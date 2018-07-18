//
// Created: 01.04.08
// Aurthor: AzarKo
//Recreated: Linus (17.01.2009)
//

#if defined _dm_rocketmania_included
#endinput
#endif

#define _dm_rocketmania_included
#pragma library dm_rocketmania
#include "deathmatch"

static name[MAX_NAME] = "Rocketmania"; // unique name of dm
static wvirtual = 41;
static interior = 15;//Интерьер ДМ в который ТП игрока
static frequency = 1; // frequency that dm runs
static lineupdelay = 180; // how long we wait for people before starting dm, in seconds
static minplayers = 2; // minimum number of dmrs required to start this dm
static minlevel = 29; // minimum player level required to join this dm
static cashprize = 13000; // cash earned for 1st position
static cashentry = 9000; // Cash required to enter (earned by winner)
static xpprize = 20000; // xp earned for 1st position
static xpbonus = 4800; // xp earned per player in dm
static xpkill = 3000; // xp gained when killing someone in dm
static xpdeath = 0; // xp lost on death in dm
static maxtime = 200; // time dm runs for (seconds)
static maxdistance = 300; // max distance player can wander from dm before being kicked out
static activedmjoin = 1; // can players join this dm while it is in progress
static weapons[MAX_DMWEAPONS+1] = {41,35,34,3,0,...};
static Float:startcp[CoordInfo] = {-2759.989013,-294.346679,6.748950}; // where startpoint is
static Float:centrecp[CoordInfo] = {-1399.110473,999.330322,1024.161621}; // where central
static Float:spawnpoints[][CoordInfo] = {
{-1423.753051,936.676696,1036.501953},
{-1462.740234,935.864501,1036.595825},
{-1519.234252,1000.894348,1037.755126},
{-1453.020385,1051.866821,1038.479003},
{-1362.676025,1056.639892,1038.409667},
{-1285.978027,1017.343750,1037.627563},
{-1333.304687,941.784606,1036.446289},
{-1389.521240,971.498229,1024.202148},
{-1366.156616,1001.800537,1024.154296},
{-1445.869873,983.722045,1024.163818},
{-1426.757812,1012.823852,1024.443603}
};

static dmid; // this will hold the id this dm is assigned at init

forward dm_rocketmania_init();

public dm_rocketmania_init() // unique named init function (must be ran on gamemode init)
{
dmid = RegisterDM(name);
if (dmid == INVALID_RACE_ID) return;

Deathmatch[dmid][dm_virtual] = wvirtual;
Deathmatch[dmid][dm_interior] = interior;
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
