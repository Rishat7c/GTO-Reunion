#include "industrial"

#define MAX_TBASE 30 // максимум точек
#define MAX_GOODS 10 // максимум товаров
#define MAX_TMISS 20 // максимум миссий

#define MAX_MLIFE 600 // максимальное время жизни активной миссии до регенерации
#define UPD_MISST 1000 // шаг синхронизации торговых миссий в миллисекндах

new Truck_Resp = (MAX_MLIFE*UPD_MISST) / 1000;
new TRADE_LEVEL = 5;		// Бесплатные грузы для < 5 уровня

#define T_DZSIZE 35 // половина ширины торговой гангзоны на карте, в метрах

#define MAX_TSPEED 15 // теоретическая средняя скорость движения грузовика с прицепом, метры в секунду

#define TIME_DISPERSION 20 //разброс +- по времени при генерации миссии (проценты)

#define COLOR_TRADE 0xBE6700FF // торговый цвет

forward IsPlayerAtTradeCP(playerid);
forward OnPlayerEnterTradeCheckpoint(playerid);
forward TradeInit();
forward TradePlayerHelp(playerid);
forward TradePlayerHelp2(playerid);
forward PlayerGetTradeMission(playerid,list);
forward HalfPriceTrade(playerid);
forward IsPlayerInIndustrialTruck(playerid);
forward OnPlayerReadyToEnterTCP(playerid,tid);
forward TradeSync();
forward SendTruckMissionList(playerid,trpoint);
forward trade_OnPlayerSC(playerid, newstate, oldstate);
forward trade_OnPlayerConnect(playerid);
forward trade_OnVehicleDeath(vehicleid);
forward IsPlayerAtGS(playerid);
forward SetCarNitro(playerid);
forward SendMessageToTraders(color, message[]);

forward trade_OnPlayerEnterRaceCP(playerid);
forward PlayerJoinTradeMission( playerid );

enum VehiclesType{
train_race,
train_indus1,
train_indus2,
train_indus3,
train_indus4
}
new TrainingVehicle[MAX_PLAYERS][VehiclesType];

/*
#define MAX_TCOLORLEVELS 20

new TColorTime[MAX_TCOLORLEVELS+1] = { // цвета для 3ДТекста над прицепами
0x40ff00FF,
0x54ff00FF,
0x68ff00FF,
0x7cff00FF,
0x90ff00FF,

0xa4ff00FF,
0xb8ff00FF,
0xccff00FF,
0xe0ff00FF,
0xf4ff00FF,

0xfff600FF,
0xffe200FF,
0xffce00FF,
0xffba00FF,
0xffa600FF,

0xff9200FF,
0xff7e00FF,
0xff6a00FF,
0xff5600FF,
0xff4200FF,

0xFFFFFFFF
};

*/
#define MAX_TCOLORLEVELS 20

enum t_col_lvl { col_code[8], lvl_str[64] }

new TColorTime[MAX_TCOLORLEVELS+1][t_col_lvl] = {

{"48E3FE","••••••••••••••••••••"},
{"48E3FE","•••••••••••••••••••{404040}•"},
{"48E3FE","••••••••••••••••••{404040}••"},
{"48E3FE","•••••••••••••••••{404040}•••"},
{"77FA18","••••••••••••••••{404040}••••"},
{"77FA18","•••••••••••••••{404040}•••••"},
{"77FA18","••••••••••••••{404040}••••••"},
{"77FA18","•••••••••••••{404040}•••••••"},
{"faf800","••••••••••••{404040}••••••••"},
{"faf800","•••••••••••{404040}•••••••••"},
{"faf800","••••••••••{404040}••••••••••"},
{"faf800","•••••••••{404040}•••••••••••"},
{"FBB113","••••••••{404040}••••••••••••"},
{"FBB113","•••••••{404040}•••••••••••••"},
{"FBB113","••••••{404040}••••••••••••••"},
{"FBB113","•••••{404040}•••••••••••••••"},
{"f81818","••••{404040}••••••••••••••••"},
{"f81818","•••{404040}•••••••••••••••••"},
{"f81818","••{404040}••••••••••••••••••"},
{"f81818","•{404040}•••••••••••••••••••"},

{"FFFFFF","[ Время вышло :: Конец миссии через %d с ]"}
};

/*
{"48E3FE","{404040}[ {%s}IIII IIII IIII IIII IIII {404040}]"},
{"46E1FF","{404040}[ {%s}IIII IIII IIII IIII III{404040}I ]"},
{"50E6D5","{404040}[ {%s}IIII IIII IIII IIII II{404040}II ]"},
{"66F06F","{404040}[ {%s}IIII IIII IIII IIII I{404040}III ]"},

{"79FA18","{404040}[ {%s}IIII IIII IIII IIII{404040} IIII ]"},
{"77FA18","{404040}[ {%s}IIII IIII IIII III{404040}I IIII ]"},
{"76F91A","{404040}[ {%s}IIII IIII IIII II{404040}II IIII ]"},
{"AEFA0F","{404040}[ {%s}IIII IIII IIII I{404040}III IIII ]"},

{"E6FB03","{404040}[ {%s}IIII IIII IIII{404040} IIII IIII ]"},
{"FFFD00","{404040}[ {%s}IIII IIII III{404040}I IIII IIII ]"},
{"FDFF00","{404040}[ {%s}IIII IIII II{404040}II IIII IIII ]"},
{"FBEF02","{404040}[ {%s}IIII IIII I{404040}III IIII IIII ]"},

{"FBCC0B","{404040}[ {%s}IIII IIII{404040} IIII IIII IIII ]"},
{"FBB113","{404040}[ {%s}IIII III{404040}I IIII IIII IIII ]"},
{"FAAA12","{404040}[ {%s}IIII II{404040}II IIII IIII IIII ]"},
{"FB7E0D","{404040}[ {%s}IIII I{404040}III IIII IIII IIII ]"},

{"FC5308","{404040}[ {%s}IIII{404040} IIII IIII IIII IIII ]"},
{"FD2703","{404040}[ {%s}III{404040}I IIII IIII IIII IIII ]"},
{"FE0000","{404040}[ {%s}II{404040}II IIII IIII IIII IIII ]"},
{"FF0000","{404040}[ {%s}I{404040}III IIII IIII IIII IIII ]"},
*/

new TColorZone[5] = { // цвета для торговых гангзон
0x00DD00CC, // магаз
0x0000FFCC, // склад
0xe34affCC, // керосин
0xe4ff00CC, // бензин АЗС
0xFF0000CC // красная отметка
};


new TBases[MAX_TBASE][CoordInfo] = { // координаты точек
//--- склады
{-1733.6309,175.0736,4.1320},
{-571.9905,-489.1039,26.1052},
{1043.5076,2114.0459,11.3907},
{2849.9995,921.2489,11.3349},
{2212.5657,-2225.5959,14.1151},
//--- магазины
{-217.1450,-243.2974,1.9994},
{-532.8221,2592.3806,53.9798},
{1610.8645,2317.7671,11.4015},
{2290.9534,2791.0852,11.4121},
{2474.8145,-2618.6760,14.2341},
//--- керосин
{-1157.96,-178.21,14.14},
{245.9205,2561.3994,16.7153},
{1560.0996,1620.0078,11.83},
{2081.65,-2224.50,13.54},
//--- бензин
	{2109.2126,917.5845,10.8203},
	{2640.1831,1103.9224,10.8203},
	{611.8934,1694.7921,6.7193},
	{-1327.5398,2682.9771,49.7896},
	{-2413.7427,975.9317,45.0031},
	{-1672.3597,414.2950,6.8866},
	{-2244.1365,-2560.6294,31.6276},
	{-1603.0166,-2709.3589,48.2419},
	{1939.3275,-1767.6813,13.2787},
	{-94.7651,-1174.8079,1.9979},
	{1381.6699,462.6467,19.8540},
	{657.8167,-559.6507,16.0630},
	{-1478.2916,1862.8318,32.3617},
	{2147.3054,2744.9377,10.5263},
	{2204.9602,2480.3494,10.5278},
	{1590.9493,2202.2637,10.5247}
};

new TBasesName[MAX_TBASE][32] = { // имена точек... Надо им нормальные имена придумать!
"Easter Docs",
"Fallen Tree",
"White Wood Estates",
"Linden Side",
"Los Santos Logistics",
//---
"Blue Berry Factory",
"Las Payasdas Shop",
"Redsands Terminal",
"Spiny Bed",
"Ocean Docs",
//---
"San Fierro Airport",
"Aircraft Graveyard",
"Las Venturas Airport",
"Los Santos Airport",
//---
"Conroe - I",
"Allendale - II",
"Wolfdale - III",
"Kentsfield - IV",
"Yorkfield - V",
"Clarkdale - VI",
"Lynnfield - VII",
"Bloomfield - VIII",
"Gulftown - IX",
"Reunion - X",
"Madison - XI",
"Hondo - XII",
"Deerfield - XIII",
"Montecito - XIV",
"Montvale - XV",
"McKinley - XVI"
};

