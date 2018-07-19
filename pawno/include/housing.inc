// Created: Аsturel 
// ReCreate: Artem Firstov (Konsul)
#if defined _housing_included
#endinput
#endif

#define _housing_included
#pragma library housing
#include "base"
#include "utils\gtoutils"
#include "utils\dutils"
#include "utils\gtodudb"
#include "utils\dini"
#include "account"
#include "player"
#include "world"

forward HousesInit();
forward IsPlayerAtHouse(playerid);
//forward OnPlayerEnterHousesCheckpoint(playerid);
forward GetHouseID(playerid);
forward HousesCommandHandler(playerid,text[]);
forward ganghouse(playerid, text);
forward gang2house(playerid,i);

//forward GetGangHouseName(gangid);
forward GetGangHouseID(gangsqlid);

//forward GetPlayerHouseID(playername[]);
forward HouseKeepUp();
forward UpdateHouse3D(id);
forward HouseMakeOwnerless(id,save,upd);
forward SetHouse3DTColor(id,color);

//forward HouseMenuInit();
forward FHouseInfo(playerid);
forward FHouseHouses(playerid);
forward FHouseBuy(playerid);
forward FHouseSell(playerid);
forward FHouseMyHouses(playerid);
forward FHouseKeep(playerid, money);
forward FHouseEnter(playerid);

forward DialogPlayerHouse(playerid);
forward HousesSync();
forward GetKeepTime(id);

#define MAX_HOUSEBUYSELL 999999999
#define MAX_HOUSES 30

#define HOUSE_DELAY 600000

new House_Delay_In_H = 3600000/HOUSE_DELAY;

new KeepC = 40000000;

enum HouseInfo {
	Houses_DBID, // ID in database - A
	Houses_Name[MAX_STRING],  // house name - B
	Houses_Cost,     // cost - C
	Houses_Gang[MAX_NAME],  // name of owner-gang - D
	Houses_GangSQLID, // sqlid of owner-gang - E
	Houses_UpKeep,    // keep up - F
	Houses_UpKeepLeft,   // keep up left - G
	Houses_Buyout,  // Buyout price - H
	Houses_3dtcolor, //color of 3d texts at house marker - I
	Houses_MinGangXP, // min XP that must have gang for bye this house - J
	Houses_VW // Virtual World in player or gangs - K
}

new HousesDB[MAX_STRING] = "GTO/HousesDB/";

new Houses[MAX_HOUSES][HouseInfo] = {
//A	B							C			D			E	F		G	H	I				J
{1,	"[LV]Emerald Isle",			10000000,	"Unknown",	0,	250,	0,	0,	COLOUR_PLAYER,	2,101}, //1
{2,	"[LV]Manhatan",				8000000,	"Unknown",	0,	100,	0,	0,	COLOUR_PLAYER,	1,102}, //2
{3,	"[LV]Jarry",				2000000,	"Unknown",	0,	100,	0,	0,	COLOUR_PLAYER,	1,103}, //3
{4,	"[LV]The Visage",			9000000,	"Unknown",	0,	250,	0,	0,	COLOUR_PLAYER,	2,104}, //4
{5,	"[LV]Mafia House",			8000000,	"Unknown",	0,	250,	0,	0,	COLOUR_PLAYER,	2,105}, //5
 
{6,	"[LV]Four Dragons Mansion",	10000000,	"Unknown",	0,	250,	0,	0,	COLOUR_PLAYER,	2,106}, //6
{7,	"[LV]Caligula Mansion",		10000000,	"Unknown",	0,	250,	0,	0,	COLOUR_PLAYER,	2,107}, //7
{8,	"[LS]Mulholland",			2000000,	"Unknown",	0,	100,	0,	0,	COLOUR_PLAYER,	1,108}, //8
{9,	"[LS]Santa Maria Beach",	3000000,	"Unknown",	0,	100,	0,	0,	COLOUR_PLAYER,	1,109}, //9
{10,"[SF]Angel Pine",			2000000,	"Unknown",	0,	100,	0,	0,	COLOUR_PLAYER,	1,110}, //10

{11,"[SF]Whetstone",			2400000,	"Unknown",	0,	100,	0,	0,	COLOUR_PLAYER,	1,111}, //11
{12,"[SF]Hashbury",				2600000,	"Unknown",	0,	100,	0,	0,	COLOUR_PLAYER,	1,112}, //12
{13,"[SF]Doherty",				2000000,	"Unknown",	0,	100,	0,	0,	COLOUR_PLAYER,	1,113}, //13
{14,"[SF]Queens",				4000000,	"Unknown",	0,	100,	0,	0,	COLOUR_PLAYER,	1,114}, //14
{15,"[SF]Paradiso",				4000000,	"Unknown",	0,	100,	0,	0,	COLOUR_PLAYER,	1,115}, //15

{16,"[LV]El Quebradas",			7000000,	"Unknown",	0,	100,	0,	0,	COLOUR_PLAYER,	1,116}, //16
{17,"[LV]Tierra Robada",		4000000,	"Unknown",	0,	100,	0,	0,	COLOUR_PLAYER,	1,117}, //17
{18,"[LV]Fort Carson",			4000000,	"Unknown",	0,	100,	0,	0,	COLOUR_PLAYER,	1,118}, //18
{19,"[LV]Whitewood Estates",	4000000,	"Unknown",	0,	100,	0,	0,	COLOUR_PLAYER,	1,119}, //19
{20,"[LV]Prickle Pine",			4000000,	"Unknown",	0,	100,	0,	0,	COLOUR_PLAYER,	1,120}, //20

{21,"[LV]Redsands West",		5000000,	"Unknown",	0,	250,	0,	0,	COLOUR_PLAYER,	2,121}, //21
{22,"[LV]Pirates In Mens Pants",10000000,	"Unknown",	0,	250,	0,	0,	COLOUR_PLAYER,	2,122}, //22
{23,"[LV]The Camels Toe",		7000000,	"Unknown",	0,	250,	0,	0,	COLOUR_PLAYER,	2,123}, //23
{24,"[LV]The Clowns Pocket",	9000000,	"Unknown",	0,	250,	0,	0,	COLOUR_PLAYER,	2,124}, //24
{25,"[LV]Old Venturas Strip",	7000000,	"Unknown",	0,	250,	0,	0,	COLOUR_PLAYER,	2,125}, //25

{26,"[LV]Creek",				4000000,	"Unknown",	0,	250,	0,	0,	COLOUR_PLAYER,	2,126}, //26
{27,"[LS]Beverly Hills",		2000000,	"Unknown",	0,	100,	0,	0,	COLOUR_PLAYER,	1,127}, //27
{28,"[LV]The High Roller",		8000000,	"Unknown",	0,	250,	0,	0,	COLOUR_PLAYER,	2,128}, //28
{29,"[LS]Real Resident",		2000000,	"Unknown",	0,	100,	0,	0,	COLOUR_PLAYER,	1,129}, //29
{30,"[LS]Mattdogs",				3000000,	"Unknown",	0,	100,	0,	0,	COLOUR_PLAYER,	1,130} //30

/*
{"[LV]Kakawki House",80000000,"Unknown","Unknown",900,0,0}
{"[SF]Calton Heights",10000000,"Unknown","Unknown",3000,0,0},
{"[SF]Chinatown",10000000,"Unknown","Unknown",500,0,0},
{"[LS]Willowfield",20000000,"Unknown","Unknown",500,0,0},
{"[LS]Verdant Bluffs",20000000,"Unknown","Unknown",500,0,0},
{"[LS]Jefferson",20000000,"Unknown","Unknown",500,0,0},
{"[LS]Verona Beach",20000000,"Unknown","Unknown",800,0,0},
{"[LS]Palomino Creek",20000000,"Unknown","Unknown",5000,0,0},
{"[LS]Blueberry",20000000,"Unknown","Unknown",500,0,0},
{"[LS]Dillimore",20000000,"Unknown","Unknown",1500,0,0},
*/
};

new HousesCP[MAX_HOUSES][CoordInfo] = {
 {2127.5940,2370.4255,10.8203}, //1
 {2482.7441,1527.2084,11.3221},
 {2167.9021,772.9495,11.4609},
 {2022.5179,1916.6848,12.3397},
	{2179.9417,1116.6407,12.6484},
	
 {2024.6848,1000.7979,10.8203}, //2
	{2186.32324,1686.7069,11.0987},	
	//{2486.8389,-1997.4480,13.8343},
	//{1687.8954,-2100.4861,13.8343},
	//{2108.2073,-1280.1827,25.6875},
	
	{1325.8687,-633.3270,109.1349}, //3
	//{890.5464,-1638.7795,14.9616},
	{312.6361,-1772.2003,4.6282},
	//{2238.4756,166.0871,28.1535},
	//{206.6301,-109.8167,4.8965},
	
	//{791.9865,-507.5847,18.0129}, //4
	{-2080.1499,-2312.3855,30.6250},
	{-1442.8309,-1541.9430,101.7578},
	{-2456.8408,-131.7211,26.0440},
	{-2027.6254,-44.5550,38.4414},
	
	{-2421.6580,335.3531,35.7626}, //5
	//{-2210.9714,723.4057,49.4141},
	{-2703.1348,818.3945,49.9844},
	//{-2103.9272,900.6589,76.7109},
	{-1534.4202,2649.6294,55.8359},
	
	{-1045.4006,1552.8932,33.3112}, //6
	{-364.1446,1168.8844,19.7422},
	{926.3783,2010.8345,11.4609},
	{1282.0720,2525.0994,10.8203},
	{1405.6171,1900.5596,11.4609},
	
	{1969.4005,1623.1444,12.8625}, //7
	{2233.6375,1288.4495,10.8203},
	{2223.1616,1840.9108,10.8203},
	{2371.1787,2169.1052,10.8257},
	{2820.9004,2140.8269,14.6615},
	
	{1497.0000,-694.0000,94.7500}, //8
	{1935.6843,1345.6214,9.9687},
	{1125.0000,-2037.0000,69.9000},
	{1245.684814,-767.764160,91.965103}
	//{1906.0000,1615.0000,24.2300}

};




