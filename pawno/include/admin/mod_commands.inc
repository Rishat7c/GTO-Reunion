//
// Created: 18.12.2007
// Aurthor: Dmitry Frolov (FP)
// ReCreated: Artem Firstov (Konsul)
/*
Last ReCreated by Maxim Tsarkov (OFFREAL)
- - - - -
Модератору разрешено кикать, убивать и садить в тюрьму игрока
Модератор может сказать что-либо в чат от имени MODER:
Модератор может дать игроку денег
*/

#if defined _mod_commands_included
#endinput
#endif

#define _mod_commands_included
#pragma library mod_commands
#include "base"
#include "player"

forward ModCommandHandler(playerid,text[]);
forward ModSpecialCommandHandler(playerid,text[]);

public ModCommandHandler(playerid,text[]) // process player commands
{
if (!IsPlayerConnected(playerid)) return 0;
if ( !IsPlayerMod(playerid) && !IsPlayerAdmin(playerid) && !IsPlayerAdm(playerid) )
{
return 0;
}
new cmd[20];
new idx;

//set(cmd,strcharsplit(text, idx,strchar(" ")));
//if(strcomp(cmd, "/mod", true) == 0) return 0;
set(cmd,strcharsplit(text, idx,strchar(" ")));

if((strcomp(cmd, "/cmdlist", true) == 1) || (strcomp(cmd, "/ahelp", true) == 1))
{
//SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);
//  SendClientMessage(playerid, COLOUR_LIGHTGREEN, "{006400}MODERATOR: {90EE90}'/cmdlist', '/about', '/plist', '/mute <ID>', 'supermute <ID>', ''/unmute <ID>', '/jail <ID>', '/unjail <ID>'");
//  SendClientMessage(playerid, COLOUR_LIGHTGREEN, "{006400}MODERATOR: {90EE90}'/msay', '/mkick', '/gohome', '/gowork', '/tele-to <id>', '/mkill <ID>'");
//  SendClientMessage(playerid, COLOUR_LIGHTGREEN, "{006400}MODERATOR: {90EE90}'/scanhelp', '/spechelp'");

// (!IsPlayerAdmin(playerid)) && (!IsPlayerAdm(playerid))

//if((strcomp(cmd, "/cmdlist", true) == 1) || (strcomp(cmd, "/ahelp", true) == 1))
//{
new ahelpstr[380];
if (IsPlayerMod(playerid) || IsPlayerAdm(playerid) || IsPlayerAdmin(playerid))strins(ahelpstr,"{1B1BE0}Команды Модератора\n", strlen(ahelpstr));
if (IsPlayerAdm(playerid) || IsPlayerAdmin(playerid))strins(ahelpstr,"{37DB45}Команды Администратора\n", strlen(ahelpstr));
if (IsPlayerAdmin(playerid))strins(ahelpstr,"{15D4ED}Команды RCON Администратора\n", strlen(ahelpstr));
ShowPlayerDialog(playerid, A_GUI, DIALOG_STYLE_LIST, " Команды администратора:", ahelpstr,"Ок", "Закрыть");
//return 1;
//}

return 1;
}

	//if(strcomp(cmd, "/getmyskin", true) == 1)
	//{
	//new skin, setat;
	//new str[64];
	//skin = GetPlayerSkin(playerid);
	//setat = GetPlayerState(playerid);
	//format(str,sizeof(str),"Ваш скин %d | State %d",skin,setat);
	//SendClientMessage(playerid, COLOUR_LIGHTRED, str);
	//return 1;
	//}
	
	

if(strcomp(cmd, "/about", true) == 1)
{
//SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);
SendClientMessage(playerid, COLOUR_LIGHTGREEN, lang_texts[15][41]);
SendClientMessage(playerid, COLOUR_LIGHTGREEN, lang_texts[15][42]);
SendClientMessage(playerid, COLOUR_LIGHTRED, lang_texts[15][43]);
SendClientMessage(playerid, COLOUR_LIGHTRED, lang_texts[15][44]);
return 1;
}

if(strcomp(cmd, "/msay", true) == 1)
{
SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

new string[MAX_STRING];
set(string,text);
strdel(string, 0, idx);
format(string,sizeof(string), lang_texts[12][94] ,string);
SendClientMessageToAll(COLOUR_WHITE, string);
return 1;
}

///-------------------------------Moder Kick sys ----------------------------------////

if(strcomp(cmd, "/mkick", true) == 1)
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
if (IsPlayerNPC(receiverid))
{
SendPlayerFormattedText(playerid, lang_texts[12][2] , 0,COLOUR_RED);
return 1;
}
new string[MAX_STRING];
format(string,sizeof(string), lang_texts[12][60] ,oGetPlayerName(receiverid),receiverid);
SendPlayerFormattedText(playerid,string, 0,COLOUR_XP_GOOD);
format(string,sizeof(string), lang_texts[12][95] ,oGetPlayerName(receiverid),receiverid);
SendClientMessageToAll(COLOUR_WHITE, string);
Kick(receiverid);
return 1;
}

