//
// Created:     08.09.06
// Aurthor:    Iain Gilbert
// ReCreate: Artem Firstov (Konsul)

#if defined _race_included
  #endinput
#endif

#define _race_included
#pragma library race
#include "base"
#include "player"
#include "world"
#include "vehicles"

forward CheckRace();
forward RaceCommandHandler(playerid,text[]);
forward RegisterRace(name[]);
forward race_OnPlayerEnterRaceCP(playerid);
forward RefreshRaceCar(plveh, is_used);

#define MAX_CP 170
#define MAX_RACES 50

#define RACE_STATE_DISABLED 0
#define RACE_STATE_SLEEPING 1
#define RACE_STATE_LINEUP 2
#define RACE_STATE_COUNTDOWN 3
#define RACE_STATE_RACING 4

#define RACE_TYPE_SPRINT 0
#define RACE_TYPE_LAPS 1
#define RACE_TYPE_STUNT 2
#define RACE_TYPE_AERO 3
#define RACE_TYPE_DERBY 4
#define RACE_TYPE_MULTI 5

#define INVALID_RACE_ID 0

#define MAX_VEH_DERBY 8+1

new RacesCount;

#define RACE_UPD_TIME 2000 // время через которое происходит update race
#define Race4METimeMAX 150 // количество циклов update race
new Race4METime = 0; // сколько циклов осталось чтобы разрешить команду 4me

enum RaceInfo{
 race_name[MAX_NAME],    // name of race
 race_type,             // race state
 race_minlevel,         // minimum level required to enter race
 race_minracers,         // minimum racers needed to race
 race_maxracetime,       // max time player can take to complete a race
 race_frequency,        // frquency that race runs
 race_lineupdelay,       // time to wait for players to linup
 race_cashprize,   // cash earned for 1st position
 race_cashentry,   // Cash required to enter (earned by winner)
 race_xpprize,    // xp earned for 1st position
 race_xpbonus,   // xp earned per player still in race
 race_vehicles[MAX_VEHICLES], // vehicles allowed in race
 Float:race_startheading, // startline heading
 race_interior,
 Float:derby_z,
 race_derby_veh[MAX_VEH_DERBY+1]
}
new Race[MAX_RACES][RaceInfo];


enum RaceStatsInfo {
 race_state,             // race state
 race_questid,           // quest id race is assigned
 race_activecpid,        // active cp id race is assigned
 race_timer,       // race timer
 race_racercount,    // count of racers
 race_position           // how many ppl have completed race alrready
}
new RaceStats[MAX_RACES][RaceStatsInfo];

enum RaceVechicleInfo{
Float: race_player_spX,
Float: race_player_spY,
Float: race_player_spZ,
Float: race_player_cX,
Float: race_player_cY,
Float: race_player_cZ,
Float: race_player_angel
//Float: race_player_rX
//Float: race_player_rY
//Float: race_player_rZ
}
new RacePlayerVechicleStats[MAX_PLAYERS][RaceVechicleInfo];

/*
enum multiraceinfo{
	member_id,
	//member_vehmodel,
	member_stat,
	member_raceid,
	member_cpid
}
enum multiracecpinfo{
	Float:member_vehang,
	Float:member_vehvelx,
	Float:member_vehvely,
	Float:member_vehvelz,
	Float:member_x,
	Float:member_y,
	Float:member_z
}

new MultiraceStat[MAX_VEHICLES][multiraceinfo];
new MultiraceCP[MAX_PLAYERS][MAX_CP][multiracecpinfo];
*/
enum RacePlayerInfo {
 race_player_time,   // time player has been in race
 race_player_cp,
 race_player_vehicle, // use for derby and multi race
 Text3D:race_player_3d,
 race_player_model,
 race_player_status
}
new RacePlayerStats[MAX_PLAYERS][RacePlayerInfo];

enum RaceScoreInfo {
 race_score_player[MAX_NAME],
 race_score_time,
 race_score_vehicle[MAX_NAME]
};
new BestScore[MAX_RACES][RaceScoreInfo];

new RaceSize[MAX_RACES]; // number of checkpoints, including start and finish
//new CPSize=8; // size of checkpoints
new Float:RaceCheckpoints[MAX_RACES][MAX_CP][CoordInfo]; //  someone tell me... why does this work? i thought pawn only suppors 2d arrays
//new Float:DerbyFailCheck[MAX_RACES][CoordInfo]; //  кто нибудь мне ответит.. это вообще работает? я думал что павн поддерживает только 2х мерный массив

//--------------------------------------------------------------
Float:GetRaceCPX(raceid,cpid)
{
 return RaceCheckpoints[raceid][cpid][Coord_X];
}
Float:GetRaceCPY(raceid,cpid)
{
 return RaceCheckpoints[raceid][cpid][Coord_Y];
}
Float:GetRaceCPZ(raceid,cpid)
{
 return RaceCheckpoints[raceid][cpid][Coord_Z];
}

GetRaceCPSize(raceid)
{
if(Race[raceid][race_type] == 3 || Race[raceid][race_type] == 5) return 20;
return 8;
}

GetRaceCPType(raceid,cpid)
{
	return RaceCheckpoints[raceid][cpid][CP_type];
}

GetRaceAllowedCar(raceid,cpid)
{
	return RaceCheckpoints[raceid][cpid][allow_veh];
}

/*new DerbyCar[] = {
444,457,467,474,478,486,496,500,504,515,531,555,571,572,573,583,585,602,422,475
};*/
//--------------------------------------------------------------

new RaceDB[MAX_STRING] = "GTO/Race/GTO.Races.txt";
new RaceBaseDB[MAX_STRING] = "GTO/Race/";
new RaceRecordDB[MAX_STRING] = "GTO/Race/Record/";

RaceLoadAll()
{
    if (ForceOverwrite) return;
 new temp[MAX_STRING];
 if (!dini_Exists(ConfigDB)) dini_Create(ConfigDB);
 set(temp,dini_Get(ConfigDB,"Race_DB"));
 if (strlen(temp) > 0) set(RaceDB,temp);
 set(temp,dini_Get(ConfigDB,"Race_Base_DB"));
 if (strlen(temp) > 0) set(RaceBaseDB,temp);
 set(temp,dini_Get(ConfigDB,"Race_Record_DB"));
 if (strlen(temp) > 0) set(RaceRecordDB,temp);
 if (!dini_Exists(RaceDB))
 {
  dini_Create(RaceDB);
 }
 
 for (new racedbid=0;racedbid<MAX_RACES;racedbid++)
  { // load all our races from db
      new cellname[MAX_STRING];
  format(cellname,sizeof(cellname), lang_texts[10][1] ,racedbid);
  set(temp,dini_Get(RaceDB,cellname));
   if (strlen(temp) == 0) continue;
     if (!RaceBaseDBExists(temp)) continue;
   new raceid = RegisterRace(temp);
   if (raceid == INVALID_RACE_ID) continue;
   RaceLoadBaseDB(raceid);
   //RaceLoadRecordDB(raceid);
 }

 return;
}

RaceLoadRecordDBAll()
{
	for (new raceid=1; raceid<=RacesCount;raceid++)
	{
	if (raceid == INVALID_RACE_ID) {continue;}
	RaceLoadRecordDB(raceid);
	}
}

RaceBaseDBExists(racename[MAX_STRING])
{
 new rdbname[MAX_STRING];
 format(rdbname,sizeof(rdbname),"%sGTO.Race.%s.txt",RaceBaseDB,racename);
 if (!dini_Exists(rdbname))
 {
  return 0;
 }
 return 1;
}


RaceLoadBaseDB(raceid)
{ // load race from db
 new temp[MAX_STRING];
 new rdbname[MAX_STRING];
 format(rdbname,sizeof(rdbname),"%sGTO.Race.%s.txt",RaceBaseDB,Race[raceid][race_name]);
 if (!dini_Exists(rdbname))
 {
  return INVALID_RACE_ID;
 }
 set(temp,dini_Get(rdbname,"Name"));
 if (strlen(temp) > 0) set(Race[raceid][race_name],temp);
  set(temp,nullstr);
  
 if (raceid == INVALID_RACE_ID)
 {
   printf("Race: '%s' Failed to load. (db)",Race[raceid][race_name]);
        new logstring[256];
  format(logstring, sizeof (logstring), "Race (DB): %s Failed to load", Race[raceid][race_name]);
     WriteLog(logstring);
  return INVALID_RACE_ID;
 }
 
  set(temp,dini_Get(rdbname,"Race_Frequency"));
  if (strlen(temp) > 0) Race[raceid][race_frequency] = strval(temp);
  set(temp,nullstr);
  
  set(temp,dini_Get(rdbname,"Lineup_Delay"));
  if (strlen(temp) > 0) Race[raceid][race_lineupdelay] = strval(temp);
  set(temp,nullstr);
  
  set(temp,dini_Get(rdbname,"Min_Racers"));
  if (strlen(temp) > 0) Race[raceid][race_minracers] = strval(temp);
  set(temp,nullstr);

  set(temp,dini_Get(rdbname,"Min_Level"));
  if (strlen(temp) > 0) Race[raceid][race_minlevel] = strval(temp);
  set(temp,nullstr);
  
  set(temp,dini_Get(rdbname,"Cash_Prize"));
  if (strlen(temp) > 0) Race[raceid][race_cashprize] = strval(temp);
  set(temp,nullstr);
  
  set(temp,dini_Get(rdbname,"Cash_Entry"));
  if (strlen(temp) > 0) Race[raceid][race_cashentry] = strval(temp);
  set(temp,nullstr);
  
  set(temp,dini_Get(rdbname,"XP_Prize"));
  if (strlen(temp) > 0) Race[raceid][race_xpprize] = strval(temp);
  set(temp,nullstr);
  
  set(temp,dini_Get(rdbname,"XP_Bonus"));
  if (strlen(temp) > 0) Race[raceid][race_xpbonus] = strval(temp);
  set(temp,nullstr);
  
  set(temp,dini_Get(rdbname,"Race_Time"));
  if (strlen(temp) > 0) Race[raceid][race_maxracetime] = strval(temp);
  set(temp,nullstr);
  
  set(temp,dini_Get(rdbname,"Startline_Heading"));
  if (strlen(temp) > 0) Race[raceid][race_startheading] = floatstr(temp);
  set(temp,nullstr);
  
  //CPSize = 8;
  new cpcount;
  for (new cpid=0;cpid<MAX_CP;cpid++)
  {
      new cellname[MAX_STRING];
  format(cellname,sizeof(cellname), lang_texts[10][2] ,cpid);
  set(temp,dini_Get(rdbname,cellname));
   if (strlen(temp) == 0) break;
   
   new Float:X;
   new Float:Y;
   new Float:Z;
   new idx=0;
    X= floatstr(strcharsplit(temp,idx,strchar(",")));
   Y = floatstr(strcharsplit(temp,idx,strchar(",")));
   Z = floatstr(strcharsplit(temp,idx,strchar(",")));
   set(temp,nullstr);
   if (( X== 0.0) && (Y == 0.0)) break;
  RaceCheckpoints[raceid][cpid][Coord_X] = X;
  RaceCheckpoints[raceid][cpid][Coord_Y] = Y;
  RaceCheckpoints[raceid][cpid][Coord_Z] = Z;
  cpcount++;
 }
  
 RaceSize[raceid] = cpcount;
 RaceStats[raceid][race_state] = RACE_STATE_SLEEPING;
 RaceStats[raceid][race_timer] = MakeRaceSleepTime(raceid);
   printf("Race (DB): '%s' Loaded.",Race[raceid][race_name]);
    new logstring[256];
 format(logstring, sizeof (logstring), "Race (DB): %s Loaded", Race[raceid][race_name]);
    WriteLog(logstring);
 return raceid;
}

MakeRaceSleepTime(raceid)
{
 new sleeptime;
 if (Race[raceid][race_frequency] == 0) Race[raceid][race_frequency] = 5;
 sleeptime = ((Race[raceid][race_frequency] * RacesCount) * (70 + random(5)) );
 return sleeptime;
}

RaceLoadRecordDB(raceid)
{
 new rdbname[MAX_STRING];
 new temp[MAX_STRING];
  format(rdbname,sizeof(rdbname),"%sGTO.Race.Record.%s.txt",RaceRecordDB,Race[raceid][race_name]);
  if (!dini_Exists(rdbname)) return;
 set(temp,dini_Get(rdbname,"Best_Time_Record"));
 if (strlen(temp) > 0) BestScore[raceid][race_score_time] = strval(temp);
 set(temp,nullstr);
 set(temp,dini_Get(rdbname,"Best_Time_Player"));
 if (strlen(temp) > 0) set(BestScore[raceid][race_score_player],temp);
 set(temp,nullstr);
 set(temp,dini_Get(rdbname,"Best_Time_Vehicle"));
 if (strlen(temp) > 0) set(BestScore[raceid][race_score_vehicle],temp);
 set(temp,nullstr);
}

RaceSaveAll()
{

 if (!dini_Exists(ConfigDB)) dini_Create(ConfigDB);
 dini_Set(ConfigDB,"Race_Base_DB",RaceBaseDB);
 dini_Set(ConfigDB,"Race_Record_DB",RaceRecordDB);
 
 if (!dini_Exists(RaceDB)) dini_Create(RaceDB);
 for (new raceid=1;raceid<=RacesCount;raceid++)
  { // load all our races from db
      if (RaceStats[raceid][race_state] == RACE_STATE_DISABLED) continue;
      new cellname[MAX_STRING];
  format(cellname,sizeof(cellname), lang_texts[10][3] ,raceid);
  dini_Set(RaceDB,cellname,Race[raceid][race_name]);
  
   RaceSaveBaseDB(raceid);
   RaceSaveRecordDB(raceid);
 }
}

