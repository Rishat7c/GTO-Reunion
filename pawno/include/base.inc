//
// Created:     05.09.06
// Aurthor:    	Iain Gilbert
// ReCreated:   Artem Firstov
/*
Last ReCreated by Maxim Tsarkov (OFFREAL)
- - - - -
Добавлено несколько новых цветов
Увеличено число уровней до 40
Увеличен максимальный опыт на последнем уровне до 50кк
*/
#if defined _base_included
  #endinput
#endif

#define _base_included
#pragma library base

#include <a_samp>
#include <core>
#include <float>
#include "utils\dini"

#define VERSION "DM RACE MISSION"

#define debug 0

#define MAX_STRING 255
#define MAX_NAME 40 // number of char's a name/password/misc_word can be
#define INACTIVE_PLAYER_ID 255
#define INVALID_QUEST_ID 0
#define INVALID_GANG_ID -1
#define MAX_QUESTS 255
#define MAX_WIN 100000 // Maximum gambling win
#define MAX_SPAWNPOINTS 50
#define MAX_COUNTDOWN 5
//------TimeConst---------------
#define SEC_SEC 1
#define MIN_SEC 60
#define HOU_SEC 3600
#define DAY_SEC 86400
#define YEA_SEC 31536000 // no visokos
//-- добавил для дальнобойщика Пират
#define TDLMARKERS 3 // количество маркеров покупки керосина переработки нефти
#define DALNSZMARKERS 1 // количество маркеров продажи нефти
#define DALNAZSMARKERS 16 // количество бензоколонок

//-----GUIs-------------------------------
#define AGUI 1 //reserved id-s from 1 to 9 (register-login system)
#define WGUI 10 //reserved id-s from 10 to 29 (ammo)
#define CGUI 30 //reserved id-s from 30 to 49 (PDA & rules & tuning & dalnoboi)
#define BGUI 50 //reserved id-s from 50 to 59 (bank)
#define HGUI 60 //reserved id-s from 60 to 64 (housing)
#define GGUI 65 //reserved id-s from 65 to 69 (gang)
#define QGUI 71 //reserved id-s from 71 to 71 (sql)
#define GUIZERO 80 //empty dialog 80 to 80
#define S_GUI_02 90	// пустой диалог, нет разморозки 90
#define S_GUI_01 91	// пустой диалог, разморока 91
#define COMMANDS_INFO_DIALOG 101 // reserved id-s from 1-9 (/commands)
#define TGUI 120	// reserved id-s from 120 to 129
#define EGUI 130	// reserved id-s from 120 to 129
#define A_GUI 140   // reserved id-s from 140 to 149
#define R_GUI 150   // reserved id-s from 150 to 159
#define MCGUI 160   // reserved id-s from 160 to 169
#define EV_GUI 170  // reserved id-s from 170 to 179
#define HOTEL_MENU_DIALOG 180 // reserved id-s from 180 to 189
//----------------------------------------

#define INFINITY (Float:0x7F800000)
#define SetPlayerServerWorldBounds(%1) SetPlayerWorldBounds(%1,INFINITY, -INFINITY, INFINITY, -INFINITY)

#define TimerTick 1000 // used for how often timer function is called

#define PM_INCOMING_COLOR     0xFFFF22FF
#define PM_OUTGOING_COLOR     0xFFCC22FF
#define ADMINFS_MESSAGE_COLOR 0xFF4444FF

#define COLOUR_RED 0xAA3333FF
#define COLOUR_GREEN 0x33AA33FF
#define COLOUR_MAROON 0x800000FF
#define COLOUR_GREY 0xAFAFAFFF
#define COLOUR_LIGHTGREEN 0x9ACD32FF
#define COLOUR_LIGHTRED 0xFF6347FF
#define COLOUR_YELLOW 0xFFFF00FF
#define COLOUR_WHITE 0xFFFFFFFF
#define COLOUR_BLUE 0x33AAFFFF
#define COLOUR_LIGHTBLUE 0x33CCFFFF
#define COLOUR_ORANGE 0xFF9900FF
#define COLOUR_PURPLE 0xC2A2DAFF
#define COLOUR_LIME 0x00FF00FF
#define COLOUR_CRIMSON 0xDC143CFF