//.------------------------------------------ModerKillSys--------------------------------------------------///

if(strcomp(cmd, "/mkill", true) == 1)
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
format(string,sizeof(string), lang_texts[12][96] ,oGetPlayerName(playerid));
SendPlayerFormattedText(receiverid,string, 0,COLOUR_XP_GOOD);
return 1;
}

//---------------------------------------------TPnaHatu--------------------------------------------------------////
/*if(strcomp(cmd, "/packupd", true) == 1)
{
if(!OnOffPackUpdate()) {SendClientMessage(playerid, 0xFFFFFFFF,"Вы ВЫКЛЮЧИЛИ обновление антенны пакетов");}
else {SendClientMessage(playerid, 0xFFFFFFFF,"Вы ВКЛЮЧИЛИ обновление антенны пакетов");}
return 1;
}
*/
//if(strcomp(cmd, "/plc", true) == 1)
//{
//EndRace(GetPlayerRace(playerid));
//CreateTableForPlayers();
// new str1[MAX_STRING];
// new str2[MAX_STRING];
// new str3[MAX_STRING];
// set(str1,"ABCDEF");
// set(str2,"ABCDEF");
// set(str3,"ABCDEF");
// strdel(str1, 0, 1);
// strdel(str2, 0, 4);
// strdel(str3, 4, 6);
// printf("%s %s %s",str1,str2,str3);
//new str[MAX_STRING];

//set(str,"/pm 3 Hello my friend!");
//new idr;
//printf("%s", strcharsplit(str, idr, strchar(" ")));
//printf("%s", strtok(str, idr) );
//printf("%s", strcharsplit(str, idr, strchar(" ")));
//printf("%s", strcharsplit(str, idr, 0 ));
//strdel(str,0,idr);
//printf("%s",str);
//format(str, sizeof(str), "~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~r~%d  ~w~::  ~b~%d", playerid, playerid+20);
//GemeTextForDMPlayers(18,str);
//new Area;
//new Area = Text3D:Create3DTextLabel("Test 3D Area", COLOUR_XP_GOOD, 0.0000, 0.0000, 0.0000, 200.0000, GetPlayerVirtualWorld(playerid), 0);
//Attach3DTextLabelToVehicle(Area, GetPlayerVehicleID(playerid), 0.0000, 0.0000, 5.0000);
//SetPlayerChatBubble(playerid, "Test Buble", COLOUR_XP_GOOD, 20.0000, 5000);
//return 1;
//}

/*

if(strcmp(cmd, "/ggun", true) == 0)
{
new tmp[256];
new str[256];
new adresat, wid, ammo, rwid, rammo;
new name[MAX_PLAYER_NAME];
//new tmp[256];
//idx = idx + 1;
tmp = strcharsplit(text, idx,strchar(" "));
if(!strlen(tmp))
{
SendClientMessage(playerid, 0xFFFFFFFF," Применение /ggun <id> wid ammo");
return 1;
}
adresat = strval(tmp);

tmp = strcharsplit(text, idx,strchar(" "));
if(!strlen(tmp))
{
SendClientMessage(playerid, 0xFFFFFFFF," Применение /ggun id <wid> ammo");
return 1;
}
wid = strval(tmp);

tmp = strcharsplit(text, idx,strchar(" "));
if(!strlen(tmp))
{
SendClientMessage(playerid, 0xFFFFFFFF," Применение /ggun id wid <ammo>");
return 1;
}
ammo = strval(tmp);

if(!IsPlayerConnected(adresat))
{
SendClientMessage(playerid, 0xFFFFFFFF," Неверный ид игрока!");
return 1;
}

for(new i=1;i<13;i++)
{
GetPlayerWeaponData(playerid, i, rwid, rammo);
if(wid == rwid && rammo >= ammo)
{
GivePlayerWeapon(adresat, wid, ammo);
GivePlayerWeapon(playerid, wid, -ammo);
GetPlayerName(adresat, name, sizeof (name))
format(str, sizeof(str), " Вы передали игроку %s оружие %d и %d своих патронов к нему!" , name, wid, ammo);
SendClientMessage(playerid, 0xFFFFFFFF, str);
GetPlayerName(playerid, name, sizeof (name))
format(str, sizeof(str), " %s передал вам оружие %d и %d своих патронов к нему!" , name , wid, ammo);
SendClientMessage(adresat, 0xFFFFFFFF, str);

break;
}
else if(wid == rwid)
{
SendClientMessage(playerid, 0xFFFFFFFF, " Неверное количество патронов");
break;
}
}
return 1;
}


if (strcomp( cmd,"/gofast", true) == 1)
{
    if(IsPlayerInAnyVehicle(playerid))
    {
     new Float:x, Float:y, Float:z;
GetVehicleVelocity(GetPlayerVehicleID(playerid),x,y,z);
         x = x*20;
         y = y*20;
SetVehicleVelocity(GetPlayerVehicleID(playerid),x,y,z);
    }
    return 1;
}
 if(strcomp(cmd, "/npc", true) == 1)
{
ConnectNPC("NPC1", "npcidle");
for (new id=0; id < MAX_PLAYERS; id++)
{
if(!IsPlayerRegistered(id) && IsPlayerNPC(id))
{
AccountLogin(id,"0000");
}
}
return 1;
} */

