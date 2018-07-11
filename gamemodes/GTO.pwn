/*
Project Name:	San Andreas: Multiplayer: Grand Theft Online
Addon Name: Reunion

Date ReCreated:	30.08.2016 (Recreated by OFFREAL) || Moded by Rishat

Compatable
SA-MP Versions: 0.3.7

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
#include <mSelection>

#include "base"								// holds base script values
#include "utils\gtoutils"					// misc used utils
#include "utils\gtodudb"					// old db handler
#include "utils\dini"						// db handler
#include "utils\dutils"						// more used tools
#include "utils\mxINI"                      // MX_Master IO system

#include "mapicons_streamer"                // map icons streamer
#include "streamer"                // map icons streamer

#include "lang"
#include "account"							// account handler
#include "rac\anticheat"
#include "player"							// holds player values
#include "weapons"							// weapons and ammunation shop
#include "vehicles" 						// vehicles

#include "packages"                         // pickaps packets
#include "tuncars"                          // tuned cars and hydra-hunter
#include "npcs"								// NPC

#include "world"							// functions for zone, location, world, etc
#include "gang10"							// gang handler
#include "housing"							// housing handler
#include "zones"							// gang zones
#include "logging"							// logging handler
#include "acs"
#include "anim"
#include "b_weapon"							// New bussines
#include "b_global"
#include "b_management"

#include "race"								// race handler, manages and runs all rasces
#include "deathmatch"						// deathmatch handler
#include "bank"								// bank money to keep it on death
#include "payday" 							// pay players money based on level
#include "groundhold"						// hold ground to gain money, pirate ship, etc

#include "commandhandler"					// command handler
#include "database_sql"
#include "pcars"
#include "clothes" 							// clothes shop

#include "admin\admin_commands"				// admin commands
#include "admin\admin_commands_race"		// admin commands for race creation/manipulation
#include "admin\admin_commands_dm"			// admin commands for deathmatch creation/manipulation
#include "admin\admin_commands_sys"         // admin sys commands for control system
#include "admin\adm_commands"               // admin commands
#include "admin\mod_commands"               // moderator commands
#include "adminspec"                        // Administrator Spectate by Keyman

#include <time>                             // time functions
//#tryinclude "testserver"					// testserver specific functions (not use)
#include "mapicons"      		// Radar Icones
#include "lottery"      			// Lottery

#include "tpmarkers"             // TP Markers to stadiums
#include "industrial"             // Дальнобойщики 2
#include "train"

#include "dialog"

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
#tryinclude "races\race_boat"         // Race 27: boat by Linus
#tryinclude "races\race_hj"         // Race 28: High Jump by Jouker
#tryinclude "races\derby_first"         // Derby 29: First Blood
#tryinclude "races\derby_two"         // Derby 30: Survival
#tryinclude "races\derby_three"         // Derby 31: Madness in the head
#tryinclude "races\race_final"         // Derby 32: Final match
#tryinclude "races\race_people"         // Derby 33: Village People
#tryinclude "races\race_star"         // Derby 34: Star Trek

//----------Deathmatches----------
#tryinclude "deathmatches\dm_azarnik5"		// Deathmatch 1 - Peril Highness
#tryinclude "deathmatches\dm_area51"		// Deathmatch 2 - Area 51
#tryinclude "deathmatches\dm_badandugly"	// Deathmatch 3 - The Bad and the Ugly
#tryinclude "deathmatches\dm_bluemountains"	// Deathmatch 4 - Blue Mountains
#tryinclude "deathmatches\dm_cargoship"		// Deathmatch 5 - Cargo Ship
#tryinclude "deathmatches\dm_dildo"			// Deathmatch 6 - Dildo Farm Revenge
#tryinclude "deathmatches\dm_baseball"		// Deathmatch 7 - BaseBall
//#tryinclude "deathmatches\dm_mbase"		// Deathmatch XXX - Millitary Base
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
#tryinclude "deathmatches\dm_newvegas"      // Deathmatch 19 - New Vegas
#tryinclude "deathmatches\zombie_chinatown"      // Zombie 20 - ChinaTown
#tryinclude "deathmatches\zombie_dillimore"      // Zombie 21 - Dillimore
#tryinclude "deathmatches\zombie_elcorona"      // Zombie 22 - El Corona

//-----------
//GTO REUNION
//-----------

#define STR 100
#define ForceClassSelection DeleteBagF4

forward Lottery();
//forward MaxPing(playerid);
//forward KickUnreg(playerid);
forward SetupPlayerForClassSelection(playerid);
//forward GameModeExitFunc();
forward OnPlayerEnterVehicle();
forward WeatherUpdate();
forward DialogPlayerHelp(playerid, dlg);
forward DialogPlayerTun(playerid, mney);
forward SyncCPAndPackages();

//forward TestBroot();
//forward GetZoneNameText();

//forward Admincheck();

new bool:DeleteF4Bag[MAX_PLAYERS];
new ServerSecond;
new ContactPlayer[MAX_PLAYERS];

main()
{
	// we will init on gamemode init,
}

new GetVW[MAX_PLAYERS];

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys == 8192) //NUM4
	{

		if(IsPlayerAtBank(playerid))
		{
			TogglePlayerControllable(playerid, 0);
			DialogPlayerBank(playerid);
		}
		
		if(IsPlayerAtArmDealer(playerid))
		{
			TogglePlayerControllable(playerid, 0);
			DialogPlayerWBussines(playerid);
		}

		if(IsPlayerAtHouse(playerid)) //
		{
			TogglePlayerControllable(playerid, 0);
			DialogPlayerHouse(playerid);
		}
		
		if(IsPlayerAtHotel(playerid)) //
		{
			TogglePlayerControllable(playerid, 0);
			//FHotelHotels(playerid);
			ShowPlayerDialog(playerid, HOTEL_MENU_DIALOG, DIALOG_STYLE_LIST, " Система управления отелями:", "Информация о всех отелях\nАрендовать отель\nВыписаться из отеля", "Выбрать", "Выход");
		}
		
		if(IsPlayerAtClothes(playerid)) //
		{
            new id = GetClothesID(playerid);
            if(id == 0)
            {
				SetPlayerPosEx(playerid,207.737991,-109.019996,1005.132812);
				SetPlayerInterior(playerid,15);
            } else if(id == 1) {
				SetPlayerPosEx(playerid,207.054992,-138.804992,1003.507812);
				SetPlayerInterior(playerid,3);
            } else if(id == 2) {
                SetPlayerPosEx(playerid,203.777999,-48.492397,1001.804687);
				SetPlayerInterior(playerid,1);
            }
		}
		
		if(IsPlayerAtChangeClothes(playerid)) //
		{
		    ShowModelSelectionMenu(playerid, skinlist, "Select Skin");
		}
		
		if(IsPlayerAtExitClothes(playerid))
		{
			new id = GetExitClothesID(playerid);
			SetPlayerPosEx(playerid,EnterToClothes[id][Coord_X],EnterToClothes[id][Coord_Y],EnterToClothes[id][Coord_Z]);
			SetPlayerInterior(playerid,0);
		}
		
        if(IsPlayerAtExitHouse(playerid))
		{
		    //new id=GetHouseIDInt(playerid);
		    GetVW[playerid]=GetPlayerVirtualWorld(playerid);
		    GetVW[playerid]=GetVW[playerid]-101;
		    //Houses[GetVW[playerid]][Houses_VW]=Houses[GetVW[playerid]][Houses_VW]-1;
		    //printf("GetWM = %d",GetVW[playerid]);
		    //printf("Player VirtualWorld = %d",GetPlayerVirtualWorld(playerid));
			//printf("House VirtualWorld = %d",Houses[GetVW[playerid]][Houses_VW]);
			// ПРОТЕСТИРОВАТЬ PRINTF ()
			if(GetPlayerVirtualWorld(playerid) == Houses[GetVW[playerid]][Houses_VW])
			{
				SetPlayerPosEx(playerid,HousesCP[GetVW[playerid]][Coord_X], HousesCP[GetVW[playerid]][Coord_Y], HousesCP[GetVW[playerid]][Coord_Z]);
				SetPlayerInterior(playerid,0);
        		oSetPlayerVirtualWorld(playerid,0); // Виртуальный мир дома
		    	DialogPlayerHouse(playerid);
		    	GetVW[playerid]=0;
			}
		}

		if(IsPlayerAtAmmunation(playerid))
		{
			DialogPlayerAmmo(playerid);
		}

		new tid = -1;
		tid = IsPlayerAtTradeCP(playerid);

		if(tid != -1)
		{
	    	OnPlayerReadyToEnterTCP(playerid,tid);
 		return 1;
		}

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
					SetPlayerPosEx(playerid,vX+dX,vY+dY,vZ);
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
						PutPlayerInVehicleEx(playerid,NPC_Info[i][npc_VID],playerid);
						break;
					}
				}
			}
		}
	}
	MyCar_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	Speed_OnPlayerSC(playerid, newstate, oldstate);
	tuning_OnPlayerStateChange(playerid, newstate, oldstate);
	aspec_OnPlayerStateChange(playerid, newstate, oldstate);
	trade_OnPlayerSC(playerid, newstate, oldstate);
	Race_OnPlayerStateChange(playerid, newstate, oldstate);
//------check for bugged weapons
if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
    {
        new Weap[2];
        GetPlayerWeaponData(playerid, 4, Weap[0], Weap[1]); // Get the players SMG weapon in slot 4
        SetPlayerArmedWeapon(playerid, Weap[0]); // Set the player to driveby with SMG
    }
//------
return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	aspec_OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid);
	return 1;
}

public OnGameModeInit()
{
    SendRconCommand("hostname GTO Reunion - ГОНКИ | ДМ | ДАЛЬНОБОЙЩИКИ");
	new starttime = GetTickCount();
	new gamemode[MAX_NAME];
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
	print("		Gaysin Rishat (Rishat)");
	print(" ");
	print(" 	Translated to Russian by Dmitry Borisoff (Beginner)");
	print(" ");
	print("\n----------------------------------\n");

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
	
	TDS_GM_Init();
	
	LoggingInit();
	BaseLoadConfig();
	PlayerLoadConfig();
	PaydayLoadConfig();
	LoggingLoadConfig();
	WeaponLoadAll();
	VehicleLoadAll();
	
	RaceLoadAll();
	DeathmatchLoadAll();

    ZoneInfoLoadALL();
    
	WeaponBusinessLoadAll();
	HousesLoadAll();
	HotelsLoadAll();
	AmmunationInit();
	BankInit();
	GroundholdInit();
	HousesInit();
	HotelsInit();
	LanguageInit();
	AcsInit();
	UsePlayerPedAnims();
	AllowAdminTeleport(1);
	EnableStuntBonusForAll(0);
	DisableInteriorEnterExits();
	
	TPCInit();
	TradeInit();
	Banner_ModeInit();
	
	NPCInit();
	ArmDealers_OnGameModeInit();
	Business_OnGameModeInit();
	OnClothesInit();
	
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

	//  28
	#if defined _race_hj_included
	    race_hj_init();
	#endif
	
	//  29
	#if defined _derby_first_included
	    derby_first_init();
	#endif
	
	//  30
	#if defined _derby_two_included
	    derby_two_init();
	#endif

	//  31
	#if defined _derby_three_included
	    derby_three_init();
	#endif
	
	//  32
	#if defined _race_final_included
	    race_final_init();
	#endif

	//  33
	#if defined _race_people_included
	    race_people_init();
	#endif
	
	//  34
	#if defined _race_star_included
	    race_star_init();
	#endif

	// Deathmatches

	//  1
	#if defined _dm_azarnik5_included
		dm_azarnik5_init(); // ok
	#endif

	//  2
	#if defined _dm_area51_included
		dm_area51_init(); // ok
	#endif

	//  3
	#if defined _dm_badandugly_included
		dm_badandugly_init(); // ok
	#endif

	//  4
	#if defined _dm_bluemountains_included
		dm_bluemountains_init(); // ok
	#endif

	//  5
	#if defined _dm_cargoship_included
		dm_cargoship_init(); // ok
	#endif

	//  6
	#if defined _dm_dildo_included
		dm_dildo_init(); // ok
	#endif

	// 7
	#if defined _dm_baseball_included
	dm_baseball_init(); // ok
	#endif

	//  8
	#if defined _dm_minigunmadness_included
		dm_minigunmadness_init(); // ok
	#endif

	//  9
	#if defined _dm_poolday_included
		dm_poolday_init(); // ok
	#endif

	//  10
	#if defined _dm_usnavy_included
		dm_usnavy_init(); // ok
	#endif

	//  11
	#if defined _dm_azarnik_included
	dm_azarnik_init(); // ok
	#endif

	//  12
	#if defined _dm_kons_included
	dm_kons_init(); // ok
	#endif

	//  13
	#if defined _dm_azarnik1_included
	dm_azarnik1_init(); // ok
	#endif

	//  14
	#if defined _dm_azarnik3_included
	dm_azarnik3_init(); // ok
	#endif

	//  15
	#if defined _dm_rocketmania_included
	dm_rocketmania_init(); // ok
	#endif

	//  16
	#if defined _dm_paper_included
	dm_paper_init(); // ok
	#endif

	//  17
	#if defined _dm_building_area_included
	dm_building_area_init(); // ok
	#endif

	// 18
	#if defined _dm_arctic_included
	dm_arctic_init(); // ok
	#endif

	// 19
	#if defined _dm_newvegas_included
	dm_newvegas_init(); // ok
	#endif
	
	// 20
	#if defined _zombie_chinatown_included
	zombie_chinatown_init(); // ok
	#endif

	// 21 dillimore
	#if defined _zombie_dillimore_included
	zombie_dillimore_init(); // ok
	#endif
	
	// 22 elcorona
	#if defined _zombie_elcorona_included
	zombie_elcorona_init(); // ok
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
	SetTimer("PlayerArmourRegen", ARMOUR_REGEN_SPEED, 1);
	SetTimer("TextScroller",TEXT_SCROLL_SPEED,1);
	//SetTimer("WorldSave", WorldSaveDelay, 1);
	SetTimer("SyncTime", 60000, 1);      //ADDED CLOCK WORLD
	SetTimer("SyncCPAndPackages", 500, 1); // Разделение на 2 потока с периодом 2 секнды
//	SetTimer("SyncActiveCP", 2600, 1);
	SetTimer("CheckRace", RACE_UPD_TIME, 1);
	SetTimer("CheckDM", DM_UPD_TIME, 1);
	SetTimer("PayDay", PayDayDelay, 1);
	SetTimer("CheckAllGround", GROUNDHOLD_DELAY, 1);
	SetTimer("ZoneCheck", ZONE_CHECK_TIME, 1);
//	SetTimer("TurnAround", TurnAroundDelay, 1);
	SetTimer("HouseKeepUp",HOUSE_DELAY,1);

	SetTimer("Lottery",1200000,1);
	
	SetTimer("CheckGangs",1000,1);

	SetTimer("AFKSystem", 1000, 1);
	//SetTimer("CheckNPCs",NPC_CHECK_TIME,1);
	
	SetTimer("UpdateSpeed",SP_UPD_TIME,1);
	
	//SetTimer("CmdTimeCheck",1000,1);
	
	//SetTimer("TestBroot",180000,0);
	//SetTimer("GetZoneNameText",1000,1);
	
	//SetTimer("Admincheck", 1001, true);
	
	printf("SERVER: Lottery script init.");
	
	MapIcones();  //теперь все черес новый файл работает --- mapicons.inc
	MapIcons_OnGameModeInit();

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
	CreateGangZones();  //Создать зоны
//------------------------
   	new string[MAX_STRING];
    new hour,minute,second;
    gettime(hour,minute,second);
    if ( (hour <= 9) && (minute <= 9) ) {format(string,sizeof(string),"0%d:0%d",hour,minute);}
    if ( (hour <= 9) && (minute > 9) )  {format(string,sizeof(string),"0%d:%d",hour,minute);}
    if ( (hour > 9) && (minute <= 9) ) {format(string,sizeof(string),"%d:0%d",hour,minute);}
    if ( (hour > 9) && (minute > 9) )  {format(string,sizeof(string),"%d:%d",hour,minute);}
    
    skinlist = LoadModelSelectionMenu("skins.txt");

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

	public OnPlayerConnect(playerid)
	{

	if(strcomp(oGetPlayerName(playerid),"Server",true) == 1)
	{
	SendClientMessage(playerid, COLOUR_WHITE,lang_texts[1][60]);
	Kick(playerid);
	return 1;
	}
	
	if(IsPlayerNPC(playerid))
	{
    OnNPCJoinServer(playerid);
	return 1;
	}
		player_Connect(playerid);
		
		TDS_OnPlayerConnect(playerid);
		
		//Pack_OnPlayerConnect(playerid);
		Speed_OnPlayerConnect(playerid);
        trade_OnPlayerConnect(playerid);
		Acs_OnPlayerConnect(playerid);

		Zones_OnPlayerConnect(playerid);
		avtp_OnPlayerConnect(playerid);
		
		new string[MAX_STRING];
		ContactPlayer[playerid] = INVALID_PLAYER_ID;
		DeleteF4Bag[playerid] = true;

		SendClientMessage(playerid, COLOUR_WHITE, lang_texts[15][87]);
		SendClientMessage(playerid, COLOUR_WHITE, lang_texts[15][93]);
	 	format(string, sizeof(string),lang_texts[15][95],MAXUNREGTIME);
	 	SendClientMessage(playerid, COLOUR_WHITE, string);

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
		NewPlayer[playerid] = 0;
		}
		else
		{
		DialogPlayerToLogin(playerid);
		NewPlayer[playerid] = 1;
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

//-------------------------
// When a player disconnect
//-------------------------

    forward gto_OnPlayerDisconnect(playerid);
	public gto_OnPlayerDisconnect(playerid)
	{
	    //printf("playerid %d worked disconnect");
		if (playerid == INVALID_PLAYER_ID)
		{
			return;
		}
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
		train_OnPlayerDisconnect(playerid);
		TDS_OnPlayerDisconnect(playerid);
		DMPlayerDisconnect(playerid);
		ZONEPlayerDisconnect(playerid);
		RacePlayerDisconnect(playerid);
		player_Disconnect(playerid);
		Speed_OnPlayerDisconnect(playerid);
		oDisablePlayerRaceCheckpoint(playerid);
		Acs_OnPlayerDisconnect(playerid);
		//printf("playerid %d stop-worked disconnect");
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
//		OnPlayerEnterBusinessCheckpoint(playerid);
//		OnPlayerEnterHousesCheckpoint(playerid);
		//OnPlayerBusCheckpoint(playerid);
		OnPlayerEnterTPCheckpoint(playerid);
		OnPlayerEnterTradeCheckpoint(playerid);

	}
	
	public OnPlayerEnterRaceCheckpoint(playerid)
	{
		trade_OnPlayerEnterRaceCP(playerid);
	    race_OnPlayerEnterRaceCP(playerid);
	    Train2_OnPlayerEnterRaceCP(playerid);
	}
	
	public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid)
	{
		#pragma unused issuerid
    	#pragma unused amount
		if(weaponid == 34)
		{
			if(PlayerWeaponsSkill[issuerid][10] > 900 || IsPlayerInAnyDM(playerid))
			{
				SetPlayerHealth(playerid, 0);
			}
		}
  		if(issuerid == INVALID_PLAYER_ID) return 1;
		ContactPlayer[issuerid] = playerid;
		ContactPlayer[playerid] = issuerid;

    	PlayerPlaySound(issuerid,17803,0,0,0); // Звук при попадании
		return 1;
	}

    public OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart)
	{
	
		new dmid = GetPlayerDM(playerid);
 		if (PlayerQuest[playerid] == GetDMQuestID(dmid)) // if player is in this dm
  		{
    		if(DeathmatchStats[dmid][dm_state] == DM_STATE_ACTIVE && Deathmatch[dmid][dm_type] == 1)
    		{
    	    	if(DMPlayerStats[playerid][dm_player_role] == DM_ROLE_ZOMBIE)
    	    	{
          			if(damagedid != INVALID_PLAYER_ID)
    				{
						amount = 35;
						new Float:healthcalc;
						new Float:armcalc;
						armcalc = Player[damagedid][Armour];
						healthcalc = Player[damagedid][Health];
						//printf("Playerid %d give damage to %d",playerid,damagedid);
						//------------- Нанесение урона и убийство
						if (Player[damagedid][Armour] > amount) armcalc -= amount;
						else
						{//Если брони меньше, чем наносимый урон
							amount -= armcalc;
							healthcalc -= amount; armcalc = 0.0;
						}//Если брони меньше, чем наносимый урон
						
						SetPlayerArmour(damagedid, armcalc);
						if (healthcalc <= 1.0)
						{//Убийство игрока
							SetPlayerHealth(damagedid,0);//Чтобы не было бага с застыванием игрока (не срабатывает OnPlayerDeath)
						} else {
                            SetPlayerHealth(damagedid, healthcalc);
						}
						//Убийство игрока
    				}
				}
    		}
  		}
		return 1;
	}
//-------------------
// When a player dies
//-------------------

    public OnPlayerDeath(playerid, killerid, reason)    // loose xp, give money, deaths++
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
        
        if(reason != 255 && reason != 47 && reason != 51 && reason != 53 && reason != 54 && ContactPlayer[killerid] != playerid)
		{
    		//ContactPlayer[killerid] = INVALID_PLAYER_ID;
    		//ContactPlayer[playerid] = INVALID_PLAYER_ID;
    		//Kick(playerid);
    		KickPlayer(playerid,"Фейковое убийство (Чит?)");
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
        Acs_OnPlayerDeath(playerid, killerid, reason);
        train_OnPlayerDisconnect(playerid);

        //printf("OnPlayerDeath %d %d %d", playerid, killerid, reason);

        new indm = IsPlayerInAnyDM(playerid);
        new inzone = IsPlayerInAnyZONE(playerid);

        //printf("Check [ %d ][ %d ]", inzone, indm);

        if (!inzone && !indm)
        {
            //printf("PlayerDeath [ %d ][ %d ]", inzone, indm);
            PlayerDeath(playerid, killerid, reason);
        }

        if(indm)
        {
            //printf("OnPlayerDMDeath(%d,%d)",playerid, killerid);
            OnPlayerDMDeath(playerid,killerid);
        }

        if(inzone)
        {
            //printf("OnPlayerZONEDeath(%d,%d)",playerid,killerid);
            OnPlayerZONEDeath(playerid,killerid);
        }

        if (killerid == INVALID_PLAYER_ID)
        {
            return 1;
        }

        UpdateWeaponSkill(killerid,reason);

        if (!indm && !inzone)
        {
            PlayerKill(killerid, playerid, reason);
        }
		if(indm)
        {
            OnPlayerDMKill(killerid,playerid,reason);
        }
        if(inzone)
        {
            OnPlayerZONEKill(killerid,playerid,reason);
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
		if( !PlayerQuest[playerid] )
		{
			oSetPlayerVirtualWorld(playerid,0);
		}
	    TDS_OnPlayerSpawn(playerid);
		Speed_OnPlayerSpawn(playerid);
        train_OnPlayerSpawn(playerid);
        DeleteF4Bag[playerid] = false;
//----------Jail----------
		
		if (IsPlayerJailed(playerid,0) == 1)
		{
		    oSetPlayerHealth(playerid, 10);
			SetPlayerInterior(playerid,JailI);
			SetPlayerPos(playerid,JailX,JailY,JailZ);
			SetPlayerFacingAngle(playerid,JailA);
			SetPlayerWantedLevel(playerid, 6);
			SetPlayerArmour(playerid, 0);
			ResetPlayerMoney(playerid);
			ResetPlayerWeapons(playerid);
			PlayerPlaySound(playerid,1082,0.00,0.00,0.00);
			return 1;
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
// ACS
	Acs_OnPlayerSpawn(playerid);
		
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
		
		new raceid = GetPlayerRace(playerid);
		if(PlayerQuest[playerid] == GetRaceQuestID(raceid))
		{
			Race_OnPlayerSpawn(playerid);
		}
		
		/*new i=GetPVarInt(playerid,"RaceVehicle");
		if(i > 0 && MultiraceStat[i][member_stat] == 1 && GetPVarInt(playerid, "PlayerQuest") != 0 && RaceStats[GetPlayerRace(playerid)][race_state] != RACE_STATE_LINEUP)
		{
			new cpid=MultiraceStat[i][member_cpid];
			SetVehiclePos(i,MultiraceCP[playerid][cpid][member_x], MultiraceCP[playerid][cpid][member_y], MultiraceCP[playerid][cpid][member_z]);
			PutPlayerInVehicle(playerid,i,0);
			SetVehicleZAngle(i,MultiraceCP[playerid][cpid][member_vehang]);
			TogglePlayerControllable(playerid, 0);
			GameTextForPlayer(playerid, "~y~Ready!",500,4);
			SetTimerEx("player_race_spawn",500,0,"d",playerid);
			return 1;
		}*/
		
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
		if(!DeleteF4Bag[playerid])
    	{
    	    if(!IsPlayerInAnyDM(playerid))
			{
        		SetSpawnInfo(playerid, 255, Player[playerid][SkinModel], PlayerSpawn[playerid][Coord_X], PlayerSpawn[playerid][Coord_Y], PlayerSpawn[playerid][Coord_Z], 1.0, -1, -1, -1, -1, -1, -1);
        		SpawnPlayer(playerid);
			}
        	return true;
    	}
    	if(!IsPlayerRegistered(playerid) || NewPlayer[playerid] == 0) {
			SetupPlayerForClassSelection(playerid);
		} else if(!IsPlayerInAnyDM(playerid)) {
			SetSpawnInfo(playerid, 255, Player[playerid][SkinModel], PlayerSpawn[playerid][Coord_X], PlayerSpawn[playerid][Coord_Y], PlayerSpawn[playerid][Coord_Z], 1.0, -1, -1, -1, -1, -1, -1);
    		SpawnPlayer(playerid);
		}
		return 1;
	}

	public SetupPlayerForClassSelection(playerid)
	{
			SetPlayerInterior(playerid,1);
			SetPlayerPosEx(playerid,-2167.2000,642.2000,1057.5938);
			SetPlayerFacingAngle(playerid,85.0000);
			SetPlayerCameraPos(playerid,-2169.7000,642.7000,1057.5938);
			SetPlayerCameraLookAt(playerid,-2167.2000,642.7000,1057.5938);
	}

