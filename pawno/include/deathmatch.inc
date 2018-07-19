//
// Created:     08.09.06
// Aurthor:    Iain Gilbert
// ReCreate: Artem Firstov (Konsul)

#if defined _deathmatch_included
  #endinput
#endif

#define _deathmatch_included
#pragma library deathmatch
#include "base"
#include "weapons"
#include "player"

forward CheckDM();
forward RegisterDM(name[]);
forward OnPlayerDMKill(playerid,victimid,weaponid);
forward OnPlayerDMDeath(playerid,killerid);
forward OnPlayerEnterDMCheckpoint(playerid);
forward DMCommandHandler(playerid,text[]);
forward GetPlayerInZombie(playerid,dmid);
//forward GetDMStat(dmid,playerid);

#define MAX_DMWEAPONS 10
//#define MAX_DM 50
#define MAX_DM_SP 10

#define DM_TYPE 0
#define DM_TYPE_ZOMBIE 1
#define DM_TYPE_GUNGAME 2

#define MAX_TEAMS 2
#define INVALID_TEAM_ID -1

#define Team_0_C 0xFF4238FF
#define Team_1_C 0x2370FFFF

#define DM_STATE_DISABLED 0
#define DM_STATE_SLEEPING 1
#define DM_STATE_LINEUP 2
#define DM_STATE_COUNTDOWN 3
#define DM_STATE_ACTIVE 4
#define INVALID_DM_ID 0

// Для зомби режима
#define DM_ROLE_HUMAN 0
#define DM_ROLE_ZOMBIE 1
#define DM_ZOMBIE_RATIO 4 // all_count / z_count =~ 4
#define DM_ZOMBIE_MIN 1 // minimum z_count
//

#define DM_UPD_TIME 2000 // время через которое происходит update dm
#define DM4METimeMAX 150 // количество циклов update dm
new DM4METime = 0; // сколько циклов осталось чтобы разрешить команду 4me

#define TDM_SCORE_UP 20
#define TDM_PCOUNT_UP 10

enum DMInfo{
 dm_name[MAX_NAME],    // name of dm
 dm_type,           // type of dm
 dm_minlevel,         // minimum level required to enter dm
 dm_minplayers,         // minimum dmplayers needed to dm
 dm_maxtime,       // max time player can take to complete a dm
 dm_frequency,        // frquency that dm runs
 dm_lineupdelay,       // time to wait for players to linup
 dm_cashprize,   // cash earned for 1st position
 dm_cashentry,   // Cash required to enter (earned by winner)
 dm_xpprize,    // xp earned for 1st position
 dm_xpbonus,   // xp earned per player still in dm
 dm_distance,        // distance players can wander from DM
 dm_xpkill,          // xp gained for killing someone in dm
 dm_xpdeath,         // xp lost for dieing in dm
 dm_activedmjoin,         // can a player join this dm while it is currently running
 dm_interior,            //interior where dm is run
 dm_virtual,            // virtual world
 dm_weapons[MAX_DMWEAPONS],   //array of dm weaponid's
 dm_team
}
new Deathmatch[MAX_DM][DMInfo];

enum DMStateInfo{
 dm_state,             // dm state
 dm_timer,
 dm_playercount,
 dm_questid,
 dm_activecpid
 //dm_allkills
}
new DeathmatchStats[MAX_DM][DMStateInfo];

enum DMPlayerInfo{
 dm_player_active, // is the player active and spawned in the deathmatch zone
 dm_player_kills,
 dm_player_deaths,
 dm_player_gotcentre,
 dm_player_outzone,
 dm_player_team,
 dm_player_role,
 Text3D:dm_player_3dtext
}
new DMPlayerStats[MAX_PLAYERS][DMPlayerInfo];
//DMPlayerStats[playerid][dm_player_team];

enum DMScoreInfo {
 dm_score_player[MAX_NAME],
 dm_score_record,
 dm_score_kills,
 dm_score_deaths
}
new DMBestScore[MAX_DM][DMScoreInfo];

enum DMTeamInfo {
team_pCount,
team_Score
}
new TeamStats[MAX_DM][MAX_TEAMS][DMTeamInfo];

enum InfoZY {
    Float:Coord_X,
    Float:Coord_Y,
    Float:Coord_Xx,
    Float:Coord_Yy
}
new DMZone[MAX_DM][InfoZY]; //  в 2006 году Гильберт написал, что в пешке не существует 3х мерных массивов, так сломаем все стереотипы

Float:GetDMZPX(dmid)
{
 return DMZone[dmid][Coord_X];
}
Float:GetDMZPY(dmid)
{
 return DMZone[dmid][Coord_Y];
}
Float:GetDMZPXx(dmid)
{
 return DMZone[dmid][Coord_Xx];
}
Float:GetDMZPYy(dmid)
{
 return DMZone[dmid][Coord_Yy];
}

/////
/*
new Zones;

forward ZombieInit();
public ZombieInit()
{
	Zones = GangZoneCreate(1812.60,-2179.20,1970.60,-1852.80);
}

forward ZombiePlayerSpawn(playerid);
public ZombiePlayerSpawn(playerid)
{
    GangZoneShowForPlayer(playerid, Zones, 0xFFFF0096);
    return 1;
}
*/
/////

OnPlayerTeamKill(playerid,victimid,dmid)
{
if(Deathmatch[dmid][dm_team] == 0) {return 0;}
new p_team = DMPlayerStats[playerid][dm_player_team];
new v_team = DMPlayerStats[victimid][dm_player_team];
if(p_team == v_team) {TeamStats[dmid][p_team][team_Score]--;}
else if(v_team != -1) {TeamStats[dmid][p_team][team_Score]++;}
new str[MAX_STRING];
//format(str, sizeof(str), lang_texts[4][71], TeamStats[dmid][0][team_Score], TeamStats[dmid][1][team_Score]);
//GameTextForDMPlayers(dmid,str);

if(TeamStats[dmid][0][team_Score] > TeamStats[dmid][1][team_Score])
{
format(str, sizeof(str), lang_texts[4][72], TeamStats[dmid][0][team_Score], TeamStats[dmid][1][team_Score]);
SendMessageToDMPlayers(dmid,str,Team_0_C);
}

if(TeamStats[dmid][0][team_Score] < TeamStats[dmid][1][team_Score])
{
format(str, sizeof(str), lang_texts[4][73], TeamStats[dmid][0][team_Score], TeamStats[dmid][1][team_Score]);
SendMessageToDMPlayers(dmid,str,Team_1_C);
}

if(TeamStats[dmid][0][team_Score] == TeamStats[dmid][1][team_Score])
{
format(str, sizeof(str), lang_texts[4][74], TeamStats[dmid][0][team_Score], TeamStats[dmid][1][team_Score]);
SendMessageToDMPlayers(dmid,str,COLOUR_TDM);
}

return 1;
}

stock GameTextForDMPlayers(dmid,text[])
{
for(new i=0;i<MAX_PLAYERS;i++)
{
if(!IsPlayerConnected(i)) {continue;}
if(PlayerQuest[i] == GetDMQuestID(dmid))
{
GameTextForPlayer(i,text,1500,3);
}
}
return 1;
}

TeamFinishDM(dmid)
{

new team_score[2];
new team_pcount[2];
new c_price[2];
new xp_price[2];

if(TeamStats[dmid][0][team_Score] > TDM_SCORE_UP) {team_score[0] = TDM_SCORE_UP;}
else {team_score[0] = TeamStats[dmid][0][team_Score];}

if(TeamStats[dmid][1][team_Score] > TDM_SCORE_UP) {team_score[1] = TDM_SCORE_UP;}
else {team_score[1] = TeamStats[dmid][1][team_Score];}

if(TeamStats[dmid][0][team_pCount] > TDM_PCOUNT_UP) {team_pcount[0] = TDM_PCOUNT_UP*TDM_PCOUNT_UP;}
else {team_pcount[0] = TeamStats[dmid][0][team_pCount]*TeamStats[dmid][0][team_pCount];}

if(TeamStats[dmid][1][team_pCount] > TDM_PCOUNT_UP) {team_pcount[1] = TDM_PCOUNT_UP*TDM_PCOUNT_UP;}
else {team_pcount[1] = TeamStats[dmid][1][team_pCount]*TeamStats[dmid][1][team_pCount];}

c_price[0] =  team_score[0] * Deathmatch[dmid][dm_cashprize] * team_pcount[0];
c_price[1] =  team_score[1] * Deathmatch[dmid][dm_cashprize] * team_pcount[1];

xp_price[0] = team_score[0] * Deathmatch[dmid][dm_xpprize] * team_pcount[0];
xp_price[1] = team_score[1] * Deathmatch[dmid][dm_xpprize] * team_pcount[1];

new str[MAX_STRING];

format(str, sizeof(str), lang_texts[4][75], Deathmatch[dmid][dm_name]);
SendMessageToDMPlayers(dmid, str, 0x808080FF);

new wonteam = GetWonTeam(dmid);

if(wonteam == 0)
{
format(str, sizeof(str), lang_texts[4][76], TeamStats[dmid][0][team_Score], TeamStats[dmid][1][team_Score]);
SendMessageToDMPlayers(dmid, str, Team_0_C);
xp_price[1] = xp_price[1]/4;
c_price[1] = c_price[1]/4;
}
else if(wonteam == 1)
{
format(str, sizeof(str), lang_texts[4][77], TeamStats[dmid][0][team_Score], TeamStats[dmid][1][team_Score]);
SendMessageToDMPlayers(dmid, str, Team_1_C);
xp_price[0] = xp_price[0]/4;
c_price[0] = c_price[0]/4;
}
else if(wonteam == -1)
{
format(str, sizeof(str), lang_texts[4][78], TeamStats[dmid][0][team_Score], TeamStats[dmid][1][team_Score]);
SendMessageToDMPlayers(dmid, str, COLOUR_TDM);
xp_price[0] = xp_price[0]/2;
c_price[0] = c_price[0]/2;
xp_price[1] = xp_price[1]/2;
c_price[1] = c_price[1]/2;
}

for (new i=0; i<MAX_PLAYERS;i++)
{
  if (!IsPlayerConnected(i)) continue;
     if (PlayerQuest[i] == GetDMQuestID(dmid))
	 {
	 if(DMPlayerStats[i][dm_player_team] == 0)
	 {
	 oGivePlayerMoney(i, c_price[0], 1);
     //GivePlayerXP(i, xp_price[0], 1);
  			new Lvl = GetPlayerScore(i);
			new XPtdm = 0;
			if(Lvl < 5) XPtdm = 500;
			else if(Lvl > 4 && Lvl < 10) XPtdm = 1000;
			else if(Lvl > 9 && Lvl < 15) XPtdm = 2000;
			else if(Lvl > 14 && Lvl < 20) XPtdm = 4000;
			else if(Lvl > 19 && Lvl < 25) XPtdm = 6000;
			else if(Lvl > 24 && Lvl < 30) XPtdm = 8000;
			else if(Lvl > 29 && Lvl < 35) XPtdm = 9000;
			else if(Lvl > 34 && Lvl < 40) XPtdm = 10000;
			GivePlayerXP(i, XPtdm, 1);
	 }
	 if(DMPlayerStats[i][dm_player_team] == 1)
	 {
	 oGivePlayerMoney(i, c_price[1], 1);
     //GivePlayerXP(i, xp_price[1], 1);
  			new Lvl = GetPlayerScore(i);
			new XPtdm = 0;
			if(Lvl < 5) XPtdm = 500;
			else if(Lvl > 4 && Lvl < 10) XPtdm = 1000;
			else if(Lvl > 9 && Lvl < 15) XPtdm = 2000;
			else if(Lvl > 14 && Lvl < 20) XPtdm = 4000;
			else if(Lvl > 19 && Lvl < 25) XPtdm = 6000;
			else if(Lvl > 24 && Lvl < 30) XPtdm = 8000;
			else if(Lvl > 29 && Lvl < 35) XPtdm = 9000;
			else if(Lvl > 34 && Lvl < 40) XPtdm = 10000;
			GivePlayerXP(i, XPtdm, 1);
	 }
	 PlayerLeaveDM(i,dmid);
	 }
}
return 1;
}

GetWonTeam(dmid)
{
if(TeamStats[dmid][0][team_Score] > TeamStats[dmid][1][team_Score]) {return 0;}
if(TeamStats[dmid][0][team_Score] < TeamStats[dmid][1][team_Score]) {return 1;}
if(TeamStats[dmid][0][team_Score] == TeamStats[dmid][1][team_Score]) {return -1;}
return -1;
}


new DMCount; // count of active deathmatches
new DMCPSize=8; // size of checkpoints
new Float:DMSpawnPoints[MAX_DM][MAX_CP][CoordInfo]; // moo
new DMSpawnsSize[MAX_DM]; // number of spawnpoints
new DMStartCP[MAX_DM][CoordInfo];
new DMCentreCP[MAX_DM][CoordInfo];
new HumanCount[MAX_DM];

//--------------------------------------------------------------
Float:GetDMCPX(dmid)
{
 return DMStartCP[dmid][Coord_X];
}
Float:GetDMCPY(dmid)
{
 return DMStartCP[dmid][Coord_Y];
}
Float:GetDMCPZ(dmid)
{
 return DMStartCP[dmid][Coord_Z];
}
//--------------------------------------------------------------

new DeathmatchDB[MAX_STRING] = "GTO/Deathmatch/GTO.Deathmatches.txt";
new DMBaseDB[MAX_STRING] = "GTO/Deathmatch/";
new DMRecordDB[MAX_STRING] = "GTO/Deathmatch/Record/";

