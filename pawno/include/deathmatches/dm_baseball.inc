//
// Creator: OFFREAL
// this vrsion of inc file work only with GTO Reunion RC6

#if defined _dm_baseball_included
#endinput
#endif

#define _dm_baseball_included
#pragma library dm_baseball
#include "deathmatch"

static name[MAX_NAME] = "Baseball"; // unique name of dm
static wvirtual = 25;
static frequency = 1; // frequency that dm runs
static lineupdelay = 180; // how long we wait for people before starting dm, in seconds
static minplayers = 4; // minimum number of dmrs required to start this dm
static minlevel = 8; // minimum player level required to join this dm
static cashprize = 700; // cash earned for 1st position
static cashentry = 900; // Cash required to enter (earned by winner)
static xpprize = 500; // xp earned for 1st position
static xpbonus = 0; // xp earned per player in dm
static xpkill = 0; // xp gained when killing someone in dm
static xpdeath = 0; // xp lost on death in dm
static maxtime = 150; // time dm runs for (seconds)
static maxdistance = 120; // max distance player can wander from dm before being kicked
static activedmjoin = 1; // can players join this dm while it is in progress
static team = 1;
static weapons[MAX_DMWEAPONS+1] = {5,16,32,25,0,...};
static Float:startcp[CoordInfo] = {1480.2178,2251.6062,11.0291}; // where startpoint is located
static Float:centrecp[CoordInfo] = {1383.2251,2184.7988,11.0234}; // central point
static Float:spawnpoints[][CoordInfo] = {
{1369.9609,2195.6318,9.7578},
{1300.3524,2212.6267,12.0156},
{1330.1754,2212.6052,12.0156},
{1359.9695,2212.6755,12.0156},
{1349.6317,2219.9814,23.4782}, // Team 0 spawns
 
{1394.2748,2167.1213,9.7578},
{1410.9598,2124.2930,12.0156},
{1410.6887,2153.6765,12.0156},
{1411.3994,2182.5425,12.0156},
{1416.7693,2153.3757,23.4782} // Team 1 spawns
// :::ВНИМАНИЕ:::
// Точек спавна в сумме должно быть ЧЕТНОЕ количество!!!
};

static dmid; // this will hold the id this dm is assigned at init

forward dm_baseball_init();

public dm_baseball_init() // unique named init function (must be ran on gamemode init)
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
 	

