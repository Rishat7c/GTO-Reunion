//Weapon Business module.
//Created by MadCat
//Based on Original Business Handler from GTO, created by Iain Gilbert
//Coords from SA-MP forum

#include "base"
#include "weapons"
#include "utils\gtoutils"
#include "utils\dutils"
#include "utils\gtodudb"
#include "utils\dini"

forward DialogPlayerWBussines(playerid);

new armdinfoshowed[MAX_PLAYERS] = 0;

#define PICKUP_PACK 3013
#define WEAPON_PACK 1000

#define PACK_COST 1500

#define PICKUP_BRASS_KNUCKLES 331
#define PICKUP_GOLFCLUB 333
#define PICKUP_NITESTICK 334
#define PICKUP_KNIFE 335
#define PICKUP_BAT 336
#define PICKUP_SHOVEL 337
#define PICKUP_POOLSTICK 338
#define PICKUP_KATANA 338
#define PICKUP_CHAINSAW 341
#define PICKUP_DILDO 321
#define PICKUP_DILDO2 322
#define PICKUP_VIBRATOR1 323
#define PICKUP_VIBRATOR2 324
#define PICKUP_FLOWER 325
#define PICKUP_CANE 326
#define PICKUP_GRENADE 342
#define PICKUP_TEARGAS 343
#define PICKUP_MOLOTOV 344
#define PICKUP_MISSILE 345
#define PICKUP_COLT45 346
#define PICKUP_SILENCED 347
#define PICKUP_DEAGLE 348
#define PICKUP_SHOTGUN 349
#define PICKUP_SAWEDOFF 350
#define PICKUP_SHOTGSPA 351
#define PICKUP_UZI 352
#define PICKUP_MP5 353
#define PICKUP_HYDRAFLARE 354
#define PICKUP_AK47 355
#define PICKUP_M4 356
#define PICKUP_TEC9 372
#define PICKUP_RIFLE 357
#define PICKUP_SNIPER 358
#define PICKUP_ROCKETLAUNCHER 359
#define PICKUP_HEATSEEKER 360
#define PICKUP_FLAMETHROWER 361
#define PICKUP_MINIGUN 362
#define PICKUP_SACHEL 363
#define PICKUP_BOMB 364  // actually the detonator
#define PICKUP_SPRAYCAN 365
#define PICKUP_FIREEXTINGUISHER 366
#define PICKUP_CAMERA 367
#define PICKUP_NIGHTVISION_GOGGLES 368
#define PICKUP_THERMAL_GOGGLES 369
#define PICKUP_PARA 371
#define PICKUP_PACK 3013

forward ArmDealers_OnGameModeInit();
forward IsPlayerAtArmDealer(playerid);
forward ArmDealerPickupCheck(playerid,pickupid);
forward BuyWeapon(playerid,weaponid,bullets);
forward GetPlayerArmDealerID(playerid);
forward BuyArmDealer(playerid);
forward CollectArmDealer(playerid);
forward SellArmDealer(playerid);
forward BuyWeaponFromDealer(playerid);
forward errormsg(playerid, text);

enum ArmDealerInfo {
    Name[MAX_STRING],
    Float:Coord_X,
    Float:Coord_Y,
    Float:Coord_Z,
    Level,
    Cost,
    MoneyNow,
    PickupModel,
    WeaponSell,
    Bullets,
    Owner[MAX_NAME]
}

#define MAX_ARMDEALERS 68

