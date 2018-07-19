//
// Created: 05.09.06
// Aurthor: Iain Gilbert
// ReCreate: Artem Firstov (Konsul)
/*
Last ReCreated by Maxim Tsarkov (OFFREAL)
- - - - -
Команда на броню не действует в десматче
Команды на броню и ремонт авто доступны 1 раз в 30 секунд
Добавлена команда /inoob для новичков ГТО
Укорочена команда на передачу денег
*/

#if defined _commandhandler_included
#endinput
#endif

#define _commandhandler_included
#pragma library commandhandler
#include "base"
#include "utils\gtoutils"
#include "player"
#include "account"

#define CMD_TIME 30 //seconds to wait commands
#define RADIO 888

#define DIALOG_ATTACH_INDEX             13500
#define DIALOG_ATTACH_INDEX_SELECTION   DIALOG_ATTACH_INDEX+1
#define DIALOG_ATTACH_EDITREPLACE       DIALOG_ATTACH_INDEX+2
#define DIALOG_ATTACH_MODEL_SELECTION   DIALOG_ATTACH_INDEX+3
#define DIALOG_ATTACH_BONE_SELECTION    DIALOG_ATTACH_INDEX+4
#define MAX_PLAYER_ATTACHED_OBJECTSM	4

new MyCMDlist[256] = "Ремонт машины\nКупить броню\nМой уровень\nМоя статистика\nМои навыки оружия\nМой SQL id\nПрыгнуть с парашютом\nАктивные десматчи\nАктивные гонки\nУправление PM";
new PlCMDlist[256] = "Запретить писать мне PM\nПередать денег\nСтатистика игрока";
new PmCMDlist[128] = "Показать черный список\nОчистить черный список";

new hourE,minuteE,secondE;

#define MAX_LISTITEMS 60
#define EVENT_DMJOIN 1
#define EVENT_RACEJOIN 2

new skinlist = mS_INVALID_LISTID;

enum item_stats {
action_code,
action_parameters
}
new dialog_select[MAX_PLAYERS][MAX_LISTITEMS][item_stats];

/*
//бензоколонки
new Float:TDMarkersPetrol[DALNAZSMARKERS][CoordInfo] = {
	{2109.2126,917.5845,10.8203},
	{2640.1831,1103.9224,10.8203},
	{611.8934,1694.7921,6.7193},
	{-1327.5398,2682.9771,49.7896},
	{-2413.7427,975.9317,45.0031},
	{-1672.3597,414.2950,6.8866},
	{-2244.1365,-2560.6294,31.6276},
	{-1603.0166,-2709.3589,48.2419},
	{1939.3275,-1767.6813,13.2787},
	{-94.7651,-1174.8079,1.9979},
	{1381.6699,462.6467,19.8540},
	{657.8167,-559.6507,16.0630},
	{-1478.2916,1862.8318,32.3617},
	{2147.3054,2744.9377,10.5263},
	{2204.9602,2480.3494,10.5278},
	{1590.9493,2202.2637,10.5247}
};

new Float:TDLMarkersLoc[1][CoordInfoEx] = { // Coord_I - цена
	{271.9484,1417.1746,10.4533,700} //завод в третьем
};

// перерабатываем тут
new Float:TDLMarkersProces[3][CoordInfoEx] = { // коорд и = цена приемки оил, кена керосина кена оил +600
	{2486.0518,-2083.7764,13.5469,1200}, //завод в первом (не перерабатывает в керосин)
	{-1035.2433,-626.3660,32.0078,950}, //завод во втором
	{2707.8103,2646.9172,10.8203,900} //завод в третьем KACC
};

// продаем тут
new Float:TDLMarkersDest[3][CoordInfoEx] = { // цена покупки бензина 1500, продажи по формуле
	{369.3520,2602.1160,16.4918,1400}, //заброшенный аэро
	{-1567.6123,-656.9137,14.1484,1300}, //аэропорт во втором
	{2491.6790,-2652.4880,13.6722,1600} //порт в первом
};

// переместил непосредственно в команду /gps dm id
new Float:GPSDMs[18][CoordInfo] = { // список для ДМов
	{1887.228637,-1424.624511,10.359399}, //дм1 Peril Highness
	{-16.790000,1517.150024,12.340000}, //дм2 Area 51
	{143.547103,-1567.568237,10.764200}, //дм3 The Bad And The Ugly
	{1653.569580,-1051.173950,23.898399}, //дм4 Blue Mountains
	{2358.659912,533.559997,1.379999}, //дм5 Cargo Ship
	{621.363220,50.637401,1.421200}, //дм6 Farm Revenge
	{2486.139892,2772.600097,10.350000}, //дм7 Millitary Base
	{2197.767089,-1643.993530,14.829099}, //дм8 Minigun Madness
	{951.679992,-1355.848632,13.023400}, //дм9 Poolday
	{2786.840087,-2456.290039,13.630000}, //дм10 The US Navy
	{2015.512939,2147.693603,10.820300}, //дм11 Fight on a Hill
	{1489.034912,722.709411,10.820311}, //дм12 Batle at the Punk's House
	{1349.053466,-1280.194824,13.382800}, //дм13 Hunt in Forest
	{2095.976806,1285.144653,10.820311}, //дм14 Rendezvous
	{-2759.989013,-294.346679,6.748950}, //дм15 Rocketmania
	{-2345.421386,149.549652,34.966327}, //дм16 Paper Work
	{2721.915527,854.379516,10.898400}, //дм17 The building area
	{1088.874023,1073.765991,10.835000} //дм18 Arctic Sea
};
*/
/* переместил непосредственно в команду /gps race id
new Float:GPSRaces[27][CoordInfo] = { // список для гонок
	{2046.305908,866.740417,6.515999}, //гонка1 Burnin Down The Strip
	{1557.117187,26.855699,23.884500}, //гонка2 Riverside Run
	{2227.252929,2455.298095,10.470299}, //гонка3 Flee the City
	{2156.771972,1680.312866,10.529100}, //гонка4 Lost in Smoke
	{2169.872802,2022.469238,10.351599}, //гонка5 Backstreet Bang
	{2061.448242,2215.910156,10.445300}, //гонка6 Flying Free
	{-2394.039306,-2205.217529,32.957500}, //гонка7 MurderHorn
	{1477.276855,1714.598266,10.812500}, //гонка8 Airport Round We Go
	{-1103.233276,388.674011,14.148400}, //гонка9 Strip Tease
	{2440.966796,113.509597,26.848699}, //гонка10 Monstertruck Madness
	{2412.836669,94.440902,26.844100}, //гонка11 Countryside Cruise
	{2455.341796,-1658.946166,13.108400}, //гонка12 Tearin Up The Grove 
	{1244.737182,-820.566772,83.947303}, //гонка13 Mullholland Getaway
	{1761.945312,834.752136,9.854599}, //гонка14 Julius Thruway Race
	{425.491668,2523.084716,16.353261}, //гонка15 Verdant Meadows Race
	{1713.795654,1453.996337,10.443292}, //гонка16 Majestic
	{1702.000000,-488.000000,33.669998}, //гонка17 Around San Andreas
	{-1883.945556,1055.327880,45.000000}, //гонка18 The Madball Run
	{2396.048828,-2290.309570,5.742175}, //гонка19 Underground
	{2066.433349,-2493.679199,13.721899}, //гонка20 Rustler Big Race
	{289.2637,2502.8608,17.0623}, //гонка21 Helicopter Slalom
	{-1382.333984,-141.270599,1051.272583}, //гонка22 Stadium in the Los Santos
	{-1440.340332,-672.379577,1053.308959}, //гонка23 Stadium in the Las Venturas
	{410.763397,2374.932373,25.292800}, //гонка24 Race DUNE
	{-2473.190185,-1920.880249,301.066802}, //гонка25 The Mountain bike
	{-1423.497558,914.972412,1039.615234}, //гонка26 Stadium in the SanFierro
	{-719.658813,1989.322265,-0.531893} //гонка27 Bon Voyage
};
*/

new obj1[MAX_PLAYERS];
new obj2[MAX_PLAYERS];
new obj3[MAX_PLAYERS];
new obj4[MAX_PLAYERS];
new TypeObjectCar[MAX_PLAYERS];
new TypeObject[MAX_PLAYERS];

new exception[] =
{
    448,461,462,463,468,471,481,509,510,521,522,523,581,586, //2х колесный транспорт
    567,575,//Кабриолеты 439,480,533,536,555,
    408,443,449,524,531,552,582,600,605, //Грузовые 403,413,414,422,433,440,455,456,459,478,482,498,514,515,543,554,578,609,
    407,416,420,427,432,438,544,596,597,598,599,601,    //Служебные 490,528,

    460,476,511,512,513,519,520,
    553,577,592,593,//Самолеты

    417,425,447,469,487,488,497,548,563, //Вертолеты

    430,446,452,453,454,472,473,484,493,595,  //Лодки

    406,423,435,449,450,485, //424,428,442,457,
    525,530,532,537,538,539,486, //500,508,568,
    569,570,571,572,574,583,584,588,590,591,
    606,607,608,610,611    //Шляпа, поезда, трактора, и т.п.
};

new cars11[] =
{
    439,480    //+.1 -.1
};

new cars21[] =
{
    533,555,543    //+.2 -.1
};

new cars31[] =
{
    536,500    //+.3 -.1
};

new cars70[] =
{
    575,413,414,459,482,498,609    //+.7
};

new cars72[] =
{
    567,440,455    //+.7 -.2
};

enum AttachProp
{
    amodelid,
	aboneid,
	Float:aOffsetX,
	Float:aOffsetY,
	Float:aOffsetZ,
	Float:aRotX,
	Float:aRotY,
	Float:aRotZ,
	Float:aScaleX,
	Float:aScaleY,
	Float:aScaleZ
};

new PlayerAttachmentsObj[MAX_PLAYERS][MAX_PLAYER_ATTACHED_OBJECTS][AttachProp];

enum AttachmentEnum
{
    attachmodel,
    attachname[24]
};

new AttachmentObjects[][AttachmentEnum] = {
	{18632, "Удочка"},
	{18633, "Гаечный Ключ"},
	{18634, "Лом"},
	{18635, "Молоток"},
	{18637, "Полицейский Щит"},
	{18638, "Строительная Каска"},
	{19160, "Каска Директора"},
	{19093, "Каска Прораба"},
	{18639, "Чёрная Шляпа"},
	{18640, "Афро-причёска_1"},
	{18975, "Афро-причёска_2"},
	{19136, "Еврейская Шляпа"},
	{19274, "Парик_1"},
	{18975, "Парик_2"},
	{18641, "Фонарик"},
	{18642, "Шокер"},
	{18643, "Лазер (Красный)"},
	{19080, "Лазер (Синий)"},
	{19081, "Лазер (Розовый)"},
	{19082, "Лазер (Оранжевый)"},
	{19083, "Лазер (Зелёный)"},
	{19084, "Лазер (Жёлтый)"},
	{18644, "Отвёртка"},
	{18865, "Мобильный телефон_1"},
	{18866, "Мобильный телефон_2"},
	{18867, "Мобильный телефон_3"},
	{18868, "Мобильный телефон_4"},
	{18869, "Мобильный телефон_5"},
	{18870, "Мобильный телефон_6"},
	{18871, "Мобильный телефон_7"},
	{18872, "Мобильный телефон_8"},
	{18873, "Мобильный телефон_9"},
	{18874, "Мобильный телефон_10"},
	{18875, "Пейджер"},
	{18890, "Грабли"},
	{18891, "Бандана_1"},
	{18892, "Бандана_2"},
	{18893, "Бандана_3"},
	{18894, "Бандана_4"},
	{18895, "Бандана_5"},
	{18896, "Бандана_6"},
	{18897, "Бандана_7"},
	{18898, "Бандана_8"},
	{18899, "Бандана_9"},
	{18900, "Бандана_10"},
	{18901, "Бандана_11"},
	{18902, "Бандана_12"},
	{18903, "Бандана_13"},
	{18904, "Бандана_14"},
	{18905, "Бандана_15"},
	{18906, "Бандана_16"},
	{18907, "Бандана_17"},
	{18908, "Бандана_18"},
	{18909, "Бандана_19"},
	{18910, "Бандана_20"},
	{18911, "Бандитская Маска_1"},
	{18912, "Бандитская Маска_2"},
	{18913, "Бандитская Маска_3"},
	{18914, "Бандитская Маска_4"},
	{18915, "Бандитская Маска_5"},
	{18916, "Бандитская Маска_6"},
	{18917, "Бандитская Маска_7"},
	{18918, "Бандитская Маска_8"},
	{18919, "Бандитская Маска_9"},
	{18920, "Бандитская Маска_10"},
	{18921, "Берет_1"},
	{18922, "Берет_2"},
	{18923, "Берет_3"},
	{18924, "Берет_4"},
	{18925, "Берет_5"},
	{18926, "Кепка_1"},
	{18927, "Кепка_2"},
	{18928, "Кепка_3"},
	{18929, "Кепка_4"},
	{18930, "Кепка_5"},
	{18931, "Кепка_6"},
	{18932, "Кепка_7"},
	{18933, "Кепка_8"},
	{18934, "Кепка_9"},
	{18935, "Кепка_10"},
	{18955, "Кепка_11"},
	{18956, "Кепка_12"},
	{18957, "Кепка_13"},
	{18958, "Кепка_14"},
	{18959, "Кепка_15"},
	{18960, "Кепка_16"},
	{18961, "Кепка Дальнобойщика"},
	{18936, "Немецкий Шлем_1"},
	{18937, "Немецкий Шлем_2"},
	{18938, "Немецкий Шлем_3"},
	{18939, "Бейсболка_1"},
	{18940, "Бейсболка_2"},
	{18941, "Бейсболка_3"},
	{18942, "Бейсболка_4"},
	{18943, "Бейсболка_5"},
	{18944, "Канотье_1"},
	{18945, "Канотье_2"},
	{18946, "Канотье_3"},
	{18947, "Котелок_1"},
	{18948, "Котелок_2"},
	{18949, "Котелок_3"},
	{18950, "Котелок_4"},
	{18951, "Котелок_5"},
	{19488, "Котелок_6"},
	{18952, "Боксёрский Шлем"},
	{18953, "Вязаная Шапка_1"},
	{18954, "Вязаная Шапка_2"},
	{18963, "Голова CJ"},
	{18964, "Шапка_1"},
	{18965, "Шапка_2"},
	{18966, "Шапка_3"},
	{18967, "Мужская Шляпа_1"},
	{18968, "Мужская Шляпа_2"},
	{18969, "Мужская Шляпа_3"},
	{18970, "Леопардовая Шляпа"},
	{18971, "Модная Шляпа_1"},
	{18972, "Модная Шляпа_2"},
	{18973, "Модная Шляпа_3"},
	{18974, "Маска Зорро"},
	{18645, "Мотоциклетный Шлем_1"},
	{18976, "Мотоциклетный Шлем_2"},
	{18977, "Мотоциклетный Шлем_3"},
	{18978, "Мотоциклетный Шлем_4"},
	{18979, "Мотоциклетный Шлем_5"},
	{19006, "Очки_1"},
	{19007, "Очки_2"},
	{19008, "Очки_3"},
	{19009, "Очки_4"},
	{19010, "Очки_5"},
	{19011, "Очки_6"},
	{19012, "Очки_7"},
	{19013, "Очки_8"},
	{19014, "Очки_9"},
	{19015, "Очки_10"},
	{19016, "Очки_11"},
	{19017, "Очки_12"},
	{19018, "Очки_13"},
	{19019, "Очки_14"},
	{19020, "Очки_15"},
	{19021, "Очки_16"},
	{19022, "Очки_17"},
	{19023, "Очки_18"},
	{19024, "Очки_19"},
	{19025, "Очки_20"},
	{19026, "Очки_21"},
	{19027, "Очки_22"},
	{19028, "Очки_23"},
	{19029, "Очки_24"},
	{19030, "Очки_25"},
	{19031, "Очки_26"},
	{19032, "Очки_27"},
	{19033, "Очки_28"},
	{19034, "Очки_29"},
	{19035, "Очки_30"},
	{19036, "Хоккейная Маска_1"},
	{19037, "Хоккейная Маска_2"},
	{19038, "Хоккейная Маска_3"},
	{19039, "Часы_1"},
	{19040, "Часы_2"},
	{19041, "Часы_3"},
	{19042, "Часы_4"},
	{19043, "Часы_5"},
	{19044, "Часы_6"},
	{19045, "Часы_7"},
	{19046, "Часы_8"},
	{19047, "Часы_9"},
	{19048, "Часы_10"},
	{19049, "Часы_11"},
	{19050, "Часы_12"},
	{19051, "Часы_13"},
	{19052, "Часы_14"},
	{19053, "Часы_15"},
	{19085, "Повязка На Глаз"},
	{19086, "Бензочлен"},
	{19090, "Помпон (Синий)"},
	{19091, "Помпон (Красный)"},
	{19092, "Помпон (Зелёный)"},
	{19094, "Шляпа-Бургер"},
	{19095, "Ковбойская Шляпа_1"},
	{18962, "Ковбойская Шляпа_2"},
	{19096, "Ковбойская Шляпа_3"},
	{19097, "Ковбойская Шляпа_4"},
	{19098, "Ковбойская Шляпа_5"},
	{18636, "Полицейская Кепка_1"},
	{19099, "Полицейская Кепка_2"},
	{19100, "Полицейская Кепка_3"},
	{19161, "Полицейская Кепка_4"},
	{19162, "Полицейская Кепка_5"},
	{19101, "Армейский Шлем_1"},
	{19102, "Армейский Шлем_2"},
	{19103, "Армейский Шлем_3"},
	{19104, "Армейский Шлем_4"},
	{19105, "Армейский Шлем_5"},
	{19106, "Армейский Шлем_6"},
	{19107, "Армейский Шлем_7"},
	{19108, "Армейский Шлем_8"},
	{19109, "Армейский Шлем_9"},
	{19110, "Армейский Шлем_10"},
	{19111, "Армейский Шлем_11"},
	{19112, "Армейский Шлем_12"},
	{19113, "Шутливый Шлем_1"},
	{19114, "Шутливый Шлем_2"},
	{19115, "Шутливый Шлем_3"},
	{19116, "Шлем_1"},
	{19117, "Шлем_2"},
	{19118, "Шлем_3"},
	{19119, "Шлем_4"},
	{19120, "Шлем_5"},
	{19137, "Голова Петуха"},
	{19138, "Полицейские Очки_1"},
	{19139, "Полицейские Очки_2"},
	{19140, "Полицейские Очки_3"},
	{19141, "Шлем Спецназа"},
	{19142, "Бронежилет"},
	{19163, "Садо-Мазо Шлем"},
	{19317, "Бас-гитара"},
	{19318, "V-Гитара"},
	{19319, "Магическая Гитара"},
	{19330, "Каска Пожарника_1"},
	{19331, "Каска Пожарника_2"},
	{19346, "Хот-дог"},
	{19347, "Звезда Шерифа"},
	{19348, "Трость"},
	{19349, "Монокль"},
	{19350, "Усы_1"},
	{19351, "Усы_2"},
	{19352, "Высокая Шляпа_1"},
	{19487, "Высокая Шляпа_2"},
	{18886, "Электромагнит"},
	{18887, "Силовое Поле"},
	{19064, "НГ Шапка_1"},
	{19065, "НГ Шапка_2"},
	{19066, "НГ Шапка_3"},
	{19078, "Попугай_1"},
	{19079, "Попугай_2"},
	{18647, "Белый Неон"},
	{18648, "Синий Неон"},
	{18649, "Зелёный Неон"},
	{18650, "Жёлтый Неон"},
	{18688, "Пламя"}
};

