//
// Created:     14.09.06
// Aurthor:    Iain Gilbert
// ReCreate: Artem Firstov (Konsul)
/*
Last ReCreated by Maxim Tsarkov (OFFREAL)
- - - - -
Убраны некоторые очень похожие цвета для банд
Оповещение о получении хр от члена банды работает только после 300хр
*/

#if defined _gang_included
  #endinput
#endif

#define _gang_included
#pragma library gang
#include "base"
#include "utils\gtoutils"
#include "utils\dutils"
#include "utils\gtodudb"
#include "utils\dini"

forward GangLoadConfig();
forward GangSaveConfig();
forward GetFreeMemberID();
forward GetOnlineGangID(gangname[]);

forward GangLoad(gangsqlid); // R10

forward GangCommandHandler(playerid,text[]);
forward PlayerGangColour(playerid);
forward GangJoinMember(gangid,playerid);
forward GangRemoveMember(gangid,kicksqlid,query);

forward GangRemove(gangid,par);

forward GangCreate(leaderid,gangname[],gangcolour);
forward GangCleanup(gangid);
forward GangSaveAll();
forward GangMemberLogout(playerid,gangid);
forward GangSave(gangid);
forward GangSaveCleanup(gangid);
forward CheckGangs();
forward GangUnload(gangid);
forward GangKill(gangid,killerid,victimid,reason);

forward GangMemberLogin(gangid,playerid); //R10

forward SendGangMessage(gangid,message[MAX_STRING],colour);
forward GangOnlineCount(gangid); //R10
forward GetFreeMemberSlots(gangid);
forward GangGiveXP(gangid,xpamount,giverid);
forward SetGangColour(gangid,colour);

forward GiveGangMoney(gangid,money,showtext);
forward PlayerAddMoneyToGangBank(playerid,amount);
forward PlayerGetMoneyFromGangBank(playerid,amount);

forward IsGangOnline(gangid);

forward SetGangXP(gangid,xpamount,giverid);
forward GetGangStat(playerid,gangid);

#define MAX_GANG_SIZE 30 // maximum number of ppl can be in any specific gang

#define GANG_XP_COLOR 1
#define GANG_XP_BUYOUT 2
#define GANG_XP_MAX 10000000

#define GANG_SAVE_DELAY 1000 //seconds

#define MAX_GANG_BANK 100000000

#define MAX_GANG_LEVEL 5 // Уровни банд
#define MAX_GANG_XP  60000000 // Уровни банд

new GANG_CREATE_COST = 150000; // money cost to create a gang
new GANG_CREATE_LEVEL = 10;		// level cost to create gang
new GANG_COLOUR_COST = 50000; // cost to change gang colour

/////
#define MAX_GANGS MAX_PLAYERS // maximum gangs (at runtime), (total maximum gangs is unlimited)
enum GangInfo {
 gang_active,
 gang_name[MAX_NAME],
    gang_colour,
    gang_kills,
    gang_score,
	gang_savetimer,
	gang_bank,
	gang_xp,
	gang_level,
	gang_tag[MAX_NAME],
	gang_zam
}
new Gangs[MAX_GANGS][GangInfo];
/////

enum ColourInfo {
 colour_name[MAX_NAME],
    colour_code
}

//     ------------ NEW gang colors system
#define COLOURS_SIZE 31 // ровно на 1 больше чем домов
new GangColours[COLOURS_SIZE][ColourInfo] = {
{ "Homeless",	G_COLOR_GANGHL}, 		// 0 - Homeleess gangs - default colour of gang > -1900245249

{ "White",		G_COLOR_WHITE},			//1 > -1
{ "Blood",		G_COLOR_RED},			//2 > -1439484929
{ "Origin",		G_COLOR_LIGHTRED},		//3 > -10270721
{ "Crimson",	G_COLOR_CRIMSON},		//4 > -602653441
{ "Half",		G_COLOR_HALFLIFE},		//5 > -273130753

{ "Lime",		G_COLOR_LIME},			//6 > 16711935
{ "Aqua",		G_COLOR_AQUA},			//7 > 16777215
{ "Khaki",		G_COLOR_KHAKI},			//8 > -1718025985
{ "Alien",		G_COLOR_ALIEN},			//9 > -1862301697
{ "Orange",		G_COLOR_ORANGE},		//10 > -6749953

{ "Oceanic",	G_COLOR_LIGHTGREEN},	//11 > -1697828097
{ "Green",		G_COLOR_DARKGREEN},		//12 > 311430143
{ "Blue",		G_COLOR_BLUE},			//13 > 866844671
{ "Bios",		G_COLOR_BIOS},			//14 > 65535
{ "Strange",	G_COLOR_DARKAQUA},		//15 > 8421631

{ "Magenta",	G_COLOR_MAGENTA},		//16 > -16711681
{ "Gold",		G_COLOR_GOLD},			//17 > -1199174657
{ "Violet",		G_COLOR_VIOLET},		//18 > -1722425601
{ "Pink",		G_COLOR_PINK},			//19 > -4142081
{ "Purple",		G_COLOR_PURPLE},		//20 > -1029514497

{ "Yellow",		G_COLOR_YELLOW},		//21 > -65281
{"Rbrown",		G_COLOR_ROSYBROWN},		//22 > -1131442177
{"Navy",		G_COLOR_NSEA},			//23 > 1047515647
{"Darkred",		G_COLOR_DARKRED},		//24 > -1962934017
{"Hotpink",		G_COLOR_HOTPINK},		//25 > -9849601

{"Coral",		G_COLOR_CORAL},			//26 > -8433409
{"GreenYellow",	G_COLOR_GREENYELL},		//27 > -1375784961
{"Darkslategr",	G_COLOR_DSLATEGRAY},	//28 > 793726975
{"Saddlebrown",	G_COLOR_SBROWN},		//29 > -1958407169
{"Midnight",	G_COLOR_MNIGHTBLUE}		//30 > 421097727
};

new GangSQLID[MAX_GANGS];

enum MemberInfo {
 member_online,
 member_name[MAX_NAME],
 member_sqlid
}
new GangMembers[MAX_GANGS][MAX_GANG_SIZE][MemberInfo];

stock GetGangLevel(gangid) return Gangs[gangid][gang_level];
stock SetGangLevel(gangid,level) return Gangs[gangid][gang_level] = level;
stock GetGangXP(gangid) return Gangs[gangid][gang_xp];

public GangLoadConfig()
{
    if (ForceOverwrite) return;
 if (!dini_Exists(ConfigDB)) return;
 new temp[MAX_STRING];
 //set(temp,dini_Get(ConfigDB,"Gang_DB"));
 //if (strlen(temp) > 0) set(GangDB,temp);
 //set(temp,nullstr);
 set(temp,dini_Get(ConfigDB,"Gang_Create_Cost"));
 if (strlen(temp) > 0) GANG_CREATE_COST = strval(temp);
 set(temp,nullstr);
 set(temp,dini_Get(ConfigDB,"Gng_Colour_Cost"));
 if (strlen(temp) > 0) GANG_COLOUR_COST =strval(temp);

 return;
}

public GangSaveConfig()
{
 if (!dini_Exists(ConfigDB)) return;
 new temp[MAX_STRING];
 //dini_Set(ConfigDB,"Gang_DB",GangDB);
 valstr(temp,GANG_CREATE_COST);
 dini_Set(ConfigDB,"Gang_Create_Cost",temp);
 valstr(temp,GANG_COLOUR_COST);
 dini_Set(ConfigDB,"Gang_Colour_Cost",temp);
 return;
}

/*
public GetFreeMemberID()
{
 for (new memberid = 1;memberid<MAX_GANG_SIZE*MAX_GANGS;memberid++)
 {
     if (GangMemberInfo[memberid][member_active] == 0)
     {
         return memberid;
  }
 }
 return 0;
}
*/
/*
public GetOnlineGangID(gangname[])
{
 for (new id=0;id<MAX_GANGS;id++)
 {
  if (Gangs[id][gang_active] == 1)
  {
   if (strcomp(gangname,Gangs[id][gang_name],true) == 1)
   {
       return id;
   }
  }
 }
 return 0;
}
*/

//
// ************************************* GANG LEVEL ******************************************************

#define GetGangXPToLevel(%1,%2) GangLevelList[%2] - Gangs[%1][gang_xp] // Уровни для банды

new GangLevelList[MAX_GANG_LEVEL+1] = {
	0, // 0
	500000, // 1
	1200000, // 2
	2200000, // 3
	3700000, // 4
	5700000 // 5
};

/*stock GetGangLevel(gangid) return Gangs[gangid][gang_level];
stock SetGangLevel(gangid,level) return Gangs[gangid][gang_level] = level;
stock GetGangXP(gangid) return Gangs[gangid][gang_xp];*/

stock GiveGangXP(gangid,xpamount)
{
	Gangs[gangid][gang_xp] += xpamount;
	CheckGangLevel(gangid);
}
stock SetGXP(gangid,xpamount)
{
	Gangs[gangid][gang_xp] = xpamount;
	CheckGangLevel(gangid);
}

stock CalculateGangLevel(gangid)
{
	for(new i = MAX_GANG_LEVEL; i != 0;--i)
	{
		if(GetGangXP(gangid) < GangLevelList[i]) continue;
		return i;
	}
	return 0;
}

stock CheckGangLevel(gangid) return Gangs[gangid][gang_level] = CalculateGangLevel(gangid);
// ************************************* /GANG LEVEL ******************************************************w
//

