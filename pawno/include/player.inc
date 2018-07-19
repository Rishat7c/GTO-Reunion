//
// Created:     05.09.06
// Aurthor:    Iain Gilbert
//ReCreate: Artem Firstov (Konsul)

#if defined _player_included
#endinput
#endif

#define _player_included
#pragma library player
#include "base"
#include "utils\gtoutils"
#include "utils\dutils"
#include "utils\gtodudb"
#include "utils\dini"
#include "account"
#include "weapons"

forward SpawnTimer();
forward PlayerHealthRegen();
forward SyncPlayers();
forward SyncMoney(playerid);
forward SyncHealth(id);
forward SyncArmour(id);
forward SyncWeapons(scanid);
forward CheckPlayerKick(playerid);
forward KickPlayer(playerid,reason[]);
forward HealthRegen(id);
forward GivePlayerOwnedWeapons(playerid);
forward GiveSlotWeapon(playerid,weaponid,bullets);
forward PlayerAntiFlood(playerid,text[]);
forward GivePlayerWeaponsSkill(playerid);
forward SendPlayerOwnedWeapons(playerid);
forward player_Spawn(playerid);
forward player_ResetStats(playerid);
forward IsPlayerRegistered(playerid);
forward player_Disconnect(playerid);
forward player_Connect(playerid);
forward PlayerDeath(playerid,killerid,reason);
forward PlayerKill(killerid, victimid, reason);
forward RegisterQuest(name[], type);
forward ResetQuest(playerid);
forward SendPlayerQuests(playerid);
forward oSetPlayerCheckpoint(playerid, Float:x, Float:y, Float:z, Float:size);
forward oSetPlayerRaceCheckpoint(playerid, type, Float:x, Float:y, Float:z, Float:xn, Float:yn, Float:zn, Float:size);
forward oDisablePlayerCheckpoint(playerid);
forward oDisablePlayerRaceCheckpoint(playerid);
forward oIsPlayerInCheckpoint(playerid,Float:cpx,Float:cpy,Float:cpz,dist);
forward oIsPlayerInRaceCheckpoint(playerid,Float:cpx,Float:cpy,Float:cpz,dist);
forward Float:GetMaxHealth(playerid);
forward GetXPToLevel(playerid,level);
forward CalculatePlayerLevel(playerid);
forward GetPlayerLevel(playerid);
forward GetPlayerXP(playerid);
forward SetPlayerXP(playerid, xpamount);
forward GivePlayerXP(playerid, xpamount,showtext);
forward oGivePlayerXP(playerid, xpamount,showtext);
forward CheckPlayerLevel(playerid);
forward PlayerLevelDown(playerid,level);
forward PlayerLevelUp(playerid,level);
forward oSetPlayerMoney(playerid,money);
forward oGivePlayerMoney(playerid,money,showtext);
forward GetPlayerTotalMoney(playerid);
forward oGetPlayerMoney(playerid);
forward SetPlayerMoney(playerid,money);
forward UpdatePlayerScore(playerid);
forward UpdateWeaponSkill(playerid,reason);
forward Float:oGetPlayerHealth(playerid);
forward Float:oGetPlayerArmour(playerid);
forward oSetPlayerHealth(playerid,Float:health);
forward oSetPlayerArmour(playerid,Float:armour);
forward oGivePlayerWeapon(playerid,weaponid,ammo);
forward PlayerSave(playerid);
forward CreatePlayer(playerid);
forward PlayerLoadStats(playerid);
forward JailPlayer(playerid);
forward UnJailPlayer(playerid);
forward GiveWantedLevel(playerid,level);
forward SetWantedLevel(playerid,level);
forward CheckWantedLevel(playerid);
forward CurrentCriminalsCheck(playerid);
forward SetColorForWantedLevel(playerid);
forward AmmoBankOffGuns(playerid);
forward SaveGameCheck(playerid);
forward oPutPlayerInVehicle(playerid, vehicleid, seatid);
forward GivePlayerRaceXP(playerid,xpamount);
forward SilentMessage(playerid,message[]);

forward pm_addto_blacklist(playerid,badid);
forward pm_show_blacklist(playerid);
forward pm_clear_blacklist(playerid);

#define MAX_MONEY 80000000
#define PLAYER_SYNC_DELAY 1000
#define MAX_DESYNC 5000
#define HEALTH_REGEN_SPEED 5000
#define ARMOUR_REGEN_SPEED 5000

#define PM_BAD_SLOTS_MAX 5

#define MinHydraLevel 20
#define MinHunterLevel 30
#define MinRhinoLevel 10

#define SAVE_TIME 600 //time in seconds to automatic save game

#define MAX_DM 50

#define JAIL_KICK_ONE 5
#define JAIL_KICK_TWO 10

new PlayerDB[MAX_STRING] = "GTO/Player/";
new PlayerArrow[MAX_PLAYERS];

new DataXP[MAX_PLAYERS];
new DataMoney[MAX_PLAYERS];
new NewPlayer[MAX_PLAYERS];

//====================================================================================
enum CmdTimers{
Time_Heal,
Time_Repair,
Time_Nitro,
Time_Skydive,
Time_GPS,
Time_SaveGame, // not command! this is time to autosave game
Time_SCommand,
Time_CarTP,
Time_PTBB,
Time_Chat
}
new CmdTimer[MAX_PLAYERS][CmdTimers];
//====================================================================================
//----------AntiFlood-----------
new PlayerChatString[MAX_PLAYERS][3][MAX_STRING];
//----------PM_Black------------
new PlayerPMBlack[MAX_PLAYERS][PM_BAD_SLOTS_MAX][MAX_NAME];
//------------------------------
//new PlayerSkin[MAX_PLAYERS];
new AWS[MAX_PLAYERS];

new PlayerWeapons[MAX_PLAYERS][MAX_WEAPONS];

new PlayerTempWeapons[MAX_PLAYERS][MAX_WEAPONS];

new PlayerSpeedoCarName[MAX_PLAYERS][32];

new PlayerCurrentKills[MAX_PLAYERS];

new PlayerGangID[MAX_PLAYERS]; //10
new GangInvite[MAX_PLAYERS]; //10
new PlayerGangSQLID[MAX_PLAYERS]; //10
new PlayerGangName[MAX_PLAYERS][MAX_NAME];
new PlayerGangTag[MAX_PLAYERS][MAX_TAG_LEN];

new PlayerSpawn[MAX_PLAYERS][CoordInfo];
new SpawnTime[MAX_PLAYERS];

new ChatPopitki[MAX_PLAYERS]; //переменная содержащая количество вводов сообщения в чате для незарегистрированных игроков
new Suecid[MAX_PLAYERS]; //переменная отвечает за проверку самоубийства игрока, чтобы ранивший его игрок не получил хр

new SelectedID[MAX_PLAYERS];

enum Quest_Stats {
	Quest_Name[MAX_NAME],
	Quest_Type // 0 - Unknown, 1 - race, 2 - dm, 3 - industrial
}

new PlayerQuest[MAX_PLAYERS]; // holds id of quest player is currently doing
new Quests[MAX_QUESTS][Quest_Stats]; // table of all registered quests
new QuestCount;

new Float:PlayerCP[MAX_PLAYERS][CoordInfo];
new Float:PlayerRCP[MAX_PLAYERS][CoordInfo];
//new Float:PlayerRCPSize[MAX_PLAYERS];

new bool:PlayerCPActive[MAX_PLAYERS];
new bool:PlayerRCPActive[MAX_PLAYERS];

new MoneyKick[MAX_PLAYERS];
new HealthKick[MAX_PLAYERS];
new ArmourKick[MAX_PLAYERS];
new MoneyUpdateDelay[MAX_PLAYERS];
new HealthUpdateDelay[MAX_PLAYERS];
new ArmourUpdateDelay[MAX_PLAYERS];
new PlayerJustTeleported[MAX_PLAYERS];

new PlayerStartMoney = 800;
new PlayerJailed = 0;
new PlayerMuted = 0;
new PlayerStartWeapon1 = WEAPON_COLT45;
new PlayerStartWeapon2 = 0;
new PlayerStartWeapon3 = 0;

enum ZONEPlayerInfo
{
	zone_player_active // is the player active and spawned in the deathmatch zone
}
new ZONEPlayerStats[MAX_PLAYERS][ZONEPlayerInfo];

enum PlayerSpawnInfo {
playerspawn_level,
Float:playerspawn_x,
Float:playerspawn_y,
Float:playerspawn_z,
Float:playerspawn_heading
}

#define PLAYERSPAWNS_SIZE 38
new Float:LeveledPlayerSpawns[PLAYERSPAWNS_SIZE][PlayerSpawnInfo] = {
	{0,2517.5344,-1694.0607,18.4772,47.2527}, // lvl0spawn1
	{0,2494.6113,-1694.2920,23.5697,7.8082}, // lvl0ps
	{0,2524.2092,-1675.8125,19.9302,65.8183}, // lvl0ps
	{3,2066.9448,-1700.1219,14.1484,276.0525}, // lvl3spawn
	{3,2065.0754,-1732.0588,18.7969,308.6771}, // lvl3spawn
	{3,2042.3877,-1722.0016,13.5469,339.7588}, // lvl3spawn
	{3,2040.6575,-1646.1099,13.5469,1.2393}, // lvl3spawn
	{5,1641.0234,-1545.1201,13.5803,293.5606}, // lvl5spawn
	{5,1585.7887,-1539.0266,13.5864,265.2574}, // lv5spaawn
	{5,1606.7871,-1476.6110,13.5804,0.8114}, // lv5 spawn
	{6,1885.8452,-1087.4312,23.9185,279.8816}, // lv6spawn
	{6,2008.4741,-1098.7870,24.9058,256.2135}, // lv6spawn
	{6,2045.3113,-1158.0294,23.4437,145.6347}, // lv6spawn
	{6,2022.5231,-1210.7472,21.7610,35.7139}, // lv6spawn
	{6,1933.6676,-1226.6060,20.1364,97.0786}, // lv6spawn
	{7,1332.1099,-911.0746,39.5781,168.9972}, // lv7spawn
	{7,1309.1066,-847.0045,64.8932,315.8327}, // lv7spawn
	{7,1285.2598,-830.9579,83.1406,171.4035}, // lv7spawn
	{7,1243.5209,-743.7954,94.9519,191.1576}, // lv7spawn
	{8,655.1062,-543.5223,16.3281,349.4992}, // lvl8player
	{8,702.5857,-463.9641,16.3359,189.5556}, // lvl8play
	{8,852.9753,-587.0893,18.0406,8.3576}, // play8
	{8,744.7605,-582.7914,16.9987,84.0696}, // play8
	{9,248.1220,-278.0332,1.5781,52.9390}, // play9
	{9,326.3771,-53.1227,1.5285,111.6351}, // play9
	{9,214.2944,-89.7956,1.5710,312.5051}, // play9
	{10,614.6899,43.1528,0.0748,344.7167}, // play10
	{10,867.4291,-30.7355,63.1953,176.7125}, // play10
	{10,1011.3226,11.4864,93.0156,302.5121}, // play10
	{11,751.2596,383.9003,23.1719,335.8973}, // play10
	{11,1222.3271,300.4901,19.5547,155.6648}, // play11
	{11,1284.9962,175.7558,20.3423,73.2174}, // play11
	{12,1426.9465,371.7816,18.8869,257.0709}, // play11
	{12,1572.3761,36.5942,24.5907,242.6472}, // play11
	{14,2215.1565,123.8511,26.4844,350.1021}, // play12
	{15,2281.3704,-49.9920,27.0176,207.7730}, // play12
	{17,2162.9019,-102.3568,2.7500,27.7265}, // play12
	{18,2459.7744,-40.9547,26.4844,25.8460} // play12
};

// LVDMSpawns
new Float:LVDMPlayerSpawns[23][CoordInfo] = {
	{1958.3783,1343.1572,15.3746},
	{2199.6531,1393.3678,10.8203},
	{2483.5977,1222.0825,10.8203},
	{2637.2712,1129.2743,11.1797},
	{2000.0106,1521.1111,17.0625},
	{2024.8190,1917.9425,12.3386},
	{2261.9048,2035.9547,10.8203},
	{2262.0986,2398.6572,10.8203},
	{2244.2566,2523.7280,10.8203},
	{2335.3228,2786.4478,10.8203},
	{2150.0186,2734.2297,11.1763},
	{2158.0811,2797.5488,10.8203},
	{1969.8301,2722.8564,10.8203},
	{1652.0555,2709.4072,10.8265},
	{1564.0052,2756.9463,10.8203},
	{1271.5452,2554.0227,10.8203},
	{1441.5894,2567.9099,10.8203},
	{1480.6473,2213.5718,11.0234},
	{1400.5906,2225.6960,11.0234},
	{1598.8419,2221.5676,11.0625},
	{1318.7759,1251.3580,10.8203},
	{1558.0731,1007.8292,10.8125},
	{1705.2347,1025.6808,10.8203}
};

public Float:GetMaxHealth(playerid)
{
	//Debug("player.inc > Float:GetMaxHealth(playerid) - Start");
	if (!IsPlayerConnected(playerid)) {return 0.0;}
	new Float:maxhealth=50.0;
////	new Float:maxhealth=oGetPlayerHealth(playerid);
	if (Player[playerid][Level] == 0) {return 50.0;}
	if (Player[playerid][Level] >= 10) return 100.0;
	maxhealth = (50.0 + (Player[playerid][Level] * 5.0));
	//Debug("player.inc > Float:GetMaxHealth(playerid) - Stop");
	return maxhealth;
}

public Float:oGetPlayerHealth(playerid)
{
	//Debug("player.inc > Float:oGetPlayerHealth(playerid) - Start");
	new Float:health;
	GetPlayerHealth(playerid, health);
	//Debug("player.inc > Float:oGetPlayerHealth(playerid) - Stop");
	return health;
}

public Float:oGetPlayerArmour(playerid)
{
	new Float:armour;
	GetPlayerArmour(playerid, armour);
	return armour;
}