//CallRemoteFunction("")

//if( strcmp(cmd, "/obj", true) == 0 )
//{
//new Float:X, Float:Y, Float:Z, Float:A;
//CreateObject(1225, X, Y, Z-3, 0, 0, 0);
// SetPlayerInterior(playerid,5);
// SetPlayerFacingAngle(playerid, 0);
//SetPlayerPosEx(playerid, 324.000,304.000,999.200);
//SetPlayerPosEx(playerid, -1537.0317,-430.1761,5.8516);
// SendClientMessage(playerid, COLOUR_GREEN, "Test");
//new obid;
//obid = strval(strcharsplit(text, idx,strchar(" ")));
//GetPlayerPos(playerid,X,Y,Z);
//GetPlayerFacingAngle(playerid, A);
//if (testOBJ == 0)
//{
//testOBJ = CreateObject(obid, X + Get_dx(A,10), Y + Get_dy(A,10), Z, 0, 0, 0);
//testOBJ = CreatePickup(obid, 15, X+10, Y, Z);
//}
//else
//{
//DestroyObject(testOBJ);
//DestroyPickup(testOBJ);
//testOBJ = 0;
//}
//return 1;
//}
// GameTextForPlayer(playerid,string,5000,st);
//return 1;
//}

//if( strcmp(cmd, "/startarena", true) == 0 )
//{
//SetPlayerInterior(playerid, 10);
//SetPlayerPosEx(playerid,-1079.99, 1061.58, 1343.04);
//return 1;
//}

//if (strcmp(cmd, "/piss",true) == 0) {
//ApplyAnimation(playerid, "PAULNMAC", "Piss_in", 4.9, 9, 9, 9, 9, 9);
//SetPlayerSpecialAction(playerid, 68);
//SendClientMessage(playerid, COLOR_GREEN," неписай где папало писю атморозеш xD ");
//return 1;
//}

//if(strcomp(cmd, "/beer", true) == 1)
//{
//SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DRINK_BEER);
//return 1;
//}
//if(strcmp(cmd, "/drugs", true) == 0)
//    {
//        SetPlayerWeather(playerid, -66);
//        return 1;
//    }

/*
if(strcomp(cmd, "/dinic", true) == 1)
{
new value;
new temp[255];
value = -1900245249;
valstr(temp,value);
printf("%s",temp);
return 1;
}
*/

//if(strcomp(cmd, "/pack-benchmark", true) == 1) { return PackBench(); }

if(strcomp(cmd, "/gohome", true) == 1)
{
SetPlayerInterior(playerid,10);
SetPlayerFacingAngle(playerid, 0);
SetPlayerPosEx(playerid, 246.000 ,112.000 ,1003.22);
SendClientMessage(playerid, COLOUR_GREEN, "Вы вернулись в Администрацию");
return 1;
}

if((strcomp(cmd, "/gocity", true) == 1) || (strcomp(cmd, "/gowork", true) == 1))
{
SetPlayerInterior(playerid,0);
SetPlayerFacingAngle(playerid, 270);
SetPlayerPosEx(playerid, 1956.000 ,1343.000 ,15.38);
SendClientMessage(playerid, COLOUR_GREEN, "Вы вернулись в Город");
return 1;
}

if(strcomp(cmd, "/tele-to", true) == 1)
{
	SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

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
	new Float:X;
	new Float:Y;
	new Float:Z;
	new Float:Angle;
	new interior;
	new vw;
	GetPlayerPos(receiverid,X,Y,Z);
	GetPlayerFacingAngle(receiverid,Angle);
	interior = GetPlayerInterior(receiverid);
	vw = GetPlayerVirtualWorld(receiverid);

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
	oSetPlayerVirtualWorld(playerid,vw);
	new string[MAX_STRING];
	format(string,sizeof(string), lang_texts[12][66] ,oGetPlayerName(receiverid),receiverid);
	SendPlayerFormattedText(playerid,string, 0,COLOUR_XP_GOOD);
	return 1;
}