public IsGangOnline(gangid)
{ return Gangs[gangid][gang_active]; }

public GangLoad(gangsqlid) // EDITED R10
{
if(!gangsqlid) {WriteBugLog("<SYSTEM> GANG BUG - GandLoad(0)"); return -1;}
// search for gang in runtime memory
for (new id=0;id<MAX_GANGS;id++)
{
	if (Gangs[id][gang_active] == 1)
	{
		if (GangSQLID[id] == gangsqlid)
		{
			return id; // gang find in runtime memory
		}
	}
}

// not find in runtime memory

new gangid = -1;
for (new id=0;id<MAX_GANGS;id++)
{
	if(!Gangs[id][gang_active])
	{
		gangid = id;
		Gangs[id][gang_active] = true; // find first free gang slot and add gang
		break;
	}
}

if(gangid == -1) {WriteBugLog("<SYSTEM> GANG BUG - Can't find free gang slot!!!"); return gangid;}

gang_load_db_sql(gangid,gangsqlid); // load gang from database

return gangid;
}

stock gang_load_db_sql_Slow(gangid,gangsqlid) // EDITED R10
{
//new starttime = GetTickCount();
new query[128];
new tmp[128];
new DBResult:RES;
new DBResult:MRES;
format(query,sizeof(query),"SELECT * FROM gangs WHERE id = %d LIMIT 1",gangsqlid);
RES = xdb_query(ReunionDB,query);
if(!db_num_rows(RES))
{
format(tmp,sizeof(tmp),"Unable to load gang [SQLID %d]",gangsqlid);
WriteSQLLog(tmp);
return 0;
}
new var[32];

GangSQLID[gangid] = gangsqlid;

db_get_field(RES, 1, var, sizeof(var));
set(Gangs[gangid][gang_name],var);

db_get_field(RES, 2, var, sizeof(var));
Gangs[gangid][gang_colour] = strval(var); 

db_get_field(RES, 3, var, sizeof(var));
Gangs[gangid][gang_kills] = strval(var);

db_get_field(RES, 4, var, sizeof(var));
Gangs[gangid][gang_score] = strval(var);

db_get_field(RES, 5, var, sizeof(var));
Gangs[gangid][gang_bank] = strval(var);

for (new i = 0;i < MAX_GANG_SIZE;i++)
{
GangMembers[gangid][i][member_online] = 0;
db_get_field(RES, 6+i, var, sizeof(var)); // Было 6+i
GangMembers[gangid][i][member_sqlid] = strval(var);
	if(GangMembers[gangid][i][member_sqlid] > 0)
	{
		format(query,sizeof(query),"SELECT name FROM players WHERE id = %d LIMIT 1",GangMembers[gangid][i][member_sqlid]);
		MRES = xdb_query(ReunionDB,query);
		if(db_num_rows(MRES))
		{
			db_get_field(MRES, 0, var, sizeof(var));
			set(GangMembers[gangid][i][member_name],var);
		}
		else
		{
			format(tmp,sizeof(tmp),"<SYSTEM> GANG BUG - Can't find name of player with sqlid %d",GangMembers[gangid][i][member_sqlid]);
			WriteBugLog(tmp);
		}
	}
	else
	{
		set(GangMembers[gangid][i][member_name],"<FREE SLOT>");
	}
}

// 37 и 38

db_get_field(RES, 36, var, sizeof(var));
Gangs[gangid][gang_level] = strval(var);

db_get_field(RES, 37, var, sizeof(var));
Gangs[gangid][gang_xp] = strval(var);

db_get_field(RES, 38, var, sizeof(var));
set(Gangs[gangid][gang_tag],var);

db_get_field(RES, 39, var, sizeof(var));
Gangs[gangid][gang_zam] = strval(var);

new logstring[256];
format(logstring, sizeof (logstring), "GANG LOADED: [ID %d] [SQLID %d]",gangid,gangsqlid);
WriteLog(logstring);

//printf("Gang Loaded in %d ms",GetTickCount() - starttime);
return 1;
}

gang_load_db_sql(gangid,gangsqlid) // EDITED R10 BETA 8 // Fast Load!!!!
{
//new starttime = GetTickCount();
new query[MAX_STRING];
new tmp[128];
new DBResult:RES;
new DBResult:MRES;
format(query,sizeof(query),"SELECT * FROM gangs WHERE id = %d LIMIT 1",gangsqlid);
RES = xdb_query(ReunionDB,query);
if(!db_num_rows(RES))
{
format(tmp,sizeof(tmp),"Unable to load gang [SQLID %d]",gangsqlid);
WriteSQLLog(tmp);
return 0;
}
new var[32];

GangSQLID[gangid] = gangsqlid;

db_get_field(RES, 1, var, sizeof(var));
set(Gangs[gangid][gang_name],var);

db_get_field(RES, 2, var, sizeof(var));
Gangs[gangid][gang_colour] = strval(var); 

db_get_field(RES, 3, var, sizeof(var));
Gangs[gangid][gang_kills] = strval(var);

db_get_field(RES, 4, var, sizeof(var));
Gangs[gangid][gang_score] = strval(var);

db_get_field(RES, 5, var, sizeof(var));
Gangs[gangid][gang_bank] = strval(var);

format(query,sizeof(query),"SELECT id, name FROM players WHERE id IN (");

for (new i = 0;i < MAX_GANG_SIZE;i++)
{
GangMembers[gangid][i][member_online] = 0;
db_get_field(RES, 6+i, var, sizeof(var));// Было 6+i
GangMembers[gangid][i][member_sqlid] = strval(var);
	if(GangMembers[gangid][i][member_sqlid] > 0)
	{
	//printf("member %d | sqlid = %d",i, GangMembers[gangid][i][member_sqlid]);
		format(query,sizeof(query),"%s%d,", query, GangMembers[gangid][i][member_sqlid]);
		/*MRES = xdb_query(ReunionDB,query);
		if(db_num_rows(MRES))
		{
			set(GangMembers[gangid][i][member_name],var);
		}
		else
		{
			format(tmp,sizeof(tmp),"<SYSTEM> GANG BUG - Can't find name of player with sqlid %d",GangMembers[gangid][i][member_sqlid]);
			WriteBugLog(tmp);
		}*/
	}
	else
	{
		set(GangMembers[gangid][i][member_name],"<FREE SLOT>");
	}
}

db_get_field(RES, 36, var, sizeof(var));
Gangs[gangid][gang_level] = strval(var);

db_get_field(RES, 37, var, sizeof(var));
Gangs[gangid][gang_xp] = strval(var);

db_get_field(RES, 38, var, sizeof(var));
set(Gangs[gangid][gang_tag],var);

db_get_field(RES, 39, var, sizeof(var));
Gangs[gangid][gang_zam] = strval(var);

new m = strlen(query); query[m-1] = ')';
MRES = xdb_query(ReunionDB,query);

m = db_num_rows(MRES);

for (new i = 0;i < m;i++)
{
if(i > 0) {db_next_row(MRES);}
db_get_field(MRES, 0, var, sizeof(var));
	for (new y = 0;y < MAX_GANG_SIZE;y++)
	{
	if(GangMembers[gangid][y][member_sqlid] == 0) {continue;}
	if(GangMembers[gangid][y][member_sqlid] == strval(var))
		{
		db_get_field(MRES, 1, var, sizeof(var));
		set(GangMembers[gangid][y][member_name],var);
		continue;
		}
	}
}

new logstring[256];
format(logstring, sizeof (logstring), "GANG LOADED: [ID %d] [SQLID %d]",gangid,gangsqlid);
WriteLog(logstring);

//printf("Gang Loaded in %d ms",GetTickCount() - starttime);
return 1;
}