/*
new Menu:HouseMenu;

public HouseMenuInit()     //Create by FP
{
//	new rst[256]="edited...";

	HouseMenu = CreateMenu("House", 1, 30.0, 150.0, 100.0, 140.0);
//	SetMenuColumnHeader(HouseMenu, 0, "");
		AddMenuItem(HouseMenu, 0, "~<~ Exit");
		AddMenuItem(HouseMenu, 0, "Information");
		AddMenuItem(HouseMenu, 0, "Buy");
		AddMenuItem(HouseMenu, 0, "Sell");
//		AddMenuItem(HouseMenu, 0, "Set Sell Cost");
		AddMenuItem(HouseMenu, 0, "Keeping");
//		AddMenuItem(HouseMenu, 0, "My Houses");
		AddMenuItem(HouseMenu, 0, "All Houses");


return 1;
}

*/

//new HousesDB[MAX_STRING] = "GTO/Housing/";

new Text3D:Houses3DT[MAX_HOUSES];
new Text3D:housextextid[MAX_HOUSES];
new mapicon[MAX_HOUSES];

/*
HousesLoadAll()
{
	if (ForceOverwrite) return;
	new temp[MAX_STRING];
	if (!dini_Exists(ConfigDB)) dini_Create(ConfigDB);
	set(temp,dini_Get(ConfigDB,"Houses_DB"));
	if (strlen(temp) > 0) set(HousesDB,temp);
	if (!dini_Exists(HousesDB))
	{

		HousesSaveAll();

		return;
	}
	for (new i=0;i<MAX_HOUSES;i++)
	{
		new housesdbname[MAX_STRING];
		format(housesdbname,sizeof(housesdbname),"%sGTO.Houses.%s.txt",HousesDB,Houses[i][Houses_Name]);
		if (!dini_Exists(housesdbname))
		{
			// continue;
			dini_Create(housesdbname); HousesSaveAll();
		}
		set(temp,dini_Get(housesdbname,"Name"));
		if (strlen(temp) > 0) set(Houses[i][Houses_Name],temp);
		set(temp,nullstr);
		set(temp,dini_Get(housesdbname,"Cost"));
		if (strlen(temp) > 0) Houses[i][Houses_Cost] = strval(temp);
		set(temp,nullstr);
		//set(temp,dini_Get(housesdbname,"Owner"));
		//if (strlen(temp) > 0) set(Houses[i][Houses_Owner],temp);
		//set(temp,nullstr);
		
		set(temp,dini_Get(housesdbname,"gsqlid"));
		if (strlen(temp) > 0) Houses[i][Houses_GangSQLID] = strval(temp);
		set(temp,nullstr);
		
		set(temp,dini_Get(housesdbname,"Gang"));
		if (strlen(temp) > 0) set(Houses[i][Houses_Gang],temp);
		set(temp,nullstr);
		set(temp,dini_Get(housesdbname,"UpKeep"));
		if (strlen(temp) > 0) Houses[i][Houses_UpKeep] = strval(temp);
		set(temp,nullstr);
		set(temp,dini_Get(housesdbname,"UpKeepLeft"));
		if (strlen(temp) > 0) Houses[i][Houses_UpKeepLeft] = strval(temp);
		set(temp,nullstr);
		set(temp,dini_Get(housesdbname,"Buyout"));
		if (strlen(temp) > 0) Houses[i][Houses_Buyout] = strval(temp);
		set(temp,nullstr);
		
	}
	return;

}
*/
HousesLoadAll()
{

KeepC = (3600000*24*5)/HOUSE_DELAY;

for (new i=0;i<MAX_HOUSES;i++)
{
new housesdbname[MAX_STRING];
format(housesdbname,sizeof(housesdbname),"%sGTO.House.%d.rdb",HousesDB,Houses[i][Houses_DBID]);
if(!dini_Exists(housesdbname)){dini_Create(housesdbname); HousesSave(i); continue;}

set(Houses[i][Houses_Name],dini_Get(housesdbname,"Name"));
Houses[i][Houses_Cost] = dini_Int(housesdbname,"Cost");
set(Houses[i][Houses_Gang],dini_Get(housesdbname,"Gang"));
Houses[i][Houses_GangSQLID] = dini_Int(housesdbname,"GangSQLID");
Houses[i][Houses_UpKeep] = dini_Int(housesdbname,"UpKeep");
Houses[i][Houses_UpKeepLeft] = dini_Int(housesdbname,"UpKeepLeft");
//Houses[i][Houses_Buyout] = dini_Int(housesdbname,"Buyout");
Houses[i][Houses_3dtcolor] = dini_Int(housesdbname,"3dtcolor");
Houses[i][Houses_MinGangXP] = dini_Int(housesdbname,"MinGangXP");
}

printf("Houses: %d | Loading complete | KeepC = %d",MAX_HOUSES,KeepC);
return;
}

HousesSave(i)
{
new housesdbname[MAX_STRING];
format(housesdbname,sizeof(housesdbname),"%sGTO.House.%d.rdb",HousesDB,Houses[i][Houses_DBID]);
if(!dini_Exists(housesdbname)) {dini_Create(housesdbname);}

dini_Set(housesdbname,"Name",Houses[i][Houses_Name]);
dini_IntSet(housesdbname,"Cost",Houses[i][Houses_Cost]);
dini_Set(housesdbname,"Gang",Houses[i][Houses_Gang]);
dini_IntSet(housesdbname,"GangSQLID",Houses[i][Houses_GangSQLID]);
dini_IntSet(housesdbname,"UpKeep",Houses[i][Houses_UpKeep]);
dini_IntSet(housesdbname,"UpKeepLeft",Houses[i][Houses_UpKeepLeft]);
//dini_IntSet(housesdbname,"Buyout",Houses[i][Houses_Buyout]);
dini_IntSet(housesdbname,"3dtcolor",Houses[i][Houses_3dtcolor]);
dini_IntSet(housesdbname,"MinGangXP",Houses[i][Houses_MinGangXP]);
return;
}

public HouseMakeOwnerless(id,save,upd)
{
/*
	new hdbname[MAX_STRING];
	format(hdbname,sizeof(hdbname),"%sGTO.Houses.%s.txt",HousesDB,Houses[id][Houses_Name]);
	if (!dini_Exists(hdbname)) {dini_Create(hdbname);}

//	set(Houses[id][Houses_Owner],"Unknown");
//	dini_Set(hdbname,"Owner",Houses[id][Houses_Owner]);

	Houses[id][Houses_GangSQLID] = 0;
	dini_Set(hdbname,"gsqlid","0");

	set(Houses[id][Houses_Gang],"Unknown");
	dini_Set(hdbname,"Gang",Houses[id][Houses_Gang]);

	Houses[id][Houses_UpKeepLeft] = 0;
	dini_Set(hdbname,"UpKeepLeft","0");
	
	Houses[id][Houses_3dtcolor] = COLOUR_PLAYER;
*/
	Houses[id][Houses_GangSQLID] = 0;
	set(Houses[id][Houses_Gang],"Unknown");
	Houses[id][Houses_UpKeepLeft] = 0;
	Houses[id][Houses_3dtcolor] = COLOUR_PLAYER;
	
	for(new playerid=0; playerid<MAX_PLAYERS; playerid++) {
		RemovePlayerMapIcon(playerid, mapicon[id]);
	}
	
	if(Houses[id][Houses_GangSQLID] > 0)
	{
 		mapicon[id] = CreateStreamMapIcon(32, HousesCP[id][Coord_X], HousesCP[id][Coord_Y], HousesCP[id][Coord_Z]);
	}
	else
	{
	    mapicon[id] = CreateStreamMapIcon(31, HousesCP[id][Coord_X], HousesCP[id][Coord_Y], HousesCP[id][Coord_Z]);
	}
	
	if(save){HousesSave(id);}
	if(upd){UpdateHouse3D(id);}
	
	return 1;
}

public HousesInit()
{

//new query[128];
//new DBResult:RES;

	for (new id=0;id<MAX_HOUSES;id++)
	{
		//AddActiveCheckpoint(HousesCP[id][Coord_X],HousesCP[id][Coord_Y],HousesCP[id][Coord_Z],20,8);
		AddStaticPickup(1273,49,HousesCP[id][Coord_X],HousesCP[id][Coord_Y],HousesCP[id][Coord_Z]);	//зеленый домик
		mapicon[id] = CreateStreamMapIcon(31, HousesCP[id][Coord_X], HousesCP[id][Coord_Y], HousesCP[id][Coord_Z]);

		if(Houses[id][Houses_MinGangXP] == 1)
		{
			new temp[MAX_STRING];
			format(temp,sizeof(temp), "Для выхода из дома нажми 'Num 4'");
			housextextid[id]=Create3DTextLabel(temp,COLOUR_WHITE,2807.619873,-1171.899902,1025.570312,40.0,Houses[id][Houses_VW],1);
			CreatePickup(1318,1,2807.619873,-1171.899902,1025.570312,Houses[id][Houses_VW]); // Вход в банк SF
		} else {
			new temp[MAX_STRING];
			format(temp,sizeof(temp), "Для выхода из дома нажми 'Num 4'");
			housextextid[id]=Create3DTextLabel(temp,COLOUR_WHITE,2324.419921,-1145.568359,1050.710083,40.0,Houses[id][Houses_VW],1);
		    CreatePickup(1318,1,2324.419921,-1145.568359,1050.710083,Houses[id][Houses_VW]); // Вход в банк SF
		}

		if(Houses[id][Houses_GangSQLID] > 0)
		{
            mapicon[id] = CreateStreamMapIcon(32, HousesCP[id][Coord_X], HousesCP[id][Coord_Y], HousesCP[id][Coord_Z]);
		}
		else
		{
		    mapicon[id] = CreateStreamMapIcon(31, HousesCP[id][Coord_X], HousesCP[id][Coord_Y], HousesCP[id][Coord_Z]);
		}

		Houses3DT[id] = Create3DTextLabel( Houses[id][Houses_Name], Houses[id][Houses_3dtcolor], HousesCP[id][Coord_X], HousesCP[id][Coord_Y], HousesCP[id][Coord_Z] + 2, 50.000, 0, 1);

		UpdateHouse3D(id);
	}
	WriteLog("Housing checkpoints and icones initialised");
}

