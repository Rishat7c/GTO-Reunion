// Gang zone
// Created: 	7.11.2016
// Aurthor:     Gaysin Rishat
//
// Update: 11.11.16
// Переход с dini на mxINI систему
//
// Update: 13.11.16
// Обновление цвета зоны при смене цвета банды
// Команды /zone, /zonesaveall
//
// Update: 15.11.16
// Обнуление и автосохранение зон при удалении банды
//
// Update: 23.11.16
// В командах /zone && /zones вместо GangSQLID отображение Имя Банды
// Полностью переписана функция загрузки зон ZonesCheck()
// Загрузка по имени и по цвету
//
// Update: 24.11.16
// Верстка команды захвата зоны ZoneInfoAttack(playerid)
//
// Update: 27.11.16
// Добавление поиска активных банд в ZoneInfoAttack (zid1 && zid2)
//
// Update: 28.11.16
// Добавление ZoneCheck с интервалом 1 сек
// Формирование функции StartAttack
//
// Update: 29.11.16
// Изменение получения номера активного [Agressor] gangid
// Захват зоны входит в состав квеста PlayerQuest = 4
// Создание функции JoinZONE(playerid,zoneid)
// Добавление команд /zone join <ID> && /zone quit <ID>
//
// Update: 30.11.16
// Добавление RegisterQuest(name, 4);
//
// Update: 4.12.16
// Возможность захвата только ОДНОЙ зоны
//
// Update: 5.12.16
// Внесении координат спавна для каждой зоны
//
// Update: 8.12.16
// Для каждого участника добавлена проверка на активность _active
//
// Update: 17.06.17
// Создание функции PayDayZoneID()
// Расчет суммы по задолжности банды
//

#if defined _zones_included
#endinput
#endif

#define _zones_included
#pragma library zones

#include "base"
#include "utils\gtoutils"
#include "utils\dutils"
#include "utils\gtodudb"
#include "utils\dini"
#include "account"
#include "player"
#include "world"
#include "gang10"							// gang handler

forward GetGangZoneID(gangsqlid);
forward DialogPlayerZone(playerid, say);
forward DialogPlayerAllZone(playerid, say);
forward DialogPlayerKeep(playerid,amount);
forward GetPlayerGZones(playerid);
forward ZonesCommandHandler(playerid,text[]);
forward ZoneCheck();

//---------------------------------------------------- ЗАХВАТ ГАНГ ЗОН ----------------------------------------------------
#define ZONE_CHECK_TIME 1000
#define	MAX_GANG_ZONE 10 			//Количество зон
#define GANGZONE_FREE_COLOR 0xAFAFAFAA
#define FZ_ALPHA 160
#define INVALID_ZONE_ID -1
#define MAX_CP_ZONE 8
#define NOATTACK_TIME 1800
#define ContentMoney 72000

enum GangZoneInfo
{
	GangZoneID,
	GangZoneName[32],
    Float:	zMin_x,
    Float:	zMin_y,
    Float:	zMin_z,
    Float:	zMax_x,
    Float:	zMax_y,
    Float:	zMax_z,
	//Сохраняемая информация
	Zones_GangSQLID,					//	ID банды, которая владеет этой зоной, 0 = зона свободна
	Attack,
	Color,
	Owner[32],
	Active,
	Aggressor,
	Attacker,
	Waittime,
	Content
};

enum ZoneState
{
	zone_timer,
	zone_maxtimer,
	zone_playercount,
	zone_start,
	zone_questid,
	zone_gang1,
 	zone_gang2,
 	zone_endtime
}
new ZoneStats[MAX_GANG_ZONE][ZoneState];

new Float:ZoneInfo[MAX_GANG_ZONE][GangZoneInfo] =
{
	{ 0, "Las Payasadas",       -354.30,  2580.30,     2.00,  -133.60,  2816.80,   200.00,		-1,0,	GANGZONE_FREE_COLOR,"",0,-1,-1,0,0},
	{ 1, "El Quebrados",        -1645.20,  2498.50,     0.00, -1372.10,  2777.80,  200.00,		-1,0,	GANGZONE_FREE_COLOR,"",0,-1,-1,0,0},
	{ 2, "Bayside Marina",      -2741.00,  2175.10,     0.00, -2353.10,  2722.70,  200.00,		-1,0,	GANGZONE_FREE_COLOR,"",0,-1,-1,0,0},
	{ 3, "Las Barrancas",       -926.10,  1398.70,    -3.00,  -719.20,  1634.60,   200.00,		-1,0,	GANGZONE_FREE_COLOR,"",0,-1,-1,0,0},
	{ 4, "Fort Carson",         -376.20,   826.30,    -3.00,   123.70,  1220.40,   200.00,	    -1,0,	GANGZONE_FREE_COLOR,"",0,-1,-1,0,0},
	{ 5, "Palomino Creek",      2160.20,  -149.00,     0.00,  2576.90,   228.30,   200.00,		-1,0,	GANGZONE_FREE_COLOR,"",0,-1,-1,0,0},
	{ 6, "Montgomery",          1119.50,   119.50,    -3.00,  1451.40,   493.30,   200.00,		-1,0,	GANGZONE_FREE_COLOR,"",0,-1,-1,0,0},
	{ 7, "Dillimore",           580.70,  -674.80,    -9.50,   861.00,  -404.70,    200.00,		-1,0,	GANGZONE_FREE_COLOR,"",0,-1,-1,0,0},
    { 8, "Blueberry",           104.50,  -220.10,     2.30,   349.60,   152.20,    200.00,		-1,0,	GANGZONE_FREE_COLOR,"",0,-1,-1,0,0},
    { 9, "Angel Pine",         -2324.90, -2584.20,    -6.10, -1964.20, -2212.10,   200.00,		-1,0,	GANGZONE_FREE_COLOR,"",0,-1,-1,0,0}
};