stock RaceSaveScores()
{
 if (!dini_Exists(ConfigDB)) dini_Create(ConfigDB);
 dini_Set(ConfigDB,"Race_Base_DB",RaceBaseDB);
 dini_Set(ConfigDB,"Race_Record_DB",RaceRecordDB);

 if (!dini_Exists(RaceDB)) dini_Create(RaceDB);
 for (new raceid=1;raceid<=RacesCount;raceid++)
  { // load all our races from db
      if (RaceStats[raceid][race_state] == RACE_STATE_DISABLED) continue;
      new cellname[MAX_STRING];
  format(cellname,sizeof(cellname), lang_texts[10][4] ,raceid);
  dini_Set(RaceDB,cellname,Race[raceid][race_name]);
   RaceSaveRecordDB(raceid);
 }
}

RaceSaveBaseDB(raceid)
{ // save race to db
 if (RaceStats[raceid][race_state] == RACE_STATE_DISABLED) return;
 new temp[MAX_STRING];
 new rdbname[MAX_STRING];
 format(rdbname,sizeof(rdbname),"%sGTO.Race.%s.txt",RaceBaseDB,Race[raceid][race_name]);
 if (!dini_Exists(rdbname))
 {
  dini_Create(rdbname);
 }
 dini_Set(rdbname,"Name",Race[raceid][race_name]);
 
 valstr(temp,Race[raceid][race_frequency]);
  dini_Set(rdbname,"Race_Frequency",temp);
  set(temp,nullstr);

 valstr(temp,Race[raceid][race_lineupdelay]);
  dini_Set(rdbname,"Lineup_Delay",temp);
  set(temp,nullstr);

 valstr(temp,Race[raceid][race_minracers]);
  dini_Set(rdbname,"Min_Racers",temp);
  set(temp,nullstr);

 valstr(temp,Race[raceid][race_minlevel]);
  dini_Set(rdbname,"Min_Level",temp);
  set(temp,nullstr);

 valstr(temp,Race[raceid][race_cashprize]);
  dini_Set(rdbname,"Cash_Prize",temp);
  set(temp,nullstr);

 valstr(temp,Race[raceid][race_cashentry]);
  dini_Set(rdbname,"Cash_Entry",temp);
  set(temp,nullstr);

  valstr(temp,Race[raceid][race_xpprize]);
  dini_Set(rdbname,"XP_Prize",temp);
  set(temp,nullstr);

  valstr(temp,Race[raceid][race_xpbonus]);
  dini_Set(rdbname,"XP_Bonus",temp);
  set(temp,nullstr);

  valstr(temp,Race[raceid][race_maxracetime]);
  dini_Set(rdbname,"Race_Time",temp);
  set(temp,nullstr);

  format(temp,sizeof(temp),"%f",Race[raceid][race_startheading]);
  dini_Set(rdbname,"Startline_Heading",temp);
  set(temp,nullstr);
  
  for (new cpid=0;cpid<RaceSize[raceid];cpid++)
  {
      new cellname[MAX_STRING];
  format(cellname,sizeof(cellname), lang_texts[10][5] ,cpid);
  format(temp,sizeof(temp), lang_texts[10][6] ,RaceCheckpoints[raceid][cpid][Coord_X],RaceCheckpoints[raceid][cpid][Coord_Y],RaceCheckpoints[raceid][cpid][Coord_Z]);
  dini_Set(rdbname,cellname,temp);
 }
 
 new logstring[256];
 format(logstring, sizeof (logstring), "Race base saved: %s",Race[raceid][race_name]);
    WriteLog(logstring);
}

RaceSaveRecordDB(raceid)
{
 new temp[MAX_STRING];
 new rdbname[MAX_STRING];
  format(rdbname,sizeof(rdbname),"%sGTO.Race.Record.%s.txt",RaceRecordDB,Race[raceid][race_name]);
 if (!dini_Exists(rdbname)) dini_Create(rdbname);
  dini_Set(rdbname,"Name",Race[raceid][race_name]);
  set(temp,nullstr);
  valstr(temp,BestScore[raceid][race_score_time]);
  dini_Set(rdbname,"Best_Time_Record",temp);
  set(temp,nullstr);
  set(temp,BestScore[raceid][race_score_player]);
  dini_Set(rdbname,"Best_Time_Player",temp);
  set(temp,nullstr);
  set(temp,BestScore[raceid][race_score_vehicle]);
  dini_Set(rdbname,"Best_Time_Vehicle",temp);
 return;
}

public CheckRace() // must be ran by timer every second
{
	if(Race4METime > 0){ Race4METime--; }
	new string [MAX_STRING];
	for (new raceid=1; raceid<=RacesCount;raceid++)
	{
		switch( RaceStats[raceid][race_state] )
		{
			case RACE_STATE_DISABLED: { continue; }
			case RACE_STATE_SLEEPING:
			{
				if (RaceStats[raceid][race_timer] <= 0) // if it is time to run
				{
					RaceStats[raceid][race_timer] = 0;
					StartRaceLineup(raceid);
					continue;
				}
				RaceStats[raceid][race_timer]--;
				continue;
			}
			case RACE_STATE_LINEUP:
			{
				RaceStats[raceid][race_timer]++;
				if (RaceStats[raceid][race_timer] >= Race[raceid][race_lineupdelay]) // if it is time to run
				{
					RaceStats[raceid][race_timer] = 0;
					StartRaceCountdown(raceid);
				}
				else
				{
					if (RaceStats[raceid][race_racercount] > 0)
					{
						switch( Race[raceid][race_lineupdelay] - RaceStats[raceid][race_timer] )
						{
							case 5,10,20,30,45,60,90:
							{
							    if(Race[raceid][race_type] == 4)
								{
   								format(string, sizeof(string),
								lang_texts[10][65] ,
									(Race[raceid][race_lineupdelay] - RaceStats[raceid][race_timer]));
								SendMessageToRacers(raceid,string,COLOUR_ORANGE);
							    } else {
								format(string, sizeof(string), 
								lang_texts[10][7] ,
									(Race[raceid][race_lineupdelay] - RaceStats[raceid][race_timer]));
								SendMessageToRacers(raceid,string,COLOUR_RACE);
								}
							}
						}
					}
				}
				continue;
			}
			case RACE_STATE_COUNTDOWN:
			{
				RaceStats[raceid][race_timer]++;
				
				for (new playerid=0; playerid<MAX_PLAYERS;playerid++)
				{
					if (!IsPlayerConnected(playerid)) { continue; }			
					if (PlayerQuest[playerid] != GetRaceQuestID(raceid)) { continue; }
					if (MAX_COUNTDOWN - RaceStats[raceid][race_timer] > 0)
					{
						format(string, sizeof(string), "%d", MAX_COUNTDOWN - RaceStats[raceid][race_timer]);
						PlayerPlaySound(playerid,1056,GetRaceCPX(raceid,RacePlayerStats[playerid][race_player_cp]),GetRaceCPY(raceid,RacePlayerStats[playerid][race_player_cp]),GetRaceCPZ(raceid,RacePlayerStats[playerid][race_player_cp]));
					}
					else
					{
						if( Race[raceid][race_type] == RACE_TYPE_DERBY )
						{
							format(string, sizeof(string), "Stay Alive!");
						}
						else
						{
							format(string, sizeof(string), "GO!");
						}
						PlayerPlaySound(playerid,1057,GetRaceCPX(raceid,RacePlayerStats[playerid][race_player_cp]),GetRaceCPY(raceid,RacePlayerStats[playerid][race_player_cp]),GetRaceCPZ(raceid,RacePlayerStats[playerid][race_player_cp]));
					}
					GameTextForPlayer(playerid, string,1000,6);
				}
   
				if (RaceStats[raceid][race_timer] >= MAX_COUNTDOWN)
				{
					StartRace(raceid);
					RaceStats[raceid][race_timer] = 0;
				}
				continue;
			}
			case RACE_STATE_RACING:
			{
				RaceStats[raceid][race_timer]++;
				
				if (RaceStats[raceid][race_timer] >= Race[raceid][race_maxracetime]) // if time limit reached
				{
					EndRace(raceid);
					RaceStats[raceid][race_timer] = 0;
				}
				if(Race[raceid][race_type] == 4)
				{
				    for (new playerid=0; playerid<MAX_PLAYERS;playerid++)
   		    		{
   						if(PlayerQuest[playerid] == GetRaceQuestID(raceid))
   						{
	   						new Float: pPos[4];
		    				new Float:vehhp;
							new VeheStr[80];
		    				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		    				{
								GetVehiclePos(GetPlayerVehicleID(playerid),pPos[0],pPos[1],pPos[2]);
			    				GetVehicleHealth(GetPlayerVehicleID(playerid), vehhp);
								format(VeheStr,sizeof(VeheStr),"%d hp",floatround(vehhp,floatround_round));
								Update3DTextLabelText(RacePlayerStats[playerid][race_player_3d],COLOUR_YELLOW,VeheStr);
								//UpdatePlayer3DTextLabelText(playerid, RacePlayerStats[playerid][race_player_3d], COLOUR_YELLOW, VeheStr);
							}
							if(pPos[2] <= Race[raceid][derby_z] || GetPlayerState(playerid) != PLAYER_STATE_DRIVER || vehhp < 250.0)
							{
								WinDerby(raceid,playerid);
								LeaveRace(raceid,playerid);
							}
						}
					}
				}
			}
		}
	}
}



public RaceCommandHandler(playerid,text[]) // process player commands
{
 if (!IsPlayerRegistered(playerid))
 {
  return 0; // non registered players dont use weapon commands
 }

 new cmd[20];
 new idx;
 //new string[MAX_STRING];

 set(cmd,strcharsplit(text, idx,strchar(" ")));
 if (strlen(cmd) == 0) return 0;

    if(strcomp(cmd, "/races", true) == 1)
 {

  SendPlayerCurrentRaces(playerid);
      return 1;
 }
 
 // if(strcomp(cmd, "/racetest", true) == 1)
 // {
 // new test;
 // new string[256];
 // test = LineupRacesCount();
 // format(string, sizeof(string)," %d", test);
 // SendPlayerScrollingText(playerid,string);
 // return 1;
 // }

    if(strcomp(cmd, "/race", true) == 1)
 {
     set(cmd,strcharsplit(text, idx,strchar(" ")));
	 
	 //if(strcomp(cmd, "records", true) == 1)
	 //{
	 //SendPlayerRacesRecords(playerid);
	 //return 1;
	 //}
	 
     if(strcomp(cmd, "help", true) == 1)
  {
   SendPlayerScrollingText(playerid, lang_texts[10][8] );
   SendPlayerScrollingText(playerid, lang_texts[10][9] );
   SendPlayerScrollingText(playerid, lang_texts[10][10] );
   SendPlayerScrollingText(playerid, lang_texts[10][11] );
   SendPlayerScrollingText(playerid, lang_texts[10][12] );
   SendPlayerScrollingText(playerid, lang_texts[10][13] );
   SendPlayerScrollingText(playerid, lang_texts[10][14] );
   SendPlayerScrollingText(playerid, lang_texts[10][15] );
   SendPlayerScrollingText(playerid, lang_texts[10][16] );
   SendPlayerScrollingText(playerid, lang_texts[10][17] );
   return 1;
  }
   
// команда запуска гонки

if(strcomp(cmd, "4me", true) == 1)
{
	if(Race4METime > 0)
	{
	new string[MAX_STRING];
	format(string,sizeof(string), "Команда будет доступна через %d секунд" ,Race4METime*2);
	return SendClientMessage(playerid, COLOUR_CRIMSON, string);
	}
	if(GetPlayerMoney(playerid) < (Player[playerid][Level]*2000)) {SendClientMessage(playerid, 0xFFFFFFFF, " У вас недостаточно средств."); return 1;}
	new allowrc[MAX_RACES];// MAX_RACES = 50
	new astep = -1;
	new active;

	for(new i=1;i<=RacesCount;i++)
	{
		if(RaceStats[i][race_state] == RACE_STATE_LINEUP){active++;}
		if(GetPlayerLevel(playerid) >= Race[i][race_minlevel] && RaceStats[i][race_state] == RACE_STATE_SLEEPING)
		{
			if(astep == -1){astep = 0;}
			allowrc[astep] = i;
			astep++;
		}
	}
	if(astep == -1) {SendClientMessage(playerid, 0xFFFFFFFF, " Нет доступных гонок =("); return 1;}
	if(active > 3){SendClientMessage(playerid, 0xFFFFFFFF, " Слишком много активных гонок!"); return 1;}
	new rid, rrid;
	if(astep != 1){rid = random(astep);}
	oGivePlayerMoney(playerid, (0 - (Player[playerid][Level]*2000)),1);
	rrid = allowrc[rid];
	RaceStats[rrid][race_timer] = 0;
	//StartRaceLineup(rrid);
	Race4METime = Race4METimeMAX;
	return 1;
}

// конец зхапуска гонки




     if(strcomp(cmd, "join", true) == 1)
  {
   new raceid;
   raceid = strval(strcharsplit(text, idx,strchar(" ")));
   if (PlayerQuest[playerid] != 0)
   {
    SendPlayerFormattedText(playerid, lang_texts[10][18] , 0,COLOUR_RED);
    return 1;
   }
   if ((raceid == 0) || (raceid >= MAX_RACES))
   {
    SendPlayerFormattedText(playerid, lang_texts[10][19] , 0,COLOUR_RED);
    return 1;
   }
   if (RaceStats[raceid][race_state] == RACE_STATE_DISABLED)
   {
    SendPlayerFormattedText(playerid, lang_texts[10][20] , 0,COLOUR_RED);
    return 1;
   }
   if (RaceStats[raceid][race_state] == RACE_STATE_RACING)
   {
    SendPlayerFormattedText(playerid, lang_texts[10][21] , 0,COLOUR_RED);
    return 1;
   }
   if (RaceStats[raceid][race_state] != RACE_STATE_LINEUP)
   {
    SendPlayerFormattedText(playerid, lang_texts[10][22] , 0,COLOUR_RED);
    return 1;
   }
   if(Race[raceid][race_type] != 4) {
	new isset = GetPlayerVehicleSeat(playerid);
	if(!IsPlayerInAnyVehicle(playerid) || isset != 0 )
	{
		ShowPlayerDialog(playerid, R_GUI, 0,"Race security","Вы должны находиться в транспорте для телепортации к месту гонки!","ОК","Эвенты");
		return 1;
	}
	}
   JoinRace(raceid,playerid);
       return 1;
  }
  if((strcomp(cmd, "leave", true) == 1) || (strcomp(cmd, "quit", true) == 1))
  {
   if (PlayerQuest[playerid] == 0)
   {
    SendPlayerFormattedText(playerid, lang_texts[10][23] , 0,COLOUR_RED);
    return 1;
   }
   new raceid = GetPlayerRace(playerid);
   if (raceid == 0)
   {
    SendPlayerFormattedText(playerid, lang_texts[10][24] , 0,COLOUR_RED);
    return 1;
   }
   LeaveRace(raceid,playerid);
       return 1;
  }
      return 0;
 }
 return 0;
}