#define COLOR_SYSTEM 0xEFEFF7FF
#define COLOR_VIOLET 0x9955DEFF
#define COLOR_LIGHTRED 0xFF99AAFF
#define COLOR_SEAGREEN 0x00EEADFF
#define COLOR_GRAYWHITE 0xEEEEFFFF
#define COLOR_LIGHTNEUTRALBLUE 0xabcdefFF
#define COLOR_GREENISHGOLD 0xDEAD43FF
#define COLOR_LIGHTBLUEGREEN 0x0FFDD3FF
#define COLOR_NEUTRALBLUE 0xABCDEFFF
#define COLOR_LIGHTCYAN 0xAAFFCCFF
#define COLOR_LEMON 0xDDDD23FF
#define COLOR_MEDIUMBLUE 0x63AFF0FF
#define COLOR_NEUTRAL 0xABCDEFFF
#define COLOR_BLACK 0x000000FF
#define COLOR_NEUTRALGREEN 0x81CFABFF
#define COLOR_DARKGREEN 0x12900BFF
#define COLOR_LIGHTGREEN 0x24FF0AFF
#define COLOR_DARKBLUE 0x300FFAFF
#define COLOR_BLUEGREEN 0x46BBAAFF
#define COLOR_PINK 0xFF66FFFF
#define COLOR_BLUE 0x0000BBFF
#define COLOR_LIGHTBLUE 0x33CCFFFF
#define COLOR_DARKRED 0x660000FF
#define COLOR_ORANGE 0xFF9900FF
#define COLOR_GREY 0xAFAFAFFF
#define COLOR_GREEN 0x33AA33FF
#define COLOR_RED 0xAA3333FF
#define COLOR_YELLOW 0xFFFF00FF
#define COLOR_PURPLE 0x800080FF
#define COLOR_CYAN  	0x40FFFFFF
#define COLOR_WHITE 0xFFFFFFFF
#define COLOR_NSEA 0x3e6fd1FF
#define COLOR_WGREEN 0x85c726FF
#define COLOR_RORANGE 0xff4200FF
#define COLOR_YRED 0xffb400FF
#define COLOR_LGREEN 0xb3ff8aFF
#define COLOR_SKY 0x33b9ffFF

#define COLOUR_MULTI_RACE 0x9F85FAAA //

// TODO: more colours
#define COLOUR_MISC 0xAFAFAFFF // Grey - Misc
#define COLOUR_CHAT 0xFFFFFFFF // White - Chat
#define COLOUR_PLAYER 0xAAAAAAFF // White - Player
#define COLOUR_XP_GOOD 0x33CCFFFF // LightBlue - XP
#define COLOUR_XP_BAD 0xFF6347FF // LightRed - XP
#define COLOUR_COMBAT_GOOD 0xAA3333FF // Red - Combat
#define COLOUR_COMBAT_BAD 0xBB3333FF // Red - Combat
#define COLOUR_MONEY_GOOD 0xFFFF00FF // Yellow - Money
#define COLOUR_MONEY_BAD 0xFFFF00FF // Yellow - Money

#define COLOUR_RACE 0x005407FF // green - dark
#define COLOUR_RACE_BAD 0x545407FF // yellow-green-dark

#define COLOUR_ARACE 0x0080FFFF
#define COLOUR_ARACE_BAD 0x004080FF

#define COLOUR_GANG 0xFF8C00FF // orange
#define COLOUR_GANG_CHAT 0xFFA500FF // orange

#define COLOUR_DM 0xFF2F37FF // red
#define COLOUR_DM_BAD 0xB62F37FF // dred

#define COLOUR_TDM 0xFF42D2FF // red
#define COLOUR_TDM_BAD 0xB52F95FF // dred

// ACS Colour
#define ACS_COLOR_MSG 0xFFFF00AA

// --- NEW Gang Colour System ---
#define G_COLOR_GANGHL		0x8EBC8EFF

#define G_COLOR_WHITE		0xFFFFFFFF
#define G_COLOR_RED			0xAA3333FF
#define G_COLOR_LIGHTRED	0xFF6347FF
#define G_COLOR_CRIMSON		0xDC143CFF
#define G_COLOR_HALFLIFE	0xEFB85AFF

#define G_COLOR_ORANGE		0xFF9900FF
#define G_COLOR_AQUA		0x00FFFFFF
#define G_COLOR_KHAKI		0x999900FF
#define G_COLOR_ALIEN		0x90FF87FF
#define G_COLOR_LIME		0x00FF00FF

#define G_COLOR_LIGHTGREEN	0x9ACD32FF
#define G_COLOR_DARKGREEN	0x12900BFF
#define G_COLOR_BLUE		0x33AAFFFF
#define G_COLOR_BIOS		0x0000FFFF
#define G_COLOR_DARKAQUA	0x008080FF

#define G_COLOR_MAGENTA		0xFF00FFFF
#define G_COLOR_GOLD		0xB8860BFF
#define G_COLOR_VIOLET		0x9955DEFF
#define G_COLOR_PINK		0xFFC0CBFF
#define G_COLOR_PURPLE		0xC2A2DAFF

