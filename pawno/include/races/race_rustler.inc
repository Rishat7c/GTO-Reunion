//
// Created:     6.6.08
// Aurthor:    Pirate Rat
//

#if defined _race_rustler_included
  #endinput
#endif

#define _race_rustler_included
#pragma library race_rustler
#include "race"

static racename[MAX_NAME] = "Rustler Big Race"; // имя гонки
static racefrequency = 5; // походу частота появления в игре
static lineupdelay = 150; // время ожидания игроков после обьявления об гонке
static minracers = 1; // минимальное количество игроков в гонке
static minlevel = 15; // минимальный уровень игрока для участия в гонке
static cashprize = 7000; // Количество призовых денег за первое место
static cashentry = 5000; // деньги за участие в гонке
static xpprize = 10000; // количество ХП за первое место
static xpbonus = 3000; // по ходу бонус ХП за рекорд
static maxracetime = 600; // time race runs for (seconds)
static type = 3; // is aero race
static allowedcars[2] = {V_RUSTLER}; // cars allowed in this race. Make sure array size is +1 to allow for null terminator
//static cpsize = 30000; // size of checkpoints
static Float:startlineheading = 90.0; // which way players face at startline
static Float:racecheckpoints[][CoordInfo] = {
{2132.0044,-2493.6792,13.7219}, //старт
{1436.3036,-2487.4075,60.0},  //сразу после полосы
{1617.2427,-1355.2837,155.0}, //меж небоскребов
{1670.4519,-882.7924,100.0},  //вылетели из города
{1629.8175,201.8990,100.0}, //развязка
{2064.7827,962.8427,70.0}, //влетели в следующий
{2057.7375,1357.6875,70.0},  //пирамида
{2112.3230,1814.1312,70.0}, //проспект далее
{2272.0293,2456.3943,70.0},  //вылетаем из города перенести!
{1789.7952,2588.3499,100.0}, //поворот
{938.5231,2221.6294,100.0},  // просто
{250.3277,1463.1989,100.0},  //завод
{-164.2301,1269.2491,100.0},  //просто
{-541.0798,1481.6132,100.0}, //до платины
{-841.7953,2104.6580,100.0},  //после платины
{-815.8447,2544.2737,130.0},  //каньен
{0.1365,2516.0627,30.0},  //посадка
{369.0218,2504.6777,17.5016}  //финиш

};


static RaceID; // this will hold the id this race is assigned at init

forward race_rustler_init();

public race_rustler_init() // unique named init function (must be ran on gamemode init)
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
 	