new TBasesZone[MAX_TBASE]; // торговые ганг-зоны

new TForSell[MAX_TBASE] = {1,1,1,1,1,	0,0,0,0,0,	2,2,2,2,	3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3}; //статический конфиг точек: 1 склады, 0 магазины

enum mission_info {
status, //0 - waiting, 1 - deliver in process
origin, // id of base - sklad
dest, // id of destination point (base or shop)
Float:path,
Float:compass,
good, // id tovara
timelife, // life of mission, to reset
time, // min time to delive
price, // nagrada
keepup, // zalog
deliverman, // player sqlid
truckid,
Float:truckh,
questid
}

new TradeMissions[MAX_TMISS][mission_info]; // динамический конфиг миссий

enum good_info {
g_name[24],
Float:g_par,
g_truck_type
}

#define Truck_A 450 //для металлолома сыпучка открытый
#define Truck_B 591 //белый крытый укорочен чуть рефрежиратор
#define Truck_C 584 //цистерна

#define Truck_L1 403 //linerunner speed 122
#define Truck_L2 514 //tanker speed 134
#define Truck_L3 515 //roadtrane speed 158

new TradeGoods[MAX_GOODS][good_info] = { // статический конфиг товаров
{"Строймат.",				1.0,	Truck_A},
{"Бензин",					1.1,	Truck_C}, // особые параметры при генерации миссии
{"Древесина",				1.2,	Truck_A},
{"Медикам.",				1.3,	Truck_B},
{"Быт. хим.",				1.4,	Truck_B},
{"Запчасти",				1.5,	Truck_B},
{"Продукты",				1.6,	Truck_B},
{"Техника",					1.7,	Truck_B},
{"Керосин",					1.8,	Truck_C}, // особые параметры при генерации мисии
{"Груз Х",					3.0,	Truck_B}
};

new TradeLOGO[64] = "::: ДАЛЬНОБОЙЩИКИ 2.0 :::";

new HelpInfo[2][1280];

new Trade3DTS = 1; // разрешение на 3Дтексты
 
new Text3D:Trade3DT[MAX_TMISS]; // 3ДТексты для прицепов

new Trader[MAX_PLAYERS];

#define TRADE_ICON_ID 99
#define TRADE_ICON_MARKER 42

//new TradeMapIcon[MAX_PLAYERS];

#define NITROPRICE 500

//--------------------------------------------------------------------------------------
/*
UpdateTrade3DT(missid) // только для активных миссий!!!! Обновляет 3ДТекст над прицепом
{
new temp[255];

new Float:destan, Float:X, Float:Y, Float:Z;
GetVehiclePos(TradeMissions[missid][truckid], X,Y,Z);

destan = GetPointDistanceToPointEx(X,Y,Z,TBases[ TradeMissions[missid][dest] ][Coord_X],TBases[ TradeMissions[missid][dest] ][Coord_Y],TBases[ TradeMissions[missid][dest] ][Coord_Z]);

new timeost;
new timestr[48];
new color;
timeost = TradeMissions[missid][time]-TradeMissions[missid][timelife];
if(timeost >= 0)
{
format(timestr,sizeof(timestr),"Осталось времени: %d s",timeost);
new cmx = (TradeMissions[missid][timelife]*MAX_TCOLORLEVELS)/TradeMissions[missid][time];
color = TColorTime[cmx];
}
else
{
format(timestr,sizeof(timestr),"Время вышло! Завершение миссии через: %d s",MAX_MLIFE - TradeMissions[missid][timelife]);
color = 0xFFFFFFFF;
}

format(temp,sizeof(temp),"Груз: %s\nПункт назначения: %s [id %d]\n%s\nРасстояние: %0.2f км\nЦена: %d $",TradeGoods[ TradeMissions[missid][good] ][g_name],TBasesName[ TradeMissions[missid][dest] ],TradeMissions[missid][dest],timestr,destan/1000,TradeMissions[missid][price] );

Update3DTextLabelText(Trade3DT[missid], color, temp);
}
*/
UpdateTrade3DT(missid) // только для активных миссий!!!! Обновляет 3ДТекст над прицепом
{
new temp[255];

new Float:destan, Float:X, Float:Y, Float:Z;
GetVehiclePos(TradeMissions[missid][truckid], X,Y,Z);

destan = GetPointDistanceToPointEx(X,Y,Z,TBases[ TradeMissions[missid][dest] ][Coord_X],TBases[ TradeMissions[missid][dest] ][Coord_Y],TBases[ TradeMissions[missid][dest] ][Coord_Z]);

new timeost;
new timestr[128];
//new levelstr[64];
new color;
color = 0xFFFFFFFF;
timeost = TradeMissions[missid][time]-TradeMissions[missid][timelife];
if(timeost > 0)
{
new cmx = (TradeMissions[missid][timelife]*MAX_TCOLORLEVELS)/TradeMissions[missid][time];
//format(levelstr,sizeof(levelstr),TColorTime[cmx][lvl_str],TColorTime[cmx][col_code]);
format(timestr,sizeof(timestr),"Время: {%s}%d с\n%s",TColorTime[cmx][col_code],timeost,TColorTime[cmx][lvl_str]);
}
else
{
format(timestr,sizeof(timestr),TColorTime[MAX_TCOLORLEVELS][lvl_str],MAX_MLIFE - TradeMissions[missid][timelife]);
}

format(temp,sizeof(temp),"Груз: %s\n> %s [id %d]\nРасстояние: %0.2f км\nЦена: %d $\n\n%s",TradeGoods[ TradeMissions[missid][good] ][g_name],TBasesName[ TradeMissions[missid][dest] ],TradeMissions[missid][dest],destan/1000,TradeMissions[missid][price], timestr);

//TradeMissions[missid][truckh]
Update3DTextLabelText(Trade3DT[missid], color, temp);
}


//--------------------------------------------------------------------------------------

public TradePlayerHelp(playerid) //помощь
{
ShowPlayerDialog(playerid,CGUI+10,0,TradeLOGO,HelpInfo[0],"ОК","Часть 2");
return 1;
}

public TradePlayerHelp2(playerid) //помощь II
{
ShowPlayerDialog(playerid,CGUI+9,0,TradeLOGO,HelpInfo[1],"ОК","Часть 1");
return 1;
}

//--------------------------------------------------------------------------------------

public PlayerGetTradeMission(playerid,list) // игрок выбрал миссию из списка в диалоге, строка списка равна list
{
if(list < 0) {return ShowPlayerDialog(playerid,CGUI+9,0,TradeLOGO,"ОШИБКА\n- - -\nНеверно выбран пункт меню...","ОК","Инфо");}
new point = -1;
point = IsPlayerAtTradeCP(playerid); // определяем, на точке ли игрок
if(point == -1) {return ShowPlayerDialog(playerid,CGUI+9,0,TradeLOGO,"ОШИБКА\n- - -\nВы далеко от маркера...","ОК","Инфо");}
new count = 0;
new missid = -1;
new tempstr[128];
new mhead[MAX_STRING];

for(new i=0;i<MAX_TMISS;i++) // цикл сопоставляет выбранную строку диалога с ИД миссии, получаем ИД миссии
{
	if(point == TradeMissions[i][origin])
	{
		if(list == count)
		{
			missid = i;
			break;
		}
		else
		{
			count++;
		}

	}
}

// если миссия не найдена
if(missid == -1) {return ShowPlayerDialog(playerid,CGUI+9,0,TradeLOGO,"ОШИБКА\n- - -\nМиссия не найдена...","ОК","Инфо");}

if(TradeMissions[missid][status] != 0) { // если миссия уже активна
new delid = PlayerSQLID2ID(TradeMissions[missid][deliverman]); // получаем ид доставщика из SQLID
if(delid != -1) // если такой игрок есть на сервере
{
format(tempstr,sizeof(tempstr),"СКЛАД - %s - [ID %d]\n- - -\nЭту миссию уже получил игрок %s [id %d], вы не можете ее выбрать!",TBasesName[point],point,oGetPlayerName(delid),delid);
}
else
{
format(tempstr,sizeof(tempstr),"СКЛАД - %s - [ID %d]\n- - -\nЭта миссия уже активна, вы не можете ее выбрать!",TBasesName[point],point);
}
return ShowPlayerDialog(playerid,CGUI+9,0,TradeLOGO,tempstr,"ОК","Инфо");}

if(GetPlayerLevel(playerid) > TRADE_LEVEL)
{
	if(GetPlayerMoney(playerid) < TradeMissions[missid][keepup]) // если не хватает чтоб внести залог
	{
		format(tempstr,sizeof(tempstr),"СКЛАД - %s - [ID %d]\n- - -\nУ Вас недостаточно денег чтобы внести залог, надо %d $",TBasesName[point],point,TradeMissions[missid][keepup]);
		return ShowPlayerDialog(playerid,CGUI+9,0,TradeLOGO,tempstr,"ОК","Инфо");
	}
	//return 1;
}

if(!IsPlayerInIndustrialTruck(playerid)) { // если игрок не в грузовике
format(mhead,sizeof(mhead),"СКЛАД - %s - [ID %d]\n- - -\nВы должны быть в грузовике!",TBasesName[point],point);
return ShowPlayerDialog(playerid,CGUI+9,0,TradeLOGO,mhead,"ОК","Инфо");}

if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) // Если игрок не водитель
{ return 1; }