#define G_COLOR_YELLOW		0xFFFF00FF
#define G_COLOR_ROSYBROWN	0xBC8F8FFF
#define G_COLOR_NSEA		0x3e6fd1FF
#define G_COLOR_DARKRED		0x8B0000FF
#define G_COLOR_HOTPINK		0xFF69B4FF

#define G_COLOR_CORAL		0xFF7F50FF
#define G_COLOR_GREENYELL	0xADFF2FFF
#define G_COLOR_DSLATEGRAY	0x2F4F4FFF
#define G_COLOR_SBROWN		0x8B4513FF
#define G_COLOR_MNIGHTBLUE	0x191970FF
//----------------------------
/*
#define COLOUR_GREY 0xAFAFAFFF // grey
#define COLOUR_GREEN 0x33AA33FF // green
#define COLOUR_RED 0xAA3333FF // red
#define COLOUR_WHITE 0xFFFFFFFF // white
#define COLOUR_LIGHTBLUE 0x33CCFFFF // LightBlu
#define COLOUR_FLBLUE 0x6495EDFF
#define COLOUR_BISQUE 0xFFE4C4FF
#define COLOUR_BLACK 0x000000FF
#define COLOUR_BROWN 0XA52A2AFF
#define COLOUR_CORAL 0xFF7F50FF
#define COLOUR_GREENYELLOW 0xADFF2FFF
#define COLOUR_INDIGO 0x4B00B0FF
#define COLOUR_IVORY 0xFFFF82FF
#define COLOUR_LAWNGREEN 0x7CFC00FF
#define COLOUR_SEAGREEN 0x20B2AAFF
#define COLOUR_LIMEGREEN 0x32CD32FF
#define COLOUR_MIDNIGHTBLUE 0X191970FF
#define COLOUR_MAROON 0x800000FF
#define COLOUR_OLIVE 0x808000FF
#define COLOUR_ORANGERED 0xFF4500FF
#define COLOUR_SPRINGGREEN 0x00FF7FFF
#define COLOUR_TOMATO 0xFF6347FF
#define COLOUR_YELLOWGREEN 0x9ACD32FF
#define COLOUR_MEDIUMAQUA 0x83BFBFFF
#define COLOUR_MEDIUMMAGENTA 0x8B008BF
*/
// ------------------------------

#define MAX_LVLXP 10000000
//#define MAX_XP MAX_LVLXP

#define MAX_RXP 5000
#define RXPTOVIP 250

#define MAX_LEVEL 40
#define MIN_HEALTH 50
#define MIN_ARMOUR 50
#define MAX_HEALTH 100
#define NUMVALUES 4	

#define MAX_BANK 40000000

#define WEAPONS_SKILLS 11
#define MAX_SKILL 999
#define KILL_SKILL 5

#define MAXUNREGTIME 45		// Time to kick unregistered players after connect
#define MAX_PING 300

#define SOUND_MUSIC_CLASSSELECT      	1185
#define SOUND_MUSIC_RACEFINISH       	1183
#define SOUND_MUSIC_RACERECORD       	1097
#define SOUND_MUSIC_MISSIONCOMPLETE  	1185
#define SOUND_OFF                    	1184
#define SOUND_BLIP1                  	1056
#define SOUND_BLIP2                  	1057
#define SOUND_EXPLOSION              	1159
#define SOUND_PURCHASE               	1149
#define SOUND_CHECKPOINT             	1058
#define SOUND_DEATH                 	 1057
#define SOUND_DMKILL                 	1056
#define SOUND_DMDEATH                 1057

#define DBNAME "GTO_REUNION_X10_DATABASE.db"

#define INVALIDX_PLAYER_ID -1

#define OUTPUTLEVEL 0 // Amount of imformation outputted to console
//              0   -   off, no output
//              1   -   + Minimal output
//              2   -   + DB saves, etc
//              3   -   + XP/Level/Money changes output

new DBTYPE = 1; //	Database type (olny flat file ATM)
//				0	-	dini - flat file
//				1	-	TODO: SQL
new DBLOG = 1;
new DBCONSOLELOG = 0;

new ConfigDB[MAX_STRING] = "GTO/Config/GTO.Config.Base.txt";
new LevelDB[MAX_STRING] = "GTO/Config/GTO.Config.Levels.txt";
new VerboseSave = 0; // do we save extra un-needed db info like weapons, races, vehicels, deathmatches, etc
new RealTime=0;
new ForceOverwrite = 1;

// добавил для дальнобойшика
//new IsLoadZavod[TDLMARKERS]; // сколько на заводе нефти для переработки

//-------------MaxPlayers--Optimize---------------
//new MaxPlayers = 0;
//new PLIDs[MAX_PLAYERS];
//------------------------------------------------

