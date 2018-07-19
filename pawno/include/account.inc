//
// Created:     05.09.06
// Aurthor:    Iain Gilbert
// ReCreate: Artem Firstov (Konsul)
/*
Last ReCreated by Maxim Tsarkov (OFFREAL)
- - - - -
Добавлена защита от ботов при регистрации
При сохранении аккаунта игрок получает уведомление
*/

#if defined _account_included
#endinput
#endif

#define _account_included
#pragma library account
#include "base"
#include "utils\gtodudb"

forward AccountLoadConfig();
forward AccountSaveConfig();
forward AccountSave(playerid);
forward AccountLogin(playerid,password[]);
forward AccountCommandHandler(playerid,text[]);
forward AccountRegisterLogin(playerid);

forward DialogPlayerToReadRules(playerid);
forward DialogPlayerToRegister(playerid);
forward DialogPlayerToTuring(playerid);
forward DialogPlayerToLogin(playerid);

forward AccountRegister(playerid);
forward PassCharCheck(pass[]);
forward ResetPass(playerid,accname[]);
forward NewPass(playerid,newpassword[]);
forward UnbanIpFromName(playerid,accname[]);
forward GetSQLID(playerid);

new AccountDB[MAX_STRING] = "GTO/Account/";
//new ENCRYPTION_KEY[MAX_STRING] = "_C)2^K¬RPXjwE8b\\p{Df+=Q3(O*vgu9ZH[!1\"Le0->?/hSF<'xVzm]$4%5a`Jdny¦IUW@G7s6&l:k;i~ YsoMЈ.cBq#|}NrTtA,";
new ENCRYPTION_KEY_SQL[MAX_STRING] = "vLs BWVJh5ItGmz20dfK6eqwiPU1urOknTbHDQag8SCAolx3ZjRYF7M4yc9NXEp";
//ключ для SQL содержит только символы: A-Z a-z 0-9

new PlayerEmail[MAX_PLAYERS][MAX_NAME];
new PlayerPassword[MAX_PLAYERS][32];
new PlayerPasswordT[MAX_PLAYERS][32];
new PlayerInputCode[MAX_PLAYERS];
new PlayerCreationDate[MAX_PLAYERS][MAX_STRING];
new PlayerLastLogin[MAX_PLAYERS][MAX_STRING];
new PlayerRegistered[MAX_PLAYERS];
new PlayerSQLID[MAX_PLAYERS];
new PlayerIP[MAX_PLAYERS][MAX_NAME];

enum Enumcode{
Param_Code,
Param_X1,
Param_X2
}
new Rcode[MAX_PLAYERS][Enumcode];

public AccountRegisterLogin(playerid)
{
	AccountLogin(playerid,PlayerPasswordT[playerid]);
	set(PlayerPasswordT[playerid],nullstr);
	return 1;
}

stock AccountSave(playerid)
{
	if(!IsPlayerRegistered(playerid))
	{
		return 0;
	}
	account_save_db_sql(playerid);
	return 1;
}

public PassCharCheck(pass[])
{
for (new i=0;i<strlen(pass);i++)
{
if (pass[i]==0) return 1; // null
if ((pass[i]<48) && (pass[i]!=32)) return 0;
if (pass[i]>57 && pass[i]<65) return 0;
if (pass[i]>90 && pass[i]<97) return 0;
if (pass[i]>122) return 0;
}
return 1;
}