new misstrailer = GetVehicleTrailer(GetPlayerVehicleID(playerid)); // узнаем ид прицепа

if(misstrailer == 0) { // если нет прицепа
format(mhead,sizeof(mhead),"СКЛАД - %s - [ID %d]\n- - -\nВы должны быть в грузовике с прицепом!",TBasesName[point],point);
return ShowPlayerDialog(playerid,CGUI+9,0,TradeLOGO,mhead,"ОК","Инфо");}

new trmod = GetVehicleModel(misstrailer); // узнаем модель прицепа

if(!IsValidTrailer(trmod)) // разрешена ли такая модель?
{
format(mhead,sizeof(mhead),"СКЛАД - %s - [ID %d]\n- - -\nДанный тип прицепа не используется в системе!",TBasesName[point],point);
ShowPlayerDialog(playerid,CGUI+9,0,TradeLOGO,mhead,"ОК","Инфо");
return 1;
}

if(trmod != TradeGoods[ TradeMissions[missid][good] ][g_truck_type]) // можно ли в такой модели прицепа возить этот товар
{
format(mhead,sizeof(mhead),"СКЛАД - %s - [ID %d]\n- - -\nДля этой миссии нужен прицеп другого типа!",TBasesName[point],point);
ShowPlayerDialog(playerid,CGUI+9,0,TradeLOGO,mhead,"ОК","Инфо");
return 1;
}

//SetVehicleParamsForPlayer(misstrailer, playerid, 1, 0);
//SetVehicleParamsEx(misstrailer, 0, 0, 0, 1, 0, 0, 0);
PlayerQuest[playerid] = TradeMissions[missid][questid];

oSetPlayerRaceCheckpoint(playerid,	2, 	TBases[ TradeMissions[missid][dest] ][Coord_X],
										TBases[ TradeMissions[missid][dest] ][Coord_Y],
										TBases[ TradeMissions[missid][dest] ][Coord_Z],
										TBases[ TradeMissions[missid][dest] ][Coord_X],
										TBases[ TradeMissions[missid][dest] ][Coord_Y],
										TBases[ TradeMissions[missid][dest] ][Coord_Z], 8);
SetPlayerMapIcon(playerid, TRADE_ICON_ID,	TBases[ TradeMissions[missid][dest] ][Coord_X],
											TBases[ TradeMissions[missid][dest] ][Coord_Y],
											TBases[ TradeMissions[missid][dest] ][Coord_Z],
											TRADE_ICON_MARKER, -1, 1);

if(GetPlayerLevel(playerid) > TRADE_LEVEL)
{
	oGivePlayerMoney(playerid, -TradeMissions[missid][keepup],0); // берем залог
}

SendPlayerFormattedText(playerid, "Миссия по доставке начата!", 0,COLOR_TRADE);

TradeMissions[missid][status] = 1; // миссия теперь активна
TradeMissions[missid][deliverman] = PlayerSQLID[playerid];
TradeMissions[missid][truckid] = misstrailer;

if(Player[playerid][train1] == 1)
{
ShowPlayerDialog(playerid, S_GUI_02, 0,"Подсказка","Следуй по значку 'Т' на карте \n Время и километраж отображается на цистерне \nУдачного пути, друг мой!","ОК","");
}

//GangZoneShowForPlayer(playerid, TBasesZone[ TradeMissions[missid][dest] ], TColorZone[4]); // красная торговая гангзона

if(Trade3DTS) // если разрешены 3Дтексты, цепляем его к прицепу
{
Trade3DT[missid] = Create3DTextLabel( "Dalnoboy", COLOR_TRADE, 0.000, 0.000, 10000.000, 50.000, 0, 0);
Attach3DTextLabelToVehicle( Trade3DT[missid], TradeMissions[missid][truckid], 0.000, 0.000, 1.000);
UpdateTrade3DT(missid);
}

return 1;
}

//--------------------------------------------------------------------------------------

HalfPriceTrade(playerid) // продажа за половину цены
{

if (!IsPlayerInIndustrialTruck(playerid))
{SendPlayerFormattedText(playerid, "Вы должны быть в грузовике С ПРИЦЕПОМ!!!", 0,COLOR_TRADE); return 0;}

new trid = GetVehicleTrailer(GetPlayerVehicleID(playerid));
if(trid == 0)
{SendPlayerFormattedText(playerid, "Вы должны быть в грузовике С ПРИЦЕПОМ!!!", 0,COLOR_TRADE); return 0;}

new trcheck = -1;
for(new i=0;i<MAX_TMISS;i++) // Ищем, используется ли прицеп в миссиях, получаем ид миссии
{
if(trid == TradeMissions[i][truckid]) {trcheck = i; break;}
}

if(trcheck == -1) {SendPlayerFormattedText(playerid, "Этот прицеп уже не используется в миссиях!!!", 0,COLOR_TRADE); return 0;}

oDisablePlayerRaceCheckpoint(playerid);
RemovePlayerMapIcon(playerid, TRADE_ICON_ID );
ResetQuest(playerid);
SendPlayerFormattedText(playerid, "Получите награду за доставку!!!", 0,COLOR_TRADE);
oGivePlayerMoney(playerid, (TradeMissions[trcheck][price]/2), 1);
new xpprice;
xpprice = floatround( TradeGoods[ TradeMissions[trcheck][good] ][g_par]*(Player[playerid][Level]+1)*60 );
GivePlayerXP(playerid, xpprice, 1);

GenerateTradeMission(trcheck,1,1,3); //регенерируем миссию
return 1;
}

//--------------------------------------------------------------------------------------

// В маркере ли игрок? возвращает ид торговой точки, если игрок в маркере
public IsPlayerAtTradeCP(playerid) {
for (new id=0;id<MAX_TBASE;id++)
{ if (oIsPlayerInCheckpoint(playerid,TBases[id][Coord_X],TBases[id][Coord_Y],TBases[id][Coord_Z],20)) { return id; } }
return -1; }

//--------------------------------------------------------------------------------------

IsValidTrailer(trmod) // Правильный ли прицеп??
{
if(trmod == Truck_A || trmod == Truck_B || trmod == Truck_C) {return 1;}
return 0;
}