new zonespawn[MAX_GANG_ZONE][MAX_CP_ZONE][CoordInfo] = {
{{-268.6963,2768.9216,61.8856},{-219.6490,2773.5513,62.6739},{-158.5154,2730.1533,62.1184},{-268.9668,2656.7827,62.6658},{-322.5651,2648.4189,63.9635},{-289.1492,2687.9919,65.8523},{-274.8121,2590.5818,63.5703},{-233.8392,2718.2029,66.8350}}, // 0 Las Payasadas
{{-1610.5510,2695.0708,55.2084},{-1549.1986,2707.1182,55.8403},{-1443.3839,2696.9663,55.8359},{-1389.3660,2657.2988,55.9655},{-1459.5201,2620.6904,55.8359},{-1423.4716,2569.4968,55.8359},{-1477.0458,2545.7183,56.2543},{-1515.5671,2518.9849,56.0703}}, // 1 El Quebrados
{{-2555.4985,2445.9185,19.4406},{-2433.3792,2510.9871,13.9610},{-2422.5286,2411.6799,13.1886},{-2416.8796,2318.3572,1.5912},{-2374.4336,2212.8030,4.9844},{-2488.0217,2225.3667,4.9844},{-2601.5515,2286.2773,7.7340},{-2535.4531,2362.1853,4.9859}}, // 2 Bayside Marina
{{-827.3353,1606.2723,27.1244},{-739.6188,1604.2795,27.1172},{-795.0759,1508.1384,22.3216},{-734.5628,1432.5813,16.3175},{-817.6215,1477.7356,19.4117},{-857.7700,1527.0925,27.0460},{-911.4188,1515.5922,25.9141},{-916.5641,1603.9115,15.4230}}, // 3 Las Barrancas
{{-220.6929,1150.4149,19.7422},{-340.9300,1180.7432,19.7355},{-368.8286,1107.6475,19.9004},{-330.7410,1038.8783,19.7422},{-243.3540,1052.1509,19.9700},{-222.9281,973.4388,22.2833},{-32.5869,1124.3032,20.2422},{-77.6768,1135.3707,19.7422}}, // 4 Fort Carson
{{2223.1147,179.9547,27.4839},{2307.5854,180.0471,27.7418},{2462.5256,142.8037,26.7790},{2567.6892,93.2833,26.9766},{2500.3264,68.1987,26.8666},{2496.5925,-42.9619,27.6139},{2432.7637,-72.8118,27.4777},{2320.5488,-54.0422,26.4766}}, // 5 Palomino Creek
{{1231.2557,305.3023,19.7212},{1239.4596,214.0001,19.5547},{1345.2661,202.9035,19.5547},{1426.2242,273.4463,19.5547},{1371.4948,363.3347,20.5474},{1297.5378,395.8468,19.5547},{1418.5270,261.1609,23.0555},{1270.2864,298.0314,19.5547}}, // 6 Montgomery
{{615.7410,-610.9721,17.2266},{658.0627,-648.2677,16.3359},{705.8061,-641.6854,16.3359},{754.0464,-588.1611,17.3359},{834.6605,-640.8968,16.3359},{815.4262,-564.2007,16.3359},{810.3512,-487.1256,17.3359},{725.8542,-448.8780,16.3437}}, // 7 Dillimore
{{252.7689,-162.9297,1.5781},{160.0874,-177.3723,1.5781},{159.0871,-107.5419,4.8965},{208.2096,-33.6188,1.5781},{210.9471,24.3082,2.5708},{271.4337,32.9911,2.4352},{307.1472,48.8137,2.8006},{334.1862,-9.4142,1.4768}}, // 8 Blueberry
{{-2075.5635,-2244.2300,31.5658},{-2008.1245,-2369.6025,30.6250},{-2083.1130,-2338.1648,30.6250},{-2069.2656,-2551.8359,30.6017},{-2139.0942,-2501.3743,30.9442},{-2184.3027,-2423.9722,30.6250},{-2234.3193,-2569.0068,31.9219},{-2257.2639,-2421.5940,31.9644}}  // 9 Angel Pine
};

new ZoneInfoDB[32] = "GTO/Zones/";

ZoneInfoLoadALL()
{
	new time = GetTickCount();
	new zonesdbname[64], dbfile;
	for(new i=0;i<MAX_GANG_ZONE;i++)
	{
		format(zonesdbname, sizeof(zonesdbname), "%sGTO.Zones.%d.rdb", ZoneInfoDB, i);
		if (!fexist(zonesdbname)) {ZoneInfoSave(i); continue;}

		dbfile = ini_openFile ( zonesdbname );
		ini_getInteger ( dbfile, "ID", 				i );
		ini_getString  ( dbfile, "Name", 			ZoneInfo[i][GangZoneName],	32 );
		ini_getInteger ( dbfile, "GangSQLID", 		ZoneInfo[i][Zones_GangSQLID] );
		ini_getInteger ( dbfile, "Attack", 			ZoneInfo[i][Attack] );
		ini_getInteger ( dbfile, "Color", 			ZoneInfo[i][Color] );
		ini_getString  ( dbfile, "Owner", 			ZoneInfo[i][Owner],	32 );
		ini_getInteger ( dbfile, "Content", 		ZoneInfo[i][Content] );

		ini_closeFile  ( dbfile );
		
		//ZoneStats[zoneid][zone_questid] = RegisterQuest(name, 4);
	}
	Zones_Init();
	
	/*new temp[MAX_STRING];
 	for (new zonedbid=0;zonedbid<MAX_GANG_ZONE;zonedbid++)
	{ 
    	if (strlen(temp) == 0) continue;
		new zoneid = RegisterDM(temp);
    	if (zoneid == INVALID_ZONE_ID) continue;
 	}*/
	
	printf("Zones > Initializaton Completed [%d ms]", GetTickCount() - time);
}

CreateGangZones()
{
	for(new i = 0; i < MAX_GANG_ZONE; i++)
	{
		ZoneInfo[i][GangZoneID] = GangZoneCreate(ZoneInfo[i][zMin_x],ZoneInfo[i][zMin_y],ZoneInfo[i][zMax_x],ZoneInfo[i][zMax_y]);
	}
}

//LoginPlayerZones(playerid)
Zones_Init()
{
    new color = 0; // тип int 32, переменная для цвета
    new query[128]; // массив int 32 чисел, строка для запроса
    // Собственно а нахуя это всё, давай в один запрос
    //new DBResult:res_color; // Переменная для результата запроса, тип DBResult
    //new DBResult:gangname; // Переменная для результата запроса, тип DBResult
    new DBResult:owner_info; // Сюда будем спрашивать у базы сразу цвет и имя владельца
    new gname[32];
    new zone_name[24];

    for(new i = 0; i < MAX_GANG_ZONE; i++) // Начинаем перебирать все зоны
    {
        // сначала читаем данные о зонах mxini, получаем ZoneInfo[i][gangsqlid]

        if(ZoneInfo[i][Zones_GangSQLID]!=-1) // если хозяин есть
        {
            format(query, sizeof(query), "SELECT name, color FROM gangs WHERE id = %d LIMIT 1", ZoneInfo[i][Zones_GangSQLID]); // Формируем запрос к базе чтобы узнать имя и цвет банды хозяина
            owner_info = xdb_query(ReunionDB, query); // делаем запрос к базе, получаем результат
            if(db_num_rows(owner_info)) // если в результате есть строки
            {
                // в результате запроса два поля, 0 - name, 1 - color, порядок согласно SELECT запросу выше
                db_get_field(owner_info, 0, gname, sizeof(gname)); // получаем из 0 поля имя банды
                color = db_get_field_int(owner_info, 1); // получаем из 1 поля результата значение, присваиваем его переменной color
            } else { // если банда с таким gangsqlid не найдена в таблице
                color = GANGZONE_FREE_COLOR; // Присваиваем цвет для ничейных зон
                format(gname, sizeof(gname), "--- Unknown Gang ---");
                // тут ещё нужно очистить ZoneInfo так как хозяин не существует, значит она ничейная
            }
            db_free_result(owner_info); // очищаем результат запроса

        } else { // если у зоны не указан хозяин
            color = GANGZONE_FREE_COLOR; // присваиваем ничейный цвет для зоны
            ZoneInfo[i][Zones_GangSQLID] = -1;
            format(gname, sizeof(gname), "--- Free ---");
            ZoneInfo[i][Content] = 0;
        }
        ZoneInfo[i][Color] = color; // Назначаем цвет зоне, который потом будем использовать в GangZoneShowForPlayer
        set(ZoneInfo[i][Owner],gname);
		//format(ZoneInfo[i][Owner], MAX_NAME( ZoneInfo[i][Owner] ), "%s", gname);
		
		printf("ZoneID: %d: | Owner: %s | GangSQLID: %d", i, ZoneInfo[i][Owner], ZoneInfo[i][Zones_GangSQLID]); // Выводим в консоль сервера
		//ZoneStats[i][zone_questid] = RegisterQuest(i, 4);
		//for(new i=0;i<MAX_TMISS;i++)
		//{
			format(zone_name, sizeof(zone_name), "Захват зоны %d");
			ZoneStats[i][zone_questid] = RegisterQuest(zone_name, 4);
		//}
    }
}