//-----------------Scan_ID---------------------//
if(strcomp(cmd, "/scan", true) == 1)
{
SendClientMessage(playerid,COLOUR_BLUE," __");
SendClientMessage(playerid,COLOUR_BLUE,"|      MIRANDA v2.1 ::: Player ID Weapons Scaner");
new scanid;
scanid = strval(strcharsplit(text, idx,strchar(" ")));
if(!IsPlayerConnected(scanid))
{
SendClientMessage(playerid,COLOUR_ORANGE, "|__  MIRANDA OUTPUT >>> ERROR: Wrong ID, Player OFFLINE");
return 1;
}
new title[MAX_STRING];
format(title,sizeof(title),"|---  Checked | Player %s | id %d | Level %d" ,oGetPlayerName(scanid), scanid, GetPlayerLevel(scanid));

new isadm = 0;

if(IsPlayerAdmin(scanid)) {format(title,sizeof(title),"%s | [RCON ADMIN]" ,title); isadm = 1;}
else if(IsPlayerAdm(scanid)) {format(title,sizeof(title),"%s | [GAME ADMIN]" ,title);  isadm = 1;}
else if(IsPlayerMod(scanid)) {format(title,sizeof(title),"%s | [MODEREATOR]" ,title);}
else if(IsPlayerNPC(scanid)) {format(title,sizeof(title),"%s | [NPC]" ,title);}
else {format(title,sizeof(title),"%s | [USER]" ,title);}

SendClientMessage(playerid,COLOUR_ORANGE,title);
new status = 0;
new ammo;
new weaponid;
//new slotid = 1;
new dmid = 0;
new indm = 0;
new string[MAX_STRING];
if(IsPlayerInAnyDM(scanid))
{
indm = 1;
dmid = GetPlayerDM(scanid);
//new dmname = Deathmatch[dmid][dm_name];
//new dman[MAX_STRING];
format(string,sizeof(string),"|--  Player in %d DM %s ",dmid,Deathmatch[dmid][dm_name]);
SendClientMessage(playerid,COLOUR_BLUE, string);
}
//while(slotid <= 12)
for(new slotid = 1;slotid<12;slotid++)
{
GetPlayerWeaponData(scanid,slotid,weaponid,ammo);
format(string,sizeof(string),"|-  Slot %d  |  %s  |  %d", slotid, oGetWeaponName(weaponid), ammo);

//if(!IsPlayerAllowedWeapon(scanid,weaponid) && !IsPlayerAdmin(scanid) && !IsPlayerAdm(scanid) && (weaponid != 0) && (weaponid != 46))
if(!IsPlayerAllowedWeapon(scanid,weaponid) && (weaponid != 0) && (weaponid != 46))
{
if(indm)
{
if(Weapons[weaponid][Weapon_Allowed] == 1 && IsWeaponAllowedInDM(weaponid,dmid))
{
SendClientMessage(playerid,COLOUR_BLUE,string);
}
if(Weapons[weaponid][Weapon_Allowed] == 0 || !IsWeaponAllowedInDM(weaponid,dmid))
{
SendClientMessage(playerid,COLOUR_CRIMSON,string);
status = 1;
}
}
else
{
if((weaponid >= 22) && (weaponid <= 33) && (Weapons[weaponid][Weapon_Allowed] == 1))
{
SendClientMessage(playerid,COLOR_LEMON,string);
}
else
{
SendClientMessage(playerid,COLOUR_CRIMSON,string);
status = 1;
}
}
}

else if(weaponid != 0)
{
SendClientMessage(playerid,COLOUR_GREEN,string);
}

//slotid=slotid+1;
}

if(status == 0)
{
SendClientMessage(playerid,COLOUR_LIME,"|__  MIRANDA OUTPUT >>> COMPLETED SUCCESS");
}
else
{
	if(isadm)
	{
	SendClientMessage(playerid,COLOUR_ORANGE,"|__  MIRANDA OUTPUT >>> NOT ALLOWED WEAPONS BUT PLAYER IS ADMIN");
	}
	else
	{
	SendClientMessage(playerid,COLOUR_CRIMSON,"|__  MIRANDA OUTPUT >>> DETECTED DANGER");
	PlayerPlaySound(playerid,1057,0,0,0);
	}
}
return 1;
}
//-------------------------Scan_All--------------------------------//
if(strcomp(cmd, "/scanall", true) == 1)
{
SendClientMessage(playerid,COLOUR_BLUE," __");
SendClientMessage(playerid,COLOUR_BLUE,"|      MIRANDA v2.1 ::: Total Weapons Scaner");
new weaponid;
new ammo;
new status = 0;

//new scanid = 0;
//while(scanid <= MAX_PLAYERS)
set(cmd,strcharsplit(text, idx,strchar(" ")));

for(new scanid = 0;scanid<MAX_PLAYERS;scanid++)
{
if(!IsPlayerConnected(scanid)) {continue;} // ignore free slots
if(IsPlayerNPC(scanid)) {continue;} // ignore NPCs
	if(cmd[0] != 109) // m
	{
	if(IsPlayerAdmin(scanid)) {continue;} // ignore RCON Admins
	if(IsPlayerAdm(scanid)) {continue;} // ignore game admins
	}

//new slotid = 1;
//while(slotid <= 12)
for(new slotid = 1;slotid<12;slotid++)
{
GetPlayerWeaponData(scanid,slotid,weaponid,ammo);
if((weaponid != 0) && (weaponid != 46))
{
if(((weaponid < 22) || (weaponid > 33)) && !IsPlayerAllowedWeapon(scanid,weaponid) && !IsPlayerInAnyDM(scanid))
{
new enemy[MAX_STRING];
format(enemy,sizeof(enemy),"|-  Found danger | Player %s | id %d | Level %d | Slot %d | %s | %d",oGetPlayerName(scanid), scanid, GetPlayerLevel(scanid), slotid, oGetWeaponName(weaponid), ammo);
SendClientMessage(playerid,COLOUR_ORANGE,enemy);
PlayerPlaySound(playerid,1057,0,0,0);
status = 1;
}
if(IsPlayerInAnyDM(scanid) && !IsWeaponAllowedInDM(weaponid,GetPlayerDM(scanid)))
{
new enemy[MAX_STRING];
format(enemy,sizeof(enemy),"|-  Wrong weapon in %d DM| Player %s | id %d | Level %d | Slot %d | %s | %d",GetPlayerDM(scanid),oGetPlayerName(scanid), scanid, GetPlayerLevel(scanid), slotid, oGetWeaponName(weaponid), ammo);
SendClientMessage(playerid,COLOUR_ORANGE,enemy);
PlayerPlaySound(playerid,1057,0,0,0);
status = 1;
}
}

//slotid = slotid+1;
}
//scanid = scanid+1;
}
if(status == 0)
{
SendClientMessage(playerid,COLOUR_ORANGE,"|-  DANGER NOT FOUND");
SendClientMessage(playerid,COLOUR_LIME,"|__  MIRANDA OUTPUT >>> COMPLETED SUCCESS");
}
else
{
SendClientMessage(playerid,COLOUR_CRIMSON,"|__  MIRANDA OUTPUT >>> DETECTED DANGER");
}
return 1;
}
//--------------------------Scan_Help-------------------------
if(strcomp(cmd, "/scanhelp", true) == 1)
{
SendClientMessage(playerid,COLOUR_BLUE,"::: MIRANDA v2.1 ::: ::: Weapon Scaner FAQ :::");
SendClientMessage(playerid,COLOUR_WHITE,"Система MIRANDA предназначена для поиска запрещенного оружия у обычных игроков (status = 0)");
SendClientMessage(playerid,COLOUR_WHITE,"Для проверки определенного игрока используется команда '/scan id' - в чат будет выведен список его оружия");
SendClientMessage(playerid,COLOUR_WHITE,"Для проверки всех игроков - '/scanall', в чат будет выведен список нарушителей. Игнорируется синее и желтое оружие.");
SendClientMessage(playerid,COLOUR_WHITE,"Цвет найденного оружия имеет свое значение.");
SendClientMessage(playerid,COLOUR_BLUE,"Синее оружие: разрешенное в десматче :И: несоответствующее уровню in_DM игрока");
SendClientMessage(playerid,COLOUR_CRIMSON,"Красное оружие: запрещенное в десматче :ИЛИ: запрещенное в моде GTO :ИЛИ: несоответствующее уровню out_DM игрока");
SendClientMessage(playerid,COLOR_LEMON,"Желтое оружие: доступное у продавца в оружейном магазине :И: несоответствующее уровню out_DM игрока");
SendClientMessage(playerid,COLOUR_LIME,"Зеленое оружие: Разрешенное всеми критериями оружие");
return 1;
}