public GetKeepTime(id)
{
new time;
time = Houses[id][Houses_UpKeepLeft]/Houses[id][Houses_UpKeep];
time = time*(-1) + KeepC;
return time/House_Delay_In_H;
}

public SetHouse3DTColor(id,color)
{
Houses[id][Houses_3dtcolor] = color;
}

public UpdateHouse3D(id)
{
new temp[128];
new price;
price = Houses[id][Houses_Cost] - Houses[id][Houses_UpKeepLeft];

/*
if(strcomp(Houses[id][Houses_Owner], "Unknown", true) == 1 && strcomp(Houses[id][Houses_Gang], "Unknown", true) == 1)
{
format(temp,sizeof(temp),"Дом: %s\nНи кому не принадлежит\nЦена: %d",Houses[id][Houses_Name],price);
}
else
{
format(temp,sizeof(temp),"Дом: %s\nВладелец: %s\nБанда: %s\nЦена: %d",Houses[id][Houses_Name],Houses[id][Houses_Owner],Houses[id][Houses_Gang],price);
}
*/

if(Houses[id][Houses_GangSQLID] < 1)
{
format(temp,sizeof(temp),"Дом: %s\nНи кому не принадлежит\nЦена: %d\nДля вызова меню нажми 'Num 4'",Houses[id][Houses_Name],price);
}
else
{
format(temp,sizeof(temp),"Дом: %s\nБанда: %s\nЦена: %d\nДля вызова меню нажми 'Num 4'",Houses[id][Houses_Name],Houses[id][Houses_Gang],price);
}

Update3DTextLabelText(Houses3DT[id], Houses[id][Houses_3dtcolor], temp);

//Delete3DTextLabel(Houses3DT[id]);
//Houses3DT[id] = Create3DTextLabel( temp, GangColours[id+1][colour_code], HousesCP[id][Coord_X], HousesCP[id][Coord_Y], HousesCP[id][Coord_Z] + 2, 50.000, 0, 0);

return 1;
}


public IsPlayerAtHouse(playerid)
{
	for (new id=0;id<MAX_HOUSES;id++)
	{
		if (IsPlayerInRangeOfPoint(playerid,1.0,HousesCP[id][Coord_X],HousesCP[id][Coord_Y],HousesCP[id][Coord_Z]))
		{
			return 1;
		}
	}
	return 0;
}

forward IsPlayerAtExitHouse(playerid);
public IsPlayerAtExitHouse(playerid)
{
	for (new id=0;id<MAX_HOUSES;id++)
	{
		if(Houses[id][Houses_MinGangXP] == 1)
		{
			if (IsPlayerInRangeOfPoint(playerid,1.0,2807.619873,-1171.899902,1025.570312))
			{
			    //printf("Сработал принт в доме: %d",id);
				return 1;
			}
		} else {
			if (IsPlayerInRangeOfPoint(playerid,1.0,2324.419921,-1145.568359,1050.710083))
			{
			    //printf("Сработал принт в доме: %d",id);
				return 1;
			}
		}
	}
	return 0;
}

public GetHouseID(playerid)
{
	new lookupid=-1;
	for (new id=0;id<MAX_HOUSES;id++)
	{
		if (IsPlayerInRangeOfPoint(playerid,1.0,HousesCP[id][Coord_X],HousesCP[id][Coord_Y],HousesCP[id][Coord_Z])) lookupid = id;
	}
	return lookupid;
}

public HousesCommandHandler(playerid,text[])
{
	if (!IsPlayerConnected(playerid)) return 0;

	new cmd[20];
	new idx;

	set(cmd,strcharsplit(text, idx,strchar(" ")));
	if (strlen(cmd) == 0) return 0;


	if (!strcmp("/hmenu", cmd, true, 5))
	{
		if (!IsPlayerAtHouse(playerid))
		{
			SendPlayerFormattedText(playerid,  lang_texts[8][2]  , 0,COLOUR_RED);
			return 1;
		}
		else
		{
		TogglePlayerControllable(playerid, 0);
		DialogPlayerHouse(playerid);
// 	   	if(IsValidMenu(HouseMenu)) ShowMenuForPlayer(HouseMenu, playerid);
		return 1;
		}
	}

	//-- houseinfo --
	if((strcomp(cmd, "/houseinfo", true) == 1) || (strcomp(cmd, "/hinfo", true) == 1))
	{
		if (!IsPlayerAtHouse(playerid))
		{
			SendPlayerFormattedText(playerid,  lang_texts[8][2]  , 0,COLOUR_RED);
			return 1;
		}
		else
		{
		FHouseInfo(playerid);
		}
	return 1;
	}
	//---------------------

	//-- buyhouses --
	if((strcomp(cmd, "/housebuy", true) == 1) || (strcomp(cmd, "/hbuy", true) == 1))
	{
		if (!IsPlayerAtHouse(playerid))
		{
			SendPlayerFormattedText(playerid,  lang_texts[8][14]  , 0,COLOUR_RED);
			return 1;
		}
		else
		{
		FHouseBuy(playerid);
		}
	return 1;
	}
	//---------------------

	//-- sell house --
	if((strcomp(cmd, "/housesell", true) == 1) || (strcomp(cmd, "/hsell", true) == 1))
	{
		if (!IsPlayerAtHouse(playerid))
		{
			SendPlayerFormattedText(playerid,  lang_texts[8][22]  , 0,COLOUR_RED);
			return 1;
		}
		else
		{
		FHouseSell(playerid);
		}
	return 1;
	}
	//--------------------
/*
//-- set buyout --
	if(strcomp(cmd, "/sethbuyout", true) == 1)
	{
		new buyoutamount;
		buyoutamount = strval(strcharsplit(text, idx,strchar(" ")));

		if ((buyoutamount < -99999999) || (buyoutamount == 0) || (buyoutamount > 99999999) || (buyoutamount > Player[playerid][Money]))
		{
			SendPlayerFormattedText(playerid, lang_texts[8][29] , 0,COLOUR_RED);
			return 1;
		}

	if (!IsPlayerAtHouse(playerid))
		{
			SendPlayerFormattedText(playerid,  lang_texts[8][30]  , 0,COLOUR_RED);
			return 1;
		} else {
			new id=GetHouseID(playerid);
			new temp[MAX_STRING];
			if (id > -1)
			{
				if (IsPlayerRegistered(playerid))
				{
					if(strcomp(Houses[id][Houses_Owner], oGetPlayerName(playerid), true) == 0)
				{
						SendPlayerFormattedText(playerid,  lang_texts[8][31] , 0,COLOUR_RED);
					} else if (GetPlayerMoney(playerid) < Houses[id][Houses_UpKeepLeft] || GetPlayerMoney(playerid) == 0){
						SendPlayerFormattedText(playerid,  lang_texts[8][46] , 0,COLOUR_RED);
					return 1;
						} else {
						new newbuyout;
						newbuyout = Houses[id][Houses_Buyout] + buyoutamount;
							
						if(newbuyout < 0 || newbuyout > MAX_HOUSEBUYSELL)
 					{
							SendPlayerFormattedText(playerid, lang_texts[8][32] , 0,COLOUR_RED);
							return 1;
						}
						
						oGivePlayerMoney(playerid,0-buyoutamount,1);
						Houses[id][Houses_Buyout] = newbuyout;
						new dinifilename[MAX_STRING];
						format(dinifilename,sizeof(dinifilename),"%sGTO.Houses.%s.txt",HousesDB,Houses[id][Houses_Name]);
						if (dini_Exists(dinifilename))
						{
							valstr(temp,Houses[id][Houses_Buyout]);
							dini_Set(dinifilename,"Buyout",temp);
							set(temp,nullstr);
						}
					if(buyoutamount > 0)
						{
							format(temp,sizeof(temp), lang_texts[8][33] ,Houses[id][Houses_Buyout]);
							SendPlayerFormattedText(playerid, temp, 0,COLOUR_GREEN);
							set(temp,nullstr);
							new logstring[256];
							format(logstring, sizeof (logstring), "player: %d:  %s: increased the buy out of '%s' (house) to $%d",playerid,oGetPlayerName(playerid),Houses[id][Houses_Name],Houses[id][Houses_Buyout]);
							WriteLog(logstring);
						} else {
							format(temp,sizeof(temp), lang_texts[8][34] ,Houses[id][Houses_Buyout]);
							SendPlayerFormattedText(playerid, temp, 0,COLOUR_GREEN);
							set(temp,nullstr);
							new logstring[256];
							format(logstring, sizeof (logstring), "player: %d:  %s: decreased the buy out of '%s' (house) to $%d",playerid,oGetPlayerName(playerid),Houses[id][Houses_Name],Houses[id][Houses_Buyout]);
							WriteLog(logstring);
						}
					}
				} else {
					SendPlayerFormattedText(playerid,  lang_texts[8][35] , 0,COLOUR_RED);
					SendPlayerFormattedText(playerid,  lang_texts[8][36] , 0,COLOUR_RED);
				}
			} else {
				SendPlayerFormattedText(playerid,  lang_texts[8][37] , 0,COLOUR_RED);
			}
		}
		return 1;
	}
	//----------------------
*/

	//-- houses list --
	if(strcomp(cmd, "/houses", true) == 1)
	{
	FHouseHouses(playerid);
	return 1;
	}

	//-------------------------

	//--  my houses list --
	if(strcomp(cmd, "/myhouses", true) == 1)
	{
	FHouseMyHouses(playerid);
	return 1;
	}

	//-------------------------
	// -- upkeep --
	if(strcomp(cmd, "/upkeep", true) == 1)
	{
		if (!IsPlayerAtHouse(playerid))
		{
			SendPlayerFormattedText(playerid,  lang_texts[8][43]  , 0,COLOUR_RED);
			return 1;
		}
		
		new tmp[256];
		tmp = strcharsplit(text, idx,strchar(" "));

		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOUR_MISC,  lang_texts[8][54] );
			return 1;
		}
		
		new money;
		money = strval(tmp);
		
		FHouseKeep(playerid,money);
		return 1;

	}


	//--------------------------
	return 0;
}

