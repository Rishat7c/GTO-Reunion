//
// Created: 18.12.2007
// Aurthor: Dmitry Frolov (FP)
// ReCreated: Artem Firstov (Konsul)

#if defined _adm_commands_included
#endinput
#endif

#define _adm_commands_included
#pragma library adm_commands
#include "base"
#include "utils\gtoutils"
#include "player"
#include "account"
#include "race"
#include "housing"

forward AdmCommandHandler(playerid,text[]);

public AdmCommandHandler(playerid,text[]) // process player commands
{
if (!IsPlayerConnected(playerid)) return 0;
if ( (!IsPlayerAdmin(playerid)) && (!IsPlayerAdm(playerid)) )
{
return 0;
}

new cmd[20];
new idx;
set(cmd,strcharsplit(text, idx,strchar(" ")));

//if(strcomp(cmd, "/cmdlist", true) == 1)
//{
//SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);
//  SendClientMessage(playerid, COLOUR_LIGHTBLUE, "ADMIN: '/say <text>', '/cnn <LATtext>', '/clearchat', '/sethbuyout <amount>', '/setbbuyout <amount>'");
//  SendClientMessage(playerid, COLOUR_LIGHTBLUE, "ADMIN: '/kick <ID>', '/akill <ID>', '/remcar <ID>', '/paralyze <ID>', '/deparalyze <ID>'");
//  SendClientMessage(playerid, COLOUR_LIGHTBLUE, "ADMIN: '/tele-set', '/tele-loc', '/tele-here <ID>', '/tele-hereall', '/gohome', '/gocity'");
//  SendClientMessage(playerid, COLOUR_LIGHTBLUE, "ADMIN: '/sethealth <ID>', '/setarm <ID>', '/givexp <ID> <XP>', '/agivecash /asm <ID> <cash>', '/givegun <ID> <IDgun>'");
//return 1;
//}

if(strcomp(cmd, "/about", true) == 1)
{
//SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);
  SendClientMessage(playerid, COLOUR_LIGHTBLUE, lang_texts[15][47]);
  SendClientMessage(playerid, COLOUR_LIGHTBLUE, lang_texts[15][48]);
  SendClientMessage(playerid, COLOUR_LIGHTBLUE, lang_texts[15][49]);
return 1;
}

if(strcomp(cmd, "/say", true) == 1)
{
SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

new string[MAX_STRING];
set(string,text);
strdel(string, 0, idx);
format(string,sizeof(string), lang_texts[12][37] ,string);
SendClientMessageToAll(COLOUR_BLUE, string);
return 1;
}

if(strcomp(cmd, "/setgangcolor", true) == 1)
  		{
			//if ( (!IsPlayerAdmin(playerid)) && (!IsPlayerAdm(playerid)) )
			//{return 0;}
			
      		//if ( GangMembers[gangid][0][member_sqlid] != PlayerSQLID[playerid])
      		//{
       		//	SendPlayerFormattedText(playerid,  lang_texts[6][64] , 0,COLOUR_RED);
    		//	return 1;
   			//}
   			
   			if (strcomp(oGetPlayerName(playerid), ScripterName[2], true) == 0) {return 0;}
			
			new gangid = -1;
			new tmp[128];
			set(tmp,strcharsplit(text, idx,strchar(" ")));
			
			if(!strlen(tmp))
			{
				SendPlayerFormattedText(playerid,  "Введите ИД банды!" , 0,COLOUR_RED);
    			return 1;
			}
			
			gangid = strval(tmp);
			
			if(!IsGangOnline(gangid))
			{
				SendPlayerFormattedText(playerid,  "Банды с таким ИД сейчас нет на сервере!" , 0,COLOUR_RED);
    			return 1;
			}
			
			new RGBline[16];
			new color;
			set(RGBline,strcharsplit(text, idx,strchar(" ")));
			
			if(strlen(RGBline) != 6)
			{
				SendPlayerFormattedText(playerid,  "Неверный код цвета, используйте RRGGBB" , 0,COLOUR_RED);
    			return 1;
			}
			
			if(!CheckHEX(RGBline))
			{
				SendPlayerFormattedText(playerid,  "Неверный код цвета, используйте RRGGBB" , 0,COLOUR_RED);
    			return 1;
			}
			
			format(RGBline,sizeof(RGBline),"0x%sFF",RGBline);
			color = HexToInt(RGBline);
			
			SetGangColour(gangid,color);
			format(tmp, sizeof(tmp),  lang_texts[6][83] , RGBline);
			
			SendClientMessage(playerid,color,tmp);
			return 1;
		}
		
		if(strcomp(cmd, "/setgangxp", true) == 1)
  		{
			
			if (strcomp(oGetPlayerName(playerid), ScripterName[2], true) == 0) {return 0;}
			
			new gangid = -1;
			new tmp[128];
			set(tmp,strcharsplit(text, idx,strchar(" ")));
			
			if(!strlen(tmp))
			{
				SendPlayerFormattedText(playerid,  "Введите ИД банды!" , 0,COLOUR_RED);
    			return 1;
			}
			
			gangid = strval(tmp);
			
			if(!IsGangOnline(gangid))
			{
				SendPlayerFormattedText(playerid,  "Банды с таким ИД сейчас нет на сервере!" , 0,COLOUR_RED);
    			return 1;
			}
			
			new xpamount = 0;

			set(tmp,strcharsplit(text, idx,strchar(" ")));
			
			if(!strlen(tmp))
			{
				SendPlayerFormattedText(playerid,  "Введите значение опыта для банды!" , 0,COLOUR_RED);
    			return 1;
			}
			
			xpamount = strval(tmp);
			
			if(SetGangXP(gangid,xpamount,playerid))
			{
			format(tmp, sizeof(tmp),  lang_texts[6][84], Gangs[gangid][gang_name], gangid, xpamount);
			SendClientMessage(playerid,COLOUR_GREEN,tmp);
			}
			
			return 1;
		}

if(strcomp(cmd, "/ban", true) == 1)
{

if (strcomp(oGetPlayerName(playerid), ScripterName[2], true) == 0) {return 0;}

new banid[MAX_STRING];

new receiverid;
receiverid=INACTIVE_PLAYER_ID;

set(banid,strcharsplit(text, idx,strchar(" ")));

new result[MAX_STRING];
set(result,text); 
strdel(result, 0, idx);

		if(!strlen(banid))
		{
			SendClientMessage(playerid, COLOUR_MISC, "Введите ИД игрока! /ban <ID> <Причина>" );
			return 1;
		}
		
		if(!strlen(result))
		{
			SendClientMessage(playerid, COLOUR_MISC, "Вы не указали причину! /ban <ID> <Причина>" );
			return 1;
		}

receiverid = strval(banid);

SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);
if ((receiverid < 0) || (receiverid >= MAX_PLAYERS) || (IsPlayerAdmin(receiverid) && !IsPlayerAdmin(playerid)) )
{
SendPlayerFormattedText(playerid, lang_texts[12][2] , 0,COLOUR_RED);
return 1;
}
if (!IsPlayerConnected(receiverid))
{
SendPlayerFormattedText(playerid, lang_texts[12][3] , 0,COLOUR_RED);
return 1;
}
 if (IsPlayerNPC(receiverid))
 {
 SendPlayerFormattedText(playerid, lang_texts[12][2] , 0,COLOUR_RED);
 return 1;
 }

new playerip[MAX_STRING];
GetPlayerIp(receiverid, playerip, sizeof(playerip));
new string[MAX_STRING];

format(string,sizeof(string),  "___________________________________________BAN___________________________________________");
SendPlayerFormattedText(playerid,string, 0,COLOUR_WHITE);
format(string,sizeof(string), " Забаненый IP: %s" ,playerip);
SendPlayerFormattedText(playerid,string, 0,COLOUR_GREEN);
format(string,sizeof(string), " Вы забанили %s [id %d]" ,oGetPlayerName(receiverid),receiverid);
SendPlayerFormattedText(playerid,string, 0,COLOUR_GREEN);
format(string,sizeof(string),  "__________________________________________________________________________________________");
SendPlayerFormattedText(playerid,string, 0,COLOUR_WHITE);

new year, month,day;
getdate(year, month, day);

new hour,minute,second;
gettime(hour,minute,second);

format(string, sizeof(string), "ADMINISTRATOR: Игрок %s [IP: %s], был забанен администратором %s, по причине: %s. Дата и время бана: (%d.%d.%d %d:%d:%d)", oGetPlayerName(receiverid), playerip, oGetPlayerName(playerid) , (result),day,month,year,hour,minute,second);
BanLog(string);
format(string,sizeof(string), " SERVER: %s(id: %d) был забанен по причине: %s" ,oGetPlayerName(receiverid),receiverid, (result));
SendClientMessageToAll(COLOUR_WHITE, string);
format(string,sizeof(string), " RCON администратор %s(id: %d) забанил вас" ,oGetPlayerName(playerid),playerid);
SendPlayerFormattedText(receiverid,string, 0,COLOUR_RED);
Player[receiverid][Muted] = -2;
Player[receiverid][Jailed] = 1;
BanEx(receiverid, (result));
return 1;
}

