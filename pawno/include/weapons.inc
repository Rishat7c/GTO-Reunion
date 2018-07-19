//
// Created: 05.09.06
// Aurthor: Iain Gilbert
// ReCreate: Artem Firstov (Konsul)
/*
Last ReCreated by Maxim Tsarkov (OFFREAL)
- - - - -
Изменено распределение оружия по уровням
Изменено максимальное количество сохраняемых боеприпасов
*/


#if defined _weapons_included
#endinput
#endif

#define _weapons_included
#pragma library weapons
#include "base"
#include "player"

forward AmmunationInit();
forward IsPlayerAtAmmunation(playerid);
forward OnPlayerEnterAmmoCheckpoint(playerid);
forward IsPlayerAllowedWeapon(playerid,weaponid);
//forward BuyWeapon(playerid,weaponid,bullets);
forward AmmunationCommandHandler(playerid,text[]);

forward DialogPlayerAmmo(playerid);

#define MAX_WEAPONS 50
#define MAX_BULLETS 20000

enum WeaponInfo {
	Weapon_ID, // id number of weapon
	Weapon_Slot, // slot
	Weapon_Name[MAX_NAME], // weapon name
	Weapon_Engname[MAX_NAME],
	Weapon_Allowed, // is weapon allowed
	Weapon_MaxBullets, // max bullets
	Weapon_Cost, // cost per bullet
	Weapon_Level, // player level required to buy this weapon
	Weapon_BuyCondition // player condition to buy weapon
}
#define WeaponsSize 47

new PlayerWeaponsSkill[MAX_PLAYERS][WEAPONS_SKILLS];
#define MAX_SKILL_NAME 16
new SkillNames[WEAPONS_SKILLS][MAX_SKILL_NAME] = {
"Pistol 9mm",
"Silenced pistol",
"Desert Eagle",
"Shotgun",
"Sawnoff Shotgun",
"SPAS-12",
"Micro UZI",
"MP5",
"AK47",
"M4",
"Sniper Rifle"
};