public CheckDM() // must be ran by timer every second
{
	if(DM4METime > 0){DM4METime--;}
    new string[MAX_STRING];
	new timetoend;
// Секунндный таймер (х2)
for (new playerid=0; playerid<MAX_PLAYERS;playerid++)
{
	if (IsPlayerConnected(playerid))
 	{
		if(Player[playerid][EventBan] > 0)
		{
		    Player[playerid][EventBan]--;
		}
	}
}
// Секундный таймер (х2)
 for (new dmid=1; dmid<=DMCount;dmid++)
 {
     if (DeathmatchStats[dmid][dm_state] == DM_STATE_DISABLED) continue;

  if (DeathmatchStats[dmid][dm_state] == DM_STATE_SLEEPING)
  {
      if (DeathmatchStats[dmid][dm_timer] <= 0) // if it is time to run
      {
       DeathmatchStats[dmid][dm_timer] = 0;
          StartDMLineup(dmid);
          continue;
   }
   DeathmatchStats[dmid][dm_timer]--;
   continue;
  }

  DeathmatchStats[dmid][dm_timer]++;
  if (DeathmatchStats[dmid][dm_state] == DM_STATE_LINEUP)
  {
      if (DeathmatchStats[dmid][dm_timer] >= Deathmatch[dmid][dm_lineupdelay]) // if it is time to run
      {
       DeathmatchStats[dmid][dm_timer] = 0;
          StartDMCountdown(dmid);
   }
   else
   {
       if (DeathmatchStats[dmid][dm_playercount] > 0)
       {
           new dmcountdown = Deathmatch[dmid][dm_lineupdelay] - DeathmatchStats[dmid][dm_timer];
     if ((dmcountdown == 5) || (dmcountdown == 10) || (dmcountdown == 20) || (dmcountdown == 30) || (dmcountdown == 45) || (dmcountdown == 60) || (dmcountdown == 90))
     {
      if(Deathmatch[dmid][dm_type] == 1) {
      format(string, sizeof(string),  lang_texts[4][80] ,(Deathmatch[dmid][dm_lineupdelay] - DeathmatchStats[dmid][dm_timer]));
	  } else {
      format(string, sizeof(string),  lang_texts[4][1] ,(Deathmatch[dmid][dm_lineupdelay] - DeathmatchStats[dmid][dm_timer]));
  	  }
      SendMessageToDMPlayers(dmid,string,COLOUR_DM);

     }
    }
   }
  }
  else if (DeathmatchStats[dmid][dm_state] == DM_STATE_COUNTDOWN)
  {
   for (new playerid=0; playerid<MAX_PLAYERS;playerid++)
   {
       if (IsPlayerConnected(playerid))
    {
       if (PlayerQuest[playerid] == GetDMQuestID(dmid)) // if player is in this dm
        {
                   if (DMPlayerStats[playerid][dm_player_active] == 1)
                   {



	   if(Deathmatch[dmid][dm_type] != 1)
	   {
       new Countdown = MAX_COUNTDOWN - DeathmatchStats[dmid][dm_timer];
       if (Countdown >= 1)
       {
        format(string, sizeof(string), "%d",Countdown);
        PlayerPlaySound(playerid,1056,GetPlayerX(playerid),GetPlayerY(playerid),GetPlayerZ(playerid));
       }
       else
       {
        format(string, sizeof(string), "GO!");
        PlayerPlaySound(playerid,1057,GetPlayerX(playerid),GetPlayerY(playerid),GetPlayerZ(playerid));
       }
       GameTextForPlayer(playerid, string,1000,6);
       } else {
       new Countdown = 25 - DeathmatchStats[dmid][dm_timer];
       if (Countdown >= 1)
       {
        format(string, sizeof(string), "%d",Countdown);
        PlayerPlaySound(playerid,1056,GetPlayerX(playerid),GetPlayerY(playerid),GetPlayerZ(playerid));
       }
       else
       {
        format(string, sizeof(string), "Zombies are infected!");
        PlayerPlaySound(playerid,1057,GetPlayerX(playerid),GetPlayerY(playerid),GetPlayerZ(playerid));
       }
       GameTextForPlayer(playerid, string,1000,6);
       }




        }
     }
     }
   }
   
   if(Deathmatch[dmid][dm_type] != 1)
   {
   if (DeathmatchStats[dmid][dm_timer] >= MAX_COUNTDOWN)
   {
       StartDM(dmid);
   }
   } else {
   if (DeathmatchStats[dmid][dm_timer] >= 25)
   {
       StartDM(dmid);
   }
   }
   
  }
		else if (DeathmatchStats[dmid][dm_state] == DM_STATE_ACTIVE)
		{
			CheckDMPlayersInZone(dmid);

			timetoend = Deathmatch[dmid][dm_maxtime] - DeathmatchStats[dmid][dm_timer];
			if ((timetoend == 20) || (timetoend == 15) || (timetoend == 10) || ((timetoend <= 5) && (timetoend > 0)))
			{
   			if(Deathmatch[dmid][dm_type] != 1)
   			{
			format(string,sizeof(string),"Десматч '%s' закончится через %d секунд",Deathmatch[dmid][dm_name],timetoend);
			} else {
			format(string,sizeof(string),"Зомби-Выживание '%s' закончится через %d секунд",Deathmatch[dmid][dm_name],timetoend);
			}
			SendMessageToDMPlayers(dmid,string,COLOUR_DM);
			}


			if (DeathmatchStats[dmid][dm_timer] >= Deathmatch[dmid][dm_maxtime]) // if time limit reached
		 {
		  EndDM(dmid);
   }
  }
 }
}

CheckDMPlayersInZone(dmid)
{
 for (new playerid=0;playerid<MAX_PLAYERS;playerid++)
 {
     if (!IsPlayerConnected(playerid))
  {
      //DMResetPlayerStats(playerid);
   continue;
  }
     if (!IsPlayerInDM(playerid,dmid)) continue;
     if (DMPlayerStats[playerid][dm_player_active] == 0) continue;
        //new Float:playerdistance;
        //new Float:x,Float:y,Float:z;
        //GetPlayerPos(playerid, x, y, z);
        //playerdistance = GetDistanceXYZtoXYZ(x,y,z,DMCentreCP[dmid][Coord_X],DMCentreCP[dmid][Coord_Y],DMCentreCP[dmid][Coord_Z]);
  //if (playerdistance > Deathmatch[dmid][dm_distance])
  if(Deathmatch[dmid][dm_type] == 1) {
    if(GetPlayerInZombie(playerid,dmid) == 0)
    {
        if(DMPlayerStats[playerid][dm_player_role] == DM_ROLE_HUMAN)
        {
  			SetPlayerTeam(playerid,1);
			HumanCount[dmid]--;
		}
		// Код смерти
		Suecid[playerid] = 1;
		SetPlayerHealth(playerid,0);
		SendClientMessage(playerid,COLOUR_RED,  " [Zombie] Вы вышли за пределы территории. Вы зомби!" );
		SetPlayerTeam(playerid,1);
    }
  }
  else if (!IsPlayerInRangeOfPoint(playerid,Deathmatch[dmid][dm_distance],DMCentreCP[dmid][Coord_X],DMCentreCP[dmid][Coord_Y],DMCentreCP[dmid][Coord_Z]))
  {
      DMPlayerStats[playerid][dm_player_outzone]++;
   if (DMPlayerStats[playerid][dm_player_outzone] > 12)
   {
    SendClientMessage(playerid,COLOUR_RED,  lang_texts[4][2] );
    	new logstring[256];
    	format(logstring, sizeof (logstring), "player: %d:  %s: has been kicked from the deathmatch because you he left the deathmatch zone",playerid,oGetPlayerName(playerid));
       	WriteLog(logstring);
    PlayerLeaveDM(playerid,dmid);
    DMPlayerStats[playerid][dm_player_outzone] = 0;
    continue;
   }
   else if (DMPlayerStats[playerid][dm_player_outzone] > 2)
   {
    SendClientMessage(playerid,COLOUR_YELLOW,  lang_texts[4][3] );
   }
  }
 }
}

DMPlayerDisconnect(playerid)
{
 new dmid = GetPlayerDM(playerid);
 if (dmid == INVALID_DM_ID) return;

	PlayerLeaveDM(playerid,dmid);
}

public RegisterDM(name[])
{
 for (new i=0;i<MAX_DM;i++)
 {
		   if (DeathmatchStats[i][dm_state] == DM_STATE_DISABLED) continue;
		   if (strcomp(name,Deathmatch[i][dm_name],true)==1)
     {
         return INVALID_DM_ID;
     }
 }
 if (DMCount >= MAX_DM) return INVALID_DM_ID;
 DMCount++;
  new dmid = DMCount;
  DeathmatchStats[dmid][dm_questid] = RegisterQuest(name, 2);
  if (DeathmatchStats[dmid][dm_questid] == INVALID_QUEST_ID)
 {
  DMCount--;
   return INVALID_DM_ID;
 }
 set(Deathmatch[dmid][dm_name],name);
  return dmid;
}


StartDMLineup(dmid)
{
 DeathmatchStats[dmid][dm_state] = DM_STATE_LINEUP;
 DeathmatchStats[dmid][dm_timer] = 0;
 DeathmatchStats[dmid][dm_playercount] = 0;
 new string1[MAX_STRING];
 new string2[MAX_STRING];
 new string3[MAX_STRING];
 
if(Deathmatch[dmid][dm_type] == 1)
{
format(string1, sizeof(string1),  lang_texts[4][79] ,Deathmatch[dmid][dm_name],dmid,Deathmatch[dmid][dm_lineupdelay]);
format(string3, sizeof(string3), "~n~ ~n~ ~r~zombie ~w~%s ~n~~r~...after~w~ %d~r~ sec." ,Deathmatch[dmid][dm_name],Deathmatch[dmid][dm_lineupdelay]);
} else if(Deathmatch[dmid][dm_team] == 1)
{
format(string1, sizeof(string1),  lang_texts[4][70] ,Deathmatch[dmid][dm_name],dmid,Deathmatch[dmid][dm_lineupdelay],GetDMStartZoneName(dmid));
format(string3, sizeof(string3), "~n~ ~n~ ~p~tdm ~w~%s ~n~~p~...after~w~ %d~p~ sec." ,Deathmatch[dmid][dm_name],Deathmatch[dmid][dm_lineupdelay]);
}
else
{
format(string1, sizeof(string1),  lang_texts[4][4] ,Deathmatch[dmid][dm_name],dmid,Deathmatch[dmid][dm_lineupdelay],GetDMStartZoneName(dmid));
format(string3, sizeof(string3), "~n~ ~n~ ~r~dm ~w~%s ~n~~r~...after~w~ %d~r~ sec." ,Deathmatch[dmid][dm_name],Deathmatch[dmid][dm_lineupdelay]);
}
	

	GameTextForAll(string3, 3999, 1);
 if (Deathmatch[dmid][dm_minplayers] > 1)
 {
  format(string2, sizeof(string2),  lang_texts[4][5] , dmid);
 }
 else
 {
  format(string2, sizeof(string2),  lang_texts[4][6] , dmid);
 }
 for (new playerid=0; playerid<MAX_PLAYERS;playerid++)
 {
  if (!IsPlayerConnected(playerid)) continue;
  SendClientMessage(playerid,GetDMColourForPlayer(playerid,dmid), string1);
  SendClientMessage(playerid,GetDMColourForPlayer(playerid,dmid), string2);
     if (PlayerQuest[playerid] == 0) // if player not on a quest
     {
      oSetPlayerCheckpoint(playerid,GetDMCPX(dmid),GetDMCPY(dmid),GetDMCPZ(dmid),DMCPSize);
      DMResetPlayerStats(playerid);
  }
 }
 DeathmatchStats[dmid][dm_activecpid] = AddActiveCheckpoint(GetDMCPX(dmid),GetDMCPY(dmid),GetDMCPZ(dmid),10000,8);
}

new Zone[MAX_DM];
StartDMCountdown(dmid)
{
    DeathmatchStats[dmid][dm_timer]=0;
 //if (DeathmatchStats[dmid][dm_activecpid] != 0)
 //{
 // RemoveActiveCheckpoint(DeathmatchStats[dmid][dm_activecpid]);
 // DeathmatchStats[dmid][dm_activecpid] = 0;
  //}
 new string[MAX_STRING];
 
if(Deathmatch[dmid][dm_type] == 1)
{
	Zone[dmid] = GangZoneCreate(GetDMZPX(dmid),GetDMZPY(dmid),GetDMZPXx(dmid),GetDMZPYy(dmid));
	HumanCount[dmid]=0;
}

 for (new playerid=0; playerid<MAX_PLAYERS;playerid++)
 {
  if (!IsPlayerConnected(playerid)) continue;
     if (PlayerQuest[playerid] == GetDMQuestID(dmid)) // if player is in this dm
     {
         /*if (!oIsPlayerInCheckpoint(playerid,GetDMCPX(dmid),GetDMCPY(dmid),GetDMCPZ(dmid),50))
         {
        	PlayerLeaveDM(playerid,dmid);
       		SendPlayerFormattedText(playerid,  lang_texts[4][7] , 0,COLOUR_RED);
		 }*/
	 }
 }

 if (DeathmatchStats[dmid][dm_playercount] < Deathmatch[dmid][dm_minplayers])
 {
  if(Deathmatch[dmid][dm_type] == 1)
  {
    format(string, sizeof(string),  lang_texts[4][81] ,Deathmatch[dmid][dm_name]);
  } else {
  	format(string, sizeof(string),  lang_texts[4][9] ,Deathmatch[dmid][dm_name]);
  }
  SendClientMessageToRegistered(COLOUR_RED, string);

  if(Deathmatch[dmid][dm_type] == 1)
  {
    format(string, sizeof(string),  lang_texts[4][82] ,Deathmatch[dmid][dm_name]);
  } else {
  	format(string, sizeof(string),  lang_texts[4][10] ,Deathmatch[dmid][dm_name]);
  }
  SendMessageToDMPlayers(dmid,string,COLOUR_DM);
  

  if (PlayerCount() > 0)
  {
   new logstring[256];
   format(logstring, sizeof (logstring), "Deathmatch: '%s' did not run. Not enough players.",Deathmatch[dmid][dm_name]);
      WriteLog(logstring);
  }
  
  CleanupDM(dmid);
  return;
 }
 if(Deathmatch[dmid][dm_type] == 1)
 {
    format(string, sizeof(string),  lang_texts[4][83] ,Deathmatch[dmid][dm_name]);
 } else {
 	format(string, sizeof(string),  lang_texts[4][11] ,Deathmatch[dmid][dm_name]);
 }
 SendClientMessageToRegistered(COLOUR_DM, string);
    new logstring[256];
 format(logstring, sizeof (logstring), "Deathmatch: %s starting.",Deathmatch[dmid][dm_name]);
    WriteLog(logstring);
 DeathmatchStats[dmid][dm_state] = DM_STATE_COUNTDOWN;
new rnd;
 for (new playerid=0; playerid<MAX_PLAYERS;playerid++)
 {
  if (!IsPlayerConnected(playerid)) continue;
     if (PlayerQuest[playerid] == GetDMQuestID(dmid)) // if player is in this dm
     {
         //if (oIsPlayerInCheckpoint(playerid,GetDMCPX(dmid),GetDMCPY(dmid),GetDMCPZ(dmid),50))
         //{
         if(Deathmatch[dmid][dm_type] == 1)
		 {
         	GangZoneShowForPlayer(playerid, Zone[dmid], 0xFFFF0096);
         	SetPlayerTeam(playerid,0);
         	DMPlayerStats[playerid][dm_player_3dtext] = Create3DTextLabel( " ", COLOUR_CRIMSON, 7.77, 7.77, 7.77, 100.0, 0, 1 );
         }
	if(Deathmatch[dmid][dm_team] == 1)
	  {
	  if(TeamStats[dmid][0][team_pCount] > TeamStats[dmid][1][team_pCount])
	  {
	  DMPlayerStats[playerid][dm_player_team] = 1;
	  TeamStats[dmid][1][team_pCount]++;
	  SetPlayerTeam(playerid,1);
	  }
	  else if(TeamStats[dmid][0][team_pCount] < TeamStats[dmid][1][team_pCount])
	  {
	  DMPlayerStats[playerid][dm_player_team] = 0;
	  TeamStats[dmid][0][team_pCount]++;
	  SetPlayerTeam(playerid,0);
	  }
	  else if(TeamStats[dmid][0][team_pCount] == TeamStats[dmid][1][team_pCount])
	  {
	  rnd = random(MAX_TEAMS);
	  DMPlayerStats[playerid][dm_player_team] = rnd;
	  TeamStats[dmid][rnd][team_pCount]++;
	  SetPlayerTeam(playerid,rnd);
	  }
	  }
 	if(Deathmatch[dmid][dm_type] != 1) {
    TogglePlayerControllable(playerid, 0);
    }
    SetCameraBehindPlayer(playerid);
    DMPlayerSpawn(playerid,dmid);
   //}
  }
 }
}