PlayerLoadConfig()
{
	//Debug("player.inc > PlayerLoadConfig() - Start");
	if (ForceOverwrite)
	{
		//Debug("player.inc > PlayerLoadConfig() - Stop(158)");
		return;
	}
	if (!dini_Exists(ConfigDB))
	{
		//Debug("player.inc > PlayerLoadConfig() - Stop(163)");
		return;
	}
	new temp[MAX_STRING];
	set(temp,dini_Get(ConfigDB,"Player_DB"));
	if (strlen(temp) > 0) set(PlayerDB,temp);
	set(temp,nullstr);
	set(temp,dini_Get(ConfigDB,"Player_Start_Money"));
	if (strlen(temp) > 0) PlayerStartMoney = strval(temp);
	set(temp,nullstr);
	set(temp,dini_Get(ConfigDB,"Player_Start_Weapon1"));
	if (strlen(temp) > 0) PlayerStartWeapon1 = strval(temp);
	set(temp,nullstr);
	set(temp,dini_Get(ConfigDB,"Player_Start_Weapon2"));
	if (strlen(temp) > 0) PlayerStartWeapon2 = strval(temp);
	set(temp,nullstr);
	set(temp,dini_Get(ConfigDB,"Player_Start_Weapon3"));
	if (strlen(temp) > 0) PlayerStartWeapon3 = strval(temp);
	set(temp,nullstr);
	set(temp,dini_Get(ConfigDB,"Player_Jailed"));
	if (strlen(temp) > 0) PlayerJailed = strval(temp);
	set(temp,nullstr);
	set(temp,dini_Get(ConfigDB,"Player_Muted"));
	if (strlen(temp) > 0) PlayerMuted = strval(temp);
	set(temp,nullstr);
	//Debug("player.inc > PlayerLoadConfig() - Stop");
	return;
}

PlayerSaveConfig()
{
	//Debug("player.inc > PlayerSaveConfig() - Start");
	if (!dini_Exists(ConfigDB))
	{
		//Debug("player.inc > PlayerSaveConfig() - Stop(191)");
		return;
	}
	dini_Set(ConfigDB,"Player_DB",PlayerDB);
	dini_Set(ConfigDB,"Player_Start_Money",ovalstr(PlayerStartMoney));
	dini_Set(ConfigDB,"Player_Start_Weapon1",ovalstr(PlayerStartWeapon1));
	dini_Set(ConfigDB,"Player_Start_Weapon2",ovalstr(PlayerStartWeapon2));
	dini_Set(ConfigDB,"Player_Start_Weapon3",ovalstr(PlayerStartWeapon3));
	dini_Set(ConfigDB,"Player_Jailed",ovalstr(PlayerJailed));
	dini_Set(ConfigDB,"Player_Muted",ovalstr(PlayerMuted));
	//Debug("player.inc > PlayerSaveConfig() - Stop");
	return;
}

public SpawnTimer()
{
new str[256];
for (new playerid=0;playerid<MAX_PLAYERS;playerid++)
	{
		if (IsPlayerConnected(playerid))
		{
			SpawnTime[playerid]++;
			
			if(IsPlayerNPC(playerid)) {continue;}
			if(!IsPlayerRegistered(playerid) && SpawnTime[playerid] > MAXUNREGTIME)
			{
				new string[MAX_STRING];
				format(string,sizeof(string),lang_texts[15][96],MAXUNREGTIME);
				SendClientMessage(playerid,COLOUR_WHITE,string);
				Kick(playerid);
				continue;
			}
			if(SpawnTime[playerid] >= 25 && SpawnTime[playerid] < 30)
			{
				if(GetPlayerPing(playerid) > MAX_PING)
				{
					SendClientMessage(playerid,COLOUR_RED, lang_texts[20][1] );				
					format(str, sizeof(str), lang_texts[20][2] , oGetPlayerName(playerid), playerid);
					SendClientMessageToAll(COLOUR_YELLOW,str);
					Kick(playerid);
					continue;
				}
			}
			if(SpawnTime[playerid] == 30) {SendClientMessage(playerid,COLOUR_GREEN, lang_texts[20][3] );}
		}
	}
}

// needs to be ran by a timer
// sync player hp/money and check for mismatch
public PlayerHealthRegen()
{
	////Debug("player.inc > PlayerHealthRegen() - Start");
	for (new playerid = 0; playerid < MAX_PLAYERS; playerid++)
	{
		if ((!IsPlayerConnected(playerid)) || (Player[playerid][IsActive] == 0)) continue;
		HealthRegen(playerid);
	}
	////Debug("player.inc > PlayerHealthRegen() - Stop");
	return;
}

forward PlayerArmourRegen();
forward ArmourRegen(id);
public PlayerArmourRegen()
{
	for (new playerid = 0; playerid < MAX_PLAYERS; playerid++)
	{
		if ((!IsPlayerConnected(playerid)) || (Player[playerid][IsActive] == 0)) continue;
		if(Player[playerid][Vip] > 2)
		{
			ArmourRegen(playerid);
		}
	}
	return;
}

// needs to be ran by a timer
// sync player hp/money and check for mismatch
public SyncPlayers()
{
	////Debug("player.inc > SyncPlayers() - Start");
	for (new playerid = 0; playerid < MAX_PLAYERS; playerid++)
	{
		if ((!IsPlayerConnected(playerid)) || (Player[playerid][IsActive] == 0)) continue;
		if (PlayerJustTeleported[playerid] > 0) PlayerJustTeleported[playerid]--;

		SyncMoney(playerid);
		SyncHealth(playerid);
		if(Player[playerid][Vip] > 2)
		{
			SyncArmour(playerid);
		}
		CheckPlayerKick(playerid);
		JailPlayer(playerid);		
		CmdTimeCheck(playerid);
	}
	////Debug("player.inc > SyncPlayers() - Stop");
	return;
}

new PlayerCasinoMoney[MAX_PLAYERS];

public SyncMoney(playerid)
{
	//Debug("player.inc > SyncMoney(playerid) - Start");
	if (!IsPlayerConnected(playerid))
	{
		if (PlayerCasinoMoney[playerid] != 0) PlayerCasinoMoney[playerid] = 0;
		MoneyKick[playerid] = 0;
		//Debug("player.inc > SyncMoney(playerid) - Stop(257)");
		return;
	}

	if (MoneyKick[playerid] >= (MAX_DESYNC/PLAYER_SYNC_DELAY)) KickPlayer(playerid,"Несоответствие денег(Тип 1)(Чит?)");

	if (MoneyUpdateDelay[playerid] > 0)
	{
		MoneyUpdateDelay[playerid]--;
		//Debug("player.inc > SyncMoney(playerid) - Stop(266)");
		return;
	}

	new clientmoney;
	clientmoney = GetPlayerMoney(playerid);

	if (clientmoney == Player[playerid][Money]) //
	{
		MoneyKick[playerid] = 0;
		//Debug("player.inc > SyncMoney(playerid) - Stop(276)");
		return;
	}

	if (IsPlayerInCasino(playerid))
	{
		if (clientmoney > Player[playerid][Money]+(MAX_WIN*2)) // if players money is lots more
		{
			//printf("Desync 4 | client %d | player %d",clientmoney,Player[playerid][Money]);
			new string[MAX_STRING];
			format(string,sizeof(string), lang_texts[9][1] ,MAX_WIN);
			SendClientMessage(playerid,COLOUR_RED, string);
			oSetPlayerMoney(playerid,Player[playerid][Money]+MAX_WIN); // set money
			MoneyKick[playerid]++; //
			PlayerCasinoMoney[playerid] = PlayerCasinoMoney[playerid]+MAX_WIN;
			if (clientmoney == Player[playerid][Money])
			{
				MoneyKick[playerid]=0;
			}
		}
		else if (clientmoney > Player[playerid][Money])
		{
			new win = clientmoney - Player[playerid][Money];
			new string[MAX_STRING];
			format(string,sizeof(string), lang_texts[9][2] ,win);
			SendClientMessage(playerid,COLOUR_MONEY_GOOD, string);
			PlayerCasinoMoney[playerid] = PlayerCasinoMoney[playerid]+win;
			oSetPlayerMoney(playerid,clientmoney);
			MoneyKick[playerid]=0;
		}
		else // clientmoney must be <= severmoney
		{
			new loss;
			loss = clientmoney + Player[playerid][Money];
			oSetPlayerMoney(playerid,clientmoney);
			MoneyKick[playerid]=0;
			PlayerCasinoMoney[playerid] = PlayerCasinoMoney[playerid]-loss;
		}

		if (PlayerCasinoMoney[playerid] > MAX_WIN*1.5)
		{
			new string[MAX_STRING];
			format(string,sizeof(string), lang_texts[9][3] ,MAX_WIN);
			SendClientMessage(playerid,COLOUR_RED, string);
			if (clientmoney > PlayerCasinoMoney[playerid] + MAX_WIN*2)
			{
				KickPlayer(playerid,"Выиграно слишком много в казино(Чит?)");
			}
		}
	}
	else
	{
		PlayerCasinoMoney[playerid] = 0;
	}

	if (clientmoney < 0) // if negative value
	{
		//printf("Desync 3 | client %d | player %d",clientmoney,Player[playerid][Money]);
		MoneyKick[playerid]++;
		oSetPlayerMoney(playerid,0);	//set 0 money
		//Debug("player.inc > SyncMoney(playerid) - Stop(335)");
		return;
	}

	if (clientmoney < Player[playerid][Money]) // if players money is less (they bought something)
	{
//		#if defined _bank_included
		if (!IsPlayerAtBank(playerid))
		{
			//printf("Desync 5 | client %d | player %d",clientmoney,Player[playerid][Money]);
			oSetPlayerMoney(playerid,Player[playerid][Money]); // set our money to player money
			MoneyKick[playerid] = 0;
		}
//#else
		//oSetPlayerMoney(clientmoney); // set our money to player money
		//MoneyKick[playerid] = 0;
//#endif
	}


	if (clientmoney > Player[playerid][Money]) // if players money is more
	{
		if ((clientmoney > Player[playerid][Money]+MAX_WIN*2) && (MoneyUpdateDelay[playerid] == 0)) // if players money is lots more
		{
			KickPlayer(playerid,"Несоответствие денег(Тип 2)(Чит?)");
			//Debug("player.inc > SyncMoney(playerid) - Stop(359)");
			return;
		}

		if (!IsPlayerInCasino(playerid))
		{
			//printf("Desync 2 | client %d | player %d",clientmoney,Player[playerid][Money]);
			oSetPlayerMoney(playerid,Player[playerid][Money]); // set money
			MoneyKick[playerid]++; //
		}
	}
	
	clientmoney = GetPlayerMoney(playerid);

	if (clientmoney != Player[playerid][Money]) // if still not equal
	{
		//printf("Desync 1 | client %d | player %d",clientmoney,Player[playerid][Money]);
		MoneyKick[playerid]++; //
		oSetPlayerMoney(playerid,Player[playerid][Money]);
		//Debug("player.inc > SyncMoney(playerid) - Stop(380)");
		return;
	}
	else
	{
		MoneyKick[playerid]=0;
	}
	//Debug("player.inc > SyncMoney(playerid) - Stop");
	return;
}

public SyncWeapons(scanid)
{
//SendClientMessage(playerid,COLOUR_BLUE,"|    ::: MIRANDA v2.1 ::: ::: Total Weapons Scaner :::");
new weaponid;
new ammo;
new status = 0;
//new scanid = 0;
//while(scanid <= MAX_PLAYERS)
//for(new scanid = 0;scanid<MAX_PLAYERS;scanid++)
//{
//if(IsPlayerConnected(scanid)) {continue;}
//if(IsPlayerNPC(scanid)) {continue;}
//new slotid = 1;
//while(slotid <= 12)
for(new slotid = 1;slotid<13;slotid++)
{
GetPlayerWeaponData(scanid,slotid,weaponid,ammo);
//if((!IsPlayerAdmin(scanid) || !IsPlayerAdm(scanid)) && (weaponid != 0) && (weaponid != 46))
if(ammo < 1){continue;}
if((weaponid != 0) && (weaponid != 46))
{
if(((weaponid < 22) || (weaponid > 33)) && !IsPlayerAllowedWeapon(scanid,weaponid) && !IsPlayerInAnyDM(scanid))
{
new enemy[MAX_STRING];
format(enemy,sizeof(enemy),"Found danger | Player %s | id %d | Level %d | Slot %d | %s | %d",oGetPlayerName(scanid), scanid, GetPlayerLevel(scanid), slotid, oGetWeaponName(weaponid), ammo);
//SendClientMessage(playerid,COLOUR_ORANGE,enemy);
print(enemy);
//PlayerPlaySound(playerid,1057,0,0,0);
status = 1;
}
if(IsPlayerInAnyDM(scanid) && !IsWeaponAllowedInDM(weaponid,GetPlayerDM(scanid)))
{
new enemy[MAX_STRING];
format(enemy,sizeof(enemy),"Wrong weapon in %d DM| Player %s | id %d | Level %d | Slot %d | %s | %d",GetPlayerDM(scanid),oGetPlayerName(scanid), scanid, GetPlayerLevel(scanid), slotid, oGetWeaponName(weaponid), ammo);
//SendClientMessage(playerid,COLOUR_ORANGE,enemy);
print(enemy);
//PlayerPlaySound(playerid,1057,0,0,0);
status = 1;
}
}

//slotid = slotid+1;
}
//scanid = scanid+1;
//}
if(status == 0)
{
//SendClientMessage(playerid,COLOUR_ORANGE,"DANGER NOT FOUND");
//SendClientMessage(playerid,COLOUR_LIME,"|__  MIRANDA OUTPUT >>> COMPLETED SUCCESS");
print("MIRANDA OUTPUT >>> COMPLETED SUCCESS");
}
else
{
//SendClientMessage(playerid,COLOUR_CRIMSON,"|__  MIRANDA OUTPUT >>> DETECTED DANGER");
print("MIRANDA OUTPUT >>> DETECTED DANGER");
}
return 1;
}

