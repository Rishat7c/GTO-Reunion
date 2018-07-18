//
// Created: 30.10.08
// Aurthor: Linus
//

#if defined _dm_newdm_included
#endinput
#endif

#define _dm_newdm_included
#pragma library dm_newdm
#include "deathmatch"

static name[MAX_NAME] = "Rezinya in observatory"; // unique name of dm
static wvirtual = 36;
static frequency = 2; // frequency that dm runs
static lineupdelay = 120; // how long we wait for people before starting dm, in seconds
static minplayers = 3; // minimum number of dmrs required to start this dm
static minlevel = 23; // minimum player level required to join this dm
static cashprize = 8000; // cash earned for 1st position
static cashentry = 5000; // Cash required to enter (earned by winner)
static xpprize = 20000; // xp earned for 1st position
static xpbonus = 5000; // xp earned per player in dm
static xpkill = 4000; // xp gained when killing someone in dm
static xpdeath = 0; // xp lost on death in dm
static maxtime = 150; // time dm runs for (seconds)
static maxdistance = 300; // max distance player can wander from dm before being kicked out
static activedmjoin = 1; // can players join this dm while it is in progress
static weapons[MAX_DMWEAPONS+1] = {37,42,31,6,12,0,...};
static Float:startcp[CoordInfo] = {1667.825073,986.128540,10.652094}; // where startpoint is
static Float:centrecp[CoordInfo] = {1116.141479,-2062.388427,74.429687}; // where central
static Float:spawnpoints[][CoordInfo] = {
{1117.685668,-2037.035156,78.750000},
{1116.759277,-2014.218383,74.429687},
{1124.239746,-2038.082275,69.884216},
{1180.323486,-2037.003295,69.007812},
{1208.024414,-2068.616455,69.007812},
{1208.179199,-2037.681640,69.007812},
{1208.474975,-2005.626464,69.000610}

};

static dmid; // this will hold the id this dm is assigned at init

forward dm_newdm_init();

public dm_newdm_init() // unique named init function (must be ran on gamemode init)
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
