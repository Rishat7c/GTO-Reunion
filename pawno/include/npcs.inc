#if defined _npcs_included
#endinput
#endif

#define _npcs_included
#pragma library npcs

#define NPC_MAX 11
#define NPC_CHECK_TIME 15000 //in ms

forward NPCInit();
forward SetupNPCToClassSelect(playerid);
forward SetupNPCToSpawn(playerid);
forward OnNPCLeaveServer(playerid);
forward OnNPCJoinServer(playerid);
forward CheckNPCs();
forward NPC_OnGameModExit();

new npc_cfg_filename[24] = "GTO/NPCConfig.cfg";
new npc_cfg_connectstr[24] = "ConnectNPC";

enum npc_info {
npc_Enable,
npc_Name[24],
npc_Scenario[24],
npc_Skin,
Float:npc_Spawn_X,
Float:npc_Spawn_Y,
Float:npc_Spawn_Z,
npc_VID,
npc_VModel,
Float:npc_VCreate_X,
Float:npc_VCreate_Y,
Float:npc_VCreate_Z,
Float:npc_VCreate_A,
npc_VCol1,
npc_VCol2,
npc_VEnter,
npc_team,
npc_playerid
}

new Float:NPC_Info[NPC_MAX][npc_info] = {
{0,"NPC_Train1","npc_train1",255,1462.0745,2630.8787,10.8203,-1,V_STREAK,-1943.9279,141.1992,27.2245,178.401, 1, 3, 0, 0, -1},
{0,"NPC_Bus1",  "npc_bus1",  255,1462.0745,2630.8787,10.8203,-1,V_COACH,  2185.48,  1259.41, 10.80,  180.000,-1,-1, 1, 1, -1},
{0,"NPC_Bus2",	"npc_bus2",  255,1462.0745,2630.8787,10.8203,-1,V_COACH,  2182.69, -1641.59, 15.28,  270.000,-1,-1, 1, 1, -1},
{0,"NPC_Train2","npc_train2",255,1462.0745,2630.8787,10.8203,-1,V_STREAK, 1763.622,-1953.79,14.876,    90.00, 1,86, 0, 0, -1},
{0,"NPC_Train3","npc_train3",255,1462.0745,2630.8787,10.8203,-1,V_STREAK,1394.013,  2632.25,12.125,   90.000, 1,93, 0, 0, -1},
{0,"NPC_Plane1","npc_plane1",255,1462.0745,2630.8787,10.8203,-1,V_AT400, 2006.716,-2493.819,13.455,   90.000, 1,3,  1, 2, -1},
{0,"NPC_Plane2","npc_plane2",255,1462.0745,2630.8787,10.8203,-1,V_AT400, 1390.125,1631.689, 10.728,   180.00, 1,86, 1, 2, -1},
{0,"NPC_Plane3","npc_plane3",255,1462.0745,2630.8787,10.8203,-1,V_AT400,-1624.722,-239.466,14.064,     315.00,1,93, 1, 2, -1},
{0,"NPC_Train4","npc_train4",255,1462.0745,2630.8787,10.8203,-1,V_FREIGHT,2864.75,1327.06, 12.125,     0.00, -1,-1, 0, 0, -1},
{0,"NPC_Tram1","npc_tram1",255,1462.0745,2630.8787,10.8203,  -1,V_TRAM,-2006.5000,148.1862,27.9973,    0.00, -1,-1, 0, 3, -1},
{0,"NPC_Helicopter1","npc_helicopter1",284,1462.0745,2630.8787,10.8203,-1,V_LEVIATHN,2434.139892,2785.981445,10.487292,180.0,-1,-1,1, 4, -1}
};

AddNPC(npcid,loadveh)
{
if(loadveh)
{
NPC_Info[npcid][npc_VID] = AddStaticVehicleEx(NPC_Info[npcid][npc_VModel],NPC_Info[npcid][npc_VCreate_X],NPC_Info[npcid][npc_VCreate_Y],NPC_Info[npcid][npc_VCreate_Z],NPC_Info[npcid][npc_VCreate_A],NPC_Info[npcid][npc_VCol1],NPC_Info[npcid][npc_VCol2],-1);
}
else
{
SetVehicleToRespawn(NPC_Info[npcid][npc_VID]);
}
ConnectNPC(NPC_Info[npcid][npc_Name],NPC_Info[npcid][npc_Scenario]);
}