public SyncHealth(id)
{
    if (HealthKick[id] > 4)
    {
        KickPlayer(id, "Дисбаланс Здоровья. (Лаг или Чит)");
        return;
    }

    if (HealthUpdateDelay[id] != 0)
    {
        return;
    }
    /* replaced to OnPlayerUpdate
    if (HealthUpdateDelay[id] > 0)
    {
        HealthUpdateDelay[id]--;
        return;
    }
    */

    new Float:clienthealth;
    clienthealth = oGetPlayerHealth(id);

    if (clienthealth < 0) // if we have negative health
    {
        HealthKick[id] = 0;
        oSetPlayerHealth(id,0);
        printf("> Health [1] | client = %f | server = %f | playerid = %d",clienthealth,Player[id][Health],id);
        return;
    }

    if (clienthealth == Player[id][Health]) // if our health valus match
    {
        HealthKick[id] = 0;
        return;
    }

    if (clienthealth < Player[id][Health]) // if client has less health
    {
        HealthKick[id] = 0;
        Player[id][Health] = clienthealth; // update our server value
    }

    if (clienthealth > Player[id][Health]) // if client has more health
    {
        HealthKick[id]++;
        printf("> Health [2] | client = %f | server = %f | playerid = %d",clienthealth,Player[id][Health],id);
        SetPlayerHealth(id,Player[id][Health]);
        return;
    }

    /* No point doing that
    clienthealth = oGetPlayerHealth(id);

    if (clienthealth != Player[id][Health]) // if still not equal
    {
        printf("> Health [3] | client = %f | server = %f | playerid = %d",clienthealth,Player[id][Health],id);
        SetPlayerHealth(id,Player[id][Health]);
        HealthKick[id]++; //
    }
    */

    return;
}

public SyncArmour(id)
{
	if (!IsPlayerConnected(id))
	{
		return;
	}
	if (ArmourKick[id] >= (MAX_DESYNC/PLAYER_SYNC_DELAY) && !IsPlayerNPC(id)) KickPlayer(id,"Дисбаланс бронежилета. (Лаг или Чит)");

	if (ArmourUpdateDelay[id] > 0)
	{
		ArmourUpdateDelay[id] = 0;
		return;
	}


	new Float:clientarm;
	clientarm = oGetPlayerArmour(id);
	
	/*if (clientarm < 0) // if we have negative health
	{
		ArmourKick[id] = 0;
		oSetPlayerArmour(id,0);
		return;
	}*/

	if (clientarm == Player[id][Armour]) // if our health valus match
	{
		ArmourKick[id] = 0;
		return;
	}

	if (clientarm < Player[id][Health]) // if client has less health
	{
		ArmourKick[id] = 0;
		Player[id][Armour] = clientarm; // update our server value
	}

	if (clientarm > Player[id][Armour]) // if client has more health
	{
		//if (Player[id][Health] == 0) return;
		if (!IsPlayerInStore(id))
		{
			ArmourKick[id]++;
			SetPlayerArmour(id,Player[id][Armour]);
		}
		else // player in store
		{
			if (clientarm <= 100)
			{
				oSetPlayerArmour(id,clientarm);
				ArmourKick[id]=0;
			}
			else
			{
				ArmourKick[id]++;
			}
		}
		return;
	}

	if (clientarm != Player[id][Armour]) // if still not equal
	{
		SetPlayerArmour(id,Player[id][Health]);
		ArmourKick[id]++; //
	}
	return;
}


// Check if any players have been marked to kick, and kicks them
public CheckPlayerKick(playerid)
{
	//Debug("player.inc > CheckPlayerKick(playerid) - Start");
	if(IsPlayerConnected(playerid))
	{
		if (KickList[playerid] == 1) // if we wanna kick this player
		{
			GameTextForPlayer(playerid,"~r~Connection Lost.",999,5); //  send msg first
			TogglePlayerControllable(playerid,0);
			KickList[playerid]=2;
		}
		else if (KickList[playerid] >=2) // wait a second before doing the kicking (for msg to get through)
		{

			new logstring[256];
			format(logstring, sizeof (logstring), "player: %d:  %s: has been auto kicked",playerid,oGetPlayerName(playerid));
			WriteLog(logstring);
			KickList[playerid] = 0;
			//if (IsPlayerRegistered(playerid))
			//{
			//PlayerSave(playerid);
			//AccountSave(playerid);
			//}
			//GangMemberLogout(playerid,PlayerGangID[playerid]);
			player_Disconnect(playerid);
			Kick(playerid);
			//Debug("player.inc > CheckPlayerKick(playerid) - Stop(489)");
			return;
		}
	}
	//Debug("player.inc > CheckPlayerKick(playerid) - Stop");
}

public KickPlayer(playerid,reason[])
{
	//Debug("player.inc > KickPlayer(playerid,reason[]) - Start");
	if (!IsPlayerConnected(playerid))
	{
		//Debug("player.inc > KickPlayer(playerid,reason[]) - Stop(501)");
		return;
	}
	new string[MAX_STRING];
	if (IsPlayerAdmin(playerid))
	{
		format(string,sizeof(string), lang_texts[9][4] ,reason);
		SendClientMessage(playerid,COLOUR_YELLOW, string);
		//Debug("player.inc > KickPlayer(playerid,reason[]) - Stop(509)");
		return;
	}
	if (KickList[playerid] != 0)
	{
		//Debug("player.inc > KickPlayer(playerid,reason[]) - Stop(514)");
		return; // we are already kicking this player
	}
	KickList[playerid]++;
	if (strlen(reason) > 0)
	{
		format(string,sizeof(string), lang_texts[9][5] ,reason);
		SendClientMessage(playerid,COLOUR_RED, string);
		format(string,sizeof(string), lang_texts[9][6] ,oGetPlayerName(playerid),reason);
		SendClientMessageToRegistered(COLOUR_MISC, string);
		new logstring[256];
		format(logstring, sizeof (logstring), "player: %d:  %s: ping %d: has been auto kicked. Reason: %s",playerid,oGetPlayerName(playerid),GetPlayerPing(playerid), reason);
		WriteLog(logstring);
	}
	//Debug("player.inc > KickPlayer(playerid,reason[]) - Start");
	return;
}

public HealthRegen(id)
{
	//Debug("player.inc > HealthRegen(id) - Start");
	if ((Player[id][Health] <= 0) || (Player[id][Health] >= 100))
	{
		//Debug("player.inc > HealthRegen(id) - Stop(538)");
		return;
	}
	if(IsPlayerActiveInDM(id) == 1){return;}
	if (Player[id][Health] < MIN_HEALTH+(Player[id][Level]*5.0)) // if we regenerate health
	{
		new Float:newhealth;
		newhealth = Player[id][Health]+((Player[id][Level]*0.25));
		if (newhealth > 100) newhealth = 100;
		oSetPlayerHealth(id, newhealth); // give some health
	}
	//Debug("player.inc > HealthRegen(id) - Stop");
}

public ArmourRegen(id)
{
	if ((Player[id][Armour] <= 0) || (Player[id][Armour] >= 100))
	{
		return;
	}
	if(IsPlayerActiveInDM(id) == 1){return;}
	if (Player[id][Armour] < MIN_ARMOUR+(Player[id][Level]*5.0)) // if we regenerate health
	{
		new Float:newarm;
		newarm = Player[id][Armour]+((Player[id][Level]*0.25));
		if (newarm > 100) newarm = 100;
		SetPlayerArmour(id, newarm);
		SetPlayerChatBubble(id, "Регенерация брони VIP", 0x33FF33AA, 50.0, 1500);
	}
}

public GivePlayerOwnedWeapons(playerid)
{
	//Debug("player.inc > GivePlayerOwnedWeapons(playerid) - Start");
	ResetPlayerWeapons(playerid);
	for (new i = 1;i<MAX_WEAPONS;i++)
	{
		if (IsPlayerAllowedWeapon(playerid,i))
		{
			if (PlayerWeapons[playerid][i] > 0) GivePlayerWeapon(playerid,i,PlayerWeapons[playerid][i]);
		}
	}
	//Debug("player.inc > GivePlayerOwnedWeapons(playerid) - Stop");
}

public GiveSlotWeapon(playerid,weaponid,bullets)
{
if(weaponid < 0 || weaponid >= WeaponsSize) {return 0;}

for (new i = 1;i<WeaponsSize;i++)
{
if (Weapons[i][Weapon_Slot] == Weapons[weaponid][Weapon_Slot])
{
if( i != weaponid)
{
PlayerWeapons[playerid][i] = 0;
}
}
}
oGivePlayerWeapon(playerid,weaponid,bullets);
GivePlayerOwnedWeapons(playerid);
return 1;
}

GetGUIPlayerWeaponsStr(playerid)
{
new weaponpstr[255];

for (new weaponid=1;weaponid<WeaponsSize;weaponid++)
{
if (PlayerWeapons[playerid][weaponid] <= 0) continue;
format(weaponpstr,sizeof(weaponpstr),"%s\n%s \t S %d \t A %d",weaponpstr,oGetWeaponName(weaponid),Weapons[weaponid][Weapon_Slot],PlayerWeapons[playerid][weaponid]);
}
return weaponpstr;
}

public GivePlayerWeaponsSkill(playerid)
{
for (new i=0;i<WEAPONS_SKILLS;i++)
{
SetPlayerSkillLevel(playerid, i, PlayerWeaponsSkill[playerid][i]);
}
}

public SendPlayerOwnedWeapons(playerid)
{
	//Debug("player.inc > SendPlayerOwnedWeapons(playerid) - Start");
	new string[MAX_STRING];
	SendPlayerFormattedText(playerid,  lang_texts[9][7]  , 0,COLOUR_GREEN);
	for (new weaponid=1;weaponid<MAX_WEAPONS;weaponid++)
	{
		if (PlayerWeapons[playerid][weaponid] <= 0) continue;
		if (PlayerWeapons[playerid][weaponid] > 1)
		{
			format(string,sizeof(string), lang_texts[9][8] ,oGetWeaponName(weaponid),PlayerWeapons[playerid][weaponid]);
			SendPlayerFormattedText(playerid, string,0,COLOUR_MISC);
		}
		else if (PlayerWeapons[playerid][weaponid] == 1)
		{
			format(string,sizeof(string), lang_texts[9][9] ,oGetWeaponName(weaponid));
			SendPlayerFormattedText(playerid, string,0,COLOUR_MISC);
		}
	}
	//Debug("player.inc > SendPlayerOwnedWeapons(playerid) - Start");
}

GetRndPlayerSpawnByLevel(level)
{
	//Debug("player.inc > GetRndPlayerSpawnByLevel(level) - Start");
	new spawnlevel=0;
	for (new lookupid=0;lookupid<PLAYERSPAWNS_SIZE;lookupid++)
	{ // first we will get our highest available spawn point level (not all have spawnpoints, so we get the level below instead)
		if ((LeveledPlayerSpawns[lookupid][playerspawn_level] <= level) && (LeveledPlayerSpawns[lookupid][playerspawn_level] > spawnlevel))
		{
			spawnlevel = LeveledPlayerSpawns[lookupid][playerspawn_level];
		}
	}
	new leveledspawns[PLAYERSPAWNS_SIZE+1];
	new idx=0;
	for (new lookupid=0;lookupid<PLAYERSPAWNS_SIZE;lookupid++)
	{ // next we will create a list of all our found spawnpoints of that level
		if (LeveledPlayerSpawns[lookupid][playerspawn_level] == spawnlevel)
		{
			leveledspawns[idx] = lookupid;
			idx++;
		}
	}

	new spawnid;
	// now we will randomly select one of the spawns from our list
	if (idx != 0)
	{
		new rnd = random(idx);
		spawnid = leveledspawns[rnd];
	}
	else
	{
		spawnid = leveledspawns[0];
	}
	//Debug("player.inc > GetRndPlayerSpawnByLevel(level) - Stop");
	return spawnid; // return the id of the spawn we found
}

public player_Spawn(playerid)
{

	//printf("SPAWN CHECK: client %d | player %d",GetPlayerMoney(playerid),Player[playerid][Money]);

	/*if (!IsPlayerRegistered(playerid))
	{
		SendClientMessage(playerid, COLOUR_CRIMSON, "Вы не зарегистрированы! Сервер кикнул вас для общей безопасности!");
		Kick(playerid);
		return 1;
	}*/

	new GH = ganghouse(playerid,1);

	SpawnTime[playerid] = 0;

	if (GH == -1)  {

		SetPlayerInterior(playerid,0);
		
		SpawnInHotel(playerid);
		
		if ((PlayerSpawn[playerid][Coord_X] !=0.0) && (PlayerSpawn[playerid][Coord_Y] !=0.0) && (PlayerSpawn[playerid][Coord_Z] !=0.0))
		{
		
		}
		else
		{
			if (Player[playerid][Level] > 12)
			{ // todo: temporary, use lvdm spawns untill i have added spawn points  for > lvl 12
				new rand = random(sizeof(LVDMPlayerSpawns));
				SetPlayerPosEx(playerid, LVDMPlayerSpawns[rand][Coord_X], LVDMPlayerSpawns[rand][Coord_Y], LVDMPlayerSpawns[rand][Coord_Z]); // Warp the player
			}
			else
			{
				new spawnid=GetRndPlayerSpawnByLevel(Player[playerid][Level]);
				SetPlayerPosEx(playerid, LeveledPlayerSpawns[spawnid][playerspawn_x], LeveledPlayerSpawns[spawnid][playerspawn_y], LeveledPlayerSpawns[spawnid][playerspawn_z]); // Warp the player
			}
		}

	}
	else
	{
	SetPlayerInterior(playerid,0);
	gang2house(playerid,GH);
	}

	GivePlayerOwnedWeapons(playerid);
	oSetPlayerHealth(playerid,GetMaxHealth(playerid)); // set health based on level
	oSetPlayerMoney(playerid,Player[playerid][Money]);
	SetPlayerXP(playerid,Player[playerid][XP]);
	PlayerJustTeleported[playerid]+=5;
	plafk[playerid] = 0;
	
	if(NewPlayer[playerid] == 1)
	{
		SetPlayerSkin(playerid,Player[playerid][SkinModel]);
	} else {
	    Player[playerid][SkinModel] = GetPlayerSkin(playerid);
	}
	
	SetAttachmentsObjectsForPlayer(playerid);
	
	//Debug("player.inc > player_Spawn(playerid) - Stop");
	return 1;
}