public GangCommandHandler(playerid,text[]) // process player commands
{

	new cmd[20];
	new idx;
	new tempstring[MAX_STRING];

	set(cmd,strcharsplit(text, idx,strchar(" ")));
	if (strlen(cmd) == 0) return 0;

	if(strcomp(cmd, "/g", true) == 1)
 	{
    	if (PlayerGangID[playerid] == -1) return 1;
     	new gangmessage[MAX_STRING];

     	set(gangmessage,text);
        strdel(gangmessage, 0, idx);
        if (!strlen(gangmessage)) return 1;
     	format(gangmessage, sizeof(gangmessage),  lang_texts[6][2] , oGetPlayerName(playerid),playerid,gangmessage);
        SendGangMessage(PlayerGangID[playerid],gangmessage,COLOUR_GANG_CHAT);

        new logstring[256];
  		format(logstring, sizeof (logstring), "player: %d: g: %d: %s: <GANG CHAT>: %s",playerid,PlayerGangID[playerid],oGetPlayerName(playerid),text);
     	WriteChatLog(logstring);

        return 1;
	}

    if(strcomp(cmd, "/gang", true) == 1)
	{

		if (!IsPlayerRegistered(playerid))
  		{
   			SendPlayerFormattedText(playerid,  lang_texts[6][3] , 0,COLOUR_RED);
   			return 1;
  		}

  		set(cmd,strcharsplit(text, idx,strchar(" ")));
  		if (strlen(cmd) == 0) return 0;
		
  		if(strcomp(cmd, "help", true) == 1)
  		{
   			SendPlayerScrollingText(playerid,  lang_texts[6][4] );
   			SendPlayerScrollingText(playerid,  lang_texts[6][5] );
   			SendPlayerScrollingText(playerid,  lang_texts[6][6] );
   			SendPlayerScrollingText(playerid,  lang_texts[6][7] );
   			SendPlayerScrollingText(playerid,  lang_texts[6][8] );
   			SendPlayerScrollingText(playerid,  lang_texts[6][9] );
   			return 1;
  		}
		
		/*
		if(strcomp(cmd, "sysinfo", true) == 1)
		{
			new gid = PlayerGangID[playerid];
			new memberid0 = GangMembers[gid][0];
			new memberid1 = GangMembers[gid][1];
			new memberid2 = GangMembers[gid][2];
			new memberid7 = GangMembers[gid][7];
			
			SendPlayerFormattedText(playerid,"Your gangid is %d", gid,COLOUR_RED);
			SendPlayerFormattedText(playerid,"[0]memberid is %d", memberid0,COLOUR_RED);
			SendPlayerFormattedText(playerid,"[1]memberid is %d", memberid1,COLOUR_RED);
			SendPlayerFormattedText(playerid,"[2]memberid is %d", memberid2,COLOUR_RED);
			SendPlayerFormattedText(playerid,"[7]memberid is %d", memberid7,COLOUR_RED);
			
		}
		*/

  		if(strcomp(cmd, "commands", true) == 1)
  		{
  		/*
   			SendPlayerScrollingText(playerid,  lang_texts[6][10] );
   			SendPlayerScrollingText(playerid,  lang_texts[6][11] );
      //SendPlayerScrollingText(playerid,  lang_texts[6][12] );
   			SendPlayerScrollingText(playerid,  lang_texts[6][13] );
   			SendPlayerScrollingText(playerid,  lang_texts[6][14] );
   			SendPlayerScrollingText(playerid,  lang_texts[6][15] );
      SendPlayerScrollingText(playerid,  lang_texts[6][16] );
  			 SendPlayerScrollingText(playerid,  lang_texts[6][17] );
   			SendPlayerScrollingText(playerid,  lang_texts[6][18] );
      SendPlayerScrollingText(playerid,  lang_texts[6][19] );
   			//SendPlayerScrollingText(playerid,  lang_texts[6][20] );*/
		    new helpstr[1800];
	    	new comstr[128];
	    	format(comstr,sizeof(comstr), "Команды Банд:");
	    	strins(helpstr, "{DB881A}'/gang create <название банды>'{ffffff}	- создать новую банду, например: '/gang create Моя банда'. Цена: $150.000.\n", strlen(helpstr));
			strins(helpstr, "{DB881A}'/gang colours'{ffffff}				- отобразить список доступных цветов для банды.\n", strlen(helpstr));
			strins(helpstr, "{DB881A}'/g <сообщение>' ('! <сообщение>'){ffffff}		- послать сообщение своей банде, например: '/g Всем привет!' или '! Всем привет!'.\n", strlen(helpstr));
			strins(helpstr, "{DB881A}'/gang quit'{ffffff}					- покинуть текущую банду.\n", strlen(helpstr));
			strins(helpstr, "{DB881A}'/gang accept'{ffffff}					- присоединиться к приглашающей Вас банде.\n", strlen(helpstr));
			strins(helpstr, "{DB881A}'/gang stats'{ffffff}					- отобразить информацию о Вашей банде.\n", strlen(helpstr));
			strins(helpstr, "{DB881A}'/gang members'{ffffff}				- отобразить информацию о членах Вашей банды.\n", strlen(helpstr));
			strins(helpstr, "{DB881A}'/gang invite <ИД>'{FF0000}*{ffffff}				- пригласить игрока в свою банду.\n", strlen(helpstr));
			strins(helpstr, "{DB881A}'/gang colour <ИД>'{FF0000}*{ffffff}				- поменять цвет своей банды. Цена: $50.000.\n", strlen(helpstr));
			strins(helpstr, "{DB881A}'/gang delete <SQLID>'{FF0000}*{ffffff}				- выгнать игрока из банды.\n", strlen(helpstr));
			strins(helpstr, "{DB881A}'/gang tag <ИМЯ>'{FF0000}*{ffffff}				- установить ганг-тэг.\n", strlen(helpstr));
			strins(helpstr, "{DB881A}'/gang prelead <SQLID>'{FF0000}*{ffffff}		- выдача статуса зам лидера.\n", strlen(helpstr));
			strins(helpstr, "{FF0000}* - Только для лидеров.", strlen(helpstr));
			ShowPlayerDialog(playerid, COMMANDS_INFO_DIALOG+1, DIALOG_STYLE_MSGBOX, comstr, helpstr,"Назад", "Выход");
   			return 1;
  		}

  		if((strcomp(cmd, "colours", true) == 1) || (strcomp(cmd, "colors", true) == 1))
		//if(strcomp(cmd, "colourlist", true) == 1)
  		{
  		
			new scolor[8];
   			SendPlayerFormattedText(playerid,  lang_texts[6][22], 0,COLOUR_GREEN);
   			for (new i = 1;i<COLOURS_SIZE;i++)
   			{
				set(scolor,OKS_HEX2STR(GangColours[i][colour_code]));
    			format(tempstring, sizeof(tempstring),"IIIIIIIIIIIIIII{FFFFFF} - [id %d] - {%s}[RGB: %s]",i,scolor,scolor);
    			SendClientMessage(playerid, GangColours[i][colour_code],tempstring);
   			}
   			return 1;
  		}
		
		if(strcomp(cmd, "sqlid", true) == 1)
  		{
			format(tempstring, sizeof(tempstring), "Ваш GANG SQLID %d", PlayerGangSQLID[playerid]);
			SendPlayerFormattedText(playerid, tempstring, 0,COLOUR_MISC);
			return 1;
		}
		
  		if((strcomp(cmd, "stats", true) == 1) || (strcomp(cmd, "stat", true) == 1) || (strcomp(cmd, "status", true) == 1))
  		{

      		if (PlayerGangID[playerid] == -1)
      		{
          		SendPlayerFormattedText(playerid,  lang_texts[6][24] , 0,COLOUR_RED);
       			return 1;
      		}
			
			new gangid = PlayerGangID[playerid];
			
			//--------
			
			GetGangStat(playerid,gangid);
			
   			return 1;
  		}

  		if(strcomp(cmd, "members", true) == 1)
  		{

      		if (PlayerGangID[playerid] == -1)
      		{
       			SendPlayerFormattedText(playerid,  lang_texts[6][29] , 0,COLOUR_RED);
       			return 1;
      		}
      		new gangid = PlayerGangID[playerid];
      		new status[10];
			//new color;
			new list[2024];
      		format(list, 32,  "Имя\tSQLID\tСтатус\n" , Gangs[gangid][gang_name]);
      		//SendPlayerFormattedText(playerid, tempstring, 0,Gangs[gangid][gang_colour]);
			//new list[1024]; format(list, 32, "SQLID\tИмя\tСтатус\n");
      		for (new i = 0;i<MAX_GANG_SIZE;i++)
   			{ // foreach member

    			if (GangMembers[gangid][i][member_sqlid] != 0)
          		{
           			if (GangMembers[gangid][i][member_online])
           			{
      					set(status,"Online");
      					//format(list,sizeof(list),"%s\n %d\t%s\t{C0C0C0}Отсутствует\n",list, i, ZoneInfo[i][GangZoneName]);
         				format(list, sizeof(list),  "%s\n %s\t %d\t {008000}%s\n" , list,GangMembers[gangid][i][member_name],GangMembers[gangid][i][member_sqlid],status);
						if(GangMembers[gangid][i][member_sqlid] == PlayerSQLID[playerid])
						{
						//color = 0x5ec8c7FF;
						}
						else
						{
						//color = 0x68c85eFF;
						}
     				}
     				else
     				{
      					set(status,"Offline");
      					format(list, sizeof(list),  "%s\n %s\t %d\t {808080}%s\n" , list,GangMembers[gangid][i][member_name],GangMembers[gangid][i][member_sqlid],status);
						//color = COLOUR_MISC;
     				}
     				new headers[128];
     				format(headers, 32,  "Члены банды '%s':" , Gangs[gangid][gang_name]);
     				ShowPlayerDialog(playerid, S_GUI_02, DIALOG_STYLE_TABLIST_HEADERS, headers, list, "ОК", "");
     				//SendPlayerFormattedText(playerid, tempstring, 0,color);
    			}
   			}
   			return 1;
  		}

		if(strcomp(cmd, "tag", true) == 1)
  		{
  		    new gangid = PlayerGangID[playerid];
  		    CheckGangLevel(gangid);
  			if (PlayerGangID[playerid] == -1)
      		{
       			SendPlayerFormattedText(playerid,  lang_texts[6][29] , 0,COLOUR_RED);
       			return 1;
      		}
      		if ( GangMembers[gangid][0][member_sqlid] != PlayerSQLID[playerid])
      		{ // player is not leader of this gang
       			SendPlayerFormattedText(playerid,  lang_texts[6][52] , 0,COLOUR_RED);
    			return 1;
   			}
			if(Gangs[gangid][gang_level] < GANG_XP_COLOR)
			{
				SendPlayerFormattedText(playerid, "Для установки ганг-тега необходим %d-ой уровень банды. '/gang stats'" , GANG_XP_COLOR+1, COLOUR_RED);
				return 1;
			}
   			if(oGetPlayerMoney(playerid) <= 500000) {
  		        SendPlayerFormattedText(playerid, "Для установки ганг-тега необходимо 500.000$", 0, COLOUR_RED);
  		        return 1;
  		    }
			new gangtag[MAX_STRING];
			set(gangtag,strcharsplit(text, idx,strchar(" ")));
			if (isnull(gangtag)){
				SendPlayerFormattedText(playerid,  lang_texts[6][89] , 0,COLOUR_RED);
				return 1;
			}
			if (strlen(gangtag) > 3){
				SendPlayerFormattedText(playerid,  lang_texts[6][90] , 0,COLOUR_RED);
				return 1;
			}
			if (strlen(gangtag) < 2){
				SendPlayerFormattedText(playerid,  lang_texts[6][91] , 0,COLOUR_RED);
				return 1;
			}
			if(strfind(gangtag,"]",true) != -1 || strfind(gangtag,"[",true) != -1){
			    SendPlayerFormattedText(playerid,  lang_texts[6][92] , 0,COLOUR_RED);
			    return 1;
			}
			for (new i=0;i<MAX_PLAYERS;i++)
			{
				if(!IsPlayerConnected(i)){continue;}
				if(PlayerGangID[i] == -1){continue;}
				if(PlayerGangID[i] == gangid)
				{
					/*if(isnull(PlayerGangTag[i]) || !strcomp(PlayerGangTag[i],"No GangTag",false)) {
                		escGetPlayerName(i);
					}*/
					set(Gangs[gangid][gang_tag],gangtag);
					set(PlayerGangTag[i],gangtag);
					
					new name[MAX_PLAYER_NAME];
					GetPlayerName(i, name, sizeof(name));
   					SetTag(name,PlayerGangTag[i]);
                	SetPlayerName(i, name);
				}
			}
			SendPlayerFormattedText(playerid, "[GANG] Вы успешно установили ганг-тег!", 0, COLOUR_GREEN);
			oGivePlayerMoney(playerid,-500000,1);
			return 1;
		}
		
		if(strcomp(cmd, "prelead", true) == 1)
  		{
  		    new preleadid = -1;
  		    new gangid = PlayerGangID[playerid];
  		    new preleadidR = -1;
  			if ( GangMembers[gangid][0][member_sqlid] != PlayerSQLID[playerid])
      		{
       			SendPlayerFormattedText(playerid,  lang_texts[6][52] , 0,COLOUR_RED);
    			return 1;
   			}
   			
   			//new preleadidR = -1;
			new prelead[128];
			set(prelead,strcharsplit(text, idx,strchar(" ")));
			if(!strlen(prelead))
			{
				SendPlayerFormattedText(playerid,  "Применение: /gang prelead <ID>" , 0,COLOUR_RED);
				return 1;
			}
			preleadid = strval(prelead);
			
    		for (new i = 0;i<MAX_GANG_SIZE;i++)
   			{ // foreach member

    			if (GangMembers[gangid][i][member_sqlid] != 0)
          		{
          		    if(GangMembers[gangid][i][member_sqlid] == preleadid)
          		    {
                        preleadidR = GangMembers[gangid][i][member_sqlid];
          		    }
          		}
			}
			
			if(preleadidR < 0) {
			    SendPlayerFormattedText(playerid, "[GANG] Введите корректный SQLID игрока. Список SQLID '/gang members'!", 0, COLOUR_RED);
				return 1;
			}
			
			if(preleadidR > 0) {
			    Gangs[gangid][gang_zam] = preleadid;
			    SendPlayerFormattedText(playerid, "[GANG] Вы назначили заместителя банды!", 0, COLOUR_GREEN);
			    return 1;
			}
			
  		    return 1;
		}
		
  		if(strcomp(cmd, "create", true) == 1)
  		{

      		if (PlayerGangID[playerid] != -1)
      		{
       			SendPlayerFormattedText(playerid,  lang_texts[6][33] , 0,COLOUR_RED);
       			return 1;
      		}

      		if (oGetPlayerMoney(playerid) < GANG_CREATE_COST)
      		{
          		format(tempstring, sizeof(tempstring),  lang_texts[6][34] , GANG_CREATE_COST);
       			SendPlayerFormattedText(playerid, tempstring, 0,COLOUR_RED);
       			return 1;
      		}
			
			if (GetPlayerLevel(playerid) < GANG_CREATE_LEVEL)
			{
				format(tempstring, sizeof(tempstring),  lang_texts[6][80] , GANG_CREATE_LEVEL);
				SendPlayerFormattedText(playerid, tempstring, 0,COLOUR_RED);
				return 1;
			}
			
   			new gangname[MAX_STRING];
   			new gangcolour;
			
			gangcolour = GangColours[0][colour_code];
			
         	if (gangcolour == 0)
         	{
          		SendPlayerFormattedText(playerid,  lang_texts[6][37] , 0,COLOUR_RED);
                SendPlayerFormattedText(playerid,  lang_texts[6][38] , 0,COLOUR_RED);
    			return 1;
   			}
			
			set(gangname,text);
			strdel(gangname, 0, idx);
			
         	if (strlen(gangname) <3)
   			{
       			SendPlayerFormattedText(playerid,  lang_texts[6][39] , 0,COLOUR_RED);
    			return 1;
   			}
   			if (strlen(gangname) > 24)
   			{
       			SendPlayerFormattedText(playerid,  lang_texts[6][40] , 0,COLOUR_RED);
    			return 1;
   			}

   			if (GangCreate(playerid,gangname,gangcolour) != -1)
   			{
    			oGivePlayerMoney(playerid,0-GANG_CREATE_COST,1);
    			SendPlayerFormattedText(playerid,  lang_texts[6][42] , 0,COLOUR_GREEN);
				SendPlayerFormattedText(playerid,  "Установлен стандартный цвет банды!" , 0,COLOUR_GREEN);
				SendPlayerFormattedText(playerid,  "Чтобы изменить цвет прокачайте банду до %d-го уровня" , GANG_XP_COLOR, COLOUR_GREEN);
   			}
   			else
   			{
    			SendPlayerFormattedText(playerid,  lang_texts[6][43] , 0,COLOUR_RED);
   			}
			
			
  			return 1;
  		} // end create

  		if((strcomp(cmd, "accept", true) == 1) || (strcomp(cmd, "join", true) == 1))
  		{
      		if (PlayerGangID[playerid] != -1)
      		{
       			SendPlayerFormattedText(playerid,  lang_texts[6][44] , 0,COLOUR_RED);
				return 1;
      		}
      		if (GangInvite[playerid] == -1)
      		{
       			SendPlayerFormattedText(playerid,  lang_texts[6][45] , 0,COLOUR_RED);
    			return 1;
      		}
   			new gangid = GangInvite[playerid];

   			if (GetFreeMemberSlots(gangid) == 0)
   			{
    			SendPlayerFormattedText(playerid,  lang_texts[6][46] , 0,COLOUR_RED);
    			GangInvite[playerid] = -1;
    			return 1;
   			}

      		if (GangJoinMember(gangid,playerid) == 1)
      		{
          		format(tempstring, sizeof(tempstring),  lang_texts[6][47] ,Gangs[gangid][gang_name]);
    			SendPlayerFormattedText(playerid, tempstring, 0,COLOUR_GANG);
    			format(tempstring, sizeof(tempstring),  lang_texts[6][48] , oGetPlayerName(playerid));
    			SendGangMessage(gangid,tempstring,COLOUR_GANG);
                new logstring[256];
    			format(logstring, sizeof (logstring), "player: %d:  %s: have joined '%s' gang.",playerid,oGetPlayerName(playerid),Gangs[gangid][gang_name]);
    			WriteLog(logstring);
    			return 1;
   			}
   			else
   			{
          		format(tempstring, sizeof(tempstring),  lang_texts[6][49] , Gangs[gangid][gang_name]);
    			SendPlayerFormattedText(playerid, tempstring, 0,COLOUR_RED);
    			return 1;
   			}
  		}

  		if (PlayerGangID[playerid] == -1)
  		{
   			SendPlayerFormattedText(playerid,  lang_texts[6][50] , 0,COLOUR_RED);
   			return 1;
  		}
  		new gangid = PlayerGangID[playerid];

  		if((strcomp(cmd, "quit", true) == 1) || (strcomp(cmd, "leave", true) == 1))
  		{
      		if (PlayerGangID[playerid] == -1)
      		{
       			SendPlayerFormattedText(playerid,  lang_texts[6][51] , 0,COLOUR_RED);
       			return 1;
      		}
			
			if ( GangMembers[gangid][0][member_sqlid] == PlayerSQLID[playerid])
      		{ // player is leader of this gang			
				ShowPlayerDialog(playerid,GGUI,0,"::: ВНИМАНИЕ :::",lang_texts[6][81],"ДА","НЕТ");
    			return 1;
			}
			
      		GangRemoveMember(gangid,PlayerSQLID[playerid],1);
						
      		return 1;
  		}

  		if(strcomp(cmd, "invite", true) == 1)
  		{
      		if ( GangMembers[gangid][0][member_sqlid] == PlayerSQLID[playerid] || PlayerSQLID[playerid] == Gangs[gangid][gang_zam])
      		{ // player is not leader of this gang
   		
// приглашение по ид
	new inviteid = -1;
	new istr[128];
	set(istr,strcharsplit(text, idx,strchar(" ")));
//	istr = strval(strcharsplit(text, idx,strchar(" ")));
	if(!strlen(istr))
		{
		SendPlayerFormattedText(playerid,  "Применение: /gang invite <ID>" , 0,COLOUR_RED);
		return 1;}
	if(strlen(istr) > 3)
	{ 
	SendPlayerFormattedText(playerid,  "Применение: /gang invite <ID>" , 0,COLOUR_RED);
	return 1;}
	inviteid = strval(istr);

// конец приглашения по ид
      		if (!IsPlayerConnected(inviteid))
      		{
//       			SendPlayerFormattedText(playerid,  lang_texts[6][54] , 0,COLOUR_RED);
       			SendPlayerFormattedText(playerid,  "Игрок оффлайн!" , 0,COLOUR_RED);

                return 1;
      		}
			
			if(!GetFreeMemberSlots(gangid))
			{
				SendPlayerFormattedText(playerid,  "Достигнут предел численности банды!" , 0,COLOUR_RED);
    			return 1;
			}
			
      		if (!IsPlayerRegistered(inviteid))
      		{
			SendPlayerFormattedText(playerid,  "Игрок не зарегистрировался!" , 0,COLOUR_RED);
       			SendPlayerFormattedText(playerid,  "Применение: /gang invite <ID>" , 0,COLOUR_RED);
//          		SendPlayerFormattedText(playerid,  lang_texts[6][55] , 0,COLOUR_RED);
//     			SendPlayerFormattedText(playerid,  lang_texts[6][56] , 0,COLOUR_RED);
                return 1;
   			}

   			if (PlayerGangID[inviteid] != -1)
      		{
       			SendPlayerFormattedText(playerid,  lang_texts[6][57] , 0,COLOUR_RED);
    			return 1;
      		}
			
         	format(tempstring, sizeof(tempstring),  lang_texts[6][58] , oGetPlayerName(playerid),Gangs[gangid][gang_name]);
   			SendPlayerFormattedText(inviteid, tempstring, 0,COLOUR_GANG);
   			format(tempstring, sizeof(tempstring),  lang_texts[6][59] , oGetPlayerName(inviteid),Gangs[gangid][gang_name]);
   			SendPlayerFormattedText(playerid, tempstring, 0,COLOUR_GANG);
   			GangInvite[inviteid] = gangid;
   			new logstring[256];
   			format(logstring, sizeof (logstring), "player: %d:  %s: has invited %s to join gang '%s'.",playerid,oGetPlayerName(playerid),oGetPlayerName(inviteid),Gangs[gangid][gang_name]);
      		WriteLog(logstring);
      		return 1;
      		} else {
      		    SendPlayerFormattedText(playerid,  lang_texts[6][52] , 0,COLOUR_RED);
      			return 1;
      		}
   			//return 1;
  		}

  		if(strcomp(cmd, "delete", true) == 1)
  		{
  			if ( GangMembers[gangid][0][member_sqlid] != PlayerSQLID[playerid] || PlayerSQLID[playerid] != Gangs[gangid][gang_zam])
			{
								
   			new kickplayerid[MAX_NAME];
   			set(kickplayerid,text);
            strdel(kickplayerid, 0, idx);
            if (!strlen(kickplayerid))
            {
            	SendPlayerFormattedText(playerid,  lang_texts[6][61] , 0,COLOUR_RED);
    			return 1;
            }
			
			new kicksqlid = strval(kickplayerid);
			
			if(kicksqlid <= 0)
			{
			SendPlayerFormattedText(playerid,  lang_texts[6][86] , 0,COLOUR_RED);
			return 1;
			}
			
			if(kicksqlid == PlayerSQLID[playerid])
			{
			SendPlayerFormattedText(playerid,  lang_texts[6][82] , 0,COLOUR_RED);
			return 1;
			}
			
			if(kicksqlid == GangMembers[gangid][0][member_sqlid])
			{
			SendPlayerFormattedText(playerid,  lang_texts[6][93] , 0,COLOUR_RED);
   			return 1;
			}
			
			new tmpname[32];
			
			for (new i = 0;i<MAX_GANG_SIZE;i++)
   			{ // foreach member
				if (GangMembers[gangid][i][member_sqlid] == kicksqlid)
				{set(tmpname,GangMembers[gangid][i][member_name]); break;}
			}
			
            if (GangRemoveMember(gangid,kicksqlid,1))
            {
       			format(tempstring, sizeof(tempstring),  lang_texts[6][62] , tmpname);
    			SendPlayerFormattedText(playerid, tempstring, 0,COLOUR_GREEN);
   			}
   			else
   			{
    			format(tempstring, sizeof(tempstring),  lang_texts[6][63] , kicksqlid);
    			SendPlayerFormattedText(playerid, tempstring, 0,COLOUR_RED);
   			}
   			return 1;
   			} else {
   				SendPlayerFormattedText(playerid,  lang_texts[6][60] , 0,COLOUR_RED);
   			    return 1;
   			}
   			//return 1;

  		}

  		if((strcomp(cmd, "colour", true) == 1) || (strcomp(cmd, "color", true) == 1))
  		{
      		if ( GangMembers[gangid][0][member_sqlid] != PlayerSQLID[playerid])
      		{
       			SendPlayerFormattedText(playerid,  lang_texts[6][64] , 0,COLOUR_RED);
    			return 1;
   			}
    		if (oGetPlayerMoney(playerid) < GANG_COLOUR_COST)
      		{
       			SendPlayerFormattedText(playerid,  lang_texts[6][65] , GANG_COLOUR_COST,COLOUR_RED);
    			return 1;
   			}
			if(Gangs[gangid][gang_level] < GANG_XP_COLOR)
			{
				SendPlayerFormattedText(playerid, "Чтобы изменить цвет ваша банда должна быть %d-го уровня." , GANG_XP_COLOR, COLOUR_RED);
				return 1;
			}
   			new colourname[MAX_NAME];
   			new gangcolour;
   			set(colourname,strcharsplit(text, idx,strchar(" ")));
   			if(!strlen(colourname))
   			{
       			SendPlayerFormattedText(playerid,  lang_texts[6][67] , 0,COLOUR_RED);
   				return 1;
         	}

			new colorid = strval(colourname);
			
			if(colorid < 1 || colorid >= COLOURS_SIZE)
			{
			SendPlayerFormattedText(playerid,  lang_texts[6][66] , 0,COLOUR_RED);
			return 1;
			}
			
			gangcolour = GangColours[colorid][colour_code];
			
         	if (gangcolour == 0)
         	{
          		SendPlayerFormattedText(playerid,  lang_texts[6][67] , 0,COLOUR_RED);
                SendPlayerFormattedText(playerid,  lang_texts[6][68] , 0,COLOUR_RED);
    			return 1;
   			}

   			SendPlayerFormattedText(playerid,  lang_texts[6][69] , GANG_COLOUR_COST,gangcolour);
   			SetGangColour(gangid,gangcolour);
   			oGivePlayerMoney(playerid,0-GANG_COLOUR_COST,1);
   			return 1;
  		}
		
	} // end gang
 	return 0;
}