public RefreshRaceCar(plveh, is_used)
{
    new Float:x,Float:y,Float:z,Float:a;
	DestroyVehicle(plveh);
	if(is_used == 1)
    {
		SetVehiclePos(plveh,x,y,z);
		SetVehicleZAngle(plveh,a);
	}
	return plveh;
}

AddRaceCP(raceid,Float:x,Float:y,Float:z)
{
 if (RaceSize[raceid] > MAX_CP) return 0;
 new cpid = RaceSize[raceid];
 RaceCheckpoints[raceid][cpid][Coord_X] = x;
 RaceCheckpoints[raceid][cpid][Coord_Y] = y;
 RaceCheckpoints[raceid][cpid][Coord_Z] = z;
 RaceSize[raceid]++;
 return 1;
}

RemoveLastRaceCP(raceid)
{
 if (RaceSize[raceid] < 1) return 0;
 new cpid = RaceSize[raceid]-1;
 RaceCheckpoints[raceid][cpid][Coord_X] = 0.0;
 RaceCheckpoints[raceid][cpid][Coord_Y] = 0.0;
 RaceCheckpoints[raceid][cpid][Coord_Z] = 0.0;
 RaceSize[raceid]--;
 return 1;
}

public RegisterRace(name[])
{
 for (new i=0;i<MAX_RACES;i++)
 {
     if (RaceStats[i][race_state] == RACE_STATE_DISABLED) continue;
     if (strcomp(name,Race[i][race_name],true)==1)
     {
         return INVALID_RACE_ID;
     }
 }
 
 RacesCount++;
 if (RacesCount >= MAX_RACES) return INVALID_RACE_ID;
  new raceid = RacesCount;
  RaceStats[raceid][race_questid] = RegisterQuest(name, 1);
  if (RaceStats[raceid][race_questid] == INVALID_RACE_ID)
 {
  RacesCount--;
   return INVALID_RACE_ID;
 }
 set(Race[raceid][race_name],name);
  return raceid;
}

StartRace(raceid)
{
	RaceStats[raceid][race_state] = RACE_STATE_RACING;
	RaceStats[raceid][race_timer]=0;
	
	if(Race[raceid][race_type] == RACE_TYPE_DERBY)
	{
		for (new playerid=0; playerid<MAX_PLAYERS;playerid++)
		{
			if (IsPlayerConnected(playerid))
			{
				if (PlayerQuest[playerid] == GetRaceQuestID(raceid)) // if player is in this race
				{
					TogglePlayerControllable(playerid, 1);
					/*SetPlayerPosEx(playerid, GetRaceCPX(raceid,0), GetRaceCPY(raceid,0), GetRaceCPZ(raceid,0) + 1);
					carforderby[playerid] = CreateVehicle(DerbyCar[random(sizeof(DerbyCar))],GetRaceCPX(raceid,0),GetRaceCPY(raceid,0),GetRaceCPZ(raceid,0) + 3,0,0,0,Race[raceid][race_maxracetime]);
					PutPlayerInVehicle(playerid, carforderby[playerid], 0);
					LinkVehicleToInterior(carforderby[playerid], Race[raceid][race_interior]);
					SetPlayerInterior(playerid,Race[raceid][race_interior]);*/
				}
			}
		}
	}
	else
	{
		for (new playerid=0; playerid<MAX_PLAYERS;playerid++)
		{
			if (IsPlayerConnected(playerid))
			{
				if (PlayerQuest[playerid] == GetRaceQuestID(raceid)) // if player is in this race
				{
					TogglePlayerControllable(playerid, 1);
					//oDisablePlayerCheckpoint(playerid);
					NextRaceCP(raceid,playerid);
				}
			}
		}	
	}
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
    new raceid = GetPlayerRace(playerid);
   	if(PlayerQuest[playerid] == GetRaceQuestID(raceid))
   	{
		if (RaceStats[raceid][race_state] == RACE_STATE_RACING)
		{
	   	    if(Race[raceid][race_type] == 4)
	   	    {
	   	        WinDerby(raceid,playerid);
	   	        LeaveRace(raceid,playerid);
	   	    }
	   	}
	}
	return 1;
}

stock WinDerby(raceid, playerid)
{
	if( RaceStats[raceid][race_racercount] > 3 )
	{
	    new string[MAX_STRING];
		new Lvl = GetPlayerScore(playerid);
		if(Lvl < 5) GivePlayerXP(playerid, 500/3,1);
		else if(Lvl > 4 && Lvl < 10) GivePlayerXP(playerid, 1000/3,1);
		else if(Lvl > 9 && Lvl < 15) GivePlayerXP(playerid, 2000/3,1);
		else if(Lvl > 14 && Lvl < 20) GivePlayerXP(playerid, 3000/3,1);
		else if(Lvl > 19 && Lvl < 25) GivePlayerXP(playerid, 4000/3,1);
		else if(Lvl > 24 && Lvl < 30) GivePlayerXP(playerid, 5000/3,1);
		else if(Lvl > 29 && Lvl < 35) GivePlayerXP(playerid, 6000/3,1);
		else if(Lvl > 34 && Lvl < 40) GivePlayerXP(playerid, 7000/3,1);
  		format(string, sizeof(string),  " [Derby]: %s занял %d место в дерби %s" ,oGetPlayerName(playerid),RaceStats[raceid][race_racercount],Race[raceid][race_name]);
		SendClientMessageToAll(COLOUR_ORANGE, string);
	    return 1;
	}
	if( RaceStats[raceid][race_racercount] == 3 )
	{
	    new string[MAX_STRING];
		new Lvl = GetPlayerScore(playerid);
		if(Lvl < 5) GivePlayerXP(playerid, 500/2,1);
		else if(Lvl > 4 && Lvl < 10) GivePlayerXP(playerid, 1000/2,1);
		else if(Lvl > 9 && Lvl < 15) GivePlayerXP(playerid, 2000/2,1);
		else if(Lvl > 14 && Lvl < 20) GivePlayerXP(playerid, 3000/2,1);
		else if(Lvl > 19 && Lvl < 25) GivePlayerXP(playerid, 4000/2,1);
		else if(Lvl > 24 && Lvl < 30) GivePlayerXP(playerid, 5000/2,1);
		else if(Lvl > 29 && Lvl < 35) GivePlayerXP(playerid, 6000/2,1);
		else if(Lvl > 34 && Lvl < 40) GivePlayerXP(playerid, 7000/2,1);
		format(string, sizeof(string),  " [Derby]: %s занял %d место в дерби %s" ,oGetPlayerName(playerid),RaceStats[raceid][race_racercount],Race[raceid][race_name]);
		SendClientMessageToAll(COLOUR_ORANGE, string);
	    return 1;
	}
	if( RaceStats[raceid][race_racercount] == 2 )
	{
	    new string[MAX_STRING];
		new Lvl = GetPlayerScore(playerid);
		if(Lvl < 5) GivePlayerXP(playerid, 500,1);
		else if(Lvl > 4 && Lvl < 10) GivePlayerXP(playerid, 1000,1);
		else if(Lvl > 9 && Lvl < 15) GivePlayerXP(playerid, 2000,1);
		else if(Lvl > 14 && Lvl < 20) GivePlayerXP(playerid, 3000,1);
		else if(Lvl > 19 && Lvl < 25) GivePlayerXP(playerid, 4000,1);
		else if(Lvl > 24 && Lvl < 30) GivePlayerXP(playerid, 5000,1);
		else if(Lvl > 29 && Lvl < 35) GivePlayerXP(playerid, 6000,1);
		else if(Lvl > 34 && Lvl < 40) GivePlayerXP(playerid, 7000,1);
		format(string, sizeof(string),  " [Derby]: %s занял 2 место в дерби %s" ,oGetPlayerName(playerid),Race[raceid][race_name]);
		SendClientMessageToAll(COLOUR_ORANGE, string);
	    return 1;
	}
	if( RaceStats[raceid][race_racercount] == 1 )
	{
	    new string[MAX_STRING];
		new Lvl = GetPlayerScore(playerid);
		if(Lvl < 5) GivePlayerXP(playerid, 500*2,1);
		else if(Lvl > 4 && Lvl < 10) GivePlayerXP(playerid, 1000*2,1);
		else if(Lvl > 9 && Lvl < 15) GivePlayerXP(playerid, 2000*2,1);
		else if(Lvl > 14 && Lvl < 20) GivePlayerXP(playerid, 3000*2,1);
		else if(Lvl > 19 && Lvl < 25) GivePlayerXP(playerid, 4000*2,1);
		else if(Lvl > 24 && Lvl < 30) GivePlayerXP(playerid, 5000*2,1);
		else if(Lvl > 29 && Lvl < 35) GivePlayerXP(playerid, 6000*2,1);
		else if(Lvl > 34 && Lvl < 40) GivePlayerXP(playerid, 7000*2,1);
		GivePlayerRaceXP(playerid,3);
		format(string, sizeof(string),  " [Derby]: %s победил в дерби %s" ,oGetPlayerName(playerid),Race[raceid][race_name]);
		SendClientMessageToAll(COLOUR_ORANGE, string);
		LeaveRace(raceid,playerid);
		return 1;
	}
	return 1;
}