Zones_OnPlayerConnect(playerid)
{
	for(new i=0;i<MAX_GANG_ZONE;i++)
	{
      GangZoneShowForPlayer(playerid, ZoneInfo[i][GangZoneID], setcolora(ZoneInfo[i][Color], FZ_ALPHA));
	}
}

public GetGangZoneID(gangsqlid)
{
new zona = -1;
if (gangsqlid < 1) return zona;
for (new id=0;id<MAX_GANG_ZONE;id++)
	{
		if (ZoneInfo[id][Zones_GangSQLID] == gangsqlid)
		{
		zona = id;
		break;
		}

	}
	return zona;
}

forward GetGangGangID(gangid);
public GetGangGangID(gangid)
{
//new gangid;
	for (new id=0;id<MAX_GANGS;id++)
	{
		if(!Gangs[gangid][gang_active])
		{
			gangid = id;
			Gangs[id][gang_active] = true; // find first free gang slot and andd our gang
			break;
		}
	}
	return gangid;
}

stock GetGangIDFromSQLID(gangsqlid)
{
	for(new i = 0; i < MAX_GANGS; i++)
	{
		if(!(Gangs[i][gang_active])) { continue; }
		//if(GangSQLID[i] == gangsqlid) { return GangSQLID[i]; }
		if(GangSQLID[i] == gangsqlid) { return i; }
	}
	return INVALID_GANG_ID;
}

/*ZoneInfoSaveALL()
{
	for(new i=0;i<MAX_GANG_ZONE;i++)
	{
		ZoneInfoSave(i);
	}
}*/

ZoneInfoSave(i)
{
	new zonesdbname[64], dbfile;
	
	format(zonesdbname, sizeof(zonesdbname), "%sGTO.Zones.%d.rdb", ZoneInfoDB, i);

	if (!fexist(zonesdbname))
	{
		dbfile = ini_createFile ( zonesdbname );
	}
	else
	{
		dbfile = ini_openFile ( zonesdbname );
	}

    ini_setInteger ( dbfile, "ID", 			i );
	ini_setString  ( dbfile, "Name", 		ZoneInfo[i][GangZoneName] );
	ini_setInteger ( dbfile, "GangSQLID", 	ZoneInfo[i][Zones_GangSQLID] );
	ini_setInteger ( dbfile, "Attack", 		ZoneInfo[i][Attack] );
	ini_setInteger ( dbfile, "Color", 		ZoneInfo[i][Color] );
	ini_setString  ( dbfile, "Owner", 		ZoneInfo[i][Owner] );
	ini_setInteger ( dbfile, "Content", 	ZoneInfo[i][Content] );

	ini_closeFile  ( dbfile );
}

forward UpdateColor(id);
public UpdateColor(id)
{
	GangZoneShowForAll(ZoneInfo[id][GangZoneID], setcolora(ZoneInfo[id][Color], FZ_ALPHA));
}

forward SetZoneColor(id,color);
public SetZoneColor(id,color)
{
	ZoneInfo[id][Color] = color;
}

forward ZoneMakeOwnerless(id,save);
public ZoneMakeOwnerless(id,save)
{
    ZoneInfo[id][Zones_GangSQLID] = -1;
    ZoneInfo[id][Color] = GANGZONE_FREE_COLOR;
    ZoneInfo[id][Content] = 0;
    set(ZoneInfo[id][Owner],"");
    if(save){ZoneInfoSave(id);}
	return 1;
}

public ZonesCommandHandler(playerid,text[]) // комманды для зон
{
	new cmd[20];
	new idx;
	new string[MAX_STRING];
	new str2[MAX_STRING];

	set(cmd,strcharsplit(text, idx,strchar(" ")));
	if (strlen(cmd) == 0) {return 0;}
	
	if(strcomp(cmd, "/attack", true) == 1)
	{
		ZoneInfoAttack(playerid);
		return 1;
	}
	
 	if(strcomp(cmd, "/zone", true) == 1)
 	{
  		set(cmd,strcharsplit(text, idx,strchar(" ")));
     	if(strcomp(cmd, "join", true) == 1)
		{
   			new zoneid;
   			zoneid = strval(strcharsplit(text, idx,strchar(" ")));
   			if (PlayerQuest[playerid] != 0)
   			{
    			SendPlayerFormattedText(playerid, lang_texts[4][55] , 0,COLOUR_RED);
    			return 1;
   			}
   			if ((zoneid == -1) || (zoneid >= MAX_GANG_ZONE))
   			{
    			SendPlayerFormattedText(playerid, lang_texts[23][9] , 0,COLOUR_RED);
    			return 1;
   			}
   			if (ZoneInfo[zoneid][Active] == 0)
   			{
    			SendPlayerFormattedText(playerid, lang_texts[23][10] , 0,COLOUR_RED);
    			return 1;
   			}
	 		if (ZoneInfo[zoneid][Active] == 3)
			{
    			SendPlayerFormattedText(playerid, lang_texts[23][11] , 0,COLOUR_RED);
    			return 1;
   			}
			
			if ( ZoneInfo[zoneid][Active] == 1 )
			{
				new gid1 = -1;
				gid1 = GetGangIDFromSQLID( ZoneInfo[zoneid][Zones_GangSQLID] ); // Владелец
			    new gid2 = ZoneInfo[zoneid][Aggressor];
				if (PlayerGangID[playerid] == gid1)
   				{
   			    	JoinZONE(playerid,zoneid);
   			    	return 1;
   				}

				if (PlayerGangID[playerid] == gid2)
   				{
   			    	JoinZONE(playerid,zoneid);
   			    	return 1;
   				}
			}
			if( ZoneInfo[zoneid][Active] == 2 )
			{
			    new gid1 = ZoneInfo[zoneid][Attacker]; // Тот который атаковал свободную зону
			    new gid2 = ZoneInfo[zoneid][Aggressor]; // Соединяющая банда
			    
			    /*if((gid2 != -1) || (PlayerGangID[playerid] != gid2))
				{
   					ShowPlayerDialog(playerid, S_GUI_02, 0,"Меню Територии","Одна из банд уже присоединилась к захвату зоны!","ОК","");
   					return 1;
				}*/
				if((gid2 == -1) && (gid1 == PlayerGangID[playerid]))
				{
					ShowPlayerDialog(playerid, S_GUI_02, 0,"Меню Територии","Ни одна из банд не приняла заявку \nВы не можете присоединиться к захвату","ОК","");
   					return 1;
				}
				if(gid2 == -1)
				{
				    new gangid = PlayerGangID[playerid];
					ZoneInfo[zoneid][Aggressor] = PlayerGangID[playerid];
					JoinZONE(playerid,zoneid);
					format(string,sizeof(string),"[GANG ZONE] {FFFFFF}Банда {%06x}%s {FFFFFF}выступила участником в захвате зоны {AAAAAA}%s",Gangs[gangid][gang_colour] >>> 8,Gangs[gangid][gang_name],ZoneInfo[zoneid][GangZoneName]);
  					SendClientMessageToAll(COLOR_LIGHTBLUE,string);
					format(str2,sizeof(str2),"[GANG ZONE] {FFFFFF}Члены банды могут присоединиться командой {AAAAAA}'/zone join %d'",zoneid);
  					SendGangMessage(gid2,str2,COLOR_LIGHTBLUE);
					return 1;
				}
				if(PlayerGangID[playerid] == gid1)
				{
					JoinZONE(playerid,zoneid);
   					return 1;
				}
				if(PlayerGangID[playerid] == gid2)
				{
					JoinZONE(playerid,zoneid);
   					return 1;
				}
			}
   			//JoinZONE(playerid,zoneid);
       		return 1;
  		}
		if((strcomp(cmd, "leave", true) == 1) || (strcomp(cmd, "quit", true) == 1))
  		{
   			if (PlayerQuest[playerid] == 0)
   			{
    			SendPlayerFormattedText(playerid, lang_texts[23][15] , 0,COLOUR_RED);
    			return 1;
   			}
   			new zoneid = GetPlayerZONE(playerid);
			if (zoneid == -1)
   			{
    			SendPlayerFormattedText(playerid, lang_texts[23][15] , 0,COLOUR_RED);
    			return 1;
   			}
   			PlayerLeaveZONE(playerid,zoneid);
       		return 1;
  		}
		if(strcomp(cmd, "info", true) == 1)
  		{
			DialogPlayerZone(playerid, 1);
       		return 1;
  		}
		if(strcomp(cmd, "all", true) == 1)
  		{
			DialogPlayerAllZone(playerid,1);
       		return 1;
  		}
		if(strcomp(cmd, "keep", true) == 1)
  		{
  		    new gangid = PlayerGangID[playerid];
   			new zoneid;
			zoneid = strval(strcharsplit(text, idx,strchar(" ")));
			new amount;
			amount = strval(strcharsplit(text, idx,strchar(" ")));
			if((zoneid < 0) || (zoneid >= MAX_GANG_ZONE))
			{
				ShowPlayerDialog(playerid, S_GUI_02, 0,"Меню Територии","Неверный ИД зоны","ОК","");
				return 1;
			}
			if((amount <= 0) || amount > ContentMoney)
			{
				ShowPlayerDialog(playerid, S_GUI_02, 0,"Меню Територии","Введите корректную сумму","ОК","");
				return 1;
			}
			if(gangid == -1)
			{
    			ShowPlayerDialog(playerid, S_GUI_02, 0,"Меню Територии","Вы НЕ в банде!","ОК","");
				return 1;
			}
			if(ZoneInfo[zoneid][Content] == 0)
			{
			    ShowPlayerDialog(playerid, S_GUI_02, 0,"Меню Територии","Содержание зоны и так равна 0!","ОК","");
			    return 1;
			}
			if(ZoneInfo[zoneid][Zones_GangSQLID] == PlayerGangSQLID[playerid]) // Здесь заполнить всю обрбаботку команды
			{
	    		if(oGetPlayerMoney(playerid) >= amount) // Узнаем имеется ли у игрока столько денег
	    		{
	    		    new stat = 0;
	    		    stat = ZoneInfo[zoneid][Content] - amount;
					if(stat <= 0) {
					    ZoneInfo[zoneid][Content] = 0;
					} else {
						ZoneInfo[zoneid][Content] = ZoneInfo[zoneid][Content] - amount;
					}
					oGivePlayerMoney(playerid, -amount, 1);
					format(string, sizeof(string),  lang_texts[23][18] , ZoneInfo[zoneid][GangZoneName]);
					SendClientMessage(playerid, COLOUR_MONEY_GOOD, string);
	    		}
			} else {
				ShowPlayerDialog(playerid, S_GUI_02, 0,"Меню Територии","Это территория принадлежит не Вашей банде","ОК","");
			}
       		return 1;
  		}
	}
	
	return 0;
}
//---------------------------------------------------- КОНЕЦ ЗАХВАТА ----------------------------------------------------

