//
//  ADMIN SPECTATE FILTER SCRIPT
//  kyeman 2008
//  
//	INCLUDING IN GTO REUNION
//	OFFREAL 2010
//
//  NEW CALLBACK oSetPlayerVirtualWorld
//  Rishat 2016

#include <a_samp>
#include <core>
#include <float>

#define AS_COLOR_GREY 0xAFAFAFAA
#define AS_COLOR_GREEN 0x33AA33AA
#define AS_COLOR_RED 0xAA3333AA
#define AS_COLOR_YELLOW 0xFFFF00AA
#define AS_COLOR_WHITE 0xFFFFFFFF

//------------------------------------------------------------------------------------------------------

#define ADMIN_SPEC_TYPE_NONE 0
#define ADMIN_SPEC_TYPE_PLAYER 1
#define ADMIN_SPEC_TYPE_VEHICLE 2

forward aspec_OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid);
forward aspec_OnPlayerStateChange(playerid, newstate, oldstate);

forward aspec_GetPlayerSpecID(playerid);

forward SpectateHelp(playerid);
forward SpectateOFF(playerid);
forward SpectateVehicle(playerid,vehicleid);
forward SpectatePlayer(playerid,specplayerid);
forward aspec_IsPlayerSpecToPlayer(playerid);

new gSpectateID[MAX_PLAYERS];
new gSpectateType[MAX_PLAYERS];

public aspec_GetPlayerSpecID(playerid) {return gSpectateID[playerid];}

public aspec_IsPlayerSpecToPlayer(playerid)
{
if(gSpectateType[playerid] == ADMIN_SPEC_TYPE_PLAYER) {return 1;}
return 0;
}

public aspec_OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	// IF ANYONE IS SPECTATING THIS PLAYER, WE'LL ALSO HAVE
	// TO CHANGE THEIR INTERIOR ID TO MATCH
	new x = 0;
	while(x!=MAX_PLAYERS) {
	    if( IsPlayerConnected(x) &&	GetPlayerState(x) == PLAYER_STATE_SPECTATING &&
			gSpectateID[x] == playerid && gSpectateType[x] == ADMIN_SPEC_TYPE_PLAYER )
   		{
   		    SetPlayerInterior(x,newinteriorid);
		}
		x++;
	}
}

forward aspec_OnPlayerVWChange(playerid, newworldid, oldworldid);
public aspec_OnPlayerVWChange(playerid, newworldid, oldworldid)
{
	// IF ANYONE IS SPECTATING THIS PLAYER, WE'LL ALSO HAVE
	// TO CHANGE THEIR INTERIOR ID TO MATCH
	new x = 0;
	while(x!=MAX_PLAYERS) {
	    if( IsPlayerConnected(x) &&	GetPlayerState(x) == PLAYER_STATE_SPECTATING &&
			gSpectateID[x] == playerid && gSpectateType[x] == ADMIN_SPEC_TYPE_PLAYER )
   		{
   		    SetPlayerVirtualWorld(x,newworldid);
		}
		x++;
	}
}

oSetPlayerVirtualWorld(playerid, worldid)
{
	aspec_OnPlayerVWChange(playerid, worldid, GetPlayerVirtualWorld(playerid));
	SetPlayerVirtualWorld(playerid, worldid);
}

public aspec_OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_ONFOOT)
	{
		new x = 0;
		while(x!=MAX_PLAYERS) {
		    if( IsPlayerConnected(x) &&	GetPlayerState(x) == PLAYER_STATE_SPECTATING &&
				gSpectateID[x] == playerid && gSpectateType[x] == ADMIN_SPEC_TYPE_PLAYER )
	   		{
			TogglePlayerSpectating(x, 1);
			PlayerSpectatePlayer(x, playerid);
			SetPlayerInterior(x, GetPlayerInterior(playerid));
		 	oSetPlayerVirtualWorld(x, GetPlayerVirtualWorld(playerid));
			}
			x++;
		}
	}
	if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER )
	{
		new x = 0;
		while(x!=MAX_PLAYERS) {
		    if( IsPlayerConnected(x) &&	GetPlayerState(x) == PLAYER_STATE_SPECTATING &&
				gSpectateID[x] == playerid && gSpectateType[x] == ADMIN_SPEC_TYPE_PLAYER )
	   		{
			TogglePlayerSpectating(x, 1);
			PlayerSpectateVehicle(x, (GetPlayerVehicleID(playerid)));
			SetPlayerInterior(x, GetPlayerInterior(playerid));
		    oSetPlayerVirtualWorld(x, GetPlayerVirtualWorld(playerid));
			}
			x++;
		}
	}
}

public SpectatePlayer(playerid,specplayerid)
{
if(IsPlayerInAnyVehicle(specplayerid))
{
TogglePlayerSpectating(playerid, 1);
PlayerSpectateVehicle(playerid, (GetPlayerVehicleID(specplayerid)));
} else {
TogglePlayerSpectating(playerid, 1);
PlayerSpectatePlayer(playerid, specplayerid);
}
SetPlayerInterior(playerid,GetPlayerInterior(specplayerid));
oSetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(specplayerid));
gSpectateID[playerid] = specplayerid;
gSpectateType[playerid] = ADMIN_SPEC_TYPE_PLAYER;
SendClientMessage(playerid, AS_COLOR_YELLOW, "--> Вы смотрите глазами выбранного игрока. Сброс: /specoff");
return 1;
}

public SpectateVehicle(playerid,vehicleid)
{
if(vehicleid < MAX_VEHICLES) {
TogglePlayerSpectating(playerid, 1);
PlayerSpectateVehicle(playerid, vehicleid);
gSpectateID[playerid] = vehicleid;
gSpectateType[playerid] = ADMIN_SPEC_TYPE_VEHICLE;
SendClientMessage(playerid, AS_COLOR_YELLOW, "--> Вы видите выбранный транспорт (его локацию). Сброс: /specoff");
} else {
SendClientMessage(playerid, AS_COLOR_YELLOW, "--> На сервере нет машины с таким ИД");
}
return 1;
}

public SpectateOFF(playerid)
{
TogglePlayerSpectating(playerid, 0);
gSpectateID[playerid] = INVALIDX_PLAYER_ID;
gSpectateType[playerid] = ADMIN_SPEC_TYPE_NONE;
return 1;
}

public SpectateHelp(playerid)
{
SendClientMessage(playerid, AS_COLOR_YELLOW, "Команды управления для Админов:");
SendClientMessage(playerid, AS_COLOR_WHITE, "'/spechelp' - эта помощь");
SendClientMessage(playerid, AS_COLOR_WHITE, "'/specplayer [playerid]' - Смотреть глазами игрока");
SendClientMessage(playerid, AS_COLOR_WHITE, "'/specvehicle [vehicleid]' - Показать транспорт по его ID в игре.");
SendClientMessage(playerid, AS_COLOR_WHITE, "'/specoff' - сброс всех функций.");
return 1;
}