StartDM(dmid)
{
 DeathmatchStats[dmid][dm_timer]=0;
 DeathmatchStats[dmid][dm_state] = DM_STATE_ACTIVE;
 //
if(Deathmatch[dmid][dm_type] == 1)
{
SetPlayerDMZombieRole(dmid);
}
 //
 for (new playerid=0; playerid<MAX_PLAYERS;playerid++)
 {
     if (IsPlayerConnected(playerid))
  {
      if (PlayerQuest[playerid] == GetDMQuestID(dmid)) // if player is in this dm
      {  
    	TogglePlayerControllable(playerid, 1);
    	if(Deathmatch[dmid][dm_type] == 1)
		{
    		if(DMPlayerStats[playerid][dm_player_role] == DM_ROLE_ZOMBIE)
    		{
				// Код смерти
				//Suecid[playerid] = 1;
				//SetPlayerHealth(playerid,0);
				//SendClientMessage(playerid,COLOUR_RED,  " [Zombie] Система рандома назначала Вас зомби. Атакуйте выживших!" );
				//SetPlayerTeam(playerid,1);
    		} //else {
				//HumanCount[dmid]++;
    		//}
		}
	  }
  }
 }
}

JoinDM(playerid,dmid)
{
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
	if(Player[playerid][EventBan] > 0)
	{
	    new str[MAX_STRING];
		format(str, sizeof(str), "Вы не можете участвовать в Зомби-Выживании ещё %d секунд. Причина: Выход с Зомби-Выживания", Player[playerid][EventBan]);
	    ShowPlayerDialog(playerid, S_GUI_02, 0,"Зомби-Выживание", str,"ОК","");
	    return;
	}
/* if (oGetPlayerMoney(playerid) < Deathmatch[dmid][dm_cashentry])
 {
  format(string, sizeof(string),  lang_texts[4][12] , Deathmatch[dmid][dm_cashentry]);
  SendPlayerFormattedText(playerid,string, 0,COLOUR_RED);
  return;
 }
 if (GetPlayerLevel(playerid) < Deathmatch[dmid][dm_minlevel])
 {
  format(string, sizeof(string),  lang_texts[4][13] , Deathmatch[dmid][dm_minlevel]);
  SendPlayerFormattedText(playerid,string, 0,COLOUR_RED);
  return;
 }*/
 /*
 if ( !IsPlayerAdmin(playerid) )
 {
  	if(Deathmatch[dmid][dm_type] == 1)
	{
	    ShowPlayerDialog(playerid, S_GUI_02, 0,"Зомби-Выживание","Зомби-Выживание находится на стадии тестирования!\nВ данный момент оно не доступно","ОК","");
	    return;
	}
 }*/
if(Deathmatch[dmid][dm_type] == 1)
{
 if ((DeathmatchStats[dmid][dm_state] == DM_STATE_ACTIVE) && (Deathmatch[dmid][dm_activedmjoin] == 0))
 {
	    ShowPlayerDialog(playerid, S_GUI_02, 0,"Зомби-Выживание","Зомби-Выживание уже началось, Вы не можете присоединиться к нему","ОК","");
	    return;
 }
}
 DMResetPlayerStats(playerid);
 DeathmatchStats[dmid][dm_playercount]++;
 speed_JoinDM(playerid,dmid);
    if (Deathmatch[dmid][dm_minplayers] > 1)
 {
  format(string, sizeof(string),  lang_texts[4][14] , oGetPlayerName(playerid),DeathmatchStats[dmid][dm_playercount],Deathmatch[dmid][dm_minplayers]);
        new logstring[256];
  format(logstring, sizeof (logstring), "player: %d:  %s: has joined the deathmatch. (Players:%d/%d)",playerid,oGetPlayerName(playerid),DeathmatchStats[dmid][dm_playercount],Deathmatch[dmid][dm_minplayers]);
     WriteLog(logstring);
 }
 else
 {
  format(string, sizeof(string),  lang_texts[4][15] , oGetPlayerName(playerid),DeathmatchStats[dmid][dm_playercount]);
        new logstring[256];
  format(logstring, sizeof (logstring), "player: %d:  %s: has joined the deathmatch. (Players:%d)",playerid,oGetPlayerName(playerid),DeathmatchStats[dmid][dm_playercount]);
     WriteLog(logstring);
 }
 SendMessageToDMPlayers(dmid,string,COLOUR_WHITE);

// oGivePlayerMoney(playerid,0-Deathmatch[dmid][dm_cashentry],1);
 GameTextForPlayer(playerid, "~g~Deathmatch Entered.",3000,6);
 PlayerQuest[playerid] = GetDMQuestID(dmid);

 if (DeathmatchStats[dmid][dm_state] == DM_STATE_LINEUP)
 {
 if(Deathmatch[dmid][dm_type] == 1) {
  format(string, sizeof(string),  lang_texts[4][84] ,(Deathmatch[dmid][dm_lineupdelay] - DeathmatchStats[dmid][dm_timer]));
 } else {
  format(string, sizeof(string),  lang_texts[4][16] ,(Deathmatch[dmid][dm_lineupdelay] - DeathmatchStats[dmid][dm_timer]));
 }
   SendPlayerFormattedText(playerid, string, 0,COLOUR_DM);
   oSetPlayerCheckpoint(playerid,GetDMCPX(dmid),GetDMCPY(dmid),GetDMCPZ(dmid),DMCPSize);
 }
 else if ((DeathmatchStats[dmid][dm_state] == DM_STATE_ACTIVE) && (Deathmatch[dmid][dm_activedmjoin] == 1))
 {
     SendPlayerFormattedText(playerid,  lang_texts[4][17] , 0,COLOUR_DM);
     //if (oIsPlayerInCheckpoint(playerid,GetDMCPX(dmid),GetDMCPY(dmid),GetDMCPZ(dmid),50))
      //  {
  	/*if(Deathmatch[dmid][dm_type] == 1)
	{
	    ShowPlayerDialog(playerid, S_GUI_02, 0,"Зомби-Выживание","Зомби-Выживание уже началось, Вы не можете присоединиться к нему","ОК","");
	    return;
	}*/
		
	if(Deathmatch[dmid][dm_team] == 1)
	  {
	  if(TeamStats[dmid][0][team_pCount] > TeamStats[dmid][1][team_pCount])
	  {
	  DMPlayerStats[playerid][dm_player_team] = 1;
	  TeamStats[dmid][1][team_pCount]++;
	  SetPlayerTeam(playerid,1);
	  }
	  else if(TeamStats[dmid][0][team_pCount] < TeamStats[dmid][1][team_pCount])
	  {
	  DMPlayerStats[playerid][dm_player_team] = 0;
	  TeamStats[dmid][0][team_pCount]++;
	  SetPlayerTeam(playerid,0);
	  }
	  else if(TeamStats[dmid][0][team_pCount] == TeamStats[dmid][1][team_pCount])
	  {
	  new rnd = random(MAX_TEAMS);
	  DMPlayerStats[playerid][dm_player_team] = rnd;
	  TeamStats[dmid][rnd][team_pCount]++;
	  SetPlayerTeam(playerid,rnd);
	  }
	  }
	  
   DMPlayerSpawn(playerid,dmid);
   format(string, sizeof(string), "GO!");
   PlayerPlaySound(playerid,1057,GetPlayerX(playerid),GetPlayerY(playerid),GetPlayerZ(playerid));
   GameTextForPlayer(playerid, string,1000,6);
   SetPlayerChatBubble(playerid, "Присоединился к десматчу", COLOR_GREEN, 20.0, 2000);

  //}
  //else
  //{
  // SendPlayerFormattedText(playerid,  lang_texts[4][18] , 0,COLOUR_DM);
  // oSetPlayerCheckpoint(playerid,GetDMCPX(dmid),GetDMCPY(dmid),GetDMCPZ(dmid),DMCPSize);
  //}
 }
 else
 {
  format(string, sizeof(string),  lang_texts[4][19] );
  SendPlayerFormattedText(playerid,string, 0,COLOUR_RED);
  return;
 }
}

DMPlayerSpawn(playerid,dmid)
{
 if (!IsPlayerInDM(playerid,dmid))
 {
  DMResetPlayerStats(playerid);
  return;
 }
 
 PlayerJustTeleported[playerid]+=5;
 SetPlayerInterior(playerid,Deathmatch[dmid][dm_interior]);
 oSetPlayerVirtualWorld(playerid,Deathmatch[dmid][dm_virtual]);
 if(Deathmatch[dmid][dm_type] == 1)
 {
    if(DMPlayerStats[playerid][dm_player_role] == DM_ROLE_ZOMBIE)
    {
		SetPlayerSkin(playerid,162);
		ResetPlayerDMWeapons(playerid);
		//DMPlayerStats[playerid][dm_player_3dtext] = Create3DTextLabel( "ЗОМБИ", COLOUR_CRIMSON, 7.77, 7.77, 7.77, 100.0, 0, 1 );
		Update3DTextLabelText(DMPlayerStats[playerid][dm_player_3dtext],COLOUR_CRIMSON,"ЗОМБИ");
 		new spid = random(DMSpawnsSize[dmid]);
 		SetPlayerPosEx(playerid,DMSpawnPoints[dmid][spid][Coord_X], DMSpawnPoints[dmid][spid][Coord_Y], DMSpawnPoints[dmid][spid][Coord_Z]);
 		SetPlayerTeam(playerid,1);
        Attach3DTextLabelToPlayer( DMPlayerStats[playerid][dm_player_3dtext], playerid, 0.0, 0.0, 0.0 );
        togglePlayerMapIconVisibility(playerid,false);
    } else {
        GivePlayerDMWeapons(playerid,dmid);
  		new spid = random(DMSpawnsSize[dmid]);
 		SetPlayerPosEx(playerid,DMSpawnPoints[dmid][spid][Coord_X], DMSpawnPoints[dmid][spid][Coord_Y], DMSpawnPoints[dmid][spid][Coord_Z]);
 		//SetPlayerTeam(playerid,0);
    }
 }
 else if(Deathmatch[dmid][dm_team] == 1)
 {
 new HalfSize = DMSpawnsSize[dmid]/2;
 if(DMPlayerStats[playerid][dm_player_team] == 0)
 {
 new spid = random(HalfSize);
 SetPlayerPosEx(playerid,DMSpawnPoints[dmid][spid][Coord_X], DMSpawnPoints[dmid][spid][Coord_Y], DMSpawnPoints[dmid][spid][Coord_Z]);
 SetPlayerColor(playerid,Team_0_C);
 GivePlayerDMWeapons(playerid,dmid);
 }
 if(DMPlayerStats[playerid][dm_player_team] == 1)
 {
 new spid = random(HalfSize) + HalfSize;
 SetPlayerPosEx(playerid,DMSpawnPoints[dmid][spid][Coord_X], DMSpawnPoints[dmid][spid][Coord_Y], DMSpawnPoints[dmid][spid][Coord_Z]);
 SetPlayerColor(playerid,Team_1_C);
 GivePlayerDMWeapons(playerid,dmid);
 }
 }
 else
 {
 new spid = random(DMSpawnsSize[dmid]);
 SetPlayerPosEx(playerid,DMSpawnPoints[dmid][spid][Coord_X], DMSpawnPoints[dmid][spid][Coord_Y], DMSpawnPoints[dmid][spid][Coord_Z]);
 SetPlayerColour(playerid,PlayerGangColour(playerid));
 GivePlayerDMWeapons(playerid,dmid);
 // Warp the player
}
//spid = random(DMSpawnsSize[dmid]);

 oSetPlayerHealth(playerid,GetMaxHealth(playerid)); // set health based on level
 oSetPlayerMoney(playerid,Player[playerid][Money]);
 DMPlayerStats[playerid][dm_player_active] = 1;
 //GivePlayerDMWeapons(playerid,dmid);
 oSetPlayerCheckpoint(playerid,DMCentreCP[dmid][Coord_X],DMCentreCP[dmid][Coord_Y],DMCentreCP[dmid][Coord_Z],DMCPSize);
 //oDisablePlayerCheckpoint(playerid);
}

// TDMPlayerSpawn(playerid,dmid)
// {
// if (!IsPlayerInDM(playerid,dmid))
 // {
  // DMResetPlayerStats(playerid);
  // return;
 // }
// PlayerJustTeleported[playerid]+=5;
// SetPlayerInterior(playerid,Deathmatch[dmid][dm_interior]);
//
// }

GetPlayerDMPosition(playerid,dmid)
{
 if (!IsPlayerInDM(playerid,dmid)) return 0;
 new position=1;
 for (new i=0;i<MAX_PLAYERS;i++)
 {
  if (!IsPlayerInDM(i,dmid)) continue;
  new iscore = DMPlayerStats[i][dm_player_kills] - DMPlayerStats[i][dm_player_deaths];
  new playerscore = DMPlayerStats[playerid][dm_player_kills] - DMPlayerStats[playerid][dm_player_deaths];
  if (iscore > playerscore)
  {
   position++;
  }
  else if (iscore == playerscore)
  {
      if (DMPlayerStats[i][dm_player_kills] > DMPlayerStats[playerid][dm_player_kills])
      {
       position++;
      }
  }
 }
 return position;
}