new AttachmentBones[][30] = {
	{"Спина"},
	{"Голова"},
	{"Левое плечо"},
	{"Правое плечо"},
	{"Левая рука"},
	{"Правая рука"},
	{"Левое бедро"},
	{"Правое бедро"},
	{"Левая нога"},
	{"Правая нога"},
	{"Правая икра"},
	{"Левая икра"},
	{"Левое предплечье"},
	{"Правое предплечье"},
	{"Левая ключица"},
	{"Правая ключица"},
	{"Шея"},
	{"Рот"}
};

forward CommandHandler(playerid,text[]);

public CommandHandler(playerid,text[]) // process player commands
{
	if (!IsPlayerConnected(playerid)) return 0;
	
	dcmd(pm, 2, text);
	
	new cmd[20];
	new idx;
	
	set(cmd,strcharsplit(text, idx,strchar(" ")));
	
	//printf("%d %s %s",idx,text,cmd);
	
	if(strcomp(cmd, "/sound", true) == 1)
	{
	new string[MAX_STRING];
	set(string,text);
	strdel(string, 0, idx);
	new soundid;
	soundid = strval(strcharsplit(text, idx,strchar(" ")));
	if (soundid <= 0)
	{
		SendPlayerFormattedText(playerid, lang_texts[1][15] , 0,COLOUR_RED);
		return 1;
	}
	new Float:playerx,Float:playery,Float:playerz;
	GetPlayerPos(playerid,playerx,playery,playerz);
	PlayerPlaySound(playerid,soundid,playerx,playery,playerz);
	format(string,sizeof(string), lang_texts[1][16] ,soundid);
	SendPlayerFormattedText(playerid,string, 0,COLOUR_XP_GOOD);
	return 1;
	}
//------------------- GPS ---

/*    if(strcomp(cmd, "/gps", true) == 1)
	{
  		set(cmd,strcharsplit(text, idx,strchar(" ")));
  		if (strlen(cmd) == 0)
		{
			SendPlayerFormattedText(playerid,  "Применение: /gps <цель> <ID>" , 0,COLOUR_RED);
			SendPlayerFormattedText(playerid,  "Возможные цели:" , 0,COLOUR_XP_GOOD);
			SendPlayerFormattedText(playerid,  "> Десматчи '/gps dm <id>'" , 0,COLOUR_XP_GOOD);
			SendPlayerFormattedText(playerid,  "> Гонки '/gps race <id>'" , 0,COLOUR_XP_GOOD);
			//SendPlayerFormattedText(playerid,  "> Дальнобойщики '/gps trade <id>'" , 0,COLOUR_XP_GOOD);
			//SendPlayerFormattedText(playerid,  "> Завод 'Green Palms'-'/gps oil'" , 0,COLOUR_XP_GOOD);
			//SendPlayerFormattedText(playerid,  "> Завод 'Willow field'- '/gps zavod 1'" , 0,COLOUR_XP_GOOD);
			//SendPlayerFormattedText(playerid,  "> Завод 'Easter bay chemicals'- '/gps zavod 2'" , 0,COLOUR_XP_GOOD);
			//SendPlayerFormattedText(playerid,  "> Завод 'K.A.C.C. military fuels'- '/gps zavod 3'" , 0,COLOUR_XP_GOOD);
			//SendPlayerFormattedText(playerid,  "> Аэродром 'Verdant Meadow Aircraft Graveyard'- '/gps kerosene 1'" , 0,COLOUR_XP_GOOD);
			//SendPlayerFormattedText(playerid,  "> Аэропорт 'Easter bay Airport'- '/gps kerosene 2'" , 0,COLOUR_XP_GOOD);
			//SendPlayerFormattedText(playerid,  "> Порт 'Ocean Docks' - '/gps kerosene 3'" , 0,COLOUR_XP_GOOD);
			return 0;
		}
		
  		if(strcomp(cmd, "dm", true) == 1)
  		{
			new iid = -1;
			new istr[128];
			set(istr,strcharsplit(text, idx,strchar(" ")));
			if(!strlen(istr))
			{
				SendPlayerFormattedText(playerid,  "Применение: /gps azs <ID>" , 0,COLOUR_RED);
				return 1;
			}
			if(strlen(istr) > 3)
			{
				SendPlayerFormattedText(playerid,  "Применение: /gps azs <ID>" , 0,COLOUR_RED);
				return 1;
			}
			if(strval(istr) < 1 || strval(istr) > DALNAZSMARKERS)
			{
				SendPlayerFormattedText(playerid,  "Неверный ID АЗС (1-16)." , 0,COLOUR_RED);
				return 1;
			}
			if(CmdTimer[playerid][Time_GPS] > 0)
			{
				new string[MAX_STRING];
				format(string,sizeof(string), "Команда будет доступна через %d сек.", CmdTimer[playerid][Time_GPS]);
				SendClientMessage(playerid, COLOUR_CRIMSON, string);
				return 1;
			}
			iid = strval(istr);
			iid = iid-1;
			new Float:X;
			new Float:Y;
			new Float:Z;
			new Float:dist;
			new Float:Angle = AnglePlayertoXY(playerid,TDMarkersPetrol[iid][Coord_X],TDMarkersPetrol[iid][Coord_Y]);

			Angle = Angle +90;
			if(Angle > 360.0) Angle = Angle - 360.0;
			if(Angle < 0) Angle = 360.0 + Angle;

			GetPlayerPos(playerid,X,Y,Z);
			dist = GetDistanceXYZtoXYZ(X,Y,Z,TDMarkersPetrol[iid][Coord_X],TDMarkersPetrol[iid][Coord_Y],TDMarkersPetrol[iid][Coord_Z]);
			PlayerArrow[playerid] = CreatePlayerObject(playerid, 1318, X, Y, 2.0 + Z, 0.0, 90.0, Angle);
			//AttachPlayerObjectToPlayer(playerid, PlayerArrow[playerid], playerid, 0.0, 0.0, 2.0, 0.0, 90.0, Angle);
			//AttachObjectToPlayer(PlayerArrow[playerid], playerid, 0.0, 0.0, 2.0, 0, 0, Angle);
			CmdTimer[playerid][Time_GPS] = 3;
			new string[MAX_STRING];
			format(string,sizeof(string), "До выбранной вами АЗС %d растояние %.0f",iid+1,dist);
			SendPlayerFormattedText(playerid,string, 0,COLOUR_XP_GOOD);
			return 1;
		}
  		if(strcomp(cmd, "oil", true) == 1)
  		{
			if(CmdTimer[playerid][Time_GPS] > 0)
			{
				new string[MAX_STRING];
				format(string,sizeof(string), "Команда будет доступна через %d сек.", CmdTimer[playerid][Time_GPS]);
				SendClientMessage(playerid, COLOUR_CRIMSON, string);
				return 1;
			}
			new iid = 0;
			new Float:X;
			new Float:Y;
			new Float:Z;
			new Float:dist;
			new Float:Angle = AnglePlayertoXY(playerid,TDLMarkersLoc[iid][Coord_X],TDLMarkersLoc[iid][Coord_Y]);

			Angle = Angle +90;
			if(Angle > 360.0) Angle = Angle - 360.0;
			if(Angle < 0) Angle = 360.0 + Angle;

			GetPlayerPos(playerid,X,Y,Z);
			dist = GetDistanceXYZtoXYZ(X,Y,Z,TDLMarkersLoc[iid][Coord_X],TDLMarkersLoc[iid][Coord_Y],TDLMarkersLoc[iid][Coord_Z]);
			PlayerArrow[playerid] = CreatePlayerObject(playerid, 1318, X, Y, 2.0 + Z, 0.0, 90.0, Angle);
			CmdTimer[playerid][Time_GPS] = 3;
			new string[MAX_STRING];
			format(string,sizeof(string), "До завода 'Green Palms' растояние %.0f",dist);
			SendPlayerFormattedText(playerid,string, 0,COLOUR_XP_GOOD);
			return 1;
		}
 		if(strcomp(cmd, "zavod", true) == 1)
  		{
			new iid = -1;
			new istr[128];
			set(istr,strcharsplit(text, idx,strchar(" ")));
			if(!strlen(istr))
			{
				SendPlayerFormattedText(playerid,  "Применение: /gps zavod <ID>" , 0,COLOUR_RED);
				return 1;
			}
			if(strlen(istr) > 3)
			{
				SendPlayerFormattedText(playerid,  "Применение: /gps zavod <ID>" , 0,COLOUR_RED);
				return 1;
			}
			if(strval(istr) < 1 || strval(istr) > 3)
			{
				SendPlayerFormattedText(playerid,  "Неверный ID Завода (1-3)." , 0,COLOUR_RED);
				return 1;
			}
			if(CmdTimer[playerid][Time_GPS] > 0)
			{
				new string[MAX_STRING];
				format(string,sizeof(string), "Команда будет доступна через %d сек.", CmdTimer[playerid][Time_GPS]);
				SendClientMessage(playerid, COLOUR_CRIMSON, string);
				return 1;
			}
			iid = strval(istr);
			iid = iid-1;
			new Float:X;
			new Float:Y;
			new Float:Z;
			new Float:dist;
			new Float:Angle = AnglePlayertoXY(playerid,TDLMarkersProces[iid][Coord_X],TDLMarkersProces[iid][Coord_Y]);

			Angle = Angle +90;
			if(Angle > 360.0) Angle = Angle - 360.0;
			if(Angle < 0) Angle = 360.0 + Angle;

			GetPlayerPos(playerid,X,Y,Z);
			dist = GetDistanceXYZtoXYZ(X,Y,Z,TDLMarkersProces[iid][Coord_X],TDLMarkersProces[iid][Coord_Y],TDLMarkersProces[iid][Coord_Z]);
			PlayerArrow[playerid] = CreatePlayerObject(playerid, 1318, X, Y, 2.0 + Z, 0.0, 90.0, Angle);
			CmdTimer[playerid][Time_GPS] = 3;
			new string[MAX_STRING];
			if(iid == 0)
			{
				format(string,sizeof(string), "До завода 'Willow field' растояние %.0f",dist);
			} else if(iid == 1)
			{
				format(string,sizeof(string), "До завода 'Easter bay chemicals' растояние %.0f",dist);
			} else
			{
				format(string,sizeof(string), "До завода 'K.A.C.C. military fuels' растояние %.0f",dist);
			}
			SendPlayerFormattedText(playerid,string, 0,COLOUR_XP_GOOD);
			return 1;
		}
 		if((strcomp(cmd, "kerosin", true) == 1) || (strcomp(cmd, "kerosene", true) == 1))
  		{
			new iid = -1;
			new istr[128];
			set(istr,strcharsplit(text, idx,strchar(" ")));
			if(!strlen(istr))
			{
				SendPlayerFormattedText(playerid,  "Применение: /gps kerosene <ID>" , 0,COLOUR_RED);
				return 1;
			}
			if(strlen(istr) > 3)
			{
				SendPlayerFormattedText(playerid,  "Применение: /gps kerosene <ID>" , 0,COLOUR_RED);
				return 1;
			}
			if(strval(istr) < 1 || strval(istr) > 3)
			{
				SendPlayerFormattedText(playerid,  "Неверный ID объекта (1-3)." , 0,COLOUR_RED);
				return 1;
			}
			if(CmdTimer[playerid][Time_GPS] > 0)
			{
				new string[MAX_STRING];
				format(string,sizeof(string), "Команда будет доступна через %d сек.", CmdTimer[playerid][Time_GPS]);
				SendClientMessage(playerid, COLOUR_CRIMSON, string);
				return 1;
			}
			iid = strval(istr);
			iid = iid-1;
			new Float:X;
			new Float:Y;
			new Float:Z;
			new Float:dist;
			new Float:Angle = AnglePlayertoXY(playerid,TDLMarkersDest[iid][Coord_X],TDLMarkersDest[iid][Coord_Y]);

			Angle = Angle +90;
			if(Angle > 360.0) Angle = Angle - 360.0;
			if(Angle < 0) Angle = 360.0 + Angle;

			GetPlayerPos(playerid,X,Y,Z);
			dist = GetDistanceXYZtoXYZ(X,Y,Z,TDLMarkersDest[iid][Coord_X],TDLMarkersDest[iid][Coord_Y],TDLMarkersDest[iid][Coord_Z]);
			PlayerArrow[playerid] = CreatePlayerObject(playerid, 1318, X, Y, 2.0 + Z, 0.0, 90.0, Angle);
			CmdTimer[playerid][Time_GPS] = 3;
			new string[MAX_STRING];
			if(iid == 0)
			{
				format(string,sizeof(string), "До объекта 'Verdant Meadow Aircraft Graveyard' растояние %.0f",dist);
			} else if(iid == 1)
			{
				format(string,sizeof(string), "До объекта 'Easter bay Airport' растояние %.0f",dist);
			} else
			{
				format(string,sizeof(string), "До объекта 'Ocean Docks' растояние %.0f",dist);
			}
			SendPlayerFormattedText(playerid,string, 0,COLOUR_XP_GOOD);
			return 1;
		}
		
  		if(strcomp(cmd, "dm", true) == 1)
  		{
			new iid = -1;
			new istr[128];
			set(istr,strcharsplit(text, idx,strchar(" ")));
			if(!strlen(istr))
			{
				SendPlayerFormattedText(playerid,  "Применение: /gps dm <ID>" , 0,COLOUR_RED);
				return 1;
			}
			if(strlen(istr) > 3)
			{
				SendPlayerFormattedText(playerid,  "Применение: /gps dm <ID>" , 0,COLOUR_RED);
				return 1;
			}
			if(strval(istr) < 1 || strval(istr) > 18)
			{
				SendPlayerFormattedText(playerid,  "Неверный ID DM (1-18)." , 0,COLOUR_RED);
				return 1;
			}
			if(CmdTimer[playerid][Time_GPS] > 0)
			{
				new string[MAX_STRING];
				format(string,sizeof(string), "Команда будет доступна через %d сек.", CmdTimer[playerid][Time_GPS]);
				SendClientMessage(playerid, COLOUR_CRIMSON, string);
				return 1;
			}
			iid = strval(istr);
			iid = iid-1;
			new Float:GPSDMs[18][CoordInfo] = { // список для ДМов
				{1887.228637,-1424.624511,10.359399}, //дм1 Peril Highness
				{-16.790000,1517.150024,12.340000}, //дм2 Area 51
				{143.547103,-1567.568237,10.764200}, //дм3 The Bad And The Ugly
				{1653.569580,-1051.173950,23.898399}, //дм4 Blue Mountains
				{2358.659912,533.559997,1.379999}, //дм5 Cargo Ship
				{621.363220,50.637401,1.421200}, //дм6 Farm Revenge
				{2486.139892,2772.600097,10.350000}, //дм7 Millitary Base
				{2197.767089,-1643.993530,14.829099}, //дм8 Minigun Madness
				{951.679992,-1355.848632,13.023400}, //дм9 Poolday
				{2786.840087,-2456.290039,13.630000}, //дм10 The US Navy
				{2015.512939,2147.693603,10.820300}, //дм11 Fight on a Hill
				{1489.034912,722.709411,10.820311}, //дм12 Batle at the Punk's House
				{1349.053466,-1280.194824,13.382800}, //дм13 Hunt in Forest
				{2095.976806,1285.144653,10.820311}, //дм14 Rendezvous
				{-2759.989013,-294.346679,6.748950}, //дм15 Rocketmania
				{-2345.421386,149.549652,34.966327}, //дм16 Paper Work
				{2721.915527,854.379516,10.898400}, //дм17 The building area
				{1088.874023,1073.765991,10.835000} //дм18 Arctic Sea
			};
			new Float:X;
			new Float:Y;
			new Float:Z;
			new Float:dist;
			new Float:Angle = AnglePlayertoXY(playerid,GPSDMs[iid][Coord_X],GPSDMs[iid][Coord_Y]);

			Angle = Angle +90;
			if(Angle > 360.0) Angle = Angle - 360.0;
			if(Angle < 0) Angle = 360.0 + Angle;

			GetPlayerPos(playerid,X,Y,Z);
			dist = GetDistanceXYZtoXYZ(X,Y,Z,GPSDMs[iid][Coord_X],GPSDMs[iid][Coord_Y],GPSDMs[iid][Coord_Z]);
			PlayerArrow[playerid] = CreatePlayerObject(playerid, 1318, X, Y, 2.0 + Z, 0.0, 90.0, Angle);
			//AttachPlayerObjectToPlayer(playerid, PlayerArrow[playerid], playerid, 0.0, 0.0, 2.0, 0.0, 90.0, Angle);
			CmdTimer[playerid][Time_GPS] = 3;
			new string[MAX_STRING];
			format(string,sizeof(string), "До выбранного вами DM %d растояние %.0f",iid+1,dist);
			SendPlayerFormattedText(playerid,string, 0,COLOUR_XP_GOOD);
			return 1;
		}
  		if(strcomp(cmd, "race", true) == 1)
  		{
			new iid1 = -1;
			new istr1[128];
			set(istr1,strcharsplit(text, idx,strchar(" ")));
			if(!strlen(istr1))
			{
				SendPlayerFormattedText(playerid,  "Применение: /gps race <ID>" , 0,COLOUR_RED);
				return 1;
			}
			if(strlen(istr1) > 3)
			{
				SendPlayerFormattedText(playerid,  "Применение: /gps race <ID>" , 0,COLOUR_RED);
				return 1;
			}
			if(strval(istr1) < 1 || strval(istr) > 27)
			{
				SendPlayerFormattedText(playerid,  "Неверный ID Гонки (1-27)." , 0,COLOUR_RED);
				return 1;
			}
			if(CmdTimer[playerid][Time_GPS] > 0)
			{
				new string[MAX_STRING];
				format(string,sizeof(string), "Команда будет доступна через %d сек.", CmdTimer[playerid][Time_GPS]);
				SendClientMessage(playerid, COLOUR_CRIMSON, string);
				return 1;
			}
			iid1 = strval(istr1);
			iid1 = iid1-1;
			new Float:GPSRaces[27][CoordInfo] = { // список для гонок
				{2046.305908,866.740417,6.515999}, //гонка1 Burnin Down The Strip
				{1557.117187,26.855699,23.884500}, //гонка2 Riverside Run
				{2227.252929,2455.298095,10.470299}, //гонка3 Flee the City
				{2156.771972,1680.312866,10.529100}, //гонка4 Lost in Smoke
				{2169.872802,2022.469238,10.351599}, //гонка5 Backstreet Bang
				{2061.448242,2215.910156,10.445300}, //гонка6 Flying Free
				{-2394.039306,-2205.217529,32.957500}, //гонка7 MurderHorn
				{1477.276855,1714.598266,10.812500}, //гонка8 Airport Round We Go
				{-1103.233276,388.674011,14.148400}, //гонка9 Strip Tease
				{2440.966796,113.509597,26.848699}, //гонка10 Monstertruck Madness
				{2412.836669,94.440902,26.844100}, //гонка11 Countryside Cruise
				{2455.341796,-1658.946166,13.108400}, //гонка12 Tearin Up The Grove 
				{1244.737182,-820.566772,83.947303}, //гонка13 Mullholland Getaway
				{1761.945312,834.752136,9.854599}, //гонка14 Julius Thruway Race
				{425.491668,2523.084716,16.353261}, //гонка15 Verdant Meadows Race
				{1713.795654,1453.996337,10.443292}, //гонка16 Majestic
				{1702.000000,-488.000000,33.669998}, //гонка17 Around San Andreas
				{-1883.945556,1055.327880,45.000000}, //гонка18 The Madball Run
				{2396.048828,-2290.309570,5.742175}, //гонка19 Underground
				{2066.433349,-2493.679199,13.721899}, //гонка20 Rustler Big Race
				{289.2637,2502.8608,17.0623}, //гонка21 Helicopter Slalom
				{-1382.333984,-141.270599,1051.272583}, //гонка22 Stadium in the Los Santos
				{-1440.340332,-672.379577,1053.308959}, //гонка23 Stadium in the Las Venturas
				{410.763397,2374.932373,25.292800}, //гонка24 Race DUNE
				{-2473.190185,-1920.880249,301.066802}, //гонка25 The Mountain bike
				{-1423.497558,914.972412,1039.615234}, //гонка26 Stadium in the SanFierro
				{-719.658813,1989.322265,-0.531893} //гонка27 Bon Voyage
			};
			new Float:X;
			new Float:Y;
			new Float:Z;
			new Float:dist;
			new Float:Angle = AnglePlayertoXY(playerid,GPSRaces[iid1][Coord_X],GPSRaces[iid1][Coord_Y]);

			Angle = Angle +90;
			if(Angle > 360.0) Angle = Angle - 360.0;
			if(Angle < 0) Angle = 360.0 + Angle;

			GetPlayerPos(playerid,X,Y,Z);
			dist = GetDistanceXYZtoXYZ(X,Y,Z,GPSRaces[iid1][Coord_X],GPSRaces[iid1][Coord_Y],GPSRaces[iid1][Coord_Z]);
			PlayerArrow[playerid] = CreatePlayerObject(playerid, 1318, X, Y, 2.0 + Z, 0.0, 90.0, Angle);
			CmdTimer[playerid][Time_GPS] = 3;
			new string[MAX_STRING];
			format(string,sizeof(string), "До выбранной вами Гонки %d растояние %.0f",iid1+1,dist);
			SendPlayerFormattedText(playerid,string, 0,COLOUR_XP_GOOD);
			return 1;
		}
	}*/

//------------------- End GPS ---
	
if(strcomp(cmd, "/*", true) == 1)
{
	if(IsPlayerRegistered(playerid) && Player[playerid][Muted] == 0)
	{
	new clubmess[MAX_STRING];
	
	set(clubmess,text);
    strdel(clubmess, 0, idx);
	
	if(!strlen(clubmess))
		{
			SendClientMessage(playerid, COLOUR_MISC,"Используйте '/* <message>'");
			return 1;
		}
	new Float:x1;
	new Float:y1;
	new Float:z1;
	new Float:xi;
	new Float:yi;
	new Float:zi;
	new Float:dist;

	GetPlayerPos(playerid,x1,y1,x1);
	format(clubmess, sizeof(clubmess)," Club: %s [id %d] %s", oGetPlayerName(playerid), playerid, clubmess);
	
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
	if(IsPlayerConnected(i) && IsPlayerRegistered(i))
	{
	GetPlayerPos(i,xi,yi,xi);
	dist = GetDistanceXYZtoXYZ(x1,y1,z1,xi,yi,zi);
	if(dist <= 15)
	{
	SendClientMessage(i, COLOUR_MISC, clubmess);
	}
	}
	}
	//format(string, sizeof(string)," -> Club: %s [id %d] %s", oGetPlayerName(playerid), playerid, clubmess);
	//SendClientMessage(playerid, COLOUR_MISC, string);
	return 1;
	}
	return 1;
}


