//
// Created: 04.11.06
// Aurthor: Iain Gilbert, Represent: Dmitry Frolov (FP), Artem Firstov (Konsul)
/*
Last ReCreated by Maxim Tsarkov (OFFREAL)
- - - - -
Добавлена система проверки игроков на читерское оружие
Взрывы теперь происходят в случайных координатах =)
*/

#if defined _admin_commands_included
#endinput
#endif

#define _admin_commands_included
#pragma library admin_commands
#include "base"
#include "utils\gtoutils"
#include "player"
#include "account"
#include "race"
#include "payday"

#define MAX_NICK_ALLOWED_CHARS 65

forward AdminCommandHandler(playerid,text[]);
forward AdminSpecialCommandHandler(playerid,text[]);
forward SendMessageToAdmins(playerid, color, text[]);
forward PushHide(playerid);
forward LoadHide(playerid);

forward SavePlayer(playerid);
forward RemoveOldAcc(name[]);

forward BanLog(string[]);

stock IsSkinValid(SkinID) return ((SkinID >= 0 && SkinID <= 2)||(SkinID == 7)||(SkinID >= 9 && SkinID <= 41)||(SkinID >= 43 && SkinID <= 64)||(SkinID >= 66 && SkinID <= 73)||(SkinID >= 75 && SkinID <= 85)||(SkinID >= 87 && SkinID <= 118)||(SkinID >= 120 && SkinID <= 148)||(SkinID >= 150 && SkinID <= 207)||(SkinID >= 209 && SkinID <= 264)||(SkinID >= 274 && SkinID <= 288)||(SkinID >= 290 && SkinID <= 299)) ? true:false;

// Tick count of the last time the thing was saved.
new Float:LocX[MAX_PLAYERS] = 0.0;
new Float:LocY[MAX_PLAYERS] = 0.0;
new Float:LocZ[MAX_PLAYERS] = 0.0;
new Inter[MAX_PLAYERS] = 0;
new Float:Ang[MAX_PLAYERS];
new Float:VAng[MAX_PLAYERS];

new testOBJ;

new AdminCommandsList[40][24] = {
"/testcmdlist",			//0
"/carinfo",			//1
"/vrecord",			//2
"/ofrecord",		//3
"/stoprecord",		//4
"/add_veh",			//5
"/add_train",		//6
"/del_veh",			//7
"/me2v",			//8
"/add_obj",			//9
"/action",			//10
"/carrep",			//11
"/carresp",			//12
"/setskill",		//13
"/go",				//14
"/go2pack",			//15
"/payday",			//16
"/about",			//17
"/poslog",			//18
"/boom",			//19
"/boomex",			//20
"/setskin",			//21
"/kickall",			//22
"/pinfo",			//23
"/ssay",			//24
"/skydiveall",		//25
"/disarm",			//26
"/disarmall",		//27
"/paralyzeall",		//28
"/deparalyzeall",	//29
"/remcash",			//30
"/remcashall",		//31
"/setlvl",			//32
"/rename",			//33
"/setstatus",		//34
"/setvip",			//35
"/sql_console",		//36
"/resetpass",		//37
"/unbipname",		//38
"/waip"				//39
};

#define POINTSHOMES 44 // 88 если с бизнесами
new Float:PointsH[POINTSHOMES][CoordInfoEx] = {
{2647.597656,-2003.409667,13.382812,0}, //go 0

{1044.264282,-1048.066284,31.700469,0},
{-2689.126220,212.037155,4.328125,0},
{-1910.156005,210.557525,35.156250,0},
{2401.584472,1026.608032,10.812986,0},
{-1346.315307,492.034332,11.202690,0},

{2832.146972,-2529.524658,17.919458,0},
{1738.811523,-2543.253173,13.546875,0},
{-1282.327880,-166.490951,14.148437,0},
{1432.760986,1490.453857,10.820312,0},
{364.079864,2504.678222,16.484375,0},

{1116.208496,-2021.855346,74.429687,0},
{2737.499023,-1760.086181,44.143890,0},
{1223.016357,-1791.427124,33.635219,0},
{1544.125122,-1353.947753,329.473236,0},
{914.587585,-1021.723815,111.054687,0},

{-2233.071289,-1736.994506,480.829284,0},
{1976.502441,1916.305297,130.934509,0},
{302.717712,-1623.151123,114.416259,0},
{2065.416503,2366.291992,150.476562,0},
{2729.579833,2686.808349,59.023437,0},

{-1818.642211,581.224853,234.890625,0},
{2658.831054,-1532.073120,47.054687,0},
{-341.302612,-172.889511,57.487934,0},
{1832.951538,-1315.967773,131.734375,0},
{-1941.218261,134.969512,41.000000,0},

{-2824.375488,2176.859375,180.767562,0},
{1481.328125,-1790.289794,156.753326,0},
{1103.387573,-836.532775,112.982246,0},
{-1406.0547,-252.2674,1043.2554,7}, //стадионы, первый go 29
{-1398.1661,930.7896,1041.5313,15}, // круглый для ДМ запихал в третий

{-1396.110351,903.513671,1041.525390,15},
{-1443.7339,-654.9235,1051.5765,4}, // стадион
{-1474.9556,1643.6835,1052.6749,14},
{-1335.830000,1210.051300,1030.273000,16}, //стадион для сумо
{-1382.912600,1248.640600,1050.070900,16}, //СУМО но уже платформа

{2561.000000,-1290.000000,1032.000000,2},

{-830.0000,504.0000,1359.0000,1}, //bistro yard
{-944.937500,1887.600708,5.005129,17},
{2567.52, -1294.59, 1063.25 ,2},
{246.000 ,112.000 ,1003.22, 10}, //admins house SFPD
{-2378.6611,-2197.8713,32.9649, 0},
{481.16666, 5478.39551, -2.02440, 0},
{341.70801, 5410.60498, 7.54530, 0}

/*
{2109.2126,917.5845,10.8203,0}, //бензоколонки
{2640.1831,1103.9224,10.8203,0},
{611.8934,1694.7921,6.7193,0},
{-1327.5398,2682.9771,49.7896,0},
{-2413.7427,975.9317,45.0031,0},
{-1672.3597,414.2950,6.8866,0},
{-2244.1365,-2560.6294,31.6276,0},
{-1603.0166,-2709.3589,48.2419,0},
{1939.3275,-1767.6813,13.2787,0},
{-94.7651,-1174.8079,1.9979,0},
{1381.6699,462.6467,19.8540,0},
{657.8167,-559.6507,16.0630,0},
{-1478.2916,1862.8318,32.3617,0},
{2147.3054,2744.9377,10.5263,0},
{2204.9602,2480.3494,10.5278,0},
{1590.9493,2202.2637,10.5247,0}
*/
/*
{1459.633178,2773.585205,10.820312,0}, //Gof Club
{418.5547,-80.1667,1001.8047,3}, //Botique
{501.4927,-75.4323,998.7578,11}, //Shithole Bar
{-203.4864,-41.2045,1002.2734,3}, //Tattoo Parlor
{207.5640,-97.8188,1005.2578,15}, //Binco Clothing
{210.1111,-129.1273,1003.5152,16}, //Train Hard Clothing 14?
{203.8557,-40.4717,1001.8047,1}, //Urban Clothing
{210.3724,-8.1825,1005.2109,5}, //Victim Clothing
{161.1875,-79.9915,1001.8047,18}, //Zip Clothing
{204.2810,-157.2614,1000.5234,14}, //DidierSachs Clothing
{773.6138,-72.1616,1000.6484,7}, //Gym
{-2231.2478,131.9623,1035.4141,6}, //Zero RC
{-1951.5938,704.3567,46.5625,0}, //Zombotech
{418.1210,2536.8762,10.0000,10},//Verdant Meadows Air Strip
{252.4851,-57.3515,1.5703,0}, //Blueberry Liquor Store
{500.7049,-13.3777,1000.6797,17}, // Club-Disco
{-225.7790,1403.9459,27.7734,18},//Lil Probe-Inn
{-103.5525,-22.4661,1000.7188,3},//Sex Shop
{1212.3918,-10.9459,1000.9219,2}, //Strip Club
{1208.5027,-32.6044,1000.9531,3}, //The Big Spread Ranch
{-2650.0667,1409.2106,906.2734,3},//Jizzy's Pleasure Domes
{-955.5327,1948.5414,9.0000,17},//The Sherman Dam
{768.2014,-36.9461,1000.6865,6},//Cobra Marital Arts
{357.0584,173.5787,1008.3820,3},//City Planning Department
{823.1819,3.2361,1004.1797,3},//Inside Track
{2131.6455,-1148.2836,24.3898,0},//Coutt and Schutz Auto
{-1657.8334,1207.3041,7.2500,0},//Ottos Auto
{-1957.5327,300.2131,35.4688,0},//Wang Cars
{2235.5408,1679.0402,1008.3594,1},//Caligulas
{1993.9758,1017.8945,994.8906,10}//Four Dragons
*/
};

