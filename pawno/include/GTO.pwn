/*
Project Name:	San Andreas: Multiplayer: Grand Theft Online
Addon Name: Reunion

Date ReCreated:	23.08.2010 (Recreated by OFFREAL)

Compatable
SA-MP Versions: 0.3b R2

Licence:
		This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 2.5 License.
		To view a copy of this license, visit http:creativecommons.org/licenses/by-nc-sa/2.5/
		or send a letter to Creative Commons, 543 Howard Street, 5th Floor, San Francisco, California, 94105, USA.

		Feel free to use, modify, copy, distribute, etc.
  		Give credit where due.
  		No using for commercial purposes.

*/

//---------------------
//Include all libraryes
//---------------------

// many values and functions are in included scripts
// some need to be ran from a timer, or at specific events

#include <a_samp>							// samp
#include <core>								// core samp
#include <float>							// float minipulation

#include "base"								// holds base script values
#include "utils\gtoutils"					// misc used utils
#include "utils\gtodudb"					// old db handler
#include "utils\dini"						// db handler
#include "utils\dutils"						// more used tools

#include "mapicons_streamer"                // map icons streamer

#include "lang"
#include "account"							// account handler
#include "player"							// holds player values
#include "weapons"							// weapons and ammunation shop
#include "vehicles" 						// vehicles

#include "packages"                         // pickaps packets
#include "tuncars"                          // tuned cars and hydra-hunter
#include "npcs"								// NPC

#include "world"							// functions for zone, location, world, etc
#include "commandhandler"					// command handler
#include "gang10"							// gang handler
#include "business"							// business handler
#include "housing"							// housing handler
#include "logging"							// logging handler

#include "race"								// race handler, manages and runs all rasces
#include "deathmatch"						// deathmatch handler
#include "bank"								// bank money to keep it on death
#include "payday" 							// pay players money based on level
#include "groundhold"						// hold ground to gain money, pirate ship, etc

#include "database_sql"
#include "pcars"

#include "admin\admin_commands"				// admin commands
#include "admin\admin_commands_race"		// admin commands for race creation/manipulation
#include "admin\admin_commands_dm"			// admin commands for deathmatch creation/manipulation
#include "admin\admin_commands_sys"         // admin sys commands for control system
#include "admin\adm_commands"               // admin commands
#include "admin\mod_commands"               // moderator commands
#include "adminspec"                        // Administrator Spectate by Keyman

#include "dialog"

#include <time>                             // time functions
//#tryinclude "testserver"					// testserver specific functions (not use)
#include "mapicons"      		// Radar Icones
#include "lottery"      			// Lottery

#include "tpmarkers"             // TP Markers to stadiums
#include "industrial"             // Дальнобойщики 2

#include "speed"                // functional speedometer

//----------Races----------
#tryinclude "races\race_thestrip"			// Race 1: Burnin Down The Strip. - Just a strait sprint down the strip and back
#tryinclude "races\race_riversiderun"		// Race 2: Riverside Run. - Beat the clock down a riverside dirt track.
#tryinclude "races\race_fleethecity"		// Race 3: Flee The City. - race to air strip
#tryinclude "races\race_lostinsmoke"		// Race 4: Lost in Smoke - a quick race around the city.
#tryinclude "races\race_backstreetbang"		// Race 5: Backstreet bang
#tryinclude "races\race_flyingfree"			// Race 6: Flying Free
#tryinclude "races\race_murderhorn"			// Race 7: Murderhorn - by |Insane|
#tryinclude "races\race_roundwego"			// Race 8: Airport Round We Go - by |Insane|
#tryinclude "races\race_striptease"			// Race 9: Strip Tease - by |Insane|
#tryinclude "races\race_monstertruck"		// Race 10: Monstertruck Madness
#tryinclude "races\race_countrycruise"		// Race 11: Countryside cruise
#tryinclude "races\race_thegrove"			// Race 12: Tearin Up The Grove
#tryinclude "races\race_mullholland"		// Race 13: Mullholland Getaway
#tryinclude "races\race_scal1"   			// Race 14: Julius Thruway Race
#tryinclude "races\race_secretbase"   		// Race 15: Verdant Meadows Race
#tryinclude "races\race_majestic" 		    // Race 16: Majestic
#tryinclude "races\race_roundsa"            // Race 17: Race Round SA by OFFREAL
#tryinclude "races\race_madball"            // Race 18: Mad Ball by Pirate Rat
#tryinclude "races\race_under"              // Race 19: Underground by OFFREAL
#tryinclude "races\race_rustler"            // Race 20: Rustler by Pirate_Rat
#tryinclude "races\race_helislalom"         // Race 21: Helicopter Slalom by Pirate_Rat
#tryinclude "races\race_stadium1"         // Race 22: Stadium1 by Pirate_Rat
#tryinclude "races\race_stadium2"         // Race 23: Stadium2 by Pirate_Rat
#tryinclude "races\race_dune"         // Race 24: DUNE by Pirate_Rat
#tryinclude "races\race_bike"         // Race 25: BikeZ by Pirate_Rat
#tryinclude "races\race_hotring"         // Race 26: hotring by Pirate_Rat
#tryinclude "races\race_boat"         // Race 25: boat by Linus

//----------Deathmatches----------
#tryinclude "deathmatches\dm_azarnik5"		// Deathmatch 1 - Peril Highness
#tryinclude "deathmatches\dm_area51"		// Deathmatch 2 - Area 51
#tryinclude "deathmatches\dm_badandugly"	// Deathmatch 3 - The Bad and the Ugly
#tryinclude "deathmatches\dm_bluemountains"	// Deathmatch 4 - Blue Mountains
#tryinclude "deathmatches\dm_cargoship"		// Deathmatch 5 - Cargo Ship
#tryinclude "deathmatches\dm_dildo"			// Deathmatch 6 - Dildo Farm Revenge
#tryinclude "deathmatches\dm_mbase"			// Deathmatch 7 - Millitary Base
#tryinclude "deathmatches\dm_minigunmadness"// Deathmatch 8 - Minigun Madness
#tryinclude "deathmatches\dm_poolday"		// Deathmatch 9 - Poolday
#tryinclude "deathmatches\dm_usnavy"		// Deathmatch 10 - The US Navy
#tryinclude "deathmatches\dm_azarnik"		// Deathmatch 11 - Fight on a Hill
#tryinclude "deathmatches\dm_kons"		    // Deathmatch 12 - Batle at the Punk's House
#tryinclude "deathmatches\dm_azarnik1"      // Deathmatch 13 - Hunt in Forest
#tryinclude "deathmatches\dm_azarnik3"      // Deathmatch 14 - Rendezvous
#tryinclude "deathmatches\dm_rocketmania"   // Deathmatch 15 - Rocketmania by Linus reincornated Wall on Wall (int)
#tryinclude "deathmatches\dm_paper"         // Deathmatch 16 - Paper Work by Linus (int)
#tryinclude "deathmatches\dm_building_area" // Deathmatch 17 - dm_building_area Pirate Rat
#tryinclude "deathmatches\dm_arctic"        // Deathmatch 18 - Arctic Sea

//-----------
//GTO REUNION
//-----------

#define STR 100

