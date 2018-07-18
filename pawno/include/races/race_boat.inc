//
// Created:     29.01.2009
// Aurthor:    Linus
//

#if defined _race_boat_included
#endinput
#endif

#define _race_boat_included
#pragma library race_boat
#include "race"

static racename[MAX_NAME] = "Bon Voyage"; // назвение гонки
static racefrequency = 6; // частота по€влени€?
static lineupdelay = 220; // сколько ждать игрока после объ€влени€
static minracers = 1; // минимальное количество игроков дл€ начала
static minlevel = 33; // минимальный уровень игрока
static cashprize = 6000; // денежный приз
static cashentry = 10000; // плата за участие
static xpprize = 30000; // приз ’ѕ за 1 место
static xpbonus = 4500; // бонус за лучший результат
static maxracetime = 600; // time race runs for (seconds) не пон€л
static allowedcars[2]; // количество и типы тачек.  акие хочешь!
static Float:startlineheading = 180.0; // направление старта
static Float:racecheckpoints[][CoordInfo] = {
{-719.658813,1989.322265,-0.531893},
{-598.974853, 1624.583618, -0.477661},
{-520.023437, 1224.712036, -0.442763},
{-674.338073, 681.464599, -0.398131},
{-1171.359741, 761.139953, -0.416056},
{-1268.281127, 968.105590, -0.336463},
{-1506.509765, 1365.805786, 1.376602},
{-2117.636230, 1522.482910, -0.403676},
{-2503.633789, 1489.937744, -0.492397},
{-2749.324462, 1570.754394, -0.793335},
{-2745.892578, 1946.896362, -0.238541},
{-2614.951904, 2103.505371, -0.380235},
{-2170.389648, 2422.210937, -0.542044},
{-2114.126464, 2409.134765, -0.546791},
{-2085.303710, 2209.470214, -0.574738},
{-1879.616455, 1963.003540, -0.403903},
{-1712.637329, 1739.670532, -0.320724},
{-1370.881591, 1511.516235, -0.564060},
{-1265.844238, 971.228820, -0.481135},
{-1216.143920, 463.647888, -0.240799},
{-1552.468261, 16.717229, -0.435386},
{-1735.470947, -193.695541, -0.614539},
{-1753.612548, -549.378356, -0.562159},
{-1723.328857, -181.583114, -0.602301},
{-1033.635131, 506.043212, -0.549148},
{-414.968322, 355.558380, -0.363407},
{538.712097, 433.965179, -0.339695},
{1204.660888, 612.368408, -0.343531},
{1789.411499, 505.081726, -0.431903},
{2162.348388, 407.179199, -0.361984},
{2122.469482, 105.468406, -0.532458},
{2067.553466, -160.580505, -0.525561},
{1882.356811, -46.089786, -0.437079},
{1605.980590, -38.312671, -0.448947},
{1419.379760, -251.635818, -0.541962},
{1218.767822, -143.939788, -0.500252},
{777.635314, -171.115264, -0.435609},
{474.376770, -258.135192, -0.422969},
{274.596343, -374.851684, -0.416056},
{35.925128, -523.298950, -0.475708},
{-142.450225, -800.734497, -0.399414},
{52.945007, -926.462890, -0.482906},
{87.397689, -1166.744506, -0.536764},
{56.663726, -1290.449340, -0.440555},
{33.620506, -1337.468383, -0.531928},
{54.446365, -1532.259887, -0.313266},
{124.072006, -1966.243286, -0.574844},
{375.551361, -1995.643676, -0.474660},
{845.916625, -2036.966796, -0.402801},
{1009.879028, -2342.869873, -0.644096},
{1322.252075, -2775.281250, -0.604197},
{1943.929931, -2829.534912, -0.650400},
{2438.975097, -2757.174072, -0.908538},
{2692.394775, -2654.114501, 0.138850},
{2814.924072, -2393.615478, -0.721446},
{2780.822021, -2294.005859, -0.507309},
{2519.131347, -2299.510009, -0.444072},
{2358.305664, -2410.399414, -0.642915},
{2327.329345, -2674.265869, -0.193112}
};

static RaceID; // this will hold the id this race is assigned at init

forward race_boat_init();

public race_boat_init() // unique named init function (must be ran on gamemode init)
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