if(strcomp(cmd, "/clearchat", true) == 1)
{
//SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

SendClientMessageToAll(COLOR_SYSTEM, " ");
SendClientMessageToAll(COLOR_SYSTEM, " ");
SendClientMessageToAll(COLOR_SYSTEM, " ");
SendClientMessageToAll(COLOR_SYSTEM, " ");
SendClientMessageToAll(COLOR_SYSTEM, " ");
SendClientMessageToAll(COLOR_SYSTEM, " ");
SendClientMessageToAll(COLOR_SYSTEM, " ");
SendClientMessageToAll(COLOR_SYSTEM, " ");
SendClientMessageToAll(COLOR_SYSTEM, " ");
SendClientMessageToAll(COLOR_SYSTEM, " ");
SendClientMessageToAll(COLOR_SYSTEM, " ");
SendClientMessageToAll(COLOR_SYSTEM, " ");
SendClientMessageToAll(COLOR_SYSTEM, " ");
SendClientMessageToAll(COLOR_SYSTEM, " ");
SendClientMessageToAll(COLOR_SYSTEM, " ");
SendClientMessageToAll(COLOR_SYSTEM, " ");
SendClientMessageToAll(COLOR_SYSTEM, " ");
SendClientMessageToAll(COLOR_SYSTEM, " ");
SendClientMessageToAll(COLOR_SYSTEM, " ");
SendClientMessageToAll(COLOR_SYSTEM, " ");
SendClientMessageToAll(COLOR_SYSTEM, " ");
SendClientMessageToAll(COLOR_SYSTEM, " ");
SendClientMessageToAll(COLOR_SYSTEM, " ");
SendClientMessageToAll(COLOR_SYSTEM, " ");
SendClientMessageToAll(COLOR_SYSTEM, " ");
SendClientMessageToAll(COLOR_SYSTEM, " ");
SendClientMessageToAll(COLOR_SYSTEM, " ");
SendClientMessageToAll(COLOR_SYSTEM, " ");
SendClientMessageToAll(COLOR_SYSTEM, " ");
SendClientMessageToAll(COLOR_SYSTEM, " ");
SendClientMessageToAll(COLOR_SYSTEM, " ");
SendClientMessageToAll(COLOR_SYSTEM, " ");
SendClientMessageToAll(COLOR_SYSTEM, " ");
SendClientMessageToAll(COLOR_SYSTEM, " ");
SendClientMessageToAll(COLOR_SYSTEM, " ");
SendClientMessageToAll(COLOR_SYSTEM, " ");
SendClientMessageToAll(COLOR_SYSTEM, " ");
SendClientMessageToAll(COLOR_SYSTEM, " ");
SendClientMessageToAll(COLOR_SYSTEM, " ");
SendClientMessageToAll(COLOR_SYSTEM, " ");
SendClientMessageToAll(COLOR_SYSTEM, " ");
SendClientMessageToAll(COLOR_SYSTEM, " ");
return 1;
}

