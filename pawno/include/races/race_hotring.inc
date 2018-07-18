//
// Created:     09.06.08
// Aurthor:    Pirate Rat
//

#if defined _race_hotring_included
  #endinput
#endif

#define _race_hotring_included
#pragma library race_hotring
#include "race"

static racename[MAX_NAME] = "Stadium in the SanFierro"; // назвение гонки
static racefrequency = 5	; // частота появления?
static lineupdelay = 160; // сколько ждать игрока после объявления
static minracers = 1; // минимальное количество игроков для начала
static minlevel = 30; // минимальный уровень игрока
static cashprize = 7000; // денежный приз
static cashentry = 10000; // плата за участие
static xpprize = 30000; // приз ХП за 1 место
static xpbonus = 5000; // бонус за лучший результат
static maxracetime = 600; // time race runs for (seconds) не понял
static interior = 15;
static allowedcars[10]= {V_KART,V_HOTRING,V_HOTRINA,V_HOTRINB}; // количество и типы тачек. HOTRINGs
static Float:startlineheading = 81.7572; // направление старта
static Float:racecheckpoints[][CoordInfo] = {

{-1423.4976,914.9724,1039.6152},
{-1284.9048,1045.9474,1039.4590},
{-1367.9238,914.1528,1039.7932},
{-1423.4976,914.9724,1039.6152},
{-1284.9048,1045.9474,1039.4590},
{-1367.9238,914.1528,1039.7932},
{-1423.4976,914.9724,1039.6152},
{-1284.9048,1045.9474,1039.4590},
{-1367.9238,914.1528,1039.7932},
{-1423.4976,914.9724,1039.6152},
{-1284.9048,1045.9474,1039.4590},
{-1367.9238,914.1528,1039.7932},
{-1423.4976,914.9724,1039.6152},
{-1284.9048,1045.9474,1039.4590},
{-1367.9238,914.1528,1039.7932},
{-1423.4976,914.9724,1039.6152},
{-1284.9048,1045.9474,1039.4590},
{-1367.9238,914.1528,1039.7932},
{-1423.4976,914.9724,1039.6152},
{-1284.9048,1045.9474,1039.4590},
{-1367.9238,914.1528,1039.7932},
{-1423.4976,914.9724,1039.6152},
{-1284.9048,1045.9474,1039.4590},
{-1367.9238,914.1528,1039.7932},
{-1423.4976,914.9724,1039.6152},
{-1284.9048,1045.9474,1039.4590},
{-1367.9238,914.1528,1039.7932},
{-1423.4976,914.9724,1039.6152},
{-1284.9048,1045.9474,1039.4590},
{-1367.9238,914.1528,1039.7932},
{-1423.4976,914.9724,1039.6152},
{-1284.9048,1045.9474,1039.4590},
{-1367.9238,914.1528,1039.7932}
};

static RaceID; // this will hold the id this race is assigned at init

forward race_hotring_init();

public race_hotring_init() // unique named init function (must be ran on gamemode init)
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