new Weapons[WeaponsSize][WeaponInfo] = {

//	id	slot  "Name"					"Engname"	Allowed  maxbullets cost level skill

	{0,0, "Невооружен",					"Unarmed",			1,	1,		0, 		0,		-1}, ////////////////////////////////

	{1,0, "Кастет",						"Knuckles",			1,	1,		10000,	1,		-1},
	{2,1, "Клюшка для гольфа",			"Golf", 			1,	1,		1000,	3,		-1},
	{3,1, "Ментовская дубинка",			"Police bat", 		1,	1,		1000,	6,		-1},
	{4,1, "Нож",						"Knife", 			1,	1,		1000,	2,		-1},
	{5,1, "Бейсбольная Бита",			"Baseball bat", 	1,	1,		2000,	4,		-1},
	{6,1, "Лопата",						"Spade", 			1,	1,		500,	32,		-1},
	{7,1, "Кий",						"Cue", 				1,	1,		500,	7,		-1},
	{8,1, "Меч Катана",					"Katana",			1,	1,		4000,	11,		-1},
	{9,1, "Бензопила",					"Chainsaw",			1,	1,		2000,	14,		-1},
	{10,10, "Пурпурный Вибратор",		"Purple Vibrator", 	1,	1,		1000,	12,		-1},
	{11,10, "Вибратор Обыкновенный",	"Vibrator", 		1,	1,		1000,	9,		-1},
	{12,10, "Длинный Белый Вибратор",	"White Vibrator",	1,	1,		1000,	29,		-1},
	{13,10, "Железный Вибратор",		"Iron Vibrator",	1,	1,		1000,	31,		-1},
	{14,10, "Букет Цветов",				"Flowers",			1,	1,		1000,	17,		-1},
	{15,10, "Трость",					"Stick",			1,	1,		1000,	18,		-1},
	{16,8, "Граната",					"Grenade",			1,	10,		1000,	26,		-1},
	{17,8, "Слезоточивый газ",			"Tear Gas",			1,	10,		2000,	24,		-1},
	{18,8, "Коктейль Молотова",			"Molotov",			1,	10,		4000,	27,		-1},

	{19,0, "Неизвестное",				"Unknown",			0,	0,		1000,	101,	-1}, ////////////////////////////////
	{20,0, "Неизвестное",				"Unknown",			0,	0,		1000,	101,	-1}, ////////////////////////////////
	{21,0, "Неизвестное",				"Unknown",			0,	0,		1000,	101,	-1}, ////////////////////////////////

	{22,2, "Пистолет",					"Pistol",			1,	5000,	200,	0,		-1},
	{23,2, "Пистолет с глушителем",		"Silenced",			1,	5000,	250,	5,		-1},
	{24,2, "Пустынный Орел",			"Desert Eagle",		1,	5000,	400,	15,		-1},

	{25,3, "Дробовик",					"Shotgun",			1,	5000,	1200,	10,		0},
	{26,3, "Обрез",						"Sawnoff",			1,	5000,	1400,	21,		1},
	{27,3, "Боевой Дробовик",			"Combat Shotgun",	1,	5000,	2000,	36,		-1},

	{28,4, "Микро УЗИ (ПолуАвтомат)",	"MicroUzi",			1,	5000,	1600,	28,		2},
	{29,4, "MP5 (ПолуАвтомат)",			"MP5",				1,	5000,	1800,	33,		3},

	{30,5, "AK47 (Автомат Калашникова)","AK47",				1,	5000,	2000,	25,		-1},
	{31,5, "M4 (Автомат)",				"M4",				1,	5000,	4400,	34,		-1},

	{32,4, "TEC9 (ПолуАвтомат)",		"TEC9",				1,	5000,	2200,	19,		4},

	{33,6, "Винтовка",					"Rifle",			1,	5000,	1600,	22,		-1},
	{34,6, "Снайперская Винтовка",		"Sniper rifle",		1,	5000,	2000,	30,		-1},

	{35,7, "Гранатомет",				"Rocket Launcher",	1,	25,		5000,	37,		5},

	{36,7, "Самонаводящийся гранатомет","Autoaim RL",		0,	25,		10000,	101,	-1}, ////////////////

	{37,7, "Огнемет",					"Flamethrower",		1,	7500,	3400,	38,		6},
	{38,7, "Ручной Пулемет (Миниган)",	"Minigun",			1, 	7500,	6400,	40,		7},

	{39,8, "Взрывпакет",				"RC Bomb",			1,	10,		10000,	35,		-1},
	{40,12, "Детонатор к взрывпакету",	"RC Bomb Detonator",1,	1,		500,	35,		-1},

	{41,9, "Баллончик с краской",		"Spray",			1,	5000,	400,	16,		-1},
	{42,9, "Огнетушитель",				"Fire extinguisher",1,	5000,	2000,	20,		-1},

	{43,9, "Фотоаппарат",				"Camera",			0,	30,		6000,	101,	-1},  ////////////////
	{44,11, "Очки ночного видения",		"Night vision", 	0,	1,		1000,	101,	-1}, /////////////////
	{45,11, "Тепловые Очки",			"Thermal",			0,	1,		1000,	101,	-1}, /////////////////

	{46,11, "Парашют",					"Parachute",		1,	1,		100000,	13,		-1}
};

#define MAX_WBC 8

enum w_buy_cond {
skill_id_1,
skill_min_1,
skill_id_2,
skill_min_2,
skill_min_any
}

new WeaponBuyBySkill[MAX_WBC][w_buy_cond] = {
{3,100,-1,-1,200},	//25
{4,100,-1,-1,400},	//26
{6,200,-1,-1,450},	//28
{7,300,-1,-1,500},	//29
{6,200,7,100,300},	//32
{8,400,-1,-1,550},	//35
{9,200,-1,-1,600},	//37
{8,600,9,600,850}	//38
};