new Armdealers[MAX_ARMDEALERS][ArmDealerInfo] = {
	{"ArmsDealer - Weapon Pack - Palomino Creek",2335.3181,63.7071,26.4828,20,6000000,0,PICKUP_PACK,WEAPON_PACK,0,"Server"},
	{"ArmsDealer - Weapon Pack - (LS)Market",1365.3409,-1282.4238,13.5469,20,6000000,0,PICKUP_PACK,WEAPON_PACK,0,"Server"},
	{"ArmsDealer - Weapon Pack - LV",2157.9685,940.0720,10.8203,20,6000000,0,PICKUP_PACK,WEAPON_PACK,0,"Server"},
	{"ArmsDealer - Weapon Pack - (LV)Old Venturas Strip",2537.6448,2081.0051,10.8203,20,6000000,0,PICKUP_PACK,WEAPON_PACK,0,"Server"},
	{"ArmsDealer - Weapon Pack - (SF)Ocean Flats",-2630.0916,209.7846,4.5073,20,6000000,0,PICKUP_PACK,WEAPON_PACK,0,"Server"},
	{"ArmsDealer - Weapon Pack - BlueBerry",240.2100,-181.3865,1.5781,20,6000000,0,PICKUP_PACK,WEAPON_PACK,0,"Server"},
	{"ArmsDealer - Weapon Pack - El Quebrados",-1510.3710,2609.0706,55.8359,20,6000000,0,PICKUP_PACK,WEAPON_PACK,0,"Server"},
	{"ArmsDealer - Weapon Pack - Fort Carson",-314.2716,828.0305,14.2422,20,6000000,0,PICKUP_PACK,WEAPON_PACK,0,"Server"},
	{"ArmsDealer - Weapon Pack - Bone County",778.7179,1874.4076,4.9257,20,6000000,0,PICKUP_PACK,WEAPON_PACK,0,"Server"},
	{"ArmsDealer - Weapon Pack - Angel Pine",-2095.2671,-2461.4656,30.6250,20,6000000,0,PICKUP_PACK,WEAPON_PACK,0,"Server"},
	{"ArmsDealer - Weapon Pack - (LS)Willowfield",2397.7991,-1980.6862,13.5469,20,6000000,0,PICKUP_PACK,WEAPON_PACK,0,"Server"},
	{"ArmsDealer - AK47 - (LV)Redsands West",1625.0,1944.0,11.0,25,5500000,0,PICKUP_AK47,WEAPON_AK47,60,"Server"},
	{"ArmsDealer - M4 - (LV)Pilgrim",2575.0,1562.0,16.0,34,5500000,0,PICKUP_M4,WEAPON_M4,70,"Server"},
	{"ArmsDealer - MP5 - (LV)Come-A-Lot",2243.0,1132.0,11.0,33,4000000,0,PICKUP_MP5,WEAPON_MP5,70,"Server"},
	{"ArmsDealer - Tec9 - Red County 1",1761.0,591.0,10.0,19,4000000,0,PICKUP_TEC9,WEAPON_TEC9,50,"Server"},
	{"ArmsDealer - AK47 - (LV)The Four Dragons Casino",1923.0,1011.0,22.0,25,5500000,0,PICKUP_AK47,WEAPON_AK47,60,"Server"},
	{"ArmsDealer - Combat Shotgun - (LV)LVA Freight Depot",1407.0,1098.0,11.0,36,4500000,0,PICKUP_SHOTGSPA,WEAPON_SHOTGSPA,50,"Server"},
	{"ArmsDealer - MicroUzi - (LV)Redsands West",1446.35,1900.03,11.0,28,4000000,0,PICKUP_UZI,WEAPON_UZI,60,"Server"},
	{"ArmsDealer - Silenced Pistol - (LV)Blackfield",1098.0,1681.0,7.0,5,1000000,0,PICKUP_SILENCED,WEAPON_SILENCED,30,"Server"},
	{"ArmsDealer - Sawed Off Shotgun - (LV)Whitewood Estates",924.0,2138.0,11.0,21,4500000,0,PICKUP_SAWEDOFF,WEAPON_SAWEDOFF,25,"Server"},
	{"ArmsDealer - Grenade - (LV)Rockshore East",2809.0, 864.0, 21.0,26,6000000,0,PICKUP_GRENADE,WEAPON_GRENADE,10,"Server"},
//	{"ArmsDealer - Nitestick - (LV)Roca Escalante",2241.0, 2425.0, 11.0,0,10000,0,PICKUP_NITESTICK,WEAPON_NITESTICK,1,"Server"},
	{"ArmsDealer - Sawed Off Shotgun - (LS)East Los Santos",2428.0,-1214.0,36.0,21,4500000,0,PICKUP_SAWEDOFF,WEAPON_SAWEDOFF,25,"Server"},
	{"ArmsDealer - Sniper Rifle - (LS)Jefferson",2047.0,-1406.0,68.0,30,6000000,0,PICKUP_SNIPER,WEAPON_SNIPER,20,"Server"},
	{"ArmsDealer - Pistol - (LS)Santa Maria Beach",338.0,-1875.0,4.0,1,500000,0,PICKUP_COLT45,WEAPON_COLT45,35,"Server"},
	{"ArmsDealer - Grenade - (LS)Las Colinas",2441.0, -1013.0, 54.0,26,6000000,0,PICKUP_GRENADE,WEAPON_GRENADE,10,"Server"},
	{"ArmsDealer - MP5 - (SF)Ocean Flats",-2678.0,-128.0,4.0,33,4000000,0,PICKUP_MP5,WEAPON_MP5,70,"Server"},
	{"ArmsDealer - M4 - (SF)Palisades",-2903.0,784.0,35.0,34,5500000,0,PICKUP_M4,WEAPON_M4,70,"Server"},
	{"ArmsDealer - Tec9 - (SF)Battery Point",-2665.0,1452.0,7.0,19,4000000,0,PICKUP_TEC9,WEAPON_TEC9,50,"Server"},
	{"ArmsDealer - Pistol - (SF)Garcia",-2206.0,-23.0,35.0,1,500000,0,PICKUP_COLT45,WEAPON_COLT45,35,"Server"},
	{"ArmsDealer - AK47 - (SF)Foster Valley",-1968.0,-923.0,32.0,25,5500000,0,PICKUP_AK47,WEAPON_AK47,60,"Server"},
	{"ArmsDealer - MicroUzi - (SF)Esplanade North",-1679.0,1410.0,7.0,28,4000000,0,PICKUP_UZI,WEAPON_UZI,60,"Server"},
	{"ArmsDealer - Sniper Rifle - (SF)Downtown",-1629.0,1167.0,24.0,30,6000000,0,PICKUP_SNIPER,WEAPON_SNIPER,20,"Server"},
	{"ArmsDealer - Baseball Bat - (SF)Garcia",-2306.0, 93.0, 35.0,4,250000,0,PICKUP_BAT,WEAPON_BAT,1,"Server"},
	{"ArmsDealer - Katana - (SF)Chinatown",-2208.0, 696.0, 50.0,11,350000,0,PICKUP_KATANA,WEAPON_KATANA,1,"Server"},
	{"ArmsDealer - Knife - (SF)Downtown",-1871.0, 351.0, 26.0,3,250000,0,PICKUP_KNIFE,WEAPON_KNIFE,1,"Server"},
	{"ArmsDealer - Golf Club - (SF)Avispa Country Club",-2715.0, -314.0, 7.0,3,150000,0,PICKUP_GOLFCLUB,WEAPON_GOLFCLUB,1,"Server"},
	{"ArmsDealer - Desert Eagle - Whetstone",-1870.0,-1625.0,22.0,15,3000000,0,PICKUP_DEAGLE,WEAPON_DEAGLE,30,"Server"},
	{"ArmsDealer - Fire Extinguisher - Whetstone",-1627.0, -2692.0, 49.0,20,3000000,0,PICKUP_FIREEXTINGUISHER,WEAPON_FIREEXTINGUISHER,3000,"Server"},
	{"ArmsDealer - MicroUzi - Angel Pine",-2038.0,-2562.0,31.0,28,4000000,0,PICKUP_UZI,WEAPON_UZI,60,"Server"},
	{"ArmsDealer - Rifle - Back o Beyond",-1035.0,-2258.0,70.0,22,3000000,0,PICKUP_RIFLE,WEAPON_RIFLE,30,"Server"},
	{"ArmsDealer - Molotov - Palomino Creek",2255.0, -74.0, 32.0,27,5000000,0,PICKUP_MOLOTOV,WEAPON_MOLTOV,10,"Server"},
	{"ArmsDealer - MP5 - Montgomery",1296.0,392.0,20.0,33,4000000,0,PICKUP_MP5,WEAPON_MP5,70,"Server"},
	{"ArmsDealer - Tec9 - Red County 2",262.0,38.0,2.0,19,4000000,0,PICKUP_TEC9,WEAPON_TEC9,50,"Server"},
	{"ArmsDealer - M4 - Bone County",113.0,1811.0,18.0,34,5500000,0,PICKUP_M4,WEAPON_M4,70,"Server"},
	{"ArmsDealer - Shotgun - Fort Carson",24.0,969.0,20.0,10,2000000,0,PICKUP_SHOTGUN,WEAPON_SHOTGUN,30,"Server"},
	{"ArmsDealer - Pistol - Tierra Robada",-639.0,1181.0,13.0,1,500000,0,PICKUP_COLT45,WEAPON_COLT45,35,"Server"},
	{"ArmsDealer - AK 47 - Tierra Robada",-585.0,2714.0,72.0,25,5500000,0,PICKUP_AK47,WEAPON_AK47,60,"Server"},
	{"ArmsDealer - MP5 - El Quebrados",-1474.0,2577.0,56.0,33,4000000,0,PICKUP_MP5,WEAPON_MP5,70,"Server"},
	{"ArmsDealer - Desert Eagle - Bayside Marina",-2352.0,2456.0,6.0,15,2000000,0,PICKUP_DEAGLE,WEAPON_DEAGLE,30,"Server"},
	{"ArmsDealer - Grenade - Bayside",-2520.0, 2293.0, 5.0,26,6000000,0,PICKUP_GRENADE,WEAPON_GRENADE,10,"Server"},
	{"ArmsDealer - MicroUzi - Verdant Meadows",119.0,2409.0,17.0,28,3000000,0,PICKUP_UZI,WEAPON_UZI,60,"Server"},
	{"ArmsDealer - Chainsaw - Red County",752.0, 260.0, 27.0,14,200000,0,PICKUP_CHAINSAW,WEAPON_CHAINSAW,1,"Server"},
	{"ArmsDealer - Parachute - (SF)Downtown",-1542.857, 698.4825, 139.2658,13,500000,0,PICKUP_PARA,WEAPON_PARACHUTE,1,"Server"},
	{"ArmsDealer - Shovel - Fern Ridge",842.9783, -17.3791, 64.2,32,1000000,0,PICKUP_SHOVEL,WEAPON_SHOVEL,1,"Server"},
	{"ArmsDealer - Cane - Flint County",-45.5928, -1148.529, 1.3953,18,500000,0,PICKUP_CANE,WEAPON_CANE,1,"Server"},
	{"ArmsDealer - Baseball Bat - (LV)Redsands West",1308.466, 2111.289, 10.7221,4,500000,0,PICKUP_BAT,WEAPON_BAT,1,"Server"},
	{"ArmsDealer - Knife - Bone County",777.8668, 1948.123, 5.3634,3,250000,0,PICKUP_KNIFE,WEAPON_KNIFE,1,"Server"},
	{"ArmsDealer - Katana - (LV)Pilgrim",2631.263, 1722.395, 11.0312,11,500000,0,PICKUP_KATANA,WEAPON_KATANA,1,"Server"},
	{"ArmsDealer - Minigun - (LV) The strip",2096.0945,1285.6149,10.8203,40,8000000,0,362,38,550,"Server"},
	//
	{"ArmsDealer - Minigun",-1755.1732,957.3755,24.8828,40,8000000,0,362,38,550,"Server"},
	{"ArmsDealer - RC Bomb",-915.6613,2012.5227,60.9141,35,3000000,0,PICKUP_SACHEL,39,550,"Server"},
	{"ArmsDealer - RC Bomb",-2378.7769,-584.1370,132.1172,35,3000000,0,PICKUP_SACHEL,39,550,"Server"},
	{"ArmsDealer - Rocket Launcher",1402.6661,2668.0315,10.8203,37,6500000,0,PICKUP_ROCKETLAUNCHER,35,550,"Server"},
	{"ArmsDealer - Rocket Launcher",-1653.9926,258.2552,1.1774,37,6500000,0,PICKUP_ROCKETLAUNCHER,35,550,"Server"},
	{"ArmsDealer - Rifle",-730.6100,1546.1224,38.9973,22,4500000,0,PICKUP_RIFLE,WEAPON_RIFLE,30,"Server"},
	{"ArmsDealer - Spray",-370.3567,1578.7250,76.0698,16,300000,0,PICKUP_SPRAYCAN,41,30,"Server"},
	{"ArmsDealer - Tear Gas",-1303.6749,2532.2324,87.7422,24,500000,0,PICKUP_TEARGAS,17,30,"Server"},
	{"ArmsDealer - Detonator",-923.6742,2675.7151,42.3703,35,600000,0,PICKUP_BOMB,40,1,"Server"}
};