//--------------------------------------------------------------------------------------

public PlayerGangColour(playerid) // OK
{
	new gangid = PlayerGangID[playerid];
	new newcolour = COLOUR_PLAYER;
	if (gangid != -1)
		{
			if (Gangs[gangid][gang_colour] != 0)
			{
				newcolour = Gangs[gangid][gang_colour];
			}
		}
return newcolour;
}

//--------------------------------------------------------------------------------------

public GangJoinMember(gangid,playerid) // EDITED R10
{
	if (gangid == -1)
	{
		WriteLog("script_warning: invalid gang id.");
		return 0;
	}
	
	if (PlayerGangID[playerid] != -1)
	{
		WriteLog("script_warning: player already in a gang!");
		return 0;
	}

	if (GetFreeMemberSlots(gangid) == 0)
	{
		WriteLog("script_warning: Gang is already full.");
		return 0;
	}

	for (new i = 0;i<MAX_GANG_SIZE;i++)
	{ // foreach member of the gang

		if (GangMembers[gangid][i][member_sqlid] == 0) // if member slot free
		{
			set(GangMembers[gangid][i][member_name],oGetPlayerName(playerid));
			GangMembers[gangid][i][member_sqlid] = PlayerSQLID[playerid];
			GangMembers[gangid][i][member_online] = 1;

			PlayerGangID[playerid] = gangid;
			set(PlayerGangName[playerid],Gangs[gangid][gang_name]);
			set(PlayerGangTag[playerid],"No GangTag");
			GangMemberLogin(gangid,playerid);
			SetPlayerColour(playerid,Gangs[gangid][gang_colour]);
			
			ResetHotel(playerid);
			
			return 1;
		}
	}
return 0;
}