EndDM(dmid)
{
	if(Deathmatch[dmid][dm_type] == 1)
	{
	    new string[MAX_STRING];
		// Проверка на наличие зомби в ДМ
		if(HumanCount[dmid] == 0)
		{
			for (new playerid=0; playerid<MAX_PLAYERS;playerid++)
			{
				if (!IsPlayerConnected(playerid)) continue;
				if (PlayerQuest[playerid] == GetDMQuestID(dmid)) // if player is in this dm
				{
					if(DMPlayerStats[playerid][dm_player_role] == DM_ROLE_ZOMBIE)
					{
  						new Lvl = GetPlayerScore(playerid);
						if(Lvl < 5) GivePlayerXP(playerid, 500*DeathmatchStats[dmid][dm_playercount],1);
						else if(Lvl > 4 && Lvl < 10) GivePlayerXP(playerid, 1000*DeathmatchStats[dmid][dm_playercount],1);
						else if(Lvl > 9 && Lvl < 15) GivePlayerXP(playerid, 2000*DeathmatchStats[dmid][dm_playercount],1);
						else if(Lvl > 14 && Lvl < 20) GivePlayerXP(playerid, 2500*DeathmatchStats[dmid][dm_playercount],1);
						else if(Lvl > 19 && Lvl < 25) GivePlayerXP(playerid, 2900*DeathmatchStats[dmid][dm_playercount],1);
						else if(Lvl > 24 && Lvl < 30) GivePlayerXP(playerid, 3100*DeathmatchStats[dmid][dm_playercount],1);
						else if(Lvl > 29 && Lvl < 35) GivePlayerXP(playerid, 4300*DeathmatchStats[dmid][dm_playercount],1);
						else if(Lvl > 34 && Lvl < 40) GivePlayerXP(playerid, 5000*DeathmatchStats[dmid][dm_playercount],1);
					} else {
						new Lvl = GetPlayerScore(playerid);
						if(Lvl < 5) GivePlayerXP(playerid, 500,1);
						else if(Lvl > 4 && Lvl < 10) GivePlayerXP(playerid, 1000,1);
						else if(Lvl > 9 && Lvl < 15) GivePlayerXP(playerid, 2000,1);
						else if(Lvl > 14 && Lvl < 20) GivePlayerXP(playerid, 2500,1);
						else if(Lvl > 19 && Lvl < 25) GivePlayerXP(playerid, 2900,1);
						else if(Lvl > 24 && Lvl < 30) GivePlayerXP(playerid, 3100,1);
						else if(Lvl > 29 && Lvl < 35) GivePlayerXP(playerid, 4300,1);
						else if(Lvl > 34 && Lvl < 40) GivePlayerXP(playerid, 5000,1);
					}
 				}
			}
			// Сюда воткнуть сообщение о победе Зомби
			format(string, sizeof(string),lang_texts[4][85], Deathmatch[dmid][dm_name]);
			SendClientMessageToAll(COLOUR_CRIMSON, string);
		} else {
			for (new playerid=0; playerid<MAX_PLAYERS;playerid++)
			{
				if (!IsPlayerConnected(playerid)) continue;
				if (PlayerQuest[playerid] == GetDMQuestID(dmid)) // if player is in this dm
				{
					if(DMPlayerStats[playerid][dm_player_role] == DM_ROLE_HUMAN)
					{
  						new Lvl = GetPlayerScore(playerid);
						if(Lvl < 5) GivePlayerXP(playerid, 500*DeathmatchStats[dmid][dm_playercount],1);
						else if(Lvl > 4 && Lvl < 10) GivePlayerXP(playerid, 1000*DeathmatchStats[dmid][dm_playercount],1);
						else if(Lvl > 9 && Lvl < 15) GivePlayerXP(playerid, 2000*DeathmatchStats[dmid][dm_playercount],1);
						else if(Lvl > 14 && Lvl < 20) GivePlayerXP(playerid, 2500*DeathmatchStats[dmid][dm_playercount],1);
						else if(Lvl > 19 && Lvl < 25) GivePlayerXP(playerid, 2900*DeathmatchStats[dmid][dm_playercount],1);
						else if(Lvl > 24 && Lvl < 30) GivePlayerXP(playerid, 3100*DeathmatchStats[dmid][dm_playercount],1);
						else if(Lvl > 29 && Lvl < 35) GivePlayerXP(playerid, 4300*DeathmatchStats[dmid][dm_playercount],1);
						else if(Lvl > 34 && Lvl < 40) GivePlayerXP(playerid, 5000*DeathmatchStats[dmid][dm_playercount],1);
					} else {
						new Lvl = GetPlayerScore(playerid);
						if(Lvl < 5) GivePlayerXP(playerid, 500,1);
						else if(Lvl > 4 && Lvl < 10) GivePlayerXP(playerid, 1000,1);
						else if(Lvl > 9 && Lvl < 15) GivePlayerXP(playerid, 2000,1);
						else if(Lvl > 14 && Lvl < 20) GivePlayerXP(playerid, 2500,1);
						else if(Lvl > 19 && Lvl < 25) GivePlayerXP(playerid, 2900,1);
						else if(Lvl > 24 && Lvl < 30) GivePlayerXP(playerid, 3100,1);
						else if(Lvl > 29 && Lvl < 35) GivePlayerXP(playerid, 4300,1);
						else if(Lvl > 34 && Lvl < 40) GivePlayerXP(playerid, 5000,1);
					}
 				}
			}
			// Сюда воткнуть сообщение о победе Людей
			format(string, sizeof(string),lang_texts[4][86], Deathmatch[dmid][dm_name]);
			SendClientMessageToAll(COLOUR_LIGHTGREEN, string);
		}
		//
	}
	else if(Deathmatch[dmid][dm_team] == 1)
	{
		TeamFinishDM(dmid);
	}
	else
	{
 		for (new playerid=0; playerid<MAX_PLAYERS;playerid++)
		{
  			if (!IsPlayerConnected(playerid)) {continue;}
   			if (PlayerQuest[playerid] != GetDMQuestID(dmid)){continue;} // if player not is in this dm
			new playerpos = GetPlayerDMPosition(playerid,dmid);
			PlayerFinishDM(playerid,dmid,playerpos);
		}
	}
	CleanupDM(dmid);
	CleanupTeams(dmid);
}

CleanupDM(dmid)
{
// ВНИМАНИЕ! Вероятно приведет к крашу ДМ
 DeathmatchStats[dmid][dm_state] = DM_STATE_SLEEPING;
// ВНИМАНИЕ! Вероятно приведет к крашу ДМ
 for (new playerid=0; playerid<MAX_PLAYERS;playerid++)
 {
  if (!IsPlayerConnected(playerid)) continue;
     if (PlayerQuest[playerid] == GetDMQuestID(dmid)) // if player is in this dm
     {
      PlayerLeaveDM(playerid,dmid);
  }
 }
 DeathmatchStats[dmid][dm_playercount] = 0;
 DeathmatchStats[dmid][dm_timer] = MakeDMSleepTime(dmid);
 DeathmatchStats[dmid][dm_state] = DM_STATE_SLEEPING;
 //DeathmatchStats[dmid][dm_allkills] = 0;

 if (DeathmatchStats[dmid][dm_activecpid] != 0)
 {
  RemoveActiveCheckpoint(DeathmatchStats[dmid][dm_activecpid]);
  DeathmatchStats[dmid][dm_activecpid] = 0;
 }
}

CleanupTeams(dmid)
{
TeamStats[dmid][0][team_pCount] = 0;
TeamStats[dmid][1][team_pCount] = 0;
TeamStats[dmid][0][team_Score] = 0;
TeamStats[dmid][1][team_Score] = 0;
return 1;
}

PlayerFinishDM(playerid,dmid,position)
{
if(DMPlayerStats[playerid][dm_player_kills] > 0) // if player kill > 0
  {
  
  new string[MAX_STRING];
  set(string,FormatPosition(position));
  GameTextForPlayer(playerid,string,5000,6);
  PlayerPlaySoundOnPlayer(playerid,1057);
  
        if (position == 1)
        {
            format(string, sizeof(string),  lang_texts[4][20] ,Deathmatch[dmid][dm_name],FormatPosition(position),GetPlayerDMScore(playerid,dmid));
   SendClientMessage(playerid,COLOUR_GREEN, string);

            format(string, sizeof(string),  lang_texts[4][21] ,oGetPlayerName(playerid),Deathmatch[dmid][dm_name],GetPlayerDMScore(playerid,dmid));
            SendClientMessageToRegistered(COLOUR_DM, string);
            new logstring[256];
   format(logstring, sizeof (logstring), "player: %d:  %s: has won deathmatch '%s'! Score: %d",playerid,oGetPlayerName(playerid),Deathmatch[dmid][dm_name],GetPlayerDMScore(playerid,dmid));
      WriteLog(logstring);
   oGivePlayerMoney(playerid,Deathmatch[dmid][dm_cashprize],1);
            //GivePlayerXP(playerid,Deathmatch[dmid][dm_xpprize],1);
			new Lvl = GetPlayerScore(playerid);
			if(Lvl < 5) GivePlayerXP(playerid, 500*DeathmatchStats[dmid][dm_playercount],1);
			else if(Lvl > 4 && Lvl < 10) GivePlayerXP(playerid, 1000*DeathmatchStats[dmid][dm_playercount],1);
			else if(Lvl > 9 && Lvl < 15) GivePlayerXP(playerid, 2000*DeathmatchStats[dmid][dm_playercount],1);
			else if(Lvl > 14 && Lvl < 20) GivePlayerXP(playerid, 3000*DeathmatchStats[dmid][dm_playercount],1);
			else if(Lvl > 19 && Lvl < 25) GivePlayerXP(playerid, 4000*DeathmatchStats[dmid][dm_playercount],1);
			else if(Lvl > 24 && Lvl < 30) GivePlayerXP(playerid, 5000*DeathmatchStats[dmid][dm_playercount],1);
			else if(Lvl > 29 && Lvl < 35) GivePlayerXP(playerid, 6000*DeathmatchStats[dmid][dm_playercount],1);
			else if(Lvl > 34 && Lvl < 40) GivePlayerXP(playerid, 7000*DeathmatchStats[dmid][dm_playercount],1);
     }
        else if (position == 2)
        {
            format(string, sizeof(string),  lang_texts[4][22] ,Deathmatch[dmid][dm_name],FormatPosition(position),GetPlayerDMScore(playerid,dmid));
   SendClientMessage(playerid,COLOUR_GREEN, string);

   //format(string, sizeof(string),  lang_texts[4][23] ,oGetPlayerName(playerid),FormatPosition(Position[dmid]),Deathmatch[dmid][dm_name],GetPlayerDMScore(playerid));
            //SendClientMessageToRegistered(COLOUR_DM, string);
			/*
			if(DeathmatchStats[dmid][dm_playercount] > 2)
			{
			oGivePlayerMoney(playerid,(Deathmatch[dmid][dm_cashprize]/2),1);
			GivePlayerXP(playerid,(Deathmatch[dmid][dm_xpprize]/2),1);
			}
			else
			{
			GivePlayerXP(playerid,Deathmatch[dmid][dm_xpbonus] * DeathmatchStats[dmid][dm_playercount],1);
			}
			*/
			oGivePlayerMoney(playerid,(Deathmatch[dmid][dm_cashprize]/2),1);
			//GivePlayerXP(playerid,(Deathmatch[dmid][dm_xpprize]/2),1);
			new Lvl = GetPlayerScore(playerid);
			if(Lvl < 5) GivePlayerXP(playerid, 500/2*DeathmatchStats[dmid][dm_playercount],1);
			else if(Lvl > 4 && Lvl < 10) GivePlayerXP(playerid, 1000/2*DeathmatchStats[dmid][dm_playercount],1);
			else if(Lvl > 9 && Lvl < 15) GivePlayerXP(playerid, 2000/2*DeathmatchStats[dmid][dm_playercount],1);
			else if(Lvl > 14 && Lvl < 20) GivePlayerXP(playerid, 3000/2*DeathmatchStats[dmid][dm_playercount],1);
			else if(Lvl > 19 && Lvl < 25) GivePlayerXP(playerid, 4000/2*DeathmatchStats[dmid][dm_playercount],1);
			else if(Lvl > 24 && Lvl < 30) GivePlayerXP(playerid, 5000/2*DeathmatchStats[dmid][dm_playercount],1);
			else if(Lvl > 29 && Lvl < 35) GivePlayerXP(playerid, 6000/2*DeathmatchStats[dmid][dm_playercount],1);
			else if(Lvl > 34 && Lvl < 40) GivePlayerXP(playerid, 7000/2*DeathmatchStats[dmid][dm_playercount],1);
  }
        else if ((position == 3) && (DeathmatchStats[dmid][dm_playercount] > 3))
        {
            format(string, sizeof(string),  lang_texts[4][24] ,Deathmatch[dmid][dm_name],FormatPosition(position),GetPlayerDMScore(playerid,dmid));
   SendClientMessage(playerid,COLOUR_GREEN, string);

   //format(string, sizeof(string),  lang_texts[4][25] ,oGetPlayerName(playerid),FormatPosition(Position[dmid]),Deathmatch[dmid][dm_name],GetPlayerDMScore(playerid));
            //SendClientMessageToRegistered(COLOUR_DM, string);
			/*
			if (DeathmatchStats[dmid][dm_playercount] > 3)
			{
			oGivePlayerMoney(playerid,(Deathmatch[dmid][dm_cashprize]/3),1);
			GivePlayerXP(playerid,(Deathmatch[dmid][dm_xpprize]/3),1);
			}
			else
			{
			GivePlayerXP(playerid,Deathmatch[dmid][dm_xpbonus] * DeathmatchStats[dmid][dm_playercount],1);
			}
			*/
			oGivePlayerMoney(playerid,(Deathmatch[dmid][dm_cashprize]/4),1);
			//GivePlayerXP(playerid,(Deathmatch[dmid][dm_xpprize]/4),1);
			new Lvl = GetPlayerScore(playerid);
			if(Lvl < 5) GivePlayerXP(playerid, 500/4*DeathmatchStats[dmid][dm_playercount],1);
			else if(Lvl > 4 && Lvl < 10) GivePlayerXP(playerid, 1000/4*DeathmatchStats[dmid][dm_playercount],1);
			else if(Lvl > 9 && Lvl < 15) GivePlayerXP(playerid, 2000/4*DeathmatchStats[dmid][dm_playercount],1);
			else if(Lvl > 14 && Lvl < 20) GivePlayerXP(playerid, 3000/4*DeathmatchStats[dmid][dm_playercount],1);
			else if(Lvl > 19 && Lvl < 25) GivePlayerXP(playerid, 4000/4*DeathmatchStats[dmid][dm_playercount],1);
			else if(Lvl > 24 && Lvl < 30) GivePlayerXP(playerid, 5000/4*DeathmatchStats[dmid][dm_playercount],1);
			else if(Lvl > 29 && Lvl < 35) GivePlayerXP(playerid, 6000/4*DeathmatchStats[dmid][dm_playercount],1);
			else if(Lvl > 34 && Lvl < 40) GivePlayerXP(playerid, 7000/4*DeathmatchStats[dmid][dm_playercount],1);
  }
        else
        {
         format(string, sizeof(string),  lang_texts[4][26] ,Deathmatch[dmid][dm_name],FormatPosition(position),GetPlayerDMScore(playerid,dmid));
   SendClientMessage(playerid,COLOUR_GREEN, string);
   //GivePlayerXP(playerid,Deathmatch[dmid][dm_xpbonus]*(4/position),1);
  }

  if ((GetPlayerDMScore(playerid,dmid) > DMBestScore[dmid][dm_score_record]) || (DMBestScore[dmid][dm_score_record] == 0))
  {
		format(string, sizeof(string),  lang_texts[4][27] ,oGetPlayerName(playerid),Deathmatch[dmid][dm_name],GetPlayerDMScore(playerid,dmid),DMBestScore[dmid][dm_score_record]);
		SendClientMessageToRegistered(COLOUR_DM, string);
		new logstring[256];
		format(logstring, sizeof (logstring), "player: %d:  %s: has set a new record for deathmatch '%s'! Score: %d. Old record: %d.",playerid,oGetPlayerName(playerid),Deathmatch[dmid][dm_name],GetPlayerDMScore(playerid,dmid),DMBestScore[dmid][dm_score_record]);
		WriteLog(logstring);
		oGivePlayerMoney(playerid,(Deathmatch[dmid][dm_cashprize]*3),1);
		//GivePlayerXP(playerid,(Deathmatch[dmid][dm_xpprize]*3),1);
			new Lvl = GetPlayerScore(playerid);
			if(Lvl < 5) GivePlayerXP(playerid, 500*DeathmatchStats[dmid][dm_playercount],1);
			else if(Lvl > 4 && Lvl < 10) GivePlayerXP(playerid, 1000*DeathmatchStats[dmid][dm_playercount],1);
			else if(Lvl > 9 && Lvl < 15) GivePlayerXP(playerid, 2000*DeathmatchStats[dmid][dm_playercount],1);
			else if(Lvl > 14 && Lvl < 20) GivePlayerXP(playerid, 3000*DeathmatchStats[dmid][dm_playercount],1);
			else if(Lvl > 19 && Lvl < 25) GivePlayerXP(playerid, 4000*DeathmatchStats[dmid][dm_playercount],1);
			else if(Lvl > 24 && Lvl < 30) GivePlayerXP(playerid, 5000*DeathmatchStats[dmid][dm_playercount],1);
			else if(Lvl > 29 && Lvl < 35) GivePlayerXP(playerid, 6000*DeathmatchStats[dmid][dm_playercount],1);
			else if(Lvl > 34 && Lvl < 40) GivePlayerXP(playerid, 7000*DeathmatchStats[dmid][dm_playercount],1);
		DMBestScore[dmid][dm_score_record] = GetPlayerDMScore(playerid,dmid);
		DMBestScore[dmid][dm_score_kills] = DMPlayerStats[playerid][dm_player_kills];
		DMBestScore[dmid][dm_score_deaths] = DMPlayerStats[playerid][dm_player_deaths];
		set(DMBestScore[dmid][dm_score_player],oGetPlayerName(playerid));
		DeathmatchSaveRecordDB(dmid);
  }
  }

  PlayerLeaveDM(playerid,dmid);
}

