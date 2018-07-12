/**********************************************************************************
*  AntiCheaterSystem 1.40 (c) 2008 Krystian Bigaj  Continued by Konsul            *
***********************************************************************************
*                                                                                 *
*  Download:                                                                      *
*    http://flatdev.ovh.org?project=5                                             *
*                                                                                 *
*  Author:                                                                        *
*    Krystian Bigaj                                                               *
*    Homepage: http://flatdev.ovh.org                                             *
*    Email: krystian.bigaj@gmail.com                                              *
*                                                                                 *
*  Inspiration - Cheaters and spawnkillers on server:                             *
*                [AU] AboveUltimate.com [gta-host.com] - Mode: Hydra Blast!       *
*                                                                                 *
*  This file is provided as is (no warranties).                                   *
*                                                                                 *
*  BTW: hp sucks, and that's all...                                               *
*                                                                                 *
**********************************************************************************/

// --------------------------------------------------------------------------------
// --- Configuration --------------------------------------------------------------
// --------------------------------------------------------------------------------

// ACS_COLOR_MSG - color of ACS messages. Default 0xFFFF00AA (yellow)
#define ACS_COLOR_MSG 0xFFFF00AA

// ACS_SPAWN_KILLS - player will be kicked after ACS_SPAWN_KILLS spawn kills. Default 4 seconds. Set 0 to disable.
#define ACS_SPAWN_KILLS 6

// ACS_SPAWN_KILL_TIME - time in seconds to no kill after spawn. Default 5s.
#define ACS_SPAWN_KILL_TIME 5

// ACS_SPAWN_KILL_TIME_DEC - time in seconds to decreses by one spawnkill counter. Default 60s. Set 0 to disable.
#define ACS_SPAWN_KILL_TIME_DEC 20

// ACS_VOTEKICK_TIME - time in seconds to cancel vote to kick after no new votes. Default 20. Set 0 to disable.
#define ACS_VOTEKICK_TIME 60

// ACS_VOTEKICK_VOTE_DELAY - delay between player votekicks. Default 10s. Set 0 to disable.
#define ACS_VOTEKICK_VOTE_DELAY 10

// --------------------------------------------------------------------------------
// --- Variables ------------------------------------------------------------------
// --------------------------------------------------------------------------------

#include <a_samp>
forward ACS_Info(playerid);
forward ACS_VoteKick_Start(voteid, playerid, reason[]);
forward ACS_VoteKick_Stop(playerid, reason[]);
forward ACS_VoteKick(playerid);
forward ACS_VoteKick_KickNow();
forward ACS_VoteKick_IsVoting();
forward ACS_VoteKick_Reset();
forward ACS_VoteKick_Update();
forward ACS_VoteKick_Timer();
forward ACS_SpawnKill_KickNow();
forward ACS_tickcount();
forward ACS_TickTimer();
forward ACS_ReinitTimers();
forward strtok(const string[], &index);

#define ACS_STRING_MAX 256

// Spawnkill
#if ACS_SPAWN_KILLS > 0
new gACS_SpawnKill_Kills_PlayerId[MAX_PLAYERS];
new gACS_SpawnKill_Time_PlayerId[MAX_PLAYERS];
new gACS_SpawnKill_KickPlayerId;
new gACS_SpawnKill_TimerLast = 0;
#endif

// Votes
new gACS_VotedPlayerId[MAX_PLAYERS];
#if ACS_VOTEKICK_TIME > 0
new gACS_VoteTimer;
#endif
new gACS_Votes;
new gACS_VotesKick;
new gACS_Kicking;
new gACS_VotePlayerId;
new gACS_VotePlayerName[MAX_PLAYER_NAME];
new gACS_VotePlayerIdBy;
new gACS_VotePlayerNameBy[MAX_PLAYER_NAME];
new gACS_VoteReason[ACS_STRING_MAX];
new gACS_PlayerCount;
#if ACS_VOTEKICK_VOTE_DELAY > 0
new gACS_VoteLastPlayerId;
new gACS_VoteLastTime;
#endif

// Tick timer
new gACS_TickTimer = 0;
new gACS_Ticks;