public GetPlayerGZones(playerid) // получить ид зоны в которой игрок стоит
{
	new Float:PCoord[3];
	GetPlayerPos(playerid,PCoord[0],PCoord[1],PCoord[2]);

	new zone = -1;

	for(new z=0;z<MAX_GANG_ZONE;z++)
	{
		if(PCoord[0] > ZoneInfo[z][zMax_x]){continue;}
		if(PCoord[1] > ZoneInfo[z][zMax_y]){continue;}
		if(PCoord[0] < ZoneInfo[z][zMin_x]){continue;}
		if(PCoord[1] < ZoneInfo[z][zMin_y]){continue;}
		zone = z; break;
	}

	return zone;
}

public DialogPlayerZone(playerid, say) // диалог игроку - инфо зоны
{
	new zone = GetPlayerGZones(playerid);
	if (zone == -1)
	{
		if(say)
		{
			ShowPlayerDialog(playerid, S_GUI_02, 0,"Меню Територии","Вы НЕ находитесь на территории!","ОК","");
		}
		return 0;
	}

    new zname[256];
	if(ZoneInfo[zone][Zones_GangSQLID] != -1)
	{
		format(zname,sizeof(zname),"{FFFFFF}Владелец:\n[ {%06x}%s{FFFFFF} ]\n\n{FFFFFF}Задолженность: {FF0000}$ %d:%d",ZoneInfo[zone][Color] >>> 8,ZoneInfo[zone][Owner],ZoneInfo[zone][Content],ContentMoney);
	}
	else
	{
		format(zname,sizeof(zname),"{FFFFFF}Сейчас никому не принадлежит");
	}

	new zstr[512];
	format(zstr,sizeof(zstr),
		"{FFFFFF}Название:\n[ {1ad900}%s{FFFFFF} ID %d ]\n\n%s",
		ZoneInfo[zone][GangZoneName], zone, zname);

	ShowPlayerDialog(playerid, S_GUI_02, 0,"Меню Территории",zstr,"ОК","");
	return 1;
}

public DialogPlayerAllZone(playerid, say) // диалог игроку - инфо о всех зонах
{
new list[1024]; format(list, 32, "ID\tИмя зоны\tВладелец\tСодержание\n");
for (new i=0;i<MAX_GANG_ZONE;)
{
	if(ZoneInfo[i][Zones_GangSQLID] != -1)
	{
		format(list,sizeof(list),"%s\n %d\t%s\t{%06x}%s\t{FF0000}$ %d из %d\n",list, i, ZoneInfo[i][GangZoneName],ZoneInfo[i][Color] >>> 8,ZoneInfo[i][Owner],ZoneInfo[i][Content],ContentMoney);
	}
	else
	{
		format(list,sizeof(list),"%s\n %d\t%s\t{C0C0C0}Отсутствует\n",list, i, ZoneInfo[i][GangZoneName]);
	}
	i++;
}
ShowPlayerDialog(playerid, S_GUI_02, DIALOG_STYLE_TABLIST_HEADERS, "Меню Территории", list, "ОК", "");
}
//---------------------------------------------------------------- РЕГИСТРАЦИЯ ЗАХВАТА -------------------------------------------------------------

GetZoneQuestID(zoneid)
{
 return ZoneStats[zoneid][zone_questid];
}