//-- муте
if (strcomp(cmd, "/mute", true) == 1)
{
	SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

	new muteid;
	muteid = strval(strcharsplit(text, idx,strchar(" ")));

	if ((muteid < 0) || (muteid >= MAX_PLAYERS))
	{
		SendPlayerFormattedText(playerid, lang_texts[12][22] , 0,COLOUR_RED);
		return 1;
	}
//-----
	if (IsPlayerConnected(muteid) == 0)
	{
		SendPlayerFormattedText(playerid, lang_texts[12][23] , 0,COLOUR_RED);
		return 1;
	}
//----
  	set(cmd,strcharsplit(text, idx,strchar(" ")));
  	if (strlen(cmd) == 0)
	{
		Player[muteid][Muted] = 1; // 1 - обычная мута

		new string[MAX_STRING];
		format(string,sizeof(string), lang_texts[12][24] ,oGetPlayerName(playerid));
		SendPlayerFormattedText(muteid,string, 0,COLOUR_RED);

		//GIVE MUTE INFO
		SetPlayerWantedLevel(muteid, 1);
		format(string,sizeof(string), lang_texts[12][50], oGetPlayerName(muteid));
		
		SendClientMessageToAll(COLOUR_WHITE, string);
		printf("SERVER : %s Has Been Muted by %s",oGetPlayerName(muteid),oGetPlayerName(playerid));
		return 1;
	}

	if(cmd[0] != 100 && cmd[0] != 104 && cmd[0] != 109 && cmd[0] != 115)
	{
	SendClientMessage(playerid, COLOUR_LIGHTGREEN, "Применение /mute id (d/h/m/s)число. (Пример: /mute 5 m10)");
	return 1;
	}
	
	new timestep = 0;
	new timeuni[24];
	
	if(cmd[0] == 100) {timestep = DAY_SEC; set(timeuni,"дня(дней)");}
	if(cmd[0] == 104) {timestep = HOU_SEC; set(timeuni,"часа(часов)");}
	if(cmd[0] == 109) {timestep = MIN_SEC; set(timeuni,"минуты(минут)");}
	if(cmd[0] == 115) {timestep = SEC_SEC; set(timeuni,"секунды(секунд)");}
	
	strdel(cmd, 0, 1);
	
	if(!strlen(cmd))
	{
	SendClientMessage(playerid, COLOUR_LIGHTGREEN, "Применение /mute id (d/h/m/s)число. (Пример: /mute 5 m10)");
	return 1;
	}
	
	new mutetime = strval(cmd)*timestep;
	
	if(mutetime > YEA_SEC) {mutetime = YEA_SEC;}
		
	Player[muteid][Muted] = AddToNow(mutetime);
	SetPlayerWantedLevel(muteid, 3);
	
	new string[MAX_STRING];
	format(string,sizeof(string), "Вам запретили говорить в течении %d %s",(mutetime/timestep),timeuni);
	SendPlayerFormattedText(muteid,string, 0,COLOUR_RED);
	SendPlayerFormattedText(muteid,"Чтобы узнать сколько вам еще молчать попробуйте написать что-нибудь в чат", 0,COLOUR_RED);
	format(string,sizeof(string), "ВЫ запретили '%s' говорить в течении %d %s",oGetPlayerName(muteid),(mutetime/timestep),timeuni);
	SendPlayerFormattedText(playerid,string, 0,COLOUR_GREEN);
	
return 1;
}