//--------------------------------------------------------------------------------------

public GetFreeMemberSlots(gangid) // EDITED R10
{
new count = 0;
for (new i = 0;i<MAX_GANG_SIZE;i++)
{ if (GangMembers[gangid][i][member_sqlid] == 0){count++;} }
return count;
}

//--------------------------------------------------------------------------------------

public GangRemoveMember(gangid,kicksqlid,query) // Edited R10
{
	new playerid = -1;
	new tmp[MAX_STRING];
	new logstring[MAX_STRING];

	for (new i = 0;i<MAX_GANG_SIZE;i++)
	{
		if (GangMembers[gangid][i][member_sqlid] == kicksqlid)
		{
			playerid = PlayerSQLID2ID(kicksqlid);
			if (playerid != -1)
			{
				format(tmp, sizeof(tmp),  lang_texts[6][71] , Gangs[gangid][gang_name]);
				SendClientMessage(playerid,COLOUR_GANG,tmp);
    			SetPlayerName(playerid,oGetPlayerName(playerid));
				PlayerGangID[playerid] = -1;
				set(PlayerGangName[playerid],nullstr);
				set(PlayerGangTag[playerid],"No GangTag");
				PlayerGangSQLID[playerid] = 0;
				SetPlayerColour(playerid,COLOUR_PLAYER);	
				if(kicksqlid == Gangs[gangid][gang_zam])
				{
					Gangs[gangid][gang_zam] = -1;
				}
				// Добавить удаление тега
				new name[MAX_PLAYER_NAME];
				GetPlayerName(playerid, name, sizeof(name));
				UnsetTag(name);
				SetPlayerName(playerid, name);
				//
			}
			GangMembers[gangid][i][member_online] = 0;
			format(tmp, sizeof(tmp),  lang_texts[6][70] , GangMembers[gangid][i][member_name]);
			SendGangMessage(gangid,tmp,COLOUR_GANG);
			format(logstring, sizeof (logstring), "%s has been removed from gang '%s'", GangMembers[gangid][i][member_name],Gangs[gangid][gang_name]);	
			set(GangMembers[gangid][i][member_name],nullstr);
			GangMembers[gangid][i][member_sqlid] = 0;
			if(query)
			{
			set(tmp,nullstr);
			format(tmp,sizeof(tmp),"UPDATE gangs SET m%d=0 WHERE id=%d",i,GangSQLID[gangid]);
			xdb_query(ReunionDB,tmp);
			set(tmp,nullstr);
			format(tmp,sizeof(tmp),"UPDATE players SET gang=0 WHERE id=%d",kicksqlid);
			xdb_query(ReunionDB,tmp);
			}
			WriteLog(logstring);
		return 1;
		}
	}
return 0;
}