ZoneInfoAttack(playerid)
{
	new string[MAX_STRING];
	new str2[MAX_STRING];
	new gangid = PlayerGangID[playerid];
	
	if(gangid == -1)
	{
    	ShowPlayerDialog(playerid, S_GUI_02, 0,"Меню Територии","Вы НЕ в банде!","ОК","");
		return 1;
	}

	if (PlayerQuest[playerid] != 0)
	{
		SendPlayerFormattedText(playerid, lang_texts[4][55] , 0,COLOUR_RED);
		return 1;
	}

	//if ( GangMembers[gangid][0][member_sqlid] != PlayerSQLID[playerid])
	//{ // player is not leader of this gang
    //    ShowPlayerDialog(playerid, S_GUI_02, 0,"Меню Територии","Вы должны быть лидером банды!","ОК","");
	//	return 1;
	//}

	new zone = GetPlayerGZones(playerid);
	if (zone == -1)
	{
		ShowPlayerDialog(playerid, S_GUI_02, 0,"Меню Територии","Вы НЕ находитесь на территории!","ОК","");
		return 0;
	}

	if(ZoneInfo[zone][Attack])
	{
		ShowPlayerDialog(playerid,S_GUI_02,0,"Захват Территорий","Эта территория уже атакована!","ОК","");
		return 1;
	}

	if(ZoneInfo[zone][Zones_GangSQLID] == PlayerGangSQLID[playerid]) // если есть владелец, то у него преимущество.
	{
	    ShowPlayerDialog(playerid, S_GUI_02, 0,"Меню Територии","Это Ваша территория!","ОК","");
	    return 1;
	}
	
	new timenow = gettime();
	new tmp[128];

	if(ZoneInfo[zone][Waittime] > timenow)
	{
		format(tmp, sizeof(tmp),"Вы не можете нападать на эту территорию еще %d секунд",ZoneInfo[zone][Waittime] - timenow);
		ShowPlayerDialog(playerid,S_GUI_02,0,"Захват Территорий",tmp,"ОК","");
		return 1;
	}
	
	for(new zi=0; zi<MAX_GANG_ZONE; zi++)
	{
		if((ZoneInfo[zi][Active] == 1) || (ZoneInfo[zi][Active] == 2) || (ZoneInfo[zi][Active] == 3))
		{
		    ShowPlayerDialog(playerid, S_GUI_02, 0,"Меню Територии","Нельзя параллельно захватывать несколько зон","ОК","");
		    return 1;
		}
		//return 1;
	}
	
	new ggid = -1;
	ggid = GetGangIDFromSQLID( ZoneInfo[zone][Zones_GangSQLID] );
	//printf("GANGID: The number is %d",ggid);  //-> GangSQLID при хозяина зоны
	
	if ( GangMembers[gangid][0][member_sqlid] == PlayerSQLID[playerid] || PlayerSQLID[playerid] == Gangs[gangid][gang_zam])
	{ // player is not leader of this gang
	
	if(ZoneInfo[zone][Zones_GangSQLID] != -1)
	{
		if(ggid == -1)
		{
	    	ShowPlayerDialog(playerid, S_GUI_02, 0,"Меню Територии","Членов этой банды нету в On-line!","ОК","");
	    	return 1;
		}
        ZoneStats[zone][zone_gang2] = 0;
        ZoneStats[zone][zone_gang1] = 0;
		format(string,sizeof(string),"[GANG ZONE] {%06x}%s {FFFFFF}начинает войну c {%06x}%s{FFFFFF} в зоне {%06x}%s.",Gangs[gangid][gang_colour] >>> 8, Gangs[gangid][gang_name],ZoneInfo[zone][Color] >>> 8, ZoneInfo[zone][Owner],ZoneInfo[zone][Color] >>> 8,ZoneInfo[zone][GangZoneName]);
  		SendClientMessageToAll(COLOR_LIGHTBLUE,string);
		format(str2,sizeof(str2),"[GANG ZONE] {FFFFFF}Члены банды могут присоединиться командой {AAAAAA}'/zone join %d'",zone);
  		SendGangMessage(PlayerGangID[playerid],str2,COLOR_LIGHTBLUE);
  		//SendGangMessage(PlayerGangID[playerid],"[GANG ZONE] {FFFFFF}Члены банды могут присоединиться командой {AAAAAA}'/zone join %d'",COLOR_LIGHTBLUE);
  		SendGangMessage(ggid,str2,COLOR_LIGHTBLUE);
  		ZoneInfo[zone][Active] = 1;
  		ZoneInfo[zone][Aggressor] = PlayerGangID[playerid];
  		JoinZONE(playerid,zone);
 	} else {
    	format(string,sizeof(string),"[GANG ZONE] {%06x}%s {FFFFFF}начинает войну в зоне {%06x}%s.",Gangs[gangid][gang_colour] >>> 8, Gangs[gangid][gang_name],ZoneInfo[zone][Color] >>> 8,ZoneInfo[zone][GangZoneName]);
  		SendClientMessageToAll(COLOR_LIGHTBLUE,string);
		format(str2,sizeof(str2),"[GANG ZONE] {FFFFFF}Желающие банды могут присоединиться командой {AAAAAA}'/zone join %d'",zone);
  		SendClientMessageToAll(COLOR_LIGHTBLUE,str2);
  		ZoneInfo[zone][Active] = 2;
  		ZoneInfo[zone][Aggressor] = PlayerGangID[playerid];
  		JoinZONE(playerid,zone);
	}
    } else {
        ShowPlayerDialog(playerid, S_GUI_02, 0,"Меню Територии","Вы должны быть лидером/зам.лидером банды!","ОК","");
    }
    return 1;
}

// Секундный таймер захвата
public ZoneCheck()
{
    new string[MAX_STRING];
	for(new z=0; z<MAX_GANG_ZONE; z++)
	{
		//gid2 = GetGangIDFromSQLID( ZoneInfo[z][Aggressor] ); // Агрессор
		
		if(ZoneInfo[z][Active] == 1) // если зона под атакой
		{
			new gid1 = -1;
			gid1 = GetGangIDFromSQLID( ZoneInfo[z][Zones_GangSQLID] ); // Владелец
			new gid2 = ZoneInfo[z][Aggressor];
			
			//printf("000 --> Zone[z][Active] GANGID | %d | %d", gid1, gid2);
		    ZoneStats[z][zone_timer]++;

      		if ((ZoneStats[z][zone_timer] == 30) || (ZoneStats[z][zone_timer] == 50))
     		{
      			format(string, sizeof(string), "[GANG ZONE] Захват зоны начнется через %d секунд" , 60-ZoneStats[z][zone_timer]);
                SendGangMessage(gid1,string,COLOR_LIGHTBLUE);
                SendGangMessage(gid2,string,COLOR_LIGHTBLUE);
     		}
		    
			if(ZoneStats[z][zone_timer] == 60)
			{
 				StartAttack(z);
   				ZoneStats[z][zone_timer] = 0;
			}
		}
		if(ZoneInfo[z][Active] == 2)
		{
  			new gid1 = ZoneInfo[z][Attacker]; // Тот который атаковал свободную зону
		   	new gid2 = ZoneInfo[z][Aggressor]; // Соединяющая банда
		   	
  			ZoneStats[z][zone_timer]++;
  			
      		if ((ZoneStats[z][zone_timer] == 30) || (ZoneStats[z][zone_timer] == 60))
     		{
      			format(string, sizeof(string), "[GANG ZONE] Захват зоны начнется через %d секунд" , 90-ZoneStats[z][zone_timer]);
                SendGangMessage(gid1,string,COLOR_LIGHTBLUE);
                SendGangMessage(gid2,string,COLOR_LIGHTBLUE);
     		}
			if(ZoneStats[z][zone_timer] == 90)
			{
 				StartAttack(z);
   				ZoneStats[z][zone_timer] = 0;
			}
		}
		if(ZoneInfo[z][Active] == 3)
		{
		    ZoneStats[z][zone_maxtimer]++;
			if(ZoneStats[z][zone_maxtimer] == 300)
			{
  				EndAttack(z);
 				ZoneStats[z][zone_maxtimer] = 0;
			}
		}
		
	}
}