public player_ResetStats(playerid)
{
	//Debug("player.inc > player_ResetStats(playerid) - Start");
	// reset player stats
	PlayerSQLID[playerid] = 0;
	set(PlayerPassword[playerid],nullstr);
	
	MoneyKick[playerid] = 0;
	PlayerRegistered[playerid] = false;

	Player[playerid][Level] = 0;
	Player[playerid][XP] = 0;
	oSetPlayerMoney(playerid,0);
	Player[playerid][Bank] = 0;
	Player[playerid][Kills] = 0;
	Player[playerid][Deaths] = 0;
	KickList[playerid] = 0;
	ResetQuest(playerid);
	SpawnTime[playerid] = 0;
	
	PlayerGangID[playerid] = -1;
	PlayerGangSQLID[playerid] = 0;
	GangInvite[playerid] = -1;
	
	set(PlayerGangName[playerid],nullstr);
	set(PlayerGangTag[playerid],"No GangTag");
	//PlayerSkin[playerid] = 0;
	Player[playerid][SkinModel] = 0;
	Player[playerid][Vip] = 0;
	Player[playerid][Car] = 0;
	Player[playerid][Packages] = 0;
	Player[playerid][RXP] = 0;
	
	Player[playerid][train1] = 0;
	Player[playerid][train2] = 0;
	Player[playerid][train3] = 0;
	Player[playerid][train4] = 0;
	
	Player[playerid][JailKick] = 0;
	
	Player[playerid][Attach] = 0;
	PlayerDebug[playerid] = 0;
	
	Player[playerid][EventBan] = 0;
	Player[playerid][TypeSpawn] = 0;
	
	warnAB[playerid] = 0; // АНТИЧИТ НА SpeedHack
	warnTP[playerid] = 0; // АНТИЧИТ НА TP
	AWS[playerid] = 0; // АНТИЧИТ НА Оружие
	AC_pPlayer[playerid][AC_pTeleport] = 3; // АНТИЧИТ НА ТП
	HealthKick[playerid] = 0;
	MoneyKick[playerid] = 0;
	ArmourKick[playerid] = 0;
	
	SetPlayerTeam(playerid, 255);
	
	ADMDropAmmo(playerid);
	for (new i=1;i<MAX_WEAPONS;i++)
	{
		PlayerWeapons[playerid][i] = 0;
	}
	for (new i=0;i<WEAPONS_SKILLS;i++)
	{
		PlayerWeaponsSkill[playerid][i] = 0;
		SetPlayerSkillLevel(playerid,i,0);
	}
	for(new i=0; i<MAX_PLAYER_ATTACHED_OBJECTS; i++)
 	{
  		if(IsPlayerAttachedObjectSlotUsed(playerid, i)) RemovePlayerAttachedObject(playerid, i);
    }
	PlayerWeapons[playerid][0] = 1; // fists
	PlayerJustTeleported[playerid] = 5;
	Player[playerid][Jailed] = 0;
	Player[playerid][Muted] = 0;

	//if (IsPlayerAdmin(playerid))
		//{
		//Player[playerid][Status] = 255;
		//} else  {
	Player[playerid][Status] = 0;
			//}
	
	ChatPopitki[playerid] = 0;
	Suecid[playerid] = 0;
	
	CmdTimer[playerid][Time_Heal] = 0;
	CmdTimer[playerid][Time_Repair] = 0;
	CmdTimer[playerid][Time_Nitro] = 0;
	CmdTimer[playerid][Time_Skydive] = 0;
	CmdTimer[playerid][Time_GPS] = -1;
	CmdTimer[playerid][Time_SaveGame] = 0;
	CmdTimer[playerid][Time_SCommand] = 0;
	CmdTimer[playerid][Time_CarTP] = 0;
	CmdTimer[playerid][Time_PTBB] = 0;
	pm_clear_blacklist(playerid);
	
	UnloadPlayerCar(playerid);

	//Debug("player.inc > player_ResetStats(playerid) - Stop");
}

public IsPlayerRegistered(playerid)
{
	//Debug("player.inc > IsPlayerRegistered(playerid) - Start");
	if (playerid == INVALID_PLAYER_ID) return 0;
	if (playerid == INVALIDX_PLAYER_ID) return 0;
	if (Player[playerid][IsActive] == 0) return 0;
	if (!IsPlayerConnected(playerid)) return 0;
	if (PlayerRegistered[playerid] == 0) return 0;
	//Debug("player.inc > IsPlayerRegistered(playerid) - Stop");
	return 1;
}

public player_Disconnect(playerid)
{
//Debug("player.inc > player_Disconnect(playerid) - Start");
//	for (new idst = 0; idst < MAX_PLAYERS; idst++)
//	{
//	if (IsPlayerConnected(idst))
//		{
//		if (IsPlayerAdmin(idst))
//			{
//if(IsPlayerRegistered(playerid))
//{
//new string[MAX_STRING];
//format(string,sizeof(string), lang_texts[1][18] ,oGetPlayerName(playerid),playerid);
//SendClientMessageToRegistered(COLOUR_GREY, string);
//}
//			SendPlayerFormattedText(idst,string, 0,COLOUR_GREY);
//			new Float:playerx,Float:playery,Float:playerz;
//			GetPlayerPos(idst,playerx,playery,playerz);
//			PlayerPlaySound(idst,1084,0,0,0);
//			}
//		}
//	}
	
DataXP[playerid]=0;
DataMoney[playerid]=0;
GangMemberLogout(playerid,PlayerGangID[playerid]);
Player[playerid][IsActive] = 0;
player_ResetStats(playerid);
//Debug("player.inc > player_Disconnect(playerid) - Stop");
}

public player_Connect(playerid)
{
	//Debug("player.inc > player_Connect(playerid) - Start");
	Player[playerid][IsActive] = 1;
	playercar_OnPlayerConnect(playerid);
	player_ResetStats(playerid);
    plafk[playerid] = -2;
    
	new playername[MAX_STRING];
	set(playername,oGetPlayerName(playerid));
	if (!NameCharCheck(playername))
	{
		SendPlayerFormattedText(playerid,  lang_texts[9][13] , 0,COLOUR_RED);
		KickPlayer(playerid,"Недействительные символы в нике."); // kick player
	}
	if(strcomp(playername,"Unknown",true) == 1)
	{
		SendClientMessage(playerid, COLOUR_WHITE,lang_texts[1][60]);
		Kick(playerid);
	}
	SetPlayerColour(playerid,COLOUR_PLAYER);
	set(PlayerGangTag[playerid],"No GangTag");
	//Debug("player.inc > player_Connect(playerid) - Start");
}

public PlayerDeath(playerid,killerid,reason)
{

	//printf("DEATH 1 CHECK: client %d | player %d",GetPlayerMoney(playerid),Player[playerid][Money]);
	//Debug("player.inc > PlayerDeath(playerid,killerid,reason) - Start");
	Player[playerid][Deaths]++;
	PlayerCurrentKills[playerid] = 0;
	plafk[playerid] = -2;
	if (oGetPlayerHealth(killerid) > 100)
	{
		KickPlayer(killerid,"Недействительное количество здоровья. (Чит?)");
	}
	if ((Player[playerid][Money] - 100) > 0)
	{
		oSetPlayerMoney(playerid,Player[playerid][Money] - 100);
		//Player[playerid][Money] -= 100;
	}
	else
	{
		oSetPlayerMoney(playerid,0);
	}
	/*
	if ((Player[playerid][XP] - (Player[playerid][XP] / 30)) > 0)
	{
		//if (!IsPlayerAdmin(playerid))
		//{
		if(killerid == INVALID_PLAYER_ID || killerid == INVALIDX_PLAYER_ID)
		{
		GivePlayerXP(playerid, (0 - (Player[playerid][XP] / 30)),1); // take death penalty xp
		Player[playerid][XP]=GetPlayerXP(playerid);
		CheckPlayerLevel(playerid);
		}
		else
		{
		if(GetPlayerInterior(killerid) == 0)
		{
		GivePlayerXP(playerid, (0 - (Player[playerid][XP] / 30)),1); // take death penalty xp
		Player[playerid][XP]=GetPlayerXP(playerid);
		CheckPlayerLevel(playerid);
		}
		else
		{
		CheckPlayerLevel(playerid);
		}
		}
		
		//}
	}
	else
	{
		SetPlayerXP(playerid,0);
	}
	*/
	//printf("DEATH 2 CHECK: client %d | player %d",GetPlayerMoney(playerid),Player[playerid][Money]);
	//Debug("player.inc > PlayerDeath(playerid,killerid,reason) - Stop");
}

public PlayerKill(killerid, victimid, reason) // earn xp, kills++
{
	//Debug("player.inc > PlayerKill(killerid, victimid, reason) - Start");
	// check gang kill
	if (PlayerGangID[killerid] != -1)
	{
		if (GangKill(PlayerGangID[killerid],killerid,victimid,reason) == 1)
		{
			//Debug("player.inc > PlayerKill(killerid, victimid, reason) - Stop(771)");
			return;
		}
	}

	// check weapon
	if (IsWeapon(reason))
	{
		/*if (PlayerTempWeapons[killerid][reason] > 0)
		{
			if (PlayerWeapons[killerid][reason] > 0)
			{// if player has bullets for this weapon
				if (!IsWeaponHandToHand(reason))
				{
					new lostbullets;
					lostbullets = Vary(2,1);
					PlayerWeapons[killerid][reason] = PlayerWeapons[killerid][reason] - lostbullets;
					if (PlayerWeapons[killerid][reason] < 0) PlayerWeapons[killerid][reason] = 0;
				}
			}
			else if (reason != 0)// killer used weapon they should not have
			{
				if (!IsStoreWeapon(reason)) // check not store bought weapon
				{
					new string[MAX_STRING];
					format(string,sizeof(string), lang_texts[9][14] ,reason);
					KickPlayer(killerid,string); //kick player, they used illegal weapon
					//Debug("player.inc > PlayerKill(killerid, victimid, reason) - Stop(798)");
					return;
				}
			}
		}*/
		if(!IsPlayerAdmin(killerid))
		{
			if(!AWS[killerid])
			{
				if(!IsStoreWeapon(reason))
				{
					if(!IsPlayerAllowedWeapon(killerid,reason))
					{
						switch(GetPlayerVehicleID(killerid))
						{
							case V_HUNTER: return;
							case V_HYDRA: return;
						}
						new string[MAX_STRING];
						format(string,sizeof(string), lang_texts[9][14] ,reason);
						KickPlayer(killerid,string); //kick player, they used illegal weapon
						//Debug("player.inc > PlayerKill(killerid, victimid, reason) - Stop(798)");
						return;
					}
				}
			}
		}
	}

	Player[killerid][Kills]++;
	PlayerCurrentKills[killerid]++;
	
	if (GetPlayerInterior(killerid) == 0)
	{
	// earn xp
	new earnedXP;
	earnedXP = ((1+Player[victimid][Level]) * 75);
	if (earnedXP > (1+Player[killerid][Level]) * 100)
	{
		earnedXP = ((1+Player[killerid][Level]) * 100);
	}
	if ((Player[killerid][XP] + earnedXP) <= MAX_LVLXP)
	{
		new CurrentXP = Player[victimid][XP] - LevelList[GetPlayerLevel(victimid)][level_xp];
		//printf("Пользователь набрал CurrentXP = %d опыта, earnedXP = %d", CurrentXP, earnedXP);
		if(CurrentXP < earnedXP)
		{
			new string[MAX_STRING];
			format(string,sizeof(string),"Вы не получите опыт, т.к. пользователь %s не набрал на данном уровне ХР",oGetPlayerName(victimid));
			SendClientMessage(killerid,COLOUR_WHITE,string);
		} else {
	    	GivePlayerXP(victimid, 0-earnedXP, 1);
	    	GivePlayerXP(killerid, earnedXP,1);
		}
	}
	else
	{
		SetPlayerXP(killerid, MAX_LVLXP);
	}

	// steal cash
	new stolencash;
	if (oGetPlayerMoney(victimid) > 1000)
	{
		stolencash = (oGetPlayerMoney(victimid) - (oGetPlayerMoney(victimid) / 7));
	}
	else
	{
		stolencash = oGetPlayerMoney(victimid);
	}

//ЕСЛИ, У убийцы предел наличных, stolencash будет соответствовать!

	if ( (MAX_MONEY-Player[killerid][Money]) < stolencash)
	{
	stolencash=(MAX_MONEY-Player[killerid][Money]);
	}

	oGivePlayerMoney(victimid,0-stolencash,1);
	oGivePlayerMoney(killerid,stolencash,1);
	//Debug("player.inc > PlayerKill(killerid, victimid, reason) - Stop");
	}
	return;
}

public RegisterQuest(name[], type)
{
	//Debug("player.inc > RegisterQuest(name[]) - Start");
	if (QuestCount >= MAX_QUESTS) return INVALID_QUEST_ID;
	QuestCount++;
	new questid =QuestCount;
	set(Quests[questid][Quest_Name],name);
	Quests[questid][Quest_Type] = type;
	//Debug("player.inc > RegisterQuest(name[]) - Stop");
	return questid;
}

public ResetQuest(playerid)
{
	//Debug("player.inc > ResetQuest(playerid) - Start");
	oDisablePlayerCheckpoint(playerid);
	//oDisablePlayerRaceCheckpoint(playerid);
	PlayerQuest[playerid] = 0;
	//Debug("player.inc > ResetQuest(playerid) - Stop");
}

