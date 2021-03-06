//
// Created:     09.06.08
// Aurthor:    Pirate Rat
//

#if defined _race_stadium1_included
  #endinput
#endif

#define _race_stadium1_included
#pragma library race_stadium1
#include "race"

static racename[MAX_NAME] = "Stadium in the Los Santos"; // �������� �����
static racefrequency = 5; // ������� ���������?
static lineupdelay = 120; // ������� ����� ������ ����� ����������
static minracers = 1; // ����������� ���������� ������� ��� ������
static minlevel = 19; // ����������� ������� ������
static cashprize = 6000; // �������� ����
static cashentry = 6000; // ����� �� �������
static xpprize = 7650; // ���� �� �� 1 �����
static xpbonus = 1200; // ����� �� ������ ���������
static maxracetime = 600; // time race runs for (seconds) �� �����
static interior = 7; // time race runs for (seconds) �� �����
static allowedcars[2]; // ���������� � ���� �����. ����� ������!
static Float:startlineheading = 318.0; // ����������� ������
static Float:racecheckpoints[][CoordInfo] = {

{-1382.3340,-141.2706,1051.2726},
{-1380.1658,-274.8464,1044.6736},
{-1469.6403,-278.8737,1050.5280},
{-1382.3340,-141.2706,1051.2726},
{-1380.1658,-274.8464,1044.6736},
{-1469.6403,-278.8737,1050.5280},
{-1382.3340,-141.2706,1051.2726},
{-1380.1658,-274.8464,1044.6736},
{-1469.6403,-278.8737,1050.5280},
{-1382.3340,-141.2706,1051.2726},
{-1380.1658,-274.8464,1044.6736},
{-1469.6403,-278.8737,1050.5280},
{-1382.3340,-141.2706,1051.2726},
{-1380.1658,-274.8464,1044.6736},
{-1469.6403,-278.8737,1050.5280}
};

static RaceID; // this will hold the id this race is assigned at init

forward race_stadium1_init();

public race_stadium1_init() // unique named init function (must be ran on gamemode init)
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
	Race[RaceID][race_interior] = interior;
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