public GangCreate(leaderid,gangname[],gangcolour) // EDITED R10
{
	if (!IsPlayerRegistered(leaderid)) { return -1; }

	new tempname[MAX_STRING];
	set(tempname,gangname);

	if (!StringCharCheck(tempname))
	{
		SendPlayerFormattedText(leaderid,  lang_texts[6][72] , 0,COLOUR_RED);
		return -1;
	}

	if(tempname[0] == 32) // (' ')
	{
		SendPlayerFormattedText(leaderid,  "Первый символ в имени не должен быть пробелом!" , 0,COLOUR_RED);
		return -1;
	}
	
	if(strfind(tempname, "  ") != -1)
	{
		SendPlayerFormattedText(leaderid,  "Не более одного пробела между символами!" , 0,COLOUR_RED);
		return -1;
	}

	new query[MAX_STRING];
	format(query,sizeof(query),"SELECT id FROM gangs WHERE name = '%s' LIMIT 1",gangname);
	new DBResult:gangreg;
	gangreg = xdb_query(ReunionDB,query);

	if(db_num_rows(gangreg))
	{
		SendClientMessage(leaderid,COLOUR_RED,  lang_texts[6][73] );		
		return -1;
	}

	// Create the gang
	new gangid;
	for (new id=0;id<MAX_GANGS;id++)
	{
		if(!Gangs[id][gang_active])
		{
			gangid = id;
			Gangs[id][gang_active] = true; // find first free gang slot and andd our gang
		break;
		}
	}

	GangSQLID[gangid] = GetFreeSQLID("gangs");
	format(query, sizeof(query), "INSERT INTO gangs ( id, name) VALUES ( %d, '%s')",GangSQLID[gangid],gangname);
	xdb_query(ReunionDB,query);

	set(Gangs[gangid][gang_name],gangname);
	Gangs[gangid][gang_colour] = gangcolour;
	Gangs[gangid][gang_bank] = 0;
	Gangs[gangid][gang_kills] = 0;
	Gangs[gangid][gang_score] = 0;
	Gangs[gangid][gang_savetimer] = 0;
	Gangs[gangid][gang_xp] = 0;
	Gangs[gangid][gang_level] = 0;
	set(Gangs[gangid][gang_tag],"No GangTag");
	Gangs[gangid][gang_zam] = -1;

	set(GangMembers[gangid][0][member_name],oGetPlayerName(leaderid));
	GangMembers[gangid][0][member_online] = 1;
	GangMembers[gangid][0][member_sqlid] = PlayerSQLID[leaderid];
	
	set(PlayerGangName[leaderid],gangname);
 	set(PlayerGangTag[leaderid],"No GangTag");
	PlayerGangID[leaderid] = gangid;
	PlayerGangSQLID[leaderid] = GangSQLID[gangid];
	SetPlayerColour(leaderid,Gangs[gangid][gang_colour]);
	
	for (new i = 1;i<MAX_GANG_SIZE;i++)
	{ // foreach member without 0
		GangMembers[gangid][i][member_online] = 0;
		set(GangMembers[gangid][i][member_name],nullstr);
		GangMembers[gangid][i][member_sqlid] = 0;	
	}
	
	ResetHotel(leaderid);
	
	GangSave(gangid);
	
	new logstring[256];
	format(logstring, sizeof (logstring), "GANG CREATED [ID: %d][NAME: %s][SQLID: %d][LEADER: %s][LID: %d]",gangid,gangname,GangSQLID[gangid],oGetPlayerName(leaderid),leaderid);
	WriteLog(logstring);

return gangid;
}

//--------------------------------------------------------------------------------------

public GangCleanup(gangid) // EDITED R10
{
	if (!Gangs[gangid][gang_active]) { return -1; }

	for (new i = 0;i<MAX_GANG_SIZE;i++)
	{ // foreach member of the gang
		if (GangMembers[gangid][i][member_online] == 1)
		{
			if (GangMembers[gangid][i][member_sqlid] == 0)
			{
				GangMembers[gangid][i][member_online] = 0;
				set(GangMembers[gangid][i][member_name],nullstr);
				continue;
			}
		}
	}

	if (GangOnlineCount(gangid) == 0)
    {
		GangUnload(gangid);
		return 1;
	}
	
return 0;
}

//--------------------------------------------------------------------------------------

public GangSaveAll() // EDITED R10
{
	for (new i = 0;i<MAX_GANGS;i++)
	{
		if (Gangs[i][gang_active])
		{
			if(!GangCleanup(i))
			{GangSave(i);}
		}
	}
}

//--------------------------------------------------------------------------------------

public CheckGangs() // EDITED R10
{
	new tmp[128];

	for (new i = 0;i<MAX_GANGS;i++)
	{
		if (Gangs[i][gang_active])
		{
			Gangs[i][gang_savetimer]++;
			if(Gangs[i][gang_savetimer] >= GANG_SAVE_DELAY)
			{
				Gangs[i][gang_savetimer] = 0;
				
				format(tmp,sizeof(tmp),"GANG AUTOSAVE [SQLID: %d][NAME: %s]",GangSQLID[i],Gangs[i][gang_name]);
				SendGangMessage(i," SERVER: Банда сохранена",COLOUR_MISC);
				
				if(!GangCleanup(i))
				{GangSave(i);}
				
				WriteSQLLog(tmp);
			}
		}
	}
return 1;
}

//--------------------------------------------------------------------------------------

public GangMemberLogout(playerid,gangid) // EDITED R10
{
	GangInvite[playerid] = -1;
	PlayerGangID[playerid] = -1;
	if (gangid == -1) { return; }

	for (new i = 0;i<MAX_GANG_SIZE;i++)
	{ // foreach member of the gang

		if (GangMembers[gangid][i][member_sqlid] == PlayerSQLID[playerid])
		{
			GangMembers[gangid][i][member_online] = 0;
			break;
		}
	}
	
	if (GangCleanup(gangid) == 0)
	{
		new tmp[MAX_STRING];
		format(tmp, sizeof(tmp),  lang_texts[6][74] , oGetPlayerName(playerid));
		SendGangMessage(gangid,tmp,COLOUR_GANG);
	}
}

//--------------------------------------------------------------------------------------

public GangSave(gangid) // EDITED R10
{
	if (gangid == -1) {return 0;}
	if (!Gangs[gangid][gang_active]) {return 0;}
	if (!strlen(Gangs[gangid][gang_name])) {return 0;}
	if (!GangSQLID[gangid]) {return 0;}
	gang_save_db_sql(gangid);
return 1;
}

//--------------------------------------------------------------------------------------

stock gang_save_db_sql_Slow(gangid) // EDITED R10
{

new lquery[MAX_STRING];
format(lquery,sizeof(lquery),"UPDATE gangs SET name='%s', color='%d', kills=%d, score=%d, bank=%d, level=%d, xp=%d, tag='%s', zam=%d WHERE id=%d",Gangs[gangid][gang_name],Gangs[gangid][gang_colour],Gangs[gangid][gang_kills],Gangs[gangid][gang_score],Gangs[gangid][gang_bank], Gangs[gangid][gang_level], Gangs[gangid][gang_xp], Gangs[gangid][gang_tag], Gangs[gangid][gang_zam], GangSQLID[gangid]);
xdb_query(ReunionDB,lquery);
set(lquery,nullstr);

	for (new gm = 0;gm<MAX_GANG_SIZE;gm++)
	{
		if(!strlen(lquery)) { format(lquery,sizeof(lquery),"UPDATE gangs SET"); }

		format(lquery,sizeof(lquery),"%s m%d=%d",lquery,gm,GangMembers[gangid][gm][member_sqlid]);

		if(strlen(lquery) >= MAX_STRING-50)
		{
			format(lquery,sizeof(lquery),"%s WHERE id=%d",lquery,GangSQLID[gangid]);
			xdb_query(ReunionDB,lquery);
			format(lquery,sizeof(lquery),nullstr);
		}
		else if (gm < MAX_GANG_SIZE-1 ) { strcat(lquery, ",", sizeof(lquery)); }
	}
	
	if(strlen(lquery))
	{
		format(lquery,sizeof(lquery),"%s WHERE id=%d",lquery,GangSQLID[gangid]);
		xdb_query(ReunionDB,lquery);
	}
return 1;
}