new ArmsDealerBusinessDB[MAX_STRING] = "GTO/Bweapon/";
new Text3D:biztextid[MAX_ARMDEALERS];

WeaponBusinessLoadAll()
{

	new temp[MAX_STRING];
	if (!dini_Exists(ConfigDB)) dini_Create(ConfigDB);
	if (!dini_Isset(ConfigDB,"ArmDealers_Business_DB")) dini_Set(ConfigDB,"ArmDealers_Business_DB",ArmsDealerBusinessDB);
	set(temp,dini_Get(ConfigDB,"ArmDealers_Business_DB"));
	if (strlen(temp) > 0) set(ArmsDealerBusinessDB,temp);
	if (!dini_Exists(ArmsDealerBusinessDB))
	{

		WeaponBusinessSaveAll();

		return;
	}
	for (new i=0;i<MAX_ARMDEALERS;i++)
	{
		new ArmsDealerBusinessDBname[MAX_STRING];
		format(ArmsDealerBusinessDBname,sizeof(ArmsDealerBusinessDBname),"%s%s.txt",ArmsDealerBusinessDB,Armdealers[i][Name]);
		if (!dini_Exists(ArmsDealerBusinessDBname))
		{
			WeaponBusinessSaveAll();
		}
		set(temp,dini_Get(ArmsDealerBusinessDBname,"Name"));
		if (strlen(temp) > 0) set(Armdealers[i][Name],temp);
		set(temp,nullstr);
		set(temp,dini_Get(ArmsDealerBusinessDBname,"MoneyNow"));
		if (strlen(temp) > 0) Armdealers[i][MoneyNow] = strval(temp);
		set(temp,nullstr);
		set(temp,dini_Get(ArmsDealerBusinessDBname,"Owner"));
		if (strlen(temp) > 0) set(Armdealers[i][Owner],temp);
		set(temp,nullstr);
	}
	return;

}