JoinRace(raceid,playerid)
{
 new PlayerState = GetPlayerState(playerid);
 new string[MAX_STRING];
 if(Player[playerid][Jailed] != 0)
 {
   ShowPlayerDialog(playerid, S_GUI_02, 0,"Тюрьма","Вы не можете участвовать в соревновании, т.к. находитесь под стражей в тюрьме!","ОК","");
   return;
 }
 	if(Player[playerid][train1] == 1)
	{
	    ShowPlayerDialog(playerid, S_GUI_02, 0,"Миссия Дальнобойщика","Для начала завершите миссию дальнобойщика","ОК","");
	    return;
	}
/* if (oGetPlayerMoney(playerid) < Race[raceid][race_cashentry])
 {
  format(string, sizeof(string),  lang_texts[10][25] , Race[raceid][race_cashentry]);
  SendPlayerFormattedText(playerid,string, 0,COLOUR_RED);
  return;
 }
 if (GetPlayerLevel(playerid) < Race[raceid][race_minlevel])
 {
  format(string, sizeof(string),  lang_texts[10][26] , Race[raceid][race_minlevel]);
  SendPlayerFormattedText(playerid,string, 0,COLOUR_RED);
  return;
 }
 */
 /*if ( !IsPlayerAdmin(playerid) )
 {
 if(Race[raceid][race_type] == 5)
 {
    ShowPlayerDialog(playerid, S_GUI_02, 0,"Мульти-гонка","На данный момент мульти-гонки находится на стадии тестировании.\nПриносим свои извинения!","ОК","");
    return;
 }
 }*/
 
 RaceStats[raceid][race_racercount]++;
 if (Race[raceid][race_minracers] > 1)
 {
  format(string, sizeof(string),  lang_texts[10][27] , oGetPlayerName(playerid),RaceStats[raceid][race_racercount],Race[raceid][race_minracers]);
        new logstring[256];
  format(logstring, sizeof (logstring), "player: %d:  %s: has joined the race. (Racers:%d/%d)",playerid,oGetPlayerName(playerid),RaceStats[raceid][race_racercount],Race[raceid][race_minracers]);
     WriteLog(logstring);
 }
 else
 {
  format(string, sizeof(string),  lang_texts[10][28] , oGetPlayerName(playerid),RaceStats[raceid][race_racercount]);
        new logstring[256];
  format(logstring, sizeof (logstring), "player: %d:  %s: has joined the race. (Racers:%d)",playerid,oGetPlayerName(playerid),RaceStats[raceid][race_racercount]);
     WriteLog(logstring);
 }
 SendMessageToRacers(raceid,string,COLOUR_WHITE);
   
 //oGivePlayerMoney(playerid,0-Race[raceid][race_cashentry],1);
 GameTextForPlayer(playerid, "~g~Race Entered.",3000,6);
 SetPlayerChatBubble(playerid, "Присоединился к гонке", COLOR_GREEN, 20.0, 2000);
 PlayerQuest[playerid] = GetRaceQuestID(raceid);
 RacePlayerStats[playerid][race_player_cp] = 0;
 //oSetPlayerCheckpoint(playerid,GetRaceCPX(raceid,RacePlayerStats[playerid][race_player_cp]),GetRaceCPY(raceid,RacePlayerStats[playerid][race_player_cp]),GetRaceCPZ(raceid,RacePlayerStats[playerid][race_player_cp]),CPSize);
 oSetPlayerRaceCheckpoint(playerid,2,GetRaceCPX(raceid,RacePlayerStats[playerid][race_player_cp]),GetRaceCPY(raceid,RacePlayerStats[playerid][race_player_cp]),GetRaceCPZ(raceid,RacePlayerStats[playerid][race_player_cp]),GetRaceCPX(raceid,1+RacePlayerStats[playerid][race_player_cp]),GetRaceCPY(raceid,1+RacePlayerStats[playerid][race_player_cp]),GetRaceCPZ(raceid,1+RacePlayerStats[playerid][race_player_cp]),GetRaceCPSize(raceid));
if(Race[raceid][race_type] != 4){
new Float:X;
new Float:Y;
//new Float:Z;
new Float:Angle;
//new interior;
//GetPlayerPos(playerid,X,Y,Z);
//GetPlayerFacingAngle(playerid,Angle);
//interior = GetPlayerInterior(playerid);

if(IsPlayerInAnyVehicle(playerid)) {
//They're in a vehicle. Transport it, too.
new VehicleID;
VehicleID = GetPlayerVehicleID(playerid);
//oSetPlayerRaceCheckpoint(playerid,2,GetRaceCPX(raceid,0),GetRaceCPY(raceid,0),GetRaceCPZ(raceid,0),GetRaceCPX(raceid,1),GetRaceCPY(raceid,1),GetRaceCPZ(raceid,1),(GetRaceCPSize(raceid)));
SetVehiclePosEx(VehicleID, GetRaceCPX(raceid,0) + 3.01, GetRaceCPY(raceid,0) + 3.01, GetRaceCPZ(raceid,0) + 1);
SetPlayerFacingAngle(playerid,Angle);
LinkVehicleToInterior(VehicleID, Race[raceid][race_interior]);
} else {
	SetPlayerFacingAngle(playerid,Angle);
	X=GetRaceCPX(raceid,0)+(random(2)-random(4));Y=GetRaceCPY(raceid,0)+(random(2)-random(4));
	SetPlayerPosEx(playerid, X, Y, GetRaceCPZ(raceid,0) + 1);
	}
if(Race[raceid][race_interior] > 0) {
	SetPlayerInterior(playerid,Race[raceid][race_interior]);
}
}
 if (RaceStats[raceid][race_state] == RACE_STATE_LINEUP)
 {
 if(Race[raceid][race_type] == 4)
 {
   format(string, sizeof(string),  lang_texts[10][66] ,(Race[raceid][race_lineupdelay] - RaceStats[raceid][race_timer]));
   SendPlayerFormattedText(playerid, string, 0,COLOUR_ORANGE);
 } else {
  format(string, sizeof(string),  lang_texts[10][29] ,(Race[raceid][race_lineupdelay] - RaceStats[raceid][race_timer]));
   SendPlayerFormattedText(playerid, string, 0,COLOUR_RACE);
   }
 }
 
 if(PlayerState != PLAYER_STATE_DRIVER && PlayerState != PLAYER_STATE_PASSENGER)
 {
  SendPlayerFormattedText(playerid, lang_texts[10][30] , 0,COLOUR_RED);
 }
 else if(PlayerState == PLAYER_STATE_PASSENGER)
 {
  SendPlayerFormattedText(playerid, lang_texts[10][31] , 0,COLOUR_RED);
 }
 
 //new playervehiclemodel = GetSpawnVehicleModel(GetPlayerVehicleID(playerid)-1);
 new playervehiclemodel = GetVehicleModel(GetPlayerVehicleID(playerid));
 
 if (playervehiclemodel >= 400)
 {
  if ((IsVehicleAllowedInRace(raceid,playervehiclemodel) == 0) && Race[raceid][race_type] != 5)
  {
   SendClientMessage(playerid,COLOUR_RED,  lang_texts[10][32] );
   SendPlayerAllowedRaceVehicles(playerid,raceid);
  }
  if ((IsVehicleAllowedInRace(raceid,playervehiclemodel) == 0) && Race[raceid][race_type] == 5)
  {
   SendClientMessage(playerid,COLOUR_RED,  lang_texts[10][32] );
   SendPlayerAllowedRaceVehicles(playerid,raceid);
   }
 }
}

SendPlayerAllowedRaceVehicles(playerid,raceid)
{
 new string[MAX_STRING];
 if (strlen(Race[raceid][race_vehicles]) <= 10)
 {
 if(Race[raceid][race_type] != 5) {
  set(string, lang_texts[10][33]);
  } else if(Race[raceid][race_type] == 5) {
  set(string," Запрещённый транспорт: ");
  }
  for (new i=0;i<strlen(Race[raceid][race_vehicles]);i++)
  {
      if (Race[raceid][race_vehicles][i] == 0)  break;
         new carmodel = Race[raceid][race_vehicles][i];
         if (i>0) strins(string, ", ", strlen(string));
   strins(string, GetVehicleName(carmodel), strlen(string));
  }
  SendClientMessage(playerid,COLOUR_GREY, string);
    }
 else
 {
  if(Race[raceid][race_type] != 5) {
  SendPlayerScrollingText(playerid, lang_texts[10][33] );
  } else if(Race[raceid][race_type] == 5) {
  SendPlayerFormattedText(playerid," Запрещённый транспорт:", 0,0xCC38F1AA);
  }
  for (new i=0;i<strlen(Race[raceid][race_vehicles]);i++)
  {
         if (Race[raceid][race_vehicles][i] == 0)  break;
         new carmodel = Race[raceid][race_vehicles][i];
   format(string,sizeof(string),"%s",GetVehicleName(carmodel));
   SendPlayerScrollingText(playerid,string);
  }
 }
}

LeaveRace(raceid,playerid)
{
 new string[MAX_STRING];
 //ResetQuest(playerid);  // reset checkpoints
 oDisablePlayerRaceCheckpoint(playerid);
 PlayerQuest[playerid] = 0;
 
 RaceStats[raceid][race_racercount]--;
 RacePlayerStats[playerid][race_player_cp] = 0;
 RacePlayerStats[playerid][race_player_time] = 0;
 
 	if(Race[raceid][race_type] == RACE_TYPE_DERBY)
 	{
		DestroyVehicle( RacePlayerStats[playerid][race_player_vehicle] );
		RacePlayerStats[playerid][race_player_vehicle] = -1;
		OnPlayerSpawn(playerid);
		Delete3DTextLabel( RacePlayerStats[playerid][race_player_3d] );
		//DeletePlayer3DTextLabel( playerid, RacePlayerStats[playerid][race_player_3d] );
		GivePlayerOwnedWeapons(playerid);
 	}
 	if(RaceStats[raceid][race_state] != RACE_STATE_LINEUP && Race[raceid][race_type] == 5)
	{
	    RacePlayerStats[playerid][race_player_model] = -1;
	    RacePlayerStats[playerid][race_player_cp] = 0;
	    RacePlayerStats[playerid][race_player_status] = 0;
	    DestroyVehicle( RacePlayerStats[playerid][race_player_vehicle] );
	    RacePlayerStats[playerid][race_player_vehicle] = -1;
	}
 
 if (!IsPlayerConnected(playerid)) return;
 if (RaceStats[raceid][race_state] == RACE_STATE_LINEUP)
 {
     if (Race[raceid][race_minracers] > 1)
     {
    format(string, sizeof(string),  lang_texts[10][34] , oGetPlayerName(playerid),RaceStats[raceid][race_racercount],Race[raceid][race_minracers]);
            new logstring[256];
   format(logstring, sizeof (logstring), "player: %d:  %s: has left the race. (Racers:%d/%d)",playerid,oGetPlayerName(playerid),RaceStats[raceid][race_racercount],Race[raceid][race_minracers]);
      WriteLog(logstring);
  }
    else
    {
     format(string, sizeof(string),  lang_texts[10][35] , oGetPlayerName(playerid),RaceStats[raceid][race_racercount]);
            new logstring[256];
   format(logstring, sizeof (logstring), "player: %d:  %s: has left the race. (Racers:%d)",playerid,oGetPlayerName(playerid),RaceStats[raceid][race_racercount]);
      WriteLog(logstring);
  }
  SendMessageToRacers(raceid,string,COLOUR_GREY);
  //oGivePlayerMoney(playerid,Race[raceid][race_cashentry],1); // give player back thier cash entry
  GameTextForPlayer(playerid, "~r~Race Aborted.",5000,6);
  SendPlayerFormattedText(playerid,  lang_texts[10][36] , 0,COLOUR_RED);
   SetPlayerChatBubble(playerid, "Покинул к гонку", COLOR_RED, 20.0, 2000);
 }
 else
 {
	if( Race[raceid][race_type] == RACE_TYPE_DERBY )
	{
		if( RaceStats[raceid][race_racercount] == 1 )
		{
			for (new pl=0; pl<MAX_PLAYERS;pl++)
			{
				if (!IsPlayerConnected(pl)) { continue; }			
				if (PlayerQuest[pl] != GetRaceQuestID(raceid)) { continue; }
				WinDerby(raceid, pl);
			}
		}
	}
	
 
  format(string, sizeof(string),  lang_texts[10][37] , oGetPlayerName(playerid),RaceStats[raceid][race_racercount]);
  SendMessageToRacers(raceid,string,COLOUR_GREY);
  SendPlayerFormattedText(playerid,  lang_texts[10][38] , 0,COLOUR_RED);
  if (RaceStats[raceid][race_state] == RACE_STATE_COUNTDOWN)
  {
  TogglePlayerControllable(playerid, 1);
  }
 }
}

SendMessageToRacers(raceid,string[],colour)
{
 for (new racerid=0; racerid<MAX_PLAYERS;racerid++)
 {
     if (!IsPlayerConnected(racerid)) continue;
     if (PlayerQuest[racerid] == GetRaceQuestID(raceid)) // if player is in this race
     {
         SendPlayerFormattedText(racerid, string, 0,colour);
  }
 }
}

IsPlayerInRace(playerid,raceid)
{
 if (PlayerQuest[playerid] == GetRaceQuestID(raceid)) return 1;
 return 0;
}


GetRaceColourForPlayer(playerid,raceid)
{
 new colour = COLOUR_RACE;
 
 // if (RaceStats[raceid][race_racercount] >= Race[raceid][race_minracers]-1)
 // {
  // colour = COLOUR_RACE;
 // }
 
 //else if (RaceStats[raceid][race_racercount] == (Race[raceid][race_minracers]-1))
 //{
 // colour = COLOUR_YELLOW;
 //}
 
 // else if (RaceStats[raceid][race_racercount] < (Race[raceid][race_minracers]-1))
 // {
  // colour = COLOUR_RACE_BAD;
 // }
 
 if (GetPlayerLevel(playerid) < Race[raceid][race_minlevel])
 {
 if(Race[raceid][race_type] == 3)
 {
 colour = COLOUR_ARACE_BAD;
 }
 else if(Race[raceid][race_type] == 4)
 {
 colour = COLOUR_ORANGE;
 }
 else if(Race[raceid][race_type] == 5)
 {
 colour = COLOUR_MULTI_RACE;
 }
 else
 {
 colour = COLOUR_RACE_BAD;
 }
 }
 else
 {
 if(Race[raceid][race_type] == 3)
 {
 colour = COLOUR_ARACE;
 }
 else if(Race[raceid][race_type] == 4)
 {
 colour = COLOUR_ORANGE;
 }
 else if(Race[raceid][race_type] == 5)
 {
 colour = COLOUR_MULTI_RACE;
 }
 else
 {
 colour = COLOUR_RACE;
 }
 }
 return colour;
}

