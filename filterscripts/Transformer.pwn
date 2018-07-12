//TransformeR GameMode made by Lomt1k

/*-------------------------------
�� ���������� 2,5 ��� � ������������ ���� ������� ���.
��� ����������������� ��������� �� ������� �������.
���� ��� ��� ������� ������� ���� �����.

�� 2,5 ���� �� ����������� � �����������
� �������� �������� ������������. �������
�������� ���� ����� ������ �����������
� ������ ������. ��� ����� ������ ������
��� ���� ��������������.

��� ��������� �������� � ������� � ����.
���� ������������ ��������� ������� ��������
���� mSelection, lookup � mxINI.

����� ������������ ������� sscanf2 � streamer.
�� ������ ���������� �� ����� �������� �������,
���� �� ������ ������ ������ ����.
��� ���� �������� ��� �������� �� �����.

������ ��� � ����� �����. ���������.
����� ����� � ����� ���������� :)

			Lomt1k, Jule 03, 2015
-------------------------------*/

#include <a_samp>
#include <mxINI>
#include <Dini>
#include <sscanf2>
#include <streamer>
#include <foreach> //����� ��� �������
#include <mSelection> //0.3� ����
#include <GetVehicleColor> //������� GetVehicleColor(vehicleid, &color1, &color2);
#include <LDate>//������� ��� ������ � �����
#include <cp> //����� ������� ��� ������ � �����������

#include "lookup"//����������� ������ � ������ �� IP
/*  GetPlayerHost(playerid)
	GetPlayerISP(playerid)
	GetPlayerCountryCode(playerid)
	GetPlayerCountryName(playerid)
	GetPlayerCountryRegion(playerid)
	IsProxyUser(playerid) // Returns true if a proxy is detected

	public OnLookupComplete(playerid) ����������� ��� ������ ������������ �������������� (����� ����� ��������) */

#pragma tabsize 0//����� �� ���� ��������� loose indentation

new MenuMyskin = mS_INVALID_LISTID;//��� ���� myskin
new MenuFirstCar = mS_INVALID_LISTID;//��� ���� ������ ������� ����
new MenuClass1 = mS_INVALID_LISTID;//��� ���� ������ avto Class1
new MenuClass2 = mS_INVALID_LISTID;//��� ���� ������ avto Class2
new MenuClass3 = mS_INVALID_LISTID;//��� ���� ������ avto Class3
new MenuBuyGun = mS_INVALID_LISTID;//��� ���� ����. ��������
new MenuPaintJob = mS_INVALID_LISTID;//��� ���� ������ avto � PaintJob
new MenuPrestigeCars = mS_INVALID_LISTID;//��� ���� ������ ���� (�������)

#undef MAX_PLAYERS
#define MAX_PLAYERS 150
new MaxVehicleUsed = 0;//������������ �������� � ������������ ������������ ID ���� (��� ������)
new MaxPlayerID = 0;//������������ �� ������ �� �������. ������������ �������� ��� ���������� ������ �����

#define MAX_PROPERTY 501 //�������� �����. ����������� �� 1 ������
#define MAX_BASE 101 //�������� ������. ����������� �� 1 ������
#define MAX_CLAN 501 //�������� ������. ����������� �� 1 ������
new MaxClanID = 0;//����� ���� ����� 15 ������, �� �� ������ ���� �� 10 000, � ������ �� 15

#define SERVER_NAME "TransformeR DM" //�������� �������, ������������ ��� �����������.
#define GAMEMODE_NAME "TransformeR DM" //�������� ����, ������������ � ���� SAMP
#define MAX_PING 250 //����������� ���������� ����

//#define MAX_ACTORS 5 //�������� NPC-�������
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

//��������� ����� �������: if (HOLDING( KEY_FIRE ))
//��������� ���������� ������: if (HOLDING( KEY_FIRE | KEY_CROUCH ))
#define HOLDING(%0) \
	((newkeys & (%0)) == (%0))
//������� ����� �������: if (PRESSED( KEY_FIRE ))
//������� ���������� ������: if (PRESSED( KEY_FIRE | KEY_CROUCH ))
#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
//���������� ����� �������: if (RELEASED( KEY_FIRE ))
//���������� ���������� ������: if (RELEASED( KEY_FIRE | KEY_CROUCH ))
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
new Float: LastPlayerX[MAX_PLAYERS], Float: LastPlayerY[MAX_PLAYERS], Float: LastPlayerZ[MAX_PLAYERS];//�������������� ������ ������� �����
new LastPlayerTuneStatus[MAX_PLAYERS], TunesPerSecond[MAX_PLAYERS];//��� �������� �� �������� ��� ������ ������ �� �������
new Float: LastPlayerSHX[MAX_PLAYERS], Float: LastPlayerSHY[MAX_PLAYERS], Float: LastPlayerSHZ[MAX_PLAYERS];//�������������� ������ ��� ������� ����� ��� ����������

new LastProperty = 1, OwnedProperty = 0, SuperProperty = 0;
new LastBase = 1, OwnedBase = 0;
new RestartDate[32];
new Year, Month, Day, hour,minute,second; //������� ���� � �����
new pKick[MAX_PLAYERS] = 0;

new Text3D:PropertyText3D[MAX_PROPERTY];
new Text3D:BaseText3D[MAX_BASE];

new PlayerPass[MAX_PLAYERS][30];//������ ������
new BannedBy[MAX_PLAYERS][25], BanReason[MAX_PLAYERS][41], MutedBy[MAX_PLAYERS][25];
new InviteClan[MAX_PLAYERS], InviteTime[MAX_PLAYERS] = -1;
new UGTime = 300;
new ServerWeather, PlayerWeather[MAX_PLAYERS] = -1, PlayerTime[MAX_PLAYERS] = -1;
new InPeacefulZone[MAX_PLAYERS];//��� ������ ���
new GPSUsed[MAX_PLAYERS];//����������� �� �������� � ������ �������� � ������� GPS
new ChatName[MAX_PLAYERS][100];//��� ��� ����
new FirstSobeitCheck[MAX_PLAYERS], FirstSobeitCheckTimer[MAX_PLAYERS], Text:BlackScreen;//��������� �������� �� ������ ����� �������

new WorkPizzaID[MAX_PLAYERS], WorkPizzaCP[MAX_PLAYERS], WorkPizzaCPs[MAX_PLAYERS];//������ ���������� �����: ID ��������, ����� ��������� � �� ����������
new WorkTime[MAX_PLAYERS];//�����, � ������� �������� ��� ����������� 1 ����� �� ������
new WorkTimeGruz[MAX_PLAYERS], WorkZoneCombine;
new IsServerRestaring = 0;

//����������
new Text:TextDrawEvent[MAX_PLAYERS];//����� �� ������ ������������
new Text:LevelupTD[MAX_PLAYERS];//  LEVEL
new Text:SkinChangeTextDraw;
new Text:SkinIDTD[MAX_PLAYERS];
new Text:SpecInfo[MAX_PLAYERS], Text:SpecInfoVeh[MAX_PLAYERS];
new Text:TextDrawSpeedo[MAX_PLAYERS];
new LevelUp[MAX_PLAYERS] = -1; //���������� ��� �������� ����������
new Text:TextDrawTime, Text:TextDrawDate; //����� � ����
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
new GMTestStage[MAX_PLAYERS] = 0, GMTestTime[MAX_PLAYERS] = 0, Float: GMTestHealthOld[MAX_PLAYERS], Float: GMTestArmourOld[MAX_PLAYERS], GMTesterID[MAX_PLAYERS]; //������� /gmtest
new FloodTime[MAX_PLAYERS], FloodMessages[MAX_PLAYERS];
new OnStartEvent[MAX_PLAYERS];//�����, ����� �������� ���, ����� �� ������ ����� �������� ������ ������
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
new MapTPTime[MAX_PLAYERS], MapTP[MAX_PLAYERS], MapTPTry[MAX_PLAYERS], Float: MapTPx[MAX_PLAYERS], Float: MapTPy[MAX_PLAYERS]; //�������� �� �����
new LastBaseVisited[MAX_PLAYERS], LastHouseVisited[MAX_PLAYERS];
new WeaponShotsLastSecond[MAX_PLAYERS];
new CasinoBet[MAX_PLAYERS]; //������ (�������): bet 0 - 36: �����, 37-38: �������, ������, 41: ������ �����, 42: ������ �����, 43: ������ �����
new Quest[MAX_PLAYERS][3], QuestScore[MAX_PLAYERS][3], QuestTime[MAX_PLAYERS][3];//������
new LastDamageFrom[MAX_PLAYERS] = -1;//�� ������������� ����� ���������� �� ������ ������ ������� ��������� ����
new LoginKickTime[MAX_PLAYERS]; //����� �� ���� (���� ����� �� ������ �������������� �������)
new LeaveDM[MAX_PLAYERS], LeaveGG[MAX_PLAYERS];

new PlayersOnline = 0;//������������ ��� ����������� ������� ���������� ������������
new MaxBank[MAX_PLAYERS];//�������� ����� � �����

new DMTimer = 150;
new DMTimeToEnd = -1;
new DMid = 8; //������ �� ����� ��������: Minigun Madness
new PrevDM = 8;
new DMPlayers = 0;
new DMKills[MAX_PLAYERS], DMLeaderID, DMLeaderKills;

new DerbyTimer = 180;
new DerbyTimeToEnd = -1;
new DerbyPlayers = 0;
new DerbyPlayersList[25];//������ � ID �������, ������� ��������� � �����
new Derbyid = 2; //������ ����� ����� ��������: Great Random
new PrevDerby = 2;
new DerbyModelCar[MAX_PLAYERS];
new DerbyCarID[MAX_PLAYERS];
new DerbyStarted[MAX_PLAYERS];
new DerbyPosition;
new Float:dchealth = 0.0;
new DerbyModelAll;


new ZMTimer = 390;
new ZMPlayers = 0, ZMHumans = 0, ZMZombies = 0;
new ZMPlayersList[25];//������ � ID �������, ������� ��������� � �����
new ZMid = 11, ZMTimeToEnd = -1; //������ ����� ����� ��������: ������ �����
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
new FRPlayersList[25];//������ � ID �������, ������� ��������� � �����
new FRStart = 4, FRFinish = 5, FRTimeToEnd = -1; //������ ����� ����� ��������: �� ���� �� �� ����
new PrevFRStart = 4, PrevFRFinish = 5;//���������� ����� � �����
new FRStarted[MAX_PLAYERS];
new FRModelCar = 411, FRCarID[MAX_PLAYERS];//������ ����� ����� �������� �� Infernus
new FRpos;
new FRTimeTransform = -1;


new XRTimer = 660;
new XRid = 11; //������ ����������� ����� ����� ��������: Into The Wild
new PrevXRid = 11;
new XRPlayers = 0;
new XRPlayersList[25];//������ � ID �������, ������� ��������� � ����������� �����
new XRTimeToEnd = -1;
new XRpos;
new XRStarted[MAX_PLAYERS];
new XRCPs = -1;//���������� ����������
new XRPlayerCP[MAX_PLAYERS] = -1;
new XRCarCP[100];//����� ����� ������ ���� ������� ���������. �������� �����: 100!
new XRTypeCP[100];//����� ��� ��������� (�������, �����, ���������...) ��������: 100!
new XRCarID[MAX_PLAYERS] = -1;
new XRPlayerCar[MAX_PLAYERS];//������ ������ ������� ������ ������, ����� � ����� ���� ������������
new Float: XRxx[MAX_PLAYERS], Float: XRy[MAX_PLAYERS], Float: XRz[MAX_PLAYERS], Float: XRa[MAX_PLAYERS], Float: XRvx[MAX_PLAYERS], Float: XRvy[MAX_PLAYERS], Float: XRvz[MAX_PLAYERS];


new GGTimer = 690;
new GGTimeToEnd = -1;
new GGid = 10; //������ ����� ���������� ����� ��������: ���������� ����
new PrevGGid = 10;
new GGPlayers = 0;
new GGKills[MAX_PLAYERS] = 0;


//������ (�������� ����������)
new DMLimit = 25;//�� ������ 1.07 ���� 30
new DerbyLimit = 25;
new ZMLimit = 25;//�� ������ 1.07 ���� 30
new FRLimit = 25;
new XRLimit = 25;
new GGLimit = 25;//�� ������ 1.07 ���� 30

new TutorialStep[MAX_PLAYERS] = 999;
new NeedXP[MAX_PLAYERS] = 9999999;
new SaveTime = 30;

new LACPanic[MAX_PLAYERS], LACPanicTime[MAX_PLAYERS]; //LAC v2.0
new Float: KarmaX[MAX_PLAYERS], Float: KarmaY[MAX_PLAYERS], Float: KarmaZ[MAX_PLAYERS];

new Weapons[MAX_PLAYERS][47];//LAC �� ������
new PlayerIP[MAX_PLAYERS][16];//IP �������
new PlayerName[MAX_PLAYERS][25];//��� ������

//������� �������
new TutorialObject[MAX_PLAYERS] = -1;

//������� �����
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
	Slot1, // ������
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

	//����������, ������� �� ����������� � ����
	CarActive,
	//��, ��� ������� �������������� ��������, ����� � ���������� �����
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
	Status, //0 - �� � PVP, 1 - � pvp
	Invite, //�� ������, � ������� pvp. �� �������: -1
	Map, //����� ����� pvp.
	Weapon,//id ������
	Health,//���-�� ��������. �� 1 �� 200.
	PlayMap,//�����, �� ������� � ������ ������ ������
	PlayWeapon,//
	PlayHealth,//
	TimeOut,
}
new PlayerPVP[MAX_PLAYERS][PVPInfo];
new CanStartPVP[MAX_PLAYERS];

enum VehicleInfo
{
	AntiDestroyTime, //���-�� ������, � ������� ������� ��������� �� ����� ���� ���������
	Owner, //id ������, �������� ����������� ���������
	Float: Health, //�������� ����������
}
new Vehicle[MAX_VEHICLES][VehicleInfo];
forward SecVehicleUpdate(vehicleid);

#define MAX_DYNAMIC_PICKUPS 1000
enum DynamicPickupInfo
{//���� ������������ �������
	Type, //1 - ���, 2 - ����, 3 - ������ ������
	ID, //ID ����, ID �����, ����� �����
	DestroyTimerID, //ID ������� ��� �������� ������ (�� ������������ � ����� � ������)
}//���� ������������ �������
new DynamicPickup[MAX_DYNAMIC_PICKUPS][DynamicPickupInfo];

//��������������� ������
new RegisterDate[MAX_PLAYERS][16];
new RegisterIP[MAX_PLAYERS][16];
new RegisterISP[MAX_PLAYERS][40];
new RegisterHost[MAX_PLAYERS][40];
new RegisterLocation[MAX_PLAYERS][40];

new NOPSetPlayerHealth[MAX_PLAYERS];
new NOPSetPlayerArmour[MAX_PLAYERS];
new NOPSetPlayerHealthAndArmourOff[MAX_PLAYERS];

//------- LAC �� ������
new LACWeaponOff[MAX_PLAYERS];
stock ResetWeapons(playerid)
{
    for(new i=0;i<47;i++) Weapons[playerid][i] = 0;
	LACWeaponOff[playerid] = 3;
	return ResetPlayerWeapons(playerid);
}
#define ResetPlayerWeapons ResetWeapons //LAC �� ������

stock GiveWeapon(playerid,weapid,ammo)
{
	if (ammo > 0) Weapons[playerid][weapid]= 1;
	GivePlayerWeapon(playerid,weapid,ammo);
	return ;
}
#define GivePlayerWeapon GiveWeapon //LAC �� ������

//------- LAC �� ��������
new LACTeleportOff[MAX_PLAYERS], TimeWithZeroSpeed[MAX_PLAYERS];
stock SetPos(playerid, Float:x, Float:y, Float:z)
{
	LastPlayerX[playerid] = x; LastPlayerY[playerid] = y; LastPlayerZ[playerid] = z;
	LACTeleportOff[playerid] = 3;
	if (IsPlayerInAnyVehicle(playerid)) DestroyVehicle(GetPlayerVehicleID(playerid));//���������� ���, �����, ������� � ����, �� ������������ � �������� ��������� �� ��
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
	if (seatid == 0) Vehicle[vehicleid][Owner] = playerid;//����������� ������ �� ��������� ����
	return 1;
}
#define PutPlayerInVehicle PutInVehicle
//------- LAC �� ��������

stock LDestroyVehicle(vehicleid)
{
	//����������� �����
	if (NeonObject1[vehicleid] != -1){DestroyDynamicObject(NeonObject1[vehicleid]);NeonObject1[vehicleid] = -1;}
	if (NeonObject2[vehicleid] != -1){DestroyDynamicObject(NeonObject2[vehicleid]);NeonObject2[vehicleid] = -1;}
	if (TrailerID[vehicleid] > -1) LDestroyVehicle(TrailerID[vehicleid]);//���� � ���� ���� ������� - ���������� ���
	TrailerID[vehicleid] = -1; IsTrailer[vehicleid] = 0;
	if (Vehicle[vehicleid][Owner] > -1)
	{
	    new ownerid = Vehicle[vehicleid][Owner];
		if (IsPlayerInVehicle(ownerid, vehicleid)) RemovePlayerFromVehicle(ownerid);
		PlayerCarID[ownerid] = -1;
		Vehicle[vehicleid][Owner] = -1;
	} //����������� ����
	return DestroyVehicle(vehicleid);
}
#define DestroyVehicle LDestroyVehicle

//LAC �� ���������������� �������� � �����
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
//LAC �� ���������������� �������� � �����

//LAC �� ������ ����������
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
//LAC �� ������ ����������

//����-�������� ������� ��������� ��� �������� ������. �������� ����� ��������� � ��������� � 100�� ����� �� ���� ���� � �������� ����
stock SetCheckpoint(playerid, Float:x, Float:y, Float:z, Float:size)
{
    DisablePlayerCheckpoint(playerid); DisablePlayerRaceCheckpoint(playerid); GPSUsed[playerid] = 0;
    return SetTimerEx("LSetPlayerCheckpoint" , 100, false, "iffff", playerid, x, y, z, size);
}
forward LSetPlayerCheckpoint(playerid, Float:x, Float:y, Float:z, Float:size);
public LSetPlayerCheckpoint(playerid, Float:x, Float:y, Float:z, Float:size) return SetPlayerCheckpoint(playerid, Float:x, Float:y, Float:z, Float:size);
#define SetPlayerCheckpoint SetCheckpoint
//� ������ ���� ����� ��� �������� ����������
stock SetRaceCheckpoint(playerid, type, Float:x, Float:y, Float:z, Float:nextx, Float:nexty, Float:nextz, Float:size)
{
    DisablePlayerCheckpoint(playerid); DisablePlayerRaceCheckpoint(playerid); GPSUsed[playerid] = 0;
	return SetTimerEx("LSetPlayerRaceCheckpoint" , 100, false, "iifffffff", playerid, type, x, y, z, nextx, nexty, nextz, size);
}
forward LSetPlayerRaceCheckpoint(playerid, type, Float:x, Float:y, Float:z, Float:nextx, Float:nexty, Float:nextz, Float:size);
public LSetPlayerRaceCheckpoint(playerid, type, Float:x, Float:y, Float:z, Float:nextx, Float:nexty, Float:nextz, Float:size) return SetPlayerRaceCheckpoint(playerid, type, x, y, z, nextx, nexty, nextz, size);
#define SetPlayerRaceCheckpoint SetRaceCheckpoint
//����-�������� ������� ��������� ��� �������� ������. �������� ����� ��������� � ��������� � 100�� ����� �� ���� ���� � �������� ����

//////////////------------- ������� GetWeaponName
new WeaponName[47][] = {// http://wiki.sa-mp.com/wiki/Weapons_RU
"���",
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
    else return weapon[0] = 0, strcat(weapon, "{FF0000}����������� ������", len), true;
}
#define GetWeaponName GetWeaponNameEx
//////////////------------- ������� GetWeaponName


new CheatFlySec[MAX_PLAYERS] = 0, LACFlyOff[MAX_PLAYERS] = 0;//LAC �� FlyHack
new LACPedSHOff[MAX_PLAYERS] = 0, LACPedSHTime[MAX_PLAYERS] = 0;//LAC �� SpeedHack (������)

new ClanTextShowed[MAX_PLAYERS] = 0;

new TimeTransform[MAX_PLAYERS], Float:carhealth = 0.0;//�������� �������������

#include "Transformer\PLAYERSpawns"
#include "Transformer\EVENTSpawns"
#include "Transformer\WeaponsData" //���� �� ������
#include "Transformer\Levels" //XP, ����������� ��� ������
#include "Transformer\LevelUp" //������� ��������� ������
new DMName[][] =
{
"0id",
"��������� �������",
"���� 69",
"Sniper Elite",
"��������",
"���� 69 (������)",
"Emerald Isle",
"Sniper Assault",
"Minigun Madness",
"���������",
"RocketMania",
"�����",
"UnderWater",
"Dead Air",
"��������",
"���� � �������",
"�������",
"�������",
"�����",
"���������",
"��� ������������"
};

new DerbyName[][] =
{
"0id",
"������� �����",
"Great Random",
"�������� ����������",
"�������������� �����",
"�� �����",
"��� ��������",
"�����������",
"���� �����",
"World Of Tanks"
};

new ZMName[][] =
{
"0id",
"������� ��������",
"���� ������",
"Angel Pine",
"���� (��� ������)",
"���� 69",
"��������� �����",
"��������",
"Grove Street",
"������",
"����� - �������",
"������ �����",
"�������",
"������",
"����������",
"��� �����"
};

new FRName[][] =
{
"0id",
"����������� �������� (������)",
"����������� �������� (�����)",
"������� ��������",
"�������� ��� ������ (�������� ������)",
"���� �������",
"���������� (��� ������)",
"���� ������ (��� ������)",
"������",
"Groove Street (��� ������)",
"������� (��� ������)",
"���� (��� ������)",
"���� (��� ������)",
"�������� ��� ������ (�������� ������)",
"����������� ������� (��� ������)",
"������ ��������",
"����������� ���� (��� ��������)",
"����� Rock (��� ��������)",
"���������� (����� ��������)",
"����� ��������",
"��������� (��� ������)",
"����������� ����� (��� ������)",
"������� ���� (��� ������)",
"������ (��� ������)",
"���������� ������� (��� ��������)",
"�/� ������ (��� ��������)",
"������� ���� (��� ��������)",
"���� 69",
"������� (��� ��������)",
"������ �������",
"������� (��� ������)",
"������������ (��� ������)",
"���������� ����� (��� ������)",
"������ ����� (��� ������)",
"�������� ��� ������",
"Angel Pine",
"������� (��� ������)",
"����� ��� ������",
"������� (��� ������)",
"�������� ��� �������� (�������� ������)",
"����� �������"
//����� �������� "�������� ��� ������" � "�������� ��� ��������" (�� �������� ������)
};

new GGName[][] =
{
"0id",
"Golf Club",
"���� 69",
"Four Dragons",
"��������",
"���� 69 (������)",
"Emerald Isle",
"��������",
"�������",
"����������� �����",
"���������� ����",
"�����",
"UnderWater",
"Dead Air",
"�����",
"��������� �����",
"�������",
"�������",
"�����",
"���������",
"��� ������������"
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
"���������",
"San Fierro Drift",
"Mountain",
"�� ��� ��������",
"Dirt And Dust",
"Los Santos Highway",
"Fast And Furious"
};

//----- �����
#include "Transformer\Packages"
new CasePickup[23], CaseMapIcon[23];
new case1, case2, case3, case4, case5, case6, case7, case8, case9, case10;
new case11, case12, case13, case14, case15, case16, case17, case18, case19, case20;
new casemodel = 1210;//������ �����

//---- ���� ����
#include "Transformer\CarStealSpawn"
new StealCar[36], StealCarMapIcon[36], cscol1, cscol2, csmodel;
new csrand1, csrand2, csrand3, csrand4, csrand5, csrand6, csrand7, csrand8, csrand9, csrand10;
new csrand11, csrand12, csrand13, csrand14, csrand15, csrand16, csrand17, csrand18, csrand19, csrand20;
new csrand21, csrand22, csrand23, csrand24, csrand25, csrand26, csrand27, csrand28, csrand29, csrand30;
new csrand31, csrand32, csrand33, csrand34, csrand35;
new StealCarTimer[MAX_VEHICLES], StealCarModel[MAX_PLAYERS];

new QuestCar[MAX_PLAYERS] = -1, QuestActive[MAX_PLAYERS] = 0;
new AirportID[MAX_PLAYERS], AirportTime[MAX_PLAYERS];//���������

//��� ������ ����� ����� � �������� (�����)
new Float: InteriorEnterX[MAX_PLAYERS], Float: InteriorEnterY[MAX_PLAYERS], Float: InteriorEnterZ[MAX_PLAYERS],Float: InteriorEnterA[MAX_PLAYERS];

//spec
new LSpecID[MAX_PLAYERS] = -1, LSpecMode[MAX_PLAYERS] = SPECTATE_MODE_NORMAL, LSpecCanFastChange[MAX_PLAYERS] = 0;
new LSpectators[MAX_PLAYERS];
//spec

new rampid[MAX_PLAYERS];
new NeedLSpawn[MAX_PLAYERS] = 0;
new PrestigeGM[MAX_PLAYERS] = 0;

new ServerLimitXPDate[80], PlayerLimitXPDate[MAX_PLAYERS][80];//��� ��������� ������ �� ������ ���

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

//���������� �� 100�� ���, ����� ����� ������ ��������� � ����
forward KickTimer(playerid);//��� ����� 100��
stock GKick(playerid){SavePlayer(playerid); return SetTimerEx("KickTimer" , 100, false, "i", playerid);}
public KickTimer(playerid) return Kick(playerid);//��� ����� 100��

forward RemoveRamp(playerid);
forward Float:GetOptimumRampDistance(playerid);
forward Float:GetXYInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance);

#include <fly> //����� �����-���� (������� 2)
#include <vehfly> //����� �� ���� (������� 4)








// --------------- ����� � �������� ---------------------------------
#define MAX_AFK_TIME 3600    // ����������� ����� AFK �� ����
#define FIRST_CHECK 2400    // ������ ��������������
#define SECOND_CHECK 3000    // ������ ��������������
#define AFK_TEXT_SET 20    // ����� �� ��������� ������� AFK ��� �������

// --------------- ����� --------------------------------------------
#define T_COLOR 0xFF000080    // ���� 3� ������
#define M1_COLOR 0xFF0000FF // ���� ������ ������� ��������������
#define M2_COLOR 0xFF0000FF // ���� ������ ������� ��������������
#define MK_COLOR 0xFF0000FF // ���� ������ ���������� � ����

// --------------- ������ -------------------------------------------
#define T_DIST 20.0 // ���������� � �������� ����� 3� �����

// --------------- ��������� ������ ---------------------------------
enum afk_info {
	AFK_Time,            // ����� AFK
Float:AFK_Coord,    // ��������� ����������
	AFK_Stat            // ������ 3� ������
}

// --------------- ���������� ���������� ----------------------------
new PlayerAFK[MAX_PLAYERS][afk_info];    // ������ AFK �������
new Text3D:AFK_3DT[MAX_PLAYERS]; // 3� ������ ��� �������� �������

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
	strmid(BannedBy[playerid], "�����", 0, strlen("�����"), 5);
	strmid(BanReason[playerid], "�����", 0, strlen("�����"), 5);
	Player[playerid][Muted] = 0;
	strmid(MutedBy[playerid], "�����", 0, strlen("�����"), 5);
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
	Player[playerid][ConMesEnterExit] = 0; //�� ��������� ��������� � �����/������ �� ������ �� ������������
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
	Quest[playerid][2] = 25;//quest: ��������� �� ������� 60 �����.
	QuestScore[playerid][2] = 0;
	QuestTime[playerid][2] = 0;
	Player[playerid][Medals] = 0;
	Player[playerid][CompletedQuests] = 0;
	Player[playerid][GGFromMedals] = 0;
	Player[playerid][GGFromMedalsTotal] = 0;
	Player[playerid][GGFromMedalsLastDay] = DateToIntDate(Day, Month, Year);

	//����������, ������� �� ����������� � ����
	Player[playerid][CarActive] = 0;
	Player[playerid][PHealth] = 100.0;
	Player[playerid][PArmour] = 100.0;
	
	//� �����������
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
	if (Logged[playerid] == 0 || Player[playerid][Level] == 0) return 1; //�������� �� ��������� ��� ���������� ��� � ���������� ��������
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
	{//���� ���� ���������� ����������
		file = ini_openFile(filename);
		ini_getInteger(file, "��������� � Level", ChangePlayer[playerid][Level]);
		ini_getInteger(file, "��������� � Exp", ChangePlayer[playerid][Exp]);
		ini_getInteger(file, "��������� � Bank", ChangePlayer[playerid][Bank]);
		ini_getFloat(file, "��������� � GameGold", ChangePlayer[playerid][GameGold]);
		ini_closeFile(file);
		if (ChangePlayer[playerid][Level] != 0)
		{//��������� ������
		    format(String, sizeof String, "UpdatePlayer: ��� ������� ��� ������� �� {FFFFFF}%d", ChangePlayer[playerid][Level]);
		    SendClientMessage(playerid, COLOR_YELLOW, String); PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
		    format(String, sizeof String, "%d.%d.%d � %d:%d:%d |   UpdatePlayer: ������� ������ %s[%d] ��� ������� �� %d", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid, ChangePlayer[playerid][Level]);
			WriteLog("GlobalLog", String);WriteLog("UpdatePlayer", String);
			Player[playerid][Level] += ChangePlayer[playerid][Level]; ChangePlayer[playerid][Level] = 0;
            SavePlayer(playerid);
		}//��������� ������
		if (ChangePlayer[playerid][Exp] != 0)
		{//��������� ��
		    format(String, sizeof String, "UpdatePlayer: ���������� ������ �� �������� �� {FFFFFF}%d", ChangePlayer[playerid][Exp]);
		    SendClientMessage(playerid, COLOR_YELLOW, String); PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
		    format(String, sizeof String, "%d.%d.%d � %d:%d:%d |   UpdatePlayer: ���������� �� ������ %s[%d] ���� �������� �� %d", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid, ChangePlayer[playerid][Exp]);
			WriteLog("GlobalLog", String);WriteLog("UpdatePlayer", String);
			Player[playerid][Exp] += ChangePlayer[playerid][Exp]; ChangePlayer[playerid][Exp] = 0;
			if (Player[playerid][Exp] >= NeedXP[playerid]) PlayerLevelUp(playerid);
			else SavePlayer(playerid);
		}//��������� ��
		if (ChangePlayer[playerid][Bank] != 0)
		{//��������� ����� � �����
            format(String, sizeof String, "UpdatePlayer: ���������� ����� ����� (� �����) ���� �������� �� {FFFFFF}%d", ChangePlayer[playerid][Bank]);
		    SendClientMessage(playerid, COLOR_YELLOW, String); PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
		    format(String, sizeof String, "%d.%d.%d � %d:%d:%d |   UpdatePlayer: ���������� ����� (� �����) � ������ %s[%d] ���� �������� �� %d", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid, ChangePlayer[playerid][Bank]);
			WriteLog("GlobalLog", String);WriteLog("UpdatePlayer", String);
			Player[playerid][Bank] += ChangePlayer[playerid][Bank]; ChangePlayer[playerid][Bank] = 0;
            SavePlayer(playerid);
		}//��������� ����� � �����
		if (ChangePlayer[playerid][GameGold] != 0)
		{//��������� GG
		    format(String, sizeof String, "UpdatePlayer: ���������� ����� ������ ���� �������� �� {FFFFFF}%0.2f", ChangePlayer[playerid][GameGold]);
		    SendClientMessage(playerid, COLOR_YELLOW, String); PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
		    format(String, sizeof String, "%d.%d.%d � %d:%d:%d |   UpdatePlayer: ���������� ������ ������ %s[%d] ���� �������� �� %0.2f", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid, ChangePlayer[playerid][GameGold]);
			WriteLog("GlobalLog", String);WriteLog("UpdatePlayer", String);WriteLog("Shop", String);
			Player[playerid][GameGold] += ChangePlayer[playerid][GameGold]; if (ChangePlayer[playerid][GameGold] > 0){Player[playerid][GameGoldTotal] += ChangePlayer[playerid][GameGold];} ChangePlayer[playerid][GameGold] = 0;
            SavePlayer(playerid);
		}//��������� GG
		file = ini_openFile(filename);
		ini_setInteger(file, "��������� � Level", ChangePlayer[playerid][Level]);
		ini_setInteger(file, "��������� � Exp", ChangePlayer[playerid][Exp]);
		ini_setInteger(file, "��������� � Bank", ChangePlayer[playerid][Bank]);
		ini_setFloat(file, "��������� � GameGold", ChangePlayer[playerid][GameGold]);
		ini_closeFile(file);
	}//���� ���� ���������� ����������
	else
	{//���� �� ����������
	    file = ini_createFile(filename);
	    if(file < 0) file = ini_openFile (filename);
		if(file >= 0)
		{
			ini_setInteger(file, "��������� � Level", 0);
			ini_setInteger(file, "��������� � Exp", 0);
			ini_setInteger(file, "��������� � Bank", 0);
			ini_setFloat(file, "��������� � GameGold", 0);
			ini_closeFile(file);
		}
	}//���� �� ����������
	
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
		ResetProperty(i);//����� ����� ���� � ������ �������� ��������� ����� ���������� ��� ����� �����.
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
			format(text3d, sizeof(text3d), "{00FF00}��� ({FFFFFF}%d${00FF00})\n{007FFF}��������:{FFFFFF} %s\n������� [{FFFF00}Alt{FFFFFF}] ����� ������������", Property[i][pPrice], Property[i][pOwner]);
			PropertyText3D[i] = CreateDynamic3DTextLabel(text3d, COLOR_WHITE, Property[i][pPosEnterX], Property[i][pPosEnterY], Property[i][pPosEnterZ], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0, -1, 11.0);
		}
		else
		{
			format(text3d, sizeof(text3d), "{00FF00}��� ({FF0000}�� ���������{00FF00})\n{007FFF}��������:{FFFFFF} %s\n������� [{FFFF00}Alt{FFFFFF}] ����� ������������", Property[i][pOwner]);
			PropertyText3D[i] = CreateDynamic3DTextLabel(text3d, COLOR_WHITE, Property[i][pPosEnterX], Property[i][pPosEnterY], Property[i][pPosEnterZ], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0, -1, 11.0);
			SuperProperty++;//���������� - ���-�� �������������� �����
		}
		PropertyPickup[i] = CreateDynamicPickup(1273, 1, Property[i][pPosEnterX], Property[i][pPosEnterY], Property[i][pPosEnterZ], -1, -1, -1, 100.0);
		PropertyMapIcon[i] = CreateDynamicMapIcon(Property[i][pPosEnterX], Property[i][pPosEnterY], Property[i][pPosEnterZ], 31, 0, -1, -1, -1, 100.0);
		new DynamicPickupID = PropertyPickup[i];
		DynamicPickup[DynamicPickupID][Type] = 1;//��� ������ - ���
		DynamicPickup[DynamicPickupID][ID] = i;//id ���� ������
		
		if(strcmp(Property[i][pOwner], "�����")){OwnedProperty++;}//���������� - ��������� �����
		LastProperty++;
	}
	new log[MAX_MESSAGE];

	format(log, sizeof(log), "������� ����� ���������. ����� �����: %i. ������: %i. ��������������: %i.", LastProperty - 1, OwnedProperty, SuperProperty);
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
			if (clanid > 0) format(text3d, sizeof(text3d), "{007FFF}���� ({FFFFFF}%d${007FFF})\n{008E00}����:{FFFFFF} %s\n������� [{FFFF00}Alt{FFFFFF}] ����� ������������", Base[i][bPrice], Clan[clanid][cName]);
			else format(text3d, sizeof(text3d), "{007FFF}���� ({FFFFFF}%d${007FFF})\n{008E00}����:{FFFFFF} �����\n������� [{FFFF00}Alt{FFFFFF}] ����� ������������", Base[i][bPrice]);
			BaseText3D[i] = CreateDynamic3DTextLabel(text3d, COLOR_WHITE, Base[i][bPosEnterX], Base[i][bPosEnterY], Base[i][bPosEnterZ], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0, -1, 11.0);
		}
		else if(Base[i][bPrice] < 0)
		{
			if (clanid > 0) format(text3d, sizeof(text3d), "{007FFF}���� ({AFAFAF}�� ���������{007FFF})\n{008E00}����:{FFFFFF} %s\n������� [{FFFF00}Alt{FFFFFF}] ����� ������������", Clan[clanid][cName]);
            else format(text3d, sizeof(text3d), "{007FFF}���� ({FFFFFF}%d${007FFF})\n{008E00}����:{FFFFFF} �����\n������� [{FFFF00}Alt{FFFFFF}] ����� ������������", Base[i][bPrice]);
			BaseText3D[i] = CreateDynamic3DTextLabel(text3d, COLOR_WHITE, Base[i][bPosEnterX], Base[i][bPosEnterY], Base[i][bPosEnterZ], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0, -1, 11.0);
		}
		BasePickup[i] = CreateDynamicPickup(1272, 1, Base[i][bPosEnterX], Base[i][bPosEnterY], Base[i][bPosEnterZ], -1, -1, -1, 100.0);
		BaseMapIcon[i] = CreateDynamicMapIcon(Base[i][bPosEnterX], Base[i][bPosEnterY], Base[i][bPosEnterZ], 32, 0, -1, -1, -1, 100.0);
        new DynamicPickupID = BasePickup[i];
		DynamicPickup[DynamicPickupID][Type] = 2;//��� ������ - ����
		DynamicPickup[DynamicPickupID][ID] = i;//id ����� ������

		if(Base[i][bClan] > 0) OwnedBase++;
		LastBase++;
	}
	new log[MAX_MESSAGE];

	format(log, sizeof(log), "������� ������ ���������. ����� ������: %d. ������: %d.", LastBase - 1, OwnedBase);
	print(log);
}

stock LoadAllClans()
{
    new filename[MAX_FILE_NAME], file, clans = 0, LastClan = 0;
	for(new i = 1; i < MAX_CLAN; i++)
	{
		format(filename, sizeof(filename), "Clans/%d.ini", i); LastClan++;
		if(!fexist(filename)) {Clan[i][cLevel] = 0; continue;} //�������������� ����
		else
		{//���� ����������
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
		}//���� ����������
	}
	new log[MAX_MESSAGE];

	format(log, sizeof(log), "������� ������ ���������. ����� ������: %d. ��������: %d.", clans, LastClan);
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
{//�������� ������, ������� �� ������ ���� �������
	new xDay = DateToIntDate(Day, Month, Year);
    for(new i = 1; i <= MaxClanID; i++) if (Clan[i][cLevel] > 0)
    {//������������ ����
        if (0 < Clan[i][cLastDay] <= xDay)
        {//���� ����� ����������
        	new StringX[120], filename[MAX_FILE_NAME];
			format(StringX,sizeof(StringX),"���� '{FFFFFF}%s{008E00}' ��� ������������� �������� ��-�� ���������� �����.",Clan[i][cName]); SendClientMessageToAll(COLOR_CLAN,StringX);
			format(filename, sizeof(filename), "Clans/%d.ini", i);
			dini_Remove(filename);//�������� ����� �����
			Clan[i][cLevel] = 0;//����� ���� ��� �����������������
			foreach(Player, cid)
			{//����
				if (Player[cid][Member] != 0 && Player[cid][MyClan] == i)
				{//������
					Player[cid][MyClan] = 0;Player[cid][Member] = 0;Player[cid][Leader] = 0;
					PlayerColor[cid] = 0;SavePlayer(cid);
				}//������
			}//����
			for(new i2 = 0; i2 < MaxClanID; i2++) //������� ID ����� ����� �� ������ ������ � ���� ������ (���� � ���� ����)
					if (Clan[i2][cEnemyClan] == i) {Clan[i2][cEnemyClan] = 0; SaveClan(i2);}
        }//���� ����� ����������
    }//������������ ����
}//�������� ������, ������� �� ������ ���� �������

HousesUpdate()
{//������ ������������� � ��� �����, � ���� ��� ���������
    new xDay = DateToIntDate(Day, Month, Year), text3d[MAX_3DTEXT];
    for(new i = 1; i < MAX_PROPERTY; i++) if (Property[i][pBuyBlock] > 0 && Property[i][pBuyBlock] < xDay)
    {//����� ����� �������������
        Property[i][pBuyBlock] = -1; SaveProperty(i);
        format(text3d, sizeof(text3d), "{00FF00}��� ({FFFFFF}%d${00FF00})\n{007FFF}��������:{FFFFFF} %s\n������� [{FFFF00}Alt{FFFFFF}] ����� ������������", Property[i][pPrice], Property[i][pOwner]);
		UpdateDynamic3DTextLabelText(PropertyText3D[i], 0xFFFFFFFF, text3d);
    }//����� ����� �������������
}//������ ������������� � ��� �����, � ���� ��� ���������

///-------------------------------------- ����� �������








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
{//�������� ����. �������� ����������
	new model = GetVehicleModel(vehicleid) - 400;
	if (model < 0) return 300;//���� ���� �� ���������� - ���������� 300
	else return VehicleMaxSpeed[model];
}//�������� ����. �������� ����������

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

//������� ���������� ����� ������� ����� �� �������� � ����������.
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
    //����������� �����
    if (NeonObject1[vehicleid] != -1){DestroyDynamicObject(NeonObject1[vehicleid]);NeonObject1[vehicleid] = -1;}
	if (NeonObject2[vehicleid] != -1){DestroyDynamicObject(NeonObject2[vehicleid]);NeonObject2[vehicleid] = -1;}
	TrailerID[vehicleid] = -1; IsTrailer[vehicleid] = 0;//������ �� ����� �������� � �� �������� ���������
    StealCarTimer[vehicleid] = 0;//����� ������ ��� ���� ��� ����� (�� 1-35)
    //ResetVehicle
    Vehicle[vehicleid][AntiDestroyTime] = 5;
    Vehicle[vehicleid][Owner] = -1;
    Vehicle[vehicleid][Health] = 1000.0; LACRepair[vehicleid] = 0;
    return vehicleid;
}

stock CallTrailer(vehicleid, trailermodel)
{//����� �������� ��� ����
	new Float:x, Float: y, Float: z, Float:Angle, trailer; GetVehiclePos(vehicleid, x, y, z); GetVehicleZAngle(vehicleid, Angle);
	trailer = LCreateVehicle(trailermodel, x, y, z + 50, Angle, 0, 0, 0);
	TrailerID[vehicleid] = trailer; IsTrailer[trailer] = 1;
	SetTimerEx("TrailerUpdate" , 1000, false, "ii", vehicleid, trailermodel);
	return 1;
}//����� �������� ��� ����

forward TrailerUpdate(vehicleid, trailermodel);
public TrailerUpdate(vehicleid, trailermodel)
{//���������� �������� ������
	if (TrailerID[vehicleid] == -1) return 1;//���� � ������ �� ������ ���� �������� - ����������
	new trailer = TrailerID[vehicleid];
	if (IsTrailer[trailer] == 0) return CallTrailer(vehicleid, trailermodel); //���� �������� �� ���������� - ���������� � ���� ��� ���������
	SetTimerEx("TrailerUpdate" , 1000, false, "ii", vehicleid, trailermodel);
	if (!IsTrailerAttachedToVehicle(vehicleid)) AttachTrailerToVehicle(trailer, vehicleid);
	Vehicle[trailer][AntiDestroyTime] = 5;//����� ������� �� ����������� ���� �� ������� ���������
	return 1;
}//���������� �������� ������

public LSpawnPlayer(playerid)//��� ��� ���
{//����������� � ������ �� ������ �������� ������
    if (IsPlayerInAnyVehicle(playerid)) DestroyVehicle(GetPlayerVehicleID(playerid));//���������� ���, �����, ������� � ����, �� ������������ � �������� ��������� �� ��
	new Float: x, Float: y, Float: z, Float: Angle, w1, w1ammo, w2, w2ammo, w3, w3ammo;
    ResetPlayerWeapons(playerid);
    LACSH[playerid] = 3;LACTeleportOff[playerid] = 4;
	LACWeaponOff[playerid] = 3;
	CheatFlySec[playerid] = 0;
	SetPlayerInterior(playerid,0);SetPlayerVirtualWorld(playerid,0);
	WorldSpawn[playerid] = 0; TogglePlayerSpectating(playerid, 0);
	
	if (Logged[playerid] == 0)
	{//����� �� �����������
		SetSpawnInfo(playerid, 0, Player[playerid][Model], 2351.0242, 2142.0093, 10.6824, Angle, w1, w1ammo, w2, w2ammo, w3, w3ammo);
		SpawnPlayer(playerid); SetPlayerVirtualWorld(playerid, playerid + 1);
	}//����� �� �����������
	
	if (JoinEvent[playerid] == EVENT_DM && DMTimeToEnd > 0)
	{//��-����� �����
		#include "Transformer\DMPlayerSpawn"
		Weapons[playerid][w1] = 1;Weapons[playerid][w2] = 1;Weapons[playerid][w3] = 1;
		SetSpawnInfo(playerid, 0, Player[playerid][Model], x, y, z, Angle, w1, w1ammo, w2, w2ammo, w3, w3ammo);
        if (TimeAfterSpawn[playerid] < 5) TimeAfterSpawn[playerid] = 5;
		return SpawnPlayer(playerid);
	}//��-����� �����

	if (ZMStarted[playerid] == 1)
	{//�����-����� �����
        #include "Transformer\ZombiePlayerSpawn"
        Weapons[playerid][w1] = 1;Weapons[playerid][w2] = 1;Weapons[playerid][w3] = 1;
        SetSpawnInfo(playerid, 0, Player[playerid][Model], x, y, z, Angle, w1, w1ammo, w2, w2ammo, w3, w3ammo);
        if (TimeAfterSpawn[playerid] < 5) TimeAfterSpawn[playerid] = 5;
		return SpawnPlayer(playerid);
	}//�����-����� �����

	if (JoinEvent[playerid] == EVENT_GUNGAME && GGTimeToEnd > 0)
	{//������� �����
		#include "Transformer\GGPlayerSpawn"
		Weapons[playerid][w1] = 1;Weapons[playerid][w2] = 1;Weapons[playerid][w3] = 1;
		SetSpawnInfo(playerid, 0, Player[playerid][Model], x, y, z, Angle, w1, w1ammo, w2, w2ammo, w3, w3ammo);
		if (TimeAfterSpawn[playerid] < 5) TimeAfterSpawn[playerid] = 5;
		return SpawnPlayer(playerid);
	}//������� �����

    TimeAfterSpawn[playerid] = 0; SetPlayerChatBubble(playerid, "������ ��� �������������", COLOR_GREEN, 300.0, 5000);

	if (Player[playerid][Level] == 0)
	{//������ ����� - ����
	    x = 2491.1553; y = -1667.5907; z = 13.0260; Angle = 90;
		SetPlayerInterior(playerid,0);
		SetPlayerVirtualWorld(playerid,playerid+1);//����. ����� � ��������
	}//������ ����� - ����
	
	//------ Spawn � SpawnStyle
    if (Player[playerid][Spawn] == 4 || Player[playerid][Spawn] == 6  || Player[playerid][Spawn] == 7) {if (Player[playerid][Home] == 0) Player[playerid][Spawn] = 0;}
    //�����������, ����� ����� ����� "������ ���", � ���� � ������ ���

	if (Player[playerid][Spawn] == 4)
	{//����� � ����
		new rand = Player[playerid][Home];
		x = Property[rand][pPosRespawnX]; y = Property[rand][pPosRespawnY]; z =Property[rand][pPosRespawnZ]; Angle = Property[rand][pPosRespawnA];
	}//����� � ����
	
	if (Player[playerid][Spawn] == 5)
	{//����� � �����
		new clanid = Player[playerid][MyClan];
		if(Clan[clanid][cBase] < 1 || Clan[clanid][cBase] > MAX_BASE)
		{
		    SendClientMessage(playerid,COLOR_RED,"��������! � ������ ����� ������ ��� �����.");
		    Player[playerid][Spawn] = 0;
		}
		else
		{
			new rand = Clan[clanid][cBase];
			x = Base[rand][bPosRespawnX]; y = Base[rand][bPosRespawnY]; z = Base[rand][bPosRespawnZ]; Angle = Base[rand][bPosRespawnA];
		}
	}//����� � �����

	if (Player[playerid][Spawn] == 6)
	{//����� ������ ����
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
		if (Property[i][pBuyBlock] > 0)//�������������� ���
		{
		    x = 2324.4902; y = -1149.5474; z = 1050.9101; Angle = 0.0; SetPlayerInterior(playerid,12);
		}
		SetPlayerVirtualWorld(playerid, 1000 + i); WorldSpawn[playerid] = 1000 + i;
	}//����� ������ ����

 	if (Player[playerid][Spawn] == 7)
	{//������ �������
		x = Player[playerid][PosX]; y = Player[playerid][PosY]; z = Player[playerid][PosZ];	Angle = Player[playerid][PosA];
		SetPlayerChatBubble(playerid, "������������� (������ �������)", COLOR_YELLOW, 300.0, 5000); WorldSpawn[playerid] = 0;
	}//������ �������
	
	if (Player[playerid][Spawn] == 8)
	{//����� ������ �����
	    new clanid = Player[playerid][MyClan];
		if(Clan[clanid][cBase] < 1 || Clan[clanid][cBase] > MAX_BASE)
		{
		    SendClientMessage(playerid,COLOR_RED,"��������! � ������ ����� ������ ��� �����.");
		    Player[playerid][Spawn] = 0;
		}
		else
		{
			new baseid = Clan[clanid][cBase]; SetPlayerVirtualWorld(playerid, 2000 + baseid); WorldSpawn[playerid] = 2000 + baseid;
			if (Base[baseid][bPrice] < 20000000 && Base[baseid][bPrice] > 0) {x = 772.8347; y = -70.5424; z = 1000.85; Angle = 180.0; SetPlayerInterior(playerid, 7);}//����� ������� ����
			else if (Base[baseid][bPrice] < 40000000 && Base[baseid][bPrice] > 0) {x = 768.0178; y = -36.5910; z = 1000.8651; Angle = 180.0; SetPlayerInterior(playerid, 6);}//���� �� 20-39��
			else if (Base[baseid][bPrice] < 60000000 && Base[baseid][bPrice] > 0) {x = 1725.0011; y = -1649.9758; z = 20.5289; Angle = 0.0; SetPlayerInterior(playerid, 18);}//���� �� 40-59��
			else {x = -2648.3760; y = 1409.8746; z = 906.5734; Angle = 270.0; SetPlayerInterior(playerid, 3);}//���� �� 60+��
		}
	}//����� ������ �����

 	if (Player[playerid][Spawn] == 0)
	{//����������� �����
	    if (Player[playerid][Level] == 0)
		{//����� �� ���� 0 ���
			new rand = random(sizeof(GroveSpawn));
			x = GroveSpawn[rand][0]; y = GroveSpawn[rand][1]; z = GroveSpawn[rand][2]; Angle = GroveSpawn[rand][3];
		}//����� �� ���� 0 ���
		else if (Player[playerid][Level] < 15)
		{//����� � LS 1-14 ���
		    new rand = random(sizeof(LSSPAWN));
			x = LSSPAWN[rand][0]; y = LSSPAWN[rand][1]; z = LSSPAWN[rand][2]; Angle = LSSPAWN[rand][3];
		}//����� � LS 1-14 ���
		else if (Player[playerid][Level] < 25)
		{//����� � SF 15-24 ���
		    new rand = random(sizeof(SFSPAWN));
			x = SFSPAWN[rand][0]; y = SFSPAWN[rand][1]; z = SFSPAWN[rand][2]; Angle = SFSPAWN[rand][3];
		}//����� � SF 15-24 ���
		else if (Player[playerid][Level] < 69)
		{//����� � LV 25-68 ���
			new rand = random(sizeof(LVSPAWN));
			x = LVSPAWN[rand][0]; y = LVSPAWN[rand][1]; z = LVSPAWN[rand][2]; Angle = LVSPAWN[rand][3];
		}//����� � LV 25-68 ���
  		else
		{//����� Chilliad 69+ ���
		    new rand = random(sizeof(ChilliadSpawn));
			x = ChilliadSpawn[rand][0]; y = ChilliadSpawn[rand][1]; z = ChilliadSpawn[rand][2]; Angle = ChilliadSpawn[rand][3];
		}//����� Chilliad 73+ ���
		WorldSpawn[playerid] = 0;
	}//����������� �����
    
	SetSpawnInfo(playerid, 0, Player[playerid][Model], x, y, z, Angle, w1, w1ammo, w2, w2ammo, w3, w3ammo);
	return SpawnPlayer(playerid);
}//����������� � ������ �� ������ �������� ������

stock WriteLog(LogName[], string[])
{//������ � ���. �������� WriteLog("����", "������ ���!"); ������� � ��� "����.ini" ����� "������ ���!"
	new entry[256], LogWay[120], i;
	format(entry,sizeof entry,"\r\n%s",string);format(LogWay,sizeof LogWay, "Logs/%s.log",LogName);
	new File: hfile = fopen(LogWay, io_append);	
	while (entry[i] != EOS) {fputchar(hfile,entry[i],false); i++;}
	fclose(hfile);
}//������ � ���. �������� WriteLog("����", "������ ���!"); ������� � ��� "����.ini" ����� "������ ���!"

stock LoadPlayerClan(playerid)
{//�������� ����� ������ ��� ������
    if (Player[playerid][MyClan] != 0 && ClanTextShowed[playerid] == 0)
	{//�������� �����
	    new clanid = Player[playerid][MyClan], bool: PlayerInClan = false; ClanTextShowed[playerid] = 1;
		if(Clan[clanid][cLevel] == 0)
		{//���� ��� ������
			SendClientMessage(playerid,COLOR_RED,"��� ��������� �� ����� ��� �� ��� ������.");
			Player[playerid][Member] = 0; Player[playerid][Leader] = 0; Player[playerid][MyClan] = 0;
			if (Player[playerid][Spawn] == 5) Player[playerid][Spawn] = 0;
			SavePlayer(playerid); return 1;
		}//���� ��� ������
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
		{//������ ��������� �� �����
			SendClientMessage(playerid,COLOR_RED,"��� ��������� �� ����� ��� �� ��� ������.");
			Player[playerid][Member] = 0; Player[playerid][Leader] = 0; Player[playerid][MyClan] = 0;
			if (Player[playerid][Spawn] == 5) Player[playerid][Spawn] = 0;
			SavePlayer(playerid); return 1;
		}//������ ��������� �� �����
		PlayerColor[playerid] = Clan[clanid][cColor];//��������� ����� �����
		
	    new cOnline = 0, cMes[140], ccolor = Clan[clanid][cColor];
		if(strcmp(Clan[clanid][cMessage], "�����", true))
		{//���� ��������� � ����� ����
		    format(cMes,sizeof(cMes),"��������� �����: {FFFFFF}%s",Clan[clanid][cMessage]);
			SendClientMessage(playerid,ClanColor[ccolor],cMes);
		}//���� ��������� � ����� ����
		format(cMes, sizeof cMes, "���������� %s[%d] ����� � ����.", PlayerName[playerid], playerid);
		foreach(Player, cid) if (Player[cid][MyClan] == Player[playerid][MyClan] && Logged[cid] == 1 && cid != playerid) {SendClientMessage(cid,ClanColor[ccolor],cMes); cOnline += 1;}
		format(cMes,sizeof(cMes),"����� ����������� � ����: %d", cOnline); SendClientMessage(playerid,ClanColor[ccolor],cMes);
		if(Clan[clanid][cBase] > MAX_BASE && Player[playerid][Leader] == 100)
		{//���� ����������. ���������� ������ ������ �� ����
  	        if (Player[playerid][Spawn] == 5 || Player[playerid][Spawn] == 8) Player[playerid][Spawn] = 0;
			new String[80]; format(String, sizeof String, "��� ���� ����������! �� ��� ���������� ���� ���� ���������� {FFFFFF}%d{FF0000}$", Clan[clanid][cBase]);
	        Player[playerid][Bank] += Clan[clanid][cBase];SavePlayer(playerid);
            Clan[clanid][cBase] = 0; SaveClan(clanid);
			SendClientMessage(playerid,COLOR_RED,String);
		}//���� ����������. ���������� ������ ������ �� ����
	}//�������� �����
	return 1;
}//�������� ����� ������ ��� ������



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
	
	//����� � ����
	getdate(Year, Month, Day); gettime(hour,minute,second);
	format(RestartDate,sizeof RestartDate, "%d/%d/%d � %d:%d:%d", Day, Month, Year, hour, minute, second);
	format(ServerLimitXPDate,sizeof ServerLimitXPDate, "%d/%d/%d � %d:00", Day, Month, Year, hour);
	
	//������ � ���. �������� WriteLog("����", "������ ���!"); ������� � ��� "����.ini" ����� "������ ���!"
	for (new i = 1; i < 11; i++) WriteLog("GlobalLog","");
	new String[120];format(String, sizeof String, "%d.%d.%d � %d:%d:%d |   ������ �������.", Day, Month, Year, hour, minute, second);WriteLog("GlobalLog", String);

	//����
	MenuMyskin = LoadModelSelectionMenu("MenuLists/skins.txt");
	MenuFirstCar = LoadModelSelectionMenu("MenuLists/firstcar.txt");
	MenuClass1 = LoadModelSelectionMenu("MenuLists/class1.txt");
	MenuClass2 = LoadModelSelectionMenu("MenuLists/class2.txt");
	MenuClass3 = LoadModelSelectionMenu("MenuLists/class3.txt");
	MenuBuyGun = LoadModelSelectionMenu("MenuLists/buygun.txt");
	MenuPaintJob = LoadModelSelectionMenu("MenuLists/paintjob.txt");
	MenuPrestigeCars = LoadModelSelectionMenu("MenuLists/PrestigeCars.txt");
	
	#include "Transformer\Objects\Other"//������ ������ �������
	#include "Transformer\Objects\zombie9"//zombie 9 �����
	#include "Transformer\Objects\zombie10"//zombie 10 �����
	#include "Transformer\Objects\zombie11"//zombie 11 ������ �����
	#include "Transformer\Objects\zombie12"//zombie 12 �������
	#include "Transformer\Objects\zombie14"//zombie 14 ����������
	#include "Transformer\Objects\zombie15"//zombie 15 ��� �����
	#include "Transformer\Objects\derby5"//derby 5 ����� "�� �����"
	#include "Transformer\Objects\derby6"//derby 6 ����� "��� ��������"
	#include "Transformer\Objects\derby7"//derby 7 ����� "�����������"
	#include "Transformer\Objects\derby8"//derby 8 ����� "���� �����"
	#include "Transformer\Objects\derby9"//derby 9 ����� "World of Tanks"
	#include "Transformer\Objects\Casino"//������
	#include "Transformer\Objects\StaticActors" //��������� NPC

	//�����
	CreateDynamicPickup( 1318, 1, 1459.3660,-1010.2814,26.8438);
	CreateDynamicMapIcon(1459.3660,-1010.2814,26.8438, 52, -1, 0, 0, -1, 200.0);
	Create3DTextLabel("{008E00}����\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� �����", COLOR_WHITE, 1459.3660,-1010.2814,26.8438, 50, 0);
	CreateDynamicPickup( 1318, 1, -2766.5518,375.5609,6.3347);
	CreateDynamicMapIcon(-2766.5518,375.5609,6.3347, 52, -1, 0, 0, -1, 200.0);
	Create3DTextLabel("{008E00}����\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� �����", COLOR_WHITE, -2766.5518,375.5609,6.3347, 50, 0);
	CreateDynamicPickup( 1318, 1, 2364.8967,2377.5842,10.8203);
	CreateDynamicMapIcon(2364.8967,2377.5842,10.8203, 52, -1, 0, 0, -1, 200.0);
	Create3DTextLabel("{008E00}����\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� �����", COLOR_WHITE, 2364.8967,2377.5842,10.8203, 50, 0);
	CreateDynamicPickup( 1318, 1, 562.1108,-1506.6329,14.5491);
	CreateDynamicMapIcon(562.1108,-1506.6329,14.5491, 52, -1, 0, 0, -1, 200.0);
	Create3DTextLabel("{008E00}����\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� �����", COLOR_WHITE, 562.1108,-1506.6329,14.5491, 50, 0);
	CreateDynamicPickup( 1318, 1, -1896.0466,483.7038,35.1719);
	CreateDynamicMapIcon(-1896.0466,483.7038,35.1719, 52, -1, 0, 0, -1, 200.0);
	Create3DTextLabel("{008E00}����\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� �����", COLOR_WHITE, -1896.0466,483.7038,35.1719, 50, 0);
	CreateDynamicPickup( 1318, 1, 1047.7667,1006.5556,11.0000);
	CreateDynamicMapIcon(1047.7667,1006.5556,11.0000, 52, -1, 0, 0, -1, 200.0);
	Create3DTextLabel("{008E00}����\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� �����", COLOR_WHITE, 1047.7667,1006.5556,11.0000, 50, 0);
	//���� - ����� �� ���������
	CreateDynamicPickup( 1318, 1, 2304.6858,-16.2069,26.7422);
	Create3DTextLabel("{008E00}����\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� �����", COLOR_WHITE, 2304.6858,-16.2069,26.7422, 50, 0);
	//���� - ������ ��� ��������
	CreateDynamicPickup(1274, 1, 2316.6182,-7.2874,26.7422,-1,-1,-1,100);
	Create3DTextLabel("{008E00}����\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� ������������", COLOR_WHITE, 2316.6182,-7.2874,26.7422, 50, 0);

	
    for(new i = 0; i < 4; i++)
	{//�������� ������
        CreateDynamicMapIcon(CLOTHESENTERS[i][0], CLOTHESENTERS[i][1], CLOTHESENTERS[i][2], 45, 0, -1, -1, -1, 300 );
		CreateDynamicPickup(1275, 1, CLOTHESENTERS[i][0], CLOTHESENTERS[i][1], CLOTHESENTERS[i][2], 0);
		Create3DTextLabel("{007FFF}������� ������\n{FFFF00}���������: {FFFFFF}10 000$\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� ������������", COLOR_WHITE, CLOTHESENTERS[i][0], CLOTHESENTERS[i][1], CLOTHESENTERS[i][2], 50, 0);
	}//�������� ������

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
	
	WorkZoneCombine = GangZoneCreate(-1198.7462, -1066.4282, -1001.5065, -908.7125);//���� ����������

	SetTimer("SecUpdate", 1000, true);

	//skinchange td
	SkinChangeTextDraw = TextDrawCreate(152 ,200 , "<   >");
	TextDrawFont(SkinChangeTextDraw , 3);
	TextDrawLetterSize(SkinChangeTextDraw , 5, 20);
	TextDrawColor(SkinChangeTextDraw , 0xFF6666FF);
	TextDrawSetOutline(SkinChangeTextDraw , false);
	TextDrawSetProportional(SkinChangeTextDraw , true);
	TextDrawSetShadow(SkinChangeTextDraw , 4);

	//����
	TextDrawDate = TextDrawCreate(547.000000,11.000000,"--");
	TextDrawFont(TextDrawDate,3);
	TextDrawLetterSize(TextDrawDate,0.399999,1.600000);
    TextDrawColor(TextDrawDate,0xffffffff);
	//�����
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
	{// ���������� � MAX_PLAYERS
		TextDrawEvent[ill] = TextDrawCreate(2, 436, "����� �� ������ ������������");
		TextDrawFont(TextDrawEvent[ill], 1);
		TextDrawLetterSize(TextDrawEvent[ill], 0.3, 1.2);
		TextDrawSetOutline(TextDrawEvent[ill], 1);
		TextDrawSetProportional(TextDrawEvent[ill], true);
		TextDrawSetShadow(TextDrawEvent[ill], 0);
	
		SpecInfo[ill] = TextDrawCreate(2, 436, "������: ���������� �� ������..");
		TextDrawFont(SpecInfo[ill] , 1);
		TextDrawLetterSize(SpecInfo[ill] , 0.3, 1.2);
		TextDrawColor(SpecInfo[ill] , 0xFFFF00FF);
		TextDrawSetOutline(SpecInfo[ill] , 1);
		TextDrawSetProportional(SpecInfo[ill] , true);
		TextDrawSetShadow(SpecInfo[ill] , 0);

		SpecInfoVeh[ill] = TextDrawCreate(2, 425, "������: ���������� � ������ ������..");
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
		
		//LevelupTD - �������� ��������� ������
		LevelupTD[ill] = TextDrawCreate(150 ,335 , "LEVEL N");
		TextDrawFont(LevelupTD[ill], 3);
		TextDrawLetterSize(LevelupTD[ill], 3, 10);
		TextDrawColor(LevelupTD[ill], 0xFFFFFFFF);
		TextDrawSetOutline(LevelupTD[ill], 1);
		TextDrawSetProportional(LevelupTD[ill], true);
		TextDrawSetShadow(LevelupTD[ill], 3);
		
		//������ ������� �� ������
		TextDrawWorkTimer[ill] = TextDrawCreate(40, 300, "00:00");
		TextDrawFont(TextDrawWorkTimer[ill] , 1);
		TextDrawLetterSize(TextDrawWorkTimer[ill] , 0.6, 2.4);
		TextDrawColor(TextDrawWorkTimer[ill] , 0x457EFFFF);
		TextDrawSetOutline(TextDrawWorkTimer[ill] , 1);
		TextDrawSetProportional(TextDrawWorkTimer[ill] , true);
		TextDrawSetShadow(TextDrawWorkTimer[ill] , 0);
	}// ���������� � MAX_PLAYERS
	
	//����� ����������� � ������ ������������
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
	Create3DTextLabel("{007FFF}����������� ������\n{FFFF00}���������: {FFFFFF}100$\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� ������������\n\n{AFAFAF}���������� ������ ��� ������!", COLOR_WHITE,2064.5986,-1831.6934,13.5469, 50, 0);
	Create3DTextLabel("{007FFF}����������� ������\n{FFFF00}���������: {FFFFFF}100$\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� ������������\n\n{AFAFAF}���������� ������ ��� ������!", COLOR_WHITE,1024.8928,-1024.6052,32.1016, 50, 0);
	Create3DTextLabel("{007FFF}����������� ������\n{FFFF00}���������: {FFFFFF}100$\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� ������������\n\n{AFAFAF}���������� ������ ��� ������!", COLOR_WHITE,487.3758,-1741.0320,11.1321, 50, 0);
	Create3DTextLabel("{007FFF}����������� ������\n{FFFF00}���������: {FFFFFF}100$\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� ������������\n\n{AFAFAF}���������� ������ ��� ������!", COLOR_WHITE,-1904.6287,285.5661,41.0469, 50, 0);
	Create3DTextLabel("{007FFF}����������� ������\n{FFFF00}���������: {FFFFFF}100$\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� ������������\n\n{AFAFAF}���������� ������ ��� ������!", COLOR_WHITE,-2425.6978,1020.8086,50.3977, 50, 0);
	Create3DTextLabel("{007FFF}����������� ������\n{FFFF00}���������: {FFFFFF}100$\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� ������������\n\n{AFAFAF}���������� ������ ��� ������!", COLOR_WHITE,1976.5468,2162.4783,11.0703, 50, 0);
	Create3DTextLabel("{007FFF}����������� ������\n{FFFF00}���������: {FFFFFF}100$\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� ������������\n\n{AFAFAF}���������� ������ ��� ������!", COLOR_WHITE,720.0233,-456.4514,16.3359, 50, 0);
	Create3DTextLabel("{007FFF}����������� ������\n{FFFF00}���������: {FFFFFF}100$\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� ������������\n\n{AFAFAF}���������� ������ ��� ������!", COLOR_WHITE,-99.9693,1118.9204,19.7417, 50, 0);
	Create3DTextLabel("{007FFF}����������� ������\n{FFFF00}���������: {FFFFFF}100$\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� ������������\n\n{AFAFAF}���������� ������ ��� ������!", COLOR_WHITE,-1420.1829,2583.6006,55.8433, 50, 0);
	
    //--------- �������������� Icons
    CreateDynamicMapIcon(2644.6580,-2044.3076,13.6352, 27, -1, 0, 0, -1, 350.0); // Tune Lowrider
	CreateDynamicMapIcon(1041.5431,-1016.8201,32.1075, 27, -1, 0, 0, -1, 350.0); // Tune Transfender Los Santos
	CreateDynamicMapIcon(-1936.0847,245.9636,34.4609, 27, -1, 0, 0, -1, 350.0); // Tune Transfender San Fierro
	CreateDynamicMapIcon(-2723.5532,217.1511,4.4844, 27, -1, 0, 0, -1, 350.0); // Tune Arch Angels
	CreateDynamicMapIcon(2386.7300,1051.5768,10.8203, 27, -1, 0, 0, -1, 350.0); // Tune Transfender Las Venturas 1
    CreateDynamicMapIcon(-2026.9791,124.2575,29.1300, 27, -1, 0, 0, -1, 350.0); // Tune TurboSpeed
    //--------- �������������� TextLabel
    Create3DTextLabel("{007FFF}��������������\n{FFFFFF}Lowrider", COLOR_WHITE,2644.6580,-2044.3076,13.6352, 50, 0);// Tune Lowrider
	Create3DTextLabel("{007FFF}��������������\n{FFFFFF}Transfender", COLOR_WHITE,1041.5431,-1016.8201,32.1075, 50, 0);// Tune Transfender Los Santos
	Create3DTextLabel("{007FFF}��������������\n{FFFFFF}Transfender", COLOR_WHITE,-1936.0847,245.9636,34.4609, 50, 0);// Tune Transfender San Fierro
	Create3DTextLabel("{007FFF}��������������\n{FFFFFF}Arch Angels", COLOR_WHITE,-2723.5532,217.1511,4.4844, 50, 0);// Tune Arch Angels
	Create3DTextLabel("{007FFF}��������������\n{FFFFFF}Transfender", COLOR_WHITE,2386.7300,1051.5768,10.8203, 50, 0);// Tune Transfender Las Venturas 1
	Create3DTextLabel("{007FFF}��������������\n{9966CC}TurboSpeed\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� ������������", COLOR_WHITE,-2026.9791,124.2575,29.1300, 50, 0);// Tune TurboSpeed

	//������ - ��������� �����
	Create3DTextLabel("{FFCC00}��������� �����\n{007FFF}2400 XP � 144 000$ / ���\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� ������ ������", COLOR_WHITE, 2397.7632, -1899.1389, 13.5469, 50, 0);
	CreateDynamicPickup( 1318, 1, 2397.7632, -1899.1389, 13.5469,-1,-1,-1,100);
	CreateDynamicMapIcon(2397.7632, -1899.1389, 13.5469, 14, -1, 0, 0, -1, 200.0);
	//������ - �������
	Create3DTextLabel("{FFCC00}�������\n{007FFF}2700 XP � 108 000$ / ���\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� ������ ������", COLOR_WHITE, 2729.3267, -2451.4578, 17.5937, 50, 0);
	CreateDynamicPickup( 1318, 1, 2729.3267, -2451.4578, 17.5937,-1,-1,-1,100);
	CreateDynamicMapIcon(2729.3267, -2451.4578, 17.5937, 54, -1, 0, 0, -1, 200.0);
	//������ - ��������
	Create3DTextLabel("{FFCC00}��������\n{007FFF}2880 XP � 360 000$ / ���\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� ������ ������", COLOR_WHITE, -1972.5024,-1020.2568,32.1719, 50, 0);
	CreateDynamicPickup( 1318, 1, -1972.5024,-1020.2568,32.1719,-1,-1,-1,100);
	CreateDynamicMapIcon(-1972.5024,-1020.2568,32.1719, 51, -1, 0, 0, -1, 200.0);
	//������ - ���������
	Create3DTextLabel("{FFCC00}���������\n{007FFF}3240 XP � 270 000$ / ���\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� ������ ������", COLOR_WHITE, -1061.6104,-1195.4755,129.8281, 50, 0);
	CreateDynamicPickup( 1318, 1, -1061.6104,-1195.4755,129.8281,-1,-1,-1,100);
	CreateDynamicMapIcon(-1061.6104,-1195.4755,129.8281, 11, -1, 0, 0, -1, 200.0);
	//������ - ������������
	Create3DTextLabel("{FFCC00}������������\n{007FFF}3420 XP � 540 000$ / ���\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� ������ ������", COLOR_WHITE, 2484.6682,-2120.8743,13.5469, 50, 0);
	CreateDynamicPickup( 1318, 1, 2484.6682,-2120.8743,13.5469,-1,-1,-1,100);
	CreateDynamicMapIcon(2484.6682,-2120.8743,13.5469, 51, -1, 0, 0, -1, 200.0);
	//������ - ������� �������
	Create3DTextLabel("{FFCC00}������� �������\n{007FFF}3600 XP � 396 000$ / ���\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� ������ ������", COLOR_WHITE, -1713.1389,-61.8556,3.5547, 50, 0);
	CreateDynamicPickup( 1318, 1, -1713.1389,-61.8556,3.5547,-1,-1,-1,100);
	CreateDynamicMapIcon(-1713.1389,-61.8556,3.5547, 9, -1, 0, 0, -1, 200.0);
	//������ - ����������
	Create3DTextLabel("{FFCC00}����������\n{007FFF}2400 XP � 900 000$ / ���\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� ������ ������", COLOR_WHITE, 2364.8955, 2382.8770, 10.8203, 50, 0);
	CreateDynamicPickup( 1318, 1, 2364.8955, 2382.8770, 10.8203, -1, -1, -1, 100);

	//��������� ����� - ������
	CreateDynamicPickup( 1318, 1, 2324.4902,-1149.5474,1050.7101,-1,-1,-1,100);
	Create3DTextLabel("{007FFF}�����\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� ������������", COLOR_WHITE, 2324.4902,-1149.5474,1050.7101, 15, 0);
	CreateDynamicPickup( 1318, 1, 243.7173,304.9818,999.1484,-1,-1,-1,100);
	Create3DTextLabel("{007FFF}�����\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� ������������", COLOR_WHITE, 243.7173,304.9818,999.1484, 15, 0);
	CreateDynamicPickup( 1318, 1, 2218.4033,-1076.2634,1050.4844,-1,-1,-1,100);
	Create3DTextLabel("{007FFF}�����\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� ������������", COLOR_WHITE, 2218.4033,-1076.2634,1050.4844, 15, 0);
	CreateDynamicPickup( 1318, 1, 2365.3140,-1135.5983,1050.8826,-1,-1,-1,100);
	Create3DTextLabel("{007FFF}�����\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� ������������", COLOR_WHITE, 2365.3140,-1135.5983,1050.8826, 15, 0);
	CreateDynamicPickup( 1318, 1, 2496.0002,-1692.0852,1014.7422,-1,-1,-1,100);
	Create3DTextLabel("{007FFF}�����\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� ������������", COLOR_WHITE, 2496.0002,-1692.0852,1014.7422, 15, 0);
	CreateDynamicPickup( 1318, 1, 2270.4172,-1210.4956,1047.5625,-1,-1,-1,100);
	Create3DTextLabel("{007FFF}�����\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� ������������", COLOR_WHITE, 2270.4172,-1210.4956,1047.5625, 15, 0);

    //��������� ����� - ����� �����
    CreateDynamicPickup( 1275, 1, 2332.5144,-1144.4189,1054.3047,-1,-1,-1,100);
	Create3DTextLabel("{007FFF}�������� ������ ���������\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� ������������", COLOR_WHITE, 2332.5144,-1144.4189,1054.3047, 15, 0);
    CreateDynamicPickup( 1275, 1, 2215.7893,-1074.6979,1050.4844,-1,-1,-1,100);
	Create3DTextLabel("{007FFF}�������� ������ ���������\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� ������������", COLOR_WHITE, 2215.7893,-1074.6979,1050.4844, 15, 0);
    CreateDynamicPickup( 1275, 1, 2363.7717,-1127.3329,1050.8826,-1,-1,-1,100);
	Create3DTextLabel("{007FFF}�������� ������ ���������\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� ������������", COLOR_WHITE, 2363.7717,-1127.3329,1050.8826, 15, 0);
    CreateDynamicPickup( 1275, 1, 2492.4016,-1708.5626,1018.3368,-1,-1,-1,100);
	Create3DTextLabel("{007FFF}�������� ������ ���������\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� ������������", COLOR_WHITE, 2492.4016,-1708.5626,1018.3368, 15, 0);
    CreateDynamicPickup( 1275, 1, 2262.7871,-1216.8030,1049.0234,-1,-1,-1,100);
	Create3DTextLabel("{007FFF}�������� ������ ���������\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� ������������", COLOR_WHITE, 2262.7871,-1216.8030,1049.0234, 15, 0);

    //��������� ������ - ������
	CreateDynamicPickup( 1318, 1, 774.0399,-78.7388,1000.6627,-1,-1,-1,100);
	CreateDynamicPickup( 1318, 1, 774.0266,-50.3715,1000.5859,-1,-1,-1,100);
	CreateDynamicPickup( 1318, 1, 1727.0281,-1637.9517,20.2230,-1,-1,-1,100);
	CreateDynamicPickup( 1318, 1, -2636.4778,1402.5682,906.4609,-1,-1,-1,100);

	//������ - �������
	Create3DTextLabel("{9966CC}�������\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� �������", COLOR_WHITE, 1962.3420, 1009.6814, 992.4688, 20, 10);
	Create3DTextLabel("{9966CC}�������\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� �������", COLOR_WHITE, 1958.0320, 1009.6746, 992.4688, 20, 10);
	Create3DTextLabel("{9966CC}�������\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� �������", COLOR_WHITE, 1962.3417, 1025.3008, 992.4688, 20, 10);
	Create3DTextLabel("{9966CC}�������\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� �������", COLOR_WHITE, 1958.0321, 1025.2384, 992.4688, 20, 10);
    //������ - ������ �����
    Create3DTextLabel("{FFCC00}������� �����\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� ��������", COLOR_WHITE, 1954.1530, 995.4341, 992.8594, 50, 10);

	//������ 4 ������� - ���� �����
	CreateDynamicPickup( 1318, 1, 1958.3613, 953.2741, 10.8203);
	CreateDynamicMapIcon(1958.3613, 953.2741, 10.8203, 25, -1, 0, 0, -1, 200.0);
	Create3DTextLabel("{9966CC}������\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� ������������", COLOR_WHITE, 1958.3613, 953.2741, 10.8203, 50, 0);
	//������ 4 ������� - ���� �����������
	CreateDynamicPickup(1318, 1, 2019.3174, 1007.8547, 10.8203);
	CreateDynamicMapIcon(2019.3174, 1007.8547, 10.8203, 25, -1, 0, 0, -1, 200.0);
	Create3DTextLabel("{9966CC}������\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� ������������", COLOR_WHITE, 2019.3174, 1007.8547, 10.8203, 50, 0);
	//������ 4 ������� - ���� ������
	CreateDynamicPickup(1318, 1, 1944.2803, 1076.0552, 10.8203);
	CreateDynamicMapIcon(1944.2803, 1076.0552, 10.8203, 25, -1, 0, 0, -1, 200.0);
	Create3DTextLabel("{9966CC}������\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� ������������", COLOR_WHITE, 1944.2803, 1076.0552, 10.8203, 50, 0);
	//������ 4 ������� - ����� �����
	CreateDynamicPickup( 1318, 1, 1963.7800, 972.4600, 994.4688);
	Create3DTextLabel("{9966CC}�����\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� ������������", COLOR_WHITE, 1963.7800, 972.4600, 994.4688, 50, 10);
	//������ 4 ������� - ����� �����������
	CreateDynamicPickup( 1318, 1, 2018.9702, 1017.8456, 996.8750);
	Create3DTextLabel("{9966CC}�����\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� ������������", COLOR_WHITE, 2018.9702, 1017.8456, 996.8750, 50, 10);
	//������ 4 ������� - ����� ������
	CreateDynamicPickup( 1318, 1, 1963.6882, 1063.2550, 994.4688);
	Create3DTextLabel("{9966CC}�����\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� ������������", COLOR_WHITE, 1963.6882, 1063.2550, 994.4688, 50, 10);

	//���������
	CreateDynamicPickup( 1318, 1, 1451.6349, -2287.0703, 13.5469);
	CreateDynamicMapIcon(1451.6349, -2287.0703, 13.5469, 5, -1, 0, 0, -1, 200.0);
	Create3DTextLabel("{007FFF}��������\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� ������������", COLOR_WHITE, 1451.6349, -2287.0703, 13.5469, 50, 0);
	CreateDynamicPickup( 1318, 1, -1404.6575, -303.7458, 14.1484);
	CreateDynamicMapIcon(-1404.6575, -303.7458, 14.1484, 5, -1, 0, 0, -1, 200.0);
	Create3DTextLabel("{007FFF}��������\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� ������������", COLOR_WHITE, -1404.6575, -303.7458, 14.1484, 50, 0);
	CreateDynamicPickup( 1318, 1, 1672.9861, 1447.9349, 10.7868);
	CreateDynamicMapIcon(1672.9861, 1447.9349, 10.7868, 5, -1, 0, 0, -1, 200.0);
	Create3DTextLabel("{007FFF}��������\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� ������������", COLOR_WHITE, 1672.9861, 1447.9349, 10.7868, 50, 0);
	//� �����
	CreateDynamicPickup( 1318, 1, 2315.5173, 0.3555, 26.7422);
	Create3DTextLabel("{007FFF}����������� ��������\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� ������������", COLOR_WHITE, 2315.5173, 0.3555, 26.7422, 30, 0);


	//--------- �����
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
	
	//���� ��� �����
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

	//������ ���� ��� �����
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

	//��������� ���� ��� �����
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
	
	//������ ��� ������ �������
	ServerWeather = random(20);
	if (ServerWeather == 8 || ServerWeather == 16 || ServerWeather == 19) ServerWeather -= 1;//�������� ������ � ������ � � �����
    if (ServerWeather == 9) ServerWeather = 10;
	SetWeather(ServerWeather);

	//new Test[80]; format(Test, sizeof Test, "Dynamic Pickups: %d", CountDynamicPickups()); print(Test);
	return 1;
}

public OnGameModeExit()
{
	SaveAllClans();SaveAllProperty(); SaveAllBase();
	foreach(Player, gid) if (Logged[gid] == 1) {SavePlayer(gid); Logged[gid] = 0;}
	
	//������ � ���. �������� WriteLog("����", "������ ���!"); ������� � ��� "����.ini" ����� "������ ���!"
	new String[120];format(String, sizeof String, "%d.%d.%d � %d:%d:%d |   ������ ��������.", Day, Month, Year, hour, minute, second);WriteLog("GlobalLog", String);

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
	//������ ���������� NeedXP
	new Lvl = Player[playerid][Level];
	if (Player[playerid][Prestige] < 10 || Lvl < 100) NeedXP[playerid] = Levels[Lvl];
	else NeedXP[playerid] = (Lvl - 99) * 100 + 35000;

	for (new i; i < 100; i++) SendClientMessage(playerid, -1, "");
    new WelcomeString[120];format(WelcomeString, sizeof WelcomeString, "{FFFFFF}����� ���������� �� ������ {007FFF}%s", SERVER_NAME);
	SendClientMessage(playerid,-1,WelcomeString);
	SendClientMessage(playerid,COLOR_WHITE,"{457EFF}���������� �������: {FF0000}/help, {FFFF00}/events, /quests, /gps, /stats, /bg, /radio");
	SendClientMessage(playerid,COLOR_WHITE,"{457EFF}���: {FFFF00}/pm, '@�����' - ���������������, '#�����' - �������, '!�����' - �����");
	SendClientMessage(playerid,COLOR_WHITE,"{FFFFFF}����� ���������� ������ ������ ������, ������� {007FFF}/commands");

    if (LogidDialogShowed[playerid] == 0)
	{//���� ������ ���
		new string[MAX_DIALOG_INFO];
        if(Registered[playerid] == 0)
		{//���� �����������
		    format(string, sizeof(string), "{FFFFFF}����� ���������� �� {00BFFF}%s{FFFFFF}\n��� ���� ��� ����� ������������������\n\n������� ������ ��� ������ ��������\n�� ����� ������������� ��� ������ ������ �� ������\n\n     {008000}����������:\n     - ������ ������ ���� ������� (������: s9cQ17)\n     - ����� ������ ������ ���� �� 6 �� 24 ��������\n\n{FFFFFF}������� ������:", SERVER_NAME);
			ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "{FFD700}�����������", string, "������", "������");
			LoginKickTime[playerid] = 180;//������ 3 ������ �� �����������
		}//���� ����������� � ����� �����
		if(Registered[playerid] == 1)
		{//���� ������
			format(string, sizeof(string), "{FFFFFF}����� ���������� �� {00BFFF}%s{FFFFFF}\n��� ������� ���������������\n\n�����: {008000}%s\n{FFFFFF}������� ������:", SERVER_NAME, GetName(playerid));
			ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT, "{FFD700}�����������", string, "�����", "������");
			LoginKickTime[playerid] = 120;//������ 2 ������ �� �����������
		}//���� ������
		LogidDialogShowed[playerid] = 1; TogglePlayerSpectating(playerid, 1);

		InterpolateCameraPos(playerid, 2347.1621,2138.8210,41, 2347.1621,2138.8210,41, 10000, CAMERA_CUT);
		InterpolateCameraLookAt(playerid, 2320.1621,2138.8210,41, 2320.1621,2138.8210,41, 1000, CAMERA_CUT);
	}//���� ������ ���
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
	//--- �� ������ 3 ������� � 1 IP
	new ip[2][16];
    GetPlayerIp(playerid,ip[0],16);GetPlayerIp(playerid,PlayerIP[playerid],16);
    for(new i, m = GetMaxPlayers(), x; i != m; i++)
    {//--- �� ������ 3 ������� � 1 IP
        if(!IsPlayerConnected(i) || i == playerid) continue;
        GetPlayerIp(i,ip[1],16);
        if(!strcmp(ip[0],ip[1],true)) x++;
        if(x > 3) return Kick(i);
    }//--- �� ������ 3 ������� � 1 IP

	//--- ����� � ����
	new PlName[MAX_PLAYER_NAME],count;
	GetPlayerName(playerid,PlName,sizeof(PlName));
	for (new i; i < strlen(PlName); i++)
	{
	    if (PlName[i] >= '0' && PlName[i] <= '9')
	    {
	        count++;
	        if(count == 6)
	        {
	            for (new ii = 1; ii <= 5; ii++) SendClientMessage(playerid,COLOR_RED,"������: � ����� ���� ������ 5 ����!");
	            return GKick(playerid);
	        }
	    }
	}//--- ����� � ����

	ClanTextShowed[playerid] = 0;
	Player[playerid][MyClan] = 0;
	if (playerid > MaxPlayerID) MaxPlayerID = playerid;
	
	XReg[playerid] = 0;
	pKick[playerid] = 0;
	
	LSpecID[playerid] = -1;
	LSpectators[playerid] = 0;
	countpos[playerid] = 0;//vortex nitro

	//��������� LAC
	ResetPlayerWeapons(playerid);
	LACSH[playerid] = 3;LACTeleportOff[playerid] = 10;
	LACWeaponOff[playerid] = 3;
	CheatFlySec[playerid] = 0; LACFlyOff[playerid] = 0;//�� FlyHack
	LACPedSHOff[playerid] = 0; LACPedSHTime[playerid] = 0;//�� SH ������ � Slapper
	LACPanic[playerid] = 0; LACPanicTime[playerid] = 0;//LAC v2.0
	PlayerColor[playerid] = 0; //��������� �����
	
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
	SetPlayerColor(playerid,COLOR_GREY);//������ ������ ����� ����
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
	LastBaseVisited[playerid] = 0; LastHouseVisited[playerid] = 0;//��� ���� ����� � ������
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
	FirstSobeitCheck[playerid] = 0;//��������� �������� �� Sobeit
	
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
	 
	InitFly(playerid);//��� ������ �����-���� (������� 2)
	OnVehFly[playerid] = 0;//��� ������ �� ���� (������� 4)

	DisablePlayerCheckpoint(playerid);
	DisablePlayerRaceCheckpoint(playerid);
    GetPlayerName(playerid, PlayerName[playerid], 25);

	PlayerWeather[playerid] = 17; PlayerTime[playerid] = 23;//������ �� ������

	strmid(ChatName[playerid], PlayerName[playerid], 0, strlen(PlayerName[playerid]), 24);
	SetTimerEx("SecPlayerUpdate" , 1000, false, "i", playerid);
	#include "Transformer\Objects\RemoveBuilding" //�������� �������� � �����
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	new OldMaxPlayerID = MaxPlayerID;
	for (new vid = 1; vid <= OldMaxPlayerID; vid++)
	{//����
	    if (IsPlayerConnected(vid) != 0)	MaxPlayerID = vid;
	}//����

	PlayerAFK[playerid][AFK_Time] = 0;
	if(PlayerAFK[playerid][AFK_Stat] != 0) { Delete3DTextLabel(AFK_3DT[playerid]); PlayerAFK[playerid][AFK_Stat] = 0; }

	if (PlayerPVP[playerid][Status] >= 2) FailPVP(playerid);

	ClanTextShowed[playerid] = 0;
	
	if (Logged[playerid] == 1)
	{//------------��������� � ������ ������ � �������
		new ChatMes[140], clanid = Player[playerid][MyClan], ccolor = Clan[clanid][cColor];
		switch (reason)
		{
			case 0:
				{
		           	foreach(Player, gid)
					{//����
						if (clanid > 0 && Player[gid][MyClan] == clanid)
						{
    					    format(ChatMes, sizeof ChatMes, "���������� %s[%d] ������� ������ (�����).", PlayerName[playerid], playerid);
							SendClientMessage(gid,ClanColor[ccolor],ChatMes);
						}
						if (Logged[gid] == 1 && Player[gid][Admin] > 0)
						{//���� ����� � ����
						    format(ChatMes, sizeof(ChatMes), "SERVER: %s[%d] ������� ������ (�����)[IP-�����:{FFFFFF} %s{AFAFAF}].", PlayerName[playerid], playerid, PlayerIP[playerid]);
						}//���� ����� � ����
						else{format(ChatMes, sizeof(ChatMes), "SERVER: %s[%d] ������� ������ (�����).", PlayerName[playerid], playerid);}
						if (Player[gid][ConMesEnterExit] == 1 && IsServerRestaring == 0) SendClientMessage(gid, COLOR_GREY, ChatMes);
					}//����
					//������ � ���. �������� WriteLog("����", "������ ���!"); ������� � ��� "����.ini" ����� "������ ���!"
					format(ChatMes, sizeof ChatMes, "%d.%d.%d � %d:%d:%d |   %s[%d] ������� ������ (�����)[IP-�����: %s].", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid, PlayerIP[playerid]);WriteLog("GlobalLog", ChatMes);
				}
			case 1:
				{
					foreach(Player, gid)
					{//����
						if (clanid > 0 && Player[gid][MyClan] == clanid)
						{
    					    format(ChatMes, sizeof ChatMes, "���������� %s[%d] ������� ������.", PlayerName[playerid], playerid);
							SendClientMessage(gid,ClanColor[ccolor],ChatMes);
						}
						if (Logged[gid] == 1 && Player[gid][Admin] > 0)
						{//���� ����� � ����
						    format(ChatMes, sizeof(ChatMes), "SERVER: %s[%d] ������� ������ [IP-�����:{FFFFFF} %s{AFAFAF}].", PlayerName[playerid], playerid, PlayerIP[playerid]);
						}//���� ����� � ����
						else{format(ChatMes, sizeof(ChatMes), "SERVER: %s[%d] ������� ������.", PlayerName[playerid], playerid);}
						if (Player[gid][ConMesEnterExit] == 1 && IsServerRestaring == 0) SendClientMessage(gid, COLOR_GREY, ChatMes);
					}//����
					if (InEvent[playerid] == EVENT_ZOMBIE && ZMTimeToFirstZombie == 0) Player[playerid][LeaveZM] = 3600;//��� �� ����� ����������� � �����-��������� ���� ��������� ����� ���������
	                //������ � ���. �������� WriteLog("����", "������ ���!"); ������� � ��� "����.ini" ����� "������ ���!"
					format(ChatMes, sizeof ChatMes, "%d.%d.%d � %d:%d:%d |   %s[%d] ������� ������ [IP-�����: %s].", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid, PlayerIP[playerid]);WriteLog("GlobalLog", ChatMes);
				}
			case 2:
				{
					foreach(Player, gid)
					{//����
						if (clanid > 0 && Player[gid][MyClan] == clanid)
						{
    					    format(ChatMes, sizeof ChatMes, "���������� %s[%d] ������� ������ (���/���).", PlayerName[playerid], playerid);
							SendClientMessage(gid,ClanColor[ccolor],ChatMes);
						}
						if (Logged[gid] == 1 && Player[gid][Admin] > 0)
						{//���� ����� � ����
						    format(ChatMes, sizeof(ChatMes), "SERVER: %s[%d] ������� ������ (���/���)[IP-�����:{FFFFFF} %s{AFAFAF}].", PlayerName[playerid], playerid, PlayerIP[playerid]);
						}//���� ����� � ����
						else{format(ChatMes, sizeof(ChatMes), "SERVER: %s[%d] ������� ������ (���/���).", PlayerName[playerid], playerid);}
						if (Player[gid][ConMesEnterExit] == 1 && IsServerRestaring == 0) SendClientMessage(gid, COLOR_GREY, ChatMes);
					}//����
					//������ � ���. �������� WriteLog("����", "������ ���!"); ������� � ��� "����.ini" ����� "������ ���!"
					format(ChatMes, sizeof ChatMes, "%d.%d.%d � %d:%d:%d |   %s[%d] ������� ������ (���/���)[IP-�����: %s].", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid, PlayerIP[playerid]);WriteLog("GlobalLog", ChatMes);
				}
			}
	}//------------��������� � ������ ������ � �������
	
	LogidDialogShowed[playerid] = 0;
	Player[playerid][CarActive] = 0;
	JetpackUsed[playerid] = 0;
	if (Logged[playerid] == 1) SavePlayer(playerid);//���������� ����
	DerbyStarted[playerid] = 0;
	ZMStarted[playerid] = 0;
	FRStarted[playerid] = 0;DisablePlayerCheckpoint(playerid);
	XRStarted[playerid] = 0;DisablePlayerRaceCheckpoint(playerid);
	
	//�������� ��������� �������� �� ������
	KillTimer(FirstSobeitCheckTimer[playerid]);	FirstSobeitCheck[playerid] = 0;

    if(countpos[playerid] != 0)
	{//vortex nitro
		countpos[playerid] = 0;
		DestroyObject(Flame[playerid][0]);
		DestroyObject(Flame[playerid][1]);
	}//vortex nitro
	
	TextDrawHideForPlayer(playerid, TextDrawTime), TextDrawHideForPlayer(playerid, TextDrawDate);

    //���������� ������� � ���, ��� ������ �� �������
	foreach(Player, i)
	{//���������� ������� � ���, ��� ������ �� �������
	    if (LSpecID[i] == playerid)
	    {
	        TogglePlayerSpectating(i, 0);LSpecID[i] = -1;PlayerWeather[i] = -1;LSpawnPlayer(i);
	        SendClientMessage(i,COLOR_YELLOW,"�����, �� ������� �� �������, ������� ������.");
	    }
	}//���������� ������� � ���, ��� ������ �� �������
	
	//�������� ��������� � ������� ��������
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
	if (InEvent[playerid] == EVENT_GUNGAME) GiveGGWeapon(playerid);//������� �����
	
	if (LSpectators[playerid] > 0) {SpecUpdate(playerid);}
	
	Player[playerid][CarActive] = 0;
	PlayerCarID[playerid] = -1;
	DerbyStarted[playerid] = 0;
	LastDamageFrom[playerid] = -1;

	//----- ����� �����
	if (Player[playerid][Slot9] == 0){SetPlayerFightingStyle (playerid, FIGHT_STYLE_NORMAL);}
	if (Player[playerid][Slot9] == 1){SetPlayerFightingStyle (playerid, FIGHT_STYLE_BOXING);}
	if (Player[playerid][Slot9] == 2){SetPlayerFightingStyle (playerid, FIGHT_STYLE_KUNGFU);}
	if (Player[playerid][Slot9] == 3){SetPlayerFightingStyle (playerid, FIGHT_STYLE_KNEEHEAD);}
	if (Player[playerid][Slot9] == 4){SetPlayerFightingStyle (playerid, FIGHT_STYLE_GRABKICK);}
	if (Player[playerid][Slot9] == 5){SetPlayerFightingStyle (playerid, FIGHT_STYLE_ELBOW);}

    //PVars
	SetPVarInt(playerid, "CashBag", 0);//��� ����� ����� �� ������

	if (TutorialStep[playerid] != 999){SetPlayerVirtualWorld(playerid,playerid+1);}//������ �����������������
	if (Logged[playerid] > 0)
	{
	    TogglePlayerControllable(playerid, 1);
		SetTimerEx("SpawnStylePub" , 650, false, "i", playerid);//����� �� ������, ������ ������
	} else TogglePlayerControllable(playerid, 0);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{//����������� ������ (������������� �� playerid)
	LACWeaponOff[playerid] = 3; NOPSetPlayerHealthAndArmourOff[playerid] = 3;
	NeedLSpawn[playerid] = 1;
	if (OnFly[playerid] == 1) StopFly(playerid);//��������� ����� ��������� (�������)
	if (InEvent[playerid] == EVENT_RACE) SendCommand(playerid, "/race", ""); //����� ����� �������� ������ ���� ������ ����������� � ������
	if (InEvent[playerid] == EVENT_XRACE) SendCommand(playerid, "/xrace", ""); //����� ����� �������� ������ ���� ������ ����������� � ������

	//����-����� ����� ����� ����� ������������ �� ������������
	if (InEvent[playerid] == EVENT_DM || InEvent[playerid] == EVENT_GUNGAME || (InEvent[playerid] == EVENT_ZOMBIE && ZMIsPlayerIsZombie[playerid] > 0))
		if (killerid != LastDamageFrom[playerid] && IsPlayerConnected(LastDamageFrom[playerid])) OnPlayerDeathFromPlayer(playerid, LastDamageFrom[playerid], 54);

	return 1;
}//����������� ������ (������������� �� playerid)

stock OnPlayerDeathFromPlayer(playerid, killerid, weaponid)
{//������ �� ��� ������ (������������� �� killerid)
	if (LastDeathTime[playerid] < 3 || playerid == killerid) return 1;
    LastDeathTime[playerid] = 0;
    
    if (ZMIsPlayerIsZombie[playerid] == 0 && ZMIsPlayerIsZombie[killerid] > 0)
	{//����������� � ����� �����������
		ZMIsPlayerIsZombie[playerid] = 1; SendDeathMessage(killerid, playerid, 52);
		FarmedXP[killerid] += 100; FarmedMoney[killerid] += 800; //100 XP � 800$ �� ������ ����
		GameTextForPlayer(killerid, "~Y~+~W~100 ~Y~XP   +~W~800~Y~$", 3000, 6);
		return SendClientMessage(playerid, COLOR_ZOMBIE, "�� ����� �����! �������� ��������!");
	}//����������� � ����� �����������

    if (TimeAfterSpawn[playerid] < 5)
    {//����� � ������� 5 ��� ����� ��������
        SendClientMessage(playerid,COLOR_YELLOW,"SERVER: ��� ����� � ������� 5 ������ ����� ��������. �� �����������, �������� �� ���������.");
		return SendClientMessage(killerid,COLOR_RED,"SERVER: ������ ������� ������� � ������� 5 ������ ����� ��������! �������� �� ���������.");
    }//����� � ������� 5 ��� ����� ��������
    if (weaponid == 38 && Player[playerid][Level] < 60 && InEvent[playerid] == 0)
	{//�������� ���� � ��������
	    SendClientMessage(playerid,COLOR_YELLOW,"SERVER: ��� ���� ��� ������ �������� ����� �������� ������. �� �����������, �������� �� ���������.");
		return SendClientMessage(killerid,COLOR_RED,"SERVER: � �������� ������ ������� �������, �� ��������� 60-�� ������! �������� �� ���������.");
    }//�������� ���� � ��������
    if (AdminTPCantKill[killerid] > 0)
    {//������ ������� �������������� ���������
        SendClientMessage(playerid, COLOR_YELLOW, "SERVER: ��� ���� �����, ������� ����������� ������������.. �� �����������, �������� �� ���������.");
        return SendClientMessage(killerid, COLOR_RED, "SERVER: ��������� ������� ������� ����� ������������! �������� �� ���������.");
    }//������ ������� �������������� ���������
    
	SendDeathMessage(killerid, playerid, weaponid); //�������

    QuestUpdate(killerid, 6, 1);//���������� ������ ����� 50 �������
    if (weaponid <= 15 && weaponid > 0) QuestUpdate(killerid, 2, 1);//���������� ������ ����� 5 ������� ��� ������ ��������� ������
    else if (weaponid >= 22 && weaponid <= 24) QuestUpdate(killerid, 7, 1);//���������� ������ ����� 10 ������� �� ���������
    else if (weaponid >= 25 && weaponid <= 27) QuestUpdate(killerid, 8, 1);//���������� ������ ����� 10 ������� �� ���������
	else if (weaponid == 28 || weaponid == 29 || weaponid == 32) QuestUpdate(killerid, 9, 1);//���������� ������ ����� 10 ������� �� ��
	else if (weaponid == 30 || weaponid == 31) QuestUpdate(killerid, 10, 1);//���������� ������ ����� 10 ������� �� ��������
	
	if (PlayerPVP[playerid][Status] > 2 && PlayerPVP[killerid][Status] > 2) return FailPVP(playerid);

	if (JoinEvent[killerid] == EVENT_DM && JoinEvent[playerid] == EVENT_DM && DMTimeToEnd > 0)
	{//�������� � ��������
		new StringZ[140]; DMKills[killerid]++;
		format(StringZ, sizeof StringZ, "~Y~KILLS: ~W~%d", DMKills[killerid]);
		GameTextForPlayer(killerid, StringZ, 3000, 6);
		if (DMKills[killerid] > DMLeaderKills) {DMLeaderID = killerid; DMLeaderKills = DMKills[killerid];}
        QuestUpdate(killerid, 1, 1);//���������� ������ 40 ������� � ��
		return 1;
	}//�������� � ��������
	
	if (ZMStarted[killerid] == 1 && ZMIsPlayerIsZombie[playerid] > 0 && ZMIsPlayerIsZombie[killerid] == 0)
	{//�������� ��������� ����� �� ���������
	    if (ZMKillsXP[killerid] < 300)
	    {
			FarmedXP[killerid] += 15; ZMKillsXP[killerid] += 15; FarmedMoney[killerid] += 250;
			GameTextForPlayer(killerid, "~Y~+~W~15 ~Y~XP   +~W~250~Y~$", 3000, 6);
		}//�������� ������ ����� �������
		else
		{//��������� ����� �� �� �������� �����
		    FarmedMoney[killerid] += 250; GameTextForPlayer(killerid, "~Y~+~W~250~Y~$", 3000, 6);
		}//��������� ����� �� �� �������� �����
		QuestUpdate(killerid, 3, 1);//���������� ������ 15 ������� ����� � �����-���������
		return 1;
	}//�������� ��������� ����� �� ���������
	if (killerid != playerid && ZMIsPlayerIsZombie[killerid] == 0 && ZMIsPlayerIsZombie[playerid] == 0 && ZMStarted[killerid] == 1 && ZMStarted[playerid] == 1)
	{//������� �� �����-���������
		ZMStarted[killerid] = 0; ZMIsPlayerIsZombie[killerid] = 0; ZMIsPlayerIsTank[killerid] = 0;
		ResetPlayerWeapons(killerid);LSpawnPlayer(killerid);
		SendClientMessage(killerid,COLOR_RED,"�� ���� ��������� �� �����-��������� �� �������� ������ ����� �������");
		GangZoneHideForPlayer(killerid,ZMZone1);GangZoneHideForPlayer(killerid,ZMZone2);GangZoneHideForPlayer(killerid,ZMZone3);GangZoneHideForPlayer(killerid,ZMZone4);GangZoneHideForPlayer(killerid,ZMZone5);
		GangZoneHideForPlayer(killerid,ZMZone6);GangZoneHideForPlayer(killerid,ZMZone7);GangZoneHideForPlayer(killerid,ZMZone8);GangZoneHideForPlayer(killerid,ZMZone9);GangZoneHideForPlayer(killerid,ZMZone10);
	}//������� �� �����-���������
	if (InEvent[killerid] == EVENT_GUNGAME && InEvent[playerid] == EVENT_GUNGAME)
	{//�������� ������ � gg
	    new String[140], BonusXP, BonusCash;
		GGKills[killerid]++; GiveGGWeapon(killerid);
		format(String, sizeof String, "~Y~KILLS: ~W~%d", GGKills[killerid]);
		GameTextForPlayer(killerid, String, 3000, 6);
		QuestUpdate(killerid, 4, 1);//���������� ������ 15 ������� � ����� ����������
		if (GGKills[killerid] == 15)
		{//������ �������. ����� GunGame
		    format(String,sizeof(String),"%s[%d] ������� � ����� ���������� � ������� 800 XP � 25 000$",PlayerName[killerid], killerid);
			SendClientMessageToAll(COLOR_GG,String);
		    foreach(Player, did)
			{//����
				if(JoinEvent[did] == EVENT_GUNGAME)
				{
					InEvent[did] = 0; JoinEvent[did] = 0;
					if (GGKills[did] >= 15) {BonusXP = 800; BonusCash = 25000;}
					else {BonusXP = 80 + GGKills[did] * 40; BonusCash = GGKills[did] * 1000;}
					format(String,sizeof(String),"�� �������� %d �� � %d$ �� ������� � ����� ���������� (�������: %d).", BonusXP, BonusCash, GGKills[did]);
					SendClientMessage(did,COLOR_YELLOW,String); LSpawnPlayer(did);
					LGiveXP(did, BonusXP); Player[did][Cash] += BonusCash;
					QuestUpdate(did, 17, 1);//���������� ������ ������� ������� � 3 ������ ����������
					QuestUpdate(did, 18, 1);//���������� ������ ������� ������� � 5 �������������
				}
			}//����
			GGTimeToEnd = -1;
		}//������ �������. ����� GunGame
		return 1;
	}//�������� ������ � gg
	
	if (Player[killerid][MyClan] != 0 && Player[killerid][MyClan] == Player[playerid][MyClan]) return 1; //�������� ����������
	if (InEvent[playerid] > 0 || InEvent[killerid] > 0) return 1;
	QuestUpdate(killerid, 5, 1);//���������� ������ 5 ������� �� ��������� ������������

	//��������� �����
    new clanid = Player[playerid][MyClan], killerclanid = Player[killerid][MyClan], ChangeCarma = 1;
	if (clanid > 0 && clanid == killerclanid) return 1; //��� �������� ������� �� �������� ������ � �����
	if (clanid > 0 && killerclanid > 0  && (Clan[clanid][cEnemyClan] == killerclanid || Clan[killerclanid][cEnemyClan] == clanid)) ChangeCarma = 0; //�� ����� ����� �� �������
   	if (ChangeCarma == 1)
	{//���� ���� ������� �����
	    Player[killerid][Karma] -= 15; Player[killerid][KarmaTime] = 0; //����� ������� �� ��������� �����
		SendClientMessage(killerid,COLOR_RED,"�� �������� 15 ����� �����! ����� ����� ����� ������ � {FFFFFF}/karma");
		if (Player[killerid][Karma] <= -400 && Player[killerid][Invisible] > 0) {Player[killerid][Invisible] = 0; SendClientMessage(killerid,COLOR_RED,"����������� ���� ��������� ��-�� ������� ������ �����.");}
	}//���� ���� ������� �����

	//�������� �����
	if (Player[playerid][Cash] <= 0 || Player[playerid][Banned] != 0) return 1;
	if (InEvent[playerid] > 0) return 1;
	new GrabMoney, SaveMoney = 0, String[180];
	GrabMoney = Player[playerid][Cash] / 2;//�� ������ �������� 50% �� �����, ��������� ����� �������
	if (Player[playerid][GPremium] >= 13) SaveMoney = Player[playerid][Cash] / 4;//25% ����� �� ������� (����� vip 13)
	format(String, sizeof String, "�� �������� %d$ �� ������ �� ��� ������� ������!", Player[playerid][Cash] - SaveMoney);
	SendClientMessage(playerid, COLOR_RED, String);
	if (Player[playerid][Bank] == 0) SendClientMessage(playerid,COLOR_YELLOW,"������� ������ � �����... ����� ��� ����� ����� {FFFFFF}/gps");
	Player[playerid][Cash] = 0 + SaveMoney;

	if (GrabMoney > 0)
	{
	    new Float: DeathPosX, Float: DeathPosY, Float: DeathPosZ; GetPlayerPos(playerid, DeathPosX, DeathPosY, DeathPosZ);
		new CashPickup = CreateDynamicPickup(1550, 1, DeathPosX, DeathPosY, DeathPosZ, GetPlayerVirtualWorld(playerid), -1, -1, 300.0);
		DynamicPickup[CashPickup][Type] = 3;//��� ������ - ������
		DynamicPickup[CashPickup][ID] = GrabMoney;//����� �����
		DynamicPickup[CashPickup][DestroyTimerID] = SetTimerEx("DestroyCashPickup" , 60 * 1000, false, "i", CashPickup);

		format(String, sizeof String, "{FFFF00}SERVER: �� ������� ���� ������ {FFFFFF}%s{FFFF00}[{FFFFFF}%d{FFFF00}] ������ ������! ��������� ��!", PlayerName[playerid], playerid);
		SendClientMessage(killerid, COLOR_YELLOW, String);
		format(String, sizeof String, "%d.%d.%d � %d:%d:%d |   CASH: %s[%d] ���� ������ %s[%d]. �� ���� ������ %d$", Day, Month, Year, hour, minute, second, PlayerName[killerid], killerid, PlayerName[playerid], playerid, GrabMoney);
		WriteLog("GlobalLog", String); WriteLog("CashOperations", String);
	}
	
	return 1;
}//������ �� ��� ������ (������������� �� killerid)

public OnVehicleSpawn(vehicleid)
{
	if (vehicleid > MaxVehicleUsed) MaxVehicleUsed = vehicleid;//������������ � ������ ������ MAX_VEHICLES
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	DestroyVehicle(vehicleid);
	return 1;
}


public OnPlayerText(playerid, text[])
{
	//���� ����� ������� ������� �� � '/', � � '.' (������� ���������) - ��������� � �������
	if (text[0] == '.' || text[0] == '/') {text[0] = '/'; OnPlayerCommandText(playerid, text); return 0;}

	if (Logged[playerid] == 0){SendClientMessage(playerid,COLOR_RED, "������: ����� ������ � ��� ����� ����������������");return 0;}
	else if (Player[playerid][Muted] != 0)
	{//����
	    if (Player[playerid][Muted] == -1) SendClientMessage(playerid,COLOR_RED,"��� ��������� ������ � ���");
	    else
	    {
		    new StringM[100], hourM;
		    if (Player[playerid][Muted] >= 60){hourM = Player[playerid][Muted] / 60;format(StringM,sizeof(StringM),"��� ��������� ������ � ��� ��� %d ����� %d ������", hourM, Player[playerid][Muted] - hourM * 60);}
		    else{format(StringM,sizeof(StringM),"��� ��������� ������ � ��� ��� %d ������", Player[playerid][Muted]);}
		    SendClientMessage(playerid,COLOR_RED,StringM);
	    }
	    return 0;
	}//����

	new Name[30];GetPlayerName(playerid, Name, MAX_PLAYER_NAME);
	new itext[300], Need60Sec = 0, NeedMute = 0;strcat(itext,text);

	//--- ����� � ������
	new count, AntiCaps = 0;
	for (new i; i < strlen(itext); i++)
	{
	    if (itext[i] >= '0' && itext[i] <= '9')
	    {
	        count++;
	        if(count > 5) {SendClientMessage(playerid,COLOR_RED,"������: ��������� �� ������ ��������� ������ 5 ����!"); return 0;}
	    }

	    //AntiCapsLock
	    if (itext[i] > 64 && itext[i] < 91 && AntiCaps == 0) AntiCaps = 1; //eng
	    if (itext[i] > 191 && itext[i] < 224 && AntiCaps == 0) AntiCaps = 1;//rus
	    if(itext[i] == 168 && AntiCaps == 0) AntiCaps = 1;//�
	    if (itext[i] == ':' && itext[i++] == 'D') AntiCaps = 0;//�������� ������ ':D'
	    //���������� ��� �������� ���������, ��� ������ � ������� ��������
	    if (AntiCaps == 1)
	    {//���� ������ � ������� ��������
	        if (itext[i++] > 64 && itext[i++] < 91) AntiCaps = 2; //���� ��� ������� ������ � ������� �������� eng
		    if (itext[i] > 191 && itext[i] < 224) AntiCaps = 2; //���� ��� ������� ������ � ������� �������� rus
		    if(itext[i++] == 168) AntiCaps = 184; //���� ��� ������� ������ � ������� �������� �
		    if (AntiCaps == 1) AntiCaps = 0;//���� ������ ������ ��� ��������� (�������� "�����")
	    }//���� ������ � ������� ��������
	}//--- ����� � ������

	if (AntiCaps == 2)
	{//���� ��� ������� ������ ���� �������� � ������� ��������
	    for (new i; i < strlen(itext); i++)
		{
			if (itext[i] > 64 && itext[i] < 91) itext[i] += 32; //eng
			if (itext[i] > 191 && itext[i] < 224) itext[i] += 32;//rus
			if(itext[i] == 168) itext[i] = 184;//�
		}
	}//���� ��� ������� ������ ���� �������� � ������� ��������

	//--- ������ �� �����
	if (FloodTime[playerid] == 0) {FloodTime[playerid] = 15; FloodMessages[playerid] = 1;}
	else FloodMessages[playerid] += 1;
	if (FloodMessages[playerid] >= 3 && FloodTime[playerid] > 12) NeedMute = 1; //3 ��������� ��� ����� �� 3 �������
	else if (FloodMessages[playerid] >= 4 && FloodTime[playerid] > 7) NeedMute = 1; //4 ��������� ��� ����� �� 8 ������
	else if (FloodMessages[playerid] >= 5 && FloodTime[playerid] > 3) NeedMute = 1; //5 ��������� ��� ����� �� 12 ������
	else if (FloodMessages[playerid] >= 6) NeedMute = 1; //6 ��������� ��� ����� �� 15 ������
	//--- ������ �� �����

	if(strfind(text, "!", true) == 0)
	{//�����
		if (Player[playerid][Member] == 0){SendClientMessage(playerid,COLOR_RED,"������: �� �� � �����."); return 0;}
		strdel(text, 0, 1);new stext[300],clanid = Player[playerid][MyClan], ccolor = Clan[clanid][cColor];
		format(stext, 300, "! [�����]%s[%d]:{FFFFFF} %s", Name, playerid, text);
		foreach(Player, cid) if (Player[cid][MyClan] == Player[playerid][MyClan] && Logged[cid] == 1){SendClientMessage(cid, ClanColor[ccolor], stext);}
		if (NeedMute == 1)
		{//���� ������ ��� �� ����
		    Player[playerid][Muted] = 1200; strmid(MutedBy[playerid], "SERVER", 0, 25, 25);
			FloodTime[playerid] = 0;FloodMessages[playerid] = 0;
		    new String[140];
			format(String,sizeof(String), "{AFAFAF}SERVER %s ��� ������������� ������� �� 20 �����. �������: ����", PlayerName[playerid]);
			SendClientMessageToAll(COLOR_GREY,String);
		}//���� ������ ��� �� ����
		//������ � ���. �������� WriteLog("����", "������ ���!"); ������� � ��� "����.ini" ����� "������ ���!"
        format(text, 300, "%d.%d.%d � %d:%d:%d |   [�����]%s[%d]: %s", Day, Month, Year, hour, minute, second, Name, playerid, text);WriteLog("GlobalLog", text);
		return 0;
	}//�����

	if(strfind(text, "#", true) == 0 || strfind(text, "�", true) == 0)
	{//�����
	    if (LSpecID[playerid] != -1 && Player[playerid][Admin] < 1){SendClientMessage(playerid,COLOR_RED,"������: ������ ���������� � ���� ����� ������ ������� � ������ ������."); return 0;}
		new Float: sx, Float: sy, Float: sz;strdel(text, 0, 1);
		new stext[300];format(stext, 300, "{B5BBFD}# [�������]%s[{FFFFFF}%d{B5BBFD}]: {FFFFFF}%s", Name, playerid, text);
		GetPlayerPos(playerid,sx,sy,sz);
		foreach(Player, cid) if (PlayerToPoint(50.0, cid, sx, sy, sz) && GetPlayerVirtualWorld(cid) == GetPlayerVirtualWorld(playerid)) SendClientMessage(cid, -1, stext);
        if (NeedMute == 1)
		{//���� ������ ��� �� ����
		    Player[playerid][Muted] = 1200;FloodTime[playerid] = 0;FloodMessages[playerid] = 0;
		    new CheaterName[30], String[140];CheaterName = GetName(playerid);
			format(String,sizeof(String), "{AFAFAF}SERVER %s ��� ������������� ������� �� 20 �����. �������: ����",CheaterName);
			SendClientMessageToAll(COLOR_GREY,String); strmid(MutedBy[playerid], "SERVER", 0, 25, 25);
		}//���� ������ ��� �� ����
		//������ � ���. �������� WriteLog("����", "������ ���!"); ������� � ��� "����.ini" ����� "������ ���!"
        format(text, 300, "%d.%d.%d � %d:%d:%d |   [�������]%s[%d]: %s", Day, Month, Year, hour, minute, second, Name, playerid, text);WriteLog("GlobalLog", text);
		return 0;
	}//�����
	
	if(strfind(text, "@", true) == 0 || text[0] == 34)
	{//�������
		strdel(text, 0, 1);new stext[300];format(stext, 300, "{00BFFF}@ [�������]%s[{FFFFFF}%d{00BFFF}]: {FFFFFF}%s", Name, playerid, text);
		if (Player[playerid][Admin] == 0){SendClientMessage(playerid,COLOR_ADMIN,"���� ��������� ���������� ���������������");}
		foreach(Player, cid) if (Player[cid][Admin] != 0 && Logged[cid] == 1){SendClientMessage(cid, -1, stext);}
        if (NeedMute == 1)
		{//���� ������ ��� �� ����
		    Player[playerid][Muted] = 1200;FloodTime[playerid] = 0;FloodMessages[playerid] = 0;
		    new CheaterName[30], String[140];CheaterName = GetName(playerid);
			format(String,sizeof(String), "{AFAFAF}SERVER %s ��� ������������� ������� �� 20 �����. �������: ����",CheaterName);
			SendClientMessageToAll(COLOR_GREY,String); strmid(MutedBy[playerid], "SERVER", 0, 25, 25);
		}//���� ������ ��� �� ����
		//������ � ���. �������� WriteLog("����", "������ ���!"); ������� � ��� "����.ini" ����� "������ ���!"
        format(text, 300, "%d.%d.%d � %d:%d:%d |   [�������]%s[%d]: %s", Day, Month, Year, hour, minute, second, Name, playerid, text);WriteLog("GlobalLog", text);
		return 0;
	}//�������

	if (Player[playerid][GPremium] >= 2)
	{//--- ������������ ���
		for(new i = 0; i < 300; i++)
		{//����
			if(strfind(itext, "*", true) == i)
			{//���� ����� "*" � ������
				if (PremiumTime[playerid] > 0)
				{
						new string[120];
						format(string, sizeof(string), "{FF0000}������������ ��������� ����� �������� ����� {FFFFFF}%d{FF0000} ������.", PremiumTime[playerid]);
						SendClientMessage(playerid,COLOR_RED,string); break;
				}
				if (Player[playerid][Admin] < 4) Need60Sec = 1;

			    if (strfind(itext, "1", true) == i + 1)
			    {// *1 - �������
					strdel(itext, i, i + 2);//��������� ��� �����
					strins(itext, "{FF0000}", i, 300);continue;
			    }// *1 - �������
			    if (strfind(itext, "2", true) == i + 1)
			    {// *2 - �����
					strdel(itext, i, i + 2);//��������� ��� �����
					strins(itext, "{3399FF}", i, 300);continue;
			    }// *2 - �����
			    if (strfind(itext, "3", true) == i + 1)
			    {// *3 - �������
					strdel(itext, i, i + 2);//��������� ��� �����
					strins(itext, "{00FF00}", i, 300);continue;
			    }// *3 - �������
			    if (strfind(itext, "4", true) == i + 1)
			    {// *4 - ������
					strdel(itext, i, i + 2);//��������� ��� �����
					strins(itext, "{FFFF00}", i, 300);continue;
			    }// *4 - ������
			    if (strfind(itext, "5", true) == i + 1)
			    {// *5 - ����
					strdel(itext, i, i + 2);//��������� ��� �����
					strins(itext, "{CCFF00}", i, 300);continue;
			    }// *5 - ����
			    if (strfind(itext, "6", true) == i + 1)
			    {// *6 - ����
					strdel(itext, i, i + 2);//��������� ��� �����
					strins(itext, "{24F7FE}", i, 300);continue;
			    }// *6 - ����
			    if (strfind(itext, "7", true) == i + 1)
			    {// *7 - �������
					strdel(itext, i, i + 2);//��������� ��� �����
					strins(itext, "{F935F9}", i, 300);continue;
			    }// *7 - �������
			    if (strfind(itext, "8", true) == i + 1)
			    {// *8 - �����
					strdel(itext, i, i + 2);//��������� ��� �����
					strins(itext, "{FFCC00}", i, 300);continue;
			    }// *8 - �����
			    if (strfind(itext, "9", true) == i + 1)
			    {// *9 - ����������
					strdel(itext, i, i + 2);//��������� ��� �����
					strins(itext, "{976D3D}", i, 300);continue;
			    }// *9 - ����������

				if (strfind(itext, "!", true) == i + 1 && strfind(itext, "1", true) == i + 2)
			    {// **1 - ��
					strdel(itext, i, i + 3);//��������� ��� �����
					strins(itext, "{FF8C00}", i, 300);continue;
			    }// **1 - ��, ���
			    if (strfind(itext, "!", true) == i + 1 && strfind(itext, "2", true) == i + 2)
			    {// **2 - �����
					strdel(itext, i, i + 3);//��������� ��� �����
					strins(itext, "{9966CC}", i, 300);continue;
			    }// **2 - �����
			    if (strfind(itext, "!", true) == i + 1 && strfind(itext, "3", true) == i + 2)
			    {// **3 - �����
					strdel(itext, i, i + 3);//��������� ��� �����
					strins(itext, "{E60020}", i, 300);continue;
			    }// **3 - �����
			    if (strfind(itext, "!", true) == i + 1 && strfind(itext, "4", true) == i + 2)
			    {// **4 - �����
					strdel(itext, i, i + 3);//��������� ��� �����
					strins(itext, "{007FFF}", i, 300);continue;
			    }// **4 - �����
			    if (strfind(itext, "!", true) == i + 1 && strfind(itext, "5", true) == i + 2)
			    {// **5 - ����������� �����
					strdel(itext, i, i + 3);//��������� ��� �����
					strins(itext, "{FFD700}", i, 300);continue;
			    }// **5 - ����������� �����
			    if (strfind(itext, "!", true) == i + 1 && strfind(itext, "6", true) == i + 2)
			    {// **6 - �������
					strdel(itext, i, i + 3);//��������� ��� �����
					strins(itext, "{FF6666}", i, 300);continue;
			    }// **6 - �������

			    if (strfind(itext, "?", true) == i + 1 || strfind(itext, "&", true) == i + 1)
			    {// *? - ���������
					strdel(itext, i, i + 2);//��������� ��� �����
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
			    }// *? - ���������

				//���� �� ��� ������ �� ���� �� ����� ���� (������ * � �������)
				strdel(itext, i, i + 1);//��������� ��� �����
				strins(itext, "{FFFFFF}", i, 300);//�����
			}//���� ����� "*" � ������
		}//����
	}//--- ������������ ���
	
	format(itext, 300, "%s{FFFFFF}[%d]: %s", ChatName[playerid], playerid, itext);
	new colorid = PlayerColor[playerid], clanid = Player[playerid][MyClan];
	if (clanid < 1 || Clan[clanid][cBase] < 1) colorid = 0; //���� ����� �� � ����� ��� ���� � ����� ��� ����� - ���� ���� ����� �����
	SendClientMessageToAll(ClanColor[colorid], itext);
	
	if (Need60Sec == 1){PremiumTime[playerid] = 60;Need60Sec = 0;}
	if (NeedMute == 1)
	{//���� ������ ��� �� ����
	    Player[playerid][Muted] = 1200;FloodTime[playerid] = 0;FloodMessages[playerid] = 0;
	    new CheaterName[30], String[140];CheaterName = GetName(playerid);
		format(String,sizeof(String), "{AFAFAF}SERVER %s ��� ������������� ������� �� 20 �����. �������: ����",CheaterName);
		SendClientMessageToAll(COLOR_GREY,String); strmid(MutedBy[playerid], "SERVER", 0, 25, 25); return 0;
	}//���� ������ ��� �� ����
	//������ � ���. �������� WriteLog("����", "������ ���!"); ������� � ��� "����.ini" ����� "������ ���!"
	format(text, 300, "%d.%d.%d � %d:%d:%d |   %s[%d]: %s", Day, Month, Year, hour, minute, second, Name, playerid, text);WriteLog("GlobalLog", text);
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    if (OnFly[playerid] == 1) StopFly(playerid);
    
    if (ispassenger == 0)
    {//������� �� ������������ �������
        foreach(Player, cid)
        {
            if (IsPlayerInVehicle(cid, vehicleid) && GetPlayerVehicleSeat(cid) == 0)
            {//���-�� ��� ����� �� �����
                SetVehicleParamsForPlayer(vehicleid, playerid, 0, 1);SetVehicleParamsForPlayer(vehicleid, cid, 0, 1);
				SetTimerEx("UnLock" , 5000, false, "dd", playerid,vehicleid);SetTimerEx("UnLock" , 5000, false, "dd", cid,vehicleid);
				SendClientMessage(playerid,COLOR_RED,"������ �������� ��������� � ������ �������! ������� {FFFFFF}Alt{FF0000} ����� ������� ����!");
            }//���-�� ��� ����� �� �����
        }
    }//������� �� ������������ �������
    
    for(new vid = 1; vid <= 35; vid++)
	{//���� ���� - �������� ���������
	    if (vehicleid == StealCar[vid])
	    {//���� ����� �������� � ����, ������� ���� ������
	        StealCarModel[playerid] = GetVehicleModel(vehicleid);
	        if (vid <= 25)
	        {//�������� ����
				new qcol1, qcol2, qmodel = GetVehicleModel(StealCar[vid]);GetVehicleColor(StealCar[vid],qcol1,qcol2);
				new Float: qx, Float: qy, Float: qz, Float: qa;GetVehiclePos(StealCar[vid],qx,qy,qz);GetVehicleZAngle(StealCar[vid], qa);
				DestroyVehicle(StealCar[vid]);DestroyDynamicMapIcon(StealCarMapIcon[vid]);

				//������������ ���� ���� � ������ �����
				new rrand1 = random(sizeof(CarStealSpawns)), rcol1 = random(256), rcol2 = random(256), rmodeld = random(133); new rmodel = StealCars[rmodeld];
				StealCar[vid] = LCreateVehicle(rmodel, CarStealSpawns[rrand1][0], CarStealSpawns[rrand1][1], CarStealSpawns[rrand1][2], CarStealSpawns[rrand1][3], rcol1, rcol2, 0);
	  		 	StealCarMapIcon[vid] = CreateDynamicMapIcon(CarStealSpawns[rrand1][0], CarStealSpawns[rrand1][1], CarStealSpawns[rrand1][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);

				//���� ��� ������ ��� ���������� �������
				if (QuestActive[playerid] > 0) return SendClientMessage(playerid, COLOR_RED, "������: ������ ������� ��������� �� ����� ���������� ������!");
				QuestCar[playerid] = LCreateVehicle(qmodel, qx, qy, qz, qa, qcol1, qcol2, 0);
				PutPlayerInVehicle(playerid, QuestCar[playerid], 0); PlayerCarID[playerid] = -1;

		        new modelid = qmodel - 400, String[120];
				format(String,sizeof(String),"{AFAFAF}���������: {FFCC00}%s{AFAFAF} ���������: %d$",PlayerVehicleName[modelid], GetVehicleMaxSpeed(QuestCar[playerid]) * 500);
		        ShowPlayerDialog(playerid, DIALOG_STEALCAR, 2, String, "{FFCC00}������ ���������{FFFFFF}\n������� ������ ����������� {007FFF}1{FFFFFF}-�� ������\n������� ������ ����������� {007FFF}2{FFFFFF}-�� ������\n{FF0000}�������� ���������", "������", "������");
			}//�������� ����
			else if (vid <= 30)
			{//������ ����
			    new qcol1, qcol2, qmodel = GetVehicleModel(StealCar[vid]);GetVehicleColor(StealCar[vid],qcol1,qcol2);
				new Float: qx, Float: qy, Float: qz, Float: qa;GetVehiclePos(StealCar[vid],qx,qy,qz);GetVehicleZAngle(StealCar[vid], qa);
				DestroyVehicle(StealCar[vid]);DestroyDynamicMapIcon(StealCarMapIcon[vid]);

				//������������ ���� ���� � ������ �����
				new rrand1 = random(sizeof(CarStealWaterSpawns)), rcol1 = random(256), rcol2 = random(256), rmodeld = random(11); new rmodel = StealWaterCars[rmodeld];
				StealCar[vid] = LCreateVehicle(rmodel, CarStealWaterSpawns[rrand1][0], CarStealWaterSpawns[rrand1][1], CarStealWaterSpawns[rrand1][2], CarStealWaterSpawns[rrand1][3], rcol1, rcol2, 0);
	  		 	StealCarMapIcon[vid] = CreateDynamicMapIcon(CarStealWaterSpawns[rrand1][0], CarStealWaterSpawns[rrand1][1], CarStealWaterSpawns[rrand1][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);

				//���� ��� ������ ��� ���������� �������
				if (QuestActive[playerid] > 0) return SendClientMessage(playerid, COLOR_RED, "������: ������ ������� ��������� �� ����� ���������� ������!");
				QuestCar[playerid] = LCreateVehicle(qmodel, qx, qy, qz, qa, qcol1, qcol2, 0);
				PutPlayerInVehicle(playerid, QuestCar[playerid], 0); PlayerCarID[playerid] = -1;

		        new modelid = qmodel - 400, String[120];
				format(String,sizeof(String),"{AFAFAF}���������: {FFCC00}%s{AFAFAF} ���������: %d$",PlayerVehicleName[modelid], GetVehicleMaxSpeed(QuestCar[playerid]) * 500);
		        ShowPlayerDialog(playerid, DIALOG_STEALWATERCAR, 2, String, "{FFCC00}������ ���������{FFFFFF}\n������� ������ ����������� {007FFF}3{FFFFFF}-�� ������\n{FF0000}�������� ���������", "������", "������");
			}//������ ����
			else if (vid <= 35)
			{//��������� ����
			    new qcol1, qcol2, qmodel = GetVehicleModel(StealCar[vid]);GetVehicleColor(StealCar[vid],qcol1,qcol2);
				new Float: qx, Float: qy, Float: qz, Float: qa;GetVehiclePos(StealCar[vid],qx,qy,qz);GetVehicleZAngle(StealCar[vid], qa);
				DestroyVehicle(StealCar[vid]);DestroyDynamicMapIcon(StealCarMapIcon[vid]);

				//������������ ���� ���� � ������ �����
				new rrand1 = random(sizeof(CarStealAirSpawns)), rcol1 = random(256), rcol2 = random(256), rmodeld = random(13); new rmodel = StealAirCars[rmodeld];
				StealCar[vid] = LCreateVehicle(rmodel, CarStealAirSpawns[rrand1][0], CarStealAirSpawns[rrand1][1], CarStealAirSpawns[rrand1][2], CarStealAirSpawns[rrand1][3], rcol1, rcol2, 0);
	  		 	StealCarMapIcon[vid] = CreateDynamicMapIcon(CarStealAirSpawns[rrand1][0], CarStealAirSpawns[rrand1][1], CarStealAirSpawns[rrand1][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);

				//���� ��� ������ ��� ���������� �������
				if (QuestActive[playerid] > 0) return SendClientMessage(playerid, COLOR_RED, "������: ������ ������� ��������� �� ����� ���������� ������!");
				QuestCar[playerid] = LCreateVehicle(qmodel, qx, qy, qz, qa, qcol1, qcol2, 0);
				PutPlayerInVehicle(playerid, QuestCar[playerid], 0); PlayerCarID[playerid] = -1;

		        new modelid = qmodel - 400, String[120];
				format(String,sizeof(String),"{AFAFAF}���������: {FFCC00}%s{AFAFAF} ���������: %d$",PlayerVehicleName[modelid], GetVehicleMaxSpeed(QuestCar[playerid]) * 2000);
		        ShowPlayerDialog(playerid, DIALOG_STEALAIRCAR, 2, String, "{FFCC00}������ ���������{FFFFFF}\n������� ������ ����������� {007FFF}3{FFFFFF}-�� ������\n{FF0000}�������� ���������", "������", "������");
			}//��������� ����
		}//���� ����� �������� � ����, ������� ���� ������
	}//���� ���� - �������� ���������
    
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
    if (Player[playerid][Level] == 0)
	{//����� ����� �� ������ � ������ ��������.
	    if (TutorialObject[playerid] != -1){DestroyObject(TutorialObject[playerid]);TutorialObject[playerid] = -1;}
	    TutorialObject[playerid] = CreateObject(19482, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    	SetObjectMaterialText(TutorialObject[playerid], "{FFFF00}��������\n{FFFFFF}������� {00FF00}Alt", 0, OBJECT_MATERIAL_SIZE_512x512, "Tahoma", 50, 1, 0xFFFFFFFF, 0x00, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
        AttachObjectToPlayer(TutorialObject[playerid], playerid, 0, 0, 1.2, 0, 0, 270);
	}//����� ����� �� ������ � ������ ��������.
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    if ((oldstate != 1 && newstate == 1) && (JoinEvent[playerid] == EVENT_RACE || JoinEvent[playerid] == EVENT_XRACE)) return SendClientMessage(playerid,COLOR_CYAN,"���������: ������� ������� {FFFFFF}Alt{00CCCC} ����� ������� ��������� � �����.");
	if (LSpectators[playerid] > 0) {SpecUpdate(playerid);}//���������� ������� � ���, ��� �� ������� ������
    if (oldstate == PLAYER_STATE_DRIVER) Player[playerid][CarActive] = 0; //���������� ����������� ������������� ������� ����� ������ �� ������ ����
 
	if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
    {//������ ��������� ������������ ������ ���, �������� � ����������
        new Weap[2];
        GetPlayerWeaponData(playerid, 4, Weap[0], Weap[1]); // Get the players SMG weapon in slot 4
        SetPlayerArmedWeapon(playerid, Weap[0]); // Set the player to driveby with SMG
        SetTimerEx("SpeedoUpdate" , 500, false, "i", playerid);//�������� ���������
    }//������ ��������� ������������ ������ ���, �������� � ����������
    
	if ((newstate == 0) && Player[playerid][Level] == 0)
	{//����� ����� �� ������ � ������ ��������.
	    if (TutorialObject[playerid] != -1){DestroyObject(TutorialObject[playerid]);TutorialObject[playerid] = -1;}
	    TutorialObject[playerid] = CreateObject(19482, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    	SetObjectMaterialText(TutorialObject[playerid], "{FFFF00}��������\n{FFFFFF}������� {00FF00}Alt", 0, OBJECT_MATERIAL_SIZE_512x512, "Tahoma", 50, 1, 0xFFFFFFFF, 0x00, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
        AttachObjectToPlayer(TutorialObject[playerid], playerid, 0, 0, 1.2, 0, 0, 270);
	}//����� ����� �� ������ � ������ ��������.

	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	if (GPSUsed[playerid] == 1)
	{//GPS ��������
	    DisablePlayerCheckpoint(playerid); GPSUsed[playerid] = 0; PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
	    return SendClientMessage(playerid, COLOR_RED, "GPS:{FFFF00} �� �������� ����� ����������.");
	}//GPS ��������

	if (FRTimer <= -1 && FRStarted[playerid] == 1)
	{//�������� ������ �����
		new String[140];FarmedXP[playerid] = 200 + 35 * (FRPlayers-1); FarmedMoney[playerid] = 2500 + 500 * (FRPlayers-1);FRpos += 1;
		if (FRpos == 1){FarmedXP[playerid] += 200;format(String,sizeof(String),"%s[%d] ������� ����� � ������� %d XP � %d$",PlayerName[playerid],playerid,FarmedXP[playerid],FarmedMoney[playerid]);SendClientMessageToAll(COLOR_RACE,String);}
		if (FRpos == 2){FarmedXP[playerid] += 130;format(String,sizeof(String),"%s[%d] ����������� ������ � ����� � ������� %d XP � %d$",PlayerName[playerid],playerid,FarmedXP[playerid],FarmedMoney[playerid]);SendClientMessageToAll(COLOR_RACE,String);}
		if (FRpos == 3){FarmedXP[playerid] += 65;format(String,sizeof(String),"%s[%d] ����������� ������� � ����� � ������� %d XP � %d$",PlayerName[playerid],playerid,FarmedXP[playerid],FarmedMoney[playerid]);SendClientMessageToAll(COLOR_RACE,String);}
		if (FRpos > 3)
		{
			//FarmedXP[playerid] = 200; FarmedMoney[playerid] = 2500;
			format(String,sizeof(String),"�� ������������ %d-�� � �������� %d XP � %d$",FRpos,FarmedXP[playerid],FarmedMoney[playerid]);SendClientMessage(playerid,COLOR_RACE,String);
		}
		FRPlayers -= 1;Player[playerid][Cash] += FarmedMoney[playerid]; LGiveXP(playerid, FarmedXP[playerid]);
		FRStarted[playerid] = 0; JoinEvent[playerid] = 0; InEvent[playerid] = 0;
		DestroyVehicle(FRCarID[playerid]); FRCarID[playerid] = 0;
		SetPlayerVirtualWorld(playerid,0);DisablePlayerCheckpoint(playerid);LSpawnPlayer(playerid);
		PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
		QuestUpdate(playerid, 14, 1);//���������� ������ ������� ������� � 3 ������
		QuestUpdate(playerid, 18, 1);//���������� ������ ������� ������� � 3 �������������
		return 1;
	}//�������� ������ �����
	
	if (QuestActive[playerid] == 3 && InEvent[playerid] == 0)
	{//�������
		if(GetPVarInt(playerid,"WorkStage") == 1)// ���� ������ ������ ������ 1..
	    {//��� ����
	    	new checku = random(sizeof GRUZTO);// �������� ����� ���������� ���� ����� ����
	        SetPlayerCheckpoint(playerid,GRUZTO[checku][0],GRUZTO[checku][1],GRUZTO[checku][2],1.5);// ������ ���� �� ����������
	        ApplyAnimation(playerid,"CARRY","crry_prtial",4.1,0,1,1,1,1);// ��������, ���� ��� �� ����..
	        SetPVarInt(playerid,"WorkStage",2);// ������������� ������ ������ ������ �� 2..
	        new objectr = random(3);// ����� � ���� ������
	        if(objectr == 0) return SetPlayerAttachedObject(playerid,0,1221,1,0.135011,0.463495,-0.024351,357.460632,87.350753,88.068374,0.434164,0.491270,0.368655);
	        if(objectr == 1) return SetPlayerAttachedObject(playerid,0,2226,1,0.000708,0.356461,0.000000,186.670364,87.529838,0.000000,1.000000,1.000000,1.000000);
	        if(objectr == 2) return SetPlayerAttachedObject(playerid,0,1750,1,0.013829,0.131155,0.145773,185.651550,86.201354,345.922180,0.693442,0.873942,0.577291);
	    }//��� ����
	    if(GetPVarInt(playerid,"WorkStage") == 2)
	    {//����� ����
	        new checkp = random(sizeof GRUZFROM); WorkTimeGruz[playerid] = 0;
	        SetPlayerCheckpoint(playerid,GRUZFROM[checkp][0],GRUZFROM[checkp][1],GRUZFROM[checkp][2],1.5);// ������ ���� �� ����������
	        RemovePlayerAttachedObject(playerid,0);// ������� ������ �� ���
	        ApplyAnimation(playerid,"PED","IDLE_tired",4.1,0,1,1,0,1);// �������� ��������
	        SetPVarInt(playerid,"WorkStage",1);// ������������� ������ ������ ������ �� 1..
	        SetPVarInt(playerid,"WorkCount",GetPVarInt(playerid,"WorkCount")+1);// �������� � ����� ������ 1
	 		if (GetPVarInt(playerid,"WorkCount") == 10)
	 		{//������� 10 ������
	 		    new str[128], wxp = WorkTime[playerid] * 3/4, wcash = WorkTime[playerid] * 30;
	 		    SetPVarInt(playerid,"WorkCount", 0); WorkTime[playerid] = 0;
		        format(str,sizeof(str),"������: �� �������� %d XP � %d$ �� ������� 10 ������.", wxp, wcash);
		        SendClientMessage(playerid,COLOR_QUEST, str); LGiveXP(playerid, wxp); Player[playerid][Cash] += wcash;
		        PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
	        }//������� 10 ������
	    }//����� ����
    }//�������
    
    if (QuestActive[playerid] == 4 && InEvent[playerid] == 0)
    {//��������
        if (GetPVarInt(playerid, "WorkDomStage") == 1)
        {//������� � ����, ������� ����� ���������
            SetPlayerAttachedObject(playerid,0,3026,1,-0.176000, -0.066000, 0.0000,0.0000, 0.0000, 0.0000, 1.07600, 1.079999, 1.029000);//������ � ��������
			SetPVarInt(playerid, "WorkDomStage", 2); SetPlayerCheckpoint(playerid, -1945.5354, -1085.3024, 30.8479, 8.0);
			return SendClientMessage(playerid,COLOR_QUEST, "������: �� �������� ���! ���� ������������ � {FF0000}��������{FFCC00}.");
        }//������� � ����, ������� ����� ���������
        if (GetPVarInt(playerid, "WorkDomStage") == 2)
        {//������ ����� � ��������
            RemovePlayerAttachedObject(playerid,0);// ������� ������ � ��������
            new String[120], wxp, wcash; //�������� � ���: 2880 xp � 360 000$ => � �������: 4/5xp � 100$
			if (WorkTime[playerid] <= 720) {wxp = WorkTime[playerid] * 4/5; wcash = WorkTime[playerid] * 100;}
			else {wxp = 576; wcash = 36000;}//�� ����� 12 ����� �� ���� �����. ���� ������ - ������ �� �� 12 ����� � ����� ������ �����
			format(String, sizeof String, "������: �� �������� %d XP � %d$ �� ���� �������� �����.", wxp, wcash);
			SendClientMessage(playerid, COLOR_QUEST, String); LGiveXP(playerid, wxp); Player[playerid][Cash] += wcash;
			PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
            //���� ������ ����� �����
            new rand = random(MAX_PROPERTY); if (rand == 0) rand++;//�������� ��� ��� ����������
            if (rand == Player[playerid][Home]) {if (rand > 1) rand--; else rand++;}//�������� ��� ��������� - ����������
            SetPVarInt(playerid, "WorkDomStage", 1); WorkTime[playerid] = 0;
            if (QuestCar[playerid] != -1) {RepairVehicle(QuestCar[playerid]); SetVehicleZAngle(QuestCar[playerid], 0); SetPlayerChatBubble(playerid, "��������� ��������������", COLOR_GREEN, 300.0, 3000);}
			SendClientMessage(playerid, COLOR_QUEST, "������: ������� {FF0000}���{FFCC00} � ������� ������������ ����!");
            SetPlayerCheckpoint(playerid,Property[rand][pPosEnterX],Property[rand][pPosEnterY],Property[rand][pPosEnterZ],2);
        }//������ ����� � ��������
    }//��������
    
    if (QuestActive[playerid] == 6 && InEvent[playerid] == 0)
    {//������������
        if (GetPVarInt(playerid, "WorkTruckStage") == 1)
        {//�������� ����
            new vehicleid = GetPlayerVehicleID(playerid);
            if (TrailerID[vehicleid] > -1) {DestroyVehicle(TrailerID[vehicleid]); TrailerID[vehicleid] = -1;}//������� ������� � ����
			SetPVarInt(playerid, "WorkTruckStage", 2); SetPlayerCheckpoint(playerid, 2453.7183, -2089.3940, 14.5622, 8.0);
			return SendClientMessage(playerid,COLOR_QUEST, "������: �� �������� ����. ����������� �� {FF0000}���������{FFCC00}.");
        }//�������� ����
        if (GetPVarInt(playerid, "WorkTruckStage") == 2)
        {//������� �� ���������
            new String[120], wxp, wcash; // 3420xp/���   540 000$/���   19/20�� � �������   150$ � �������
			if (WorkTime[playerid] <= 720) {wxp = WorkTime[playerid] * 19/20; wcash = WorkTime[playerid] * 150;}
			else {wxp = 684; wcash = 54000;}//�� ����� 12 ����� �� ���� �����. ���� ������ - ������ �� �� 12 ����� � ����� ������ �����
			format(String, sizeof String, "������: �� �������� %d XP � %d$ �� �������� �����.", wxp, wcash);
			SendClientMessage(playerid, COLOR_QUEST, String); LGiveXP(playerid, wxp); Player[playerid][Cash] += wcash;
			PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
            //���� ������ ����� �����
            if (QuestCar[playerid] != -1) {SetVehicleZAngle(QuestCar[playerid], 90); CallTrailer(QuestCar[playerid], 584); RepairVehicle(QuestCar[playerid]); SetPlayerChatBubble(playerid, "��������� ��������������", COLOR_GREEN, 300.0, 3000);}
            SetPVarInt(playerid, "WorkTruckStage", 1); WorkTime[playerid] = 0;
            new rand = random(sizeof WORKTRUCK);//�������� ����� �������� �����
            SetPlayerCheckpoint(playerid,WORKTRUCK[rand][0], WORKTRUCK[rand][1], WORKTRUCK[rand][2], 10);
			SendClientMessage(playerid, COLOR_QUEST, "������: ������� ���� �� {FF0000}����� ����������{FFCC00} � ������� �� ���������!");
        }//������� �� ���������
    }//������������
    
    if (QuestActive[playerid] == 7 && InEvent[playerid] == 0)
    {//������� �������
        if (GetPVarInt(playerid, "WorkWaterStage") == 1)
        {//�������� ����
 			SetPVarInt(playerid, "WorkWaterStage", 2); SetPlayerCheckpoint(playerid, -1759.8169,-192.7360,0.0, 8.0);
			return SendClientMessage(playerid,COLOR_QUEST, "������: �� �������� ����. ����������� �� {FF0000}���������{FFCC00}.");
        }//�������� ����
        if (GetPVarInt(playerid, "WorkWaterStage") == 2)
        {//������� �� ���������
            new String[120], wxp, wcash; // 3600xp/���   396 000$/���   1�� � �������   110$ � �������
			if (WorkTime[playerid] <= 480) {wxp = WorkTime[playerid]; wcash = WorkTime[playerid] * 110;}
			else {wxp = 480; wcash = 26400;}//�� ����� 12 ����� �� ���� �����. ���� ������ - ������ �� �� 12 ����� � ����� ������ �����
			format(String, sizeof String, "������: �� �������� %d XP � %d$ �� �������� �����.", wxp, wcash);
			SendClientMessage(playerid, COLOR_QUEST, String); LGiveXP(playerid, wxp); Player[playerid][Cash] += wcash;
			PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
            //���� ������ ����� �����
		    if (QuestCar[playerid] != -1) {SetVehicleZAngle(QuestCar[playerid], 270); RepairVehicle(QuestCar[playerid]); SetPlayerChatBubble(playerid, "��������� ��������������", COLOR_GREEN, 300.0, 3000);}
            SetPVarInt(playerid, "WorkWaterStage", 1); WorkTime[playerid] = 0;
			new rand = random(sizeof WORKWATER);//�������� ����� �������� �����
            SetPlayerCheckpoint(playerid,WORKWATER[rand][0], WORKWATER[rand][1], WORKWATER[rand][2], 10);
			SendClientMessage(playerid, COLOR_QUEST, "������: ������� ���� �� {FF0000}����� ����������{FFCC00} � ������� �� ���������!");
        }//������� �� ���������
    }//������� �������
    
    if (QuestActive[playerid] == 8 && InEvent[playerid] == 0)
    {//����������
        if (GetPVarInt(playerid, "WorkBankStage") == 1)
        {//������� � �����, � �������� ����� ����� ������
			SetPVarInt(playerid, "WorkBankStage", 2); SetPlayerCheckpoint(playerid, 2361.7593, 2397.3511, 10.9471, 8.0);
			return SendClientMessage(playerid,COLOR_QUEST, "������: �� ������ ������! ������ �� � {FF0000}����{FFCC00}.");
        }//������� � �����, � �������� ����� ����� ������
        if (GetPVarInt(playerid, "WorkBankStage") == 2)
        {//������ ����� � ��������
            new String[120], wxp, wcash; //�������� � ���: 2400 xp � 900 000$ => � �������: 2/3xp � 250$
			if (WorkTime[playerid] <= 600) {wxp = WorkTime[playerid] * 2/3; wcash = WorkTime[playerid] * 250;}
			else {wxp = 400; wcash = 75000;}//�� ����� 10 ����� �� ���� �����. ���� ������ - ������ �� �� 10 ����� � ����� ������ �����
			format(String, sizeof String, "������: �� �������� %d XP � %d$ �� ����������� ������.", wxp, wcash);
			SendClientMessage(playerid, COLOR_QUEST, String); LGiveXP(playerid, wxp); Player[playerid][Cash] += wcash;
			PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
            //���� ������ ����� �����
            new rand = random(MAX_BASE); if (rand == 0) rand++;//�������� ���� ��� ����� �����
            SetPVarInt(playerid, "WorkBankStage", 1); WorkTime[playerid] = 0;
            if (QuestCar[playerid] != -1) {RepairVehicle(QuestCar[playerid]); SetVehicleZAngle(QuestCar[playerid], 0); SetPlayerChatBubble(playerid, "��������� ��������������", COLOR_GREEN, 300.0, 3000);}
			SendClientMessage(playerid, COLOR_QUEST, "������: ������ ������ �� {FF0000}�����{FFCC00} � ������� �� ����!");
            SetPlayerCheckpoint(playerid,Base[rand][bPosEnterX],Base[rand][bPosEnterY],Base[rand][bPosEnterZ],2);
        }//������ ����� � ��������
    }//����������
	
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	if (QuestActive[playerid] == 2 && InEvent[playerid] == 0)
	{//������ - ��������� �����
	    new target,next;
	    if (WorkPizzaCP[playerid] == WorkPizzaCPs[playerid] - 1)
	    {//����� ��������
  			RepairVehicle(QuestCar[playerid]); SetPlayerChatBubble(playerid, "��������� ��������������", COLOR_GREEN, 300.0, 3000);
	        new String[120], wxp, wcash;
			//�������� � ���: 2400 xp � 144 000$ => � �������: 2/3xp � 40$
			if (WorkTime[playerid] <= 300) {wxp = WorkTime[playerid] * 2/3; wcash = WorkTime[playerid] * 40;}
			else {wxp = 200;}//�� ����� 5 ����� �� ���� ����. ���� ������ 5 ����� - ������ ��� �� 5 �����.
			format(String, sizeof String, "������: �� �������� %d XP � %d$ �� �������� �����.", wxp, wcash);
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
	    }//����� ��������
	    if (WorkPizzaCP[playerid] == WorkPizzaCPs[playerid] - 2)
	    {//������������� CP
	        WorkPizzaCP[playerid] += 1;
	        SetPlayerRaceCheckpoint(playerid, 1, 2386.8760, -1921.9377, 12.9784, 0.0, 0.0, 0.0, 7);
	    }//������������� CP
	    else
	    {//������� CP
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
	        {//�������� - ��� �������
	            switch(rand)
	            {
		            case 0: SendClientMessage(playerid, COLOR_QUEST, "������: {AFAFAF}���������! � ��� ������ ����� �� ���� ������!");
		            case 1: SendClientMessage(playerid, COLOR_QUEST, "������: {AFAFAF}� ������ ���� ��������� ��������?!");
		            case 2: SendClientMessage(playerid, COLOR_QUEST, "������: {AFAFAF}� ��� � ��� �����! �������!");
		            case 3: SendClientMessage(playerid, COLOR_QUEST, "������: {AFAFAF}��� ������?! �������!");
		            case 4: SendClientMessage(playerid, COLOR_QUEST, "������: {AFAFAF}����� ������, �������!");
	            }
	        }//�������� - ��� �������
	    }//������� CP
	}//������ - ��������� �����

    if (XRTimeToEnd > 0 && XRStarted[playerid] == 1)
	{//�������� ����������� �����
	    new target,next,used;
	    if (XRPlayerCP[playerid] == XRCPs - 1)
	    {//�������� ��������
			new String[120];FarmedXP[playerid] = 200 + 35 * (XRPlayers-1); FarmedMoney[playerid] = 25000 + 5000 * (XRPlayers);XRpos += 1;
			if (XRpos == 1){FarmedXP[playerid] += 300;format(String,sizeof(String),"%s[%d] ������� ����������� ����� � ������� %d XP � %d$",PlayerName[playerid],playerid,FarmedXP[playerid],FarmedMoney[playerid]);SendClientMessageToAll(COLOR_XR,String);}
			if (XRpos == 2){FarmedXP[playerid] += 200;format(String,sizeof(String),"%s[%d] ����������� ������ � ����������� ����� � ������� %d XP � %d$",PlayerName[playerid],playerid,FarmedXP[playerid],FarmedMoney[playerid]);SendClientMessageToAll(COLOR_XR,String);}
			if (XRpos == 3){FarmedXP[playerid] += 100;format(String,sizeof(String),"%s[%d] ����������� ������� � ����������� ����� � ������� %d XP � %d$",PlayerName[playerid],playerid,FarmedXP[playerid],FarmedMoney[playerid]);SendClientMessageToAll(COLOR_XR,String);}
			if (XRpos > 3)
			{
				format(String,sizeof(String),"�� ������������ %d-�� � �������� %d XP � %d$",XRpos,FarmedXP[playerid],FarmedMoney[playerid]);SendClientMessage(playerid,COLOR_XR,String);
			}
			XRPlayers -= 1;Player[playerid][Cash] += FarmedMoney[playerid]; LGiveXP(playerid, FarmedXP[playerid]);
			XRStarted[playerid] = 0; JoinEvent[playerid] = 0; InEvent[playerid] = 0;
			DestroyVehicle(XRCarID[playerid]); XRCarID[playerid] = 0;LSpawnPlayer(playerid);
			SetPlayerVirtualWorld(playerid,0);PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
			DisablePlayerRaceCheckpoint(playerid);
			QuestUpdate(playerid, 16, 1);//���������� ������ ������� ������� � 3 ����������� ������
			QuestUpdate(playerid, 18, 1);//���������� ������ ������� ������� � 5 �������������
			return 1;
	    }//�������� ��������
	    if (XRPlayerCP[playerid] == XRCPs - 2)
	    {//������������� ��������
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
	        {//���� � ���� ��������� ����� ������ ����
	            NeedSpeedDown[playerid] = 1; LACSH[playerid] = 3; LastSpeed[playerid] = 999;//����� 2 ��� �� ������� LAC �� SpeedHack (������ ������������)
				DestroyVehicle(XRCarID[playerid]);new col1 = random(187), col2 = random(187);
				XRCarID[playerid] = LCreateVehicle(XRCarCP[used], x, y, z, Angle, col1, col2, 0);
				SetVehicleVirtualWorld(XRCarID[playerid], 700);PutPlayerInVehicle(playerid, XRCarID[playerid], 0);
				SetVehicleVelocity(XRCarID[playerid], vx, vy, vz);
				if (LSpectators[playerid] > 0) SpecUpdate(playerid);
				new rand = random(3);ChangeVehiclePaintjob(GetPlayerVehicleID(playerid), rand);//��������� paintjob
				XRPlayerCar[playerid] = XRCarCP[used];//��������� ������ ������ ��� � �������������� � ����������
				//���� ��������� �����
				new engine, lights, alarm, doors, bonnet, boot, objective;
			    GetVehicleParamsEx(XRCarID[playerid], engine, lights, alarm, doors, bonnet, boot, objective);
			    SetVehicleParamsEx(XRCarID[playerid], engine, lights, alarm, true, bonnet, boot, objective);
      		}//���� � ���� ��������� ����� ������ ����
	        PlayerPlaySound(playerid,1056,0.0,0.0,0.0);
	        XRxx[playerid] = x;XRy[playerid] = y;XRz[playerid] = z;XRa[playerid] = Angle;XRvx[playerid] = vx;XRvy[playerid] = vy;XRvz[playerid] = vz;//��� �������������� � ���������
	    }//������������� ��������
	    else
	    {//������� ��������
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
	        {//���� � ���� ��������� ����� ������ ����
	            NeedSpeedDown[playerid] = 1; LACSH[playerid] = 3; LastSpeed[playerid] = 999;//����� 2 ��� �� ������� LAC �� SpeedHack (������ ������������)
	            DestroyVehicle(XRCarID[playerid]);new col1 = random(187), col2 = random(187);
				XRCarID[playerid] = LCreateVehicle(XRCarCP[used], x, y, z, Angle, col1, col2, 0);
				SetVehicleVirtualWorld(XRCarID[playerid], 700);PutPlayerInVehicle(playerid, XRCarID[playerid], 0);
				SetVehicleVelocity(XRCarID[playerid], vx, vy, vz);
				if (LSpectators[playerid] > 0) SpecUpdate(playerid);
				new rand = random(3);ChangeVehiclePaintjob(GetPlayerVehicleID(playerid), rand);//��������� paintjob
				XRPlayerCar[playerid] = XRCarCP[used];//��������� ������ ������ ��� � �������������� � ����������
                //���� ��������� �����
				new engine, lights, alarm, doors, bonnet, boot, objective;
			    GetVehicleParamsEx(XRCarID[playerid], engine, lights, alarm, doors, bonnet, boot, objective);
			    SetVehicleParamsEx(XRCarID[playerid], engine, lights, alarm, true, bonnet, boot, objective);
       		}//���� � ���� ��������� ����� ������ ����
	        PlayerPlaySound(playerid,1056,0.0,0.0,0.0);
	        XRxx[playerid] = x;XRy[playerid] = y;XRz[playerid] = z;XRa[playerid] = Angle;XRvx[playerid] = vx;XRvy[playerid] = vy;XRvz[playerid] = vz;//��� �������������� � ���������
	    }//������� ��������
	    return 1;
	}//�������� ����������� �����

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
	{//���
	    new id = DynamicPickup[pickupid][ID];
	    if (PlayerToPoint(3.0,playerid, Property[id][pPosEnterX], Property[id][pPosEnterY], Property[id][pPosEnterZ])) LastHouseVisited[playerid] = id;
	}//���
	
	if (DynamicPickup[pickupid][Type] == 2)
	{//����
	    new id = DynamicPickup[pickupid][ID];
	    if (PlayerToPoint(3.0,playerid, Base[id][bPosEnterX], Base[id][bPosEnterY], Base[id][bPosEnterZ])) LastBaseVisited[playerid] = id;
	}//����
	
	if (DynamicPickup[pickupid][Type] == 3)
	{//���-�� ������
	    new String[140];
		Player[playerid][Cash] += DynamicPickup[pickupid][ID];
		format(String, sizeof String, "{FFFF00}SERVER: �� ��������� {FFFFFF}%d{FFFF00}$", DynamicPickup[pickupid][ID]);
		SendClientMessage(playerid, COLOR_YELLOW, String);
		format(String, sizeof String, "%d.%d.%d � %d:%d:%d |   CASH: %s[%d] �������� %d$", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid, DynamicPickup[pickupid][ID]);
		WriteLog("GlobalLog", String); WriteLog("CashOperations", String);
		QuestUpdate(playerid, 19, DynamicPickup[pickupid][ID]);//���������� ������ �������� ������ ������� �� ����� 10 000$
		//������� �����
		KillTimer(DynamicPickup[pickupid][DestroyTimerID]);
		DestroyCashPickup(pickupid);
	}//���-�� ������

	//----------- �����
	if (pickupid == CasePickup[1])
	{//����
		DestroyDynamicPickup(CasePickup[1]);DestroyDynamicMapIcon(CaseMapIcon[1]);
		case1 = random(sizeof(CaseSpawn));
		CasePickup[1] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case1][0], CaseSpawn[case1][1], CaseSpawn[case1][2] );
		CaseMapIcon[1] = CreateDynamicMapIcon(CaseSpawn[case1][0], CaseSpawn[case1][1], CaseSpawn[case1][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
		if (CaseBugTime[playerid] > 0) return 1;
		if (GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"������: ��������� ����� ����� ������ � ����� ������� ����!");
		new String[140], Priz = 3000 + random(69) * 250;//�� 3 000 �� 20 000. ������ ������ 250
		Player[playerid][Cash] += Priz; CaseBugTime[playerid] = 3;
		QuestUpdate(playerid, 21, 1);//���������� ������ ������� 5 ������
		format(String, sizeof String, "���������� �����: {FFFFFF}%d{FFCC00}$", Priz);
		return SendClientMessage(playerid,COLOR_QUEST,String);
	}//����

	if (pickupid == CasePickup[2])
	{//����
		DestroyDynamicPickup(CasePickup[2]);DestroyDynamicMapIcon(CaseMapIcon[2]);
		case2 = random(sizeof(CaseSpawn));
		CasePickup[2] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case2][0], CaseSpawn[case2][1], CaseSpawn[case2][2] );
		CaseMapIcon[2] = CreateDynamicMapIcon(CaseSpawn[case2][0], CaseSpawn[case2][1], CaseSpawn[case2][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
        if (CaseBugTime[playerid] > 0) return 1;
        if (GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"������: ��������� ����� ����� ������ � ����� ������� ����!");
		new String[140], Priz = 3000 + random(69) * 250;//�� 3 000 �� 20 000. ������ ������ 250
		Player[playerid][Cash] += Priz; CaseBugTime[playerid] = 3;
		QuestUpdate(playerid, 21, 1);//���������� ������ ������� 5 ������
		format(String, sizeof String, "���������� �����: {FFFFFF}%d{FFCC00}$", Priz);
		return SendClientMessage(playerid,COLOR_QUEST,String);
	}//����
	//----------- �����

	if (pickupid == CasePickup[3])
	{//����
		DestroyDynamicPickup(CasePickup[3]);DestroyDynamicMapIcon(CaseMapIcon[3]);
		case3 = random(sizeof(CaseSpawn));
		CasePickup[3] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case3][0], CaseSpawn[case3][1], CaseSpawn[case3][2] );
		CaseMapIcon[3] = CreateDynamicMapIcon(CaseSpawn[case3][0], CaseSpawn[case3][1], CaseSpawn[case3][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
        if (CaseBugTime[playerid] > 0) return 1;
        if (GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"������: ��������� ����� ����� ������ � ����� ������� ����!");
  		new String[140], Priz = 3000 + random(69) * 250;//�� 3 000 �� 20 000. ������ ������ 250
		Player[playerid][Cash] += Priz; CaseBugTime[playerid] = 3;
		QuestUpdate(playerid, 21, 1);//���������� ������ ������� 5 ������
		format(String, sizeof String, "���������� �����: {FFFFFF}%d{FFCC00}$", Priz);
		return SendClientMessage(playerid,COLOR_QUEST,String);
	}//����

	if (pickupid == CasePickup[4])
	{//����
		DestroyDynamicPickup(CasePickup[4]);DestroyDynamicMapIcon(CaseMapIcon[4]);
		case4 = random(sizeof(CaseSpawn));
		CasePickup[4] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case4][0], CaseSpawn[case4][1], CaseSpawn[case4][2] );
		CaseMapIcon[4] = CreateDynamicMapIcon(CaseSpawn[case4][0], CaseSpawn[case4][1], CaseSpawn[case4][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
        if (CaseBugTime[playerid] > 0) return 1;
        if (GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"������: ��������� ����� ����� ������ � ����� ������� ����!");
		new String[140], Priz = 3000 + random(69) * 250;//�� 3 000 �� 20 000. ������ ������ 250
		Player[playerid][Cash] += Priz; CaseBugTime[playerid] = 3;
		QuestUpdate(playerid, 21, 1);//���������� ������ ������� 5 ������
		format(String, sizeof String, "���������� �����: {FFFFFF}%d{FFCC00}$", Priz);
		return SendClientMessage(playerid,COLOR_QUEST,String);
	}//����

	if (pickupid == CasePickup[5])
	{//����
		DestroyDynamicPickup(CasePickup[5]);DestroyDynamicMapIcon(CaseMapIcon[5]);
		case5 = random(sizeof(CaseSpawn));
		CasePickup[5] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case5][0], CaseSpawn[case5][1], CaseSpawn[case5][2] );
		CaseMapIcon[5] = CreateDynamicMapIcon(CaseSpawn[case5][0], CaseSpawn[case5][1], CaseSpawn[case5][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
        if (CaseBugTime[playerid] > 0) return 1;
        if (GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"������: ��������� ����� ����� ������ � ����� ������� ����!");
		new String[140], Priz = 3000 + random(69) * 250;//�� 3 000 �� 20 000. ������ ������ 250
		Player[playerid][Cash] += Priz; CaseBugTime[playerid] = 3;
		QuestUpdate(playerid, 21, 1);//���������� ������ ������� 5 ������
		format(String, sizeof String, "���������� �����: {FFFFFF}%d{FFCC00}$", Priz);
		return SendClientMessage(playerid,COLOR_QUEST,String);
	}//����

	if (pickupid == CasePickup[6])
	{//����
		DestroyDynamicPickup(CasePickup[6]);DestroyDynamicMapIcon(CaseMapIcon[6]);
		case6 = random(sizeof(CaseSpawn));
		CasePickup[6] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case6][0], CaseSpawn[case6][1], CaseSpawn[case6][2] );
		CaseMapIcon[6] = CreateDynamicMapIcon(CaseSpawn[case6][0], CaseSpawn[case6][1], CaseSpawn[case6][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
        if (CaseBugTime[playerid] > 0) return 1;
        if (GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"������: ��������� ����� ����� ������ � ����� ������� ����!");
		new String[140], Priz = 3000 + random(69) * 250;//�� 3 000 �� 20 000. ������ ������ 250
		Player[playerid][Cash] += Priz; CaseBugTime[playerid] = 3;
		QuestUpdate(playerid, 21, 1);//���������� ������ ������� 5 ������
		format(String, sizeof String, "���������� �����: {FFFFFF}%d{FFCC00}$", Priz);
		return SendClientMessage(playerid,COLOR_QUEST,String);
	}//����

	if (pickupid == CasePickup[7])
	{//����
		DestroyDynamicPickup(CasePickup[7]);DestroyDynamicMapIcon(CaseMapIcon[7]);
		case7 = random(sizeof(CaseSpawn));
		CasePickup[7] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case7][0], CaseSpawn[case7][1], CaseSpawn[case7][2] );
		CaseMapIcon[7] = CreateDynamicMapIcon(CaseSpawn[case7][0], CaseSpawn[case7][1], CaseSpawn[case7][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
        if (CaseBugTime[playerid] > 0) return 1;
        if (GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"������: ��������� ����� ����� ������ � ����� ������� ����!");
		new String[140], Priz = 3000 + random(69) * 250;//�� 3 000 �� 20 000. ������ ������ 250
		Player[playerid][Cash] += Priz; CaseBugTime[playerid] = 3;
		QuestUpdate(playerid, 21, 1);//���������� ������ ������� 5 ������
		format(String, sizeof String, "���������� �����: {FFFFFF}%d{FFCC00}$", Priz);
		return SendClientMessage(playerid,COLOR_QUEST,String);
	}//����

	if (pickupid == CasePickup[8])
	{//����
		DestroyDynamicPickup(CasePickup[8]);DestroyDynamicMapIcon(CaseMapIcon[8]);
		case8 = random(sizeof(CaseSpawn));
		CasePickup[8] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case8][0], CaseSpawn[case8][1], CaseSpawn[case8][2] );
		CaseMapIcon[8] = CreateDynamicMapIcon(CaseSpawn[case8][0], CaseSpawn[case8][1], CaseSpawn[case8][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
        if (CaseBugTime[playerid] > 0) return 1;
        if (GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"������: ��������� ����� ����� ������ � ����� ������� ����!");
		new String[140], Priz = 3000 + random(69) * 250;//�� 3 000 �� 20 000. ������ ������ 250
		Player[playerid][Cash] += Priz; CaseBugTime[playerid] = 3;
		QuestUpdate(playerid, 21, 1);//���������� ������ ������� 5 ������
		format(String, sizeof String, "���������� �����: {FFFFFF}%d{FFCC00}$", Priz);
		return SendClientMessage(playerid,COLOR_QUEST,String);
	}//����

	if (pickupid == CasePickup[9])
	{//����
		DestroyDynamicPickup(CasePickup[9]);DestroyDynamicMapIcon(CaseMapIcon[9]);
		case9 = random(sizeof(CaseSpawn));
		CasePickup[9] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case9][0], CaseSpawn[case9][1], CaseSpawn[case9][2] );
		CaseMapIcon[9] = CreateDynamicMapIcon(CaseSpawn[case9][0], CaseSpawn[case9][1], CaseSpawn[case9][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
        if (CaseBugTime[playerid] > 0) return 1;
        if (GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"������: ��������� ����� ����� ������ � ����� ������� ����!");
		new String[140], Priz = 3000 + random(69) * 250;//�� 3 000 �� 20 000. ������ ������ 250
		Player[playerid][Cash] += Priz; CaseBugTime[playerid] = 3;
		QuestUpdate(playerid, 21, 1);//���������� ������ ������� 5 ������
		format(String, sizeof String, "���������� �����: {FFFFFF}%d{FFCC00}$", Priz);
		return SendClientMessage(playerid,COLOR_QUEST,String);
	}//����

	if (pickupid == CasePickup[10])
	{//����
		DestroyDynamicPickup(CasePickup[10]);DestroyDynamicMapIcon(CaseMapIcon[10]);
		case10 = random(sizeof(CaseSpawn));
		CasePickup[10] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case10][0], CaseSpawn[case10][1], CaseSpawn[case10][2] );
		CaseMapIcon[10] = CreateDynamicMapIcon(CaseSpawn[case10][0], CaseSpawn[case10][1], CaseSpawn[case10][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
        if (CaseBugTime[playerid] > 0) return 1;
        if (GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"������: ��������� ����� ����� ������ � ����� ������� ����!");
		new String[140], Priz = 3000 + random(69) * 250;//�� 3 000 �� 20 000. ������ ������ 250
		Player[playerid][Cash] += Priz; CaseBugTime[playerid] = 3;
		QuestUpdate(playerid, 21, 1);//���������� ������ ������� 5 ������
		format(String, sizeof String, "���������� �����: {FFFFFF}%d{FFCC00}$", Priz);
		return SendClientMessage(playerid,COLOR_QUEST,String);
	}//����

	if (pickupid == CasePickup[11])
	{//����
		DestroyDynamicPickup(CasePickup[11]);DestroyDynamicMapIcon(CaseMapIcon[11]);
		case11 = random(sizeof(CaseSpawn));
		CasePickup[11] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case11][0], CaseSpawn[case11][1], CaseSpawn[case11][2] );
		CaseMapIcon[11] = CreateDynamicMapIcon(CaseSpawn[case11][0], CaseSpawn[case11][1], CaseSpawn[case11][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
        if (CaseBugTime[playerid] > 0) return 1;
        if (GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"������: ��������� ����� ����� ������ � ����� ������� ����!");
		new String[140], Priz = 3000 + random(69) * 250;//�� 3 000 �� 20 000. ������ ������ 250
		Player[playerid][Cash] += Priz; CaseBugTime[playerid] = 3;
		QuestUpdate(playerid, 21, 1);//���������� ������ ������� 5 ������
		format(String, sizeof String, "���������� �����: {FFFFFF}%d{FFCC00}$", Priz);
		return SendClientMessage(playerid,COLOR_QUEST,String);
	}//����

	if (pickupid == CasePickup[12])
	{//����
		DestroyDynamicPickup(CasePickup[12]);DestroyDynamicMapIcon(CaseMapIcon[12]);
		case12 = random(sizeof(CaseSpawn));
		CasePickup[12] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case12][0], CaseSpawn[case12][1], CaseSpawn[case12][2] );
		CaseMapIcon[12] = CreateDynamicMapIcon(CaseSpawn[case12][0], CaseSpawn[case12][1], CaseSpawn[case12][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
        if (CaseBugTime[playerid] > 0) return 1;
        if (GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"������: ��������� ����� ����� ������ � ����� ������� ����!");
		new String[140], Priz = 3000 + random(69) * 250;//�� 3 000 �� 20 000. ������ ������ 250
		Player[playerid][Cash] += Priz; CaseBugTime[playerid] = 3;
		QuestUpdate(playerid, 21, 1);//���������� ������ ������� 5 ������
		format(String, sizeof String, "���������� �����: {FFFFFF}%d{FFCC00}$", Priz);
		return SendClientMessage(playerid,COLOR_QUEST,String);
	}//����

	if (pickupid == CasePickup[13])
	{//����
		DestroyDynamicPickup(CasePickup[13]);DestroyDynamicMapIcon(CaseMapIcon[13]);
		case13 = random(sizeof(CaseSpawn));
		CasePickup[13] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case13][0], CaseSpawn[case13][1], CaseSpawn[case13][2] );
		CaseMapIcon[13] = CreateDynamicMapIcon(CaseSpawn[case13][0], CaseSpawn[case13][1], CaseSpawn[case13][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
        if (CaseBugTime[playerid] > 0) return 1;
        if (GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"������: ��������� ����� ����� ������ � ����� ������� ����!");
		new String[140], Priz = 3000 + random(69) * 250;//�� 3 000 �� 20 000. ������ ������ 250
		Player[playerid][Cash] += Priz; CaseBugTime[playerid] = 3;
		QuestUpdate(playerid, 21, 1);//���������� ������ ������� 5 ������
		format(String, sizeof String, "���������� �����: {FFFFFF}%d{FFCC00}$", Priz);
		return SendClientMessage(playerid,COLOR_QUEST,String);
	}//����

	if (pickupid == CasePickup[14])
	{//����
		DestroyDynamicPickup(CasePickup[14]);DestroyDynamicMapIcon(CaseMapIcon[14]);
		case14 = random(sizeof(CaseSpawn));
		CasePickup[14] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case14][0], CaseSpawn[case14][1], CaseSpawn[case14][2] );
		CaseMapIcon[14] = CreateDynamicMapIcon(CaseSpawn[case14][0], CaseSpawn[case14][1], CaseSpawn[case14][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
        if (CaseBugTime[playerid] > 0) return 1;
        if (GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"������: ��������� ����� ����� ������ � ����� ������� ����!");
		new String[140], Priz = 3000 + random(69) * 250;//�� 3 000 �� 20 000. ������ ������ 250
		Player[playerid][Cash] += Priz; CaseBugTime[playerid] = 3;
		QuestUpdate(playerid, 21, 1);//���������� ������ ������� 5 ������
		format(String, sizeof String, "���������� �����: {FFFFFF}%d{FFCC00}$", Priz);
		return SendClientMessage(playerid,COLOR_QUEST,String);
	}//����

	if (pickupid == CasePickup[15])
	{//����
		DestroyDynamicPickup(CasePickup[15]);DestroyDynamicMapIcon(CaseMapIcon[15]);
		case15 = random(sizeof(CaseSpawn));
		CasePickup[15] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case15][0], CaseSpawn[case15][1], CaseSpawn[case15][2] );
		CaseMapIcon[15] = CreateDynamicMapIcon(CaseSpawn[case15][0], CaseSpawn[case15][1], CaseSpawn[case15][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
        if (CaseBugTime[playerid] > 0) return 1;
        if (GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"������: ��������� ����� ����� ������ � ����� ������� ����!");
		new String[140], Priz = 3000 + random(69) * 250;//�� 3 000 �� 20 000. ������ ������ 250
		Player[playerid][Cash] += Priz; CaseBugTime[playerid] = 3;
		QuestUpdate(playerid, 21, 1);//���������� ������ ������� 5 ������
		format(String, sizeof String, "���������� �����: {FFFFFF}%d{FFCC00}$", Priz);
		return SendClientMessage(playerid,COLOR_QUEST,String);
	}//����

	if (pickupid == CasePickup[16])
	{//����
		DestroyDynamicPickup(CasePickup[16]);DestroyDynamicMapIcon(CaseMapIcon[16]);
		case16 = random(sizeof(CaseSpawn));
		CasePickup[16] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case16][0], CaseSpawn[case16][1], CaseSpawn[case16][2] );
		CaseMapIcon[16] = CreateDynamicMapIcon(CaseSpawn[case16][0], CaseSpawn[case16][1], CaseSpawn[case16][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
        if (CaseBugTime[playerid] > 0) return 1;
        if (GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"������: ��������� ����� ����� ������ � ����� ������� ����!");
		new String[140], Priz = 3000 + random(69) * 250;//�� 3 000 �� 20 000. ������ ������ 250
		Player[playerid][Cash] += Priz; CaseBugTime[playerid] = 3;
		QuestUpdate(playerid, 21, 1);//���������� ������ ������� 5 ������
		format(String, sizeof String, "���������� �����: {FFFFFF}%d{FFCC00}$", Priz);
		return SendClientMessage(playerid,COLOR_QUEST,String);
	}//����

	if (pickupid == CasePickup[17])
	{//����
		DestroyDynamicPickup(CasePickup[17]);DestroyDynamicMapIcon(CaseMapIcon[17]);
		case17 = random(sizeof(CaseSpawn));
		CasePickup[17] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case17][0], CaseSpawn[case17][1], CaseSpawn[case17][2] );
		CaseMapIcon[17] = CreateDynamicMapIcon(CaseSpawn[case17][0], CaseSpawn[case17][1], CaseSpawn[case17][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
        if (CaseBugTime[playerid] > 0) return 1;
        if (GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"������: ��������� ����� ����� ������ � ����� ������� ����!");
		new String[140], Priz = 3000 + random(69) * 250;//�� 3 000 �� 20 000. ������ ������ 250
		Player[playerid][Cash] += Priz; CaseBugTime[playerid] = 3;
		QuestUpdate(playerid, 21, 1);//���������� ������ ������� 5 ������
		format(String, sizeof String, "���������� �����: {FFFFFF}%d{FFCC00}$", Priz);
		return SendClientMessage(playerid,COLOR_QUEST,String);
	}//����

	if (pickupid == CasePickup[18])
	{//����
		DestroyDynamicPickup(CasePickup[18]);DestroyDynamicMapIcon(CaseMapIcon[18]);
		case18 = random(sizeof(CaseSpawn));
		CasePickup[18] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case18][0], CaseSpawn[case18][1], CaseSpawn[case18][2] );
		CaseMapIcon[18] = CreateDynamicMapIcon(CaseSpawn[case18][0], CaseSpawn[case18][1], CaseSpawn[case18][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
        if (CaseBugTime[playerid] > 0) return 1;
        if (GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"������: ��������� ����� ����� ������ � ����� ������� ����!");
		new String[140], Priz = 3000 + random(69) * 250;//�� 3 000 �� 20 000. ������ ������ 250
		Player[playerid][Cash] += Priz; CaseBugTime[playerid] = 3;
		QuestUpdate(playerid, 21, 1);//���������� ������ ������� 5 ������
		format(String, sizeof String, "���������� �����: {FFFFFF}%d{FFCC00}$", Priz);
		return SendClientMessage(playerid,COLOR_QUEST,String);
	}//����

	if (pickupid == CasePickup[19])
	{//����
		DestroyDynamicPickup(CasePickup[19]);DestroyDynamicMapIcon(CaseMapIcon[19]);
		case19 = random(sizeof(CaseSpawn));
		CasePickup[19] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case19][0], CaseSpawn[case19][1], CaseSpawn[case19][2] );
		CaseMapIcon[19] = CreateDynamicMapIcon(CaseSpawn[case19][0], CaseSpawn[case19][1], CaseSpawn[case19][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
        if (CaseBugTime[playerid] > 0) return 1;
        if (GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"������: ��������� ����� ����� ������ � ����� ������� ����!");
		new String[140], Priz = 3000 + random(69) * 250;//�� 3 000 �� 20 000. ������ ������ 250
		Player[playerid][Cash] += Priz; CaseBugTime[playerid] = 3;
		QuestUpdate(playerid, 21, 1);//���������� ������ ������� 5 ������
		format(String, sizeof String, "���������� �����: {FFFFFF}%d{FFCC00}$", Priz);
		return SendClientMessage(playerid,COLOR_QUEST,String);
	}//����

	if (pickupid == CasePickup[20])
	{//����
		DestroyDynamicPickup(CasePickup[20]);DestroyDynamicMapIcon(CaseMapIcon[20]);
		case20 = random(sizeof(CaseSpawn));
		CasePickup[20] = CreateDynamicPickup ( casemodel, 2, CaseSpawn[case20][0], CaseSpawn[case20][1], CaseSpawn[case20][2] );
		CaseMapIcon[20] = CreateDynamicMapIcon(CaseSpawn[case20][0], CaseSpawn[case20][1], CaseSpawn[case20][2], 56, COLOR_QUEST, 0, 0, -1, 350.0);
        if (CaseBugTime[playerid] > 0) return 1;
        if (GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"������: ��������� ����� ����� ������ � ����� ������� ����!");
		new String[140], Priz = 3000 + random(69) * 250;//�� 3 000 �� 20 000. ������ ������ 250
		Player[playerid][Cash] += Priz; CaseBugTime[playerid] = 3;
		QuestUpdate(playerid, 21, 1);//���������� ������ ������� 5 ������
		format(String, sizeof String, "���������� �����: {FFFFFF}%d{FFCC00}$", Priz);
		return SendClientMessage(playerid,COLOR_QUEST,String);
	}//����



	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
 	TunesPerSecond[playerid]++; if (TunesPerSecond[playerid] > 5) Kick(playerid);//�� ����� ��������
    if (Player[playerid][Banned] == 1) return 1;//����� ������ �� ������ � �� �� ����� ���
	if (InEvent[playerid] == EVENT_RACE || InEvent[playerid] == EVENT_XRACE)
	{//����������� ������ � ������
		RemovePlayerFromVehicle(playerid);//������ ������� � ������
		return SendClientMessage(playerid, COLOR_RED, "������������� �������������� ��������� � ������! ������ �������� ��������� � �������� ��������������!");
	}//����������� ������ � ������
    
	if (componentid == 1087 && Player[playerid][Level] < 9) return SendClientMessage(playerid,COLOR_RED,"�� ������ ���� ��� ������� 9-�� ������, ����� ���������� ����������� ��� �������������!");
	if (componentid == 1009 && Player[playerid][Level] < 35) return SendClientMessage(playerid,COLOR_RED,"�� ������ ���� ��� ������� 35-�� ������, ����� ����� �2 ����������� ��� �������������!");
	if (componentid == 1008 && Player[playerid][Level] < 42) return SendClientMessage(playerid,COLOR_RED,"�� ������ ���� ��� ������� 42-�� ������, ����� ����� �5 ����������� ��� �������������!");
	if (componentid == 1010 && Player[playerid][Level] < 48) return SendClientMessage(playerid,COLOR_RED,"�� ������ ���� ��� ������� 48-�� ������, ����� ����� �10 ����������� ��� �������������!");

	if (LastPlayerTuneStatus[playerid] > 0)
	{//����� �������� ��������� � �������
	    if (Player[playerid][CarActive] == 1)
	    {//���������� ������� ����� 1
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
	    }//���������� ������� ����� 1
	    if (Player[playerid][CarActive] == 2)
	    {//���������� ������� ����� 2
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
	    }//���������� ������� ����� 2
		return 1;
	}//����� �������� ��������� � �������

	new String[140];
	DestroyVehicle(vehicleid); TimeTransform[playerid] = 5; LACPanic[playerid]++;//LAC v2.0
	format(String,sizeof(String), "[�������]LAC:{AFAFAF} ��������� ������ %s[%d] ���������. {FF0000}�������: {AFAFAF}�������� ������ ����������",PlayerName[playerid], playerid);
    foreach(Player, cid) if (Player[cid][Admin] != 0 && Logged[cid] == 1) SendClientMessage(cid, COLOR_RED, String);
    SendClientMessage(playerid, -1,"{FF0000}LAC:{AFAFAF} ��� ��������� ��� ���������. {FF0000}�������: {AFAFAF}�������� ��� �� ������ ����������");
	format(String, 140, "%d.%d.%d � %d:%d:%d |   LAC: ��������� ������ %s[%d] ���������. �������: �������� ��� �� ������ ����������", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid);
	WriteLog("GlobalLog", String);WriteLog("LAC", String);
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{//����� PaintJob � �������
    TunesPerSecond[playerid]++; if (TunesPerSecond[playerid] > 5) Kick(playerid);//�� ����� ��������
	if (Player[playerid][Level] < 55) return SendClientMessage(playerid,COLOR_RED,"�� ������ ���� ��� ������� 55-�� ������, ����� ����������� ������ ����������� ��� �������������!");
    if (Player[playerid][CarActive] == 1) Player[playerid][CarSlot1PaintJob] = paintjobid;
    if (Player[playerid][CarActive] == 2) Player[playerid][CarSlot2PaintJob] = paintjobid;
    SaveTune(playerid);
	return 1;
}//����� PaintJob � �������

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{//���������� ���� � �������
    TunesPerSecond[playerid]++; if (TunesPerSecond[playerid] > 5) Kick(playerid);//�� ����� ��������
	if (Player[playerid][CarActive] == 1) {Player[playerid][CarSlot1Color1] = color1; Player[playerid][CarSlot1Color2] = color2;}
	if (Player[playerid][CarActive] == 2) {Player[playerid][CarSlot2Color1] = color1; Player[playerid][CarSlot2Color2] = color2;}
	return 1;
}//���������� ���� � �������

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
     {//����������� �����
        if (Player[playerid][CarActive] == 1 && Player[playerid][CarSlot1NitroX] > 0 && InEvent[playerid] == 0 && QuestActive[playerid] == 0) AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
        if (Player[playerid][CarActive] == 2 && Player[playerid][CarSlot2NitroX] > 0 && InEvent[playerid] == 0 && QuestActive[playerid] == 0) AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
     }//����������� �����

     if(newkeys & KEY_FIRE && IsPlayerInAnyVehicle(playerid))
     {//���������� ����
	     if(IsPlayerInPayNSpray(playerid))
		 {//����� � ������ Pay N Spray
			    if (Player[playerid][Cash] < 100){SendClientMessage(playerid,COLOR_RED,"��� ����� {FFFFFF}100${FF0000} ����� ����������� ������");return 1;}
		        Player[playerid][Cash] -= 100;
				new col1 = random (256), col2 = random(256);
			    if (Player[playerid][CarActive] == 1){Player[playerid][CarSlot1Color1] = col1;Player[playerid][CarSlot1Color2] = col2;}
			    if (Player[playerid][CarActive] == 2){Player[playerid][CarSlot2Color1] = col1;Player[playerid][CarSlot2Color2] = col2;}
			    if (Player[playerid][CarActive] == 3){Player[playerid][CarSlot3Color1] = col1;Player[playerid][CarSlot3Color2] = col2;}
			    ChangeVehicleColor(GetPlayerVehicleID(playerid), col1, col2);RepairVehicle(GetPlayerVehicleID(playerid));
			    PlayerPlaySound(playerid,1134,0.0,0.0,0.0);
		 }//����� � ������ Pay N Spray
	}//���������� ����
	
	if(newkeys & KEY_FIRE && IsPlayerInAnyVehicle(playerid) && IsPlayerInRangeOfPoint(playerid, 8, -2026.9791, 124.2575, 29.1300))
    {//�������������� TurboSpeed
       ShowPlayerDialog(playerid, DIALOG_TURBOSPEED, 2, "�������������� TurboSpeed", "�����\n����\n{FF0000}������� ��������� �������", "��", "������");
    }//�������������� TurboSpeed

	if (newkeys & KEY_JUMP && ZMIsPlayerIsTank[playerid] == 1 && InEvent[playerid] == EVENT_ZOMBIE)
	{//������� ������ � �������
	    if (JumpTime[playerid] > 0) return 1;
	    new Float: vx, Float: vy, Float: vz;
		GetPlayerVelocity(playerid,vx,vy,vz);
        SetPlayerVelocity(playerid, vx, vy, 0.75);
        JumpTime[playerid] = 3;
	}//������� ������ � �������

	if(newkeys & KEY_YES && IsPlayerInVehicle(playerid, PlayerCarID[playerid]) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{//������������� ������ �� +1, ���� ����� �� ����� ������ ����
		if (TimeTransform[playerid] > 0){new String[120];format(String,sizeof(String),"�� �� ������ ���������������� ��������� ��� {FFFFFF}%d{FF0000} ������",TimeTransform[playerid]);return SendClientMessage(playerid,COLOR_RED,String);}
		if (LastPlayerTuneStatus[playerid] != 0) return SendClientMessage(playerid,COLOR_RED,"������ ������������������ � �������������� � � ������ � ���");
		LastSpeed[playerid] = 999; NeedSpeedDown[playerid] = 1; LACSH[playerid] = 3;//����� �� ������� LAC �� SpeedHack (������ ������������)
		new Float: x, Float: y, Float: z, Float: Angle; GetPlayerPos(playerid,x,y,z);
		new Float: vx, Float: vy, Float: vz;new wrld = GetPlayerVirtualWorld(playerid);
		//!!!������ ����������
		new Passenger1 = -1, Passenger2 = -1, Passenger3 = -1, Seats;
		foreach(Player, cid)
		{//����
		    if (IsPlayerInVehicle(cid,PlayerCarID[playerid]) && GetPlayerState(cid) == PLAYER_STATE_PASSENGER)
		    {//��� ��������
		        if (GetPlayerVehicleSeat(cid) == 1){Passenger1 = cid;}
		        if (GetPlayerVehicleSeat(cid) == 2){Passenger2 = cid;}
		        if (GetPlayerVehicleSeat(cid) == 3){Passenger3 = cid;}
		    }//��� ��������
		}//����
		//!!!������ ����������
		GetVehicleVelocity(PlayerCarID[playerid], vx, vy, vz);
		GetVehicleZAngle(PlayerCarID[playerid], Angle);
		DestroyVehicle(PlayerCarID[playerid]); PlayerCarID[playerid] = -1;
		CarChanged[playerid] = 0;
		if (Player[playerid][CarActive] == 1 && CarChanged[playerid] == 0)
		{//���� ������ ������� ���� 1
			if (Player[playerid][CarSlot2] > 0){Player[playerid][CarActive] = 2;CarChanged[playerid] = 1;}
			if (Player[playerid][CarSlot3] > 0){Player[playerid][CarActive] = 3;CarChanged[playerid] = 1;}
			if(CarChanged[playerid] == 0){Player[playerid][CarActive] = 1;CarChanged[playerid] = 1;}
		}//���� ������ ������� ���� 1
		if (Player[playerid][CarActive] == 2 && CarChanged[playerid] == 0)
		{//���� ������ ������� ���� 2
			if (Player[playerid][CarSlot3] > 0){Player[playerid][CarActive] = 3;CarChanged[playerid] = 1;}
			if (Player[playerid][CarSlot1] > 0){Player[playerid][CarActive] = 1;CarChanged[playerid] = 1;}
			if(CarChanged[playerid] == 0){Player[playerid][CarActive] = 2;CarChanged[playerid] = 1;}
		}//���� ������ ������� ���� 2
		if (Player[playerid][CarActive] == 3 && CarChanged[playerid] == 0)
		{//���� ������ ������� ���� 3
			if (Player[playerid][CarSlot1] > 0){Player[playerid][CarActive] = 1;CarChanged[playerid] = 1;}
			if (Player[playerid][CarSlot2] > 0){Player[playerid][CarActive] = 2;CarChanged[playerid] = 1;}
			if(CarChanged[playerid] == 0){Player[playerid][CarActive] = 3;CarChanged[playerid] = 1;}
		}//���� ������ ������� ���� 3
		if (Player[playerid][CarActive] == 1)
		{
			PlayerCarID[playerid] = LCreateVehicle(Player[playerid][CarSlot1], x, y, z + 1, Angle, Player[playerid][CarSlot1Color1], Player[playerid][CarSlot1Color2], 0);
			if (Player[playerid][CarSlot1PaintJob] > -1){ChangeVehiclePaintjob(PlayerCarID[playerid], Player[playerid][CarSlot1PaintJob]);}
			//�������� ����������� �������
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
			{//�������� �����
			    new vehicleid = PlayerCarID[playerid];
			    NeonObject1[vehicleid] = CreateDynamicObject(Player[playerid][CarSlot1Neon], 0, 0, 0, 0, 0, 0, wrld, GetPlayerInterior(playerid), -1, 300.0);
			    NeonObject2[vehicleid] = CreateDynamicObject(Player[playerid][CarSlot1Neon], 0, 0, 0, 0, 0, 0, wrld, GetPlayerInterior(playerid), -1, 300.0);
			    AttachDynamicObjectToVehicle(NeonObject1[vehicleid], vehicleid, -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
			    AttachDynamicObjectToVehicle(NeonObject2[vehicleid], vehicleid, 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
			}//�������� �����
		}
		else if (Player[playerid][CarActive] == 2)
		{
			PlayerCarID[playerid] = LCreateVehicle(Player[playerid][CarSlot2], x, y, z + 1, Angle, Player[playerid][CarSlot2Color1], Player[playerid][CarSlot2Color2], 0);
			if (Player[playerid][CarSlot2PaintJob] > -1){ChangeVehiclePaintjob(PlayerCarID[playerid], Player[playerid][CarSlot2PaintJob]);}
            //�������� ����������� �������
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
			{//�������� �����
			    new vehicleid = PlayerCarID[playerid];
			    NeonObject1[vehicleid] = CreateDynamicObject(Player[playerid][CarSlot2Neon], 0, 0, 0, 0, 0, 0, wrld, GetPlayerInterior(playerid), -1, 300.0);
			    NeonObject2[vehicleid] = CreateDynamicObject(Player[playerid][CarSlot2Neon], 0, 0, 0, 0, 0, 0, wrld, GetPlayerInterior(playerid), -1, 300.0);
			    AttachDynamicObjectToVehicle(NeonObject1[vehicleid], vehicleid, -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
			    AttachDynamicObjectToVehicle(NeonObject2[vehicleid], vehicleid, 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
			}//�������� �����
		}
		else if (Player[playerid][CarActive] == 3){PlayerCarID[playerid] = LCreateVehicle(Player[playerid][CarSlot3], x, y, z + 2, Angle, Player[playerid][CarSlot3Color1], Player[playerid][CarSlot3Color2], 0);}
		SetVehicleVirtualWorld(PlayerCarID[playerid], wrld);PutPlayerInVehicle(playerid, PlayerCarID[playerid], 0);
		SetVehicleVelocity(PlayerCarID[playerid], vx, vy, vz); LACSH[playerid] = 3;
        LinkVehicleToInterior(PlayerCarID[playerid],GetPlayerInterior(playerid));
		CarChanged[playerid] = 1;TimeTransform[playerid] = 5;
		//!!!�������� ����������
		Seats = GetPassengerSeats(PlayerCarID[playerid]);
		if (Seats == 1)
		{//���� ����� ����� ����
		    if (Passenger1 > -1){PutPlayerInVehicle(Passenger1, PlayerCarID[playerid], 1);}
		    else
		    {
		        if (Passenger2 > -1){PutPlayerInVehicle(Passenger2, PlayerCarID[playerid], 1);}
		        else
		        {
		            if (Passenger3 > -1){PutPlayerInVehicle(Passenger3, PlayerCarID[playerid], 1);}
		        }
		    }
		}//���� ����� ����� ����
		if (Seats == 3)
		{//��� �����
		    if (Passenger1 > -1){PutPlayerInVehicle(Passenger1, PlayerCarID[playerid], 1);}
		    if (Passenger2 > -1){PutPlayerInVehicle(Passenger2, PlayerCarID[playerid], 2);}
		    if (Passenger3 > -1){PutPlayerInVehicle(Passenger3, PlayerCarID[playerid], 3);}
		}//��� �����
		//!!!�������� ����������
		if (LSpectators[playerid] > 0) {SpecUpdate(playerid);}//���������� ������� � ���, ��� �� ������� ������
        QuestUpdate(playerid, 29, 1);//���������� ������ ��������������� ��������� 30 ���
	}//������������� ������ �� +1, ���� ����� �� ����� ������ ����
	if(newkeys & KEY_NO && IsPlayerInVehicle(playerid, PlayerCarID[playerid]) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{//������������� ������ �� -1, ���� ����� �� ����� ������ ����
		if (TimeTransform[playerid] > 0){new String[120];format(String,sizeof(String),"�� �� ������ ���������������� ��������� ��� {FFFFFF}%d{FF0000} ������",TimeTransform[playerid]);SendClientMessage(playerid,COLOR_RED,String);return 1;}
        if (LastPlayerTuneStatus[playerid] != 0) return SendClientMessage(playerid,COLOR_RED,"������ ������������������ � �������������� � � ������ � ���");
	    LastSpeed[playerid] = 999; NeedSpeedDown[playerid] = 1; LACSH[playerid] = 3;//����� 2 ��� �� ������� LAC �� SpeedHack (������ ������������)
		new Float: x, Float: y, Float: z, Float: Angle; GetPlayerPos(playerid,x,y,z);
		new Float: vx, Float: vy, Float: vz;new wrld = GetPlayerVirtualWorld(playerid);
        //!!!������ ����������
		new Passenger1 = -1, Passenger2 = -1, Passenger3 = -1, Seats;
		foreach(Player, cid)
		{//����
		    if (IsPlayerInVehicle(cid,PlayerCarID[playerid]) && GetPlayerState(cid) == PLAYER_STATE_PASSENGER)
		    {//��� ��������
		        if (GetPlayerVehicleSeat(cid) == 1){Passenger1 = cid;}
		        if (GetPlayerVehicleSeat(cid) == 2){Passenger2 = cid;}
		        if (GetPlayerVehicleSeat(cid) == 3){Passenger3 = cid;}
		    }//��� ��������
		}//����
		//!!!������ ����������
		GetVehicleVelocity(PlayerCarID[playerid], vx, vy, vz);
		GetVehicleZAngle(PlayerCarID[playerid], Angle);
		DestroyVehicle(PlayerCarID[playerid]); PlayerCarID[playerid] = -1;
		CarChanged[playerid] = 0;
		if (Player[playerid][CarActive] == 1 && CarChanged[playerid] == 0)
		{//���� ������ ������� ���� 1
			if (Player[playerid][CarSlot3] > 0){Player[playerid][CarActive] = 3;CarChanged[playerid] = 1;}
			if (Player[playerid][CarSlot2] > 0){Player[playerid][CarActive] = 2;CarChanged[playerid] = 1;}
			if(CarChanged[playerid] == 0){Player[playerid][CarActive] = 1;CarChanged[playerid] = 1;}
		}//���� ������ ������� ���� 1
		if (Player[playerid][CarActive] == 2 && CarChanged[playerid] == 0)
		{//���� ������ ������� ���� 2
			if (Player[playerid][CarSlot1] > 0){Player[playerid][CarActive] = 1;CarChanged[playerid] = 1;}
			if (Player[playerid][CarSlot3] > 0){Player[playerid][CarActive] = 3;CarChanged[playerid] = 1;}
			if(CarChanged[playerid] == 0){Player[playerid][CarActive] = 2;CarChanged[playerid] = 1;}
		}//���� ������ ������� ���� 2
		if (Player[playerid][CarActive] == 3 && CarChanged[playerid] == 0)
		{//���� ������ ������� ���� 3
			if (Player[playerid][CarSlot2] > 0){Player[playerid][CarActive] = 2;CarChanged[playerid] = 1;}
			if (Player[playerid][CarSlot1] > 0){Player[playerid][CarActive] = 1;CarChanged[playerid] = 1;}
			if(CarChanged[playerid] == 0){Player[playerid][CarActive] = 3;CarChanged[playerid] = 1;}
		}//���� ������ ������� ���� 3
		if (Player[playerid][CarActive] == 1)
		{
			PlayerCarID[playerid] = LCreateVehicle(Player[playerid][CarSlot1], x, y, z + 1, Angle, Player[playerid][CarSlot1Color1], Player[playerid][CarSlot1Color2], 0);
            if (Player[playerid][CarSlot1PaintJob] > -1){ChangeVehiclePaintjob(PlayerCarID[playerid], Player[playerid][CarSlot1PaintJob]);}
			//�������� ����������� �������
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
			{//�������� �����
			    new vehicleid = PlayerCarID[playerid];
			    NeonObject1[vehicleid] = CreateDynamicObject(Player[playerid][CarSlot1Neon], 0, 0, 0, 0, 0, 0, wrld, GetPlayerInterior(playerid), -1, 300.0);
			    NeonObject2[vehicleid] = CreateDynamicObject(Player[playerid][CarSlot1Neon], 0, 0, 0, 0, 0, 0, wrld, GetPlayerInterior(playerid), -1, 300.0);
			    AttachDynamicObjectToVehicle(NeonObject1[vehicleid], vehicleid, -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
			    AttachDynamicObjectToVehicle(NeonObject2[vehicleid], vehicleid, 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
			}//�������� �����
		}
		else if (Player[playerid][CarActive] == 2)
		{
			PlayerCarID[playerid] = LCreateVehicle(Player[playerid][CarSlot2], x, y, z + 1, Angle, Player[playerid][CarSlot2Color1], Player[playerid][CarSlot2Color2], 0);
			if (Player[playerid][CarSlot2PaintJob] > -1){ChangeVehiclePaintjob(PlayerCarID[playerid], Player[playerid][CarSlot2PaintJob]);}
        	//�������� ����������� �������
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
			{//�������� �����
			    new vehicleid = PlayerCarID[playerid];
			    NeonObject1[vehicleid] = CreateDynamicObject(Player[playerid][CarSlot2Neon], 0, 0, 0, 0, 0, 0, wrld, GetPlayerInterior(playerid), -1, 300.0);
			    NeonObject2[vehicleid] = CreateDynamicObject(Player[playerid][CarSlot2Neon], 0, 0, 0, 0, 0, 0, wrld, GetPlayerInterior(playerid), -1, 300.0);
			    AttachDynamicObjectToVehicle(NeonObject1[vehicleid], vehicleid, -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
			    AttachDynamicObjectToVehicle(NeonObject2[vehicleid], vehicleid, 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
			}//�������� �����
		}
		else if (Player[playerid][CarActive] == 3){PlayerCarID[playerid] = LCreateVehicle(Player[playerid][CarSlot3], x, y, z + 2, Angle, Player[playerid][CarSlot3Color1], Player[playerid][CarSlot3Color2], 0);}
		SetVehicleVirtualWorld(PlayerCarID[playerid], wrld);PutPlayerInVehicle(playerid, PlayerCarID[playerid], 0);
		SetVehicleVelocity(PlayerCarID[playerid], vx, vy, vz); LACSH[playerid] = 3;
        LinkVehicleToInterior(PlayerCarID[playerid],GetPlayerInterior(playerid));
		CarChanged[playerid] = 1;TimeTransform[playerid] = 5;
        //!!!�������� ����������
		Seats = GetPassengerSeats(PlayerCarID[playerid]);
		if (Seats == 1)
		{//���� ����� ����� ����
		    if (Passenger1 > -1){PutPlayerInVehicle(Passenger1, PlayerCarID[playerid], 1);}
		    else
		    {
		        if (Passenger2 > -1){PutPlayerInVehicle(Passenger2, PlayerCarID[playerid], 1);}
		        else
		        {
		            if (Passenger3 > -1){PutPlayerInVehicle(Passenger3, PlayerCarID[playerid], 1);}
		        }
		    }
		}//���� ����� ����� ����
		if (Seats == 3)
		{//��� �����
		    if (Passenger1 > -1){PutPlayerInVehicle(Passenger1, PlayerCarID[playerid], 1);}
		    if (Passenger2 > -1){PutPlayerInVehicle(Passenger2, PlayerCarID[playerid], 2);}
		    if (Passenger3 > -1){PutPlayerInVehicle(Passenger3, PlayerCarID[playerid], 3);}
		}//��� �����
		//!!!�������� ����������
		if (LSpectators[playerid] > 0) {SpecUpdate(playerid);}//���������� ������� � ���, ��� �� ������� ������
        QuestUpdate(playerid, 29, 1);//���������� ������ ��������������� ��������� 30 ���
	}//������������� ������ �� -1

    if((newkeys & KEY_YES || newkeys & KEY_NO) && IsPlayerInVehicle(playerid, QuestCar[playerid]) && QuestActive[playerid] == 0)
    {//����� ����� Y ��� N ���� � �������� ������ (��������� ����� ������� �����)
        new modelid = GetVehicleModel(QuestCar[playerid]);
        switch (modelid)
        {//switch
	        case 417, 447, 469, 476, 487, 488, 497, 511, 512, 513, 519, 548, 563, 593:
	        {//��������� ����
		        modelid -= 400; new String[120];
				format(String,sizeof(String),"{AFAFAF}���������: {FFCC00}%s{AFAFAF} ���������: %d$",PlayerVehicleName[modelid], GetVehicleMaxSpeed(QuestCar[playerid]) * 2000);
		        ShowPlayerDialog(playerid, DIALOG_STEALAIRCAR, 2, String, "{FFCC00}������ ���������{FFFFFF}\n������� ������ ����������� {007FFF}3{FFFFFF}-�� ������\n{FF0000}�������� ���������", "������", "������");
			}//��������� ����
			case 472, 473, 493, 595, 484, 430, 453, 452, 446, 454, 460:
			{//������ ����
		        modelid -= 400; new String[120];
				format(String,sizeof(String),"{AFAFAF}���������: {FFCC00}%s{AFAFAF} ���������: %d$",PlayerVehicleName[modelid], GetVehicleMaxSpeed(QuestCar[playerid]) * 500);
		        ShowPlayerDialog(playerid, DIALOG_STEALWATERCAR, 2, String, "{FFCC00}������ ���������{FFFFFF}\n������� ������ ����������� {007FFF}3{FFFFFF}-�� ������\n{FF0000}�������� ���������", "������", "������");
			}//������ ����
			default:
		    {//�������� ����
				modelid -= 400; new String[120];
				format(String,sizeof(String),"{AFAFAF}���������: {FFCC00}%s{AFAFAF} ���������: %d$",PlayerVehicleName[modelid], GetVehicleMaxSpeed(QuestCar[playerid]) * 500);
			    ShowPlayerDialog(playerid, DIALOG_STEALCAR, 2, String, "{FFCC00}������ ���������{FFFFFF}\n������� ������ ����������� {007FFF}1{FFFFFF}-�� ������\n������� ������ ����������� {007FFF}2{FFFFFF}-�� ������\n{FF0000}�������� ���������", "������", "������");
			}//�������� ����
        }//switch
    }//����� ����� Y ��� N ���� � �������� ������ (��������� ����� ������� �����)

	if(newkeys & KEY_FIRE || newkeys & KEY_SECONDARY_ATTACK || newkeys & KEY_ACTION)
	{//������ �����
		if (GetPlayerState(playerid) == 1 && Player[playerid][Slot9] == -1)
		{//����� ����� MixFight
			new rand = random(6);
			if (rand == 0){SetPlayerFightingStyle (playerid, FIGHT_STYLE_NORMAL);}
			if (rand == 1){SetPlayerFightingStyle (playerid, FIGHT_STYLE_BOXING);}
			if (rand == 2){SetPlayerFightingStyle (playerid, FIGHT_STYLE_KUNGFU);}
			if (rand == 3){SetPlayerFightingStyle (playerid, FIGHT_STYLE_KNEEHEAD);}
			if (rand == 4){SetPlayerFightingStyle (playerid, FIGHT_STYLE_GRABKICK);}
			if (rand == 5){SetPlayerFightingStyle (playerid, FIGHT_STYLE_ELBOW);}
		}//������ ����� MixFight
		if (InPeacefulZone[playerid] == 1 || AdminTPCantKill[playerid] > 0)
		{//� ������ ����
            if (GetPlayerState(playerid) == 1) {SetPlayerArmedWeapon(playerid,0); ApplyAnimation(playerid,"PED","KO_SKID_BACK",4.0,0,0,0,0,0,1);}//������
			if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER && InEvent[playerid] == 0)
			{//�� �����, �� � ������� (����� � ������ �� ���� �� ����������)
			    new model = GetVehicleModel(GetPlayerVehicleID(playerid));
			    if (model == 447 || model == 520 || model == 425 || model == 476 || model == 464 || model == 432 || model == 430)
				{
				    DestroyVehicle(GetPlayerVehicleID(playerid));
				    SendClientMessage(playerid, COLOR_RED, "������ ������� � ������ ����!");
				}
			}//�� �����, �� � ������� (����� � ������ �� ���� �� ����������)
		}//� ������ ����
		if (PrestigeGM[playerid] == 1)
		{//����� ����
		    if (GetPlayerState(playerid) == 1 && InEvent[playerid] == 0) ApplyAnimation(playerid,"PED","KO_SKID_BACK",4.0,0,0,0,0,0,1);//������ ������� ����-�� ��� ������ ����� ��� ������
            if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER  && InEvent[playerid] == 0)
			{
			    new model = GetVehicleModel(GetPlayerVehicleID(playerid));
			    if (model == 447 || model == 520 || model == 425 || model == 476 || model == 464 || model == 432 || model == 430)
				{
				    DestroyVehicle(GetPlayerVehicleID(playerid));
				    SendClientMessage(playerid,COLOR_RED,"������: ��������� ������������ ������� � ������ ����");
				}
			}
		}//����� ����
	}//������ �����
	
	if((newkeys & KEY_FIRE) && (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT || GetPlayerState(playerid) == PLAYER_STATE_PASSENGER))
	{//������ ��������
	    //AntiPlus
	    if (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) AntiPlus[playerid] = 2; //deagle, shotgun, sniper

		//---------------------- LAC �� ������
		new weaponid = GetPlayerWeapon(playerid);
		if(weaponid > 0 && weaponid < 46 && Weapons[playerid][weaponid] == 0 && Player[playerid][Banned] == 0)
		{
			new cheat = 1, String[140];
			if (LACWeaponOff[playerid] > 0) cheat = 0;//���� �����, ����� LAC �� �������
			if (cheat == 1)
			{//����� �����
				ResetPlayerWeapons(playerid); LSpawnPlayer(playerid); LACWeaponOff[playerid] = 3;
				LACPanic[playerid]++;//LAC v2.0
				format(String,sizeof(String), "[�������]LAC:{AFAFAF} %s[%d] �������� ���������� ��� �� ������",PlayerName[playerid], playerid);
				foreach(Player, cid) if (Player[cid][Admin] != 0 && Logged[cid] == 1) SendClientMessage(cid, COLOR_RED, String);
				SendClientMessage(playerid, -1,"{FF0000}LAC:{AFAFAF} �� ���� ������ ������������. {FF0000}�������: {AFAFAF}�������� ��� �� ������");
				format(String, 140, "%d.%d.%d a %d:%d:%d |   LAC: %s[%d] �������� ���������� ��� �� ������", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid);
				WriteLog("GlobalLog", String);WriteLog("LAC", String);
			}//����� �����
		}
		//---------------------- LAC �� ������

	}//������ ��������
	
	if(newkeys & KEY_CROUCH && GetPlayerState(playerid) == 1 && AntiPlus[playerid] > 0) ApplyAnimation(playerid,"PED","KO_SKID_BACK",4.0,0,0,0,0,0,1);


	if(newkeys & KEY_SECONDARY_ATTACK || newkeys & KEY_SPRINT)
	{//����� ����� - �����
		if (SkinChangeMode[playerid] == 1)
		{
			SavePlayer(playerid);TogglePlayerControllable(playerid,1);SkinChangeMode[playerid] = 0;
			SetPlayerVirtualWorld(playerid,0);LSpawnPlayer(playerid);
			TextDrawHideForPlayer(playerid, SkinChangeTextDraw);TextDrawHideForPlayer(playerid, SkinIDTD[playerid]);
		}
	}//����� ����� - �����

	if(newkeys & KEY_WALK && GetPlayerState(playerid) == 1)
	{//����� ���� - ���, ����, ��������, ������, ������
	    new xOnce = 0;		
		//------ ����
		if (IsPlayerInRangeOfPoint(playerid,2,2316.6182,-7.2874,26.7422))
		{//����� � 2 ������ �� �����
		    //������������ ����. �����
		    new houseid = Player[playerid][Home];
			if (houseid <= 0) MaxBank[playerid] = 50000000;//���� 50 ��� ���� � ������ ��� ����
			else if (Property[houseid][pPrice] >= 80000000) MaxBank[playerid] = 999999999; //��� �� 80�� - 999��
			else if (Property[houseid][pPrice] >= 60000000) MaxBank[playerid] = 400000000; //��� �� 60�� - 400��
			else if (Property[houseid][pPrice] >= 40000000) MaxBank[playerid] = 250000000; //��� �� 40�� - 250��
			else if (Property[houseid][pPrice] >= 20000000) MaxBank[playerid] = 150000000; //��� �� 20�� - 150��
			else MaxBank[playerid] = 100000000; //��� �� 10�� - 100��
            //������������ ����. �����
			new String[120];xOnce = 1;
			format(String,sizeof(String),"{AFAFAF}����. �� �����: {00FF00}%d{AFAFAF}. ��������: {FFFFFF}%d{AFAFAF}.",Player[playerid][Bank],MaxBank[playerid]);
			ShowPlayerDialog(playerid, DIALOG_BANK, 2, String, "�������� ������ �� ����\n����� ������ �� �����\n{AFAFAF}(?) ��� ��������� �������� ����� � �����", "��", "");
		}
		
		for(new i = 0; i < 6; i++)
		{//���� - ����
		    if (IsPlayerInRangeOfPoint(playerid,1.5,BANKENTERS[i][0],BANKENTERS[i][1],BANKENTERS[i][2]))
		    {//����� � ����� � ����
	        	if (Player[playerid][Banned] != 0) return 1;//���������� �� �������
		        GetPlayerPos(playerid,InteriorEnterX[playerid],InteriorEnterY[playerid],InteriorEnterZ[playerid]);
			    GetPlayerFacingAngle(playerid,InteriorEnterA[playerid]);
			    SetPlayerPos(playerid,2304.6858,-16.2069,26.7422); SetPlayerFacingAngle(playerid, 270);
			    SetCameraBehindPlayer(playerid);xOnce = 1;
			    InPeacefulZone[playerid] = 1;
		    }//����� � ����� � ����
		}//���� - ����
		
		if (IsPlayerInRangeOfPoint(playerid,1.5,2304.6858,-16.2069,26.7422))
		{//���� - �����
		    if (InteriorEnterX[playerid] != 0 && InteriorEnterY[playerid] != 0 && InteriorEnterZ[playerid] != 0)
		    {//����� ������� � ��������, � ������ ������ ����� �����
		        if (Player[playerid][Banned] != 0) return 1;//���������� �� �������
			    SetPlayerPos(playerid,InteriorEnterX[playerid],InteriorEnterY[playerid],InteriorEnterZ[playerid]);
				SetPlayerFacingAngle(playerid,InteriorEnterA[playerid] - 180);
				SetPlayerInterior(playerid, 0);SetCameraBehindPlayer(playerid);
	            InteriorEnterX[playerid] = 0; InteriorEnterY[playerid] = 0; InteriorEnterZ[playerid] = 0;
	            xOnce = 1; InPeacefulZone[playerid] = 0;
            }//����� ������� � ��������, � ������ ������ ����� �����
		}//���� - �����		
		
		if (IsPlayerInRangeOfPoint(playerid,2,2324.4902,-1149.5474,1050.7101) || IsPlayerInRangeOfPoint(playerid,2,243.7173,304.9818,999.1484) || IsPlayerInRangeOfPoint(playerid,2,2218.4033,-1076.2634,1050.4844) || IsPlayerInRangeOfPoint(playerid,2,2365.3140,-1135.5983,1050.8826) || IsPlayerInRangeOfPoint(playerid,2,2496.0002,-1692.0852,1014.7422) || IsPlayerInRangeOfPoint(playerid,2,2270.4172,-1210.4956,1047.5625))
		{//����� �� ����
		    if (Player[playerid][Banned] != 0) return 1;//���������� �� �������
			new houseid = GetPlayerVirtualWorld(playerid) - 1000;
			SetPlayerPos(playerid, Property[houseid][pPosEnterX], Property[houseid][pPosEnterY],Property[houseid][pPosEnterZ]);
			SetPlayerFacingAngle(playerid, Property[houseid][pPosEnterA] - 180.0);
			SetPlayerVirtualWorld(playerid,0);SetPlayerInterior(playerid,0);
            InPeacefulZone[playerid] = 0;
			SetCameraBehindPlayer(playerid); return 1;
		}//����� �� ����
		
		if (IsPlayerInRangeOfPoint(playerid,2,2332.5144,-1144.4189,1054.3047) || IsPlayerInRangeOfPoint(playerid,2,2215.7893,-1074.6979,1050.4844) || IsPlayerInRangeOfPoint(playerid,2,2363.7717,-1127.3329,1050.8826) || IsPlayerInRangeOfPoint(playerid,2,2492.4016,-1708.5626,1018.3368) || IsPlayerInRangeOfPoint(playerid,2,2262.7871,-1216.8030,1049.0234))
		{//����� ����� � ����
		    SetPlayerPos(playerid,681.4626,-450.8589,-25.6172);SetPlayerFacingAngle(playerid,-180.0);
			SetPlayerInterior(playerid,1);SetPlayerVirtualWorld(playerid,playerid + 1);
			SetPlayerCameraPos(playerid,681.4331,-454.7023,-24.5537);SetPlayerCameraLookAt(playerid,681.4626,-450.8589,-25.1172);
			TogglePlayerControllable(playerid,0);SkinChangeMode[playerid] = 1;SetPlayerArmedWeapon(playerid, 0);
			new String[10];format (String,sizeof(String),"Skin: %d",Player[playerid][Model]);TextDrawSetString(SkinIDTD[playerid], String);
			TextDrawShowForPlayer(playerid, SkinChangeTextDraw);TextDrawShowForPlayer(playerid, SkinIDTD[playerid]);
            xOnce = 1;
		}//����� ����� � ����

		if (IsPlayerInRangeOfPoint(playerid,2, 774.0399, -78.7388, 1000.6627) || IsPlayerInRangeOfPoint(playerid,2, 774.0266, -50.3715, 1000.5859) || IsPlayerInRangeOfPoint(playerid,2, 1727.0281, -1637.9517, 20.2230) || IsPlayerInRangeOfPoint(playerid,2, -2636.4778, 1402.5682, 906.4609))
		{//����� �� �����
		    if (Player[playerid][Banned] != 0) return 1;//���������� �� �������
			new baseid = GetPlayerVirtualWorld(playerid) - 2000;
			if (baseid > 0 && baseid <= MAX_BASE)
			{//���������� ID �����
				SetPlayerPos(playerid, Base[baseid][bPosEnterX], Base[baseid][bPosEnterY], Base[baseid][bPosEnterZ]);
				SetPlayerFacingAngle(playerid, Base[baseid][bPosEnterA] - 180.0);
				SetPlayerVirtualWorld(playerid,0);SetPlayerInterior(playerid,0);
                InPeacefulZone[playerid] = 0;
				SetCameraBehindPlayer(playerid); return 1;
			}//���������� ID �����
		}//����� �� �����

		for(new i = 0; i < 4; i++)
		{//�������� ������
		    if (IsPlayerInRangeOfPoint(playerid,1.5,CLOTHESENTERS[i][0],CLOTHESENTERS[i][1],CLOTHESENTERS[i][2]))
		    {//����� � �������� ������
        		if (Player[playerid][Cash] < 10000) return SendClientMessage(playerid,COLOR_RED,"������: ��� ����� 10 000$ ����� ����� � ������� ������!");
				Player[playerid][Cash] -= 10000;SendClientMessage(playerid,COLOR_YELLOW,"�� ��������� 10 000$ �� ���� � ������� ������. �������� ������ ���������..");
				SetPlayerPos(playerid,681.4626,-450.8589,-25.6172);SetPlayerFacingAngle(playerid,-180.0);
				SetPlayerInterior(playerid,1);SetPlayerVirtualWorld(playerid,playerid + 1);
				SetPlayerCameraPos(playerid,681.4331,-454.7023,-24.5537);SetPlayerCameraLookAt(playerid,681.4626,-450.8589,-25.1172);
				TogglePlayerControllable(playerid,0);SkinChangeMode[playerid] = 1;SetPlayerArmedWeapon(playerid, 0);
				new String[10];format (String,sizeof(String),"Skin: %d",Player[playerid][Model]);TextDrawSetString(SkinIDTD[playerid], String);
				TextDrawShowForPlayer(playerid, SkinChangeTextDraw);TextDrawShowForPlayer(playerid, SkinIDTD[playerid]);
			    xOnce = 1;
		    }//����� � �������� ������
		}//�������� ������
		
		if (IsPlayerInRangeOfPoint(playerid,1.5,1962.3420,1009.6814,992.4688) || IsPlayerInRangeOfPoint(playerid,1.5,1958.0320,1009.6746,992.4688) || IsPlayerInRangeOfPoint(playerid,1.5,1962.3417,1025.3008,992.4688) || IsPlayerInRangeOfPoint(playerid,1.5,1958.0321,1025.2384,992.4688))
		{//������ - �������
		    if (Player[playerid][CasinoBalance] >= 100000000 && Player[playerid][Prestige] < 9) return SendClientMessage(playerid, COLOR_RED, "����������! ���� ����� �� ����!");
   			new String[180], MaxBet; xOnce = 1;
   			if (Player[playerid][Level] < 39) MaxBet = 100000; //1 - 38 ���: 100 000$
   			else if (Player[playerid][Level] < 53) MaxBet = 250000; //39 - 52 ���: 250 000$
   			else if (Player[playerid][Level] < 66) MaxBet = 500000; //53 - 65 ���: 500 000$
   			else MaxBet = 1000000; //66+ ���: 1 000 000$
   			if (Player[playerid][Prestige] >= 9) MaxBet = 100000000; //������� 8: 100 000 000$
			format(String,sizeof(String),"{AFAFAF}������������ ������: {FFFFFF}%d", MaxBet);
			ShowPlayerDialog(playerid, DIALOG_CASINORULET, 2, String, "{FFFFFF}��������� �� {FF0000}�������\n{FFFFFF}��������� �� {AFAFAF}������\n{FFFFFF}��������� �� {FFFF00}1-12\n{FFFFFF}��������� �� {FFFF00}13-24\n{FFFFFF}��������� �� {FFFF00}25-36\n{FFFFFF}��������� �� {FFFF00}�����", "��", "������");
		}//������ - �������
		
		if (IsPlayerInRangeOfPoint(playerid,1.5,1954.1530,995.4341,992.8594))
		{//������ - ������� �����
		    new String[140], randaction = random(3), randvalue; xOnce = 1;
		    if (Player[playerid][BuddhaTime] > 0)
		    {
		        format(String, sizeof String, "������� ����� ����� �������� ����� %d �����", Player[playerid][BuddhaTime]/60 + 1);
		        return SendClientMessage(playerid, COLOR_RED, String);
		    }
			Player[playerid][BuddhaTime] = 1800;
			if (randaction == 0)
			{//������������� ��������
				randvalue = random(50000) + 1;//�� 1 �� 50 000
				Player[playerid][Cash] -= randvalue; SavePlayer(playerid);
				format(String,sizeof(String),"������� �����: �� �������� {FFFFFF}%d{FF0000}$", randvalue);
                SendClientMessage(playerid, COLOR_RED, String);
                format(String, sizeof String, "-%d$", randvalue); SetPlayerChatBubble(playerid, String, COLOR_RED, 50.0, 3000);
			}//������������� ��������
			else if (randaction == 1)
			{//������������� �������� - ������
				randvalue = random(200000) + 50000;//�� 50 000 �� 250 000
				Player[playerid][Cash] += randvalue; SavePlayer(playerid);
				format(String,sizeof(String),"������� �����: �� �������� {FFFFFF}%d{FFCC00}$", randvalue);
                SendClientMessage(playerid, COLOR_QUEST, String);
                format(String, sizeof String, "+%d$", randvalue); SetPlayerChatBubble(playerid, String, COLOR_GREEN, 50.0, 3000);
			}//������������� �������� - ������
			else if (randaction == 2)
			{//������������� �������� - XP
				randvalue = random(400) + 100;//�� 100 �� 500
				format(String,sizeof(String),"������� �����: �� �������� {FFFFFF}%d{FFCC00} XP", randvalue);
				SendClientMessage(playerid, COLOR_QUEST, String);
				LGiveXP(playerid, randvalue); SavePlayer(playerid);
				format(String, sizeof String, "+%d XP", randvalue); SetPlayerChatBubble(playerid, String, COLOR_YELLOW, 50.0, 3000);
			}//������������� �������� - XP
		}//������ - ������� �����
		
		if (IsPlayerInRangeOfPoint(playerid,1.5,1958.3613,953.2741,10.8203))
		{//������ - ���� �����
		    if (Player[playerid][Banned] != 0) return 1;//���������� �� �������
		    SetPlayerPos(playerid, 1963.7800,972.4600,994.4688);
		    SetPlayerFacingAngle(playerid, 30); SetPlayerInterior(playerid, 10);
		    SetCameraBehindPlayer(playerid); SetPlayerVirtualWorld(playerid, 10); xOnce = 1;
            InPeacefulZone[playerid] = 1;
		}//������ - ���� �����
		
		if (IsPlayerInRangeOfPoint(playerid,1.5,1963.7800,972.4600,994.4688))
		{//������ - ����� �����
		    if (Player[playerid][Banned] != 0) return 1;//���������� �� �������
		    SetPlayerPos(playerid, 1958.3613,953.2741,10.82030);
		    SetPlayerFacingAngle(playerid, 176); SetPlayerInterior(playerid, 0);
		    SetCameraBehindPlayer(playerid); SetPlayerVirtualWorld(playerid, 0); xOnce = 1;
            InPeacefulZone[playerid] = 0;
		}//������ - ����� �����
		
		if (IsPlayerInRangeOfPoint(playerid,1.5,2019.3174,1007.8547,10.8203))
		{//������ - ���� �����������
		    if (Player[playerid][Banned] != 0) return 1;//���������� �� �������
		    SetPlayerPos(playerid, 2018.9702, 1017.8456, 996.8750);
		    SetPlayerFacingAngle(playerid, 90); SetPlayerInterior(playerid, 10);
		    SetCameraBehindPlayer(playerid); SetPlayerVirtualWorld(playerid, 10); xOnce = 1;
            InPeacefulZone[playerid] = 1;
		}//������ - ���� �����������
		
		if (IsPlayerInRangeOfPoint(playerid,1.5,2018.9702,1017.8456,996.8750))
		{//������ - ����� �����������
            if (Player[playerid][Banned] != 0) return 1;//���������� �� �������
		    SetPlayerPos(playerid, 2019.3174,1007.8547,10.8203);
		    SetPlayerFacingAngle(playerid, 270); SetPlayerInterior(playerid, 0);
		    SetCameraBehindPlayer(playerid); SetPlayerVirtualWorld(playerid, 0); xOnce = 1;
            InPeacefulZone[playerid] = 0;
		}//������ - ����� �����������
		
		if (IsPlayerInRangeOfPoint(playerid,1.5,1944.2803,1076.0552,10.8203))
		{//������ - ���� ������
		    if (Player[playerid][Banned] != 0) return 1;//���������� �� �������
		    SetPlayerPos(playerid, 1963.6882,1063.2550,994.4688);
		    SetPlayerFacingAngle(playerid, 180); SetPlayerInterior(playerid, 10);
		    SetCameraBehindPlayer(playerid); SetPlayerVirtualWorld(playerid, 10); xOnce = 1;
            InPeacefulZone[playerid] = 1;
		}//������ - ���� ������

		if (IsPlayerInRangeOfPoint(playerid,1.5,1963.6882,1063.2550,994.4688))
		{//������ - ����� ������
		    if (Player[playerid][Banned] != 0) return 1;//���������� �� �������
		    SetPlayerPos(playerid, 1944.2803,1076.0552,10.8203);
		    SetPlayerFacingAngle(playerid, 0); SetPlayerInterior(playerid, 0);
		    SetCameraBehindPlayer(playerid); SetPlayerVirtualWorld(playerid, 0); xOnce = 1;
            InPeacefulZone[playerid] = 0;
		}//������ - ����� ������

		if (IsPlayerInRangeOfPoint(playerid,1.5,1451.6349,-2287.0703,13.5469) || IsPlayerInRangeOfPoint(playerid,2,-1404.6575,-303.7458,14.1484) || IsPlayerInRangeOfPoint(playerid,2,1672.9861,1447.9349,10.7868) || IsPlayerInRangeOfPoint(playerid,2,2315.5173,0.3555,26.7422))
		{//��������
		    if (InEvent[playerid] == 0)
		    {//����� �� �� �������������
			    if (GetPlayerVirtualWorld(playerid) == 0) ShowPlayerDialog(playerid, DIALOG_AIRPORT, 2, "��������. ��������� ��������: 50 000$", "{FFFFFF}��� ������\n��� ������\n��� ��������", "��", "������");
				else SendClientMessage(playerid,COLOR_RED,"������: �������� �������� ������ � ����� ����.");
			}//����� �� �� �������������
            xOnce = 1;
		}//��������
		
		if (IsPlayerInRangeOfPoint(playerid,2,2397.7632,-1899.1389,13.5469) && QuestActive[playerid] == 0 && InEvent[playerid] == 0)
		{//������ - ��������� �����
            WorkPizzaID[playerid] = random(8) + 1; WorkPizzaCP[playerid] = 0; xOnce = 1;
		    QuestCar[playerid] = LCreateVehicle(448, 2386.8760, -1921.9377, 12.9784, 270.0, 3, 3, 0);
			PutPlayerInVehicle(playerid,QuestCar[playerid], 0); QuestActive[playerid] = 2; WorkTime[playerid] = 0;
			SendClientMessage(playerid, COLOR_QUEST, "������: ������� ������� ����� {FF0000}��������{FFCC00} � ������� �� ���������!");
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
		}//������ - ��������� �����
		
		//������ - ������� (�����)
        if (QuestActive[playerid] == 3){xOnce = 1; ShowPlayerDialog(playerid,DIALOG_WORKGRUZSTOP,0,"������� - ��������� ������?","{FFFFFF}��������� ������ ���������?","��","������");}
        //������ - ���������� �����, ��������� (����� ������� ��������� � ����� ����)
        if (QuestActive[playerid] == 2 || QuestActive[playerid] >= 4){xOnce = 1; ShowPlayerDialog(playerid,DIALOG_WORKSTOP,2,"������","������� ������� ���������\n{FF0000}��������� ������","��","������");}

		if (IsPlayerInRangeOfPoint(playerid,2, 2729.3267, -2451.4578, 17.5937) && QuestActive[playerid] == 0 && InEvent[playerid] == 0)// ��������� ���������� ������ � ������ ������ ������
        {//������ - ������� (�����)
            SendClientMessage(playerid, COLOR_QUEST, "������: ���� {FF0000}����{FFCC00} � �������� ��� � ����� ����������!");
			QuestActive[playerid] = 3; WorkTime[playerid] = 0; WorkTimeGruz[playerid] = 0; xOnce = 1;
            SetPVarInt(playerid,"WorkStage",1);// ������������� ������ ������, 1 - ��� ����� ����. 2 - ���� ����.
            new checkp = random(sizeof GRUZFROM);// �������� ����� ���������� ��� ����� ����
            ApplyAnimation(playerid,"CARRY","Null",4.1,0,1,1,1,1);//���������� ���������� � ����������
            SetPlayerCheckpoint(playerid,GRUZFROM[checkp][0],GRUZFROM[checkp][1],GRUZFROM[checkp][2],1.5);// ������ ���� �� ����������
        }//������ - ������� (�����)
        
        if (IsPlayerInRangeOfPoint(playerid,2,-1972.5024,-1020.2568,32.1719) && QuestActive[playerid] == 0 && InEvent[playerid] == 0)
		{//������ - ��������
		    if (Player[playerid][Level] < 14) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 14-�� ������ ����� �������� ����������!");
            new rand = random(MAX_PROPERTY); if (rand == 0) rand++;//�������� ��� ��� ����������
            if (rand == Player[playerid][Home]) {if (rand > 1) rand--; else rand++;}//�������� ��� ��������� - ����������
            SetPVarInt(playerid, "WorkDomStage", 1); QuestActive[playerid] = 4; WorkTime[playerid] = 0; xOnce = 1;
		    QuestCar[playerid] = LCreateVehicle(609, -1945.5354,-1085.3024,30.8479, 0.0, 25, 25, 0); PutPlayerInVehicle(playerid,QuestCar[playerid], 0);
			SendClientMessage(playerid, COLOR_QUEST, "������: ������� {FF0000}���{FFCC00} � ������� ������������ ����!");
            SetPlayerCheckpoint(playerid,Property[rand][pPosEnterX],Property[rand][pPosEnterY],Property[rand][pPosEnterZ],2);
		}//������ - ��������
		
		if (IsPlayerInRangeOfPoint(playerid,2,-1061.6104,-1195.4755,129.8281) && QuestActive[playerid] == 0 && InEvent[playerid] == 0)
		{//������ - ���������
		    if (Player[playerid][Level] < 21) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 21-�� ������ ����� �������� �����������!");
			new Float: wx = random(20) - 10 - 1096, Float: wy = random(20) - 10 - 992, Float: wz = 130, Float:wa = random(360);
		    QuestCar[playerid] = LCreateVehicle(532, wx, wy, wz, wa, 25, 25, 0); PutPlayerInVehicle(playerid,QuestCar[playerid], 0);
            QuestActive[playerid] = 5; WorkTime[playerid] = 0; xOnce = 1;
			SendClientMessage(playerid, COLOR_QUEST, "������: ��������� �� {FF0000}����{FFCC00} � ���� ���!");
            GangZoneShowForPlayer(playerid, WorkZoneCombine, 0xFF000080);
		}//������ - ���������
		
		if (IsPlayerInRangeOfPoint(playerid,2,2484.6682,-2120.8743,13.5469) && QuestActive[playerid] == 0 && InEvent[playerid] == 0)
		{//������ - ������������
		    if (Player[playerid][Level] < 28) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 28-�� ������ ����� �������� ��������������!");
            new rand = random(sizeof WORKTRUCK);//�������� ����� �������� �����
            SetPlayerCheckpoint(playerid,WORKTRUCK[rand][0], WORKTRUCK[rand][1], WORKTRUCK[rand][2], 10);
	        SetPVarInt(playerid, "WorkTruckStage", 1); QuestActive[playerid] = 6; WorkTime[playerid] = 0; xOnce = 1;
		    QuestCar[playerid] = LCreateVehicle(515, 2453.7183, -2089.3940, 15.2, 90.0, 4, 4, 0); PutPlayerInVehicle(playerid,QuestCar[playerid], 0);
			CallTrailer(QuestCar[playerid], 584);
			SendClientMessage(playerid, COLOR_QUEST, "������: ������� ���� �� {FF0000}����� ����������{FFCC00} � ������� �� ���������!");
		}//������ - ������������
		
		if (IsPlayerInRangeOfPoint(playerid,2,-1713.1389,-61.8556,3.5547) && QuestActive[playerid] == 0 && InEvent[playerid] == 0)
		{//������ - ������� �������
		    if (Player[playerid][Level] < 35) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 35-�� ������ ����� �������� ��������� �������!");
            new rand = random(sizeof WORKWATER);//�������� ����� �������� �����
            SetPlayerCheckpoint(playerid,WORKWATER[rand][0], WORKWATER[rand][1], WORKWATER[rand][2], 10);
	        SetPVarInt(playerid, "WorkWaterStage", 1); QuestActive[playerid] = 7; WorkTime[playerid] = 0; xOnce = 1;
		    QuestCar[playerid] = LCreateVehicle(452, -1759.8169,-192.7360,0.5, 270.0, 1, 2, 0); PutPlayerInVehicle(playerid,QuestCar[playerid], 0);
			SendClientMessage(playerid, COLOR_QUEST, "������: ������� ���� �� {FF0000}����� ����������{FFCC00} � ������� �� ���������!");
		}//������ - ������� �������
		
		if (IsPlayerInRangeOfPoint(playerid,2,2364.8955,2382.8770,10.8203) && QuestActive[playerid] == 0 && InEvent[playerid] == 0)
		{//������ - ����������
		    if (Player[playerid][Level] < 42) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 42-�� ������ ����� �������� ������������!");
            new rand = random(MAX_BASE); if (rand == 0) rand++;//�������� ���� ��� ����� �����
            SetPVarInt(playerid, "WorkBankStage", 1); QuestActive[playerid] = 8; WorkTime[playerid] = 0; xOnce = 1;
		    QuestCar[playerid] = LCreateVehicle(428, 2361.7593,2397.3511,10.9471, 0.0, 227, 4, 0); PutPlayerInVehicle(playerid,QuestCar[playerid], 0);
			SendClientMessage(playerid, COLOR_QUEST, "������: ������ ������ �� {FF0000}�����{FFCC00} � ������� �� ����!");
            SetPlayerCheckpoint(playerid,Base[rand][bPosEnterX],Base[rand][bPosEnterY],Base[rand][bPosEnterZ],2);
		}//������ - ����������
		
		if (xOnce == 0 && SkinChangeMode[playerid] == 0)
		{//���� �������� �������
		    if (InEvent[playerid] == 0)
		    {//����� �� � �������������
				if (Player[playerid][Level] > 0) ShowPlayerDialog(playerid, 2, 2, "���� �������� �������", "����� � ������ [����� 1]\n����� � ������ [����� 2]\n����� � ������ [����� 3]\n������ JetPack (/jetpack)\n�������� � ��������� (/skydive)\n{FF0000}GPS (/gps){FFFFFF}\n�������� ��� ����������\n�������� ��� ������\n��������� PvP\n{FFFF00}������� ���", "��", "");
				else ShowPlayerDialog(playerid, 2, 2, "���� �������� �������", "����� � ������ [����� 1]", "��", "");
			}//����� �� � �������������
			if (JoinEvent[playerid] == EVENT_RACE && TimeTransform[playerid] == 0)
			{//����� ���������� � ������� �����
			    new Float: x, Float: y, Float: z, Float: Angle, col1 = random(187), col2 = random(187);
			    GetPlayerPos(playerid,x,y,z);GetPlayerFacingAngle(playerid, Angle);
			    FRCarID[playerid] = LCreateVehicle(FRModelCar, x, y, z, Angle, col1, col2, 0);
				SetVehicleVirtualWorld(FRCarID[playerid], 661);PutPlayerInVehicle(playerid, FRCarID[playerid], 0);
                new rand = random(3);ChangeVehiclePaintjob(GetPlayerVehicleID(playerid), rand);//��������� paintjob
				//���� ��������� �����
				new engine, lights, alarm, doors, bonnet, boot, objective; TimeTransform[playerid] = 5;
			    GetVehicleParamsEx(FRCarID[playerid], engine, lights, alarm, doors, bonnet, boot, objective);
			    SetVehicleParamsEx(FRCarID[playerid], engine, lights, alarm, true, bonnet, boot, objective);
                SendClientMessage(playerid,COLOR_CYAN,"���������: ���� ���� ������ ������������� � �����, ����������� ������� ����� ����� ��������� �� �� ������");
			}//����� ���������� � ������� �����
			if (JoinEvent[playerid] == EVENT_XRACE && TimeTransform[playerid] == 0)
			{//����� ���������� � ����������� �����
			    new Float: x, Float: y, Float: z, Float: Angle, col1 = random(187), col2 = random(187);
				GetPlayerPos(playerid,x,y,z);GetPlayerFacingAngle(playerid, Angle);
				XRCarID[playerid] = LCreateVehicle(XRPlayerCar[playerid], x, y, z, Angle, col1, col2, 0);
				SetVehicleVirtualWorld(XRCarID[playerid], 700);PutPlayerInVehicle(playerid, XRCarID[playerid], 0);
                new rand = random(3);ChangeVehiclePaintjob(GetPlayerVehicleID(playerid), rand);//��������� paintjob
				//���� ��������� �����
				new engine, lights, alarm, doors, bonnet, boot, objective; TimeTransform[playerid] = 5;
			    GetVehicleParamsEx(XRCarID[playerid], engine, lights, alarm, doors, bonnet, boot, objective);
			    SetVehicleParamsEx(XRCarID[playerid], engine, lights, alarm, true, bonnet, boot, objective);
			}//����� ���������� � ����������� �����
		}//���� �������� �������
		SendCommand(playerid, "/house", ""); SendCommand(playerid, "/base", "");//------ ���, ����
	}//����� ���� - ����, ���, ����, �������, ��������
	
    if(QuestActive[playerid] == 3 && GetPVarInt(playerid,"WorkStage") == 2)
    {//�������, ������� ����
    	if(newkeys == KEY_SECONDARY_ATTACK || newkeys == KEY_JUMP || newkeys == KEY_SECONDARY_ATTACK || newkeys == KEY_FIRE || newkeys == KEY_CROUCH)
        {//������� ����
        	RemovePlayerAttachedObject(playerid,0);// ������� ������ �� ���
            ApplyAnimation(playerid,"PED","IDLE_tired",4.1,0,1,1,0,1);// �������� ��������
            SetPVarInt(playerid,"WorkStage",1);// ������������� ������ ������ ������ �� 1..
            new checkp = random(sizeof GRUZFROM);
            SetPlayerCheckpoint(playerid,GRUZFROM[checkp][0],GRUZFROM[checkp][1],GRUZFROM[checkp][2],1.5);// ������ ���� �� ����������
        }//������� ����
    }//�������, ������� ����

	//moto nitro
 	if (PRESSED(KEY_FIRE)  || PRESSED(KEY_ACTION))
	{//������ �����
		 if (((Player[playerid][CarActive] == 1 && Player[playerid][CarSlot1NitroX] >= 2) || (Player[playerid][CarActive] == 2 && Player[playerid][CarSlot2NitroX] >= 2)) && InEvent[playerid] == 0 && QuestActive[playerid] == 0)
		 {//UberNitro ����� 1, 2
		    if (UberNitroTime[playerid] > 0)
		    {//UberNitro ��� ����������
		        new StringZ[20];
				format(StringZ, sizeof StringZ, "~R~%d sec", UberNitroTime[playerid]);
		        GameTextForPlayer(playerid, StringZ, 1000, 6);
		    }//UberNitro ��� ����������
		    else
		    {//UberNitro ��������
		        new vehicleid = GetPlayerVehicleID(playerid), MaxSpeed = GetVehicleMaxSpeed(vehicleid);
		        if (MaxSpeed > 250) MaxSpeed = 250;//��� ���������� � ��, ��� ����. �������� 300
				SetVehicleSpeed(vehicleid, MaxSpeed);
				LastSpeed[playerid] = MaxSpeed; LACSH[playerid] = 3; UberNitroTime[playerid] = 5;
				SetPlayerChatBubble(playerid, "����������� UberNitro", COLOR_GREEN, 300.0, 3000);
			}//UberNitro ��������
		}//UberNitro ����� 1, 2
	}//������ �����
	
	//ubervortex
	if (Player[playerid][Level] >= 90 && Player[playerid][CarActive] == 3)
	{//ubervortex
		new vehid = GetPlayerVehicleID(playerid);
		new model = GetVehicleModel(vehid);
		if(model == 539)
		{//ubervortex
			if (PRESSED(KEY_SUBMISSION))
			{//2 - �����
			    new Float:Velocity[3];
				GetVehicleVelocity(vehid, Velocity[0], Velocity[1], Velocity[2]);
				SetVehicleVelocity(vehid, Velocity[0], Velocity[1], Velocity[2] + 0.25);
				NeedSpeedDown[playerid] = 1;LACTeleportOff[playerid] = 3;
			}//2 - �����
			if (PRESSED(KEY_CROUCH))
			{//H - �����������
			    new Float:Velocity[3];
				GetVehicleVelocity(vehid, Velocity[0], Velocity[1], Velocity[2]);
				SetVehicleVelocity(vehid, Velocity[0], Velocity[1], Velocity[2] - 0.25);
				LastSpeed[playerid] = 999;LACSH[playerid] = 10;LACTeleportOff[playerid] = 3;
			}//H - �����������
   			if (newkeys & KEY_FIRE || newkeys & KEY_ACTION)
			{//���� - ���������
			    new Float:Velocity[3];
				GetVehicleVelocity(vehid, Velocity[0], Velocity[1], Velocity[2]);
				if(Velocity[0] < 4  && Velocity[1] < 4 && Velocity[0] > -4 && Velocity[1] > -4)
				{
					SetVehicleVelocity(vehid, Velocity[0]*2, Velocity[1]*2, Velocity[2] * 0.8);
					NeedSpeedDown[playerid] = 1; LACSH[playerid] = 5;LACTeleportOff[playerid] = 3;
				}
			}//���� - ���������
		}
	}//ubervortex

	if(PRESSED(KEY_SUBMISSION) && Player[playerid][CarActive] == 1 && Player[playerid][ActiveSkillCar1] > 0 &&  JumpTime[playerid] == 0 && LSpecID[playerid] == -1 && InEvent[playerid] == 0 && QuestActive[playerid] == 0)
	{//������ ���� ������ 1
	    new vehid = GetPlayerVehicleID(playerid);new Float:Velocity[3];
	    if (Player[playerid][ActiveSkillCar1] == 1)
	    {//�������� �� 180
	         new Float: vang;GetVehicleZAngle(vehid, vang);SetVehicleZAngle(vehid, vang - 180.0);
	         GetVehicleVelocity(vehid, Velocity[0], Velocity[1], Velocity[2]);SetVehicleVelocity(vehid, Velocity[0] * -1, Velocity[1] * -1, Velocity[2] * -1);
	         SetPlayerChatBubble(playerid, "����������� �����", COLOR_GREEN, 100.0, 3000);
	         JumpTime[playerid] = 3;SetCameraBehindPlayer(playerid);
	    }//�������� �� 180
	    if (Player[playerid][ActiveSkillCar1] == 2)
	    {//������
	         GetVehicleVelocity(vehid, Velocity[0], Velocity[1], Velocity[2]);SetVehicleVelocity(vehid, Velocity[0], Velocity[1], Velocity[2] + 0.5);
	         SetPlayerChatBubble(playerid, "����������� �����", COLOR_GREEN, 100.0, 3000);
	         JumpTime[playerid] = 3;LACSH[playerid] = 5;LACTeleportOff[playerid] = 3;
	    }//������
	    if (Player[playerid][ActiveSkillCar1] == 3)
	    {//��������
	         new Float:x, Float:y, Float:z, Float:angle;GetPlayerPos(playerid, x, y, z);
		     angle = GetXYInFrontOfPlayer(playerid, x, y, GetOptimumRampDistance(playerid));
		 	 rampid[playerid] = CreateDynamicObject(1632, x, y, z, 0.0, 0.0, angle, GetPlayerVirtualWorld(playerid), -1, -1, 300.0);//����������� ���������
	         SetTimerEx("RemoveRamp", 2000, 0, "d", playerid);
			 SetPlayerChatBubble(playerid, "����������� �����", COLOR_GREEN, 100.0, 3000);JumpTime[playerid] = 3;
	    }//��������
	    
	}//������ ���� ������ 1
	
	if(PRESSED(KEY_SUBMISSION) && Player[playerid][CarActive] == 2 && Player[playerid][ActiveSkillCar2] > 0 &&  JumpTime[playerid] == 0 && LSpecID[playerid] == -1 && InEvent[playerid] == 0 && QuestActive[playerid] == 0)
	{//������ ���� ������ 2
	    new vehid = GetPlayerVehicleID(playerid);new Float:Velocity[3];
	    if (Player[playerid][ActiveSkillCar2] == 1)
	    {//�������� �� 180
	         new Float: vang;GetVehicleZAngle(vehid, vang);SetVehicleZAngle(vehid, vang - 180.0);
	         GetVehicleVelocity(vehid, Velocity[0], Velocity[1], Velocity[2]);SetVehicleVelocity(vehid, Velocity[0] * -1, Velocity[1] * -1, Velocity[2] * -1);
	         SetPlayerChatBubble(playerid, "����������� �����", COLOR_GREEN, 100.0, 3000);
	         JumpTime[playerid] = 4;SetCameraBehindPlayer(playerid);
	    }//�������� �� 180
	    if (Player[playerid][ActiveSkillCar2] == 2)
	    {//������
	         GetVehicleVelocity(vehid, Velocity[0], Velocity[1], Velocity[2]);SetVehicleVelocity(vehid, Velocity[0], Velocity[1], Velocity[2] + 0.5);
	         SetPlayerChatBubble(playerid, "����������� �����", COLOR_GREEN, 100.0, 3000);
	         JumpTime[playerid] = 4;LACSH[playerid] = 5;LACTeleportOff[playerid] = 3;
	    }//������
	    if (Player[playerid][ActiveSkillCar2] == 3)
	    {//��������
	         new Float:x, Float:y, Float:z, Float:angle;GetPlayerPos(playerid, x, y, z);
		     angle = GetXYInFrontOfPlayer(playerid, x, y, GetOptimumRampDistance(playerid));
		 	 rampid[playerid] = CreateDynamicObject(1632, x, y, z, 0.0, 0.0, angle, GetPlayerVirtualWorld(playerid), -1, -1, 300.0);//����������� ���������
	         SetTimerEx("RemoveRamp", 2000, 0, "d", playerid);
			 SetPlayerChatBubble(playerid, "����������� �����", COLOR_GREEN, 100.0, 3000);JumpTime[playerid] = 3;
	    }//��������
	}//������ ���� ������ 2
	
	if (Player[playerid][Level] >= 100 && PRESSED(KEY_NO) && !IsPlayerInAnyVehicle(playerid) && GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USEJETPACK)
	{//UberJetpack
     	new Float: x, Float: y, Float: z;GetPlayerVelocity(playerid,x,y,z);
	    SetPlayerVelocity(playerid,x*5,y*5,0.0);
		LACTeleportOff[playerid] = 5; LACPedSHOff[playerid] = 5;
	    SetPlayerChatBubble(playerid, "���������� ����������", COLOR_GREEN, 100.0, 3000);
	}//UberJetpack
	
	if (Player[playerid][ActiveSkillPerson] > 0)
	{//����� ���������
		if(PRESSED(KEY_NO) && !IsPlayerInAnyVehicle(playerid) && GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_USEJETPACK && SkillNTime[playerid] < 1 && InEvent[playerid] == 0 && QuestActive[playerid] == 0)
		{//�� N
		    if (Player[playerid][ActiveSkillPerson] == 1)
		    {//�� �� 50 ������
		        if (GetPlayerInterior(playerid) != 0 || IsPlayerInRangeOfPoint(playerid, 13.0, 2311.6953,-7.4206,26.7422)) return SendClientMessage(playerid,COLOR_RED,"������: �� ������ ���� �� �����, ����� ������������ ���� �����");
			    new Float: x, Float: y;GetXYInFrontOfPlayer(playerid,x,y,50.0);
			    SetPlayerPosFindZ(playerid, x, y, 3000.0);SkillNTime[playerid] = 5;
			    SetPlayerChatBubble(playerid, "����������� �����", COLOR_GREEN, 100.0, 3000);
		    }//�� �� 50 ������
		    if (Player[playerid][ActiveSkillPerson] == 2)
		    {//�� �� 100 ������
		        if (GetPlayerInterior(playerid) != 0 || IsPlayerInRangeOfPoint(playerid, 13.0, 2311.6953,-7.4206,26.7422)) return SendClientMessage(playerid,COLOR_RED,"������: �� ������ ���� �� �����, ����� ������������ ���� �����");
			    new Float: x, Float: y;GetXYInFrontOfPlayer(playerid,x,y,100.0);
			    SetPlayerPosFindZ(playerid, x, y, 3000.0);SkillNTime[playerid] = 5;
			    SetPlayerChatBubble(playerid, "����������� �����", COLOR_GREEN, 100.0, 3000);
		    }//�� �� 100 ������
		    if (Player[playerid][ActiveSkillPerson] == 3)
		    {//�� �� 300 ������
		        if (GetPlayerInterior(playerid) != 0 || IsPlayerInRangeOfPoint(playerid, 13.0, 2311.6953,-7.4206,26.7422)) return SendClientMessage(playerid,COLOR_RED,"������: �� ������ ���� �� �����, ����� ������������ ���� �����");
			    new Float: x, Float: y;GetXYInFrontOfPlayer(playerid,x,y,200.0);
			    SetPlayerPosFindZ(playerid, x, y, 3000.0);SkillNTime[playerid] = 5;
			    SetPlayerChatBubble(playerid, "����������� �����", COLOR_GREEN, 100.0, 3000);
		    }//�� �� 300 ������
		    if (Player[playerid][ActiveSkillPerson] == 4)
		    {//����� ���������
		        if (OnFly[playerid] == 0 && Player[playerid][Prestige] >= 8)//�������� �� 8 ������� ����� �.�. ������ �� ��� �� 2 ��������
				{
				    if (GetPlayerInterior(playerid) != 0 || IsPlayerInRangeOfPoint(playerid, 13.0, 2311.6953,-7.4206,26.7422)) return SendClientMessage(playerid,COLOR_RED,"������: �� ������ ���� �� �����, ����� ������������ ���� �����");
			    	else StartFly(playerid);
				}
				else StopFly(playerid);
		    }//����� ���������
		}//�� N
	}//����� ���������
		
	if(PRESSED(KEY_YES) && !IsPlayerInAnyVehicle(playerid) && Player[playerid][Prestige] >= 10 && SkillYTime[playerid] < 1 && InEvent[playerid] == 0)
	{//����� ����
		if (PrestigeGM[playerid] == 0){PrestigeGM[playerid] = 1;SendClientMessage(playerid,0x00FF00FF,"����� ���� �����������.");}
	    else ShowPlayerDialog(playerid, DIALOG_PRESTIGEGM, 2, "����� ����", "{FF0000}��������� ����� ����\n�������� � ������� GPS\n�������", "��", "������");
	}//����� ����

	if (Player[playerid][ActiveSkillHCar1] > 0 || Player[playerid][ActiveSkillHCar2] > 0)
	{//����� H ���� ����� 1
		if(PRESSED(KEY_CROUCH) && IsPlayerInAnyVehicle(playerid) && SkillHTime[playerid] < 1 && InEvent[playerid] == 0 && QuestActive[playerid] == 0)
		{//�� H
		    if (Player[playerid][CarActive] == 1)
		    {//����� 1
		        if (Player[playerid][ActiveSkillHCar1] == 1)
		        {//����������� ��������� �� ������
		        	new Float: aangle;
				    SkillHTime[playerid] = 5;SetPlayerChatBubble(playerid, "���������� ���������", COLOR_GREEN, 300.0, 3000);
				    GetVehicleZAngle(GetPlayerVehicleID(playerid), aangle);SetVehicleZAngle(GetPlayerVehicleID(playerid), aangle);
		            SendClientMessage(playerid,COLOR_GREEN,"�� ����������� ��� ��������� �� ������.");
		        }//����������� ��������� �� ������
			    if (Player[playerid][ActiveSkillHCar1] == 2)
			    {//�� �� 50 ������
			        if (GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"������: �� ������ ���� �� �����, ����� ������������ ���� �����");
				    new Float: x, Float: y;GetXYInFrontOfPlayer(playerid,x,y,50.0);
				    SetPlayerPosFindZ(playerid, x, y, 3000.0);SkillHTime[playerid] = 5;
				    SetPlayerChatBubble(playerid, "����������� �����", COLOR_GREEN, 100.0, 3000);
				    new CarClass = Player[playerid][CarActive];TimeTransform[playerid] = 0;
				    new S1 = -1, S2 = -1, S3 = -1;
				    foreach(Player, cid)
					{//����
						if(GetPlayerVehicleID(cid) == GetPlayerVehicleID(playerid) && GetPlayerVehicleSeat(cid) > 0)
						{//������ ����������
							if(GetPlayerVehicleSeat(cid) == 1){S1 = cid;}
							if(GetPlayerVehicleSeat(cid) == 2){S2 = cid;}
							if(GetPlayerVehicleSeat(cid) == 3){S3 = cid;}
						}//������ ����������
					}
	                SetTimerEx("PrestigeCarTP" , 500, false, "idiii", playerid, CarClass, S1, S2, S3);
	                TogglePlayerControllable(playerid,0);DestroyVehicle(PlayerCarID[playerid]);
			    }//�� �� 50 ������
			    if (Player[playerid][ActiveSkillHCar1] == 3)
			    {//�� �� 100 ������
			        if (GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"������: �� ������ ���� �� �����, ����� ������������ ���� �����");
	                new Float: x, Float: y;GetXYInFrontOfPlayer(playerid,x,y,100.0);
				    SetPlayerPosFindZ(playerid, x, y, 3000.0);SkillHTime[playerid] = 5;
				    SetPlayerChatBubble(playerid, "����������� �����", COLOR_GREEN, 100.0, 3000);
				    new CarClass = Player[playerid][CarActive];TimeTransform[playerid] = 0;
				    new S1 = -1, S2 = -1, S3 = -1;
				    foreach(Player, cid)
					{//����
						if(GetPlayerVehicleID(cid) == GetPlayerVehicleID(playerid) && GetPlayerVehicleSeat(cid) > 0)
						{//������ ����������
							if(GetPlayerVehicleSeat(cid) == 1){S1 = cid;}
							if(GetPlayerVehicleSeat(cid) == 2){S2 = cid;}
							if(GetPlayerVehicleSeat(cid) == 3){S3 = cid;}
						}//������ ����������
					}
	                SetTimerEx("PrestigeCarTP" , 500, false, "idiii", playerid, CarClass, S1, S2, S3);
	                TogglePlayerControllable(playerid,0);DestroyVehicle(PlayerCarID[playerid]);
			    }//�� �� 100 ������
			    if (Player[playerid][ActiveSkillHCar1] == 4)
			    {//�� �� 200 ������
			        if (GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"������: �� ������ ���� �� �����, ����� ������������ ���� �����");
	                new Float: x, Float: y;GetXYInFrontOfPlayer(playerid,x,y,200.0);
				    SetPlayerPosFindZ(playerid, x, y, 3000.0);SkillHTime[playerid] = 5;
				    SetPlayerChatBubble(playerid, "����������� �����", COLOR_GREEN, 100.0, 3000);
				    new CarClass = Player[playerid][CarActive];TimeTransform[playerid] = 0;
				    new S1 = -1, S2 = -1, S3 = -1;
				    foreach(Player, cid)
					{//����
						if(GetPlayerVehicleID(cid) == GetPlayerVehicleID(playerid) && GetPlayerVehicleSeat(cid) > 0)
						{//������ ����������
							if(GetPlayerVehicleSeat(cid) == 1){S1 = cid;}
							if(GetPlayerVehicleSeat(cid) == 2){S2 = cid;}
							if(GetPlayerVehicleSeat(cid) == 3){S3 = cid;}
						}//������ ����������
					}
	                SetTimerEx("PrestigeCarTP" , 500, false, "idiii", playerid, CarClass, S1, S2, S3);
	                TogglePlayerControllable(playerid,0);DestroyVehicle(PlayerCarID[playerid]);
			    }//�� �� 100 ������
			    if (Player[playerid][ActiveSkillHCar1] == 5)
			    {//�� �� 50 ������ �� ���������
			        if (GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"������: �� ������ ���� �� �����, ����� ������������ ���� �����");
				    new Float: x, Float: y;GetXYInFrontOfPlayer(playerid,x,y,50.0);
				    SetPlayerPosFindZ(playerid, x, y, 3000.0);SkillHTime[playerid] = 5;
				    SetPlayerChatBubble(playerid, "����������� �����", COLOR_GREEN, 100.0, 3000);
				    new CarClass = Player[playerid][CarActive];TimeTransform[playerid] = 0;
				    new S1 = -1, S2 = -1, S3 = -1;
				    foreach(Player, cid)
					{//����
						if(GetPlayerVehicleID(cid) == GetPlayerVehicleID(playerid) && GetPlayerVehicleSeat(cid) > 0)
						{//������ ����������
							if(GetPlayerVehicleSeat(cid) == 1){S1 = cid;}
							if(GetPlayerVehicleSeat(cid) == 2){S2 = cid;}
							if(GetPlayerVehicleSeat(cid) == 3){S3 = cid;}
						}//������ ����������
					}
					new Float: vel1, Float: vel2, Float: vel3;GetVehicleVelocity(GetPlayerVehicleID(playerid), vel1, vel2, vel3);
	                SetTimerEx("PrestigeCarTPx" , 500, false, "idiiifff", playerid, CarClass, S1, S2, S3, vel1, vel2, vel3);
	                TogglePlayerControllable(playerid,0);DestroyVehicle(PlayerCarID[playerid]);
			    }//�� �� 50 ������
			    if (Player[playerid][ActiveSkillHCar1] == 6)
			    {//�� �� 100 ������ �� ���������
			        if (GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"������: �� ������ ���� �� �����, ����� ������������ ���� �����");
				    new Float: x, Float: y;GetXYInFrontOfPlayer(playerid,x,y,100.0);
				    SetPlayerPosFindZ(playerid, x, y, 3000.0);SkillHTime[playerid] = 5;
				    SetPlayerChatBubble(playerid, "����������� �����", COLOR_GREEN, 100.0, 3000);
				    new CarClass = Player[playerid][CarActive];TimeTransform[playerid] = 0;
				    new S1 = -1, S2 = -1, S3 = -1;
				    foreach(Player, cid)
					{//����
						if(GetPlayerVehicleID(cid) == GetPlayerVehicleID(playerid) && GetPlayerVehicleSeat(cid) > 0)
						{//������ ����������
							if(GetPlayerVehicleSeat(cid) == 1){S1 = cid;}
							if(GetPlayerVehicleSeat(cid) == 2){S2 = cid;}
							if(GetPlayerVehicleSeat(cid) == 3){S3 = cid;}
						}//������ ����������
					}
					new Float: vel1, Float: vel2, Float: vel3;GetVehicleVelocity(GetPlayerVehicleID(playerid), vel1, vel2, vel3);
	                SetTimerEx("PrestigeCarTPx" , 500, false, "idiiifff", playerid, CarClass, S1, S2, S3, vel1, vel2, vel3);
	                TogglePlayerControllable(playerid,0);DestroyVehicle(PlayerCarID[playerid]);
			    }//�� �� 100 ������
			    if (Player[playerid][ActiveSkillHCar1] == 7)
			    {//�� �� 200 ������ �� ���������
			        if (GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"������: �� ������ ���� �� �����, ����� ������������ ���� �����");
				    new Float: x, Float: y;GetXYInFrontOfPlayer(playerid,x,y,200.0);
				    SetPlayerPosFindZ(playerid, x, y, 3000.0);SkillHTime[playerid] = 5;
				    SetPlayerChatBubble(playerid, "����������� �����", COLOR_GREEN, 100.0, 3000);
				    new CarClass = Player[playerid][CarActive];TimeTransform[playerid] = 0;
				    new S1 = -1, S2 = -1, S3 = -1;
				    foreach(Player, cid)
					{//����
						if(GetPlayerVehicleID(cid) == GetPlayerVehicleID(playerid) && GetPlayerVehicleSeat(cid) > 0)
						{//������ ����������
							if(GetPlayerVehicleSeat(cid) == 1){S1 = cid;}
							if(GetPlayerVehicleSeat(cid) == 2){S2 = cid;}
							if(GetPlayerVehicleSeat(cid) == 3){S3 = cid;}
						}//������ ����������
					}
					new Float: vel1, Float: vel2, Float: vel3;GetVehicleVelocity(GetPlayerVehicleID(playerid), vel1, vel2, vel3);
	                SetTimerEx("PrestigeCarTPx" , 500, false, "idiiifff", playerid, CarClass, S1, S2, S3, vel1, vel2, vel3);
	                TogglePlayerControllable(playerid,0);DestroyVehicle(PlayerCarID[playerid]);
			    }//�� �� 200 ������
			    if (Player[playerid][ActiveSkillHCar1] == 8){if(OnVehFly[playerid] == 0) StartVehFly(playerid); else StopVehFly(playerid);}//����� ������ �� ����
			}//����� 1
		    if (Player[playerid][CarActive] == 2)
		    {//����� 2
		        if (Player[playerid][ActiveSkillHCar2] == 1)
		        {//����������� ��������� �� ������
		        	new Float: aangle;
				    SkillHTime[playerid] = 5;SetPlayerChatBubble(playerid, "���������� ���������", COLOR_GREEN, 300.0, 3000);
				    GetVehicleZAngle(GetPlayerVehicleID(playerid), aangle);SetVehicleZAngle(GetPlayerVehicleID(playerid), aangle);
		            SendClientMessage(playerid,COLOR_GREEN,"�� ����������� ��� ��������� �� ������.");
		        }//����������� ��������� �� ������
			    if (Player[playerid][ActiveSkillHCar2] == 2)
			    {//�� �� 50 ������
			        if (GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"������: �� ������ ���� �� �����, ����� ������������ ���� �����");
				    new Float: x, Float: y;GetXYInFrontOfPlayer(playerid,x,y,50.0);
				    SetPlayerPosFindZ(playerid, x, y, 3000.0);SkillHTime[playerid] = 5;
				    SetPlayerChatBubble(playerid, "����������� �����", COLOR_GREEN, 100.0, 3000);
				    new CarClass = Player[playerid][CarActive];TimeTransform[playerid] = 0;
				    new S1 = -1, S2 = -1, S3 = -1;
				    foreach(Player, cid)
					{//����
						if(GetPlayerVehicleID(cid) == GetPlayerVehicleID(playerid) && GetPlayerVehicleSeat(cid) > 0)
						{//������ ����������
							if(GetPlayerVehicleSeat(cid) == 1){S1 = cid;}
							if(GetPlayerVehicleSeat(cid) == 2){S2 = cid;}
							if(GetPlayerVehicleSeat(cid) == 3){S3 = cid;}
						}//������ ����������
					}
	                SetTimerEx("PrestigeCarTP" , 500, false, "idiii", playerid, CarClass, S1, S2, S3);
	                TogglePlayerControllable(playerid,0);DestroyVehicle(PlayerCarID[playerid]);
			    }//�� �� 50 ������
			    if (Player[playerid][ActiveSkillHCar2] == 3)
			    {//�� �� 100 ������
			        if (GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"������: �� ������ ���� �� �����, ����� ������������ ���� �����");
	                new Float: x, Float: y;GetXYInFrontOfPlayer(playerid,x,y,100.0);
				    SetPlayerPosFindZ(playerid, x, y, 3000.0);SkillHTime[playerid] = 5;
				    SetPlayerChatBubble(playerid, "����������� �����", COLOR_GREEN, 100.0, 3000);
				    new CarClass = Player[playerid][CarActive];TimeTransform[playerid] = 0;
				    new S1 = -1, S2 = -1, S3 = -1;
				    foreach(Player, cid)
					{//����
						if(GetPlayerVehicleID(cid) == GetPlayerVehicleID(playerid) && GetPlayerVehicleSeat(cid) > 0)
						{//������ ����������
							if(GetPlayerVehicleSeat(cid) == 1){S1 = cid;}
							if(GetPlayerVehicleSeat(cid) == 2){S2 = cid;}
							if(GetPlayerVehicleSeat(cid) == 3){S3 = cid;}
						}//������ ����������
					}
	                SetTimerEx("PrestigeCarTP" , 500, false, "idiii", playerid, CarClass, S1, S2, S3);
	                TogglePlayerControllable(playerid,0);DestroyVehicle(PlayerCarID[playerid]);
			    }//�� �� 100 ������
			    if (Player[playerid][ActiveSkillHCar2] == 4)
			    {//�� �� 200 ������
			        if (GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"������: �� ������ ���� �� �����, ����� ������������ ���� �����");
	                new Float: x, Float: y;GetXYInFrontOfPlayer(playerid,x,y,200.0);
				    SetPlayerPosFindZ(playerid, x, y, 3000.0);SkillHTime[playerid] = 5;
				    SetPlayerChatBubble(playerid, "����������� �����", COLOR_GREEN, 100.0, 3000);
				    new CarClass = Player[playerid][CarActive];TimeTransform[playerid] = 0;
				    new S1 = -1, S2 = -1, S3 = -1;
				    foreach(Player, cid)
					{//����
						if(GetPlayerVehicleID(cid) == GetPlayerVehicleID(playerid) && GetPlayerVehicleSeat(cid) > 0)
						{//������ ����������
							if(GetPlayerVehicleSeat(cid) == 1){S1 = cid;}
							if(GetPlayerVehicleSeat(cid) == 2){S2 = cid;}
							if(GetPlayerVehicleSeat(cid) == 3){S3 = cid;}
						}//������ ����������
					}
	                SetTimerEx("PrestigeCarTP" , 500, false, "idiii", playerid, CarClass, S1, S2, S3);
	                TogglePlayerControllable(playerid,0);DestroyVehicle(PlayerCarID[playerid]);
			    }//�� �� 100 ������
			    if (Player[playerid][ActiveSkillHCar2] == 5)
			    {//�� �� 50 ������ �� ���������
			        if (GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"������: �� ������ ���� �� �����, ����� ������������ ���� �����");
				    new Float: x, Float: y;GetXYInFrontOfPlayer(playerid,x,y,50.0);
				    SetPlayerPosFindZ(playerid, x, y, 3000.0);SkillHTime[playerid] = 5;
				    SetPlayerChatBubble(playerid, "����������� �����", COLOR_GREEN, 100.0, 3000);
				    new CarClass = Player[playerid][CarActive];TimeTransform[playerid] = 0;
				    new S1 = -1, S2 = -1, S3 = -1;
				    foreach(Player, cid)
					{//����
						if(GetPlayerVehicleID(cid) == GetPlayerVehicleID(playerid) && GetPlayerVehicleSeat(cid) > 0)
						{//������ ����������
							if(GetPlayerVehicleSeat(cid) == 1){S1 = cid;}
							if(GetPlayerVehicleSeat(cid) == 2){S2 = cid;}
							if(GetPlayerVehicleSeat(cid) == 3){S3 = cid;}
						}//������ ����������
					}
					new Float: vel1, Float: vel2, Float: vel3;GetVehicleVelocity(GetPlayerVehicleID(playerid), vel1, vel2, vel3);
	                SetTimerEx("PrestigeCarTPx" , 500, false, "idiiifff", playerid, CarClass, S1, S2, S3, vel1, vel2, vel3);
	                TogglePlayerControllable(playerid,0);DestroyVehicle(PlayerCarID[playerid]);
			    }//�� �� 50 ������
			    if (Player[playerid][ActiveSkillHCar2] == 6)
			    {//�� �� 100 ������ �� ���������
			        if (GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"������: �� ������ ���� �� �����, ����� ������������ ���� �����");
				    new Float: x, Float: y;GetXYInFrontOfPlayer(playerid,x,y,100.0);
				    SetPlayerPosFindZ(playerid, x, y, 3000.0);SkillHTime[playerid] = 5;
				    SetPlayerChatBubble(playerid, "����������� �����", COLOR_GREEN, 100.0, 3000);
				    new CarClass = Player[playerid][CarActive];TimeTransform[playerid] = 0;
				    new S1 = -1, S2 = -1, S3 = -1;
				    foreach(Player, cid)
					{//����
						if(GetPlayerVehicleID(cid) == GetPlayerVehicleID(playerid) && GetPlayerVehicleSeat(cid) > 0)
						{//������ ����������
							if(GetPlayerVehicleSeat(cid) == 1){S1 = cid;}
							if(GetPlayerVehicleSeat(cid) == 2){S2 = cid;}
							if(GetPlayerVehicleSeat(cid) == 3){S3 = cid;}
						}//������ ����������
					}
					new Float: vel1, Float: vel2, Float: vel3;GetVehicleVelocity(GetPlayerVehicleID(playerid), vel1, vel2, vel3);
	                SetTimerEx("PrestigeCarTPx" , 500, false, "idiiifff", playerid, CarClass, S1, S2, S3, vel1, vel2, vel3);
	                TogglePlayerControllable(playerid,0);DestroyVehicle(PlayerCarID[playerid]);
			    }//�� �� 100 ������
			    if (Player[playerid][ActiveSkillHCar2] == 7)
			    {//�� �� 200 ������ �� ���������
			        if (GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,COLOR_RED,"������: �� ������ ���� �� �����, ����� ������������ ���� �����");
				    new Float: x, Float: y;GetXYInFrontOfPlayer(playerid,x,y,200.0);
				    SetPlayerPosFindZ(playerid, x, y, 3000.0);SkillHTime[playerid] = 5;
				    SetPlayerChatBubble(playerid, "����������� �����", COLOR_GREEN, 100.0, 3000);
				    new CarClass = Player[playerid][CarActive];TimeTransform[playerid] = 0;
				    new S1 = -1, S2 = -1, S3 = -1;
				    foreach(Player, cid)
					{//����
						if(GetPlayerVehicleID(cid) == GetPlayerVehicleID(playerid) && GetPlayerVehicleSeat(cid) > 0)
						{//������ ����������
							if(GetPlayerVehicleSeat(cid) == 1){S1 = cid;}
							if(GetPlayerVehicleSeat(cid) == 2){S2 = cid;}
							if(GetPlayerVehicleSeat(cid) == 3){S3 = cid;}
						}//������ ����������
					}
					new Float: vel1, Float: vel2, Float: vel3;GetVehicleVelocity(GetPlayerVehicleID(playerid), vel1, vel2, vel3);
	                SetTimerEx("PrestigeCarTPx" , 500, false, "idiiifff", playerid, CarClass, S1, S2, S3, vel1, vel2, vel3);
	                TogglePlayerControllable(playerid,0);DestroyVehicle(PlayerCarID[playerid]);
			    }//�� �� 200 ������
			    if (Player[playerid][ActiveSkillHCar2] == 8){if(OnVehFly[playerid] == 0) StartVehFly(playerid); else StopVehFly(playerid);}//����� ������ �� ����
		}//����� 2
		}//�� H
	}//����� H ����
	
	if(PRESSED(KEY_CROUCH) && IsPlayerInAnyVehicle(playerid))
	{//��������� ������ �� ������
	    if (InEvent[playerid] == EVENT_XRACE || InEvent[playerid] == EVENT_RACE)
	    {//� ������� ��� ����������� �����
	        if (FlipCount[playerid] <= 0) return 1;
			new Float: aangle, String[120], needcount = 0;
			GetVehicleZAngle(GetPlayerVehicleID(playerid), aangle);SetVehicleZAngle(GetPlayerVehicleID(playerid), aangle);
            SetPlayerChatBubble(playerid, "���������� ���������", COLOR_GREEN, 300.0, 3000);
         	if (InEvent[playerid] == EVENT_RACE || InEvent[playerid] == EVENT_XRACE) needcount = 1;
			if (needcount == 1)
			{//���� ����� ������� ���-�� ���������� �����������
	            FlipCount[playerid] -= 1;
				format(String,sizeof(String),"�� ����������� ��� ��������� �� ������. �������� �����������: %d", FlipCount[playerid]);
				SendClientMessage(playerid,COLOR_GREEN,String);
			}//���� ����� ������� ���-�� ���������� �����������
			else
			{//���� �� �����
			    format(String,sizeof(String),"�� ����������� ��� ��������� �� ������.", FlipCount[playerid]);
				SendClientMessage(playerid,COLOR_GREEN,String);
			}//���� �� �����
	    }//� ������� ��� ����������� �����
	}//��������� ������ �� ������
	
	if (Player[playerid][Level] == 0 && IsPlayerInAnyVehicle(playerid))
	{//�������� ��������
		if(PRESSED(KEY_NO) || PRESSED(KEY_YES))
		{//����������������� �� ������ � ������
			new String[1024];
			strcat(String, "{007FFF}����� ��������: ����{FFFFFF}\n\n");
			strcat(String, "�����������! �� ������� ������ ��������! ������ ����� �������� ������� �������� �������� ������.\n");
			strcat(String, "� ������ ����� ������� � ��� ����� ����� �����������, ��������� � ������. ����� �������� �������\n");
			strcat(String, "����� ����� ����������� � �������������: � ������, ���������, ����� � ��� �����.\n\n");
			strcat(String, "{008E00}���������� ������ ��������� ������������ ����� �������� {FF0000}/events\n");
			strcat(String, "{008E00}���������� ������ ��������� ������� ����� �������� {FF0000}/quests\n");
			strcat(String, "{008E00}����� ������, ����, ������ � ������ ������ ������� ����� ��� ������ {FF0000}/gps\n\n");
			strcat(String, "{FFFFFF}���� � ��� �������� �����-�� �������, �� �� ����������� ��� ��������� FAQ (������� {FF0000}/help{FFFFFF}).\n");
			strcat(String, "\n\n{FFFF00}�������� ����!");
			ShowPlayerDialog(playerid, DIALOG_TUTORIAL, 0, "��������", String, "������", "");
			DestroyObject(TutorialObject[playerid]);TutorialObject[playerid] = -1;
			TutorialStep[playerid] = 4;
			SendClientMessage(playerid, -1, "{AFAFAF}SERVER: �� ������� ������ ��������!");
		}//����������������� �� ������ � ������
	}//�������� ��������

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
                SendClientMessage(i, 0xFFFFFFFF, "������������ ������. ����� ����������!"); //Send a message
                Kick(i);//Ban(i); //They are now banned.
            }
        }
	return 1;
}

public OnPlayerUpdate(playerid)
{
	LAFK[playerid] = 0; //����� afk
	
	//--- ������ �� ����������� �� ��������� ������ �������
	if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{//����� �� ����� ����
	    new vehicleid = GetPlayerVehicleID(playerid);
	    if (Vehicle[vehicleid][Owner] != -1 && Vehicle[vehicleid][Owner] != playerid)
	        return 0;
	}//����� �� ����� ����
	//--- ������ �� ����������� �� ��������� ������ �������

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
	        if (hp != 100.0 || Armour != 0.0) SendClientMessage(testerid,COLOR_YELLOW,"GMTest: {DD0000}��������� ���, ����������� �������� �������� �/��� ����� ������!");
	        GMTestTime[playerid] = 3;GMTestStage[playerid] = 2;//������������� ������
			new Float: x, Float: y, Float: z;GetPlayerPos(playerid,x,y,z);SetPlayerPos(playerid,x+1,y+1,z + 10);
	    }//NOP
	    if (GMTestStage[playerid] == 2)
	    {//�������������
	        if (hp < 100.0)
	        {
	            SendClientMessage(testerid,COLOR_YELLOW,"GMTest: {008E00}������������ � ������� � ������ �� ����������.");
	            SetPlayerHealth(playerid,100);GMTestTime[playerid] = 3;GMTestTime[playerid] = 3;GMTestStage[playerid] = 666;//�����
	        }
	        else if (GMTestTime[playerid] <= 1)
	        {
	            SendClientMessage(testerid,COLOR_YELLOW,"GMTest: {DD0000}��������� ��� �� ������������ � ������� � ������!");
	            SetPlayerHealth(playerid,100);GMTestTime[playerid] = 3;GMTestTime[playerid] = 3;GMTestStage[playerid] = 666;//�����
	        }
	    }//�������������
	    if (GMTestStage[playerid] == 3)
	    {//�����
	        if (hp < 100.0)
	        {
	            SendClientMessage(testerid,COLOR_YELLOW,"GMTest: {008E00}������������ � ������� �� ����������.");
	            SetPlayerHealth(playerid,100);GMTestTime[playerid] = 0;GMTestStage[playerid] = 4;//�����
	        }
	        else if (GMTestTime[playerid] <= 1)
	        {
	            SendClientMessage(testerid,COLOR_YELLOW,"GMTest: {DD0000}��������� ��� �� ������������ � �������!");
	            SetPlayerHealth(playerid,100);GMTestTime[playerid] = 3;GMTestStage[playerid] = 4;//�����
	        }
	    }//�����
	    if (GMTestStage[playerid] == 666)
	    {//�������������, �� �����������..
	        GMTestStage[playerid] = 3;GMTestTime[playerid] = 3;
	        new Float: x, Float: y, Float: z;GetPlayerPos(playerid,x,y,z);CreateExplosionForPlayer(playerid, x, y , z+7, 4, 2);
	    }//�������������, �� �����������..
	    if (GMTestStage[playerid] == 4)
	    {
	        GMTestStage[playerid] = 0;GMTestTime[playerid] = 0;
			SetPlayerHealth(playerid,GMTestHealthOld[playerid]);SetPlayerArmour(playerid,GMTestArmourOld[playerid]);
			new string[120], pname[24];GetPlayerName(playerid, pname, sizeof(pname));
			format(string,sizeof(string),"GMTest: ������������ ������ %s[%d] ���������.",pname,playerid);
			SendClientMessage(testerid,COLOR_YELLOW,string);
	    }
	    
	}//----- GMTest
	
	if (FirstSobeitCheck[playerid] > 0 && FirstSobeitCheck[playerid] < 3)
	{//----- ��������� �������� �� Sobeit ��� ������ ������
	    new Float:x, Float:y, Float:z; GetPlayerCameraFrontVector(playerid, x, y, z);
		if (FirstSobeitCheck[playerid] == 1)
		{//��������� ��������
		    if(z >= -0.25)
			{//���� � ������� �������
	    	    TogglePlayerControllable(playerid, false); //������������ ������ (� ���������� ������ ����� ��������� ����)
				FirstSobeitCheck[playerid] = 2;
			}//���� � ������� �������
			else SetCameraBehindPlayer(playerid); //����� ������, ����� � ������� ��� �������
		}//��������� ��������
		if (FirstSobeitCheck[playerid] == 2)
		{//----- ��������� �������� �� Sobeit ��� ������ ������
		   	if(z < -0.8)
		    {//��������� Sobeit (UnFreeze ���)
		        new String[140]; FirstSobeitCheck[playerid] = 3; //����� �� ���������� ��������
				format(String,sizeof(String), "[�������]LAC: {AFAFAF}%s[%d] ��� ������������� ������. {FF0000}�������: {AFAFAF}��������� ��� Sobeit",PlayerName[playerid], playerid);
		        foreach(Player, cid) if (Player[cid][Admin] != 0 && Logged[cid] == 1) SendClientMessage(cid, COLOR_RED, String);
				format(String, 140, "%d.%d.%d � %d:%d:%d |   LAC: %s[%d] ��� ������������� ������. �������: ��������� ��� Sobeit", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid);
				WriteLog("GlobalLog", String);WriteLog("LACSobeit", String);
				SendClientMessage(playerid, COLOR_RED, "LAC: {AFAFAF}��������� ��� {FF0000}Sobeit{AFAFAF}! ������� ��� � ����������� � ����!");
				TogglePlayerControllable(playerid, 1); SetCameraBehindPlayer(playerid);
				CancelSelectTextDraw(playerid); return GKick(playerid);
		    }//��������� Sobeit (UnFreeze ���)
		}//----- ��������� �������� �� Sobeit ��� ������ ������
	}//----- ��������� �������� �� Sobeit ��� ������ ������

	//----- ����� �����
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
	//----- ����� �����
	
	//----- ��������� ������ ������
	if (LSpecID[playerid] != -1 && LSpecCanFastChange[playerid] == 1)
	{//����� � ������ ������ (����� �������������� �����������)
	    if(lr > 0)
	    {//������ ������� ������
	        new bool: CurrentID = false, specplayerid = LSpecID[playerid];
	        LSpectators[specplayerid]--;
	        while (!CurrentID)
	        {//���� ID ������ �������������� ������������
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
	        }//���� ID ������ �������������� ������������
	    }//������ ������� ������
	    else if(lr < 0)
	    {//������ ������� �����
	        new bool: CurrentID = false, specplayerid = LSpecID[playerid];
            LSpectators[specplayerid]--;
			while (!CurrentID)
	        {//���� ID ������ �������������� ������������
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
	        }//���� ID ������ �������������� ������������
	    }//������ ������� �����
	    else if(ud != 0)
	    {//������ ������� ���� ��� ����� (���������� ������, ����� ������)
	        if(ud > 0)
	        {//������ ������� ���� (����� ������)
	            if (LSpecMode[playerid] == SPECTATE_MODE_NORMAL) LSpecMode[playerid] = SPECTATE_MODE_SIDE;
	            else  LSpecMode[playerid] = SPECTATE_MODE_NORMAL;
	        }//������ ������� ���� (����� ������)
	        new specplayerid = LSpecID[playerid]; LSpecCanFastChange[playerid] = 0;
	        SetPlayerInterior(playerid, GetPlayerInterior(specplayerid));
		    SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(specplayerid));
		    if (IsPlayerInAnyVehicle(specplayerid)) PlayerSpectateVehicle(playerid, GetPlayerVehicleID(specplayerid), LSpecMode[playerid]);
			else PlayerSpectatePlayer(playerid, specplayerid);
			GameTextForPlayer(playerid, "~Y~camera updated", 1500, 6);
	    }//������ ������� ���� ��� ����� (���������� ������, ����� ������)
	}//����� � ������ ������ (����� �������������� �����������)
	//----- ��������� ������ ������
	
	if (InPeacefulZone[playerid] == 1 || AdminTPCantKill[playerid] > 0) SetPlayerArmedWeapon(playerid, 0);//������ ������ � ������ �����

    if (PrestigeGM[playerid] == 1)
    {//����� ����
        if (InEvent[playerid] == 0)
        {
	        SetPlayerHealth(playerid, 90000.0);
	        if (GetPlayerInterior(playerid) != 10) SetPlayerChatBubble(playerid, "����� ���� (�������)", COLOR_YELLOW, 300.0, 1000); //� ������ �� ���������� �������
	        if (IsPlayerInAnyVehicle(playerid)) RepairVehicle(GetPlayerVehicleID(playerid));
        }
        else
		{
			PrestigeGM[playerid] = 0;SetPlayerHealth(playerid, 100.0);SendClientMessage(playerid,0xFF0000FF,"����� ���� �������������.");
			if (InEvent[playerid] == EVENT_DERBY) SetVehicleHealth(GetPlayerVehicleID(playerid), 700.0);
		}
    }//����� ����
    
    if (MapTP[playerid] == 1)
    {//����������� �������� �� ����� (����� ����� ��������� �������� ���������� Z)
    	new Float: X, Float: Y, Float: Z; GetPlayerPos(playerid, X, Y, Z);
    	if (MapTPx[playerid] != X || MapTPy[playerid] != Y) Z = -5.0;
        if (Z < 0)
        {//�� ��� ������ ���������� Z
            MapTPTry[playerid]++;
            if (MapTPTry[playerid] < 10) SetPlayerPosFindZ(playerid, MapTPx[playerid], MapTPy[playerid], 10000);
            else
            {//��� � �� ������� ����� ���������� Z ���� ���� (������� ��������� �� ���)
                SetPlayerPos(playerid, MapTPx[playerid], MapTPy[playerid], 1);
                //SendClientMessage(playerid, -1, "�� ������� ����� ���������� Z ����� 10 �������!");
            }//��� � �� ������� ����� ���������� Z ���� ���� (������� ��������� �� ���)
        }//�� ��� ������ ���������� Z
        else
        {//���������� Z � �����
            MapTP[playerid] = 0; AdminTPCantKill[playerid] = 20;
            if (Player[playerid][Admin] < 4) {MapTPTime[playerid] = 120; SetPlayerChatBubble(playerid, "���������������� (ViP)", 0x00FF00FF, 300.0, 6000);}
			SendClientMessage(playerid, COLOR_YELLOW, "SERVER: �� ������� ������������ �������� �� �����!");
        }//���������� Z � �����
    }//����������� �������� �� ����� (����� ����� ��������� �������� ���������� Z)

	if (InEvent[playerid] == EVENT_ZOMBIE && ZMTimeToFirstZombie <= 0 && ZMIsPlayerIsZombie[playerid] == 0)
	{//����� �� �����-��������� ������ �� ��������, ����� ��� ������������
	    new Float:SPD, Float:vx, Float:vy, Float:vz; GetPlayerVelocity(playerid, vx,vy,vz);
		SPD = floatsqroot(((vx*vx)+(vy*vy))/*+(vz*vz)*/);
		if (SPD > 0.125 || GetPlayerAnimationIndex(playerid) == 1195 || GetPlayerAnimationIndex(playerid) == 1061 || GetPlayerAnimationIndex(playerid) == 1065 || GetPlayerAnimationIndex(playerid) == 1066)
		{//���, ������, ����� �� �����, ������� �� �����, ������� �� �����
		    SecFreeze(playerid, 1); ApplyAnimation(playerid,"CRACK","crckdeth1",4.1,0,0,0,0,1,1);
	 		SendClientMessage(playerid, COLOR_RED, "����� ��������� ������ � ������� ����� ��������� �����!");
		}//���, ������, ����� �� �����, ������� �� �����, ������� �� �����
	}//����� �� �����-��������� ������ �� ��������, ����� ��� ������������
	
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
/*
    //����� ������
    new aindex = GetPlayerAnimationIndex(playerid);
    if(aindex > 0)
    {
        new animlib[32], animname[32];
        GetAnimationName(aindex, animlib, sizeof(animlib), animname, sizeof(animname));
        ApplyAnimation(playerid, animlib, animname, 4.0, 0, 1, 1, 0, 0, 1);
    }
    //����� ������*/
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
{//�� ��
	//����� � ����
    getdate(Year, Month, Day); gettime(hour,minute,second);new StringTime[80];
	format(StringTime, sizeof StringTime, "%d/%s%d/%s%d", Day, ((Month < 10) ? ("0") : ("")), Month, (Year < 10) ? ("0") : (""), Year);
	TextDrawSetString(TextDrawDate, StringTime);
	format(StringTime, sizeof StringTime, "%s%d:%s%d:%s%d", (hour < 10) ? ("0") : (""), hour, (minute < 10) ? ("0") : (""), minute, (second < 10) ? ("0") : (""), second);
	TextDrawSetString(TextDrawTime, StringTime);
	if (minute == 0 && second < 3)
	{//��������� ������ �� ��� � ���, ����������� ������ �� ������, ���� ���� ��� �� ��������� (��� �������)
		format(ServerLimitXPDate,sizeof ServerLimitXPDate, "%d/%d/%d � %d:00", Day, Month, Year, hour);
		foreach(Player, gid)
		{
		    //--------- ����� ���������� ����������
	    	format(PlayerLimitXPDate[gid], 80, "%d/%d/%d � %d:00", Day, Month, Year, hour);
            if (Player[gid][LastHourExp] > 0)
			{
				new String[180];
			    format(String, sizeof String, "%d.%d.%d � %d:%d:%d |   STATISTICS: ����� %s[%d] ������� %d XP �� ���� ���", Day, Month, Year, hour, minute, second, PlayerName[gid], gid, Player[gid][LastHourExp]);
				WriteLog("StatisticsXP", String);
			}
			if (Player[gid][LastHourReferalExp] > 0)
			{
				new String[180];
			    format(String, sizeof String, "%d.%d.%d � %d:%d:%d |   STATISTICS: ����� %s[%d] ������� �� ����� %d XP �� ���� ���", Day, Month, Year, hour, minute, second, PlayerName[gid], gid, Player[gid][LastHourReferalExp]);
				WriteLog("StatisticsClanXP", String);
			}
			Player[gid][LastHourExp] = 0; Player[gid][LastHourReferalExp] = 0;
			//--------- ����� ���������� ����������
			
		    ShopUpdate(gid);//���������� ��������� ������� Shop
		}
		if (minute == 0 && second == 0)
		{//������ ����� �� ��������� (��� �������)
		    ClansUpdate();//�������� ������, ������� �� ������ ���� �������
		    HousesUpdate();//������ ������������� � ���, � ���� ��� ���������
			SendClientMessageToAll(COLOR_YELLOW,"SERVER: ������� ����� ������� ���! ������� �����, ���������� �� ��������� ���, �����������.");
		}//������ ����� �� ��������� (��� �������)
	}//��������� ������ �� ��� � ���, ����������� ������ �� ������, ���� ���� ��� �� ��������� (��� �������)
	if (second == 0)
	{//��� � ������
	    PlayersOnline = 0;
	    foreach(Player, gid)
		{//����
			PlayersOnline++;
            QuestUpdate(gid, 25, 1);//���������� ������ ��������� �� ������� 60 �����
            if (QuestActive[gid] >= 2) QuestUpdate(gid, 27, 1);//���������� ������ ��������� 15 ����� �� ����� ������
		}//����
	}//��� � ������

	
	UGTime--; //��������� � ������
	if (UGTime == 0)
	{
	    SendClientMessageToAll(-1,"");
	    SendClientMessageToAll(COLOR_YELLOW,"��������� � ���� ������ ���������: {FFFFFF}vk.com/ubergame");
	    new rand = random(5);
	        if (rand == 0) SendClientMessageToAll(COLOR_GG,"��������! �� ������� ���� ������������� �������: {FFFFFF}/shop");
	        if (rand == 1) SendClientMessageToAll(COLOR_DERBY,"��������! �� ������� ���� ������������� �������: {FFFFFF}/shop)");
	        if (rand == 2) SendClientMessageToAll(COLOR_RACE,"��������! �� ������� ���� ������������� �������: {FFFFFF}/shop");
	        if (rand == 3) SendClientMessageToAll(COLOR_GREEN,"��������! �� ������� ���� ������������� �������: {FFFFFF}/shop");
	        if (rand == 4) SendClientMessageToAll(COLOR_NICEORANGE,"��������! �� ������� ���� ������������� �������: {FFFFFF}/shop");
        SendClientMessageToAll(-1,"");

		//������������ �������
		if(fexist("AD.ini"))
		{
		    new file, ADString1[140], ADString2[140], ADString3[140], ADString4[140];
		    file = ini_openFile("AD.ini");
			ini_getString(file,"String1", ADString1); if(strcmp(ADString1, "�����", true)) SendClientMessageToAll(-1, ADString1);
			ini_getString(file,"String2", ADString2); if(strcmp(ADString2, "�����", true)) SendClientMessageToAll(-1, ADString2);
			ini_getString(file,"String3", ADString3); if(strcmp(ADString3, "�����", true)) SendClientMessageToAll(-1, ADString3);
			ini_getString(file,"String4", ADString4); if(strcmp(ADString4, "�����", true)) SendClientMessageToAll(-1, ADString4);
            ini_closeFile(file);
		}//������������ �������


	    UGTime = 900; SendRconCommand("reloadbans");
	    //����� ������
	    ServerWeather = random(20);
		if (ServerWeather == 8 || ServerWeather == 16 || ServerWeather == 19) ServerWeather -= 1;//�������� ������ � ������ � � �����
		if (ServerWeather == 9) ServerWeather = 10;
		SetWeather(ServerWeather);		//����� ������
		foreach(Player, gid) if (Logged[gid] == 1) SavePlayer(gid);
		SaveAllClans(); //SaveAllProperty(); SaveAllBase();
	}
	

	/////////////
	DMPlayers = 0; DerbyPlayers = 0;	ZMPlayers = 0; ZMZombies = 0; ZMHumans = 0;	FRPlayers = 0;	XRPlayers = 0;	GGPlayers = 0;
	foreach(Player, cid)
	{//����
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
	}//����
	/////////////

	#include "Transformer\DMSecUpdate"
	#include "Transformer\DerbySecUpdate"
	#include "Transformer\ZombieSecUpdate"
	#include "Transformer\RaceSecUpdate"
	#include "Transformer\XRaceSecUpdate"
	#include "Transformer\GGSecUpdate"

	//------------------------------- ������ ��������� ��������
	if (SaveTime > 0){SaveTime--;}//�������������� �����
	if (SaveTime == 0){SaveTime = 30;}//UpdatePlayer ������ 30 ���
	
	for (new vid = 1; vid <= 35; vid++)
	{//��������� ���� ��� �����
	    StealCarTimer[vid]++;
	    if (StealCarTimer[vid] >= 600)
	    {//����� �������� ���� ��� ����� �� �����
	        if (vid <= 25)
	        {//�������� ����
				DestroyVehicle(StealCar[vid]);DestroyDynamicMapIcon(StealCarMapIcon[vid]);
				//������������ ���� ���� � ������ �����
				new rrand1 = random(sizeof(CarStealSpawns)), rcol1 = random(256), rcol2 = random(256), rmodeld = random(133); new rmodel = StealCars[rmodeld];
				StealCar[vid] = LCreateVehicle(rmodel, CarStealSpawns[rrand1][0], CarStealSpawns[rrand1][1], CarStealSpawns[rrand1][2], CarStealSpawns[rrand1][3], rcol1, rcol2, 0);
	  		 	StealCarMapIcon[vid] = CreateDynamicMapIcon(CarStealSpawns[rrand1][0], CarStealSpawns[rrand1][1], CarStealSpawns[rrand1][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);
			}//�������� ����
			else if (vid <= 30)
			{//������ ����
				DestroyVehicle(StealCar[vid]);DestroyDynamicMapIcon(StealCarMapIcon[vid]);
				//������������ ���� ���� � ������ �����
				new rrand1 = random(sizeof(CarStealWaterSpawns)), rcol1 = random(256), rcol2 = random(256), rmodeld = random(11); new rmodel = StealWaterCars[rmodeld];
				StealCar[vid] = LCreateVehicle(rmodel, CarStealWaterSpawns[rrand1][0], CarStealWaterSpawns[rrand1][1], CarStealWaterSpawns[rrand1][2], CarStealWaterSpawns[rrand1][3], rcol1, rcol2, 0);
	  		 	StealCarMapIcon[vid] = CreateDynamicMapIcon(CarStealWaterSpawns[rrand1][0], CarStealWaterSpawns[rrand1][1], CarStealWaterSpawns[rrand1][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);
			}//������ ����
			else if (vid <= 35)
			{//��������� ����
				DestroyVehicle(StealCar[vid]);DestroyDynamicMapIcon(StealCarMapIcon[vid]);
				//������������ ���� ���� � ������ �����
				new rrand1 = random(sizeof(CarStealAirSpawns)), rcol1 = random(256), rcol2 = random(256), rmodeld = random(13); new rmodel = StealAirCars[rmodeld];
				StealCar[vid] = LCreateVehicle(rmodel, CarStealAirSpawns[rrand1][0], CarStealAirSpawns[rrand1][1], CarStealAirSpawns[rrand1][2], CarStealAirSpawns[rrand1][3], rcol1, rcol2, 0);
	  		 	StealCarMapIcon[vid] = CreateDynamicMapIcon(CarStealAirSpawns[rrand1][0], CarStealAirSpawns[rrand1][1], CarStealAirSpawns[rrand1][2], 55, COLOR_QUEST, 0, 0, -1, 350.0);
			}//��������� ����
	    }//����� �������� ���� ��� ����� �� �����
	}//��������� ���� ��� �����
	
	new Float: vehHP, NewMaxVehicleUsed = 35;
	for (new vehid = 36; vehid <= MaxVehicleUsed; vehid++)
	{//��������� ���� ����, ����� ���� ��� �����
	    GetVehicleHealth(vehid, vehHP);
	    //���� �������� ���� �� ����� 0, ������ ������ ���������� - ������������ �
	    if (vehHP != 0) {SecVehicleUpdate(vehid); NewMaxVehicleUsed = vehid;}
	}//��������� ���� ����, ����� ���� ��� �����
	MaxVehicleUsed = NewMaxVehicleUsed;

return 1;
}//�� ��

public SecVehicleUpdate(vehicleid)
{//������������ ���������� ���������� (�� �������� �� ���� ��� ����� � �� �������������� ����)
	if (Vehicle[vehicleid][AntiDestroyTime] > 0) Vehicle[vehicleid][AntiDestroyTime]--;
	else
	{//��������� ��� ����� ����������
	    if (Vehicle[vehicleid][Owner] == -1) DestroyVehicle(vehicleid); //���� ��������� ������ �� ����������� - ����������
	    else if (!IsPlayerInVehicle(Vehicle[vehicleid][Owner], vehicleid) || (GetPlayerVehicleSeat(Vehicle[vehicleid][Owner]) != 0 && GetPlayerVehicleSeat(Vehicle[vehicleid][Owner]) != 128))
		{//���� �������� ���������� �� �� ����� ����� ����
		    if( IsTrailer[vehicleid] == 0) DestroyVehicle(vehicleid); //���� ��� �� ������� - ����������
		}//���� �������� ���������� �� �� ����� ����� ����
	}//��������� ��� ����� ����������
	
	new Float: newHealth; GetVehicleHealth(vehicleid, newHealth);
	if (newHealth <= Vehicle[vehicleid][Health]) {Vehicle[vehicleid][Health] = newHealth; LACRepair[vehicleid] = 0;}
	else
	{//�������� ���������� ��������� ������, ��� ��� ������ ����
	    new playerid = Vehicle[vehicleid][Owner];
	    if (playerid > -1 && IsPlayerConnected(playerid) && IsPlayerInVehicle(playerid, vehicleid) && LAFK[playerid] < 4)
	    {//�������� ���������� ��������� � ������� � ����� �� ����� ����� ����. ����� �� �� afk, �� � ������� � �� � PayNSpray
			//���� ����� �������������� ���� � ������� ��� � Pay N Spray - �� ������� ����� �������� �������� ����
			if (newHealth == 1000 && (LastPlayerTuneStatus[playerid] != 0 || IsPlayerInPayNSpray(playerid))) {Vehicle[vehicleid][Health] = newHealth; LACRepair[vehicleid] = 0;}
			else
			{//����� �����
			    LACRepair[vehicleid]++; SetVehicleHealth(vehicleid, Vehicle[vehicleid][Health]); //������������� ��������� ��������
			    if (LACRepair[vehicleid] > 4)
			    {
			        new String[140]; DestroyVehicle(vehicleid); TimeTransform[playerid] = 5; LACPanic[playerid]++;//LAC v2.0
					format(String,sizeof(String), "[�������]LAC:{AFAFAF} ��������� ������ %s[%d] ���������. {FF0000}�������: {AFAFAF}�������� ��� �� ������ ����������",PlayerName[playerid], playerid);
		            foreach(Player, cid) if (Player[cid][Admin] != 0 && Logged[cid] == 1) SendClientMessage(cid, COLOR_RED, String);
		    		SendClientMessage(playerid, -1,"{FF0000}LAC:{AFAFAF} ��� ��������� ��� ���������. {FF0000}�������: {AFAFAF}�������� ��� �� ������ ����������");
					format(String, 140, "%d.%d.%d � %d:%d:%d |   LAC: ��������� ������ %s[%d] ���������. �������: �������� ��� �� ������ ����������", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid);
					WriteLog("GlobalLog", String);WriteLog("LAC", String);
				}
			}//����� �����
	    }//�������� ���������� ��������� � ������� � ����� �� ����� ����� ����
	}//�������� ���������� ��������� ������, ��� ��� ������ ����
	
	return 1;
}//������������ ���������� ���������� (�� �������� �� ���� ��� ����� � �� �������������� ����)

public SecPlayerUpdate(playerid)
{//�� ��
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
	    
	    InPeacefulZone[playerid] = 0;//� ������ ����: ������ ����� � ���� ������
	    if (GetPlayerInterior(playerid) != 16 && GetPlayerInterior(playerid) != 0 && InEvent[playerid] == 0) InPeacefulZone[playerid] = 1;//� ���������� (����� PvP)
		if (IsPlayerInRangeOfPoint(playerid, 13.0, 2311.6953,-7.4206,26.7422)) InPeacefulZone[playerid] = 1;//� ����� (�� ��������� ����������)
        if (JoinEvent[playerid] == EVENT_RACE || JoinEvent[playerid] == EVENT_XRACE) InPeacefulZone[playerid] = 1;//� ������
        if (IsPlayerInRangeOfPoint(playerid, 150.0, 2746.9546, -2436.0449, 13.6432) && InEvent[playerid] == 0) InPeacefulZone[playerid] = 1;//���� (������ ��������)
        if (IsPlayerInRangeOfPoint(playerid, 150.0, -1107.8953, -986.4189, 129.2188) && InEvent[playerid] == 0) InPeacefulZone[playerid] = 1;//���� (������ ����������)
		if (GetPlayerVirtualWorld(playerid) == 999) InPeacefulZone[playerid] = 1;//������� ��� (� ���������� ������) - ������ ����
		if (OnVehFly[playerid] == 1 && InPeacefulZone[playerid] > 0) StopVehFly(playerid);//����� ������ ����������� � ������ ����

	    //��������� �� 3 ��� �� ����� (������ �� ���� ����� �� ��� �������� � ����� �����)
	    if (JoinEvent[playerid] == EVENT_DM && DMTimeToEnd == 3){EndEventFreeze(playerid);}
	    if (JoinEvent[playerid] == EVENT_ZOMBIE && ZMTimeToEnd == 3){EndEventFreeze(playerid);}

		//���� ���������� ���, ����� ����� � ������������ ��� ������ � ������ � �� �������, ����� ������� ���������� �� ������
		if ((DMid == 7 && InEvent[playerid] == EVENT_DM) || (GGid == 14 && InEvent[playerid] == EVENT_GUNGAME))
		{//�� �� ������ ���� ������� �� ������
		    if (LastPlayerZ[playerid] < 98.0) {OnPlayerDeath(playerid, -1, -1); LSpawnPlayer(playerid);}
		}//�� �� ������ ���� ������� �� ������

	    //������ ���� � ������
	    if (JoinEvent[playerid] == EVENT_RACE || JoinEvent[playerid] == EVENT_XRACE) if (IsPlayerInAnyVehicle(playerid)) RepairVehicle(GetPlayerVehicleID(playerid));
	    
	    if (AutoBug == 1 && IsPlayerInAnyVehicle(playerid)){DestroyVehicle(PlayerCarID[playerid]);Player[playerid][CarActive] = 0;PlayerCarID[playerid] = -1;}
	    //���������� ���, ����� ����� �� �������� �� ������ � ����� ������������� (�������� DM)

 		if (PrestigeGM[playerid] > 0 && InEvent[playerid] == 0) ResetPlayerWeapons(playerid);//������ ������ � ������ ����

		//������
		if (QuestActive[playerid] > 0)
		{//�� ������� ��� ������
			if (QuestActive[playerid] == 2)
			{//��������� �����
			    WorkTime[playerid]++;
				new wTime[16], wTimeLeft = 300 - WorkTime[playerid], wmin = wTimeLeft / 60, wsec = wTimeLeft - wmin * 60;
				if (wTimeLeft > 30)
				{//������ 30 ������ � ������
					format(wTime, sizeof wTime, "~Y~%s%d~W~:~Y~%s%d", (wmin < 10) ? ("0") : (""), wmin, (wsec < 10) ? ("0") : (""), wsec);
					TextDrawSetString(TextDrawWorkTimer[playerid], wTime); TextDrawShowForPlayer(playerid, TextDrawWorkTimer[playerid]);
				}//������ 30 ������ � ������
				if (wTimeLeft <= 30 && wTimeLeft >= 0)
				{//�������� ������ 30 ������
					format(wTime, sizeof wTime, "~R~%s%d~W~:~R~%s%d", (wmin < 10) ? ("0") : (""), wmin, (wsec < 10) ? ("0") : (""), wsec);
					TextDrawSetString(TextDrawWorkTimer[playerid], wTime); TextDrawShowForPlayer(playerid, TextDrawWorkTimer[playerid]);
				}//������ 30 ������ � ������
				if (wTimeLeft < 0)
				{//����� �����
					TextDrawSetString(TextDrawWorkTimer[playerid], "~R~00~W~:~R~00"); TextDrawShowForPlayer(playerid, TextDrawWorkTimer[playerid]);
				}//����� �����
				if (wTimeLeft == -1) SendClientMessage(playerid, COLOR_QUEST, "������: {FF0000}�� �� ������ ������� � �� �������� ����� �� ������!");
			}//��������� �����
			
			if (QuestActive[playerid] == 3)
	        {//�������
	            WorkTimeGruz[playerid]++; if (WorkTimeGruz[playerid] <= 35) WorkTime[playerid]++;
				new str[16]; format(str, sizeof str, "~Y~%d~W~/~Y~10", GetPVarInt(playerid,"WorkCount"));
                TextDrawSetString(TextDrawWorkTimer[playerid], str); TextDrawShowForPlayer(playerid, TextDrawWorkTimer[playerid]);
                if(GetPVarInt(playerid,"WorkStage") == 2) ApplyAnimation(playerid,"CARRY","crry_prtial",4.1,0,1,1,1,1);//����� �� ������� �������� ����� ����� ����
                
	            if (!IsPlayerInRangeOfPoint(playerid, 150.0, 2746.9546, -2436.0449, 13.6432) || GetPlayerState(playerid) != 1)
	            {//����� ��� ���� ������ ��� �� � ������
	                ApplyAnimation(playerid,"PED","IDLE_tired",4.1,0,1,1,0,1);// �������� ��������
	            	RemovePlayerAttachedObject(playerid,0);// ������� ������ �� ���
	            	DeletePVar(playerid,"WorkStage"); DeletePVar(playerid,"WorkCount");// ������� PVar ������
	            	DisablePlayerCheckpoint(playerid); QuestActive[playerid] = 0;
	            	SendClientMessage(playerid,COLOR_QUEST,"������ <<{FFFFFF}�������{FFCC00}>> ��������.");
	            }//����� ��� ���� ������ ��� �� � ������
	        }//�������
	        
	        if (QuestActive[playerid] == 4)
			{//��������
			    WorkTime[playerid]++;
				new wTime[16], wTimeLeft = 720 - WorkTime[playerid], wmin = wTimeLeft / 60, wsec = wTimeLeft - wmin * 60;
				if (wTimeLeft > 30)
				{//������ 30 ������ � ������
					format(wTime, sizeof wTime, "~Y~%s%d~W~:~Y~%s%d", (wmin < 10) ? ("0") : (""), wmin, (wsec < 10) ? ("0") : (""), wsec);
					TextDrawSetString(TextDrawWorkTimer[playerid], wTime); TextDrawShowForPlayer(playerid, TextDrawWorkTimer[playerid]);
				}//������ 30 ������ � ������
				if (wTimeLeft <= 30 && wTimeLeft >= 0)
				{//�������� ������ 30 ������
					format(wTime, sizeof wTime, "~R~%s%d~W~:~R~%s%d", (wmin < 10) ? ("0") : (""), wmin, (wsec < 10) ? ("0") : (""), wsec);
					TextDrawSetString(TextDrawWorkTimer[playerid], wTime); TextDrawShowForPlayer(playerid, TextDrawWorkTimer[playerid]);
				}//������ 30 ������ � ������
				if (wTimeLeft < 0)
				{//����� �����
					TextDrawSetString(TextDrawWorkTimer[playerid], "~R~00~W~:~R~00"); TextDrawShowForPlayer(playerid, TextDrawWorkTimer[playerid]);
				}//����� �����
				if (wTimeLeft == -1) SendClientMessage(playerid, COLOR_QUEST, "������: {FF0000}�� �� ������ ������� � �������� ������ �������� ����� �� ������!");
			}//��������
			
			if (QuestActive[playerid] == 5)
	        {//���������
	            new Float:Speed, Float:vx, Float:vy, Float:vz, str[24];
			    GetVehicleVelocity(GetPlayerVehicleID(playerid), vx,vy,vz); Speed = floatsqroot(((vx*vx)+(vy*vy)))*200;
	            if (Speed >= 45 && LAFK[playerid] < 4 && -1198.7462 < LastPlayerX[playerid] < -1001.5065 && -1066.4282 < LastPlayerY[playerid] < -908.7125 && GetVehicleModel(GetPlayerVehicleID(playerid)) == 532) WorkTime[playerid]++;//������� ���� ������������� ���� ������� ����(!) �� ����
				format(str, sizeof str, "~Y~%d~W~/~Y~300", WorkTime[playerid]);
                TextDrawSetString(TextDrawWorkTimer[playerid], str); TextDrawShowForPlayer(playerid, TextDrawWorkTimer[playerid]);
       			if (WorkTime[playerid] == 300)
				{//������ 300 ������ ���� (�� 300���)
				    SendClientMessage(playerid, COLOR_QUEST,"������: �� �������� 270 XP � 22500$ �� 300 ������ ����.");
				    LGiveXP(playerid, 300); Player[playerid][Cash] += 22500; WorkTime[playerid] = 0; PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
				}//������ 300 ������ ���� (�� 300���)
	        }//���������
	        
	        if (QuestActive[playerid] == 6)
			{//������������
			    WorkTime[playerid]++;
				new wTime[16], wTimeLeft = 720 - WorkTime[playerid], wmin = wTimeLeft / 60, wsec = wTimeLeft - wmin * 60;
				if (wTimeLeft > 30)
				{//������ 30 ������ � ������
					format(wTime, sizeof wTime, "~Y~%s%d~W~:~Y~%s%d", (wmin < 10) ? ("0") : (""), wmin, (wsec < 10) ? ("0") : (""), wsec);
					TextDrawSetString(TextDrawWorkTimer[playerid], wTime); TextDrawShowForPlayer(playerid, TextDrawWorkTimer[playerid]);
				}//������ 30 ������ � ������
				if (wTimeLeft <= 30 && wTimeLeft >= 0)
				{//�������� ������ 30 ������
					format(wTime, sizeof wTime, "~R~%s%d~W~:~R~%s%d", (wmin < 10) ? ("0") : (""), wmin, (wsec < 10) ? ("0") : (""), wsec);
					TextDrawSetString(TextDrawWorkTimer[playerid], wTime); TextDrawShowForPlayer(playerid, TextDrawWorkTimer[playerid]);
				}//������ 30 ������ � ������
				if (wTimeLeft < 0)
				{//����� �����
					TextDrawSetString(TextDrawWorkTimer[playerid], "~R~00~W~:~R~00"); TextDrawShowForPlayer(playerid, TextDrawWorkTimer[playerid]);
				}//����� �����
				if (wTimeLeft == -1) SendClientMessage(playerid, COLOR_QUEST, "������: {FF0000}�� �� ������ ������� � �������� ������ �������� ����� �� ������!");
			}//������������
			
			if (QuestActive[playerid] == 7)
			{//������� �������
			    WorkTime[playerid]++;
				new wTime[16], wTimeLeft = 480 - WorkTime[playerid], wmin = wTimeLeft / 60, wsec = wTimeLeft - wmin * 60;
				if (wTimeLeft > 30)
				{//������ 30 ������ � ������
					format(wTime, sizeof wTime, "~Y~%s%d~W~:~Y~%s%d", (wmin < 10) ? ("0") : (""), wmin, (wsec < 10) ? ("0") : (""), wsec);
					TextDrawSetString(TextDrawWorkTimer[playerid], wTime); TextDrawShowForPlayer(playerid, TextDrawWorkTimer[playerid]);
				}//������ 30 ������ � ������
				if (wTimeLeft <= 30 && wTimeLeft >= 0)
				{//�������� ������ 30 ������
					format(wTime, sizeof wTime, "~R~%s%d~W~:~R~%s%d", (wmin < 10) ? ("0") : (""), wmin, (wsec < 10) ? ("0") : (""), wsec);
					TextDrawSetString(TextDrawWorkTimer[playerid], wTime); TextDrawShowForPlayer(playerid, TextDrawWorkTimer[playerid]);
				}//������ 30 ������ � ������
				if (wTimeLeft < 0)
				{//����� �����
					TextDrawSetString(TextDrawWorkTimer[playerid], "~R~00~W~:~R~00"); TextDrawShowForPlayer(playerid, TextDrawWorkTimer[playerid]);
				}//����� �����
				if (wTimeLeft == -1) SendClientMessage(playerid, COLOR_QUEST, "������: {FF0000}�� �� ������ ������� � �������� ������ �������� ����� �� ������!");
			}//������� �������
			
			if (QuestActive[playerid] == 8)
			{//����������
			    WorkTime[playerid]++;
				new wTime[16], wTimeLeft = 600 - WorkTime[playerid], wmin = wTimeLeft / 60, wsec = wTimeLeft - wmin * 60;
				if (wTimeLeft > 30)
				{//������ 30 ������ � ������
					format(wTime, sizeof wTime, "~Y~%s%d~W~:~Y~%s%d", (wmin < 10) ? ("0") : (""), wmin, (wsec < 10) ? ("0") : (""), wsec);
					TextDrawSetString(TextDrawWorkTimer[playerid], wTime); TextDrawShowForPlayer(playerid, TextDrawWorkTimer[playerid]);
				}//������ 30 ������ � ������
				if (wTimeLeft <= 30 && wTimeLeft >= 0)
				{//�������� ������ 30 ������
					format(wTime, sizeof wTime, "~R~%s%d~W~:~R~%s%d", (wmin < 10) ? ("0") : (""), wmin, (wsec < 10) ? ("0") : (""), wsec);
					TextDrawSetString(TextDrawWorkTimer[playerid], wTime); TextDrawShowForPlayer(playerid, TextDrawWorkTimer[playerid]);
				}//������ 30 ������ � ������
				if (wTimeLeft < 0)
				{//����� �����
					TextDrawSetString(TextDrawWorkTimer[playerid], "~R~00~W~:~R~00"); TextDrawShowForPlayer(playerid, TextDrawWorkTimer[playerid]);
				}//����� �����
				if (wTimeLeft == -1) SendClientMessage(playerid, COLOR_QUEST, "������: {FF0000}�� �� ������ ������� � �������� ������ �������� ����� �� ������!");
			}//����������
	        
	        if (InEvent[playerid] > 0)
	        {//����� � �������������, �� ��� ���� ������ ��� ������� �������
	            if (JoinEvent[playerid] != EVENT_RACE && JoinEvent[playerid] != EVENT_XRACE) {DisablePlayerCheckpoint(playerid); DisablePlayerRaceCheckpoint(playerid);}
	            if (QuestActive[playerid] == 3)
	            {//��������� ������ ��������
	                ApplyAnimation(playerid,"PED","IDLE_tired",4.1,0,1,1,0,1);// �������� ��������
	            	RemovePlayerAttachedObject(playerid,0);// ������� ������ ������ �� ���
	            	DeletePVar(playerid,"WorkStage"); DeletePVar(playerid,"WorkCount");// ������� PVar ������
	            }//��������� ������ ��������
	            if (QuestActive[playerid] == 4)
	            {//��������� ������ ���������
	            	RemovePlayerAttachedObject(playerid,0);// ������� ������ ������ �� ���
	            	DeletePVar(playerid,"WorkDomStage");// ������� PVar ������
	            }//��������� ������ ���������
	            if (QuestActive[playerid] == 5) GangZoneHideForPlayer(playerid, WorkZoneCombine);//���� ����������
                if (QuestActive[playerid] == 6) DeletePVar(playerid,"WorkTruckStage");// ������� PVar ������
                if (QuestActive[playerid] == 7) DeletePVar(playerid,"WorkWaterStage");// ������� PVar ������
                if (QuestActive[playerid] == 8) DeletePVar(playerid,"WorkBankStage");// ������� PVar ������
				QuestActive[playerid] = 0;
	        }//����� � �������������, �� ��� ���� ������ ��� ������� �������
	        if (GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USEJETPACK) SetPlayerSpecialAction(playerid,0);
		}//�� ������� ��� ������
		else {WorkTime[playerid] = 0; TextDrawHideForPlayer(playerid, TextDrawWorkTimer[playerid]);}
		
        if (Logged[playerid] == 1)
		{//���������� Score � �����
			SetPlayerScore(playerid,Player[playerid][Level]); //���������� score
            if (LastPlayerTuneStatus[playerid] > 0)
			{//����� � �������
			    if (GetPlayerMoney(playerid) < Player[playerid][Cash]) Player[playerid][Cash] = GetPlayerMoney(playerid); //����� ����� ��� ������� ������ �� ������
			}//����� � �������
			else {ResetPlayerMoney(playerid); GivePlayerMoney(playerid, Player[playerid][Cash]);} //���������� �����
		} else SetPlayerScore(playerid,0); 
		//����� � ������ ��������� ������ �� ������

		//����� ����� �� ������ ��� 500� � �����
		if (Player[playerid][Cash] >= 500000 && GetPVarInt(playerid,"CashBag") == 0) {SetPVarInt(playerid, "CashBag", 1); SetPlayerAttachedObject(playerid,1,1550,1,0.0,-0.245,0.0,270.0,103.0,70.0);}
		else if (Player[playerid][Cash] < 500000 && GetPVarInt(playerid,"CashBag") == 1){SetPVarInt(playerid, "CashBag", 0); RemovePlayerAttachedObject(playerid,1);}

		if (Player[playerid][Banned] != 0) {SetPlayerVirtualWorld(playerid,666);SetPlayerChatBubble(playerid, "�������", COLOR_RED, 300.0, 1001);}//��

		if (SkydiveTime[playerid] > 0){SkydiveTime[playerid]--;}
        if (InviteTime[playerid] > -1){InviteTime[playerid] --;}
        if (InviteTime[playerid] == 0){ShowPlayerDialog(playerid, 777, 0, "����������� � ����", "{008E00}��������! ��� ���������� � ����, �� �� �� ������ ������� �����������..", "��", "");}
    	if (FloodTime[playerid] > 0){FloodTime[playerid]--;}
    	if (HealthTime[playerid] > 0){HealthTime[playerid]--;}
		if (ArmourTime[playerid] > 0){ArmourTime[playerid]--;}
		if (UberNitroTime[playerid] > 0) UberNitroTime[playerid]--;
		if (AdminTPCantKill[playerid] > 0){AdminTPCantKill[playerid]--;}
		if (RepairTime[playerid] > 0) RepairTime[playerid]--;
		if (RepairTime[playerid] == 0 && Player[playerid][SkillRepair] > 0 && GetPlayerVehicleSeat(playerid) == 0 && InEvent[playerid] == 0)
		{//����-������� ����
	        new Float: vehhealth; GetVehicleHealth(GetPlayerVehicleID(playerid), vehhealth);
	        if (vehhealth < 1000.0)
			{//���� �� �����
			    RepairVehicle(GetPlayerVehicleID(playerid));
			    SetPlayerChatBubble(playerid, "��������� ������������� ��������������.", COLOR_GREEN, 100.0, 3000);
			    PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
			    RepairTime[playerid] = 40 - Player[playerid][SkillRepair];
			}//���� �� �����
		}//����-������� ����
		if (HPRegenTime[playerid] == 0 && Player[playerid][SkillHP] > 0 && GMTestStage[playerid] == 0 && InEvent[playerid] == 0 && PlayerPVP[playerid][Status] < 2)
		{//����������� HP (�����)
		    new Float: hp;GetPlayerHealth(playerid, hp);
		    if (Player[playerid][PHealth] < 100.0 && InEvent[playerid] == 0)
		    {
		        HPRegenTime[playerid] = 5;
		        if (hp + Player[playerid][SkillHP] <= 100.0) SetPlayerHealth(playerid, hp + Player[playerid][SkillHP]);
		        else SetPlayerHealth(playerid, 100.0);
		    }
		}//����������� HP (�����)
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
        WeaponShotsLastSecond[playerid] = 0;//���-�� ��������� �� ��������� �������
	 	//�������� ���������� �����-���
		if (LevelUp[playerid] > -1){LevelUp[playerid]--;}
		if (LevelUp[playerid] == 0)
		{
			TextDrawHideForPlayer(playerid, LevelupTD[playerid]);
			PlayerPlaySound(playerid, 19801, 0.0,0.0,0.0);//���������� ����
		}

        if (GMTestTime[playerid] > 0)
		{
			GMTestTime[playerid]--;new tester= GMTesterID[playerid];
			if (GMTestTime[playerid] == 0){GMTestStage[playerid] = 0;SendClientMessage(tester,COLOR_YELLOW,"GMTest: ������������ ��������, ��� ��� ����� AFK");}

		}

		if (ArmourTime[playerid] == 59){SetPlayerArmour(playerid, 100.0);}
		if (AntiPlus[playerid] > -1) AntiPlus[playerid] --;
		if (PlayerPVP[playerid][TimeOut] == 1)
		{
			PlayerPVP[playerid][TimeOut] = 0;PlayerPVP[playerid][Status] = 0;PlayerPVP[playerid][Invite] = -1;CanStartPVP[playerid] = 0;
			SendClientMessage(playerid,COLOR_RED,"����� �������� ����������� �� ����� �������.");
			if (JoinEvent[playerid] == EVENT_PVP) JoinEvent[playerid] = 0;
		}
		if (PlayerPVP[playerid][TimeOut] > 1){PlayerPVP[playerid][TimeOut]--;}
        if (LeaveDM[playerid] > 0) LeaveDM[playerid]--;
        if (LeaveGG[playerid] > 0) LeaveGG[playerid]--;

		if (LoginKickTime[playerid] > 0)
		{//��� ���� ������� �� ���� ������
			LoginKickTime[playerid]--;
			if (LoginKickTime[playerid] == 0) Kick(playerid);
			else if (LoginKickTime[playerid] <= 30)
			{
				new StringZ[20];
				format(StringZ, sizeof StringZ, "~R~%d", LoginKickTime[playerid]);
			    GameTextForPlayer(playerid, StringZ, 1000, 6);
		    }
		}//��� ���� ������� �� ���� ������
		

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

		//�����������
		if (Player[playerid][BuddhaTime] == 1){SendClientMessage(playerid,COLOR_QUEST,"������� ����� � ������ ������ ��������!");PlayerPlaySound(playerid,1083,0.0,0.0,0.0);}//���� ��������
        if (QuestTime[playerid][0] == 1 || QuestTime[playerid][1] == 1 || QuestTime[playerid][2] == 1){SendClientMessage(playerid,COLOR_QUEST,"QUEST: ����� ������� ������ ��������! ������ {FF0000}/quests");PlayerPlaySound(playerid,1083,0.0,0.0,0.0);}//���� ��������

		if (Player[playerid][HelpTime] > 0) Player[playerid][HelpTime]--;
		if (Player[playerid][HelpTime] == 0)
		{//������� ���������
		    if (Player[playerid][Level] < 5 && Player[playerid][Prestige] == 0)
		    {//������� ������� 5
		        new hms = random(5) + 1; Player[playerid][HelpTime] = 180;//������ 3 ������ ��� ��������
		        if (hms == 1) SendClientMessage(playerid,COLOR_CYAN,"���������: �� ������ ������ ��������� �� ����� ���� ��������� {FFFFFF}Y {00CCCC}� {FFFFFF}N.");
		        if (hms == 2) SendClientMessage(playerid,COLOR_CYAN,"���������: ����������� ������� {FFFFFF}/bg{00CCCC} ����� ������ ������.");
		        if (hms == 3) SendClientMessage(playerid,COLOR_CYAN,"���������: �������� {FFFFFF}/help{00CCCC} ���� � ��� ���� ������� �� ����.");
		        if (hms == 4) SendClientMessage(playerid,COLOR_CYAN,"���������: ���������� � ������������� (�����, �����, ����� �.�.) ����� �������� ���� �������.");
		        if (hms == 5) SendClientMessage(playerid,COLOR_CYAN,"���������: ����������� {FFFFFF}/gps{00CCCC} ����� ����� ������.");
		    }//������� ������� 5
		    if (Player[playerid][Level] >= 5 && Player[playerid][Level] < 20 && Player[playerid][Prestige] == 0)
		    {//������� ������ 5
		        new hms = random(9) + 1; Player[playerid][HelpTime] = 240;//������ 4 ������ ��� "�����" ��������
		        if (hms == 1) SendClientMessage(playerid,COLOR_CYAN,"���������: ����������� {FFFFFF}/gps{00CCCC} ����� ����� ������.");
		        if (hms == 2) SendClientMessage(playerid,COLOR_CYAN,"���������: ����� �������� ���� ��������� ����������� {FFFFFF}Alt - �������� ��� ����������{00CCCC}.");
		        if (hms == 3) SendClientMessage(playerid,COLOR_CYAN,"���������: ����������� {FFFFFF}/mygun{00CCCC} ����� �������� ������ ������. ��� �������� ����� ������.");
		        if (hms == 4) SendClientMessage(playerid,COLOR_CYAN,"���������: � {FFFFFF}/radio {00CCCC}������ ����������!");
		        if (hms == 5) SendClientMessage(playerid,COLOR_CYAN,"���������: ��� ������ {FFFFFF}/myspawn{00CCCC} �� ������ �������� ����� � ����� ������.");
		        if (hms == 6) SendClientMessage(playerid,COLOR_CYAN,"���������: �������� {FFFFFF}/help{00CCCC} ���� � ��� ���� ������� �� ����.");
		        if (hms == 7) SendClientMessage(playerid,COLOR_CYAN,"���������: ������� {FFFFFF}/stats{00CCCC} ��� ����������� ����� ����������.");
                if (hms == 8) SendClientMessage(playerid,COLOR_CYAN,"���������: �������� ������? �������� ����������� ����� {FFFFFF}@{00CCCC}�����.");
                if (hms == 9) SendClientMessage(playerid,COLOR_CYAN,"���������: �� ��������� ��������� �������! ������� {FFFFFF}/quests{00CCCC} ����� ���������� ������ �������.");
 		    }//������� ������ 5
		    if (Player[playerid][Level] >= 20 || Player[playerid][Prestige] > 0)
		    {
		        new hms = random(5) + 1; Player[playerid][HelpTime] = 300;//������ 5 ����� ��� ���� ���������
                if (hms == 1) SendClientMessage(playerid,COLOR_CYAN,"���������: �������� {FFFFFF}/help{00CCCC} ���� � ��� ���� ������� �� ����.");
                if (hms == 2) SendClientMessage(playerid,COLOR_CYAN,"���������: � {FFFFFF}/radio {00CCCC}������ ����������!");
                if (hms == 3) SendClientMessage(playerid,COLOR_CYAN,"���������: ����������� {FFFFFF}/config {00CCCC}����� ������� ���� �������� ��������.");
                if (hms == 4) SendClientMessage(playerid,COLOR_CYAN,"���������: �������� ������? �������� ����������� ����� {FFFFFF}@{00CCCC}�����.");
                if (hms == 5) SendClientMessage(playerid,COLOR_CYAN,"���������: �� ��������� ��������� �������! ������� {FFFFFF}/quests{00CCCC} ����� ���������� ������ �������.");
		    }
		}//������� ���������

		//MaxMoney
		if (Player[playerid][Cash] > 999999999)
		{
		    Player[playerid][Cash] = 999999999;
		    SendClientMessage(playerid,COLOR_RED,"��������! � ��� ������������ ���������� �����! ��� ������ ������ ���� ����������...");
		}

		if(Player[playerid][Muted] > 0 && LAFK[playerid] < 60){Player[playerid][Muted] -= 1;}

		//����������� ������, ����� ����� � ���������� ������������ � �� ����� �� ���� �����
		if (DMTimer > 600 && JoinEvent[playerid] == EVENT_DM && DMTimeToEnd < 1) JoinEvent[playerid] = 0;
		if (DerbyTimer > 600 && JoinEvent[playerid] == EVENT_DERBY) JoinEvent[playerid] = 0;
		if (ZMTimer > 600 && JoinEvent[playerid] == EVENT_ZOMBIE && ZMTimeToEnd < 1) JoinEvent[playerid] = 0;
		if (FRTimer > 600 && JoinEvent[playerid] == EVENT_RACE) JoinEvent[playerid] = 0;
		if (XRTimer > 600 && JoinEvent[playerid] == EVENT_XRACE && XRStarted[playerid] == 0) JoinEvent[playerid] = 0;
		if (GGTimer > 600 && JoinEvent[playerid] == EVENT_GUNGAME && GGTimeToEnd < 1) JoinEvent[playerid] = 0;

		//--- ������������� ������ � �������
		if (LSpecID[playerid] == -1)
		{//����� �� � �������
		    //������
			if (PlayerWeather[playerid] != -1 && InEvent[playerid] == 0)
				SetPlayerWeather(playerid, PlayerWeather[playerid]);
			else SetPlayerWeather(playerid, ServerWeather);
			//�����
			if (PlayerTime[playerid] != -1 && InEvent[playerid] == 0)
				SetPlayerTime(playerid, PlayerTime[playerid], minute);
			else SetPlayerTime(playerid, hour, minute);
		}//����� �� � �������
		else
		{//����� � �������
		    new specid = LSpecID[playerid];
		    if (PlayerWeather[specid] != -1 && InEvent[specid] == 0)
				SetPlayerWeather(playerid, PlayerWeather[specid]);
			else SetPlayerWeather(playerid, ServerWeather);
			//�����
			if (PlayerTime[specid] != -1 && InEvent[specid] == 0)
				SetPlayerTime(playerid, PlayerTime[specid], minute);
			else SetPlayerTime(playerid, hour, minute);
		}//����� � �������
		//--- ������������� ������ � �������

		if (AirportTime[playerid] >= 0){AirportTime[playerid] --;}
		if (AirportTime[playerid] == 0 && InEvent[playerid] == 0)
		{//������� ����� ����
		    if (AirportID[playerid] > 0 && AirportID[playerid] <= 5)
		    {
			    SetPlayerInterior(playerid,0);SetPlayerVirtualWorld(playerid, 0);
			    if (AirportID[playerid] == 1)
			    {
			        SetPlayerPos(playerid,1451.6349, -2287.0703, 13.5469);SetPlayerFacingAngle(playerid,90.0);SetCameraBehindPlayer(playerid);
			        SendClientMessage(playerid,COLOR_YELLOW,"����� ���������� � {FFFFFF}��� ������");
				}
				if (AirportID[playerid] == 2)
			    {
			        SetPlayerPos(playerid,-1404.6575, -303.7458, 14.1484);SetPlayerFacingAngle(playerid,140.0);SetCameraBehindPlayer(playerid);
			        SendClientMessage(playerid,COLOR_YELLOW,"����� ���������� � {FFFFFF}��� ������");
				}
				if (AirportID[playerid] == 3)
			    {
			        SetPlayerPos(playerid,1672.9861, 1447.9349, 10.7868);SetPlayerFacingAngle(playerid,270.0);SetCameraBehindPlayer(playerid);
			        SendClientMessage(playerid,COLOR_YELLOW,"����� ���������� � {FFFFFF}��� ��������");
				}
				if (AirportID[playerid] == 4)
			    {
			        SetPlayerPos(playerid,-2281.9551, 2288.5420, 4.9740);SetPlayerFacingAngle(playerid,270.0);SetCameraBehindPlayer(playerid);
			        SendClientMessage(playerid,COLOR_YELLOW,"����� ���������� � {FFFFFF}�������");
				}
			}
		}//������� ����� ����

		//�������� ����� � �������������
		if(InEvent[playerid] > 0 && InEvent[playerid] != EVENT_PVP){SetPlayerArmour(playerid, 0);}

		//����������� ���� ���� ���������� � ����������� ������� �� �������������
		if (TimeTransform[playerid] > 0){TimeTransform[playerid]--;new String[5];format(String,sizeof(String),"%d",TimeTransform[playerid]);GameTextForPlayer(playerid, String,1000,6);}
		if (IsPlayerInVehicle(playerid,PlayerCarID[playerid]))
		{//����� � ����� ������
			GetVehicleHealth(PlayerCarID[playerid], carhealth);
			if (PrestigeGM[playerid] == 1 && InEvent[playerid] == 0) RepairVehicle(PlayerCarID[playerid]);
			if (carhealth <= 250 && PrestigeGM[playerid] == 0){DestroyVehicle(PlayerCarID[playerid]);PlayerCarID[playerid] = 0;Player[playerid][CarActive] = 0;TimeTransform[playerid] = 10;}
		}//����� � ����� ������

        if (second == 0)
        {//���������� �������� ���-�� �������� �� ������� ��� � ������
            LSpectators[playerid] = 0;
            foreach(Player, i)
			{//����
			    if(LSpecID[i] == playerid && IsPlayerConnected(i)){LSpectators[playerid] += 1;}
			}//����
        }//���������� �������� ���-�� �������� �� ������� ��� � ������

		if (Player[playerid][BuddhaTime] > 0){Player[playerid][BuddhaTime]--;}
        if (QuestTime[playerid][0] > 0) QuestTime[playerid][0]--;
        if (QuestTime[playerid][1] > 0) QuestTime[playerid][1]--;
        if (QuestTime[playerid][2] > 0) QuestTime[playerid][2]--;
        
		if (LAFK[playerid] < 600)
		{//����� �� � ���, ���� ��� ����� 10 �����
			Player[playerid][Time]++;//����� ����� �� �����
		    if (Player[playerid][GPremium] >= 3 && Player[playerid][Time] == Player[playerid][Time] / 3600 * 3600)
		    {//ViP 3: +500k � ���
		        PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
		        if (Player[playerid][Bank] <= 999499999)
		        {
			        Player[playerid][Bank] += 500000;
					SendClientMessage(playerid, 0x00FF00FF, "ViP: �� �������� ���������� ����� � ������� 500 000$ �� ��� ���������� ����");
				}
				else
				{
				    Player[playerid][Cash] += 500000;
					SendClientMessage(playerid, 0x00FF00FF, "ViP: �� �������� ���������� ����� � ������� 500 000$");
				}
		    }//ViP 3: +500k � ���
	    }//����� �� � ���, ���� ��� ����� 10 �����

		//---------- �����
		if (LAFK[playerid] < 60){Player[playerid][KarmaTime]++;}
		new xkarm = Player[playerid][KarmaTime] / 600;new xkarm2 = xkarm*600;//����� �� 600 ��� ������� � �������� �� 600
		if (xkarm2 == Player[playerid][KarmaTime])
		{//���� ������ ��� 10 ����� ��� ������� � ���� ��������� �����
		    new Float: x, Float: y, Float: z;GetPlayerPos(playerid,x,y,z);
			new Float: xdist = x - KarmaX[playerid], Float: ydist = y - KarmaY[playerid];
			if (xdist < 0) xdist = xdist * -1;//���������� �������� �� X �� ����� ����������� ���������� �����
			if (ydist < 0) ydist = ydist * -1;//���������� �������� �� Y �� ����� ����������� ���������� �����
		    if (xdist < 10 && ydist < 10) SendClientMessage(playerid,COLOR_RED,"�� �� �������� ����� ����� ��� ��� �� ����� ������ �� �����.");
		    else
		    {//����� �� ����� �� ����� � ��� ���� ��������� �����
		        new String[120], kpoint;
	      	    if(xkarm == 1) kpoint = 2; if(xkarm == 2) kpoint = 4;
			    if(xkarm == 3) kpoint = 6; if(xkarm == 4) kpoint = 8;
			    if(xkarm >= 5) kpoint = 10;
				Player[playerid][Karma] += kpoint;
				if (Player[playerid][Karma] > 1000) Player[playerid][Karma] = 1000;
				else
				{
					format(String,sizeof(String),"�� �������� %d ����� �����! ������������ ��� ������� ��� 10 ����� � �� �������� ������.",kpoint);SendClientMessage(playerid,COLOR_YELLOW,String);
					if(Player[playerid][GPremium] >= 7){format(String,sizeof(String),"ViP: �� �������� ����� %d ����� �����",kpoint/2);SendClientMessage(playerid,0x00FF00FF,String);Player[playerid][Karma] += kpoint/2;}
					PlayerPlaySound(playerid,1083,0.0,0.0,0.0);//���� ��������
				}
			    KarmaX[playerid] = x; KarmaY[playerid] = y; KarmaZ[playerid] = z;
		    }//����� �� ����� �� ����� � ��� ���� ��������� �����
		}//���� ������ ��� 10 ����� ��� ������� � ���� ��������� �����

		//---------- ������������� ����� ������
		if (Logged[playerid] == 0) SetPlayerColor(playerid,0xAFAFAFFF);//�� �����������
		else
		{//����� �����������
			new colorid = PlayerColor[playerid], clanid = Player[playerid][MyClan];
			if (Player[playerid][MyClan] < 1 || Clan[clanid][cBase] < 1) colorid = 0; //���� ����� �� � ����� ��� ���� � ����� ��� ����� - ���� ���� ����� �����
			
	        if (Player[playerid][Invisible] > 0 && InEvent[playerid] == 0) SetPlayerColor(playerid, ClanColorInvisible[colorid]);//� ������������
			else
			{//��� ����������� ��� � �������
			    if (Player[playerid][PrestigeColor] >= 0) colorid = Player[playerid][PrestigeColor]; //���� 7-�� ��������
				SetPlayerColor(playerid, ClanColor[colorid]);

				if (InEvent[playerid] == EVENT_ZOMBIE && ZMIsPlayerIsZombie[playerid] > 0) SetPlayerColor(playerid, ClanColorInvisible[colorid]);
			}//��� ����������� ��� � �������
		}//����� �����������
		//---------- ������������� ����� ������

		if  (SkinChangeMode[playerid] == 1) JoinEvent[playerid] = 0;//����������� ���� ��� ��������� �����

		//--------- PVP
		if (PlayerPVP[playerid][Status] >= 2)
		{//����� � PVP
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
		    {//����� ������ PVP
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
		    }//����� ������ PVP
		}//����� � PVP
        //--------- PVP

        if (OnFly[playerid] == 1)//���������� ������ ��������� � ������� � ��
        {if (IsPlayerInAnyVehicle(playerid) || InEvent[playerid] > 0) StopFly(playerid); else SetPlayerChatBubble(playerid,"Superman (�������)",COLOR_YELLOW,200,1001);}

		if (GetPlayerPing(playerid) < MAX_PING) BadPingTime[playerid] = 0;
		else
		{
		    BadPingTime[playerid]++;
		    if (BadPingTime[playerid] == 10)
		    {
		        new String[140]; GKick(playerid);
				format(String,sizeof(String), "SERVER: %s[%d] ��� ������������� ������ (Ping: %d).", PlayerName[playerid], playerid, GetPlayerPing(playerid));
				return SendClientMessageToAll(COLOR_GREY, String);
		    }
		}
    	#include "Transformer\LAC" //Lomt1k`s AntiCheat
		if (GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USEJETPACK && InEvent[playerid] != 0) SetPlayerSpecialAction(playerid, 0); //���������� ��� � ��������� �� �������������
		//������� ���������� � ������ ������������, ���� ����� ��� �����
		if (JoinEvent[playerid] == 0) for (new i = 1; i <= 6; i++) TextDrawHideForPlayer(playerid, TextDrawEvent[i]);

	    LAFK[playerid] += 1;
		if (LAFK[playerid] >= 3)
		{
		    new afstring[120];
		    if (LAFK[playerid] > 60){new mi = LAFK[playerid]/60; format(afstring,sizeof(afstring),"AFK (%d ����� %d ������)",mi,LAFK[playerid] - 60 * mi);}
			else {format(afstring,sizeof(afstring),"AFK (%d ������)",LAFK[playerid]);}
			SetPlayerChatBubble(playerid,afstring,COLOR_GREY, 80.0,1000);NeedSpeedDown[playerid] = 1; LACSH[playerid] = 3;
		}
		
		return 1;
}//�� ��


public OnPlayerModelSelection(playerid, response, listid, modelid)
{//����
	if(listid == MenuMyskin)
    {//myskin
        if(response)
        {
            SendClientMessage(playerid, COLOR_YELLOW, "������ ��������� ������� ��������");
            SetPlayerSkin(playerid,modelid);Player[playerid][Model] = modelid;
	    }
	}//myskin
	
	if(listid == MenuFirstCar)
    {//����� ������� ���������� (��������)
		if(response)
		{//�������
		    Player[playerid][CarSlot2] = modelid;TutorialStep[playerid] = 3;
		    new String[1024];
			strcat(String, "{007FFF}��������: �������������{FFFFFF}\n\n");
			strcat(String, "�� ������ ����� �� ����� ���� ������������������ �� ������ � ����������!\n");
			strcat(String, "��� ����� ����������� ������� {00FF00}Y{FFFFFF} � {00FF00}N\n");
			strcat(String, "\n\n{FFFF00}������� �� � ����������������� � ���������� �������� {00FF00}Y{FFFF00} ��� {00FF00}N");
			ShowPlayerDialog(playerid, DIALOG_TUTORIAL, 0, "��������", String, "��", "");
		}//�������
		else{ShowModelSelectionMenu(playerid, MenuFirstCar, "First Car");}
	}//����� ������� ���������� (��������)
	
	if(listid == MenuClass1)
    {//����� ���� ����� 1
			if(response)
			{
			    if(modelid == 1343)
				{//������� - ������� ���������
				    Player[playerid][CarSlot1] = 0;
					return SendClientMessage(playerid,COLOR_YELLOW,"���������� 1-�� ������ ������");
				}//������� - ������� ���������

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
				if (Player[playerid][Karma] >= 800) CarPrice /= 2;//��� ����� 800+ ��������� ����� � ��� ���� �������
				
				if (Player[playerid][Level] < CarLevel){ShowModelSelectionMenu(playerid, MenuClass1, "Car Class 1");format(String,sizeof(String),"������: �� ������ ���� ��� ������� %d-�� ������",CarLevel);return SendClientMessage(playerid,COLOR_RED,String);}
				if (Player[playerid][Cash] < CarPrice && CarPrice > 0){ShowModelSelectionMenu(playerid, MenuClass1, "Car Class 1");format(String,sizeof(String),"������: ��� ����� ��� ������� %d$",CarPrice);return SendClientMessage(playerid,COLOR_RED,String);}
				Player[playerid][CarSlot1] = modelid;Player[playerid][Cash] -= CarPrice; ResetTuneClass1(playerid);
				Player[playerid][CarActive] = 0;
				modelid -= 400;format(String,sizeof(String),"��� ����� ���������� 1-�� ������ - %s",PlayerVehicleName[modelid]);SendClientMessage(playerid,COLOR_YELLOW,String);
				if (CarPrice > 0){format(String,sizeof(String),"�� ��������� �� ���� %d$",CarPrice);SendClientMessage(playerid,COLOR_YELLOW,String);}
			}
			else{ShowPlayerDialog(playerid, 3, 2, "������ ������� ����������", "����� 1\n����� 2\n����� 3\n{FFFF00}Prestige{FFFFFF}\n������", "��", "");}
    }//����� ���� ����� 1
    
    if(listid == MenuClass2)
    {//����� ���� ����� 2
    if(response)
			{
			    if(modelid == 1343)
				{//������� - ������� ���������
				    Player[playerid][CarSlot2] = 0;
					return SendClientMessage(playerid,COLOR_YELLOW,"���������� 2-�� ������ ������");
				}//������� - ������� ���������
				
				if(modelid == 365)
				{//paintjob
					if (Player[playerid][Level] < 55){ShowModelSelectionMenu(playerid, MenuClass2, "Car Class 2");SendClientMessage(playerid,COLOR_RED,"������: �� ������ ���� ��� ������� 55-�� ������");return 1;}
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
				if (Player[playerid][Karma] >= 800) CarPrice /= 2;//��� ����� 800+ ��������� ����� � ��� ���� �������
				
                if (Player[playerid][Level] < CarLevel){ShowModelSelectionMenu(playerid, MenuClass2, "Car Class 2");format(String,sizeof(String),"������: �� ������ ���� ��� ������� %d-�� ������",CarLevel);return SendClientMessage(playerid,COLOR_RED,String);}
				if (Player[playerid][Cash] < CarPrice && CarPrice > 0){ShowModelSelectionMenu(playerid, MenuClass2, "Car Class 2");format(String,sizeof(String),"������: ��� ����� ��� ������� %d$",CarPrice);return SendClientMessage(playerid,COLOR_RED,String);}
				Player[playerid][CarSlot2] = modelid;Player[playerid][Cash] -= CarPrice; ResetTuneClass2(playerid);
                Player[playerid][CarActive] = 0;
				modelid -= 400;format(String,sizeof(String),"��� ����� ���������� 2-�� ������ - %s",PlayerVehicleName[modelid]);SendClientMessage(playerid,COLOR_YELLOW,String);
				if (CarPrice > 0){format(String,sizeof(String),"�� ��������� �� ���� %d$",CarPrice);SendClientMessage(playerid,COLOR_YELLOW,String);}
    		}
    		else{ShowPlayerDialog(playerid, 3, 2, "������ ������� ����������", "����� 1\n����� 2\n����� 3\n{FFFF00}Prestige{FFFFFF}\n������", "��", "");}
    }//����� ���� ����� 2

    if(listid == MenuClass3)
    {//����� ���� ����� 3
    		if(response)
			{
			    if(modelid == 1343)
				{//������� - ������� ���������
				    Player[playerid][CarSlot3] = 0;
					return SendClientMessage(playerid,COLOR_YELLOW,"���������� 3-�� ������ ������");
				}//������� - ������� ���������
				
				if(modelid == 539)
				{//UberVortex
					if (Player[playerid][Level] < 90){ShowModelSelectionMenu(playerid, MenuClass3, "Car Class 3");SendClientMessage(playerid,COLOR_RED,"������: �� ������ ���� ��� ������� 90-�� ������");return 1;}
					if (Player[playerid][Cash] < 200000 && Player[playerid][Karma] < 900){ShowModelSelectionMenu(playerid, MenuClass3, "Car Class 3");return SendClientMessage(playerid,COLOR_RED,"������: ��� ����� ��� ������� 200000$");}
					Player[playerid][CarSlot3] = 539;
					
					SendClientMessage(playerid,COLOR_YELLOW,"��� ����� ���������� 3-�� ������ - {9966CC}Uber{007FFF}Vortex");
					if (Player[playerid][Karma] < 900){Player[playerid][Cash] -= 200000; SendClientMessage(playerid,COLOR_YELLOW,"�� ��������� �� ���� 150000$");}
					return SendClientMessage(playerid,COLOR_YELLOW,"������ �������: [���] - ���������, [2] - �����, [�����] - �����������");
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
                if (Player[playerid][Karma] >= 800) CarPrice /= 2;//��� ����� 800+ ��������� ����� � ��� ���� �������

                if (Player[playerid][Level] < CarLevel){ShowModelSelectionMenu(playerid, MenuClass3, "Car Class 3");format(String,sizeof(String),"������: �� ������ ���� ��� ������� %d-�� ������",CarLevel);return SendClientMessage(playerid,COLOR_RED,String);}
				if (Player[playerid][Cash] < CarPrice && CarPrice > 0){ShowModelSelectionMenu(playerid, MenuClass3, "Car Class 3");format(String,sizeof(String),"������: ��� ����� ��� ������� %d$",CarPrice);return SendClientMessage(playerid,COLOR_RED,String);}
				Player[playerid][CarSlot3] = modelid;Player[playerid][Cash] -= CarPrice;
                Player[playerid][CarActive] = 0;
				modelid -= 400;format(String,sizeof(String),"��� ����� ���������� 3-�� ������ - %s",PlayerVehicleName[modelid]);SendClientMessage(playerid,COLOR_YELLOW,String);
				if (CarPrice > 0){format(String,sizeof(String),"�� ��������� �� ���� %d$",CarPrice);SendClientMessage(playerid,COLOR_YELLOW,String);}
				
			}
			else{ShowPlayerDialog(playerid, 3, 2, "������ ������� ����������", "����� 1\n����� 2\n����� 3\n{FFFF00}Prestige{FFFFFF}\n������", "��", "");}
    }//����� ���� ����� 3
    
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
			
				if (Player[playerid][Cash] < CarPrice && CarPrice > 0){ShowModelSelectionMenu(playerid, MenuPaintJob, "PaintJob Cars");format(String,sizeof(String),"������: ��� ����� ��� ������� %d$",CarPrice);return SendClientMessage(playerid,COLOR_RED,String);}
				Player[playerid][CarSlot2] = modelid;Player[playerid][Cash] -= CarPrice;ResetTuneClass2(playerid);
                Player[playerid][CarActive] = 0;
				modelid -= 400;format(String,sizeof(String),"��� ����� ���������� 2-�� ������ - %s",PlayerVehicleName[modelid]);SendClientMessage(playerid,COLOR_YELLOW,String);
				if (CarPrice > 0){format(String,sizeof(String),"�� ��������� �� ���� %d$",CarPrice);SendClientMessage(playerid,COLOR_YELLOW,String);}

				if(modelid == 83)
				{//���������
				    Player[playerid][CarSlot2PaintJob] = 0;
				}//���������
				else if (modelid == 134 || modelid == 136 || modelid == 167 || modelid == 175 || modelid == 176)
				{//lowrider
				    SendClientMessage(playerid, COLOR_YELLOW, "�� ���� ���������� ����� ���������� ����������� ������ � �������������� {FFFFFF}Lowrider");
				}//lowrider
				else
				{//Arch Angels
				    SendClientMessage(playerid, COLOR_YELLOW, "�� ���� ���������� ����� ���������� ����������� ������ � �������������� {FFFFFF}Arch Angels");
				}//Arch Angels
			}
			else{ShowPlayerDialog(playerid, 3, 2, "������ ������� ����������", "����� 1\n����� 2\n����� 3\n{FFFF00}Prestige{FFFFFF}\n������", "��", "");}
	}//PaintJob Cars

    if(listid == MenuBuyGun)
    {//��������� �������
		{//��������� �������
			if(response)
			{
			    if (InEvent[playerid] > 0) return SendClientMessage(playerid, COLOR_RED, "������: ������ �������� ������ � �������������");
                    if(modelid == 1240)
					{//�������
						if (HealthTime[playerid] > 0)
						{
							new str[120];format(str, sizeof(str), "{FF0000}������� ������� ������ �������� ����� {FFFFFF}%d{FF0000} ������.", HealthTime[playerid]);
							SendClientMessage(playerid,COLOR_RED,str);ShowModelSelectionMenu(playerid, MenuBuyGun, "Buy Gun");return 1;
						}
						if (Player[playerid][Cash] < 100 && Player[playerid][Karma] < 600){SendClientMessage(playerid,COLOR_RED,"��� ������� ������� ��� ����� 100$");return 1;}
	     				SetPlayerChatBubble(playerid, "�������� �������", COLOR_GREEN, 100.0, 3000);
						ShowModelSelectionMenu(playerid, MenuBuyGun, "Buy Gun");
						HealthTime[playerid] = 30; SetPlayerHealth(playerid, 100);
						if (Player[playerid][Karma] < 600) {Player[playerid][Cash] -= 100; SendClientMessage(playerid,COLOR_YELLOW,"�� ������ ������� �� 100$");}
						else SendClientMessage(playerid,COLOR_YELLOW,"�� �������� �������.");
						QuestUpdate(playerid, 30, 100);//���������� ������ ��������� 25� � /bg
					}//�������
					if(modelid == 1242)
					{//������� ����� �� 250$
					    if (Player[playerid][Karma] <= -600) return SendClientMessage(playerid, COLOR_RED, "�� �� ������ �������� ������� ����� ��-�� ������� ������ �����.");
						if (ArmourTime[playerid] > 0)
						{
							new str[120];format(str, sizeof(str), "{FF0000}������� ����� ������ �������� ����� {FFFFFF}%d{FF0000} ������.", ArmourTime[playerid]);
							SendClientMessage(playerid,COLOR_RED,str);ShowModelSelectionMenu(playerid, MenuBuyGun, "Buy Gun");return 1;
						}
						if (Player[playerid][Cash] < 250 && Player[playerid][Karma] < 600){SendClientMessage(playerid,COLOR_RED,"��� ������� ����� ��� ����� 250$");return 1;}
	     				SetPlayerChatBubble(playerid, "�������� �����", COLOR_GREEN, 100.0, 3000);
						ShowModelSelectionMenu(playerid, MenuBuyGun, "Buy Gun"); ArmourTime[playerid] = 60;
                        if (Player[playerid][Karma] < 600) {Player[playerid][Cash] -= 250; SendClientMessage(playerid,COLOR_YELLOW,"�� ������ ����� �� 250$");}
						else SendClientMessage(playerid,COLOR_YELLOW,"�� �������� �����.");
						QuestUpdate(playerid, 30, 250);//���������� ������ ��������� 25� � /bg
					}//������� ����� �� 250$
					if(modelid == 347)
					{//9�� �������� 100$
						if (Player[playerid][Cash] < 100){SendClientMessage(playerid,COLOR_RED,"��� ������� ��������� � ���������� ��� ����� 100$");return 1;}
						Player[playerid][Cash] -= 100;GivePlayerWeapon(playerid,23,70);SetPlayerChatBubble(playerid, "�������� �������� � ����������", COLOR_GREEN, 100.0, 3000);
	 					ShowModelSelectionMenu(playerid, MenuBuyGun, "Buy Gun");
	 					SendClientMessage(playerid,COLOR_YELLOW,"�� ������ 9�� �������� � ���������� �� 100$");
	 					QuestUpdate(playerid, 30, 100);//���������� ������ ��������� 25� � /bg
					}//9�� �������� 100$
					if(modelid == 346)
					{//9��  200$
						if (Player[playerid][Cash] < 200){SendClientMessage(playerid,COLOR_RED,"��� ������� 9�� ��������� ��� ����� 200$");return 1;}
						Player[playerid][Cash] -= 200;GivePlayerWeapon(playerid,22,70);SetPlayerChatBubble(playerid, "�������� 9�� ��������", COLOR_GREEN, 100.0, 3000);
	 					ShowModelSelectionMenu(playerid, MenuBuyGun, "Buy Gun");
	 					SendClientMessage(playerid,COLOR_YELLOW,"�� ������ 9�� �������� �� 200$");
	 					QuestUpdate(playerid, 30, 200);//���������� ������ ��������� 25� � /bg
					}//9�� 200$
					if(modelid == 348)
					{//����  500$
						if (Player[playerid][Cash] < 500){SendClientMessage(playerid,COLOR_RED,"��� ������� Desert Eagle ��� ����� 500$");return 1;}
						Player[playerid][Cash] -= 500;GivePlayerWeapon(playerid,24,70);SetPlayerChatBubble(playerid, "�������� Desert Eagle", COLOR_GREEN, 100.0, 3000);
	 					ShowModelSelectionMenu(playerid, MenuBuyGun, "Buy Gun");
	 					SendClientMessage(playerid,COLOR_YELLOW,"�� ������ Desert Eagle �� 500$");
	 					QuestUpdate(playerid, 30, 500);//���������� ������ ��������� 25� � /bg
					}//���� 500$
					if(modelid == 349)
					{//��������  250$
						if (Player[playerid][Cash] < 250){SendClientMessage(playerid,COLOR_RED,"��� ������� ��������� ��� ����� 250$");return 1;}
						Player[playerid][Cash] -= 250;GivePlayerWeapon(playerid,25,28);SetPlayerChatBubble(playerid, "�������� ��������", COLOR_GREEN, 100.0, 3000);
	 					ShowModelSelectionMenu(playerid, MenuBuyGun, "Buy Gun");
	 					SendClientMessage(playerid,COLOR_YELLOW,"�� ������ �������� �� 250$");
	 					QuestUpdate(playerid, 30, 250);//���������� ������ ��������� 25� � /bg
					}//�������� 250$
					if(modelid == 350)
					{//�����
						if (Player[playerid][Cash] < 800){SendClientMessage(playerid,COLOR_RED,"��� ������� ������� ��� ����� 800$");return 1;}
						Player[playerid][Cash] -= 800;GivePlayerWeapon(playerid,26,48);SetPlayerChatBubble(playerid, "�������� �����", COLOR_GREEN, 100.0, 3000);
	 					ShowModelSelectionMenu(playerid, MenuBuyGun, "Buy Gun");
	 					SendClientMessage(playerid,COLOR_YELLOW,"�� ������ ����� �� 800$");
	 					QuestUpdate(playerid, 30, 800);//���������� ������ ��������� 25� � /bg
					}//�����
					if(modelid == 351)
					{//����
						if (Player[playerid][Cash] < 1200){SendClientMessage(playerid,COLOR_RED,"��� ������� SPAS12 ��� ����� 1200$");return 1;}
						Player[playerid][Cash] -= 1200;GivePlayerWeapon(playerid,27,48);SetPlayerChatBubble(playerid, "�������� SPAS12", COLOR_GREEN, 100.0, 3000);
	  					ShowModelSelectionMenu(playerid, MenuBuyGun, "Buy Gun");
	  					SendClientMessage(playerid,COLOR_YELLOW,"�� ������ SPAS12 �� 1200$");
	  					QuestUpdate(playerid, 30, 1200);//���������� ������ ��������� 25� � /bg
					}//����
					if(modelid == 353)
					{//MP5
					   	if (Player[playerid][Cash] < 500){SendClientMessage(playerid,COLOR_RED,"��� ������� MP5 ��� ����� 500$");return 1;}
						Player[playerid][Cash] -= 500;GivePlayerWeapon(playerid,29,500);SetPlayerChatBubble(playerid, "�������� MP5", COLOR_GREEN, 100.0, 3000);
	 					ShowModelSelectionMenu(playerid, MenuBuyGun, "Buy Gun");
	 					SendClientMessage(playerid,COLOR_YELLOW,"�� ������ MP5 �� 500$");
	 					QuestUpdate(playerid, 30, 500);//���������� ������ ��������� 25� � /bg
					}//MP5
					if(modelid == 372)
					{//Tec9
					   	if (Player[playerid][Cash] < 650){SendClientMessage(playerid,COLOR_RED,"��� ������� Tec9 ��� ����� 650$");return 1;}
						Player[playerid][Cash] -= 650;GivePlayerWeapon(playerid,32,500);SetPlayerChatBubble(playerid, "�������� Tec9", COLOR_GREEN, 100.0, 3000);
	 					ShowModelSelectionMenu(playerid, MenuBuyGun, "Buy Gun");
	 					SendClientMessage(playerid,COLOR_YELLOW,"�� ������ Tec9 �� 650$");
	 					QuestUpdate(playerid, 30, 650);//���������� ������ ��������� 25� � /bg
					}//Tec9
					if(modelid == 352)
					{//UZI
					    if (Player[playerid][Cash] < 650){SendClientMessage(playerid,COLOR_RED,"��� ������� MiniUZI ��� ����� 650$");return 1;}
						Player[playerid][Cash] -= 650;GivePlayerWeapon(playerid,28,500);SetPlayerChatBubble(playerid, "�������� MiniUZI", COLOR_GREEN, 100.0, 3000);
						ShowModelSelectionMenu(playerid, MenuBuyGun, "Buy Gun");
						SendClientMessage(playerid,COLOR_YELLOW,"�� ������ MicroUZI �� 650$");
						QuestUpdate(playerid, 30, 650);//���������� ������ ��������� 25� � /bg
					}//UZI
					if(modelid == 355)
					{//AK
						if (Player[playerid][Cash] < 800){SendClientMessage(playerid,COLOR_RED,"��� ������� AK-47 ��� ����� 800$");return 1;}
						Player[playerid][Cash] -= 800;GivePlayerWeapon(playerid,30,90);SetPlayerChatBubble(playerid, "�������� AK-47", COLOR_GREEN, 100.0, 3000);
						ShowModelSelectionMenu(playerid, MenuBuyGun, "Buy Gun");
						SendClientMessage(playerid,COLOR_YELLOW,"�� ������ AK-47 �� 800$");
						QuestUpdate(playerid, 30, 800);//���������� ������ ��������� 25� � /bg
					}//AK
					if(modelid == 356)
					{//m4
					    if (Player[playerid][Cash] < 800){SendClientMessage(playerid,COLOR_RED,"��� ������� M4 ��� ����� 800$");return 1;}
						Player[playerid][Cash] -= 800;GivePlayerWeapon(playerid,31,90);SetPlayerChatBubble(playerid, "�������� M4", COLOR_GREEN, 100.0, 3000);
						ShowModelSelectionMenu(playerid, MenuBuyGun, "Buy Gun");
						SendClientMessage(playerid,COLOR_YELLOW,"�� ������ M4 �� 800$");
						QuestUpdate(playerid, 30, 800);//���������� ������ ��������� 25� � /bg
					}//m4
					if(modelid == 1310)
					{//�������
					    if (Player[playerid][Cash] < 200){SendClientMessage(playerid,COLOR_RED,"��� ������� �������� ��� ����� 200$");return 1;}
						Player[playerid][Cash] -= 200;GivePlayerWeapon(playerid,46,1);SetPlayerChatBubble(playerid, "�������� �������", COLOR_GREEN, 100.0, 3000);
						ShowModelSelectionMenu(playerid, MenuBuyGun, "Buy Gun");
						SendClientMessage(playerid,COLOR_YELLOW,"�� ������ ������� �� 200$");
						QuestUpdate(playerid, 30, 200);//���������� ������ ��������� 25� � /bg
					}//�������

				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER || GetPlayerState(playerid) == PLAYER_STATE_PASSENGER)
				{//������ ��������� ������������ ������ ���, �������� � ����������
				    new Weap[2];
				    GetPlayerWeaponData(playerid, 4, Weap[0], Weap[1]); // Get the players SMG weapon in slot 4
				    SetPlayerArmedWeapon(playerid, Weap[0]); // Set the player to driveby with SMG
				}//������ ��������� ������������ ������ ���, �������� � ����������
			}
		}//�������
    }//��������� �������

    if(listid == MenuPrestigeCars)
    {//���������� ����
        if(response)
		{
		    SelectedModel[playerid] = modelid;
		    ShowPlayerDialog(playerid, DIALOG_PRESTIGECAR, 2, "����� ������ ��� ������� ����", "����� 1\n����� 2\n{FFFF00}����� ������ ������", "��", "������");
		}
		else ShowPlayerDialog(playerid, 3, 2, "������ ������� ����������", "����� 1\n����� 2\n����� 3\n{FFFF00}Prestige{FFFFFF}\n������", "��", "");
    }//���������� ����
    
    return 1;
}//����



public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if (Logged[playerid] == 0 && dialogid != DIALOG_LOGIN && dialogid != DIALOG_REGISTER) return Kick(playerid);//�� ����������� ������� ������� �� ��������

	new string[MAX_DIALOG_INFO];
	switch(dialogid)
	{
	case DIALOG_LOGIN:
		{
		    for (new i; i < strlen(inputtext); i++)
			{
		   		if (inputtext[i] == '=')
		   		{//� ������ ���� ������ =
		   		    format(string, sizeof(string), "{FFFFFF}����� ���������� �� {00BFFF}%s{FFFFFF}\n��� ������� ���������������\n\n�����: {008000}%s\n{FFFFFF}������� ������:", SERVER_NAME, GetName(playerid));
					return ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT, "{FFD700}�����������", string, "�����", "������");
		   		}//� ������ ���� ������ =
		   	}
			if(response)
			{
				if(strlen(inputtext) < 3)
				{
					format(string, sizeof(string), "{FFFFFF}����� ���������� �� {00BFFF}%s{FFFFFF}\n��� ������� ���������������\n\n�����: {008000}%s\n{FFFFFF}������� ������:", SERVER_NAME, GetName(playerid));
					ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT, "{FFD700}�����������", string, "�����", "������");
					return 1;
				}
				
				else if(strcmp(PlayerPass[playerid], inputtext, true))
				{
					Errors[playerid]--;
					if(Errors[playerid] < 1)
					{
						SendClientMessage(playerid,0xFF8800FF,"-------------------------------------------------");
						SendClientMessage(playerid,0xFF8800FF,"����� �������� ������!");
						SendClientMessage(playerid,0xFF8800FF,"���������� ���������...");
						SendClientMessage(playerid,0xFF8800FF,"-------------------------------------------------");
						GKick(playerid);
						return 1;
					}
					format(string, sizeof(string), "{FFFFFF}����� ���������� �� {00BFFF}%s{FFFFFF}\n��� ������� ���������������\n\n�����: {008000}%s\n{FFFFFF}������� ������:\n\n{FF0000}������ �������� ������! �������� �������: {FFFFFF}%i", SERVER_NAME, GetName(playerid), Errors[playerid]);
					ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT, "{FFD700}�����������", string, "�����", "������");
					return 1;
				}
				Logged[playerid] = 1;
				
				new name[24];GetPlayerName(playerid, name, sizeof(name));new ChatMes[140];
               	foreach(Player, gid)
				{//����
					if (Logged[gid] == 1 && Player[gid][Admin] > 0)
					{//���� ����� � ����
					    format(ChatMes, sizeof(ChatMes), "SERVER: %s[%d] ����� � ���� [IP-�����:{FFFFFF} %s{AFAFAF}].", name,playerid, PlayerIP[playerid]);
					}//���� ����� � ����
					else{format(ChatMes, sizeof(ChatMes), "SERVER: %s[%d] ����� � ����.", name,playerid);}
					if (Player[gid][ConMesEnterExit] == 1) SendClientMessage(gid, COLOR_GREY, ChatMes);
				}//����
				//������ � ���. �������� WriteLog("����", "������ ���!"); ������� � ��� "����.ini" ����� "������ ���!"
    			format(ChatMes, sizeof ChatMes, "%d.%d.%d � %d:%d:%d |   %s[%d] ����� � ���� [IP-�����: %s].", Day, Month, Year, hour, minute, second, name, playerid, PlayerIP[playerid]);
				WriteLog("GlobalLog", ChatMes);


				SetPlayerVirtualWorld(playerid,0);LSpawnPlayer(playerid);
				TextDrawShowForPlayer(playerid, TextDrawTime), TextDrawShowForPlayer(playerid, TextDrawDate);//���� � �����
				SetTimerEx("SpeedoUpdate" , 500, false, "i", playerid);
				OnPlayerLogin(playerid); LoginKickTime[playerid] = 0;
				if (Player[playerid][Level] == 0) TutorialStep[playerid] = 1;//���������� �������� ���� 0 ���
				return 1;
			}
			else{ShowPlayerDialog(playerid,999,0,"���������� ���������","{FF0000}�� ���� ������� � �������, �� ������� ������ ������� �����������", "��", "");Kick(playerid);}
		}
	case DIALOG_REGISTER:
		{
			if(!response){ShowPlayerDialog(playerid,999,0,"���������� ���������","{FF0000}�� ���� ������� � �������, �� ������� ������ ������� �����������", "��", "");Kick(playerid);}
			if(!strlen(inputtext) || strlen(inputtext) < 6 || strlen(inputtext) > 24)
			{
				format(string, sizeof(string), "{FFFFFF}����� ���������� �� {00BFFF}%s{FFFFFF}\n��� ���� ��� ����� ������������������\n\n������� ������ ��� ������ ��������\n�� ����� ������������� ��� ������ ������ �� ������\n\n     {008000}����������:\n     - ������ ������ ���� ������� (������: s9cQ17)\n     {FF0000}- ����� ������ ������ ���� �� 6 �� 24 ��������\n     {FF0000}- ��������� ������������ '=' � ������\n\n{FFFFFF}������� ������:", SERVER_NAME);
				ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "{FFD700}�����������", string, "������", "������");return 1;
			}
			for (new i; i < strlen(inputtext); i++)
			{
	   			if (inputtext[i] == '=')
	   			{//� ������ ���� ������ =
	   			    format(string, sizeof(string), "{FFFFFF}����� ���������� �� {00BFFF}%s{FFFFFF}\n��� ���� ��� ����� ������������������\n\n������� ������ ��� ������ ��������\n�� ����� ������������� ��� ������ ������ �� ������\n\n     {008000}����������:\n     - ������ ������ ���� ������� (������: s9cQ17)\n     {FF0000}- ����� ������ ������ ���� �� 6 �� 24 ��������\n     {FF0000}- ��������� ������������ '=' � ������\n\n{FFFFFF}������� ������:", SERVER_NAME);
					ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "{FFD700}�����������", string, "������", "������");return 1;
	   			}//� ������ ���� ������ =
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
				{//���� ����� ���� ������ 0 (����������� ���� �������� ����������� ������ �����)
	               	foreach(Player, gid)
					{//����
						if (Logged[gid] == 1 && Player[gid][Admin] > 0)
						{//���� ����� � ����
						    format(ChatMes, sizeof(ChatMes), "SERVER: %s[%d] ����������������� [IP-�����:{FFFFFF} %s{AFAFAF}].", name,playerid, PlayerIP[playerid]);
						}//���� ����� � ����
						else{format(ChatMes, sizeof(ChatMes), "SERVER: %s[%d] �����������������.", name,playerid);}
						SendClientMessage(gid, COLOR_GREY, ChatMes);

					}//����
					//������ � ���. �������� WriteLog("����", "������ ���!"); ������� � ��� "����.ini" ����� "������ ���!"
					format(ChatMes, sizeof ChatMes, "%d.%d.%d � %d:%d:%d |   %s[%d] ����������������� [IP-�����: %s].", Day, Month, Year, hour, minute, second, name, playerid, PlayerIP[playerid]);WriteLog("GlobalLog", ChatMes);
				}//���� ����� ���� ������ 0 (����������� ���� �������� ����������� ������ �����)
			}
			Registered[playerid] = 1;Logged[playerid] = 1;
			TutorialStep[playerid] = 1;LogidDialogShowed[playerid] =1;XReg[playerid] = 1;
			PlayerWeather[playerid] = -1; PlayerTime[playerid] = -1;//��������� ������ � ����� ����� �����������
 			TextDrawShowForPlayer(playerid, TextDrawTime), TextDrawShowForPlayer(playerid, TextDrawDate);//���� � �����
			new NoobSkins[] = {134,135,137, 212, 230, 239};
			new rand = random(sizeof NoobSkins); Player[playerid][Model] = NoobSkins[rand];
			Player[playerid][CarSlot1] = 462;//Faggio ��-���������
			Player[playerid][CarSlot1Color1] = random(200);
			Player[playerid][Cash] = 500;  LoginKickTime[playerid] = 0;
			TutorialStep[playerid] = 1;//������ ��������
            new String[1024]; LSpawnPlayer(playerid); StopAudioStreamForPlayer(playerid);
			strcat(String, "{007FFF}��������: ����� ����������{FFFFFF}\n\n");
			strcat(String, "������� ������ �� ������� � ������ ������ �������� ���� ������ ����������. ���������� ��� �����.\n");
			strcat(String, "��� ����, ����� ����� �� ����, ������� ������� {00FF00}Alt{FFFFFF} � �������� <<{FFFF00}����� � ������ [����� 1]{FFFFFF}>>");
			return ShowPlayerDialog(playerid, DIALOG_TUTORIAL, 0, "��������", String, "��, ������", "");
		}

		///////////////

	case 2:
		{//������� ������
			if(response)
			{
				if(listitem == 0 && GetPlayerState(playerid) == 1)
				{//Slot 1
				    CallCar1(playerid);//����� ���� ������ 1
				    if (Player[playerid][Level] == 0)
				    {//�������� ��������
				        if (TutorialStep[playerid] == 1)
				        {//��������: ����� ������
					        new String[1024];
					        TutorialStep[playerid] = 2;
							strcat(String, "{007FFF}��������: ����� ������� ����������{FFFFFF}\n\n");
							strcat(String, "��� ����� - ��������� ������� ������, �� � ������� ������ ����� ���� ����� ��� ����������: \n");
							strcat(String, "�� ������ �� ������ �����. ������ ���� ������� ��� ������ ���������� ������� ������!");
	 						strcat(String, "\n\n{FFFF00}������� �� � �������� ����������..");
							ShowPlayerDialog(playerid, DIALOG_TUTORIAL, 0, "��������", String, "��", "");
							DestroyObject(TutorialObject[playerid]);TutorialObject[playerid] = -1;
						}//��������: ����� ������
						if (TutorialStep[playerid] == 3)
						{//��������: �������������
						    if (TutorialObject[playerid] != -1){DestroyObject(TutorialObject[playerid]);TutorialObject[playerid] = -1;}
						    TutorialObject[playerid] = CreateObject(19482, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
							SetObjectMaterialText(TutorialObject[playerid], "{FFFF00}��������\n{FFFFFF}������� {00FF00}Y{FFFFFF}/{00FF00}N", 0, OBJECT_MATERIAL_SIZE_512x512, "Tahoma", 50, 1, 0xFFFFFFFF, 0x00, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
			                AttachObjectToPlayer(TutorialObject[playerid], playerid, 0, 0, 1.2, 0, 0, 270);
						}//��������: �������������
				    }//�������� ��������
				}//Slot 1
				if(listitem == 1 && GetPlayerState(playerid) == 1)
				{//Slot 2
				    CallCar2(playerid);//����� ���� ������ 2
				}//Slot 2
				if(listitem == 2 && GetPlayerState(playerid) == 1)
				{//Slot 3
				    CallCar3(playerid);//����� ���� ������ 3
				}//Slot 3
				if(listitem == 3) SendCommand(playerid, "/jetpack", ""); //Jetpack
				if(listitem == 4) SendCommand(playerid, "/skydive", ""); //�������
				if(listitem == 5) SendCommand(playerid, "/gps", ""); //GPS
				if(listitem == 6)
				{//�������� �����
					ShowPlayerDialog(playerid, 3, 2, "������ ������� ����������", "����� 1\n����� 2\n����� 3\n{FFFF00}Prestige{FFFFFF}\n������", "��", "");
				}//�������� �����
				if(listitem == 7)
				{//�������� ������
				    new StringF[600];
				    switch (Player[playerid][ActiveSkillPerson])
				    {//����� ���������
				        case 1: strcat(StringF,"������� {008D00}N{FFFFFF} (������): {007FFF}�������� �� 50 ������\n");
				        case 2: strcat(StringF,"������� {008D00}N{FFFFFF} (������): {007FFF}�������� �� 100 ������\n");
				        case 3: strcat(StringF,"������� {008D00}N{FFFFFF} (������): {007FFF}�������� �� 200 ������\n");
				        case 4: strcat(StringF,"������� {008D00}N{FFFFFF} (������): {007FFF}����� ���������\n");
				        default: strcat(StringF,"������� {008D00}N{FFFFFF} (������): {AFAFAF}���\n");
				    }//����� ���������
				    
				    switch (Player[playerid][ActiveSkillCar1])
				    {//����� 1: ������� 2
				        case 1: strcat(StringF,"������� {008D00}2{FFFFFF} (����� 1): {007FFF}�������� �� 180 ��������\n");
				        case 2: strcat(StringF,"������� {008D00}2{FFFFFF} (����� 1): {007FFF}������\n");
				        case 3: strcat(StringF,"������� {008D00}2{FFFFFF} (����� 1): {007FFF}��������\n");
				        default: strcat(StringF,"������� {008D00}2{FFFFFF} (����� 1): {AFAFAF}���\n");
				    }//����� 1: ������� 2
				    
				    switch (Player[playerid][ActiveSkillCar2])
				    {//����� 2: ������� 2
				        case 1: strcat(StringF,"������� {008D00}2{FFFFFF} (����� 2): {007FFF}�������� �� 180 ��������\n");
				        case 2: strcat(StringF,"������� {008D00}2{FFFFFF} (����� 2): {007FFF}������\n");
				        case 3: strcat(StringF,"������� {008D00}2{FFFFFF} (����� 2): {007FFF}��������\n");
				        default: strcat(StringF,"������� {008D00}2{FFFFFF} (����� 2): {AFAFAF}���\n");
				    }//����� 2: ������� 2
				    
				    switch (Player[playerid][ActiveSkillHCar1])
				    {//����� 1: ������� �����
				        case 1: strcat(StringF,"������� {008D00}H{FFFFFF} (����� 1): {007FFF}��������� ���������� �� ������\n");
				        case 2: strcat(StringF,"������� {008D00}H{FFFFFF} (����� 1): {007FFF}�������� �� 50 ������\n");
				        case 3: strcat(StringF,"������� {008D00}H{FFFFFF} (����� 1): {007FFF}�������� �� 100 ������\n");
				        case 4: strcat(StringF,"������� {008D00}H{FFFFFF} (����� 1): {007FFF}�������� �� 200 ������\n");
				        case 5: strcat(StringF,"������� {008D00}H{FFFFFF} (����� 1): {007FFF}�������� �� 50 ������ �� ���������\n");
				        case 6: strcat(StringF,"������� {008D00}H{FFFFFF} (����� 1): {007FFF}�������� �� 100 ������ �� ���������\n");
				        case 7: strcat(StringF,"������� {008D00}H{FFFFFF} (����� 1): {007FFF}�������� �� 200 ������ �� ���������\n");
				        case 8: strcat(StringF,"������� {008D00}H{FFFFFF} (����� 1): {007FFF}����� ������\n");
				        default: strcat(StringF,"������� {008D00}H{FFFFFF} (����� 1): {AFAFAF}���\n");
				    }//����� 1: ������� �����
				    
				    switch (Player[playerid][ActiveSkillHCar2])
				    {//����� 2: ������� �����
				        case 1: strcat(StringF,"������� {008D00}H{FFFFFF} (����� 2): {007FFF}��������� ���������� �� ������\n");
				        case 2: strcat(StringF,"������� {008D00}H{FFFFFF} (����� 2): {007FFF}�������� �� 50 ������\n");
				        case 3: strcat(StringF,"������� {008D00}H{FFFFFF} (����� 2): {007FFF}�������� �� 100 ������\n");
				        case 4: strcat(StringF,"������� {008D00}H{FFFFFF} (����� 2): {007FFF}�������� �� 200 ������\n");
				        case 5: strcat(StringF,"������� {008D00}H{FFFFFF} (����� 2): {007FFF}�������� �� 50 ������ �� ���������\n");
				        case 6: strcat(StringF,"������� {008D00}H{FFFFFF} (����� 2): {007FFF}�������� �� 100 ������ �� ���������\n");
				        case 7: strcat(StringF,"������� {008D00}H{FFFFFF} (����� 2): {007FFF}�������� �� 200 ������ �� ���������\n");
				        case 8: strcat(StringF,"������� {008D00}H{FFFFFF} (����� 2): {007FFF}����� ������\n");
				        default: strcat(StringF,"������� {008D00}H{FFFFFF} (����� 2): {AFAFAF}���\n");
				    }//����� 1: ������� �����
				    strcat(StringF, "{FF0000}��������� ������");
				    ShowPlayerDialog(playerid, DIALOG_SKILLCHANGE, 2, "�������� ��� ������", StringF, "��", "������");
				}//�������� ������
				if(listitem == 8)
				{//��������� PvP
				    if (PlayerPVP[playerid][Status] > 0) return SendClientMessage(playerid,COLOR_RED,"������: ������ �������� ��������� �� ����� �����.");
					if (PlayerPVP[playerid][TimeOut] > 0) return SendClientMessage(playerid,COLOR_RED,"������: ������ �������� ��������� ����� ��/��� ������� �� �����.");
					new String[300], zWeapon[48], zMap[30];
					GetWeaponName(PlayerPVP[playerid][Weapon],zWeapon,sizeof(zWeapon));
				    if (PlayerPVP[playerid][Weapon] == 0) zWeapon = "��� ������";
				    if (PlayerPVP[playerid][Map] == 1) zMap = "�����";
					if (PlayerPVP[playerid][Map] == 2) zMap = "��� ������";
					if (PlayerPVP[playerid][Map] == 3) zMap = "��� ������";
					if (PlayerPVP[playerid][Map] == 4) zMap = "������";
					if (PlayerPVP[playerid][Map] == 5) zMap = "�����";
					if (PlayerPVP[playerid][Map] == 6) zMap = "����������� ��������";
					if (PlayerPVP[playerid][Map] == 7) zMap = "��� �����";
					if (PlayerPVP[playerid][Map] == 8) zMap = "�����";
					if (PlayerPVP[playerid][Map] == 9) zMap = "�������� �������";
					if (PlayerPVP[playerid][Map] == 10) zMap = "��������";
				    format(String,sizeof(String),"{457EFF}��������� ���������\n{FFFF00}�����:{FFFFFF} %s\n{FFFF00}������:{FFFFFF} %s\n{FFFF00}��������:{FFFFFF} %d",zMap,zWeapon, PlayerPVP[playerid][Health]);
					ShowPlayerDialog(playerid, DIALOG_PVP, 2, "��������� PvP", String, "��", "�����");
				}//��������� PvP
				if(listitem == 9)
				{//������� ���
					ShowPlayerDialog(playerid, 8, 2, "���", "���������� (/stats)\n��������� ������������ (/events)\n��������� ������� (/quests)\n��������� ������� (/buygun)\n������ ������ (/mygun)\n����� ����� (/style)\n��������� �������� (/myspawn)\n����� (/radio)\n����������� (/invisible)\n{007FFF}����{FFFFFF}\n{FFCC00}GameGold �������\n{FF0000}��������� ��������{FFFFFF}\n���������� � ����� (/karma)\n������ �� ���� (/help)", "��", "�����");
				}//������� ���
				
			}
		}//������� ������





	case 3:
		{//������ ����������
			if(response)
			{
				if(listitem == 0) ShowModelSelectionMenu(playerid, MenuClass1, "Car Class 1");
				if(listitem == 1) ShowModelSelectionMenu(playerid, MenuClass2, "Car Class 2");
				if(listitem == 2) ShowModelSelectionMenu(playerid, MenuClass3, "Car Class 3");
				if(listitem == 3)
				{//Prestige-list
				    if (Player[playerid][Prestige] == 0){SendClientMessage(playerid,COLOR_RED,"������: � ��� ������ ���� ��� ������� 1-�� ������� ��������");return 1;}
				    if (Player[playerid][Level] < 85){SendClientMessage(playerid,COLOR_RED,"������: �� ������ ���� ��� ������� 85-�� ������");return 1;}
				    if (Player[playerid][CarActive] > 0){SendClientMessage(playerid,COLOR_RED,"������: �� ������ ����� �� ����");return 1;}
				    ShowModelSelectionMenu(playerid, MenuPrestigeCars, "Prestige Cars");
				}//Prestige-list
				
			}
		}//������ ����������



	case 8:
		{//���
			if(response)
			{
				if(listitem == 0) SendCommand(playerid, "/stats", ""); //����������
				if(listitem == 1) SendCommand(playerid, "/events", ""); //������������
				if(listitem == 2) SendCommand(playerid, "/quests", ""); //�������
				if(listitem == 3) SendCommand(playerid, "/buygun", ""); //����. �����
				if(listitem == 4) SendCommand(playerid, "/mygun", ""); //������ ������
				if(listitem == 5) SendCommand(playerid, "/style", ""); //����� �����
				if(listitem == 6) SendCommand(playerid, "/myspawn", ""); //��������� ��������
				if(listitem == 7) SendCommand(playerid, "/radio", ""); //�����
  				if(listitem == 8) SendCommand(playerid, "/invisible", ""); //�����������
				if(listitem == 9) SendCommand(playerid, "/clan", ""); //����
				if(listitem == 10) SendCommand(playerid, "/shop", ""); //������� shop
				if(listitem == 11) SendCommand(playerid, "/config", ""); //������
				if(listitem == 12) SendCommand(playerid, "/karma", ""); //���� � �����
				if(listitem == 13) SendCommand(playerid, "/help", ""); //������
			}
			else{ShowPlayerDialog(playerid, 2, 2, "���� �������� �������", "����� � ������ [����� 1]\n����� � ������ [����� 2]\n����� � ������ [����� 3]\n������ JetPack (/jetpack)\n�������� � ��������� (/skydive)\n{FF0000}GPS (/gps){FFFFFF}\n�������� ��� ����������\n�������� ��� ������\n��������� PvP\n{FFFF00}������� ���", "��", "�����");}
			return 1;
		}//���



	case 9:
		{//�����
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
				if(listitem == 9){PlayAudioStreamForPlayer(playerid, "http://radio.zaycev.fm:9002/ZaycevFM(128).m3u");}//������.fm Pop
				if(listitem == 10){PlayAudioStreamForPlayer(playerid, "http://radio.zaycev.fm:9002/alternative/ZaycevFM(128).m3u");}//������.fm NewRock
				if(listitem == 11){PlayAudioStreamForPlayer(playerid, "http://radio.zaycev.fm:9002/electronic/ZaycevFM(128).m3u");}//������.fm Club
				if(listitem == 12){PlayAudioStreamForPlayer(playerid, "http://radio.zaycev.fm:9002/disco/ZaycevFM(128).m3u");}//������.fm Disco
				if(listitem == 13){PlayAudioStreamForPlayer(playerid, "http://radio.zaycev.fm:9002/rnb/ZaycevFM(128).m3u");}//������.fm RnB
			}
			return 1;
		}//�����



	case DIALOG_MYSPAWN:
		{//����� ������
			if (response)
			{//�������
				if (listitem == 0)
				{//����������� ����� ������
					Player[playerid][Spawn] = 0;
					SendClientMessage(playerid,COLOR_YELLOW,"����� ������ �������� �������� �� {FFFFFF}����������� ����� ������");
				}//����������� ����� ������
				if (listitem == 1)
				{//������ ��� (�������)
					if (Player[playerid][Home] == 0){SendClientMessage(playerid,COLOR_RED,"������: � ��� ��� ����.");return 0;}
					Player[playerid][Spawn] = 4;
					SendClientMessage(playerid,COLOR_YELLOW,"����� ������ �������� �������� �� {FFFFFF}������ ��� (�������)");
				}//������ ��� (�������)
				if (listitem == 2)
				{//������ ��� (������)
				    if (Player[playerid][Home] == 0){SendClientMessage(playerid,COLOR_RED,"������: � ��� ��� ����.");return 0;}
					Player[playerid][Spawn] = 6; Player[playerid][SpawnStyle] = 0;
					SendClientMessage(playerid,COLOR_YELLOW,"����� ������ �������� �������� �� {FFFFFF}������ ��� (������)");
                    return 1;//����� �� ���� ������ ����� ������
				}//������ ��� (������)
				if (listitem == 3)
				{//���� ����� (�������)
				    if (Player[playerid][MyClan] == 0) return SendClientMessage(playerid,COLOR_RED,"������: �� �� � �����");
					new clanid = Player[playerid][MyClan];
					if(Clan[clanid][cBase] < 1 || Clan[clanid][cBase] > MAX_BASE) return SendClientMessage(playerid,COLOR_RED,"������: � ������ ����� ��� �����");
    				Player[playerid][Spawn] = 5;
					SendClientMessage(playerid,COLOR_YELLOW,"����� ������ �������� �������� �� {FFFFFF}���� ����� (�������)");
				}//���� ����� (�������)
				if (listitem == 4)
				{//���� ����� (������)
				    if (Player[playerid][MyClan] == 0) return SendClientMessage(playerid,COLOR_RED,"������: �� �� � �����");
					new clanid = Player[playerid][MyClan];
					if(Clan[clanid][cBase] < 1 || Clan[clanid][cBase] > MAX_BASE) return SendClientMessage(playerid,COLOR_RED,"������: � ������ ����� ��� �����");
    				Player[playerid][Spawn] = 8; Player[playerid][SpawnStyle] = 0;
					return SendClientMessage(playerid,COLOR_YELLOW,"����� ������ �������� �������� �� {FFFFFF}���� ����� (������)");
				}//���� ����� (������)
				if (listitem == 5)
				{//������� �������������� (ViP 4 lvl)
				    if (Player[playerid][GPremium] < 4) return SendClientMessage(playerid,COLOR_RED,"������: �� ������ ���� ��� ������� 4-�� ������ ViP");
				    if (Player[playerid][Home] == 0) return SendClientMessage(playerid,COLOR_RED,"������: � ��� ������ ���� ������ ���");
					if (LSpecID[playerid] != -1) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ����� �� ������ ������");
					if (GetPlayerInterior(playerid) != 0 || IsPlayerInRangeOfPoint(playerid, 13.0, 2311.6953,-7.4206,26.7422)) return SendClientMessage(playerid,COLOR_RED,"������: ������ ���������� VIP-����� � ����������");
				    GetPlayerPos(playerid,Player[playerid][PosX],Player[playerid][PosY],Player[playerid][PosZ]);GetPlayerFacingAngle(playerid,Player[playerid][PosA]);
				    Player[playerid][Spawn] = 7;SavePlayer(playerid);
				    SendClientMessage(playerid,COLOR_YELLOW,"����� ������ �������� �������� �� {FFFFFF}������ ������� (ViP)");
				}//������� �������������� (ViP 4 lvl)
				
				new StringX[1024];
				strcat(StringX, "{FFFFFF}({FFFF00}������� 0{FFFFFF})���\n{FFFFFF}({FFFF00}������� 10{FFFFFF})����� �� ���� ������ 1\n{FFFFFF}({FFFF00}������� 13{FFFFFF})����� �� ���� ������ 2\n{FFFFFF}({FFFF00}������� 38{FFFFFF})����� �� JetPack\n{FFFFFF}({FFFF00}������� 54{FFFFFF})����� �� ���� ������ 3");
				ShowPlayerDialog(playerid, DIALOG_MYSPAWN2, 2, "��������� �������� - �����", StringX, "��", "�����");
			}//�������
		}//����� ������

	case DIALOG_MYSPAWN2:
		{//����� ������
			if(response)
			{//�������
				if(listitem == 0)
				{//��� �����
					Player[playerid][SpawnStyle] = 0;
					SendClientMessage(playerid,COLOR_YELLOW,"����� ������ ��������: {FFFFFF}�������(��� �����)");
				}//��� �����
				if(listitem == 1)
				{//���� 1
					if (Player[playerid][Level] < 10){SendClientMessage(playerid,COLOR_RED,"������: �� ������ ���� ��� ������� {FFFFFF}10{FF0000}-�� ������, ����� ������� ���� ����� ��������");return 0;}
					Player[playerid][SpawnStyle] = 1;
					SendClientMessage(playerid,COLOR_YELLOW,"����� ������ ��������: {FFFFFF}�� ���� ������ 1");
				}//���� 1
				if(listitem == 2)
				{//���� 2
					if (Player[playerid][Level] < 13){SendClientMessage(playerid,COLOR_RED,"������: �� ������ ���� ��� ������� {FFFFFF}13{FF0000}-�� ������, ����� ������� ���� ����� ��������");return 0;}
					Player[playerid][SpawnStyle] = 2;
					SendClientMessage(playerid,COLOR_YELLOW,"����� ������ ��������: {FFFFFF}�� ���� ������ 2");
				}//���� 2
				if(listitem == 3)
				{//jetpack
				    if (Player[playerid][Level] < 38){SendClientMessage(playerid,COLOR_RED,"������: �� ������ ���� ��� ������� {FFFFFF}38{FF0000}-�� ������, ����� ������� ���� ����� ��������");return 0;}
					Player[playerid][SpawnStyle] = 5;
					SendClientMessage(playerid,COLOR_YELLOW,"����� ������ ��������: {FFFFFF}�� JetPack");
				}//jetpack
				if(listitem == 4)
				{//���� 3
					if (Player[playerid][Level] < 54){SendClientMessage(playerid,COLOR_RED,"������: �� ������ ���� ��� ������� {FFFFFF}54{FF0000}-�� ������, ����� ������� ���� ����� ��������");return 0;}
					Player[playerid][SpawnStyle] = 4;
					SendClientMessage(playerid,COLOR_YELLOW,"����� ������ ��������: {FFFFFF}�� ���� ������ 3");
				}//���� 3
			}//�������
			else {SendCommand(playerid, "/myspawn", "");}//���� ����� ���
		}//����� ������

	case DIALOG_MYGUN:
		{//������ ������
			if(response)
			{//�������
				if(listitem == 0)
				{//�������� ������ ��1
					if (Player[playerid][Level] < 8) return SendClientMessage(playerid,COLOR_RED,"�� ������ ���� ��� ������� {FFFFFF}8{FF0000}-�� ������, ����� �������� ������ �� ���� ���������");
					ShowPlayerDialog(playerid, DIALOG_MYGUN1, 2, "������ ������ - �������� ������", "���\n[{FFFF00}8{FFFFFF}]���������\n[{FFFF00}27{FFFFFF}]������", "��", "�����");
				}//�������� ������ ��1
				if(listitem == 1)
				{//��������� ��2
					if (Player[playerid][Level] < 16) return SendClientMessage(playerid,COLOR_RED,"�� ������ ���� ��� ������� {FFFFFF}16{FF0000}-�� ������, ����� �������� ������ �� ���� ���������");
					ShowPlayerDialog(playerid, DIALOG_MYGUN2, 2, "������ ������ - ���������", "���\n9�� ��������\n9�� �������� � ����������\nDesert Eagle", "��", "�����");
				}//��������� ��2
				if(listitem == 2)
				{//��������� ��3
					if (Player[playerid][Level] < 17) return SendClientMessage(playerid,COLOR_RED,"�� ������ ���� ��� ������� {FFFFFF}17{FF0000}-�� ������, ����� �������� ������ �� ���� ���������");
					ShowPlayerDialog(playerid, DIALOG_MYGUN3, 2, "������ ������ - ���������", "���\n��������\n�����\nSPAZ-12", "��", "�����");
				}//��������� ��3
				if(listitem == 3)
				{//�� ��4
					if (Player[playerid][Level] < 18) return SendClientMessage(playerid,COLOR_RED,"�� ������ ���� ��� ������� {FFFFFF}18{FF0000}-�� ������, ����� �������� ������ �� ���� ���������");
					ShowPlayerDialog(playerid, DIALOG_MYGUN4, 2, "������ ������ - ��������-��������", "���\nMP5\nUZI\nTec-9", "��", "�����");
				}//�� ��4
				if(listitem == 4)
				{//�������� ��5
					if (Player[playerid][Level] < 19) return SendClientMessage(playerid,COLOR_RED,"�� ������ ���� ��� ������� {FFFFFF}19{FF0000}-�� ������, ����� �������� ������ �� ���� ���������");
					ShowPlayerDialog(playerid, DIALOG_MYGUN5, 2, "������ ������ - ��������", "���\n��-47\n�4", "��", "�����");
				}//�������� ��5
				if(listitem == 5)
				{//����������� ��8
					if (Player[playerid][Level] < 23) return SendClientMessage(playerid,COLOR_RED,"�� ������ ���� ��� ������� {FFFFFF}23{FF0000}-�� ������, ����� �������� ������ �� ���� ���������");
					ShowPlayerDialog(playerid, DIALOG_MYGUN8, 2, "������ ������ - �����������", "���\n�������", "��", "�����");
				}//����������� ��8
				if(listitem == 6)
				{//�������� ��6
					if (Player[playerid][Level] < 34) return SendClientMessage(playerid,COLOR_RED,"�� ������ ���� ��� ������� {FFFFFF}34{FF0000}-�� ������, ����� �������� ������ �� ���� ���������");
					ShowPlayerDialog(playerid, DIALOG_MYGUN6, 2, "������ ������ - ��������", "���\n����������� �����\n����������� ��������", "��", "�����");
				}//�������� ��6
				if(listitem == 7)
				{//������� ������ ��7
					if (Player[playerid][Level] < 40) return SendClientMessage(playerid,COLOR_RED,"�� ������ ���� ��� ������� {FFFFFF}40{FF0000}-�� ������, ����� �������� ������ �� ���� ���������");
					ShowPlayerDialog(playerid, DIALOG_MYGUN7, 2, "������ ������ - ������� ������", "���\nRPG\n[{FFFF00}60{FFFFFF}]�������", "��", "�����");
				}//������� ������ ��7
				if(listitem == 8)
				{//������ ��10
					if (Player[playerid][Level] < 4) return SendClientMessage(playerid,COLOR_RED,"�� ������ ���� ��� ������� {FFFFFF}4{FF0000}-�� ������, ����� �������� ������ �� ���� ���������");
					ShowPlayerDialog(playerid, DIALOG_MYGUN10, 2, "������ ������ - ������", "���\n�������\n������������", "��", "�����");
				}//������ ��10
			}//�������
		}//������ ������

	case DIALOG_MYGUN1:
		{//�� - ��������
		    if(!response) return SendCommand(playerid, "/mygun", "");
			if(listitem == 0) {Player[playerid][Slot1] = 0; SendClientMessage(playerid, COLOR_YELLOW, "��������� ������� � ���� ����� ��������.");}
			if(listitem == 1) {Player[playerid][Slot1] = 9; SendClientMessage(playerid, COLOR_YELLOW, "��������� ������� � ���� ����� ��������.");}
			if(listitem == 2)
			{
				if (Player[playerid][Level] < 27) return SendClientMessage(playerid,COLOR_RED,"������: �� ������ ���� ��� ������� {FFFFFF}27{FF0000}-�� ������, ����� ������� ��� ������");
				Player[playerid][Slot1] = 8; SendClientMessage(playerid, COLOR_YELLOW, "��������� ������� � ���� ����� ��������.");
			}
			SendCommand(playerid, "/mygun", "");
		}//�� - ��������

	case DIALOG_MYGUN2:
		{//�� - ���������
		    if(!response) return SendCommand(playerid, "/mygun", "");
			if(listitem == 0) Player[playerid][Slot2] = 0;
			if(listitem == 1) Player[playerid][Slot2] = 22;
			if(listitem == 2) Player[playerid][Slot2] = 23;
			if(listitem == 3) Player[playerid][Slot2] = 24;
			SendClientMessage(playerid, COLOR_YELLOW, "��������� ������� � ���� ����� ��������.");
			SendCommand(playerid, "/mygun", "");
		}//�� - ���������

	case DIALOG_MYGUN3:
		{//�� - ���������
		    if(!response) return SendCommand(playerid, "/mygun", "");
			if(listitem == 0) Player[playerid][Slot3] = 0;
			if(listitem == 1) Player[playerid][Slot3] = 25;
			if(listitem == 2) Player[playerid][Slot3] = 26;
			if(listitem == 3) Player[playerid][Slot3] = 27;
			SendClientMessage(playerid, COLOR_YELLOW, "��������� ������� � ���� ����� ��������.");
			SendCommand(playerid, "/mygun", "");
		}//�� - ���������

	case DIALOG_MYGUN4:
		{//�� - ��
		    if(!response) return SendCommand(playerid, "/mygun", "");
			if(listitem == 0) Player[playerid][Slot4] = 0;
			if(listitem == 1) Player[playerid][Slot4] = 29;
			if(listitem == 2) Player[playerid][Slot4] = 28;
			if(listitem == 3) Player[playerid][Slot4] = 32;
			SendClientMessage(playerid, COLOR_YELLOW, "��������� ������� � ���� ����� ��������.");
			SendCommand(playerid, "/mygun", "");
		}//�� - ��

	case DIALOG_MYGUN5:
		{//�� - ��������
		    if(!response) return SendCommand(playerid, "/mygun", "");
			if(listitem == 0) Player[playerid][Slot5] = 0;
			if(listitem == 1) Player[playerid][Slot5] = 30;
			if(listitem == 2) Player[playerid][Slot5] = 31;
			SendClientMessage(playerid, COLOR_YELLOW, "��������� ������� � ���� ����� ��������.");
			SendCommand(playerid, "/mygun", "");
		}//�� - ��������

	case DIALOG_MYGUN8:
		{//�� - �����������
            if(!response) return SendCommand(playerid, "/mygun", "");
			if(listitem == 0) Player[playerid][Slot8] = 0;
			if(listitem == 1) Player[playerid][Slot8] = 16;
			SendClientMessage(playerid, COLOR_YELLOW, "��������� ������� � ���� ����� ��������.");
			SendCommand(playerid, "/mygun", "");
		}//�� - �����������

	case DIALOG_MYGUN6:
		{//�� - ��������
		    if(!response) return SendCommand(playerid, "/mygun", "");
			if(listitem == 0) Player[playerid][Slot6] = 0;
			if(listitem == 1) Player[playerid][Slot6] = 33;
			if(listitem == 2) Player[playerid][Slot6] = 34;
			SendClientMessage(playerid, COLOR_YELLOW, "��������� ������� � ���� ����� ��������.");
			SendCommand(playerid, "/mygun", "");
		}//�� - ��������

	case DIALOG_MYGUN7:
		{//�� - ������� ������
		    if(!response) return SendCommand(playerid, "/mygun", "");
			if(listitem == 0) {Player[playerid][Slot7] = 0; SendClientMessage(playerid, COLOR_YELLOW, "��������� ������� � ���� ����� ��������.");}
			if(listitem == 1) {Player[playerid][Slot7] = 35; SendClientMessage(playerid, COLOR_YELLOW, "��������� ������� � ���� ����� ��������.");}
			if(listitem == 2)
			{
				if (Player[playerid][Level] < 60) return SendClientMessage(playerid,COLOR_RED,"������: �� ������ ���� ��� ������� {FFFFFF}60{FF0000}-�� ������, ����� ������� ��� ������");
				Player[playerid][Slot7] = 38; SendClientMessage(playerid, COLOR_YELLOW, "��������� ������� � ���� ����� ��������.");
			}
			SendCommand(playerid, "/mygun", "");
		}//�� - ������

	case DIALOG_MYGUN10:
		{//�� - ������
		    if(!response) return SendCommand(playerid, "/mygun", "");
			if(listitem == 0) Player[playerid][Slot10] = 0;
			if(listitem == 1) Player[playerid][Slot10] = 46;
			if(listitem == 2) Player[playerid][Slot10] = 42;
			SendClientMessage(playerid, COLOR_YELLOW, "��������� ������� � ���� ����� ��������.");
			SendCommand(playerid, "/mygun", "");
		}//�� - ������

	case DIALOG_STYLE:
		{//����� �����
			if(response)
			{//�������
				if(listitem == 0)
				{//�������
					Player[playerid][Slot9] = 0;SetPlayerFightingStyle (playerid, FIGHT_STYLE_NORMAL);
					SendClientMessage(playerid,COLOR_YELLOW,"����� ����� ������� �� {FFFFFF}�������");
				}//�������
				if(listitem == 1)
				{//����
					Player[playerid][Slot9] = 1;SetPlayerFightingStyle (playerid, FIGHT_STYLE_BOXING);
					SendClientMessage(playerid,COLOR_YELLOW,"����� ����� ������� �� {FFFFFF}Boxing");
				}//����
				if(listitem == 2)
				{//������
					Player[playerid][Slot9] = 2;SetPlayerFightingStyle (playerid, FIGHT_STYLE_KUNGFU);
					SendClientMessage(playerid,COLOR_YELLOW,"����� ����� ������� �� {FFFFFF}KungFu");
				}//������
				if(listitem == 3)
				{//������
					Player[playerid][Slot9] = 3;SetPlayerFightingStyle (playerid, FIGHT_STYLE_KNEEHEAD);
					SendClientMessage(playerid,COLOR_YELLOW,"����� ����� ������� �� {FFFFFF}KneeHead");
				}//������
				if(listitem == 4)
				{//�������
					Player[playerid][Slot9] = 4;SetPlayerFightingStyle (playerid, FIGHT_STYLE_GRABKICK);
					SendClientMessage(playerid,COLOR_YELLOW,"����� ����� ������� �� {FFFFFF}GrabKick");
				}//�������
				if(listitem == 5)
				{//�����
					Player[playerid][Slot9] = 5;SetPlayerFightingStyle (playerid, FIGHT_STYLE_ELBOW);
					SendClientMessage(playerid,COLOR_YELLOW,"����� ����� ������� �� {FFFFFF}Elbow");
				}//�����
				if(listitem == 6)
				{//����
					Player[playerid][Slot9] = -1;
					SendClientMessage(playerid,COLOR_YELLOW,"����� ����� ������� �� {FFFFFF}MixFight");
				}//����
			}//�������
		}//����� �����

	case DIALOG_BANK:
		{//����
			if(response)
			{//�������
				if(listitem == 0)
				{//�� ����
				    if (!IsPlayerInRangeOfPoint(playerid, 5, 2316.6182, -7.2874, 26.7422)) return SendClientMessage(playerid, COLOR_RED, "������: �� �� � �����");
					ShowPlayerDialog(playerid, DIALOG_BANKTO, 1, "���� - �������� �� ����", "{FFFFFF}������� ����� �� ������ ��������?", "��", "�����");
				}//�� ����
				if(listitem == 1)
				{//�� �����
				    if (!IsPlayerInRangeOfPoint(playerid, 5, 2316.6182, -7.2874, 26.7422)) return SendClientMessage(playerid, COLOR_RED, "������: �� �� � �����");
					new String[120];format(String,sizeof(String),"{FFFFFF}� ��� �� ����� {00FF00}%d{FFFFFF}$\n������� �� ������ �����?",Player[playerid][Bank]);
					ShowPlayerDialog(playerid, DIALOG_BANKFROM, 1, "���� - ����� �� �����", String, "��", "�����");
				}//�� �����
				if(listitem == 2)
				{//��� ��������� �������� ����� � �����
				    new String[512];
				    strcat(String, "{FFFF00}�������� ����� � ����� ������� �� ��������� ������ ������� ����:{FFFFFF}\n");
				    strcat(String, "   ��� ���� - �������� ����� � �����: 50 000 000$\n");
				    strcat(String, "10 000 000$ - �������� ����� � �����: 100 000 000$\n");
				    strcat(String, "20 000 000$ - �������� ����� � �����: 150 000 000$\n");
				    strcat(String, "40 000 000$ - �������� ����� � �����: 250 000 000$\n");
				    strcat(String, "60 000 000$ - �������� ����� � �����: 400 000 000$\n");
				    strcat(String, "80 000 000$ - �������� ����� � �����: 999 999 999$\n");
					ShowPlayerDialog(playerid, 999, 0, "��� ��������� �������� ����� � �����", String, "��", "");
				}//��� ��������� �������� ����� � �����
			}//�������
		}//����

	case DIALOG_BANKTO:
		{//���� �������� ���
			if(response)
			{//�������
				new entered = strval(inputtext);
				if (entered < 0){SendClientMessage(playerid,COLOR_RED,"������: ��������� ����� �����������");return 1;}
				if (Player[playerid][Bank] >= MaxBank[playerid]) return SendClientMessage(playerid, COLOR_RED, "������: ��������� �������� ����� � �����!");
				if (entered > Player[playerid][Cash]){entered = Player[playerid][Cash];}
				new BankFree = MaxBank[playerid] - Player[playerid][Bank];if (BankFree < entered){entered = BankFree;}
				Player[playerid][Bank] += entered;Player[playerid][Cash] -= entered;SavePlayer(playerid);
				new String[120];format(String,sizeof(String),"�� ������� �������� {FFFFFF}%d{00FF00}$",entered);
				SendClientMessage(playerid,COLOR_GREEN,String);
			}//�������
			else
			{
			    //������������ ����. �����
			    new houseid = Player[playerid][Home];
				if (houseid <= 0) MaxBank[playerid] = 50000000;//���� 50 ��� ���� � ������ ��� ����
				else if (Property[houseid][pPrice] >= 80000000) MaxBank[playerid] = 999999999; //��� �� 80�� - 999��
				else if (Property[houseid][pPrice] >= 60000000) MaxBank[playerid] = 400000000; //��� �� 60�� - 400��
				else if (Property[houseid][pPrice] >= 40000000) MaxBank[playerid] = 250000000; //��� �� 40�� - 250��
				else if (Property[houseid][pPrice] >= 20000000) MaxBank[playerid] = 150000000; //��� �� 20�� - 150��
				else MaxBank[playerid] = 100000000; //��� �� 10�� - 100��
	            //������������ ����. �����
				new String[120];
				format(String,sizeof(String),"{AFAFAF}����. �� �����: {00FF00}%d{AFAFAF}. ��������: {FFFFFF}%d{AFAFAF}.",Player[playerid][Bank],MaxBank[playerid]);
				ShowPlayerDialog(playerid, DIALOG_BANK, 2, String, "�������� ������ �� ����\n����� ������ �� �����\n{AFAFAF}(?) ��� ��������� �������� ����� � �����", "��", "");
			}
		}//���� ��������

	case DIALOG_BANKFROM:
		{//���� c����
			if(response)
			{//�������
				new entered = strval(inputtext);
				if (entered < 0){SendClientMessage(playerid,COLOR_RED,"������: ��������� ����� �����������");return 1;}
				if (entered > Player[playerid][Bank]){entered = Player[playerid][Bank];}
				Player[playerid][Bank] -= entered;Player[playerid][Cash] += entered;SavePlayer(playerid);
				new String[120];format(String,sizeof(String),"�� ������� ����� {FFFFFF}%d{00FF00}$",entered);
				SendClientMessage(playerid,COLOR_GREEN,String);
			}//�������
			else
			{
			    //������������ ����. �����
			    new houseid = Player[playerid][Home];
				if (houseid <= 0) MaxBank[playerid] = 50000000;//���� 50 ��� ���� � ������ ��� ����
				else if (Property[houseid][pPrice] >= 80000000) MaxBank[playerid] = 999999999; //��� �� 80�� - 999��
				else if (Property[houseid][pPrice] >= 60000000) MaxBank[playerid] = 400000000; //��� �� 60�� - 400��
				else if (Property[houseid][pPrice] >= 40000000) MaxBank[playerid] = 250000000; //��� �� 40�� - 250��
				else if (Property[houseid][pPrice] >= 20000000) MaxBank[playerid] = 150000000; //��� �� 20�� - 150��
				else MaxBank[playerid] = 100000000; //��� �� 10�� - 100��
	            //������������ ����. �����
				new String[120];
				format(String,sizeof(String),"{AFAFAF}����. �� �����: {00FF00}%d{AFAFAF}. ��������: {FFFFFF}%d{AFAFAF}.",Player[playerid][Bank],MaxBank[playerid]);
				ShowPlayerDialog(playerid, DIALOG_BANK, 2, String, "�������� ������ �� ����\n����� ������ �� �����\n{AFAFAF}(?) ��� ��������� �������� ����� � �����", "��", "");
			}
		}//���� �����		
		
	case DIALOG_HOUSEMENU:
		{//��� ������
			if(response)
			{//�������
			    if(listitem == 0) SendCommand(playerid, "/enterhouse", "");
				if(listitem == 1) SendCommand(playerid, "/houseinfo", "");
				if(listitem == 2) SendCommand(playerid, "/buyhouse", "");
				if(listitem == 3)
				{//������� ���
				    if (Player[playerid][Home] > 0 && Player[playerid][Home] == LastHouseVisited[playerid])
				    {
				        new String[180], myhome = Player[playerid][Home], Nalog = Property[myhome][pPrice] / 100 * 15;
				        format(String, sizeof String, "{FFFFFF}�� �������, ��� ������ ������� ���?\n\n���� ���� ��� �������: {008D00}%d$\n{FFFFFF}���� ���� ��� �������: {E60020}%d$", Property[myhome][pPrice], Property[myhome][pPrice] - Nalog);
						return ShowPlayerDialog(playerid, DIALOG_SELLHOUSE, 0, "������� ���", String, "{FF0000}�������", "������");
				    }
				}//������� ���
				if(listitem == 4)
				{//��������� ����
					if (Player[playerid][Home] == 0){SendClientMessage(playerid,COLOR_RED,"������: � ��� ��� ����.");return 1;}
					new myhome = Player[playerid][Home];
					if(strcmp(Property[myhome][pOwner], GetName(playerid), true)) return SendClientMessage(playerid, COLOR_RED, "������: ��� �� ��� ���");
					ShowPlayerDialog(playerid, DIALOG_HOUSEMENUPRICE, 1, "�������� ����", "{FFFF00}�������� ���� �������� � ����������� �� ��� ���������:{FFFFFF}\n� ����� 20 000 000$\n� 20 000 000$\n� 40 000 000$\n� 60 000 000$\n� 80 000 000$\n� �������������� ��� (/shop)\n\n{FFFF00}�� ������� �� ������ �������� ���� ����?", "��", "�����");
				}//��������� ����
				if(listitem == 5) SendCommand(playerid, "/openhouse", "");
				if(listitem == 6)
				{//������� ��� ����� (�������)
					if (Player[playerid][Home] == 0){SendClientMessage(playerid,COLOR_RED,"������: � ��� ��� ����.");return 1;}
					new myhome = Player[playerid][Home];
					if(strcmp(Property[myhome][pOwner], GetName(playerid), true)) return SendClientMessage(playerid, COLOR_RED, "������: ��� �� ��� ���");
					Player[playerid][Spawn] = 4;
					SendClientMessage(playerid,COLOR_YELLOW,"����� ������ �������� �������� �� {FFFFFF}������ ��� (�������)");
				}//������� ��� ����� (�������)
				if(listitem == 7)
				{//������� ��� ����� (������)
					if (Player[playerid][Home] == 0){SendClientMessage(playerid,COLOR_RED,"������: � ��� ��� ����.");return 1;}
					new myhome = Player[playerid][Home];
					if(strcmp(Property[myhome][pOwner], GetName(playerid), true)) return SendClientMessage(playerid, COLOR_RED, "������: ��� �� ��� ���");
					Player[playerid][Spawn] = 6;
					SendClientMessage(playerid,COLOR_YELLOW,"����� ������ �������� �������� �� {FFFFFF}������ ��� (������)");
				}//������� ��� ����� (������)
			}//�������
		}//��� ������


	case DIALOG_HOUSEMENUPRICE:
		{//���� ����
			if(response)
			{//�������
				new entered = strval(inputtext);
				if (entered <= 0){SendClientMessage(playerid,COLOR_RED,"��������� ����� �����������");return 1;}
				if (entered > Player[playerid][Cash]){entered = Player[playerid][Cash];}
				new myhome = Player[playerid][Home];
				new BankFree = 80000000 - Property[myhome][pPrice];if (BankFree < entered){entered = BankFree;}
				if (entered == 0) return SendClientMessage(playerid, COLOR_RED, "������: ��������� ���� ��� �������� ���������");
				Property[myhome][pPrice] += entered;Player[playerid][Cash] -= entered;SavePlayer(playerid); SaveProperty(myhome);
				new String[120];format(String,sizeof(String),"����� ���� ����: {FFFFFF}%d{00FF00}$",Property[myhome][pPrice]);
				SendClientMessage(playerid,COLOR_GREEN,String);
				if (Property[myhome][pBuyBlock] <= 0)
				{//��� ������������
					new text3d[MAX_3DTEXT];
					format(text3d, sizeof(text3d), "{00FF00}��� ({FFFFFF}%d${00FF00})\n{007FFF}��������:{FFFFFF} %s\n������� [{FFFF00}Alt{FFFFFF}] ����� ������������", Property[myhome][pPrice], Property[myhome][pOwner]);
					UpdateDynamic3DTextLabelText(PropertyText3D[myhome], 0xFFFFFFFF, text3d);
				}//��� ������������
			}//�������
			else{ShowPlayerDialog(playerid, DIALOG_HOUSEMENU, 2, "{00FF00}���", "{007FFF}����� � ���{FFFFFF}\n���������� � ����\n������ ���\n������� ���\n��������� ���� ����\n������� / ������� ���\n������� ������ �������� (������� ����)\n������� ������ �������� (������ ����)", "��", "������");}
		}//���� ����

	case DIALOG_CLANCREATE:
		{//�� ������ ������� ���� �� 500�?
			if(response)
			{//��
				if (Player[playerid][Cash] < 500000){SendClientMessage(playerid,COLOR_RED,"������: � ��� ��� {FFFFFF}500 000{FF0000}$");return 1;}
				new StringX[1024];
				strcat(StringX, "{AFAFAF}���� �0\n{FFFF99}���� �1\n{FFFF00}���� �2\n{FF99FF}���� �3\n{FF9999}���� �4\n{FFCC00}���� �5\n{FF66CC}���� �6\n{FF6600}���� �7\n{FF00FF}���� �8\n{CCFFFF}���� �9\n{00A0C1}���� �10\n");
				strcat(StringX, "{E5004F}���� �11\n{CCFF00}���� �12\n{CC66FF}���� �13\n{CC3366}���� �14\n{CC6600}���� �15\n{9999FF}���� �16\n{9925FF}���� �17\n{99CCCC}���� �18\n{99FF66}���� �19\n{99FF00}���� �20\n");
				strcat(StringX, "{993300}���� �21\n{990066}���� �22\n{66FFFF}���� �23\n{6666FF}���� �24\n{EB6100}���� �25\n{666633}���� �26\n{33FFFF}���� �27\n{3399FF}���� �28\n{33CC99}���� �29\n{33FF66}���� �30\n");
				strcat(StringX, "{339900}���� �31\n{457EFF}���� �32\n{FFCC00}���� �33\n{976D3D}���� �34\n{FF8800}���� �35\n{FF6666}���� �36\n{0015FF}���� �37\n{DDAA00}���� �38\n{FFFFFF}���� �39\n{FF8000}���� �40");
				ShowPlayerDialog(playerid, DIALOG_CLANCREATECOLOR, 2, "�������� ���� �����", StringX, "�������", "������");
			}//��
		}//�� ������ ������� ���� �� 500�?

	case DIALOG_CLANCREATECOLOR:
		{//����� �����
			if(response)
			{//��
				CreateClanColor[playerid] = listitem;
				ShowPlayerDialog(playerid, DIALOG_CLANCREATENAME, 1, "������� �������� �����", "{FFFFFF}������� �������� �����.\n{008E00}[����� �� 2 �� 20 ��������]", "�������", "������");
			}//��
		}//����� �����

	case DIALOG_CLANCREATENAME:
		{//���� �������� �����
			if(response)
			{//�������
				if(!strlen(inputtext) || strlen(inputtext) < 2 || strlen(inputtext) > 20) return ShowPlayerDialog(playerid, DIALOG_CLANCREATENAME, 1, "������� �������� �����", "{FF0000}������: �������� ����� ��������..\n\n{FFFFFF}������� �������� �����.\n{008E00}[����� �� 2 �� 20 ��������]", "�������", "������"); //���� ����� �����������
				
				new AllowName = 1;
			    for (new i; i < strlen(inputtext); i++)
				{//�������� ������� ������� � ���� �� ������������
				    if (inputtext[i] >= '0' && inputtext[i] <= '9') continue;
				    if (inputtext[i] >= 'A' && inputtext[i] <= 'Z') continue;
				    if (inputtext[i] >= 'a' && inputtext[i] <= 'z') continue;
                    if (inputtext[i] == '_') continue;
				    AllowName = 0;
				}//�������� ������� ������� � ���� �� ������������
				if (!AllowName)  return ShowPlayerDialog(playerid, DIALOG_CLANCREATENAME, 1, "������� �������� �����", "{FF0000}������: � �������� ����������� ������ ��������� �����, ����� � ������ '_'.\n\n{FFFFFF}������� �������� �����.\n{008E00}[����� �� 2 �� 20 ��������]", "�������", "������");
				
				for(new i = 1; i < MAX_CLAN; i++)
				{//��� ��������� id`� ������
					if (Clan[i][cLevel] == 0) continue; //���������� �������������� �����
                    if(!strcmp(Clan[i][cName], inputtext, true)) return ShowPlayerDialog(playerid, DIALOG_CLANCREATENAME, 1, "������� �������� �����", "{FF0000}������: ���� � ����� ������ ��� ����������.\n\n{FFFFFF}������� �������� �����.\n{008E00}[����� �� 2 �� 20 ��������]", "�������", "������");
				}//��� ��������� id`� ������
				if (Player[playerid][Cash] < 500000) return SendClientMessage(playerid,COLOR_RED,"������: � ��� ��� {FFFFFF}500 000{FF0000}$");
				Player[playerid][Cash] -= 500000;

				new clanid = 0, file, filename[MAX_FILE_NAME];
				for(new i = 1; i < MAX_CLAN; i++)
				{//--- ������� ����������� ��������� ID ��� �����
				    if (Clan[i][cLevel] > 0) continue;
				    clanid = i; if (clanid > MaxClanID) MaxClanID = clanid;
					break;
				}//--- ������� ����������� ��������� ID ��� �����
				if (clanid == 0) return SendClientMessage(playerid, COLOR_RED, "������: �� ������� ��������� ����� ������. ���������� ������� ���� �������.");
				format(filename, sizeof(filename), "Clans/%d.ini", clanid);
				//---������� ���� �����
				file = ini_createFile(filename);
				ini_setInteger(file, "Level", 1);
				ini_closeFile(file);
				//---������� ���� �����
				
				//ResetClan
				Clan[clanid][cLevel] = 1;
				strmid(Clan[clanid][cLider], PlayerName[playerid], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
				strmid(Clan[clanid][cName], inputtext, 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
				Clan[clanid][cColor] = CreateClanColor[playerid];
				Clan[clanid][cBase] = 0;
				Clan[clanid][cXP] = 0;
				Clan[clanid][cLastDay] = DateToIntDate(Day, Month, Year) + 7;//�������� ����� ����� ������
				Clan[clanid][cCWwin] = 0;
				Clan[clanid][cEnemyClan] = 0;
				strmid(Clan[clanid][cMessage], "�����", 0, strlen("�����"), 25);
				strmid(Clan[clanid][cMember1], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);
				strmid(Clan[clanid][cMember2], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);
				strmid(Clan[clanid][cMember3], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);
				strmid(Clan[clanid][cMember4], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);
				strmid(Clan[clanid][cMember5], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);
				strmid(Clan[clanid][cMember6], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);
				strmid(Clan[clanid][cMember7], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);
				strmid(Clan[clanid][cMember8], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);
				strmid(Clan[clanid][cMember9], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);
				strmid(Clan[clanid][cMember10], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);
				strmid(Clan[clanid][cMember11], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);
				strmid(Clan[clanid][cMember12], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);
				strmid(Clan[clanid][cMember13], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);
				strmid(Clan[clanid][cMember14], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);
				strmid(Clan[clanid][cMember15], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);
				strmid(Clan[clanid][cMember16], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);
				strmid(Clan[clanid][cMember17], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);
				strmid(Clan[clanid][cMember18], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);
				strmid(Clan[clanid][cMember19], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);
				strmid(Clan[clanid][cMember20], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);
				
				PlayerColor[playerid] = CreateClanColor[playerid];
				Player[playerid][MyClan] = clanid; Player[playerid][Leader] = 100; Player[playerid][Member] = -1;
				SaveClan(clanid); SavePlayer(playerid);
				new ChatMes[120];
				format(ChatMes, sizeof(ChatMes), "{008E00}�� ������� ������� ���� '{FFFFFF}%s{008E00}'", inputtext);
				SendClientMessage(playerid,COLOR_GREEN, ChatMes);
			}//�������
		}//���� �������� �����


	case DIALOG_CLANMENU:
		{//���� �����
			if(response)
			{//�������
				if(listitem == 0)
				{//���������� � �����
				    new clanid = Player[playerid][MyClan];
				    if (clanid == 0) return SendClientMessage(playerid, COLOR_RED, "������: �� �� � �����!");
					else return ShowClanStats(playerid, clanid);
				}//���������� � �����
				if(listitem == 1)
				{//���������� ������
					if (Player[playerid][Leader] < 2){SendClientMessage(playerid, COLOR_RED, "������: � ��� ������������ ����.");return 1;}
					if (Player[playerid][Leader] == 2){ShowPlayerDialog(playerid, DIALOG_CLANMANAGER, 2, "���������� ������", "������� ������ �� �����", "��", "������");}
					if (Player[playerid][Leader] >= 100) ShowPlayerDialog(playerid, DIALOG_CLANMANAGER, 2, "���������� ������", "{FFFFFF}������� ������ �� �����\n�������� ���� �����\n�������� ��������� ����� ��� ����� � ����\n������������� ����\n{AFAFAF}�������� �� ��������� �����\n{FF0000}[���������� ����]\n/---{008E00} ���������� ���� {FFFFFF}---/\n������� ���� �����\n����� ��������� �������\n����� ��������� � ��������� �������", "��", "������");
				}//���������� ������
				if(listitem == 2)
				{//��������� � ������� �������
				    new String[1024], String2[140], clanid = Player[playerid][MyClan], enemies = 0; if (clanid == 0) return 1;
				    if (Clan[clanid][cEnemyClan] > 0)
				    {//���� ������� ����-�� �����
				        new enemyclan = Clan[clanid][cEnemyClan];
				        format(String, sizeof String, "{FFFFFF}��� ���� ������� ����� ����� {FF0000}%s[ID:%d]\n\n", Clan[enemyclan][cName], enemyclan);
				    }//���� ������� ����-�� �����
				    else format(String, sizeof String, "{008E00}��� ���� ������ �� �������� �����.\n\n");
				    
				    strcat(String, "{FFFFFF}��������� ����� �������� ����� ������:\n{FF0000}");
				    for(new i = 1; i <= MaxClanID; i++)
				    {//����
				        if (Clan[i][cEnemyClan] == clanid)
				        {//���� i �������� ����� ����� ������
				            format(String2, sizeof String2, "%s[ID:%d]\n", Clan[i][cName], i);
							strcat(String, String2); enemies++;
				        }//���� i �������� ����� ����� ������
				    }//����
				    if (enemies == 0) strcat(String, "{008E00}������ ����� ����� �� �������� �����.\n");
				    strcat(String, "\n{FFFF00}����������� {FFFFFF}/claninfo [ID �����] {FFFF00}����� ���������� ���������� � ������ �����.");
				    ShowPlayerDialog(playerid, 999, 0, "��������� � �������", String, "��", "");
				}//��������� � ������� �������
				if(listitem == 3)
				{//�������� ����
					if (Player[playerid][Leader] == 100){SendClientMessage(playerid,COLOR_RED,"������: ����� �� ����� �������� ����! ����������� '���������� ������' ����� ���������� ����."); return 1;}
					new StringX[120], clanid = Player[playerid][MyClan];
					format(StringX,sizeof(StringX),"{008E00}�� �������, ��� ������ ����� �� ����� '{FFFFFF}%s{008E00}'",Clan[clanid][cName]);
					ShowPlayerDialog(playerid, DIALOG_CLANEXIT, 0, "����� �� �����", StringX, "��", "������");
				}//�������� ����
			}//�������
		}//���� �����

	case DIALOG_CLANEXIT:
		{//����� �� �����
			if(response)
			{//�������
				new StringX[120], clanid = Player[playerid][MyClan];
				format(StringX,sizeof(StringX),"����� %s[%d] ������� ����.",PlayerName[playerid],playerid);
				foreach(Player, cid)
				{//����
     				if (Player[cid][Member] != 0 && Player[cid][MyClan] == Player[playerid][MyClan] && Logged[cid] == 1) SendClientMessage(cid,COLOR_GREEN,StringX);
				}//����
				if(!strcmp(Clan[clanid][cMember1], PlayerName[playerid], true)) strmid(Clan[clanid][cMember1], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);
				if(!strcmp(Clan[clanid][cMember2], PlayerName[playerid], true)) strmid(Clan[clanid][cMember2], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);
				if(!strcmp(Clan[clanid][cMember3], PlayerName[playerid], true)) strmid(Clan[clanid][cMember3], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);
				if(!strcmp(Clan[clanid][cMember4], PlayerName[playerid], true)) strmid(Clan[clanid][cMember4], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);
				if(!strcmp(Clan[clanid][cMember5], PlayerName[playerid], true)) strmid(Clan[clanid][cMember5], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);
				if(!strcmp(Clan[clanid][cMember6], PlayerName[playerid], true)) strmid(Clan[clanid][cMember6], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);
				if(!strcmp(Clan[clanid][cMember7], PlayerName[playerid], true)) strmid(Clan[clanid][cMember7], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);
				if(!strcmp(Clan[clanid][cMember8], PlayerName[playerid], true)) strmid(Clan[clanid][cMember8], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);
				if(!strcmp(Clan[clanid][cMember9], PlayerName[playerid], true)) strmid(Clan[clanid][cMember9], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);
				if(!strcmp(Clan[clanid][cMember10], PlayerName[playerid], true)) strmid(Clan[clanid][cMember10], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);
				if(!strcmp(Clan[clanid][cMember11], PlayerName[playerid], true)) strmid(Clan[clanid][cMember11], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);
				if(!strcmp(Clan[clanid][cMember12], PlayerName[playerid], true)) strmid(Clan[clanid][cMember12], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);
				if(!strcmp(Clan[clanid][cMember13], PlayerName[playerid], true)) strmid(Clan[clanid][cMember13], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);
				if(!strcmp(Clan[clanid][cMember14], PlayerName[playerid], true)) strmid(Clan[clanid][cMember14], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);
				if(!strcmp(Clan[clanid][cMember15], PlayerName[playerid], true)) strmid(Clan[clanid][cMember15], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);
				if(!strcmp(Clan[clanid][cMember16], PlayerName[playerid], true)) strmid(Clan[clanid][cMember16], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);
				if(!strcmp(Clan[clanid][cMember17], PlayerName[playerid], true)) strmid(Clan[clanid][cMember17], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);
				if(!strcmp(Clan[clanid][cMember18], PlayerName[playerid], true)) strmid(Clan[clanid][cMember18], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);
				if(!strcmp(Clan[clanid][cMember19], PlayerName[playerid], true)) strmid(Clan[clanid][cMember19], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);
				if(!strcmp(Clan[clanid][cMember20], PlayerName[playerid], true)) strmid(Clan[clanid][cMember20], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);
				Player[playerid][Member] = 0; Player[playerid][Leader] = 0; Player[playerid][MyClan] = 0;
				PlayerColor[playerid] = 0; SavePlayer(playerid); SaveClan(clanid);
			}//�������
		}//����� �� �����

	case DIALOG_TABMENU:
		{//���� ������ ���
			if(response)
			{//�������
				if (listitem == 0)
				{//���������� ������
					ShowStats(playerid,ClickedPid[playerid]);
				}//���������� ������
				if (listitem == 1)
				{//���������� ����� ������
				    new clicked = ClickedPid[playerid], clanid = Player[clicked][MyClan];
					if (clanid == 0) return SendClientMessage(playerid,COLOR_RED,"������: ���� ����� �� � �����.");
					else return ShowClanStats(playerid, clanid);
				}//���������� ����� ������
				if (listitem == 2) return SendClientMessage(playerid, COLOR_RED, "��� �������� ������� ��������� ��������� /pm [id ������] [���������]");//��������� PM
				if (listitem == 3)
				{//���� �����
					ShowPlayerDialog(playerid, DIALOG_TABGIVECASH, 1, "�������� ������", "������� ����� �����, ������� ������ ��������.", "��", "������");
				}//���� �����
				if (listitem == 4)
				{//������� �� ����� (PVP)
				    new clicked = ClickedPid[playerid];
				    if (JoinEvent[playerid] > 0) return SendClientMessage(playerid,COLOR_RED,"������: �� ������ ����� �� ������������ ������, ��� �������� ����-�� �� �����.");
					if (PrestigeGM[playerid] == 1) return SendClientMessage(playerid,COLOR_RED,"������: �� ������ ����� �� ������ ���� ������, ��� �������� ����-�� �� �����");
					if (PrestigeGM[clicked] == 1) return SendClientMessage(playerid,COLOR_RED,"������: ������ ������� ����� ������ �� �����, ��� ��� �� ��������� � ������ ����.");
					if (Player[playerid][Banned] > 0 || Player[clicked][Banned] > 0) return SendClientMessage(playerid,COLOR_RED,"������: ���������� ������ �� ����� ����������� � PvP.");
					if (Logged[clicked] == 0) return SendClientMessage(playerid,COLOR_RED,"������: ���� ����� �� ���������������.");
				    if (Player[clicked][ConInvitePVP] == 0) return SendClientMessage(playerid, COLOR_RED, "������: ���� ����� �������� �������� ��� �� PvP.");
				    if (InEvent[clicked] > 0) return SendClientMessage(playerid,COLOR_RED,"������: ���� ����� ��������� � �������������.");
				    if (LAFK[clicked] > 3) return SendClientMessage(playerid,COLOR_RED,"������: ���� ����� ������ AFK.");
				    if (LSpecID[clicked] > -1) return SendClientMessage(playerid,COLOR_RED,"������: ���� ����� ��������� � ������ ������.");
				    if (Player[clicked][Level] == 0) return SendClientMessage(playerid,COLOR_RED,"������: ���� ����� ������ �������� ��������...");
				    if (PlayerPVP[clicked][TimeOut] > 0) return SendClientMessage(playerid,COLOR_RED,"������: ����� ������ ���-�� ������ ��� ������� �� �����. ����������, ���������� �������..");
				    PlayerPVP[playerid][Invite] = clicked;PlayerPVP[clicked][Invite] = playerid;PlayerPVP[playerid][TimeOut] = 20; PlayerPVP[clicked][TimeOut] = 20;
                    CanStartPVP[playerid] = 0;CanStartPVP[clicked] = 1;
					PlayerPVP[playerid][PlayMap] = PlayerPVP[playerid][Map];PlayerPVP[playerid][PlayWeapon] = PlayerPVP[playerid][Weapon];PlayerPVP[playerid][PlayHealth] = PlayerPVP[playerid][Health];
                    PlayerPVP[clicked][PlayMap] = PlayerPVP[playerid][Map];PlayerPVP[clicked][PlayWeapon] = PlayerPVP[playerid][Weapon];PlayerPVP[clicked][PlayHealth] = PlayerPVP[playerid][Health];
					PlayerPVP[playerid][Status] = 1; JoinEvent[playerid] = EVENT_PVP; PlayerPVP[clicked][Status] = 0;
					new String[300], zWeapon[48], zMap[30];	GetWeaponName(PlayerPVP[playerid][Weapon],zWeapon,sizeof(zWeapon));
				    if (PlayerPVP[playerid][PlayWeapon] == 0) zWeapon = "��� ������";
				    if (PlayerPVP[playerid][PlayMap] == 1) zMap = "�����";
					if (PlayerPVP[playerid][PlayMap] == 2) zMap = "��� ������";
					if (PlayerPVP[playerid][PlayMap] == 3) zMap = "��� ������";
					if (PlayerPVP[playerid][PlayMap] == 4) zMap = "������";
					if (PlayerPVP[playerid][PlayMap] == 5) zMap = "�����";
					if (PlayerPVP[playerid][PlayMap] == 6) zMap = "����������� ��������";
					if (PlayerPVP[playerid][PlayMap] == 7) zMap = "��� �����";
					if (PlayerPVP[playerid][PlayMap] == 8) zMap = "�����";
					if (PlayerPVP[playerid][PlayMap] == 9) zMap = "�������� �������";
					if (PlayerPVP[playerid][PlayMap] == 10) zMap = "��������";
				    format(String,sizeof(String),"{FF9E27}PVP: {AFAFAF}�� ������� ������ %s �� �����. � ���� ���� 20 ������ �� �������� �������.", PlayerName[clicked]);SendClientMessage(playerid,COLOR_RED,String);
				    format(String,sizeof(String),"{FF9E27}PVP: {AFAFAF}����� %s �������� ��� �� �����. ����������� {FF9E27}/pvp{AFAFAF} ����� ������� �����.", PlayerName[playerid]);SendClientMessage(clicked,COLOR_RED,String);
				    format(String,sizeof(String),"{AFAFAF}������: %s   �����: %s   ��������: %d", zWeapon, zMap, PlayerPVP[playerid][PlayHealth]);
				    SendClientMessage(playerid,COLOR_RED,String);SendClientMessage(clicked,COLOR_RED,String);
				}//������� �� ����� (PVP)
				if (listitem == 5)
				{//���������� � ����
				    new clickedplayerid = ClickedPid[playerid];
				    if (Player[playerid][Member] == 0) return SendClientMessage(playerid, COLOR_RED, "������: � ��� ��� �����! ����������� ������� {FFFFFF}/clan {FF0000}����� ������� ���.");
				    if (Player[playerid][Leader] == 0) return SendClientMessage(playerid, COLOR_RED, "������: � ��� ��� ����� �� �������� ������� � ����.");
					if (Player[clickedplayerid][MyClan] != 0) return SendClientMessage(playerid, COLOR_RED, "������: ���� ����� ��� ������� � ����-�� �����.");
	 				if (Player[clickedplayerid][Level] < 5 && Player[clickedplayerid][Prestige] == 0) return SendClientMessage(playerid, COLOR_RED, "������: ������ ���������� � ���� ������� ���� 5 ������.");
					new clicked = ClickedPid[playerid];
					if (Player[clicked][MyClan] == 0)
					{//�����, �� �������� �������� - �� � �����
					    new Free = 0, clanid = Player[playerid][MyClan], StringF[140];
						if(!strcmp(Clan[clanid][cMember1], "�����", true)) Free++;
						if(!strcmp(Clan[clanid][cMember2], "�����", true)) Free++;
						if(!strcmp(Clan[clanid][cMember3], "�����", true)) Free++;
						if(!strcmp(Clan[clanid][cMember4], "�����", true)) Free++;
						if(!strcmp(Clan[clanid][cMember5], "�����", true)) Free++;
						if(!strcmp(Clan[clanid][cMember6], "�����", true)) Free++;
						if(!strcmp(Clan[clanid][cMember7], "�����", true)) Free++;
						if(!strcmp(Clan[clanid][cMember8], "�����", true)) Free++;
						if(!strcmp(Clan[clanid][cMember9], "�����", true)) Free++;
						if(!strcmp(Clan[clanid][cMember10], "�����", true)) Free++;
						if(!strcmp(Clan[clanid][cMember11], "�����", true)) Free++;
						if(!strcmp(Clan[clanid][cMember12], "�����", true)) Free++;
						if(!strcmp(Clan[clanid][cMember13], "�����", true)) Free++;
						if(!strcmp(Clan[clanid][cMember14], "�����", true)) Free++;
						if(!strcmp(Clan[clanid][cMember15], "�����", true)) Free++;
						if(!strcmp(Clan[clanid][cMember16], "�����", true)) Free++;
						if(!strcmp(Clan[clanid][cMember17], "�����", true)) Free++;
						if(!strcmp(Clan[clanid][cMember18], "�����", true)) Free++;
						if(!strcmp(Clan[clanid][cMember19], "�����", true)) Free++;
						if(!strcmp(Clan[clanid][cMember20], "�����", true)) Free++;
						
						if (Free == 0) return SendClientMessage(playerid,COLOR_RED,"������: � ����� ��� �����.");
						if (Logged[clicked] == 0) return SendClientMessage(playerid,COLOR_RED,"������: ������ ���������� ����� ������ � ����, ��� ��� �� �� �������������.");
						if (Player[clicked][ConInviteClan] == 0) return SendClientMessage(playerid, COLOR_RED, "������: ���� ����� �������� ���������� ��� � ����.");
						if (LAFK[clicked] > 4) return SendClientMessage(playerid,COLOR_RED,"������: ������ ���������� ����� ������ � ����, ��� ��� �� AFK.");
						if (InEvent[clicked] > 0) return SendClientMessage(playerid,COLOR_RED,"������: ������ ���������� ����� ������ � ����, ��� ��� �� ������ ��������� � ������������.");
 						InviteClan[clicked] = Player[playerid][MyClan];
						SendClientMessage(playerid,COLOR_CLAN,"����������� ����������. ��������! � ������ 10 ������ �� �������� �����������!");
						format(StringF,sizeof(StringF),"{008E00}��������! ����� {FFFFFF}%s{008E00} ���������� ��� � ���� '{FFFFFF}%s{008E00}'\n������ ��������?",PlayerName[playerid],Clan[clanid][cName]);
						ShowPlayerDialog(clicked,DIALOG_CLANENTER,0,"����������� � ����",StringF,"��","���");InviteTime[clicked] = 10;
					}//�����, �� �������� �������� - �� � �����
				}//���������� � ����
				if (listitem == 6)
				{//�������� ����� ����� ������
				    new targetid = ClickedPid[playerid], clanid = Player[playerid][MyClan], targetclanid = Player[targetid][MyClan];
				    if (clanid <= 0 || Player[playerid][Leader] < 100) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ������� ����� ����� ��������� �����!");
					if (Clan[clanid][cLevel] < 2) return SendClientMessage(playerid, COLOR_RED, "������: ����� ��������� ����� ��� ���� ������ ���� ��� ������� 2-�� ������!");
				    if (targetclanid <= 0) return SendClientMessage(playerid, COLOR_RED, "������: ���� ����� �� � �����!");
					if (targetclanid == clanid) return SendClientMessage(playerid, COLOR_RED, "������: ������ �������� ����� ������ �����!");
				    if (Clan[clanid][cEnemyClan] > 0) return SendClientMessage(playerid, COLOR_RED, "������: ��������� ����� ����� ������ ������ �����! ��������� ��������� � ����������, ������ ��� ������� �� ���������!");
                    new String[140], String2[140];
					if (Player[playerid][ClanWarTime] > 0)
				    {
				        format(String,sizeof(String),"������: �� ������� �������� ����� �� ������, ��� ����� %d �����",Player[playerid][ClanWarTime] / 60 + 1);
				        return SendClientMessage(playerid,COLOR_RED,String);
				    }
					//��������� �����
					Clan[clanid][cEnemyClan] = targetclanid; SaveClan(clanid);
					format(String, sizeof String, "{008E00}SERVER: ���� {FFFFFF}%s{008E00}[ID:%d] ������� ����� ����� {FFFFFF}%s{008E00}[ID:%d].", Clan[clanid][cName], clanid, Clan[targetclanid][cName], targetclanid);
					SendClientMessageToAll(-1, String); Player[playerid][ClanWarTime] = 3600;
					format(String, sizeof String, "���� %s[ID:%d] ������� ����� ������ �����! �� ������ ������� ���� ����� ��� ������ ����� �����!", Clan[clanid][cName], clanid);
                    format(String2, sizeof String2, "��� ���� ������� ����� ����� %s[ID:%d]! �� ������ ������� ���� ����� ��� ������ ����� �����!", Clan[targetclanid][cName], targetclanid);
					foreach(Player, cid)
					{//����
					    if (Player[cid][MyClan] == targetclanid) SendClientMessage(cid, COLOR_RED, String);
					    else if (Player[cid][MyClan] == clanid) SendClientMessage(cid, COLOR_RED, String2);
					}//����
				}//�������� ����� ����� ������
				if (listitem == 7)
				{//����������������� � ������ (������� 5)
				    new String[140], clickedplayerid = ClickedPid[playerid];
					if (PrestigeTPTime[playerid] > 0) {format(String, sizeof String, "������: �� �� ������ ����������������� � ������� ��� %d ������!", PrestigeTPTime[playerid]); return SendClientMessage(playerid, COLOR_RED, String);}
				    if (Player[playerid][Prestige] < 5) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 5-�� ������ ��������!");
				    if (InEvent[playerid] > 0) return SendClientMessage(playerid, COLOR_RED, "������: ������ ����������������� ����� �� ���������� � �������������!");
				    if (QuestActive[playerid] > 0) return SendClientMessage(playerid, COLOR_RED, "������: ������ ����������������� �� ����� ���������� ������� ��� ������!");
				    if (InEvent[clickedplayerid] > 0) return SendClientMessage(playerid, COLOR_RED, "������: ���� ����� ������ ��������� � �������������!");
					if (GetPlayerVirtualWorld(clickedplayerid) != 0) return SendClientMessage(playerid, COLOR_RED, "������: ���� ����� �� ��������� � ����� ������� ����!");
					if (LSpecID[clickedplayerid] != -1) return SendClientMessage(playerid, COLOR_RED, "������: ���� ����� ��������� � ������ ������!");
					if (GetPlayerInterior(clickedplayerid) != 0) return SendClientMessage(playerid, COLOR_RED, "������: ���� ����� ��������� � ���������!");
					if (Player[clickedplayerid][Banned] > 0) return SendClientMessage(playerid, COLOR_RED, "������ ����������������� � ����� ������ ��� ��� �� �������!");
					SetPlayerInterior(playerid, 0);  SetPlayerVirtualWorld(playerid, 0); PrestigeTPTime[playerid] = 180; AdminTPCantKill[playerid] = 20;
					new Float: x, Float: y, Float: z; GetPlayerPos(clickedplayerid, x, y, z);
				    if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER) SetVehiclePos(GetPlayerVehicleID(playerid), x + 1, y, z);
				    else SetPlayerPos(playerid, x + 1, y, z);
				    format(String, sizeof String, "�� ����������������� � ������ %s[%d] � �� ������ ����� ������ � ������� 20 ������!", PlayerName[clickedplayerid], clickedplayerid); SendClientMessage(playerid, COLOR_YELLOW, String);
				    format(String, sizeof String, "����� %s[%d] ���������������� � ��� (������� 5) � �� ����� ��������� ��� � ������� 20 ������!", PlayerName[playerid], playerid); SendClientMessage(clickedplayerid, COLOR_YELLOW, String);
				}//����������������� � ������ (����� ����, ������� 5)
			}//�������
		}//���� ������ ���

	case DIALOG_TABGIVECASH:
		{//�������� �����
			if(response)
			{//�������
				if (Logged[playerid] == 0){SendClientMessage(playerid,COLOR_RED,"������: �� ������ ����������������, ����� ������������ ��� �������");return 1;}
                if (Player[playerid][Banned] > 0) return SendClientMessage(playerid,COLOR_RED,"������: ���������� ������ �� ����� ���������� ������");
				new plid = ClickedPid[playerid]; new money = strval(inputtext);
				new stringD[180];
				if (!IsPlayerConnected(plid)){SendClientMessage(playerid,COLOR_RED,"������: ������ � ��������� ID ��� � ����"); return 1;}
				if (Logged[plid] == 0){SendClientMessage(playerid,COLOR_RED,"������: ������ � ��������� ID �� ���������������"); return 1;}
				if (Player[plid][GiveCashBalance] >= 100000000) return SendClientMessage(playerid, COLOR_RED, "������: ����� ������ ������ ���������� ������!");
                if (LastPlayerTuneStatus[plid] > 0) return SendClientMessage(playerid, COLOR_RED, "������: ������ ���������� ������ ������, ������� �� ��������� � ��������������. ���������� �������.");
				if (money < 1000){SendClientMessage(playerid,COLOR_RED,"������: ����������� ����� ��������: 1000$"); return 1;}
				if (money > Player[playerid][Cash]){SendClientMessage(playerid,COLOR_RED,"������: � ��� ��� ����� ����� �����"); return 1;}
				if (money > 100000000 - Player[plid][GiveCashBalance]) money = 100000000 - Player[plid][GiveCashBalance];//���� ����� ����� �������� ���� 20� �� ������� - �� ��� ������ ������ ����� �������� �� 20�
				Player[plid][Cash] += money;Player[playerid][Cash] -= money;
				Player[playerid][GiveCashBalance] -= money; Player[plid][GiveCashBalance] += money;
				format(stringD, sizeof(stringD), "{FFFF00}����� %s[%d] ������� ��� {FFFFFF}%d$ {FFFF00}�����", PlayerName[playerid], playerid, money);
				SendClientMessage(plid,COLOR_YELLOW,stringD);
				format(stringD, sizeof(stringD), "{FFFF00}�� ������� �������� {FFFFFF}%d$ {FFFF00}����� ������ %s[%d]", money, PlayerName[plid], plid);
				SendClientMessage(playerid,COLOR_YELLOW,stringD);
				QuestUpdate(playerid, 15, money);//���������� ������ �������� ������ ������� 50 000$

				format(stringD, sizeof stringD, "%d.%d.%d � %d:%d:%d |   CASH: %s[%d] ������� %d$ ������ %s[%d]", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid, money, PlayerName[plid], plid);
				WriteLog("GlobalLog", stringD);WriteLog("CashOperations", stringD);
			}//�������
		}//�������� �����		
		
	case DIALOG_CLANMANAGER:
		{//���������� ������
			if(response)
			{//�������
				if (listitem == 0)
				{//������� �� �����
					ClanFunks[playerid] = -1;
					ShowPlayerDialog(playerid, DIALOG_CLANENTERNAME, 1, "���������� �� �����", "{FFFFFF}������� ������� ������, �������� �� ������ ��������� �� �����", "��", "������");
				}//������� �� �����
				if (listitem == 1)
				{//����� �����
					new StringX[1024];
					strcat(StringX, "{AFAFAF}���� �0\n{FFFF99}���� �1\n{FFFF00}���� �2\n{FF99FF}���� �3\n{FF9999}���� �4\n{FFCC00}���� �5\n{FF66CC}���� �6\n{FF6600}���� �7\n{FF00FF}���� �8\n{CCFFFF}���� �9\n{00A0C1}���� �10\n");
					strcat(StringX, "{E5004F}���� �11\n{CCFF00}���� �12\n{CC66FF}���� �13\n{CC3366}���� �14\n{CC6600}���� �15\n{9999FF}���� �16\n{9925FF}���� �17\n{99CCCC}���� �18\n{99FF66}���� �19\n{99FF00}���� �20\n");
					strcat(StringX, "{993300}���� �21\n{990066}���� �22\n{66FFFF}���� �23\n{6666FF}���� �24\n{EB6100}���� �25\n{666633}���� �26\n{33FFFF}���� �27\n{3399FF}���� �28\n{33CC99}���� �29\n{33FF66}���� �30\n");
					strcat(StringX, "{339900}���� �31\n{457EFF}���� �32\n{FFCC00}���� �33\n{976D3D}���� �34\n{FF8800}���� �35\n{FF6666}���� �36\n{0015FF}���� �37\n{DDAA00}���� �38\n{FFFFFF}���� �39\n{FF8000}���� �40");
					ShowPlayerDialog(playerid, DIALOG_CLANCOLOR, 2, "�������� ���� �����", StringX, "�������", "������");
				}//����� �����
				if (listitem == 2)
				{//��������� �����
				    ShowPlayerDialog(playerid, DIALOG_CLANMESSAGE, 1, "��������� �����", "{008E00}������� ���������, ������� ����� ������������ ������� ��� ����� �� ������.\n������� '{FF0000}�����{008E00}'(�������� �������), ����� ������ ���������.", "��", "������");
				}//��������� �����
				if (listitem == 3)
				{//������������� ����
				    ShowPlayerDialog(playerid, DIALOG_CLANRENAME, 1, "������� �������� �����", "{FFFFFF}������� �������� �����.\n{008E00}[����� �� 2 �� 20 ��������]", "��", "������");
				}//������������� ����
				if (listitem == 4)
				{//�������� �� ��������� �����
				    new clanid = Player[playerid][MyClan], targetclan = Clan[clanid][cEnemyClan], String[140];
				    if (targetclan == 0) return SendClientMessage(playerid, COLOR_RED, "������: �� �� ��������� ������ �����.");
				    format(String, sizeof String, "{008E00}���� {FFFFFF}%s{008E00}[ID:%d] ������� � ��������� ���������� ����� � ������ {FFFFFF}%s{008E00}[ID:%d].", Clan[clanid][cName], clanid, Clan[targetclan][cName], targetclan);
				    Clan[clanid][cEnemyClan] = 0; SaveClan(clanid); return SendClientMessageToAll(-1, String);
				}//�������� �� ��������� �����
				if (listitem == 5)
				{//���������� ����
					ShowPlayerDialog(playerid, DIALOG_CLANDESTROY, 0, "{FF0000}���������� ����", "�� �������, ��� ������ {FF0000}���������� ����?", "��", "������");
				}//���������� ����
				if (listitem == 6)//���������� ���� (������ �� ������, ���������)
					ShowPlayerDialog(playerid, DIALOG_CLANMANAGER, 2, "���������� ������", "{FFFFFF}������� ������ �� �����\n�������� ���� �����\n�������� ��������� ����� ��� ����� � ����\n������������� ����\n{AFAFAF}�������� �� ��������� �����\n{FF0000}[���������� ����]\n/---{008E00} ���������� ���� {FFFFFF}---/\n������� ���� �����\n����� ��������� �������\n����� ��������� � ��������� �������", "��", "������");
				if (listitem == 7)
				{//������� ����
					ClanFunks[playerid] = 0;
					ShowPlayerDialog(playerid, DIALOG_CLANENTERNAME, 1, "���������� ����", "{FFFFFF}������� ������� ����� �����, �������� ������\n���������� ������ '{008E00}������� ���� �����{FFFFFF}'", "��", "������");
				}//������� ����
				if (listitem == 8)
				{//����� ���������
					ClanFunks[playerid] = 1;
					ShowPlayerDialog(playerid, DIALOG_CLANENTERNAME, 1, "���������� ����", "{FFFFFF}������� ������� ����� �����, �������� ������\n���������� ������ '{008E00}����� ��������� �������{FFFFFF}'", "��", "������");
				}//����� ���������
				if (listitem == 9)
				{//����� ��������� � �������
					ClanFunks[playerid] = 2;
					ShowPlayerDialog(playerid, DIALOG_CLANENTERNAME, 1, "���������� ����", "{FFFFFF}������� ������� ����� �����, �������� ������ \n���������� ������ '{008E00}����� ��������� � ��������� �������{FFFFFF}'", "��", "������");
				}//����� ��������� � �������
			}//�������
		}//���������� ������

	case DIALOG_CLANENTERNAME:
		{//������� ���
			if(response)
			{//�������
			    if (strlen(inputtext) < 3 || strlen(inputtext) > 24) return SendClientMessage(playerid, COLOR_RED, "������: �������� ����� ��������");
				new filename[MAX_FILE_NAME], file, clanid = Player[playerid][MyClan], PlayerFind = 0;
				if(!strcmp(Clan[clanid][cMember1], inputtext, true)) {PlayerFind = 1; if(ClanFunks[playerid] == -1) strmid(Clan[clanid][cMember1], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);}
				if(!strcmp(Clan[clanid][cMember2], inputtext, true)) {PlayerFind = 2; if(ClanFunks[playerid] == -1) strmid(Clan[clanid][cMember2], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);}
				if(!strcmp(Clan[clanid][cMember3], inputtext, true)) {PlayerFind = 3; if(ClanFunks[playerid] == -1) strmid(Clan[clanid][cMember3], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);}
				if(!strcmp(Clan[clanid][cMember4], inputtext, true)) {PlayerFind = 4; if(ClanFunks[playerid] == -1) strmid(Clan[clanid][cMember4], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);}
				if(!strcmp(Clan[clanid][cMember5], inputtext, true)) {PlayerFind = 5; if(ClanFunks[playerid] == -1) strmid(Clan[clanid][cMember5], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);}
				if(!strcmp(Clan[clanid][cMember6], inputtext, true)) {PlayerFind = 6; if(ClanFunks[playerid] == -1) strmid(Clan[clanid][cMember6], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);}
				if(!strcmp(Clan[clanid][cMember7], inputtext, true)) {PlayerFind = 7; if(ClanFunks[playerid] == -1) strmid(Clan[clanid][cMember7], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);}
				if(!strcmp(Clan[clanid][cMember8], inputtext, true)) {PlayerFind = 8; if(ClanFunks[playerid] == -1) strmid(Clan[clanid][cMember8], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);}
				if(!strcmp(Clan[clanid][cMember9], inputtext, true)) {PlayerFind = 9; if(ClanFunks[playerid] == -1) strmid(Clan[clanid][cMember9], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);}
				if(!strcmp(Clan[clanid][cMember10], inputtext, true)) {PlayerFind = 10; if(ClanFunks[playerid] == -1) strmid(Clan[clanid][cMember10], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);}
				if(!strcmp(Clan[clanid][cMember11], inputtext, true)) {PlayerFind = 11; if(ClanFunks[playerid] == -1) strmid(Clan[clanid][cMember11], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);}
				if(!strcmp(Clan[clanid][cMember12], inputtext, true)) {PlayerFind = 12; if(ClanFunks[playerid] == -1) strmid(Clan[clanid][cMember12], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);}
				if(!strcmp(Clan[clanid][cMember13], inputtext, true)) {PlayerFind = 13; if(ClanFunks[playerid] == -1) strmid(Clan[clanid][cMember13], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);}
				if(!strcmp(Clan[clanid][cMember14], inputtext, true)) {PlayerFind = 14; if(ClanFunks[playerid] == -1) strmid(Clan[clanid][cMember14], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);}
				if(!strcmp(Clan[clanid][cMember15], inputtext, true)) {PlayerFind = 15; if(ClanFunks[playerid] == -1) strmid(Clan[clanid][cMember15], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);}
				if(!strcmp(Clan[clanid][cMember16], inputtext, true)) {PlayerFind = 16; if(ClanFunks[playerid] == -1) strmid(Clan[clanid][cMember16], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);}
				if(!strcmp(Clan[clanid][cMember17], inputtext, true)) {PlayerFind = 17; if(ClanFunks[playerid] == -1) strmid(Clan[clanid][cMember17], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);}
				if(!strcmp(Clan[clanid][cMember18], inputtext, true)) {PlayerFind = 18; if(ClanFunks[playerid] == -1) strmid(Clan[clanid][cMember18], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);}
				if(!strcmp(Clan[clanid][cMember19], inputtext, true)) {PlayerFind = 19; if(ClanFunks[playerid] == -1) strmid(Clan[clanid][cMember19], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);}
				if(!strcmp(Clan[clanid][cMember20], inputtext, true)) {PlayerFind = 20; if(ClanFunks[playerid] == -1) strmid(Clan[clanid][cMember20], "�����", 0, strlen("�����"), MAX_PLAYER_NAME);}

				if (PlayerFind == 0){SendClientMessage(playerid,COLOR_RED,"������: ����� � ����� ����� �� ������.");return 1;}
				if (ClanFunks[playerid] == -1)
				{//���������� �� �����
					new FindName[24];new SendOnce = 0;
					foreach(Player, cid)
					{//����
						GetPlayerName(cid, FindName, sizeof(FindName));
						if (Player[cid][MyClan] == Player[playerid][MyClan] && !strcmp(inputtext, FindName, true))
						{//����������� ����� ������
							Player[cid][Member] = 0;Player[cid][Leader] = 0;Player[cid][MyClan] = 0;PlayerColor[cid] = 0;
							SendClientMessage(cid,COLOR_RED,"��� ��������� �� �����");SavePlayer(cid);
						}//����������� ����� ������
						format(filename, sizeof(filename), "accounts/%s.ini", inputtext);
						file = ini_openFile(filename);
						ini_setInteger(file,"MyClan", 0);
						ini_setInteger(file,"Leader", 0);
						ini_setInteger(file,"Member", 0);
						ini_closeFile(file);
						if (SendOnce == 0){SendClientMessage(playerid,COLOR_YELLOW,"����� �������� �� �����");SendOnce = 1;}
					}//����
				}//���������� �� �����
				if (ClanFunks[playerid] == 0)
				{//������� ���� �����
					new FindName[24];new SendOnce = 0;
					foreach(Player, cid)
					{//����
						GetPlayerName(cid, FindName, sizeof(FindName));
						if (Player[cid][MyClan] == Player[playerid][MyClan] && !strcmp(inputtext, FindName, true))
						{//����������� ����� ������
							Player[cid][Leader] = 0;SendClientMessage(cid,COLOR_YELLOW,"������ �� ������� ���� �����");SavePlayer(cid);
						}//����������� ����� ������
						format(filename, sizeof(filename), "accounts/%s.ini", inputtext);
						file = ini_openFile(filename);
						ini_setInteger(file,"Leader", 0);
						ini_closeFile(file);
						if (SendOnce != 1){SendClientMessage(playerid,COLOR_YELLOW,"�� ������� �������� ������ ������.");SendOnce = 1;}
					}//����
				}//������� ���� �����
				if (ClanFunks[playerid] == 1)
				{//����� ���������� � ����
					new FindName[24];new SendOnce = 0;
					foreach(Player, cid)
					{//����
						GetPlayerName(cid, FindName, sizeof(FindName));
						if (Player[cid][MyClan] == Player[playerid][MyClan] && !strcmp(inputtext, FindName, true))
						{//����������� ����� ������
							Player[cid][Leader] = 1;SendClientMessage(cid,COLOR_YELLOW,"������ �� ������ ��������� ������� � ����");SavePlayer(cid);
						}//����������� ����� ������
						format(filename, sizeof(filename), "accounts/%s.ini", inputtext);
						file = ini_openFile(filename);
						ini_setInteger(file,"Leader", 1);
						ini_closeFile(file);
						if (SendOnce == 0){SendClientMessage(playerid,COLOR_YELLOW,"�� ������� �������� ������ ������.");SendOnce = 1;}
					}//����
				}//����� ���������� � ����
				if (ClanFunks[playerid] == 2)
				{//����� ���������� � ���� � ������� �� ����
					new FindName[24];new SendOnce = 0;
					foreach(Player, cid)
					{//����
						GetPlayerName(cid, FindName, sizeof(FindName));
						if (Player[cid][MyClan] == Player[playerid][MyClan] && !strcmp(inputtext, FindName, true))
						{//����������� ����� ������
							Player[cid][Leader] = 2;SendClientMessage(cid,COLOR_YELLOW,"������ �� ������ ��������� ������� � ���� � ��������� �� ����");SavePlayer(cid);
						}//����������� ����� ������
						format(filename, sizeof(filename), "accounts/%s.ini", inputtext);
						file = ini_openFile(filename);
						ini_setInteger(file,"Leader", 2);
						ini_closeFile(file);
						if (SendOnce == 0){SendClientMessage(playerid,COLOR_YELLOW,"�� ������� �������� ������ ������.");SendOnce = 1;}
					}//����
				}//����� ���������� � ���� � ������� �� ����
				SaveClan(clanid);
			}//�������
		}//������� ���

	case DIALOG_CLANCOLOR:
		{//����� �����
			if(response)
			{//��
			    PlayerColor[playerid] = listitem;
				foreach(Player, cid)
				{//����
					if (Player[cid][Member] != 0 && Player[cid][MyClan] == Player[playerid][MyClan])
					{
						SendClientMessage(cid, ClanColor[listitem], "���� ����� ��� �������.");
						PlayerColor[cid] = PlayerColor[playerid];
					}
				}//����
				new clanid = Player[playerid][MyClan]; Clan[clanid][cColor] = listitem; SaveClan(clanid);
			}//��
		}//����� �����

	case DIALOG_CLANDESTROY:
		{//���������� ����
			if(response)
			{//��
				new StringX[120], filename[MAX_FILE_NAME], clanid = Player[playerid][MyClan], bbase = Clan[clanid][cBase];
				format(StringX,sizeof(StringX),"���� '{FFFFFF}%s{008E00}' ��� ��������.",Clan[clanid][cName]);
				SendClientMessageToAll(COLOR_CLAN,StringX);
				format(filename, sizeof(filename), "Clans/%d.ini", clanid);
				if (bbase > 0)
				{//� ����� ���� ����
				    Base[bbase][bPrice] -= Base[bbase][bPrice] / 100 * 15;//��� ������� ����� ���������� ����� 15% �� ��� ���������
					Player[playerid][Cash] += Base[bbase][bPrice];
					new String[80], text3d[MAX_3DTEXT];
					format(String,sizeof(String),"{008E00}�� ������� ������� ���� ���� �� {FFFFFF}%d{008E00}$",Base[bbase][bPrice]);
					SendClientMessage(playerid,COLOR_GREEN,String);
				    Base[bbase][bClan] = 0; Base[bbase][bPrice] = 10000000; SaveBase(bbase);
					format(text3d, sizeof(text3d), "{007FFF}���� ({FFFFFF}%d${007FFF})\n{008E00}����:{FFFFFF} �����\n������� [{FFFF00}Alt{FFFFFF}] ����� ������������", Base[bbase][bPrice]);
					UpdateDynamic3DTextLabelText(BaseText3D[bbase], 0xFFFFFFFF, text3d);
				}//� ����� ���� ����
				dini_Remove(filename);//�������� ����� �����
				Clan[clanid][cLevel] = 0;//����� ���� ��� �����������������
				foreach(Player, cid)
				{//����
					if (Player[cid][Member] != 0 && Player[cid][MyClan] == clanid)
					{//������
						Player[cid][MyClan] = 0;Player[cid][Member] = 0;Player[cid][Leader] = 0;
						PlayerColor[cid] = 0;SavePlayer(cid);
					}//������
				}//����

				for(new i = 0; i < MaxClanID; i++) //������� ID ����� ����� �� ������ ������ � ���� ������ (���� � ���� ����)
					if (Clan[i][cEnemyClan] == clanid) {Clan[i][cEnemyClan] = 0; SaveClan(i);}
			}//��
		}//���������� ����
		
	case DIALOG_BASEMENU:
		{//���� ������
			if(response)
			{//�������
			    if (listitem == 0)
			    {//����� � ����
		        	if (GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid, COLOR_RED, "�������� � ����� ����� ������ � ����� ������� ����!");
                    new i = LastBaseVisited[playerid];
				    if (i < 1 || i == MAX_BASE) return 1;
					if (PlayerToPoint(3.0,playerid, Base[i][bPosEnterX], Base[i][bPosEnterY], Base[i][bPosEnterZ]))
					{
					    if (Base[i][bPrice] < 20000000 && Base[i][bPrice] > 0) {SetPlayerPos(playerid, 774.0399, -78.7388, 1000.8); SetPlayerFacingAngle(playerid, 0); SetPlayerInterior(playerid, 7);}//����� ������� ����
					    else if (Base[i][bPrice] < 40000000 && Base[i][bPrice] > 0) {SetPlayerPos(playerid, 774.0266, -50.3715, 1000.8); SetPlayerFacingAngle(playerid, 0); SetPlayerInterior(playerid, 6);}//���� �� 20-39��
					    else if (Base[i][bPrice] < 60000000 && Base[i][bPrice] > 0) {SetPlayerPos(playerid, 1727.0281, -1637.9517 ,20.5); SetPlayerFacingAngle(playerid, 170); SetPlayerInterior(playerid, 18);}//���� �� 40-59��
					    else {SetPlayerPos(playerid, -2636.4778, 1402.5682, 906.4609); SetPlayerFacingAngle(playerid, 0); SetPlayerInterior(playerid, 3);}//���� �� 60+��
                        SetPlayerVirtualWorld(playerid, 2000 + i); SetCameraBehindPlayer(playerid);//��� �����
                        InPeacefulZone[playerid] = 1;
					}
			    }//����� � ����
				if (listitem == 1) SendCommand(playerid, "/baseinfo", "");
				if (listitem == 2) SendCommand(playerid, "/buybase", "");
				if (listitem == 3)
				{//������� ����
				    new baseid = LastBaseVisited[playerid];
				    if (baseid < 1 || baseid == MAX_BASE) return 1;
				    new String[180], Nalog = Base[baseid][bPrice] / 100 * 15;
				    format(String, sizeof String, "{FFFFFF}�� �������, ��� ������ ������� ����?\n\n���� ����� ��� �������: {008D00}%d$\n{FFFFFF}���� ����� ��� �������: {E60020}%d$", Base[baseid][bPrice], Base[baseid][bPrice] - Nalog);
				    return ShowPlayerDialog(playerid, DIALOG_SELLBASE, 0, "������� ����", String, "{FF0000}�������", "������");
				}//������� ����
				if (listitem == 4)
				{//��������� ���� �����
				    if (Player[playerid][MyClan] == 0)return SendClientMessage(playerid, COLOR_RED, "������: �� �� � �����");
	   				new clanid = Player[playerid][MyClan];
                    for(new i = 1; i < MAX_BASE; i++) if(PlayerToPoint(3.0,playerid, Base[i][bPosEnterX], Base[i][bPosEnterY], Base[i][bPosEnterZ]))
					{
					    if (Base[i][bClan] != clanid) return SendClientMessage(playerid, COLOR_RED, "������: ��� �� ��� ����");
                        return ShowPlayerDialog(playerid, DIALOG_BASEMENUPRICE, 1, "�������� ����", "{FFFF00}�������� ����� �������� � ����������� �� ��� ���������:{FFFFFF}\n� ����� 20 000 000$\n� 20 000 000$\n� 40 000 000$\n� 60 000 000$\n\n{FFFF00}�� ������� �� ������ �������� ���� �����?", "��", "�����");
                    }
				}//��������� ���� �����
				if (listitem == 5)
				{//����� ������� �����
				    if (Player[playerid][MyClan] == 0) return SendClientMessage(playerid,COLOR_RED,"������: �� �� � �����");
					new clanid = Player[playerid][MyClan];
					if(Clan[clanid][cBase] < 1 || Clan[clanid][cBase] > MAX_BASE) return SendClientMessage(playerid,COLOR_RED,"������: � ������ ����� ��� �����");
    				Player[playerid][Spawn] = 5;
					SendClientMessage(playerid,COLOR_YELLOW,"����� ������ �������� �������� �� {FFFFFF}���� ����� (�������)");
				}//����� ������� �����
				if (listitem == 6)
				{//����� ������ �����
				    if (Player[playerid][MyClan] == 0) return SendClientMessage(playerid,COLOR_RED,"������: �� �� � �����");
					new clanid = Player[playerid][MyClan];
					if(Clan[clanid][cBase] < 1 || Clan[clanid][cBase] > MAX_BASE) return SendClientMessage(playerid,COLOR_RED,"������: � ������ ����� ��� �����");
    				Player[playerid][Spawn] = 8; Player[playerid][SpawnStyle] = 0;
					return SendClientMessage(playerid,COLOR_YELLOW,"����� ������ �������� �������� �� {FFFFFF}���� ����� (������)");
				}//����� ������ �����
			}//�������
		}//���� ������
		
 	case DIALOG_INVISIBLE:
		{//������ �����
			if(response)
			{//�������
			    if(listitem == 0)
			    {//���
			        Player[playerid][Invisible] = 0;
			        SendClientMessage(playerid,COLOR_YELLOW,"����������� ���������.");
			    }//���
			    if(listitem == 1)
			    {//�� ������
			        if (Player[playerid][Level] < 70) return SendClientMessage(playerid,COLOR_RED,"������: �� ������ ���� ��� ������� 70-�� ������.");
                   	if (Player[playerid][Karma] <= -400) return SendClientMessage(playerid,COLOR_RED,"������: ����������� ���������� ��-�� ������ �����.");
					Player[playerid][Invisible] = 1;
					SendClientMessage(playerid,COLOR_YELLOW,"�������� ����������� �� ������.");
			    }//�� ������
			}//�������
		}//������ �����
		
	case DIALOG_AIRPORT:
		{//��������
		    if(response)
			{//�������
			    if (Player[playerid][Banned] != 0) return 1;//���������� �� �������
			    if (InEvent[playerid] > 0) return SendClientMessage(playerid, COLOR_RED, "������: ������ ������������ �������� � �������������");//����� ��� ������� ������� �� ������ ������������, � ����� �� ����� ������������ ������������ ��������
			    if(listitem == 0)
			    {//LS
			        if (IsPlayerInRangeOfPoint(playerid,3,1451.6349,-2287.0703,13.5469)) return SendClientMessage(playerid,COLOR_RED,"������: �� ���� � ��� �������");
			        if (Player[playerid][Cash] < 50000) return SendClientMessage(playerid,COLOR_RED,"������: ��� ����� 50 000$ ��� ������� ������");
			        AirportTime[playerid] = 15; AirportID[playerid] = 1;Player[playerid][Cash] -= 50000;
			        SendClientMessage(playerid,COLOR_YELLOW,"�� ������ � ��� ������� ����� 15 ������.");SetPlayerVirtualWorld(playerid,playerid + 1);
			        SetPlayerInterior(playerid,1);SetPlayerPos(playerid,1.5491, 23.3183, 1199.5938);SetPlayerFacingAngle(playerid,0.0);SetCameraBehindPlayer(playerid);
			    }//LS
			    if(listitem == 1)
			    {//SF
			        if (IsPlayerInRangeOfPoint(playerid,3,-1404.6575,-303.7458,14.1484)) return SendClientMessage(playerid,COLOR_RED,"������: �� ���� � ��� ������");
                    if (Player[playerid][Cash] < 50000) return SendClientMessage(playerid,COLOR_RED,"������: ��� ����� 50 000$ ��� ������� ������");
			        AirportTime[playerid] = 15; AirportID[playerid] = 2;Player[playerid][Cash] -= 50000;
			        SendClientMessage(playerid,COLOR_YELLOW,"�� ������ � ��� ������ ����� 15 ������.");SetPlayerVirtualWorld(playerid,playerid + 1);
			        SetPlayerInterior(playerid,1);SetPlayerPos(playerid,1.5491, 23.3183, 1199.5938);SetPlayerFacingAngle(playerid,0.0);SetCameraBehindPlayer(playerid);
			    }//SF
			    if(listitem == 2)
			    {//LV
			        if (IsPlayerInRangeOfPoint(playerid,3,1672.9861,1447.9349,10.7868)) return SendClientMessage(playerid,COLOR_RED,"������: �� ���� � ��� ���������");
                    if (Player[playerid][Cash] < 50000) return SendClientMessage(playerid,COLOR_RED,"������: ��� ����� 50 000$ ��� ������� ������");
			        AirportTime[playerid] = 15; AirportID[playerid] = 3;Player[playerid][Cash] -= 50000;
			        SendClientMessage(playerid,COLOR_YELLOW,"�� ������ � ��� ��������� ����� 15 ������.");SetPlayerVirtualWorld(playerid,playerid + 1);
			        SetPlayerInterior(playerid,1);SetPlayerPos(playerid,1.5491, 23.3183, 1199.5938);SetPlayerFacingAngle(playerid,0.0);SetCameraBehindPlayer(playerid);
			    }//LV
			}//�������
		}//��������
		
		case DIALOG_STEALCAR:
		{//StealCar
		    if (!IsPlayerInAnyVehicle(playerid) && response) return SendClientMessage(playerid, COLOR_RED, "������: �� �� � ����������!");
			else QuestCar[playerid] = GetPlayerVehicleID(playerid);

		    if (listitem == 0 || !response)
			{
				SendClientMessage(playerid, COLOR_QUEST, "�� ������ ���������! �� �������� ��� ������ �� �������� ���!");
                return SendClientMessage(playerid,COLOR_CYAN,"���������: ������� ������� {FFFFFF}Y{00CCCC} ��� {FFFFFF}N{00CCCC} ���� �� ���������� � ������ ������ ���� ���������.");
			}
		    if (listitem == 1 || listitem == 2)
		    {//������� ����
		        if (StealCarModel[playerid] != GetVehicleModel(QuestCar[playerid])) return QuestCar[playerid] = -1;//����� ��������� ������ ����, ���� ��� � ������ ����������
		        new Price = GetVehicleMaxSpeed(QuestCar[playerid]) * 500, modelid = GetVehicleModel(QuestCar[playerid]), xmodel = modelid - 400, String[120];
		        if (Player[playerid][Cash] < Price)
		        {
					format(String,sizeof(String),"{AFAFAF}���������: {FFCC00}%s{AFAFAF} ���������: %d$",PlayerVehicleName[xmodel], Price);
			        ShowPlayerDialog(playerid, DIALOG_STEALCAR, 2, String, "{FFCC00}������ ���������{FFFFFF}\n������� ������ ����������� {007FFF}1{FFFFFF}-�� ������\n������� ������ ����������� {007FFF}2{FFFFFF}-�� ������\n{FF0000}�������� ���������", "������", "������");
					return SendClientMessage(playerid, COLOR_RED, "������: � ��� ������������ ����� ��� ������� ����� ����������!");
				}
				Player[playerid][Cash] -= Price;
				new col1, col2; GetVehicleColor(QuestCar[playerid], col1, col2);
				if (listitem == 1) {Player[playerid][CarSlot1] = modelid; Player[playerid][CarSlot1Color1] = col1; Player[playerid][CarSlot1Color2] = col2; ResetTuneClass1(playerid);}
				if (listitem == 2) {Player[playerid][CarSlot2] = modelid; Player[playerid][CarSlot2Color1] = col1; Player[playerid][CarSlot2Color2] = col2; ResetTuneClass2(playerid);}
				format(String,sizeof(String),"��� ����� ���������� %d-�� ������ - %s", listitem, PlayerVehicleName[xmodel]); SendClientMessage(playerid,COLOR_YELLOW,String);
				format(String,sizeof(String),"�� ��������� �� ���� %d$", Price); SendClientMessage(playerid,COLOR_YELLOW,String);
                Player[playerid][CarActive] = listitem; PlayerCarID[playerid] = QuestCar[playerid]; QuestCar[playerid] = -1;
		    }//������� ����
		    if (listitem == 3) return RemovePlayerFromVehicle(playerid);//�������� ���������
		}//StealCar
		
		case DIALOG_STEALWATERCAR:
		{//StealWaterCar
		    if (!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_RED, "������: �� �� � ����������!");
			else QuestCar[playerid] = GetPlayerVehicleID(playerid);

            if (listitem == 0 || !response)
			{
				SendClientMessage(playerid, COLOR_QUEST, "�� ������ ���������! �� �������� ��� ������ �� �������� ���!");
                return SendClientMessage(playerid,COLOR_CYAN,"���������: ������� ������� {FFFFFF}Y{00CCCC} ��� {FFFFFF}N{00CCCC} ���� �� ���������� � ������ ������ ���� ���������.");
			}
			if (listitem == 1)
		    {//������� ����
		        new Price = GetVehicleMaxSpeed(QuestCar[playerid]) * 500, modelid = GetVehicleModel(QuestCar[playerid]), xmodel = modelid - 400, String[120];
		        if (Player[playerid][Cash] < Price)
		        {
					format(String,sizeof(String),"{AFAFAF}���������: {FFCC00}%s{AFAFAF} ���������: %d$",PlayerVehicleName[xmodel], Price);
			        ShowPlayerDialog(playerid, DIALOG_STEALWATERCAR, 2, String, "{FFCC00}������ ���������{FFFFFF}\n������� ������ ����������� {007FFF}3{FFFFFF}-�� ������\n{FF0000}�������� ���������", "������", "������");
					return SendClientMessage(playerid, COLOR_RED, "������: � ��� ������������ ����� ��� ������� ����� ����������!");
				}
				Player[playerid][Cash] -= Price;
				new col1, col2; GetVehicleColor(QuestCar[playerid], col1, col2);
				Player[playerid][CarSlot3] = modelid; Player[playerid][CarSlot3Color1] = col1; Player[playerid][CarSlot3Color2] = col2;
				format(String,sizeof(String),"��� ����� ���������� 3-�� ������ - %s", PlayerVehicleName[xmodel]); SendClientMessage(playerid,COLOR_YELLOW,String);
				format(String,sizeof(String),"�� ��������� �� ���� %d$", Price); SendClientMessage(playerid,COLOR_YELLOW,String);
                Player[playerid][CarActive] = 3; PlayerCarID[playerid] = QuestCar[playerid]; QuestCar[playerid] = -1;
		    }//������� ����
		    if (listitem == 2) return RemovePlayerFromVehicle(playerid);//�������� ���������
		}//StealWaterCar
		
		case DIALOG_STEALAIRCAR:
		{//StealAirCar
		    if (listitem == 0 || !response)
			{
				SendClientMessage(playerid, COLOR_QUEST, "�� ������ ���������! �� �������� ��� ������ �� �������� ���!");
                return SendClientMessage(playerid,COLOR_CYAN,"���������: ������� ������� {FFFFFF}Y{00CCCC} ��� {FFFFFF}N{00CCCC} ���� �� ���������� � ������ ������ ���� ���������.");
			}
			else QuestCar[playerid] = GetPlayerVehicleID(playerid);

		    if (listitem == 0 || !response) return SendClientMessage(playerid, COLOR_QUEST, "�� ������ ���������! �� �������� ��� ������ �� �������� ���!");
		    if (listitem == 1)
		    {//������� ����
		        new Price = GetVehicleMaxSpeed(QuestCar[playerid]) * 2000, modelid = GetVehicleModel(QuestCar[playerid]), xmodel = modelid - 400, String[120];
		        if (Player[playerid][Cash] < Price)
		        {
					format(String,sizeof(String),"{AFAFAF}���������: {FFCC00}%s{AFAFAF} ���������: %d$",PlayerVehicleName[xmodel], Price);
			        ShowPlayerDialog(playerid, DIALOG_STEALAIRCAR, 2, String, "{FFCC00}������ ���������{FFFFFF}\n������� ������ ����������� {007FFF}3{FFFFFF}-�� ������\n{FF0000}�������� ���������", "������", "������");
					return SendClientMessage(playerid, COLOR_RED, "������: � ��� ������������ ����� ��� ������� ����� ����������!");
				}
				Player[playerid][Cash] -= Price;
				new col1, col2; GetVehicleColor(QuestCar[playerid], col1, col2);
				Player[playerid][CarSlot3] = modelid; Player[playerid][CarSlot3Color1] = col1; Player[playerid][CarSlot3Color2] = col2;
				format(String,sizeof(String),"��� ����� ���������� 3-�� ������ - %s", PlayerVehicleName[xmodel]); SendClientMessage(playerid,COLOR_YELLOW,String);
				format(String,sizeof(String),"�� ��������� �� ���� %d$", Price); SendClientMessage(playerid,COLOR_YELLOW,String);
                Player[playerid][CarActive] = 3; PlayerCarID[playerid] = QuestCar[playerid]; QuestCar[playerid] = -1;
		    }//������� ����
		    if (listitem == 2) return RemovePlayerFromVehicle(playerid);//�������� ���������
		}//StealAirCar
		
		case DIALOG_GGSHOP:
		{//GGSHOP
		    if(response)
			{//response
			    if(listitem == 1)//�������� ������� ViP
			    {
			        if (Player[playerid][GameGold] < 150) return SendClientMessage(playerid,COLOR_RED,"������: � ��� ��� 150 ������");
			        if (Player[playerid][GPremium] == 20) return SendClientMessage(playerid,COLOR_RED,"������: � ��� ������������ ������� ViP");
			        Player[playerid][GameGold] -= 150.0; Player[playerid][GPremium] += 1;
					if (Player[playerid][GPremium] == 19) Player[playerid][Prestige] += 1;//������� ��������� �������� �� ViP 19
					SendClientMessage(playerid,COLOR_YELLOW,"�� �������� ��� ������� ViP �� 150 ������. ������� /vip, ����� ������ ���� ����������.");
                    new String[140]; format(String, sizeof String, "%d.%d.%d � %d:%d:%d |   SHOP: %s[%d] ������� ���� ������� ViP �� 150 ������", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid);
					WriteLog("GlobalLog", String);WriteLog("Shop", String);SavePlayer(playerid);
				}
			    if(listitem == 2)//LevelUp
			    {
			        if (Player[playerid][Level] >= 100 && Player[playerid][Prestige] < 10) return SendClientMessage(playerid,COLOR_RED,"������: �� ��� �������� ������������� ������! ��������� �� ������� (/prestige).");
                    if (Player[playerid][Level] < 30)
					{
						if (Player[playerid][GameGold] < 10) return SendClientMessage(playerid,COLOR_RED,"������: � ��� ��� 10 ������");
	       	  	    	Player[playerid][GameGold] -= 10.0; Player[playerid][Exp] += NeedXP[playerid]; PlayerLevelUp(playerid);
			        	SendClientMessage(playerid,COLOR_YELLOW,"�� �������� ���� ������� �� 10 ������");
			        	new String[140]; format(String, sizeof String, "%d.%d.%d � %d:%d:%d |   SHOP: %s[%d] ������� ���� ������� �� 10 ������", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid);
						WriteLog("GlobalLog", String);WriteLog("Shop", String);
					}
					else if (Player[playerid][Level] < 60)
					{
						if (Player[playerid][GameGold] < 15) return SendClientMessage(playerid,COLOR_RED,"������: � ��� ��� 15 ������");
	       	  	    	Player[playerid][GameGold] -= 15.0; Player[playerid][Exp] += NeedXP[playerid]; PlayerLevelUp(playerid);
			        	SendClientMessage(playerid,COLOR_YELLOW,"�� �������� ���� ������� �� 15 ������");
			        	new String[140]; format(String, sizeof String, "%d.%d.%d � %d:%d:%d |   SHOP: %s[%d] ������� ���� ������� �� 15 ������", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid);
						WriteLog("GlobalLog", String);WriteLog("Shop", String);
					}
					else
					{
                        if (Player[playerid][GameGold] < 20) return SendClientMessage(playerid,COLOR_RED,"������: � ��� ��� 20 ������");
	       	  	    	Player[playerid][GameGold] -= 20.0; Player[playerid][Exp] += NeedXP[playerid]; PlayerLevelUp(playerid);
			        	SendClientMessage(playerid,COLOR_YELLOW,"�� �������� ���� ������� �� 20 ������");
			        	new String[140]; format(String, sizeof String, "%d.%d.%d � %d:%d:%d |   SHOP: %s[%d] ������� ���� ������� �� 20 ������", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid);
						WriteLog("GlobalLog", String);WriteLog("Shop", String);
					}
				}
			    if(listitem == 3)//1 000 000$ (15GG)
			    {
			        if (Player[playerid][GameGold] < 15) return SendClientMessage(playerid,COLOR_RED,"������: � ��� ��� 15 ������");
			        Player[playerid][GameGold] -= 15.0;Player[playerid][Cash] += 1000000; SavePlayer(playerid);
			        SendClientMessage(playerid,COLOR_YELLOW,"�� ������ 1 000 000$ �� 15 ������");
			        new String[140]; format(String, sizeof String, "%d.%d.%d � %d:%d:%d |   SHOP: %s[%d] �������� 1 000 000$ �� 15 ������", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid);
					WriteLog("GlobalLog", String);WriteLog("Shop", String);
				}
			    if(listitem == 4)//+50 � ����� (10GG)
			    {
			        if (Player[playerid][Karma] >= 1000) return SendClientMessage(playerid, COLOR_RED, "������: � ��� �������� �����!");
			        if (Player[playerid][GameGold] < 10) return SendClientMessage(playerid,COLOR_RED,"������: � ��� ��� 10 ������");
			        Player[playerid][GameGold] -= 10.0;Player[playerid][Karma] += 50;
			        if (Player[playerid][Karma] > 1000) Player[playerid][Karma] = 1000;
			        SendClientMessage(playerid,COLOR_YELLOW,"�� ������ 50 ����� ����� �� 10 ������");
			        new String[140]; format(String, sizeof String, "%d.%d.%d � %d:%d:%d |   SHOP: %s[%d] ����� 50 ����� ����� �� 10 ������", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid);
					WriteLog("GlobalLog", String);WriteLog("Shop", String);SavePlayer(playerid);
				}
				if(listitem == 5)//�������� ������� ���
			    {
			        if (Player[playerid][GameGold] < 100) return SendClientMessage(playerid,COLOR_RED,"������: � ��� ��� 100 ������");
			        return ShowPlayerDialog(playerid, DIALOG_CHANGENICK, 1, "����� ����", "{FF0000}�� �������, ��� ������ ������� ���?\n{FFFFFF}��� ����������� ������� ��� ������� ������:","��","�����");
			    }
			    if(listitem == 6)//������ (50GG, 100GG ��� 250GG)
			    {
			        if (Player[playerid][Banned] == 0) return SendClientMessage(playerid,COLOR_RED,"������: �� ���� ���������");
                    if (Player[playerid][Level] < 30 && Player[playerid][Prestige] == 0)
					{
						if (Player[playerid][GameGold] < 50) return SendClientMessage(playerid,COLOR_RED,"������: � ��� ��� 50 ������");
				        Player[playerid][GameGold] -= 50.0;Player[playerid][Banned] = 0; strmid(BannedBy[playerid], "�����", 0, strlen("�����"), 5); strmid(BanReason[playerid], "�����", 0, strlen("�����"), 5);
						SavePlayer(playerid);LSpawnPlayer(playerid);
				        new pname[25], String[120];GetPlayerName(playerid,pname,sizeof(pname));format(String,sizeof(String),"{AFAFAF}SERVER: %s[%d] ����� ������ �� 50 ������",pname,playerid);
				        PlayerWeather[playerid] = -1;SendClientMessageToAll(COLOR_YELLOW,String);
				        format(String, sizeof String, "%d.%d.%d � %d:%d:%d |   SHOP: %s[%d] �������� ������ �� 50 ������", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid);
						WriteLog("GlobalLog", String);WriteLog("Shop", String);
			        }
					else if (Player[playerid][Level] < 60 && Player[playerid][Prestige] == 0)
					{
						if (Player[playerid][GameGold] < 100) return SendClientMessage(playerid,COLOR_RED,"������: � ��� ��� 100 ������");
				        Player[playerid][GameGold] -= 100.0;Player[playerid][Banned] = 0; strmid(BannedBy[playerid], "�����", 0, strlen("�����"), 5); strmid(BanReason[playerid], "�����", 0, strlen("�����"), 5);
						SavePlayer(playerid);LSpawnPlayer(playerid);
				        new pname[25], String[120];GetPlayerName(playerid,pname,sizeof(pname));format(String,sizeof(String),"{AFAFAF}SERVER: %s[%d] ����� ������ �� 100 ������",pname,playerid);
				        PlayerWeather[playerid] = -1;SendClientMessageToAll(COLOR_YELLOW,String);
				        format(String, sizeof String, "%d.%d.%d � %d:%d:%d |   SHOP: %s[%d] �������� ������ �� 100 ������", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid);
						WriteLog("GlobalLog", String);WriteLog("Shop", String);
			        }
			        else
			        {
			            if (Player[playerid][GameGold] < 250) return SendClientMessage(playerid,COLOR_RED,"������: � ��� ��� 250 ������");
				        Player[playerid][GameGold] -= 250.0;Player[playerid][Banned] = 0; strmid(BannedBy[playerid], "�����", 0, strlen("�����"), 5); strmid(BanReason[playerid], "�����", 0, strlen("�����"), 5);
						SavePlayer(playerid);LSpawnPlayer(playerid);
				        new pname[25], String[120];GetPlayerName(playerid,pname,sizeof(pname));format(String,sizeof(String),"{AFAFAF}SERVER: %s[%d] ����� ������ �� 250 ������",pname,playerid);
				        PlayerWeather[playerid] = -1;SendClientMessageToAll(COLOR_YELLOW,String);
				        format(String, sizeof String, "%d.%d.%d � %d:%d:%d |   SHOP: %s[%d] �������� ������ �� 250 ������", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid);
						WriteLog("GlobalLog", String);WriteLog("Shop", String);
			        }
				}
							    

				if(listitem == 0)//��� ����� GG
			    {
			        new StringX[1024];
			        format(StringX,sizeof(StringX),"{FFFFFF}����������� (�������) ����� ������������� �� ��������.\n");
			        strcat(StringX, "{FFCC00}���� �� �������: {FFFFFF} 1 ����������� ����� = 1 �������� �����\n\n");
                    strcat(StringX, "{007FFF}�� �������� ��������� � �������� ��������������.");
                    strcat(StringX, "\n{FFFFFF}���������: {AFAFAF}�� �������");
                    strcat(StringX, "\n{FFFFFF}Skype: {AFAFAF}�� �������");
			        ShowPlayerDialog(playerid, 666, 0, "�������� GameGold", StringX, "��", "");
				} else return SendCommand(playerid, "/shop", "");
			}//response
		}//GGSHOP
		
		case DIALOG_SKILLS:
		{//SKILLS
		    if(response)
			{//response
			    if(listitem == 0)//RegenHP
			    {
			        if (Player[playerid][SkillHP] >= 50) return SendClientMessage(playerid,COLOR_RED,"������: �� ��� ��������� ���� ����� �� ���������.");
			        if (Player[playerid][Cash] < 1000000) return SendClientMessage(playerid,COLOR_RED,"������: ��� ����� 1 000 000$ ����� ��������� ���� �����.");
			        Player[playerid][Cash] -= 1000000;Player[playerid][SkillHP] += 1;
			        SendClientMessage(playerid,COLOR_YELLOW,"�� ������� �������� ������� ������ <<{FFFFFF}����������� HP{FFFF00}>>.");
			        SendClientMessage(playerid,COLOR_CYAN,"���������: ��� ���� ������� ����� ������, ��� ������� ����������������� ��������.");
			    }
			    if(listitem == 1)//Repair
			    {
			        if (Player[playerid][SkillRepair] >= 30) return SendClientMessage(playerid,COLOR_RED,"������: �� ��� ��������� ���� ����� �� ���������.");
			        if (Player[playerid][Cash] < 1000000) return SendClientMessage(playerid,COLOR_RED,"������: ��� ����� 1 000 000$ ����� ��������� ���� �����.");
			        Player[playerid][Cash] -= 1000000;Player[playerid][SkillRepair] += 1;
			        SendClientMessage(playerid,COLOR_YELLOW,"�� ������� �������� ������� ������ <<{FFFFFF}������ ����������{FFFF00}>>.");
			        SendClientMessage(playerid,COLOR_CYAN,"���������: ��� ���� ������� ����� ������, ��� ���� ������������� ���������.");
			    }
			    new String[300], StringF[500];
				format(String,sizeof(String),"{FFFFFF}[{FFFF00}%d{FFFFFF}/50] ����������� HP (1 000 000$)\n[{FFFF00}%d{FFFFFF}/30] ������ ���������� (1 000 000$)",Player[playerid][SkillHP], Player[playerid][SkillRepair]);
				strcat(StringF,String);
				ShowPlayerDialog(playerid, DIALOG_SKILLS, 2, "��������� ������", StringF, "��", "");
			}//�������
		}//Skills
		
		case DIALOG_CLANENTER:
		{//�������� � ����
			if(response)
			{//�������
			    new Free = 0, clanid = InviteClan[playerid];
				if(!strcmp(Clan[clanid][cMember1], "�����", true)){Free = 1; strmid(Clan[clanid][cMember1], PlayerName[playerid], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);}
				if(!strcmp(Clan[clanid][cMember2], "�����", true)){if(Free == 0){Free = 2;strmid(Clan[clanid][cMember2], PlayerName[playerid], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);}}
				if(!strcmp(Clan[clanid][cMember3], "�����", true)){if(Free == 0){Free = 3;strmid(Clan[clanid][cMember3], PlayerName[playerid], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);}}
				if(!strcmp(Clan[clanid][cMember4], "�����", true)){if(Free == 0){Free = 4;strmid(Clan[clanid][cMember4], PlayerName[playerid], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);}}
				if(!strcmp(Clan[clanid][cMember5], "�����", true)){if(Free == 0){Free = 5;strmid(Clan[clanid][cMember5], PlayerName[playerid], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);}}
				if(!strcmp(Clan[clanid][cMember6], "�����", true)){if(Free == 0){Free = 6;strmid(Clan[clanid][cMember6], PlayerName[playerid], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);}}
				if(!strcmp(Clan[clanid][cMember7], "�����", true)){if(Free == 0){Free = 7;strmid(Clan[clanid][cMember7], PlayerName[playerid], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);}}
				if(!strcmp(Clan[clanid][cMember8], "�����", true)){if(Free == 0){Free = 8;strmid(Clan[clanid][cMember8], PlayerName[playerid], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);}}
				if(!strcmp(Clan[clanid][cMember9], "�����", true)){if(Free == 0){Free = 9;strmid(Clan[clanid][cMember9], PlayerName[playerid], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);}}
				if(!strcmp(Clan[clanid][cMember10], "�����", true)){if(Free == 0){Free = 10;strmid(Clan[clanid][cMember10], PlayerName[playerid], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);}}
				if(!strcmp(Clan[clanid][cMember11], "�����", true)){if(Free == 0){Free = 11;strmid(Clan[clanid][cMember11], PlayerName[playerid], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);}}
				if(!strcmp(Clan[clanid][cMember12], "�����", true)){if(Free == 0){Free = 12;strmid(Clan[clanid][cMember12], PlayerName[playerid], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);}}
				if(!strcmp(Clan[clanid][cMember13], "�����", true)){if(Free == 0){Free = 13;strmid(Clan[clanid][cMember13], PlayerName[playerid], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);}}
				if(!strcmp(Clan[clanid][cMember14], "�����", true)){if(Free == 0){Free = 14;strmid(Clan[clanid][cMember14], PlayerName[playerid], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);}}
				if(!strcmp(Clan[clanid][cMember15], "�����", true)){if(Free == 0){Free = 15;strmid(Clan[clanid][cMember15], PlayerName[playerid], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);}}
				if(!strcmp(Clan[clanid][cMember16], "�����", true)){if(Free == 0){Free = 16;strmid(Clan[clanid][cMember16], PlayerName[playerid], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);}}
				if(!strcmp(Clan[clanid][cMember17], "�����", true)){if(Free == 0){Free = 17;strmid(Clan[clanid][cMember17], PlayerName[playerid], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);}}
				if(!strcmp(Clan[clanid][cMember18], "�����", true)){if(Free == 0){Free = 18;strmid(Clan[clanid][cMember18], PlayerName[playerid], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);}}
				if(!strcmp(Clan[clanid][cMember19], "�����", true)){if(Free == 0){Free = 19;strmid(Clan[clanid][cMember19], PlayerName[playerid], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);}}
				if(!strcmp(Clan[clanid][cMember20], "�����", true)){if(Free == 0){Free = 20;strmid(Clan[clanid][cMember20], PlayerName[playerid], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);}}

				if (Free == 0){SendClientMessage(playerid,COLOR_RED,"������: � ����� ��� �����."); return 1;}
				Player[playerid][MyClan] = InviteClan[playerid];Player[playerid][Member] = Free;Player[playerid][Leader] = 0;
				SavePlayer(playerid); SaveClan(clanid); InviteTime[playerid] = -1;
				new StringC[140], ccolor = Clan[clanid][cColor]; PlayerColor[playerid] = ccolor;
				format(StringC,sizeof(StringC),"����� %s[%d] ������� � ����.",PlayerName[playerid],playerid);
				foreach(Player, cid)
				{//����
					if (Player[cid][MyClan] != 0 && Player[cid][MyClan] == Player[playerid][MyClan]) SendClientMessage(cid, ClanColor[ccolor], StringC);
				}
			}//�������
			else{InviteTime[playerid] = -1;}//���� ����� ��������� ��� �����, ����� ��� �� �������� ������ "��� ���������� � ����, �� �� �� ������ ������� �����������"
		}//�������� � ����
		
		case DIALOG_CLANMESSAGE:
		{//��������� �����
			if(response)
			{//�������
			    if (strlen(inputtext) < 3 || strlen(inputtext) > 120) return SendClientMessage(playerid, COLOR_RED, "������: ����� ��������� ������ ���� �� 3 �� 120 ��������");
                new clanid = Player[playerid][MyClan], ccolor = Clan[clanid][cColor];
				strmid(Clan[clanid][cMessage], inputtext, 0, strlen(inputtext), 120); SaveClan(clanid);
				if(!strcmp(inputtext, "�����", true)) return SendClientMessage(playerid,COLOR_YELLOW,"��������� ����� �������.");
				else
				{//����� ��������� �����
	 				format(inputtext, 140, "��������� �����:{FFFFFF} %s", inputtext);
					foreach(Player, cid)
					{//����
						if (Player[cid][MyClan] != 0 && Player[cid][MyClan] == Player[playerid][MyClan] && Logged[cid] == 1 ) SendClientMessage(cid, ClanColor[ccolor], inputtext);
					}
				}//����� ��������� �����
			}//�������
		}//��������� �����

		case DIALOG_SKILLCHANGE:
		{//����� �������� �������
		    if (!response) return 1;
		    if (listitem == 0)
		    {//�������� ����� ���������
		        new StringF[600];
		        strcat(StringF, "���\n");
		        strcat(StringF, "[{FFFF00}500 000${FFFFFF}] �������� �� 50 ������ (������� 1, ������� 10)\n");
		        strcat(StringF, "[{FFFF00}500 000${FFFFFF}] �������� �� 100 ������ (������� 1, ������� 20)\n");
		        strcat(StringF, "[{FFFF00}500 000${FFFFFF}] �������� �� 200 ������ (������� 1, ������� 53)\n");
		        strcat(StringF, "[{FFFF00}1 000 000${FFFFFF}] ����� ��������� (������� 8, ������� 25)");
	            ShowPlayerDialog(playerid, DIALOG_ACTIVESKILLPERSON, 2, "����� ���������", StringF, "��", "������");
		    }//�������� ����� ���������
		    else if (listitem == 1)
		    {//�������� ����� ������ 1
		        new StringF[300];
		        strcat(StringF, "���\n");
		        strcat(StringF, "[{FFFF00}500 000${FFFFFF}] �������� �� 180 �������� (������� 56)\n");
		        strcat(StringF, "[{FFFF00}500 000${FFFFFF}] ������ (������� 61)\n");
		        strcat(StringF, "[{FFFF00}500 000${FFFFFF}] �������� (������� 63)");
				ShowPlayerDialog(playerid, DIALOG_ACTIVESKILLCAR1, 2, "����� ������ 1 (������� '2')", StringF, "��", "������");
		    }//�������� ����� ������ 1
		    else if (listitem == 2)
		    {//�������� ����� ������ 2
		        new StringF[300];
		        strcat(StringF, "���\n");
		        strcat(StringF, "[{FFFF00}500 000${FFFFFF}] �������� �� 180 �������� (������� 59)\n");
		        strcat(StringF, "[{FFFF00}500 000${FFFFFF}] ������ (������� 62)\n");
		        strcat(StringF, "[{FFFF00}500 000${FFFFFF}] �������� (������� 64)");
				ShowPlayerDialog(playerid, DIALOG_ACTIVESKILLCAR2, 2, "����� ������ 2 (������� '2')", StringF, "��", "������");
		    }//�������� ����� ������ 2
		    else if (listitem == 3)
		    {//�������� H ����� ������ 1
		        new StringF[1024];
		        strcat(StringF, "���\n");
		        strcat(StringF, "[{FFFF00}500 000${FFFFFF}] ��������� ���������� �� ������ (������� 51)\n");
		        strcat(StringF, "[{FFFF00}500 000${FFFFFF}] �������� �� 50 ������ (������� 1, ������� 35)\n");
		        strcat(StringF, "[{FFFF00}500 000${FFFFFF}] �������� �� 100 ������ (������� 1, ������� 40)\n");
		        strcat(StringF, "[{FFFF00}500 000${FFFFFF}] �������� �� 200 ������ (������� 1, ������� 45)\n");
		        strcat(StringF, "[{FFFF00}1 000 000${FFFFFF}] �������� �� 50 ������ c� ��������� (������� 1, ������� 55)\n");
		        strcat(StringF, "[{FFFF00}1 000 000${FFFFFF}] �������� �� 100 ������ c� ��������� (������� 1, ������� 60)\n");
		        strcat(StringF, "[{FFFF00}1 000 000${FFFFFF}] �������� �� 200 ������ c� ��������� (������� 1, ������� 65)\n");
		        strcat(StringF, "[{FFFF00}1 000 000${FFFFFF}] ����� ������ (������� 2, ������� 25)\n");
				ShowPlayerDialog(playerid, DIALOG_ACTIVESKILLHCAR1, 2, "����� ������ 1 (������� 'H')", StringF, "��", "������");
		    }//�������� ����� ������ 1
		    else if (listitem == 4)
		    {//�������� H ����� ������ 2
		        new StringF[1024];
		        strcat(StringF, "���\n");
		        strcat(StringF, "[{FFFF00}500 000${FFFFFF}] ��������� ���������� �� ������ (������� 51)\n");
		        strcat(StringF, "[{FFFF00}500 000${FFFFFF}] �������� �� 50 ������ (������� 1, ������� 35)\n");
		        strcat(StringF, "[{FFFF00}500 000${FFFFFF}] �������� �� 100 ������ (������� 1, ������� 40)\n");
		        strcat(StringF, "[{FFFF00}500 000${FFFFFF}] �������� �� 200 ������ (������� 1, ������� 45)\n");
		        strcat(StringF, "[{FFFF00}1 000 000${FFFFFF}] �������� �� 50 ������ c� ��������� (������� 1, ������� 55)\n");
		        strcat(StringF, "[{FFFF00}1 000 000${FFFFFF}] �������� �� 100 ������ c� ��������� (������� 1, ������� 60)\n");
		        strcat(StringF, "[{FFFF00}1 000 000${FFFFFF}] �������� �� 200 ������ c� ��������� (������� 1, ������� 65)\n");
		        strcat(StringF, "[{FFFF00}1 000 000${FFFFFF}] ����� ������ (������� 2, ������� 25)\n");
				ShowPlayerDialog(playerid, DIALOG_ACTIVESKILLHCAR2, 2, "����� ������ 2 (������� 'H')", StringF, "��", "������");
		    }//�������� ����� ������ 2
		    else if (listitem == 5)
		    {//��������� ������
		      	new String[300], StringF[500];
				format(String,sizeof(String),"{FFFFFF}[{FFFF00}%d{FFFFFF}/50] ����������� HP (1 000 000$)\n[{FFFF00}%d{FFFFFF}/30] ������ ���������� (1 000 000$)",Player[playerid][SkillHP], Player[playerid][SkillRepair]);
				strcat(StringF,String);
				ShowPlayerDialog(playerid, DIALOG_SKILLS, 2, "��������� ������", StringF, "��", "������");
		    }//��������� ������
		    return 1;
		}//����� �������� �������
		
		case DIALOG_ACTIVESKILLPERSON:
		{//����� ������ ���������
		    if (!response) return 1;
		    if (listitem == Player[playerid][ActiveSkillPerson]) return 1; //����� ������ �����, ������� ���� ��� ������
			if (listitem == 0) {Player[playerid][ActiveSkillPerson] = 0; return 1;}//������ �����
			if (listitem == 1)
		    {//�� �� 50 ������
		        if (Player[playerid][Prestige] < 1) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 1-�� ������ ��������!");
		        if (Player[playerid][Level] < 10) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 10-�� ������!");
		        if (Player[playerid][Cash] < 500000) return SendClientMessage(playerid, COLOR_RED, "������: ��� ����� 500 000$ ����� ������� ���� �����!");
		        Player[playerid][Cash] -= 500000; Player[playerid][ActiveSkillPerson] = listitem;
		        if (OnFly[playerid] == 1) StopFly(playerid);
		        return SendClientMessage(playerid, COLOR_YELLOW, "��� ����� ����� ���������: {FFFFFF}�������� �� 50 ������");
		    }//�� �� 50 ������
		    if (listitem == 2)
		    {//�� �� 100 ������
		        if (Player[playerid][Prestige] < 1) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 1-�� ������ ��������!");
		        if (Player[playerid][Level] < 20) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 20-�� ������!");
		        if (Player[playerid][Cash] < 500000) return SendClientMessage(playerid, COLOR_RED, "������: ��� ����� 500 000$ ����� ������� ���� �����!");
		        Player[playerid][Cash] -= 500000; Player[playerid][ActiveSkillPerson] = listitem;
		        return SendClientMessage(playerid, COLOR_YELLOW, "��� ����� ����� ���������: {FFFFFF}�������� �� 100 ������");
		    }//�� �� 100 ������
		    if (listitem == 3)
		    {//�� �� 200 ������
		        if (Player[playerid][Prestige] < 1) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 1-�� ������ ��������!");
		        if (Player[playerid][Level] < 53) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 53-�� ������!");
		        if (Player[playerid][Cash] < 500000) return SendClientMessage(playerid, COLOR_RED, "������: ��� ����� 500 000$ ����� ������� ���� �����!");
		        Player[playerid][Cash] -= 500000; Player[playerid][ActiveSkillPerson] = listitem;
                if (OnFly[playerid] == 1) StopFly(playerid);
				return SendClientMessage(playerid, COLOR_YELLOW, "��� ����� ����� ���������: {FFFFFF}�������� �� 200 ������");
		    }//�� �� 200 ������
		    if (listitem == 4)
		    {//����� ���������
		        if (Player[playerid][Prestige] < 8) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 8-�� ������ ��������!");
		        if (Player[playerid][Level] < 25) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 25-�� ������!");
		        if (Player[playerid][Cash] < 1000000) return SendClientMessage(playerid, COLOR_RED, "������: ��� ����� 1 000 000$ ����� ������� ���� �����!");
		        Player[playerid][Cash] -= 1000000; Player[playerid][ActiveSkillPerson] = listitem;
                if (OnFly[playerid] == 1) StopFly(playerid);
				return SendClientMessage(playerid, COLOR_YELLOW, "��� ����� ����� ���������: {FFFFFF}����� ���������");
		    }//����� ���������
		    return 1;
		}//����� ������ ���������
		
		case DIALOG_ACTIVESKILLCAR1:
		{//����� ������ ����� 1 (������� 2)
		    if (!response) return 1;
		    if (listitem == Player[playerid][ActiveSkillCar1]) return 1; //����� ������ �����, ������� ���� ��� ������
			if (listitem == 0) {Player[playerid][ActiveSkillCar1] = 0; return 1;}//������ �����
			if (listitem == 1)
		    {//�������� �� 180 ��������
		        if (Player[playerid][Level] < 56) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 56-�� ������!");
		        if (Player[playerid][Cash] < 500000) return SendClientMessage(playerid, COLOR_RED, "������: ��� ����� 500 000$ ����� ������� ���� �����!");
		        Player[playerid][Cash] -= 500000; Player[playerid][ActiveSkillCar1] = listitem;
		        return SendClientMessage(playerid, COLOR_YELLOW, "��� ����� ����� ������ 1 (������� '2'): {FFFFFF}�������� �� 180 ��������");
		    }//�������� �� 180 ��������
		    if (listitem == 2)
		    {//������
		        if (Player[playerid][Level] < 61) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 61-�� ������!");
		        if (Player[playerid][Cash] < 500000) return SendClientMessage(playerid, COLOR_RED, "������: ��� ����� 500 000$ ����� ������� ���� �����!");
		        Player[playerid][Cash] -= 500000; Player[playerid][ActiveSkillCar1] = listitem;
		        return SendClientMessage(playerid, COLOR_YELLOW, "��� ����� ����� ������ 1 (������� '2'): {FFFFFF}������");
		    }//������
		    if (listitem == 3)
		    {//��������
		        if (Player[playerid][Level] < 63) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 63-�� ������!");
		        if (Player[playerid][Cash] < 500000) return SendClientMessage(playerid, COLOR_RED, "������: ��� ����� 500 000$ ����� ������� ���� �����!");
		        Player[playerid][Cash] -= 500000; Player[playerid][ActiveSkillCar1] = listitem;
		        return SendClientMessage(playerid, COLOR_YELLOW, "��� ����� ����� ������ 1 (������� '2'): {FFFFFF}��������");
		    }//��������
		    return 1;
		}//����� ������ ����� 1 (������� 2)
		
		case DIALOG_ACTIVESKILLCAR2:
		{//����� ������ ����� 2 (������� 2)
		    if (!response) return 1;
		    if (listitem == Player[playerid][ActiveSkillCar2]) return 1; //����� ������ �����, ������� ���� ��� ������
			if (listitem == 0) {Player[playerid][ActiveSkillCar2] = 0; return 1;}//������ �����
			if (listitem == 1)
		    {//�������� �� 180 ��������
		        if (Player[playerid][Level] < 59) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 59-�� ������!");
		        if (Player[playerid][Cash] < 500000) return SendClientMessage(playerid, COLOR_RED, "������: ��� ����� 500 000$ ����� ������� ���� �����!");
		        Player[playerid][Cash] -= 500000; Player[playerid][ActiveSkillCar2] = listitem;
		        return SendClientMessage(playerid, COLOR_YELLOW, "��� ����� ����� ������ 2 (������� '2'): {FFFFFF}�������� �� 180 ��������");
		    }//�������� �� 180 ��������
		    if (listitem == 2)
		    {//������
		        if (Player[playerid][Level] < 62) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 62-�� ������!");
		        if (Player[playerid][Cash] < 500000) return SendClientMessage(playerid, COLOR_RED, "������: ��� ����� 500 000$ ����� ������� ���� �����!");
		        Player[playerid][Cash] -= 500000; Player[playerid][ActiveSkillCar2] = listitem;
		        return SendClientMessage(playerid, COLOR_YELLOW, "��� ����� ����� ������ 2 (������� '2'): {FFFFFF}������");
		    }//������
		    if (listitem == 3)
		    {//��������
		        if (Player[playerid][Level] < 64) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 64-�� ������!");
		        if (Player[playerid][Cash] < 500000) return SendClientMessage(playerid, COLOR_RED, "������: ��� ����� 500 000$ ����� ������� ���� �����!");
		        Player[playerid][Cash] -= 500000; Player[playerid][ActiveSkillCar2] = listitem;
		        return SendClientMessage(playerid, COLOR_YELLOW, "��� ����� ����� ������ 2 (������� '2'): {FFFFFF}��������");
		    }//��������
		    return 1;
		}//����� ������ ����� 2 (������� 2)
		
		case DIALOG_ACTIVESKILLHCAR1:
		{//����� ������ ����� 1 (������� H)
		    if (!response) return 1;
		    if (listitem == Player[playerid][ActiveSkillHCar1]) return 1; //����� ������ �����, ������� ���� ��� ������
			if (listitem == 0) {Player[playerid][ActiveSkillHCar1] = 0; return 1;}//������ �����
			if (listitem == 1)
		    {//��������� ���������� �� ������
		        if (Player[playerid][Level] < 51) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 51-�� ������!");
		        if (Player[playerid][Cash] < 500000) return SendClientMessage(playerid, COLOR_RED, "������: ��� ����� 500 000$ ����� ������� ���� �����!");
		        Player[playerid][Cash] -= 500000; Player[playerid][ActiveSkillHCar1] = listitem;
				if (OnVehFly[playerid] == 1) StopVehFly(playerid);
				return SendClientMessage(playerid, COLOR_YELLOW, "��� ����� ����� ������ 1 (������� 'H'): {FFFFFF}��������� ���������� �� ������");
		    }//��������� ���������� �� ������
		    if (listitem == 2)
		    {//�������� �� 50 ������
		        if (Player[playerid][Prestige] < 1) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 1-�� ������ ��������!");
		        if (Player[playerid][Level] < 35) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 35-�� ������!");
		        if (Player[playerid][Cash] < 500000) return SendClientMessage(playerid, COLOR_RED, "������: ��� ����� 500 000$ ����� ������� ���� �����!");
		        Player[playerid][Cash] -= 500000; Player[playerid][ActiveSkillHCar1] = listitem;
                if (OnVehFly[playerid] == 1) StopVehFly(playerid);
				return SendClientMessage(playerid, COLOR_YELLOW, "��� ����� ����� ������ 1 (������� 'H'): {FFFFFF}�������� �� 50 ������");
		    }//�������� �� 50 ������
		    if (listitem == 3)
		    {//�������� �� 100 ������
		        if (Player[playerid][Prestige] < 1) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 1-�� ������ ��������!");
		        if (Player[playerid][Level] < 40) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 40-�� ������!");
		        if (Player[playerid][Cash] < 500000) return SendClientMessage(playerid, COLOR_RED, "������: ��� ����� 500 000$ ����� ������� ���� �����!");
		        Player[playerid][Cash] -= 500000; Player[playerid][ActiveSkillHCar1] = listitem;
                if (OnVehFly[playerid] == 1) StopVehFly(playerid);
				return SendClientMessage(playerid, COLOR_YELLOW, "��� ����� ����� ������ 1 (������� 'H'): {FFFFFF}�������� �� 100 ������");
		    }//�������� �� 100 ������
		    if (listitem == 4)
		    {//�������� �� 200 ������
		        if (Player[playerid][Prestige] < 1) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 1-�� ������ ��������!");
		        if (Player[playerid][Level] < 45) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 45-�� ������!");
		        if (Player[playerid][Cash] < 500000) return SendClientMessage(playerid, COLOR_RED, "������: ��� ����� 500 000$ ����� ������� ���� �����!");
		        Player[playerid][Cash] -= 500000; Player[playerid][ActiveSkillHCar1] = listitem;
                if (OnVehFly[playerid] == 1) StopVehFly(playerid);
				return SendClientMessage(playerid, COLOR_YELLOW, "��� ����� ����� ������ 1 (������� 'H'): {FFFFFF}�������� �� 200 ������");
		    }//�������� �� 200 ������
		    if (listitem == 5)
		    {//�������� �� 50 ������ �� ���������
		        if (Player[playerid][Prestige] < 1) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 1-�� ������ ��������!");
		        if (Player[playerid][Level] < 55) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 55-�� ������!");
		        if (Player[playerid][Cash] < 1000000) return SendClientMessage(playerid, COLOR_RED, "������: ��� ����� 1 000 000$ ����� ������� ���� �����!");
		        Player[playerid][Cash] -= 1000000; Player[playerid][ActiveSkillHCar1] = listitem;
                if (OnVehFly[playerid] == 1) StopVehFly(playerid);
				return SendClientMessage(playerid, COLOR_YELLOW, "��� ����� ����� ������ 1 (������� 'H'): {FFFFFF}�������� �� 50 ������ (�� ���������)");
		    }//�������� �� 50 ������ �� ���������
		    if (listitem == 6)
		    {//�������� �� 100 ������ �� ���������
		        if (Player[playerid][Prestige] < 1) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 1-�� ������ ��������!");
		        if (Player[playerid][Level] < 60) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 60-�� ������!");
		        if (Player[playerid][Cash] < 1000000) return SendClientMessage(playerid, COLOR_RED, "������: ��� ����� 1 000 000$ ����� ������� ���� �����!");
		        Player[playerid][Cash] -= 1000000; Player[playerid][ActiveSkillHCar1] = listitem;
                if (OnVehFly[playerid] == 1) StopVehFly(playerid);
				return SendClientMessage(playerid, COLOR_YELLOW, "��� ����� ����� ������ 1 (������� 'H'): {FFFFFF}�������� �� 100 ������ (�� ���������)");
		    }//�������� �� 100 ������ �� ���������
		    if (listitem == 7)
		    {//�������� �� 200 ������ �� ���������
		        if (Player[playerid][Prestige] < 1) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 1-�� ������ ��������!");
		        if (Player[playerid][Level] < 65) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 65-�� ������!");
		        if (Player[playerid][Cash] < 1000000) return SendClientMessage(playerid, COLOR_RED, "������: ��� ����� 1 000 000$ ����� ������� ���� �����!");
		        Player[playerid][Cash] -= 1000000; Player[playerid][ActiveSkillHCar1] = listitem;
                if (OnVehFly[playerid] == 1) StopVehFly(playerid);
				return SendClientMessage(playerid, COLOR_YELLOW, "��� ����� ����� ������ 1 (������� 'H'): {FFFFFF}�������� �� 200 ������ (�� ���������)");
		    }//�������� �� 200 ������ �� ���������
		    if (listitem == 8)
		    {//����� ������
		        if (Player[playerid][Prestige] < 2) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 2-�� ������ ��������!");
		        if (Player[playerid][Level] < 25) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 25-�� ������!");
		        if (Player[playerid][Cash] < 1000000) return SendClientMessage(playerid, COLOR_RED, "������: ��� ����� 1 000 000$ ����� ������� ���� �����!");
		        Player[playerid][Cash] -= 1000000; Player[playerid][ActiveSkillHCar1] = listitem;
				return SendClientMessage(playerid, COLOR_YELLOW, "��� ����� ����� ������ 1 (������� 'H'): {FFFFFF}����� ������");
		    }//����� ������
		    return 1;
		}//����� ������ ����� 1 (������� H)
		
		case DIALOG_ACTIVESKILLHCAR2:
		{//����� ������ ����� 2 (������� H)
		    if (!response) return 1;
		    if (listitem == Player[playerid][ActiveSkillHCar2]) return 1; //����� ������ �����, ������� ���� ��� ������
			if (listitem == 0) {Player[playerid][ActiveSkillHCar2] = 0; return 1;}//������ �����
			if (listitem == 1)
		    {//��������� ���������� �� ������
		        if (Player[playerid][Level] < 51) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 51-�� ������!");
		        if (Player[playerid][Cash] < 500000) return SendClientMessage(playerid, COLOR_RED, "������: ��� ����� 500 000$ ����� ������� ���� �����!");
		        Player[playerid][Cash] -= 500000; Player[playerid][ActiveSkillHCar2] = listitem;
                if (OnVehFly[playerid] == 1) StopVehFly(playerid);
				return SendClientMessage(playerid, COLOR_YELLOW, "��� ����� ����� ������ 2 (������� 'H'): {FFFFFF}��������� ���������� �� ������");
		    }//��������� ���������� �� ������
		    if (listitem == 2)
		    {//�������� �� 50 ������
		        if (Player[playerid][Prestige] < 1) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 1-�� ������ ��������!");
		        if (Player[playerid][Level] < 35) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 35-�� ������!");
		        if (Player[playerid][Cash] < 500000) return SendClientMessage(playerid, COLOR_RED, "������: ��� ����� 500 000$ ����� ������� ���� �����!");
		        Player[playerid][Cash] -= 500000; Player[playerid][ActiveSkillHCar2] = listitem;
                if (OnVehFly[playerid] == 1) StopVehFly(playerid);
				return SendClientMessage(playerid, COLOR_YELLOW, "��� ����� ����� ������ 2 (������� 'H'): {FFFFFF}�������� �� 50 ������");
		    }//�������� �� 50 ������
		    if (listitem == 3)
		    {//�������� �� 100 ������
		        if (Player[playerid][Prestige] < 1) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 1-�� ������ ��������!");
		        if (Player[playerid][Level] < 40) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 40-�� ������!");
		        if (Player[playerid][Cash] < 500000) return SendClientMessage(playerid, COLOR_RED, "������: ��� ����� 500 000$ ����� ������� ���� �����!");
		        Player[playerid][Cash] -= 500000; Player[playerid][ActiveSkillHCar2] = listitem;
                if (OnVehFly[playerid] == 1) StopVehFly(playerid);
				return SendClientMessage(playerid, COLOR_YELLOW, "��� ����� ����� ������ 2 (������� 'H'): {FFFFFF}�������� �� 100 ������");
		    }//�������� �� 100 ������
		    if (listitem == 4)
		    {//�������� �� 200 ������
		        if (Player[playerid][Prestige] < 1) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 1-�� ������ ��������!");
		        if (Player[playerid][Level] < 45) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 45-�� ������!");
		        if (Player[playerid][Cash] < 500000) return SendClientMessage(playerid, COLOR_RED, "������: ��� ����� 500 000$ ����� ������� ���� �����!");
		        Player[playerid][Cash] -= 500000; Player[playerid][ActiveSkillHCar2] = listitem;
                if (OnVehFly[playerid] == 1) StopVehFly(playerid);
				return SendClientMessage(playerid, COLOR_YELLOW, "��� ����� ����� ������ 2 (������� 'H'): {FFFFFF}�������� �� 200 ������");
		    }//�������� �� 200 ������
		    if (listitem == 5)
		    {//�������� �� 50 ������ �� ���������
		        if (Player[playerid][Prestige] < 1) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 1-�� ������ ��������!");
		        if (Player[playerid][Level] < 55) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 55-�� ������!");
		        if (Player[playerid][Cash] < 1000000) return SendClientMessage(playerid, COLOR_RED, "������: ��� ����� 1 000 000$ ����� ������� ���� �����!");
		        Player[playerid][Cash] -= 1000000; Player[playerid][ActiveSkillHCar2] = listitem;
                if (OnVehFly[playerid] == 1) StopVehFly(playerid);
				return SendClientMessage(playerid, COLOR_YELLOW, "��� ����� ����� ������ 2 (������� 'H'): {FFFFFF}�������� �� 50 ������ (�� ���������)");
		    }//�������� �� 50 ������ �� ���������
		    if (listitem == 6)
		    {//�������� �� 100 ������ �� ���������
		        if (Player[playerid][Prestige] < 1) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 1-�� ������ ��������!");
		        if (Player[playerid][Level] < 60) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 60-�� ������!");
		        if (Player[playerid][Cash] < 1000000) return SendClientMessage(playerid, COLOR_RED, "������: ��� ����� 1 000 000$ ����� ������� ���� �����!");
		        Player[playerid][Cash] -= 1000000; Player[playerid][ActiveSkillHCar2] = listitem;
                if (OnVehFly[playerid] == 1) StopVehFly(playerid);
				return SendClientMessage(playerid, COLOR_YELLOW, "��� ����� ����� ������ 2 (������� 'H'): {FFFFFF}�������� �� 100 ������ (�� ���������)");
		    }//�������� �� 100 ������ �� ���������
		    if (listitem == 7)
		    {//�������� �� 200 ������ �� ���������
		        if (Player[playerid][Prestige] < 1) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 1-�� ������ ��������!");
		        if (Player[playerid][Level] < 65) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 65-�� ������!");
		        if (Player[playerid][Cash] < 1000000) return SendClientMessage(playerid, COLOR_RED, "������: ��� ����� 1 000 000$ ����� ������� ���� �����!");
		        Player[playerid][Cash] -= 1000000; Player[playerid][ActiveSkillHCar2] = listitem;
                if (OnVehFly[playerid] == 1) StopVehFly(playerid);
				return SendClientMessage(playerid, COLOR_YELLOW, "��� ����� ����� ������ 2 (������� 'H'): {FFFFFF}�������� �� 200 ������ (�� ���������)");
		    }//�������� �� 200 ������ �� ���������
		    if (listitem == 8)
		    {//����� ������
		        if (Player[playerid][Prestige] < 2) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 2-�� ������ ��������!");
		        if (Player[playerid][Level] < 25) return SendClientMessage(playerid, COLOR_RED, "������: �� ������ ���� ��� ������� 25-�� ������!");
		        if (Player[playerid][Cash] < 1000000) return SendClientMessage(playerid, COLOR_RED, "������: ��� ����� 1 000 000$ ����� ������� ���� �����!");
		        Player[playerid][Cash] -= 1000000; Player[playerid][ActiveSkillHCar2] = listitem;
		        return SendClientMessage(playerid, COLOR_YELLOW, "��� ����� ����� ������ 2 (������� 'H'): {FFFFFF}����� ������");
		    }//����� ������
		    return 1;
		}//����� ������ ����� 2 (������� H)
		
		case DIALOG_PAINTJOB:
		{//����� PaintJob
			if(response)
			{//�������
			    Player[playerid][CarSlot2PaintJob] = listitem;
			}//�������
			else{Player[playerid][CarSlot2PaintJob] = 0;}
  			new mid = Player[playerid][CarSlot2] - 400, String[120];format(String,sizeof(String),"��� ����� ���������� 2-�� ������ - %s (PaintJob �%d)", PlayerVehicleName[mid],Player[playerid][CarSlot2PaintJob] + 1);
			SendClientMessage(playerid,COLOR_YELLOW,String);
			SendClientMessage(playerid,COLOR_YELLOW,"�� ��������� �� ���� 100000$");
		}//����� PaintJob
		
		case DIALOG_PRESTIGE:
		{//�������
			if(response)
			{//�������
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
					new String[140];format(String,sizeof(String), "SERVER: %s[%d] ������ {FFFFFF}%d{FFFF00}-�� ������ ��������! ���������� ���!",PlayerName[playerid], playerid, Player[playerid][Prestige]);
					SendClientMessageToAll(COLOR_YELLOW, String);

					if (Player[playerid][Prestige] == 3) SendClientMessage(playerid,COLOR_YELLOW,"PRESTIGE 3: {FFFFFF}������������ ��� � ���� (������� '/chatname') ������ ��������.");
					if (Player[playerid][Prestige] == 4) SendClientMessage(playerid,COLOR_YELLOW,"PRESTIGE 4: {FFFFFF}���� ������ �������� � �������������� TurboSpeed.");
					if (Player[playerid][Prestige] == 5) SendClientMessage(playerid,COLOR_YELLOW, "{FFFF00}PRESTIGE 5: {FFFFFF}������������ � ������� ������ ��������.\n");
					if (Player[playerid][Prestige] == 6) SendClientMessage(playerid,COLOR_YELLOW,"PRESTIGE 6: ����� ������ ������ �������� (������� '/specp' � '/specoff').");
					if (Player[playerid][Prestige] == 7) SendClientMessage(playerid,COLOR_YELLOW,"PRESTIGE 7: ����� ����� ���� (������� '/mycolor') ������ ��������.");
					if (Player[playerid][Prestige] == 9) SendClientMessage(playerid,COLOR_YELLOW,"PRESTIGE 9: ������ ��� ������ ���� � ������! ������������ ������ ��������� �� 100 000 000$");
					if (Player[playerid][Prestige] == 10) SendClientMessage(playerid,COLOR_YELLOW,"PRESTIGE 10: '����� ����' (����������) ������ ��������. ����������� ������� 'Y' (������).");

				ResetTuneClass1(playerid); ResetTuneClass2(playerid);
				SavePlayer(playerid);LSpawnPlayer(playerid);
			}//�������
		}//�������
		
		case DIALOG_TUTORIAL:
		{//��������
			if (TutorialStep[playerid] == 1)
			{//��������: ����� ������
			    SendClientMessage(playerid,COLOR_YELLOW,"��������: {FFFFFF}������� {00FF00}Alt{FFFFFF} � �������� <<{FFFF00}����� � ������ [����� 1]{FFFFFF}>>");
				TutorialObject[playerid] = CreateObject(19482, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    			SetObjectMaterialText(TutorialObject[playerid], "{FFFF00}��������\n{FFFFFF}������� {00FF00}Alt", 0, OBJECT_MATERIAL_SIZE_512x512, "Tahoma", 50, 1, 0xFFFFFFFF, 0x00, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
                AttachObjectToPlayer(TutorialObject[playerid], playerid, 0, 0, 1.2, 0, 0, 270);
			}//��������: ����� ������
			if (TutorialStep[playerid] == 2)
			{//��������: ����� ���� ������ 2
			    ShowModelSelectionMenu(playerid, MenuFirstCar, "First Car");//������� ������ ����
			}//��������: ����� ���� ������ 2
            if (TutorialStep[playerid] == 3)
			{//��������: �������������
			    SendClientMessage(playerid,COLOR_YELLOW,"��������: {FFFFFF}������� {00FF00}Y{FFFFFF} ��� {00FF00}N{FFFFFF} ���� �� ������ ��� ������������� ����������.");
                TutorialObject[playerid] = CreateObject(19482, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
				SetObjectMaterialText(TutorialObject[playerid], "{FFFF00}��������\n{FFFFFF}������� {00FF00}Y{FFFFFF}/{00FF00}N", 0, OBJECT_MATERIAL_SIZE_512x512, "Tahoma", 50, 1, 0xFFFFFFFF, 0x00, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
                AttachObjectToPlayer(TutorialObject[playerid], playerid, 0, 0, 1.2, 0, 0, 270);
			}//��������: �������������
			if (TutorialStep[playerid] == 4)
			{//��������: ����� ��������
    			new String[120];
				TutorialStep[playerid] = 999;Player[playerid][HelpTime] = 45;Player[playerid][Level] = 1;
				new Lvl = Player[playerid][Level]; NeedXP[playerid] = Levels[Lvl]; //������ ���������� NeedXP
				SetVehicleVirtualWorld(GetPlayerVehicleID(playerid), 0);SetPlayerVirtualWorld(playerid, 0);
				format(String, sizeof String, "%d.%d.%d a %d:%d:%d |   %s[%d] ������ ��������.", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid);WriteLog("GlobalLog", String);
                if(TutorialObject[playerid] != -1){DestroyObject(TutorialObject[playerid]);TutorialObject[playerid] = -1;}
                LSpawnPlayer(playerid); PlayerPlaySound(playerid,1083,0.0,0.0,0.0);//���� ��������
                SendClientMessage(playerid,COLOR_YELLOW,"��������: {FFFFFF}�� ���������, ��� ����� {00FF00}Alt{FFFFFF} �� ������ ������� ���������.");
                SendClientMessage(playerid,COLOR_YELLOW,"��������: {FFFFFF}� ����� {00FF00}Y{FFFFFF} ��� {00FF00}N{FFFFFF} �� ������ ���������������� ���.");
			}//��������: ����� ��������
		}//��������
		
		case DIALOG_PRESTIGECAR:
		{
		    if (response)
		    {//response
			    if(listitem == 0)
			    {//����� 1
			        SendClientMessage(playerid,COLOR_YELLOW,"��������� 1-�� ������ ������� �������.");
			        Player[playerid][CarSlot1] = SelectedModel[playerid];ResetTuneClass1(playerid);
			    }//����� 1
			    if(listitem == 1)
			    {//����� 2
			        SendClientMessage(playerid,COLOR_YELLOW,"��������� 2-�� ������ ������� �������.");
			        Player[playerid][CarSlot2] = SelectedModel[playerid];ResetTuneClass2(playerid);
			    }//����� 2
			    if(listitem == 2)
			    {//����� ������
					if (GetPlayerInterior(playerid) != 0 || IsPlayerInRangeOfPoint(playerid, 12.0, 2311.6953,-7.4206,26.7422)) return SendClientMessage(playerid, COLOR_RED, "������ �������� ��������� � ����������!");//����� � ���������� ��� � �����
					if (GetPlayerWeapon(playerid) == 46) return SendClientMessage(playerid,COLOR_RED,"������� ������! ������ �������� ���������� � ��������� �� �����.");
					if (InEvent[playerid] > 0) return SendClientMessage(playerid,COLOR_RED,"������ �������� ������ � �������������!");
					if (QuestActive[playerid] > 0) return SendClientMessage(playerid,COLOR_RED,"������ �������� ������ ��������� �� ������!");
					if (TimeTransform[playerid] > 0){new String[120];format(String,sizeof(String),"�� �� ������ ������� ��������� ��� {FFFFFF}%d{FF0000} ������",TimeTransform[playerid]);SendClientMessage(playerid,COLOR_RED,String);return 1;}
					new Float: x, Float: y, Float: z, Float: Angle;
					GetPlayerPos(playerid,x,y,z);new wrld = GetPlayerVirtualWorld(playerid);GetPlayerFacingAngle(playerid, Angle);
					new col1 = random(240), col2 = random(240);
					PlayerCarID[playerid] = LCreateVehicle(SelectedModel[playerid], x, y, z, Angle, col1, col2, 0);
					SetVehicleVirtualWorld(PlayerCarID[playerid], wrld);PutPlayerInVehicle(playerid, PlayerCarID[playerid], 0);
					LinkVehicleToInterior(PlayerCarID[playerid],GetPlayerInterior(playerid));
			    }//����� ������
		    } else ShowModelSelectionMenu(playerid, MenuPrestigeCars, "Prestige Cars");
		}
		
		case DIALOG_HELP:
		{//help
		    if(response)
			{//�������
			    if(listitem == 0)
				{//FAQ
				    new StringX[1024];
					strcat(StringX, "��� ����� ������?\n��� ��� ������? ��� ������ �������?\n��� ������ ������ ����� �� ����� ����?\n� ���� ������� ������! ��� ������?\n");
					strcat(StringX, "\n��� �������� ������ ���������?\n��� �������� ����� ��������?\n��� ������� ��� �������� � ����?\n��� ����� '�����' � ����� ��� �����?\n��� ��������� '�������'?");
					ShowPlayerDialog(playerid, DIALOG_HELPFAQ, 2, "����� ���������� ������� (FAQ)", StringX, "��", "�����");
				}//FAQ
				if(listitem == 1){ShowPlayerDialog(playerid, DIALOG_HELPCMD, 2, "������� �������, ���", "{FFFFFF}����� ������ � ����� ������������ �������\n���� ��������� (�����, ��, ����� � �.�.)\n������ ������ ������ (��� ���������� ��������)\nViP - ���������", "��", "�����");}//CMD
                if(listitem == 2)
                {
                    new StringX[1024];
					strcat(StringX, "{FFFF00}1 {FFFFFF}- {FFFF00}20 {FFFFFF}������\n{FFFF00}21 {FFFFFF}- {FFFF00}40 {FFFFFF}������\n{FFFF00}41 {FFFFFF}- {FFFF00}60 {FFFFFF}������\n{FFFF00}61 {FFFFFF}- {FFFF00}80 {FFFFFF}������\n{FFFF00}81 {FFFFFF}- {FFFF00}100 {FFFFFF}������\n");
					strcat(StringX, "{FFFF00}������� {FFFFFF}1\n{FFFF00}������� {FFFFFF}2 - 10");
					ShowPlayerDialog(playerid, DIALOG_HELPLVL, 2, "���������� �� �������", StringX, "��", "�����");
                }
				if(listitem == 3) SendCommand(playerid, "/vip", "");
			}//�������
		}//help
		
		case DIALOG_HELPFAQ:
		{//helpfaq
		    if(response)
			{//�������
			    new StringX[1024];
			    if(listitem == 0)
			    {//��� ����� ������
			        strcat(StringX, "{FFFFFF}������� ������ �� ������� � ����� ������ �������� ���� ������ ����������. ���������� ��� ����� {FFFF00}Faggio{FFFFFF}.\n");
			        strcat(StringX, "��� ����, ����� ����� �� ����, ����������� ������ ������ (����� Alt) � �������� <<����� � ������ [����� 1]>>\n\n");
			        strcat(StringX, "� ������� ������ ����� ���� ����� ��� ����������: �� ������ �� ������ �����. ����� ����, ����� ����� �� ����� ���� ������������������\n");
			        strcat(StringX, "�� ������ ���������� � ������ ��� ������ ������ <{FFFF00}Y{FFFFFF}> � <{FFFF00}N{FFFFFF}>.");
			    }//��� ����� ������
			    if(listitem == 1)
			    {//��� ��� ������? ��� ������ �������?
			        strcat(StringX, "{FFFFFF}����� �������� ������� �������� �������� ������. � ������ ������� � ��� ����� ����� �����������, ��������� � ������.\n");
			        strcat(StringX, "��� ��������� ������ ����� ����������� � {FFFF00}�������������{FFFFFF}, ��������� {FFFF00}�������{FFFFFF} ��� ������ �� {FFFF00}������{FFFFFF}.\n");
			        strcat(StringX, "�� ��� �� ������ �������� ����, ����������� ��� ��������� ������.\n\n");
			        strcat(StringX, "    � ���������� ������ ��������� ������������ ����� �������� {FF0000}/events{FFFFFF}\n");
  			        strcat(StringX, "    � ���������� ������ ��������� ������� ����� �������� {FF0000}/quests{FFFFFF}\n");
			        strcat(StringX, "    � ����� ������, ����, ������ � ������ ������ ������� ����� ��� ������ {FF0000}/gps{FFFFFF}\n");
			    }//��� ��� ������? ��� ������ �������?
			    if(listitem == 2)
			    {//��� ������ ���� �� ����� ����
			        strcat(StringX, "{FFFFFF}��� ������ ������ <{FFFF00}Y{FFFFFF}> � <{FFFF00}N{FFFFFF}>.");
			    }//��� ������ ���� �� ����� ����
			    if(listitem == 3)
			    {//� ���� ������� ������. ��� ������?
			        strcat(StringX, "{FFFFFF}������ ������� ���� ������ � �����. ����� ��������� ���� ����� ��� ������ {FF0000}/gps{FFFFFF}.\n");
			    }//� ���� ������� ������. ��� ������?
			    if(listitem == 4)
			    {//��� ������� ����
			         strcat(StringX, "{FFFFFF}�������� ������ ��������� ����� � �������� ������.\n����������� {FFFF00}/gps{FFFFFF} ����� ����� ���.\n");
			    }//��� ������� ����
			    if(listitem == 5)
			    {//��� �������� ����� ��������
			        strcat(StringX, "{FFFFFF}����������� ����� �������� ���������� �������������, � ����������� �� ������ ������. ������� ����������� ������ � ���������, � ������ � ���������������\n");
			        strcat(StringX, "���������� ����� � ������ �� ��������. ������ ���� �� ������ ���� ��� ��� ���� � ������ ����� ���� ����, �� �� ������ ������������ ���.\n");
			        strcat(StringX, "����������� {FFFF00}/myspawn{FFFFFF} ����� ������� ���� �������� ������ ��������.");
			    }//��� �������� ����� ��������
			    if(listitem == 6)
			    {//��� ������� ��� �������� � ����
			        strcat(StringX, "{FFFFFF}��� ���������� � ���� ��� ������ ���������� ���-�� �� �����, � ���� ���� �� ��� �����. ����������, ��� �� �� ������ ���� �� � ����� �� ������, ����� ��� ��\n");
			        strcat(StringX, "������ ���������� ����� ������. ���� �� �� ���� ������ ������� ����, �� ��� ����� ���������, ��� � ��� ���� 500 000$ � ��� ������� 10-�� �������. ���� ��, �� ������\n");
			        strcat(StringX, "������� ������� {FFFF00}/clan {FFFF00} � �� ����������� �����������. ��� �� ������.");
			    }//��� ������� ��� �������� � ����
			    if(listitem == 7) return ShowKarma(playerid);
			    if(listitem == 8)
			    {//��� ��������� �������?
			        strcat(StringX, "{FFFFFF}����� �������� ������� ��� ������� ����� ����� �� ������ ����� - �� 100-�� ������, � ����� �� ������� ����������� ������ ��\n");
			        strcat(StringX, "{FFFFFF}� ������. ���� �� �������� �� ���, �� ��� ��������� �������� ��� ����� ����� ����� �����������, ������� ��� � ������� �������.");
			    }//��� ��������� �������?
			    
  			    ShowPlayerDialog(playerid, DIALOG_HELPMES, 0, "�����",StringX, "�����", "");
			}//�������
			else SendCommand(playerid, "/help", "");
		}//helpfaq
		
		//ShowPlayerDialog(playerid, DIALOG_HELPMES, 0, "������ ������ �������","", "�����", "");
		
		case DIALOG_HELPCMD:
		{//helpcmd
		    if(response)
			{//�������
			    if(listitem == 0)
				{//������ �������
					new StringX[1024];
					strcat(StringX, "{008D00}/events{FFFFFF} - ���������� ������ ���� ������������    {008D00}/quests{FFFFFF} - ���������� ������ ���� �������,\n{008D00}/dm, /derby, /zombie, /race, /xrace, /gungame{FFFFFF} - ��������� ������� ��� ������� ������������,\n");
					strcat(StringX, "{008D00}/stats{FFFFFF} - ���������� ���� ����������    {008D00}/givecash{FFFFFF} - �������� ������ ������� ������,\n{008D00}/buygun{FFFFFF} - ��������� �������    {008D00}/mygun{FFFFFF} - ����� ������� ������,\n{008D00}/gps{FFFFFF} - �������� GPS    {008D00}/radio{FFFFFF} - �������� �����");
				    ShowPlayerDialog(playerid, DIALOG_HELPMES, 0, "����� ������ � ����� ������������ �������",StringX, "�����", "");
				}//������ �������
				if(listitem == 1)
				{//���� ���������
				    new StringX[1024];
					strcat(StringX, "{FFFF00}� ���� ���� � ������ ������� ������� ����� ������ ����. �����������\n   {008D00}!{FFFFFF}�����  - ��� �������� ��������� � ��� �����,\n   {457EFF}@{FFFFFF}�����  - ��� �������� ��������� ������������� �������,\n   {CCFF00}#{FFFFFF}�����  - ��� �������� ��������� ��������� ������� (�����),\n   � {FFFF00}/pm{FFFFFF}  - ��� �������� ������ ���������.");
					ShowPlayerDialog(playerid, DIALOG_HELPMES, 0, "���� ���������",StringX, "�����", "");
				}//���� ���������
				if(listitem == 2) SendCommand(playerid, "/commands", "");//������ ������ ������
				if(listitem == 3)
				{//ViP - ���������
				    new StringX[1024];
				    strcat(StringX, "{FFFF00}��������! ��� �������� ���� ��������� � ��� ������ ���� ViP 2-�� ������ ��� ����!\n\n�� ������ ������������� ���� ����� � ����������, ��������� ���� ������, ��������� ����:\n");
                    strcat(StringX, "{FF0000}*1{FFFFFF} - �������    {3399FF}*2{FFFFFF} - �����    {00FF00}*3{FFFFFF} - �������    {FFFF00}*4{FFFFFF} - ������    {CCFF00}*5{FFFFFF} - Qiwi\n");
                    strcat(StringX, "{24F7FE}*6{FFFFFF} - Aqua    {F74AB8}*7{FFFFFF} - �������    {FFCC00}*8{FFFFFF} - ���� �������    {976D3D}*9{FFFFFF} - ����������    {FFFFFF}* - ����� (��������)\n");
                    strcat(StringX, "{FF8C00}*!1{FFFFFF} - dm    {9966CC}*!2{FFFFFF} - derby    {E60020}*!3{FFFFFF} - zombie    {007FFF}*!4{FFFFFF} - race\n");
                    strcat(StringX, "{FFD700}*!5{FFFFFF} - xrace    {FF6666}*!6{FFFFFF} - gungame    {AABBCC}*?{FFFFFF} - ��������� ����\n");
					ShowPlayerDialog(playerid, DIALOG_HELPMES, 0, "Premium - ���������",StringX, "�����", "");
				}//Premium - ���������
			}//�������
			else SendCommand(playerid, "/help", "");
		}//helpcmd
		
		case DIALOG_HELPLVL:
		{//helplvl
		    if(response)
			{//�������
			    new StringX[2048];
			    if(listitem == 0)
				{//1 - 20 ������
 					strcat(StringX, "{FFFF00}Level 2: {FFFFFF}������� /skydive ������ ��������.\n");
					strcat(StringX, "{FFFF00}Level 3: {FFFFFF}��� �������� ����� ��������� 2-�� ������.\n");
					strcat(StringX, "{FFFF00}Level 4: {FFFFFF}��� �������� ����� ������ ������.\n");
					strcat(StringX, "{FFFF00}Level 5: {FFFFFF}��� �������� ����� ��������� 1-�� ������.\n");
					strcat(StringX, "{FFFF00}Level 6: {FFFFFF}��� �������� ����� ��������� 3-�� ������.\n");
					strcat(StringX, "{FFFF00}Level 7: {FFFFFF}��� �������� ����� ��������� 3-�� ������.\n");
					strcat(StringX, "{FFFF00}Level 8: {FFFFFF}��� �������� ����� ��������� 2-�� ������ � ����� ������ ������.\n");
					strcat(StringX, "{FFFF00}Level 9: {FFFFFF}��� �������� ����� ��������� 3-�� ������ � ���������� � ��������������.\n");
					strcat(StringX, "{FFFF00}Level 10: {FFFFFF}��� �������� ����� ����� ������ - �� ���� 1-�� ������.\n");
					strcat(StringX, "{FFFF00}Level 11: {FFFFFF}��� �������� ����� ��������� 3-�� ������.\n");
					strcat(StringX, "{FFFF00}Level 12: {FFFFFF}��� �������� ����� ��������� 1-�� ������.\n");
					strcat(StringX, "{FFFF00}Level 13: {FFFFFF}��� �������� ����� ����� ������ - �� ���� 2-�� ������.\n");
					strcat(StringX, "{FFFF00}Level 14: {FFFFFF}��� �������� ����� ��������� 2-�� ������.\n");
					strcat(StringX, "{FFFF00}Level 15: {FFFFFF}��� �������� ����� ��������� 3-�� ������ � �������� ����� ������������ ������ - ��� ������.\n");
					strcat(StringX, "{FFFF00}Level 16: {FFFFFF}��� �������� ����� ��������� 1-�� ������ � ����� ������ ������.\n");
					strcat(StringX, "{FFFF00}Level 17: {FFFFFF}��� �������� ����� ��������� 3-�� ������ � ����� ������ ������.\n");
					strcat(StringX, "{FFFF00}Level 18: {FFFFFF}��� �������� ����� ������ ������.\n");
					strcat(StringX, "{FFFF00}Level 19: {FFFFFF}��� �������� ����� ��������� 3-�� ������ � ����� ������ ������.\n");
					strcat(StringX, "{FFFF00}Level 20: {FFFFFF}��� �������� ����� ��������� 1-�� ������.\n");
 				}//1 - 20 ������
				if(listitem == 1)
				{//21 - 40 ������
					strcat(StringX, "{FFFF00}Level 21: {FFFFFF}��� �������� ����� ��������� 3-�� ������.\n");
					strcat(StringX, "{FFFF00}Level 22: {FFFFFF}��� �������� ����� ��������� 2-�� ������.\n");
					strcat(StringX, "{FFFF00}Level 23: {FFFFFF}��� �������� ����� ��������� 3-�� ������ � ����� ������ ������.\n");
					strcat(StringX, "{FFFF00}Level 24: {FFFFFF}��� �������� ����� ��������� 1-�� ������.\n");
					strcat(StringX, "{FFFF00}Level 25: {FFFFFF}��� �������� ����� ��������� 3-�� ������.\n");
					strcat(StringX, "{FFFF00}Level 25: {FFFFFF}������� /mytime ������ ��������  � �������� ����� ������������ ������ - ��� ��������.\n");
					strcat(StringX, "{FFFF00}Level 26: {FFFFFF}��� �������� ����� ��������� 2-�� ������.\n");
					strcat(StringX, "{FFFF00}Level 27: {FFFFFF}��� �������� ����� ������ ������.\n");
					strcat(StringX, "{FFFF00}Level 28: {FFFFFF}��� �������� ����� ��������� 1-�� ������.\n");
					strcat(StringX, "{FFFF00}Level 29: {FFFFFF}��� �������� ����� ��������� 3-�� ������.\n");
					strcat(StringX, "{FFFF00}Level 30: {FFFFFF}��� �������� ����� ��������� 2-�� ������.\n");
					strcat(StringX, "{FFFF00}Level 31: {FFFFFF}���������� ����������� ��� ���������� (������ ������) ��������� �� 140.\n");
					strcat(StringX, "{FFFF00}Level 32: {FFFFFF}��� �������� ����� ��������� 3-�� ������.\n");
					strcat(StringX, "{FFFF00}Level 33: {FFFFFF}���������� ����������� ��� ���������� (������ ������) ��������� �� 56.\n");
					strcat(StringX, "{FFFF00}Level 34: {FFFFFF}��� �������� ����� ������ ������.\n");
					strcat(StringX, "{FFFF00}Level 35: {FFFFFF}����� �2 � �������������� ������ ��������.\n");
					strcat(StringX, "{FFFF00}Level 36: {FFFFFF}��� �������� ����� ����� ����� (/style).\n");
					strcat(StringX, "{FFFF00}Level 37: {FFFFFF}���������� ����������� ��� ��������-��������� (������ ������) ��������� �� 1 000.\n");
					strcat(StringX, "{FFFF00}Level 38: {FFFFFF}��� �������� JetPack � ����� ������ '�� JetPack'.\n");
					strcat(StringX, "{FFFF00}Level 39: {FFFFFF}������������ ������ � ������ ��������� �� 100 000$.\n");
					strcat(StringX, "{FFFF00}Level 40: {FFFFFF}��� �������� ����� ������ ������.\n");
				}//21 - 40 ������
				if(listitem == 2)
				{//41 - 60 ������
					strcat(StringX, "{FFFF00}Level 41: {FFFFFF}���������� ����������� ��� ��������� (������ ������) ��������� �� 180.\n");
					strcat(StringX, "{FFFF00}Level 42: {FFFFFF}����� �5 � �������������� ������ ��������.\n");
					strcat(StringX, "{FFFF00}Level 43: {FFFFFF}���������� ������ (������ ������) ��������� �� 20.\n");
					strcat(StringX, "{FFFF00}Level 44: {FFFFFF}���������� ����������� ��� �������� (������ ������) ��������� �� 30.\n");
					strcat(StringX, "{FFFF00}Level 45: {FFFFFF}��� �������� ����� ��������� 1-�� ������.\n");
					strcat(StringX, "{FFFF00}Level 46: {FFFFFF}���������� ����������� ��� RPG (������ ������) ��������� �� 20.\n");
					strcat(StringX, "{FFFF00}Level 47: {FFFFFF}������� ��� ���������� ���������� /paint � /paintid ������ ��������.\n");
					strcat(StringX, "{FFFF00}Level 48: {FFFFFF}����� �10 � �������������� ������ ��������.\n");
					strcat(StringX, "{FFFF00}Level 49: {FFFFFF}��� �������� ����� ��������� 1-�� ������.\n");
					strcat(StringX, "{FFFF00}Level 50: {FFFFFF}��� �������� ����� ��������� 3-�� ������.\n");
					strcat(StringX, "{FFFF00}Level 51: {FFFFFF}����� '����������� ��������� �� ������' ������ ��������.\n");
					strcat(StringX, "{FFFF00}Level 52: {FFFFFF}������� ��� ����� ����� (/myskin, /myskinid) ������ ��������.\n");
					strcat(StringX, "{FFFF00}Level 53: {FFFFFF}������������ ������ � ������ ��������� �� 500 000$.\n");	
					strcat(StringX, "{FFFF00}Level 54: {FFFFFF}�������� ����� ����� ������ - �� ���� 3-�� ������.\n");
					strcat(StringX, "{FFFF00}Level 55: {FFFFFF}����������� ������ � �������������� ������ ��������.\n");
					strcat(StringX, "{FFFF00}Level 56: {FFFFFF}�������� ����� '�������� �� 180' ��� ���������� 1-�� ������.\n");
					strcat(StringX, "{FFFF00}Level 57: {FFFFFF}��� �������� ����� ��������� 1-�� ������.\n");
					strcat(StringX, "{FFFF00}Level 58: {FFFFFF}��� �������� ����� ��������� 1-�� ������.\n");
					strcat(StringX, "{FFFF00}Level 59: {FFFFFF}�������� �����  '�������� �� 180' ��� ���������� 2-�� ������.\n");
					strcat(StringX, "{FFFF00}Level 60: {FFFFFF}��� �������� ����� ������ ������.\n");
				}//41 - 60 ������
				if(listitem == 3)
				{//61 - 80 ������
					strcat(StringX, "{FFFF00}Level 61: {FFFFFF}�������� ����� '������' ��� ���������� 1-�� ������.\n");
					strcat(StringX, "{FFFF00}Level 62: {FFFFFF}�������� ����� '������' ��� ���������� 2-�� ������.\n");
					strcat(StringX, "{FFFF00}Level 63: {FFFFFF}�������� ����� '��������' ��� ���������� 1-�� ������.\n");
					strcat(StringX, "{FFFF00}Level 64: {FFFFFF}�������� ����� '��������' ��� ���������� 2-�� ������.\n");
					strcat(StringX, "{FFFF00}Level 65: {FFFFFF}����������� ����� ������ �������� � �������������� TurboSpeed.\n");
					strcat(StringX, "{FFFF00}Level 66: {FFFFFF}������������ ������ � ������ ��������� �� 1 000 000$.\n");
					strcat(StringX, "{FFFF00}Level 67: {FFFFFF}������� /myweather ������ ��������.\n");
					strcat(StringX, "{FFFF00}Level 68: {FFFFFF}��� �������� ����� ��������� 3-�� ������.\n");
					strcat(StringX, "{FFFF00}Level 69: {FFFFFF}�������� ����� ������������ ������ - ���� Chilliad.\n");
					strcat(StringX, "{FFFF00}Level 70: {FFFFFF}��� �������� ����������� �� ������ (/invisible).\n");
					strcat(StringX, "{FFFF00}Level 71: {FFFFFF}���������� ����������� ��� ���������� (������ ������) ��������� �� 210.\n");
					strcat(StringX, "{FFFF00}Level 72: {FFFFFF}���������� ����������� ��� ���������� (������ ������) ��������� �� 84.\n");
					strcat(StringX, "{FFFF00}Level 73: {FFFFFF}���������� ����������� ��� ��������-��������� (������ ������) ��������� �� 1 500.\n");
					strcat(StringX, "{FFFF00}Level 74: {FFFFFF}���������� ����������� ��� ��������� (������ ������) ��������� �� 270.\n");
					strcat(StringX, "{FFFF00}Level 75: {FFFFFF}��� �������� ����� ��������� 1-�� ������.\n");
					strcat(StringX, "{FFFF00}Level 76: {FFFFFF}���������� ������ (������ ������) ��������� �� 30.\n");
					strcat(StringX, "{FFFF00}Level 77: {FFFFFF}���������� ����������� ��� �������� (������ ������) ��������� �� 45.\n");
					strcat(StringX, "{FFFF00}Level 78: {FFFFFF}��� �������� ����� ��������� 3-�� ������.\n");
					strcat(StringX, "{FFFF00}Level 79: {FFFFFF}���������� ����������� ��� RPG (������ ������) ��������� �� 30.\n");
					strcat(StringX, "{FFFF00}Level 80: {FFFFFF}UberNitro ������ �������� � �������������� TurboSpeed.\n");
				}//61 - 80 ������
				if(listitem == 4)
				{//81 - 100 ������
					strcat(StringX, "{FFFF00}Level 81: {FFFFFF}���������� ����������� ��� �������� (������ ������) ��������� �� 2 000.\n");
					strcat(StringX, "{FFFF00}Level 82: {FFFFFF}���������� ����������� ��� ���������� (������ ������) ��������� �� 280.\n");
					strcat(StringX, "{FFFF00}Level 83: {FFFFFF}���������� ����������� ��� ���������� (������ ������) ��������� �� 112.\n");
					strcat(StringX, "{FFFF00}Level 84: {FFFFFF}���������� ����������� ��� ��������-��������� (������ ������) ��������� �� 2 000.\n");
					strcat(StringX, "{FFFF00}Level 85: {FFFFFF}��� �������� ����� ��������� 3-�� ������.\n");
					strcat(StringX, "{FFFF00}Level 86: {FFFFFF}���������� ����������� ��� ��������� (������ ������) ��������� �� 360.\n");
					strcat(StringX, "{FFFF00}Level 87: {FFFFFF}���������� ������ (������ ������) ��������� �� 40.\n");
					strcat(StringX, "{FFFF00}Level 88: {FFFFFF}���������� ����������� ��� �������� (������ ������) ��������� �� 60.\n");
					strcat(StringX, "{FFFF00}Level 89: {FFFFFF}���������� ����������� ��� RPG (������ ������) ��������� �� 40.\n");
					strcat(StringX, "{FFFF00}Level 90: {FFFFFF}��� �������� ����� ��������� 3-�� ������.\n");
					strcat(StringX, "{FFFF00}Level 91: {FFFFFF}���������� ����������� ��� �������� (������ ������) ��������� �� 3 000.\n");
					strcat(StringX, "{FFFF00}Level 92: {FFFFFF}���������� ����������� ��� ���������� (������ ������) ��������� �� 20 000.\n");
					strcat(StringX, "{FFFF00}Level 93: {FFFFFF}���������� ����������� ��� ���������� (������ ������) ��������� �� 20 000.\n");
					strcat(StringX, "{FFFF00}Level 94: {FFFFFF}���������� ����������� ��� ��������-��������� (������ ������) ��������� �� 20 000.\n");
					strcat(StringX, "{FFFF00}Level 95: {FFFFFF}���������� ����������� ��� ��������� (������ ������) ��������� �� 20 000.\n");
					strcat(StringX, "{FFFF00}Level 96: {FFFFFF}���������� ������ (������ ������) ��������� �� 20 000.\n");
					strcat(StringX, "{FFFF00}Level 97: {FFFFFF}���������� ����������� ��� �������� (������ ������) ��������� �� 20 000.\n");
					strcat(StringX, "{FFFF00}Level 98: {FFFFFF}���������� ����������� ��� RPG (������ ������) ��������� �� 20 000.\n");
					strcat(StringX, "{FFFF00}Level 99: {FFFFFF}���������� ����������� ��� �������� (������ ������) ��������� �� 20 000.\n");
					strcat(StringX, "{FFFF00}Level 100: {FFFFFF}���������� ��� JetPack ������ �������� (������� 'N').\n");
                }//81 - 100 ������
				if(listitem == 5)
				{//������� 1
					strcat(StringX, "{FFFF00}Level 10 PRESTIGE 1: {FFFFFF}����� '�������� �� 50 ������' ������ ��������.\n");
					strcat(StringX, "{FFFF00}Level 20 PRESTIGE 1: {FFFFFF}����� '�������� �� 100 ������' ������ ��������.\n");
					strcat(StringX, "{FFFF00}Level 35 PRESTIGE 1: {FFFFFF}����� '�������� �� 50 ������' (��� ����������) ������ ��������.\n");
					strcat(StringX, "{FFFF00}Level 40 PRESTIGE 1: {FFFFFF}����� '�������� �� 100 ������' (��� ����������) ������ ��������.\n");
					strcat(StringX, "{FFFF00}Level 45 PRESTIGE 1: {FFFFFF}����� '�������� �� 200 ������' (��� ����������) ������ ��������.\n");
					strcat(StringX, "{FFFF00}Level 53 PRESTIGE 1: {FFFFFF}����� '�������� �� 200 ������' ������ ��������.\n");
					strcat(StringX, "{FFFF00}Level 55 PRESTIGE 1: {FFFFFF}����� '�������� �� 50 ������ (c� ���������)' (��� ����������) ������ ��������.\n");
					strcat(StringX, "{FFFF00}Level 60 PRESTIGE 1: {FFFFFF}����� '�������� �� 100 ������ (c� ���������)' (��� ����������) ������ ��������.\n");
					strcat(StringX, "{FFFF00}Level 65 PRESTIGE 1: {FFFFFF}����� '�������� �� 200 ������ (c� ���������)' (��� ����������) ������ ��������.\n");
					strcat(StringX, "{FFFF00}Level 85 PRESTIGE 1: {FFFFFF}������ �� ������ ������� ����� ��������� � ����� 1 � 2.\n");
				}//������� 1
				if(listitem == 6)
				{//������� 2+
					strcat(StringX, "{FFFF00}Level 25 PRESTIGE 2: {FFFFFF}����� '����� ������' (��� ����������) ������ ��������.\n");
					strcat(StringX, "{FFFF00}PRESTIGE 3: {FFFFFF}������������ ��� � ���� (������� '/chatname') ������ ��������.\n");
					strcat(StringX, "{FFFF00}PRESTIGE 4: {FFFFFF}���� ������ �������� � �������������� TurboSpeed.\n");
					strcat(StringX, "{FFFF00}PRESTIGE 5: {FFFFFF}������������ � ������� ������ ��������.\n");
					strcat(StringX, "{FFFF00}PRESTIGE 6: {FFFFFF}����� ������ ������ �������� (������� '/specp' � '/specoff').\n");
					strcat(StringX, "{FFFF00}PRESTIGE 7: {FFFFFF}����� ����� ���� (������� '/mycolor') ������ ��������.\n");
					strcat(StringX, "{FFFF00}Level 25 PRESTIGE 8: {FFFFFF}����� '����� C��������' ������ ��������.\n");
					strcat(StringX, "{FFFF00}PRESTIGE 9: {FFFFFF}������ ��� ������ ���� � ������! ������������ ������ ��������� �� 100 000 000$.\n");
					strcat(StringX, "{FFFF00}PRESTIGE 10: {FFFFFF}'����� ����' (����������) ������ ��������.\n");
					strcat(StringX, "{FFFF00}Level 100 PRESTIGE 10: {FFFFFF}��������! ������ �� ������ '�������������' ���� 100-�� ������!\n");
					strcat(StringX, "{FFFF00}Level 150 PRESTIGE 10: {FFFFFF}��������! ������ �� ������ ������ ������� � '������ ������'.\n");
					strcat(StringX, "{FFFF00}Level 200 PRESTIGE 10: {FFFFFF}��������! ������ �� ������ ������ ������� � '������ ���������'.\n");

				}//������� 2+
                ShowPlayerDialog(playerid, DIALOG_HELPMES, 0, "���������� �� �������",StringX, "�����", "");
			}//�������
			else SendCommand(playerid, "/help", "");
		}//helplvl
		
		case DIALOG_HELPMES: SendCommand(playerid, "/help", "");

        case DIALOG_PVP:
		{//��������� PvP
		    if(response)
			{//�������
			    if (listitem == 0)
			    {//��������� ���������
			        if (PlayerPVP[playerid][Status] > 0) return SendClientMessage(playerid,COLOR_RED,"������: ������ �������� ��������� �� ����� �����.");
      			    if (PlayerPVP[playerid][TimeOut] > 0) return SendClientMessage(playerid,COLOR_RED,"������: ������ �������� ��������� ����� ��/��� ������� �� �����.");
					PlayerPVP[playerid][Map] = random(10) + 1;//��������� �����
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
					//�������� ����������� ���������
					new String[300], zWeapon[48], zMap[30];
					GetWeaponName(PlayerPVP[playerid][Weapon],zWeapon,sizeof(zWeapon));
					if (PlayerPVP[playerid][Weapon] == 0) zWeapon = "��� ������";
					if (PlayerPVP[playerid][Map] == 1) zMap = "�����";
					if (PlayerPVP[playerid][Map] == 2) zMap = "��� ������";
					if (PlayerPVP[playerid][Map] == 3) zMap = "��� ������";
					if (PlayerPVP[playerid][Map] == 4) zMap = "������";
					if (PlayerPVP[playerid][Map] == 5) zMap = "�����";
					if (PlayerPVP[playerid][Map] == 6) zMap = "����������� ��������";
					if (PlayerPVP[playerid][Map] == 7) zMap = "��� �����";
					if (PlayerPVP[playerid][Map] == 8) zMap = "�����";
					if (PlayerPVP[playerid][Map] == 9) zMap = "�������� �������";
					if (PlayerPVP[playerid][Map] == 10) zMap = "��������";
					format(String,sizeof(String),"{457EFF}��������� ���������\n{FFFF00}�����:{FFFFFF} %s\n{FFFF00}������:{FFFFFF} %s\n{FFFF00}��������:{FFFFFF} %d",zMap,zWeapon, PlayerPVP[playerid][Health]);
					ShowPlayerDialog(playerid, DIALOG_PVP, 2, "��������� PvP", String, "��", "�����");
			    }//��������� ���������
			    if (listitem == 1)
			    {//����� �����
			        ShowPlayerDialog(playerid, DIALOG_PVPMAP, 2, "PVP - ����� �����", "�����\n��� ������\n��� ������\n������\n�����\n����������� ��������\n��� �����\n�����\n�������� �������\n��������", "��", "�����");
			    }//����� �����
			    if (listitem == 2)
			    {//����� ������
			        ShowPlayerDialog(playerid, DIALOG_PVPWEAPON, 2, "PVP - ����� ������","��� ������\n������\n���������\n9�� ��������\n9�� �������� � ����������\nDesert Eagle\n��������\n������\nSPAS12\nMicroUZI\nTec9\nMP5\nM4\nAK-47\n��������\n����������� ��������\n�������\nRPG\n�������\n������������", "��", "�����");
			    }//����� ������
			    if (listitem == 3)
			    {//����� ��������
			        ShowPlayerDialog(playerid, DIALOG_PVPHEALTH, 1, "PVP - ���������� ��������","������� ����������� ���������� �������� (�� 1 �� 200).\nPS: 100 �������� + 100 ����� = 200 (�� ���������).","��","�����");
			    }//����� ��������
			}//�������
   			else{ShowPlayerDialog(playerid, 2, 2, "���� �������� �������", "����� � ������ [����� 1]\n����� � ������ [����� 2]\n����� � ������ [����� 3]\n������ JetPack (/jetpack)\n�������� � ��������� (/skydive)\n{FF0000}GPS (/gps){FFFFFF}\n�������� ��� ����������\n�������� ��� ������\n��������� PvP\n{FFFF00}������� ���", "��", "�����");}
		}///��������� PvP

        case DIALOG_PVPMAP:
		{//����� ���
			if (PlayerPVP[playerid][Status] > 0) return SendClientMessage(playerid,COLOR_RED,"������: ������ �������� ��������� �� ����� �����.");
            if (PlayerPVP[playerid][TimeOut] > 0) return SendClientMessage(playerid,COLOR_RED,"������: ������ �������� ��������� ����� ��/��� ������� �� �����.");
		    if(response){PlayerPVP[playerid][Map] = listitem + 1;}
			new String[300], zWeapon[48], zMap[30];
			GetWeaponName(PlayerPVP[playerid][Weapon],zWeapon,sizeof(zWeapon));
			if (PlayerPVP[playerid][Weapon] == 0) zWeapon = "��� ������";
			if (PlayerPVP[playerid][Map] == 1) zMap = "�����";
			if (PlayerPVP[playerid][Map] == 2) zMap = "��� ������";
			if (PlayerPVP[playerid][Map] == 3) zMap = "��� ������";
			if (PlayerPVP[playerid][Map] == 4) zMap = "������";
			if (PlayerPVP[playerid][Map] == 5) zMap = "�����";
			if (PlayerPVP[playerid][Map] == 6) zMap = "����������� ��������";
			if (PlayerPVP[playerid][Map] == 7) zMap = "��� �����";
			if (PlayerPVP[playerid][Map] == 8) zMap = "�����";
			if (PlayerPVP[playerid][Map] == 9) zMap = "�������� �������";
			if (PlayerPVP[playerid][Map] == 10) zMap = "��������";
			format(String,sizeof(String),"{457EFF}��������� ���������\n{FFFF00}�����:{FFFFFF} %s\n{FFFF00}������:{FFFFFF} %s\n{FFFF00}��������:{FFFFFF} %d",zMap,zWeapon, PlayerPVP[playerid][Health]);
			ShowPlayerDialog(playerid, DIALOG_PVP, 2, "��������� PvP", String, "��", "�����");
		}//����� ���
		
		case DIALOG_PVPWEAPON:
		{//������ ���
			if (PlayerPVP[playerid][Status] > 0) return SendClientMessage(playerid,COLOR_RED,"������: ������ �������� ��������� �� ����� �����.");
            if (PlayerPVP[playerid][TimeOut] > 0) return SendClientMessage(playerid,COLOR_RED,"������: ������ �������� ��������� ����� ��/��� ������� �� �����.");
	        if(response)
			{
			    //��� ������, ������, 9��, 9�� ��������, ����, ������, ������, ����, ����� ���, ���9, �4, ��47
				//��������, ���������, �����, ���, �������
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
			if (PlayerPVP[playerid][Weapon] == 0) zWeapon = "��� ������";
			if (PlayerPVP[playerid][Map] == 1) zMap = "�����";
			if (PlayerPVP[playerid][Map] == 2) zMap = "��� ������";
			if (PlayerPVP[playerid][Map] == 3) zMap = "��� ������";
			if (PlayerPVP[playerid][Map] == 4) zMap = "������";
			if (PlayerPVP[playerid][Map] == 5) zMap = "�����";
			if (PlayerPVP[playerid][Map] == 6) zMap = "����������� ��������";
			if (PlayerPVP[playerid][Map] == 7) zMap = "��� �����";
			if (PlayerPVP[playerid][Map] == 8) zMap = "�����";
			if (PlayerPVP[playerid][Map] == 9) zMap = "�������� �������";
			if (PlayerPVP[playerid][Map] == 10) zMap = "��������";
			format(String,sizeof(String),"{457EFF}��������� ���������\n{FFFF00}�����:{FFFFFF} %s\n{FFFF00}������:{FFFFFF} %s\n{FFFF00}��������:{FFFFFF} %d",zMap,zWeapon, PlayerPVP[playerid][Health]);
			ShowPlayerDialog(playerid, DIALOG_PVP, 2, "��������� PvP", String, "��", "�����");
		}//������ ���
		
		case DIALOG_PVPHEALTH:
		{//�������� ���
			if (PlayerPVP[playerid][Status] > 0) return SendClientMessage(playerid,COLOR_RED,"������: ������ �������� ��������� �� ����� �����.");
            if (PlayerPVP[playerid][TimeOut] > 0) return SendClientMessage(playerid,COLOR_RED,"������: ������ �������� ��������� ����� ��/��� ������� �� �����.");
		    if(response)
			{
			    if (strval(inputtext) < 1 || strval(inputtext) > 200) SendClientMessage(playerid,COLOR_RED,"������: �������� ������� �� ����� (������ ���� �� 1 �� 200).");
			    else PlayerPVP[playerid][Health] = strval(inputtext);
			}
			new String[300], zWeapon[48], zMap[30];
			GetWeaponName(PlayerPVP[playerid][Weapon],zWeapon,sizeof(zWeapon));
			if (PlayerPVP[playerid][Weapon] == 0) zWeapon = "��� ������";
			if (PlayerPVP[playerid][Map] == 1) zMap = "�����";
			if (PlayerPVP[playerid][Map] == 2) zMap = "��� ������";
			if (PlayerPVP[playerid][Map] == 3) zMap = "��� ������";
			if (PlayerPVP[playerid][Map] == 4) zMap = "������";
			if (PlayerPVP[playerid][Map] == 5) zMap = "�����";
			if (PlayerPVP[playerid][Map] == 6) zMap = "����������� ��������";
			if (PlayerPVP[playerid][Map] == 7) zMap = "��� �����";
			if (PlayerPVP[playerid][Map] == 8) zMap = "�����";
			if (PlayerPVP[playerid][Map] == 9) zMap = "�������� �������";
			if (PlayerPVP[playerid][Map] == 10) zMap = "��������";
			format(String,sizeof(String),"{457EFF}��������� ���������\n{FFFF00}�����:{FFFFFF} %s\n{FFFF00}������:{FFFFFF} %s\n{FFFF00}��������:{FFFFFF} %d",zMap,zWeapon, PlayerPVP[playerid][Health]);
			ShowPlayerDialog(playerid, DIALOG_PVP, 2, "��������� PvP", String, "��", "�����");
		}//�������� ���

		case DIALOG_CONFIG:
		{//��������� ��������
		    if (!response) return 1;
		    if (listitem == 0)
		    {//������ ���������
		        if (Player[playerid][ConPM] == 1) {Player[playerid][ConPM] = 0;SendClientMessage(playerid,COLOR_RED,"SERVER: ������� ������ ��������� ���������.");}
				else {Player[playerid][ConPM] = 1;SendClientMessage(playerid,COLOR_CLAN,"SERVER: ������� ������ ��������� ��������.");}
		    }//������ ���������
		    if (listitem == 1)
		    {//��������� ���������� � ����
		        if (Player[playerid][ConInviteClan] == 1) {Player[playerid][ConInviteClan] = 0;SendClientMessage(playerid,COLOR_RED,"SERVER: �� ��������� ���������� ���� � ����.");}
				else {Player[playerid][ConInviteClan] = 1;SendClientMessage(playerid,COLOR_CLAN,"SERVER: �� ��������� ���������� ���� � ����.");}
		    }//��������� ���������� � ����
		    if (listitem == 2)
		    {//��������� ���������� �� PvP
		        if (Player[playerid][ConInvitePVP] == 1) {Player[playerid][ConInvitePVP] = 0;SendClientMessage(playerid,COLOR_RED,"SERVER: �� ��������� �������� ���� �� PvP.");}
				else {Player[playerid][ConInvitePVP] = 1;SendClientMessage(playerid,COLOR_CLAN,"SERVER: �� ��������� �������� ���� �� PvP.");}
		    }//��������� ���������� �� PvP
		    if (listitem == 3)
		    {//���������� ���������� PvP
		        if (Player[playerid][ConMesPVP] == 1) {Player[playerid][ConMesPVP] = 0;SendClientMessage(playerid,COLOR_RED,"SERVER: �� ��������� ����������� ��������� � ����������� PvP ������ �������.");}
				else {Player[playerid][ConMesPVP] = 1;SendClientMessage(playerid,COLOR_CLAN,"SERVER: �� �������� ����������� ��������� � ����������� PvP ������ �������.");}
		    }//���������� ���������� PvP
		    if (listitem == 4)
		    {//��������� � �����/������ �������
		        if (Player[playerid][ConMesEnterExit] == 1) {Player[playerid][ConMesEnterExit] = 0;SendClientMessage(playerid,COLOR_RED,"SERVER: �� ��������� ����������� ��������� � �����/������ ������� �� ������.");}
				else {Player[playerid][ConMesEnterExit] = 1;SendClientMessage(playerid,COLOR_CLAN,"SERVER: �� �������� ����������� ��������� � �����/������ ������� �� ������.");}
		    }//��������� � �����/������ �������
		    if (listitem == 5)
		    {//��������� � �����/������ �������
		        if (Player[playerid][ConSpeedo] == 1) {Player[playerid][ConSpeedo] = 0;SendClientMessage(playerid,COLOR_RED,"SERVER: �� ��������� ����������� ����������.");}
				else {Player[playerid][ConSpeedo] = 1;SendClientMessage(playerid,COLOR_CLAN,"SERVER: �� �������� ����������� ����������."); SpeedoUpdate(playerid);}
		    }//��������� � �����/������ �������
		
		    if (listitem != 6) SendCommand(playerid, "/config", "");//���� �� ����� "��������� � �������" - ���������� ������� ��� ���
		}//��������� ��������
		
		case DIALOG_CHANGENICK:
		{//����� ���� - ���� ������� ������ ������ ��� ������� ����� ���
		    if (!response) return SendCommand(playerid, "/shop", "");
		    if(strcmp(PlayerPass[playerid], inputtext, true)) return ShowPlayerDialog(playerid, DIALOG_CHANGENICK, 1, "����� ����", "{FF0000}�� �������, ��� ������ ������� ���?\n{FFFFFF}��� ����������� ������� ��� ������� ������:\n\n{FF0000}������ ������ �������! ��������� �������...","��","�����");
		    ShowPlayerDialog(playerid, DIALOG_CHANGENICK2, 1, "����� ����", "{008E00}�������! ������ ������� ��� ����� ������� ���:","��","������");
		}//����� ���� - ���� ������� ������ ������ ��� ������� ����� ���
		
		case DIALOG_CHANGENICK2:
		{//����� ���� - ���� ������ ����
		    if (!response) return SendClientMessage(playerid,COLOR_RED,"�� �������� ����� ����.");
		    if (Player[playerid][GameGold] < 100) return SendClientMessage(playerid,COLOR_RED,"������: � ��� ��� 100GG");
		    if(!strcmp(PlayerName[playerid], inputtext, true)) return ShowPlayerDialog(playerid, DIALOG_CHANGENICK2, 1, "����� ����", "{008E00}�������! ������ ������� ��� ����� ������� ���:\n\n{FF0000}��� ����� ��� �� ���������� �� �������!","��","������");
		    if(!strlen(inputtext) || strlen(inputtext) < 3 || strlen(inputtext) > 20) return ShowPlayerDialog(playerid, DIALOG_CHANGENICK2, 1, "����� ����", "{008E00}�������! ������ ������� ��� ����� ������� ���:\n\n{FF0000}����� ���� ������ ���� �� 3 �� 20 ��������!","��","������");
		    new AllowNick = 1, file, OldName[24], NewName[24],filename[60];
		    for (new i; i < strlen(inputtext); i++)
			{//�������� ������� ������� � ���� �� ������������
			    if (inputtext[i] >= '0' && inputtext[i] <= '9') continue;
			    if (inputtext[i] >= 'A' && inputtext[i] <= 'Z') continue;
			    if (inputtext[i] >= 'a' && inputtext[i] <= 'z') continue;
			    if (inputtext[i] == '[' || inputtext[i] == ']') continue;
			    if (inputtext[i] == '(' || inputtext[i] == ')') continue;
			    if (inputtext[i] == '.' || inputtext[i] == '_') continue;
			    AllowNick = 0;
			}//�������� ������� ������� � ���� �� ������������
			if (!AllowNick)  return ShowPlayerDialog(playerid, DIALOG_CHANGENICK2, 1, "����� ����", "{008E00}�������! ������ ������� ��� ����� ������� ���:\n\n{FF0000}��������� ���� ��� �������� ������������ �������!\n{008E00}���������� ������: {FFFFFF}A-Z, a-z, 0-9\n{008E00}� ����� �������:{FFFFFF} ( ) [ ] . _","��","������");
			format(filename,sizeof(filename),"accounts/%s.ini",inputtext);
			if(fexist(filename)) return ShowPlayerDialog(playerid, DIALOG_CHANGENICK2, 1, "����� ����", "{008E00}�������! ������ ������� ��� ����� ������� ���:\n\n{FF0000}������� � ����� ������ ��� ����������!","��","������");
            foreach(Player, cid) if(!strcmp(PlayerName[cid], inputtext, true)) return ShowPlayerDialog(playerid, DIALOG_CHANGENICK2, 1, "����� ����", "{008E00}�������! ������ ������� ��� ����� ������� ���:\n\n{FF0000}������� � ����� ������ ��� ����������!","��","������");
            strmid(NewName, inputtext, 0, strlen(inputtext), 24);strmid(OldName, PlayerName[playerid], 0, strlen(PlayerName[playerid]), 24);
            strmid(PlayerName[playerid], inputtext, 0, strlen(inputtext), 24); SetPlayerName(playerid, PlayerName[playerid]);
            strmid(ChatName[playerid], PlayerName[playerid], 0, strlen(inputtext), 24);
            //���������� ������ ��������
			file = ini_createFile(filename);
			if(file < 0) file = ini_openFile (filename);
			if(file >= 0)
			{
				ini_setString(file,"Password", PlayerPass[playerid]);
				ini_closeFile(file);
			}
			Player[playerid][GameGold] -= 100.0; SavePlayer(playerid);
			//���������� ������ ��������
			format(filename,sizeof(filename),"accounts/%s.ini",OldName);dini_Remove(filename);//�������� ������� ��������
			if (Player[playerid][Home] > 0)
			{//� ������ ���� ���
			    new PlayerHouse = Player[playerid][Home], text3d[MAX_3DTEXT];
			    if(!strcmp(Property[PlayerHouse][pOwner], OldName, true))
			    {//������ ������������� ����������� ��� �� ������ ����
			        strmid(Property[PlayerHouse][pOwner], NewName, 0, strlen(NewName), MAX_PLAYER_NAME);
			        if(Property[PlayerHouse][pBuyBlock] > 0)
					{
						format(text3d, sizeof(text3d), "{00FF00}��� ({FFFFFF}%d${00FF00})\n{007FFF}��������:{FFFFFF} %s\n������� [{FFFF00}Alt{FFFFFF}] ����� ������������", Property[PlayerHouse][pPrice], Property[PlayerHouse][pOwner]);
                        UpdateDynamic3DTextLabelText(PropertyText3D[PlayerHouse], 0xFFFFFFFF, text3d);SaveProperty(PlayerHouse);
					}
					else
					{
						format(text3d, sizeof(text3d), "{00FF00}��� ({FF0000}�� ���������{00FF00})\n{007FFF}��������:{FFFFFF} %s\n������� [{FFFF00}Alt{FFFFFF}] ����� ������������", Property[PlayerHouse][pOwner]);
                        UpdateDynamic3DTextLabelText(PropertyText3D[PlayerHouse], 0xFFFFFFFF, text3d);SaveProperty(PlayerHouse);
					}
			    }//������ ������������� ����������� ��� �� ������ ����
			}//� ������ ���� ���
			if (Player[playerid][MyClan] != 0 && Player[playerid][Member] != 0)
			{//����� � �����
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
			}//����� � �����
			new MesString[256];
			format(MesString,sizeof(MesString),"{008E00}�� ������� �������� ��� �� 100 ������.{FFFF00}\n����� ���: {FFFFFF}%s{FFFF00}\n�� �������� ������ ���, ����� � ��������� ��� ��������� samp.",NewName);
			ShowPlayerDialog(playerid, 999999, 0, "����� ����", MesString,"��","");
			//--------- ���� ���� ������ � Log
			new String[140]; format(String, sizeof String, "%d.%d.%d � %d:%d:%d |   SHOP: %s ������� ��� �� %s �� 100 ������", Day, Month, Year, hour, minute, second, OldName, NewName);
			WriteLog("GlobalLog", String);WriteLog("Shop", String);WriteLog("NickChanges", String);
		}//����� ���� - ���� ������ ����
		
		case DIALOG_MYWEATHER:
		{//��������� ������
		    if (!response) return 1;
		    if (listitem == 0) return 1;//�������� ������� ������
		    if (listitem == 1){SendClientMessage(playerid,COLOR_YELLOW,"SERVER: �� ���������� ��������� (�����) ������.");PlayerWeather[playerid] = -1;}
			if (listitem == 2) return ShowPlayerDialog(playerid, DIALOG_MYWEATHER2, 1, "���������� ���� ������", "{FFFFFF}������� ID ������ (�� {008D00}0 {FFFFFF}�� {008D00}1000000)\n{AFAFAF}- �� ��������� �� ������� ������������ ������ � ID �� 0 �� 20\n- ������ � ID ������ 20 ����� �������� ����������� � ��������� ����� �����", "��", "�����");
		}//��������� ������
		
		case DIALOG_MYWEATHER2:
		{//���������� ���� ������
		    if (!response) return ShowPlayerDialog(playerid, DIALOG_MYWEATHER, 2, "��������� ������", "�������� ������� ������\n���������� ��������� (�����) ������\n���������� ���� ������", "��", "");
			new entered = strval(inputtext);
			if (entered < 0 || entered > 1000000) return ShowPlayerDialog(playerid, DIALOG_MYWEATHER2, 1, "���������� ���� ������", "{FFFFFF}������� ID ������ ({FF0000}�� 0 {FFFFFF}�� 1000000)\n{AFAFAF}- �� ��������� �� ������� ������������ ������ � ID �� 0 �� 20\n- ������ � ID ������ 20 ����� �������� ����������� � ��������� ����� �����", "��", "�����");
		    PlayerWeather[playerid] = entered;
		    new String[140];format(String,sizeof(String),"SERVER: �� ���������� ������ � ID %d",entered);
			return SendClientMessage(playerid,COLOR_YELLOW,String);
		}//���������� ���� ������
		
        case DIALOG_PRESTIGEGM:
		{//����� ����
		    if (!response) return 1;
		    if (listitem == 0)
			{//��������� ����� ����
                PrestigeGM[playerid] = 0; SetPlayerHealth(playerid, 100.0);
				SendClientMessage(playerid,0xFF0000FF,"����� ���� �������������. �� ���� ������������� ������������.");
				LSpawnPlayer(playerid);
			}//��������� ����� ����
			if (listitem == 1)
			{//����������������� � ������� GPS
			    if (GPSUsed[playerid] == 0) return SendClientMessage(playerid,COLOR_RED, "������: ������� ��� ����� ���������� ������, ��������� {FFFFFF}/gps");
			    new Float: x, Float: y, Float: z; GetPlayerCheckpointPos(playerid, x, y, z); SetPlayerPos(playerid, x, y, z); SetPlayerInterior(playerid, 0);
			}//����������������� � ������� GPS
			if (listitem == 2) return LSpawnPlayer(playerid); //�������
		}//����� ����
		
		case DIALOG_ACHANGE:
		{//��������� ������������
		    if (!response) return 1;
		    if (listitem == 0)
			{//�������� �������
			    if (DMTimer > 1 && DMTimer < 300)
			    {//������������ �������� ��� ��������� (��������� � ��� �� ����������)
			        new String[1024], StringX[80];String = "{FFFF00}��������� �����\n";
			        for (new id = 1; id <= 20; id++)
			        {//����
			            if (DMid == id) format (StringX, sizeof StringX, "{FF8C00}%s (������ �������)\n", DMName[id]);
			            else format (StringX, sizeof StringX, "{FFFFFF}%s\n", DMName[id]);
						strcat(String, StringX);
			        }//����
			        return ShowPlayerDialog(playerid, DIALOG_ACHANGEDM, 2, "{FF8C00}�������� �������", String, "��", "������");
			    }//������������ �������� ��� ��������� (��������� � ��� �� ����������)
			    else return SendClientMessage(playerid,COLOR_RED,"������: ������ �������� ������� ���� �� �� ��������");
			}//�������� �������
			if (listitem == 1)
			{//�������� �����
			    if (DerbyTimer > 1 && DerbyTimer < 300)
			    {//������������ �������� ��� ��������� (��������� � ��� �� ����������)
			        new String[1024], StringX[80];String = "{FFFF00}��������� �����\n";
			        for (new id = 1; id <= 9; id++)
			        {//����
			            if (Derbyid == id) format (StringX, sizeof StringX, "{9966CC}%s (������ �������)\n", DerbyName[id]);
			            else format (StringX, sizeof StringX, "{FFFFFF}%s\n", DerbyName[id]);
						strcat(String, StringX);
			        }//����
			        return ShowPlayerDialog(playerid, DIALOG_ACHANGEDERBY, 2, "{9966CC}�������� �����", String, "��", "������");
			    }//������������ �������� ��� ��������� (��������� � ��� �� ����������)
			    else return SendClientMessage(playerid,COLOR_RED,"������: ������ �������� ����� ���� ��� �� ���������");
			}//�������� �����
			if (listitem == 2)
			{//�������� �����
			    if (ZMTimer > 1 && ZMTimer < 300)
			    {//������������ �������� ��� ��������� (��������� � ��� �� ����������)
			        new String[1024], StringX[80];String = "{FFFF00}��������� �����\n";
			        for (new id = 1; id <= 15; id++)
			        {//����
			            if (ZMid == id) format (StringX, sizeof StringX, "{FF6666}%s (������ �������)\n", ZMName[id]);
			            else format (StringX, sizeof StringX, "{FFFFFF}%s\n", ZMName[id]);
						strcat(String, StringX);
			        }//����
			        return ShowPlayerDialog(playerid, DIALOG_ACHANGEZM, 2, "{FF6666}�������� �����-���������", String, "��", "������");
			    }//������������ �������� ��� ��������� (��������� � ��� �� ����������)
			    else SendClientMessage(playerid,COLOR_RED,"������: ������ �������� �����-��������� ���� ��� �� ���������");
			}//�������� �����
			if (listitem == 3)
			{//�������� �����
			    if (FRTimer > 1 && FRTimer < 300)
			    {//������������ �������� ��� ��������� (��������� � ��� �� ����������)
			        new String[2048], StringX[100];String = "{FFFF00}��������� �����\n";
			        for (new id = 1; id <= 40; id++)
			        {//����
			            if (FRStart == id) format (StringX, sizeof StringX, "{007FFF}%s (������ �������)\n", FRName[id]);
			            else format (StringX, sizeof StringX, "{FFFFFF}%s\n", FRName[id]);
						strcat(String, StringX);
			        }//����
			        return ShowPlayerDialog(playerid, DIALOG_ACHANGEFR, 2, "{007FFF}�������� �����:{FFFFFF} �����", String, "��", "������");
			    }//������������ �������� ��� ��������� (��������� � ��� �� ����������)
			    else SendClientMessage(playerid,COLOR_RED,"������: ������ �������� ����� ���� ��� �� ���������");
			}//�������� �����
			if (listitem == 4)
			{//�������� �������
			    if (GGTimer > 1 && GGTimer < 600)
			    {//������������ �������� ��� ��������� (��������� � ��� �� ����������)
			        new String[1024], StringX[80];String = "{FFFF00}��������� �����\n";
			        for (new id = 1; id <= 20; id++)
			        {//����
			            if (GGid == id) format (StringX, sizeof StringX, "{FF6666}%s (������ �������)\n", GGName[id]);
			            else format (StringX, sizeof StringX, "{FFFFFF}%s\n", GGName[id]);
						strcat(String, StringX);
			        }//����
			        return ShowPlayerDialog(playerid, DIALOG_ACHANGEGG, 2, "{FF6666}�������� ����� ����������", String, "��", "������");
			    }//������������ �������� ��� ��������� (��������� � ��� �� ����������)
			    else SendClientMessage(playerid,COLOR_RED,"������: ������ �������� ����� ���������� ���� ��� �� ���������");
			}//�������� �������
			if (listitem == 5)
			{//�������� �������
			    if (XRTimer > 1 && XRTimer < 600)
			    {//������������ �������� ��� ��������� (��������� � ��� �� ����������)
			        new String[1024], StringX[80];String = "{FFFF00}��������� �����\n";
			        for (new id = 1; id <= 20; id++)
			        {//����
			            if (XRid == id) format (StringX, sizeof StringX, "{007FFF}%s (������ �������)\n", XRName[id]);
			            else format (StringX, sizeof StringX, "{FFFFFF}%s\n", XRName[id]);
						strcat(String, StringX);
			        }//����
			        return ShowPlayerDialog(playerid, DIALOG_ACHANGEXR, 2, "{007FFF}�������� ����������� �����", String, "��", "������");
			    }//������������ �������� ��� ��������� (��������� � ��� �� ����������)
			    else SendClientMessage(playerid,COLOR_RED,"������: ������ �������� ����������� ����� ���� ��� �� ���������");
			}//�������� �������
		}//��������� ������������
		
		case DIALOG_ACHANGEDM:
		{//��������� ��������
		    if (!response) return SendCommand(playerid, "/change", "");
		    if (listitem == 0) listitem = random(20) + 1;
		    if (listitem == DMid) return 1;
		    new Params[20];format(Params, sizeof Params, "dm %i", listitem);
            SendCommand(playerid, "/changeid", Params);
		}//��������� ��������
		
		case DIALOG_ACHANGEDERBY:
		{//��������� �����
		    if (!response) return SendCommand(playerid, "/change", "");
		    if (listitem == 0) listitem = random(9) + 1;
		    if (listitem == Derbyid) return 1;
		    new Params[20];format(Params, sizeof Params, "derby %i", listitem);
		    SendCommand(playerid, "/changeid", Params);
		}//��������� �����
		
		case DIALOG_ACHANGEZM:
		{//��������� �����
		    if (!response) return SendCommand(playerid, "/change", "");
		    if (listitem == 0) listitem = random(15) + 1;
		    if (listitem == ZMid) return 1;
		    new Params[20];format(Params, sizeof Params, "zombie %i", listitem);
		    SendCommand(playerid, "/changeid", Params);
		}//��������� �����
		
		case DIALOG_ACHANGEFR:
		{//��������� �����: �����
		    if (!response) return SendCommand(playerid, "/change", "");
		    if (FRTimer > 300) return SendClientMessage(playerid,COLOR_RED,"������: ������ �������� ����� ���� ��� �� ���������");
		    if (FRTimer > 2 && FRTimer <= 30) return SendClientMessage(playerid,COLOR_RED,"������: ������ �������� ����� ��� ��� �� ������ �������� ������ 30 ������");
 		    if (listitem == 0) listitem = random(40) + 1;
		    ACHANGEFR[playerid] = listitem;
            new String[2048], StringX[100];String = "{FFFF00}��������� �����\n";
			for (new id = 1; id <= 40; id++)
			{//����
				if (FRFinish == id) format (StringX, sizeof StringX, "{007FFF}%s (������ �������)\n", FRName[id]);
				else format (StringX, sizeof StringX, "{FFFFFF}%s\n", FRName[id]);
				strcat(String, StringX);
			}//����
			return ShowPlayerDialog(playerid, DIALOG_ACHANGEFR2, 2, "{007FFF}�������� �����:{FFFFFF} �����", String, "��", "�����");
		}//��������� �����: �����
		
		case DIALOG_ACHANGEFR2:
		{//��������� �����: �����
		    if (!response)
		    {//������ ������ ����� (������� � ������ ������ �����)
                if (FRTimer > 1 && FRTimer < 300)
			    {//������������ �������� ��� ��������� (��������� � ��� �� ����������)
			        new String[2048], StringX[100];String = "{FFFF00}��������� �����\n";
			        for (new id = 1; id <= 40; id++)
			        {//����
			            if (FRStart == id) format (StringX, sizeof StringX, "{007FFF}%s (������ �������)\n", FRName[id]);
			            else format (StringX, sizeof StringX, "{FFFFFF}%s\n", FRName[id]);
						strcat(String, StringX);
			        }//����
			        return ShowPlayerDialog(playerid, DIALOG_ACHANGEFR, 2, "{007FFF}�������� �����:{FFFFFF} �����", String, "��", "������");
			    }//������������ �������� ��� ��������� (��������� � ��� �� ����������)
			    else SendClientMessage(playerid,COLOR_RED,"������: ������ �������� ����� ���� ��� �� ���������");
		    }//������ ������ ����� (������� � ������ ������ �����)
		    if (listitem == 0) listitem = random(40) + 1;
		    new Params[20];format(Params, sizeof Params, "%i %i", ACHANGEFR[playerid], listitem);
		    SendCommand(playerid, "/changeraceid", Params);
		}//��������� �����: �����
		
		case DIALOG_ACHANGEGG:
		{//��������� ��������
		    if (!response) return SendCommand(playerid, "/change", "");
		    if (listitem == 0) listitem = random(20) + 1;
		    if (listitem == GGid) return 1;
		    new Params[20];format(Params, sizeof Params, "gungame %i", listitem);
		    SendCommand(playerid, "/changeid", Params);
		}//��������� ��������
		
		case DIALOG_ACHANGEXR:
		{//��������� �������
		    if (!response) return SendCommand(playerid, "/change", "");
		    if (listitem == 0) listitem = random(20) + 1;
		    if (listitem == XRid) return 1;
		    new Params[20];format(Params, sizeof Params, "xrace %i", listitem);
		    SendCommand(playerid, "/changeid", Params);
		}//��������� �������
		
		case DIALOG_TURBOSPEED:
		{//�������������� TurboSpeed
		    if (response)
		    {
		    	if (listitem == 0) ShowPlayerDialog(playerid, DIALOG_TURBOSPEEDNITRO, 2, "�����", "[{FFFF00}50 000${FFFFFF}] ����������� �����\n[{FFFF00}300 000${FFFFFF}] UberNitro", "��", "�����");
				if (listitem == 1) ShowPlayerDialog(playerid, DIALOG_TURBOSPEEDNEON, 2, "����", "[{FFFF00}50 000${FFFFFF}] �������\n[{FFFF00}50 000${FFFFFF}] �����\n[{FFFF00}50 000${FFFFFF}] �������\n[{FFFF00}50 000${FFFFFF}] ������\n[{FFFF00}50 000${FFFFFF}] �������\n[{FFFF00}50 000${FFFFFF}] �����", "��", "�����");
				if (listitem == 2)
				{//������� ��������� �������
				    if (Player[playerid][CarActive] < 1 || Player[playerid][CarActive] > 2) return SendClientMessage(playerid,COLOR_RED,"������� ���������� ������� ����� ������ � ������ �����������!");
				    new StringZ[1024];
				    if (Player[playerid][CarActive] == 1)
				    {//����� 1
  				   		if (Player[playerid][CarSlot1Component0] == 0) strcat(StringZ, "{AFAFAF}�������\n"); else strcat(StringZ, "{FFFFFF}�������\n");
  				   		if (Player[playerid][CarSlot1Component1] == 0) strcat(StringZ, "{AFAFAF}�����\n"); else strcat(StringZ, "{FFFFFF}�����\n");
  				   		if (Player[playerid][CarSlot1Component2] == 0) strcat(StringZ, "{AFAFAF}�����\n"); else strcat(StringZ, "{FFFFFF}�����\n");
  				   		if (Player[playerid][CarSlot1Component3] == 0) strcat(StringZ, "{AFAFAF}������� ����\n"); else strcat(StringZ, "{FFFFFF}������� ����\n");
  				   		if (Player[playerid][CarSlot1Component4] == 0) strcat(StringZ, "{AFAFAF}����\n"); else strcat(StringZ, "{FFFFFF}����\n");
  				   		if (Player[playerid][CarSlot1Component5] == 0) strcat(StringZ, "{AFAFAF}�����\n"); else strcat(StringZ, "{FFFFFF}�����\n");
  				   		if (Player[playerid][CarSlot1Component6] == 0) strcat(StringZ, "{AFAFAF}��������� �����\n"); else strcat(StringZ, "{FFFFFF}��������� �����\n");
  				   		if (Player[playerid][CarSlot1Component7] == 0) strcat(StringZ, "{AFAFAF}�����\n"); else strcat(StringZ, "{FFFFFF}�����\n");
  				   		if (Player[playerid][CarSlot1Component8] == 0) strcat(StringZ, "{AFAFAF}������\n"); else strcat(StringZ, "{FFFFFF}������\n");
  				   		if (Player[playerid][CarSlot1Component9] == 0) strcat(StringZ, "{AFAFAF}����������\n"); else strcat(StringZ, "{FFFFFF}����������\n");
  				   		if (Player[playerid][CarSlot1Component10] == 0) strcat(StringZ, "{AFAFAF}�������� ������\n"); else strcat(StringZ, "{FFFFFF}�������� ������\n");
  				   		if (Player[playerid][CarSlot1Component11] == 0) strcat(StringZ, "{AFAFAF}������ ������\n"); else strcat(StringZ, "{FFFFFF}������ ������\n");
  				   		if (Player[playerid][CarSlot1Component12] == 0) strcat(StringZ, "{AFAFAF}������ ����\n"); else strcat(StringZ, "{FFFFFF}������ ����\n");
  				   		if (Player[playerid][CarSlot1Component13] == 0) strcat(StringZ, "{AFAFAF}����� ����\n"); else strcat(StringZ, "{FFFFFF}����� ����\n");
  				   		if (Player[playerid][CarSlot1PaintJob] == -1) strcat(StringZ, "{AFAFAF}����������� ������\n"); else strcat(StringZ, "{FFFFFF}����������� ������\n");
  				   		if (Player[playerid][CarSlot1Neon] == 0) strcat(StringZ, "{AFAFAF}����\n"); else strcat(StringZ, "{FFFFFF}����\n");
						return ShowPlayerDialog(playerid, DIALOG_TURBOSPEEDDELETE, 2, "������� ���������", StringZ, "�������", "�����");
					}//����� 1
  				    if (Player[playerid][CarActive] == 2)
				    {//����� 2
				        if (Player[playerid][CarSlot2Component0] == 0) strcat(StringZ, "{AFAFAF}�������\n"); else strcat(StringZ, "{FFFFFF}�������\n");
  				   		if (Player[playerid][CarSlot2Component1] == 0) strcat(StringZ, "{AFAFAF}�����\n"); else strcat(StringZ, "{FFFFFF}�����\n");
  				   		if (Player[playerid][CarSlot2Component2] == 0) strcat(StringZ, "{AFAFAF}�����\n"); else strcat(StringZ, "{FFFFFF}�����\n");
  				   		if (Player[playerid][CarSlot2Component3] == 0) strcat(StringZ, "{AFAFAF}������� ����\n"); else strcat(StringZ, "{FFFFFF}������� ����\n");
  				   		if (Player[playerid][CarSlot2Component4] == 0) strcat(StringZ, "{AFAFAF}����\n"); else strcat(StringZ, "{FFFFFF}����\n");
  				   		if (Player[playerid][CarSlot2Component5] == 0) strcat(StringZ, "{AFAFAF}�����\n"); else strcat(StringZ, "{FFFFFF}�����\n");
  				   		if (Player[playerid][CarSlot2Component6] == 0) strcat(StringZ, "{AFAFAF}��������� �����\n"); else strcat(StringZ, "{FFFFFF}��������� �����\n");
  				   		if (Player[playerid][CarSlot2Component7] == 0) strcat(StringZ, "{AFAFAF}�����\n"); else strcat(StringZ, "{FFFFFF}�����\n");
  				   		if (Player[playerid][CarSlot2Component8] == 0) strcat(StringZ, "{AFAFAF}������\n"); else strcat(StringZ, "{FFFFFF}������\n");
  				   		if (Player[playerid][CarSlot2Component9] == 0) strcat(StringZ, "{AFAFAF}����������\n"); else strcat(StringZ, "{FFFFFF}����������\n");
  				   		if (Player[playerid][CarSlot2Component10] == 0) strcat(StringZ, "{AFAFAF}�������� ������\n"); else strcat(StringZ, "{FFFFFF}�������� ������\n");
  				   		if (Player[playerid][CarSlot2Component11] == 0) strcat(StringZ, "{AFAFAF}������ ������\n"); else strcat(StringZ, "{FFFFFF}������ ������\n");
  				   		if (Player[playerid][CarSlot2Component12] == 0) strcat(StringZ, "{AFAFAF}������ ����\n"); else strcat(StringZ, "{FFFFFF}������ ����\n");
  				   		if (Player[playerid][CarSlot2Component13] == 0) strcat(StringZ, "{AFAFAF}����� ����\n"); else strcat(StringZ, "{FFFFFF}����� ����\n");
  				   		if (Player[playerid][CarSlot2PaintJob] == -1) strcat(StringZ, "{AFAFAF}����������� ������\n"); else strcat(StringZ, "{FFFFFF}����������� ������\n");
  				   		if (Player[playerid][CarSlot2Neon] == 0) strcat(StringZ, "{AFAFAF}����\n"); else strcat(StringZ, "{FFFFFF}����\n");
                        return ShowPlayerDialog(playerid, DIALOG_TURBOSPEEDDELETE, 2, "������� ���������", StringZ, "�������", "�����");
				    }//����� 2
				}//������� ��������� �������
			}
		}//�������������� TurboSpeed
		
		case DIALOG_TURBOSPEEDDELETE:
		{//�������������� TurboSpeed - ������� ���������
		    if (!response) return ShowPlayerDialog(playerid, DIALOG_TURBOSPEED, 2, "�������������� TurboSpeed", "�����\n����\n{FF0000}������� ��������� �������", "��", "������");
			if (Player[playerid][CarActive] == 1)
			{//����� 1
				if (listitem == 0)
				{
				    if (Player[playerid][CarSlot1Component0] == 0) return SendClientMessage(playerid,COLOR_GREY,"� ��� �� ���������� �������");
					Player[playerid][CarSlot1Component0] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 0);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"������� ������");
				}
				if (listitem == 1)
				{
				    if (Player[playerid][CarSlot1Component1] == 0) return SendClientMessage(playerid,COLOR_GREY,"� ��� �� ���������� �����");
					Player[playerid][CarSlot1Component1] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 1);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"����� ������");
				}
				if (listitem == 2)
				{
				    if (Player[playerid][CarSlot1Component2] == 0) return SendClientMessage(playerid,COLOR_GREY,"� ��� �� ����������� �����");
					Player[playerid][CarSlot1Component2] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 2);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"����� �������");
				}
				if (listitem == 3)
				{
				    if (Player[playerid][CarSlot1Component3] == 0) return SendClientMessage(playerid,COLOR_GREY,"� ��� �� ����������� ������� ����");
					Player[playerid][CarSlot1Component3] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 3);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"������� ���� ������");
				}
				if (listitem == 4)
				{
				    if (Player[playerid][CarSlot1Component4] == 0) return SendClientMessage(playerid,COLOR_GREY,"� ��� �� ����������� ����");
					Player[playerid][CarSlot1Component4] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 4);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"���� �������");
				}
				if (listitem == 5)
				{
				    if (Player[playerid][CarSlot1Component5] == 0) return SendClientMessage(playerid,COLOR_GREY,"� ��� �� ����������� �����");
					Player[playerid][CarSlot1Component5] = 0;Player[playerid][CarSlot1NitroX] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 5);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"����� �������");
				}
				if (listitem == 6)
				{
				    if (Player[playerid][CarSlot1Component6] == 0) return SendClientMessage(playerid,COLOR_GREY,"� ��� �� ����������� ��������� �����");
					Player[playerid][CarSlot1Component6] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 6);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"��������� ����� ������");
				}
				if (listitem == 7)
				{
				    if (Player[playerid][CarSlot1Component7] == 0) return SendClientMessage(playerid,COLOR_GREY,"� ��� �� ����������� �����");
					Player[playerid][CarSlot1Component7] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 7);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"����� �������");
				}
				if (listitem == 8)
				{
				    if (Player[playerid][CarSlot1Component8] == 0) return SendClientMessage(playerid,COLOR_GREY,"� ��� �� ����������� ������");
					Player[playerid][CarSlot1Component8] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 8);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"������ �������");
				}
				if (listitem == 9)
				{
				    if (Player[playerid][CarSlot1Component9] == 0) return SendClientMessage(playerid,COLOR_GREY,"� ��� �� ����������� ����������");
					Player[playerid][CarSlot1Component9] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 9);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"���������� �������");
				}
				if (listitem == 10)
				{
				    if (Player[playerid][CarSlot1Component10] == 0) return SendClientMessage(playerid,COLOR_GREY,"� ��� �� ���������� �������� ������");
					Player[playerid][CarSlot1Component10] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 10);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"�������� ������ ������");
				}
				if (listitem == 11)
				{
				    if (Player[playerid][CarSlot1Component11] == 0) return SendClientMessage(playerid,COLOR_GREY,"� ��� �� ���������� ������ ������");
					Player[playerid][CarSlot1Component11] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 11);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"������ ������ ������");
				}
				if (listitem == 12)
				{
				    if (Player[playerid][CarSlot1Component12] == 0) return SendClientMessage(playerid,COLOR_GREY,"� ��� �� ���������� ������ ����");
					Player[playerid][CarSlot1Component12] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 12);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"������ ���� ������");
				}
				if (listitem == 13)
				{
				    if (Player[playerid][CarSlot1Component13] == 0) return SendClientMessage(playerid,COLOR_GREY,"� ��� �� ���������� ����� ����");
					Player[playerid][CarSlot1Component13] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 13);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"����� ���� ������");
				}
				if (listitem == 14)
				{
				    if (Player[playerid][CarSlot1PaintJob] == -1) return SendClientMessage(playerid,COLOR_GREY,"� ��� �� ����������� ����������� �����");
					Player[playerid][CarSlot1PaintJob] = -1;
					DestroyVehicle(GetPlayerVehicleID(playerid));CallCar1(playerid);
					SendClientMessage(playerid,COLOR_GREY,"����������� ������ �������");
				}
				if (listitem == 15)
				{
				    if (Player[playerid][CarSlot1Neon] == 0) return SendClientMessage(playerid,COLOR_GREY,"� ��� �� ���������� ����");
					Player[playerid][CarSlot1Neon] = 0; new vehicleid = GetPlayerVehicleID(playerid);
					if (NeonObject1[vehicleid] != -1){DestroyDynamicObject(NeonObject1[vehicleid]);NeonObject1[vehicleid] = -1;}
					if (NeonObject2[vehicleid] != -1){DestroyDynamicObject(NeonObject2[vehicleid]);NeonObject2[vehicleid] = -1;}
					SendClientMessage(playerid,COLOR_GREY,"���� ������");
				}
			}//����� 1
            if (Player[playerid][CarActive] == 2)
			{//����� 2
				if (listitem == 0)
				{
				    if (Player[playerid][CarSlot2Component0] == 0) return SendClientMessage(playerid,COLOR_GREY,"� ��� �� ���������� �������");
					Player[playerid][CarSlot2Component0] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 0);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"������� ������");
				}
				if (listitem == 1)
				{
				    if (Player[playerid][CarSlot2Component1] == 0) return SendClientMessage(playerid,COLOR_GREY,"� ��� �� ���������� �����");
					Player[playerid][CarSlot2Component1] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 1);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"����� ������");
				}
				if (listitem == 2)
				{
				    if (Player[playerid][CarSlot2Component2] == 0) return SendClientMessage(playerid,COLOR_GREY,"� ��� �� ����������� �����");
					Player[playerid][CarSlot2Component2] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 2);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"����� �������");
				}
				if (listitem == 3)
				{
				    if (Player[playerid][CarSlot2Component3] == 0) return SendClientMessage(playerid,COLOR_GREY,"� ��� �� ����������� ������� ����");
					Player[playerid][CarSlot2Component3] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 3);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"������� ���� ������");
				}
				if (listitem == 4)
				{
				    if (Player[playerid][CarSlot2Component4] == 0) return SendClientMessage(playerid,COLOR_GREY,"� ��� �� ����������� ����");
					Player[playerid][CarSlot2Component4] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 4);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"���� �������");
				}
				if (listitem == 5)
				{
				    if (Player[playerid][CarSlot2Component5] == 0) return SendClientMessage(playerid,COLOR_GREY,"� ��� �� ����������� �����");
					Player[playerid][CarSlot2Component5] = 0;Player[playerid][CarSlot2NitroX] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 5);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"����� �������");
				}
				if (listitem == 6)
				{
				    if (Player[playerid][CarSlot2Component6] == 0) return SendClientMessage(playerid,COLOR_GREY,"� ��� �� ����������� ��������� �����");
					Player[playerid][CarSlot2Component6] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 6);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"��������� ����� ������");
				}
				if (listitem == 7)
				{
				    if (Player[playerid][CarSlot2Component7] == 0) return SendClientMessage(playerid,COLOR_GREY,"� ��� �� ����������� �����");
					Player[playerid][CarSlot2Component7] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 7);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"����� �������");
				}
				if (listitem == 8)
				{
				    if (Player[playerid][CarSlot2Component8] == 0) return SendClientMessage(playerid,COLOR_GREY,"� ��� �� ����������� ������");
					Player[playerid][CarSlot2Component8] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 8);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"������ �������");
				}
				if (listitem == 9)
				{
				    if (Player[playerid][CarSlot2Component9] == 0) return SendClientMessage(playerid,COLOR_GREY,"� ��� �� ����������� ����������");
					Player[playerid][CarSlot2Component9] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 9);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"���������� �������");
				}
				if (listitem == 10)
				{
				    if (Player[playerid][CarSlot2Component10] == 0) return SendClientMessage(playerid,COLOR_GREY,"� ��� �� ���������� �������� ������");
					Player[playerid][CarSlot2Component10] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 10);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"�������� ������ ������");
				}
				if (listitem == 11)
				{
				    if (Player[playerid][CarSlot2Component11] == 0) return SendClientMessage(playerid,COLOR_GREY,"� ��� �� ���������� ������ ������");
					Player[playerid][CarSlot2Component11] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 11);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"������ ������ ������");
				}
				if (listitem == 12)
				{
				    if (Player[playerid][CarSlot2Component12] == 0) return SendClientMessage(playerid,COLOR_GREY,"� ��� �� ���������� ������ ����");
					Player[playerid][CarSlot2Component12] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 12);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"������ ���� ������");
				}
				if (listitem == 13)
				{
				    if (Player[playerid][CarSlot2Component13] == 0) return SendClientMessage(playerid,COLOR_GREY,"� ��� �� ���������� ����� ����");
					Player[playerid][CarSlot2Component13] = 0;
					new component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), 13);
					if (component != 0) RemoveVehicleComponent(GetPlayerVehicleID(playerid), component);
					SendClientMessage(playerid,COLOR_GREY,"����� ���� ������");
				}
				if (listitem == 14)
				{
				    if (Player[playerid][CarSlot2PaintJob] == -1) return SendClientMessage(playerid,COLOR_GREY,"� ��� �� ����������� ����������� �����");
					Player[playerid][CarSlot2PaintJob] = -1;
					DestroyVehicle(GetPlayerVehicleID(playerid));CallCar2(playerid);
					SendClientMessage(playerid,COLOR_GREY,"����������� ������ �������");
				}
				if (listitem == 15)
				{
				    if (Player[playerid][CarSlot2Neon] == 0) return SendClientMessage(playerid,COLOR_GREY,"� ��� �� ���������� ����");
					Player[playerid][CarSlot2Neon] = 0; new vehicleid = GetPlayerVehicleID(playerid);
					if (NeonObject1[vehicleid] != -1){DestroyDynamicObject(NeonObject1[vehicleid]);NeonObject1[vehicleid] = -1;}
					if (NeonObject2[vehicleid] != -1){DestroyDynamicObject(NeonObject2[vehicleid]);NeonObject2[vehicleid] = -1;}
					SendClientMessage(playerid,COLOR_GREY,"���� ������");
				}
			}//����� 2
		    SaveTune(playerid);
		    
		    
		    //������ ����� ������� �������� �����������
		    new StringZ[1024];
			if (Player[playerid][CarActive] == 1)
			{//����� 1
  				if (Player[playerid][CarSlot1Component0] == 0) strcat(StringZ, "{AFAFAF}�������\n"); else strcat(StringZ, "{FFFFFF}�������\n");
  				if (Player[playerid][CarSlot1Component1] == 0) strcat(StringZ, "{AFAFAF}�����\n"); else strcat(StringZ, "{FFFFFF}�����\n");
  				if (Player[playerid][CarSlot1Component2] == 0) strcat(StringZ, "{AFAFAF}�����\n"); else strcat(StringZ, "{FFFFFF}�����\n");
  				if (Player[playerid][CarSlot1Component3] == 0) strcat(StringZ, "{AFAFAF}������� ����\n"); else strcat(StringZ, "{FFFFFF}������� ����\n");
  				if (Player[playerid][CarSlot1Component4] == 0) strcat(StringZ, "{AFAFAF}����\n"); else strcat(StringZ, "{FFFFFF}����\n");
  				if (Player[playerid][CarSlot1Component5] == 0) strcat(StringZ, "{AFAFAF}�����\n"); else strcat(StringZ, "{FFFFFF}�����\n");
  				if (Player[playerid][CarSlot1Component6] == 0) strcat(StringZ, "{AFAFAF}��������� �����\n"); else strcat(StringZ, "{FFFFFF}��������� �����\n");
  				if (Player[playerid][CarSlot1Component7] == 0) strcat(StringZ, "{AFAFAF}�����\n"); else strcat(StringZ, "{FFFFFF}�����\n");
  				if (Player[playerid][CarSlot1Component8] == 0) strcat(StringZ, "{AFAFAF}������\n"); else strcat(StringZ, "{FFFFFF}������\n");
  				if (Player[playerid][CarSlot1Component9] == 0) strcat(StringZ, "{AFAFAF}����������\n"); else strcat(StringZ, "{FFFFFF}����������\n");
  				if (Player[playerid][CarSlot1Component10] == 0) strcat(StringZ, "{AFAFAF}�������� ������\n"); else strcat(StringZ, "{FFFFFF}�������� ������\n");
  				if (Player[playerid][CarSlot1Component11] == 0) strcat(StringZ, "{AFAFAF}������ ������\n"); else strcat(StringZ, "{FFFFFF}������ ������\n");
  				if (Player[playerid][CarSlot1Component12] == 0) strcat(StringZ, "{AFAFAF}������ ����\n"); else strcat(StringZ, "{FFFFFF}������ ����\n");
  				if (Player[playerid][CarSlot1Component13] == 0) strcat(StringZ, "{AFAFAF}����� ����\n"); else strcat(StringZ, "{FFFFFF}����� ����\n");
                if (Player[playerid][CarSlot1PaintJob] == -1) strcat(StringZ, "{AFAFAF}����������� ������\n"); else strcat(StringZ, "{FFFFFF}����������� ������\n");
                if (Player[playerid][CarSlot1Neon] == 0) strcat(StringZ, "{AFAFAF}����\n"); else strcat(StringZ, "{FFFFFF}����\n");
				return ShowPlayerDialog(playerid, DIALOG_TURBOSPEEDDELETE, 2, "������� ���������", StringZ, "�������", "�����");
			}//����� 1
  			if (Player[playerid][CarActive] == 2)
			{//����� 2
				if (Player[playerid][CarSlot2Component0] == 0) strcat(StringZ, "{AFAFAF}�������\n"); else strcat(StringZ, "{FFFFFF}�������\n");
  				if (Player[playerid][CarSlot2Component1] == 0) strcat(StringZ, "{AFAFAF}�����\n"); else strcat(StringZ, "{FFFFFF}�����\n");
  				if (Player[playerid][CarSlot2Component2] == 0) strcat(StringZ, "{AFAFAF}�����\n"); else strcat(StringZ, "{FFFFFF}�����\n");
  				if (Player[playerid][CarSlot2Component3] == 0) strcat(StringZ, "{AFAFAF}������� ����\n"); else strcat(StringZ, "{FFFFFF}������� ����\n");
  				if (Player[playerid][CarSlot2Component4] == 0) strcat(StringZ, "{AFAFAF}����\n"); else strcat(StringZ, "{FFFFFF}����\n");
  				if (Player[playerid][CarSlot2Component5] == 0) strcat(StringZ, "{AFAFAF}�����\n"); else strcat(StringZ, "{FFFFFF}�����\n");
  				if (Player[playerid][CarSlot2Component6] == 0) strcat(StringZ, "{AFAFAF}��������� �����\n"); else strcat(StringZ, "{FFFFFF}��������� �����\n");
  				if (Player[playerid][CarSlot2Component7] == 0) strcat(StringZ, "{AFAFAF}�����\n"); else strcat(StringZ, "{FFFFFF}�����\n");
  				if (Player[playerid][CarSlot2Component8] == 0) strcat(StringZ, "{AFAFAF}������\n"); else strcat(StringZ, "{FFFFFF}������\n");
  				if (Player[playerid][CarSlot2Component9] == 0) strcat(StringZ, "{AFAFAF}����������\n"); else strcat(StringZ, "{FFFFFF}����������\n");
  				if (Player[playerid][CarSlot2Component10] == 0) strcat(StringZ, "{AFAFAF}�������� ������\n"); else strcat(StringZ, "{FFFFFF}�������� ������\n");
  				if (Player[playerid][CarSlot2Component11] == 0) strcat(StringZ, "{AFAFAF}������ ������\n"); else strcat(StringZ, "{FFFFFF}������ ������\n");
  				if (Player[playerid][CarSlot2Component12] == 0) strcat(StringZ, "{AFAFAF}������ ����\n"); else strcat(StringZ, "{FFFFFF}������ ����\n");
  				if (Player[playerid][CarSlot2Component13] == 0) strcat(StringZ, "{AFAFAF}����� ����\n"); else strcat(StringZ, "{FFFFFF}����� ����\n");
                if (Player[playerid][CarSlot2PaintJob] == -1) strcat(StringZ, "{AFAFAF}����������� ������\n"); else strcat(StringZ, "{FFFFFF}����������� ������\n");
                if (Player[playerid][CarSlot2Neon] == 0) strcat(StringZ, "{AFAFAF}����\n"); else strcat(StringZ, "{FFFFFF}����\n");
				return ShowPlayerDialog(playerid, DIALOG_TURBOSPEEDDELETE, 2, "������� ���������", StringZ, "�������", "�����");
			}//����� 2
		}//�������������� TurboSpeed - ������� ���������
		
		case DIALOG_TURBOSPEEDNITRO:
		{//�������������� TurboSpeed - �����
		    	if (!response) return ShowPlayerDialog(playerid, DIALOG_TURBOSPEED, 2, "�������������� TurboSpeed", "�����\n����\n{FF0000}������� ��������� �������", "��", "������");
                if (Player[playerid][CarActive] < 1 || Player[playerid][CarActive] > 2) return SendClientMessage(playerid,COLOR_RED,"���������� ����� ����� ������ �� ������ ���������� 1-�� ��� 2-�� ������!");
				if (listitem == 0)
				{//����������� �����
				    if (Player[playerid][CarActive] > 0 && Player[playerid][CarActive] < 3)
				    {//����� � ���� ������ 1, 2
				        if (Player[playerid][Cash] < 50000) return SendClientMessage(playerid, COLOR_RED, "��� ������� ������������ ����� ����� 50 000$");
        				if (Player[playerid][Level] < 65) return SendClientMessage(playerid, COLOR_RED, "�� ������ ���� ��� ������� 65-�� ������");
					    if (Player[playerid][CarActive] == 1)
				        {
				            Player[playerid][CarSlot1Component5] = 1010; Player[playerid][CarSlot1NitroX] = 1;AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
							SendClientMessage(playerid, COLOR_YELLOW, "�� ��������� ����������� ����� �� 50 000$ ��� ���������� 1-�� ������.");
				        }
				        else if (Player[playerid][CarActive] == 2)
				        {
				            Player[playerid][CarSlot2Component5] = 1010; Player[playerid][CarSlot2NitroX] = 1;AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
				            SendClientMessage(playerid, COLOR_YELLOW, "�� ��������� ����������� ����� �� 50 000$ ��� ���������� 2-�� ������.");
				        }
				        Player[playerid][Cash] -= 50000;SaveTune(playerid);
				    }//����� � ���� ������ 1, 2
				}//����������� �����
				if (listitem == 1)
				{//UberNitro
				    if (Player[playerid][CarActive] > 0 && Player[playerid][CarActive] < 3)
				    {//����� � ���� ������ 1, 2
				        if (Player[playerid][Cash] < 300000) return SendClientMessage(playerid, COLOR_RED, "��� ������� Uber����� ����� 300 000$");
			            if (Player[playerid][Level] < 80) return SendClientMessage(playerid, COLOR_RED, "�� ������ ���� ��� ������� 80-�� ������");
					    if (Player[playerid][CarActive] == 1)
				        {
				            Player[playerid][CarSlot1Component5] = 1010; Player[playerid][CarSlot1NitroX] = 2;AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
							SendClientMessage(playerid, COLOR_YELLOW, "�� ��������� ����������� UberNitro �� 300 000$ ��� ���������� 1-�� ������.");
				        }
				        else if (Player[playerid][CarActive] == 2)
				        {
				            Player[playerid][CarSlot2Component5] = 1010; Player[playerid][CarSlot2NitroX] = 2;AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
				            SendClientMessage(playerid, COLOR_YELLOW, "�� ��������� ����������� UberNitro �� 300 000$ ��� ���������� 2-�� ������.");
				        }
				        Player[playerid][Cash] -= 300000;SaveTune(playerid);
					}//����� � ���� ������ 1,2
				}//UberNitro
		}//�������������� TurboSpeed - �����
		
		case DIALOG_TURBOSPEEDNEON:
		{//�������������� TurboSpeed - ����
		    if (!response) return ShowPlayerDialog(playerid, DIALOG_TURBOSPEED, 2, "�������������� TurboSpeed", "�����\n����\n{FF0000}������� ��������� �������", "��", "������");
			if (Player[playerid][Prestige] < 4) return SendClientMessage(playerid,COLOR_RED, "�� ������ ���� ��� ������� 4 ������ �������� ����� ���������� ����");
			if (Player[playerid][Cash] < 50000) return SendClientMessage(playerid, COLOR_RED, "��� ������� ����� ����� 50 000$");
            if (Player[playerid][CarActive] < 1 || Player[playerid][CarActive] > 2) return SendClientMessage(playerid,COLOR_RED,"���������� ���� ����� ������ �� ������ ���������� 1-�� ��� 2-�� ������!");

			new model = GetVehicleModel(GetPlayerVehicleID(playerid));
			switch (model)
			{
			    case 417, 425, 447, 460, 469, 476, 487, 488, 497, 511, 512, 513, 519, 520, 548, 553, 563, 577, 592, 593, //Air
			    509, 481, 510, 462, 448, 581, 522, 461, 521, 523, 463, 486, 468, 471, /*Bikes*/ 472, 473, 493, 595, 484, 430, 453, 452, 446, 454, //Boats
			    435, 441, 449, 450, 464, 465, 501, 530, 485, 457, 532, 537, 538, 564, 569, 570, 571, 572, 584, 590, 591, 594, 606, 607, 608, 610, 611: //������
			    return SendClientMessage(playerid, COLOR_RED, "������ ���������� ���� �� ��� ������ ����������!");
			}

			if (Player[playerid][CarActive] == 1)
			{//���� ������ 1
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
			    SendClientMessage(playerid, COLOR_YELLOW, "�� ��������� ���� �� 50 000$ ��� ���������� 1-�� ������.");
			}//���� ������ 1
			if (Player[playerid][CarActive] == 2)
			{//���� ������ 2
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
			    SendClientMessage(playerid, COLOR_YELLOW, "�� ��������� ���� �� 50 000$ ��� ���������� 2-�� ������.");
			}//���� ������ 2
			Player[playerid][Cash] -= 50000; SaveTune(playerid);
		}//�������������� TurboSpeed - ����
		
		case DIALOG_GPS:
		{//GPS
		    if (!response) return 1;
		    if (InEvent[playerid] > 0) return SendClientMessage(playerid, COLOR_RED, "������: GPS ���������� � �������������.");
		    if (QuestActive[playerid] > 0) return SendClientMessage(playerid, COLOR_RED, "������: GPS ���������� �� ������ � ��� ���������� �������.");
		    if (listitem == 0)
			{//������
			    new String[1024];
			    strcat(String, "{00CCCC}��. 1: {FFFFFF}��������� ����� (2400 XP, 144 000$)\n{00CCCC}��. 1: {FFFFFF}������� (2700 XP, 108 000$)\n{00CCCC}��. 14: {FFFFFF}�������� (2880 XP, 360 000$)\n{00CCCC}��. 21: {FFFFFF}��������� (3240 XP, 270 000$)");
				strcat(String, "\n{00CCCC}��. 28: {FFFFFF}������������ (3420 XP, 540 000$)\n{00CCCC}��. 35: {FFFFFF}������� ������� (3600 XP, 396 000$)\n{00CCCC}��. 42: {FFFFFF}���������� (2400 XP, 900 000$)");
				return ShowPlayerDialog(playerid, DIALOG_GPSWORK, 2, "GPS - ������", String, "��", "�����");//������
			}//������
			if (listitem == 1)
			{//����
			    new Closest = 0, Float: fDistance = 99999999.9;
                for(new i = 0; i < 6; i++)
				{//���� - ������� ��������� ����
				    if (GetPlayerDistanceFromPoint(playerid, BANKENTERS[i][0], BANKENTERS[i][1], BANKENTERS[i][2]) < fDistance)
				    {//���������� �� ����� i ������, ��� fDistance
				        fDistance = GetPlayerDistanceFromPoint(playerid, BANKENTERS[i][0], BANKENTERS[i][1], BANKENTERS[i][2]);
				        Closest = i;
				    }//���������� �� ����� i ������, ��� fDistance
				}//���� - ������� ��������� ����
			    SetPlayerCheckpoint(playerid, BANKENTERS[Closest][0], BANKENTERS[Closest][1], BANKENTERS[Closest][2], 5); GPSUsed[playerid] = 1;
				SendClientMessage(playerid, COLOR_RED, "GPS:{FFFF00} ��������� ���� ��� ������� �� ������ {FF0000}������� ��������{FFFF00}.");
				return PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
			}//����
			if (listitem == 2)
			{//������
			    SetPlayerCheckpoint(playerid, 2019.3174, 1007.8547, 10.8203, 5); GPSUsed[playerid] = 1;
				SendClientMessage(playerid, COLOR_RED, "GPS:{FFFF00} ������ ���� �������� �� ������ {FF0000}������� ��������{FFFF00}.");
				return PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
			}//������
		    if (listitem == 3) return ShowPlayerDialog(playerid, DIALOG_GPSTUNE, 2, "GPS - ��������������", "Transfender ({AFAFAF}��� ����������� �����{FFFFFF})\nLowrider\nArch Angels\nTurboSpeed", "��", "�����");//��������������
			if (listitem == 4)
			{//������� ������
			    new Closest = 0, Float: fDistance = 99999999.9;
                for(new i = 0; i < 4; i++)
				{//���� - ������� ��������� ������� ������
				    if (GetPlayerDistanceFromPoint(playerid, CLOTHESENTERS[i][0], CLOTHESENTERS[i][1], CLOTHESENTERS[i][2]) < fDistance)
				    {//���������� �� �������� i ������, ��� fDistance
				        fDistance = GetPlayerDistanceFromPoint(playerid, CLOTHESENTERS[i][0], CLOTHESENTERS[i][1], CLOTHESENTERS[i][2]);
				        Closest = i;
				    }//���������� �� �������� i ������, ��� fDistance
				}//���� - ������� ��������� ������� ������
			    SetPlayerCheckpoint(playerid, CLOTHESENTERS[Closest][0], CLOTHESENTERS[Closest][1], CLOTHESENTERS[Closest][2], 5); GPSUsed[playerid] = 1;
				SendClientMessage(playerid, COLOR_RED, "GPS:{FFFF00} ��������� ������� ������ ��� ������� �� ������ {FF0000}������� ��������{FFFF00}.");
				return PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
			}//������� ������
			if (listitem == 5)
			{//��������
			    new Closest = 0, Float: fDistance = 99999999.9;
                for(new i = 0; i < 3; i++)
				{//���� - ������� ��������� ������� ������
				    if (GetPlayerDistanceFromPoint(playerid, AIRPORTENTERS[i][0], AIRPORTENTERS[i][1], AIRPORTENTERS[i][2]) < fDistance)
				    {//���������� �� �������� i ������, ��� fDistance
				        fDistance = GetPlayerDistanceFromPoint(playerid, AIRPORTENTERS[i][0], AIRPORTENTERS[i][1], AIRPORTENTERS[i][2]);
				        Closest = i;
				    }//���������� �� �������� i ������, ��� fDistance
				}//���� - ������� ��������� ������� ������
			    SetPlayerCheckpoint(playerid, AIRPORTENTERS[Closest][0], AIRPORTENTERS[Closest][1], AIRPORTENTERS[Closest][2], 5); GPSUsed[playerid] = 1;
				SendClientMessage(playerid, COLOR_RED, "GPS:{FFFF00} ��������� �������� ��� ������� �� ������ {FF0000}������� ��������{FFFF00}.");
				return PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
			}//��������
			if (listitem == 6)
			{//������ ���
				if (Player[playerid][Home] == 0) return SendClientMessage(playerid, COLOR_RED, "������: � ��� ��� ����!");
				new houseid = Player[playerid][Home];
				SetPlayerCheckpoint(playerid, Property[houseid][pPosEnterX], Property[houseid][pPosEnterY], Property[houseid][pPosEnterZ], 5); GPSUsed[playerid] = 1;
				SendClientMessage(playerid, COLOR_RED, "GPS:{FFFF00} ��� ��� ��� ������� �� ������ {FF0000}������� ��������{FFFF00}.");
				return PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
			}//������ ���
			if (listitem == 7)
			{//���� �����
				if (Player[playerid][MyClan] == 0) return SendClientMessage(playerid, COLOR_RED, "������: �� �� �������� � �����!");
				new clanid = Player[playerid][MyClan], baseid = Clan[clanid][cBase];
				if (baseid <= 0) return SendClientMessage(playerid, COLOR_RED, "������: � ������ ����� ��� �����!");
				SetPlayerCheckpoint(playerid, Base[baseid][bPosEnterX], Base[baseid][bPosEnterY], Base[baseid][bPosEnterZ], 5); GPSUsed[playerid] = 1;
				SendClientMessage(playerid, COLOR_RED, "GPS:{FFFF00} ���� ������ ����� ��� ������� �� ������ {FF0000}������� ��������{FFFF00}.");
				return PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
			}//���� �����
			if (listitem == 8)
		    {//������ �������
		        if (GPSUsed[playerid] == 0) return SendClientMessage(playerid, COLOR_RED, "GPS:{FFFF00} �� ����� ������ �� ����������� ������� ��������.");
		        DisablePlayerCheckpoint(playerid); GPSUsed[playerid] = 0;
		        return SendClientMessage(playerid, COLOR_RED, "GPS:{FFFF00} ������ ������� ������.");
		    }//������ �������
		}//GPS
		
		case DIALOG_GPSWORK:
		{//GPS - ������
		    if (!response) return SendCommand(playerid, "/gps", "");
		    if (InEvent[playerid] > 0) return SendClientMessage(playerid, COLOR_RED, "������: GPS ���������� � �������������.");
		    if (QuestActive[playerid] > 0) return SendClientMessage(playerid, COLOR_RED, "������: GPS ���������� �� ������ � ��� ���������� �������.");
		    if (listitem == 0)
			{//��������� �����
			    SetPlayerCheckpoint(playerid, 2397.7632, -1899.1389, 13.5469, 5); GPSUsed[playerid] = 1;
				SendClientMessage(playerid, COLOR_RED, "GPS:{FFFF00} ������ <<��������� �����>> ���� �������� �� ������ {FF0000}������� ��������{FFFF00}.");
				return PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
			}//��������� �����
			if (listitem == 1)
			{//�������
			    SetPlayerCheckpoint(playerid, 2729.3267, -2451.4578, 17.5937, 5); GPSUsed[playerid] = 1;
				SendClientMessage(playerid, COLOR_RED, "GPS:{FFFF00} ������ <<�������>> ���� �������� �� ������ {FF0000}������� ��������{FFFF00}.");
				return PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
			}//�������
			if (listitem == 2)
			{//��������
			    SetPlayerCheckpoint(playerid, -1972.5024, -1020.2568, 32.1719, 5); GPSUsed[playerid] = 1;
				SendClientMessage(playerid, COLOR_RED, "GPS:{FFFF00} ������ <<��������>> ���� �������� �� ������ {FF0000}������� ��������{FFFF00}.");
				return PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
			}//��������
			if (listitem == 3)
			{//���������
			    SetPlayerCheckpoint(playerid, -1061.6104, -1195.4755, 129.8281, 5); GPSUsed[playerid] = 1;
				SendClientMessage(playerid, COLOR_RED, "GPS:{FFFF00} ������ <<���������>> ���� �������� �� ������ {FF0000}������� ��������{FFFF00}.");
				return PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
			}//���������
			if (listitem == 4)
			{//������������
			    SetPlayerCheckpoint(playerid, 2484.6682, -2120.8743, 13.5469, 5); GPSUsed[playerid] = 1;
				SendClientMessage(playerid, COLOR_RED, "GPS:{FFFF00} ������ <<������������>> ���� �������� �� ������ {FF0000}������� ��������{FFFF00}.");
				return PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
			}//������������
			if (listitem == 5)
			{//������� �������
			    SetPlayerCheckpoint(playerid, -1713.1389, -61.8556, 3.5547, 5); GPSUsed[playerid] = 1;
				SendClientMessage(playerid, COLOR_RED, "GPS:{FFFF00} ������ <<������� �������>> ���� �������� �� ������ {FF0000}������� ��������{FFFF00}.");
				return PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
			}//������� �������
			if (listitem == 6)
			{//����������
			    SetPlayerCheckpoint(playerid, 2364.8955, 2382.8770, 10.8203, 5); GPSUsed[playerid] = 1;
				SendClientMessage(playerid, COLOR_RED, "GPS:{FFFF00} ������ <<����������>> ���� �������� �� ������ {FF0000}������� ��������{FFFF00}.");
				return PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
			}//����������
		}//GPS - ������
		
		case DIALOG_GPSTUNE:
		{//GPS - ��������������
		    if (!response) return SendCommand(playerid, "/gps", "");
		    if (InEvent[playerid] > 0) return SendClientMessage(playerid, COLOR_RED, "������: GPS ���������� � �������������.");
		    if (QuestActive[playerid] > 0) return SendClientMessage(playerid, COLOR_RED, "������: GPS ���������� �� ������ � ��� ���������� �������.");
		    if (listitem == 0)
			{//Transfender
			    new Closest = 0, Float: fDistance = 99999999.9;
                for(new i = 0; i < 3; i++)
				{//���� - ������� ��������� �������������� Transfender
				    if (GetPlayerDistanceFromPoint(playerid, TRANSFENDER[i][0], TRANSFENDER[i][1], TRANSFENDER[i][2]) < fDistance)
				    {//���������� �� transfender i ������, ��� fDistance
				        fDistance = GetPlayerDistanceFromPoint(playerid, TRANSFENDER[i][0], TRANSFENDER[i][1], TRANSFENDER[i][2]);
				        Closest = i;
				    }//���������� �� transfender i ������, ��� fDistance
				}//���� - ������� ��������� �������������� Transfender
			    SetPlayerCheckpoint(playerid, TRANSFENDER[Closest][0], TRANSFENDER[Closest][1], TRANSFENDER[Closest][2], 5); GPSUsed[playerid] = 1;
				SendClientMessage(playerid, COLOR_RED, "GPS:{FFFF00} ��������� �������������� Transfender ���� �������� �� ������ {FF0000}������� ��������{FFFF00}.");
				return PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
			}//Transfender
		    if (listitem == 1)
			{//Lowrider
			    SetPlayerCheckpoint(playerid, 2645.1233, -2034.3359, 13.5540, 5); GPSUsed[playerid] = 1;
				SendClientMessage(playerid, COLOR_RED, "GPS:{FFFF00} �������������� Lowrider ���� �������� �� ������ {FF0000}������� ��������{FFFF00}.");
				return PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
			}//Lowrider
		    if (listitem == 2)
			{//Arch Angels
			    SetPlayerCheckpoint(playerid, -2711.2119, 217.4269, 4.1955, 5); GPSUsed[playerid] = 1;
				SendClientMessage(playerid, COLOR_RED, "GPS:{FFFF00} �������������� Arch Angels ���� �������� �� ������ {FF0000}������� ��������{FFFF00}.");
				return PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
			}//Arch Angels
		    if (listitem == 3)
			{//TurboSpeed
			    SetPlayerCheckpoint(playerid, -2026.9071, 133.2521, 28.8359, 5); GPSUsed[playerid] = 1;
				SendClientMessage(playerid, COLOR_RED, "GPS:{FFFF00} �������������� TurboSpeed ���� �������� �� ������ {FF0000}������� ��������{FFFF00}.");
				return PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
			}//TurboSpeed
		}//GPS - ��������������
		
        case DIALOG_WORKGRUZSTOP:
        {//����������� ������ ��������
        	if(!response) return 1;
            SendClientMessage(playerid,COLOR_QUEST,"������ <<{FFFFFF}�������{FFCC00}>> ��������.");// ������� �����
            DisablePlayerCheckpoint(playerid); QuestActive[playerid] = 0;
            ApplyAnimation(playerid,"PED","IDLE_tired",4.1,0,1,1,0,1);// �������� ��������
            RemovePlayerAttachedObject(playerid,0);// ������� ������ �� ���
            DeletePVar(playerid,"WorkStage");// ������� PVar � �������� ������
            DeletePVar(playerid,"WorkCount");// ������� PVar � ������������ �����
        }//����������� ������ ��������
        
        case DIALOG_WORKSTOP:
        {//����� �������� ���������� ��� ����������� ������
            if (!response) return 1;
            if (listitem == 0)
            {//����� �������� ����������
                if (TimeTransform[playerid] > 0){new String[120];format(String,sizeof(String),"�� �� ������ �������� ��������� ��� {FFFFFF}%d{FF0000} ������",TimeTransform[playerid]);return SendClientMessage(playerid,COLOR_RED,String);}
				if (GetPlayerInterior(playerid) != 0 || IsPlayerInRangeOfPoint(playerid, 13.0, 2311.6953,-7.4206,26.7422)) return SendClientMessage(playerid, COLOR_RED, "������ �������� ��������� � ����������!");//����� � ���������� ��� � �����
                new Float: x, Float: y, Float: z, Float: angle; GetPlayerPos(playerid, x, y, z); GetPlayerFacingAngle(playerid, angle);
                if (QuestActive[playerid] == 2) QuestCar[playerid] = LCreateVehicle(448, x, y, z, angle, 3, 3, 0);
                if (QuestActive[playerid] == 4) QuestCar[playerid] = LCreateVehicle(609, x, y, z, angle, 25, 25, 0);
 				if (QuestActive[playerid] == 5) QuestCar[playerid] = LCreateVehicle(532, x, y, z + 1, angle, 25, 25, 0);
 				if (QuestActive[playerid] == 6) {QuestCar[playerid] = LCreateVehicle(515, x, y, z + 1, angle, 4, 4, 0); if (GetPVarInt(playerid, "WorkTruckStage") == 1) CallTrailer(QuestCar[playerid], 584);}
                if (QuestActive[playerid] == 7) QuestCar[playerid] = LCreateVehicle(452, x, y, z + 1, angle, 1, 2, 0);
                if (QuestActive[playerid] == 8) QuestCar[playerid] = LCreateVehicle(428, x, y, z + 1, angle, 227, 4, 0);
				PutPlayerInVehicle(playerid,QuestCar[playerid], 0); TimeTransform[playerid] = 3;
            }//����� �������� ����������
            if (listitem == 1)
            {//�������� ������
				if (QuestActive[playerid] == 2) SendClientMessage(playerid,COLOR_QUEST,"������ <<{FFFFFF}��������� �����{FFCC00}>> ��������.");
                if (QuestActive[playerid] == 4)
                {
                    RemovePlayerAttachedObject(playerid,0); DeletePVar(playerid,"WorkDomStage");
                    SendClientMessage(playerid,COLOR_QUEST,"������ <<{FFFFFF}��������{FFCC00}>> ��������.");
                }
                if (QuestActive[playerid] == 5)
                {
                    GangZoneHideForPlayer(playerid,WorkZoneCombine);
                    SendClientMessage(playerid,COLOR_QUEST,"������ <<{FFFFFF}���������{FFCC00}>> ��������.");
                }
                if (QuestActive[playerid] == 6)
				{
				    DeletePVar(playerid,"WorkTruckStage");
					SendClientMessage(playerid,COLOR_QUEST,"������ <<{FFFFFF}������������{FFCC00}>> ��������.");
				}
				if (QuestActive[playerid] == 7)
				{
				    DeletePVar(playerid,"WorkWaterStage");
					SendClientMessage(playerid,COLOR_QUEST,"������ <<{FFFFFF}������� �������{FFCC00}>> ��������.");
				}
				if (QuestActive[playerid] == 8)
                {
                    DeletePVar(playerid,"WorkBankStage");
                    SendClientMessage(playerid,COLOR_QUEST,"������ <<{FFFFFF}����������{FFCC00}>> ��������.");
                }
				QuestActive[playerid] = 0; DisablePlayerCheckpoint(playerid); DisablePlayerRaceCheckpoint(playerid);
            }//�������� ������
        }//����� �������� ���������� ��� ����������� ������
        
        case DIALOG_LEAVEZM:
        {//�������� �����-���������?
            if (!response) return 1;
            JoinEvent[playerid] = 0; InEvent[playerid] = 0; ZMStarted[playerid] = 0; ZMIsPlayerIsZombie[playerid] = 0; ZMIsPlayerIsTank[playerid] = 0;
			SendClientMessage(playerid,COLOR_ZOMBIE,"�� �������� �����-���������.");
			GangZoneHideForPlayer(playerid,ZMZone1);GangZoneHideForPlayer(playerid,ZMZone2);GangZoneHideForPlayer(playerid,ZMZone3);GangZoneHideForPlayer(playerid,ZMZone4);GangZoneHideForPlayer(playerid,ZMZone5);
			GangZoneHideForPlayer(playerid,ZMZone6);GangZoneHideForPlayer(playerid,ZMZone7);GangZoneHideForPlayer(playerid,ZMZone8);GangZoneHideForPlayer(playerid,ZMZone9);GangZoneHideForPlayer(playerid,ZMZone10);
			ZMPlayers--; Player[playerid][LeaveZM] = 3600;//��������� ��� ������ �� �����
			SetPlayerVirtualWorld(playerid,0);ResetPlayerWeapons(playerid);LSpawnPlayer(playerid);
			new String[120]; format(String,sizeof(String),"%s[%d] ������� �����-���������.", PlayerName[playerid], playerid);
			foreach(Player, cid) if (cid != playerid && JoinEvent[cid] == EVENT_ZOMBIE) SendClientMessage(cid,COLOR_ZOMBIE,String);
        }//�������� �����-���������?

		case DIALOG_CLANRENAME:
		{//������������� ����
			if(response)
			{//�������
				if(!strlen(inputtext) || strlen(inputtext) < 2 || strlen(inputtext) > 20) return ShowPlayerDialog(playerid, DIALOG_CLANRENAME, 1, "������� �������� �����", "{FF0000}������: �������� ����� ��������..\n\n{FFFFFF}������� �������� �����.\n{008E00}[����� �� 2 �� 20 ��������]", "��", "������"); //���� ����� �����������

				new AllowName = 1;
			    for (new i; i < strlen(inputtext); i++)
				{//�������� ������� ������� � ���� �� ������������
				    if (inputtext[i] >= '0' && inputtext[i] <= '9') continue;
				    if (inputtext[i] >= 'A' && inputtext[i] <= 'Z') continue;
				    if (inputtext[i] >= 'a' && inputtext[i] <= 'z') continue;
                    if (inputtext[i] == '_') continue;
				    AllowName = 0;
				}//�������� ������� ������� � ���� �� ������������
				if (!AllowName)  return ShowPlayerDialog(playerid, DIALOG_CLANRENAME, 1, "������� �������� �����", "{FF0000}������: � �������� ����������� ������ ��������� �����, ����� � ������ '_'.\n\n{FFFFFF}������� �������� �����.\n{008E00}[����� �� 2 �� 20 ��������]", "��", "������");

				for(new i = 1; i < MAX_CLAN; i++)
				{//��� ��������� id`� ������
					if (Clan[i][cLevel] == 0) continue; //���������� �������������� �����
                    if(!strcmp(Clan[i][cName], inputtext, true)) return ShowPlayerDialog(playerid, DIALOG_CLANRENAME, 1, "������� �������� �����", "{FF0000}������: ���� � ����� ������ ��� ����������.\n\n{FFFFFF}������� �������� �����.\n{008E00}[����� �� 2 �� 20 ��������]", "��", "������");
				}//��� ��������� id`� ������
				if (Player[playerid][Cash] < 500000) return SendClientMessage(playerid,COLOR_RED,"������: � ��� ��� {FFFFFF}500 000{FF0000}$");
				Player[playerid][Cash] -= 500000;

				new clanid = Player[playerid][MyClan];
                strmid(Clan[clanid][cName], inputtext, 0, strlen(inputtext), 20);
				SaveClan(clanid); SavePlayer(playerid);
				
				if (Clan[clanid][cBase] > 0 && Clan[clanid][cBase] < MAX_BASE)
				{//� ����� ���� ����
				    new baseid = Clan[clanid][cBase], text3d[MAX_3DTEXT];
				    format(text3d, sizeof(text3d), "{007FFF}���� ({FFFFFF}%d${007FFF})\n{008E00}����:{FFFFFF} %s\n������� [{FFFF00}Alt{FFFFFF}] ����� ������������", Base[baseid][bPrice], Clan[clanid][cName]);
					UpdateDynamic3DTextLabelText(BaseText3D[baseid], 0xFFFFFFFF, text3d);
				}//� ����� ���� ����

				new ChatMes[120]; format(ChatMes, sizeof(ChatMes), "{008E00}�� �������� �������� ����� �� '{FFFFFF}%s{008E00}'", inputtext);
				SendClientMessage(playerid,COLOR_GREEN, ChatMes);
			}//�������
		}//���� �������� �����
		
		case DIALOG_BASEMENUPRICE:
		{//���� ����
			if(response)
			{//�������
			    new clanid = Player[playerid][MyClan], baseid = Clan[clanid][cBase], entered = strval(inputtext);
			    if (baseid <= 0 ||Base[baseid][bClan] != clanid) return SendClientMessage(playerid, COLOR_RED, "������: ��� �� ��� ����");
			    if (Player[playerid][Leader] < 100) return SendClientMessage(playerid, COLOR_RED, "������: ������ ����� ����� ����� ��������� ���� �����");
				if (entered <= 0) return SendClientMessage(playerid,COLOR_RED,"��������� ����� �����������");
				if (entered > Player[playerid][Cash]) entered = Player[playerid][Cash];
				new BankFree = 80000000 - Base[baseid][bPrice]; if (BankFree < entered) entered = BankFree;
				if (entered == 0) return SendClientMessage(playerid, COLOR_RED, "������: ��������� ����� ��� �������� ���������");
				Base[baseid][bPrice] += entered;Player[playerid][Cash] -= entered; SavePlayer(playerid); SaveBase(baseid);
				new text3d[MAX_3DTEXT], String[140], ccolor = Clan[clanid][cColor];
				format(text3d, sizeof(text3d), "{007FFF}���� ({FFFFFF}%d${007FFF})\n{008E00}����:{FFFFFF} %s\n������� [{FFFF00}Alt{FFFFFF}] ����� ������������", Base[baseid][bPrice], Clan[clanid][cName]);
				UpdateDynamic3DTextLabelText(BaseText3D[baseid], 0xFFFFFFFF, text3d);
				format(String,sizeof(String),"%s[%d] �������� ���� ����� �� %d$", PlayerName[playerid], playerid, entered);
				foreach(Player, cid) if (Player[cid][Member] != 0 && Player[cid][MyClan] == Player[playerid][MyClan] && Logged[cid] == 1) SendClientMessage(cid,ClanColor[ccolor],String);
			}//�������
			else ShowPlayerDialog(playerid, DIALOG_BASEMENU, 2, "{007FFF}����", "{008D00}����� � ����{FFFFFF}\n���������� � �����\n������ ����\n������� ����\n��������� ���� �����\n������� ������ ��������\n{FF0000}������", "��", "");
		}//���� ����

        case DIALOG_CHATNAME:
		{//������������ ��� ��� ����
		    if (!response || !strlen(inputtext)) return 1;
		    if (strlen(inputtext) > 100) return SendClientMessage(playerid, COLOR_RED, "������: �� ����� ������� ����� ��������!");
		    new BasicNick[100], allowed;
			//������� ��������� ��������� ���� ����� �� ������������. ������ ����������� ���� *FF0000*
			for(new i = 0; i < strlen(inputtext); i++)
			{//����
				if(inputtext[i] == '*' || inputtext[i] == '{')
				{//���� ����� "*" � ������
				    if (inputtext[i+7] == '*' || inputtext[i+7] == '}')
				    {//������� ������ * �� ������ ����� (����������� ������)
						inputtext[i] = '{'; inputtext[i+7] = '}';
						for (new u = i+1; u < i+7; u++)
						{//���� ��� �������� ������ ������
							allowed = 0;
							if (inputtext[u] >= '0' && inputtext[u] <= '9') allowed = 1;
							if (inputtext[u] >= 'A' && inputtext[u] <= 'F') allowed = 1; //A - F
							if (inputtext[u] >= 'a' && inputtext[u] <= 'f') allowed = 1;//a - f
							if (allowed == 0) return SendClientMessage(playerid, COLOR_RED, "������: ���� �� ����� ����� ������ �������!");
						}//���� ��� �������� ������ ������
						i += 7; continue;
				    }//������� ������ * �� ������ ����� (����������� ������)
				    else return SendClientMessage(playerid, COLOR_RED, "������: ���� �� ����� ����� ������ �������!");
				}//���� ����� "*" � ������
			}//����

			//������ ��������� ��������� ��� �� ������������ (��������� �� � ���������)
			if (Player[playerid][Admin] < 4)
			{//��. ����� ������ ������� ���� ����� ������ ���
	            strmid(BasicNick, inputtext, 0, strlen(inputtext), 100);
				for(new i = 0; i < strlen(BasicNick); i++)
				{//����
					if(BasicNick[i] == '{') strdel(BasicNick, i, i + 8);//������� ���� �����
				}//����
				if(strcmp(BasicNick, PlayerName[playerid], false)) return SendClientMessage(playerid, COLOR_RED, "������: ��������� ���� ��� ���������� �� ������ ���������� ����!");
			}//��. ����� ������ ������� ���� ����� ������ ���

            strmid(ChatName[playerid], inputtext, 0, strlen(inputtext), 100); SavePlayer(playerid);//��������� ����� ���
		    new String[140]; format(String, sizeof String, "%s {FFFFFF}- ��� �������� ��� ����� ���.", inputtext);
		    SendClientMessage(playerid, GetPlayerColor(playerid), String);
		}//������������ ��� ��� ����
		
		case DIALOG_CHANGEPASS:
		{//����� ������
		    new String[480];
		    if (!response)
		    {
		        format(String,sizeof(String), "SERVER: {AFAFAF}%s[%d] ��������� �������� ������.", PlayerName[playerid], playerid);
				foreach(Player, cid) if (Player[cid][Admin] >= 4 && Logged[cid] == 1) SendClientMessage(cid, COLOR_RED, String);
				return 1;
		    }
		    if(!strlen(inputtext) || strlen(inputtext) < 6 || strlen(inputtext) > 24)
			{
				format(String, sizeof(String), "{FFFFFF}������� ����� ������:\n\n     {008000}����������:\n     - ������ ������ ���� ������� (������: s9cQ17)\n     {FF0000}- ����� ������ ������ ���� �� 6 �� 24 ��������\n     {FF0000}- ��������� ������������ '=' � ������");
				return ShowPlayerDialog(playerid, DIALOG_CHANGEPASS, DIALOG_STYLE_INPUT, "{FF0000}����� ������", String, "��", "������");
			}
			for (new i; i < strlen(inputtext); i++)
			{
	   			if (inputtext[i] == '=')
	   			{//� ������ ���� ������ =
    				format(String, sizeof(String), "{FFFFFF}������� ����� ������:\n\n     {008000}����������:\n     - ������ ������ ���� ������� (������: s9cQ17)\n     {FF0000}- ����� ������ ������ ���� �� 6 �� 24 ��������\n     {FF0000}- ��������� ������������ '=' � ������");
					return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "{FFD700}����� ������", String, "��", "������");
	   			}//� ������ ���� ������ =
	   		}
	   		strmid(PlayerPass[playerid], inputtext, 0, strlen(inputtext), MAX_PASSWORD);
	   		SavePlayer(playerid);
	   		
	   		format(String,sizeof(String), "SERVER: {AFAFAF}%s[%d] ������� ���� ������.", PlayerName[playerid], playerid);
			foreach(Player, cid) if (Player[cid][Admin] >= 4 && Logged[cid] == 1) SendClientMessage(cid, COLOR_RED, String);
			format(String, sizeof String, "%d.%d.%d � %d:%d:%d |   %s[%d] ������� ������ �� %s", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid, inputtext);
			WriteLog("GlobalLog", String); WriteLog("PasswordChanges", String);
		}//����� ������
		
		case DIALOG_CASINORULET:
		{//������� �� ������
		    if(response)
			{//�������
			    if(listitem == 0) {CasinoBet[playerid] = 37; ShowPlayerDialog(playerid,DIALOG_CASINORULETBETSIZE,1,"������ ������","������� ������ ������","��","�����");}//������� (37)
			    if(listitem == 1) {CasinoBet[playerid] = 38; ShowPlayerDialog(playerid,DIALOG_CASINORULETBETSIZE,1,"������ ������","������� ������ ������","��","�����");}//������ (38)
			    if(listitem == 2) {CasinoBet[playerid] = 41; ShowPlayerDialog(playerid,DIALOG_CASINORULETBETSIZE,1,"������ ������","������� ������ ������","��","�����");}//������ ����� (41)
			    if(listitem == 3) {CasinoBet[playerid] = 42; ShowPlayerDialog(playerid,DIALOG_CASINORULETBETSIZE,1,"������ ������","������� ������ ������","��","�����");}//������ ����� (42)
			    if(listitem == 4) {CasinoBet[playerid] = 43; ShowPlayerDialog(playerid,DIALOG_CASINORULETBETSIZE,1,"������ ������","������� ������ ������","��","�����");}//������ ����� (43)
			    if(listitem == 5) ShowPlayerDialog(playerid,DIALOG_CASINORULETBETNUMBER,1,"������ �� �����","������� �����, �� ������� ������ ������� ������ (0-36)","��","�����");//�� ����� (0 - 37)
			}//�������
		}//������� �� ������

		case DIALOG_CASINORULETBETNUMBER:
		{//������ �� �����
			if(response)
			{//�������
			    new entered = strval(inputtext);
			    if (entered < 0 || entered > 36)
			    {
			        ShowPlayerDialog(playerid,DIALOG_CASINORULETBETNUMBER,1,"������ �� �����","������� �����, �� ������� ������ ������� ������ (0-36)\n\n{FF0000}������: ������� �������� �����","��","�����");
			        return 1;
				}
				CasinoBet[playerid] = entered;
				ShowPlayerDialog(playerid,DIALOG_CASINORULETBETSIZE,1,"������ ������","������� ������ ������","��","�����");
			}//�������
			else
			{
       			new String[180], MaxBet;
		  		if (Player[playerid][Level] < 39) MaxBet = 100000; //1 - 38 ���: 100 000$
	   			else if (Player[playerid][Level] < 53) MaxBet = 250000; //39 - 52 ���: 250 000$
	   			else if (Player[playerid][Level] < 66) MaxBet = 500000; //53 - 65 ���: 500 000$
	   			else MaxBet = 1000000; //66+ ���: 1 000 000$
 	   			if (Player[playerid][Prestige] >= 9) MaxBet = 100000000; //������� 9: 100 000 000$
				format(String,sizeof(String),"{AFAFAF}������������ ������: {FFFFFF}%d", MaxBet);
				ShowPlayerDialog(playerid, DIALOG_CASINORULET, 2, String, "{FFFFFF}��������� �� {FF0000}�������\n{FFFFFF}��������� �� {AFAFAF}������\n{FFFFFF}��������� �� {FFFF00}1-12\n{FFFFFF}��������� �� {FFFF00}13-24\n{FFFFFF}��������� �� {FFFF00}25-36\n{FFFFFF}��������� �� {FFFF00}�����", "��", "������");
			}
		}//������ �� �����

		case DIALOG_CASINORULETBETSIZE:
		{//���� ������� ������
   			new String[180], MaxBet, BetColor;
   		 		if (Player[playerid][Level] < 39) MaxBet = 100000; //1 - 38 ���: 100 000$
	   			else if (Player[playerid][Level] < 53) MaxBet = 250000; //39 - 52 ���: 250 000$
	   			else if (Player[playerid][Level] < 66) MaxBet = 500000; //53 - 65 ���: 500 000$
	   			else MaxBet = 1000000; //66+ ���: 1 000 000$
    			if (Player[playerid][Prestige] >= 9) MaxBet = 100000000; //������� 8: 100 000 000$
   			
			if(response)
			{//�������
				new entered = strval(inputtext);new StringB[120], Result;
				if (entered > Player[playerid][Cash]) entered = Player[playerid][Cash];
				if (entered <= 0) return SendClientMessage(playerid,COLOR_RED,"��������� ����� ����������� ��� � ��� ��� �����!");
				if (entered > MaxBet) entered = MaxBet;//����. ������
				Player[playerid][Cash] -= entered; Player[playerid][CasinoBalance] -= entered;
				if (CasinoBet[playerid] == 37 || CasinoBet[playerid] == 38)
				{//������ �� ������� ��� ������
					if (CasinoBet[playerid] == 37){format(StringB,sizeof(StringB),"{FFFF00}�� ��������� {FFFFFF}%d${FFFF00} �� �������.", entered);}
					if (CasinoBet[playerid] == 38){format(StringB,sizeof(StringB),"{FFFF00}�� ��������� {FFFFFF}%d${FFFF00} �� ������.", entered);}
					SendClientMessage(playerid,COLOR_YELLOW,StringB);
				}//������ �� ������� ��� ������

				if (CasinoBet[playerid] == 41 || CasinoBet[playerid] == 42  || CasinoBet[playerid] == 43)
				{//������ �� ������
				    if (CasinoBet[playerid] == 41){format(StringB,sizeof(StringB),"{FFFF00}�� ��������� {FFFFFF}%d${FFFF00} �� 1-12.", entered);}
				    if (CasinoBet[playerid] == 42){format(StringB,sizeof(StringB),"{FFFF00}�� ��������� {FFFFFF}%d${FFFF00} �� 13-24.", entered);}
				    if (CasinoBet[playerid] == 43){format(StringB,sizeof(StringB),"{FFFF00}�� ��������� {FFFFFF}%d${FFFF00} �� 25-36.", entered);}
				    SendClientMessage(playerid,COLOR_YELLOW,StringB);
				}//������ �� ������

                if (CasinoBet[playerid] >= 0 && CasinoBet[playerid] <= 36)
				{//������ �� �����
				    format(StringB,sizeof(StringB),"{FFFF00}�� ��������� {FFFFFF}%d${FFFF00} �� %d", entered, CasinoBet[playerid]);
				    SendClientMessage(playerid,COLOR_YELLOW,StringB);
				}//������ �� �����

				Result = random(37);

				if (CasinoBet[playerid] == 37)
				{//���� ���� ������ �� �������
					switch(Result)
					{
						case 0: BetColor = 0;//�������
						case 1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31,33,35: BetColor = 1;//�������
						case 2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36: BetColor = 2;//������
					}
				
				    if(BetColor == 1)
				    {//������ - ������ �������
				        Player[playerid][Cash] += entered*2; Player[playerid][CasinoBalance] += entered*2;
				        format(StringB,sizeof(StringB),"�� ��������! �� ��������: %d (�������)", Result);
				        SendClientMessage(playerid,COLOR_YELLOW,StringB);
				        format(StringB, sizeof StringB, "+%d$", entered); SetPlayerChatBubble(playerid, StringB, COLOR_GREEN, 10.0, 2000);
				        PlayerPlaySound(playerid,1083,0.0,0.0,0.0);//���� ��������
				    }//������ - ������ �������
				    if(BetColor == 2)
				    {//�������� - ������ ������
				        format(StringB,sizeof(StringB),"�� ���������! �� ��������: %d (������)", Result);
				        SendClientMessage(playerid,COLOR_GREY,StringB);
                        format(StringB, sizeof StringB, "-%d$", entered); SetPlayerChatBubble(playerid, StringB, COLOR_RED, 10.0, 2000);
				        PlayerPlaySound(playerid,1084,0.0,0.0,0.0);//���� ���������
				    }//�������� - ������ ������
				    if(BetColor == 0)
				    {//�������� - ������ ������
				        format(StringB,sizeof(StringB),"�� ���������! �� ��������: 0", Result);
				        SendClientMessage(playerid,COLOR_GREY,StringB);
				        format(StringB, sizeof StringB, "-%d$", entered); SetPlayerChatBubble(playerid, StringB, COLOR_RED, 10.0, 2000);
				        PlayerPlaySound(playerid,1084,0.0,0.0,0.0);//���� ���������
				    }//�������� - ������ ������
				}//���� ���� ������ �� �������

				if (CasinoBet[playerid] == 38)
				{//���� ���� ������ �� ������
					switch(Result)
					{
						case 0: BetColor = 0;//�������
						case 1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31,33,35: BetColor = 1;//�������
						case 2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36: BetColor = 2;//������
					}
				
				    if(BetColor == 1)
				    {//�������� - ������ �������
				        format(StringB,sizeof(StringB),"�� ���������! �� ��������: %d (�������)", Result);
				        SendClientMessage(playerid,COLOR_GREY,StringB);
				        format(StringB, sizeof StringB, "-%d$", entered); SetPlayerChatBubble(playerid, StringB, COLOR_RED, 10.0, 2000);
				        PlayerPlaySound(playerid,1084,0.0,0.0,0.0);//���� ���������
				    }//�������� - ������ �������
				    if(BetColor == 2)
				    {//������ - ������ ������
				        Player[playerid][Cash] += entered*2; Player[playerid][CasinoBalance] += entered*2;
				        format(StringB,sizeof(StringB),"�� ��������! �� ��������: %d (������)", Result);
				        SendClientMessage(playerid,COLOR_YELLOW,StringB);
				        format(StringB, sizeof StringB, "+%d$", entered); SetPlayerChatBubble(playerid, StringB, COLOR_GREEN, 10.0, 2000);
				        PlayerPlaySound(playerid,1083,0.0,0.0,0.0);//���� ��������
				    }//������ - ������ ������
				    if(BetColor == 0)
				    {//�������� - ������ ������
				        format(StringB,sizeof(StringB),"�� ���������! �� ��������: 0", Result);
				        SendClientMessage(playerid,COLOR_GREY,StringB);
				        format(StringB, sizeof StringB, "-%d$", entered); SetPlayerChatBubble(playerid, StringB, COLOR_RED, 10.0, 2000);
				        PlayerPlaySound(playerid,1084,0.0,0.0,0.0);//���� ���������
				    }//�������� - ������ ������
				}//���� ���� ������ �� ������

				if (CasinoBet[playerid] == 41)
				{//���� ���� ������ �� 1-12
				    if (Result >= 1 && Result <= 12)
					{//������� 1-12
					    Player[playerid][Cash] += entered*3; Player[playerid][CasinoBalance] += entered*3;
				        format(StringB,sizeof(StringB),"�� ��������! �� ��������: %d", Result);
				        SendClientMessage(playerid,COLOR_YELLOW,StringB);
				        format(StringB, sizeof StringB, "+%d$", entered*2); SetPlayerChatBubble(playerid, StringB, COLOR_GREEN, 10.0, 2000);
				        PlayerPlaySound(playerid,1083,0.0,0.0,0.0);//���� ��������
					}//������� 1-12
					else
				    {//��������
				        format(StringB,sizeof(StringB),"�� ���������! �� ��������: %d", Result);
				        SendClientMessage(playerid,COLOR_GREY,StringB);
				        format(StringB, sizeof StringB, "-%d$", entered); SetPlayerChatBubble(playerid, StringB, COLOR_RED, 10.0, 2000);
				        PlayerPlaySound(playerid,1084,0.0,0.0,0.0);//���� ���������
				    }//��������
				}//���� ���� ������ �� 1-12

				if (CasinoBet[playerid] == 42)
				{//���� ���� ������ �� 13-24
				    if (Result >= 13 && Result <= 24)
					{//�������
					    Player[playerid][Cash] += entered*3; Player[playerid][CasinoBalance] += entered*3;
				        format(StringB,sizeof(StringB),"�� ��������! �� ��������: %d", Result);
				        SendClientMessage(playerid,COLOR_YELLOW,StringB);
				        format(StringB, sizeof StringB, "+%d$", entered*2); SetPlayerChatBubble(playerid, StringB, COLOR_GREEN, 10.0, 2000);
				        PlayerPlaySound(playerid,1083,0.0,0.0,0.0);//���� ��������
					}//�������
					else
				    {//��������
				        format(StringB,sizeof(StringB),"�� ���������! �� ��������: %d", Result);
				        SendClientMessage(playerid,COLOR_GREY,StringB);
				        format(StringB, sizeof StringB, "-%d$", entered); SetPlayerChatBubble(playerid, StringB, COLOR_RED, 10.0, 2000);
				        PlayerPlaySound(playerid,1084,0.0,0.0,0.0);//���� ���������
				    }//��������
				}//���� ���� ������ �� 13-24

				if (CasinoBet[playerid] == 43)
				{//���� ���� ������ �� 25-36
				    if (Result >= 25 && Result <= 36)
					{//�������
					    Player[playerid][Cash] += entered*3; Player[playerid][CasinoBalance] += entered*3;
				        format(StringB,sizeof(StringB),"�� ��������! �� ��������: %d", Result);
				        SendClientMessage(playerid,COLOR_YELLOW,StringB);
				        format(StringB, sizeof StringB, "+%d$", entered*2); SetPlayerChatBubble(playerid, StringB, COLOR_GREEN, 10.0, 2000);
				        PlayerPlaySound(playerid,1083,0.0,0.0,0.0);//���� ��������
					}//�������
					else
				    {//��������
				        format(StringB,sizeof(StringB),"�� ���������! �� ��������: %d", Result);
				        SendClientMessage(playerid,COLOR_GREY,StringB);
				        format(StringB, sizeof StringB, "-%d$", entered); SetPlayerChatBubble(playerid, StringB, COLOR_RED, 10.0, 2000);
				        PlayerPlaySound(playerid,1084,0.0,0.0,0.0);//���� ���������
				    }//��������
				}//���� ���� ������ �� 25-36

				if (CasinoBet[playerid] >= 0 && CasinoBet[playerid] <= 36)
				{//���� ���� ������ �� �����
				    if (Result == CasinoBet[playerid])
					{//�������
					    Player[playerid][Cash] += entered*37; Player[playerid][CasinoBalance] += entered*37;
				        format(StringB,sizeof(StringB),"�� ��������! �� ��������: %d", Result);
				        SendClientMessage(playerid,COLOR_YELLOW,StringB);
				        format(StringB, sizeof StringB, "+%d$", entered*36); SetPlayerChatBubble(playerid, StringB, COLOR_GREEN, 10.0, 2000);
				        PlayerPlaySound(playerid,1083,0.0,0.0,0.0);//���� ��������
					}//�������
					else
				    {//��������
				        format(StringB,sizeof(StringB),"�� ���������! �� ��������: %d", Result);
				        SendClientMessage(playerid,COLOR_GREY,StringB);
				        format(StringB, sizeof StringB, "-%d$", entered); SetPlayerChatBubble(playerid, StringB, COLOR_RED, 10.0, 2000);
				        PlayerPlaySound(playerid,1084,0.0,0.0,0.0);//���� ���������
				    }//��������
				}//���� ���� ������ �� �����

           	    if (Player[playerid][CasinoBalance] >= 100000000 && Player[playerid][Prestige] < 9)
				{
				    format(StringB, sizeof StringB, "%d.%d.%d � %d:%d:%d |   UpdatePlayer: ����� %s[%d] ������� ������ �� 100 000 000$", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid);
					WriteLog("Casino", StringB);
					SendClientMessage(playerid, COLOR_RED, "�� �������� ������ �� 100 000 000$");
				}
				
				QuestUpdate(playerid, 24, 1);//���������� ������ �������� 20 ������ � ������
			}//�������
			else
			{
				format(String,sizeof(String),"{AFAFAF}������������ ������: {FFFFFF}%d", MaxBet);
				ShowPlayerDialog(playerid, DIALOG_CASINORULET, 2, String, "{FFFFFF}��������� �� {FF0000}�������\n{FFFFFF}��������� �� {AFAFAF}������\n{FFFFFF}��������� �� {FFFF00}1-12\n{FFFFFF}��������� �� {FFFF00}13-24\n{FFFFFF}��������� �� {FFFF00}25-36\n{FFFFFF}��������� �� {FFFF00}�����", "��", "������");
			}
		}//���� ������� ������
		
		case DIALOG_PRESTIGECOLOR:
		{//��������� ������ ����� �� ������ � � Tab (������� 7)
		    if (!response) return 1;
		    if (listitem <= 40)
			{
				Player[playerid][PrestigeColor] = listitem;
				SendClientMessage(playerid, COLOR_YELLOW, "SERVER: �� ������� �������� ���� ����!");
                SendClientMessage(playerid,COLOR_CYAN,"���������: ������� ��� ���� �� ������, � ����� ���� ���� ��� ������� � � Tab.");
                SendClientMessage(playerid,COLOR_CYAN,"���������: �� �������� ��� ���������� ����������� � � ����!");
			}
		    else {Player[playerid][PrestigeColor] = -1; SendClientMessage(playerid, COLOR_YELLOW, "SERVER: �� ������� ������� ���� ����������� ����!");}
		}//��������� ������ ����� �� ������ � � Tab (������� 7)
		
		case DIALOG_QUESTS:
		{//���� �������
		    if (!response) return 1;
		    if (listitem < 3) return SendCommand(playerid, "/quests", "");
		    if (listitem == 3)
		    {//����� �������
		        new String[120], StringX[480];
		        format(String, sizeof String, "{FFFFFF}[{FFCC00}1 ������{FFFFFF}] �������� 1 ����� ({007FFF}%0.0f{FFFFFF} / 5 �� �������)\n", Player[playerid][GGFromMedals]); strcat(StringX, String);
		        strcat(StringX, "{FFFFFF}[{FFCC00}1 ������{FFFFFF}] �������� 200 XP\n");
		        strcat(StringX, "{FFFFFF}[{FFCC00}1 ������{FFFFFF}] �������� 50 000$\n");
		        strcat(StringX, "{FFFFFF}[{FFCC00}4 ������{FFFFFF}] �������� 25 ����� �����\n");
		        strcat(StringX, "{FFFFFF}[{FFCC00}10 �������{FFFFFF}] �������� ������� ��������\n");

				//�������������� ���
				new ph = Player[playerid][Home];
				if (ph == 0) strcat(StringX, "{AFAFAF}[{FFCC00}14 �������{FFFFFF} / {00CCCC}7 ����{FFFFFF}] �������������� ���\n");
				else
				{
				    if (Property[ph][pBuyBlock] <= 0) strcat(StringX, "{AFAFAF}[{FFCC00}14 �������{FFFFFF} / {00CCCC}7 ����{FFFFFF}] �������������� ���\n");
					else
					{
					    new StrZ[140];
						format(StrZ, sizeof StrZ, "{AFAFAF}[{FFCC00}14 �������{FFFFFF} / {00CCCC}7 ����{FFFFFF}] �������������� ��� (�������� �� {00CCCC}%s{FFFFFF})\n", IntDateToStringDate(Property[ph][pBuyBlock]));
						strcat(StringX, StrZ);
					}
				}
                //�������������� ���
                
               	format(String, sizeof String, "{AFAFAF}�������� ������: {FFCC00}%d", Player[playerid][Medals]);
				ShowPlayerDialog(playerid, DIALOG_MEDALTRADE, 2, String, StringX, "�������", "�����");
		    }//����� �������
		}//���� �������

		case DIALOG_MEDALTRADE:
		{//����� �������
		    if (!response) return SendCommand(playerid, "/quests", "");
		    if (listitem == 0)
		    {//1 ������ = 1GG
		        if (Player[playerid][Banned] != 0) return SendClientMessage(playerid, COLOR_RED, "������: ����� ������� �� ����� ���������� ��� ���������� �������");
		        if (Player[playerid][Medals] < 1) return SendClientMessage(playerid, COLOR_RED, "������: � ��� ��� �������!");
				if (Player[playerid][GGFromMedals] >= 5) return SendClientMessage(playerid, COLOR_RED, "������: �� ����� ����� ���������� �� ����� 5 ������� � ����! ��������� ������� ������!");
		        Player[playerid][Medals]--; Player[playerid][GameGold] += 1.0; Player[playerid][GameGoldTotal] += 1.0;
				Player[playerid][GGFromMedals] += 1.0; Player[playerid][GGFromMedalsTotal] += 1.0;
		        return SendClientMessage(playerid, COLOR_YELLOW, "SERVER: �� ������� �������� ������ �� 1 �����!");
		    }//1 ������ = 1GG
		    if (listitem == 1)
		    {//1 ������ = 200 XP
		        if (Player[playerid][Medals] < 1) return SendClientMessage(playerid, COLOR_RED, "������: � ��� ��� �������!");
		        Player[playerid][Medals]--; LGiveXP(playerid, 200);
		        return SendClientMessage(playerid, COLOR_YELLOW, "SERVER: �� ������� �������� ������ �� 200 XP!");
		    }//1 ������ = 200 XP
		    if (listitem == 2)
		    {//1 ������ = 50 000$
		        if (Player[playerid][Medals] < 1) return SendClientMessage(playerid, COLOR_RED, "������: � ��� ��� �������!");
		        Player[playerid][Medals]--; Player[playerid][Cash] += 50000;
		        return SendClientMessage(playerid, COLOR_YELLOW, "SERVER: �� ������� �������� ������ �� 50 000$");
		    }//1 ������ = 50 000$
		    if (listitem == 3)
		    {//4 ������ = 25 ����� �����
		        if (Player[playerid][Medals] < 4) return SendClientMessage(playerid, COLOR_RED, "������: � ��� ��� 4 �������!");
		        if (Player[playerid][Karma] >= 1000) return SendClientMessage(playerid, COLOR_RED, "������: � ��� �������� �����!");
		        Player[playerid][Medals] -= 4; Player[playerid][Karma] += 25;
		        if (Player[playerid][Karma] >= 1000) Player[playerid][Karma] = 1000;
		        return SendClientMessage(playerid, COLOR_YELLOW, "SERVER: �� ������� �������� 4 ������ �� 25 ����� �����");
		    }//4 ������ = 25 ����� �����
		    if (listitem == 4) return SendCommand(playerid, "/prestige", ""); //10 ������� - �������� �������
			if(listitem == 5)
			{//�������������� ���
				if (Player[playerid][Medals] < 14) return SendClientMessage(playerid,COLOR_RED,"������: � ��� ��� 14 �������");
			    new phouse = Player[playerid][Home], text3d[MAX_3DTEXT], String[140];
			    if (phouse == 0) return SendClientMessage(playerid,COLOR_RED,"������: � ��� ��� ����");
                if (Property[phouse][pBuyBlock] <= 0)
			    {//�������
			    	Property[phouse][pBuyBlock] = DateToIntDate(Day, Month, Year) + 7;
			        format(String, sizeof String, "�� ��������� '�������������� ������ ���' �� {00CCCC}%s", IntDateToStringDate(Property[phouse][pBuyBlock]));
			        SendClientMessage(playerid, COLOR_YELLOW, String); SendClientMessage(playerid, COLOR_YELLOW, "���� �� ������ �������� ������, �� ������ ������ � ��� ���!");
			    }//�������
			    else
			    {//���������
			    	Property[phouse][pBuyBlock] += 7;
			        format(String, sizeof String, "�� �������� '�������������� ������ ���' �� {00CCCC}%s", IntDateToStringDate(Property[phouse][pBuyBlock]));
			        SendClientMessage(playerid, COLOR_YELLOW, String);
			    }//���������
			    Player[playerid][Medals] -= 14; SaveProperty(phouse); SavePlayer(playerid);
			    format(text3d, sizeof(text3d), "{00FF00}��� ({FF0000}�� ���������{00FF00})\n{007FFF}��������:{FFFFFF} %s\n������� [{FFFF00}Alt{FFFFFF}] ����� ������������", Property[phouse][pOwner]);
			    UpdateDynamic3DTextLabelText(PropertyText3D[phouse], 0xFFFFFFFF, text3d);
			}//�������������� ���
		}//����� �������
		
		case DIALOG_SELLHOUSE: if (response) return SendCommand(playerid, "/sellhouse", "");
		case DIALOG_SELLBASE: if (response) return SendCommand(playerid, "/sellbase", "");

	}//switch
	return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
	if (InEvent[playerid] != 0 || QuestActive[playerid] != 0) return SendClientMessage(playerid, COLOR_RED, "������: ������ ������������ �������� �� ����� �� ����� ������ ��� ������������!");
    if (MapTPTime[playerid] > 0) {new String[140]; format(String,sizeof(String),"�������� �� ����� ����� �������� ����� %d ������", MapTPTime[playerid]); return SendClientMessage(playerid,COLOR_RED,String);}
    if (Player[playerid][GPremium] >= 14 || Player[playerid][Admin] >= 4)
    {//14 ViP ���� ����. �����
		MapTP[playerid] = 1; MapTPTry[playerid] = 0; MapTPx[playerid] = fX; MapTPy[playerid] = fY;
		SetPlayerPos(playerid, fX, fY, -5);
    }//14 ViP ���� ����. �����

	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	if (Logged[playerid] == 0){SendClientMessage(playerid,COLOR_RED,"������: �� ������ ����������������, ����� ��������� ���� �������� �������");return 1;}
	if (SkinChangeMode[playerid] == 1) return SendClientMessage(playerid,COLOR_RED,"������: ������ ������� ���������� ��� ������ ������ ���������");
	if (playerid == clickedplayerid)
	{//���� ������� ��� �� ����
		ShowPlayerDialog(playerid, 2, 2, "���� �������� �������", "����� � ������ [����� 1]\n����� � ������ [����� 2]\n����� � ������ [����� 3]\n������ JetPack (/jetpack)\n�������� � ��������� (/skydive)\n{FF0000}GPS (/gps){FFFFFF}\n�������� ��� ����������\n�������� ��� ������\n��������� PvP\n{FFFF00}������� ���", "��", "");
	}//���� ������� ��� �� ����
	else
	{//������� �� ������� ������
		new pname[24];GetPlayerName(clickedplayerid, pname, sizeof(pname));
		if (Player[playerid][Prestige] < 5) ShowPlayerDialog(playerid, DIALOG_TABMENU, 2, pname, "���������� ������\n���������� ����� ������\n��������� ��������� ������\n�������� ������ ������\n������� �� ����� (PvP)\n{007FFF}���������� ������ � ����\n{FF0000}�������� ����� ����� ������", "��", "������");
		else ShowPlayerDialog(playerid, DIALOG_TABMENU, 2, pname, "���������� ������\n���������� ����� ������\n��������� ��������� ������\n�������� ������ ������\n������� �� ����� (PvP)\n{007FFF}���������� ������ � ����\n{FF0000}�������� ����� ����� ������\n{008D00}����������������� � ������", "��", "������");
		ClickedPid[playerid] = clickedplayerid;
	}//������� �� ������� ������
	return 1;
}


public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
    //������� ���� ���������������� � OnPlayerWeaponShot, �������� ������ � OnPlayerGiveDamage.
	if (!IsPlayerConnected(issuerid) || issuerid == playerid) {Player[playerid][PHealth] -= amount; return 1;}//������� ���� �� �� ������� ������ (�������� ������� � ������ ��� ������ ������ � ��������������)

	//------- ���� ���� ��������� �����, ����������� �� �������(!) ������
	if ((weaponid == 51 || weaponid == 37 || weaponid == 49 || weaponid == 50) || ((weaponid == 31 || weaponid == 38) && IsPlayerInAnyVehicle(issuerid)) || (GetPlayerState(issuerid) == 2 && (weaponid == 28 || weaponid == 29 || weaponid == 32)))
	{//������, �����, �� �� ������, �� �� ���������, ������ �� ����. ����������
		if (InPeacefulZone[playerid] == 1 || InPeacefulZone[issuerid] == 1)
		{//� ������ ����
			SetPlayerArmedWeapon(issuerid,0); ApplyAnimation(issuerid,"PED","KO_SKID_BACK",4.0,0,0,0,0,0,1);
			if (IsPlayerInAnyVehicle(issuerid)) RemovePlayerFromVehicle(issuerid);
			return SendClientMessage(issuerid, COLOR_RED, "������ ������� � ������ ����!");
		}//� ������ ����
		if (PrestigeGM[issuerid] == 1)
		{//������ ������� ���� �� � ������ ����
		    if (InEvent[issuerid] == 0)
			{//�� � �������������
			    if (IsPlayerInAnyVehicle(issuerid)) RemovePlayerFromVehicle(issuerid);
    			ApplyAnimation(issuerid,"PED","KO_SKID_BACK",4.0,0,0,0,0,0,1);
				return SendClientMessage(issuerid,COLOR_RED,"��������� ������������ ������� � ������ ����");
			}//�� � �������������
		}//������ ������� ���� �� � ������ ����
		if (Player[playerid][PHealth] <= 0.0) return 1;//�����, �������� ������� ����, ��� �����
		if (NOPSetPlayerHealth[issuerid] > 5 || NOPSetPlayerArmour[issuerid] > 5) return SendClientMessage(issuerid, COLOR_RED, "���� �������� ��� ����� �������������������! ���� �� ������ ������ �� ��������.");

		//���� ��������� �����
		if (Player[playerid][PArmour] > amount) Player[playerid][PArmour] -= amount;
		else
		{//���� ����� ������, ��� ��������� ����
		    amount -= Player[playerid][PArmour];
			Player[playerid][PHealth] -= amount; Player[playerid][PArmour] = 0.0;
		}//���� ����� ������, ��� ��������� ����

		SetPlayerHealth(playerid, Player[playerid][PHealth]);
		SetPlayerArmour(playerid, Player[playerid][PArmour]);
		//���������� ������ �� ���� �� ������� ��������� ����
		LastDamageFrom[playerid] = issuerid;


		if (Player[playerid][PHealth] <= 1.0 && IsPlayerConnected(issuerid) && issuerid != playerid)
		{//�������� ������
			OnPlayerDeathFromPlayer(playerid, issuerid, weaponid);
	        SetPlayerHealth(playerid,0.0);//����� �� ���� ���� � ����������� ������ (�� ����������� OnPlayerDeath). �� � ����� ������.
		}//�������� ������
	}//������, �����, �� �� ������, �� �� ���������, ������ �� ����. ����������

	return 1;
}

public OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart)
{
 	//new szString[140];
    //format(szString, sizeof(szString), "GiveDamage | playerid: %i   damagedid: %i   amount: %0.2f   weaponid: %i   bodypart: %i", playerid, damagedid, amount, weaponid, bodypart);
    //SendClientMessageToAll(-1, szString);

    if (weaponid < 0 || weaponid > 15) return 1;//���� �� ���� ���������������� � OnPlayerWeaponShot, ��������� ���� � TakeDamage
    //����� GiveDamage ���� ������ ���� �� ��������� ������
    if (weaponid > 0 && Weapons[playerid][weaponid] == 0) return 1;//���� �� ������������� ������
    new Float: fX, Float: fY, Float: fZ; GetPlayerPos(damagedid, fX, fY, fZ);
	new Float: fDistance = GetPlayerDistanceFromPoint(playerid, fX, fY, fZ); if (fDistance > 3) return 1;//���������� ����� �������� ������� ������� (�� ����� ������ �������� ������)
	if (Player[damagedid][PHealth] <= 0.0) return 1;//�����, �������� ������� ����, ��� �����
	if (LAFK[damagedid] > 3 ||  LAFK[playerid] > 3) return 1;//�����, �������� ������� ����, ��� ������ 3 ��� ��������� ���� � ��� (���)
	if (InPeacefulZone[damagedid] == 1 || InPeacefulZone[playerid] == 1)
	{//� ������ ����
		SetPlayerArmedWeapon(playerid,0); ApplyAnimation(playerid,"PED","KO_SKID_BACK",4.0,0,0,0,0,0,1);
		return SendClientMessage(playerid, COLOR_RED, "������ ������� � ������ ����!");
	}//� ������ ����
	if (PrestigeGM[playerid] == 1)
	{//������ ������� ���� �� � ������ ����
	    if (InEvent[playerid] == 0)
		{//�� � �������������
			ApplyAnimation(playerid,"PED","KO_SKID_BACK",4.0,0,0,0,0,0,1);
			return SendClientMessage(playerid,COLOR_RED,"��������� ������������ ������� � ������ ����");
		}//�� � �������������
	}//������ ������� ���� �� � ������ ����
	if (NOPSetPlayerHealth[playerid] > 5 || NOPSetPlayerArmour[playerid] > 5) return SendClientMessage(playerid, COLOR_RED, "���� �������� ��� ����� �������������������! ���� �� ������ ������ �� ��������.");


	amount = ColdWeaponDamage[weaponid];//�������� �������� ����� �� ������ �������� ���
	//------------- ��������� ���������� �����
	if (InEvent[playerid] > 0)
	{//����� � �������������
		if (ZMStarted[damagedid] > 0)
		{//�����-���������
			if (ZMStarted[playerid] == 1 && ZMIsPlayerIsZombie[playerid] == 0 && ZMIsPlayerIsZombie[damagedid] == 0) return SendClientMessage(playerid,COLOR_RED,"�� ����� �����!");
			if (ZMIsPlayerIsZombie[playerid] > 0 && weaponid != 0) return ResetPlayerWeapons(playerid);
			if (ZMIsPlayerIsZombie[playerid] > 0 && ZMIsPlayerIsZombie[damagedid] == 0) amount = 35;//����� ������� �� 35 ����� �� ����
			if (ZMIsPlayerIsTank[playerid] > 0  && ZMIsPlayerIsZombie[damagedid] == 0) amount = 65;//������� ������� �� 65 ����� �� ����
		}//�����-���������
    }//����� � �������������
	//------------- ��������� ���������� �����

	//------------- ��������� ����� � ��������
	if (Player[damagedid][PArmour] > amount) Player[damagedid][PArmour] -= amount;
	else
	{//���� ����� ������, ��� ��������� ����
	    amount -= Player[damagedid][PArmour];
		Player[damagedid][PHealth] -= amount; Player[damagedid][PArmour] = 0.0;
	}//���� ����� ������, ��� ��������� ����
	SetPlayerHealth(damagedid, Player[damagedid][PHealth]);
	SetPlayerArmour(damagedid, Player[damagedid][PArmour]);
	//���������� ������ �� ���� �� ������� ��������� ����
	LastDamageFrom[damagedid] = playerid;

	if (Player[damagedid][PHealth] <= 1.0)
	{//�������� ������
		OnPlayerDeathFromPlayer(damagedid, playerid, weaponid);
        SetPlayerHealth(damagedid,0.0);//����� �� ���� ���� � ����������� ������ (�� ����������� OnPlayerDeath)
	}//�������� ������
	//------------- ��������� ����� � ��������

	return 1;
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{//�������� �� �������������� ������ ������ ��� � ������������� �����
 	//new szString[140];
    //format(szString, sizeof(szString), "SHOT | playerid: %i   weaponid: %i   hittype: %i   hitid: %i   pos: %f, %f, %f", playerid, weaponid, hittype, hitid, fX, fY, fZ);
    //SendClientMessageToAll(-1, szString);

    //���� ���� ����� �������� �� ��, ��� ������� �� ������ �����
    if ((weaponid < 22 || weaponid > 34) && weaponid != 38) return 0;//������� ������ �� � �������������� ������.
	if (Weapons[playerid][weaponid] == 0) return 0;//������� �� ������������� ������
    if (hittype == BULLET_HIT_TYPE_PLAYER && (!(-10.0 < fX < 10.0) || !(-10.0 < fY < 10.0) || !(-10.0 < fZ < 10.0))) return 0; //Anti Bullet Crasher
	new Float: amount = WeaponShotDamage[weaponid];//�������� �������� ����� �� ����
	WeaponShotsLastSecond[playerid]++;//+1 � ���-�� ��������� �� ��������� �������
	if (WeaponShotsLastSecond[playerid] > WeaponShotsPerSecond[weaponid])  return 0; //��������� ����. ���-�� ��������� �� 1 �������

    if (InPeacefulZone[playerid] == 1)
	{//� ������ ����
		SetPlayerArmedWeapon(playerid,0); ApplyAnimation(playerid,"CRACK","crckdeth1",4.1,0,0,0,0,1,1);
		SendClientMessage(playerid, COLOR_RED, "������ ������� � ������ ����!"); return 0;
	}//� ������ ����
	if (PrestigeGM[playerid] == 1)
	{//������ ������� ���� �� � ������ ����
	    if (InEvent[playerid] == 0)
		{//�� � �������������
			SetPlayerArmedWeapon(playerid,0); ApplyAnimation(playerid,"CRACK","crckdeth1",4.1,0,0,0,0,1,1);
			SendClientMessage(playerid,COLOR_RED,"��������� ������������ ������� � ������ ����"); return 0;
		}//�� � �������������
	}//������ ������� ���� �� � ������ ����

    new Float: var; GetPlayerLastShotVectors(playerid, var, var, var, fX, fY, fZ);
    if (GetPlayerDistanceFromPoint(playerid, fX, fY, fZ) > 300) return 1;//���������� ������ ���� ������� ������� (� ����� ������ ����� ��������� ������� 225)
	if (weaponid >= 25 && weaponid <= 27 && GetPlayerDistanceFromPoint(playerid, fX, fY, fZ) > 35) return 1;//������� ������� ���������� ��� ���������

	if(hittype == 1 && hitid != playerid || IsPlayerConnected(hitid) && Player[hitid][PHealth] > 0.0)
	{//������� �� ������� ������
	    if (GetPlayerDistanceFromPoint(hitid, fX, fY, fZ) > 5) return 1;//������ ��� ���, ���� ������ ����
	    if (weaponid == 38 && Player[hitid][Level] < 60 && InEvent[hitid] == 0) //�������� � �������� �� ������ ���� 40 ���
			{SendClientMessage(playerid,COLOR_RED,"� �������� ������ ������� �������, �� ��������� 60-�� ������!"); SetPlayerArmedWeapon(playerid, 0);  return 0;}
        if (LAFK[hitid] > 3 ||  LAFK[playerid] > 3) return 1;//�����, �������� ������� ����, ��� ����� ��� AFK ��� ������� ���� �� ��� (���)
        if (Player[hitid][PHealth] <= 0.0) return 1;//�����, �������� ������� ����, ��� �����
 		if (NOPSetPlayerHealth[playerid] > 5 || NOPSetPlayerArmour[playerid] > 5) return SendClientMessage(playerid, COLOR_RED, "���� �������� ��� ����� �������������������! ���� �� ������ ������ �� ��������.");


		//��������� ���������� �����
		if (InEvent[playerid] > 0)
		{//����� � �������������
			if(InEvent[playerid] == EVENT_DM && (DMid == 9 || DMid == 11)) amount = 500;//�� �� ���������, �����
			if (ZMStarted[playerid] == 1 && ZMStarted[hitid] == 1)
			{//�����-���������
			    if (ZMIsPlayerIsZombie[playerid] > 0 || ZMIsPlayerIsTank[playerid] > 0) {ResetPlayerWeapons(playerid); return 0;} //��������, ������ ����� ��� ������
 				if (ZMIsPlayerIsZombie[playerid] == 0 && ZMIsPlayerIsZombie[hitid] == 0) {SendClientMessage(playerid,COLOR_RED,"�� ��������� �� �����!"); return 0;}
			}//�����-���������
	    }//����� � �������������
        //��������� ���������� �����
        
        //------------- ��������� ����� � ��������
		if (Player[hitid][PArmour] > amount) Player[hitid][PArmour] -= amount;
		else
		{//���� ����� ������, ��� ��������� ����
		    amount -= Player[hitid][PArmour];
			Player[hitid][PHealth] -= amount; Player[hitid][PArmour] = 0.0;
		}//���� ����� ������, ��� ��������� ����
		//���������� ������ �� ���� �� ������� ��������� ����
		LastDamageFrom[hitid] = playerid;

		if (Player[hitid][PHealth] <= 1.0)
		{//�������� ������
			OnPlayerDeathFromPlayer(hitid, playerid, weaponid);
	        SetPlayerHealth(hitid,0.0);//����� �� ���� ���� � ����������� ������ (�� ����������� OnPlayerDeath)
		}//�������� ������
		//------------- ��������� ����� � ��������
	}//������� �� ������� ������
	
	if(hittype == 2 && hitid > 35 && hitid <= MAX_VEHICLES && Vehicle[hitid][Health] > 0.0)
	{//������� �� ���������� (����� ���� ��� �����)
        Vehicle[hitid][Health] -= amount;
	}//������� �� ���������� (����� ���� ��� �����)
    
    return 1;
}//�������� �� �������������� ������ ������ ��� � ������������� �����

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strlen(cmdtext) > 140) return 1;//������ �� �������� �������� ��������� ��� ������ ���������� �����
    new idx, cmd[20], params[137];
	idx = strfind(cmdtext, " ", true);//������� ������� �������. ���������� -1 ���� ������� �� ����
	if (idx == -1) return SendCommand(playerid, cmdtext, "");
	strmid(cmd, cmdtext, 0, idx); strmid(params, cmdtext, idx + 1, 140);
	return SendCommand(playerid, cmd, params);
}

stock SendCommand(playerid, cmd[], params[])
{
	for(new i = 0; i < strlen(cmd); i++)
	{//����������� ����� ��������� ������
		if (cmd[i] > 64 && cmd[i] < 91) {cmd[i] += 32; continue;} //��������� ������� ���� eng
		if (cmd[i] > 191 && cmd[i] < 224) cmd[i] += 32;//��������� ������� ���� rus
		if (cmd[i] >= 224 && cmd[i] <= 255)
		{//��������� ������� ����� ���� ����������� �� ���������� �� ��������� ���������� (��� ����� ������ �� ������� ������ /pm - /�� � ��
		    switch (cmd[i])
		    {
		    	case 233: cmd[i] = 113; /*� - q*/ case 246: cmd[i] = 119; /*� - w*/ case 243: cmd[i] = 101; /*� - e*/ case 234: cmd[i] = 114; /*� - r*/
                case 229: cmd[i] = 116; /*� - t*/ case 237: cmd[i] = 121; /*� - y*/ case 227: cmd[i] = 117; /*� - u*/ case 248: cmd[i] = 105; /*� - i*/
				case 249: cmd[i] = 111; /*� - o*/ case 231: cmd[i] = 112; /*� - p*/ case 244: cmd[i] = 97; /*� - a*/  case 251: cmd[i] = 115; /*� - s*/
				case 226: cmd[i] = 100; /*� - d*/ case 224: cmd[i] = 102; /*� - f*/ case 239: cmd[i] = 103; /*� - g*/ case 240: cmd[i] = 104; /*� - h*/
				case 238: cmd[i] = 106; /*� - j*/ case 235: cmd[i] = 107; /*� - k*/ case 228: cmd[i] = 108; /*� - l*/ case 255: cmd[i] = 122; /*� - z*/
				case 247: cmd[i] = 120; /*� - x*/ case 241: cmd[i] = 99; /*� - cv*/ case 236: cmd[i] = 118; /*� - v*/ case 232: cmd[i] = 98; /*� - b*/
				case 242: cmd[i] = 110; /*� - n*/ case 252: cmd[i] = 109; /*� - m*/
		    }
		}//��������� ������� ����� ���� ����������� �� ���������� �� ��������� ���������� (��� ����� ������ �� ������� ������ /pm - /�� � ��
	}//����������� ����� ��������� ������

	#include "Transformer\Commands.inc"
	#include "Transformer\ACommands.inc"
	return SendClientMessage(playerid, COLOR_WHITE, "SERVER: ����������� �������. ����������� {FF0000}/commands {FFFFFF}����� ���������� ������ ������.");
}

public OnPlayerEnterDynamicCP(playerid, checkpointid)//checkpointid
{
	return 1;
}







//------------ LAC: AntiNOP RemovePlayerFromVehicle
forward AntiRemovePlayerFromVehicle(playerid);
public AntiRemovePlayerFromVehicle(playerid)
{

	/*if (GetPlayerState(playerid) == 2)//� ����
		{
			new CheaterName[30], String[120];CheaterName = GetName(playerid);
			format(String,sizeof(String), "{FF0000}LAC: {AFAFAF}%s ��� ������ � �������. {FF0000}�������:{AFAFAF} �������� ��� NOP: RemovePlayerFromVehicle",CheaterName);
			SendClientMessageToAll(COLOR_GREY,String);print(String);
			Kick(playerid);
		}*/
}
//------------ LAC: AntiNOP RemovePlayerFromVehicle

//------------ SpawnStyle
forward SpawnStylePub(playerid);
public SpawnStylePub(playerid)
{//������ ����
	if (Logged[playerid] == 1 && Player[playerid][Level] > 0 && FirstSobeitCheck[playerid] == 0)
	{//������ ��������� �������� �� Sobeit
        FirstSobeitCheckTimer[playerid] = SetTimerEx("SobeitCamCheck", 4000, 0, "i", playerid);
		SetCameraBehindPlayer(playerid); //������ ���������� ������
		TextDrawShowForPlayer(playerid, BlackScreen);//������ �����
		SelectTextDraw(playerid, 0x00FF00FF); FirstSobeitCheck[playerid] = 1;
		return SendClientMessage(playerid, COLOR_RED, "LAC: {AFAFAF}�������� �������� ������� �� ������� �����. ����������, ���������...");
	}//������ ��������� �������� �� Sobeit
	
	if (FirstSobeitCheck[playerid] < 3) return 1; //���� �� ������ �������� �� ������
	else TextDrawHideForPlayer(playerid, BlackScreen);//������� ������ ����� �� �������� �� sobeit
	
	if (InEvent[playerid] > 0 && JoinEvent[playerid] > 0) return 1;
	if (Player[playerid][SpawnStyle] == 1)
	{//����� �� ���� ������ 1
		CallCar1(playerid);//����� ���� ������ 1
	}//����� �� ���� ������ 1
	if (Player[playerid][SpawnStyle] == 2)
	{//����� �� ���� ������ 2
		CallCar2(playerid);//����� ���� ������ 2
	}//spawn �� ���� ������ 2
	if (Player[playerid][SpawnStyle] == 3)
	{//����� � ���������
		new Float:x;new Float:y;new Float:z;GiveWeapon(playerid,46,1);
		GetPlayerPos(playerid,x,y,z);SetPlayerPos(playerid,x,y,z+1300);
		GiveWeapon(playerid,46,1);SkydiveTime[playerid] = 60;
	}//����� � ���������
	if (Player[playerid][SpawnStyle] == 4)
	{//����� �� ���� ������ 3
		CallCar3(playerid);//����� ���� ������ 3
	}//spawn �� ���� ������ 3
	if (Player[playerid][SpawnStyle] == 5)
	{//����� �� ��������
	    JetpackUsed[playerid] = 1;SetPlayerSpecialAction(playerid,SPECIAL_ACTION_USEJETPACK);
	}//����� �� ��������
	if (OnStartEvent[playerid] == 0) GiveMyGunWeapons(playerid);//�������� ������� ������
	if (Logged[playerid] > 0) SetCameraBehindPlayer(playerid);
	if (WorldSpawn[playerid] > 0) SetPlayerVirtualWorld(playerid, WorldSpawn[playerid]); //����� � ������ � � ����� ����� �������� ������ ���
	if (Logged[playerid] == 0) SetPlayerVirtualWorld(playerid,playerid+1);
	SetPlayerHealth(playerid,100);
return 1;
}//����� ����
//------------ SpawnStyle

stock GiveMyGunWeapons(playerid)
{
    new ammo;
	if (Player[playerid][Slot1] > 0) GiveWeapon(playerid,Player[playerid][Slot1],1);//���� 1 - ���������, ������, ��������
	if (Player[playerid][Slot2] > 0)
	{//���� 2 - ���������
		GiveWeapon(playerid,Player[playerid][Slot2],1);
		if (Player[playerid][Level] < 31) ammo = 70;
		else if (Player[playerid][Level] < 71) ammo = 140;
		else if (Player[playerid][Level] < 82) ammo = 210;
		else if (Player[playerid][Level] < 92) ammo = 280;
		else ammo = 20000;
		SetPlayerAmmo(playerid, Player[playerid][Slot2], ammo);
	}//���� 2 - ���������
	if (Player[playerid][Slot3] > 0)
	{//���� 3 - ���������
		GiveWeapon(playerid,Player[playerid][Slot3],1);
		if (Player[playerid][Level] < 33) ammo = 28;
		else if (Player[playerid][Level] < 72) ammo = 56;
		else if (Player[playerid][Level] < 83) ammo = 84;
		else if (Player[playerid][Level] < 93) ammo = 112;
		else ammo = 20000;
		SetPlayerAmmo(playerid, Player[playerid][Slot3], ammo);
	}//���� 3 - ���������
	if (Player[playerid][Slot4] > 0)
	{//���� 4 - ��
		GiveWeapon(playerid,Player[playerid][Slot4],1);
		if (Player[playerid][Level] < 37) ammo = 500;
		else if (Player[playerid][Level] < 73) ammo = 1000;
		else if (Player[playerid][Level] < 84) ammo = 1500;
		else if (Player[playerid][Level] < 94) ammo = 2000;
		else ammo = 20000;
		SetPlayerAmmo(playerid, Player[playerid][Slot4], ammo);
	}//���� 4 - ��
	if (Player[playerid][Slot5] > 0)
	{//���� 5 - ��������
		GiveWeapon(playerid,Player[playerid][Slot5],1);
		if (Player[playerid][Level] < 41) ammo = 90;
		else if (Player[playerid][Level] < 74) ammo = 180;
		else if (Player[playerid][Level] < 86) ammo = 270;
		else if (Player[playerid][Level] < 95) ammo = 360;
		else ammo = 20000;
		SetPlayerAmmo(playerid, Player[playerid][Slot5], ammo);
	}//���� 5 - ��������
	if (Player[playerid][Slot6] > 0)
	{//���� 6 - ��������
	    if (Player[playerid][Slot6] == 34 && Player[playerid][Karma] <= -800) SendClientMessage(playerid, COLOR_RED, "����������� �������� �� ������ ��-�� ������� ������ �����.");
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
	}//���� 6 - ��������
	if (Player[playerid][Slot7] == 35)
	{//���� 7 - RPG
		GiveWeapon(playerid,35,1);
		if (Player[playerid][Level] < 46) ammo = 10;
		else if (Player[playerid][Level] < 79) ammo = 20;
		else if (Player[playerid][Level] < 89) ammo = 30;
		else if (Player[playerid][Level] < 98) ammo = 40;
		else ammo = 20000;
		SetPlayerAmmo(playerid, Player[playerid][Slot7], ammo);
	}//���� 7 - RPG
	if (Player[playerid][Slot7] == 38)
	{//���� 7 - �������
		GiveWeapon(playerid,38,1);
		if (Player[playerid][Level] < 82) ammo = 1000;
		else if (Player[playerid][Level] < 81) ammo = 2000;
		else if (Player[playerid][Level] < 99) ammo = 3000;
		else ammo = 20000;
		SetPlayerAmmo(playerid, Player[playerid][Slot7], ammo);
	}//���� 7 - �������
	if (Player[playerid][Slot8] > 0 && Player[playerid][Slot8] != 18)
	{//���� 8 - ����������� (����� ��������)
		GiveWeapon(playerid,Player[playerid][Slot8],1);
		if (Player[playerid][Level] < 43) ammo = 10;
		else if (Player[playerid][Level] < 76) ammo = 20;
		else if (Player[playerid][Level] < 87) ammo = 30;
		else if (Player[playerid][Level] < 96) ammo = 40;
		else ammo = 20000;
		SetPlayerAmmo(playerid, Player[playerid][Slot8], ammo);
	}//���� 8 - ����������� (����� ��������)
	//Player[playerid][Slot9] ������������ ��� ����� �����
	if (Player[playerid][Slot10] > 0)
	{//������
		if(Player[playerid][Slot10] == 46){GiveWeapon(playerid,46,1);}
		if(Player[playerid][Slot10] == 42){GiveWeapon(playerid,42,20000);}
	}//������
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
    SendClientMessage(playerid,COLOR_YELLOW,"������������ �����������. ����������, ���������..");
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
{//---------- TextDraw � �������
	if (LSpecID[playerid] != -1)
	{//����� gid ������ �� ���-��
        SetTimerEx("SpecTextDrawPub" , 500, false, "i", playerid);
		TextDrawHideForPlayer(playerid, SpecInfo[playerid]);
		TextDrawHideForPlayer(playerid, SpecInfoVeh[playerid]);
		LSpecCanFastChange[playerid] = 1;//�������� ������� ����� ID ����� ���������
		new vid = LSpecID[playerid], String[240], pname[24];
		GetPlayerName(vid, pname, sizeof(pname));
		new Float: hp;GetPlayerHealth(vid, hp);new Float: arm;GetPlayerArmour(vid, arm);
		new hpX = floatround(hp, floatround_round);new armX = floatround(arm, floatround_round);new vehX;
		new ammo = GetPlayerAmmo(vid);new weaponname[48];GetWeaponName(GetPlayerWeapon(vid),weaponname,sizeof(weaponname));
		if(IsPlayerInAnyVehicle(vid))
		{//���� ����� � ����
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
		}//���� ����� � ����
		else
		{//����� ������
			if (GetPlayerWeapon(vid) == 0) format(String,sizeof(String),"~Y~Player: ~W~%s~Y~[%~W~%d~Y~]    ~Y~Level: ~W~%d    ~Y~Health: ~W~%d    ~Y~Armour: ~W~%d",pname, vid, Player[vid][Level], hpX, armX); //��� ������
			else if ( 15 < GetPlayerWeapon(vid) < 39) format(String,sizeof(String),"~Y~Player: ~W~%s~Y~[%~W~%d~Y~]    ~Y~Level: ~W~%d    ~Y~Health: ~W~%d    ~Y~Armour: ~W~%d    ~Y~Weapon: ~W~%s ~Y~(~W~%d~Y~)",pname, vid, Player[vid][Level], hpX, armX, weaponname, ammo); //������ � ���������
			else format(String,sizeof(String),"~Y~Player: ~W~%s~Y~[%~W~%d~Y~]    ~Y~Level: ~W~%d    ~Y~Health: ~W~%d    ~Y~Armour: ~W~%d    ~Y~Weapon: ~W~%s",pname, vid, Player[vid][Level], hpX, armX, weaponname); //������, � ������� �� ����� ������� �� ���-��� ��������
			TextDrawSetString(SpecInfo[playerid], String);TextDrawShowForPlayer(playerid, SpecInfo[playerid]);
		}//����� ������
	}//����� gid ������ �� ���-��
	else{TextDrawHideForPlayer(playerid, SpecInfo[playerid]);TextDrawHideForPlayer(playerid, SpecInfoVeh[playerid]);}
	return 1;
}//---------- TextDraw � �������


public ParaEnd(playerid)
{
    new Float: x, Float: y, Float: z, Float:a;GetPlayerPos(playerid,x,y,z);GetPlayerFacingAngle(playerid,a);
	SetPlayerPosFindZ(playerid,x,y,z);SendClientMessage(playerid,COLOR_YELLOW,"�� ������� ������������.");
	ApplyAnimation(playerid,"PED","FALL_land",4.1,0,0,0,0,1,1);SetPlayerChatBubble(playerid, "�����������", COLOR_GREEN, 100.0, 3000);
	return 1;
}

stock ShowStats(playerid,targetid)
{
	if (Logged[playerid] == 0) return SendClientMessage(playerid,COLOR_RED,"������: �� ������ ����������������, ����� ������������� ����������");
	new String[1500] = "", String2[240], PName[24], clanid = Player[targetid][MyClan];
	GetPlayerName(targetid, PName, sizeof(PName));
	format(String2,sizeof(String2),"{FFFF00}���������� ������ {FFFFFF}%s\n",PName);

    if (Player[targetid][Admin] == 0) format(String2,sizeof(String2),"{FFFF00}���������� ������ {FFFFFF}%s\n",PName);
	if (Player[targetid][Admin] == 1){format(String2,sizeof(String2),"{FFFF00}���������� ������ {FFFFFF}%s [{66CDAA}���������{FFFFFF}]\n",PName);}
	if (Player[targetid][Admin] == 2){format(String2,sizeof(String2),"{FFFF00}���������� ������ {FFFFFF}%s [{9ACD32}�����-���������{FFFFFF}]\n",PName);}
	if (Player[targetid][Admin] == 3){format(String2,sizeof(String2),"{FFFF00}���������� ������ {FFFFFF}%s [{00BFFF}�������������{FFFFFF}]\n",PName);}
	if (Player[targetid][Admin] == 4){format(String2,sizeof(String2),"{FFFF00}���������� ������ {FFFFFF}%s [{FF7F50}������� �������������{FFFFFF}]\n",PName);}
		
	if (clanid > 0){format(String2,sizeof(String2),"{FFFF00}���������� ������ {FFFFFF}[{008E00}%s{FFFFFF}] %s\n",Clan[clanid][cName],PName);}
	if (clanid > 0 && Player[targetid][Admin] == 1){format(String2,sizeof(String2),"{FFFF00}���������� ������ {FFFFFF}[{008E00}%s{FFFFFF}] %s [{66CDAA}���������{FFFFFF}]\n",Clan[clanid][cName],PName);}
	if (clanid > 0 && Player[targetid][Admin] == 2){format(String2,sizeof(String2),"{FFFF00}���������� ������ {FFFFFF}[{008E00}%s{FFFFFF}] %s [{9ACD32}�����-���������{FFFFFF}]\n",Clan[clanid][cName],PName);}
	if (clanid > 0 && Player[targetid][Admin] == 3){format(String2,sizeof(String2),"{FFFF00}���������� ������ {FFFFFF}[{008E00}%s{FFFFFF}] %s [{00BFFF}�������������{FFFFFF}]\n",Clan[clanid][cName],PName);}
	if (clanid > 0 && Player[targetid][Admin] == 4){format(String2,sizeof(String2),"{FFFF00}���������� ������ {FFFFFF}[{008E00}%s{FFFFFF}] %s [{FF7F50}������� �������������{FFFFFF}]\n",Clan[clanid][cName],PName);}
	strcat(String, String2);
	
 	new hours = Player[targetid][Time] / 3600;
	if (hours > 0) format(String2,sizeof(String2),"{AFAFAF}[�� ������� ���������: {FFFFFF}%d{AFAFAF} �����]\n", hours);
	else format(String2,sizeof(String2),"{AFAFAF}[�� ������� ���������: ����� ������ ����]\n", hours);
	strcat(String, String2);

	if (Player[targetid][Prestige] > 0 && Player[targetid][GPremium] == 0){format(String2,sizeof(String2),"{FFFF00}[������� {FFFFFF}%d{FFFF00}-�� ������]\n",Player[targetid][Prestige]);strcat(String, String2);}
	if (Player[targetid][Prestige] == 0 && Player[targetid][GPremium] > 0){format(String2,sizeof(String2),"{FFFF00}[ViP {FFFFFF}%d{FFFF00}-�� ������]\n",Player[targetid][GPremium]);strcat(String, String2);}
	if (Player[targetid][Prestige] > 0  && Player[targetid][GPremium] > 0){format(String2,sizeof(String2),"{FFFF00}[������� {FFFFFF}%d{FFFF00}-�� ������] {FFFF00}[ViP {FFFFFF}%d{FFFF00}-�� ������]\n",Player[targetid][Prestige],Player[targetid][GPremium]);strcat(String, String2);}
	
    if (Player[targetid][Banned] != 0)
    {//������� �������
        format(String2,sizeof(String2),"\n{FF0000}������� ������������. ��� �����: {FFFFFF}%s\n{FF0000}�������: {FFFFFF}%s\n", BannedBy[targetid], BanReason[targetid]);
        strcat(String, String2);
    }//������� �������
    
    if (Player[targetid][Muted] != 0)
    {//� ������ ������� ����
        if (Player[targetid][Muted] > 0) format(String2,sizeof(String2),"\n{FF0000}��� ������������. ������� �����: {FFFFFF}%s\n{FF0000}���������� ����� ����� ����� {FFFFFF}%d {FF0000}�����.\n", MutedBy[targetid], Player[targetid][Muted]/60 + 1); //������� ���
        else format(String2,sizeof(String2),"\n{FF0000}��� ������������. ������� �����: {FFFFFF}%s\n{FF0000}���������� ������ �� �������������� ����.\n", MutedBy[targetid]); //��������
        strcat(String, String2);
    }//� ������ ������� ����
    
    if (Player[targetid][GiveCashBalance] >= 100000000)
    {//������� - ������� �� 100�� ������ �����, ��� �����
        strcat(String, "\n{FF0000}�������: ���� ����� ������� �� ������ ������� ������� ������ �����, \n��� �����. �� ������ �� ����� �������� ������ �� �������.\n");
    }//������� - ������� �� 100�� ������ �����, ��� �����

    if (Player[targetid][Level] > 0 && (Player[targetid][Level] < 100 || Player[targetid][Prestige] >= 10))
    {//� ��������
		format(String2,sizeof(String2),"\n{007FFF}XP ������� �� ������: {FFFFFF}%d   {FF8C00}XP �������� �������: {FFFFFF}%d\n",Player[targetid][Exp],NeedXP[targetid] - Player[targetid][Exp]);strcat(String, String2);
		new kef = 100;if (Player[targetid][GPremium] >= 1) kef = 135; if (Player[targetid][GPremium] >= 5) kef = 160; if (Player[targetid][GPremium] >= 8) kef = 180; if (Player[targetid][GPremium] >= 10) kef = 200;
		if (Player[targetid][GPremium] >= 12) kef = 225; if (Player[targetid][GPremium] >= 15) kef = 250; if (Player[targetid][GPremium] >= 17) kef = 275; if (Player[targetid][GPremium] >= 20) kef = 300;

		if (Player[targetid][GPremium] < 11) format(String2,sizeof(String2),"{AFAFAF}XP ������� �� ���� ���: {FFFFFF}%d   {AFAFAF}����� XP � ���:{FFFFFF} %d\n",Player[targetid][LastHourExp] * kef / 100, kef * 50);
		else format(String2,sizeof(String2),"{AFAFAF}XP ������� �� ���� ���: {FFFFFF}%d\n",Player[targetid][LastHourExp] * kef / 100);
 		strcat(String, String2);
 		format(String2,sizeof(String2),"{AFAFAF}�������� XP �� ����� �� ���� ���: {FFFFFF}%d\n\n",Player[targetid][LastHourReferalExp]);
 		strcat(String, String2);
	}//� ��������

	if (Player[playerid][Admin] >= 4 || playerid == targetid) format(String2,sizeof(String2),"{FFFF00}�������: {FFFFFF}%d   {FFFF00}�����: {FFFFFF}%d$   {FFFF00}����: {FFFFFF}%d$   {FFFF00}������: {FFFFFF}%d\n",Player[targetid][Level], Player[targetid][Cash], Player[targetid][Bank], Player[targetid][Medals]);
	else format(String2,sizeof(String2),"{FFFF00}�������: {FFFFFF}%d\n",Player[targetid][Level]);
	strcat(String, String2);
	
	if (Player[targetid][Karma] < 0) format(String2,sizeof(String2),"{FFFF00}�����: {FF0000}%d   {FFFF00}������� ���������:{FFFFFF} %d\n", Player[targetid][Karma], Player[targetid][CompletedQuests]);
	else format(String2,sizeof(String2),"{FFFF00}�����: {008E00}+%d   {FFFF00}������� ���������:{FFFFFF} %d\n", Player[targetid][Karma], Player[targetid][CompletedQuests]);
	strcat(String, String2);

	if (Player[targetid][Spawn] == 0)
	{
		if (Player[targetid][Level] < 3){strcat(String, "{FFFF00}����� ������: {FFFFFF}Grove Street   ");}
		if (Player[targetid][Level] >= 3 && Player[targetid][Level] < 15){strcat(String, "{FFFF00}����� ������: {FFFFFF}��� ������   ");}
		if (Player[targetid][Level] >= 15 && Player[targetid][Level] < 25){strcat(String, "{FFFF00}����� ������: {FFFFFF}��� ������   ");}
		if (Player[targetid][Level] >= 25 && Player[targetid][Level] < 73){strcat(String, "{FFFF00}����� ������: {FFFFFF}��� ��������   ");}
		if (Player[targetid][Level] >= 73){strcat(String, "{FFFF00}����� ������: {FFFFFF}���� Chilliad   ");}
	}
	if (Player[targetid][Spawn] == 4){strcat(String, "{FFFF00}����� ������: {FFFFFF}������ ��� (�������)   ");}
	if (Player[targetid][Spawn] == 5){strcat(String, "{FFFF00}����� ������: {FFFFFF}���� �����   ");}
	if (Player[targetid][Spawn] == 6){strcat(String, "{FFFF00}����� ������: {FFFFFF}������ ��� (������)   ");}
	if (Player[targetid][Spawn] == 7){strcat(String, "{FFFF00}����� ������: {FFFFFF}������ ������� (ViP)   ");}
	if (Player[targetid][Spawn] == 8){strcat(String, "{FFFF00}����� ������: {FFFFFF}���� ����� (������)   ");}
	if (Player[targetid][SpawnStyle] == 0){strcat(String, "{FFFF00}����� ������: {FFFFFF}���\n");}
	if (Player[targetid][SpawnStyle] == 1){strcat(String, "{FFFF00}����� ������: {FFFFFF}�� ���� ������ 1\n");}
	if (Player[targetid][SpawnStyle] == 2){strcat(String, "{FFFF00}����� ������: {FFFFFF}�� ���� ������ 2\n");}
	if (Player[targetid][SpawnStyle] == 3){strcat(String, "{FFFF00}����� ������: {FFFFFF}������\n");}
	if (Player[targetid][SpawnStyle] == 4){strcat(String, "{FFFF00}����� ������: {FFFFFF}�� ���� ������ 3\n");}
	if (Player[targetid][SpawnStyle] == 5){strcat(String, "{FFFF00}����� ������: {FFFFFF}�� JetPack\n");}
	
	new veh1[30]; if(Player[targetid][CarSlot1] == 0){veh1 = "";}else{new mid = Player[targetid][CarSlot1] - 400;format(veh1,sizeof(veh1),"%s", PlayerVehicleName[mid]);}
    new veh2[30]; if(Player[targetid][CarSlot2] == 0){veh2 = "";}else{new mid = Player[targetid][CarSlot2] - 400;format(veh2,sizeof(veh2),"%s", PlayerVehicleName[mid]);}
    new veh3[30]; if(Player[targetid][CarSlot3] == 0){veh3 = "";}else{new mid = Player[targetid][CarSlot3] - 400;format(veh3,sizeof(veh3),"%s", PlayerVehicleName[mid]);} if(Player[targetid][CarSlot3] == 539){format(veh3,sizeof(veh3),"%s{9966CC}Uber{007FFF}Vortex");}
    if(strlen(veh1) == 0 && strlen(veh2) == 0 && strlen(veh3) == 0) veh1 = "���";//���� ������ ��� ����������
    format(String2,sizeof(String2),"{FFFF00}���������:{FFFFFF} %s   %s   %s\n", veh1, veh2, veh3);strcat(String, String2);

	ShowPlayerDialog(playerid, 999, 0, "����������", String, "��", "");
	return 1;
}


stock ShowKarma(playerid)
{
	new String[1024], Caption[40];

	if (Player[playerid][Karma] < 0) format(Caption,sizeof Caption,"���� �����: {FF0000}%d", Player[playerid][Karma]);
	else format(Caption,sizeof Caption,"���� �����: {008E00}+%d", Player[playerid][Karma]);

	strcat(String, "{FFFF00}������ � ������ �����:\n{008E00}");

    strcat(String, "+800 � ����: ��������� ������� ���������� ������� � ��� ����.\n");
    strcat(String, "+600 � ����: ������� � ����� ���������.\n");
	strcat(String, "+400 � ����: ������� {FFFFFF}/skydive{008E00} ���������.{FF0000}\n\n");

    strcat(String, "-400 � ����: ����������� ����������.\n");
    strcat(String, "-600 � ����: ����� ����������.\n");
    strcat(String, "-800 � ����: ����������� �������� ����������.\n");
    
    strcat(String, "\n{FFFF00}���� ����� ���������� �������������� ������ ��������� �� �������.\n");
    strcat(String, "{008E00}+ ������������� �� ��������, ���� �� ������ ���� ����� � ������ �� ��������.\n");
    strcat(String, "{FF0000}- ����������� ����� �� �������� ������ ������� �� ��������� ������������.\n");

	ShowPlayerDialog(playerid, 999, 0, Caption, String, "��", "");
	return 1;
}

stock ShowPInfo(playerid, targetid)
{
	if (Player[playerid][Admin] < Player[targetid][Admin]) return 1;//������ ���� �������� �� ����� �������� ���� ���������� ������, ����� ��� � �����
	new String[1500] = ""; new String2[240]; new PName[24];	GetPlayerName(targetid, PName, sizeof(PName));
	format(String2,sizeof(String2),"{FFFF00}������� ������ ������ {FFFFFF}%s\n",PName);
	if (Player[targetid][Admin] == 1){format(String2,sizeof(String2),"{FFFF00}������� ������ ������ {FFFFFF}%s [{66CDAA}���������{FFFFFF}]\n",PName);}
	if (Player[targetid][Admin] == 2){format(String2,sizeof(String2),"{FFFF00}������� ������ ������ {FFFFFF}%s [{9ACD32}�����-���������{FFFFFF}]\n",PName);}
	if (Player[targetid][Admin] == 3){format(String2,sizeof(String2),"{FFFF00}������� ������ ������ {FFFFFF}%s [{00BFFF}�������������{FFFFFF}]\n",PName);}
	if (Player[targetid][Admin] == 4){format(String2,sizeof(String2),"{FFFF00}������� ������ ������ {FFFFFF}%s [{FF7F50}������� �������������{FFFFFF}]\n",PName);}

	new clanid = Player[targetid][MyClan];
	if (clanid > 0){format(String2,sizeof(String2),"{FFFF00}������� ������ ������ {FFFFFF}[{008E00}%s{FFFFFF}] %s\n",Clan[clanid][cName],PName);}
	if (clanid > 0 && Player[targetid][Admin] == 1){format(String2,sizeof(String2),"{FFFF00}������� ������ ������ {FFFFFF}[{008E00}%s{FFFFFF}] %s [{66CDAA}���������{FFFFFF}]\n",Clan[clanid][cName],PName);}
	if (clanid > 0 && Player[targetid][Admin] == 2){format(String2,sizeof(String2),"{FFFF00}������� ������ ������ {FFFFFF}[{008E00}%s{FFFFFF}] %s [{9ACD32}�����-���������{FFFFFF}]\n",Clan[clanid][cName],PName);}
	if (clanid > 0 && Player[targetid][Admin] == 3){format(String2,sizeof(String2),"{FFFF00}������� ������ ������ {FFFFFF}[{008E00}%s{FFFFFF}] %s [{00BFFF}�������������{FFFFFF}]\n",Clan[clanid][cName],PName);}
	if (clanid > 0 && Player[targetid][Admin] == 4){format(String2,sizeof(String2),"{FFFF00}������� ������ ������ {FFFFFF}[{008E00}%s{FFFFFF}] %s [{FF7F50}������� �������������{FFFFFF}]\n",Clan[clanid][cName],PName);}
	strcat(String, String2);
	
	format(String2,sizeof(String2),"{FF0000}IP-�����: {FFFFFF}%s\n", PlayerIP[targetid]); strcat(String, String2);
 	if (Player[playerid][Admin] >= 4)
	{
		format(String2,sizeof(String2),"{FF0000}������: {FFFFFF}%0.2f   {FF0000}������ �� ������: {FFFFFF}%0.2f   {FF0000}������ �� ��� �����: {FFFFFF}%0.2f\n", Player[targetid][GameGold], Player[targetid][GGFromMedalsTotal], Player[targetid][GameGoldTotal]); strcat(String, String2);
	    format(String2,sizeof(String2),"{FF0000}������: {FFFFFF}%d$   {FF0000}��������� / ������ �����: {FFFFFF}%d$\n", Player[targetid][CasinoBalance], Player[targetid][GiveCashBalance]); strcat(String, String2);
	}

	//������ � �����
	if(PlayerTime[targetid] == -1) format(String2,sizeof(String2),"{FF0000}������� �����: {FFFFFF}���������   ");
	else {format(String2,sizeof(String2),"{FF0000}������� �����: {FFFFFF}%d:00   ",PlayerTime[targetid]);}strcat(String, String2);
	if(PlayerWeather[targetid] == -1) format(String2,sizeof(String2),"{FF0000}������: {FFFFFF}���������\n");
	else {format(String2,sizeof(String2),"{FF0000}������: {FFFFFF}%d\n",PlayerWeather[targetid]);}strcat(String, String2);
	
	//��������������
	strcat(String, "\n{FFFF00}���������� �� lookupffs.com\n");
	format(String2, sizeof(String2), "{FF0000}������: {FFFFFF}%s   {FF0000}�����: {FFFFFF}%s\n", GetPlayerCountryName(targetid), GetPlayerCountryRegion(targetid));strcat(String, String2);
	format(String2, sizeof(String2), "{FF0000}���������: {FFFFFF}%s\n", GetPlayerISP(targetid));strcat(String, String2);
	format(String2, sizeof(String2), "{FF0000}Host: {FFFFFF}%s\n", GetPlayerHost(targetid));strcat(String, String2);

	//� �����������
	strcat(String, "\n{FFFF00}��������������� ������\n");
	if (Registered[targetid] == 0) strcat(String, "{AFAFAF}�� ���������������.\n");
	else
	{//���������������
		format(String2, sizeof(String2), "{AFAFAF}���� �����������: {FFFFFF}%s   {AFAFAF}IP: {FFFFFF}%s\n", RegisterDate[targetid], RegisterIP[targetid]); strcat(String, String2);
		format(String2, sizeof(String2), "{AFAFAF}����� �����������: {FFFFFF}%s\n", RegisterLocation[targetid]); strcat(String, String2);
		format(String2, sizeof(String2), "{AFAFAF}���������: {FFFFFF}%s\n", RegisterISP[targetid]); strcat(String, String2);
		format(String2, sizeof(String2), "{AFAFAF}����: {FFFFFF}%s\n", RegisterHost[targetid]); strcat(String, String2);
	}//���������������

	ShowPlayerDialog(playerid, 999, 0, "������� ������", String, "��", "");
	return 1;
}

stock ShowServerInfo(playerid)
{
    LastProperty = 1; OwnedProperty = 0; SuperProperty = 0;
    for(new i = 1; i < MAX_PROPERTY; i++)
	{
	    if(strcmp(Property[i][pOwner], "�����")) OwnedProperty++;
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
	format(String2,sizeof(String2),"{FFFF00}����� ������: {FFFFFF}%d �� %d{FFFF00}   �������������� �����: {FFFFFF}%d\n", OwnedProperty, LastProperty - 1, SuperProperty);strcat(String, String2);
	format(String2,sizeof(String2),"{FFFF00}������ ������: {FFFFFF}%d �� %d{FFFF00}\n", OwnedBase, LastBase - 1);strcat(String, String2);
	format(String2,sizeof(String2),"{FFFF00}������ �� �������: {FFFFFF}%d{FFFF00}   {FFFF00}��������: {FFFFFF}%d\n\n", clans, LastClan);strcat(String, String2);

    format(String2,sizeof(String2),"{FFFF00}������� �� �������: {FFFFFF}%d   {FFFF00}������������ ID ����������: {FFFFFF}%d\n\n", PlayersOnline, MaxVehicleUsed);strcat(String, String2);

	format(String2,sizeof(String2),"{FF0000}��������� ������� ��� %s",RestartDate);strcat(String, String2);

	ShowPlayerDialog(playerid, 999, 0, "���������� �������", String, "��", "");
	return ;
}





stock ShowClanStats(playerid, clanid)
{//ShowClanStats
 	new Free = 0;
 	if (clanid < 1 || clanid > MaxClanID || Clan[clanid][cLevel] < 1) return SendClientMessage(playerid, COLOR_RED, "���� � ����� ID �� ���������������!");
	if(!strcmp(Clan[clanid][cMember1], "�����", true)) Free++;
	if(!strcmp(Clan[clanid][cMember2], "�����", true)) Free++;
	if(!strcmp(Clan[clanid][cMember3], "�����", true)) Free++;
	if(!strcmp(Clan[clanid][cMember4], "�����", true)) Free++;
	if(!strcmp(Clan[clanid][cMember5], "�����", true)) Free++;
	if(!strcmp(Clan[clanid][cMember6], "�����", true)) Free++;
	if(!strcmp(Clan[clanid][cMember7], "�����", true)) Free++;
	if(!strcmp(Clan[clanid][cMember8], "�����", true)) Free++;
	if(!strcmp(Clan[clanid][cMember9], "�����", true)) Free++;
	if(!strcmp(Clan[clanid][cMember10], "�����", true)) Free++;
	if(!strcmp(Clan[clanid][cMember11], "�����", true)) Free++;
	if(!strcmp(Clan[clanid][cMember12], "�����", true)) Free++;
	if(!strcmp(Clan[clanid][cMember13], "�����", true)) Free++;
	if(!strcmp(Clan[clanid][cMember14], "�����", true)) Free++;
	if(!strcmp(Clan[clanid][cMember15], "�����", true)) Free++;
	if(!strcmp(Clan[clanid][cMember16], "�����", true)) Free++;
	if(!strcmp(Clan[clanid][cMember17], "�����", true)) Free++;
	if(!strcmp(Clan[clanid][cMember18], "�����", true)) Free++;
	if(!strcmp(Clan[clanid][cMember19], "�����", true)) Free++;
	if(!strcmp(Clan[clanid][cMember20], "�����", true)) Free++;

	new StringX[1024], StringZ[140], cNeedXP = Clan[clanid][cLevel] * 100000 + 100000;
	format(StringZ,sizeof(StringZ),"{008E00}���������� ����� {FFFFFF}%s {008E00}[ID:{FFFFFF}%d{008E00}]\n",Clan[clanid][cName], clanid);
	strcat(StringX, StringZ);
	//������ ���� - �����������, ��� ����� ������ ����, ����� ���� �� ��� ��������
	if (Clan[clanid][cLastDay] != 0) {format(StringZ, sizeof StringZ, "{FF0000}���� ����� �������� %s ���� � ���� �� �������� ����!\n����� ����, ��� ���������� ����� ���� ����� �� ��������!\n", IntDateToStringDate(Clan[clanid][cLastDay])); strcat(StringX, StringZ);}
	Free = 20 - Free;//�������� ����������� ������� ������

	//���������� ������ � ��� �����������
	if (Clan[clanid][cXP] >= cNeedXP && Clan[clanid][cLevel] < 100) {Clan[clanid][cXP] -= cNeedXP; Clan[clanid][cLevel] += 1; SaveClan(clanid); cNeedXP += 100000;}
	format(StringZ,sizeof(StringZ),"\n{FF7F50}������� �����: {FFFFFF}%d   {AFAFAF}���� � {FFFFFF}%d\n",Clan[clanid][cLevel], Clan[clanid][cColor]);

	strcat(StringX, StringZ);
	format(StringZ,sizeof(StringZ),"{AFAFAF}XP �������: {FFFFFF}%d   {AFAFAF}XP �������� �������: {FFFFFF}%d",Clan[clanid][cXP], cNeedXP - Clan[clanid][cXP]);
	if (Clan[clanid][cLevel] < 100) strcat(StringX, StringZ);
	
	if (Clan[clanid][cBase] == 0){format(StringZ,sizeof(StringZ),"\n\n{007FFF}����� �����: {FFFF00}%s   {007FFF}����: {FFFF00}���\n{008E00}���� ������: %d / 20    ����� �����:\n",Clan[clanid][cLider],Free);}
	if (Clan[clanid][cBase] > 0){format(StringZ,sizeof(StringZ),"\n\n{007FFF}����� �����: {FFFF00}%s   {007FFF}����: {FFFF00}����\n{008E00}���� ������: %d / 20    ����� �����:\n",Clan[clanid][cLider],Free);}
	if (Clan[clanid][cBase] > MAX_BASE){format(StringZ,sizeof(StringZ),"\n\n{007FFF}����� �����: {FFFF00}%s   {007FFF}����: {FF0000}����������\n{008E00}���� ������: %d / 20    ����� �����:\n",Clan[clanid][cLider],Free);}
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

	ShowPlayerDialog(playerid, 999, 0, "���������� �����", StringX, "��", "");
	return 1;
}//ShowClanStats

stock ShowEvents(playerid)
{//ShowEvents
	new StringX[2048], String[180], ClosestEvents = 0;
	strcat(StringX, "{FFFF00}������������ � ��������� 3 ������:\n");
	
	if (DMTimer <= 180 && DMTimer > 0 && DMPlayers < DMLimit)
	{
		if (DMTimer < 60){format (String, sizeof(String),"{33FF00}/dm\t\t{FF8C00}������� <<{FFFFFF}%s{FF8C00}>> �������� ����� {FFFFFF}%d{FF8C00} ������. �������: {FFFFFF}%d\n",DMName[DMid], DMTimer, DMPlayers);}
        else{new emin = DMTimer/60;format (String, sizeof(String),"{33FF00}/dm\t\t{FF8C00}������� <<{FFFFFF}%s{FF8C00}>> �������� ����� {FFFFFF}%d{FF8C00} ����� {FFFFFF}%d{FF8C00} ������. �������: {FFFFFF}%d\n",DMName[DMid], emin, DMTimer - emin*60, DMPlayers);}
		strcat(StringX, String); ClosestEvents++;
	}
	else if (DMTimeToEnd > 0 && DMPlayers < DMLimit)
	{
		format (String, sizeof(String),"{33FF00}/dm\t\t{FF8C00}������� <<{FFFFFF}%s{FF8C00}>> ���� ����� ������! �������: {FFFFFF}%d\n",DMName[DMid], DMPlayers);
		strcat(StringX, String); ClosestEvents++;
	}
	
	if (DerbyTimer < 180 && DerbyTimer > 0 && DerbyPlayers < DerbyLimit)
	{
		if (DerbyTimer < 60){format (String, sizeof(String),"{33FF00}/derby\t\t{9966CC}����� <<{FFFFFF}%s{9966CC}>> �������� ����� {FFFFFF}%d{9966CC} ������. �������: {FFFFFF}%d\n",DerbyName[Derbyid], DerbyTimer, DerbyPlayers);}
        else{new emin = DerbyTimer/60;format (String, sizeof(String),"{33FF00}/derby\t\t{9966CC}����� <<{FFFFFF}%s{9966CC}>> �������� ����� {FFFFFF}%d{9966CC} ����� {FFFFFF}%d{9966CC} ������. �������: {FFFFFF}%d\n",DerbyName[Derbyid], emin, DerbyTimer - emin*60, DerbyPlayers);}
		strcat(StringX, String); ClosestEvents++;
	}
	
	if (ZMTimer < 180 && ZMTimer > 0 && ZMPlayers < ZMLimit)
	{
		if (ZMTimer < 60){format (String, sizeof(String),"{33FF00}/zombie\t{E60020}�����-��������� <<{FFFFFF}%s{E60020}>> �������� ����� {FFFFFF}%d{E60020} ������. �������: {FFFFFF}%d\n",ZMName[ZMid], ZMTimer, ZMPlayers);}
        else{new emin = ZMTimer/60;format (String, sizeof(String),"{33FF00}/zombie\t{E60020}�����-��������� <<{FFFFFF}%s{E60020}>> �������� ����� {FFFFFF}%d{E60020} ����� {FFFFFF}%d{E60020} ������. �������: {FFFFFF}%d\n",ZMName[ZMid], emin, ZMTimer - emin*60, ZMPlayers);}
		strcat(StringX, String); ClosestEvents++;
	}
	
	if (FRTimer < 180 && FRTimer > 0 && FRPlayers < FRLimit)
	{
		if (FRTimer < 60){format (String, sizeof(String),"{33FF00}/race\t\t{007FFF}����� �������� ����� {FFFFFF}%d{007FFF} ������. �������: {FFFFFF}%d\n", FRTimer, FRPlayers);}
        else{new emin = FRTimer/60;format (String, sizeof(String),"{33FF00}/race\t\t{007FFF}����� �������� ����� {FFFFFF}%d{007FFF} ����� {FFFFFF}%d{007FFF} ������. �������: {FFFFFF}%d\n", emin, FRTimer - emin*60, FRPlayers);}
		strcat(StringX, String);
		format(String,sizeof(String),"\t\t{007FFF}�����: {FFFFFF}%s{007FFF}. �����: {FFFFFF}%s{007FFF}.\n",FRName[FRStart],FRName[FRFinish]);
		strcat(StringX, String); ClosestEvents++;
	}

	if (GGTimer < 180 && GGTimer > 0 && GGPlayers < GGLimit)
	{
		if (GGTimer < 60){format (String, sizeof(String),"{33FF00}/gungame\t{FF6666}����� ���������� <<{FFFFFF}%s{FF6666}>> �������� ����� {FFFFFF}%d{FF6666} ������. �������: {FFFFFF}%d\n",GGName[GGid], GGTimer, GGPlayers);}
        else{new emin = GGTimer/60;format (String, sizeof(String),"{33FF00}/gungame\t{FF6666}����� ���������� <<{FFFFFF}%s{FF6666}>> �������� ����� {FFFFFF}%d{FF6666} ����� {FFFFFF}%d{FF6666} ������. �������: {FFFFFF}%d\n",GGName[GGid], emin, GGTimer - emin*60, GGPlayers);}
		strcat(StringX, String); ClosestEvents++;
	}
	else if (GGTimeToEnd > 0 && GGPlayers < GGLimit)
	{
		format (String, sizeof(String),"{33FF00}/gungame\t{FF6666}����� ���������� <<{FFFFFF}%s{FF6666}>> ���� ����� ������! �������: {FFFFFF}%d\n",GGName[GGid], GGPlayers);
		strcat(StringX, String); ClosestEvents++;
	}
	
	if (XRTimer <= 180 && XRTimer > 0 && XRPlayers < XRLimit)
	{
		if (XRTimer < 60){format (String, sizeof(String),"{33FF00}/xrace\t\t{FFD700}����������� ����� <<{FFFFFF}%s{FFD700}>> �������� ����� {FFFFFF}%d{FFD700} ������. �������: {FFFFFF}%d\n",XRName[XRid], XRTimer, XRPlayers);}
        else{new emin = XRTimer/60;format (String, sizeof(String),"{33FF00}/xrace\t\t{FFD700}����������� ����� <<{FFFFFF}%s{FFD700}>> �������� ����� {FFFFFF}%d{FFD700} ����� {FFFFFF}%d{FFD700} ������. �������: {FFFFFF}%d\n",XRName[XRid], emin, XRTimer - emin*60, XRPlayers);}
		strcat(StringX, String); ClosestEvents++;
	}

	if (ClosestEvents == 0)
	{
	    format (String, sizeof(String),"{AFAFAF}� ��������� 3 ������ ��� ������� ������������.\n��������� ������� ��� ��������� ���-������ ������.\n",GGName[GGid], GGPlayers);
		strcat(StringX, String); ClosestEvents++;
	}



	ShowPlayerDialog(playerid, 999, 0, "��������� ������������", StringX, "��", "");
	return 1;
}//ShowEvents

stock ShowQuests(playerid)
{//ShowQuests
	new StringX[1024], String[180];

	for (new i = 0; i <= 2; i++)
	{//����
	    if (QuestTime[playerid][i] > 0) format(String, sizeof String, "{FB98DA}����� ������� �������� ����� ����� %d �����\n", QuestTime[playerid][i] / 60 + 1);
	    else switch (Quest[playerid][i])
	    {//switch
	        case 1: format(String, sizeof String, "{FFFFFF}������ 40 ������� � ��������: {007FFF}%d{FFFFFF} / 40\n", QuestScore[playerid][i]);
	        case 2: format(String, sizeof String, "{FFFFFF}������ 5 ������� ��� ������ ��������� ������: {007FFF}%d{FFFFFF} / 5\n", QuestScore[playerid][i]);
	        case 3: format(String, sizeof String, "{FFFFFF}������ 15 ����� � �����-���������: {007FFF}%d{FFFFFF} / 15\n", QuestScore[playerid][i]);
	        case 4: format(String, sizeof String, "{FFFFFF}������ 15 ������� � ����� ����������: {007FFF}%d{FFFFFF} / 15\n", QuestScore[playerid][i]);
	        case 5: format(String, sizeof String, "{FFFFFF}������ 5 ������� �� ��������� ������������: {007FFF}%d{FFFFFF} / 5\n", QuestScore[playerid][i]);
	        case 6: format(String, sizeof String, "{FFFFFF}������ 50 �������: {007FFF}%d{FFFFFF} / 50\n", QuestScore[playerid][i]);
	        case 7: format(String, sizeof String, "{FFFFFF}��������� 10 ������� �� ������ ���������: {007FFF}%d{FFFFFF} / 10\n", QuestScore[playerid][i]);
	        case 8: format(String, sizeof String, "{FFFFFF}��������� 10 ������� �� ������ ���������: {007FFF}%d{FFFFFF} / 10\n", QuestScore[playerid][i]);
	        case 9: format(String, sizeof String, "{FFFFFF}��������� 10 ������� �� ������ ��������-��������: {007FFF}%d{FFFFFF} / 10\n", QuestScore[playerid][i]);
	        case 10: format(String, sizeof String, "{FFFFFF}��������� 10 ������� �� ������ ��������: {007FFF}%d{FFFFFF} / 10\n", QuestScore[playerid][i]);
	        case 11: format(String, sizeof String, "{FFFFFF}������� ������� � 3 ���������: {007FFF}%d{FFFFFF} / 3\n", QuestScore[playerid][i]);
	        case 12: format(String, sizeof String, "{FFFFFF}������� ������� � 3 �����: {007FFF}%d{FFFFFF} / 3\n", QuestScore[playerid][i]);
	        case 13: format(String, sizeof String, "{FFFFFF}������� ������� � 3 �����-����������: {007FFF}%d{FFFFFF} / 3\n", QuestScore[playerid][i]);
	        case 14: format(String, sizeof String, "{FFFFFF}������� ������� � 3 ������: {007FFF}%d{FFFFFF} / 3\n", QuestScore[playerid][i]);
	        case 15: format(String, sizeof String, "{FFFFFF}�������� ������ ������� 50 000$: {007FFF}%d{FFFFFF} / 50000\n", QuestScore[playerid][i]);
	        case 16: format(String, sizeof String, "{FFFFFF}������� ������� � 3 ����������� ������: {007FFF}%d{FFFFFF} / 3\n", QuestScore[playerid][i]);
	        case 17: format(String, sizeof String, "{FFFFFF}������� ������� � 3 ������ ����������: {007FFF}%d{FFFFFF} / 3\n", QuestScore[playerid][i]);
	        case 18: format(String, sizeof String, "{FFFFFF}������� ������� � 5 ����� �������������: {007FFF}%d{FFFFFF} / 5\n", QuestScore[playerid][i]);
	        case 19: format(String, sizeof String, "{FFFFFF}�������� ������ ������� �� ����� 10 000$: {007FFF}%d{FFFFFF} / 10000\n", QuestScore[playerid][i]);
	        case 20: format(String, sizeof String, "{FFFFFF}�������� � 2 �����-����������: {007FFF}%d{FFFFFF} / 2\n", QuestScore[playerid][i]);
	        case 21: format(String, sizeof String, "{FFFFFF}������� 5 ������: {007FFF}%d{FFFFFF} / 5\n", QuestScore[playerid][i]);
	        case 22: format(String, sizeof String, "{FFFFFF}������� ������� � 5 PvP: {007FFF}%d{FFFFFF} / 5\n", QuestScore[playerid][i]);
	        case 23: format(String, sizeof String, "{FFFFFF}��������� 3 PvP: {007FFF}%d{FFFFFF} / 3\n", QuestScore[playerid][i]);
	        case 24: format(String, sizeof String, "{FFFFFF}�������� 20 ������ � ������: {007FFF}%d{FFFFFF} / 20\n", QuestScore[playerid][i]);
	        case 25: format(String, sizeof String, "{FFFFFF}��������� �� ������� 60 �����: {007FFF}%d{FFFFFF} / 60\n", QuestScore[playerid][i]);
	        case 26: format(String, sizeof String, "{FFFFFF}�������� 3 000 XP: {007FFF}%d{FFFFFF} / 3000\n", QuestScore[playerid][i]);
	        case 27: format(String, sizeof String, "{FFFFFF}��������� 15 ����� �� ����� ������: {007FFF}%d{FFFFFF} / 15\n", QuestScore[playerid][i]);
	        case 28: format(String, sizeof String, "{FFFFFF}�������� ������ ��������� 30 ���: {007FFF}%d{FFFFFF} / 30\n", QuestScore[playerid][i]);
	        case 29: format(String, sizeof String, "{FFFFFF}��������������� ��������� 30 ���: {007FFF}%d{FFFFFF} / 30\n", QuestScore[playerid][i]);
	        case 30: format(String, sizeof String, "{FFFFFF}��������� 25 000$ � ��������� ��������: {007FFF}%d{FFFFFF} / 25000\n", QuestScore[playerid][i]);

			default: format(String, sizeof String, "{FF0000}��������� ������ ��� ���������� �������! �������� �������������!\n");
	    }//switch
	    strcat(StringX, String);
	}//����
	strcat(StringX, "{FFCC00}�������� ������\n");

	format(String, sizeof String, "{AFAFAF}��������� ������� (������: {FFFF00}%d{AFAFAF})", Player[playerid][Medals]);
	ShowPlayerDialog(playerid, DIALOG_QUESTS, 2, String, StringX, "�������", "�������");
}//ShowQuests

stock CallCar1(playerid)
{//����� ���� ������ 1
    if (Player[playerid][CarSlot1] == 0) return SendClientMessage(playerid,COLOR_RED,"� ��� ��� ���������� 1-�� ������");
	if (GetPlayerInterior(playerid) != 0 || IsPlayerInRangeOfPoint(playerid, 13.0, 2311.6953,-7.4206,26.7422)) return SendClientMessage(playerid, COLOR_RED, "������ �������� ��������� � ����������!");//����� � ���������� ��� � �����
	if (GetPlayerWeapon(playerid) == 46) return SendClientMessage(playerid,COLOR_RED,"������� ������! ������ �������� ���������� � ��������� �� ������.");
	if (InEvent[playerid] > 0) return SendClientMessage(playerid,COLOR_RED,"������ �������� ������ � �������������!");
	if (QuestActive[playerid] > 0) return SendClientMessage(playerid,COLOR_RED,"������ �������� ������ ��������� �� ������!");
	if (TimeTransform[playerid] > 0){new String[120];format(String,sizeof(String),"�� �� ������ ������� ��������� ��� {FFFFFF}%d{FF0000} ������",TimeTransform[playerid]);SendClientMessage(playerid,COLOR_RED,String);return 1;}
    if (OnFly[playerid] == 1) StopFly(playerid);
	Player[playerid][CarActive] = 1; SetPlayerSpecialAction(playerid, 0); //����� �� ���� ���� � ����� ����
    new Float: x, Float: y, Float: z, Float: Angle; GetPlayerPos(playerid,x,y,z);
	new wrld = GetPlayerVirtualWorld(playerid); GetPlayerFacingAngle(playerid, Angle);
	PlayerCarID[playerid] = LCreateVehicle(Player[playerid][CarSlot1], x, y, z, Angle, Player[playerid][CarSlot1Color1], Player[playerid][CarSlot1Color2], 0);
	SetVehicleVirtualWorld(PlayerCarID[playerid], wrld);PutPlayerInVehicle(playerid, PlayerCarID[playerid], 0);
    if (Player[playerid][CarSlot1PaintJob] > -1){ChangeVehiclePaintjob(PlayerCarID[playerid], Player[playerid][CarSlot1PaintJob]);}
	//�������� ����������� �������
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
	{//�������� �����
	    new vehicleid = PlayerCarID[playerid];
	    NeonObject1[vehicleid] = CreateDynamicObject(Player[playerid][CarSlot1Neon], 0, 0, 0, 0, 0, 0, wrld, GetPlayerInterior(playerid), -1, 300.0);
	    NeonObject2[vehicleid] = CreateDynamicObject(Player[playerid][CarSlot1Neon], 0, 0, 0, 0, 0, 0, wrld, GetPlayerInterior(playerid), -1, 300.0);
	    AttachDynamicObjectToVehicle(NeonObject1[vehicleid], vehicleid, -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	    AttachDynamicObjectToVehicle(NeonObject2[vehicleid], vehicleid, 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	}//�������� �����
	TimeTransform[playerid] = 5;
	QuestUpdate(playerid, 28, 1);//���������� ������ �������� ������ ��������� 30 ���
	return 1;
}//����� ���� ������ 1

stock CallCar2(playerid)
{//����� ���� ������ 2
    if (Player[playerid][CarSlot2] == 0) return SendClientMessage(playerid,COLOR_RED,"� ��� ��� ���������� 2-�� ������");
	if (GetPlayerInterior(playerid) != 0 || IsPlayerInRangeOfPoint(playerid, 13.0, 2311.6953,-7.4206,26.7422)) return SendClientMessage(playerid, COLOR_RED, "������ �������� ��������� � ����������!");//����� � ���������� ��� � �����
	if (GetPlayerWeapon(playerid) == 46) return SendClientMessage(playerid,COLOR_RED,"������� ������! ������ �������� ���������� � ��������� �� �����.");
	if (InEvent[playerid] > 0) return SendClientMessage(playerid,COLOR_RED,"������ �������� ������ � �������������!");
	if (QuestActive[playerid] > 0) return SendClientMessage(playerid,COLOR_RED,"������ �������� ������ ��������� �� ������!");
	if (TimeTransform[playerid] > 0){new String[120];format(String,sizeof(String),"�� �� ������ ������� ��������� ��� {FFFFFF}%d{FF0000} ������",TimeTransform[playerid]);SendClientMessage(playerid,COLOR_RED,String);return 1;}
    if (OnFly[playerid] == 1) StopFly(playerid);
	Player[playerid][CarActive] = 2; SetPlayerSpecialAction(playerid, 0); //����� �� ���� ���� � ����� ����
    new Float: x, Float: y, Float: z, Float: Angle; GetPlayerPos(playerid,x,y,z);
	new wrld = GetPlayerVirtualWorld(playerid); GetPlayerFacingAngle(playerid, Angle);
	PlayerCarID[playerid] = LCreateVehicle(Player[playerid][CarSlot2], x, y, z, Angle, Player[playerid][CarSlot2Color1], Player[playerid][CarSlot2Color2], 0);
	SetVehicleVirtualWorld(PlayerCarID[playerid], wrld);PutPlayerInVehicle(playerid, PlayerCarID[playerid], 0);
	if (Player[playerid][CarSlot2PaintJob] > -1){ChangeVehiclePaintjob(PlayerCarID[playerid], Player[playerid][CarSlot2PaintJob]);}
	//�������� ����������� �������
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
	{//�������� �����
	    new vehicleid = PlayerCarID[playerid];
	    NeonObject1[vehicleid] = CreateDynamicObject(Player[playerid][CarSlot2Neon], 0, 0, 0, 0, 0, 0, wrld, GetPlayerInterior(playerid), -1, 300.0);
	    NeonObject2[vehicleid] = CreateDynamicObject(Player[playerid][CarSlot2Neon], 0, 0, 0, 0, 0, 0, wrld, GetPlayerInterior(playerid), -1, 300.0);
	    AttachDynamicObjectToVehicle(NeonObject1[vehicleid], vehicleid, -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	    AttachDynamicObjectToVehicle(NeonObject2[vehicleid], vehicleid, 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	}//�������� �����
	TimeTransform[playerid] = 5;
	QuestUpdate(playerid, 28, 1);//���������� ������ �������� ������ ��������� 30 ���
    return 1;
}//����� ���� ������ 2

stock CallCar3(playerid)
{//����� ���� ������ 3
    if (Player[playerid][CarSlot3] == 0) return SendClientMessage(playerid,COLOR_RED,"� ��� ��� ���������� 3-�� ������");
	if (GetPlayerInterior(playerid) != 0 || IsPlayerInRangeOfPoint(playerid, 13.0, 2311.6953,-7.4206,26.7422)) return SendClientMessage(playerid, COLOR_RED, "������ �������� ��������� � ����������!");//����� � ���������� ��� � �����
	if (GetPlayerWeapon(playerid) == 46) return SendClientMessage(playerid,COLOR_RED,"������� ������! ������ �������� ���������� � ��������� �� �����.");
	if (InEvent[playerid] > 0) return SendClientMessage(playerid,COLOR_RED,"������ �������� ������ � �������������!");
	if (QuestActive[playerid] > 0) return SendClientMessage(playerid,COLOR_RED,"������ �������� ������ ��������� �� ������!");
	if (TimeTransform[playerid] > 0){new String[120];format(String,sizeof(String),"�� �� ������ ������� ��������� ��� {FFFFFF}%d{FF0000} ������",TimeTransform[playerid]);SendClientMessage(playerid,COLOR_RED,String);return 1;}
    if (OnFly[playerid] == 1) StopFly(playerid);
	Player[playerid][CarActive] = 3; SetPlayerSpecialAction(playerid, 0); //����� �� ���� ���� � ����� ����
    new Float: x, Float: y, Float: z, Float: Angle; GetPlayerPos(playerid,x,y,z);
	new wrld = GetPlayerVirtualWorld(playerid); GetPlayerFacingAngle(playerid, Angle);
	PlayerCarID[playerid] = LCreateVehicle(Player[playerid][CarSlot3], x, y, z + 2, Angle, Player[playerid][CarSlot3Color1], Player[playerid][CarSlot3Color2], 0);
	SetVehicleVirtualWorld(PlayerCarID[playerid], wrld);PutPlayerInVehicle(playerid, PlayerCarID[playerid], 0);
    LinkVehicleToInterior(PlayerCarID[playerid],GetPlayerInterior(playerid));
	TimeTransform[playerid] = 5;
	QuestUpdate(playerid, 28, 1);//���������� ������ �������� ������ ��������� 30 ���
    return 1;
}//����� ���� ������ 3

stock OnPlayerLogin(playerid)
{//��� �������� �����������
	if(strcmp(PlayerLimitXPDate[playerid], ServerLimitXPDate))
	{
	    if (Player[playerid][LastHourExp] > 0)
		{
			new String[180];
		    format(String, sizeof String, "%d.%d.%d � %d:%d:%d |   STATISTICS: ����� %s[%d] ������� %d XP �� ���� ���", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid, Player[playerid][LastHourExp]);
			WriteLog("StatisticsXP", String);
		}
		if (Player[playerid][LastHourReferalExp] > 0)
		{
			new String[180];
		    format(String, sizeof String, "%d.%d.%d � %d:%d:%d |   STATISTICS: ����� %s[%d] ������� �� ����� %d XP �� ���� ���", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid, Player[playerid][LastHourReferalExp]);
			WriteLog("StatisticsClanXP", String);
		}
		Player[playerid][LastHourExp] = 0; Player[playerid][LastHourReferalExp] = 0;
	}
	format(PlayerLimitXPDate[playerid], 80, "%s", ServerLimitXPDate);
    StopAudioStreamForPlayer(playerid); LoadPlayerClan(playerid);//�������� �����

	UpdatePlayer(playerid); ShopUpdate(playerid);
    PlayerWeather[playerid] = -1; PlayerTime[playerid] = -1;//��������� ������ � ����� ����� ������

	if (Player[playerid][Home] > 0)
	{//��������� � ������ ����
		new myhome = Player[playerid][Home];
		if(strcmp(Property[myhome][pOwner], GetName(playerid), true))
		{//��� �� ����������� ������
			Player[playerid][Home] = 0;
			if (Player[playerid][Spawn] == 4 || Player[playerid][Spawn] == 6 || Player[playerid][Spawn] == 7) Player[playerid][Spawn] = 0;
			SendClientMessage(playerid, COLOR_YELLOW, "��� ��� ����������! ������ ���� ���������� �� ��� ���������� ����.");
		}//��� �� ����������� ������
	}//��������� � ������ ����

	if (Player[playerid][Level] == 0)
	{//��� ������� ������ �� ����� �������� �� �����
	    //��������� �������� ������
		new String[1024];TutorialStep[playerid] = 1;
		strcat(String, "{007FFF}��������: ����� ����������{FFFFFF}\n\n");
		strcat(String, "������� ������ �� ������� � ������ ������ �������� ���� ������ ����������. ���������� ��� �����.\n");
		strcat(String, "��� ����, ����� ����� �� ����, ������� ������� {00FF00}Alt{FFFFFF} � �������� <<{FFFF00}����� � ������ [����� 1]{FFFFFF}>>");
		return ShowPlayerDialog(playerid, DIALOG_TUTORIAL, 0, "��������", String, "��, ������", "");
	}//��� ������� ������ �� ����� �������� �� �����

    HealthTime[playerid] = 0; ArmourTime[playerid] = 0;
	return 1;
}//��� �������� �����������

stock SpecUpdate(playerid)
{//SpecUpdate
    foreach(Player, i)
	{//���������� ������� � ���, ��� ������ �� �������
	    if (LSpecID[i] == playerid)
	    {
			SetPlayerInterior(i,GetPlayerInterior(playerid));
			SetPlayerVirtualWorld(i,GetPlayerVirtualWorld(playerid));
			if (IsPlayerInAnyVehicle(playerid))
			{
				PlayerSpectateVehicle(i, GetPlayerVehicleID(playerid), LSpecMode[playerid]);
				//����������� �����, ����� �� ���������� ����� ������ �����
                SetTimerEx("SideCameraSpecpUpdate" , 100, false, "id", i, GetPlayerVehicleID(playerid));
			}
			else PlayerSpectatePlayer(i, playerid, LSpecMode[playerid]);
		}
	}//���������� ������� � ���, ��� ������ �� �������
}//SpecUpdate

//------------ ���������� ������������ ������� � ����������
new VehiclePassengerSeats[] = {
3,1,1,1,3,3,0,1,1,3,1,1,1,3,1,1,3,1,3,1,3,3,1,1,1,0,3,3,3,1,0,1000,0,1,1,0,1,1000,3,1,3,0,1,1,1,3,0,1,
0,0,0,1,0,0,0,1,1,1,3,3,1,1,1,1,0,0,3,3,1,1,3,1,0,0,1,1,0,1,1,3,1,0,3,3,0,0,0,3,1,1,3,1,3,0,1,1,1,3,
3,1,1,0,1,1,1,1,1,3,1,0,0,1,0,0,1,1,3,1,1,0,0,1,1,1,1,1,1,1,1,3,0,0,0,1,1,1,1,1000,1000,0,3,1,1,1,1,1,
3,3,1,1,3,3,1,0,1,1,1,1,1,1,3,3,1,1,0,1,3,3,0,0,0,0,0,1,0,1,1,0,1,3,3,1,3,0,0,3,1,1,1,1,0,0,1000,1,1,
0,3,3,3,1,1,1,1,1,3,1,0,0,0,3,0,0};
stock GetPassengerSeats(vehicleid) return VehiclePassengerSeats[(GetVehicleModel(vehicleid) - 400)];
//------------ ���������� ������������ ������� � ����������

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
	if (GGKills[playerid] == 14) GivePlayerWeapon(playerid, 8, 1);//���� ������
	return 1;
}

stock GetPlayerSpeed(playerid)
{//��� LAC flyhack
	new Float:Coord[4];
	GetPlayerVelocity(playerid, Coord[0], Coord[1], Coord[2]);
	Coord[3] = floatsqroot(floatpower(floatabs(Coord[0]), 2.0) + floatpower(floatabs(Coord[1]), 2.0) + floatpower(floatabs(Coord[2]), 2.0)) * 213.3;
	return floatround(Coord[3]);
}//��� LAC flyhack

stock LGiveXP(playerid, standartxp)
{//���������� XP
	new LevelXPAvailable = 5000 - Player[playerid][LastHourExp]; if (Player[playerid][GPremium] >= 11) LevelXPAvailable = 999999;
	new XPToLevel, XPToMoney, String[140], XPBonus = 0, MBonus = 0;
	if (standartxp >= LevelXPAvailable) {XPToLevel = LevelXPAvailable; XPToMoney = standartxp - LevelXPAvailable;}
	else {XPToLevel = standartxp; XPToMoney = 0;}
	Player[playerid][LastHourExp] += XPToLevel;

	if (XPToLevel > 0)
	{//���������� �� �� ������
	    Player[playerid][Exp] += XPToLevel;
		if (Player[playerid][GPremium] >= 1 && Player[playerid][GPremium] < 5) XPBonus = XPToLevel * 35 / 100;//���������� ������ 35%
		if (Player[playerid][GPremium] >= 5 && Player[playerid][GPremium] < 8) XPBonus = XPToLevel * 60 / 100;//���������� ������ 60%
		if (Player[playerid][GPremium] >= 8 && Player[playerid][GPremium] < 10) XPBonus = XPToLevel * 80 / 100;//���������� ������ 80%
		if (Player[playerid][GPremium] >= 10 && Player[playerid][GPremium] < 12)  XPBonus = XPToLevel;//���������� ������ 100%
		if (Player[playerid][GPremium] >= 12 && Player[playerid][GPremium] < 15) XPBonus = XPToLevel * 125 / 100;//���������� ������ 125%
		if (Player[playerid][GPremium] >= 15 && Player[playerid][GPremium] < 17) XPBonus = XPToLevel * 15 / 10;//���������� ������ 150%
		if (Player[playerid][GPremium] >= 17 && Player[playerid][GPremium] < 20) XPBonus = XPToLevel * 175 / 100;//���������� ������ 175%
		if (Player[playerid][GPremium] >= 20) XPBonus = XPToLevel * 2;//���������� ������ 200%
		if (XPBonus > 0) Player[playerid][Exp] += XPBonus;//���������� �� ������ VIP

		//----------------------------------- ���������
		if (Player[playerid][MyClan] > 0)
		{//���� ������ ���-�� ��������� �� ������
		    new RefXP = XPToLevel / 10;//10% �� ����������� �� ������ �����������
		    if (RefXP > 0)
		    {//RefXP > 0
				foreach(Player, cid)
				{//����
					if(Player[cid][MyClan] == Player[playerid][MyClan] && cid != playerid && Logged[cid] == 1)
					{//������������ � ����
						Player[cid][Exp] += RefXP; Player[cid][LastHourReferalExp] += RefXP;
 						new clanid = Player[playerid][MyClan], ccolor = Clan[clanid][cColor];
						format(String, sizeof String, "�� �������� %d XP �� ������ %s[%d].", RefXP, PlayerName[playerid], playerid);
						SendClientMessage(cid, ClanColor[ccolor], String); PlayerPlaySound(cid,1083,0.0,0.0,0.0);
                        if (NeedXP[cid] <= Player[cid][Exp]) PlayerLevelUp(cid);
					}//������������ � ����
				}//����
		    }//RefXP > 0
		}//���� ������ ���-�� ��������� �� ������
		//----------------------------------- ���������

	}//���������� �� �� ������

	if (XPToMoney > 0)
	{//���������� �� � ������ ��� ������
	    Player[playerid][Cash] += XPToMoney * 100;//���� ��-�� ������ �� ����� 100��, �� ��������� 10 000 �����
		format(String,sizeof(String),"����� XP ������! ������ ��� �� �������� %d$",XPToMoney * 100);
		SendClientMessage(playerid,0x00FF00FF,String);
	}//���������� �� � ������ ��� ������
	
	if (Player[playerid][GPremium] >= 6 && Player[playerid][GPremium] < 9) MBonus = standartxp * 15;//ViP 6: x15 ����� �� XP
	if (Player[playerid][GPremium] >= 9 && Player[playerid][GPremium] < 16) MBonus = standartxp * 30;//ViP 9: x30 ����� �� XP
	if (Player[playerid][GPremium] >= 16) MBonus = standartxp * 60;//ViP 16: x60 ����� �� XP
	if (MBonus > 0)	Player[playerid][Cash] += MBonus;//���������� ��������� ������ VIP
	
	if (XPBonus > 0)
	{//��������� � ��� � ����������� �������
		if (MBonus == 0) format(String,sizeof(String),"ViP: �� �������� ����� %d XP",XPBonus);
		else format(String,sizeof(String),"ViP: �� �������� ����� %d XP � %d$",XPBonus, MBonus);
		SendClientMessage(playerid,0x00FF00FF,String);
	}//��������� � ��� � ����������� �������
	
	if (Player[playerid][MyClan] != 0)
	{//�������� �����
	    new clanid = Player[playerid][MyClan];
		Clan[clanid][cXP] += standartxp; Clan[clanid][cXP] += XPBonus;
	}//�������� �����

	if (Player[playerid][Exp] >= NeedXP[playerid] && (0 < Player[playerid][Level] < 100 || Player[playerid][Prestige] >= 10)) PlayerLevelUp(playerid); //��������� ������, ���� ������� ���������� XP
	QuestUpdate(playerid, 26, standartxp);//���������� ������ �������� 3 000 XP
}//���������� XP


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
{//����������� ����� ��� ����������� ������������� �� lookupffs.com
	new String[256];
	format(String, sizeof String, "%d.%d.%d � %d:%d:%d |   CONNECTION: Nick: %s[%d]   IP: %s   Region: %s   Country: %s   ISP: %s   Host: %s", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid, PlayerIP[playerid], GetPlayerCountryRegion(playerid), GetPlayerCountryName(playerid), GetPlayerISP(playerid), GetPlayerHost(playerid));
	WriteLog("ConnectionsLog", String);
	
	if(!strcmp(GetPlayerCountryRegion(playerid), "Kerch") && strlen(GetPlayerCountryRegion(playerid)) > 3)
	{//��� ������ ����� �� lookupffs.com �� ���� �����
		format(String,sizeof(String), "{FF0000}LAC: {AFAFAF}%s ��� ������������� ������� (�����: �����).",PlayerName[playerid]);
		SendClientMessageToAll(COLOR_GREY,String); BanEx( playerid, "������� (�����: �����)");
		format(String, 140, "%d.%d.%d � %d:%d:%d |   LAC: %s[%d] %s ��� ������������� ������� (�����: �����)", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid);
		WriteLog("GlobalLog", String);WriteLog("LAC", String);
	}//��� ������ ����� �� lookupffs.com
	if(strfind(GetPlayerHost(playerid),"kerch",true) != -1 && strlen(GetPlayerHost(playerid)) > 3)
	{//��� ������ ����� �� lookupffs.com �� ���� ����
		format(String,sizeof(String), "{FF0000}LAC: {AFAFAF}%s ��� ������������� ������� (�����: �����).",PlayerName[playerid]);
		SendClientMessageToAll(COLOR_GREY,String); BanEx( playerid, "������� (�����: �����)");
		format(String, 140, "%d.%d.%d � %d:%d:%d |   LAC: %s[%d] %s ��� ������������� ������� (�����: �����)", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid);
		WriteLog("GlobalLog", String);WriteLog("LAC", String);
	}//��� ������ ����� �� lookupffs.com
	if(IsProxyUser(playerid))
	{//��� �������, ������������ Proxy (������� IP)
		format(String,sizeof(String), "{FF0000}LAC: {AFAFAF}%s ��� ������������� ������� (������� IP).",PlayerName[playerid]);
		SendClientMessageToAll(COLOR_GREY,String); BanEx( playerid, "������� (Proxy)");
		format(String, 140, "%d.%d.%d � %d:%d:%d |   LAC: %s[%d] %s ��� ������������� ������� (������� IP)", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid);
		WriteLog("GlobalLog", String);WriteLog("LAC", String);
	}//��� �������, ������������ Proxy (������� IP)


/*	if(strfind(GetPlayerISP(playerid),"Rostelecom",true) != -1 && strlen(GetPlayerISP(playerid)) > 3 && !strcmp(GetPlayerCountryRegion(playerid), "Saratov"))
	{//��� ������ ������� ��� ���������� ����������
		format(String,sizeof(String), "{FF0000}LAC: {AFAFAF}%s ��� ������������� ������� (�����: Saratov, ���������: Rostelecom).",PlayerName[playerid]);
		SendClientMessageToAll(COLOR_GREY,String); BanEx( playerid, "������� (�����: Saratov, Rostelecom)");
		format(String, 140, "%d.%d.%d � %d:%d:%d |   LAC: %s[%d] %s ��� ������������� ������� (�����: Saratov, ���������: Rostelecom)", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid);
		WriteLog("GlobalLog", String);WriteLog("LAC", String);
	}///��� ������ ������� ��� ���������� ����������
*/

	 
	 /*����� ������: ������, ������� ��������� ������ �� ������� (������������ �������������� ����� lookupffs.com)
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
	 //���� ������ �� ������������ - ���������� � ����� ������
	 if (strlen(GetPlayerCountryName(playerid)) < 3) WhiteList = 1;
	 if (WhiteList == 0) Kick(playerid);*/

	return 1;
}//����������� ����� ��� ����������� ������������� �� lookupffs.com

public SpeedoUpdate(playerid)
{//���������. ����������� ��� ���� � �������, ���� ����� � ������
	if (Logged[playerid] == 0 || !IsPlayerInAnyVehicle(playerid) || Player[playerid][ConSpeedo] == 0 || LSpecID[playerid] != -1)
	{TextDrawHideForPlayer(playerid, TextDrawSpeedo[playerid]);LastSpeed[playerid] = 999; return 1;}
	else
	{//����� � ������, ���������, �� � �������
	        SetTimerEx("SpeedoUpdate" , 500, false, "i", playerid);
	   		new Float:SPD, Float:vx, Float:vy, Float:vz, String[140], Float: x, Float: y, Float: z, vehicleid = GetPlayerVehicleID(playerid);
		    GetVehicleVelocity(vehicleid, vx,vy,vz);GetPlayerPos(playerid,x,y,z);
		    SPD = floatsqroot(((vx*vx)+(vy*vy))/*+(vz*vz)*/)*200;
			new speed = floatround(SPD, floatround_round);
			new MaxSpeed = GetVehicleMaxSpeed(vehicleid);
			if (z < LastPlayerSHZ[playerid] && speed > MaxSpeed && speed < MaxSpeed * 11/10 && LACSH[playerid] == 0) NeedSpeedDown[playerid] = 1;//��� ���������� ����. �������� �� �����, ��� �� 10% - �������� ��������
			if (NeedSpeedDown[playerid] > 0 && speed > MaxSpeed){SetVehicleSpeed(vehicleid, MaxSpeed*9/10); speed = MaxSpeed*9/10;} else NeedSpeedDown[playerid] = 0;
			//speedo
			format(String,sizeof(String),"CKOPOCTb: %d Km/h", speed);
			TextDrawSetString(TextDrawSpeedo[playerid], String);TextDrawShowForPlayer(playerid, TextDrawSpeedo[playerid]);
			//anti speedhack test
            new kef = speed - LastSpeed[playerid], cheat = 0, vmodel = GetVehicleModel(vehicleid);
			if (LACSH[playerid] == 0) LastSpeed[playerid] = speed; else LastSpeed[playerid] = 999;
			new Float: VHealth;GetVehicleHealth(vehicleid,VHealth);//��� � ��������� ������ ���������� ������ ������������ ��� ������ (������ ����� ������� �������� �������)
			if (VHealth < LastVHealth[playerid]){LastSpeed[playerid] = 999;if (LACSH[playerid] == 0) LACSH[playerid] = 1;}LastVHealth[playerid] = VHealth;
			if (kef > 80 && LACSH[playerid] == 0 && GetPlayerState(playerid) == PLAYER_STATE_DRIVER && Player[playerid][Banned] == 0 && vz >= 0.0) cheat = 1;//������� �������� ������ 80 �� ��� ������� (�� ��������� ���������� �������� +56, �� ����� +76)
			switch(vmodel)
			{//������ ����
				case 460, 476, 511, 512, 513, 519, 520, 553, 577, 592, 593: cheat = 0;//�� ��������� �������� ������� �� ����������
				case 448, 461, 462, 463, 468, 481, 509, 510, 521, 522, 523, 581, 586: MaxSpeed = 300;//��������� ����������� �� ���������� �� ������ ������
			}//������ ����
			if (speed > MaxSpeed + 5 && NeedSpeedDown[playerid] == 0 && LACSH[playerid] == 0 && GetPlayerState(playerid) == PLAYER_STATE_DRIVER && Player[playerid][Banned] == 0) cheat = 1;//�������� ������ 300 � ����� �� ��������� � ������� ����
            LastPlayerSHX[playerid] = x;LastPlayerSHY[playerid] = y;LastPlayerSHZ[playerid] = z;
			if (cheat == 1)
            {
                DestroyVehicle(vehicleid); TimeTransform[playerid] = 5; LACPanic[playerid]++;//LAC v2.0
				format(String,sizeof(String), "[�������]LAC:{AFAFAF} ��������� ������ %s[%d] ���������. {FF0000}�������: {AFAFAF}�������� SpeedHack",PlayerName[playerid], playerid);
                foreach(Player, cid) if (Player[cid][Admin] != 0 && Logged[cid] == 1) SendClientMessage(cid, COLOR_RED, String);
    			SendClientMessage(playerid, -1,"{FF0000}LAC:{AFAFAF} ��� ��������� ��� ���������. {FF0000}�������: {AFAFAF}�������� ��� SpeedHack");
				format(String, 140, "%d.%d.%d � %d:%d:%d |   LAC: ��������� ������ %s[%d] ���������. �������: �������� ��� SpeedHack", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid);
				WriteLog("GlobalLog", String);WriteLog("LAC", String);
			}
	}//����� � ������, ���������, �� � �������
	return 1;
}//���������. ����������� ��� ���� � �������, ���� ����� � ������

public OnUnoccupiedVehicleUpdate(vehicleid, playerid, passenger_seat, Float:new_x, Float:new_y, Float:new_z, Float:vel_x, Float:vel_y, Float:vel_z)
{
	//��� ���� ��������� ����� ������� �������� � ����� ��������� ��� ��������...
	new Float: fDistance = GetVehicleDistanceFromPoint(vehicleid, new_x, new_y, new_z);
	if (fDistance > 3)
	{//���� �������������� ���������� ������������������� �� 3 ����� � ����� - ���������� ��� �� �����
	    GetVehiclePos(vehicleid, new_x, new_y, new_z);
		SetVehiclePos(vehicleid, new_x, new_y, new_z);
		SetVehicleVelocity(vehicleid, 0, 0, 0);
	}//���� �������������� ���������� ������������������� �� 3 ����� � ����� - ���������� ��� �� �����
	return 0;
}

stock FailPVP(playerid)
{//����� �������� PVP
	new winer = PlayerPVP[playerid][Invite], String[200];
	format(String,sizeof(String),"{FF9E27}PVP: {AFAFAF}%s ������� � ����� ������ %s.", PlayerName[winer], PlayerName[playerid]);
	foreach(Player, cid) if (Player[cid][ConMesPVP] == 1 || cid == playerid || cid == winer) SendClientMessage(cid,COLOR_RED,String);
	PlayerPVP[playerid][Status] = 0;PlayerPVP[playerid][Invite] = 0;
    PlayerPVP[playerid][PlayMap] = 0;PlayerPVP[playerid][PlayWeapon] = 0;PlayerPVP[playerid][PlayHealth] = 0;
	PlayerPVP[winer][Status] = 0;PlayerPVP[winer][Invite] = 0;
    PlayerPVP[winer][PlayMap] = 0;PlayerPVP[winer][PlayWeapon] = 0;PlayerPVP[winer][PlayHealth] = 0;
    SetPlayerVirtualWorld(playerid,0);SetPlayerVirtualWorld(winer,0);
    SavePlayer(playerid);LSpawnPlayer(playerid);SavePlayer(winer);LSpawnPlayer(winer);
	JoinEvent[playerid] = 0; JoinEvent[winer] = 0;
    QuestUpdate(playerid, 22, 1);//���������� ������ ������� ������� � 5 PvP
    QuestUpdate(winer, 22, 1);//���������� ������ ������� ������� � 5 PvP
    QuestUpdate(winer, 23, 1);//���������� ������ ��������� 3 PvP
	return 1;
}//����� �������� PVP

stock IsPlayerInPayNSpray(playerid)
{//�������� �� ��, ��� ����� � ����������� ������ Pay N Spray
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
}//�������� �� ��, ��� ����� � ����������� ������ Pay N Spray

stock GetPlayerTuneStatus(playerid)
{//�������� �� ��, ��� ����� � ������ ������
    if(GetPlayerInterior(playerid) != 0)
    {//����� � ��������� (����� ���� � �������)
	    if (IsPlayerInRangeOfPoint(playerid,5,617.5347,-1.9909,1000.5783)) return 1; //� ������� Transfender
	    if (IsPlayerInRangeOfPoint(playerid,5,616.7845,-74.8150,997.8722)) return 2; //� ������� Lowrider
	    if (IsPlayerInRangeOfPoint(playerid,5,615.2812,-124.2390,997.6196)) return 3; //� ������� Arch Angels
    }//����� � ��������� (����� ���� � �������)
    else
    {//����� �� � ��������� (����� ���� �� ������ ��� ������ �� �������
	    if (IsPlayerInRangeOfPoint(playerid,15,1041.5431,-1016.8201,32.1075)) return -1; //�� ������ � Transfender � LS
	    if (IsPlayerInRangeOfPoint(playerid,15,-1936.0847,245.9636,34.4609)) return -2; //�� ������ � Transfender � SF
	    if (IsPlayerInRangeOfPoint(playerid,15,2386.7300,1051.5768,10.8203)) return -3; //�� ������ � Transfender � LV
	    if (IsPlayerInRangeOfPoint(playerid,15,2644.6580,-2044.3076,13.6352)) return -4; //�� ������ � Lowrider
	    if (IsPlayerInRangeOfPoint(playerid,15,-2723.5532,217.1511,4.4844)) return -5; //�� ������ � Arch Angels
    }//����� �� � ��������� (����� ���� �� ������ ��� ������ �� �������
	return 0;//����� �� � ������ � �� � ������ � ������
}//�������� �� ��, ��� ����� � ������ ������

stock ShopUpdate(playerid)
{//����������� ��� ����������� � � ������ ������� ����
	new xhouse = Player[playerid][Home];
	if (xhouse > 0 && Property[xhouse][pBuyBlock] == -1)
	{//����������� �������������
	    Property[xhouse][pBuyBlock] = 0; SaveProperty(xhouse);
	    for (new i = 1; i <= 2; i++) SendClientMessage(playerid, COLOR_RED, "��������! ����������� ����� �������� ������� '�������������� ������ ���'");
	}//����������� �������������

	if (Player[playerid][GGFromMedalsLastDay] != DateToIntDate(Day, Month, Year))
	{//����� ���� - ����� �������� ������� GG �� ������
	    Player[playerid][GGFromMedalsLastDay] = DateToIntDate(Day, Month, Year);
	    if (Player[playerid][GGFromMedals] == 5)
		{//� ������ ��� ������ ������� �����
			SendClientMessage(playerid, COLOR_YELLOW, "SERVER: ��������! ����� ������� �� ����� ������ ����� ��������!");
			PlayerPlaySound(playerid,1083,0.0,0.0,0.0);
		}//� ������ ��� ������ ������� �����
	    Player[playerid][GGFromMedals] = 0;
	}//����� ���� - ����� �������� ������� GG �� ������
	return 1;
}//����������� ��� ����������� � � ������ ������� ����

stock GetEventRestartTime()
{
	new value, EventsAtOneTime; //���-�� ������������, ������� ������������ ������ ���� �������� �� ����� ������ � ������ ������ �������
	if (PlayersOnline < 50) EventsAtOneTime = 2; //��� ������� < 50 ������� ������ ���� �������� 2 ������������ �� �����
	else if (PlayersOnline < 75) EventsAtOneTime = 3; //��� ������� � 50-74 ������ - 3 ������������
	else if (PlayersOnline < 100) EventsAtOneTime = 4; //��� ������� � 75-99 ������� - 4 ������������
	else if (PlayersOnline < 125) EventsAtOneTime = 5; //��� ������� � 100-124 ������ - 5 ������������
	else EventsAtOneTime = 6; //��� ������� � 125-150 ������� - 6 ������������
	
	value = (6 - EventsAtOneTime) * (240 / EventsAtOneTime);//6 - ����� ����� ���� ������������, 240 - �����, ������� ����� �� ���������� 1 ������������
	/*����� ���� ���������� �� �������� ������, � ������� �����, ����� ��������� ������������ ����� �� �������� ���������
	��� ������ �� �������. ����� �������� �������������� ������� ��� �������� ���������� ������������*/
	value += 125; //������ ����� ��������� ������������ ����� ������� ��������� � ������� ����� 2 ������
	return value;
}

stock SetXmasTree(Float:x,Float:y,Float:z, Float: zAngle)
{//�������� ���� � ���������� ������
	CreateDynamicObject(19076, x, y, z-1.0, 0, 0, zAngle, -1, -1, -1, 300.0);//����, ������� ����
	CreateDynamicObject(19054, x, y+1.0, z-0.4, 0, 0, zAngle, -1, -1, -1, 300.0);//XmasBox1
	CreateDynamicObject(19058, x+1.0, y, z-0.4, 0, 0, zAngle, -1, -1, -1, 300.0);//XmasBox5
	CreateDynamicObject(19056, x, y-1.0, z-0.4, 0, 0, zAngle, -1, -1, -1, 300.0);//XmasBox3
	CreateDynamicObject(19057, x-1.0, y, z-0.4, 0, 0, zAngle, -1, -1, -1, 300.0);//XmasBox4
	CreateDynamicObject(19058, x-1.5, y+1.5, z-1.0, 0, 0, zAngle, -1, -1, -1, 300.0);//XmasBox5
	CreateDynamicObject(19055, x+1.5, y-1.5, z-1.0, 0, 0, zAngle, -1, -1, -1, 300.0);//XmasBox2
	CreateDynamicObject(19057, x+1.5, y+1.5, z-1.0, 0, 0, zAngle, -1, -1, -1, 300.0);//XmasBox4
	CreateDynamicObject(19054, x-1.5, y-1.5, z-1.0, 0, 0, zAngle, -1, -1, -1, 300.0);//XmasBox1
	CreateDynamicObject(3526, x, y, z-1.0, 0, 0, zAngle, -1, -1, -1, 300.0);//Airportlight - ������ ��� ������� ������� ����
    CreateDynamicMapIcon(x, y, z, 37, 0, -1, -1, -1, 300 ); //���� ������� �� �����
    Create3DTextLabel("{007FFF}����\n{FFFFFF}������� [{FFFF00}Alt{FFFFFF}] ����� �������� �������", COLOR_WHITE, x, y, z, 20, 0);
	return 1;
}//�������� ���� � ���������� ������

stock FindWeapon(playerid, weaponid)
{//������� ��� ������ ������ � ������������ id. ���������� true, ���� ������ � ���� id ���� � ������
        new
            weapon,
            ammo;

        for (new i = 0; i < 13; i ++)
        {
            GetPlayerWeaponData(playerid, i, weapon, ammo);
            if (weapon == weaponid) return (true);
        }
        return (false);
}//������� ��� ������ ������ � ������������ id. ���������� true, ���� ������ � ���� id ���� � ������

stock QuestUpdate(playerid, questid, score)
{//���������� �������
	for (new i = 0; i <= 2; i++)
	{//����
	    if (Quest[playerid][i] != questid || QuestTime[playerid][i] > 0) continue;//����� ���������� �� ������� ���� � ������ ��� ����� ������
		QuestScore[playerid][i] += score;//���������� ������ ���-�� �����
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
		{//����� �������� �������
		    QuestTime[playerid][i] = 3600;//��������� ����� � ���� ����� ����� �������� ����� ���
		    if (Player[playerid][CasinoBalance] < 100000000 || Player[playerid][Prestige] >= 9) //����� ������ ������ ��� ��������� ������
		    	while(questid == Quest[playerid][0] || questid == Quest[playerid][1] || questid == Quest[playerid][2]) questid = random(30) + 1; //�������� ����� �����
			else //����� ������ ������ ��� ����������� ������
			    while(questid == Quest[playerid][0] || questid == Quest[playerid][1] || questid == Quest[playerid][2] || questid == 24) questid = random(30) + 1; //�������� ����� �����
		    QuestScore[playerid][i] = 0; Quest[playerid][i] = questid; //��������� ����� �����
   		    SendClientMessage(playerid, COLOR_QUEST, "QUEST: �� �������� 350 XP, 50 000$ � ������ �� �������� ���������� �������!");
		    Player[playerid][Medals]++; Player[playerid][CompletedQuests]++;
		    Player[playerid][Cash] += 50000; LGiveXP(playerid, 350);
		    PlayerPlaySound(playerid,1083,0.0,0.0,0.0);//���� ��������
		}//����� �������� �������
		
	}//����
	return 1;
}//���������� �������

public SobeitCamCheck(playerid)
{
	new Float:x, Float:y, Float:z; GetPlayerCameraFrontVector(playerid, x, y, z);
	if(z < -0.8)
	{//��������� Sobeit (UnFreeze ���)
        new String[140];
		format(String,sizeof(String), "[�������]LAC: {AFAFAF}%s[%d] ��� ������������� ������. {FF0000}�������: {AFAFAF}��������� ��� Sobeit",PlayerName[playerid], playerid);
        foreach(Player, cid) if (Player[cid][Admin] != 0 && Logged[cid] == 1) SendClientMessage(cid, COLOR_RED, String);
		format(String, 140, "%d.%d.%d � %d:%d:%d |   LAC: %s[%d] ��� ������������� ������. �������: ��������� ��� Sobeit", Day, Month, Year, hour, minute, second, PlayerName[playerid], playerid);
		WriteLog("GlobalLog", String);WriteLog("LACSobeit", String);
		SendClientMessage(playerid, COLOR_RED, "LAC: {AFAFAF}��������� ��� {FF0000}Sobeit{AFAFAF}! ������� ��� � ����������� � ����!");
		TogglePlayerControllable(playerid, 1); SetCameraBehindPlayer(playerid);
		CancelSelectTextDraw(playerid); return GKick(playerid);
	}//��������� Sobeit (UnFreeze ���)
	else
	{//Sobeit �� ���������
	   	TogglePlayerControllable(playerid, 1); CancelSelectTextDraw(playerid);
		FirstSobeitCheck[playerid] = 3;//�������� �� ������ ���������
	   	SendClientMessage(playerid, COLOR_RED, "LAC: {AFAFAF}�������� ������� ���������! �������� ����!");
		TextDrawHideForPlayer(playerid, BlackScreen);//������� ������ �����
		return LSpawnPlayer(playerid);
	}//Sobeit �� ���������
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
    if(FirstSobeitCheck[playerid] == 2 && clickedid != BlackScreen) return Kick(playerid);//����� ����� Esc ��� �������� �� Sobeit
	return 1;
}

public DestroyCashPickup(pickupid)
{//����������� ������, ������� �������� ����� �� ����� ���������
	DynamicPickup[pickupid][Type] = -1;//��� ������ - ������
	DynamicPickup[pickupid][ID] = -1;//����� �����
	DynamicPickup[pickupid][DestroyTimerID] = -1;
	DestroyDynamicPickup(pickupid);
	return 1;
}//����������� ������, ������� �������� ����� �� ����� ���������


	