WeaponBusinessSaveAll()
{
	new temp[MAX_STRING];
	if (dini_Exists(ConfigDB))
	{
		dini_Set(ConfigDB,"ArmDealers_Business_DB",ArmsDealerBusinessDB);
	}

	for (new i=0;i<MAX_ARMDEALERS;i++)
	{
		new ArmsDealerBusinessDBname[MAX_STRING];
		format(ArmsDealerBusinessDBname,sizeof(ArmsDealerBusinessDBname),"%s%s.txt",ArmsDealerBusinessDB,Armdealers[i][Name]);
		if (dini_Exists(ArmsDealerBusinessDBname)){
			continue;
		}
		dini_Create(ArmsDealerBusinessDBname);
//		dini_BeforeBigSaving(ArmsDealerBusinessDBname);
		dini_Set(ArmsDealerBusinessDBname,"Name",Armdealers[i][Name]);
		valstr(temp,Armdealers[i][MoneyNow]);
		dini_Set(ArmsDealerBusinessDBname,"MoneyNow",temp);
		set(temp,nullstr);
		dini_Set(ArmsDealerBusinessDBname,"Owner",Armdealers[i][Owner]);
//		dini_AfterBigSaving(ArmsDealerBusinessDBname);

	}
	return;
}

public ArmDealers_OnGameModeInit()
{
	new count = 0;
	for (new id=0;id<MAX_ARMDEALERS;id++)
	{
		AddStaticPickup(Armdealers[id][PickupModel],1,Armdealers[id][Coord_X],Armdealers[id][Coord_Y],Armdealers[id][Coord_Z]+1,0);
		CreatePickup(1274,1,Armdealers[id][Coord_X],Armdealers[id][Coord_Y],Armdealers[id][Coord_Z],0);
		
		new temp[MAX_STRING];
		format(temp,sizeof(temp), "Бизнес %s\nДля вызова меню нажми 'Num 4'", Armdealers[id][Name]);
		biztextid[id]=Create3DTextLabel(temp,COLOUR_WHITE,Armdealers[id][Coord_X],Armdealers[id][Coord_Y],Armdealers[id][Coord_Z],40.0,0,1);
		
		if (Armdealers[id][WeaponSell] == WEAPON_PACK)
		{
			CreateStreamMapIcon(6,Armdealers[id][Coord_X],Armdealers[id][Coord_Y],Armdealers[id][Coord_Z]);
		} else
		{
		    CreateStreamMapIcon(18,Armdealers[id][Coord_X],Armdealers[id][Coord_Y],Armdealers[id][Coord_Z]);
		}
		count++;
	}
	new logstring[256];
	format(logstring,sizeof(logstring),"ArmDealers System Loaded. Armdealers: %d",count);
	WriteLog(logstring);
}