forward Lottery();
//forward MaxPing(playerid);
//forward KickUnreg(playerid);
forward SetupPlayerForClassSelection(playerid);
//forward GameModeExitFunc();
forward OnPlayerEnterVehicle();
forward WeatherUpdate();
forward DialogPlayerHelp(playerid, dlg);
forward DialogPlayerTun(playerid, mney);

//forward TestBroot();
//forward GetZoneNameText();

//forward Admincheck();
//------------------------//
//forward writer(playerid,xhtdert[]);
//forward xmessage(second, msg[]);

//public xmessage(second, msg[])
//{
//printf("%i second has passed, also we have a %s.", second, msg);
//return 1;
//}

/*public writer(playerid,xhtdert[])
{
printf("Timer pid = %d ,Timer string = %s\n",playerid,xhtdert);
new string[MAX_STRING];
format(string, sizeof(string),"Timer value = %d ,Timer string = %s", playerid,xhtdert);
SendClientMessage(playerid, COLOUR_GREEN, string);
return 1;
}*/
//-------------------------/

new ServerSecond;
//new Skin[MAX_PLAYERS];

main()
{
	// we will init on gamemode init,
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys == 8192) //NUM4
	{

		if(IsPlayerAtBank(playerid))
		{
			TogglePlayerControllable(playerid, 0);
			DialogPlayerBank(playerid);
		}

		if(IsPlayerAtBusiness(playerid))// && IsValidMenu(BisMenu))
		{
			TogglePlayerControllable(playerid, 0);
			DialogPlayerBisiness(playerid);
			//ShowMenuForPlayer(BisMenu, playerid);
		}

		if(IsPlayerAtHouse(playerid)) // && IsValidMenu(HouseMenu))
		{
			TogglePlayerControllable(playerid, 0);
			DialogPlayerHouse(playerid);
			//ShowMenuForPlayer(HouseMenu, playerid);
		}

		if(IsPlayerAtAmmunation(playerid))
		{
			TogglePlayerControllable(playerid, 0);
			DialogPlayerAmmo(playerid);
		}

		/*if(IsPlayerAtTDLC(playerid)) // покупка оил
		{
			TogglePlayerControllable(playerid, 0);
			DialogPlayerDLB(playerid);
		}

		if(IsPlayerAtTDLD(playerid)) // продажа керосина
		{
			TogglePlayerControllable(playerid, 0);
			DialogPlayerDLS(playerid);
		}

		if(IsPlayerAtTDLP(playerid)) // переработка оил
		{
			TogglePlayerControllable(playerid, 0);
			DialogPlayerDLP(playerid);
		}
		*/

	} // конец проверки нум4

	if(newkeys == 512) //submission
	{
		//SendClientMessage(playerid, COLOUR_GREEN,"Its WORKED !!!!");
		if(IsPlayerAtTPC(playerid))
		{
			OnPlayerReadyToEnterTPCP(playerid);
			return 1;
		}
        if(IsPlayerInIndustrialTruck(playerid))
		{
			DetachTrailerFromVehicle(GetPlayerVehicleID(playerid));
			return 1;
		}
	}

/*
	if(newkeys == 1024)
	{
    if(IsPlayerInAnyVehicle(playerid) && IsPlayerAdmin(playerid))
    {
     new Float:x, Float:y, Float:z;
GetVehicleVelocity(GetPlayerVehicleID(playerid),x,y,z);
         x = x*2;
         y = y*2;
SetVehicleVelocity(GetPlayerVehicleID(playerid),x,y,z);
    }
	}
*/
	if(newkeys == 16)
	{

		if(IsPlayerInAnyVehicle(playerid))
		{

			for(new i=0;i<NPC_MAX;i++)
			{
				if(GetPlayerVehicleID(playerid) == NPC_Info[i][npc_VID] && NPC_Info[i][npc_VEnter] == 1)
				{
					new Float:vX, Float:vY, Float:vZ, Float:vA, Float:dX, Float:dY;
					GetVehiclePos(NPC_Info[i][npc_VID],vX,vY,vZ);
					GetVehicleZAngle(NPC_Info[i][npc_VID],vA);
					dX = Get_dx(vA-90, 3.00);
					dY = Get_dy(vA-90, 3.00);
					SetPlayerPos(playerid,vX+dX,vY+dY,vZ);
					break;
				}
			}

		} else {
			for(new i=0;i<NPC_MAX;i++)
			{
				if(NPC_Info[i][npc_VEnter] == 1)
				{
					if(IsPlayerInSphereOfVehicle(playerid, NPC_Info[i][npc_VID], 10))
					{
						PutPlayerInVehicle(playerid,NPC_Info[i][npc_VID],playerid);
						break;
					}
				}
			}
		}
	}
return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
Speed_OnPlayerSC(playerid, newstate, oldstate);
tuning_OnPlayerStateChange(playerid, newstate, oldstate);
aspec_OnPlayerStateChange(playerid, newstate, oldstate);
trade_OnPlayerSC(playerid, newstate, oldstate);
return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
aspec_OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid);
return 1;
}