//
/*stock DestroyVehicleDebug(vehicleid)
{
    new result = DestroyVehicle(vehicleid);
    printf("Debug > DestroyVehicle: vehicleid %d | result %d", vehicleid, result);
    return result;
}

stock CreateVehicleDebug(vehicletype, Float:x, Float:y, Float:z, Float:rotation, color1, color2, respawn_delay, addsiren=0)
{
    new result = CreateVehicle( vehicletype, x, y, z, rotation, color1, color2, respawn_delay, addsiren );
    printf("Debug > CreateVehicle: type %d | result %d", vehicletype, result);
    return result;
}

stock Attach3DTextLabelToVehicleDebug(Text3D:id, vehicleid, Float:OffsetX, Float:OffsetY, Float:OffsetZ)
{
    printf("Debug > Attach3DTextLabelToVehicle: vehicleid %d", vehicleid);
    Attach3DTextLabelToVehicle(id, vehicleid, OffsetX, OffsetY, OffsetZ);
}

#define CreateVehicle CreateVehicleDebug
#define DestroyVehicle DestroyVehicleDebug
#define Attach3DTextLabelToVehicle Attach3DTextLabelToVehicleDebug*/
//

//new UseSQL = 1;
new DB:ReunionDB;
new GM_RestartNow = 0;

new ScripterName[3][24] = {{"OFFREAL"}, {"Pirate_Rat"}, {"[DF]Rishat"}};

// xyz coord info
enum CoordInfo {
    Float:Coord_X,
    Float:Coord_Y,
    Float:Coord_Z,
    CP_type,
    allow_veh,
    Float:Cp_Size
}

//xyzi coord info
enum CoordInfoEx {
    Float:Coord_X,
    Float:Coord_Y,
    Float:Coord_Z,
	Coord_I
}

new Float:JailX = 265.1273;
new Float:JailY = 77.6823;
new Float:JailZ = 1001.0391;
new Float:JailA = 0.000;
new JailI = 6;

new KickList[MAX_PLAYERS];
new WorldTime;
new DBSeperator= 124; // seperate db fields.atm for db writing im just sending a string, which is written to a file.
new nullstr[MAX_STRING];

enum LevelInfo {
	level_xp,
    level_name[MAX_NAME]
}

// level rank names by Baby Face / Cool
new LevelList[MAX_LEVEL+1][LevelInfo] = { // experience required for each level
{	0	,	"Прохожий"	},

{	2000	,	"Интересующийся"	},
{	5000	,	"Пользователь"	},
{	13000	,	"Геймер"	},
{	24000	,	"Безбашный Чел"	},
{	38000	,	"Жигало"	},

{	58000	,	"Владелец Игрового Портала"	},
{	81000	,	"Гейм Дизайнер" 	},
{	109000	,	"Студент Колледжа"	},
{	143000	,	"Программист"	},
{	182000	,	"Гений С++"	},

{	228000	,	"Разработчик"	},
{	281000	,	"Красавчик"	},
{	341000	,	"Безбашенный Киллер"	},
{	410000	,	"Отморозок"	},
{	487000	,	"Беспредельщик"	},

{	575000	,	"Профессионал"	},
{	674000	,	"Античитер"	},
{	786000	,	"Лаггер"	},
{	911000	,	"Кандидат в Депутаты"	},
{	1050000	,	"Депутат Городской Думы"	},
{	1207000	,	"Самурай"	},
{	1381000	,	"Жертва Перестройки"	},
{	1576000	,	"Доминатор"	},
{	1794000	,	"Хозяин Полуострова"	},
{	2038000	,	"Президент США"	},
{	2311000	,	"Владелец фабрик  домов и пароходов"	},
{	2617000	,	"Франкенштейн"	},
{	2960000	,	"Глава Майкрософт"	},
{	3346000	,	"Великий Скриптер"	},
{	3780000	,	"Враг Касперского"	},
{	4272000	,	"Босс Хакеров"	},
{	4785000	,	"Администратор Мира"	},
{	5332000	,	"Киберпанк"	},
{	5899000	,	"Последний кто видел WINDOWS 95"	},
{	6523000	,	"Мозговзрыватель"	},
{	7200000	,	"ИМХО"	},
{	7886000	,	"Мастер Джедай"	},
{	8582000	,	"Сам придумай кто..."	},
{	9286000	,	"Доктор Зло"	},
{	10000000	,	"Терминатор"	}
};