SendPlayerCurrentRaces(playerid)
{
 if (!IsPlayerConnected(playerid)) return;
 new string[MAX_STRING];
 new racefound;
 for (new raceid=1; raceid<=RacesCount;raceid++)
 {
     if (RaceStats[raceid][race_state] == RACE_STATE_LINEUP)
     {
         if (racefound == 0)
         {
          SendPlayerFormattedText(playerid,  lang_texts[10][39] , 0,COLOUR_RACE);
          racefound++;
         }
         if (RaceStats[raceid][race_racercount] >= Race[raceid][race_minracers])
         {
             format(string, sizeof(string),  lang_texts[10][40] ,Race[raceid][race_name],raceid,Race[raceid][race_lineupdelay] - RaceStats[raceid][race_timer],RaceStats[raceid][race_racercount],GetRaceCPZoneName(raceid,0));
   }
   else 
   {
    format(string, sizeof(string),  lang_texts[10][41] ,Race[raceid][race_name],raceid,Race[raceid][race_lineupdelay] - RaceStats[raceid][race_timer],RaceStats[raceid][race_racercount],Race[raceid][race_minracers],GetRaceCPZoneName(raceid,0));
   }
      SendPlayerFormattedText(playerid, string, 0,GetRaceColourForPlayer(playerid,raceid));
     }
     else if (IsPlayerAdmin(playerid))
     {
         if (strlen(Race[raceid][race_name]) > 0)
         {
       format(string, sizeof(string),  lang_texts[10][42] ,Race[raceid][race_name],raceid,Race[raceid][race_minlevel],Race[raceid][race_cashentry]);
             SendPlayerFormattedText(playerid, string, 0,COLOUR_RED);
   }
     }
 }
 if (racefound == 0)
 {
  SendPlayerFormattedText(playerid,  lang_texts[10][43] , 0,COLOUR_RED);
 }
}

GetPlayerRace(playerid)
{
 if (!IsPlayerConnected(playerid)) return 0;
 for (new raceid=1; raceid<=RacesCount;raceid++)
 {
     if (RaceStats[raceid][race_state] == RACE_STATE_DISABLED) continue;
     if (PlayerQuest[playerid] == GetRaceQuestID(raceid)) // if player is in this race
     {
         return raceid;
  }
 }
 return 0;
}

GetRaceQuestID(raceid)
{
 return RaceStats[raceid][race_questid];
}

CleanupRace(raceid)
{
 for (new playerid=0; playerid<MAX_PLAYERS;playerid++)
 {
  if (!IsPlayerConnected(playerid)) continue;
     if (PlayerQuest[playerid] == GetRaceQuestID(raceid)) // if player is in this race
     {
      LeaveRace(raceid,playerid);
  }
 }
 RaceStats[raceid][race_position] = 0;
 RaceStats[raceid][race_racercount] = 0;
 RaceStats[raceid][race_timer] = MakeRaceSleepTime(raceid);
 RaceStats[raceid][race_state] = RACE_STATE_SLEEPING;
 
 if (RaceStats[raceid][race_activecpid] != 0)
 {
RemoveActiveRaceCheckpoint(RaceStats[raceid][race_activecpid]);
RaceStats[raceid][race_activecpid] = 0;
 }
}

NextRaceCP(raceid,playerid)
{
	if(RacePlayerStats[playerid][race_player_status] == 1 && Race[raceid][race_type] == 5)
	{
		//new cpid=RacePlayerStats[playerid][race_player_cp];
		GetVehiclePos(RacePlayerStats[playerid][race_player_vehicle],
			RacePlayerVechicleStats[playerid][race_player_cX],
			RacePlayerVechicleStats[playerid][race_player_cY],
			RacePlayerVechicleStats[playerid][race_player_cZ]);
			
		GetVehicleZAngle(RacePlayerStats[playerid][race_player_vehicle],
			RacePlayerVechicleStats[playerid][race_player_angel]);
		
		GetVehicleVelocity(RacePlayerStats[playerid][race_player_vehicle],
			RacePlayerVechicleStats[playerid][race_player_spX],
			RacePlayerVechicleStats[playerid][race_player_spY],
			RacePlayerVechicleStats[playerid][race_player_spZ]);
	}

if (RacePlayerStats[playerid][race_player_cp] == RaceSize[raceid]-1) // if finish line
{
FinishRace(raceid,playerid);
return;
}
else if (RacePlayerStats[playerid][race_player_cp] == RaceSize[raceid]-2) // if next finish line
{
PlayerPlaySound(playerid,1058,GetRaceCPX(raceid,RacePlayerStats[playerid][race_player_cp]),GetRaceCPY(raceid,RacePlayerStats[playerid][race_player_cp]),GetRaceCPZ(raceid,RacePlayerStats[playerid][race_player_cp]));
RacePlayerStats[playerid][race_player_cp]++;
//oSetPlayerCheckpoint(playerid,GetRaceCPX(raceid,RacePlayerStats[playerid][race_player_cp]),GetRaceCPY(raceid,RacePlayerStats[playerid][race_player_cp]),GetRaceCPZ(raceid,RacePlayerStats[playerid][race_player_cp]),CPSize);
//oSetPlayerRaceCheckpoint(playerid,1,GetRaceCPX(raceid,RacePlayerStats[playerid][race_player_cp]),GetRaceCPY(raceid,RacePlayerStats[playerid][race_player_cp]),GetRaceCPZ(raceid,RacePlayerStats[playerid][race_player_cp]),GetRaceCPX(raceid,1+RacePlayerStats[playerid][race_player_cp]),GetRaceCPY(raceid,1+RacePlayerStats[playerid][race_player_cp]),GetRaceCPZ(raceid,1+RacePlayerStats[playerid][race_player_cp]),GetRaceCPSize(raceid));
if(Race[raceid][race_type] == 0 || Race[raceid][race_type] == 5)
{
oSetPlayerRaceCheckpoint(playerid,1,GetRaceCPX(raceid,RacePlayerStats[playerid][race_player_cp]),GetRaceCPY(raceid,RacePlayerStats[playerid][race_player_cp]),GetRaceCPZ(raceid,RacePlayerStats[playerid][race_player_cp]),GetRaceCPX(raceid,1+RacePlayerStats[playerid][race_player_cp]),GetRaceCPY(raceid,1+RacePlayerStats[playerid][race_player_cp]),GetRaceCPZ(raceid,1+RacePlayerStats[playerid][race_player_cp]),GetRaceCPSize(raceid));
}
if(Race[raceid][race_type] == 3)
{
oSetPlayerRaceCheckpoint(playerid,4,GetRaceCPX(raceid,RacePlayerStats[playerid][race_player_cp]),GetRaceCPY(raceid,RacePlayerStats[playerid][race_player_cp]),GetRaceCPZ(raceid,RacePlayerStats[playerid][race_player_cp]),GetRaceCPX(raceid,RacePlayerStats[playerid][race_player_cp]-1),GetRaceCPY(raceid,RacePlayerStats[playerid][race_player_cp]-1),GetRaceCPZ(raceid,RacePlayerStats[playerid][race_player_cp]-1),GetRaceCPSize(raceid));
}
if(Race[raceid][race_type] == 4)
{
// Для дерби они нахуй не нужны
}
}
else
{
PlayerPlaySound(playerid,1058,GetRaceCPX(raceid,RacePlayerStats[playerid][race_player_cp]),GetRaceCPY(raceid,RacePlayerStats[playerid][race_player_cp]),GetRaceCPZ(raceid,RacePlayerStats[playerid][race_player_cp]));
RacePlayerStats[playerid][race_player_cp]++;
//oSetPlayerCheckpoint(playerid,GetRaceCPX(raceid,RacePlayerStats[playerid][race_player_cp]),GetRaceCPY(raceid,RacePlayerStats[playerid][race_player_cp]),GetRaceCPZ(raceid,RacePlayerStats[playerid][race_player_cp]),CPSize);
if(Race[raceid][race_type] == 0)
{
oSetPlayerRaceCheckpoint(playerid,0,GetRaceCPX(raceid,RacePlayerStats[playerid][race_player_cp]),GetRaceCPY(raceid,RacePlayerStats[playerid][race_player_cp]),GetRaceCPZ(raceid,RacePlayerStats[playerid][race_player_cp]),GetRaceCPX(raceid,1+RacePlayerStats[playerid][race_player_cp]),GetRaceCPY(raceid,1+RacePlayerStats[playerid][race_player_cp]),GetRaceCPZ(raceid,1+RacePlayerStats[playerid][race_player_cp]),GetRaceCPSize(raceid));
}
if(Race[raceid][race_type] == 3)
{
oSetPlayerRaceCheckpoint(playerid,3,GetRaceCPX(raceid,RacePlayerStats[playerid][race_player_cp]),GetRaceCPY(raceid,RacePlayerStats[playerid][race_player_cp]),GetRaceCPZ(raceid,RacePlayerStats[playerid][race_player_cp]),GetRaceCPX(raceid,RacePlayerStats[playerid][race_player_cp]-1),GetRaceCPY(raceid,RacePlayerStats[playerid][race_player_cp]-1),GetRaceCPZ(raceid,RacePlayerStats[playerid][race_player_cp]-1),GetRaceCPSize(raceid));
}
if(Race[raceid][race_type] == 4)
{
// Для дерби они нахуй не нужны
}
		if(Race[raceid][race_type] == 5)
		{
		    new cpt=GetRaceCPType(raceid,RacePlayerStats[playerid][race_player_cp]);
		    new vehcps=GetRaceAllowedCar(raceid,RacePlayerStats[playerid][race_player_cp]);
		    if(vehcps > 0)
		    {
		        new Float:x,Float:y,Float:z,Float:a,seatid;
		        if(!IsPlayerInAnyVehicle(playerid))
                    PutPlayerInVehicle(playerid,RacePlayerStats[playerid][race_player_vehicle],0);
				if(IsPlayerInAnyVehicle(playerid))
			    {
			    	seatid=GetPlayerVehicleSeat(playerid);
				    if(seatid == 0)
       				{
	       				GetVehiclePos(GetPlayerVehicleID(playerid),x,y,z);
				    	GetVehicleZAngle(GetPlayerVehicleID(playerid),a);
				    	DestroyVehicle(GetPlayerVehicleID(playerid));
						RacePlayerStats[playerid][race_player_vehicle] = CreateVehicle(vehcps,x,y,z,a,-1,-1,1000);
			   			PutPlayerInVehicle(playerid,RacePlayerStats[playerid][race_player_vehicle],seatid);
       				}
			   	}
		    }
			oSetPlayerRaceCheckpoint(playerid, cpt, GetRaceCPX(raceid,RacePlayerStats[playerid][race_player_cp]),GetRaceCPY(raceid,RacePlayerStats[playerid][race_player_cp]),GetRaceCPZ(raceid,RacePlayerStats[playerid][race_player_cp]),  GetRaceCPX(raceid,RacePlayerStats[playerid][race_player_cp]+1),GetRaceCPY(raceid,RacePlayerStats[playerid][race_player_cp]+1),GetRaceCPZ(raceid,RacePlayerStats[playerid][race_player_cp]+1),GetRaceCPSize(raceid));
		}
}
}