public oSetPlayerCheckpoint(playerid, Float:x, Float:y, Float:z, Float:size)
{
	//Debug("player.inc > oSetPlayerCheckpoint(playerid, Float:x, Float:y, Float:z, Float:size) - Start");
	DisablePlayerCheckpoint(playerid);
	SetPlayerCheckpoint(playerid, 0.0, 0.0, 0.0, size);//size); // TODO: size bugged
	DisablePlayerCheckpoint(playerid);
	PlayerCP[playerid][Coord_X] = x;
	PlayerCP[playerid][Coord_Y] = y;
	PlayerCP[playerid][Coord_Z] = z;
	PlayerCPActive[playerid] = true;
	SetPlayerCheckpoint(playerid, x, y, z, size);//size); // TODO: size bugged
	//SetPlayerRaceCheckpoint(playerid,3,x,y,z,x,y,z,8);
	//Debug("player.inc > oSetPlayerCheckpoint(playerid, Float:x, Float:y, Float:z, Float:size) - Stop");
}

//=========================================================================================================================================
//=========================================================================================================================================

public oSetPlayerRaceCheckpoint(playerid, type, Float:x, Float:y, Float:z, Float:xn, Float:yn, Float:zn, Float:size)
{
DisablePlayerRaceCheckpoint(playerid);
SetPlayerRaceCheckpoint(playerid, type, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, size);
DisablePlayerRaceCheckpoint(playerid);
PlayerRCP[playerid][Coord_X] = x;
PlayerRCP[playerid][Coord_Y] = y;
PlayerRCP[playerid][Coord_Z] = z;
PlayerRCPActive[playerid] = true;
SetPlayerRaceCheckpoint(playerid,type, x, y, z, xn, yn, zn, size);
}

public oDisablePlayerRaceCheckpoint(playerid)
{
	// Debug("player.inc > oDisablePlayerCheckpoint(playerid) - Start");
	DisablePlayerRaceCheckpoint(playerid);
	PlayerRCPActive[playerid] = false;
	PlayerRCP[playerid][Coord_X] = 0.0;
	PlayerRCP[playerid][Coord_Y] = 0.0;
	PlayerRCP[playerid][Coord_Z] = 0.0;
	// Debug("player.inc > oDisablePlayerCheckpoint(playerid) - Stop");
} 

public oIsPlayerInRaceCheckpoint(playerid,Float:cpx,Float:cpy,Float:cpz,dist)
{
	//Debug("player.inc > oIsPlayerInCheckpoint(playerid,Float:cpx,Float:cpy,Float:cpz,dist) - Start");
	if (!IsPlayerConnected(playerid)) {return 0;}
	if (!PlayerRCPActive[playerid]) {return 0;}
	if (!loccmp(cpx,cpy,cpz,PlayerRCP[playerid][Coord_X],PlayerRCP[playerid][Coord_Y],PlayerRCP[playerid][Coord_Z])) return 0;
	//new Float:playerx,Float:playery,Float:playerz;
	//GetPlayerPos(playerid,playerx,playery,playerz);

	return IsPlayerInRangeOfPoint(playerid, dist, cpx, cpy, cpz);

	/*
	if (GetDistanceXYZtoXYZ(playerx,playery,playerz,cpx,cpy,cpz) < dist)
	{
		return 1;
	}
	*/

	//Debug("player.inc > oIsPlayerInCheckpoint(playerid,Float:cpx,Float:cpy,Float:cpz,dist) - Stop");
	//return 0;
}

//=========================================================================================================================================
//=========================================================================================================================================

public oDisablePlayerCheckpoint(playerid)
{
	//Debug("player.inc > oDisablePlayerCheckpoint(playerid) - Start");
	DisablePlayerCheckpoint(playerid);
	PlayerCPActive[playerid] = false;
	PlayerCP[playerid][Coord_X] = 0.0;
	PlayerCP[playerid][Coord_Y] = 0.0;
	PlayerCP[playerid][Coord_Z] = 0.0;
	//Debug("player.inc > oDisablePlayerCheckpoint(playerid) - Stop");
} 

public oIsPlayerInCheckpoint(playerid,Float:cpx,Float:cpy,Float:cpz,dist)
{
	//Debug("player.inc > oIsPlayerInCheckpoint(playerid,Float:cpx,Float:cpy,Float:cpz,dist) - Start");
	if (!IsPlayerConnected(playerid)) {return 0;}
	if (!PlayerCPActive[playerid]) {return 0;}
	if (!loccmp(cpx,cpy,cpz,PlayerCP[playerid][Coord_X],PlayerCP[playerid][Coord_Y],PlayerCP[playerid][Coord_Z])) return 0;
	//new Float:playerx,Float:playery,Float:playerz;
	//GetPlayerPos(playerid,playerx,playery,playerz);

	return IsPlayerInRangeOfPoint(playerid, dist, cpx, cpy, cpz);
	/*
	if (GetDistanceXYZtoXYZ(playerx,playery,playerz,cpx,cpy,cpz) < dist)
	{
		return IsPlayerInCheckpoint(playerid);
	}
	*/
	//Debug("player.inc > oIsPlayerInCheckpoint(playerid,Float:cpx,Float:cpy,Float:cpz,dist) - Stop");
	//return 0;
}


public GetXPToLevel(playerid,level)
{
	//Debug("player.inc > GetXPToLevel(playerid,level) - Start");
	if (!IsPlayerConnected(playerid)) {return 0;}
	new xptolevel;
	xptolevel=0;
	if ((level <= MAX_LEVEL) && (level > Player[playerid][Level]))
	{
		xptolevel =LevelList[level][level_xp] - Player[playerid][XP];
	}
	else
	{
		xptolevel = 0;
	}
	//Debug("player.inc > GetXPToLevel(playerid,level) - Stop");
	return xptolevel;
}

public CalculatePlayerLevel(playerid)
{
	//Debug("player.inc > CalculatePlayerLevel(playerid) - Start");
	if (!IsPlayerConnected(playerid)) {return 0;}
	new level;
	level = 0;

	for (new i = 0; i <= MAX_LEVEL; i++)
	{
		if (GetPlayerXP(playerid) >=LevelList[i][level_xp])
		{
			level = i;
		}
	}
	//Debug("player.inc > CalculatePlayerLevel(playerid) - Stop");
	return level;
}

public GetPlayerLevel(playerid)
{
	//Debug("player.inc > CalculatePlayerLevel(playerid) - Start");
	if (!IsPlayerConnected(playerid)) {return 0;}
	//Debug("player.inc > CalculatePlayerLevel(playerid) - Stop");
	return Player[playerid][Level];
}

public GetPlayerXP(playerid)
{
	//Debug("player.inc > GetPlayerXP(playerid) - Start");
	if (!IsPlayerConnected(playerid)) {return 0;}
	//Debug("player.inc > GetPlayerXP(playerid) - Start");
	return Player[playerid][XP];
}

public SetPlayerXP(playerid, xpamount)
{
	//Debug("player.inc > SetPlayerXP(playerid, xpamount) - Start");
	if (!IsPlayerConnected(playerid))
	{
		//Debug("player.inc > SetPlayerXP(playerid, xpamount) - Stop(970)");
		return;
	}
	Player[playerid][XP] = xpamount;
	//Debug("player.inc > SetPlayerXP(playerid, xpamount) - Stop");
}

public GivePlayerXP(playerid, xpamount,showtext) // showtext = do we display "You gain %d XP"  to client
{
	//Debug("player.inc > GivePlayerXP(playerid, xpamount,showtext) - Start");
	if (!IsPlayerConnected(playerid))
	{
		//Debug("player.inc > GivePlayerXP(playerid, xpamount,showtext) - Stop(982)");
		return;
	}
	if (xpamount == 0)
	{
		//Debug("player.inc > GivePlayerXP(playerid, xpamount,showtext) - Stop(987)");
		return;
	}
	
	if (PlayerGangID[playerid] != -1)
	{ // in a gang
		if (xpamount > 100)
		{
			new gangxp = xpamount / 4;
			GangGiveXP(PlayerGangID[playerid],gangxp,playerid);
		}
	}
	
	new texttime;
	if (xpamount <= 50)
	{
		texttime = 500;
	}
	else if (xpamount < 200)
	{
		texttime = 1000;
	}
	else if (xpamount < 500)
	{
		texttime = 1500;
	}
	else if (xpamount < 1000)
	{
		texttime = 2000;
	}
	else if (xpamount < 2000)
	{
		texttime = 4000;
	}
	else
	{
		texttime = 5000;
	}
	
	new string[MAX_STRING];
	if ((GetPlayerXP(playerid) + xpamount) < 0) // if after add xp, playerxp < 0
	{
		SetPlayerXP(playerid, 0);
		if (showtext == 1)
		{
			format(string, sizeof(string),  lang_texts[9][15] , xpamount);
			SendClientMessage(playerid, COLOUR_XP_BAD, string);
		}
		//Debug("player.inc > GivePlayerXP(playerid, xpamount,showtext) - Stop(1035)");
		return;
	}

	if ((GetPlayerXP(playerid) + xpamount) > MAX_LVLXP) // if after add, playerxp > MAX
	{
		if (showtext == 1)
		{
			format(string, sizeof(string),  lang_texts[9][16] , MAX_LVLXP - GetPlayerXP(playerid));
			SendClientMessage(playerid, COLOUR_XP_GOOD, string);
			SendClientMessage(playerid, COLOUR_RED, lang_texts[9][17] );
		}
		SetPlayerXP(playerid, MAX_LVLXP);
		CheckPlayerLevel(playerid);
		//Debug("player.inc > GivePlayerXP(playerid, xpamount,showtext) - Stop(1048)");
		return;
	}

	if (xpamount >= 0)
	{
		format(string, sizeof(string),  lang_texts[9][18] , xpamount);
		GameTextForPlayer(playerid,string,texttime,3);
	}
	else
	{
		//new levelxp = LevelList[GetPlayerLevel(playerid)][level_xp];
		//new xpfromlevel = GetPlayerXP(playerid) - levelxp;
		//if ((xpfromlevel + xpamount) < levelxp)
		//{ // we cant go down levels
		//	xpamount = 0-xpfromlevel;
		//}
		//if (xpamount > 0)
		//{
			format(string, sizeof(string),  lang_texts[9][19] , xpamount);
			GameTextForPlayer(playerid,string,texttime,3);
		//}
	}


	SetPlayerXP(playerid, (GetPlayerXP(playerid) + xpamount));
	if (showtext==1)
	{
		if (xpamount > 0)
		{
			format(string, sizeof(string),  lang_texts[9][20] , xpamount);
			SendClientMessage(playerid, COLOUR_XP_GOOD, string);
		}
		else if (xpamount < 0)
		{
			format(string, sizeof(string),  lang_texts[9][21] , xpamount);
			SendClientMessage(playerid, COLOUR_XP_BAD, string);
		}
	}
	Player[playerid][XP]=GetPlayerXP(playerid);
	CheckPlayerLevel(playerid);
	//Debug("player.inc > GivePlayerXP(playerid, xpamount,showtext) - Stop");
}


public CheckPlayerLevel(playerid)
{
	//Debug("player.inc > CheckPlayerLevel(playerid) - Start");
	if (!IsPlayerConnected(playerid))
	{
		//Debug("player.inc > CheckPlayerLevel(playerid) - Stop(1098)");
		return;
	}
	new level;
	level = CalculatePlayerLevel(playerid);
	if (Player[playerid][Level] < level)
	{
		PlayerLevelUp(playerid,level);
		UpdatePlayerInfoTD(playerid);
	}
	else if (Player[playerid][Level] > level)
	{
		PlayerLevelDown(playerid,level);
		UpdatePlayerInfoTD(playerid);
	}
	Player[playerid][XP]=GetPlayerXP(playerid);
	
	UpdatePlayerXPLine(playerid);
	//Debug("player.inc > CheckPlayerLevel(playerid) - Stop");
}

public PlayerLevelDown(playerid,level)
{
	//Debug("player.inc > PlayerLevelDown(playerid,level) - Start");
	if (!IsPlayerConnected(playerid))
	{
		//Debug("player.inc > PlayerLevelDown(playerid,level) - Stop(1119)");
		return;
	}
	new string[256];
	Player[playerid][Level] = level;
	format(string, sizeof(string),  lang_texts[9][22] , Player[playerid][Level]);
	SendClientMessage(playerid, COLOUR_XP_BAD, string);
	new logstring[256];
	format(logstring, sizeof (logstring), "player: %d:  %s: decreased his level to %d",playerid,oGetPlayerName(playerid),Player[playerid][Level]);
	WriteLog(logstring);
	new Float:playerx,Float:playery,Float:playerz;
	GetPlayerPos(playerid,playerx,playery,playerz);
	PlayerPlaySound(playerid,1057,playerx,playery,playerz);
	UpdatePlayerScore(playerid);
	//Debug("player.inc > PlayerLevelDown(playerid,level) - Stop");
}

