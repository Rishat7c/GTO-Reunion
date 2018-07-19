//
// Icon Streamer(Стример иконок)
// Version: 2.0.1.0
// Date Created: Unknown
// Date ReCreated: Unknown
// Created by: Rafelder
// Continued by: MadCat
//
//------Beginning----------------------------------------------------------------
#define MAX_ICONS 900
#define MAX_SHOWED_MAPICONS 25 //25 old

new Float:XM[MAX_ICONS];
new Float:YM[MAX_ICONS];
new Float:ZM[MAX_ICONS];

new MarkerM[MAX_ICONS];

new IsValid[MAX_ICONS];
new Show[MAX_PLAYERS][MAX_ICONS];

new IconidM=-1;
new Count=0;
new ShowedForPlayer[MAX_PLAYERS];

forward MapIconsTimer();


stock MapIcons_OnGameModeInit(){
	SetTimer("MapIconsTimer", 1000, 1);
	new logstring[MAX_STRING];
	format(logstring,sizeof(logstring),"Mapicons Streamer Loaded. Map icons: %d",IconidM);
	printf ("SERVER: %s", logstring);
	WriteLog(logstring);
	return 0;
}


stock CreateStreamMapIcon(markerid, Float:X, Float:Y, Float:Z)
{
	if (IconidM >= MAX_ICONS) return 0;
	IconidM++;
	IsValid[IconidM]=1;
	XM[IconidM]=X;
	YM[IconidM]=Y;
	ZM[IconidM]=Z;
	MarkerM[IconidM]=markerid;
	for(new i=0; i<MAX_PLAYERS; i++) {
	Show[i][IconidM]=1;
	}
	return IconidM;
}


stock ResetMapIconVariables(playerid)
{
	for(new i=0; i<MAX_ICONS; i++) {
	Show[playerid][i]=1;
	}
	return 0;
}


stock IsValidMapIcon(iconid)
{
	if (IsValid[iconid] == 1) return 1;
	return 0;
}


stock GetMapIconPos(iconid, &Float:X, &Float:Y, &Float:Z)
{
	if (!IsValidMapIcon(iconid)) return 0;
	X=XM[iconid];
	Y=YM[iconid];
	Z=ZM[iconid];
	return 1;
}


public MapIconsTimer()
{
	for(new i=0; i<MAX_PLAYERS; i++) {
		if (IsPlayerConnected(i)) {
			ShowedForPlayer[i]=0;
			for(new oldm=0; oldm<32; oldm++) {RemovePlayerMapIcon(i, oldm);}
			Count=0;
			for(new m=0; m<MAX_ICONS; m++) {
				if (IsValidMapIcon(m)) {
					if (ShowedForPlayer[i] < MAX_SHOWED_MAPICONS) {
						if (Show[i][m] == 1) {
							if (GetDistanceToMapIcon(i, m) <= 400) {
								SetPlayerMapIcon(i, Count, XM[m], YM[m], ZM[m], MarkerM[m],COLOUR_WHITE);
								ShowedForPlayer[i]++;
								Count++;
							}
						
						}
					}
				}
			}
		}
	}
	return 1;
}
stock GetDistanceToMapIcon(playerid, iconid)
{
	new Float:x1,Float:y1,Float:z1;
	new Float:x2,Float:y2,Float:z2;
	new Float:output;
	GetPlayerPos(playerid, x1, y1, z1);
	GetMapIconPos(iconid, x2, y2, z2);
	output = floatsqroot(floatpower(floatabs(floatsub(x2, x1)), 2)+floatpower(floatabs(floatsub(y2, y1)), 2));
	return floatround(output);
}
//------End----------------------------------------------------------------------