new renamingstatus = 0;
new savetimer;

public SavePlayer(playerid)
{
if (IsPlayerRegistered(playerid))
{
PlayerSave(playerid);
AccountSave(playerid);
SendClientMessage(playerid, COLOUR_MISC,"Новый аккаунт создан, игра сохранена");
}
else
{
SendClientMessage(playerid, COLOUR_MISC,"Вы не зарегистрированы! Ошибка переименования!");
}
KillTimer(savetimer);
renamingstatus = 0;
return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
    if(IsPlayerAdmin(playerid))
	{
		SetPlayerPosFindZ(playerid, fX, fY, fZ);
	}
    return 1;
}

public AdminCommandHandler(playerid,text[]) // process player commands
{
if (!IsPlayerConnected(playerid)) return 0;
if ( !IsPlayerAdmin(playerid) )
{
return 0;
}

new cmd[20];
new idx;
	
set(cmd,strcharsplit(text, idx,strchar(" ")));

if(strcomp(cmd, AdminCommandsList[0], true) == 1)
{
//SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

//  SendClientMessage(playerid, COLOUR_GREEN, "ADMINISTRATOR RCON:______________________________________________________________");
//  SendClientMessage(playerid, COLOUR_WHITE, "RCON: '/ssay <text>', '/setlvl <ID> <lvl>', '/setstatus <ID> <status> (0, 1-10, 11-256)'");
//  SendClientMessage(playerid, COLOUR_WHITE, "RCON: '/disarm <ID>', '/disarmall', '/skydiveall', '/paralyzeall', '/deparalyzeall', '/remcash <ID>', '/remcashall'");
//  SendClientMessage(playerid, COLOUR_WHITE, "RCON: '/payday', /go <point> (0,1,...,27)', '/pinfo <ID>', '/setskin <ID> <IDskin>', '/kickall'");
//  SendClientMessage(playerid, COLOUR_WHITE, "RCON: '/carrep', '/carresp', '/carinfo', '/boom <IDboom>', '/rename <ID> <new name>'");
//  SendClientMessage(playerid, COLOUR_YELLOW, "SERVER: '/sys cmdlist', '/sys about', '/sys info'");
return 1;
}

if(strcomp(cmd, "/givexp", true) == 1)
{

//if (strcomp(oGetPlayerName(playerid), ScripterName[2], true) == 0) {return 0;}

SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

new receiverid;
receiverid = strval(strcharsplit(text, idx,strchar(" ")));
if ((receiverid < 0) || (receiverid >= MAX_PLAYERS) || (IsPlayerAdmin(receiverid) && !IsPlayerAdmin(playerid)) )
{
SendPlayerFormattedText(playerid, lang_texts[12][2] , 0,COLOUR_RED);
return 1;
}

if (IsPlayerConnected(receiverid) == 0)
{
SendPlayerFormattedText(playerid, lang_texts[12][3] , 0,COLOUR_RED);
return 1;
}

new xpamount;
xpamount = strval(strcharsplit(text, idx,strchar(" ")));

if ((xpamount == 0) || (xpamount > MAX_LVLXP))
{
SendPlayerFormattedText(playerid, lang_texts[12][4] , 0,COLOUR_RED);
return 1;
}

/*
new xpamountkeep;
xpamountkeep = GetPlayerXP(receiverid)+xpamount;

if ((!IsPlayerAdmin(receiverid) && xpamountkeep >MAX_LVLXP) || (IsPlayerAdmin(receiverid) && xpamountkeep > MAX_XP))
{
    SendPlayerFormattedText(playerid, lang_texts[12][40] , 0,COLOUR_RED);
	if (IsPlayerAdmin(receiverid))
	{
	xpamount = xpamountkeep-MAX_XP;
	} else {
	xpamount = xpamountkeep-MAX_LVLXP;
	}
}
*/
if ((GetPlayerXP(receiverid) + xpamount) < 0) // if after add xp, playerxp < 0
{
SetPlayerXP(receiverid, 0);
}
else if ((GetPlayerXP(receiverid) + xpamount) > MAX_LVLXP) // if after add, playerxp > MAX
{
SetPlayerXP(receiverid, MAX_LVLXP);
}
else { SetPlayerXP(receiverid,GetPlayerXP(receiverid)+xpamount); }

//GivePlayerXP(receiverid,xpamount,0);
//SetPlayerXP(receiverid,Player[receiverid][XP]+xpamount);
//Player[receiverid][XP]=GetPlayerXP(receiverid);

CheckPlayerLevel(receiverid);
new string[MAX_STRING];

if (xpamount > 0)
{
format(string,sizeof(string), lang_texts[12][5] ,oGetPlayerName(playerid),xpamount);
SendPlayerFormattedText(receiverid,string, 0,COLOUR_XP_GOOD);

format(string,sizeof(string), lang_texts[12][6] ,oGetPlayerName(receiverid),xpamount,GetPlayerXP(receiverid));
SendPlayerFormattedText(playerid,string, 0,COLOUR_XP_GOOD);
}
else
{
format(string,sizeof(string), lang_texts[12][7] ,oGetPlayerName(playerid),xpamount);
SendPlayerFormattedText(receiverid,string, 0,COLOUR_XP_GOOD);

format(string,sizeof(string), lang_texts[12][8] ,oGetPlayerName(receiverid),xpamount,GetPlayerXP(receiverid));
SendPlayerFormattedText(playerid,string, 0,COLOUR_XP_GOOD);
}

return 1;
}


if((strcomp(cmd, "/agivecash", true) == 1) || (strcomp(cmd, "/asm", true) == 1))
{

//if (strcomp(oGetPlayerName(playerid), ScripterName[2], true) == 0) {return 0;}

SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

new receiverid;
receiverid = strval(strcharsplit(text, idx,strchar(" ")));

if ((receiverid < 0) || (receiverid >= MAX_PLAYERS) || (IsPlayerAdmin(receiverid) && !IsPlayerAdmin(playerid)) )
{
SendPlayerFormattedText(playerid, lang_texts[12][9] , 0,COLOUR_RED);
return 1;
}

if (IsPlayerConnected(receiverid) == 0)
{
SendPlayerFormattedText(playerid, lang_texts[12][10] , 0,COLOUR_RED);
return 1;
}

new cashamount;
cashamount = strval(strcharsplit(text, idx,strchar(" ")));

if ((cashamount < -99999999) || (cashamount == 0) || (cashamount > 99999999))
{
SendPlayerFormattedText(playerid, lang_texts[12][11] , 0,COLOUR_RED);
return 1;
}

oGivePlayerMoney(receiverid,cashamount,1);

new string[MAX_STRING];

if (cashamount > 0)
{
format(string,sizeof(string), lang_texts[12][12] ,oGetPlayerName(playerid),cashamount);
SendPlayerFormattedText(receiverid,string, 0,COLOUR_XP_GOOD);

format(string,sizeof(string), lang_texts[12][13] ,oGetPlayerName(receiverid),cashamount,GetPlayerMoney(receiverid));
SendPlayerFormattedText(playerid,string, 0,COLOUR_XP_GOOD);
}
else
{
format(string,sizeof(string), lang_texts[12][14] ,oGetPlayerName(playerid),cashamount);
SendPlayerFormattedText(receiverid,string, 0,COLOUR_XP_GOOD);

format(string,sizeof(string), lang_texts[12][15] ,oGetPlayerName(receiverid),cashamount,GetPlayerMoney(receiverid));
SendPlayerFormattedText(playerid,string, 0,COLOUR_XP_GOOD);
}
return 1;
}


if ((strcomp(cmd, AdminCommandsList[1], true) == 1) && IsPlayerInAnyVehicle(playerid) )
{
//SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

new Float:x3;
new Float:y3;
new Float:z3;
new Float:zangle3;
new Float:health3;
GetVehiclePos(GetPlayerVehicleID(playerid), x3, y3, z3);
GetVehicleZAngle(GetPlayerVehicleID(playerid), zangle3);
GetVehicleHealth(GetPlayerVehicleID(playerid), health3);
new string[256];
format(string,sizeof(string), lang_texts[11][11] , GetVehicleModel(GetPlayerVehicleID(playerid)), GetPlayerVehicleID(playerid), health3, x3, y3, z3, zangle3);
SendPlayerFormattedText(playerid, string, 0,COLOUR_WHITE);
return 1;
}


 	if(strcomp(cmd, AdminCommandsList[2], true) == 1) {
	    new tmp[512];
      	tmp = strtok(text, idx);
		if(!strlen(tmp)) {
			SendClientMessage(playerid,0xFF0000FF,"Usage: /vrecord {name}");
			return 1;
		}
		if(!IsPlayerInAnyVehicle(playerid)) {
            SendClientMessage(playerid,0xFF0000FF,"Recording: Get in a vehicle.");
			return 1;
		}
//-------------------------------------------				
// if(LocX[playerid] == 0.0 && LocY[playerid] == 0.0 && LocZ[playerid] == 0.0) {
// new string[MAX_STRING];
// format(string,sizeof(string), lang_texts[12][69]);
// SendPlayerFormattedText(playerid,string, 0,COLOUR_RED);
// } else {
	// if(IsPlayerInAnyVehicle(playerid)) {
		// new VehicleID;
		// VehicleID = GetPlayerVehicleID(playerid);
		// SetVehiclePosEx(VehicleID, LocX[playerid], LocY[playerid], LocZ[playerid] );
		// SetVehicleZAngle(VehicleID, VAng[playerid] );
		// LinkVehicleToInterior(VehicleID, Inter[playerid] );
		// } else {
			// SetPlayerPosEx(playerid, LocX[playerid], LocY[playerid], LocZ[playerid] );
			// SetPlayerFacingAngle(playerid, Ang[playerid] );
			// }
	// SetPlayerInterior(playerid, Inter[playerid] );
	// new string[MAX_STRING];
	// format(string,sizeof(string), lang_texts[12][70]);
	// SendPlayerFormattedText(playerid,string, 0,COLOUR_XP_GOOD);
	// }
//-------------------------------------------	
	StartRecordingPlayerData(playerid,PLAYER_RECORDING_TYPE_DRIVER,tmp);
	SendClientMessage(playerid,0xFF0000FF,"Recording: started.");
		
		return 1;
	}


 	if(strcomp(cmd, AdminCommandsList[3], true) == 1) {
	    new tmp[512];
      	tmp = strtok(text, idx);
		if(!strlen(tmp)) {
			SendClientMessage(playerid,0xFF0000FF,"Usage: /ofrecord {name}");
			return 1;
		}
 		if(IsPlayerInAnyVehicle(playerid)) {
            SendClientMessage(playerid,0xFF0000FF,"Recording: Leave the vehicle and reuse the command.");
			return 1;
		}
		StartRecordingPlayerData(playerid,PLAYER_RECORDING_TYPE_ONFOOT,tmp);
		SendClientMessage(playerid,0xFF0000FF,"Recording: started.");
		return 1;
	}
	
	// Stop recording any data
	if(strcomp(cmd, AdminCommandsList[4], true) == 1) {
		StopRecordingPlayerData(playerid);
//-------------------------------------------		
// GetPlayerPos(playerid, LocX[playerid], LocY[playerid], LocZ[playerid] );
// if(IsPlayerInAnyVehicle(playerid))
// {
// new VehicleID;
// VehicleID = GetPlayerVehicleID(playerid);
// GetVehicleZAngle(VehicleID, VAng[playerid]);
// }
// else
// {
// GetPlayerFacingAngle(playerid, Ang[playerid] );
// }
// Inter[playerid] = GetPlayerInterior(playerid);
// new string[MAX_STRING];
// format(string,sizeof(string), lang_texts[12][68] ,LocX[playerid],LocY[playerid],LocZ[playerid],Ang[playerid],Inter[playerid]);
// SendPlayerFormattedText(playerid,string, 0,COLOUR_XP_GOOD);
//-------------------------------------------		
		SendClientMessage(playerid,0xFF0000FF,"Recording: stopped.");
		return 1;
	}

	if(strcomp( cmd, AdminCommandsList[5], true ) == 1 )
	{
		new Float:X, Float:Y, Float:Z;
		new tmp[256];
		new created_vehicle_id;
		new vw;
		tmp = strtok( text, idx );

		GetPlayerPos( playerid, X, Y, Z );
		
		//if((strval(tmp) == 537) || (strval(tmp) == V_STREAK)) {created_vehicle_id = AddStaticVehicleEx( strval(tmp), X+2, Y+2, Z, 0, 0, 0, -1 );}
		
        vw = GetPlayerVirtualWorld(playerid);
		//else {
		created_vehicle_id = CreateVehicle( strval(tmp), X+2, Y+2, Z, 0, -1, -1, -1 );
		SetVehicleVirtualWorld ( created_vehicle_id, vw );
		//}

		new msg[256];
		format(msg,256,"Created vehicle: %d",created_vehicle_id);
		SendClientMessage(playerid,0xAAAAAAAA,msg);

		return 1;
	}
	
	if(strcomp( cmd, AdminCommandsList[6], true ) == 1 )
	{
		new Float:X, Float:Y, Float:Z;
		new tmp[256];
		new created_vehicle_id;
		tmp = strtok( text, idx );

		GetPlayerPos( playerid, X, Y, Z );

		created_vehicle_id = AddStaticVehicleEx( strval(tmp), X+2, Y+2, Z, 0, -1, -1, -1 );

		new msg[256];
		format(msg,256,"Created vehicle: %d",created_vehicle_id);
		SendClientMessage(playerid,0xAAAAAAAA,msg);

		return 1;
	}

	if(strcomp( cmd, AdminCommandsList[7], true ) == 1 )
	{
		new tmp[256];
		tmp = strtok( text, idx );

		DestroyVehicle( strval(tmp) );

		new msg[256];
		format(msg,256,"Destroyed vehicle: %d",strval(tmp));
		SendClientMessage(playerid,0xAAAAAAAA,msg);

		return 1;
	}
	
		if (strcomp(cmd, AdminCommandsList[8], true) == 1)
	{
	  	new tmp[256];
		tmp = strtok(text,idx);
		PutPlayerInVehicleEx(playerid,strval(tmp),0);
	    return 1;
	}
	
if( strcomp(cmd, AdminCommandsList[9], true) == 1 )
{
new Float:X, Float:Y, Float:Z, Float:A;
new obid;
obid = strval(strcharsplit(text, idx,strchar(" ")));
GetPlayerPos(playerid,X,Y,Z);
GetPlayerFacingAngle(playerid, A);
if (testOBJ == 0)
{
testOBJ = CreateObject(obid, X + Get_dx(A,10), Y + Get_dy(A,10), Z, 0, 0, 0);
}
else
{
DestroyObject(testOBJ);
testOBJ = 0;
}
return 1;
}

if(strcomp(cmd, AdminCommandsList[10], true) == 1)
{
new rid, aid;
rid = strval(strcharsplit(text, idx,strchar(" ")));
aid = strval(strcharsplit(text, idx,strchar(" ")));
SetPlayerSpecialAction(rid,aid);
return 1;
}
	
if ((strcomp(cmd, AdminCommandsList[11], true) == 1) && IsPlayerInAnyVehicle(playerid) )
{
//SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

SetVehicleHealth(GetPlayerVehicleID(playerid), 1000.0);
RepairVehicle(GetPlayerVehicleID(playerid));
new string[MAX_STRING];
format(string,sizeof(string), lang_texts[11][12] , GetPlayerVehicleID(playerid) );
SendPlayerFormattedText(playerid, string, 0,COLOUR_WHITE);
return 1;
}

if ((strcomp(cmd, AdminCommandsList[12], true) == 1) && IsPlayerInAnyVehicle(playerid) )
{
//SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

//SetVehicleHealth(GetPlayerVehicleID(playerid), 1.0);
SetVehicleToRespawn(GetPlayerVehicleID(playerid));
new string[MAX_STRING];
format(string,sizeof(string), lang_texts[11][13] , GetPlayerVehicleID(playerid) );
SendPlayerFormattedText(playerid,string, 0,COLOUR_WHITE);
return 1;
}

	if(strcomp(cmd, AdminCommandsList[13], true) == 1)
	{
	
	    //if (strcomp(oGetPlayerName(playerid), ScripterName[2], true) == 0) {return 0;}
	
		new tmpstr[MAX_STRING];
		set(tmpstr,strcharsplit(text, idx,strchar(" ")));
		
		if(!strlen(tmpstr))
		{
		format(tmpstr,sizeof(tmpstr),"playerid - ??? Использование: '%s playerid skillid value'",AdminCommandsList[13]);
		SendClientMessage(playerid, 0xFFFFFFFF, tmpstr);
		return 1;
		}
		
	    new tmp1 = INVALIDX_PLAYER_ID;
		tmp1 = strval(tmpstr);
		
		if(tmp1 < 0)
		{
		SendClientMessage(playerid,0xFFFFFFFF, "Неверный id игрока!");
		return 1;
		}
		
		if(!IsPlayerConnected(tmp1))
		{
		SendClientMessage(playerid,0xFFFFFFFF, "Игрок OFFLINE");
		return 1;
		}
		
		set(tmpstr,strcharsplit(text, idx,strchar(" ")));
		
		if(!strlen(tmpstr))
		{
		format(tmpstr,sizeof(tmpstr),"skillid - ??? Использование: '%s playerid skillid value'",AdminCommandsList[13]);
		SendClientMessage(playerid, 0xFFFFFFFF, tmpstr);
		return 1;
		}
		
	  	new tmp2;
		tmp2 = strval(tmpstr);
		
		if(tmp2 < 0 || tmp2 >= WEAPONS_SKILLS)
		{
		format(tmpstr,sizeof(tmpstr),"Неверный skillid, используйте 0-%d",WEAPONS_SKILLS-1);
		SendClientMessage(playerid, 0xFFFFFFFF, tmpstr);
		return 1;
		}
		
		set(tmpstr,strcharsplit(text, idx,strchar(" ")));
		
		if(!strlen(tmpstr))
		{
		format(tmpstr,sizeof(tmpstr),"value - ??? Использование: '%s playerid skillid value'",AdminCommandsList[13]);
		SendClientMessage(playerid, 0xFFFFFFFF, tmpstr);
		return 1;
		}
		
		new tmp3;
		tmp3 = strval(tmpstr);
		
		if(tmp3 < 0 || tmp3 > MAX_SKILL)
		{
		format(tmpstr,sizeof(tmpstr),"Неверное значение, используйте 0 - %d",MAX_SKILL);
		SendClientMessage(playerid, 0xFFFFFFFF, tmpstr);
		return 1;
		}
		
		//tmp3--;
		
		PlayerWeaponsSkill[tmp1][tmp2] = tmp3;
		SetPlayerSkillLevel(tmp1, tmp2, tmp3);
		
		format(tmpstr,sizeof(tmpstr),"Вы установили игроку %s навык владения оружием %s[id %d] равный %d",oGetPlayerName(tmp1),SkillNames[tmp2],tmp2,tmp3);
		SendClientMessage(playerid, 0xFFFFFFFF, tmpstr);
		
		format(tmpstr,sizeof(tmpstr),"Администратор установил вам навык владения оружием %s[id %d] равный %d",SkillNames[tmp2],tmp2,tmp3);
		SendClientMessage(tmp1, 0xFFFFFFFF, tmpstr);
		
		return 1;
	}
	
/*	if(strcomp(cmd, "/loadtr", true) == 1)
	{
		new tmp;
		tmp = strval(strcharsplit(text, idx,strchar(" ")));
	  	new tmp2;
		tmp2 = strval(strcharsplit(text, idx,strchar(" ")));

		if (IsPlayerInAnyVehicle(playerid))
		{
			if (GetVehicleModel(GetPlayerVehicleID(playerid)) == 403 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 514 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 515)
			{
				if (GetVehicleModel(GetVehicleTrailer(GetPlayerVehicleID(playerid))) == 584)
				{
					new tempz1;
					for(new f=0; f < sizeof(LoadTrailer);f++)
					{
						if(GetVehicleTrailer(GetPlayerVehicleID(playerid)) == LoadTrailer[f])
						{
						tempz1 = f;
						}
					}
					IsLoadTrailerTip[tempz1] = tmp;
					IsLoadTrailer[tempz1] = tmp2;						
					SendClientMessage(playerid, 0xFFFFFFFF, "вы изменили груз /cargo");
				}
			}
		}
		return 1;
	}*/

/*    if (strcomp(cmd, "/myspeed", true) == 1 && IsPlayerInAnyVehicle(playerid))
    {
        new Float:Velocity[3], output[80];
	GetVehicleVelocity(GetPlayerVehicleID(playerid), Velocity[0], Velocity[1], Velocity[2]);
        format(output, sizeof(output), "You are going at a velocity of X%f, Y%f, Z%f", Velocity[0], Velocity[1], Velocity[2]);
        SendClientMessage(playerid, 0xFFFFFFFF, output);
	return 1;
    } */

if (strcomp(cmd, AdminCommandsList[14], true) == 1)
{
//SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

new pointt;
pointt = strval(strcharsplit(text, idx,strchar(" ")));
if ((pointt < 0) || (pointt >= POINTSHOMES) ) {return 1;}

if( IsPlayerInAnyVehicle(playerid) ) {
//They're in a vehicle. Transport it, too.
new VehicleID;
VehicleID = GetPlayerVehicleID(playerid);
SetPlayerInterior(playerid,PointsH[pointt][Coord_I]);
SetVehiclePosEx(VehicleID, PointsH[pointt][Coord_X], PointsH[pointt][Coord_Y], PointsH[pointt][Coord_Z]);
LinkVehicleToInterior(VehicleID,PointsH[pointt][Coord_I]);
} else {
    SetPlayerInterior(playerid,PointsH[pointt][Coord_I]);
	SetPlayerPosEx(playerid, PointsH[pointt][Coord_X], PointsH[pointt][Coord_Y], PointsH[pointt][Coord_Z]);
	}

new string[MAX_STRING];
format(string,sizeof(string), lang_texts[12][92] , pointt );
SendPlayerFormattedText(playerid,string, 0,COLOUR_WHITE);
return 1;
}

/*
if (strcomp(cmd, "/goazs", true) == 1)
{
//SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

new pointt;
pointt = strval(strcharsplit(text, idx,strchar(" ")));
if ((pointt < 0) || (pointt >= 16) ) {return 1;}

if( IsPlayerInAnyVehicle(playerid) ) {
//They're in a vehicle. Transport it, too.
new VehicleID;
VehicleID = GetPlayerVehicleID(playerid);
//SetPlayerInterior(playerid,PointsH[pointt][Coord_I]);
SetVehiclePosEx(VehicleID, TDMarkersPetrol[pointt][Coord_X], TDMarkersPetrol[pointt][Coord_Y], TDMarkersPetrol[pointt][Coord_Z]);
//LinkVehicleToInterior(VehicleID,PointsH[pointt][Coord_I]);
} else {
    //SetPlayerInterior(playerid,PointsH[pointt][Coord_I]);
	SetPlayerPosEx(playerid, TDMarkersPetrol[pointt][Coord_X], TDMarkersPetrol[pointt][Coord_Y], TDMarkersPetrol[pointt][Coord_Z]);
	}

new string[MAX_STRING];
format(string,sizeof(string), lang_texts[12][92] , pointt );
SendPlayerFormattedText(playerid,string, 0,COLOUR_WHITE);
return 1;
}
*/

if (strcomp(cmd, AdminCommandsList[15], true) == 1)
{
	new packid;
	packid = strval(strcharsplit(text, idx,strchar(" ")));
	if ((packid < 0) || (packid >= PACKINGAME) ) {return 1;}
	if( IsPlayerInAnyVehicle(playerid) ) {
		new VehicleID;
		VehicleID = GetPlayerVehicleID(playerid);
        SetVehiclePosEx(VehicleID, PackAllCoords[PackNowCoords[packid]][Coord_X],PackAllCoords[PackNowCoords[packid]][Coord_Y],PackAllCoords[PackNowCoords[packid]][Coord_Z]);
		} else {
		SetPlayerPosEx(playerid, PackAllCoords[PackNowCoords[packid]][Coord_X]+1,PackAllCoords[PackNowCoords[packid]][Coord_Y]+1,PackAllCoords[PackNowCoords[packid]][Coord_Z]);
		}
	return 1;
}


if(strcomp(cmd, AdminCommandsList[16], true) == 1)
{
admpayday=256;
PayDay();
  SendClientMessage(playerid, COLOUR_WHITE, lang_texts[12][90]);
return 1;
}

if(strcomp(cmd, AdminCommandsList[17], true) == 1)
{
//SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

  SendClientMessage(playerid, COLOUR_GREEN, "ADMINISTRATOR RCON:______________________________________________________________");
  SendClientMessage(playerid, COLOUR_LIGHTRED, lang_texts[15][51]);
  SendClientMessage(playerid, COLOUR_WHITE, lang_texts[15][52]);
  SendClientMessage(playerid, COLOUR_WHITE, lang_texts[15][53]);
  SendClientMessage(playerid, COLOUR_WHITE, lang_texts[15][54]);
  SendClientMessage(playerid, COLOUR_YELLOW, lang_texts[15][55]);
return 1;
}

if(strcomp(cmd, AdminCommandsList[18], true) == 1)
{
new comment[48];
set(comment,strcharsplit(text, idx,strchar(" ")));
new str[128];
new Float:X;
new Float:Y;
new Float:Z;
new Float:A;
if(IsPlayerInAnyVehicle(playerid))
{
GetVehiclePos(GetPlayerVehicleID(playerid), X, Y, Z);
GetVehicleZAngle(GetPlayerVehicleID(playerid), A);
format(str,sizeof(str),"[POS][veh][%s][ %.3f, %.3f, %.3f %.3f][%s]",oGetPlayerName(playerid), X,Y,Z,A,comment);
}
else
{
GetPlayerPos(playerid,X,Y,Z);
GetPlayerFacingAngle(playerid,A);
format(str,sizeof(str),"[POS][ped][%s][ %.3f, %.3f, %.3f %.3f][%s]",oGetPlayerName(playerid), X,Y,Z,A,comment);
}
//printf("{%.3f, %.3f, %.3f}",X,Y,Z);
WriteLog(str);
SendClientMessage(playerid, COLOUR_GREEN, str);
return 1;
}

if(strcomp(cmd, AdminCommandsList[19], true) == 1)
{

new bomamount;
bomamount = strval(strcharsplit(text, idx,strchar(" ")));
new Float:X;
new Float:Y;
new Float:Z;
GetPlayerPos(playerid,X,Y,Z);
new dX = minrand(-20, 20);
new dY = minrand(-20,20);
CreateExplosion((X+dX), (Y+dY), (Z+2), bomamount, 30);
return 1;
}

if(strcomp(cmd, AdminCommandsList[20], true) == 1)
{

new bomamount;
bomamount = strval(strcharsplit(text, idx,strchar(" ")));
new Float:X;
new Float:Y;
new Float:Z;
new Float:A, Float:dX, Float:dY;
GetPlayerPos(playerid,X,Y,Z);
GetPlayerFacingAngle(playerid,A);
dX = Get_dx(A, 20.0);
dY = Get_dy(A, 20.0);
CreateExplosion((X+dX), (Y+dY), (Z+2), bomamount, 30);
return 1;
}

if(strcomp(cmd, AdminCommandsList[21], true) == 1)
{
//SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

new receiverid;
receiverid=INACTIVE_PLAYER_ID;

receiverid = strval(strcharsplit(text, idx,strchar(" ")));
if ( (receiverid < 0) || (receiverid >= MAX_PLAYERS)  || (IsPlayerAdmin(receiverid) && !IsPlayerAdmin(playerid)) )
{
SendPlayerFormattedText(playerid, lang_texts[12][2] , 0,COLOUR_RED);	// не тот ИД
return 1;
}
if (IsPlayerConnected(receiverid) == 0)
{
SendPlayerFormattedText(playerid, lang_texts[12][3] , 0,COLOUR_RED);	//игрок в офф
return 1;
}
new sknamount;
sknamount = strval(strcharsplit(text, idx,strchar(" ")));
//if ((sknamount < 100) || (sknamount > 188))

if(!IsValidSkin(sknamount))
{
SendPlayerFormattedText(playerid, lang_texts[12][41] , 0,COLOUR_RED);	//Не тот скин!
return 1;
}

new sknkeep;
sknkeep = GetPlayerSkin(receiverid);
SetPlayerSkin(receiverid, sknamount);
Player[receiverid][SkinModel] = sknamount;
new string[MAX_STRING];
format(string,sizeof(string), lang_texts[12][42] ,oGetPlayerName(playerid),sknamount);
SendPlayerFormattedText(receiverid,string, 0,COLOUR_XP_GOOD);
format(string,sizeof(string), lang_texts[12][43] ,oGetPlayerName(receiverid),sknamount,sknkeep);
SendPlayerFormattedText(playerid,string, 0,COLOUR_XP_GOOD);
return 1;
}

if(strcmp(cmd, AdminCommandsList[22], true) == 0)
{
//SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);
new string[256];
new admin[256];
if (IsPlayerAdmin(playerid)){
GetPlayerName(playerid,admin,sizeof(admin));
format(string,sizeof(string), lang_texts[12][91] ,admin);
SendClientMessageToAll(COLOR_WHITE,string);
for(new i = 0; i < MAX_PLAYERS; i++)
{
Kick(i);
}
}
return 1;
}

if(strcomp(cmd, AdminCommandsList[23], true) == 1)
{
//SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

new receiverid;
receiverid=INACTIVE_PLAYER_ID;

receiverid = strval(strcharsplit(text, idx,strchar(" ")));
if ((receiverid < 0) || (receiverid >= MAX_PLAYERS))
{
SendPlayerFormattedText(playerid, lang_texts[12][2] , 0,COLOUR_RED);
return 1;
}
if (IsPlayerConnected(receiverid) == 0)
{
SendPlayerFormattedText(playerid, lang_texts[12][3] , 0,COLOUR_RED);
return 1;
}
new string[MAX_STRING];
format(string,sizeof(string), lang_texts[12][34] ,oGetPlayerName(receiverid),receiverid);
SendPlayerFormattedText(playerid,string, 0,COLOUR_YELLOW);

new sid;
sid=Player[receiverid][Status];
if (sid>0 && sid<10) {format(string,sizeof(string),lang_texts[12][87],sid);}
else if (sid>10) {format(string,sizeof(string),lang_texts[12][86],sid);}
else {format(string,sizeof(string),lang_texts[12][88]);}
//Status
SendPlayerFormattedText(playerid,string, 0,COLOUR_LIGHTRED);

format(string,sizeof(string), lang_texts[12][35] ,Player[receiverid][Level],Player[receiverid][XP]);	//Level, XP
SendPlayerFormattedText(playerid,string, 0,COLOUR_WHITE);
format(string,sizeof(string), lang_texts[12][36] ,Player[receiverid][Money],Player[receiverid][Bank]);	//Money, Bank
SendPlayerFormattedText(playerid,string, 0,COLOUR_WHITE);

format(string,sizeof(string), lang_texts[12][38] ,Player[receiverid][Deaths],Player[receiverid][Kills]);	//Kills, Deaths
SendPlayerFormattedText(playerid,string, 0,COLOUR_WHITE);
format(string,sizeof(string), lang_texts[12][71] ,Player[receiverid][Jailed],Player[receiverid][Muted]);	//Jailed, Muted
SendPlayerFormattedText(playerid,string, 0,COLOUR_WHITE);

new oPlayerIP[256];
GetPlayerIp(receiverid,oPlayerIP,256);
format(string,sizeof(string), lang_texts[12][72] ,GetPlayerPing(receiverid),oPlayerIP);
SendPlayerFormattedText(playerid,string, 0,COLOUR_WHITE);
return 1;
}


if(strcomp(cmd, AdminCommandsList[24], true) == 1)
{
//SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

new string[MAX_STRING];
set(string,text);
strdel(string, 0, idx);
format(string,sizeof(string), lang_texts[12][1] ,string);
SendClientMessageToAll(COLOUR_YELLOW, string);
return 1;
}

if(strcomp(cmd, AdminCommandsList[25], true) == 1)
{
//SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

new string[MAX_STRING];
new Float:playerx,Float:playery,Float:playerz;

for (new id = 0; id < MAX_PLAYERS; id++)
{
if (IsPlayerConnected(id) && (Player[id][Jailed] == 0) && !IsPlayerInAnyDM(id) &&!IsPlayerNPC(id))
	{
	GivePlayerWeapon(id,46,1);
	GetPlayerPos(id,playerx,playery,playerz);
	PlayerPlaySound(id,1058,0,0,0);
	SetPlayerPosEx(id,playerx,playery,playerz+1200);
	}
if (Player[id][Jailed] == 1)
	{
	SendPlayerFormattedText(id, lang_texts[1][22], 0,COLOUR_LIGHTRED);
	}
}
SendClientMessageToAll(COLOUR_WHITE,lang_texts[1][19]);
format(string,sizeof(string), lang_texts[1][20]);
GameTextForAll(string,5000,6);

//	format(string,sizeof(string), lang_texts[1][21] ,oGetPlayerName(playerid),playerid);
//	SendClientMessageToRegistered(COLOUR_GREY, string);
return 1;
}


if(strcomp(cmd, AdminCommandsList[26], true) == 1)
{
//SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

new receiverid;
receiverid = strval(strcharsplit(text, idx,strchar(" ")));
if ((receiverid < 0) || (receiverid >= MAX_PLAYERS))
{
SendPlayerFormattedText(playerid, lang_texts[12][9] , 0,COLOUR_RED);
return 1;
}
if ( (IsPlayerConnected(receiverid) == 0) && !IsPlayerInAnyDM(receiverid) )
{
SendPlayerFormattedText(playerid, lang_texts[12][10] , 0,COLOUR_RED);
return 1;
}
ResetPlayerWeapons(receiverid);
for (new i=1;i<MAX_WEAPONS;i++)
{
	PlayerWeapons[receiverid][i] = 0;
}

new string[MAX_STRING];
format(string,sizeof(string), lang_texts[12][48] ,oGetPlayerName(playerid));			//игроку
SendPlayerFormattedText(receiverid,string, 0,COLOUR_XP_GOOD);
format(string,sizeof(string), lang_texts[12][49] ,oGetPlayerName(receiverid));
SendPlayerFormattedText(playerid,string, 0,COLOUR_XP_GOOD);
return 1;
}



if(strcomp(cmd, AdminCommandsList[27], true) == 1)
{
//SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

new string[MAX_STRING];
for (new id = 0; id < MAX_PLAYERS; id++)
{
if ( (id < playerid) || (id > playerid) )
	{
	if (IsPlayerConnected(id) && (Player[id][Jailed] == 0) && !IsPlayerInAnyDM(id) )
		{
		if (IsPlayerConnected(id) == 0) { return 0; }
		if (IsPlayerAdmin(id) == 1) { return 0; }
		ResetPlayerWeapons(id);
		for (new i=1;i<MAX_WEAPONS;i++)
		{
		PlayerWeapons[id][i] = 0;
		}
		format(string,sizeof(string), lang_texts[12][48] ,oGetPlayerName(playerid));	//игроку
		SendPlayerFormattedText(id,string, 0,COLOUR_XP_GOOD);
		}
	}
}
format(string,sizeof(string), lang_texts[12][75]);
SendPlayerFormattedText(playerid,string, 0,COLOUR_XP_GOOD);
return 1;
}


if(strcomp(cmd, AdminCommandsList[28], true) == 1)
{
//SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

new string[MAX_STRING];
for (new id = 0; id < MAX_PLAYERS; id++)
{
if ( (id < playerid) || (id > playerid) )
	{
	if (IsPlayerConnected(id) && (Player[id][Jailed] == 0) && !IsPlayerInAnyDM(id) && !IsPlayerNPC(id))
		{
		if (IsPlayerConnected(id) == 0) { return 0; }
		if (IsPlayerAdmin(id) == 1) { return 0; }
		TogglePlayerControllable(id,0);
		format(string,sizeof(string), lang_texts[12][54] ,oGetPlayerName(playerid));//игроку
		SendPlayerFormattedText(id,string, 0,COLOUR_XP_GOOD);
		}
	}
}
format(string,sizeof(string), lang_texts[12][76]);
SendPlayerFormattedText(playerid,string, 0,COLOUR_XP_GOOD);
return 1;
}


if(strcomp(cmd, AdminCommandsList[29], true) == 1)
{
//SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

new string[MAX_STRING];
for (new id = 0; id < MAX_PLAYERS; id++)
{
if ( (id < playerid) || (id > playerid) )
	{
	if (IsPlayerConnected(id) && (Player[id][Jailed] == 0) && !IsPlayerInAnyDM(id) )
		{
		if (IsPlayerConnected(id) == 0) { return 0; }
		if (IsPlayerAdmin(id) == 1) { return 0; }
		TogglePlayerControllable(id,1);
		format(string,sizeof(string), lang_texts[12][56] ,oGetPlayerName(playerid));//игроку
		SendPlayerFormattedText(id,string, 0,COLOUR_XP_GOOD);
		}
	}
}
format(string,sizeof(string), lang_texts[12][77]);
SendPlayerFormattedText(playerid,string, 0,COLOUR_XP_GOOD);
return 1;
}

if(strcomp(cmd, AdminCommandsList[30], true) == 1)
{
//SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

new receiverid;
receiverid = strval(strcharsplit(text, idx,strchar(" ")));
if ((receiverid < 0) || (receiverid >= MAX_PLAYERS) || (IsPlayerAdmin(receiverid) && !IsPlayerAdmin(playerid)) )
{
SendPlayerFormattedText(playerid, lang_texts[12][9] , 0,COLOUR_RED);
return 1;
}
if (IsPlayerConnected(receiverid) == 0)
{
SendPlayerFormattedText(playerid, lang_texts[12][10] , 0,COLOUR_RED);
return 1;
}
ResetPlayerMoney(receiverid);

new string[MAX_STRING];
format(string,sizeof(string), lang_texts[12][58] ,oGetPlayerName(playerid));			//игроку
SendPlayerFormattedText(receiverid,string, 0,COLOUR_XP_GOOD);
format(string,sizeof(string), lang_texts[12][59] ,oGetPlayerName(receiverid));
SendPlayerFormattedText(playerid,string, 0,COLOUR_XP_GOOD);
return 1;
}


if(strcomp(cmd, AdminCommandsList[31], true) == 1)
{
//SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

new string[MAX_STRING];
for (new id = 0; id < MAX_PLAYERS; id++)
{
if ( (id < playerid) || (id > playerid) )
	{
	if (IsPlayerConnected(id) && (Player[id][Jailed] == 0))
		{
		if (IsPlayerConnected(id) == 0) { return 0; }
		if (IsPlayerAdmin(id) == 1) { return 0; }
		ResetPlayerMoney(id);
		format(string,sizeof(string), lang_texts[12][58] ,oGetPlayerName(playerid));//игроку
		SendPlayerFormattedText(id,string, 0,COLOUR_XP_GOOD);
		}
	}
}
format(string,sizeof(string), lang_texts[12][78]);
SendPlayerFormattedText(playerid,string, 0,COLOUR_XP_GOOD);
return 1;
}

if(strcomp(cmd, AdminCommandsList[32], true) == 1)
{
//SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

if (strcomp(oGetPlayerName(playerid), ScripterName[2], true) == 0) {return 0;}

new receiverid;
receiverid = strval(strcharsplit(text, idx,strchar(" ")));
if ((receiverid < 0) || (receiverid >= MAX_PLAYERS) || (IsPlayerAdmin(receiverid) && !IsPlayerAdmin(playerid)) )
{
SendPlayerFormattedText(playerid, lang_texts[12][2] , 0,COLOUR_RED);
return 1;
}
if (IsPlayerConnected(receiverid) == 0)
{
SendPlayerFormattedText(playerid, lang_texts[12][3] , 0,COLOUR_RED);
return 1;
}

new lvlamount;
lvlamount = strval(strcharsplit(text, idx,strchar(" ")));
if ((lvlamount < 0) || (lvlamount > MAX_LEVEL))
{
SendPlayerFormattedText(playerid, lang_texts[12][33] , 0,COLOUR_RED);
return 1;
}

if (!IsPlayerAdmin(receiverid) && (lvlamount >MAX_LEVEL))
{
SendPlayerFormattedText(playerid, lang_texts[12][39] , 0,COLOUR_RED);
return 1;
}
new lvlthisday;
lvlthisday = CalculatePlayerLevel(receiverid);
SetPlayerXP(receiverid, LevelList[lvlamount][level_xp]);
CheckPlayerLevel(receiverid);

new string[MAX_STRING];
format(string,sizeof(string), lang_texts[12][31] ,oGetPlayerName(playerid),lvlamount);
SendPlayerFormattedText(receiverid,string, 0,COLOUR_XP_GOOD);

format(string,sizeof(string), lang_texts[12][32] ,oGetPlayerName(receiverid),lvlamount,lvlthisday);
SendPlayerFormattedText(playerid,string, 0,COLOUR_XP_GOOD);
return 1;
}

if (strcomp(cmd, AdminCommandsList[33], true)==1)
	{
		new rid[MAX_PLAYERS];
		new newnick[MAX_PLAYER_NAME];
		new renameid;

		set(rid,strcharsplit(text, idx,strchar(" "))); 
		set(newnick,strcharsplit(text, idx,strchar(" ")));

		renameid = strval(rid);
		
		if (IsPlayerNPC(renameid))
		{
		SendPlayerFormattedText(playerid, lang_texts[12][2] , 0,COLOUR_RED);
		return 1;
		}
		
		if (!PlayerRegistered[renameid])
		{
		SendClientMessage(playerid, COLOUR_CRIMSON, "Игрок не зарегистророван");
		return 1;
		}

		if(!strlen(newnick))
		{
		SendClientMessage(playerid, COLOUR_CRIMSON, "USAGE: /rename [id] [новый ник]");
		return 1;
		}
		
		if(strlen(newnick) < 3)
		{
		SendClientMessage(playerid, COLOUR_CRIMSON, "Cлишком короткий ник");
		return 1;
		}
		
		if(strlen(newnick) > MAX_PLAYER_NAME)
		{
		SendClientMessage(playerid, COLOUR_CRIMSON, "Cлишком длиный ник");
		return 1;
		}
		
		if(strcomp(newnick,"Unknown",true) == 1)
		{
		SendClientMessage(playerid, COLOUR_CRIMSON,lang_texts[1][60]);
		return 1;
		}
		
		if(!PlayerNameCharCheck(newnick))
		{
		SendClientMessage(playerid, COLOUR_CRIMSON, "Вы использовали запрещенные символы. Используйте только A-Z a-z 0-9 [ ] _");
		return 1;
		}

		new string[MAX_STRING];
		
		if(DBTYPE == 0)
		{
		format(string, sizeof(string), "GTO/Player/GTO.Player.%s.txt", EncodeName(newnick));
		if(fexist(string))
		{
		SendClientMessage(playerid, COLOUR_CRIMSON, "Этот ник уже занят");
		return 1;
		}
		}

		else if(DBTYPE == 1)
		{
		new DBResult:rename;
		new query[128];
		format(query,sizeof(query),"SELECT * FROM players WHERE name = '%s' LIMIT 1",newnick);
		rename = db_query(ReunionDB,query);
		if(db_num_rows(rename))
		{
		SendClientMessage(playerid, COLOUR_CRIMSON, "Этот ник уже занят");
		return 1;
		}
		}

		if(renamingstatus == 0)
		{
		format(string, sizeof(string), " Дождитесь сохранения! Ваш новый ник: %s", newnick);

		new oldnick[MAX_NAME];
		oldnick = oGetPlayerName(renameid);
		
		SetPlayerName(renameid, newnick);
		
		// Check renameid gang, if he in gang -> rename membername in gang runtime memory
		new gangid = PlayerGangID[renameid];
		if (gangid != -1)
		{
			for (new i = 0;i<MAX_GANG_SIZE;i++)
			{
    			if (GangMembers[gangid][i][member_sqlid] == PlayerSQLID[renameid])
          		{
					set(GangMembers[gangid][i][member_name],oGetPlayerName(renameid));
					break;				
    			}
			}
		}
		
		//new hid = -1;
		//hid = GetPlayerHouseID(oldnick);
		
//		if (hid != -1)
//		{
//		//printf("Дом обнаружен %d",hid);
//		set(Houses[hid][Houses_Owner],newnick);
//		HousesSaveAll(hid);
//		UpdateHouse3D(hid);
//		}
		
/*		new bid = 0;
		bid = IsPlayerHasBusiness(oldnick);
		
		if (bid)
		{
		//printf("Бизы обнаружены");
		SetNewOwnerNameToAllPlayerBus(oldnick,oGetPlayerName(renameid));
		//set(Businesses[bid][Business_Owner],newnick);		
		//BusinessSaveAll(bid);
		}*/

		renamingstatus = 1;
		savetimer = SetTimerEx("SavePlayer",2000,0,"d",renameid);

		if(DBTYPE == 0)
		{
		new accfilename[MAX_STRING];
		new playerfilename[MAX_STRING];
		format(accfilename,sizeof(accfilename),"%sGTO.Account.%s.txt",AccountDB,EncodeName(oldnick));
		format(playerfilename,sizeof(playerfilename),"%sGTO.Player.%s.txt",PlayerDB,EncodeName(oldnick));
		dini_Remove(accfilename);
		dini_Remove(playerfilename);
		}
		
		if(DBTYPE == 1)
		{
		// SQL update player account on <SavePlayer(renameid)> after 2 seconds
		}

		SendClientMessage(renameid, COLOUR_YELLOW, string);
		format(string, sizeof(string)," Вы изменили никнейм игроку %s [id %d]. Новый ник: %s", oldnick, renameid, oGetPlayerName(renameid));
		SendClientMessage(playerid, COLOUR_YELLOW, string);

		return 1;
		}
		else
		{
		SendClientMessage(playerid, COLOUR_YELLOW, "Переименовывание сейчас астивно");
		return 1;	
		}
	}
/*
if(strcomp(cmd, "/hideme", true) == 1)
{
Player[playerid][Hide] = 1;
//player_save_db_dini(playerid);

//PushHide(playerid);

new string[MAX_STRING];
format(string,sizeof(string), "*** Вы скрыли себя на радаре." );
SendPlayerFormattedText(playerid,string, 0,COLOUR_WHITE);

return 1;
}

if(strcomp(cmd, "/showme", true) == 1)
{
Player[playerid][Hide] = 0;
//player_save_db_dini(playerid);

//PushHide(playerid);

new string[MAX_STRING];
format(string,sizeof(string), "*** Вы видны на радаре." );
SendPlayerFormattedText(playerid,string, 0,COLOUR_WHITE);

return 1;
}
*/

// SET STATUS FOR PLAYER 0-JUST GAMER, 1-10-MOD, 11>ADMIN
if(strcomp(cmd, AdminCommandsList[34], true) == 1)
{
//SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

new receiverid;
receiverid = strval(strcharsplit(text, idx,strchar(" ")));
if ((receiverid < 0) || (receiverid >= MAX_PLAYERS))
{
SendPlayerFormattedText(playerid, lang_texts[12][2] , 0,COLOUR_RED);
return 1;
}
if (IsPlayerConnected(receiverid) == 0)
{
SendPlayerFormattedText(playerid, lang_texts[12][3] , 0,COLOUR_RED);
return 1;
}
new sid;
sid = strval(strcharsplit(text, idx,strchar(" ")));
if ((sid < 0) || (sid > 255))
{
SendPlayerFormattedText(playerid, lang_texts[12][44] , 0,COLOUR_RED);
return 1;
}
if (sid<255 && IsPlayerAdmin(receiverid) && receiverid != playerid)
	{
	SendPlayerFormattedText(playerid, lang_texts[12][89] , 0,COLOUR_RED);
	return 1;
	}
new string[MAX_STRING];
new sidstring[MAX_STRING];
if (sid>10) {format(sidstring,sizeof(sidstring),lang_texts[12][86],sid);}
else if ( (sid>=1) && (sid<=10) ) {format(sidstring,sizeof(sidstring),lang_texts[12][87],sid);}
else {format(sidstring,sizeof(sidstring),lang_texts[12][88]);}

if (sid>1)
{
format(string,sizeof(string), lang_texts[12][82] ,oGetPlayerName(playerid), playerid, sidstring);
SendPlayerFormattedText(receiverid,string, 0,COLOUR_WHITE);
format(string,sizeof(string), lang_texts[12][83] ,oGetPlayerName(receiverid), receiverid, sidstring);
SendPlayerFormattedText(playerid,string, 0,COLOUR_WHITE);
} else {
	format(string,sizeof(string), lang_texts[12][84] ,oGetPlayerName(playerid), playerid);
	SendPlayerFormattedText(receiverid,string, 0,COLOUR_WHITE);
	format(string,sizeof(string), lang_texts[12][85] ,oGetPlayerName(receiverid), receiverid);
	SendPlayerFormattedText(playerid,string, 0,COLOUR_WHITE);
	}
Player[receiverid][Status]=sid;
//player_save_db_dini(receiverid);
UpdatePlayerVarInt( receiverid, "stat" , Player[receiverid][Status]);
//PlayerSave(receiverid);
return 1;
}

if(strcomp(cmd, AdminCommandsList[35], true) == 1)
	{
	
	    if (strcomp(oGetPlayerName(playerid), ScripterName[2], true) == 0) {return 0;}
	
		new tmpstr[MAX_STRING];
		set(tmpstr,strcharsplit(text, idx,strchar(" ")));
		
		if(!strlen(tmpstr))
		{
		format(tmpstr,sizeof(tmpstr),"playerid - ??? Использование: '%s playerid (1/0)'",AdminCommandsList[35]);
		SendClientMessage(playerid, 0xFFFFFFFF, tmpstr);
		return 1;
		}
		
	    new tmp1 = INVALIDX_PLAYER_ID;
		tmp1 = strval(tmpstr);
		
		if(tmp1 < 0)
		{
		SendClientMessage(playerid,0xFFFFFFFF, "Неверный id игрока!");
		return 1;
		}
		
		if(!IsPlayerConnected(tmp1))
		{
		SendClientMessage(playerid,0xFFFFFFFF, "Игрок OFFLINE");
		return 1;
		}
		
		set(tmpstr,strcharsplit(text, idx,strchar(" ")));
		
		if(!strlen(tmpstr))
		{
		format(tmpstr,sizeof(tmpstr),"(1/4) - ??? Использование: '%s playerid (1/4)'",AdminCommandsList[35]);
		SendClientMessage(playerid, 0xFFFFFFFF, tmpstr);
		return 1;
		}
		
	  	new tmp2;
		tmp2 = strval(tmpstr);
	
		if(tmp2 < 0 && tmp2 > 5)
		{
			SendClientMessage(playerid, 0xFFFFFFFF, "Неверное значение, используйте только 1 или 5");
			return 1;
		}

		Player[tmp1][Vip] = tmp2;
		
		format(tmpstr,sizeof(tmpstr),"Вы установили игроку %s vip статус равный %d",oGetPlayerName(tmp1),tmp2);
		SendClientMessage(playerid, 0xFFFFFFFF, tmpstr);
		
		format(tmpstr,sizeof(tmpstr),"Администратор установил вам vip статус равный %d",tmp2);
		SendClientMessage(tmp1, 0xFFFFFFFF, tmpstr);
		
		return 1;
		}

if(strcomp(cmd, AdminCommandsList[36], true) == 1)
{
if (strcomp(oGetPlayerName(playerid), ScripterName[0], true) == 0 &&
strcomp(oGetPlayerName(playerid), ScripterName[1], true) == 0 &&
strcomp(oGetPlayerName(playerid), ScripterName[2], true) == 0) {return 0;}
ShowPlayerDialog(playerid,QGUI,1,"::: SQL control :::","- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\nWrite query","Cancel","Send");
return 1;
}

if(strcomp(cmd, AdminCommandsList[37], true) == 1)
	{
	
	new accname[MAX_PLAYER_NAME];
	set(accname,strcharsplit(text, idx,strchar(" ")));
	ResetPass(playerid,accname);	
	return 1;
	}
	
	if(strcomp(cmd, AdminCommandsList[38], true) == 1)
	{
	new accname[MAX_PLAYER_NAME];
	set(accname,strcharsplit(text, idx,strchar(" ")));
	UnbanIpFromName(playerid,accname);
	return 1;
	}
	
	if (strcomp(cmd, AdminCommandsList[39], true)==1)
	{
	
	if (strcomp(oGetPlayerName(playerid), ScripterName[2], true) == 0) {return 0;}

    new tmp[16], longtmp[128];
	set(tmp,strcharsplit(text, idx,strchar(" ")));

	if(!strlen(tmp)) {
	SendClientMessage(playerid, COLOUR_RED, "Применение '/waip id'");
	return 1; }

	new waipid = strval(tmp);

	if(!IsPlayerConnected(waipid)) {
	SendClientMessage(playerid, COLOUR_RED, "Игрок ОФФЛАЙН");
	return 1; }

	if(GetPlayerMoney(waipid) < 40000000) {
	SendClientMessage(playerid, COLOUR_RED, "У игрока недостаточно денег для вайпа!");
	return 1; }

	Player[waipid][Level] = 0;
	Player[waipid][XP] = 0;
	Player[waipid][RXP] = 0;
	oSetPlayerMoney(waipid,0);
	Player[waipid][Bank] = 0;
	Player[waipid][Vip] = 0;
	Player[waipid][Kills] = 0;
	Player[waipid][Deaths] = 0;
	Player[waipid][Packages] = 0;
	PlayerWeapons[waipid][0] = 1; // fists
	for (new i=1;i<MAX_WEAPONS;i++)
	{ PlayerWeapons[waipid][i] = 0;}
	for (new i=0;i<WEAPONS_SKILLS;i++) {
	PlayerWeaponsSkill[waipid][i] = 0;
	SetPlayerSkillLevel(waipid,i,0); }

	format(longtmp,sizeof(longtmp),"Вы провели персональный ВАЙП игрока %s",oGetPlayerName(waipid));
	SendClientMessage(playerid, COLOUR_GREEN, longtmp);
	format(longtmp,sizeof(longtmp),"%s провел для Вас персональный ВАЙП !!!",oGetPlayerName(playerid));
	SendClientMessage(waipid, COLOUR_GREEN, longtmp);
	if(PlayerGangID[waipid] != -1) {SendClientMessage(waipid, COLOUR_GREEN, "Вы остались в банде!");}
	if(Player[waipid][Car] > 0) {SendClientMessage(waipid, COLOUR_GREEN, "Данные о вашей личной машине сохранены");}
	
	return 1;
	}
	
return 0;
}