StartAttack(zoneid)
{
	new string[MAX_STRING];
	ZoneStats[zoneid][zone_timer] = 0;
	if(ZoneInfo[zoneid][Zones_GangSQLID] != -1)
	{
		// Добавить код выйгрыша
		//new gid1 = -1;
		//gid1 = GetGangIDFromSQLID( ZoneInfo[zoneid][Zones_GangSQLID] ); // Владелец
		new gid2 = ZoneInfo[zoneid][Aggressor]; // Тот который атаковал
		if(ZoneStats[zoneid][zone_gang1] == 0)
		{
		//new gid2 = ZoneInfo[zoneid][Aggressor]; // Соединяющая банда
		SetZoneColor(zoneid,Gangs[gid2][gang_colour]);
		UpdateColor(zoneid);
		ZoneInfo[zoneid][Zones_GangSQLID] = GangSQLID[gid2];
 		set(ZoneInfo[zoneid][Owner],Gangs[gid2][gang_name]);
		format(string,sizeof(string),"[GANG ZONE] {%06x}%s {FFFFFF}новый владелец зоны %s",Gangs[gid2][gang_colour] >>> 8,Gangs[gid2][gang_name],ZoneInfo[zoneid][GangZoneName]);
		SendClientMessageToAll(COLOR_LIGHTBLUE,string);
		//
		ZoneStats[zoneid][zone_timer] = 0;
		ZoneInfo[zoneid][Active] = 0;
		ZoneInfo[zoneid][Attacker] = 0;
		ZoneInfo[zoneid][Aggressor] = 0;
  		ZoneStats[zoneid][zone_gang2] = 0;
        ZoneStats[zoneid][zone_gang1] = 0;
   		for (new playerid=0; playerid<MAX_PLAYERS;playerid++)
		{
  			if (!IsPlayerConnected(playerid)) continue;
  			if (PlayerQuest[playerid] != GetZoneQuestID(zoneid)){continue;}
  			ResetQuest(playerid);
		}
		return 1;
		}
	} else {
	if( ZoneStats[zoneid][zone_gang2] == 0 || ZoneStats[zoneid][zone_gang1] == 0)
	{
		format(string,sizeof(string),"[GANG ZONE] {FFFFFF}Все забили на захват зоны %s",ZoneInfo[zoneid][GangZoneName]);
		SendClientMessageToAll(COLOR_LIGHTBLUE,string);
		ZoneStats[zoneid][zone_timer] = 0;
		ZoneInfo[zoneid][Active] = 0;
		ZoneInfo[zoneid][Attacker] = 0;
		ZoneInfo[zoneid][Aggressor] = 0;
  		ZoneStats[zoneid][zone_gang2] = 0;
        ZoneStats[zoneid][zone_gang1] = 0;
   		for (new playerid=0; playerid<MAX_PLAYERS;playerid++)
		{
  			if (!IsPlayerConnected(playerid)) continue;
  			if (PlayerQuest[playerid] != GetZoneQuestID(zoneid)){continue;}
  			ResetQuest(playerid);
		}
		return 1;
	}
	}
	
	if(ZoneInfo[zoneid][Active] == 1)
	{
		new gid1 = -1;
		gid1 = GetGangIDFromSQLID( ZoneInfo[zoneid][Zones_GangSQLID] ); // Владелец
		new gid2 = ZoneInfo[zoneid][Aggressor];
		for (new playerid=0; playerid<MAX_PLAYERS;playerid++)
		{
  			if (!IsPlayerConnected(playerid)) continue;
			if (PlayerQuest[playerid] == GetZoneQuestID(zoneid)) // if player is in this dm
			{
				ZONEPlayerStats[playerid][zone_player_active] = 1;
				if(PlayerGangID[playerid] == gid1)
				{
 					new cpid = random(MAX_CP_ZONE);
   					oSetPlayerVirtualWorld(playerid,zoneid+50);// Виртуальный мир
     				SetPlayerWorldBounds(playerid,ZoneInfo[zoneid][zMax_x],ZoneInfo[zoneid][zMin_x],ZoneInfo[zoneid][zMax_y],ZoneInfo[zoneid][zMin_y]);
      				SetPlayerPosEx(playerid,zonespawn[zoneid][cpid][Coord_X], zonespawn[zoneid][cpid][Coord_Y], zonespawn[zoneid][cpid][Coord_Z]);
				}
				if(PlayerGangID[playerid] == gid2)
				{
 					new cpid = random(MAX_CP_ZONE);
   					oSetPlayerVirtualWorld(playerid,zoneid+50);// Виртуальный мир
     				SetPlayerWorldBounds(playerid,ZoneInfo[zoneid][zMax_x],ZoneInfo[zoneid][zMin_x],ZoneInfo[zoneid][zMax_y],ZoneInfo[zoneid][zMin_y]);
      				SetPlayerPosEx(playerid,zonespawn[zoneid][cpid][Coord_X], zonespawn[zoneid][cpid][Coord_Y], zonespawn[zoneid][cpid][Coord_Z]);
				}
			}
		}
		ZoneInfo[zoneid][Active] = 3;
	}
	
	if(ZoneInfo[zoneid][Active] == 2)
	{
		new gid1 = ZoneInfo[zoneid][Attacker]; // Тот который атаковал свободную зону
   		new gid2 = ZoneInfo[zoneid][Aggressor]; // Соединяющая банда
   		
		if( gid2 == -1)
		{
			format(string,sizeof(string),"[GANG ZONE] {FFFFFF}Никто не присоединился к захвату зоны %s",ZoneInfo[zoneid][GangZoneName]);
			SendClientMessageToAll(COLOR_LIGHTBLUE,string);
			ZoneStats[zoneid][zone_timer] = 0;
    		ZoneInfo[zoneid][Active] = 0;
   			ZoneInfo[zoneid][Attacker] = 0;
			ZoneInfo[zoneid][Aggressor] = 0;
   			ZoneStats[zoneid][zone_gang2] = 0;
        	ZoneStats[zoneid][zone_gang1] = 0;
    	   	for (new playerid=0; playerid<MAX_PLAYERS;playerid++)
			{
  				if (!IsPlayerConnected(playerid)) continue;
  				if (PlayerQuest[playerid] != GetZoneQuestID(zoneid)){continue;}
  				ResetQuest(playerid);
			}
			return 1;
		}
		for (new playerid=0; playerid<MAX_PLAYERS;playerid++)
		{
  			if (!IsPlayerConnected(playerid)) continue;
			if (PlayerQuest[playerid] == GetZoneQuestID(zoneid)) // if player is in this dm
			{
				ZONEPlayerStats[playerid][zone_player_active] = 1;
				if(PlayerGangID[playerid] == gid1)
				{
 					new cpid = random(MAX_CP_ZONE);
   					oSetPlayerVirtualWorld(playerid,zoneid+50);// Виртуальный мир
     				SetPlayerWorldBounds(playerid,ZoneInfo[zoneid][zMax_x],ZoneInfo[zoneid][zMin_x],ZoneInfo[zoneid][zMax_y],ZoneInfo[zoneid][zMin_y]);
      				SetPlayerPosEx(playerid,zonespawn[zoneid][cpid][Coord_X], zonespawn[zoneid][cpid][Coord_Y], zonespawn[zoneid][cpid][Coord_Z]);
				}
				if(PlayerGangID[playerid] == gid2)
				{
 					new cpid = random(MAX_CP_ZONE);
   					oSetPlayerVirtualWorld(playerid,zoneid+50);// Виртуальный мир
     				SetPlayerWorldBounds(playerid,ZoneInfo[zoneid][zMax_x],ZoneInfo[zoneid][zMin_x],ZoneInfo[zoneid][zMax_y],ZoneInfo[zoneid][zMin_y]);
      				SetPlayerPosEx(playerid,zonespawn[zoneid][cpid][Coord_X], zonespawn[zoneid][cpid][Coord_Y], zonespawn[zoneid][cpid][Coord_Z]);
				}
			}
		}
		ZoneInfo[zoneid][Active] = 3;
	}
	
	new countpl = 0;
	countpl = ZoneStats[zoneid][zone_gang1] + ZoneStats[zoneid][zone_gang2];
	format(string,sizeof(string),"[GANG ZONE] {FFFFFF}Захват за зону {%06x}%s {FFFFFF}начался. Игроков: %d",ZoneInfo[zoneid][Color] >>> 8,ZoneInfo[zoneid][GangZoneName],countpl);
	SendClientMessageToAll(COLOR_LIGHTBLUE,string);
	return 1;
}