KickNPCTeam(teamid)
{
for(new i=0;i<NPC_MAX;i++)
{
if(NPC_Info[i][npc_team] == teamid && NPC_Info[i][npc_playerid] != -1) { Kick( NPC_Info[i][npc_playerid] ); }
}
}

public NPCInit()
{

new str[24];

if (!dini_Exists(npc_cfg_filename))
	{
	printf("NPC config file not found... Start creating file '%s'...",npc_cfg_filename);
	dini_Create(npc_cfg_filename);
	for(new i=0;i<NPC_MAX;i++)
	{
	format(str,sizeof(str),"%s%d",npc_cfg_connectstr,i+1);
	dini_Set(npc_cfg_filename, str,"0");
	}
	print("NPC config file created. All parametres set to default");
	}
	else
	{
	for(new i=0;i<NPC_MAX;i++)
	{
	format(str,sizeof(str),"%s%d",npc_cfg_connectstr,i+1);
	NPC_Info[i][npc_Enable] = strval(dini_Get(npc_cfg_filename,str));
	}
	print("NPC config file loaded... Start connect NPCs...");
	}

for(new i=0;i<NPC_MAX;i++)
{
if(NPC_Info[i][npc_Enable] == 1)
{
AddNPC(i,1);
}
}

return 1;
}

public SetupNPCToClassSelect(playerid)
{
new playername[MAX_NAME];
playername = oGetPlayerName(playerid);

for(new i=0;i<NPC_MAX;i++)
{
if(!strcmp(playername,NPC_Info[i][npc_Name],true))
{
SetSpawnInfo(playerid,0,NPC_Info[i][npc_Skin],NPC_Info[i][npc_Spawn_X],NPC_Info[i][npc_Spawn_Y],NPC_Info[i][npc_Spawn_Z],0.0,-1,-1,-1,-1,-1,-1);
break;
}
}

return 1;
}

public SetupNPCToSpawn(playerid)
{
new playername[MAX_NAME];
playername = oGetPlayerName(playerid);

SetPlayerColor(playerid, 0x00000080);

for(new i=0;i<NPC_MAX;i++)
{
if(!strcmp(playername,NPC_Info[i][npc_Name],true))
{
if(NPC_Info[i][npc_VID] != -1)
{
oPutPlayerInVehicle(playerid,NPC_Info[i][npc_VID],0);
printf("Created %s[%d] and put in vechicle '%s', veh-id[%d]",playername,NPC_Info[i][npc_playerid],GetVehicleName(GetVehicleModel(NPC_Info[i][npc_VID])),NPC_Info[i][npc_VID]);
}
else
{
printf("Created %s[%d]",playername,NPC_Info[i][npc_playerid]);
}
break;
}
}
return 1;
}

public OnNPCLeaveServer(playerid)
{
if(GM_RestartNow) {return 1;}
new npcid = -1;

for(new i=0;i<NPC_MAX;i++)
{ if(NPC_Info[i][npc_playerid] == playerid)
{npcid = i; break; }}

if(npcid == -1) {return 0;}
SetVehicleToRespawn(NPC_Info[npcid][npc_VID]);
//NPC_Info[npcid][npc_VID] = -1;
NPC_Info[npcid][npc_playerid] = -1;
KickNPCTeam( NPC_Info[npcid][npc_team] );
return 1;
}

public OnNPCJoinServer(playerid)
{
for(new i=0;i<NPC_MAX;i++)
{
if(!strcmp(oGetPlayerName(playerid),NPC_Info[i][npc_Name],true))
{
NPC_Info[i][npc_playerid] = playerid;
player_ResetStats(playerid);
break;
}
}
return 1;
}

public CheckNPCs()
{
for(new i=0;i<NPC_MAX;i++)
{
if(NPC_Info[i][npc_playerid] == -1 && NPC_Info[i][npc_Enable] == 1)
{ AddNPC(i,0); }}
return 1;
}

public NPC_OnGameModExit()
{
	for(new i=0;i<NPC_MAX;i++)
	{
		if(NPC_Info[i][npc_playerid] != -1)
		{
			Kick( NPC_Info[i][npc_playerid] );
		}
	}
}