//-------------------- VEHICLES --------------------
#define V_ADMIRAL 445
#define V_ALPHA 602
#define V_AMBULAN 416
#define V_ANDROM 592			// air
#define V_ARTICT1 435
#define V_ARTICT2 450
#define V_ARTICT3 591
#define V_AT400 577				// air
#define V_BAGBOXA 606
#define V_BAGBOXB 607
#define V_BAGGAGE 485
#define V_BANDITO 568
#define V_BANSHEE 429
#define V_BARRACKS 433
#define V_BEAGLE 511			// air
#define V_BENSON 499
#define V_BF400 581				// bike
#define V_BFINJECT 424
#define V_BIKE 481				// bike
#define V_BLADE 536
#define V_BLISTAC 496
#define V_BLOODRA 504
#define V_BMX 481				// bike
#define V_BOBCAT 422
#define V_BOXBURG 609
#define V_BOXVILLE 498
#define V_BRAVURA 401
#define V_BROADWAY 575
#define V_BUCCANEE 518
#define V_BUFFALO 402
#define V_BULLET 541
#define V_BURRITO 482
#define V_BUS 431
#define V_CABBIE 438
#define V_CADDY 457
#define V_CADRONA 527
#define V_CAMPER 483
#define V_CARGOBOB 548			// air
#define V_CEMENT 524
#define V_CHEETAH 415
#define V_CLOVER 542
#define V_CLUB 589
#define V_COACH 437
#define V_COASTG 472			// water
#define V_COMBINE 532
#define V_COMET 480
#define V_COPBIKE 523			// bike
#define V_COPCARLA 596
#define V_COPCARRU 599
#define V_COPCARSF 597
#define V_COPCARVG 598
#define V_CROPDUST 512			// air
#define V_DFT30 578
#define V_DINGHY 473			// water
#define V_DODO 593				// air
#define V_DOZER 486
#define V_DUMPER 406
#define V_DUNERIDE 573
#define V_ELEGANT 507
#define V_ELEGY 562
#define V_EMPEROR 585
#define V_ENFORCER 427
#define V_ESPERANT 419
#define V_EUROS 587
#define V_FAGGIO 462
#define V_FARMTR1 610
#define V_FBIRANCH 490
#define V_FBITRUCK 528
#define V_FCR900 521			// bike
#define V_FELTZER 533
#define V_FIRELA 544
#define V_FIRETRUK 407
#define V_FLASH 565
#define V_FLATBED 455
#define V_FORKLIFT 530
#define V_FORTUNE 526
#define V_FREEWAY 463			// bike
#define V_FREIBOX 590			//vagon
#define V_FREIFLAT 569			//vagon
#define V_FREIGHT 537			//POEZD
#define V_GLENDALE 466
#define V_GLENSHIT 604
#define V_GREENWOO 492
#define V_HERMES 474
#define V_HOTDOG 588
#define V_HOTKNIFE 434
#define V_HOTRINA 502
#define V_HOTRINB 503
#define V_HOTRING 494
#define V_HUNTER 425			// air
#define V_HUNTLEY 579
#define V_HUSTLER 545
#define V_HYDRA 520				// air
#define V_INFERNUS 411
#define V_INTRUDER 546
#define V_JESTER 559
#define V_JETMAX 493			// water
#define V_JOURNEY 508
#define V_KART 571
#define V_LANDSTAL 400
#define V_LAUNCH 595			// water
#define V_LEVIATHN 417			// air
#define V_LINERUN 403
#define V_MAJESTIC 517
#define V_MANANA 410
#define V_MARQUIS 484			// water
#define V_MAVERICK 487			// air
#define V_MERIT 551
#define V_MESA 500
#define V_MONSTER 444
#define V_MONSTERA 556
#define V_MONSTERB 557
#define V_MOONBEAM 418
#define V_MOWER 572
#define V_MRWHOOP 423
#define V_MTBIKE 510			// bike
#define V_MULE 414
#define V_NEBULA 516
#define V_NEVADA 553			// air
#define V_NEWSVAN 582
#define V_NRG500 522			// bike
#define V_OCEANIC 467
#define V_PACKER 443
#define V_PATRIOT 470
#define V_PCJ600 461			// bike
#define V_PEREN 404
#define V_PETRO 514			//GRUZOVIK
#define V_PETROTR 584			//PRICEP BENZO
#define V_PHOENIX 603
#define V_PICADOR 600
#define V_PIZZABOY 448
#define V_POLMAV 497			// air
#define V_PONY 413
#define V_PREDATOR 430			// water
#define V_PREMIER 426
#define V_PREVION 436
#define V_PRIMO 547
#define V_QUAD 471				// bike
#define V_RAINDANC 563			// air
#define V_RANCHER 489
#define V_RCBANDIT 441
#define V_RCBARON 464			// air
#define V_RCCAM 594
#define V_RCGOBLIN 501			// air
#define V_RCRAIDER 465			// air
#define V_RCTIGER 564
#define V_RDTRAIN 515			//GRUZOVIK
#define V_REEFER 453			// water
#define V_REGINA 479
#define V_REMINGTN 534
#define V_RHINO 432
#define V_RNCHLURE 505
#define V_ROMERO 442
#define V_RUMPO 440
#define V_RUSTLER 476			// air
#define V_SABRE 475
#define V_SADLER 543
#define V_SADLSHIT 605
#define V_SANCHEZ 468			// bike
#define V_SANDKING 495
#define V_SAVANNA 567
#define V_SEASPAR 447			// air
#define V_SECURICA 428
#define V_SENTINEL 405
#define V_SHAMAL 519			// air
#define V_SKIMMER 460			// air
#define V_SLAMVAN 535
#define V_SOLAIR 458
#define V_SPARROW 469			// air
#define V_SPEEDER 452			// water
#define V_SQUALO 446			// water
#define V_STAFFORD 580
#define V_STALLION 439
#define V_STRATUM 561
#define V_STREAK 538		//poezd
#define V_STREAKC 570		//
#define V_STRETCH 409
#define V_STUNT 513				// air
#define V_SULTAN 560
#define V_SUNRISE 550
#define V_SUPERGT 506
#define V_SWATVAN 601
#define V_SWEEPER 574
#define V_TAHOMA 566
#define V_TAMPA 549
#define V_TAXI 420
#define V_TOPFUN 459
#define V_TORNADO 576
#define V_TOWTRUCK 525
#define V_TRACTOR 531
#define V_TRAM 449
#define V_TRASH 408			//MUSOROVOZ
#define V_TROPIC 454			//water
#define V_TUG 583
#define V_TUGSTAIR 608			//AIRPORT LESTNICA
#define V_TURISMO 451
#define V_URANUS 558
#define V_UTILITY 552			//UBORSHIK
#define V_UTILTR1 611			//UBOESHIK PRICEP
#define V_VCNMAV 488			// air
#define V_VINCENT 540
#define V_VIRGO 491
#define V_VOODOO 412
#define V_VORTEX 539			// hovercraft PODUSHKA
#define V_WALTON 478
#define V_WASHING 421
#define V_WAYFARER 586			// bike
#define V_WILLARD 529
#define V_WINDSOR 555
#define V_YANKEE 456
#define V_YOSEMITE 554
#define V_ZR350 477