GetDMStat(dmid,playerid)
{
new str[48];
if(dmid < 1){return str;}
if(Deathmatch[dmid][dm_type] == 1)
{
if(DMPlayerStats[playerid][dm_player_role] == DM_ROLE_ZOMBIE)
{
	format(str,sizeof(str),"~r~zombie ~n~~w~living ~y~human ~y~%d", HumanCount[dmid]);
} else {
	format(str,sizeof(str),"~y~human ~n~~w~living ~y~human ~y~%d", HumanCount[dmid]);
}
}
else if(Deathmatch[dmid][dm_team] == 1)
{
format(str,sizeof(str),"~p~dm ~w~%d ~n~~r~%d ~w~: ~b~%d ",dmid,TeamStats[dmid][0][team_Score],TeamStats[dmid][1][team_Score]);
}
else
{
format(str,sizeof(str),"~r~dm ~w~%d ~n~~r~score ~w~%d ",dmid,DMPlayerStats[playerid][dm_player_kills] - DMPlayerStats[playerid][dm_player_deaths]);
}
return str;
}

PlayerLeaveDM(playerid,dmid)
{
 new string[MAX_STRING];
 ResetQuest(playerid);  // reset checkpoints
 DeathmatchStats[dmid][dm_playercount]--;
 speed_PlayerLeaveDM(playerid);
 
 if(Deathmatch[dmid][dm_team] == 1)
 {
 PlayerLeaveTeam(dmid,playerid);
 }
 
	if (!IsPlayerConnected(playerid))
	{
 		if (DMPlayerStats[playerid][dm_player_active])
 		{
  			if(Deathmatch[dmid][dm_type] == 1)
  			{
    			GangZoneHideForPlayer(playerid,Zone[dmid]);
    			Delete3DTextLabel( DMPlayerStats[playerid][dm_player_3dtext] );
    			// Сделать систему бана за покидания зомби выживании
    			Player[playerid][EventBan] = 1800;
    			if( DMPlayerStats[playerid][dm_player_role] == DM_ROLE_ZOMBIE )
				{
	    			togglePlayerMapIconVisibility(playerid,true);
	    			if(HumanCount[dmid] != 0) { SetPlayerDMZombieRole(dmid); }
				}
    			//
    			if( DMPlayerStats[playerid][dm_player_role] == DM_ROLE_HUMAN ) { HumanCount[dmid]--; }
  			}
  		}
 		DMResetPlayerStats(playerid);
 		DeathmatchStats[dmid][dm_playercount]--;
    	format(string, sizeof(string),  lang_texts[4][31] , oGetPlayerName(playerid),DeathmatchStats[dmid][dm_playercount]);
  		SendMessageToDMPlayers(dmid,string,COLOUR_GREY);
	 	return;
	}
 
 if(Deathmatch[dmid][dm_team] == 1)
 {
 SetPlayerColour(playerid,PlayerGangColour(playerid));
 }
 
 if (DeathmatchStats[dmid][dm_state] == DM_STATE_LINEUP)
 {
     if (Deathmatch[dmid][dm_minplayers] > 1)
     {
    format(string, sizeof(string),  lang_texts[4][28] , oGetPlayerName(playerid),DeathmatchStats[dmid][dm_playercount],Deathmatch[dmid][dm_minplayers]);
            new logstring[256];
   format(logstring, sizeof (logstring), "player: %d:  %s: has left the dm. (Players:%d/%d)",playerid,oGetPlayerName(playerid),DeathmatchStats[dmid][dm_playercount],Deathmatch[dmid][dm_minplayers]);
      WriteLog(logstring);
  }
    else
    {
     format(string, sizeof(string),  lang_texts[4][29] , oGetPlayerName(playerid),DeathmatchStats[dmid][dm_playercount]);
            new logstring[256];
   format(logstring, sizeof (logstring), "player: %d:  %s: has left the dm. (Players:%d)",playerid,oGetPlayerName(playerid),DeathmatchStats[dmid][dm_playercount]);
      WriteLog(logstring);
  }
  SendMessageToDMPlayers(dmid,string,COLOUR_GREY);
  //oGivePlayerMoney(playerid,Deathmatch[dmid][dm_cashentry],1); // give player back thier cash entry
  GameTextForPlayer(playerid, "~r~Deathmatch Aborted.",5000,6);
  SetPlayerChatBubble(playerid, "Покинул к десматч", COLOR_RED, 20.0, 2000);
  SendPlayerFormattedText(playerid,  lang_texts[4][30] , 0,COLOUR_RED);
 }
 else
 {
  format(string, sizeof(string),  lang_texts[4][31] , oGetPlayerName(playerid),DeathmatchStats[dmid][dm_playercount]);
  SendMessageToDMPlayers(dmid,string,COLOUR_GREY);
        new logstring[256];
  format(logstring, sizeof (logstring), "player: %d:  %s: has left the dm. (Players:%d)",playerid,oGetPlayerName(playerid),DeathmatchStats[dmid][dm_playercount]);
     WriteLog(logstring);
  SendPlayerFormattedText(playerid,  lang_texts[4][32] , 0,COLOUR_RED);
 }
  if (DMPlayerStats[playerid][dm_player_active])
  {
	if(Deathmatch[dmid][dm_type] == 1)
	{
		GangZoneHideForPlayer(playerid,Zone[dmid]);
		Delete3DTextLabel( DMPlayerStats[playerid][dm_player_3dtext] );
		// Сделать систему бана за покидания зомби выживании
		if(DeathmatchStats[dmid][dm_state] != DM_STATE_SLEEPING) { Player[playerid][EventBan] = 1800; }
		if( DMPlayerStats[playerid][dm_player_role] == DM_ROLE_ZOMBIE )
		{
			togglePlayerMapIconVisibility(playerid,true);
			if(HumanCount[dmid] != 0) { SetPlayerDMZombieRole(dmid); }
		}
		//
	 	if( DMPlayerStats[playerid][dm_player_role] == DM_ROLE_HUMAN ) { HumanCount[dmid]--; }
	 }
  ResetPlayerDMWeapons(playerid);
  PlayerJustTeleported[playerid]+=5;
  //SetPlayerPosEx(playerid,DMStartCP[dmid][Coord_X], DMStartCP[dmid][Coord_Y], DMStartCP[dmid][Coord_Z]);
  OnPlayerSpawn(playerid);

  SetPlayerInterior(playerid,0);
  oSetPlayerVirtualWorld(playerid,0);
  oSetPlayerHealth(playerid,GetMaxHealth(playerid)); // set health based on level
  oDisablePlayerCheckpoint(playerid);
  GivePlayerOwnedWeapons(playerid);
  SetPlayerTeam(playerid, 255);
  }
 
 //DeathmatchStats[dmid][dm_allkills] -= DMPlayerStats[playerid][dm_player_kills];
 //new tmp_kills = 0;
 //if(!crush) {tmp_kills = DMPlayerStats[playerid][dm_player_kills];}
 
 DMResetPlayerStats(playerid);
 
 //DMPlayerStats[playerid][dm_player_kills] = tmp_kills;
}
/*
SendPlayerDMWeapons(playerid,dmid)
{
 ResetPlayerWeapons(playerid);
 new string[MAX_STRING];
 new weapons[MAX_DMWEAPONS+1];
 set(weapons,Deathmatch[dmid][dm_weapons]);
 if (strlen(weapons) <= 7)
 {
  set(string,"Deathmatch weapons: ");
  for (new i=0;i<strlen(weapons);i++)
  {
      if (weapons[i] == 0)  break;
         if (i>0) strins(string, ", ", strlen(string));
   strins(string, GetWeaponName(weapons[i]), strlen(string));
  }
  SendClientMessage(playerid,COLOUR_GREY, string);
    }
 else
 {
  SendPlayerScrollingText(playerid, lang_texts[4][33] );
  for (new i=0;i<strlen(weapons);i++)
  {
         if (weapons[i] == 0)  break;
         if (i>0) strins(string, ", ", strlen(string));

   strins(string, GetWeaponName(weapons[i]), strlen(string));
   SendPlayerScrollingText(playerid,string);
  }
 }
}
*/

PlayerLeaveTeam(dmid,playerid)
{
if(Deathmatch[dmid][dm_team] == 0) {return 0;}
if(DMPlayerStats[playerid][dm_player_team] == -1) {return 0;}
new team = DMPlayerStats[playerid][dm_player_team];
TeamStats[dmid][team][team_pCount]--;
DMPlayerStats[playerid][dm_player_team] = -1;
SetPlayerTeam(playerid, 255);
return 1;
}

GivePlayerDMWeapons(playerid,dmid)
{
	new weapons[MAX_DMWEAPONS+1];
	set(weapons,Deathmatch[dmid][dm_weapons]);
	ResetPlayerWeapons(playerid);
	if(Deathmatch[dmid][dm_type] == 1)
	{
	    GivePlayerWeapon(playerid,weapons[random(sizeof(weapons))],500); // Первый набор
	    GivePlayerWeapon(playerid,weapons[random(sizeof(weapons))],500); // Второй набор
	    GivePlayerWeapon(playerid,weapons[random(sizeof(weapons))],500); // Третий набор
	} else {
		for (new i=0;i<strlen(weapons);i++)
		{
			if (weapons[i] == 0)  break;
			new ammo = GetWeaponMaxAmmo(weapons[i]);
			GivePlayerWeapon(playerid,weapons[i],ammo);
			PlayerTempWeapons[playerid][i] = 1;
		}
	}
}

ResetPlayerDMWeapons(playerid)
{
 ResetPlayerWeapons(playerid);
 for (new i=0;i<MAX_WEAPONS;i++)
 {
  PlayerTempWeapons[playerid][i] = 0;
 }
}

SendMessageToDMPlayers(dmid,string[],colour,team = -1) // 0,1 teams - if dm is tdm, -1 for all players in any dm type
{
 for (new dmplayerid=0; dmplayerid<MAX_PLAYERS;dmplayerid++)
 {
     if (!IsPlayerConnected(dmplayerid)) continue;
     if (PlayerQuest[dmplayerid] == GetDMQuestID(dmid)) // if player is in this dm
    {
	 if(team == -1) {SendPlayerFormattedText(dmplayerid, string, 0,colour); continue;}
	 if(Deathmatch[dmid][dm_team] == 1 && DMPlayerStats[dmplayerid][dm_player_team] == team)
	 {SendPlayerFormattedText(dmplayerid, string, 0,colour);}
	}
 }
}

IsPlayerInDM(playerid,dmid)
{
 if (dmid == INVALID_DM_ID) return 0;
 if (!IsPlayerConnected(playerid)) return 0;
 if (PlayerQuest[playerid] != GetDMQuestID(dmid)) return 0; 
 return 1;
}

IsPlayerInAnyDM(playerid)
{
 new dmid = GetPlayerDM(playerid);
 if (dmid == INVALID_DM_ID) return 0;
 if (DMPlayerStats[playerid][dm_player_active] == 0) return 0; // if we are not spawned in dm zone then we are not actualy active in dm
 return 1;
}

IsPlayerActiveInDM(playerid)
{
return DMPlayerStats[playerid][dm_player_active];
}

DMResetPlayerStats(playerid)
{
 DMPlayerStats[playerid][dm_player_active] = 0;
 DMPlayerStats[playerid][dm_player_kills] = 0;
 DMPlayerStats[playerid][dm_player_deaths] = 0;
 DMPlayerStats[playerid][dm_player_gotcentre] = 0;
 DMPlayerStats[playerid][dm_player_outzone] = 0;
 DMPlayerStats[playerid][dm_player_team] = -1;
 DMPlayerStats[playerid][dm_player_role] = 0;
 SetPlayerTeam(playerid, 255);
 }

GetPlayerDMScore(playerid,dmid)
{
 if (!IsPlayerInDM(playerid,dmid)) return 0;
 new score;
 score = DMPlayerStats[playerid][dm_player_kills] - DMPlayerStats[playerid][dm_player_deaths];
 if (score < 0) score = 0;
 return score;
}

GetDMColourForPlayer(playerid,dmid)
{
 new colour;
 // if (DeathmatchStats[dmid][dm_playercount] >= Deathmatch[dmid][dm_minplayers]-1)
 // {
  // colour = COLOUR_DM;
 // }
 // else if (DeathmatchStats[dmid][dm_playercount] < (Deathmatch[dmid][dm_minplayers]-1))
 // {
  // colour = COLOUR_DM_BAD;
 // }
 if (GetPlayerLevel(playerid) < Deathmatch[dmid][dm_minlevel])
 {
 if(Deathmatch[dmid][dm_type] == 1) { colour = COLOUR_CRIMSON;}
 else if(Deathmatch[dmid][dm_team] == 1) { colour = COLOUR_TDM_BAD;}
 else { colour = COLOUR_DM_BAD;}
 } else {
 if(Deathmatch[dmid][dm_type] == 1) { colour = COLOUR_CRIMSON; }
 else if(Deathmatch[dmid][dm_team] == 1) { colour = COLOUR_TDM; }
 else { colour = COLOUR_DM; }
 }
 return colour;
}

