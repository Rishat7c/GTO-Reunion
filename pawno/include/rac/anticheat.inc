#if defined _anticheat_included
	#endinput
#endif
#define _anticheat_included

#define MAX_VEHICLE_SPEED 350

enum enum_AC_pPlayer
{
	Float: AC_pPosX,
	Float: AC_pPosY,
	Float: AC_pPosZ,
	Float: AC_pPosA,
	AC_pTeleport
}
new AC_pPlayer[MAX_PLAYERS][enum_AC_pPlayer];

enum enum_VC_vPlayer
{
	Float: VC_vPosX,
	Float: VC_vPosY,
	Float: VC_vPosZ
}
new VC_vPlayer[MAX_VEHICLES][enum_VC_vPlayer];

// Переменные:

#define STREAM_DIST_MIN 100.00

new bool:v_Streamed[ MAX_VEHICLES ][ MAX_PLAYERS ];

// Паблики (требуется добавить ссылки на эти функции в оргинальных пабликах)

stock avtp_OnVehicleStreamIn(vehicleid, forplayerid)
{
if (!IsPlayerMod(forplayerid) && !IsPlayerAdmin(forplayerid) && !IsPlayerAdm(forplayerid))
{
    v_Streamed[vehicleid][forplayerid] = true;
}
return 1;
}

stock avtp_OnVehicleStreamOut(vehicleid, forplayerid)
{
    v_Streamed[vehicleid][forplayerid] = false;
    return 1;
}

stock avtp_OnPlayerConnect(playerid)
{
    for(new v;v<MAX_VEHICLES;v++)
    {
        v_Streamed[v][playerid] = false;
    }
    return 1;
}

stock avtp_OnVehicleSpawn(vehicleid)
{
    new Float:vehx, Float:vehy, Float:vehz;
    GetVehiclePos(vehicleid, vehx, vehy, vehz);
    for(new i; i<MAX_PLAYERS; i++)
    {
        if( GetPlayerDistanceFromPoint(i, vehx, vehy, vehz) < STREAM_DIST_MIN )
        {
            v_Streamed[vehicleid][i] = true;
        }
        else
        {
            v_Streamed[vehicleid][i] = false;
        }
    }
    return 1;
}

stock Float: GetPlayerSpeedV(playerid)
{
	new Float: x, Float: y, Float: z;
	if(IsPlayerInAnyVehicle(playerid)) GetVehicleVelocity(GetPlayerVehicleID(playerid), x, y, z);
	else GetPlayerVelocity(playerid, x, y, z);
	return (VectorSize(x,y,z)*195.29);
}

stock AC_SetPlayerPosFindZ(playerid, Float: x, Float: y, Float: z)
{
	AC_pPlayer[playerid][AC_pPosX] = x;
	AC_pPlayer[playerid][AC_pPosY] = y;
	AC_pPlayer[playerid][AC_pPosZ] = z;
	SetPlayerPosFindZ(playerid, x, y, z);
	AC_pPlayer[playerid][AC_pTeleport] = 3;
	SetCameraBehindPlayer(playerid);
}

stock AC_SetPlayerPos(playerid, Float: x, Float: y, Float: z)
{
	AC_pPlayer[playerid][AC_pPosX] = x; 
	AC_pPlayer[playerid][AC_pPosY] = y; 
	AC_pPlayer[playerid][AC_pPosZ] = z;
	for(new i; i<MAX_VEHICLES; i++)
    {
        if( GetVehicleDistanceFromPoint(i, x, y, z) < STREAM_DIST_MIN )
        {
            v_Streamed[i][playerid] = true;
        }
        else
        {
            v_Streamed[i][playerid] = false;
        }
    }
	SetPlayerPos(playerid, x, y, z);
	SetCameraBehindPlayer(playerid);
	AC_pPlayer[playerid][AC_pTeleport] = 3;
}

stock AC_SetVehiclePos(vehicleid, Float:x, Float:y, Float:z)
{
	VC_vPlayer[vehicleid][VC_vPosX] = x;
	VC_vPlayer[vehicleid][VC_vPosY] = y;
	VC_vPlayer[vehicleid][VC_vPosZ] = z;
 	for(new i; i<MAX_PLAYERS; i++)
    {
        AC_pPlayer[i][AC_pTeleport] = 3;
        if( GetPlayerDistanceFromPoint(i, x, y, z) < STREAM_DIST_MIN )
        {
            v_Streamed[vehicleid][i] = true;
        }
        else
        {
            v_Streamed[vehicleid][i] = false;
        }
    }
	SetVehiclePos(vehicleid, x, y, z);
}