public IsPlayerAtArmDealer(playerid)
{
	for (new id=0;id<MAX_ARMDEALERS;id++)
	{
		if (IsPlayerInRangeOfPoint(playerid,1.0,Armdealers[id][Coord_X],Armdealers[id][Coord_Y],Armdealers[id][Coord_Z])) //|| oIsPlayerInCheckpoint(playerid,Armdealers[id][Coord_X],Armdealers[id][Coord_Y],Armdealers[id][Coord_Z],8))
		{
			return 1;
		}
	}
	return 0;
}

public GetPlayerArmDealerID(playerid)
{
	new lookupid=-1;
	for (new armdealersid=0;armdealersid<MAX_ARMDEALERS;armdealersid++)
	{
		if (IsPlayerInRangeOfPoint(playerid,1.0,Armdealers[armdealersid][Coord_X],Armdealers[armdealersid][Coord_Y],Armdealers[armdealersid][Coord_Z])) lookupid = armdealersid;
	}
	return lookupid;
}

public BuyWeapon(playerid,weaponid,bullets)
{
	new string[MAX_STRING];
	if ((weaponid < 1) || (weaponid > 46))
	{
		SendPlayerFormattedText(playerid,  lang_texts[16][7]  , 0,COLOUR_RED);
		return 0;
	}
	//if (bullets < 1)
	if ((bullets < 1) || (bullets > 9999))
	{
		SendPlayerFormattedText(playerid,  lang_texts[16][8]  , 0,COLOUR_RED);
		return 0;
	}
	if (!IsPlayerAtArmDealer(playerid))
	{
		SendPlayerFormattedText(playerid,  lang_texts[16][9]  , 0,COLOUR_RED);
		return 0;
	}

	if (!IsPlayerAllowedWeapon(playerid,weaponid))
	{
		format(string,sizeof(string), lang_texts[16][10] ,oGetWeaponName(weaponid));
		SendPlayerFormattedText(playerid,string,0,COLOUR_RED);
		return 0;
	}
	
//---- проверка на скилы
	if(!WeaponAllowBySkill(playerid,weaponid))
	{ format(string,sizeof(string),"Ваш навык владения оружием не позволяет приобрести ЭТО оружие. Требуется любой из навыков: %s",GetWeaponSkillCondition(weaponid)); SendPlayerFormattedText(playerid,string,0,COLOUR_RED); return 0; }
//---- енд проверки на скилы */
	
	new purchasecost;
	purchasecost = GetWeaponCost(weaponid) * bullets;
	if (purchasecost < 1)
	{
		format(string,sizeof(string), lang_texts[16][11] ,oGetWeaponName(weaponid));
		SendPlayerFormattedText(playerid, string,0,COLOUR_RED);
		return 0;
	}
	if (oGetPlayerMoney(playerid) < purchasecost)
	{
		format(string,sizeof(string), lang_texts[16][12]  , purchasecost);
		SendPlayerFormattedText(playerid, string,0,COLOUR_RED);
		return 0;
	}
	
	
	new id=GetPlayerArmDealerID(playerid);
	if (strcomp(Armdealers[id][Owner],"Server",false) == 0){ // Хозяин есть
	oGivePlayerMoney(playerid,0-purchasecost,0);
	Armdealers[id][MoneyNow]=Armdealers[id][MoneyNow]+purchasecost;
	new dinifilename[MAX_STRING];
	new temp[MAX_STRING];
	format(dinifilename,sizeof(dinifilename),"%s%s.txt",ArmsDealerBusinessDB,Armdealers[id][Name]);
	if (dini_Exists(dinifilename))
	{
		valstr(temp,Armdealers[id][MoneyNow]);
		dini_Set(dinifilename,"MoneyNow",temp);
		set(temp,nullstr);
	}
	} else if (strcomp(Armdealers[id][Owner],oGetPlayerName(playerid),false) == 0){ // Хозяин есть
	new dinifilename[MAX_STRING];
//	new temp[MAX_STRING];
	format(dinifilename,sizeof(dinifilename),"%s%s.txt",ArmsDealerBusinessDB,Armdealers[id][Name]);
	oGivePlayerMoney(playerid,0-purchasecost,1);
	if (dini_Exists(dinifilename))
	{

	}
	//SystemMsg(playerid,COLOUR_OK,gettext(854));
	}
	else
	{
	oGivePlayerMoney(playerid,0-purchasecost,1); // Reunion
	Armdealers[id][MoneyNow]=Armdealers[id][MoneyNow]+purchasecost;
	new dinifilename[MAX_STRING];
	new temp[MAX_STRING];
	format(dinifilename,sizeof(dinifilename),"%s%s.txt",ArmsDealerBusinessDB,Armdealers[id][Name]);
	if (dini_Exists(dinifilename))
	{
		valstr(temp,Armdealers[id][MoneyNow]);
		dini_Set(dinifilename,"MoneyNow",temp);
		set(temp,nullstr);
	}
	}
	GiveSlotWeapon(playerid,weaponid,bullets); // Reunion
	if (bullets == 1){
	format(string,sizeof(string),lang_texts[22][11],oGetWeaponName(weaponid),purchasecost);
	} else {
	format(string,sizeof(string),lang_texts[22][12],oGetWeaponName(weaponid),bullets,purchasecost);
	}
	SendPlayerFormattedText(playerid, string, 0,COLOUR_GREEN);
//	SystemMsg(playerid, COLOUR_OK, string);
	// Система Reunion'a
	if (bullets > 1)
	{
		format(string,sizeof(string), lang_texts[16][13] ,bullets,oGetWeaponName(weaponid),purchasecost);
	}
	else
	{
		format(string,sizeof(string), lang_texts[16][14] ,oGetWeaponName(weaponid),purchasecost);
	}
	SendPlayerFormattedText(playerid, string, 0,COLOUR_GREEN);
	SendPlayerFormattedText(playerid,  lang_texts[16][15]  , 0,COLOUR_GREEN);
	return 1;
}

						//---------------