SendPlayerCurrentDeathmatches(playerid)
{
 if (!IsPlayerConnected(playerid)) return;
 new string[MAX_STRING];
 new dmfound;
 for (new dmid=1; dmid<=DMCount;dmid++)
 {
     if ((DeathmatchStats[dmid][dm_state] == DM_STATE_LINEUP) || (DeathmatchStats[dmid][dm_state] == DM_STATE_ACTIVE))
     {
         if (dmfound == 0)
         {
          SendPlayerFormattedText(playerid,  lang_texts[4][34] , 0,COLOUR_DM);
          dmfound++;
         }
         if (DeathmatchStats[dmid][dm_playercount] >= Deathmatch[dmid][dm_minplayers])
         {
             format(string, sizeof(string),  lang_texts[4][35] ,Deathmatch[dmid][dm_name],dmid,DeathmatchStats[dmid][dm_playercount],GetDMStartZoneName(dmid), Deathmatch[dmid][dm_minlevel], Deathmatch[dmid][dm_cashentry]);
   }
   else 
   {
    format(string, sizeof(string),  lang_texts[4][36] ,Deathmatch[dmid][dm_name],dmid,DeathmatchStats[dmid][dm_playercount],Deathmatch[dmid][dm_minplayers],GetDMStartZoneName(dmid), Deathmatch[dmid][dm_minlevel], Deathmatch[dmid][dm_cashentry]);
   }
      SendPlayerFormattedText(playerid, string, 0,GetDMColourForPlayer(playerid,dmid));
     }
     else if (IsPlayerAdmin(playerid))
     {
         if (strlen(Deathmatch[dmid][dm_name]) > 0)
         {
       format(string, sizeof(string),  lang_texts[4][37] ,Deathmatch[dmid][dm_name],dmid, Deathmatch[dmid][dm_minlevel], Deathmatch[dmid][dm_cashentry]);
             SendPlayerFormattedText(playerid, string, 0,COLOUR_RED);
   }
     }
 }
 if (dmfound == 0)
 {
  SendPlayerFormattedText(playerid,  lang_texts[4][38] , 0,COLOUR_RED);
 }
}

GetPlayerDM(playerid)
{
 if (!IsPlayerConnected(playerid)) return 0;
 for (new dmid=1; dmid<=DMCount;dmid++)
 {
     if (DeathmatchStats[dmid][dm_state] == DM_STATE_DISABLED) continue;
     if (PlayerQuest[playerid] == GetDMQuestID(dmid)) // if player is in this dm
     {
         return dmid;
  }
 }
 return 0;
}

//------------------------------------------------------------------------------------------------------------------------------------------------------
//=============================================================================================================================//
// stock oGetDMName(dmid)
// {
// new name = Deathmatch[dmid][dm_name];
// return name;
// }
//=============================================================================================================================//
//------------------------------------------------------------------------------------------------------------------------------------------------------

GetDMQuestID(dmid)
{
 return DeathmatchStats[dmid][dm_questid];
}


//----------------------------------------
/*
Float:GetDMCPX(dmid)
{
 return DMStartCP[dmid][Coord_X];
}
Float:GetDMCPY(dmid)
{
 return DMStartCP[dmid][Coord_Y];
}
Float:GetDMCPZ(dmid)
{
 return DMStartCP[dmid][Coord_Z];
}
*/
//--------------------------------------
GetDMStartZoneName(dmid)
{
 new zone[MAX_NAME];
 zone = GetXYZZoneName(GetDMCPX(dmid),GetDMCPY(dmid),GetDMCPZ(dmid));
 return zone;
}

GetDMWinner(dmid)
{
 new winnerid=INVALIDX_PLAYER_ID;
 new winnerscore;
 for (new playerid=0; playerid<MAX_PLAYERS;playerid++)
 {
  if (!IsPlayerConnected(playerid)) continue;
     if (PlayerQuest[playerid] == GetDMQuestID(dmid)) // if player is in this dm
     {
         if (DMPlayerStats[playerid][dm_player_kills] - DMPlayerStats[playerid][dm_player_deaths] > winnerscore)
         {
             winnerid = playerid;
             winnerscore = DMPlayerStats[playerid][dm_player_kills] - DMPlayerStats[playerid][dm_player_deaths];
         }
     }
 }
 return winnerid;
}


UpdateDMScore(dmid)
{
 new winnerid = GetDMWinner(dmid);
 if (winnerid != INVALIDX_PLAYER_ID)
 {
     new string[MAX_STRING];
     format(string, sizeof(string),  lang_texts[4][39] ,oGetPlayerName(winnerid),DMPlayerStats[winnerid][dm_player_kills],DMPlayerStats[winnerid][dm_player_deaths]);
  SendMessageToDMPlayers(dmid,string,COLOUR_DM);
 }
}

MakeDMSleepTime(dmid)
{
 new sleeptime;
 if (Deathmatch[dmid][dm_frequency] == 0) Deathmatch[dmid][dm_frequency] = 5;
 sleeptime = ((Deathmatch[dmid][dm_frequency] * DMCount) * 125);
 return sleeptime;
}

IsWeaponAllowedInDM(weaponid,dmid)
{
 if (weaponid == 0) return 1; //unarmed always allowed
 new weapons[MAX_DMWEAPONS+1];
 set(weapons,Deathmatch[dmid][dm_weapons]);
 for (new i=0;i<strlen(weapons);i++)
 {
     if (weapons[i] == weaponid) return 1;
 }
 return 0;
}

public OnPlayerDMKill(playerid,victimid,weaponid)
{

// check gang kill
//if (PlayerGangID[killerid] != -1)
 //{
 //    if (GangKill(PlayerGangID[killerid],killerid,victimid,reason) == 1) return;
 //}

 Player[playerid][Kills]++;
 PlayerCurrentKills[playerid]++;
 
 new dmid = GetPlayerDM(playerid);
 if ((dmid == INVALID_DM_ID) || (!IsPlayerInDM(playerid,dmid)))
 {
   DMResetPlayerStats(playerid);
  return; // player not in a dm
 }
 if (IsWeapon(weaponid))
 {
  if (!IsWeaponAllowedInDM(weaponid,dmid))
  {
      KickPlayer(playerid,"Неизвестный тип оружия на ДМ");
      return;
  }
 }
 
 if (GetPlayerDM(victimid) != dmid)
 {
     new string[MAX_STRING];
  format(string, sizeof(string),  lang_texts[4][40] ,oGetPlayerName(victimid));
  SendMessageToDMPlayers(dmid,string,COLOUR_DM);
 }
 DMPlayerStats[playerid][dm_player_kills]++;
 //DeathmatchStats[dmid][dm_allkills]++; // Remove
 
 if(Deathmatch[dmid][dm_team] == 1)
 {
 OnPlayerTeamKill(playerid,victimid,dmid);
} 
else
{
 // Remove
 //if(DMPlayerStats[playerid][dm_player_kills] <= DeathmatchStats[dmid][dm_allkills] - DMPlayerStats[playerid][dm_player_kills]) {GivePlayerXP(playerid,Deathmatch[dmid][dm_xpkill],1,1);}
 //GivePlayerXP(playerid,Deathmatch[dmid][dm_xpkill],1);
  			new Lvl = GetPlayerScore(playerid);
			if(Lvl < 5) GivePlayerXP(playerid, 100 ,1);
			else if(Lvl > 4 && Lvl < 10) GivePlayerXP(playerid, 150 ,1);
			else if(Lvl > 9 && Lvl < 15) GivePlayerXP(playerid, 200 ,1);
			else if(Lvl > 14 && Lvl < 20) GivePlayerXP(playerid, 250 ,1);
			else if(Lvl > 19 && Lvl < 25) GivePlayerXP(playerid, 300 ,1);
			else if(Lvl > 24 && Lvl < 30) GivePlayerXP(playerid, 350 ,1);
			else if(Lvl > 29 && Lvl < 35) GivePlayerXP(playerid, 400 ,1);
			else if(Lvl > 34 && Lvl < 40) GivePlayerXP(playerid, 500 ,1);
 if (GetDMWinner(dmid) == playerid)
 {
  UpdateDMScore(dmid);
    }
    new string[MAX_STRING];
 format(string, sizeof(string),  lang_texts[4][41] ,FormatPosition(GetPlayerDMPosition(playerid,dmid)),DMPlayerStats[playerid][dm_player_deaths],DMPlayerStats[playerid][dm_player_kills]);
 PlayerPlaySound(playerid,1056,GetPlayerX(playerid),GetPlayerY(playerid),GetPlayerZ(playerid));
    GameTextForPlayer(playerid, string,3000,6);
	}
}

public OnPlayerDMDeath(playerid,killerid)
{
 new string[MAX_STRING];
 Player[playerid][Deaths]++;
 PlayerCurrentKills[playerid] = 0;
 if (oGetPlayerHealth(killerid) > 100)
 {
       KickPlayer(killerid,"Invalid health amount. (cheat?)");
 }
 
 new dmid = GetPlayerDM(playerid);
 if ((dmid == INVALID_DM_ID) || (!IsPlayerInDM(playerid,dmid)))
 {
   DMResetPlayerStats(playerid);
   return; // player not in a dm
 }
 DMPlayerStats[playerid][dm_player_deaths]++;
 
 if(Deathmatch[dmid][dm_type] == 1)
 {
    if(DMPlayerStats[playerid][dm_player_role] == DM_ROLE_HUMAN)
    {
        HumanCount[dmid]--;
        DMPlayerStats[playerid][dm_player_role] = DM_ROLE_ZOMBIE;
        SendClientMessage(playerid,COLOUR_RED,  " [Zombie] Вас заразили. Атакуйте выживших!" );
        SetPlayerTeam(playerid,1);
        Update3DTextLabelText(DMPlayerStats[playerid][dm_player_3dtext],COLOUR_CRIMSON,"ЗОМБИ");
    } else {
        SetPlayerTeam(playerid,1);
    }
   	if(HumanCount[dmid] <= 0)
	{
	    EndDM(dmid);
	}
 }
 else if(Deathmatch[dmid][dm_team] == 1)
 {
 //new str[MAX_NAME];
//DMPlayerSpawn(playerid,dmid); // no double spawn
//format(str, sizeof(str), "~r~%d | ~b~%d", TeamStats[dmid][0][team_Score], TeamStats[dmid][1][team_Score]);
PlayerPlaySound(playerid,1057,GetPlayerX(playerid),GetPlayerY(playerid),GetPlayerZ(playerid));
//GameTextForPlayer(playerid, string,3000,6);
 }
 else{
 //GivePlayerXP(playerid,0-Deathmatch[dmid][dm_xpdeath],1);
 //DMPlayerSpawn(playerid,dmid); // no double spawn
 format(string, sizeof(string),  lang_texts[4][42] ,FormatPosition(GetPlayerDMPosition(playerid,dmid)),DMPlayerStats[playerid][dm_player_deaths],DMPlayerStats[playerid][dm_player_kills]);
 PlayerPlaySound(playerid,1057,GetPlayerX(playerid),GetPlayerY(playerid),GetPlayerZ(playerid));
    GameTextForPlayer(playerid, string,3000,6);
	}
}


public OnPlayerEnterDMCheckpoint(playerid)
{
 new playerdmid = GetPlayerDM(playerid);
 new string[MAX_STRING];
 new rnd;
 for (new dmid=1; dmid<=DMCount;dmid++) //  for each dm
 {
     if (DeathmatchStats[dmid][dm_state] == DM_STATE_DISABLED) break;
  
     if (DeathmatchStats[dmid][dm_state] == DM_STATE_LINEUP)
  {
      if (PlayerQuest[playerid] == 0) // if player not on a quest
      {
      // if player at startline
    if (oIsPlayerInCheckpoint(playerid,GetDMCPX(dmid),GetDMCPY(dmid),GetDMCPZ(dmid),DMCPSize*3))
    {
     JoinDM(playerid,dmid);
    }
   }
   else if (playerdmid == dmid)
   {
    if (oIsPlayerInCheckpoint(playerid,GetDMCPX(dmid),GetDMCPY(dmid),GetDMCPZ(dmid),DMCPSize*3))
    {
     format(string,sizeof(string), lang_texts[4][43] ,(Deathmatch[dmid][dm_lineupdelay] - DeathmatchStats[dmid][dm_timer]));
     SendClientMessage(playerid,COLOUR_GREEN, string);
    }
   }
  }
  else if (DeathmatchStats[dmid][dm_state] == DM_STATE_ACTIVE)
  {
      if (PlayerQuest[playerid] == 0) // if player not on a quest
      {
      // if player at startline
    if (oIsPlayerInCheckpoint(playerid,GetDMCPX(dmid),GetDMCPY(dmid),GetDMCPZ(dmid),DMCPSize*3))
    {
     //JoinDM(playerid,dmid);
     format(string,sizeof(string), lang_texts[4][44] ,Deathmatch[dmid][dm_name],dmid);
     SendClientMessage(playerid,COLOUR_GREEN, string);
    }
   }
   else if (playerdmid == dmid)
   {
    if (oIsPlayerInCheckpoint(playerid,GetDMCPX(dmid),GetDMCPY(dmid),GetDMCPZ(dmid),DMCPSize*3))
    {
	
	if(Deathmatch[dmid][dm_team] == 1)
	  {
	  if(TeamStats[dmid][0][team_pCount] > TeamStats[dmid][1][team_pCount])
	  {
	  DMPlayerStats[playerid][dm_player_team] = 1;
	  TeamStats[dmid][1][team_pCount]++;
	  }
	  else if(TeamStats[dmid][0][team_pCount] < TeamStats[dmid][1][team_pCount])
	  {
	  DMPlayerStats[playerid][dm_player_team] = 0;
	  TeamStats[dmid][0][team_pCount]++;
	  }
	  else if(TeamStats[dmid][0][team_pCount] == TeamStats[dmid][1][team_pCount])
	  {
	  rnd = random(MAX_TEAMS);
	  DMPlayerStats[playerid][dm_player_team] = rnd;
	  TeamStats[dmid][rnd][team_pCount]++;
	  }
	  }
	  
     DMPlayerSpawn(playerid,dmid);
     format(string, sizeof(string), "GO!");
     PlayerPlaySound(playerid,1057,GetPlayerX(playerid),GetPlayerY(playerid),GetPlayerZ(playerid));
        GameTextForPlayer(playerid, string,1000,6);
    }
    else if (DMPlayerStats[playerid][dm_player_gotcentre] == 0) // && Deathmatch[dmid][dm_team] == 0)
    {
     if (oIsPlayerInCheckpoint(playerid,DMCentreCP[dmid][Coord_X],DMCentreCP[dmid][Coord_Y],DMCentreCP[dmid][Coord_Z],DMCPSize*3))
     {
         //new xpbonus = Deathmatch[dmid][dm_xpprize]/20;
      //format(string,sizeof(string), lang_texts[4][45] ,xpbonus);
      //SendClientMessage(playerid,COLOUR_GREEN,string);
   			new Lvl = GetPlayerScore(playerid);
			if(Lvl < 5) GivePlayerXP(playerid, 75 ,1);
			else if(Lvl > 4 && Lvl < 10) GivePlayerXP(playerid, 75 ,1);
			else if(Lvl > 9 && Lvl < 15) GivePlayerXP(playerid, 80 ,1);
			else if(Lvl > 14 && Lvl < 20) GivePlayerXP(playerid, 80 ,1);
			else if(Lvl > 19 && Lvl < 25) GivePlayerXP(playerid, 90 ,1);
			else if(Lvl > 24 && Lvl < 30) GivePlayerXP(playerid, 90 ,1);
			else if(Lvl > 29 && Lvl < 35) GivePlayerXP(playerid, 100 ,1);
			else if(Lvl > 34 && Lvl < 40) GivePlayerXP(playerid, 100 ,1);
      //GivePlayerXP(playerid,xpbonus,1);
      DMPlayerStats[playerid][dm_player_gotcentre] = 1;
     }
    }
	/*
	else if(Deathmatch[dmid][dm_team] == 1)
	{
	if(oIsPlayerInCheckpoint(playerid,DMCentreCP[dmid][Coord_X],DMCentreCP[dmid][Coord_Y],DMCentreCP[dmid][Coord_Z],DMCPSize*3))
		{
		DMPlayerStats[playerid][dm_player_gotcentre] = 0;
		SendClientMessage(playerid,COLOUR_GREEN,"Вы должны простоять на этой точке 30 секунд чтобы принести 5 очков команде");
		SendMessageToDMPlayers(dmid,"Команда нападающих начала захват точки",COLOUR_LIGHTRED, 1); //to blue team
		}
	}
	*/
   }
  }
 }
}