new WeaponSkillCondGUIStrting[MAX_STRING*4];

WeaponAllowBySkill(playerid,weaponid)
{
if(Weapons[weaponid][Weapon_BuyCondition] == -1) {return 1;}
new cond = Weapons[weaponid][Weapon_BuyCondition];
if(WeaponBuyBySkill[cond][skill_id_1] != -1 && PlayerWeaponsSkill[playerid][ WeaponBuyBySkill[cond][skill_id_1] ] >= WeaponBuyBySkill[cond][skill_min_1]) {return 1;}
if(WeaponBuyBySkill[cond][skill_id_2] != -1 && PlayerWeaponsSkill[playerid][ WeaponBuyBySkill[cond][skill_id_2] ] >= WeaponBuyBySkill[cond][skill_min_2]) {return 1;}
for(new i=0;i<WEAPONS_SKILLS;i++)
{ if(PlayerWeaponsSkill[playerid][i] >= WeaponBuyBySkill[cond][skill_min_any]) { return 1; } }
return 0;}

GetWeaponSkillCondition(weaponid)
{
new cstr[128];
if(Weapons[weaponid][Weapon_BuyCondition] == -1) {set(cstr,"| no |"); return cstr;}
new cond = Weapons[weaponid][Weapon_BuyCondition];
set(cstr,"|");
if(WeaponBuyBySkill[cond][skill_id_1] != -1 && WeaponBuyBySkill[cond][skill_min_1] != -1){
format(cstr,sizeof(cstr),"%s [ID %d] %s %d |",cstr,WeaponBuyBySkill[cond][skill_id_1],SkillNames[WeaponBuyBySkill[cond][skill_id_1]], WeaponBuyBySkill[cond][skill_min_1]);}
if(WeaponBuyBySkill[cond][skill_id_2] != -1 && WeaponBuyBySkill[cond][skill_min_2] != -1){
format(cstr,sizeof(cstr),"%s [ID %d] %s %d |",cstr,WeaponBuyBySkill[cond][skill_id_2],SkillNames[WeaponBuyBySkill[cond][skill_id_2]], WeaponBuyBySkill[cond][skill_min_2]);}
if(WeaponBuyBySkill[cond][skill_min_any] != -1){
format(cstr,sizeof(cstr),"%s Любой %d |",cstr, WeaponBuyBySkill[cond][skill_min_any]);}
return cstr;}

FormatWeaponSkillCondGUIStrting()
{
format(WeaponSkillCondGUIStrting,sizeof(WeaponSkillCondGUIStrting),"Требуемые навыки для покупки оружия:\n\n");
for(new i=0;i<WeaponsSize;i++)
{
if(Weapons[i][Weapon_BuyCondition] == -1) {continue;}
format(WeaponSkillCondGUIStrting,sizeof(WeaponSkillCondGUIStrting),"%s%s:\n%s\n\n",WeaponSkillCondGUIStrting,Weapons[i][Weapon_Name],GetWeaponSkillCondition(i));
}
return 1;
}

#define AmmunationsCount 3
new Ammunations[AmmunationsCount][CoordInfo] = {
	{291.0004,-84.5168,1001.5156}, 	// LVammunation1
	{293.2710,-108.9645,1001.5156}, // LSAmmunation1
	{290.3177,-38.7184,1001.5156} 	// LSAmmunation2
};

new WeaponDB[MAX_STRING] = "GTO/Weapon/";