public OnGameModeInit()
{
	new starttime = GetTickCount();
	new gamemode[MAX_NAME];
	//format(gamemode,sizeof(gamemode),"Grand Theft Online %s",VERSION);
	format(gamemode,sizeof(gamemode),"GTO %s",VERSION);
	SetGameModeText(gamemode);

	// Console Message
	print(" ");
	print(" ");
	print("\n----------------------------------\n");
	printf("	Running %s\n",gamemode);
	print(" ");
	print(" 	Created by:	Iain Gilbert (Bogart)");
	print(" 	Continued by:	Peter Steenbergen (j1nx)");
	print("		Robin Kikkert (Dejavu)");
	print("		Lajos Pacsek  (asturel)");
	print("		Dmitry Frolov (FP)");
	print("		Artem Firstov (Konsul)");
	print("		Maxim Tsarkov (OFFREAL)");
	print(" ");
	print(" 	Translated to Dutch by (Kraay)");
	print(" 	Translated to Hungarian by Adam Arato (addam)");
	print(" 	Translated to Norwegian by Jim C. Flaten (Inf3rn0)");
	print(" 	Translated to Russian by Dmitry Borisoff (Beginner)");
	print(" 	Translated to Spanish by (capitanazo)");
	print(" ");
	print("	 Visit us at http://www.sa-mp.com");
	print("\n----------------------------------\n");


	print("              o---o  GTO  o---o");
	print("       \\     /     \\     /     \\     /");
	print("        o---o   R   o---o   E   o---o");
	print("       /     \\     /     \\     /     \\");
	print("   ---o   U   o---o   N   o---o   I   o---");
	print("       \\     /     \\     /     \\     /");
	print("        o---o   O   o---o   N   o---o");
	print("       /     \\     /     \\     /     \\");
	print("              o---o > X < o---o");
	print("             /     \\     /     \\");
	print("                    o---o");
	
	//printf("1 %f",AnglePointToPoint(0.00,0.00,200.00,0.00));
	//printf("2 %f",AnglePointToPoint(0.00,0.00,200.00,200.00));
	//printf("3 %f",AnglePointToPoint(0.00,0.00,0.00,200.00));
	//printf("4 %f",AnglePointToPoint(0.00,0.00,-200.00,200.00));
	
	//printf("5 %f",AnglePointToPoint(0.00,0.00,-200.00,0.00));
	//printf("6 %f",AnglePointToPoint(0.00,0.00,-200.00,-200.00));
	//printf("7 %f",AnglePointToPoint(0.00,0.00,0.00,-200.00));
	//printf("8 %f",AnglePointToPoint(0.00,0.00,200.00,-200.00));
	
	//format(gamemode,sizeof(gamemode),"%d",minrand(1,29));
	//printf("Testing %d\n",minrand(1,29));
	//------------------------------------
	// Connect to SQLite database
	//------------------------------------
	if(dini_Exists("DB.cfg"))
	{
	DBTYPE = strval(dini_Get("DB.cfg","DBTYPE"));
	DBLOG = strval(dini_Get("DB.cfg","DBLOG"));
	DBCONSOLELOG = strval(dini_Get("DB.cfg","DBCONSOLELOG"));
	}
	else
	{
	DBTYPE = 1;
	DBLOG = 0;
	DBCONSOLELOG = 0;
	dini_Create("DB.cfg");
	dini_IntSet("DB.cfg","DBTYPE",DBTYPE);
	dini_IntSet("DB.cfg","DBLOG",DBLOG);
	dini_IntSet("DB.cfg","DBCONSOLELOG",DBCONSOLELOG);
	}
	
	if(DBTYPE != 0 && DBTYPE != 1) {DBTYPE = 1;}

	if(DBTYPE == 1) { DatabaseConnect(); }
		
	//------------------------------------
	// Initialize everything that needs it
	//------------------------------------
	// Buggeg 3DT
	new Text3D:Bug3DT;
	new Text:BugTD;
	new Bug3DTx = 0;
	new BugTDx = 0;
	BugTD = TextDrawCreate( 0.00, 0.00, " ");
    Bug3DT = Create3DTextLabel("bugged", 0xFFFFFFFF, 246.1479,116.5132,1005.2188, 15.00, 0, 0);
    if(Bug3DTx == 1) { print("Bugged 3DT deleted"); Delete3DTextLabel(Bug3DT); }
    if(BugTDx == 1) { print("Bugged TD deleted"); TextDrawDestroy(BugTD); }
	
	LoggingInit();
	BaseLoadConfig();
	AccountLoadConfig();
	PlayerLoadConfig();
	//GangLoadConfig();
	PaydayLoadConfig();
	LoggingLoadConfig();
	WeaponLoadAll();
	VehicleLoadAll();
	
	RaceLoadAll();
	DeathmatchLoadAll();
	
	BusinessLoadAll();
	HousesLoadAll();
	AmmunationInit();
	BankInit();
	GroundholdInit();
	BusinessInit();
	HousesInit();
	LanguageInit();
	//EnableTirePopping(1);
	//EnableZoneNames(1);
	UsePlayerPedAnims();
	AllowAdminTeleport(1);
	EnableStuntBonusForAll(0);
	
	TPCInit();
	TradeInit();
	
	NPCInit();
	
	/*if (!dini_Exists("GTO/GTOConfig.cfg"))
	{
	dini_Create("GTO/GTOConfig.cfg");
	dini_Set("GTO/GTOConfig.cfg","AllowInteriorWeapons","1");
	AllowInteriorWeapons(1);
	}
	else
	{
	new allow;
	allow = strval(dini_Get("GTO/GTOConfig.cfg","AllowInteriorWeapons"));
	AllowInteriorWeapons(allow);
	}
	*/


	// Races
	
	//  1
	#if defined _race_thestrip_included
		race_thestrip_init();
	#endif
	
	//  2
	#if defined _race_riversiderun_included
		race_riversiderun_init();
	#endif
	
	//  3
	#if defined _race_fleethecity_included
		race_fleethecity_init();
	#endif
	
	//  4
	#if defined _race_lostinsmoke_included
		race_lostinsmoke_init();
	#endif
	
	//  5
	#if defined _race_backstreetbang_included
		race_backstreetbang_init();
	#endif
	
	//  6
	#if defined _race_flyingfree_included
		race_flyingfree_init();
	#endif
	
	//  7
	#if defined _race_murderhorn_included
		race_murderhorn_init();
	#endif
	
	//  8
	#if defined _race_roundwego_included
		race_roundwego_init();
	#endif
	
	//  9
	#if defined _race_striptease_included
		race_striptease_init();
	#endif
	
	//  10
	#if defined _race_monstertruck_included
		race_monstertruck_init();
	#endif
	
	//  11
	#if defined _race_countrycruise_included
		race_countrycruise_init();
	#endif
	
	//  12
	#if defined _race_thegrove_included
		race_thegrove_init();
	#endif
	
	//  13
	#if defined _race_mullholland_included
		race_mullholland_init();
	#endif
	
	//  14
	#if defined _race_scal1_included
	    race_scal1_init();
	#endif
	
	//  15
	#if defined _race_secretbase_included
	    race_secretbase_init();
	#endif
	
	//  16
	#if defined _race_majestic_included
	    race_majestic_init();
	#endif
	
	//  17
	#if defined _race_roundsa_included
	    race_roundsa_init();
	#endif
	
	//  18
	#if defined _race_madball_included
	    race_madball_init();
	#endif
	
	//  19
	#if defined _race_under_included
	    race_under_init();
	#endif
	
	//  20
	#if defined _race_rustler_included
	    race_rustler_init();
	#endif
	
	//  21
	#if defined _race_helislalom_included
	    race_helislalom_init();
	#endif
	
	//  22
	#if defined _race_stadium1_included
	    race_stadium1_init();
	#endif
	
	//  23
	#if defined _race_stadium2_included
	    race_stadium2_init();
	#endif

	//  24
	#if defined _race_dune_included
	    race_dune_init();
	#endif

	//  25
	#if defined _race_bike_included
	    race_bike_init();
	#endif

	//  26
	#if defined _race_hotring_included
	    race_hotring_init();
	#endif

	//  27
	#if defined _race_boat_included
	    race_boat_init();
	#endif

	// Deathmatches
	
	//  1
	#if defined _dm_azarnik5_included
		dm_azarnik5_init();
	#endif
	
	//  2
	#if defined _dm_area51_included
		dm_area51_init();
	#endif
	
	//  3
	#if defined _dm_badandugly_included
		dm_badandugly_init();
	#endif
	
	//  4
	#if defined _dm_bluemountains_included
		dm_bluemountains_init();
	#endif
	
	//  5
	#if defined _dm_cargoship_included
		dm_cargoship_init();
	#endif
	
	//  6
	#if defined _dm_dildo_included
		dm_dildo_init();
	#endif
	
	//  7
	#if defined _dm_mbase_included
		dm_mbase_init();
	#endif
	
	//  8
	#if defined _dm_minigunmadness_included
		dm_minigunmadness_init();
	#endif
	
	//  9
	#if defined _dm_poolday_included
		dm_poolday_init();
	#endif
	
	//  10
	#if defined _dm_usnavy_included
		dm_usnavy_init();
	#endif
	
	//  11
	#if defined _dm_azarnik_included
	dm_azarnik_init();
	#endif
	
	//  12
	#if defined _dm_kons_included
	dm_kons_init();
	#endif
	
	//  13
	#if defined _dm_azarnik1_included
	dm_azarnik1_init();
	#endif
	
	//  14
	#if defined _dm_azarnik3_included
	dm_azarnik3_init();
	#endif
	
	//  15
	#if defined _dm_rocketmania_included
	dm_rocketmania_init();
	#endif
	
	//  16
	#if defined _dm_paper_included
	dm_paper_init();
	#endif

	//  17
	#if defined _dm_building_area_included
	dm_building_area_init();
	#endif
	
	// 18
	#if defined _dm_arctic_included
	dm_arctic_init();
	#endif

	printf("SERVER: Racing and DM Scripts init");
	
	#tryinclude "armours"   //Armours
	#tryinclude "objects"  //[LV]Park

	printf("SERVER: New Objects and Pickups init");
	
	WorldTime = 0;
	ServerSecond = 0;
	SetWorldTime(WorldTime);
	print(" \n");
	printf("SERVER: Worldtime set as %d:0%d",WorldTime,ServerSecond);
	SetWeather(10);
	
//----------------------------------------------------
//Set timers for anything that needs constant checking
//----------------------------------------------------

	SetTimer("SpawnTimer", 1000, 1);
	SetTimer("SyncPlayers", PLAYER_SYNC_DELAY, 1);
	SetTimer("PlayerHealthRegen", HEALTH_REGEN_SPEED, 1);
	SetTimer("TextScroller",TEXT_SCROLL_SPEED,1);
	//SetTimer("WorldSave", WorldSaveDelay, 1);
	SetTimer("SyncTime", 60000, 1);      //ADDED CLOCK WORLD
	SetTimer("SyncActiveCP", 2600, 1);
	SetTimer("CheckRace", 2000, 1);
	SetTimer("CheckDM", 2000, 1);
	SetTimer("PayDay", PayDayDelay, 1);
	SetTimer("CheckAllGround", GROUNDHOLD_DELAY, 1);
	SetTimer("TurnAround", TurnAroundDelay, 1);
	SetTimer("HouseKeepUp",HOUSE_DELAY,1);

	SetTimer("Lottery",1200000,1);
	
	SetTimer("CheckGangs",1000,1);

	SetTimer("CheckNPCs",NPC_CHECK_TIME,1);
	
	SetTimer("UpdateSpeed",SP_UPD_TIME,1);
	
	//SetTimer("CmdTimeCheck",1000,1);
	
	//SetTimer("TestBroot",180000,0);
	//SetTimer("GetZoneNameText",1000,1);
	
	//SetTimer("Admincheck", 1001, true);
	
	printf("SERVER: Lottery script init.");
	
	MapIcones();  //теперь все черес новый файл работает --- mapicons.inc
	MapIcons_OnGameModeInit();

/* всеменю переписал
//-----------------------
//Housing & Business Menu
//-----------------------

// HouseMenuInit();
// BisMenuInit();
 //BankMenuInit();
 //BankMenuAddInit();
 //BankMenuGetInit();
 //WeaponMenuInit();
 
 printf("SERVER: Menu init.");
*/

//------------------------
// Packages
//------------------------
PackInit();
//------------------------

//------------------------
	ShowPlayerMarkers(1);
	ShowNameTags(1);
	SpawnWorld();
//------------------------
	RaceLoadRecordDBAll();
	DeathmatchLoadRecordDBAll();
//------------------------
/*
	if ((VerboseSave == 1) || (VerboseSave == -1))
	{
		WorldSave();
		if (VerboseSave == -1) VerboseSave = 0;
	}
*/
   	new string[MAX_STRING];
    new hour,minute,second;
    gettime(hour,minute,second);
    if ( (hour <= 9) && (minute <= 9) ) {format(string,sizeof(string),"0%d:0%d",hour,minute);}
    if ( (hour <= 9) && (minute > 9) )  {format(string,sizeof(string),"0%d:%d",hour,minute);}
    if ( (hour > 9) && (minute <= 9) ) {format(string,sizeof(string),"%d:0%d",hour,minute);}
    if ( (hour > 9) && (minute > 9) )  {format(string,sizeof(string),"%d:%d",hour,minute);}

	print("\n-----------------------------------------------------\n");
	print("TRANSPORT STATISTICS:");
	printf("Vehicles: %d,		Models: %d", ActiveVehiclesCount, ActiveVehicleModelsCount());
	print("\n-----------------------------------------------------\n");
	
	printf("SERVER: %s initialization complete [%s][%d ms].",gamemode, string,GetTickCount()-starttime);
	new logstring[256];
	format(logstring, sizeof (logstring), "SERVER: %s initialization complete [%s][%d ms].",gamemode, string, GetTickCount()-starttime);
	WriteLog(logstring);
	
	//ConnectNPC("NPC1", "npcidle");
	//print("Starting timer...");
    //SetTimerEx("xmessage", 5000, false, "is", { 5, "string to pass"} );
    
	return 1;
	}
	//-------------------------------------------------

