//
// Created:     11.08.17
// Aurthor:    	Rishat
//

#if defined _derby_first_included
  #endinput
#endif

#define _derby_first_included
#pragma library derby_first
#include "race"

static racename[MAX_NAME] = "First Blood"; // unique name of race
static racefrequency = 1	; // frequency that race runs
static lineupdelay = 80; // how long we wait for people before starting race, in seconds
static minracers = 1; // minimum number of racers required to start this race
static minlevel = 1; // minimum player level required to join this race
static cashprize = 4000; // cash earned for 1st position
static cashentry = 2200; // Cash required to enter (earned by winner)
static xpprize = 5000; // xp earned for 1st position
static xpbonus = 500; // xp earned per player still in race
static maxracetime = 600; // time race runs for (seconds)
static allowedcars[2]; // cars allowed in this race.
static type = 4; // is derby
static interior = 0;
static derbyvehicle[MAX_VEH_DERBY+1] = {504,504,504,504,504,504,504,504,0};
static Float:derbyz = 990.0;
static Float:startlineheading = -90.32894; // which way players face at startline
static Float:racecheckpoints[][CoordInfo] = {
{2580.9543,-2922.2375,1003.8871},
{2580.9543,-2922.2375,1003.8871},
{2580.9353,-3040.3372,1003.8871},
{2620.9497,-2980.4980,1003.8871},
{2662.5625,-2922.4089,1003.8871},
{2682.1228,-2959.8835,1003.8871},
{2663.1399,-2999.8201,1003.8871},
{2581.3845,-2962.0913,1003.8871},
{2606.0146,-2995.0747,1003.8871},
{2601.6973,-2941.1292,1003.8871},
{2581.7783,-2959.8501,1003.8871}
};

static RaceID; // this will hold the id this race is assigned at init

forward derby_first_init();

public derby_first_init() // unique named init function (must be ran on gamemode init)
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
	Race[RaceID][race_startheading] = startlineheading;
	Race[RaceID][derby_z] = derbyz;
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
