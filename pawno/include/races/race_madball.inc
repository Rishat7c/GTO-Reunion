//
// Created:     09.06.08
// Aurthor:    Pirate Rat
//

#if defined _race_madball_included
  #endinput
#endif

#define _race_madball_included
#pragma library race_madball
#include "race"

static racename[MAX_NAME] = "The Madball Run"; // назвение гонки
static racefrequency = 5	; // частота по€влени€?
static lineupdelay = 150; // сколько ждать игрока после объ€влени€
static minracers = 1; // минимальное количество игроков дл€ начала
static minlevel = 20; // минимальный уровень игрока
static cashprize = 3500; // денежный приз
static cashentry = 3500; // плата за участие
static xpprize = 10000; // приз ’ѕ за 1 место
static xpbonus = 1500; // бонус за лучший результат
static maxracetime = 600; // time race runs for (seconds) не пон€л
static allowedcars[2]; // количество и типы тачек.  акие хочешь!
static Float:startlineheading = 90.0; // направление старта
static Float:racecheckpoints[][CoordInfo] = {

{-1883.9456,1055.3279,45.0},
{-2101.3601,1055.2997,55.2868},
{-2597.6912,1120.8646,55.1840},
{-2688.8027,1599.5276,63.9844},
{-2710.0701,2226.6897,55.3772},
{-2764.8530,2509.7913,95.6847},
{-2290.5925,2675.8069,55.7033},
{-1990.7380,2617.6936,50.1219},
{-1768.6290,2715.7336,58.8309},
{-1497.5233,2730.4456,65.3333},
{-1333.7412,2645.1067,49.9203},
{-876.8337,2725.7366,45.5552},
{-383.9919,2694.8884,63.6552},
{114.9128,2713.0789,52.2922},
{434.6826,2670.6667,59.2241},
{845.9996,2635.8643,11.6407},
{1111.7821,2468.6553,10.3342},
{1724.7927,2420.9453,6.5056},
{1787.7543,1982.0431,4.6350},
{1787.2408,1413.9082,6.4399},
{1785.4160,783.1979,11.2977},
{1672.9128,358.3784,29.9203},
{1640.7651,-18.8326,36.3125},
{1704.8912,-624.1581,39.8006},
{1592.7124,-1424.6552,28.2908},
{1589.4771,-2090.0989,17.7387},
{1322.7368,-2389.6208,13.0799},
{1174.0439,-2411.0398,10.0915},
{1060.9493,-1854.1814,13.1033},
{556.1738,-1718.6232,12.7769},
{88.4845,-1530.4497,5.3222},
{-136.8721,-1324.3020,1.8020},
{-315.0753,-1754.0146,15.4864},
{-32.7600,-2650.8762,42.6892},
{-1042.2451,-2851.4653,67.4240},
{-1740.5765,-2604.9172,49.0479},
{-2428.2771,-2472.3047,36.2817},
{-2933.0742,-1383.2190,11.2797},
{-2778.7151,-478.8974,6.8981},
{-2062.7866,-349.7892,35.0088},
{-1887.9486,36.2626,37.9475},
{-1671.1329,530.4117,37.9471},
{-1071.9576,1162.5079,38.1525},
{-692.4133,674.2928,16.3396},
{96.3755,664.9338,5.3246},
{1134.2301,812.5544,10.3678},
{1588.4215,833.8577,6.4427},
{2046.9606,836.3490,6.4471}

};

static RaceID; // this will hold the id this race is assigned at init

forward race_madball_init();

public race_madball_init() // unique named init function (must be ran on gamemode init)
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