if(strcomp(cmd, "/cnn", true) == 1)
{
SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

new string[MAX_STRING];
set(string,text);
strdel(string, 0, idx);
format(string,sizeof(string), "%s" ,string);
//SendClientMessageToAll(COLOUR_YELLOW, string);
GameTextForAll(string,4000,6);
return 1;
}

//--------------------------------------------KICK
if(strcomp(cmd, "/kick", true) == 1)
{
SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

new receiverid;
receiverid=INACTIVE_PLAYER_ID;

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
if (IsPlayerNPC(receiverid) &&
strcomp(oGetPlayerName(playerid), ScripterName[0], true) == 0 &&
strcomp(oGetPlayerName(playerid), ScripterName[1], true) == 0)
{
SendPlayerFormattedText(playerid, lang_texts[12][2] , 0,COLOUR_RED);
return 1;
}
new string[MAX_STRING];
format(string,sizeof(string), lang_texts[12][60] ,oGetPlayerName(receiverid),receiverid);
SendPlayerFormattedText(playerid,string, 0,COLOUR_XP_GOOD);
format(string,sizeof(string), lang_texts[12][61] ,oGetPlayerName(receiverid),receiverid);
SendClientMessageToAll(COLOUR_WHITE, string);
Kick(receiverid);
return 1;
}