public DMCommandHandler(playerid,text[]) // process player commands
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

    if((strcomp(cmd, "/deathmatches", true) || (strcomp(cmd, "/dms", true)) == 1))
 {

  SendPlayerCurrentDeathmatches(playerid);
      return 1;
 }

    if(strcomp(cmd, "/dm", true) == 1)
 {
     set(cmd,strcharsplit(text, idx,strchar(" ")));
     if(strcomp(cmd, "help", true) == 1)
  {
   SendPlayerScrollingText(playerid, lang_texts[4][46] );
   SendPlayerScrollingText(playerid, lang_texts[4][47] );
   SendPlayerScrollingText(playerid, lang_texts[4][48] );
   SendPlayerScrollingText(playerid, lang_texts[4][49] );
   SendPlayerScrollingText(playerid, lang_texts[4][50] );
   SendPlayerScrollingText(playerid, lang_texts[4][51] );
   SendPlayerScrollingText(playerid, lang_texts[4][52] );
   SendPlayerScrollingText(playerid, lang_texts[4][53] );
   SendPlayerScrollingText(playerid, lang_texts[4][54] );
   return 1;
  }


// команда запуска ДМ

if(strcomp(cmd, "4me", true) == 1)
{
	if(DM4METime > 0)
	{
	new string[MAX_STRING];
	format(string,sizeof(string), "Команда будет доступна через %d секунд" ,DM4METime*2);
	return SendClientMessage(playerid, COLOUR_CRIMSON, string);
	}

	if(GetPlayerMoney(playerid) < (Player[playerid][Level]*2000)) {SendClientMessage(playerid, 0xFFFFFFFF, " У вас недостаточно средств."); return 1;}
	new summplayers;
	for (new id = 0; id < MAX_PLAYERS; id++)
	{
		if (!IsPlayerConnected(id)){continue;}
		if (!IsPlayerRegistered(id)){continue;}
		if (IsPlayerNPC(id)){continue;}
		
		summplayers++;
		
	}
	if(summplayers < 2) {SendClientMessage(playerid, 0xFFFFFFFF, " Недостаточно он-лайн игроков."); return 1;}

	new allowrc[MAX_DM];// MAX_DM = 50
	new astep = -1;
	new active;

	for(new i=1;i<=DMCount;i++)
	{
		if(DeathmatchStats[i][dm_state] == DM_STATE_LINEUP){active++;}
		if(GetPlayerLevel(playerid) >= Deathmatch[i][dm_minlevel] && DeathmatchStats[i][dm_state] == DM_STATE_SLEEPING)
		{
			if(astep == -1){astep = 0;}
			allowrc[astep] = i;
			astep++;
		}
	}
	if(astep == -1) {SendClientMessage(playerid, 0xFFFFFFFF, " Нет доступных DM =("); return 1;}
	if(active > 3){SendClientMessage(playerid, 0xFFFFFFFF, " Слишком много активных DM!"); return 1;}
	new rid, rrid;
	if(astep != 1){rid = random(astep);}
	oGivePlayerMoney(playerid, (0 - (Player[playerid][Level]*2000)),1);
	rrid = allowrc[rid];
	DeathmatchStats[rrid][dm_timer] = 0;
	//StartDMLineup(rrid);
	DM4METime = DM4METimeMAX;
	return 1;
}

// конец зхапуска DM


     if(strcomp(cmd, "join", true) == 1)
  {
   new dmid;
   dmid = strval(strcharsplit(text, idx,strchar(" ")));
   if (PlayerQuest[playerid] != 0)
   {
    SendPlayerFormattedText(playerid, lang_texts[4][55] , 0,COLOUR_RED);
    return 1;
   }
   if ((dmid == 0) || (dmid >= MAX_DM))
   {
    SendPlayerFormattedText(playerid, lang_texts[4][56] , 0,COLOUR_RED);
    return 1;
   }
   if (DeathmatchStats[dmid][dm_state] == DM_STATE_DISABLED)
   {
    SendPlayerFormattedText(playerid, lang_texts[4][57] , 0,COLOUR_RED);
    return 1;
   }
   if ((DeathmatchStats[dmid][dm_state] != DM_STATE_LINEUP) && (DeathmatchStats[dmid][dm_state] != DM_STATE_ACTIVE))
   {
    SendPlayerFormattedText(playerid, lang_texts[4][58] , 0,COLOUR_RED);
    return 1;
   }

   if ((Deathmatch[dmid][dm_activedmjoin] == 0) && (DeathmatchStats[dmid][dm_state] == DM_STATE_ACTIVE))
   {
    SendPlayerFormattedText(playerid, lang_texts[4][59] , 0,COLOUR_RED);
    return 1;
   }
   JoinDM(playerid,dmid);
       return 1;
  }
  if((strcomp(cmd, "leave", true) == 1) || (strcomp(cmd, "quit", true) == 1))
  {
   if (PlayerQuest[playerid] == 0)
   {
    SendPlayerFormattedText(playerid, lang_texts[4][60] , 0,COLOUR_RED);
    return 1;
   }
   new dmid = GetPlayerDM(playerid);
   if (dmid == 0)
   {
    SendPlayerFormattedText(playerid, lang_texts[4][61] , 0,COLOUR_RED);
    return 1;
   }
   if(Deathmatch[dmid][dm_type] == 1)
   {
    ShowPlayerDialog(playerid,EV_GUI,0,"Зомби-Выживание","Внимание! Если покинете зомби-выживание, то Вы получите временную блокировку на участие в зомби-выживании!\n3600 секунд = 1 час","Выйти","Отмена");
    return 1;
   }
	PlayerLeaveDM(playerid,dmid);
 	return 1;
  }
  /*
  if(strcomp(cmd, "show", true) == 1)
  {
  ShowDMMarkers(playerid);
  return 1;
  }
  
  if(strcomp(cmd, "hide", true) == 1)
  {
  HideDMMarkers(playerid);
  return 1;
  }
  */
  
  
      return 0;
 }
 return 0;
}

DeathmatchLoadAll()
{
    if (ForceOverwrite) return;
 new temp[MAX_STRING];
 if (!dini_Exists(ConfigDB)) dini_Create(ConfigDB);
 set(temp,dini_Get(ConfigDB,"Deathmatch_DB"));
 if (strlen(temp) > 0) set(DeathmatchDB,temp);
 set(temp,dini_Get(ConfigDB,"Deathmatch_Base_DB"));
 if (strlen(temp) > 0) set(DMBaseDB,temp);
 set(temp,dini_Get(ConfigDB,"Deathmatch_Record_DB"));
 if (strlen(temp) > 0) set(DMRecordDB,temp);


 if (!dini_Exists(DeathmatchDB))
 {
  dini_Create(DeathmatchDB);
 }

 for (new dmdbid=0;dmdbid<MAX_DM;dmdbid++)
  { // load all our dms from db
      new cellname[MAX_STRING];
  format(cellname,sizeof(cellname), lang_texts[4][62] ,dmdbid);
  set(temp,dini_Get(DeathmatchDB,cellname));
   if (strlen(temp) == 0) continue;
   if (!DeathmatchBaseDBExists(temp)) continue;
   new dmid = RegisterDM(temp);
   if (dmid == INVALID_DM_ID) continue;
   DeathmatchLoadBaseDB(dmid);
   //DeathmatchLoadRecordDB(dmid);
 }

 return;
}

DeathmatchLoadRecordDBAll()
{
	for (new dmid=1; dmid<=DMCount;dmid++)
	{
    if(DeathmatchStats[dmid][dm_state] == DM_STATE_DISABLED) {continue;}
	DeathmatchLoadRecordDB(dmid);
	}
}

DeathmatchBaseDBExists(dmname[MAX_STRING])
{ 
 new rdbname[MAX_STRING];
 format(rdbname,sizeof(rdbname),"%sGTO.Deathmatch.%s.txt",DMBaseDB,dmname);
 if (!dini_Exists(rdbname))
 {
  return 0;
 }
 return 1;
}

DeathmatchLoadBaseDB(dmid)
{ // load dm from db
 if (ForceOverwrite) return INVALID_DM_ID;
 new temp[MAX_STRING];
 new rdbname[MAX_STRING];
 format(rdbname,sizeof(rdbname),"%sGTO.Deathmatch.%s.txt",DMBaseDB,Deathmatch[dmid][dm_name]);
 if (!dini_Exists(rdbname))
 {
  return INVALID_DM_ID;
 }
 set(temp,dini_Get(rdbname,"Name"));
 if (strlen(temp) > 0) set(Deathmatch[dmid][dm_name],temp);
  set(temp,nullstr);

 if (dmid <= 0)
 {
     printf("Deathmatch (DB): %s Failed to load", Deathmatch[dmid][dm_name]);
   new logstring[256];
  format(logstring, sizeof (logstring), "Deathmatch (DB): %s Failed to load", Deathmatch[dmid][dm_name]);
     WriteLog(logstring);
  return INVALID_DM_ID;
 }

  set(temp,dini_Get(rdbname,"Frequency"));
  if (strlen(temp) > 0) Deathmatch[dmid][dm_frequency] = strval(temp);
  set(temp,nullstr);

  set(temp,dini_Get(rdbname,"Lineup_Delay"));
  if (strlen(temp) > 0) Deathmatch[dmid][dm_lineupdelay] = strval(temp);
  set(temp,nullstr);

  set(temp,dini_Get(rdbname,"Min_Players"));
  if (strlen(temp) > 0) Deathmatch[dmid][dm_minplayers] = strval(temp);
  set(temp,nullstr);

  set(temp,dini_Get(rdbname,"Min_Level"));
  if (strlen(temp) > 0) Deathmatch[dmid][dm_minlevel] = strval(temp);
  set(temp,nullstr);

  set(temp,dini_Get(rdbname,"Cash_Prize"));
  if (strlen(temp) > 0) Deathmatch[dmid][dm_cashprize] = strval(temp);
  set(temp,nullstr);

  set(temp,dini_Get(rdbname,"Cash_Entry"));
  if (strlen(temp) > 0) Deathmatch[dmid][dm_cashentry] = strval(temp);
  set(temp,nullstr);

  set(temp,dini_Get(rdbname,"XP_Prize"));
  if (strlen(temp) > 0) Deathmatch[dmid][dm_xpprize] = strval(temp);
  set(temp,nullstr);

  set(temp,dini_Get(rdbname,"XP_Bonus"));
  if (strlen(temp) > 0) Deathmatch[dmid][dm_xpbonus] = strval(temp);
  set(temp,nullstr);

  set(temp,dini_Get(rdbname,"Max_Time"));
  if (strlen(temp) > 0) Deathmatch[dmid][dm_maxtime] = strval(temp);
  set(temp,nullstr);

  set(temp,dini_Get(rdbname,"XP_Kill"));
  if (strlen(temp) > 0) Deathmatch[dmid][dm_xpkill] = strval(temp);
  set(temp,nullstr);

  set(temp,dini_Get(rdbname,"XP_Death"));
  if (strlen(temp) > 0) Deathmatch[dmid][dm_xpdeath] = strval(temp);
  set(temp,nullstr);
  
  set(temp,dini_Get(rdbname,"Join_Active"));
  if (strlen(temp) > 0) Deathmatch[dmid][dm_activedmjoin] = strval(temp);
  set(temp,nullstr);

  set(temp,dini_Get(rdbname,"Max_Distance"));
  if (strlen(temp) > 0) Deathmatch[dmid][dm_distance] = strval(temp);
  set(temp,nullstr);
  
  set(temp,dini_Get(rdbname,"Weapons"));
  if (strlen(temp) > 0) set(Deathmatch[dmid][dm_weapons],DMDecodeWeaponsDB(temp));
  set(temp,nullstr);

  new Float:X;
  new Float:Y;
  new Float:Z;

  set(temp,dini_Get(rdbname,"Start_CP"));
  if (strlen(temp) != 0)
  {
      new idx=0;
    X= floatstr(strcharsplit(temp,idx,strchar(",")));
   Y = floatstr(strcharsplit(temp,idx,strchar(",")));
   Z = floatstr(strcharsplit(temp,idx,strchar(",")));
   set(temp,nullstr);
   if (( X!= 0.0) || (Y != 0.0))
   {
   DMStartCP[dmid][Coord_X] = X;
   DMStartCP[dmid][Coord_Y] = Y;
   DMStartCP[dmid][Coord_Z] = Z;
    X= 0.0;
   Y = 0.0;
   Z = 0.0;
  }
 }
 
 set(temp,dini_Get(rdbname,"Centre_CP"));
  if (strlen(temp) != 0)
  {
      new idx=0;
    X= floatstr(strcharsplit(temp,idx,strchar(",")));
   Y = floatstr(strcharsplit(temp,idx,strchar(",")));
   Z = floatstr(strcharsplit(temp,idx,strchar(",")));
   set(temp,nullstr);
   if (( X!= 0.0) || (Y != 0.0))
   {
   DMCentreCP[dmid][Coord_X] = X;
   DMCentreCP[dmid][Coord_Y] = Y;
   DMCentreCP[dmid][Coord_Z] = Z;
    X= 0.0;
   Y = 0.0;
   Z = 0.0;
  }
 }

  new spsize;
  for (new spid=0;spid<MAX_DM_SP;spid++)
  {
      new cellname[MAX_STRING];
  format(cellname,sizeof(cellname), lang_texts[4][63] ,spid);
  set(temp,dini_Get(rdbname,cellname));
   if (strlen(temp) == 0) break;
   new idx=0;
    X= floatstr(strcharsplit(temp,idx,strchar(",")));
   Y = floatstr(strcharsplit(temp,idx,strchar(",")));
   Z = floatstr(strcharsplit(temp,idx,strchar(",")));
   set(temp,nullstr);
   if (( X== 0.0) && (Y == 0.0)) break;
  DMSpawnPoints[dmid][spid][Coord_X] = X;
  DMSpawnPoints[dmid][spid][Coord_Y] = Y;
  DMSpawnPoints[dmid][spid][Coord_Z] = Z;
  spsize++;
 }

 DMSpawnsSize[dmid] = spsize;
 DeathmatchStats[dmid][dm_state] = DM_STATE_SLEEPING;
 DeathmatchStats[dmid][dm_timer] = MakeDMSleepTime(dmid);
   printf("Deathmatch (DB): '%s' Loaded.",Deathmatch[dmid][dm_name]);
    new logstring[256];
 format(logstring, sizeof (logstring), "Deathmatch (DB): %s loaded", Deathmatch[dmid][dm_name]);
    WriteLog(logstring);
  return dmid;
}

