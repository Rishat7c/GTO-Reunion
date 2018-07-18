
//
// Created:     13.October.2006
// Aurthor:    |Insane|
// Also Thanks to Iain for a little help about how to make it
// Thanks Again

#if defined _race_bike_included
  #endinput
#endif

#define _race_bike_included
#pragma library race_bike
#include "race"




static racename[MAX_NAME] = "The Mountain bike"; // unique name of race
static racefrequency = 6; // frequency that race runs
static lineupdelay = 190; // how long we wait for people before starting race, in seconds
static minracers = 1; // minimum number of racers required to start this race
static minlevel = 12; // minimum player level required to join this race
static cashprize = 3500; // cash earned for 1st position
static cashentry = 5000; // Cash required to enter (earned by winner)
static xpprize = 4500; // xp earned for 1st position
static xpbonus = 400; // xp earned per player still in race
static maxracetime = 600; // time race runs for (seconds)
static allowedcars[2]; // cars allowed in this race.
static Float:startlineheading = 240.0000; // which way players face at startline
static Float:racecheckpoints[][CoordInfo] = {


{-2473.1902,-1920.8802,301.0668},
{-2345.9058,-1940.9373,297.7739},
{-2235.4785,-1925.7998,243.4370},
{-2205.7283,-1914.5389,240.0054},
{-2169.5212,-1898.4142,234.3077},
{-2172.2698,-1844.0844,219.0257},
{-2166.6414,-1812.1812,215.8455},
{-2141.1453,-1784.8040,208.5307},
{-2103.8052,-1748.7152,195.3035},
{-2071.5588,-1656.3909,176.5631},
{-2084.8777,-1600.1068,164.9123},
{-2024.6440,-1566.9152,132.1850},
{-2049.9995,-1484.2240,117.8295},
{-2001.5077,-1484.8834,83.6507},
{-1993.4727,-1658.1907,84.2233},
{-2043.5502,-1804.0883,101.7975},
{-2100.5313,-1885.1450,110.1927},
{-2169.6687,-2047.5958,89.7863},
{-2378.6611,-2197.8713,32.9649}

};

static RaceID; // this will hold the id this race is assigned at init

forward race_bike_init();

public race_bike_init() // unique named init function (must be ran on gamemode init)
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