//-------RECOMPIL FOR HOUSE MENUS
public FHouseInfo(playerid) {

			new id=GetHouseID(playerid);
			if (id > -1)
			{
				new temp[MAX_STRING];
				format(temp,sizeof(temp), lang_texts[8][3] ,Houses[id][Houses_Name]);
				SendPlayerFormattedText(playerid, temp, 0,COLOUR_GREEN);
				set(temp,nullstr);
//				if(strcomp(Houses[id][Houses_Owner], "Unknown", true) == 0 && strcomp(Houses[id][Houses_Gang], "Unknown", true) == 0)
				if(Houses[id][Houses_GangSQLID] > 0)
				{
					//format(temp,sizeof(temp), lang_texts[8][4] ,Houses[id][Houses_Gang],Houses[id][Houses_Owner]);
					format(temp,sizeof(temp), lang_texts[8][4] ,Houses[id][Houses_Gang]);
					
					SendPlayerFormattedText(playerid, temp, 0,COLOUR_GREEN);
					set(temp,nullstr);
					new price;
					price = Houses[id][Houses_Cost] - Houses[id][Houses_UpKeepLeft];
					new UpKeep;
					UpKeep = Houses[id][Houses_UpKeep];
					//if(strcomp(Houses[id][Houses_Owner], oGetPlayerName(playerid), true) == 0 || strcomp(Houses[id][Houses_Gang], PlayerGangName[playerid], true) == 0)
					if(Houses[id][Houses_GangSQLID] != GangSQLID[ PlayerGangID[playerid] ])

					{
						format(temp,sizeof(temp), lang_texts[8][5] ,price);
						SendPlayerFormattedText(playerid, temp, 0,COLOUR_GREEN);
						set(temp,nullstr);
						
						format(temp,sizeof(temp), lang_texts[8][6] ,UpKeep);
						SendPlayerFormattedText(playerid, temp, 0,COLOUR_GREEN);
						set(temp,nullstr);
						
						format(temp,sizeof(temp), lang_texts[8][7] ,Houses[id][Houses_UpKeepLeft], UpKeep*2800);
						SendPlayerFormattedText(playerid, temp, 0,COLOUR_GREEN);
						set(temp,nullstr);
						
						
						SendPlayerFormattedText(playerid,  lang_texts[8][8] , 0,COLOUR_GREEN);
					}
				}
				else
				{
					SendPlayerFormattedText(playerid,  lang_texts[8][9] , 0,COLOUR_GREEN);
					format(temp,sizeof(temp), lang_texts[8][10] ,Houses[id][Houses_Cost]-Houses[id][Houses_UpKeepLeft]);
					SendPlayerFormattedText(playerid, temp, 0,COLOUR_GREEN);
					set(temp,nullstr);
					
					format(temp,sizeof(temp), lang_texts[8][11] ,Houses[id][Houses_UpKeep]);
					SendPlayerFormattedText(playerid, temp, 0,COLOUR_GREEN);
					set(temp,nullstr);
					
					SendPlayerFormattedText(playerid,  lang_texts[8][12] , 0,COLOUR_GREEN);
				}
			} else { SendPlayerFormattedText(playerid,  lang_texts[8][13] , 0,COLOUR_RED); }
			return 1;
}

public FHouseHouses(playerid) {
		new temp[MAX_STRING];
		for (new id=0;id<MAX_HOUSES;id++)
		{
//			if(strcomp(Houses[id][Houses_Owner], "Unknown", true) == 0)
//			{
//				format(temp,sizeof(temp), lang_texts[8][38] ,Houses[id][Houses_Name],Houses[id][Houses_Gang],Houses[id][Houses_Owner]);

			if(Houses[id][Houses_GangSQLID] > 0)
			{
				format(temp,sizeof(temp), lang_texts[8][38] ,Houses[id][Houses_Name],Houses[id][Houses_Gang]);
				
				SendPlayerScrollingText(playerid,temp);
				set(temp,nullstr);
			}
			else
			{
				format(temp,sizeof(temp), lang_texts[8][39] ,Houses[id][Houses_Name]);
				SendPlayerScrollingText(playerid,temp);
				set(temp,nullstr);
			}
		}
		return 1;
}


public FHouseBuy(playerid) {

	new id=GetHouseID(playerid);
	new temp[MAX_STRING];
	
	if (id == -1) {
	SendPlayerFormattedText(playerid,  lang_texts[8][21] , 0,COLOUR_RED);
	return 1;}
	
	if(!IsPlayerRegistered(playerid)) {
	SendPlayerFormattedText(playerid,  lang_texts[8][20] , 0,COLOUR_RED);
	return 1;}
		
	new gangid = PlayerGangID[playerid];
		
	if(PlayerGangID[playerid] == -1) {
	SendPlayerFormattedText(playerid,  lang_texts[8][19] , 0,COLOUR_RED);
	return 1;}
		
	if(GangMembers[gangid][0][member_sqlid] != PlayerSQLID[playerid]) {
	SendPlayerFormattedText(playerid,  lang_texts[8][19] , 0,COLOUR_RED);
	return 1;}
		
	if (ganghouse(playerid,0) != -1) {
	SendPlayerFormattedText(playerid,  lang_texts[8][52] , 0,COLOUR_RED);
	return 1;}
						
	new price;
	price = Houses[id][Houses_Cost] - Houses[id][Houses_UpKeepLeft];
	
	if(Player[playerid][Money] < price) {
	SendPlayerFormattedText(playerid,  lang_texts[8][18] , 0,COLOUR_RED);
	return 1;}

	CheckGangLevel(gangid);
	
	if(Gangs[gangid][gang_level] < Houses[id][Houses_MinGangXP]) {
	SendPlayerFormattedText(playerid,  lang_texts[8][57] , Houses[id][Houses_MinGangXP], COLOUR_RED);
	return 1;
	}
	
	if ( GangMembers[gangid][0][member_sqlid] == PlayerSQLID[playerid] || PlayerSQLID[playerid] == Gangs[gangid][gang_zam])
	{ // player is not leader of this gang
	
	if(Houses[id][Houses_GangSQLID] == GangSQLID[ PlayerGangID[playerid] ]) {
	SendPlayerFormattedText(playerid,  lang_texts[8][15] , 0,COLOUR_RED);
	}
	else
	{
		if(Houses[id][Houses_GangSQLID] > 0) // Если дом чей-то
		{
		
			if(Gangs[gangid][gang_level] < GANG_XP_BUYOUT)
			{
			SendPlayerFormattedText(playerid,  lang_texts[8][56] , GANG_XP_BUYOUT, COLOUR_RED);
			return 1;
			}
		
			new gangownerid = -1;
			for (new gid = 0; gid < MAX_GANGS; gid++)
			{
			if (!IsGangOnline(gid)) {continue;}

			if(Houses[id][Houses_GangSQLID] == GangSQLID[gid])
			{
			format(temp,sizeof(temp), lang_texts[8][16], Gangs[gangid][gang_name],Houses[id][Houses_Name]);
			SendGangMessage(gid,temp,COLOUR_GREEN);
			set(temp,nullstr);
			gangownerid = gid;
			}
			}
		

			if (gangownerid > -1) // Если банда-хозяин онлайн
			{ GiveGangMoney(gangownerid,price,1); } else
			{ // А если оффлайн
			
			new tempmoney;
			new DBResult:res;
			new query[128];

			format(query,sizeof(query),"SELECT bank FROM gangs WHERE id = %d LIMIT 1",Houses[id][Houses_GangSQLID]);
			res = db_query(ReunionDB,query);
									
				if(db_num_rows(res))
				{
				new mvar[32];
				db_get_field(res, 0, mvar, sizeof(mvar));
				tempmoney = strval(mvar) + price;
				
				if(tempmoney > MAX_GANG_BANK) {tempmoney = MAX_GANG_BANK;}

				format(query, sizeof(query), "UPDATE gangs SET bank=%d WHERE id=%d", tempmoney, Houses[id][Houses_GangSQLID]);
				xdb_query(ReunionDB,query);
				}
			}
			set(temp,nullstr);
		}
		
		oGivePlayerMoney(playerid,0-price,1);
		
		Houses[id][Houses_GangSQLID] = GangSQLID[ PlayerGangID[playerid] ];
		set(Houses[id][Houses_Gang],PlayerGangName[playerid]);
		SendPlayerFormattedText(playerid,  lang_texts[8][53] , 0,COLOUR_WHITE);
	
		//Houses[id][Houses_Buyout] = price; // почем купил по том и продавать (если не перекупят! ;) )
		Houses[id][Houses_UpKeepLeft] = 0; // залог 0
		Houses[id][Houses_3dtcolor] = PlayerGangColour(playerid);

		HousesSave(id);
		UpdateHouse3D(id);
		
		for(new i=0; i<MAX_PLAYERS; i++) {
			RemovePlayerMapIcon(i, mapicon[id]);
		}
		
		if(Houses[id][Houses_GangSQLID] > 0)
		{
            mapicon[id] = CreateStreamMapIcon(32, HousesCP[id][Coord_X], HousesCP[id][Coord_Y], HousesCP[id][Coord_Z]);
		}
		else
		{
		    mapicon[id] = CreateStreamMapIcon(31, HousesCP[id][Coord_X], HousesCP[id][Coord_Y], HousesCP[id][Coord_Z]);
		}
		
		format(temp,sizeof(temp), lang_texts[8][17] ,Houses[id][Houses_Name]);
		SendPlayerFormattedText(playerid, temp, 0,COLOUR_GREEN);
		set(temp,nullstr);
								
		new logstring[256];
		format(logstring, sizeof (logstring), "player: %d:  %s: bought the '%s' (house)",playerid,oGetPlayerName(playerid),Houses[id][Houses_Name]);
							
		WriteLog(logstring);
	}
 } else {
    ShowPlayerDialog(playerid, S_GUI_02, 0,"База банды","Базу банды может купить лидер или зам.лидера!","ОК","");
 }

return 1;
}