public ResetPass(playerid,accname[])
{
if(!IsPlayerAdmin(playerid)) {
SendClientMessage(playerid,0xFFFFFFFF, "Вы должны быть админом RCON чтобы применить эту команду!");
return 0;}

if(!strlen(accname)) {
SendClientMessage(playerid,0xFFFFFFFF, "Вы не указали никнейм игрока!");
return 0;}

if(strlen(accname) < 3 || strlen(accname) >= MAX_PLAYER_NAME) {
SendClientMessage(playerid,0xFFFFFFFF, "Длина никнейма должна быть больше 2 но меньше 24 символов!");
return 0;}

new DBResult:RES;
new query[128];
format(query,sizeof(query),"SELECT id FROM players WHERE name = '%s' LIMIT 1",accname);
RES = xdb_query(ReunionDB,query);

if (!db_num_rows(RES)) {
SendClientMessage(playerid,0xFFFFFFFF, "Аккаунт с таким именем не найден в базе!");
return 0;
}

new sqlid = 0;
new var[8];
db_get_field(RES, 0, var, sizeof(var));
sqlid = strval(var);

new npass[32];
format(npass,sizeof(npass),"%d", minrand(10000,100000));

new pass[32];
set(pass,encryptbykey(npass,ENCRYPTION_KEY_SQL));

format(query, sizeof(query), "UPDATE players SET pass='%s' WHERE id=%d", pass ,sqlid);
xdb_query(ReunionDB,query);

format(query, sizeof(query), "RESET PASSWORD IN [SQLID:%d][P:%s] BY [ADM:%s][SQLID:%d]",sqlid,npass,oGetPlayerName(playerid),PlayerSQLID[playerid]);
WriteSQLLog(query);
	
format(query, sizeof(query), "Сгенерирован новый пароль (5 цифр):( %s ) для аккаунта SQLID %d. Сообщите его игроку!", npass,sqlid);
SendClientMessage(playerid,COLOUR_GREEN, query);
return 1;
}

public UnbanIpFromName(playerid,accname[])
{
if(!IsPlayerAdmin(playerid)) {
SendClientMessage(playerid,0xFFFFFFFF, "Вы должны быть админом RCON чтобы применить эту команду!");
return 0;}

if(!strlen(accname)) {
SendClientMessage(playerid,0xFFFFFFFF, "Вы не указали никнейм игрока!");
return 0;}

if(strlen(accname) < 3 || strlen(accname) >= MAX_PLAYER_NAME) {
SendClientMessage(playerid,0xFFFFFFFF, "Длина никнейма должна быть больше 2 но меньше 24 символов!");
return 0;}

new DBResult:RES;
new query[128];
format(query,sizeof(query),"SELECT ip FROM players WHERE name = '%s' LIMIT 1",accname);
RES = xdb_query(ReunionDB,query);

if (!db_num_rows(RES)) {
SendClientMessage(playerid,0xFFFFFFFF, "Аккаунт с таким именем не найден в базе!");
return 0;
}

new ip[24];
db_get_field(RES, 0, ip, sizeof(ip));

format(query,sizeof(query),"unbanip %s",ip);
SendRconCommand(query);

format(query,sizeof(query),"Вы разбанили IP %s (если он был забанен), указанный в аккаунте игрока %s",ip,accname);
SendClientMessage(playerid,COLOUR_GREEN, query);
return 1;
}

public NewPass(playerid,newpassword[])
{
if (!IsPlayerRegistered(playerid))
{
SendClientMessage(playerid, COLOUR_MISC, lang_texts[1][58] );
return 0;
}

if(!strlen(newpassword))
{
SendClientMessage(playerid, COLOUR_MISC, lang_texts[1][57] );
return 0;
}

if(strlen(newpassword) <= 3)
{
SendClientMessage(playerid, COLOUR_MISC,  lang_texts[1][55] );
return 0;
}

if(strlen(newpassword) >= 16)
{
SendClientMessage(playerid, COLOUR_MISC,  lang_texts[1][56] );
return 0;
}

if(!PassCharCheck(newpassword))
{
SendClientMessage(playerid, COLOUR_MISC, " Недопустимые символы в пароле, используйте a-z, A-Z, 0-9" );
return 0;
}

if(PlayerSQLID[playerid] == 0) {return 0;}

new pass[32];

set(pass,encryptbykey(newpassword,ENCRYPTION_KEY_SQL));
set(PlayerPassword[playerid],pass);

new query[128];
format(query, sizeof(query), "UPDATE players SET pass='%s' WHERE id=%d", pass ,PlayerSQLID[playerid]);
xdb_query(ReunionDB,query);

format(query, sizeof(query), lang_texts[1][59], newpassword);
SendClientMessage(playerid,COLOUR_GREEN, query);

return 1;
}