/*	//-------------------------------------------------
new PlayerZoneID[MAX_PLAYERS];


public GetZoneNameText()
{
new Float:x, Float:y, Float:z;
new name[MAX_STRING] = "Unknown";
for(new i=0;i<MAX_PLAYERS;i++)
{
if(IsPlayerInZone(i, PlayerZoneID[i])) {continue;}
else
{
GetPlayerPos(i,x,y,z);
set(name,GetXYZZoneName(x,y,z));
GameTextForPlayer(i, name, 999, 1);
PlayerZoneID[i] = GetXYZZoneID(x,y,z);
}
}
return 1;
}
*/

	//----------------------
	// When a player connect
	//----------------------
	
	public OnPlayerConnect(playerid)
	{
	/*
	if(strcomp(oGetPlayerName(playerid),"Unknown",true) == 1)
	{
	SendClientMessage(playerid, COLOUR_WHITE,lang_texts[1][60]);
	Kick(playerid);
	return 1;
	}
	*/
	
    //Speed_OnPlayerConnect(playerid);
	//GetPlayerPackSignal(playerid, 0, -1);

	if(IsPlayerNPC(playerid))
	{
    OnNPCJoinServer(playerid);
	return 1;
	}
		player_Connect(playerid);
		
		Pack_OnPlayerConnect(playerid);
		Speed_OnPlayerConnect(playerid);
        trade_OnPlayerConnect(playerid);


		new string[MAX_STRING];
  		format(string, sizeof(string),lang_texts[15][85], VERSION);
		GameTextForPlayer(playerid,string,5500,5);

 		SendClientMessage(playerid, COLOUR_GREEN, "Добро Пожаловать на сервер GTO REUNION");
  		SendClientMessage(playerid, COLOUR_WHITE, lang_texts[15][86]);
		SendClientMessage(playerid, COLOUR_WHITE, lang_texts[15][87]);
		SendClientMessage(playerid, COLOUR_WHITE, lang_texts[15][93]);
        SendClientMessage(playerid, COLOUR_LIGHTRED, lang_texts[15][88]);
		SendClientMessage(playerid, COLOUR_WHITE, lang_texts[15][89]);
		SendClientMessage(playerid, COLOUR_LIGHTRED, lang_texts[15][90]);
		SendClientMessage(playerid, COLOUR_WHITE, lang_texts[15][91]);
		SendClientMessage(playerid, COLOUR_WHITE, lang_texts[15][92]);
		SendClientMessage(playerid, COLOUR_WHITE, lang_texts[15][94]);
	 	format(string, sizeof(string),lang_texts[15][95],MAXUNREGTIME);
		SendClientMessage(playerid, COLOUR_WHITE, string);

		//PlayerTimerPing[playerid] = SetTimerEx("MaxPing",25000,0,"d",playerid);
		//PlayerTimerUnreg[playerid] = SetTimerEx("KickUnreg",UnregTime,0,"d",playerid);
//------------------

	//	new pdb[MAX_STRING];
	//	new adb[MAX_STRING];
	//	format(adb,sizeof(adb),"%sGTO.Account.%s.txt",AccountDB,EncodeName(oGetPlayerName(playerid)));
	//	format(pdb,sizeof(pdb),"%sGTO.Account.%s.txt",PlayerDB,EncodeName(oGetPlayerName(playerid)));
		
	//	if(dini_Exists(dinifilename))

	//	ReSetAcc[playerid] = 0;

		if(DBTYPE == 1)
		{
		new DBResult:dialog;
		new query[128];
		format(query,sizeof(query),"SELECT id FROM players WHERE name = '%s' LIMIT 1",oGetPlayerName(playerid));
		dialog = xdb_query(ReunionDB,query);
		if(!db_num_rows(dialog))
		{
		Turing(playerid);
		DialogPlayerToReadRules(playerid);

	//	new dinifilename[MAX_STRING];
	//	format(dinifilename,sizeof(dinifilename),"%sGTO.Account.%s.txt",AccountDB,EncodeName(oGetPlayerName(playerid)));

	//	if(dini_Exists(dinifilename))
	//	{
	//	SendClientMessage(playerid,COLOUR_GREEN, " ::: ВНИМАНИЕ :::" );
	//	SendClientMessage(playerid,COLOUR_GREEN, " На сервере проходит испытание новой системы хранения аккаунтов!" );
	//	SendClientMessage(playerid,COLOUR_GREEN, " Чтобы восстановить свой старый аккаунт пройдите регистрацию, после чего введите:" );
	//	SendClientMessage(playerid,COLOUR_GREEN, " '/dblogin password' Используйте пароль от СТАРОГО аккаунта!" );
	//	ReSetAcc[playerid] = 1;
	//	}

		}
		else
		{
		DialogPlayerToLogin(playerid);
		}
		
  		}
		else if(DBTYPE == 0)
		{
		new dinifilename[MAX_STRING];
		format(dinifilename,sizeof(dinifilename),"%sGTO.Account.%s.txt",AccountDB,EncodeName(oGetPlayerName(playerid)));
		if(dini_Exists(dinifilename))
		{
		DialogPlayerToLogin(playerid);
		}
		else
		{
		Turing(playerid);
		DialogPlayerToReadRules(playerid);
		}
		}
//------------------
		
		#if defined _testserver_included
			testserver_playerconnect(playerid);
		#endif
		Debug("GTO.pwn > OnPlayerConnect(playerid) - Stop");
		return 1;
	}