if(strcomp(cmd,"/muted", true) == 1)
{
	if(IsPlayerConnected(playerid))
	{
		if(Player[playerid][Muted] == 0)
		{
			SendClientMessage(playerid, 0xFFFFFFFF, "А вы не наказанны!");
		} else if (Player[playerid][Muted] < 0)
		{
			SendClientMessage(playerid, 0xFFFFFFFF, "Ваше наказание автоматически снято не будет!");
		} else
		{
			new HoursNow=GetHoursFromDate();
			if(Player[playerid][Muted] == HoursNow)
			{
				SendClientMessage(playerid, COLOUR_LIGHTBLUE,"Наказание с вас снято!");
				Player[playerid][Muted]=0;
			} else if(Player[playerid][Muted] > HoursNow)
			{
				new string[MAX_STRING];
				format(string, sizeof(string), "Вам осталось еще %d час.",Player[playerid][Muted]-HoursNow);
				SendClientMessage(playerid, COLOUR_LIGHTBLUE,string);
			} else
			{
				if(Player[playerid][Muted] <= HoursNow -4380)
				{
					new string[MAX_STRING];
					format(string, sizeof(string), "Вам осталось еще %d час.", 8760-HoursNow+Player[playerid][Muted]);
					SendClientMessage(playerid, COLOUR_LIGHTBLUE,string);
					format(string, sizeof(string), "Test сейчас %d до %d час.", HoursNow, Player[playerid][Muted]);
					SendClientMessage(playerid, COLOUR_LIGHTBLUE,string);

				} else
				{
					SendClientMessage(playerid, COLOUR_LIGHTBLUE,"Наказание с вас снято!");
					Player[playerid][Muted]=0;
				}				
			}
		}
	}
	return 1;
}

if(strcomp(cmd,"/hours", true) == 1)
{
	if(IsPlayerConnected(playerid))
	{
		new HoursNow=GetHoursFromDate();
		new string[MAX_STRING];
		format(string, sizeof(string), "нынчо %d час.",HoursNow);
		SendClientMessage(playerid, COLOUR_LIGHTBLUE,string);
	}
	return 1;
}

if(strcomp(cmd, "/buble", true) == 1)
{
	if(IsPlayerRegistered(playerid))
	{
	
	new bubletext[MAX_CHATBUBBLE_LENGTH];
	
	set(bubletext,text);
    strdel(bubletext, 0, idx);
	
	if(!strlen(bubletext))
		{
			SendClientMessage(playerid, COLOUR_MISC,"Используйте '/buble <message>'");
			return 1;
		}
	
	SetPlayerChatBubble(playerid, bubletext, GetPlayerColor(playerid), 20.000, 10000);
	format(bubletext, sizeof(bubletext)," Buble: %s", bubletext);
	SendClientMessage(playerid, 0xFFFFFFFF, bubletext);
	return 1;
	}
	return 1;
}


if(strcomp(cmd, "/myskills", true) == 1)
		{
		if(!IsPlayerRegistered(playerid)) {return 1;}
	
	
	ShowPlayerDialog(playerid, WGUI+14, DIALOG_STYLE_MSGBOX, ":: Ваши навыки :::",GetGUIPlayerSkillStr(playerid), "OK", "Назад");
	/*
	new skillstring[MAX_STRING];
	SendClientMessage(playerid, COLOUR_MISC,"Ваши навыки владения оружием:");
	
	for(new i=0;i<WEAPONS_SKILLS;i++)
	{
	format(skillstring, sizeof(skillstring),"ID %d | %s  |  %d",i, SkillNames[i], PlayerWeaponsSkill[playerid][i] );
	SendClientMessage(playerid, COLOUR_MISC, skillstring);
	}
	*/
	

		return 1;
		}
		
if(strcomp(cmd,"/up", true) == 1)
	{
	    if(IsPlayerConnected(playerid))
	    {
	        if(IsPlayerInSphere(playerid, 2120.74,1233.3,9.6,14))
	        {
	            if (GetPlayerMoney(playerid) <  5000)
						{
						SendClientMessage(playerid, COLOUR_RED, "У тебя нет 5000$!");
						return 1;
						}
				oGivePlayerMoney(playerid, - 1000,0);
				new Float:xW;
				new Float:yW;
				new Float:zW;
//				if(IsPlayerInAnyVehicle(playerid))
//				{
//				GetVehiclePos(GetPlayerVehicleID(playerid), xW, yW, zW);
//				SetVehiclePosEx(GetPlayerVehicleID(playerid), xW, yW, zW + 2000);
//              }
//				else
//				{
				GetPlayerPos(playerid, xW, yW, zW);
				SetPlayerPos(playerid, xW, yW, zW + 2000);
//				}
                GivePlayerWeapon(playerid,46,5);
				SendClientMessage(playerid, 0xAA3333AA, "Прыгай! Высота 2км");
				return 1;
	        }
			return 1;
	    }
	return 1;
}

if(strcomp(cmd, "/admins", true) == 1)
{
	new string[MAX_STRING];
	new idsa=0;
	SendClientMessage(playerid, COLOUR_WHITE, lang_texts[1][28]);
	for (new id = 0; id < MAX_PLAYERS; id++)
	{
		if (IsPlayerConnected(id) && IsPlayerAdm(id)) //(IsPlayerConnected(id) && IsPlayerAdmin(id)) || 
		{
		format(string, sizeof(string), lang_texts[1][29] , oGetPlayerName(id), id);
		SendClientMessage(playerid, COLOUR_LIGHTBLUE,string);
		idsa++;
		}
	}
	for (new id = 0; id < MAX_PLAYERS; id++)
	{
		if ( IsPlayerConnected(id) && IsPlayerMod(id) )
		{
		format(string, sizeof(string), lang_texts[1][30] , oGetPlayerName(id), id);
		SendClientMessage(playerid, COLOUR_LIGHTGREEN,string);
		idsa++;
		}
	}
	if (idsa==0)
	{
	SendClientMessage(playerid, COLOUR_GREY,lang_texts[1][31]);
	}
	
	/*if(IsPlayerRegistered(playerid) && Player[playerid][Muted] == 0)
	{
	format(string,sizeof(string), lang_texts[15][29] ,oGetPlayerName(playerid),playerid);
	SendClientMessageToRegistered(COLOUR_GREY, string);
	}*/
return 1;
}
/*
if(strcomp(cmd, "/price", true) == 1)
{
	new sd[MAX_STRING];
	SendClientMessage(playerid, COLOUR_WHITE, ">>> Цены на бензин на АЗС:");
	for (new i = 0; i < DALNAZSMARKERS; i++)
	{
		format(sd, sizeof(sd),"> Бензоколонка ID%d цена покупки %d$", i+1, 2000-CmdTimerComand[i+2]);
		SendClientMessage(playerid, COLOUR_LIGHTBLUE,sd);
	}
	SendClientMessage(playerid, COLOUR_LIGHTBLUE,">>> Загруженность перерабатывающих заводов:");
	format(sd, sizeof(sd),"> Перерабатывающий завод 'Willow field' (Los Santos) заполнен на %d ед.", IsLoadZavod[0]);
	SendClientMessage(playerid, COLOUR_LIGHTBLUE,sd);
	SendClientMessage(playerid, COLOUR_LIGHTBLUE,">> Завод приобретает нефть по цене 1200$. Не продает керосин. Продает бензина по цене - 1500$");
	format(sd, sizeof(sd),"> Перерабатывающий завод 'Easter bay chemicals' (San Fierro) заполнен на %d ед.", IsLoadZavod[1]);
	SendClientMessage(playerid, COLOUR_LIGHTBLUE,sd);
	SendClientMessage(playerid, COLOUR_LIGHTBLUE,">> Завод приобретает нефть по цене 950$. Продает керосин по 1150$. Бензин - 1500$");
	format(sd, sizeof(sd),"> Перерабатывающий завод 'K.A.C.C. military fuels' (Las Venturas) заполнен на %d ед.", IsLoadZavod[2]);
	SendClientMessage(playerid, COLOUR_LIGHTBLUE,sd);
	SendClientMessage(playerid, COLOUR_LIGHTBLUE,">> Завод приобретает нефть по цене 900$. Продает керосин по 1100$. Бензин - 1500$");
	SendClientMessage(playerid, COLOUR_ORANGE,">>> Карту АЗС и заводов вы можете найти на gro-reunion.ru");

	return 1;
}*/