enum PlayerInfo {
	IsActive,       // is player online
	Float:Health,   // health
	Money,          // Money
	Bank,           // Money in bank
	Level,          // Level
	XP,             // XP
	RXP,			// RaceXP
	Deaths,         // Deaths
	Kills,          // Kills
	Jailed,         // Jailed status
	Muted,          // Muted status
	CarKills,       // cars killed
	Status,		       // 0-user,1>-moderator,admins
	SkinModel,	     // Skin Model
	Hide,		         // Hide on the radar
	Jailtime,	      // Time for Jails
	Mutetime,	// Time for Mute
	Vip,		// VIP status
	Car,			// player CAR
	Packages,		// player collected packages
	train1, // Дальнобойщики
	train2, // Гонка
	train3, // Дм
	train4, // Теор часть
    Float:Armour,   // health
   	JailKick,		// Jail Check Kick
   	Attach,
   	EventBan,
   	TypeSpawn
}
new Player[MAX_PLAYERS][PlayerInfo];

BaseLoadConfig()
{
	if (ForceOverwrite) return;
	new temp[MAX_STRING];
	if (!dini_Exists(ConfigDB))
	{
		dini_Create(ConfigDB);
	}
	set(temp,dini_Get(ConfigDB,"Level_DB"));
	if (strlen(temp) > 0) set(LevelDB,temp);
	
	set(temp,dini_Get(ConfigDB,"Verbose_Save"));
	if (strlen(temp) > 0) VerboseSave = strval(temp);
	
	set(temp,dini_Get(ConfigDB,"Real_Time"));
	if (strlen(temp) > 0) RealTime = strval(temp);
	
	if (!dini_Exists(LevelDB))
	{
		BaseSaveConfig();
	}
	for (new i=0;i<=MAX_LEVEL;i++)
	{
		new tempname[MAX_STRING];
	    format(tempname,sizeof(tempname),"Level%d_Rankname",i);
		set(temp,dini_Get(LevelDB,tempname));
		if (strlen(temp) > 0) set(LevelList[i][level_name],temp);
		
		format(tempname,sizeof(tempname),"Level%d_Experience",i);
		set(temp,dini_Get(LevelDB,tempname));
		if (strlen(temp) > 0) LevelList[i][level_xp] = strval(temp);
	}
	return;
}