public GetSQLID(playerid)
{
if (!IsPlayerRegistered(playerid)) {return 0;}
new str[MAX_STRING];
format(str,sizeof(str), "Ваш SQLID %d", PlayerSQLID[playerid]);
SendClientMessage(playerid,COLOUR_GREEN, str);
return 1;
}
//==================================== АнтиБотСистема ========================================================
//============================================================================================================
Rand(min, max)                  //функция для генерации рандомных чисел при проверке на бот
{ 
   return random(max - min) + min; 
} 

Turing(playerid) //функция выводит на экран код безопасности
{
Rcode[playerid][Param_X1] = Rand(1,11); //генерация первого числа
Rcode[playerid][Param_X2] = Rand(1,11); //генерация второго числа
Rcode[playerid][Param_Code] = Rcode[playerid][Param_X1] * Rcode[playerid][Param_X2];

return 1;
}

public AccountLogin(playerid,password[]) //эта функция логиняет уже зарегистрированного игрока
{
	if (PlayerRegistered[playerid])
	{
		SendClientMessage(playerid, COLOR_ORANGE, lang_texts[1][1] );
		return 0;
	}

	if ( account_login_db_sql(playerid,password) == 0 ) { return 0; }

	if (!IsPlayerRegistered(playerid))
	{
		return 0;
	}

	player_load_db_sql(playerid);

	GivePlayerOwnedWeapons(playerid);

	//welcome!
	new string[MAX_STRING];

	if (IsPlayerAdmin(playerid))
	{
		format(string,sizeof(string),"~w~Welcome ~n~~b~RCON Admin ~n~~y~%s",oGetPlayerName(playerid));
		GameTextForPlayer(playerid,string,2000,1);
		SendClientMessage(playerid,COLOR_ORANGE,  lang_texts[1][25] );
	}
	else if (IsPlayerAdm(playerid))
	{
		format(string,sizeof(string),"~w~Welcome ~n~~b~Admin ~n~~y~%s",oGetPlayerName(playerid));
		GameTextForPlayer(playerid,string,2000,1);
		SendClientMessage(playerid,COLOR_ORANGE,  lang_texts[1][26] );
	}
	else if (IsPlayerMod(playerid))
	{
		format(string,sizeof(string),"~w~Welcome ~n~~g~Moderator ~n~~y~%s",oGetPlayerName(playerid));
		GameTextForPlayer(playerid,string,2000,1);
		SendClientMessage(playerid,COLOR_ORANGE,  lang_texts[1][27] );
	}
	else
	{
		format(string,sizeof(string),"~w~Welcome ~n~~g~Player ~n~~y~%s",oGetPlayerName(playerid));
		GameTextForPlayer(playerid,string,2000,1);
		SendClientMessage(playerid,COLOR_ORANGE,  lang_texts[1][2] );
	}

	if(!IsPlayerAdmin(playerid) && !IsPlayerAdm(playerid) && !IsPlayerMod(playerid))
	{
		format(string,sizeof(string), lang_texts[1][17] ,oGetPlayerName(playerid),playerid);
		SendClientMessageToRegistered(COLOR_GREY, string);
	}

	TDS_AccLoad(playerid);
	Pack_OnAccLogin(playerid);

	new logstring[256];
	format(logstring, sizeof (logstring), "player: %d:  %s: logged in successfully [%s]",playerid,oGetPlayerName(playerid),oGetPlayerIp(playerid));
	WriteLog(logstring);

	return true;
}

public AccountCommandHandler(playerid,text[]) // process account commands
{
	if (!IsPlayerConnected(playerid)) return 0;
	new cmd[20];
	new idx;
	
	set(cmd,strcharsplit(text, idx,strchar(" ")));

	if(strcomp(cmd, "/newpass", true) == 1)
	{
	
	new newpassword[24];
	set(newpassword,strcharsplit(text, idx, 0 ));
	
	NewPass(playerid,newpassword);
	return 1;
	}
	
	if(strcomp(cmd, "/mysqlid", true) == 1)
	{
	GetSQLID(playerid);
	return 1;
	}
	
	return 0;	
	}