StartRaceCountdown(raceid)
{
	RaceStats[raceid][race_timer]=0;
	if(RaceStats[raceid][race_activecpid] != 0)
	{
		RemoveActiveRaceCheckpoint(RaceStats[raceid][race_activecpid]);
		RaceStats[raceid][race_activecpid] = 0;
	}
	
	new string[100];
	for (new playerid=0; playerid<MAX_PLAYERS;playerid++)
	{
		if(!IsPlayerConnected(playerid)) { continue; }
		if(PlayerQuest[playerid] == GetRaceQuestID(raceid)) // if player is in this race
		{
            if(Race[raceid][race_type] != 4){
			if(!oIsPlayerInRaceCheckpoint(playerid,
			GetRaceCPX(raceid,0),GetRaceCPY(raceid,0),GetRaceCPZ(raceid,0),(GetRaceCPSize(raceid))))
			{
				LeaveRace(raceid,playerid);
				SendPlayerFormattedText(playerid,  lang_texts[10][44] , 0,COLOUR_RED);
			}
			}
		}
		if(GetPlayerRace(playerid) == INVALID_RACE_ID && PlayerQuest[playerid] != playerid + 500)
		{
			// Вызывает временное пропадание стартового гоночного чп ВОЗЛЕ которого стоит игрок
			oDisablePlayerRaceCheckpoint(playerid);
		}
	}
 
	if(RaceStats[raceid][race_racercount] < Race[raceid][race_minracers])
	{
		format(string, sizeof(string),  lang_texts[10][45] ,Race[raceid][race_name]);
		if(PlayerCount() > 0)
		{
			new logstring[256];
			format(logstring, sizeof (logstring), "Race: '%s' did not run.",Race[raceid][race_name]);
			WriteLog(logstring);
		}
		SendClientMessageToRegistered(COLOUR_RED, string);
		CleanupRace(raceid);
		return;
	}

	if(Race[raceid][race_type] != 4){
	format(string, sizeof(string),  lang_texts[10][46] ,Race[raceid][race_name]);
	SendClientMessageToRegistered(COLOUR_RACE, string);
	} else {
	format(string, sizeof(string),  lang_texts[10][67] ,Race[raceid][race_name]);
	SendClientMessageToRegistered(COLOUR_ORANGE, string);
	}
	new logstring[256];
	format(logstring, sizeof (logstring), "Race: %s starting.",Race[raceid][race_name]);
	WriteLog(logstring);
	RaceStats[raceid][race_state] = RACE_STATE_COUNTDOWN;

	if( Race[raceid][race_type] == RACE_TYPE_DERBY )
	{
		new Float: Angle;
		Angle = (360/RaceStats[raceid][race_racercount]);
		
		for (new playerid=0, step=0; playerid<MAX_PLAYERS;playerid++)
		{
			if(!IsPlayerConnected(playerid)) { continue; }
			if(PlayerQuest[playerid] == GetRaceQuestID(raceid)) // if player is in this race
			{
			
			    /*//DerbyVehicle
			    //DerbyCar[random(sizeof(DerbyCar))]
			    
			    new derbyvehicles[MAX_VEH_DERBY+1];
			    set(derbyvehicles,Race[raceid][race_derby_veh]);
				
				for(new i; i<MAX_VEH_DERBY;i++)
				{
    				if(i < strlen(derbyvehicle))
    				{
        				Race[raceid][race_derby_veh][i] = derbyvehicle[i];
    				}
    				else
    				{
        				Race[raceid][race_derby_veh][i] = 0;
    				}
				}*/

				new rand = random(strlen(Race[raceid][race_derby_veh]));
			
			    ResetPlayerWeapons(playerid);
				RacePlayerStats[playerid][race_player_vehicle] =
					CreateVehicle( Race[raceid][race_derby_veh][ rand ],
					GetRaceCPX(raceid,0) + Get_dx(Angle*step, 50.00),
					GetRaceCPY(raceid,0) + Get_dy(Angle*step, 50.00),
					GetRaceCPZ(raceid,0),
					Angle*step - 180.00, -1, -1, 3600);
					
				new
    				Float:VHealth,
    				VeheStr[80];
				SetVehicleHealth(RacePlayerStats[playerid][race_player_vehicle], 650);
				GetVehicleHealth(RacePlayerStats[playerid][race_player_vehicle],VHealth);
				format(VeheStr,sizeof(VeheStr),"%d hp",floatround(VHealth,floatround_round));

				RacePlayerStats[playerid][race_player_3d] = Create3DTextLabel(VeheStr, COLOUR_YELLOW, 7.77, 7.77, 7.77, 100.0, 0, 1);
				//RacePlayerStats[playerid][race_player_3d] = CreatePlayer3DTextLabel(playerid, VeheStr, COLOUR_YELLOW, 7.77, 7.77, 7.77, 100.0, playerid, RacePlayerStats[playerid][race_player_vehicle], 1);
				
				TogglePlayerControllable(playerid, 0);
				SetCameraBehindPlayer(playerid);
				step++;
				oSetPlayerVirtualWorld(playerid,100); // Виртуальный мир
				SetPlayerInterior(playerid, 0);
				SetVehicleVirtualWorld(RacePlayerStats[playerid][race_player_vehicle],100);
    			new RandomDerby = random( RaceSize[raceid] );
				SetVehiclePos(RacePlayerStats[playerid][race_player_vehicle],RaceCheckpoints[raceid][RandomDerby][Coord_X],RaceCheckpoints[raceid][RandomDerby][Coord_Y],RaceCheckpoints[raceid][RandomDerby][Coord_Z]+2);
                PutPlayerInVehicle(playerid, RacePlayerStats[playerid][race_player_vehicle], 0);
                
                Attach3DTextLabelToVehicle(RacePlayerStats[playerid][race_player_3d], RacePlayerStats[playerid][race_player_vehicle], 0.0, 0.0, 2.0);
                
				if(Race[raceid][race_interior] != 0)
				{
					SetPlayerInterior(playerid,Race[raceid][race_interior]);
					LinkVehicleToInterior(RacePlayerStats[playerid][race_player_vehicle], Race[raceid][race_interior]);
				}
			}
		}
	}
	else
	{
		for (new playerid=0; playerid<MAX_PLAYERS;playerid++)
		{
			if (!IsPlayerConnected(playerid)) { continue; }
			if(PlayerQuest[playerid] == GetRaceQuestID(raceid)) // if player is in this race
			{
				if(Race[raceid][race_type] == 5)
				{
				    RacePlayerStats[playerid][race_player_status] = 1;
		        	new vehcps=GetRaceAllowedCar(raceid,RacePlayerStats[playerid][race_player_cp]);
			    	if(vehcps > 0)
			    	{
			        	new Float:x,Float:y,Float:z,Float:a,seatid;
						if(IsPlayerInAnyVehicle(playerid))
				    	{
				    		seatid=GetPlayerVehicleSeat(playerid);
					    	if(seatid == 0)
	       					{
  								GetVehiclePos(GetPlayerVehicleID(playerid),x,y,z);
					    		GetVehicleZAngle(GetPlayerVehicleID(playerid),a);
	       					    SetVehicleToRespawn(GetPlayerVehicleID(playerid));
	       					    RemovePlayerFromVehicle(playerid);
								RacePlayerStats[playerid][race_player_vehicle] = CreateVehicle(vehcps,x,y,z,a,-1,-1,1000);
				   				PutPlayerInVehicle(playerid,RacePlayerStats[playerid][race_player_vehicle],seatid);
				   				//RacePlayerStats[playerid][race_player_vehicle] = GetVehicleModel(GetPlayerVehicleID(playerid));
	       					}
				   		}
				   		else
				   		{
				   	    	GetPlayerPos(playerid,x,y,z);
				   	    	GetPlayerFacingAngle(playerid,a);
				   	    	RacePlayerStats[playerid][race_player_vehicle] = CreateVehicle(vehcps,x,y,z,a,-1,-1,1000);
				   			PutPlayerInVehicle(playerid,RacePlayerStats[playerid][race_player_vehicle],seatid);
				   			//RacePlayerStats[playerid][race_player_vehicle] = GetVehicleModel(GetPlayerVehicleID(playerid));
				   		}
			    	}
		    	}
				if(Race[raceid][race_startheading] != 0.0)
				{
					SetVehicleZAngle(GetPlayerVehicleID(playerid), Race[raceid][race_startheading]);
				}
				TogglePlayerControllable(playerid, 0);
				SetCameraBehindPlayer(playerid);
			}
		}
	}
}

EndRace(raceid)
{
 for (new playerid=0; playerid<MAX_PLAYERS;playerid++)
 {
  if (!IsPlayerConnected(playerid)) continue;
     if (PlayerQuest[playerid] == GetRaceQuestID(raceid)) // if player is in this race
      {
       GameTextForPlayer(playerid, "~r~Race Failed!",5000,6);
       SendPlayerFormattedText(playerid,  lang_texts[10][47] , 0,COLOUR_RED);
          new logstring[256];
    format(logstring, sizeof (logstring), "player: %d:  %s: his race ended. He failed to quilify.",playerid,oGetPlayerName(playerid));
       WriteLog(logstring);
    //GivePlayerXP(playerid, Race[raceid][race_xpprize]/100 ,1); // если гонка закончилась))
 			new Lvl = GetPlayerScore(playerid);
			if(Lvl < 5) GivePlayerXP(playerid, 75 ,1);
			else if(Lvl > 4 && Lvl < 10) GivePlayerXP(playerid, 75 ,1);
			else if(Lvl > 9 && Lvl < 15) GivePlayerXP(playerid, 80 ,1);
			else if(Lvl > 14 && Lvl < 20) GivePlayerXP(playerid, 80 ,1);
			else if(Lvl > 19 && Lvl < 25) GivePlayerXP(playerid, 90 ,1);
			else if(Lvl > 24 && Lvl < 30) GivePlayerXP(playerid, 90 ,1);
			else if(Lvl > 29 && Lvl < 35) GivePlayerXP(playerid, 100 ,1);
			else if(Lvl > 34 && Lvl < 40) GivePlayerXP(playerid, 100 ,1);
  }
   }
 CleanupRace(raceid);
}