public FHouseSell(playerid) {

		new id=GetHouseID(playerid);
		new temp[MAX_STRING];
		new gangid = PlayerGangID[playerid];
		
		if (id < 0) {
		SendPlayerFormattedText(playerid,  lang_texts[8][28] , 0,COLOUR_RED);
		return 1; }
		
		if (!IsPlayerRegistered(playerid)) {
		SendPlayerFormattedText(playerid,  lang_texts[8][26] , 0,COLOUR_RED);
		return 1; }

		if(Houses[id][Houses_GangSQLID] != GangSQLID[ PlayerGangID[playerid] ]) {
		SendPlayerFormattedText(playerid,  lang_texts[8][23] , 0,COLOUR_RED);
		return 1; }
		
		if ( GangMembers[gangid][0][member_sqlid] == PlayerSQLID[playerid] || PlayerSQLID[playerid] == Gangs[gangid][gang_zam])
		{ // player is not leader of this gang
		
		new price;
						
		price = Houses[id][Houses_Cost] - Houses[id][Houses_UpKeepLeft];
		
		oGivePlayerMoney(playerid, price, 1);

		HouseMakeOwnerless(id,1,1);
		
		for(new i=0; i<MAX_PLAYERS; i++) {
			RemovePlayerMapIcon(i, mapicon[id]);
		}

		if(Houses[id][Houses_GangSQLID] > 0)
		{
            mapicon[id] = CreateStreamMapIcon(32, HousesCP[id][Coord_X], HousesCP[id][Coord_Y], HousesCP[id][Coord_Z]);
		}
		else
		{
		    mapicon[id] = CreateStreamMapIcon(31, HousesCP[id][Coord_X], HousesCP[id][Coord_Y], HousesCP[id][Coord_Z]);
		}
						
		format(temp,sizeof(temp), lang_texts[8][24] ,Houses[id][Houses_Name]);
		SendPlayerFormattedText(playerid, temp, 0,COLOUR_GREEN);
		set(temp,nullstr);
		
		new logstring[256];
		format(logstring, sizeof (logstring), "player: %d:  %s: sold the '%s' (house)",playerid,oGetPlayerName(playerid),Houses[id][Houses_Name]);
		WriteLog(logstring);
	 	} else {
    	ShowPlayerDialog(playerid, S_GUI_02, 0,"База банды","Базу банды может купить лидер или зам.лидера!","ОК","");
		}
return 1;
}

public FHouseEnter(playerid)
{
	new id=GetHouseID(playerid);
	
	if(Houses[id][Houses_GangSQLID] > 0)
	{
	    new string[MAX_STRING];
	    if(Houses[id][Houses_GangSQLID] == PlayerGangSQLID[playerid]){
		if(Houses[id][Houses_MinGangXP] == 1)
		{
			SetPlayerPosEx(playerid,2807.619873,-1171.899902,1025.570312);
			//SetPlayerFacingAngle(playerid,180);
			SetPlayerInterior(playerid,8);
        	oSetPlayerVirtualWorld(playerid,Houses[id][Houses_VW]); // Виртуальный мир дома
		} else {
			SetPlayerPosEx(playerid,2324.419921,-1145.568359,1050.710083);
			//SetPlayerFacingAngle(playerid,180);
			SetPlayerInterior(playerid,12);
        	oSetPlayerVirtualWorld(playerid,Houses[id][Houses_VW]); // Виртуальный мир дома
		}
		} else {
			format(string,sizeof(string), lang_texts[8][23] , Houses[id][Houses_Name]);
			SendPlayerFormattedText(playerid, string, 0,COLOUR_RED);
		}
	} else {
		new string[MAX_STRING];
		format(string,sizeof(string), lang_texts[8][39] , Houses[id][Houses_Name]);
		SendPlayerFormattedText(playerid, string, 0,COLOUR_RED);
	}
	return 1;
}

public FHouseMyHouses(playerid) {
		new temp[MAX_STRING];
		new count = 0;
		for (new id=0;id<MAX_HOUSES;id++)
		{
//			if(strcomp(Houses[id][Houses_Gang], PlayerGangName[playerid], true) == 1)
			if(Houses[id][Houses_GangSQLID] == GangSQLID[ PlayerGangID[playerid] ])
			{
				count++;
//				format(temp,sizeof(temp), lang_texts[8][40] ,Houses[id][Houses_Name],Houses[id][Houses_Owner],Houses[id][Houses_Cost]);
				format(temp,sizeof(temp), lang_texts[8][40] ,Houses[id][Houses_Name],Houses[id][Houses_Cost]);
				SendPlayerScrollingText(playerid,temp);
				set(temp,nullstr);
				
				format(temp,sizeof(temp), lang_texts[8][41] ,Houses[id][Houses_UpKeep], Houses[id][Houses_UpKeepLeft]);
				SendPlayerScrollingText(playerid,temp);
				set(temp,nullstr);
				
			}
		}
		if(count < 1)
		{
			SendPlayerFormattedText(playerid,  lang_texts[8][42] , 0,COLOUR_RED);
		}
		return 1;
	}


public FHouseKeep(playerid, money) {

	new id=GetHouseID(playerid);

	if (id == -1) {
	SendPlayerFormattedText(playerid,  lang_texts[8][21] , 0,COLOUR_RED);
	return 1;}
	
	if(!IsPlayerRegistered(playerid)) {
	SendPlayerFormattedText(playerid,  lang_texts[8][48] , 0,COLOUR_RED);
	return 1;}
	
	if(PlayerGangID[playerid] == -1) {
	SendPlayerFormattedText(playerid,  lang_texts[8][19] , 0,COLOUR_RED);
	return 1;}
	
	new gangid = PlayerGangID[playerid];
	
	if(Houses[id][Houses_GangSQLID] != GangSQLID[gangid]) {
	SendPlayerFormattedText(playerid,  lang_texts[8][49] , 0,COLOUR_RED);
	return 1;}
	
	if(money <= 0) {
	SendPlayerFormattedText(playerid,  lang_texts[8][55] , 0,COLOUR_RED);
	return 1;
	}
					
	if (GetPlayerMoney(playerid) < money) {
	SendPlayerFormattedText(playerid,  lang_texts[8][46] , 0,COLOUR_RED);
	return 1;
	}
	
	if(Houses[id][Houses_UpKeepLeft] == 0) {
	SendPlayerFormattedText(playerid,  lang_texts[8][45] , 0,COLOUR_RED);
	return 1;
	}
	
	if(money >=  Houses[id][Houses_UpKeepLeft])
	{
	oGivePlayerMoney(playerid, 0 - Houses[id][Houses_UpKeepLeft],1);
	Houses[id][Houses_UpKeepLeft] = 0;
	}
	else
	{
	oGivePlayerMoney(playerid, 0 - money,1);
	Houses[id][Houses_UpKeepLeft] = Houses[id][Houses_UpKeepLeft] - money;
	}
								
	SendPlayerFormattedText(playerid,  lang_texts[8][44] , 0,COLOUR_GREEN);
								
	HousesSave(id);
	UpdateHouse3D(id);
	
return 1;							
}

//--------------------------------------------------------------------------------



public ganghouse(playerid,text) {
	new hova = -1;
	if (!IsPlayerRegistered(playerid)) return hova;
	if (PlayerGangID[playerid] == -1) return hova;
	for (new id=0;id<MAX_HOUSES;id++)
	{
//		if (!strcmp(Houses[id][Houses_Gang], PlayerGangName[playerid], true))
		if(Houses[id][Houses_GangSQLID] == GangSQLID[ PlayerGangID[playerid] ])
		{
			hova = id;
			if(text)
			{
			new tmp[MAX_STRING];
			format(tmp,sizeof(tmp), lang_texts[8][51] , Houses[id][Houses_Name], Houses[id][Houses_UpKeepLeft],Houses[id][Houses_UpKeep]*KeepC);
			SendPlayerFormattedText(playerid,tmp,0, COLOUR_RED);
			}
			break;
		}

	}
	return hova;
}


stock GetGangHouseName(gangid)
{
new hname[32];
set(hname,"< Нет дома >");
if (GangSQLID[gangid] < 1) return hname;
for (new id=0;id<MAX_HOUSES;id++)
	{
		if(Houses[id][Houses_GangSQLID] == GangSQLID[gangid])
		{
		set(hname,Houses[id][Houses_Name]);
		break;
		}

	}
return hname;
}


public GetGangHouseID(gangsqlid)
{
new hova = -1;
if (gangsqlid < 1) return hova;
for (new id=0;id<MAX_HOUSES;id++)
	{
		if (Houses[id][Houses_GangSQLID] == gangsqlid)
		{
		hova = id;
		break;
		}

	}
	return hova;
}

/*
public GetPlayerHouseID(playername[])
{
new hova = -1;
if (!strlen(playername)) return hova;
for (new id=0;id<MAX_HOUSES;id++)
	{
		if (!strcmp(Houses[id][Houses_Owner], playername, true))
		{
		hova = id;
		}

	}
	return hova;
}
*/