//--------------------------------------------------------------------------------------
//crushtype | 0 - NA | 1 - time lost | 2 - crush trailer
GenerateTradeMission(missid,sayforall,del3dt,crushtype) // Генератор торговых миссий
{

if(Trade3DTS) // если запрешены 3Дтексты
{
	if(del3dt) // если надо удалить 3Дтекст миссии
	{
	Delete3DTextLabel(Trade3DT[missid]);
	}
}

TradeMissions[missid][status] = 0; // статус - ожидание

TradeMissions[missid][good] = random(MAX_GOODS); // рандомно выбираем товар
new rnddest = -1;

if(TradeMissions[missid][good] == 1) // если груз - бензин
{ rnddest = minrand(14,MAX_TBASE); } // рандомно выбираем пункт назначения из 16 бензоколонок
else if(TradeMissions[missid][good] == 8) // если груз - керосин
{ rnddest = minrand(10,14); } // рандомно выбираем пункт назначения из 4 аэропортов
else  // если груз - не керосин не бензин
{
rnddest = random(10); // рандомно выбираем пункт назначения из 5 складов + 5 магазинов

if(rnddest == TradeMissions[missid][origin])
{
if(rnddest > 0){rnddest--;}
else {rnddest++;}
}
}

TradeMissions[missid][dest] = rnddest;

TradeMissions[missid][path] = GetPointDistanceToPointEx(TBases[ TradeMissions[missid][origin] ][Coord_X],TBases[ TradeMissions[missid][origin] ][Coord_Y],TBases[ TradeMissions[missid][origin] ][Coord_Z],TBases[ TradeMissions[missid][dest] ][Coord_X],TBases[ TradeMissions[missid][dest] ][Coord_Y],TBases[ TradeMissions[missid][dest] ][Coord_Z]);
// находим расстояние до пункта назначения

TradeMissions[missid][compass] = AnglePointToPoint(TBases[ TradeMissions[missid][origin] ][Coord_X],TBases[ TradeMissions[missid][origin] ][Coord_Y],TBases[ TradeMissions[missid][dest] ][Coord_X],TBases[ TradeMissions[missid][dest] ][Coord_Y]);
// находим угол-направление (азимут) на точку назначения

TradeMissions[missid][timelife] = 0; // время жизни равно нулю

new Float:timedispersion = minrand(100-TIME_DISPERSION,100+TIME_DISPERSION+1)/100.00; // разброс по времени
//printf("Miss %d | TDisp %f",missid,timedispersion);
TradeMissions[missid][time] = floatround( (TradeMissions[missid][path]/MAX_TSPEED)*timedispersion ); // ищем минимальное время доставки

TradeMissions[missid][price] = floatround( floatpower((TradeMissions[missid][path]/TradeMissions[missid][time]),2)*TradeGoods[ TradeMissions[missid][good] ][g_par]*25 ); // 175
// считаем награду

TradeMissions[missid][keepup] = floatround( TradeGoods[ TradeMissions[missid][good] ][g_par]*TradeMissions[missid][time]*400 ); // 500
// считаем залог

// учет коротких дистанций, добавочное время на повороты и торможения
if(TradeMissions[missid][path] < 200){TradeMissions[missid][time] += 20;}
else if(TradeMissions[missid][path] < 400){TradeMissions[missid][time] += 15;}
else if(TradeMissions[missid][path] < 600){TradeMissions[missid][time] += 10;}

TradeMissions[missid][deliverman] = 0; // SQLID доставщика ставим равное нулю

TradeMissions[missid][truckid] = -1; // ИД прицепа который используется в миссии равное -1

if(sayforall) // если требуется оповестить всех
{
new tstr[256];
new times, timem;
timem = TradeMissions[missid][time]/MIN_SEC;
times = TradeMissions[missid][time] - timem*MIN_SEC;
format(tstr,sizeof(tstr),"Точке '%s' [ID %d] в требуется водитель для доставки груза '%s' [расстояние %.2f km | время %d минут %d секунд]",TBasesName[TradeMissions[missid][origin]], TradeMissions[missid][origin], TradeGoods[ TradeMissions[missid][good] ][g_name], TradeMissions[missid][path]/1000, timem, times);
//SendClientMessageToAll(COLOR_TRADE, tstr);
SendMessageToTraders(COLOR_TRADE, tstr);

switch(crushtype)
{
	case 1: { format(tstr,sizeof(tstr), "ТОРГОВАЯ МИССИЯ\n- - -\nВремя миссии истекло!"); }
	case 2: { format(tstr,sizeof(tstr), "ТОРГОВАЯ МИССИЯ ПРОВАЛЕНА\n- - -\nГруз уничтожен!"); }
	case 3: { format(tstr,sizeof(tstr), "ТОРГОВАЯ МИССИЯ ЗАВЕРШЕНА\n- - -\nГруз был доставлен!"); }
	default: { format(tstr,sizeof(tstr), "ТОРГОВАЯ МИССИЯ ЗАВЕРШЕНА\n- - -\nНеизвестная причина завершения!"); }
}

for(new i = 0; i < MAX_PLAYERS; i++)
{
	if( PlayerQuest[i] == TradeMissions[missid][questid] )
	{
		oDisablePlayerRaceCheckpoint(i);
		RemovePlayerMapIcon(i, TRADE_ICON_ID );
		ResetQuest(i);
		ShowPlayerDialog(i, S_GUI_02, 0, TradeLOGO,tstr,"ОК","");
	}
}

}

}

//--------------------------------------------------------------------------------------

public TradeSync() // синхронизация торговых миссий
{
	for(new i=0;i<MAX_TMISS;i++)
	{
		if(!TradeMissions[i][status]) {continue;} // если миссия ждет, то не трогать ее
			
			if(TradeMissions[i][timelife] >= MAX_MLIFE) // если миссия уже отжила свое время
			{
				/*
				new playerid = PlayerSQLID2ID(TradeMissions[i][deliverman]); // получаем ид игрока из его SQLID
				if(playerid != -1) // если такой игрок есть на сервере
					{
					ShowPlayerDialog(playerid,CGUI+9,0,TradeLOGO,"МИССИЯ\n- - -\nВремя миссии истекло!","ОК","Инфо");
					
					if(IsPlayerInIndustrialTruck(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER) // если игрок за рулем грузовика
					{
					GangZoneShowForPlayer(playerid, TBasesZone[i], TColorZone[TForSell[TradeMissions[i][dest]]] ); // показываем гангзону		
					}
					
					ResetQuest(playerid);
					
					}
				*/
				GenerateTradeMission(i,1,1,1); // регенерируем миссию, и говорим всем об этом, и удаляем 3Дтекст
			}
			else // а если не отжила еще
			{
				TradeMissions[i][timelife]++; // прибавим 1 к времени жизни
				
//------------------- Добавил после обнаружения бага в OnVehickeDeath ---------- START
/*				
				GetVehicleHealth(TradeMissions[i][truckid],TradeMissions[i][truckh]);
				
				if(TradeMissions[i][truckh] < 250)
				{
					new playerid = PlayerSQLID2ID(TradeMissions[i][deliverman]); // получаем ид игрока из его SQLID
					
					if(playerid != -1) // если такой игрок есть на сервере
					{
						ShowPlayerDialog(playerid,CGUI+9,0,TradeLOGO,"МИССИЯ ПРОВАЛЕНА\n- - -\nГруз серьезно поврежден!","ОК","Инфо");
					
						if(IsPlayerInIndustrialTruck(playerid)
						&& GetPlayerState(playerid) == PLAYER_STATE_DRIVER) // если игрок за рулем грузовика
						{
							GangZoneShowForPlayer(playerid, TBasesZone[i], TColorZone[TForSell[TradeMissions[i][dest]]] ); // показываем гангзону		
						}
					}
			
				GenerateTradeMission(i,1,1); // регенерируем миссию, и говорим всем об этом, и удаляем 3Дтекст
				continue;
				}
*/			
//------------------- Добавил после обнаружения бага в OnVehickeDeath ---------- END
				
				if(Trade3DTS) // если разрешены 3ДТексты
				{
				UpdateTrade3DT(i); // обновить 3Дтекст миссии i
				}
			}
		
	}
}

//--------------------------------------------------------------------------------------