BaseSaveConfig()
{
	new temp[MAX_STRING];
	if (dini_Exists(ConfigDB))
	{
		dini_Set(ConfigDB,"Level_DB",LevelDB);
		
		valstr(temp,VerboseSave);
		dini_Set(ConfigDB,"Verbose_Save",temp);

        valstr(temp,RealTime);
		dini_Set(ConfigDB,"Real_Time",temp);
	}
	
	if (!dini_Exists(LevelDB))
	{
		dini_Create(LevelDB);
	}
	for (new i=0;i<=MAX_LEVEL;i++)
	{
		new tempname[MAX_STRING];
	    format(tempname,sizeof(tempname),"Level%d_Rankname",i);
		dini_Set_utf8(LevelDB,tempname,LevelList[i][level_name]);
		
		format(tempname,sizeof(tempname),"Level%d_Experience",i);
		valstr(temp,LevelList[i][level_xp]);
		dini_Set_utf8(LevelDB,tempname,temp);
	}
	return;
}

/*GetLevelName(level)
{
	new name[MAX_NAME];
	if ((level < 0) || (level > MAX_LEVEL+1)) return name;
	set(name,LevelList[level][level_name]);
	return name;
}*/

// ---- Info TD Module ----
new Text:InfoTDB;
new Text:InfoTD[MAX_PLAYERS];

new Text:XPLineTDB;
new Text:XPLineTD[MAX_PLAYERS];

new Text:LogoTD[4];


new bool:ShowTDS[MAX_PLAYERS][2];


// 0 - logo
// 1 - radar


#define ITDX 499.00


#define ITDY 79.00
#define LTDX 70.00
#define LTDY 180.00

#define XPTDL 107.00
#define ZEROFFS 4.00

new Float:xp_td_buffer, info_td_buffer[64];

// ---------------------------
UpdatePlayerXPLine(playerid) // WARN: use only after CreatePlyerXPLine
{
	if( Player[playerid][Level] < MAX_LEVEL )
	{
		xp_td_buffer =
		float( Player[playerid][XP] - LevelList[ Player[playerid][Level] ][level_xp] ) * (XPTDL + ZEROFFS)/
		float( LevelList[ Player[playerid][Level] + 1 ][level_xp] - LevelList[ Player[playerid][Level] ][level_xp] );
	}
	else
	{
		xp_td_buffer = 0.00;
	}

	TextDrawTextSize(XPLineTD[playerid], ITDX - ZEROFFS + xp_td_buffer, 0.00);
	TextDrawShowForPlayer(playerid, XPLineTD[playerid]);
}

UpdatePlayerInfoTD(playerid) // WARN: use only after CreatePlyerInfoTD
{
	format(info_td_buffer,sizeof(info_td_buffer),"~w~%d ~g~$~n~~w~%d ~p~LVL", Player[playerid][Money], Player[playerid][Level]);
	TextDrawSetString(InfoTD[playerid],info_td_buffer);
}

TDS_GM_Init()
{
	// LOGO

    LogoTD[0] = TextDrawCreate(LTDX, LTDY, "grand~n~ theft~n~online");
	TextDrawSetOutline(LogoTD[0], 3);
	TextDrawFont(LogoTD[0], 3);
	TextDrawSetShadow(LogoTD[0],0);
	TextDrawSetProportional(LogoTD[0], true);
	TextDrawLetterSize(LogoTD[0], 0.9, 3.0);
	TextDrawHideForAll(LogoTD[0]);

    LogoTD[1] = TextDrawCreate(LTDX-25.00, LTDY+80.00, "reunion");
    TextDrawBackgroundColor(LogoTD[1], 0xffffffFF);
	TextDrawSetOutline(LogoTD[1], 2);
	TextDrawColor(LogoTD[1],0x000000FF);
	TextDrawFont(LogoTD[1], 3);
	TextDrawSetShadow(LogoTD[1],0);
	TextDrawSetProportional(LogoTD[1], true);
	TextDrawLetterSize(LogoTD[1], 0.9, 3.0);
	TextDrawHideForAll(LogoTD[1]);

    LogoTD[2] = TextDrawCreate(LTDX+100.00, LTDY+70.00, "11");
    TextDrawBackgroundColor(LogoTD[2], 0xffffffFF);
	TextDrawSetOutline(LogoTD[2], 2);
	TextDrawColor(LogoTD[2],0xFF6000FF);
	TextDrawFont(LogoTD[2], 1);
	TextDrawSetShadow(LogoTD[2],0);
	TextDrawSetProportional(LogoTD[2], true);
	TextDrawLetterSize(LogoTD[2], 1.0, 5.0);
	TextDrawHideForAll(LogoTD[2]);

	new logostring[128];
	format(logostring,sizeof(logostring),"version %s",VERSION);

    LogoTD[3] = TextDrawCreate(LTDX+50.00, LTDY+110.00, logostring);
    TextDrawColor(LogoTD[3],0xFFFFFF80);
    TextDrawFont(LogoTD[3], 2);
    TextDrawAlignment(LogoTD[3], 2);
    TextDrawSetShadow(LogoTD[3],0);
    TextDrawSetProportional(LogoTD[3], true);
    TextDrawLetterSize(LogoTD[3], 0.3, 1.0);
	TextDrawHideForAll(LogoTD[3]);

	// Info Back

	InfoTDB = TextDrawCreate(ITDX, ITDY, "_");
	TextDrawUseBox(InfoTDB,1);
    TextDrawBoxColor(InfoTDB, 0x222222FF );
    TextDrawTextSize(InfoTDB, ITDX + XPTDL ,0.00);
    TextDrawLetterSize(InfoTDB,0.00, 3.00 );

	// XP Back

	XPLineTDB = TextDrawCreate(ITDX, ITDY + 27.00, "_");
	TextDrawUseBox(XPLineTDB,1);
    TextDrawBoxColor(XPLineTDB, 0xFFFFFF44 );
    TextDrawTextSize(XPLineTDB, ITDX + 107.00, 0.00);
    TextDrawLetterSize(XPLineTDB, 0.00, 0.00 );

	//
}

