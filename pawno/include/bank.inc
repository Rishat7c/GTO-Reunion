//
// Created: 18.12.2007
// Aurthor: Dmitry Frolov (FP)
// ReCreated: Artem Firstov (Konsul)

#if defined _bank_included
#endinput
#endif

#define _bank_included
#pragma library bank
#include "base"
#include "player"

forward BankInit();
forward IsPlayerAtBank(playerid);
forward OnPlayerEnterBankCheckpoint(playerid);
forward BankCommandHandler(playerid,text[]);

forward PlayerAddMoneyToBank(playerid,amount);
forward PlayerGetMoneyFromBank(playerid,amount);

forward DialogPlayerBank(playerid);

#define BanksCount 4

new Banks[BanksCount][CoordInfo] = {
	{-22.9578,-54.8951,1003.5469}, // LV 24/7 bank
	{371.2316,-125.5778,1001.4995}, // LS pizza bank
	{368.7201,-72.7097,1001.5078}, // LS burger bank7
	{826.1130,3.3117,1004.1797} // LS chicken bank5
};

new PlayerBankSelect[MAX_PLAYERS];

public DialogPlayerBank(playerid)
{
if (!IsPlayerConnected(playerid)) return 0;
ShowPlayerDialog(playerid,BGUI,DIALOG_STYLE_LIST,":: БАНК ::","Мой счет\nСчет банды","ОК","ЗАКРЫТЬ");
return 1;
}

/*
AddPlayerClass(294,-2038.4464,472.4764,35.1719,315.3448,0,0,0,0,0,0); // Точка выхода с SF
AddPlayerClass(294,2506.1272,2126.6125,10.8203,2.7906,0,0,0,0,0,0); // Точка выхода с LV
AddPlayerClass(294,1310.2745,-1372.4268,13.6019,180.5226,0,0,0,0,0,0); // Точка выхода с LS

Интерьер банка = 3
Координаты банка 833.269775,10.588416,1004.179687

AddPlayerClass(294,826.1130,3.3117,1004.1797,87.1839,0,0,0,0,0,0); // Позиция чекпоинта
AddPlayerClass(294,833.9465,7.3754,1004.1797,271.0889,0,0,0,0,0,0); // Точка пикапа Exit'a из банка
*/

new EnterSF, EnterLV, EnterLS, ExitSF, ExitLV, ExitLS;

public BankInit()
{
	for (new bankid=0;bankid<BanksCount;bankid++)
	{
		AddActiveCheckpoint(Banks[bankid][Coord_X],Banks[bankid][Coord_Y],Banks[bankid][Coord_Z],20,8);
	}
	// Точки входа в банк
	EnterSF = CreatePickup(1318,1,-2049.3223,461.5894,35.1719,0); // Вход в банк SF
	Create3DTextLabel("БАНК", COLOR_GREEN, -2049.3223,461.5894,35.1719, 45.0 , 0, 1);
	CreateStreamMapIcon(52,-2049.3223,461.5894,35.1719);
	EnterLV = CreatePickup(1318,1,2506.2771,2123.6609,10.8203,0); // Вход в банк LV
	Create3DTextLabel("БАНК", COLOR_GREEN, 2506.2771,2123.6609,10.8203, 45.0 , 0, 1);
	CreateStreamMapIcon(52,2506.2771,2123.6609,10.8203);
	EnterLS = CreatePickup(1318,1,1310.2627,-1368.5656,13.5510,0); // Вход в банк LS
	Create3DTextLabel("БАНК", COLOR_GREEN, 1310.2627,-1368.5656,13.5510, 45.0 , 0, 1);
	CreateStreamMapIcon(52,1310.2627,-1368.5656,13.5510);
// Точки выхода из банка
	ExitSF = CreatePickup(1318,1,833.9465,7.3754,1004.1797,5); // Выход из банка SF
	ExitLV = CreatePickup(1318,1,833.9465,7.3754,1004.1797,6); // Выход из банка LV
	ExitLS = CreatePickup(1318,1,833.9465,7.3754,1004.1797,7); // Выход из банка LS
	WriteLog("Banking checkpoints initialised");
}