WeaponLoadAll()
{
	if (ForceOverwrite) return;
	new temp[MAX_STRING];
	if (!dini_Exists(ConfigDB)) dini_Create(ConfigDB);
	set(temp,dini_Get(ConfigDB,"Weapon_DB"));
	if (strlen(temp) > 0) set(WeaponDB,temp);

	if (!dini_Exists(WeaponDB))
	{

		WeaponSaveAll();

		return;
	}
	for (new i=0;i<WeaponsSize;i++)
	{
		new weapondbname[MAX_STRING];
		format(weapondbname,sizeof(weapondbname),"%sGTO.Weapon.%s.txt",WeaponDB,Weapons[i][Weapon_Engname]);
		set(temp,dini_Get(weapondbname,"Name"));
		if (strlen(temp) > 0) set(Weapons[i][Weapon_Name],temp);
		set(temp,nullstr);
		set(temp,dini_Get(weapondbname,"IsAllowed"));
		if (strlen(temp) > 0) Weapons[i][Weapon_Allowed] = strval(temp);
		set(temp,nullstr);
		set(temp,dini_Get(weapondbname,"Level"));
		if (strlen(temp) > 0) Weapons[i][Weapon_Level] = strval(temp);
		set(temp,nullstr);
		set(temp,dini_Get(weapondbname,"Price"));
		if (strlen(temp) > 0) Weapons[i][Weapon_Cost] = strval(temp);
		set(temp,nullstr);
	}
	return;
}

WeaponSaveAll()
{

	new temp[MAX_STRING];
	if (dini_Exists(ConfigDB))
	{
		dini_Set_utf8(ConfigDB,"Weapon_DB",WeaponDB);
	}

	for (new i=0;i<WeaponsSize;i++)
	{
		new weapondbname[MAX_STRING];
		format(weapondbname,sizeof(weapondbname),"%sGTO.Weapon.%s.txt",WeaponDB,Weapons[i][Weapon_Engname]);
		if (!dini_Exists(weapondbname)) dini_Create(weapondbname);
		dini_Set_utf8(weapondbname,"Name",Weapons[i][Weapon_Name]);
		valstr(temp,Weapons[i][Weapon_Allowed]);
		dini_Set_utf8(weapondbname,"IsAllowed",temp);
		set(temp,nullstr);
		valstr(temp,Weapons[i][Weapon_Level]);
		dini_Set_utf8(weapondbname,"Level",temp);
		set(temp,nullstr);
		valstr(temp,Weapons[i][Weapon_Cost]);
		dini_Set_utf8(weapondbname,"Price",temp);
		set(temp,nullstr);
	}
	return;
}

public AmmunationInit()
{
	for (new id=0;id<AmmunationsCount;id++)
	{
		AddActiveCheckpoint(Ammunations[id][Coord_X],Ammunations[id][Coord_Y],Ammunations[id][Coord_Z],20,8);
	}
	WriteLog("Ammunition checkpoints initialised");
	FormatWeaponSkillCondGUIStrting();
}

public IsPlayerAtAmmunation(playerid)
{
	for (new id=0;id<AmmunationsCount;id++)
	{
		if (oIsPlayerInCheckpoint(playerid,Ammunations[id][Coord_X],Ammunations[id][Coord_Y],Ammunations[id][Coord_Z],8))
		{
			return 1;
		}
	}
	return 0;
}

public OnPlayerEnterAmmoCheckpoint(playerid)
{
	//if (playerid == INVALID_PLAYER_ID) return;
	//if (playerid == INVALIDX_PLAYER_ID) return;
	//if (!IsPlayerConnected(playerid)) return;
	if (!IsPlayerAtAmmunation(playerid)) return;
	SendPlayerFormattedText(playerid,  lang_texts[16][1]  , 0,COLOUR_GREEN);
	SendPlayerFormattedText(playerid,  lang_texts[16][2]  , 0,COLOUR_GREEN);
	SendPlayerFormattedText(playerid,  lang_texts[16][3]  , 0,COLOUR_GREEN);
	SendPlayerFormattedText(playerid,  lang_texts[16][4]  , 0,COLOUR_GREEN);

}

oGetWeaponName(weaponid)
{
	new name[MAX_NAME];
	new lookupid=GetWeaponLookupID(weaponid);
	if (lookupid == -1) return name;
	set(name,Weapons[lookupid][Weapon_Name]);
	return name;
}

