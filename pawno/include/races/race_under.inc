//
// Created:     01.10.08
// Aurthor:   OFFREAL
//

#define _race_under_included
#pragma library race_under
#include "race"

static racename[MAX_NAME] = "Underground"; // назвение гонки
static racefrequency = 5; // частота по€влени€?
static lineupdelay = 150; // сколько ждать игрока после объ€влени€
static minracers = 1; // минимальное количество игроков дл€ начала
static minlevel = 10; // минимальный уровень игрока
static cashprize = 2500; // денежный приз
static cashentry = 1500; // плата за участие
static xpprize = 2700; // приз ’ѕ за 1 место
static xpbonus = 1100; // бонус за лучший результат
static maxracetime = 300; // time race runs for (seconds) не пон€л
static allowedcars[2]; // количество и типы тачек.  акие хочешь!
static Float:startlineheading = 45.00; // направление старта
static Float:racecheckpoints[][CoordInfo] = {

{2396.048828,-2290.309570,5.742175},
{2309.126708,-2201.041503,5.745595},
{2126.860351,-2015.667480,7.664055},
{2009.534545,-1896.297485,7.664023},
{1954.037841,-1846.896606,3.715974},
{1848.397338,-1813.656494,3.664026},
{1681.962768,-1773.983276,3.650605},
{1576.681884,-1755.345581,3.906136},
{1459.582397,-1727.560180,6.539024},
{1389.014648,-1716.253295,8.205871},
{1358.231933,-1694.538330,8.289525},
{1361.893798,-1600.843627,8.290163},
{1379.174926,-1531.844238,8.351554},
{1390.320068,-1524.866088,10.892899},
{1386.745361,-1586.407958,13.042722},
{1531.579833,-1592.116821,13.066344},
{1617.069946,-1599.741455,13.226552},
{1617.575927,-1670.592529,12.306112},
{1630.071655,-1759.112548,3.636845},
{1718.288818,-1791.196166,3.670922},
{1906.051635,-1835.411987,3.670862},
{2033.928955,-1852.498046,3.664079},
{2185.185791,-1852.533813,2.612895},
{2391.375244,-1851.878540,1.250587},
{2550.543457,-1856.988891,3.443010},
{2566.570312,-1943.913208,3.537914},
{2567.460449,-2040.214721,3.539054},
{2583.069580,-2084.768798,2.474154},
{2601.515869,-2048.071044,3.539055},
{2602.993652,-1888.625488,3.539063},
{2598.243896,-1713.210327,1.320308},
{2603.936767,-1549.822631,10.823963},
{2626.047851,-1494.529052,16.042474},
{2804.004394,-1419.414550,15.929657}

};

static RaceID; // this will hold the id this race is assigned at init

forward race_under_init();

public race_under_init() // unique named init function (must be ran on gamemode init)
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