if (strcomp(cmd, "/supermute", true) == 1)
{
	SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);
	new hmuteid;
	hmuteid = strval(strcharsplit(text, idx,strchar(" ")));
	if ((hmuteid < 0) || (hmuteid >= MAX_PLAYERS))
	{
		SendPlayerFormattedText(playerid, lang_texts[12][22] , 0,COLOUR_RED);
		return 1;
	}
	if (IsPlayerConnected(hmuteid) == 0)
	{
		SendPlayerFormattedText(playerid, lang_texts[12][23] , 0,COLOUR_RED);
		return 1;
	}
	Player[hmuteid][Muted] = 2;
	new string[MAX_STRING];
	format(string,sizeof(string), lang_texts[12][99] ,oGetPlayerName(playerid));
	SendPlayerFormattedText(hmuteid,string, 0,COLOUR_RED);
	SetPlayerWantedLevel(hmuteid, 2);
	printf("SERVER : %s Has Been Super Muted by %s",oGetPlayerName(hmuteid),oGetPlayerName(playerid));
	return 1;
}

if (strcomp(cmd, "/unmute", true) == 1)
{
	SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

	new unmuteid;
	unmuteid = strval(strcharsplit(text, idx,strchar(" ")));

	if ((unmuteid < 0) || (unmuteid >= MAX_PLAYERS))
	{
		SendPlayerFormattedText(playerid, lang_texts[12][25] , 0,COLOUR_RED);
		return 1;
	}

	if (IsPlayerConnected(unmuteid) == 0)
	{
		SendPlayerFormattedText(playerid, lang_texts[12][26] , 0,COLOUR_RED);
		return 1;
	}

	Player[unmuteid][Muted] = 0;

	new string[MAX_STRING];
	format(string,sizeof(string), lang_texts[12][27] ,oGetPlayerName(playerid));
	SendPlayerFormattedText(unmuteid,string, 0,COLOUR_GREEN);

	//GIVE UNMUTE INFO
	SetPlayerWantedLevel(unmuteid, 0);
	format(string,sizeof(string), lang_texts[12][51], oGetPlayerName(unmuteid));
	//GameTextForAll(string,5000,4);
	SendClientMessageToAll(COLOUR_WHITE, string);
	printf("SERVER : %s Has Been UNMuted by %s",oGetPlayerName(unmuteid),oGetPlayerName(playerid));
	return 1;
}

if(strcomp(cmd, "/plist", true) == 1)
{
SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

SendClientMessage(playerid, COLOUR_YELLOW, lang_texts[18][1]);
new ccount;

for (new id = 0; id < MAX_PLAYERS; id++)
{
if ( IsPlayerConnected(id) && Player[id][Jailed] != 0 )
	{
	new string[MAX_STRING];
	if(Player[id][Jailed] == 1) {format(string,sizeof(string), lang_texts[18][5] ,oGetPlayerName(id), id);}
	else if(Player[id][Jailed] > 1){format(string,sizeof(string), lang_texts[18][4] ,oGetPlayerName(id), id);}
	SendClientMessage(playerid, COLOUR_LIGHTRED, string);
	ccount++;
	}
	if ( IsPlayerConnected(id) && Player[id][Muted] != 0 )
	{
	new string[MAX_STRING];
	if(Player[id][Muted] == 1) {format(string,sizeof(string), lang_texts[18][6] ,oGetPlayerName(id), id);}
	else if(Player[id][Muted] == 2){format(string,sizeof(string), lang_texts[18][7] ,oGetPlayerName(id), id);}
	else if(Player[id][Muted] > 2){format(string,sizeof(string), lang_texts[18][9] ,oGetPlayerName(id), id);}
	SendClientMessage(playerid, COLOUR_LIGHTGREEN, string);
	ccount++;
	}
}
if (ccount==0) { SendClientMessage(playerid, COLOUR_XP_GOOD, lang_texts[18][8] );}
return 1;
}

