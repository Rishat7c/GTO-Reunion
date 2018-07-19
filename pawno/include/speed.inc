#include <a_samp>

#define SP_UPD_TIME 500 // in ms

forward UpdateSpeed();
forward Speed_OnGameModeExit();

forward Speed_OnPlayerConnect(playerid);
forward Speed_OnPlayerDisconnect(playerid);

forward Speed_OnPlayerSpawn(playerid);
forward Speed_OnPlayerDeath(playerid);
forward Speed_OnPlayerSC(playerid, newstate, oldstate);

forward speed_JoinDM(playerid,dmid);
forward speed_PlayerLeaveDM(playerid);

forward Speed_UpdateVehName(vehicleid, name[]);

new Text:Speedo[MAX_PLAYERS];
new PlayerSpeedSwitch[MAX_PLAYERS]; //0 = not show, 1 = show
//new PlayerSpeedMode[MAX_PLAYERS]; //0,1
//new PlayerSpeedoCarID[MAX_PLAYERS];
new PlayerDM[MAX_PLAYERS];

static const CarName[][] =
{
    "Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel",	"Dumper", "Firetruck",
	"Trashmaster", "Stretch", "Manana", "Infernus",	"Voodoo", "Pony", "Mule", "Cheetah", "Ambulance",
	"Leviathan", "Moonbeam", "Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BF Injection",
	"Hunter", "Premier", "Enforcer", "Securicar", "Banshee", "Predator", "Bus",
	"Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach", "Cabbie","Stallion",
	"Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral","Squalo", "Seasparrow",
	"Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder","Reefer", "Tropic", "Flatbed", "Yankee",
	"Caddy", "Solair", "Berkley's RC Van","Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron",
	"RC Raider", "Glendale","Oceanic","Sanchez", "Sparrow", "Patriot", "Quad", "Coastguard",
	"Dinghy","Hermes", "Sabre", "Rustler", "ZR-350", "Walton", "Regina", "Comet", "BMX",
	"Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick", "News Chopper",
	"Rancher", "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking",
	"Blista Compact", "Police Maverick", "Boxvillde", "Benson", "Mesa", "RC Goblin",
	"Hotring Racer A", "Hotring Racer B", "Bloodring Banger", "Rancher", "Super GT",
	"Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropduster", "Stunt",
	"Tanker", "Roadtrain", "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra","FCR-900",
	"NRG-500", "HPV1000", "Cement Truck", "Tow Truck", "Fortune", "Cadrona", "FBI Truck",
	"Willard", "Forklift", "Tractor", "Combine", "Feltzer",	"Remington", "Slamvan", "Blade",
	"Freight", "Streak", "Vortex", "Vincent","Bullet", "Clover", "Sadler", "Firetruck",
	"Hustler", "Intruder", "Primo",	"Cargobob", "Tampa", "Sunrise", "Merit", "Utility",
	"Nevada", "Yosemite","Windsor", "Monster", "Monster", "Uranus", "Jester", "Sultan",
	"Stratium",	"Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito",
    "Freight Flat", "Streak Carriage", "Kart", "Mower", "Dune", "Sweeper","Broadway", "Tornado",
	"AT-400", "DFT-30", "Huntley", "Stafford", "BF-400","News Van", "Tug", "Trailer", "Emperor",
	"Wayfarer", "Euros", "Hotdog", "Club","Freight Box", "Trailer", "Andromeda", "Dodo", "RC Cam",
	"Launch", "Police Car","Police Car", "Police Car", "Police Ranger", "Picador", "S.W.A.T", "Alpha",
 	"Phoenix", "Glendale", "Sadler", "Luggage", "Luggage", "Stairs", "Boxville","Tiller", "Utility Trailer"
};