/*
public Admincheck()
 {
 for(new i = 0; i < MAX_PLAYERS; i++)
      {
 if(IsPlayerConnected(i))
           {
 if(IsPlayerAdmin(i))
                {
 AllowPlayerTeleport(i, 1);
                }
           }
      }
 return 0;
 }
 */
/*
	public MaxPing(playerid)
	{
	new PlayerPing = GetPlayerPing(playerid);
	if (PlayerPing > 400)
	{
	SendClientMessage(playerid,COLOUR_RED, lang_texts[20][1] );
	new PlayerName[30], str[256];
    GetPlayerName(playerid, PlayerName, 30);
    format(str, 256, lang_texts[20][2] , PlayerName, playerid);
    SendClientMessageToAll(COLOUR_YELLOW,str);
	Kick(playerid);
	}
	else
	{
	SendClientMessage(playerid,COLOUR_GREEN, lang_texts[20][3] );
	}
	return 1;
	}
	*/
/*
public TestBroot()
{

new symbol[65][2] = {
		"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z", //26
		"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z", //26
		"1","2","3","4","5","6","7","8","9","0", // 10
		"[","]","_" //3
		};

new keycode[5];
set(keycode,"Fh_9");

new str[5];
new find[5];

for(new r=0;r<65;r++)
{
set(str[0],symbol[r]);

for(new e=0;e<65;e++)
{
set(str[1],symbol[e]);

for(new w=0;w<65;w++)
{
set(str[2],symbol[w]);

for(new q=0;q<65;q++)
{
set(str[3],symbol[q]);
format(str,sizeof(str),"%s%s%s%s",str[0],str[1],str[2],str[3]);
printf("%s", str);
if(strcmp(str,keycode, true) == 0)
{
printf("------------------------ >>> %s", str);
set(find,str);
}

}
}
}
}

printf("Code find = %s", find);

return 1;
}
*/
/*
public KickUnreg(playerid)
{
if(!IsPlayerRegistered(playerid))
{
new string[MAX_STRING];
format(string,sizeof(string),lang_texts[15][96],UnregTime/1000);
SendClientMessage(playerid,COLOUR_WHITE,string);
Kick(playerid);
return 1;
}
return 1;
}
*/
//-------------------------
// When a player disconnect
//-------------------------

	public OnPlayerDisconnect(playerid)
	{
		if (playerid == INVALID_PLAYER_ID)
		{
			return;
		}
		//Speed_OnPlayerDisconnect(playerid);
		if(IsPlayerNPC(playerid))
		{
		OnNPCLeaveServer(playerid);
		return;
		}
		if (IsPlayerRegistered(playerid))
		{
			PlayerSave(playerid);
			AccountSave(playerid);
		}
		
		DMPlayerDisconnect(playerid);
		player_Disconnect(playerid);
		Speed_OnPlayerDisconnect(playerid);
		oDisablePlayerRaceCheckpoint(playerid);
	}

//----------------------------------
// When a player enters a checkpoint
//----------------------------------

	public OnPlayerEnterCheckpoint(playerid)
	{
	if(IsPlayerNPC(playerid)) return;
	if (playerid == INVALID_PLAYER_ID) return;
	if (playerid == INVALIDX_PLAYER_ID) return;
	if (!IsPlayerConnected(playerid)) return;

		OnPlayerEnterAmmoCheckpoint(playerid);
		OnPlayerEnterRaceCheckpoint(playerid);
		OnPlayerEnterDMCheckpoint(playerid);
		OnPlayerEnterBankCheckpoint(playerid);
		OnPlayerEnterBusinessCheckpoint(playerid);
		OnPlayerEnterHousesCheckpoint(playerid);
		OnPlayerEnterTPCheckpoint(playerid);
		OnPlayerEnterTradeCheckpoint(playerid);

	}
	
