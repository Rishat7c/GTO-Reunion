//
// Created:     10.08.08
// Aurthor:    Maxim Tsarkov (OFFREAL)
//

#if defined _race_roundsa_included
  #endinput
#endif

#define _race_roundsa_included
#pragma library race_roundsa
#include "race"

static racename[MAX_NAME] = "Around San Andreas"; // unique name of race
static racefrequency = 6; // frequency that race runs
static lineupdelay = 80; // how long we wait for people before starting race, in seconds
static minracers = 1; // minimum number of racers required to start this race
static minlevel = 30; // minimum player level required to join this race
static cashprize = 7500; // cash earned for 1st position
static cashentry = 5000; // Cash required to enter (earned by winner)
static xpprize = 15000; // xp earned for 1st position
static xpbonus = 20000; // xp earned per player still in race
static maxracetime = 600; // time race runs for (seconds)
static allowedcars[2]; // cars allowed in this race.
static Float:startlineheading = 5.7200; // which way players face at startline
static Float:racecheckpoints[][CoordInfo] = {


{1702.0000,-488.0000,33.6700},
{1681.0000,-351.0000,43.9800},
{1676.0000,-285.0000,44.4700},
{1619.0000,135.0000,36.3100},
{1789.0000,675.0000,16.7700},
{1807.0000,1441.0000,6.7300},
{1806.0000,1980.0000,4.9600},
{1818.0000,2444.0000,12.5500},
{1704.0000,2549.0000,10.5800},
{1405.0000,2470.0000,6.7300},
{1290.0000,2429.0000,6.7300},
{1206.0000,2221.0000,6.7400},
{1206.0000,1783.0000,6.7400},
{1206.0000,1185.0000,6.8100},
{1188.0000,954.0000,8.4900},
{954.0000,751.0000,10.6700},
{564.0000,690.0000,3.4400},
{311.0000,774.0000,6.1700},
{-38.0000,620.0000,11.3400},
{-478.0000,596.0000,16.9700},
{-753.0000,715.0000,18.1600},
{-835.0000,841.0000,26.1300},
{-856.0000,1049.0000,25.0400},
{-886.0000,1197.0000,31.9200},
{-885.0000,1287.0000,35.2500},
{-1029.0000,1276.0000,40.0800},
{-1204.0000,1043.0000,41.8300},
{-1733.0000,488.0000,38.5000},
{-1904.0000,-4.0000,38.2400},
{-1925.0000,-203.0000,38.1000},
{-2286.0000,-334.0000,39.8400},
{-2651.0000,-357.0000,12.3300},
{-2850.0000,-572.0000,7.0400},
{-2894.0000,-1037.0000,9.4900},
{-2931.0000,-1629.0000,12.7400},
{-2817.0000,-1989.0000,38.0700},
{-2560.0000,-2165.0000,30.0000},
{-2482.0000,-2427.0000,33.6300},
{-2290.0000,-2643.0000,59.4000},
{-2042.0000,-2662.0000,55.2400},
{-1799.0000,-2603.0000,53.2300},
{-1657.0000,-2726.0000,46.9400},
{-1431.0000,-2920.0000,46.9200},
{-1119.0000,-2864.0000,67.7200},
{-843.0000,-2844.0000,59.0900},
{-532.0000,-2793.0000,48.0300},
{-186.0000,-2873.0000,39.1900},
{0.0000,-2754.0000,40.5800},
{-195.0000,-2345.0000,29.0400},
{-289.0000,-1757.0000,15.1600},
{-36.0000,-1389.0000,11.2500},
{529.0000,-1141.0000,30.2600},

{611.0000,-1201.0000,18.1100},
{633.0000,-1344.0000,13.3900},
{634.0000,-1675.0000,15.2300}

//{621.0000,-1206.0000,18.1100}
//{648.0000,-1206.0000,18.1100}
//{700.0000,-1143.0000,16.1000}
//{761.0000,-1059.0000,24.3000}
//{872.0000,-1002.0000,34.4700}
//{1108.0000,-956.0000,42.5400}
//{1346.0000,-938.0000,34.9100}
//{1483.0000,-939.0000,36.5300}
//{1604.0000,-880.0000,54.1000}
//{1688.0000,-738.0000,50.8100}
//{1702.0000,-488.0000,33.6700}


};

static RaceID; // this will hold the id this race is assigned at init

forward race_roundsa_init();

public race_roundsa_init() // unique named init function (must be ran on gamemode init)
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

