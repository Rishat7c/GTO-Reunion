//
// Created:     6.6.08
// Aurthor:    Pirate Rat
//

#if defined _race_helislalom_included
  #endinput
#endif

#define _race_helislalom_included
#pragma library race_helislalom
#include "race"

static racename[MAX_NAME] = "Helicopter Slalom"; // им€ гонки
static racefrequency = 5; // походу частота по€влени€ в игре
static lineupdelay = 150; // врем€ ожидани€ игроков после обь€влени€ об гонке
static minracers = 1; // минимальное количество игроков в гонке
static minlevel = 15; // минимальный уровень игрока дл€ участи€ в гонке
static cashprize = 2500; //  оличество призовых денег за первое место
static cashentry = 5000; // деньги за участие в гонке
static xpprize = 7000; // количество ’ѕ за первое место
static xpbonus = 1000; // по ходу бонус ’ѕ за рекорд
static maxracetime = 600; // time race runs for (seconds)
static type = 3; // is aero race
static allowedcars[2]; // cars allowed in this race. Make sure array size is +1 to allow for null terminator
//static cpsize = 30000; // size of checkpoints
static Float:startlineheading = 90.0; // which way players face at startline
static Float:racecheckpoints[][CoordInfo] = {
{ 289.2637,2502.8608,17.0623 }, // start
//{ 287.4988,2782.8943,38.1318 }, // point
{ 279.3000,2748.6365,46.0042 }, // point
{ 245.3375,2941.7766,23.5556 }, // point
{ -19.2119,2927.7646,92.9824 }, // point
{ -106.4847,2640.3042,49.3562 }, // point
{ -153.3853,2299.6724,48.0084 }, // point
{ -241.5933,2226.4641,74.8047 }, // point
{ -407.5623,2133.2002,80.7691 }, // point
{ -542.5746,2084.6316,61.5132 }, // point
{ -669.6181,2126.3203,49.4519 }, // point
{ -801.0036,2112.6162,46.3239 }, // point
{ -864.1395,1842.8152,71.2770 }, // point
{ -981.8756,1844.4115,71.0958 }, // point
{ -890.9327,1656.7112,6.9933 }, // point
{ -677.3433,1667.6775,17.3093 }, // point
{ -563.2822,1208.7599,17.2842 }, // point
{ -690.4001,644.0820,2.5580 }, // point
{ -987.3687,950.3972,19.2412 }, // point
{ -1263.4778,969.9101,83.1018 }, // point
{ -1524.1876,698.3262,80.8556 }, // point
{ -1753.5607,604.6621,79.4814 }, // point
{ -2004.0114,675.6176,67.8738 }, // point
{ -2004.2882,815.0383,66.0809 }, // point
{ -2003.4866,1039.3341,66.2369 }, // point
{ -2262.7002,1178.8463,87.4186 }, // point
{ -2386.2502,945.8859,63.4572 }, // point
{ -2363.6355,488.7325,43.7459 }, // point
{ -2259.9739,272.0784,45.9105 }, // point
{ -2253.8635,-97.4525,44.9201 }, // point
{ -2253.6731,-337.4883,56.9747 }, // point
{ -2131.2144,-522.4076,60.0951 }, // point
{ -1725.9872,-577.1710,16.5143 }, // point
{ -1224.7466,-13.3255,14.1599 } // finish

};


static RaceID; // this will hold the id this race is assigned at init

forward race_helislalom_init();

public race_helislalom_init() // unique named init function (must be ran on gamemode init)
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
 	