stock gang_save_db_sql(gangid) // EDITED R10 BETA 8
{

new lquery[1024];
format(lquery,sizeof(lquery),"UPDATE gangs SET name='%s', color='%d', kills=%d, score=%d, bank=%d, level=%d, xp=%d, tag='%s', zam=%d,",Gangs[gangid][gang_name],Gangs[gangid][gang_colour],Gangs[gangid][gang_kills],Gangs[gangid][gang_score],Gangs[gangid][gang_bank],Gangs[gangid][gang_level],Gangs[gangid][gang_xp],Gangs[gangid][gang_tag],Gangs[gangid][gang_zam]);
//xdb_query(ReunionDB,lquery);
//set(lquery,nullstr);

	for (new gm = 0;gm<MAX_GANG_SIZE;gm++)
	{
		//if(!strlen(lquery)) { format(lquery,sizeof(lquery),"UPDATE gangs SET"); }

		format(lquery,sizeof(lquery),"%s m%d=%d",lquery,gm,GangMembers[gangid][gm][member_sqlid]);

		//if(strlen(lquery) >= MAX_STRING-50)
		//{
		//	format(lquery,sizeof(lquery),"%s WHERE id=%d",lquery,GangSQLID[gangid]);
		//	xdb_query(ReunionDB,lquery);
		//	format(lquery,sizeof(lquery),nullstr);
		//}
		//else 
		if (gm < MAX_GANG_SIZE-1 ) { strcat(lquery, ",", sizeof(lquery)); }
	}
	
	if(strlen(lquery))
	{
		format(lquery,sizeof(lquery),"%s WHERE id=%d",lquery,GangSQLID[gangid]);
		xdb_query(ReunionDB,lquery);
	}
return 1;
}

//--------------------------------------------------------------------------------------

public GangUnload(gangid) // EDITED R10
{
	if(GangMembers[gangid][0][member_sqlid] == 0)
	{ //No leader of gang - remove file.
	
		new query[128];
		format(query,sizeof(query),"DELETE FROM gangs WHERE id=%d",GangSQLID[gangid]);
		xdb_query(ReunionDB,query);
		format(query,sizeof(query),"GANG REMOVE - NO LEADER IN GANG [NAME: %s][SQLID: %d]",Gangs[gangid][gang_name],GangSQLID[gangid]);
		WriteLog(query);

		new hid = -1;
		hid = GetGangHouseID( GangSQLID[gangid] );
		
		if(hid > -1) {HouseMakeOwnerless(hid,1,1);} //банда удаляется и если владела домом, то дом становится ничейным
  		
		new zoneid = 0;
		zoneid = GetGangZoneID( GangSQLID[gangid] );
		
		if(zoneid > 0) {ZoneMakeOwnerless(zoneid,1); UpdateColor(zoneid);} // банда удаляется и если владела зоной, то зона становится ничейной
		
	}
	else
	{
	GangSave(gangid);
	}

	for (new i = 0;i<MAX_GANG_SIZE;i++)
	{ // foreach member
		set(GangMembers[gangid][i][member_name],nullstr);
		GangMembers[gangid][i][member_online] = 0;
		GangMembers[gangid][i][member_sqlid] = 0;
	}

	new logstring[256];
	format(logstring, sizeof (logstring), "GANG UNLOADED [ID: %d][NAME: %s][SQLID: %d]",gangid,Gangs[gangid][gang_name],GangSQLID[gangid]);
	WriteLog(logstring);
	
	set(Gangs[gangid][gang_name],nullstr);
	Gangs[gangid][gang_bank] = 0;
	Gangs[gangid][gang_colour] = 0;
	Gangs[gangid][gang_kills] = 0;
	Gangs[gangid][gang_score] = 0;
	Gangs[gangid][gang_savetimer] = 0;
	GangSQLID[gangid] = 0;
	Gangs[gangid][gang_active] = 0;
	Gangs[gangid][gang_xp] = 0;
	Gangs[gangid][gang_level] = 0;
	set(Gangs[gangid][gang_tag],nullstr);
	Gangs[gangid][gang_zam] = -1;
}

//--------------------------------------------------------------------------------------

public GangKill(gangid,killerid,victimid,reason) // EDITED R10
{
new tmp[MAX_STRING];
	if (victimid != INVALIDX_PLAYER_ID && victimid != INVALID_PLAYER_ID) { Gangs[gangid][gang_kills]++; }

	if (PlayerGangID[killerid] == PlayerGangID[victimid])
	{ // killed a gang member	
//		new xpamount = (1+GetPlayerLevel(killerid))*50;
//       GiveGangXP(gangid,(1+Gangs[gangid][gang_level]) * 50);
//		if(xpamount >= Gangs[gangid][gang_xp]) {xpamount = Gangs[gangid][gang_xp]; Gangs[gangid][gang_xp] = 0;} else
//		{Gangs[gangid][gang_xp] -= xpamount;}
		
//		CheckGangLevel(gangid);
		
		format(tmp, sizeof(tmp),  lang_texts[6][76] , oGetPlayerName(killerid));
		SendGangMessage(PlayerGangID[killerid],tmp,COLOUR_GANG);
		
//		if(xpamount)
//		{
//		format(tmp, sizeof(tmp),  " Банда потеряла %d ХР" ,xpamount );
//		SendGangMessage(PlayerGangID[killerid],tmp,COLOUR_GANG);
//		}
	return 1;
    }
return 0;
}

//--------------------------------------------------------------------------------------

public GangMemberLogin(gangid, playerid) // EDITED R10
{
PlayerGangID[playerid] = -1;
if(gangid == -1) {return 0;}
if(PlayerSQLID[playerid] == 0) {return 0;}
new tmp[MAX_STRING];
//printf("1 ---> %d",PlayerGangSQLID[playerid]);
for (new i = 0;i<MAX_GANG_SIZE;i++)
{
	if(GangMembers[gangid][i][member_sqlid] == PlayerSQLID[playerid])
	{
			format(tmp, sizeof(tmp),  lang_texts[6][77] , oGetPlayerName(playerid));
			SendGangMessage(gangid,tmp,COLOUR_GANG);
			
			GangMembers[gangid][i][member_online] = 1;
			PlayerGangID[playerid] = gangid;
			//printf("2 ---> %d",PlayerGangSQLID[playerid]);
			PlayerGangSQLID[playerid] = GangSQLID[gangid];
			//printf("3 ---> %d",PlayerGangSQLID[playerid]);
			set(PlayerGangName[playerid],Gangs[gangid][gang_name]);
			set(PlayerGangTag[playerid],Gangs[gangid][gang_tag]);

			format(tmp, sizeof(tmp),  lang_texts[6][78] ,Gangs[gangid][gang_name],GangOnlineCount(gangid)-1);
			SendPlayerFormattedText(playerid, tmp, 0,COLOUR_GANG);
   			//if (strcomp(PlayerGangTag[playerid],"No GangTag",false) < 0){
   			if(isnull(PlayerGangTag[playerid]) || !strcomp(PlayerGangTag[playerid],"No GangTag",false)) {
				new name[MAX_PLAYER_NAME];
				GetPlayerName(playerid, name, sizeof(name));
                SetTag( name, PlayerGangTag[playerid] );
                SetPlayerName(playerid, name);
			} else {
				//SetPlayerName(playerid,escGetPlayerName(playerid));
			}
			GangInvite[playerid] = -1;
			SetPlayerColour(playerid,Gangs[gangid][gang_colour]);
			return 1;
	}
}

if (PlayerGangID[playerid] == -1)
{
	format(tmp,sizeof(tmp),"Возможно, ВЫ были удалены из банды [NAME: %s][SQLID: %d]",Gangs[gangid][gang_name],GangSQLID[gangid]);
	SendClientMessage(playerid,COLOUR_GANG, tmp);
	//printf("4 ---> %d",PlayerGangSQLID[playerid]);
	PlayerGangID[playerid] = -1;
	PlayerGangSQLID[playerid] = 0;
	//PlayerGangMemberID[playerid] = -1;
	set(PlayerGangName[playerid],nullstr);
	
	if(GangOnlineCount(gangid) == 0) {GangCleanup(gangid);}
}

return 0;
}

//--------------------------------------------------------------------------------------

public SendGangMessage(gangid,message[MAX_STRING],colour) // EDITED R10
{
	for (new i=0;i<MAX_PLAYERS;i++)
	{	
		if(!IsPlayerConnected(i)){continue;}
		if(PlayerGangID[i] == -1){continue;}
		if(PlayerGangID[i] == gangid)
		{
			SendPlayerFormattedText(i, message, 0,colour);
		}
	}
}

//--------------------------------------------------------------------------------------

public GangOnlineCount(gangid) // EDITED R10
{
	new memberscount;
	
	for (new i = 0;i<MAX_GANG_SIZE;i++)
	{ // foreach member of the gang
		if (GangMembers[gangid][i][member_online] == 1) { memberscount++; }
	}
return memberscount;
}

//--------------------------------------------------------------------------------------
public SetGangXP(gangid,xpamount,giverid)
{
//if(xpamount <= 0) {return 0;}
if(xpamount > MAX_GANG_XP) {xpamount = MAX_GANG_XP;}

GiveGangXP(gangid,xpamount);
//Gangs[gangid][gang_level] = xpamount;
//SetGXP(gangid,xpamount);

new string[MAX_STRING];
format(string, sizeof(string),  lang_texts[6][85] ,oGetPlayerName(giverid), giverid, xpamount);
SendGangMessage(gangid,string,COLOUR_GREEN);

return 1;
}

