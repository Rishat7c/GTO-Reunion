//TransformeR GameMode made by Lomt1k

/*-------------------------------
На протяжение 2,5 лет я разрабатывал этот игровой мод.
Его работоспособность проверена на тысячах игроков.
Этот мод был главным фокусом моей жизни.

За 2,5 года из быдлокодера я превратился
в довольно опытного программиста. Поэтому
качество кода очень сильно различается
в разных местах. Все самые важные нюансы
уже были оптимизированы.

Мод полностью уникален и написан с нуля.
Хотя используется несколько готовых инлкюдов
типа mSelection, lookup и mxINI.

Также используются плагины sscanf2 и streamer.
Не забудь подключить их перед запуском сервера,
если ты скачал чистую версию мода.
Без этих плагинов мод работать не будет.

Теперь мод в твоих руках. Бесплатно.
Желаю удачи в твоих начинаниях :)

			Lomt1k, Jule 03, 2015
-------------------------------*/

#include <a_samp>
#include <mxINI>
#include <Dini>
#include <sscanf2>
#include <streamer>
#include <foreach> //циклы для игроков
#include <mSelection> //0.3х меню
#include <GetVehicleColor> //Функция GetVehicleColor(vehicleid, &color1, &color2);
#include <LDate>//Функции для работы с датой
#include <cp> //Новые функции для работы с чекпоинтами

#include "lookup"//определение города и страны по IP
/*  GetPlayerHost(playerid)
	GetPlayerISP(playerid)
	GetPlayerCountryCode(playerid)
	GetPlayerCountryName(playerid)
	GetPlayerCountryRegion(playerid)
	IsProxyUser(playerid) // Returns true if a proxy is detected

	public OnLookupComplete(playerid) срабатывает как только определяется местоположение (Скоро после коннекта) */

#pragma tabsize 0//Чтобы не было варнингов loose indentation

new MenuMyskin = mS_INVALID_LISTID;//для меню myskin
new MenuFirstCar = mS_INVALID_LISTID;//для меню выбора первого авто
new MenuClass1 = mS_INVALID_LISTID;//для меню выбора avto Class1
new MenuClass2 = mS_INVALID_LISTID;//для меню выбора avto Class2
new MenuClass3 = mS_INVALID_LISTID;//для меню выбора avto Class3
new MenuBuyGun = mS_INVALID_LISTID;//для меню оруж. магазина
new MenuPaintJob = mS_INVALID_LISTID;//для меню выбора avto с PaintJob
new MenuPrestigeCars = mS_INVALID_LISTID;//для меню выбора авто (престиж)

#undef MAX_PLAYERS
#define MAX_PLAYERS 150
new MaxVehicleUsed = 0;//Динамическое значение с максимальным существующим ID авто (для циклов)
new MaxPlayerID = 0;//Максимальный ид игрока на сервере. Используется например для рандомного выбора зомби

#define MAX_PROPERTY 501 //Максимум домов. Указывается на 1 больше
#define MAX_BASE 101 //Максимум штабов. Указывается на 1 больше
#define MAX_CLAN 501 //Максимум кланов. Указывается на 1 больше
new MaxClanID = 0;//чтобы если всего 15 кланов, то не делать цикл на 10 000, а делать на 15

#define SERVER_NAME "TransformeR DM" //Название сервера, отображаемое при подключении.
#define GAMEMODE_NAME "TransformeR DM" //Название мода, отображаемое в окне SAMP
#define MAX_PING 250 //Максимально допустимый пинг

//#define MAX_ACTORS 5 //Максимум NPC-актеров
new Actor[MAX_ACTORS];

#define MAX_STRING 255
#define MAX_FILE_NAME 64
#define MAX_MESSAGE 180
#define MAX_DIALOG_INFO 500
#define MAX_PASSWORD 24
#define MAX_3DTEXT 255

#define DIALOG_LOGIN 0
#define DIALOG_REGISTER 1
#define DIALOG_OTHER 25000

#define DIALOG_TUTORIAL 100
#define DIALOG_MYSPAWN 101
#define DIALOG_MYSPAWN2 102
#define DIALOG_MYGUN 103
#define DIALOG_MYGUN1 104
#define DIALOG_MYGUN2 105
#define DIALOG_MYGUN3 106
#define DIALOG_MYGUN4 107
#define DIALOG_MYGUN5 108
#define DIALOG_MYGUN6 109
#define DIALOG_MYGUN7 110
#define DIALOG_MYGUN8 111
#define DIALOG_MYGUN10 112
#define DIALOG_STYLE 113
#define DIALOG_BANK 114
#define DIALOG_BANKTO 115
#define DIALOG_BANKFROM 116
#define DIALOG_HOUSEMENU 117
#define DIALOG_HOUSEMENUPRICE 118
#define DIALOG_CLANCREATE 119
#define DIALOG_CLANCREATECOLOR 120
#define DIALOG_CLANCREATENAME 121
#define DIALOG_CLANMENU 122
//#define DIALOG_CLANBANK 123
#define DIALOG_CLANEXIT 124
#define DIALOG_TABMENU 125
//#define DIALOG_TABPM 126
#define DIALOG_TABGIVECASH 127
#define DIALOG_CLANMANAGER 128
#define DIALOG_CLANCOLOR 129
#define DIALOG_CLANENTERNAME 130
#define DIALOG_CLANDESTROY 131
#define DIALOG_BASEMENU 132
#define DIALOG_INVISIBLE 133
#define DIALOG_CASINORULET 134
#define DIALOG_CASINORULETBETSIZE 135
#define DIALOG_CASINORULETBETNUMBER 136
#define DIALOG_AIRPORT 137
//#define DIALOG_C4 138
#define DIALOG_STEALCAR 139
#define DIALOG_STEALWATERCAR 140
#define DIALOG_GGSHOP 141
#define DIALOG_SKILLS 142
#define DIALOG_STEALAIRCAR 143
#define DIALOG_CLANENTER 144
#define DIALOG_CLANMESSAGE 145
#define DIALOG_SKILLCHANGE 146
#define DIALOG_PAINTJOB 147
#define DIALOG_PRESTIGE 148
//#define DIALOG_STARTTUTORIAL 149
//#define DIALOG_SKILLCHANGE2 150
#define DIALOG_PRESTIGECAR 151
//#define DIALOG_WORKCAPTAIN 152
//#define DIALOG_WORKPILOT 153
//#define DIALOG_CODE 154
#define DIALOG_HELP 155
#define DIALOG_HELPFAQ 156
#define DIALOG_HELPCMD 157
#define DIALOG_HELPMES 158
#define DIALOG_PVP 159
#define DIALOG_PVPMAP 160
#define DIALOG_PVPWEAPON 161
#define DIALOG_PVPHEALTH 162
//#define DIALOG_PVPCASH 163
#define DIALOG_CONFIG 164
#define DIALOG_CHANGEPASS 165
//#define DIALOG_CHANGEPASS2 166
#define DIALOG_CHANGENICK 167
#define DIALOG_CHANGENICK2 168
#define DIALOG_MYWEATHER 169
#define DIALOG_MYWEATHER2 170
//#define DIALOG_REFERAL 171
#define DIALOG_HELPLVL 172
#define DIALOG_PRESTIGEGM 173
#define DIALOG_ACHANGE 174
#define DIALOG_ACHANGEDM 175
#define DIALOG_ACHANGEDERBY 176
#define DIALOG_ACHANGEFR 177
#define DIALOG_ACHANGEFR2 178
new ACHANGEFR[MAX_PLAYERS];
#define DIALOG_ACHANGEZM 179
//#define DIALOG_ACHANGETDM 180
#define DIALOG_ACHANGEGG 181
#define DIALOG_ACHANGEXR 182
#define DIALOG_TURBOSPEED 183
#define DIALOG_TURBOSPEEDDELETE 184
#define DIALOG_TURBOSPEEDNITRO 185
#define DIALOG_TURBOSPEEDNEON 186
#define DIALOG_GPS 187
#define DIALOG_GPSTUNE 188
#define DIALOG_GPSWORK 189
#define DIALOG_WORKGRUZSTOP 190
#define DIALOG_WORKSTOP 191
#define DIALOG_LEAVEZM 192
//#define DIALOG_LEAVETDM 193
#define DIALOG_CLANRENAME 194
#define DIALOG_BASEMENUPRICE 195
#define DIALOG_ACTION 196
#define DIALOG_CHATNAME 197
#define DIALOG_PRESTIGECOLOR 198
#define DIALOG_QUESTS 199
#define DIALOG_MEDALTRADE 200
#define DIALOG_ACTIVESKILLPERSON 201
#define DIALOG_ACTIVESKILLCAR1 202
#define DIALOG_ACTIVESKILLCAR2 203
#define DIALOG_ACTIVESKILLHCAR1 204
#define DIALOG_ACTIVESKILLHCAR2 205
#define DIALOG_SELLHOUSE 206
#define DIALOG_SELLBASE 207

#include "Transformer\Colors"
#define COLOR_CLAN 0x008E00FF //iauee oaao aey nenoaiu eeaia

//Удержание одной клавиши: if (HOLDING( KEY_FIRE ))
//Удержание нескольких клавиш: if (HOLDING( KEY_FIRE | KEY_CROUCH ))
#define HOLDING(%0) \
	((newkeys & (%0)) == (%0))
//Нажатие одной клавиши: if (PRESSED( KEY_FIRE ))
//Нажатие нескольких клавиш: if (PRESSED( KEY_FIRE | KEY_CROUCH ))
#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
//Отпускание одной клавиши: if (RELEASED( KEY_FIRE ))
//Отпускание нескольких клавиш: if (RELEASED( KEY_FIRE | KEY_CROUCH ))
#define RELEASED(%0) \
	(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))


//vortex nitro
new countpos[MAX_PLAYERS];
new Flame[MAX_PLAYERS][2];

new XReg[MAX_PLAYERS] = 0;
new Registered[MAX_PLAYERS];
new Errors[MAX_PLAYERS];
new Logged[MAX_PLAYERS];
new PropertyPickup[MAX_PROPERTY];
new PropertyMapIcon[MAX_PROPERTY];
new BasePickup[MAX_BASE];
new BaseMapIcon[MAX_BASE];
new LAFK[MAX_PLAYERS];
new ClickedPid[MAX_PLAYERS] = -1;
new ClanFunks[MAX_PLAYERS];

new CreateClanColor[MAX_PLAYERS];
new PlayerColor[MAX_PLAYERS];
new AntiPlus[MAX_PLAYERS]= -1;
new AdminTPCantKill[MAX_PLAYERS] = 0;
new Float: LastPlayerX[MAX_PLAYERS], Float: LastPlayerY[MAX_PLAYERS], Float: LastPlayerZ[MAX_PLAYERS];//Местоположение игрока секунду назад
new LastPlayerTuneStatus[MAX_PLAYERS], TunesPerSecond[MAX_PLAYERS];//для античита на телепорт при въезде выезде из тюнинга
new Float: LastPlayerSHX[MAX_PLAYERS], Float: LastPlayerSHY[MAX_PLAYERS], Float: LastPlayerSHZ[MAX_PLAYERS];//Местоположение игрока пол секунды назад для спидометра

new LastProperty = 1, OwnedProperty = 0, SuperProperty = 0;
new LastBase = 1, OwnedBase = 0;
new RestartDate[32];
new Year, Month, Day, hour,minute,second; //текущие дата и время
new pKick[MAX_PLAYERS] = 0;

new Text3D:PropertyText3D[MAX_PROPERTY];
new Text3D:BaseText3D[MAX_BASE];

new PlayerPass[MAX_PLAYERS][30];//пароль игрока
new BannedBy[MAX_PLAYERS][25], BanReason[MAX_PLAYERS][41], MutedBy[MAX_PLAYERS][25];
new InviteClan[MAX_PLAYERS], InviteTime[MAX_PLAYERS] = -1;
new UGTime = 300;
new ServerWeather, PlayerWeather[MAX_PLAYERS] = -1, PlayerTime[MAX_PLAYERS] = -1;
new InPeacefulZone[MAX_PLAYERS];//Для мирных зон
new GPSUsed[MAX_PLAYERS];//Принадлежит ли активный у игрока чекпоинт к системе GPS
new ChatName[MAX_PLAYERS][100];//ник для чата
new FirstSobeitCheck[MAX_PLAYERS], FirstSobeitCheckTimer[MAX_PLAYERS], Text:BlackScreen;//Первичная проверка на собейт после конекта

new WorkPizzaID[MAX_PLAYERS], WorkPizzaCP[MAX_PLAYERS], WorkPizzaCPs[MAX_PLAYERS];//Работа доставщика пиццы: ID маршрута, номер чекпоинта и их количество
new WorkTime[MAX_PLAYERS];//Время, в течение которого уже выполняется 1 заказ на работе
new WorkTimeGruz[MAX_PLAYERS], WorkZoneCombine;
new IsServerRestaring = 0;

//текстдравы
new Text:TextDrawEvent[MAX_PLAYERS];//время до старта соревнования
new Text:LevelupTD[MAX_PLAYERS];//  LEVEL
new Text:SkinChangeTextDraw;
new Text:SkinIDTD[MAX_PLAYERS];
new Text:SpecInfo[MAX_PLAYERS], Text:SpecInfoVeh[MAX_PLAYERS];
new Text:TextDrawSpeedo[MAX_PLAYERS];
new LevelUp[MAX_PLAYERS] = -1; //переменная для убирания текстдрава
new Text:TextDrawTime, Text:TextDrawDate; //время и дата
new Text:TextDrawWorkTimer[MAX_PLAYERS];

new InEvent[MAX_PLAYERS] = 0, JoinEvent[MAX_PLAYERS] = 0;
#define EVENT_DM 1
#define EVENT_DERBY 2
#define EVENT_ZOMBIE 3
#define EVENT_RACE 4
//#define EVENT_TDM 5
#define EVENT_XRACE 5
#define EVENT_GUNGAME 6
#define EVENT_PVP 7


new LogidDialogShowed[MAX_PLAYERS] = 0;
new PlayerCarID[MAX_PLAYERS] = -1;
new CarChanged[MAX_PLAYERS];
new JetpackUsed[MAX_PLAYERS];
new FarmedXP[MAX_PLAYERS];
new FarmedMoney[MAX_PLAYERS];
new SkydiveTime[MAX_PLAYERS];
new HealthTime[MAX_PLAYERS];
new ArmourTime[MAX_PLAYERS];
new RepairTime[MAX_PLAYERS];
new PremiumTime[MAX_PLAYERS];
new SkinChangeMode[MAX_PLAYERS];
new GMTestStage[MAX_PLAYERS] = 0, GMTestTime[MAX_PLAYERS] = 0, Float: GMTestHealthOld[MAX_PLAYERS], Float: GMTestArmourOld[MAX_PLAYERS], GMTesterID[MAX_PLAYERS]; //команда /gmtest
new FloodTime[MAX_PLAYERS], FloodMessages[MAX_PLAYERS];
new OnStartEvent[MAX_PLAYERS];//Нужно, чтобы испавить баг, когда на старте сорев выдавало личное оружие
new UberNitroTime[MAX_PLAYERS];
new PrestigeTPTime[MAX_PLAYERS];
new TimeAfterSpawn[MAX_PLAYERS];
new LastDeathTime[MAX_PLAYERS];
new BadPingTime[MAX_PLAYERS];

new HPRegenTime[MAX_PLAYERS];
new JumpTime[MAX_PLAYERS];
new SkillNTime[MAX_PLAYERS];
new SkillYTime[MAX_PLAYERS];
new SkillHTime[MAX_PLAYERS];
new CaseBugTime[MAX_PLAYERS];
new SelectedModel[MAX_PLAYERS];
new FlipCount[MAX_PLAYERS] = 0;
new WorldSpawn[MAX_PLAYERS] = 0;
new MapTPTime[MAX_PLAYERS], MapTP[MAX_PLAYERS], MapTPTry[MAX_PLAYERS], Float: MapTPx[MAX_PLAYERS], Float: MapTPy[MAX_PLAYERS]; //телепорт по карте
new LastBaseVisited[MAX_PLAYERS], LastHouseVisited[MAX_PLAYERS];
new WeaponShotsLastSecond[MAX_PLAYERS];
new CasinoBet[MAX_PLAYERS]; //Казино (Рулетка): bet 0 - 36: числа, 37-38: красное, черное, 41: первая треть, 42: вторая треть, 43: третья треть
new Quest[MAX_PLAYERS][3], QuestScore[MAX_PLAYERS][3], QuestTime[MAX_PLAYERS][3];//квесты
new LastDamageFrom[MAX_PLAYERS] = -1;//на соревнованиях будет записывать от какого игрока получен последний урон
new LoginKickTime[MAX_PLAYERS]; //Время до кика (если игрок не успеет авторизоваться вовремя)
new LeaveDM[MAX_PLAYERS], LeaveGG[MAX_PLAYERS];

new PlayersOnline = 0;//Используется для определения частоты проведения соревнований
new MaxBank[MAX_PLAYERS];//Максимум денег в банке

new DMTimer = 150;
new DMTimeToEnd = -1;
new DMid = 8; //Первый дм после рестарта: Minigun Madness
new PrevDM = 8;
new DMPlayers = 0;
new DMKills[MAX_PLAYERS], DMLeaderID, DMLeaderKills;

new DerbyTimer = 180;
new DerbyTimeToEnd = -1;
new DerbyPlayers = 0;
new DerbyPlayersList[25];//Массив с ID игроков, которые участвуют в дерби
new Derbyid = 2; //Первое дерби после рестарта: Great Random
new PrevDerby = 2;
new DerbyModelCar[MAX_PLAYERS];
new DerbyCarID[MAX_PLAYERS];
new DerbyStarted[MAX_PLAYERS];
new DerbyPosition;
new Float:dchealth = 0.0;
new DerbyModelAll;


new ZMTimer = 390;
new ZMPlayers = 0, ZMHumans = 0, ZMZombies = 0;
new ZMPlayersList[25];//Массив с ID игроков, которые участвуют в зомби
new ZMid = 11, ZMTimeToEnd = -1; //Первое зомби после рестарта: Казино Рояль
new PrevZM = 1;
new ZMStarted[MAX_PLAYERS], ZMIsPlayerIsZombie[MAX_PLAYERS];
new ZMIsPlayerIsTank[MAX_PLAYERS], ZMTimeToFirstZombie;
new ZMTankOn = 0;
new ZMZone1, ZMZone2, ZMZone3, ZMZone4, ZMZone5, ZMZone6, ZMZone7, ZMZone8, ZMZone9, ZMZone10;
new ZMZone11, ZMZone12, ZMZone13, ZMZone14, ZMZone15;
new ZMSurvivalTime[MAX_PLAYERS] = 0;
new Float: ZMXmin, Float: ZMXmax, Float: ZMYmin, Float: ZMYmax;
new ZMKillsXP[MAX_PLAYERS];


new FRTimer = 420;
new FRPlayers = 0;
new FRPlayersList[25];//Массив с ID игроков, которые участвуют в гонке
new FRStart = 4, FRFinish = 5, FRTimeToEnd = -1; //Первая гонка после рестарта: из аэро СФ на гору
new PrevFRStart = 4, PrevFRFinish = 5;//предыдущие старт и финиш
new FRStarted[MAX_PLAYERS];
new FRModelCar = 411, FRCarID[MAX_PLAYERS];//первая гонка после рестарта на Infernus
new FRpos;
new FRTimeTransform = -1;


new XRTimer = 660;
new XRid = 11; //Первая легендарная гонка после рестарта: Into The Wild
new PrevXRid = 11;
new XRPlayers = 0;
new XRPlayersList[25];//Массив с ID игроков, которые участвуют в легендарной гонке
new XRTimeToEnd = -1;
new XRpos;
new XRStarted[MAX_PLAYERS];
new XRCPs = -1;//количество чекпоинтов
new XRPlayerCP[MAX_PLAYERS] = -1;
new XRCarCP[100];//здесь будут модели авто каждого чекпоинта. Максимум чеков: 100!
new XRTypeCP[100];//здесь тип чекпоинта (обычный, финиш, воздушный...) Максимум: 100!
new XRCarID[MAX_PLAYERS] = -1;
new XRPlayerCar[MAX_PLAYERS];//хранит модель текущей машины игрока, чтобы её можно было восстановить
new Float: XRxx[MAX_PLAYERS], Float: XRy[MAX_PLAYERS], Float: XRz[MAX_PLAYERS], Float: XRa[MAX_PLAYERS], Float: XRvx[MAX_PLAYERS], Float: XRvy[MAX_PLAYERS], Float: XRvz[MAX_PLAYERS];


new GGTimer = 690;
new GGTimeToEnd = -1;
new GGid = 10; //Первая гонка вооружений после рестарта: Футбольное поле
new PrevGGid = 10;
new GGPlayers = 0;
new GGKills[MAX_PLAYERS] = 0;


//Лимиты (максимум участников)
new DMLimit = 25;//до обновы 1.07 было 30
new DerbyLimit = 25;
new ZMLimit = 25;//до обновы 1.07 было 30
new FRLimit = 25;
new XRLimit = 25;
new GGLimit = 25;//до обновы 1.07 было 30

new TutorialStep[MAX_PLAYERS] = 999;
new NeedXP[MAX_PLAYERS] = 9999999;
new SaveTime = 30;

new LACPanic[MAX_PLAYERS], LACPanicTime[MAX_PLAYERS]; //LAC v2.0
new Float: KarmaX[MAX_PLAYERS], Float: KarmaY[MAX_PLAYERS], Float: KarmaZ[MAX_PLAYERS];

new Weapons[MAX_PLAYERS][47];//LAC на оружие
new PlayerIP[MAX_PLAYERS][16];//IP игроков
new PlayerName[MAX_PLAYERS][25];//ник игрока

//Объекты игроков
new TutorialObject[MAX_PLAYERS] = -1;

//Объекты машин
new NeonObject1[MAX_VEHICLES] = -1, NeonObject2[MAX_VEHICLES] = -1;
new TrailerID[MAX_VEHICLES] = - 1, IsTrailer[MAX_VEHICLES] = 0;

enum Info
{
	Model,
	Admin,
	Level,
	Exp,
	Spawn,
	SpawnStyle,
	Invisible,
	Time,
	Cash,
	Bank,
	Banned,
	Muted,
	Slot1, // Оружие
	Slot2,
	Slot3,
	Slot4,
	Slot5,
	Slot6,
	Slot7,
	Slot8,
	Slot9,
	Slot10,
	MyClan,
	Member,
	Leader,
	Home,
	Account,
	CarSlot1,
	CarSlot1Color1,
	CarSlot1Color2,
	CarSlot1PaintJob,
	CarSlot1Neon,
	CarSlot1Component0,
	CarSlot1Component1,
	CarSlot1Component2,
	CarSlot1Component3,
	CarSlot1Component4,
	CarSlot1Component5,
	CarSlot1Component6,
	CarSlot1Component7,
	CarSlot1Component8,
	CarSlot1Component9,
	CarSlot1Component10,
	CarSlot1Component11,
	CarSlot1Component12,
	CarSlot1Component13,
	CarSlot1NitroX,
	CarSlot2,
	CarSlot2Color1,
	CarSlot2Color2,
	CarSlot2PaintJob,
	CarSlot2Neon,
	CarSlot2Component0,
	CarSlot2Component1,
	CarSlot2Component2,
	CarSlot2Component3,
	CarSlot2Component4,
	CarSlot2Component5,
	CarSlot2Component6,
	CarSlot2Component7,
	CarSlot2Component8,
	CarSlot2Component9,
	CarSlot2Component10,
	CarSlot2Component11,
	CarSlot2Component12,
	CarSlot2Component13,
	CarSlot2NitroX,
	CarSlot3,
	CarSlot3Color1,
	CarSlot3Color2,
	Float: GameGold,
	Float: GameGoldTotal,
	GPremium,
	SkillHP,
	SkillRepair,
	ActiveSkillPerson,
	ActiveSkillCar1,
	ActiveSkillCar2,
	ActiveSkillHCar1,
	ActiveSkillHCar2,
	Prestige,
	PrestigeSkillN,
	PrestigeSkillY,
	PrestigeSkillH,
	Karma,
	KarmaTime,
	Float: PosX,
	Float: PosY,
	Float: PosZ,
	Float: PosA,
	ConPM,
	ConInviteClan,
	ConInvitePVP,
	ConMesPVP,
	ConMesEnterExit,
	ConSpeedo,
	LastHourExp,
	LastHourReferalExp,
	HelpTime,
	EventChangeTime,
	LeaveZM,
	ClanWarTime,
	CasinoBalance,
	GiveCashBalance,
	BuddhaTime,
	PrestigeColor,
	Medals,
	CompletedQuests,
	Float: GGFromMedals,
	Float: GGFromMedalsTotal,
	Float: GGFromMedalsLastDay,

	//Переменные, которые НЕ сохраняются в файл
	CarActive,
	//Всё, что связано синхронизацией здоровья, брони и нанесением урона
	Float: PHealth,
	Float: PArmour,
}
new Player[MAX_PLAYERS][Info];

enum ChangeInfo
{
	Level,
	Exp,
    Bank,
    Float: GameGold,
}
new ChangePlayer[MAX_PLAYERS][ChangeInfo];

enum pInfo
{
	pOwner[MAX_PLAYER_NAME],
	pName[MAX_PLAYER_NAME],
	pPrice,
	Float:pPosEnterX,
	Float:pPosEnterY,
	Float:pPosEnterZ,
	Float:pPosEnterA,
	Float:pPosRespawnX,
	Float:pPosRespawnY,
	Float:pPosRespawnZ,
	Float:pPosRespawnA,
	pOpened,
	pBuyBlock,
}
new Property[MAX_PROPERTY][pInfo];

enum bInfo
{
	bClan,
	bPrice,
	Float:bPosEnterX,
	Float:bPosEnterY,
	Float:bPosEnterZ,
	Float:bPosEnterA,
	Float:bPosRespawnX,
	Float:bPosRespawnY,
	Float:bPosRespawnZ,
	Float:bPosRespawnA,
}
new Base[MAX_BASE][bInfo];


enum cInfo
{
	cLevel,
	cLider[MAX_PLAYER_NAME],
	cName[MAX_PLAYER_NAME],
	cMessage[125],
	cColor,
	cBase,
	cXP,
	cLastDay,
	cEnemyClan,
	cCWwin,
	cMember1[MAX_PLAYER_NAME],
	cMember2[MAX_PLAYER_NAME],
	cMember3[MAX_PLAYER_NAME],
	cMember4[MAX_PLAYER_NAME],
	cMember5[MAX_PLAYER_NAME],
	cMember6[MAX_PLAYER_NAME],
	cMember7[MAX_PLAYER_NAME],
	cMember8[MAX_PLAYER_NAME],
	cMember9[MAX_PLAYER_NAME],
	cMember10[MAX_PLAYER_NAME],
	cMember11[MAX_PLAYER_NAME],
	cMember12[MAX_PLAYER_NAME],
	cMember13[MAX_PLAYER_NAME],
	cMember14[MAX_PLAYER_NAME],
	cMember15[MAX_PLAYER_NAME],
	cMember16[MAX_PLAYER_NAME],
	cMember17[MAX_PLAYER_NAME],
	cMember18[MAX_PLAYER_NAME],
	cMember19[MAX_PLAYER_NAME],
	cMember20[MAX_PLAYER_NAME],
}
new Clan[MAX_CLAN][cInfo];

enum PVPInfo
{
	Status, //0 - не в PVP, 1 - в pvp
	Invite, //ид игрока, с которым pvp. Не выбрано: -1
	Map, //Номер карты pvp.
	Weapon,//id оружия
	Health,//Кол-во здоровья. От 1 до 200.
	PlayMap,//карта, на которой в данный момент играет
	PlayWeapon,//
	PlayHealth,//
	TimeOut,
}
new PlayerPVP[MAX_PLAYERS][PVPInfo];
new CanStartPVP[MAX_PLAYERS];

enum VehicleInfo
{
	AntiDestroyTime, //кол-во секунд, в течение которых транспорт не может быть уничтожен
	Owner, //id игрока, которому принадлежит транспорт
	Float: Health, //Здоровье транспорта
}
new Vehicle[MAX_VEHICLES][VehicleInfo];
forward SecVehicleUpdate(vehicleid);

#define MAX_DYNAMIC_PICKUPS 1000
enum DynamicPickupInfo
{//инфа динамических пикапов
	Type, //1 - дом, 2 - штаб, 3 - деньги игрока
	ID, //ID дома, ID штаба, сумма денег
	DestroyTimerID, //ID таймера для удаления пикапа (не используется у домов и штабов)
}//инфа динамических пикапов
new DynamicPickup[MAX_DYNAMIC_PICKUPS][DynamicPickupInfo];

//Регистрационные данные
new RegisterDate[MAX_PLAYERS][16];
new RegisterIP[MAX_PLAYERS][16];
new RegisterISP[MAX_PLAYERS][40];
new RegisterHost[MAX_PLAYERS][40];
new RegisterLocation[MAX_PLAYERS][40];

new NOPSetPlayerHealth[MAX_PLAYERS];
new NOPSetPlayerArmour[MAX_PLAYERS];
new NOPSetPlayerHealthAndArmourOff[MAX_PLAYERS];

//------- LAC на оружие
new LACWeaponOff[MAX_PLAYERS];
stock ResetWeapons(playerid)
{
    for(new i=0;i<47;i++) Weapons[playerid][i] = 0;
	LACWeaponOff[playerid] = 3;
	return ResetPlayerWeapons(playerid);
}
#define ResetPlayerWeapons ResetWeapons //LAC на оружие

stock GiveWeapon(playerid,weapid,ammo)
{
	if (ammo > 0) Weapons[playerid][weapid]= 1;
	GivePlayerWeapon(playerid,weapid,ammo);
	return ;
}
#define GivePlayerWeapon GiveWeapon //LAC на оружие

//------- LAC на телепорт
new LACTeleportOff[MAX_PLAYERS], TimeWithZeroSpeed[MAX_PLAYERS];
stock SetPos(playerid, Float:x, Float:y, Float:z)
{
	LastPlayerX[playerid] = x; LastPlayerY[playerid] = y; LastPlayerZ[playerid] = z;
	LACTeleportOff[playerid] = 3;
	if (IsPlayerInAnyVehicle(playerid)) DestroyVehicle(GetPlayerVehicleID(playerid));//исправляет баг, игрок, который в авто, не перемещается и кикается античитом на тп
	SetPlayerPos(playerid, x, y, z);
	return 1;
}
#define SetPlayerPos SetPos
stock SetPosFindZ(playerid, Float:x, Float:y, Float:z)
{
	LastPlayerX[playerid] = x; LastPlayerY[playerid] = y; LastPlayerZ[playerid] = z;
	LACTeleportOff[playerid] = 3;
	SetPlayerPosFindZ(playerid, x, y, z);
	return 1;
}
#define SetPlayerPosFindZ SetPosFindZ
stock SetVPos(vehicleid, Float:x, Float:y, Float:z)
{
	foreach(Player, cid)
	{
	    if(GetPlayerVehicleID(cid) == vehicleid){LastPlayerX[cid] = x; LastPlayerY[cid] = y; LastPlayerZ[cid] = z; LACTeleportOff[cid] = 3;}
	}
	SetVehiclePos(vehicleid, x, y, z);
	return 1;
}
#define SetVehiclePos SetVPos
stock PutInVehicle(playerid,vehicleid,seatid)
{
    GetVehiclePos(vehicleid, LastPlayerX[playerid], LastPlayerY[playerid], LastPlayerZ[playerid]);
	LACTeleportOff[playerid] = 3;
	PutPlayerInVehicle(playerid,vehicleid,seatid);
	if (seatid == 0) Vehicle[vehicleid][Owner] = playerid;//присваеваем машине ид владельца авто
	return 1;
}
#define PutPlayerInVehicle PutInVehicle
//------- LAC на телепорт

stock LDestroyVehicle(vehicleid)
{
	//Уничтожение неона
	if (NeonObject1[vehicleid] != -1){DestroyDynamicObject(NeonObject1[vehicleid]);NeonObject1[vehicleid] = -1;}
	if (NeonObject2[vehicleid] != -1){DestroyDynamicObject(NeonObject2[vehicleid]);NeonObject2[vehicleid] = -1;}
	if (TrailerID[vehicleid] > -1) LDestroyVehicle(TrailerID[vehicleid]);//Если у авто есть трейлер - уничтожаем его
	TrailerID[vehicleid] = -1; IsTrailer[vehicleid] = 0;
	if (Vehicle[vehicleid][Owner] > -1)
	{
	    new ownerid = Vehicle[vehicleid][Owner];
		if (IsPlayerInVehicle(ownerid, vehicleid)) RemovePlayerFromVehicle(ownerid);
		PlayerCarID[ownerid] = -1;
		Vehicle[vehicleid][Owner] = -1;
	} //исправление бага
	return DestroyVehicle(vehicleid);
}
#define DestroyVehicle LDestroyVehicle

//LAC на рассинхронизацию здоровья и брони
stock SetHealth(playerid, Float: health)
{
	Player[playerid][PHealth] = health;
	return SetPlayerHealth(playerid, health);
}
#define SetPlayerHealth SetHealth
stock SetArmour(playerid, Float: armour)
{
	Player[playerid][PArmour] = armour;
	return SetPlayerArmour(playerid, armour);
}
#define SetPlayerArmour SetArmour
//LAC на рассинхронизацию здоровья и брони

//LAC на ремонт транспорта
new LACRepair[MAX_VEHICLES] = 0;
stock SetVHealth(vehicleid, Float: health)
{
	Vehicle[vehicleid][Health] = health;
	return SetVehicleHealth(vehicleid, health);
}
#define SetVehicleHealth SetVHealth
stock RepairVeh(vehicleid)
{
	Vehicle[vehicleid][Health] = 1000.0;
	return RepairVehicle(vehicleid);
}
#define RepairVehicle RepairVeh
//LAC на ремонт транспорта

//Авто-удаление старого чекпоинта при создании нового. Задержка между удалением и созданием в 100мс чтобы не было бага с размером чека
stock SetCheckpoint(playerid, Float:x, Float:y, Float:z, Float:size)
{
    DisablePlayerCheckpoint(playerid); DisablePlayerRaceCheckpoint(playerid); GPSUsed[playerid] = 0;
    return SetTimerEx("LSetPlayerCheckpoint" , 100, false, "iffff", playerid, x, y, z, size);
}
forward LSetPlayerCheckpoint(playerid, Float:x, Float:y, Float:z, Float:size);
public LSetPlayerCheckpoint(playerid, Float:x, Float:y, Float:z, Float:size) return SetPlayerCheckpoint(playerid, Float:x, Float:y, Float:z, Float:size);
#define SetPlayerCheckpoint SetCheckpoint
//А теперь тоже самое для гоночных чекпоинтов
stock SetRaceCheckpoint(playerid, type, Float:x, Float:y, Float:z, Float:nextx, Float:nexty, Float:nextz, Float:size)
{
    DisablePlayerCheckpoint(playerid); DisablePlayerRaceCheckpoint(playerid); GPSUsed[playerid] = 0;
	return SetTimerEx("LSetPlayerRaceCheckpoint" , 100, false, "iifffffff", playerid, type, x, y, z, nextx, nexty, nextz, size);
}
forward LSetPlayerRaceCheckpoint(playerid, type, Float:x, Float:y, Float:z, Float:nextx, Float:nexty, Float:nextz, Float:size);
public LSetPlayerRaceCheckpoint(playerid, type, Float:x, Float:y, Float:z, Float:nextx, Float:nexty, Float:nextz, Float:size) return SetPlayerRaceCheckpoint(playerid, type, x, y, z, nextx, nexty, nextz, size);
#define SetPlayerRaceCheckpoint SetRaceCheckpoint
//Авто-удаление старого чекпоинта при создании нового. Задержка между удалением и созданием в 100мс чтобы не было бага с размером чека

//////////////------------- Русский GetWeaponName
new WeaponName[47][] = {// http://wiki.sa-mp.com/wiki/Weapons_RU
"Нет",
"Knuckles",
"Golf Club",
"Nightstick",
"Knife",
"Baseball Bat",
"Shovel",
"Pool Cue",
"Katana",
"Chainsaw",
"Purple Dildo",
"Dildo",
"Vibrator",
"Silver Vibrator",
"Flowers",
"Cane",
"Grenades",
"Tear Gas",
"Molotov",
"Vehicle Rocket",
"Hydra Gas",
"JetPack",
"9mm Pistol",
"Silenced 9mm Pistol",
"Desert Eagle",
"Shotgun",
"Sawnoff Shotgun",
"Combat Shotgun",
"UZI",
"MP5",
"AK-47",
"M4",
"Tec-9",
"Country Rifle",
"Sniper Rifle",
"RPG",
"HS Rocket",
"Flamethrower",
"Minigun",
"Satchel Charge",
"Detonator",
"Spraycan",
"Fire Extinguisher",
"Camera",
"Night Vis Goggles",
"Thermal Goggles",
"Parachute"
 };
stock GetWeaponNameEx(weaponid, weapon[], len = sizeof(weapon))
{
    if (0 <= weaponid <= 46) return weapon[0] = 0, strcat(weapon, WeaponName[weaponid], len), true;
    else return weapon[0] = 0, strcat(weapon, "{FF0000}Неизвестное оружие", len), true;
}
#define GetWeaponName GetWeaponNameEx
//////////////------------- Русский GetWeaponName


new CheatFlySec[MAX_PLAYERS] = 0, LACFlyOff[MAX_PLAYERS] = 0;//LAC на FlyHack
new LACPedSHOff[MAX_PLAYERS] = 0, LACPedSHTime[MAX_PLAYERS] = 0;//LAC на SpeedHack (пешком)

new ClanTextShowed[MAX_PLAYERS] = 0;

new TimeTransform[MAX_PLAYERS], Float:carhealth = 0.0;//задержка трансформации

#include "Transformer\PLAYERSpawns"
#include "Transformer\EVENTSpawns"
#include "Transformer\WeaponsData" //урон от оружия
#include "Transformer\Levels" //XP, необходимый для уровня
#include "Transformer\LevelUp" //Функция повышения уровня
new DMName[][] =
{
"0id",
"Последний Самурай",
"Зона 69",
"Sniper Elite",
"Кладбище",
"Зона 69 (Внутри)",
"Emerald Isle",
"Sniper Assault",
"Minigun Madness",
"Мясорубка",
"RocketMania",
"Ферма",
"UnderWater",
"Dead Air",
"Диллимор",
"Буря в Пустыне",
"Бассейн",
"Полигон",
"Ангар",
"Авианосец",
"Дом Удовольствий"
};

new DerbyName[][] =
{
"0id",
"Честная Битва",
"Great Random",
"Выживает Сильнейший",
"Разрушительная Битва",
"На Грани",
"Без Гарантий",
"Перекрестки",
"Пять Башен",
"World Of Tanks"
};

new ZMName[][] =
{
"0id",
"Поселок Блуберри",
"Форт Карсон",
"Angel Pine",
"Доки (Лос Сантос)",
"Зона 69",
"Пустынный округ",
"Диллимор",
"Grove Street",
"Свалка",
"Город - Призрак",
"Казино Рояль",
"Стройка",
"Склады",
"Нефтезавод",
"Две Крыши"
};

new FRName[][] =
{
"0id",
"Заброшенный аэропорт (Восток)",
"Заброшенный аэропорт (Запад)",
"Великий Трамплин",
"Аэропорт Сан Фиерро (Взлетная полоса)",
"Гора Чиллиад",
"Радиовышка (Сан Фиерро)",
"Клуб Джиззи (Сан Фиерро)",
"Карьер",
"Groove Street (Лос Сантос)",
"Иделвуд (Лос Сантос)",
"Маяк (Лос Сантос)",
"Доки (Лос Сантос)",
"Аэропорт Лос Сантос (Взлетная полоса)",
"Полицейский участок (Лос Сантос)",
"Казино Калигула",
"Бейсбольное поле (Лас Вентурас)",
"Отель Rock (Лас Вентурас)",
"Автострада (Ручей Паломино)",
"Завод Блуберри",
"Автошкола (Сан Фиерро)",
"Медицинский центр (Сан Фиерро)",
"Военная база (Сан Фиерро)",
"Причал (Лос Сантос)",
"Автострада Джулиус (Лас Вентурас)",
"Ж/Д вокзал (Лас Вентурас)",
"Военная база (Лас Вентурас)",
"Зона 69",
"Стадион (Лас Вентурас)",
"Причал Бейсайд",
"Стадион (Лос Сантос)",
"Обсерватория (Лос Сантос)",
"Химический завод (Сан Фиерро)",
"Старый склад (Сан Фиерро)",
"Аэропорт Лос Сантос",
"Angel Pine",
"Стадион (Сан Фиерро)",
"Центр Сан Фиерро",
"Церковь (Сан Фиерро)",
"Аэропорт Лас Вентурас (Взлетная полоса)",
"Дамба Шермана"
//Можно добавить "Аэропорт Сан Фиерро" и "Аэропорт Лас Вентурас" (не взлетные полосы)
};

new GGName[][] =
{
"0id",
"Golf Club",
"Зона 69",
"Four Dragons",
"Кладбище",
"Зона 69 (внутри)",
"Emerald Isle",
"Диллимор",
"Стройка",
"Заброшенный Завод",
"Футбольное Поле",
"Ферма",
"UnderWater",
"Dead Air",
"Скалы",
"Пустынный округ",
"Бассейн",
"Полигон",
"Ангар",
"Авианосец",
"Дом Удовольствий"
};

new XRName[][] =
{
"0id",
"Around San Andreas",
"Bon Voyage",
"Up And Down",
"Riders On The Storm",
"Crazy Turns",
"Vegas Race",
"Dead Air",
"Road To Farm",
"UnderGround",
"San Fierro Tour",
"Into The Wild",
"Drag Race",
"Need For Speed",
"Восьмерка",
"San Fierro Drift",
"Mountain",
"Не для слабаков",
"Dirt And Dust",
"Los Santos Highway",
"Fast And Furious"
};

//----- кейсы
#include "Transformer\Packages"
new CasePickup[23], CaseMapIcon[23];
new case1, case2, case3, case4, case5, case6, case7, case8, case9, case10;
new case11, case12, case13, case14, case15, case16, case17, case18, case19, case20;
new casemodel = 1210;//Модель кейса

//---- Угон авто
#include "Transformer\CarStealSpawn"
new StealCar[36], StealCarMapIcon[36], cscol1, cscol2, csmodel;
new csrand1, csrand2, csrand3, csrand4, csrand5, csrand6, csrand7, csrand8, csrand9, csrand10;
new csrand11, csrand12, csrand13, csrand14, csrand15, csrand16, csrand17, csrand18, csrand19, csrand20;
new csrand21, csrand22, csrand23, csrand24, csrand25, csrand26, csrand27, csrand28, csrand29, csrand30;
new csrand31, csrand32, csrand33, csrand34, csrand35;
new StealCarTimer[MAX_VEHICLES], StealCarModel[MAX_PLAYERS];

new QuestCar[MAX_PLAYERS] = -1, QuestActive[MAX_PLAYERS] = 0;
new AirportID[MAX_PLAYERS], AirportTime[MAX_PLAYERS];//аэропорты

//для записи точки входа в интерьер (банки)
new Float: InteriorEnterX[MAX_PLAYERS], Float: InteriorEnterY[MAX_PLAYERS], Float: InteriorEnterZ[MAX_PLAYERS],Float: InteriorEnterA[MAX_PLAYERS];

//spec
new LSpecID[MAX_PLAYERS] = -1, LSpecMode[MAX_PLAYERS] = SPECTATE_MODE_NORMAL, LSpecCanFastChange[MAX_PLAYERS] = 0;
new LSpectators[MAX_PLAYERS];
//spec

new rampid[MAX_PLAYERS];
new NeedLSpawn[MAX_PLAYERS] = 0;
new PrestigeGM[MAX_PLAYERS] = 0;

new ServerLimitXPDate[80], PlayerLimitXPDate[MAX_PLAYERS][80];//Для обнуления лимита ХР каждый час

forward SecUpdate();
forward UnFreeze(playerid);
forward ParaEnd(playerid);
forward PrestigeCarTP(playerid, class, seat1, seat2, seat3);
forward PrestigeCarTPx(playerid, class, seat1, seat2, seat3, Float: vel1,  Float: vel2, Float: vel3);
forward SpecTextDrawPub(playerid);
forward SpeedoUpdate(playerid); new LastSpeed[MAX_PLAYERS] = 999, LACSH[MAX_PLAYERS] = 3, Float: LastVHealth[MAX_PLAYERS], NeedSpeedDown[MAX_PLAYERS];
forward SecPlayerUpdate(playerid);
forward UnLock(playerid,vehicleid);
forward LSpawnPlayer(playerid);
forward SobeitCamCheck(playerid);
forward DestroyCashPickup(pickupid);
forward SideCameraSpecpUpdate(playerid, vehicleid);

//Отложенный на 100мс кик, чтобы игрок увидел сообщение о кике
forward KickTimer(playerid);//кик через 100мс
stock GKick(playerid){SavePlayer(playerid); return SetTimerEx("KickTimer" , 100, false, "i", playerid);}
public KickTimer(playerid) return Kick(playerid);//кик через 100мс

forward RemoveRamp(playerid);
forward Float:GetOptimumRampDistance(playerid);
forward Float:GetXYInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance);

#include <fly> //Полет супер-мена (Престиж 2)
#include <vehfly> //Полет на авто (Престиж 4)








// --------------- Время в секундах ---------------------------------
#define MAX_AFK_TIME 3600    // максимально время AFK до кика
#define FIRST_CHECK 2400    // первое предупреждение
#define SECOND_CHECK 3000    // второе предупреждение
#define AFK_TEXT_SET 20    // время до появления надписи AFK над головой

// --------------- Цвета --------------------------------------------
#define T_COLOR 0xFF000080    // цвет 3Д текста
#define M1_COLOR 0xFF0000FF // цвет текста первого предупреждения
#define M2_COLOR 0xFF0000FF // цвет текста второго предупреждения
#define MK_COLOR 0xFF0000FF // цвет текста оповещения о кике

// --------------- Прочее -------------------------------------------
#define T_DIST 20.0 // расстояние с которого видно 3Д текст

// --------------- Структура данных ---------------------------------
enum afk_info {
	AFK_Time,            // время AFK
Float:AFK_Coord,    // последняя координата
	AFK_Stat            // статус 3Д текста
}

// --------------- Объявление переменных ----------------------------
new PlayerAFK[MAX_PLAYERS][afk_info];    // данные AFK игроков
new Text3D:AFK_3DT[MAX_PLAYERS]; // 3Д тексты над головами игроков

main() {}


PlayerToPoint(Float:radius, playerid, Float:x, Float:y, Float:z)
{
	if(IsPlayerConnected(playerid))
	{
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		tempposx = (oldposx -x);
		tempposy = (oldposy -y);
		tempposz = (oldposz -z);
		if (((tempposx < radius) && (tempposx > -radius)) && ((tempposy < radius) && (tempposy > -radius)) && ((tempposz < radius) && (tempposz > -radius)))
		{
			return 1;
		}
	}
	return 0;
}

GetName(playerid)
{
	new playername[MAX_PLAYER_NAME];
	GetPlayerName(playerid, playername, sizeof(playername));
	return playername;
}

stock ResetPlayer(playerid)
{
	Player[playerid][Model] = 0;
	Player[playerid][Admin] = 0;
	Player[playerid][Level] = 0;
	Player[playerid][Exp] = 0;
	Player[playerid][Spawn] = 0;
	Player[playerid][SpawnStyle] = 0;
	Player[playerid][Invisible] = 0;
	Player[playerid][Time] = 0;
	Player[playerid][Cash] = 0;
	Player[playerid][Bank] = 0;
	Player[playerid][Slot1] = 0;
	Player[playerid][Slot2] = 0;
	Player[playerid][Slot3] = 0;
	Player[playerid][Slot4] = 0;
	Player[playerid][Slot5] = 0;
	Player[playerid][Slot6] = 0;
	Player[playerid][Slot7] = 0;
	Player[playerid][Slot8] = 0;
	Player[playerid][Slot9] = 0;
	Player[playerid][Slot10] = 0;
	Player[playerid][MyClan] = 0;
	Player[playerid][Member] = 0;
	Player[playerid][Leader] = 0;
	Player[playerid][Home] = 0;
	Player[playerid][Account] = 0;
	Player[playerid][Banned] = 0;
	strmid(BannedBy[playerid], "ПУСТО", 0, strlen("ПУСТО"), 5);
	strmid(BanReason[playerid], "ПУСТО", 0, strlen("ПУСТО"), 5);
	Player[playerid][Muted] = 0;
	strmid(MutedBy[playerid], "ПУСТО", 0, strlen("ПУСТО"), 5);
	Player[playerid][CarSlot1] = 462;
	Player[playerid][CarSlot1Color1] = 0;
	Player[playerid][CarSlot1Color2] = 0;
	Player[playerid][CarSlot1PaintJob] = -1;
	Player[playerid][CarSlot1Neon] = 0;
	Player[playerid][CarSlot1Component0] = 0;
	Player[playerid][CarSlot1Component1] = 0;
	Player[playerid][CarSlot1Component2] = 0;
	Player[playerid][CarSlot1Component3] = 0;
	Player[playerid][CarSlot1Component4] = 0;
	Player[playerid][CarSlot1Component5] = 0;
	Player[playerid][CarSlot1Component6] = 0;
	Player[playerid][CarSlot1Component7] = 0;
	Player[playerid][CarSlot1Component8] = 0;
	Player[playerid][CarSlot1Component9] = 0;
	Player[playerid][CarSlot1Component10] = 0;
	Player[playerid][CarSlot1Component11] = 0;
	Player[playerid][CarSlot1Component12] = 0;
	Player[playerid][CarSlot1Component13] = 0;
	Player[playerid][CarSlot1NitroX] = 0;
	Player[playerid][CarSlot2] = 0;
	Player[playerid][CarSlot2Color1] = 0;
	Player[playerid][CarSlot2Color2] = 0;
	Player[playerid][CarSlot2PaintJob] = -1;
	Player[playerid][CarSlot2Neon] = 0;
	Player[playerid][CarSlot2Component0] = 0;
	Player[playerid][CarSlot2Component1] = 0;
	Player[playerid][CarSlot2Component2] = 0;
	Player[playerid][CarSlot2Component3] = 0;
	Player[playerid][CarSlot2Component4] = 0;
	Player[playerid][CarSlot2Component5] = 0;
	Player[playerid][CarSlot2Component6] = 0;
	Player[playerid][CarSlot2Component7] = 0;
	Player[playerid][CarSlot2Component8] = 0;
	Player[playerid][CarSlot2Component9] = 0;
	Player[playerid][CarSlot2Component10] = 0;
	Player[playerid][CarSlot2Component11] = 0;
	Player[playerid][CarSlot2Component12] = 0;
	Player[playerid][CarSlot2Component13] = 0;
	Player[playerid][CarSlot2NitroX] = 0;
	Player[playerid][CarSlot3] = 0;
	Player[playerid][CarSlot3Color1] = 0;
	Player[playerid][CarSlot3Color2] = 0;
	Player[playerid][GameGold] = 0;
	Player[playerid][GameGoldTotal] = 0;
	Player[playerid][GPremium] = 0;
	Player[playerid][SkillHP] = 0;
	Player[playerid][SkillRepair] = 0;
	Player[playerid][ActiveSkillPerson] = 0;
	Player[playerid][ActiveSkillCar1] = 0;
	Player[playerid][ActiveSkillCar2] = 0;
	Player[playerid][ActiveSkillHCar1] = 0;
	Player[playerid][ActiveSkillHCar2] = 0;
	Player[playerid][Prestige] = 0;
	Player[playerid][Karma] = 250;
	Player[playerid][KarmaTime] = 0;
	Player[playerid][PosX] = 0.0;
	Player[playerid][PosY] = 0.0;
	Player[playerid][PosZ] = 0.0;
	Player[playerid][PosA] = 0.0;
	Player[playerid][ConPM] = 1;
	Player[playerid][ConInviteClan] = 1;
	Player[playerid][ConInvitePVP] = 1;
	Player[playerid][ConMesPVP] = 1;
	Player[playerid][ConMesEnterExit] = 0; //По умолчанию сообщения о входе/выходе на сервер не отображаются
	Player[playerid][ConSpeedo] = 1;
	Player[playerid][LastHourExp] = 0;
	Player[playerid][LastHourReferalExp] = 0;
	Player[playerid][HelpTime] = 500;
	Player[playerid][EventChangeTime] = 0;
	Player[playerid][LeaveZM] = 0;
	Player[playerid][ClanWarTime] = 0;
	Player[playerid][CasinoBalance] = 0;
	Player[playerid][GiveCashBalance] = 0;
	Player[playerid][BuddhaTime] = 0;
	Player[playerid][PrestigeColor] = -1;
	Quest[playerid][0] = random(10) + 1;
	QuestScore[playerid][0] = 0;
	QuestTime[playerid][0] = 0;
	Quest[playerid][1] = random(10) + 11;
	QuestScore[playerid][1] = 0;
	QuestTime[playerid][1] = 0;
	Quest[playerid][2] = 25;//quest: Проведите на сервере 60 минут.
	QuestScore[playerid][2] = 0;
	QuestTime[playerid][2] = 0;
	Player[playerid][Medals] = 0;
	Player[playerid][CompletedQuests] = 0;
	Player[playerid][GGFromMedals] = 0;
	Player[playerid][GGFromMedalsTotal] = 0;
	Player[playerid][GGFromMedalsLastDay] = DateToIntDate(Day, Month, Year);

	//Переменные, которые НЕ сохраняются в файл
	Player[playerid][CarActive] = 0;
	Player[playerid][PHealth] = 100.0;
	Player[playerid][PArmour] = 100.0;
	
	//О регистрации
	RegisterDate[playerid] = "?";
	RegisterIP[playerid] = "?";
	RegisterISP[playerid] = "?";
	RegisterHost[playerid] = "?";
	RegisterLocation[playerid] = "?";
}


stock LoadPlayer(playerid)
{
	new filename[MAX_FILE_NAME], file;
	format(filename, sizeof(filename), "accounts/%s.ini", GetName(playerid));
	file = ini_openFile(filename);
	ini_getString(file,"Password", PlayerPass[playerid]);
	ini_getInteger(file, "Model", Player[playerid][Model]);
	ini_getInteger(file, "Admin", Player[playerid][Admin]);
	ini_getInteger(file, "Level", Player[playerid][Level]);
	ini_getInteger(file, "Exp", Player[playerid][Exp]);
	ini_getInteger(file, "Spawn", Player[playerid][Spawn]);
	ini_getInteger(file, "SpawnStyle", Player[playerid][SpawnStyle]);
	ini_getInteger(file, "Invisible", Player[playerid][Invisible]);
	ini_getInteger(file, "Time", Player[playerid][Time]);
	ini_getInteger(file, "Cash", Player[playerid][Cash]);
	ini_getInteger(file, "Bank", Player[playerid][Bank]);
	ini_getInteger(file, "Banned", Player[playerid][Banned]);
	ini_getString(file,"BannedBy", BannedBy[playerid]);
	ini_getString(file,"BanReason", BanReason[playerid]);
	ini_getInteger(file, "Muted", Player[playerid][Muted]);
	ini_getString(file,"MutedBy", MutedBy[playerid]);
	ini_getInteger(file, "Slot1", Player[playerid][Slot1]);
	ini_getInteger(file, "Slot2", Player[playerid][Slot2]);
	ini_getInteger(file, "Slot3", Player[playerid][Slot3]);
	ini_getInteger(file, "Slot4", Player[playerid][Slot4]);
	ini_getInteger(file, "Slot5", Player[playerid][Slot5]);
	ini_getInteger(file, "Slot6", Player[playerid][Slot6]);
	ini_getInteger(file, "Slot7", Player[playerid][Slot7]);
	ini_getInteger(file, "Slot8", Player[playerid][Slot8]);
	ini_getInteger(file, "Slot9", Player[playerid][Slot9]);
	ini_getInteger(file, "Slot10", Player[playerid][Slot10]);
	ini_getInteger(file, "MyClan", Player[playerid][MyClan]);
	ini_getInteger(file, "Member", Player[playerid][Member]);
	ini_getInteger(file, "Leader", Player[playerid][Leader]);
	ini_getInteger(file, "Home", Player[playerid][Home]);
	ini_getInteger(file, "Account", Player[playerid][Account]);
	ini_getInteger(file, "CarSlot1", Player[playerid][CarSlot1]);
	ini_getInteger(file, "CarSlot1Color1", Player[playerid][CarSlot1Color1]);
	ini_getInteger(file, "CarSlot1Color2", Player[playerid][CarSlot1Color2]);
	ini_getInteger(file, "CarSlot1PaintJob", Player[playerid][CarSlot1PaintJob]);
	ini_getInteger(file, "CarSlot1Neon", Player[playerid][CarSlot1Neon]);
	ini_getInteger(file, "CarSlot1Component0", Player[playerid][CarSlot1Component0]);
	ini_getInteger(file, "CarSlot1Component1", Player[playerid][CarSlot1Component1]);
	ini_getInteger(file, "CarSlot1Component2", Player[playerid][CarSlot1Component2]);
	ini_getInteger(file, "CarSlot1Component3", Player[playerid][CarSlot1Component3]);
	ini_getInteger(file, "CarSlot1Component4", Player[playerid][CarSlot1Component4]);
	ini_getInteger(file, "CarSlot1Component5", Player[playerid][CarSlot1Component5]);
	ini_getInteger(file, "CarSlot1Component6", Player[playerid][CarSlot1Component6]);
	ini_getInteger(file, "CarSlot1Component7", Player[playerid][CarSlot1Component7]);
	ini_getInteger(file, "CarSlot1Component8", Player[playerid][CarSlot1Component8]);
	ini_getInteger(file, "CarSlot1Component9", Player[playerid][CarSlot1Component9]);
	ini_getInteger(file, "CarSlot1Component10", Player[playerid][CarSlot1Component10]);
	ini_getInteger(file, "CarSlot1Component11", Player[playerid][CarSlot1Component11]);
	ini_getInteger(file, "CarSlot1Component12", Player[playerid][CarSlot1Component12]);
	ini_getInteger(file, "CarSlot1Component13", Player[playerid][CarSlot1Component13]);
	ini_getInteger(file, "CarSlot1NitroX", Player[playerid][CarSlot1NitroX]);
	ini_getInteger(file, "CarSlot2", Player[playerid][CarSlot2]);
	ini_getInteger(file, "CarSlot2Color1", Player[playerid][CarSlot2Color1]);
	ini_getInteger(file, "CarSlot2Color2", Player[playerid][CarSlot2Color2]);
	ini_getInteger(file, "CarSlot2PaintJob", Player[playerid][CarSlot2PaintJob]);
	ini_getInteger(file, "CarSlot2Neon", Player[playerid][CarSlot2Neon]);
	ini_getInteger(file, "CarSlot2Component0", Player[playerid][CarSlot2Component0]);
	ini_getInteger(file, "CarSlot2Component1", Player[playerid][CarSlot2Component1]);
	ini_getInteger(file, "CarSlot2Component2", Player[playerid][CarSlot2Component2]);
	ini_getInteger(file, "CarSlot2Component3", Player[playerid][CarSlot2Component3]);
	ini_getInteger(file, "CarSlot2Component4", Player[playerid][CarSlot2Component4]);
	ini_getInteger(file, "CarSlot2Component5", Player[playerid][CarSlot2Component5]);
	ini_getInteger(file, "CarSlot2Component6", Player[playerid][CarSlot2Component6]);
	ini_getInteger(file, "CarSlot2Component7", Player[playerid][CarSlot2Component7]);
	ini_getInteger(file, "CarSlot2Component8", Player[playerid][CarSlot2Component8]);
	ini_getInteger(file, "CarSlot2Component9", Player[playerid][CarSlot2Component9]);
	ini_getInteger(file, "CarSlot2Component10", Player[playerid][CarSlot2Component10]);
	ini_getInteger(file, "CarSlot2Component11", Player[playerid][CarSlot2Component11]);
	ini_getInteger(file, "CarSlot2Component12", Player[playerid][CarSlot2Component12]);
	ini_getInteger(file, "CarSlot2Component13", Player[playerid][CarSlot2Component13]);
	ini_getInteger(file, "CarSlot2NitroX", Player[playerid][CarSlot2NitroX]);
	ini_getInteger(file, "CarSlot3", Player[playerid][CarSlot3]);
	ini_getInteger(file, "CarSlot3Color1", Player[playerid][CarSlot3Color1]);
	ini_getInteger(file, "CarSlot3Color2", Player[playerid][CarSlot3Color2]);
	ini_getFloat(file, "GameGold", Player[playerid][GameGold]);
	ini_getFloat(file, "GameGoldTotal", Player[playerid][GameGoldTotal]);
	ini_getInteger(file, "GPremium", Player[playerid][GPremium]);
	ini_getInteger(file, "SkillHP", Player[playerid][SkillHP]);
	ini_getInteger(file, "SkillRepair", Player[playerid][SkillRepair]);
	ini_getInteger(file, "ActiveSkillPerson", Player[playerid][ActiveSkillPerson]);
	ini_getInteger(file, "ActiveSkillCar1", Player[playerid][ActiveSkillCar1]);
    ini_getInteger(file, "ActiveSkillCar2", Player[playerid][ActiveSkillCar2]);
    ini_getInteger(file, "ActiveSkillHCar1", Player[playerid][ActiveSkillHCar1]);
    ini_getInteger(file, "ActiveSkillHCar2", Player[playerid][ActiveSkillHCar2]);
	ini_getInteger(file, "Prestige", Player[playerid][Prestige]);
	ini_getInteger(file, "Karma", Player[playerid][Karma]);
	ini_getInteger(file, "KarmaTime", Player[playerid][KarmaTime]);
	ini_getFloat(file, "PosX", Player[playerid][PosX]);
	ini_getFloat(file, "PosY", Player[playerid][PosY]);
	ini_getFloat(file, "PosZ", Player[playerid][PosZ]);
	ini_getFloat(file, "PosA", Player[playerid][PosA]);
	ini_getInteger(file, "ConPM", Player[playerid][ConPM]);
	ini_getInteger(file, "ConInviteClan", Player[playerid][ConInviteClan]);
    ini_getInteger(file, "ConInvitePVP", Player[playerid][ConInvitePVP]);
    ini_getInteger(file, "ConMesPVP", Player[playerid][ConMesPVP]);
    ini_getInteger(file, "ConMesEnterExit", Player[playerid][ConMesEnterExit]);
    ini_getInteger(file, "ConSpeedo", Player[playerid][ConSpeedo]);
    ini_getInteger(file, "LastHourExp", Player[playerid][LastHourExp]);
    ini_getInteger(file, "LastHourReferalExp", Player[playerid][LastHourReferalExp]);
    ini_getString(file,"PlayerLimitXPDate", PlayerLimitXPDate[playerid]);
    ini_getInteger(file, "HelpTime", Player[playerid][HelpTime]);
    ini_getInteger(file, "EventChangeTime", Player[playerid][EventChangeTime]);
    ini_getString(file,"RegisterDate", RegisterDate[playerid]);
    ini_getString(file,"RegisterIP", RegisterIP[playerid]);
    ini_getString(file,"RegisterISP", RegisterISP[playerid]);
    ini_getString(file,"RegisterHost", RegisterHost[playerid]);
    ini_getString(file,"RegisterLocation", RegisterLocation[playerid]);
    ini_getInteger(file, "LeaveZM", Player[playerid][LeaveZM]);
    ini_getInteger(file, "ClanWarTime", Player[playerid][ClanWarTime]);
    ini_getInteger(file, "CasinoBalance", Player[playerid][CasinoBalance]);
    ini_getInteger(file, "GiveCashBalance", Player[playerid][GiveCashBalance]);
    ini_getString(file,"ChatName", ChatName[playerid]);
    ini_getInteger(file, "BuddhaTime", Player[playerid][BuddhaTime]);
    ini_getInteger(file, "PrestigeColor", Player[playerid][PrestigeColor]);
    ini_getInteger(file, "Quest1", Quest[playerid][0]);
    ini_getInteger(file, "Quest1Score", QuestScore[playerid][0]);
    ini_getInteger(file, "Quest1Time", QuestTime[playerid][0]);
    ini_getInteger(file, "Quest2", Quest[playerid][1]);
    ini_getInteger(file, "Quest2Score", QuestScore[playerid][1]);
    ini_getInteger(file, "Quest2Time", QuestTime[playerid][1]);
    ini_getInteger(file, "Quest3", Quest[playerid][2]);
    ini_getInteger(file, "Quest3Score", QuestScore[playerid][2]);
    ini_getInteger(file, "Quest3Time", QuestTime[playerid][2]);
    ini_getInteger(file, "Medals", Player[playerid][Medals]);
    ini_getInteger(file, "CompletedQuests", Player[playerid][CompletedQuests]);
    ini_getFloat(file, "GGFromMedals", Player[playerid][GGFromMedals]);
    ini_getFloat(file, "GGFromMedalsTotal", Player[playerid][GGFromMedalsTotal]);
    ini_getFloat(file, "GGFromMedalsLastDay", Player[playerid][GGFromMedalsLastDay]);
	ini_closeFile(file);
	return 1;
}

stock SavePlayer(playerid)
{
	if (Logged[playerid] == 0 || Player[playerid][Level] == 0) return 1; //Проверка на ненулевой лвл исправляет баг с обнулением аккаунта
	new filename[MAX_FILE_NAME], file;
	format(filename, sizeof(filename), "accounts/%s.ini", GetName(playerid));
	file = ini_openFile(filename);
	ini_setString(file,"Password", PlayerPass[playerid]);
	ini_setInteger(file, "Model", Player[playerid][Model]);
	ini_setInteger(file, "Admin", Player[playerid][Admin]);
	ini_setInteger(file, "Level", Player[playerid][Level]);
	ini_setInteger(file, "Exp", Player[playerid][Exp]);
	ini_setInteger(file, "Spawn", Player[playerid][Spawn]);
	ini_setInteger(file, "SpawnStyle", Player[playerid][SpawnStyle]);
	ini_setInteger(file, "Invisible", Player[playerid][Invisible]);
	ini_setInteger(file, "Time", Player[playerid][Time]);
	ini_setInteger(file, "Cash", Player[playerid][Cash]);
	ini_setInteger(file, "Bank", Player[playerid][Bank]);
	ini_setInteger(file, "Banned", Player[playerid][Banned]);
	ini_setString(file,"BannedBy", BannedBy[playerid]);
	ini_setString(file,"BanReason", BanReason[playerid]);
	ini_setInteger(file, "Muted", Player[playerid][Muted]);
	ini_setString(file,"MutedBy", MutedBy[playerid]);
	ini_setInteger(file, "Slot1", Player[playerid][Slot1]);
	ini_setInteger(file, "Slot2", Player[playerid][Slot2]);
	ini_setInteger(file, "Slot3", Player[playerid][Slot3]);
	ini_setInteger(file, "Slot4", Player[playerid][Slot4]);
	ini_setInteger(file, "Slot5", Player[playerid][Slot5]);
	ini_setInteger(file, "Slot6", Player[playerid][Slot6]);
	ini_setInteger(file, "Slot7", Player[playerid][Slot7]);
	ini_setInteger(file, "Slot8", Player[playerid][Slot8]);
	ini_setInteger(file, "Slot9", Player[playerid][Slot9]);
	ini_setInteger(file, "Slot10", Player[playerid][Slot10]);
	ini_setInteger(file, "MyClan", Player[playerid][MyClan]);
	ini_setInteger(file, "Member", Player[playerid][Member]);
	ini_setInteger(file, "Leader", Player[playerid][Leader]);
	ini_setInteger(file, "Home", Player[playerid][Home]);
	ini_setInteger(file, "Account", Player[playerid][Account]);
	ini_setInteger(file, "CarSlot1", Player[playerid][CarSlot1]);
	ini_setInteger(file, "CarSlot1Color1", Player[playerid][CarSlot1Color1]);
	ini_setInteger(file, "CarSlot1Color2", Player[playerid][CarSlot1Color2]);
	ini_setInteger(file, "CarSlot2", Player[playerid][CarSlot2]);
	ini_setInteger(file, "CarSlot2Color1", Player[playerid][CarSlot2Color1]);
	ini_setInteger(file, "CarSlot2Color2", Player[playerid][CarSlot2Color2]);
	ini_setInteger(file, "CarSlot3", Player[playerid][CarSlot3]);
	ini_setInteger(file, "CarSlot3Color1", Player[playerid][CarSlot3Color1]);
	ini_setInteger(file, "CarSlot3Color2", Player[playerid][CarSlot3Color2]);
	ini_setFloat(file, "GameGold", Player[playerid][GameGold]);
	ini_setFloat(file, "GameGoldTotal", Player[playerid][GameGoldTotal]);
	ini_setInteger(file, "GPremium", Player[playerid][GPremium]);
	ini_setInteger(file, "SkillHP", Player[playerid][SkillHP]);
	ini_setInteger(file, "SkillRepair", Player[playerid][SkillRepair]);
	ini_setInteger(file, "ActiveSkillPerson", Player[playerid][ActiveSkillPerson]);
	ini_setInteger(file, "ActiveSkillCar1", Player[playerid][ActiveSkillCar1]);
    ini_setInteger(file, "ActiveSkillCar2", Player[playerid][ActiveSkillCar2]);
    ini_setInteger(file, "ActiveSkillHCar1", Player[playerid][ActiveSkillHCar1]);
    ini_setInteger(file, "ActiveSkillHCar2", Player[playerid][ActiveSkillHCar2]);
	ini_setInteger(file, "Prestige", Player[playerid][Prestige]);
	ini_setInteger(file, "Karma", Player[playerid][Karma]);
	ini_setInteger(file, "KarmaTime", Player[playerid][KarmaTime]);
	ini_setFloat(file, "PosX", Player[playerid][PosX]);
	ini_setFloat(file, "PosY", Player[playerid][PosY]);
	ini_setFloat(file, "PosZ", Player[playerid][PosZ]);
	ini_setFloat(file, "PosA", Player[playerid][PosA]);
	ini_setInteger(file, "ConPM", Player[playerid][ConPM]);
	ini_setInteger(file, "ConInviteClan", Player[playerid][ConInviteClan]);
	ini_setInteger(file, "ConInvitePVP", Player[playerid][ConInvitePVP]);
	ini_setInteger(file, "ConMesPVP", Player[playerid][ConMesPVP]);
	ini_setInteger(file, "ConMesEnterExit", Player[playerid][ConMesEnterExit]);
	ini_setInteger(file, "ConSpeedo", Player[playerid][ConSpeedo]);
	ini_setInteger(file, "LastHourExp", Player[playerid][LastHourExp]);
	ini_setInteger(file, "LastHourReferalExp", Player[playerid][LastHourReferalExp]);
	ini_setString(file,"PlayerLimitXPDate", PlayerLimitXPDate[playerid]);
	ini_setString(file,"LastIP", PlayerIP[playerid]);
	ini_setInteger(file, "HelpTime", Player[playerid][HelpTime]);
	ini_setInteger(file, "EventChangeTime", Player[playerid][EventChangeTime]);
	ini_setInteger(file, "LeaveZM", Player[playerid][LeaveZM]);
	ini_setInteger(file, "ClanWarTime", Player[playerid][ClanWarTime]);
	ini_setInteger(file, "CasinoBalance", Player[playerid][CasinoBalance]);
	ini_setInteger(file, "GiveCashBalance", Player[playerid][GiveCashBalance]);
	ini_setString(file,"ChatName", ChatName[playerid]);
	ini_setInteger(file, "BuddhaTime", Player[playerid][BuddhaTime]);
	ini_setInteger(file, "PrestigeColor", Player[playerid][PrestigeColor]);
   ini_setInteger(file, "Quest1", Quest[playerid][0]);
    ini_setInteger(file, "Quest1Score", QuestScore[playerid][0]);
    ini_setInteger(file, "Quest1Time", QuestTime[playerid][0]);
    ini_setInteger(file, "Quest2", Quest[playerid][1]);
    ini_setInteger(file, "Quest2Score", QuestScore[playerid][1]);
    ini_setInteger(file, "Quest2Time", QuestTime[playerid][1]);
    ini_setInteger(file, "Quest3", Quest[playerid][2]);
    ini_setInteger(file, "Quest3Score", QuestScore[playerid][2]);
    ini_setInteger(file, "Quest3Time", QuestTime[playerid][2]);
    ini_setInteger(file, "Medals", Player[playerid][Medals]);
    ini_setInteger(file, "CompletedQuests", Player[playerid][CompletedQuests]);
    ini_setFloat(file, "GGFromMedals", Player[playerid][GGFromMedals]);
    ini_setFloat(file, "GGFromMedalsTotal", Player[playerid][GGFromMedalsTotal]);
    ini_setFloat(file, "GGFromMedalsLastDay", Player[playerid][GGFromMedalsLastDay]);
	ini_closeFile(file);
	return 1;
}

stock SaveTune(playerid)
{
	if (Logged[playerid] == 0) return 1;
	new filename[MAX_FILE_NAME], file;
	format(filename, sizeof(filename), "accounts/%s.ini", GetName(playerid));
	file = ini_openFile(filename);
	ini_setInteger(file, "CarSlot1PaintJob", Player[playerid][CarSlot1PaintJob]);
	ini_setInteger(file, "CarSlot1Neon", Player[playerid][CarSlot1Neon]);
	ini_setInteger(file, "CarSlot1Component0", Player[playerid][CarSlot1Component0]);
	ini_setInteger(file, "CarSlot1Component1", Player[playerid][CarSlot1Component1]);
	ini_setInteger(file, "CarSlot1Component2", Player[playerid][CarSlot1Component2]);
	ini_setInteger(file, "CarSlot1Component3", Player[playerid][CarSlot1Component3]);
	ini_setInteger(file, "CarSlot1Component4", Player[playerid][CarSlot1Component4]);
	ini_setInteger(file, "CarSlot1Component5", Player[playerid][CarSlot1Component5]);
	ini_setInteger(file, "CarSlot1Component6", Player[playerid][CarSlot1Component6]);
	ini_setInteger(file, "CarSlot1Component7", Player[playerid][CarSlot1Component7]);
	ini_setInteger(file, "CarSlot1Component8", Player[playerid][CarSlot1Component8]);
	ini_setInteger(file, "CarSlot1Component9", Player[playerid][CarSlot1Component9]);
	ini_setInteger(file, "CarSlot1Component10", Player[playerid][CarSlot1Component10]);
	ini_setInteger(file, "CarSlot1Component11", Player[playerid][CarSlot1Component11]);
	ini_setInteger(file, "CarSlot1Component12", Player[playerid][CarSlot1Component12]);
	ini_setInteger(file, "CarSlot1Component13", Player[playerid][CarSlot1Component13]);
	ini_setInteger(file, "CarSlot1NitroX", Player[playerid][CarSlot1NitroX]);
	ini_setInteger(file, "CarSlot2PaintJob", Player[playerid][CarSlot2PaintJob]);
	ini_setInteger(file, "CarSlot2Neon", Player[playerid][CarSlot2Neon]);
	ini_setInteger(file, "CarSlot2Component0", Player[playerid][CarSlot2Component0]);
	ini_setInteger(file, "CarSlot2Component1", Player[playerid][CarSlot2Component1]);
	ini_setInteger(file, "CarSlot2Component2", Player[playerid][CarSlot2Component2]);
	ini_setInteger(file, "CarSlot2Component3", Player[playerid][CarSlot2Component3]);
	ini_setInteger(file, "CarSlot2Component4", Player[playerid][CarSlot2Component4]);
	ini_setInteger(file, "CarSlot2Component5", Player[playerid][CarSlot2Component5]);
	ini_setInteger(file, "CarSlot2Component6", Player[playerid][CarSlot2Component6]);
	ini_setInteger(file, "CarSlot2Component7", Player[playerid][CarSlot2Component7]);
	ini_setInteger(file, "CarSlot2Component8", Player[playerid][CarSlot2Component8]);
	ini_setInteger(file, "CarSlot2Component9", Player[playerid][CarSlot2Component9]);
	ini_setInteger(file, "CarSlot2Component10", Player[playerid][CarSlot2Component10]);
	ini_setInteger(file, "CarSlot2Component11", Player[playerid][CarSlot2Component11]);
	ini_setInteger(file, "CarSlot2Component12", Player[playerid][CarSlot2Component12]);
	ini_setInteger(file, "CarSlot2Component13", Player[playerid][CarSlot2Component13]);
	ini_setInteger(file, "CarSlot2NitroX", Player[playerid][CarSlot2NitroX]);
	ini_closeFile(file);
	return 1;
}

stock ResetTuneClass1(playerid)
{
	Player[playerid][CarSlot1PaintJob] = -1;
	Player[playerid][CarSlot1Component0] = 0;Player[playerid][CarSlot1Component1] = 0;Player[playerid][CarSlot1Component2] = 0;
	Player[playerid][CarSlot1Component3] = 0;Player[playerid][CarSlot1Component4] = 0;Player[playerid][CarSlot1Component5] = 0;
	Player[playerid][CarSlot1Component6] = 0;Player[playerid][CarSlot1Component7] = 0;Player[playerid][CarSlot1Component8] = 0;
	Player[playerid][CarSlot1Component9] = 0;Player[playerid][CarSlot1Component10] = 0;Player[playerid][CarSlot1Component11] = 0;
	Player[playerid][CarSlot1Component12] = 0;Player[playerid][CarSlot1Component13] = 0;
	Player[playerid][CarSlot1NitroX] = 0;Player[playerid][CarSlot1Neon] = 0;
	SaveTune(playerid); return 1;
}

stock ResetTuneClass2(playerid)
{
    Player[playerid][CarSlot2PaintJob] = -1;
	Player[playerid][CarSlot2Component0] = 0;Player[playerid][CarSlot2Component1] = 0;Player[playerid][CarSlot2Component2] = 0;
	Player[playerid][CarSlot2Component3] = 0;Player[playerid][CarSlot2Component4] = 0;Player[playerid][CarSlot2Component5] = 0;
	Player[playerid][CarSlot2Component6] = 0;Player[playerid][CarSlot2Component7] = 0;Player[playerid][CarSlot2Component8] = 0;
	Player[playerid][CarSlot2Component9] = 0;Player[playerid][CarSlot2Component10] = 0;Player[playerid][CarSlot2Component11] = 0;
	Player[playerid][CarSlot2Component12] = 0;Player[playerid][CarSlot2Component13] = 0;
	Player[playerid][CarSlot2NitroX] = 0;Player[playerid][CarSlot2Neon] = 0;
	SaveTune(playerid); return 1;
}

stock UpdatePlayer(playerid)
{
	new filename[MAX_FILE_NAME], file, String[120];
	format(filename, sizeof(filename), "UpdatePlayer/%s.ini", GetName(playerid));
    if(fexist(filename))
	{//если файл обновления существует
		file = ini_openFile(filename);
		ini_getInteger(file, "Прибавить к Level", ChangePlayer[playerid][Level]);
		ini_getInteger(file, "Прибавить к Exp", ChangePlayer[playerid][Exp]);
		ini_getInteger(file, "Прибавить к Bank", ChangePlayer[playerid][Bank]);
		ini_getFloat(file, "Прибавить к GameGold", ChangePlayer[playerid][GameGold]);
		ini_closeFile(file);
		if (ChangePlayer[playerid][Level] != 0)
		{//Изменение уровня
		    format(String, sizeof String, "UpdatePlayer: Ваш уровень был изменен на {FFFFFF}%d", ChangePlayer[playerid][Level]);
		    SendClientMessage(playerid, COLOR_YELLOW, String); PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
		    format(String, sizeof String, "%d.%d.%d в %d:%d:%d |   UpdatePlayer: Уровень игрока %s[%d] был изменен на %d", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid, ChangePlayer[playerid][Level]);
			WriteLog("GlobalLog", String);WriteLog("UpdatePlayer", String);
			Player[playerid][Level] += ChangePlayer[playerid][Level]; ChangePlayer[playerid][Level] = 0;
            SavePlayer(playerid);
		}//Изменение уровня
		if (ChangePlayer[playerid][Exp] != 0)
		{//Изменение ХР
		    format(String, sizeof String, "UpdatePlayer: Количество вашего ХР изменено на {FFFFFF}%d", ChangePlayer[playerid][Exp]);
		    SendClientMessage(playerid, COLOR_YELLOW, String); PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
		    format(String, sizeof String, "%d.%d.%d в %d:%d:%d |   UpdatePlayer: Количество ХР игрока %s[%d] было изменено на %d", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid, ChangePlayer[playerid][Exp]);
			WriteLog("GlobalLog", String);WriteLog("UpdatePlayer", String);
			Player[playerid][Exp] += ChangePlayer[playerid][Exp]; ChangePlayer[playerid][Exp] = 0;
			if (Player[playerid][Exp] >= NeedXP[playerid]) PlayerLevelUp(playerid);
			else SavePlayer(playerid);
		}//Изменение ХР
		if (ChangePlayer[playerid][Bank] != 0)
		{//Изменение денег в банке
            format(String, sizeof String, "UpdatePlayer: Количество ваших денег (в банке) было изменено на {FFFFFF}%d", ChangePlayer[playerid][Bank]);
		    SendClientMessage(playerid, COLOR_YELLOW, String); PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
		    format(String, sizeof String, "%d.%d.%d в %d:%d:%d |   UpdatePlayer: Количество денег (в банке) у игрока %s[%d] было изменено на %d", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid, ChangePlayer[playerid][Bank]);
			WriteLog("GlobalLog", String);WriteLog("UpdatePlayer", String);
			Player[playerid][Bank] += ChangePlayer[playerid][Bank]; ChangePlayer[playerid][Bank] = 0;
            SavePlayer(playerid);
		}//Изменение денег в банке
		if (ChangePlayer[playerid][GameGold] != 0)
		{//Изменение GG
		    format(String, sizeof String, "UpdatePlayer: Количество ваших рублей было изменено на {FFFFFF}%0.2f", ChangePlayer[playerid][GameGold]);
		    SendClientMessage(playerid, COLOR_YELLOW, String); PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
		    format(String, sizeof String, "%d.%d.%d в %d:%d:%d |   UpdatePlayer: Количество рублей игрока %s[%d] было изменено на %0.2f", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid, ChangePlayer[playerid][GameGold]);
			WriteLog("GlobalLog", String);WriteLog("UpdatePlayer", String);WriteLog("Shop", String);
			Player[playerid][GameGold] += ChangePlayer[playerid][GameGold]; if (ChangePlayer[playerid][GameGold] > 0){Player[playerid][GameGoldTotal] += ChangePlayer[playerid][GameGold];} ChangePlayer[playerid][GameGold] = 0;
            SavePlayer(playerid);
		}//Изменение GG
		file = ini_openFile(filename);
		ini_setInteger(file, "Прибавить к Level", ChangePlayer[playerid][Level]);
		ini_setInteger(file, "Прибавить к Exp", ChangePlayer[playerid][Exp]);
		ini_setInteger(file, "Прибавить к Bank", ChangePlayer[playerid][Bank]);
		ini_setFloat(file, "Прибавить к GameGold", ChangePlayer[playerid][GameGold]);
		ini_closeFile(file);
	}//если файл обновления существует
	else
	{//если не существует
	    file = ini_createFile(filename);
	    if(file < 0) file = ini_openFile (filename);
		if(file >= 0)
		{
			ini_setInteger(file, "Прибавить к Level", 0);
			ini_setInteger(file, "Прибавить к Exp", 0);
			ini_setInteger(file, "Прибавить к Bank", 0);
			ini_setFloat(file, "Прибавить к GameGold", 0);
			ini_closeFile(file);
		}
	}//если не существует
	
	return 1;
}


stock ResetProperty(houseid)
{
		Property[houseid][pOwner] = 0;
		Property[houseid][pName] = 0;
		Property[houseid][pPrice] = 1;
		Property[houseid][pPosEnterX] = 0.0;
		Property[houseid][pPosEnterY] = 0.0;
		Property[houseid][pPosEnterZ] = 0.0;
		Property[houseid][pPosEnterA] = 0.0;
		Property[houseid][pPosRespawnX] = 0.0;
		Property[houseid][pPosRespawnY] = 0.0;
		Property[houseid][pPosRespawnZ] = 0.0;
		Property[houseid][pPosRespawnA] = 0.0;
		Property[houseid][pOpened] = 0;
		Property[houseid][pBuyBlock] = 0;
}

stock LoadAllProperty()
{
	for(new i = 1; i < MAX_PROPERTY; i++)
	{
		new filename[MAX_FILE_NAME], file, text3d[MAX_3DTEXT];
		format(filename, sizeof(filename), "PlayerHouses/%i.ini", i);
		if(!fexist(filename)) continue;
		ResetProperty(i);//Чтобы можно было с новыми обновами добавлять новые переменные без вайпа домов.
		file = ini_openFile(filename);
		ini_getString(file, "Owner", Property[i][pOwner], MAX_PLAYER_NAME);
		ini_getString(file, "Name", Property[i][pName], 32);
		ini_getInteger(file, "Price", Property[i][pPrice]);
		ini_getFloat(file, "PosEnterX", Property[i][pPosEnterX]);
		ini_getFloat(file, "PosEnterY", Property[i][pPosEnterY]);
		ini_getFloat(file, "PosEnterZ", Property[i][pPosEnterZ]);
		ini_getFloat(file, "PosEnterA", Property[i][pPosEnterA]);
		ini_getFloat(file, "PosRespawnX", Property[i][pPosRespawnX]);
		ini_getFloat(file, "PosRespawnY", Property[i][pPosRespawnY]);
		ini_getFloat(file, "PosRespawnZ", Property[i][pPosRespawnZ]);
		ini_getFloat(file, "PosRespawnA", Property[i][pPosRespawnA]);
		ini_getInteger(file, "Opened", Property[i][pOpened]);
		ini_getInteger(file, "BuyBlock", Property[i][pBuyBlock]);
		ini_closeFile(file);
		if(Property[i][pBuyBlock] <= 0)
		{
			format(text3d, sizeof(text3d), "{00FF00}Дом ({FFFFFF}%d${00FF00})\n{007FFF}Владелец:{FFFFFF} %s\nНажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать", Property[i][pPrice], Property[i][pOwner]);
			PropertyText3D[i] = CreateDynamic3DTextLabel(text3d, COLOR_WHITE, Property[i][pPosEnterX], Property[i][pPosEnterY], Property[i][pPosEnterZ], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0, -1, 11.0);
		}
		else
		{
			format(text3d, sizeof(text3d), "{00FF00}Дом ({FF0000}Не продается{00FF00})\n{007FFF}Владелец:{FFFFFF} %s\nНажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать", Property[i][pOwner]);
			PropertyText3D[i] = CreateDynamic3DTextLabel(text3d, COLOR_WHITE, Property[i][pPosEnterX], Property[i][pPosEnterY], Property[i][pPosEnterZ], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0, -1, 11.0);
			SuperProperty++;//статистика - кол-во неперекупаемых домов
		}
		PropertyPickup[i] = CreateDynamicPickup(1273, 1, Property[i][pPosEnterX], Property[i][pPosEnterY], Property[i][pPosEnterZ], -1, -1, -1, 100.0);
		PropertyMapIcon[i] = CreateDynamicMapIcon(Property[i][pPosEnterX], Property[i][pPosEnterY], Property[i][pPosEnterZ], 31, 0, -1, -1, -1, 100.0);
		new DynamicPickupID = PropertyPickup[i];
		DynamicPickup[DynamicPickupID][Type] = 1;//тип пикапа - дом
		DynamicPickup[DynamicPickupID][ID] = i;//id дома пикапа
		
		if(strcmp(Property[i][pOwner], "Никто")){OwnedProperty++;}//статистика - купленных домов
		LastProperty++;
	}
	new log[MAX_MESSAGE];

	format(log, sizeof(log), "Система домов загружена. Всего домов: %i. Занято: %i. Неперекупаемых: %i.", LastProperty - 1, OwnedProperty, SuperProperty);
	print(log);
}

stock LoadAllBase()
{
	for(new i = 1; i < MAX_BASE; i++)
	{
		new filename[MAX_FILE_NAME], file, text3d[MAX_3DTEXT];
		format(filename, sizeof(filename), "Base/%i.ini", i);
		if(!fexist(filename)) continue;
		file = ini_openFile(filename);
		ini_getInteger(file, "Clan", Base[i][bClan]);
		ini_getInteger(file, "Price", Base[i][bPrice]);
		ini_getFloat(file, "PosEnterX", Base[i][bPosEnterX]);
		ini_getFloat(file, "PosEnterY", Base[i][bPosEnterY]);
		ini_getFloat(file, "PosEnterZ", Base[i][bPosEnterZ]);
		ini_getFloat(file, "PosEnterA", Base[i][bPosEnterA]);
		ini_getFloat(file, "PosRespawnX", Base[i][bPosRespawnX]);
		ini_getFloat(file, "PosRespawnY", Base[i][bPosRespawnY]);
		ini_getFloat(file, "PosRespawnZ", Base[i][bPosRespawnZ]);
		ini_getFloat(file, "PosRespawnA", Base[i][bPosRespawnA]);
		ini_closeFile(file);
		new clanid = Base[i][bClan];
		if(Base[i][bPrice] >= 0)
		{
			if (clanid > 0) format(text3d, sizeof(text3d), "{007FFF}Штаб ({FFFFFF}%d${007FFF})\n{008E00}Клан:{FFFFFF} %s\nНажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать", Base[i][bPrice], Clan[clanid][cName]);
			else format(text3d, sizeof(text3d), "{007FFF}Штаб ({FFFFFF}%d${007FFF})\n{008E00}Клан:{FFFFFF} Никто\nНажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать", Base[i][bPrice]);
			BaseText3D[i] = CreateDynamic3DTextLabel(text3d, COLOR_WHITE, Base[i][bPosEnterX], Base[i][bPosEnterY], Base[i][bPosEnterZ], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0, -1, 11.0);
		}
		else if(Base[i][bPrice] < 0)
		{
			if (clanid > 0) format(text3d, sizeof(text3d), "{007FFF}Штаб ({AFAFAF}Не продается{007FFF})\n{008E00}Клан:{FFFFFF} %s\nНажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать", Clan[clanid][cName]);
            else format(text3d, sizeof(text3d), "{007FFF}Штаб ({FFFFFF}%d${007FFF})\n{008E00}Клан:{FFFFFF} Никто\nНажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать", Base[i][bPrice]);
			BaseText3D[i] = CreateDynamic3DTextLabel(text3d, COLOR_WHITE, Base[i][bPosEnterX], Base[i][bPosEnterY], Base[i][bPosEnterZ], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0, -1, 11.0);
		}
		BasePickup[i] = CreateDynamicPickup(1272, 1, Base[i][bPosEnterX], Base[i][bPosEnterY], Base[i][bPosEnterZ], -1, -1, -1, 100.0);
		BaseMapIcon[i] = CreateDynamicMapIcon(Base[i][bPosEnterX], Base[i][bPosEnterY], Base[i][bPosEnterZ], 32, 0, -1, -1, -1, 100.0);
        new DynamicPickupID = BasePickup[i];
		DynamicPickup[DynamicPickupID][Type] = 2;//тип пикапа - штаб
		DynamicPickup[DynamicPickupID][ID] = i;//id штаба пикапа

		if(Base[i][bClan] > 0) OwnedBase++;
		LastBase++;
	}
	new log[MAX_MESSAGE];

	format(log, sizeof(log), "Система штабов загружена. Всего штабов: %d. Занято: %d.", LastBase - 1, OwnedBase);
	print(log);
}

stock LoadAllClans()
{
    new filename[MAX_FILE_NAME], file, clans = 0, LastClan = 0;
	for(new i = 1; i < MAX_CLAN; i++)
	{
		format(filename, sizeof(filename), "Clans/%d.ini", i); LastClan++;
		if(!fexist(filename)) {Clan[i][cLevel] = 0; continue;} //несуществующий клан
		else
		{//клан существует
		    file = ini_openFile(filename);
		    ini_getInteger(file, "Level", Clan[i][cLevel]);
			ini_getString(file, "Lider", Clan[i][cLider], MAX_PLAYER_NAME);
			ini_getString(file, "Name", Clan[i][cName], MAX_PLAYER_NAME);
			ini_getString(file, "Message", Clan[i][cMessage], 125);
			ini_getInteger(file, "Color", Clan[i][cColor]);
			ini_getInteger(file, "Base", Clan[i][cBase]);
			ini_getInteger(file, "XP", Clan[i][cXP]);
			ini_getInteger(file, "LastDay", Clan[i][cLastDay]);
			ini_getInteger(file, "EnemyClan", Clan[i][cEnemyClan]);
			ini_getInteger(file, "CWwin", Clan[i][cCWwin]);
			ini_getString(file, "Member1", Clan[i][cMember1], MAX_PLAYER_NAME);
			ini_getString(file, "Member2", Clan[i][cMember2], MAX_PLAYER_NAME);
			ini_getString(file, "Member3", Clan[i][cMember3], MAX_PLAYER_NAME);
			ini_getString(file, "Member4", Clan[i][cMember4], MAX_PLAYER_NAME);
			ini_getString(file, "Member5", Clan[i][cMember5], MAX_PLAYER_NAME);
			ini_getString(file, "Member6", Clan[i][cMember6], MAX_PLAYER_NAME);
			ini_getString(file, "Member7", Clan[i][cMember7], MAX_PLAYER_NAME);
			ini_getString(file, "Member8", Clan[i][cMember8], MAX_PLAYER_NAME);
			ini_getString(file, "Member9", Clan[i][cMember9], MAX_PLAYER_NAME);
			ini_getString(file, "Member10", Clan[i][cMember10], MAX_PLAYER_NAME);
			ini_getString(file, "Member11", Clan[i][cMember11], MAX_PLAYER_NAME);
			ini_getString(file, "Member12", Clan[i][cMember12], MAX_PLAYER_NAME);
			ini_getString(file, "Member13", Clan[i][cMember13], MAX_PLAYER_NAME);
			ini_getString(file, "Member14", Clan[i][cMember14], MAX_PLAYER_NAME);
			ini_getString(file, "Member15", Clan[i][cMember15], MAX_PLAYER_NAME);
			ini_getString(file, "Member16", Clan[i][cMember16], MAX_PLAYER_NAME);
			ini_getString(file, "Member17", Clan[i][cMember17], MAX_PLAYER_NAME);
			ini_getString(file, "Member18", Clan[i][cMember18], MAX_PLAYER_NAME);
			ini_getString(file, "Member19", Clan[i][cMember19], MAX_PLAYER_NAME);
			ini_getString(file, "Member20", Clan[i][cMember20], MAX_PLAYER_NAME);
		    ini_closeFile(file);
		    clans++; MaxClanID = i;
		}//клан существует
	}
	new log[MAX_MESSAGE];

	format(log, sizeof(log), "Система кланов загружена. Всего кланов: %d. Максимум: %d.", clans, LastClan);
	print(log);
}

stock SaveBase(baseid)
{
	new filename[MAX_FILE_NAME], file;
	format(filename, sizeof(filename), "Base/%i.ini", baseid);
	file = ini_openFile(filename);
	ini_setInteger(file, "Clan", Base[baseid][bClan]);
	ini_setInteger(file, "Price", Base[baseid][bPrice]);
	ini_setFloat(file, "PosEnterX", Base[baseid][bPosEnterX]);
	ini_setFloat(file, "PosEnterY", Base[baseid][bPosEnterY]);
	ini_setFloat(file, "PosEnterZ", Base[baseid][bPosEnterZ]);
	ini_setFloat(file, "PosEnterA", Base[baseid][bPosEnterA]);
	ini_setFloat(file, "PosRespawnX", Base[baseid][bPosRespawnX]);
	ini_setFloat(file, "PosRespawnY", Base[baseid][bPosRespawnY]);
	ini_setFloat(file, "PosRespawnZ", Base[baseid][bPosRespawnZ]);
	ini_setFloat(file, "PosRespawnA", Base[baseid][bPosRespawnA]);
	ini_closeFile(file);
}
stock SaveAllBase()	for(new i = 1; i < MAX_BASE; i++) SaveBase(i);

stock SaveProperty(houseid)
{
	new filename[MAX_FILE_NAME], file;
	format(filename, sizeof(filename), "PlayerHouses/%i.ini", houseid);
	file = ini_openFile(filename);
	ini_setString(file, "Owner", Property[houseid][pOwner]);
	ini_setString(file, "Name", Property[houseid][pName]);
	ini_setInteger(file, "Price", Property[houseid][pPrice]);
	ini_setFloat(file, "PosEnterX", Property[houseid][pPosEnterX]);
	ini_setFloat(file, "PosEnterY", Property[houseid][pPosEnterY]);
	ini_setFloat(file, "PosEnterZ", Property[houseid][pPosEnterZ]);
	ini_setFloat(file, "PosEnterA", Property[houseid][pPosEnterA]);
	ini_setFloat(file, "PosRespawnX", Property[houseid][pPosRespawnX]);
	ini_setFloat(file, "PosRespawnY", Property[houseid][pPosRespawnY]);
	ini_setFloat(file, "PosRespawnZ", Property[houseid][pPosRespawnZ]);
	ini_setFloat(file, "PosRespawnA", Property[houseid][pPosRespawnA]);
	ini_setInteger(file, "Opened", Property[houseid][pOpened]);
	ini_setInteger(file, "BuyBlock", Property[houseid][pBuyBlock]);
	ini_closeFile(file);
}
stock SaveAllProperty() for(new i = 1; i < MAX_BASE; i++) SaveProperty(i);

stock SaveClan(clanid)
{
	new filename[MAX_FILE_NAME], file;
	format(filename, sizeof(filename), "Clans/%d.ini", clanid);
	file = ini_openFile(filename);
	ini_setInteger(file, "Level", Clan[clanid][cLevel]);
	ini_setString(file, "Lider", Clan[clanid][cLider]);
	ini_setString(file, "Name", Clan[clanid][cName]);
	ini_setString(file, "Message", Clan[clanid][cMessage]);
	ini_setInteger(file, "Color", Clan[clanid][cColor]);
	ini_setInteger(file, "Base", Clan[clanid][cBase]);
	ini_setInteger(file, "XP", Clan[clanid][cXP]);
	ini_setInteger(file, "LastDay", Clan[clanid][cLastDay]);
	ini_setInteger(file, "EnemyClan", Clan[clanid][cEnemyClan]);
	ini_setInteger(file, "CWwin", Clan[clanid][cCWwin]);
	ini_setString(file, "Member1", Clan[clanid][cMember1]);
	ini_setString(file, "Member2", Clan[clanid][cMember2]);
	ini_setString(file, "Member3", Clan[clanid][cMember3]);
	ini_setString(file, "Member4", Clan[clanid][cMember4]);
	ini_setString(file, "Member5", Clan[clanid][cMember5]);
	ini_setString(file, "Member6", Clan[clanid][cMember6]);
	ini_setString(file, "Member7", Clan[clanid][cMember7]);
	ini_setString(file, "Member8", Clan[clanid][cMember8]);
	ini_setString(file, "Member9", Clan[clanid][cMember9]);
	ini_setString(file, "Member10", Clan[clanid][cMember10]);
	ini_setString(file, "Member11", Clan[clanid][cMember11]);
	ini_setString(file, "Member12", Clan[clanid][cMember12]);
	ini_setString(file, "Member13", Clan[clanid][cMember13]);
	ini_setString(file, "Member14", Clan[clanid][cMember14]);
	ini_setString(file, "Member15", Clan[clanid][cMember15]);
	ini_setString(file, "Member16", Clan[clanid][cMember16]);
	ini_setString(file, "Member17", Clan[clanid][cMember17]);
	ini_setString(file, "Member18", Clan[clanid][cMember18]);
	ini_setString(file, "Member19", Clan[clanid][cMember19]);
	ini_setString(file, "Member20", Clan[clanid][cMember20]);
	ini_closeFile(file);
}
stock SaveAllClans() for(new i = 1; i <= MaxClanID; i++) if (Clan[i][cLevel] > 0) SaveClan(i);

stock ClansUpdate()
{//Удаление кланов, которые не купили штаб вовремя
	new xDay = DateToIntDate(Day, Month, Year);
    for(new i = 1; i <= MaxClanID; i++) if (Clan[i][cLevel] > 0)
    {//Существующий клан
        if (0 < Clan[i][cLastDay] <= xDay)
        {//Клан нужно распустить
        	new StringX[120], filename[MAX_FILE_NAME];
			format(StringX,sizeof(StringX),"Клан '{FFFFFF}%s{008E00}' был автоматически распущен из-за отсутствия штаба.",Clan[i][cName]); SendClientMessageToAll(COLOR_CLAN,StringX);
			format(filename, sizeof(filename), "Clans/%d.ini", i);
			dini_Remove(filename);//удаление файла клана
			Clan[i][cLevel] = 0;//Чтобы клан был недействителеьным
			foreach(Player, cid)
			{//цикл
				if (Player[cid][Member] != 0 && Player[cid][MyClan] == i)
				{//соклан
					Player[cid][MyClan] = 0;Player[cid][Member] = 0;Player[cid][Leader] = 0;
					PlayerColor[cid] = 0;SavePlayer(cid);
				}//соклан
			}//цикл
			for(new i2 = 0; i2 < MaxClanID; i2++) //убирает ID этого клана из списка врагов у всех кланов (если у кого есть)
					if (Clan[i2][cEnemyClan] == i) {Clan[i2][cEnemyClan] = 0; SaveClan(i2);}
        }//Клан нужно распустить
    }//Существующий клан
}//Удаление кланов, которые не купили штаб вовремя

HousesUpdate()
{//Снятие неперекупайки с тех домов, у кого она кончилась
    new xDay = DateToIntDate(Day, Month, Year), text3d[MAX_3DTEXT];
    for(new i = 1; i < MAX_PROPERTY; i++) if (Property[i][pBuyBlock] > 0 && Property[i][pBuyBlock] < xDay)
    {//Вышло время неперекупайки
        Property[i][pBuyBlock] = -1; SaveProperty(i);
        format(text3d, sizeof(text3d), "{00FF00}Дом ({FFFFFF}%d${00FF00})\n{007FFF}Владелец:{FFFFFF} %s\nНажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать", Property[i][pPrice], Property[i][pOwner]);
		UpdateDynamic3DTextLabelText(PropertyText3D[i], 0xFFFFFFFF, text3d);
    }//Вышло время неперекупайки
}//Снятие неперекупайки с тех домов, у кого она кончилась

///-------------------------------------- Новые функции








////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

new PlayerVehicleName[212][] = {
"Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel", "Dumper", "Firetruck", "Trashmaster", "Stretch", "Manana",
"Infernus", "Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam", "Esperanto", "Taxi", "Washington", "Bobcat",
"Whoopee", "BF Injection", "Hunter", "Premier", "Enforcer", "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife",
"Trailer 1", "Previon", "Coach", "Cabbie", "Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral", "Squalo",
"Seasparrow", "Pizzaboy", "Tram", "Trailer 2", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair",
"Berkley's RC Van", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale", "Oceanic", "Sanchez", "Sparrow",
"Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton", "Regina", "Comet", "BMX", "Burrito",
"Camper", "Marquis", "Baggage", "Dozer", "Maverick", "News Chopper", "Rancher", "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring",
"Sandking", "Blista Compact", "Police Maverick", "Boxvillde", "Benson", "Mesa", "RC Goblin", "Hotring Racer A", "Hotring Racer B",
"Bloodring Banger", "Rancher", "Super GT", "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropduster","Stunt",  "Tanker",
"Roadtrain", "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra", "FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Tow Truck", "Fortune",
"Cadrona", "FBI Truck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan", "Blade", "Freight", "Streak",
"Vortex", "Vincent", "Bullet", "Clover", "Sadler", "Firetruck LA", "Hustler", "Intruder", "Primo", "Cargobob", "Tampa", "Sunrise", "Merit",
"Utility", "Nevada", "Yosemite", "Windsor", "Monster A", "Monster B", "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance",
"RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito", "Freight Flat", "Streak Carriage", "Kart", "Mower", "Dune", "Sweeper", "Broadway",
"Tornado", "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400", "News Van", "Tug", "Trailer 3", "Emperor", "Wayfarer", "Euros", "Hotdog",
"Club", "Freight Carriage", "Trailer 4", "Andromada", "Dodo", "RC Cam", "Launch", "Police Car (LSPD)", "Police Car (SFPD)",
"Police Car (LVPD)", "Police Ranger", "Picador", "S.W.A.T", "Alpha", "Phoenix", "Glendale", "Sadler", "Luggage Trailer A",
"Luggage Trailer B", "Stairs", "Boxville", "Tiller", "Utility Trailer" };

#include "VehicleMaxSpeed"
stock GetVehicleMaxSpeed(vehicleid)
{//Получить макс. скорость автомобиля
	new model = GetVehicleModel(vehicleid) - 400;
	if (model < 0) return 300;//Если авто не существует - возвращаем 300
	else return VehicleMaxSpeed[model];
}//Получить макс. скорость автомобиля

stock SetVehicleSpeed(vehicleid, Float:Speed)
{
        new Float:X, Float:Y, Float:Z, Float:Angle;

        GetVehicleZAngle(vehicleid, Angle); 
        Speed = Speed/200;
        X = Speed * floatsin(-Angle, degrees);
        Y = Speed * floatcos(-Angle, degrees);
        SetVehicleVelocity(vehicleid, X, Y, Z);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Функция возвращает самое большое число из заданных в аргументах.
stock GetHighNumber(...)
{
	new high;
	for (new i = 0; i< numargs(); i++)
	if (getarg(i) > high) high = getarg(i);
	return high;
}

stock LCreateVehicle(modelid, Float:x, Float:y, Float:z, Float:angle, color1 = 0, color2 = 0, respawn_delay = -1)
{
	new vehicleid = CreateVehicle(modelid, Float:x, Float:y, Float:z, Float:angle, color1, color2, respawn_delay);
    if (vehicleid > MaxVehicleUsed) MaxVehicleUsed = vehicleid;
    //Уничтожение неона
    if (NeonObject1[vehicleid] != -1){DestroyDynamicObject(NeonObject1[vehicleid]);NeonObject1[vehicleid] = -1;}
	if (NeonObject2[vehicleid] != -1){DestroyDynamicObject(NeonObject2[vehicleid]);NeonObject2[vehicleid] = -1;}
	TrailerID[vehicleid] = -1; IsTrailer[vehicleid] = 0;//Машина не имеет трейлера и не является трейлером
    StealCarTimer[vehicleid] = 0;//Нужен только для авто для угона (ид 1-35)
    //ResetVehicle
    Vehicle[vehicleid][AntiDestroyTime] = 5;
    Vehicle[vehicleid][Owner] = -1;
    Vehicle[vehicleid][Health] = 1000.0; LACRepair[vehicleid] = 0;
    return vehicleid;
}

stock CallTrailer(vehicleid, trailermodel)
{//Вызов трейлера для авто
	new Float:x, Float: y, Float: z, Float:Angle, trailer; GetVehiclePos(vehicleid, x, y, z); GetVehicleZAngle(vehicleid, Angle);
	trailer = LCreateVehicle(trailermodel, x, y, z + 50, Angle, 0, 0, 0);
	TrailerID[vehicleid] = trailer; IsTrailer[trailer] = 1;
	SetTimerEx("TrailerUpdate" , 1000, false, "ii", vehicleid, trailermodel);
	return 1;
}//Вызов трейлера для авто

forward TrailerUpdate(vehicleid, trailermodel);
public TrailerUpdate(vehicleid, trailermodel)
{//обновление трейлера машины
	if (TrailerID[vehicleid] == -1) return 1;//Если у машины не должно быть трейлера - прекращаем
	new trailer = TrailerID[vehicleid];
	if (IsTrailer[trailer] == 0) return CallTrailer(vehicleid, trailermodel); //Если трейлера не существует - прекращаем и идем его создавать
	SetTimerEx("TrailerUpdate" , 1000, false, "ii", vehicleid, trailermodel);
	if (!IsTrailerAttachedToVehicle(vehicleid)) AttachTrailerToVehicle(trailer, vehicleid);
	Vehicle[trailer][AntiDestroyTime] = 5;//Чтобы трейлер не уничтожался пока он успешно прицеплен
	return 1;
}//обновление трейлера машины

public LSpawnPlayer(playerid)//вот тут вот
{//Выполняется в момент до самого респавна игрока
    if (IsPlayerInAnyVehicle(playerid)) DestroyVehicle(GetPlayerVehicleID(playerid));//исправляет баг, игрок, который в авто, не перемещается и кикается античитом на тп
	new Float: x, Float: y, Float: z, Float: Angle, w1, w1ammo, w2, w2ammo, w3, w3ammo;
    ResetPlayerWeapons(playerid);
    LACSH[playerid] = 3;LACTeleportOff[playerid] = 4;
	LACWeaponOff[playerid] = 3;
	CheatFlySec[playerid] = 0;
	SetPlayerInterior(playerid,0);SetPlayerVirtualWorld(playerid,0);
	WorldSpawn[playerid] = 0; TogglePlayerSpectating(playerid, 0);
	
	if (Logged[playerid] == 0)
	{//игрок не залогинился
		SetSpawnInfo(playerid, 0, Player[playerid][Model], 2351.0242, 2142.0093, 10.6824, Angle, w1, w1ammo, w2, w2ammo, w3, w3ammo);
		SpawnPlayer(playerid); SetPlayerVirtualWorld(playerid, playerid + 1);
	}//игрок не залогинился
	
	if (JoinEvent[playerid] == EVENT_DM && DMTimeToEnd > 0)
	{//дм-режим спавн
		#include "Transformer\DMPlayerSpawn"
		Weapons[playerid][w1] = 1;Weapons[playerid][w2] = 1;Weapons[playerid][w3] = 1;
		SetSpawnInfo(playerid, 0, Player[playerid][Model], x, y, z, Angle, w1, w1ammo, w2, w2ammo, w3, w3ammo);
        if (TimeAfterSpawn[playerid] < 5) TimeAfterSpawn[playerid] = 5;
		return SpawnPlayer(playerid);
	}//дм-режим спавн

	if (ZMStarted[playerid] == 1)
	{//зомби-режим спавн
        #include "Transformer\ZombiePlayerSpawn"
        Weapons[playerid][w1] = 1;Weapons[playerid][w2] = 1;Weapons[playerid][w3] = 1;
        SetSpawnInfo(playerid, 0, Player[playerid][Model], x, y, z, Angle, w1, w1ammo, w2, w2ammo, w3, w3ammo);
        if (TimeAfterSpawn[playerid] < 5) TimeAfterSpawn[playerid] = 5;
		return SpawnPlayer(playerid);
	}//зомби-режим спавн

	if (JoinEvent[playerid] == EVENT_GUNGAME && GGTimeToEnd > 0)
	{//гангейм спавн
		#include "Transformer\GGPlayerSpawn"
		Weapons[playerid][w1] = 1;Weapons[playerid][w2] = 1;Weapons[playerid][w3] = 1;
		SetSpawnInfo(playerid, 0, Player[playerid][Model], x, y, z, Angle, w1, w1ammo, w2, w2ammo, w3, w3ammo);
		if (TimeAfterSpawn[playerid] < 5) TimeAfterSpawn[playerid] = 5;
		return SpawnPlayer(playerid);
	}//гангейм спавн

    TimeAfterSpawn[playerid] = 0; SetPlayerChatBubble(playerid, "Только что зареспавнился", COLOR_GREEN, 300.0, 5000);

	if (Player[playerid][Level] == 0)
	{//первый спавн - грув
	    x = 2491.1553; y = -1667.5907; z = 13.0260; Angle = 90;
		SetPlayerInterior(playerid,0);
		SetPlayerVirtualWorld(playerid,playerid+1);//вирт. ворлд в обучении
	}//первый спавн - грув
	
	//------ Spawn и SpawnStyle
    if (Player[playerid][Spawn] == 4 || Player[playerid][Spawn] == 6  || Player[playerid][Spawn] == 7) {if (Player[playerid][Home] == 0) Player[playerid][Spawn] = 0;}
    //Исправление, когда стоит спавн "Личный дом", а дома у игрока нет

	if (Player[playerid][Spawn] == 4)
	{//спавн в доме
		new rand = Player[playerid][Home];
		x = Property[rand][pPosRespawnX]; y = Property[rand][pPosRespawnY]; z =Property[rand][pPosRespawnZ]; Angle = Property[rand][pPosRespawnA];
	}//спавн в доме
	
	if (Player[playerid][Spawn] == 5)
	{//спавн в штабе
		new clanid = Player[playerid][MyClan];
		if(Clan[clanid][cBase] < 1 || Clan[clanid][cBase] > MAX_BASE)
		{
		    SendClientMessage(playerid,COLOR_RED,"Внимание! У вашего клана больше нет штаба.");
		    Player[playerid][Spawn] = 0;
		}
		else
		{
			new rand = Clan[clanid][cBase];
			x = Base[rand][bPosRespawnX]; y = Base[rand][bPosRespawnY]; z = Base[rand][bPosRespawnZ]; Angle = Base[rand][bPosRespawnA];
		}
	}//спавн в штабе

	if (Player[playerid][Spawn] == 6)
	{//Спавн внутри дома
	    new i = Player[playerid][Home];
		if (Property[i][pPrice] < 20000000)//10kk dom
		{
		    x = 243.7173; y = 304.9818; z = 999.3484; Angle = 270.0; SetPlayerInterior(playerid,1);
		}
		else if (Property[i][pPrice] >= 20000000 && Property[i][pPrice] < 40000000)//20kk dom
		{
		    x = 2218.4033; y = -1076.2634; z = 1050.6844; Angle = 90.0; SetPlayerInterior(playerid,1);
		}
		else if (Property[i][pPrice] >= 40000000 && Property[i][pPrice] < 60000000)//40kk dom
		{
		    x = 2365.3140; y = -1135.5983; z = 1051.0826; Angle = 0.0; SetPlayerInterior(playerid,8);
		}
		else if (Property[i][pPrice] >= 60000000 && Property[i][pPrice] < 80000000)//60kk dom
		{
		    x = 2496.0002; y = -1692.0852; z = 1014.9422; Angle = 180.0; SetPlayerInterior(playerid,3);
		}
		else if (Property[i][pPrice] >= 80000000)//80kk dom
		{
		    x = 2270.4172; y = -1210.4956; z = 1047.7625; Angle = 90.0; SetPlayerInterior(playerid,10);
		}
		if (Property[i][pBuyBlock] > 0)//Неперекупаемый дом
		{
		    x = 2324.4902; y = -1149.5474; z = 1050.9101; Angle = 0.0; SetPlayerInterior(playerid,12);
		}
		SetPlayerVirtualWorld(playerid, 1000 + i); WorldSpawn[playerid] = 1000 + i;
	}//Спавн внутри дома

 	if (Player[playerid][Spawn] == 7)
	{//личная позиция
		x = Player[playerid][PosX]; y = Player[playerid][PosY]; z = Player[playerid][PosZ];	Angle = Player[playerid][PosA];
		SetPlayerChatBubble(playerid, "Зареспавнился (Личная позиция)", COLOR_YELLOW, 300.0, 5000); WorldSpawn[playerid] = 0;
	}//личная позиция
	
	if (Player[playerid][Spawn] == 8)
	{//Спавн внутри штаба
	    new clanid = Player[playerid][MyClan];
		if(Clan[clanid][cBase] < 1 || Clan[clanid][cBase] > MAX_BASE)
		{
		    SendClientMessage(playerid,COLOR_RED,"Внимание! У вашего клана больше нет штаба.");
		    Player[playerid][Spawn] = 0;
		}
		else
		{
			new baseid = Clan[clanid][cBase]; SetPlayerVirtualWorld(playerid, 2000 + baseid); WorldSpawn[playerid] = 2000 + baseid;
			if (Base[baseid][bPrice] < 20000000 && Base[baseid][bPrice] > 0) {x = 772.8347; y = -70.5424; z = 1000.85; Angle = 180.0; SetPlayerInterior(playerid, 7);}//Самый дешевый штаб
			else if (Base[baseid][bPrice] < 40000000 && Base[baseid][bPrice] > 0) {x = 768.0178; y = -36.5910; z = 1000.8651; Angle = 180.0; SetPlayerInterior(playerid, 6);}//Штаб за 20-39кк
			else if (Base[baseid][bPrice] < 60000000 && Base[baseid][bPrice] > 0) {x = 1725.0011; y = -1649.9758; z = 20.5289; Angle = 0.0; SetPlayerInterior(playerid, 18);}//Штаб за 40-59кк
			else {x = -2648.3760; y = 1409.8746; z = 906.5734; Angle = 270.0; SetPlayerInterior(playerid, 3);}//Штаб за 60+кк
		}
	}//Спавн внутри штаба

 	if (Player[playerid][Spawn] == 0)
	{//Стандартный спавн
	    if (Player[playerid][Level] == 0)
		{//Спавн на грув 0 лвл
			new rand = random(sizeof(GroveSpawn));
			x = GroveSpawn[rand][0]; y = GroveSpawn[rand][1]; z = GroveSpawn[rand][2]; Angle = GroveSpawn[rand][3];
		}//Спавн на грув 0 лвл
		else if (Player[playerid][Level] < 15)
		{//Спавн в LS 1-14 лвл
		    new rand = random(sizeof(LSSPAWN));
			x = LSSPAWN[rand][0]; y = LSSPAWN[rand][1]; z = LSSPAWN[rand][2]; Angle = LSSPAWN[rand][3];
		}//Спавн в LS 1-14 лвл
		else if (Player[playerid][Level] < 25)
		{//Спавн в SF 15-24 лвл
		    new rand = random(sizeof(SFSPAWN));
			x = SFSPAWN[rand][0]; y = SFSPAWN[rand][1]; z = SFSPAWN[rand][2]; Angle = SFSPAWN[rand][3];
		}//Спавн в SF 15-24 лвл
		else if (Player[playerid][Level] < 69)
		{//Спавн в LV 25-68 лвл
			new rand = random(sizeof(LVSPAWN));
			x = LVSPAWN[rand][0]; y = LVSPAWN[rand][1]; z = LVSPAWN[rand][2]; Angle = LVSPAWN[rand][3];
		}//Спавн в LV 25-68 лвл
  		else
		{//Спавн Chilliad 69+ лвл
		    new rand = random(sizeof(ChilliadSpawn));
			x = ChilliadSpawn[rand][0]; y = ChilliadSpawn[rand][1]; z = ChilliadSpawn[rand][2]; Angle = ChilliadSpawn[rand][3];
		}//Спавн Chilliad 73+ лвл
		WorldSpawn[playerid] = 0;
	}//Стандартный спавн
    
	SetSpawnInfo(playerid, 0, Player[playerid][Model], x, y, z, Angle, w1, w1ammo, w2, w2ammo, w3, w3ammo);
	return SpawnPlayer(playerid);
}//Выполняется в момент до самого респавна игрока

stock WriteLog(LogName[], string[])
{//Запись в лог. Например WriteLog("Файл", "Привет Мир!"); запишет в лог "Файл.ini" фразу "Привет Мир!"
	new entry[256], LogWay[120], i;
	format(entry,sizeof entry,"\r\n%s",string);format(LogWay,sizeof LogWay, "Logs/%s.log",LogName);
	new File: hfile = fopen(LogWay, io_append);	
	while (entry[i] != EOS) {fputchar(hfile,entry[i],false); i++;}
	fclose(hfile);
}//Запись в лог. Например WriteLog("Файл", "Привет Мир!"); запишет в лог "Файл.ini" фразу "Привет Мир!"

stock LoadPlayerClan(playerid)
{//Загрузка клана игрока при логине
    if (Player[playerid][MyClan] != 0 && ClanTextShowed[playerid] == 0)
	{//загрузка клана
	    new clanid = Player[playerid][MyClan], bool: PlayerInClan = false; ClanTextShowed[playerid] = 1;
		if(Clan[clanid][cLevel] == 0)
		{//клан был удален
			SendClientMessage(playerid,COLOR_RED,"Вас исключили из клана или он был удален.");
			Player[playerid][Member] = 0; Player[playerid][Leader] = 0; Player[playerid][MyClan] = 0;
			if (Player[playerid][Spawn] == 5) Player[playerid][Spawn] = 0;
			SavePlayer(playerid); return 1;
		}//клан был удален
        if(!strcmp(Clan[clanid][cLider], PlayerName[playerid], true)) PlayerInClan = true;
        if(!strcmp(Clan[clanid][cMember1], PlayerName[playerid], true)) PlayerInClan = true;
        if(!strcmp(Clan[clanid][cMember2], PlayerName[playerid], true)) PlayerInClan = true;
        if(!strcmp(Clan[clanid][cMember3], PlayerName[playerid], true)) PlayerInClan = true;
        if(!strcmp(Clan[clanid][cMember4], PlayerName[playerid], true)) PlayerInClan = true;
        if(!strcmp(Clan[clanid][cMember5], PlayerName[playerid], true)) PlayerInClan = true;
        if(!strcmp(Clan[clanid][cMember6], PlayerName[playerid], true)) PlayerInClan = true;
        if(!strcmp(Clan[clanid][cMember7], PlayerName[playerid], true)) PlayerInClan = true;
        if(!strcmp(Clan[clanid][cMember8], PlayerName[playerid], true)) PlayerInClan = true;
        if(!strcmp(Clan[clanid][cMember9], PlayerName[playerid], true)) PlayerInClan = true;
        if(!strcmp(Clan[clanid][cMember10], PlayerName[playerid], true)) PlayerInClan = true;
        if(!strcmp(Clan[clanid][cMember11], PlayerName[playerid], true)) PlayerInClan = true;
        if(!strcmp(Clan[clanid][cMember12], PlayerName[playerid], true)) PlayerInClan = true;
        if(!strcmp(Clan[clanid][cMember13], PlayerName[playerid], true)) PlayerInClan = true;
        if(!strcmp(Clan[clanid][cMember14], PlayerName[playerid], true)) PlayerInClan = true;
        if(!strcmp(Clan[clanid][cMember15], PlayerName[playerid], true)) PlayerInClan = true;
        if(!strcmp(Clan[clanid][cMember16], PlayerName[playerid], true)) PlayerInClan = true;
        if(!strcmp(Clan[clanid][cMember17], PlayerName[playerid], true)) PlayerInClan = true;
        if(!strcmp(Clan[clanid][cMember18], PlayerName[playerid], true)) PlayerInClan = true;
        if(!strcmp(Clan[clanid][cMember19], PlayerName[playerid], true)) PlayerInClan = true;
        if(!strcmp(Clan[clanid][cMember20], PlayerName[playerid], true)) PlayerInClan = true;

		if (PlayerInClan == false)
		{//игрока исключили из клана
			SendClientMessage(playerid,COLOR_RED,"Вас исключили из клана или он был удален.");
			Player[playerid][Member] = 0; Player[playerid][Leader] = 0; Player[playerid][MyClan] = 0;
			if (Player[playerid][Spawn] == 5) Player[playerid][Spawn] = 0;
			SavePlayer(playerid); return 1;
		}//игрока исключили из клана
		PlayerColor[playerid] = Clan[clanid][cColor];//установка цвета клана
		
	    new cOnline = 0, cMes[140], ccolor = Clan[clanid][cColor];
		if(strcmp(Clan[clanid][cMessage], "ПУСТО", true))
		{//если сообщение у клана есть
		    format(cMes,sizeof(cMes),"СООБЩЕНИЕ КЛАНА: {FFFFFF}%s",Clan[clanid][cMessage]);
			SendClientMessage(playerid,ClanColor[ccolor],cMes);
		}//если сообщение у клана есть
		format(cMes, sizeof cMes, "Соклановец %s[%d] вошел в игру.", PlayerName[playerid], playerid);
		foreach(Player, cid) if (Player[cid][MyClan] == Player[playerid][MyClan] && Logged[cid] == 1 && cid != playerid) {SendClientMessage(cid,ClanColor[ccolor],cMes); cOnline += 1;}
		format(cMes,sizeof(cMes),"Ваших соклановцев в сети: %d", cOnline); SendClientMessage(playerid,ClanColor[ccolor],cMes);
		if(Clan[clanid][cBase] > MAX_BASE && Player[playerid][Leader] == 100)
		{//Штаб перекупили. Возвращаем лидеру деньги за штаб
  	        if (Player[playerid][Spawn] == 5 || Player[playerid][Spawn] == 8) Player[playerid][Spawn] = 0;
			new String[80]; format(String, sizeof String, "Ваш штаб перекупили! На ваш банковский счет было возвращено {FFFFFF}%d{FF0000}$", Clan[clanid][cBase]);
	        Player[playerid][Bank] += Clan[clanid][cBase];SavePlayer(playerid);
            Clan[clanid][cBase] = 0; SaveClan(clanid);
			SendClientMessage(playerid,COLOR_RED,String);
		}//Штаб перекупили. Возвращаем лидеру деньги за штаб
	}//загрузка клана
	return 1;
}//Загрузка клана игрока при логине



public OnGameModeInit()
{
	new b;//Anti DeAMX
	#emit LOAD.pri b//Anti DeAMX
	#emit STOR.pri b//Anti DeAMX

	for(new i = 0; i < MAX_PLAYERS; i++) ResetPlayer(i);
	LoadAllClans();
	LoadAllProperty();
	LoadAllBase();
	SetGameModeText(GAMEMODE_NAME);
	DisableInteriorEnterExits();
	
	//Время и дата
	getdate(Year, Month, Day); gettime(hour,minute,second);
	format(RestartDate,sizeof RestartDate, "%d/%d/%d в %d:%d:%d", Day, Month, Year, hour, minute, second);
	format(ServerLimitXPDate,sizeof ServerLimitXPDate, "%d/%d/%d в %d:00", Day, Month, Year, hour);
	
	//Запись в лог. Например WriteLog("Файл", "Привет Мир!"); запишет в лог "Файл.ini" фразу "Привет Мир!"
	for (new i = 1; i < 11; i++) WriteLog("GlobalLog","");
	new String[120];format(String, sizeof String, "%d.%d.%d в %d:%d:%d |   Сервер запущен.", Day, Month, Year, hour, minute, second);WriteLog("GlobalLog", String);

	//Меню
	MenuMyskin = LoadModelSelectionMenu("MenuLists/skins.txt");
	MenuFirstCar = LoadModelSelectionMenu("MenuLists/firstcar.txt");
	MenuClass1 = LoadModelSelectionMenu("MenuLists/class1.txt");
	MenuClass2 = LoadModelSelectionMenu("MenuLists/class2.txt");
	MenuClass3 = LoadModelSelectionMenu("MenuLists/class3.txt");
	MenuBuyGun = LoadModelSelectionMenu("MenuLists/buygun.txt");
	MenuPaintJob = LoadModelSelectionMenu("MenuLists/paintjob.txt");
	MenuPrestigeCars = LoadModelSelectionMenu("MenuLists/PrestigeCars.txt");
	
	#include "Transformer\Objects\Other"//всякие важные объекты
	#include "Transformer\Objects\zombie9"//zombie 9 карта
	#include "Transformer\Objects\zombie10"//zombie 10 карта
	#include "Transformer\Objects\zombie11"//zombie 11 Казино Рояль
	#include "Transformer\Objects\zombie12"//zombie 12 Стройка
	#include "Transformer\Objects\zombie14"//zombie 14 Нефтезавод
	#include "Transformer\Objects\zombie15"//zombie 15 Две Крыши
	#include "Transformer\Objects\derby5"//derby 5 карта "На Грани"
	#include "Transformer\Objects\derby6"//derby 6 карта "Без Гарантий"
	#include "Transformer\Objects\derby7"//derby 7 карта "Перекрестки"
	#include "Transformer\Objects\derby8"//derby 8 карта "Пять Башен"
	#include "Transformer\Objects\derby9"//derby 9 карта "World of Tanks"
	#include "Transformer\Objects\Casino"//Казино
	#include "Transformer\Objects\StaticActors" //Статичные NPC

	//Банки
	CreateDynamicPickup( 1318, 1, 1459.3660,-1010.2814,26.8438);
	CreateDynamicMapIcon(1459.3660,-1010.2814,26.8438, 52, -1, 0, 0, -1, 200.0);
	Create3DTextLabel("{008E00}Банк\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы войти", COLOR_WHITE, 1459.3660,-1010.2814,26.8438, 50, 0);
	CreateDynamicPickup( 1318, 1, -2766.5518,375.5609,6.3347);
	CreateDynamicMapIcon(-2766.5518,375.5609,6.3347, 52, -1, 0, 0, -1, 200.0);
	Create3DTextLabel("{008E00}Банк\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы войти", COLOR_WHITE, -2766.5518,375.5609,6.3347, 50, 0);
	CreateDynamicPickup( 1318, 1, 2364.8967,2377.5842,10.8203);
	CreateDynamicMapIcon(2364.8967,2377.5842,10.8203, 52, -1, 0, 0, -1, 200.0);
	Create3DTextLabel("{008E00}Банк\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы войти", COLOR_WHITE, 2364.8967,2377.5842,10.8203, 50, 0);
	CreateDynamicPickup( 1318, 1, 562.1108,-1506.6329,14.5491);
	CreateDynamicMapIcon(562.1108,-1506.6329,14.5491, 52, -1, 0, 0, -1, 200.0);
	Create3DTextLabel("{008E00}Банк\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы войти", COLOR_WHITE, 562.1108,-1506.6329,14.5491, 50, 0);
	CreateDynamicPickup( 1318, 1, -1896.0466,483.7038,35.1719);
	CreateDynamicMapIcon(-1896.0466,483.7038,35.1719, 52, -1, 0, 0, -1, 200.0);
	Create3DTextLabel("{008E00}Банк\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы войти", COLOR_WHITE, -1896.0466,483.7038,35.1719, 50, 0);
	CreateDynamicPickup( 1318, 1, 1047.7667,1006.5556,11.0000);
	CreateDynamicMapIcon(1047.7667,1006.5556,11.0000, 52, -1, 0, 0, -1, 200.0);
	Create3DTextLabel("{008E00}Банк\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы войти", COLOR_WHITE, 1047.7667,1006.5556,11.0000, 50, 0);
	//Банк - Выход из интерьера
	CreateDynamicPickup( 1318, 1, 2304.6858,-16.2069,26.7422);
	Create3DTextLabel("{008E00}Банк\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы выйти", COLOR_WHITE, 2304.6858,-16.2069,26.7422, 50, 0);
	//Банк - Окошко для операции
	CreateDynamicPickup(1274, 1, 2316.6182,-7.2874,26.7422,-1,-1,-1,100);
	Create3DTextLabel("{008E00}Банк\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать", COLOR_WHITE, 2316.6182,-7.2874,26.7422, 50, 0);

	
    for(new i = 0; i < 4; i++)
	{//Магазины одежды
        CreateDynamicMapIcon(CLOTHESENTERS[i][0], CLOTHESENTERS[i][1], CLOTHESENTERS[i][2], 45, 0, -1, -1, -1, 300 );
		CreateDynamicPickup(1275, 1, CLOTHESENTERS[i][0], CLOTHESENTERS[i][1], CLOTHESENTERS[i][2], 0);
		Create3DTextLabel("{007FFF}Магазин Одежды\n{FFFF00}Стоимость: {FFFFFF}10 000$\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать", COLOR_WHITE, CLOTHESENTERS[i][0], CLOTHESENTERS[i][1], CLOTHESENTERS[i][2], 50, 0);
	}//Магазины одежды

	ZMZone1 = GangZoneCreate(18.2401, -346.2097, 381.6300, 38.1058);
	ZMZone2 = GangZoneCreate(-421.3790,970.1434,34.3993,1253.4585);
	ZMZone3 = GangZoneCreate(-2323.9080,-2588.7029,-1978.8424,-2192.2981);
	ZMZone4 = GangZoneCreate(2535.5085,-2568.9009,2855.7583,-2327.5361);
	ZMZone5 = GangZoneCreate(96.3056,1798.4053,285.9781,1941.6783);
	ZMZone6 = GangZoneCreate(-481.7286,2160.7854,-313.6042,2278.5151);
	ZMZone7 = GangZoneCreate(586.2542,-680.1298,865.8792,-437.2776);
	ZMZone8 = GangZoneCreate(2402.7788, -1738.0784, 2540.9875, -1611.7262);
	ZMZone9 = GangZoneCreate(-1955.0227, -1814.8270, -1726.5884, -1529.1664);
	ZMZone10 = GangZoneCreate(6.1427, 1958.9844, 168.5044, 2068.9446);
	ZMZone11 = GangZoneCreate(2058.5452, 1367.7277, 2257.4702, 1543.2401);
	ZMZone12 = GangZoneCreate(-2157.1594, 98.7720, -2000.8650, 329.9948);
	ZMZone13 = GangZoneCreate(2776.7744, 832.9240, 2895.4053, 1023.6314);
	ZMZone14 = GangZoneCreate(110.2249, 1335.4117, 288.8354, 1485.3009);
	ZMZone15 = GangZoneCreate(-1616.5637, 993.2772, -1418.4362, 1233.9050);
	
	WorkZoneCombine = GangZoneCreate(-1198.7462, -1066.4282, -1001.5065, -908.7125);//Поле комбайнера

	SetTimer("SecUpdate", 1000, true);

	//skinchange td
	SkinChangeTextDraw = TextDrawCreate(152 ,200 , "<   >");
	TextDrawFont(SkinChangeTextDraw , 3);
	TextDrawLetterSize(SkinChangeTextDraw , 5, 20);
	TextDrawColor(SkinChangeTextDraw , 0xFF6666FF);
	TextDrawSetOutline(SkinChangeTextDraw , false);
	TextDrawSetProportional(SkinChangeTextDraw , true);
	TextDrawSetShadow(SkinChangeTextDraw , 4);

	//Дата
	TextDrawDate = TextDrawCreate(547.000000,11.000000,"--");
	TextDrawFont(TextDrawDate,3);
	TextDrawLetterSize(TextDrawDate,0.399999,1.600000);
    TextDrawColor(TextDrawDate,0xffffffff);
	//Время
	TextDrawTime = TextDrawCreate(547.000000,28.000000,"--");
	TextDrawFont(TextDrawTime,3);
	TextDrawLetterSize(TextDrawTime,0.399999,1.600000);
	TextDrawColor(TextDrawTime,0xffffffff);
	
	BlackScreen = TextDrawCreate(0.000000, 0.000000, "_");
	TextDrawBackgroundColor(BlackScreen, 255);
	TextDrawFont(BlackScreen, 1);
	TextDrawLetterSize(BlackScreen, 0.500000, 50.000000);
	TextDrawColor(BlackScreen, -1);
	TextDrawSetOutline(BlackScreen, 0);
	TextDrawSetProportional(BlackScreen, 1);
	TextDrawSetShadow(BlackScreen, 1);
	TextDrawUseBox(BlackScreen, 1);
	TextDrawBoxColor(BlackScreen, 255);
	TextDrawTextSize(BlackScreen, 680.000000, 0.000000);

	for(new ill = 0; ill < MAX_PLAYERS; ill++)
	{// текстдравы с MAX_PLAYERS
		TextDrawEvent[ill] = TextDrawCreate(2, 436, "Время до старта соревнования");
		TextDrawFont(TextDrawEvent[ill], 1);
		TextDrawLetterSize(TextDrawEvent[ill], 0.3, 1.2);
		TextDrawSetOutline(TextDrawEvent[ill], 1);
		TextDrawSetProportional(TextDrawEvent[ill], true);
		TextDrawSetShadow(TextDrawEvent[ill], 0);
	
		SpecInfo[ill] = TextDrawCreate(2, 436, "Спектр: информация об игроке..");
		TextDrawFont(SpecInfo[ill] , 1);
		TextDrawLetterSize(SpecInfo[ill] , 0.3, 1.2);
		TextDrawColor(SpecInfo[ill] , 0xFFFF00FF);
		TextDrawSetOutline(SpecInfo[ill] , 1);
		TextDrawSetProportional(SpecInfo[ill] , true);
		TextDrawSetShadow(SpecInfo[ill] , 0);

		SpecInfoVeh[ill] = TextDrawCreate(2, 425, "Спектр: информация о машине игрока..");
		TextDrawFont(SpecInfoVeh[ill] , 1);
		TextDrawLetterSize(SpecInfoVeh[ill] , 0.3, 1.2);
		TextDrawColor(SpecInfoVeh[ill] , 0x457EFFFF);
		TextDrawSetOutline(SpecInfoVeh[ill] , 1);
		TextDrawSetProportional(SpecInfoVeh[ill] , true);
		TextDrawSetShadow(SpecInfoVeh[ill] , 0);

		TextDrawSpeedo[ill] = TextDrawCreate(40, 325, "CKOPOCTb: x Km/h");
		TextDrawFont(TextDrawSpeedo[ill] , 1);
		TextDrawLetterSize(TextDrawSpeedo[ill] , 0.3, 1.2);
		TextDrawColor(TextDrawSpeedo[ill] , 0x457EFFFF);
		TextDrawSetOutline(TextDrawSpeedo[ill] , 1);
		TextDrawSetProportional(TextDrawSpeedo[ill] , true);
		TextDrawSetShadow(TextDrawSpeedo[ill] , 0);
		
		//skinid td
		SkinIDTD[ill] = TextDrawCreate(230 ,410 , "Skin ID: %d");
		TextDrawFont(SkinIDTD[ill] , 1);
		TextDrawLetterSize(SkinIDTD[ill] , 1.2, 4.0);
		TextDrawColor(SkinIDTD[ill] , 0xAFAFAFFF);
		TextDrawSetOutline(SkinIDTD[ill] , false);
		TextDrawSetProportional(SkinIDTD[ill] , true);
		TextDrawSetShadow(SkinIDTD[ill] , 3);
		
		//LevelupTD - текстдав повышения уровня
		LevelupTD[ill] = TextDrawCreate(150 ,335 , "LEVEL N");
		TextDrawFont(LevelupTD[ill], 3);
		TextDrawLetterSize(LevelupTD[ill], 3, 10);
		TextDrawColor(LevelupTD[ill], 0xFFFFFFFF);
		TextDrawSetOutline(LevelupTD[ill], 1);
		TextDrawSetProportional(LevelupTD[ill], true);
		TextDrawSetShadow(LevelupTD[ill], 3);
		
		//Таймер времени на работе
		TextDrawWorkTimer[ill] = TextDrawCreate(40, 300, "00:00");
		TextDrawFont(TextDrawWorkTimer[ill] , 1);
		TextDrawLetterSize(TextDrawWorkTimer[ill] , 0.6, 2.4);
		TextDrawColor(TextDrawWorkTimer[ill] , 0x457EFFFF);
		TextDrawSetOutline(TextDrawWorkTimer[ill] , 1);
		TextDrawSetProportional(TextDrawWorkTimer[ill] , true);
		TextDrawSetShadow(TextDrawWorkTimer[ill] , 0);
	}// текстдравы с MAX_PLAYERS
	
	//Цвета текстдравов о старте соревнований
	TextDrawColor(TextDrawEvent[EVENT_DM], COLOR_DM);
	TextDrawColor(TextDrawEvent[EVENT_DERBY], COLOR_DERBY);
	TextDrawColor(TextDrawEvent[EVENT_ZOMBIE], COLOR_ZOMBIE);
	TextDrawColor(TextDrawEvent[EVENT_RACE], COLOR_RACE);
	TextDrawColor(TextDrawEvent[EVENT_XRACE], COLOR_XR);
	TextDrawColor(TextDrawEvent[EVENT_GUNGAME], COLOR_GG);
	
	//--------- Pay N Spray Icons
	CreateDynamicMapIcon(2064.5986,-1831.6934,13.5469, 63, -1, 0, 0, -1, 350.0);
	CreateDynamicMapIcon(1024.8928,-1024.6052,32.1016, 63, -1, 0, 0, -1, 350.0);
	CreateDynamicMapIcon(487.3758,-1741.0320,11.1321, 63, -1, 0, 0, -1, 350.0);
	CreateDynamicMapIcon(-1904.6287,285.5661,41.0469, 63, -1, 0, 0, -1, 350.0);
	CreateDynamicMapIcon(-2425.6978,1020.8086,50.3977, 63, -1, 0, 0, -1, 350.0);
	CreateDynamicMapIcon(1976.5468,2162.4783,11.0703, 63, -1, 0, 0, -1, 350.0);
	CreateDynamicMapIcon(720.0233,-456.4514,16.3359, 63, -1, 0, 0, -1, 350.0);
	CreateDynamicMapIcon(-99.9693,1118.9204,19.7417, 63, -1, 0, 0, -1, 350.0);
	CreateDynamicMapIcon(-1420.1829,2583.6006,55.8433, 63, -1, 0, 0, -1, 350.0);
	//--------- Pay N Spray TextLabel
	Create3DTextLabel("{007FFF}Перекрасить машину\n{FFFF00}Стоимость: {FFFFFF}100$\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать\n\n{AFAFAF}Бесплатный ремонт при заезде!", COLOR_WHITE,2064.5986,-1831.6934,13.5469, 50, 0);
	Create3DTextLabel("{007FFF}Перекрасить машину\n{FFFF00}Стоимость: {FFFFFF}100$\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать\n\n{AFAFAF}Бесплатный ремонт при заезде!", COLOR_WHITE,1024.8928,-1024.6052,32.1016, 50, 0);
	Create3DTextLabel("{007FFF}Перекрасить машину\n{FFFF00}Стоимость: {FFFFFF}100$\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать\n\n{AFAFAF}Бесплатный ремонт при заезде!", COLOR_WHITE,487.3758,-1741.0320,11.1321, 50, 0);
	Create3DTextLabel("{007FFF}Перекрасить машину\n{FFFF00}Стоимость: {FFFFFF}100$\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать\n\n{AFAFAF}Бесплатный ремонт при заезде!", COLOR_WHITE,-1904.6287,285.5661,41.0469, 50, 0);
	Create3DTextLabel("{007FFF}Перекрасить машину\n{FFFF00}Стоимость: {FFFFFF}100$\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать\n\n{AFAFAF}Бесплатный ремонт при заезде!", COLOR_WHITE,-2425.6978,1020.8086,50.3977, 50, 0);
	Create3DTextLabel("{007FFF}Перекрасить машину\n{FFFF00}Стоимость: {FFFFFF}100$\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать\n\n{AFAFAF}Бесплатный ремонт при заезде!", COLOR_WHITE,1976.5468,2162.4783,11.0703, 50, 0);
	Create3DTextLabel("{007FFF}Перекрасить машину\n{FFFF00}Стоимость: {FFFFFF}100$\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать\n\n{AFAFAF}Бесплатный ремонт при заезде!", COLOR_WHITE,720.0233,-456.4514,16.3359, 50, 0);
	Create3DTextLabel("{007FFF}Перекрасить машину\n{FFFF00}Стоимость: {FFFFFF}100$\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать\n\n{AFAFAF}Бесплатный ремонт при заезде!", COLOR_WHITE,-99.9693,1118.9204,19.7417, 50, 0);
	Create3DTextLabel("{007FFF}Перекрасить машину\n{FFFF00}Стоимость: {FFFFFF}100$\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать\n\n{AFAFAF}Бесплатный ремонт при заезде!", COLOR_WHITE,-1420.1829,2583.6006,55.8433, 50, 0);
	
    //--------- Автомастерские Icons
    CreateDynamicMapIcon(2644.6580,-2044.3076,13.6352, 27, -1, 0, 0, -1, 350.0); // Tune Lowrider
	CreateDynamicMapIcon(1041.5431,-1016.8201,32.1075, 27, -1, 0, 0, -1, 350.0); // Tune Transfender Los Santos
	CreateDynamicMapIcon(-1936.0847,245.9636,34.4609, 27, -1, 0, 0, -1, 350.0); // Tune Transfender San Fierro
	CreateDynamicMapIcon(-2723.5532,217.1511,4.4844, 27, -1, 0, 0, -1, 350.0); // Tune Arch Angels
	CreateDynamicMapIcon(2386.7300,1051.5768,10.8203, 27, -1, 0, 0, -1, 350.0); // Tune Transfender Las Venturas 1
    CreateDynamicMapIcon(-2026.9791,124.2575,29.1300, 27, -1, 0, 0, -1, 350.0); // Tune TurboSpeed
    //--------- Автомастерские TextLabel
    Create3DTextLabel("{007FFF}Автомастерская\n{FFFFFF}Lowrider", COLOR_WHITE,2644.6580,-2044.3076,13.6352, 50, 0);// Tune Lowrider
	Create3DTextLabel("{007FFF}Автомастерская\n{FFFFFF}Transfender", COLOR_WHITE,1041.5431,-1016.8201,32.1075, 50, 0);// Tune Transfender Los Santos
	Create3DTextLabel("{007FFF}Автомастерская\n{FFFFFF}Transfender", COLOR_WHITE,-1936.0847,245.9636,34.4609, 50, 0);// Tune Transfender San Fierro
	Create3DTextLabel("{007FFF}Автомастерская\n{FFFFFF}Arch Angels", COLOR_WHITE,-2723.5532,217.1511,4.4844, 50, 0);// Tune Arch Angels
	Create3DTextLabel("{007FFF}Автомастерская\n{FFFFFF}Transfender", COLOR_WHITE,2386.7300,1051.5768,10.8203, 50, 0);// Tune Transfender Las Venturas 1
	Create3DTextLabel("{007FFF}Автомастерская\n{9966CC}TurboSpeed\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать", COLOR_WHITE,-2026.9791,124.2575,29.1300, 50, 0);// Tune TurboSpeed

	//Работа - Доставщик пиццы
	Create3DTextLabel("{FFCC00}Доставщик Пиццы\n{007FFF}2400 XP и 144 000$ / Час\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы начать работу", COLOR_WHITE, 2397.7632, -1899.1389, 13.5469, 50, 0);
	CreateDynamicPickup( 1318, 1, 2397.7632, -1899.1389, 13.5469,-1,-1,-1,100);
	CreateDynamicMapIcon(2397.7632, -1899.1389, 13.5469, 14, -1, 0, 0, -1, 200.0);
	//Работа - Грузчик
	Create3DTextLabel("{FFCC00}Грузчик\n{007FFF}2700 XP и 108 000$ / Час\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы начать работу", COLOR_WHITE, 2729.3267, -2451.4578, 17.5937, 50, 0);
	CreateDynamicPickup( 1318, 1, 2729.3267, -2451.4578, 17.5937,-1,-1,-1,100);
	CreateDynamicMapIcon(2729.3267, -2451.4578, 17.5937, 54, -1, 0, 0, -1, 200.0);
	//Работа - Домушник
	Create3DTextLabel("{FFCC00}Домушник\n{007FFF}2880 XP и 360 000$ / Час\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы начать работу", COLOR_WHITE, -1972.5024,-1020.2568,32.1719, 50, 0);
	CreateDynamicPickup( 1318, 1, -1972.5024,-1020.2568,32.1719,-1,-1,-1,100);
	CreateDynamicMapIcon(-1972.5024,-1020.2568,32.1719, 51, -1, 0, 0, -1, 200.0);
	//Работа - Комбайнер
	Create3DTextLabel("{FFCC00}Комбайнер\n{007FFF}3240 XP и 270 000$ / Час\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы начать работу", COLOR_WHITE, -1061.6104,-1195.4755,129.8281, 50, 0);
	CreateDynamicPickup( 1318, 1, -1061.6104,-1195.4755,129.8281,-1,-1,-1,100);
	CreateDynamicMapIcon(-1061.6104,-1195.4755,129.8281, 11, -1, 0, 0, -1, 200.0);
	//Работа - Дальнобойщик
	Create3DTextLabel("{FFCC00}Дальнобойщик\n{007FFF}3420 XP и 540 000$ / Час\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы начать работу", COLOR_WHITE, 2484.6682,-2120.8743,13.5469, 50, 0);
	CreateDynamicPickup( 1318, 1, 2484.6682,-2120.8743,13.5469,-1,-1,-1,100);
	CreateDynamicMapIcon(2484.6682,-2120.8743,13.5469, 51, -1, 0, 0, -1, 200.0);
	//Работа - Капитан Корабля
	Create3DTextLabel("{FFCC00}Капитан Корабля\n{007FFF}3600 XP и 396 000$ / Час\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы начать работу", COLOR_WHITE, -1713.1389,-61.8556,3.5547, 50, 0);
	CreateDynamicPickup( 1318, 1, -1713.1389,-61.8556,3.5547,-1,-1,-1,100);
	CreateDynamicMapIcon(-1713.1389,-61.8556,3.5547, 9, -1, 0, 0, -1, 200.0);
	//Работа - Инкассатор
	Create3DTextLabel("{FFCC00}Инкассатор\n{007FFF}2400 XP и 900 000$ / Час\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы начать работу", COLOR_WHITE, 2364.8955, 2382.8770, 10.8203, 50, 0);
	CreateDynamicPickup( 1318, 1, 2364.8955, 2382.8770, 10.8203, -1, -1, -1, 100);

	//Интерьеры домов - выходы
	CreateDynamicPickup( 1318, 1, 2324.4902,-1149.5474,1050.7101,-1,-1,-1,100);
	Create3DTextLabel("{007FFF}Выход\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать", COLOR_WHITE, 2324.4902,-1149.5474,1050.7101, 15, 0);
	CreateDynamicPickup( 1318, 1, 243.7173,304.9818,999.1484,-1,-1,-1,100);
	Create3DTextLabel("{007FFF}Выход\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать", COLOR_WHITE, 243.7173,304.9818,999.1484, 15, 0);
	CreateDynamicPickup( 1318, 1, 2218.4033,-1076.2634,1050.4844,-1,-1,-1,100);
	Create3DTextLabel("{007FFF}Выход\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать", COLOR_WHITE, 2218.4033,-1076.2634,1050.4844, 15, 0);
	CreateDynamicPickup( 1318, 1, 2365.3140,-1135.5983,1050.8826,-1,-1,-1,100);
	Create3DTextLabel("{007FFF}Выход\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать", COLOR_WHITE, 2365.3140,-1135.5983,1050.8826, 15, 0);
	CreateDynamicPickup( 1318, 1, 2496.0002,-1692.0852,1014.7422,-1,-1,-1,100);
	Create3DTextLabel("{007FFF}Выход\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать", COLOR_WHITE, 2496.0002,-1692.0852,1014.7422, 15, 0);
	CreateDynamicPickup( 1318, 1, 2270.4172,-1210.4956,1047.5625,-1,-1,-1,100);
	Create3DTextLabel("{007FFF}Выход\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать", COLOR_WHITE, 2270.4172,-1210.4956,1047.5625, 15, 0);

    //Интерьеры домов - смена скина
    CreateDynamicPickup( 1275, 1, 2332.5144,-1144.4189,1054.3047,-1,-1,-1,100);
	Create3DTextLabel("{007FFF}Изменить модель персонажа\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать", COLOR_WHITE, 2332.5144,-1144.4189,1054.3047, 15, 0);
    CreateDynamicPickup( 1275, 1, 2215.7893,-1074.6979,1050.4844,-1,-1,-1,100);
	Create3DTextLabel("{007FFF}Изменить модель персонажа\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать", COLOR_WHITE, 2215.7893,-1074.6979,1050.4844, 15, 0);
    CreateDynamicPickup( 1275, 1, 2363.7717,-1127.3329,1050.8826,-1,-1,-1,100);
	Create3DTextLabel("{007FFF}Изменить модель персонажа\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать", COLOR_WHITE, 2363.7717,-1127.3329,1050.8826, 15, 0);
    CreateDynamicPickup( 1275, 1, 2492.4016,-1708.5626,1018.3368,-1,-1,-1,100);
	Create3DTextLabel("{007FFF}Изменить модель персонажа\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать", COLOR_WHITE, 2492.4016,-1708.5626,1018.3368, 15, 0);
    CreateDynamicPickup( 1275, 1, 2262.7871,-1216.8030,1049.0234,-1,-1,-1,100);
	Create3DTextLabel("{007FFF}Изменить модель персонажа\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать", COLOR_WHITE, 2262.7871,-1216.8030,1049.0234, 15, 0);

    //Интерьеры штабов - выходы
	CreateDynamicPickup( 1318, 1, 774.0399,-78.7388,1000.6627,-1,-1,-1,100);
	CreateDynamicPickup( 1318, 1, 774.0266,-50.3715,1000.5859,-1,-1,-1,100);
	CreateDynamicPickup( 1318, 1, 1727.0281,-1637.9517,20.2230,-1,-1,-1,100);
	CreateDynamicPickup( 1318, 1, -2636.4778,1402.5682,906.4609,-1,-1,-1,100);

	//Казино - Рулетка
	Create3DTextLabel("{9966CC}Рулетка\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы сыграть", COLOR_WHITE, 1962.3420, 1009.6814, 992.4688, 20, 10);
	Create3DTextLabel("{9966CC}Рулетка\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы сыграть", COLOR_WHITE, 1958.0320, 1009.6746, 992.4688, 20, 10);
	Create3DTextLabel("{9966CC}Рулетка\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы сыграть", COLOR_WHITE, 1962.3417, 1025.3008, 992.4688, 20, 10);
	Create3DTextLabel("{9966CC}Рулетка\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы сыграть", COLOR_WHITE, 1958.0321, 1025.2384, 992.4688, 20, 10);
    //Казино - Весёлый Будда
    Create3DTextLabel("{FFCC00}Веселый Будда\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы рискнуть", COLOR_WHITE, 1954.1530, 995.4341, 992.8594, 50, 10);

	//Казино 4 дракона - вход слева
	CreateDynamicPickup( 1318, 1, 1958.3613, 953.2741, 10.8203);
	CreateDynamicMapIcon(1958.3613, 953.2741, 10.8203, 25, -1, 0, 0, -1, 200.0);
	Create3DTextLabel("{9966CC}Казино\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать", COLOR_WHITE, 1958.3613, 953.2741, 10.8203, 50, 0);
	//Казино 4 дракона - вход центральный
	CreateDynamicPickup(1318, 1, 2019.3174, 1007.8547, 10.8203);
	CreateDynamicMapIcon(2019.3174, 1007.8547, 10.8203, 25, -1, 0, 0, -1, 200.0);
	Create3DTextLabel("{9966CC}Казино\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать", COLOR_WHITE, 2019.3174, 1007.8547, 10.8203, 50, 0);
	//Казино 4 дракона - вход справа
	CreateDynamicPickup(1318, 1, 1944.2803, 1076.0552, 10.8203);
	CreateDynamicMapIcon(1944.2803, 1076.0552, 10.8203, 25, -1, 0, 0, -1, 200.0);
	Create3DTextLabel("{9966CC}Казино\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать", COLOR_WHITE, 1944.2803, 1076.0552, 10.8203, 50, 0);
	//Казино 4 дракона - выход слева
	CreateDynamicPickup( 1318, 1, 1963.7800, 972.4600, 994.4688);
	Create3DTextLabel("{9966CC}Выход\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать", COLOR_WHITE, 1963.7800, 972.4600, 994.4688, 50, 10);
	//Казино 4 дракона - выход центральный
	CreateDynamicPickup( 1318, 1, 2018.9702, 1017.8456, 996.8750);
	Create3DTextLabel("{9966CC}Выход\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать", COLOR_WHITE, 2018.9702, 1017.8456, 996.8750, 50, 10);
	//Казино 4 дракона - выход справа
	CreateDynamicPickup( 1318, 1, 1963.6882, 1063.2550, 994.4688);
	Create3DTextLabel("{9966CC}Выход\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать", COLOR_WHITE, 1963.6882, 1063.2550, 994.4688, 50, 10);

	//Аэропорты
	CreateDynamicPickup( 1318, 1, 1451.6349, -2287.0703, 13.5469);
	CreateDynamicMapIcon(1451.6349, -2287.0703, 13.5469, 5, -1, 0, 0, -1, 200.0);
	Create3DTextLabel("{007FFF}Аэропорт\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать", COLOR_WHITE, 1451.6349, -2287.0703, 13.5469, 50, 0);
	CreateDynamicPickup( 1318, 1, -1404.6575, -303.7458, 14.1484);
	CreateDynamicMapIcon(-1404.6575, -303.7458, 14.1484, 5, -1, 0, 0, -1, 200.0);
	Create3DTextLabel("{007FFF}Аэропорт\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать", COLOR_WHITE, -1404.6575, -303.7458, 14.1484, 50, 0);
	CreateDynamicPickup( 1318, 1, 1672.9861, 1447.9349, 10.7868);
	CreateDynamicMapIcon(1672.9861, 1447.9349, 10.7868, 5, -1, 0, 0, -1, 200.0);
	Create3DTextLabel("{007FFF}Аэропорт\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать", COLOR_WHITE, 1672.9861, 1447.9349, 10.7868, 50, 0);
	//В банке
	CreateDynamicPickup( 1318, 1, 2315.5173, 0.3555, 26.7422);
	Create3DTextLabel("{007FFF}Вертолетная Плодащка\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать", COLOR_WHITE, 2315.5173, 0.3555, 26.7422, 30, 0);


	//--------- Кейсы
	case1 = random(sizeof(CaseSpawn));
	CasePickup[1] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case1][0], CaseSpawn[case1][1], CaseSpawn[case1][2] );
	CaseMapIcon[1] = CreateDynamicMapIcon(CaseSpawn[case1][0], CaseSpawn[case1][1], CaseSpawn[case1][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
	case2 = random(sizeof(CaseSpawn));
	CasePickup[2] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case2][0], CaseSpawn[case2][1], CaseSpawn[case2][2] );
	CaseMapIcon[2] = CreateDynamicMapIcon(CaseSpawn[case2][0], CaseSpawn[case2][1], CaseSpawn[case2][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
	case3 = random(sizeof(CaseSpawn));
	CasePickup[3] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case3][0], CaseSpawn[case3][1], CaseSpawn[case3][2] );
	CaseMapIcon[3] = CreateDynamicMapIcon(CaseSpawn[case3][0], CaseSpawn[case3][1], CaseSpawn[case3][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
	case4 = random(sizeof(CaseSpawn));
	CasePickup[4] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case4][0], CaseSpawn[case4][1], CaseSpawn[case4][2] );
	CaseMapIcon[4] = CreateDynamicMapIcon(CaseSpawn[case4][0], CaseSpawn[case4][1], CaseSpawn[case4][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
	case5 = random(sizeof(CaseSpawn));
	CasePickup[5] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case5][0], CaseSpawn[case5][1], CaseSpawn[case5][2] );
	CaseMapIcon[5] = CreateDynamicMapIcon(CaseSpawn[case5][0], CaseSpawn[case5][1], CaseSpawn[case5][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
	case6 = random(sizeof(CaseSpawn));
	CasePickup[6] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case6][0], CaseSpawn[case6][1], CaseSpawn[case6][2] );
	CaseMapIcon[6] = CreateDynamicMapIcon(CaseSpawn[case6][0], CaseSpawn[case6][1], CaseSpawn[case6][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
	case7 = random(sizeof(CaseSpawn));
	CasePickup[7] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case7][0], CaseSpawn[case7][1], CaseSpawn[case7][2] );
	CaseMapIcon[7] = CreateDynamicMapIcon(CaseSpawn[case7][0], CaseSpawn[case7][1], CaseSpawn[case7][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
	case8 = random(sizeof(CaseSpawn));
	CasePickup[8] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case8][0], CaseSpawn[case8][1], CaseSpawn[case8][2] );
	CaseMapIcon[8] = CreateDynamicMapIcon(CaseSpawn[case8][0], CaseSpawn[case8][1], CaseSpawn[case8][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
	case9 = random(sizeof(CaseSpawn));
	CasePickup[9] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case9][0], CaseSpawn[case9][1], CaseSpawn[case9][2] );
	CaseMapIcon[9] = CreateDynamicMapIcon(CaseSpawn[case9][0], CaseSpawn[case9][1], CaseSpawn[case9][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
	case10 = random(sizeof(CaseSpawn));
	CasePickup[10] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case10][0], CaseSpawn[case10][1], CaseSpawn[case10][2] );
	CaseMapIcon[10] = CreateDynamicMapIcon(CaseSpawn[case10][0], CaseSpawn[case10][1], CaseSpawn[case10][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
	case11 = random(sizeof(CaseSpawn));
	CasePickup[11] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case11][0], CaseSpawn[case11][1], CaseSpawn[case11][2] );
	CaseMapIcon[11] = CreateDynamicMapIcon(CaseSpawn[case11][0], CaseSpawn[case11][1], CaseSpawn[case11][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
	case12 = random(sizeof(CaseSpawn));
	CasePickup[12] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case12][0], CaseSpawn[case12][1], CaseSpawn[case12][2] );
	CaseMapIcon[12] = CreateDynamicMapIcon(CaseSpawn[case12][0], CaseSpawn[case12][1], CaseSpawn[case12][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
	case13 = random(sizeof(CaseSpawn));
	CasePickup[13] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case13][0], CaseSpawn[case13][1], CaseSpawn[case13][2] );
	CaseMapIcon[13] = CreateDynamicMapIcon(CaseSpawn[case13][0], CaseSpawn[case13][1], CaseSpawn[case13][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
	case14 = random(sizeof(CaseSpawn));
	CasePickup[14] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case14][0], CaseSpawn[case14][1], CaseSpawn[case14][2] );
	CaseMapIcon[14] = CreateDynamicMapIcon(CaseSpawn[case14][0], CaseSpawn[case14][1], CaseSpawn[case14][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
	case15 = random(sizeof(CaseSpawn));
	CasePickup[15] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case15][0], CaseSpawn[case15][1], CaseSpawn[case15][2] );
	CaseMapIcon[15] = CreateDynamicMapIcon(CaseSpawn[case15][0], CaseSpawn[case15][1], CaseSpawn[case15][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
	case16 = random(sizeof(CaseSpawn));
	CasePickup[16] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case16][0], CaseSpawn[case16][1], CaseSpawn[case16][2] );
	CaseMapIcon[16] = CreateDynamicMapIcon(CaseSpawn[case16][0], CaseSpawn[case16][1], CaseSpawn[case16][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
	case17 = random(sizeof(CaseSpawn));
	CasePickup[17] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case17][0], CaseSpawn[case17][1], CaseSpawn[case17][2] );
	CaseMapIcon[17] = CreateDynamicMapIcon(CaseSpawn[case17][0], CaseSpawn[case17][1], CaseSpawn[case17][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
	case18 = random(sizeof(CaseSpawn));
	CasePickup[18] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case18][0], CaseSpawn[case18][1], CaseSpawn[case18][2] );
	CaseMapIcon[18] = CreateDynamicMapIcon(CaseSpawn[case18][0], CaseSpawn[case18][1], CaseSpawn[case18][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
	case19 = random(sizeof(CaseSpawn));
	CasePickup[19] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case19][0], CaseSpawn[case19][1], CaseSpawn[case19][2] );
	CaseMapIcon[19] = CreateDynamicMapIcon(CaseSpawn[case19][0], CaseSpawn[case19][1], CaseSpawn[case19][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
	case20 = random(sizeof(CaseSpawn));
	CasePickup[20] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case20][0], CaseSpawn[case20][1], CaseSpawn[case20][2] );
	CaseMapIcon[20] = CreateDynamicMapIcon(CaseSpawn[case20][0], CaseSpawn[case20][1], CaseSpawn[case20][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
	
	//Авто для угона
	new modeld;
	csrand1 = random(sizeof(CarStealSpawns));cscol1 = random(256);cscol2 = random(256);modeld = random(133); csmodel = StealCars[modeld];
	StealCar[1] = LCreateVehicle(csmodel, CarStealSpawns[csrand1][0], CarStealSpawns[csrand1][1], CarStealSpawns[csrand1][2], CarStealSpawns[csrand1][3], cscol1, cscol2, 0);
    StealCarMapIcon[1] = CreateDynamicMapIcon(CarStealSpawns[csrand1][0], CarStealSpawns[csrand1][1], CarStealSpawns[csrand1][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);

    csrand2 = random(sizeof(CarStealSpawns));cscol1 = random(256);cscol2 = random(256);modeld = random(133); csmodel = StealCars[modeld];
    StealCar[2] = LCreateVehicle(csmodel, CarStealSpawns[csrand2][0], CarStealSpawns[csrand2][1], CarStealSpawns[csrand2][2], CarStealSpawns[csrand2][3], cscol1, cscol2, 0);
	StealCarMapIcon[2] = CreateDynamicMapIcon(CarStealSpawns[csrand2][0], CarStealSpawns[csrand2][1], CarStealSpawns[csrand2][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);

    csrand3 = random(sizeof(CarStealSpawns));cscol1 = random(256);cscol2 = random(256);modeld = random(133); csmodel = StealCars[modeld];
	StealCar[3] = LCreateVehicle(csmodel, CarStealSpawns[csrand3][0], CarStealSpawns[csrand3][1], CarStealSpawns[csrand3][2], CarStealSpawns[csrand3][3], cscol1, cscol2, 0);
	StealCarMapIcon[3] = CreateDynamicMapIcon(CarStealSpawns[csrand3][0], CarStealSpawns[csrand3][1], CarStealSpawns[csrand3][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);

	csrand4 = random(sizeof(CarStealSpawns));cscol1 = random(256);cscol2 = random(256);modeld = random(133); csmodel = StealCars[modeld];
	StealCar[4] = LCreateVehicle(csmodel, CarStealSpawns[csrand4][0], CarStealSpawns[csrand4][1], CarStealSpawns[csrand4][2], CarStealSpawns[csrand4][3], cscol1, cscol2, 0);
	StealCarMapIcon[4] = CreateDynamicMapIcon(CarStealSpawns[csrand4][0], CarStealSpawns[csrand4][1], CarStealSpawns[csrand4][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);

    csrand5 = random(sizeof(CarStealSpawns));cscol1 = random(256);cscol2 = random(256);modeld = random(133); csmodel = StealCars[modeld];
	StealCar[5] = LCreateVehicle(csmodel, CarStealSpawns[csrand5][0], CarStealSpawns[csrand5][1], CarStealSpawns[csrand5][2], CarStealSpawns[csrand5][3], cscol1, cscol2, 0);
	StealCarMapIcon[5] = CreateDynamicMapIcon(CarStealSpawns[csrand5][0], CarStealSpawns[csrand5][1], CarStealSpawns[csrand5][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);

    csrand6 = random(sizeof(CarStealSpawns));cscol1 = random(256);cscol2 = random(256);modeld = random(133); csmodel = StealCars[modeld];
	StealCar[6] = LCreateVehicle(csmodel, CarStealSpawns[csrand6][0], CarStealSpawns[csrand6][1], CarStealSpawns[csrand6][2], CarStealSpawns[csrand6][3], cscol1, cscol2, 0);
	StealCarMapIcon[6] = CreateDynamicMapIcon(CarStealSpawns[csrand6][0], CarStealSpawns[csrand6][1], CarStealSpawns[csrand6][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);

    csrand7 = random(sizeof(CarStealSpawns));cscol1 = random(256);cscol2 = random(256);modeld = random(133); csmodel = StealCars[modeld];
	StealCar[7] = LCreateVehicle(csmodel, CarStealSpawns[csrand7][0], CarStealSpawns[csrand7][1], CarStealSpawns[csrand7][2], CarStealSpawns[csrand7][3], cscol1, cscol2, 0);
	StealCarMapIcon[7] = CreateDynamicMapIcon(CarStealSpawns[csrand7][0], CarStealSpawns[csrand7][1], CarStealSpawns[csrand7][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);

    csrand8 = random(sizeof(CarStealSpawns));cscol1 = random(256);cscol2 = random(256);modeld = random(133); csmodel = StealCars[modeld];
	StealCar[8] = LCreateVehicle(csmodel, CarStealSpawns[csrand8][0], CarStealSpawns[csrand8][1], CarStealSpawns[csrand8][2], CarStealSpawns[csrand8][3], cscol1, cscol2, 0);
	StealCarMapIcon[8] = CreateDynamicMapIcon(CarStealSpawns[csrand8][0], CarStealSpawns[csrand8][1], CarStealSpawns[csrand8][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);

    csrand9 = random(sizeof(CarStealSpawns));cscol1 = random(256);cscol2 = random(256);modeld = random(133); csmodel = StealCars[modeld];
	StealCar[9] = LCreateVehicle(csmodel, CarStealSpawns[csrand9][0], CarStealSpawns[csrand9][1], CarStealSpawns[csrand9][2], CarStealSpawns[csrand9][3], cscol1, cscol2, 0);
	StealCarMapIcon[9] = CreateDynamicMapIcon(CarStealSpawns[csrand9][0], CarStealSpawns[csrand9][1], CarStealSpawns[csrand9][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);

    csrand10 = random(sizeof(CarStealSpawns));cscol1 = random(256);cscol2 = random(256);modeld = random(133); csmodel = StealCars[modeld];
	StealCar[10] = LCreateVehicle(csmodel, CarStealSpawns[csrand10][0], CarStealSpawns[csrand10][1], CarStealSpawns[csrand10][2], CarStealSpawns[csrand10][3], cscol1, cscol2, 0);
	StealCarMapIcon[10] = CreateDynamicMapIcon(CarStealSpawns[csrand10][0], CarStealSpawns[csrand10][1], CarStealSpawns[csrand10][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);

    csrand11 = random(sizeof(CarStealSpawns));cscol1 = random(256);cscol2 = random(256);modeld = random(133); csmodel = StealCars[modeld];
	StealCar[11] = LCreateVehicle(csmodel, CarStealSpawns[csrand11][0], CarStealSpawns[csrand11][1], CarStealSpawns[csrand11][2], CarStealSpawns[csrand11][3], cscol1, cscol2, 0);
	StealCarMapIcon[11] = CreateDynamicMapIcon(CarStealSpawns[csrand11][0], CarStealSpawns[csrand11][1], CarStealSpawns[csrand11][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);

    csrand12 = random(sizeof(CarStealSpawns));cscol1 = random(256);cscol2 = random(256);modeld = random(133); csmodel = StealCars[modeld];
	StealCar[12] = LCreateVehicle(csmodel, CarStealSpawns[csrand12][0], CarStealSpawns[csrand12][1], CarStealSpawns[csrand12][2], CarStealSpawns[csrand12][3], cscol1, cscol2, 0);
	StealCarMapIcon[12] = CreateDynamicMapIcon(CarStealSpawns[csrand12][0], CarStealSpawns[csrand12][1], CarStealSpawns[csrand12][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);

    csrand13 = random(sizeof(CarStealSpawns));cscol1 = random(256);cscol2 = random(256);modeld = random(133); csmodel = StealCars[modeld];
	StealCar[13] = LCreateVehicle(csmodel, CarStealSpawns[csrand13][0], CarStealSpawns[csrand13][1], CarStealSpawns[csrand13][2], CarStealSpawns[csrand13][3], cscol1, cscol2, 0);
	StealCarMapIcon[13] = CreateDynamicMapIcon(CarStealSpawns[csrand13][0], CarStealSpawns[csrand13][1], CarStealSpawns[csrand13][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);

    csrand14 = random(sizeof(CarStealSpawns));cscol1 = random(256);cscol2 = random(256);modeld = random(133); csmodel = StealCars[modeld];
	StealCar[14] = LCreateVehicle(csmodel, CarStealSpawns[csrand14][0], CarStealSpawns[csrand14][1], CarStealSpawns[csrand14][2], CarStealSpawns[csrand14][3], cscol1, cscol2, 0);
	StealCarMapIcon[14] = CreateDynamicMapIcon(CarStealSpawns[csrand14][0], CarStealSpawns[csrand14][1], CarStealSpawns[csrand14][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);

    csrand15 = random(sizeof(CarStealSpawns));cscol1 = random(256);cscol2 = random(256);modeld = random(133); csmodel = StealCars[modeld];
	StealCar[15] = LCreateVehicle(csmodel, CarStealSpawns[csrand15][0], CarStealSpawns[csrand15][1], CarStealSpawns[csrand15][2], CarStealSpawns[csrand15][3], cscol1, cscol2, 0);
	StealCarMapIcon[15] = CreateDynamicMapIcon(CarStealSpawns[csrand15][0], CarStealSpawns[csrand15][1], CarStealSpawns[csrand15][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);

	csrand16 = random(sizeof(CarStealSpawns));cscol1 = random(256);cscol2 = random(256);modeld = random(133); csmodel = StealCars[modeld];
	StealCar[16] = LCreateVehicle(csmodel, CarStealSpawns[csrand16][0], CarStealSpawns[csrand16][1], CarStealSpawns[csrand16][2], CarStealSpawns[csrand16][3], cscol1, cscol2, 0);
	StealCarMapIcon[16] = CreateDynamicMapIcon(CarStealSpawns[csrand16][0], CarStealSpawns[csrand16][1], CarStealSpawns[csrand16][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);

	csrand17 = random(sizeof(CarStealSpawns));cscol1 = random(256);cscol2 = random(256);modeld = random(133); csmodel = StealCars[modeld];
	StealCar[17] = LCreateVehicle(csmodel, CarStealSpawns[csrand17][0], CarStealSpawns[csrand17][1], CarStealSpawns[csrand17][2], CarStealSpawns[csrand17][3], cscol1, cscol2, 0);
	StealCarMapIcon[17] = CreateDynamicMapIcon(CarStealSpawns[csrand17][0], CarStealSpawns[csrand17][1], CarStealSpawns[csrand17][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);

	csrand18 = random(sizeof(CarStealSpawns));cscol1 = random(256);cscol2 = random(256);modeld = random(133); csmodel = StealCars[modeld];
	StealCar[18] = LCreateVehicle(csmodel, CarStealSpawns[csrand18][0], CarStealSpawns[csrand18][1], CarStealSpawns[csrand18][2], CarStealSpawns[csrand18][3], cscol1, cscol2, 0);
	StealCarMapIcon[18] = CreateDynamicMapIcon(CarStealSpawns[csrand18][0], CarStealSpawns[csrand18][1], CarStealSpawns[csrand18][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);

	csrand19 = random(sizeof(CarStealSpawns));cscol1 = random(256);cscol2 = random(256);modeld = random(133); csmodel = StealCars[modeld];
	StealCar[19] = LCreateVehicle(csmodel, CarStealSpawns[csrand19][0], CarStealSpawns[csrand19][1], CarStealSpawns[csrand19][2], CarStealSpawns[csrand19][3], cscol1, cscol2, 0);
	StealCarMapIcon[19] = CreateDynamicMapIcon(CarStealSpawns[csrand19][0], CarStealSpawns[csrand19][1], CarStealSpawns[csrand19][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);

	csrand20 = random(sizeof(CarStealSpawns));cscol1 = random(256);cscol2 = random(256);modeld = random(133); csmodel = StealCars[modeld];
	StealCar[20] = LCreateVehicle(csmodel, CarStealSpawns[csrand20][0], CarStealSpawns[csrand20][1], CarStealSpawns[csrand20][2], CarStealSpawns[csrand20][3], cscol1, cscol2, 0);
	StealCarMapIcon[20] = CreateDynamicMapIcon(CarStealSpawns[csrand20][0], CarStealSpawns[csrand20][1], CarStealSpawns[csrand20][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);

	csrand21 = random(sizeof(CarStealSpawns));cscol1 = random(256);cscol2 = random(256);modeld = random(133); csmodel = StealCars[modeld];
	StealCar[21] = LCreateVehicle(csmodel, CarStealSpawns[csrand21][0], CarStealSpawns[csrand21][1], CarStealSpawns[csrand21][2], CarStealSpawns[csrand21][3], cscol1, cscol2, 0);
	StealCarMapIcon[21] = CreateDynamicMapIcon(CarStealSpawns[csrand21][0], CarStealSpawns[csrand21][1], CarStealSpawns[csrand21][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);

	csrand22 = random(sizeof(CarStealSpawns));cscol1 = random(256);cscol2 = random(256);modeld = random(133); csmodel = StealCars[modeld];
	StealCar[22] = LCreateVehicle(csmodel, CarStealSpawns[csrand22][0], CarStealSpawns[csrand22][1], CarStealSpawns[csrand22][2], CarStealSpawns[csrand22][3], cscol1, cscol2, 0);
	StealCarMapIcon[22] = CreateDynamicMapIcon(CarStealSpawns[csrand22][0], CarStealSpawns[csrand22][1], CarStealSpawns[csrand22][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);

	csrand23 = random(sizeof(CarStealSpawns));cscol1 = random(256);cscol2 = random(256);modeld = random(133); csmodel = StealCars[modeld];
	StealCar[23] = LCreateVehicle(csmodel, CarStealSpawns[csrand23][0], CarStealSpawns[csrand23][1], CarStealSpawns[csrand23][2], CarStealSpawns[csrand23][3], cscol1, cscol2, 0);
	StealCarMapIcon[23] = CreateDynamicMapIcon(CarStealSpawns[csrand23][0], CarStealSpawns[csrand23][1], CarStealSpawns[csrand23][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);

	csrand24 = random(sizeof(CarStealSpawns));cscol1 = random(256);cscol2 = random(256);modeld = random(133); csmodel = StealCars[modeld];
	StealCar[24] = LCreateVehicle(csmodel, CarStealSpawns[csrand24][0], CarStealSpawns[csrand24][1], CarStealSpawns[csrand24][2], CarStealSpawns[csrand24][3], cscol1, cscol2, 0);
	StealCarMapIcon[24] = CreateDynamicMapIcon(CarStealSpawns[csrand24][0], CarStealSpawns[csrand24][1], CarStealSpawns[csrand24][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);

	csrand25 = random(sizeof(CarStealSpawns));cscol1 = random(256);cscol2 = random(256);modeld = random(133); csmodel = StealCars[modeld];
	StealCar[25] = LCreateVehicle(csmodel, CarStealSpawns[csrand25][0], CarStealSpawns[csrand25][1], CarStealSpawns[csrand25][2], CarStealSpawns[csrand25][3], cscol1, cscol2, 0);
	StealCarMapIcon[25] = CreateDynamicMapIcon(CarStealSpawns[csrand25][0], CarStealSpawns[csrand25][1], CarStealSpawns[csrand25][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);

	//Водные авто для угона
	csrand26 = random(sizeof(CarStealWaterSpawns));cscol1 = random(256);cscol2 = random(256);modeld = random(11); csmodel = StealWaterCars[modeld];
	StealCar[26] = LCreateVehicle(csmodel, CarStealWaterSpawns[csrand26][0], CarStealWaterSpawns[csrand26][1], CarStealWaterSpawns[csrand26][2], CarStealWaterSpawns[csrand26][3], cscol1, cscol2, 0);
	StealCarMapIcon[26] = CreateDynamicMapIcon(CarStealWaterSpawns[csrand26][0], CarStealWaterSpawns[csrand26][1], CarStealWaterSpawns[csrand26][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);

	csrand27 = random(sizeof(CarStealWaterSpawns));cscol1 = random(256);cscol2 = random(256);modeld = random(11); csmodel = StealWaterCars[modeld];
	StealCar[27] = LCreateVehicle(csmodel, CarStealWaterSpawns[csrand27][0], CarStealWaterSpawns[csrand27][1], CarStealWaterSpawns[csrand27][2], CarStealWaterSpawns[csrand27][3], cscol1, cscol2, 0);
	StealCarMapIcon[27] = CreateDynamicMapIcon(CarStealWaterSpawns[csrand27][0], CarStealWaterSpawns[csrand27][1], CarStealWaterSpawns[csrand27][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);

	csrand28 = random(sizeof(CarStealWaterSpawns));cscol1 = random(256);cscol2 = random(256);modeld = random(11); csmodel = StealWaterCars[modeld];
	StealCar[28] = LCreateVehicle(csmodel, CarStealWaterSpawns[csrand28][0], CarStealWaterSpawns[csrand28][1], CarStealWaterSpawns[csrand28][2], CarStealWaterSpawns[csrand28][3], cscol1, cscol2, 0);
	StealCarMapIcon[28] = CreateDynamicMapIcon(CarStealWaterSpawns[csrand28][0], CarStealWaterSpawns[csrand28][1], CarStealWaterSpawns[csrand28][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);

	csrand29 = random(sizeof(CarStealWaterSpawns));cscol1 = random(256);cscol2 = random(256);modeld = random(11); csmodel = StealWaterCars[modeld];
	StealCar[29] = LCreateVehicle(csmodel, CarStealWaterSpawns[csrand29][0], CarStealWaterSpawns[csrand29][1], CarStealWaterSpawns[csrand29][2], CarStealWaterSpawns[csrand29][3], cscol1, cscol2, 0);
	StealCarMapIcon[29] = CreateDynamicMapIcon(CarStealWaterSpawns[csrand29][0], CarStealWaterSpawns[csrand29][1], CarStealWaterSpawns[csrand29][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);

	csrand30 = random(sizeof(CarStealWaterSpawns));cscol1 = random(256);cscol2 = random(256);modeld = random(11); csmodel = StealWaterCars[modeld];
	StealCar[30] = LCreateVehicle(csmodel, CarStealWaterSpawns[csrand30][0], CarStealWaterSpawns[csrand30][1], CarStealWaterSpawns[csrand30][2], CarStealWaterSpawns[csrand30][3], cscol1, cscol2, 0);
	StealCarMapIcon[30] = CreateDynamicMapIcon(CarStealWaterSpawns[csrand30][0], CarStealWaterSpawns[csrand30][1], CarStealWaterSpawns[csrand30][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);

	//Воздушные авто для угона
	csrand31 = random(sizeof(CarStealAirSpawns));cscol1 = random(256);cscol2 = random(256);modeld = random(13); csmodel = StealAirCars[modeld];
	StealCar[31] = LCreateVehicle(csmodel, CarStealAirSpawns[csrand31][0], CarStealAirSpawns[csrand31][1], CarStealAirSpawns[csrand31][2], CarStealAirSpawns[csrand31][3], cscol1, cscol2, 0);
	StealCarMapIcon[31] = CreateDynamicMapIcon(CarStealAirSpawns[csrand31][0], CarStealAirSpawns[csrand31][1], CarStealAirSpawns[csrand31][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);

	csrand32 = random(sizeof(CarStealAirSpawns));cscol1 = random(256);cscol2 = random(256);modeld = random(13); csmodel = StealAirCars[modeld];
	StealCar[32] = LCreateVehicle(csmodel, CarStealAirSpawns[csrand32][0], CarStealAirSpawns[csrand32][1], CarStealAirSpawns[csrand32][2], CarStealAirSpawns[csrand32][3], cscol1, cscol2, 0);
	StealCarMapIcon[32] = CreateDynamicMapIcon(CarStealAirSpawns[csrand32][0], CarStealAirSpawns[csrand32][1], CarStealAirSpawns[csrand32][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);

	csrand33 = random(sizeof(CarStealAirSpawns));cscol1 = random(256);cscol2 = random(256);modeld = random(13); csmodel = StealAirCars[modeld];
	StealCar[33] = LCreateVehicle(csmodel, CarStealAirSpawns[csrand33][0], CarStealAirSpawns[csrand33][1], CarStealAirSpawns[csrand33][2], CarStealAirSpawns[csrand33][3], cscol1, cscol2, 0);
	StealCarMapIcon[33] = CreateDynamicMapIcon(CarStealAirSpawns[csrand33][0], CarStealAirSpawns[csrand33][1], CarStealAirSpawns[csrand33][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);

	csrand34 = random(sizeof(CarStealAirSpawns));cscol1 = random(256);cscol2 = random(256);modeld = random(13); csmodel = StealAirCars[modeld];
	StealCar[34] = LCreateVehicle(csmodel, CarStealAirSpawns[csrand34][0], CarStealAirSpawns[csrand34][1], CarStealAirSpawns[csrand34][2], CarStealAirSpawns[csrand34][3], cscol1, cscol2, 0);
	StealCarMapIcon[34] = CreateDynamicMapIcon(CarStealAirSpawns[csrand34][0], CarStealAirSpawns[csrand34][1], CarStealAirSpawns[csrand34][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);

	csrand35 = random(sizeof(CarStealAirSpawns));cscol1 = random(256);cscol2 = random(256);modeld = random(13); csmodel = StealAirCars[modeld];
	StealCar[35] = LCreateVehicle(csmodel, CarStealAirSpawns[csrand35][0], CarStealAirSpawns[csrand35][1], CarStealAirSpawns[csrand35][2], CarStealAirSpawns[csrand35][3], cscol1, cscol2, 0);
	StealCarMapIcon[35] = CreateDynamicMapIcon(CarStealAirSpawns[csrand35][0], CarStealAirSpawns[csrand35][1], CarStealAirSpawns[csrand35][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);

	UsePlayerPedAnims();
	EnableStuntBonusForAll(0);
	AllowInteriorWeapons(1);
	
	//Погода при старте сервера
	ServerWeather = random(20);
	if (ServerWeather == 8 || ServerWeather == 16 || ServerWeather == 19) ServerWeather -= 1;//Удаление погоды с дождем и с бурей
    if (ServerWeather == 9) ServerWeather = 10;
	SetWeather(ServerWeather);

	//new Test[80]; format(Test, sizeof Test, "Dynamic Pickups: %d", CountDynamicPickups()); print(Test);
	return 1;
}

public OnGameModeExit()
{
	SaveAllClans();SaveAllProperty(); SaveAllBase();
	foreach(Player, gid) if (Logged[gid] == 1) {SavePlayer(gid); Logged[gid] = 0;}
	
	//Запись в лог. Например WriteLog("Файл", "Привет Мир!"); запишет в лог "Файл.ini" фразу "Привет Мир!"
	new String[120];format(String, sizeof String, "%d.%d.%d в %d:%d:%d |   Сервер выключен.", Day, Month, Year, hour, minute, second);WriteLog("GlobalLog", String);

	return 1;
}

stock StartLogin(playerid)
{
	new filename[MAX_FILE_NAME];
	format(filename, sizeof(filename), "accounts/%s.ini", GetName(playerid));
	if(fexist(filename))
	{
		Registered[playerid] = 1;
		LoadPlayer(playerid);
	}
	//первое обновление NeedXP
	new Lvl = Player[playerid][Level];
	if (Player[playerid][Prestige] < 10 || Lvl < 100) NeedXP[playerid] = Levels[Lvl];
	else NeedXP[playerid] = (Lvl - 99) * 100 + 35000;

	for (new i; i < 100; i++) SendClientMessage(playerid, -1, "");
    new WelcomeString[120];format(WelcomeString, sizeof WelcomeString, "{FFFFFF}Добро пожаловать на сервер {007FFF}%s", SERVER_NAME);
	SendClientMessage(playerid,-1,WelcomeString);
	SendClientMessage(playerid,COLOR_WHITE,"{457EFF}ПОПУЛЯРНЫЕ КОМАНДЫ: {FF0000}/help, {FFFF00}/events, /quests, /gps, /stats, /bg, /radio");
	SendClientMessage(playerid,COLOR_WHITE,"{457EFF}ЧАТ: {FFFF00}/pm, '@текст' - администраторам, '#текст' - шепотом, '!текст' - клану");
	SendClientMessage(playerid,COLOR_WHITE,"{FFFFFF}Чтобы посмотреть полный список команд, введите {007FFF}/commands");

    if (LogidDialogShowed[playerid] == 0)
	{//Если первый раз
		new string[MAX_DIALOG_INFO];
        if(Registered[playerid] == 0)
		{//окно регистрации
		    format(string, sizeof(string), "{FFFFFF}Добро пожаловать на {00BFFF}%s{FFFFFF}\nДля игры вам нужно зарегистрироваться\n\nВведите пароль для вашего аккаунта\nОн будет запрашиваться при каждом заходе на сервер\n\n     {008000}Примечания:\n     - Пароль должен быть сложным (Пример: s9cQ17)\n     - Длина пароля должна быть от 6 до 24 символов\n\n{FFFFFF}Введите пароль:", SERVER_NAME);
			ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "{FFD700}Регистрация", string, "Готово", "Отмена");
			LoginKickTime[playerid] = 180;//Дается 3 минуты на регистрацию
		}//окно регистрации и выбор скина
		if(Registered[playerid] == 1)
		{//окно логина
			format(string, sizeof(string), "{FFFFFF}Добро пожаловать на {00BFFF}%s{FFFFFF}\nВаш аккаунт зарегестрирован\n\nЛогин: {008000}%s\n{FFFFFF}Введите пароль:", SERVER_NAME, GetName(playerid));
			ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT, "{FFD700}Авторизация", string, "Войти", "Отмена");
			LoginKickTime[playerid] = 120;//Дается 2 минуты на авторизацию
		}//окно логина
		LogidDialogShowed[playerid] = 1; TogglePlayerSpectating(playerid, 1);

		InterpolateCameraPos(playerid, 2347.1621,2138.8210,41, 2347.1621,2138.8210,41, 10000, CAMERA_CUT);
		InterpolateCameraLookAt(playerid, 2320.1621,2138.8210,41, 2320.1621,2138.8210,41, 1000, CAMERA_CUT);
	}//если первый раз
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
    LSpawnPlayer(playerid);
	if (Logged[playerid] == 0) StartLogin(playerid);
	return 1;
}

public OnPlayerConnect(playerid)
{
	//--- не больше 3 игроков с 1 IP
	new ip[2][16];
    GetPlayerIp(playerid,ip[0],16);GetPlayerIp(playerid,PlayerIP[playerid],16);
    for(new i, m = GetMaxPlayers(), x; i != m; i++)
    {//--- не больше 3 игроков с 1 IP
        if(!IsPlayerConnected(i) || i == playerid) continue;
        GetPlayerIp(i,ip[1],16);
        if(!strcmp(ip[0],ip[1],true)) x++;
        if(x > 3) return Kick(i);
    }//--- не больше 3 игроков с 1 IP

	//--- Цифры в нике
	new PlName[MAX_PLAYER_NAME],count;
	GetPlayerName(playerid,PlName,sizeof(PlName));
	for (new i; i < strlen(PlName); i++)
	{
	    if (PlName[i] >= '0' && PlName[i] <= '9')
	    {
	        count++;
	        if(count == 6)
	        {
	            for (new ii = 1; ii <= 5; ii++) SendClientMessage(playerid,COLOR_RED,"ОШИБКА: В вашем нике больше 5 цифр!");
	            return GKick(playerid);
	        }
	    }
	}//--- Цифры в нике

	ClanTextShowed[playerid] = 0;
	Player[playerid][MyClan] = 0;
	if (playerid > MaxPlayerID) MaxPlayerID = playerid;
	
	XReg[playerid] = 0;
	pKick[playerid] = 0;
	
	LSpecID[playerid] = -1;
	LSpectators[playerid] = 0;
	countpos[playerid] = 0;//vortex nitro

	//обнуление LAC
	ResetPlayerWeapons(playerid);
	LACSH[playerid] = 3;LACTeleportOff[playerid] = 10;
	LACWeaponOff[playerid] = 3;
	CheatFlySec[playerid] = 0; LACFlyOff[playerid] = 0;//на FlyHack
	LACPedSHOff[playerid] = 0; LACPedSHTime[playerid] = 0;//на SH пешком и Slapper
	LACPanic[playerid] = 0; LACPanicTime[playerid] = 0;//LAC v2.0
	PlayerColor[playerid] = 0; //обнуление цвета
	
	Registered[playerid] = 0;
	Errors[playerid] = 3;
	Logged[playerid] = 0;
	DerbyStarted[playerid] = 0;
	TimeTransform[playerid] = 0;
	TutorialStep[playerid] = 999;
	SkydiveTime[playerid] = 0;
	HealthTime[playerid] = 0;
	ArmourTime[playerid] = 0;
	RepairTime[playerid] = 0;
	PremiumTime[playerid] = 0;
	SkinChangeMode[playerid] = 0;
	SetPlayerColor(playerid,COLOR_GREY);//ставит игроку серый цвет
	HPRegenTime[playerid] = 0;
	JumpTime[playerid] = 0;
	SkillNTime[playerid] = 0;
	SkillYTime[playerid] = 0;
	SkillHTime[playerid] = 0;
	MapTPTime[playerid] = 0;
	CaseBugTime[playerid] = 0;
	GMTestStage[playerid] = 0;GMTestTime[playerid] = 0;
	FloodTime[playerid] = 0;FloodMessages[playerid] = 0;
	OnStartEvent[playerid] = 0;
	LACSH[playerid] = 3;
	PrestigeGM[playerid] = 0;
	LastPlayerTuneStatus[playerid] = 0;TunesPerSecond[playerid] = 0;
	UberNitroTime[playerid] = 0;
	GPSUsed[playerid] = 0;
	PrestigeTPTime[playerid] = 0;
	MapTP[playerid] = 0;
	LastBaseVisited[playerid] = 0; LastHouseVisited[playerid] = 0;//Для меню домов и штабов
	BadPingTime[playerid] = 0;
	LeaveDM[playerid] = 0; LeaveGG[playerid] = 0;
	
	InEvent[playerid] = 0; JoinEvent[playerid] = 0;
	ZMStarted[playerid] = 0; ZMIsPlayerIsZombie[playerid] = 0; ZMIsPlayerIsTank[playerid] = 0;
	FRStarted[playerid] = 0; XRStarted[playerid] = 0; GGKills[playerid] = 0;
	
	NOPSetPlayerHealth[playerid] = 0;
	NOPSetPlayerArmour[playerid] = 0;
	
	QuestActive[playerid] = 0;QuestCar[playerid] = -1;
	JetpackUsed[playerid] = 0;

	PlayerAFK[playerid][AFK_Time] = 0;
	PlayerAFK[playerid][AFK_Stat] = 0;
	FirstSobeitCheck[playerid] = 0;//Первичная проверка на Sobeit
	
	//PVP
	 PlayerPVP[playerid][Status] = 0;
	 PlayerPVP[playerid][Invite] = -1;
	 PlayerPVP[playerid][Map] = 1;
	 PlayerPVP[playerid][Weapon] = 24;
	 PlayerPVP[playerid][Health] = 200;
	 PlayerPVP[playerid][PlayMap] = 0;
	 PlayerPVP[playerid][PlayWeapon] = 0;
	 PlayerPVP[playerid][PlayHealth] = 0;
	 PlayerPVP[playerid][TimeOut] = 0;
	 CanStartPVP[playerid] = 0;
	 
	InitFly(playerid);//Для полета супер-мена (Престиж 2)
	OnVehFly[playerid] = 0;//Для полета на авто (Престиж 4)

	DisablePlayerCheckpoint(playerid);
	DisablePlayerRaceCheckpoint(playerid);
    GetPlayerName(playerid, PlayerName[playerid], 25);

	PlayerWeather[playerid] = 17; PlayerTime[playerid] = 23;//Погода до логина

	strmid(ChatName[playerid], PlayerName[playerid], 0, strlen(PlayerName[playerid]), 24);
	SetTimerEx("SecPlayerUpdate" , 1000, false, "i", playerid);
	#include "Transformer\Objects\RemoveBuilding" //Удаление объектов с карты
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	new OldMaxPlayerID = MaxPlayerID;
	for (new vid = 1; vid <= OldMaxPlayerID; vid++)
	{//цикл
	    if (IsPlayerConnected(vid) != 0)	MaxPlayerID = vid;
	}//цикл

	PlayerAFK[playerid][AFK_Time] = 0;
	if(PlayerAFK[playerid][AFK_Stat] != 0) { Delete3DTextLabel(AFK_3DT[playerid]); PlayerAFK[playerid][AFK_Stat] = 0; }

	if (PlayerPVP[playerid][Status] >= 2) FailPVP(playerid);

	ClanTextShowed[playerid] = 0;
	
	if (Logged[playerid] == 1)
	{//------------сообщение о выходе игрока с сервера
		new ChatMes[140], clanid = Player[playerid][MyClan], ccolor = Clan[clanid][cColor];
		switch (reason)
		{
			case 0:
				{
		           	foreach(Player, gid)
					{//цикл
						if (clanid > 0 && Player[gid][MyClan] == clanid)
						{
    					    format(ChatMes, sizeof ChatMes, "Соклановец %s[%d] покинул сервер (Вылет).", PlayerName[playerid], playerid);
							SendClientMessage(gid,ClanColor[ccolor],ChatMes);
						}
						if (Logged[gid] == 1 && Player[gid][Admin] > 0)
						{//если модер и выше
						    format(ChatMes, sizeof(ChatMes), "SERVER: %s[%d] покинул сервер (Вылет)[IP-Адрес:{FFFFFF} %s{AFAFAF}].", PlayerName[playerid], playerid, PlayerIP[playerid]);
						}//если модер и выше
						else{format(ChatMes, sizeof(ChatMes), "SERVER: %s[%d] покинул сервер (Вылет).", PlayerName[playerid], playerid);}
						if (Player[gid][ConMesEnterExit] == 1 && IsServerRestaring == 0) SendClientMessage(gid, COLOR_GREY, ChatMes);
					}//цикл
					//Запись в лог. Например WriteLog("Файл", "Привет Мир!"); запишет в лог "Файл.ini" фразу "Привет Мир!"
					format(ChatMes, sizeof ChatMes, "%d.%d.%d в %d:%d:%d |   %s[%d] покинул сервер (Вылет)[IP-Адрес: %s].", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid, PlayerIP[playerid]);WriteLog("GlobalLog", ChatMes);
				}
			case 1:
				{
					foreach(Player, gid)
					{//цикл
						if (clanid > 0 && Player[gid][MyClan] == clanid)
						{
    					    format(ChatMes, sizeof ChatMes, "Соклановец %s[%d] покинул сервер.", PlayerName[playerid], playerid);
							SendClientMessage(gid,ClanColor[ccolor],ChatMes);
						}
						if (Logged[gid] == 1 && Player[gid][Admin] > 0)
						{//если модер и выше
						    format(ChatMes, sizeof(ChatMes), "SERVER: %s[%d] покинул сервер [IP-Адрес:{FFFFFF} %s{AFAFAF}].", PlayerName[playerid], playerid, PlayerIP[playerid]);
						}//если модер и выше
						else{format(ChatMes, sizeof(ChatMes), "SERVER: %s[%d] покинул сервер.", PlayerName[playerid], playerid);}
						if (Player[gid][ConMesEnterExit] == 1 && IsServerRestaring == 0) SendClientMessage(gid, COLOR_GREY, ChatMes);
					}//цикл
					if (InEvent[playerid] == EVENT_ZOMBIE && ZMTimeToFirstZombie == 0) Player[playerid][LeaveZM] = 3600;//час не может участвовать в зомби-выживании если подставил своих товарищей
	                //Запись в лог. Например WriteLog("Файл", "Привет Мир!"); запишет в лог "Файл.ini" фразу "Привет Мир!"
					format(ChatMes, sizeof ChatMes, "%d.%d.%d в %d:%d:%d |   %s[%d] покинул сервер [IP-Адрес: %s].", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid, PlayerIP[playerid]);WriteLog("GlobalLog", ChatMes);
				}
			case 2:
				{
					foreach(Player, gid)
					{//цикл
						if (clanid > 0 && Player[gid][MyClan] == clanid)
						{
    					    format(ChatMes, sizeof ChatMes, "Соклановец %s[%d] покинул сервер (Кик/Бан).", PlayerName[playerid], playerid);
							SendClientMessage(gid,ClanColor[ccolor],ChatMes);
						}
						if (Logged[gid] == 1 && Player[gid][Admin] > 0)
						{//если модер и выше
						    format(ChatMes, sizeof(ChatMes), "SERVER: %s[%d] покинул сервер (Кик/Бан)[IP-Адрес:{FFFFFF} %s{AFAFAF}].", PlayerName[playerid], playerid, PlayerIP[playerid]);
						}//если модер и выше
						else{format(ChatMes, sizeof(ChatMes), "SERVER: %s[%d] покинул сервер (Кик/Бан).", PlayerName[playerid], playerid);}
						if (Player[gid][ConMesEnterExit] == 1 && IsServerRestaring == 0) SendClientMessage(gid, COLOR_GREY, ChatMes);
					}//цикл
					//Запись в лог. Например WriteLog("Файл", "Привет Мир!"); запишет в лог "Файл.ini" фразу "Привет Мир!"
					format(ChatMes, sizeof ChatMes, "%d.%d.%d в %d:%d:%d |   %s[%d] покинул сервер (Кик/Бан)[IP-Адрес: %s].", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid, PlayerIP[playerid]);WriteLog("GlobalLog", ChatMes);
				}
			}
	}//------------сообщение о выходе игрока с сервера
	
	LogidDialogShowed[playerid] = 0;
	Player[playerid][CarActive] = 0;
	JetpackUsed[playerid] = 0;
	if (Logged[playerid] == 1) SavePlayer(playerid);//сохранение акка
	DerbyStarted[playerid] = 0;
	ZMStarted[playerid] = 0;
	FRStarted[playerid] = 0;DisablePlayerCheckpoint(playerid);
	XRStarted[playerid] = 0;DisablePlayerRaceCheckpoint(playerid);
	
	//Обнуляем первичную проверку на собейт
	KillTimer(FirstSobeitCheckTimer[playerid]);	FirstSobeitCheck[playerid] = 0;

    if(countpos[playerid] != 0)
	{//vortex nitro
		countpos[playerid] = 0;
		DestroyObject(Flame[playerid][0]);
		DestroyObject(Flame[playerid][1]);
	}//vortex nitro
	
	TextDrawHideForPlayer(playerid, TextDrawTime), TextDrawHideForPlayer(playerid, TextDrawDate);

    //отключение спектра у тех, кто следил за игроком
	foreach(Player, i)
	{//отключение спектра у тех, кто следил за игроком
	    if (LSpecID[i] == playerid)
	    {
	        TogglePlayerSpectating(i, 0);LSpecID[i] = -1;PlayerWeather[i] = -1;LSpawnPlayer(i);
	        SendClientMessage(i,COLOR_YELLOW,"Игрок, за которым вы следили, покинул сервер.");
	    }
	}//отключение спектра у тех, кто следил за игроком
	
	//Удаление связанных с игроком объектов
	if (TutorialObject[playerid] != -1){DestroyObject(TutorialObject[playerid]);TutorialObject[playerid] = -1;}

	Logged[playerid] = 0; ResetPlayer(playerid);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if (NeedLSpawn[playerid] > 0){NeedLSpawn[playerid] = 0;LSpawnPlayer(playerid);}
	LACSH[playerid] = 3;LACTeleportOff[playerid] = 3;
	LACWeaponOff[playerid] = 3; CheatFlySec[playerid] = 0;
	SetPlayerHealth(playerid, 100.0); SetPlayerArmour(playerid, 0.0);
	NOPSetPlayerHealth[playerid] = 0; NOPSetPlayerArmour[playerid] = 0;
	if (Logged[playerid] > 0) SetCameraBehindPlayer(playerid);
	if (InEvent[playerid] == EVENT_GUNGAME) GiveGGWeapon(playerid);//гангейм спавн
	
	if (LSpectators[playerid] > 0) {SpecUpdate(playerid);}
	
	Player[playerid][CarActive] = 0;
	PlayerCarID[playerid] = -1;
	DerbyStarted[playerid] = 0;
	LastDamageFrom[playerid] = -1;

	//----- Стили драки
	if (Player[playerid][Slot9] == 0){SetPlayerFightingStyle (playerid, FIGHT_STYLE_NORMAL);}
	if (Player[playerid][Slot9] == 1){SetPlayerFightingStyle (playerid, FIGHT_STYLE_BOXING);}
	if (Player[playerid][Slot9] == 2){SetPlayerFightingStyle (playerid, FIGHT_STYLE_KUNGFU);}
	if (Player[playerid][Slot9] == 3){SetPlayerFightingStyle (playerid, FIGHT_STYLE_KNEEHEAD);}
	if (Player[playerid][Slot9] == 4){SetPlayerFightingStyle (playerid, FIGHT_STYLE_GRABKICK);}
	if (Player[playerid][Slot9] == 5){SetPlayerFightingStyle (playerid, FIGHT_STYLE_ELBOW);}

    //PVars
	SetPVarInt(playerid, "CashBag", 0);//Для мешка денег за спиной

	if (TutorialStep[playerid] != 999){SetPlayerVirtualWorld(playerid,playerid+1);}//только зарегистрировался
	if (Logged[playerid] > 0)
	{
	    TogglePlayerControllable(playerid, 1);
		SetTimerEx("SpawnStylePub" , 650, false, "i", playerid);//спавн со стилем, личное оружие
	} else TogglePlayerControllable(playerid, 0);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{//стандартная смерть (синхронизация от playerid)
	LACWeaponOff[playerid] = 3; NOPSetPlayerHealthAndArmourOff[playerid] = 3;
	NeedLSpawn[playerid] = 1;
	if (OnFly[playerid] == 1) StopFly(playerid);//Выключает режим супермена (престиж)
	if (InEvent[playerid] == EVENT_RACE) SendCommand(playerid, "/race", ""); //чтобы после респавна нельзя было дальше участвовать в гонках
	if (InEvent[playerid] == EVENT_XRACE) SendCommand(playerid, "/xrace", ""); //чтобы после респавна нельзя было дальше участвовать в гонках

	//Анти-обход слива фрага путем самоубийства на соревновании
	if (InEvent[playerid] == EVENT_DM || InEvent[playerid] == EVENT_GUNGAME || (InEvent[playerid] == EVENT_ZOMBIE && ZMIsPlayerIsZombie[playerid] > 0))
		if (killerid != LastDamageFrom[playerid] && IsPlayerConnected(LastDamageFrom[playerid])) OnPlayerDeathFromPlayer(playerid, LastDamageFrom[playerid], 54);

	return 1;
}//стандартная смерть (синхронизация от playerid)

stock OnPlayerDeathFromPlayer(playerid, killerid, weaponid)
{//Смерть от рук игрока (синхронизация от killerid)
	if (LastDeathTime[playerid] < 3 || playerid == killerid) return 1;
    LastDeathTime[playerid] = 0;
    
    if (ZMIsPlayerIsZombie[playerid] == 0 && ZMIsPlayerIsZombie[killerid] > 0)
	{//превращение в зомби зараженного
		ZMIsPlayerIsZombie[playerid] = 1; SendDeathMessage(killerid, playerid, 52);
		FarmedXP[killerid] += 100; FarmedMoney[killerid] += 800; //100 XP и 800$ за каждый удар
		GameTextForPlayer(killerid, "~Y~+~W~100 ~Y~XP   +~W~800~Y~$", 3000, 6);
		return SendClientMessage(playerid, COLOR_ZOMBIE, "Вы стали зомби! Атакуйте выживших!");
	}//превращение в зомби зараженного

    if (TimeAfterSpawn[playerid] < 5)
    {//Убили в течение 5 сек после респавна
        SendClientMessage(playerid,COLOR_YELLOW,"SERVER: Вас убили в течение 5 секунд после респавна. Не переживайте, убийство не засчитано.");
		return SendClientMessage(killerid,COLOR_RED,"SERVER: Нельзя убивать игроков в течение 5 секунд после респавна! Убийство не засчитано.");
    }//Убили в течение 5 сек после респавна
    if (weaponid == 38 && Player[playerid][Level] < 60 && InEvent[playerid] == 0)
	{//Убийство нуба с минигана
	    SendClientMessage(playerid,COLOR_YELLOW,"SERVER: Вас убил при помощи минигана игрок высокого уровня. Не переживайте, убийство не засчитано.");
		return SendClientMessage(killerid,COLOR_RED,"SERVER: С минигана нельзя убивать игроков, не достигших 60-го уровня! Убийство не засчитано.");
    }//Убийство нуба с минигана
    if (AdminTPCantKill[killerid] > 0)
    {//Убийцу недавно телепортировал модератор
        SendClientMessage(playerid, COLOR_YELLOW, "SERVER: Вас убил игрок, который использовал телепортацию.. Не переживайте, убийство не засчитано.");
        return SendClientMessage(killerid, COLOR_RED, "SERVER: Запрещено убивать игроков после телепортации! Убийство не засчитано.");
    }//Убийцу недавно телепортировал модератор
    
	SendDeathMessage(killerid, playerid, weaponid); //киллист

    QuestUpdate(killerid, 6, 1);//Обновление квеста Убить 50 человек
    if (weaponid <= 15 && weaponid > 0) QuestUpdate(killerid, 2, 1);//Обновление квеста Убить 5 человек при помощи холодного оружия
    else if (weaponid >= 22 && weaponid <= 24) QuestUpdate(killerid, 7, 1);//Обновление квеста Убить 10 человек из пистолета
    else if (weaponid >= 25 && weaponid <= 27) QuestUpdate(killerid, 8, 1);//Обновление квеста Убить 10 человек из дробовика
	else if (weaponid == 28 || weaponid == 29 || weaponid == 32) QuestUpdate(killerid, 9, 1);//Обновление квеста Убить 10 человек из ПП
	else if (weaponid == 30 || weaponid == 31) QuestUpdate(killerid, 10, 1);//Обновление квеста Убить 10 человек из автомата
	
	if (PlayerPVP[playerid][Status] > 2 && PlayerPVP[killerid][Status] > 2) return FailPVP(playerid);

	if (JoinEvent[killerid] == EVENT_DM && JoinEvent[playerid] == EVENT_DM && DMTimeToEnd > 0)
	{//убийство в десматче
		new StringZ[140]; DMKills[killerid]++;
		format(StringZ, sizeof StringZ, "~Y~KILLS: ~W~%d", DMKills[killerid]);
		GameTextForPlayer(killerid, StringZ, 3000, 6);
		if (DMKills[killerid] > DMLeaderKills) {DMLeaderID = killerid; DMLeaderKills = DMKills[killerid];}
        QuestUpdate(killerid, 1, 1);//Обновление квеста 40 убийств в дм
		return 1;
	}//убийство в десматче
	
	if (ZMStarted[killerid] == 1 && ZMIsPlayerIsZombie[playerid] > 0 && ZMIsPlayerIsZombie[killerid] == 0)
	{//убийство человеком зомби на выживании
	    if (ZMKillsXP[killerid] < 300)
	    {
			FarmedXP[killerid] += 15; ZMKillsXP[killerid] += 15; FarmedMoney[killerid] += 250;
			GameTextForPlayer(killerid, "~Y~+~W~15 ~Y~XP   +~W~250~Y~$", 3000, 6);
		}//убийство игрока чужой команды
		else
		{//Достигнут лимит ХР за убийство зомби
		    FarmedMoney[killerid] += 250; GameTextForPlayer(killerid, "~Y~+~W~250~Y~$", 3000, 6);
		}//Достигнут лимит ХР за убийство зомби
		QuestUpdate(killerid, 3, 1);//Обновление квеста 15 убийств зомби в зомби-выживании
		return 1;
	}//убийство человеком зомби на выживании
	if (killerid != playerid && ZMIsPlayerIsZombie[killerid] == 0 && ZMIsPlayerIsZombie[playerid] == 0 && ZMStarted[killerid] == 1 && ZMStarted[playerid] == 1)
	{//тимкилл на Зомби-Выживании
		ZMStarted[killerid] = 0; ZMIsPlayerIsZombie[killerid] = 0; ZMIsPlayerIsTank[killerid] = 0;
		ResetPlayerWeapons(killerid);LSpawnPlayer(killerid);
		SendClientMessage(killerid,COLOR_RED,"Вы были выброшены из Зомби-Выживания за убийство игрока своей команды");
		GangZoneHideForPlayer(killerid,ZMZone1);GangZoneHideForPlayer(killerid,ZMZone2);GangZoneHideForPlayer(killerid,ZMZone3);GangZoneHideForPlayer(killerid,ZMZone4);GangZoneHideForPlayer(killerid,ZMZone5);
		GangZoneHideForPlayer(killerid,ZMZone6);GangZoneHideForPlayer(killerid,ZMZone7);GangZoneHideForPlayer(killerid,ZMZone8);GangZoneHideForPlayer(killerid,ZMZone9);GangZoneHideForPlayer(killerid,ZMZone10);
	}//тимкилл на Зомби-Выживании
	if (InEvent[killerid] == EVENT_GUNGAME && InEvent[playerid] == EVENT_GUNGAME)
	{//убийство игрока в gg
	    new String[140], BonusXP, BonusCash;
		GGKills[killerid]++; GiveGGWeapon(killerid);
		format(String, sizeof String, "~Y~KILLS: ~W~%d", GGKills[killerid]);
		GameTextForPlayer(killerid, String, 3000, 6);
		QuestUpdate(killerid, 4, 1);//Обновление квеста 15 убийств в гонке вооружений
		if (GGKills[killerid] == 15)
		{//убийца победил. Конец GunGame
		    format(String,sizeof(String),"%s[%d] победил в гонке вооружений и получил 800 XP и 25 000$",PlayerName[killerid], killerid);
			SendClientMessageToAll(COLOR_GG,String);
		    foreach(Player, did)
			{//цикл
				if(JoinEvent[did] == EVENT_GUNGAME)
				{
					InEvent[did] = 0; JoinEvent[did] = 0;
					if (GGKills[did] >= 15) {BonusXP = 800; BonusCash = 25000;}
					else {BonusXP = 80 + GGKills[did] * 40; BonusCash = GGKills[did] * 1000;}
					format(String,sizeof(String),"Вы получили %d ХР и %d$ за участие в Гонке Вооружений (Убийств: %d).", BonusXP, BonusCash, GGKills[did]);
					SendClientMessage(did,COLOR_YELLOW,String); LSpawnPlayer(did);
					LGiveXP(did, BonusXP); Player[did][Cash] += BonusCash;
					QuestUpdate(did, 17, 1);//Обновление квеста Примите участие в 3 гонках вооружений
					QuestUpdate(did, 18, 1);//Обновление квеста Примите участие в 5 соревнованиях
				}
			}//цикл
			GGTimeToEnd = -1;
		}//убийца победил. Конец GunGame
		return 1;
	}//убийство игрока в gg
	
	if (Player[killerid][MyClan] != 0 && Player[killerid][MyClan] == Player[playerid][MyClan]) return 1; //Убийство соклановца
	if (InEvent[playerid] > 0 || InEvent[killerid] > 0) return 1;
	QuestUpdate(killerid, 5, 1);//Обновление квеста 5 убийств за пределами соревнований

	//Понижение кармы
    new clanid = Player[playerid][MyClan], killerclanid = Player[killerid][MyClan], ChangeCarma = 1;
	if (clanid > 0 && clanid == killerclanid) return 1; //При убийстве соклана не теряются деньги и карма
	if (clanid > 0 && killerclanid > 0  && (Clan[clanid][cEnemyClan] == killerclanid || Clan[killerclanid][cEnemyClan] == clanid)) ChangeCarma = 0; //на войне карму не сливать
   	if (ChangeCarma == 1)
	{//Если надо сливать карму
	    Player[killerid][Karma] -= 15; Player[killerid][KarmaTime] = 0; //Сброс таймера до повышения кармы
		SendClientMessage(killerid,COLOR_RED,"Вы потеряли 15 очков кармы! Зачем нужна карма смотри в {FFFFFF}/karma");
		if (Player[killerid][Karma] <= -400 && Player[killerid][Invisible] > 0) {Player[killerid][Invisible] = 0; SendClientMessage(killerid,COLOR_RED,"Невидимость была отключена из-за слишком низкой кармы.");}
	}//Если надо сливать карму

	//передача денег
	if (Player[playerid][Cash] <= 0 || Player[playerid][Banned] != 0) return 1;
	if (InEvent[playerid] > 0) return 1;
	new GrabMoney, SaveMoney = 0, String[180];
	GrabMoney = Player[playerid][Cash] / 2;//Из игрока выпадает 50% от денег, остальная сумма сгорает
	if (Player[playerid][GPremium] >= 13) SaveMoney = Player[playerid][Cash] / 4;//25% денег не сгорает (нужен vip 13)
	format(String, sizeof String, "Вы потеряли %d$ за смерть от рук другого игрока!", Player[playerid][Cash] - SaveMoney);
	SendClientMessage(playerid, COLOR_RED, String);
	if (Player[playerid][Bank] == 0) SendClientMessage(playerid,COLOR_YELLOW,"Храните деньги в банке... Найти его можно через {FFFFFF}/gps");
	Player[playerid][Cash] = 0 + SaveMoney;

	if (GrabMoney > 0)
	{
	    new Float: DeathPosX, Float: DeathPosY, Float: DeathPosZ; GetPlayerPos(playerid, DeathPosX, DeathPosY, DeathPosZ);
		new CashPickup = CreateDynamicPickup(1550, 1, DeathPosX, DeathPosY, DeathPosZ, GetPlayerVirtualWorld(playerid), -1, -1, 300.0);
		DynamicPickup[CashPickup][Type] = 3;//тип пикапа - деньги
		DynamicPickup[CashPickup][ID] = GrabMoney;//сумма денег
		DynamicPickup[CashPickup][DestroyTimerID] = SetTimerEx("DestroyCashPickup" , 60 * 1000, false, "i", CashPickup);

		format(String, sizeof String, "{FFFF00}SERVER: Из убитого вами игрока {FFFFFF}%s{FFFF00}[{FFFFFF}%d{FFFF00}] выпали деньги! Подберите их!", PlayerName[playerid], playerid);
		SendClientMessage(killerid, COLOR_YELLOW, String);
		format(String, sizeof String, "%d.%d.%d в %d:%d:%d |   CASH: %s[%d] убил игрока %s[%d]. Из него выпало %d$", Day, Month, Year, hour, minute, second, PlayerName[killerid], killerid, PlayerName[playerid], playerid, GrabMoney);
		WriteLog("GlobalLog", String); WriteLog("CashOperations", String);
	}
	
	return 1;
}//Смерть от рук игрока (синхронизация от killerid)

public OnVehicleSpawn(vehicleid)
{
	if (vehicleid > MaxVehicleUsed) MaxVehicleUsed = vehicleid;//используется в циклах вместо MAX_VEHICLES
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	DestroyVehicle(vehicleid);
	return 1;
}


public OnPlayerText(playerid, text[])
{
	//Если начал вводить команду не с '/', а с '.' (русская раскладка) - переводим в команды
	if (text[0] == '.' || text[0] == '/') {text[0] = '/'; OnPlayerCommandText(playerid, text); return 0;}

	if (Logged[playerid] == 0){SendClientMessage(playerid,COLOR_RED, "Ошибка: Чтобы писать в чат нужно авторизироваться");return 0;}
	else if (Player[playerid][Muted] != 0)
	{//мута
	    if (Player[playerid][Muted] == -1) SendClientMessage(playerid,COLOR_RED,"Вам запрещено писать в чат");
	    else
	    {
		    new StringM[100], hourM;
		    if (Player[playerid][Muted] >= 60){hourM = Player[playerid][Muted] / 60;format(StringM,sizeof(StringM),"Вам запрещено писать в чат еще %d минут %d секунд", hourM, Player[playerid][Muted] - hourM * 60);}
		    else{format(StringM,sizeof(StringM),"Вам запрещено писать в чат еще %d секунд", Player[playerid][Muted]);}
		    SendClientMessage(playerid,COLOR_RED,StringM);
	    }
	    return 0;
	}//мута

	new Name[30];GetPlayerName(playerid, Name, MAX_PLAYER_NAME);
	new itext[300], Need60Sec = 0, NeedMute = 0;strcat(itext,text);

	//--- Цифры в тексте
	new count, AntiCaps = 0;
	for (new i; i < strlen(itext); i++)
	{
	    if (itext[i] >= '0' && itext[i] <= '9')
	    {
	        count++;
	        if(count > 5) {SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Сообщение не должно содержать больше 5 цифр!"); return 0;}
	    }

	    //AntiCapsLock
	    if (itext[i] > 64 && itext[i] < 91 && AntiCaps == 0) AntiCaps = 1; //eng
	    if (itext[i] > 191 && itext[i] < 224 && AntiCaps == 0) AntiCaps = 1;//rus
	    if(itext[i] == 168 && AntiCaps == 0) AntiCaps = 1;//Ё
	    if (itext[i] == ':' && itext[i++] == 'D') AntiCaps = 0;//Спасение смайла ':D'
	    //Предыдущие три проверки проверяют, что символ в верхнем регистре
	    if (AntiCaps == 1)
	    {//Если символ в верхнем регистре
	        if (itext[i++] > 64 && itext[i++] < 91) AntiCaps = 2; //Если два символа подряд в верхнем регистре eng
		    if (itext[i] > 191 && itext[i] < 224) AntiCaps = 2; //Если два символа подряд в верхнем регистре rus
		    if(itext[i++] == 168) AntiCaps = 184; //Если два символа подряд в верхнем регистре Ё
		    if (AntiCaps == 1) AntiCaps = 0;//Если второй символ был маленьким (например "Текст")
	    }//Если символ в верхнем регистре
	}//--- Цифры в тексте

	if (AntiCaps == 2)
	{//Если два символа подряд были написаны в верхнем регистре
	    for (new i; i < strlen(itext); i++)
		{
			if (itext[i] > 64 && itext[i] < 91) itext[i] += 32; //eng
			if (itext[i] > 191 && itext[i] < 224) itext[i] += 32;//rus
			if(itext[i] == 168) itext[i] = 184;//Ё
		}
	}//Если два символа подряд были написаны в верхнем регистре

	//--- Защита от флуда
	if (FloodTime[playerid] == 0) {FloodTime[playerid] = 15; FloodMessages[playerid] = 1;}
	else FloodMessages[playerid] += 1;
	if (FloodMessages[playerid] >= 3 && FloodTime[playerid] > 12) NeedMute = 1; //3 сообщения или более за 3 секунды
	else if (FloodMessages[playerid] >= 4 && FloodTime[playerid] > 7) NeedMute = 1; //4 сообщения или более за 8 секунд
	else if (FloodMessages[playerid] >= 5 && FloodTime[playerid] > 3) NeedMute = 1; //5 сообщений или более за 12 секунд
	else if (FloodMessages[playerid] >= 6) NeedMute = 1; //6 сообщений или более за 15 секунд
	//--- Защита от флуда

	if(strfind(text, "!", true) == 0)
	{//клану
		if (Player[playerid][Member] == 0){SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вы не в клане."); return 0;}
		strdel(text, 0, 1);new stext[300],clanid = Player[playerid][MyClan], ccolor = Clan[clanid][cColor];
		format(stext, 300, "! [КЛАНУ]%s[%d]:{FFFFFF} %s", Name, playerid, text);
		foreach(Player, cid) if (Player[cid][MyClan] == Player[playerid][MyClan] && Logged[cid] == 1){SendClientMessage(cid, ClanColor[ccolor], stext);}
		if (NeedMute == 1)
		{//надо выдать мут за флуд
		    Player[playerid][Muted] = 1200; strmid(MutedBy[playerid], "SERVER", 0, 25, 25);
			FloodTime[playerid] = 0;FloodMessages[playerid] = 0;
		    new String[140];
			format(String,sizeof(String), "{AFAFAF}SERVER %s был автоматически заткнут на 20 минут. Причина: Флуд", PlayerName[playerid]);
			SendClientMessageToAll(COLOR_GREY,String);
		}//надо выдать мут за флуд
		//Запись в лог. Например WriteLog("Файл", "Привет Мир!"); запишет в лог "Файл.ini" фразу "Привет Мир!"
        format(text, 300, "%d.%d.%d в %d:%d:%d |   [КЛАНУ]%s[%d]: %s", Day, Month, Year, hour, minute, second, Name, playerid, text);WriteLog("GlobalLog", text);
		return 0;
	}//клану

	if(strfind(text, "#", true) == 0 || strfind(text, "№", true) == 0)
	{//шепот
	    if (LSpecID[playerid] != -1 && Player[playerid][Admin] < 1){SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Только модераторы и выше могут писать шепотом в режиме слежки."); return 0;}
		new Float: sx, Float: sy, Float: sz;strdel(text, 0, 1);
		new stext[300];format(stext, 300, "{B5BBFD}# [ШЕПОТОМ]%s[{FFFFFF}%d{B5BBFD}]: {FFFFFF}%s", Name, playerid, text);
		GetPlayerPos(playerid,sx,sy,sz);
		foreach(Player, cid) if (PlayerToPoint(50.0, cid, sx, sy, sz) && GetPlayerVirtualWorld(cid) == GetPlayerVirtualWorld(playerid)) SendClientMessage(cid, -1, stext);
        if (NeedMute == 1)
		{//надо выдать мут за флуд
		    Player[playerid][Muted] = 1200;FloodTime[playerid] = 0;FloodMessages[playerid] = 0;
		    new CheaterName[30], String[140];CheaterName = GetName(playerid);
			format(String,sizeof(String), "{AFAFAF}SERVER %s был автоматически заткнут на 20 минут. Причина: Флуд",CheaterName);
			SendClientMessageToAll(COLOR_GREY,String); strmid(MutedBy[playerid], "SERVER", 0, 25, 25);
		}//надо выдать мут за флуд
		//Запись в лог. Например WriteLog("Файл", "Привет Мир!"); запишет в лог "Файл.ini" фразу "Привет Мир!"
        format(text, 300, "%d.%d.%d в %d:%d:%d |   [ШЕПОТОМ]%s[%d]: %s", Day, Month, Year, hour, minute, second, Name, playerid, text);WriteLog("GlobalLog", text);
		return 0;
	}//шепот
	
	if(strfind(text, "@", true) == 0 || text[0] == 34)
	{//админам
		strdel(text, 0, 1);new stext[300];format(stext, 300, "{00BFFF}@ [АДМИНАМ]%s[{FFFFFF}%d{00BFFF}]: {FFFFFF}%s", Name, playerid, text);
		if (Player[playerid][Admin] == 0){SendClientMessage(playerid,COLOR_ADMIN,"Ваше сообщение отправлено администраторам");}
		foreach(Player, cid) if (Player[cid][Admin] != 0 && Logged[cid] == 1){SendClientMessage(cid, -1, stext);}
        if (NeedMute == 1)
		{//надо выдать мут за флуд
		    Player[playerid][Muted] = 1200;FloodTime[playerid] = 0;FloodMessages[playerid] = 0;
		    new CheaterName[30], String[140];CheaterName = GetName(playerid);
			format(String,sizeof(String), "{AFAFAF}SERVER %s был автоматически заткнут на 20 минут. Причина: Флуд",CheaterName);
			SendClientMessageToAll(COLOR_GREY,String); strmid(MutedBy[playerid], "SERVER", 0, 25, 25);
		}//надо выдать мут за флуд
		//Запись в лог. Например WriteLog("Файл", "Привет Мир!"); запишет в лог "Файл.ini" фразу "Привет Мир!"
        format(text, 300, "%d.%d.%d в %d:%d:%d |   [АДМИНАМ]%s[%d]: %s", Day, Month, Year, hour, minute, second, Name, playerid, text);WriteLog("GlobalLog", text);
		return 0;
	}//админам

	if (Player[playerid][GPremium] >= 2)
	{//--- Разноцветный чат
		for(new i = 0; i < 300; i++)
		{//цикл
			if(strfind(itext, "*", true) == i)
			{//Если нашло "*" в тексте
				if (PremiumTime[playerid] > 0)
				{
						new string[120];
						format(string, sizeof(string), "{FF0000}Разноцветное сообщение будет доступно через {FFFFFF}%d{FF0000} секунд.", PremiumTime[playerid]);
						SendClientMessage(playerid,COLOR_RED,string); break;
				}
				if (Player[playerid][Admin] < 4) Need60Sec = 1;

			    if (strfind(itext, "1", true) == i + 1)
			    {// *1 - красный
					strdel(itext, i, i + 2);//удаляется код цвета
					strins(itext, "{FF0000}", i, 300);continue;
			    }// *1 - красный
			    if (strfind(itext, "2", true) == i + 1)
			    {// *2 - синий
					strdel(itext, i, i + 2);//удаляется код цвета
					strins(itext, "{3399FF}", i, 300);continue;
			    }// *2 - синий
			    if (strfind(itext, "3", true) == i + 1)
			    {// *3 - зеленый
					strdel(itext, i, i + 2);//удаляется код цвета
					strins(itext, "{00FF00}", i, 300);continue;
			    }// *3 - зеленый
			    if (strfind(itext, "4", true) == i + 1)
			    {// *4 - желтый
					strdel(itext, i, i + 2);//удаляется код цвета
					strins(itext, "{FFFF00}", i, 300);continue;
			    }// *4 - желтый
			    if (strfind(itext, "5", true) == i + 1)
			    {// *5 - киви
					strdel(itext, i, i + 2);//удаляется код цвета
					strins(itext, "{CCFF00}", i, 300);continue;
			    }// *5 - киви
			    if (strfind(itext, "6", true) == i + 1)
			    {// *6 - аква
					strdel(itext, i, i + 2);//удаляется код цвета
					strins(itext, "{24F7FE}", i, 300);continue;
			    }// *6 - аква
			    if (strfind(itext, "7", true) == i + 1)
			    {// *7 - розовый
					strdel(itext, i, i + 2);//удаляется код цвета
					strins(itext, "{F935F9}", i, 300);continue;
			    }// *7 - розовый
			    if (strfind(itext, "8", true) == i + 1)
			    {// *8 - квест
					strdel(itext, i, i + 2);//удаляется код цвета
					strins(itext, "{FFCC00}", i, 300);continue;
			    }// *8 - квест
			    if (strfind(itext, "9", true) == i + 1)
			    {// *9 - коричневый
					strdel(itext, i, i + 2);//удаляется код цвета
					strins(itext, "{976D3D}", i, 300);continue;
			    }// *9 - коричневый

				if (strfind(itext, "!", true) == i + 1 && strfind(itext, "1", true) == i + 2)
			    {// **1 - дм
					strdel(itext, i, i + 3);//удаляется код цвета
					strins(itext, "{FF8C00}", i, 300);continue;
			    }// **1 - дм, тдм
			    if (strfind(itext, "!", true) == i + 1 && strfind(itext, "2", true) == i + 2)
			    {// **2 - дерби
					strdel(itext, i, i + 3);//удаляется код цвета
					strins(itext, "{9966CC}", i, 300);continue;
			    }// **2 - дерби
			    if (strfind(itext, "!", true) == i + 1 && strfind(itext, "3", true) == i + 2)
			    {// **3 - зомби
					strdel(itext, i, i + 3);//удаляется код цвета
					strins(itext, "{E60020}", i, 300);continue;
			    }// **3 - зомби
			    if (strfind(itext, "!", true) == i + 1 && strfind(itext, "4", true) == i + 2)
			    {// **4 - гонка
					strdel(itext, i, i + 3);//удаляется код цвета
					strins(itext, "{007FFF}", i, 300);continue;
			    }// **4 - гонка
			    if (strfind(itext, "!", true) == i + 1 && strfind(itext, "5", true) == i + 2)
			    {// **5 - легендарная гонка
					strdel(itext, i, i + 3);//удаляется код цвета
					strins(itext, "{FFD700}", i, 300);continue;
			    }// **5 - легендарная гонка
			    if (strfind(itext, "!", true) == i + 1 && strfind(itext, "6", true) == i + 2)
			    {// **6 - гангейм
					strdel(itext, i, i + 3);//удаляется код цвета
					strins(itext, "{FF6666}", i, 300);continue;
			    }// **6 - гангейм

			    if (strfind(itext, "?", true) == i + 1 || strfind(itext, "&", true) == i + 1)
			    {// *? - случайный
					strdel(itext, i, i + 2);//удаляется код цвета
					new rand = random(14) + 1;
					if (rand == 1) strins(itext, "{FF0000}", i, 300);
					if (rand == 2) strins(itext, "{3399FF}", i, 300);
					if (rand == 3) strins(itext, "{00FF00}", i, 300);
					if (rand == 4) strins(itext, "{FFFF00}", i, 300);
					if (rand == 5) strins(itext, "{CCFF00}", i, 300);
					if (rand == 6) strins(itext, "{24F7FE}", i, 300);
					if (rand == 7) strins(itext, "{F935F9}", i, 300);
					if (rand == 8) strins(itext, "{FFCC00}", i, 300);
					if (rand == 9) strins(itext, "{976D3D}", i, 300);
					if (rand == 10) strins(itext, "{FFFFFF}", i, 300);
					if (rand == 11) strins(itext, "{FF8C00}", i, 300);
					if (rand == 12) strins(itext, "{9966CC}", i, 300);
					if (rand == 13) strins(itext, "{FF6666}", i, 300);
					if (rand == 14) strins(itext, "{007FFF}", i, 300);
					continue;
			    }// *? - случайный

				//Если не был введен ни один из кодов выше (просто * с текстом)
				strdel(itext, i, i + 1);//удаляется код цвета
				strins(itext, "{FFFFFF}", i, 300);//белый
			}//Если нашло "*" в тексте
		}//цикл
	}//--- Разноцветный чат
	
	format(itext, 300, "%s{FFFFFF}[%d]: %s", ChatName[playerid], playerid, itext);
	new colorid = PlayerColor[playerid], clanid = Player[playerid][MyClan];
	if (clanid < 1 || Clan[clanid][cBase] < 1) colorid = 0; //Если игрок не в клане или если у клана нет штаба - цвет ника будет серым
	SendClientMessageToAll(ClanColor[colorid], itext);
	
	if (Need60Sec == 1){PremiumTime[playerid] = 60;Need60Sec = 0;}
	if (NeedMute == 1)
	{//надо выдать мут за флуд
	    Player[playerid][Muted] = 1200;FloodTime[playerid] = 0;FloodMessages[playerid] = 0;
	    new CheaterName[30], String[140];CheaterName = GetName(playerid);
		format(String,sizeof(String), "{AFAFAF}SERVER %s был автоматически заткнут на 20 минут. Причина: Флуд",CheaterName);
		SendClientMessageToAll(COLOR_GREY,String); strmid(MutedBy[playerid], "SERVER", 0, 25, 25); return 0;
	}//надо выдать мут за флуд
	//Запись в лог. Например WriteLog("Файл", "Привет Мир!"); запишет в лог "Файл.ini" фразу "Привет Мир!"
	format(text, 300, "%d.%d.%d в %d:%d:%d |   %s[%d]: %s", Day, Month, Year, hour, minute, second, Name, playerid, text);WriteLog("GlobalLog", text);
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    if (OnFly[playerid] == 1) StopFly(playerid);
    
    if (ispassenger == 0)
    {//Садится на водительское сидение
        foreach(Player, cid)
        {
            if (IsPlayerInVehicle(cid, vehicleid) && GetPlayerVehicleSeat(cid) == 0)
            {//кто-то уже сидит за рулем
                SetVehicleParamsForPlayer(vehicleid, playerid, 0, 1);SetVehicleParamsForPlayer(vehicleid, cid, 0, 1);
				SetTimerEx("UnLock" , 5000, false, "dd", playerid,vehicleid);SetTimerEx("UnLock" , 5000, false, "dd", cid,vehicleid);
				SendClientMessage(playerid,COLOR_RED,"Нельзя отбирать транспорт у других игроков! Нажмите {FFFFFF}Alt{FF0000} чтобы вызвать свой!");
            }//кто-то уже сидит за рулем
        }
    }//Садится на водительское сидение
    
    for(new vid = 1; vid <= 35; vid++)
	{//угон авто - наземный транспорт
	    if (vehicleid == StealCar[vid])
	    {//если игрок оказался в авто, которое надо угнать
	        StealCarModel[playerid] = GetVehicleModel(vehicleid);
	        if (vid <= 25)
	        {//Наземные авто
				new qcol1, qcol2, qmodel = GetVehicleModel(StealCar[vid]);GetVehicleColor(StealCar[vid],qcol1,qcol2);
				new Float: qx, Float: qy, Float: qz, Float: qa;GetVehiclePos(StealCar[vid],qx,qy,qz);GetVehicleZAngle(StealCar[vid], qa);
				DestroyVehicle(StealCar[vid]);DestroyDynamicMapIcon(StealCarMapIcon[vid]);

				//пересоздание того авто в другом месте
				new rrand1 = random(sizeof(CarStealSpawns)), rcol1 = random(256), rcol2 = random(256), rmodeld = random(133); new rmodel = StealCars[rmodeld];
				StealCar[vid] = LCreateVehicle(rmodel, CarStealSpawns[rrand1][0], CarStealSpawns[rrand1][1], CarStealSpawns[rrand1][2], CarStealSpawns[rrand1][3], rcol1, rcol2, 0);
	  		 	StealCarMapIcon[vid] = CreateDynamicMapIcon(CarStealSpawns[rrand1][0], CarStealSpawns[rrand1][1], CarStealSpawns[rrand1][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);

				//Авто для игрока для выполнения задания
				if (QuestActive[playerid] > 0) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Нельзя угонять транспорт во время выполнения работы!");
				QuestCar[playerid] = LCreateVehicle(qmodel, qx, qy, qz, qa, qcol1, qcol2, 0);
				PutPlayerInVehicle(playerid, QuestCar[playerid], 0); PlayerCarID[playerid] = -1;

		        new modelid = qmodel - 400, String[120];
				format(String,sizeof(String),"{AFAFAF}Транспорт: {FFCC00}%s{AFAFAF} Стоимость: %d$",PlayerVehicleName[modelid], GetVehicleMaxSpeed(QuestCar[playerid]) * 500);
		        ShowPlayerDialog(playerid, DIALOG_STEALCAR, 2, String, "{FFCC00}Угнать транспорт{FFFFFF}\nСделать личным транспортом {007FFF}1{FFFFFF}-го класса\nСделать личным транспортом {007FFF}2{FFFFFF}-го класса\n{FF0000}Покинуть транспорт", "Начать", "Отмена");
			}//Наземные авто
			else if (vid <= 30)
			{//Водные авто
			    new qcol1, qcol2, qmodel = GetVehicleModel(StealCar[vid]);GetVehicleColor(StealCar[vid],qcol1,qcol2);
				new Float: qx, Float: qy, Float: qz, Float: qa;GetVehiclePos(StealCar[vid],qx,qy,qz);GetVehicleZAngle(StealCar[vid], qa);
				DestroyVehicle(StealCar[vid]);DestroyDynamicMapIcon(StealCarMapIcon[vid]);

				//пересоздание того авто в другом месте
				new rrand1 = random(sizeof(CarStealWaterSpawns)), rcol1 = random(256), rcol2 = random(256), rmodeld = random(11); new rmodel = StealWaterCars[rmodeld];
				StealCar[vid] = LCreateVehicle(rmodel, CarStealWaterSpawns[rrand1][0], CarStealWaterSpawns[rrand1][1], CarStealWaterSpawns[rrand1][2], CarStealWaterSpawns[rrand1][3], rcol1, rcol2, 0);
	  		 	StealCarMapIcon[vid] = CreateDynamicMapIcon(CarStealWaterSpawns[rrand1][0], CarStealWaterSpawns[rrand1][1], CarStealWaterSpawns[rrand1][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);

				//Авто для игрока для выполнения задания
				if (QuestActive[playerid] > 0) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Нельзя угонять транспорт во время выполнения работы!");
				QuestCar[playerid] = LCreateVehicle(qmodel, qx, qy, qz, qa, qcol1, qcol2, 0);
				PutPlayerInVehicle(playerid, QuestCar[playerid], 0); PlayerCarID[playerid] = -1;

		        new modelid = qmodel - 400, String[120];
				format(String,sizeof(String),"{AFAFAF}Транспорт: {FFCC00}%s{AFAFAF} Стоимость: %d$",PlayerVehicleName[modelid], GetVehicleMaxSpeed(QuestCar[playerid]) * 500);
		        ShowPlayerDialog(playerid, DIALOG_STEALWATERCAR, 2, String, "{FFCC00}Угнать транспорт{FFFFFF}\nСделать личным транспортом {007FFF}3{FFFFFF}-го класса\n{FF0000}Покинуть транспорт", "Начать", "Отмена");
			}//Водные авто
			else if (vid <= 35)
			{//Воздушное авто
			    new qcol1, qcol2, qmodel = GetVehicleModel(StealCar[vid]);GetVehicleColor(StealCar[vid],qcol1,qcol2);
				new Float: qx, Float: qy, Float: qz, Float: qa;GetVehiclePos(StealCar[vid],qx,qy,qz);GetVehicleZAngle(StealCar[vid], qa);
				DestroyVehicle(StealCar[vid]);DestroyDynamicMapIcon(StealCarMapIcon[vid]);

				//пересоздание того авто в другом месте
				new rrand1 = random(sizeof(CarStealAirSpawns)), rcol1 = random(256), rcol2 = random(256), rmodeld = random(13); new rmodel = StealAirCars[rmodeld];
				StealCar[vid] = LCreateVehicle(rmodel, CarStealAirSpawns[rrand1][0], CarStealAirSpawns[rrand1][1], CarStealAirSpawns[rrand1][2], CarStealAirSpawns[rrand1][3], rcol1, rcol2, 0);
	  		 	StealCarMapIcon[vid] = CreateDynamicMapIcon(CarStealAirSpawns[rrand1][0], CarStealAirSpawns[rrand1][1], CarStealAirSpawns[rrand1][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);

				//Авто для игрока для выполнения задания
				if (QuestActive[playerid] > 0) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Нельзя угонять транспорт во время выполнения работы!");
				QuestCar[playerid] = LCreateVehicle(qmodel, qx, qy, qz, qa, qcol1, qcol2, 0);
				PutPlayerInVehicle(playerid, QuestCar[playerid], 0); PlayerCarID[playerid] = -1;

		        new modelid = qmodel - 400, String[120];
				format(String,sizeof(String),"{AFAFAF}Транспорт: {FFCC00}%s{AFAFAF} Стоимость: %d$",PlayerVehicleName[modelid], GetVehicleMaxSpeed(QuestCar[playerid]) * 2000);
		        ShowPlayerDialog(playerid, DIALOG_STEALAIRCAR, 2, String, "{FFCC00}Угнать транспорт{FFFFFF}\nСделать личным транспортом {007FFF}3{FFFFFF}-го класса\n{FF0000}Покинуть транспорт", "Начать", "Отмена");
			}//Воздушное авто
		}//если игрок оказался в авто, которое надо угнать
	}//угон авто - наземный транспорт
    
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
    if (Player[playerid][Level] == 0)
	{//Игрок вышел из машины в режиме обучения.
	    if (TutorialObject[playerid] != -1){DestroyObject(TutorialObject[playerid]);TutorialObject[playerid] = -1;}
	    TutorialObject[playerid] = CreateObject(19482, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    	SetObjectMaterialText(TutorialObject[playerid], "{FFFF00}Обучение\n{FFFFFF}Нажмите {00FF00}Alt", 0, OBJECT_MATERIAL_SIZE_512x512, "Tahoma", 50, 1, 0xFFFFFFFF, 0x00, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
        AttachObjectToPlayer(TutorialObject[playerid], playerid, 0, 0, 1.2, 0, 0, 270);
	}//Игрок вышел из машины в режиме обучения.
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    if ((oldstate != 1 && newstate == 1) && (JoinEvent[playerid] == EVENT_RACE || JoinEvent[playerid] == EVENT_XRACE)) return SendClientMessage(playerid,COLOR_CYAN,"Подсказка: Нажмите клавишу {FFFFFF}Alt{00CCCC} чтобы вызвать транспорт в гонке.");
	if (LSpectators[playerid] > 0) {SpecUpdate(playerid);}//обновление спектра у тех, кто за игроком следил
    if (oldstate == PLAYER_STATE_DRIVER) Player[playerid][CarActive] = 0; //Исправляет возможность использования навыков после выхода из своего авто
 
	if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
    {//делает возможным пользоваться только смг, находясь в транспорте
        new Weap[2];
        GetPlayerWeaponData(playerid, 4, Weap[0], Weap[1]); // Get the players SMG weapon in slot 4
        SetPlayerArmedWeapon(playerid, Weap[0]); // Set the player to driveby with SMG
        SetTimerEx("SpeedoUpdate" , 500, false, "i", playerid);//включает спидометр
    }//делает возможным пользоваться только смг, находясь в транспорте
    
	if ((newstate == 0) && Player[playerid][Level] == 0)
	{//Игрок вышел из машины в режиме обучения.
	    if (TutorialObject[playerid] != -1){DestroyObject(TutorialObject[playerid]);TutorialObject[playerid] = -1;}
	    TutorialObject[playerid] = CreateObject(19482, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    	SetObjectMaterialText(TutorialObject[playerid], "{FFFF00}Обучение\n{FFFFFF}Нажмите {00FF00}Alt", 0, OBJECT_MATERIAL_SIZE_512x512, "Tahoma", 50, 1, 0xFFFFFFFF, 0x00, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
        AttachObjectToPlayer(TutorialObject[playerid], playerid, 0, 0, 1.2, 0, 0, 270);
	}//Игрок вышел из машины в режиме обучения.

	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	if (GPSUsed[playerid] == 1)
	{//GPS чекпоинт
	    DisablePlayerCheckpoint(playerid); GPSUsed[playerid] = 0; PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
	    return SendClientMessage(playerid, COLOR_RED, "GPS:{FFFF00} Вы достигли места назначения.");
	}//GPS чекпоинт

	if (FRTimer <= -1 && FRStarted[playerid] == 1)
	{//чекпоинт финиша гонки
		new String[140];FarmedXP[playerid] = 200 + 35 * (FRPlayers-1); FarmedMoney[playerid] = 2500 + 500 * (FRPlayers-1);FRpos += 1;
		if (FRpos == 1){FarmedXP[playerid] += 200;format(String,sizeof(String),"%s[%d] выиграл гонку и получил %d XP и %d$",PlayerName[playerid],playerid,FarmedXP[playerid],FarmedMoney[playerid]);SendClientMessageToAll(COLOR_RACE,String);}
		if (FRpos == 2){FarmedXP[playerid] += 130;format(String,sizeof(String),"%s[%d] финишировал вторым в гонке и получил %d XP и %d$",PlayerName[playerid],playerid,FarmedXP[playerid],FarmedMoney[playerid]);SendClientMessageToAll(COLOR_RACE,String);}
		if (FRpos == 3){FarmedXP[playerid] += 65;format(String,sizeof(String),"%s[%d] финишировал третьим в гонке и получил %d XP и %d$",PlayerName[playerid],playerid,FarmedXP[playerid],FarmedMoney[playerid]);SendClientMessageToAll(COLOR_RACE,String);}
		if (FRpos > 3)
		{
			//FarmedXP[playerid] = 200; FarmedMoney[playerid] = 2500;
			format(String,sizeof(String),"Вы финишировали %d-ым и получили %d XP и %d$",FRpos,FarmedXP[playerid],FarmedMoney[playerid]);SendClientMessage(playerid,COLOR_RACE,String);
		}
		FRPlayers -= 1;Player[playerid][Cash] += FarmedMoney[playerid]; LGiveXP(playerid, FarmedXP[playerid]);
		FRStarted[playerid] = 0; JoinEvent[playerid] = 0; InEvent[playerid] = 0;
		DestroyVehicle(FRCarID[playerid]); FRCarID[playerid] = 0;
		SetPlayerVirtualWorld(playerid,0);DisablePlayerCheckpoint(playerid);LSpawnPlayer(playerid);
		PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
		QuestUpdate(playerid, 14, 1);//Обновление квеста Примите участие в 3 гонках
		QuestUpdate(playerid, 18, 1);//Обновление квеста Примите участие в 3 соревнованиях
		return 1;
	}//чекпоинт финиша гонки
	
	if (QuestActive[playerid] == 3 && InEvent[playerid] == 0)
	{//Грузчик
		if(GetPVarInt(playerid,"WorkStage") == 1)// Если момент работы игрока 1..
	    {//взл груз
	    	new checku = random(sizeof GRUZTO);// Рандомно выдаём координаты куда нести груз
	        SetPlayerCheckpoint(playerid,GRUZTO[checku][0],GRUZTO[checku][1],GRUZTO[checku][2],1.5);// Создаём один из чекпоинтов
	        ApplyAnimation(playerid,"CARRY","crry_prtial",4.1,0,1,1,1,1);// Анимация, типо что то несём..
	        SetPVarInt(playerid,"WorkStage",2);// Устанавливаем момент работы игрока на 2..
	        new objectr = random(3);// Выдаём в руки объект
	        if(objectr == 0) return SetPlayerAttachedObject(playerid,0,1221,1,0.135011,0.463495,-0.024351,357.460632,87.350753,88.068374,0.434164,0.491270,0.368655);
	        if(objectr == 1) return SetPlayerAttachedObject(playerid,0,2226,1,0.000708,0.356461,0.000000,186.670364,87.529838,0.000000,1.000000,1.000000,1.000000);
	        if(objectr == 2) return SetPlayerAttachedObject(playerid,0,1750,1,0.013829,0.131155,0.145773,185.651550,86.201354,345.922180,0.693442,0.873942,0.577291);
	    }//взл груз
	    if(GetPVarInt(playerid,"WorkStage") == 2)
	    {//отдал груз
	        new checkp = random(sizeof GRUZFROM); WorkTimeGruz[playerid] = 0;
	        SetPlayerCheckpoint(playerid,GRUZFROM[checkp][0],GRUZFROM[checkp][1],GRUZFROM[checkp][2],1.5);// Создаём один из чекпоинтов
	        RemovePlayerAttachedObject(playerid,0);// Удаляем объект из рук
	        ApplyAnimation(playerid,"PED","IDLE_tired",4.1,0,1,1,0,1);// Обнуляем анимацию
	        SetPVarInt(playerid,"WorkStage",1);// Устанавливаем момент работы игрока на 1..
	        SetPVarInt(playerid,"WorkCount",GetPVarInt(playerid,"WorkCount")+1);// Прибавим к вещам игрока 1
	 		if (GetPVarInt(playerid,"WorkCount") == 10)
	 		{//Перенес 10 грузов
	 		    new str[128], wxp = WorkTime[playerid] * 3/4, wcash = WorkTime[playerid] * 30;
	 		    SetPVarInt(playerid,"WorkCount", 0); WorkTime[playerid] = 0;
		        format(str,sizeof(str),"Работа: Вы получили %d XP и %d$ за перенос 10 грузов.", wxp, wcash);
		        SendClientMessage(playerid,COLOR_QUEST, str); LGiveXP(playerid, wxp); Player[playerid][Cash] += wcash;
		        PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
	        }//Перенес 10 грузов
	    }//отдал груз
    }//Грузчик
    
    if (QuestActive[playerid] == 4 && InEvent[playerid] == 0)
    {//Домушник
        if (GetPVarInt(playerid, "WorkDomStage") == 1)
        {//Подошел к дому, который нужно обокрасть
            SetPlayerAttachedObject(playerid,0,3026,1,-0.176000, -0.066000, 0.0000,0.0000, 0.0000, 0.0000, 1.07600, 1.079999, 1.029000);//Рюкзак с краденым
			SetPVarInt(playerid, "WorkDomStage", 2); SetPlayerCheckpoint(playerid, -1945.5354, -1085.3024, 30.8479, 8.0);
			return SendClientMessage(playerid,COLOR_QUEST, "Работа: Ты обчистил дом! Вези награбленное к {FF0000}скупщику{FFCC00}.");
        }//Подошел к дому, который нужно обокрасть
        if (GetPVarInt(playerid, "WorkDomStage") == 2)
        {//Привез товар к скупщику
            RemovePlayerAttachedObject(playerid,0);// Удаляем рюкзак с краденым
            new String[120], wxp, wcash; //Зарплата в час: 2880 xp и 360 000$ => в секунду: 4/5xp и 100$
			if (WorkTime[playerid] <= 720) {wxp = WorkTime[playerid] * 4/5; wcash = WorkTime[playerid] * 100;}
			else {wxp = 576; wcash = 36000;}//Не более 12 минут на один заход. Если больше - выдаем хр за 12 минут и вдвое меньше денег
			format(String, sizeof String, "Работа: Вы получили %d XP и %d$ за сбыт краденых вещей.", wxp, wcash);
			SendClientMessage(playerid, COLOR_QUEST, String); LGiveXP(playerid, wxp); Player[playerid][Cash] += wcash;
			PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
            //Ниже выдаем новый заказ
            new rand = random(MAX_PROPERTY); if (rand == 0) rand++;//Выбираем дом для ограбления
            if (rand == Player[playerid][Home]) {if (rand > 1) rand--; else rand++;}//Выбрался дом грабителя - исправляем
            SetPVarInt(playerid, "WorkDomStage", 1); WorkTime[playerid] = 0;
            if (QuestCar[playerid] != -1) {RepairVehicle(QuestCar[playerid]); SetVehicleZAngle(QuestCar[playerid], 0); SetPlayerChatBubble(playerid, "Транспорт отремонтирован", COLOR_GREEN, 300.0, 3000);}
			SendClientMessage(playerid, COLOR_QUEST, "Работа: Обчисти {FF0000}дом{FFCC00} и привези награбленное сюда!");
            SetPlayerCheckpoint(playerid,Property[rand][pPosEnterX],Property[rand][pPosEnterY],Property[rand][pPosEnterZ],2);
        }//Привез товар к скупщику
    }//Домушник
    
    if (QuestActive[playerid] == 6 && InEvent[playerid] == 0)
    {//Дальнобойщик
        if (GetPVarInt(playerid, "WorkTruckStage") == 1)
        {//Доставил груз
            new vehicleid = GetPlayerVehicleID(playerid);
            if (TrailerID[vehicleid] > -1) {DestroyVehicle(TrailerID[vehicleid]); TrailerID[vehicleid] = -1;}//Убираем трейлер у фуры
			SetPVarInt(playerid, "WorkTruckStage", 2); SetPlayerCheckpoint(playerid, 2453.7183, -2089.3940, 14.5622, 8.0);
			return SendClientMessage(playerid,COLOR_QUEST, "Работа: Ты доставил груз. Возвращайся за {FF0000}зарплатой{FFCC00}.");
        }//Доставил груз
        if (GetPVarInt(playerid, "WorkTruckStage") == 2)
        {//Приехал за зарплатой
            new String[120], wxp, wcash; // 3420xp/час   540 000$/час   19/20хр в секунду   150$ в секунду
			if (WorkTime[playerid] <= 720) {wxp = WorkTime[playerid] * 19/20; wcash = WorkTime[playerid] * 150;}
			else {wxp = 684; wcash = 54000;}//Не более 12 минут на один заход. Если больше - выдаем хр за 12 минут и вдвое меньше денег
			format(String, sizeof String, "Работа: Вы получили %d XP и %d$ за доставку груза.", wxp, wcash);
			SendClientMessage(playerid, COLOR_QUEST, String); LGiveXP(playerid, wxp); Player[playerid][Cash] += wcash;
			PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
            //Ниже выдаем новый заказ
            if (QuestCar[playerid] != -1) {SetVehicleZAngle(QuestCar[playerid], 90); CallTrailer(QuestCar[playerid], 584); RepairVehicle(QuestCar[playerid]); SetPlayerChatBubble(playerid, "Транспорт отремонтирован", COLOR_GREEN, 300.0, 3000);}
            SetPVarInt(playerid, "WorkTruckStage", 1); WorkTime[playerid] = 0;
            new rand = random(sizeof WORKTRUCK);//Выбираем место доставки груза
            SetPlayerCheckpoint(playerid,WORKTRUCK[rand][0], WORKTRUCK[rand][1], WORKTRUCK[rand][2], 10);
			SendClientMessage(playerid, COLOR_QUEST, "Работа: Доставь груз до {FF0000}места назначения{FFCC00} и вернись за зарплатой!");
        }//Приехал за зарплатой
    }//Дальнобойщик
    
    if (QuestActive[playerid] == 7 && InEvent[playerid] == 0)
    {//Капитан Корабля
        if (GetPVarInt(playerid, "WorkWaterStage") == 1)
        {//Доставил груз
 			SetPVarInt(playerid, "WorkWaterStage", 2); SetPlayerCheckpoint(playerid, -1759.8169,-192.7360,0.0, 8.0);
			return SendClientMessage(playerid,COLOR_QUEST, "Работа: Ты доставил груз. Возвращайся за {FF0000}зарплатой{FFCC00}.");
        }//Доставил груз
        if (GetPVarInt(playerid, "WorkWaterStage") == 2)
        {//Приехал за зарплатой
            new String[120], wxp, wcash; // 3600xp/час   396 000$/час   1хр в секунду   110$ в секунду
			if (WorkTime[playerid] <= 480) {wxp = WorkTime[playerid]; wcash = WorkTime[playerid] * 110;}
			else {wxp = 480; wcash = 26400;}//Не более 12 минут на один заход. Если больше - выдаем хр за 12 минут и вдвое меньше денег
			format(String, sizeof String, "Работа: Вы получили %d XP и %d$ за доставку груза.", wxp, wcash);
			SendClientMessage(playerid, COLOR_QUEST, String); LGiveXP(playerid, wxp); Player[playerid][Cash] += wcash;
			PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
            //Ниже выдаем новый заказ
		    if (QuestCar[playerid] != -1) {SetVehicleZAngle(QuestCar[playerid], 270); RepairVehicle(QuestCar[playerid]); SetPlayerChatBubble(playerid, "Транспорт отремонтирован", COLOR_GREEN, 300.0, 3000);}
            SetPVarInt(playerid, "WorkWaterStage", 1); WorkTime[playerid] = 0;
			new rand = random(sizeof WORKWATER);//Выбираем место доставки груза
            SetPlayerCheckpoint(playerid,WORKWATER[rand][0], WORKWATER[rand][1], WORKWATER[rand][2], 10);
			SendClientMessage(playerid, COLOR_QUEST, "Работа: Доставь груз до {FF0000}места назначения{FFCC00} и вернись за зарплатой!");
        }//Приехал за зарплатой
    }//Капитан Корабля
    
    if (QuestActive[playerid] == 8 && InEvent[playerid] == 0)
    {//Инкассатор
        if (GetPVarInt(playerid, "WorkBankStage") == 1)
        {//Подошел к штабу, с которого нужно взять деньги
			SetPVarInt(playerid, "WorkBankStage", 2); SetPlayerCheckpoint(playerid, 2361.7593, 2397.3511, 10.9471, 8.0);
			return SendClientMessage(playerid,COLOR_QUEST, "Работа: Ты забрал деньги! Отвези их в {FF0000}банк{FFCC00}.");
        }//Подошел к штабу, с которого нужно взять деньги
        if (GetPVarInt(playerid, "WorkBankStage") == 2)
        {//Привез товар к скупщику
            new String[120], wxp, wcash; //Зарплата в час: 2400 xp и 900 000$ => в секунду: 2/3xp и 250$
			if (WorkTime[playerid] <= 600) {wxp = WorkTime[playerid] * 2/3; wcash = WorkTime[playerid] * 250;}
			else {wxp = 400; wcash = 75000;}//Не более 10 минут на один заход. Если больше - выдаем хр за 10 минут и вдвое меньше денег
			format(String, sizeof String, "Работа: Вы получили %d XP и %d$ за проделанную работу.", wxp, wcash);
			SendClientMessage(playerid, COLOR_QUEST, String); LGiveXP(playerid, wxp); Player[playerid][Cash] += wcash;
			PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
            //Ниже выдаем новый заказ
            new rand = random(MAX_BASE); if (rand == 0) rand++;//Выбираем штаб для сбора денег
            SetPVarInt(playerid, "WorkBankStage", 1); WorkTime[playerid] = 0;
            if (QuestCar[playerid] != -1) {RepairVehicle(QuestCar[playerid]); SetVehicleZAngle(QuestCar[playerid], 0); SetPlayerChatBubble(playerid, "Транспорт отремонтирован", COLOR_GREEN, 300.0, 3000);}
			SendClientMessage(playerid, COLOR_QUEST, "Работа: Собери деньги со {FF0000}штаба{FFCC00} и привези их сюда!");
            SetPlayerCheckpoint(playerid,Base[rand][bPosEnterX],Base[rand][bPosEnterY],Base[rand][bPosEnterZ],2);
        }//Привез товар к скупщику
    }//Инкассатор
	
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	if (QuestActive[playerid] == 2 && InEvent[playerid] == 0)
	{//Работа - Доставщик Пиццы
	    new target,next;
	    if (WorkPizzaCP[playerid] == WorkPizzaCPs[playerid] - 1)
	    {//конец маршрута
  			RepairVehicle(QuestCar[playerid]); SetPlayerChatBubble(playerid, "Транспорт отремонтирован", COLOR_GREEN, 300.0, 3000);
	        new String[120], wxp, wcash;
			//Зарплата в час: 2400 xp и 144 000$ => в секунду: 2/3xp и 40$
			if (WorkTime[playerid] <= 300) {wxp = WorkTime[playerid] * 2/3; wcash = WorkTime[playerid] * 40;}
			else {wxp = 200;}//Не более 5 минут на один круг. Если больше 5 минут - выдаем как за 5 минут.
			format(String, sizeof String, "Работа: Вы получили %d XP и %d$ за доставку пиццы.", wxp, wcash);
			SendClientMessage(playerid, COLOR_QUEST, String); LGiveXP(playerid, wxp); Player[playerid][Cash] += wcash;
            PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
			WorkPizzaID[playerid] = random(8) + 1; WorkPizzaCP[playerid] = 0; WorkTime[playerid] = 0;
			switch(WorkPizzaID[playerid])
			{
			    case 1: {WorkPizzaCPs[playerid] = 18; SetPlayerRaceCheckpoint(playerid, 0, PIZZA1[0][0], PIZZA1[0][1], PIZZA1[0][2], PIZZA1[1][0], PIZZA1[1][1], PIZZA1[1][2], 7);}
			    case 2: {WorkPizzaCPs[playerid] = 19; SetPlayerRaceCheckpoint(playerid, 0, PIZZA2[0][0], PIZZA2[0][1], PIZZA2[0][2], PIZZA2[1][0], PIZZA2[1][1], PIZZA2[1][2], 7);}
			    case 3: {WorkPizzaCPs[playerid] = 20; SetPlayerRaceCheckpoint(playerid, 0, PIZZA3[0][0], PIZZA3[0][1], PIZZA3[0][2], PIZZA3[1][0], PIZZA3[1][1], PIZZA3[1][2], 7);}
			    case 4: {WorkPizzaCPs[playerid] = 21; SetPlayerRaceCheckpoint(playerid, 0, PIZZA4[0][0], PIZZA4[0][1], PIZZA4[0][2], PIZZA4[1][0], PIZZA4[1][1], PIZZA4[1][2], 7);}
			    case 5: {WorkPizzaCPs[playerid] = 20; SetPlayerRaceCheckpoint(playerid, 0, PIZZA5[0][0], PIZZA5[0][1], PIZZA5[0][2], PIZZA5[1][0], PIZZA5[1][1], PIZZA5[1][2], 7);}
			    case 6: {WorkPizzaCPs[playerid] = 25; SetPlayerRaceCheckpoint(playerid, 0, PIZZA6[0][0], PIZZA6[0][1], PIZZA6[0][2], PIZZA6[1][0], PIZZA6[1][1], PIZZA6[1][2], 7);}
			    case 7: {WorkPizzaCPs[playerid] = 22; SetPlayerRaceCheckpoint(playerid, 0, PIZZA7[0][0], PIZZA7[0][1], PIZZA7[0][2], PIZZA7[1][0], PIZZA7[1][1], PIZZA7[1][2], 7);}
			    case 8: {WorkPizzaCPs[playerid] = 20; SetPlayerRaceCheckpoint(playerid, 0, PIZZA8[0][0], PIZZA8[0][1], PIZZA8[0][2], PIZZA8[1][0], PIZZA8[1][1], PIZZA8[1][2], 7);}
			}
			return 1;
	    }//конец маршрута
	    if (WorkPizzaCP[playerid] == WorkPizzaCPs[playerid] - 2)
	    {//предпоследний CP
	        WorkPizzaCP[playerid] += 1;
	        SetPlayerRaceCheckpoint(playerid, 1, 2386.8760, -1921.9377, 12.9784, 0.0, 0.0, 0.0, 7);
	    }//предпоследний CP
	    else
	    {//обычный CP
	        WorkPizzaCP[playerid] += 1;target = WorkPizzaCP[playerid]; next = WorkPizzaCP[playerid] + 1;
	        switch(WorkPizzaID[playerid])
	        {
	            case 1: SetPlayerRaceCheckpoint(playerid, 0, PIZZA1[target][0], PIZZA1[target][1], PIZZA1[target][2], PIZZA1[next][0], PIZZA1[next][1], PIZZA1[next][2], 7);
                case 2: SetPlayerRaceCheckpoint(playerid, 0, PIZZA2[target][0], PIZZA2[target][1], PIZZA2[target][2], PIZZA2[next][0], PIZZA2[next][1], PIZZA2[next][2], 7);
				case 3: SetPlayerRaceCheckpoint(playerid, 0, PIZZA3[target][0], PIZZA3[target][1], PIZZA3[target][2], PIZZA3[next][0], PIZZA3[next][1], PIZZA3[next][2], 7);
				case 4: SetPlayerRaceCheckpoint(playerid, 0, PIZZA4[target][0], PIZZA4[target][1], PIZZA4[target][2], PIZZA4[next][0], PIZZA4[next][1], PIZZA4[next][2], 7);
				case 5: SetPlayerRaceCheckpoint(playerid, 0, PIZZA5[target][0], PIZZA5[target][1], PIZZA5[target][2], PIZZA5[next][0], PIZZA5[next][1], PIZZA5[next][2], 7);
				case 6: SetPlayerRaceCheckpoint(playerid, 0, PIZZA6[target][0], PIZZA6[target][1], PIZZA6[target][2], PIZZA6[next][0], PIZZA6[next][1], PIZZA6[next][2], 7);
				case 7: SetPlayerRaceCheckpoint(playerid, 0, PIZZA7[target][0], PIZZA7[target][1], PIZZA7[target][2], PIZZA7[next][0], PIZZA7[next][1], PIZZA7[next][2], 7);
				case 8: SetPlayerRaceCheckpoint(playerid, 0, PIZZA8[target][0], PIZZA8[target][1], PIZZA8[target][2], PIZZA8[next][0], PIZZA8[next][1], PIZZA8[next][2], 7);
	        }
	        new id = WorkPizzaID[playerid], rand = random(5);
	        if (WorkPizzaCP[playerid] == PIZZAHOUSES[id][0] || WorkPizzaCP[playerid] == PIZZAHOUSES[id][1] || WorkPizzaCP[playerid] == PIZZAHOUSES[id][2])
	        {//Чекпоинт - дом клиента
	            switch(rand)
	            {
		            case 0: SendClientMessage(playerid, COLOR_QUEST, "Клиент: {AFAFAF}Благодарю! У вас лучшая пицца во всем городе!");
		            case 1: SendClientMessage(playerid, COLOR_QUEST, "Клиент: {AFAFAF}А нельзя было побыстрее приехать?!");
		            case 2: SendClientMessage(playerid, COLOR_QUEST, "Клиент: {AFAFAF}А вот и моя пицца! Спасибо!");
		            case 3: SendClientMessage(playerid, COLOR_QUEST, "Клиент: {AFAFAF}Так быстро?! Спасибо!");
		            case 4: SendClientMessage(playerid, COLOR_QUEST, "Клиент: {AFAFAF}Очень вкусно, спасибо!");
	            }
	        }//Чекпоинт - дом клиента
	    }//обычный CP
	}//Работа - Доставщик Пиццы

    if (XRTimeToEnd > 0 && XRStarted[playerid] == 1)
	{//чекпоинт легендарной гонки
	    new target,next,used;
	    if (XRPlayerCP[playerid] == XRCPs - 1)
	    {//финишный чекпоинт
			new String[120];FarmedXP[playerid] = 200 + 35 * (XRPlayers-1); FarmedMoney[playerid] = 25000 + 5000 * (XRPlayers);XRpos += 1;
			if (XRpos == 1){FarmedXP[playerid] += 300;format(String,sizeof(String),"%s[%d] выиграл легендарную гонку и получил %d XP и %d$",PlayerName[playerid],playerid,FarmedXP[playerid],FarmedMoney[playerid]);SendClientMessageToAll(COLOR_XR,String);}
			if (XRpos == 2){FarmedXP[playerid] += 200;format(String,sizeof(String),"%s[%d] финишировал вторым в легендарной гонке и получил %d XP и %d$",PlayerName[playerid],playerid,FarmedXP[playerid],FarmedMoney[playerid]);SendClientMessageToAll(COLOR_XR,String);}
			if (XRpos == 3){FarmedXP[playerid] += 100;format(String,sizeof(String),"%s[%d] финишировал третьим в легендарной гонке и получил %d XP и %d$",PlayerName[playerid],playerid,FarmedXP[playerid],FarmedMoney[playerid]);SendClientMessageToAll(COLOR_XR,String);}
			if (XRpos > 3)
			{
				format(String,sizeof(String),"Вы финишировали %d-ым и получили %d XP и %d$",XRpos,FarmedXP[playerid],FarmedMoney[playerid]);SendClientMessage(playerid,COLOR_XR,String);
			}
			XRPlayers -= 1;Player[playerid][Cash] += FarmedMoney[playerid]; LGiveXP(playerid, FarmedXP[playerid]);
			XRStarted[playerid] = 0; JoinEvent[playerid] = 0; InEvent[playerid] = 0;
			DestroyVehicle(XRCarID[playerid]); XRCarID[playerid] = 0;LSpawnPlayer(playerid);
			SetPlayerVirtualWorld(playerid,0);PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
			DisablePlayerRaceCheckpoint(playerid);
			QuestUpdate(playerid, 16, 1);//Обновление квеста Примите участие в 3 легендарных гонках
			QuestUpdate(playerid, 18, 1);//Обновление квеста Примите участие в 5 соревнованиях
			return 1;
	    }//финишный чекпоинт
	    if (XRPlayerCP[playerid] == XRCPs - 2)
	    {//предпоследний чекпоинт
	        XRPlayerCP[playerid] += 1;target = XRPlayerCP[playerid]; next = XRPlayerCP[playerid] + 1; used = XRPlayerCP[playerid] - 1;
	        if (XRid == 1){SetPlayerRaceCheckpoint(playerid, XRTypeCP[target], XRACE1[target][0], XRACE1[target][1], XRACE1[target][2], 0.0, 0.0, 0.0, 7);}
            if (XRid == 2){SetPlayerRaceCheckpoint(playerid, XRTypeCP[target], XRACE2[target][0], XRACE2[target][1], XRACE2[target][2], 0.0, 0.0, 0.0, 7);}
            if (XRid == 3){SetPlayerRaceCheckpoint(playerid, XRTypeCP[target], XRACE3[target][0], XRACE3[target][1], XRACE3[target][2], 0.0, 0.0, 0.0, 7);}
            if (XRid == 4){SetPlayerRaceCheckpoint(playerid, XRTypeCP[target], XRACE4[target][0], XRACE4[target][1], XRACE4[target][2], 0.0, 0.0, 0.0, 7);}
            if (XRid == 5){SetPlayerRaceCheckpoint(playerid, XRTypeCP[target], XRACE5[target][0], XRACE5[target][1], XRACE5[target][2], 0.0, 0.0, 0.0, 7);}
            if (XRid == 6){SetPlayerRaceCheckpoint(playerid, XRTypeCP[target], XRACE6[target][0], XRACE6[target][1], XRACE6[target][2], 0.0, 0.0, 0.0, 7);}
            if (XRid == 7){SetPlayerRaceCheckpoint(playerid, XRTypeCP[target], XRACE7[target][0], XRACE7[target][1], XRACE7[target][2], 0.0, 0.0, 0.0, 7);}
            if (XRid == 8){SetPlayerRaceCheckpoint(playerid, XRTypeCP[target], XRACE8[target][0], XRACE8[target][1], XRACE8[target][2], 0.0, 0.0, 0.0, 7);}
            if (XRid == 9){SetPlayerRaceCheckpoint(playerid, XRTypeCP[target], XRACE9[target][0], XRACE9[target][1], XRACE9[target][2], 0.0, 0.0, 0.0, 7);}
            if (XRid == 10){SetPlayerRaceCheckpoint(playerid, XRTypeCP[target], XRACE10[target][0], XRACE10[target][1], XRACE10[target][2], 0.0, 0.0, 0.0, 7);}
            if (XRid == 11){SetPlayerRaceCheckpoint(playerid, XRTypeCP[target], XRACE11[target][0], XRACE11[target][1], XRACE11[target][2], 0.0, 0.0, 0.0, 7);}
            if (XRid == 12){SetPlayerRaceCheckpoint(playerid, XRTypeCP[target], XRACE12[target][0], XRACE12[target][1], XRACE12[target][2], 0.0, 0.0, 0.0, 7);}
            if (XRid == 13){SetPlayerRaceCheckpoint(playerid, XRTypeCP[target], XRACE13[target][0], XRACE13[target][1], XRACE13[target][2], 0.0, 0.0, 0.0, 7);}
            if (XRid == 14){SetPlayerRaceCheckpoint(playerid, XRTypeCP[target], XRACE14[target][0], XRACE14[target][1], XRACE14[target][2], 1483.6304, 1130.1642, 10.7147, 7);}
            if (XRid == 15){SetPlayerRaceCheckpoint(playerid, XRTypeCP[target], XRACE15[target][0], XRACE15[target][1], XRACE15[target][2], 0.0, 0.0, 0.0, 7);}
            if (XRid == 16){SetPlayerRaceCheckpoint(playerid, XRTypeCP[target], XRACE16[target][0], XRACE16[target][1], XRACE16[target][2], 0.0, 0.0, 0.0, 7);}
            if (XRid == 17){SetPlayerRaceCheckpoint(playerid, XRTypeCP[target], XRACE17[target][0], XRACE17[target][1], XRACE17[target][2], 0.0, 0.0, 0.0, 7);}
            if (XRid == 18){SetPlayerRaceCheckpoint(playerid, XRTypeCP[target], XRACE18[target][0], XRACE18[target][1], XRACE18[target][2], 0.0, 0.0, 0.0, 7);}
            if (XRid == 19){SetPlayerRaceCheckpoint(playerid, XRTypeCP[target], XRACE19[target][0], XRACE19[target][1], XRACE19[target][2], 0.0, 0.0, 0.0, 7);}
            if (XRid == 20){SetPlayerRaceCheckpoint(playerid, XRTypeCP[target], XRACE20[target][0], XRACE20[target][1], XRACE20[target][2], 0.0, 0.0, 0.0, 7);}
            new Float: x, Float: y, Float: z, Float: Angle, Float: vx, Float: vy, Float: vz;
			GetPlayerPos(playerid,x,y,z);GetVehicleVelocity(XRCarID[playerid], vx, vy, vz);GetVehicleZAngle(XRCarID[playerid], Angle);
			if (XRCarCP[used] != -1)
	        {//если в этом чекпоинте нужно менять авто
	            NeedSpeedDown[playerid] = 1; LACSH[playerid] = 3; LastSpeed[playerid] = 999;//чтобы 2 сек не работал LAC на SpeedHack (ложные срабатывания)
				DestroyVehicle(XRCarID[playerid]);new col1 = random(187), col2 = random(187);
				XRCarID[playerid] = LCreateVehicle(XRCarCP[used], x, y, z, Angle, col1, col2, 0);
				SetVehicleVirtualWorld(XRCarID[playerid], 700);PutPlayerInVehicle(playerid, XRCarID[playerid], 0);
				SetVehicleVelocity(XRCarID[playerid], vx, vy, vz);
				if (LSpectators[playerid] > 0) SpecUpdate(playerid);
				new rand = random(3);ChangeVehiclePaintjob(GetPlayerVehicleID(playerid), rand);//случайный paintjob
				XRPlayerCar[playerid] = XRCarCP[used];//Сохраняет модель машины для её восстановления в дальнейшем
				//Ниже закрываем двери
				new engine, lights, alarm, doors, bonnet, boot, objective;
			    GetVehicleParamsEx(XRCarID[playerid], engine, lights, alarm, doors, bonnet, boot, objective);
			    SetVehicleParamsEx(XRCarID[playerid], engine, lights, alarm, true, bonnet, boot, objective);
      		}//если в этом чекпоинте нужно менять авто
	        PlayerPlaySound(playerid,1056,0.0,0.0,0.0);
	        XRxx[playerid] = x;XRy[playerid] = y;XRz[playerid] = z;XRa[playerid] = Angle;XRvx[playerid] = vx;XRvy[playerid] = vy;XRvz[playerid] = vz;//для восстановления с чекпоинта
	    }//предпоследний чекпоинт
	    else
	    {//обычный чекпоинт
	        XRPlayerCP[playerid] += 1;target = XRPlayerCP[playerid]; next = XRPlayerCP[playerid] + 1; used = XRPlayerCP[playerid] - 1;
	        if (XRid == 1){SetPlayerRaceCheckpoint(playerid, XRTypeCP[target], XRACE1[target][0], XRACE1[target][1], XRACE1[target][2], XRACE1[next][0], XRACE1[next][1], XRACE1[next][2], 7);}
            if (XRid == 2){SetPlayerRaceCheckpoint(playerid, XRTypeCP[target], XRACE2[target][0], XRACE2[target][1], XRACE2[target][2], XRACE2[next][0], XRACE2[next][1], XRACE2[next][2], 7);}
            if (XRid == 3){SetPlayerRaceCheckpoint(playerid, XRTypeCP[target], XRACE3[target][0], XRACE3[target][1], XRACE3[target][2], XRACE3[next][0], XRACE3[next][1], XRACE3[next][2], 7);}
            if (XRid == 4){SetPlayerRaceCheckpoint(playerid, XRTypeCP[target], XRACE4[target][0], XRACE4[target][1], XRACE4[target][2], XRACE4[next][0], XRACE4[next][1], XRACE4[next][2], 7);}
            if (XRid == 5){SetPlayerRaceCheckpoint(playerid, XRTypeCP[target], XRACE5[target][0], XRACE5[target][1], XRACE5[target][2], XRACE5[next][0], XRACE5[next][1], XRACE5[next][2], 7);}
            if (XRid == 6){SetPlayerRaceCheckpoint(playerid, XRTypeCP[target], XRACE6[target][0], XRACE6[target][1], XRACE6[target][2], XRACE6[next][0], XRACE6[next][1], XRACE6[next][2], 7);}
            if (XRid == 7){SetPlayerRaceCheckpoint(playerid, XRTypeCP[target], XRACE7[target][0], XRACE7[target][1], XRACE7[target][2], XRACE7[next][0], XRACE7[next][1], XRACE7[next][2], 7);}
            if (XRid == 8){SetPlayerRaceCheckpoint(playerid, XRTypeCP[target], XRACE8[target][0], XRACE8[target][1], XRACE8[target][2], XRACE8[next][0], XRACE8[next][1], XRACE8[next][2], 7);}
            if (XRid == 9){SetPlayerRaceCheckpoint(playerid, XRTypeCP[target], XRACE9[target][0], XRACE9[target][1], XRACE9[target][2], XRACE9[next][0], XRACE9[next][1], XRACE9[next][2], 7);}
            if (XRid == 10){SetPlayerRaceCheckpoint(playerid, XRTypeCP[target], XRACE10[target][0], XRACE10[target][1], XRACE10[target][2], XRACE10[next][0], XRACE10[next][1], XRACE10[next][2], 7);}
            if (XRid == 11){SetPlayerRaceCheckpoint(playerid, XRTypeCP[target], XRACE11[target][0], XRACE11[target][1], XRACE11[target][2], XRACE11[next][0], XRACE11[next][1], XRACE11[next][2], 7);}
            if (XRid == 12){SetPlayerRaceCheckpoint(playerid, XRTypeCP[target], XRACE12[target][0], XRACE12[target][1], XRACE12[target][2], XRACE12[next][0], XRACE12[next][1], XRACE12[next][2], 7);}
            if (XRid == 13){SetPlayerRaceCheckpoint(playerid, XRTypeCP[target], XRACE13[target][0], XRACE13[target][1], XRACE13[target][2], XRACE13[next][0], XRACE13[next][1], XRACE13[next][2], 7);}
            if (XRid == 14){SetPlayerRaceCheckpoint(playerid, XRTypeCP[target], XRACE14[target][0], XRACE14[target][1], XRACE14[target][2], XRACE14[next][0], XRACE14[next][1], XRACE14[next][2], 15);}
            if (XRid == 15){SetPlayerRaceCheckpoint(playerid, XRTypeCP[target], XRACE15[target][0], XRACE15[target][1], XRACE15[target][2], XRACE15[next][0], XRACE15[next][1], XRACE15[next][2], 7);}
            if (XRid == 16){SetPlayerRaceCheckpoint(playerid, XRTypeCP[target], XRACE16[target][0], XRACE16[target][1], XRACE16[target][2], XRACE16[next][0], XRACE16[next][1], XRACE16[next][2], 3.5);}
            if (XRid == 17){SetPlayerRaceCheckpoint(playerid, XRTypeCP[target], XRACE17[target][0], XRACE17[target][1], XRACE17[target][2], XRACE17[next][0], XRACE17[next][1], XRACE17[next][2], 7);}
            if (XRid == 18){SetPlayerRaceCheckpoint(playerid, XRTypeCP[target], XRACE18[target][0], XRACE18[target][1], XRACE18[target][2], XRACE18[next][0], XRACE18[next][1], XRACE18[next][2], 7);}
            if (XRid == 19){SetPlayerRaceCheckpoint(playerid, XRTypeCP[target], XRACE19[target][0], XRACE19[target][1], XRACE19[target][2], XRACE19[next][0], XRACE19[next][1], XRACE19[next][2], 15);}
            if (XRid == 20){SetPlayerRaceCheckpoint(playerid, XRTypeCP[target], XRACE20[target][0], XRACE20[target][1], XRACE20[target][2], XRACE20[next][0], XRACE20[next][1], XRACE20[next][2], 7);}
			new Float: x, Float: y, Float: z, Float: Angle, Float: vx, Float: vy, Float: vz;
			GetPlayerPos(playerid,x,y,z);GetVehicleVelocity(XRCarID[playerid], vx, vy, vz);GetVehicleZAngle(XRCarID[playerid], Angle);
			if (XRCarCP[used] != -1)
	        {//если в этом чекпоинте нужно менять авто
	            NeedSpeedDown[playerid] = 1; LACSH[playerid] = 3; LastSpeed[playerid] = 999;//чтобы 2 сек не работал LAC на SpeedHack (ложные срабатывания)
	            DestroyVehicle(XRCarID[playerid]);new col1 = random(187), col2 = random(187);
				XRCarID[playerid] = LCreateVehicle(XRCarCP[used], x, y, z, Angle, col1, col2, 0);
				SetVehicleVirtualWorld(XRCarID[playerid], 700);PutPlayerInVehicle(playerid, XRCarID[playerid], 0);
				SetVehicleVelocity(XRCarID[playerid], vx, vy, vz);
				if (LSpectators[playerid] > 0) SpecUpdate(playerid);
				new rand = random(3);ChangeVehiclePaintjob(GetPlayerVehicleID(playerid), rand);//случайный paintjob
				XRPlayerCar[playerid] = XRCarCP[used];//Сохраняет модель машины для её восстановления в дальнейшем
                //Ниже закрываем двери
				new engine, lights, alarm, doors, bonnet, boot, objective;
			    GetVehicleParamsEx(XRCarID[playerid], engine, lights, alarm, doors, bonnet, boot, objective);
			    SetVehicleParamsEx(XRCarID[playerid], engine, lights, alarm, true, bonnet, boot, objective);
       		}//если в этом чекпоинте нужно менять авто
	        PlayerPlaySound(playerid,1056,0.0,0.0,0.0);
	        XRxx[playerid] = x;XRy[playerid] = y;XRz[playerid] = z;XRa[playerid] = Angle;XRvx[playerid] = vx;XRvy[playerid] = vy;XRvz[playerid] = vz;//для восстановления с чекпоинта
	    }//обычный чекпоинт
	    return 1;
	}//чекпоинт легендарной гонки

	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
	if (DynamicPickup[pickupid][Type] == 1)
	{//дом
	    new id = DynamicPickup[pickupid][ID];
	    if (PlayerToPoint(3.0,playerid, Property[id][pPosEnterX], Property[id][pPosEnterY], Property[id][pPosEnterZ])) LastHouseVisited[playerid] = id;
	}//дом
	
	if (DynamicPickup[pickupid][Type] == 2)
	{//штаб
	    new id = DynamicPickup[pickupid][ID];
	    if (PlayerToPoint(3.0,playerid, Base[id][bPosEnterX], Base[id][bPosEnterY], Base[id][bPosEnterZ])) LastBaseVisited[playerid] = id;
	}//штаб
	
	if (DynamicPickup[pickupid][Type] == 3)
	{//чьи-то деньги
	    new String[140];
		Player[playerid][Cash] += DynamicPickup[pickupid][ID];
		format(String, sizeof String, "{FFFF00}SERVER: Вы подобрали {FFFFFF}%d{FFFF00}$", DynamicPickup[pickupid][ID]);
		SendClientMessage(playerid, COLOR_YELLOW, String);
		format(String, sizeof String, "%d.%d.%d в %d:%d:%d |   CASH: %s[%d] подобрал %d$", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid, DynamicPickup[pickupid][ID]);
		WriteLog("GlobalLog", String); WriteLog("CashOperations", String);
		QuestUpdate(playerid, 19, DynamicPickup[pickupid][ID]);//Обновление квеста Ограбьте других игроков на сумму 10 000$
		//удаляем пикап
		KillTimer(DynamicPickup[pickupid][DestroyTimerID]);
		DestroyCashPickup(pickupid);
	}//чьи-то деньги

	//----------- кейсы
	if (pickupid == CasePickup[1])
	{//кейс
		DestroyDynamicPickup(CasePickup[1]);DestroyDynamicMapIcon(CaseMapIcon[1]);
		case1 = random(sizeof(CaseSpawn));
		CasePickup[1] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case1][0], CaseSpawn[case1][1], CaseSpawn[case1][2] );
		CaseMapIcon[1] = CreateDynamicMapIcon(CaseSpawn[case1][0], CaseSpawn[case1][1], CaseSpawn[case1][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
		if (CaseBugTime[playerid] > 0) return 1;
		if (GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Подбирать кейсы можно только в общем игровом мире!");
		new String[140], Priz = 3000 + random(69) * 250;//От 3 000 до 20 000. Всегда кратно 250
		Player[playerid][Cash] += Priz; CaseBugTime[playerid] = 3;
		QuestUpdate(playerid, 21, 1);//Обновление квеста Найдите 5 кейсов
		format(String, sizeof String, "Содержимое кейса: {FFFFFF}%d{FFCC00}$", Priz);
		return SendClientMessage(playerid,COLOR_QUEST,String);
	}//кейс

	if (pickupid == CasePickup[2])
	{//кейс
		DestroyDynamicPickup(CasePickup[2]);DestroyDynamicMapIcon(CaseMapIcon[2]);
		case2 = random(sizeof(CaseSpawn));
		CasePickup[2] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case2][0], CaseSpawn[case2][1], CaseSpawn[case2][2] );
		CaseMapIcon[2] = CreateDynamicMapIcon(CaseSpawn[case2][0], CaseSpawn[case2][1], CaseSpawn[case2][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
        if (CaseBugTime[playerid] > 0) return 1;
        if (GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Подбирать кейсы можно только в общем игровом мире!");
		new String[140], Priz = 3000 + random(69) * 250;//От 3 000 до 20 000. Всегда кратно 250
		Player[playerid][Cash] += Priz; CaseBugTime[playerid] = 3;
		QuestUpdate(playerid, 21, 1);//Обновление квеста Найдите 5 кейсов
		format(String, sizeof String, "Содержимое кейса: {FFFFFF}%d{FFCC00}$", Priz);
		return SendClientMessage(playerid,COLOR_QUEST,String);
	}//кейс
	//----------- кейсы

	if (pickupid == CasePickup[3])
	{//кейс
		DestroyDynamicPickup(CasePickup[3]);DestroyDynamicMapIcon(CaseMapIcon[3]);
		case3 = random(sizeof(CaseSpawn));
		CasePickup[3] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case3][0], CaseSpawn[case3][1], CaseSpawn[case3][2] );
		CaseMapIcon[3] = CreateDynamicMapIcon(CaseSpawn[case3][0], CaseSpawn[case3][1], CaseSpawn[case3][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
        if (CaseBugTime[playerid] > 0) return 1;
        if (GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Подбирать кейсы можно только в общем игровом мире!");
  		new String[140], Priz = 3000 + random(69) * 250;//От 3 000 до 20 000. Всегда кратно 250
		Player[playerid][Cash] += Priz; CaseBugTime[playerid] = 3;
		QuestUpdate(playerid, 21, 1);//Обновление квеста Найдите 5 кейсов
		format(String, sizeof String, "Содержимое кейса: {FFFFFF}%d{FFCC00}$", Priz);
		return SendClientMessage(playerid,COLOR_QUEST,String);
	}//кейс

	if (pickupid == CasePickup[4])
	{//кейс
		DestroyDynamicPickup(CasePickup[4]);DestroyDynamicMapIcon(CaseMapIcon[4]);
		case4 = random(sizeof(CaseSpawn));
		CasePickup[4] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case4][0], CaseSpawn[case4][1], CaseSpawn[case4][2] );
		CaseMapIcon[4] = CreateDynamicMapIcon(CaseSpawn[case4][0], CaseSpawn[case4][1], CaseSpawn[case4][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
        if (CaseBugTime[playerid] > 0) return 1;
        if (GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Подбирать кейсы можно только в общем игровом мире!");
		new String[140], Priz = 3000 + random(69) * 250;//От 3 000 до 20 000. Всегда кратно 250
		Player[playerid][Cash] += Priz; CaseBugTime[playerid] = 3;
		QuestUpdate(playerid, 21, 1);//Обновление квеста Найдите 5 кейсов
		format(String, sizeof String, "Содержимое кейса: {FFFFFF}%d{FFCC00}$", Priz);
		return SendClientMessage(playerid,COLOR_QUEST,String);
	}//кейс

	if (pickupid == CasePickup[5])
	{//кейс
		DestroyDynamicPickup(CasePickup[5]);DestroyDynamicMapIcon(CaseMapIcon[5]);
		case5 = random(sizeof(CaseSpawn));
		CasePickup[5] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case5][0], CaseSpawn[case5][1], CaseSpawn[case5][2] );
		CaseMapIcon[5] = CreateDynamicMapIcon(CaseSpawn[case5][0], CaseSpawn[case5][1], CaseSpawn[case5][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
        if (CaseBugTime[playerid] > 0) return 1;
        if (GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Подбирать кейсы можно только в общем игровом мире!");
		new String[140], Priz = 3000 + random(69) * 250;//От 3 000 до 20 000. Всегда кратно 250
		Player[playerid][Cash] += Priz; CaseBugTime[playerid] = 3;
		QuestUpdate(playerid, 21, 1);//Обновление квеста Найдите 5 кейсов
		format(String, sizeof String, "Содержимое кейса: {FFFFFF}%d{FFCC00}$", Priz);
		return SendClientMessage(playerid,COLOR_QUEST,String);
	}//кейс

	if (pickupid == CasePickup[6])
	{//кейс
		DestroyDynamicPickup(CasePickup[6]);DestroyDynamicMapIcon(CaseMapIcon[6]);
		case6 = random(sizeof(CaseSpawn));
		CasePickup[6] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case6][0], CaseSpawn[case6][1], CaseSpawn[case6][2] );
		CaseMapIcon[6] = CreateDynamicMapIcon(CaseSpawn[case6][0], CaseSpawn[case6][1], CaseSpawn[case6][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
        if (CaseBugTime[playerid] > 0) return 1;
        if (GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Подбирать кейсы можно только в общем игровом мире!");
		new String[140], Priz = 3000 + random(69) * 250;//От 3 000 до 20 000. Всегда кратно 250
		Player[playerid][Cash] += Priz; CaseBugTime[playerid] = 3;
		QuestUpdate(playerid, 21, 1);//Обновление квеста Найдите 5 кейсов
		format(String, sizeof String, "Содержимое кейса: {FFFFFF}%d{FFCC00}$", Priz);
		return SendClientMessage(playerid,COLOR_QUEST,String);
	}//кейс

	if (pickupid == CasePickup[7])
	{//кейс
		DestroyDynamicPickup(CasePickup[7]);DestroyDynamicMapIcon(CaseMapIcon[7]);
		case7 = random(sizeof(CaseSpawn));
		CasePickup[7] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case7][0], CaseSpawn[case7][1], CaseSpawn[case7][2] );
		CaseMapIcon[7] = CreateDynamicMapIcon(CaseSpawn[case7][0], CaseSpawn[case7][1], CaseSpawn[case7][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
        if (CaseBugTime[playerid] > 0) return 1;
        if (GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Подбирать кейсы можно только в общем игровом мире!");
		new String[140], Priz = 3000 + random(69) * 250;//От 3 000 до 20 000. Всегда кратно 250
		Player[playerid][Cash] += Priz; CaseBugTime[playerid] = 3;
		QuestUpdate(playerid, 21, 1);//Обновление квеста Найдите 5 кейсов
		format(String, sizeof String, "Содержимое кейса: {FFFFFF}%d{FFCC00}$", Priz);
		return SendClientMessage(playerid,COLOR_QUEST,String);
	}//кейс

	if (pickupid == CasePickup[8])
	{//кейс
		DestroyDynamicPickup(CasePickup[8]);DestroyDynamicMapIcon(CaseMapIcon[8]);
		case8 = random(sizeof(CaseSpawn));
		CasePickup[8] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case8][0], CaseSpawn[case8][1], CaseSpawn[case8][2] );
		CaseMapIcon[8] = CreateDynamicMapIcon(CaseSpawn[case8][0], CaseSpawn[case8][1], CaseSpawn[case8][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
        if (CaseBugTime[playerid] > 0) return 1;
        if (GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Подбирать кейсы можно только в общем игровом мире!");
		new String[140], Priz = 3000 + random(69) * 250;//От 3 000 до 20 000. Всегда кратно 250
		Player[playerid][Cash] += Priz; CaseBugTime[playerid] = 3;
		QuestUpdate(playerid, 21, 1);//Обновление квеста Найдите 5 кейсов
		format(String, sizeof String, "Содержимое кейса: {FFFFFF}%d{FFCC00}$", Priz);
		return SendClientMessage(playerid,COLOR_QUEST,String);
	}//кейс

	if (pickupid == CasePickup[9])
	{//кейс
		DestroyDynamicPickup(CasePickup[9]);DestroyDynamicMapIcon(CaseMapIcon[9]);
		case9 = random(sizeof(CaseSpawn));
		CasePickup[9] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case9][0], CaseSpawn[case9][1], CaseSpawn[case9][2] );
		CaseMapIcon[9] = CreateDynamicMapIcon(CaseSpawn[case9][0], CaseSpawn[case9][1], CaseSpawn[case9][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
        if (CaseBugTime[playerid] > 0) return 1;
        if (GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Подбирать кейсы можно только в общем игровом мире!");
		new String[140], Priz = 3000 + random(69) * 250;//От 3 000 до 20 000. Всегда кратно 250
		Player[playerid][Cash] += Priz; CaseBugTime[playerid] = 3;
		QuestUpdate(playerid, 21, 1);//Обновление квеста Найдите 5 кейсов
		format(String, sizeof String, "Содержимое кейса: {FFFFFF}%d{FFCC00}$", Priz);
		return SendClientMessage(playerid,COLOR_QUEST,String);
	}//кейс

	if (pickupid == CasePickup[10])
	{//кейс
		DestroyDynamicPickup(CasePickup[10]);DestroyDynamicMapIcon(CaseMapIcon[10]);
		case10 = random(sizeof(CaseSpawn));
		CasePickup[10] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case10][0], CaseSpawn[case10][1], CaseSpawn[case10][2] );
		CaseMapIcon[10] = CreateDynamicMapIcon(CaseSpawn[case10][0], CaseSpawn[case10][1], CaseSpawn[case10][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
        if (CaseBugTime[playerid] > 0) return 1;
        if (GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Подбирать кейсы можно только в общем игровом мире!");
		new String[140], Priz = 3000 + random(69) * 250;//От 3 000 до 20 000. Всегда кратно 250
		Player[playerid][Cash] += Priz; CaseBugTime[playerid] = 3;
		QuestUpdate(playerid, 21, 1);//Обновление квеста Найдите 5 кейсов
		format(String, sizeof String, "Содержимое кейса: {FFFFFF}%d{FFCC00}$", Priz);
		return SendClientMessage(playerid,COLOR_QUEST,String);
	}//кейс

	if (pickupid == CasePickup[11])
	{//кейс
		DestroyDynamicPickup(CasePickup[11]);DestroyDynamicMapIcon(CaseMapIcon[11]);
		case11 = random(sizeof(CaseSpawn));
		CasePickup[11] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case11][0], CaseSpawn[case11][1], CaseSpawn[case11][2] );
		CaseMapIcon[11] = CreateDynamicMapIcon(CaseSpawn[case11][0], CaseSpawn[case11][1], CaseSpawn[case11][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
        if (CaseBugTime[playerid] > 0) return 1;
        if (GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Подбирать кейсы можно только в общем игровом мире!");
		new String[140], Priz = 3000 + random(69) * 250;//От 3 000 до 20 000. Всегда кратно 250
		Player[playerid][Cash] += Priz; CaseBugTime[playerid] = 3;
		QuestUpdate(playerid, 21, 1);//Обновление квеста Найдите 5 кейсов
		format(String, sizeof String, "Содержимое кейса: {FFFFFF}%d{FFCC00}$", Priz);
		return SendClientMessage(playerid,COLOR_QUEST,String);
	}//кейс

	if (pickupid == CasePickup[12])
	{//кейс
		DestroyDynamicPickup(CasePickup[12]);DestroyDynamicMapIcon(CaseMapIcon[12]);
		case12 = random(sizeof(CaseSpawn));
		CasePickup[12] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case12][0], CaseSpawn[case12][1], CaseSpawn[case12][2] );
		CaseMapIcon[12] = CreateDynamicMapIcon(CaseSpawn[case12][0], CaseSpawn[case12][1], CaseSpawn[case12][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
        if (CaseBugTime[playerid] > 0) return 1;
        if (GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Подбирать кейсы можно только в общем игровом мире!");
		new String[140], Priz = 3000 + random(69) * 250;//От 3 000 до 20 000. Всегда кратно 250
		Player[playerid][Cash] += Priz; CaseBugTime[playerid] = 3;
		QuestUpdate(playerid, 21, 1);//Обновление квеста Найдите 5 кейсов
		format(String, sizeof String, "Содержимое кейса: {FFFFFF}%d{FFCC00}$", Priz);
		return SendClientMessage(playerid,COLOR_QUEST,String);
	}//кейс

	if (pickupid == CasePickup[13])
	{//кейс
		DestroyDynamicPickup(CasePickup[13]);DestroyDynamicMapIcon(CaseMapIcon[13]);
		case13 = random(sizeof(CaseSpawn));
		CasePickup[13] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case13][0], CaseSpawn[case13][1], CaseSpawn[case13][2] );
		CaseMapIcon[13] = CreateDynamicMapIcon(CaseSpawn[case13][0], CaseSpawn[case13][1], CaseSpawn[case13][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
        if (CaseBugTime[playerid] > 0) return 1;
        if (GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Подбирать кейсы можно только в общем игровом мире!");
		new String[140], Priz = 3000 + random(69) * 250;//От 3 000 до 20 000. Всегда кратно 250
		Player[playerid][Cash] += Priz; CaseBugTime[playerid] = 3;
		QuestUpdate(playerid, 21, 1);//Обновление квеста Найдите 5 кейсов
		format(String, sizeof String, "Содержимое кейса: {FFFFFF}%d{FFCC00}$", Priz);
		return SendClientMessage(playerid,COLOR_QUEST,String);
	}//кейс

	if (pickupid == CasePickup[14])
	{//кейс
		DestroyDynamicPickup(CasePickup[14]);DestroyDynamicMapIcon(CaseMapIcon[14]);
		case14 = random(sizeof(CaseSpawn));
		CasePickup[14] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case14][0], CaseSpawn[case14][1], CaseSpawn[case14][2] );
		CaseMapIcon[14] = CreateDynamicMapIcon(CaseSpawn[case14][0], CaseSpawn[case14][1], CaseSpawn[case14][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
        if (CaseBugTime[playerid] > 0) return 1;
        if (GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Подбирать кейсы можно только в общем игровом мире!");
		new String[140], Priz = 3000 + random(69) * 250;//От 3 000 до 20 000. Всегда кратно 250
		Player[playerid][Cash] += Priz; CaseBugTime[playerid] = 3;
		QuestUpdate(playerid, 21, 1);//Обновление квеста Найдите 5 кейсов
		format(String, sizeof String, "Содержимое кейса: {FFFFFF}%d{FFCC00}$", Priz);
		return SendClientMessage(playerid,COLOR_QUEST,String);
	}//кейс

	if (pickupid == CasePickup[15])
	{//кейс
		DestroyDynamicPickup(CasePickup[15]);DestroyDynamicMapIcon(CaseMapIcon[15]);
		case15 = random(sizeof(CaseSpawn));
		CasePickup[15] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case15][0], CaseSpawn[case15][1], CaseSpawn[case15][2] );
		CaseMapIcon[15] = CreateDynamicMapIcon(CaseSpawn[case15][0], CaseSpawn[case15][1], CaseSpawn[case15][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
        if (CaseBugTime[playerid] > 0) return 1;
        if (GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Подбирать кейсы можно только в общем игровом мире!");
		new String[140], Priz = 3000 + random(69) * 250;//От 3 000 до 20 000. Всегда кратно 250
		Player[playerid][Cash] += Priz; CaseBugTime[playerid] = 3;
		QuestUpdate(playerid, 21, 1);//Обновление квеста Найдите 5 кейсов
		format(String, sizeof String, "Содержимое кейса: {FFFFFF}%d{FFCC00}$", Priz);
		return SendClientMessage(playerid,COLOR_QUEST,String);
	}//кейс

	if (pickupid == CasePickup[16])
	{//кейс
		DestroyDynamicPickup(CasePickup[16]);DestroyDynamicMapIcon(CaseMapIcon[16]);
		case16 = random(sizeof(CaseSpawn));
		CasePickup[16] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case16][0], CaseSpawn[case16][1], CaseSpawn[case16][2] );
		CaseMapIcon[16] = CreateDynamicMapIcon(CaseSpawn[case16][0], CaseSpawn[case16][1], CaseSpawn[case16][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
        if (CaseBugTime[playerid] > 0) return 1;
        if (GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Подбирать кейсы можно только в общем игровом мире!");
		new String[140], Priz = 3000 + random(69) * 250;//От 3 000 до 20 000. Всегда кратно 250
		Player[playerid][Cash] += Priz; CaseBugTime[playerid] = 3;
		QuestUpdate(playerid, 21, 1);//Обновление квеста Найдите 5 кейсов
		format(String, sizeof String, "Содержимое кейса: {FFFFFF}%d{FFCC00}$", Priz);
		return SendClientMessage(playerid,COLOR_QUEST,String);
	}//кейс

	if (pickupid == CasePickup[17])
	{//кейс
		DestroyDynamicPickup(CasePickup[17]);DestroyDynamicMapIcon(CaseMapIcon[17]);
		case17 = random(sizeof(CaseSpawn));
		CasePickup[17] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case17][0], CaseSpawn[case17][1], CaseSpawn[case17][2] );
		CaseMapIcon[17] = CreateDynamicMapIcon(CaseSpawn[case17][0], CaseSpawn[case17][1], CaseSpawn[case17][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
        if (CaseBugTime[playerid] > 0) return 1;
        if (GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Подбирать кейсы можно только в общем игровом мире!");
		new String[140], Priz = 3000 + random(69) * 250;//От 3 000 до 20 000. Всегда кратно 250
		Player[playerid][Cash] += Priz; CaseBugTime[playerid] = 3;
		QuestUpdate(playerid, 21, 1);//Обновление квеста Найдите 5 кейсов
		format(String, sizeof String, "Содержимое кейса: {FFFFFF}%d{FFCC00}$", Priz);
		return SendClientMessage(playerid,COLOR_QUEST,String);
	}//кейс

	if (pickupid == CasePickup[18])
	{//кейс
		DestroyDynamicPickup(CasePickup[18]);DestroyDynamicMapIcon(CaseMapIcon[18]);
		case18 = random(sizeof(CaseSpawn));
		CasePickup[18] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case18][0], CaseSpawn[case18][1], CaseSpawn[case18][2] );
		CaseMapIcon[18] = CreateDynamicMapIcon(CaseSpawn[case18][0], CaseSpawn[case18][1], CaseSpawn[case18][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
        if (CaseBugTime[playerid] > 0) return 1;
        if (GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Подбирать кейсы можно только в общем игровом мире!");
		new String[140], Priz = 3000 + random(69) * 250;//От 3 000 до 20 000. Всегда кратно 250
		Player[playerid][Cash] += Priz; CaseBugTime[playerid] = 3;
		QuestUpdate(playerid, 21, 1);//Обновление квеста Найдите 5 кейсов
		format(String, sizeof String, "Содержимое кейса: {FFFFFF}%d{FFCC00}$", Priz);
		return SendClientMessage(playerid,COLOR_QUEST,String);
	}//кейс

	if (pickupid == CasePickup[19])
	{//кейс
		DestroyDynamicPickup(CasePickup[19]);DestroyDynamicMapIcon(CaseMapIcon[19]);
		case19 = random(sizeof(CaseSpawn));
		CasePickup[19] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case19][0], CaseSpawn[case19][1], CaseSpawn[case19][2] );
		CaseMapIcon[19] = CreateDynamicMapIcon(CaseSpawn[case19][0], CaseSpawn[case19][1], CaseSpawn[case19][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
        if (CaseBugTime[playerid] > 0) return 1;
        if (GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Подбирать кейсы можно только в общем игровом мире!");
		new String[140], Priz = 3000 + random(69) * 250;//От 3 000 до 20 000. Всегда кратно 250
		Player[playerid][Cash] += Priz; CaseBugTime[playerid] = 3;
		QuestUpdate(playerid, 21, 1);//Обновление квеста Найдите 5 кейсов
		format(String, sizeof String, "Содержимое кейса: {FFFFFF}%d{FFCC00}$", Priz);
		return SendClientMessage(playerid,COLOR_QUEST,String);
	}//кейс

	if (pickupid == CasePickup[20])
	{//кейс
		DestroyDynamicPickup(CasePickup[20]);DestroyDynamicMapIcon(CaseMapIcon[20]);
		case20 = random(sizeof(CaseSpawn));
		CasePickup[20] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case20][0], CaseSpawn[case20][1], CaseSpawn[case20][2] );
		CaseMapIcon[20] = CreateDynamicMapIcon(CaseSpawn[case20][0], CaseSpawn[case20][1], CaseSpawn[case20][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
        if (CaseBugTime[playerid] > 0) return 1;
        if (GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Подбирать кейсы можно только в общем игровом мире!");
		new String[140], Priz = 3000 + random(69) * 250;//От 3 000 до 20 000. Всегда кратно 250
		Player[playerid][Cash] += Priz; CaseBugTime[playerid] = 3;
		QuestUpdate(playerid, 21, 1);//Обновление квеста Найдите 5 кейсов
		format(String, sizeof String, "Содержимое кейса: {FFFFFF}%d{FFCC00}$", Priz);
		return SendClientMessage(playerid,COLOR_QUEST,String);
	}//кейс



	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
 	TunesPerSecond[playerid]++; if (TunesPerSecond[playerid] > 5) Kick(playerid);//От флуда тюнингом
    if (Player[playerid][Banned] == 1) return 1;//чтобы читера не садило в ад по много раз
	if (InEvent[playerid] == EVENT_RACE || InEvent[playerid] == EVENT_XRACE)
	{//использовал тюнинг в гонках
		RemovePlayerFromVehicle(playerid);//Запрет тюнинга в гонках
		return SendClientMessage(playerid, COLOR_RED, "Использование автомастерских запрещено в гонках! Заново вызовите транспорт и покиньте автомастерскую!");
	}//использовал тюнинг в гонках
    
	if (componentid == 1087 && Player[playerid][Level] < 9) return SendClientMessage(playerid,COLOR_RED,"Вы должны быть как минимум 9-го уровня, чтобы гидравлика сохранялась при трансформации!");
	if (componentid == 1009 && Player[playerid][Level] < 35) return SendClientMessage(playerid,COLOR_RED,"Вы должны быть как минимум 35-го уровня, чтобы нитро х2 сохранялось при трансформации!");
	if (componentid == 1008 && Player[playerid][Level] < 42) return SendClientMessage(playerid,COLOR_RED,"Вы должны быть как минимум 42-го уровня, чтобы нитро х5 сохранялось при трансформации!");
	if (componentid == 1010 && Player[playerid][Level] < 48) return SendClientMessage(playerid,COLOR_RED,"Вы должны быть как минимум 48-го уровня, чтобы нитро х10 сохранялось при трансформации!");

	if (LastPlayerTuneStatus[playerid] > 0)
	{//Игрок поставил компонент в тюнинге
	    if (Player[playerid][CarActive] == 1)
	    {//Сохранение тюнинга класс 1
	        if (GetVehicleComponentType(componentid) == 0) Player[playerid][CarSlot1Component0] = componentid;
	        if (GetVehicleComponentType(componentid) == 1) Player[playerid][CarSlot1Component1] = componentid;
	        if (GetVehicleComponentType(componentid) == 2) Player[playerid][CarSlot1Component2] = componentid;
	        if (GetVehicleComponentType(componentid) == 3) Player[playerid][CarSlot1Component3] = componentid;
	        if (GetVehicleComponentType(componentid) == 4) Player[playerid][CarSlot1Component4] = componentid;
	        if (GetVehicleComponentType(componentid) == 5) Player[playerid][CarSlot1Component5] = componentid;
	        if (GetVehicleComponentType(componentid) == 6) Player[playerid][CarSlot1Component6] = componentid;
	        if (GetVehicleComponentType(componentid) == 7) Player[playerid][CarSlot1Component7] = componentid;
	        if (GetVehicleComponentType(componentid) == 8) Player[playerid][CarSlot1Component8] = componentid;
	        if (GetVehicleComponentType(componentid) == 9) Player[playerid][CarSlot1Component9] = componentid;
	        if (GetVehicleComponentType(componentid) == 10) Player[playerid][CarSlot1Component10] = componentid;
	        if (GetVehicleComponentType(componentid) == 11) Player[playerid][CarSlot1Component11] = componentid;
	        if (GetVehicleComponentType(componentid) == 12) Player[playerid][CarSlot1Component12] = componentid;
	        if (GetVehicleComponentType(componentid) == 13) Player[playerid][CarSlot1Component13] = componentid;
            SaveTune(playerid);
	    }//Сохранение тюнинга класс 1
	    if (Player[playerid][CarActive] == 2)
	    {//Сохранение тюнинга класс 2
	        if (GetVehicleComponentType(componentid) == 0) Player[playerid][CarSlot2Component0] = componentid;
	        if (GetVehicleComponentType(componentid) == 1) Player[playerid][CarSlot2Component1] = componentid;
	        if (GetVehicleComponentType(componentid) == 2) Player[playerid][CarSlot2Component2] = componentid;
	        if (GetVehicleComponentType(componentid) == 3) Player[playerid][CarSlot2Component3] = componentid;
	        if (GetVehicleComponentType(componentid) == 4) Player[playerid][CarSlot2Component4] = componentid;
	        if (GetVehicleComponentType(componentid) == 5) Player[playerid][CarSlot2Component5] = componentid;
	        if (GetVehicleComponentType(componentid) == 6) Player[playerid][CarSlot2Component6] = componentid;
	        if (GetVehicleComponentType(componentid) == 7) Player[playerid][CarSlot2Component7] = componentid;
	        if (GetVehicleComponentType(componentid) == 8) Player[playerid][CarSlot2Component8] = componentid;
	        if (GetVehicleComponentType(componentid) == 9) Player[playerid][CarSlot2Component9] = componentid;
	        if (GetVehicleComponentType(componentid) == 10) Player[playerid][CarSlot2Component10] = componentid;
	        if (GetVehicleComponentType(componentid) == 11) Player[playerid][CarSlot2Component11] = componentid;
	        if (GetVehicleComponentType(componentid) == 12) Player[playerid][CarSlot2Component12] = componentid;
	        if (GetVehicleComponentType(componentid) == 13) Player[playerid][CarSlot2Component13] = componentid;
            SaveTune(playerid);
	    }//Сохранение тюнинга класс 2
		return 1;
	}//Игрок поставил компонент в тюнинге

	new String[140];
	DestroyVehicle(vehicleid); TimeTransform[playerid] = 5; LACPanic[playerid]++;//LAC v2.0
	format(String,sizeof(String), "[АДМИНАМ]LAC:{AFAFAF} Транспорт игрока %s[%d] уничтожен. {FF0000}Причина: {AFAFAF}Возможно тюнинг транспорта",PlayerName[playerid], playerid);
    foreach(Player, cid) if (Player[cid][Admin] != 0 && Logged[cid] == 1) SendClientMessage(cid, COLOR_RED, String);
    SendClientMessage(playerid, -1,"{FF0000}LAC:{AFAFAF} Ваш транспорт был уничтожен. {FF0000}Причина: {AFAFAF}Возможно чит на тюнинг транспорта");
	format(String, 140, "%d.%d.%d в %d:%d:%d |   LAC: Транспорт игрока %s[%d] уничтожен. Причина: Возможно чит на тюнинг транспорта", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid);
	WriteLog("GlobalLog", String);WriteLog("LAC", String);
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{//смена PaintJob в тюнинге
    TunesPerSecond[playerid]++; if (TunesPerSecond[playerid] > 5) Kick(playerid);//От флуда тюнингом
	if (Player[playerid][Level] < 55) return SendClientMessage(playerid,COLOR_RED,"Вы должны быть как минимум 55-го уровня, чтобы покрасочные работы сохранялись при трансформации!");
    if (Player[playerid][CarActive] == 1) Player[playerid][CarSlot1PaintJob] = paintjobid;
    if (Player[playerid][CarActive] == 2) Player[playerid][CarSlot2PaintJob] = paintjobid;
    SaveTune(playerid);
	return 1;
}//смена PaintJob в тюнинге

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{//перекраска авто в тюнинге
    TunesPerSecond[playerid]++; if (TunesPerSecond[playerid] > 5) Kick(playerid);//От флуда тюнингом
	if (Player[playerid][CarActive] == 1) {Player[playerid][CarSlot1Color1] = color1; Player[playerid][CarSlot1Color2] = color2;}
	if (Player[playerid][CarActive] == 2) {Player[playerid][CarSlot2Color1] = color1; Player[playerid][CarSlot2Color2] = color2;}
	return 1;
}//перекраска авто в тюнинге

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
    if (LSpectators[playerid] > 0) {SpecUpdate(playerid);}
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
     if( newkeys == 1 || newkeys == 9 || newkeys == 33 && oldkeys != 1 || oldkeys != 9 || oldkeys != 33)
     {//бесконечное нитро
        if (Player[playerid][CarActive] == 1 && Player[playerid][CarSlot1NitroX] > 0 && InEvent[playerid] == 0 && QuestActive[playerid] == 0) AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
        if (Player[playerid][CarActive] == 2 && Player[playerid][CarSlot2NitroX] > 0 && InEvent[playerid] == 0 && QuestActive[playerid] == 0) AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
     }//бесконечное нитро

     if(newkeys & KEY_FIRE && IsPlayerInAnyVehicle(playerid))
     {//перекраска авто
	     if(IsPlayerInPayNSpray(playerid))
		 {//игрок в гараже Pay N Spray
			    if (Player[playerid][Cash] < 100){SendClientMessage(playerid,COLOR_RED,"Вам нужно {FFFFFF}100${FF0000} чтобы перекрасить машину");return 1;}
		        Player[playerid][Cash] -= 100;
				new col1 = random (256), col2 = random(256);
			    if (Player[playerid][CarActive] == 1){Player[playerid][CarSlot1Color1] = col1;Player[playerid][CarSlot1Color2] = col2;}
			    if (Player[playerid][CarActive] == 2){Player[playerid][CarSlot2Color1] = col1;Player[playerid][CarSlot2Color2] = col2;}
			    if (Player[playerid][CarActive] == 3){Player[playerid][CarSlot3Color1] = col1;Player[playerid][CarSlot3Color2] = col2;}
			    ChangeVehicleColor(GetPlayerVehicleID(playerid), col1, col2);RepairVehicle(GetPlayerVehicleID(playerid));
			    PlayerPlaySound(playerid,1134,0.0,0.0,0.0);
		 }//игрок в гараже Pay N Spray
	}//перекраска авто
	
	if(newkeys & KEY_FIRE && IsPlayerInAnyVehicle(playerid) && IsPlayerInRangeOfPoint(playerid, 8, -2026.9791, 124.2575, 29.1300))
    {//Автомастерская TurboSpeed
       ShowPlayerDialog(playerid, DIALOG_TURBOSPEED, 2, "Автомастерская TurboSpeed", "Нитро\nНеон\n{FF0000}Удалить компонент тюнинга", "ОК", "Отмена");
    }//Автомастерская TurboSpeed

	if (newkeys & KEY_JUMP && ZMIsPlayerIsTank[playerid] == 1 && InEvent[playerid] == EVENT_ZOMBIE)
	{//Высокий прыжок у прыгуна
	    if (JumpTime[playerid] > 0) return 1;
	    new Float: vx, Float: vy, Float: vz;
		GetPlayerVelocity(playerid,vx,vy,vz);
        SetPlayerVelocity(playerid, vx, vy, 0.75);
        JumpTime[playerid] = 3;
	}//Высокий прыжок у прыгуна

	if(newkeys & KEY_YES && IsPlayerInVehicle(playerid, PlayerCarID[playerid]) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{//трансформация машины на +1, если игрок за рулем своего авто
		if (TimeTransform[playerid] > 0){new String[120];format(String,sizeof(String),"Вы не можете трансформировать транспорт еще {FFFFFF}%d{FF0000} секунд",TimeTransform[playerid]);return SendClientMessage(playerid,COLOR_RED,String);}
		if (LastPlayerTuneStatus[playerid] != 0) return SendClientMessage(playerid,COLOR_RED,"Нельзя трансформироваться в автомастерской и у въезда в нее");
		LastSpeed[playerid] = 999; NeedSpeedDown[playerid] = 1; LACSH[playerid] = 3;//чтобы не работал LAC на SpeedHack (ложные срабатывания)
		new Float: x, Float: y, Float: z, Float: Angle; GetPlayerPos(playerid,x,y,z);
		new Float: vx, Float: vy, Float: vz;new wrld = GetPlayerVirtualWorld(playerid);
		//!!!запись пассажиров
		new Passenger1 = -1, Passenger2 = -1, Passenger3 = -1, Seats;
		foreach(Player, cid)
		{//цикл
		    if (IsPlayerInVehicle(cid,PlayerCarID[playerid]) && GetPlayerState(cid) == PLAYER_STATE_PASSENGER)
		    {//наш пассажир
		        if (GetPlayerVehicleSeat(cid) == 1){Passenger1 = cid;}
		        if (GetPlayerVehicleSeat(cid) == 2){Passenger2 = cid;}
		        if (GetPlayerVehicleSeat(cid) == 3){Passenger3 = cid;}
		    }//наш пассажир
		}//цикл
		//!!!запись пассажиров
		GetVehicleVelocity(PlayerCarID[playerid], vx, vy, vz);
		GetVehicleZAngle(PlayerCarID[playerid], Angle);
		DestroyVehicle(PlayerCarID[playerid]); PlayerCarID[playerid] = -1;
		CarChanged[playerid] = 0;
		if (Player[playerid][CarActive] == 1 && CarChanged[playerid] == 0)
		{//Если сейчас активен слот 1
			if (Player[playerid][CarSlot2] > 0){Player[playerid][CarActive] = 2;CarChanged[playerid] = 1;}
			if (Player[playerid][CarSlot3] > 0){Player[playerid][CarActive] = 3;CarChanged[playerid] = 1;}
			if(CarChanged[playerid] == 0){Player[playerid][CarActive] = 1;CarChanged[playerid] = 1;}
		}//Если сейчас активен слот 1
		if (Player[playerid][CarActive] == 2 && CarChanged[playerid] == 0)
		{//Если сейчас активен слот 2
			if (Player[playerid][CarSlot3] > 0){Player[playerid][CarActive] = 3;CarChanged[playerid] = 1;}
			if (Player[playerid][CarSlot1] > 0){Player[playerid][CarActive] = 1;CarChanged[playerid] = 1;}
			if(CarChanged[playerid] == 0){Player[playerid][CarActive] = 2;CarChanged[playerid] = 1;}
		}//Если сейчас активен слот 2
		if (Player[playerid][CarActive] == 3 && CarChanged[playerid] == 0)
		{//Если сейчас активен слот 3
			if (Player[playerid][CarSlot1] > 0){Player[playerid][CarActive] = 1;CarChanged[playerid] = 1;}
			if (Player[playerid][CarSlot2] > 0){Player[playerid][CarActive] = 2;CarChanged[playerid] = 1;}
			if(CarChanged[playerid] == 0){Player[playerid][CarActive] = 3;CarChanged[playerid] = 1;}
		}//Если сейчас активен слот 3
		if (Player[playerid][CarActive] == 1)
		{
			PlayerCarID[playerid] = LCreateVehicle(Player[playerid][CarSlot1], x, y, z + 1, Angle, Player[playerid][CarSlot1Color1], Player[playerid][CarSlot1Color2], 0);
			if (Player[playerid][CarSlot1PaintJob] > -1){ChangeVehiclePaintjob(PlayerCarID[playerid], Player[playerid][CarSlot1PaintJob]);}
			//Загрузка компонентов тюнинга
		    if (Player[playerid][CarSlot1Component0] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot1Component0]);
		    if (Player[playerid][CarSlot1Component1] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot1Component1]);
		    if (Player[playerid][CarSlot1Component2] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot1Component2]);
		    if (Player[playerid][CarSlot1Component3] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot1Component3]);
		    if (Player[playerid][CarSlot1Component4] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot1Component4]);
		    if (Player[playerid][CarSlot1Component5] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot1Component5]);
		    if (Player[playerid][CarSlot1Component6] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot1Component6]);
		    if (Player[playerid][CarSlot1Component7] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot1Component7]);
		    if (Player[playerid][CarSlot1Component8] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot1Component8]);
		    if (Player[playerid][CarSlot1Component9] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot1Component9]);
		    if (Player[playerid][CarSlot1Component10] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot1Component10]);
		    if (Player[playerid][CarSlot1Component11] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot1Component11]);
		    if (Player[playerid][CarSlot1Component12] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot1Component12]);
		    if (Player[playerid][CarSlot1Component13] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot1Component13]);
            if (Player[playerid][CarSlot1Neon] != 0 && Player[playerid][Prestige] >= 4)
			{//Создание неона
			    new vehicleid = PlayerCarID[playerid];
			    NeonObject1[vehicleid] = CreateDynamicObject(Player[playerid][CarSlot1Neon], 0, 0, 0, 0, 0, 0, wrld, GetPlayerInterior(playerid), -1, 300.0);
			    NeonObject2[vehicleid] = CreateDynamicObject(Player[playerid][CarSlot1Neon], 0, 0, 0, 0, 0, 0, wrld, GetPlayerInterior(playerid), -1, 300.0);
			    AttachDynamicObjectToVehicle(NeonObject1[vehicleid], vehicleid, -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
			    AttachDynamicObjectToVehicle(NeonObject2[vehicleid], vehicleid, 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
			}//Создание неона
		}
		else if (Player[playerid][CarActive] == 2)
		{
			PlayerCarID[playerid] = LCreateVehicle(Player[playerid][CarSlot2], x, y, z + 1, Angle, Player[playerid][CarSlot2Color1], Player[playerid][CarSlot2Color2], 0);
			if (Player[playerid][CarSlot2PaintJob] > -1){ChangeVehiclePaintjob(PlayerCarID[playerid], Player[playerid][CarSlot2PaintJob]);}
            //Загрузка компонентов тюнинга
		    if (Player[playerid][CarSlot2Component0] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot2Component0]);
		    if (Player[playerid][CarSlot2Component1] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot2Component1]);
		    if (Player[playerid][CarSlot2Component2] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot2Component2]);
		    if (Player[playerid][CarSlot2Component3] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot2Component3]);
		    if (Player[playerid][CarSlot2Component4] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot2Component4]);
		    if (Player[playerid][CarSlot2Component5] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot2Component5]);
		    if (Player[playerid][CarSlot2Component6] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot2Component6]);
		    if (Player[playerid][CarSlot2Component7] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot2Component7]);
		    if (Player[playerid][CarSlot2Component8] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot2Component8]);
		    if (Player[playerid][CarSlot2Component9] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot2Component9]);
		    if (Player[playerid][CarSlot2Component10] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot2Component10]);
		    if (Player[playerid][CarSlot2Component11] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot2Component11]);
		    if (Player[playerid][CarSlot2Component12] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot2Component12]);
		    if (Player[playerid][CarSlot2Component13] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot2Component13]);
            if (Player[playerid][CarSlot2Neon] != 0 && Player[playerid][Prestige] >= 4)
			{//Создание неона
			    new vehicleid = PlayerCarID[playerid];
			    NeonObject1[vehicleid] = CreateDynamicObject(Player[playerid][CarSlot2Neon], 0, 0, 0, 0, 0, 0, wrld, GetPlayerInterior(playerid), -1, 300.0);
			    NeonObject2[vehicleid] = CreateDynamicObject(Player[playerid][CarSlot2Neon], 0, 0, 0, 0, 0, 0, wrld, GetPlayerInterior(playerid), -1, 300.0);
			    AttachDynamicObjectToVehicle(NeonObject1[vehicleid], vehicleid, -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
			    AttachDynamicObjectToVehicle(NeonObject2[vehicleid], vehicleid, 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
			}//Создание неона
		}
		else if (Player[playerid][CarActive] == 3){PlayerCarID[playerid] = LCreateVehicle(Player[playerid][CarSlot3], x, y, z + 2, Angle, Player[playerid][CarSlot3Color1], Player[playerid][CarSlot3Color2], 0);}
		SetVehicleVirtualWorld(PlayerCarID[playerid], wrld);PutPlayerInVehicle(playerid, PlayerCarID[playerid], 0);
		SetVehicleVelocity(PlayerCarID[playerid], vx, vy, vz); LACSH[playerid] = 3;
        LinkVehicleToInterior(PlayerCarID[playerid],GetPlayerInterior(playerid));
		CarChanged[playerid] = 1;TimeTransform[playerid] = 5;
		//!!!загрузка пассажиров
		Seats = GetPassengerSeats(PlayerCarID[playerid]);
		if (Seats == 1)
		{//если место всего одно
		    if (Passenger1 > -1){PutPlayerInVehicle(Passenger1, PlayerCarID[playerid], 1);}
		    else
		    {
		        if (Passenger2 > -1){PutPlayerInVehicle(Passenger2, PlayerCarID[playerid], 1);}
		        else
		        {
		            if (Passenger3 > -1){PutPlayerInVehicle(Passenger3, PlayerCarID[playerid], 1);}
		        }
		    }
		}//если место всего одно
		if (Seats == 3)
		{//три места
		    if (Passenger1 > -1){PutPlayerInVehicle(Passenger1, PlayerCarID[playerid], 1);}
		    if (Passenger2 > -1){PutPlayerInVehicle(Passenger2, PlayerCarID[playerid], 2);}
		    if (Passenger3 > -1){PutPlayerInVehicle(Passenger3, PlayerCarID[playerid], 3);}
		}//три места
		//!!!загрузка пассажиров
		if (LSpectators[playerid] > 0) {SpecUpdate(playerid);}//обновление спектра у тех, кто за игроком следил
        QuestUpdate(playerid, 29, 1);//Обновление квеста Трансформируйте транспорт 30 раз
	}//трансформация машины на +1, если игрок за рулем своего авто
	if(newkeys & KEY_NO && IsPlayerInVehicle(playerid, PlayerCarID[playerid]) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{//трансформация машины на -1, если игрок за рулем своего авто
		if (TimeTransform[playerid] > 0){new String[120];format(String,sizeof(String),"Вы не можете трансформировать транспорт еще {FFFFFF}%d{FF0000} секунд",TimeTransform[playerid]);SendClientMessage(playerid,COLOR_RED,String);return 1;}
        if (LastPlayerTuneStatus[playerid] != 0) return SendClientMessage(playerid,COLOR_RED,"Нельзя трансформироваться в автомастерской и у въезда в нее");
	    LastSpeed[playerid] = 999; NeedSpeedDown[playerid] = 1; LACSH[playerid] = 3;//чтобы 2 сек не работал LAC на SpeedHack (ложные срабатывания)
		new Float: x, Float: y, Float: z, Float: Angle; GetPlayerPos(playerid,x,y,z);
		new Float: vx, Float: vy, Float: vz;new wrld = GetPlayerVirtualWorld(playerid);
        //!!!запись пассажиров
		new Passenger1 = -1, Passenger2 = -1, Passenger3 = -1, Seats;
		foreach(Player, cid)
		{//цикл
		    if (IsPlayerInVehicle(cid,PlayerCarID[playerid]) && GetPlayerState(cid) == PLAYER_STATE_PASSENGER)
		    {//наш пассажир
		        if (GetPlayerVehicleSeat(cid) == 1){Passenger1 = cid;}
		        if (GetPlayerVehicleSeat(cid) == 2){Passenger2 = cid;}
		        if (GetPlayerVehicleSeat(cid) == 3){Passenger3 = cid;}
		    }//наш пассажир
		}//цикл
		//!!!запись пассажиров
		GetVehicleVelocity(PlayerCarID[playerid], vx, vy, vz);
		GetVehicleZAngle(PlayerCarID[playerid], Angle);
		DestroyVehicle(PlayerCarID[playerid]); PlayerCarID[playerid] = -1;
		CarChanged[playerid] = 0;
		if (Player[playerid][CarActive] == 1 && CarChanged[playerid] == 0)
		{//Если сейчас активен слот 1
			if (Player[playerid][CarSlot3] > 0){Player[playerid][CarActive] = 3;CarChanged[playerid] = 1;}
			if (Player[playerid][CarSlot2] > 0){Player[playerid][CarActive] = 2;CarChanged[playerid] = 1;}
			if(CarChanged[playerid] == 0){Player[playerid][CarActive] = 1;CarChanged[playerid] = 1;}
		}//Если сейчас активен слот 1
		if (Player[playerid][CarActive] == 2 && CarChanged[playerid] == 0)
		{//Если сейчас активен слот 2
			if (Player[playerid][CarSlot1] > 0){Player[playerid][CarActive] = 1;CarChanged[playerid] = 1;}
			if (Player[playerid][CarSlot3] > 0){Player[playerid][CarActive] = 3;CarChanged[playerid] = 1;}
			if(CarChanged[playerid] == 0){Player[playerid][CarActive] = 2;CarChanged[playerid] = 1;}
		}//Если сейчас активен слот 2
		if (Player[playerid][CarActive] == 3 && CarChanged[playerid] == 0)
		{//Если сейчас активен слот 3
			if (Player[playerid][CarSlot2] > 0){Player[playerid][CarActive] = 2;CarChanged[playerid] = 1;}
			if (Player[playerid][CarSlot1] > 0){Player[playerid][CarActive] = 1;CarChanged[playerid] = 1;}
			if(CarChanged[playerid] == 0){Player[playerid][CarActive] = 3;CarChanged[playerid] = 1;}
		}//Если сейчас активен слот 3
		if (Player[playerid][CarActive] == 1)
		{
			PlayerCarID[playerid] = LCreateVehicle(Player[playerid][CarSlot1], x, y, z + 1, Angle, Player[playerid][CarSlot1Color1], Player[playerid][CarSlot1Color2], 0);
            if (Player[playerid][CarSlot1PaintJob] > -1){ChangeVehiclePaintjob(PlayerCarID[playerid], Player[playerid][CarSlot1PaintJob]);}
			//Загрузка компонентов тюнинга
		    if (Player[playerid][CarSlot1Component0] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot1Component0]);
		    if (Player[playerid][CarSlot1Component1] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot1Component1]);
		    if (Player[playerid][CarSlot1Component2] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot1Component2]);
		    if (Player[playerid][CarSlot1Component3] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot1Component3]);
		    if (Player[playerid][CarSlot1Component4] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot1Component4]);
		    if (Player[playerid][CarSlot1Component5] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot1Component5]);
		    if (Player[playerid][CarSlot1Component6] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot1Component6]);
		    if (Player[playerid][CarSlot1Component7] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot1Component7]);
		    if (Player[playerid][CarSlot1Component8] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot1Component8]);
		    if (Player[playerid][CarSlot1Component9] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot1Component9]);
		    if (Player[playerid][CarSlot1Component10] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot1Component10]);
		    if (Player[playerid][CarSlot1Component11] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot1Component11]);
		    if (Player[playerid][CarSlot1Component12] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot1Component12]);
		    if (Player[playerid][CarSlot1Component13] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot1Component13]);
            if (Player[playerid][CarSlot1Neon] != 0 && Player[playerid][Prestige] >= 4)
			{//Создание неона
			    new vehicleid = PlayerCarID[playerid];
			    NeonObject1[vehicleid] = CreateDynamicObject(Player[playerid][CarSlot1Neon], 0, 0, 0, 0, 0, 0, wrld, GetPlayerInterior(playerid), -1, 300.0);
			    NeonObject2[vehicleid] = CreateDynamicObject(Player[playerid][CarSlot1Neon], 0, 0, 0, 0, 0, 0, wrld, GetPlayerInterior(playerid), -1, 300.0);
			    AttachDynamicObjectToVehicle(NeonObject1[vehicleid], vehicleid, -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
			    AttachDynamicObjectToVehicle(NeonObject2[vehicleid], vehicleid, 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
			}//Создание неона
		}
		else if (Player[playerid][CarActive] == 2)
		{
			PlayerCarID[playerid] = LCreateVehicle(Player[playerid][CarSlot2], x, y, z + 1, Angle, Player[playerid][CarSlot2Color1], Player[playerid][CarSlot2Color2], 0);
			if (Player[playerid][CarSlot2PaintJob] > -1){ChangeVehiclePaintjob(PlayerCarID[playerid], Player[playerid][CarSlot2PaintJob]);}
        	//Загрузка компонентов тюнинга
		    if (Player[playerid][CarSlot2Component0] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot2Component0]);
		    if (Player[playerid][CarSlot2Component1] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot2Component1]);
		    if (Player[playerid][CarSlot2Component2] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot2Component2]);
		    if (Player[playerid][CarSlot2Component3] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot2Component3]);
		    if (Player[playerid][CarSlot2Component4] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot2Component4]);
		    if (Player[playerid][CarSlot2Component5] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot2Component5]);
		    if (Player[playerid][CarSlot2Component6] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot2Component6]);
		    if (Player[playerid][CarSlot2Component7] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot2Component7]);
		    if (Player[playerid][CarSlot2Component8] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot2Component8]);
		    if (Player[playerid][CarSlot2Component9] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot2Component9]);
		    if (Player[playerid][CarSlot2Component10] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot2Component10]);
		    if (Player[playerid][CarSlot2Component11] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot2Component11]);
		    if (Player[playerid][CarSlot2Component12] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot2Component12]);
		    if (Player[playerid][CarSlot2Component13] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot2Component13]);
            if (Player[playerid][CarSlot2Neon] != 0 && Player[playerid][Prestige] >= 4)
			{//Создание неона
			    new vehicleid = PlayerCarID[playerid];
			    NeonObject1[vehicleid] = CreateDynamicObject(Player[playerid][CarSlot2Neon], 0, 0, 0, 0, 0, 0, wrld, GetPlayerInterior(playerid), -1, 300.0);
			    NeonObject2[vehicleid] = CreateDynamicObject(Player[playerid][CarSlot2Neon], 0, 0, 0, 0, 0, 0, wrld, GetPlayerInterior(playerid), -1, 300.0);
			    AttachDynamicObjectToVehicle(NeonObject1[vehicleid], vehicleid, -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
			    AttachDynamicObjectToVehicle(NeonObject2[vehicleid], vehicleid, 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
			}//Создание неона
		}
		else if (Player[playerid][CarActive] == 3){PlayerCarID[playerid] = LCreateVehicle(Player[playerid][CarSlot3], x, y, z + 2, Angle, Player[playerid][CarSlot3Color1], Player[playerid][CarSlot3Color2], 0);}
		SetVehicleVirtualWorld(PlayerCarID[playerid], wrld);PutPlayerInVehicle(playerid, PlayerCarID[playerid], 0);
		SetVehicleVelocity(PlayerCarID[playerid], vx, vy, vz); LACSH[playerid] = 3;
        LinkVehicleToInterior(PlayerCarID[playerid],GetPlayerInterior(playerid));
		CarChanged[playerid] = 1;TimeTransform[playerid] = 5;
        //!!!загрузка пассажиров
		Seats = GetPassengerSeats(PlayerCarID[playerid]);
		if (Seats == 1)
		{//если место всего одно
		    if (Passenger1 > -1){PutPlayerInVehicle(Passenger1, PlayerCarID[playerid], 1);}
		    else
		    {
		        if (Passenger2 > -1){PutPlayerInVehicle(Passenger2, PlayerCarID[playerid], 1);}
		        else
		        {
		            if (Passenger3 > -1){PutPlayerInVehicle(Passenger3, PlayerCarID[playerid], 1);}
		        }
		    }
		}//если место всего одно
		if (Seats == 3)
		{//три места
		    if (Passenger1 > -1){PutPlayerInVehicle(Passenger1, PlayerCarID[playerid], 1);}
		    if (Passenger2 > -1){PutPlayerInVehicle(Passenger2, PlayerCarID[playerid], 2);}
		    if (Passenger3 > -1){PutPlayerInVehicle(Passenger3, PlayerCarID[playerid], 3);}
		}//три места
		//!!!загрузка пассажиров
		if (LSpectators[playerid] > 0) {SpecUpdate(playerid);}//обновление спектра у тех, кто за игроком следил
        QuestUpdate(playerid, 29, 1);//Обновление квеста Трансформируйте транспорт 30 раз
	}//трансформация машины на -1

    if((newkeys & KEY_YES || newkeys & KEY_NO) && IsPlayerInVehicle(playerid, QuestCar[playerid]) && QuestActive[playerid] == 0)
    {//Игрок нажал Y или N сидя в угнанной машине (повторный вызов менюшки угона)
        new modelid = GetVehicleModel(QuestCar[playerid]);
        switch (modelid)
        {//switch
	        case 417, 447, 469, 476, 487, 488, 497, 511, 512, 513, 519, 548, 563, 593:
	        {//Воздушное авто
		        modelid -= 400; new String[120];
				format(String,sizeof(String),"{AFAFAF}Транспорт: {FFCC00}%s{AFAFAF} Стоимость: %d$",PlayerVehicleName[modelid], GetVehicleMaxSpeed(QuestCar[playerid]) * 2000);
		        ShowPlayerDialog(playerid, DIALOG_STEALAIRCAR, 2, String, "{FFCC00}Угнать транспорт{FFFFFF}\nСделать личным транспортом {007FFF}3{FFFFFF}-го класса\n{FF0000}Покинуть транспорт", "Начать", "Отмена");
			}//Воздушное авто
			case 472, 473, 493, 595, 484, 430, 453, 452, 446, 454, 460:
			{//Водные авто
		        modelid -= 400; new String[120];
				format(String,sizeof(String),"{AFAFAF}Транспорт: {FFCC00}%s{AFAFAF} Стоимость: %d$",PlayerVehicleName[modelid], GetVehicleMaxSpeed(QuestCar[playerid]) * 500);
		        ShowPlayerDialog(playerid, DIALOG_STEALWATERCAR, 2, String, "{FFCC00}Угнать транспорт{FFFFFF}\nСделать личным транспортом {007FFF}3{FFFFFF}-го класса\n{FF0000}Покинуть транспорт", "Начать", "Отмена");
			}//Водные авто
			default:
		    {//Наземные авто
				modelid -= 400; new String[120];
				format(String,sizeof(String),"{AFAFAF}Транспорт: {FFCC00}%s{AFAFAF} Стоимость: %d$",PlayerVehicleName[modelid], GetVehicleMaxSpeed(QuestCar[playerid]) * 500);
			    ShowPlayerDialog(playerid, DIALOG_STEALCAR, 2, String, "{FFCC00}Угнать транспорт{FFFFFF}\nСделать личным транспортом {007FFF}1{FFFFFF}-го класса\nСделать личным транспортом {007FFF}2{FFFFFF}-го класса\n{FF0000}Покинуть транспорт", "Начать", "Отмена");
			}//Наземные авто
        }//switch
    }//Игрок нажал Y или N сидя в угнанной машине (повторный вызов менюшки угона)

	if(newkeys & KEY_FIRE || newkeys & KEY_SECONDARY_ATTACK || newkeys & KEY_ACTION)
	{//кнопки атаки
		if (GetPlayerState(playerid) == 1 && Player[playerid][Slot9] == -1)
		{//Стиль драки MixFight
			new rand = random(6);
			if (rand == 0){SetPlayerFightingStyle (playerid, FIGHT_STYLE_NORMAL);}
			if (rand == 1){SetPlayerFightingStyle (playerid, FIGHT_STYLE_BOXING);}
			if (rand == 2){SetPlayerFightingStyle (playerid, FIGHT_STYLE_KUNGFU);}
			if (rand == 3){SetPlayerFightingStyle (playerid, FIGHT_STYLE_KNEEHEAD);}
			if (rand == 4){SetPlayerFightingStyle (playerid, FIGHT_STYLE_GRABKICK);}
			if (rand == 5){SetPlayerFightingStyle (playerid, FIGHT_STYLE_ELBOW);}
		}//Стильь драки MixFight
		if (InPeacefulZone[playerid] == 1 || AdminTPCantKill[playerid] > 0)
		{//В мирной зоне
            if (GetPlayerState(playerid) == 1) {SetPlayerArmedWeapon(playerid,0); ApplyAnimation(playerid,"PED","KO_SKID_BACK",4.0,0,0,0,0,0,1);}//пешком
			if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER && InEvent[playerid] == 0)
			{//за рулем, не в соревах (чтобы в гонках из авто не выкидывало)
			    new model = GetVehicleModel(GetPlayerVehicleID(playerid));
			    if (model == 447 || model == 520 || model == 425 || model == 476 || model == 464 || model == 432 || model == 430)
				{
				    DestroyVehicle(GetPlayerVehicleID(playerid));
				    SendClientMessage(playerid, COLOR_RED, "Нельзя драться в мирной зоне!");
				}
			}//за рулем, не в соревах (чтобы в гонках из авто не выкидывало)
		}//В мирной зоне
		if (PrestigeGM[playerid] == 1)
		{//режим Бога
		    if (GetPlayerState(playerid) == 1 && InEvent[playerid] == 0) ApplyAnimation(playerid,"PED","KO_SKID_BACK",4.0,0,0,0,0,0,1);//нельзя ударить кого-то при низкой карме или позоре
            if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER  && InEvent[playerid] == 0)
			{
			    new model = GetVehicleModel(GetPlayerVehicleID(playerid));
			    if (model == 447 || model == 520 || model == 425 || model == 476 || model == 464 || model == 432 || model == 430)
				{
				    DestroyVehicle(GetPlayerVehicleID(playerid));
				    SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Запрещено пользоваться оружием в Режиме Бога");
				}
			}
		}//режим Бога
	}//кнопки атаки
	
	if((newkeys & KEY_FIRE) && (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT || GetPlayerState(playerid) == PLAYER_STATE_PASSENGER))
	{//Кнопка выстрела
	    //AntiPlus
	    if (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) AntiPlus[playerid] = 2; //deagle, shotgun, sniper

		//---------------------- LAC на Оружие
		new weaponid = GetPlayerWeapon(playerid);
		if(weaponid > 0 && weaponid < 46 && Weapons[playerid][weaponid] == 0 && Player[playerid][Banned] == 0)
		{
			new cheat = 1, String[140];
			if (LACWeaponOff[playerid] > 0) cheat = 0;//Если нужно, чтобы LAC не работал
			if (cheat == 1)
			{//игрок читер
				ResetPlayerWeapons(playerid); LSpawnPlayer(playerid); LACWeaponOff[playerid] = 3;
				LACPanic[playerid]++;//LAC v2.0
				format(String,sizeof(String), "[АДМИНАМ]LAC:{AFAFAF} %s[%d] возможно использует чит на Оружие",PlayerName[playerid], playerid);
				foreach(Player, cid) if (Player[cid][Admin] != 0 && Logged[cid] == 1) SendClientMessage(cid, COLOR_RED, String);
				SendClientMessage(playerid, -1,"{FF0000}LAC:{AFAFAF} Вы были заново зареспавнены. {FF0000}Причина: {AFAFAF}Возможно чит на Оружие");
				format(String, 140, "%d.%d.%d a %d:%d:%d |   LAC: %s[%d] возможно использует чит на Оружие", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid);
				WriteLog("GlobalLog", String);WriteLog("LAC", String);
			}//игрок читер
		}
		//---------------------- LAC на Оружие

	}//Кнопка выстрела
	
	if(newkeys & KEY_CROUCH && GetPlayerState(playerid) == 1 && AntiPlus[playerid] > 0) ApplyAnimation(playerid,"PED","KO_SKID_BACK",4.0,0,0,0,0,0,1);


	if(newkeys & KEY_SECONDARY_ATTACK || newkeys & KEY_SPRINT)
	{//смена скина - выбор
		if (SkinChangeMode[playerid] == 1)
		{
			SavePlayer(playerid);TogglePlayerControllable(playerid,1);SkinChangeMode[playerid] = 0;
			SetPlayerVirtualWorld(playerid,0);LSpawnPlayer(playerid);
			TextDrawHideForPlayer(playerid, SkinChangeTextDraw);TextDrawHideForPlayer(playerid, SkinIDTD[playerid]);
		}
	}//смена скина - выбор

	if(newkeys & KEY_WALK && GetPlayerState(playerid) == 1)
	{//нажал альт - дом, штаб, аэропорт, казино, работа
	    new xOnce = 0;		
		//------ Банк
		if (IsPlayerInRangeOfPoint(playerid,2,2316.6182,-7.2874,26.7422))
		{//Игрок в 2 метрах от банка
		    //Высчитывание макс. денег
		    new houseid = Player[playerid][Home];
			if (houseid <= 0) MaxBank[playerid] = 50000000;//макс 50 млн пока у игрока нет дома
			else if (Property[houseid][pPrice] >= 80000000) MaxBank[playerid] = 999999999; //дом за 80кк - 999кк
			else if (Property[houseid][pPrice] >= 60000000) MaxBank[playerid] = 400000000; //дом за 60кк - 400кк
			else if (Property[houseid][pPrice] >= 40000000) MaxBank[playerid] = 250000000; //дом за 40кк - 250кк
			else if (Property[houseid][pPrice] >= 20000000) MaxBank[playerid] = 150000000; //дом за 20кк - 150кк
			else MaxBank[playerid] = 100000000; //дом за 10кк - 100кк
            //Высчитывание макс. денег
			new String[120];xOnce = 1;
			format(String,sizeof(String),"{AFAFAF}Банк. На счете: {00FF00}%d{AFAFAF}. Максимум: {FFFFFF}%d{AFAFAF}.",Player[playerid][Bank],MaxBank[playerid]);
			ShowPlayerDialog(playerid, DIALOG_BANK, 2, String, "Положить деньги на счет\nСнять деньги со счета\n{AFAFAF}(?) Как увеличить максимум денег в банке", "ОК", "");
		}
		
		for(new i = 0; i < 6; i++)
		{//банк - вход
		    if (IsPlayerInRangeOfPoint(playerid,1.5,BANKENTERS[i][0],BANKENTERS[i][1],BANKENTERS[i][2]))
		    {//игрок у входа в банк
	        	if (Player[playerid][Banned] != 0) return 1;//Забаненных не пускает
		        GetPlayerPos(playerid,InteriorEnterX[playerid],InteriorEnterY[playerid],InteriorEnterZ[playerid]);
			    GetPlayerFacingAngle(playerid,InteriorEnterA[playerid]);
			    SetPlayerPos(playerid,2304.6858,-16.2069,26.7422); SetPlayerFacingAngle(playerid, 270);
			    SetCameraBehindPlayer(playerid);xOnce = 1;
			    InPeacefulZone[playerid] = 1;
		    }//игрок у входа в банк
		}//банк - вход
		
		if (IsPlayerInRangeOfPoint(playerid,1.5,2304.6858,-16.2069,26.7422))
		{//банк - выход
		    if (InteriorEnterX[playerid] != 0 && InteriorEnterY[playerid] != 0 && InteriorEnterZ[playerid] != 0)
		    {//игрок заходил в интерьер, а значит сейчас может выйти
		        if (Player[playerid][Banned] != 0) return 1;//Забаненных не пускает
			    SetPlayerPos(playerid,InteriorEnterX[playerid],InteriorEnterY[playerid],InteriorEnterZ[playerid]);
				SetPlayerFacingAngle(playerid,InteriorEnterA[playerid] - 180);
				SetPlayerInterior(playerid, 0);SetCameraBehindPlayer(playerid);
	            InteriorEnterX[playerid] = 0; InteriorEnterY[playerid] = 0; InteriorEnterZ[playerid] = 0;
	            xOnce = 1; InPeacefulZone[playerid] = 0;
            }//игрок заходил в интерьер, а значит сейчас может выйти
		}//банк - выход		
		
		if (IsPlayerInRangeOfPoint(playerid,2,2324.4902,-1149.5474,1050.7101) || IsPlayerInRangeOfPoint(playerid,2,243.7173,304.9818,999.1484) || IsPlayerInRangeOfPoint(playerid,2,2218.4033,-1076.2634,1050.4844) || IsPlayerInRangeOfPoint(playerid,2,2365.3140,-1135.5983,1050.8826) || IsPlayerInRangeOfPoint(playerid,2,2496.0002,-1692.0852,1014.7422) || IsPlayerInRangeOfPoint(playerid,2,2270.4172,-1210.4956,1047.5625))
		{//выход из дома
		    if (Player[playerid][Banned] != 0) return 1;//Забаненных не пускает
			new houseid = GetPlayerVirtualWorld(playerid) - 1000;
			SetPlayerPos(playerid, Property[houseid][pPosEnterX], Property[houseid][pPosEnterY],Property[houseid][pPosEnterZ]);
			SetPlayerFacingAngle(playerid, Property[houseid][pPosEnterA] - 180.0);
			SetPlayerVirtualWorld(playerid,0);SetPlayerInterior(playerid,0);
            InPeacefulZone[playerid] = 0;
			SetCameraBehindPlayer(playerid); return 1;
		}//выход из дома
		
		if (IsPlayerInRangeOfPoint(playerid,2,2332.5144,-1144.4189,1054.3047) || IsPlayerInRangeOfPoint(playerid,2,2215.7893,-1074.6979,1050.4844) || IsPlayerInRangeOfPoint(playerid,2,2363.7717,-1127.3329,1050.8826) || IsPlayerInRangeOfPoint(playerid,2,2492.4016,-1708.5626,1018.3368) || IsPlayerInRangeOfPoint(playerid,2,2262.7871,-1216.8030,1049.0234))
		{//Смена скина в доме
		    SetPlayerPos(playerid,681.4626,-450.8589,-25.6172);SetPlayerFacingAngle(playerid,-180.0);
			SetPlayerInterior(playerid,1);SetPlayerVirtualWorld(playerid,playerid + 1);
			SetPlayerCameraPos(playerid,681.4331,-454.7023,-24.5537);SetPlayerCameraLookAt(playerid,681.4626,-450.8589,-25.1172);
			TogglePlayerControllable(playerid,0);SkinChangeMode[playerid] = 1;SetPlayerArmedWeapon(playerid, 0);
			new String[10];format (String,sizeof(String),"Skin: %d",Player[playerid][Model]);TextDrawSetString(SkinIDTD[playerid], String);
			TextDrawShowForPlayer(playerid, SkinChangeTextDraw);TextDrawShowForPlayer(playerid, SkinIDTD[playerid]);
            xOnce = 1;
		}//Смена скина в доме

		if (IsPlayerInRangeOfPoint(playerid,2, 774.0399, -78.7388, 1000.6627) || IsPlayerInRangeOfPoint(playerid,2, 774.0266, -50.3715, 1000.5859) || IsPlayerInRangeOfPoint(playerid,2, 1727.0281, -1637.9517, 20.2230) || IsPlayerInRangeOfPoint(playerid,2, -2636.4778, 1402.5682, 906.4609))
		{//выход из штаба
		    if (Player[playerid][Banned] != 0) return 1;//Забаненных не пускает
			new baseid = GetPlayerVirtualWorld(playerid) - 2000;
			if (baseid > 0 && baseid <= MAX_BASE)
			{//Корректный ID штаба
				SetPlayerPos(playerid, Base[baseid][bPosEnterX], Base[baseid][bPosEnterY], Base[baseid][bPosEnterZ]);
				SetPlayerFacingAngle(playerid, Base[baseid][bPosEnterA] - 180.0);
				SetPlayerVirtualWorld(playerid,0);SetPlayerInterior(playerid,0);
                InPeacefulZone[playerid] = 0;
				SetCameraBehindPlayer(playerid); return 1;
			}//Корректный ID штаба
		}//выход из штаба

		for(new i = 0; i < 4; i++)
		{//магазины одежды
		    if (IsPlayerInRangeOfPoint(playerid,1.5,CLOTHESENTERS[i][0],CLOTHESENTERS[i][1],CLOTHESENTERS[i][2]))
		    {//игрок у магазина одежды
        		if (Player[playerid][Cash] < 10000) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вам нужно 10 000$ чтобы войти в магазин одежды!");
				Player[playerid][Cash] -= 10000;SendClientMessage(playerid,COLOR_YELLOW,"Вы заплатили 10 000$ за вход в магазин одежды. Выберите модель персонажа..");
				SetPlayerPos(playerid,681.4626,-450.8589,-25.6172);SetPlayerFacingAngle(playerid,-180.0);
				SetPlayerInterior(playerid,1);SetPlayerVirtualWorld(playerid,playerid + 1);
				SetPlayerCameraPos(playerid,681.4331,-454.7023,-24.5537);SetPlayerCameraLookAt(playerid,681.4626,-450.8589,-25.1172);
				TogglePlayerControllable(playerid,0);SkinChangeMode[playerid] = 1;SetPlayerArmedWeapon(playerid, 0);
				new String[10];format (String,sizeof(String),"Skin: %d",Player[playerid][Model]);TextDrawSetString(SkinIDTD[playerid], String);
				TextDrawShowForPlayer(playerid, SkinChangeTextDraw);TextDrawShowForPlayer(playerid, SkinIDTD[playerid]);
			    xOnce = 1;
		    }//игрок у магазина одежды
		}//магазины одежды
		
		if (IsPlayerInRangeOfPoint(playerid,1.5,1962.3420,1009.6814,992.4688) || IsPlayerInRangeOfPoint(playerid,1.5,1958.0320,1009.6746,992.4688) || IsPlayerInRangeOfPoint(playerid,1.5,1962.3417,1025.3008,992.4688) || IsPlayerInRangeOfPoint(playerid,1.5,1958.0321,1025.2384,992.4688))
		{//казино - рулетка
		    if (Player[playerid][CasinoBalance] >= 100000000 && Player[playerid][Prestige] < 9) return SendClientMessage(playerid, COLOR_RED, "Проваливай! Тебе здесь не рады!");
   			new String[180], MaxBet; xOnce = 1;
   			if (Player[playerid][Level] < 39) MaxBet = 100000; //1 - 38 лвл: 100 000$
   			else if (Player[playerid][Level] < 53) MaxBet = 250000; //39 - 52 лвл: 250 000$
   			else if (Player[playerid][Level] < 66) MaxBet = 500000; //53 - 65 лвл: 500 000$
   			else MaxBet = 1000000; //66+ лвл: 1 000 000$
   			if (Player[playerid][Prestige] >= 9) MaxBet = 100000000; //Престиж 8: 100 000 000$
			format(String,sizeof(String),"{AFAFAF}Максимальная Ставка: {FFFFFF}%d", MaxBet);
			ShowPlayerDialog(playerid, DIALOG_CASINORULET, 2, String, "{FFFFFF}Поставить на {FF0000}Красное\n{FFFFFF}Поставить на {AFAFAF}Черное\n{FFFFFF}Поставить на {FFFF00}1-12\n{FFFFFF}Поставить на {FFFF00}13-24\n{FFFFFF}Поставить на {FFFF00}25-36\n{FFFFFF}Поставить на {FFFF00}Число", "ОК", "Отмена");
		}//казино - рулетка
		
		if (IsPlayerInRangeOfPoint(playerid,1.5,1954.1530,995.4341,992.8594))
		{//Казино - Веселый Будда
		    new String[140], randaction = random(3), randvalue; xOnce = 1;
		    if (Player[playerid][BuddhaTime] > 0)
		    {
		        format(String, sizeof String, "Веселый Будда будет доступен через %d минут", Player[playerid][BuddhaTime]/60 + 1);
		        return SendClientMessage(playerid, COLOR_RED, String);
		    }
			Player[playerid][BuddhaTime] = 1800;
			if (randaction == 0)
			{//Отрицательное действие
				randvalue = random(50000) + 1;//от 1 до 50 000
				Player[playerid][Cash] -= randvalue; SavePlayer(playerid);
				format(String,sizeof(String),"Веселый Будда: Вы потеряли {FFFFFF}%d{FF0000}$", randvalue);
                SendClientMessage(playerid, COLOR_RED, String);
                format(String, sizeof String, "-%d$", randvalue); SetPlayerChatBubble(playerid, String, COLOR_RED, 50.0, 3000);
			}//Отрицательное действие
			else if (randaction == 1)
			{//Положительное действие - Деньги
				randvalue = random(200000) + 50000;//от 50 000 до 250 000
				Player[playerid][Cash] += randvalue; SavePlayer(playerid);
				format(String,sizeof(String),"Веселый Будда: Вы получили {FFFFFF}%d{FFCC00}$", randvalue);
                SendClientMessage(playerid, COLOR_QUEST, String);
                format(String, sizeof String, "+%d$", randvalue); SetPlayerChatBubble(playerid, String, COLOR_GREEN, 50.0, 3000);
			}//Положительное действие - Деньги
			else if (randaction == 2)
			{//Положительное действие - XP
				randvalue = random(400) + 100;//от 100 до 500
				format(String,sizeof(String),"Веселый Будда: Вы получили {FFFFFF}%d{FFCC00} XP", randvalue);
				SendClientMessage(playerid, COLOR_QUEST, String);
				LGiveXP(playerid, randvalue); SavePlayer(playerid);
				format(String, sizeof String, "+%d XP", randvalue); SetPlayerChatBubble(playerid, String, COLOR_YELLOW, 50.0, 3000);
			}//Положительное действие - XP
		}//Казино - Веселый Будда
		
		if (IsPlayerInRangeOfPoint(playerid,1.5,1958.3613,953.2741,10.8203))
		{//Казино - вход слева
		    if (Player[playerid][Banned] != 0) return 1;//Забаненных не пускает
		    SetPlayerPos(playerid, 1963.7800,972.4600,994.4688);
		    SetPlayerFacingAngle(playerid, 30); SetPlayerInterior(playerid, 10);
		    SetCameraBehindPlayer(playerid); SetPlayerVirtualWorld(playerid, 10); xOnce = 1;
            InPeacefulZone[playerid] = 1;
		}//Казино - вход слева
		
		if (IsPlayerInRangeOfPoint(playerid,1.5,1963.7800,972.4600,994.4688))
		{//Казино - выход слева
		    if (Player[playerid][Banned] != 0) return 1;//Забаненных не пускает
		    SetPlayerPos(playerid, 1958.3613,953.2741,10.82030);
		    SetPlayerFacingAngle(playerid, 176); SetPlayerInterior(playerid, 0);
		    SetCameraBehindPlayer(playerid); SetPlayerVirtualWorld(playerid, 0); xOnce = 1;
            InPeacefulZone[playerid] = 0;
		}//Казино - выход слева
		
		if (IsPlayerInRangeOfPoint(playerid,1.5,2019.3174,1007.8547,10.8203))
		{//Казино - вход центральный
		    if (Player[playerid][Banned] != 0) return 1;//Забаненных не пускает
		    SetPlayerPos(playerid, 2018.9702, 1017.8456, 996.8750);
		    SetPlayerFacingAngle(playerid, 90); SetPlayerInterior(playerid, 10);
		    SetCameraBehindPlayer(playerid); SetPlayerVirtualWorld(playerid, 10); xOnce = 1;
            InPeacefulZone[playerid] = 1;
		}//Казино - вход центральный
		
		if (IsPlayerInRangeOfPoint(playerid,1.5,2018.9702,1017.8456,996.8750))
		{//Казино - выход центральный
            if (Player[playerid][Banned] != 0) return 1;//Забаненных не пускает
		    SetPlayerPos(playerid, 2019.3174,1007.8547,10.8203);
		    SetPlayerFacingAngle(playerid, 270); SetPlayerInterior(playerid, 0);
		    SetCameraBehindPlayer(playerid); SetPlayerVirtualWorld(playerid, 0); xOnce = 1;
            InPeacefulZone[playerid] = 0;
		}//Казино - выход центральный
		
		if (IsPlayerInRangeOfPoint(playerid,1.5,1944.2803,1076.0552,10.8203))
		{//Казино - вход справа
		    if (Player[playerid][Banned] != 0) return 1;//Забаненных не пускает
		    SetPlayerPos(playerid, 1963.6882,1063.2550,994.4688);
		    SetPlayerFacingAngle(playerid, 180); SetPlayerInterior(playerid, 10);
		    SetCameraBehindPlayer(playerid); SetPlayerVirtualWorld(playerid, 10); xOnce = 1;
            InPeacefulZone[playerid] = 1;
		}//Казино - вход справа

		if (IsPlayerInRangeOfPoint(playerid,1.5,1963.6882,1063.2550,994.4688))
		{//Казино - выход справа
		    if (Player[playerid][Banned] != 0) return 1;//Забаненных не пускает
		    SetPlayerPos(playerid, 1944.2803,1076.0552,10.8203);
		    SetPlayerFacingAngle(playerid, 0); SetPlayerInterior(playerid, 0);
		    SetCameraBehindPlayer(playerid); SetPlayerVirtualWorld(playerid, 0); xOnce = 1;
            InPeacefulZone[playerid] = 0;
		}//Казино - выход справа

		if (IsPlayerInRangeOfPoint(playerid,1.5,1451.6349,-2287.0703,13.5469) || IsPlayerInRangeOfPoint(playerid,2,-1404.6575,-303.7458,14.1484) || IsPlayerInRangeOfPoint(playerid,2,1672.9861,1447.9349,10.7868) || IsPlayerInRangeOfPoint(playerid,2,2315.5173,0.3555,26.7422))
		{//аэропорт
		    if (InEvent[playerid] == 0)
		    {//игрок не на соревнованиях
			    if (GetPlayerVirtualWorld(playerid) == 0) ShowPlayerDialog(playerid, DIALOG_AIRPORT, 2, "Аэропорт. Стоимость перелета: 50 000$", "{FFFFFF}Лос Сантос\nСан Фиерро\nЛас Вентурас", "ОК", "Отмена");
				else SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Аэропорт работает только в общем мире.");
			}//игрок не на соревнованиях
            xOnce = 1;
		}//аэропорт
		
		if (IsPlayerInRangeOfPoint(playerid,2,2397.7632,-1899.1389,13.5469) && QuestActive[playerid] == 0 && InEvent[playerid] == 0)
		{//Работа - Доставщик пиццы
            WorkPizzaID[playerid] = random(8) + 1; WorkPizzaCP[playerid] = 0; xOnce = 1;
		    QuestCar[playerid] = LCreateVehicle(448, 2386.8760, -1921.9377, 12.9784, 270.0, 3, 3, 0);
			PutPlayerInVehicle(playerid,QuestCar[playerid], 0); QuestActive[playerid] = 2; WorkTime[playerid] = 0;
			SendClientMessage(playerid, COLOR_QUEST, "Работа: Вовремя доставь пиццу {FF0000}клиентам{FFCC00} и вернись за зарплатой!");
			switch(WorkPizzaID[playerid])
			{
			    case 1: {WorkPizzaCPs[playerid] = 18; return SetPlayerRaceCheckpoint(playerid, 0, PIZZA1[0][0], PIZZA1[0][1], PIZZA1[0][2], PIZZA1[1][0], PIZZA1[1][1], PIZZA1[1][2], 7);}
			    case 2: {WorkPizzaCPs[playerid] = 19; return SetPlayerRaceCheckpoint(playerid, 0, PIZZA2[0][0], PIZZA2[0][1], PIZZA2[0][2], PIZZA2[1][0], PIZZA2[1][1], PIZZA2[1][2], 7);}
			    case 3: {WorkPizzaCPs[playerid] = 20; return SetPlayerRaceCheckpoint(playerid, 0, PIZZA3[0][0], PIZZA3[0][1], PIZZA3[0][2], PIZZA3[1][0], PIZZA3[1][1], PIZZA3[1][2], 7);}
			    case 4: {WorkPizzaCPs[playerid] = 21; return SetPlayerRaceCheckpoint(playerid, 0, PIZZA4[0][0], PIZZA4[0][1], PIZZA4[0][2], PIZZA4[1][0], PIZZA4[1][1], PIZZA4[1][2], 7);}
			    case 5: {WorkPizzaCPs[playerid] = 20; return SetPlayerRaceCheckpoint(playerid, 0, PIZZA5[0][0], PIZZA5[0][1], PIZZA5[0][2], PIZZA5[1][0], PIZZA5[1][1], PIZZA5[1][2], 7);}
			    case 6: {WorkPizzaCPs[playerid] = 25; return SetPlayerRaceCheckpoint(playerid, 0, PIZZA6[0][0], PIZZA6[0][1], PIZZA6[0][2], PIZZA6[1][0], PIZZA6[1][1], PIZZA6[1][2], 7);}
			    case 7: {WorkPizzaCPs[playerid] = 22; return SetPlayerRaceCheckpoint(playerid, 0, PIZZA7[0][0], PIZZA7[0][1], PIZZA7[0][2], PIZZA7[1][0], PIZZA7[1][1], PIZZA7[1][2], 7);}
			    case 8: {WorkPizzaCPs[playerid] = 20; return SetPlayerRaceCheckpoint(playerid, 0, PIZZA8[0][0], PIZZA8[0][1], PIZZA8[0][2], PIZZA8[1][0], PIZZA8[1][1], PIZZA8[1][2], 7);}
			}
		}//Работа - Доставщик пиццы
		
		//Работа - Грузчик (Конец)
        if (QuestActive[playerid] == 3){xOnce = 1; ShowPlayerDialog(playerid,DIALOG_WORKGRUZSTOP,0,"Грузчик - Завершить работу?","{FFFFFF}Завершить работу грузчиком?","Да","Отмена");}
        //Работа - Доставщика пиццы, Домушника (когда потерял транспорт и нажал Альт)
        if (QuestActive[playerid] == 2 || QuestActive[playerid] >= 4){xOnce = 1; ShowPlayerDialog(playerid,DIALOG_WORKSTOP,2,"Работа","Вызвать рабочий транспорт\n{FF0000}Завершить работу","ОК","Отмена");}

		if (IsPlayerInRangeOfPoint(playerid,2, 2729.3267, -2451.4578, 17.5937) && QuestActive[playerid] == 0 && InEvent[playerid] == 0)// Проверяем нахождение игрока в точках начала работы
        {//Работа - Грузчик (Старт)
            SendClientMessage(playerid, COLOR_QUEST, "Работа: Бери {FF0000}груз{FFCC00} и переноси его в точку назначения!");
			QuestActive[playerid] = 3; WorkTime[playerid] = 0; WorkTimeGruz[playerid] = 0; xOnce = 1;
            SetPVarInt(playerid,"WorkStage",1);// Устанавливаем момент работы, 1 - идём брать вещи. 2 - несём вещи.
            new checkp = random(sizeof GRUZFROM);// Рандомно выдаём координаты где брать груз
            ApplyAnimation(playerid,"CARRY","Null",4.1,0,1,1,1,1);//Прогружаем библиотеку с анимациями
            SetPlayerCheckpoint(playerid,GRUZFROM[checkp][0],GRUZFROM[checkp][1],GRUZFROM[checkp][2],1.5);// Создаём один из чекпоинтов
        }//Работа - Грузчик (Старт)
        
        if (IsPlayerInRangeOfPoint(playerid,2,-1972.5024,-1020.2568,32.1719) && QuestActive[playerid] == 0 && InEvent[playerid] == 0)
		{//Работа - Домушник
		    if (Player[playerid][Level] < 14) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 14-го уровня чтобы работать домушником!");
            new rand = random(MAX_PROPERTY); if (rand == 0) rand++;//Выбираем дом для ограбления
            if (rand == Player[playerid][Home]) {if (rand > 1) rand--; else rand++;}//Выбрался дом грабителя - исправляем
            SetPVarInt(playerid, "WorkDomStage", 1); QuestActive[playerid] = 4; WorkTime[playerid] = 0; xOnce = 1;
		    QuestCar[playerid] = LCreateVehicle(609, -1945.5354,-1085.3024,30.8479, 0.0, 25, 25, 0); PutPlayerInVehicle(playerid,QuestCar[playerid], 0);
			SendClientMessage(playerid, COLOR_QUEST, "Работа: Обчисти {FF0000}дом{FFCC00} и привези награбленное сюда!");
            SetPlayerCheckpoint(playerid,Property[rand][pPosEnterX],Property[rand][pPosEnterY],Property[rand][pPosEnterZ],2);
		}//Работа - Домушник
		
		if (IsPlayerInRangeOfPoint(playerid,2,-1061.6104,-1195.4755,129.8281) && QuestActive[playerid] == 0 && InEvent[playerid] == 0)
		{//Работа - Комбайнер
		    if (Player[playerid][Level] < 21) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 21-го уровня чтобы работать комбайнером!");
			new Float: wx = random(20) - 10 - 1096, Float: wy = random(20) - 10 - 992, Float: wz = 130, Float:wa = random(360);
		    QuestCar[playerid] = LCreateVehicle(532, wx, wy, wz, wa, 25, 25, 0); PutPlayerInVehicle(playerid,QuestCar[playerid], 0);
            QuestActive[playerid] = 5; WorkTime[playerid] = 0; xOnce = 1;
			SendClientMessage(playerid, COLOR_QUEST, "Работа: Разъезжай по {FF0000}полю{FFCC00} и коси овёс!");
            GangZoneShowForPlayer(playerid, WorkZoneCombine, 0xFF000080);
		}//Работа - Комбайнер
		
		if (IsPlayerInRangeOfPoint(playerid,2,2484.6682,-2120.8743,13.5469) && QuestActive[playerid] == 0 && InEvent[playerid] == 0)
		{//Работа - Дальнобойщик
		    if (Player[playerid][Level] < 28) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 28-го уровня чтобы работать дальнобойщиком!");
            new rand = random(sizeof WORKTRUCK);//Выбираем место доставки груза
            SetPlayerCheckpoint(playerid,WORKTRUCK[rand][0], WORKTRUCK[rand][1], WORKTRUCK[rand][2], 10);
	        SetPVarInt(playerid, "WorkTruckStage", 1); QuestActive[playerid] = 6; WorkTime[playerid] = 0; xOnce = 1;
		    QuestCar[playerid] = LCreateVehicle(515, 2453.7183, -2089.3940, 15.2, 90.0, 4, 4, 0); PutPlayerInVehicle(playerid,QuestCar[playerid], 0);
			CallTrailer(QuestCar[playerid], 584);
			SendClientMessage(playerid, COLOR_QUEST, "Работа: Доставь груз до {FF0000}места назначения{FFCC00} и вернись за зарплатой!");
		}//Работа - Дальнобойщик
		
		if (IsPlayerInRangeOfPoint(playerid,2,-1713.1389,-61.8556,3.5547) && QuestActive[playerid] == 0 && InEvent[playerid] == 0)
		{//Работа - Капитан Корабля
		    if (Player[playerid][Level] < 35) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 35-го уровня чтобы работать капитаном корабля!");
            new rand = random(sizeof WORKWATER);//Выбираем место доставки груза
            SetPlayerCheckpoint(playerid,WORKWATER[rand][0], WORKWATER[rand][1], WORKWATER[rand][2], 10);
	        SetPVarInt(playerid, "WorkWaterStage", 1); QuestActive[playerid] = 7; WorkTime[playerid] = 0; xOnce = 1;
		    QuestCar[playerid] = LCreateVehicle(452, -1759.8169,-192.7360,0.5, 270.0, 1, 2, 0); PutPlayerInVehicle(playerid,QuestCar[playerid], 0);
			SendClientMessage(playerid, COLOR_QUEST, "Работа: Доставь груз до {FF0000}места назначения{FFCC00} и вернись за зарплатой!");
		}//Работа - Капитан Корабля
		
		if (IsPlayerInRangeOfPoint(playerid,2,2364.8955,2382.8770,10.8203) && QuestActive[playerid] == 0 && InEvent[playerid] == 0)
		{//Работа - Инкассатор
		    if (Player[playerid][Level] < 42) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 42-го уровня чтобы работать инкассатором!");
            new rand = random(MAX_BASE); if (rand == 0) rand++;//Выбираем штаб для сбора денег
            SetPVarInt(playerid, "WorkBankStage", 1); QuestActive[playerid] = 8; WorkTime[playerid] = 0; xOnce = 1;
		    QuestCar[playerid] = LCreateVehicle(428, 2361.7593,2397.3511,10.9471, 0.0, 227, 4, 0); PutPlayerInVehicle(playerid,QuestCar[playerid], 0);
			SendClientMessage(playerid, COLOR_QUEST, "Работа: Собери деньги со {FF0000}штаба{FFCC00} и привези их сюда!");
            SetPlayerCheckpoint(playerid,Base[rand][bPosEnterX],Base[rand][bPosEnterY],Base[rand][bPosEnterZ],2);
		}//Работа - Инкассатор
		
		if (xOnce == 0 && SkinChangeMode[playerid] == 0)
		{//Меню быстрого доступа
		    if (InEvent[playerid] == 0)
		    {//Игрок не в соревнованиях
				if (Player[playerid][Level] > 0) ShowPlayerDialog(playerid, 2, 2, "Меню быстрого доступа", "Сесть в машину [Класс 1]\nСесть в машину [Класс 2]\nСесть в машину [Класс 3]\nНадеть JetPack (/jetpack)\nПрыгнуть с парашютом (/skydive)\n{FF0000}GPS (/gps){FFFFFF}\nИзменить мои автомобили\nИзменить мои навыки\nНастройки PvP\n{FFFF00}Открыть КПК", "ОК", "");
				else ShowPlayerDialog(playerid, 2, 2, "Меню быстрого доступа", "Сесть в машину [Класс 1]", "ОК", "");
			}//Игрок не в соревнованиях
			if (JoinEvent[playerid] == EVENT_RACE && TimeTransform[playerid] == 0)
			{//Вызов транспорта в обычной гонке
			    new Float: x, Float: y, Float: z, Float: Angle, col1 = random(187), col2 = random(187);
			    GetPlayerPos(playerid,x,y,z);GetPlayerFacingAngle(playerid, Angle);
			    FRCarID[playerid] = LCreateVehicle(FRModelCar, x, y, z, Angle, col1, col2, 0);
				SetVehicleVirtualWorld(FRCarID[playerid], 661);PutPlayerInVehicle(playerid, FRCarID[playerid], 0);
                new rand = random(3);ChangeVehiclePaintjob(GetPlayerVehicleID(playerid), rand);//случайный paintjob
				//Ниже закрываем двери
				new engine, lights, alarm, doors, bonnet, boot, objective; TimeTransform[playerid] = 5;
			    GetVehicleParamsEx(FRCarID[playerid], engine, lights, alarm, doors, bonnet, boot, objective);
			    SetVehicleParamsEx(FRCarID[playerid], engine, lights, alarm, true, bonnet, boot, objective);
                SendClientMessage(playerid,COLOR_CYAN,"Подсказка: Если ваша машина перевернулась в гонке, используйте клавишу гудка чтобы поставить ее на колеса");
			}//Вызов транспорта в обычной гонке
			if (JoinEvent[playerid] == EVENT_XRACE && TimeTransform[playerid] == 0)
			{//Вызов транспорта в легендарной гонке
			    new Float: x, Float: y, Float: z, Float: Angle, col1 = random(187), col2 = random(187);
				GetPlayerPos(playerid,x,y,z);GetPlayerFacingAngle(playerid, Angle);
				XRCarID[playerid] = LCreateVehicle(XRPlayerCar[playerid], x, y, z, Angle, col1, col2, 0);
				SetVehicleVirtualWorld(XRCarID[playerid], 700);PutPlayerInVehicle(playerid, XRCarID[playerid], 0);
                new rand = random(3);ChangeVehiclePaintjob(GetPlayerVehicleID(playerid), rand);//случайный paintjob
				//Ниже закрываем двери
				new engine, lights, alarm, doors, bonnet, boot, objective; TimeTransform[playerid] = 5;
			    GetVehicleParamsEx(XRCarID[playerid], engine, lights, alarm, doors, bonnet, boot, objective);
			    SetVehicleParamsEx(XRCarID[playerid], engine, lights, alarm, true, bonnet, boot, objective);
			}//Вызов транспорта в легендарной гонке
		}//Меню быстрого доступа
		SendCommand(playerid, "/house", ""); SendCommand(playerid, "/base", "");//------ дом, штаб
	}//нажал альт - банк, дом, штаб, рулетка, аэропорт
	
    if(QuestActive[playerid] == 3 && GetPVarInt(playerid,"WorkStage") == 2)
    {//грузчик, несущий груз
    	if(newkeys == KEY_SECONDARY_ATTACK || newkeys == KEY_JUMP || newkeys == KEY_SECONDARY_ATTACK || newkeys == KEY_FIRE || newkeys == KEY_CROUCH)
        {//обранил груз
        	RemovePlayerAttachedObject(playerid,0);// Удаляем объект из рук
            ApplyAnimation(playerid,"PED","IDLE_tired",4.1,0,1,1,0,1);// Обнуляем анимацию
            SetPVarInt(playerid,"WorkStage",1);// Устанавливаем момент работы игрока на 1..
            new checkp = random(sizeof GRUZFROM);
            SetPlayerCheckpoint(playerid,GRUZFROM[checkp][0],GRUZFROM[checkp][1],GRUZFROM[checkp][2],1.5);// Создаём один из чекпоинтов
        }//обранил груз
    }//грузчик, несущий груз

	//moto nitro
 	if (PRESSED(KEY_FIRE)  || PRESSED(KEY_ACTION))
	{//кнопки нитро
		 if (((Player[playerid][CarActive] == 1 && Player[playerid][CarSlot1NitroX] >= 2) || (Player[playerid][CarActive] == 2 && Player[playerid][CarSlot2NitroX] >= 2)) && InEvent[playerid] == 0 && QuestActive[playerid] == 0)
		 {//UberNitro класс 1, 2
		    if (UberNitroTime[playerid] > 0)
		    {//UberNitro еще недоступно
		        new StringZ[20];
				format(StringZ, sizeof StringZ, "~R~%d sec", UberNitroTime[playerid]);
		        GameTextForPlayer(playerid, StringZ, 1000, 6);
		    }//UberNitro еще недоступно
		    else
		    {//UberNitro доступно
		        new vehicleid = GetPlayerVehicleID(playerid), MaxSpeed = GetVehicleMaxSpeed(vehicleid);
		        if (MaxSpeed > 250) MaxSpeed = 250;//для мотоциклов и тд, где макс. скорость 300
				SetVehicleSpeed(vehicleid, MaxSpeed);
				LastSpeed[playerid] = MaxSpeed; LACSH[playerid] = 3; UberNitroTime[playerid] = 5;
				SetPlayerChatBubble(playerid, "Использовал UberNitro", COLOR_GREEN, 300.0, 3000);
			}//UberNitro доступно
		}//UberNitro класс 1, 2
	}//кнопки нитро
	
	//ubervortex
	if (Player[playerid][Level] >= 90 && Player[playerid][CarActive] == 3)
	{//ubervortex
		new vehid = GetPlayerVehicleID(playerid);
		new model = GetVehicleModel(vehid);
		if(model == 539)
		{//ubervortex
			if (PRESSED(KEY_SUBMISSION))
			{//2 - взлет
			    new Float:Velocity[3];
				GetVehicleVelocity(vehid, Velocity[0], Velocity[1], Velocity[2]);
				SetVehicleVelocity(vehid, Velocity[0], Velocity[1], Velocity[2] + 0.25);
				NeedSpeedDown[playerid] = 1;LACTeleportOff[playerid] = 3;
			}//2 - взлет
			if (PRESSED(KEY_CROUCH))
			{//H - приземление
			    new Float:Velocity[3];
				GetVehicleVelocity(vehid, Velocity[0], Velocity[1], Velocity[2]);
				SetVehicleVelocity(vehid, Velocity[0], Velocity[1], Velocity[2] - 0.25);
				LastSpeed[playerid] = 999;LACSH[playerid] = 10;LACTeleportOff[playerid] = 3;
			}//H - приземление
   			if (newkeys & KEY_FIRE || newkeys & KEY_ACTION)
			{//Альт - ускорение
			    new Float:Velocity[3];
				GetVehicleVelocity(vehid, Velocity[0], Velocity[1], Velocity[2]);
				if(Velocity[0] < 4  && Velocity[1] < 4 && Velocity[0] > -4 && Velocity[1] > -4)
				{
					SetVehicleVelocity(vehid, Velocity[0]*2, Velocity[1]*2, Velocity[2] * 0.8);
					NeedSpeedDown[playerid] = 1; LACSH[playerid] = 5;LACTeleportOff[playerid] = 3;
				}
			}//Альт - ускорение
		}
	}//ubervortex

	if(PRESSED(KEY_SUBMISSION) && Player[playerid][CarActive] == 1 && Player[playerid][ActiveSkillCar1] > 0 &&  JumpTime[playerid] == 0 && LSpecID[playerid] == -1 && InEvent[playerid] == 0 && QuestActive[playerid] == 0)
	{//навыки авто класса 1
	    new vehid = GetPlayerVehicleID(playerid);new Float:Velocity[3];
	    if (Player[playerid][ActiveSkillCar1] == 1)
	    {//Разворот на 180
	         new Float: vang;GetVehicleZAngle(vehid, vang);SetVehicleZAngle(vehid, vang - 180.0);
	         GetVehicleVelocity(vehid, Velocity[0], Velocity[1], Velocity[2]);SetVehicleVelocity(vehid, Velocity[0] * -1, Velocity[1] * -1, Velocity[2] * -1);
	         SetPlayerChatBubble(playerid, "Использовал навык", COLOR_GREEN, 100.0, 3000);
	         JumpTime[playerid] = 3;SetCameraBehindPlayer(playerid);
	    }//Разворот на 180
	    if (Player[playerid][ActiveSkillCar1] == 2)
	    {//прыжок
	         GetVehicleVelocity(vehid, Velocity[0], Velocity[1], Velocity[2]);SetVehicleVelocity(vehid, Velocity[0], Velocity[1], Velocity[2] + 0.5);
	         SetPlayerChatBubble(playerid, "Использовал навык", COLOR_GREEN, 100.0, 3000);
	         JumpTime[playerid] = 3;LACSH[playerid] = 5;LACTeleportOff[playerid] = 3;
	    }//прыжок
	    if (Player[playerid][ActiveSkillCar1] == 3)
	    {//трамплин
	         new Float:x, Float:y, Float:z, Float:angle;GetPlayerPos(playerid, x, y, z);
		     angle = GetXYInFrontOfPlayer(playerid, x, y, GetOptimumRampDistance(playerid));
		 	 rampid[playerid] = CreateDynamicObject(1632, x, y, z, 0.0, 0.0, angle, GetPlayerVirtualWorld(playerid), -1, -1, 300.0);//Стандартные трамплины
	         SetTimerEx("RemoveRamp", 2000, 0, "d", playerid);
			 SetPlayerChatBubble(playerid, "Использовал навык", COLOR_GREEN, 100.0, 3000);JumpTime[playerid] = 3;
	    }//трамплин
	    
	}//навыки авто класса 1
	
	if(PRESSED(KEY_SUBMISSION) && Player[playerid][CarActive] == 2 && Player[playerid][ActiveSkillCar2] > 0 &&  JumpTime[playerid] == 0 && LSpecID[playerid] == -1 && InEvent[playerid] == 0 && QuestActive[playerid] == 0)
	{//навыки авто класса 2
	    new vehid = GetPlayerVehicleID(playerid);new Float:Velocity[3];
	    if (Player[playerid][ActiveSkillCar2] == 1)
	    {//Разворот на 180
	         new Float: vang;GetVehicleZAngle(vehid, vang);SetVehicleZAngle(vehid, vang - 180.0);
	         GetVehicleVelocity(vehid, Velocity[0], Velocity[1], Velocity[2]);SetVehicleVelocity(vehid, Velocity[0] * -1, Velocity[1] * -1, Velocity[2] * -1);
	         SetPlayerChatBubble(playerid, "Использовал навык", COLOR_GREEN, 100.0, 3000);
	         JumpTime[playerid] = 4;SetCameraBehindPlayer(playerid);
	    }//Разворот на 180
	    if (Player[playerid][ActiveSkillCar2] == 2)
	    {//прыжок
	         GetVehicleVelocity(vehid, Velocity[0], Velocity[1], Velocity[2]);SetVehicleVelocity(vehid, Velocity[0], Velocity[1], Velocity[2] + 0.5);
	         SetPlayerChatBubble(playerid, "Использовал навык", COLOR_GREEN, 100.0, 3000);
	         JumpTime[playerid] = 4;LACSH[playerid] = 5;LACTeleportOff[playerid] = 3;
	    }//прыжок
	    if (Player[playerid][ActiveSkillCar2] == 3)
	    {//трамплин
	         new Float:x, Float:y, Float:z, Float:angle;GetPlayerPos(playerid, x, y, z);
		     angle = GetXYInFrontOfPlayer(playerid, x, y, GetOptimumRampDistance(playerid));
		 	 rampid[playerid] = CreateDynamicObject(1632, x, y, z, 0.0, 0.0, angle, GetPlayerVirtualWorld(playerid), -1, -1, 300.0);//Стандартные трамплины
	         SetTimerEx("RemoveRamp", 2000, 0, "d", playerid);
			 SetPlayerChatBubble(playerid, "Использовал навык", COLOR_GREEN, 100.0, 3000);JumpTime[playerid] = 3;
	    }//трамплин
	}//навыки авто класса 2
	
	if (Player[playerid][Level] >= 100 && PRESSED(KEY_NO) && !IsPlayerInAnyVehicle(playerid) && GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USEJETPACK)
	{//UberJetpack
     	new Float: x, Float: y, Float: z;GetPlayerVelocity(playerid,x,y,z);
	    SetPlayerVelocity(playerid,x*5,y*5,0.0);
		LACTeleportOff[playerid] = 5; LACPedSHOff[playerid] = 5;
	    SetPlayerChatBubble(playerid, "Использует Ускоритель", COLOR_GREEN, 100.0, 3000);
	}//UberJetpack
	
	if (Player[playerid][ActiveSkillPerson] > 0)
	{//навык персонажа
		if(PRESSED(KEY_NO) && !IsPlayerInAnyVehicle(playerid) && GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_USEJETPACK && SkillNTime[playerid] < 1 && InEvent[playerid] == 0 && QuestActive[playerid] == 0)
		{//на N
		    if (Player[playerid][ActiveSkillPerson] == 1)
		    {//тп на 50 метров
		        if (GetPlayerInterior(playerid) != 0 || IsPlayerInRangeOfPoint(playerid, 13.0, 2311.6953,-7.4206,26.7422)) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вы должны быть на улице, чтобы использовать этот навык");
			    new Float: x, Float: y;GetXYInFrontOfPlayer(playerid,x,y,50.0);
			    SetPlayerPosFindZ(playerid, x, y, 3000.0);SkillNTime[playerid] = 5;
			    SetPlayerChatBubble(playerid, "Использовал навык", COLOR_GREEN, 100.0, 3000);
		    }//тп на 50 метров
		    if (Player[playerid][ActiveSkillPerson] == 2)
		    {//тп на 100 метров
		        if (GetPlayerInterior(playerid) != 0 || IsPlayerInRangeOfPoint(playerid, 13.0, 2311.6953,-7.4206,26.7422)) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вы должны быть на улице, чтобы использовать этот навык");
			    new Float: x, Float: y;GetXYInFrontOfPlayer(playerid,x,y,100.0);
			    SetPlayerPosFindZ(playerid, x, y, 3000.0);SkillNTime[playerid] = 5;
			    SetPlayerChatBubble(playerid, "Использовал навык", COLOR_GREEN, 100.0, 3000);
		    }//тп на 100 метров
		    if (Player[playerid][ActiveSkillPerson] == 3)
		    {//тп на 300 метров
		        if (GetPlayerInterior(playerid) != 0 || IsPlayerInRangeOfPoint(playerid, 13.0, 2311.6953,-7.4206,26.7422)) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вы должны быть на улице, чтобы использовать этот навык");
			    new Float: x, Float: y;GetXYInFrontOfPlayer(playerid,x,y,200.0);
			    SetPlayerPosFindZ(playerid, x, y, 3000.0);SkillNTime[playerid] = 5;
			    SetPlayerChatBubble(playerid, "Использовал навык", COLOR_GREEN, 100.0, 3000);
		    }//тп на 300 метров
		    if (Player[playerid][ActiveSkillPerson] == 4)
		    {//Режим Супермена
		        if (OnFly[playerid] == 0 && Player[playerid][Prestige] >= 8)//Проверка на 8 престиж нужна т.к. раньше он был на 2 престиже
				{
				    if (GetPlayerInterior(playerid) != 0 || IsPlayerInRangeOfPoint(playerid, 13.0, 2311.6953,-7.4206,26.7422)) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вы должны быть на улице, чтобы использовать этот навык");
			    	else StartFly(playerid);
				}
				else StopFly(playerid);
		    }//Режим Супермена
		}//на N
	}//Навык персонажа
		
	if(PRESSED(KEY_YES) && !IsPlayerInAnyVehicle(playerid) && Player[playerid][Prestige] >= 10 && SkillYTime[playerid] < 1 && InEvent[playerid] == 0)
	{//Режим Бога
		if (PrestigeGM[playerid] == 0){PrestigeGM[playerid] = 1;SendClientMessage(playerid,0x00FF00FF,"Режим Бога активирован.");}
	    else ShowPlayerDialog(playerid, DIALOG_PRESTIGEGM, 2, "Режим Бога", "{FF0000}Отключить режим Бога\nТелепорт к маркеру GPS\nРеспавн", "ОК", "Отмена");
	}//Режим Бога

	if (Player[playerid][ActiveSkillHCar1] > 0 || Player[playerid][ActiveSkillHCar2] > 0)
	{//Навык H авто класс 1
		if(PRESSED(KEY_CROUCH) && IsPlayerInAnyVehicle(playerid) && SkillHTime[playerid] < 1 && InEvent[playerid] == 0 && QuestActive[playerid] == 0)
		{//на H
		    if (Player[playerid][CarActive] == 1)
		    {//Класс 1
		        if (Player[playerid][ActiveSkillHCar1] == 1)
		        {//Перевернуть транспорт на колеса
		        	new Float: aangle;
				    SkillHTime[playerid] = 5;SetPlayerChatBubble(playerid, "Перевернул транспорт", COLOR_GREEN, 300.0, 3000);
				    GetVehicleZAngle(GetPlayerVehicleID(playerid), aangle);SetVehicleZAngle(GetPlayerVehicleID(playerid), aangle);
		            SendClientMessage(playerid,COLOR_GREEN,"Вы перевернули ваш транспорт на колеса.");
		        }//Перевернуть транспорт на колеса
			    if (Player[playerid][ActiveSkillHCar1] == 2)
			    {//тп на 50 метров
			        if (GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вы должны быть на улице, чтобы использовать этот навык");
				    new Float: x, Float: y;GetXYInFrontOfPlayer(playerid,x,y,50.0);
				    SetPlayerPosFindZ(playerid, x, y, 3000.0);SkillHTime[playerid] = 5;
				    SetPlayerChatBubble(playerid, "Использовал навык", COLOR_GREEN, 100.0, 3000);
				    new CarClass = Player[playerid][CarActive];TimeTransform[playerid] = 0;
				    new S1 = -1, S2 = -1, S3 = -1;
				    foreach(Player, cid)
					{//цикл
						if(GetPlayerVehicleID(cid) == GetPlayerVehicleID(playerid) && GetPlayerVehicleSeat(cid) > 0)
						{//запись пассажиров
							if(GetPlayerVehicleSeat(cid) == 1){S1 = cid;}
							if(GetPlayerVehicleSeat(cid) == 2){S2 = cid;}
							if(GetPlayerVehicleSeat(cid) == 3){S3 = cid;}
						}//запись пассажиров
					}
	                SetTimerEx("PrestigeCarTP" , 500, false, "idiii", playerid, CarClass, S1, S2, S3);
	                TogglePlayerControllable(playerid,0);DestroyVehicle(PlayerCarID[playerid]);
			    }//тп на 50 метров
			    if (Player[playerid][ActiveSkillHCar1] == 3)
			    {//тп на 100 метров
			        if (GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вы должны быть на улице, чтобы использовать этот навык");
	                new Float: x, Float: y;GetXYInFrontOfPlayer(playerid,x,y,100.0);
				    SetPlayerPosFindZ(playerid, x, y, 3000.0);SkillHTime[playerid] = 5;
				    SetPlayerChatBubble(playerid, "Использовал навык", COLOR_GREEN, 100.0, 3000);
				    new CarClass = Player[playerid][CarActive];TimeTransform[playerid] = 0;
				    new S1 = -1, S2 = -1, S3 = -1;
				    foreach(Player, cid)
					{//цикл
						if(GetPlayerVehicleID(cid) == GetPlayerVehicleID(playerid) && GetPlayerVehicleSeat(cid) > 0)
						{//запись пассажиров
							if(GetPlayerVehicleSeat(cid) == 1){S1 = cid;}
							if(GetPlayerVehicleSeat(cid) == 2){S2 = cid;}
							if(GetPlayerVehicleSeat(cid) == 3){S3 = cid;}
						}//запись пассажиров
					}
	                SetTimerEx("PrestigeCarTP" , 500, false, "idiii", playerid, CarClass, S1, S2, S3);
	                TogglePlayerControllable(playerid,0);DestroyVehicle(PlayerCarID[playerid]);
			    }//тп на 100 метров
			    if (Player[playerid][ActiveSkillHCar1] == 4)
			    {//тп на 200 метров
			        if (GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вы должны быть на улице, чтобы использовать этот навык");
	                new Float: x, Float: y;GetXYInFrontOfPlayer(playerid,x,y,200.0);
				    SetPlayerPosFindZ(playerid, x, y, 3000.0);SkillHTime[playerid] = 5;
				    SetPlayerChatBubble(playerid, "Использовал навык", COLOR_GREEN, 100.0, 3000);
				    new CarClass = Player[playerid][CarActive];TimeTransform[playerid] = 0;
				    new S1 = -1, S2 = -1, S3 = -1;
				    foreach(Player, cid)
					{//цикл
						if(GetPlayerVehicleID(cid) == GetPlayerVehicleID(playerid) && GetPlayerVehicleSeat(cid) > 0)
						{//запись пассажиров
							if(GetPlayerVehicleSeat(cid) == 1){S1 = cid;}
							if(GetPlayerVehicleSeat(cid) == 2){S2 = cid;}
							if(GetPlayerVehicleSeat(cid) == 3){S3 = cid;}
						}//запись пассажиров
					}
	                SetTimerEx("PrestigeCarTP" , 500, false, "idiii", playerid, CarClass, S1, S2, S3);
	                TogglePlayerControllable(playerid,0);DestroyVehicle(PlayerCarID[playerid]);
			    }//тп на 100 метров
			    if (Player[playerid][ActiveSkillHCar1] == 5)
			    {//тп на 50 метров со скоростью
			        if (GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вы должны быть на улице, чтобы использовать этот навык");
				    new Float: x, Float: y;GetXYInFrontOfPlayer(playerid,x,y,50.0);
				    SetPlayerPosFindZ(playerid, x, y, 3000.0);SkillHTime[playerid] = 5;
				    SetPlayerChatBubble(playerid, "Использовал навык", COLOR_GREEN, 100.0, 3000);
				    new CarClass = Player[playerid][CarActive];TimeTransform[playerid] = 0;
				    new S1 = -1, S2 = -1, S3 = -1;
				    foreach(Player, cid)
					{//цикл
						if(GetPlayerVehicleID(cid) == GetPlayerVehicleID(playerid) && GetPlayerVehicleSeat(cid) > 0)
						{//запись пассажиров
							if(GetPlayerVehicleSeat(cid) == 1){S1 = cid;}
							if(GetPlayerVehicleSeat(cid) == 2){S2 = cid;}
							if(GetPlayerVehicleSeat(cid) == 3){S3 = cid;}
						}//запись пассажиров
					}
					new Float: vel1, Float: vel2, Float: vel3;GetVehicleVelocity(GetPlayerVehicleID(playerid), vel1, vel2, vel3);
	                SetTimerEx("PrestigeCarTPx" , 500, false, "idiiifff", playerid, CarClass, S1, S2, S3, vel1, vel2, vel3);
	                TogglePlayerControllable(playerid,0);DestroyVehicle(PlayerCarID[playerid]);
			    }//тп на 50 метров
			    if (Player[playerid][ActiveSkillHCar1] == 6)
			    {//тп на 100 метров со скоростью
			        if (GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вы должны быть на улице, чтобы использовать этот навык");
				    new Float: x, Float: y;GetXYInFrontOfPlayer(playerid,x,y,100.0);
				    SetPlayerPosFindZ(playerid, x, y, 3000.0);SkillHTime[playerid] = 5;
				    SetPlayerChatBubble(playerid, "Использовал навык", COLOR_GREEN, 100.0, 3000);
				    new CarClass = Player[playerid][CarActive];TimeTransform[playerid] = 0;
				    new S1 = -1, S2 = -1, S3 = -1;
				    foreach(Player, cid)
					{//цикл
						if(GetPlayerVehicleID(cid) == GetPlayerVehicleID(playerid) && GetPlayerVehicleSeat(cid) > 0)
						{//запись пассажиров
							if(GetPlayerVehicleSeat(cid) == 1){S1 = cid;}
							if(GetPlayerVehicleSeat(cid) == 2){S2 = cid;}
							if(GetPlayerVehicleSeat(cid) == 3){S3 = cid;}
						}//запись пассажиров
					}
					new Float: vel1, Float: vel2, Float: vel3;GetVehicleVelocity(GetPlayerVehicleID(playerid), vel1, vel2, vel3);
	                SetTimerEx("PrestigeCarTPx" , 500, false, "idiiifff", playerid, CarClass, S1, S2, S3, vel1, vel2, vel3);
	                TogglePlayerControllable(playerid,0);DestroyVehicle(PlayerCarID[playerid]);
			    }//тп на 100 метров
			    if (Player[playerid][ActiveSkillHCar1] == 7)
			    {//тп на 200 метров со скоростью
			        if (GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вы должны быть на улице, чтобы использовать этот навык");
				    new Float: x, Float: y;GetXYInFrontOfPlayer(playerid,x,y,200.0);
				    SetPlayerPosFindZ(playerid, x, y, 3000.0);SkillHTime[playerid] = 5;
				    SetPlayerChatBubble(playerid, "Использовал навык", COLOR_GREEN, 100.0, 3000);
				    new CarClass = Player[playerid][CarActive];TimeTransform[playerid] = 0;
				    new S1 = -1, S2 = -1, S3 = -1;
				    foreach(Player, cid)
					{//цикл
						if(GetPlayerVehicleID(cid) == GetPlayerVehicleID(playerid) && GetPlayerVehicleSeat(cid) > 0)
						{//запись пассажиров
							if(GetPlayerVehicleSeat(cid) == 1){S1 = cid;}
							if(GetPlayerVehicleSeat(cid) == 2){S2 = cid;}
							if(GetPlayerVehicleSeat(cid) == 3){S3 = cid;}
						}//запись пассажиров
					}
					new Float: vel1, Float: vel2, Float: vel3;GetVehicleVelocity(GetPlayerVehicleID(playerid), vel1, vel2, vel3);
	                SetTimerEx("PrestigeCarTPx" , 500, false, "idiiifff", playerid, CarClass, S1, S2, S3, vel1, vel2, vel3);
	                TogglePlayerControllable(playerid,0);DestroyVehicle(PlayerCarID[playerid]);
			    }//тп на 200 метров
			    if (Player[playerid][ActiveSkillHCar1] == 8){if(OnVehFly[playerid] == 0) StartVehFly(playerid); else StopVehFly(playerid);}//Режим Полета на авто
			}//Класс 1
		    if (Player[playerid][CarActive] == 2)
		    {//Класс 2
		        if (Player[playerid][ActiveSkillHCar2] == 1)
		        {//Перевернуть транспорт на колеса
		        	new Float: aangle;
				    SkillHTime[playerid] = 5;SetPlayerChatBubble(playerid, "Перевернул транспорт", COLOR_GREEN, 300.0, 3000);
				    GetVehicleZAngle(GetPlayerVehicleID(playerid), aangle);SetVehicleZAngle(GetPlayerVehicleID(playerid), aangle);
		            SendClientMessage(playerid,COLOR_GREEN,"Вы перевернули ваш транспорт на колеса.");
		        }//Перевернуть транспорт на колеса
			    if (Player[playerid][ActiveSkillHCar2] == 2)
			    {//тп на 50 метров
			        if (GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вы должны быть на улице, чтобы использовать этот навык");
				    new Float: x, Float: y;GetXYInFrontOfPlayer(playerid,x,y,50.0);
				    SetPlayerPosFindZ(playerid, x, y, 3000.0);SkillHTime[playerid] = 5;
				    SetPlayerChatBubble(playerid, "Использовал навык", COLOR_GREEN, 100.0, 3000);
				    new CarClass = Player[playerid][CarActive];TimeTransform[playerid] = 0;
				    new S1 = -1, S2 = -1, S3 = -1;
				    foreach(Player, cid)
					{//цикл
						if(GetPlayerVehicleID(cid) == GetPlayerVehicleID(playerid) && GetPlayerVehicleSeat(cid) > 0)
						{//запись пассажиров
							if(GetPlayerVehicleSeat(cid) == 1){S1 = cid;}
							if(GetPlayerVehicleSeat(cid) == 2){S2 = cid;}
							if(GetPlayerVehicleSeat(cid) == 3){S3 = cid;}
						}//запись пассажиров
					}
	                SetTimerEx("PrestigeCarTP" , 500, false, "idiii", playerid, CarClass, S1, S2, S3);
	                TogglePlayerControllable(playerid,0);DestroyVehicle(PlayerCarID[playerid]);
			    }//тп на 50 метров
			    if (Player[playerid][ActiveSkillHCar2] == 3)
			    {//тп на 100 метров
			        if (GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вы должны быть на улице, чтобы использовать этот навык");
	                new Float: x, Float: y;GetXYInFrontOfPlayer(playerid,x,y,100.0);
				    SetPlayerPosFindZ(playerid, x, y, 3000.0);SkillHTime[playerid] = 5;
				    SetPlayerChatBubble(playerid, "Использовал навык", COLOR_GREEN, 100.0, 3000);
				    new CarClass = Player[playerid][CarActive];TimeTransform[playerid] = 0;
				    new S1 = -1, S2 = -1, S3 = -1;
				    foreach(Player, cid)
					{//цикл
						if(GetPlayerVehicleID(cid) == GetPlayerVehicleID(playerid) && GetPlayerVehicleSeat(cid) > 0)
						{//запись пассажиров
							if(GetPlayerVehicleSeat(cid) == 1){S1 = cid;}
							if(GetPlayerVehicleSeat(cid) == 2){S2 = cid;}
							if(GetPlayerVehicleSeat(cid) == 3){S3 = cid;}
						}//запись пассажиров
					}
	                SetTimerEx("PrestigeCarTP" , 500, false, "idiii", playerid, CarClass, S1, S2, S3);
	                TogglePlayerControllable(playerid,0);DestroyVehicle(PlayerCarID[playerid]);
			    }//тп на 100 метров
			    if (Player[playerid][ActiveSkillHCar2] == 4)
			    {//тп на 200 метров
			        if (GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вы должны быть на улице, чтобы использовать этот навык");
	                new Float: x, Float: y;GetXYInFrontOfPlayer(playerid,x,y,200.0);
				    SetPlayerPosFindZ(playerid, x, y, 3000.0);SkillHTime[playerid] = 5;
				    SetPlayerChatBubble(playerid, "Использовал навык", COLOR_GREEN, 100.0, 3000);
				    new CarClass = Player[playerid][CarActive];TimeTransform[playerid] = 0;
				    new S1 = -1, S2 = -1, S3 = -1;
				    foreach(Player, cid)
					{//цикл
						if(GetPlayerVehicleID(cid) == GetPlayerVehicleID(playerid) && GetPlayerVehicleSeat(cid) > 0)
						{//запись пассажиров
							if(GetPlayerVehicleSeat(cid) == 1){S1 = cid;}
							if(GetPlayerVehicleSeat(cid) == 2){S2 = cid;}
							if(GetPlayerVehicleSeat(cid) == 3){S3 = cid;}
						}//запись пассажиров
					}
	                SetTimerEx("PrestigeCarTP" , 500, false, "idiii", playerid, CarClass, S1, S2, S3);
	                TogglePlayerControllable(playerid,0);DestroyVehicle(PlayerCarID[playerid]);
			    }//тп на 100 метров
			    if (Player[playerid][ActiveSkillHCar2] == 5)
			    {//тп на 50 метров со скоростью
			        if (GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вы должны быть на улице, чтобы использовать этот навык");
				    new Float: x, Float: y;GetXYInFrontOfPlayer(playerid,x,y,50.0);
				    SetPlayerPosFindZ(playerid, x, y, 3000.0);SkillHTime[playerid] = 5;
				    SetPlayerChatBubble(playerid, "Использовал навык", COLOR_GREEN, 100.0, 3000);
				    new CarClass = Player[playerid][CarActive];TimeTransform[playerid] = 0;
				    new S1 = -1, S2 = -1, S3 = -1;
				    foreach(Player, cid)
					{//цикл
						if(GetPlayerVehicleID(cid) == GetPlayerVehicleID(playerid) && GetPlayerVehicleSeat(cid) > 0)
						{//запись пассажиров
							if(GetPlayerVehicleSeat(cid) == 1){S1 = cid;}
							if(GetPlayerVehicleSeat(cid) == 2){S2 = cid;}
							if(GetPlayerVehicleSeat(cid) == 3){S3 = cid;}
						}//запись пассажиров
					}
					new Float: vel1, Float: vel2, Float: vel3;GetVehicleVelocity(GetPlayerVehicleID(playerid), vel1, vel2, vel3);
	                SetTimerEx("PrestigeCarTPx" , 500, false, "idiiifff", playerid, CarClass, S1, S2, S3, vel1, vel2, vel3);
	                TogglePlayerControllable(playerid,0);DestroyVehicle(PlayerCarID[playerid]);
			    }//тп на 50 метров
			    if (Player[playerid][ActiveSkillHCar2] == 6)
			    {//тп на 100 метров со скоростью
			        if (GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вы должны быть на улице, чтобы использовать этот навык");
				    new Float: x, Float: y;GetXYInFrontOfPlayer(playerid,x,y,100.0);
				    SetPlayerPosFindZ(playerid, x, y, 3000.0);SkillHTime[playerid] = 5;
				    SetPlayerChatBubble(playerid, "Использовал навык", COLOR_GREEN, 100.0, 3000);
				    new CarClass = Player[playerid][CarActive];TimeTransform[playerid] = 0;
				    new S1 = -1, S2 = -1, S3 = -1;
				    foreach(Player, cid)
					{//цикл
						if(GetPlayerVehicleID(cid) == GetPlayerVehicleID(playerid) && GetPlayerVehicleSeat(cid) > 0)
						{//запись пассажиров
							if(GetPlayerVehicleSeat(cid) == 1){S1 = cid;}
							if(GetPlayerVehicleSeat(cid) == 2){S2 = cid;}
							if(GetPlayerVehicleSeat(cid) == 3){S3 = cid;}
						}//запись пассажиров
					}
					new Float: vel1, Float: vel2, Float: vel3;GetVehicleVelocity(GetPlayerVehicleID(playerid), vel1, vel2, vel3);
	                SetTimerEx("PrestigeCarTPx" , 500, false, "idiiifff", playerid, CarClass, S1, S2, S3, vel1, vel2, vel3);
	                TogglePlayerControllable(playerid,0);DestroyVehicle(PlayerCarID[playerid]);
			    }//тп на 100 метров
			    if (Player[playerid][ActiveSkillHCar2] == 7)
			    {//тп на 200 метров со скоростью
			        if (GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вы должны быть на улице, чтобы использовать этот навык");
				    new Float: x, Float: y;GetXYInFrontOfPlayer(playerid,x,y,200.0);
				    SetPlayerPosFindZ(playerid, x, y, 3000.0);SkillHTime[playerid] = 5;
				    SetPlayerChatBubble(playerid, "Использовал навык", COLOR_GREEN, 100.0, 3000);
				    new CarClass = Player[playerid][CarActive];TimeTransform[playerid] = 0;
				    new S1 = -1, S2 = -1, S3 = -1;
				    foreach(Player, cid)
					{//цикл
						if(GetPlayerVehicleID(cid) == GetPlayerVehicleID(playerid) && GetPlayerVehicleSeat(cid) > 0)
						{//запись пассажиров
							if(GetPlayerVehicleSeat(cid) == 1){S1 = cid;}
							if(GetPlayerVehicleSeat(cid) == 2){S2 = cid;}
							if(GetPlayerVehicleSeat(cid) == 3){S3 = cid;}
						}//запись пассажиров
					}
					new Float: vel1, Float: vel2, Float: vel3;GetVehicleVelocity(GetPlayerVehicleID(playerid), vel1, vel2, vel3);
	                SetTimerEx("PrestigeCarTPx" , 500, false, "idiiifff", playerid, CarClass, S1, S2, S3, vel1, vel2, vel3);
	                TogglePlayerControllable(playerid,0);DestroyVehicle(PlayerCarID[playerid]);
			    }//тп на 200 метров
			    if (Player[playerid][ActiveSkillHCar2] == 8){if(OnVehFly[playerid] == 0) StartVehFly(playerid); else StopVehFly(playerid);}//Режим Полета на авто
		}//Класс 2
		}//на H
	}//Навык H авто
	
	if(PRESSED(KEY_CROUCH) && IsPlayerInAnyVehicle(playerid))
	{//Поставить машину на колеса
	    if (InEvent[playerid] == EVENT_XRACE || InEvent[playerid] == EVENT_RACE)
	    {//В обычной или легендарной гонке
	        if (FlipCount[playerid] <= 0) return 1;
			new Float: aangle, String[120], needcount = 0;
			GetVehicleZAngle(GetPlayerVehicleID(playerid), aangle);SetVehicleZAngle(GetPlayerVehicleID(playerid), aangle);
            SetPlayerChatBubble(playerid, "Перевернул транспорт", COLOR_GREEN, 300.0, 3000);
         	if (InEvent[playerid] == EVENT_RACE || InEvent[playerid] == EVENT_XRACE) needcount = 1;
			if (needcount == 1)
			{//если нужно считать кол-во оставшихся переворотов
	            FlipCount[playerid] -= 1;
				format(String,sizeof(String),"Вы перевернули ваш транспорт на колеса. Осталось переворотов: %d", FlipCount[playerid]);
				SendClientMessage(playerid,COLOR_GREEN,String);
			}//если нужно считать кол-во оставшихся переворотов
			else
			{//если НЕ нужно
			    format(String,sizeof(String),"Вы перевернули ваш транспорт на колеса.", FlipCount[playerid]);
				SendClientMessage(playerid,COLOR_GREEN,String);
			}//если НЕ нужно
	    }//В обычной или легендарной гонке
	}//Поставить машину на колеса
	
	if (Player[playerid][Level] == 0 && IsPlayerInAnyVehicle(playerid))
	{//проходит обучение
		if(PRESSED(KEY_NO) || PRESSED(KEY_YES))
		{//трансформировался из мопеда в машину
			new String[1024];
			strcat(String, "{007FFF}Конец Обучения: Игра{FFFFFF}\n\n");
			strcat(String, "Поздравляем! Вы успешно прошли обучение! Теперь вашей основной задачей является прокачка уровня.\n");
			strcat(String, "С каждым новым уровнем у вас будут новые возможности, транспорт и оружие. Чтобы повысить уровень\n");
			strcat(String, "лучше всего участвовать в соревнованиях: в гонках, десматчах, дерби и так далее.\n\n");
			strcat(String, "{008E00}Посмотреть список доступных соревнований можно командой {FF0000}/events\n");
			strcat(String, "{008E00}Посмотреть список доступных заданий можно командой {FF0000}/quests\n");
			strcat(String, "{008E00}Найти работу, банк, казино и другие важные объекты можно при помощи {FF0000}/gps\n\n");
			strcat(String, "{FFFFFF}Если у вас остались какие-то вопросы, то мы рекомендуем вам прочитать FAQ (команда {FF0000}/help{FFFFFF}).\n");
			strcat(String, "\n\n{FFFF00}Приятной игры!");
			ShowPlayerDialog(playerid, DIALOG_TUTORIAL, 0, "Обучение", String, "ИГРАТЬ", "");
			DestroyObject(TutorialObject[playerid]);TutorialObject[playerid] = -1;
			TutorialStep[playerid] = 4;
			SendClientMessage(playerid, -1, "{AFAFAF}SERVER: Вы успешно прошли обучение!");
		}//трансформировался из мопеда в машину
	}//проходит обучение

	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
   		//printf("FAILED RCON LOGIN BY IP %s USING PASSWORD %s",ip, password);
        new pip[16];
        for(new i=0; i<MAX_PLAYERS; i++) //Loop through all players
        {
            GetPlayerIp(i, pip, sizeof(pip));
            if(!strcmp(ip, pip, true)) //If a player's IP is the IP that failed the login
            {
                SendClientMessage(i, 0xFFFFFFFF, "Неправильный пароль. Давай досвидания!"); //Send a message
                Kick(i);//Ban(i); //They are now banned.
            }
        }
	return 1;
}

public OnPlayerUpdate(playerid)
{
	LAFK[playerid] = 0; //Сброс afk
	
	//--- Защита от воздействия на транспорт других игроков
	if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{//Игрок за рулем авто
	    new vehicleid = GetPlayerVehicleID(playerid);
	    if (Vehicle[vehicleid][Owner] != -1 && Vehicle[vehicleid][Owner] != playerid)
	        return 0;
	}//Игрок за рулем авто
	//--- Защита от воздействия на транспорт других игроков

	if(GetPlayerCameraMode(playerid) == 53)
	{//Anti Weapon Crasher
		new Float:pos[3];
		GetPlayerCameraPos(playerid,pos[0],pos[1],pos[2]);
		if( pos[0] < -7000.0 || pos[0] > 7000.0 || pos[1] < -7000.0 || pos[1] > 7000.0 || pos[2] < -7000.0 || pos[2] > 7000.0 )
		{
			Kick(playerid); return 0;
		}
	}//Anti Weapon Crasher
	
	if (GMTestStage[playerid] > 0)
	{//----- GMTest
	    new Float: hp, Float: Armour, testerid = GMTesterID[playerid];GetPlayerHealth(playerid, hp);GetPlayerArmour(playerid, Armour);
	    if (GMTestStage[playerid] == 1 && GMTestTime[playerid] < 3 && GMTestTime[playerid] > 0)
	    {//NOP
	        if (hp != 100.0 || Armour != 0.0) SendClientMessage(testerid,COLOR_YELLOW,"GMTest: {DD0000}Обнаружен чит, запрещающий изменять здоровье и/или броню игрока!");
	        GMTestTime[playerid] = 3;GMTestStage[playerid] = 2;//подбрасывание игрока
			new Float: x, Float: y, Float: z;GetPlayerPos(playerid,x,y,z);SetPlayerPos(playerid,x+1,y+1,z + 10);
	    }//NOP
	    if (GMTestStage[playerid] == 2)
	    {//подбрасывание
	        if (hp < 100.0)
	        {
	            SendClientMessage(testerid,COLOR_YELLOW,"GMTest: {008E00}Неуязвимости к падению с высоты не обнаружено.");
	            SetPlayerHealth(playerid,100);GMTestTime[playerid] = 3;GMTestTime[playerid] = 3;GMTestStage[playerid] = 666;//взрыв
	        }
	        else if (GMTestTime[playerid] <= 1)
	        {
	            SendClientMessage(testerid,COLOR_YELLOW,"GMTest: {DD0000}Обнаружен чит на неуязвимость к падению с высоты!");
	            SetPlayerHealth(playerid,100);GMTestTime[playerid] = 3;GMTestTime[playerid] = 3;GMTestStage[playerid] = 666;//взрыв
	        }
	    }//подбрасывание
	    if (GMTestStage[playerid] == 3)
	    {//взрыв
	        if (hp < 100.0)
	        {
	            SendClientMessage(testerid,COLOR_YELLOW,"GMTest: {008E00}Неуязвимости к взрывам не обнаружено.");
	            SetPlayerHealth(playerid,100);GMTestTime[playerid] = 0;GMTestStage[playerid] = 4;//финал
	        }
	        else if (GMTestTime[playerid] <= 1)
	        {
	            SendClientMessage(testerid,COLOR_YELLOW,"GMTest: {DD0000}Обнаружен чит на неуязвимость к взрывам!");
	            SetPlayerHealth(playerid,100);GMTestTime[playerid] = 3;GMTestStage[playerid] = 4;//финал
	        }
	    }//взрыв
	    if (GMTestStage[playerid] == 666)
	    {//промежуточное, но необходимое..
	        GMTestStage[playerid] = 3;GMTestTime[playerid] = 3;
	        new Float: x, Float: y, Float: z;GetPlayerPos(playerid,x,y,z);CreateExplosionForPlayer(playerid, x, y , z+7, 4, 2);
	    }//промежуточное, но необходимое..
	    if (GMTestStage[playerid] == 4)
	    {
	        GMTestStage[playerid] = 0;GMTestTime[playerid] = 0;
			SetPlayerHealth(playerid,GMTestHealthOld[playerid]);SetPlayerArmour(playerid,GMTestArmourOld[playerid]);
			new string[120], pname[24];GetPlayerName(playerid, pname, sizeof(pname));
			format(string,sizeof(string),"GMTest: Тестирование игрока %s[%d] завершено.",pname,playerid);
			SendClientMessage(testerid,COLOR_YELLOW,string);
	    }
	    
	}//----- GMTest
	
	if (FirstSobeitCheck[playerid] > 0 && FirstSobeitCheck[playerid] < 3)
	{//----- Первичная проверка на Sobeit при первом спавне
	    new Float:x, Float:y, Float:z; GetPlayerCameraFrontVector(playerid, x, y, z);
		if (FirstSobeitCheck[playerid] == 1)
		{//запускаем проверку
		    if(z >= -0.25)
			{//если с камерой порядок
	    	    TogglePlayerControllable(playerid, false); //Замараживаем игрока (у собейтеров камера будет двигаться сама)
				FirstSobeitCheck[playerid] = 2;
			}//если с камерой порядок
			else SetCameraBehindPlayer(playerid); //иначе делаем, чтобы с камерой был порядок
		}//запускаем проверку
		if (FirstSobeitCheck[playerid] == 2)
		{//----- Первичная проверка на Sobeit при первом спавне
		   	if(z < -0.8)
		    {//обнаружен Sobeit (UnFreeze баг)
		        new String[140]; FirstSobeitCheck[playerid] = 3; //чтобы не срабатывал повторно
				format(String,sizeof(String), "[АДМИНАМ]LAC: {AFAFAF}%s[%d] был автоматически кикнут. {FF0000}Причина: {AFAFAF}Обнаружен чит Sobeit",PlayerName[playerid], playerid);
		        foreach(Player, cid) if (Player[cid][Admin] != 0 && Logged[cid] == 1) SendClientMessage(cid, COLOR_RED, String);
				format(String, 140, "%d.%d.%d в %d:%d:%d |   LAC: %s[%d] был автоматически кикнут. Причина: Обнаружен чит Sobeit", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid);
				WriteLog("GlobalLog", String);WriteLog("LACSobeit", String);
				SendClientMessage(playerid, COLOR_RED, "LAC: {AFAFAF}Обнаружен чит {FF0000}Sobeit{AFAFAF}! Удалите его и перезайдите в игру!");
				TogglePlayerControllable(playerid, 1); SetCameraBehindPlayer(playerid);
				CancelSelectTextDraw(playerid); return GKick(playerid);
		    }//обнаружен Sobeit (UnFreeze баг)
		}//----- Первичная проверка на Sobeit при первом спавне
	}//----- Первичная проверка на Sobeit при первом спавне

	//----- Смена скина
	new Keys, ud, lr;
	GetPlayerKeys(playerid,Keys,ud,lr);
	// if(ud > 0) SendClientMessage(playerid, 0xFFFFFFFF, "DOWN");
	// else if(ud < 0) SendClientMessage(playerid, 0xFFFFFFFF, "UP");
	if(lr > 0 && SkinChangeMode[playerid] == 1)
	{//right
		Player[playerid][Model] += 1;if(Player[playerid][Model] == 312){Player[playerid][Model] = 0;}
		SetPlayerSkin(playerid,Player[playerid][Model]);
		new String[10];format (String,sizeof(String),"Skin: %d",Player[playerid][Model]);TextDrawSetString(SkinIDTD[playerid], String);
		TextDrawShowForPlayer(playerid, SkinIDTD[playerid]);
	}//right
	else if(lr < 0&& SkinChangeMode[playerid] == 1)
	{//left
		Player[playerid][Model] -= 1;if(Player[playerid][Model] == -1){Player[playerid][Model] = 311;}
		SetPlayerSkin(playerid,Player[playerid][Model]);
		new String[10];format (String,sizeof(String),"Skin: %d",Player[playerid][Model]);TextDrawSetString(SkinIDTD[playerid], String);
		TextDrawShowForPlayer(playerid, SkinIDTD[playerid]);
	}//left
	//----- Смена скина
	
	//----- Настройки режима слежки
	if (LSpecID[playerid] != -1 && LSpecCanFastChange[playerid] == 1)
	{//Игрок в режиме слежки (смена подозреваемого стрелочками)
	    if(lr > 0)
	    {//Нажата стрелка вправо
	        new bool: CurrentID = false, specplayerid = LSpecID[playerid];
	        LSpectators[specplayerid]--;
	        while (!CurrentID)
	        {//Пока ID нового подозреваемого неподходящий
	            specplayerid++;
	            if (specplayerid == MAX_PLAYERS) specplayerid = 0;
	            if ((IsPlayerConnected(specplayerid) && LSpecID[specplayerid] == -1) || LSpecID[playerid] == specplayerid)
	            {
	                TogglePlayerSpectating(playerid, 1);
					CurrentID = true; LSpecID[playerid] = specplayerid; LSpecCanFastChange[playerid] = 0;
		            SetPlayerInterior(playerid, GetPlayerInterior(specplayerid));
		            SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(specplayerid));
		            if (IsPlayerInAnyVehicle(specplayerid)) PlayerSpectateVehicle(playerid, GetPlayerVehicleID(specplayerid), LSpecMode[playerid]);
					else PlayerSpectatePlayer(playerid, specplayerid);
					LSpectators[specplayerid]++;
				}
	        }//Пока ID нового подозреваемого неподходящий
	    }//Нажата стрелка вправо
	    else if(lr < 0)
	    {//Нажата стрелка влево
	        new bool: CurrentID = false, specplayerid = LSpecID[playerid];
            LSpectators[specplayerid]--;
			while (!CurrentID)
	        {//Пока ID нового подозреваемого неподходящий
	            specplayerid--;
	            if (specplayerid == -1) specplayerid = MAX_PLAYERS - 1;
	            if ((IsPlayerConnected(specplayerid) && LSpecID[specplayerid] == -1) || LSpecID[playerid] == specplayerid)
	            {
					CurrentID = true; LSpecID[playerid] = specplayerid; LSpecCanFastChange[playerid] = 0;
		            SetPlayerInterior(playerid, GetPlayerInterior(specplayerid));
		            SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(specplayerid));
		            if (IsPlayerInAnyVehicle(specplayerid)) PlayerSpectateVehicle(playerid, GetPlayerVehicleID(specplayerid), LSpecMode[playerid]);
					else PlayerSpectatePlayer(playerid, specplayerid);
					LSpectators[specplayerid]++;
				}
	        }//Пока ID нового подозреваемого неподходящий
	    }//Нажата стрелка влево
	    else if(ud != 0)
	    {//Нажата стрелка вниз или вверх (обновление слежки, смена камеры)
	        if(ud > 0)
	        {//Нажата клавиша вниз (смена камеры)
	            if (LSpecMode[playerid] == SPECTATE_MODE_NORMAL) LSpecMode[playerid] = SPECTATE_MODE_SIDE;
	            else  LSpecMode[playerid] = SPECTATE_MODE_NORMAL;
	        }//Нажата клавиша вниз (смена камеры)
	        new specplayerid = LSpecID[playerid]; LSpecCanFastChange[playerid] = 0;
	        SetPlayerInterior(playerid, GetPlayerInterior(specplayerid));
		    SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(specplayerid));
		    if (IsPlayerInAnyVehicle(specplayerid)) PlayerSpectateVehicle(playerid, GetPlayerVehicleID(specplayerid), LSpecMode[playerid]);
			else PlayerSpectatePlayer(playerid, specplayerid);
			GameTextForPlayer(playerid, "~Y~camera updated", 1500, 6);
	    }//Нажата стрелка вниз или вверх (обновление слежки, смена камеры)
	}//Игрок в режиме слежки (смена подозреваемого стрелочками)
	//----- Настройки режима слежки
	
	if (InPeacefulZone[playerid] == 1 || AdminTPCantKill[playerid] > 0) SetPlayerArmedWeapon(playerid, 0);//Запрет оружия в мирных зонах

    if (PrestigeGM[playerid] == 1)
    {//Режим Бога
        if (InEvent[playerid] == 0)
        {
	        SetPlayerHealth(playerid, 90000.0);
	        if (GetPlayerInterior(playerid) != 10) SetPlayerChatBubble(playerid, "Режим Бога (Престиж)", COLOR_YELLOW, 300.0, 1000); //в казино не показывает надпись
	        if (IsPlayerInAnyVehicle(playerid)) RepairVehicle(GetPlayerVehicleID(playerid));
        }
        else
		{
			PrestigeGM[playerid] = 0;SetPlayerHealth(playerid, 100.0);SendClientMessage(playerid,0xFF0000FF,"Режим Бога деактивирован.");
			if (InEvent[playerid] == EVENT_DERBY) SetVehicleHealth(GetPlayerVehicleID(playerid), 700.0);
		}
    }//Режим Бога
    
    if (MapTP[playerid] == 1)
    {//Использовал телепорт по карте (нужно найти номальное значение координаты Z)
    	new Float: X, Float: Y, Float: Z; GetPlayerPos(playerid, X, Y, Z);
    	if (MapTPx[playerid] != X || MapTPy[playerid] != Y) Z = -5.0;
        if (Z < 0)
        {//Всё еще кривая координата Z
            MapTPTry[playerid]++;
            if (MapTPTry[playerid] < 10) SetPlayerPosFindZ(playerid, MapTPx[playerid], MapTPy[playerid], 10000);
            else
            {//Так и не удалось найти координату Z выше моря (попытка телепорта на дно)
                SetPlayerPos(playerid, MapTPx[playerid], MapTPy[playerid], 1);
                //SendClientMessage(playerid, -1, "Не удалось найти координату Z после 10 попыток!");
            }//Так и не удалось найти координату Z выше моря (попытка телепорта на дно)
        }//Всё еще кривая координата Z
        else
        {//Координата Z в норме
            MapTP[playerid] = 0; AdminTPCantKill[playerid] = 20;
            if (Player[playerid][Admin] < 4) {MapTPTime[playerid] = 120; SetPlayerChatBubble(playerid, "Телепортировался (ViP)", 0x00FF00FF, 300.0, 6000);}
			SendClientMessage(playerid, COLOR_YELLOW, "SERVER: Вы успешно использовали телепорт по карте!");
        }//Координата Z в норме
    }//Использовал телепорт по карте (нужно найти номальное значение координаты Z)

	if (InEvent[playerid] == EVENT_ZOMBIE && ZMTimeToFirstZombie <= 0 && ZMIsPlayerIsZombie[playerid] == 0)
	{//Игрок на зомби-выживании играет за человека, зомби уже заспавнились
	    new Float:SPD, Float:vx, Float:vy, Float:vz; GetPlayerVelocity(playerid, vx,vy,vz);
		SPD = floatsqroot(((vx*vx)+(vy*vy))/*+(vz*vz)*/);
		if (SPD > 0.125 || GetPlayerAnimationIndex(playerid) == 1195 || GetPlayerAnimationIndex(playerid) == 1061 || GetPlayerAnimationIndex(playerid) == 1065 || GetPlayerAnimationIndex(playerid) == 1066)
		{//Бег, Прыжок, Повис на стене, залазит на стену, залазит на забор
		    SecFreeze(playerid, 1); ApplyAnimation(playerid,"CRACK","crckdeth1",4.1,0,0,0,0,1,1);
	 		SendClientMessage(playerid, COLOR_RED, "Людям запрещено бегать и прыгать после появления зомби!");
		}//Бег, Прыжок, Повис на стене, залазит на стену, залазит на забор
	}//Игрок на зомби-выживании играет за человека, зомби уже заспавнились
	
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
/*
    //Стрим анимок
    new aindex = GetPlayerAnimationIndex(playerid);
    if(aindex > 0)
    {
        new animlib[32], animname[32];
        GetAnimationName(aindex, animlib, sizeof(animlib), animname, sizeof(animname));
        ApplyAnimation(playerid, animlib, animname, 4.0, 0, 1, 1, 0, 0, 1);
    }
    //Стрим анимок*/
    return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}



public SecUpdate()
{//нц пб
	//Время и дата
    getdate(Year, Month, Day); gettime(hour,minute,second);new StringTime[80];
	format(StringTime, sizeof StringTime, "%d/%s%d/%s%d", Day, ((Month < 10) ? ("0") : ("")), Month, (Year < 10) ? ("0") : (""), Year);
	TextDrawSetString(TextDrawDate, StringTime);
	format(StringTime, sizeof StringTime, "%s%d:%s%d:%s%d", (hour < 10) ? ("0") : (""), hour, (minute < 10) ? ("0") : (""), minute, (second < 10) ? ("0") : (""), second);
	TextDrawSetString(TextDrawTime, StringTime);
	if (minute == 0 && second < 3)
	{//обнуление лимита хр раз в час, срабатывает трижды на случай, если один раз не сработает (баг таймера)
		format(ServerLimitXPDate,sizeof ServerLimitXPDate, "%d/%d/%d в %d:00", Day, Month, Year, hour);
		foreach(Player, gid)
		{
		    //--------- Сброс ежечасовой статистики
	    	format(PlayerLimitXPDate[gid], 80, "%d/%d/%d в %d:00", Day, Month, Year, hour);
            if (Player[gid][LastHourExp] > 0)
			{
				new String[180];
			    format(String, sizeof String, "%d.%d.%d в %d:%d:%d |   STATISTICS: Игрок %s[%d] получил %d XP за один час", Day, Month, Year, hour, minute, second, PlayerName[gid], gid, Player[gid][LastHourExp]);
				WriteLog("StatisticsXP", String);
			}
			if (Player[gid][LastHourReferalExp] > 0)
			{
				new String[180];
			    format(String, sizeof String, "%d.%d.%d в %d:%d:%d |   STATISTICS: Игрок %s[%d] получил от клана %d XP за один час", Day, Month, Year, hour, minute, second, PlayerName[gid], gid, Player[gid][LastHourReferalExp]);
				WriteLog("StatisticsClanXP", String);
			}
			Player[gid][LastHourExp] = 0; Player[gid][LastHourReferalExp] = 0;
			//--------- Сброс ежечасовой статистики
			
		    ShopUpdate(gid);//Обновление временных товаров Shop
		}
		if (minute == 0 && second == 0)
		{//Иногда может не сработать (баг таймера)
		    ClansUpdate();//Удаление кланов, которые не купили штаб вовремя
		    HousesUpdate();//Снятие неперекупайки у тех, у кого она кончилась
			SendClientMessageToAll(COLOR_YELLOW,"SERVER: Начался новый игровой час! Счетчик опыта, набранного за последний час, аннулирован.");
		}//Иногда может не сработать (баг таймера)
	}//обнуление лимита хр раз в час, срабатывает трижды на случай, если один раз не сработает (баг таймера)
	if (second == 0)
	{//Раз в минуту
	    PlayersOnline = 0;
	    foreach(Player, gid)
		{//цикл
			PlayersOnline++;
            QuestUpdate(gid, 25, 1);//Обновление квеста Проведите на сервере 60 минут
            if (QuestActive[gid] >= 2) QuestUpdate(gid, 27, 1);//Обновление квеста Проведите 15 минут на любой работе
		}//цикл
	}//Раз в минуту

	
	UGTime--; //сообщение о форуме
	if (UGTime == 0)
	{
	    SendClientMessageToAll(-1,"");
	    SendClientMessageToAll(COLOR_YELLOW,"Вступайте в нашу группу вконтакте: {FFFFFF}vk.com/ubergame");
	    new rand = random(5);
	        if (rand == 0) SendClientMessageToAll(COLOR_GG,"Внимание! На сервере есть внутриигровой магазин: {FFFFFF}/shop");
	        if (rand == 1) SendClientMessageToAll(COLOR_DERBY,"Внимание! На сервере есть внутриигровой магазин: {FFFFFF}/shop)");
	        if (rand == 2) SendClientMessageToAll(COLOR_RACE,"Внимание! На сервере есть внутриигровой магазин: {FFFFFF}/shop");
	        if (rand == 3) SendClientMessageToAll(COLOR_GREEN,"Внимание! На сервере есть внутриигровой магазин: {FFFFFF}/shop");
	        if (rand == 4) SendClientMessageToAll(COLOR_NICEORANGE,"Внимание! На сервере есть внутриигровой магазин: {FFFFFF}/shop");
        SendClientMessageToAll(-1,"");

		//Динамическая реклама
		if(fexist("AD.ini"))
		{
		    new file, ADString1[140], ADString2[140], ADString3[140], ADString4[140];
		    file = ini_openFile("AD.ini");
			ini_getString(file,"String1", ADString1); if(strcmp(ADString1, "ПУСТО", true)) SendClientMessageToAll(-1, ADString1);
			ini_getString(file,"String2", ADString2); if(strcmp(ADString2, "ПУСТО", true)) SendClientMessageToAll(-1, ADString2);
			ini_getString(file,"String3", ADString3); if(strcmp(ADString3, "ПУСТО", true)) SendClientMessageToAll(-1, ADString3);
			ini_getString(file,"String4", ADString4); if(strcmp(ADString4, "ПУСТО", true)) SendClientMessageToAll(-1, ADString4);
            ini_closeFile(file);
		}//Динамическая реклама


	    UGTime = 900; SendRconCommand("reloadbans");
	    //Смена погоды
	    ServerWeather = random(20);
		if (ServerWeather == 8 || ServerWeather == 16 || ServerWeather == 19) ServerWeather -= 1;//Удаление погоды с дождем и с бурей
		if (ServerWeather == 9) ServerWeather = 10;
		SetWeather(ServerWeather);		//Смена погоды
		foreach(Player, gid) if (Logged[gid] == 1) SavePlayer(gid);
		SaveAllClans(); //SaveAllProperty(); SaveAllBase();
	}
	

	/////////////
	DMPlayers = 0; DerbyPlayers = 0;	ZMPlayers = 0; ZMZombies = 0; ZMHumans = 0;	FRPlayers = 0;	XRPlayers = 0;	GGPlayers = 0;
	foreach(Player, cid)
	{//цикл
		if (JoinEvent[cid] == EVENT_DM){DMPlayers++;}
		if (JoinEvent[cid] == EVENT_DERBY && DerbyTimer <= 300 && DerbyTimer > 0){DerbyPlayers++;}
		if (JoinEvent[cid] == EVENT_DERBY && DerbyStarted[cid] == 1 && DerbyTimer <= -1 && DerbyTimeToEnd >= 0){DerbyPlayers++;}
		if (JoinEvent[cid] == EVENT_ZOMBIE && ZMTimer <= 300 && ZMTimer > 0){ZMPlayers++;}
		if (ZMStarted[cid] == 1 && ZMTimer <= -1 && ZMTimeToEnd >= 0){ZMPlayers++; if (ZMIsPlayerIsZombie[cid] > 0) ZMZombies++; else ZMHumans++;}
		if (FRTimer != -1 && JoinEvent[cid] == EVENT_RACE){FRPlayers++;}
		else if(FRStarted[cid] == 1 && FRTimeToEnd >= 0){FRPlayers++;}
		if (XRTimer != -1 && JoinEvent[cid] == EVENT_XRACE){XRPlayers++;}
		else if(XRStarted[cid] == 1 && XRTimeToEnd >= 0){XRPlayers++;}
		if (JoinEvent[cid] == EVENT_GUNGAME){GGPlayers++;}
	}//цикл
	/////////////

	#include "Transformer\DMSecUpdate"
	#include "Transformer\DerbySecUpdate"
	#include "Transformer\ZombieSecUpdate"
	#include "Transformer\RaceSecUpdate"
	#include "Transformer\XRaceSecUpdate"
	#include "Transformer\GGSecUpdate"

	//------------------------------- Прочие цикличные важности
	if (SaveTime > 0){SaveTime--;}//автосохранение акков
	if (SaveTime == 0){SaveTime = 30;}//UpdatePlayer каждые 30 сек
	
	for (new vid = 1; vid <= 35; vid++)
	{//обработка авто для угона
	    StealCarTimer[vid]++;
	    if (StealCarTimer[vid] >= 600)
	    {//нужно заменить авто для угона на новое
	        if (vid <= 25)
	        {//Наземные авто
				DestroyVehicle(StealCar[vid]);DestroyDynamicMapIcon(StealCarMapIcon[vid]);
				//пересоздание того авто в другом месте
				new rrand1 = random(sizeof(CarStealSpawns)), rcol1 = random(256), rcol2 = random(256), rmodeld = random(133); new rmodel = StealCars[rmodeld];
				StealCar[vid] = LCreateVehicle(rmodel, CarStealSpawns[rrand1][0], CarStealSpawns[rrand1][1], CarStealSpawns[rrand1][2], CarStealSpawns[rrand1][3], rcol1, rcol2, 0);
	  		 	StealCarMapIcon[vid] = CreateDynamicMapIcon(CarStealSpawns[rrand1][0], CarStealSpawns[rrand1][1], CarStealSpawns[rrand1][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);
			}//Наземные авто
			else if (vid <= 30)
			{//Водные авто
				DestroyVehicle(StealCar[vid]);DestroyDynamicMapIcon(StealCarMapIcon[vid]);
				//пересоздание того авто в другом месте
				new rrand1 = random(sizeof(CarStealWaterSpawns)), rcol1 = random(256), rcol2 = random(256), rmodeld = random(11); new rmodel = StealWaterCars[rmodeld];
				StealCar[vid] = LCreateVehicle(rmodel, CarStealWaterSpawns[rrand1][0], CarStealWaterSpawns[rrand1][1], CarStealWaterSpawns[rrand1][2], CarStealWaterSpawns[rrand1][3], rcol1, rcol2, 0);
	  		 	StealCarMapIcon[vid] = CreateDynamicMapIcon(CarStealWaterSpawns[rrand1][0], CarStealWaterSpawns[rrand1][1], CarStealWaterSpawns[rrand1][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);
			}//Водные авто
			else if (vid <= 35)
			{//Воздушное авто
				DestroyVehicle(StealCar[vid]);DestroyDynamicMapIcon(StealCarMapIcon[vid]);
				//пересоздание того авто в другом месте
				new rrand1 = random(sizeof(CarStealAirSpawns)), rcol1 = random(256), rcol2 = random(256), rmodeld = random(13); new rmodel = StealAirCars[rmodeld];
				StealCar[vid] = LCreateVehicle(rmodel, CarStealAirSpawns[rrand1][0], CarStealAirSpawns[rrand1][1], CarStealAirSpawns[rrand1][2], CarStealAirSpawns[rrand1][3], rcol1, rcol2, 0);
	  		 	StealCarMapIcon[vid] = CreateDynamicMapIcon(CarStealAirSpawns[rrand1][0], CarStealAirSpawns[rrand1][1], CarStealAirSpawns[rrand1][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);
			}//Воздушное авто
	    }//нужно заменить авто для угона на новое
	}//обработка авто для угона
	
	new Float: vehHP, NewMaxVehicleUsed = 35;
	for (new vehid = 36; vehid <= MaxVehicleUsed; vehid++)
	{//обработка всех авто, кроме авто для угона
	    GetVehicleHealth(vehid, vehHP);
	    //если здоровье авто не равно 0, значит машина существует - обрабатываем её
	    if (vehHP != 0) {SecVehicleUpdate(vehid); NewMaxVehicleUsed = vehid;}
	}//обработка всех авто, кроме авто для угона
	MaxVehicleUsed = NewMaxVehicleUsed;

return 1;
}//кц пб

public SecVehicleUpdate(vehicleid)
{//ежесекундный обработчик транспорта (не работает на авто для угона и на несуществующих авто)
	if (Vehicle[vehicleid][AntiDestroyTime] > 0) Vehicle[vehicleid][AntiDestroyTime]--;
	else
	{//транспорт уже можно уничтожать
	    if (Vehicle[vehicleid][Owner] == -1) DestroyVehicle(vehicleid); //если транспорт никому не принадлежит - уничтожить
	    else if (!IsPlayerInVehicle(Vehicle[vehicleid][Owner], vehicleid) || (GetPlayerVehicleSeat(Vehicle[vehicleid][Owner]) != 0 && GetPlayerVehicleSeat(Vehicle[vehicleid][Owner]) != 128))
		{//если владелец транспорта не за рулем этого авто
		    if( IsTrailer[vehicleid] == 0) DestroyVehicle(vehicleid); //если это не трейлер - уничтожить
		}//если владелец транспорта не за рулем этого авто
	}//транспорт уже можно уничтожать
	
	new Float: newHealth; GetVehicleHealth(vehicleid, newHealth);
	if (newHealth <= Vehicle[vehicleid][Health]) {Vehicle[vehicleid][Health] = newHealth; LACRepair[vehicleid] = 0;}
	else
	{//Здоровье транспорта оказалось больше, чем оно должно быть
	    new playerid = Vehicle[vehicleid][Owner];
	    if (playerid > -1 && IsPlayerConnected(playerid) && IsPlayerInVehicle(playerid, vehicleid) && LAFK[playerid] < 4)
	    {//Владелец транспорта подключен к серверу и сидит за рулем этого авто. Также он НЕ afk, не в тюнинге и не в PayNSpray
			//Если игрок отремонтировал авто в тюнинге или в Pay N Spray - то принять новые значение здоровья авто
			if (newHealth == 1000 && (LastPlayerTuneStatus[playerid] != 0 || IsPlayerInPayNSpray(playerid))) {Vehicle[vehicleid][Health] = newHealth; LACRepair[vehicleid] = 0;}
			else
			{//игрок читер
			    LACRepair[vehicleid]++; SetVehicleHealth(vehicleid, Vehicle[vehicleid][Health]); //устанавливаем настоящее значение
			    if (LACRepair[vehicleid] > 4)
			    {
			        new String[140]; DestroyVehicle(vehicleid); TimeTransform[playerid] = 5; LACPanic[playerid]++;//LAC v2.0
					format(String,sizeof(String), "[АДМИНАМ]LAC:{AFAFAF} Транспорт игрока %s[%d] уничтожен. {FF0000}Причина: {AFAFAF}Возможно чит на Ремонт транспорта",PlayerName[playerid], playerid);
		            foreach(Player, cid) if (Player[cid][Admin] != 0 && Logged[cid] == 1) SendClientMessage(cid, COLOR_RED, String);
		    		SendClientMessage(playerid, -1,"{FF0000}LAC:{AFAFAF} Ваш транспорт был уничтожен. {FF0000}Причина: {AFAFAF}Возможно чит на Ремонт транспорта");
					format(String, 140, "%d.%d.%d в %d:%d:%d |   LAC: Транспорт игрока %s[%d] уничтожен. Причина: Возможно чит на Ремонт транспорта", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid);
					WriteLog("GlobalLog", String);WriteLog("LAC", String);
				}
			}//игрок читер
	    }//Владелец транспорта подключен к серверу и сидит за рулем этого авто
	}//Здоровье транспорта оказалось больше, чем оно должно быть
	
	return 1;
}//ежесекундный обработчик транспорта (не работает на авто для угона и на несуществующих авто)

public SecPlayerUpdate(playerid)
{//нц пб
		if (!IsPlayerConnected(playerid)) return 1;
		SetTimerEx("SecPlayerUpdate" , 1000, false, "i", playerid);

		if (Logged[playerid] == 1 && SaveTime == 1) UpdatePlayer(playerid);

		InEvent[playerid] = 0;new AutoBug = 0;
		if (JoinEvent[playerid] == EVENT_DM && DMTimeToEnd > 0){InEvent[playerid] = EVENT_DM; AutoBug = 1;SetPlayerVirtualWorld(playerid,1);}
		if (JoinEvent[playerid] == EVENT_ZOMBIE && ZMTimeToEnd > 0){InEvent[playerid] = EVENT_ZOMBIE; AutoBug = 1;SetPlayerVirtualWorld(playerid,663);} else {ZMIsPlayerIsZombie[playerid] = 0;}
	    if (JoinEvent[playerid] == EVENT_RACE){InEvent[playerid] = EVENT_RACE;SetPlayerVirtualWorld(playerid,661);}
	    if (JoinEvent[playerid] == EVENT_XRACE){InEvent[playerid] = EVENT_XRACE;SetPlayerVirtualWorld(playerid,700);}
	    if (DerbyStarted[playerid] == 1){InEvent[playerid] = EVENT_DERBY;SetPlayerVirtualWorld(playerid,664);}
	    if (JoinEvent[playerid] == EVENT_GUNGAME && GGTimeToEnd > 0){InEvent[playerid] = EVENT_GUNGAME; AutoBug = 1;SetPlayerVirtualWorld(playerid,701);}
	    if (PlayerPVP[playerid][Status] >= 2){InEvent[playerid] = EVENT_PVP; AutoBug = 1;}
	    
	    InPeacefulZone[playerid] = 0;//В мирной зоне: нельзя убить и быть убитым
	    if (GetPlayerInterior(playerid) != 16 && GetPlayerInterior(playerid) != 0 && InEvent[playerid] == 0) InPeacefulZone[playerid] = 1;//В интерьерах (кроме PvP)
		if (IsPlayerInRangeOfPoint(playerid, 13.0, 2311.6953,-7.4206,26.7422)) InPeacefulZone[playerid] = 1;//В банке (не считается интерьером)
        if (JoinEvent[playerid] == EVENT_RACE || JoinEvent[playerid] == EVENT_XRACE) InPeacefulZone[playerid] = 1;//В гонках
        if (IsPlayerInRangeOfPoint(playerid, 150.0, 2746.9546, -2436.0449, 13.6432) && InEvent[playerid] == 0) InPeacefulZone[playerid] = 1;//Порт (работа грузчика)
        if (IsPlayerInRangeOfPoint(playerid, 150.0, -1107.8953, -986.4189, 129.2188) && InEvent[playerid] == 0) InPeacefulZone[playerid] = 1;//Поле (работа комбайнера)
		if (GetPlayerVirtualWorld(playerid) == 999) InPeacefulZone[playerid] = 1;//Снежный мир (в новогоднем режиме) - мирная зона
		if (OnVehFly[playerid] == 1 && InPeacefulZone[playerid] > 0) StopVehFly(playerid);//Режим полета отключается в мирной зоне

	    //Заморозка за 3 сек до конца (защита от бага слива ХР при убийстве в конце сорев)
	    if (JoinEvent[playerid] == EVENT_DM && DMTimeToEnd == 3){EndEventFreeze(playerid);}
	    if (JoinEvent[playerid] == EVENT_ZOMBIE && ZMTimeToEnd == 3){EndEventFreeze(playerid);}

		//Ниже исправляем баг, когда игрок в соревновании мог упасть с высоты и не умереть, таким образом оказавшись за картой
		if ((DMid == 7 && InEvent[playerid] == EVENT_DM) || (GGid == 14 && InEvent[playerid] == EVENT_GUNGAME))
		{//дм на скалах либо гангейм на скалах
		    if (LastPlayerZ[playerid] < 98.0) {OnPlayerDeath(playerid, -1, -1); LSpawnPlayer(playerid);}
		}//дм на скалах либо гангейм на скалах

	    //Ремонт авто в гонках
	    if (JoinEvent[playerid] == EVENT_RACE || JoinEvent[playerid] == EVENT_XRACE) if (IsPlayerInAnyVehicle(playerid)) RepairVehicle(GetPlayerVehicleID(playerid));
	    
	    if (AutoBug == 1 && IsPlayerInAnyVehicle(playerid)){DestroyVehicle(PlayerCarID[playerid]);Player[playerid][CarActive] = 0;PlayerCarID[playerid] = -1;}
	    //Исправляет баг, когда игрок на оказался на машине в пеших соревнованиях (например DM)

 		if (PrestigeGM[playerid] > 0 && InEvent[playerid] == 0) ResetPlayerWeapons(playerid);//Запрет оружия в Режиме Бога

		//Работа
		if (QuestActive[playerid] > 0)
		{//На задании или работе
			if (QuestActive[playerid] == 2)
			{//Доставщик пиццы
			    WorkTime[playerid]++;
				new wTime[16], wTimeLeft = 300 - WorkTime[playerid], wmin = wTimeLeft / 60, wsec = wTimeLeft - wmin * 60;
				if (wTimeLeft > 30)
				{//Больше 30 секунд в запасе
					format(wTime, sizeof wTime, "~Y~%s%d~W~:~Y~%s%d", (wmin < 10) ? ("0") : (""), wmin, (wsec < 10) ? ("0") : (""), wsec);
					TextDrawSetString(TextDrawWorkTimer[playerid], wTime); TextDrawShowForPlayer(playerid, TextDrawWorkTimer[playerid]);
				}//Больше 30 секунд в запасе
				if (wTimeLeft <= 30 && wTimeLeft >= 0)
				{//Осталось меньше 30 секунд
					format(wTime, sizeof wTime, "~R~%s%d~W~:~R~%s%d", (wmin < 10) ? ("0") : (""), wmin, (wsec < 10) ? ("0") : (""), wsec);
					TextDrawSetString(TextDrawWorkTimer[playerid], wTime); TextDrawShowForPlayer(playerid, TextDrawWorkTimer[playerid]);
				}//Больше 30 секунд в запасе
				if (wTimeLeft < 0)
				{//Время вышло
					TextDrawSetString(TextDrawWorkTimer[playerid], "~R~00~W~:~R~00"); TextDrawShowForPlayer(playerid, TextDrawWorkTimer[playerid]);
				}//Время вышло
				if (wTimeLeft == -1) SendClientMessage(playerid, COLOR_QUEST, "Работа: {FF0000}Вы не успели вовремя и не получите денег за работу!");
			}//Доставщик пиццы
			
			if (QuestActive[playerid] == 3)
	        {//Грузчик
	            WorkTimeGruz[playerid]++; if (WorkTimeGruz[playerid] <= 35) WorkTime[playerid]++;
				new str[16]; format(str, sizeof str, "~Y~%d~W~/~Y~10", GetPVarInt(playerid,"WorkCount"));
                TextDrawSetString(TextDrawWorkTimer[playerid], str); TextDrawShowForPlayer(playerid, TextDrawWorkTimer[playerid]);
                if(GetPVarInt(playerid,"WorkStage") == 2) ApplyAnimation(playerid,"CARRY","crry_prtial",4.1,0,1,1,1,1);//Чтобы не спадала анимация когда несет ящик
                
	            if (!IsPlayerInRangeOfPoint(playerid, 150.0, 2746.9546, -2436.0449, 13.6432) || GetPlayerState(playerid) != 1)
	            {//Игрок вне зоны работы или он в машине
	                ApplyAnimation(playerid,"PED","IDLE_tired",4.1,0,1,1,0,1);// Обнуляем анимацию
	            	RemovePlayerAttachedObject(playerid,0);// Удаляем объект из рук
	            	DeletePVar(playerid,"WorkStage"); DeletePVar(playerid,"WorkCount");// Удаляем PVar работы
	            	DisablePlayerCheckpoint(playerid); QuestActive[playerid] = 0;
	            	SendClientMessage(playerid,COLOR_QUEST,"Работа <<{FFFFFF}Грузчик{FFCC00}>> прервана.");
	            }//Игрок вне зоны работы или он в машине
	        }//Грузчик
	        
	        if (QuestActive[playerid] == 4)
			{//Домушник
			    WorkTime[playerid]++;
				new wTime[16], wTimeLeft = 720 - WorkTime[playerid], wmin = wTimeLeft / 60, wsec = wTimeLeft - wmin * 60;
				if (wTimeLeft > 30)
				{//Больше 30 секунд в запасе
					format(wTime, sizeof wTime, "~Y~%s%d~W~:~Y~%s%d", (wmin < 10) ? ("0") : (""), wmin, (wsec < 10) ? ("0") : (""), wsec);
					TextDrawSetString(TextDrawWorkTimer[playerid], wTime); TextDrawShowForPlayer(playerid, TextDrawWorkTimer[playerid]);
				}//Больше 30 секунд в запасе
				if (wTimeLeft <= 30 && wTimeLeft >= 0)
				{//Осталось меньше 30 секунд
					format(wTime, sizeof wTime, "~R~%s%d~W~:~R~%s%d", (wmin < 10) ? ("0") : (""), wmin, (wsec < 10) ? ("0") : (""), wsec);
					TextDrawSetString(TextDrawWorkTimer[playerid], wTime); TextDrawShowForPlayer(playerid, TextDrawWorkTimer[playerid]);
				}//Больше 30 секунд в запасе
				if (wTimeLeft < 0)
				{//Время вышло
					TextDrawSetString(TextDrawWorkTimer[playerid], "~R~00~W~:~R~00"); TextDrawShowForPlayer(playerid, TextDrawWorkTimer[playerid]);
				}//Время вышло
				if (wTimeLeft == -1) SendClientMessage(playerid, COLOR_QUEST, "Работа: {FF0000}Вы не успели вовремя и получите только половину денег за работу!");
			}//Домушник
			
			if (QuestActive[playerid] == 5)
	        {//Комбайнер
	            new Float:Speed, Float:vx, Float:vy, Float:vz, str[24];
			    GetVehicleVelocity(GetPlayerVehicleID(playerid), vx,vy,vz); Speed = floatsqroot(((vx*vx)+(vy*vy)))*200;
	            if (Speed >= 45 && LAFK[playerid] < 4 && -1198.7462 < LastPlayerX[playerid] < -1001.5065 && -1066.4282 < LastPlayerY[playerid] < -908.7125 && GetVehicleModel(GetPlayerVehicleID(playerid)) == 532) WorkTime[playerid]++;//Единица овса засчитывается если комбайн едет(!) по полю
				format(str, sizeof str, "~Y~%d~W~/~Y~300", WorkTime[playerid]);
                TextDrawSetString(TextDrawWorkTimer[playerid], str); TextDrawShowForPlayer(playerid, TextDrawWorkTimer[playerid]);
       			if (WorkTime[playerid] == 300)
				{//Набрал 300 единиц овса (за 300сек)
				    SendClientMessage(playerid, COLOR_QUEST,"Работа: Вы получили 270 XP и 22500$ за 300 единиц овса.");
				    LGiveXP(playerid, 300); Player[playerid][Cash] += 22500; WorkTime[playerid] = 0; PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
				}//Набрал 300 единиц овса (за 300сек)
	        }//Комбайнер
	        
	        if (QuestActive[playerid] == 6)
			{//Дальнобойщик
			    WorkTime[playerid]++;
				new wTime[16], wTimeLeft = 720 - WorkTime[playerid], wmin = wTimeLeft / 60, wsec = wTimeLeft - wmin * 60;
				if (wTimeLeft > 30)
				{//Больше 30 секунд в запасе
					format(wTime, sizeof wTime, "~Y~%s%d~W~:~Y~%s%d", (wmin < 10) ? ("0") : (""), wmin, (wsec < 10) ? ("0") : (""), wsec);
					TextDrawSetString(TextDrawWorkTimer[playerid], wTime); TextDrawShowForPlayer(playerid, TextDrawWorkTimer[playerid]);
				}//Больше 30 секунд в запасе
				if (wTimeLeft <= 30 && wTimeLeft >= 0)
				{//Осталось меньше 30 секунд
					format(wTime, sizeof wTime, "~R~%s%d~W~:~R~%s%d", (wmin < 10) ? ("0") : (""), wmin, (wsec < 10) ? ("0") : (""), wsec);
					TextDrawSetString(TextDrawWorkTimer[playerid], wTime); TextDrawShowForPlayer(playerid, TextDrawWorkTimer[playerid]);
				}//Больше 30 секунд в запасе
				if (wTimeLeft < 0)
				{//Время вышло
					TextDrawSetString(TextDrawWorkTimer[playerid], "~R~00~W~:~R~00"); TextDrawShowForPlayer(playerid, TextDrawWorkTimer[playerid]);
				}//Время вышло
				if (wTimeLeft == -1) SendClientMessage(playerid, COLOR_QUEST, "Работа: {FF0000}Вы не успели вовремя и получите только половину денег за работу!");
			}//Дальнобойщик
			
			if (QuestActive[playerid] == 7)
			{//Капитан Корабля
			    WorkTime[playerid]++;
				new wTime[16], wTimeLeft = 480 - WorkTime[playerid], wmin = wTimeLeft / 60, wsec = wTimeLeft - wmin * 60;
				if (wTimeLeft > 30)
				{//Больше 30 секунд в запасе
					format(wTime, sizeof wTime, "~Y~%s%d~W~:~Y~%s%d", (wmin < 10) ? ("0") : (""), wmin, (wsec < 10) ? ("0") : (""), wsec);
					TextDrawSetString(TextDrawWorkTimer[playerid], wTime); TextDrawShowForPlayer(playerid, TextDrawWorkTimer[playerid]);
				}//Больше 30 секунд в запасе
				if (wTimeLeft <= 30 && wTimeLeft >= 0)
				{//Осталось меньше 30 секунд
					format(wTime, sizeof wTime, "~R~%s%d~W~:~R~%s%d", (wmin < 10) ? ("0") : (""), wmin, (wsec < 10) ? ("0") : (""), wsec);
					TextDrawSetString(TextDrawWorkTimer[playerid], wTime); TextDrawShowForPlayer(playerid, TextDrawWorkTimer[playerid]);
				}//Больше 30 секунд в запасе
				if (wTimeLeft < 0)
				{//Время вышло
					TextDrawSetString(TextDrawWorkTimer[playerid], "~R~00~W~:~R~00"); TextDrawShowForPlayer(playerid, TextDrawWorkTimer[playerid]);
				}//Время вышло
				if (wTimeLeft == -1) SendClientMessage(playerid, COLOR_QUEST, "Работа: {FF0000}Вы не успели вовремя и получите только половину денег за работу!");
			}//Капитан Корабля
			
			if (QuestActive[playerid] == 8)
			{//Инкассатор
			    WorkTime[playerid]++;
				new wTime[16], wTimeLeft = 600 - WorkTime[playerid], wmin = wTimeLeft / 60, wsec = wTimeLeft - wmin * 60;
				if (wTimeLeft > 30)
				{//Больше 30 секунд в запасе
					format(wTime, sizeof wTime, "~Y~%s%d~W~:~Y~%s%d", (wmin < 10) ? ("0") : (""), wmin, (wsec < 10) ? ("0") : (""), wsec);
					TextDrawSetString(TextDrawWorkTimer[playerid], wTime); TextDrawShowForPlayer(playerid, TextDrawWorkTimer[playerid]);
				}//Больше 30 секунд в запасе
				if (wTimeLeft <= 30 && wTimeLeft >= 0)
				{//Осталось меньше 30 секунд
					format(wTime, sizeof wTime, "~R~%s%d~W~:~R~%s%d", (wmin < 10) ? ("0") : (""), wmin, (wsec < 10) ? ("0") : (""), wsec);
					TextDrawSetString(TextDrawWorkTimer[playerid], wTime); TextDrawShowForPlayer(playerid, TextDrawWorkTimer[playerid]);
				}//Больше 30 секунд в запасе
				if (wTimeLeft < 0)
				{//Время вышло
					TextDrawSetString(TextDrawWorkTimer[playerid], "~R~00~W~:~R~00"); TextDrawShowForPlayer(playerid, TextDrawWorkTimer[playerid]);
				}//Время вышло
				if (wTimeLeft == -1) SendClientMessage(playerid, COLOR_QUEST, "Работа: {FF0000}Вы не успели вовремя и получите только половину денег за работу!");
			}//Инкассатор
	        
	        if (InEvent[playerid] > 0)
	        {//игрок в соревнованиях, но при этом работа или задание активно
	            if (JoinEvent[playerid] != EVENT_RACE && JoinEvent[playerid] != EVENT_XRACE) {DisablePlayerCheckpoint(playerid); DisablePlayerRaceCheckpoint(playerid);}
	            if (QuestActive[playerid] == 3)
	            {//отключаем работу грузчика
	                ApplyAnimation(playerid,"PED","IDLE_tired",4.1,0,1,1,0,1);// Обнуляем анимацию
	            	RemovePlayerAttachedObject(playerid,0);// Удаляем объект работы из рук
	            	DeletePVar(playerid,"WorkStage"); DeletePVar(playerid,"WorkCount");// Удаляем PVar работы
	            }//отключаем работу грузчика
	            if (QuestActive[playerid] == 4)
	            {//отключаем работу домушника
	            	RemovePlayerAttachedObject(playerid,0);// Удаляем объект работы из рук
	            	DeletePVar(playerid,"WorkDomStage");// Удаляем PVar работы
	            }//отключаем работу домушника
	            if (QuestActive[playerid] == 5) GangZoneHideForPlayer(playerid, WorkZoneCombine);//поле комбайнера
                if (QuestActive[playerid] == 6) DeletePVar(playerid,"WorkTruckStage");// Удаляем PVar работы
                if (QuestActive[playerid] == 7) DeletePVar(playerid,"WorkWaterStage");// Удаляем PVar работы
                if (QuestActive[playerid] == 8) DeletePVar(playerid,"WorkBankStage");// Удаляем PVar работы
				QuestActive[playerid] = 0;
	        }//игрок в соревнованиях, но при этом работа или задание активно
	        if (GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USEJETPACK) SetPlayerSpecialAction(playerid,0);
		}//На задании или работе
		else {WorkTime[playerid] = 0; TextDrawHideForPlayer(playerid, TextDrawWorkTimer[playerid]);}
		
        if (Logged[playerid] == 1)
		{//обновление Score и денег
			SetPlayerScore(playerid,Player[playerid][Level]); //обновление score
            if (LastPlayerTuneStatus[playerid] > 0)
			{//игрок в тюнинге
			    if (GetPlayerMoney(playerid) < Player[playerid][Cash]) Player[playerid][Cash] = GetPlayerMoney(playerid); //чтобы игрок мог тратить деньги на тюнинг
			}//игрок в тюнинге
			else {ResetPlayerMoney(playerid); GivePlayerMoney(playerid, Player[playerid][Cash]);} //обновление денег
		} else SetPlayerScore(playerid,0); 
		//Чтобы у игрока тратились деньги за тюнинг

		//Мешок денег за спиной при 500к и более
		if (Player[playerid][Cash] >= 500000 && GetPVarInt(playerid,"CashBag") == 0) {SetPVarInt(playerid, "CashBag", 1); SetPlayerAttachedObject(playerid,1,1550,1,0.0,-0.245,0.0,270.0,103.0,70.0);}
		else if (Player[playerid][Cash] < 500000 && GetPVarInt(playerid,"CashBag") == 1){SetPVarInt(playerid, "CashBag", 0); RemovePlayerAttachedObject(playerid,1);}

		if (Player[playerid][Banned] != 0) {SetPlayerVirtualWorld(playerid,666);SetPlayerChatBubble(playerid, "Забанен", COLOR_RED, 300.0, 1001);}//Ад

		if (SkydiveTime[playerid] > 0){SkydiveTime[playerid]--;}
        if (InviteTime[playerid] > -1){InviteTime[playerid] --;}
        if (InviteTime[playerid] == 0){ShowPlayerDialog(playerid, 777, 0, "Приглашение в клан", "{008E00}Внимание! Вас пригласили в клан, но вы не успели принять приглашение..", "ОК", "");}
    	if (FloodTime[playerid] > 0){FloodTime[playerid]--;}
    	if (HealthTime[playerid] > 0){HealthTime[playerid]--;}
		if (ArmourTime[playerid] > 0){ArmourTime[playerid]--;}
		if (UberNitroTime[playerid] > 0) UberNitroTime[playerid]--;
		if (AdminTPCantKill[playerid] > 0){AdminTPCantKill[playerid]--;}
		if (RepairTime[playerid] > 0) RepairTime[playerid]--;
		if (RepairTime[playerid] == 0 && Player[playerid][SkillRepair] > 0 && GetPlayerVehicleSeat(playerid) == 0 && InEvent[playerid] == 0)
		{//авто-починка авто
	        new Float: vehhealth; GetVehicleHealth(GetPlayerVehicleID(playerid), vehhealth);
	        if (vehhealth < 1000.0)
			{//авто не целое
			    RepairVehicle(GetPlayerVehicleID(playerid));
			    SetPlayerChatBubble(playerid, "Транспорт автоматически отремонтирован.", COLOR_GREEN, 100.0, 3000);
			    PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
			    RepairTime[playerid] = 40 - Player[playerid][SkillRepair];
			}//авто не целое
		}//авто-починка авто
		if (HPRegenTime[playerid] == 0 && Player[playerid][SkillHP] > 0 && GMTestStage[playerid] == 0 && InEvent[playerid] == 0 && PlayerPVP[playerid][Status] < 2)
		{//регенерация HP (навык)
		    new Float: hp;GetPlayerHealth(playerid, hp);
		    if (Player[playerid][PHealth] < 100.0 && InEvent[playerid] == 0)
		    {
		        HPRegenTime[playerid] = 5;
		        if (hp + Player[playerid][SkillHP] <= 100.0) SetPlayerHealth(playerid, hp + Player[playerid][SkillHP]);
		        else SetPlayerHealth(playerid, 100.0);
		    }
		}//регенерация HP (навык)
		if (HPRegenTime[playerid] > 0){HPRegenTime[playerid]--;}//RegenHP Timer
		if (JumpTime[playerid] > 0){JumpTime[playerid]--;new String[5];format(String,sizeof(String),"%d",JumpTime[playerid]);GameTextForPlayer(playerid, String,1000,6);}//Jump Timer
		if (SkillNTime[playerid] > 0){SkillNTime[playerid]--;new String[5];format(String,sizeof(String),"%d",SkillNTime[playerid]);GameTextForPlayer(playerid, String,1000,6);}//Skill N Timer
		if (SkillYTime[playerid] > 0){SkillYTime[playerid]--;new String[5];format(String,sizeof(String),"%d",SkillYTime[playerid]);GameTextForPlayer(playerid, String,1000,6);}//Skill Y Timer
		if (SkillHTime[playerid] > 0){SkillHTime[playerid]--;new String[5];format(String,sizeof(String),"%d",SkillHTime[playerid]);GameTextForPlayer(playerid, String,1000,6);}//Skill H Timer
		if (MapTPTime[playerid] > 0){MapTPTime[playerid]--;}//Skill N Timer
        if (CaseBugTime[playerid] > 0){CaseBugTime[playerid]--;}
        if (PremiumTime[playerid] > 0){PremiumTime[playerid]--;}
        if (OnStartEvent[playerid] > 0){OnStartEvent[playerid]--;}
        if (Player[playerid][EventChangeTime] > 0) Player[playerid][EventChangeTime]--;
        if (LACSH[playerid] > 0){LACSH[playerid]--;}
        if (Player[playerid][LeaveZM] > 0) Player[playerid][LeaveZM]--;
        if (PrestigeTPTime[playerid] > 0) PrestigeTPTime[playerid]--;
        TimeAfterSpawn[playerid]++; LastDeathTime[playerid]++;
        if (Player[playerid][ClanWarTime] > 0) Player[playerid][ClanWarTime]--;
        WeaponShotsLastSecond[playerid] = 0;//Кол-во выстрелов за последнюю секунду
	 	//убирание текстдрава левел-апа
		if (LevelUp[playerid] > -1){LevelUp[playerid]--;}
		if (LevelUp[playerid] == 0)
		{
			TextDrawHideForPlayer(playerid, LevelupTD[playerid]);
			PlayerPlaySound(playerid, 19801, 0.0,0.0,0.0);//Выключение баса
		}

        if (GMTestTime[playerid] > 0)
		{
			GMTestTime[playerid]--;new tester= GMTesterID[playerid];
			if (GMTestTime[playerid] == 0){GMTestStage[playerid] = 0;SendClientMessage(tester,COLOR_YELLOW,"GMTest: Тестирование отменено, так как игрок AFK");}

		}

		if (ArmourTime[playerid] == 59){SetPlayerArmour(playerid, 100.0);}
		if (AntiPlus[playerid] > -1) AntiPlus[playerid] --;
		if (PlayerPVP[playerid][TimeOut] == 1)
		{
			PlayerPVP[playerid][TimeOut] = 0;PlayerPVP[playerid][Status] = 0;PlayerPVP[playerid][Invite] = -1;CanStartPVP[playerid] = 0;
			SendClientMessage(playerid,COLOR_RED,"Время действия приглашения на дуэль истекло.");
			if (JoinEvent[playerid] == EVENT_PVP) JoinEvent[playerid] = 0;
		}
		if (PlayerPVP[playerid][TimeOut] > 1){PlayerPVP[playerid][TimeOut]--;}
        if (LeaveDM[playerid] > 0) LeaveDM[playerid]--;
        if (LeaveGG[playerid] > 0) LeaveGG[playerid]--;

		if (LoginKickTime[playerid] > 0)
		{//Кик если вовремя не ввел пароль
			LoginKickTime[playerid]--;
			if (LoginKickTime[playerid] == 0) Kick(playerid);
			else if (LoginKickTime[playerid] <= 30)
			{
				new StringZ[20];
				format(StringZ, sizeof StringZ, "~R~%d", LoginKickTime[playerid]);
			    GameTextForPlayer(playerid, StringZ, 1000, 6);
		    }
		}//Кик если вовремя не ввел пароль
		

		if(countpos[playerid] != 0)
		{//vortex nitro
			countpos[playerid]++;
			if(countpos[playerid] == 4)
			{
				countpos[playerid] = 0;
				DestroyObject(Flame[playerid][0]);
				DestroyObject(Flame[playerid][1]);
			}
		}//vortex nitro

		//уведомления
		if (Player[playerid][BuddhaTime] == 1){SendClientMessage(playerid,COLOR_QUEST,"Веселый Будда в казино теперь доступен!");PlayerPlaySound(playerid,1083,0.0,0.0,0.0);}//звук выигрыша
        if (QuestTime[playerid][0] == 1 || QuestTime[playerid][1] == 1 || QuestTime[playerid][2] == 1){SendClientMessage(playerid,COLOR_QUEST,"QUEST: Новое задание теперь доступно! Смотри {FF0000}/quests");PlayerPlaySound(playerid,1083,0.0,0.0,0.0);}//звук выигрыша

		if (Player[playerid][HelpTime] > 0) Player[playerid][HelpTime]--;
		if (Player[playerid][HelpTime] == 0)
		{//Система подсказок
		    if (Player[playerid][Level] < 5 && Player[playerid][Prestige] == 0)
		    {//Уровень меншьше 5
		        new hms = random(5) + 1; Player[playerid][HelpTime] = 180;//Каждые 3 минуты для новичков
		        if (hms == 1) SendClientMessage(playerid,COLOR_CYAN,"Подсказка: Вы можете менять транспорт во время езды клавишами {FFFFFF}Y {00CCCC}и {FFFFFF}N.");
		        if (hms == 2) SendClientMessage(playerid,COLOR_CYAN,"Подсказка: Используйте команду {FFFFFF}/bg{00CCCC} чтобы купить оружие.");
		        if (hms == 3) SendClientMessage(playerid,COLOR_CYAN,"Подсказка: Смотрите {FFFFFF}/help{00CCCC} если у вас есть вопросы по игре.");
		        if (hms == 4) SendClientMessage(playerid,COLOR_CYAN,"Подсказка: Участвуйте в соревнованиях (гонки, дерби, зомби т.д.) чтобы повысить свой уровень.");
		        if (hms == 5) SendClientMessage(playerid,COLOR_CYAN,"Подсказка: Используйте {FFFFFF}/gps{00CCCC} чтобы найти работу.");
		    }//Уровень меншьше 5
		    if (Player[playerid][Level] >= 5 && Player[playerid][Level] < 20 && Player[playerid][Prestige] == 0)
		    {//уровень больше 5
		        new hms = random(9) + 1; Player[playerid][HelpTime] = 240;//Каждые 4 минуты для "почти" новичков
		        if (hms == 1) SendClientMessage(playerid,COLOR_CYAN,"Подсказка: Используйте {FFFFFF}/gps{00CCCC} чтобы найти работу.");
		        if (hms == 2) SendClientMessage(playerid,COLOR_CYAN,"Подсказка: Чтобы изменить свой транспорт используйте {FFFFFF}Alt - Изменить мои автомобили{00CCCC}.");
		        if (hms == 3) SendClientMessage(playerid,COLOR_CYAN,"Подсказка: Используйте {FFFFFF}/mygun{00CCCC} чтобы изменить личное оружие. Оно появится после смерти.");
		        if (hms == 4) SendClientMessage(playerid,COLOR_CYAN,"Подсказка: С {FFFFFF}/radio {00CCCC}играть интереснее!");
		        if (hms == 5) SendClientMessage(playerid,COLOR_CYAN,"Подсказка: При помощи {FFFFFF}/myspawn{00CCCC} вы можете изменить стиль и место спавна.");
		        if (hms == 6) SendClientMessage(playerid,COLOR_CYAN,"Подсказка: Смотрите {FFFFFF}/help{00CCCC} если у вас есть вопросы по игре.");
		        if (hms == 7) SendClientMessage(playerid,COLOR_CYAN,"Подсказка: Введите {FFFFFF}/stats{00CCCC} для отображения вашей статистики.");
                if (hms == 8) SendClientMessage(playerid,COLOR_CYAN,"Подсказка: Заметили читера? Сообщите модераторам через {FFFFFF}@{00CCCC}текст.");
                if (hms == 9) SendClientMessage(playerid,COLOR_CYAN,"Подсказка: Не забывайте выполнять задания! Введите {FFFFFF}/quests{00CCCC} чтобы отобразить список заданий.");
 		    }//уровень больше 5
		    if (Player[playerid][Level] >= 20 || Player[playerid][Prestige] > 0)
		    {
		        new hms = random(5) + 1; Player[playerid][HelpTime] = 300;//Каждые 5 минут для всех остальных
                if (hms == 1) SendClientMessage(playerid,COLOR_CYAN,"Подсказка: Смотрите {FFFFFF}/help{00CCCC} если у вас есть вопросы по игре.");
                if (hms == 2) SendClientMessage(playerid,COLOR_CYAN,"Подсказка: С {FFFFFF}/radio {00CCCC}играть интереснее!");
                if (hms == 3) SendClientMessage(playerid,COLOR_CYAN,"Подсказка: Используйте {FFFFFF}/config {00CCCC}чтобы открыть меню настроек аккаунта.");
                if (hms == 4) SendClientMessage(playerid,COLOR_CYAN,"Подсказка: Заметили читера? Сообщите модераторам через {FFFFFF}@{00CCCC}текст.");
                if (hms == 5) SendClientMessage(playerid,COLOR_CYAN,"Подсказка: Не забывайте выполнять задания! Введите {FFFFFF}/quests{00CCCC} чтобы отобразить список заданий.");
		    }
		}//Система подсказок

		//MaxMoney
		if (Player[playerid][Cash] > 999999999)
		{
		    Player[playerid][Cash] = 999999999;
		    SendClientMessage(playerid,COLOR_RED,"Внимание! У вас максимальное количество денег! Все лишние деньги были уничтожены...");
		}

		if(Player[playerid][Muted] > 0 && LAFK[playerid] < 60){Player[playerid][Muted] -= 1;}

		//Исправление ошибки, когда игрок в неактивном соревновании и не может из него выйти
		if (DMTimer > 600 && JoinEvent[playerid] == EVENT_DM && DMTimeToEnd < 1) JoinEvent[playerid] = 0;
		if (DerbyTimer > 600 && JoinEvent[playerid] == EVENT_DERBY) JoinEvent[playerid] = 0;
		if (ZMTimer > 600 && JoinEvent[playerid] == EVENT_ZOMBIE && ZMTimeToEnd < 1) JoinEvent[playerid] = 0;
		if (FRTimer > 600 && JoinEvent[playerid] == EVENT_RACE) JoinEvent[playerid] = 0;
		if (XRTimer > 600 && JoinEvent[playerid] == EVENT_XRACE && XRStarted[playerid] == 0) JoinEvent[playerid] = 0;
		if (GGTimer > 600 && JoinEvent[playerid] == EVENT_GUNGAME && GGTimeToEnd < 1) JoinEvent[playerid] = 0;

		//--- Синхронизация погоды и времени
		if (LSpecID[playerid] == -1)
		{//игрок не в спектре
		    //Погода
			if (PlayerWeather[playerid] != -1 && InEvent[playerid] == 0)
				SetPlayerWeather(playerid, PlayerWeather[playerid]);
			else SetPlayerWeather(playerid, ServerWeather);
			//Время
			if (PlayerTime[playerid] != -1 && InEvent[playerid] == 0)
				SetPlayerTime(playerid, PlayerTime[playerid], minute);
			else SetPlayerTime(playerid, hour, minute);
		}//игрок не в спектре
		else
		{//игрок в спектре
		    new specid = LSpecID[playerid];
		    if (PlayerWeather[specid] != -1 && InEvent[specid] == 0)
				SetPlayerWeather(playerid, PlayerWeather[specid]);
			else SetPlayerWeather(playerid, ServerWeather);
			//Время
			if (PlayerTime[specid] != -1 && InEvent[specid] == 0)
				SetPlayerTime(playerid, PlayerTime[specid], minute);
			else SetPlayerTime(playerid, hour, minute);
		}//игрок в спектре
		//--- Синхронизация погоды и времени

		if (AirportTime[playerid] >= 0){AirportTime[playerid] --;}
		if (AirportTime[playerid] == 0 && InEvent[playerid] == 0)
		{//перелет между аэро
		    if (AirportID[playerid] > 0 && AirportID[playerid] <= 5)
		    {
			    SetPlayerInterior(playerid,0);SetPlayerVirtualWorld(playerid, 0);
			    if (AirportID[playerid] == 1)
			    {
			        SetPlayerPos(playerid,1451.6349, -2287.0703, 13.5469);SetPlayerFacingAngle(playerid,90.0);SetCameraBehindPlayer(playerid);
			        SendClientMessage(playerid,COLOR_YELLOW,"Добро пожаловать в {FFFFFF}Лос Сантос");
				}
				if (AirportID[playerid] == 2)
			    {
			        SetPlayerPos(playerid,-1404.6575, -303.7458, 14.1484);SetPlayerFacingAngle(playerid,140.0);SetCameraBehindPlayer(playerid);
			        SendClientMessage(playerid,COLOR_YELLOW,"Добро пожаловать в {FFFFFF}Сан Фиерро");
				}
				if (AirportID[playerid] == 3)
			    {
			        SetPlayerPos(playerid,1672.9861, 1447.9349, 10.7868);SetPlayerFacingAngle(playerid,270.0);SetCameraBehindPlayer(playerid);
			        SendClientMessage(playerid,COLOR_YELLOW,"Добро пожаловать в {FFFFFF}Лас Вентурас");
				}
				if (AirportID[playerid] == 4)
			    {
			        SetPlayerPos(playerid,-2281.9551, 2288.5420, 4.9740);SetPlayerFacingAngle(playerid,270.0);SetCameraBehindPlayer(playerid);
			        SendClientMessage(playerid,COLOR_YELLOW,"Добро пожаловать в {FFFFFF}Бэйсайд");
				}
			}
		}//перелет между аэро

		//Убирание брони в соревнованиях
		if(InEvent[playerid] > 0 && InEvent[playerid] != EVENT_PVP){SetPlayerArmour(playerid, 0);}

		//Уничтожение авто если загорелось и отображение времени до трансформации
		if (TimeTransform[playerid] > 0){TimeTransform[playerid]--;new String[5];format(String,sizeof(String),"%d",TimeTransform[playerid]);GameTextForPlayer(playerid, String,1000,6);}
		if (IsPlayerInVehicle(playerid,PlayerCarID[playerid]))
		{//игрок в своей машине
			GetVehicleHealth(PlayerCarID[playerid], carhealth);
			if (PrestigeGM[playerid] == 1 && InEvent[playerid] == 0) RepairVehicle(PlayerCarID[playerid]);
			if (carhealth <= 250 && PrestigeGM[playerid] == 0){DestroyVehicle(PlayerCarID[playerid]);PlayerCarID[playerid] = 0;Player[playerid][CarActive] = 0;TimeTransform[playerid] = 10;}
		}//игрок в своей машине

        if (second == 0)
        {//обновление счетчика кол-ва следящим за игроком раз в минуту
            LSpectators[playerid] = 0;
            foreach(Player, i)
			{//цикл
			    if(LSpecID[i] == playerid && IsPlayerConnected(i)){LSpectators[playerid] += 1;}
			}//цикл
        }//обновление счетчика кол-ва следящим за игроком раз в минуту

		if (Player[playerid][BuddhaTime] > 0){Player[playerid][BuddhaTime]--;}
        if (QuestTime[playerid][0] > 0) QuestTime[playerid][0]--;
        if (QuestTime[playerid][1] > 0) QuestTime[playerid][1]--;
        if (QuestTime[playerid][2] > 0) QuestTime[playerid][2]--;
        
		if (LAFK[playerid] < 600)
		{//игрок не в афк, либо афк менее 10 минут
			Player[playerid][Time]++;//общее время на серве
		    if (Player[playerid][GPremium] >= 3 && Player[playerid][Time] == Player[playerid][Time] / 3600 * 3600)
		    {//ViP 3: +500k в час
		        PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
		        if (Player[playerid][Bank] <= 999499999)
		        {
			        Player[playerid][Bank] += 500000;
					SendClientMessage(playerid, 0x00FF00FF, "ViP: Вы получили ежечасовой бонус в размере 500 000$ на ваш банковский счет");
				}
				else
				{
				    Player[playerid][Cash] += 500000;
					SendClientMessage(playerid, 0x00FF00FF, "ViP: Вы получили ежечасовой бонус в размере 500 000$");
				}
		    }//ViP 3: +500k в час
	    }//игрок не в афк, либо афк менее 10 минут

		//---------- карма
		if (LAFK[playerid] < 60){Player[playerid][KarmaTime]++;}
		new xkarm = Player[playerid][KarmaTime] / 600;new xkarm2 = xkarm*600;//делит на 600 без остатка и умножает на 600
		if (xkarm2 == Player[playerid][KarmaTime])
		{//если прошло еще 10 минут без убийств и пора начислять карму
		    new Float: x, Float: y, Float: z;GetPlayerPos(playerid,x,y,z);
			new Float: xdist = x - KarmaX[playerid], Float: ydist = y - KarmaY[playerid];
			if (xdist < 0) xdist = xdist * -1;//Расстояние смещения по X от точки предыдущего начисления кармы
			if (ydist < 0) ydist = ydist * -1;//Расстояние смещения по Y от точки предыдущего начисления кармы
		    if (xdist < 10 && ydist < 10) SendClientMessage(playerid,COLOR_RED,"Вы не получили очков кармы так как всё время стояли на месте.");
		    else
		    {//игрок не стоял на месте и ему надо начислить карму
		        new String[120], kpoint;
	      	    if(xkarm == 1) kpoint = 2; if(xkarm == 2) kpoint = 4;
			    if(xkarm == 3) kpoint = 6; if(xkarm == 4) kpoint = 8;
			    if(xkarm >= 5) kpoint = 10;
				Player[playerid][Karma] += kpoint;
				if (Player[playerid][Karma] > 1000) Player[playerid][Karma] = 1000;
				else
				{
					format(String,sizeof(String),"Вы получили %d очков кармы! Продержитесь без убийств еще 10 минут и вы получите больше.",kpoint);SendClientMessage(playerid,COLOR_YELLOW,String);
					if(Player[playerid][GPremium] >= 7){format(String,sizeof(String),"ViP: Вы получили бонус %d очков кармы",kpoint/2);SendClientMessage(playerid,0x00FF00FF,String);Player[playerid][Karma] += kpoint/2;}
					PlayerPlaySound(playerid,1083,0.0,0.0,0.0);//Звук выигрыша
				}
			    KarmaX[playerid] = x; KarmaY[playerid] = y; KarmaZ[playerid] = z;
		    }//игрок не стоял на месте и ему надо начислить карму
		}//если прошло еще 10 минут без убийств и пора начислять карму

		//---------- Синхронизация цвета игрока
		if (Logged[playerid] == 0) SetPlayerColor(playerid,0xAFAFAFFF);//не залогинелся
		else
		{//игрок залогинелся
			new colorid = PlayerColor[playerid], clanid = Player[playerid][MyClan];
			if (Player[playerid][MyClan] < 1 || Clan[clanid][cBase] < 1) colorid = 0; //Если игрок не в клане или если у клана нет штаба - цвет ника будет серым
			
	        if (Player[playerid][Invisible] > 0 && InEvent[playerid] == 0) SetPlayerColor(playerid, ClanColorInvisible[colorid]);//С невидимостью
			else
			{//Без невидимости или в соревах
			    if (Player[playerid][PrestigeColor] >= 0) colorid = Player[playerid][PrestigeColor]; //Цвет 7-го Престижа
				SetPlayerColor(playerid, ClanColor[colorid]);

				if (InEvent[playerid] == EVENT_ZOMBIE && ZMIsPlayerIsZombie[playerid] > 0) SetPlayerColor(playerid, ClanColorInvisible[colorid]);
			}//Без невидимости или в соревах
		}//игрок залогинелся
		//---------- Синхронизация цвета игрока

		if  (SkinChangeMode[playerid] == 1) JoinEvent[playerid] = 0;//Исправление бага при изменении скина

		//--------- PVP
		if (PlayerPVP[playerid][Status] >= 2)
		{//Игрок в PVP
		    if (PlayerPVP[playerid][Status] == 2)
		    {
		        ResetPlayerWeapons(playerid);
				GiveWeapon(playerid,PlayerPVP[playerid][PlayWeapon],20000);
				if (PlayerPVP[playerid][PlayHealth] < 101){SetPlayerHealth(playerid,PlayerPVP[playerid][PlayHealth]);SetPlayerArmour(playerid,0);}
				else{SetPlayerHealth(playerid,100);SetPlayerArmour(playerid,PlayerPVP[playerid][PlayHealth] - 100);}
				PlayerPlaySound(playerid,1056,0.0,0.0,0.0);GameTextForPlayer(playerid, "2",1000,6);
				SetCameraBehindPlayer(playerid);
		    }
		    if (PlayerPVP[playerid][Status] == 3){PlayerPlaySound(playerid,1056,0.0,0.0,0.0);GameTextForPlayer(playerid, "1",1000,6);}
		    if (PlayerPVP[playerid][Status] == 4){PlayerPlaySound(playerid,1057,0.0,0.0,0.0);GameTextForPlayer(playerid, "GO",1000,6);TogglePlayerControllable(playerid,1);}
		    if (PlayerPVP[playerid][Status] < 5) PlayerPVP[playerid][Status]++;
		    if (PlayerPVP[playerid][Status] == 5)
		    {//После старта PVP
		        new Float: x, Float: y, Float: z;GetPlayerPos(playerid,x,y,z);
		        if (PlayerPVP[playerid][PlayMap] == 1 && z < 1038) FailPVP(playerid);
		        if (PlayerPVP[playerid][PlayMap] == 2 && z < 2.5) FailPVP(playerid);
		        if (PlayerPVP[playerid][PlayMap] == 3 && z < 132) FailPVP(playerid);
		        if (PlayerPVP[playerid][PlayMap] == 4 && z < 78) FailPVP(playerid);
		        if (PlayerPVP[playerid][PlayMap] == 5 && z < 66) FailPVP(playerid);
		        if (PlayerPVP[playerid][PlayMap] == 6 && z < 72) FailPVP(playerid);
		        if (PlayerPVP[playerid][PlayMap] == 7 && z < 20) FailPVP(playerid);
		        if (PlayerPVP[playerid][PlayMap] == 8 && z < 75) FailPVP(playerid);
		        if (PlayerPVP[playerid][PlayMap] == 9 && z < 1.3) FailPVP(playerid);
		        if (PlayerPVP[playerid][PlayMap] == 10 && z < 144) FailPVP(playerid);
		        if (LAFK[playerid] > 3) FailPVP(playerid);
		    }//После старта PVP
		}//Игрок в PVP
        //--------- PVP

        if (OnFly[playerid] == 1)//Отключение режима супермена в соревах и тд
        {if (IsPlayerInAnyVehicle(playerid) || InEvent[playerid] > 0) StopFly(playerid); else SetPlayerChatBubble(playerid,"Superman (Престиж)",COLOR_YELLOW,200,1001);}

		if (GetPlayerPing(playerid) < MAX_PING) BadPingTime[playerid] = 0;
		else
		{
		    BadPingTime[playerid]++;
		    if (BadPingTime[playerid] == 10)
		    {
		        new String[140]; GKick(playerid);
				format(String,sizeof(String), "SERVER: %s[%d] был автоматически кикнут (Ping: %d).", PlayerName[playerid], playerid, GetPlayerPing(playerid));
				return SendClientMessageToAll(COLOR_GREY, String);
		    }
		}
    	#include "Transformer\LAC" //Lomt1k`s AntiCheat
		if (GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USEJETPACK && InEvent[playerid] != 0) SetPlayerSpecialAction(playerid, 0); //Исправляем баг с джетпаком на соревнованиях
		//Убираем текстдравы о старте соревнований, если игрок вне сорев
		if (JoinEvent[playerid] == 0) for (new i = 1; i <= 6; i++) TextDrawHideForPlayer(playerid, TextDrawEvent[i]);

	    LAFK[playerid] += 1;
		if (LAFK[playerid] >= 3)
		{
		    new afstring[120];
		    if (LAFK[playerid] > 60){new mi = LAFK[playerid]/60; format(afstring,sizeof(afstring),"AFK (%d минут %d секунд)",mi,LAFK[playerid] - 60 * mi);}
			else {format(afstring,sizeof(afstring),"AFK (%d секунд)",LAFK[playerid]);}
			SetPlayerChatBubble(playerid,afstring,COLOR_GREY, 80.0,1000);NeedSpeedDown[playerid] = 1; LACSH[playerid] = 3;
		}
		
		return 1;
}//кц пб


public OnPlayerModelSelection(playerid, response, listid, modelid)
{//меню
	if(listid == MenuMyskin)
    {//myskin
        if(response)
        {
            SendClientMessage(playerid, COLOR_YELLOW, "Модель персонажа успешно изменена");
            SetPlayerSkin(playerid,modelid);Player[playerid][Model] = modelid;
	    }
	}//myskin
	
	if(listid == MenuFirstCar)
    {//выбор первого автомобиля (обучение)
		if(response)
		{//респонс
		    Player[playerid][CarSlot2] = modelid;TutorialStep[playerid] = 3;
		    new String[1024];
			strcat(String, "{007FFF}Обучение: Трансформация{FFFFFF}\n\n");
			strcat(String, "Вы можете прямо во время езды трансформироваться из мопеда в автомобиль!\n");
			strcat(String, "Для этого используйте клавиши {00FF00}Y{FFFFFF} и {00FF00}N\n");
			strcat(String, "\n\n{FFFF00}Нажмите ОК и трансформируйтесь в автомобиль клавишей {00FF00}Y{FFFF00} или {00FF00}N");
			ShowPlayerDialog(playerid, DIALOG_TUTORIAL, 0, "Обучение", String, "ОК", "");
		}//респонс
		else{ShowModelSelectionMenu(playerid, MenuFirstCar, "First Car");}
	}//выбор первого автомобиля (обучение)
	
	if(listid == MenuClass1)
    {//выбор авто класс 1
			if(response)
			{
			    if(modelid == 1343)
				{//Корзина - удалить транспорт
				    Player[playerid][CarSlot1] = 0;
					return SendClientMessage(playerid,COLOR_YELLOW,"Автомобиль 1-го класса удален");
				}//Корзина - удалить транспорт

				new CarLevel, CarPrice = 0, String[120];
			    if(modelid == 509) CarLevel = 0;//bike
				if(modelid == 462) CarLevel = 0;//faggio
				if(modelid == 586) CarLevel = 5;
				if(modelid == 471) CarLevel = 5;
    			if(modelid == 478) CarLevel = 12;
				if(modelid == 424) CarLevel = 16;
				if(modelid == 539) CarLevel = 20;
				if(modelid == 408) CarLevel = 24;
				if(modelid == 434) CarLevel = 28;
				if(modelid == 522) CarLevel = 45;
				if(modelid == 406) CarLevel = 49;
				if(modelid == 441) CarLevel = 57;
				if(modelid == 564) CarLevel = 57;
				if(modelid == 465) CarLevel = 58;
				if(modelid == 501) CarLevel = 58;
				if(modelid == 464) CarLevel = 58;
				if(modelid == 432) CarLevel = 75;
				if (CarLevel >= 10) CarPrice = CarLevel * 1500;
				if (Player[playerid][Karma] >= 800) CarPrice /= 2;//При карме 800+ транспорт стоит в два раза дешевле
				
				if (Player[playerid][Level] < CarLevel){ShowModelSelectionMenu(playerid, MenuClass1, "Car Class 1");format(String,sizeof(String),"ОШИБКА: Вы должны быть как минимум %d-го уровня",CarLevel);return SendClientMessage(playerid,COLOR_RED,String);}
				if (Player[playerid][Cash] < CarPrice && CarPrice > 0){ShowModelSelectionMenu(playerid, MenuClass1, "Car Class 1");format(String,sizeof(String),"ОШИБКА: Вам нужно как минимум %d$",CarPrice);return SendClientMessage(playerid,COLOR_RED,String);}
				Player[playerid][CarSlot1] = modelid;Player[playerid][Cash] -= CarPrice; ResetTuneClass1(playerid);
				Player[playerid][CarActive] = 0;
				modelid -= 400;format(String,sizeof(String),"Ваш новый автомобиль 1-го класса - %s",PlayerVehicleName[modelid]);SendClientMessage(playerid,COLOR_YELLOW,String);
				if (CarPrice > 0){format(String,sizeof(String),"Вы потратили на него %d$",CarPrice);SendClientMessage(playerid,COLOR_YELLOW,String);}
			}
			else{ShowPlayerDialog(playerid, 3, 2, "Замена личного транспорта", "Класс 1\nКласс 2\nКласс 3\n{FFFF00}Prestige{FFFFFF}\nОтмена", "ОК", "");}
    }//выбор авто класс 1
    
    if(listid == MenuClass2)
    {//выбор авто класс 2
    if(response)
			{
			    if(modelid == 1343)
				{//Корзина - удалить транспорт
				    Player[playerid][CarSlot2] = 0;
					return SendClientMessage(playerid,COLOR_YELLOW,"Автомобиль 2-го класса удален");
				}//Корзина - удалить транспорт
				
				if(modelid == 365)
				{//paintjob
					if (Player[playerid][Level] < 55){ShowModelSelectionMenu(playerid, MenuClass2, "Car Class 2");SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вы должны быть как минимум 55-го уровня");return 1;}
					return ShowModelSelectionMenu(playerid, MenuPaintJob, "PaintJob Cars");
				}//paintjob
				
				new CarLevel, CarPrice = 0, String[120];
				if(modelid == 561) CarLevel = 1;
				if(modelid == 558) CarLevel = 1;
				if(modelid == 555) CarLevel = 1;
				if(modelid == 496) CarLevel = 1;
				if(modelid == 542) CarLevel = 1;
				if(modelid == 589) CarLevel = 3;
				if(modelid == 565) CarLevel = 3;
				if(modelid == 602) CarLevel = 3;
				if(modelid == 444) CarLevel = 8;
				if(modelid == 475) CarLevel = 8;
				if(modelid == 603) CarLevel = 8;
				if(modelid == 560) CarLevel = 14;
				if(modelid == 559) CarLevel = 14;
				if(modelid == 506) CarLevel = 14;
				if(modelid == 562) CarLevel = 14;
				if(modelid == 477) CarLevel = 22;
				if(modelid == 402) CarLevel = 22;
				if(modelid == 480) CarLevel = 22;
				if(modelid == 415) CarLevel = 22;
				if(modelid == 451) CarLevel = 26;
				if(modelid == 541) CarLevel = 26;
				if(modelid == 429) CarLevel = 26;
				if(modelid == 494) CarLevel = 30;
				if(modelid == 411) CarLevel = 50;
				if (CarLevel >= 10) CarPrice = CarLevel * 1500;
				if (Player[playerid][Karma] >= 800) CarPrice /= 2;//При карме 800+ транспорт стоит в два раза дешевле
				
                if (Player[playerid][Level] < CarLevel){ShowModelSelectionMenu(playerid, MenuClass2, "Car Class 2");format(String,sizeof(String),"ОШИБКА: Вы должны быть как минимум %d-го уровня",CarLevel);return SendClientMessage(playerid,COLOR_RED,String);}
				if (Player[playerid][Cash] < CarPrice && CarPrice > 0){ShowModelSelectionMenu(playerid, MenuClass2, "Car Class 2");format(String,sizeof(String),"ОШИБКА: Вам нужно как минимум %d$",CarPrice);return SendClientMessage(playerid,COLOR_RED,String);}
				Player[playerid][CarSlot2] = modelid;Player[playerid][Cash] -= CarPrice; ResetTuneClass2(playerid);
                Player[playerid][CarActive] = 0;
				modelid -= 400;format(String,sizeof(String),"Ваш новый автомобиль 2-го класса - %s",PlayerVehicleName[modelid]);SendClientMessage(playerid,COLOR_YELLOW,String);
				if (CarPrice > 0){format(String,sizeof(String),"Вы потратили на него %d$",CarPrice);SendClientMessage(playerid,COLOR_YELLOW,String);}
    		}
    		else{ShowPlayerDialog(playerid, 3, 2, "Замена личного транспорта", "Класс 1\nКласс 2\nКласс 3\n{FFFF00}Prestige{FFFFFF}\nОтмена", "ОК", "");}
    }//выбор авто класс 2

    if(listid == MenuClass3)
    {//выбор авто класс 3
    		if(response)
			{
			    if(modelid == 1343)
				{//Корзина - удалить транспорт
				    Player[playerid][CarSlot3] = 0;
					return SendClientMessage(playerid,COLOR_YELLOW,"Автомобиль 3-го класса удален");
				}//Корзина - удалить транспорт
				
				if(modelid == 539)
				{//UberVortex
					if (Player[playerid][Level] < 90){ShowModelSelectionMenu(playerid, MenuClass3, "Car Class 3");SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вы должны быть как минимум 90-го уровня");return 1;}
					if (Player[playerid][Cash] < 200000 && Player[playerid][Karma] < 900){ShowModelSelectionMenu(playerid, MenuClass3, "Car Class 3");return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вам нужно как минимум 200000$");}
					Player[playerid][CarSlot3] = 539;
					
					SendClientMessage(playerid,COLOR_YELLOW,"Ваш новый автомобиль 3-го класса - {9966CC}Uber{007FFF}Vortex");
					if (Player[playerid][Karma] < 900){Player[playerid][Cash] -= 200000; SendClientMessage(playerid,COLOR_YELLOW,"Вы потратили на него 150000$");}
					return SendClientMessage(playerid,COLOR_YELLOW,"Особые функции: [ЛКМ] - ускорение, [2] - взлет, [Гудок] - приземление");
				}//UberVortex
				
				new CarLevel, CarPrice = 0, String[120];
				if(modelid == 473) CarLevel = 6;
				if(modelid == 452) CarLevel = 7;
				if(modelid == 493) CarLevel = 9;
				if(modelid == 512) CarLevel = 11;
				if(modelid == 446) CarLevel = 15;
				if(modelid == 469) CarLevel = 17;
				if(modelid == 447) CarLevel = 19;
				if(modelid == 593) CarLevel = 21;
				if(modelid == 487) CarLevel = 23;
				if(modelid == 460) CarLevel = 25;
				if(modelid == 513) CarLevel = 29;
				if(modelid == 476) CarLevel = 32;
				if(modelid == 519) CarLevel = 68;
				if(modelid == 425) CarLevel = 78;
				if(modelid == 520) CarLevel = 85;
                if (CarLevel >= 10) CarPrice = CarLevel * 2000;
                if (Player[playerid][Karma] >= 800) CarPrice /= 2;//При карме 800+ транспорт стоит в два раза дешевле

                if (Player[playerid][Level] < CarLevel){ShowModelSelectionMenu(playerid, MenuClass3, "Car Class 3");format(String,sizeof(String),"ОШИБКА: Вы должны быть как минимум %d-го уровня",CarLevel);return SendClientMessage(playerid,COLOR_RED,String);}
				if (Player[playerid][Cash] < CarPrice && CarPrice > 0){ShowModelSelectionMenu(playerid, MenuClass3, "Car Class 3");format(String,sizeof(String),"ОШИБКА: Вам нужно как минимум %d$",CarPrice);return SendClientMessage(playerid,COLOR_RED,String);}
				Player[playerid][CarSlot3] = modelid;Player[playerid][Cash] -= CarPrice;
                Player[playerid][CarActive] = 0;
				modelid -= 400;format(String,sizeof(String),"Ваш новый автомобиль 3-го класса - %s",PlayerVehicleName[modelid]);SendClientMessage(playerid,COLOR_YELLOW,String);
				if (CarPrice > 0){format(String,sizeof(String),"Вы потратили на него %d$",CarPrice);SendClientMessage(playerid,COLOR_YELLOW,String);}
				
			}
			else{ShowPlayerDialog(playerid, 3, 2, "Замена личного транспорта", "Класс 1\nКласс 2\nКласс 3\n{FFFF00}Prestige{FFFFFF}\nОтмена", "ОК", "");}
    }//выбор авто класс 3
    
    if(listid == MenuPaintJob)
    {//PaintJob Cars
    		if(response)
			{
			    new CarLevel, CarPrice = 0, String[120];
			    if(modelid == 483) CarLevel = 22;
				if(modelid == 534) CarLevel = 22;
				if(modelid == 535) CarLevel = 22;
				if(modelid == 536) CarLevel = 22;
				if(modelid == 558) CarLevel = 1;
				if(modelid == 559) CarLevel = 14;
				if(modelid == 560) CarLevel = 14;
				if(modelid == 561) CarLevel = 14;
				if(modelid == 562) CarLevel = 14;
				if(modelid == 565) CarLevel = 2;
				if(modelid == 567) CarLevel = 22;
				if(modelid == 575) CarLevel = 22;
				if(modelid == 576) CarLevel = 22;
				if (CarLevel >= 10) CarPrice = CarLevel * 1500;
				if (Player[playerid][Karma] >= 800) CarPrice /= 2;
			
				if (Player[playerid][Cash] < CarPrice && CarPrice > 0){ShowModelSelectionMenu(playerid, MenuPaintJob, "PaintJob Cars");format(String,sizeof(String),"ОШИБКА: Вам нужно как минимум %d$",CarPrice);return SendClientMessage(playerid,COLOR_RED,String);}
				Player[playerid][CarSlot2] = modelid;Player[playerid][Cash] -= CarPrice;ResetTuneClass2(playerid);
                Player[playerid][CarActive] = 0;
				modelid -= 400;format(String,sizeof(String),"Ваш новый автомобиль 2-го класса - %s",PlayerVehicleName[modelid]);SendClientMessage(playerid,COLOR_YELLOW,String);
				if (CarPrice > 0){format(String,sizeof(String),"Вы потратили на него %d$",CarPrice);SendClientMessage(playerid,COLOR_YELLOW,String);}

				if(modelid == 83)
				{//Фургончик
				    Player[playerid][CarSlot2PaintJob] = 0;
				}//Фургончик
				else if (modelid == 134 || modelid == 136 || modelid == 167 || modelid == 175 || modelid == 176)
				{//lowrider
				    SendClientMessage(playerid, COLOR_YELLOW, "На этот автомобиль можно установить покрасочные работы в автомастерской {FFFFFF}Lowrider");
				}//lowrider
				else
				{//Arch Angels
				    SendClientMessage(playerid, COLOR_YELLOW, "На этот автомобиль можно установить покрасочные работы в автомастерской {FFFFFF}Arch Angels");
				}//Arch Angels
			}
			else{ShowPlayerDialog(playerid, 3, 2, "Замена личного транспорта", "Класс 1\nКласс 2\nКласс 3\n{FFFF00}Prestige{FFFFFF}\nОтмена", "ОК", "");}
	}//PaintJob Cars

    if(listid == MenuBuyGun)
    {//оружейный магазин
		{//оружейный магазин
			if(response)
			{
			    if (InEvent[playerid] > 0) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Нельзя покупать оружие в соревнованиях");
                    if(modelid == 1240)
					{//аптечка
						if (HealthTime[playerid] > 0)
						{
							new str[120];format(str, sizeof(str), "{FF0000}Покупка аптечки станет доступна через {FFFFFF}%d{FF0000} секунд.", HealthTime[playerid]);
							SendClientMessage(playerid,COLOR_RED,str);ShowModelSelectionMenu(playerid, MenuBuyGun, "Buy Gun");return 1;
						}
						if (Player[playerid][Cash] < 100 && Player[playerid][Karma] < 600){SendClientMessage(playerid,COLOR_RED,"Для покупки аптечки вам нужно 100$");return 1;}
	     				SetPlayerChatBubble(playerid, "Приобрел аптечку", COLOR_GREEN, 100.0, 3000);
						ShowModelSelectionMenu(playerid, MenuBuyGun, "Buy Gun");
						HealthTime[playerid] = 30; SetPlayerHealth(playerid, 100);
						if (Player[playerid][Karma] < 600) {Player[playerid][Cash] -= 100; SendClientMessage(playerid,COLOR_YELLOW,"Вы купили аптечку за 100$");}
						else SendClientMessage(playerid,COLOR_YELLOW,"Вы получили аптечку.");
						QuestUpdate(playerid, 30, 100);//Обновление квеста Потратьте 25к в /bg
					}//аптечка
					if(modelid == 1242)
					{//покупка брони за 250$
					    if (Player[playerid][Karma] <= -600) return SendClientMessage(playerid, COLOR_RED, "Вы не можете покупать аптечки броню из-за слишком низкой кармы.");
						if (ArmourTime[playerid] > 0)
						{
							new str[120];format(str, sizeof(str), "{FF0000}Покупка брони станет доступна через {FFFFFF}%d{FF0000} секунд.", ArmourTime[playerid]);
							SendClientMessage(playerid,COLOR_RED,str);ShowModelSelectionMenu(playerid, MenuBuyGun, "Buy Gun");return 1;
						}
						if (Player[playerid][Cash] < 250 && Player[playerid][Karma] < 600){SendClientMessage(playerid,COLOR_RED,"Для покупки брони вам нужно 250$");return 1;}
	     				SetPlayerChatBubble(playerid, "Приобрел броню", COLOR_GREEN, 100.0, 3000);
						ShowModelSelectionMenu(playerid, MenuBuyGun, "Buy Gun"); ArmourTime[playerid] = 60;
                        if (Player[playerid][Karma] < 600) {Player[playerid][Cash] -= 250; SendClientMessage(playerid,COLOR_YELLOW,"Вы купили броню за 250$");}
						else SendClientMessage(playerid,COLOR_YELLOW,"Вы получили броню.");
						QuestUpdate(playerid, 30, 250);//Обновление квеста Потратьте 25к в /bg
					}//покупка брони за 250$
					if(modelid == 347)
					{//9мм силенсед 100$
						if (Player[playerid][Cash] < 100){SendClientMessage(playerid,COLOR_RED,"Для покупки пистолета с глушителем вам нужно 100$");return 1;}
						Player[playerid][Cash] -= 100;GivePlayerWeapon(playerid,23,70);SetPlayerChatBubble(playerid, "Приобрел пистолет с глушителем", COLOR_GREEN, 100.0, 3000);
	 					ShowModelSelectionMenu(playerid, MenuBuyGun, "Buy Gun");
	 					SendClientMessage(playerid,COLOR_YELLOW,"Вы купили 9мм пистолет с глушителем за 100$");
	 					QuestUpdate(playerid, 30, 100);//Обновление квеста Потратьте 25к в /bg
					}//9мм силенсед 100$
					if(modelid == 346)
					{//9мм  200$
						if (Player[playerid][Cash] < 200){SendClientMessage(playerid,COLOR_RED,"Для покупки 9мм пистолета вам нужно 200$");return 1;}
						Player[playerid][Cash] -= 200;GivePlayerWeapon(playerid,22,70);SetPlayerChatBubble(playerid, "Приобрел 9мм пистолет", COLOR_GREEN, 100.0, 3000);
	 					ShowModelSelectionMenu(playerid, MenuBuyGun, "Buy Gun");
	 					SendClientMessage(playerid,COLOR_YELLOW,"Вы купили 9мм пистолет за 200$");
	 					QuestUpdate(playerid, 30, 200);//Обновление квеста Потратьте 25к в /bg
					}//9мм 200$
					if(modelid == 348)
					{//дигл  500$
						if (Player[playerid][Cash] < 500){SendClientMessage(playerid,COLOR_RED,"Для покупки Desert Eagle вам нужно 500$");return 1;}
						Player[playerid][Cash] -= 500;GivePlayerWeapon(playerid,24,70);SetPlayerChatBubble(playerid, "Приобрел Desert Eagle", COLOR_GREEN, 100.0, 3000);
	 					ShowModelSelectionMenu(playerid, MenuBuyGun, "Buy Gun");
	 					SendClientMessage(playerid,COLOR_YELLOW,"Вы купили Desert Eagle за 500$");
	 					QuestUpdate(playerid, 30, 500);//Обновление квеста Потратьте 25к в /bg
					}//дигл 500$
					if(modelid == 349)
					{//дробовик  250$
						if (Player[playerid][Cash] < 250){SendClientMessage(playerid,COLOR_RED,"Для покупки дробовика вам нужно 250$");return 1;}
						Player[playerid][Cash] -= 250;GivePlayerWeapon(playerid,25,28);SetPlayerChatBubble(playerid, "Приобрел дробовик", COLOR_GREEN, 100.0, 3000);
	 					ShowModelSelectionMenu(playerid, MenuBuyGun, "Buy Gun");
	 					SendClientMessage(playerid,COLOR_YELLOW,"Вы купили Дробовик за 250$");
	 					QuestUpdate(playerid, 30, 250);//Обновление квеста Потратьте 25к в /bg
					}//дробовик 250$
					if(modelid == 350)
					{//обрез
						if (Player[playerid][Cash] < 800){SendClientMessage(playerid,COLOR_RED,"Для покупки обрезов вам нужно 800$");return 1;}
						Player[playerid][Cash] -= 800;GivePlayerWeapon(playerid,26,48);SetPlayerChatBubble(playerid, "Приобрел обрез", COLOR_GREEN, 100.0, 3000);
	 					ShowModelSelectionMenu(playerid, MenuBuyGun, "Buy Gun");
	 					SendClientMessage(playerid,COLOR_YELLOW,"Вы купили Обрез за 800$");
	 					QuestUpdate(playerid, 30, 800);//Обновление квеста Потратьте 25к в /bg
					}//обрез
					if(modelid == 351)
					{//спас
						if (Player[playerid][Cash] < 1200){SendClientMessage(playerid,COLOR_RED,"Для покупки SPAS12 вам нужно 1200$");return 1;}
						Player[playerid][Cash] -= 1200;GivePlayerWeapon(playerid,27,48);SetPlayerChatBubble(playerid, "Приобрел SPAS12", COLOR_GREEN, 100.0, 3000);
	  					ShowModelSelectionMenu(playerid, MenuBuyGun, "Buy Gun");
	  					SendClientMessage(playerid,COLOR_YELLOW,"Вы купили SPAS12 за 1200$");
	  					QuestUpdate(playerid, 30, 1200);//Обновление квеста Потратьте 25к в /bg
					}//спас
					if(modelid == 353)
					{//MP5
					   	if (Player[playerid][Cash] < 500){SendClientMessage(playerid,COLOR_RED,"Для покупки MP5 вам нужно 500$");return 1;}
						Player[playerid][Cash] -= 500;GivePlayerWeapon(playerid,29,500);SetPlayerChatBubble(playerid, "Приобрел MP5", COLOR_GREEN, 100.0, 3000);
	 					ShowModelSelectionMenu(playerid, MenuBuyGun, "Buy Gun");
	 					SendClientMessage(playerid,COLOR_YELLOW,"Вы купили MP5 за 500$");
	 					QuestUpdate(playerid, 30, 500);//Обновление квеста Потратьте 25к в /bg
					}//MP5
					if(modelid == 372)
					{//Tec9
					   	if (Player[playerid][Cash] < 650){SendClientMessage(playerid,COLOR_RED,"Для покупки Tec9 вам нужно 650$");return 1;}
						Player[playerid][Cash] -= 650;GivePlayerWeapon(playerid,32,500);SetPlayerChatBubble(playerid, "Приобрел Tec9", COLOR_GREEN, 100.0, 3000);
	 					ShowModelSelectionMenu(playerid, MenuBuyGun, "Buy Gun");
	 					SendClientMessage(playerid,COLOR_YELLOW,"Вы купили Tec9 за 650$");
	 					QuestUpdate(playerid, 30, 650);//Обновление квеста Потратьте 25к в /bg
					}//Tec9
					if(modelid == 352)
					{//UZI
					    if (Player[playerid][Cash] < 650){SendClientMessage(playerid,COLOR_RED,"Для покупки MiniUZI вам нужно 650$");return 1;}
						Player[playerid][Cash] -= 650;GivePlayerWeapon(playerid,28,500);SetPlayerChatBubble(playerid, "Приобрел MiniUZI", COLOR_GREEN, 100.0, 3000);
						ShowModelSelectionMenu(playerid, MenuBuyGun, "Buy Gun");
						SendClientMessage(playerid,COLOR_YELLOW,"Вы купили MicroUZI за 650$");
						QuestUpdate(playerid, 30, 650);//Обновление квеста Потратьте 25к в /bg
					}//UZI
					if(modelid == 355)
					{//AK
						if (Player[playerid][Cash] < 800){SendClientMessage(playerid,COLOR_RED,"Для покупки AK-47 вам нужно 800$");return 1;}
						Player[playerid][Cash] -= 800;GivePlayerWeapon(playerid,30,90);SetPlayerChatBubble(playerid, "Приобрел AK-47", COLOR_GREEN, 100.0, 3000);
						ShowModelSelectionMenu(playerid, MenuBuyGun, "Buy Gun");
						SendClientMessage(playerid,COLOR_YELLOW,"Вы купили AK-47 за 800$");
						QuestUpdate(playerid, 30, 800);//Обновление квеста Потратьте 25к в /bg
					}//AK
					if(modelid == 356)
					{//m4
					    if (Player[playerid][Cash] < 800){SendClientMessage(playerid,COLOR_RED,"Для покупки M4 вам нужно 800$");return 1;}
						Player[playerid][Cash] -= 800;GivePlayerWeapon(playerid,31,90);SetPlayerChatBubble(playerid, "Приобрел M4", COLOR_GREEN, 100.0, 3000);
						ShowModelSelectionMenu(playerid, MenuBuyGun, "Buy Gun");
						SendClientMessage(playerid,COLOR_YELLOW,"Вы купили M4 за 800$");
						QuestUpdate(playerid, 30, 800);//Обновление квеста Потратьте 25к в /bg
					}//m4
					if(modelid == 1310)
					{//Парашют
					    if (Player[playerid][Cash] < 200){SendClientMessage(playerid,COLOR_RED,"Для покупки Парашюта вам нужно 200$");return 1;}
						Player[playerid][Cash] -= 200;GivePlayerWeapon(playerid,46,1);SetPlayerChatBubble(playerid, "Приобрел парашют", COLOR_GREEN, 100.0, 3000);
						ShowModelSelectionMenu(playerid, MenuBuyGun, "Buy Gun");
						SendClientMessage(playerid,COLOR_YELLOW,"Вы купили Парашют за 200$");
						QuestUpdate(playerid, 30, 200);//Обновление квеста Потратьте 25к в /bg
					}//Парашют

				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER || GetPlayerState(playerid) == PLAYER_STATE_PASSENGER)
				{//делает возможным пользоваться только смг, находясь в транспорте
				    new Weap[2];
				    GetPlayerWeaponData(playerid, 4, Weap[0], Weap[1]); // Get the players SMG weapon in slot 4
				    SetPlayerArmedWeapon(playerid, Weap[0]); // Set the player to driveby with SMG
				}//делает возможным пользоваться только смг, находясь в транспорте
			}
		}//респонс
    }//оружейный магазин

    if(listid == MenuPrestigeCars)
    {//Престижные авто
        if(response)
		{
		    SelectedModel[playerid] = modelid;
		    ShowPlayerDialog(playerid, DIALOG_PRESTIGECAR, 2, "Выбор класса для данного авто", "Класс 1\nКласс 2\n{FFFF00}Сесть только сейчас", "ОК", "Отмена");
		}
		else ShowPlayerDialog(playerid, 3, 2, "Замена личного транспорта", "Класс 1\nКласс 2\nКласс 3\n{FFFF00}Prestige{FFFFFF}\nОтмена", "ОК", "");
    }//Престижные авто
    
    return 1;
}//меню



public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if (Logged[playerid] == 0 && dialogid != DIALOG_LOGIN && dialogid != DIALOG_REGISTER) return Kick(playerid);//До авторизации никакие диалоги не работают

	new string[MAX_DIALOG_INFO];
	switch(dialogid)
	{
	case DIALOG_LOGIN:
		{
		    for (new i; i < strlen(inputtext); i++)
			{
		   		if (inputtext[i] == '=')
		   		{//В пароле есть символ =
		   		    format(string, sizeof(string), "{FFFFFF}Добро пожаловать на {00BFFF}%s{FFFFFF}\nВаш аккаунт зарегестрирован\n\nЛогин: {008000}%s\n{FFFFFF}Введите пароль:", SERVER_NAME, GetName(playerid));
					return ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT, "{FFD700}Авторизация", string, "Войти", "Отмена");
		   		}//В пароле есть символ =
		   	}
			if(response)
			{
				if(strlen(inputtext) < 3)
				{
					format(string, sizeof(string), "{FFFFFF}Добро пожаловать на {00BFFF}%s{FFFFFF}\nВаш аккаунт зарегестрирован\n\nЛогин: {008000}%s\n{FFFFFF}Введите пароль:", SERVER_NAME, GetName(playerid));
					ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT, "{FFD700}Авторизация", string, "Войти", "Отмена");
					return 1;
				}
				
				else if(strcmp(PlayerPass[playerid], inputtext, true))
				{
					Errors[playerid]--;
					if(Errors[playerid] < 1)
					{
						SendClientMessage(playerid,0xFF8800FF,"-------------------------------------------------");
						SendClientMessage(playerid,0xFF8800FF,"Введён неверный пароль!");
						SendClientMessage(playerid,0xFF8800FF,"Соединение разорвано...");
						SendClientMessage(playerid,0xFF8800FF,"-------------------------------------------------");
						GKick(playerid);
						return 1;
					}
					format(string, sizeof(string), "{FFFFFF}Добро пожаловать на {00BFFF}%s{FFFFFF}\nВаш аккаунт зарегестрирован\n\nЛогин: {008000}%s\n{FFFFFF}Введите пароль:\n\n{FF0000}Введен неверный пароль! Осталось попыток: {FFFFFF}%i", SERVER_NAME, GetName(playerid), Errors[playerid]);
					ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT, "{FFD700}Авторизация", string, "Войти", "Отмена");
					return 1;
				}
				Logged[playerid] = 1;
				
				new name[24];GetPlayerName(playerid, name, sizeof(name));new ChatMes[140];
               	foreach(Player, gid)
				{//цикл
					if (Logged[gid] == 1 && Player[gid][Admin] > 0)
					{//если модер и выше
					    format(ChatMes, sizeof(ChatMes), "SERVER: %s[%d] вошел в игру [IP-Адрес:{FFFFFF} %s{AFAFAF}].", name,playerid, PlayerIP[playerid]);
					}//если модер и выше
					else{format(ChatMes, sizeof(ChatMes), "SERVER: %s[%d] вошел в игру.", name,playerid);}
					if (Player[gid][ConMesEnterExit] == 1) SendClientMessage(gid, COLOR_GREY, ChatMes);
				}//цикл
				//Запись в лог. Например WriteLog("Файл", "Привет Мир!"); запишет в лог "Файл.ini" фразу "Привет Мир!"
    			format(ChatMes, sizeof ChatMes, "%d.%d.%d в %d:%d:%d |   %s[%d] вошел в игру [IP-Адрес: %s].", Day, Month, Year, hour, minute, second, name, playerid, PlayerIP[playerid]);
				WriteLog("GlobalLog", ChatMes);


				SetPlayerVirtualWorld(playerid,0);LSpawnPlayer(playerid);
				TextDrawShowForPlayer(playerid, TextDrawTime), TextDrawShowForPlayer(playerid, TextDrawDate);//дата и время
				SetTimerEx("SpeedoUpdate" , 500, false, "i", playerid);
				OnPlayerLogin(playerid); LoginKickTime[playerid] = 0;
				if (Player[playerid][Level] == 0) TutorialStep[playerid] = 1;//включается обучение если 0 лвл
				return 1;
			}
			else{ShowPlayerDialog(playerid,999,0,"Соединение разорвано","{FF0000}Вы были кикнуты с сервера, за попытку обойти систему авторизации", "ОК", "");Kick(playerid);}
		}
	case DIALOG_REGISTER:
		{
			if(!response){ShowPlayerDialog(playerid,999,0,"Соединение разорвано","{FF0000}Вы были кикнуты с сервера, за попытку обойти систему авторизации", "ОК", "");Kick(playerid);}
			if(!strlen(inputtext) || strlen(inputtext) < 6 || strlen(inputtext) > 24)
			{
				format(string, sizeof(string), "{FFFFFF}Добро пожаловать на {00BFFF}%s{FFFFFF}\nДля игры вам нужно зарегистрироваться\n\nВведите пароль для вашего аккаунта\nОн будет запрашиваться при каждом заходе на сервер\n\n     {008000}Примечания:\n     - Пароль должен быть сложным (Пример: s9cQ17)\n     {FF0000}- Длина пароля должна быть от 6 до 24 символов\n     {FF0000}- Запрещено использовать '=' в пароле\n\n{FFFFFF}Введите пароль:", SERVER_NAME);
				ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "{FFD700}Регистрация", string, "Готово", "Отмена");return 1;
			}
			for (new i; i < strlen(inputtext); i++)
			{
	   			if (inputtext[i] == '=')
	   			{//В пароле есть символ =
	   			    format(string, sizeof(string), "{FFFFFF}Добро пожаловать на {00BFFF}%s{FFFFFF}\nДля игры вам нужно зарегистрироваться\n\nВведите пароль для вашего аккаунта\nОн будет запрашиваться при каждом заходе на сервер\n\n     {008000}Примечания:\n     - Пароль должен быть сложным (Пример: s9cQ17)\n     {FF0000}- Длина пароля должна быть от 6 до 24 символов\n     {FF0000}- Запрещено использовать '=' в пароле\n\n{FFFFFF}Введите пароль:", SERVER_NAME);
					ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "{FFD700}Регистрация", string, "Готово", "Отмена");return 1;
	   			}//В пароле есть символ =
	   		}
			new filename[MAX_FILE_NAME], file, StringZ[80];
			strmid(PlayerPass[playerid], inputtext, 0, strlen(inputtext), MAX_PASSWORD);
			format(filename, sizeof(filename), "accounts/%s.ini", GetName(playerid));
			file = ini_createFile(filename);
			if(file < 0) file = ini_openFile (filename);
			if(file >= 0)
			{
				ini_setString(file,"Password", PlayerPass[playerid]);
				format(StringZ, sizeof StringZ, "%d.%d.%d", Day, Month, Year);
				ini_setString(file,"RegisterDate", StringZ);
				ini_getString(file,"RegisterDate", RegisterDate[playerid]);
                format(StringZ, sizeof StringZ, "%s", PlayerIP[playerid]);
                ini_setString(file,"RegisterIP", StringZ);
                ini_getString(file,"RegisterIP", RegisterIP[playerid]);
                format(StringZ, sizeof StringZ, "%s, %s", GetPlayerCountryRegion(playerid), GetPlayerCountryName(playerid));
                ini_setString(file,"RegisterLocation", StringZ);
                ini_getString(file,"RegisterLocation", RegisterLocation[playerid]);
                format(StringZ, sizeof StringZ, "%s", GetPlayerISP(playerid));
                ini_setString(file,"RegisterISP", StringZ);
                ini_getString(file,"RegisterISP", RegisterISP[playerid]);
                format(StringZ, sizeof StringZ, "%s", GetPlayerHost(playerid));
                ini_setString(file,"RegisterHost", StringZ);
                ini_getString(file,"RegisterHost", RegisterHost[playerid]);
				ini_closeFile(file);
				new name[24];GetPlayerName(playerid, name, sizeof(name));new ChatMes[120];
				if (strlen(name) > 0)
				{//Если длина ника больше 0 (исправление бага фейковой регистрации пустых ников)
	               	foreach(Player, gid)
					{//цикл
						if (Logged[gid] == 1 && Player[gid][Admin] > 0)
						{//если модер и выше
						    format(ChatMes, sizeof(ChatMes), "SERVER: %s[%d] зарегистрировался [IP-Адрес:{FFFFFF} %s{AFAFAF}].", name,playerid, PlayerIP[playerid]);
						}//если модер и выше
						else{format(ChatMes, sizeof(ChatMes), "SERVER: %s[%d] зарегистрировался.", name,playerid);}
						SendClientMessage(gid, COLOR_GREY, ChatMes);

					}//цикл
					//Запись в лог. Например WriteLog("Файл", "Привет Мир!"); запишет в лог "Файл.ini" фразу "Привет Мир!"
					format(ChatMes, sizeof ChatMes, "%d.%d.%d в %d:%d:%d |   %s[%d] зарегистрировался [IP-Адрес: %s].", Day, Month, Year, hour, minute, second, name, playerid, PlayerIP[playerid]);WriteLog("GlobalLog", ChatMes);
				}//Если длина ника больше 0 (исправление бага фейковой регистрации пустых ников)
			}
			Registered[playerid] = 1;Logged[playerid] = 1;
			TutorialStep[playerid] = 1;LogidDialogShowed[playerid] =1;XReg[playerid] = 1;
			PlayerWeather[playerid] = -1; PlayerTime[playerid] = -1;//Серверные погода и время после регистрации
 			TextDrawShowForPlayer(playerid, TextDrawTime), TextDrawShowForPlayer(playerid, TextDrawDate);//дата и время
			new NoobSkins[] = {134,135,137, 212, 230, 239};
			new rand = random(sizeof NoobSkins); Player[playerid][Model] = NoobSkins[rand];
			Player[playerid][CarSlot1] = 462;//Faggio по-умолчанию
			Player[playerid][CarSlot1Color1] = random(200);
			Player[playerid][Cash] = 500;  LoginKickTime[playerid] = 0;
			TutorialStep[playerid] = 1;//Начало обучения
            new String[1024]; LSpawnPlayer(playerid); StopAudioStreamForPlayer(playerid);
			strcat(String, "{007FFF}Обучение: Вызов транспорта{FFFFFF}\n\n");
			strcat(String, "Каждому игроку на сервере с самого начала выдается свой личный автомобиль. Изначально это мопед.\n");
			strcat(String, "Для того, чтобы сесть на него, нажмите клавишу {00FF00}Alt{FFFFFF} и выберите <<{FFFF00}Сесть в машину [Класс 1]{FFFFFF}>>");
			return ShowPlayerDialog(playerid, DIALOG_TUTORIAL, 0, "Обучение", String, "ОК, сейчас", "");
		}

		///////////////

	case 2:
		{//Быстрый доступ
			if(response)
			{
				if(listitem == 0 && GetPlayerState(playerid) == 1)
				{//Slot 1
				    CallCar1(playerid);//вызов авто класса 1
				    if (Player[playerid][Level] == 0)
				    {//Проходит обучение
				        if (TutorialStep[playerid] == 1)
				        {//Обучение: Вызов мопеда
					        new String[1024];
					        TutorialStep[playerid] = 2;
							strcat(String, "{007FFF}Обучение: Выбор первого автомобиля{FFFFFF}\n\n");
							strcat(String, "Ваш мопед - транспорт первого класса, но у каждого игрока может быть сразу три автомобиля: \n");
							strcat(String, "по одному на каждый класс. Пришла пора выбрать ваш первый автомобиль второго класса!");
	 						strcat(String, "\n\n{FFFF00}Нажмите ОК и выберите автомобиль..");
							ShowPlayerDialog(playerid, DIALOG_TUTORIAL, 0, "Обучение", String, "ОК", "");
							DestroyObject(TutorialObject[playerid]);TutorialObject[playerid] = -1;
						}//Обучение: Вызов мопеда
						if (TutorialStep[playerid] == 3)
						{//Обучение: Трансформация
						    if (TutorialObject[playerid] != -1){DestroyObject(TutorialObject[playerid]);TutorialObject[playerid] = -1;}
						    TutorialObject[playerid] = CreateObject(19482, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
							SetObjectMaterialText(TutorialObject[playerid], "{FFFF00}Обучение\n{FFFFFF}Нажмите {00FF00}Y{FFFFFF}/{00FF00}N", 0, OBJECT_MATERIAL_SIZE_512x512, "Tahoma", 50, 1, 0xFFFFFFFF, 0x00, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
			                AttachObjectToPlayer(TutorialObject[playerid], playerid, 0, 0, 1.2, 0, 0, 270);
						}//Обучение: Трансформация
				    }//Проходит обучение
				}//Slot 1
				if(listitem == 1 && GetPlayerState(playerid) == 1)
				{//Slot 2
				    CallCar2(playerid);//вызов авто класса 2
				}//Slot 2
				if(listitem == 2 && GetPlayerState(playerid) == 1)
				{//Slot 3
				    CallCar3(playerid);//вызов авто класса 3
				}//Slot 3
				if(listitem == 3) SendCommand(playerid, "/jetpack", ""); //Jetpack
				if(listitem == 4) SendCommand(playerid, "/skydive", ""); //Парашют
				if(listitem == 5) SendCommand(playerid, "/gps", ""); //GPS
				if(listitem == 6)
				{//Изменить слоты
					ShowPlayerDialog(playerid, 3, 2, "Замена личного транспорта", "Класс 1\nКласс 2\nКласс 3\n{FFFF00}Prestige{FFFFFF}\nОтмена", "ОК", "");
				}//Изменить слоты
				if(listitem == 7)
				{//Изменить навыки
				    new StringF[600];
				    switch (Player[playerid][ActiveSkillPerson])
				    {//Навык персонажа
				        case 1: strcat(StringF,"Клавиша {008D00}N{FFFFFF} (Пешком): {007FFF}Телепорт на 50 метров\n");
				        case 2: strcat(StringF,"Клавиша {008D00}N{FFFFFF} (Пешком): {007FFF}Телепорт на 100 метров\n");
				        case 3: strcat(StringF,"Клавиша {008D00}N{FFFFFF} (Пешком): {007FFF}Телепорт на 200 метров\n");
				        case 4: strcat(StringF,"Клавиша {008D00}N{FFFFFF} (Пешком): {007FFF}Режим Супермена\n");
				        default: strcat(StringF,"Клавиша {008D00}N{FFFFFF} (Пешком): {AFAFAF}Нет\n");
				    }//Навык персонажа
				    
				    switch (Player[playerid][ActiveSkillCar1])
				    {//Класс 1: Клавиша 2
				        case 1: strcat(StringF,"Клавиша {008D00}2{FFFFFF} (Класс 1): {007FFF}Разворот на 180 градусов\n");
				        case 2: strcat(StringF,"Клавиша {008D00}2{FFFFFF} (Класс 1): {007FFF}Прыжок\n");
				        case 3: strcat(StringF,"Клавиша {008D00}2{FFFFFF} (Класс 1): {007FFF}Трамплин\n");
				        default: strcat(StringF,"Клавиша {008D00}2{FFFFFF} (Класс 1): {AFAFAF}Нет\n");
				    }//Класс 1: Клавиша 2
				    
				    switch (Player[playerid][ActiveSkillCar2])
				    {//Класс 2: Клавиша 2
				        case 1: strcat(StringF,"Клавиша {008D00}2{FFFFFF} (Класс 2): {007FFF}Разворот на 180 градусов\n");
				        case 2: strcat(StringF,"Клавиша {008D00}2{FFFFFF} (Класс 2): {007FFF}Прыжок\n");
				        case 3: strcat(StringF,"Клавиша {008D00}2{FFFFFF} (Класс 2): {007FFF}Трамплин\n");
				        default: strcat(StringF,"Клавиша {008D00}2{FFFFFF} (Класс 2): {AFAFAF}Нет\n");
				    }//Класс 2: Клавиша 2
				    
				    switch (Player[playerid][ActiveSkillHCar1])
				    {//Класс 1: Клавиша гудка
				        case 1: strcat(StringF,"Клавиша {008D00}H{FFFFFF} (Класс 1): {007FFF}Переворот транспорта на колеса\n");
				        case 2: strcat(StringF,"Клавиша {008D00}H{FFFFFF} (Класс 1): {007FFF}Телепорт на 50 метров\n");
				        case 3: strcat(StringF,"Клавиша {008D00}H{FFFFFF} (Класс 1): {007FFF}Телепорт на 100 метров\n");
				        case 4: strcat(StringF,"Клавиша {008D00}H{FFFFFF} (Класс 1): {007FFF}Телепорт на 200 метров\n");
				        case 5: strcat(StringF,"Клавиша {008D00}H{FFFFFF} (Класс 1): {007FFF}Телепорт на 50 метров со скоростью\n");
				        case 6: strcat(StringF,"Клавиша {008D00}H{FFFFFF} (Класс 1): {007FFF}Телепорт на 100 метров со скоростью\n");
				        case 7: strcat(StringF,"Клавиша {008D00}H{FFFFFF} (Класс 1): {007FFF}Телепорт на 200 метров со скоростью\n");
				        case 8: strcat(StringF,"Клавиша {008D00}H{FFFFFF} (Класс 1): {007FFF}Режим Полета\n");
				        default: strcat(StringF,"Клавиша {008D00}H{FFFFFF} (Класс 1): {AFAFAF}Нет\n");
				    }//Класс 1: Клавиша гудка
				    
				    switch (Player[playerid][ActiveSkillHCar2])
				    {//Класс 2: Клавиша гудка
				        case 1: strcat(StringF,"Клавиша {008D00}H{FFFFFF} (Класс 2): {007FFF}Переворот транспорта на колеса\n");
				        case 2: strcat(StringF,"Клавиша {008D00}H{FFFFFF} (Класс 2): {007FFF}Телепорт на 50 метров\n");
				        case 3: strcat(StringF,"Клавиша {008D00}H{FFFFFF} (Класс 2): {007FFF}Телепорт на 100 метров\n");
				        case 4: strcat(StringF,"Клавиша {008D00}H{FFFFFF} (Класс 2): {007FFF}Телепорт на 200 метров\n");
				        case 5: strcat(StringF,"Клавиша {008D00}H{FFFFFF} (Класс 2): {007FFF}Телепорт на 50 метров со скоростью\n");
				        case 6: strcat(StringF,"Клавиша {008D00}H{FFFFFF} (Класс 2): {007FFF}Телепорт на 100 метров со скоростью\n");
				        case 7: strcat(StringF,"Клавиша {008D00}H{FFFFFF} (Класс 2): {007FFF}Телепорт на 200 метров со скоростью\n");
				        case 8: strcat(StringF,"Клавиша {008D00}H{FFFFFF} (Класс 2): {007FFF}Режим Полета\n");
				        default: strcat(StringF,"Клавиша {008D00}H{FFFFFF} (Класс 2): {AFAFAF}Нет\n");
				    }//Класс 1: Клавиша гудка
				    strcat(StringF, "{FF0000}Пассивные навыки");
				    ShowPlayerDialog(playerid, DIALOG_SKILLCHANGE, 2, "Изменить мои навыки", StringF, "ОК", "Отмена");
				}//Изменить навыки
				if(listitem == 8)
				{//Настройки PvP
				    if (PlayerPVP[playerid][Status] > 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Нельзя изменять настройки во время дуэли.");
					if (PlayerPVP[playerid][TimeOut] > 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Нельзя изменять настройки когда Вы/Вас вызвали на дуэль.");
					new String[300], zWeapon[48], zMap[30];
					GetWeaponName(PlayerPVP[playerid][Weapon],zWeapon,sizeof(zWeapon));
				    if (PlayerPVP[playerid][Weapon] == 0) zWeapon = "Без оружия";
				    if (PlayerPVP[playerid][Map] == 1) zMap = "Арена";
					if (PlayerPVP[playerid][Map] == 2) zMap = "Под мостом";
					if (PlayerPVP[playerid][Map] == 3) zMap = "Над мостом";
					if (PlayerPVP[playerid][Map] == 4) zMap = "Молния";
					if (PlayerPVP[playerid][Map] == 5) zMap = "Окопы";
					if (PlayerPVP[playerid][Map] == 6) zMap = "Вертолетная площадка";
					if (PlayerPVP[playerid][Map] == 7) zMap = "Две крыши";
					if (PlayerPVP[playerid][Map] == 8) zMap = "Дамба";
					if (PlayerPVP[playerid][Map] == 9) zMap = "Грузовой корабль";
					if (PlayerPVP[playerid][Map] == 10) zMap = "Пирамида";
				    format(String,sizeof(String),"{457EFF}Случайные настройки\n{FFFF00}Карта:{FFFFFF} %s\n{FFFF00}Оружие:{FFFFFF} %s\n{FFFF00}Здоровье:{FFFFFF} %d",zMap,zWeapon, PlayerPVP[playerid][Health]);
					ShowPlayerDialog(playerid, DIALOG_PVP, 2, "Настройки PvP", String, "ОК", "Назад");
				}//Настройки PvP
				if(listitem == 9)
				{//Открыть кпк
					ShowPlayerDialog(playerid, 8, 2, "КПК", "Статистика (/stats)\nДоступные Соревнования (/events)\nДоступные Задания (/quests)\nОружейный Магазин (/buygun)\nЛичное Оружие (/mygun)\nСтиль Драки (/style)\nНастройки респавна (/myspawn)\nРадио (/radio)\nНевидимость (/invisible)\n{007FFF}Клан{FFFFFF}\n{FFCC00}GameGold Магазин\n{FF0000}Настройки аккаунта{FFFFFF}\nИнформация о карме (/karma)\nПомощь по игре (/help)", "ОК", "Назад");
				}//Открыть кпк
				
			}
		}//Быстрый доступ





	case 3:
		{//Замена транспорта
			if(response)
			{
				if(listitem == 0) ShowModelSelectionMenu(playerid, MenuClass1, "Car Class 1");
				if(listitem == 1) ShowModelSelectionMenu(playerid, MenuClass2, "Car Class 2");
				if(listitem == 2) ShowModelSelectionMenu(playerid, MenuClass3, "Car Class 3");
				if(listitem == 3)
				{//Prestige-list
				    if (Player[playerid][Prestige] == 0){SendClientMessage(playerid,COLOR_RED,"ОШИБКА: У вас должен быть как минимум 1-ый уровень Престижа");return 1;}
				    if (Player[playerid][Level] < 85){SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вы должны быть как минимум 85-го уровня");return 1;}
				    if (Player[playerid][CarActive] > 0){SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вы должны выйти из авто");return 1;}
				    ShowModelSelectionMenu(playerid, MenuPrestigeCars, "Prestige Cars");
				}//Prestige-list
				
			}
		}//замена транспорта



	case 8:
		{//КПК
			if(response)
			{
				if(listitem == 0) SendCommand(playerid, "/stats", ""); //Статистика
				if(listitem == 1) SendCommand(playerid, "/events", ""); //соревнования
				if(listitem == 2) SendCommand(playerid, "/quests", ""); //задания
				if(listitem == 3) SendCommand(playerid, "/buygun", ""); //оруж. магаз
				if(listitem == 4) SendCommand(playerid, "/mygun", ""); //личное оружие
				if(listitem == 5) SendCommand(playerid, "/style", ""); //стиль драки
				if(listitem == 6) SendCommand(playerid, "/myspawn", ""); //Настройки респавна
				if(listitem == 7) SendCommand(playerid, "/radio", ""); //радио
  				if(listitem == 8) SendCommand(playerid, "/invisible", ""); //невидимость
				if(listitem == 9) SendCommand(playerid, "/clan", ""); //клан
				if(listitem == 10) SendCommand(playerid, "/shop", ""); //магазин shop
				if(listitem == 11) SendCommand(playerid, "/config", ""); //конфиг
				if(listitem == 12) SendCommand(playerid, "/karma", ""); //инфа о карме
				if(listitem == 13) SendCommand(playerid, "/help", ""); //помощь
			}
			else{ShowPlayerDialog(playerid, 2, 2, "Меню быстрого доступа", "Сесть в машину [Класс 1]\nСесть в машину [Класс 2]\nСесть в машину [Класс 3]\nНадеть JetPack (/jetpack)\nПрыгнуть с парашютом (/skydive)\n{FF0000}GPS (/gps){FFFFFF}\nИзменить мои автомобили\nИзменить мои навыки\nНастройки PvP\n{FFFF00}Открыть КПК", "ОК", "Назад");}
			return 1;
		}//КПК



	case 9:
		{//Радио
			if(response)
			{
				if(listitem == 0){StopAudioStreamForPlayer(playerid);}
				if(listitem == 1){PlayAudioStreamForPlayer(playerid, "http://ep256server.streamr.ru:8014/europaplus256.mp3");}//Europa+
				if(listitem == 2){PlayAudioStreamForPlayer(playerid, "http://mxsel.maksmedia.ru:8000/maksfm128.m3u");}//MaksFM
				if(listitem == 3){PlayAudioStreamForPlayer(playerid, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=172098");}//SmoothJazz
				if(listitem == 4){PlayAudioStreamForPlayer(playerid, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=914897");}//IDOBI
				if(listitem == 5){PlayAudioStreamForPlayer(playerid, "http://radio02-cn03.akadostream.ru:8108/shanson128.mp3");}//Shanson
				if(listitem == 6){PlayAudioStreamForPlayer(playerid, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=7540");}//CINEMIX SoundTracks
				if(listitem == 7){PlayAudioStreamForPlayer(playerid, "http://yp.shoutcast.com/sbin/tunein-station.m3u?id=338128");}//Dubbase.FM
				if(listitem == 8){PlayAudioStreamForPlayer(playerid, "http://cmd.3dn.ru/sound/RadioRecord.m3u");}//Radio Record
				if(listitem == 9){PlayAudioStreamForPlayer(playerid, "http://radio.zaycev.fm:9002/ZaycevFM(128).m3u");}//Зайцев.fm Pop
				if(listitem == 10){PlayAudioStreamForPlayer(playerid, "http://radio.zaycev.fm:9002/alternative/ZaycevFM(128).m3u");}//Зайцев.fm NewRock
				if(listitem == 11){PlayAudioStreamForPlayer(playerid, "http://radio.zaycev.fm:9002/electronic/ZaycevFM(128).m3u");}//Зайцев.fm Club
				if(listitem == 12){PlayAudioStreamForPlayer(playerid, "http://radio.zaycev.fm:9002/disco/ZaycevFM(128).m3u");}//Зайцев.fm Disco
				if(listitem == 13){PlayAudioStreamForPlayer(playerid, "http://radio.zaycev.fm:9002/rnb/ZaycevFM(128).m3u");}//Зайцев.fm RnB
			}
			return 1;
		}//Радио



	case DIALOG_MYSPAWN:
		{//Место спавна
			if (response)
			{//респонс
				if (listitem == 0)
				{//Стандартное место спавна
					Player[playerid][Spawn] = 0;
					SendClientMessage(playerid,COLOR_YELLOW,"Место вашего респавна изменено на {FFFFFF}Стандартное место спавна");
				}//Стандартное место спавна
				if (listitem == 1)
				{//Личный дом (Снаружи)
					if (Player[playerid][Home] == 0){SendClientMessage(playerid,COLOR_RED,"ОШИБКА: У вас нет дома.");return 0;}
					Player[playerid][Spawn] = 4;
					SendClientMessage(playerid,COLOR_YELLOW,"Место вашего респавна изменено на {FFFFFF}Личный дом (Снаружи)");
				}//Личный дом (Снаружи)
				if (listitem == 2)
				{//Личный дом (Внутри)
				    if (Player[playerid][Home] == 0){SendClientMessage(playerid,COLOR_RED,"ОШИБКА: У вас нет дома.");return 0;}
					Player[playerid][Spawn] = 6; Player[playerid][SpawnStyle] = 0;
					SendClientMessage(playerid,COLOR_YELLOW,"Место вашего респавна изменено на {FFFFFF}Личный дом (Внутри)");
                    return 1;//Чтобы не было выбора стиля спавна
				}//Личный дом (Внутри)
				if (listitem == 3)
				{//Штаб клана (Снаружи)
				    if (Player[playerid][MyClan] == 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вы не в клане");
					new clanid = Player[playerid][MyClan];
					if(Clan[clanid][cBase] < 1 || Clan[clanid][cBase] > MAX_BASE) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: У вашего клана нет штаба");
    				Player[playerid][Spawn] = 5;
					SendClientMessage(playerid,COLOR_YELLOW,"Место вашего респавна изменено на {FFFFFF}Штаб клана (Снаружи)");
				}//Штаб клана (Снаружи)
				if (listitem == 4)
				{//Штаб клана (Внутри)
				    if (Player[playerid][MyClan] == 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вы не в клане");
					new clanid = Player[playerid][MyClan];
					if(Clan[clanid][cBase] < 1 || Clan[clanid][cBase] > MAX_BASE) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: У вашего клана нет штаба");
    				Player[playerid][Spawn] = 8; Player[playerid][SpawnStyle] = 0;
					return SendClientMessage(playerid,COLOR_YELLOW,"Место вашего респавна изменено на {FFFFFF}Штаб клана (Внутри)");
				}//Штаб клана (Внутри)
				if (listitem == 5)
				{//текущее местоположение (ViP 4 lvl)
				    if (Player[playerid][GPremium] < 4) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вы должны быть как минимум 4-го уровня ViP");
				    if (Player[playerid][Home] == 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: У вас должен быть личный дом");
					if (LSpecID[playerid] != -1) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны выйти из режима слежки");
					if (GetPlayerInterior(playerid) != 0 || IsPlayerInRangeOfPoint(playerid, 13.0, 2311.6953,-7.4206,26.7422)) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Нельзя установить VIP-спавн в помещениях");
				    GetPlayerPos(playerid,Player[playerid][PosX],Player[playerid][PosY],Player[playerid][PosZ]);GetPlayerFacingAngle(playerid,Player[playerid][PosA]);
				    Player[playerid][Spawn] = 7;SavePlayer(playerid);
				    SendClientMessage(playerid,COLOR_YELLOW,"Место вашего респавна изменено на {FFFFFF}Личная позиция (ViP)");
				}//текущее местоположение (ViP 4 lvl)
				
				new StringX[1024];
				strcat(StringX, "{FFFFFF}({FFFF00}Уровень 0{FFFFFF})Нет\n{FFFFFF}({FFFF00}Уровень 10{FFFFFF})Спавн на авто класса 1\n{FFFFFF}({FFFF00}Уровень 13{FFFFFF})Спавн на авто класса 2\n{FFFFFF}({FFFF00}Уровень 38{FFFFFF})Спавн на JetPack\n{FFFFFF}({FFFF00}Уровень 54{FFFFFF})Спавн на авто класса 3");
				ShowPlayerDialog(playerid, DIALOG_MYSPAWN2, 2, "Настройки респавна - Стиль", StringX, "ОК", "Назад");
			}//респонс
		}//Место спавна

	case DIALOG_MYSPAWN2:
		{//Стили спавна
			if(response)
			{//респонс
				if(listitem == 0)
				{//без стиля
					Player[playerid][SpawnStyle] = 0;
					SendClientMessage(playerid,COLOR_YELLOW,"Стиль вашего респавна: {FFFFFF}Обычный(без стиля)");
				}//без стиля
				if(listitem == 1)
				{//авто 1
					if (Player[playerid][Level] < 10){SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вы должны быть как минимум {FFFFFF}10{FF0000}-го уровня, чтобы выбрать этот стиль респавна");return 0;}
					Player[playerid][SpawnStyle] = 1;
					SendClientMessage(playerid,COLOR_YELLOW,"Стиль вашего респавна: {FFFFFF}На авто класса 1");
				}//авто 1
				if(listitem == 2)
				{//авто 2
					if (Player[playerid][Level] < 13){SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вы должны быть как минимум {FFFFFF}13{FF0000}-го уровня, чтобы выбрать этот стиль респавна");return 0;}
					Player[playerid][SpawnStyle] = 2;
					SendClientMessage(playerid,COLOR_YELLOW,"Стиль вашего респавна: {FFFFFF}На авто класса 2");
				}//авто 2
				if(listitem == 3)
				{//jetpack
				    if (Player[playerid][Level] < 38){SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вы должны быть как минимум {FFFFFF}38{FF0000}-го уровня, чтобы выбрать этот стиль респавна");return 0;}
					Player[playerid][SpawnStyle] = 5;
					SendClientMessage(playerid,COLOR_YELLOW,"Стиль вашего респавна: {FFFFFF}На JetPack");
				}//jetpack
				if(listitem == 4)
				{//авто 3
					if (Player[playerid][Level] < 54){SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вы должны быть как минимум {FFFFFF}54{FF0000}-го уровня, чтобы выбрать этот стиль респавна");return 0;}
					Player[playerid][SpawnStyle] = 4;
					SendClientMessage(playerid,COLOR_YELLOW,"Стиль вашего респавна: {FFFFFF}На авто класса 3");
				}//авто 3
			}//респонс
			else {SendCommand(playerid, "/myspawn", "");}//если нажал Еск
		}//Стили спавна

	case DIALOG_MYGUN:
		{//Личное оружие
			if(response)
			{//респонс
				if(listitem == 0)
				{//холодное оружие сл1
					if (Player[playerid][Level] < 8) return SendClientMessage(playerid,COLOR_RED,"Вы должны быть как минимум {FFFFFF}8{FF0000}-го уровня, чтобы покупать оружие из этой категории");
					ShowPlayerDialog(playerid, DIALOG_MYGUN1, 2, "Личное Оружие - Холодное Оружие", "Нет\n[{FFFF00}8{FFFFFF}]Бензопила\n[{FFFF00}27{FFFFFF}]Катана", "ОК", "Назад");
				}//холодное оружие сл1
				if(listitem == 1)
				{//пистолеты сл2
					if (Player[playerid][Level] < 16) return SendClientMessage(playerid,COLOR_RED,"Вы должны быть как минимум {FFFFFF}16{FF0000}-го уровня, чтобы покупать оружие из этой категории");
					ShowPlayerDialog(playerid, DIALOG_MYGUN2, 2, "Личное Оружие - Пистолеты", "Нет\n9мм пистолет\n9мм пистолет с глушителем\nDesert Eagle", "ОК", "Назад");
				}//пистолеты сл2
				if(listitem == 2)
				{//дробовики сл3
					if (Player[playerid][Level] < 17) return SendClientMessage(playerid,COLOR_RED,"Вы должны быть как минимум {FFFFFF}17{FF0000}-го уровня, чтобы покупать оружие из этой категории");
					ShowPlayerDialog(playerid, DIALOG_MYGUN3, 2, "Личное Оружие - Дробовики", "Нет\nДробовик\nОбрез\nSPAZ-12", "ОК", "Назад");
				}//дробовики сл3
				if(listitem == 3)
				{//пп сл4
					if (Player[playerid][Level] < 18) return SendClientMessage(playerid,COLOR_RED,"Вы должны быть как минимум {FFFFFF}18{FF0000}-го уровня, чтобы покупать оружие из этой категории");
					ShowPlayerDialog(playerid, DIALOG_MYGUN4, 2, "Личное Оружие - Пистолет-Пулеметы", "Нет\nMP5\nUZI\nTec-9", "ОК", "Назад");
				}//пп сл4
				if(listitem == 4)
				{//автоматы сл5
					if (Player[playerid][Level] < 19) return SendClientMessage(playerid,COLOR_RED,"Вы должны быть как минимум {FFFFFF}19{FF0000}-го уровня, чтобы покупать оружие из этой категории");
					ShowPlayerDialog(playerid, DIALOG_MYGUN5, 2, "Личное Оружие - Автоматы", "Нет\nАК-47\nМ4", "ОК", "Назад");
				}//автоматы сл5
				if(listitem == 5)
				{//метательное сл8
					if (Player[playerid][Level] < 23) return SendClientMessage(playerid,COLOR_RED,"Вы должны быть как минимум {FFFFFF}23{FF0000}-го уровня, чтобы покупать оружие из этой категории");
					ShowPlayerDialog(playerid, DIALOG_MYGUN8, 2, "Личное Оружие - Метательное", "Нет\nГранаты", "ОК", "Назад");
				}//метательное сл8
				if(listitem == 6)
				{//винтовки сл6
					if (Player[playerid][Level] < 34) return SendClientMessage(playerid,COLOR_RED,"Вы должны быть как минимум {FFFFFF}34{FF0000}-го уровня, чтобы покупать оружие из этой категории");
					ShowPlayerDialog(playerid, DIALOG_MYGUN6, 2, "Личное Оружие - Винтовки", "Нет\nДеревенское Ружье\nСнайперская Винтовка", "ОК", "Назад");
				}//винтовки сл6
				if(listitem == 7)
				{//тяжелое оружие сл7
					if (Player[playerid][Level] < 40) return SendClientMessage(playerid,COLOR_RED,"Вы должны быть как минимум {FFFFFF}40{FF0000}-го уровня, чтобы покупать оружие из этой категории");
					ShowPlayerDialog(playerid, DIALOG_MYGUN7, 2, "Личное Оружие - Тяжелое Оружие", "Нет\nRPG\n[{FFFF00}60{FFFFFF}]Миниган", "ОК", "Назад");
				}//тяжелое оружие сл7
				if(listitem == 8)
				{//прочее сл10
					if (Player[playerid][Level] < 4) return SendClientMessage(playerid,COLOR_RED,"Вы должны быть как минимум {FFFFFF}4{FF0000}-го уровня, чтобы покупать оружие из этой категории");
					ShowPlayerDialog(playerid, DIALOG_MYGUN10, 2, "Личное Оружие - Прочее", "Нет\nПарашют\nОгнетушитель", "ОК", "Назад");
				}//прочее сл10
			}//респонс
		}//Личное оружие

	case DIALOG_MYGUN1:
		{//ло - холодное
		    if(!response) return SendCommand(playerid, "/mygun", "");
			if(listitem == 0) {Player[playerid][Slot1] = 0; SendClientMessage(playerid, COLOR_YELLOW, "Изменения вступят в силу после респавна.");}
			if(listitem == 1) {Player[playerid][Slot1] = 9; SendClientMessage(playerid, COLOR_YELLOW, "Изменения вступят в силу после респавна.");}
			if(listitem == 2)
			{
				if (Player[playerid][Level] < 27) return SendClientMessage(playerid,COLOR_RED,"Ошибка: Вы должны быть как минимум {FFFFFF}27{FF0000}-го уровня, чтобы выбрать это оружие");
				Player[playerid][Slot1] = 8; SendClientMessage(playerid, COLOR_YELLOW, "Изменения вступят в силу после респавна.");
			}
			SendCommand(playerid, "/mygun", "");
		}//ло - холодное

	case DIALOG_MYGUN2:
		{//ло - пистолеты
		    if(!response) return SendCommand(playerid, "/mygun", "");
			if(listitem == 0) Player[playerid][Slot2] = 0;
			if(listitem == 1) Player[playerid][Slot2] = 22;
			if(listitem == 2) Player[playerid][Slot2] = 23;
			if(listitem == 3) Player[playerid][Slot2] = 24;
			SendClientMessage(playerid, COLOR_YELLOW, "Изменения вступят в силу после респавна.");
			SendCommand(playerid, "/mygun", "");
		}//ло - пистолеты

	case DIALOG_MYGUN3:
		{//ло - дробовики
		    if(!response) return SendCommand(playerid, "/mygun", "");
			if(listitem == 0) Player[playerid][Slot3] = 0;
			if(listitem == 1) Player[playerid][Slot3] = 25;
			if(listitem == 2) Player[playerid][Slot3] = 26;
			if(listitem == 3) Player[playerid][Slot3] = 27;
			SendClientMessage(playerid, COLOR_YELLOW, "Изменения вступят в силу после респавна.");
			SendCommand(playerid, "/mygun", "");
		}//ло - дробовики

	case DIALOG_MYGUN4:
		{//ло - пп
		    if(!response) return SendCommand(playerid, "/mygun", "");
			if(listitem == 0) Player[playerid][Slot4] = 0;
			if(listitem == 1) Player[playerid][Slot4] = 29;
			if(listitem == 2) Player[playerid][Slot4] = 28;
			if(listitem == 3) Player[playerid][Slot4] = 32;
			SendClientMessage(playerid, COLOR_YELLOW, "Изменения вступят в силу после респавна.");
			SendCommand(playerid, "/mygun", "");
		}//ло - пп

	case DIALOG_MYGUN5:
		{//ло - автоматы
		    if(!response) return SendCommand(playerid, "/mygun", "");
			if(listitem == 0) Player[playerid][Slot5] = 0;
			if(listitem == 1) Player[playerid][Slot5] = 30;
			if(listitem == 2) Player[playerid][Slot5] = 31;
			SendClientMessage(playerid, COLOR_YELLOW, "Изменения вступят в силу после респавна.");
			SendCommand(playerid, "/mygun", "");
		}//ло - автоматы

	case DIALOG_MYGUN8:
		{//ло - Метательное
            if(!response) return SendCommand(playerid, "/mygun", "");
			if(listitem == 0) Player[playerid][Slot8] = 0;
			if(listitem == 1) Player[playerid][Slot8] = 16;
			SendClientMessage(playerid, COLOR_YELLOW, "Изменения вступят в силу после респавна.");
			SendCommand(playerid, "/mygun", "");
		}//ло - Метательное

	case DIALOG_MYGUN6:
		{//ло - Винтовки
		    if(!response) return SendCommand(playerid, "/mygun", "");
			if(listitem == 0) Player[playerid][Slot6] = 0;
			if(listitem == 1) Player[playerid][Slot6] = 33;
			if(listitem == 2) Player[playerid][Slot6] = 34;
			SendClientMessage(playerid, COLOR_YELLOW, "Изменения вступят в силу после респавна.");
			SendCommand(playerid, "/mygun", "");
		}//ло - Винтовки

	case DIALOG_MYGUN7:
		{//ло - Тяжелое оружие
		    if(!response) return SendCommand(playerid, "/mygun", "");
			if(listitem == 0) {Player[playerid][Slot7] = 0; SendClientMessage(playerid, COLOR_YELLOW, "Изменения вступят в силу после респавна.");}
			if(listitem == 1) {Player[playerid][Slot7] = 35; SendClientMessage(playerid, COLOR_YELLOW, "Изменения вступят в силу после респавна.");}
			if(listitem == 2)
			{
				if (Player[playerid][Level] < 60) return SendClientMessage(playerid,COLOR_RED,"Ошибка: Вы должны быть как минимум {FFFFFF}60{FF0000}-го уровня, чтобы выбрать это оружие");
				Player[playerid][Slot7] = 38; SendClientMessage(playerid, COLOR_YELLOW, "Изменения вступят в силу после респавна.");
			}
			SendCommand(playerid, "/mygun", "");
		}//ло - Прочее

	case DIALOG_MYGUN10:
		{//ло - Прочее
		    if(!response) return SendCommand(playerid, "/mygun", "");
			if(listitem == 0) Player[playerid][Slot10] = 0;
			if(listitem == 1) Player[playerid][Slot10] = 46;
			if(listitem == 2) Player[playerid][Slot10] = 42;
			SendClientMessage(playerid, COLOR_YELLOW, "Изменения вступят в силу после респавна.");
			SendCommand(playerid, "/mygun", "");
		}//ло - Прочее

	case DIALOG_STYLE:
		{//стиль драки
			if(response)
			{//респонс
				if(listitem == 0)
				{//обычный
					Player[playerid][Slot9] = 0;SetPlayerFightingStyle (playerid, FIGHT_STYLE_NORMAL);
					SendClientMessage(playerid,COLOR_YELLOW,"Стиль драки изменен на {FFFFFF}Обычный");
				}//обычный
				if(listitem == 1)
				{//бокс
					Player[playerid][Slot9] = 1;SetPlayerFightingStyle (playerid, FIGHT_STYLE_BOXING);
					SendClientMessage(playerid,COLOR_YELLOW,"Стиль драки изменен на {FFFFFF}Boxing");
				}//бокс
				if(listitem == 2)
				{//кунгфу
					Player[playerid][Slot9] = 2;SetPlayerFightingStyle (playerid, FIGHT_STYLE_KUNGFU);
					SendClientMessage(playerid,COLOR_YELLOW,"Стиль драки изменен на {FFFFFF}KungFu");
				}//кунгфу
				if(listitem == 3)
				{//книхед
					Player[playerid][Slot9] = 3;SetPlayerFightingStyle (playerid, FIGHT_STYLE_KNEEHEAD);
					SendClientMessage(playerid,COLOR_YELLOW,"Стиль драки изменен на {FFFFFF}KneeHead");
				}//книхед
				if(listitem == 4)
				{//грабкик
					Player[playerid][Slot9] = 4;SetPlayerFightingStyle (playerid, FIGHT_STYLE_GRABKICK);
					SendClientMessage(playerid,COLOR_YELLOW,"Стиль драки изменен на {FFFFFF}GrabKick");
				}//грабкик
				if(listitem == 5)
				{//елбоу
					Player[playerid][Slot9] = 5;SetPlayerFightingStyle (playerid, FIGHT_STYLE_ELBOW);
					SendClientMessage(playerid,COLOR_YELLOW,"Стиль драки изменен на {FFFFFF}Elbow");
				}//елбоу
				if(listitem == 6)
				{//микс
					Player[playerid][Slot9] = -1;
					SendClientMessage(playerid,COLOR_YELLOW,"Стиль драки изменен на {FFFFFF}MixFight");
				}//микс
			}//респонс
		}//стиль драки

	case DIALOG_BANK:
		{//Банк
			if(response)
			{//респонс
				if(listitem == 0)
				{//На счет
				    if (!IsPlayerInRangeOfPoint(playerid, 5, 2316.6182, -7.2874, 26.7422)) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы не в банке");
					ShowPlayerDialog(playerid, DIALOG_BANKTO, 1, "Банк - Положить на счет", "{FFFFFF}Сколько денег вы хотите положить?", "ОК", "Назад");
				}//На счет
				if(listitem == 1)
				{//Со счета
				    if (!IsPlayerInRangeOfPoint(playerid, 5, 2316.6182, -7.2874, 26.7422)) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы не в банке");
					new String[120];format(String,sizeof(String),"{FFFFFF}У вас на счету {00FF00}%d{FFFFFF}$\nСколько вы хотите снять?",Player[playerid][Bank]);
					ShowPlayerDialog(playerid, DIALOG_BANKFROM, 1, "Банк - Снять со счета", String, "ОК", "Назад");
				}//Со счета
				if(listitem == 2)
				{//Как увеличить максимум денег в банке
				    new String[512];
				    strcat(String, "{FFFF00}Максимум денег в банке зависит от стоимости вашего личного дома:{FFFFFF}\n");
				    strcat(String, "   Нет дома - Максимум денег в банке: 50 000 000$\n");
				    strcat(String, "10 000 000$ - Максимум денег в банке: 100 000 000$\n");
				    strcat(String, "20 000 000$ - Максимум денег в банке: 150 000 000$\n");
				    strcat(String, "40 000 000$ - Максимум денег в банке: 250 000 000$\n");
				    strcat(String, "60 000 000$ - Максимум денег в банке: 400 000 000$\n");
				    strcat(String, "80 000 000$ - Максимум денег в банке: 999 999 999$\n");
					ShowPlayerDialog(playerid, 999, 0, "Как увеличить максимум денег в банке", String, "ОК", "");
				}//Как увеличить максимум денег в банке
			}//респонс
		}//Банк

	case DIALOG_BANKTO:
		{//Банк положить тут
			if(response)
			{//респонс
				new entered = strval(inputtext);
				if (entered < 0){SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Введенная сумма некорректна");return 1;}
				if (Player[playerid][Bank] >= MaxBank[playerid]) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Достигнут максимум денег в банке!");
				if (entered > Player[playerid][Cash]){entered = Player[playerid][Cash];}
				new BankFree = MaxBank[playerid] - Player[playerid][Bank];if (BankFree < entered){entered = BankFree;}
				Player[playerid][Bank] += entered;Player[playerid][Cash] -= entered;SavePlayer(playerid);
				new String[120];format(String,sizeof(String),"Вы успешно положили {FFFFFF}%d{00FF00}$",entered);
				SendClientMessage(playerid,COLOR_GREEN,String);
			}//респонс
			else
			{
			    //Высчитывание макс. денег
			    new houseid = Player[playerid][Home];
				if (houseid <= 0) MaxBank[playerid] = 50000000;//макс 50 млн пока у игрока нет дома
				else if (Property[houseid][pPrice] >= 80000000) MaxBank[playerid] = 999999999; //дом за 80кк - 999кк
				else if (Property[houseid][pPrice] >= 60000000) MaxBank[playerid] = 400000000; //дом за 60кк - 400кк
				else if (Property[houseid][pPrice] >= 40000000) MaxBank[playerid] = 250000000; //дом за 40кк - 250кк
				else if (Property[houseid][pPrice] >= 20000000) MaxBank[playerid] = 150000000; //дом за 20кк - 150кк
				else MaxBank[playerid] = 100000000; //дом за 10кк - 100кк
	            //Высчитывание макс. денег
				new String[120];
				format(String,sizeof(String),"{AFAFAF}Банк. На счете: {00FF00}%d{AFAFAF}. Максимум: {FFFFFF}%d{AFAFAF}.",Player[playerid][Bank],MaxBank[playerid]);
				ShowPlayerDialog(playerid, DIALOG_BANK, 2, String, "Положить деньги на счет\nСнять деньги со счета\n{AFAFAF}(?) Как увеличить максимум денег в банке", "ОК", "");
			}
		}//банк положить

	case DIALOG_BANKFROM:
		{//Банк cнять
			if(response)
			{//респонс
				new entered = strval(inputtext);
				if (entered < 0){SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Введенная сумма некорректна");return 1;}
				if (entered > Player[playerid][Bank]){entered = Player[playerid][Bank];}
				Player[playerid][Bank] -= entered;Player[playerid][Cash] += entered;SavePlayer(playerid);
				new String[120];format(String,sizeof(String),"Вы успешно сняли {FFFFFF}%d{00FF00}$",entered);
				SendClientMessage(playerid,COLOR_GREEN,String);
			}//респонс
			else
			{
			    //Высчитывание макс. денег
			    new houseid = Player[playerid][Home];
				if (houseid <= 0) MaxBank[playerid] = 50000000;//макс 50 млн пока у игрока нет дома
				else if (Property[houseid][pPrice] >= 80000000) MaxBank[playerid] = 999999999; //дом за 80кк - 999кк
				else if (Property[houseid][pPrice] >= 60000000) MaxBank[playerid] = 400000000; //дом за 60кк - 400кк
				else if (Property[houseid][pPrice] >= 40000000) MaxBank[playerid] = 250000000; //дом за 40кк - 250кк
				else if (Property[houseid][pPrice] >= 20000000) MaxBank[playerid] = 150000000; //дом за 20кк - 150кк
				else MaxBank[playerid] = 100000000; //дом за 10кк - 100кк
	            //Высчитывание макс. денег
				new String[120];
				format(String,sizeof(String),"{AFAFAF}Банк. На счете: {00FF00}%d{AFAFAF}. Максимум: {FFFFFF}%d{AFAFAF}.",Player[playerid][Bank],MaxBank[playerid]);
				ShowPlayerDialog(playerid, DIALOG_BANK, 2, String, "Положить деньги на счет\nСнять деньги со счета\n{AFAFAF}(?) Как увеличить максимум денег в банке", "ОК", "");
			}
		}//банк снять		
		
	case DIALOG_HOUSEMENU:
		{//Дом диалог
			if(response)
			{//респонс
			    if(listitem == 0) SendCommand(playerid, "/enterhouse", "");
				if(listitem == 1) SendCommand(playerid, "/houseinfo", "");
				if(listitem == 2) SendCommand(playerid, "/buyhouse", "");
				if(listitem == 3)
				{//продать дом
				    if (Player[playerid][Home] > 0 && Player[playerid][Home] == LastHouseVisited[playerid])
				    {
				        new String[180], myhome = Player[playerid][Home], Nalog = Property[myhome][pPrice] / 100 * 15;
				        format(String, sizeof String, "{FFFFFF}Вы уверены, что хотите продать дом?\n\nЦена дома для покупки: {008D00}%d$\n{FFFFFF}Цена дома для продажи: {E60020}%d$", Property[myhome][pPrice], Property[myhome][pPrice] - Nalog);
						return ShowPlayerDialog(playerid, DIALOG_SELLHOUSE, 0, "Продать дом", String, "{FF0000}ПРОДАТЬ", "Отмена");
				    }
				}//продать дом
				if(listitem == 4)
				{//увеличить цену
					if (Player[playerid][Home] == 0){SendClientMessage(playerid,COLOR_RED,"ОШИБКА: У вас нет дома.");return 1;}
					new myhome = Player[playerid][Home];
					if(strcmp(Property[myhome][pOwner], GetName(playerid), true)) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Это не ваш дом");
					ShowPlayerDialog(playerid, DIALOG_HOUSEMENUPRICE, 1, "Повысить цену", "{FFFF00}Интерьер дома меняется в зависимости от его стоимости:{FFFFFF}\n• Менее 20 000 000$\n• 20 000 000$\n• 40 000 000$\n• 60 000 000$\n• 80 000 000$\n• Неперекупаемый дом (/shop)\n\n{FFFF00}На сколько вы хотите повысить цену дома?", "ОК", "Назад");
				}//увеличить цену
				if(listitem == 5) SendCommand(playerid, "/openhouse", "");
				if(listitem == 6)
				{//сделать тут спавн (снаружи)
					if (Player[playerid][Home] == 0){SendClientMessage(playerid,COLOR_RED,"ОШИБКА: У вас нет дома.");return 1;}
					new myhome = Player[playerid][Home];
					if(strcmp(Property[myhome][pOwner], GetName(playerid), true)) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Это не ваш дом");
					Player[playerid][Spawn] = 4;
					SendClientMessage(playerid,COLOR_YELLOW,"Место вашего респавна изменено на {FFFFFF}Личный дом (Снаружи)");
				}//сделать тут спавн (снаружи)
				if(listitem == 7)
				{//сделать тут спавн (внутри)
					if (Player[playerid][Home] == 0){SendClientMessage(playerid,COLOR_RED,"ОШИБКА: У вас нет дома.");return 1;}
					new myhome = Player[playerid][Home];
					if(strcmp(Property[myhome][pOwner], GetName(playerid), true)) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Это не ваш дом");
					Player[playerid][Spawn] = 6;
					SendClientMessage(playerid,COLOR_YELLOW,"Место вашего респавна изменено на {FFFFFF}Личный дом (Внутри)");
				}//сделать тут спавн (внутри)
			}//респонс
		}//Дом диалог


	case DIALOG_HOUSEMENUPRICE:
		{//цена дома
			if(response)
			{//респонс
				new entered = strval(inputtext);
				if (entered <= 0){SendClientMessage(playerid,COLOR_RED,"Введенная сумма некорректна");return 1;}
				if (entered > Player[playerid][Cash]){entered = Player[playerid][Cash];}
				new myhome = Player[playerid][Home];
				new BankFree = 80000000 - Property[myhome][pPrice];if (BankFree < entered){entered = BankFree;}
				if (entered == 0) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Стоимость дома уже достигла максимума");
				Property[myhome][pPrice] += entered;Player[playerid][Cash] -= entered;SavePlayer(playerid); SaveProperty(myhome);
				new String[120];format(String,sizeof(String),"Новая цена дома: {FFFFFF}%d{00FF00}$",Property[myhome][pPrice]);
				SendClientMessage(playerid,COLOR_GREEN,String);
				if (Property[myhome][pBuyBlock] <= 0)
				{//Дом перекупаемый
					new text3d[MAX_3DTEXT];
					format(text3d, sizeof(text3d), "{00FF00}Дом ({FFFFFF}%d${00FF00})\n{007FFF}Владелец:{FFFFFF} %s\nНажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать", Property[myhome][pPrice], Property[myhome][pOwner]);
					UpdateDynamic3DTextLabelText(PropertyText3D[myhome], 0xFFFFFFFF, text3d);
				}//Дом перекупаемый
			}//респонс
			else{ShowPlayerDialog(playerid, DIALOG_HOUSEMENU, 2, "{00FF00}Дом", "{007FFF}Войти в дом{FFFFFF}\nИнформация о доме\nКупить дом\nПродать дом\nУвеличить цену дома\nОткрыть / Закрыть дом\nСделать местом респавна (Снаружи дома)\nСделать местом респавна (Внутри дома)", "ОК", "Отмена");}
		}//цена дома

	case DIALOG_CLANCREATE:
		{//вы хотите создать клан за 500к?
			if(response)
			{//Да
				if (Player[playerid][Cash] < 500000){SendClientMessage(playerid,COLOR_RED,"ОШИБКА: У вас нет {FFFFFF}500 000{FF0000}$");return 1;}
				new StringX[1024];
				strcat(StringX, "{AFAFAF}Цвет №0\n{FFFF99}Цвет №1\n{FFFF00}Цвет №2\n{FF99FF}Цвет №3\n{FF9999}Цвет №4\n{FFCC00}Цвет №5\n{FF66CC}Цвет №6\n{FF6600}Цвет №7\n{FF00FF}Цвет №8\n{CCFFFF}Цвет №9\n{00A0C1}Цвет №10\n");
				strcat(StringX, "{E5004F}Цвет №11\n{CCFF00}Цвет №12\n{CC66FF}Цвет №13\n{CC3366}Цвет №14\n{CC6600}Цвет №15\n{9999FF}Цвет №16\n{9925FF}Цвет №17\n{99CCCC}Цвет №18\n{99FF66}Цвет №19\n{99FF00}Цвет №20\n");
				strcat(StringX, "{993300}Цвет №21\n{990066}Цвет №22\n{66FFFF}Цвет №23\n{6666FF}Цвет №24\n{EB6100}Цвет №25\n{666633}Цвет №26\n{33FFFF}Цвет №27\n{3399FF}Цвет №28\n{33CC99}Цвет №29\n{33FF66}Цвет №30\n");
				strcat(StringX, "{339900}Цвет №31\n{457EFF}Цвет №32\n{FFCC00}Цвет №33\n{976D3D}Цвет №34\n{FF8800}Цвет №35\n{FF6666}Цвет №36\n{0015FF}Цвет №37\n{DDAA00}Цвет №38\n{FFFFFF}Цвет №39\n{FF8000}Цвет №40");
				ShowPlayerDialog(playerid, DIALOG_CLANCREATECOLOR, 2, "Выберите цвет клана", StringX, "Выбрать", "Отмена");
			}//Да
		}//вы хотите создать клан за 500к?

	case DIALOG_CLANCREATECOLOR:
		{//выбор цвета
			if(response)
			{//Да
				CreateClanColor[playerid] = listitem;
				ShowPlayerDialog(playerid, DIALOG_CLANCREATENAME, 1, "Введите название клана", "{FFFFFF}Введите название клана.\n{008E00}[Длина от 2 до 20 символов]", "Создать", "Отмена");
			}//Да
		}//выбор цвета

	case DIALOG_CLANCREATENAME:
		{//ввод названия клана
			if(response)
			{//респонс
				if(!strlen(inputtext) || strlen(inputtext) < 2 || strlen(inputtext) > 20) return ShowPlayerDialog(playerid, DIALOG_CLANCREATENAME, 1, "Введите название клана", "{FF0000}ОШИБКА: Неверная длина названия..\n\n{FFFFFF}Введите название клана.\n{008E00}[Длина от 2 до 20 символов]", "Создать", "Отмена"); //если длина некорректна
				
				new AllowName = 1;
			    for (new i; i < strlen(inputtext); i++)
				{//Проверка каждого символа в нике на допустимость
				    if (inputtext[i] >= '0' && inputtext[i] <= '9') continue;
				    if (inputtext[i] >= 'A' && inputtext[i] <= 'Z') continue;
				    if (inputtext[i] >= 'a' && inputtext[i] <= 'z') continue;
                    if (inputtext[i] == '_') continue;
				    AllowName = 0;
				}//Проверка каждого символа в нике на допустимость
				if (!AllowName)  return ShowPlayerDialog(playerid, DIALOG_CLANCREATENAME, 1, "Введите название клана", "{FF0000}ОШИБКА: В названии допускаются только латинские буквы, цифры и символ '_'.\n\n{FFFFFF}Введите название клана.\n{008E00}[Длина от 2 до 20 символов]", "Создать", "Отмена");
				
				for(new i = 1; i < MAX_CLAN; i++)
				{//все возможные id`ы кланов
					if (Clan[i][cLevel] == 0) continue; //Пропускаем несуществующие кланы
                    if(!strcmp(Clan[i][cName], inputtext, true)) return ShowPlayerDialog(playerid, DIALOG_CLANCREATENAME, 1, "Введите название клана", "{FF0000}ОШИБКА: Клан с таким именем уже существует.\n\n{FFFFFF}Введите название клана.\n{008E00}[Длина от 2 до 20 символов]", "Создать", "Отмена");
				}//все возможные id`ы кланов
				if (Player[playerid][Cash] < 500000) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: У вас нет {FFFFFF}500 000{FF0000}$");
				Player[playerid][Cash] -= 500000;

				new clanid = 0, file, filename[MAX_FILE_NAME];
				for(new i = 1; i < MAX_CLAN; i++)
				{//--- Находим минимальный незанятый ID для клана
				    if (Clan[i][cLevel] > 0) continue;
				    clanid = i; if (clanid > MaxClanID) MaxClanID = clanid;
					break;
				}//--- Находим минимальный незанятый ID для клана
				if (clanid == 0) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: На сервере достигнут лимит кланов. Попробуйте создать клан позднее.");
				format(filename, sizeof(filename), "Clans/%d.ini", clanid);
				//---создаем файл клана
				file = ini_createFile(filename);
				ini_setInteger(file, "Level", 1);
				ini_closeFile(file);
				//---создаем файл клана
				
				//ResetClan
				Clan[clanid][cLevel] = 1;
				strmid(Clan[clanid][cLider], PlayerName[playerid], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
				strmid(Clan[clanid][cName], inputtext, 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
				Clan[clanid][cColor] = CreateClanColor[playerid];
				Clan[clanid][cBase] = 0;
				Clan[clanid][cXP] = 0;
				Clan[clanid][cLastDay] = DateToIntDate(Day, Month, Year) + 7;//Удаление клана через неделю
				Clan[clanid][cCWwin] = 0;
				Clan[clanid][cEnemyClan] = 0;
				strmid(Clan[clanid][cMessage], "ПУСТО", 0, strlen("ПУСТО"), 25);
				strmid(Clan[clanid][cMember1], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);
				strmid(Clan[clanid][cMember2], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);
				strmid(Clan[clanid][cMember3], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);
				strmid(Clan[clanid][cMember4], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);
				strmid(Clan[clanid][cMember5], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);
				strmid(Clan[clanid][cMember6], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);
				strmid(Clan[clanid][cMember7], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);
				strmid(Clan[clanid][cMember8], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);
				strmid(Clan[clanid][cMember9], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);
				strmid(Clan[clanid][cMember10], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);
				strmid(Clan[clanid][cMember11], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);
				strmid(Clan[clanid][cMember12], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);
				strmid(Clan[clanid][cMember13], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);
				strmid(Clan[clanid][cMember14], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);
				strmid(Clan[clanid][cMember15], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);
				strmid(Clan[clanid][cMember16], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);
				strmid(Clan[clanid][cMember17], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);
				strmid(Clan[clanid][cMember18], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);
				strmid(Clan[clanid][cMember19], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);
				strmid(Clan[clanid][cMember20], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);
				
				PlayerColor[playerid] = CreateClanColor[playerid];
				Player[playerid][MyClan] = clanid; Player[playerid][Leader] = 100; Player[playerid][Member] = -1;
				SaveClan(clanid); SavePlayer(playerid);
				new ChatMes[120];
				format(ChatMes, sizeof(ChatMes), "{008E00}Вы успешно создали клан '{FFFFFF}%s{008E00}'", inputtext);
				SendClientMessage(playerid,COLOR_GREEN, ChatMes);
			}//респонс
		}//ввод названия клана


	case DIALOG_CLANMENU:
		{//меню клана
			if(response)
			{//респорс
				if(listitem == 0)
				{//информация о клане
				    new clanid = Player[playerid][MyClan];
				    if (clanid == 0) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы не в клане!");
					else return ShowClanStats(playerid, clanid);
				}//информация о клане
				if(listitem == 1)
				{//Управление кланом
					if (Player[playerid][Leader] < 2){SendClientMessage(playerid, COLOR_RED, "ОШИБКА: У вас недостаточно прав.");return 1;}
					if (Player[playerid][Leader] == 2){ShowPlayerDialog(playerid, DIALOG_CLANMANAGER, 2, "Управление кланом", "Удалить игрока из клана", "Ок", "Отмена");}
					if (Player[playerid][Leader] >= 100) ShowPlayerDialog(playerid, DIALOG_CLANMANAGER, 2, "Управление кланом", "{FFFFFF}Удалить игрока из клана\nИзменить цвет клана\nИзменить сообщение клана при входе в игру\nПереименовать клан\n{AFAFAF}Объявить об окончании войны\n{FF0000}[Распустить клан]\n/---{008E00} Назначение прав {FFFFFF}---/\nОбычный член клана\nМожет принимать игроков\nМожет принимать и исключать игроков", "Ок", "Отмена");
				}//Управление кланом
				if(listitem == 2)
				{//Отношения с другими кланами
				    new String[1024], String2[140], clanid = Player[playerid][MyClan], enemies = 0; if (clanid == 0) return 1;
				    if (Clan[clanid][cEnemyClan] > 0)
				    {//клан объявил кому-то войну
				        new enemyclan = Clan[clanid][cEnemyClan];
				        format(String, sizeof String, "{FFFFFF}Ваш клан объявил войну клану {FF0000}%s[ID:%d]\n\n", Clan[enemyclan][cName], enemyclan);
				    }//клан объявил кому-то войну
				    else format(String, sizeof String, "{008E00}Ваш клан никому не объявлял войну.\n\n");
				    
				    strcat(String, "{FFFFFF}Следующие кланы объявили войну вашему:\n{FF0000}");
				    for(new i = 1; i <= MaxClanID; i++)
				    {//цикл
				        if (Clan[i][cEnemyClan] == clanid)
				        {//клан i объявлял войну клану игрока
				            format(String2, sizeof String2, "%s[ID:%d]\n", Clan[i][cName], i);
							strcat(String, String2); enemies++;
				        }//клан i объявлял войну клану игрока
				    }//цикл
				    if (enemies == 0) strcat(String, "{008E00}Вашему клану никто не объявлял войну.\n");
				    strcat(String, "\n{FFFF00}Используйте {FFFFFF}/claninfo [ID клана] {FFFF00}чтобы посмотреть информацию о нужном клане.");
				    ShowPlayerDialog(playerid, 999, 0, "Отношения с кланами", String, "ОК", "");
				}//Отношения с другими кланами
				if(listitem == 3)
				{//Покинуть клан
					if (Player[playerid][Leader] == 100){SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Лидер не может покинуть клан! Используйте 'Управление кланом' чтобы распустите клан."); return 1;}
					new StringX[120], clanid = Player[playerid][MyClan];
					format(StringX,sizeof(StringX),"{008E00}Вы уверены, что хотите выйти из клана '{FFFFFF}%s{008E00}'",Clan[clanid][cName]);
					ShowPlayerDialog(playerid, DIALOG_CLANEXIT, 0, "Выйти из клана", StringX, "Да", "Отмена");
				}//Покинуть клан
			}//респонс
		}//меню клана

	case DIALOG_CLANEXIT:
		{//выйти из клана
			if(response)
			{//респорс
				new StringX[120], clanid = Player[playerid][MyClan];
				format(StringX,sizeof(StringX),"Игрок %s[%d] покинул клан.",PlayerName[playerid],playerid);
				foreach(Player, cid)
				{//цикл
     				if (Player[cid][Member] != 0 && Player[cid][MyClan] == Player[playerid][MyClan] && Logged[cid] == 1) SendClientMessage(cid,COLOR_GREEN,StringX);
				}//цикл
				if(!strcmp(Clan[clanid][cMember1], PlayerName[playerid], true)) strmid(Clan[clanid][cMember1], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);
				if(!strcmp(Clan[clanid][cMember2], PlayerName[playerid], true)) strmid(Clan[clanid][cMember2], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);
				if(!strcmp(Clan[clanid][cMember3], PlayerName[playerid], true)) strmid(Clan[clanid][cMember3], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);
				if(!strcmp(Clan[clanid][cMember4], PlayerName[playerid], true)) strmid(Clan[clanid][cMember4], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);
				if(!strcmp(Clan[clanid][cMember5], PlayerName[playerid], true)) strmid(Clan[clanid][cMember5], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);
				if(!strcmp(Clan[clanid][cMember6], PlayerName[playerid], true)) strmid(Clan[clanid][cMember6], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);
				if(!strcmp(Clan[clanid][cMember7], PlayerName[playerid], true)) strmid(Clan[clanid][cMember7], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);
				if(!strcmp(Clan[clanid][cMember8], PlayerName[playerid], true)) strmid(Clan[clanid][cMember8], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);
				if(!strcmp(Clan[clanid][cMember9], PlayerName[playerid], true)) strmid(Clan[clanid][cMember9], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);
				if(!strcmp(Clan[clanid][cMember10], PlayerName[playerid], true)) strmid(Clan[clanid][cMember10], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);
				if(!strcmp(Clan[clanid][cMember11], PlayerName[playerid], true)) strmid(Clan[clanid][cMember11], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);
				if(!strcmp(Clan[clanid][cMember12], PlayerName[playerid], true)) strmid(Clan[clanid][cMember12], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);
				if(!strcmp(Clan[clanid][cMember13], PlayerName[playerid], true)) strmid(Clan[clanid][cMember13], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);
				if(!strcmp(Clan[clanid][cMember14], PlayerName[playerid], true)) strmid(Clan[clanid][cMember14], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);
				if(!strcmp(Clan[clanid][cMember15], PlayerName[playerid], true)) strmid(Clan[clanid][cMember15], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);
				if(!strcmp(Clan[clanid][cMember16], PlayerName[playerid], true)) strmid(Clan[clanid][cMember16], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);
				if(!strcmp(Clan[clanid][cMember17], PlayerName[playerid], true)) strmid(Clan[clanid][cMember17], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);
				if(!strcmp(Clan[clanid][cMember18], PlayerName[playerid], true)) strmid(Clan[clanid][cMember18], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);
				if(!strcmp(Clan[clanid][cMember19], PlayerName[playerid], true)) strmid(Clan[clanid][cMember19], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);
				if(!strcmp(Clan[clanid][cMember20], PlayerName[playerid], true)) strmid(Clan[clanid][cMember20], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);
				Player[playerid][Member] = 0; Player[playerid][Leader] = 0; Player[playerid][MyClan] = 0;
				PlayerColor[playerid] = 0; SavePlayer(playerid); SaveClan(clanid);
			}//респонс
		}//выйти из клана

	case DIALOG_TABMENU:
		{//меню игрока таб
			if(response)
			{//респорс
				if (listitem == 0)
				{//статистика игрока
					ShowStats(playerid,ClickedPid[playerid]);
				}//статистика игрока
				if (listitem == 1)
				{//статистика клана игрока
				    new clicked = ClickedPid[playerid], clanid = Player[clicked][MyClan];
					if (clanid == 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Этот игрок не в клане.");
					else return ShowClanStats(playerid, clanid);
				}//статистика клана игрока
				if (listitem == 2) return SendClientMessage(playerid, COLOR_RED, "Для отправки личного сообщения используй /pm [id игрока] [Сообщение]");//отправить PM
				if (listitem == 3)
				{//дать денег
					ShowPlayerDialog(playerid, DIALOG_TABGIVECASH, 1, "Передать деньги", "Введите сумму денег, которую хотите передать.", "Ок", "Отмена");
				}//дать денег
				if (listitem == 4)
				{//вызвать на дуэль (PVP)
				    new clicked = ClickedPid[playerid];
				    if (JoinEvent[playerid] > 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вы должны выйти из соревнований прежде, чем вызывать кого-то на дуэль.");
					if (PrestigeGM[playerid] == 1) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вы должны выйти из режима Бога прежде, чем вызывать кого-то на дуэль");
					if (PrestigeGM[clicked] == 1) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Нельзя вызвать этого игрока на дуэль, так как он находится в режиме Бога.");
					if (Player[playerid][Banned] > 0 || Player[clicked][Banned] > 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Забаненные игроки не могут участвовать в PvP.");
					if (Logged[clicked] == 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Этот игрок не авторизировался.");
				    if (Player[clicked][ConInvitePVP] == 0) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Этот игрок запретил вызывать его на PvP.");
				    if (InEvent[clicked] > 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Этот игрок участвует в соревнованиях.");
				    if (LAFK[clicked] > 3) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Этот игрок сейчас AFK.");
				    if (LSpecID[clicked] > -1) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Этот игрок находится в режиме слежки.");
				    if (Player[clicked][Level] == 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Этот игрок сейчас проходит обучение...");
				    if (PlayerPVP[clicked][TimeOut] > 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Этого игрока кто-то только что вызывал на дуэль. Пожалуйста, попробуйте позднее..");
				    PlayerPVP[playerid][Invite] = clicked;PlayerPVP[clicked][Invite] = playerid;PlayerPVP[playerid][TimeOut] = 20; PlayerPVP[clicked][TimeOut] = 20;
                    CanStartPVP[playerid] = 0;CanStartPVP[clicked] = 1;
					PlayerPVP[playerid][PlayMap] = PlayerPVP[playerid][Map];PlayerPVP[playerid][PlayWeapon] = PlayerPVP[playerid][Weapon];PlayerPVP[playerid][PlayHealth] = PlayerPVP[playerid][Health];
                    PlayerPVP[clicked][PlayMap] = PlayerPVP[playerid][Map];PlayerPVP[clicked][PlayWeapon] = PlayerPVP[playerid][Weapon];PlayerPVP[clicked][PlayHealth] = PlayerPVP[playerid][Health];
					PlayerPVP[playerid][Status] = 1; JoinEvent[playerid] = EVENT_PVP; PlayerPVP[clicked][Status] = 0;
					new String[300], zWeapon[48], zMap[30];	GetWeaponName(PlayerPVP[playerid][Weapon],zWeapon,sizeof(zWeapon));
				    if (PlayerPVP[playerid][PlayWeapon] == 0) zWeapon = "Без оружия";
				    if (PlayerPVP[playerid][PlayMap] == 1) zMap = "Арена";
					if (PlayerPVP[playerid][PlayMap] == 2) zMap = "Под мостом";
					if (PlayerPVP[playerid][PlayMap] == 3) zMap = "Над мостом";
					if (PlayerPVP[playerid][PlayMap] == 4) zMap = "Молния";
					if (PlayerPVP[playerid][PlayMap] == 5) zMap = "Окопы";
					if (PlayerPVP[playerid][PlayMap] == 6) zMap = "Вертолетная площадка";
					if (PlayerPVP[playerid][PlayMap] == 7) zMap = "Две крыши";
					if (PlayerPVP[playerid][PlayMap] == 8) zMap = "Дамба";
					if (PlayerPVP[playerid][PlayMap] == 9) zMap = "Грузовой корабль";
					if (PlayerPVP[playerid][PlayMap] == 10) zMap = "Пирамида";
				    format(String,sizeof(String),"{FF9E27}PVP: {AFAFAF}Вы вызвали игрока %s на дуэль. У него есть 20 секунд на принятие решения.", PlayerName[clicked]);SendClientMessage(playerid,COLOR_RED,String);
				    format(String,sizeof(String),"{FF9E27}PVP: {AFAFAF}Игрок %s вызывает вас на дуэль. Используйте {FF9E27}/pvp{AFAFAF} чтобы принять вызов.", PlayerName[playerid]);SendClientMessage(clicked,COLOR_RED,String);
				    format(String,sizeof(String),"{AFAFAF}Оружие: %s   Карта: %s   Здоровье: %d", zWeapon, zMap, PlayerPVP[playerid][PlayHealth]);
				    SendClientMessage(playerid,COLOR_RED,String);SendClientMessage(clicked,COLOR_RED,String);
				}//вызвать на дуэль (PVP)
				if (listitem == 5)
				{//пригласить в клан
				    new clickedplayerid = ClickedPid[playerid];
				    if (Player[playerid][Member] == 0) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: У вас нет клана! Используйте команду {FFFFFF}/clan {FF0000}чтобы создать его.");
				    if (Player[playerid][Leader] == 0) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: У вас нет права на принятие игроков в клан.");
					if (Player[clickedplayerid][MyClan] != 0) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Этот игрок уже состоит в чьем-то клане.");
	 				if (Player[clickedplayerid][Level] < 5 && Player[clickedplayerid][Prestige] == 0) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Нельзя приглашать в клан игроков ниже 5 уровня.");
					new clicked = ClickedPid[playerid];
					if (Player[clicked][MyClan] == 0)
					{//игрок, на которого кликнули - не в клане
					    new Free = 0, clanid = Player[playerid][MyClan], StringF[140];
						if(!strcmp(Clan[clanid][cMember1], "Пусто", true)) Free++;
						if(!strcmp(Clan[clanid][cMember2], "Пусто", true)) Free++;
						if(!strcmp(Clan[clanid][cMember3], "Пусто", true)) Free++;
						if(!strcmp(Clan[clanid][cMember4], "Пусто", true)) Free++;
						if(!strcmp(Clan[clanid][cMember5], "Пусто", true)) Free++;
						if(!strcmp(Clan[clanid][cMember6], "Пусто", true)) Free++;
						if(!strcmp(Clan[clanid][cMember7], "Пусто", true)) Free++;
						if(!strcmp(Clan[clanid][cMember8], "Пусто", true)) Free++;
						if(!strcmp(Clan[clanid][cMember9], "Пусто", true)) Free++;
						if(!strcmp(Clan[clanid][cMember10], "Пусто", true)) Free++;
						if(!strcmp(Clan[clanid][cMember11], "Пусто", true)) Free++;
						if(!strcmp(Clan[clanid][cMember12], "Пусто", true)) Free++;
						if(!strcmp(Clan[clanid][cMember13], "Пусто", true)) Free++;
						if(!strcmp(Clan[clanid][cMember14], "Пусто", true)) Free++;
						if(!strcmp(Clan[clanid][cMember15], "Пусто", true)) Free++;
						if(!strcmp(Clan[clanid][cMember16], "Пусто", true)) Free++;
						if(!strcmp(Clan[clanid][cMember17], "Пусто", true)) Free++;
						if(!strcmp(Clan[clanid][cMember18], "Пусто", true)) Free++;
						if(!strcmp(Clan[clanid][cMember19], "Пусто", true)) Free++;
						if(!strcmp(Clan[clanid][cMember20], "Пусто", true)) Free++;
						
						if (Free == 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: В клане нет места.");
						if (Logged[clicked] == 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Нельзя пригласить этого игрока в клан, так как он не авторизовался.");
						if (Player[clicked][ConInviteClan] == 0) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Этот игрок запретил приглашать его в клан.");
						if (LAFK[clicked] > 4) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Нельзя пригласить этого игрока в клан, так как он AFK.");
						if (InEvent[clicked] > 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Нельзя пригласить этого игрока в клан, так как он сейчас участвует в соревновании.");
 						InviteClan[clicked] = Player[playerid][MyClan];
						SendClientMessage(playerid,COLOR_CLAN,"Приглашение отправлено. Внимание! У игрока 10 секунд на принятие приглашения!");
						format(StringF,sizeof(StringF),"{008E00}Внимание! Игрок {FFFFFF}%s{008E00} приглашает вас в клан '{FFFFFF}%s{008E00}'\nХотите вступить?",PlayerName[playerid],Clan[clanid][cName]);
						ShowPlayerDialog(clicked,DIALOG_CLANENTER,0,"Приглашение в клан",StringF,"Да","Нет");InviteTime[clicked] = 10;
					}//игрок, на которого кликнули - не в клане
				}//пригласить в клан
				if (listitem == 6)
				{//Объявить войну клану игрока
				    new targetid = ClickedPid[playerid], clanid = Player[playerid][MyClan], targetclanid = Player[targetid][MyClan];
				    if (clanid <= 0 || Player[playerid][Leader] < 100) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть лидером клана чтобы объявлять войну!");
					if (Clan[clanid][cLevel] < 2) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Чтобы объявлять войну ваш клан должен быть как минимум 2-го уровня!");
				    if (targetclanid <= 0) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Этот игрок не в клане!");
					if (targetclanid == clanid) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Нельзя объявить войну своему клану!");
				    if (Clan[clanid][cEnemyClan] > 0) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Объявлять войну можно только одному клану! Заключите перемирие с предыдущим, прежде чем воевать со следующим!");
                    new String[140], String2[140];
					if (Player[playerid][ClanWarTime] > 0)
				    {
				        format(String,sizeof(String),"ОШИБКА: Вы сможете объявить войну не раньше, чем через %d минут",Player[playerid][ClanWarTime] / 60 + 1);
				        return SendClientMessage(playerid,COLOR_RED,String);
				    }
					//объявляем войну
					Clan[clanid][cEnemyClan] = targetclanid; SaveClan(clanid);
					format(String, sizeof String, "{008E00}SERVER: Клан {FFFFFF}%s{008E00}[ID:%d] объявил войну клану {FFFFFF}%s{008E00}[ID:%d].", Clan[clanid][cName], clanid, Clan[targetclanid][cName], targetclanid);
					SendClientMessageToAll(-1, String); Player[playerid][ClanWarTime] = 3600;
					format(String, sizeof String, "Клан %s[ID:%d] объявил войну вашему клану! Вы можете убивать друг друга без потери очков кармы!", Clan[clanid][cName], clanid);
                    format(String2, sizeof String2, "Ваш клан объявил войну клану %s[ID:%d]! Вы можете убивать друг друга без потери очков кармы!", Clan[targetclanid][cName], targetclanid);
					foreach(Player, cid)
					{//цикл
					    if (Player[cid][MyClan] == targetclanid) SendClientMessage(cid, COLOR_RED, String);
					    else if (Player[cid][MyClan] == clanid) SendClientMessage(cid, COLOR_RED, String2);
					}//цикл
				}//Объявить войну клану игрока
				if (listitem == 7)
				{//телепортироваться к игроку (Престиж 5)
				    new String[140], clickedplayerid = ClickedPid[playerid];
					if (PrestigeTPTime[playerid] > 0) {format(String, sizeof String, "ОШИБКА: Вы не можете телепортироваться к игрокам еще %d секунд!", PrestigeTPTime[playerid]); return SendClientMessage(playerid, COLOR_RED, String);}
				    if (Player[playerid][Prestige] < 5) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 5-го уровня Престижа!");
				    if (InEvent[playerid] > 0) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Нельзя телепортироваться когда вы участвуете в соревнованиях!");
				    if (QuestActive[playerid] > 0) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Нельзя телепортироваться во время выполнения задания или работы!");
				    if (InEvent[clickedplayerid] > 0) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Этот игрок сейчас участвует в соревнованиях!");
					if (GetPlayerVirtualWorld(clickedplayerid) != 0) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Этот игрок не находится в общем игровом мире!");
					if (LSpecID[clickedplayerid] != -1) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Этот игрок находится в режиме слежки!");
					if (GetPlayerInterior(clickedplayerid) != 0) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Этот игрок находится в помещении!");
					if (Player[clickedplayerid][Banned] > 0) return SendClientMessage(playerid, COLOR_RED, "Нельзя телепортироваться к этому игроку так как он забанен!");
					SetPlayerInterior(playerid, 0);  SetPlayerVirtualWorld(playerid, 0); PrestigeTPTime[playerid] = 180; AdminTPCantKill[playerid] = 20;
					new Float: x, Float: y, Float: z; GetPlayerPos(clickedplayerid, x, y, z);
				    if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER) SetVehiclePos(GetPlayerVehicleID(playerid), x + 1, y, z);
				    else SetPlayerPos(playerid, x + 1, y, z);
				    format(String, sizeof String, "Вы телепортировались к игроку %s[%d] и не можете брать оружие в течение 20 секунд!", PlayerName[clickedplayerid], clickedplayerid); SendClientMessage(playerid, COLOR_YELLOW, String);
				    format(String, sizeof String, "Игрок %s[%d] телепортировался к вам (Престиж 5) и не может атаковать вас в течение 20 секунд!", PlayerName[playerid], playerid); SendClientMessage(clickedplayerid, COLOR_YELLOW, String);
				}//телепортироваться к игроку (Режим Бога, Престиж 5)
			}//респонс
		}//меню игрока таб

	case DIALOG_TABGIVECASH:
		{//передать денег
			if(response)
			{//респонс
				if (Logged[playerid] == 0){SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вы должны авторизироваться, чтобы использовать эту команду");return 1;}
                if (Player[playerid][Banned] > 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Забаненные игроки не могут передавать деньги");
				new plid = ClickedPid[playerid]; new money = strval(inputtext);
				new stringD[180];
				if (!IsPlayerConnected(plid)){SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Игрока с указанным ID нет в сети"); return 1;}
				if (Logged[plid] == 0){SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Игрока с указанным ID не авторизировался"); return 1;}
				if (Player[plid][GiveCashBalance] >= 100000000) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Этому игроку нельзя передавать деньги!");
                if (LastPlayerTuneStatus[plid] > 0) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Нельзя передавать деньги игроку, который он находится в автомастерской. Попробуйте позднее.");
				if (money < 1000){SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Минимальная сумма перевода: 1000$"); return 1;}
				if (money > Player[playerid][Cash]){SendClientMessage(playerid,COLOR_RED,"ОШИБКА: У вас нет такой суммы денег"); return 1;}
				if (money > 100000000 - Player[plid][GiveCashBalance]) money = 100000000 - Player[plid][GiveCashBalance];//Если игрок может получить лишь 20к по балансу - то эта строка правит сумму перевода на 20к
				Player[plid][Cash] += money;Player[playerid][Cash] -= money;
				Player[playerid][GiveCashBalance] -= money; Player[plid][GiveCashBalance] += money;
				format(stringD, sizeof(stringD), "{FFFF00}Игрок %s[%d] передал вам {FFFFFF}%d$ {FFFF00}денег", PlayerName[playerid], playerid, money);
				SendClientMessage(plid,COLOR_YELLOW,stringD);
				format(stringD, sizeof(stringD), "{FFFF00}Вы успешно передали {FFFFFF}%d$ {FFFF00}денег игроку %s[%d]", money, PlayerName[plid], plid);
				SendClientMessage(playerid,COLOR_YELLOW,stringD);
				QuestUpdate(playerid, 15, money);//Обновление квеста Подарите другим игрокам 50 000$

				format(stringD, sizeof stringD, "%d.%d.%d в %d:%d:%d |   CASH: %s[%d] передал %d$ игроку %s[%d]", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid, money, PlayerName[plid], plid);
				WriteLog("GlobalLog", stringD);WriteLog("CashOperations", stringD);
			}//респонс
		}//передать денег		
		
	case DIALOG_CLANMANAGER:
		{//управление кланом
			if(response)
			{//респорс
				if (listitem == 0)
				{//удалить из клана
					ClanFunks[playerid] = -1;
					ShowPlayerDialog(playerid, DIALOG_CLANENTERNAME, 1, "Исключение из клана", "{FFFFFF}Введите никнейм игрока, которого вы хотите исключить из клана", "Ок", "Отмена");
				}//удалить из клана
				if (listitem == 1)
				{//смена цвета
					new StringX[1024];
					strcat(StringX, "{AFAFAF}Цвет №0\n{FFFF99}Цвет №1\n{FFFF00}Цвет №2\n{FF99FF}Цвет №3\n{FF9999}Цвет №4\n{FFCC00}Цвет №5\n{FF66CC}Цвет №6\n{FF6600}Цвет №7\n{FF00FF}Цвет №8\n{CCFFFF}Цвет №9\n{00A0C1}Цвет №10\n");
					strcat(StringX, "{E5004F}Цвет №11\n{CCFF00}Цвет №12\n{CC66FF}Цвет №13\n{CC3366}Цвет №14\n{CC6600}Цвет №15\n{9999FF}Цвет №16\n{9925FF}Цвет №17\n{99CCCC}Цвет №18\n{99FF66}Цвет №19\n{99FF00}Цвет №20\n");
					strcat(StringX, "{993300}Цвет №21\n{990066}Цвет №22\n{66FFFF}Цвет №23\n{6666FF}Цвет №24\n{EB6100}Цвет №25\n{666633}Цвет №26\n{33FFFF}Цвет №27\n{3399FF}Цвет №28\n{33CC99}Цвет №29\n{33FF66}Цвет №30\n");
					strcat(StringX, "{339900}Цвет №31\n{457EFF}Цвет №32\n{FFCC00}Цвет №33\n{976D3D}Цвет №34\n{FF8800}Цвет №35\n{FF6666}Цвет №36\n{0015FF}Цвет №37\n{DDAA00}Цвет №38\n{FFFFFF}Цвет №39\n{FF8000}Цвет №40");
					ShowPlayerDialog(playerid, DIALOG_CLANCOLOR, 2, "Выберите цвет клана", StringX, "Выбрать", "Отмена");
				}//смена цвета
				if (listitem == 2)
				{//сообщение клана
				    ShowPlayerDialog(playerid, DIALOG_CLANMESSAGE, 1, "Сообщение клана", "{008E00}Введите сообщение, которое будет отображаться игрокам при входе на сервер.\nВведите '{FF0000}ПУСТО{008E00}'(большими буквами), чтобы убрать сообщение.", "ОК", "Отмена");
				}//сообщение клана
				if (listitem == 3)
				{//Переименовать клан
				    ShowPlayerDialog(playerid, DIALOG_CLANRENAME, 1, "Введите название клана", "{FFFFFF}Введите название клана.\n{008E00}[Длина от 2 до 20 символов]", "ОК", "Отмена");
				}//Переименовать клан
				if (listitem == 4)
				{//Объявить об окончании войны
				    new clanid = Player[playerid][MyClan], targetclan = Clan[clanid][cEnemyClan], String[140];
				    if (targetclan == 0) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы не объявляли никому войну.");
				    format(String, sizeof String, "{008E00}Клан {FFFFFF}%s{008E00}[ID:%d] объявил о нежелании продолжать войну с кланом {FFFFFF}%s{008E00}[ID:%d].", Clan[clanid][cName], clanid, Clan[targetclan][cName], targetclan);
				    Clan[clanid][cEnemyClan] = 0; SaveClan(clanid); return SendClientMessageToAll(-1, String);
				}//Объявить об окончании войны
				if (listitem == 5)
				{//распустить клан
					ShowPlayerDialog(playerid, DIALOG_CLANDESTROY, 0, "{FF0000}Распустить клан", "Вы уверены, что хотите {FF0000}распустить клан?", "Да", "Отмена");
				}//распустить клан
				if (listitem == 6)//назначение прав (ничего не делает, заголовок)
					ShowPlayerDialog(playerid, DIALOG_CLANMANAGER, 2, "Управление кланом", "{FFFFFF}Удалить игрока из клана\nИзменить цвет клана\nИзменить сообщение клана при входе в игру\nПереименовать клан\n{AFAFAF}Объявить об окончании войны\n{FF0000}[Распустить клан]\n/---{008E00} Назначение прав {FFFFFF}---/\nОбычный член клана\nМожет принимать игроков\nМожет принимать и исключать игроков", "Ок", "Отмена");
				if (listitem == 7)
				{//обычный член
					ClanFunks[playerid] = 0;
					ShowPlayerDialog(playerid, DIALOG_CLANENTERNAME, 1, "Назначение прав", "{FFFFFF}Введите никнейм члена клана, которому хотите\nустановить статус '{008E00}Обычный член клана{FFFFFF}'", "Ок", "Отмена");
				}//обычный член
				if (listitem == 8)
				{//может принимать
					ClanFunks[playerid] = 1;
					ShowPlayerDialog(playerid, DIALOG_CLANENTERNAME, 1, "Назначение прав", "{FFFFFF}Введите никнейм члена клана, которому хотите\nустановить статус '{008E00}Может принимать игроков{FFFFFF}'", "Ок", "Отмена");
				}//может принимать
				if (listitem == 9)
				{//может принимать и удалять
					ClanFunks[playerid] = 2;
					ShowPlayerDialog(playerid, DIALOG_CLANENTERNAME, 1, "Назначение прав", "{FFFFFF}Введите никнейм члена клана, которому хотите \nустановить статус '{008E00}Может принимать и исключать игроков{FFFFFF}'", "Ок", "Отмена");
				}//может принимать и удалять
			}//респонс
		}//управление кланом

	case DIALOG_CLANENTERNAME:
		{//введите имя
			if(response)
			{//респонс
			    if (strlen(inputtext) < 3 || strlen(inputtext) > 24) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Неверная длина никнейма");
				new filename[MAX_FILE_NAME], file, clanid = Player[playerid][MyClan], PlayerFind = 0;
				if(!strcmp(Clan[clanid][cMember1], inputtext, true)) {PlayerFind = 1; if(ClanFunks[playerid] == -1) strmid(Clan[clanid][cMember1], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);}
				if(!strcmp(Clan[clanid][cMember2], inputtext, true)) {PlayerFind = 2; if(ClanFunks[playerid] == -1) strmid(Clan[clanid][cMember2], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);}
				if(!strcmp(Clan[clanid][cMember3], inputtext, true)) {PlayerFind = 3; if(ClanFunks[playerid] == -1) strmid(Clan[clanid][cMember3], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);}
				if(!strcmp(Clan[clanid][cMember4], inputtext, true)) {PlayerFind = 4; if(ClanFunks[playerid] == -1) strmid(Clan[clanid][cMember4], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);}
				if(!strcmp(Clan[clanid][cMember5], inputtext, true)) {PlayerFind = 5; if(ClanFunks[playerid] == -1) strmid(Clan[clanid][cMember5], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);}
				if(!strcmp(Clan[clanid][cMember6], inputtext, true)) {PlayerFind = 6; if(ClanFunks[playerid] == -1) strmid(Clan[clanid][cMember6], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);}
				if(!strcmp(Clan[clanid][cMember7], inputtext, true)) {PlayerFind = 7; if(ClanFunks[playerid] == -1) strmid(Clan[clanid][cMember7], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);}
				if(!strcmp(Clan[clanid][cMember8], inputtext, true)) {PlayerFind = 8; if(ClanFunks[playerid] == -1) strmid(Clan[clanid][cMember8], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);}
				if(!strcmp(Clan[clanid][cMember9], inputtext, true)) {PlayerFind = 9; if(ClanFunks[playerid] == -1) strmid(Clan[clanid][cMember9], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);}
				if(!strcmp(Clan[clanid][cMember10], inputtext, true)) {PlayerFind = 10; if(ClanFunks[playerid] == -1) strmid(Clan[clanid][cMember10], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);}
				if(!strcmp(Clan[clanid][cMember11], inputtext, true)) {PlayerFind = 11; if(ClanFunks[playerid] == -1) strmid(Clan[clanid][cMember11], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);}
				if(!strcmp(Clan[clanid][cMember12], inputtext, true)) {PlayerFind = 12; if(ClanFunks[playerid] == -1) strmid(Clan[clanid][cMember12], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);}
				if(!strcmp(Clan[clanid][cMember13], inputtext, true)) {PlayerFind = 13; if(ClanFunks[playerid] == -1) strmid(Clan[clanid][cMember13], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);}
				if(!strcmp(Clan[clanid][cMember14], inputtext, true)) {PlayerFind = 14; if(ClanFunks[playerid] == -1) strmid(Clan[clanid][cMember14], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);}
				if(!strcmp(Clan[clanid][cMember15], inputtext, true)) {PlayerFind = 15; if(ClanFunks[playerid] == -1) strmid(Clan[clanid][cMember15], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);}
				if(!strcmp(Clan[clanid][cMember16], inputtext, true)) {PlayerFind = 16; if(ClanFunks[playerid] == -1) strmid(Clan[clanid][cMember16], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);}
				if(!strcmp(Clan[clanid][cMember17], inputtext, true)) {PlayerFind = 17; if(ClanFunks[playerid] == -1) strmid(Clan[clanid][cMember17], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);}
				if(!strcmp(Clan[clanid][cMember18], inputtext, true)) {PlayerFind = 18; if(ClanFunks[playerid] == -1) strmid(Clan[clanid][cMember18], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);}
				if(!strcmp(Clan[clanid][cMember19], inputtext, true)) {PlayerFind = 19; if(ClanFunks[playerid] == -1) strmid(Clan[clanid][cMember19], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);}
				if(!strcmp(Clan[clanid][cMember20], inputtext, true)) {PlayerFind = 20; if(ClanFunks[playerid] == -1) strmid(Clan[clanid][cMember20], "Пусто", 0, strlen("Пусто"), MAX_PLAYER_NAME);}

				if (PlayerFind == 0){SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Игрок с таким ником не найден.");return 1;}
				if (ClanFunks[playerid] == -1)
				{//исключение из клана
					new FindName[24];new SendOnce = 0;
					foreach(Player, cid)
					{//цикл
						GetPlayerName(cid, FindName, sizeof(FindName));
						if (Player[cid][MyClan] == Player[playerid][MyClan] && !strcmp(inputtext, FindName, true))
						{//исключаемый игрок онлайн
							Player[cid][Member] = 0;Player[cid][Leader] = 0;Player[cid][MyClan] = 0;PlayerColor[cid] = 0;
							SendClientMessage(cid,COLOR_RED,"Вас исключили из клана");SavePlayer(cid);
						}//исключаемый игрок онлайн
						format(filename, sizeof(filename), "accounts/%s.ini", inputtext);
						file = ini_openFile(filename);
						ini_setInteger(file,"MyClan", 0);
						ini_setInteger(file,"Leader", 0);
						ini_setInteger(file,"Member", 0);
						ini_closeFile(file);
						if (SendOnce == 0){SendClientMessage(playerid,COLOR_YELLOW,"Игрок исключен из клана");SendOnce = 1;}
					}//цикл
				}//исключение из клана
				if (ClanFunks[playerid] == 0)
				{//Обычный член клана
					new FindName[24];new SendOnce = 0;
					foreach(Player, cid)
					{//цикл
						GetPlayerName(cid, FindName, sizeof(FindName));
						if (Player[cid][MyClan] == Player[playerid][MyClan] && !strcmp(inputtext, FindName, true))
						{//исключаемый игрок онлайн
							Player[cid][Leader] = 0;SendClientMessage(cid,COLOR_YELLOW,"Теперь вы обычный член клана");SavePlayer(cid);
						}//исключаемый игрок онлайн
						format(filename, sizeof(filename), "accounts/%s.ini", inputtext);
						file = ini_openFile(filename);
						ini_setInteger(file,"Leader", 0);
						ini_closeFile(file);
						if (SendOnce != 1){SendClientMessage(playerid,COLOR_YELLOW,"Вы успешно изменили статус игроку.");SendOnce = 1;}
					}//цикл
				}//Обычный член клана
				if (ClanFunks[playerid] == 1)
				{//Может приглашать в клан
					new FindName[24];new SendOnce = 0;
					foreach(Player, cid)
					{//цикл
						GetPlayerName(cid, FindName, sizeof(FindName));
						if (Player[cid][MyClan] == Player[playerid][MyClan] && !strcmp(inputtext, FindName, true))
						{//исключаемый игрок онлайн
							Player[cid][Leader] = 1;SendClientMessage(cid,COLOR_YELLOW,"Теперь вы можете принимать игроков в клан");SavePlayer(cid);
						}//исключаемый игрок онлайн
						format(filename, sizeof(filename), "accounts/%s.ini", inputtext);
						file = ini_openFile(filename);
						ini_setInteger(file,"Leader", 1);
						ini_closeFile(file);
						if (SendOnce == 0){SendClientMessage(playerid,COLOR_YELLOW,"Вы успешно изменили статус игроку.");SendOnce = 1;}
					}//цикл
				}//Может приглашать в клан
				if (ClanFunks[playerid] == 2)
				{//Может приглашать в клан и удалять из него
					new FindName[24];new SendOnce = 0;
					foreach(Player, cid)
					{//цикл
						GetPlayerName(cid, FindName, sizeof(FindName));
						if (Player[cid][MyClan] == Player[playerid][MyClan] && !strcmp(inputtext, FindName, true))
						{//исключаемый игрок онлайн
							Player[cid][Leader] = 2;SendClientMessage(cid,COLOR_YELLOW,"Теперь вы можете принимать игроков в клан и исключать из него");SavePlayer(cid);
						}//исключаемый игрок онлайн
						format(filename, sizeof(filename), "accounts/%s.ini", inputtext);
						file = ini_openFile(filename);
						ini_setInteger(file,"Leader", 2);
						ini_closeFile(file);
						if (SendOnce == 0){SendClientMessage(playerid,COLOR_YELLOW,"Вы успешно изменили статус игроку.");SendOnce = 1;}
					}//цикл
				}//Может приглашать в клан и удалять из него
				SaveClan(clanid);
			}//респонс
		}//введите имя

	case DIALOG_CLANCOLOR:
		{//выбор цвета
			if(response)
			{//Да
			    PlayerColor[playerid] = listitem;
				foreach(Player, cid)
				{//цикл
					if (Player[cid][Member] != 0 && Player[cid][MyClan] == Player[playerid][MyClan])
					{
						SendClientMessage(cid, ClanColor[listitem], "Цвет клана был изменен.");
						PlayerColor[cid] = PlayerColor[playerid];
					}
				}//цикл
				new clanid = Player[playerid][MyClan]; Clan[clanid][cColor] = listitem; SaveClan(clanid);
			}//Да
		}//выбор цвета

	case DIALOG_CLANDESTROY:
		{//распустить клан
			if(response)
			{//Да
				new StringX[120], filename[MAX_FILE_NAME], clanid = Player[playerid][MyClan], bbase = Clan[clanid][cBase];
				format(StringX,sizeof(StringX),"Клан '{FFFFFF}%s{008E00}' был распущен.",Clan[clanid][cName]);
				SendClientMessageToAll(COLOR_CLAN,StringX);
				format(filename, sizeof(filename), "Clans/%d.ini", clanid);
				if (bbase > 0)
				{//у клана есть штаб
				    Base[bbase][bPrice] -= Base[bbase][bPrice] / 100 * 15;//При продаже штаба взывмается налог 15% от его стоимости
					Player[playerid][Cash] += Base[bbase][bPrice];
					new String[80], text3d[MAX_3DTEXT];
					format(String,sizeof(String),"{008E00}Вы успешно продали свой штаб за {FFFFFF}%d{008E00}$",Base[bbase][bPrice]);
					SendClientMessage(playerid,COLOR_GREEN,String);
				    Base[bbase][bClan] = 0; Base[bbase][bPrice] = 10000000; SaveBase(bbase);
					format(text3d, sizeof(text3d), "{007FFF}Штаб ({FFFFFF}%d${007FFF})\n{008E00}Клан:{FFFFFF} Никто\nНажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать", Base[bbase][bPrice]);
					UpdateDynamic3DTextLabelText(BaseText3D[bbase], 0xFFFFFFFF, text3d);
				}//у клана есть штаб
				dini_Remove(filename);//удаление файла клана
				Clan[clanid][cLevel] = 0;//Чтобы клан был недействителеьным
				foreach(Player, cid)
				{//цикл
					if (Player[cid][Member] != 0 && Player[cid][MyClan] == clanid)
					{//соклан
						Player[cid][MyClan] = 0;Player[cid][Member] = 0;Player[cid][Leader] = 0;
						PlayerColor[cid] = 0;SavePlayer(cid);
					}//соклан
				}//цикл

				for(new i = 0; i < MaxClanID; i++) //убирает ID этого клана из списка врагов у всех кланов (если у кого есть)
					if (Clan[i][cEnemyClan] == clanid) {Clan[i][cEnemyClan] = 0; SaveClan(i);}
			}//да
		}//распустить клан
		
	case DIALOG_BASEMENU:
		{//Штаб диалог
			if(response)
			{//респонс
			    if (listitem == 0)
			    {//Войти в штаб
		        	if (GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid, COLOR_RED, "Заходить в штабы можно только в общем игровом мире!");
                    new i = LastBaseVisited[playerid];
				    if (i < 1 || i == MAX_BASE) return 1;
					if (PlayerToPoint(3.0,playerid, Base[i][bPosEnterX], Base[i][bPosEnterY], Base[i][bPosEnterZ]))
					{
					    if (Base[i][bPrice] < 20000000 && Base[i][bPrice] > 0) {SetPlayerPos(playerid, 774.0399, -78.7388, 1000.8); SetPlayerFacingAngle(playerid, 0); SetPlayerInterior(playerid, 7);}//Самый дешевый штаб
					    else if (Base[i][bPrice] < 40000000 && Base[i][bPrice] > 0) {SetPlayerPos(playerid, 774.0266, -50.3715, 1000.8); SetPlayerFacingAngle(playerid, 0); SetPlayerInterior(playerid, 6);}//Штаб за 20-39кк
					    else if (Base[i][bPrice] < 60000000 && Base[i][bPrice] > 0) {SetPlayerPos(playerid, 1727.0281, -1637.9517 ,20.5); SetPlayerFacingAngle(playerid, 170); SetPlayerInterior(playerid, 18);}//Штаб за 40-59кк
					    else {SetPlayerPos(playerid, -2636.4778, 1402.5682, 906.4609); SetPlayerFacingAngle(playerid, 0); SetPlayerInterior(playerid, 3);}//Штаб за 60+кк
                        SetPlayerVirtualWorld(playerid, 2000 + i); SetCameraBehindPlayer(playerid);//мир штаба
                        InPeacefulZone[playerid] = 1;
					}
			    }//Войти в штаб
				if (listitem == 1) SendCommand(playerid, "/baseinfo", "");
				if (listitem == 2) SendCommand(playerid, "/buybase", "");
				if (listitem == 3)
				{//продать штаб
				    new baseid = LastBaseVisited[playerid];
				    if (baseid < 1 || baseid == MAX_BASE) return 1;
				    new String[180], Nalog = Base[baseid][bPrice] / 100 * 15;
				    format(String, sizeof String, "{FFFFFF}Вы уверены, что хотите продать штаб?\n\nЦена штаба для покупки: {008D00}%d$\n{FFFFFF}Цена штаба для продажи: {E60020}%d$", Base[baseid][bPrice], Base[baseid][bPrice] - Nalog);
				    return ShowPlayerDialog(playerid, DIALOG_SELLBASE, 0, "Продать штаб", String, "{FF0000}ПРОДАТЬ", "Отмена");
				}//продать штаб
				if (listitem == 4)
				{//увеличить цену штаба
				    if (Player[playerid][MyClan] == 0)return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы не в клане");
	   				new clanid = Player[playerid][MyClan];
                    for(new i = 1; i < MAX_BASE; i++) if(PlayerToPoint(3.0,playerid, Base[i][bPosEnterX], Base[i][bPosEnterY], Base[i][bPosEnterZ]))
					{
					    if (Base[i][bClan] != clanid) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Это не ваш штаб");
                        return ShowPlayerDialog(playerid, DIALOG_BASEMENUPRICE, 1, "Повысить цену", "{FFFF00}Интерьер штаба меняется в зависимости от его стоимости:{FFFFFF}\n• Менее 20 000 000$\n• 20 000 000$\n• 40 000 000$\n• 60 000 000$\n\n{FFFF00}На сколько вы хотите повысить цену штаба?", "ОК", "Назад");
                    }
				}//увеличить цену штаба
				if (listitem == 5)
				{//Спавн снаружи штаба
				    if (Player[playerid][MyClan] == 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вы не в клане");
					new clanid = Player[playerid][MyClan];
					if(Clan[clanid][cBase] < 1 || Clan[clanid][cBase] > MAX_BASE) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: У вашего клана нет штаба");
    				Player[playerid][Spawn] = 5;
					SendClientMessage(playerid,COLOR_YELLOW,"Место вашего респавна изменено на {FFFFFF}Штаб клана (Снаружи)");
				}//Спавн снаружи штаба
				if (listitem == 6)
				{//Спавн внутри штаба
				    if (Player[playerid][MyClan] == 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вы не в клане");
					new clanid = Player[playerid][MyClan];
					if(Clan[clanid][cBase] < 1 || Clan[clanid][cBase] > MAX_BASE) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: У вашего клана нет штаба");
    				Player[playerid][Spawn] = 8; Player[playerid][SpawnStyle] = 0;
					return SendClientMessage(playerid,COLOR_YELLOW,"Место вашего респавна изменено на {FFFFFF}Штаб клана (Внутри)");
				}//Спавн внутри штаба
			}//респонс
		}//Штаб диалог
		
 	case DIALOG_INVISIBLE:
		{//диалог инвиз
			if(response)
			{//респонс
			    if(listitem == 0)
			    {//нет
			        Player[playerid][Invisible] = 0;
			        SendClientMessage(playerid,COLOR_YELLOW,"Невидимость отключена.");
			    }//нет
			    if(listitem == 1)
			    {//на радаре
			        if (Player[playerid][Level] < 70) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вы должны быть как минимум 70-го уровня.");
                   	if (Player[playerid][Karma] <= -400) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Невидимость недоступна из-за низкой кармы.");
					Player[playerid][Invisible] = 1;
					SendClientMessage(playerid,COLOR_YELLOW,"Включена невидимость на радаре.");
			    }//на радаре
			}//респонс
		}//диалог инвиз
		
	case DIALOG_AIRPORT:
		{//аэропорт
		    if(response)
			{//респонс
			    if (Player[playerid][Banned] != 0) return 1;//Забаненных не пускает
			    if (InEvent[playerid] > 0) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Нельзя использовать аэропорт в соревнованиях");//игрок мог вызвать менюшку до старта соревнований, и затем во время соревнований использовать аэропорт
			    if(listitem == 0)
			    {//LS
			        if (IsPlayerInRangeOfPoint(playerid,3,1451.6349,-2287.0703,13.5469)) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вы итак в Лос Сантосе");
			        if (Player[playerid][Cash] < 50000) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вам нужно 50 000$ для покупки билета");
			        AirportTime[playerid] = 15; AirportID[playerid] = 1;Player[playerid][Cash] -= 50000;
			        SendClientMessage(playerid,COLOR_YELLOW,"Вы будете в Лос Сантосе через 15 секунд.");SetPlayerVirtualWorld(playerid,playerid + 1);
			        SetPlayerInterior(playerid,1);SetPlayerPos(playerid,1.5491, 23.3183, 1199.5938);SetPlayerFacingAngle(playerid,0.0);SetCameraBehindPlayer(playerid);
			    }//LS
			    if(listitem == 1)
			    {//SF
			        if (IsPlayerInRangeOfPoint(playerid,3,-1404.6575,-303.7458,14.1484)) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вы итак в Сан Фиерро");
                    if (Player[playerid][Cash] < 50000) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вам нужно 50 000$ для покупки билета");
			        AirportTime[playerid] = 15; AirportID[playerid] = 2;Player[playerid][Cash] -= 50000;
			        SendClientMessage(playerid,COLOR_YELLOW,"Вы будете в Сан Фиерро через 15 секунд.");SetPlayerVirtualWorld(playerid,playerid + 1);
			        SetPlayerInterior(playerid,1);SetPlayerPos(playerid,1.5491, 23.3183, 1199.5938);SetPlayerFacingAngle(playerid,0.0);SetCameraBehindPlayer(playerid);
			    }//SF
			    if(listitem == 2)
			    {//LV
			        if (IsPlayerInRangeOfPoint(playerid,3,1672.9861,1447.9349,10.7868)) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вы итак в Лас Вентурасе");
                    if (Player[playerid][Cash] < 50000) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вам нужно 50 000$ для покупки билета");
			        AirportTime[playerid] = 15; AirportID[playerid] = 3;Player[playerid][Cash] -= 50000;
			        SendClientMessage(playerid,COLOR_YELLOW,"Вы будете в Лас Вентурасе через 15 секунд.");SetPlayerVirtualWorld(playerid,playerid + 1);
			        SetPlayerInterior(playerid,1);SetPlayerPos(playerid,1.5491, 23.3183, 1199.5938);SetPlayerFacingAngle(playerid,0.0);SetCameraBehindPlayer(playerid);
			    }//LV
			}//респонс
		}//аэропорт
		
		case DIALOG_STEALCAR:
		{//StealCar
		    if (!IsPlayerInAnyVehicle(playerid) && response) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы не в транспорте!");
			else QuestCar[playerid] = GetPlayerVehicleID(playerid);

		    if (listitem == 0 || !response)
			{
				SendClientMessage(playerid, COLOR_QUEST, "Вы угнали транспорт! Он исчезнет как только вы покинете его!");
                return SendClientMessage(playerid,COLOR_CYAN,"Подсказка: Нажмите клавишу {FFFFFF}Y{00CCCC} или {FFFFFF}N{00CCCC} если вы передумали и хотите купить этот транспорт.");
			}
		    if (listitem == 1 || listitem == 2)
		    {//Покупка авто
		        if (StealCarModel[playerid] != GetVehicleModel(QuestCar[playerid])) return QuestCar[playerid] = -1;//Игрок попытлася купить авто, сидя уже в другом транспорте
		        new Price = GetVehicleMaxSpeed(QuestCar[playerid]) * 500, modelid = GetVehicleModel(QuestCar[playerid]), xmodel = modelid - 400, String[120];
		        if (Player[playerid][Cash] < Price)
		        {
					format(String,sizeof(String),"{AFAFAF}Транспорт: {FFCC00}%s{AFAFAF} Стоимость: %d$",PlayerVehicleName[xmodel], Price);
			        ShowPlayerDialog(playerid, DIALOG_STEALCAR, 2, String, "{FFCC00}Угнать транспорт{FFFFFF}\nСделать личным транспортом {007FFF}1{FFFFFF}-го класса\nСделать личным транспортом {007FFF}2{FFFFFF}-го класса\n{FF0000}Покинуть транспорт", "Начать", "Отмена");
					return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: У вас недостаточно денег для покупки этого транспорта!");
				}
				Player[playerid][Cash] -= Price;
				new col1, col2; GetVehicleColor(QuestCar[playerid], col1, col2);
				if (listitem == 1) {Player[playerid][CarSlot1] = modelid; Player[playerid][CarSlot1Color1] = col1; Player[playerid][CarSlot1Color2] = col2; ResetTuneClass1(playerid);}
				if (listitem == 2) {Player[playerid][CarSlot2] = modelid; Player[playerid][CarSlot2Color1] = col1; Player[playerid][CarSlot2Color2] = col2; ResetTuneClass2(playerid);}
				format(String,sizeof(String),"Ваш новый автомобиль %d-го класса - %s", listitem, PlayerVehicleName[xmodel]); SendClientMessage(playerid,COLOR_YELLOW,String);
				format(String,sizeof(String),"Вы потратили на него %d$", Price); SendClientMessage(playerid,COLOR_YELLOW,String);
                Player[playerid][CarActive] = listitem; PlayerCarID[playerid] = QuestCar[playerid]; QuestCar[playerid] = -1;
		    }//Покупка авто
		    if (listitem == 3) return RemovePlayerFromVehicle(playerid);//Покинуть транспорт
		}//StealCar
		
		case DIALOG_STEALWATERCAR:
		{//StealWaterCar
		    if (!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы не в транспорте!");
			else QuestCar[playerid] = GetPlayerVehicleID(playerid);

            if (listitem == 0 || !response)
			{
				SendClientMessage(playerid, COLOR_QUEST, "Вы угнали транспорт! Он исчезнет как только вы покинете его!");
                return SendClientMessage(playerid,COLOR_CYAN,"Подсказка: Нажмите клавишу {FFFFFF}Y{00CCCC} или {FFFFFF}N{00CCCC} если вы передумали и хотите купить этот транспорт.");
			}
			if (listitem == 1)
		    {//Покупка авто
		        new Price = GetVehicleMaxSpeed(QuestCar[playerid]) * 500, modelid = GetVehicleModel(QuestCar[playerid]), xmodel = modelid - 400, String[120];
		        if (Player[playerid][Cash] < Price)
		        {
					format(String,sizeof(String),"{AFAFAF}Транспорт: {FFCC00}%s{AFAFAF} Стоимость: %d$",PlayerVehicleName[xmodel], Price);
			        ShowPlayerDialog(playerid, DIALOG_STEALWATERCAR, 2, String, "{FFCC00}Угнать транспорт{FFFFFF}\nСделать личным транспортом {007FFF}3{FFFFFF}-го класса\n{FF0000}Покинуть транспорт", "Начать", "Отмена");
					return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: У вас недостаточно денег для покупки этого транспорта!");
				}
				Player[playerid][Cash] -= Price;
				new col1, col2; GetVehicleColor(QuestCar[playerid], col1, col2);
				Player[playerid][CarSlot3] = modelid; Player[playerid][CarSlot3Color1] = col1; Player[playerid][CarSlot3Color2] = col2;
				format(String,sizeof(String),"Ваш новый автомобиль 3-го класса - %s", PlayerVehicleName[xmodel]); SendClientMessage(playerid,COLOR_YELLOW,String);
				format(String,sizeof(String),"Вы потратили на него %d$", Price); SendClientMessage(playerid,COLOR_YELLOW,String);
                Player[playerid][CarActive] = 3; PlayerCarID[playerid] = QuestCar[playerid]; QuestCar[playerid] = -1;
		    }//Покупка авто
		    if (listitem == 2) return RemovePlayerFromVehicle(playerid);//Покинуть транспорт
		}//StealWaterCar
		
		case DIALOG_STEALAIRCAR:
		{//StealAirCar
		    if (listitem == 0 || !response)
			{
				SendClientMessage(playerid, COLOR_QUEST, "Вы угнали транспорт! Он исчезнет как только вы покинете его!");
                return SendClientMessage(playerid,COLOR_CYAN,"Подсказка: Нажмите клавишу {FFFFFF}Y{00CCCC} или {FFFFFF}N{00CCCC} если вы передумали и хотите купить этот транспорт.");
			}
			else QuestCar[playerid] = GetPlayerVehicleID(playerid);

		    if (listitem == 0 || !response) return SendClientMessage(playerid, COLOR_QUEST, "Вы угнали транспорт! Он исчезнет как только вы покинете его!");
		    if (listitem == 1)
		    {//Покупка авто
		        new Price = GetVehicleMaxSpeed(QuestCar[playerid]) * 2000, modelid = GetVehicleModel(QuestCar[playerid]), xmodel = modelid - 400, String[120];
		        if (Player[playerid][Cash] < Price)
		        {
					format(String,sizeof(String),"{AFAFAF}Транспорт: {FFCC00}%s{AFAFAF} Стоимость: %d$",PlayerVehicleName[xmodel], Price);
			        ShowPlayerDialog(playerid, DIALOG_STEALAIRCAR, 2, String, "{FFCC00}Угнать транспорт{FFFFFF}\nСделать личным транспортом {007FFF}3{FFFFFF}-го класса\n{FF0000}Покинуть транспорт", "Начать", "Отмена");
					return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: У вас недостаточно денег для покупки этого транспорта!");
				}
				Player[playerid][Cash] -= Price;
				new col1, col2; GetVehicleColor(QuestCar[playerid], col1, col2);
				Player[playerid][CarSlot3] = modelid; Player[playerid][CarSlot3Color1] = col1; Player[playerid][CarSlot3Color2] = col2;
				format(String,sizeof(String),"Ваш новый автомобиль 3-го класса - %s", PlayerVehicleName[xmodel]); SendClientMessage(playerid,COLOR_YELLOW,String);
				format(String,sizeof(String),"Вы потратили на него %d$", Price); SendClientMessage(playerid,COLOR_YELLOW,String);
                Player[playerid][CarActive] = 3; PlayerCarID[playerid] = QuestCar[playerid]; QuestCar[playerid] = -1;
		    }//Покупка авто
		    if (listitem == 2) return RemovePlayerFromVehicle(playerid);//Покинуть транспорт
		}//StealAirCar
		
		case DIALOG_GGSHOP:
		{//GGSHOP
		    if(response)
			{//response
			    if(listitem == 1)//Повысить уровень ViP
			    {
			        if (Player[playerid][GameGold] < 150) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: У вас нет 150 рублей");
			        if (Player[playerid][GPremium] == 20) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: У вас максимальный уровень ViP");
			        Player[playerid][GameGold] -= 150.0; Player[playerid][GPremium] += 1;
					if (Player[playerid][GPremium] == 19) Player[playerid][Prestige] += 1;//Разовое повышение престижа на ViP 19
					SendClientMessage(playerid,COLOR_YELLOW,"Вы повысили ваш уровень ViP за 150 рублей. Введите /vip, чтобы узнать ваши привелегии.");
                    new String[140]; format(String, sizeof String, "%d.%d.%d в %d:%d:%d |   SHOP: %s[%d] повысил свой уровень ViP за 150 рублей", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid);
					WriteLog("GlobalLog", String);WriteLog("Shop", String);SavePlayer(playerid);
				}
			    if(listitem == 2)//LevelUp
			    {
			        if (Player[playerid][Level] >= 100 && Player[playerid][Prestige] < 10) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вы уже достигли максимального уровня! Перейдите на Престиж (/prestige).");
                    if (Player[playerid][Level] < 30)
					{
						if (Player[playerid][GameGold] < 10) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: У вас нет 10 рублей");
	       	  	    	Player[playerid][GameGold] -= 10.0; Player[playerid][Exp] += NeedXP[playerid]; PlayerLevelUp(playerid);
			        	SendClientMessage(playerid,COLOR_YELLOW,"Вы повысили свой уровень за 10 рублей");
			        	new String[140]; format(String, sizeof String, "%d.%d.%d в %d:%d:%d |   SHOP: %s[%d] повысил свой уровень за 10 рублей", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid);
						WriteLog("GlobalLog", String);WriteLog("Shop", String);
					}
					else if (Player[playerid][Level] < 60)
					{
						if (Player[playerid][GameGold] < 15) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: У вас нет 15 рублей");
	       	  	    	Player[playerid][GameGold] -= 15.0; Player[playerid][Exp] += NeedXP[playerid]; PlayerLevelUp(playerid);
			        	SendClientMessage(playerid,COLOR_YELLOW,"Вы повысили свой уровень за 15 рублей");
			        	new String[140]; format(String, sizeof String, "%d.%d.%d в %d:%d:%d |   SHOP: %s[%d] повысил свой уровень за 15 рублей", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid);
						WriteLog("GlobalLog", String);WriteLog("Shop", String);
					}
					else
					{
                        if (Player[playerid][GameGold] < 20) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: У вас нет 20 рублей");
	       	  	    	Player[playerid][GameGold] -= 20.0; Player[playerid][Exp] += NeedXP[playerid]; PlayerLevelUp(playerid);
			        	SendClientMessage(playerid,COLOR_YELLOW,"Вы повысили свой уровень за 20 рублей");
			        	new String[140]; format(String, sizeof String, "%d.%d.%d в %d:%d:%d |   SHOP: %s[%d] повысил свой уровень за 20 рублей", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid);
						WriteLog("GlobalLog", String);WriteLog("Shop", String);
					}
				}
			    if(listitem == 3)//1 000 000$ (15GG)
			    {
			        if (Player[playerid][GameGold] < 15) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: У вас нет 15 рублей");
			        Player[playerid][GameGold] -= 15.0;Player[playerid][Cash] += 1000000; SavePlayer(playerid);
			        SendClientMessage(playerid,COLOR_YELLOW,"Вы купили 1 000 000$ за 15 рублей");
			        new String[140]; format(String, sizeof String, "%d.%d.%d в %d:%d:%d |   SHOP: %s[%d] приобрел 1 000 000$ за 15 рублей", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid);
					WriteLog("GlobalLog", String);WriteLog("Shop", String);
				}
			    if(listitem == 4)//+50 к карме (10GG)
			    {
			        if (Player[playerid][Karma] >= 1000) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: У вас максимум кармы!");
			        if (Player[playerid][GameGold] < 10) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: У вас нет 10 рублей");
			        Player[playerid][GameGold] -= 10.0;Player[playerid][Karma] += 50;
			        if (Player[playerid][Karma] > 1000) Player[playerid][Karma] = 1000;
			        SendClientMessage(playerid,COLOR_YELLOW,"Вы купили 50 очков кармы за 10 рублей");
			        new String[140]; format(String, sizeof String, "%d.%d.%d в %d:%d:%d |   SHOP: %s[%d] купил 50 очков кармы за 10 рублей", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid);
					WriteLog("GlobalLog", String);WriteLog("Shop", String);SavePlayer(playerid);
				}
				if(listitem == 5)//Изменить игровой ник
			    {
			        if (Player[playerid][GameGold] < 100) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: У вас нет 100 рублей");
			        return ShowPlayerDialog(playerid, DIALOG_CHANGENICK, 1, "Смена ника", "{FF0000}Вы уверены, что хотите сменить ник?\n{FFFFFF}Для продолжения введите ваш текущий пароль:","ОК","Назад");
			    }
			    if(listitem == 6)//Разбан (50GG, 100GG или 250GG)
			    {
			        if (Player[playerid][Banned] == 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вы итак разбанены");
                    if (Player[playerid][Level] < 30 && Player[playerid][Prestige] == 0)
					{
						if (Player[playerid][GameGold] < 50) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: У вас нет 50 рублей");
				        Player[playerid][GameGold] -= 50.0;Player[playerid][Banned] = 0; strmid(BannedBy[playerid], "ПУСТО", 0, strlen("ПУСТО"), 5); strmid(BanReason[playerid], "ПУСТО", 0, strlen("ПУСТО"), 5);
						SavePlayer(playerid);LSpawnPlayer(playerid);
				        new pname[25], String[120];GetPlayerName(playerid,pname,sizeof(pname));format(String,sizeof(String),"{AFAFAF}SERVER: %s[%d] купил разбан за 50 рублей",pname,playerid);
				        PlayerWeather[playerid] = -1;SendClientMessageToAll(COLOR_YELLOW,String);
				        format(String, sizeof String, "%d.%d.%d в %d:%d:%d |   SHOP: %s[%d] приобрел разбан за 50 рублей", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid);
						WriteLog("GlobalLog", String);WriteLog("Shop", String);
			        }
					else if (Player[playerid][Level] < 60 && Player[playerid][Prestige] == 0)
					{
						if (Player[playerid][GameGold] < 100) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: У вас нет 100 рублей");
				        Player[playerid][GameGold] -= 100.0;Player[playerid][Banned] = 0; strmid(BannedBy[playerid], "ПУСТО", 0, strlen("ПУСТО"), 5); strmid(BanReason[playerid], "ПУСТО", 0, strlen("ПУСТО"), 5);
						SavePlayer(playerid);LSpawnPlayer(playerid);
				        new pname[25], String[120];GetPlayerName(playerid,pname,sizeof(pname));format(String,sizeof(String),"{AFAFAF}SERVER: %s[%d] купил разбан за 100 рублей",pname,playerid);
				        PlayerWeather[playerid] = -1;SendClientMessageToAll(COLOR_YELLOW,String);
				        format(String, sizeof String, "%d.%d.%d в %d:%d:%d |   SHOP: %s[%d] приобрел разбан за 100 рублей", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid);
						WriteLog("GlobalLog", String);WriteLog("Shop", String);
			        }
			        else
			        {
			            if (Player[playerid][GameGold] < 250) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: У вас нет 250 рублей");
				        Player[playerid][GameGold] -= 250.0;Player[playerid][Banned] = 0; strmid(BannedBy[playerid], "ПУСТО", 0, strlen("ПУСТО"), 5); strmid(BanReason[playerid], "ПУСТО", 0, strlen("ПУСТО"), 5);
						SavePlayer(playerid);LSpawnPlayer(playerid);
				        new pname[25], String[120];GetPlayerName(playerid,pname,sizeof(pname));format(String,sizeof(String),"{AFAFAF}SERVER: %s[%d] купил разбан за 250 рублей",pname,playerid);
				        PlayerWeather[playerid] = -1;SendClientMessageToAll(COLOR_YELLOW,String);
				        format(String, sizeof String, "%d.%d.%d в %d:%d:%d |   SHOP: %s[%d] приобрел разбан за 250 рублей", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid);
						WriteLog("GlobalLog", String);WriteLog("Shop", String);
			        }
				}
							    

				if(listitem == 0)//где взять GG
			    {
			        new StringX[1024];
			        format(StringX,sizeof(StringX),"{FFFFFF}Виртуальные (игровые) рубли приобретаются за реальные.\n");
			        strcat(StringX, "{FFCC00}Курс на сегодня: {FFFFFF} 1 виртуальный рубль = 1 реальный рубль\n\n");
                    strcat(StringX, "{007FFF}За покупкой обращайся к главному администратору.");
                    strcat(StringX, "\n{FFFFFF}Вконтакте: {AFAFAF}Не указано");
                    strcat(StringX, "\n{FFFFFF}Skype: {AFAFAF}Не указано");
			        ShowPlayerDialog(playerid, 666, 0, "Получить GameGold", StringX, "ОК", "");
				} else return SendCommand(playerid, "/shop", "");
			}//response
		}//GGSHOP
		
		case DIALOG_SKILLS:
		{//SKILLS
		    if(response)
			{//response
			    if(listitem == 0)//RegenHP
			    {
			        if (Player[playerid][SkillHP] >= 50) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вы уже прокачали этот навык до максимума.");
			        if (Player[playerid][Cash] < 1000000) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вам нужно 1 000 000$ чтобы прокачать этот навык.");
			        Player[playerid][Cash] -= 1000000;Player[playerid][SkillHP] += 1;
			        SendClientMessage(playerid,COLOR_YELLOW,"Вы успешно повысили уровень навыка <<{FFFFFF}Регенерация HP{FFFF00}>>.");
			        SendClientMessage(playerid,COLOR_CYAN,"Подсказка: Чем выше уровень этого навыка, тем быстрее восстанавливается здоровье.");
			    }
			    if(listitem == 1)//Repair
			    {
			        if (Player[playerid][SkillRepair] >= 30) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вы уже прокачали этот навык до максимума.");
			        if (Player[playerid][Cash] < 1000000) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вам нужно 1 000 000$ чтобы прокачать этот навык.");
			        Player[playerid][Cash] -= 1000000;Player[playerid][SkillRepair] += 1;
			        SendClientMessage(playerid,COLOR_YELLOW,"Вы успешно повысили уровень навыка <<{FFFFFF}Ремонт транспорта{FFFF00}>>.");
			        SendClientMessage(playerid,COLOR_CYAN,"Подсказка: Чем выше уровень этого навыка, тем чаще ремонтируется транспорт.");
			    }
			    new String[300], StringF[500];
				format(String,sizeof(String),"{FFFFFF}[{FFFF00}%d{FFFFFF}/50] Регенерация HP (1 000 000$)\n[{FFFF00}%d{FFFFFF}/30] Ремонт транспорта (1 000 000$)",Player[playerid][SkillHP], Player[playerid][SkillRepair]);
				strcat(StringF,String);
				ShowPlayerDialog(playerid, DIALOG_SKILLS, 2, "Пассивные навыки", StringF, "ОК", "");
			}//респонс
		}//Skills
		
		case DIALOG_CLANENTER:
		{//вступить в клан
			if(response)
			{//респорс
			    new Free = 0, clanid = InviteClan[playerid];
				if(!strcmp(Clan[clanid][cMember1], "Пусто", true)){Free = 1; strmid(Clan[clanid][cMember1], PlayerName[playerid], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);}
				if(!strcmp(Clan[clanid][cMember2], "Пусто", true)){if(Free == 0){Free = 2;strmid(Clan[clanid][cMember2], PlayerName[playerid], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);}}
				if(!strcmp(Clan[clanid][cMember3], "Пусто", true)){if(Free == 0){Free = 3;strmid(Clan[clanid][cMember3], PlayerName[playerid], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);}}
				if(!strcmp(Clan[clanid][cMember4], "Пусто", true)){if(Free == 0){Free = 4;strmid(Clan[clanid][cMember4], PlayerName[playerid], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);}}
				if(!strcmp(Clan[clanid][cMember5], "Пусто", true)){if(Free == 0){Free = 5;strmid(Clan[clanid][cMember5], PlayerName[playerid], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);}}
				if(!strcmp(Clan[clanid][cMember6], "Пусто", true)){if(Free == 0){Free = 6;strmid(Clan[clanid][cMember6], PlayerName[playerid], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);}}
				if(!strcmp(Clan[clanid][cMember7], "Пусто", true)){if(Free == 0){Free = 7;strmid(Clan[clanid][cMember7], PlayerName[playerid], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);}}
				if(!strcmp(Clan[clanid][cMember8], "Пусто", true)){if(Free == 0){Free = 8;strmid(Clan[clanid][cMember8], PlayerName[playerid], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);}}
				if(!strcmp(Clan[clanid][cMember9], "Пусто", true)){if(Free == 0){Free = 9;strmid(Clan[clanid][cMember9], PlayerName[playerid], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);}}
				if(!strcmp(Clan[clanid][cMember10], "Пусто", true)){if(Free == 0){Free = 10;strmid(Clan[clanid][cMember10], PlayerName[playerid], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);}}
				if(!strcmp(Clan[clanid][cMember11], "Пусто", true)){if(Free == 0){Free = 11;strmid(Clan[clanid][cMember11], PlayerName[playerid], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);}}
				if(!strcmp(Clan[clanid][cMember12], "Пусто", true)){if(Free == 0){Free = 12;strmid(Clan[clanid][cMember12], PlayerName[playerid], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);}}
				if(!strcmp(Clan[clanid][cMember13], "Пусто", true)){if(Free == 0){Free = 13;strmid(Clan[clanid][cMember13], PlayerName[playerid], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);}}
				if(!strcmp(Clan[clanid][cMember14], "Пусто", true)){if(Free == 0){Free = 14;strmid(Clan[clanid][cMember14], PlayerName[playerid], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);}}
				if(!strcmp(Clan[clanid][cMember15], "Пусто", true)){if(Free == 0){Free = 15;strmid(Clan[clanid][cMember15], PlayerName[playerid], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);}}
				if(!strcmp(Clan[clanid][cMember16], "Пусто", true)){if(Free == 0){Free = 16;strmid(Clan[clanid][cMember16], PlayerName[playerid], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);}}
				if(!strcmp(Clan[clanid][cMember17], "Пусто", true)){if(Free == 0){Free = 17;strmid(Clan[clanid][cMember17], PlayerName[playerid], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);}}
				if(!strcmp(Clan[clanid][cMember18], "Пусто", true)){if(Free == 0){Free = 18;strmid(Clan[clanid][cMember18], PlayerName[playerid], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);}}
				if(!strcmp(Clan[clanid][cMember19], "Пусто", true)){if(Free == 0){Free = 19;strmid(Clan[clanid][cMember19], PlayerName[playerid], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);}}
				if(!strcmp(Clan[clanid][cMember20], "Пусто", true)){if(Free == 0){Free = 20;strmid(Clan[clanid][cMember20], PlayerName[playerid], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);}}

				if (Free == 0){SendClientMessage(playerid,COLOR_RED,"ОШИБКА: В клане нет места."); return 1;}
				Player[playerid][MyClan] = InviteClan[playerid];Player[playerid][Member] = Free;Player[playerid][Leader] = 0;
				SavePlayer(playerid); SaveClan(clanid); InviteTime[playerid] = -1;
				new StringC[140], ccolor = Clan[clanid][cColor]; PlayerColor[playerid] = ccolor;
				format(StringC,sizeof(StringC),"Игрок %s[%d] вступил в клан.",PlayerName[playerid],playerid);
				foreach(Player, cid)
				{//цикл
					if (Player[cid][MyClan] != 0 && Player[cid][MyClan] == Player[playerid][MyClan]) SendClientMessage(cid, ClanColor[ccolor], StringC);
				}
			}//респонс
			else{InviteTime[playerid] = -1;}//Если игрок отказался это нужно, чтобы ему не вылазало окошна "Вас пригласили в клан, но вы не успели принять приглашение"
		}//вступить в клан
		
		case DIALOG_CLANMESSAGE:
		{//сообщение клана
			if(response)
			{//респонс
			    if (strlen(inputtext) < 3 || strlen(inputtext) > 120) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Длина сообщения должна быть от 3 до 120 символов");
                new clanid = Player[playerid][MyClan], ccolor = Clan[clanid][cColor];
				strmid(Clan[clanid][cMessage], inputtext, 0, strlen(inputtext), 120); SaveClan(clanid);
				if(!strcmp(inputtext, "ПУСТО", true)) return SendClientMessage(playerid,COLOR_YELLOW,"Сообщение клана удалено.");
				else
				{//новое сообщение клана
	 				format(inputtext, 140, "СООБЩЕНИЕ КЛАНА:{FFFFFF} %s", inputtext);
					foreach(Player, cid)
					{//цикл
						if (Player[cid][MyClan] != 0 && Player[cid][MyClan] == Player[playerid][MyClan] && Logged[cid] == 1 ) SendClientMessage(cid, ClanColor[ccolor], inputtext);
					}
				}//новое сообщение клана
			}//респонс
		}//сообщение клана

		case DIALOG_SKILLCHANGE:
		{//Выбор активных навыков
		    if (!response) return 1;
		    if (listitem == 0)
		    {//Изменить скилл персонажа
		        new StringF[600];
		        strcat(StringF, "Нет\n");
		        strcat(StringF, "[{FFFF00}500 000${FFFFFF}] Телепорт на 50 метров (Престиж 1, уровень 10)\n");
		        strcat(StringF, "[{FFFF00}500 000${FFFFFF}] Телепорт на 100 метров (Престиж 1, уровень 20)\n");
		        strcat(StringF, "[{FFFF00}500 000${FFFFFF}] Телепорт на 200 метров (Престиж 1, уровень 53)\n");
		        strcat(StringF, "[{FFFF00}1 000 000${FFFFFF}] Режим Супермена (Престиж 8, уровень 25)");
	            ShowPlayerDialog(playerid, DIALOG_ACTIVESKILLPERSON, 2, "Навык Персонажа", StringF, "ОК", "Отмена");
		    }//Изменить скилл персонажа
		    else if (listitem == 1)
		    {//Изменить скилл класса 1
		        new StringF[300];
		        strcat(StringF, "Нет\n");
		        strcat(StringF, "[{FFFF00}500 000${FFFFFF}] Разворот на 180 градусов (Уровень 56)\n");
		        strcat(StringF, "[{FFFF00}500 000${FFFFFF}] Прыжок (Уровень 61)\n");
		        strcat(StringF, "[{FFFF00}500 000${FFFFFF}] Трамплин (Уровень 63)");
				ShowPlayerDialog(playerid, DIALOG_ACTIVESKILLCAR1, 2, "Навык Класса 1 (Клавиша '2')", StringF, "ОК", "Отмена");
		    }//Изменить скилл класса 1
		    else if (listitem == 2)
		    {//Изменить скилл класса 2
		        new StringF[300];
		        strcat(StringF, "Нет\n");
		        strcat(StringF, "[{FFFF00}500 000${FFFFFF}] Разворот на 180 градусов (Уровень 59)\n");
		        strcat(StringF, "[{FFFF00}500 000${FFFFFF}] Прыжок (Уровень 62)\n");
		        strcat(StringF, "[{FFFF00}500 000${FFFFFF}] Трамплин (Уровень 64)");
				ShowPlayerDialog(playerid, DIALOG_ACTIVESKILLCAR2, 2, "Навык Класса 2 (Клавиша '2')", StringF, "ОК", "Отмена");
		    }//Изменить скилл класса 2
		    else if (listitem == 3)
		    {//Изменить H скилл класса 1
		        new StringF[1024];
		        strcat(StringF, "Нет\n");
		        strcat(StringF, "[{FFFF00}500 000${FFFFFF}] Переворот транспорта на колеса (Уровень 51)\n");
		        strcat(StringF, "[{FFFF00}500 000${FFFFFF}] Телепорт на 50 метров (Престиж 1, уровень 35)\n");
		        strcat(StringF, "[{FFFF00}500 000${FFFFFF}] Телепорт на 100 метров (Престиж 1, уровень 40)\n");
		        strcat(StringF, "[{FFFF00}500 000${FFFFFF}] Телепорт на 200 метров (Престиж 1, уровень 45)\n");
		        strcat(StringF, "[{FFFF00}1 000 000${FFFFFF}] Телепорт на 50 метров cо скоростью (Престиж 1, уровень 55)\n");
		        strcat(StringF, "[{FFFF00}1 000 000${FFFFFF}] Телепорт на 100 метров cо скоростью (Престиж 1, уровень 60)\n");
		        strcat(StringF, "[{FFFF00}1 000 000${FFFFFF}] Телепорт на 200 метров cо скоростью (Престиж 1, уровень 65)\n");
		        strcat(StringF, "[{FFFF00}1 000 000${FFFFFF}] Режим Полета (Престиж 2, уровень 25)\n");
				ShowPlayerDialog(playerid, DIALOG_ACTIVESKILLHCAR1, 2, "Навык Класса 1 (Клавиша 'H')", StringF, "ОК", "Отмена");
		    }//Изменить скилл класса 1
		    else if (listitem == 4)
		    {//Изменить H скилл класса 2
		        new StringF[1024];
		        strcat(StringF, "Нет\n");
		        strcat(StringF, "[{FFFF00}500 000${FFFFFF}] Переворот транспорта на колеса (Уровень 51)\n");
		        strcat(StringF, "[{FFFF00}500 000${FFFFFF}] Телепорт на 50 метров (Престиж 1, уровень 35)\n");
		        strcat(StringF, "[{FFFF00}500 000${FFFFFF}] Телепорт на 100 метров (Престиж 1, уровень 40)\n");
		        strcat(StringF, "[{FFFF00}500 000${FFFFFF}] Телепорт на 200 метров (Престиж 1, уровень 45)\n");
		        strcat(StringF, "[{FFFF00}1 000 000${FFFFFF}] Телепорт на 50 метров cо скоростью (Престиж 1, уровень 55)\n");
		        strcat(StringF, "[{FFFF00}1 000 000${FFFFFF}] Телепорт на 100 метров cо скоростью (Престиж 1, уровень 60)\n");
		        strcat(StringF, "[{FFFF00}1 000 000${FFFFFF}] Телепорт на 200 метров cо скоростью (Престиж 1, уровень 65)\n");
		        strcat(StringF, "[{FFFF00}1 000 000${FFFFFF}] Режим Полета (Престиж 2, уровень 25)\n");
				ShowPlayerDialog(playerid, DIALOG_ACTIVESKILLHCAR2, 2, "Навык Класса 2 (Клавиша 'H')", StringF, "ОК", "Отмена");
		    }//Изменить скилл класса 2
		    else if (listitem == 5)
		    {//Пассивные навыки
		      	new String[300], StringF[500];
				format(String,sizeof(String),"{FFFFFF}[{FFFF00}%d{FFFFFF}/50] Регенерация HP (1 000 000$)\n[{FFFF00}%d{FFFFFF}/30] Ремонт транспорта (1 000 000$)",Player[playerid][SkillHP], Player[playerid][SkillRepair]);
				strcat(StringF,String);
				ShowPlayerDialog(playerid, DIALOG_SKILLS, 2, "Пассивные навыки", StringF, "ОК", "Отмена");
		    }//Пассивные навыки
		    return 1;
		}//Выбор активных навыков
		
		case DIALOG_ACTIVESKILLPERSON:
		{//Выбор скилла персонажа
		    if (!response) return 1;
		    if (listitem == Player[playerid][ActiveSkillPerson]) return 1; //Игрок выбрал навык, который итак уже выбран
			if (listitem == 0) {Player[playerid][ActiveSkillPerson] = 0; return 1;}//Убрать навык
			if (listitem == 1)
		    {//тп на 50 метров
		        if (Player[playerid][Prestige] < 1) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 1-го уровня Престижа!");
		        if (Player[playerid][Level] < 10) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 10-го уровня!");
		        if (Player[playerid][Cash] < 500000) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вам нужно 500 000$ чтобы выбрать этот навык!");
		        Player[playerid][Cash] -= 500000; Player[playerid][ActiveSkillPerson] = listitem;
		        if (OnFly[playerid] == 1) StopFly(playerid);
		        return SendClientMessage(playerid, COLOR_YELLOW, "Ваш новый навык персонажа: {FFFFFF}Телепорт на 50 метров");
		    }//тп на 50 метров
		    if (listitem == 2)
		    {//тп на 100 метров
		        if (Player[playerid][Prestige] < 1) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 1-го уровня Престижа!");
		        if (Player[playerid][Level] < 20) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 20-го уровня!");
		        if (Player[playerid][Cash] < 500000) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вам нужно 500 000$ чтобы выбрать этот навык!");
		        Player[playerid][Cash] -= 500000; Player[playerid][ActiveSkillPerson] = listitem;
		        return SendClientMessage(playerid, COLOR_YELLOW, "Ваш новый навык персонажа: {FFFFFF}Телепорт на 100 метров");
		    }//тп на 100 метров
		    if (listitem == 3)
		    {//тп на 200 метров
		        if (Player[playerid][Prestige] < 1) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 1-го уровня Престижа!");
		        if (Player[playerid][Level] < 53) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 53-го уровня!");
		        if (Player[playerid][Cash] < 500000) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вам нужно 500 000$ чтобы выбрать этот навык!");
		        Player[playerid][Cash] -= 500000; Player[playerid][ActiveSkillPerson] = listitem;
                if (OnFly[playerid] == 1) StopFly(playerid);
				return SendClientMessage(playerid, COLOR_YELLOW, "Ваш новый навык персонажа: {FFFFFF}Телепорт на 200 метров");
		    }//тп на 200 метров
		    if (listitem == 4)
		    {//Режим Супермена
		        if (Player[playerid][Prestige] < 8) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 8-го уровня Престижа!");
		        if (Player[playerid][Level] < 25) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 25-го уровня!");
		        if (Player[playerid][Cash] < 1000000) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вам нужен 1 000 000$ чтобы выбрать этот навык!");
		        Player[playerid][Cash] -= 1000000; Player[playerid][ActiveSkillPerson] = listitem;
                if (OnFly[playerid] == 1) StopFly(playerid);
				return SendClientMessage(playerid, COLOR_YELLOW, "Ваш новый навык персонажа: {FFFFFF}Режим Супермена");
		    }//Режим Супермена
		    return 1;
		}//Выбор скилла персонажа
		
		case DIALOG_ACTIVESKILLCAR1:
		{//Выбор скилла класс 1 (клавиша 2)
		    if (!response) return 1;
		    if (listitem == Player[playerid][ActiveSkillCar1]) return 1; //Игрок выбрал навык, который итак уже выбран
			if (listitem == 0) {Player[playerid][ActiveSkillCar1] = 0; return 1;}//Убрать навык
			if (listitem == 1)
		    {//Разворот на 180 градусов
		        if (Player[playerid][Level] < 56) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 56-го уровня!");
		        if (Player[playerid][Cash] < 500000) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вам нужно 500 000$ чтобы выбрать этот навык!");
		        Player[playerid][Cash] -= 500000; Player[playerid][ActiveSkillCar1] = listitem;
		        return SendClientMessage(playerid, COLOR_YELLOW, "Ваш новый навык класса 1 (Клавиша '2'): {FFFFFF}Разворот на 180 градусов");
		    }//Разворот на 180 градусов
		    if (listitem == 2)
		    {//Прыжок
		        if (Player[playerid][Level] < 61) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 61-го уровня!");
		        if (Player[playerid][Cash] < 500000) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вам нужно 500 000$ чтобы выбрать этот навык!");
		        Player[playerid][Cash] -= 500000; Player[playerid][ActiveSkillCar1] = listitem;
		        return SendClientMessage(playerid, COLOR_YELLOW, "Ваш новый навык класса 1 (Клавиша '2'): {FFFFFF}Прыжок");
		    }//Прыжок
		    if (listitem == 3)
		    {//Трамплин
		        if (Player[playerid][Level] < 63) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 63-го уровня!");
		        if (Player[playerid][Cash] < 500000) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вам нужно 500 000$ чтобы выбрать этот навык!");
		        Player[playerid][Cash] -= 500000; Player[playerid][ActiveSkillCar1] = listitem;
		        return SendClientMessage(playerid, COLOR_YELLOW, "Ваш новый навык класса 1 (Клавиша '2'): {FFFFFF}Трамплин");
		    }//Трамплин
		    return 1;
		}//Выбор скилла класс 1 (клавиша 2)
		
		case DIALOG_ACTIVESKILLCAR2:
		{//Выбор скилла класс 2 (клавиша 2)
		    if (!response) return 1;
		    if (listitem == Player[playerid][ActiveSkillCar2]) return 1; //Игрок выбрал навык, который итак уже выбран
			if (listitem == 0) {Player[playerid][ActiveSkillCar2] = 0; return 1;}//Убрать навык
			if (listitem == 1)
		    {//Разворот на 180 градусов
		        if (Player[playerid][Level] < 59) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 59-го уровня!");
		        if (Player[playerid][Cash] < 500000) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вам нужно 500 000$ чтобы выбрать этот навык!");
		        Player[playerid][Cash] -= 500000; Player[playerid][ActiveSkillCar2] = listitem;
		        return SendClientMessage(playerid, COLOR_YELLOW, "Ваш новый навык класса 2 (Клавиша '2'): {FFFFFF}Разворот на 180 градусов");
		    }//Разворот на 180 градусов
		    if (listitem == 2)
		    {//Прыжок
		        if (Player[playerid][Level] < 62) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 62-го уровня!");
		        if (Player[playerid][Cash] < 500000) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вам нужно 500 000$ чтобы выбрать этот навык!");
		        Player[playerid][Cash] -= 500000; Player[playerid][ActiveSkillCar2] = listitem;
		        return SendClientMessage(playerid, COLOR_YELLOW, "Ваш новый навык класса 2 (Клавиша '2'): {FFFFFF}Прыжок");
		    }//Прыжок
		    if (listitem == 3)
		    {//Трамплин
		        if (Player[playerid][Level] < 64) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 64-го уровня!");
		        if (Player[playerid][Cash] < 500000) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вам нужно 500 000$ чтобы выбрать этот навык!");
		        Player[playerid][Cash] -= 500000; Player[playerid][ActiveSkillCar2] = listitem;
		        return SendClientMessage(playerid, COLOR_YELLOW, "Ваш новый навык класса 2 (Клавиша '2'): {FFFFFF}Трамплин");
		    }//Трамплин
		    return 1;
		}//Выбор скилла класс 2 (клавиша 2)
		
		case DIALOG_ACTIVESKILLHCAR1:
		{//Выбор скилла класс 1 (клавиша H)
		    if (!response) return 1;
		    if (listitem == Player[playerid][ActiveSkillHCar1]) return 1; //Игрок выбрал навык, который итак уже выбран
			if (listitem == 0) {Player[playerid][ActiveSkillHCar1] = 0; return 1;}//Убрать навык
			if (listitem == 1)
		    {//Переворот транспорта на колеса
		        if (Player[playerid][Level] < 51) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 51-го уровня!");
		        if (Player[playerid][Cash] < 500000) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вам нужно 500 000$ чтобы выбрать этот навык!");
		        Player[playerid][Cash] -= 500000; Player[playerid][ActiveSkillHCar1] = listitem;
				if (OnVehFly[playerid] == 1) StopVehFly(playerid);
				return SendClientMessage(playerid, COLOR_YELLOW, "Ваш новый навык класса 1 (Клавиша 'H'): {FFFFFF}Переворот транспорта на колеса");
		    }//Переворот транспорта на колеса
		    if (listitem == 2)
		    {//Телепорт на 50 метров
		        if (Player[playerid][Prestige] < 1) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 1-го уровня Престижа!");
		        if (Player[playerid][Level] < 35) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 35-го уровня!");
		        if (Player[playerid][Cash] < 500000) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вам нужно 500 000$ чтобы выбрать этот навык!");
		        Player[playerid][Cash] -= 500000; Player[playerid][ActiveSkillHCar1] = listitem;
                if (OnVehFly[playerid] == 1) StopVehFly(playerid);
				return SendClientMessage(playerid, COLOR_YELLOW, "Ваш новый навык класса 1 (Клавиша 'H'): {FFFFFF}Телепорт на 50 метров");
		    }//Телепорт на 50 метров
		    if (listitem == 3)
		    {//Телепорт на 100 метров
		        if (Player[playerid][Prestige] < 1) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 1-го уровня Престижа!");
		        if (Player[playerid][Level] < 40) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 40-го уровня!");
		        if (Player[playerid][Cash] < 500000) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вам нужно 500 000$ чтобы выбрать этот навык!");
		        Player[playerid][Cash] -= 500000; Player[playerid][ActiveSkillHCar1] = listitem;
                if (OnVehFly[playerid] == 1) StopVehFly(playerid);
				return SendClientMessage(playerid, COLOR_YELLOW, "Ваш новый навык класса 1 (Клавиша 'H'): {FFFFFF}Телепорт на 100 метров");
		    }//Телепорт на 100 метров
		    if (listitem == 4)
		    {//Телепорт на 200 метров
		        if (Player[playerid][Prestige] < 1) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 1-го уровня Престижа!");
		        if (Player[playerid][Level] < 45) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 45-го уровня!");
		        if (Player[playerid][Cash] < 500000) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вам нужно 500 000$ чтобы выбрать этот навык!");
		        Player[playerid][Cash] -= 500000; Player[playerid][ActiveSkillHCar1] = listitem;
                if (OnVehFly[playerid] == 1) StopVehFly(playerid);
				return SendClientMessage(playerid, COLOR_YELLOW, "Ваш новый навык класса 1 (Клавиша 'H'): {FFFFFF}Телепорт на 200 метров");
		    }//Телепорт на 200 метров
		    if (listitem == 5)
		    {//Телепорт на 50 метров со скоростью
		        if (Player[playerid][Prestige] < 1) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 1-го уровня Престижа!");
		        if (Player[playerid][Level] < 55) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 55-го уровня!");
		        if (Player[playerid][Cash] < 1000000) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вам нужно 1 000 000$ чтобы выбрать этот навык!");
		        Player[playerid][Cash] -= 1000000; Player[playerid][ActiveSkillHCar1] = listitem;
                if (OnVehFly[playerid] == 1) StopVehFly(playerid);
				return SendClientMessage(playerid, COLOR_YELLOW, "Ваш новый навык класса 1 (Клавиша 'H'): {FFFFFF}Телепорт на 50 метров (со скоростью)");
		    }//Телепорт на 50 метров со скоростью
		    if (listitem == 6)
		    {//Телепорт на 100 метров со скоростью
		        if (Player[playerid][Prestige] < 1) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 1-го уровня Престижа!");
		        if (Player[playerid][Level] < 60) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 60-го уровня!");
		        if (Player[playerid][Cash] < 1000000) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вам нужно 1 000 000$ чтобы выбрать этот навык!");
		        Player[playerid][Cash] -= 1000000; Player[playerid][ActiveSkillHCar1] = listitem;
                if (OnVehFly[playerid] == 1) StopVehFly(playerid);
				return SendClientMessage(playerid, COLOR_YELLOW, "Ваш новый навык класса 1 (Клавиша 'H'): {FFFFFF}Телепорт на 100 метров (со скоростью)");
		    }//Телепорт на 100 метров со скоростью
		    if (listitem == 7)
		    {//Телепорт на 200 метров со скоростью
		        if (Player[playerid][Prestige] < 1) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 1-го уровня Престижа!");
		        if (Player[playerid][Level] < 65) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 65-го уровня!");
		        if (Player[playerid][Cash] < 1000000) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вам нужно 1 000 000$ чтобы выбрать этот навык!");
		        Player[playerid][Cash] -= 1000000; Player[playerid][ActiveSkillHCar1] = listitem;
                if (OnVehFly[playerid] == 1) StopVehFly(playerid);
				return SendClientMessage(playerid, COLOR_YELLOW, "Ваш новый навык класса 1 (Клавиша 'H'): {FFFFFF}Телепорт на 200 метров (со скоростью)");
		    }//Телепорт на 200 метров со скоростью
		    if (listitem == 8)
		    {//Режим Полета
		        if (Player[playerid][Prestige] < 2) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 2-го уровня Престижа!");
		        if (Player[playerid][Level] < 25) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 25-го уровня!");
		        if (Player[playerid][Cash] < 1000000) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вам нужно 1 000 000$ чтобы выбрать этот навык!");
		        Player[playerid][Cash] -= 1000000; Player[playerid][ActiveSkillHCar1] = listitem;
				return SendClientMessage(playerid, COLOR_YELLOW, "Ваш новый навык класса 1 (Клавиша 'H'): {FFFFFF}Режим Полета");
		    }//Режим Полета
		    return 1;
		}//Выбор скилла класс 1 (клавиша H)
		
		case DIALOG_ACTIVESKILLHCAR2:
		{//Выбор скилла класс 2 (клавиша H)
		    if (!response) return 1;
		    if (listitem == Player[playerid][ActiveSkillHCar2]) return 1; //Игрок выбрал навык, который итак уже выбран
			if (listitem == 0) {Player[playerid][ActiveSkillHCar2] = 0; return 1;}//Убрать навык
			if (listitem == 1)
		    {//Переворот транспорта на колеса
		        if (Player[playerid][Level] < 51) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 51-го уровня!");
		        if (Player[playerid][Cash] < 500000) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вам нужно 500 000$ чтобы выбрать этот навык!");
		        Player[playerid][Cash] -= 500000; Player[playerid][ActiveSkillHCar2] = listitem;
                if (OnVehFly[playerid] == 1) StopVehFly(playerid);
				return SendClientMessage(playerid, COLOR_YELLOW, "Ваш новый навык класса 2 (Клавиша 'H'): {FFFFFF}Переворот транспорта на колеса");
		    }//Переворот транспорта на колеса
		    if (listitem == 2)
		    {//Телепорт на 50 метров
		        if (Player[playerid][Prestige] < 1) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 1-го уровня Престижа!");
		        if (Player[playerid][Level] < 35) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 35-го уровня!");
		        if (Player[playerid][Cash] < 500000) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вам нужно 500 000$ чтобы выбрать этот навык!");
		        Player[playerid][Cash] -= 500000; Player[playerid][ActiveSkillHCar2] = listitem;
                if (OnVehFly[playerid] == 1) StopVehFly(playerid);
				return SendClientMessage(playerid, COLOR_YELLOW, "Ваш новый навык класса 2 (Клавиша 'H'): {FFFFFF}Телепорт на 50 метров");
		    }//Телепорт на 50 метров
		    if (listitem == 3)
		    {//Телепорт на 100 метров
		        if (Player[playerid][Prestige] < 1) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 1-го уровня Престижа!");
		        if (Player[playerid][Level] < 40) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 40-го уровня!");
		        if (Player[playerid][Cash] < 500000) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вам нужно 500 000$ чтобы выбрать этот навык!");
		        Player[playerid][Cash] -= 500000; Player[playerid][ActiveSkillHCar2] = listitem;
                if (OnVehFly[playerid] == 1) StopVehFly(playerid);
				return SendClientMessage(playerid, COLOR_YELLOW, "Ваш новый навык класса 2 (Клавиша 'H'): {FFFFFF}Телепорт на 100 метров");
		    }//Телепорт на 100 метров
		    if (listitem == 4)
		    {//Телепорт на 200 метров
		        if (Player[playerid][Prestige] < 1) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 1-го уровня Престижа!");
		        if (Player[playerid][Level] < 45) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 45-го уровня!");
		        if (Player[playerid][Cash] < 500000) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вам нужно 500 000$ чтобы выбрать этот навык!");
		        Player[playerid][Cash] -= 500000; Player[playerid][ActiveSkillHCar2] = listitem;
                if (OnVehFly[playerid] == 1) StopVehFly(playerid);
				return SendClientMessage(playerid, COLOR_YELLOW, "Ваш новый навык класса 2 (Клавиша 'H'): {FFFFFF}Телепорт на 200 метров");
		    }//Телепорт на 200 метров
		    if (listitem == 5)
		    {//Телепорт на 50 метров со скоростью
		        if (Player[playerid][Prestige] < 1) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 1-го уровня Престижа!");
		        if (Player[playerid][Level] < 55) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 55-го уровня!");
		        if (Player[playerid][Cash] < 1000000) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вам нужно 1 000 000$ чтобы выбрать этот навык!");
		        Player[playerid][Cash] -= 1000000; Player[playerid][ActiveSkillHCar2] = listitem;
                if (OnVehFly[playerid] == 1) StopVehFly(playerid);
				return SendClientMessage(playerid, COLOR_YELLOW, "Ваш новый навык класса 2 (Клавиша 'H'): {FFFFFF}Телепорт на 50 метров (со скоростью)");
		    }//Телепорт на 50 метров со скоростью
		    if (listitem == 6)
		    {//Телепорт на 100 метров со скоростью
		        if (Player[playerid][Prestige] < 1) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 1-го уровня Престижа!");
		        if (Player[playerid][Level] < 60) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 60-го уровня!");
		        if (Player[playerid][Cash] < 1000000) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вам нужно 1 000 000$ чтобы выбрать этот навык!");
		        Player[playerid][Cash] -= 1000000; Player[playerid][ActiveSkillHCar2] = listitem;
                if (OnVehFly[playerid] == 1) StopVehFly(playerid);
				return SendClientMessage(playerid, COLOR_YELLOW, "Ваш новый навык класса 2 (Клавиша 'H'): {FFFFFF}Телепорт на 100 метров (со скоростью)");
		    }//Телепорт на 100 метров со скоростью
		    if (listitem == 7)
		    {//Телепорт на 200 метров со скоростью
		        if (Player[playerid][Prestige] < 1) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 1-го уровня Престижа!");
		        if (Player[playerid][Level] < 65) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 65-го уровня!");
		        if (Player[playerid][Cash] < 1000000) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вам нужно 1 000 000$ чтобы выбрать этот навык!");
		        Player[playerid][Cash] -= 1000000; Player[playerid][ActiveSkillHCar2] = listitem;
                if (OnVehFly[playerid] == 1) StopVehFly(playerid);
				return SendClientMessage(playerid, COLOR_YELLOW, "Ваш новый навык класса 2 (Клавиша 'H'): {FFFFFF}Телепорт на 200 метров (со скоростью)");
		    }//Телепорт на 200 метров со скоростью
		    if (listitem == 8)
		    {//Режим Полета
		        if (Player[playerid][Prestige] < 2) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 2-го уровня Престижа!");
		        if (Player[playerid][Level] < 25) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы должны быть как минимум 25-го уровня!");
		        if (Player[playerid][Cash] < 1000000) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вам нужно 1 000 000$ чтобы выбрать этот навык!");
		        Player[playerid][Cash] -= 1000000; Player[playerid][ActiveSkillHCar2] = listitem;
		        return SendClientMessage(playerid, COLOR_YELLOW, "Ваш новый навык класса 2 (Клавиша 'H'): {FFFFFF}Режим Полета");
		    }//Режим Полета
		    return 1;
		}//Выбор скилла класс 2 (клавиша H)
		
		case DIALOG_PAINTJOB:
		{//Выбор PaintJob
			if(response)
			{//респонс
			    Player[playerid][CarSlot2PaintJob] = listitem;
			}//респонс
			else{Player[playerid][CarSlot2PaintJob] = 0;}
  			new mid = Player[playerid][CarSlot2] - 400, String[120];format(String,sizeof(String),"Ваш новый автомобиль 2-го класса - %s (PaintJob №%d)", PlayerVehicleName[mid],Player[playerid][CarSlot2PaintJob] + 1);
			SendClientMessage(playerid,COLOR_YELLOW,String);
			SendClientMessage(playerid,COLOR_YELLOW,"Вы потратили на него 100000$");
		}//Выбор PaintJob
		
		case DIALOG_PRESTIGE:
		{//Престиж
			if(response)
			{//респорс
			    	Player[playerid][Level] = 1;
					Player[playerid][Exp] = 0;
					Player[playerid][Spawn] = 0;
					Player[playerid][SpawnStyle] = 0;
					Player[playerid][Invisible] = 0;
					Player[playerid][BuddhaTime] = 0;
					Player[playerid][Slot1] = 0;
					Player[playerid][Slot2] = 0;
					Player[playerid][Slot3] = 0;
					Player[playerid][Slot4] = 0;
					Player[playerid][Slot5] = 0;
					Player[playerid][Slot6] = 0;
					Player[playerid][Slot7] = 0;
					Player[playerid][Slot8] = 0;
					Player[playerid][Slot9] = 0;
					Player[playerid][Slot10] = 0;
					Player[playerid][CarSlot1] = 462;//Faggio
					Player[playerid][CarSlot2] = 0;
					Player[playerid][CarSlot3] = 0;
					Player[playerid][SkillHP] = 0;
					Player[playerid][SkillRepair] = 0;
					Player[playerid][ActiveSkillPerson] = 0;
					Player[playerid][ActiveSkillCar1] = 0;
					Player[playerid][ActiveSkillCar2] = 0;
					Player[playerid][ActiveSkillHCar1] = 0;
					Player[playerid][ActiveSkillHCar2] = 0;
					NeedXP[playerid] = Levels[1];
					
					Player[playerid][Prestige] += 1; Player[playerid][Medals] -= 10;
					new String[140];format(String,sizeof(String), "SERVER: %s[%d] достиг {FFFFFF}%d{FFFF00}-го уровня Престижа! Поздравьте его!",PlayerName[playerid], playerid, Player[playerid][Prestige]);
					SendClientMessageToAll(COLOR_YELLOW, String);

					if (Player[playerid][Prestige] == 3) SendClientMessage(playerid,COLOR_YELLOW,"PRESTIGE 3: {FFFFFF}Разноцветный ник в чате (команда '/chatname') теперь доступен.");
					if (Player[playerid][Prestige] == 4) SendClientMessage(playerid,COLOR_YELLOW,"PRESTIGE 4: {FFFFFF}Неон теперь доступен в автомастерской TurboSpeed.");
					if (Player[playerid][Prestige] == 5) SendClientMessage(playerid,COLOR_YELLOW, "{FFFF00}PRESTIGE 5: {FFFFFF}Телепортация к игрокам теперь доступна.\n");
					if (Player[playerid][Prestige] == 6) SendClientMessage(playerid,COLOR_YELLOW,"PRESTIGE 6: Режим слежки теперь доступен (команды '/specp' и '/specoff').");
					if (Player[playerid][Prestige] == 7) SendClientMessage(playerid,COLOR_YELLOW,"PRESTIGE 7: Смена цвета ника (команда '/mycolor') теперь доступна.");
					if (Player[playerid][Prestige] == 9) SendClientMessage(playerid,COLOR_YELLOW,"PRESTIGE 9: Теперь вам всегда рады в казино! Максимальная ставка увеличена до 100 000 000$");
					if (Player[playerid][Prestige] == 10) SendClientMessage(playerid,COLOR_YELLOW,"PRESTIGE 10: 'Режим Бога' (бессмертие) теперь доступен. Используйте клавишу 'Y' (Пешком).");

				ResetTuneClass1(playerid); ResetTuneClass2(playerid);
				SavePlayer(playerid);LSpawnPlayer(playerid);
			}//респонс
		}//Престиж
		
		case DIALOG_TUTORIAL:
		{//обучение
			if (TutorialStep[playerid] == 1)
			{//Обучение: Вызов мопеда
			    SendClientMessage(playerid,COLOR_YELLOW,"ОБУЧЕНИЕ: {FFFFFF}Нажмите {00FF00}Alt{FFFFFF} и выберите <<{FFFF00}Сесть в машину [Класс 1]{FFFFFF}>>");
				TutorialObject[playerid] = CreateObject(19482, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    			SetObjectMaterialText(TutorialObject[playerid], "{FFFF00}Обучение\n{FFFFFF}Нажмите {00FF00}Alt", 0, OBJECT_MATERIAL_SIZE_512x512, "Tahoma", 50, 1, 0xFFFFFFFF, 0x00, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
                AttachObjectToPlayer(TutorialObject[playerid], playerid, 0, 0, 1.2, 0, 0, 270);
			}//Обучение: Вызов мопеда
			if (TutorialStep[playerid] == 2)
			{//Обучение: Выбор авто класса 2
			    ShowModelSelectionMenu(playerid, MenuFirstCar, "First Car");//менюшка выбора авто
			}//Обучение: Выбор авто класса 2
            if (TutorialStep[playerid] == 3)
			{//Обучение: Трансформация
			    SendClientMessage(playerid,COLOR_YELLOW,"ОБУЧЕНИЕ: {FFFFFF}Нажмите {00FF00}Y{FFFFFF} или {00FF00}N{FFFFFF} сидя на мопеде для трансформации транспорта.");
                TutorialObject[playerid] = CreateObject(19482, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
				SetObjectMaterialText(TutorialObject[playerid], "{FFFF00}Обучение\n{FFFFFF}Нажмите {00FF00}Y{FFFFFF}/{00FF00}N", 0, OBJECT_MATERIAL_SIZE_512x512, "Tahoma", 50, 1, 0xFFFFFFFF, 0x00, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
                AttachObjectToPlayer(TutorialObject[playerid], playerid, 0, 0, 1.2, 0, 0, 270);
			}//Обучение: Трансформация
			if (TutorialStep[playerid] == 4)
			{//Обучение: Конец обучения
    			new String[120];
				TutorialStep[playerid] = 999;Player[playerid][HelpTime] = 45;Player[playerid][Level] = 1;
				new Lvl = Player[playerid][Level]; NeedXP[playerid] = Levels[Lvl]; //первое обновление NeedXP
				SetVehicleVirtualWorld(GetPlayerVehicleID(playerid), 0);SetPlayerVirtualWorld(playerid, 0);
				format(String, sizeof String, "%d.%d.%d a %d:%d:%d |   %s[%d] прошел обучение.", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid);WriteLog("GlobalLog", String);
                if(TutorialObject[playerid] != -1){DestroyObject(TutorialObject[playerid]);TutorialObject[playerid] = -1;}
                LSpawnPlayer(playerid); PlayerPlaySound(playerid,1083,0.0,0.0,0.0);//звук выигрыша
                SendClientMessage(playerid,COLOR_YELLOW,"ОБУЧЕНИЕ: {FFFFFF}Не забывайте, что нажав {00FF00}Alt{FFFFFF} вы можете вызвать транспорт.");
                SendClientMessage(playerid,COLOR_YELLOW,"ОБУЧЕНИЕ: {FFFFFF}А нажав {00FF00}Y{FFFFFF} или {00FF00}N{FFFFFF} вы можете трансформировать его.");
			}//Обучение: Конец обучения
		}//обучение
		
		case DIALOG_PRESTIGECAR:
		{
		    if (response)
		    {//response
			    if(listitem == 0)
			    {//Класс 1
			        SendClientMessage(playerid,COLOR_YELLOW,"Транспорт 1-го класса успешно изменен.");
			        Player[playerid][CarSlot1] = SelectedModel[playerid];ResetTuneClass1(playerid);
			    }//Класс 1
			    if(listitem == 1)
			    {//Класс 2
			        SendClientMessage(playerid,COLOR_YELLOW,"Транспорт 2-го класса успешно изменен.");
			        Player[playerid][CarSlot2] = SelectedModel[playerid];ResetTuneClass2(playerid);
			    }//Класс 2
			    if(listitem == 2)
			    {//Сесть сейчас
					if (GetPlayerInterior(playerid) != 0 || IsPlayerInRangeOfPoint(playerid, 12.0, 2311.6953,-7.4206,26.7422)) return SendClientMessage(playerid, COLOR_RED, "Нельзя вызывать транспорт в помещениях!");//Игрок в интерьерах или в банке
					if (GetPlayerWeapon(playerid) == 46) return SendClientMessage(playerid,COLOR_RED,"Смените оружие! Нельзя вызывать автомобиль с парашютом на спине.");
					if (InEvent[playerid] > 0) return SendClientMessage(playerid,COLOR_RED,"Нельзя вызывать машину в соревнованиях!");
					if (QuestActive[playerid] > 0) return SendClientMessage(playerid,COLOR_RED,"Нельзя вызывать личный транспорт на работе!");
					if (TimeTransform[playerid] > 0){new String[120];format(String,sizeof(String),"Вы не можете вызвать транспорт еще {FFFFFF}%d{FF0000} секунд",TimeTransform[playerid]);SendClientMessage(playerid,COLOR_RED,String);return 1;}
					new Float: x, Float: y, Float: z, Float: Angle;
					GetPlayerPos(playerid,x,y,z);new wrld = GetPlayerVirtualWorld(playerid);GetPlayerFacingAngle(playerid, Angle);
					new col1 = random(240), col2 = random(240);
					PlayerCarID[playerid] = LCreateVehicle(SelectedModel[playerid], x, y, z, Angle, col1, col2, 0);
					SetVehicleVirtualWorld(PlayerCarID[playerid], wrld);PutPlayerInVehicle(playerid, PlayerCarID[playerid], 0);
					LinkVehicleToInterior(PlayerCarID[playerid],GetPlayerInterior(playerid));
			    }//Сесть сейчас
		    } else ShowModelSelectionMenu(playerid, MenuPrestigeCars, "Prestige Cars");
		}
		
		case DIALOG_HELP:
		{//help
		    if(response)
			{//респорс
			    if(listitem == 0)
				{//FAQ
				    new StringX[1024];
					strcat(StringX, "Где взять машину?\nЧто тут делать? Как качать уровень?\nКак менять машину прямо во время езды?\nУ меня забрали деньги! Что делать?\n");
					strcat(StringX, "\nКак изменить модель персонажа?\nКак изменить место респавна?\nКак создать или вступить в клан?\nЧто такое 'Карма' и зачем она нужна?\nКак прокачать 'Престиж'?");
					ShowPlayerDialog(playerid, DIALOG_HELPFAQ, 2, "Часто Задаваемые Вопросы (FAQ)", StringX, "ОК", "Назад");
				}//FAQ
				if(listitem == 1){ShowPlayerDialog(playerid, DIALOG_HELPCMD, 2, "Игровые команды, Чат", "{FFFFFF}Самые важные и часто используемые команды\nВиды сообщений (общие, ЛС, шепот и т.д.)\nПолный список команд (Без подробного описания)\nViP - Сообщения", "ОК", "Назад");}//CMD
                if(listitem == 2)
                {
                    new StringX[1024];
					strcat(StringX, "{FFFF00}1 {FFFFFF}- {FFFF00}20 {FFFFFF}уровни\n{FFFF00}21 {FFFFFF}- {FFFF00}40 {FFFFFF}уровни\n{FFFF00}41 {FFFFFF}- {FFFF00}60 {FFFFFF}уровни\n{FFFF00}61 {FFFFFF}- {FFFF00}80 {FFFFFF}уровни\n{FFFF00}81 {FFFFFF}- {FFFF00}100 {FFFFFF}уровни\n");
					strcat(StringX, "{FFFF00}Престиж {FFFFFF}1\n{FFFF00}Престиж {FFFFFF}2 - 10");
					ShowPlayerDialog(playerid, DIALOG_HELPLVL, 2, "Информация об уровнях", StringX, "ОК", "Назад");
                }
				if(listitem == 3) SendCommand(playerid, "/vip", "");
			}//респонс
		}//help
		
		case DIALOG_HELPFAQ:
		{//helpfaq
		    if(response)
			{//респорс
			    new StringX[1024];
			    if(listitem == 0)
			    {//Где взять машину
			        strcat(StringX, "{FFFFFF}Каждому игроку на сервере с смого начала выдается свой личный автомобиль. Изначально это мопед {FFFF00}Faggio{FFFFFF}.\n");
			        strcat(StringX, "Для того, чтобы сесть на него, используйте кнопку ходьбы (Левый Alt) и выберите <<Сесть в машину [Класс 1]>>\n\n");
			        strcat(StringX, "У каждого игрока может быть сразу три автомобиля: по одному на каждый класс. Более того, можно прямо во время езды трансформироваться\n");
			        strcat(StringX, "из одного автомобиля в другой при помощи клавиш <{FFFF00}Y{FFFFFF}> и <{FFFF00}N{FFFFFF}>.");
			    }//Где взять машину
			    if(listitem == 1)
			    {//Что тут делать? Как качать уровень?
			        strcat(StringX, "{FFFFFF}Вашей основной задачей является прокачка уровня. С каждым уровнем у вас будут новые возможности, транспорт и оружие.\n");
			        strcat(StringX, "Для повышения уровня нужно участвовать в {FFFF00}соревнованиях{FFFFFF}, выполнять {FFFF00}задания{FFFFFF} или ходить на {FFFF00}работу{FFFFFF}.\n");
			        strcat(StringX, "За это вы будете получать опыт, необходимый для повышения уровня.\n\n");
			        strcat(StringX, "    • Посмотреть список доступных соревнований можно командой {FF0000}/events{FFFFFF}\n");
  			        strcat(StringX, "    • Посмотреть список доступных заданий можно командой {FF0000}/quests{FFFFFF}\n");
			        strcat(StringX, "    • Найти работу, банк, казино и другие важные объекты можно при помощи {FF0000}/gps{FFFFFF}\n");
			    }//Что тут делать? Как качать уровень?
			    if(listitem == 2)
			    {//как менять авто во время езды
			        strcat(StringX, "{FFFFFF}При помощи клавиш <{FFFF00}Y{FFFFFF}> и <{FFFF00}N{FFFFFF}>.");
			    }//как менять авто во время езды
			    if(listitem == 3)
			    {//У меня забрали деньги. Что делать?
			        strcat(StringX, "{FFFFFF}Всегда храните ваши деньги в банке. Найти ближайший банк можно при помощи {FF0000}/gps{FFFFFF}.\n");
			    }//У меня забрали деньги. Что делать?
			    if(listitem == 4)
			    {//Как сменить скин
			         strcat(StringX, "{FFFFFF}Изменить модель персонажа можно в магазине одежды.\nИспользуйте {FFFF00}/gps{FFFFFF} чтобы найти его.\n");
			    }//Как сменить скин
			    if(listitem == 5)
			    {//Как изменить место респавна
			        strcat(StringX, "{FFFFFF}Стандартное место респавна изменяется автоматически, в зависимости от вашего уровня. Новички респавнятся вместе с новичками, а дядьки с шестиствольными\n");
			        strcat(StringX, "пулеметами рядом с такими же дядьками. Однако если вы купите себе дом или если у вашего клана есть штаб, то вы можете возрождаться там.\n");
			        strcat(StringX, "Используйте {FFFF00}/myspawn{FFFFFF} чтобы открыть меню настроек вашего респавна.");
			    }//Как изменить место респавна
			    if(listitem == 6)
			    {//Как создать или вступить в клан
			        strcat(StringX, "{FFFFFF}Для вступления в клан вас должен пригласить кто-то из клана, у кого есть на это право. Разумеется, что вы не должны быть ни в одном из кланов, иначе вас не\n");
			        strcat(StringX, "сможет пригласить никто другой. Если же вы сами решили создать клан, то вам нужно убедиться, что у вас есть 500 000$ и как минимум 10-ый уровень. Если да, то просто\n");
			        strcat(StringX, "введите команду {FFFF00}/clan {FFFF00} и вы обязательно разберетесь. Это не трудно.");
			    }//Как создать или вступить в клан
			    if(listitem == 7) return ShowKarma(playerid);
			    if(listitem == 8)
			    {//Как прокачать престиж?
			        strcat(StringX, "{FFFFFF}Чтобы получить Престиж вам сначала нужно дойти до самого верха - до 100-го уровня, а затем вы сможете добровольно начать всё\n");
			        strcat(StringX, "{FFFFFF}с начала. Если вы решитесь на это, то при повторной прокачке вас будут ждать новые возможности, которых нет у обычных игроков.");
			    }//Как прокачать престиж?
			    
  			    ShowPlayerDialog(playerid, DIALOG_HELPMES, 0, "Ответ",StringX, "Назад", "");
			}//респонс
			else SendCommand(playerid, "/help", "");
		}//helpfaq
		
		//ShowPlayerDialog(playerid, DIALOG_HELPMES, 0, "Список правил сервера","", "Назад", "");
		
		case DIALOG_HELPCMD:
		{//helpcmd
		    if(response)
			{//респорс
			    if(listitem == 0)
				{//частые команды
					new StringX[1024];
					strcat(StringX, "{008D00}/events{FFFFFF} - отобразить список всех соревнований    {008D00}/quests{FFFFFF} - отобразить список всех заданий,\n{008D00}/dm, /derby, /zombie, /race, /xrace, /gungame{FFFFFF} - отдельные команды для каждого соревнования,\n");
					strcat(StringX, "{008D00}/stats{FFFFFF} - посмотреть свою статистику    {008D00}/givecash{FFFFFF} - передать деньги другому игроку,\n{008D00}/buygun{FFFFFF} - оружейный магазин    {008D00}/mygun{FFFFFF} - выбор личного оружия,\n{008D00}/gps{FFFFFF} - Включить GPS    {008D00}/radio{FFFFFF} - включить радио");
				    ShowPlayerDialog(playerid, DIALOG_HELPMES, 0, "Самые важные и часто используемые команды",StringX, "Назад", "");
				}//частые команды
				if(listitem == 1)
				{//виды сообщений
				    new StringX[1024];
					strcat(StringX, "{FFFF00}В игре есть и другие способы общения кроме общего чата. Используйте\n   {008D00}!{FFFFFF}текст  - для отправки сообщений в чат клана,\n   {457EFF}@{FFFFFF}текст  - для отправки сообщений администрации сервера,\n   {CCFF00}#{FFFFFF}текст  - для отправки сообщения ближайшим игрокам (Шепот),\n   и {FFFF00}/pm{FFFFFF}  - для отправки личных сообщений.");
					ShowPlayerDialog(playerid, DIALOG_HELPMES, 0, "Виды сообщений",StringX, "Назад", "");
				}//виды сообщений
				if(listitem == 2) SendCommand(playerid, "/commands", "");//полный список команд
				if(listitem == 3)
				{//ViP - сообщения
				    new StringX[1024];
				    strcat(StringX, "{FFFF00}Внимание! Для отправки этих сообщений у вас должен быть ViP 2-го уровня или выше!\n\nВы можете разукрашивать ваши слова в сообщениях, используя коды цветов, указанные ниже:\n");
                    strcat(StringX, "{FF0000}*1{FFFFFF} - Красный    {3399FF}*2{FFFFFF} - Синий    {00FF00}*3{FFFFFF} - Зеленый    {FFFF00}*4{FFFFFF} - Желтый    {CCFF00}*5{FFFFFF} - Qiwi\n");
                    strcat(StringX, "{24F7FE}*6{FFFFFF} - Aqua    {F74AB8}*7{FFFFFF} - Розовый    {FFCC00}*8{FFFFFF} - цвет заданий    {976D3D}*9{FFFFFF} - Коричневый    {FFFFFF}* - Белый (Стандарт)\n");
                    strcat(StringX, "{FF8C00}*!1{FFFFFF} - dm    {9966CC}*!2{FFFFFF} - derby    {E60020}*!3{FFFFFF} - zombie    {007FFF}*!4{FFFFFF} - race\n");
                    strcat(StringX, "{FFD700}*!5{FFFFFF} - xrace    {FF6666}*!6{FFFFFF} - gungame    {AABBCC}*?{FFFFFF} - Случайный цвет\n");
					ShowPlayerDialog(playerid, DIALOG_HELPMES, 0, "Premium - Сообщения",StringX, "Назад", "");
				}//Premium - сообщения
			}//респонс
			else SendCommand(playerid, "/help", "");
		}//helpcmd
		
		case DIALOG_HELPLVL:
		{//helplvl
		    if(response)
			{//респорс
			    new StringX[2048];
			    if(listitem == 0)
				{//1 - 20 уровни
 					strcat(StringX, "{FFFF00}Level 2: {FFFFFF}Команда /skydive теперь доступна.\n");
					strcat(StringX, "{FFFF00}Level 3: {FFFFFF}Вам доступен новый транспорт 2-го класса.\n");
					strcat(StringX, "{FFFF00}Level 4: {FFFFFF}Вам доступен новое личное оружие.\n");
					strcat(StringX, "{FFFF00}Level 5: {FFFFFF}Вам доступен новый транспорт 1-го класса.\n");
					strcat(StringX, "{FFFF00}Level 6: {FFFFFF}Вам доступен новый транспорт 3-го класса.\n");
					strcat(StringX, "{FFFF00}Level 7: {FFFFFF}Вам доступен новый транспорт 3-го класса.\n");
					strcat(StringX, "{FFFF00}Level 8: {FFFFFF}Вам доступен новый транспорт 2-го класса и новое личное оружие.\n");
					strcat(StringX, "{FFFF00}Level 9: {FFFFFF}Вам доступен новый транспорт 3-го класса и гидравлика в автомастерских.\n");
					strcat(StringX, "{FFFF00}Level 10: {FFFFFF}Вам доступен новый стиль спавна - На авто 1-го класса.\n");
					strcat(StringX, "{FFFF00}Level 11: {FFFFFF}Вам доступен новый транспорт 3-го класса.\n");
					strcat(StringX, "{FFFF00}Level 12: {FFFFFF}Вам доступен новый транспорт 1-го класса.\n");
					strcat(StringX, "{FFFF00}Level 13: {FFFFFF}Вам доступен новый стиль спавна - На авто 2-го класса.\n");
					strcat(StringX, "{FFFF00}Level 14: {FFFFFF}Вам доступен новый транспорт 2-го класса.\n");
					strcat(StringX, "{FFFF00}Level 15: {FFFFFF}Вам доступен новый транспорт 3-го класса и изменено место стандартного спавна - Сан Фиерро.\n");
					strcat(StringX, "{FFFF00}Level 16: {FFFFFF}Вам доступен новый транспорт 1-го класса и новое личное оружие.\n");
					strcat(StringX, "{FFFF00}Level 17: {FFFFFF}Вам доступен новый транспорт 3-го класса и новое личное оружие.\n");
					strcat(StringX, "{FFFF00}Level 18: {FFFFFF}Вам доступно новое личное оружие.\n");
					strcat(StringX, "{FFFF00}Level 19: {FFFFFF}Вам доступен новый транспорт 3-го класса и новое личное оружие.\n");
					strcat(StringX, "{FFFF00}Level 20: {FFFFFF}Вам доступен новый транспорт 1-го класса.\n");
 				}//1 - 20 уровни
				if(listitem == 1)
				{//21 - 40 уровни
					strcat(StringX, "{FFFF00}Level 21: {FFFFFF}Вам доступен новый транспорт 3-го класса.\n");
					strcat(StringX, "{FFFF00}Level 22: {FFFFFF}Вам доступен новый транспорт 2-го класса.\n");
					strcat(StringX, "{FFFF00}Level 23: {FFFFFF}Вам доступен новый транспорт 3-го класса и новое личное оружие.\n");
					strcat(StringX, "{FFFF00}Level 24: {FFFFFF}Вам доступен новый транспорт 1-го класса.\n");
					strcat(StringX, "{FFFF00}Level 25: {FFFFFF}Вам доступен новый транспорт 3-го класса.\n");
					strcat(StringX, "{FFFF00}Level 25: {FFFFFF}Команда /mytime теперь доступна  и изменено место стандартного спавна - Лас Вентурас.\n");
					strcat(StringX, "{FFFF00}Level 26: {FFFFFF}Вам доступен новый транспорт 2-го класса.\n");
					strcat(StringX, "{FFFF00}Level 27: {FFFFFF}Вам доступно новое личное оружие.\n");
					strcat(StringX, "{FFFF00}Level 28: {FFFFFF}Вам доступен новый транспорт 1-го класса.\n");
					strcat(StringX, "{FFFF00}Level 29: {FFFFFF}Вам доступен новый транспорт 3-го класса.\n");
					strcat(StringX, "{FFFF00}Level 30: {FFFFFF}Вам доступен новый транспорт 2-го класса.\n");
					strcat(StringX, "{FFFF00}Level 31: {FFFFFF}Количество боеприпасов для пистолетов (Личное Оружие) увеличено до 140.\n");
					strcat(StringX, "{FFFF00}Level 32: {FFFFFF}Вам доступен новый транспорт 3-го класса.\n");
					strcat(StringX, "{FFFF00}Level 33: {FFFFFF}Количество боеприпасов для дробовиков (Личное Оружие) увеличено до 56.\n");
					strcat(StringX, "{FFFF00}Level 34: {FFFFFF}Вам доступно новое личное оружие.\n");
					strcat(StringX, "{FFFF00}Level 35: {FFFFFF}Нитро х2 в автомастерских теперь доступно.\n");
					strcat(StringX, "{FFFF00}Level 36: {FFFFFF}Вам доступны новые стили драки (/style).\n");
					strcat(StringX, "{FFFF00}Level 37: {FFFFFF}Количество боеприпасов для пистолет-пулеметов (Личное Оружие) увеличено до 1 000.\n");
					strcat(StringX, "{FFFF00}Level 38: {FFFFFF}Вам доступен JetPack и стиль спавна 'На JetPack'.\n");
					strcat(StringX, "{FFFF00}Level 39: {FFFFFF}Максимальная ставка в казино увеличена до 100 000$.\n");
					strcat(StringX, "{FFFF00}Level 40: {FFFFFF}Вам доступно новое личное оружие.\n");
				}//21 - 40 уровни
				if(listitem == 2)
				{//41 - 60 уровни
					strcat(StringX, "{FFFF00}Level 41: {FFFFFF}Количество боеприпасов для автоматов (Личное Оружие) увеличено до 180.\n");
					strcat(StringX, "{FFFF00}Level 42: {FFFFFF}Нитро х5 в автомастерских теперь доступно.\n");
					strcat(StringX, "{FFFF00}Level 43: {FFFFFF}Количество гранат (Личное Оружие) увеличено до 20.\n");
					strcat(StringX, "{FFFF00}Level 44: {FFFFFF}Количество боеприпасов для винтовок (Личное Оружие) увеличено до 30.\n");
					strcat(StringX, "{FFFF00}Level 45: {FFFFFF}Вам доступен новый транспорт 1-го класса.\n");
					strcat(StringX, "{FFFF00}Level 46: {FFFFFF}Количество боеприпасов для RPG (Личное Оружие) увеличено до 20.\n");
					strcat(StringX, "{FFFF00}Level 47: {FFFFFF}Команды для перекраски транспорта /paint и /paintid теперь доступны.\n");
					strcat(StringX, "{FFFF00}Level 48: {FFFFFF}Нитро х10 в автомастерских теперь доступно.\n");
					strcat(StringX, "{FFFF00}Level 49: {FFFFFF}Вам доступен новый транспорт 1-го класса.\n");
					strcat(StringX, "{FFFF00}Level 50: {FFFFFF}Вам доступен новый транспорт 3-го класса.\n");
					strcat(StringX, "{FFFF00}Level 51: {FFFFFF}Навык 'Перевернуть транспорт на колеса' теперь доступен.\n");
					strcat(StringX, "{FFFF00}Level 52: {FFFFFF}Команды для смены скина (/myskin, /myskinid) теперь доступны.\n");
					strcat(StringX, "{FFFF00}Level 53: {FFFFFF}Максимальная ставка в казино увеличена до 500 000$.\n");	
					strcat(StringX, "{FFFF00}Level 54: {FFFFFF}Доступен новый стиль спавна - На авто 3-го класса.\n");
					strcat(StringX, "{FFFF00}Level 55: {FFFFFF}Покрасочные работы в автомастерских теперь доступны.\n");
					strcat(StringX, "{FFFF00}Level 56: {FFFFFF}Доступен навык 'Разворот на 180' для транспорта 1-го класса.\n");
					strcat(StringX, "{FFFF00}Level 57: {FFFFFF}Вам доступен новый транспорт 1-го класса.\n");
					strcat(StringX, "{FFFF00}Level 58: {FFFFFF}Вам доступен новый транспорт 1-го класса.\n");
					strcat(StringX, "{FFFF00}Level 59: {FFFFFF}Доступен навык  'Разворот на 180' для транспорта 2-го класса.\n");
					strcat(StringX, "{FFFF00}Level 60: {FFFFFF}Вам доступно новое личное оружие.\n");
				}//41 - 60 уровни
				if(listitem == 3)
				{//61 - 80 уровни
					strcat(StringX, "{FFFF00}Level 61: {FFFFFF}Доступен навык 'Прыжок' для транспорта 1-го класса.\n");
					strcat(StringX, "{FFFF00}Level 62: {FFFFFF}Доступен навык 'Прыжок' для транспорта 2-го класса.\n");
					strcat(StringX, "{FFFF00}Level 63: {FFFFFF}Доступен навык 'Трамплин' для транспорта 1-го класса.\n");
					strcat(StringX, "{FFFF00}Level 64: {FFFFFF}Доступен навык 'Трамплин' для транспорта 2-го класса.\n");
					strcat(StringX, "{FFFF00}Level 65: {FFFFFF}Бесконечное нитро теперь доступно в автомастерской TurboSpeed.\n");
					strcat(StringX, "{FFFF00}Level 66: {FFFFFF}Максимальная ставка в казино увеличена до 1 000 000$.\n");
					strcat(StringX, "{FFFF00}Level 67: {FFFFFF}Команда /myweather теперь доступна.\n");
					strcat(StringX, "{FFFF00}Level 68: {FFFFFF}Вам доступен новый транспорт 3-го класса.\n");
					strcat(StringX, "{FFFF00}Level 69: {FFFFFF}Изменено место стандартного спавна - Гора Chilliad.\n");
					strcat(StringX, "{FFFF00}Level 70: {FFFFFF}Вам доступна невидимость на радаре (/invisible).\n");
					strcat(StringX, "{FFFF00}Level 71: {FFFFFF}Количество боеприпасов для пистолетов (Личное Оружие) увеличено до 210.\n");
					strcat(StringX, "{FFFF00}Level 72: {FFFFFF}Количество боеприпасов для дробовиков (Личное Оружие) увеличено до 84.\n");
					strcat(StringX, "{FFFF00}Level 73: {FFFFFF}Количество боеприпасов для пистолет-пулеметов (Личное Оружие) увеличено до 1 500.\n");
					strcat(StringX, "{FFFF00}Level 74: {FFFFFF}Количество боеприпасов для автоматов (Личное Оружие) увеличено до 270.\n");
					strcat(StringX, "{FFFF00}Level 75: {FFFFFF}Вам доступен новый транспорт 1-го класса.\n");
					strcat(StringX, "{FFFF00}Level 76: {FFFFFF}Количество гранат (Личное Оружие) увеличено до 30.\n");
					strcat(StringX, "{FFFF00}Level 77: {FFFFFF}Количество боеприпасов для винтовок (Личное Оружие) увеличено до 45.\n");
					strcat(StringX, "{FFFF00}Level 78: {FFFFFF}Вам доступен новый транспорт 3-го класса.\n");
					strcat(StringX, "{FFFF00}Level 79: {FFFFFF}Количество боеприпасов для RPG (Личное Оружие) увеличено до 30.\n");
					strcat(StringX, "{FFFF00}Level 80: {FFFFFF}UberNitro теперь доступно в автомастерской TurboSpeed.\n");
				}//61 - 80 уровни
				if(listitem == 4)
				{//81 - 100 уровни
					strcat(StringX, "{FFFF00}Level 81: {FFFFFF}Количество боеприпасов для Минигана (Личное Оружие) увеличено до 2 000.\n");
					strcat(StringX, "{FFFF00}Level 82: {FFFFFF}Количество боеприпасов для пистолетов (Личное Оружие) увеличено до 280.\n");
					strcat(StringX, "{FFFF00}Level 83: {FFFFFF}Количество боеприпасов для дробовиков (Личное Оружие) увеличено до 112.\n");
					strcat(StringX, "{FFFF00}Level 84: {FFFFFF}Количество боеприпасов для пистолет-пулеметов (Личное Оружие) увеличено до 2 000.\n");
					strcat(StringX, "{FFFF00}Level 85: {FFFFFF}Вам доступен новый транспорт 3-го класса.\n");
					strcat(StringX, "{FFFF00}Level 86: {FFFFFF}Количество боеприпасов для автоматов (Личное Оружие) увеличено до 360.\n");
					strcat(StringX, "{FFFF00}Level 87: {FFFFFF}Количество гранат (Личное Оружие) увеличено до 40.\n");
					strcat(StringX, "{FFFF00}Level 88: {FFFFFF}Количество боеприпасов для винтовок (Личное Оружие) увеличено до 60.\n");
					strcat(StringX, "{FFFF00}Level 89: {FFFFFF}Количество боеприпасов для RPG (Личное Оружие) увеличено до 40.\n");
					strcat(StringX, "{FFFF00}Level 90: {FFFFFF}Вам доступен новый транспорт 3-го класса.\n");
					strcat(StringX, "{FFFF00}Level 91: {FFFFFF}Количество боеприпасов для Минигана (Личное Оружие) увеличено до 3 000.\n");
					strcat(StringX, "{FFFF00}Level 92: {FFFFFF}Количество боеприпасов для пистолетов (Личное Оружие) увеличено до 20 000.\n");
					strcat(StringX, "{FFFF00}Level 93: {FFFFFF}Количество боеприпасов для дробовиков (Личное Оружие) увеличено до 20 000.\n");
					strcat(StringX, "{FFFF00}Level 94: {FFFFFF}Количество боеприпасов для пистолет-пулеметов (Личное Оружие) увеличено до 20 000.\n");
					strcat(StringX, "{FFFF00}Level 95: {FFFFFF}Количество боеприпасов для автоматов (Личное Оружие) увеличено до 20 000.\n");
					strcat(StringX, "{FFFF00}Level 96: {FFFFFF}Количество гранат (Личное Оружие) увеличено до 20 000.\n");
					strcat(StringX, "{FFFF00}Level 97: {FFFFFF}Количество боеприпасов для винтовок (Личное Оружие) увеличено до 20 000.\n");
					strcat(StringX, "{FFFF00}Level 98: {FFFFFF}Количество боеприпасов для RPG (Личное Оружие) увеличено до 20 000.\n");
					strcat(StringX, "{FFFF00}Level 99: {FFFFFF}Количество боеприпасов для Минигана (Личное Оружие) увеличено до 20 000.\n");
					strcat(StringX, "{FFFF00}Level 100: {FFFFFF}Ускоритель для JetPack теперь доступен (Клавиша 'N').\n");
                }//81 - 100 уровни
				if(listitem == 5)
				{//Престиж 1
					strcat(StringX, "{FFFF00}Level 10 PRESTIGE 1: {FFFFFF}Навык 'Телепорт на 50 метров' теперь доступен.\n");
					strcat(StringX, "{FFFF00}Level 20 PRESTIGE 1: {FFFFFF}Навык 'Телепорт на 100 метров' теперь доступен.\n");
					strcat(StringX, "{FFFF00}Level 35 PRESTIGE 1: {FFFFFF}Навык 'Телепорт на 50 метров' (для транспорта) теперь доступен.\n");
					strcat(StringX, "{FFFF00}Level 40 PRESTIGE 1: {FFFFFF}Навык 'Телепорт на 100 метров' (для транспорта) теперь доступен.\n");
					strcat(StringX, "{FFFF00}Level 45 PRESTIGE 1: {FFFFFF}Навык 'Телепорт на 200 метров' (для транспорта) теперь доступен.\n");
					strcat(StringX, "{FFFF00}Level 53 PRESTIGE 1: {FFFFFF}Навык 'Телепорт на 200 метров' теперь доступен.\n");
					strcat(StringX, "{FFFF00}Level 55 PRESTIGE 1: {FFFFFF}Навык 'Телепорт на 50 метров (cо скоростью)' (для транспорта) теперь доступен.\n");
					strcat(StringX, "{FFFF00}Level 60 PRESTIGE 1: {FFFFFF}Навык 'Телепорт на 100 метров (cо скоростью)' (для транспорта) теперь доступен.\n");
					strcat(StringX, "{FFFF00}Level 65 PRESTIGE 1: {FFFFFF}Навык 'Телепорт на 200 метров (cо скоростью)' (для транспорта) теперь доступен.\n");
					strcat(StringX, "{FFFF00}Level 85 PRESTIGE 1: {FFFFFF}Теперь вы можете ставить любой транспорт в класс 1 и 2.\n");
				}//Престиж 1
				if(listitem == 6)
				{//Престиж 2+
					strcat(StringX, "{FFFF00}Level 25 PRESTIGE 2: {FFFFFF}Навык 'Режим Полета' (для транспорта) теперь доступен.\n");
					strcat(StringX, "{FFFF00}PRESTIGE 3: {FFFFFF}Разноцветный ник в чате (команда '/chatname') теперь доступен.\n");
					strcat(StringX, "{FFFF00}PRESTIGE 4: {FFFFFF}Неон теперь доступен в автомастерской TurboSpeed.\n");
					strcat(StringX, "{FFFF00}PRESTIGE 5: {FFFFFF}Телепортация к игрокам теперь доступна.\n");
					strcat(StringX, "{FFFF00}PRESTIGE 6: {FFFFFF}Режим слежки теперь доступен (команды '/specp' и '/specoff').\n");
					strcat(StringX, "{FFFF00}PRESTIGE 7: {FFFFFF}Смена цвета ника (команда '/mycolor') теперь доступна.\n");
					strcat(StringX, "{FFFF00}Level 25 PRESTIGE 8: {FFFFFF}Навык 'Режим Cупермена' теперь доступен.\n");
					strcat(StringX, "{FFFF00}PRESTIGE 9: {FFFFFF}Теперь вам всегда рады в казино! Максимальная ставка увеличена до 100 000 000$.\n");
					strcat(StringX, "{FFFF00}PRESTIGE 10: {FFFFFF}'Режим Бога' (бессмертие) теперь доступен.\n");
					strcat(StringX, "{FFFF00}Level 100 PRESTIGE 10: {FFFFFF}Внимание! Теперь вы можете 'прокачиваться' выше 100-го уровня!\n");
					strcat(StringX, "{FFFF00}Level 150 PRESTIGE 10: {FFFFFF}Внимание! Теперь вы можете летать быстрее в 'Режиме Полета'.\n");
					strcat(StringX, "{FFFF00}Level 200 PRESTIGE 10: {FFFFFF}Внимание! Теперь вы можете летать быстрее в 'Режиме Супермена'.\n");

				}//Престиж 2+
                ShowPlayerDialog(playerid, DIALOG_HELPMES, 0, "Информация об уровнях",StringX, "Назад", "");
			}//респонс
			else SendCommand(playerid, "/help", "");
		}//helplvl
		
		case DIALOG_HELPMES: SendCommand(playerid, "/help", "");

        case DIALOG_PVP:
		{//Настройки PvP
		    if(response)
			{//респонс
			    if (listitem == 0)
			    {//случайные настройки
			        if (PlayerPVP[playerid][Status] > 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Нельзя изменять настройки во время дуэли.");
      			    if (PlayerPVP[playerid][TimeOut] > 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Нельзя изменять настройки когда Вы/Вас вызвали на дуэль.");
					PlayerPVP[playerid][Map] = random(10) + 1;//случайная карта
					new rweap = random(20);
			        if (rweap == 0) PlayerPVP[playerid][Weapon] = 0;if (rweap == 1) PlayerPVP[playerid][Weapon] = 8;if (rweap == 2) PlayerPVP[playerid][Weapon] = 9;if (rweap == 3) PlayerPVP[playerid][Weapon] = 22;if (rweap == 4) PlayerPVP[playerid][Weapon] = 23;
					if (rweap == 5) PlayerPVP[playerid][Weapon] = 24;if (rweap == 6) PlayerPVP[playerid][Weapon] = 25;if (rweap == 7) PlayerPVP[playerid][Weapon] = 26;if (rweap == 8) PlayerPVP[playerid][Weapon] = 27;if (rweap == 9) PlayerPVP[playerid][Weapon] = 28;
					if (rweap == 10) PlayerPVP[playerid][Weapon] = 32;if (rweap == 11) PlayerPVP[playerid][Weapon] = 29;if (rweap == 12) PlayerPVP[playerid][Weapon] = 31;if (rweap == 13) PlayerPVP[playerid][Weapon] = 30;if (rweap == 14) PlayerPVP[playerid][Weapon] = 33;
					if (rweap == 15) PlayerPVP[playerid][Weapon] = 34;if (rweap == 16) PlayerPVP[playerid][Weapon] = 16;if (rweap == 17) PlayerPVP[playerid][Weapon] = 35;if (rweap == 18) PlayerPVP[playerid][Weapon] = 38;if (rweap == 19) PlayerPVP[playerid][Weapon] = 42;
					rweap = random(5);
					if (rweap == 0) PlayerPVP[playerid][Health] = 1;
					if (rweap == 1) PlayerPVP[playerid][Health] = 50;
					if (rweap == 2) PlayerPVP[playerid][Health] = 100;
					if (rweap == 3) PlayerPVP[playerid][Health] = 150;
					if (rweap == 4) PlayerPVP[playerid][Health] = 200;
					//Показать обновленные настройки
					new String[300], zWeapon[48], zMap[30];
					GetWeaponName(PlayerPVP[playerid][Weapon],zWeapon,sizeof(zWeapon));
					if (PlayerPVP[playerid][Weapon] == 0) zWeapon = "Без оружия";
					if (PlayerPVP[playerid][Map] == 1) zMap = "Арена";
					if (PlayerPVP[playerid][Map] == 2) zMap = "Под мостом";
					if (PlayerPVP[playerid][Map] == 3) zMap = "Над мостом";
					if (PlayerPVP[playerid][Map] == 4) zMap = "Молния";
					if (PlayerPVP[playerid][Map] == 5) zMap = "Окопы";
					if (PlayerPVP[playerid][Map] == 6) zMap = "Вертолетная площадка";
					if (PlayerPVP[playerid][Map] == 7) zMap = "Две крыши";
					if (PlayerPVP[playerid][Map] == 8) zMap = "Дамба";
					if (PlayerPVP[playerid][Map] == 9) zMap = "Грузовой корабль";
					if (PlayerPVP[playerid][Map] == 10) zMap = "Пирамида";
					format(String,sizeof(String),"{457EFF}Случайные настройки\n{FFFF00}Карта:{FFFFFF} %s\n{FFFF00}Оружие:{FFFFFF} %s\n{FFFF00}Здоровье:{FFFFFF} %d",zMap,zWeapon, PlayerPVP[playerid][Health]);
					ShowPlayerDialog(playerid, DIALOG_PVP, 2, "Настройки PvP", String, "ОК", "Назад");
			    }//случайные настройки
			    if (listitem == 1)
			    {//Смена карты
			        ShowPlayerDialog(playerid, DIALOG_PVPMAP, 2, "PVP - Выбор карты", "Арена\nПод мостом\nНад мостом\nМолния\nОкопы\nВертолетная площадка\nДве крыши\nДамба\nГрузовой корабль\nПирамида", "Ок", "Назад");
			    }//Смена карты
			    if (listitem == 2)
			    {//Смена оружия
			        ShowPlayerDialog(playerid, DIALOG_PVPWEAPON, 2, "PVP - Выбор оружия","Без оружия\nКатана\nБензопила\n9мм пистолет\n9мм пистолет с глушителем\nDesert Eagle\nДробовик\nОбрезы\nSPAS12\nMicroUZI\nTec9\nMP5\nM4\nAK-47\nВинтовка\nСнайперская винтовка\nГранаты\nRPG\nМиниган\nОгнетушитель", "Ок", "Назад");
			    }//Смена оружия
			    if (listitem == 3)
			    {//Смена здоровья
			        ShowPlayerDialog(playerid, DIALOG_PVPHEALTH, 1, "PVP - Количество здоровья","Введите необходимое количество здоровья (от 1 до 200).\nPS: 100 здоровья + 100 брони = 200 (по умолчанию).","Ок","Назад");
			    }//Смена здоровья
			}//респонс
   			else{ShowPlayerDialog(playerid, 2, 2, "Меню быстрого доступа", "Сесть в машину [Класс 1]\nСесть в машину [Класс 2]\nСесть в машину [Класс 3]\nНадеть JetPack (/jetpack)\nПрыгнуть с парашютом (/skydive)\n{FF0000}GPS (/gps){FFFFFF}\nИзменить мои автомобили\nИзменить мои навыки\nНастройки PvP\n{FFFF00}Открыть КПК", "ОК", "Назад");}
		}///Настройки PvP

        case DIALOG_PVPMAP:
		{//Место пвп
			if (PlayerPVP[playerid][Status] > 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Нельзя изменять настройки во время дуэли.");
            if (PlayerPVP[playerid][TimeOut] > 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Нельзя изменять настройки когда Вы/Вас вызвали на дуэль.");
		    if(response){PlayerPVP[playerid][Map] = listitem + 1;}
			new String[300], zWeapon[48], zMap[30];
			GetWeaponName(PlayerPVP[playerid][Weapon],zWeapon,sizeof(zWeapon));
			if (PlayerPVP[playerid][Weapon] == 0) zWeapon = "Без оружия";
			if (PlayerPVP[playerid][Map] == 1) zMap = "Арена";
			if (PlayerPVP[playerid][Map] == 2) zMap = "Под мостом";
			if (PlayerPVP[playerid][Map] == 3) zMap = "Над мостом";
			if (PlayerPVP[playerid][Map] == 4) zMap = "Молния";
			if (PlayerPVP[playerid][Map] == 5) zMap = "Окопы";
			if (PlayerPVP[playerid][Map] == 6) zMap = "Вертолетная площадка";
			if (PlayerPVP[playerid][Map] == 7) zMap = "Две крыши";
			if (PlayerPVP[playerid][Map] == 8) zMap = "Дамба";
			if (PlayerPVP[playerid][Map] == 9) zMap = "Грузовой корабль";
			if (PlayerPVP[playerid][Map] == 10) zMap = "Пирамида";
			format(String,sizeof(String),"{457EFF}Случайные настройки\n{FFFF00}Карта:{FFFFFF} %s\n{FFFF00}Оружие:{FFFFFF} %s\n{FFFF00}Здоровье:{FFFFFF} %d",zMap,zWeapon, PlayerPVP[playerid][Health]);
			ShowPlayerDialog(playerid, DIALOG_PVP, 2, "Настройки PvP", String, "ОК", "Назад");
		}//Место пвп
		
		case DIALOG_PVPWEAPON:
		{//оружие пвп
			if (PlayerPVP[playerid][Status] > 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Нельзя изменять настройки во время дуэли.");
            if (PlayerPVP[playerid][TimeOut] > 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Нельзя изменять настройки когда Вы/Вас вызвали на дуэль.");
	        if(response)
			{
			    //Без оружия, Катана, 9мм, 9мм силенсед, дигл, шотбан, обрезы, спас, микро узи, тек9, м4, ак47
				//винтовка, снайперка, грены, рпг, миниган
				if (listitem == 0) PlayerPVP[playerid][Weapon] = 0;
				if (listitem == 1) PlayerPVP[playerid][Weapon] = 8;
				if (listitem == 2) PlayerPVP[playerid][Weapon] = 9;
				if (listitem == 3) PlayerPVP[playerid][Weapon] = 22;
				if (listitem == 4) PlayerPVP[playerid][Weapon] = 23;
				if (listitem == 5) PlayerPVP[playerid][Weapon] = 24;
				if (listitem == 6) PlayerPVP[playerid][Weapon] = 25;
				if (listitem == 7) PlayerPVP[playerid][Weapon] = 26;
				if (listitem == 8) PlayerPVP[playerid][Weapon] = 27;
				if (listitem == 9) PlayerPVP[playerid][Weapon] = 28;
				if (listitem == 10) PlayerPVP[playerid][Weapon] = 32;
				if (listitem == 11) PlayerPVP[playerid][Weapon] = 29;
				if (listitem == 12) PlayerPVP[playerid][Weapon] = 31;
				if (listitem == 13) PlayerPVP[playerid][Weapon] = 30;
				if (listitem == 14) PlayerPVP[playerid][Weapon] = 33;
				if (listitem == 15) PlayerPVP[playerid][Weapon] = 34;
				if (listitem == 16) PlayerPVP[playerid][Weapon] = 16;
				if (listitem == 17) PlayerPVP[playerid][Weapon] = 35;
				if (listitem == 18) PlayerPVP[playerid][Weapon] = 38;
				if (listitem == 19) PlayerPVP[playerid][Weapon] = 42;
			}
			new String[300], zWeapon[48], zMap[30];
			GetWeaponName(PlayerPVP[playerid][Weapon],zWeapon,sizeof(zWeapon));
			if (PlayerPVP[playerid][Weapon] == 0) zWeapon = "Без оружия";
			if (PlayerPVP[playerid][Map] == 1) zMap = "Арена";
			if (PlayerPVP[playerid][Map] == 2) zMap = "Под мостом";
			if (PlayerPVP[playerid][Map] == 3) zMap = "Над мостом";
			if (PlayerPVP[playerid][Map] == 4) zMap = "Молния";
			if (PlayerPVP[playerid][Map] == 5) zMap = "Окопы";
			if (PlayerPVP[playerid][Map] == 6) zMap = "Вертолетная площадка";
			if (PlayerPVP[playerid][Map] == 7) zMap = "Две крыши";
			if (PlayerPVP[playerid][Map] == 8) zMap = "Дамба";
			if (PlayerPVP[playerid][Map] == 9) zMap = "Грузовой корабль";
			if (PlayerPVP[playerid][Map] == 10) zMap = "Пирамида";
			format(String,sizeof(String),"{457EFF}Случайные настройки\n{FFFF00}Карта:{FFFFFF} %s\n{FFFF00}Оружие:{FFFFFF} %s\n{FFFF00}Здоровье:{FFFFFF} %d",zMap,zWeapon, PlayerPVP[playerid][Health]);
			ShowPlayerDialog(playerid, DIALOG_PVP, 2, "Настройки PvP", String, "ОК", "Назад");
		}//оружие пвп
		
		case DIALOG_PVPHEALTH:
		{//здоровье пвп
			if (PlayerPVP[playerid][Status] > 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Нельзя изменять настройки во время дуэли.");
            if (PlayerPVP[playerid][TimeOut] > 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Нельзя изменять настройки когда Вы/Вас вызвали на дуэль.");
		    if(response)
			{
			    if (strval(inputtext) < 1 || strval(inputtext) > 200) SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Значение указано не верно (Должно быть от 1 до 200).");
			    else PlayerPVP[playerid][Health] = strval(inputtext);
			}
			new String[300], zWeapon[48], zMap[30];
			GetWeaponName(PlayerPVP[playerid][Weapon],zWeapon,sizeof(zWeapon));
			if (PlayerPVP[playerid][Weapon] == 0) zWeapon = "Без оружия";
			if (PlayerPVP[playerid][Map] == 1) zMap = "Арена";
			if (PlayerPVP[playerid][Map] == 2) zMap = "Под мостом";
			if (PlayerPVP[playerid][Map] == 3) zMap = "Над мостом";
			if (PlayerPVP[playerid][Map] == 4) zMap = "Молния";
			if (PlayerPVP[playerid][Map] == 5) zMap = "Окопы";
			if (PlayerPVP[playerid][Map] == 6) zMap = "Вертолетная площадка";
			if (PlayerPVP[playerid][Map] == 7) zMap = "Две крыши";
			if (PlayerPVP[playerid][Map] == 8) zMap = "Дамба";
			if (PlayerPVP[playerid][Map] == 9) zMap = "Грузовой корабль";
			if (PlayerPVP[playerid][Map] == 10) zMap = "Пирамида";
			format(String,sizeof(String),"{457EFF}Случайные настройки\n{FFFF00}Карта:{FFFFFF} %s\n{FFFF00}Оружие:{FFFFFF} %s\n{FFFF00}Здоровье:{FFFFFF} %d",zMap,zWeapon, PlayerPVP[playerid][Health]);
			ShowPlayerDialog(playerid, DIALOG_PVP, 2, "Настройки PvP", String, "ОК", "Назад");
		}//здоровье пвп

		case DIALOG_CONFIG:
		{//Настройки аккаунта
		    if (!response) return 1;
		    if (listitem == 0)
		    {//Личные сообщения
		        if (Player[playerid][ConPM] == 1) {Player[playerid][ConPM] = 0;SendClientMessage(playerid,COLOR_RED,"SERVER: Система личных сообщений отключена.");}
				else {Player[playerid][ConPM] = 1;SendClientMessage(playerid,COLOR_CLAN,"SERVER: Система личных сообщений включена.");}
		    }//Личные сообщения
		    if (listitem == 1)
		    {//Разрешить приглашать в клан
		        if (Player[playerid][ConInviteClan] == 1) {Player[playerid][ConInviteClan] = 0;SendClientMessage(playerid,COLOR_RED,"SERVER: Вы запретили приглашать себя в клан.");}
				else {Player[playerid][ConInviteClan] = 1;SendClientMessage(playerid,COLOR_CLAN,"SERVER: Вы разрешили приглашать себя в клан.");}
		    }//Разрешить приглашать в клан
		    if (listitem == 2)
		    {//Разрешить приглашать на PvP
		        if (Player[playerid][ConInvitePVP] == 1) {Player[playerid][ConInvitePVP] = 0;SendClientMessage(playerid,COLOR_RED,"SERVER: Вы запретили вызывать себя на PvP.");}
				else {Player[playerid][ConInvitePVP] = 1;SendClientMessage(playerid,COLOR_CLAN,"SERVER: Вы разрешили вызывать себя на PvP.");}
		    }//Разрешить приглашать на PvP
		    if (listitem == 3)
		    {//Отображать результаты PvP
		        if (Player[playerid][ConMesPVP] == 1) {Player[playerid][ConMesPVP] = 0;SendClientMessage(playerid,COLOR_RED,"SERVER: Вы отключили отображение сообщений о результатах PvP других игроков.");}
				else {Player[playerid][ConMesPVP] = 1;SendClientMessage(playerid,COLOR_CLAN,"SERVER: Вы включили отображение сообщений о результатах PvP других игроков.");}
		    }//Отображать результаты PvP
		    if (listitem == 4)
		    {//Сообщения о входе/выходе игроков
		        if (Player[playerid][ConMesEnterExit] == 1) {Player[playerid][ConMesEnterExit] = 0;SendClientMessage(playerid,COLOR_RED,"SERVER: Вы отключили отображение сообщений о входе/выходе игроков на сервер.");}
				else {Player[playerid][ConMesEnterExit] = 1;SendClientMessage(playerid,COLOR_CLAN,"SERVER: Вы включили отображение сообщений о входе/выходе игроков на сервер.");}
		    }//Сообщения о входе/выходе игроков
		    if (listitem == 5)
		    {//Сообщения о входе/выходе игроков
		        if (Player[playerid][ConSpeedo] == 1) {Player[playerid][ConSpeedo] = 0;SendClientMessage(playerid,COLOR_RED,"SERVER: Вы отключили отображение спидометра.");}
				else {Player[playerid][ConSpeedo] = 1;SendClientMessage(playerid,COLOR_CLAN,"SERVER: Вы включили отображение спидометра."); SpeedoUpdate(playerid);}
		    }//Сообщения о входе/выходе игроков
		
		    if (listitem != 6) SendCommand(playerid, "/config", "");//Если не нажал "Сохранить и закрыть" - показываем менюшку еще раз
		}//Настройки аккаунта
		
		case DIALOG_CHANGENICK:
		{//Смена ника - ввод старого пароля прежде чем вводить новый ник
		    if (!response) return SendCommand(playerid, "/shop", "");
		    if(strcmp(PlayerPass[playerid], inputtext, true)) return ShowPlayerDialog(playerid, DIALOG_CHANGENICK, 1, "Смена ника", "{FF0000}Вы уверены, что хотите сменить ник?\n{FFFFFF}Для продолжения введите ваш текущий пароль:\n\n{FF0000}Пароль введен неверно! Повторите попытку...","ОК","Назад");
		    ShowPlayerDialog(playerid, DIALOG_CHANGENICK2, 1, "Смена ника", "{008E00}Отлично! Теперь введите ваш новый игровой ник:","ОК","Отмена");
		}//Смена ника - ввод старого пароля прежде чем вводить новый ник
		
		case DIALOG_CHANGENICK2:
		{//Смена ника - ввод нового ника
		    if (!response) return SendClientMessage(playerid,COLOR_RED,"Вы отменили смену ника.");
		    if (Player[playerid][GameGold] < 100) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: У вас нет 100GG");
		    if(!strcmp(PlayerName[playerid], inputtext, true)) return ShowPlayerDialog(playerid, DIALOG_CHANGENICK2, 1, "Смена ника", "{008E00}Отлично! Теперь введите ваш новый игровой ник:\n\n{FF0000}Ваш новый ник не отличается от старого!","ОК","Отмена");
		    if(!strlen(inputtext) || strlen(inputtext) < 3 || strlen(inputtext) > 20) return ShowPlayerDialog(playerid, DIALOG_CHANGENICK2, 1, "Смена ника", "{008E00}Отлично! Теперь введите ваш новый игровой ник:\n\n{FF0000}Длина ника должна быть от 3 до 20 символов!","ОК","Отмена");
		    new AllowNick = 1, file, OldName[24], NewName[24],filename[60];
		    for (new i; i < strlen(inputtext); i++)
			{//Проверка каждого символа в нике на допустимость
			    if (inputtext[i] >= '0' && inputtext[i] <= '9') continue;
			    if (inputtext[i] >= 'A' && inputtext[i] <= 'Z') continue;
			    if (inputtext[i] >= 'a' && inputtext[i] <= 'z') continue;
			    if (inputtext[i] == '[' || inputtext[i] == ']') continue;
			    if (inputtext[i] == '(' || inputtext[i] == ')') continue;
			    if (inputtext[i] == '.' || inputtext[i] == '_') continue;
			    AllowNick = 0;
			}//Проверка каждого символа в нике на допустимость
			if (!AllowNick)  return ShowPlayerDialog(playerid, DIALOG_CHANGENICK2, 1, "Смена ника", "{008E00}Отлично! Теперь введите ваш новый игровой ник:\n\n{FF0000}Введенный вами ник содержит недопустимые символы!\n{008E00}Допустимые сиволы: {FFFFFF}A-Z, a-z, 0-9\n{008E00}А также символы:{FFFFFF} ( ) [ ] . _","ОК","Отмена");
			format(filename,sizeof(filename),"accounts/%s.ini",inputtext);
			if(fexist(filename)) return ShowPlayerDialog(playerid, DIALOG_CHANGENICK2, 1, "Смена ника", "{008E00}Отлично! Теперь введите ваш новый игровой ник:\n\n{FF0000}Аккаунт с таким именем уже существует!","ОК","Отмена");
            foreach(Player, cid) if(!strcmp(PlayerName[cid], inputtext, true)) return ShowPlayerDialog(playerid, DIALOG_CHANGENICK2, 1, "Смена ника", "{008E00}Отлично! Теперь введите ваш новый игровой ник:\n\n{FF0000}Аккаунт с таким именем уже существует!","ОК","Отмена");
            strmid(NewName, inputtext, 0, strlen(inputtext), 24);strmid(OldName, PlayerName[playerid], 0, strlen(PlayerName[playerid]), 24);
            strmid(PlayerName[playerid], inputtext, 0, strlen(inputtext), 24); SetPlayerName(playerid, PlayerName[playerid]);
            strmid(ChatName[playerid], PlayerName[playerid], 0, strlen(inputtext), 24);
            //Сохранение нового аккаунта
			file = ini_createFile(filename);
			if(file < 0) file = ini_openFile (filename);
			if(file >= 0)
			{
				ini_setString(file,"Password", PlayerPass[playerid]);
				ini_closeFile(file);
			}
			Player[playerid][GameGold] -= 100.0; SavePlayer(playerid);
			//Сохранение нового аккаунта
			format(filename,sizeof(filename),"accounts/%s.ini",OldName);dini_Remove(filename);//удаление старого аккаунта
			if (Player[playerid][Home] > 0)
			{//У игрока есть дом
			    new PlayerHouse = Player[playerid][Home], text3d[MAX_3DTEXT];
			    if(!strcmp(Property[PlayerHouse][pOwner], OldName, true))
			    {//Игроку ДЕЙСТВИТЕЛЬНО принадленал дом на старом нике
			        strmid(Property[PlayerHouse][pOwner], NewName, 0, strlen(NewName), MAX_PLAYER_NAME);
			        if(Property[PlayerHouse][pBuyBlock] > 0)
					{
						format(text3d, sizeof(text3d), "{00FF00}Дом ({FFFFFF}%d${00FF00})\n{007FFF}Владелец:{FFFFFF} %s\nНажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать", Property[PlayerHouse][pPrice], Property[PlayerHouse][pOwner]);
                        UpdateDynamic3DTextLabelText(PropertyText3D[PlayerHouse], 0xFFFFFFFF, text3d);SaveProperty(PlayerHouse);
					}
					else
					{
						format(text3d, sizeof(text3d), "{00FF00}Дом ({FF0000}Не продается{00FF00})\n{007FFF}Владелец:{FFFFFF} %s\nНажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать", Property[PlayerHouse][pOwner]);
                        UpdateDynamic3DTextLabelText(PropertyText3D[PlayerHouse], 0xFFFFFFFF, text3d);SaveProperty(PlayerHouse);
					}
			    }//Игроку ДЕЙСТВИТЕЛЬНО принадленал дом на старом нике
			}//У игрока есть дом
			if (Player[playerid][MyClan] != 0 && Player[playerid][Member] != 0)
			{//Игрок в клане
			    new clanid = Player[playerid][MyClan];
			    if (Player[playerid][Member] == -1) strmid(Clan[clanid][cLider], NewName, 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
                if (Player[playerid][Member] == 1) strmid(Clan[clanid][cMember1], NewName, 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
                if (Player[playerid][Member] == 2) strmid(Clan[clanid][cMember2], NewName, 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
                if (Player[playerid][Member] == 3) strmid(Clan[clanid][cMember3], NewName, 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
                if (Player[playerid][Member] == 4) strmid(Clan[clanid][cMember4], NewName, 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
                if (Player[playerid][Member] == 5) strmid(Clan[clanid][cMember5], NewName, 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
                if (Player[playerid][Member] == 6) strmid(Clan[clanid][cMember6], NewName, 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
                if (Player[playerid][Member] == 7) strmid(Clan[clanid][cMember7], NewName, 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
                if (Player[playerid][Member] == 8) strmid(Clan[clanid][cMember8], NewName, 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
                if (Player[playerid][Member] == 9) strmid(Clan[clanid][cMember9], NewName, 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
                if (Player[playerid][Member] == 10) strmid(Clan[clanid][cMember10], NewName, 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
                if (Player[playerid][Member] == 11) strmid(Clan[clanid][cMember11], NewName, 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
                if (Player[playerid][Member] == 12) strmid(Clan[clanid][cMember12], NewName, 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
                if (Player[playerid][Member] == 13) strmid(Clan[clanid][cMember13], NewName, 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
                if (Player[playerid][Member] == 14) strmid(Clan[clanid][cMember14], NewName, 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
                if (Player[playerid][Member] == 15) strmid(Clan[clanid][cMember15], NewName, 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
                if (Player[playerid][Member] == 16) strmid(Clan[clanid][cMember16], NewName, 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
                if (Player[playerid][Member] == 17) strmid(Clan[clanid][cMember17], NewName, 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
                if (Player[playerid][Member] == 18) strmid(Clan[clanid][cMember18], NewName, 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
                if (Player[playerid][Member] == 19) strmid(Clan[clanid][cMember19], NewName, 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
                if (Player[playerid][Member] == 20) strmid(Clan[clanid][cMember20], NewName, 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
				SaveClan(clanid);
			}//Игрок в клане
			new MesString[256];
			format(MesString,sizeof(MesString),"{008E00}Вы успешно изменили ник за 100 рублей.{FFFF00}\nНовый ник: {FFFFFF}%s{FFFF00}\nНе забудьте ввести его, когда в следующий раз запустите samp.",NewName);
			ShowPlayerDialog(playerid, 999999, 0, "Смена ника", MesString,"ОК","");
			//--------- Ниже идет запись в Log
			new String[140]; format(String, sizeof String, "%d.%d.%d в %d:%d:%d |   SHOP: %s изменил ник на %s за 100 рублей", Day, Month, Year, hour, minute, second, OldName, NewName);
			WriteLog("GlobalLog", String);WriteLog("Shop", String);WriteLog("NickChanges", String);
		}//Смена ника - ввод нового ника
		
		case DIALOG_MYWEATHER:
		{//Настройки погоды
		    if (!response) return 1;
		    if (listitem == 0) return 1;//Оставить текущую погоду
		    if (listitem == 1){SendClientMessage(playerid,COLOR_YELLOW,"SERVER: Вы установили серверную (общую) погоду.");PlayerWeather[playerid] = -1;}
			if (listitem == 2) return ShowPlayerDialog(playerid, DIALOG_MYWEATHER2, 1, "Установить свою погоду", "{FFFFFF}Введите ID погоды (от {008D00}0 {FFFFFF}до {008D00}1000000)\n{AFAFAF}- По умолчанию на сервере используется погода с ID от 0 до 20\n- Погода с ID больше 20 может работать некорректно в некоторое время суток", "ОК", "Назад");
		}//Настройки погоды
		
		case DIALOG_MYWEATHER2:
		{//Установить свою погоду
		    if (!response) return ShowPlayerDialog(playerid, DIALOG_MYWEATHER, 2, "Настройки погоды", "Оставить текущую погоду\nУстановить серверную (общую) погоду\nУстановить свою погоду", "ОК", "");
			new entered = strval(inputtext);
			if (entered < 0 || entered > 1000000) return ShowPlayerDialog(playerid, DIALOG_MYWEATHER2, 1, "Установить свою погоду", "{FFFFFF}Введите ID погоды ({FF0000}от 0 {FFFFFF}до 1000000)\n{AFAFAF}- По умолчанию на сервере используется погода с ID от 0 до 20\n- Погода с ID больше 20 может работать некорректно в некоторое время суток", "ОК", "Назад");
		    PlayerWeather[playerid] = entered;
		    new String[140];format(String,sizeof(String),"SERVER: Вы установили погоду с ID %d",entered);
			return SendClientMessage(playerid,COLOR_YELLOW,String);
		}//Установить свою погоду
		
        case DIALOG_PRESTIGEGM:
		{//Режим Бога
		    if (!response) return 1;
		    if (listitem == 0)
			{//Отключить режим Бога
                PrestigeGM[playerid] = 0; SetPlayerHealth(playerid, 100.0);
				SendClientMessage(playerid,0xFF0000FF,"Режим Бога деактивирован. Вы были автоматически зареспавнены.");
				LSpawnPlayer(playerid);
			}//Отключить режим Бога
			if (listitem == 1)
			{//Телепортироваться к маркеру GPS
			    if (GPSUsed[playerid] == 0) return SendClientMessage(playerid,COLOR_RED, "ОШИБКА: Сначала вам нужно установить маркер, используя {FFFFFF}/gps");
			    new Float: x, Float: y, Float: z; GetPlayerCheckpointPos(playerid, x, y, z); SetPlayerPos(playerid, x, y, z); SetPlayerInterior(playerid, 0);
			}//Телепортироваться к маркеру GPS
			if (listitem == 2) return LSpawnPlayer(playerid); //Респавн
		}//Режим Бога
		
		case DIALOG_ACHANGE:
		{//Изменение соревнований
		    if (!response) return 1;
		    if (listitem == 0)
			{//Изменить десматч
			    if (DMTimer > 1 && DMTimer < 300)
			    {//Соревнование доступно для изменения (объявлено и еще не стартовало)
			        new String[1024], StringX[80];String = "{FFFF00}Случайный выбор\n";
			        for (new id = 1; id <= 20; id++)
			        {//цикл
			            if (DMid == id) format (StringX, sizeof StringX, "{FF8C00}%s (СЕЙЧАС ВЫБРАНО)\n", DMName[id]);
			            else format (StringX, sizeof StringX, "{FFFFFF}%s\n", DMName[id]);
						strcat(String, StringX);
			        }//цикл
			        return ShowPlayerDialog(playerid, DIALOG_ACHANGEDM, 2, "{FF8C00}Изменить Десматч", String, "ОК", "Отмена");
			    }//Соревнование доступно для изменения (объявлено и еще не стартовало)
			    else return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Нельзя изменить десматч пока он не объявлен");
			}//Изменить десматч
			if (listitem == 1)
			{//Изменить дерби
			    if (DerbyTimer > 1 && DerbyTimer < 300)
			    {//Соревнование доступно для изменения (объявлено и еще не стартовало)
			        new String[1024], StringX[80];String = "{FFFF00}Случайный выбор\n";
			        for (new id = 1; id <= 9; id++)
			        {//цикл
			            if (Derbyid == id) format (StringX, sizeof StringX, "{9966CC}%s (СЕЙЧАС ВЫБРАНО)\n", DerbyName[id]);
			            else format (StringX, sizeof StringX, "{FFFFFF}%s\n", DerbyName[id]);
						strcat(String, StringX);
			        }//цикл
			        return ShowPlayerDialog(playerid, DIALOG_ACHANGEDERBY, 2, "{9966CC}Изменить Дерби", String, "ОК", "Отмена");
			    }//Соревнование доступно для изменения (объявлено и еще не стартовало)
			    else return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Нельзя изменить дерби пока оно не объявлено");
			}//Изменить дерби
			if (listitem == 2)
			{//Изменить зомби
			    if (ZMTimer > 1 && ZMTimer < 300)
			    {//Соревнование доступно для изменения (объявлено и еще не стартовало)
			        new String[1024], StringX[80];String = "{FFFF00}Случайный выбор\n";
			        for (new id = 1; id <= 15; id++)
			        {//цикл
			            if (ZMid == id) format (StringX, sizeof StringX, "{FF6666}%s (СЕЙЧАС ВЫБРАНО)\n", ZMName[id]);
			            else format (StringX, sizeof StringX, "{FFFFFF}%s\n", ZMName[id]);
						strcat(String, StringX);
			        }//цикл
			        return ShowPlayerDialog(playerid, DIALOG_ACHANGEZM, 2, "{FF6666}Изменить Зомби-Выживание", String, "ОК", "Отмена");
			    }//Соревнование доступно для изменения (объявлено и еще не стартовало)
			    else SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Нельзя изменить зомби-выживание пока оно не объявлено");
			}//Изменить зомби
			if (listitem == 3)
			{//Изменить гонку
			    if (FRTimer > 1 && FRTimer < 300)
			    {//Соревнование доступно для изменения (объявлено и еще не стартовало)
			        new String[2048], StringX[100];String = "{FFFF00}Случайный выбор\n";
			        for (new id = 1; id <= 40; id++)
			        {//цикл
			            if (FRStart == id) format (StringX, sizeof StringX, "{007FFF}%s (СЕЙЧАС ВЫБРАНО)\n", FRName[id]);
			            else format (StringX, sizeof StringX, "{FFFFFF}%s\n", FRName[id]);
						strcat(String, StringX);
			        }//цикл
			        return ShowPlayerDialog(playerid, DIALOG_ACHANGEFR, 2, "{007FFF}Изменить Гонку:{FFFFFF} Старт", String, "ОК", "Отмена");
			    }//Соревнование доступно для изменения (объявлено и еще не стартовало)
			    else SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Нельзя изменить гонку пока она не объявлена");
			}//Изменить гонку
			if (listitem == 4)
			{//Изменить гангейм
			    if (GGTimer > 1 && GGTimer < 600)
			    {//Соревнование доступно для изменения (объявлено и еще не стартовало)
			        new String[1024], StringX[80];String = "{FFFF00}Случайный выбор\n";
			        for (new id = 1; id <= 20; id++)
			        {//цикл
			            if (GGid == id) format (StringX, sizeof StringX, "{FF6666}%s (СЕЙЧАС ВЫБРАНО)\n", GGName[id]);
			            else format (StringX, sizeof StringX, "{FFFFFF}%s\n", GGName[id]);
						strcat(String, StringX);
			        }//цикл
			        return ShowPlayerDialog(playerid, DIALOG_ACHANGEGG, 2, "{FF6666}Изменить Гонку Вооружений", String, "ОК", "Отмена");
			    }//Соревнование доступно для изменения (объявлено и еще не стартовало)
			    else SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Нельзя изменить гонку вооружений пока она не объявлена");
			}//Изменить гангейм
			if (listitem == 5)
			{//Изменить легенду
			    if (XRTimer > 1 && XRTimer < 600)
			    {//Соревнование доступно для изменения (объявлено и еще не стартовало)
			        new String[1024], StringX[80];String = "{FFFF00}Случайный выбор\n";
			        for (new id = 1; id <= 20; id++)
			        {//цикл
			            if (XRid == id) format (StringX, sizeof StringX, "{007FFF}%s (СЕЙЧАС ВЫБРАНО)\n", XRName[id]);
			            else format (StringX, sizeof StringX, "{FFFFFF}%s\n", XRName[id]);
						strcat(String, StringX);
			        }//цикл
			        return ShowPlayerDialog(playerid, DIALOG_ACHANGEXR, 2, "{007FFF}Изменить Легендарную Гонку", String, "ОК", "Отмена");
			    }//Соревнование доступно для изменения (объявлено и еще не стартовало)
			    else SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Нельзя изменить легендарную гонку пока она не объявлена");
			}//Изменить легенду
		}//Изменение соревнований
		
		case DIALOG_ACHANGEDM:
		{//Изменение десматча
		    if (!response) return SendCommand(playerid, "/change", "");
		    if (listitem == 0) listitem = random(20) + 1;
		    if (listitem == DMid) return 1;
		    new Params[20];format(Params, sizeof Params, "dm %i", listitem);
            SendCommand(playerid, "/changeid", Params);
		}//Изменение десматча
		
		case DIALOG_ACHANGEDERBY:
		{//Изменение дерби
		    if (!response) return SendCommand(playerid, "/change", "");
		    if (listitem == 0) listitem = random(9) + 1;
		    if (listitem == Derbyid) return 1;
		    new Params[20];format(Params, sizeof Params, "derby %i", listitem);
		    SendCommand(playerid, "/changeid", Params);
		}//Изменение дерби
		
		case DIALOG_ACHANGEZM:
		{//Изменение зомби
		    if (!response) return SendCommand(playerid, "/change", "");
		    if (listitem == 0) listitem = random(15) + 1;
		    if (listitem == ZMid) return 1;
		    new Params[20];format(Params, sizeof Params, "zombie %i", listitem);
		    SendCommand(playerid, "/changeid", Params);
		}//Изменение зомби
		
		case DIALOG_ACHANGEFR:
		{//Изменение гонки: Старт
		    if (!response) return SendCommand(playerid, "/change", "");
		    if (FRTimer > 300) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Нельзя изменить гонку пока она не проявлена");
		    if (FRTimer > 2 && FRTimer <= 30) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Нельзя изменить гонку так как до старта осталось меньше 30 секунд");
 		    if (listitem == 0) listitem = random(40) + 1;
		    ACHANGEFR[playerid] = listitem;
            new String[2048], StringX[100];String = "{FFFF00}Случайный выбор\n";
			for (new id = 1; id <= 40; id++)
			{//цикл
				if (FRFinish == id) format (StringX, sizeof StringX, "{007FFF}%s (СЕЙЧАС ВЫБРАНО)\n", FRName[id]);
				else format (StringX, sizeof StringX, "{FFFFFF}%s\n", FRName[id]);
				strcat(String, StringX);
			}//цикл
			return ShowPlayerDialog(playerid, DIALOG_ACHANGEFR2, 2, "{007FFF}Изменить Гонку:{FFFFFF} Финиш", String, "ОК", "Назад");
		}//Изменение гонки: Старт
		
		case DIALOG_ACHANGEFR2:
		{//Изменение гонки: Финиш
		    if (!response)
		    {//Нажали кнопку назад (возврат к выбору старта гонки)
                if (FRTimer > 1 && FRTimer < 300)
			    {//Соревнование доступно для изменения (объявлено и еще не стартовало)
			        new String[2048], StringX[100];String = "{FFFF00}Случайный выбор\n";
			        for (new id = 1; id <= 40; id++)
			        {//цикл
			            if (FRStart == id) format (StringX, sizeof StringX, "{007FFF}%s (СЕЙЧАС ВЫБРАНО)\n", FRName[id]);
			            else format (StringX, sizeof StringX, "{FFFFFF}%s\n", FRName[id]);
						strcat(String, StringX);
			        }//цикл
			        return ShowPlayerDialog(playerid, DIALOG_ACHANGEFR, 2, "{007FFF}Изменить Гонку:{FFFFFF} Старт", String, "ОК", "Отмена");
			    }//Соревнование доступно для изменения (объявлено и еще не стартовало)
			    else SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Нельзя изменить гонку пока она не объявлена");
		    }//Нажали кнопку назад (возврат к выбору старта гонки)
		    if (listitem == 0) listitem = random(40) + 1;
		    new Params[20];format(Params, sizeof Params, "%i %i", ACHANGEFR[playerid], listitem);
		    SendCommand(playerid, "/changeraceid", Params);
		}//Изменение гонки: Финиш
		
		case DIALOG_ACHANGEGG:
		{//Изменение гангейма
		    if (!response) return SendCommand(playerid, "/change", "");
		    if (listitem == 0) listitem = random(20) + 1;
		    if (listitem == GGid) return 1;
		    new Params[20];format(Params, sizeof Params, "gungame %i", listitem);
		    SendCommand(playerid, "/changeid", Params);
		}//Изменение гангейма
		
		case DIALOG_ACHANGEXR:
		{//Изменение легенды
		    if (!response) return SendCommand(playerid, "/change", "");
		    if (listitem == 0) listitem = random(20) + 1;
		    if (listitem == XRid) return 1;
		    new Params[20];format(Params, sizeof Params, "xrace %i", listitem);
		    SendCommand(playerid, "/changeid", Params);
		}//Изменение легенды
		
		case DIALOG_TURBOSPEED:
		{//Автомастерская TurboSpeed
		    if (response)
		    {
		    	if (listitem == 0) ShowPlayerDialog(playerid, DIALOG_TURBOSPEEDNITRO, 2, "Нитро", "[{FFFF00}50 000${FFFFFF}] Бесконечное Нитро\n[{FFFF00}300 000${FFFFFF}] UberNitro", "ОК", "Назад");
				if (listitem == 1) ShowPlayerDialog(playerid, DIALOG_TURBOSPEEDNEON, 2, "Неон", "[{FFFF00}50 000${FFFFFF}] Красный\n[{FFFF00}50 000${FFFFFF}] Синий\n[{FFFF00}50 000${FFFFFF}] Зеленый\n[{FFFF00}50 000${FFFFFF}] Желтый\n[{FFFF00}50 000${FFFFFF}] Розовый\n[{FFFF00}50 000${FFFFFF}] Белый", "ОК", "Назад");
				if (listitem == 2)
				{//Удалить компонент тюнинга
				    if (Player[playerid][CarActive] < 1 || Player[playerid][CarActive] > 2) return SendClientMessage(playerid,COLOR_RED,"Удалять компоненты тюнинга можно только с личных автомобилей!");
				    new StringZ[1024];
				    if (Player[playerid][CarActive] == 1)
				    {//Класс 1
  				   		if (Player[playerid][CarSlot1Component0] == 0) strcat(StringZ, "{AFAFAF}Спойлер\n"); else strcat(StringZ, "{FFFFFF}Спойлер\n");
  				   		if (Player[playerid][CarSlot1Component1] == 0) strcat(StringZ, "{AFAFAF}Капот\n"); else strcat(StringZ, "{FFFFFF}Капот\n");
  				   		if (Player[playerid][CarSlot1Component2] == 0) strcat(StringZ, "{AFAFAF}Крыша\n"); else strcat(StringZ, "{FFFFFF}Крыша\n");
  				   		if (Player[playerid][CarSlot1Component3] == 0) strcat(StringZ, "{AFAFAF}Боковые юбки\n"); else strcat(StringZ, "{FFFFFF}Боковые юбки\n");
  				   		if (Player[playerid][CarSlot1Component4] == 0) strcat(StringZ, "{AFAFAF}Фары\n"); else strcat(StringZ, "{FFFFFF}Фары\n");
  				   		if (Player[playerid][CarSlot1Component5] == 0) strcat(StringZ, "{AFAFAF}Нитро\n"); else strcat(StringZ, "{FFFFFF}Нитро\n");
  				   		if (Player[playerid][CarSlot1Component6] == 0) strcat(StringZ, "{AFAFAF}Выхлопная труба\n"); else strcat(StringZ, "{FFFFFF}Выхлопная труба\n");
  				   		if (Player[playerid][CarSlot1Component7] == 0) strcat(StringZ, "{AFAFAF}Диски\n"); else strcat(StringZ, "{FFFFFF}Диски\n");
  				   		if (Player[playerid][CarSlot1Component8] == 0) strcat(StringZ, "{AFAFAF}Стерео\n"); else strcat(StringZ, "{FFFFFF}Стерео\n");
  				   		if (Player[playerid][CarSlot1Component9] == 0) strcat(StringZ, "{AFAFAF}Гидравлика\n"); else strcat(StringZ, "{FFFFFF}Гидравлика\n");
  				   		if (Player[playerid][CarSlot1Component10] == 0) strcat(StringZ, "{AFAFAF}Передний бампер\n"); else strcat(StringZ, "{FFFFFF}Передний бампер\n");
  				   		if (Player[playerid][CarSlot1Component11] == 0) strcat(StringZ, "{AFAFAF}Задний бампер\n"); else strcat(StringZ, "{FFFFFF}Задний бампер\n");
  				   		if (Player[playerid][CarSlot1Component12] == 0) strcat(StringZ, "{AFAFAF}Правый вент\n"); else strcat(StringZ, "{FFFFFF}Правый вент\n");
  				   		if (Player[playerid][CarSlot1Component13] == 0) strcat(StringZ, "{AFAFAF}Левый вент\n"); else strcat(StringZ, "{FFFFFF}Левый вент\n");
  				   		if (Player[playerid][CarSlot1PaintJob] == -1) strcat(StringZ, "{AFAFAF}Покрасочные работы\n"); else strcat(StringZ, "{FFFFFF}Покрасочные работы\n");
  				   		if (Player[playerid][CarSlot1Neon] == 0) strcat(StringZ, "{AFAFAF}Неон\n"); else strcat(StringZ, "{FFFFFF}Неон\n");
						return ShowPlayerDialog(playerid, DIALOG_TURBOSPEEDDELETE, 2, "Удалить компонент", StringZ, "Удалить", "Назад");
					}//Класс 1
  				    if (Player[playerid][CarActive] == 2)
				    {//Класс 2
				        if (Player[playerid][CarSlot2Component0] == 0) strcat(StringZ, "{AFAFAF}Спойлер\n"); else strcat(StringZ, "{FFFFFF}Спойлер\n");
  				   		if (Player[playerid][CarSlot2Component1] == 0) strcat(StringZ, "{AFAFAF}Капот\n"); else strcat(StringZ, "{FFFFFF}Капот\n");
  				   		if (Player[playerid][CarSlot2Component2] == 0) strcat(StringZ, "{AFAFAF}Крыша\n"); else strcat(StringZ, "{FFFFFF}Крыша\n");
  				   		if (Player[playerid][CarSlot2Component3] == 0) strcat(StringZ, "{AFAFAF}Боковые юбки\n"); else strcat(StringZ, "{FFFFFF}Боковые юбки\n");
  				   		if (Player[playerid][CarSlot2Component4] == 0) strcat(StringZ, "{AFAFAF}Фары\n"); else strcat(StringZ, "{FFFFFF}Фары\n");
  				   		if (Player[playerid][CarSlot2Component5] == 0) strcat(StringZ, "{AFAFAF}Нитро\n"); else strcat(StringZ, "{FFFFFF}Нитро\n");
  				   		if (Player[playerid][CarSlot2Component6] == 0) strcat(StringZ, "{AFAFAF}Выхлопная труба\n"); else strcat(StringZ, "{FFFFFF}Выхлопная труба\n");
  				   		if (Player[playerid][CarSlot2Component7] == 0) strcat(StringZ, "{AFAFAF}Диски\n"); else strcat(StringZ, "{FFFFFF}Диски\n");
  				   		if (Player[playerid][CarSlot2Component8] == 0) strcat(StringZ, "{AFAFAF}Стерео\n"); else strcat(StringZ, "{FFFFFF}Стерео\n");
  				   		if (Player[playerid][CarSlot2Component9] == 0) strcat(StringZ, "{AFAFAF}Гидравлика\n"); else strcat(StringZ, "{FFFFFF}Гидравлика\n");
  				   		if (Player[playerid][CarSlot2Component10] == 0) strcat(StringZ, "{AFAFAF}Передний бампер\n"); else strcat(StringZ, "{FFFFFF}Передний бампер\n");
  				   		if (Player[playerid][CarSlot2Component11] == 0) strcat(StringZ, "{AFAFAF}Задний бампер\n"); else strcat(StringZ, "{FFFFFF}Задний бампер\n");
  				   		if (Player[playerid][CarSlot2Component12] == 0) strcat(StringZ, "{AFAFAF}Правый вент\n"); else strcat(StringZ, "{FFFFFF}Правый вент\n");
  				   		if (Player[playerid][CarSlot2Component13] == 0) strcat(StringZ, "{AFAFAF}Левый вент\n"); else strcat(StringZ, "{FFFFFF}Левый вент\n");
  				   		if (Player[playerid][CarSlot2PaintJob] == -1) strcat(StringZ, "{AFAFAF}Покрасочные работы\n"); else strcat(StringZ, "{FFFFFF}Покрасочные работы\n");
  				   		if (Player[playerid][CarSlot2Neon] == 0) strcat(StringZ, "{AFAFAF}Неон\n"); else strcat(StringZ, "{FFFFFF}Неон\n");
                        return ShowPlayerDialog(playerid, DIALOG_TURBOSPEEDDELETE, 2, "Удалить компонент", StringZ, "Удалить", "Назад");
				    }//Кдасс 2
				}//Удалить компонент тюнинга
			}
		}//Автомастерская TurboSpeed
		
		case DIALOG_TURBOSPEEDDELETE:
		{//Автомастерская TurboSpeed - Удалить компонент
		    if (!response) return ShowPlayerDialog(playerid, DIALOG_TURBOSPEED, 2, "Автомастерская TurboSpeed", "Нитро\nНеон\n{FF0000}Удалить компонент тюнинга", "ОК", "Отмена");
			if (Player[playerid][CarActive] == 1)
			{//Класс 1
				if (listitem == 0)
				{
				    if (Player[playerid][CarSlot1Component0] == 0) return SendClientMessage(playerid,COLOR_GREY,"У вас не установлен спойлер");
					Player[playerid][CarSlot1Component0] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 0);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"Спойлер удален");
				}
				if (listitem == 1)
				{
				    if (Player[playerid][CarSlot1Component1] == 0) return SendClientMessage(playerid,COLOR_GREY,"У вас не установлен капот");
					Player[playerid][CarSlot1Component1] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 1);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"Капот удален");
				}
				if (listitem == 2)
				{
				    if (Player[playerid][CarSlot1Component2] == 0) return SendClientMessage(playerid,COLOR_GREY,"У вас не установлена крыша");
					Player[playerid][CarSlot1Component2] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 2);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"Крыша удалена");
				}
				if (listitem == 3)
				{
				    if (Player[playerid][CarSlot1Component3] == 0) return SendClientMessage(playerid,COLOR_GREY,"У вас не установлены боковые юбки");
					Player[playerid][CarSlot1Component3] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 3);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"Боковые юбки удален");
				}
				if (listitem == 4)
				{
				    if (Player[playerid][CarSlot1Component4] == 0) return SendClientMessage(playerid,COLOR_GREY,"У вас не установлены фары");
					Player[playerid][CarSlot1Component4] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 4);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"Фары удалены");
				}
				if (listitem == 5)
				{
				    if (Player[playerid][CarSlot1Component5] == 0) return SendClientMessage(playerid,COLOR_GREY,"У вас не установлено нитро");
					Player[playerid][CarSlot1Component5] = 0;Player[playerid][CarSlot1NitroX] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 5);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"Нитро удалено");
				}
				if (listitem == 6)
				{
				    if (Player[playerid][CarSlot1Component6] == 0) return SendClientMessage(playerid,COLOR_GREY,"У вас не установлена выхлопная труба");
					Player[playerid][CarSlot1Component6] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 6);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"Выхлопная труба удален");
				}
				if (listitem == 7)
				{
				    if (Player[playerid][CarSlot1Component7] == 0) return SendClientMessage(playerid,COLOR_GREY,"У вас не установлены диски");
					Player[playerid][CarSlot1Component7] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 7);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"Диски удалены");
				}
				if (listitem == 8)
				{
				    if (Player[playerid][CarSlot1Component8] == 0) return SendClientMessage(playerid,COLOR_GREY,"У вас не установлено стерео");
					Player[playerid][CarSlot1Component8] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 8);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"Стерео удалено");
				}
				if (listitem == 9)
				{
				    if (Player[playerid][CarSlot1Component9] == 0) return SendClientMessage(playerid,COLOR_GREY,"У вас не установлена гидравлика");
					Player[playerid][CarSlot1Component9] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 9);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"Гидравлика удалена");
				}
				if (listitem == 10)
				{
				    if (Player[playerid][CarSlot1Component10] == 0) return SendClientMessage(playerid,COLOR_GREY,"У вас не установлен передний бампер");
					Player[playerid][CarSlot1Component10] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 10);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"Передний бампер удален");
				}
				if (listitem == 11)
				{
				    if (Player[playerid][CarSlot1Component11] == 0) return SendClientMessage(playerid,COLOR_GREY,"У вас не установлен задний бампер");
					Player[playerid][CarSlot1Component11] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 11);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"Задний бампер удален");
				}
				if (listitem == 12)
				{
				    if (Player[playerid][CarSlot1Component12] == 0) return SendClientMessage(playerid,COLOR_GREY,"У вас не установлен правый вент");
					Player[playerid][CarSlot1Component12] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 12);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"Правый вент удален");
				}
				if (listitem == 13)
				{
				    if (Player[playerid][CarSlot1Component13] == 0) return SendClientMessage(playerid,COLOR_GREY,"У вас не установлен левый вент");
					Player[playerid][CarSlot1Component13] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 13);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"Левый вент удален");
				}
				if (listitem == 14)
				{
				    if (Player[playerid][CarSlot1PaintJob] == -1) return SendClientMessage(playerid,COLOR_GREY,"У вас не установлено покрасочных работ");
					Player[playerid][CarSlot1PaintJob] = -1;
					DestroyVehicle(GetPlayerVehicleID(playerid));CallCar1(playerid);
					SendClientMessage(playerid,COLOR_GREY,"Покрасочные работы удалены");
				}
				if (listitem == 15)
				{
				    if (Player[playerid][CarSlot1Neon] == 0) return SendClientMessage(playerid,COLOR_GREY,"У вас не установлен неон");
					Player[playerid][CarSlot1Neon] = 0; new vehicleid = GetPlayerVehicleID(playerid);
					if (NeonObject1[vehicleid] != -1){DestroyDynamicObject(NeonObject1[vehicleid]);NeonObject1[vehicleid] = -1;}
					if (NeonObject2[vehicleid] != -1){DestroyDynamicObject(NeonObject2[vehicleid]);NeonObject2[vehicleid] = -1;}
					SendClientMessage(playerid,COLOR_GREY,"Неон удален");
				}
			}//Класс 1
            if (Player[playerid][CarActive] == 2)
			{//Класс 2
				if (listitem == 0)
				{
				    if (Player[playerid][CarSlot2Component0] == 0) return SendClientMessage(playerid,COLOR_GREY,"У вас не установлен спойлер");
					Player[playerid][CarSlot2Component0] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 0);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"Спойлер удален");
				}
				if (listitem == 1)
				{
				    if (Player[playerid][CarSlot2Component1] == 0) return SendClientMessage(playerid,COLOR_GREY,"У вас не установлен капот");
					Player[playerid][CarSlot2Component1] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 1);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"Капот удален");
				}
				if (listitem == 2)
				{
				    if (Player[playerid][CarSlot2Component2] == 0) return SendClientMessage(playerid,COLOR_GREY,"У вас не установлена крыша");
					Player[playerid][CarSlot2Component2] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 2);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"Крыша удалена");
				}
				if (listitem == 3)
				{
				    if (Player[playerid][CarSlot2Component3] == 0) return SendClientMessage(playerid,COLOR_GREY,"У вас не установлены боковые юбки");
					Player[playerid][CarSlot2Component3] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 3);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"Боковые юбки удален");
				}
				if (listitem == 4)
				{
				    if (Player[playerid][CarSlot2Component4] == 0) return SendClientMessage(playerid,COLOR_GREY,"У вас не установлены фары");
					Player[playerid][CarSlot2Component4] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 4);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"Фары удалены");
				}
				if (listitem == 5)
				{
				    if (Player[playerid][CarSlot2Component5] == 0) return SendClientMessage(playerid,COLOR_GREY,"У вас не установлено нитро");
					Player[playerid][CarSlot2Component5] = 0;Player[playerid][CarSlot2NitroX] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 5);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"Нитро удалено");
				}
				if (listitem == 6)
				{
				    if (Player[playerid][CarSlot2Component6] == 0) return SendClientMessage(playerid,COLOR_GREY,"У вас не установлена выхлопная труба");
					Player[playerid][CarSlot2Component6] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 6);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"Выхлопная труба удален");
				}
				if (listitem == 7)
				{
				    if (Player[playerid][CarSlot2Component7] == 0) return SendClientMessage(playerid,COLOR_GREY,"У вас не установлены диски");
					Player[playerid][CarSlot2Component7] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 7);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"Диски удалены");
				}
				if (listitem == 8)
				{
				    if (Player[playerid][CarSlot2Component8] == 0) return SendClientMessage(playerid,COLOR_GREY,"У вас не установлено стерео");
					Player[playerid][CarSlot2Component8] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 8);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"Стерео удалено");
				}
				if (listitem == 9)
				{
				    if (Player[playerid][CarSlot2Component9] == 0) return SendClientMessage(playerid,COLOR_GREY,"У вас не установлена гидравлика");
					Player[playerid][CarSlot2Component9] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 9);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"Гидравлика удалена");
				}
				if (listitem == 10)
				{
				    if (Player[playerid][CarSlot2Component10] == 0) return SendClientMessage(playerid,COLOR_GREY,"У вас не установлен передний бампер");
					Player[playerid][CarSlot2Component10] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 10);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"Передний бампер удален");
				}
				if (listitem == 11)
				{
				    if (Player[playerid][CarSlot2Component11] == 0) return SendClientMessage(playerid,COLOR_GREY,"У вас не установлен задний бампер");
					Player[playerid][CarSlot2Component11] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 11);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"Задний бампер удален");
				}
				if (listitem == 12)
				{
				    if (Player[playerid][CarSlot2Component12] == 0) return SendClientMessage(playerid,COLOR_GREY,"У вас не установлен правый вент");
					Player[playerid][CarSlot2Component12] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 12);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"Правый вент удален");
				}
				if (listitem == 13)
				{
				    if (Player[playerid][CarSlot2Component13] == 0) return SendClientMessage(playerid,COLOR_GREY,"У вас не установлен левый вент");
					Player[playerid][CarSlot2Component13] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 13);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"Левый вент удален");
				}
				if (listitem == 14)
				{
				    if (Player[playerid][CarSlot2PaintJob] == -1) return SendClientMessage(playerid,COLOR_GREY,"У вас не установлено покрасочных работ");
					Player[playerid][CarSlot2PaintJob] = -1;
					DestroyVehicle(GetPlayerVehicleID(playerid));CallCar2(playerid);
					SendClientMessage(playerid,COLOR_GREY,"Покрасочные работы удалены");
				}
				if (listitem == 15)
				{
				    if (Player[playerid][CarSlot2Neon] == 0) return SendClientMessage(playerid,COLOR_GREY,"У вас не установлен неон");
					Player[playerid][CarSlot2Neon] = 0; new vehicleid = GetPlayerVehicleID(playerid);
					if (NeonObject1[vehicleid] != -1){DestroyDynamicObject(NeonObject1[vehicleid]);NeonObject1[vehicleid] = -1;}
					if (NeonObject2[vehicleid] != -1){DestroyDynamicObject(NeonObject2[vehicleid]);NeonObject2[vehicleid] = -1;}
					SendClientMessage(playerid,COLOR_GREY,"Неон удален");
				}
			}//Класс 2
		    SaveTune(playerid);
		    
		    
		    //Заново показ менюшки удаления компонентов
		    new StringZ[1024];
			if (Player[playerid][CarActive] == 1)
			{//Класс 1
  				if (Player[playerid][CarSlot1Component0] == 0) strcat(StringZ, "{AFAFAF}Спойлер\n"); else strcat(StringZ, "{FFFFFF}Спойлер\n");
  				if (Player[playerid][CarSlot1Component1] == 0) strcat(StringZ, "{AFAFAF}Капот\n"); else strcat(StringZ, "{FFFFFF}Капот\n");
  				if (Player[playerid][CarSlot1Component2] == 0) strcat(StringZ, "{AFAFAF}Крыша\n"); else strcat(StringZ, "{FFFFFF}Крыша\n");
  				if (Player[playerid][CarSlot1Component3] == 0) strcat(StringZ, "{AFAFAF}Боковые юбки\n"); else strcat(StringZ, "{FFFFFF}Боковые юбки\n");
  				if (Player[playerid][CarSlot1Component4] == 0) strcat(StringZ, "{AFAFAF}Фары\n"); else strcat(StringZ, "{FFFFFF}Фары\n");
  				if (Player[playerid][CarSlot1Component5] == 0) strcat(StringZ, "{AFAFAF}Нитро\n"); else strcat(StringZ, "{FFFFFF}Нитро\n");
  				if (Player[playerid][CarSlot1Component6] == 0) strcat(StringZ, "{AFAFAF}Выхлопная труба\n"); else strcat(StringZ, "{FFFFFF}Выхлопная труба\n");
  				if (Player[playerid][CarSlot1Component7] == 0) strcat(StringZ, "{AFAFAF}Диски\n"); else strcat(StringZ, "{FFFFFF}Диски\n");
  				if (Player[playerid][CarSlot1Component8] == 0) strcat(StringZ, "{AFAFAF}Стерео\n"); else strcat(StringZ, "{FFFFFF}Стерео\n");
  				if (Player[playerid][CarSlot1Component9] == 0) strcat(StringZ, "{AFAFAF}Гидравлика\n"); else strcat(StringZ, "{FFFFFF}Гидравлика\n");
  				if (Player[playerid][CarSlot1Component10] == 0) strcat(StringZ, "{AFAFAF}Передний бампер\n"); else strcat(StringZ, "{FFFFFF}Передний бампер\n");
  				if (Player[playerid][CarSlot1Component11] == 0) strcat(StringZ, "{AFAFAF}Задний бампер\n"); else strcat(StringZ, "{FFFFFF}Задний бампер\n");
  				if (Player[playerid][CarSlot1Component12] == 0) strcat(StringZ, "{AFAFAF}Правый вент\n"); else strcat(StringZ, "{FFFFFF}Правый вент\n");
  				if (Player[playerid][CarSlot1Component13] == 0) strcat(StringZ, "{AFAFAF}Левый вент\n"); else strcat(StringZ, "{FFFFFF}Левый вент\n");
                if (Player[playerid][CarSlot1PaintJob] == -1) strcat(StringZ, "{AFAFAF}Покрасочные работы\n"); else strcat(StringZ, "{FFFFFF}Покрасочные работы\n");
                if (Player[playerid][CarSlot1Neon] == 0) strcat(StringZ, "{AFAFAF}Неон\n"); else strcat(StringZ, "{FFFFFF}Неон\n");
				return ShowPlayerDialog(playerid, DIALOG_TURBOSPEEDDELETE, 2, "Удалить компонент", StringZ, "Удалить", "Назад");
			}//Класс 1
  			if (Player[playerid][CarActive] == 2)
			{//Класс 2
				if (Player[playerid][CarSlot2Component0] == 0) strcat(StringZ, "{AFAFAF}Спойлер\n"); else strcat(StringZ, "{FFFFFF}Спойлер\n");
  				if (Player[playerid][CarSlot2Component1] == 0) strcat(StringZ, "{AFAFAF}Капот\n"); else strcat(StringZ, "{FFFFFF}Капот\n");
  				if (Player[playerid][CarSlot2Component2] == 0) strcat(StringZ, "{AFAFAF}Крыша\n"); else strcat(StringZ, "{FFFFFF}Крыша\n");
  				if (Player[playerid][CarSlot2Component3] == 0) strcat(StringZ, "{AFAFAF}Боковые юбки\n"); else strcat(StringZ, "{FFFFFF}Боковые юбки\n");
  				if (Player[playerid][CarSlot2Component4] == 0) strcat(StringZ, "{AFAFAF}Фары\n"); else strcat(StringZ, "{FFFFFF}Фары\n");
  				if (Player[playerid][CarSlot2Component5] == 0) strcat(StringZ, "{AFAFAF}Нитро\n"); else strcat(StringZ, "{FFFFFF}Нитро\n");
  				if (Player[playerid][CarSlot2Component6] == 0) strcat(StringZ, "{AFAFAF}Выхлопная труба\n"); else strcat(StringZ, "{FFFFFF}Выхлопная труба\n");
  				if (Player[playerid][CarSlot2Component7] == 0) strcat(StringZ, "{AFAFAF}Диски\n"); else strcat(StringZ, "{FFFFFF}Диски\n");
  				if (Player[playerid][CarSlot2Component8] == 0) strcat(StringZ, "{AFAFAF}Стерео\n"); else strcat(StringZ, "{FFFFFF}Стерео\n");
  				if (Player[playerid][CarSlot2Component9] == 0) strcat(StringZ, "{AFAFAF}Гидравлика\n"); else strcat(StringZ, "{FFFFFF}Гидравлика\n");
  				if (Player[playerid][CarSlot2Component10] == 0) strcat(StringZ, "{AFAFAF}Передний бампер\n"); else strcat(StringZ, "{FFFFFF}Передний бампер\n");
  				if (Player[playerid][CarSlot2Component11] == 0) strcat(StringZ, "{AFAFAF}Задний бампер\n"); else strcat(StringZ, "{FFFFFF}Задний бампер\n");
  				if (Player[playerid][CarSlot2Component12] == 0) strcat(StringZ, "{AFAFAF}Правый вент\n"); else strcat(StringZ, "{FFFFFF}Правый вент\n");
  				if (Player[playerid][CarSlot2Component13] == 0) strcat(StringZ, "{AFAFAF}Левый вент\n"); else strcat(StringZ, "{FFFFFF}Левый вент\n");
                if (Player[playerid][CarSlot2PaintJob] == -1) strcat(StringZ, "{AFAFAF}Покрасочные работы\n"); else strcat(StringZ, "{FFFFFF}Покрасочные работы\n");
                if (Player[playerid][CarSlot2Neon] == 0) strcat(StringZ, "{AFAFAF}Неон\n"); else strcat(StringZ, "{FFFFFF}Неон\n");
				return ShowPlayerDialog(playerid, DIALOG_TURBOSPEEDDELETE, 2, "Удалить компонент", StringZ, "Удалить", "Назад");
			}//Кдасс 2
		}//Автомастерская TurboSpeed - Удалить компонент
		
		case DIALOG_TURBOSPEEDNITRO:
		{//Автомастерская TurboSpeed - Нитро
		    	if (!response) return ShowPlayerDialog(playerid, DIALOG_TURBOSPEED, 2, "Автомастерская TurboSpeed", "Нитро\nНеон\n{FF0000}Удалить компонент тюнинга", "ОК", "Отмена");
                if (Player[playerid][CarActive] < 1 || Player[playerid][CarActive] > 2) return SendClientMessage(playerid,COLOR_RED,"Установить нитро можно только на личный автомобиль 1-го или 2-го класса!");
				if (listitem == 0)
				{//Бесконечное нитро
				    if (Player[playerid][CarActive] > 0 && Player[playerid][CarActive] < 3)
				    {//игрок в авто класса 1, 2
				        if (Player[playerid][Cash] < 50000) return SendClientMessage(playerid, COLOR_RED, "Для покупки Бесконечного Нитро нужно 50 000$");
        				if (Player[playerid][Level] < 65) return SendClientMessage(playerid, COLOR_RED, "Вы должны быть как минимум 65-го уровня");
					    if (Player[playerid][CarActive] == 1)
				        {
				            Player[playerid][CarSlot1Component5] = 1010; Player[playerid][CarSlot1NitroX] = 1;AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
							SendClientMessage(playerid, COLOR_YELLOW, "Вы приобрели Бесконечное Нитро за 50 000$ для автомобиля 1-го класса.");
				        }
				        else if (Player[playerid][CarActive] == 2)
				        {
				            Player[playerid][CarSlot2Component5] = 1010; Player[playerid][CarSlot2NitroX] = 1;AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
				            SendClientMessage(playerid, COLOR_YELLOW, "Вы приобрели Бесконечное Нитро за 50 000$ для автомобиля 2-го класса.");
				        }
				        Player[playerid][Cash] -= 50000;SaveTune(playerid);
				    }//игрок в авто класса 1, 2
				}//Бесконечное нитро
				if (listitem == 1)
				{//UberNitro
				    if (Player[playerid][CarActive] > 0 && Player[playerid][CarActive] < 3)
				    {//игрок в авто класса 1, 2
				        if (Player[playerid][Cash] < 300000) return SendClientMessage(playerid, COLOR_RED, "Для покупки UberНитро нужно 300 000$");
			            if (Player[playerid][Level] < 80) return SendClientMessage(playerid, COLOR_RED, "Вы должны быть как минимум 80-го уровня");
					    if (Player[playerid][CarActive] == 1)
				        {
				            Player[playerid][CarSlot1Component5] = 1010; Player[playerid][CarSlot1NitroX] = 2;AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
							SendClientMessage(playerid, COLOR_YELLOW, "Вы приобрели Бесконечное UberNitro за 300 000$ для автомобиля 1-го класса.");
				        }
				        else if (Player[playerid][CarActive] == 2)
				        {
				            Player[playerid][CarSlot2Component5] = 1010; Player[playerid][CarSlot2NitroX] = 2;AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
				            SendClientMessage(playerid, COLOR_YELLOW, "Вы приобрели Бесконечное UberNitro за 300 000$ для автомобиля 2-го класса.");
				        }
				        Player[playerid][Cash] -= 300000;SaveTune(playerid);
					}//игрок в авто класса 1,2
				}//UberNitro
		}//Автомастерская TurboSpeed - Нитро
		
		case DIALOG_TURBOSPEEDNEON:
		{//Автомастерская TurboSpeed - Неон
		    if (!response) return ShowPlayerDialog(playerid, DIALOG_TURBOSPEED, 2, "Автомастерская TurboSpeed", "Нитро\nНеон\n{FF0000}Удалить компонент тюнинга", "ОК", "Отмена");
			if (Player[playerid][Prestige] < 4) return SendClientMessage(playerid,COLOR_RED, "Вы должны быть как минимум 4 уровня Престижа чтобы установить неон");
			if (Player[playerid][Cash] < 50000) return SendClientMessage(playerid, COLOR_RED, "Для покупки неона нужно 50 000$");
            if (Player[playerid][CarActive] < 1 || Player[playerid][CarActive] > 2) return SendClientMessage(playerid,COLOR_RED,"Установить неон можно только на личный автомобиль 1-го или 2-го класса!");

			new model = GetVehicleModel(GetPlayerVehicleID(playerid));
			switch (model)
			{
			    case 417, 425, 447, 460, 469, 476, 487, 488, 497, 511, 512, 513, 519, 520, 548, 553, 563, 577, 592, 593, //Air
			    509, 481, 510, 462, 448, 581, 522, 461, 521, 523, 463, 486, 468, 471, /*Bikes*/ 472, 473, 493, 595, 484, 430, 453, 452, 446, 454, //Boats
			    435, 441, 449, 450, 464, 465, 501, 530, 485, 457, 532, 537, 538, 564, 569, 570, 571, 572, 584, 590, 591, 594, 606, 607, 608, 610, 611: //Прочее
			    return SendClientMessage(playerid, COLOR_RED, "Нельзя установить неон на эту модель транспорта!");
			}

			if (Player[playerid][CarActive] == 1)
			{//авто класса 1
				switch(listitem)
				{
				    case 0: Player[playerid][CarSlot1Neon] = 18647; case 1: Player[playerid][CarSlot1Neon] = 18648; case 2: Player[playerid][CarSlot1Neon] = 18649;
				    case 3: Player[playerid][CarSlot1Neon] = 18650; case 4: Player[playerid][CarSlot1Neon] = 18651; case 5: Player[playerid][CarSlot1Neon] = 18652;
				}
			    new vehicleid = PlayerCarID[playerid];
			   	if (NeonObject1[vehicleid] != -1) DestroyDynamicObject(NeonObject1[vehicleid]);
				if (NeonObject2[vehicleid] != -1) DestroyDynamicObject(NeonObject2[vehicleid]);
			    NeonObject1[vehicleid] = CreateDynamicObject(Player[playerid][CarSlot1Neon], 0, 0, 0, 0, 0, 0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 300.0);
			    NeonObject2[vehicleid] = CreateDynamicObject(Player[playerid][CarSlot1Neon], 0, 0, 0, 0, 0, 0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 300.0);
			    AttachDynamicObjectToVehicle(NeonObject1[vehicleid], vehicleid, -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
			    AttachDynamicObjectToVehicle(NeonObject2[vehicleid], vehicleid, 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
			    SendClientMessage(playerid, COLOR_YELLOW, "Вы приобрели неон за 50 000$ для автомобиля 1-го класса.");
			}//авто класса 1
			if (Player[playerid][CarActive] == 2)
			{//авто класса 2
				switch(listitem)
				{
				    case 0: Player[playerid][CarSlot2Neon] = 18647; case 1: Player[playerid][CarSlot2Neon] = 18648; case 2: Player[playerid][CarSlot2Neon] = 18649;
				    case 3: Player[playerid][CarSlot2Neon] = 18650; case 4: Player[playerid][CarSlot2Neon] = 18651; case 5: Player[playerid][CarSlot2Neon] = 18652;
				}
			    new vehicleid = PlayerCarID[playerid];
			   	if (NeonObject1[vehicleid] != -1) DestroyDynamicObject(NeonObject1[vehicleid]);
				if (NeonObject2[vehicleid] != -1) DestroyDynamicObject(NeonObject2[vehicleid]);
			    NeonObject1[vehicleid] = CreateDynamicObject(Player[playerid][CarSlot2Neon], 0, 0, 0, 0, 0, 0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 300.0);
			    NeonObject2[vehicleid] = CreateDynamicObject(Player[playerid][CarSlot2Neon], 0, 0, 0, 0, 0, 0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 300.0);
			    AttachDynamicObjectToVehicle(NeonObject1[vehicleid], vehicleid, -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
			    AttachDynamicObjectToVehicle(NeonObject2[vehicleid], vehicleid, 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
			    SendClientMessage(playerid, COLOR_YELLOW, "Вы приобрели неон за 50 000$ для автомобиля 2-го класса.");
			}//авто класса 2
			Player[playerid][Cash] -= 50000; SaveTune(playerid);
		}//Автомастерская TurboSpeed - Неон
		
		case DIALOG_GPS:
		{//GPS
		    if (!response) return 1;
		    if (InEvent[playerid] > 0) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: GPS недоступно в соревнованиях.");
		    if (QuestActive[playerid] > 0) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: GPS недоступно на работе и при выполнении заданий.");
		    if (listitem == 0)
			{//Работа
			    new String[1024];
			    strcat(String, "{00CCCC}Ур. 1: {FFFFFF}Доставщик Пиццы (2400 XP, 144 000$)\n{00CCCC}Ур. 1: {FFFFFF}Грузчик (2700 XP, 108 000$)\n{00CCCC}Ур. 14: {FFFFFF}Домушник (2880 XP, 360 000$)\n{00CCCC}Ур. 21: {FFFFFF}Комбайнер (3240 XP, 270 000$)");
				strcat(String, "\n{00CCCC}Ур. 28: {FFFFFF}Дальнобойщик (3420 XP, 540 000$)\n{00CCCC}Ур. 35: {FFFFFF}Капитан Корабля (3600 XP, 396 000$)\n{00CCCC}Ур. 42: {FFFFFF}Инкассатор (2400 XP, 900 000$)");
				return ShowPlayerDialog(playerid, DIALOG_GPSWORK, 2, "GPS - Работа", String, "ОК", "Назад");//Работа
			}//Работа
			if (listitem == 1)
			{//Банк
			    new Closest = 0, Float: fDistance = 99999999.9;
                for(new i = 0; i < 6; i++)
				{//цикл - находим ближайший банк
				    if (GetPlayerDistanceFromPoint(playerid, BANKENTERS[i][0], BANKENTERS[i][1], BANKENTERS[i][2]) < fDistance)
				    {//Расстояние до банка i меньше, чем fDistance
				        fDistance = GetPlayerDistanceFromPoint(playerid, BANKENTERS[i][0], BANKENTERS[i][1], BANKENTERS[i][2]);
				        Closest = i;
				    }//Расстояние до банка i меньше, чем fDistance
				}//цикл - находим ближайший банк
			    SetPlayerCheckpoint(playerid, BANKENTERS[Closest][0], BANKENTERS[Closest][1], BANKENTERS[Closest][2], 5); GPSUsed[playerid] = 1;
				SendClientMessage(playerid, COLOR_RED, "GPS:{FFFF00} Ближайший банк был отмечен на радаре {FF0000}красным маркером{FFFF00}.");
				return PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
			}//Банк
			if (listitem == 2)
			{//Казино
			    SetPlayerCheckpoint(playerid, 2019.3174, 1007.8547, 10.8203, 5); GPSUsed[playerid] = 1;
				SendClientMessage(playerid, COLOR_RED, "GPS:{FFFF00} Казино было отмечено на радаре {FF0000}красным маркером{FFFF00}.");
				return PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
			}//Казино
		    if (listitem == 3) return ShowPlayerDialog(playerid, DIALOG_GPSTUNE, 2, "GPS - Автомастерские", "Transfender ({AFAFAF}для большинства машин{FFFFFF})\nLowrider\nArch Angels\nTurboSpeed", "ОК", "Назад");//Автомастерские
			if (listitem == 4)
			{//Магазин Одежды
			    new Closest = 0, Float: fDistance = 99999999.9;
                for(new i = 0; i < 4; i++)
				{//цикл - находим ближайший магазин одежды
				    if (GetPlayerDistanceFromPoint(playerid, CLOTHESENTERS[i][0], CLOTHESENTERS[i][1], CLOTHESENTERS[i][2]) < fDistance)
				    {//Расстояние до магазина i меньше, чем fDistance
				        fDistance = GetPlayerDistanceFromPoint(playerid, CLOTHESENTERS[i][0], CLOTHESENTERS[i][1], CLOTHESENTERS[i][2]);
				        Closest = i;
				    }//Расстояние до магазина i меньше, чем fDistance
				}//цикл - находим ближайший магазин одежды
			    SetPlayerCheckpoint(playerid, CLOTHESENTERS[Closest][0], CLOTHESENTERS[Closest][1], CLOTHESENTERS[Closest][2], 5); GPSUsed[playerid] = 1;
				SendClientMessage(playerid, COLOR_RED, "GPS:{FFFF00} Ближайший магазин одежды был отмечен на радаре {FF0000}красным маркером{FFFF00}.");
				return PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
			}//Магазин Одежды
			if (listitem == 5)
			{//Аэропорт
			    new Closest = 0, Float: fDistance = 99999999.9;
                for(new i = 0; i < 3; i++)
				{//цикл - находим ближайший магазин одежды
				    if (GetPlayerDistanceFromPoint(playerid, AIRPORTENTERS[i][0], AIRPORTENTERS[i][1], AIRPORTENTERS[i][2]) < fDistance)
				    {//Расстояние до магазина i меньше, чем fDistance
				        fDistance = GetPlayerDistanceFromPoint(playerid, AIRPORTENTERS[i][0], AIRPORTENTERS[i][1], AIRPORTENTERS[i][2]);
				        Closest = i;
				    }//Расстояние до магазина i меньше, чем fDistance
				}//цикл - находим ближайший магазин одежды
			    SetPlayerCheckpoint(playerid, AIRPORTENTERS[Closest][0], AIRPORTENTERS[Closest][1], AIRPORTENTERS[Closest][2], 5); GPSUsed[playerid] = 1;
				SendClientMessage(playerid, COLOR_RED, "GPS:{FFFF00} Ближайший аэропорт был отмечен на радаре {FF0000}красным маркером{FFFF00}.");
				return PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
			}//Аэропорт
			if (listitem == 6)
			{//Личный Дом
				if (Player[playerid][Home] == 0) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: У вас нет дома!");
				new houseid = Player[playerid][Home];
				SetPlayerCheckpoint(playerid, Property[houseid][pPosEnterX], Property[houseid][pPosEnterY], Property[houseid][pPosEnterZ], 5); GPSUsed[playerid] = 1;
				SendClientMessage(playerid, COLOR_RED, "GPS:{FFFF00} Ваш дом был отмечен на радаре {FF0000}красным маркером{FFFF00}.");
				return PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
			}//Личный Дом
			if (listitem == 7)
			{//Штаб Клана
				if (Player[playerid][MyClan] == 0) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы не состоите в клане!");
				new clanid = Player[playerid][MyClan], baseid = Clan[clanid][cBase];
				if (baseid <= 0) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: У вашего клана нет штаба!");
				SetPlayerCheckpoint(playerid, Base[baseid][bPosEnterX], Base[baseid][bPosEnterY], Base[baseid][bPosEnterZ], 5); GPSUsed[playerid] = 1;
				SendClientMessage(playerid, COLOR_RED, "GPS:{FFFF00} Штаб вашего клана был отмечен на радаре {FF0000}красным маркером{FFFF00}.");
				return PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
			}//Штаб Клана
			if (listitem == 8)
		    {//Убрать отметку
		        if (GPSUsed[playerid] == 0) return SendClientMessage(playerid, COLOR_RED, "GPS:{FFFF00} На вашем радаре не установлено никаких маркеров.");
		        DisablePlayerCheckpoint(playerid); GPSUsed[playerid] = 0;
		        return SendClientMessage(playerid, COLOR_RED, "GPS:{FFFF00} Маркер успешно удален.");
		    }//Убрать отметку
		}//GPS
		
		case DIALOG_GPSWORK:
		{//GPS - Работа
		    if (!response) return SendCommand(playerid, "/gps", "");
		    if (InEvent[playerid] > 0) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: GPS недоступно в соревнованиях.");
		    if (QuestActive[playerid] > 0) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: GPS недоступно на работе и при выполнении заданий.");
		    if (listitem == 0)
			{//Доставщик пиццы
			    SetPlayerCheckpoint(playerid, 2397.7632, -1899.1389, 13.5469, 5); GPSUsed[playerid] = 1;
				SendClientMessage(playerid, COLOR_RED, "GPS:{FFFF00} Работа <<Доставщик Пиццы>> была отмечена на радаре {FF0000}красным маркером{FFFF00}.");
				return PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
			}//Доставщик пиццы
			if (listitem == 1)
			{//Грузчик
			    SetPlayerCheckpoint(playerid, 2729.3267, -2451.4578, 17.5937, 5); GPSUsed[playerid] = 1;
				SendClientMessage(playerid, COLOR_RED, "GPS:{FFFF00} Работа <<Грузчик>> была отмечена на радаре {FF0000}красным маркером{FFFF00}.");
				return PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
			}//Грузчик
			if (listitem == 2)
			{//Домушник
			    SetPlayerCheckpoint(playerid, -1972.5024, -1020.2568, 32.1719, 5); GPSUsed[playerid] = 1;
				SendClientMessage(playerid, COLOR_RED, "GPS:{FFFF00} Работа <<Домушник>> была отмечена на радаре {FF0000}красным маркером{FFFF00}.");
				return PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
			}//Домушник
			if (listitem == 3)
			{//Комбайнер
			    SetPlayerCheckpoint(playerid, -1061.6104, -1195.4755, 129.8281, 5); GPSUsed[playerid] = 1;
				SendClientMessage(playerid, COLOR_RED, "GPS:{FFFF00} Работа <<Комбайнер>> была отмечена на радаре {FF0000}красным маркером{FFFF00}.");
				return PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
			}//Комбайнер
			if (listitem == 4)
			{//Дальнобойщик
			    SetPlayerCheckpoint(playerid, 2484.6682, -2120.8743, 13.5469, 5); GPSUsed[playerid] = 1;
				SendClientMessage(playerid, COLOR_RED, "GPS:{FFFF00} Работа <<Дальнобойщик>> была отмечена на радаре {FF0000}красным маркером{FFFF00}.");
				return PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
			}//Дальнобойщик
			if (listitem == 5)
			{//Капитан корабля
			    SetPlayerCheckpoint(playerid, -1713.1389, -61.8556, 3.5547, 5); GPSUsed[playerid] = 1;
				SendClientMessage(playerid, COLOR_RED, "GPS:{FFFF00} Работа <<Капитан Корабля>> была отмечена на радаре {FF0000}красным маркером{FFFF00}.");
				return PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
			}//Капитан корабля
			if (listitem == 6)
			{//Инкассатор
			    SetPlayerCheckpoint(playerid, 2364.8955, 2382.8770, 10.8203, 5); GPSUsed[playerid] = 1;
				SendClientMessage(playerid, COLOR_RED, "GPS:{FFFF00} Работа <<Инкассатор>> была отмечена на радаре {FF0000}красным маркером{FFFF00}.");
				return PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
			}//Инкассатор
		}//GPS - Работа
		
		case DIALOG_GPSTUNE:
		{//GPS - Автомастерские
		    if (!response) return SendCommand(playerid, "/gps", "");
		    if (InEvent[playerid] > 0) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: GPS недоступно в соревнованиях.");
		    if (QuestActive[playerid] > 0) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: GPS недоступно на работе и при выполнении заданий.");
		    if (listitem == 0)
			{//Transfender
			    new Closest = 0, Float: fDistance = 99999999.9;
                for(new i = 0; i < 3; i++)
				{//цикл - находим ближайшую автомастерскую Transfender
				    if (GetPlayerDistanceFromPoint(playerid, TRANSFENDER[i][0], TRANSFENDER[i][1], TRANSFENDER[i][2]) < fDistance)
				    {//Расстояние до transfender i меньше, чем fDistance
				        fDistance = GetPlayerDistanceFromPoint(playerid, TRANSFENDER[i][0], TRANSFENDER[i][1], TRANSFENDER[i][2]);
				        Closest = i;
				    }//Расстояние до transfender i меньше, чем fDistance
				}//цикл - находим ближайшую автомастерскую Transfender
			    SetPlayerCheckpoint(playerid, TRANSFENDER[Closest][0], TRANSFENDER[Closest][1], TRANSFENDER[Closest][2], 5); GPSUsed[playerid] = 1;
				SendClientMessage(playerid, COLOR_RED, "GPS:{FFFF00} Ближайшая автомастерская Transfender была отмечена на радаре {FF0000}красным маркером{FFFF00}.");
				return PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
			}//Transfender
		    if (listitem == 1)
			{//Lowrider
			    SetPlayerCheckpoint(playerid, 2645.1233, -2034.3359, 13.5540, 5); GPSUsed[playerid] = 1;
				SendClientMessage(playerid, COLOR_RED, "GPS:{FFFF00} Автомастерская Lowrider была отмечена на радаре {FF0000}красным маркером{FFFF00}.");
				return PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
			}//Lowrider
		    if (listitem == 2)
			{//Arch Angels
			    SetPlayerCheckpoint(playerid, -2711.2119, 217.4269, 4.1955, 5); GPSUsed[playerid] = 1;
				SendClientMessage(playerid, COLOR_RED, "GPS:{FFFF00} Автомастерская Arch Angels была отмечена на радаре {FF0000}красным маркером{FFFF00}.");
				return PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
			}//Arch Angels
		    if (listitem == 3)
			{//TurboSpeed
			    SetPlayerCheckpoint(playerid, -2026.9071, 133.2521, 28.8359, 5); GPSUsed[playerid] = 1;
				SendClientMessage(playerid, COLOR_RED, "GPS:{FFFF00} Автомастерская TurboSpeed была отмечена на радаре {FF0000}красным маркером{FFFF00}.");
				return PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
			}//TurboSpeed
		}//GPS - Автомастерские
		
        case DIALOG_WORKGRUZSTOP:
        {//прекращении работы грузчика
        	if(!response) return 1;
            SendClientMessage(playerid,COLOR_QUEST,"Работа <<{FFFFFF}Грузчик{FFCC00}>> прервана.");// Выводим текст
            DisablePlayerCheckpoint(playerid); QuestActive[playerid] = 0;
            ApplyAnimation(playerid,"PED","IDLE_tired",4.1,0,1,1,0,1);// Обнуляем анимацию
            RemovePlayerAttachedObject(playerid,0);// Удаляем объект из рук
            DeletePVar(playerid,"WorkStage");// Удаляем PVar с моментом работы
            DeletePVar(playerid,"WorkCount");// Удаляем PVar с колличеством вещей
        }//прекращении работы грузчика
        
        case DIALOG_WORKSTOP:
        {//Вызов рабочего транспорта или прекращение работы
            if (!response) return 1;
            if (listitem == 0)
            {//Вызов рабочего транспорта
                if (TimeTransform[playerid] > 0){new String[120];format(String,sizeof(String),"Вы не можете вызывать транспорт еще {FFFFFF}%d{FF0000} секунд",TimeTransform[playerid]);return SendClientMessage(playerid,COLOR_RED,String);}
				if (GetPlayerInterior(playerid) != 0 || IsPlayerInRangeOfPoint(playerid, 13.0, 2311.6953,-7.4206,26.7422)) return SendClientMessage(playerid, COLOR_RED, "Нельзя вызывать транспорт в помещениях!");//Игрок в интерьерах или в банке
                new Float: x, Float: y, Float: z, Float: angle; GetPlayerPos(playerid, x, y, z); GetPlayerFacingAngle(playerid, angle);
                if (QuestActive[playerid] == 2) QuestCar[playerid] = LCreateVehicle(448, x, y, z, angle, 3, 3, 0);
                if (QuestActive[playerid] == 4) QuestCar[playerid] = LCreateVehicle(609, x, y, z, angle, 25, 25, 0);
 				if (QuestActive[playerid] == 5) QuestCar[playerid] = LCreateVehicle(532, x, y, z + 1, angle, 25, 25, 0);
 				if (QuestActive[playerid] == 6) {QuestCar[playerid] = LCreateVehicle(515, x, y, z + 1, angle, 4, 4, 0); if (GetPVarInt(playerid, "WorkTruckStage") == 1) CallTrailer(QuestCar[playerid], 584);}
                if (QuestActive[playerid] == 7) QuestCar[playerid] = LCreateVehicle(452, x, y, z + 1, angle, 1, 2, 0);
                if (QuestActive[playerid] == 8) QuestCar[playerid] = LCreateVehicle(428, x, y, z + 1, angle, 227, 4, 0);
				PutPlayerInVehicle(playerid,QuestCar[playerid], 0); TimeTransform[playerid] = 3;
            }//Вызов рабочего транспорта
            if (listitem == 1)
            {//Прервать работу
				if (QuestActive[playerid] == 2) SendClientMessage(playerid,COLOR_QUEST,"Работа <<{FFFFFF}Доставщик Пиццы{FFCC00}>> прервана.");
                if (QuestActive[playerid] == 4)
                {
                    RemovePlayerAttachedObject(playerid,0); DeletePVar(playerid,"WorkDomStage");
                    SendClientMessage(playerid,COLOR_QUEST,"Работа <<{FFFFFF}Домушник{FFCC00}>> прервана.");
                }
                if (QuestActive[playerid] == 5)
                {
                    GangZoneHideForPlayer(playerid,WorkZoneCombine);
                    SendClientMessage(playerid,COLOR_QUEST,"Работа <<{FFFFFF}Комбайнер{FFCC00}>> прервана.");
                }
                if (QuestActive[playerid] == 6)
				{
				    DeletePVar(playerid,"WorkTruckStage");
					SendClientMessage(playerid,COLOR_QUEST,"Работа <<{FFFFFF}Дальнобойщик{FFCC00}>> прервана.");
				}
				if (QuestActive[playerid] == 7)
				{
				    DeletePVar(playerid,"WorkWaterStage");
					SendClientMessage(playerid,COLOR_QUEST,"Работа <<{FFFFFF}Капитан Корабля{FFCC00}>> прервана.");
				}
				if (QuestActive[playerid] == 8)
                {
                    DeletePVar(playerid,"WorkBankStage");
                    SendClientMessage(playerid,COLOR_QUEST,"Работа <<{FFFFFF}Инкассатор{FFCC00}>> прервана.");
                }
				QuestActive[playerid] = 0; DisablePlayerCheckpoint(playerid); DisablePlayerRaceCheckpoint(playerid);
            }//Прервать работу
        }//Вызов рабочего транспорта или прекращение работы
        
        case DIALOG_LEAVEZM:
        {//Покинуть Зомби-Выживание?
            if (!response) return 1;
            JoinEvent[playerid] = 0; InEvent[playerid] = 0; ZMStarted[playerid] = 0; ZMIsPlayerIsZombie[playerid] = 0; ZMIsPlayerIsTank[playerid] = 0;
			SendClientMessage(playerid,COLOR_ZOMBIE,"Вы покинули зомби-выживание.");
			GangZoneHideForPlayer(playerid,ZMZone1);GangZoneHideForPlayer(playerid,ZMZone2);GangZoneHideForPlayer(playerid,ZMZone3);GangZoneHideForPlayer(playerid,ZMZone4);GangZoneHideForPlayer(playerid,ZMZone5);
			GangZoneHideForPlayer(playerid,ZMZone6);GangZoneHideForPlayer(playerid,ZMZone7);GangZoneHideForPlayer(playerid,ZMZone8);GangZoneHideForPlayer(playerid,ZMZone9);GangZoneHideForPlayer(playerid,ZMZone10);
			ZMPlayers--; Player[playerid][LeaveZM] = 3600;//Запрещаем час ходить на зомби
			SetPlayerVirtualWorld(playerid,0);ResetPlayerWeapons(playerid);LSpawnPlayer(playerid);
			new String[120]; format(String,sizeof(String),"%s[%d] покинул зомби-выживание.", PlayerName[playerid], playerid);
			foreach(Player, cid) if (cid != playerid && JoinEvent[cid] == EVENT_ZOMBIE) SendClientMessage(cid,COLOR_ZOMBIE,String);
        }//Покинуть Зомби-Выживание?

		case DIALOG_CLANRENAME:
		{//переименовать клан
			if(response)
			{//респонс
				if(!strlen(inputtext) || strlen(inputtext) < 2 || strlen(inputtext) > 20) return ShowPlayerDialog(playerid, DIALOG_CLANRENAME, 1, "Введите название клана", "{FF0000}ОШИБКА: Неверная длина названия..\n\n{FFFFFF}Введите название клана.\n{008E00}[Длина от 2 до 20 символов]", "ОК", "Отмена"); //если длина некорректна

				new AllowName = 1;
			    for (new i; i < strlen(inputtext); i++)
				{//Проверка каждого символа в нике на допустимость
				    if (inputtext[i] >= '0' && inputtext[i] <= '9') continue;
				    if (inputtext[i] >= 'A' && inputtext[i] <= 'Z') continue;
				    if (inputtext[i] >= 'a' && inputtext[i] <= 'z') continue;
                    if (inputtext[i] == '_') continue;
				    AllowName = 0;
				}//Проверка каждого символа в нике на допустимость
				if (!AllowName)  return ShowPlayerDialog(playerid, DIALOG_CLANRENAME, 1, "Введите название клана", "{FF0000}ОШИБКА: В названии допускаются только латинские буквы, цифры и символ '_'.\n\n{FFFFFF}Введите название клана.\n{008E00}[Длина от 2 до 20 символов]", "ОК", "Отмена");

				for(new i = 1; i < MAX_CLAN; i++)
				{//все возможные id`ы кланов
					if (Clan[i][cLevel] == 0) continue; //Пропускаем несуществующие кланы
                    if(!strcmp(Clan[i][cName], inputtext, true)) return ShowPlayerDialog(playerid, DIALOG_CLANRENAME, 1, "Введите название клана", "{FF0000}ОШИБКА: Клан с таким именем уже существует.\n\n{FFFFFF}Введите название клана.\n{008E00}[Длина от 2 до 20 символов]", "ОК", "Отмена");
				}//все возможные id`ы кланов
				if (Player[playerid][Cash] < 500000) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: У вас нет {FFFFFF}500 000{FF0000}$");
				Player[playerid][Cash] -= 500000;

				new clanid = Player[playerid][MyClan];
                strmid(Clan[clanid][cName], inputtext, 0, strlen(inputtext), 20);
				SaveClan(clanid); SavePlayer(playerid);
				
				if (Clan[clanid][cBase] > 0 && Clan[clanid][cBase] < MAX_BASE)
				{//У клана есть штаб
				    new baseid = Clan[clanid][cBase], text3d[MAX_3DTEXT];
				    format(text3d, sizeof(text3d), "{007FFF}Штаб ({FFFFFF}%d${007FFF})\n{008E00}Клан:{FFFFFF} %s\nНажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать", Base[baseid][bPrice], Clan[clanid][cName]);
					UpdateDynamic3DTextLabelText(BaseText3D[baseid], 0xFFFFFFFF, text3d);
				}//У клана есть штаб

				new ChatMes[120]; format(ChatMes, sizeof(ChatMes), "{008E00}Вы изменили название клана на '{FFFFFF}%s{008E00}'", inputtext);
				SendClientMessage(playerid,COLOR_GREEN, ChatMes);
			}//респонс
		}//ввод названия клана
		
		case DIALOG_BASEMENUPRICE:
		{//цена дома
			if(response)
			{//респонс
			    new clanid = Player[playerid][MyClan], baseid = Clan[clanid][cBase], entered = strval(inputtext);
			    if (baseid <= 0 ||Base[baseid][bClan] != clanid) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Это не ваш штаб");
			    if (Player[playerid][Leader] < 100) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Только лидер клана может увеличить цену штаба");
				if (entered <= 0) return SendClientMessage(playerid,COLOR_RED,"Введенная сумма некорректна");
				if (entered > Player[playerid][Cash]) entered = Player[playerid][Cash];
				new BankFree = 80000000 - Base[baseid][bPrice]; if (BankFree < entered) entered = BankFree;
				if (entered == 0) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Стоимость штаба уже достигла максимума");
				Base[baseid][bPrice] += entered;Player[playerid][Cash] -= entered; SavePlayer(playerid); SaveBase(baseid);
				new text3d[MAX_3DTEXT], String[140], ccolor = Clan[clanid][cColor];
				format(text3d, sizeof(text3d), "{007FFF}Штаб ({FFFFFF}%d${007FFF})\n{008E00}Клан:{FFFFFF} %s\nНажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать", Base[baseid][bPrice], Clan[clanid][cName]);
				UpdateDynamic3DTextLabelText(BaseText3D[baseid], 0xFFFFFFFF, text3d);
				format(String,sizeof(String),"%s[%d] увеличил цену штаба на %d$", PlayerName[playerid], playerid, entered);
				foreach(Player, cid) if (Player[cid][Member] != 0 && Player[cid][MyClan] == Player[playerid][MyClan] && Logged[cid] == 1) SendClientMessage(cid,ClanColor[ccolor],String);
			}//респонс
			else ShowPlayerDialog(playerid, DIALOG_BASEMENU, 2, "{007FFF}Штаб", "{008D00}Войти в штаб{FFFFFF}\nИнформация о штабе\nКупить штаб\nПродать штаб\nУвеличить цену штаба\nСделать местом респавна\n{FF0000}Отмена", "ОК", "");
		}//цена дома

        case DIALOG_CHATNAME:
		{//разноцветный ник для чата
		    if (!response || !strlen(inputtext)) return 1;
		    if (strlen(inputtext) > 100) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Вы ввели слишком много символов!");
		    new BasicNick[100], allowed;
			//Сначала проверяем введенные коды цвета на корректность. Пример правильного кода *FF0000*
			for(new i = 0; i < strlen(inputtext); i++)
			{//цикл
				if(inputtext[i] == '*' || inputtext[i] == '{')
				{//Если нашло "*" в тексте
				    if (inputtext[i+7] == '*' || inputtext[i+7] == '}')
				    {//Найдена вторая * на нужном месте (закрывающая скобка)
						inputtext[i] = '{'; inputtext[i+7] = '}';
						for (new u = i+1; u < i+7; u++)
						{//цикл для символов внутри скобок
							allowed = 0;
							if (inputtext[u] >= '0' && inputtext[u] <= '9') allowed = 1;
							if (inputtext[u] >= 'A' && inputtext[u] <= 'F') allowed = 1; //A - F
							if (inputtext[u] >= 'a' && inputtext[u] <= 'f') allowed = 1;//a - f
							if (allowed == 0) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Один из кодов цвета указан неверно!");
						}//цикл для символов внутри скобок
						i += 7; continue;
				    }//Найдена вторая * на нужном месте (закрывающая скобка)
				    else return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Один из кодов цвета указан неверно!");
				}//Если нашло "*" в тексте
			}//цикл

			//Теперь проверяем введенный ник на корректность (совпадает ли с настоящим)
			if (Player[playerid][Admin] < 4)
			{//гл. админ сможет сделать себе какой угодно ник
	            strmid(BasicNick, inputtext, 0, strlen(inputtext), 100);
				for(new i = 0; i < strlen(BasicNick); i++)
				{//цикл
					if(BasicNick[i] == '{') strdel(BasicNick, i, i + 8);//удаляем коды цвета
				}//цикл
				if(strcmp(BasicNick, PlayerName[playerid], false)) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Введенный вами ник отличается от вашего настоящего ника!");
			}//гл. админ сможет сделать себе какой угодно ник

            strmid(ChatName[playerid], inputtext, 0, strlen(inputtext), 100); SavePlayer(playerid);//сохраняем новый ник
		    new String[140]; format(String, sizeof String, "%s {FFFFFF}- Так выглядит ваш новый ник.", inputtext);
		    SendClientMessage(playerid, GetPlayerColor(playerid), String);
		}//разноцветный ник для чата
		
		case DIALOG_CHANGEPASS:
		{//смена пароля
		    new String[480];
		    if (!response)
		    {
		        format(String,sizeof(String), "SERVER: {AFAFAF}%s[%d] отказался изменять пароль.", PlayerName[playerid], playerid);
				foreach(Player, cid) if (Player[cid][Admin] >= 4 && Logged[cid] == 1) SendClientMessage(cid, COLOR_RED, String);
				return 1;
		    }
		    if(!strlen(inputtext) || strlen(inputtext) < 6 || strlen(inputtext) > 24)
			{
				format(String, sizeof(String), "{FFFFFF}Введите новый пароль:\n\n     {008000}Примечания:\n     - Пароль должен быть сложным (Пример: s9cQ17)\n     {FF0000}- Длина пароля должна быть от 6 до 24 символов\n     {FF0000}- Запрещено использовать '=' в пароле");
				return ShowPlayerDialog(playerid, DIALOG_CHANGEPASS, DIALOG_STYLE_INPUT, "{FF0000}Смена пароля", String, "ОК", "Отмена");
			}
			for (new i; i < strlen(inputtext); i++)
			{
	   			if (inputtext[i] == '=')
	   			{//В пароле есть символ =
    				format(String, sizeof(String), "{FFFFFF}Введите новый пароль:\n\n     {008000}Примечания:\n     - Пароль должен быть сложным (Пример: s9cQ17)\n     {FF0000}- Длина пароля должна быть от 6 до 24 символов\n     {FF0000}- Запрещено использовать '=' в пароле");
					return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "{FFD700}Смена пароля", String, "ОК", "Отмена");
	   			}//В пароле есть символ =
	   		}
	   		strmid(PlayerPass[playerid], inputtext, 0, strlen(inputtext), MAX_PASSWORD);
	   		SavePlayer(playerid);
	   		
	   		format(String,sizeof(String), "SERVER: {AFAFAF}%s[%d] изменил свой пароль.", PlayerName[playerid], playerid);
			foreach(Player, cid) if (Player[cid][Admin] >= 4 && Logged[cid] == 1) SendClientMessage(cid, COLOR_RED, String);
			format(String, sizeof String, "%d.%d.%d в %d:%d:%d |   %s[%d] изменил пароль на %s", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid, inputtext);
			WriteLog("GlobalLog", String); WriteLog("PasswordChanges", String);
		}//смена пароля
		
		case DIALOG_CASINORULET:
		{//Рулетка на деньги
		    if(response)
			{//респонс
			    if(listitem == 0) {CasinoBet[playerid] = 37; ShowPlayerDialog(playerid,DIALOG_CASINORULETBETSIZE,1,"Размер ставки","Введите размер ставки","ОК","Назад");}//красное (37)
			    if(listitem == 1) {CasinoBet[playerid] = 38; ShowPlayerDialog(playerid,DIALOG_CASINORULETBETSIZE,1,"Размер ставки","Введите размер ставки","ОК","Назад");}//черное (38)
			    if(listitem == 2) {CasinoBet[playerid] = 41; ShowPlayerDialog(playerid,DIALOG_CASINORULETBETSIZE,1,"Размер ставки","Введите размер ставки","ОК","Назад");}//первая треть (41)
			    if(listitem == 3) {CasinoBet[playerid] = 42; ShowPlayerDialog(playerid,DIALOG_CASINORULETBETSIZE,1,"Размер ставки","Введите размер ставки","ОК","Назад");}//вторая треть (42)
			    if(listitem == 4) {CasinoBet[playerid] = 43; ShowPlayerDialog(playerid,DIALOG_CASINORULETBETSIZE,1,"Размер ставки","Введите размер ставки","ОК","Назад");}//первая треть (43)
			    if(listitem == 5) ShowPlayerDialog(playerid,DIALOG_CASINORULETBETNUMBER,1,"Ставка на число","Введите число, на которое хотите сделать ставку (0-36)","ОК","Назад");//на число (0 - 37)
			}//респонс
		}//Рулетка на деньги

		case DIALOG_CASINORULETBETNUMBER:
		{//ставка на число
			if(response)
			{//респонс
			    new entered = strval(inputtext);
			    if (entered < 0 || entered > 36)
			    {
			        ShowPlayerDialog(playerid,DIALOG_CASINORULETBETNUMBER,1,"Ставка на число","Введите число, на которое хотите сделать ставку (0-36)\n\n{FF0000}Ошибка: Введено неверное число","ОК","Назад");
			        return 1;
				}
				CasinoBet[playerid] = entered;
				ShowPlayerDialog(playerid,DIALOG_CASINORULETBETSIZE,1,"Размер ставки","Введите размер ставки","ОК","Назад");
			}//респонс
			else
			{
       			new String[180], MaxBet;
		  		if (Player[playerid][Level] < 39) MaxBet = 100000; //1 - 38 лвл: 100 000$
	   			else if (Player[playerid][Level] < 53) MaxBet = 250000; //39 - 52 лвл: 250 000$
	   			else if (Player[playerid][Level] < 66) MaxBet = 500000; //53 - 65 лвл: 500 000$
	   			else MaxBet = 1000000; //66+ лвл: 1 000 000$
 	   			if (Player[playerid][Prestige] >= 9) MaxBet = 100000000; //Престиж 9: 100 000 000$
				format(String,sizeof(String),"{AFAFAF}Максимальная Ставка: {FFFFFF}%d", MaxBet);
				ShowPlayerDialog(playerid, DIALOG_CASINORULET, 2, String, "{FFFFFF}Поставить на {FF0000}Красное\n{FFFFFF}Поставить на {AFAFAF}Черное\n{FFFFFF}Поставить на {FFFF00}1-12\n{FFFFFF}Поставить на {FFFF00}13-24\n{FFFFFF}Поставить на {FFFF00}25-36\n{FFFFFF}Поставить на {FFFF00}Число", "ОК", "Отмена");
			}
		}//ставка на число

		case DIALOG_CASINORULETBETSIZE:
		{//ввод размера ставки
   			new String[180], MaxBet, BetColor;
   		 		if (Player[playerid][Level] < 39) MaxBet = 100000; //1 - 38 лвл: 100 000$
	   			else if (Player[playerid][Level] < 53) MaxBet = 250000; //39 - 52 лвл: 250 000$
	   			else if (Player[playerid][Level] < 66) MaxBet = 500000; //53 - 65 лвл: 500 000$
	   			else MaxBet = 1000000; //66+ лвл: 1 000 000$
    			if (Player[playerid][Prestige] >= 9) MaxBet = 100000000; //Престиж 8: 100 000 000$
   			
			if(response)
			{//респонс
				new entered = strval(inputtext);new StringB[120], Result;
				if (entered > Player[playerid][Cash]) entered = Player[playerid][Cash];
				if (entered <= 0) return SendClientMessage(playerid,COLOR_RED,"Введенная сумма некорректна или у вас нет денег!");
				if (entered > MaxBet) entered = MaxBet;//макс. ставка
				Player[playerid][Cash] -= entered; Player[playerid][CasinoBalance] -= entered;
				if (CasinoBet[playerid] == 37 || CasinoBet[playerid] == 38)
				{//Ставка на красное или черное
					if (CasinoBet[playerid] == 37){format(StringB,sizeof(StringB),"{FFFF00}Вы поставили {FFFFFF}%d${FFFF00} на Красное.", entered);}
					if (CasinoBet[playerid] == 38){format(StringB,sizeof(StringB),"{FFFF00}Вы поставили {FFFFFF}%d${FFFF00} на Черное.", entered);}
					SendClientMessage(playerid,COLOR_YELLOW,StringB);
				}//Ставка на красное или черное

				if (CasinoBet[playerid] == 41 || CasinoBet[playerid] == 42  || CasinoBet[playerid] == 43)
				{//ставка на тройки
				    if (CasinoBet[playerid] == 41){format(StringB,sizeof(StringB),"{FFFF00}Вы поставили {FFFFFF}%d${FFFF00} на 1-12.", entered);}
				    if (CasinoBet[playerid] == 42){format(StringB,sizeof(StringB),"{FFFF00}Вы поставили {FFFFFF}%d${FFFF00} на 13-24.", entered);}
				    if (CasinoBet[playerid] == 43){format(StringB,sizeof(StringB),"{FFFF00}Вы поставили {FFFFFF}%d${FFFF00} на 25-36.", entered);}
				    SendClientMessage(playerid,COLOR_YELLOW,StringB);
				}//ставка на тройки

                if (CasinoBet[playerid] >= 0 && CasinoBet[playerid] <= 36)
				{//ставка на число
				    format(StringB,sizeof(StringB),"{FFFF00}Вы поставили {FFFFFF}%d${FFFF00} на %d", entered, CasinoBet[playerid]);
				    SendClientMessage(playerid,COLOR_YELLOW,StringB);
				}//ставка на число

				Result = random(37);

				if (CasinoBet[playerid] == 37)
				{//если была ставка на красное
					switch(Result)
					{
						case 0: BetColor = 0;//зеленый
						case 1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31,33,35: BetColor = 1;//красный
						case 2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36: BetColor = 2;//черный
					}
				
				    if(BetColor == 1)
				    {//победа - выпало красное
				        Player[playerid][Cash] += entered*2; Player[playerid][CasinoBalance] += entered*2;
				        format(StringB,sizeof(StringB),"Вы выиграли! На барабане: %d (Красное)", Result);
				        SendClientMessage(playerid,COLOR_YELLOW,StringB);
				        format(StringB, sizeof StringB, "+%d$", entered); SetPlayerChatBubble(playerid, StringB, COLOR_GREEN, 10.0, 2000);
				        PlayerPlaySound(playerid,1083,0.0,0.0,0.0);//звук выигрыша
				    }//победа - выпало красное
				    if(BetColor == 2)
				    {//проигрыш - выпало черное
				        format(StringB,sizeof(StringB),"Вы проиграли! На барабане: %d (Черное)", Result);
				        SendClientMessage(playerid,COLOR_GREY,StringB);
                        format(StringB, sizeof StringB, "-%d$", entered); SetPlayerChatBubble(playerid, StringB, COLOR_RED, 10.0, 2000);
				        PlayerPlaySound(playerid,1084,0.0,0.0,0.0);//звук проигрыша
				    }//проигрыш - выпало черное
				    if(BetColor == 0)
				    {//проигрыш - выпало черное
				        format(StringB,sizeof(StringB),"Вы проиграли! На барабане: 0", Result);
				        SendClientMessage(playerid,COLOR_GREY,StringB);
				        format(StringB, sizeof StringB, "-%d$", entered); SetPlayerChatBubble(playerid, StringB, COLOR_RED, 10.0, 2000);
				        PlayerPlaySound(playerid,1084,0.0,0.0,0.0);//звук проигрыша
				    }//проигрыш - выпало черное
				}//если была ставка на красное

				if (CasinoBet[playerid] == 38)
				{//если была ставка на черное
					switch(Result)
					{
						case 0: BetColor = 0;//зеленый
						case 1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31,33,35: BetColor = 1;//красный
						case 2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36: BetColor = 2;//черный
					}
				
				    if(BetColor == 1)
				    {//проигрыш - выпало красное
				        format(StringB,sizeof(StringB),"Вы проиграли! На барабане: %d (Красное)", Result);
				        SendClientMessage(playerid,COLOR_GREY,StringB);
				        format(StringB, sizeof StringB, "-%d$", entered); SetPlayerChatBubble(playerid, StringB, COLOR_RED, 10.0, 2000);
				        PlayerPlaySound(playerid,1084,0.0,0.0,0.0);//звук проигрыша
				    }//проигрыш - выпало красное
				    if(BetColor == 2)
				    {//победа - выпало черное
				        Player[playerid][Cash] += entered*2; Player[playerid][CasinoBalance] += entered*2;
				        format(StringB,sizeof(StringB),"Вы выиграли! На барабане: %d (Черное)", Result);
				        SendClientMessage(playerid,COLOR_YELLOW,StringB);
				        format(StringB, sizeof StringB, "+%d$", entered); SetPlayerChatBubble(playerid, StringB, COLOR_GREEN, 10.0, 2000);
				        PlayerPlaySound(playerid,1083,0.0,0.0,0.0);//звук выигрыша
				    }//победа - выпало черное
				    if(BetColor == 0)
				    {//проигрыш - выпало черное
				        format(StringB,sizeof(StringB),"Вы проиграли! На барабане: 0", Result);
				        SendClientMessage(playerid,COLOR_GREY,StringB);
				        format(StringB, sizeof StringB, "-%d$", entered); SetPlayerChatBubble(playerid, StringB, COLOR_RED, 10.0, 2000);
				        PlayerPlaySound(playerid,1084,0.0,0.0,0.0);//звук проигрыша
				    }//проигрыш - выпало черное
				}//если была ставка на черное

				if (CasinoBet[playerid] == 41)
				{//если была ставка на 1-12
				    if (Result >= 1 && Result <= 12)
					{//выигрыш 1-12
					    Player[playerid][Cash] += entered*3; Player[playerid][CasinoBalance] += entered*3;
				        format(StringB,sizeof(StringB),"Вы выиграли! На барабане: %d", Result);
				        SendClientMessage(playerid,COLOR_YELLOW,StringB);
				        format(StringB, sizeof StringB, "+%d$", entered*2); SetPlayerChatBubble(playerid, StringB, COLOR_GREEN, 10.0, 2000);
				        PlayerPlaySound(playerid,1083,0.0,0.0,0.0);//звук выигрыша
					}//выигрыш 1-12
					else
				    {//проигрыш
				        format(StringB,sizeof(StringB),"Вы проиграли! На барабане: %d", Result);
				        SendClientMessage(playerid,COLOR_GREY,StringB);
				        format(StringB, sizeof StringB, "-%d$", entered); SetPlayerChatBubble(playerid, StringB, COLOR_RED, 10.0, 2000);
				        PlayerPlaySound(playerid,1084,0.0,0.0,0.0);//звук проигрыша
				    }//проигрыш
				}//если была ставка на 1-12

				if (CasinoBet[playerid] == 42)
				{//если была ставка на 13-24
				    if (Result >= 13 && Result <= 24)
					{//выигрыш
					    Player[playerid][Cash] += entered*3; Player[playerid][CasinoBalance] += entered*3;
				        format(StringB,sizeof(StringB),"Вы выиграли! На барабане: %d", Result);
				        SendClientMessage(playerid,COLOR_YELLOW,StringB);
				        format(StringB, sizeof StringB, "+%d$", entered*2); SetPlayerChatBubble(playerid, StringB, COLOR_GREEN, 10.0, 2000);
				        PlayerPlaySound(playerid,1083,0.0,0.0,0.0);//звук выигрыша
					}//выигрыш
					else
				    {//проигрыш
				        format(StringB,sizeof(StringB),"Вы проиграли! На барабане: %d", Result);
				        SendClientMessage(playerid,COLOR_GREY,StringB);
				        format(StringB, sizeof StringB, "-%d$", entered); SetPlayerChatBubble(playerid, StringB, COLOR_RED, 10.0, 2000);
				        PlayerPlaySound(playerid,1084,0.0,0.0,0.0);//звук проигрыша
				    }//проигрыш
				}//если была ставка на 13-24

				if (CasinoBet[playerid] == 43)
				{//если была ставка на 25-36
				    if (Result >= 25 && Result <= 36)
					{//выигрыш
					    Player[playerid][Cash] += entered*3; Player[playerid][CasinoBalance] += entered*3;
				        format(StringB,sizeof(StringB),"Вы выиграли! На барабане: %d", Result);
				        SendClientMessage(playerid,COLOR_YELLOW,StringB);
				        format(StringB, sizeof StringB, "+%d$", entered*2); SetPlayerChatBubble(playerid, StringB, COLOR_GREEN, 10.0, 2000);
				        PlayerPlaySound(playerid,1083,0.0,0.0,0.0);//звук выигрыша
					}//выигрыш
					else
				    {//проигрыш
				        format(StringB,sizeof(StringB),"Вы проиграли! На барабане: %d", Result);
				        SendClientMessage(playerid,COLOR_GREY,StringB);
				        format(StringB, sizeof StringB, "-%d$", entered); SetPlayerChatBubble(playerid, StringB, COLOR_RED, 10.0, 2000);
				        PlayerPlaySound(playerid,1084,0.0,0.0,0.0);//звук проигрыша
				    }//проигрыш
				}//если была ставка на 25-36

				if (CasinoBet[playerid] >= 0 && CasinoBet[playerid] <= 36)
				{//если была ставка на число
				    if (Result == CasinoBet[playerid])
					{//выигрыш
					    Player[playerid][Cash] += entered*37; Player[playerid][CasinoBalance] += entered*37;
				        format(StringB,sizeof(StringB),"Вы выиграли! На барабане: %d", Result);
				        SendClientMessage(playerid,COLOR_YELLOW,StringB);
				        format(StringB, sizeof StringB, "+%d$", entered*36); SetPlayerChatBubble(playerid, StringB, COLOR_GREEN, 10.0, 2000);
				        PlayerPlaySound(playerid,1083,0.0,0.0,0.0);//звук выигрыша
					}//выигрыш
					else
				    {//проигрыш
				        format(StringB,sizeof(StringB),"Вы проиграли! На барабане: %d", Result);
				        SendClientMessage(playerid,COLOR_GREY,StringB);
				        format(StringB, sizeof StringB, "-%d$", entered); SetPlayerChatBubble(playerid, StringB, COLOR_RED, 10.0, 2000);
				        PlayerPlaySound(playerid,1084,0.0,0.0,0.0);//звук проигрыша
				    }//проигрыш
				}//если была ставка на число

           	    if (Player[playerid][CasinoBalance] >= 100000000 && Player[playerid][Prestige] < 9)
				{
				    format(StringB, sizeof StringB, "%d.%d.%d в %d:%d:%d |   UpdatePlayer: Игрок %s[%d] разорил казино на 100 000 000$", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid);
					WriteLog("Casino", StringB);
					SendClientMessage(playerid, COLOR_RED, "ВЫ РАЗОРИЛИ КАЗИНО НА 100 000 000$");
				}
				
				QuestUpdate(playerid, 24, 1);//Обновление квеста Сделайте 20 ставок в казино
			}//респонс
			else
			{
				format(String,sizeof(String),"{AFAFAF}Максимальная Ставка: {FFFFFF}%d", MaxBet);
				ShowPlayerDialog(playerid, DIALOG_CASINORULET, 2, String, "{FFFFFF}Поставить на {FF0000}Красное\n{FFFFFF}Поставить на {AFAFAF}Черное\n{FFFFFF}Поставить на {FFFF00}1-12\n{FFFFFF}Поставить на {FFFF00}13-24\n{FFFFFF}Поставить на {FFFF00}25-36\n{FFFFFF}Поставить на {FFFF00}Число", "ОК", "Отмена");
			}
		}//ввод размера ставки
		
		case DIALOG_PRESTIGECOLOR:
		{//изменение своего цвета на радаре и в Tab (Престиж 7)
		    if (!response) return 1;
		    if (listitem <= 40)
			{
				Player[playerid][PrestigeColor] = listitem;
				SendClientMessage(playerid, COLOR_YELLOW, "SERVER: Вы успешно изменили свой цвет!");
                SendClientMessage(playerid,COLOR_CYAN,"Подсказка: Изменен ваш цвет на радаре, а также цвет ника над головой и в Tab.");
                SendClientMessage(playerid,COLOR_CYAN,"Подсказка: Не работает при включенной невидимости и в чате!");
			}
		    else {Player[playerid][PrestigeColor] = -1; SendClientMessage(playerid, COLOR_YELLOW, "SERVER: Вы успешно вернули свой стандартный цвет!");}
		}//изменение своего цвета на радаре и в Tab (Престиж 7)
		
		case DIALOG_QUESTS:
		{//меню квестов
		    if (!response) return 1;
		    if (listitem < 3) return SendCommand(playerid, "/quests", "");
		    if (listitem == 3)
		    {//Обмен медалей
		        new String[120], StringX[480];
		        format(String, sizeof String, "{FFFFFF}[{FFCC00}1 Медаль{FFFFFF}] Получить 1 рубль ({007FFF}%0.0f{FFFFFF} / 5 за сегодня)\n", Player[playerid][GGFromMedals]); strcat(StringX, String);
		        strcat(StringX, "{FFFFFF}[{FFCC00}1 Медаль{FFFFFF}] Получить 200 XP\n");
		        strcat(StringX, "{FFFFFF}[{FFCC00}1 Медаль{FFFFFF}] Получить 50 000$\n");
		        strcat(StringX, "{FFFFFF}[{FFCC00}4 Медали{FFFFFF}] Получить 25 очков кармы\n");
		        strcat(StringX, "{FFFFFF}[{FFCC00}10 Медалей{FFFFFF}] Повысить уровень Престижа\n");

				//Неперекупаемый дом
				new ph = Player[playerid][Home];
				if (ph == 0) strcat(StringX, "{AFAFAF}[{FFCC00}14 Медалей{FFFFFF} / {00CCCC}7 дней{FFFFFF}] Неперекупаемый дом\n");
				else
				{
				    if (Property[ph][pBuyBlock] <= 0) strcat(StringX, "{AFAFAF}[{FFCC00}14 Медалей{FFFFFF} / {00CCCC}7 дней{FFFFFF}] Неперекупаемый дом\n");
					else
					{
					    new StrZ[140];
						format(StrZ, sizeof StrZ, "{AFAFAF}[{FFCC00}14 Медалей{FFFFFF} / {00CCCC}7 дней{FFFFFF}] Неперекупаемый дом (оплачено до {00CCCC}%s{FFFFFF})\n", IntDateToStringDate(Property[ph][pBuyBlock]));
						strcat(StringX, StrZ);
					}
				}
                //Неперекупаемый дом
                
               	format(String, sizeof String, "{AFAFAF}Обменять Медали: {FFCC00}%d", Player[playerid][Medals]);
				ShowPlayerDialog(playerid, DIALOG_MEDALTRADE, 2, String, StringX, "Выбрать", "Назад");
		    }//Обмен медалей
		}//меню квестов

		case DIALOG_MEDALTRADE:
		{//обмен медалей
		    if (!response) return SendCommand(playerid, "/quests", "");
		    if (listitem == 0)
		    {//1 медаль = 1GG
		        if (Player[playerid][Banned] != 0) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Обмен медалей на рубли недоступен для забаненных игроков");
		        if (Player[playerid][Medals] < 1) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: У вас нет медалей!");
				if (Player[playerid][GGFromMedals] >= 5) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: На рубли можно обменивать не более 5 медалей в день! Повторите попытку завтра!");
		        Player[playerid][Medals]--; Player[playerid][GameGold] += 1.0; Player[playerid][GameGoldTotal] += 1.0;
				Player[playerid][GGFromMedals] += 1.0; Player[playerid][GGFromMedalsTotal] += 1.0;
		        return SendClientMessage(playerid, COLOR_YELLOW, "SERVER: Вы успешно обменяли медаль на 1 рубль!");
		    }//1 медаль = 1GG
		    if (listitem == 1)
		    {//1 медаль = 200 XP
		        if (Player[playerid][Medals] < 1) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: У вас нет медалей!");
		        Player[playerid][Medals]--; LGiveXP(playerid, 200);
		        return SendClientMessage(playerid, COLOR_YELLOW, "SERVER: Вы успешно обменяли медаль на 200 XP!");
		    }//1 медаль = 200 XP
		    if (listitem == 2)
		    {//1 медаль = 50 000$
		        if (Player[playerid][Medals] < 1) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: У вас нет медалей!");
		        Player[playerid][Medals]--; Player[playerid][Cash] += 50000;
		        return SendClientMessage(playerid, COLOR_YELLOW, "SERVER: Вы успешно обменяли медаль на 50 000$");
		    }//1 медаль = 50 000$
		    if (listitem == 3)
		    {//4 медали = 25 очков кармы
		        if (Player[playerid][Medals] < 4) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: У вас нет 4 медалей!");
		        if (Player[playerid][Karma] >= 1000) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: У вас максимум кармы!");
		        Player[playerid][Medals] -= 4; Player[playerid][Karma] += 25;
		        if (Player[playerid][Karma] >= 1000) Player[playerid][Karma] = 1000;
		        return SendClientMessage(playerid, COLOR_YELLOW, "SERVER: Вы успешно обменяли 4 медали на 25 очков кармы");
		    }//4 медали = 25 очков кармы
		    if (listitem == 4) return SendCommand(playerid, "/prestige", ""); //10 медалей - повысить Престиж
			if(listitem == 5)
			{//Неперекупаемый дом
				if (Player[playerid][Medals] < 14) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: У вас нет 14 медалей");
			    new phouse = Player[playerid][Home], text3d[MAX_3DTEXT], String[140];
			    if (phouse == 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: У вас нет дома");
                if (Property[phouse][pBuyBlock] <= 0)
			    {//Покупка
			    	Property[phouse][pBuyBlock] = DateToIntDate(Day, Month, Year) + 7;
			        format(String, sizeof String, "Вы приобрели 'Неперекупаемый личный дом' до {00CCCC}%s", IntDateToStringDate(Property[phouse][pBuyBlock]));
			        SendClientMessage(playerid, COLOR_YELLOW, String); SendClientMessage(playerid, COLOR_YELLOW, "Если вы хотите продлить услугу, то просто купите её еще раз!");
			    }//Покупка
			    else
			    {//Продление
			    	Property[phouse][pBuyBlock] += 7;
			        format(String, sizeof String, "Вы продлили 'Неперекупаемый личный дом' до {00CCCC}%s", IntDateToStringDate(Property[phouse][pBuyBlock]));
			        SendClientMessage(playerid, COLOR_YELLOW, String);
			    }//Продление
			    Player[playerid][Medals] -= 14; SaveProperty(phouse); SavePlayer(playerid);
			    format(text3d, sizeof(text3d), "{00FF00}Дом ({FF0000}Не продается{00FF00})\n{007FFF}Владелец:{FFFFFF} %s\nНажмите [{FFFF00}Alt{FFFFFF}] чтобы использовать", Property[phouse][pOwner]);
			    UpdateDynamic3DTextLabelText(PropertyText3D[phouse], 0xFFFFFFFF, text3d);
			}//Неперекупаемый дом
		}//обмен медалей
		
		case DIALOG_SELLHOUSE: if (response) return SendCommand(playerid, "/sellhouse", "");
		case DIALOG_SELLBASE: if (response) return SendCommand(playerid, "/sellbase", "");

	}//switch
	return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
	if (InEvent[playerid] != 0 || QuestActive[playerid] != 0) return SendClientMessage(playerid, COLOR_RED, "ОШИБКА: Нельзя использовать телепорт по карте во время работы или соревнований!");
    if (MapTPTime[playerid] > 0) {new String[140]; format(String,sizeof(String),"Телепорт по карте будет доступен через %d секунд", MapTPTime[playerid]); return SendClientMessage(playerid,COLOR_RED,String);}
    if (Player[playerid][GPremium] >= 14 || Player[playerid][Admin] >= 4)
    {//14 ViP либо глав. админ
		MapTP[playerid] = 1; MapTPTry[playerid] = 0; MapTPx[playerid] = fX; MapTPy[playerid] = fY;
		SetPlayerPos(playerid, fX, fY, -5);
    }//14 ViP либо глав. админ

	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	if (Logged[playerid] == 0){SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вы должны авторизироваться, чтобы открывать меню быстрого доступа");return 1;}
	if (SkinChangeMode[playerid] == 1) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Данная функция недоступна при выборе модели персонажа");
	if (playerid == clickedplayerid)
	{//если кликнул сам на себя
		ShowPlayerDialog(playerid, 2, 2, "Меню быстрого доступа", "Сесть в машину [Класс 1]\nСесть в машину [Класс 2]\nСесть в машину [Класс 3]\nНадеть JetPack (/jetpack)\nПрыгнуть с парашютом (/skydive)\n{FF0000}GPS (/gps){FFFFFF}\nИзменить мои автомобили\nИзменить мои навыки\nНастройки PvP\n{FFFF00}Открыть КПК", "ОК", "");
	}//если кликнул сам на себя
	else
	{//кликнул на другого игрока
		new pname[24];GetPlayerName(clickedplayerid, pname, sizeof(pname));
		if (Player[playerid][Prestige] < 5) ShowPlayerDialog(playerid, DIALOG_TABMENU, 2, pname, "Статистика игрока\nСтатистика клана игрока\nОтправить сообщение игроку\nПередать деньги игроку\nВызвать на дуэль (PvP)\n{007FFF}Пригласить игрока в клан\n{FF0000}Объявить войну клану игрока", "ОК", "Отмена");
		else ShowPlayerDialog(playerid, DIALOG_TABMENU, 2, pname, "Статистика игрока\nСтатистика клана игрока\nОтправить сообщение игроку\nПередать деньги игроку\nВызвать на дуэль (PvP)\n{007FFF}Пригласить игрока в клан\n{FF0000}Объявить войну клану игрока\n{008D00}Телепортироваться к игроку", "ОК", "Отмена");
		ClickedPid[playerid] = clickedplayerid;
	}//кликнул на другого игрока
	return 1;
}


public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
    //Обычные пули синхронизируются в OnPlayerWeaponShot, холодное оружие в OnPlayerGiveDamage.
	if (!IsPlayerConnected(issuerid) || issuerid == playerid) {Player[playerid][PHealth] -= amount; return 1;}//Получил урон не от другого игрока (например падение с высоты или разные косяки с синхронизацией)

	//------- Ниже идет обработка урона, полученного от другого(!) игрока
	if ((weaponid == 51 || weaponid == 37 || weaponid == 49 || weaponid == 50) || ((weaponid == 31 || weaponid == 38) && IsPlayerInAnyVehicle(issuerid)) || (GetPlayerState(issuerid) == 2 && (weaponid == 28 || weaponid == 29 || weaponid == 32)))
	{//Взрывы, огонь, дб на машине, дб на вертолете, оружие на возд. транспорте
		if (InPeacefulZone[playerid] == 1 || InPeacefulZone[issuerid] == 1)
		{//В мирной зоне
			SetPlayerArmedWeapon(issuerid,0); ApplyAnimation(issuerid,"PED","KO_SKID_BACK",4.0,0,0,0,0,0,1);
			if (IsPlayerInAnyVehicle(issuerid)) RemovePlayerFromVehicle(issuerid);
			return SendClientMessage(issuerid, COLOR_RED, "Нельзя драться в мирной зоне!");
		}//В мирной зоне
		if (PrestigeGM[issuerid] == 1)
		{//нельзя убивать если ты в режиме бога
		    if (InEvent[issuerid] == 0)
			{//не в соревнованиях
			    if (IsPlayerInAnyVehicle(issuerid)) RemovePlayerFromVehicle(issuerid);
    			ApplyAnimation(issuerid,"PED","KO_SKID_BACK",4.0,0,0,0,0,0,1);
				return SendClientMessage(issuerid,COLOR_RED,"Запрещено пользоваться оружием в Режиме Бога");
			}//не в соревнованиях
		}//нельзя убивать если ты в режиме бога
		if (Player[playerid][PHealth] <= 0.0) return 1;//Игрок, которому наносят урон, уже мертв
		if (NOPSetPlayerHealth[issuerid] > 5 || NOPSetPlayerArmour[issuerid] > 5) return SendClientMessage(issuerid, COLOR_RED, "Ваше здоровье или броня рассинхронизированы! Урон от вашего оружия не засчитан.");

		//Само нанесение урона
		if (Player[playerid][PArmour] > amount) Player[playerid][PArmour] -= amount;
		else
		{//Если брони меньше, чем наносимый урон
		    amount -= Player[playerid][PArmour];
			Player[playerid][PHealth] -= amount; Player[playerid][PArmour] = 0.0;
		}//Если брони меньше, чем наносимый урон

		SetPlayerHealth(playerid, Player[playerid][PHealth]);
		SetPlayerArmour(playerid, Player[playerid][PArmour]);
		//Записываем жертве от кого он получил последний урон
		LastDamageFrom[playerid] = issuerid;


		if (Player[playerid][PHealth] <= 1.0 && IsPlayerConnected(issuerid) && issuerid != playerid)
		{//Убийство игрока
			OnPlayerDeathFromPlayer(playerid, issuerid, weaponid);
	        SetPlayerHealth(playerid,0.0);//Чтобы не было бага с застыванием игрока (не срабатывает OnPlayerDeath). Но с огнем глючит.
		}//Убийство игрока
	}//Взрывы, огонь, дб на машине, дб на вертолете, оружие на возд. транспорте

	return 1;
}

public OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart)
{
 	//new szString[140];
    //format(szString, sizeof(szString), "GiveDamage | playerid: %i   damagedid: %i   amount: %0.2f   weaponid: %i   bodypart: %i", playerid, damagedid, amount, weaponid, bodypart);
    //SendClientMessageToAll(-1, szString);

    if (weaponid < 0 || weaponid > 15) return 1;//Урон от ПУЛЬ синхронизируется в OnPlayerWeaponShot, остальной урон в TakeDamage
    //Через GiveDamage идет только урон от холодного оружия
    if (weaponid > 0 && Weapons[playerid][weaponid] == 0) return 1;//Удар из начитеренного оружия
    new Float: fX, Float: fY, Float: fZ; GetPlayerPos(damagedid, fX, fY, fZ);
	new Float: fDistance = GetPlayerDistanceFromPoint(playerid, fX, fY, fZ); if (fDistance > 3) return 1;//расстояние между игроками слишком большое (не могло задеть холодное оружие)
	if (Player[damagedid][PHealth] <= 0.0) return 1;//Игрок, которому наносят урон, уже мертв
	if (LAFK[damagedid] > 3 ||  LAFK[playerid] > 3) return 1;//Игрок, которому наносят урон, афк больше 3 или наносящий урон в афк (чит)
	if (InPeacefulZone[damagedid] == 1 || InPeacefulZone[playerid] == 1)
	{//В мирной зоне
		SetPlayerArmedWeapon(playerid,0); ApplyAnimation(playerid,"PED","KO_SKID_BACK",4.0,0,0,0,0,0,1);
		return SendClientMessage(playerid, COLOR_RED, "Нельзя драться в мирной зоне!");
	}//В мирной зоне
	if (PrestigeGM[playerid] == 1)
	{//нельзя убивать если ты в режиме бога
	    if (InEvent[playerid] == 0)
		{//не в соревнованиях
			ApplyAnimation(playerid,"PED","KO_SKID_BACK",4.0,0,0,0,0,0,1);
			return SendClientMessage(playerid,COLOR_RED,"Запрещено пользоваться оружием в Режиме Бога");
		}//не в соревнованиях
	}//нельзя убивать если ты в режиме бога
	if (NOPSetPlayerHealth[playerid] > 5 || NOPSetPlayerArmour[playerid] > 5) return SendClientMessage(playerid, COLOR_RED, "Ваше здоровье или броня рассинхронизированы! Урон от вашего оружия не засчитан.");


	amount = ColdWeaponDamage[weaponid];//получаем значение урона от оружия ближнего боя
	//------------- Изменение наносимого урона
	if (InEvent[playerid] > 0)
	{//Игрок в соревнованиях
		if (ZMStarted[damagedid] > 0)
		{//Зомби-Выживание
			if (ZMStarted[playerid] == 1 && ZMIsPlayerIsZombie[playerid] == 0 && ZMIsPlayerIsZombie[damagedid] == 0) return SendClientMessage(playerid,COLOR_RED,"Не бейте своих!");
			if (ZMIsPlayerIsZombie[playerid] > 0 && weaponid != 0) return ResetPlayerWeapons(playerid);
			if (ZMIsPlayerIsZombie[playerid] > 0 && ZMIsPlayerIsZombie[damagedid] == 0) amount = 35;//Зомби наносят по 35 урона за удар
			if (ZMIsPlayerIsTank[playerid] > 0  && ZMIsPlayerIsZombie[damagedid] == 0) amount = 65;//Прыгуны наносят по 65 урона за удар
		}//Зомби-Выживание
    }//Игрок в соревнованиях
	//------------- Изменение наносимого урона

	//------------- Нанесение урона и убийство
	if (Player[damagedid][PArmour] > amount) Player[damagedid][PArmour] -= amount;
	else
	{//Если брони меньше, чем наносимый урон
	    amount -= Player[damagedid][PArmour];
		Player[damagedid][PHealth] -= amount; Player[damagedid][PArmour] = 0.0;
	}//Если брони меньше, чем наносимый урон
	SetPlayerHealth(damagedid, Player[damagedid][PHealth]);
	SetPlayerArmour(damagedid, Player[damagedid][PArmour]);
	//Записываем жертве от кого он получил последний урон
	LastDamageFrom[damagedid] = playerid;

	if (Player[damagedid][PHealth] <= 1.0)
	{//Убийство игрока
		OnPlayerDeathFromPlayer(damagedid, playerid, weaponid);
        SetPlayerHealth(damagedid,0.0);//Чтобы не было бага с застыванием игрока (не срабатывает OnPlayerDeath)
	}//Убийство игрока
	//------------- Нанесение урона и убийство

	return 1;
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{//Стрельба из огнестрельного оружия пешком или с ПАССАЖИРСКОГО места
 	//new szString[140];
    //format(szString, sizeof(szString), "SHOT | playerid: %i   weaponid: %i   hittype: %i   hitid: %i   pos: %f, %f, %f", playerid, weaponid, hittype, hitid, fX, fY, fZ);
    //SendClientMessageToAll(-1, szString);

    //Ниже идет серия проверок на то, что выстрел не сделан читом
    if ((weaponid < 22 || weaponid > 34) && weaponid != 38) return 0;//Выстрел сделан НЕ с огрестрельного оружия.
	if (Weapons[playerid][weaponid] == 0) return 0;//Выстрел из начитеренного оружия
    if (hittype == BULLET_HIT_TYPE_PLAYER && (!(-10.0 < fX < 10.0) || !(-10.0 < fY < 10.0) || !(-10.0 < fZ < 10.0))) return 0; //Anti Bullet Crasher
	new Float: amount = WeaponShotDamage[weaponid];//получаем значение урона от пули
	WeaponShotsLastSecond[playerid]++;//+1 к кол-ву выстрелов за последнюю секунду
	if (WeaponShotsLastSecond[playerid] > WeaponShotsPerSecond[weaponid])  return 0; //Превышено макс. кол-во выстрелов за 1 секунду

    if (InPeacefulZone[playerid] == 1)
	{//В мирной зоне
		SetPlayerArmedWeapon(playerid,0); ApplyAnimation(playerid,"CRACK","crckdeth1",4.1,0,0,0,0,1,1);
		SendClientMessage(playerid, COLOR_RED, "Нельзя драться в мирной зоне!"); return 0;
	}//В мирной зоне
	if (PrestigeGM[playerid] == 1)
	{//нельзя убивать если ты в режиме бога
	    if (InEvent[playerid] == 0)
		{//не в соревнованиях
			SetPlayerArmedWeapon(playerid,0); ApplyAnimation(playerid,"CRACK","crckdeth1",4.1,0,0,0,0,1,1);
			SendClientMessage(playerid,COLOR_RED,"Запрещено пользоваться оружием в Режиме Бога"); return 0;
		}//не в соревнованиях
	}//нельзя убивать если ты в режиме бога

    new Float: var; GetPlayerLastShotVectors(playerid, var, var, var, fX, fY, fZ);
    if (GetPlayerDistanceFromPoint(playerid, fX, fY, fZ) > 300) return 1;//расстояние полета пули слишком большое (у всего оружия кроме снайперки хватает 225)
	if (weaponid >= 25 && weaponid <= 27 && GetPlayerDistanceFromPoint(playerid, fX, fY, fZ) > 35) return 1;//слишком большое расстояние для дробовика

	if(hittype == 1 && hitid != playerid || IsPlayerConnected(hitid) && Player[hitid][PHealth] > 0.0)
	{//Выстрел по другому игроку
	    if (GetPlayerDistanceFromPoint(hitid, fX, fY, fZ) > 5) return 1;//игрока нет там, куда попала пуля
	    if (weaponid == 38 && Player[hitid][Level] < 60 && InEvent[hitid] == 0) //стрельба с минигана по игроку ниже 40 лвл
			{SendClientMessage(playerid,COLOR_RED,"С минигана нельзя убивать игроков, не достигших 60-го уровня!"); SetPlayerArmedWeapon(playerid, 0);  return 0;}
        if (LAFK[hitid] > 3 ||  LAFK[playerid] > 3) return 1;//Игрок, которому наносят урон, уже мертв или AFK или наносят урон из афк (чит)
        if (Player[hitid][PHealth] <= 0.0) return 1;//Игрок, которому наносят урон, уже мертв
 		if (NOPSetPlayerHealth[playerid] > 5 || NOPSetPlayerArmour[playerid] > 5) return SendClientMessage(playerid, COLOR_RED, "Ваше здоровье или броня рассинхронизированы! Урон от вашего оружия не засчитан.");


		//Изменение наносимого урона
		if (InEvent[playerid] > 0)
		{//Игрок в соревнованиях
			if(InEvent[playerid] == EVENT_DM && (DMid == 9 || DMid == 11)) amount = 500;//На дм Мясорубка, Ферма
			if (ZMStarted[playerid] == 1 && ZMStarted[hitid] == 1)
			{//Зомби-Выживание
			    if (ZMIsPlayerIsZombie[playerid] > 0 || ZMIsPlayerIsTank[playerid] > 0) {ResetPlayerWeapons(playerid); return 0;} //стрельба, будучи зомби или танком
 				if (ZMIsPlayerIsZombie[playerid] == 0 && ZMIsPlayerIsZombie[hitid] == 0) {SendClientMessage(playerid,COLOR_RED,"Не стреляйте по своим!"); return 0;}
			}//Зомби-Выживание
	    }//Игрок в соревнованиях
        //Изменение наносимого урона
        
        //------------- Нанесение урона и убийство
		if (Player[hitid][PArmour] > amount) Player[hitid][PArmour] -= amount;
		else
		{//Если брони меньше, чем наносимый урон
		    amount -= Player[hitid][PArmour];
			Player[hitid][PHealth] -= amount; Player[hitid][PArmour] = 0.0;
		}//Если брони меньше, чем наносимый урон
		//Записываем жертве от кого он получил последний урон
		LastDamageFrom[hitid] = playerid;

		if (Player[hitid][PHealth] <= 1.0)
		{//Убийство игрока
			OnPlayerDeathFromPlayer(hitid, playerid, weaponid);
	        SetPlayerHealth(hitid,0.0);//Чтобы не было бага с застыванием игрока (не срабатывает OnPlayerDeath)
		}//Убийство игрока
		//------------- Нанесение урона и убийство
	}//Выстрел по другому игроку
	
	if(hittype == 2 && hitid > 35 && hitid <= MAX_VEHICLES && Vehicle[hitid][Health] > 0.0)
	{//Выстрел по транспорту (кроме авто для угона)
        Vehicle[hitid][Health] -= amount;
	}//Выстрел по транспорту (кроме авто для угона)
    
    return 1;
}//Стрельба из огнестрельного оружия пешком или с ПАССАЖИРСКОГО места

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strlen(cmdtext) > 140) return 1;//защита на отправку огромных сообщений при помощи стороннего софта
    new idx, cmd[20], params[137];
	idx = strfind(cmdtext, " ", true);//находим позицию пробела. Возвращает -1 если пробела не было
	if (idx == -1) return SendCommand(playerid, cmdtext, "");
	strmid(cmd, cmdtext, 0, idx); strmid(params, cmdtext, idx + 1, 140);
	return SendCommand(playerid, cmd, params);
}

stock SendCommand(playerid, cmd[], params[])
{
	for(new i = 0; i < strlen(cmd); i++)
	{//исправление криво введенных команд
		if (cmd[i] > 64 && cmd[i] < 91) {cmd[i] += 32; continue;} //занижение больших букв eng
		if (cmd[i] > 191 && cmd[i] < 224) cmd[i] += 32;//занижение больших букв rus
		if (cmd[i] >= 224 && cmd[i] <= 255)
		{//маленькие русские буквы надо перевестить на английские по раскладке клавиатуры (для ввода команд на русском вместо /pm - /зь и тд
		    switch (cmd[i])
		    {
		    	case 233: cmd[i] = 113; /*й - q*/ case 246: cmd[i] = 119; /*ц - w*/ case 243: cmd[i] = 101; /*у - e*/ case 234: cmd[i] = 114; /*к - r*/
                case 229: cmd[i] = 116; /*е - t*/ case 237: cmd[i] = 121; /*н - y*/ case 227: cmd[i] = 117; /*г - u*/ case 248: cmd[i] = 105; /*ш - i*/
				case 249: cmd[i] = 111; /*щ - o*/ case 231: cmd[i] = 112; /*з - p*/ case 244: cmd[i] = 97; /*ф - a*/  case 251: cmd[i] = 115; /*ы - s*/
				case 226: cmd[i] = 100; /*в - d*/ case 224: cmd[i] = 102; /*а - f*/ case 239: cmd[i] = 103; /*п - g*/ case 240: cmd[i] = 104; /*р - h*/
				case 238: cmd[i] = 106; /*о - j*/ case 235: cmd[i] = 107; /*л - k*/ case 228: cmd[i] = 108; /*д - l*/ case 255: cmd[i] = 122; /*я - z*/
				case 247: cmd[i] = 120; /*ч - x*/ case 241: cmd[i] = 99; /*с - cv*/ case 236: cmd[i] = 118; /*м - v*/ case 232: cmd[i] = 98; /*и - b*/
				case 242: cmd[i] = 110; /*т - n*/ case 252: cmd[i] = 109; /*ь - m*/
		    }
		}//маленькие русские буквы надо перевестить на английские по раскладке клавиатуры (для ввода команд на русском вместо /pm - /зь и тд
	}//исправление криво введенных команд

	#include "Transformer\Commands.inc"
	#include "Transformer\ACommands.inc"
	return SendClientMessage(playerid, COLOR_WHITE, "SERVER: Неизвестная команда. Используйте {FF0000}/commands {FFFFFF}чтобы отобразить список команд.");
}

public OnPlayerEnterDynamicCP(playerid, checkpointid)//checkpointid
{
	return 1;
}







//------------ LAC: AntiNOP RemovePlayerFromVehicle
forward AntiRemovePlayerFromVehicle(playerid);
public AntiRemovePlayerFromVehicle(playerid)
{

	/*if (GetPlayerState(playerid) == 2)//В авто
		{
			new CheaterName[30], String[120];CheaterName = GetName(playerid);
			format(String,sizeof(String), "{FF0000}LAC: {AFAFAF}%s был кикнут с сервера. {FF0000}Причина:{AFAFAF} Возможно чит NOP: RemovePlayerFromVehicle",CheaterName);
			SendClientMessageToAll(COLOR_GREY,String);print(String);
			Kick(playerid);
		}*/
}
//------------ LAC: AntiNOP RemovePlayerFromVehicle

//------------ SpawnStyle
forward SpawnStylePub(playerid);
public SpawnStylePub(playerid)
{//начало паба
	if (Logged[playerid] == 1 && Player[playerid][Level] > 0 && FirstSobeitCheck[playerid] == 0)
	{//Запуск первичной проверки на Sobeit
        FirstSobeitCheckTimer[playerid] = SetTimerEx("SobeitCamCheck", 4000, 0, "i", playerid);
		SetCameraBehindPlayer(playerid); //ставим нормальную камеру
		TextDrawShowForPlayer(playerid, BlackScreen);//Черный экран
		SelectTextDraw(playerid, 0x00FF00FF); FirstSobeitCheck[playerid] = 1;
		return SendClientMessage(playerid, COLOR_RED, "LAC: {AFAFAF}Начинаем проверку клиента на наличие читов. Пожалуйста, подождите...");
	}//Запуск первичной проверки на Sobeit
	
	if (FirstSobeitCheck[playerid] < 3) return 1; //если не прошел проверку на собейт
	else TextDrawHideForPlayer(playerid, BlackScreen);//убираем черный экран от проверки на sobeit
	
	if (InEvent[playerid] > 0 && JoinEvent[playerid] > 0) return 1;
	if (Player[playerid][SpawnStyle] == 1)
	{//спавн на авто класса 1
		CallCar1(playerid);//вызов авто класса 1
	}//спавн на авто класса 1
	if (Player[playerid][SpawnStyle] == 2)
	{//спавн на авто класса 2
		CallCar2(playerid);//вызов авто класса 2
	}//spawn на авто класса 2
	if (Player[playerid][SpawnStyle] == 3)
	{//спавн с парашютом
		new Float:x;new Float:y;new Float:z;GiveWeapon(playerid,46,1);
		GetPlayerPos(playerid,x,y,z);SetPlayerPos(playerid,x,y,z+1300);
		GiveWeapon(playerid,46,1);SkydiveTime[playerid] = 60;
	}//спавн с парашютом
	if (Player[playerid][SpawnStyle] == 4)
	{//спавн на авто класса 3
		CallCar3(playerid);//вызов авто класса 3
	}//spawn на авто класса 3
	if (Player[playerid][SpawnStyle] == 5)
	{//спавн на джетпаке
	    JetpackUsed[playerid] = 1;SetPlayerSpecialAction(playerid,SPECIAL_ACTION_USEJETPACK);
	}//спавн на джетпаке
	if (OnStartEvent[playerid] == 0) GiveMyGunWeapons(playerid);//загрузка личного оружия
	if (Logged[playerid] > 0) SetCameraBehindPlayer(playerid);
	if (WorldSpawn[playerid] > 0) SetPlayerVirtualWorld(playerid, WorldSpawn[playerid]); //Чтобы в штабах и в домах точно ставился нужный мир
	if (Logged[playerid] == 0) SetPlayerVirtualWorld(playerid,playerid+1);
	SetPlayerHealth(playerid,100);
return 1;
}//конец паба
//------------ SpawnStyle

stock GiveMyGunWeapons(playerid)
{
    new ammo;
	if (Player[playerid][Slot1] > 0) GiveWeapon(playerid,Player[playerid][Slot1],1);//Слот 1 - Бензопила, Катана, Вибратор
	if (Player[playerid][Slot2] > 0)
	{//Слот 2 - Пистолеты
		GiveWeapon(playerid,Player[playerid][Slot2],1);
		if (Player[playerid][Level] < 31) ammo = 70;
		else if (Player[playerid][Level] < 71) ammo = 140;
		else if (Player[playerid][Level] < 82) ammo = 210;
		else if (Player[playerid][Level] < 92) ammo = 280;
		else ammo = 20000;
		SetPlayerAmmo(playerid, Player[playerid][Slot2], ammo);
	}//Слот 2 - Пистолеты
	if (Player[playerid][Slot3] > 0)
	{//Слот 3 - Дробовики
		GiveWeapon(playerid,Player[playerid][Slot3],1);
		if (Player[playerid][Level] < 33) ammo = 28;
		else if (Player[playerid][Level] < 72) ammo = 56;
		else if (Player[playerid][Level] < 83) ammo = 84;
		else if (Player[playerid][Level] < 93) ammo = 112;
		else ammo = 20000;
		SetPlayerAmmo(playerid, Player[playerid][Slot3], ammo);
	}//Слот 3 - Дробовики
	if (Player[playerid][Slot4] > 0)
	{//Слот 4 - ПП
		GiveWeapon(playerid,Player[playerid][Slot4],1);
		if (Player[playerid][Level] < 37) ammo = 500;
		else if (Player[playerid][Level] < 73) ammo = 1000;
		else if (Player[playerid][Level] < 84) ammo = 1500;
		else if (Player[playerid][Level] < 94) ammo = 2000;
		else ammo = 20000;
		SetPlayerAmmo(playerid, Player[playerid][Slot4], ammo);
	}//Слот 4 - ПП
	if (Player[playerid][Slot5] > 0)
	{//Слот 5 - Автоматы
		GiveWeapon(playerid,Player[playerid][Slot5],1);
		if (Player[playerid][Level] < 41) ammo = 90;
		else if (Player[playerid][Level] < 74) ammo = 180;
		else if (Player[playerid][Level] < 86) ammo = 270;
		else if (Player[playerid][Level] < 95) ammo = 360;
		else ammo = 20000;
		SetPlayerAmmo(playerid, Player[playerid][Slot5], ammo);
	}//Слот 5 - Автоматы
	if (Player[playerid][Slot6] > 0)
	{//Слот 6 - Винтовки
	    if (Player[playerid][Slot6] == 34 && Player[playerid][Karma] <= -800) SendClientMessage(playerid, COLOR_RED, "Снайперская винтовка не выдана из-за слишком низкой кармы.");
	    else
	    {
			GiveWeapon(playerid,Player[playerid][Slot6],1);
			if (Player[playerid][Level] < 44) ammo = 15;
			else if (Player[playerid][Level] < 77) ammo = 30;
			else if (Player[playerid][Level] < 88) ammo = 45;
			else if (Player[playerid][Level] < 97) ammo = 60;
			else ammo = 20000;
			SetPlayerAmmo(playerid, Player[playerid][Slot6], ammo);
		}
	}//Слот 6 - Винтовки
	if (Player[playerid][Slot7] == 35)
	{//Слот 7 - RPG
		GiveWeapon(playerid,35,1);
		if (Player[playerid][Level] < 46) ammo = 10;
		else if (Player[playerid][Level] < 79) ammo = 20;
		else if (Player[playerid][Level] < 89) ammo = 30;
		else if (Player[playerid][Level] < 98) ammo = 40;
		else ammo = 20000;
		SetPlayerAmmo(playerid, Player[playerid][Slot7], ammo);
	}//Слот 7 - RPG
	if (Player[playerid][Slot7] == 38)
	{//Слот 7 - Миниган
		GiveWeapon(playerid,38,1);
		if (Player[playerid][Level] < 82) ammo = 1000;
		else if (Player[playerid][Level] < 81) ammo = 2000;
		else if (Player[playerid][Level] < 99) ammo = 3000;
		else ammo = 20000;
		SetPlayerAmmo(playerid, Player[playerid][Slot7], ammo);
	}//Слот 7 - Миниган
	if (Player[playerid][Slot8] > 0 && Player[playerid][Slot8] != 18)
	{//Слот 8 - Метательное (кроме молотова)
		GiveWeapon(playerid,Player[playerid][Slot8],1);
		if (Player[playerid][Level] < 43) ammo = 10;
		else if (Player[playerid][Level] < 76) ammo = 20;
		else if (Player[playerid][Level] < 87) ammo = 30;
		else if (Player[playerid][Level] < 96) ammo = 40;
		else ammo = 20000;
		SetPlayerAmmo(playerid, Player[playerid][Slot8], ammo);
	}//Слот 8 - Метательное (кроме молотова)
	//Player[playerid][Slot9] используется для стиля драки
	if (Player[playerid][Slot10] > 0)
	{//Прочее
		if(Player[playerid][Slot10] == 46){GiveWeapon(playerid,46,1);}
		if(Player[playerid][Slot10] == 42){GiveWeapon(playerid,42,20000);}
	}//Прочее
	return 1;
}

stock SecFreeze(playerid, count = 1)
{
    TogglePlayerControllable(playerid,0);
    SetTimerEx("UnFreeze" , 1000 * count, false, "i", playerid);
	return 1;
}

stock EndEventFreeze(playerid)
{
    TogglePlayerControllable(playerid,0);
    SetTimerEx("UnFreeze" , 3000, false, "i", playerid);
    SendClientMessage(playerid,COLOR_YELLOW,"Соревнование завершается. Пожалуйста, подождите..");
    ResetPlayerWeapons(playerid);
	return 1;
}

public UnFreeze(playerid) {TogglePlayerControllable(playerid,1);return 1;}
public UnLock(playerid, vehicleid) {SetVehicleParamsForPlayer(vehicleid, playerid, 0, 0);return 1;}
public SideCameraSpecpUpdate(playerid, vehicleid){if (LSpecID[playerid] != -1) PlayerSpectateVehicle(playerid, vehicleid, LSpecMode[playerid]);return 1;}

public PrestigeCarTP(playerid, class, seat1, seat2, seat3)
{
	new Float: x, Float: y, Float: z;GetPlayerPos(playerid,x,y,z);SetPlayerPosFindZ(playerid, x, y, 3000.0);
    if (class == 1){CallCar1(playerid);}
	if (class == 2){CallCar2(playerid);}
	if (class == 3){CallCar3(playerid);}
	if (seat1 != -1){PutPlayerInVehicle(seat1, PlayerCarID[playerid], 1);}
	if (seat2 != -1){PutPlayerInVehicle(seat2, PlayerCarID[playerid], 2);}
	if (seat3 != -1){PutPlayerInVehicle(seat3, PlayerCarID[playerid], 3);}
	TimeTransform[playerid] = 0;TogglePlayerControllable(playerid,1);
	SetCameraBehindPlayer(playerid);
	return 1;
}

public PrestigeCarTPx(playerid, class, seat1, seat2, seat3, Float: vel1, Float: vel2, Float: vel3)
{
	new Float: x, Float: y, Float: z;GetPlayerPos(playerid,x,y,z);SetPlayerPosFindZ(playerid, x, y, 3000.0);
    if (class == 1){CallCar1(playerid);}
	if (class == 2){CallCar2(playerid);}
	if (class == 3){CallCar3(playerid);}
	if (seat1 != -1){PutPlayerInVehicle(seat1, PlayerCarID[playerid], 1);}
	if (seat2 != -1){PutPlayerInVehicle(seat2, PlayerCarID[playerid], 2);}
	if (seat3 != -1){PutPlayerInVehicle(seat3, PlayerCarID[playerid], 3);}
	TimeTransform[playerid] = 0;TogglePlayerControllable(playerid,1);
	SetVehicleVelocity(GetPlayerVehicleID(playerid), vel1, vel2, vel3);
	SetCameraBehindPlayer(playerid);
	return 1;
}

public SpecTextDrawPub(playerid)
{//---------- TextDraw в спектре
	if (LSpecID[playerid] != -1)
	{//Игрок gid следит за кем-то
        SetTimerEx("SpecTextDrawPub" , 500, false, "i", playerid);
		TextDrawHideForPlayer(playerid, SpecInfo[playerid]);
		TextDrawHideForPlayer(playerid, SpecInfoVeh[playerid]);
		LSpecCanFastChange[playerid] = 1;//Доступна быстрая смена ID через стрелочки
		new vid = LSpecID[playerid], String[240], pname[24];
		GetPlayerName(vid, pname, sizeof(pname));
		new Float: hp;GetPlayerHealth(vid, hp);new Float: arm;GetPlayerArmour(vid, arm);
		new hpX = floatround(hp, floatround_round);new armX = floatround(arm, floatround_round);new vehX;
		new ammo = GetPlayerAmmo(vid);new weaponname[48];GetWeaponName(GetPlayerWeapon(vid),weaponname,sizeof(weaponname));
		if(IsPlayerInAnyVehicle(vid))
		{//Если игрок в авто
	        format(String,sizeof(String),"~Y~Player: ~W~%s~Y~[%~W~%d~Y~]    ~Y~Level: ~W~%d    ~Y~Health: ~W~%d    ~Y~Armour: ~W~%d",pname, vid, Player[vid][Level], hpX, armX);
			TextDrawSetString(SpecInfo[playerid], String);TextDrawShowForPlayer(playerid, SpecInfo[playerid]);
		    new vehname[32], vehid = GetPlayerVehicleID(vid);new Float: vehhealth; GetVehicleHealth(vehid, vehhealth);
			vehX = floatround(vehhealth, floatround_round);
			new model = GetVehicleModel(vehid) - 400;format(vehname,sizeof(vehname),"%s", PlayerVehicleName[model]);
			//speedo
			new Float:SPD, Float:vx, Float:vy, Float:vz;
		    GetVehicleVelocity(GetPlayerVehicleID(vid), vx,vy,vz);
		    SPD = floatsqroot(((vx*vx)+(vy*vy))+(vz*vz))*200;
			new speed = floatround(SPD, floatround_round);
			//speedo
			new MaxSpeed = GetVehicleMaxSpeed(GetPlayerVehicleID(vid));
			format(String,sizeof(String),"~B~Vehicle: ~W~%s    ~B~Health: ~W~%d    ~B~Speed: ~W~%d    ~B~Max Speed: ~W~%d",vehname, vehX, speed, MaxSpeed);
			TextDrawSetString(SpecInfoVeh[playerid], String);TextDrawShowForPlayer(playerid, SpecInfoVeh[playerid]);
		}//Если игрок в авто
		else
		{//Игрок пешком
			if (GetPlayerWeapon(vid) == 0) format(String,sizeof(String),"~Y~Player: ~W~%s~Y~[%~W~%d~Y~]    ~Y~Level: ~W~%d    ~Y~Health: ~W~%d    ~Y~Armour: ~W~%d",pname, vid, Player[vid][Level], hpX, armX); //нет оружия
			else if ( 15 < GetPlayerWeapon(vid) < 39) format(String,sizeof(String),"~Y~Player: ~W~%s~Y~[%~W~%d~Y~]    ~Y~Level: ~W~%d    ~Y~Health: ~W~%d    ~Y~Armour: ~W~%d    ~Y~Weapon: ~W~%s ~Y~(~W~%d~Y~)",pname, vid, Player[vid][Level], hpX, armX, weaponname, ammo); //оружие с патронами
			else format(String,sizeof(String),"~Y~Player: ~W~%s~Y~[%~W~%d~Y~]    ~Y~Level: ~W~%d    ~Y~Health: ~W~%d    ~Y~Armour: ~W~%d    ~Y~Weapon: ~W~%s",pname, vid, Player[vid][Level], hpX, armX, weaponname); //оружие, в котором не нужно следить за кол-вом патронов
			TextDrawSetString(SpecInfo[playerid], String);TextDrawShowForPlayer(playerid, SpecInfo[playerid]);
		}//Игрок пешком
	}//Игрок gid следит за кем-то
	else{TextDrawHideForPlayer(playerid, SpecInfo[playerid]);TextDrawHideForPlayer(playerid, SpecInfoVeh[playerid]);}
	return 1;
}//---------- TextDraw в спектре


public ParaEnd(playerid)
{
    new Float: x, Float: y, Float: z, Float:a;GetPlayerPos(playerid,x,y,z);GetPlayerFacingAngle(playerid,a);
	SetPlayerPosFindZ(playerid,x,y,z);SendClientMessage(playerid,COLOR_YELLOW,"Вы успешно приземлились.");
	ApplyAnimation(playerid,"PED","FALL_land",4.1,0,0,0,0,1,1);SetPlayerChatBubble(playerid, "Приземлился", COLOR_GREEN, 100.0, 3000);
	return 1;
}

stock ShowStats(playerid,targetid)
{
	if (Logged[playerid] == 0) return SendClientMessage(playerid,COLOR_RED,"ОШИБКА: Вы должны авторизироваться, чтобы просматривать статистику");
	new String[1500] = "", String2[240], PName[24], clanid = Player[targetid][MyClan];
	GetPlayerName(targetid, PName, sizeof(PName));
	format(String2,sizeof(String2),"{FFFF00}Статистика игрока {FFFFFF}%s\n",PName);

    if (Player[targetid][Admin] == 0) format(String2,sizeof(String2),"{FFFF00}Статистика игрока {FFFFFF}%s\n",PName);
	if (Player[targetid][Admin] == 1){format(String2,sizeof(String2),"{FFFF00}Статистика игрока {FFFFFF}%s [{66CDAA}Модератор{FFFFFF}]\n",PName);}
	if (Player[targetid][Admin] == 2){format(String2,sizeof(String2),"{FFFF00}Статистика игрока {FFFFFF}%s [{9ACD32}Супер-Модератор{FFFFFF}]\n",PName);}
	if (Player[targetid][Admin] == 3){format(String2,sizeof(String2),"{FFFF00}Статистика игрока {FFFFFF}%s [{00BFFF}Администратор{FFFFFF}]\n",PName);}
	if (Player[targetid][Admin] == 4){format(String2,sizeof(String2),"{FFFF00}Статистика игрока {FFFFFF}%s [{FF7F50}Главный Администратор{FFFFFF}]\n",PName);}
		
	if (clanid > 0){format(String2,sizeof(String2),"{FFFF00}Статистика игрока {FFFFFF}[{008E00}%s{FFFFFF}] %s\n",Clan[clanid][cName],PName);}
	if (clanid > 0 && Player[targetid][Admin] == 1){format(String2,sizeof(String2),"{FFFF00}Статистика игрока {FFFFFF}[{008E00}%s{FFFFFF}] %s [{66CDAA}Модератор{FFFFFF}]\n",Clan[clanid][cName],PName);}
	if (clanid > 0 && Player[targetid][Admin] == 2){format(String2,sizeof(String2),"{FFFF00}Статистика игрока {FFFFFF}[{008E00}%s{FFFFFF}] %s [{9ACD32}Супер-Модератор{FFFFFF}]\n",Clan[clanid][cName],PName);}
	if (clanid > 0 && Player[targetid][Admin] == 3){format(String2,sizeof(String2),"{FFFF00}Статистика игрока {FFFFFF}[{008E00}%s{FFFFFF}] %s [{00BFFF}Администратор{FFFFFF}]\n",Clan[clanid][cName],PName);}
	if (clanid > 0 && Player[targetid][Admin] == 4){format(String2,sizeof(String2),"{FFFF00}Статистика игрока {FFFFFF}[{008E00}%s{FFFFFF}] %s [{FF7F50}Главный Администратор{FFFFFF}]\n",Clan[clanid][cName],PName);}
	strcat(String, String2);
	
 	new hours = Player[targetid][Time] / 3600;
	if (hours > 0) format(String2,sizeof(String2),"{AFAFAF}[На сервере проведено: {FFFFFF}%d{AFAFAF} часов]\n", hours);
	else format(String2,sizeof(String2),"{AFAFAF}[На сервере проведено: Менее одного часа]\n", hours);
	strcat(String, String2);

	if (Player[targetid][Prestige] > 0 && Player[targetid][GPremium] == 0){format(String2,sizeof(String2),"{FFFF00}[Престиж {FFFFFF}%d{FFFF00}-го уровня]\n",Player[targetid][Prestige]);strcat(String, String2);}
	if (Player[targetid][Prestige] == 0 && Player[targetid][GPremium] > 0){format(String2,sizeof(String2),"{FFFF00}[ViP {FFFFFF}%d{FFFF00}-го уровня]\n",Player[targetid][GPremium]);strcat(String, String2);}
	if (Player[targetid][Prestige] > 0  && Player[targetid][GPremium] > 0){format(String2,sizeof(String2),"{FFFF00}[Престиж {FFFFFF}%d{FFFF00}-го уровня] {FFFF00}[ViP {FFFFFF}%d{FFFF00}-го уровня]\n",Player[targetid][Prestige],Player[targetid][GPremium]);strcat(String, String2);}
	
    if (Player[targetid][Banned] != 0)
    {//аккаунт забанен
        format(String2,sizeof(String2),"\n{FF0000}Аккаунт заблокирован. Бан выдал: {FFFFFF}%s\n{FF0000}Причина: {FFFFFF}%s\n", BannedBy[targetid], BanReason[targetid]);
        strcat(String, String2);
    }//аккаунт забанен
    
    if (Player[targetid][Muted] != 0)
    {//у игрока затычка чата
        if (Player[targetid][Muted] > 0) format(String2,sizeof(String2),"\n{FF0000}Чат заблокирован. Затычку выдал: {FFFFFF}%s\n{FF0000}Блокировка будет снята через {FFFFFF}%d {FF0000}минут.\n", MutedBy[targetid], Player[targetid][Muted]/60 + 1); //Простой мут
        else format(String2,sizeof(String2),"\n{FF0000}Чат заблокирован. Затычку выдал: {FFFFFF}%s\n{FF0000}Блокировка выдана на неопределенный срок.\n", MutedBy[targetid]); //Супермут
        strcat(String, String2);
    }//у игрока затычка чата
    
    if (Player[targetid][GiveCashBalance] >= 100000000)
    {//Паразит - получил на 100кк больше денег, чем отдал
        strcat(String, "\n{FF0000}Паразит: Этот игрок получил от других игроков гораздо больше денег, \nчем отдал. Он больше не может получать деньги от игроков.\n");
    }//Паразит - получил на 100кк больше денег, чем отдал

    if (Player[targetid][Level] > 0 && (Player[targetid][Level] < 100 || Player[targetid][Prestige] >= 10))
    {//О прокачке
		format(String2,sizeof(String2),"\n{007FFF}XP набрано на уровне: {FFFFFF}%d   {FF8C00}XP осталось набрать: {FFFFFF}%d\n",Player[targetid][Exp],NeedXP[targetid] - Player[targetid][Exp]);strcat(String, String2);
		new kef = 100;if (Player[targetid][GPremium] >= 1) kef = 135; if (Player[targetid][GPremium] >= 5) kef = 160; if (Player[targetid][GPremium] >= 8) kef = 180; if (Player[targetid][GPremium] >= 10) kef = 200;
		if (Player[targetid][GPremium] >= 12) kef = 225; if (Player[targetid][GPremium] >= 15) kef = 250; if (Player[targetid][GPremium] >= 17) kef = 275; if (Player[targetid][GPremium] >= 20) kef = 300;

		if (Player[targetid][GPremium] < 11) format(String2,sizeof(String2),"{AFAFAF}XP набрано за этот час: {FFFFFF}%d   {AFAFAF}Лимит XP в час:{FFFFFF} %d\n",Player[targetid][LastHourExp] * kef / 100, kef * 50);
		else format(String2,sizeof(String2),"{AFAFAF}XP набрано за этот час: {FFFFFF}%d\n",Player[targetid][LastHourExp] * kef / 100);
 		strcat(String, String2);
 		format(String2,sizeof(String2),"{AFAFAF}Получено XP от клана за этот час: {FFFFFF}%d\n\n",Player[targetid][LastHourReferalExp]);
 		strcat(String, String2);
	}//О прокачке

	if (Player[playerid][Admin] >= 4 || playerid == targetid) format(String2,sizeof(String2),"{FFFF00}Уровень: {FFFFFF}%d   {FFFF00}Денег: {FFFFFF}%d$   {FFFF00}Банк: {FFFFFF}%d$   {FFFF00}Медали: {FFFFFF}%d\n",Player[targetid][Level], Player[targetid][Cash], Player[targetid][Bank], Player[targetid][Medals]);
	else format(String2,sizeof(String2),"{FFFF00}Уровень: {FFFFFF}%d\n",Player[targetid][Level]);
	strcat(String, String2);
	
	if (Player[targetid][Karma] < 0) format(String2,sizeof(String2),"{FFFF00}Карма: {FF0000}%d   {FFFF00}Заданий выполнено:{FFFFFF} %d\n", Player[targetid][Karma], Player[targetid][CompletedQuests]);
	else format(String2,sizeof(String2),"{FFFF00}Карма: {008E00}+%d   {FFFF00}Заданий выполнено:{FFFFFF} %d\n", Player[targetid][Karma], Player[targetid][CompletedQuests]);
	strcat(String, String2);

	if (Player[targetid][Spawn] == 0)
	{
		if (Player[targetid][Level] < 3){strcat(String, "{FFFF00}Место спавна: {FFFFFF}Grove Street   ");}
		if (Player[targetid][Level] >= 3 && Player[targetid][Level] < 15){strcat(String, "{FFFF00}Место спавна: {FFFFFF}Лос Сантос   ");}
		if (Player[targetid][Level] >= 15 && Player[targetid][Level] < 25){strcat(String, "{FFFF00}Место спавна: {FFFFFF}Сан Фиерро   ");}
		if (Player[targetid][Level] >= 25 && Player[targetid][Level] < 73){strcat(String, "{FFFF00}Место спавна: {FFFFFF}Лас Вентурас   ");}
		if (Player[targetid][Level] >= 73){strcat(String, "{FFFF00}Место спавна: {FFFFFF}Гора Chilliad   ");}
	}
	if (Player[targetid][Spawn] == 4){strcat(String, "{FFFF00}Место спавна: {FFFFFF}Личный дом (Снаружи)   ");}
	if (Player[targetid][Spawn] == 5){strcat(String, "{FFFF00}Место спавна: {FFFFFF}Штаб клана   ");}
	if (Player[targetid][Spawn] == 6){strcat(String, "{FFFF00}Место спавна: {FFFFFF}Личный дом (Внутри)   ");}
	if (Player[targetid][Spawn] == 7){strcat(String, "{FFFF00}Место спавна: {FFFFFF}Личная позиция (ViP)   ");}
	if (Player[targetid][Spawn] == 8){strcat(String, "{FFFF00}Место спавна: {FFFFFF}Штаб клана (Внутри)   ");}
	if (Player[targetid][SpawnStyle] == 0){strcat(String, "{FFFF00}Стиль спавна: {FFFFFF}Нет\n");}
	if (Player[targetid][SpawnStyle] == 1){strcat(String, "{FFFF00}Стиль спавна: {FFFFFF}На авто класса 1\n");}
	if (Player[targetid][SpawnStyle] == 2){strcat(String, "{FFFF00}Стиль спавна: {FFFFFF}На авто класса 2\n");}
	if (Player[targetid][SpawnStyle] == 3){strcat(String, "{FFFF00}Стиль спавна: {FFFFFF}Десант\n");}
	if (Player[targetid][SpawnStyle] == 4){strcat(String, "{FFFF00}Стиль спавна: {FFFFFF}На авто класса 3\n");}
	if (Player[targetid][SpawnStyle] == 5){strcat(String, "{FFFF00}Стиль спавна: {FFFFFF}На JetPack\n");}
	
	new veh1[30]; if(Player[targetid][CarSlot1] == 0){veh1 = "";}else{new mid = Player[targetid][CarSlot1] - 400;format(veh1,sizeof(veh1),"%s", PlayerVehicleName[mid]);}
    new veh2[30]; if(Player[targetid][CarSlot2] == 0){veh2 = "";}else{new mid = Player[targetid][CarSlot2] - 400;format(veh2,sizeof(veh2),"%s", PlayerVehicleName[mid]);}
    new veh3[30]; if(Player[targetid][CarSlot3] == 0){veh3 = "";}else{new mid = Player[targetid][CarSlot3] - 400;format(veh3,sizeof(veh3),"%s", PlayerVehicleName[mid]);} if(Player[targetid][CarSlot3] == 539){format(veh3,sizeof(veh3),"%s{9966CC}Uber{007FFF}Vortex");}
    if(strlen(veh1) == 0 && strlen(veh2) == 0 && strlen(veh3) == 0) veh1 = "Нет";//Если вообще нет транспорта
    format(String2,sizeof(String2),"{FFFF00}Транспорт:{FFFFFF} %s   %s   %s\n", veh1, veh2, veh3);strcat(String, String2);

	ShowPlayerDialog(playerid, 999, 0, "Статистика", String, "ОК", "");
	return 1;
}


stock ShowKarma(playerid)
{
	new String[1024], Caption[40];

	if (Player[playerid][Karma] < 0) format(Caption,sizeof Caption,"Ваша карма: {FF0000}%d", Player[playerid][Karma]);
	else format(Caption,sizeof Caption,"Ваша карма: {008E00}+%d", Player[playerid][Karma]);

	strcat(String, "{FFFF00}Штрафы и бонусы кармы:\n{008E00}");

    strcat(String, "+800 и выше: Стоимость личного транспорта снижена в два раза.\n");
    strcat(String, "+600 и выше: Аптечки и броня бесплатны.\n");
	strcat(String, "+400 и выше: Команда {FFFFFF}/skydive{008E00} бесплатна.{FF0000}\n\n");

    strcat(String, "-400 и ниже: Невидимость недоступна.\n");
    strcat(String, "-600 и ниже: Броня недоступна.\n");
    strcat(String, "-800 и ниже: Снайперская винтовка недоступна.\n");
    
    strcat(String, "\n{FFFF00}Ваша карма изменяется соответственно вашему поведению на сервере.\n");
    strcat(String, "{008E00}+ Увеличивается со временем, если вы ведете себя мирно и никого не убиваете.\n");
    strcat(String, "{FF0000}- Уменьшается когда вы убиваете других игроков за пределами соревнований.\n");

	ShowPlayerDialog(playerid, 999, 0, Caption, String, "ОК", "");
	return 1;
}

stock ShowPInfo(playerid, targetid)
{
	if (Player[playerid][Admin] < Player[targetid][Admin]) return 1;//админы ниже статусом не могут смотреть инфу выбранного админа, когда тот в хайде
	new String[1500] = ""; new String2[240]; new PName[24];	GetPlayerName(targetid, PName, sizeof(PName));
	format(String2,sizeof(String2),"{FFFF00}Скрытые данные игрока {FFFFFF}%s\n",PName);
	if (Player[targetid][Admin] == 1){format(String2,sizeof(String2),"{FFFF00}Скрытые данные игрока {FFFFFF}%s [{66CDAA}Модератор{FFFFFF}]\n",PName);}
	if (Player[targetid][Admin] == 2){format(String2,sizeof(String2),"{FFFF00}Скрытые данные игрока {FFFFFF}%s [{9ACD32}Супер-Модератор{FFFFFF}]\n",PName);}
	if (Player[targetid][Admin] == 3){format(String2,sizeof(String2),"{FFFF00}Скрытые данные игрока {FFFFFF}%s [{00BFFF}Администратор{FFFFFF}]\n",PName);}
	if (Player[targetid][Admin] == 4){format(String2,sizeof(String2),"{FFFF00}Скрытые данные игрока {FFFFFF}%s [{FF7F50}Главный Администратор{FFFFFF}]\n",PName);}

	new clanid = Player[targetid][MyClan];
	if (clanid > 0){format(String2,sizeof(String2),"{FFFF00}Скрытые данные игрока {FFFFFF}[{008E00}%s{FFFFFF}] %s\n",Clan[clanid][cName],PName);}
	if (clanid > 0 && Player[targetid][Admin] == 1){format(String2,sizeof(String2),"{FFFF00}Скрытые данные игрока {FFFFFF}[{008E00}%s{FFFFFF}] %s [{66CDAA}Модератор{FFFFFF}]\n",Clan[clanid][cName],PName);}
	if (clanid > 0 && Player[targetid][Admin] == 2){format(String2,sizeof(String2),"{FFFF00}Скрытые данные игрока {FFFFFF}[{008E00}%s{FFFFFF}] %s [{9ACD32}Супер-Модератор{FFFFFF}]\n",Clan[clanid][cName],PName);}
	if (clanid > 0 && Player[targetid][Admin] == 3){format(String2,sizeof(String2),"{FFFF00}Скрытые данные игрока {FFFFFF}[{008E00}%s{FFFFFF}] %s [{00BFFF}Администратор{FFFFFF}]\n",Clan[clanid][cName],PName);}
	if (clanid > 0 && Player[targetid][Admin] == 4){format(String2,sizeof(String2),"{FFFF00}Скрытые данные игрока {FFFFFF}[{008E00}%s{FFFFFF}] %s [{FF7F50}Главный Администратор{FFFFFF}]\n",Clan[clanid][cName],PName);}
	strcat(String, String2);
	
	format(String2,sizeof(String2),"{FF0000}IP-Адрес: {FFFFFF}%s\n", PlayerIP[targetid]); strcat(String, String2);
 	if (Player[playerid][Admin] >= 4)
	{
		format(String2,sizeof(String2),"{FF0000}Рублей: {FFFFFF}%0.2f   {FF0000}Рублей за Медали: {FFFFFF}%0.2f   {FF0000}Рублей за все время: {FFFFFF}%0.2f\n", Player[targetid][GameGold], Player[targetid][GGFromMedalsTotal], Player[targetid][GameGoldTotal]); strcat(String, String2);
	    format(String2,sizeof(String2),"{FF0000}Казино: {FFFFFF}%d$   {FF0000}Получение / Отдача Денег: {FFFFFF}%d$\n", Player[targetid][CasinoBalance], Player[targetid][GiveCashBalance]); strcat(String, String2);
	}

	//Погода и время
	if(PlayerTime[targetid] == -1) format(String2,sizeof(String2),"{FF0000}Игровое время: {FFFFFF}Серверное   ");
	else {format(String2,sizeof(String2),"{FF0000}Игровое время: {FFFFFF}%d:00   ",PlayerTime[targetid]);}strcat(String, String2);
	if(PlayerWeather[targetid] == -1) format(String2,sizeof(String2),"{FF0000}Погода: {FFFFFF}Серверная\n");
	else {format(String2,sizeof(String2),"{FF0000}Погода: {FFFFFF}%d\n",PlayerWeather[targetid]);}strcat(String, String2);
	
	//Местоположение
	strcat(String, "\n{FFFF00}Информация от lookupffs.com\n");
	format(String2, sizeof(String2), "{FF0000}Страна: {FFFFFF}%s   {FF0000}Город: {FFFFFF}%s\n", GetPlayerCountryName(targetid), GetPlayerCountryRegion(targetid));strcat(String, String2);
	format(String2, sizeof(String2), "{FF0000}Провайдер: {FFFFFF}%s\n", GetPlayerISP(targetid));strcat(String, String2);
	format(String2, sizeof(String2), "{FF0000}Host: {FFFFFF}%s\n", GetPlayerHost(targetid));strcat(String, String2);

	//О регистрации
	strcat(String, "\n{FFFF00}Регистрационные данные\n");
	if (Registered[targetid] == 0) strcat(String, "{AFAFAF}Не зарегистрирован.\n");
	else
	{//Зарегистрирован
		format(String2, sizeof(String2), "{AFAFAF}Дата регистрации: {FFFFFF}%s   {AFAFAF}IP: {FFFFFF}%s\n", RegisterDate[targetid], RegisterIP[targetid]); strcat(String, String2);
		format(String2, sizeof(String2), "{AFAFAF}Место регистрации: {FFFFFF}%s\n", RegisterLocation[targetid]); strcat(String, String2);
		format(String2, sizeof(String2), "{AFAFAF}Провайдер: {FFFFFF}%s\n", RegisterISP[targetid]); strcat(String, String2);
		format(String2, sizeof(String2), "{AFAFAF}Хост: {FFFFFF}%s\n", RegisterHost[targetid]); strcat(String, String2);
	}//Зарегистрирован

	ShowPlayerDialog(playerid, 999, 0, "Скрытые Данные", String, "ОК", "");
	return 1;
}

stock ShowServerInfo(playerid)
{
    LastProperty = 1; OwnedProperty = 0; SuperProperty = 0;
    for(new i = 1; i < MAX_PROPERTY; i++)
	{
	    if(strcmp(Property[i][pOwner], "Никто")) OwnedProperty++;
	    if(Property[i][pBuyBlock] > 0) SuperProperty++;
		LastProperty++;
	}
	LastBase = 1, OwnedBase = 0;
	for(new i = 1; i < MAX_BASE; i++)
	{
	    if(Base[i][bClan] > 0) OwnedBase++;
		LastBase++;
	}
	new clans, LastClan;
	for(new i = 1; i < MAX_CLAN; i++)
	{
	    if(Clan[i][cLevel] > 0) clans++;
	    LastClan++;
	}
	//------------------------------------
	new String[1500] = "", String2[240];
	format(String2,sizeof(String2),"{FFFF00}Домов занято: {FFFFFF}%d из %d{FFFF00}   Неперекупаемых домов: {FFFFFF}%d\n", OwnedProperty, LastProperty - 1, SuperProperty);strcat(String, String2);
	format(String2,sizeof(String2),"{FFFF00}Штабов занято: {FFFFFF}%d из %d{FFFF00}\n", OwnedBase, LastBase - 1);strcat(String, String2);
	format(String2,sizeof(String2),"{FFFF00}Кланов на сервере: {FFFFFF}%d{FFFF00}   {FFFF00}Максимум: {FFFFFF}%d\n\n", clans, LastClan);strcat(String, String2);

    format(String2,sizeof(String2),"{FFFF00}Игроков на сервере: {FFFFFF}%d   {FFFF00}Максимальный ID транспорта: {FFFFFF}%d\n\n", PlayersOnline, MaxVehicleUsed);strcat(String, String2);

	format(String2,sizeof(String2),"{FF0000}Последний рестарт был %s",RestartDate);strcat(String, String2);

	ShowPlayerDialog(playerid, 999, 0, "Статистика сервера", String, "ОК", "");
	return ;
}





stock ShowClanStats(playerid, clanid)
{//ShowClanStats
 	new Free = 0;
 	if (clanid < 1 || clanid > MaxClanID || Clan[clanid][cLevel] < 1) return SendClientMessage(playerid, COLOR_RED, "Клан с таким ID не зарегистрирован!");
	if(!strcmp(Clan[clanid][cMember1], "Пусто", true)) Free++;
	if(!strcmp(Clan[clanid][cMember2], "Пусто", true)) Free++;
	if(!strcmp(Clan[clanid][cMember3], "Пусто", true)) Free++;
	if(!strcmp(Clan[clanid][cMember4], "Пусто", true)) Free++;
	if(!strcmp(Clan[clanid][cMember5], "Пусто", true)) Free++;
	if(!strcmp(Clan[clanid][cMember6], "Пусто", true)) Free++;
	if(!strcmp(Clan[clanid][cMember7], "Пусто", true)) Free++;
	if(!strcmp(Clan[clanid][cMember8], "Пусто", true)) Free++;
	if(!strcmp(Clan[clanid][cMember9], "Пусто", true)) Free++;
	if(!strcmp(Clan[clanid][cMember10], "Пусто", true)) Free++;
	if(!strcmp(Clan[clanid][cMember11], "Пусто", true)) Free++;
	if(!strcmp(Clan[clanid][cMember12], "Пусто", true)) Free++;
	if(!strcmp(Clan[clanid][cMember13], "Пусто", true)) Free++;
	if(!strcmp(Clan[clanid][cMember14], "Пусто", true)) Free++;
	if(!strcmp(Clan[clanid][cMember15], "Пусто", true)) Free++;
	if(!strcmp(Clan[clanid][cMember16], "Пусто", true)) Free++;
	if(!strcmp(Clan[clanid][cMember17], "Пусто", true)) Free++;
	if(!strcmp(Clan[clanid][cMember18], "Пусто", true)) Free++;
	if(!strcmp(Clan[clanid][cMember19], "Пусто", true)) Free++;
	if(!strcmp(Clan[clanid][cMember20], "Пусто", true)) Free++;

	new StringX[1024], StringZ[140], cNeedXP = Clan[clanid][cLevel] * 100000 + 100000;
	format(StringZ,sizeof(StringZ),"{008E00}Статистика клана {FFFFFF}%s {008E00}[ID:{FFFFFF}%d{008E00}]\n",Clan[clanid][cName], clanid);
	strcat(StringX, StringZ);
	//Строка ниже - уведомление, что нужно купить штаб, чтобы клан не был распущен
	if (Clan[clanid][cLastDay] != 0) {format(StringZ, sizeof StringZ, "{FF0000}Клан будет распущен %s если у него не появится штаб!\nКроме того, при отсутствии штаба цвет клана не работает!\n", IntDateToStringDate(Clan[clanid][cLastDay])); strcat(StringX, StringZ);}
	Free = 20 - Free;//наоборот высчитывает сколько занято

	//Обновление уровня и его отображение
	if (Clan[clanid][cXP] >= cNeedXP && Clan[clanid][cLevel] < 100) {Clan[clanid][cXP] -= cNeedXP; Clan[clanid][cLevel] += 1; SaveClan(clanid); cNeedXP += 100000;}
	format(StringZ,sizeof(StringZ),"\n{FF7F50}Уровень клана: {FFFFFF}%d   {AFAFAF}Цвет № {FFFFFF}%d\n",Clan[clanid][cLevel], Clan[clanid][cColor]);

	strcat(StringX, StringZ);
	format(StringZ,sizeof(StringZ),"{AFAFAF}XP набрано: {FFFFFF}%d   {AFAFAF}XP осталось набрать: {FFFFFF}%d",Clan[clanid][cXP], cNeedXP - Clan[clanid][cXP]);
	if (Clan[clanid][cLevel] < 100) strcat(StringX, StringZ);
	
	if (Clan[clanid][cBase] == 0){format(StringZ,sizeof(StringZ),"\n\n{007FFF}Лидер клана: {FFFF00}%s   {007FFF}Штаб: {FFFF00}Нет\n{008E00}Мест занято: %d / 20    Члены клана:\n",Clan[clanid][cLider],Free);}
	if (Clan[clanid][cBase] > 0){format(StringZ,sizeof(StringZ),"\n\n{007FFF}Лидер клана: {FFFF00}%s   {007FFF}Штаб: {FFFF00}Есть\n{008E00}Мест занято: %d / 20    Члены клана:\n",Clan[clanid][cLider],Free);}
	if (Clan[clanid][cBase] > MAX_BASE){format(StringZ,sizeof(StringZ),"\n\n{007FFF}Лидер клана: {FFFF00}%s   {007FFF}Штаб: {FF0000}Перекуплен\n{008E00}Мест занято: %d / 20    Члены клана:\n",Clan[clanid][cLider],Free);}
	strcat(StringX, StringZ);
	format(StringZ,sizeof(StringZ),"{AFAFAF}%s   %s   %s   %s\n",Clan[clanid][cMember1],Clan[clanid][cMember2],Clan[clanid][cMember3],Clan[clanid][cMember4]);
	strcat(StringX, StringZ);
	format(StringZ,sizeof(StringZ),"%s   %s   %s   %s\n",Clan[clanid][cMember5],Clan[clanid][cMember6],Clan[clanid][cMember7],Clan[clanid][cMember8]);
	strcat(StringX, StringZ);
	format(StringZ,sizeof(StringZ),"%s   %s   %s   %s\n",Clan[clanid][cMember9],Clan[clanid][cMember10],Clan[clanid][cMember11],Clan[clanid][cMember12]);
	strcat(StringX, StringZ);
	format(StringZ,sizeof(StringZ),"%s   %s   %s   %s\n",Clan[clanid][cMember13],Clan[clanid][cMember14],Clan[clanid][cMember15],Clan[clanid][cMember16]);
	strcat(StringX, StringZ);
	format(StringZ,sizeof(StringZ),"%s   %s   %s   %s\n",Clan[clanid][cMember17],Clan[clanid][cMember18],Clan[clanid][cMember19],Clan[clanid][cMember20]);
	strcat(StringX, StringZ);

	ShowPlayerDialog(playerid, 999, 0, "Статистика клана", StringX, "ОК", "");
	return 1;
}//ShowClanStats

stock ShowEvents(playerid)
{//ShowEvents
	new StringX[2048], String[180], ClosestEvents = 0;
	strcat(StringX, "{FFFF00}Соревнования в ближайшие 3 минуты:\n");
	
	if (DMTimer <= 180 && DMTimer > 0 && DMPlayers < DMLimit)
	{
		if (DMTimer < 60){format (String, sizeof(String),"{33FF00}/dm\t\t{FF8C00}Десматч <<{FFFFFF}%s{FF8C00}>> начнется через {FFFFFF}%d{FF8C00} секунд. Игроков: {FFFFFF}%d\n",DMName[DMid], DMTimer, DMPlayers);}
        else{new emin = DMTimer/60;format (String, sizeof(String),"{33FF00}/dm\t\t{FF8C00}Десматч <<{FFFFFF}%s{FF8C00}>> начнется через {FFFFFF}%d{FF8C00} минут {FFFFFF}%d{FF8C00} секунд. Игроков: {FFFFFF}%d\n",DMName[DMid], emin, DMTimer - emin*60, DMPlayers);}
		strcat(StringX, String); ClosestEvents++;
	}
	else if (DMTimeToEnd > 0 && DMPlayers < DMLimit)
	{
		format (String, sizeof(String),"{33FF00}/dm\t\t{FF8C00}Десматч <<{FFFFFF}%s{FF8C00}>> идет прямо сейчас! Игроков: {FFFFFF}%d\n",DMName[DMid], DMPlayers);
		strcat(StringX, String); ClosestEvents++;
	}
	
	if (DerbyTimer < 180 && DerbyTimer > 0 && DerbyPlayers < DerbyLimit)
	{
		if (DerbyTimer < 60){format (String, sizeof(String),"{33FF00}/derby\t\t{9966CC}Дерби <<{FFFFFF}%s{9966CC}>> начнется через {FFFFFF}%d{9966CC} секунд. Игроков: {FFFFFF}%d\n",DerbyName[Derbyid], DerbyTimer, DerbyPlayers);}
        else{new emin = DerbyTimer/60;format (String, sizeof(String),"{33FF00}/derby\t\t{9966CC}Дерби <<{FFFFFF}%s{9966CC}>> начнется через {FFFFFF}%d{9966CC} минут {FFFFFF}%d{9966CC} секунд. Игроков: {FFFFFF}%d\n",DerbyName[Derbyid], emin, DerbyTimer - emin*60, DerbyPlayers);}
		strcat(StringX, String); ClosestEvents++;
	}
	
	if (ZMTimer < 180 && ZMTimer > 0 && ZMPlayers < ZMLimit)
	{
		if (ZMTimer < 60){format (String, sizeof(String),"{33FF00}/zombie\t{E60020}Зомби-Выживание <<{FFFFFF}%s{E60020}>> начнется через {FFFFFF}%d{E60020} секунд. Игроков: {FFFFFF}%d\n",ZMName[ZMid], ZMTimer, ZMPlayers);}
        else{new emin = ZMTimer/60;format (String, sizeof(String),"{33FF00}/zombie\t{E60020}Зомби-Выживание <<{FFFFFF}%s{E60020}>> начнется через {FFFFFF}%d{E60020} минут {FFFFFF}%d{E60020} секунд. Игроков: {FFFFFF}%d\n",ZMName[ZMid], emin, ZMTimer - emin*60, ZMPlayers);}
		strcat(StringX, String); ClosestEvents++;
	}
	
	if (FRTimer < 180 && FRTimer > 0 && FRPlayers < FRLimit)
	{
		if (FRTimer < 60){format (String, sizeof(String),"{33FF00}/race\t\t{007FFF}Гонка начнется через {FFFFFF}%d{007FFF} секунд. Игроков: {FFFFFF}%d\n", FRTimer, FRPlayers);}
        else{new emin = FRTimer/60;format (String, sizeof(String),"{33FF00}/race\t\t{007FFF}Гонка начнется через {FFFFFF}%d{007FFF} минут {FFFFFF}%d{007FFF} секунд. Игроков: {FFFFFF}%d\n", emin, FRTimer - emin*60, FRPlayers);}
		strcat(StringX, String);
		format(String,sizeof(String),"\t\t{007FFF}Старт: {FFFFFF}%s{007FFF}. Финиш: {FFFFFF}%s{007FFF}.\n",FRName[FRStart],FRName[FRFinish]);
		strcat(StringX, String); ClosestEvents++;
	}

	if (GGTimer < 180 && GGTimer > 0 && GGPlayers < GGLimit)
	{
		if (GGTimer < 60){format (String, sizeof(String),"{33FF00}/gungame\t{FF6666}Гонка Вооружений <<{FFFFFF}%s{FF6666}>> начнется через {FFFFFF}%d{FF6666} секунд. Игроков: {FFFFFF}%d\n",GGName[GGid], GGTimer, GGPlayers);}
        else{new emin = GGTimer/60;format (String, sizeof(String),"{33FF00}/gungame\t{FF6666}Гонка Вооружений <<{FFFFFF}%s{FF6666}>> начнется через {FFFFFF}%d{FF6666} минут {FFFFFF}%d{FF6666} секунд. Игроков: {FFFFFF}%d\n",GGName[GGid], emin, GGTimer - emin*60, GGPlayers);}
		strcat(StringX, String); ClosestEvents++;
	}
	else if (GGTimeToEnd > 0 && GGPlayers < GGLimit)
	{
		format (String, sizeof(String),"{33FF00}/gungame\t{FF6666}Гонка Вооружений <<{FFFFFF}%s{FF6666}>> идет прямо сейчас! Игроков: {FFFFFF}%d\n",GGName[GGid], GGPlayers);
		strcat(StringX, String); ClosestEvents++;
	}
	
	if (XRTimer <= 180 && XRTimer > 0 && XRPlayers < XRLimit)
	{
		if (XRTimer < 60){format (String, sizeof(String),"{33FF00}/xrace\t\t{FFD700}Легендарная Гонка <<{FFFFFF}%s{FFD700}>> начнется через {FFFFFF}%d{FFD700} секунд. Игроков: {FFFFFF}%d\n",XRName[XRid], XRTimer, XRPlayers);}
        else{new emin = XRTimer/60;format (String, sizeof(String),"{33FF00}/xrace\t\t{FFD700}Легендарная Гонка <<{FFFFFF}%s{FFD700}>> начнется через {FFFFFF}%d{FFD700} минут {FFFFFF}%d{FFD700} секунд. Игроков: {FFFFFF}%d\n",XRName[XRid], emin, XRTimer - emin*60, XRPlayers);}
		strcat(StringX, String); ClosestEvents++;
	}

	if (ClosestEvents == 0)
	{
	    format (String, sizeof(String),"{AFAFAF}В ближайшие 3 минуты нет никаких соревнований.\nПодождите немного или займитесь чем-нибудь другим.\n",GGName[GGid], GGPlayers);
		strcat(StringX, String); ClosestEvents++;
	}



	ShowPlayerDialog(playerid, 999, 0, "Доступные соревнования", StringX, "ОК", "");
	return 1;
}//ShowEvents

stock ShowQuests(playerid)
{//ShowQuests
	new StringX[1024], String[180];

	for (new i = 0; i <= 2; i++)
	{//цикл
	    if (QuestTime[playerid][i] > 0) format(String, sizeof String, "{FB98DA}Новое задание появится здесь через %d минут\n", QuestTime[playerid][i] / 60 + 1);
	    else switch (Quest[playerid][i])
	    {//switch
	        case 1: format(String, sizeof String, "{FFFFFF}Убейте 40 игроков в десматче: {007FFF}%d{FFFFFF} / 40\n", QuestScore[playerid][i]);
	        case 2: format(String, sizeof String, "{FFFFFF}Убейте 5 игроков при помощи холодного оружия: {007FFF}%d{FFFFFF} / 5\n", QuestScore[playerid][i]);
	        case 3: format(String, sizeof String, "{FFFFFF}Убейте 15 зомби в зомби-выживании: {007FFF}%d{FFFFFF} / 15\n", QuestScore[playerid][i]);
	        case 4: format(String, sizeof String, "{FFFFFF}Убейте 15 игроков в гонке вооружений: {007FFF}%d{FFFFFF} / 15\n", QuestScore[playerid][i]);
	        case 5: format(String, sizeof String, "{FFFFFF}Убейте 5 игроков за пределами соревнований: {007FFF}%d{FFFFFF} / 5\n", QuestScore[playerid][i]);
	        case 6: format(String, sizeof String, "{FFFFFF}Убейте 50 игроков: {007FFF}%d{FFFFFF} / 50\n", QuestScore[playerid][i]);
	        case 7: format(String, sizeof String, "{FFFFFF}Совершите 10 убийств из любого пистолета: {007FFF}%d{FFFFFF} / 10\n", QuestScore[playerid][i]);
	        case 8: format(String, sizeof String, "{FFFFFF}Совершите 10 убийств из любого дробовика: {007FFF}%d{FFFFFF} / 10\n", QuestScore[playerid][i]);
	        case 9: format(String, sizeof String, "{FFFFFF}Совершите 10 убийств из любого пистолет-пулемета: {007FFF}%d{FFFFFF} / 10\n", QuestScore[playerid][i]);
	        case 10: format(String, sizeof String, "{FFFFFF}Совершите 10 убийств из любого автомата: {007FFF}%d{FFFFFF} / 10\n", QuestScore[playerid][i]);
	        case 11: format(String, sizeof String, "{FFFFFF}Примите участие в 3 десматчах: {007FFF}%d{FFFFFF} / 3\n", QuestScore[playerid][i]);
	        case 12: format(String, sizeof String, "{FFFFFF}Примите участие в 3 дерби: {007FFF}%d{FFFFFF} / 3\n", QuestScore[playerid][i]);
	        case 13: format(String, sizeof String, "{FFFFFF}Примите участие в 3 зомби-выживаниях: {007FFF}%d{FFFFFF} / 3\n", QuestScore[playerid][i]);
	        case 14: format(String, sizeof String, "{FFFFFF}Примите участие в 3 гонках: {007FFF}%d{FFFFFF} / 3\n", QuestScore[playerid][i]);
	        case 15: format(String, sizeof String, "{FFFFFF}Подарите другим игрокам 50 000$: {007FFF}%d{FFFFFF} / 50000\n", QuestScore[playerid][i]);
	        case 16: format(String, sizeof String, "{FFFFFF}Примите участие в 3 легендарных гонках: {007FFF}%d{FFFFFF} / 3\n", QuestScore[playerid][i]);
	        case 17: format(String, sizeof String, "{FFFFFF}Примите участие в 3 гонках вооружений: {007FFF}%d{FFFFFF} / 3\n", QuestScore[playerid][i]);
	        case 18: format(String, sizeof String, "{FFFFFF}Примите участие в 5 любых соревнованиях: {007FFF}%d{FFFFFF} / 5\n", QuestScore[playerid][i]);
	        case 19: format(String, sizeof String, "{FFFFFF}Ограбьте других игроков на сумму 10 000$: {007FFF}%d{FFFFFF} / 10000\n", QuestScore[playerid][i]);
	        case 20: format(String, sizeof String, "{FFFFFF}Выживите в 2 зомби-выживаниях: {007FFF}%d{FFFFFF} / 2\n", QuestScore[playerid][i]);
	        case 21: format(String, sizeof String, "{FFFFFF}Найдите 5 кейсов: {007FFF}%d{FFFFFF} / 5\n", QuestScore[playerid][i]);
	        case 22: format(String, sizeof String, "{FFFFFF}Примите участие в 5 PvP: {007FFF}%d{FFFFFF} / 5\n", QuestScore[playerid][i]);
	        case 23: format(String, sizeof String, "{FFFFFF}Выиграйте 3 PvP: {007FFF}%d{FFFFFF} / 3\n", QuestScore[playerid][i]);
	        case 24: format(String, sizeof String, "{FFFFFF}Сделайте 20 ставок в казино: {007FFF}%d{FFFFFF} / 20\n", QuestScore[playerid][i]);
	        case 25: format(String, sizeof String, "{FFFFFF}Проведите на сервере 60 минут: {007FFF}%d{FFFFFF} / 60\n", QuestScore[playerid][i]);
	        case 26: format(String, sizeof String, "{FFFFFF}Наберите 3 000 XP: {007FFF}%d{FFFFFF} / 3000\n", QuestScore[playerid][i]);
	        case 27: format(String, sizeof String, "{FFFFFF}Проведите 15 минут на любой работе: {007FFF}%d{FFFFFF} / 15\n", QuestScore[playerid][i]);
	        case 28: format(String, sizeof String, "{FFFFFF}Вызовите личный транспорт 30 раз: {007FFF}%d{FFFFFF} / 30\n", QuestScore[playerid][i]);
	        case 29: format(String, sizeof String, "{FFFFFF}Трансформируйте транспорт 30 раз: {007FFF}%d{FFFFFF} / 30\n", QuestScore[playerid][i]);
	        case 30: format(String, sizeof String, "{FFFFFF}Потратьте 25 000$ в оружейном магазине: {007FFF}%d{FFFFFF} / 25000\n", QuestScore[playerid][i]);

			default: format(String, sizeof String, "{FF0000}Произошла ошибка при обновлении задания! Сообщите администрации!\n");
	    }//switch
	    strcat(StringX, String);
	}//цикл
	strcat(StringX, "{FFCC00}Обменять медали\n");

	format(String, sizeof String, "{AFAFAF}Доступные задания (Медали: {FFFF00}%d{AFAFAF})", Player[playerid][Medals]);
	ShowPlayerDialog(playerid, DIALOG_QUESTS, 2, String, StringX, "Выбрать", "Закрыть");
}//ShowQuests

stock CallCar1(playerid)
{//вызов авто класса 1
    if (Player[playerid][CarSlot1] == 0) return SendClientMessage(playerid,COLOR_RED,"У вас нет автомобиля 1-го класса");
	if (GetPlayerInterior(playerid) != 0 || IsPlayerInRangeOfPoint(playerid, 13.0, 2311.6953,-7.4206,26.7422)) return SendClientMessage(playerid, COLOR_RED, "Нельзя вызывать транспорт в помещениях!");//Игрок в интерьерах или в банке
	if (GetPlayerWeapon(playerid) == 46) return SendClientMessage(playerid,COLOR_RED,"Смените оружие! Нельзя вызывать автомобиль с парашютом за спиной.");
	if (InEvent[playerid] > 0) return SendClientMessage(playerid,COLOR_RED,"Нельзя вызывать машину в соревнованиях!");
	if (QuestActive[playerid] > 0) return SendClientMessage(playerid,COLOR_RED,"Нельзя вызывать личный транспорт на работе!");
	if (TimeTransform[playerid] > 0){new String[120];format(String,sizeof(String),"Вы не можете вызвать транспорт еще {FFFFFF}%d{FF0000} секунд",TimeTransform[playerid]);SendClientMessage(playerid,COLOR_RED,String);return 1;}
    if (OnFly[playerid] == 1) StopFly(playerid);
	Player[playerid][CarActive] = 1; SetPlayerSpecialAction(playerid, 0); //чтобы не было бага с дюпом авто
    new Float: x, Float: y, Float: z, Float: Angle; GetPlayerPos(playerid,x,y,z);
	new wrld = GetPlayerVirtualWorld(playerid); GetPlayerFacingAngle(playerid, Angle);
	PlayerCarID[playerid] = LCreateVehicle(Player[playerid][CarSlot1], x, y, z, Angle, Player[playerid][CarSlot1Color1], Player[playerid][CarSlot1Color2], 0);
	SetVehicleVirtualWorld(PlayerCarID[playerid], wrld);PutPlayerInVehicle(playerid, PlayerCarID[playerid], 0);
    if (Player[playerid][CarSlot1PaintJob] > -1){ChangeVehiclePaintjob(PlayerCarID[playerid], Player[playerid][CarSlot1PaintJob]);}
	//Загрузка компонентов тюнинга
    if (Player[playerid][CarSlot1Component0] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot1Component0]);
    if (Player[playerid][CarSlot1Component1] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot1Component1]);
    if (Player[playerid][CarSlot1Component2] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot1Component2]);
    if (Player[playerid][CarSlot1Component3] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot1Component3]);
    if (Player[playerid][CarSlot1Component4] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot1Component4]);
    if (Player[playerid][CarSlot1Component5] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot1Component5]);
    if (Player[playerid][CarSlot1Component6] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot1Component6]);
    if (Player[playerid][CarSlot1Component7] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot1Component7]);
    if (Player[playerid][CarSlot1Component8] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot1Component8]);
    if (Player[playerid][CarSlot1Component9] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot1Component9]);
    if (Player[playerid][CarSlot1Component10] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot1Component10]);
    if (Player[playerid][CarSlot1Component11] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot1Component11]);
    if (Player[playerid][CarSlot1Component12] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot1Component12]);
    if (Player[playerid][CarSlot1Component13] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot1Component13]);
	LinkVehicleToInterior(PlayerCarID[playerid],GetPlayerInterior(playerid));
	if (Player[playerid][CarSlot1Neon] != 0 && Player[playerid][Prestige] >= 4)
	{//Создание неона
	    new vehicleid = PlayerCarID[playerid];
	    NeonObject1[vehicleid] = CreateDynamicObject(Player[playerid][CarSlot1Neon], 0, 0, 0, 0, 0, 0, wrld, GetPlayerInterior(playerid), -1, 300.0);
	    NeonObject2[vehicleid] = CreateDynamicObject(Player[playerid][CarSlot1Neon], 0, 0, 0, 0, 0, 0, wrld, GetPlayerInterior(playerid), -1, 300.0);
	    AttachDynamicObjectToVehicle(NeonObject1[vehicleid], vehicleid, -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	    AttachDynamicObjectToVehicle(NeonObject2[vehicleid], vehicleid, 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	}//Создание неона
	TimeTransform[playerid] = 5;
	QuestUpdate(playerid, 28, 1);//Обновление квеста Вызовите личный транспорт 30 раз
	return 1;
}//вызов авто класса 1

stock CallCar2(playerid)
{//вызов авто класса 2
    if (Player[playerid][CarSlot2] == 0) return SendClientMessage(playerid,COLOR_RED,"У вас нет автомобиля 2-го класса");
	if (GetPlayerInterior(playerid) != 0 || IsPlayerInRangeOfPoint(playerid, 13.0, 2311.6953,-7.4206,26.7422)) return SendClientMessage(playerid, COLOR_RED, "Нельзя вызывать транспорт в помещениях!");//Игрок в интерьерах или в банке
	if (GetPlayerWeapon(playerid) == 46) return SendClientMessage(playerid,COLOR_RED,"Смените оружие! Нельзя вызывать автомобиль с парашютом на спине.");
	if (InEvent[playerid] > 0) return SendClientMessage(playerid,COLOR_RED,"Нельзя вызывать машину в соревнованиях!");
	if (QuestActive[playerid] > 0) return SendClientMessage(playerid,COLOR_RED,"Нельзя вызывать личный транспорт на работе!");
	if (TimeTransform[playerid] > 0){new String[120];format(String,sizeof(String),"Вы не можете вызвать транспорт еще {FFFFFF}%d{FF0000} секунд",TimeTransform[playerid]);SendClientMessage(playerid,COLOR_RED,String);return 1;}
    if (OnFly[playerid] == 1) StopFly(playerid);
	Player[playerid][CarActive] = 2; SetPlayerSpecialAction(playerid, 0); //чтобы не было бага с дюпом авто
    new Float: x, Float: y, Float: z, Float: Angle; GetPlayerPos(playerid,x,y,z);
	new wrld = GetPlayerVirtualWorld(playerid); GetPlayerFacingAngle(playerid, Angle);
	PlayerCarID[playerid] = LCreateVehicle(Player[playerid][CarSlot2], x, y, z, Angle, Player[playerid][CarSlot2Color1], Player[playerid][CarSlot2Color2], 0);
	SetVehicleVirtualWorld(PlayerCarID[playerid], wrld);PutPlayerInVehicle(playerid, PlayerCarID[playerid], 0);
	if (Player[playerid][CarSlot2PaintJob] > -1){ChangeVehiclePaintjob(PlayerCarID[playerid], Player[playerid][CarSlot2PaintJob]);}
	//Загрузка компонентов тюнинга
    if (Player[playerid][CarSlot2Component0] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot2Component0]);
    if (Player[playerid][CarSlot2Component1] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot2Component1]);
    if (Player[playerid][CarSlot2Component2] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot2Component2]);
    if (Player[playerid][CarSlot2Component3] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot2Component3]);
    if (Player[playerid][CarSlot2Component4] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot2Component4]);
    if (Player[playerid][CarSlot2Component5] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot2Component5]);
    if (Player[playerid][CarSlot2Component6] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot2Component6]);
    if (Player[playerid][CarSlot2Component7] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot2Component7]);
    if (Player[playerid][CarSlot2Component8] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot2Component8]);
    if (Player[playerid][CarSlot2Component9] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot2Component9]);
    if (Player[playerid][CarSlot2Component10] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot2Component10]);
    if (Player[playerid][CarSlot2Component11] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot2Component11]);
    if (Player[playerid][CarSlot2Component12] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot2Component12]);
    if (Player[playerid][CarSlot2Component13] != 0) AddVehicleComponent(PlayerCarID[playerid], Player[playerid][CarSlot2Component13]);
    LinkVehicleToInterior(PlayerCarID[playerid],GetPlayerInterior(playerid));
    if (Player[playerid][CarSlot2Neon] != 0 && Player[playerid][Prestige] >= 4)
	{//Создание неона
	    new vehicleid = PlayerCarID[playerid];
	    NeonObject1[vehicleid] = CreateDynamicObject(Player[playerid][CarSlot2Neon], 0, 0, 0, 0, 0, 0, wrld, GetPlayerInterior(playerid), -1, 300.0);
	    NeonObject2[vehicleid] = CreateDynamicObject(Player[playerid][CarSlot2Neon], 0, 0, 0, 0, 0, 0, wrld, GetPlayerInterior(playerid), -1, 300.0);
	    AttachDynamicObjectToVehicle(NeonObject1[vehicleid], vehicleid, -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	    AttachDynamicObjectToVehicle(NeonObject2[vehicleid], vehicleid, 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	}//Создание неона
	TimeTransform[playerid] = 5;
	QuestUpdate(playerid, 28, 1);//Обновление квеста Вызовите личный транспорт 30 раз
    return 1;
}//вызов авто класса 2

stock CallCar3(playerid)
{//вызов авто класса 3
    if (Player[playerid][CarSlot3] == 0) return SendClientMessage(playerid,COLOR_RED,"У вас нет автомобиля 3-го класса");
	if (GetPlayerInterior(playerid) != 0 || IsPlayerInRangeOfPoint(playerid, 13.0, 2311.6953,-7.4206,26.7422)) return SendClientMessage(playerid, COLOR_RED, "Нельзя вызывать транспорт в помещениях!");//Игрок в интерьерах или в банке
	if (GetPlayerWeapon(playerid) == 46) return SendClientMessage(playerid,COLOR_RED,"Смените оружие! Нельзя вызывать автомобиль с парашютом на спине.");
	if (InEvent[playerid] > 0) return SendClientMessage(playerid,COLOR_RED,"Нельзя вызывать машину в соревнованиях!");
	if (QuestActive[playerid] > 0) return SendClientMessage(playerid,COLOR_RED,"Нельзя вызывать личный транспорт на работе!");
	if (TimeTransform[playerid] > 0){new String[120];format(String,sizeof(String),"Вы не можете вызвать транспорт еще {FFFFFF}%d{FF0000} секунд",TimeTransform[playerid]);SendClientMessage(playerid,COLOR_RED,String);return 1;}
    if (OnFly[playerid] == 1) StopFly(playerid);
	Player[playerid][CarActive] = 3; SetPlayerSpecialAction(playerid, 0); //чтобы не было бага с дюпом авто
    new Float: x, Float: y, Float: z, Float: Angle; GetPlayerPos(playerid,x,y,z);
	new wrld = GetPlayerVirtualWorld(playerid); GetPlayerFacingAngle(playerid, Angle);
	PlayerCarID[playerid] = LCreateVehicle(Player[playerid][CarSlot3], x, y, z + 2, Angle, Player[playerid][CarSlot3Color1], Player[playerid][CarSlot3Color2], 0);
	SetVehicleVirtualWorld(PlayerCarID[playerid], wrld);PutPlayerInVehicle(playerid, PlayerCarID[playerid], 0);
    LinkVehicleToInterior(PlayerCarID[playerid],GetPlayerInterior(playerid));
	TimeTransform[playerid] = 5;
	QuestUpdate(playerid, 28, 1);//Обновление квеста Вызовите личный транспорт 30 раз
    return 1;
}//вызов авто класса 3

stock OnPlayerLogin(playerid)
{//при успешной АВТОРИЗАЦИИ
	if(strcmp(PlayerLimitXPDate[playerid], ServerLimitXPDate))
	{
	    if (Player[playerid][LastHourExp] > 0)
		{
			new String[180];
		    format(String, sizeof String, "%d.%d.%d в %d:%d:%d |   STATISTICS: Игрок %s[%d] получил %d XP за один час", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid, Player[playerid][LastHourExp]);
			WriteLog("StatisticsXP", String);
		}
		if (Player[playerid][LastHourReferalExp] > 0)
		{
			new String[180];
		    format(String, sizeof String, "%d.%d.%d в %d:%d:%d |   STATISTICS: Игрок %s[%d] получил от клана %d XP за один час", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid, Player[playerid][LastHourReferalExp]);
			WriteLog("StatisticsClanXP", String);
		}
		Player[playerid][LastHourExp] = 0; Player[playerid][LastHourReferalExp] = 0;
	}
	format(PlayerLimitXPDate[playerid], 80, "%s", ServerLimitXPDate);
    StopAudioStreamForPlayer(playerid); LoadPlayerClan(playerid);//Загрузка клана

	UpdatePlayer(playerid); ShopUpdate(playerid);
    PlayerWeather[playerid] = -1; PlayerTime[playerid] = -1;//Серверные погода и время после логина

	if (Player[playerid][Home] > 0)
	{//Сообщение о потере дома
		new myhome = Player[playerid][Home];
		if(strcmp(Property[myhome][pOwner], GetName(playerid), true))
		{//дом не принадлежит игроку
			Player[playerid][Home] = 0;
			if (Player[playerid][Spawn] == 4 || Player[playerid][Spawn] == 6 || Player[playerid][Spawn] == 7) Player[playerid][Spawn] = 0;
			SendClientMessage(playerid, COLOR_YELLOW, "Ваш дом перекупили! Деньги были возвращены на ваш банковский счет.");
		}//дом не принадлежит игроку
	}//Сообщение о потере дома

	if (Player[playerid][Level] == 0)
	{//При прошлом заходе не дошел обучение до конца
	    //Запускаем обучение заново
		new String[1024];TutorialStep[playerid] = 1;
		strcat(String, "{007FFF}Обучение: Вызов транспорта{FFFFFF}\n\n");
		strcat(String, "Каждому игроку на сервере с самого начала выдается свой личный автомобиль. Изначально это мопед.\n");
		strcat(String, "Для того, чтобы сесть на него, нажмите клавишу {00FF00}Alt{FFFFFF} и выберите <<{FFFF00}Сесть в машину [Класс 1]{FFFFFF}>>");
		return ShowPlayerDialog(playerid, DIALOG_TUTORIAL, 0, "Обучение", String, "ОК, сейчас", "");
	}//При прошлом заходе не дошел обучение до конца

    HealthTime[playerid] = 0; ArmourTime[playerid] = 0;
	return 1;
}//при успешной АВТОРИЗАЦИИ

stock SpecUpdate(playerid)
{//SpecUpdate
    foreach(Player, i)
	{//обновление спектра у тех, кто следит за игроком
	    if (LSpecID[i] == playerid)
	    {
			SetPlayerInterior(i,GetPlayerInterior(playerid));
			SetPlayerVirtualWorld(i,GetPlayerVirtualWorld(playerid));
			if (IsPlayerInAnyVehicle(playerid))
			{
				PlayerSpectateVehicle(i, GetPlayerVehicleID(playerid), LSpecMode[playerid]);
				//Исправление глюка, когда не сохранялся режим камеры сбоку
                SetTimerEx("SideCameraSpecpUpdate" , 100, false, "id", i, GetPlayerVehicleID(playerid));
			}
			else PlayerSpectatePlayer(i, playerid, LSpecMode[playerid]);
		}
	}//обновление спектра у тех, кто следит за игроком
}//SpecUpdate

//------------ Количество пассажирских сидений в транспорте
new VehiclePassengerSeats[] = {
3,1,1,1,3,3,0,1,1,3,1,1,1,3,1,1,3,1,3,1,3,3,1,1,1,0,3,3,3,1,0,1000,0,1,1,0,1,1000,3,1,3,0,1,1,1,3,0,1,
0,0,0,1,0,0,0,1,1,1,3,3,1,1,1,1,0,0,3,3,1,1,3,1,0,0,1,1,0,1,1,3,1,0,3,3,0,0,0,3,1,1,3,1,3,0,1,1,1,3,
3,1,1,0,1,1,1,1,1,3,1,0,0,1,0,0,1,1,3,1,1,0,0,1,1,1,1,1,1,1,1,3,0,0,0,1,1,1,1,1000,1000,0,3,1,1,1,1,1,
3,3,1,1,3,3,1,0,1,1,1,1,1,1,3,3,1,1,0,1,3,3,0,0,0,0,0,1,0,1,1,0,1,3,3,1,3,0,0,3,1,1,1,1,0,0,1000,1,1,
0,3,3,3,1,1,1,1,1,3,1,0,0,0,3,0,0};
stock GetPassengerSeats(vehicleid) return VehiclePassengerSeats[(GetVehicleModel(vehicleid) - 400)];
//------------ Количество пассажирских сидений в транспорте

stock GiveGGWeapon(playerid)
{
	ResetPlayerWeapons(playerid);
	if (GGKills[playerid] < 1) GivePlayerWeapon(playerid, 24, 20000);
	if (GGKills[playerid] == 1) GivePlayerWeapon(playerid, 25, 20000);
	if (GGKills[playerid] == 2) GivePlayerWeapon(playerid, 26, 20000);
	if (GGKills[playerid] == 3) GivePlayerWeapon(playerid, 27, 20000);
	if (GGKills[playerid] == 4) GivePlayerWeapon(playerid, 29, 20000);
	if (GGKills[playerid] == 5) GivePlayerWeapon(playerid, 28, 20000);
	if (GGKills[playerid] == 6) GivePlayerWeapon(playerid, 32, 20000);
	if (GGKills[playerid] == 7) GivePlayerWeapon(playerid, 31, 20000);
	if (GGKills[playerid] == 8) GivePlayerWeapon(playerid, 30, 20000);
	if (GGKills[playerid] == 9) GivePlayerWeapon(playerid, 16, 20000);
	if (GGKills[playerid] == 10) GivePlayerWeapon(playerid, 34, 20000);
	if (GGKills[playerid] == 11) GivePlayerWeapon(playerid, 35, 20000);
	if (GGKills[playerid] == 12 || GGKills[playerid] == 13) GivePlayerWeapon(playerid, 38, 20000);
	if (GGKills[playerid] == 14) GivePlayerWeapon(playerid, 8, 1);//дать катану
	return 1;
}

stock GetPlayerSpeed(playerid)
{//для LAC flyhack
	new Float:Coord[4];
	GetPlayerVelocity(playerid, Coord[0], Coord[1], Coord[2]);
	Coord[3] = floatsqroot(floatpower(floatabs(Coord[0]), 2.0) + floatpower(floatabs(Coord[1]), 2.0) + floatpower(floatabs(Coord[2]), 2.0)) * 213.3;
	return floatround(Coord[3]);
}//для LAC flyhack

stock LGiveXP(playerid, standartxp)
{//добавление XP
	new LevelXPAvailable = 5000 - Player[playerid][LastHourExp]; if (Player[playerid][GPremium] >= 11) LevelXPAvailable = 999999;
	new XPToLevel, XPToMoney, String[140], XPBonus = 0, MBonus = 0;
	if (standartxp >= LevelXPAvailable) {XPToLevel = LevelXPAvailable; XPToMoney = standartxp - LevelXPAvailable;}
	else {XPToLevel = standartxp; XPToMoney = 0;}
	Player[playerid][LastHourExp] += XPToLevel;

	if (XPToLevel > 0)
	{//Начисление ХР до уровня
	    Player[playerid][Exp] += XPToLevel;
		if (Player[playerid][GPremium] >= 1 && Player[playerid][GPremium] < 5) XPBonus = XPToLevel * 35 / 100;//начисление бонуса 35%
		if (Player[playerid][GPremium] >= 5 && Player[playerid][GPremium] < 8) XPBonus = XPToLevel * 60 / 100;//начисление бонуса 60%
		if (Player[playerid][GPremium] >= 8 && Player[playerid][GPremium] < 10) XPBonus = XPToLevel * 80 / 100;//начисление бонуса 80%
		if (Player[playerid][GPremium] >= 10 && Player[playerid][GPremium] < 12)  XPBonus = XPToLevel;//начисление бонуса 100%
		if (Player[playerid][GPremium] >= 12 && Player[playerid][GPremium] < 15) XPBonus = XPToLevel * 125 / 100;//начисление бонуса 125%
		if (Player[playerid][GPremium] >= 15 && Player[playerid][GPremium] < 17) XPBonus = XPToLevel * 15 / 10;//начисление бонуса 150%
		if (Player[playerid][GPremium] >= 17 && Player[playerid][GPremium] < 20) XPBonus = XPToLevel * 175 / 100;//начисление бонуса 175%
		if (Player[playerid][GPremium] >= 20) XPBonus = XPToLevel * 2;//начисление бонуса 200%
		if (XPBonus > 0) Player[playerid][Exp] += XPBonus;//начисление ХР бонуса VIP

		//----------------------------------- Рефералка
		if (Player[playerid][MyClan] > 0)
		{//Если игрока кто-то пригласил на сервер
		    new RefXP = XPToLevel / 10;//10% от полученного ХР дается соклановцам
		    if (RefXP > 0)
		    {//RefXP > 0
				foreach(Player, cid)
				{//цикл
					if(Player[cid][MyClan] == Player[playerid][MyClan] && cid != playerid && Logged[cid] == 1)
					{//пригласивший в сети
						Player[cid][Exp] += RefXP; Player[cid][LastHourReferalExp] += RefXP;
 						new clanid = Player[playerid][MyClan], ccolor = Clan[clanid][cColor];
						format(String, sizeof String, "Вы получили %d XP от игрока %s[%d].", RefXP, PlayerName[playerid], playerid);
						SendClientMessage(cid, ClanColor[ccolor], String); PlayerPlaySound(cid,1083,0.0,0.0,0.0);
                        if (NeedXP[cid] <= Player[cid][Exp]) PlayerLevelUp(cid);
					}//пригласивший в сети
				}//цикл
		    }//RefXP > 0
		}//Если игрока кто-то пригласил на сервер
		//----------------------------------- Рефералка

	}//Начисление ХР до уровня

	if (XPToMoney > 0)
	{//Начисление ХР в деньги при лимите
	    Player[playerid][Cash] += XPToMoney * 100;//Если из-за лимита не вошли 100хр, то получаешь 10 000 денег
		format(String,sizeof(String),"Лимит XP набран! Вместо них вы получили %d$",XPToMoney * 100);
		SendClientMessage(playerid,0x00FF00FF,String);
	}//Начисление ХР в деньги при лимите
	
	if (Player[playerid][GPremium] >= 6 && Player[playerid][GPremium] < 9) MBonus = standartxp * 15;//ViP 6: x15 денег от XP
	if (Player[playerid][GPremium] >= 9 && Player[playerid][GPremium] < 16) MBonus = standartxp * 30;//ViP 9: x30 денег от XP
	if (Player[playerid][GPremium] >= 16) MBonus = standartxp * 60;//ViP 16: x60 денег от XP
	if (MBonus > 0)	Player[playerid][Cash] += MBonus;//начисление денежного бонуса VIP
	
	if (XPBonus > 0)
	{//Сообщения в чат о начисленных бонусах
		if (MBonus == 0) format(String,sizeof(String),"ViP: Вы получили бонус %d XP",XPBonus);
		else format(String,sizeof(String),"ViP: Вы получили бонус %d XP и %d$",XPBonus, MBonus);
		SendClientMessage(playerid,0x00FF00FF,String);
	}//Сообщения в чат о начисленных бонусах
	
	if (Player[playerid][MyClan] != 0)
	{//Прокачка клана
	    new clanid = Player[playerid][MyClan];
		Clan[clanid][cXP] += standartxp; Clan[clanid][cXP] += XPBonus;
	}//Прокачка клана

	if (Player[playerid][Exp] >= NeedXP[playerid] && (0 < Player[playerid][Level] < 100 || Player[playerid][Prestige] >= 10)) PlayerLevelUp(playerid); //Повышение уровня, если набрано достаточно XP
	QuestUpdate(playerid, 26, standartxp);//Обновление квеста Наберите 3 000 XP
}//добавление XP


public RemoveRamp(playerid)
{
	if (rampid[playerid] != -1)
	{
	    DestroyDynamicObject(rampid[playerid]);
	    rampid[playerid] = -1;
	}
}

Float:GetOptimumRampDistance(playerid)
{
	new ping = GetPlayerPing(playerid), Float:dist;
	dist = floatpower(ping, 0.25);
	dist = dist*4.0;
	dist = dist+5.0;
	return dist;
}

Float:GetXYInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance)
{
	new Float:a;
	GetPlayerPos(playerid, x, y, a);
	if (IsPlayerInAnyVehicle(playerid)) GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
	else GetPlayerFacingAngle(playerid, a);
	x += (distance * floatsin(-a, degrees));
	y += (distance * floatcos(-a, degrees));
	return a;
}

public OnLookupComplete(playerid)
{//Срабатывает сразу при определении местополжения от lookupffs.com
	new String[256];
	format(String, sizeof String, "%d.%d.%d в %d:%d:%d |   CONNECTION: Nick: %s[%d]   IP: %s   Region: %s   Country: %s   ISP: %s   Host: %s", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid, PlayerIP[playerid], GetPlayerCountryRegion(playerid), GetPlayerCountryName(playerid), GetPlayerISP(playerid), GetPlayerHost(playerid));
	WriteLog("ConnectionsLog", String);
	
	if(!strcmp(GetPlayerCountryRegion(playerid), "Kerch") && strlen(GetPlayerCountryRegion(playerid)) > 3)
	{//Бан города Керчь по lookupffs.com по полю Город
		format(String,sizeof(String), "{FF0000}LAC: {AFAFAF}%s Был автоматически забанен (Город: Керчь).",PlayerName[playerid]);
		SendClientMessageToAll(COLOR_GREY,String); BanEx( playerid, "Автобан (Город: Керчь)");
		format(String, 140, "%d.%d.%d в %d:%d:%d |   LAC: %s[%d] %s был автоматически забанен (Город: Керчь)", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid);
		WriteLog("GlobalLog", String);WriteLog("LAC", String);
	}//Бан города Керчь по lookupffs.com
	if(strfind(GetPlayerHost(playerid),"kerch",true) != -1 && strlen(GetPlayerHost(playerid)) > 3)
	{//Бан города Керчь по lookupffs.com по полю Хост
		format(String,sizeof(String), "{FF0000}LAC: {AFAFAF}%s Был автоматически забанен (Город: Керчь).",PlayerName[playerid]);
		SendClientMessageToAll(COLOR_GREY,String); BanEx( playerid, "Автобан (Город: Керчь)");
		format(String, 140, "%d.%d.%d в %d:%d:%d |   LAC: %s[%d] %s был автоматически забанен (Город: Керчь)", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid);
		WriteLog("GlobalLog", String);WriteLog("LAC", String);
	}//Бан города Керчь по lookupffs.com
	if(IsProxyUser(playerid))
	{//Бан игроков, использующих Proxy (подмена IP)
		format(String,sizeof(String), "{FF0000}LAC: {AFAFAF}%s Был автоматически забанен (Подмена IP).",PlayerName[playerid]);
		SendClientMessageToAll(COLOR_GREY,String); BanEx( playerid, "Автобан (Proxy)");
		format(String, 140, "%d.%d.%d в %d:%d:%d |   LAC: %s[%d] %s был автоматически забанен (Подмена IP)", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid);
		WriteLog("GlobalLog", String);WriteLog("LAC", String);
	}//Бан игроков, использующих Proxy (подмена IP)


/*	if(strfind(GetPlayerISP(playerid),"Rostelecom",true) != -1 && strlen(GetPlayerISP(playerid)) > 3 && !strcmp(GetPlayerCountryRegion(playerid), "Saratov"))
	{//Бан города Саратов при провайдере Ростелеком
		format(String,sizeof(String), "{FF0000}LAC: {AFAFAF}%s Был автоматически забанен (Город: Saratov, Провайдер: Rostelecom).",PlayerName[playerid]);
		SendClientMessageToAll(COLOR_GREY,String); BanEx( playerid, "Автобан (Город: Saratov, Rostelecom)");
		format(String, 140, "%d.%d.%d в %d:%d:%d |   LAC: %s[%d] %s был автоматически забанен (Город: Saratov, Провайдер: Rostelecom)", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid);
		WriteLog("GlobalLog", String);WriteLog("LAC", String);
	}///Бан города Саратов при провайдере Ростелеком
*/

	 
	 /*Белый список: Страны, которым РАЗРЕШЕНО играть на сервере (опеределение местоположения через lookupffs.com)
	 new WhiteList = 0;
     if(strfind(GetPlayerCountryName(playerid),"Russian Federation",true) != -1) WhiteList = 1;
     if(strfind(GetPlayerCountryName(playerid),"Kazakhstan",true) != -1) WhiteList = 1;
     if(strfind(GetPlayerCountryName(playerid),"Ukraine",true) != -1) WhiteList = 1;
     if(strfind(GetPlayerCountryName(playerid),"Dagestan",true) != -1) WhiteList = 1;
     if(strfind(GetPlayerCountryName(playerid),"Belarus",true) != -1) WhiteList = 1;
     if(strfind(GetPlayerCountryName(playerid),"Moldova",true) != -1) WhiteList = 1;
     if(strfind(GetPlayerCountryName(playerid),"South Ossetia",true) != -1) WhiteList = 1;
     if(strfind(GetPlayerCountryName(playerid),"Kyrgyzstan",true) != -1) WhiteList = 1;
     if(strfind(GetPlayerCountryName(playerid),"Abkhazia",true) != -1) WhiteList = 1;
     if(strfind(GetPlayerCountryName(playerid),"Tajikistan",true) != -1) WhiteList = 1;
     if(strfind(GetPlayerCountryName(playerid),"Uzbekistan",true) != -1) WhiteList = 1;
     if(strfind(GetPlayerCountryName(playerid),"Latvia",true) != -1) WhiteList = 1;
     if(strfind(GetPlayerCountryName(playerid),"Lithuania",true) != -1) WhiteList = 1;
     if(strfind(GetPlayerCountryName(playerid),"Georgia",true) != -1) WhiteList = 1;
	 //Если страна не определилась - пропустить в белый список
	 if (strlen(GetPlayerCountryName(playerid)) < 3) WhiteList = 1;
	 if (WhiteList == 0) Kick(playerid);*/

	return 1;
}//Срабатывает сразу при определении местополжения от lookupffs.com

public SpeedoUpdate(playerid)
{//Спидометр. Срабатывает два раза в секунду, если игрок в машине
	if (Logged[playerid] == 0 || !IsPlayerInAnyVehicle(playerid) || Player[playerid][ConSpeedo] == 0 || LSpecID[playerid] != -1)
	{TextDrawHideForPlayer(playerid, TextDrawSpeedo[playerid]);LastSpeed[playerid] = 999; return 1;}
	else
	{//Игрок в машине, залогинен, не в спектре
	        SetTimerEx("SpeedoUpdate" , 500, false, "i", playerid);
	   		new Float:SPD, Float:vx, Float:vy, Float:vz, String[140], Float: x, Float: y, Float: z, vehicleid = GetPlayerVehicleID(playerid);
		    GetVehicleVelocity(vehicleid, vx,vy,vz);GetPlayerPos(playerid,x,y,z);
		    SPD = floatsqroot(((vx*vx)+(vy*vy))/*+(vz*vz)*/)*200;
			new speed = floatround(SPD, floatround_round);
			new MaxSpeed = GetVehicleMaxSpeed(vehicleid);
			if (z < LastPlayerSHZ[playerid] && speed > MaxSpeed && speed < MaxSpeed * 11/10 && LACSH[playerid] == 0) NeedSpeedDown[playerid] = 1;//при превышении макс. скорости не более, чем на 10% - занизить скорость
			if (NeedSpeedDown[playerid] > 0 && speed > MaxSpeed){SetVehicleSpeed(vehicleid, MaxSpeed*9/10); speed = MaxSpeed*9/10;} else NeedSpeedDown[playerid] = 0;
			//speedo
			format(String,sizeof(String),"CKOPOCTb: %d Km/h", speed);
			TextDrawSetString(TextDrawSpeedo[playerid], String);TextDrawShowForPlayer(playerid, TextDrawSpeedo[playerid]);
			//anti speedhack test
            new kef = speed - LastSpeed[playerid], cheat = 0, vmodel = GetVehicleModel(vehicleid);
			if (LACSH[playerid] == 0) LastSpeed[playerid] = speed; else LastSpeed[playerid] = 999;
			new Float: VHealth;GetVehicleHealth(vehicleid,VHealth);//Эта и следующая строка исправляют ложное срабатывание при аварии (другой игрок поддает скорость толчком)
			if (VHealth < LastVHealth[playerid]){LastSpeed[playerid] = 999;if (LACSH[playerid] == 0) LACSH[playerid] = 1;}LastVHealth[playerid] = VHealth;
			if (kef > 80 && LACSH[playerid] == 0 && GetPlayerState(playerid) == PLAYER_STATE_DRIVER && Player[playerid][Banned] == 0 && vz >= 0.0) cheat = 1;//Прирост скорости больше 80 за пол секунды (На инфернусе получалось максимум +56, на гидре +76)
			switch(vmodel)
			{//Модель авто
				case 460, 476, 511, 512, 513, 519, 520, 553, 577, 592, 593: cheat = 0;//Не проверять скорость разгона на аэропланах
				case 448, 461, 462, 463, 468, 481, 509, 510, 521, 522, 523, 581, 586: MaxSpeed = 300;//Позволить разгоняться на мотоциклах на заднем колесе
			}//Модель авто
			if (speed > MaxSpeed + 5 && NeedSpeedDown[playerid] == 0 && LACSH[playerid] == 0 && GetPlayerState(playerid) == PLAYER_STATE_DRIVER && Player[playerid][Banned] == 0) cheat = 1;//скорость больше 300 и игрок не находится в падении вниз
            LastPlayerSHX[playerid] = x;LastPlayerSHY[playerid] = y;LastPlayerSHZ[playerid] = z;
			if (cheat == 1)
            {
                DestroyVehicle(vehicleid); TimeTransform[playerid] = 5; LACPanic[playerid]++;//LAC v2.0
				format(String,sizeof(String), "[АДМИНАМ]LAC:{AFAFAF} Транспорт игрока %s[%d] уничтожен. {FF0000}Причина: {AFAFAF}Возможно SpeedHack",PlayerName[playerid], playerid);
                foreach(Player, cid) if (Player[cid][Admin] != 0 && Logged[cid] == 1) SendClientMessage(cid, COLOR_RED, String);
    			SendClientMessage(playerid, -1,"{FF0000}LAC:{AFAFAF} Ваш транспорт был уничтожен. {FF0000}Причина: {AFAFAF}Возможно чит SpeedHack");
				format(String, 140, "%d.%d.%d в %d:%d:%d |   LAC: Транспорт игрока %s[%d] уничтожен. Причина: Возможно чит SpeedHack", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid);
				WriteLog("GlobalLog", String);WriteLog("LAC", String);
			}
	}//Игрок в машине, залогинен, не в спектре
	return 1;
}//Спидометр. Срабатывает два раза в секунду, если игрок в машине

public OnUnoccupiedVehicleUpdate(vehicleid, playerid, passenger_seat, Float:new_x, Float:new_y, Float:new_z, Float:vel_x, Float:vel_y, Float:vel_z)
{
	//Код ниже блокирует любые попытки сдвинуть с места транспорт без водителя...
	new Float: fDistance = GetVehicleDistanceFromPoint(vehicleid, new_x, new_y, new_z);
	if (fDistance > 3)
	{//если местоположение транспорта рассинхронизировано на 3 метра и более - возвращаем его на место
	    GetVehiclePos(vehicleid, new_x, new_y, new_z);
		SetVehiclePos(vehicleid, new_x, new_y, new_z);
		SetVehicleVelocity(vehicleid, 0, 0, 0);
	}//если местоположение транспорта рассинхронизировано на 3 метра и более - возвращаем его на место
	return 0;
}

stock FailPVP(playerid)
{//игрок проиграл PVP
	new winer = PlayerPVP[playerid][Invite], String[200];
	format(String,sizeof(String),"{FF9E27}PVP: {AFAFAF}%s победил в дуэли против %s.", PlayerName[winer], PlayerName[playerid]);
	foreach(Player, cid) if (Player[cid][ConMesPVP] == 1 || cid == playerid || cid == winer) SendClientMessage(cid,COLOR_RED,String);
	PlayerPVP[playerid][Status] = 0;PlayerPVP[playerid][Invite] = 0;
    PlayerPVP[playerid][PlayMap] = 0;PlayerPVP[playerid][PlayWeapon] = 0;PlayerPVP[playerid][PlayHealth] = 0;
	PlayerPVP[winer][Status] = 0;PlayerPVP[winer][Invite] = 0;
    PlayerPVP[winer][PlayMap] = 0;PlayerPVP[winer][PlayWeapon] = 0;PlayerPVP[winer][PlayHealth] = 0;
    SetPlayerVirtualWorld(playerid,0);SetPlayerVirtualWorld(winer,0);
    SavePlayer(playerid);LSpawnPlayer(playerid);SavePlayer(winer);LSpawnPlayer(winer);
	JoinEvent[playerid] = 0; JoinEvent[winer] = 0;
    QuestUpdate(playerid, 22, 1);//Обновление квеста Примите участие в 5 PvP
    QuestUpdate(winer, 22, 1);//Обновление квеста Примите участие в 5 PvP
    QuestUpdate(winer, 23, 1);//Обновление квеста Выиграйте 3 PvP
	return 1;
}//игрок проиграл PVP

stock IsPlayerInPayNSpray(playerid)
{//проверка на то, что игрок в покрасочном гараже Pay N Spray
    if (IsPlayerInRangeOfPoint(playerid,7,2064.5986,-1831.6934,13.5469)) return 1; //LS 1
	if (IsPlayerInRangeOfPoint(playerid,7,1024.8928,-1024.6052,32.1016)) return 1; //LS 2
	if (IsPlayerInRangeOfPoint(playerid,7,487.3758,-1741.0320,11.1321)) return 1; //LS 3
	if (IsPlayerInRangeOfPoint(playerid,7,-1904.6287,285.5661,41.0469)) return 1; //SF 1
	if (IsPlayerInRangeOfPoint(playerid,7,-2425.6978,1020.8086,50.3977)) return 1; //SF 2
	if (IsPlayerInRangeOfPoint(playerid,7,1976.5468,2162.4783,11.0703)) return 1; //LV
	if (IsPlayerInRangeOfPoint(playerid,7,720.0233,-456.4514,16.3359)) return 1; //Dillimor
	if (IsPlayerInRangeOfPoint(playerid,7,-99.9693,1118.9204,19.7417)) return 1; //Fort Carson
	if (IsPlayerInRangeOfPoint(playerid,7,-1420.1829,2583.6006,55.8433)) return 1; //El Cebrados
	return 0;
}//проверка на то, что игрок в покрасочном гараже Pay N Spray

stock GetPlayerTuneStatus(playerid)
{//проверка на то, что игрок в тюнинг гараже
    if(GetPlayerInterior(playerid) != 0)
    {//Игрок в интерьере (может быть в тюнинге)
	    if (IsPlayerInRangeOfPoint(playerid,5,617.5347,-1.9909,1000.5783)) return 1; //в тюнинге Transfender
	    if (IsPlayerInRangeOfPoint(playerid,5,616.7845,-74.8150,997.8722)) return 2; //в тюнинге Lowrider
	    if (IsPlayerInRangeOfPoint(playerid,5,615.2812,-124.2390,997.6196)) return 3; //в тюнинге Arch Angels
    }//Игрок в интерьере (может быть в тюнинге)
    else
    {//игрок не в интерьере (может быть на въезде или выезде из тюнинга
	    if (IsPlayerInRangeOfPoint(playerid,15,1041.5431,-1016.8201,32.1075)) return -1; //на въезде в Transfender в LS
	    if (IsPlayerInRangeOfPoint(playerid,15,-1936.0847,245.9636,34.4609)) return -2; //на въезде в Transfender в SF
	    if (IsPlayerInRangeOfPoint(playerid,15,2386.7300,1051.5768,10.8203)) return -3; //на въезде в Transfender в LV
	    if (IsPlayerInRangeOfPoint(playerid,15,2644.6580,-2044.3076,13.6352)) return -4; //на въезде в Lowrider
	    if (IsPlayerInRangeOfPoint(playerid,15,-2723.5532,217.1511,4.4844)) return -5; //на въезде в Arch Angels
    }//игрок не в интерьере (может быть на въезде или выезде из тюнинга
	return 0;//игрок не в тюниге и не у въезда в тюнинг
}//проверка на то, что игрок в тюнинг гараже

stock ShopUpdate(playerid)
{//Срабатывает при авторизации И в начале каждого часа
	new xhouse = Player[playerid][Home];
	if (xhouse > 0 && Property[xhouse][pBuyBlock] == -1)
	{//Закончилась неперекупайка
	    Property[xhouse][pBuyBlock] = 0; SaveProperty(xhouse);
	    for (new i = 1; i <= 2; i++) SendClientMessage(playerid, COLOR_RED, "Внимание! Закончилось время действия функции 'Неперекупаемый личный дом'");
	}//Закончилась неперекупайка

	if (Player[playerid][GGFromMedalsLastDay] != DateToIntDate(Day, Month, Year))
	{//Новый день - нужно обнулить счетчик GG за медали
	    Player[playerid][GGFromMedalsLastDay] = DateToIntDate(Day, Month, Year);
	    if (Player[playerid][GGFromMedals] == 5)
		{//У игрока был набран дневной лимит
			SendClientMessage(playerid, COLOR_YELLOW, "SERVER: Внимание! Обмен медалей на рубли теперь снова доступен!");
			PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
		}//У игрока был набран дневной лимит
	    Player[playerid][GGFromMedals] = 0;
	}//Новый день - нужно обнулить счетчик GG за медали
	return 1;
}//Срабатывает при авторизации И в начале каждого часа

stock GetEventRestartTime()
{
	new value, EventsAtOneTime; //кол-во соревнований, которое теоритически должно быть доступно на выбор игроку в каждый момент времени
	if (PlayersOnline < 50) EventsAtOneTime = 2; //При онлайне < 50 игроков должны быть доступны 2 соревнования на выбор
	else if (PlayersOnline < 75) EventsAtOneTime = 3; //При онлайне в 50-74 игрока - 3 соревнования
	else if (PlayersOnline < 100) EventsAtOneTime = 4; //При онлайне в 75-99 игроков - 4 соревнования
	else if (PlayersOnline < 125) EventsAtOneTime = 5; //При онлайне в 100-124 игрока - 5 соревнований
	else EventsAtOneTime = 6; //При онлайне в 125-150 игроков - 6 соревнований
	
	value = (6 - EventsAtOneTime) * (240 / EventsAtOneTime);//6 - общее число всех соревнований, 240 - время, среднее время на проведение 1 соревнования
	/*После этих вычислений мы получаем модель, в которой игрок, после окончания соревнования сразу же стартует следующее
	Это никуда не годится. Нужно добавить дополнительные секунды для ожидания следующего соревнования*/
	value += 125; //Теперь после окончания соревнования игрок старует следующее в среднем через 2 минуты
	return value;
}

stock SetXmasTree(Float:x,Float:y,Float:z, Float: zAngle)
{//создание елки в новогоднем режиме
	CreateDynamicObject(19076, x, y, z-1.0, 0, 0, zAngle, -1, -1, -1, 300.0);//елка, подарки ниже
	CreateDynamicObject(19054, x, y+1.0, z-0.4, 0, 0, zAngle, -1, -1, -1, 300.0);//XmasBox1
	CreateDynamicObject(19058, x+1.0, y, z-0.4, 0, 0, zAngle, -1, -1, -1, 300.0);//XmasBox5
	CreateDynamicObject(19056, x, y-1.0, z-0.4, 0, 0, zAngle, -1, -1, -1, 300.0);//XmasBox3
	CreateDynamicObject(19057, x-1.0, y, z-0.4, 0, 0, zAngle, -1, -1, -1, 300.0);//XmasBox4
	CreateDynamicObject(19058, x-1.5, y+1.5, z-1.0, 0, 0, zAngle, -1, -1, -1, 300.0);//XmasBox5
	CreateDynamicObject(19055, x+1.5, y-1.5, z-1.0, 0, 0, zAngle, -1, -1, -1, 300.0);//XmasBox2
	CreateDynamicObject(19057, x+1.5, y+1.5, z-1.0, 0, 0, zAngle, -1, -1, -1, 300.0);//XmasBox4
	CreateDynamicObject(19054, x-1.5, y-1.5, z-1.0, 0, 0, zAngle, -1, -1, -1, 300.0);//XmasBox1
	CreateDynamicObject(3526, x, y, z-1.0, 0, 0, zAngle, -1, -1, -1, 300.0);//Airportlight - объект для эффекта мигания елки
    CreateDynamicMapIcon(x, y, z, 37, 0, -1, -1, -1, 300 ); //Знак вопроса на карте
    Create3DTextLabel("{007FFF}Ёлка\n{FFFFFF}Нажмите [{FFFF00}Alt{FFFFFF}] чтобы получить подарок", COLOR_WHITE, x, y, z, 20, 0);
	return 1;
}//создание елки в новогоднем режиме

stock FindWeapon(playerid, weaponid)
{//функция для поиска оружия с определенным id. Возвращает true, если оружие с этим id есть у игрока
        new
            weapon,
            ammo;

        for (new i = 0; i < 13; i ++)
        {
            GetPlayerWeaponData(playerid, i, weapon, ammo);
            if (weapon == weaponid) return (true);
        }
        return (false);
}//функция для поиска оружия с определенным id. Возвращает true, если оружие с этим id есть у игрока

stock QuestUpdate(playerid, questid, score)
{//обновление задания
	for (new i = 0; i <= 2; i++)
	{//цикл
	    if (Quest[playerid][i] != questid || QuestTime[playerid][i] > 0) continue;//Квест недоступен по времени либо у игрока нет этого квеста
		QuestScore[playerid][i] += score;//Прибавляем нужное кол-во очков
		new bool: QuestCompleted = false;
		switch (questid)
		{//switch
		    case 1: if (QuestScore[playerid][i] >= 40) QuestCompleted = true;
		    case 2: if (QuestScore[playerid][i] >= 5) QuestCompleted = true;
		    case 3: if (QuestScore[playerid][i] >= 15) QuestCompleted = true;
		    case 4: if (QuestScore[playerid][i] >= 15) QuestCompleted = true;
		    case 5: if (QuestScore[playerid][i] >= 5) QuestCompleted = true;
		    case 6: if (QuestScore[playerid][i] >= 50) QuestCompleted = true;
		    case 7: if (QuestScore[playerid][i] >= 10) QuestCompleted = true;
		    case 8: if (QuestScore[playerid][i] >= 10) QuestCompleted = true;
		    case 9: if (QuestScore[playerid][i] >= 10) QuestCompleted = true;
		    case 10: if (QuestScore[playerid][i] >= 10) QuestCompleted = true;
		    case 11: if (QuestScore[playerid][i] >= 3) QuestCompleted = true;
		    case 12: if (QuestScore[playerid][i] >= 3) QuestCompleted = true;
		    case 13: if (QuestScore[playerid][i] >= 3) QuestCompleted = true;
		    case 14: if (QuestScore[playerid][i] >= 3) QuestCompleted = true;
		    case 15: if (QuestScore[playerid][i] >= 50000) QuestCompleted = true;
		    case 16: if (QuestScore[playerid][i] >= 3) QuestCompleted = true;
		    case 17: if (QuestScore[playerid][i] >= 3) QuestCompleted = true;
		    case 18: if (QuestScore[playerid][i] >= 5) QuestCompleted = true;
		    case 19: if (QuestScore[playerid][i] >= 10000) QuestCompleted = true;
		    case 20: if (QuestScore[playerid][i] >= 2) QuestCompleted = true;
		    case 21: if (QuestScore[playerid][i] >= 5) QuestCompleted = true;
		    case 22: if (QuestScore[playerid][i] >= 5) QuestCompleted = true;
		    case 23: if (QuestScore[playerid][i] >= 3) QuestCompleted = true;
		    case 24: if (QuestScore[playerid][i] >= 20) QuestCompleted = true;
		    case 25: if (QuestScore[playerid][i] >= 60) QuestCompleted = true;
		    case 26: if (QuestScore[playerid][i] >= 3000) QuestCompleted = true;
		    case 27: if (QuestScore[playerid][i] >= 15) QuestCompleted = true;
		    case 28: if (QuestScore[playerid][i] >= 30) QuestCompleted = true;
		    case 29: if (QuestScore[playerid][i] >= 30) QuestCompleted = true;
		    case 30: if (QuestScore[playerid][i] >= 25000) QuestCompleted = true;
		}//switch
		if (QuestCompleted)
		{//Игрок выполнил задание
		    QuestTime[playerid][i] = 3600;//Следующий квест в этом слоте будет доступен через час
		    if (Player[playerid][CasinoBalance] < 100000000 || Player[playerid][Prestige] >= 9) //выбор нового квеста при доступном казино
		    	while(questid == Quest[playerid][0] || questid == Quest[playerid][1] || questid == Quest[playerid][2]) questid = random(30) + 1; //Выбираем новый квест
			else //выбор нового квеста при недоступном казино
			    while(questid == Quest[playerid][0] || questid == Quest[playerid][1] || questid == Quest[playerid][2] || questid == 24) questid = random(30) + 1; //Выбираем новый квест
		    QuestScore[playerid][i] = 0; Quest[playerid][i] = questid; //Назначаем новый квест
   		    SendClientMessage(playerid, COLOR_QUEST, "QUEST: Вы получили 350 XP, 50 000$ и медаль за успешное выполнение задания!");
		    Player[playerid][Medals]++; Player[playerid][CompletedQuests]++;
		    Player[playerid][Cash] += 50000; LGiveXP(playerid, 350);
		    PlayerPlaySound(playerid,1083,0.0,0.0,0.0);//Звук выигрыша
		}//Игрок выполнил задание
		
	}//цикл
	return 1;
}//обновление задания

public SobeitCamCheck(playerid)
{
	new Float:x, Float:y, Float:z; GetPlayerCameraFrontVector(playerid, x, y, z);
	if(z < -0.8)
	{//обнаружен Sobeit (UnFreeze баг)
        new String[140];
		format(String,sizeof(String), "[АДМИНАМ]LAC: {AFAFAF}%s[%d] был автоматически кикнут. {FF0000}Причина: {AFAFAF}Обнаружен чит Sobeit",PlayerName[playerid], playerid);
        foreach(Player, cid) if (Player[cid][Admin] != 0 && Logged[cid] == 1) SendClientMessage(cid, COLOR_RED, String);
		format(String, 140, "%d.%d.%d в %d:%d:%d |   LAC: %s[%d] был автоматически кикнут. Причина: Обнаружен чит Sobeit", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid);
		WriteLog("GlobalLog", String);WriteLog("LACSobeit", String);
		SendClientMessage(playerid, COLOR_RED, "LAC: {AFAFAF}Обнаружен чит {FF0000}Sobeit{AFAFAF}! Удалите его и перезайдите в игру!");
		TogglePlayerControllable(playerid, 1); SetCameraBehindPlayer(playerid);
		CancelSelectTextDraw(playerid); return GKick(playerid);
	}//обнаружен Sobeit (UnFreeze баг)
	else
	{//Sobeit не обнаружен
	   	TogglePlayerControllable(playerid, 1); CancelSelectTextDraw(playerid);
		FirstSobeitCheck[playerid] = 3;//Проверка на собейт завершена
	   	SendClientMessage(playerid, COLOR_RED, "LAC: {AFAFAF}Проверка успешно завершена! Приятной игры!");
		TextDrawHideForPlayer(playerid, BlackScreen);//убираем черный экран
		return LSpawnPlayer(playerid);
	}//Sobeit не обнаружен
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
    if(FirstSobeitCheck[playerid] == 2 && clickedid != BlackScreen) return Kick(playerid);//Игрок нажал Esc при проверке на Sobeit
	return 1;
}

public DestroyCashPickup(pickupid)
{//уничтожение пикапа, который которого никто не успел подобрать
	DynamicPickup[pickupid][Type] = -1;//тип пикапа - деньги
	DynamicPickup[pickupid][ID] = -1;//сумма денег
	DynamicPickup[pickupid][DestroyTimerID] = -1;
	DestroyDynamicPickup(pickupid);
	return 1;
}//уничтожение пикапа, который которого никто не успел подобрать


	