//--------------------
// Processing Commands
//--------------------

	public OnPlayerCommandText(playerid,cmdtext[])
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
		
		//if (strlen(cmdtext) > 140) return 1;//защита на отправку огромных сообщений при помощи стороннего софта
		
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
//		cmdfound += BusinessCommandHandler(playerid,cmdtext);
		cmdfound += Business_OnPlayerCommandText(playerid,cmdtext);
		cmdfound += HousesCommandHandler(playerid,cmdtext);
		cmdfound += CarsCommandHandler(playerid,cmdtext);
		cmdfound += Acs_OnPlayerCommandText(playerid,cmdtext);
		cmdfound += Anim_OnPlayerCommandText(playerid,cmdtext);
		cmdfound += ZonesCommandHandler(playerid,cmdtext);
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
		return SendClientMessage(playerid, COLOR_WHITE, "SERVER: Неизвестная команда. Используйте {FF0000}/commands {FFFFFF}чтобы отобразить список команд.");
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

if (text[0] == '.' || text[0] == '/') {text[0] = '/'; OnPlayerCommandText(playerid, text); return 0;}

if( CmdTimer[playerid][Time_Chat] >= gettime() && !IsPlayerAdmin(playerid))
{
	SendClientMessage(playerid, COLOUR_CRIMSON, "Запрещено писать в чат чаще чем 1 раз в секунду");
	return 0;
}