// --------------------------------------------------------------------------------
// --- Functions ------------------------------------------------------------------
// --------------------------------------------------------------------------------

PlName(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof (name));
	return name;
}

public ACS_Info(playerid)
{
  new string[ACS_STRING_MAX];

  SendClientMessage(playerid, ACS_COLOR_MSG, " AntiCheaterSystem v1.40");
  SendClientMessage(playerid, ACS_COLOR_MSG, " Created by Krystian Bigaj");
  SendClientMessage(playerid, ACS_COLOR_MSG, " Continued by Konsul");

#if ACS_SPAWN_KILLS > 0
  format(string, sizeof(string), " AntiSpawnKill: ����� %d ������� �� ������ � ������� %d �. ����� ������, ����� ����� ������", ACS_SPAWN_KILLS, ACS_SPAWN_KILL_TIME);
  SendClientMessage(playerid, ACS_COLOR_MSG, string);
#endif

  if( ACS_VoteKick_IsVoting() )
  {
    format(string, sizeof(string), " %s(%d) ����������� ����������� ��� ���� %s(%d). �������: %s",
      gACS_VotePlayerNameBy, gACS_VotePlayerIdBy, gACS_VotePlayerName, gACS_VotePlayerId, gACS_VoteReason);
    SendClientMessage(playerid, ACS_COLOR_MSG, string);

    format(string, sizeof(string), " ������� /avote ��� ������ ��. ����� [%d/%d] �������", gACS_Votes, gACS_VotesKick);
    SendClientMessage(playerid, ACS_COLOR_MSG, string);
  }else
  {
    SendClientMessage(playerid, ACS_COLOR_MSG,
      " ��� ������ ����������� �� ��� (������ ������, ������ �� ������ � ��.) �������: /votekick [ID ������] [�������]");
  }
}

public ACS_VoteKick_Start(voteid, playerid, reason[])
{
  if ( ACS_VoteKick_IsVoting() )
  {
    SendClientMessage(playerid, ACS_COLOR_MSG,  " ������ �� �� ������ ��������� ���-�����������. ��� ���. ���������� �������: /acsinfo");
    return;
  }

  ACS_VoteKick_Update();

  if( gACS_PlayerCount < 3 )
  {
    SendClientMessage(playerid, ACS_COLOR_MSG,  " ������� ������� ��� ����������� - 3. ��� ���. ���������� �������: /acsinfo");
    return;
  }

  if( !IsPlayerConnected(voteid) )
  {
    SendClientMessage(playerid, ACS_COLOR_MSG,  " �������� ID ������ (����� � Offline)");
    return;
  }
  
  if( IsPlayerNPC(voteid) )
  {
    SendClientMessage(playerid, ACS_COLOR_MSG,  " �� �� ������ ��������� ���-����������� ������ NPC!");
    return;
  }

  if( voteid == playerid )
  {
    SendClientMessage(playerid, ACS_COLOR_MSG,  " �������� ID ������ (��� ��� ID)");
    return;
  }

  if( IsPlayerAdmin(voteid) )
  {
    SendClientMessage(playerid, ACS_COLOR_MSG,  " �������� ID ������ (��� �������������)");
    return;
  }
//================================================================================================================================/*/
//------------------------------------------------���������� ������ � ������ �����������------------------------------------------/*/
  new aid = 0;
  while(aid <= MAX_PLAYERS)
  {
    if ((IsPlayerConnected(aid)) && (IsPlayerAdmin(aid)))
  {
    new string[ACS_STRING_MAX];
    format(string, sizeof(string), "ACS: %s [ID %d] ��������� ������������ ����������� ��� ���� %s [ID %d] �� ������� %s",
    PlName(playerid), playerid, PlName(voteid), voteid, reason);
    SendClientMessage(aid,ACS_COLOR_MSG, string);
    SendClientMessage(playerid,ACS_COLOR_MSG, "����� ������ �� �������� ���� �����������");
    return;
  }
    aid=aid+1;
  }
//---------------------------------------------------------------------------------------------------------------------------------/*/
//=================================================================================================================================/*/
  new string[ACS_STRING_MAX];

#if ACS_VOTEKICK_VOTE_DELAY > 0
  if( (gACS_VoteLastPlayerId == playerid) && (ACS_tickcount() <= (gACS_VoteLastTime + (ACS_VOTEKICK_VOTE_DELAY * 1000))) )
  {
    format(string, sizeof(string), " ������ �� �� ������ ������������� �� ���. ������ ��� ���-�� ����� ���� �����. ��������� ��������� ����� %d �.", ACS_VOTEKICK_VOTE_DELAY);
    SendClientMessage(playerid, ACS_COLOR_MSG, string);
    return;
  }

  gACS_VoteLastPlayerId = playerid;
#endif

  gACS_VotePlayerId = voteid;
  GetPlayerName(voteid, gACS_VotePlayerName, sizeof(gACS_VotePlayerName));

  gACS_VotePlayerIdBy = playerid;
  GetPlayerName(playerid, gACS_VotePlayerNameBy, sizeof(gACS_VotePlayerNameBy));

  new i = 0;
  while( i<strlen(reason) )
  {
    gACS_VoteReason[i] = reason[i];
    i++;
  }
  gACS_VoteReason[i] = EOS;

  gACS_VotedPlayerId[playerid] = 1;
  gACS_Votes = 1;

  format(string, sizeof(string), " %s(%d) ����������� ����������� ��� ���� %s(%d) �� �������: %s",
    gACS_VotePlayerNameBy, gACS_VotePlayerIdBy, gACS_VotePlayerName, gACS_VotePlayerId, gACS_VoteReason);
  SendClientMessageToAll(ACS_COLOR_MSG, string);
  
  format(string, sizeof(string), " ������� /avote ��� ������ ��. ��������� %d �������.", gACS_VotesKick - 1);
  SendClientMessageToAll(ACS_COLOR_MSG, string);
  SendClientMessage(playerid, ACS_COLOR_MSG,  " ���� �� ������ �������� �����������, ������� /votestop [�������]");

#if ACS_VOTEKICK_TIME > 0
  gACS_VoteTimer = SetTimer("ACS_VoteKick_Timer", ACS_VOTEKICK_TIME * 1000, 0);
#endif
}

