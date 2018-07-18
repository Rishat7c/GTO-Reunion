//
// Created:     22.08.2017
// Aurthor:    Rishat
//

#if defined _race_star_included
  #endinput
#endif

#define _race_star_included
#pragma library race_star
#include "race"

static racename[MAX_NAME] = "Star Trek"; // unique name of race
static racefrequency = 2; // frequency that race runs
static lineupdelay = 90; // how long we wait for people before starting race, in seconds
static minracers = 1; // minimum number of racers required to start this race
static minlevel = 30; // minimum player level required to join this race
static cashprize = 40000; // cash earned for 1st position
static cashentry = 4000; // Cash required to enter (earned by winner)
static xpprize = 80000; // xp earned for 1st position
static xpbonus = 1000; // xp earned per player still in race
static maxracetime = 16000; // time race runs for (seconds)
static allowedcars[2]; // cars allowed in this race.
static Float:startlineheading = 1.7; // which way players face at startline
static Float:racecheckpoints[][CoordInfo] = {
{-1018.2562,-674.0697,31.5663,0},
{-1043.6704,-462.0767,35.1871,0},
{-683.5824,-413.3069,17.8061,0},
{-401.4871,-550.1605,15.8567,0},
{-354.1663,-777.6428,29.5043,0},
{-476.1305,-985.7745,24.6929,0},
{-365.2750,-1111.8777,69.1009,0},
{-156.3374,-1016.9965,0.5690,0},
{-105.8632,-1122.0724,1.1901,0},
{-110.5290,-1482.5537,2.2539,0},
{159.9215,-1548.8062,10.6766,0},
{597.9396,-1226.4449,17.4565,0},
{844.1827,-1021.1176,27.0342,0},
{1107.1068,-952.8668,42.1277,0},
{1406.9954,-942.1693,34.8030,0},
{1617.2617,-1182.5245,54.1841,0},
{1595.4225,-1686.6744,27.9321,0},
{1562.7607,-2105.8123,15.6073,0},
{1259.8926,-2232.1082,16.4316,0},
{1638.7465,-2195.8064,12.9337,0},
{1800.3040,-2339.8020,13.0440,0},
{1439.2501,-2377.3896,14.4732,0},
{1278.6882,-2311.3467,13.5014,0},
{1332.9642,-2560.7258,12.9336,0},
{1761.5205,-2670.6890,5.4502,0},
{2167.4280,-2497.5229,12.9336,0},
{2668.3979,-2168.9390,10.4883,0},
{2918.9302,-1338.3804,10.4336,0},
{2891.6704,-929.8490,10.4337,0},
{2885.4915,-760.1519,10.4002,0},
{2783.5227,-442.3693,21.3823,0},
{2751.5330,-24.8834,33.3126,0},
{2530.4739,42.3266,25.8945,0},
{2385.8066,90.1560,25.9501,0},
{2127.2205,95.6132,35.2418,0},
{1816.5930,191.4737,29.5664,0},
{1548.0388,256.4319,15.2410,0},
{1201.4690,292.0367,18.9648,0},
{1023.0296,476.2187,19.4414,0},
{625.9476,309.3806,19.4496,0},
{410.3444,627.5622,17.6000,0},
{543.7870,680.6725,2.8955,0},
{1184.0717,824.2786,9.1028,0},
{1610.0005,855.2900,6.2930,0},
{2046.6443,852.5013,6.2889,0},
{2056.9995,1191.9459,10.2362,0},
{2323.9336,1283.4036,97.3505,0}

};

static RaceID; // this will hold the id this race is assigned at init

forward race_star_init();

public race_star_init() // unique named init function (must be ran on gamemode init)
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
