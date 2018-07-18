//
// Created:     12.08.17
// Aurthor:    	Rishat
//

#if defined _derby_two_included
  #endinput
#endif

#define _derby_two_included
#pragma library derby_two
#include "race"

static racename[MAX_NAME] = "Survivor"; // unique name of race
static racefrequency = 2; // frequency that race runs
static lineupdelay = 80; // how long we wait for people before starting race, in seconds
static minracers = 1; // minimum number of racers required to start this race
static minlevel = 20; // minimum player level required to join this race
static cashprize = 4000; // cash earned for 1st position
static cashentry = 2200; // Cash required to enter (earned by winner)
static xpprize = 5000; // xp earned for 1st position
static xpbonus = 500; // xp earned per player still in race
static maxracetime = 400; // time race runs for (seconds)
static allowedcars[2]; // cars allowed in this race.
static type = 4; // is derby
static derbyvehicle[MAX_VEH_DERBY+1] = {601,601,601,601,601,601,601,601,0};
static Float:derbyz = 990.0;
static interior = 0;
static Float:startlineheading = -90.32894; // which way players face at startline
static Float:racecheckpoints[][CoordInfo] = {
{3811.2156,-2453.5735,1002.5284},
{3828.2717,-2437.7588,1002.5284},
{3797.6394,-2471.6860,1002.5284},
{3778.0747,-2452.8750,1002.5284},
{3848.7319,-2453.9375,1002.5284},
{3828.6216,-2453.9402,1015.5284},
{3797.5637,-2453.8789,1015.5284},
{3855.7751,-2472.6580,1015.5284},
{3770.3140,-2436.6235,1015.5284},
{3811.2190,-2436.3999,1015.5284}
};

static RaceID; // this will hold the id this race is assigned at init

forward derby_two_init();

public derby_two_init() // unique named init function (must be ran on gamemode init)
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