public ACS_VoteKick_Stop(playerid, reason[])
{
  if ( !ACS_VoteKick_IsVoting() )
     return;

  if( (playerid != gACS_VotePlayerIdBy) && !IsPlayerAdmin(playerid) )
  {
    SendClientMessage(playerid, ACS_COLOR_MSG,  " �� �� ������ �������� ����������� ��� ����, ������ ��������� � ������������� ����� ������� ���. ��� ���. ���. ���������� �������: /acsinfo");
    return;
  }

  new string[ACS_STRING_MAX];
  format(string, sizeof(string), " ����������� ��� ���� %s(%d) ���������� �� �������: %s",
    gACS_VotePlayerName, gACS_VotePlayerId, reason);
  SendClientMessageToAll(ACS_COLOR_MSG, string);

  ACS_VoteKick_Reset();
}

public ACS_VoteKick(playerid)
{
  if( gACS_Kicking )
    return;

  if ( !ACS_VoteKick_IsVoting() )
  {
    SendClientMessage(playerid, ACS_COLOR_MSG,  " ������ �� �� ������ ���������� �� ���. ��� ���. ���������� �������: /acsinfo");
    return;
  }

  if( gACS_VotePlayerId == playerid )
  {
    SendClientMessage(playerid, ACS_COLOR_MSG, " �� ��� ���������� � ������ �� ������ ��� ������");
    return;
  }

  if( gACS_VotedPlayerId[playerid] )
  {
    SendClientMessage(playerid, ACS_COLOR_MSG, " �� �������������");
    return;
  }

#if ACS_VOTEKICK_TIME > 0
  KillTimer(gACS_VoteTimer);
  gACS_VoteTimer = 0;
#endif

  new name[MAX_PLAYER_NAME];
  new string[ACS_STRING_MAX];

  GetPlayerName(playerid, name, sizeof(name));

  gACS_VotedPlayerId[playerid] = 1;
  gACS_Votes += 1;

  format(string, sizeof(string), " %s (ID: %d) ������� ����� �� ��� %s(%d). ����� [%d/%d]",
    name, playerid, gACS_VotePlayerName, gACS_VotePlayerId, gACS_Votes, gACS_VotesKick);
  SendClientMessageToAll(ACS_COLOR_MSG, string);

  if( gACS_Votes >= gACS_VotesKick )
  {
    format(string, sizeof(string), " ������ �� ������ ������� � ������� �� �������: %s", gACS_VoteReason);
    SendClientMessage(gACS_VotePlayerId, ACS_COLOR_MSG, string);

    gACS_Kicking = 1;
    SetTimer("ACS_VoteKick_KickNow", 1000, 0);
    return;
  }

  format(string, sizeof(string), " �������: %s. ��� ����������� �� �������: /avote", gACS_VoteReason);
  SendClientMessageToAll(ACS_COLOR_MSG, string);

#if ACS_VOTEKICK_TIME > 0
  gACS_VoteTimer = SetTimer("ACS_VoteKick_Timer", ACS_VOTEKICK_TIME * 1000, 0);
#endif
}