//Внимание! - Посаженный в тюрьму или "заткнутый" - не сможет обойти это - ни выходом, ни самоубийством!
if (strcomp(cmd, "/jail", true) == 1)
{
	SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

	new jailid;
	jailid = strval(strcharsplit(text, idx,strchar(" ")));

	if ((jailid < 0) || (jailid >= MAX_PLAYERS))
	{
	SendPlayerFormattedText(playerid, lang_texts[12][16] , 0,COLOUR_RED);
	return 1;
	}

	if (IsPlayerAdmin(jailid) && !IsPlayerAdmin(playerid))
	{
	SendPlayerFormattedText(playerid, "Вы не можете посадить администратора RCON" , 0,COLOUR_RED);
	return 1;
	}
//-----
	if (!IsPlayerConnected(jailid))
	{
		SendPlayerFormattedText(playerid, lang_texts[12][23] , 0,COLOUR_RED);
		return 1;
	}
//-----
	if (IsPlayerNPC(jailid))
	{
	SendPlayerFormattedText(playerid, lang_texts[12][2] , 0,COLOUR_RED);
	return 1;
	}
//-----
  	set(cmd,strcharsplit(text, idx,strchar(" ")));

	new string[MAX_STRING];

	//----------------JAIL-PERMANENT----------------------------------
  	if (strlen(cmd) == 0)
	{
		Player[jailid][Jailed] = 1; // 1 - обычная жайла

		format(string, sizeof (string), "JAIL [OUTLAW: %s][ID: %d] BY [COP: %s][ID: %d] MOD [permanent]",oGetPlayerName(jailid),jailid,oGetPlayerName(playerid),playerid);
		WriteLog(string);
	}
	//----------------------------------------------------------------
	else
	//----------------JAIL-TIME---------------------------------------
	{

	if(cmd[0] != 100 && cmd[0] != 104 && cmd[0] != 109 && cmd[0] != 115)
	{
	SendClientMessage(playerid, COLOUR_LIGHTGREEN, "Применение /jail id (d/h/m/s)число. (Пример: /jail 14 h2)");
	return 1;
	}

	new timestep = 0;
	new timeuni[24];
	new temp[16];

	if(cmd[0] == 100) {timestep = DAY_SEC; set(timeuni,"дня(дней)");}
	if(cmd[0] == 104) {timestep = HOU_SEC; set(timeuni,"часа(часов)");}
	if(cmd[0] == 109) {timestep = MIN_SEC; set(timeuni,"минуты(минут)");}
	if(cmd[0] == 115) {timestep = SEC_SEC; set(timeuni,"секунды(секунд)");}

	set(temp,cmd);
	strdel(cmd, 0, 1);

	if(!strlen(cmd))
	{
	SendClientMessage(playerid, COLOUR_LIGHTGREEN, "Применение /jail id (d/h/m/s)число. (Пример: /jail 14 h2)");
	return 1;
	}

	new jailtime = strval(cmd)*timestep;

	if(jailtime > YEA_SEC) {jailtime = YEA_SEC;}

	//Player[jailid][Jailed] = AddToNow(jailtime);
	Player[jailid][Jailed] = gettime() + jailtime;

	format(string,sizeof(string), "Вы будете сидеть за решеткой %d %s",(jailtime/timestep),timeuni);
	SendClientMessage(jailid, COLOUR_CRIMSON, string);
	SendClientMessage(jailid, COLOUR_CRIMSON, "Чтобы узнать сколько вам еще сидеть, перезайдите на сервер, или напишите в чат {FFFFFF}###");
	format(string,sizeof(string), "ВЫ посадили '%s' на %d %s",oGetPlayerName(jailid),(jailtime/timestep),timeuni);
	SendClientMessage(playerid, COLOUR_CRIMSON, string);

	format(string, sizeof (string), "JAIL [OUTLAW: %s][ID: %d] BY [COP: %s][ID: %d] MOD [%s]",oGetPlayerName(jailid),jailid,oGetPlayerName(playerid),playerid,temp);
	WriteLog(string);
	}
	//----------------------------------------------------------------

	//--------------------GET-JAIL-INFO-------------------------------
	format(string,sizeof(string), lang_texts[12][18] ,oGetPlayerName(playerid));
	SendClientMessage(jailid,COLOUR_RED,string);
	SetPlayerWantedLevel(jailid, 6);
	SetPlayerArmour(jailid, 0);
	oSetPlayerHealth(jailid, 10);
	ResetPlayerMoney(jailid);
	ResetPlayerWeapons(jailid);
	ADMDropAmmo(jailid);
	JailPlayer(jailid);
	PlayerPlaySound(jailid,1082,0.00,0.00,0.00);
	format(string,sizeof(string), "~r~%s ~w~has been Jailed", oGetPlayerName(jailid));
	GameTextForAll(string,3000,4);
	format(string,sizeof(string), lang_texts[12][52], oGetPlayerName(jailid));
	SendClientMessageToAll(COLOUR_WHITE, string);
	//---END-JAIL---

return 1;
}

