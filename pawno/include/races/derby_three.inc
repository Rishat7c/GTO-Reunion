//
// Created:     17.08.17
// Aurthor:    	Rishat
//

#if defined _derby_three_included
  #endinput
#endif

#define _derby_three_included
#pragma library derby_three
#include "race"

static racename[MAX_NAME] = "Madness in the head"; // unique name of race
static racefrequency = 3; // frequency that race runs
static lineupdelay = 100; // how long we wait for people before starting race, in seconds
static minracers = 1; // minimum number of racers required to start this race
static minlevel = 10; // minimum player level required to join this race
static cashprize = 4000; // cash earned for 1st position
static cashentry = 2200; // Cash required to enter (earned by winner)
static xpprize = 5000; // xp earned for 1st position
static xpbonus = 500; // xp earned per player still in race
static maxracetime = 550; // time race runs for (seconds)
static allowedcars[2]; // cars allowed in this race.
static type = 4; // is derby
static interior = 0;
static derbyvehicle[MAX_VEH_DERBY+1] = {515,531,555,571,572,573,583,585,0};
static Float:derbyz = 5.1;
static Float:startlineheading = 0.0; // which way players face at startline
static Float:racecheckpoints[][CoordInfo] = {
{366.7737,5263.7915,9.8007},
{365.3026,5403.0044,9.8008},
{404.3041,5353.6426,25.5734},
{319.0525,5338.9546,9.8007},
{365.7390,5314.7412,9.8007},
{423.7690,5316.6392,9.8007},
{443.8740,5279.3545,25.5734},
{318.6070,5281.0645,25.4615},
{318.7276,5345.7500,25.5149},
{325.0059,5407.3843,25.5734},
{379.0459,5407.7544,25.5731},
{464.5328,5408.0771,25.5734},
{471.2692,5364.0977,25.5734},
{438.8683,5353.7236,25.5734},
{470.1731,5290.8760,25.5734},
{457.0915,5279.9307,25.5734}
};

static RaceID; // this will hold the id this race is assigned at init

forward derby_three_init();

public derby_three_init() // unique named init function (must be ran on gamemode init)
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
	Race[RaceID][race_type] = type;
	Race[RaceID][race_interior] = interior;
	Race[RaceID][derby_z] = derbyz;
	Race[RaceID][race_startheading] = startlineheading;
	set(Race[RaceID][race_vehicles],allowedcars);

	RaceSize[RaceID] = sizeof(racecheckpoints);
	for (new cpid=0;cpid<sizeof(racecheckpoints);cpid++)
	{
		RaceCheckpoints[RaceID][cpid][Coord_X] = racecheckpoints[cpid][Coord_X];
		RaceCheckpoints[RaceID][cpid][Coord_Y] = racecheckpoints[cpid][Coord_Y];
		RaceCheckpoints[RaceID][cpid][Coord_Z] = racecheckpoints[cpid][Coord_Z];
	}
	
	//set(Race[RaceID][race_derby_veh],derbyvehicle);
	for(new i; i<MAX_VEH_DERBY;i++)
	{
		if(i < strlen(derbyvehicle))
		{
			Race[RaceID][race_derby_veh][i] = derbyvehicle[i];
		}
		else
		{
			Race[RaceID][race_derby_veh][i] = 0;
		}
	}

	RaceStats[RaceID][race_timer] = MakeRaceSleepTime(RaceID);
    RaceStats[RaceID][race_state] = RACE_STATE_SLEEPING;
  	printf("Derby: '%s' Loaded.",racename);
 }
