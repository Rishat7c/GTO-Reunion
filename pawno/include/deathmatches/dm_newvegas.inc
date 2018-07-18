//
// Creator: OFFREAL
// this vrsion of inc file work only with GTO Reunion RC6

#if defined _dm_newvegas_included
#endinput
#endif

#define _dm_newvegas_included
#pragma library dm_newvegas
#include "deathmatch"

static name[MAX_NAME] = "New Vegas"; // unique name of dm
static wvirtual = 37;
static frequency = 2; // frequency that dm runs
static lineupdelay = 180; // how long we wait for people before starting dm, in seconds
static minplayers = 4; // minimum number of dmrs required to start this dm
static minlevel = 36; // minimum player level required to join this dm
static cashprize = 10000; // cash earned for 1st position
static cashentry = 15000; // Cash required to enter (earned by winner)
static xpprize = 6500; // xp earned for 1st position
static xpbonus = 1500; // xp earned per player in dm
static xpkill = 0; // xp gained when killing someone in dm
static xpdeath = 0; // xp lost on death in dm
static maxtime = 180; // time dm runs for (seconds)
static maxdistance = 170; // max distance player can wander from dm before being kicked
static activedmjoin = 1; // can players join this dm while it is in progress
static team = 1;
static weapons[MAX_DMWEAPONS+1] = {16,31,34,38,0,...};
static Float:startcp[CoordInfo] = {1583.3845,1448.1193,10.8318}; // where startpoint is located
static Float:centrecp[CoordInfo] = {-714.9391,2046.5475,60.3906}; // central point
static Float:spawnpoints[][CoordInfo] = {
{-756.3458,2039.2737,77.8984},
{-780.4026,2094.3403,73.0297},
{-795.6130,2026.8630,60.3906},
{-821.7972,2031.7051,60.3828},
{-781.2045,2121.6707,60.3828}, // Team 0 spawns
 
{-650.9617,2125.5962,60.3828},
{-674.9377,2043.6429,77.8984},
{-652.0648,2100.3406,73.1487},
{-634.3600,2034.5077,60.3906},
{-603.7198,2039.9850,60.3828} // Team 1 spawns
// :::ВНИМАНИЕ:::
// Точек спавна в сумме должно быть ЧЕТНОЕ количество!!!
};

static dmid; // this will hold the id this dm is assigned at init

forward dm_newvegas_init();

public dm_newvegas_init() // unique named init function (must be ran on gamemode init)
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
	Deathmatch[dmid][dm_team] = team;
	set(Deathmatch[dmid][dm_weapons],weapons);
	DeathmatchStats[dmid][dm_timer] = MakeDMSleepTime(dmid);
	DeathmatchStats[dmid][dm_state] = DM_STATE_SLEEPING;
	
	DMStartCP[dmid][Coord_X] = startcp[Coord_X];
	DMStartCP[dmid][Coord_Y] = startcp[Coord_Y];
	DMStartCP[dmid][Coord_Z] = startcp[Coord_Z];
	
	DMCentreCP[dmid][Coord_X] = centrecp[Coord_X];
	DMCentreCP[dmid][Coord_Y] = centrecp[Coord_Y];
	DMCentreCP[dmid][Coord_Z] = centrecp[Coord_Z];
	
	DMSpawnsSize[dmid] = sizeof(spawnpoints);
	for (new spid=0;spid<sizeof(spawnpoints);spid++)
	{
		DMSpawnPoints[dmid][spid][Coord_X] = spawnpoints[spid][Coord_X];
		DMSpawnPoints[dmid][spid][Coord_Y] = spawnpoints[spid][Coord_Y];
		DMSpawnPoints[dmid][spid][Coord_Z] = spawnpoints[spid][Coord_Z];
	}

 	printf("Deathmatch: '%s' Loaded.",name);
 }
 	