forward Ba_OnPlayerPickUpPickup(playerid, pickupid);
public Ba_OnPlayerPickUpPickup(playerid, pickupid)
{
	if(pickupid == EnterSF)
	{
		SetPlayerPosEx(playerid,833.269775,10.588416,1004.179687);
		SetPlayerFacingAngle(playerid,180);
		SetPlayerInterior(playerid,3);
        oSetPlayerVirtualWorld(playerid,5);// Виртуальный мир банка SF
	}
	if(pickupid == EnterLV)
	{
		SetPlayerPosEx(playerid,833.269775,10.588416,1004.179687);
		SetPlayerFacingAngle(playerid,180);
		SetPlayerInterior(playerid,3);
        oSetPlayerVirtualWorld(playerid,6);// Виртуальный мир банка LV
	}
	if(pickupid == EnterLS)
	{
		SetPlayerPosEx(playerid,833.269775,10.588416,1004.179687);
		SetPlayerFacingAngle(playerid,180);
		SetPlayerInterior(playerid,3);
        oSetPlayerVirtualWorld(playerid,7);// Виртуальный мир банка LS
	}
	if(pickupid == ExitSF)
	{
		SetPlayerPosEx(playerid,-2038.4464,472.4764,35.1719);
		SetPlayerFacingAngle(playerid,180);
		SetPlayerInterior(playerid,0);
        oSetPlayerVirtualWorld(playerid,0);
	}
	if(pickupid == ExitLV)
	{
		SetPlayerPosEx(playerid,2506.1272,2126.6125,10.8203);
		SetPlayerFacingAngle(playerid,180);
		SetPlayerInterior(playerid,0);
        oSetPlayerVirtualWorld(playerid,0);
	}
	if(pickupid == ExitLS)
	{
		SetPlayerPosEx(playerid,1310.2745,-1372.4268,13.6019);
		SetPlayerFacingAngle(playerid,180);
		SetPlayerInterior(playerid,0);
        oSetPlayerVirtualWorld(playerid,0);
	}
	return 1;
}

public IsPlayerAtBank(playerid)
{
	for (new bankid=0;bankid<BanksCount;bankid++)
	{
		if (oIsPlayerInCheckpoint(playerid,Banks[bankid][Coord_X],Banks[bankid][Coord_Y],Banks[bankid][Coord_Z],8))
		{
			return 1;
		}
	}
	return 0;
}

public OnPlayerEnterBankCheckpoint(playerid)
{
	//if (playerid == INVALIDX_PLAYER_ID) return;
	//if (playerid == INVALID_PLAYER_ID) return;
	//if (!IsPlayerConnected(playerid)) return;
	if (!IsPlayerAtBank(playerid)) return;
	SendPlayerFormattedText(playerid,  lang_texts[2][1]  , 0,COLOUR_GREEN);
	SendPlayerFormattedText(playerid,  lang_texts[2][2]  , Player[playerid][Bank],COLOUR_GREEN);
}

public PlayerGetMoneyFromBank(playerid,amount)
{
if (amount <= 0)
{
SendPlayerFormattedText(playerid,  lang_texts[2][5]  , 0,COLOUR_RED);
return 1;
}
if (amount > Player[playerid][Bank])
{
amount = Player[playerid][Bank];
}
oGivePlayerMoney(playerid,amount,0);
Player[playerid][Bank] = Player[playerid][Bank] - amount;
new string[MAX_STRING];
format(string,sizeof(string), lang_texts[2][6]  ,amount,Player[playerid][Bank]);
SendPlayerFormattedText(playerid, string,0,COLOUR_GREEN);
new Float:playerx,Float:playery,Float:playerz;
GetPlayerPos(playerid,playerx,playery,playerz);
PlayerPlaySound(playerid,1084,playerx,playery,playerz);

new logstring[256];
format(logstring, sizeof (logstring), "player: %d:  %s: withdrawed $%d from the bank. Current balance: $%d ",playerid,oGetPlayerName(playerid),amount,Player[playerid][Bank]);
WriteLog(logstring);
return 1;
}

