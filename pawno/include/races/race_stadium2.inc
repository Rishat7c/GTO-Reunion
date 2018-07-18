//
// Created:     09.06.08
// Aurthor:    Pirate Rat
//

#if defined _race_stadium2_included
  #endinput
#endif

#define _race_stadium2_included
#pragma library race_stadium2
#include "race"

static racename[MAX_NAME] = "Stadium in the Las Venturas"; // назвение гонки
static racefrequency = 5; // частота по€влени€?
static lineupdelay = 150; // сколько ждать игрока после объ€влени€
static minracers = 1; // минимальное количество игроков дл€ начала
static minlevel = 30; // минимальный уровень игрока
static cashprize = 9000; // денежный приз
static cashentry = 16000; // плата за участие
static xpprize = 18000; // приз ’ѕ за 1 место
static xpbonus = 2000; // бонус за лучший результат
static maxracetime = 600; // time race runs for (seconds) не пон€л
static interior = 4;
static allowedcars[2]; // количество и типы тачек.  акие хочешь!
static Float:startlineheading = 148.0; // направление старта
static Float:racecheckpoints[][CoordInfo] = {

{-1440.3403,-672.3796,1053.3090},
{-1289.8596,-643.5181,1056.2778},
{-1388.3964,-664.1674,1056.6798},
{-1484.2152,-618.5288,1054.6608},
{-1440.3403,-672.3796,1053.3090},
{-1289.8596,-643.5181,1056.2778},
{-1388.3964,-664.1674,1056.6798},
{-1484.2152,-618.5288,1054.6608},
{-1440.3403,-672.3796,1053.3090},
{-1289.8596,-643.5181,1056.2778},
{-1388.3964,-664.1674,1056.6798},
{-1484.2152,-618.5288,1054.6608}
};

static RaceID; // this will hold the id this race is assigned at init

forward race_stadium2_init();

public race_stadium2_init() // unique named init function (must be ran on gamemode init)
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