if(strcomp(cmd, "/unjail", true) == 1)
{
SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

new unjailid;
unjailid = strval(strcharsplit(text, idx,strchar(" ")));

if ((unjailid < 0) || (unjailid >= MAX_PLAYERS) || (IsPlayerAdmin(unjailid) && !IsPlayerAdmin(playerid)) || (IsPlayerAdm(unjailid) && IsPlayerMod(playerid)) )
{
SendPlayerFormattedText(playerid, lang_texts[12][19] , 0,COLOUR_RED);
return 1;
}

if (IsPlayerConnected(unjailid) == 0)
{
SendPlayerFormattedText(playerid, lang_texts[12][20] , 0,COLOUR_RED);
return 1;
}

Player[unjailid][Jailed] = 0;
Player[unjailid][Muted] = 0;

new string[MAX_STRING];
format(string,sizeof(string), lang_texts[12][21] ,oGetPlayerName(playerid));
SendPlayerFormattedText(unjailid,string, 0,COLOUR_GREEN);

//GIVE UNJAIL INFO
SetPlayerWantedLevel(unjailid, 0);

format(string,sizeof(string), "~r~%s ~w~Now is Free", oGetPlayerName(unjailid));
GameTextForAll(string,5000,4);
printf("SERVER : %s Has Been UNJailed by %s",oGetPlayerName(unjailid),oGetPlayerName(playerid));

format(string,sizeof(string), lang_texts[12][53], oGetPlayerName(unjailid));
SendClientMessageToAll(COLOUR_WHITE, string);

UnJailPlayer(unjailid);
return 1;
}

//------------------------Spectating--------------------------
		if(strcomp(cmd, "/specplayer", true) == 1) {
	    new tmp[MAX_STRING];
		tmp = strcharsplit(text, idx,strchar(" "));

		if(!strlen(tmp)) {
			SendClientMessage(playerid, COLOR_WHITE, "Приминение: /specplayer [playerid]");
			return 1;
		}
		new specplayerid = strval(tmp);
		
		if(!IsPlayerConnected(specplayerid)) {
		    SendClientMessage(playerid, COLOR_RED, "--> Этот игрок оффлайн.");
			return 1;
		}		
		SpectatePlayer(playerid,specplayerid);
		return 1;
		}
//------------	
		if(strcomp(cmd, "/specvehicle", true) == 1) {
	    new tmp[MAX_STRING];
		tmp = strcharsplit(text, idx,strchar(" "));

		if(!strlen(tmp)) {
			SendClientMessage(playerid, COLOR_WHITE, "Приминение: /specvehicle [vehicleid]");
			return 1;
		}
		new specvehicleid = strval(tmp);
		SpectateVehicle(playerid,specvehicleid);
		return 1;
		}
//-----------
		if(strcomp(cmd, "/specoff", true) == 1) {
		SpectateOFF(playerid);
		return 1;
		}
//-----------
 	if(strcomp(cmd, "/spechelp", true) == 1) {
  		SpectateHelp(playerid);
  		return 1;
	}
		
return 0;
}

public ModSpecialCommandHandler(playerid,text[])
{
if (!IsPlayerConnected(playerid)) return 0;

if(text[0] == '@')
{
new string[MAX_STRING];
strmid(string,text,1,strlen(text));
new count = 0;
for (new adminid=0; adminid<MAX_PLAYERS;adminid++)
{
if (IsPlayerAdmin(adminid) || IsPlayerAdm(adminid) || IsPlayerMod(adminid))
//if (IsPlayerMod(adminid))
{
	new message[MAX_STRING];
	format(message,sizeof(message), lang_texts[12][79] ,oGetPlayerName(playerid),playerid,string);
	SendPlayerFormattedText(adminid,message, 0,COLOUR_RED);
	count++;
	}
}
if (count == 0)
	{
	SendPlayerFormattedText(playerid, lang_texts[12][80] , 0,COLOUR_RED);
	return 0;
	} else {
	new message[MAX_STRING];
	format(message,sizeof(message), lang_texts[12][81] ,string);
	SendPlayerFormattedText(playerid,message, 0,COLOUR_GREEN);
	return 0;
	}
}
return 0;
}