stock GetWeaponSlot(weaponid)
{
	if(weaponid < 0 || weaponid >= WeaponsSize) {return -1;}
	new slot;
	slot = Weapons[weaponid][Weapon_Slot];
	return slot;
}

GetWeaponMaxAmmo(weaponid)
{
	new ammo;
	new lookupid=GetWeaponLookupID(weaponid);
	if (lookupid == -1) return ammo;
	ammo = Weapons[lookupid][Weapon_MaxBullets];
	return ammo;
}

public IsPlayerAllowedWeapon(playerid,weaponid)
{
	new lookupid=GetWeaponLookupID(weaponid);
	if (lookupid == -1) return 0;
	if (Weapons[lookupid][Weapon_Allowed] == 0) return 0;
	if (Weapons[lookupid][Weapon_Level] > GetPlayerLevel(playerid)) return 0;
	return 1;
}

IsWeaponHandToHand(weaponid)
{
	new weaponlookupid=GetWeaponLookupID(weaponid);
	if (weaponlookupid == -1) return 0;
	if (Weapons[weaponlookupid][Weapon_MaxBullets] == 1) return 1;
	return 0;
}

GetWeaponCost(weaponid)
{
	new weaponlookupid=GetWeaponLookupID(weaponid);
	if (weaponlookupid == -1) return 0;
	return Weapons[weaponlookupid][Weapon_Cost];
}

//---------------------------------УровеньОружия-------------------------------------//
//=========================================================================//
// GetWeaponLevel(weaponid)
// {
	// new weaponlookupid=GetWeaponLookupID(weaponid);
	// if (weaponlookupid == -1) return 0;
	// return Weapons[weaponlookupid][Weapon_Level];
// }
//=========================================================================//
//----------------------------------------------------------------------------------------//
GetWeaponLookupID(weaponid)
{
	new lookupid=-1;
	for (new i=0;i<WeaponsSize;i++)
	{
		if (weaponid == Weapons[i][Weapon_ID])
		{
			lookupid = i;
		}
	}
	return lookupid;
}

IsWeapon(weaponid)
{
	if ((weaponid >= 0) && (weaponid <= 46)) return 1;
	return 0;
}

IsStoreWeapon(weaponid)
{

	if ((weaponid >= 22) && (weaponid <= 32)) return 1;
	return 0;
	/*
22 Pistol,
23 Silenced Pistol,
24 Desert Eagle,
25 Shotgun,
26 Sawn Off Shotgun,
27 Combat Shotgun,
28 Micro Uzi (Mac 10),
29 MP5,
30 AK47,
31 M4,
32 Tec9,
*/
}

SendPlayerVendorWeapons(playerid)
{
	new string[MAX_STRING];
	SendPlayerFormattedText(playerid,  lang_texts[16][5]  , 0,COLOUR_GREEN);
	for (new weaponid=1;weaponid<MAX_WEAPONS;weaponid++)
	{
		if (IsPlayerAllowedWeapon(playerid,weaponid))
		{
			format(string,sizeof(string), lang_texts[16][6] ,oGetWeaponName(weaponid),GetWeaponCost(weaponid),weaponid);
			SendPlayerScrollingText(playerid, string);
		}
	}
}

/*public BuyWeapon(playerid,weaponid,bullets)
{
	new string[MAX_STRING];
	if ((weaponid < 1) || (weaponid > 46))
	{
		SendPlayerFormattedText(playerid,  lang_texts[16][7]  , 0,COLOUR_RED);
		return 0;
	}
	if ((bullets < 1) || (bullets > 9999))
	{
		SendPlayerFormattedText(playerid,  lang_texts[16][8]  , 0,COLOUR_RED);
		return 0;
	}
	if (!IsPlayerAtAmmunation(playerid))
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
//---- енд проверки на скилы
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

	oGivePlayerMoney(playerid,0-purchasecost,1);
	
	GiveSlotWeapon(playerid,weaponid,bullets);
		
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
}*/