EndAttack(zoneid)
{
	if(ZoneInfo[zoneid][Attacker] != -1)
	{
		new gid1 = ZoneInfo[zoneid][Attacker]; // Тот который атаковал свободную зону
   		new gid2 = ZoneInfo[zoneid][Aggressor]; // Соединяющая банда
     	if(ZoneStats[zoneid][zone_gang1] > ZoneStats[zoneid][zone_gang2] && ZoneStats[zoneid][zone_gang1] != 0) // Если выйгрывает агрессор
    	{
			SetZoneColor(zoneid,Gangs[gid1][gang_colour]);
			UpdateColor(zoneid);
			ZoneInfo[zoneid][Zones_GangSQLID] = GangSQLID[gid1];
			set(ZoneInfo[zoneid][Owner],Gangs[gid1][gang_name]);
    	}

		if(ZoneStats[zoneid][zone_gang2] >= ZoneStats[zoneid][zone_gang1] && ZoneStats[zoneid][zone_gang2] != 0) // Если выйгрывает хозяин
		{
			SetZoneColor(zoneid,Gangs[gid2][gang_colour]);
			UpdateColor(zoneid);
			ZoneInfo[zoneid][Zones_GangSQLID] = GangSQLID[gid2];
        	set(ZoneInfo[zoneid][Owner],Gangs[gid2][gang_name]);
		}
	}
	else
	{
		new gid1 = -1;
		gid1 = GetGangIDFromSQLID( ZoneInfo[zoneid][Zones_GangSQLID] ); // Владелец
		new gid2 = ZoneInfo[zoneid][Aggressor];
  		if(ZoneStats[zoneid][zone_gang1] >= ZoneStats[zoneid][zone_gang2] && ZoneStats[zoneid][zone_gang1] != 0) // Если выйгрывает хозяин
    	{
			SetZoneColor(zoneid,Gangs[gid1][gang_colour]);
			UpdateColor(zoneid);
			ZoneInfo[zoneid][Zones_GangSQLID] = GangSQLID[gid1];
			set(ZoneInfo[zoneid][Owner],Gangs[gid1][gang_name]);
    	}

		if(ZoneStats[zoneid][zone_gang2] > ZoneStats[zoneid][zone_gang1] && ZoneStats[zoneid][zone_gang2] != 0) // Если выйгрывает агрессор
		{
			SetZoneColor(zoneid,Gangs[gid2][gang_colour]);
			UpdateColor(zoneid);
			ZoneInfo[zoneid][Zones_GangSQLID] = GangSQLID[gid2];
        	set(ZoneInfo[zoneid][Owner],Gangs[gid2][gang_name]);
		}
	}
	
	ZoneStats[zoneid][zone_maxtimer] = 0;

    ZoneInfo[zoneid][Waittime] = gettime() + NOATTACK_TIME;

	//printf("002 --> EndAttack() | %d | %s", zoneid, ZoneInfo[zoneid][GangZoneName]);

    ZoneInfo[zoneid][Active] = 0;
   	for (new playerid=0; playerid<MAX_PLAYERS;playerid++)
	{
  		if (!IsPlayerConnected(playerid)) continue;
  		if (PlayerQuest[playerid] != GetZoneQuestID(zoneid)){continue;}
  		ResetQuest(playerid);
  		oSetPlayerVirtualWorld(playerid,0);// Виртуальный мир
    	player_Spawn(playerid);
    	SetPlayerServerWorldBounds(playerid);
    	ZONEPlayerStats[playerid][zone_player_active] = 0;
	}
	
	ZoneInfoSave(zoneid);
    
	new string[MAX_STRING];
	format(string,sizeof(string),"[GANG ZONE] {%06x}%s {FFFFFF}захватил зону {%06x}%s", ZoneInfo[zoneid][Color] >>> 8, ZoneInfo[zoneid][Owner], ZoneInfo[zoneid][Color] >>> 8,ZoneInfo[zoneid][GangZoneName]);
	SendClientMessageToAll(COLOR_LIGHTBLUE,string);
	ZoneInfo[zoneid][Attacker] = 0;
	ZoneInfo[zoneid][Aggressor] = 0;
}

JoinZONE(playerid,zoneid)
{
    new string[MAX_STRING];
    if (ZoneInfo[zoneid][Active] == 1)
	{
		new gid1 = -1;
		gid1 = GetGangIDFromSQLID( ZoneInfo[zoneid][Zones_GangSQLID] ); // Владелец
		new gid2 = ZoneInfo[zoneid][Aggressor];
	
		if (PlayerGangID[playerid] == gid1)
		{
	 		format(string,sizeof(string),"[GANG ZONE] {FFFFFF}Член банды %s присоединился к захвату",oGetPlayerName(playerid));
			SendGangMessage(gid1, string, COLOR_LIGHTBLUE);
			ZoneStats[zoneid][zone_gang1]++;
		}
		if (PlayerGangID[playerid] == gid2)
		{
	    	format(string,sizeof(string),"[GANG ZONE] {FFFFFF}Член банды %s присоединился к захвату",oGetPlayerName(playerid));
			SendGangMessage(gid2, string, COLOR_LIGHTBLUE);
			ZoneStats[zoneid][zone_gang2]++;
		}
		GameTextForPlayer(playerid, "~w~Zone War ~g~Entered",3000,6);
	
		PlayerQuest[playerid] = GetZoneQuestID(zoneid);
	
 		if (ZoneInfo[zoneid][Active] == 1)
 		{
  			format(string, sizeof(string),  lang_texts[23][13] ,(60 - ZoneStats[zoneid][zone_timer]));
   			SendPlayerFormattedText(playerid, string, 0, COLOR_LIGHTBLUE);
 		}
	}
	
 	if (ZoneInfo[zoneid][Active] == 2)
	{
 		new gid1 = ZoneInfo[zoneid][Attacker]; // Тот который атаковал свободную зону
   		new gid2 = ZoneInfo[zoneid][Aggressor]; // Соединяющая банда
		if(PlayerGangID[playerid] == gid1)
	    {
 	 		format(string,sizeof(string),"[GANG ZONE] {FFFFFF}Член банды %s присоединился к захвату",oGetPlayerName(playerid));
			SendGangMessage(gid1, string, COLOR_LIGHTBLUE);
			ZoneStats[zoneid][zone_gang1]++;
	    }
   		if(PlayerGangID[playerid] == gid2)
	    {
 	 		format(string,sizeof(string),"[GANG ZONE] {FFFFFF}Член банды %s присоединился к захвату",oGetPlayerName(playerid));
			SendGangMessage(gid2, string, COLOR_LIGHTBLUE);
			ZoneStats[zoneid][zone_gang2]++;
	    }
   		GameTextForPlayer(playerid, "~w~Zone War ~g~Entered",3000,6);

		PlayerQuest[playerid] = GetZoneQuestID(zoneid);
		
		if (ZoneInfo[zoneid][Active] == 1)
 		{
  			format(string, sizeof(string),  lang_texts[23][13] ,(90 - ZoneStats[zoneid][zone_timer]));
   			SendPlayerFormattedText(playerid, string, 0, COLOR_LIGHTBLUE);
 		}
	}
}