public TradeInit()
{
	
	//sizeof( HelpInfo[0] )

	format(HelpInfo[0],1280,"ИНФОРМАЦИЯ (1/2)\n- - -\n\n%s\n%s\n\t%s\n\t%s\n\t%s\n\t%s\n\n%s\n%s\n\t%s\n\t%s\n\t%s\n\t%s\n%s\n%s",lang_texts[21][2],lang_texts[21][3],lang_texts[21][4],lang_texts[21][5],lang_texts[21][6],lang_texts[21][7],lang_texts[21][8],lang_texts[21][9],lang_texts[21][10],lang_texts[21][11],lang_texts[21][12],lang_texts[21][13],lang_texts[21][14],lang_texts[21][15]);
	
	format(HelpInfo[1],1280,"ИНФОРМАЦИЯ (2/2)\n- - -\n\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n\n%s\n%s\n%s\n%s\n%s\n\n%s\n%s\n%s",lang_texts[21][16],lang_texts[21][17],lang_texts[21][18],lang_texts[21][19],lang_texts[21][20],lang_texts[21][21],lang_texts[21][22],lang_texts[21][23],lang_texts[21][24],lang_texts[21][25],lang_texts[21][26],lang_texts[21][27],lang_texts[21][28],lang_texts[21][29],lang_texts[21][30],lang_texts[21][31],lang_texts[21][32]);
	
	for (new i=0;i<MAX_TBASE;i++)
	{
		AddActiveCheckpoint(TBases[i][Coord_X],TBases[i][Coord_Y],TBases[i][Coord_Z],100,8);
		if(TForSell[i] == 1){CreateStreamMapIcon( 51, TBases[i][Coord_X],TBases[i][Coord_Y],TBases[i][Coord_Z]);}
		TBasesZone[i] = GangZoneCreate(TBases[i][Coord_X]-T_DZSIZE, TBases[i][Coord_Y]-T_DZSIZE, TBases[i][Coord_X]+T_DZSIZE, TBases[i][Coord_Y]+T_DZSIZE);
		GangZoneHideForAll(TBasesZone[i]);
	}
	
	new miss_name[24];
	
	for(new i=0;i<MAX_TMISS;i++)
	{
		TradeMissions[i][origin] = (i/4);
		GenerateTradeMission(i,0,0,0);
		format(miss_name, sizeof(miss_name), "Торговая Миссия %d");
		TradeMissions[i][questid] = RegisterQuest(miss_name, 3);
	}
	
	SetTimer("TradeSync",UPD_MISST,1);

// --- склад 0 ---
AddStaticVehicleEx(Truck_L3,-1721.647460,154.509826,4.576739,180.000,-1,-1,never);
AddStaticVehicleEx(Truck_L2,-1738.220947,92.352470,5.573369,45.000,-1,-1,never);
AddStaticVehicleEx(Truck_B,-1714.220947,116.352470,5.575515,45.000,-1,-1,Truck_Resp);
AddStaticVehicleEx(Truck_B,-1720.220947,110.352470,5.573369,45.000,-1,-1,Truck_Resp);
AddStaticVehicleEx(Truck_A,-1726.220947,104.352470,5.573369,45.000,-1,-1,Truck_Resp);
AddStaticVehicleEx(Truck_C,-1732.220947,98.352470,5.573369,45.000,-1,-1,Truck_Resp);

// --- склад 1 ---
AddStaticVehicleEx(Truck_B,-607.904602,-497.401397,27.547872,270.000,-1,-1,Truck_Resp);
AddStaticVehicleEx(Truck_B,-607.904602,-492.401397,27.547872,270.000,-1,-1,Truck_Resp);
AddStaticVehicleEx(Truck_A,-607.904602,-487.401397,27.547872,270.000,-1,-1,Truck_Resp);
AddStaticVehicleEx(Truck_C,-607.904602,-482.401397,27.547872,270.000,-1,-1,Truck_Resp);
AddStaticVehicleEx(Truck_L3,-551.702636,-500.173431,26.7000, 0.000,-1,-1,never);
AddStaticVehicleEx(Truck_L2,-546.702636,-500.173431,26.7000, 0.000,-1,-1,never);
AddStaticVehicleEx(Truck_L2,-541.702636,-500.173431,26.7000, 0.000,-1,-1,never);

// -- склад 2 ---
AddStaticVehicleEx(Truck_A,1024.378784,2109.518798,11.953639,0.000,-1,-1,Truck_Resp);
AddStaticVehicleEx(Truck_A,1082.265380,2069.524902,11.953635,90.000,-1,-1,Truck_Resp);
AddStaticVehicleEx(Truck_B,1047.362915,2140.871826,11.953639,90.000,-1,-1,Truck_Resp);
AddStaticVehicleEx(Truck_B,1047.362915,2135.871826,11.953653,90.000,-1,-1,Truck_Resp);
AddStaticVehicleEx(Truck_B,1047.362915,2130.871826,11.953639,90.000,-1,-1,Truck_Resp);
AddStaticVehicleEx(Truck_C,1047.362915,2125.871826,11.953639,90.000,-1,-1,Truck_Resp);
AddStaticVehicleEx(Truck_C,1034.217407,2103.036376,11.953649,0.000,-1,-1,Truck_Resp);

// -- склад 3 ---
AddStaticVehicleEx(Truck_A,2873.277832,905.880187,11.883332,90.000,-1,-1,Truck_Resp);
AddStaticVehicleEx(Truck_A,2873.277832,910.880187,11.883332,90.000,-1,-1,Truck_Resp);
AddStaticVehicleEx(Truck_B,2873.277832,915.880187,11.883332,90.000,-1,-1,Truck_Resp);
AddStaticVehicleEx(Truck_B,2873.277832,920.880187,11.883332,90.000,-1,-1,Truck_Resp);
AddStaticVehicleEx(Truck_B,2873.277832,925.880187,11.883332,90.000,-1,-1,Truck_Resp);
AddStaticVehicleEx(Truck_C,2873.277832,930.880187,11.883332,90.000,-1,-1,Truck_Resp);
AddStaticVehicleEx(Truck_C,2873.277832,935.880187,11.883332,90.000,-1,-1,Truck_Resp);
AddStaticVehicleEx(Truck_C,2873.277832,940.880187,11.883332,90.000,-1,-1,Truck_Resp);
AddStaticVehicleEx(Truck_L1,2850.0000,897.352233,11.338171,0.000,-1,-1,never);
AddStaticVehicleEx(Truck_L2,2844.0000,897.352233,11.338171,0.000,-1,-1,never);
AddStaticVehicleEx(Truck_L2,2838.0000,897.352233,11.338171,0.000,-1,-1,never);
AddStaticVehicleEx(Truck_L3,2832.0000,897.352233,11.338171,0.000,-1,-1,never);

// -- склад 4 ---
AddStaticVehicleEx(Truck_B,2197.700,-2234.700,13.700,315.000,-1,-1,Truck_Resp);
AddStaticVehicleEx(Truck_B,2200.700,-2237.700,13.700,315.000,-1,-1,Truck_Resp);
AddStaticVehicleEx(Truck_A,2203.700,-2240.700,13.700,315.000,-1,-1,Truck_Resp);
AddStaticVehicleEx(Truck_C,2207.700,-2243.700,13.700,315.000,-1,-1,Truck_Resp);
AddStaticVehicleEx(Truck_L3,2248.105224,-2233.470458,13.680203,45.000,-1,-1,never);
AddStaticVehicleEx(Truck_L3,2181.323730,-2284.930175,13.680213,315.000,-1,-1,never);

// -- SFAir ---
AddStaticVehicleEx(Truck_C,-1127.508,-176.402,14.280,135.000,-1,-1,Truck_Resp);
// -- GYAir ---
AddStaticVehicleEx(Truck_C,227.692,2553.218,16.814,90.000,-1,-1,Truck_Resp);
// -- LSAir ---
AddStaticVehicleEx(Truck_C,2042.382,-2217.575,13.680,90.000,-1,-1,Truck_Resp);
// -- LVAir ---
AddStaticVehicleEx(Truck_C,1550.955,1671.162,10.953,0.000,-1,-1,Truck_Resp);

return 1;
}

//--------------------------------------------------------------------------------------

public SendTruckMissionList(playerid,trpoint) // Формирует список миссий на точке и шлет диалог для игрока
{
if(TForSell[trpoint] != 1) {return 0;}

if (PlayerQuest[playerid] != 0)
{
	ShowPlayerDialog(playerid,S_GUI_02,0,TradeLOGO,"Вы уже участвуете в другом соревновании,\nсначала покинте его!","Info","Выход");
	return 0;
}

new mislist[1024];
new times, timem;
new mhead[128];
new money = GetPlayerMoney(playerid);
new level = GetPlayerLevel(playerid);

for(new i=0;i<MAX_TMISS;i++)
{
if(TradeMissions[i][origin] == trpoint)
{

if(!TradeMissions[i][status])
{
timem = TradeMissions[i][time]/MIN_SEC;
times = TradeMissions[i][time] - timem*MIN_SEC;
//if(GetPlayerLevel(playerid) > TRADE_LEVEL)
//{
	if(money < TradeMissions[i][keepup] && level > TRADE_LEVEL)
	{
	format(mislist,sizeof(mislist),"%s{fffa6e}FREE{FFFFFF} | DP %d | %.2fkm to %s | %s | %dm %ds | P %d$ | K %d$\n",mislist,TradeMissions[i][dest], TradeMissions[i][path]/1000, ACompass(TradeMissions[i][compass]),  TradeGoods[ TradeMissions[i][good] ][g_name], timem, times , TradeMissions[i][price], TradeMissions[i][keepup]);
	}
	else
	{
	format(mislist,sizeof(mislist),"%s{00EE00}FREE{FFFFFF} | DP %d | %.2fkm to %s | %s | %dm %ds | P %d$ | K %d$\n",mislist,TradeMissions[i][dest], TradeMissions[i][path]/1000, ACompass(TradeMissions[i][compass]),  TradeGoods[ TradeMissions[i][good] ][g_name], timem, times , TradeMissions[i][price], TradeMissions[i][keepup]);
	}
//	return 1;
//}
}
else
{
new delid = PlayerSQLID2ID(TradeMissions[i][deliverman]);
format(mislist,sizeof(mislist),"%s{FF0000}LOCKED{FFFFFF} | DP %d | Driver: %s [id %d]\n",mislist,TradeMissions[i][dest],oGetPlayerName(delid),delid);
}

}
}
format(mhead,sizeof(mhead),"::: ДАЛЬНОБОЙЩИКИ - СКЛАД - %s [ID %d] - СПИСОК МИССИЙ :::",TBasesName[trpoint],trpoint);
ShowPlayerDialog(playerid,CGUI+7,DIALOG_STYLE_LIST,mhead, mislist ,"ПРИНЯТЬ","Отмена");
return 1;
}
//--------------------------------------------------------------------------------------

