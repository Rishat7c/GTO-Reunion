//
// Created:     30.08.17
// Aurthor:    Rishat
//

#if defined _zombie_chinatown_included
  #endinput
#endif

#define _zombie_chinatown_included
#pragma library zombie_chinatown
#include "deathmatch"

static name[MAX_NAME] = "Chinatown"; // unique name of dm
static wvirtual = 28;
static frequency = 1; // frequency that dm runs
static lineupdelay = 120; // how long we wait for people before starting dm, in seconds
static minplayers = 3; // minimum number of dmrs required to start this dm
static minlevel = 20; // minimum player level required to join this dm
static cashprize = 6500; // cash earned for 1st position
static cashentry = 5000; // Cash required to enter (earned by winner)
static xpprize = 3800; // xp earned for 1st position
static xpbonus = 900; // xp earned per player in dm
static xpkill = 700; // xp gained when killing someone in dm
static xpdeath = 0; // xp lost on death in dm
static maxtime = 180; // time dm runs for (seconds)
static maxdistance = 200; // max distance player can wander from dm before being kicked
static activedmjoin = 0; //an players join this dm while it is in progress
static type = 1;
static weapons[MAX_DMWEAPONS+1] = {27,25,33,23,29,30,24,31,28,25}; //
static Float:startcp[CoordInfo] = {2358.66, 533.56, 1.38}; // where startpoint is located
static Float:centrecp[CoordInfo] = {-2472.95, 1547.36, 33.23}; // central point
static Float:zombiezone[InfoZY] = {-2274.10,578.30,-2078.60,744.10};
static Float:spawnpoints[][CoordInfo] = {
{-2182.3276,640.6168,49.4375},
{-2188.1738,640.7931,49.4375},
{-2192.2498,640.3058,49.4429},
{-2196.7261,640.1528,49.4429},
{-2201.1062,640.0963,49.4429},
{-2181.7683,610.2219,35.1641},
{-2188.7712,612.3321,35.1641},
{-2189.6882,605.4775,35.1641},
{-2199.7422,609.3682,35.1641},
{-2207.8767,604.9662,35.1641}
};

static dmid; // this will hold the id this dm is assigned at init

forward zombie_chinatown_init();

public zombie_chinatown_init() // unique named init function (must be ran on gamemode init)
{
	dmid = RegisterDM(name);
	if (dmid == INVALID_RACE_ID) return;

	Deathmatch[dmid][dm_virtual] = wvirtual;
	Deathmatch[dmid][dm_frequency] = frequency;
 	Deathmatch[dmid][dm_lineupdelay] = lineupdelay;
 	Deathmatch[dmid][dm_minplayers] = minplayers;
 	Deathmatch[dmid][dm_minlevel] = minlevel;
 	Deathmatch[dmid][dm_cashprize] = cashprize;
	Deathmatch[dmid][dm_cashentry] = cashentry;
	Deathmatch[dmid][dm_xpprize] = xpprize;
	Deathmatch[dmid][dm_xpbonus] = xpbonus;
	Deathmatch[dmid][dm_xpkill] = xpkill;
	Deathmatch[dmid][dm_xpdeath] = xpdeath;
	Deathmatch[dmid][dm_maxtime] = maxtime;
	Deathmatch[dmid][dm_distance] = maxdistance;
	Deathmatch[dmid][dm_activedmjoin] = activedmjoin;
	Deathmatch[dmid][dm_type] = type;
	set(Deathmatch[dmid][dm_weapons],weapons);
	DeathmatchStats[dmid][dm_timer] = MakeDMSleepTime(dmid);
	DeathmatchStats[dmid][dm_state] = DM_STATE_SLEEPING;
	
	DMStartCP[dmid][Coord_X] = startcp[Coord_X];
	DMStartCP[dmid][Coord_Y] = startcp[Coord_Y];
	DMStartCP[dmid][Coord_Z] = startcp[Coord_Z];
	
	DMCentreCP[dmid][Coord_X] = centrecp[Coord_X];
	DMCentreCP[dmid][Coord_Y] = centrecp[Coord_Y];
	DMCentreCP[dmid][Coord_Z] = centrecp[Coord_Z];
	
	DMZone[dmid][Coord_X] = zombiezone[Coord_X];
	DMZone[dmid][Coord_Y] = zombiezone[Coord_Y];
	DMZone[dmid][Coord_Xx] = zombiezone[Coord_Xx];
	DMZone[dmid][Coord_Yy] = zombiezone[Coord_Yy];
	
	DMSpawnsSize[dmid] = sizeof(spawnpoints);
	for (new spid=0;spid<sizeof(spawnpoints);spid++)
	{
		DMSpawnPoints[dmid][spid][Coord_X] = spawnpoints[spid][Coord_X];
		DMSpawnPoints[dmid][spid][Coord_Y] = spawnpoints[spid][Coord_Y];
		DMSpawnPoints[dmid][spid][Coord_Z] = spawnpoints[spid][Coord_Z];
	}

 	printf("Zombie: '%s' Loaded.",name);
 }
 	