if(strcomp(cmd, "/fight", true) == 1)
{
//		new pointt;
//		pointt = strval(strcharsplit(text, idx,strchar(" ")));

		new tmp;
		tmp = strval(strcharsplit(text, idx,strchar(" ")));
		if (tmp < 0 || tmp > 5)
		{
		SendClientMessage(playerid, COLOUR_MISC, ">>> используйте '/fight 0-5'.");
		return 1;
		}

		if (tmp == 5)
		{ tmp = 26; }
		else if (tmp == 4)
		{ tmp = 15; }
		else if (tmp == 3)
		{ tmp = 7; }
		else if (tmp == 2)
		{ tmp = 6; }
		else if (tmp == 1)
		{ tmp = 5; }
		else
		{ tmp = 4; }

		SetPlayerFightingStyle(playerid, tmp);
		SendClientMessage(playerid, COLOUR_XP_GOOD, ">>> Вы поменяли свой стиль боя (стандартный стиль - 0)");
		return 1;
}

if(strcomp(cmd, "/tmlist", true) == 1)
{
		new tmp;
		tmp = strval(strcharsplit(text, idx,strchar(" ")));
		if(tmp < 0 || tmp > 4) {return 1;}
		SendTruckMissionList(playerid,tmp);
		return 1;
}


if(strcomp(cmd, "/trade", true) == 1)
{
	new tid = -1;
	tid = IsPlayerAtTradeCP(playerid);
	if(tid != -1)
	{ OnPlayerReadyToEnterTCP(playerid,tid);}
	return 1;
}

if(strcomp(cmd, "/nitro", true) == 1)
{
	if(CmdTimer[playerid][Time_Nitro] <= 0)
	{
	CmdTimer[playerid][Time_Nitro] = CMD_TIME;
	SetCarNitro(playerid);
	}
	else
	{
	new string[MAX_STRING];
	format(string,sizeof(string), lang_texts[9][39], cmd, CmdTimer[playerid][Time_Nitro]);
	return SendClientMessage(playerid, COLOUR_CRIMSON, string);
	}
	return 1;
}


if(strcomp(cmd, "/pitstop", true) == 1)
	{
	if(IsPlayerInAnyRace(playerid) && IsPlayerInSphere(playerid,-1403.8387,1104.1726,1040.1302,8))
	{
		if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,COLOUR_RED, lang_texts[11][9]);	
		new Float:X;
		new Float:Y;
		new Float:Z;
		new Float:Angle;
		GetPlayerPos(playerid,X,Y,Z);
		GetPlayerFacingAngle(playerid,Angle);
		SetVehiclePosEx(GetPlayerVehicleID(playerid), X, Y, Z);
		SetPlayerFacingAngle(playerid,Angle);
		AddVehicleComponent(GetPlayerVehicleID(playerid),1010);
		SetVehicleHealth(GetPlayerVehicleID(playerid),1000.0);
		return 1;
	}
	return 1;
	}

if(strcomp(cmd, "/dropammo", true) == 1)
{
	ADMDropAmmo(playerid);
	SendPlayerFormattedText(playerid, lang_texts[1][33] , 0,COLOUR_WHITE);
	CheckPlayerLevel(playerid);
return 1;
}

if(strcomp(cmd, "/repair", true) == 1)
{
	if(GetPlayerMoney(playerid) < 1000)
	{
	return SendClientMessage(playerid, COLOUR_RED, lang_texts[11][8]);
	}
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,COLOUR_RED, lang_texts[11][9]);	
 	new raceid = GetPlayerRace(playerid);
   				if(PlayerQuest[playerid] == GetRaceQuestID(raceid))
				{
					if (RaceStats[raceid][race_state] == RACE_STATE_RACING)
					{
	   	    			if(Race[raceid][race_type] == 4)
	   	    			{
	   	    			    SendClientMessage(playerid, COLOUR_RED,"[Derby]: Команда '/repair' недоступна на дерби");
							return 1;
	   	    			}
	   				}
				}
	if(CmdTimer[playerid][Time_Repair] <= 0)
	{
	CmdTimer[playerid][Time_Repair] = CMD_TIME;
	SetVehicleHealth(GetPlayerVehicleID(playerid),1000.0);
	RepairVehicle(GetPlayerVehicleID(playerid));
	oGivePlayerMoney(playerid,-1000,0);
	PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);
	SetPlayerChatBubble(playerid, "Я починил машину.", 0x505000FF, 20.000, 10000);
	return SendClientMessage(playerid,COLOUR_GREEN, lang_texts[11][10]);
	}
	else
	{
	new string[MAX_STRING];
	format(string,sizeof(string), lang_texts[9][38], CmdTimer[playerid][Time_Repair]);
	return SendClientMessage(playerid, COLOUR_CRIMSON, string);
	}
}

 if(strcomp(cmd, "/bb", true) == 1)
	{
	if(IsPlayerRegistered(playerid) && Player[playerid][Muted] == 0)
	{
		if(CmdTimer[playerid][Time_PTBB] <= 0)
		{
		CmdTimer[playerid][Time_PTBB] = CMD_TIME;
		new PlayerName[30], str[256];
		GetPlayerName(playerid, PlayerName, 30);
		format(str, 256, lang_texts[9][31] , PlayerName);
		SendClientMessageToAll(COLOUR_LIGHTBLUE, str);
		return 1;
		}
		else
		{
		new string[MAX_STRING];
		format(string,sizeof(string), lang_texts[9][39],cmd,CmdTimer[playerid][Time_PTBB]);
		return SendClientMessage(playerid, COLOUR_CRIMSON, string);
		}
	}
	return 1;
	}

 if(strcomp(cmd, "/pt", true) == 1)
	{
	if(IsPlayerRegistered(playerid) && Player[playerid][Muted] == 0)
	{
		if(CmdTimer[playerid][Time_PTBB] <= 0)
		{
		CmdTimer[playerid][Time_PTBB] = CMD_TIME;
		new PlayerName[30], str[256];
		GetPlayerName(playerid, PlayerName, 30);
		format(str, 256, lang_texts[9][32] , PlayerName);
		SendClientMessageToAll(COLOUR_ORANGE, str);
		return 1;
		}
		else
		{
		new string[MAX_STRING];
		format(string,sizeof(string), lang_texts[9][39],cmd,CmdTimer[playerid][Time_PTBB]);
		return SendClientMessage(playerid, COLOUR_CRIMSON, string);
		}
	}
	return 1;
	}
    
	if(strcomp(cmd, "/rules", true) == 1)
	{
/*   SendClientMessage(playerid, COLOUR_LIGHTBLUE, lang_texts[19][1]);
	  SendClientMessage(playerid, COLOUR_ORANGE, lang_texts[19][2]);
	  SendClientMessage(playerid, COLOUR_ORANGE, lang_texts[19][3]);
	  SendClientMessage(playerid, COLOUR_ORANGE, lang_texts[19][4]);
	  SendClientMessage(playerid, COLOUR_ORANGE, lang_texts[19][5]);
	  SendClientMessage(playerid, COLOUR_ORANGE, lang_texts[19][6]);
	  SendClientMessage(playerid, COLOUR_ORANGE, lang_texts[19][7]);
	  SendClientMessage(playerid, COLOUR_ORANGE, lang_texts[19][8]);
	  SendClientMessage(playerid, COLOUR_ORANGE, lang_texts[19][9]);
	  SendClientMessage(playerid, COLOUR_ORANGE, lang_texts[19][10]);
	  SendClientMessage(playerid, COLOUR_ORANGE, lang_texts[19][11]);
	  SendClientMessage(playerid, COLOUR_ORANGE, lang_texts[19][12]);
	  SendClientMessage(playerid, COLOUR_ORANGE, lang_texts[19][13]);
	  SendClientMessage(playerid, COLOUR_ORANGE, lang_texts[19][14]);
	  SendClientMessage(playerid, COLOUR_ORANGE, lang_texts[19][15]);
	  SendClientMessage(playerid, COLOUR_ORANGE, lang_texts[19][16]);
	  SendClientMessage(playerid, COLOUR_ORANGE, lang_texts[19][17]);
	  SendClientMessage(playerid, COLOUR_ORANGE, lang_texts[19][18]);
	 SendClientMessage(playerid, COLOUR_ORANGE, lang_texts[19][19]);
	 SendClientMessage(playerid, COLOUR_ORANGE, lang_texts[19][20]);
	 SendClientMessage(playerid, COLOUR_LIGHTBLUE, lang_texts[19][21]);
	 SendClientMessage(playerid, COLOUR_LIGHTBLUE, lang_texts[19][22]);
*/
	DialogPlayerHelp(playerid, 1);
	return 1;
	}

	
if(strcomp(cmd, "/rulesx", true) == 1)
{
	DialogPlayerHelp(playerid, 0);
	return 1;
}




if(strcomp(cmd, "/inoob", true) == 1)
	{
	DialogPlayerHelp(playerid, 3);
	return 1;

	}

/*
if(strcomp(cmd, "/cargo", true) == 1)
{
	if (IsPlayerInAnyVehicle(playerid))
	{
		if (GetVehicleModel(GetPlayerVehicleID(playerid)) == 403 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 514 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 515)
		{
			if (GetVehicleModel(GetVehicleTrailer(GetPlayerVehicleID(playerid))) == 584)
			{
				new tempz1;
				for(new f=0; f < sizeof(LoadTrailer);f++)
				{
					if(GetVehicleTrailer(GetPlayerVehicleID(playerid)) == LoadTrailer[f])
					{
						tempz1 = f;
			        	}
				}
				if (IsLoadTrailerTip[tempz1] == 1)
				{
					new s[MAX_STRING];
					format(s,sizeof(s), "В этом прицепе %d едениц нефти.", IsLoadTrailer[tempz1]);
					SendPlayerFormattedText(playerid, s, 0,COLOUR_GREEN);
					Delete3DTextLabel(TextTrailer[tempz1]);
					TextTrailer[tempz1] = Create3DTextLabel(s, 0x556B2FFF, 0.0,0.0,500.0,30.0,0,1);
					Attach3DTextLabelToVehicle(TextTrailer[tempz1],GetVehicleTrailer(GetPlayerVehicleID(playerid)),0.0,0.0,2.0);
				} else if (IsLoadTrailerTip[tempz1] == 2){
					new s[MAX_STRING];
					format(s,sizeof(s), "В этом прицепе %d едениц керосина.", IsLoadTrailer[tempz1]);
					SendPlayerFormattedText(playerid, s, 0,COLOUR_GREEN);
					Delete3DTextLabel(TextTrailer[tempz1]);
					TextTrailer[tempz1] = Create3DTextLabel(s, 0x556B2FFF, 0.0,0.0,500.0,30.0,0,1);
					Attach3DTextLabelToVehicle(TextTrailer[tempz1],GetVehicleTrailer(GetPlayerVehicleID(playerid)),0.0,0.0,2.0);
				} else if (IsLoadTrailerTip[tempz1] == 3){
					new s[MAX_STRING];
					format(s,sizeof(s), "В этом прицепе %d едениц бензина.", IsLoadTrailer[tempz1]);
					SendPlayerFormattedText(playerid, s, 0,COLOUR_GREEN);
					Delete3DTextLabel(TextTrailer[tempz1]);
					TextTrailer[tempz1] = Create3DTextLabel(s, 0x556B2FFF, 0.0,0.0,500.0,30.0,0,1);
					Attach3DTextLabelToVehicle(TextTrailer[tempz1],GetVehicleTrailer(GetPlayerVehicleID(playerid)),0.0,0.0,2.0);
				} else if (IsLoadTrailer[tempz1] == 0){
					new s[MAX_STRING];
					format(s,sizeof(s), "Это пустой прицеп.");
					SendPlayerFormattedText(playerid, s, 0,COLOUR_GREEN);
					Delete3DTextLabel(TextTrailer[tempz1]);
					TextTrailer[tempz1] = Create3DTextLabel(s, 0x556B2FFF, 0.0,0.0,500.0,30.0,0,1);
					Attach3DTextLabelToVehicle(TextTrailer[tempz1],GetVehicleTrailer(GetPlayerVehicleID(playerid)),0.0,0.0,2.0);
				} else {
					SendPlayerFormattedText(playerid,"ERROR: Ошибка в Дальнобойщике! Сообщите администратору!!!", 0,COLOR_RED);
				}

			}
		}
	}
	return 1;
}


if(strcomp(cmd, "/unload", true) == 1)
{
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,COLOUR_RED, lang_texts[11][9]);	
	if(!IsPlayerAtTDLE(playerid)) return SendClientMessage(playerid,COLOUR_RED, "Эта команда для разгрузки бензина на бензоколонке.");	
	if (GetVehicleModel(GetPlayerVehicleID(playerid)) != 403 && GetVehicleModel(GetPlayerVehicleID(playerid)) != 514 && GetVehicleModel(GetPlayerVehicleID(playerid)) != 515)
	{ // не на грузовике (если модель машины на которой приехал игрок НЕ 403 и НЕ 514 и НЕ 515)
	SendPlayerFormattedText(playerid, " Это грузовой портал. Приезжайте на грузовике с прицепом.", 0,COLOUR_GREEN);
	} else if (!IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
	{ // без прицепа
	SendPlayerFormattedText(playerid, " Это грузовой портал. Приезжайте на грузовике с прицепом 'цистерна'.", 0,COLOUR_GREEN);
	} else if (GetVehicleModel(GetVehicleTrailer(GetPlayerVehicleID(playerid))) != 584)
	{ // не с цистерной
	SendPlayerFormattedText(playerid, " Вам надо приехать с цистерной!", 0,COLOUR_GREEN);
	} else // иначе все ок
	{	
	DialogPlayerDLE(playerid); // меню разгрузки бензина
	}
	return 1;
}
*/

if ((strcomp(cmd, "/carkill", true) == 1) && GetPlayerState(playerid)==PLAYER_STATE_DRIVER)
{
SetVehicleHealth(GetPlayerVehicleID(playerid), 1.0);
new string[MAX_STRING];
format(string,sizeof(string), lang_texts[11][7] , GetPlayerVehicleID(playerid) );
SendPlayerFormattedText(playerid,string, 0,COLOUR_GREEN);
SetPlayerChatBubble(playerid, "Я убил машину.", 0x505000FF, 20.000, 10000);
return 1;
}