//-------------------
// When a player dies
//-------------------

	public OnPlayerDeath(playerid, killerid, reason)	// loose xp, give money, deaths++
	{
		if (!IsPlayerConnected(playerid))
		{
			return 1;
		}
		
		if (!IsPlayerRegistered(playerid))
		{
		Kick(playerid);
		return 1;
		}
		
		if (killerid == INVALID_PLAYER_ID)
		{
			new logstring[256];
			format(logstring, sizeof (logstring), "player: %d: %s: has died > Reason: (%d)",playerid,oGetPlayerName(playerid),reason);
			WriteLog(logstring);
		}
		else
		{
			new logstring[256];
			format(logstring, sizeof (logstring), "player: %d: %s: has killed player %s(%d)> Reason: (%d)",killerid,oGetPlayerName(killerid),oGetPlayerName(playerid),playerid,reason);
			WriteLog(logstring);
		}
		SendDeathMessage(killerid,playerid,reason);
		Speed_OnPlayerDeath(playerid);
		if (!IsPlayerInAnyDM(playerid))
		{
			PlayerDeath(playerid, killerid, reason);
		}
		else
		{
			OnPlayerDMDeath(playerid,killerid);
		}
		if (killerid == INVALID_PLAYER_ID)
		{
			return 1;
		}
		if (!IsPlayerInAnyDM(playerid))
		{
			PlayerKill(killerid, playerid, reason);
			UpdateWeaponSkill(killerid,reason);
		}
		else
		{
			OnPlayerDMKill(killerid,playerid,reason);
			UpdateWeaponSkill(killerid,reason);
		}
		return 1;
	}

//---------------------
// When a player spwans
//---------------------

	public OnPlayerSpawn(playerid)
	{
		if (!IsPlayerConnected(playerid))
		{
			return 1;
		}
		
	if(IsPlayerNPC(playerid))
	{
	SetupNPCToSpawn(playerid);
	return 1;
	}
		//Player[playerid][SkinModel] = GetPlayerSkin(playerid);
		//SetPlayerSkin(playerid,Player[playerid][SkinModel]);
		Speed_OnPlayerSpawn(playerid);
//----------Jail----------

		if (Player[playerid][Jailed] == 1)
		{
			SetPlayerInterior(playerid,6);
			SetPlayerPos(playerid,265.1273,77.6823,1001.0391);
			SetPlayerFacingAngle(playerid,0);
			SetPlayerWantedLevel(playerid, 6);
			SetPlayerArmour(playerid, 0);
			SetPlayerHealth(playerid, 10);
			ResetPlayerMoney(playerid);
			ResetPlayerWeapons(playerid);
			PlayerPlaySound(playerid,1082,198.3797,160.8905,1003.0300);
		}
		
//----------Mute----------

		if (Player[playerid][Muted] == 1)
		{
			SendPlayerFormattedText(playerid,lang_texts[1][14], 0,COLOUR_RED);
			SetPlayerWantedLevel(playerid, 1);
		}
		else if(Player[playerid][Muted] == 2)
		{
			SendPlayerFormattedText(playerid,lang_texts[1][38], 0,COLOUR_RED);
			SetPlayerWantedLevel(playerid, 2);
		}
		else if(Player[playerid][Muted] > 2)
		{
			SendPlayerFormattedText(playerid,"Администратор временно запретил Вам писать в общий чат.", 0,COLOUR_RED);
			SendPlayerFormattedText(playerid,"Чтобы узнать сколько вам еще молчать напишите что-нибудь в чат", 0,COLOUR_RED);
			SetPlayerWantedLevel(playerid, 3);
		}
//----------Skill-----------
	GivePlayerWeaponsSkill(playerid);
//----------SQL-------------
//if(ReSetAcc[playerid] == 1)
//{
//		SendClientMessage(playerid,COLOUR_GREEN, " ::: ВНИМАНИЕ :::" );
//		SendClientMessage(playerid,COLOUR_GREEN, " На сервере проходит испытание новой системы хранения аккаунтов!" );
//		SendClientMessage(playerid,COLOUR_GREEN, " Чтобы восстановить свой старый аккаунт пройдите регистрацию, после чего введите:" );
//		SendClientMessage(playerid,COLOUR_GREEN, " '/dblogin password' Используйте пароль от СТАРОГО аккаунта!" );
//}
		
//----------Dm_Die----------
			
		new dmid = GetPlayerDM(playerid);
		if ((dmid == INVALID_DM_ID) || (DMPlayerStats[playerid][dm_player_active] == 0))
		{
			player_Spawn(playerid);
			SetPlayerColour(playerid,PlayerGangColour(playerid));
		}
		else
		{
			DMPlayerSpawn(playerid,dmid);
		}
		return 1;
	}

//-----------------------------
// When player choose character
//-----------------------------

	public OnPlayerRequestClass(playerid, classid)
	{
	
	if(IsPlayerNPC(playerid))
	{
	SetupNPCToClassSelect(playerid);
	return 1;
	}
	

		//PlayerSkin[playerid] = classid;
		//Skin[playerid] = classid;
		//Player[playerid][SkinModel] = classid;
		// for usefull functions include
		//SpawnPlayer(playerid);
		SetupPlayerForClassSelection(playerid);
		return 1;
		
	}

	public SetupPlayerForClassSelection(playerid)
	{
			SetPlayerInterior(playerid,1);
			SetPlayerPos(playerid,-2167.2000,642.2000,1057.5938);
			SetPlayerFacingAngle(playerid,85.0000);
			SetPlayerCameraPos(playerid,-2169.7000,642.7000,1057.5938);
			SetPlayerCameraLookAt(playerid,-2167.2000,642.7000,1057.5938);
			//Player[playerid][SkinModel] = GetPlayerSkin(playerid);
	}

//--------------------
// Processing Commands
//--------------------

	public OnPlayerCommandText(playerid,cmdtext[])						// process commands
	{
		if (!IsPlayerConnected(playerid))
		{
			return 1;
		}
		
		if (!IsPlayerRegistered(playerid))
		{
		SendClientMessage(playerid, COLOUR_CRIMSON, "Незарегистрированным игрокам запрещено пользоваться командной строкой!");
 		return 1;
		}
		
		new cmdfound;
		cmdfound += CommandHandler(playerid,cmdtext);
		cmdfound += AccountCommandHandler(playerid,cmdtext);
		cmdfound += GangCommandHandler(playerid,cmdtext);
		cmdfound += AmmunationCommandHandler(playerid,cmdtext);
		cmdfound += BankCommandHandler(playerid,cmdtext);
		cmdfound += RaceCommandHandler(playerid,cmdtext);
		cmdfound += AdminRaceCommandHandler(playerid,cmdtext);
		cmdfound += AdminCommandHandler(playerid,cmdtext);  			//rcon admins
		cmdfound += AdminCommandHandlerSys(playerid,cmdtext);   		//SYSTEM
		cmdfound += DMCommandHandler(playerid,cmdtext);
		cmdfound += AdminDMCommandHandler(playerid,cmdtext);
		cmdfound += AdmCommandHandler(playerid,cmdtext);    			//admins
		cmdfound += ModCommandHandler(playerid,cmdtext);    			//moderators
		cmdfound += BusinessCommandHandler(playerid,cmdtext);
		cmdfound += HousesCommandHandler(playerid,cmdtext);
		cmdfound += CarsCommandHandler(playerid,cmdtext);
  		if (cmdfound > 0)
		{
			new cmd[20];
			new idx;
			set(cmd,strcharsplit(cmdtext, idx,strchar(" ")));
			if ((strcomp(cmd, "/login", true) == 1) || (strcomp(cmd, "/register", true) == 1))
			{
				new logstring[256];
				format(logstring, sizeof (logstring), "player: %d:  %s:    %s *********",playerid,oGetPlayerName(playerid),cmd);
				WriteCMDLog(logstring);
			}
			else
			{
				new logstring[256];
				format(logstring, sizeof (logstring), "player: %d:  %s:    %s",playerid,oGetPlayerName(playerid),cmdtext);
				WriteCMDLog(logstring);
			}
			return 1;
		}
		return 0;
	}


