//
// Created: 31.10.08
// Aurthor: Linus
//

#if defined _dm_din_included
#endinput
#endif

#define _dm_din_included
#pragma library dm_din
#include "deathmatch"

static name[MAX_NAME] = "Death in Nondemons"; // unique name of dm
static wvirtual = 31;
static frequency = 2; // frequency that dm runs
static lineupdelay = 200; // how long we wait for people before starting dm, in seconds
static minplayers = 3; // minimum number of dmrs required to start this dm
static minlevel = 25; // minimum player level required to join this dm
static cashprize = 9000; // cash earned for 1st position
static cashentry = 7000; // Cash required to enter (earned by winner)
static xpprize = 30000; // xp earned for 1st position
static xpbonus = 10000; // xp earned per player in dm
static xpkill = 5000; // xp gained when killing someone in dm
static xpdeath = 0; // xp lost on death in dm
static maxtime = 150; // time dm runs for (seconds)
static maxdistance = 300; // max distance player can wander from dm before being kicked out
static activedmjoin = 1; // can players join this dm while it is in progress
static weapons[MAX_DMWEAPONS+1] = {27,5,24,32,16,41,0,...};
static Float:startcp[CoordInfo] = {-1806.374267,577.139526,35.166793}; // where startpoint is
static Float:centrecp[CoordInfo] = {-2313.469970,-1651.015014,483.703125}; // where central
static Float:spawnpoints[][CoordInfo] = {
{-2233.071289,-1736.994506,480.829284},
{-2233.071289,-1736.994506,480.829284},
{-2262.092529,-1687.917968,481.026855},
{-2330.996582,-1707.033325,484.245819},
{-2392.239257,-1677.743041,477.026153},
{-2301.769531,-1617.291992,483.848510},
{-2386.172607,-1587.398315,503.927062},
{-2432.739013,-1620.005493,526.867736}

};

static dmid; // this will hold the id this dm is assigned at init

forward dm_din_init();

public dm_din_init() // unique named init function (must be ran on gamemode init)
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