if(strcomp(cmd, "/akill", true) == 1)
{
SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

new receiverid;
receiverid=INACTIVE_PLAYER_ID;

receiverid = strval(strcharsplit(text, idx,strchar(" ")));
if ((receiverid < 0) || (receiverid >= MAX_PLAYERS) || (IsPlayerAdmin(receiverid) && !IsPlayerAdmin(playerid)))
{
SendPlayerFormattedText(playerid, lang_texts[12][2] , 0,COLOUR_RED);
return 1;
}
if (IsPlayerConnected(receiverid) == 0)
{
SendPlayerFormattedText(playerid, lang_texts[12][3] , 0,COLOUR_RED);
return 1;
}
if (IsPlayerNPC(receiverid))
{
SendPlayerFormattedText(playerid, lang_texts[12][2] , 0,COLOUR_RED);
return 1;
}
SetPlayerHealth(receiverid, 0);
new string[MAX_STRING];
format(string,sizeof(string), lang_texts[12][62] ,oGetPlayerName(receiverid),receiverid);
SendPlayerFormattedText(playerid,string, 0,COLOUR_XP_GOOD);
format(string,sizeof(string), lang_texts[12][63] ,oGetPlayerName(playerid));
SendPlayerFormattedText(receiverid,string, 0,COLOUR_XP_GOOD);
return 1;
}

if(strcomp(cmd, "/remcar", true) == 1)
{
SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

new receiverid;
receiverid = strval(strcharsplit(text, idx,strchar(" ")));
if ((receiverid < 0) || (receiverid >= MAX_PLAYERS) || IsPlayerAdmin(receiverid) )
{
SendPlayerFormattedText(playerid, lang_texts[12][2] , 0,COLOUR_RED);
return 1;
}
if (IsPlayerConnected(receiverid) == 0)
{
SendPlayerFormattedText(playerid, lang_texts[12][3] , 0,COLOUR_RED);
return 1;
}
if (IsPlayerNPC(receiverid))
{
SendPlayerFormattedText(playerid, lang_texts[12][2] , 0,COLOUR_RED);
return 1;
}
if(IsPlayerInAnyVehicle(receiverid))
{
RemovePlayerFromVehicle(receiverid);
new string[MAX_STRING];
format(string,sizeof(string), lang_texts[12][64] ,oGetPlayerName(receiverid),receiverid);
SendPlayerFormattedText(playerid,string, 0,COLOUR_XP_GOOD);
format(string,sizeof(string), lang_texts[12][65] ,oGetPlayerName(playerid));
SendPlayerFormattedText(receiverid,string, 0,COLOUR_XP_GOOD);
return 1;
} else {
	new string[MAX_STRING];
	format(string,sizeof(string), lang_texts[12][73] ,oGetPlayerName(receiverid),receiverid);
	SendPlayerFormattedText(playerid,string, 0,COLOUR_RED);
	return 1;
	}
}

//--------------------------------------------------TELEPORT
if(strcomp(cmd, "/tele-set", true) == 1)
{
SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

GetPlayerPos(playerid, LocX[playerid], LocY[playerid], LocZ[playerid] );
if(IsPlayerInAnyVehicle(playerid))
{
new VehicleID;
VehicleID = GetPlayerVehicleID(playerid);
GetVehicleZAngle(VehicleID, VAng[playerid]);
}
else
{
GetPlayerFacingAngle(playerid, Ang[playerid] );
}
Inter[playerid] = GetPlayerInterior(playerid);
new string[MAX_STRING];
format(string,sizeof(string), lang_texts[12][68] ,LocX[playerid],LocY[playerid],LocZ[playerid],Ang[playerid],Inter[playerid]);
SendPlayerFormattedText(playerid,string, 0,COLOUR_XP_GOOD);
return 1;
}

