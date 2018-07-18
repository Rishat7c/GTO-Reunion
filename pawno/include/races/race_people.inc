//
// Created:     22.08.2017
// Aurthor:    Rishat
//

#if defined _race_people_included
  #endinput
#endif

#define _race_people_included
#pragma library race_people
#include "race"

static racename[MAX_NAME] = "Village people"; // unique name of race
static racefrequency = 4; // frequency that race runs
static lineupdelay = 100; // how long we wait for people before starting race, in seconds
static minracers = 1; // minimum number of racers required to start this race
static minlevel = 12; // minimum player level required to join this race
static cashprize = 3500; // cash earned for 1st position
static cashentry = 5000; // Cash required to enter (earned by winner)
static xpprize = 4500; // xp earned for 1st position
static xpbonus = 400; // xp earned per player still in race
static maxracetime = 1600; // time race runs for (seconds)
static allowedcars[2]; // cars allowed in this race.
static Float:startlineheading = 270.0000; // which way players face at startline
static Float:racecheckpoints[][CoordInfo] = {
{-1101.110717,-1621.676757,76.146598},
{-1019.663085,-1684.626220,77.352287},
{-981.643554,-1719.179809,77.358123},
{-896.545776,-1723.998413,76.984664},
{-857.648803,-1831.104125,91.232360},
{-974.647949,-1914.394897,80.159080},
{-1096.284667,-2136.951660,37.233524},
{-1164.404541,-2300.412353,36.831405},
{-1167.528320,-2355.850585,20.232606},
{-1042.972778,-2374.256835,52.778667},
{-986.756713,-2373.054443,67.964294},
{-907.040344,-2380.564453,52.688674},
{-803.628295,-2464.930908,76.921455},
{-860.123535,-2541.164306,88.837944},
{-695.103820,-2578.647216,61.105350},
{-648.414733,-2465.058349,33.174533},
{-574.954101,-2369.017578,28.151956},
{-509.596435,-2289.408447,33.386405},
{-444.690795,-2256.347167,46.694515},
{-338.699890,-2255.406738,40.163661},
{-330.828155,-2183.552734,28.191711},
{-315.184967,-1752.309570,15.478464},
{-192.329498,-1524.886840,14.628529},
{-47.058044,-1412.036865,11.394664},
{-152.319854,-1351.778930,2.433804},
{-72.069458,-1129.889892,0.857014}
};

static RaceID; // this will hold the id this race is assigned at init

forward race_people_init();

public race_people_init() // unique named init function (must be ran on gamemode init)
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