public DialogPlayerToReadRules(playerid)
{
if (!IsPlayerConnected(playerid)) return 0;
new str[1024];
format(str,sizeof(str),"%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s ",lang_texts[20][23],lang_texts[20][24],lang_texts[20][25],lang_texts[20][26],lang_texts[20][27],lang_texts[20][28],lang_texts[20][29],lang_texts[20][30],lang_texts[20][31]);
ShowPlayerDialog(playerid,AGUI+3,0,":::ПРАВИЛА сервера!:::",str,"Я согласен","Отмена");
return 1;
/*
format(s,sizeof(s), "Добро пожаловать, %s!\nПожалуйста зарегистрируйтесь!\nВведите ваш пароль:", oGetPlayerName(playerid));
ShowPlayerDialog(playerid,AGUI,1,lang_texts[1][43],s,lang_texts[1][44],lang_texts[1][45]);
return 1;
*/
}

public DialogPlayerToRegister(playerid)
{
if (!IsPlayerConnected(playerid)) return 0;
new s[MAX_STRING];
format(s,sizeof(s), "{FFFFFF}Добро пожаловать, {AAAAAA}%s{FFFFFF}!\n\
Пожалуйста зарегистрируйтесь!\n\
%s\n\
Введите ваш пароль:", oGetPlayerName(playerid));
ShowPlayerDialog(playerid,AGUI,1,lang_texts[1][43],s,lang_texts[1][44],lang_texts[1][45]);
return 1;
}

public DialogPlayerToTuring(playerid)
{
if (!IsPlayerConnected(playerid)) return 0;
new s[MAX_STRING];
format(s,sizeof(s),"{FFFFFF}Введите защитный код (решите уравнение)\n%d x %d = ?",Rcode[playerid][Param_X1],Rcode[playerid][Param_X2]);
ShowPlayerDialog(playerid,AGUI+2,1,lang_texts[1][47],s,lang_texts[1][48],lang_texts[1][49]);
return 1;
}

public DialogPlayerToLogin(playerid)
{
if (!IsPlayerConnected(playerid)) return 0;
new s[MAX_STRING];
format(s,sizeof(s),"{FFFFFF}Добро пожаловать обратно, {444444}%s{FFFFFF}!\n\
%s\n\
Войдите на сервер, для этого\n\
введите ваш пароль:",oGetPlayerName(playerid));
ShowPlayerDialog(playerid,AGUI+1,1,lang_texts[1][51],s,lang_texts[1][52],lang_texts[1][45]);
return 1;
}

public AccountRegister(playerid)
{

if (PlayerRegistered[playerid])
{
SendClientMessage(playerid,COLOUR_RED,  lang_texts[1][10] );
return 1;
}

new logstring[256];

//sql
new DBResult:accreg;
new query[255];
format(query,sizeof(query),"SELECT id FROM players WHERE name = '%s' LIMIT 1",oGetPlayerName(playerid));
accreg = xdb_query(ReunionDB,query);
if(db_num_rows(accreg))
{
SendClientMessage(playerid,COLOUR_RED,  lang_texts[1][11] );
return 1;
}
//new pIP[24];
GetPlayerIp(playerid, PlayerIP[playerid], MAX_NAME );
set(PlayerLastLogin[playerid],oNow());

PlayerSQLID[playerid] = GetFreeSQLID("players");

new temp[32];
new email[24];
set(email,"not_use");

set(temp,encryptbykey( PlayerPasswordT[playerid],ENCRYPTION_KEY_SQL));
//set(temp,sqlencrypt(PlayerPasswordT[playerid]));

format(query, sizeof(query), "INSERT INTO players ( id, name, ip, pass, email, cdate, llogin ) VALUES ( %d, '%s', '%s','%s','%s','%s','%s')", PlayerSQLID[playerid], oGetPlayerName(playerid),PlayerIP[playerid], temp,email,PlayerLastLogin[playerid],PlayerLastLogin[playerid]);
xdb_query(ReunionDB,query);
format(logstring, sizeof (logstring), "[SQLite][%d] create account success %d %s P:[%s]", PlayerSQLID[playerid], playerid,oGetPlayerName(playerid),temp);
WriteSQLLog(logstring);

CreatePlayer(playerid);
SendClientMessage(playerid,COLOUR_GREEN,  lang_texts[1][12] );

SetTimerEx("AccountRegisterLogin",2000,0, "d", playerid);

WriteLog(logstring);
return 1;
}
