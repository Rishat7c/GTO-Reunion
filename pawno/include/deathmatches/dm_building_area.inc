//
//

#if defined _dm_building_area_included
#endinput
#endif

#define _dm_building_area_included
#pragma library dm_building_area
#include "deathmatch"

static name[MAX_NAME] = "The building area"; // unique name of dm
static wvirtual = 27;
static frequency = 2; // frequency that dm runs
static lineupdelay = 120; // how long we wait for people before starting dm, in seconds
static minplayers = 2; // minimum number of dmrs required to start this dm
static minlevel = 25; // minimum player level required to join this dm
static cashprize = 7000; // cash earned for 1st position
static cashentry = 4000; // Cash required to enter (earned by winner)
static xpprize = 10000; // xp earned for 1st position
static xpbonus = 2400; // xp earned per player in dm
static xpkill = 1500; // xp gained when killing someone in dm
static xpdeath = 0; // xp lost on death in dm
static maxtime = 150; // time dm runs for (seconds)
static maxdistance = 250; // max distance player can wander from dm before being kicked
static activedmjoin = 1; // can players join this dm while it is in progress
static weapons[MAX_DMWEAPONS+1] = {24,29,31,0,...};
static Float:startcp[CoordInfo] = {2721.9155,854.3795,10.8984}; // where startpoint is located
static Float:centrecp[CoordInfo] = {2677.1575,813.9844,10.9467}; // central point
static Float:spawnpoints[][CoordInfo] = {
	{2667.2717,835.4937,13.7127},
	{2586.8560,797.5442,10.9545},
	{2581.6824,792.5731,5.3158},
	{2698.3110,908.4289,10.6683},
	{2694.5613,865.5081,10.3144},
	{2711.3643,781.1887,10.8754},
	{2691.8374,821.8204,24.4501},
	{2685.6255,836.1235,21.7658},
	{2713.9631,812.9665,19.0814}
	
};

static dmid; // this will hold the id this dm is assigned at init

forward dm_building_area_init();

public dm_building_area_init() // unique named init function (must be ran on gamemode init)
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
 	