public PlayerLevelUp(playerid,level)
{
	//Debug("player.inc > PlayerLevelUp(playerid,level) - Start");
	if (!IsPlayerConnected(playerid))
	{
		//Debug("player.inc > PlayerLevelUp(playerid,level) - Stop(1141)");
		return;
	}
	new string[256];
	Player[playerid][Level] = level;
	oSetPlayerHealth(playerid,GetMaxHealth(playerid));
	format(string, sizeof(string),  lang_texts[9][23] , Player[playerid][Level]);
	SendClientMessage(playerid, COLOUR_XP_GOOD, string);
	new logstring[256];
	format(logstring, sizeof (logstring), "player: %d:  %s: increased his level to %d",playerid,oGetPlayerName(playerid),Player[playerid][Level]);
	WriteLog(logstring);
	new Float:playerx,Float:playery,Float:playerz;
	GetPlayerPos(playerid,playerx,playery,playerz);
	PlayerPlaySound(playerid,1057,playerx,playery,playerz);
	UpdatePlayerScore(playerid);

	new wepfound;
	for (new weaponid=1;weaponid<MAX_WEAPONS;weaponid++)
	{
		new lookupid=GetWeaponLookupID(weaponid);
		if (lookupid == -1) continue;
		if (Weapons[lookupid][Weapon_Allowed] == 0) continue;
		if (Weapons[lookupid][Weapon_Level] == GetPlayerLevel(playerid))
		{
			if (wepfound == 0)
			{
				SendClientMessage(playerid, COLOUR_GREEN,  lang_texts[9][24] );
				wepfound=1;
			}
			format(string, sizeof(string),  lang_texts[9][25] ,oGetWeaponName(weaponid),GetWeaponCost(weaponid));
			SendClientMessage(playerid, COLOUR_MISC, string);
		}
	}
	
	if(level == MinHydraLevel)
	{
	SendClientMessage(playerid, COLOUR_MISC," Транспорт: Боевая машина 'Hydra' теперь доступна");
	}
	
	if(level == MinHunterLevel)
	{
	SendClientMessage(playerid, COLOUR_MISC," Транспорт: Боевая машина 'Hunter' теперь доступна");
	}
	
	if(level == MinRhinoLevel)
	{
	SendClientMessage(playerid, COLOUR_MISC," Транспорт: Боевая машина 'ТАНК' теперь доступна");
	}
	
	GetInfoDMLevel(playerid,level);
 	GetInfoRaceLevel(playerid,level);
	//Debug("player.inc > PlayerLevelUp(playerid,level) - Stop");
}

public oSetPlayerMoney(playerid,money)
{
	//Debug("player.inc > oSetPlayerMoney(playerid,money) - Start");
	if (!IsPlayerConnected(playerid))
	{
		//Debug("player.inc > oSetPlayerMoney(playerid,money) - Stop(1182)");
		return;
	}
	//new h,m,s;
	//gettime(h,m,s);
	MoneyUpdateDelay[playerid] = 2;
	Player[playerid][Money] = money;
	SetPlayerMoney(playerid,money);	
	MoneyUpdateDelay[playerid] = 2;
	//Debug("player.inc > oSetPlayerMoney(playerid,money) - Stop");
	return;
}

public SetPlayerMoney(playerid,money) //By Jan "DracoBlue" Schutze (Edited by Sacky)
{
GivePlayerMoney(playerid,money-GetPlayerMoney(playerid));
UpdatePlayerInfoTD(playerid);
}

public oGivePlayerMoney(playerid,money,showtext)
{
	//Debug("player.inc > oGivePlayerMoney(playerid,money,showtext) - Start");
	if (!IsPlayerConnected(playerid))
	{
		//Debug("player.inc > oGivePlayerMoney(playerid,money,showtext) - Stop(1197)");
		return;
	}
	if (money == 0)
	{
		//Debug("player.inc > oGivePlayerMoney(playerid,money,showtext) - Stop(1202)");
		return;
	}
	new string[MAX_STRING];

	if ((Player[playerid][Money] + money) > MAX_MONEY)
	{
		oSetPlayerMoney(playerid,MAX_MONEY);
		format(string, sizeof(string),  lang_texts[9][26] , money);
		SendClientMessage(playerid, COLOUR_MONEY_GOOD, string);
		new logstring[256];
		format(logstring, sizeof (logstring), "player: %d:  %s: is on max money",playerid,oGetPlayerName(playerid));
		WriteLog(logstring);
		//Debug("player.inc > oGivePlayerMoney(playerid,money,showtext) - Stop(1215)");
		return;
	}
	if ((Player[playerid][Money] + money) < 0)
	{
		oSetPlayerMoney(playerid,0);
		format(string, sizeof(string),  lang_texts[9][27] , money);
		SendClientMessage(playerid, COLOUR_MONEY_GOOD, string);
		//Debug("player.inc > oGivePlayerMoney(playerid,money,showtext) - Stop(1223)");
		return;
	}

	if (showtext == 1)
	{
		if (money >= 0)
		{
			format(string, sizeof(string),  lang_texts[9][28] , money);
			SendClientMessage(playerid, COLOUR_MONEY_GOOD, string);
		}
		else
		{
			format(string, sizeof(string),  lang_texts[9][29] , money);
			SendClientMessage(playerid, COLOUR_MONEY_BAD, string);
		}
	}

	oSetPlayerMoney(playerid,Player[playerid][Money] + money);
	//Debug("player.inc > oGivePlayerMoney(playerid,money,showtext) - Stop");
}

public GetPlayerTotalMoney(playerid)
{
	//Debug("player.inc > GetPlayerTotalMoney(playerid) - Start");
	new money=0;
	money = money + Player[playerid][Money];
	money = money + Player[playerid][Bank];
	//Debug("player.inc > GetPlayerTotalMoney(playerid) - Stop");
	return money;
}

public oGetPlayerMoney(playerid)
{
	//Debug("player.inc > oGetPlayerMoney(playerid) - Start");
	//Debug("player.inc > oGetPlayerMoney(playerid) - Stop");
	return Player[playerid][Money];
}

public UpdatePlayerScore(playerid)
{
	//Debug("player.inc > UpdatePlayerScore(playerid) - Start");
	SetPlayerScore(playerid,Player[playerid][Level]);
	//Debug("player.inc > UpdatePlayerScore(playerid) - Stop");
}

UpdateWeaponSkill(playerid,reason)
{
if(reason > 21 && reason < 32)
{
if((PlayerWeaponsSkill[playerid][reason-22] + KILL_SKILL) >= MAX_SKILL)
{
PlayerWeaponsSkill[playerid][reason-22] = MAX_SKILL;
SetPlayerSkillLevel(playerid, reason-22, MAX_SKILL);
}
else
{
PlayerWeaponsSkill[playerid][reason-22] = PlayerWeaponsSkill[playerid][reason-22] + KILL_SKILL;
SetPlayerSkillLevel(playerid, reason-22, PlayerWeaponsSkill[playerid][reason-22]);
}
}
if(reason == 34)
{
if((PlayerWeaponsSkill[playerid][10] + KILL_SKILL) >= MAX_SKILL)
{
PlayerWeaponsSkill[playerid][10] = MAX_SKILL;
SetPlayerSkillLevel(playerid, 10, MAX_SKILL);
}
else
{
PlayerWeaponsSkill[playerid][10] = PlayerWeaponsSkill[playerid][10] + KILL_SKILL;
SetPlayerSkillLevel(playerid, 10, PlayerWeaponsSkill[playerid][10]);
}
}
}

stock escGetPlayerName(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof (name));
	strdel(name, 0, strfind(name, "]", true) + 1);
	SetPlayerName(playerid,name);
	return name;
}

stock oGetPlayerName(playerid)
{
	//Debug("player.inc > oGetPlayerName(playerid) - Start");
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof (name));
	//Debug("player.inc > oGetPlayerName(playerid) - Stop");
	return name;
}

/*
stock oGetPlayerName(playerid)
{
	//Debug("player.inc > oGetPlayerName(playerid) - Start");
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof (name));
	//PlayerGangID[playerid];
	if (PlayerGangID[playerid] != -1)
	{
		if(isnull(PlayerGangTag[playerid]) || !strcomp(PlayerGangTag[playerid],"No GangTag",false)) {
			if ((strfind(name,"[",true) != -1) && (strfind(name,"]",true) != -1))
			{
				new whatcut[MAX_NAME];
				format(whatcut,sizeof(whatcut),"[%s]",PlayerGangTag[playerid]);
				strcut(name,whatcut);
			}
	 	} else {
	 	    //escGetPlayerName(playerid);
		}
	}
	//Debug("player.inc > oGetPlayerName(playerid) - Stop");
	return name;
}*/

/*oGetPlayerName(playerid)
{
	new pname[MAX_PLAYER_NAME];
	GetPlayerName(playerid, pname, sizeof (pname));
	if (PlayerGangid[playerid] != 0){
		if (strcomp(PlayerGangTag[playerid],"No GangTag",true)==0){
			if ((strfind(pname,"[",true) != -1) && (strfind(pname,"]",true) != -1)){
				new whatcut[MAX_NAME];
				format(whatcut,sizeof(whatcut),"[%s]",PlayerGangTag[playerid]);
				strcut(pname,whatcut);
			}
		}
	}
	return pname;
}*/

stock oGetPlayerIp(playerid)
{
	new IP[256];
	GetPlayerIp(playerid,IP,256);
	return IP;
}

public oSetPlayerHealth(playerid,Float:health)
{
	//Debug("player.inc > oSetPlayerHealth(playerid,Float:health) - Start");
	Player[playerid][Health] = health;
	SetPlayerHealth(playerid, health);
	HealthUpdateDelay[playerid] = 1;
	//Debug("player.inc > oSetPlayerHealth(playerid,Float:health) - Stop");
}

public oSetPlayerArmour(playerid,Float:armour)
{
	//Debug("player.inc > oSetPlayerHealth(playerid,Float:health) - Start");
	Player[playerid][Armour] = armour;
	SetPlayerArmour(playerid, armour);
	ArmourUpdateDelay[playerid] = 1;
	//Debug("player.inc > oSetPlayerHealth(playerid,Float:health) - Stop");
}

public oGivePlayerWeapon(playerid,weaponid,ammo)
{
	//Debug("player.inc > oGivePlayerWeapon(playerid,weaponid,ammo) - Start");
	if (ammo > 0)
	{
		if (!IsWeaponHandToHand(weaponid))
		{
			PlayerWeapons[playerid][weaponid] = PlayerWeapons[playerid][weaponid] + ammo;
		}
		else
		{
			PlayerWeapons[playerid][weaponid] = 1;
		}
		GivePlayerWeapon(playerid,weaponid,ammo);
	}
	//Debug("player.inc > oGivePlayerWeapon(playerid,weaponid,ammo) - Stop");
}

public PlayerSave(playerid)
{
	//Debug("player.inc > PlayerSave(playerid) - Start");
	if (!IsPlayerRegistered(playerid)) return 0;

	if(DBTYPE == 0) { player_save_db_dini(playerid); }
	else if(DBTYPE == 1) {player_save_db_sql(playerid);}
	

	new logstring[256];
	format(logstring, sizeof (logstring), "player: %d:  %s: player_saved successfully",playerid,oGetPlayerName(playerid));
	WriteLog(logstring);
	//Debug("player.inc > PlayerSave(playerid) - Stop");
	return 1;
}

public CreatePlayer(playerid)
{
	//Debug("player.inc > CreatePlayer(playerid) - Start");
	oSetPlayerMoney(playerid,PlayerStartMoney);
	SetPlayerXP(playerid,0);
	ResetPlayerWeapons(playerid);
	
	new bullets = 100;
	if (PlayerStartWeapon1 != 0)
	{
		if (bullets > GetWeaponMaxAmmo(PlayerStartWeapon1))
		{
			oGivePlayerWeapon(playerid,PlayerStartWeapon1,GetWeaponMaxAmmo(PlayerStartWeapon1));
		}
		else
		{
			oGivePlayerWeapon(playerid,PlayerStartWeapon1,bullets);
		}
	}
	if (PlayerStartWeapon2 != 0)
	{
		if (bullets > GetWeaponMaxAmmo(PlayerStartWeapon2))
		{
			oGivePlayerWeapon(playerid,PlayerStartWeapon2,GetWeaponMaxAmmo(PlayerStartWeapon2));
		}
		else
		{
			oGivePlayerWeapon(playerid,PlayerStartWeapon2,bullets);
		}
	}
	if (PlayerStartWeapon3 != 0)
	{
		if (bullets > GetWeaponMaxAmmo(PlayerStartWeapon3))
		{
			oGivePlayerWeapon(playerid,PlayerStartWeapon3,GetWeaponMaxAmmo(PlayerStartWeapon3));
		}
		else
		{
			oGivePlayerWeapon(playerid,PlayerStartWeapon3,bullets);
		}
	}
	
	if(DBTYPE == 1)
	{
	player_create_db_sql(playerid);
	}
	else if(DBTYPE == 0)
	{
	player_create_db_dini(playerid);
	}

	new logstring[256];
	format(logstring, sizeof (logstring), "player: %d:  %s: player_created successfully",playerid,oGetPlayerName(playerid));
	WriteLog(logstring);
	//Debug("player.inc > CreatePlayer(playerid) - Stop");
	return;
}

SetPlayerColour(playerid,colour)
{
	//Debug("player.inc > SetPlayerColour(playerid,colour) - Start");
	SetPlayerColor(playerid,colour);
	//Debug("player.inc > SetPlayerColour(playerid,colour) - Stop");
}

player_create_db_dini(playerid)
{
	//Debug("player.inc > player_create_db_dini(playerid) - Start");
	// UDB
	new udbfilename[MAX_STRING];
	udbfilename = oGetPlayerName(playerid);
	strcat(udbfilename,".Status",sizeof(udbfilename));

	// Dini
	new dinifilename[MAX_STRING];
	format(dinifilename,sizeof(dinifilename),"%sGTO.Player.%s.txt",PlayerDB,EncodeName(oGetPlayerName(playerid)));


	if ((dini_Exists(dinifilename)) || (udb_Exists(udbfilename)))
	{
		SendClientMessage(playerid,COLOUR_RED,  lang_texts[9][30] );
		//Debug("player.inc > player_create_db_dini(playerid) - Stop(1401)");
		return;
	}
	player_save_db_dini(playerid);
	//Debug("player.inc > player_create_db_dini(playerid) - Stop");
}

SetWeaponsFromDBString(playerid,dbstring[])
{
	//Debug("player.inc > SetWeaponsFromDBString(playerid,dbstring[]) - Start");
	new idx;
	for (new i=0;i<MAX_WEAPONS;i++)
	{
		new bullets;
		bullets = strval(strcharsplit(dbstring,idx,strchar("/")));
		PlayerWeapons[playerid][i] = bullets;
	}
	//Debug("player.inc > SetWeaponsFromDBString(playerid,dbstring[]) - Stop");
}