CmdTimer[playerid][Time_Chat] = gettime() + 1;

if(text[0] == '#' && text[1] == '#' && text[2] == '#') { // ###
if(Player[playerid][Jailed] == 0){SendClientMessage(playerid, COLOUR_CRIMSON, "Вы итак на свободе!"); return 0;}
if(Player[playerid][Jailed] == 1){SendClientMessage(playerid, COLOUR_CRIMSON, "Вы сидите бессрочно!"); return 0;}
IsPlayerJailed(playerid,1);
return 0;
}

if(Player[playerid][Muted] == 2) {SendClientMessage(playerid, COLOUR_CRIMSON, lang_texts[1][38]); return 0;}

PlayerAntiFlood(playerid,text);

if(text[0] == '!')
{
new gangmessage[MAX_STRING];
strmid(gangmessage,text,1,strlen(text));
if(!strlen(gangmessage)) return 1;
format(gangmessage, sizeof(gangmessage), "%s[id %d] [БАНДЕ]: %s", oGetPlayerName(playerid),playerid,gangmessage);
SendGangMessage(PlayerGangID[playerid],gangmessage,COLOUR_GANG_CHAT);
new logstring[256];
format(logstring, sizeof (logstring), "player: %d: g: %d: %s: <GANG CHAT>: %s",playerid,PlayerGangID[playerid],oGetPlayerName(playerid),text);
WriteChatLog(logstring);
return 0;
}
    new itext[300];strcat(itext,text);
	if(Player[playerid][Vip] >= 2)
	{//--- Разноцветный чат
		for(new i = 0; i < 300; i++)
		{//цикл
			if(strfind(itext, "#", true) == i)
			{//Если нашло "*" в тексте
			    if (strfind(itext, "1", true) == i + 1)
			    {// *1 - красный
					strdel(itext, i, i + 2);//удаляется код цвета
					strins(itext, "{FF0000}", i, 300);continue;
			    }// *1 - красный
			    if (strfind(itext, "2", true) == i + 1)
			    {// *2 - синий
					strdel(itext, i, i + 2);//удаляется код цвета
					strins(itext, "{3399FF}", i, 300);continue;
			    }// *2 - синий
			    if (strfind(itext, "3", true) == i + 1)
			    {// *3 - зеленый
					strdel(itext, i, i + 2);//удаляется код цвета
					strins(itext, "{00FF00}", i, 300);continue;
			    }// *3 - зеленый
			    if (strfind(itext, "4", true) == i + 1)
			    {// *4 - желтый
					strdel(itext, i, i + 2);//удаляется код цвета
					strins(itext, "{FFFF00}", i, 300);continue;
			    }// *4 - желтый
			    if (strfind(itext, "5", true) == i + 1)
			    {// *5 - киви
					strdel(itext, i, i + 2);//удаляется код цвета
					strins(itext, "{CCFF00}", i, 300);continue;
			    }// *5 - киви
			    if (strfind(itext, "6", true) == i + 1)
			    {// *6 - аква
					strdel(itext, i, i + 2);//удаляется код цвета
					strins(itext, "{24F7FE}", i, 300);continue;
			    }// *6 - аква
			    if (strfind(itext, "7", true) == i + 1)
			    {// *7 - розовый
					strdel(itext, i, i + 2);//удаляется код цвета
					strins(itext, "{F935F9}", i, 300);continue;
			    }// *7 - розовый
			    if (strfind(itext, "8", true) == i + 1)
			    {// *8 - квест
					strdel(itext, i, i + 2);//удаляется код цвета
					strins(itext, "{FFCC00}", i, 300);continue;
			    }// *8 - квест
			    if (strfind(itext, "9", true) == i + 1)
			    {// *9 - коричневый
					strdel(itext, i, i + 2);//удаляется код цвета
					strins(itext, "{976D3D}", i, 300);continue;
			    }// *9 - коричневый

				if (strfind(itext, "!", true) == i + 1 && strfind(itext, "1", true) == i + 2)
			    {// **1 - дм
					strdel(itext, i, i + 3);//удаляется код цвета
					strins(itext, "{FF8C00}", i, 300);continue;
			    }// **1 - дм, тдм
			    if (strfind(itext, "!", true) == i + 1 && strfind(itext, "2", true) == i + 2)
			    {// **2 - дерби
					strdel(itext, i, i + 3);//удаляется код цвета
					strins(itext, "{9966CC}", i, 300);continue;
			    }// **2 - дерби
			    if (strfind(itext, "!", true) == i + 1 && strfind(itext, "3", true) == i + 2)
			    {// **3 - зомби
					strdel(itext, i, i + 3);//удаляется код цвета
					strins(itext, "{E60020}", i, 300);continue;
			    }// **3 - зомби
			    if (strfind(itext, "!", true) == i + 1 && strfind(itext, "4", true) == i + 2)
			    {// **4 - гонка
					strdel(itext, i, i + 3);//удаляется код цвета
					strins(itext, "{007FFF}", i, 300);continue;
			    }// **4 - гонка
			    if (strfind(itext, "!", true) == i + 1 && strfind(itext, "5", true) == i + 2)
			    {// **5 - легендарная гонка
					strdel(itext, i, i + 3);//удаляется код цвета
					strins(itext, "{FFD700}", i, 300);continue;
			    }// **5 - легендарная гонка
			    if (strfind(itext, "!", true) == i + 1 && strfind(itext, "6", true) == i + 2)
			    {// **6 - гангейм
					strdel(itext, i, i + 3);//удаляется код цвета
					strins(itext, "{FF6666}", i, 300);continue;
			    }// **6 - гангейм

			    if (strfind(itext, "?", true) == i + 1 || strfind(itext, "&", true) == i + 1)
			    {// *? - случайный
					strdel(itext, i, i + 2);//удаляется код цвета
					new rand = random(14) + 1;
					if (rand == 1) strins(itext, "{FF0000}", i, 300);
					if (rand == 2) strins(itext, "{3399FF}", i, 300);
					if (rand == 3) strins(itext, "{00FF00}", i, 300);
					if (rand == 4) strins(itext, "{FFFF00}", i, 300);
					if (rand == 5) strins(itext, "{CCFF00}", i, 300);
					if (rand == 6) strins(itext, "{24F7FE}", i, 300);
					if (rand == 7) strins(itext, "{F935F9}", i, 300);
					if (rand == 8) strins(itext, "{FFCC00}", i, 300);
					if (rand == 9) strins(itext, "{976D3D}", i, 300);
					if (rand == 10) strins(itext, "{FFFFFF}", i, 300);
					if (rand == 11) strins(itext, "{FF8C00}", i, 300);
					if (rand == 12) strins(itext, "{9966CC}", i, 300);
					if (rand == 13) strins(itext, "{FF6666}", i, 300);
					if (rand == 14) strins(itext, "{007FFF}", i, 300);
					continue;
			    }// *? - случайный

				//Если не был введен ни один из кодов выше (просто * с текстом)
				strdel(itext, i, i + 1);//удаляется код цвета
				strins(itext, "{FFFFFF}", i, 300);//белый
			}//Если нашло "*" в тексте
		}//цикл
	}//--- Разноцветный чат