if(strcomp(cmd, "/heal", true) == 1)
{	
	if(GetPlayerMoney(playerid) < 2500)
	{
	return SendClientMessage(playerid, COLOUR_RED, lang_texts[9][34]);
	}
	if(IsPlayerInAnyDM(playerid) || IsPlayerInAnyZONE(playerid))
	{
	return SendClientMessage(playerid, COLOUR_CRIMSON, lang_texts[9][36]);
    }
	if(CmdTimer[playerid][Time_Heal] <= 0)
	{
	CmdTimer[playerid][Time_Heal] = CMD_TIME*3;
	oSetPlayerArmour(playerid,100);
    //SetPlayerArmour(playerid, 100);
    PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);  
    oGivePlayerMoney(playerid,-2500,0);
    SetPlayerChatBubble(playerid, "Я купил броню.", 0x505000FF, 20.000, 10000);
//	new PlayerName[30];  
//    GetPlayerName(playerid, PlayerName, 30);
	return SendClientMessage(playerid, COLOUR_GREEN, lang_texts[9][35]); 
	}
	else
	{
	new string[MAX_STRING];
	format(string,sizeof(string), lang_texts[9][37],CmdTimer[playerid][Time_Heal]);
	return SendClientMessage(playerid, COLOUR_CRIMSON, string);
	}
}
	
	if(strcomp(cmd, "/skydive", true) == 1)
	{
	if (Player[playerid][Jailed] == 1)
	{
	SendClientMessage(playerid, COLOUR_LIGHTRED, lang_texts[1][22]);
	return 1;
	}
    if(GetPlayerMoney(playerid) < 25000)
	{
	SendClientMessage(playerid, COLOUR_RED, "Вам нужно 25000 $");
	return 1;
	}
	
	if(CmdTimer[playerid][Time_Skydive] <= 0)
	{
	CmdTimer[playerid][Time_Skydive] = 4*CMD_TIME;
	new string[MAX_STRING];
	SendPlayerFormattedText(playerid, lang_texts[1][19] , 0,COLOUR_WHITE);
	new Float:playerx,Float:playery,Float:playerz;
    oGivePlayerMoney(playerid,-25000,0);
	//SendClientMessage(playerid, COLOUR_RED, "Не рекомендуется повторно вводить команду до приземления =)");
	GivePlayerWeapon(playerid,46,1);
	GetPlayerPos(playerid,playerx,playery,playerz);
	PlayerPlaySound(playerid,1057,0,0,0);
	SetPlayerPosEx(playerid,playerx,playery,playerz+1200);

//	format(string,sizeof(string), lang_texts[1][16] ,soundid);
//	SendPlayerFormattedText(playerid,string, 0,COLOUR_XP_GOOD);

	format(string,sizeof(string), lang_texts[1][20]);
	GameTextForPlayer(playerid,string,4000,5);
	if(IsPlayerRegistered(playerid) && Player[playerid][Muted] == 0)
	{
	format(string,sizeof(string), lang_texts[1][21] ,oGetPlayerName(playerid),playerid);
	SendClientMessageToRegistered(COLOUR_GREY, string);
	}
	PlayerPlaySound(playerid,1039,0,0,0);
	}
	else
	{
	new string[MAX_STRING];
	format(string,sizeof(string), lang_texts[9][39],cmd,CmdTimer[playerid][Time_Skydive]);
	return SendClientMessage(playerid, COLOUR_CRIMSON, string);
	}
	return 1;
	}

	if(strcomp(cmd, "/help", true) == 1)
	{
	  SendClientMessage(playerid, COLOUR_GREEN, lang_texts[15][1]);
   SendClientMessage(playerid, COLOUR_WHITE, lang_texts[15][2]);
	  SendClientMessage(playerid, COLOUR_LIGHTRED, lang_texts[15][3]);
	  SendClientMessage(playerid, COLOUR_WHITE, lang_texts[15][4]);
	  SendClientMessage(playerid, COLOUR_WHITE, lang_texts[15][5]);

//		for (new i=2; i<9; i++) SendPlayerScrollingText(playerid, lang_texts[15][i]);

		return 1;
	}

	if( (strcomp(cmd, "/objective", true) == 1) || (strcomp(cmd, "/info", true) == 1) )
	{
	  SendClientMessage(playerid, COLOUR_LIGHTGREEN, lang_texts[15][6]);
	  SendClientMessage(playerid, COLOUR_LIGHTGREEN, lang_texts[15][7]);
	  SendClientMessage(playerid, COLOUR_LIGHTGREEN, lang_texts[15][8]);
	  SendClientMessage(playerid, COLOUR_LIGHTGREEN, lang_texts[15][9]);
	  SendClientMessage(playerid, COLOUR_LIGHTGREEN, lang_texts[15][10]);
	  SendClientMessage(playerid, COLOUR_LIGHTGREEN, lang_texts[15][11]);
	  SendClientMessage(playerid, COLOUR_LIGHTGREEN, lang_texts[15][12]);
	  SendClientMessage(playerid, COLOUR_LIGHTGREEN, lang_texts[15][13]);

//		for (new i=10; i<17; i++) SendPlayerScrollingText(playerid, lang_texts[15][i]);

		return 1;
	}


	if(strcomp(cmd, "/commands", true) == 1)
	{
	  ShowPlayerDialog(playerid, COMMANDS_INFO_DIALOG, DIALOG_STYLE_LIST, " Пользовательские команды для:", "{596C56}Аккаунта\n{DBED15}Финансов\n{DB881A}Банд\n{BABABA}Оружия\n{8CED15}Домов\n{37DB45}Гонок\n{FF0000}Дестматчей\n{37DB45}Бизнесов\n{1B1BE0}Машин\n{DBED15}Vote System\n{15D4ED}Территории\n{DBED15}V.I.P\n{CCEEFF}Дальнобойщика\n{7340DB}Остального","Выбрать", "Выход");
	  /*SendClientMessage(playerid, COLOUR_GREY, lang_texts[15][14]);
	  SendClientMessage(playerid, COLOUR_GREY, lang_texts[15][15]);
	  SendClientMessage(playerid, COLOUR_GREY, lang_texts[15][16]);
	  SendClientMessage(playerid, COLOUR_GREY, lang_texts[15][17]);
	  SendClientMessage(playerid, COLOUR_GREY, lang_texts[15][18]);
	  SendClientMessage(playerid, COLOUR_GREY, lang_texts[15][19]);
	  SendClientMessage(playerid, COLOUR_GREY, lang_texts[15][20]);
	  SendClientMessage(playerid, COLOUR_GREY, lang_texts[15][21]);
	  SendClientMessage(playerid, COLOUR_GREY, lang_texts[15][22]);
	  SendClientMessage(playerid, COLOUR_GREY, lang_texts[15][23]);
	  SendClientMessage(playerid, COLOUR_GREY, lang_texts[15][24]);
	  SendClientMessage(playerid, COLOUR_GREY, lang_texts[15][25]);
	  SendClientMessage(playerid, COLOUR_GREY, lang_texts[15][26]);
	  SendClientMessage(playerid, COLOUR_GREY, lang_texts[15][27]);
	  SendClientMessage(playerid, COLOUR_GREY, lang_texts[15][28]);*/


//		for (new i=18; i<61; i++) SendPlayerScrollingText(playerid, lang_texts[15][i] );
//		for (new i=84; i<92; i++) SendPlayerScrollingText(playerid, lang_texts[15][i] );
		return 1;
	}
	
	if(strcomp(cmd, "/teleport", true) == 1)
	{
		if(IsPlayerAtTPC(playerid))
		{
		OnPlayerReadyToEnterTPCP(playerid);
		}
		else
		{
		SendClientMessage(playerid,COLOUR_LIGHTRED,lang_texts[9][43]);
		}
		return 1;
	}

	if((strcomp(cmd, "/stats", true) == 1) || (strcomp(cmd, "/status", true) == 1) || (strcomp(cmd, "/stat", true) == 1) || (strcomp(cmd, "/level", true) == 1))
	{
		SendPlayerStatGUI(playerid);
		return 1;
	}

/*	if((strcomp(cmd, "/stats", true) == 1) || (strcomp(cmd, "/status", true) == 1) || (strcomp(cmd, "/stat", true) == 1))
	{
		new string[MAX_STRING];
		SendClientMessage(playerid,COLOUR_GREEN,  lang_texts[15][35] );

		new sid;
		sid=Player[playerid][Status];
		if (sid>=1 && sid<=10) {format(string,sizeof(string),lang_texts[12][87],sid);}
		else if (sid>10) {format(string,sizeof(string),lang_texts[12][86],sid);}
		else {format(string,sizeof(string),lang_texts[12][88]);}
		//Status
		SendClientMessage(playerid,COLOUR_LIGHTRED,string);

		format(string, sizeof(string),  lang_texts[15][37] , GetLevelName(Player[playerid][Level]), PlayerGangName[playerid] );
		SendClientMessage(playerid,COLOUR_LIGHTBLUE,string);
		format(string, sizeof(string),  lang_texts[15][38] , Player[playerid][Level], Player[playerid][XP], Player[playerid][Money], Player[playerid][Bank], GetPlayerTotalMoney(playerid) );
		SendClientMessage(playerid,COLOUR_LIGHTBLUE,string);
		format(string, sizeof(string),  lang_texts[15][39] , Player[playerid][Deaths], Player[playerid][Kills] );
		SendClientMessage(playerid,COLOUR_LIGHTRED,string);
		return 1;
	}

	if(strcomp(cmd, "/level", true) == 1)
	{
		CheckPlayerLevel(playerid);
		new string[256];
		SendClientMessage(playerid,COLOUR_GREEN,  lang_texts[15][70] );
		format(string, sizeof(string),  lang_texts[15][71] , Player[playerid][Level]);
		SendClientMessage(playerid,COLOUR_XP_GOOD, string);
		format(string, sizeof(string),  lang_texts[15][72] , Player[playerid][XP]);
		SendClientMessage(playerid,COLOUR_XP_GOOD, string);
		if(Player[playerid][Level] == MAX_LEVEL)
		{
		format(string, sizeof(string),  lang_texts[9][45]);
		}
		else
		{
		format(string, sizeof(string),  lang_texts[15][73] , GetXPToLevel(playerid, Player[playerid][Level] + 1));
		}
		SendClientMessage(playerid,COLOUR_XP_BAD, string);
		return 1;
	}*/

	if(strcomp(cmd, "/version", true) == 1)
	{
		new string[MAX_STRING];
		SendClientMessage(playerid, COLOUR_MISC,  lang_texts[15][74] );
		format(string, sizeof(string),  lang_texts[15][75] , VERSION);
		SendClientMessage(playerid, COLOUR_GREEN,string);
		SendClientMessage(playerid, COLOUR_MISC,  lang_texts[15][76] );
		return 1;
	}

	if(strcomp(cmd, "/kill", true) == 1)
	{
		SendClientMessage(playerid, COLOUR_WHITE, lang_texts[9][33] );
		Suecid[playerid] = 1;
		SetPlayerHealth(playerid,0.0);
		return 1;
	}