GetEventStat(playerid)
{
new str[64];
if(PlayerQuest[playerid] == 0){return str;}
new dmid = GetPlayerDM(playerid);
new dmcountdown = Deathmatch[dmid][dm_lineupdelay] - DeathmatchStats[dmid][dm_timer];
new raceid = GetPlayerRace(playerid);
new racecountdown = Race[raceid][race_lineupdelay] - RaceStats[raceid][race_timer];
// %s: in %d seconds
if(Quests[ PlayerQuest[playerid] ][Quest_Type] == 1) // Гонка
{
    if(Race[raceid][race_type] == 0)
    {
		format(str,sizeof(str),"~g~race: ~w~start in ~g~%d ~w~seconds", racecountdown);
	} else if(Race[raceid][race_type] == 3)
	{
	    format(str,sizeof(str),"~b~flight: ~w~start in ~b~%d ~w~seconds", racecountdown);
	} else if(Race[raceid][race_type] == 4)
	{
	    format(str,sizeof(str),"~y~derby: ~w~start in ~y~%d ~w~seconds", racecountdown);
	} else if(Race[raceid][race_type] == 5)
	{
	    format(str,sizeof(str),"~p~multi race: ~w~start in ~p~%d ~w~seconds", racecountdown);
	}
}
else if(Quests[ PlayerQuest[playerid] ][Quest_Type] == 2) // Дм
{
    if(Deathmatch[dmid][dm_type] == 1)
	{
		format(str,sizeof(str),"~r~zombie: ~w~start in ~r~%d ~w~seconds", dmcountdown);
	}
    else if(Deathmatch[dmid][dm_team] == 1)
	{
		format(str,sizeof(str),"~p~tdm: ~w~start in ~p~%d ~w~seconds", dmcountdown);
	} else {
	    format(str,sizeof(str),"~r~dm: ~w~start in ~r~%d ~w~seconds", dmcountdown);
	}
}
else
{
    format(str,sizeof(str),"~h~secondary mission");
}
return str;
}

TD_Create(playerid, show)
{
Speedo[playerid] = TextDrawCreate(320.00, 380.00, "~r~LOAD...");
TextDrawSetOutline(Speedo[playerid], 1);
TextDrawFont(Speedo[playerid], 3);
TextDrawSetShadow(Speedo[playerid],0);
TextDrawSetProportional(Speedo[playerid], 3);
TextDrawAlignment(Speedo[playerid], 2);
TextDrawHideForAll(Speedo[playerid]);
PlayerSpeedSwitch[playerid] = show;
//if(show){TextDrawShowForPlayer(playerid,Speedo[playerid]);}
}

Speed_GetVehicleName(vehicleid)
{
new vname[32] = "unknown";
if(vehicleid == -1) {return vname;}

for(new i=0;i<MAX_PLAYERS;i++)
{
if(!IsPlayerConnected(i)) {continue;}
if(PlCar[i][vid] == -1) {continue;}
if(PlCar[i][vid] == vehicleid) {set(vname,PlCar[i][pcarname]); return vname;}
}
set(vname,CarName[GetVehicleModel(vehicleid)-400]);
return vname;
}

public Speed_UpdateVehName(vehicleid, name[])
{
for(new i=0;i<MAX_PLAYERS;i++)
{
if(!IsPlayerConnected(i)) {continue;}
if(IsPlayerNPC(i)) {continue;}
if(GetPlayerVehicleID(i) == vehicleid) {set(PlayerSpeedoCarName[i], name);}
}
return 1;
}

public Speed_OnGameModeExit()
{
	for(new i=0; i<MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			TextDrawDestroy(Speedo[i]);
		}
	}
	return 1;
}

public Speed_OnPlayerConnect(playerid)
{
TD_Create(playerid, 0);
//PlayerSpeedSwitch[playerid] = 0;
set(PlayerSpeedoCarName[playerid],"loading");
PlayerDM[playerid] = 0;
//PlayerSpeedoCarID[playerid] = -1;
return 1;
}

public Speed_OnPlayerDisconnect(playerid)
{
PlayerSpeedSwitch[playerid] = 0;
TextDrawDestroy(Speedo[playerid]);
set(PlayerSpeedoCarName[playerid],"loading");
PlayerDM[playerid] = 0;
//PlayerSpeedoCarID[playerid] = -1;
return 1;
}

public Speed_OnPlayerSpawn(playerid)
{
//PlayerSpeedSwitch[playerid] = 1;
//TextDrawShowForPlayer(playerid, Speedo[playerid]);
PlayerSpeedSwitch[playerid] = 1;
return 1;
}

public Speed_OnPlayerDeath(playerid)
{
//PlayerSpeedSwitch[playerid] = 1;
TextDrawHideForPlayer(playerid, Speedo[playerid]);
set(PlayerSpeedoCarName[playerid],"loading");
return 1;
}