public GangGiveXP(gangid,xpamount,giverid) // EDITED R10
{

	//if(Gangs[gangid][gang_score] + xpamount > GANG_XP_MAX){Gangs[gangid][gang_score] = GANG_XP_MAX;}else{
	//Gangs[gangid][gang_score] += xpamount;}

	if(Gangs[gangid][gang_xp] + xpamount > MAX_GANG_XP){Gangs[gangid][gang_xp] = MAX_GANG_XP;} else {
	GiveGangXP(gangid,xpamount); }

	new giveamount;
	giveamount = xpamount / GangOnlineCount(gangid);

	for (new i = 0;i<MAX_PLAYERS;i++)
	{
		if(!IsPlayerConnected(i)){continue;}
		if(PlayerGangID[i] == -1){continue;}
		if(PlayerGangID[i] == gangid && giverid != i)
		{
			GivePlayerXP(i,giveamount,0);
            CheckGangLevel(gangid);
			if (giveamount >= 300)
			{
				new string[MAX_STRING];
				format(string, sizeof(string),  lang_texts[6][79] ,giveamount,oGetPlayerName(giverid));
				SendPlayerFormattedText(i, string, 0,COLOUR_XP_GOOD);
			}
		}
	}
}

//--------------------------------------------------------------------------------------

public SetGangColour(gangid,colour) // OK
{
	Gangs[gangid][gang_colour] = colour;

	new ghid = GetGangHouseID( GangSQLID[gangid] );
	if(ghid != -1)
	{
	SetHouse3DTColor(ghid,Gangs[gangid][gang_colour]);
	UpdateHouse3D(ghid);
	}
	
	new zoneid = GetGangZoneID( GangSQLID[gangid] );
	if(zoneid != 0)
	{
		SetZoneColor(zoneid,Gangs[gangid][gang_colour]);
		UpdateColor(zoneid);
	}
	
for (new i = 0;i<MAX_PLAYERS;i++)
{
	if(!IsPlayerConnected(i)){continue;}
	if(IsPlayerNPC(i)){continue;}
	if(PlayerGangID[i] == -1){continue;}
	if(PlayerGangID[i] == gangid)
	{
		SetPlayerColour( i ,colour);
	}
//	SetZoneColor(i,Gangs[gangid][gang_colour]);
//	UpdateColor(i);
}
}

public PlayerGetMoneyFromGangBank(playerid,amount)
{
if (amount <= 0)
{
SendPlayerFormattedText(playerid,"Введите положительное число", 0,COLOUR_RED);
return 1;
}

new money = oGetPlayerMoney(playerid);
if(money + amount > MAX_MONEY)
{
amount = MAX_MONEY - money;
}

new gangid = PlayerGangID[playerid];
if(gangid == -1)
{
SendPlayerFormattedText(playerid,"Вы не в банде", 0,COLOUR_RED);
return 1;
}

if(Gangs[gangid][gang_bank] <= 0)
{
Gangs[gangid][gang_bank] = 0;
SendPlayerFormattedText(playerid,"На счету банды 0 $", 0,COLOUR_RED);
return 1;
}

if (amount > Gangs[gangid][gang_bank])
{
amount = Gangs[gangid][gang_bank];
}

oGivePlayerMoney(playerid,amount,0);
Gangs[gangid][gang_bank] = Gangs[gangid][gang_bank] - amount;

new str[MAX_STRING];
format(str,sizeof(str),"[GANG] '%s' снял с банковского счета банды %d $",oGetPlayerName(playerid),amount);
SendGangMessage(gangid,str,COLOUR_GREEN);
format(str,sizeof(str),"Вы сняли с банковского счета банды %d $",amount);
SendClientMessage(playerid, COLOUR_GREEN, str);

PlayerPlaySound(playerid,1084,0.000,0.000,0.000);
return 1;
}

public PlayerAddMoneyToGangBank(playerid,amount)
{

if (amount <= 0)
{
SendPlayerFormattedText(playerid,"Введите положительное число", 0,COLOUR_RED);
return 1;
}

new gangid = PlayerGangID[playerid];
if(gangid == -1)
{
SendPlayerFormattedText(playerid,"Вы не в банде", 0,COLOUR_RED);
return 1;
}

if(Gangs[gangid][gang_bank] >= MAX_GANG_BANK)
{
Gangs[gangid][gang_bank] = MAX_GANG_BANK;
SendPlayerFormattedText(playerid,"Банк полон!", 0,COLOUR_RED);
return 1;
}

if (oGetPlayerMoney(playerid) < amount)
{
amount = oGetPlayerMoney(playerid);
}

if (Gangs[gangid][gang_bank] + amount > MAX_GANG_BANK)
{
amount = MAX_GANG_BANK - Gangs[gangid][gang_bank];
}

oGivePlayerMoney(playerid,0 - amount,0);

Gangs[gangid][gang_bank] = Gangs[gangid][gang_bank] + amount;

new str[MAX_STRING];
format(str,sizeof(str),"[GANG] '%s' положил на банковский счет банды %d $",oGetPlayerName(playerid),amount);
SendGangMessage(gangid,str,COLOUR_GREEN);
format(str,sizeof(str),"Вы положили на банковский счет банды %d $",amount);
SendClientMessage(playerid, COLOUR_GREEN, str);

PlayerPlaySound(playerid,1083,0.000,0.000,0.000);

if (Gangs[gangid][gang_bank] == MAX_GANG_BANK)
{
SendGangMessage(gangid,"[GANG] Банк банды заполнен!",COLOUR_GREEN);
}

return 1;
}

public GiveGangMoney(gangid,money,showtext)
{
	if (!Gangs[gangid][gang_active])
	{
	return;
	}

	if (money == 0)
	{
	return;
	}
	
	new string[MAX_STRING];
	new temp = Gangs[gangid][gang_bank];

	if ((Gangs[gangid][gang_bank] + money) > MAX_GANG_BANK)
	{
		Gangs[gangid][gang_bank] = MAX_GANG_BANK;
		if(showtext)
		{
		format(string, sizeof(string), "[GANG] Банк банды пополнен на %d",Gangs[gangid][gang_bank]-temp);
		SendGangMessage(gangid,string,COLOUR_GREEN);
		}
		return;
	}
	if ((Gangs[gangid][gang_bank] + money) < 0)
	{
		Gangs[gangid][gang_bank] = 0;
		if(showtext)
		{
		format(string, sizeof(string), "[GANG] С банковского счета банды снято %d" , temp-Gangs[gangid][gang_bank]);
		SendGangMessage(gangid,string,COLOUR_GREEN);
		}
		return;
	}
	
	Gangs[gangid][gang_bank] = Gangs[gangid][gang_bank] + money;
	
	if(showtext)
	{
	if(money > 0)
	{
	format(string, sizeof(string), "[GANG] Банк банды пополнен на %d",money);
	SendGangMessage(gangid,string,COLOUR_GREEN);
	}
	else
	{
	format(string, sizeof(string), "[GANG] С банковского счета банды снято %d",money*(-1));
	SendGangMessage(gangid,string,COLOUR_GREEN);
	}
	}
return;
}

public GetGangStat(playerid,gangid)
{
			if(gangid < 0){return 0;}
			if(!Gangs[gangid][gang_active]) {return 0;}
			CheckGangLevel(gangid);

			new gangstat[512]; // 512
			new leaderinfo[128];
			new gname[64];
			new ganglevel[128];
			
			if(Gangs[gangid][gang_level] == MAX_GANG_LEVEL)
			{
			format(ganglevel,sizeof(ganglevel),"Уровень банды:\n\t--- %d ---\n",MAX_GANG_LEVEL);
			}
			else
			{
			format(ganglevel,sizeof(ganglevel),"Уровень банды:\n\t--- %d ---\n\nДо следующего уровня:\n\t--- %d XP ---\n",Gangs[gangid][gang_level],GetGangXPToLevel(gangid, Gangs[gangid][gang_level] + 1));
			}
			
			if(GangMembers[gangid][0][member_online])
			{
			format(leaderinfo,sizeof(leaderinfo),"Глава банды:\n\t%s\t[Online: ID %d][SQLID %d]\n",GangMembers[gangid][0][member_name],PlayerSQLID2ID( GangMembers[gangid][0][member_sqlid] ), GangMembers[gangid][0][member_sqlid]);
			}
			else
			{
			format(leaderinfo,sizeof(leaderinfo),"Глава банды:\n\t%s\t[Offline][SQLID %d]\n", GangMembers[gangid][0][member_name], GangMembers[gangid][0][member_sqlid]);
			}
			
      		format(gangstat, sizeof(gangstat),"Server ID:\n\t--- %d ---\n\n\%s\nЧленов банды онлайн:\n\t--- %d ---\n\nУбийств:\n\t--- %d ---\n\n%s\nСчет в банке:\n\t--- %d ---\n\nДом банды:\n\t--- %s ---",gangid,leaderinfo,GangOnlineCount(gangid),Gangs[gangid][gang_kills],ganglevel,Gangs[gangid][gang_bank],GetGangHouseName(gangid));
			format(gname, sizeof(gname),":: Банда: %s (SQLID %d) ::", Gangs[gangid][gang_name], GangSQLID[gangid]);
			
			ShowPlayerDialog(playerid,S_GUI_02,0,gname,gangstat,"OК","Выход");
			
return 1;
}