if(strcomp(cmd, "/time", true) == 1)
{
new string[MAX_STRING];
new hour,minute,second;
gettime(hour,minute,second);
if ( (hour <= 9) && (minute <= 9) ) {format(string,sizeof(string),"0%d:0%d",hour,minute);}
if ( (hour <= 9) && (minute > 9) )  {format(string,sizeof(string),"0%d:%d",hour,minute);}
if ( (hour > 9) && (minute <= 9) ) {format(string,sizeof(string),"%d:0%d",hour,minute);}
if ( (hour > 9) && (minute > 9) )  {format(string,sizeof(string),"%d:%d",hour,minute);}

GameTextForPlayer(playerid,string,999,1);
//SendClientMessage(playerid, COLOUR_WHITE,string );

PlayerPlaySound(playerid,1085,0,0,0);

//format(string, sizeof(string),lang_texts[1][32], oGetPlayerName(playerid), playerid);
//SendClientMessageToAll(COLOUR_GREY, string);
return 1;
}


	if((strcomp(cmd, "/givecash", true) == 1) || (strcomp(cmd, "/sm", true) == 1))
	{
		new string[256];
		new giveplayerid, moneys;
		new sendername[MAX_PLAYER_NAME];
		new playermoney;
		new giveplayer[MAX_PLAYER_NAME];
		new tmp[256];
		tmp = strcharsplit(text, idx,strchar(" "));

		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOUR_MISC,  lang_texts[15][77] );
			return 1;
		}
		giveplayerid = strval(tmp);

		tmp = strcharsplit(text, idx,strchar(" "));
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOUR_MISC,  lang_texts[15][78] );
			return 1;
		}
		moneys = strval(tmp);

		if (IsPlayerConnected(giveplayerid))
		{
			GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
			GetPlayerName(playerid, sendername, sizeof(sendername));
			playermoney = oGetPlayerMoney(playerid);
			if (moneys > 0 && playermoney >= moneys)
			{
				oGivePlayerMoney(playerid, (0 - moneys),1);
				oGivePlayerMoney(giveplayerid, moneys,1);
				format(string, sizeof(string),  lang_texts[15][79] , giveplayer,giveplayerid, moneys);
				SendClientMessage(playerid, COLOUR_MONEY_GOOD, string);
				format(string, sizeof(string),  lang_texts[15][80] , moneys, sendername, playerid);
				SendClientMessage(giveplayerid, COLOUR_MONEY_GOOD, string);

				new logstring[256];
				format(logstring, sizeof (logstring), "%s(playerid:%d) has transfered %d to %s(playerid:%d)",sendername, playerid, moneys, giveplayer, giveplayerid);
				WriteLog(logstring);
			}
			else
			{
				SendClientMessage(playerid, COLOUR_MISC,  lang_texts[15][81] );
			}
		}
		else
		{
			format(string, sizeof(string),  lang_texts[15][82] , giveplayerid);
			SendClientMessage(playerid, COLOUR_MISC, string);
		}
		return 1;
	}
	
	if(strcomp(cmd, "/savegame", true) == 1)
	{

	if (IsPlayerRegistered(playerid))
	{
	if(CmdTimer[playerid][Time_SCommand] <= 0)
	{
	CmdTimer[playerid][Time_SCommand] = CMD_TIME*4;
	PlayerSave(playerid);
	AccountSave(playerid);
	//GangSaveAll();
	SendClientMessage(playerid, COLOUR_MISC, lang_texts[1][40]);
	}
	else
	{
	new string[MAX_STRING];
	format(string,sizeof(string), lang_texts[9][39],cmd,CmdTimer[playerid][Time_SCommand]);
	return SendClientMessage(playerid, COLOUR_CRIMSON, string);	
	}
	}
	return 1;
	}
	
	if(strcomp(cmd, "/pack-help", true) == 1) { return PackHelp(playerid); }
	if(strcomp(cmd, "/pack-info", true) == 1) { return PackInfo(playerid); }
	
	if(strcomp(cmd, "/bug", true) == 1)
	{
	new bugreport[MAX_STRING];
	
	set(bugreport,text);
    strdel(bugreport, 0, idx);
	
	if(!strlen(bugreport))
		{
			SendClientMessage(playerid, COLOUR_MISC,"Используйте '/bug <сообщение>' чтобы сообщить о баге");
			return 1;
		}
	new str[MAX_STRING];
	format(str,sizeof(str),"%s[sql:%d]: %s",oGetPlayerName(playerid),PlayerSQLID[playerid],bugreport);	
	WriteBugLog(str);
	format(str,sizeof(str),"Спасибо Вам, %s, ваше замечание будет учтено!!!",oGetPlayerName(playerid));
	SendClientMessage(playerid, COLOUR_MISC,str);
	return 1;
	}
	
 	if(!strcmp(cmd, "/plight", true) || !strcmp(cmd, "/tlight", true))
    {
		//проверка ВИП ли игрок
		if(!IsPlayerInAnyVehicle(playerid))
		{
			SendClientMessage(playerid,COLOUR_GREEN, "Вы должны быть в машине!");
			return 1;
		}
		if(GetPlayerVehicleSeat(playerid) != 0)
		{
			SendClientMessage(playerid,COLOUR_GREEN, "Вы должны быть водителем!");
			return 1;
		}
		if(!Player[playerid][Vip]) {
		SendClientMessage(playerid,COLOUR_GREEN, "Нет прав на выполнение!");
		return 0;}
		//ага всяк проверки пройдены

		for(new i= 0;i<sizeof(exception);i++)
		{
			if(exception[i] == GetVehicleModel(GetPlayerVehicleID(playerid)))
			{
				SendClientMessage(playerid,-1,"На этот транспорт нельзя установить этот объект.");
				return 1;
			}
		}
		new Float:x,Float:y,Float:z;

		GetVehicleModelInfo(GetVehicleModel(GetPlayerVehicleID(playerid)), VEHICLE_MODEL_INFO_SIZE, x, y, z);
		if(obj1[playerid] != 0)	{DestroyObject(obj1[playerid]);}
		if(obj2[playerid] != 0)	{DestroyObject(obj2[playerid]);}
		if(obj3[playerid] != 0)	{DestroyObject(obj3[playerid]);}
		if(obj4[playerid] != 0)	{DestroyObject(obj4[playerid]);}

		if(!strcmp(cmd, "/plight", true))
		{
			for(new i=0; i < MAX_PLAYERS; i++)
			{
				if(TypeObjectCar[i] == GetPlayerVehicleID(playerid))
				{
					if(obj1[i] != 0)
					{
						DestroyObject(obj1[i]);
						obj1[i] = 0;
					}
					if(obj2[i] != 0)
					{
						DestroyObject(obj2[i]);
						obj2[i] = 0;
					}
					if(obj3[i] != 0)
					{
						DestroyObject(obj3[i]);
						obj3[i] = 0;
					}
					if(obj4[i] != 0)
					{
						DestroyObject(obj4[i]);
						obj4[i] = 0;
					}
				}

			}
			if(TypeObject[playerid] != 19419)
			{
				TypeObject[playerid] = 19419;
				TypeObjectCar[playerid] = GetPlayerVehicleID(playerid);
				obj1[playerid] = CreateObject(19419, 0.0, 0.0,0.0, 0.0, 0.0, 0.0);
				z = z/2;
				y = 0.0; //вращение по оси Z
			} else
			{
				TypeObject[playerid] = 19420;
				TypeObjectCar[playerid] = GetPlayerVehicleID(playerid);
				obj1[playerid] = CreateObject(19420, 0.0, 0.0,0.0, 0.0, 0.0, 0.0);
				z = z/2;
				y = 0.0; //вращение по оси Z

			}
		}
		else
		{
			for(new i=0; i< MAX_PLAYERS; i++)
			{
				if(TypeObjectCar[i] == GetPlayerVehicleID(playerid))
				{
					if(obj1[i] != 0)
					{
						DestroyObject(obj1[i]);
						obj1[i] = 0;
					}
					if(obj2[i] != 0)
					{
						DestroyObject(obj2[i]);
						obj2[i] = 0;
					}
					if(obj3[i] != 0)
					{
						DestroyObject(obj3[i]);
						obj3[i] = 0;
					}
					if(obj4[i] != 0)
					{
						DestroyObject(obj4[i]);
						obj4[i] = 0;
					}
				}

			}
			TypeObject[playerid] = 19308;
			TypeObjectCar[playerid] = GetPlayerVehicleID(playerid);
			obj1[playerid] = CreateObject(19308, 0.0, 0.0,0.0, 0.0, 0.0, 0.0);
			z = z/2+0.1;
			y = 90.0; //вращение по оси Z
		}
		for(new i= 0;i<sizeof(cars11);i++)
		{
			if(cars11[i] == GetVehicleModel(GetPlayerVehicleID(playerid)))
			{
				AttachObjectToVehicle(obj1[playerid],GetPlayerVehicleID(playerid),0.0,0.1,z-0.1, 0.0, 0.0, y);
				SendClientMessage(playerid,-1,"Установлено");
				return 1;
			}
		}
		for(new i= 0;i<sizeof(cars21);i++)
		{
			if(cars21[i] == GetVehicleModel(GetPlayerVehicleID(playerid)))
			{
				AttachObjectToVehicle(obj1[playerid],GetPlayerVehicleID(playerid),0.0,0.2,z-0.1, 0.0, 0.0, y);
				SendClientMessage(playerid,-1,"Установлено");
				return 1;
			}
		}
		for(new i= 0;i<sizeof(cars31);i++)
		{
			if(cars31[i] == GetVehicleModel(GetPlayerVehicleID(playerid)))
			{
				AttachObjectToVehicle(obj1[playerid],GetPlayerVehicleID(playerid),0.0,0.3,z-0.1, 0.0, 0.0, y);
				SendClientMessage(playerid,-1,"Установлено");
				return 1;
			}
		}
		for(new i= 0;i<sizeof(cars70);i++)
		{
			if(cars70[i] == GetVehicleModel(GetPlayerVehicleID(playerid)))
			{
				AttachObjectToVehicle(obj1[playerid],GetPlayerVehicleID(playerid),0.0,0.7,z, 0.0, 0.0, y);
				SendClientMessage(playerid,-1,"Установлено");
				return 1;
			}
		}
		for(new i= 0;i<sizeof(cars72);i++)
		{
			if(cars72[i] == GetVehicleModel(GetPlayerVehicleID(playerid)))
			{
				AttachObjectToVehicle(obj1[playerid],GetPlayerVehicleID(playerid),0.0,0.7,z-0.2, 0.0, 0.0, y);
				SendClientMessage(playerid,-1,"Установлено");
				return 1;
			}
		}
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 433)
		{
	    	AttachObjectToVehicle(obj1[playerid],GetPlayerVehicleID(playerid),0.0,1.4,1.6, 0.0, 0.0, y);
       		SendClientMessage(playerid,-1,"Установлено");
			return 1;
		}
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 456)
		{
	        AttachObjectToVehicle(obj1[playerid],GetPlayerVehicleID(playerid),0.0,1.5,1.2, 0.0, 0.0, y);
       		SendClientMessage(playerid,-1,"Установлено");
			return 1;
		}
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 515)
		{
	        AttachObjectToVehicle(obj1[playerid],GetPlayerVehicleID(playerid),0.0,0.0,1.4, 0.0, 0.0, y);
       		SendClientMessage(playerid,-1,"Установлено");
			return 1;
		}
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 578)
		{
	        AttachObjectToVehicle(obj1[playerid],GetPlayerVehicleID(playerid),0.0,3.6,1.4, 0.0, 0.0, y);
       		SendClientMessage(playerid,-1,"Установлено");
			return 1;
		}
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 428)
		{
	        AttachObjectToVehicle(obj1[playerid],GetPlayerVehicleID(playerid),0.0,1.1,1.4, 0.0, 0.0, y);
       		SendClientMessage(playerid,-1,"Установлено");
			return 1;
		}
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 508)
		{
	        AttachObjectToVehicle(obj1[playerid],GetPlayerVehicleID(playerid),0.0,2.0,1.6, 0.0, 0.0, y);
       		SendClientMessage(playerid,-1,"Установлено");
			return 1;
		}
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 431)
		{
	        AttachObjectToVehicle(obj1[playerid],GetPlayerVehicleID(playerid),0.0,5.5,2.1, 0.0, 0.0, y);
       		SendClientMessage(playerid,-1,"Установлено");
			return 1;
		}
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 437)
		{
	        AttachObjectToVehicle(obj1[playerid],GetPlayerVehicleID(playerid),0.0,5.3,2.0, 0.0, 0.0, y);
       		SendClientMessage(playerid,-1,"Установлено");
			return 1;
		}
		AttachObjectToVehicle(obj1[playerid],GetPlayerVehicleID(playerid),0.0,0.0,z, 0.0, 0.0, y);
		SendClientMessage(playerid,-1,"Установлено");
		return 1;
	}
    if(!strcmp(cmd, "/llight", true))
    {
		//проверка ВИП ли игрок
		if(!IsPlayerInAnyVehicle(playerid))
		{
			SendClientMessage(playerid,COLOUR_GREEN, "Вы должны быть в машине!");
			return 1;
		}
		if(GetPlayerVehicleSeat(playerid) != 0)
		{
			SendClientMessage(playerid,COLOUR_GREEN, "Вы должны быть водителем!");
			return 1;
		}
		if(!Player[playerid][Vip]) {
		SendClientMessage(playerid,COLOUR_GREEN, "Нет прав на выполнение!");
		return 0;}
		//ага всяк проверки пройдены
        for(new i= 0;i<sizeof(exception);i++)
        {
            if(exception[i] == GetVehicleModel(GetPlayerVehicleID(playerid)))
            {
                SendClientMessage(playerid,-1,"На этот транспорт нельзя установить свет.");
                return 1;
            }
        }
		for(new i=0; i < MAX_PLAYERS; i++)
		{
			if(TypeObjectCar[i] == GetPlayerVehicleID(playerid))
			{
				if(obj1[i] != 0)
				{
					DestroyObject(obj1[i]);
					obj1[i] = 0;
				}
				if(obj2[i] != 0)
				{
					DestroyObject(obj2[i]);
					obj2[i] = 0;
				}
				if(obj3[i] != 0)
				{
					DestroyObject(obj3[i]);
					obj3[i] = 0;
				}
				if(obj4[i] != 0)
				{
					DestroyObject(obj4[i]);
					obj4[i] = 0;
				}
			}

		}

		new Float:x,Float:y,Float:z;

        GetVehicleModelInfo(GetVehicleModel(GetPlayerVehicleID(playerid)), VEHICLE_MODEL_INFO_SIZE, x, y, z);
		if(obj1[playerid] != 0)	{DestroyObject(obj1[playerid]);}
		if(obj2[playerid] != 0)	{DestroyObject(obj2[playerid]);}
		if(obj3[playerid] != 0)	{DestroyObject(obj3[playerid]);}
		if(obj4[playerid] != 0)	{DestroyObject(obj4[playerid]);}
		TypeObject[playerid] = 19280;
        obj1[playerid] = CreateObject(19280, 0.0, 0.0,0.0, 0.0, 0.0, 0.0);
        obj2[playerid] = CreateObject(19280, 0.0, 0.0,0.0, 0.0, 0.0, 0.0);
        obj3[playerid] = CreateObject(19280, 0.0, 0.0,0.0, 0.0, 0.0, 0.0);
        obj4[playerid] = CreateObject(19280, 0.0, 0.0,0.0, 0.0, 0.0, 0.0);
		TypeObjectCar[playerid] = GetPlayerVehicleID(playerid);
		z = z/2;
		for(new i= 0;i<sizeof(cars11);i++)
		{
			if(cars11[i] == GetVehicleModel(GetPlayerVehicleID(playerid)))
			{
				AttachObjectToVehicle(obj1[playerid],GetPlayerVehicleID(playerid),0.6,0.1,z-0.1, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(obj2[playerid],GetPlayerVehicleID(playerid),0.2,0.1,z-0.1, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(obj3[playerid],GetPlayerVehicleID(playerid),-0.2,0.1,z-0.1, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(obj4[playerid],GetPlayerVehicleID(playerid),-0.6,0.1,z-0.1, 0.0, 0.0, 0.0);
				SendClientMessage(playerid,-1,"Установлено");
				return 1;
			}
		}
		for(new i= 0;i<sizeof(cars21);i++)
		{
			if(cars21[i] == GetVehicleModel(GetPlayerVehicleID(playerid)))
			{
				AttachObjectToVehicle(obj1[playerid],GetPlayerVehicleID(playerid),0.6,0.2,z-0.1, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(obj2[playerid],GetPlayerVehicleID(playerid),0.2,0.2,z-0.1, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(obj3[playerid],GetPlayerVehicleID(playerid),-0.2,0.2,z-0.1, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(obj4[playerid],GetPlayerVehicleID(playerid),-0.6,0.2,z-0.1, 0.0, 0.0, 0.0);
				SendClientMessage(playerid,-1,"Установлено");
				return 1;
			}
		}
		for(new i= 0;i<sizeof(cars31);i++)
		{
			if(cars31[i] == GetVehicleModel(GetPlayerVehicleID(playerid)))
			{
				AttachObjectToVehicle(obj1[playerid],GetPlayerVehicleID(playerid),0.6,0.3,z-0.1, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(obj2[playerid],GetPlayerVehicleID(playerid),0.2,0.3,z-0.1, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(obj3[playerid],GetPlayerVehicleID(playerid),-0.2,0.3,z-0.1, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(obj4[playerid],GetPlayerVehicleID(playerid),-0.6,0.3,z-0.1, 0.0, 0.0, 0.0);
				SendClientMessage(playerid,-1,"Установлено");
				return 1;
			}
		}
		for(new i= 0;i<sizeof(cars70);i++)
		{
			if(cars70[i] == GetVehicleModel(GetPlayerVehicleID(playerid)))
			{
				AttachObjectToVehicle(obj1[playerid],GetPlayerVehicleID(playerid),0.6,0.7,z, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(obj2[playerid],GetPlayerVehicleID(playerid),0.2,0.7,z, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(obj3[playerid],GetPlayerVehicleID(playerid),-0.2,0.7,z, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(obj4[playerid],GetPlayerVehicleID(playerid),-0.6,0.7,z, 0.0, 0.0, 0.0);
				SendClientMessage(playerid,-1,"Установлено");
				return 1;
			}
		}
		for(new i= 0;i<sizeof(cars72);i++)
		{
			if(cars72[i] == GetVehicleModel(GetPlayerVehicleID(playerid)))
			{
				AttachObjectToVehicle(obj1[playerid],GetPlayerVehicleID(playerid),0.6,0.7,z-0.2, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(obj2[playerid],GetPlayerVehicleID(playerid),0.2,0.7,z-0.2, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(obj3[playerid],GetPlayerVehicleID(playerid),-0.2,0.7,z-0.2, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(obj4[playerid],GetPlayerVehicleID(playerid),-0.6,0.7,z-0.2, 0.0, 0.0, 0.0);
				SendClientMessage(playerid,-1,"Установлено");
				return 1;
			}
		}
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 433)
		{
	        AttachObjectToVehicle(obj1[playerid],GetPlayerVehicleID(playerid),0.6,1.4,1.6, 0.0, 0.0, 0.0);
	        AttachObjectToVehicle(obj2[playerid],GetPlayerVehicleID(playerid),0.2,1.4,1.6, 0.0, 0.0, 0.0);
	        AttachObjectToVehicle(obj3[playerid],GetPlayerVehicleID(playerid),-0.2,1.4,1.6, 0.0, 0.0, 0.0);
	        AttachObjectToVehicle(obj4[playerid],GetPlayerVehicleID(playerid),-0.6,1.4,1.6, 0.0, 0.0, 0.0);
       		SendClientMessage(playerid,-1,"Установлено");
			return 1;
		}
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 456)
		{
	   	    AttachObjectToVehicle(obj1[playerid],GetPlayerVehicleID(playerid),0.6,1.5,1.2, 0.0, 0.0, 0.0);
	       	AttachObjectToVehicle(obj2[playerid],GetPlayerVehicleID(playerid),0.2,1.5,1.2, 0.0, 0.0, 0.0);
	        AttachObjectToVehicle(obj3[playerid],GetPlayerVehicleID(playerid),-0.2,1.5,1.2, 0.0, 0.0, 0.0);
	        AttachObjectToVehicle(obj4[playerid],GetPlayerVehicleID(playerid),-0.6,1.5,1.2, 0.0, 0.0, 0.0);
			SendClientMessage(playerid,-1,"Установлено");
			return 1;
		}
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 515)
		{
	        AttachObjectToVehicle(obj1[playerid],GetPlayerVehicleID(playerid),0.6,0.0,1.4, 0.0, 0.0, 0.0);
	        AttachObjectToVehicle(obj2[playerid],GetPlayerVehicleID(playerid),0.2,0.0,1.4, 0.0, 0.0, 0.0);
	        AttachObjectToVehicle(obj3[playerid],GetPlayerVehicleID(playerid),-0.2,0.0,1.4, 0.0, 0.0, 0.0);
	        AttachObjectToVehicle(obj4[playerid],GetPlayerVehicleID(playerid),-0.6,0.0,1.4, 0.0, 0.0, 0.0);
       		SendClientMessage(playerid,-1,"Установлено");
			return 1;
		}
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 578)
		{
	        AttachObjectToVehicle(obj1[playerid],GetPlayerVehicleID(playerid),0.6,3.6,1.4, 0.0, 0.0, 0.0);
	        AttachObjectToVehicle(obj2[playerid],GetPlayerVehicleID(playerid),0.2,3.6,1.4, 0.0, 0.0, 0.0);
	        AttachObjectToVehicle(obj3[playerid],GetPlayerVehicleID(playerid),-0.2,3.6,1.4, 0.0, 0.0, 0.0);
	        AttachObjectToVehicle(obj4[playerid],GetPlayerVehicleID(playerid),-0.6,3.6,1.4, 0.0, 0.0, 0.0);
       		SendClientMessage(playerid,-1,"Установлено");
			return 1;
		}
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 428)
		{
	        AttachObjectToVehicle(obj1[playerid],GetPlayerVehicleID(playerid),0.6,1.1,1.4, 0.0, 0.0, 0.0);
	        AttachObjectToVehicle(obj2[playerid],GetPlayerVehicleID(playerid),0.2,1.1,1.4, 0.0, 0.0, 0.0);
	        AttachObjectToVehicle(obj3[playerid],GetPlayerVehicleID(playerid),-0.2,1.1,1.4, 0.0, 0.0, 0.0);
	        AttachObjectToVehicle(obj4[playerid],GetPlayerVehicleID(playerid),-0.6,1.1,1.4, 0.0, 0.0, 0.0);
       		SendClientMessage(playerid,-1,"Установлено");
			return 1;
		}
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 508)
		{
	        AttachObjectToVehicle(obj1[playerid],GetPlayerVehicleID(playerid),0.6,2.0,1.6, 0.0, 0.0, 0.0);
	        AttachObjectToVehicle(obj2[playerid],GetPlayerVehicleID(playerid),0.2,2.0,1.6, 0.0, 0.0, 0.0);
	        AttachObjectToVehicle(obj3[playerid],GetPlayerVehicleID(playerid),-0.2,2.0,1.6, 0.0, 0.0, 0.0);
	        AttachObjectToVehicle(obj4[playerid],GetPlayerVehicleID(playerid),-0.6,2.0,1.6, 0.0, 0.0, 0.0);
       		SendClientMessage(playerid,-1,"Установлено");
			return 1;
		}
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 431)
		{
	        AttachObjectToVehicle(obj1[playerid],GetPlayerVehicleID(playerid),0.6,5.5,2.1, 0.0, 0.0, 0.0);
	        AttachObjectToVehicle(obj2[playerid],GetPlayerVehicleID(playerid),0.2,5.5,2.1, 0.0, 0.0, 0.0);
	        AttachObjectToVehicle(obj3[playerid],GetPlayerVehicleID(playerid),-0.2,5.5,2.1, 0.0, 0.0, 0.0);
	        AttachObjectToVehicle(obj4[playerid],GetPlayerVehicleID(playerid),-0.6,5.5,2.1, 0.0, 0.0, 0.0);
       		SendClientMessage(playerid,-1,"Установлено");
			return 1;
		}
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 437)
		{
	        AttachObjectToVehicle(obj1[playerid],GetPlayerVehicleID(playerid),0.6,5.3,2.0, 0.0, 0.0, 0.0);
	        AttachObjectToVehicle(obj2[playerid],GetPlayerVehicleID(playerid),0.2,5.3,2.0, 0.0, 0.0, 0.0);
	        AttachObjectToVehicle(obj3[playerid],GetPlayerVehicleID(playerid),-0.2,5.3,2.0, 0.0, 0.0, 0.0);
	        AttachObjectToVehicle(obj4[playerid],GetPlayerVehicleID(playerid),-0.6,5.3,2.0, 0.0, 0.0, 0.0);
       		SendClientMessage(playerid,-1,"Установлено");
			return 1;
		}
        AttachObjectToVehicle(obj1[playerid],GetPlayerVehicleID(playerid),0.6,0.0,z, 0.0, 0.0, 0.0);
        AttachObjectToVehicle(obj2[playerid],GetPlayerVehicleID(playerid),0.2,0.0,z, 0.0, 0.0, 0.0);
        AttachObjectToVehicle(obj3[playerid],GetPlayerVehicleID(playerid),-0.2,0.0,z, 0.0, 0.0, 0.0);
        AttachObjectToVehicle(obj4[playerid],GetPlayerVehicleID(playerid),-0.6,0.0,z, 0.0, 0.0, 0.0);
   		SendClientMessage(playerid,-1,"Установлено");
        return 1;
    }
    if(!strcmp(cmd, "/dellight", true))
    {
		if(obj1[playerid] != 0)
		{
			DestroyObject(obj1[playerid]);
			obj1[playerid] = 0;
		}
		if(obj2[playerid] != 0)
		{
			DestroyObject(obj2[playerid]);
			obj2[playerid] = 0;
		}
		if(obj3[playerid] != 0)
		{
			DestroyObject(obj3[playerid]);
			obj3[playerid] = 0;
		}
		if(obj4[playerid] != 0)
		{
			DestroyObject(obj4[playerid]);
			obj4[playerid] = 0;
		}
		TypeObject[playerid] = 0;
		TypeObjectCar[playerid] = -1;
        return 1;
    }
    if(!strcmp(cmd, "/hydraulic", true))
    {
		//проверка ВИП ли игрок
		if(!IsPlayerInAnyVehicle(playerid))
		{
			SendClientMessage(playerid,COLOUR_GREEN, "Вы должны быть в машине!");
			return 1;
		}
		if(GetPlayerVehicleSeat(playerid) != 0)
		{
			SendClientMessage(playerid,COLOUR_GREEN, "Вы должны быть водителем!");
			return 1;
		}
		if(GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_HYDRAULICS) == 1087)
		{
			SendClientMessage(playerid,-1,"На этой машине есть гидравлика.");
			return 1;
		}
		if(!Player[playerid][Vip]) {
		SendClientMessage(playerid,COLOUR_GREEN, "Нет прав на выполнение!");
		return 0;}
		//ага всяк проверки пройдены
		AddVehicleComponent(GetPlayerVehicleID(playerid), 1087);
   		SendClientMessage(playerid,-1,"Установлено");
		return 1;
    }
    if(!strcmp(cmd, "/attachments", true))
    {
		//проверка ВИП ли игрок
		if(Player[playerid][Vip] <= 1)
		{
			SendClientMessage(playerid,COLOUR_GREEN, "Нет прав на выполнение!");
			return 0;
		}
		//ага всяк проверки пройдены
  		new string[MAX_STRING];
		//PlayerAttachmentsObj[playerid][GetPVarInt(playerid, "AttachmentIndexSel")][amodelid]=0;
		//RemovePlayerAttachedObject(playerid, GetPVarInt(playerid, "AttachmentIndexSel"));
		for(new x;x<MAX_PLAYER_ATTACHED_OBJECTS;x++)
		{
 			if(IsPlayerAttachedObjectSlotUsed(playerid, x)) format(string, sizeof(string), "%s%d (занято)\n", string, x);
   			else format(string, sizeof(string), "%s%d\n", string, x);
		}
		ShowPlayerDialog(playerid, DIALOG_ATTACH_INDEX_SELECTION, DIALOG_STYLE_LIST, "{FF0000}Добавление объекта - Выбор слота", string, "Выбрать", "Выход");
        return 1;
 	}
 	
	if(strcomp(cmd, "/upgrade", true) == 1)
	{

	    if(GetPlayerLevel(playerid) < 40)
	    {
	        ShowPlayerDialog(playerid, S_GUI_02, 0,"Upgrade account","Для прокачки 2 уровня VIP'a необходимо прокачать аккаунт до 40 уровня","ОК","");
	        return 1;
	    }
	
	    if(Player[playerid][Vip] == 0)
	    {
	        ShowPlayerDialog(playerid, S_GUI_02, 0,"Upgrade account","Для прокачки 2 уровня VIP'a необходимо получить 1-ый уровень VIP'a \nПервый уровень VIP'a достаточно легко выполнить, для этого необходимо собрать 50 скрытых пакетов '/pack-help' ","ОК","");
	        return 1;
		}
	
 		if(Player[playerid][Vip] == 5)
	    {
	        ShowPlayerDialog(playerid, S_GUI_02, 0,"Upgrade account","У тебя максимальный уровень VIP'a!","ОК","");
	        return 1;
		}
	
		if(GetPlayerMoney(playerid) < 5000000)
	 	{
			ShowPlayerDialog(playerid, S_GUI_02, 0,"Upgrade account","У Вас недостаточно средств для обнуления аккаунта! ( $ 5.000.000 )","ОК","");
			return 1;
		}

        oGivePlayerMoney(playerid,-5000000,1); // берем залог

        new sd[MAX_STRING];
        new name[MAX_PLAYER_NAME];
    	GetPlayerName(playerid, name, sizeof(name));

		if(Player[playerid][Vip] == 1)
		{
			Player[playerid][Level] = 0;
			Player[playerid][XP] = 0;
		    Player[playerid][Vip] = 2;
    		format(sd,sizeof(sd), " [VIP] Игрок %s[%d] выполнил обнуление и получил %d-ой уровень VIP'a! Поздравляем!",name,playerid,Player[playerid][Vip]);
			SendClientMessageToAll(COLOUR_YELLOW, sd);
			
			Player[playerid][XP]=GetPlayerXP(playerid);
			CheckPlayerLevel(playerid);
			
		    return 1;
		}
		
		if(Player[playerid][Vip] == 2)
		{
			Player[playerid][Level] = 0;
			Player[playerid][XP] = 0;
		    Player[playerid][Vip] = 3;
    		format(sd,sizeof(sd), " [VIP] Игрок %s[%d] выполнил обнуление и получил %d-ой уровень VIP'a! Поздравляем!",name,playerid,Player[playerid][Vip]);
			SendClientMessageToAll(COLOUR_YELLOW, sd);
			Player[playerid][XP]=GetPlayerXP(playerid);
			CheckPlayerLevel(playerid);
		    return 1;
		}
		
		if(Player[playerid][Vip] == 3)
		{
			Player[playerid][Level] = 0;
			Player[playerid][XP] = 0;
		    Player[playerid][Vip] = 4;
    		format(sd,sizeof(sd), " [VIP] Игрок %s[%d] выполнил обнуление и получил %d-ой уровень VIP'a! Поздравляем!",name,playerid,Player[playerid][Vip]);
			SendClientMessageToAll(COLOUR_YELLOW, sd);
			Player[playerid][XP]=GetPlayerXP(playerid);
			CheckPlayerLevel(playerid);
		    return 1;
		}
		
		if(Player[playerid][Vip] == 4)
		{
			Player[playerid][Level] = 0;
			Player[playerid][XP] = 0;
		    Player[playerid][Vip] = 5;
    		format(sd,sizeof(sd), " [VIP] Игрок %s[%d] выполнил обнуление и получил %d-ой уровень VIP'a! Поздравляем!",name,playerid,Player[playerid][Vip]);
			SendClientMessageToAll(COLOUR_YELLOW, sd);
			Player[playerid][XP]=GetPlayerXP(playerid);
			CheckPlayerLevel(playerid);
		    return 1;
		}

		return 1;
	}
 	
	if(strcomp(cmd, "/vip", true) == 1)
	{
 		new helpstr[1800];
	    new comstr[128];
  		format(comstr,sizeof(comstr), "VIP system:");
   		strins(helpstr, "{ffffff}VIP система представляет собой привелегии, позволяющие иметь персонажу уникальные возможности перед другими игроками.\n", strlen(helpstr));
	    strins(helpstr, "{ffffff}Доступно {596C56}5 уровней VIP{ffffff}. VIP может получить каждый игрок выполняя нижеуказанные требования.\n\n", strlen(helpstr));
	    strins(helpstr, "1-ый уровень: Доступен личный транспорт. '/mycar help'. Необходимо собрать 50 скрытых пакетов.\n", strlen(helpstr));
	    strins(helpstr, "2-ой уровень: Доступно сохранение военного транспорта как личное авто. Необходимо прокачаться до 40 уровня и выполнить обнуление.\n", strlen(helpstr));
	    strins(helpstr, "3-ий уровень: Доступно регенирация брони. Необходимо прокачаться до 40 уровня и выполнить обнуление.\n", strlen(helpstr));
	    strins(helpstr, "4-ый уровень: Доступен пассивный режим (Бессмертие). Необходимо прокачаться до 40 уровня и выполнить обнуление.\n", strlen(helpstr));
	    strins(helpstr, "5-ый уровень: Доступно ТП по клику на карте. Необходимо прокачаться до 40 уровня и выполнить обнуление.\n\n", strlen(helpstr));
	    strins(helpstr, "Это базовые привелегии который получает каждый игрок при прокачке VIP'a, есть и уникальный способности.\n", strlen(helpstr));
	    strins(helpstr, "Способности так-же открываются при прокачке VIP уровня.\n", strlen(helpstr));
	    strins(helpstr, "Доступна возможность покупки каких либо привелегии. Информация {EE82EE}'/donat'\n", strlen(helpstr));
     	ShowPlayerDialog(playerid, S_GUI_02, DIALOG_STYLE_MSGBOX, comstr, helpstr,"OK", "");
		return 1;
	}
	
	if(strcomp(cmd, "/changeskin", true) == 1)
	{
		if(Player[playerid][Vip] < 1)
		{
		    SendClientMessage(playerid, COLOUR_RED, " [CLOTHES] Необходимо получить 1-ый уровень VIP");
			return 1;
		}
	    ShowModelSelectionMenu(playerid, skinlist, "Select Skin");
	    return 1;
	}
	
	if(strcomp(cmd, "/radio", true) == 1)
	{
	    ShowPlayerDialog(playerid,RADIO,DIALOG_STYLE_LIST, "Радиоприемник","[1] Radio Зайцев-FM\n[2] Radio Record\n[3] Radio Europa-Plus\n[4] Radio Energy-FM\nВыключить радио","Включить","Отмена");
		return 1;
	}
	
	if(strcomp(cmd, "/donat", true) == 1)
	{
 		new helpstr[1800];
	    new comstr[128];
  		format(comstr,sizeof(comstr), "Donat system:");
   		strins(helpstr, "{ffffff}Предварительные расценки:\n\n", strlen(helpstr));
	    strins(helpstr, "1. VIP 2-го уровня = 350 р.\n", strlen(helpstr));
	    strins(helpstr, "2. VIP 3-го уровня = 450 р.\n", strlen(helpstr));
	    strins(helpstr, "3. Оригинальный цвет банды = 150 р.\n", strlen(helpstr));
	    strins(helpstr, "4. Скилы = 100 р за скилл*.\n", strlen(helpstr));
	    strins(helpstr, "5. Смена никнэйма = 150 р.\n", strlen(helpstr));
	    strins(helpstr, "6: Деньги - $ 2.000.000 = 150 р.\n", strlen(helpstr));
	    strins(helpstr, "7: Разбан тюрьмы, IP и муты = 150 р.\n\n", strlen(helpstr));
	    strins(helpstr, "МИНИМАЛЬНАЯ СУММА покупки — 100 руб.\n", strlen(helpstr));
	    strins(helpstr, "Внимания! Избегайте мошейничества. Покупку может осуществить только руководитель проекта {ADD8E6}Rishat\n", strlen(helpstr));
	    strins(helpstr, "{ffffff}Связь VK (Гайсин Ришат): {ADD8E6}www.vk.com/rishat1c\n", strlen(helpstr));
	    strins(helpstr, "{ffffff}Связь через группу VK: www.vk.com/gto_reunion\n\n", strlen(helpstr));
	    strins(helpstr, "Кошелек WebMoney: {DBED15}R173681406925\n", strlen(helpstr));
	    strins(helpstr, "{ffffff}Кошелек Yandex: {DBED15}410014231695602\n", strlen(helpstr));
     	ShowPlayerDialog(playerid, S_GUI_02, DIALOG_STYLE_MSGBOX, comstr, helpstr,"OK", "");
		return 1;
	}
 	
  	if(strcomp(cmd,"/debug", true) == 1)
  	{
  		if ( !IsPlayerMod(playerid) && !IsPlayerAdmin(playerid) && !IsPlayerAdm(playerid) )
		{
			return 1;
		}
        PlayerDebug[playerid] = PlayerDebug[playerid] ? 0 : 1;
        SendDebugMessage(playerid, 0xFF0000FF, "Player %d debug mode ON", playerid);
        return 1;
    }
 	
 	//
	if(strcomp(cmd, "/events", true) == 1)
	{
 	new string[1024]; format(string, 1024, "Тип\tНаименование\tИгроков\tСтатус\n");
    new timer[128];
	new dmfound;
	
 	gettime(hourE,minuteE,secondE);
 	
	if(Player[playerid][train1] == 1)
	{
	    ShowPlayerDialog(playerid, S_GUI_02, 0,"Миссия Дальнобойщика","Для начала завершите миссию дальнобойщика","ОК","");
	    return 1;
	}
 	
 	new str_num = 0;
 	
 	for (new dmid=1; dmid<=DMCount;dmid++)
 	{
 		if ((DeathmatchStats[dmid][dm_state] == DM_STATE_LINEUP) || (DeathmatchStats[dmid][dm_state] == DM_STATE_ACTIVE))
     	{
         	if (dmfound == 0)
         	{
          		dmfound++;
         	}
         	dialog_select[playerid][str_num][action_code] = EVENT_DMJOIN;
			dialog_select[playerid][str_num][action_parameters] = dmid;
			str_num++;
			if(Deathmatch[dmid][dm_type] == 1)
         	{
         	    if(DeathmatchStats[dmid][dm_state] == DM_STATE_ACTIVE) {
          			if (DeathmatchStats[dmid][dm_playercount] >= Deathmatch[dmid][dm_minplayers])
         			{
         				format(string, sizeof(string),  "%s\n{FF0000}Зомби-Выживание\t '%s'\t %d\t{F08080}[активно]\n" ,string,Deathmatch[dmid][dm_name],DeathmatchStats[dmid][dm_playercount],Deathmatch[dmid][dm_lineupdelay] - DeathmatchStats[dmid][dm_timer]);
					}
					else
					{
				    	format(string, sizeof(string),  "%s\n{FF0000}Зомби-Выживание\t '%s'\t %d/%d\t{F08080}[активно]\n" ,string,Deathmatch[dmid][dm_name],DeathmatchStats[dmid][dm_playercount],Deathmatch[dmid][dm_minplayers],Deathmatch[dmid][dm_lineupdelay] - DeathmatchStats[dmid][dm_timer]);
					}
				} else {
 					if (DeathmatchStats[dmid][dm_playercount] >= Deathmatch[dmid][dm_minplayers])
         			{
         				format(string, sizeof(string),  "%s\n{FF0000}Зомби-Выживание\t '%s'\t %d\t[до старта %d секунд]\n" ,string,Deathmatch[dmid][dm_name],DeathmatchStats[dmid][dm_playercount],Deathmatch[dmid][dm_lineupdelay] - DeathmatchStats[dmid][dm_timer]);
					}
					else
					{
				    	format(string, sizeof(string),  "%s\n{FF0000}Зомби-Выживание\t '%s'\t %d/%d\t[до старта %d секунд]\n" ,string,Deathmatch[dmid][dm_name],DeathmatchStats[dmid][dm_playercount],Deathmatch[dmid][dm_minplayers],Deathmatch[dmid][dm_lineupdelay] - DeathmatchStats[dmid][dm_timer]);
					}
				}
			}
         	else if(Deathmatch[dmid][dm_team] == 1)
         	{
         	    if(DeathmatchStats[dmid][dm_state] == DM_STATE_ACTIVE) {
          			if (DeathmatchStats[dmid][dm_playercount] >= Deathmatch[dmid][dm_minplayers])
         			{
         				format(string, sizeof(string),  "%s\n{9370DB}Командный Десматч\t '%s'\t %d\t{F08080}[активно]\n" ,string,Deathmatch[dmid][dm_name],DeathmatchStats[dmid][dm_playercount],Deathmatch[dmid][dm_lineupdelay] - DeathmatchStats[dmid][dm_timer]);
					}
					else
					{
				    	format(string, sizeof(string),  "%s\n{9370DB}Командный Десматч\t '%s'\t %d/%d\t{F08080}[активно]\n" ,string,Deathmatch[dmid][dm_name],DeathmatchStats[dmid][dm_playercount],Deathmatch[dmid][dm_minplayers],Deathmatch[dmid][dm_lineupdelay] - DeathmatchStats[dmid][dm_timer]);
					}
				} else {
 					if (DeathmatchStats[dmid][dm_playercount] >= Deathmatch[dmid][dm_minplayers])
         			{
         				format(string, sizeof(string),  "%s\n{9370DB}Командный Десматч\t '%s'\t %d\t[до старта %d секунд]\n" ,string,Deathmatch[dmid][dm_name],DeathmatchStats[dmid][dm_playercount],Deathmatch[dmid][dm_lineupdelay] - DeathmatchStats[dmid][dm_timer]);
					}
					else
					{
				    	format(string, sizeof(string),  "%s\n{9370DB}Командный Десматч\t '%s'\t %d/%d\t[до старта %d секунд]\n" ,string,Deathmatch[dmid][dm_name],DeathmatchStats[dmid][dm_playercount],Deathmatch[dmid][dm_minplayers],Deathmatch[dmid][dm_lineupdelay] - DeathmatchStats[dmid][dm_timer]);
					}
				}
			}
   			else
   			{
   				if(DeathmatchStats[dmid][dm_state] == DM_STATE_ACTIVE) {
     				if (DeathmatchStats[dmid][dm_playercount] >= Deathmatch[dmid][dm_minplayers])
         			{
    					format(string, sizeof(string),  "%s\n{EE82EE}Десматч\t '%s'\t %d\t{F08080}[активно]\n" ,string,Deathmatch[dmid][dm_name],DeathmatchStats[dmid][dm_playercount],Deathmatch[dmid][dm_lineupdelay] - DeathmatchStats[dmid][dm_timer]);
					}
					else
					{
				    	format(string, sizeof(string),  "%s\n{EE82EE}Десматч\t '%s'\t %d/%d\t{F08080}[активно]\n" ,string,Deathmatch[dmid][dm_name],DeathmatchStats[dmid][dm_playercount],Deathmatch[dmid][dm_minplayers],Deathmatch[dmid][dm_lineupdelay] - DeathmatchStats[dmid][dm_timer]);
					}
				} else {
					if (DeathmatchStats[dmid][dm_playercount] >= Deathmatch[dmid][dm_minplayers])
         			{
    					format(string, sizeof(string),  "%s\n{EE82EE}Десматч\t '%s'\t %d\t[до старта %d секунд]\n" ,string,Deathmatch[dmid][dm_name],DeathmatchStats[dmid][dm_playercount],Deathmatch[dmid][dm_lineupdelay] - DeathmatchStats[dmid][dm_timer]);
					}
					else
					{
				    	format(string, sizeof(string),  "%s\n{EE82EE}Десматч\t '%s'\t %d/%d\t[до старта %d секунд]\n" ,string,Deathmatch[dmid][dm_name],DeathmatchStats[dmid][dm_playercount],Deathmatch[dmid][dm_minplayers],Deathmatch[dmid][dm_lineupdelay] - DeathmatchStats[dmid][dm_timer]);
					}
				}
			}
     	}
	}
	//
 	new racefound;
 	for (new raceid=1; raceid<=RacesCount;raceid++)
 	{
     	if (RaceStats[raceid][race_state] == RACE_STATE_LINEUP)
     	{
         	if (racefound == 0)
         	{
          		racefound++;
         	}
         	dialog_select[playerid][str_num][action_code] = EVENT_RACEJOIN;
			dialog_select[playerid][str_num][action_parameters] = raceid;
			str_num++;
   		 	if(Race[raceid][race_type] == 3)
	 		{
         		if (RaceStats[raceid][race_racercount] >= Race[raceid][race_minracers])
         		{
             		format(string, sizeof(string),  "%s\n{ADD8E6}Авиагонка\t '%s'\t %d [Место: '%s']\t[до старта %d секунд]\n" ,string,Race[raceid][race_name],RaceStats[raceid][race_racercount],GetRaceCPZoneName(raceid,0),Race[raceid][race_minlevel],Race[raceid][race_cashentry],Race[raceid][race_lineupdelay] - RaceStats[raceid][race_timer]);
				}
   				else
   				{
    				format(string, sizeof(string),  "%s\n{ADD8E6}Авиагонка\t '%s'\t %d/%d [Место: '%s']\t[до старта %d секунд]\n" ,string,Race[raceid][race_name],RaceStats[raceid][race_racercount],Race[raceid][race_minracers],GetRaceCPZoneName(raceid,0),Race[raceid][race_lineupdelay] - RaceStats[raceid][race_timer]);
   				}
			}
			else if(Race[raceid][race_type] == 4)
			{
 				if (RaceStats[raceid][race_racercount] >= Race[raceid][race_minracers])
         		{
             		format(string, sizeof(string),  "%s\n{FFFF00}Дерби\t '%s'\t %d [Место: '%s']\t[до старта %d секунд]\n" ,string,Race[raceid][race_name],RaceStats[raceid][race_racercount],GetRaceCPZoneName(raceid,0),Race[raceid][race_lineupdelay] - RaceStats[raceid][race_timer]);
				}
   				else
   				{
    				format(string, sizeof(string),  "%s\n{FFFF00}Дерби\t '%s'\t %d/%d [Место: '%s']\t[до старта %d секунд]\n" ,string,Race[raceid][race_name],RaceStats[raceid][race_racercount],Race[raceid][race_minracers],GetRaceCPZoneName(raceid,0),Race[raceid][race_lineupdelay] - RaceStats[raceid][race_timer]);
   				}
			}
			else if(Race[raceid][race_type] == 5)
			{
 				if (RaceStats[raceid][race_racercount] >= Race[raceid][race_minracers])
         		{
             		format(string, sizeof(string),  "%s\n{DA70D6}Мульти-гонка\t '%s'\t %d [Место: '%s']\t[до старта %d секунд]\n" ,string,Race[raceid][race_name],RaceStats[raceid][race_racercount],GetRaceCPZoneName(raceid,0),Race[raceid][race_lineupdelay] - RaceStats[raceid][race_timer]);
				}
   				else
   				{
    				format(string, sizeof(string),  "%s\n{DA70D6}Мульти-гонка\t '%s'\t %d/%d [Место: '%s']\t[до старта %d секунд]\n" ,string,Race[raceid][race_name],RaceStats[raceid][race_racercount],Race[raceid][race_minracers],GetRaceCPZoneName(raceid,0),Race[raceid][race_lineupdelay] - RaceStats[raceid][race_timer]);
   				}
			}
			else
			{
 				if (RaceStats[raceid][race_racercount] >= Race[raceid][race_minracers])
         		{
             		format(string, sizeof(string),  "%s\n{228B22}Гонка\t '%s'\t %d [Место: '%s']\t[до старта %d секунд]\n" ,string,Race[raceid][race_name],RaceStats[raceid][race_racercount],GetRaceCPZoneName(raceid,0),Race[raceid][race_lineupdelay] - RaceStats[raceid][race_timer]);
				}
   				else
   				{
    				format(string, sizeof(string),  "%s\n{228B22}Гонка\t '%s'\t %d/%d [Место: '%s']\t[до старта %d секунд]\n" ,string,Race[raceid][race_name],RaceStats[raceid][race_racercount],Race[raceid][race_minracers],GetRaceCPZoneName(raceid,0),Race[raceid][race_lineupdelay] - RaceStats[raceid][race_timer]);
   				}
			}
 		}
 	}
 	if (dmfound == 0 && racefound == 0)
 	{
 		format(string, sizeof(string),  "%s\nДоступных \tсоревнований \tнет\n" ,string);
 	}
 	format(timer, sizeof(timer),  "Активные соревнования [%d:%d:%d]" ,hourE,minuteE,secondE);
	ShowPlayerDialog(playerid, EGUI, DIALOG_STYLE_TABLIST_HEADERS, timer, string, "Выбрать", "Отмена");
	SetPlayerChatBubble(playerid, "Открыл меню соревнований...", COLOR_BLUE, 20.0, 2000);
	return 1;
	}
 	//
 	
	return 0;
}

forward PlayerGetEvents(playerid,listitem);
public PlayerGetEvents(playerid,listitem)
{
	if(!(listitem > -1 && listitem < MAX_LISTITEMS)) { return 0; }
	switch (dialog_select[playerid][listitem][action_code]) {
	case EVENT_RACEJOIN:
	{
		if (PlayerQuest[playerid] != 0)
   		{
    		SendPlayerFormattedText(playerid, lang_texts[10][18] , 0,COLOUR_RED);
    		return 1;
   		}
   		if ((dialog_select[playerid][listitem][action_parameters] == 0) || (dialog_select[playerid][listitem][action_parameters] >= MAX_RACES))
   		{
    		SendPlayerFormattedText(playerid, lang_texts[10][19] , 0,COLOUR_RED);
    		return 1;
   		}
   		if (RaceStats[dialog_select[playerid][listitem][action_parameters]][race_state] == RACE_STATE_DISABLED)
   		{
    		SendPlayerFormattedText(playerid, lang_texts[10][20] , 0,COLOUR_RED);
    		return 1;
   		}
   		if (RaceStats[dialog_select[playerid][listitem][action_parameters]][race_state] == RACE_STATE_RACING)
   		{
    		SendPlayerFormattedText(playerid, lang_texts[10][21] , 0,COLOUR_RED);
    		return 1;
   		}
   		if (RaceStats[dialog_select[playerid][listitem][action_parameters]][race_state] != RACE_STATE_LINEUP)
   		{
    		SendPlayerFormattedText(playerid, lang_texts[10][22] , 0,COLOUR_RED);
    		return 1;
   		}
   		
   		if(Race[dialog_select[playerid][listitem][action_parameters]][race_type] != 4)
  		{
  		    new isset = GetPlayerVehicleSeat(playerid);
  			if(!IsPlayerInAnyVehicle(playerid) || isset != 0 )
   			{
    			ShowPlayerDialog(playerid, R_GUI, 0,"Race security","Вы должны находиться в транспорте для телепортации к месту гонки!","ОК","Эвенты");
				return 1;
   			}
   		}
		JoinRace(dialog_select[playerid][listitem][action_parameters], playerid);
	}
	case EVENT_DMJOIN :
	{
 		if (PlayerQuest[playerid] != 0)
   		{
    		SendPlayerFormattedText(playerid, lang_texts[4][55] , 0,COLOUR_RED);
    		return 1;
   		}
   		if ((dialog_select[playerid][listitem][action_parameters] == 0) || (dialog_select[playerid][listitem][action_parameters] >= MAX_DM))
   		{
    		SendPlayerFormattedText(playerid, lang_texts[4][56] , 0,COLOUR_RED);
    		return 1;
   		}
   		if (DeathmatchStats[dialog_select[playerid][listitem][action_parameters]][dm_state] == DM_STATE_DISABLED)
   		{
    		SendPlayerFormattedText(playerid, lang_texts[4][57] , 0,COLOUR_RED);
    		return 1;
		}
   		if ((DeathmatchStats[dialog_select[playerid][listitem][action_parameters]][dm_state] != DM_STATE_LINEUP) && (DeathmatchStats[dialog_select[playerid][listitem][action_parameters]][dm_state] != DM_STATE_ACTIVE))
   		{
    		SendPlayerFormattedText(playerid, lang_texts[4][58] , 0,COLOUR_RED);
    		return 1;
   		}
   		if ((Deathmatch[dialog_select[playerid][listitem][action_parameters]][dm_activedmjoin] == 0) && (DeathmatchStats[dialog_select[playerid][listitem][action_parameters]][dm_state] == DM_STATE_ACTIVE))
   		{
    		SendPlayerFormattedText(playerid, lang_texts[4][59] , 0,COLOUR_RED);
    		return 1;
   		}
	    JoinDM(playerid,dialog_select[playerid][listitem][action_parameters]);
	}
	}
	return 1;
}

dcmd_pm(playerid, params[])
{
//	if (Player[playerid][Muted] == 0)
//	{
		new id;
		new mess[MAX_STRING];
		if (sscanf(params, "us", id, mess))
		{
			SendClientMessage(playerid, ADMINFS_MESSAGE_COLOR, "Usage: /pm <playerid> <message>");
			return 1;
		}
			      
		if(!IsPlayerConnected(id))
		{
			SendClientMessage(playerid,ADMINFS_MESSAGE_COLOR,"PM: Bad player ID");
			return 1;
		}
		
		if(playerid != id)
		{
		
		for(new i=0;i<PM_BAD_SLOTS_MAX;i++)
		{
			if(strcomp(PlayerPMBlack[id][i],oGetPlayerName(playerid),true) == 1)
			{SendClientMessage(playerid,ADMINFS_MESSAGE_COLOR,"PM: Sorry! You in black list!"); return 1;}
		}
			new message[256];

			format(message,sizeof(message),"PM to %s[%d]: %s",oGetPlayerName(id),id,mess);
			SendClientMessage(playerid,PM_OUTGOING_COLOR,message);
			
			format(message,sizeof(message),"PM from %s[%d]: %s",oGetPlayerName(playerid),playerid,mess);
			SendClientMessage(id,PM_INCOMING_COLOR,message);
			
			PlayerPlaySound(id,1085,0.0,0.0,0.0);
			
			printf("PM: %s to %s: %s",oGetPlayerName(playerid),oGetPlayerName(id), mess);
			
		}
		else
		{
			SendClientMessage(playerid,ADMINFS_MESSAGE_COLOR,"You cannot PM yourself");
		}
		return 1;
/*	}
	else
	{
		SendClientMessage(playerid,ADMINFS_MESSAGE_COLOR,"You cannot PM when you muted");
		return 1;
	}*/
}

public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid,Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ,Float:fRotX, Float:fRotY, Float:fRotZ,Float:fScaleX, Float:fScaleY, Float:fScaleZ )
{
	if(fOffsetX > 2 || fOffsetY > 2 || fOffsetZ > 2 || fScaleX > 2 || fScaleY > 2 || fScaleZ > 2)
	{
	    SendClientMessage(playerid, COLOUR_RED, "ОШИБКА! Неверные параметры объекта.");
		EditAttachedObject(playerid, index);
		return 0;
	}
	PlayerAttachmentsObj[playerid][index][amodelid]=modelid;
	PlayerAttachmentsObj[playerid][index][aboneid]=boneid;
	PlayerAttachmentsObj[playerid][index][aOffsetX]=fOffsetX;
	PlayerAttachmentsObj[playerid][index][aOffsetY]=fOffsetY;
	PlayerAttachmentsObj[playerid][index][aOffsetZ]=fOffsetZ;
	PlayerAttachmentsObj[playerid][index][aRotX]=fRotX;
	PlayerAttachmentsObj[playerid][index][aRotY]=fRotY;
	PlayerAttachmentsObj[playerid][index][aRotZ]=fRotZ;
	PlayerAttachmentsObj[playerid][index][aScaleX]=fScaleX;
	PlayerAttachmentsObj[playerid][index][aScaleY]=fScaleY;
	PlayerAttachmentsObj[playerid][index][aScaleZ]=fScaleZ;
    SetPlayerAttachedObject(playerid,index,modelid,boneid,fOffsetX,fOffsetY,fOffsetZ,fRotX,fRotY,fRotZ,fScaleX,fScaleY,fScaleZ);
    new string[MAX_STRING];
    for(new x=0;x<MAX_PLAYER_ATTACHED_OBJECTS;x++)
	{
	    if(IsPlayerAttachedObjectSlotUsed(playerid, x)) format(string, sizeof(string), "%s%d (занято)\n", string, x);
	    else format(string, sizeof(string), "%s%d\n", string, x);
	}
	ShowPlayerDialog(playerid, DIALOG_ATTACH_INDEX_SELECTION, DIALOG_STYLE_LIST, "{FF0000}Добавление объекта - Выбор слота", string, "Выбрать", "Выход");
    return 1;
}

public OnPlayerModelSelection(playerid, response, listid, modelid)
{
	if(listid == skinlist)
	{
	    if(response)
	    {
			if(GetPlayerMoney(playerid) < 50000)
			{
				return SendClientMessage(playerid, COLOUR_RED, lang_texts[11][14]);
			}
		    SendClientMessage(playerid, COLOUR_GREEN, " [CLOTHES] Поздравляю с попкупкой скина!");
	    	SetPlayerSkin(playerid, modelid);
	    	Player[playerid][SkinModel] = modelid;
	    	oGivePlayerMoney(playerid,-50000,0);
	    }
	    else SendClientMessage(playerid, COLOUR_RED, " [CLOTHES] Вы покинули меню выбора скина");
    	return 1;
	}
	return 1;
}