TDS_OnPlayerSpawn(playerid)
{
	// Hide LOGO
	if( ShowTDS[playerid][0] )
	{
		for(new i=0; i<4; i++)
		{
			TextDrawHideForPlayer(playerid, LogoTD[i]);
		}
		ShowTDS[playerid][0] = false;
	}
}

TDS_OnPlayerConnect(playerid)
{
	// Show LOGO
	for(new i=0; i<4; i++)
	{
		TextDrawShowForPlayer(playerid, LogoTD[i]);
	}
	ShowTDS[playerid][0] = true;

	// Show Info TDB
	TextDrawShowForPlayer(playerid, InfoTDB);

	// Create PlayerXPLine
	XPLineTD[playerid] = TextDrawCreate(ITDX, ITDY + 27.00, "_");
	TextDrawUseBox(XPLineTD[playerid],1);
    TextDrawBoxColor(XPLineTD[playerid], 0xffae00FF ); //0xffae00FF
    TextDrawTextSize(XPLineTD[playerid], ITDX, 0.00);
    TextDrawLetterSize(XPLineTD[playerid],0.00, 0.00 );
	TextDrawHideForPlayer(playerid, XPLineTD[playerid]); // <<< Hide

	// Create PlayerInfoTD
	InfoTD[playerid] = TextDrawCreate(ITDX + 2.0, ITDY, "~r~//~n~~w~Autorization");
    TextDrawFont(InfoTD[playerid],2);
    TextDrawLetterSize(InfoTD[playerid],0.25, 1.00 );
	TextDrawSetShadow(InfoTD[playerid],0);
	TextDrawSetOutline(InfoTD[playerid],0);
	TextDrawShowForPlayer(playerid, InfoTD[playerid]); // <<< SHOW

	// Radar
	ShowTDS[playerid][1] = false;
}

TDS_OnPlayerDisconnect(playerid)
{
	TextDrawDestroy(InfoTD[playerid]);
	TextDrawDestroy(XPLineTD[playerid]);
	TextDrawHideForPlayer(playerid, InfoTDB);
	TextDrawHideForPlayer(playerid, XPLineTDB);
	// Radar
	ShowTDS[playerid][1] = false;
}

TDS_AccLoad(playerid)
{
	// Info update
	UpdatePlayerInfoTD(playerid);

	// Show XP Line
	TextDrawShowForPlayer(playerid, XPLineTDB);
	UpdatePlayerXPLine(playerid);

	// Radar
	if( !ShowTDS[playerid][1] )
	{
		ShowTDS[playerid][1] = true;
		xGetPlayerPackSignal(playerid, 0, -1);
	}
}

new PlayerDebug[MAX_PLAYERS]; // reset player stats

//
#define DEBUG_STATIC_ARGS 3
#define DEBUG_MAX_ARGS 8
#define DEBUG_MSG_ENABLE

stock SendDebugMessage(playerid, color, fstring[], {Float, _}:...)
{
    #if defined DEBUG_MSG_ENABLE
    if(!PlayerDebug[playerid]) { return 0; }

    for(new i = numargs(); i < DEBUG_MAX_ARGS; i++)
    {
        setarg(i, 0, 0);
    }

    new message[128];
    format(message, sizeof(message),
        fstring,
        getarg(DEBUG_STATIC_ARGS),
        getarg(DEBUG_STATIC_ARGS + 1),
        getarg(DEBUG_STATIC_ARGS + 2),
        getarg(DEBUG_STATIC_ARGS + 3),
        getarg(DEBUG_STATIC_ARGS + 4)   );


    format(message, sizeof(message), "DEBUG > {FFFFFF}%s", message);
    return SendClientMessage(playerid, color, message);
    #else
    return 0;
    #endif
}

//--------------------------------------------------------