public PlayerAddMoneyToBank(playerid,amount)
{
if (amount <= 0)
{
SendPlayerFormattedText(playerid,  lang_texts[2][9]  , 0,COLOUR_RED);
return 1;
}
if (oGetPlayerMoney(playerid) < amount)
{
amount = oGetPlayerMoney(playerid);
}
if (Player[playerid][Bank] + amount > MAX_BANK)
{
amount = MAX_BANK - Player[playerid][Bank];
}
oGivePlayerMoney(playerid,0 - amount,0);
Player[playerid][Bank] = Player[playerid][Bank] + amount;
new string[MAX_STRING];
format(string,sizeof(string), lang_texts[2][10]  ,amount,Player[playerid][Bank]);
SendPlayerFormattedText(playerid, string,0,COLOUR_GREEN);
new Float:playerx,Float:playery,Float:playerz;
GetPlayerPos(playerid,playerx,playery,playerz);
PlayerPlaySound(playerid,1083,playerx,playery,playerz);

new logstring[256];
format(logstring, sizeof (logstring), "player: %d:  %s: deposited $%d at the bank. Current balance: $%d ",playerid,oGetPlayerName(playerid),amount,Player[playerid][Bank]);
WriteLog(logstring);

if (Player[playerid][Bank] == MAX_BANK)
{
SendPlayerFormattedText(playerid,  lang_texts[2][11]  , 0,COLOUR_RED);
set(logstring,nullstr);
format(logstring, sizeof (logstring), "player: %d:  %s: His bank is full",playerid,oGetPlayerName(playerid));
WriteLog(logstring);
}
return 1;
}



public BankCommandHandler(playerid,text[]) // process player commands
{
if (!IsPlayerConnected(playerid)) return 0;

new cmd[20];
new idx;

set(cmd,strcharsplit(text, idx,strchar(" ")));
if (strlen(cmd) == 0) return 0;

if(strcomp(cmd, "/bankmenu", true) == 1)
{
if (!IsPlayerAtBank(playerid))
{
SendPlayerFormattedText(playerid,  lang_texts[2][3]  , 0,COLOUR_RED);
return 1;
}
else
{
TogglePlayerControllable(playerid, 0);
//if(IsValidMenu(BankMenu)) ShowMenuForPlayer(BankMenu, playerid);
DialogPlayerBank(playerid);
return 1;
}
}

if(strcomp(cmd, "/withdraw", true) == 1)
{
if (!IsPlayerAtBank(playerid))
{
SendPlayerFormattedText(playerid,  lang_texts[2][3]  , 0,COLOUR_RED);
return 1;
}
	
set(cmd,strcharsplit(text, idx,strchar(" ")));
if (strlen(cmd) == 0)
{
SendPlayerFormattedText(playerid,  lang_texts[2][4]  , 0,COLOUR_RED);
return 1;
}
new amount = strval(cmd);
PlayerGetMoneyFromBank(playerid,amount);
return 1;
}


if((strcomp(cmd, "/bank", true) == 1) || (strcomp(cmd, "/deposit", true) == 1))
{
if (!IsPlayerAtBank(playerid))
{
SendPlayerFormattedText(playerid,  lang_texts[2][7]  , 0,COLOUR_RED);
return 1;
}

set(cmd,strcharsplit(text, idx,strchar(" ")));
if (strlen(cmd) == 0)
{
SendPlayerFormattedText(playerid,  lang_texts[2][8]  , 0,COLOUR_RED);
return 1;
}
new amount = strval(cmd);
PlayerAddMoneyToBank(playerid,amount);
return 1;
}

return 0;
}