public gang2house(playerid,i)
{
	SetPlayerPosEx(playerid, HousesCP[i][Coord_X], HousesCP[i][Coord_Y], HousesCP[i][Coord_Z]);
}

/*
public HousesSync()
{
KeepTimeAll++;
if(KeepTimeAll >= HOUSES_UPKEEPTIME)
{HouseKeepUp(); KeepTimeAll = 0;}

for (new id=0;id<MAX_HOUSES;id++)
{
HouseSaveKeepTime[id]++;

if(HouseSaveKeepTime[id] >= HOUSES_SAVETIME)
{
	if(Houses[id][Houses_GangSQLID] != 0)
	{
HouseSaveKeepTime[id] = 0;
new query[128];
format(query, sizeof(query), "UPDATE houses SET cost=%d, gang='%s', gsqlid=%d, upkeep=%d, upkeepl=%d, buyout=%d, color='%d' WHERE id=%d", Houses[id][Houses_Cost], Houses[id][Houses_Gang], Houses[id][Houses_GangSQLID], Houses[id][Houses_UpKeep], Houses[id][Houses_UpKeepLeft], Houses[id][Houses_Buyout], Houses[id][Houses_3dtcolor], Houses[id][Houses_SQLID]);
xdb_query(ReunionDB,query);
	}
}
}
return 1;
}
*/

public HouseKeepUp()
{
	new upkeepamount;
	new upkeep;
	new upkeepleft;
	for (new id=0;id<MAX_HOUSES;id++)
	{
		if(Houses[id][Houses_GangSQLID] > 0)
		{
			upkeep = Houses[id][Houses_UpKeep];// цена содержания
			upkeepleft = Houses[id][Houses_UpKeepLeft];// долг по содержанию
			upkeepamount = upkeep + upkeepleft;

			if (upkeepamount < upkeep*KeepC)
			{
				Houses[id][Houses_UpKeepLeft] = upkeepamount;
			}
			else
			{
				HouseMakeOwnerless(id,0,0);
			}
		UpdateHouse3D(id);
	 	HousesSave(id);
		}

	}
}