public ACS_VoteKick_KickNow()
{
  new string[ACS_STRING_MAX];

  format(string, sizeof(string), " %s (ID: %d) ��� ������ � ������� �� �������: %s",
    gACS_VotePlayerName, gACS_VotePlayerId, gACS_VoteReason);
  SendClientMessageToAll(ACS_COLOR_MSG, string);
  printf("ACS: Kicked: %s | Init by: %s | Reason: %s", gACS_VotePlayerName, gACS_VotePlayerNameBy, gACS_VoteReason);
  
  new i = gACS_VotePlayerId;
  ACS_VoteKick_Reset();
  Kick(i);
}

public ACS_VoteKick_IsVoting()
{
  return gACS_VotePlayerId != INVALID_PLAYER_ID;
}

public ACS_VoteKick_Reset()
{
  for( new i=0; i<MAX_PLAYERS; i++)
    gACS_VotedPlayerId[i] = 0;

#if ACS_VOTEKICK_VOTE_DELAY > 0
  gACS_VoteLastTime = ACS_tickcount();
#endif

#if ACS_VOTEKICK_TIME > 0
  if( gACS_VoteTimer != 0 )
    KillTimer(gACS_VoteTimer);
  gACS_VoteTimer = 0;
#endif
  gACS_Votes = 0;
  gACS_Kicking = 0;
  gACS_VotePlayerId = INVALID_PLAYER_ID;
  gACS_VotePlayerName = "";
  gACS_VotePlayerIdBy = INVALID_PLAYER_ID;
  gACS_VotePlayerNameBy = "";
  gACS_VoteReason = "";
}

public ACS_VoteKick_Update()
{
  gACS_PlayerCount = 0;
  for( new i = 0; i < MAX_PLAYERS; i++)
    if( IsPlayerConnected(i) && !IsPlayerNPC(i) )
      gACS_PlayerCount++;

  if( gACS_PlayerCount <= 4 )
    gACS_VotesKick = 2;
  else if( gACS_PlayerCount <= 7 )
    gACS_VotesKick = 3;
  else if( gACS_PlayerCount <= 10 )
    gACS_VotesKick = 4;
  else if( gACS_PlayerCount <= 14 )
    gACS_VotesKick = 5;
  else if( gACS_PlayerCount <= 20 )
    gACS_VotesKick = 6;
  else if( gACS_PlayerCount <= 30 )
    gACS_VotesKick = 7;
  else if( gACS_PlayerCount <= 40 )
    gACS_VotesKick = 8;
  else if( gACS_PlayerCount <= 60 )
    gACS_VotesKick = 9;
  else
    gACS_VotesKick = 10;

  return gACS_VotesKick;
}

#if ACS_VOTEKICK_TIME > 0
public ACS_VoteKick_Timer()
{
  new string[ACS_STRING_MAX];

  format(string, sizeof(string), " ��� ����� ������� (%d�.)", ACS_VOTEKICK_TIME);
  ACS_VoteKick_Stop(gACS_VotePlayerIdBy, string);
}
#endif