FinishRace(raceid,playerid)
{
        RaceStats[raceid][race_position]++;
  new string[MAX_STRING];
        RacePlayerStats[playerid][race_player_time] = RaceStats[raceid][race_timer];
        
        if (RaceStats[raceid][race_position] == 1)
        {
            format(string, sizeof(string),  lang_texts[10][48] ,Race[raceid][race_name],FormatPosition(RaceStats[raceid][race_position]),ConvertSeconds(RacePlayerStats[playerid][race_player_time]));
   SendClientMessage(playerid,COLOUR_GREEN, string);

            format(string, sizeof(string),  lang_texts[10][49] ,oGetPlayerName(playerid),Race[raceid][race_name],ConvertSeconds(RacePlayerStats[playerid][race_player_time]));
            SendClientMessageToRegistered(COLOUR_RACE, string);
            new logstring[256];
   format(logstring, sizeof (logstring), "player: %d:  %s: has won race '%s'! Time: %s",playerid,oGetPlayerName(playerid),Race[raceid][race_name],ConvertSeconds(RacePlayerStats[playerid][race_player_time]));
      WriteLog(logstring);
   oGivePlayerMoney(playerid,Race[raceid][race_cashprize],1);
            //GivePlayerXP(playerid,Race[raceid][race_xpprize] + (Race[raceid][race_xpbonus] * RaceStats[raceid][race_racercount]),1); // 1st
            if(Race[raceid][race_type] != 5){
			new Lvl = GetPlayerScore(playerid);
			if(Lvl < 5) GivePlayerXP(playerid, 500*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 4 && Lvl < 10) GivePlayerXP(playerid, 1000*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 9 && Lvl < 15) GivePlayerXP(playerid, 2000*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 14 && Lvl < 20) GivePlayerXP(playerid, 3000*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 19 && Lvl < 25) GivePlayerXP(playerid, 4000*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 24 && Lvl < 30) GivePlayerXP(playerid, 5000*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 29 && Lvl < 35) GivePlayerXP(playerid, 6000*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 34 && Lvl < 40) GivePlayerXP(playerid, 7000*RaceStats[raceid][race_racercount],1);
			GivePlayerRaceXP(playerid,3);
			} else {
			new Lvl = GetPlayerScore(playerid);
			if(Lvl < 5) GivePlayerXP(playerid, 3500*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 4 && Lvl < 10) GivePlayerXP(playerid, 4000*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 9 && Lvl < 15) GivePlayerXP(playerid, 5000*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 14 && Lvl < 20) GivePlayerXP(playerid, 7500*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 19 && Lvl < 25) GivePlayerXP(playerid, 9900*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 24 && Lvl < 30) GivePlayerXP(playerid, 11000*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 29 && Lvl < 35) GivePlayerXP(playerid, 15000*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 34 && Lvl < 40) GivePlayerXP(playerid, 18000*RaceStats[raceid][race_racercount],1);
			GivePlayerRaceXP(playerid,9);
			}

     }
        else if (RaceStats[raceid][race_position] == 2)
        {
         format(string, sizeof(string),  lang_texts[10][50] ,Race[raceid][race_name],FormatPosition(RaceStats[raceid][race_position]),ConvertSeconds(RacePlayerStats[playerid][race_player_time]));
   SendClientMessage(playerid,COLOUR_GREEN, string);

   format(string, sizeof(string),  lang_texts[10][51] ,oGetPlayerName(playerid),FormatPosition(RaceStats[raceid][race_position]),Race[raceid][race_name],ConvertSeconds(RacePlayerStats[playerid][race_player_time]));
            SendClientMessageToRegistered(COLOUR_RACE, string);
			GivePlayerRaceXP(playerid,2);
            if (RaceStats[raceid][race_racercount] > 2) // if total racers was >= 4
            {
             oGivePlayerMoney(playerid,(Race[raceid][race_cashprize]/2),1);
             //GivePlayerXP(playerid,(Race[raceid][race_xpprize]/2) + (Race[raceid][race_xpbonus] * RaceStats[raceid][race_racercount]),1); // 2nd
            if(Race[raceid][race_type] != 5){
			new Lvl = GetPlayerScore(playerid);
			if(Lvl < 5) GivePlayerXP(playerid, 500/2,1);
			else if(Lvl > 4 && Lvl < 10) GivePlayerXP(playerid, 1000/2*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 9 && Lvl < 15) GivePlayerXP(playerid, 2000/2*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 14 && Lvl < 20) GivePlayerXP(playerid, 3000/2*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 19 && Lvl < 25) GivePlayerXP(playerid, 4000/2*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 24 && Lvl < 30) GivePlayerXP(playerid, 5000/2*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 29 && Lvl < 35) GivePlayerXP(playerid, 6000/2*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 34 && Lvl < 40) GivePlayerXP(playerid, 7000/2*RaceStats[raceid][race_racercount],1);
			} else {
			new Lvl = GetPlayerScore(playerid);
			if(Lvl < 5) GivePlayerXP(playerid, 5000/2,1);
			else if(Lvl > 4 && Lvl < 10) GivePlayerXP(playerid, 2000*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 9 && Lvl < 15) GivePlayerXP(playerid, 4000*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 14 && Lvl < 20) GivePlayerXP(playerid, 5000*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 19 && Lvl < 25) GivePlayerXP(playerid, 6000*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 24 && Lvl < 30) GivePlayerXP(playerid, 8000*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 29 && Lvl < 35) GivePlayerXP(playerid, 10000*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 34 && Lvl < 40) GivePlayerXP(playerid, 12000*RaceStats[raceid][race_racercount],1);
			GivePlayerRaceXP(playerid,6);
			}

   }
   else
   {
       //GivePlayerXP(playerid,Race[raceid][race_xpbonus] * RaceStats[raceid][race_racercount],1);
            if(Race[raceid][race_type] != 5){
			new Lvl = GetPlayerScore(playerid);
			if(Lvl < 5) GivePlayerXP(playerid, 500/2,1);
			else if(Lvl > 4 && Lvl < 10) GivePlayerXP(playerid, 1000/2*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 9 && Lvl < 15) GivePlayerXP(playerid, 2000/2*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 14 && Lvl < 20) GivePlayerXP(playerid, 3000/2*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 19 && Lvl < 25) GivePlayerXP(playerid, 4000/2*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 24 && Lvl < 30) GivePlayerXP(playerid, 5000/2*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 29 && Lvl < 35) GivePlayerXP(playerid, 6000/2*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 34 && Lvl < 40) GivePlayerXP(playerid, 7000/2*RaceStats[raceid][race_racercount],1);
			} else {
			new Lvl = GetPlayerScore(playerid);
			if(Lvl < 5) GivePlayerXP(playerid, 5000/2,1);
			else if(Lvl > 4 && Lvl < 10) GivePlayerXP(playerid, 2000*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 9 && Lvl < 15) GivePlayerXP(playerid, 4000*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 14 && Lvl < 20) GivePlayerXP(playerid, 5000*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 19 && Lvl < 25) GivePlayerXP(playerid, 6000*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 24 && Lvl < 30) GivePlayerXP(playerid, 8000*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 29 && Lvl < 35) GivePlayerXP(playerid, 10000*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 34 && Lvl < 40) GivePlayerXP(playerid, 12000*RaceStats[raceid][race_racercount],1);
			GivePlayerRaceXP(playerid,6);
			}
   }
  }
        else if ((RaceStats[raceid][race_position] == 3) && (RaceStats[raceid][race_racercount] > 3))
        {
            format(string, sizeof(string),  lang_texts[10][52] ,Race[raceid][race_name],FormatPosition(RaceStats[raceid][race_position]),ConvertSeconds(RacePlayerStats[playerid][race_player_time]));
   SendClientMessage(playerid,COLOUR_GREEN, string);
   
   format(string, sizeof(string),  lang_texts[10][53] ,oGetPlayerName(playerid),FormatPosition(RaceStats[raceid][race_position]),Race[raceid][race_name],ConvertSeconds(RacePlayerStats[playerid][race_player_time]));
            SendClientMessageToRegistered(COLOUR_RACE, string);
			GivePlayerRaceXP(playerid,1);
            if (RaceStats[raceid][race_racercount] > 3) // if total racers was >= 6
            {
          oGivePlayerMoney(playerid,(Race[raceid][race_cashprize]/4),1);
          //GivePlayerXP(playerid,(Race[raceid][race_xpprize]/4) + (Race[raceid][race_xpbonus] * RaceStats[raceid][race_racercount]),1); // 3rd
          if(Race[raceid][race_type] != 5){
			new Lvl = GetPlayerScore(playerid);
			if(Lvl < 5) GivePlayerXP(playerid, 500/4,1);
			else if(Lvl > 4 && Lvl < 10) GivePlayerXP(playerid, 1000/4*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 9 && Lvl < 15) GivePlayerXP(playerid, 2000/4*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 14 && Lvl < 20) GivePlayerXP(playerid, 3000/4*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 19 && Lvl < 25) GivePlayerXP(playerid, 4000/4*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 24 && Lvl < 30) GivePlayerXP(playerid, 5000/4*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 29 && Lvl < 35) GivePlayerXP(playerid, 6000/4*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 34 && Lvl < 40) GivePlayerXP(playerid, 7000/4*RaceStats[raceid][race_racercount],1);
			} else {
   			new Lvl = GetPlayerScore(playerid);
			if(Lvl < 5) GivePlayerXP(playerid, 3000,1);
			else if(Lvl > 4 && Lvl < 10) GivePlayerXP(playerid, 4000*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 9 && Lvl < 15) GivePlayerXP(playerid, 4500*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 14 && Lvl < 20) GivePlayerXP(playerid, 5500*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 19 && Lvl < 25) GivePlayerXP(playerid, 12000/2*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 24 && Lvl < 30) GivePlayerXP(playerid, 20000/2*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 29 && Lvl < 35) GivePlayerXP(playerid, 26000/2*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 34 && Lvl < 40) GivePlayerXP(playerid, 35000/2*RaceStats[raceid][race_racercount],1);
			GivePlayerRaceXP(playerid,3);
			}
   }
   else
   {
       //GivePlayerXP(playerid,Race[raceid][race_xpbonus] * RaceStats[raceid][race_racercount],1); // no price
	   //GivePlayerXP(playerid,Race[raceid][race_xpbonus] * RaceStats[raceid][race_racercount],1); // no price
	   if(Race[raceid][race_type] != 5){
			new Lvl = GetPlayerScore(playerid);
			if(Lvl < 5) GivePlayerXP(playerid, 500/4,1);
			else if(Lvl > 4 && Lvl < 10) GivePlayerXP(playerid, 1000/4*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 9 && Lvl < 15) GivePlayerXP(playerid, 2000/4*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 14 && Lvl < 20) GivePlayerXP(playerid, 3000/4*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 19 && Lvl < 25) GivePlayerXP(playerid, 4000/4*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 24 && Lvl < 30) GivePlayerXP(playerid, 5000/4*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 29 && Lvl < 35) GivePlayerXP(playerid, 6000/4*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 34 && Lvl < 40) GivePlayerXP(playerid, 7000/4*RaceStats[raceid][race_racercount],1);
			} else {
   			new Lvl = GetPlayerScore(playerid);
			if(Lvl < 5) GivePlayerXP(playerid, 3000,1);
			else if(Lvl > 4 && Lvl < 10) GivePlayerXP(playerid, 4000*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 9 && Lvl < 15) GivePlayerXP(playerid, 4500*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 14 && Lvl < 20) GivePlayerXP(playerid, 5500*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 19 && Lvl < 25) GivePlayerXP(playerid, 12000/2*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 24 && Lvl < 30) GivePlayerXP(playerid, 20000/2*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 29 && Lvl < 35) GivePlayerXP(playerid, 26000/2*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 34 && Lvl < 40) GivePlayerXP(playerid, 35000/2*RaceStats[raceid][race_racercount],1);
			GivePlayerRaceXP(playerid,3);
			}
   }
  }
        else
        {
         format(string, sizeof(string),  lang_texts[10][54] ,Race[raceid][race_name],FormatPosition(RaceStats[raceid][race_position]),ConvertSeconds(RacePlayerStats[playerid][race_player_time]));
   SendClientMessage(playerid,COLOUR_GREEN, string);
   //GivePlayerXP(playerid,Race[raceid][race_xpbonus] * RaceStats[raceid][race_racercount],1);
   			if(Race[raceid][race_type] != 5){
			new Lvl = GetPlayerScore(playerid);
			if(Lvl < 5) GivePlayerXP(playerid, 500/4,1);
			else if(Lvl > 4 && Lvl < 10) GivePlayerXP(playerid, 1000/4*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 9 && Lvl < 15) GivePlayerXP(playerid, 2000/4*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 14 && Lvl < 20) GivePlayerXP(playerid, 3000/4*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 19 && Lvl < 25) GivePlayerXP(playerid, 4000/4*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 24 && Lvl < 30) GivePlayerXP(playerid, 5000/4*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 29 && Lvl < 35) GivePlayerXP(playerid, 6000/4*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 34 && Lvl < 40) GivePlayerXP(playerid, 7000/4*RaceStats[raceid][race_racercount],1);
			} else {
   			new Lvl = GetPlayerScore(playerid);
			if(Lvl < 5) GivePlayerXP(playerid, 3000,1);
			else if(Lvl > 4 && Lvl < 10) GivePlayerXP(playerid, 4000*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 9 && Lvl < 15) GivePlayerXP(playerid, 4500*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 14 && Lvl < 20) GivePlayerXP(playerid, 5500*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 19 && Lvl < 25) GivePlayerXP(playerid, 12000/2*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 24 && Lvl < 30) GivePlayerXP(playerid, 20000/2*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 29 && Lvl < 35) GivePlayerXP(playerid, 26000/2*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 34 && Lvl < 40) GivePlayerXP(playerid, 35000/2*RaceStats[raceid][race_racercount],1);
			GivePlayerRaceXP(playerid,3);
			}
  }
  
  string = FormatPosition(RaceStats[raceid][race_position]);
  GameTextForPlayer(playerid,string,5000,6);
  PlayerPlaySound(playerid,1057,GetRaceCPX(raceid,RacePlayerStats[playerid][race_player_cp]),GetRaceCPY(raceid,RacePlayerStats[playerid][race_player_cp]),GetRaceCPZ(raceid,RacePlayerStats[playerid][race_player_cp]));

  if ((RaceStats[raceid][race_timer] < BestScore[raceid][race_score_time]) || (BestScore[raceid][race_score_time] == 0))
  {
	new playervehiclemodel = GetVehicleModel(GetPlayerVehicleID(playerid));
   format(string, sizeof(string),  lang_texts[10][55] ,oGetPlayerName(playerid),playerid,GetVehicleName(playervehiclemodel),Race[raceid][race_name],raceid,ConvertSeconds(RacePlayerStats[playerid][race_player_time]));
   //printf("1 old best %d",BestScore[raceid][race_score_time]);
   //SendClientMessageToRegistered(COLOUR_RACE, string);
	SendClientMessageToAll(COLOUR_RACE, string);
	
	if(BestScore[raceid][race_score_time] > 0)
   {
   //printf("2 old best %d",BestScore[raceid][race_score_time]);
   format(string, sizeof(string),  lang_texts[10][63] ,BestScore[raceid][race_score_player],BestScore[raceid][race_score_vehicle],ConvertSeconds(BestScore[raceid][race_score_time]));
   SendClientMessageToAll(COLOUR_RACE, string);
   }
			
            new logstring[256];
   format(logstring, sizeof (logstring), "player: %d:  %s: has set a new record for race '%s'! Time: %s. Old record: %s.",playerid,oGetPlayerName(playerid),Race[raceid][race_name],ConvertSeconds(RacePlayerStats[playerid][race_player_time]),ConvertSeconds(BestScore[raceid][race_score_time]));
      WriteLog(logstring);
   oGivePlayerMoney(playerid,(Race[raceid][race_cashprize]*3),1);
         //GivePlayerXP(playerid,(Race[raceid][race_xpprize]*3),1);
         
			new Lvl = GetPlayerScore(playerid);
			if(Lvl < 5) GivePlayerXP(playerid, 3500*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 4 && Lvl < 10) GivePlayerXP(playerid, 4000*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 9 && Lvl < 15) GivePlayerXP(playerid, 5000*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 14 && Lvl < 20) GivePlayerXP(playerid, 7500*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 19 && Lvl < 25) GivePlayerXP(playerid, 9900*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 24 && Lvl < 30) GivePlayerXP(playerid, 11000*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 29 && Lvl < 35) GivePlayerXP(playerid, 15000*RaceStats[raceid][race_racercount],1);
			else if(Lvl > 34 && Lvl < 40) GivePlayerXP(playerid, 18000*RaceStats[raceid][race_racercount],1);
			GivePlayerRaceXP(playerid,9);

	BestScore[raceid][race_score_time] = RaceStats[raceid][race_timer];
   set(BestScore[raceid][race_score_player],oGetPlayerName(playerid));
   set(BestScore[raceid][race_score_vehicle],GetVehicleName(playervehiclemodel));
   RaceSaveRecordDB(raceid);
  }

  LeaveRace(raceid,playerid);
}

RacePlayerDisconnect(playerid)
{
 		new raceid = GetPlayerRace(playerid);
		if (raceid == INVALID_RACE_ID) return;

 		LeaveRace(raceid,playerid);
 
 	    if(PlayerQuest[playerid] != 0 && RaceStats[GetPlayerRace(playerid)][race_state] != RACE_STATE_LINEUP)
		{
			if(RacePlayerStats[playerid][race_player_status] == 1)
			{
			    RacePlayerStats[playerid][race_player_status] = 0;
			    RacePlayerStats[playerid][race_player_cp] = 0;
			}
		}
}