public PlayerJoinTradeMission( playerid )
{
	if( !IsPlayerInIndustrialTruck(playerid) )
	{
		ShowPlayerDialog(playerid, S_GUI_02,0,TradeLOGO,"Вы должны быть в грузовике!","ОК","");
		return 0;
	}
	
	new trid = GetVehicleTrailer(GetPlayerVehicleID(playerid));
	new missid = -1;
	if(trid != 0)
	{
		for(new i=0;i<MAX_TMISS;i++)
		{
			if(trid == TradeMissions[i][truckid])
			{
				missid = i;
				break;
			}
		}
	}

	if(missid == -1)
	{
		ShowPlayerDialog(playerid, S_GUI_02,0,TradeLOGO,"Извините, эта торговая миссия\nуже завершена!","ОК","");
		return 0;
	}
	
	if ( PlayerQuest[playerid] != 0 && PlayerQuest[playerid] != TradeMissions[missid][questid] )
	{
		RemovePlayerFromVehicle(playerid);
		ShowPlayerDialog(playerid, S_GUI_02,0,TradeLOGO,"Вы уже участвуете в другом соревновании,\nсначала покинте его!","OK","");
		return 0;
	}
	
	//GangZoneShowForPlayer(playerid, TBasesZone[ TradeMissions[missid][dest] ], TColorZone[4]);
	PlayerQuest[playerid] = TradeMissions[missid][questid];
	oSetPlayerRaceCheckpoint(playerid,	2, 	TBases[ TradeMissions[missid][dest] ][Coord_X],
										TBases[ TradeMissions[missid][dest] ][Coord_Y],
										TBases[ TradeMissions[missid][dest] ][Coord_Z],
										TBases[ TradeMissions[missid][dest] ][Coord_X],
										TBases[ TradeMissions[missid][dest] ][Coord_Y],
										TBases[ TradeMissions[missid][dest] ][Coord_Z], 8);
	SetPlayerMapIcon(playerid, TRADE_ICON_ID,	TBases[ TradeMissions[missid][dest] ][Coord_X],
												TBases[ TradeMissions[missid][dest] ][Coord_Y],
												TBases[ TradeMissions[missid][dest] ][Coord_Z],
												TRADE_ICON_MARKER, -1, 1);
									
	ShowPlayerDialog(playerid,S_GUI_02,0,TradeLOGO,
	"Следуйте к иконке 'Т' на радаре\n\
	Доставьте груз на красный маркер!"
	,"ОК","");
	return 1;
}
//--------------------------------------------------------------------------------------

public OnPlayerReadyToEnterTCP(playerid,tid) // если наехали на чекпоинт торговли
{
//if (playerid == INVALID_PLAYER_ID) {return 1;}
//if (playerid == INVALIDX_PLAYER_ID) {return 1;}
//if (!IsPlayerConnected(playerid)) {return 1;}

new tempstr[128];
//new tid = -1;
//tid = IsPlayerAtTradeCP(playerid); // получаем ид торговой точки

if (tid == -1) {return 1;}

new mhead[MAX_STRING];

if (!IsPlayerInIndustrialTruck(playerid)) // Если игрок не в грузовике
{
switch (TForSell[tid])
{
case 0:format(mhead,sizeof(mhead),"МАГАЗИН - %s - [ID %d]\n- - -\nМагазины скупают привезенные вами товары.\nПолучите миссию по доставке груза на складе",TBasesName[tid],tid);
case 1:format(mhead,sizeof(mhead),"СКЛАД - %s - [ID %d]\n- - -\nПриезжайте на грузовике с прицепом чтобы получить миссию по доставке груза",TBasesName[tid],tid);
case 2:format(mhead,sizeof(mhead),"АЭРОПОРТ - %s - [ID %d]\n- - -\nАэропорты покупают керосин для заправки самолетов.\nВы можете получить миссию по доставке керосина на складе",TBasesName[tid],tid);
case 3:format(mhead,sizeof(mhead),"AЗС - %s - [ID %d]\n- - -\nЗдесь вы можете:\n\t+ Заправить машину АЗОТОМ ('/nitro')\n\t+ Получить награду за привезенный бензин\n\nАЗС покупают только бензин.\nВы можете получить миссию по доставке бензина на складе",TBasesName[tid],tid);
}
ShowPlayerDialog(playerid,CGUI+5,0,TradeLOGO,mhead,"Info","Выход");
return 1;
}

if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) // Если игрок не водитель
{ return 1; }

new trid = GetVehicleTrailer(GetPlayerVehicleID(playerid)); // Получаем ид прицепа

if(trid == 0) // Нет прицепа
{
format(mhead,sizeof(mhead),"ДИСПЕТЧЕР ТОЧКИ - %s - [ID %d]\n- - -\nВы приехали без прицепа!",TBasesName[tid],tid);
ShowPlayerDialog(playerid,CGUI+5,0,TradeLOGO,mhead,"Info","Выход");
return 1;
}

new trmod = GetVehicleModel(trid); // Узнаем модель прицепа

if(!IsValidTrailer(trmod)) // Если неправильная модель прицепа
{
format(mhead,sizeof(mhead),"ДИСПЕТЧЕР ТОЧКИ - %s - [ID %d]\n- - -\nДанная модель прицепа не используется в системе!",TBasesName[tid],tid);
ShowPlayerDialog(playerid,CGUI+5,0,TradeLOGO,mhead,"Info","Выход");
return 1;
}

new trcheck = -1; // переменная получит значение равное ИД миссии в которой используется прицеп

for(new i=0;i<MAX_TMISS;i++) // Ищем, используется ли прицеп в какойнибудь миссии, получаем ид миссии
{
if(trid == TradeMissions[i][truckid]) {trcheck = i; break;}
}

