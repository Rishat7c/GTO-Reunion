//
// Created: 17.01.2009
// Aurthor: Linus
//

#if defined _dm_paper_included
#endinput
#endif

#define _dm_paper_included
#pragma library dm_paper
#include "deathmatch"

static name[MAX_NAME] = "Paper Work"; // unique name of dm
static wvirtual = 38;
static interior = 3;//Интерьер ДМ в который ТП игрока
static frequency = 2; // frequency that dm runs
static lineupdelay = 120; // how long we wait for people before starting dm, in seconds
static minplayers = 2; // minimum number of dmrs required to start this dm
static minlevel = 33; // minimum player level required to join this dm
static cashprize = 13000; // cash earned for 1st position
static cashentry = 9000; // Cash required to enter (earned by winner)
static xpprize = 25000; // xp earned for 1st position
static xpbonus = 6000; // xp earned per player in dm
static xpkill = 3000; // xp gained when killing someone in dm
static xpdeath = 0; // xp lost on death in dm
static maxtime = 150; // time dm runs for (seconds)
static maxdistance = 300; // max distance player can wander from dm before being kicked out
static activedmjoin = 1; // can players join this dm while it is in progress
static weapons[MAX_DMWEAPONS+1] = {26,29,4,16,31,0,...};
static Float:startcp[CoordInfo] = {-2345.421386,149.549652,34.966327}; // where startpoint is
static Float:centrecp[CoordInfo] = {356.884063,173.625457,1008.381896}; // where central
static Float:spawnpoints[][CoordInfo] = {
{373.376251,184.830886,1008.879821},
{356.907379,207.587112,1008.382812},
{375.133270,190.609222,1014.187500},
{323.597290,187.932785,1014.187500},
{328.201690,153.587951,1014.187500},
{324.961059,164.137420,1014.179687},
{347.003753,162.231582,1014.187500},
{371.202301,172.901290,1019.984375},
{356.932952,193.204498,1019.984375},
{351.510833,163.007858,1019.991210},
{331.700469,173.965789,1019.984375},
{346.315460,162.090606,1025.796386}
};

static dmid; // this will hold the id this dm is assigned at init

forward dm_paper_init();

public dm_paper_init() // unique named init function (must be ran on gamemode init)
{
dmid = RegisterDM(name);
//new playerid=1;
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
