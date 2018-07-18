//
// Created:     20.10.07
// Aurthor:    Artem Firstov
//

#if defined _race_majestic_included
  #endinput
#endif

#define _race_majestic_included
#pragma library race_majestic
#include "race"

static racename[MAX_NAME] = "Majestic"; // unique name of race
static racefrequency = 1	; // frequency that race runs
static lineupdelay = 100; // how long we wait for people before starting race, in seconds
static minracers = 1; // minimum number of racers required to start this race
static minlevel = 26; // minimum player level required to join this race
static cashprize = 2200; // cash earned for 1st position
static cashentry = 2200; // Cash required to enter (earned by winner)
static xpprize = 12000; // xp earned for 1st position
static xpbonus = 1000; // xp earned per player still in race
static maxracetime = 600; // time race runs for (seconds)
static allowedcars[2]; // cars allowed in this race.
static Float:startlineheading = 269.829498; // which way players face at startline
static Float:racecheckpoints[][CoordInfo] = {
{1713.795654,1453.996337,10.443293},
{1771.194702,1453.217407,12.699398},
{1834.060302,1453.390747,11.997037},
{1911.748535,1453.283691,10.351538},
{1985.298950,1453.169433,10.517702},
{1986.507568,1419.328369,8.789232},
{1971.504150,1392.675537,8.789037},
{1947.706542,1374.054687,8.788983},
{1947.491333,1315.041137,8.789066},
{1964.370483,1273.661743,10.351560},
{2026.302368,1273.352661,10.351551},
{2048.728271,1241.118041,10.351560},
{2048.842773,1136.922607,10.351579},
{2048.618896,1024.656616,10.351565},
{2026.728149,973.290527,10.228583},
{2007.412109,954.210937,10.347644},
{1989.558715,933.134582,10.351526},
{1914.064453,932.934082,10.427070},
{1867.061279,959.867248,10.351560},
{1867.321289,1052.293212,10.351563},
{1867.615844,1113.250610,10.351388},
{1838.975830,1133.132324,11.659555},
{1733.223999,1133.040283,10.352499},
{1700.690551,1133.127319,10.351531},
{1668.724365,1133.213134,10.351526},
{1647.386474,1162.657836,10.351566},
{1647.388793,1216.058837,10.351569},
{1667.930908,1273.269531,10.351517},
{1713.164916,1273.130615,10.441177},
{1731.824707,1298.289550,10.420238},
{1734.036254,1323.319335,10.274024},
{1729.839111,1354.078125,10.175735},
{1713.277099,1413.405273,10.175735},
{1714.779296,1453.975219,10.468860}
};

static RaceID; // this will hold the id this race is assigned at init

forward race_majestic_init();

public race_majestic_init() // unique named init function (must be ran on gamemode init)
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