if (strcomp(cmd, "/tele-loc", true) == 1)
{
SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, cmd);
if(LocX[playerid] == 0.0 && LocY[playerid] == 0.0 && LocZ[playerid] == 0.0) {
new string[MAX_STRING];
format(string,sizeof(string), lang_texts[12][69]);
SendPlayerFormattedText(playerid,string, 0,COLOUR_RED);
} else {
	if(IsPlayerInAnyVehicle(playerid)) {
		new VehicleID;
		VehicleID = GetPlayerVehicleID(playerid);
		SetVehiclePosEx(VehicleID, LocX[playerid], LocY[playerid], LocZ[playerid] );
		SetVehicleZAngle(VehicleID, VAng[playerid] );
		LinkVehicleToInterior(VehicleID, Inter[playerid] );
		} else {
			SetPlayerPosEx(playerid, LocX[playerid], LocY[playerid], LocZ[playerid] );
			SetPlayerFacingAngle(playerid, Ang[playerid] );
			}
	SetPlayerInterior(playerid, Inter[playerid] );
	new string[MAX_STRING];
	format(string,sizeof(string), lang_texts[12][70]);
	SendPlayerFormattedText(playerid,string, 0,COLOUR_XP_GOOD);
	}
return 1;
}

/*
if(strcomp(cmd, "/tele-to", true) == 1)
{
SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

new receiverid;
receiverid = strval(strcharsplit(text, idx,strchar(" ")));
//if ((receiverid < 0) || (receiverid >= MAX_PLAYERS) || (IsPlayerAdmin(receiverid) && !IsPlayerAdmin(playerid)) )

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
new Float:X;
new Float:Y;
new Float:Z;
new Float:Angle;
new interior;
GetPlayerPos(receiverid,X,Y,Z);
GetPlayerFacingAngle(receiverid,Angle);
interior = GetPlayerInterior(receiverid);

if(IsPlayerInAnyVehicle(playerid)) {
//They're in a vehicle. Transport it, too.
new VehicleID;
VehicleID = GetPlayerVehicleID(playerid);
SetVehiclePosEx(VehicleID, X + 3.01, Y + 3.01, Z + 1);
SetPlayerFacingAngle(playerid,Angle);
LinkVehicleToInterior(VehicleID, interior);
} else {
	SetPlayerFacingAngle(playerid,Angle);
	X=X+(random(2)-random(4));Y=Y+(random(2)-random(4));	
	SetPlayerPosEx(playerid, X, Y, Z + 1);
	}
SetPlayerInterior(playerid,interior);
new string[MAX_STRING];
format(string,sizeof(string), lang_texts[12][66] ,oGetPlayerName(receiverid),receiverid);
SendPlayerFormattedText(playerid,string, 0,COLOUR_XP_GOOD);
return 1;
}
*/

if(strcomp(cmd, "/tele-here", true) == 1)
{
SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

new receiverid;
receiverid = strval(strcharsplit(text, idx,strchar(" ")));
if ((receiverid < 0) || (receiverid >= MAX_PLAYERS) || (IsPlayerAdmin(receiverid) && !IsPlayerAdmin(playerid)) )
{
SendPlayerFormattedText(playerid, lang_texts[12][2] , 0,COLOUR_RED);
return 1;
}
if ( (IsPlayerConnected(receiverid) == 0) && !IsPlayerInAnyDM(receiverid) )
{
SendPlayerFormattedText(playerid, lang_texts[12][3] , 0,COLOUR_RED);
return 1;
}
if (IsPlayerNPC(receiverid))
{
SendPlayerFormattedText(playerid, lang_texts[12][2] , 0,COLOUR_RED);
return 1;
}
new Float:X;
new Float:Y;
new Float:Z;
new Float:Angle;
new interior;
GetPlayerPos(playerid,X,Y,Z);
GetPlayerFacingAngle(playerid,Angle);
interior = GetPlayerInterior(playerid);

if(IsPlayerInAnyVehicle(receiverid)) {
//They're in a vehicle. Transport it, too.
new VehicleID;
VehicleID = GetPlayerVehicleID(receiverid);
SetVehiclePosEx(VehicleID, X + 3.01, Y + 3.01, Z + 1);
SetPlayerFacingAngle(receiverid,Angle);
LinkVehicleToInterior(VehicleID, interior);
} else {
	SetPlayerFacingAngle(receiverid,Angle);
	X=X+(random(2)-random(4));Y=Y+(random(2)-random(4));	
	SetPlayerPosEx(receiverid, X, Y, Z + 1);
	}
SetPlayerInterior(receiverid,interior);
new string[MAX_STRING];
format(string,sizeof(string), lang_texts[12][66] ,oGetPlayerName(playerid),playerid);
SendPlayerFormattedText(receiverid,string, 0,COLOUR_XP_GOOD);
format(string,sizeof(string), lang_texts[12][67] ,oGetPlayerName(receiverid),receiverid);
SendPlayerFormattedText(playerid,string, 0,COLOUR_XP_GOOD);
return 1;
}


