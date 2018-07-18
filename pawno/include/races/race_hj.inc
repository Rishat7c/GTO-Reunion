//
// Created:     10.03.11
// Aurthor:   Joker
//

#if defined _race_hj_included
  #endinput
#endif

#define _race_hj_included
#pragma library race_hj
#include "race"

static racename[MAX_NAME] = "High Jump"; // unique name of race
static racefrequency = 3; // frequency that race runs
static lineupdelay = 90; // how long we wait for people before starting race, in seconds
static minracers = 1; // minimum number of racers required to start this race
static minlevel = 30; // minimum player level required to join this race
static cashprize = 4000; // cash earned for 1st position
static cashentry = 4000; // Cash required to enter (earned by winner)
static xpprize = 12000; // xp earned for 1st position
static xpbonus = 1000; // xp earned per player still in race
static maxracetime = 600; // time race runs for (seconds)
static allowedcars[2]; // cars allowed in this race.
static Float:startlineheading = 171.5583; // which way players face at startline
static Float:racecheckpoints[][CoordInfo] = {

{-797.0007,2416.2126,156.5079},
{-810.3381,2326.5554,145.4073},
{-756.3254,2308.7942,131.9950}, 
{-693.3120,2361.6670,128.0168}, 
{-719.2429,2455.0110,123.3975}, 
{-617.4118,2410.6719,95.4191},
{-580.9360,2373.1892,79.8729}, 
{-495.4829,2315.2312,65.7483}, 
{-399.9543,2288.4207,39.8361}, 
{-371.2409,2357.6877,29.4800}, 
{-399.3017,2458.3508,42.0387}, 
{-347.4301,2514.8489,35.6415}, 
{-378.3655,2571.6409,40.3928}, 
{-425.8782,2717.0762,62.0004}, 
{-541.5869,2710.8787,65.8379}, 
{-622.8759,2628.3501,86.8479}, 
{-589.9372,2519.1777,76.5323}, 
{-509.4952,2437.5076,56.7168}, 
{-403.1051,2454.2930,42.4762}, 
{-378.2816,2370.9504,31.9465}, 
{-396.6228,2285.2903,39.7942}, 
{-579.8520,2371.9294,79.7979}, 
{-718.7789,2453.4299,123.6907}, 
{-692.6912,2374.1511,129.3023}, 
{-659.7793,2330.2422,138.3483}, 
{-661.5253,2306.2690,135.7590},
{-753.4219,2306.7976,131.4233}, 
{-865.7346,2309.2092,159.8234}, 
{-1073.2568,2294.2432,87.6500}

};

static RaceID; // this will hold the id this race is assigned at init

forward race_hj_init();

public race_hj_init() // unique named init function (must be ran on gamemode init)
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