public AmmunationCommandHandler(playerid,text[]) // process player commands
{
	if (!IsPlayerRegistered(playerid))
	{
		return 0; // non registered players dont use weapon commands
	}

	new cmd[20];
	new idx;

	set(cmd,strcharsplit(text, idx,strchar(" ")));
	if (strlen(cmd) == 0) return 0;

	if(strcomp(cmd, "/weapons", true) == 1)
	{

		SendPlayerOwnedWeapons(playerid);
		return 1;
	}
	
	if((strcomp(cmd, "/wl", true) == 1) || (strcomp(cmd, "/weaponlist", true) == 1))
	{
        GetGUIPlayerWeapons(playerid);
		return 1;
	}

	if((strcomp(cmd, "/wmenu", true) == 1) || (strcomp(cmd, "/weaponmenu", true) == 1))
	{
		DialogPlayerAmmo(playerid);
		return 1;
	}

	if((strcomp(cmd, "/wb", true) == 1) || (strcomp(cmd, "/weaponbuy", true) == 1))
	{
		if (!IsPlayerAtAmmunation(playerid))
		{
			SendPlayerFormattedText(playerid,  lang_texts[16][17]  , 0,COLOUR_RED);
			return 1;
		}

		// get weaponid
		new weaponid;
		set(cmd,strcharsplit(text, idx,strchar(" ")));
		if (strlen(cmd) == 0)
		{
			SendPlayerVendorWeapons(playerid);
			//SendPlayerFormattedText(playerid,  lang_texts[16][18]  , 0,COLOUR_RED);
			return 1;
		}
		weaponid = strval(cmd);
		if (weaponid <= 0)
		{
			SendPlayerFormattedText(playerid,  lang_texts[16][19]  , 0,COLOUR_RED);
			return 1;
		}

		// get bullets
		new bullets;
		set(cmd,strcharsplit(text, idx,strchar(" ")));
		if (strlen(cmd) == 0)
		{
			bullets=1;
		}
		else
		{
			bullets = strval(cmd);
		}
		if (bullets < 0)
		{
			SendPlayerFormattedText(playerid,  lang_texts[16][20]  , 0,COLOUR_RED);
			return 1;
		}
		BuyWeapon(playerid,weaponid,bullets);
		return 1;
	}

	if(strcomp(cmd, "/weapon", true) == 1)
	{
		set(cmd,strcharsplit(text, idx,strchar(" ")));

		if(strcomp(cmd, "help", true) == 1)
		{
   			SendPlayerFormattedText(playerid,  lang_texts[16][21]  , 0,COLOUR_RED);
			return 1;
		}

		if (strcomp(cmd, "list", true) == 1)
		{
//			if (!IsPlayerAtAmmunation(playerid))
//			{
//				SendPlayerFormattedText(playerid,  lang_texts[16][22]  , 0,COLOUR_RED);
//				return 1;
//			}
			//SendPlayerVendorWeapons(playerid);
			GetGUIPlayerWeapons(playerid);
			return 1;
		}

		if(strcomp(cmd, "buy", true) == 1)
		{
			if (!IsPlayerAtAmmunation(playerid))
			{
				SendPlayerFormattedText(playerid,  lang_texts[16][23]  , 0,COLOUR_RED);
				return 1;
			}

			// get weaponid
			new weaponid;
			set(cmd,strcharsplit(text, idx,strchar(" ")));
			if (strlen(cmd) == 0)
			{
				SendPlayerVendorWeapons(playerid);
				//SendPlayerFormattedText(playerid,  lang_texts[16][24]  , 0,COLOUR_RED);
				return 1;
			}
			weaponid = strval(cmd);
			if (weaponid <= 0)
			{
				SendPlayerFormattedText(playerid,  lang_texts[16][25]  , 0,COLOUR_RED);
				return 1;
			}

			// get bullets
			new bullets;
			set(cmd,strcharsplit(text, idx,strchar(" ")));
			if (strlen(cmd) == 0)
			{
				bullets=1;
			}
			else
			{
				bullets = strval(cmd);
			}
			if (bullets < 0)
			{
				SendPlayerFormattedText(playerid,  lang_texts[16][26]  , 0,COLOUR_RED);
				return 1;
			}
			BuyWeapon(playerid,weaponid,bullets);
			return 1;
		}
	}
	return 0;
}