//-----Ниже используемый опрос - если игрок пишет в чат, всгда выдает ретерн 0, то есть фактически функция несрабатывает!!!-----
public OnPlayerText(playerid, text[])
{

if(!IsPlayerRegistered(playerid)) { //если игрок незарегистрирован и пишет в чат...

if(ChatPopitki[playerid] == 0) //...пишет в первый раз.
{
SendClientMessage(playerid, COLOUR_CRIMSON, lang_texts[1][34]);
ChatPopitki[playerid]++; //переменная ++ писал в чат 1 раз
return 0;
}
if(ChatPopitki[playerid] == 1) //... пишет во второй раз
{
SendClientMessage(playerid, COLOUR_CRIMSON, lang_texts[1][34]);
SendClientMessage(playerid, COLOUR_CRIMSON, lang_texts[1][35]);
ChatPopitki[playerid]++; //переменная ++ писал в чат 2 раза
return 0;
}
if(ChatPopitki[playerid] >= 2) //...пишет в третий раз
{
SendClientMessage(playerid, COLOUR_CRIMSON, lang_texts[1][36]);
Kick(playerid);
return 0;
}
return 0;}

if(Player[playerid][Muted] == 2) {SendClientMessage(playerid, COLOUR_CRIMSON, lang_texts[1][38]); return 0;}

PlayerAntiFlood(playerid,text);

if(text[0] == '!')
{
new gangmessage[MAX_STRING];
strmid(gangmessage,text,1,strlen(text));
if(!strlen(gangmessage)) return 1;
format(gangmessage, sizeof(gangmessage), "Gang: %s [id %d]: %s", oGetPlayerName(playerid),playerid,gangmessage);
SendGangMessage(PlayerGangID[playerid],gangmessage,COLOUR_GANG_CHAT);
new logstring[256];
format(logstring, sizeof (logstring), "player: %d: g: %d: %s: <GANG CHAT>: %s",playerid,PlayerGangID[playerid],oGetPlayerName(playerid),text);
WriteChatLog(logstring);
return 0;
}

if(text[0] == '@')
{
AdminSpecialCommandHandler(playerid,text);
new logstring[256];
format(logstring, sizeof (logstring), "player: %d:  %s: <ADMIN TALK>:   %s",playerid,oGetPlayerName(playerid),text);
WriteChatLog(logstring);
return 0;
}

if(text[0] == '#')
{
ModSpecialCommandHandler(playerid,text);
new logstring[256];
format(logstring, sizeof (logstring), "player: %d:  %s: <MODERATOR TALK>:   %s",playerid,oGetPlayerName(playerid),text);
WriteChatLog(logstring);
return 0;
}

if(Player[playerid][Muted] == 1) {SendClientMessage(playerid, COLOUR_CRIMSON, lang_texts[1][14]); return 0;}
if(Player[playerid][Muted] > 0) {

new date_p = Player[playerid][Muted];
new date_n = Now();

if(date_p <= date_n) {
Player[playerid][Muted] = 0; SetPlayerWantedLevel(playerid, 0);
SendClientMessage(playerid, COLOUR_LIGHTGREEN, "Время вышло, теперь вы можете общаться в чате");
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
format(str,sizeof(str),"Вы будете молчать еще %d дней, %d часов, %d минут, %d секунд",day,hour,minute,second);
SendClientMessage(playerid, COLOUR_CRIMSON, str);
return 0;
}}

new string[256];                                              //ID in CHAT <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
format(string, sizeof(string), "[id %d] %s", playerid, text); //ID in CHAT <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
SendPlayerMessageToAll(playerid, string);                     //ID in CHAT <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
new logstring[256];                                           //ID in CHAT <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
format(logstring, sizeof (logstring), "player: %d:  %s:    %s",playerid,oGetPlayerName(playerid),text);
WriteChatLog(logstring);
return 0;

}


//--------------------
// When gamemode exits
//--------------------

	public OnGameModeExit()
	{
		WorldSave();
		GameModeExit();
		Speed_OnGameModeExit();
	}

//----------------
//Private messages
//----------------
/*
	public OnPlayerPrivmsg(playerid, recieverid, text[])
	{

        if (!IsPlayerRegistered(playerid))
        {
        	SendClientMessage(playerid,COLOUR_RED, lang_texts[1][37]);
        	return 0;
        }
        
        
        if (Player[playerid][Muted] == -2)
        {
        	SendClientMessage(playerid,COLOUR_RED, lang_texts[1][38]);
        	return 0;
		}
		
		if(Player[playerid][Muted] == -1)
		{
			SendPlayerFormattedText(playerid,lang_texts[1][14], 0,COLOUR_RED);
			return 1;
		} 
		if(Player[playerid][Muted] > 0)
		{
			SendPlayerFormattedText(playerid,"Администратор временно запретил Вам писать в общий чат.На данный момент вы можете писать только Администраторам через @ или Модераторам через #.", 0,COLOUR_RED);
			SendPlayerFormattedText(playerid,"Что-бы узнать срок снятия накозания наберите /muted", 0,COLOUR_RED);
			SetPlayerWantedLevel(playerid, 5);
			return 1;
		}

	return 1;
	}
*/