#if ACS_SPAWN_KILLS > 0
public ACS_SpawnKill_KickNow()
{
  new name[MAX_PLAYER_NAME];
  new string[ACS_STRING_MAX];

  GetPlayerName(gACS_SpawnKill_KickPlayerId, name, sizeof(name));

  format(string, sizeof(string), " %s(%d) ��� ������ � ������� �� �������: �������� �� ������",
    name, gACS_SpawnKill_KickPlayerId);
  SendClientMessageToAll(ACS_COLOR_MSG, string);

  Kick(gACS_SpawnKill_KickPlayerId);
}
#endif

public ACS_tickcount()
{
  return gACS_Ticks;
}

public ACS_TickTimer()
{
  gACS_Ticks += 1000;

#if (ACS_SPAWN_KILLS > 0) && (ACS_SPAWN_KILL_TIME_DEC > 0)
  if( ACS_tickcount() >= (gACS_SpawnKill_TimerLast + (ACS_SPAWN_KILL_TIME_DEC * 1000))  )
  {
    new i;
    new string[ACS_STRING_MAX];

    for( i = 0; i < MAX_PLAYERS; i++)
      if( gACS_SpawnKill_Kills_PlayerId[i] > 0)
      {
        gACS_SpawnKill_Kills_PlayerId[i]--;
        format(string, sizeof(string), " ��� ������� ������� �� ������: %d", gACS_SpawnKill_Kills_PlayerId[i]);
        SendClientMessage(i, ACS_COLOR_MSG, string);
      }

    gACS_SpawnKill_TimerLast = ACS_tickcount();
  }
 #endif
}

public ACS_ReinitTimers() // Workaround for bug #0000250 (http://bugs.sa-mp.com/view.php?id=250)
{
  if( gACS_TickTimer != 0 )
    KillTimer(gACS_TickTimer);
  gACS_TickTimer = SetTimer("ACS_TickTimer", 1000, 1);
}

// --------------------------------------------------------------------------------
// --- Events ---------------------------------------------------------------------
// --------------------------------------------------------------------------------

public OnFilterScriptInit()
{
  gACS_Ticks = tickcount();
  if( gACS_Ticks < 360000 )
    gACS_Ticks = 360000;

  ACS_VoteKick_Reset();
#if ACS_VOTEKICK_VOTE_DELAY > 0
  gACS_VoteLastTime = 0;
#endif

  print("\n--------------------------------------");
  print(  "--- AnitCheaterSystem  1.40 Loaded ---");
  print(  "--------------------------------------\n");
}

public OnFilterScriptExit()
{
  // Nothing now
}

public OnPlayerConnect(playerid)
{
  ACS_ReinitTimers();

#if ACS_SPAWN_KILLS > 0
  gACS_SpawnKill_Kills_PlayerId[playerid] = 0;
#endif

  gACS_VotedPlayerId[playerid] = 0;
  if( gACS_VotePlayerId == playerid)
    ACS_VoteKick_Reset();
}

public OnPlayerDisconnect(playerid)
{
  if( (gACS_VotePlayerId == playerid) || (gACS_VotePlayerIdBy == playerid) )
    ACS_VoteKick_Stop(gACS_VotePlayerIdBy, "����� ����������");
}

public OnPlayerSpawn(playerid)
{
  SendClientMessage(playerid, ACS_COLOR_MSG, " ��������! �� ������� ���������� AntiCheatSystem 1.40m (ACS). ������� /acsinfo ��� ��������� ���. ����������");

#if ACS_SPAWN_KILLS > 0
  gACS_SpawnKill_Time_PlayerId[playerid] = ACS_tickcount();
#endif
}

