//
// Created:     09.06.08
// Aurthor:    Pirate Rat
//

#if defined _race_dune_included
  #endinput
#endif

#define _race_dune_included
#pragma library race_dune
#include "race"

static racename[MAX_NAME] = "Race DUNE"; // назвение гонки
static racefrequency = 6; // частота по€влени€?
static lineupdelay = 150; // сколько ждать игрока после объ€влени€
static minracers = 1; // минимальное количество игроков дл€ начала
static minlevel = 35; // минимальный уровень игрока
static cashprize = 6000; // денежный приз
static cashentry = 16000; // плата за участие
static xpprize = 35000; // приз ’ѕ за 1 место
static xpbonus = 5000; // бонус за лучший результат
static maxracetime = 200; // time race runs for (seconds) не пон€л
static allowedcars[2]; // количество и типы тачек.  акие хочешь!
static Float:startlineheading = 120.0; // направление старта
static Float:racecheckpoints[][CoordInfo] = {

{410.7634,2374.9324,25.2928},
{-78.2188,2359.0103,18.6190},
{-172.8600,2247.9717,29.1783},
{-282.2460,2223.1545,57.6246},
{-328.8777,2131.4106,47.3200},
{-245.3449,2070.3254,27.0532},
{-209.6668,1907.6387,39.7851},
{-182.7785,1849.7827,48.4802},
{-68.8296,1796.1927,17.1413},
{-33.9166,2243.5923,38.7075},
{-96.8719,2596.9692,20.7435},
{-81.9830,2832.2244,75.8404},
{285.0941,2776.4265,34.2650},
{341.5270,2621.7532,16.3520},
{479.4420,2377.1960,29.1070}
};

static RaceID; // this will hold the id this race is assigned at init

forward race_dune_init();

public race_dune_init() // unique named init function (must be ran on gamemode init)
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