/* нету таких меню больше
//------
//Menues
//------

public OnPlayerSelectedMenuRow(playerid,row) {
new Menu:Current = GetPlayerMenu(playerid);

//----------House----------

if(Current == HouseMenu) {
	TogglePlayerControllable(playerid, 0);
	switch(row) {
		case 0: {TogglePlayerControllable(playerid, 1); return 1;} //cancel
		case 1: {FHouseInfo(playerid); ShowMenuForPlayer(HouseMenu, playerid);} //Info
		case 2: {FHouseBuy(playerid); TogglePlayerControllable(playerid, 1);} //Buy
		case 3: {FHouseSell(playerid); TogglePlayerControllable(playerid, 1);} //Sell
		case 4: {FHouseKeep(playerid); TogglePlayerControllable(playerid, 1);} //Keeping
		//case 5: {FHouseMyHouses(playerid); ShowMenuForPlayer(HouseMenu, playerid);} //My Houses
		case 5: {FHouseHouses(playerid); ShowMenuForPlayer(HouseMenu, playerid);} //Houses
	}
}

//----------Bisiness----------

if(Current == BisMenu) {
TogglePlayerControllable(playerid, 0);
switch(row) {
case 0: {TogglePlayerControllable(playerid, 1); return 1;} //cancel
case 1: {FBisInfo(playerid); ShowMenuForPlayer(BisMenu, playerid);} //Info
case 2: {FBisBuy(playerid); TogglePlayerControllable(playerid, 1);} //Buy
case 3: {FBisSell(playerid); TogglePlayerControllable(playerid, 1);} //Sell
case 4: {FBisCollect(playerid); TogglePlayerControllable(playerid, 1);} //Collect
case 5: {FBisMyBises(playerid); ShowMenuForPlayer(BisMenu, playerid);} //My Businesses
case 6: {FBisBises(playerid); ShowMenuForPlayer(BisMenu, playerid);} //Businesses
}
}

//----------BankHead----------

if(Current == BankMenu) {
TogglePlayerControllable(playerid, 0);
switch(row) {
case 0: {TogglePlayerControllable(playerid, 1); return 1;} //cancel
case 1: ShowMenuForPlayer(BankMenuAdd, playerid);
case 2: ShowMenuForPlayer(BankMenuGet, playerid);
}
}

//----------BankAdd----------

if(Current == BankMenuAdd) {
TogglePlayerControllable(playerid, 0);
switch(row) {
case 0: ShowMenuForPlayer(BankMenu, playerid); //back
case 1: {PlayerAddMoneyToBank(playerid,5000000); ShowMenuForPlayer(BankMenuAdd,playerid);}
case 2: {PlayerAddMoneyToBank(playerid,1000000); ShowMenuForPlayer(BankMenuAdd,playerid);}
case 3: {PlayerAddMoneyToBank(playerid,500000); ShowMenuForPlayer(BankMenuAdd,playerid);}
case 4: {PlayerAddMoneyToBank(playerid,100000); ShowMenuForPlayer(BankMenuAdd,playerid);}
case 5: {PlayerAddMoneyToBank(playerid,50000); ShowMenuForPlayer(BankMenuAdd,playerid);}
case 6: {PlayerAddMoneyToBank(playerid,10000); ShowMenuForPlayer(BankMenuAdd,playerid);}
case 7: {PlayerAddMoneyToBank(playerid,5000); ShowMenuForPlayer(BankMenuAdd,playerid);}
case 8: {PlayerAddMoneyToBank(playerid,1000); ShowMenuForPlayer(BankMenuAdd,playerid);}
}
}

//----------BankGet----------

if(Current == BankMenuGet) {
TogglePlayerControllable(playerid, 0);
switch(row) {
case 0: ShowMenuForPlayer(BankMenu, playerid); //back
case 1: {PlayerGetMoneyFromBank(playerid,5000000); ShowMenuForPlayer(BankMenuGet,playerid);}
case 2: {PlayerGetMoneyFromBank(playerid,1000000); ShowMenuForPlayer(BankMenuGet,playerid);}
case 3: {PlayerGetMoneyFromBank(playerid,500000); ShowMenuForPlayer(BankMenuGet,playerid);}
case 4: {PlayerGetMoneyFromBank(playerid,100000); ShowMenuForPlayer(BankMenuGet,playerid);}
case 5: {PlayerGetMoneyFromBank(playerid,50000); ShowMenuForPlayer(BankMenuGet,playerid);}
case 6: {PlayerGetMoneyFromBank(playerid,10000); ShowMenuForPlayer(BankMenuGet,playerid);}
case 7: {PlayerGetMoneyFromBank(playerid,5000); ShowMenuForPlayer(BankMenuGet,playerid);}
case 8: {PlayerGetMoneyFromBank(playerid,1000); ShowMenuForPlayer(BankMenuGet,playerid);}
}
}


//----------Ammo----------
//-- переделано
return 1;
}

public OnPlayerExitedMenu(playerid)
{
TogglePlayerControllable(playerid, 1);
return 1;
}
*/



//_/\_/\_/\_/\_/\_/\_

public DialogPlayerHelp(playerid, dlg)
{
	if (!IsPlayerConnected(playerid)) return 0;
	new str[1024];
	if (dlg == 0)
	{ // правила коротко
		format(str,sizeof(str),"%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s ",lang_texts[20][23],lang_texts[20][24],lang_texts[20][25],lang_texts[20][26],lang_texts[20][27],lang_texts[20][28],lang_texts[20][29],lang_texts[20][30],lang_texts[20][31]);
		ShowPlayerDialog(playerid,CGUI+1,0,"::: Rules Short:::",str,"Full","Close");
		return 1;
	} else if (dlg == 1) { // правила стр1
		format(str,sizeof(str),"%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s ",lang_texts[19][2],lang_texts[19][3],lang_texts[19][4],lang_texts[19][5],lang_texts[19][6],lang_texts[19][7],lang_texts[19][8],lang_texts[19][9],lang_texts[19][10]);
		ShowPlayerDialog(playerid,CGUI+2,0,"::: Rules list 1:::",str,"Next","Close");
		return 1;
	} else if (dlg == 2) { // правила стр2
		format(str,sizeof(str),"%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s ",lang_texts[19][11],lang_texts[19][12],lang_texts[19][13],lang_texts[19][14],lang_texts[19][15],lang_texts[19][16],lang_texts[19][17],lang_texts[19][18],lang_texts[19][19]);
		ShowPlayerDialog(playerid,CGUI+3,0,"::: Rules list 2:::",str,"o GTO","back");
		return 1;
	} else { // я нуб
		format(str,sizeof(str),"%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s ",lang_texts[20][32],lang_texts[20][33],lang_texts[20][34],lang_texts[20][35],lang_texts[20][36],lang_texts[20][37],lang_texts[20][38],lang_texts[19][39],lang_texts[20][40],lang_texts[20][41]);
		ShowPlayerDialog(playerid,CGUI+4,0,"::: o GTO Reunion :::",str,"Rules","Close");
		return 1;
	}
}

public DialogPlayerTun(playerid, mney)
{
	if (!IsPlayerConnected(playerid)) return 0;
	new str[MAX_STRING];
	if(GetPlayerMoney(playerid) < mney)
	{
		format(str,sizeof(str),"Аренда данного автомобиля стоит:\n%d\nИзвените но у вас недостаточно средств.", mney);
		ShowPlayerDialog(playerid,CGUI+5,0,"::: Tun Car Shop:::",str,"Ok","Cancel");
		RemovePlayerFromVehicle(playerid);
	} else {
		format(str,sizeof(str),"Аренда данного автомобиля стоит:\n%d\nвы готовы заплатить?", mney);
		ShowPlayerDialog(playerid,CGUI+6,0,"::: Tun Car Shop:::",str,"Buy","Cancel");
	}		
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
if(source == 0)
{
SelectedID[playerid] = clickedplayerid;
if(playerid == clickedplayerid) {ShowPlayerDialog(playerid, CGUI, DIALOG_STYLE_LIST, ":: Список команд ::", MyCMDlist, "OK", "Cancel");}
else {
ShowPlayerDialog(playerid, CGUI+13, DIALOG_STYLE_LIST, ":: Игрок %s id:%d ::", PlCMDlist, "OK", "Cancel");}
return 1;
}
return 0;
}
//_/\_/\_/\_/\_/\_/\_

//--------------
//Weather Update
//--------------

public WeatherUpdate() {      //Random Weather
	if (sysweath==1)
	{
	new rand = random(19);
	SetWeather(rand);
	printf("SERVER: Weather set to %d",rand);
	}
}

//---
//End
//---