/*    					if(strcomp(Armdealers[id][Owner],"Server",true) == 0) {
//					    		        new pricex;
//										pricex = Armdealers[id][Cost] * 3;
					    		        new str[648];
//                                		format(str,sizeof(str),"{FFFFFF}Вы уверены что хотите перекупить бизнес {FFFFE0}%s {D3D3D3}(%s)\n{FFFFFF}Цена перекупа {008000}$ %d", Armdealers[id][Name],Armdealers[id][Owner],pricex);
//										ShowPlayerDialog(playerid,638,DIALOG_STYLE_MSGBOX,"::: Аммунация :::",str,"Купить","Назад");
                                		format(str,sizeof(str),"ТЕСТ");
										ShowPlayerDialog(playerid,999,DIALOG_STYLE_MSGBOX,"::: Аммунация :::",str,"Купить","Назад");
						} else {
						//----------------*/

public BuyArmDealer(playerid){
		new temp[MAX_STRING];
		new count = 0;
		for (new id=0;id<MAX_ARMDEALERS;id++)
		{
			if(strcomp(Armdealers[id][Owner], oGetPlayerName(playerid), true) == 1)
			{
				count++;
			}
		}
		if(count == 1)
		{
		format(temp,sizeof(temp),lang_texts[22][45]);
		SendPlayerFormattedText(playerid, temp, 0,COLOUR_RED);
		set(temp,nullstr);
		} else {
		
			new id=GetPlayerArmDealerID(playerid);
			if (id > -1)
			{
					if (GetPlayerLevel(playerid) >= Armdealers[id][Level])
					{
						new price;
						price = Armdealers[id][Cost] + Armdealers[id][MoneyNow];
						if(oGetPlayerMoney(playerid) >= price)
						{
							if(strcomp(Armdealers[id][Owner], oGetPlayerName(playerid), true) == 1)
							{
								SendPlayerFormattedText(playerid,lang_texts[22][13],0,COLOUR_RED);
							} else {
								oGivePlayerMoney(playerid,0-price,1);
								set(Armdealers[id][Owner],oGetPlayerName(playerid));
								new dinifilename[MAX_STRING];
								format(dinifilename,sizeof(dinifilename),"%s%s.txt",ArmsDealerBusinessDB,Armdealers[id][Name]);
								if (dini_Exists(dinifilename))
								{
									dini_Set(dinifilename,"Owner",Armdealers[id][Owner]);
								}
								format(temp,sizeof(temp),lang_texts[22][14],Armdealers[id][Name]);
								SendPlayerFormattedText(playerid, temp, 0,COLOUR_GREEN);
								SendPlayerFormattedText(playerid,lang_texts[22][15],0,COLOUR_GREEN);
								SendPlayerFormattedText(playerid,lang_texts[22][16],0,COLOUR_GREEN);
								set(temp,nullstr);
							}
						} else {
      						 SendPlayerFormattedText(playerid,lang_texts[22][17],0,COLOUR_RED);
						}
					} else {
						format(temp,sizeof(temp),lang_texts[22][18],Armdealers[id][Level]);
						SendPlayerFormattedText(playerid, temp, 0,COLOUR_RED);
						set(temp,nullstr);
					}
				} else {
				SendPlayerFormattedText(playerid,lang_texts[22][19],0,COLOUR_RED);
			}
			}
return 0;
}