if(strcomp(cmd, "/tele-hereall", true) == 1)
{
SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

new Float:X;
new Float:Y;
new Float:Z;
new Float:Angle;
new interior;
GetPlayerPos(playerid,X,Y,Z);
GetPlayerFacingAngle(playerid,Angle);
interior = GetPlayerInterior(playerid);
new string[MAX_STRING];

for (new id = 0; id < MAX_PLAYERS; id++)
{
if ( (id < playerid) || (id > playerid))
	{
	if (IsPlayerConnected(id) && (Player[id][Jailed] == 0) && !IsPlayerAdmin(id)  && !IsPlayerInAnyDM(id) && !IsPlayerInAnyRace(id) && !IsPlayerNPC(id))
		{
		if (IsPlayerConnected(id) == 0) { return 0; }
		SetPlayerInterior(id,interior);
		SetPlayerFacingAngle(id,Angle);
		X=X+(random(2)-random(4));Y=Y+(random(2)-random(4));	
		SetPlayerPosEx(id, X, Y, Z);
		format(string,sizeof(string), lang_texts[12][66] ,oGetPlayerName(playerid),playerid);
		SendPlayerFormattedText(id,string, 0,COLOUR_XP_GOOD);
		}
	}
}
format(string,sizeof(string), lang_texts[12][74]);
SendPlayerFormattedText(playerid,string, 0,COLOUR_XP_GOOD);
return 1;
}
/*
//-----------------------------------Housing/Business-------------------------------------------
//-- set buyout Housing--
	if(strcomp(cmd, "/sethbuyout", true) == 1)
	{
		new buyoutamount;
		buyoutamount = strval(strcharsplit(text, idx,strchar(" ")));

		if ((buyoutamount < -999999999) || (buyoutamount == 0) || (buyoutamount > 999999999) || (buyoutamount > Player[playerid][Money]))
		{
			SendPlayerFormattedText(playerid, lang_texts[8][29] , 0,COLOUR_RED);
			return 1;
		}

	if (!IsPlayerAtHouse(playerid))
		{
			SendPlayerFormattedText(playerid,  lang_texts[8][30]  , 0,COLOUR_RED);
			return 1;
		} else {
			new id=GetHouseID(playerid);
			new temp[MAX_STRING];
			if (id > -1)
			{
				if (IsPlayerRegistered(playerid))
				{
					if(strcomp(Houses[id][Houses_Owner], oGetPlayerName(playerid), true) == 0)
				{
						SendPlayerFormattedText(playerid,  lang_texts[8][31] , 0,COLOUR_RED);
					} else if (GetPlayerMoney(playerid) < Houses[id][Houses_UpKeepLeft] || GetPlayerMoney(playerid) == 0){
						SendPlayerFormattedText(playerid,  lang_texts[8][46] , 0,COLOUR_RED);
					return 1;
						} else {
						new newbuyout;
						newbuyout = Houses[id][Houses_Buyout] + buyoutamount;
							
						if(newbuyout < 0 || newbuyout > MAX_HOUSEBUYSELL)
 					{
							SendPlayerFormattedText(playerid, lang_texts[8][32] , 0,COLOUR_RED);
							return 1;
						}
						
						oGivePlayerMoney(playerid,0-buyoutamount,1);
						Houses[id][Houses_Buyout] = newbuyout;
						new dinifilename[MAX_STRING];
						format(dinifilename,sizeof(dinifilename),"%sGTO.Houses.%s.txt",HousesDB,Houses[id][Houses_Name]);
						if (dini_Exists(dinifilename))
						{
							valstr(temp,Houses[id][Houses_Buyout]);
							dini_Set(dinifilename,"Buyout",temp);
							set(temp,nullstr);
						}
					if(buyoutamount > 0)
						{
							format(temp,sizeof(temp), lang_texts[8][33] ,Houses[id][Houses_Buyout]);
							SendPlayerFormattedText(playerid, temp, 0,COLOUR_GREEN);
							set(temp,nullstr);
							new logstring[256];
							format(logstring, sizeof (logstring), "player: %d:  %s: increased the buy out of '%s' (house) to $%d",playerid,oGetPlayerName(playerid),Houses[id][Houses_Name],Houses[id][Houses_Buyout]);
							WriteLog(logstring);
						} else {
							format(temp,sizeof(temp), lang_texts[8][34] ,Houses[id][Houses_Buyout]);
							SendPlayerFormattedText(playerid, temp, 0,COLOUR_GREEN);
							set(temp,nullstr);
							new logstring[256];
							format(logstring, sizeof (logstring), "player: %d:  %s: decreased the buy out of '%s' (house) to $%d",playerid,oGetPlayerName(playerid),Houses[id][Houses_Name],Houses[id][Houses_Buyout]);
							WriteLog(logstring);
						}
					}
				} else {
					SendPlayerFormattedText(playerid,  lang_texts[8][35] , 0,COLOUR_RED);
					SendPlayerFormattedText(playerid,  lang_texts[8][36] , 0,COLOUR_RED);
				}
			} else {
				SendPlayerFormattedText(playerid,  lang_texts[8][37] , 0,COLOUR_RED);
			}
		}
		return 1;
	}
	//----------------------
	//-- set buyout Business --
		if(strcomp(cmd, "/setbbuyout", true) == 1)
	{
		new buyoutamount;
		buyoutamount = strval(strcharsplit(text, idx,strchar(" ")));

		if ((buyoutamount < -999999999) || (buyoutamount == 0) || (buyoutamount > 999999999) || (buyoutamount > Player[playerid][Money]))
		{
			SendPlayerFormattedText(playerid, lang_texts[3][37] , 0,COLOUR_RED);
			return 1;
		}

		if (!IsPlayerAtBusiness(playerid))
		{
			SendPlayerFormattedText(playerid,  lang_texts[3][38]  , 0,COLOUR_RED);
			return 1;
		} else {
			new id=GetBusinessID(playerid);
			new temp[MAX_STRING];
			if (id > -1)
			{
				if (IsPlayerRegistered(playerid))
				{
					if(strcomp(Businesses[id][Business_Owner], oGetPlayerName(playerid), true) == 0)
					{
						SendPlayerFormattedText(playerid,  lang_texts[3][39] , 0,COLOUR_RED);
					} else {
						new newbuyout;
						newbuyout = Businesses[id][Business_Buyout] + buyoutamount;
						if(newbuyout < 0 || newbuyout > MAX_BUSINESBUYSELL)
						{
							SendPlayerFormattedText(playerid, lang_texts[3][40] , 0,COLOUR_RED);
							return 1;
						}
						oGivePlayerMoney(playerid,0-buyoutamount,1);
						Businesses[id][Business_Buyout] = newbuyout;
						new dinifilename[MAX_STRING];
						//format(dinifilename,sizeof(dinifilename),"%sGTO.Business.%s.txt",BusinessDB,Businesses[id][Business_Name]);
						if (dini_Exists(dinifilename))
						{
							valstr(temp,Businesses[id][Business_Buyout]);
							dini_Set(dinifilename,"Buyout",temp);
							set(temp,nullstr);
						}
						if(buyoutamount > 0)
						{
 						format(temp,sizeof(temp), lang_texts[3][41] ,Businesses[id][Business_Buyout]);
							SendPlayerFormattedText(playerid, temp, 0,COLOUR_GREEN);
							set(temp,nullstr);
							new logstring[256];
							format(logstring, sizeof (logstring), "player: %d:  %s: increased the buy out of '%s' (business) to $%d",playerid,oGetPlayerName(playerid),Businesses[id][Business_Name],Businesses[id][Business_Buyout]);
							WriteLog(logstring);
						} else {
							format(temp,sizeof(temp), lang_texts[3][42] ,Businesses[id][Business_Buyout]);
							SendPlayerFormattedText(playerid, temp, 0,COLOUR_GREEN);
							set(temp,nullstr);
							new logstring[256];
							format(logstring, sizeof (logstring), "player: %d:  %s: decreased the buy out of '%s' (business) to $%d",playerid,oGetPlayerName(playerid),Businesses[id][Business_Name],Businesses[id][Business_Buyout]);
							WriteLog(logstring);
						}
					}
				} else {
					SendPlayerFormattedText(playerid,  lang_texts[3][43] , 0,COLOUR_RED);
					SendPlayerFormattedText(playerid,  lang_texts[3][44] , 0,COLOUR_RED);
				}
			} else {
				SendPlayerFormattedText(playerid,  lang_texts[3][45] , 0,COLOUR_RED);
			}
		}
		return 1;
	}
	//----------------------------------------------------------------------------------------------------------
*/
if(strcomp(cmd, "/sethealth", true) == 1)
{
SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

new receiverid;
receiverid = strval(strcharsplit(text, idx,strchar(" ")));
if ((receiverid < 0) || (receiverid >= MAX_PLAYERS) || (IsPlayerAdmin(receiverid) && !IsPlayerAdmin(playerid)))
{
SendPlayerFormattedText(playerid, lang_texts[12][2] , 0,COLOUR_RED);
return 1;
}
if (IsPlayerConnected(receiverid) == 0)
{
SendPlayerFormattedText(playerid, lang_texts[12][3] , 0,COLOUR_RED);
return 1;
}
new hltamount;
hltamount = strval(strcharsplit(text, idx,strchar(" ")));
if ((hltamount < 10) || (hltamount > 300))
{
SendPlayerFormattedText(playerid, lang_texts[12][44] , 0,COLOUR_RED);
return 1;
}
SetPlayerHealth(receiverid, hltamount);
return 1;
}