DeathmatchLoadRecordDB(dmid)
{
 new rdbname[MAX_STRING];
 new temp[MAX_STRING];
  format(rdbname,sizeof(rdbname),"%sGTO.Deathmatch.Record.%s.txt",DMRecordDB,Deathmatch[dmid][dm_name]);
  if (!dini_Exists(rdbname)) return;
 set(temp,dini_Get(rdbname,"Best_Score_Record"));
 if (strlen(temp) > 0) DMBestScore[dmid][dm_score_record] = strval(temp);
 set(temp,nullstr);
 set(temp,dini_Get(rdbname,"Best_Score_Player"));
 if (strlen(temp) > 0) set(DMBestScore[dmid][dm_score_player],temp);
 set(temp,nullstr);
	set(temp,dini_Get(rdbname,"Best_Score_Kills"));
	if (strlen(temp) > 0) DMBestScore[dmid][dm_score_kills] = strval(temp);
 set(temp,nullstr);
 set(temp,dini_Get(rdbname,"Best_Score_Deaths"));
 if (strlen(temp) > 0) DMBestScore[dmid][dm_score_deaths] = strval(temp);
 set(temp,nullstr);
}

DeathmatchSaveAll()
{
 if (!dini_Exists(ConfigDB)) dini_Create(ConfigDB);
 dini_Set(ConfigDB,"Deathmatch_Base_DB",DMBaseDB);
 dini_Set(ConfigDB,"Deathmatch_Record_DB",DMRecordDB);

 if (!dini_Exists(DeathmatchDB)) dini_Create(DeathmatchDB);
 for (new dmid=1;dmid<=DMCount;dmid++)
  { // load all our dms from db
      if (DeathmatchStats[dmid][dm_state] == DM_STATE_DISABLED) continue;
      new cellname[MAX_STRING];
  format(cellname,sizeof(cellname), lang_texts[4][64] ,dmid);
  dini_Set(DeathmatchDB,cellname,Deathmatch[dmid][dm_name]);

   DeathmatchSaveBaseDB(dmid);
   DeathmatchSaveRecordDB(dmid);
 }
}

stock DeathmatchSaveScores()
{
 if (!dini_Exists(ConfigDB)) dini_Create(ConfigDB);
 dini_Set(ConfigDB,"Deathmatch_Base_DB",DMBaseDB);
 dini_Set(ConfigDB,"Deathmatch_Record_DB",DMRecordDB);

 if (!dini_Exists(DeathmatchDB)) dini_Create(DeathmatchDB);
 for (new dmid=1;dmid<=DMCount;dmid++)
  { // load all our dms from db
      if (DeathmatchStats[dmid][dm_state] == DM_STATE_DISABLED) continue;
      new cellname[MAX_STRING];
  format(cellname,sizeof(cellname), lang_texts[4][65] ,dmid);
  dini_Set(DeathmatchDB,cellname,Deathmatch[dmid][dm_name]);
   DeathmatchSaveRecordDB(dmid);
 }
}

DeathmatchSaveBaseDB(dmid)
{ // save dm to db
 if (DeathmatchStats[dmid][dm_state] == DM_STATE_DISABLED) return;
 new temp[MAX_STRING];
 new rdbname[MAX_STRING];
 format(rdbname,sizeof(rdbname),"%sGTO.Deathmatch.%s.txt",DMBaseDB,Deathmatch[dmid][dm_name]);
 if (!dini_Exists(rdbname))
 {
  dini_Create(rdbname);
 }
 dini_Set(rdbname,"Name",Deathmatch[dmid][dm_name]);

 valstr(temp,Deathmatch[dmid][dm_frequency]);
  dini_Set(rdbname,"Frequency",temp);
  set(temp,nullstr);

 valstr(temp,Deathmatch[dmid][dm_lineupdelay]);
  dini_Set(rdbname,"Lineup_Delay",temp);
  set(temp,nullstr);

 valstr(temp,Deathmatch[dmid][dm_minplayers]);
  dini_Set(rdbname,"Min_Players",temp);
  set(temp,nullstr);

 valstr(temp,Deathmatch[dmid][dm_minlevel]);
  dini_Set(rdbname,"Min_Level",temp);
  set(temp,nullstr);

 valstr(temp,Deathmatch[dmid][dm_cashprize]);
  dini_Set(rdbname,"Cash_Prize",temp);
  set(temp,nullstr);

 valstr(temp,Deathmatch[dmid][dm_cashentry]);
  dini_Set(rdbname,"Cash_Entry",temp);
  set(temp,nullstr);

  valstr(temp,Deathmatch[dmid][dm_xpprize]);
  dini_Set(rdbname,"XP_Prize",temp);
  set(temp,nullstr);

  valstr(temp,Deathmatch[dmid][dm_xpbonus]);
  dini_Set(rdbname,"XP_Bonus",temp);
  set(temp,nullstr);

  valstr(temp,Deathmatch[dmid][dm_maxtime]);
  dini_Set(rdbname,"Max_Time",temp);
  set(temp,nullstr);

   valstr(temp,Deathmatch[dmid][dm_xpkill]);
  dini_Set(rdbname,"XP_Kill",temp);
  set(temp,nullstr);

  valstr(temp,Deathmatch[dmid][dm_xpdeath]);
  dini_Set(rdbname,"XP_Death",temp);
  set(temp,nullstr);
  
  valstr(temp,Deathmatch[dmid][dm_activedmjoin]);
  dini_Set(rdbname,"Join_Active",temp);
  set(temp,nullstr);
  
  valstr(temp,Deathmatch[dmid][dm_distance]);
  dini_Set(rdbname,"Max_Distance",temp);
  set(temp,nullstr);

  set(temp,DMEncodeWeaponsDB(dmid));
 dini_Set(rdbname,"Weapons",temp);
  set(temp,nullstr);

  format(temp,sizeof(temp), lang_texts[4][66] ,DMStartCP[dmid][Coord_X],DMStartCP[dmid][Coord_Y],DMStartCP[dmid][Coord_Z]);
 dini_Set(rdbname,"Start_CP",temp);
  set(temp,nullstr);
  
  format(temp,sizeof(temp), lang_texts[4][67] ,DMCentreCP[dmid][Coord_X],DMCentreCP[dmid][Coord_Y],DMCentreCP[dmid][Coord_Z]);
 dini_Set(rdbname,"Centre_CP",temp);
  set(temp,nullstr);

  for (new spid=0;spid<DMSpawnsSize[dmid];spid++)
  {
      new cellname[MAX_STRING];
  format(cellname,sizeof(cellname), lang_texts[4][68] ,spid);
  format(temp,sizeof(temp), lang_texts[4][69] ,DMSpawnPoints[dmid][spid][Coord_X],DMSpawnPoints[dmid][spid][Coord_Y],DMSpawnPoints[dmid][spid][Coord_Z]);
  dini_Set(rdbname,cellname,temp);
 }

}

DeathmatchSaveRecordDB(dmid)
{
 new temp[MAX_STRING];
 new rdbname[MAX_STRING];
  format(rdbname,sizeof(rdbname),"%sGTO.Deathmatch.Record.%s.txt",DMRecordDB,Deathmatch[dmid][dm_name]);
 if (!dini_Exists(rdbname)) dini_Create(rdbname);
  dini_Set(rdbname,"Name",Deathmatch[dmid][dm_name]);
  set(temp,nullstr);
  valstr(temp,DMBestScore[dmid][dm_score_record]);
  dini_Set(rdbname,"Best_Score_Record",temp);
  set(temp,nullstr);
  set(temp,DMBestScore[dmid][dm_score_player]);
  dini_Set(rdbname,"Best_Score_Player",temp);
  set(temp,nullstr);
	 valstr(temp,DMBestScore[dmid][dm_score_kills]);
	 dini_Set(rdbname,"Best_Score_Kills",temp);
  set(temp,nullstr);
  valstr(temp,DMBestScore[dmid][dm_score_deaths]);
  dini_Set(rdbname,"Best_Score_Deaths",temp);
  set(temp,nullstr);
 return;
}

DMEncodeWeaponsDB(dmid)
{
 new weps[MAX_DMWEAPONS+1];
 new retstr[MAX_STRING];
 set(weps,Deathmatch[dmid][dm_weapons]);
 for (new i=0;i<strlen(weps);i++)
 {
     if (weps[i] == 0) break;
     new tempstr[10];
     valstr(tempstr,weps[i]);
     strins(retstr,tempstr,strlen(retstr));
  retstr[strlen(retstr)] = '/';
 }
 return retstr;
}

DMDecodeWeaponsDB(wepstr[])
{
 new weps[MAX_DMWEAPONS];
 new tmpwepstr[20];
 new idx;

 for (new i=0;((i<strlen(wepstr)) && (i<MAX_DMWEAPONS));i++)
 {
  set(tmpwepstr,strcharsplit(wepstr, idx,'/'));
  if (strlen(tmpwepstr) == 0) break;
  weps[i] = strval(tmpwepstr);
  if (weps[i] == 0) break;
 }
 //set(Deathmatch[dmid][dm_weapons],weps);
 return weps;
}

stock GetInfoDMLevel(playerid,level)
{
	new string[128];
 	for (new i=0;i<MAX_DM;i++)
 	{
 		if(level == Deathmatch[i][dm_minlevel])
 		{
			format(string, sizeof(string), " Доступен новый десматч: %s (%d)" ,Deathmatch[i][dm_name],i);
			SendClientMessage(playerid, COLOUR_MISC, string);
 		}
 	}
return 1;
}

forward UnFreeze(playerid);

stock SecFreeze(playerid, count = 1)
{
    TogglePlayerControllable(playerid,0);
    SetTimerEx("UnFreeze" , 1000 * count, false, "i", playerid);
	return 1;
}

public UnFreeze(playerid) {TogglePlayerControllable(playerid,1);return 1;}
/*
SetPlayerDMZombieRole(dmid)
{
    new count = 0, dm_player_ids[MAX_PLAYERS], z_count = 0, player = 0;

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        dm_player_ids[i] = 0;
        if(DeathmatchStats[dmid][dm_questid] != PlayerQuest[i]) { continue; }
        if(!DMPlayerStats[i][dm_player_active]) { continue; }
        if(DMPlayerStats[i][dm_player_role] == DM_ROLE_ZOMBIE) { z_count++; }
        dm_player_ids[count] = i;
        count++;
        HumanCount[dmid]++;
        SetPlayerTeam(i,0);
        //printf("Playerid role in DM: %d",DMPlayerStats[i][dm_player_role]);
    }

    //z_count = (count/4 + 1);

    if(count >= DM_MAX_ZOMBIES)
    {
        while(z_count < DM_MAX_ZOMBIES)
        {
            player = dm_player_ids[ random(count) ];
            if( DMPlayerStats[player][dm_player_role] != DM_ROLE_ZOMBIE )
            {
                DMPlayerStats[player][dm_player_role] = DM_ROLE_ZOMBIE;
                z_count++;
                HumanCount[dmid]--;
                SetPlayerTeam(player,1);
            }
        }
    }
}
*/
SetPlayerDMZombieRole(dmid)
{
    new count = 0, dm_player_ids[MAX_PLAYERS], z_count = 0, player = 0;

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        dm_player_ids[i] = 0;
        // only for players who taking part in event
        if(DeathmatchStats[dmid][dm_questid] != PlayerQuest[i]) { continue; }
        // can be apply only for already spawned DM players
        if(!DMPlayerStats[i][dm_player_active]) { continue; }
        // always must not be zombie, for correctly cleared DM
        if(DMPlayerStats[i][dm_player_role] == DM_ROLE_ZOMBIE) { z_count++; }
        dm_player_ids[count] = i;
        count++;
        HumanCount[dmid]++;
        SetPlayerTeam(i,0);
    }

    while(z_count < count/DM_ZOMBIE_RATIO + DM_ZOMBIE_MIN)
    {
        player = dm_player_ids[ random(count) ];
        if( DMPlayerStats[player][dm_player_role] != DM_ROLE_ZOMBIE )
        {
            DMPlayerStats[player][dm_player_role] = DM_ROLE_ZOMBIE;
            z_count++;
            HumanCount[dmid]--;
			//
			Suecid[player] = 1;
			SetPlayerHealth(player,0);
			SendClientMessage(player,COLOUR_RED,  " [Zombie] Система рандома назначала Вас зомби. Атакуйте выживших!" );
			SetPlayerTeam(player,1);
  			if(HumanCount[dmid] <= 0)
			{
	    		EndDM(dmid);
			}
			//
        }
    }
}

public GetPlayerInZombie(playerid,dmid)
{
    new Float:xz,Float:yz,Float:zz;
    GetPlayerPos(playerid, xz, yz, zz);
    if((xz <= GetDMZPXx(dmid) && xz >= GetDMZPX(dmid)) && (yz <= GetDMZPYy(dmid) && yz >= GetDMZPY(dmid))) return 1;
    return 0;
}

//Zone[dmid] = GangZoneCreate(GetDMZPX(dmid),GetDMZPY(dmid),GetDMZPXx(dmid),GetDMZPYy(dmid));

//----------------------------------------------------//
// 3D Text Streamer
/*
forward ShowDMMarkers(playerid);
forward HideDMMarkers(playerid);
//forward UpdateMarkers();

//new PlayerDMMarkersOn[playerid]; // показывать или не показывать маркеры

new PlayerText3D:DM3DTEXT[MAX_PLAYERS][MAX_DM];

public ShowDMMarkers(playerid)
{
new string[128];

for (new dmid=1; dmid<=DMCount;dmid++)
{
format(string,sizeof(string),"DM %d\n%s",dmid,Deathmatch[dmid][dm_name]);
DM3DTEXT[playerid][dmid] = CreatePlayer3DTextLabel(playerid, string, 0xBB0000AA, DMStartCP[dmid][Coord_X], DMStartCP[dmid][Coord_Y], DMStartCP[dmid][Coord_Z], 10000, -1, -1, 0);
}

return 1;
}


public HideDMMarkers(playerid)
{

for (new dmid=1; dmid<=DMCount;dmid++)
{
DeletePlayer3DTextLabel(playerid, DM3DTEXT[playerid][dmid]);
}

return 1;
}

*/