if(text[0] == '*')
{
	new clubmessage[MAX_STRING];
	strmid(clubmessage,text,1,strlen(text));
	if(strlen(clubmessage))
	{
		SilentMessage(playerid,clubmessage);
	}
return 0;
}

if(text[0] == '@' || text[0] == '"')
{
ModSpecialCommandHandler(playerid,text);
//AdminSpecialCommandHandler(playerid,text);
new logstring[256];
format(logstring, sizeof (logstring), "player: %d:  %s: <ADMIN TALK>:   %s",playerid,oGetPlayerName(playerid),text);
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

//new string[256];                                              //ID in CHAT <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
format(itext, sizeof(itext), "[id %d] %s", playerid, itext); //ID in CHAT <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
SendPlayerMessageToAll(playerid, itext);                     //ID in CHAT <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
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

// Убрать в COMMANDHUNDLER или в dialogs

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
new str[MAX_STRING];
format(str,sizeof(str),":: Игрок %s [id:%d] ::", oGetPlayerName(SelectedID[playerid]),SelectedID[playerid]);
ShowPlayerDialog(playerid, CGUI+13, DIALOG_STYLE_LIST, str, PlCMDlist, "OK", "Cancel");}
return 1;
}
return 0;
}

//-------------------
// Обновление погоды
//-------------------