stock AC_GetPlayerPos(playerid)
{
	new Float: x, Float: y, Float: z, Float: angle;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, angle);
	AC_pPlayer[playerid][AC_pPosX] = x; 
	AC_pPlayer[playerid][AC_pPosY] = y; 
	AC_pPlayer[playerid][AC_pPosZ] = z;
	AC_pPlayer[playerid][AC_pPosA] = angle;
}

new warnAB[MAX_PLAYERS];

ac_OnPlayerUpdate(playerid)
{
if (!IsPlayerMod(playerid) && !IsPlayerAdmin(playerid) && !IsPlayerAdm(playerid))
{
if(GetPlayerSpeedV(playerid) > MAX_VEHICLE_SPEED)
{
	new VehicleID;
	VehicleID = GetPlayerVehicleID(playerid);
	for (new adminid=0; adminid<MAX_PLAYERS;adminid++)
	{
	    warnAB[playerid]++;
	    if(warnAB[playerid] > 5)
		{
			if (IsPlayerAdmin(adminid) || IsPlayerAdm(adminid) || IsPlayerMod(adminid))
			{
				/*new message[MAX_STRING];
				format(message,sizeof(message), lang_texts[23][4] ,oGetPlayerName(playerid),playerid, GetVehicleName(VehicleID), GetPlayerSpeedV(playerid));
				SendPlayerFormattedText(adminid,message, 0,COLOUR_GREY);*/
				warnAB[playerid] = 0;
				//
				new string[MAX_STRING];
				format(string,sizeof(string), lang_texts[23][7] , GetVehicleName(VehicleID), GetPlayerSpeedV(playerid));
				KickPlayer(playerid,string); //kick player, they used speed hack
				//
			}
		}
	}
}
}
}

/*ac_OnGameModeInit()
{
	new tick = GetTickCount();

	SetTimer("ac_Timer", 1000, true);

	printf("Anticheat loaded (%d ms)", GetTickCount() - tick);	
}

forward ac_Timer();
public ac_Timer()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(!IsPlayerConnected(i)) continue;
		{
			ac_CheckPlayer(i);
		}
	}
	return true;
}*/


new plafk[MAX_PLAYERS];
new warnTP[MAX_PLAYERS];
/*
stock ac_CheckPlayer(playerid)
{
if (!IsPlayerConnected(playerid)) return 0;
new pstate;
pstate=GetPlayerState(playerid);
if(pstate==PLAYER_STATE_ONFOOT || (pstate==PLAYER_STATE_DRIVER && GetPlayerSpeedV(playerid)<10))
{
if (!IsPlayerMod(playerid) && !IsPlayerAdmin(playerid) && !IsPlayerAdm(playerid))
{
if(!IsPlayerInAnyVehicle(playerid))
{
if(GetPlayerDistanceFromPoint(playerid, AC_pPlayer[playerid][AC_pPosX], AC_pPlayer[playerid][AC_pPosY], AC_pPlayer[playerid][AC_pPosZ]) > 300)
{
if(AC_pPlayer[playerid][AC_pTeleport] <= 0)
{
for (new adminid=0; adminid<MAX_PLAYERS;adminid++)
{
warnTP[playerid]++;
if(warnTP[playerid] > 2)
{
if (IsPlayerAdmin(adminid) || IsPlayerAdm(adminid) || IsPlayerMod(adminid))
{
new message[MAX_STRING];
format(message,sizeof(message), lang_texts[23][3] ,oGetPlayerName(playerid),playerid);
SendPlayerFormattedText(adminid,message, 0,COLOUR_GREY);
warnTP[playerid] = 0;
}
}
}
}
}
}
}
AC_pPlayer[playerid][AC_pTeleport] -= 1;
AC_GetPlayerPos(playerid);
}
return 1;
}*/

stock avtp_PutPlayerInVehicle(playerid, vehicleid, seat)
{
    v_Streamed[vehicleid][playerid] = true;
    PutPlayerInVehicle(playerid, vehicleid, seat);
}


#define SetPlayerPosEx(%0,%1,%2,%3) AC_SetPlayerPos(%0,%1,%2,%3)
#define SetVehiclePosEx(%0,%1,%2,%3) AC_SetVehiclePos(%0,%1,%2,%3)
#define SetPlayerPosFindZ(%0,%1,%2,%3) AC_SetPlayerPosFindZ(%0,%1,%2,%3)
#define PutPlayerInVehicleEx(%0,%1,%2) avtp_PutPlayerInVehicle(%0,%1,%2)