public DialogPlayerHouse(playerid)
{
if (!IsPlayerConnected(playerid)) return 0;
new s[MAX_STRING];
format(s,sizeof(s), "Информация\nПриобрести\nПродать\nВнести деньги на содержание\nВсе дома\n{00FF00}Войти в дом", oGetPlayerName(playerid));
ShowPlayerDialog(playerid,HGUI+1,2,":: ДОМА ::",s,"ОК ","НАЗАД");
return 1;
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////СИСТЕМА ОТЕЛЕЙ//////////////////////////////////////

#define MAX_HOTELS 60

forward HotelsInit();
forward IsPlayerAtHotel(playerid);
forward OnPlayerEnterHotelsCheckpoint(playerid);
forward GetHotelID(playerid);
forward FHotelHotels(playerid);
forward FHotelBuy(playerid);
forward FHotelSell(playerid);

enum HotelInfo {
	Hotel_DBID,
	Hotel_Name[MAX_STRING],  	// house name
	Hotel_Cost,     			// cost
	Hotel_Owner[MAX_NAME]   	// owner
}

new Hotels[MAX_HOTELS][HotelInfo] = {
	{1,"Hotel 'Sarcophagus' Room 1",5000,"Unknown"},
	{2,"Hotel 'Sarcophagus' Room 2",5000,"Unknown"},
	{3,"Hotel 'Sarcophagus' Room 3",5000,"Unknown"},
	{4,"Hotel 'Sarcophagus' Room 4",5000,"Unknown"},
	{5,"Hotel 'Sarcophagus' Room 5",5000,"Unknown"},
	{6,"Hotel 'Sarcophagus' Room 6",5000,"Unknown"},
	{7,"Hotel 'Lalonca' Room 1",4000,"Unknown"},
	{8,"Hotel 'Lalonca' Room 2",4000,"Unknown"},
	{9,"Hotel 'Lalonca' Room 3",4000,"Unknown"},
	{10,"Hotel 'Lalonca' Room 4",4000,"Unknown"},
	{11,"Hotel 'Lalonca' Room 5",4000,"Unknown"},
	{12,"Hotel 'Lalonca' Room 6",4000,"Unknown"},
	{13,"Hotel 'Lalonca' Room 7",4000,"Unknown"},
	{14,"Hotel 'Lalonca' Room 8",4000,"Unknown"},
	{15,"Hotel 'Western Renaissance' Room 1",5000,"Unknown"},
	{16,"Hotel 'Western Renaissance' Room 2",5000,"Unknown"},
	{17,"Hotel 'Western Renaissance' Room 3",5000,"Unknown"},
	{18,"Hotel 'Western Renaissance' Room 4",5000,"Unknown"},
	{19,"Hotel 'Western Renaissance' Room 5",5000,"Unknown"},
	{20,"Hotel 'Western Renaissance' Room 6",5000,"Unknown"},
	{21,"Hotel 'Western Renaissance' Room 7",5000,"Unknown"},
	{22,"Hotel 'Western Renaissance' Room 8",5000,"Unknown"},
	{23,"Hotel 'Western Renaissance' Room 9",5000,"Unknown"},
	{24,"Hotel 'Western Renaissance' Room 10",5000,"Unknown"},
	{25,"Hotel 'Western Renaissance' Room 11",5000,"Unknown"},
	{26,"Hotel 'Western Renaissance' Room 12",5000,"Unknown"},
	{27,"Hotel 'Jefferson' Room 1",1000,"Unknown"},
	{28,"Hotel 'Jefferson' Room 2",1000,"Unknown"},
	{29,"Hotel 'Jefferson' Room 3",1000,"Unknown"},
	{30,"Hotel 'Jefferson' Room 4",1000,"Unknown"},
	{31,"Hotel 'Liqour' Room 1",700,"Unknown"},
	{32,"Hotel 'Liqour' Room 2",700,"Unknown"},
	{33,"Hotel 'Liqour' Room 3",700,"Unknown"},
	{34,"Hotel 'Liqour' Room 4",700,"Unknown"},
	{35,"Hotel 'Liqour' Room 5",700,"Unknown"},
	{36,"Hotel 'Liqour' Room 6",700,"Unknown"},
	{37,"Hotel 'Verona beach' Room 1",1200,"Unknown"},
	{38,"Hotel 'Verona beach' Room 2",1200,"Unknown"},
	{39,"Hotel 'Verona beach' Room 3",1200,"Unknown"},
	{40,"Hotel 'Verona beach' Room 4",1200,"Unknown"},
	{41,"Hotel 'Embarcadero' Room 1",1000,"Unknown"},
	{42,"Hotel 'Embarcadero' Room 2",1000,"Unknown"},
	{43,"Hotel 'Embarcadero' Room 3",1000,"Unknown"},
	{44,"Hotel 'Embarcadero' Room 4",1000,"Unknown"},
	{45,"Hotel 'Embarcadero' Room 5",1000,"Unknown"},
	{46,"Hotel 'Embarcadero' Room 6",1000,"Unknown"},
	{47,"Hotel 'Embarcadero' Room 7",1000,"Unknown"},
	{48,"Hotel 'Embarcadero' Room 8",1000,"Unknown"},
	{49,"Hotel 'Embarcadero' Room 9",1000,"Unknown"},
	{50,"Hotel 'Embarcadero' Room 10",1000,"Unknown"},
	{51,"Hotel 'Embarcadero' Room 11",1000,"Unknown"},
	{52,"Hotel 'Heshburi' Room 1",1500,"Unknown"},
	{53,"Hotel 'Heshburi' Room 2",1500,"Unknown"},
	{54,"Hotel 'Heshburi' Room 3",1500,"Unknown"},
	{55,"Hotel 'Heshburi' Room 4",1500,"Unknown"},
	{56,"Hotel 'Heshburi' Room 5",1500,"Unknown"},
	{57,"Hotel 'Heshburi' Room 6",1500,"Unknown"},
	{58,"Hotel 'Heshburi' Room 7",1500,"Unknown"},
	{59,"Hotel 'Heshburi' Room 8",1500,"Unknown"},
	{60,"Hotel 'Heshburi' Room 9",1500,"Unknown"}
};

enum CoordHotels
{
    Float:Coord_X,
    Float:Coord_Y,
    Float:Coord_Z,
    Coord_I,
    Float:Coord_A
}

new HotelCP[MAX_HOTELS][CoordHotels] = {
	{2440.4143,1232.1476,14.3426,0,90.9404},											//Hotel 'Sarcophagus'
	{2440.4438,1225.6819,14.3426,0,90.0604},											//Hotel 'Sarcophagus'
	{2440.6160,1214.1837,14.3426,0,90.9270},											//Hotel 'Sarcophagus'
	{2436.6797,1210.7979,14.3426,0,90.8205},											//Hotel 'Sarcophagus'
	{2436.5137,1204.5792,14.3426,0,90.0605},											//Hotel 'Sarcophagus'
	{2436.7156,1241.7800,14.3426,0,90.3254},											//Hotel 'Sarcophagus'
	{2461.5698,1681.9615,14.2656,0,180.3505},											//Hotel 'Lalonca'
	{2476.2153,1681.9905,14.2656,0,180.8572},											//Hotel 'Lalonca'
	{2486.3052,1681.8423,14.2656,0,180.4839},											//Hotel 'Lalonca'
	{2496.1384,1682.1042,14.2656,0,180.7372},											//Hotel 'Lalonca'
	{2516.0920,1681.8757,14.2732,0,134.3505},											//Hotel 'Lalonca'
	{2515.9529,1664.7449,14.2732,0,85.3630},											//Hotel 'Lalonca'
	{2513.2937,1643.9370,14.2656,0,350.7622},											//Hotel 'Lalonca'
	{2498.3374,1643.8167,14.2656,0,350.3755},											//Hotel 'Lalonca'
	{1671.8123,1967.4525,10.8203,0,90.2333},											//Hotel 'Western Renaissance'
	{1672.1428,1986.1667,10.8203,0,90.1134},											//Hotel 'Western Renaissance'
	{1649.1516,1975.8168,10.8203,0,180.7642},											//Hotel 'Western Renaissance'
	{1630.5576,1976.8558,10.8203,0,180.8842},											//Hotel 'Western Renaissance'
	{1612.1372,1976.1007,10.8203,0,180.1375},											//Hotel 'Western Renaissance'
	{1593.5270,1976.4319,10.8203,0,180.2576},											//Hotel 'Western Renaissance'
	{1567.6499,1934.6051,10.8203,0,180.7509},											//Hotel 'Western Renaissance'
	{1530.3978,1934.6912,10.8203,0,180.8709},											//Hotel 'Western Renaissance'
	{1512.1029,1912.5833,10.8203,0,0.4860},												//Hotel 'Western Renaissance'
	{1549.0139,1911.1086,10.8203,0,0.3661},												//Hotel 'Western Renaissance'
	{1606.1299,1910.7686,10.8203,0,0.3663},												//Hotel 'Western Renaissance'
	{1663.4408,1910.8888,10.8203,0,0.7398},												//Hotel 'Western Renaissance'
	{2035.8309,-1311.1138,25.2163,0,180.6806},											//Hotel 'Jefferson'
	{2027.5508,-1311.8394,25.2261,0,180.1872},											//Hotel 'Jefferson'
	{2001.7587,-1310.9154,25.2221,0,180.9705},											//Hotel 'Jefferson'
	{1993.7098,-1311.7601,25.2249,0,180.7171},											//Hotel 'Jefferson'
	{2172.1682,-1818.4761,16.1406,0,360.6117},											//Hotel 'Liqour'
	{2158.4504,-1818.6976,16.1406,0,360.8383},											//Hotel 'Liqour'
	{2147.3855,-1814.9247,16.1406,0,280.9832},											//Hotel 'Liqour'
	{2147.5244,-1807.3510,16.1406,0,267.1965},											//Hotel 'Liqour'
	{2142.2957,-1802.9404,16.1475,0,270.9565},											//Hotel 'Liqour'
	{2192.3503,-1813.3739,13.5469,0,7.4174},											//Hotel 'Liqour'
	{890.6267,-1637.7610,14.9424,0,176.1933},											//Hotel 'Verona beach'
	{863.6597,-1636.3759,14.9297,0,178.9900},											//Hotel 'Verona beach'
	{851.7469,-1687.6461,14.9587,0,271.3585},											//Hotel 'Verona beach'
	{849.2690,-1719.3135,14.9297,0,268.5151},											//Hotel 'Verona beach'
	{822.6939,-1502.8921,13.5938,0,358.1917},											//Hotel 'Embarcadero'
	{852.5128,-1520.0636,13.5547,0,269.2043},											//Hotel 'Embarcadero'
	{873.6896,-1517.3302,13.5547,0,132.5896},											//Hotel 'Embarcadero'
	{906.5271,-1517.6080,13.5522,0,225.0009},											//Hotel 'Embarcadero'
	{903.2618,-1475.6482,13.5406,0,222.4941},											//Hotel 'Embarcadero'
	{902.2482,-1444.0073,13.5596,0,323.0517},											//Hotel 'Embarcadero'
	{824.7277,-1420.6440,14.4024,0,7.2089},												//Hotel 'Embarcadero'
	{852.4475,-1419.1675,13.3432,0,0.9424},												//Hotel 'Embarcadero'
	{880.8958,-1421.7404,14.4766,0,12.2225},											//Hotel 'Embarcadero'
	{841.0620,-1475.6190,13.6014,0,179.8341},											//Hotel 'Embarcadero'
	{810.1277,-1456.3231,13.5440,0,85.8333},											//Hotel 'Embarcadero'
	{-2512.3035,-189.0719,25.3933,0,271.4059},											//Hotel 'Heshburi'
	{-2512.4478,-170.9758,25.3772,0,270.1526},											//Hotel 'Heshburi'
	{-2512.4116,-153.9737,25.3812,0,267.0192},											//Hotel 'Heshburi'
	{-2524.5239,-143.5978,21.6429,0,2.9001},											//Hotel 'Heshburi'
	{-2541.3306,-143.6072,15.8018,0,359.7667},											//Hotel 'Heshburi'
	{-2558.0598,-144.4215,9.8520,0,29.8470},											//Hotel 'Heshburi'
	{-2576.5488,-143.8367,6.5823,0,0.3934},												//Hotel 'Heshburi'
	{-2593.1292,-158.7596,4.2356,0,83.1142},											//Hotel 'Heshburi'
	{-2593.4932,-186.1686,4.2226,0,86.8742}												//Hotel 'Heshburi'
};

//Hotels.inc--------------------------------------------------------------------
new HotelsDB[MAX_STRING] = "GTO/HotelsDB/";

HotelsLoadAll()
{
for (new i=0;i<MAX_HOTELS;i++)
{
new housesdbname[MAX_STRING];
format(housesdbname,sizeof(housesdbname),"%sGTO.Hotels.%d.rdb",HotelsDB,Hotels[i][Hotel_DBID]);
if(!dini_Exists(housesdbname)){dini_Create(housesdbname); HotelsSave(i); continue;}

set(Hotels[i][Hotel_Owner],dini_Get(housesdbname,"Name"));
Hotels[i][Hotel_Cost] = dini_Int(housesdbname,"Cost");
set(Hotels[i][Hotel_Owner],dini_Get(housesdbname,"Owner"));
}
printf("Hotels: %d | Loading complete",MAX_HOTELS);
return;
}

HotelsSave(i)
{
new housesdbname[MAX_STRING];
format(housesdbname,sizeof(housesdbname),"%sGTO.Hotels.%d.rdb",HotelsDB,Hotels[i][Hotel_DBID]);
if(!dini_Exists(housesdbname)) {dini_Create(housesdbname);}

dini_Set(housesdbname,"Name",Hotels[i][Hotel_Name]);
dini_IntSet(housesdbname,"Cost",Hotels[i][Hotel_Cost]);
dini_Set(housesdbname,"Owner",Hotels[i][Hotel_Owner]);
return;
}

new Text3D:hoteltextid[MAX_HOTELS];
new mapiconH[MAX_HOTELS];

public HotelsInit()
{
	for (new id=0;id<MAX_HOTELS;id++)
	{
		AddStaticPickup(1272,49,HotelCP[id][Coord_X],HotelCP[id][Coord_Y],HotelCP[id][Coord_Z]);	// синий домик
		mapiconH[id] = CreateStreamMapIcon(35, HotelCP[id][Coord_X], HotelCP[id][Coord_Y], HotelCP[id][Coord_Z]);
		
		new temp[MAX_STRING];
		if(strcomp(Hotels[id][Hotel_Owner],"Unknown",true) == 0)
			format(temp,sizeof(temp), "Отель %s\n Цена: %d\nСейчас принадлежит: %s\nДля вызова меню нажми 'Num 4'",Hotels[id][Hotel_Name],Hotels[id][Hotel_Cost],Hotels[id][Hotel_Owner]);
		else
			format(temp,sizeof(temp), "Отель %s\n Цена: %d\nСейчас никому не принадлежит\nДля вызова меню нажми 'Num 4'",Hotels[id][Hotel_Name],Hotels[id][Hotel_Cost]);
		hoteltextid[id]=Create3DTextLabel(temp,COLOUR_WHITE,HotelCP[id][Coord_X], HotelCP[id][Coord_Y], HotelCP[id][Coord_Z],40.0,0);
	}
}

public IsPlayerAtHotel(playerid)
{
	for (new id=0;id<MAX_HOTELS;id++)
	{
		if (IsPlayerInRangeOfPoint(playerid,1.0,HotelCP[id][Coord_X],HotelCP[id][Coord_Y],HotelCP[id][Coord_Z]))
		{
			return 1;
		}
	}
	return 0;
}

public GetHotelID(playerid)
{
	new lookupid=-1;
	for (new id=0;id<MAX_HOTELS;id++)
	{
		if (IsPlayerInRangeOfPoint(playerid,1.0,HotelCP[id][Coord_X],HotelCP[id][Coord_Y],HotelCP[id][Coord_Z])) lookupid = id;
	}
	return lookupid;
}

public FHotelHotels(playerid)
{
	new temp[MAX_STRING];
	for (new id=0;id<MAX_HOTELS;id++)
	{
		if(strcomp(Hotels[id][Hotel_Owner], "Unknown", true) == 0)
		{
			format(temp,sizeof(temp)," '%s' принадлежит %s." ,Hotels[id][Hotel_Name],Hotels[id][Hotel_Owner]);
            SendPlayerFormattedText(playerid,temp, 0,COLOUR_LIGHTRED);
			set(temp,nullstr);
		}
		else
		{
			format(temp,sizeof(temp)," '%s' никому не принадлежит.",Hotels[id][Hotel_Name]);
			SendPlayerFormattedText(playerid,temp, 0,COLOUR_LIGHTGREEN);
			set(temp,nullstr);
		}
	}
	return 1;
}


public FHotelBuy(playerid)
{
	new id=GetHotelID(playerid);
	new temp[MAX_STRING];
	if (id > -1)
	{
		if (IsPlayerRegistered(playerid))
		{
		    if (PlayerGangID[playerid] != -1)
			{
			    SendPlayerFormattedText(playerid, "ОШИБКА! Вы не должны быть в банде." , 0,COLOUR_RED);
				return 1;
			}
			new price;
			price = Hotels[id][Hotel_Cost];
			if(Player[playerid][Money] >= price)
			{
			    for (new hid=0;hid<MAX_HOTELS;hid++)
				{
					if(strcomp(Hotels[hid][Hotel_Owner], oGetPlayerName(playerid), true) == 1)
					{
					    SendPlayerFormattedText(playerid, "ОШИБКА! Вы не можете арендовать более 2-х комнат." , 0,COLOUR_RED);
					    return 1;
					}
				}
				new Texttemp[MAX_STRING];
				format(Texttemp,sizeof(Texttemp), "Отель %s\n Цена: %d\n Сейчас принадлежит: %s",Hotels[id][Hotel_Name],Hotels[id][Hotel_Cost],oGetPlayerName(playerid));
				Update3DTextLabelText(hoteltextid[id],COLOUR_WHITE,Texttemp);
				oGivePlayerMoney(playerid,(0-price),1);
				format(temp,sizeof(temp), " Вы арендовали отель '%s'. Плата за каждый спавн: $%d." ,Hotels[id][Hotel_Name],Hotels[id][Hotel_Cost]);
				SendPlayerFormattedText(playerid, temp, 0,COLOUR_GREEN);
				set(temp,nullstr);
				set(Hotels[id][Hotel_Owner],oGetPlayerName(playerid));
				/*if(sqlaccountstatus != 0)
				{
					new query[MAX_STRING];
					format(query, MAX_STRING, "UPDATE Hotels SET ");
					MySQLUpdateHotelStr(query, sqlaccountstatus, "Owner", oGetPlayerName(playerid));
					MySQLUpdateFinish(query, sqlaccountstatus, "Hotels");
				}*/
				
				HotelsSave(id);
				
				new logstring[MAX_STRING];
				format(logstring, sizeof (logstring), "Player %s(id: %d) rent hotel: '%s'",oGetPlayerName(playerid),playerid,Hotels[id][Hotel_Name]);
				WriteLog(logstring);
			}
			else
			{
				SendPlayerFormattedText(playerid, "ОШИБКА! У Вас не хватает денег для аренды этого отеля." , 0,COLOUR_RED);
			}
		}
		else
		{
			SendPlayerFormattedText(playerid, "ОШИБКА! Вы должны быть зарегистрированны, чтобы арендовать этот отель." , 0,COLOUR_RED);
		}
	}
	else
	{
		SendPlayerFormattedText(playerid, "ОШИБКА! Информация недоступна т.к. вы находитесь далеко от какого-либо отеля." , 0,COLOUR_RED);
	}
	return 1;
}

public FHotelSell(playerid)
{
	new id=GetHotelID(playerid);
	new temp[MAX_STRING];
	if (id > -1)
	{
		if (IsPlayerRegistered(playerid))
		{
			if(strcomp(Hotels[id][Hotel_Owner], oGetPlayerName(playerid), true) == 0)
			{
				SendPlayerFormattedText(playerid, "ОШИБКА! Вы не владеете этим отелем." , 0,COLOUR_RED);
			}
			else
			{
				new price;
				price = Hotels[id][Hotel_Cost];
				oGivePlayerMoney(playerid,price,1);
				set(Hotels[id][Hotel_Owner],"Unknown");
				/*new sqlaccountstatus = MySQLCheckHotelName(Hotels[id][Hotel_Name]);
				if(sqlaccountstatus != 0)
				{
					new query[MAX_STRING];
					format(query, MAX_STRING, "UPDATE Hotels SET ");
					MySQLUpdateHotelStr(query, sqlaccountstatus, "Owner", "Unknown");
					MySQLUpdateFinish(query, sqlaccountstatus, "Hotels");
				}*/
				new Texttemp[MAX_STRING];
				format(Texttemp,sizeof(Texttemp), "Отель %s\n Цена: %d\n Сейчас никому не принадлежит", Hotels[id][Hotel_Name],Hotels[id][Hotel_Cost]);
				Update3DTextLabelText(hoteltextid[id],COLOUR_WHITE,Texttemp);
				format(temp,sizeof(temp), " Аренда отеля '%s' прекращена." ,Hotels[id][Hotel_Name]);
				SendPlayerFormattedText(playerid, temp, 0,COLOUR_GREEN);
				set(temp,nullstr);
				
				HotelsSave(id);
				
				new logstring[MAX_STRING];
				format(logstring, sizeof (logstring), "Игрок %s(id: %d) расторгнул аренду отеля: '%s'",oGetPlayerName(playerid),playerid,Hotels[id][Hotel_Name]);
				WriteLog(logstring);
			}
		}
		else
		{
			SendPlayerFormattedText(playerid,  "ОШИБКА! Вы должны быть зарегистрированны, чтобы расторгнуть аренду отеля." , 0,COLOUR_RED);
		}
	}
	else
	{
		SendPlayerFormattedText(playerid,"ОШИБКА! Информация недоступна, т.к. вы находитесь далеко от какого-либо отеля.", 0,COLOUR_RED);
	}
	return 1;
}

forward SpawnInHotel(playerid);
public SpawnInHotel(playerid)
{
			for (new id=0;id<MAX_HOTELS;id++)
			{
			    if(strcmp(Hotels[id][Hotel_Owner],oGetPlayerName(playerid), true) == 0)
			    {
			        new temp[MAX_STRING];
			        if(Player[playerid][Bank] >= Hotels[id][Hotel_Cost])
			        {
			            format(temp,sizeof(temp), " Вы в своём номере отеля. С вашего банковского счёта списано $%d.", Hotels[id][Hotel_Cost]);
						SendPlayerFormattedText(playerid, temp, 0, COLOUR_GREEN);
						SetPlayerPos(playerid, HotelCP[id][Coord_X], HotelCP[id][Coord_Y], HotelCP[id][Coord_Z]);
						SetPlayerFacingAngle(playerid, HotelCP[id][Coord_A] );
						SetCameraBehindPlayer(playerid);
						Player[playerid][Bank] = Player[playerid][Bank] - Hotels[id][Hotel_Cost];
						//SetPVarInt(playerid, "Bank",(GetPVarInt(playerid, "Bank")-Hotels[id][Hotel_Cost]));
						if(Player[playerid][Bank] <= (Hotels[id][Hotel_Cost]*10))ShowPlayerDialog(playerid, 15646, DIALOG_STYLE_MSGBOX, "ВНИМАНИЕ!", "{FFFFFF}Сумма на вашем банковском счете может покрыть ещё 10 спавнов в этом отеле.\n			{ff0000}Пополните счёт как можно скорее!", "Ок", "");
						return 1;
					}
					SendPlayerFormattedText(playerid, "ВНИМАНИЕ! У вас недостаточно денег для аренды отеля." , 0,COLOUR_LIGHTRED);
					set(Hotels[id][Hotel_Owner],"Unknown");
					/*MySQLCheckConnection();
					new sqlaccountstatus = MySQLCheckHotelName(Hotels[id][Hotel_Name]);
					if(sqlaccountstatus != 0)
					{
						new query[MAX_STRING];
						format(query, MAX_STRING, "UPDATE Hotels SET ");
						MySQLUpdateHotelStr(query, sqlaccountstatus, "Owner", "Unknown");
						MySQLUpdateFinish(query, sqlaccountstatus, "Hotels");
					}*/
					HotelsSave(id);
					new Texttemp[MAX_STRING];
					format(Texttemp,sizeof(Texttemp), "Отель %s\n Цена: %d\n Сейчас никому не принадлежит",Hotels[id][Hotel_Name],Hotels[id][Hotel_Cost]);
					Update3DTextLabelText(hoteltextid[id],COLOUR_WHITE,Texttemp);
					format(temp,sizeof(temp), " Аренда отеля '%s' прекращена." ,Hotels[id][Hotel_Name]);
					SendPlayerFormattedText(playerid, temp, 0,COLOUR_GREEN);
					set(temp,nullstr);
					new logstring[MAX_STRING];
					format(logstring, sizeof (logstring), "Отель '%s' был автоматически продан",Hotels[id][Hotel_Name]);
					WriteLog(logstring);
					break;
				} else {
 					SetPlayerPosEx(playerid, PlayerSpawn[playerid][Coord_X], PlayerSpawn[playerid][Coord_Y], PlayerSpawn[playerid][Coord_Z]); // Warp the player
					PlayerSpawn[playerid][Coord_X] = 0.0;
					PlayerSpawn[playerid][Coord_Y] = 0.0;
					PlayerSpawn[playerid][Coord_Z] = 0.0;
				}
			}
	return 1;
}

forward ResetHotel(playerid);
public ResetHotel(playerid)
{
			for (new id=0;id<MAX_HOTELS;id++)
			{
			    if(strcmp(Hotels[id][Hotel_Owner],oGetPlayerName(playerid), true) == 0)
			    {
					new temp[MAX_STRING];
					set(Hotels[id][Hotel_Owner],"Unknown");
					/*new sqlaccountstatus = MySQLCheckHotelName(Hotels[id][Hotel_Name]);
					if(sqlaccountstatus != 0)
					{
						new query_2[MAX_STRING];
						format(query_2, MAX_STRING, "UPDATE Hotels SET ");
						MySQLUpdateHotelStr(query_2, sqlaccountstatus, "Owner", "Unknown");
						MySQLUpdateFinish(query_2, sqlaccountstatus, "Hotels");
					}*/
					new Texttemp[MAX_STRING];
					format(Texttemp,sizeof(Texttemp), "Отель %s\n Цена: %d\n Сейчас никому не принадлежит",Hotels[id][Hotel_Name],Hotels[id][Hotel_Cost]);
					Update3DTextLabelText(hoteltextid[id],COLOUR_WHITE,Texttemp);
					format(temp,sizeof(temp), " Аренда отеля '%s' прекращена." ,Hotels[id][Hotel_Name]);
					SendPlayerFormattedText(playerid, temp, 0,COLOUR_GREEN);
					set(temp,nullstr);

					HotelsSave(id);

					new logstring[MAX_STRING];
					format(logstring, sizeof (logstring), "Отель '%s' был автоматически продан. Причина: принятие в банду.",Hotels[id][Hotel_Name]);
					WriteLog(logstring);
					break;
				}
			}
	return 1;
}