//----------------------------GUI-------------------------------------
forward GetGUIPlayerWeapons(playerid);
public GetGUIPlayerWeapons(playerid)
{
new list[1024]; format(list, 32, "Оружие\tЦена\tID\n");
for (new weaponid=1;weaponid<MAX_WEAPONS;weaponid++)
{
if (IsPlayerAllowedWeapon(playerid,weaponid))
{
format(list,sizeof(list),"%s %s\t%d\t%d\n",list, oGetWeaponName(weaponid),GetWeaponCost(weaponid),weaponid);
}
}
ShowPlayerDialog(playerid,S_GUI_02,DIALOG_STYLE_TABLIST_HEADERS, "Доступный арсенал", list, "ОК", "");
return 1;
}

new bGUIWeaponID[MAX_PLAYERS];
new wtypes[128] = {"Холодное оружие\nПистолеты\nАвтоматы\nВинтовки\nШтурмовое\nДробовики\nТяжелое\nМетательное\nПрочее"};

public DialogPlayerAmmo(playerid)
{
if (!IsPlayerConnected(playerid)) return 0;
new s[MAX_STRING];
format(s,sizeof(s), "Мое оружие\nМои навыки\nОружие & Навыки\nДоступное оружие", oGetPlayerName(playerid));
//format(s,sizeof(s), "Мое оружие\nМои навыки\nОружие & Навыки\nКупить оружие", oGetPlayerName(playerid));
ShowPlayerDialog(playerid,WGUI+1,2,":: НАВИГАЦИЯ ::",s,"ОК ","НАЗАД");
return 1;
}

WSTR(weaponid)
{
/**/
new weaponguistr[64];
format(weaponguistr,sizeof(weaponguistr),"%s | L %d | $ %d",Weapons[weaponid][Weapon_Name],Weapons[weaponid][Weapon_Level],Weapons[weaponid][Weapon_Cost]);
return weaponguistr;
/*
new weaponguistr[128];

format(weaponguistr,sizeof(weaponguistr),"%s | L %d | $ %d",Weapons[weaponid][Weapon_Name],Weapons[weaponid][Weapon_Level],Weapons[weaponid][Weapon_Cost]);

if(Weapons[weaponid][Weapon_BuyCondition] != -1)
{
new cond = Weapons[weaponid][Weapon_BuyCondition];
format(weaponguistr,sizeof(weaponguistr),"%s | S: ",weaponguistr);

if(WeaponBuyBySkill[cond][skill_id_1] != -1 && WeaponBuyBySkill[cond][skill_min_1] != -1)
{
format(weaponguistr,sizeof(weaponguistr),"%s[id%d %.2f] ",weaponguistr,WeaponBuyBySkill[cond][skill_id_1], (WeaponBuyBySkill[cond][skill_min_1]+1)*0.01);
}

if(WeaponBuyBySkill[cond][skill_id_2] != -1 && WeaponBuyBySkill[cond][skill_min_2] != -1)
{
format(weaponguistr,sizeof(weaponguistr),"%s[id%d %.2f] ",weaponguistr,WeaponBuyBySkill[cond][skill_id_2], (WeaponBuyBySkill[cond][skill_min_2]+1)*0.01);
}

if(WeaponBuyBySkill[cond][skill_min_any] != -1)
{
format(weaponguistr,sizeof(weaponguistr),"%s[любой %.2f] ",weaponguistr, (WeaponBuyBySkill[cond][skill_min_2]+1)*0.01);
}


}
printf("%s",weaponguistr);

return weaponguistr;
*/
}