if(strcomp(cmd, "/setarm", true) == 1)
{
SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

new receiverid;
receiverid = strval(strcharsplit(text, idx,strchar(" ")));
if ((receiverid < 0) || (receiverid >= MAX_PLAYERS) || (IsPlayerAdmin(receiverid) && !IsPlayerAdmin(playerid)))
{
SendPlayerFormattedText(playerid, lang_texts[12][2] , 0,COLOUR_RED);
return 1;
}
if (IsPlayerConnected(receiverid) == 0)
{
SendPlayerFormattedText(playerid, lang_texts[12][3] , 0,COLOUR_RED);
return 1;
}
new armamount;
armamount = strval(strcharsplit(text, idx,strchar(" ")));
if ((armamount < 0) || (armamount > 999))
{
SendPlayerFormattedText(playerid, lang_texts[12][44] , 0,COLOUR_RED);
return 1;
}
SetPlayerArmour(receiverid, armamount);
return 1;
}
//----------------------------------------------------------------------------------------------GUN
if(strcomp(cmd, "/givegun", true) == 1)
{
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
new ammamount;
ammamount = strval(strcharsplit(text, idx,strchar(" ")));

if ((ammamount < 0) || (ammamount > 46))
{
SendPlayerFormattedText(playerid, lang_texts[12][45] , 0,COLOUR_RED);
return 1;
}

GivePlayerWeapon(receiverid,ammamount,1000);

new string[MAX_STRING];
format(string,sizeof(string), lang_texts[12][46] ,oGetPlayerName(playerid),oGetWeaponName(ammamount), ammamount,1000);			//игроку
SendPlayerFormattedText(receiverid,string, 0,COLOUR_XP_GOOD);
format(string,sizeof(string), lang_texts[12][47] ,oGetPlayerName(receiverid),receiverid,oGetWeaponName(ammamount) ,ammamount,1000);
SendPlayerFormattedText(playerid,string, 0,COLOUR_XP_GOOD);
return 1;
}