public WeatherUpdate()
{
	if (sysweath==1)
	{
	new rand = random(19);
	SetWeather(rand);
	printf("SERVER: Weather set to %d",rand);
	}
}

new Switch = 0;

public SyncCPAndPackages()
{
	if(!Switch)
	{
	SyncActiveCP();
	Switch = 1;
	//print("Sync CP");
	}
	else
	{
		if(PackEnable)
		{
		UpdatePackSignal();
		//print("Sync Pack");
		}
	Switch = 0;
	}
return;
}

public OnPlayerUpdate(playerid)
{
    ac_OnPlayerUpdate(playerid);
    if(!IsPlayerNPC(playerid) && plafk[playerid] > -2)
    {
    	if(plafk[playerid] > 5)
   		{
           		new string[128];
            	format(string,sizeof(string)," Время вашего АФК: %s",ConvertSeconds(plafk[playerid]));
           		SendClientMessage(playerid, -1, string);
            	SetPlayerChatBubble(playerid, "АФК: завершено", COLOR_WHITE, 20.0, 1000);
		}

		plafk[playerid] = 0;
	}
	if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USEJETPACK)
	{
	    if(!IsPlayerMod(playerid) && !IsPlayerAdm(playerid) && !IsPlayerAdmin(playerid))
	    {
			KickPlayer(playerid,"обнаружен Джетпак (Чит?)");
		}
	}
	new dmid = GetPlayerDM(playerid);
 	if (PlayerQuest[playerid] == GetDMQuestID(dmid)) // if player is in this dm
  	{
    	if(DeathmatchStats[dmid][dm_state] == DM_STATE_ACTIVE && Deathmatch[dmid][dm_type] == 1)
    	{
    	    if(DMPlayerStats[playerid][dm_player_role] == DM_ROLE_HUMAN)
    	    {
	    	new Float:SPD, Float:vx, Float:vy, Float:vz; GetPlayerVelocity(playerid, vx,vy,vz);
			SPD = floatsqroot(((vx*vx)+(vy*vy))/*+(vz*vz)*/);
			if (SPD > 0.125 || GetPlayerAnimationIndex(playerid) == 1195 || GetPlayerAnimationIndex(playerid) == 1061 || GetPlayerAnimationIndex(playerid) == 1065 || GetPlayerAnimationIndex(playerid) == 1066)
			{//Бег, Прыжок, Повис на стене, залазит на стену, залазит на забор
		    	SecFreeze(playerid, 1); ApplyAnimation(playerid,"CRACK","crckdeth1",4.1,0,0,0,0,1,1);
	 			SendClientMessage(playerid, COLOR_RED, "Людям запрещено бегать и прыгать после появления зомби!");
			}
			}
    	}
  	}
  	
   // from here
    if (HealthUpdateDelay[playerid] > 0)
    {
        HealthUpdateDelay[playerid]--;
    }
    // to here
    
   	if(GetPlayerCameraMode(playerid) == 53)
	{//Anti Weapon Crasher
		new Float:pos[3];
		GetPlayerCameraPos(playerid,pos[0],pos[1],pos[2]);
		if( pos[0] < -7000.0 || pos[0] > 7000.0 || pos[1] < -7000.0 || pos[1] > 7000.0 || pos[2] < -7000.0 || pos[2] > 7000.0 )
		{
			KickPlayer(playerid,"Попытка вызова краша оружием (Чит?)");
		}
	}//Anti Weapon Crasher
	
	
    return 1;
}

stock DeleteBagF4(playerid)
{
    DeleteF4Bag[playerid] = true;
    ForceClassSelection(playerid);
}

public OnPlayerDisconnect(playerid) { gto_OnPlayerDisconnect(playerid); return 1; }

