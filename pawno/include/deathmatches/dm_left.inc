//
// Aurthor:    Linus
//

#if defined _dm_left_included
  #endinput
#endif

#define _dm_left_included
#pragma library dm_left
#include "deathmatch"

static name[MAX_NAME] = "Left Behind"; // unique name of dm
static wvirtual = 33;
static interior = 10; //Интерьер ДМ в который ТП игрока
static frequency = 3; // frequency that dm runs
static lineupdelay = 180; // how long we wait for people before starting dm, in seconds
static minplayers = 2; // minimum number of dmrs required to start this dm
static minlevel = 25; // minimum player level required to join this dm
static cashprize = 10000; // cash earned for 1st position
static cashentry = 8000; // Cash required to enter (earned by winner)
static xpprize = 8000; // xp earned for 1st position
static xpbonus = 4000; // xp earned per player in dm
static xpkill = 4000; // xp gained when killing someone in dm
static xpdeath = 0; // xp lost on death in dm
static maxtime = 150; // time dm runs for (seconds)
static maxdistance = 150; // max distance player can wander from dm before being kicked out
static activedmjoin = 1; // can players join this dm while it is in progress
static weapons[MAX_DMWEAPONS+1] = {9,22,27,30,0,...};
static Float:startcp[CoordInfo] = {-710.097961,962.201965,11.981829}; // where startpoint is
static Float:centrecp[CoordInfo] = {-1055.207031,1062.529174,1341.358642}; // where central

static Float:spawnpoints[][CoordInfo] = {
{-1131.752563,1028.790283,1349.180175},
{-1132.261962,1078.915771,1353.440429},
{-1131.878173,1097.117187,1345.795654},
{-1070.071166,1090.634033,1343.302246},
{-1095.406250,1055.296508,1341.358642},
{-1065.441772,1021.111999,1343.139770},
{-1054.719970,1059.492675,1341.351562},
{-1040.027587,1095.712646,1343.134399},
{-1021.126892,1050.990234,1345.867431},
{-990.461059,1020.774291,1341.843750},
{-998.917114,1099.200195,1343.062377},
{-974.475830,1089.498168,1348.437500},
{-974.220458,1043.158569,1352.681884},
{-974.574951,1022.500427,1345.043579}
};

static dmid; // this will hold the id this dm is assigned at init

forward dm_left_init();

public dm_left_init() // unique named init function (must be ran on gamemode init)
{
	dmid = RegisterDM(name);
	if (dmid == INVALID_RACE_ID) return;

    Deathmatch[dmid][dm_virtual] = wvirtual;
	Deathmatch[dmid][dm_frequency] = frequency;
	Deathmatch[dmid][dm_interior] = interior;
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
 	