if(trcheck != -1) // Если прицеп используется в одной из миссии
{


if(tid == TradeMissions[trcheck][dest]) // Если груз привезен в нужную точку
{
/*
new xpprice;
if(TradeMissions[trcheck][timelife] <= TradeMissions[trcheck][time]) // если успел вовремя
{
PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
SendPlayerFormattedText(playerid, "Поздравляю! ВЫ привезли груз вовремя!!!! Держите награду!!!", 0,COLOR_TRADE);
oGivePlayerMoney(playerid, TradeMissions[trcheck][price]+TradeMissions[trcheck][keepup], 1);
xpprice = floatround( TradeGoods[ TradeMissions[trcheck][good] ][g_par]*(Player[playerid][Level]+1)*750 );
}
else // ... а если не успел
{
PlayerPlaySound(playerid, 1055, 0.0, 0.0, 0.0);
SendPlayerFormattedText(playerid, "ВЫ опоздали, и не получите награды!!!", 0,COLOR_TRADE);
oGivePlayerMoney(playerid, TradeMissions[trcheck][keepup], 1);
xpprice = floatround( TradeGoods[ TradeMissions[trcheck][good] ][g_par]*(Player[playerid][Level]+1)*300 );
}

GivePlayerXP(playerid, xpprice, 1);

GangZoneShowForPlayer(playerid, TBasesZone[tid], TColorZone[TForSell[tid]] ); // рисуем на карте гангзону

GenerateTradeMission(trcheck,1,1); // регенерируем миссию и всем сообщаем о ней и 3ДТехт удаляем
*/
}

else // ... а если привезен в ненужную точку

{



if(tid == TradeMissions[trcheck][origin]) // если привезен туда где был взят
{
format(tempstr,sizeof(tempstr),"СКЛАД - %s - [ID %d]\n- - -\nЭтот груз необходимо отвезти на %s [ID %d],\nзачем вы привезли его обратно?",TBasesName[tid],tid,TBasesName[ TradeMissions[trcheck][dest] ],TradeMissions[trcheck][dest]);
ShowPlayerDialog(playerid,CGUI+5,0,TradeLOGO,tempstr,"Info","Выход");
return 1;
}

if(TForSell[tid] == 1) // если точка - склад
{
format(mhead,sizeof(mhead),"СКЛАД - %s - [ID %d]\n- - -\nГруз привезен не туда куда требуется!\nХотите продать его за ПОЛОВИНУ стоимости?",TBasesName[tid],tid);
ShowPlayerDialog(playerid,CGUI+8,0,TradeLOGO,mhead,"ДА","НЕТ");
return 1;
}

if(TradeMissions[trcheck][good] == 8) // если везет керосин
{
	switch(TForSell[tid])
	{
		case 0:{format(mhead,sizeof(mhead),"МАГАЗИН - %s - [ID %d]\n- - -\nГруз привезен не туда куда требуется!\nМагазин не покупает керосин, везите его в аэропорт!",TBasesName[tid],tid);
		ShowPlayerDialog(playerid,CGUI+5,0,TradeLOGO,mhead,"Info","Выход");}
		case 2:{format(mhead,sizeof(mhead),"АЭРОПОРТ - %s - [ID %d]\n- - -\nГруз привезен не туда куда требуется!\nХотите продать его за ПОЛОВИНУ стоимости?",TBasesName[tid],tid);
		ShowPlayerDialog(playerid,CGUI+8,0,TradeLOGO,mhead,"ДА","НЕТ");}
		case 3:{format(mhead,sizeof(mhead),"АЗС - %s - [ID %d]\n- - -\nГруз привезен не туда куда требуется!\nАЗС не покупает керосин, везите его в аэропорт!",TBasesName[tid],tid);
		ShowPlayerDialog(playerid,CGUI+5,0,TradeLOGO,mhead,"Info","Выход");}
	}
return 1;
}

if(TradeMissions[trcheck][good] == 1) // если везет бензин
{
	switch(TForSell[tid])
	{
		case 0:{format(mhead,sizeof(mhead),"МАГАЗИН - %s - [ID %d]\n- - -\nГруз привезен не туда куда требуется!\nМагазин не покупает бензин, везите его на АЗС!",TBasesName[tid],tid);
		ShowPlayerDialog(playerid,CGUI+5,0,TradeLOGO,mhead,"Info","Выход");}
		case 2:{format(mhead,sizeof(mhead),"АЭРОПОРТ - %s - [ID %d]\n- - -\nГруз привезен не туда куда требуется!\nАэропорт не покупает бензин, везите его на АЗС!",TBasesName[tid],tid);
		ShowPlayerDialog(playerid,CGUI+5,0,TradeLOGO,mhead,"Info","Выход");}
		case 3:{format(mhead,sizeof(mhead),"АЗС - %s - [ID %d]\n- - -\nГруз привезен не туда куда требуется!\nХотите продать его за ПОЛОВИНУ стоимости?",TBasesName[tid],tid);
		ShowPlayerDialog(playerid,CGUI+8,0,TradeLOGO,mhead,"ДА","НЕТ");}
	}
return 1;
}

if(TradeMissions[trcheck][good] != 1 && TradeMissions[trcheck][good] != 8) //
{
switch(TForSell[tid])
	{
		case 0:{format(mhead,sizeof(mhead),"МАГАЗИН - %s - [ID %d]\n- - -\nГруз привезен не туда куда требуется!\nХотите продать его за ПОЛОВИНУ стоимости?",TBasesName[tid],tid);
		ShowPlayerDialog(playerid,CGUI+8,0,TradeLOGO,mhead,"ДА","НЕТ");}
		case 2:{format(mhead,sizeof(mhead),"АЭРОПОРТ - %s - [ID %d]\n- - -\nГруз привезен не туда куда требуется!\nАэропорты не покупает ничего кроме керосина.\nВезите груз в магазин или на склад!",TBasesName[tid],tid);
		ShowPlayerDialog(playerid,CGUI+5,0,TradeLOGO,mhead,"Info","Выход");}
		case 3:{format(mhead,sizeof(mhead),"АЗС - %s - [ID %d]\n- - -\nГруз привезен не туда куда требуется!\nАЗС не покупает ничего кроме бензина.\nВезите груз в магазин или на склад!",TBasesName[tid],tid);
		ShowPlayerDialog(playerid,CGUI+5,0,TradeLOGO,mhead,"Info","Выход");}
	}
return 1;
}

}

}
else // ... а если ни в одной не используется
{

switch(TForSell[tid])
{
	case 0:{format(mhead,sizeof(mhead),"МАГАЗИН - %s - [ID %d]\n- - -\nВы приехали с пустым прицепом! Здесь нечего делать без груза!\nПоезжайте на склад и возьмите миссию по доставке",TBasesName[tid],tid);
	ShowPlayerDialog(playerid,CGUI+5,0,TradeLOGO,mhead,"Info","Выход");}
	case 1:{SetVehicleVelocity(GetPlayerVehicleID(playerid), 0.000, 0.000, 0.000); SendTruckMissionList(playerid,tid);} // Прислать диалог со списком миссий на этой точке
	case 2:{format(mhead,sizeof(mhead),"АЭРОПОРТ - %s - [ID %d]\n- - -\nВы приехали с пустым прицепом! Здесь нечего делать без груза!\nПоезжайте на склад и возьмите миссию по доставке керосина",TBasesName[tid],tid);
	ShowPlayerDialog(playerid,CGUI+5,0,TradeLOGO,mhead,"Info","Выход");}
	case 3:{format(mhead,sizeof(mhead),"АЗС - %s - [ID %d]\n- - -\nВы приехали с пустым прицепом! Здесь нечего делать без груза!\nПоезжайте на склад и возьмите миссию по доставке бензина",TBasesName[tid],tid);
	ShowPlayerDialog(playerid,CGUI+5,0,TradeLOGO,mhead,"Info","Выход");}
}

}

return 1;
}

public OnPlayerEnterTradeCheckpoint(playerid)
{
new mhead[128];

new tid = -1;
tid = IsPlayerAtTradeCP(playerid);
if (tid == -1) {return 1;}

switch (TForSell[tid])
{
case 0:format(mhead,sizeof(mhead),"МАГАЗИН - %s - [ID %d] (Используйте '/trade')",TBasesName[tid],tid);
case 1:format(mhead,sizeof(mhead),"СКЛАД - %s - [ID %d] (Используйте '/trade')",TBasesName[tid],tid);
case 2:format(mhead,sizeof(mhead),"АЭРОПОРТ - %s - [ID %d] (Используйте '/trade')",TBasesName[tid],tid);
case 3:format(mhead,sizeof(mhead),"AЗС - %s - [ID %d] (Используйте '/trade')",TBasesName[tid],tid);
}

SendPlayerFormattedText(playerid, mhead, 0,COLOR_TRADE);

return 1;
}

trade_OnPlayerEnterRaceCP(playerid)
{
new tid = -1;
tid = IsPlayerAtTradeCP(playerid);
if (tid == -1) {
SendDebugMessage(playerid, 0xFF0000FF, "Player %d выполнилось 1 условие", playerid);
return 1;}

if (!IsPlayerInIndustrialTruck(playerid)) {
SendDebugMessage(playerid, 0xFF0000FF, "Player %d выполнилось 2 условие", playerid);
return 1; }

if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) {
SendDebugMessage(playerid, 0xFF0000FF, "Player %d выполнилось 3 условие", playerid);
return 1; }

new trid = GetVehicleTrailer(GetPlayerVehicleID(playerid));
if(trid == 0) {
SendDebugMessage(playerid, 0xFF0000FF, "Player %d выполнилось 4 условие", playerid);
return 1; }

new trmod = GetVehicleModel(trid);
if(!IsValidTrailer(trmod)){
SendDebugMessage(playerid, 0xFF0000FF, "Player %d выполнилось 5 условие", playerid);
return 1;}

new trcheck = -1;
for(new i=0;i<MAX_TMISS;i++) {
if(trid == TradeMissions[i][truckid]) {trcheck = i; break;}}
if(trcheck == -1) {
SendDebugMessage(playerid, 0xFF0000FF, "Player %d выполнилось 6 условие", playerid);
return 1; }