GetPlayerZONE(playerid)
{
 if (!IsPlayerConnected(playerid)) return 0;
 for (new zoneid=0; zoneid<MAX_GANG_ZONE;zoneid++)
 {
     if (ZoneInfo[zoneid][Active] == 0) continue;
     if (PlayerQuest[playerid] == GetZoneQuestID(zoneid)) // if player is in this zone
     {
         return zoneid;
  }
 }
 return 0;
}

ZONEPlayerDisconnect(playerid)
{
 	new zoneid = GetPlayerZONE(playerid);
 	if (zoneid == INVALID_ZONE_ID) return;

	PlayerLeaveZONE(playerid,zoneid);
	oSetPlayerVirtualWorld(playerid,0);// Виртуальный мир
	SetPlayerServerWorldBounds(playerid);
}

PlayerLeaveZONE(playerid,zoneid)
{
    GameTextForPlayer(playerid, "~w~Zone War ~r~Aborted",5000,6);
    
    if (ZoneInfo[zoneid][Active] == 1)
	{
   		new gid1 = -1;
		gid1 = GetGangIDFromSQLID( ZoneInfo[zoneid][Zones_GangSQLID] ); // Владелец
		new gid2 = ZoneInfo[zoneid][Aggressor];
    
    	ZONEPlayerStats[playerid][zone_player_active] = 0;
    
    	new string[MAX_STRING];
		format(string, sizeof(string),  lang_texts[23][14] , oGetPlayerName(playerid));
		if(PlayerGangID[playerid] == gid1)
		{
			SendGangMessage(gid1, string, COLOR_GREY);
			SetPlayerServerWorldBounds(playerid);
			oSetPlayerVirtualWorld(playerid,0);// Виртуальный мир
			ZoneStats[zoneid][zone_gang1]--;
		}
		if(PlayerGangID[playerid] == gid2)
		{
			SendGangMessage(gid2, string, COLOR_GREY);
			SetPlayerServerWorldBounds(playerid);
			oSetPlayerVirtualWorld(playerid,0);// Виртуальный мир
			ZoneStats[zoneid][zone_gang2]--;
		}
	}
 	if (ZoneInfo[zoneid][Active] == 2)
	{
		new gid1 = ZoneInfo[zoneid][Attacker]; // Тот который атаковал свободную зону
   		new gid2 = ZoneInfo[zoneid][Aggressor]; // Соединяющая банда
   		
    	ZONEPlayerStats[playerid][zone_player_active] = 0;

    	new string[MAX_STRING];
		format(string, sizeof(string),  lang_texts[23][14] , oGetPlayerName(playerid));
		if(PlayerGangID[playerid] == gid1)
		{
			SendGangMessage(gid1, string, COLOR_GREY);
			SetPlayerServerWorldBounds(playerid);
			oSetPlayerVirtualWorld(playerid,0);// Виртуальный мир
			ZoneStats[zoneid][zone_gang1]--;
		}
		if(PlayerGangID[playerid] == gid2)
		{
			SendGangMessage(gid2, string, COLOR_GREY);
			SetPlayerServerWorldBounds(playerid);
			oSetPlayerVirtualWorld(playerid,0);// Виртуальный мир
			ZoneStats[zoneid][zone_gang2]--;
		}
	}
	if(ZoneInfo[zoneid][Active] == 3)
 	{
 	    new string[MAX_STRING];
 		new gid1 = -1;
    	if(ZoneInfo[zoneid][Zones_GangSQLID] == -1)
		{
			gid1 = ZoneInfo[zoneid][Attacker];
    	} else {
			gid1 = GetGangIDFromSQLID( ZoneInfo[zoneid][Zones_GangSQLID] );
    	}
    	new gid2 = ZoneInfo[zoneid][Aggressor];
		if(PlayerGangID[playerid] == gid1)
		{
			SendGangMessage(gid1, string, COLOR_GREY);
			SetPlayerServerWorldBounds(playerid);
			oSetPlayerVirtualWorld(playerid,0);// Виртуальный мир
			ZoneStats[zoneid][zone_gang1]--;
			player_Spawn(playerid);
			ZONEPlayerStats[playerid][zone_player_active] = 0;
		}
		if(PlayerGangID[playerid] == gid2)
		{
			SendGangMessage(gid2, string, COLOR_GREY);
			SetPlayerServerWorldBounds(playerid);
			oSetPlayerVirtualWorld(playerid,0);// Виртуальный мир
			ZoneStats[zoneid][zone_gang2]--;
			player_Spawn(playerid);
			ZONEPlayerStats[playerid][zone_player_active] = 0;
		}
 	}
    ResetQuest(playerid);
}

IsPlayerInAnyZONE(playerid)
{
	new zoneid = GetPlayerZONE(playerid);
	if (zoneid == INVALID_ZONE_ID) return 0;
 	if (ZONEPlayerStats[playerid][zone_player_active] == 0) return 0;
 	return 1;
}

forward OnPlayerZONEKill(playerid,victimid,weaponid);
public OnPlayerZONEKill(playerid,victimid,weaponid)
{
	Player[playerid][Kills]++;
}

forward OnPlayerZONEDeath(playerid,killerid);
public OnPlayerZONEDeath(playerid,killerid)
{
 	Player[playerid][Deaths]++;
 	
 	if (oGetPlayerHealth(killerid) > 100)
 	{
       KickPlayer(killerid,"Недопустимая величина здоровья. (чит?)");
 	}

 	new zoneid = GetPlayerZONE(playerid);

	new gid1 = -1;
    if(ZoneInfo[zoneid][Zones_GangSQLID] == -1)
	{
		gid1 = ZoneInfo[zoneid][Attacker];
    } else {
		gid1 = GetGangIDFromSQLID( ZoneInfo[zoneid][Zones_GangSQLID] );
    }
    new gid2 = ZoneInfo[zoneid][Aggressor];

 	if(ZoneInfo[zoneid][Active] == 3)
 	{
 	    if(PlayerGangID[playerid] == gid1)
 	    {
 			ZoneStats[zoneid][zone_gang1]--;
		}
		if(PlayerGangID[playerid] == gid2)
		{
 			ZoneStats[zoneid][zone_gang2]--;
		}
		
		if(ZoneStats[zoneid][zone_gang1] <= 0) // gang1 = gid1 Хозяин
		{
		    EndAttack(zoneid);
			// Присвоение зоны выйграшной банде gid2
		}
		if(ZoneStats[zoneid][zone_gang2] <= 0) // gang2 = gid2 Агрессор
		{
		    EndAttack(zoneid);
			// рисвоение зоны выйграшной банде gid1
		}
 	}
	ResetQuest(playerid);
	oSetPlayerVirtualWorld(playerid,0);// Виртуальный мир
	player_Spawn(playerid);
	SetPlayerServerWorldBounds(playerid);
	ZONEPlayerStats[playerid][zone_player_active] = 0;
}

forward PayDayZoneID();
public PayDayZoneID() {
	for(new z=0; z<MAX_GANG_ZONE; z++)
	{
		if(ZoneInfo[z][Zones_GangSQLID] != -1)
		{
            ZoneInfo[z][Content] += 1000;
            if(ZoneInfo[z][Content] >= ContentMoney)
            {
                new string[MAX_STRING];
                ZoneMakeOwnerless(z,1);
				UpdateColor(z);
		 		format(string, sizeof(string),lang_texts[23][16],ZoneInfo[z][GangZoneName],z);
	 			SendClientMessageToAll(COLOUR_WHITE, string);
	 			ZoneInfo[z][Content]=0;
            }
            ZoneInfoSave(z);
     	}
	}
}