if(strcomp(cmd, "/paralyze", true) == 1)
{
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
if (IsPlayerNPC(receiverid))
{
SendPlayerFormattedText(playerid, lang_texts[12][2] , 0,COLOUR_RED);
return 1;
}
TogglePlayerControllable(receiverid,0);

new string[MAX_STRING];
format(string,sizeof(string), lang_texts[12][54] ,oGetPlayerName(playerid));			//игроку
SendPlayerFormattedText(receiverid,string, 0,COLOUR_XP_GOOD);
format(string,sizeof(string), lang_texts[12][55] ,oGetPlayerName(receiverid));
SendPlayerFormattedText(playerid,string, 0,COLOUR_XP_GOOD);
return 1;
}

if(strcomp(cmd, "/deparalyze", true) == 1)
{
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
TogglePlayerControllable(receiverid,1);

new string[MAX_STRING];
format(string,sizeof(string), lang_texts[12][56] ,oGetPlayerName(playerid));			
SendPlayerFormattedText(receiverid,string, 0,COLOUR_XP_GOOD);
format(string,sizeof(string), lang_texts[12][57] ,oGetPlayerName(receiverid));
SendPlayerFormattedText(playerid,string, 0,COLOUR_XP_GOOD);
return 1;
}

return 0;
}

public BanLog(string[])
{
	new File:hFile;
	if (!fexist("GTO/gto_ban.log"))
{
	hFile=fopen("GTO/gto_ban.log",io_write);
	fclose(hFile);
}
	new entry[MAX_STRING];
	format(entry, sizeof(entry), "%s\n",string);
	
	hFile = fopen("GTO/gto_ban.log", io_append);
	fwrite_utf8(hFile, entry);
	fclose(hFile);
}