public CollectArmDealer(playerid){
			new id=GetPlayerArmDealerID(playerid);
			new temp[MAX_STRING];
			if (id > -1)
			{
					if(strcomp(Armdealers[id][Owner], oGetPlayerName(playerid), true) == 0)
					{
						SendPlayerFormattedText(playerid,lang_texts[22][20],0,COLOUR_RED);
					} else {
						if(Armdealers[id][MoneyNow] > 0)
						{
							oGivePlayerMoney(playerid,0+Armdealers[id][MoneyNow],1);
							SendPlayerFormattedText(playerid,lang_texts[22][21],0,COLOUR_RED);
							Armdealers[id][MoneyNow] = 0;
							new dinifilename[MAX_STRING];
							format(dinifilename,sizeof(dinifilename),"%s%s.txt",ArmsDealerBusinessDB,Armdealers[id][Name]);
							if (dini_Exists(dinifilename))
							{
								valstr(temp,Armdealers[id][MoneyNow]);
								dini_Set(dinifilename,"MoneyNow",temp);
								set(temp,nullstr);
							}
						} else {
							SendPlayerFormattedText(playerid,lang_texts[22][22],0,COLOUR_RED);
						}
					}
				} else {
				SendPlayerFormattedText(playerid,lang_texts[22][19],0,COLOUR_RED);
			}
			return 0;
}

public SellArmDealer(playerid){
			new id=GetPlayerArmDealerID(playerid);
			new temp[MAX_STRING];
			if (id > -1)
			{
					if(strcomp(Armdealers[id][Owner], oGetPlayerName(playerid), true) == 0)
					{
						SendPlayerFormattedText(playerid,lang_texts[22][20],0,COLOUR_RED);
					} else {
						new price;
						price = Armdealers[id][Cost] + Armdealers[id][MoneyNow];
						price = (price * 85) / 100;
						oGivePlayerMoney(playerid,0+price,1);
						set(Armdealers[id][Owner],"Server");
						new dinifilename[MAX_STRING];
						format(dinifilename,sizeof(dinifilename),"%s%s.txt",ArmsDealerBusinessDB,Armdealers[id][Name]);
						if (dini_Exists(dinifilename))
						{
							dini_Set(dinifilename,"Owner","Server");
						}
						format(temp,sizeof(temp),lang_texts[22][23],Armdealers[id][Name]);
						SendPlayerFormattedText(playerid, temp, 0,COLOUR_GREEN);
						set(temp,nullstr);
					}
			} else {
				SendPlayerFormattedText(playerid,lang_texts[22][19],0,COLOUR_RED);
			}
			return 1;
		}

stock ShowTextForPlayer(playerid,msg[],time,style) {
	if ((IsPlayerConnected(playerid))&&(strlen(msg)>0)){
		GameTextForPlayer(playerid,msg,time,style);
	}
}

