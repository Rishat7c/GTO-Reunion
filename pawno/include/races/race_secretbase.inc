//
// Created:     20.10.07
// Aurthor:    Artem Firstov
//

#if defined _race_secretbase_included
  #endinput
#endif

#define _race_secretbase_included
#pragma library race_secretbase
#include "race"

static racename[MAX_NAME] = "Verdant Meadows Race"; // unique name of race
static racefrequency = 5; // frequency that race runs
static lineupdelay = 90; // how long we wait for people before starting race, in seconds
static minracers = 1; // minimum number of racers required to start this race
static minlevel = 20; // minimum player level required to join this race
static cashprize = 5500; // cash earned for 1st position
static cashentry = 4200; // Cash required to enter (earned by winner)
static xpprize = 8800; // xp earned for 1st position
static xpbonus = 1100; // xp earned per player still in race
static maxracetime = 600; // time race runs for (seconds)
static allowedcars[2]; // cars allowed in this race.
static Float:startlineheading = 89.285385; // which way players face at startline
static Float:racecheckpoints[][CoordInfo] = {
{425.491668,2523.084716,16.353261},
{374.208648,2524.339599,16.433485},
{307.783843,2525.660888,16.647294},
{218.106414,2523.569335,16.613094},
{143.367874,2523.153564,16.579490},
{61.024055,2522.886474,16.348552},
{-14.547893,2521.784179,16.350416},
{-58.822566,2506.597412,16.356212},
{-31.255336,2481.836914,16.352500},
{52.948150,2483.258300,16.352598},
{126.204917,2484.122558,16.360406},
{216.948974,2484.377685,16.348899},
{305.175872,2485.245361,16.348529},
{366.046386,2484.128417,16.350784},
{405.513763,2483.294921,16.348560},
{428.203765,2490.144531,16.350765},
{428.273101,2520.880859,16.349927}
};

static RaceID; // this will hold the id this race is assigned at init

forward race_secretbase_init();

public race_secretbase_init() // unique named init function (must be ran on gamemode init)
{
	RaceID = RegisterRace(racename);
	if (RaceID == INVALID_RACE_ID) return;

	Race[RaceID][race_frequency] = racefrequency;
 	Race[RaceID][race_lineupdelay] = lineupdelay;
 	Race[RaceID][race_minracers] = minracers;
 	Race[RaceID][race_minlevel] = minlevel;
 	Race[RaceID][race_cashprize] = cashprize;
	Race[RaceID][race_cashentry] = cashentry;
	Race[RaceID][race_xpprize] = xpprize;
	Race[RaceID][race_xpbonus] = xpbonus;
	Race[RaceID][race_maxracetime] = maxracetime;
	Race[RaceID][race_startheading] = startlineheading;
	set(Race[RaceID][race_vehicles],allowedcars);

	RaceSize[RaceID] = sizeof(racecheckpoints);
	for (new cpid=0;cpid<sizeof(racecheckpoints);cpid++)
	{
		RaceCheckpoints[RaceID][cpid][Coord_X] = racecheckpoints[cpid][Coord_X];
		RaceCheckpoints[RaceID][cpid][Coord_Y] = racecheckpoints[cpid][Coord_Y];
		RaceCheckpoints[RaceID][cpid][Coord_Z] = racecheckpoints[cpid][Coord_Z];
	}

	RaceStats[RaceID][race_timer] = MakeRaceSleepTime(RaceID);
    RaceStats[RaceID][race_state] = RACE_STATE_SLEEPING;
  	printf("Race: '%s' Loaded.",racename);
 }