if(tid == TradeMissions[trcheck][dest])
{

new xpprice;
if(GetPlayerLevel(playerid) >= TRADE_LEVEL)
{
	if(TradeMissions[trcheck][timelife] <= TradeMissions[trcheck][time]) // если успел вовремя
	{
		PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
		SendPlayerFormattedText(playerid, "Поздравляю! ВЫ привезли груз вовремя!!!! Держите награду!!!", 0,COLOR_TRADE);
		oGivePlayerMoney(playerid, TradeMissions[trcheck][price]+TradeMissions[trcheck][keepup], 1);
		xpprice = floatround( TradeGoods[ TradeMissions[trcheck][good] ][g_par]*(Player[playerid][Level]+1)*350 );
		GivePlayerRaceXP(playerid,2);
	}
	else // ... а если не успел
	{
		PlayerPlaySound(playerid, 1055, 0.0, 0.0, 0.0);
		SendPlayerFormattedText(playerid, "ВЫ опоздали, и не получите награды!!!", 0,COLOR_TRADE);
		xpprice = floatround( TradeGoods[ TradeMissions[trcheck][good] ][g_par]*(Player[playerid][Level]+1)*150 );
		GivePlayerRaceXP(playerid,1);
	}
}
if(GetPlayerLevel(playerid) < TRADE_LEVEL)
{
	if(TradeMissions[trcheck][timelife] <= TradeMissions[trcheck][time]) // если успел вовремя
	{
		PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
		SendPlayerFormattedText(playerid, "Поздравляю! ВЫ привезли груз вовремя!!!! Держите награду!!!", 0,COLOR_TRADE);
		oGivePlayerMoney(playerid, TradeMissions[trcheck][price], 1);
		xpprice = floatround( TradeGoods[ TradeMissions[trcheck][good] ][g_par]*(Player[playerid][Level]+1)*350 );
		GivePlayerRaceXP(playerid,2);
	}
	else // ... а если не успел
	{
		PlayerPlaySound(playerid, 1055, 0.0, 0.0, 0.0);
		SendPlayerFormattedText(playerid, "ВЫ опоздали, и не получите награды!!!", 0,COLOR_TRADE);
		xpprice = floatround( TradeGoods[ TradeMissions[trcheck][good] ][g_par]*(Player[playerid][Level]+1)*150 );
		GivePlayerRaceXP(playerid,1);
	}
}
oDisablePlayerRaceCheckpoint(playerid);
RemovePlayerMapIcon(playerid, TRADE_ICON_ID );
ResetQuest(playerid);

GivePlayerXP(playerid, xpprice, 1);
//GangZoneShowForPlayer(playerid, TBasesZone[tid], TColorZone[TForSell[tid]] ); // рисуем на карте гангзону
GenerateTradeMission(trcheck,1,1,3); // регенерируем миссию и всем сообщаем о ней и 3ДТехт удаляем

	if(Player[playerid][train1] == 1)
	{
   		Player[playerid][train1]=2;
   		GivePlayerXP(playerid, 850, 1);
   		DestroyVehicle(TrainingVehicle[playerid][train_indus1]);
   		TrainingVehicle[playerid][train_indus1] = INVALID_VEHICLE_ID;
   		DestroyVehicle(TrainingVehicle[playerid][train_indus2]);
   		TrainingVehicle[playerid][train_indus2] = INVALID_VEHICLE_ID;
   		DestroyVehicle(TrainingVehicle[playerid][train_indus3]);
   		TrainingVehicle[playerid][train_indus3] = INVALID_VEHICLE_ID;
   		DestroyVehicle(TrainingVehicle[playerid][train_indus4]);
   		TrainingVehicle[playerid][train_indus4] = INVALID_VEHICLE_ID;
   		OnPlayerSpawn(playerid);
   		ResetQuest(playerid);
   		oSetPlayerVirtualWorld(playerid,0); // Виртуальный мир
		printf("INDUSTRIAL: DestroyVehicle and setting INVALID_VEHICLE_ID");
	}
	if(Player[playerid][train1] == 0)
	{
   		Player[playerid][train1] = 2;
   		GivePlayerXP(playerid, 850, 1);
	}

}
SendDebugMessage(playerid, 0xFF0000FF, "Player %d выполнилось последние 7 условие", playerid);
return 1;
}

//--------------------------------------------------------------------------------------

public IsPlayerInIndustrialTruck(playerid) //By OFFREAL
{
if(IsPlayerInAnyVehicle(playerid)){
new vehicleid = GetPlayerVehicleID(playerid);
new vehicleclass = GetVehicleModel(vehicleid);
switch(vehicleclass)
{
case 403:return 1;
case 514:return 1;
case 515:return 1;
}
}
return 0;
}

//--------------------------------------------------------------------------------------

//вся эта байда ниже, нужна чтобы торговые гангзоны на карте были видны только игрокам сидящим за рулем грузовиков, если
//игрок сядет в грузовик к которому приделан прицеп который используется в какойнибудь миссии, то торговая гангзона для 
//игрока станет красной.
//есть однако проблема - если сначала сесть в грузовик, а потом зацепить прицеп который используется в какойнибудь
//из миссий, то хрен станет торговая гангзона красной. Надо вылазить и снова садиться. Это из-за того что нельзя
//опросить момент прикрепления прицепа

//--------------------------------------------------------------------------------------

public trade_OnPlayerSC(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_DRIVER)
	{
		if(IsPlayerInIndustrialTruck(playerid))
		{
			
			for (new i=0;i<MAX_TBASE;i++)
			{
				GangZoneShowForPlayer(playerid, TBasesZone[i], TColorZone[ TForSell[i] ] );
			}
			
			Trader[playerid] = 1;
			
			new trid = 0;
			trid = GetVehicleTrailer(GetPlayerVehicleID(playerid));
			if(trid != 0)
			{
				for(new i=0;i<MAX_TMISS;i++)
				{
					if(trid == TradeMissions[i][truckid])
					{
						ShowPlayerDialog(playerid, CGUI+11, 0,TradeLOGO,"Жалаете выполнить торговую миссию?","Да","Нет");
						break;
					}
				}
			}	
		}
	return 1;
	}
	if(oldstate == PLAYER_STATE_DRIVER)
	{
		if( Trader[playerid] )
		{
			for (new i=0;i<MAX_TBASE;i++)
			{
				GangZoneHideForPlayer(playerid, TBasesZone[i]);
			}
		
			Trader[playerid] = 0;
		}
	return 1;
	}
return 1;
}

//--------------------------------------------------------------------------------------

public trade_OnPlayerConnect(playerid)
{
	RemovePlayerMapIcon(playerid, TRADE_ICON_ID );
	for (new i=0;i<MAX_TBASE;i++)
	{
		GangZoneHideForPlayer(playerid, TBasesZone[i]);
	}
return 1;
}

public trade_OnVehicleDeath(vehicleid)
{
	for(new i=0;i<MAX_TMISS;i++)
	{
		if(vehicleid == TradeMissions[i][truckid])
		{
			/*
			new playerid = PlayerSQLID2ID(TradeMissions[i][deliverman]); // получаем ид игрока из его SQLID
			if(playerid != -1) // если такой игрок есть на сервере
			{
				ShowPlayerDialog(playerid,CGUI+9,0,TradeLOGO,"ТОРГОВАЯ МИССИЯ ПРОВАЛЕНА\n- - -\nГруз уничтожен!","ОК","Инфо");
				
				
				if(IsPlayerInIndustrialTruck(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER) // если игрок за рулем грузовика
				{
					GangZoneShowForPlayer(playerid, TBasesZone[i], TColorZone[TForSell[TradeMissions[i][dest]]] ); // показываем гангзону		
				}

			}
			*/
			
			GenerateTradeMission(i,1,1,2); // регенерируем миссию, и говорим всем об этом, и удаляем 3Дтекст
		}
	}
return 1;
}

public IsPlayerAtGS(playerid)
{
for (new id=0;id<MAX_TBASE;id++)
	{
	if(TForSell[id] != 3) {continue;}

		if (IsPlayerInSphere(playerid,TBases[id][Coord_X],TBases[id][Coord_Y],TBases[id][Coord_Z],30))
		{
		return 1;
		}

	}
return 0;
}

public SetCarNitro(playerid)
{
	if(!IsPlayerInAnyVehicle(playerid)) {return SendClientMessage(playerid,COLOUR_RED, lang_texts[11][9]); }
	
	if(IsPlayerAtGS(playerid))
	{
		if(GetPlayerMoney(playerid) < NITROPRICE)
		{
			new tmp[128];
			format(tmp,sizeof(tmp),"Недостаточно средств для установки! Требуется %d $",NITROPRICE);
			return SendClientMessage(playerid, COLOUR_RED, tmp);
		}
		oGivePlayerMoney(playerid,-NITROPRICE,0);
		AddVehicleComponent(GetPlayerVehicleID(playerid),1010);
		SendClientMessage(playerid, COLOUR_XP_GOOD, ">>> Система закиси азота приобретена.");
	}
	return 1;
}

public SendMessageToTraders(color, message[])
{
	for (new playerid=0;playerid<MAX_PLAYERS;playerid++)
	{
 		if (IsPlayerRegistered(playerid))
 		{
		if(Trader[playerid] == 1)
		{
			SendClientMessage(playerid,color,message);
		}
		}
	}
}