public Speed_OnPlayerSC(playerid, newstate, oldstate)
{
//PlayerSpeedoCarID[playerid] = -1;
if(IsPlayerNPC(playerid)) {return 1;}

if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
{
//print("SC_LOG");
//PlayerSpeedoCarID[playerid] = GetPlayerVehicleID(playerid);
set(PlayerSpeedoCarName[playerid],Speed_GetVehicleName(GetPlayerVehicleID(playerid))); 

TextDrawHideForPlayer(playerid, Speedo[playerid]);
//PlayerSpeedSwitch[playerid] = 0;
TextDrawDestroy(Speedo[playerid]);
TD_Create(playerid, 1);

}

return 1;
}

new speedstrv[MAX_STRING] = "~g~VEHICLE  ~w~%s ~n~~w~%d  ~b~MPH :: KMH  ~w~%d ~n~~r~VEHICLE HEALTH  ~w~%.2f ~n~%s";
new speedstrf[MAX_STRING] = "~g~LEVEL ~w~%d ~n~%s";
new speedstrf_events[MAX_STRING] = "~g~LEVEL ~w~%d ~n~%s ~n~%s"; // Event stats
new speedstrf_dm[MAX_STRING] = "%s~n~%s"; // dm stat
new speedstrs[MAX_STRING] = "~y~PLAYER  ~w~%s ~n~%s";
new speedstrsv[MAX_STRING] = "~g~VEHICLE ~w~ID %d ~n~%s";

public UpdateSpeed()
{
	new Float:x,Float:y,Float:z;
	new Float:distance,value,string[512], timestr[32], vehid;
	new Float:health;
	new pw = -1;

	set(timestr,XoNow());
	
	for(new i=0; i<MAX_PLAYERS; i++)
	{
		if(!IsPlayerConnected(i)) {continue;}
		if(IsPlayerNPC(i)) {continue;}
		
		pw = i;
		
		if(GetPlayerState(i) == PLAYER_STATE_SPECTATING)
		{
					pw = aspec_GetPlayerSpecID(i);
					if(!aspec_IsPlayerSpecToPlayer(i))
					{
					format(string,sizeof(string),speedstrsv,pw,timestr);
					TextDrawSetString(Speedo[i],string);
					if(PlayerSpeedSwitch[i] == 1) {PlayerSpeedSwitch[i] = 0; TextDrawShowForPlayer(i, Speedo[i]);}
					continue;
					}
		}
		
		//if(IsPlayerInAnyVehicle(pw))
		vehid = GetPlayerVehicleID(pw);
		if(vehid)
		{
			//GetVehicleVelocity(GetPlayerVehicleID(pw),x,y,z);
			//GetVehicleHealth(GetPlayerVehicleID(pw), health);
			GetVehicleVelocity(vehid, x,y,z);
			GetVehicleHealth(vehid, health);
			
			distance = floatsqroot(floatpower(x,2) + floatpower(y,2) + floatpower(z,2));
			value = floatround(distance*200);

			format(string,sizeof(string),speedstrv,PlayerSpeedoCarName[pw],floatround(value/1.6),floatround(value/1),health,timestr);

		}
		else
		{
			if(PlayerDM[pw] > 0 && DMPlayerStats[pw][dm_player_active])
			{
				format(string,sizeof(string),speedstrf_dm,GetDMStat(PlayerDM[pw],pw),timestr);
			} else if(PlayerQuest[pw] != 0){ // Принял участие в соревнованиях
			    new dmid = GetPlayerDM(pw);
			    new raceid = GetPlayerRace(pw);
			    if (DeathmatchStats[dmid][dm_state] == DM_STATE_LINEUP || RaceStats[raceid][race_state] == RACE_STATE_LINEUP)
			    {
					format(string,sizeof(string),speedstrf_events,GetPlayerLevel(pw),timestr,GetEventStat(pw));
				}
			}
			else
			{
				//format(string,sizeof(string),speedstrf,GetPlayerLevel(pw),Compass(pw),timestr);
				format(string,sizeof(string),speedstrf,GetPlayerLevel(pw),timestr);
			}
			
		}
		
		if(i != pw) { format(string,sizeof(string),speedstrs,oGetPlayerName(pw),string); }
		
		TextDrawSetString(Speedo[i],string);

		if(PlayerSpeedSwitch[i] == 1) {PlayerSpeedSwitch[i] = 0; TextDrawShowForPlayer(i, Speedo[i]);}		
	}
}

public speed_JoinDM(playerid,dmid) { PlayerDM[playerid] = dmid; }
public speed_PlayerLeaveDM(playerid) {PlayerDM[playerid] = 0; }