public BuyWeaponFromDealer(playerid)
{
	if (!IsPlayerAtArmDealer(playerid))
	{
		SendPlayerFormattedText(playerid,  lang_texts[16][9]  , 0,COLOUR_RED);
		return 1;
	}
	new id = GetPlayerArmDealerID(playerid);
	if (Armdealers[id][WeaponSell] == WEAPON_PACK){
		if (oGetPlayerMoney(playerid) < PACK_COST){
		SendPlayerFormattedText(playerid,lang_texts[22][25],0,COLOUR_RED);
		return 0;
		}
		if (GetPlayerLevel(playerid) < 5){
		SendPlayerFormattedText(playerid,lang_texts[22][26],0,COLOUR_RED);
		return 0;
		}
		GivePlayerWeapon(playerid,WEAPON_UZI,150);
		GivePlayerWeapon(playerid,WEAPON_SHOTGUN,40);
		GivePlayerWeapon(playerid,WEAPON_COLT45,90);
		oGivePlayerMoney(playerid,-PACK_COST,1);
		SendPlayerFormattedText(playerid,lang_texts[22][27],0,COLOUR_GREEN);
	} else {
	    if( Armdealers[id][Bullets] != 1 )
	    {
	        ShowPlayerDialog(playerid, WGUI+16, DIALOG_STYLE_INPUT, "  ", "Патроны", "Купить", "Назад");
	    }
	    if ( Armdealers[id][Bullets] == 1 )
	    {
			BuyWeapon(playerid,Armdealers[id][WeaponSell],Armdealers[id][Bullets]);
		}
	}
	return 1;
}

public DialogPlayerWBussines(playerid)
{
	if (!IsPlayerConnected(playerid)) return 0;
	armdinfoshowed[playerid] = 1;
	new id=GetPlayerArmDealerID(playerid);
    if(strcomp(Armdealers[id][Owner],"Server",true) == 0) {
         new s[300];
         new sx[300];
         new s2[128];
		 new s3[128];
		 new s4[300];
		 new s5[300];
		 new s56[MAX_STRING * 3];
		 format(s,sizeof(s),"Аммунация");
		 format(sx,sizeof(sx),lang_texts[22][1]);
		 format(s3,sizeof(s3),lang_texts[22][2],Armdealers[id][Cost]+Armdealers[id][MoneyNow],Armdealers[id][Level]);
	 	 if (Armdealers[id][WeaponSell] == WEAPON_PACK){
 		 format(s4,sizeof(s4),lang_texts[22][3],PACK_COST);
 		 format(s5,sizeof(s5),lang_texts[22][4]);
         } else {
         format(s4,sizeof(s4),lang_texts[22][5],oGetWeaponName(Armdealers[id][WeaponSell]),GetWeaponCost(Armdealers[id][WeaponSell]));
         format(s5,sizeof(s5),lang_texts[22][6],Armdealers[id][Owner]);
		 }
		 format(s2,sizeof(s2),lang_texts[22][7],Armdealers[id][MoneyNow]);
		 format(s56,sizeof(s56),"%s\n%s\n%s\n%s\n%s\n",sx,s3,s4,s5,s2);
		 ShowPlayerDialog(playerid,430,0,s,s56,"Меню","Закрыть");
		 } else {
		 new s[300];
         new sx[300];
         new s2[128];
		 new s3[128];
		 new s4[300];
		 new s5[300];
		 new s56[MAX_STRING * 3];
		 format(s,sizeof(s),"Аммунация");
		 format(sx,sizeof(sx),lang_texts[22][1]);
		 format(s3,sizeof(s3),lang_texts[22][2],Armdealers[id][Cost]+Armdealers[id][MoneyNow],Armdealers[id][Level]);
	 	 if (Armdealers[id][WeaponSell] == WEAPON_PACK){
 		 format(s4,sizeof(s4),lang_texts[22][3],PACK_COST);
 		 format(s5,sizeof(s5),lang_texts[22][4]);
         } else {
         format(s4,sizeof(s4),lang_texts[22][5],oGetWeaponName(Armdealers[id][WeaponSell]),GetWeaponCost(Armdealers[id][WeaponSell]));
         format(s5,sizeof(s5),lang_texts[22][44]);
		 }
		 format(s2,sizeof(s2),lang_texts[22][7],Armdealers[id][MoneyNow]);
		 format(s56,sizeof(s56),"%s\n%s\n%s\n%s\n%s\n",sx,s3,s4,s5,s2);
		 ShowPlayerDialog(playerid,430,0,s,s56,"Меню","Закрыть");
		 }
return 1;
}

public errormsg(playerid,text) {
	new hova = -1;
	if (!IsPlayerRegistered(playerid)) return hova;
	for (new id=0;id<MAX_ARMDEALERS;id++)
	{
		hova = id;
		if(text)
		{
			new tmp[MAX_STRING];
			format(tmp,sizeof(tmp), lang_texts[22][19]);
			SendPlayerFormattedText(playerid,tmp,0, COLOUR_RED);
		}
		break;
	}
	return hova;
}