public OnPlayerDeath(playerid, killerid, reason)
{
#if ACS_SPAWN_KILLS > 0
  if( (killerid == INVALID_PLAYER_ID) || (playerid == INVALID_PLAYER_ID) || (playerid == killerid) || IsPlayerNPC(killerid))
    return;

  new string[ACS_STRING_MAX];

  if( gACS_SpawnKill_Kills_PlayerId[playerid] > 0 )
  {
    gACS_SpawnKill_Kills_PlayerId[playerid]--;
    format(string, sizeof(string), " ��� ������� ������� �� ������: %d", gACS_SpawnKill_Kills_PlayerId[playerid]);
    SendClientMessage(playerid, ACS_COLOR_MSG, string);
  }

  if( ACS_tickcount() <= (gACS_SpawnKill_Time_PlayerId[playerid] + (ACS_SPAWN_KILL_TIME * 1000)) )
  {
    gACS_SpawnKill_Kills_PlayerId[killerid] += 1;

    format(string, sizeof(string), " ��������! �� ������ ������� �� �������� �� ������. �� �������� ������ � ������� %d �. ����� ������. �������: [%d/%d]",
      ACS_SPAWN_KILL_TIME, gACS_SpawnKill_Kills_PlayerId[killerid], ACS_SPAWN_KILLS);
    SendClientMessage(killerid, ACS_COLOR_MSG, string);
  }

  if( gACS_SpawnKill_Kills_PlayerId[killerid] >= ACS_SPAWN_KILLS)
  {
    SendClientMessage(killerid, ACS_COLOR_MSG, " �� ������ ������� � ������� �� �������: �������� �� ������");

    gACS_SpawnKill_KickPlayerId = killerid;
    SetTimer("ACS_SpawnKill_KickNow", 1000, 0);
    gACS_SpawnKill_Kills_PlayerId[killerid] = 0;
  }
#endif
}

public OnPlayerCommandText(playerid, cmdtext[])
{
  if( !IsPlayerConnected(playerid) )
    return 0;

  if( strcmp(cmdtext, "/acsinfo", true) == 0 )
  {
    ACS_Info(playerid);
    return 1;
  }

  new cmd[ACS_STRING_MAX];
  new voteid;
  new votereason[ACS_STRING_MAX];
  new idx=0;
  new i = 0;

  cmd = strtok(cmdtext, idx);

  if( strcmp(cmd, "/votekick", true) == 0 )
  {
    cmd = strtok(cmdtext, idx);
    if(!strlen(cmd))
    {
      SendClientMessage(playerid, ACS_COLOR_MSG, " ������������ ����������, ������� /acsinfo");
      return 1;
    }
    voteid = strval(cmd);

    i = 0;
    while( i < strlen(cmdtext) )
    {
      votereason[i] = cmdtext[i];
      i++;
    }
    votereason[i] = EOS;

    if(!strlen(votereason))
    {
      SendClientMessage(playerid, ACS_COLOR_MSG, " ������������ ����������, ������� /acsinfo");
      return 1;
    }
	ACS_VoteKick_Start(voteid, playerid, votereason);
    return 1;
    }
 
  if( strcmp(cmd, "/votestop", true) == 0 )
  {
    i = 0;
    while( i < strlen(cmdtext) )
    {
      votereason[i-idx]=cmdtext[i];
      i++;
    }
    votereason[i] = EOS;

    ACS_VoteKick_Stop(playerid, votereason);
    return 1;
  }

  if( strcmp(cmd, "/avote", true) == 0 )
  {
    ACS_VoteKick(playerid);
    return 1;
  }

  if( strcmp(cmd, "/acsdebug", true) == 0 )
  {
    new s[ACS_STRING_MAX];
    format(s, sizeof(s), " �������: %d, Tickcount: %d, ACS_Ticks: %d, players: %d, kicks: %d", GetTickCount(), tickcount(), ACS_tickcount(), gACS_PlayerCount, gACS_VotesKick);
    SendClientMessage(playerid, ACS_COLOR_MSG, s);
    return 1;
  }

  return 0;
}

// --------------------------------------------------------------------------------
// --- Other functions ------------------------------------------------------------
// --------------------------------------------------------------------------------

strtok(const string[], &index)
{
  new length = strlen(string);
  while ((index < length) && (string[index] <= ' '))
    index++;

  new offset = index;
  new result[20];
  while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
  {
    result[index - offset] = string[index];
    index++;
  }
  result[index - offset] = EOS;
  return result;
  }