SetWeaponsSkillFromDBString(playerid,dbstring[])
{
	//Debug("player.inc > SetWeaponsFromDBString(playerid,dbstring[]) - Start");
	new idx;
	for (new i=0;i<WEAPONS_SKILLS;i++)
	{
		new skill;
		skill = strval(strcharsplit(dbstring,idx,strchar("/")));
		PlayerWeaponsSkill[playerid][i] = skill;
	}
	//Debug("player.inc > SetWeaponsFromDBString(playerid,dbstring[]) - Stop");
}

CreateWeaponDBString(playerid)
{
	//Debug("player.inc > CreateWeaponDBString(playerid) - Start");
	new wepstr[MAX_STRING];
	for (new i=0;i<MAX_WEAPONS;i++)
	{
		new temp[MAX_STRING];
		valstr(temp,PlayerWeapons[playerid][i]); // level
		strins(wepstr, temp, strlen(wepstr));
		wepstr[strlen(wepstr)] =strchar("/");
	}
	//Debug("player.inc > CreateWeaponDBString(playerid) - Stop");
	return wepstr;
}

CreateWeaponSkillDBString(playerid)
{
	//Debug("player.inc > CreateWeaponDBString(playerid) - Start");
	new skillstr[MAX_STRING];
	for (new i=0;i<WEAPONS_SKILLS;i++)
	{
		new temp[MAX_STRING];
		valstr(temp,PlayerWeaponsSkill[playerid][i]); // level
		strins(skillstr, temp, strlen(skillstr));
		skillstr[strlen(skillstr)] =strchar("/");
	}
	//Debug("player.inc > CreateWeaponDBString(playerid) - Stop");
	return skillstr;
}


GetGUIPlayerSkillStr(playerid)
{
new skillstring[MAX_STRING];
set(skillstring,"ID\tValue\tSkill\n");
for(new i=0;i<WEAPONS_SKILLS;i++)
{
format(skillstring, sizeof(skillstring),"%s\n%d\t%d\t%s", skillstring,i, PlayerWeaponsSkill[playerid][i], SkillNames[i] );
}
return skillstring;
}

player_save_db_dini(playerid)
{
	//Debug("player.inc > player_save_db_dini(playerid) - Start");
	if (strlen(oGetPlayerName(playerid)) < 1)
	{
		//Debug("player.inc > player_save_db_dini(playerid) - Stop(1441)");
		return;
	}
	new dinifilename[MAX_STRING];
	format(dinifilename,sizeof(dinifilename),"%sGTO.Player.%s.txt",PlayerDB,EncodeName(oGetPlayerName(playerid)));
	if (!dini_Exists(dinifilename))
	{
		dini_Create(dinifilename);
	}
	new temp[MAX_STRING];

	dini_Set(dinifilename,"Name",oGetPlayerName(playerid));

	dini_Set(dinifilename,"Gang",PlayerGangName[playerid]);

	valstr(temp,Player[playerid][Level]); // level
	dini_Set(dinifilename,"Level",temp);

	valstr(temp,Player[playerid][XP]); // xp
	dini_Set(dinifilename,"XP",temp);

	valstr(temp,Player[playerid][Money]); // money
	dini_Set(dinifilename,"Money",temp);

	valstr(temp,Player[playerid][Bank]); // bankmoney
	dini_Set(dinifilename,"BankMoney",temp);

	valstr(temp,Player[playerid][Deaths]); // deaths
	dini_Set(dinifilename,"Deaths",temp);

	valstr(temp,Player[playerid][Kills]); // kills
	dini_Set(dinifilename,"Kills",temp);

	valstr(temp,Player[playerid][Jailed]); // jailed
	dini_Set(dinifilename,"Jailed",temp);

	valstr(temp,Player[playerid][Muted]); // muted
	dini_Set(dinifilename,"Muted",temp);

	//valstr(temp,Player[playerid][CarKills]); // carkills
	//dini_Set(dinifilename,"CarKills",temp);

	new Float:playerx, Float:playery, Float:playerz;
	GetPlayerPos(playerid,playerx,playery,playerz);
	if (playerz > 900)
	{ // we must be indoors
		playerx=0;
		playery=0;
		playerz=0;
	}
	format(temp,sizeof(temp),"%f",playerx);
	dini_Set(dinifilename,"X",temp);

	format(temp,sizeof(temp),"%f",playery);
	dini_Set(dinifilename,"Y",temp);

	format(temp,sizeof(temp),"%f",playerz);
	dini_Set(dinifilename,"Z",temp);


	valstr(temp,Player[playerid][Status]); // Status
	dini_Set(dinifilename,"Status",temp);

	dini_Set(dinifilename,"Weapons",CreateWeaponDBString(playerid));
	
	dini_Set(dinifilename,"Skills",CreateWeaponSkillDBString(playerid));

	valstr(temp,Player[playerid][SkinModel]); // Status
	dini_Set(dinifilename,"SkinModel",temp);

//	valstr(temp,Player[playerid][Hide]); // Status
//	dini_Set(dinifilename,"Hide",temp);

	//Debug("player.inc > player_save_db_dini(playerid) - Stop");
}

public PlayerLoadStats(playerid)
{
	//Debug("player.inc > PlayerLoadStats(playerid) - Start");
	if (!IsPlayerRegistered(playerid)) return 0; // login to acct first
	
	if(DBTYPE == 0) { 
	//player_load_db_dini(playerid);
	}
	else if(DBTYPE == 1) {player_load_db_sql(playerid);}
	//Debug("player.inc > PlayerLoadStats(playerid) - Stop");
	return 1;
}
/*
player_load_db_dini(playerid)
{
	//Debug("player.inc > player_load_db_dini(playerid) - Start");
	// udb
	new udbfilename[MAX_STRING];
	udbfilename = oGetPlayerName(playerid);
	strcat(udbfilename,".Status",sizeof(udbfilename));

	// dini
	new dinifilename[MAX_STRING];
	format(dinifilename,sizeof(dinifilename),"%sGTO.Player.%s.txt",PlayerDB,EncodeName(oGetPlayerName(playerid)));

	new useudb = 0;
	if ((!udb_Exists(udbfilename)) && (!dini_Exists(dinifilename)))
	{
		//Debug("player.inc > player_load_db_dini(playerid) - Stop(1524)");
		return;
	}
	if ((udb_Exists(udbfilename)) && (!dini_Exists(dinifilename)))
	{
		useudb = 1;
	}
	if ((udb_Exists(udbfilename)) && (dini_Exists(dinifilename)))
	{
		udb_Remove(udbfilename);
	}

	if (useudb)
	{
		new statsdbstring[MAX_DBSTRING];
		statsdbstring = udb_Loadfile(udbfilename);

		new idx;
		strcharsplit(statsdbstring,idx,DBSeperator); // playername
		// set stats
		Player[playerid][Level] = strval(strcharsplit(statsdbstring,idx,DBSeperator));
		Player[playerid][XP] = strval(strcharsplit(statsdbstring,idx,DBSeperator));
		oSetPlayerMoney(playerid,strval(strcharsplit(statsdbstring,idx,DBSeperator)));
		Player[playerid][Deaths] = strval(strcharsplit(statsdbstring,idx,DBSeperator));
		Player[playerid][Kills] = strval(strcharsplit(statsdbstring,idx,DBSeperator));
		Player[playerid][Jailed] = strval(strcharsplit(statsdbstring,idx,DBSeperator));
		Player[playerid][Muted] = strval(strcharsplit(statsdbstring,idx,DBSeperator));
		Player[playerid][CarKills] = strval(strcharsplit(statsdbstring,idx,DBSeperator));
		Player[playerid][Bank] = strval(strcharsplit(statsdbstring,idx,DBSeperator));
		PlayerSpawn[playerid][Coord_X] = floatstr(strcharsplit(statsdbstring,idx,DBSeperator));
		PlayerSpawn[playerid][Coord_Y] = floatstr(strcharsplit(statsdbstring,idx,DBSeperator));
		PlayerSpawn[playerid][Coord_Z] = floatstr(strcharsplit(statsdbstring,idx,DBSeperator));
		Player[playerid][Status] = strval(strcharsplit(statsdbstring,idx,DBSeperator));
		new gangname[MAX_NAME];
		set(gangname,strcharsplit(statsdbstring,idx,DBSeperator));
		if (gangname[0] != 0)
		{
			set(PlayerGangName[playerid],gangname);
			PlayerGangid[playerid] = GangLoad(gangname);
			GangMemberLogin(playerid,PlayerGangid[playerid]);
			if (PlayerGangid[playerid] == 0)
			{
				new tmpname[MAX_NAME];
				set(PlayerGangName[playerid],tmpname);
				PlayerGangName[playerid][0] = 0;
				PlayerGangid[playerid] = 0;
			}
			// TODO:
		}
		else
		{
			PlayerGangid[playerid] = 0; // no gang
		}
		new wepstr[MAX_STRING];
		set(wepstr,strcharsplit(statsdbstring,idx,DBSeperator));
		SetWeaponsFromDBString(playerid,wepstr);
		
		new skillstr[MAX_STRING];
		set(skillstr,strcharsplit(statsdbstring,idx,DBSeperator));
		SetWeaponsSkillFromDBString(playerid,skillstr);

		Player[playerid][SkinModel] = strval(strcharsplit(statsdbstring,idx,DBSeperator));
//		Player[playerid][Hide] = strval(strcharsplit(statsdbstring,idx,DBSeperator));
		
		UpdatePlayerScore(playerid);
	}
	else
	{ // use dini
		Player[playerid][Level] = strval(dini_Get(dinifilename,"Level"));
		Player[playerid][XP] = strval(dini_Get(dinifilename,"XP"));
		oSetPlayerMoney(playerid,strval(dini_Get(dinifilename,"Money")));
		Player[playerid][Bank] = strval(dini_Get(dinifilename,"BankMoney"));
		Player[playerid][Deaths] = strval(dini_Get(dinifilename,"Deaths"));
		Player[playerid][Kills] = strval(dini_Get(dinifilename,"Kills"));
		Player[playerid][Jailed] = strval(dini_Get(dinifilename,"Jailed"));
		Player[playerid][Muted] = strval(dini_Get(dinifilename,"Muted"));
		//Player[playerid][Level] = strval(dini_Get(dinifilename,"Level"));
		PlayerSpawn[playerid][Coord_X] = floatstr(dini_Get(dinifilename,"X"));
		PlayerSpawn[playerid][Coord_Y] = floatstr(dini_Get(dinifilename,"Y"));
		PlayerSpawn[playerid][Coord_Z] = floatstr(dini_Get(dinifilename,"Z"));
		Player[playerid][Status] = strval(dini_Get(dinifilename,"Status"));

		new gangname[MAX_NAME];
		set(gangname,dini_Get(dinifilename,"Gang"));
		if (strlen(gangname) > 0)
		{
			set(PlayerGangName[playerid],gangname);
			PlayerGangid[playerid] = GangLoad(gangname);
			GangMemberLogin(playerid,PlayerGangid[playerid]);
			if (PlayerGangid[playerid] == 0)
			{
				new tmpname[MAX_NAME];
				set(PlayerGangName[playerid],tmpname);
				PlayerGangName[playerid][0] = 0;
				PlayerGangid[playerid] = 0;
			}
		}
		else
		{
			PlayerGangid[playerid] = 0; // no gang
		}

		new wepstr[MAX_STRING];
		set(wepstr,dini_Get(dinifilename,"Weapons"));
		SetWeaponsFromDBString(playerid,wepstr);
		
		new skillstr[MAX_STRING];
		set(skillstr,dini_Get(dinifilename,"Skills"));
		SetWeaponsSkillFromDBString(playerid,skillstr);

		Player[playerid][SkinModel] = strval(dini_Get(dinifilename,"SkinModel"));
		//Player[playerid][Hide] = strval(dini_Get(dinifilename,"Hide"));
		//SetSpawnInfo(playerid,255,Player[playerid][SkinModel],508.2252,-84.8755,998.9609,10.7533,0,0,0,0,-1,-1);
		UpdatePlayerScore(playerid);
	}
	//Debug("player.inc > player_load_db_dini(playerid) - Stop");
}
*/

public JailPlayer(playerid)
{
	if (Player[playerid][Jailed] > 0)
	{
		new Float:playerx,Float:playery,Float:playerz;
		GetPlayerPos(playerid,playerx,playery,playerz);
		//if (!IsPlayerInBox(playerid, JailCoord[0]-10.0, JailCoord[1]-10.0, JailCoord[2]-10.0, JailCoord[0]+10.0, JailCoord[1]+10.0, JailCoord[2]+10.0)) // если игрок таки не в тюрьме!
		if(playerz < 990.000 && GetPlayerState(playerid) != 0) // 990 взято из AddPlayerClass
		//if(playerz < 990.000) // 990 взято из AddPlayerClass
		{
			Player[playerid][JailKick]++;
			SetPlayerInterior(playerid,JailI);
			SetPlayerPos(playerid,JailX,JailY,JailZ);
			if(Player[playerid][JailKick] > JAIL_KICK_ONE)
			{
			SendClientMessage(playerid, COLOUR_CRIMSON, "Немедленно вернитесь в тюрьму, или будете кикнуты!");
			}
			if(Player[playerid][JailKick] > JAIL_KICK_TWO)
			{
			Kick(playerid);
			}
		}
		else
		{
			if(Player[playerid][JailKick] > 0)
			{Player[playerid][JailKick]--;}
		}
	}
}

public UnJailPlayer(playerid)
{
	if (Player[playerid][Jailed] == 0)
	{
		SetPlayerInterior(playerid,0);
		SetPlayerPosEx(playerid,2297.1064,2452.0115,10.8203);
	}
}


forward IsPlayerAdm(playerid);
forward IsPlayerMod(playerid);
forward ADMDropAmmo(asid);
forward CmdTimeCheck(playerid);

public ADMDropAmmo(asid)
{
if (IsPlayerConnected(asid)==0) {return 0;}
for (new i=1;i<MAX_WEAPONS;i++)
	{
	PlayerWeapons[asid][i] = 0;
	}
PlayerWeapons[asid][0] = 1; // fists
return 1;
}

/*
public PlayerChangeSkin(playerid)
{
SetPlayerPos(playerid,);
SetPlayerFacingAngle(playerid,);

}
*/