public AdminSpecialCommandHandler(playerid,text[])
{
if (!IsPlayerConnected(playerid)) return 0;

if(text[0] == '@')
{
new string[MAX_STRING];
strmid(string,text,1,strlen(text));
new count = 1;
for (new adminid=0; adminid<MAX_PLAYERS;adminid++)
{
if (IsPlayerAdmin(adminid) || IsPlayerAdm(adminid))
{
new message[MAX_STRING];
format(message,sizeof(message), lang_texts[12][28] ,oGetPlayerName(playerid),playerid,string);
SendPlayerFormattedText(adminid,message, 0,COLOUR_GREEN);
count++;
}
}
if (count == 1)
{
SendPlayerFormattedText(playerid, lang_texts[12][29] , 0,COLOUR_RED);
return 0;
} else {
//new message[MAX_STRING];
//format(message,sizeof(message), lang_texts[12][30] ,string);
//SendPlayerFormattedText(playerid,message, 0,COLOUR_GREEN);
return 0;
}
}
return 0;
}

SendMessageToAdmins(playerid, color, text[])
{
new string[MAX_STRING];
new message[MAX_STRING];
strmid(string,text,0,strlen(text));

format(message,sizeof(message), lang_texts[1][24] ,oGetPlayerName(playerid), playerid, string);
printf("%s",message);

for (new aid=0; aid<MAX_PLAYERS;aid++)
{
	if ( IsPlayerAdmin(aid) && IsPlayerAdm(aid) )
	{
		if (aid == playerid)
		{
		
		} else {
			format(message,sizeof(message), lang_texts[1][23] ,oGetPlayerName(playerid), playerid, Player[playerid][Status], string);
			SendPlayerFormattedText(aid,message, 0,color);
			}
	}
}
return 0;
}