StartRaceLineup(raceid)
{
  RaceStats[raceid][race_state] = RACE_STATE_LINEUP;
	new string1[MAX_STRING];
	new string2[MAX_STRING];
	new string3[MAX_STRING];
 	new string4[MAX_STRING];
	 if(Race[raceid][race_type] == 3)
	 {
	 format(string1, sizeof(string1),  lang_texts[10][62] ,Race[raceid][race_name],raceid,Race[raceid][race_lineupdelay],GetRaceCPZoneName(raceid,0));
	 format(string3, sizeof(string3), "~n~ ~n~ ~b~flight ~w~%s ~n~~b~...after~w~ %d~b~ sec." ,Race[raceid][race_name],Race[raceid][race_lineupdelay]);
	 }
	 else if(Race[raceid][race_type] == 4)
	 {
	 format(string1, sizeof(string1),  lang_texts[10][64] ,Race[raceid][race_name],raceid,Race[raceid][race_lineupdelay]);
	 format(string3, sizeof(string3), "~n~ ~n~ ~y~derby ~w~%s ~n~~y~...after~w~ %d~y~ sec." ,Race[raceid][race_name],Race[raceid][race_lineupdelay]);
	 }
	 else if(Race[raceid][race_type] == 5)
	 {
	 format(string1, sizeof(string1),  lang_texts[10][68] ,Race[raceid][race_name],raceid,Race[raceid][race_lineupdelay],GetRaceCPZoneName(raceid,0));
	 //format(string3, sizeof(string3), "~n~ ~n~ ~g~race ~w~%s ~n~~g~...after~w~ %d~g~ sec." ,Race[raceid][race_name],Race[raceid][race_lineupdelay]);
	 format(string3, sizeof(string3), "~n~ ~n~ ~p~multi race ~p~~w~%s ~n~~p~...after~w~ %d~p~ sec." ,Race[raceid][race_name],Race[raceid][race_lineupdelay]);
	 }
	 else
	 {
	 format(string1, sizeof(string1),  lang_texts[10][56] ,Race[raceid][race_name],raceid,Race[raceid][race_lineupdelay],GetRaceCPZoneName(raceid,0));
	 format(string3, sizeof(string3), "~n~ ~n~ ~g~race ~w~%s ~n~~g~...after~w~ %d~g~ sec." ,Race[raceid][race_name],Race[raceid][race_lineupdelay]);
	 }
	 GameTextForAll(string3, 3999, 1);
	  if (Race[raceid][race_minracers] > 1)
  {
   format(string2, sizeof(string2),  lang_texts[10][57] ,raceid);
  }
  else
  {
   format(string2, sizeof(string2),  lang_texts[10][58] ,raceid);
  }
  format(string4, sizeof(string4), " Прошлый рекорд гонки был установлен игроком %s: %s [%s].",BestScore[raceid][race_score_player],ConvertSeconds(BestScore[raceid][race_score_time]), BestScore[raceid][race_score_vehicle]);
  for (new playerid=0; playerid<MAX_PLAYERS;playerid++)
  {
   if (!IsPlayerConnected(playerid)) continue;
   SendClientMessage(playerid,GetRaceColourForPlayer(playerid,raceid), string1);
   SendClientMessage(playerid,GetRaceColourForPlayer(playerid,raceid), string2);
	if(BestScore[raceid][race_score_time]>0) SendPlayerFormattedText(playerid, string4, 0,GetRaceColourForPlayer(playerid,raceid));
      if (PlayerQuest[playerid] == 0) // if player not on a quest
      {
        //oSetPlayerCheckpoint(playerid,GetRaceCPX(raceid,0),GetRaceCPY(raceid,0),GetRaceCPZ(raceid,0),12);
		oSetPlayerRaceCheckpoint(playerid,2,GetRaceCPX(raceid,0),GetRaceCPY(raceid,0),GetRaceCPZ(raceid,0),GetRaceCPX(raceid,1),GetRaceCPY(raceid,1),GetRaceCPZ(raceid,1),(GetRaceCPSize(raceid)));
  }
  }
  RaceStats[raceid][race_activecpid] = AddActiveRaceCheckpoint(GetRaceCPX(raceid,0),GetRaceCPY(raceid,0),GetRaceCPZ(raceid,0),10000,(GetRaceCPSize(raceid)));
}

//---------------------------------------------------------------------
/*
Float:GetRaceCPX(raceid,cpid)
{
 return RaceCheckpoints[raceid][cpid][Coord_X];
}
Float:GetRaceCPY(raceid,cpid)
{
 return RaceCheckpoints[raceid][cpid][Coord_Y];
}
Float:GetRaceCPZ(raceid,cpid)
{
 return RaceCheckpoints[raceid][cpid][Coord_Z];
}
*/
//--------------------------------------------------------------------------

GetRaceCPZoneName(raceid,cpid)
{
 new zone[MAX_NAME];
 zone = GetXYZZoneName(GetRaceCPX(raceid,cpid),GetRaceCPY(raceid,cpid),GetRaceCPZ(raceid,cpid));
 return zone;
}

public race_OnPlayerEnterRaceCP(playerid)
{

 for (new raceid=1; raceid<=RacesCount;raceid++) //  for each race
 {
     if (RaceStats[raceid][race_state] == RACE_STATE_DISABLED) break;
  
     if (RaceStats[raceid][race_state] == RACE_STATE_LINEUP)
  {
      if (PlayerQuest[playerid] == 0) // if player not on a quest
      {
      // if player at startline
    //if (oIsPlayerInCheckpoint(playerid,GetRaceCPX(raceid,0),GetRaceCPY(raceid,0),GetRaceCPZ(raceid,0),(CPSize*3)))
	 if (oIsPlayerInRaceCheckpoint(playerid,GetRaceCPX(raceid,0),GetRaceCPY(raceid,0),GetRaceCPZ(raceid,0),(GetRaceCPSize(raceid))))
    {
    	if(Race[raceid][race_type] == 5 && !IsPlayerInAnyVehicle(playerid)) return;
        if (!IsPlayerInRace(playerid,raceid))
        {
      JoinRace(raceid,playerid);
     }
     else
        {
            //new playervehiclemodel = GetSpawnVehicleModel(GetPlayerVehicleID(playerid)-1);
			new playervehiclemodel = GetVehicleModel(GetPlayerVehicleID(playerid));
			
         if ((IsVehicleAllowedInRace(raceid,playervehiclemodel) == 0) && Race[raceid][race_type] != 5)
      {
       SendClientMessage(playerid,COLOUR_RED,  lang_texts[10][59] );
       SendPlayerAllowedRaceVehicles(playerid,raceid);
      }
      else if ((IsVehicleAllowedInRace(raceid,playervehiclemodel) == 0) && Race[raceid][race_type] == 5)
	{
		SendClientMessage(playerid,COLOUR_RED, "ВНИМАНИЕ! Этот транспорт не поддерживается в этой гонке." );
		SendPlayerAllowedRaceVehicles(playerid,raceid);
	}
      else
      {
       SendClientMessage(playerid,COLOUR_RACE,  lang_texts[10][60] );
      }
        }
    }
   }
  }
  else if (RaceStats[raceid][race_state] == RACE_STATE_RACING)
  {
   if (PlayerQuest[playerid] == GetRaceQuestID(raceid)) // if player is in this race
      {
       //if (oIsPlayerInCheckpoint(playerid,GetRaceCPX(raceid,RacePlayerStats[playerid][race_player_cp]),GetRaceCPY(raceid,RacePlayerStats[playerid][race_player_cp]),GetRaceCPZ(raceid,RacePlayerStats[playerid][race_player_cp]),CPSize*3))
	   if (oIsPlayerInRaceCheckpoint(playerid,GetRaceCPX(raceid,RacePlayerStats[playerid][race_player_cp]),GetRaceCPY(raceid,RacePlayerStats[playerid][race_player_cp]),GetRaceCPZ(raceid,RacePlayerStats[playerid][race_player_cp]),(GetRaceCPSize(raceid))))
       { 
     //new playervehiclemodel = GetSpawnVehicleModel(GetPlayerVehicleID(playerid)-1);
     new playervehiclemodel = GetVehicleModel(GetPlayerVehicleID(playerid));
	 
     if (IsVehicleAllowedInRace(raceid,playervehiclemodel) == 0)
     {
      SendClientMessage(playerid,COLOUR_RED,  lang_texts[10][61] );
      SendPlayerAllowedRaceVehicles(playerid,raceid);
      continue;

     }
	  
                    NextRaceCP(raceid,playerid);
    }
      }
  }
 }
}

IsVehicleAllowedInRace(raceid,vehiclemodel)
{
    if (Race[raceid][race_vehicles][0] == 0) return 1;
    new vehicleallowed;
    
    for (new i=0;i<strlen(Race[raceid][race_vehicles]);i++)
 {
    if (vehiclemodel == Race[raceid][race_vehicles][i])
  {
    vehicleallowed = 1;
    break;
   }
 }
 return vehicleallowed;
}

IsPlayerInAnyRace(playerid)
{
 new raceid = GetPlayerRace(playerid);
 if (raceid == INVALID_RACE_ID) return 0;
 if (RaceStats[raceid][race_state] == RACE_STATE_LINEUP) return 0;
 return 1;
}

stock GetInfoRaceLevel(playerid,level)
{
	new string[128];
 	for (new i=0;i<MAX_RACES;i++)
 	{
 	    if(level == Race[i][race_minlevel])
 	    {
   			format(string, sizeof(string), " Доступна новая гонка: %s (%d)" ,Race[i][race_name],i);
			SendClientMessage(playerid, COLOUR_MISC, string);
 	    }
 	}
 	return 1;
 }



forward antiafkderby(playerid);
public antiafkderby(playerid){
 new raceid = GetPlayerRace(playerid);
   				if(PlayerQuest[playerid] == GetRaceQuestID(raceid))
				{
					if (RaceStats[raceid][race_state] == RACE_STATE_RACING)
					{
	   	    			if(Race[raceid][race_type] == 4)
	   	    			{
	   	    			    SendClientMessage(playerid, COLOUR_RED,"[Derby]: Вы были исключены из дерби - АФК");
	   	        			WinDerby(raceid,playerid);
	   	        			LeaveRace(raceid,playerid);
	   	    			}
	   				}
				}
return 1;
}

forward Race_OnPlayerStateChange(playerid, newstate, oldstate);
public Race_OnPlayerStateChange(playerid, newstate, oldstate)
{
if(PlayerQuest[playerid] != 0 && newstate == PLAYER_STATE_DRIVER && RaceStats[GetPlayerRace(playerid)][race_state] != RACE_STATE_LINEUP && Race[GetPlayerRace(playerid)][race_type] == 5)
{
	if(RacePlayerStats[playerid][race_player_status] == 1)
	{
	    PutPlayerInVehicle(playerid,RacePlayerStats[playerid][race_player_vehicle],0);
	}
}

if(PlayerQuest[playerid] != 0 && oldstate != PLAYER_STATE_DRIVER && newstate == PLAYER_STATE_DRIVER && RaceStats[GetPlayerRace(playerid)][race_state] != RACE_STATE_LINEUP && RacePlayerStats[playerid][race_player_vehicle] != GetPlayerVehicleID(playerid))
{
	new i=GetPlayerVehicleID(playerid);
	RacePlayerStats[playerid][race_player_status] = 1;
	RacePlayerStats[playerid][race_player_vehicle] = i;
}
return 1;
}

/*
enum RaceVechicleInfo{
Float: race_player_spX,
Float: race_player_spY,
Float: race_player_spZ,
Float: race_player_cX,
Float: race_player_cY,
Float: race_player_cZ,
Float: race_player_angel
//Float: race_player_rX
//Float: race_player_rY
//Float: race_player_rZ
}
new RacePlayerVechicleStats[MAX_PLAYERS][RaceVechicleInfo];
*/

forward player_race_spawn(playerid);
public player_race_spawn(playerid)
{
    new i=RacePlayerStats[playerid][race_player_vehicle];
    TogglePlayerSpectating(playerid, 0);
    //new cpid=RacePlayerStats[playerid][race_player_cp];
    
	SetVehiclePos(i,
		RacePlayerVechicleStats[playerid][race_player_cX],
		RacePlayerVechicleStats[playerid][race_player_cY],
		RacePlayerVechicleStats[playerid][race_player_cZ]);
	
	PutPlayerInVehicle(playerid,i,0);
	
	SetVehicleZAngle(i,RacePlayerVechicleStats[playerid][race_player_angel]);
	
	SetVehicleVelocity(i,
		RacePlayerVechicleStats[playerid][race_player_spX],
		RacePlayerVechicleStats[playerid][race_player_spY],
		RacePlayerVechicleStats[playerid][race_player_spZ]);
	
	SetPlayerInterior(playerid,0);
	SetCameraBehindPlayer(playerid);
	TogglePlayerControllable(playerid, 1);
	GameTextForPlayer(playerid, "~g~GO!",1000,4);
	//if(RacePlayerStats[playerid][race_player_cp]>0)RacePlayerStats[playerid][race_player_cp]=RacePlayerStats[playerid][race_player_cp]-1;
	return 1;
}

forward Race_OnPlayerSpawn(playerid);
public Race_OnPlayerSpawn(playerid)
{
    new raceid = GetPlayerRace(playerid);
   	if(PlayerQuest[playerid] == GetRaceQuestID(raceid))
   	{
		if(RaceStats[raceid][race_state] == RACE_STATE_RACING)
		{
  		if(Race[raceid][race_type] == 5)
    	{
	    if(RacePlayerStats[playerid][race_player_status] == 1)
	    {
	        new i=RacePlayerStats[playerid][race_player_vehicle];
	        SetVehicleToRespawn(i);
			SetVehiclePos(i,
				RacePlayerVechicleStats[playerid][race_player_cX],
				RacePlayerVechicleStats[playerid][race_player_cY],
				RacePlayerVechicleStats[playerid][race_player_cZ]);
		
			PutPlayerInVehicle(playerid,i,0);
			
			SetVehicleZAngle(i,RacePlayerVechicleStats[playerid][race_player_angel]);
			
			TogglePlayerControllable(playerid, 0);
			GameTextForPlayer(playerid, "~y~Ready!",1000,4);
			SetTimerEx("player_race_spawn",500,0,"d",playerid);
      		return 1;
   		}
   		}
   		}
	}
	return 1;
}

/*forward Race_OnPlayerDeath(playerid, killerid, reason);
public Race_OnPlayerDeath(playerid, killerid, reason)
{
    SetVehicleToRespawn(RacePlayerStats[playerid][race_player_vehicle]);
	return 1;
}*/

// LineupRacesCount()
// {
// new count;
// for(new raceid=1;raceid<MAX_RACES;raceid++)
// {
// if(RaceStats[raceid][race_state] == RACE_STATE_LINEUP)
// {
// count++;
// }
// }
// return count;
// }