//Moderator/Admin Function-------------------------------------------------------
public IsPlayerMod(playerid)
{
if ( Player[playerid][Status]==0 ) {return 0;}
if ( Player[playerid][Status]>10 ) {return 0;}
return 1;
}

public IsPlayerAdm(playerid)
{
if ( Player[playerid][Status]<11 ) {return 0;}
return 1;
}

public CmdTimeCheck(playerid)
{

if(!PlayerRegistered[playerid]) {return 1;}
if(CmdTimer[playerid][Time_Heal] > 0){CmdTimer[playerid][Time_Heal]--;}
if(CmdTimer[playerid][Time_Repair] > 0){CmdTimer[playerid][Time_Repair]--;}
if(CmdTimer[playerid][Time_Nitro] > 0) {CmdTimer[playerid][Time_Nitro]--;}
if(CmdTimer[playerid][Time_Skydive] > 0){CmdTimer[playerid][Time_Skydive]--;}
if(CmdTimer[playerid][Time_GPS] > 0){CmdTimer[playerid][Time_GPS]--;}
if(CmdTimer[playerid][Time_SCommand] > 0){CmdTimer[playerid][Time_SCommand]--;}
if(CmdTimer[playerid][Time_CarTP] > 0){CmdTimer[playerid][Time_CarTP]--;}
if(CmdTimer[playerid][Time_PTBB] > 0){CmdTimer[playerid][Time_PTBB]--;}

if(CmdTimer[playerid][Time_GPS] == 0)
{
	DestroyPlayerObject(playerid,PlayerArrow[playerid]);
	CmdTimer[playerid][Time_GPS] = -1;
}

CmdTimer[playerid][Time_SaveGame]++;
if(CmdTimer[playerid][Time_SaveGame] >= SAVE_TIME)
{
	CmdTimer[playerid][Time_SaveGame] = 0;
	if (IsPlayerRegistered(playerid))
	{
		PlayerSave(playerid);
		AccountSave(playerid);
		SendClientMessage(playerid, COLOUR_MISC, lang_texts[1][61]);
	}
}


return 1;
}

public AmmoBankOffGuns(playerid)
{
if(IsPlayerAtAmmunation(playerid)){SetPlayerArmedWeapon(playerid,0); return 1;}
if(IsPlayerAtBank(playerid)){SetPlayerArmedWeapon(playerid,0); return 1;}
return 1;
}

public PlayerAntiFlood(playerid,text[])
{
set(PlayerChatString[playerid][2],PlayerChatString[playerid][1]);
set(PlayerChatString[playerid][1],PlayerChatString[playerid][0]);
set(PlayerChatString[playerid][0],text);
if(strcomp(PlayerChatString[playerid][2],PlayerChatString[playerid][1], true) && strcomp(PlayerChatString[playerid][1],PlayerChatString[playerid][0], true))
{
//new str[MAX_STRING];
//format(str,sizeof(str),"SERVER: Игрок %s был кикнут за флуд!",oGetPlayerName(playerid));
//SendClientMessageToAll(COLOUR_WHITE, str);
//SendClientMessage(playerid, COLOUR_CRIMSON, "SERVER: Вы были кикнуты за флуд!");
//Kick(playerid);
new string[MAX_STRING];
Player[playerid][Muted] = AddToNow(60);
format(string,sizeof(string), lang_texts[12][50], oGetPlayerName(playerid));
SendClientMessageToAll(COLOUR_WHITE, string);
return 0;
}
return 1;
}
//------------------------------------------------------------------------------
public pm_addto_blacklist(playerid,badid)
{
for(new i=0;i<PM_BAD_SLOTS_MAX;i++)
{
if(!strlen(PlayerPMBlack[playerid][i])) { set(PlayerPMBlack[playerid][i],oGetPlayerName(badid)); return 1;}
}
SendClientMessage(playerid, COLOUR_WHITE, "Список полон! Очистите список!");
return 1;
}

public pm_show_blacklist(playerid)
{
new tmp[MAX_STRING];
new pmc;
set(tmp,"PM black list:");
for(new i=0;i<PM_BAD_SLOTS_MAX;i++)
{
if(strlen(PlayerPMBlack[playerid][i])) { pmc++; format(tmp,sizeof(tmp),"%s %s,",tmp,PlayerPMBlack[playerid][i]);}
}
if(!pmc) {format(tmp,sizeof(tmp),"%s < ПУСТО >",tmp);}
SendClientMessage(playerid, COLOUR_WHITE, tmp);
return 1;
}

public pm_clear_blacklist(playerid)
{
for(new i=0;i<PM_BAD_SLOTS_MAX;i++)
{
set(PlayerPMBlack[playerid][i],nullstr);
}
if(IsPlayerConnected(playerid))
{
SendClientMessage(playerid,COLOUR_WHITE,"Список очищен!");
}
return 1;
}

//------------------------------------------------------------------------------

public GivePlayerRaceXP(playerid,xpamount)
{
	if(!xpamount){return 1;}
	if(xpamount > 0)
	{
		if(xpamount + Player[playerid][RXP] > MAX_RXP) {Player[playerid][RXP] = MAX_RXP;}
		else {Player[playerid][RXP] = Player[playerid][RXP] + xpamount;}
	}
	else
	{
		if(xpamount + Player[playerid][RXP] < 0) {Player[playerid][RXP] = 0;}
		else {Player[playerid][RXP] = Player[playerid][RXP] + xpamount;}
	}

	if(Player[playerid][Vip] == 0)
	{
		if(Player[playerid][RXP] >= RXPTOVIP)
		{
		new string[MAX_STRING];
		Player[playerid][Vip] = 1;
		SendClientMessage(playerid, 0xFFFFFFAA, "Поздравляем! Теперь вы имеете статус VIP!");
		format(string,sizeof(string), "Игрок %s(id%d) заработал %d RXP и получил VIP статус!!!",oGetPlayerName(playerid),		playerid,RXPTOVIP);
		SendClientMessageToAll(COLOUR_WHITE, string);
		}
	}
	return 1;
}

forward IsPlayerJailed(playerid,spawn);
public IsPlayerJailed(playerid,spawn) // return 1 if jailed > 0
{
	if (Player[playerid][Jailed] == 0) {return 0;}
	if (Player[playerid][Jailed] == 1) {return 1;}
	if (Player[playerid][Jailed] > 1) // time jail
	{
		new date_p = Player[playerid][Jailed];
		//new date_n = Now();
		new date_n = gettime();

		if(date_p <= date_n)
		{
			Player[playerid][Jailed] = 0; SetPlayerWantedLevel(playerid, 0);
			SendClientMessage(playerid, COLOUR_LIGHTGREEN, "Время вышло, теперь вы свободны!!!");
			if(spawn){UnJailPlayer(playerid);}
			return 0;
		} else {
			new lost, day, hour, minute, second;
			new str[128];
			lost = date_p - date_n;
			day = lost/DAY_SEC;
			lost -= day*DAY_SEC;
			hour = lost/HOU_SEC;
			lost -= hour*HOU_SEC;
			minute = lost/MIN_SEC;
			lost -= minute*MIN_SEC;
			second = lost;
			format(str,sizeof(str),"Вы будете сидеть еще %d дней, %d часов, %d минут, %d секунд",day,hour,minute,second);
			SendClientMessage(playerid, COLOUR_CRIMSON, str);
			return 1;
		}
	}
	//UnJailPlayer(playerid);
	Player[playerid][Jailed] = 0;
	return 0;
}

public oPutPlayerInVehicle(playerid, vehicleid, seatid)
{
set(PlayerSpeedoCarName[playerid],Speed_GetVehicleName(vehicleid));
PutPlayerInVehicleEx(playerid, vehicleid, seatid);
return 1;
}

public SilentMessage(playerid,message[])
{
//	new id;
	new count;
	new clubmess[256];
	format(clubmess, sizeof(clubmess),"ШЕПОТОМ: %s [id %d]: %s", oGetPlayerName(playerid), playerid, message);
	new Float:playerx,Float:playery,Float:playerz;
	GetPlayerPos(playerid,playerx,playery,playerz);

	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerInRangeOfPoint(i, 15.00, playerx,playery,playerz))
		{
			SendClientMessage(i, 0x83dbffFF, clubmess);
			count++;
		}
	}

	count--;

	if(!count)
	{
		SendClientMessage(playerid, 0x83dbffFF, "CLUB: Вас никто не услышал! Подойдите ближе!");//{AFAFAF}
	}
}

forward SendPlayerStatGUI(playerid);
public SendPlayerStatGUI(playerid)
{
	new lstr[1024],scolor[8],stat[32];

	if(IsPlayerAdmin(playerid))
	{
		format(stat,sizeof(stat),lang_texts[15][97],Player[playerid][Status]);
	}
	else if(Player[playerid][Status] >= 1 && Player[playerid][Status]<=10)
	{
		format(stat,sizeof(stat),lang_texts[12][87],Player[playerid][Status]);
	}
	else if(Player[playerid][Status]>10)
	{
		format(stat,sizeof(stat),lang_texts[12][86],Player[playerid][Status]);
	}
	else
	{
		format(stat,sizeof(stat),lang_texts[12][88]);
	}

	OKS_HEX2STR_M(GetPlayerColor(playerid), scolor, sizeof(scolor));

	format(lstr,sizeof(lstr),
	"{FFFFFF}ИГРОК:\t\t{%s}%s{FFFFFF}   id %d\nСТАТ.:\t\t%s\nSQLID:\t\t%d\n",
	scolor,oGetPlayerName(playerid),playerid,stat,PlayerSQLID[playerid]);

	if(PlayerGangID[playerid] != -1)
	{
		format(lstr,sizeof(lstr),
		"%sБАНДА:\t{%s}%s{FFFFFF}   id %d\n",
		lstr,scolor,PlayerGangName[playerid],PlayerGangID[playerid]);
	}

	if(Player[playerid][Level] == MAX_LEVEL)
	{
		format(lstr,sizeof(lstr),
		"%sУРОВЕНЬ:\t{23FF70}%d{FFFFFF}\n",
		lstr,Player[playerid][Level]);
	}
	else
	{
		format(lstr,sizeof(lstr),
		"%sУРОВЕНЬ:   {23FF70}%d{FFFFFF}   |   СЛЕД.УР.:   {2370FF}%d{FFFFFF} XP\n",
		lstr,Player[playerid][Level],GetXPToLevel(playerid, Player[playerid][Level] + 1));
	}

	format(lstr,sizeof(lstr),
	"%sОПЫТ:\t\t{2370FF}%d{FFFFFF} XP\nНАЛИЧНЫЕ:\t{FF4238}%d{FFFFFF}\nБАНК:\t\t\
	{FF4238}%d{FFFFFF}\nУБИЙСТВ:   {FF4238}%d{FFFFFF}   |   СМЕРТЕЙ:   {FF4238}%d{FFFFFF}\n\
	RACEXP:\t{2370FF}%d{FFFFFF}\nPACK:\t\t{2370FF}%d{FFFFFF}\nVIP:\t\t%d\nРЕГИСТРАЦИЯ:\t%s",
	lstr,Player[playerid][XP],oGetPlayerMoney(playerid),Player[playerid][Bank],
	Player[playerid][Kills],Player[playerid][Deaths],Player[playerid][RXP],
	Player[playerid][Packages],Player[playerid][Vip],PlayerCreationDate[playerid]);

	ShowPlayerDialog(playerid,S_GUI_02,0,"Общая статистика",lstr,"OК","");
}

forward AFKSystem();
public AFKSystem()
{
    for(new playerid;playerid < MAX_PLAYERS;playerid++)
    {
        if(IsPlayerConnected(playerid) && !IsPlayerNPC(playerid))
        {
            if(plafk[playerid] == 0) plafk[playerid] -= 1;
            else if(plafk[playerid] == -1)
            {
                plafk[playerid] = 1;
                new string[128];
                format(string, sizeof(string), "АФК: %s", ConvertSeconds(plafk[playerid]));
                SetPlayerChatBubble(playerid, string, COLOR_WHITE, 20.0, 1500);
            }
            else if(plafk[playerid] > 0)
            {
                new string[255];
                plafk[playerid] += 1;
                format(string, sizeof(string), "АФК: %s", ConvertSeconds(plafk[playerid]));
                SetPlayerChatBubble(playerid, string, COLOR_WHITE, 20.0, 1500);
      		    if(plafk[playerid] >= 2) {
                    antiafkderby(playerid);
				}
            }
            //
            //
        }
    }
}

public SendPlayerQuests(playerid) // Мои соревнования
{
	new infostr[128];
	if( !PlayerQuest[playerid] )
	{
		format(infostr, sizeof(infostr), "Вы не участвуете в соревнованиях");
		ShowPlayerDialog(playerid, CGUI+16, DIALOG_STYLE_LIST, "Мои соревнования", infostr, "OK", "");
		return 1;
	}
	switch( Quests[ PlayerQuest[playerid] ][Quest_Type] )
	{
		case 1: format(infostr, sizeof(infostr), "Гонка: '%s' {FF0000}/race leave",Quests[ PlayerQuest[playerid] ][Quest_Name]);
		case 2: format(infostr, sizeof(infostr), "Десматч: '%s' {FF0000}/dm leave",Quests[ PlayerQuest[playerid] ][Quest_Name]);
		case 3: format(infostr, sizeof(infostr), "Дальнобойщики: '%s' {FF0000}/trade leave",Quests[ PlayerQuest[playerid] ][Quest_Name]);
		case 4: format(infostr, sizeof(infostr), "Захват зоны: '%s' {FF0000}/kill",Quests[ PlayerQuest[playerid] ][Quest_Name]);
		default: format(infostr, sizeof(infostr), "Неизвестно: '%s'",Quests[ PlayerQuest[playerid] ][Quest_Name]);
	}
	ShowPlayerDialog(playerid, CGUI+16, DIALOG_STYLE_LIST, "Мои соревнования", infostr, "OK", "Покинуть");
	return 1;
}


