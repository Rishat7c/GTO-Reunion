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

forward GangLoadConfig();
forward GangSaveConfig();
forward GetFreeMemberID();
forward GetOnlineGangID(gangname[]);
forward GangLoad(gangname[]);
forward GangCommandHandler(playerid,text[]);
forward PlayerGangColour(playerid);
forward GangJoinMember(gangid,playerid);
forward GangRemoveMember(gangid,kickplayername[],par);

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
forward GangMemberLogin(playerid,gangid);
forward SendGangMessage(gangid,message[MAX_STRING],colour);
forward GangOnlineCount(gangid);
forward GangGiveXP(gangid,xpamount,giverid);
forward SetGangColour(gangid,colour);

#define MAX_GANGS MAX_PLAYERS // maximum gangs (at runtime), (total maximum gangs is unlimited)
#define MAX_GANG_SIZE 30 // maximum number of ppl can be in any specific gang

#define GANG_SAVE_DELAY 1200 //seconds

new GANG_CREATE_COST = 150000; // money cost to create a gang
new GANG_CREATE_LEVEL = 10;		// level cost to create gang
new GANG_COLOUR_COST = 50000; // cost to change gang colour
new GangDB[MAX_STRING] = "GTO/Gang/";

//new GangSQLID[MAX_GANGS];

enum MemberInfo {
 member_active,
 member_online, // bool
 member_name[MAX_NAME],
 member_playerid,
 member_sqlid
}

enum GangInfo {
 gang_active, //bool
 gang_name[MAX_NAME],
    gang_colour,
    gang_kills,
    gang_score,
	gang_savetimer,
	gang_sqlid
}

enum ColourInfo {
 colour_name[MAX_NAME],
    colour_code
}
/*
#define COLOURS_SIZE 21 //     <------------ Old gang colors system
new GangColours[COLOURS_SIZE][ColourInfo] = {
{ "White",    COLOUR_WHITE},
{ "Blood",     COLOUR_RED},
{ "Origin",    COLOUR_LIGHTRED},
{ "Crimson", COLOUR_CRIMSON},
{ "Half",    COLOUR_HALFLIFE},
{ "Orange",    COLOUR_ORANGE},
{ "Yellow",    COLOUR_YELLOW},
{ "Khaki", COLOUR_KHAKI},
{ "Alien",    COLOUR_ALIEN},
{ "Lime",    COLOUR_LIME},
{ "Oceanic", COLOUR_LIGHTGREEN},
{ "Green",    COLOR_DARKGREEN},
{ "Blue",    COLOUR_BLUE},
{ "Bios",    COLOUR_BIOS},
{ "Strange",    COLOUR_DARKAQUA},
{ "Magenta",    COLOUR_MAGENTA},
{ "Gold",    COLOUR_GOLD},
{ "Violet",    COLOR_VIOLET},
{ "Pink",    COLOUR_PINK},
{ "Purple",    COLOUR_PURPLE},
{ "Aqua",   COLOUR_AQUA}
};
*/

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

new GangMemberInfo[MAX_GANGS*MAX_GANG_SIZE][MemberInfo]; //shit way of '3d' array
new GangMembers[MAX_GANGS][MAX_GANG_SIZE]; // shit

new Gangs[MAX_GANGS][GangInfo];
new GangInvite[MAX_PLAYERS];
new tempstring[MAX_STRING];

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

public GetOnlineGangID(gangsqlid)
{
 for (new id=1;id<MAX_GANGS;id++)
 {
  if (Gangs[id][gang_active] == 1)
  {
   if (gangsqlid == Gangs[id][gang_sqlid])
   {
       return id;
   }
  }
 }
 return 0;
}

public GangLoad(gangsqlid)
{

 // search for gang in runtime memory
 for (new id=1;id<MAX_GANGS;id++)
 {
  if (Gangs[id][gang_active] == 1)
  {
   if (gangsqlid == Gangs[id][gang_sqlid])
   {
       return id; // gang found in runtime memory
   }
  }
 }

 new gangid;
 for (new id=1;id<MAX_GANGS;id++)
 {
     if(!Gangs[id][gang_active])
     {
      gangid = id;
      Gangs[id][gang_active] = true; // find first free gang slot and andd our gang
      break;
  }
 }
 gang_load_db_sql(gangid,gangsqlid);
 
 new logstring[256];
 format(logstring, sizeof (logstring), "gang_loaded: %d",gangid);
    WriteLog(logstring);
 return gangid;
}

gang_load_db_sql(gangid,gangsqlid)
{
new query[128];
new DBResult:RES;
new DBResult:RESM;
format(query,sizeof(query),"SELECT * FROM gangs WHERE id = %d LIMIT 1",gangsqlid);
RES = xdb_query(ReunionDB,query);
format(query,sizeof(query),"SELECT id, name FROM players WHERE gang = %d LIMIT %d",gangsqlid,MAX_GANG_SIZE);
RESM = xdb_query(ReunionDB,query);
new memberscount = db_num_rows(RESM);
new MList[MAX_GANG_SIZE][24];
new MSQL[MAX_GANG_SIZE];
fon(new i=0;i<memberscount;i++)
{

}

if(!db_num_rows(RES))
{
new tmp[128];
format(tmp,sizeof(tmp),"Unable to load gang %d",gangsqlid);
WriteSQLLog(tmp);
return 0;
}
new var[32];
db_get_field(RES, 0, var, sizeof(var));
GangSQLID[gangid] = strval(var);

db_get_field(RES, 1, var, sizeof(var));
set(Gangs[gangid][gang_name],var);

db_get_field(RES, 2, var, sizeof(var));

new ghid = -1;
ghid = GetGangHouseID(Gangs[gangid][gang_sqlid]);

/*
if(ghid == -1) {Gangs[gangid][gang_colour] = GangColours[0][colour_code];} else {
if(strval(var) != GangColours[ghid+1][colour_code]) {
new str[128];
format(str,128,"GANG ColorBug | gang:%s | gsid:%d | house:%d",gangname,GangSQLID[gangid],ghid);
WriteSQLLog(str);
Gangs[gangid][gang_colour] = GangColours[ghid+1][colour_code];
} else { Gangs[gangid][gang_colour] = strval(var); }}
*/

db_get_field(RES, 3, var, sizeof(var));
Gangs[gangid][gang_kills] = strval(var);

db_get_field(RES, 4, var, sizeof(var));
Gangs[gangid][gang_score] = strval(var);

for (new gangmember = 0;gangmember < MAX_GANG_SIZE;gangmember++)
{
GangMembers[gangid][gangmember] = GetFreeMemberID();
new memberid = GangMembers[gangid][gangmember];
if (memberid == 0)
{
WriteLog("script error: free gang member id not found.");
break;
}
GangMemberInfo[memberid][member_active] = 1;
GangMemberInfo[memberid][member_online] = 0;

db_get_field(RES, 5+gangmember, var, sizeof(var));
GangMemberInfo[memberid][member_sqlid] = strval(var);
GangMemberInfo[memberid][member_playerid] = INVALID_PLAYER_ID;
}
return 1;
}

public GangCommandHandler(playerid,text[]) // process player commands
{

	new cmd[20];
	new idx;

	set(cmd,strcharsplit(text, idx,strchar(" ")));
	if (strlen(cmd) == 0) return 0;

	if(strcomp(cmd, "/g", true) == 1)
 	{
    	if (PlayerGangid[playerid] == 0) return 1;
     	new gangmessage[MAX_STRING];

     	set(gangmessage,text);
        strdel(gangmessage, 0, idx);
        if (!strlen(gangmessage)) return 1;
     	format(gangmessage, sizeof(gangmessage),  lang_texts[6][2] , oGetPlayerName(playerid),playerid,gangmessage);
        SendGangMessage(PlayerGangid[playerid],gangmessage,COLOUR_GANG_CHAT);

        new logstring[256];
  		format(logstring, sizeof (logstring), "player: %d: g: %d: %s: <GANG CHAT>: %s",playerid,PlayerGangid[playerid],oGetPlayerName(playerid),text);
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
		
  		if(strcomp(cmd, "commands", true) == 1)
  		{
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
   			//SendPlayerScrollingText(playerid,  lang_texts[6][20] );
   			return 1;
  		}

	 // <------------ Old gang colors system
  		if((strcomp(cmd, "colours", true) == 1) || (strcomp(cmd, "colors", true) == 1))
		//if(strcomp(cmd, "colourlist", true) == 1)
  		{
   			SendPlayerFormattedText(playerid,  lang_texts[6][22], 0,COLOUR_GREEN);
   			for (new i = 0;i<COLOURS_SIZE;i++)
   			{
    			format(tempstring, sizeof(tempstring),  lang_texts[6][23] ,GangColours[i][colour_name]);
    			SendPlayerFormattedText(playerid, tempstring, 0,GangColours[i][colour_code]);
   			}
   			return 1;
  		}

  		if((strcomp(cmd, "stats", true) == 1) || (strcomp(cmd, "stat", true) == 1) || (strcomp(cmd, "status", true) == 1))
  		{

      		if (PlayerGangid[playerid] == 0)
      		{
          		SendPlayerFormattedText(playerid,  lang_texts[6][24] , 0,COLOUR_RED);
       			return 1;
      		}
      		new gangid = PlayerGangid[playerid];
      		format(tempstring, sizeof(tempstring),  lang_texts[6][25] , Gangs[gangid][gang_name]);
      		SendPlayerFormattedText(playerid, tempstring, 0,Gangs[gangid][gang_colour]);
      		format(tempstring, sizeof(tempstring),  lang_texts[6][26] , Gangs[gangid][gang_kills]);
   			SendPlayerFormattedText(playerid, tempstring, 0,COLOUR_MISC);
   			format(tempstring, sizeof(tempstring),  lang_texts[6][27] , Gangs[gangid][gang_score]);
   			SendPlayerFormattedText(playerid, tempstring, 0,COLOUR_MISC);

   			format(tempstring, sizeof(tempstring),  lang_texts[6][28] , GangOnlineCount(gangid));
   			SendPlayerFormattedText(playerid, tempstring, 0,COLOUR_MISC);
   			return 1;
  		}

  		if(strcomp(cmd, "members", true) == 1)
  		{

      		if (PlayerGangid[playerid] == 0)
      		{
       			SendPlayerFormattedText(playerid,  lang_texts[6][29] , 0,COLOUR_RED);
       			return 1;
      		}
      		new gangid = PlayerGangid[playerid];
      		new status[10];
      		format(tempstring, sizeof(tempstring),  lang_texts[6][30] , Gangs[gangid][gang_name]);
      		SendPlayerFormattedText(playerid, tempstring, 0,Gangs[gangid][gang_colour]);

      		for (new gangmember = 0;gangmember<MAX_GANG_SIZE;gangmember++)
   			{ // foreach member
    			new memberid = GangMembers[gangid][gangmember];
    			if (strlen(GangMemberInfo[memberid][member_name]) > 0)
          		{
           			if (GangMemberInfo[memberid][member_online])
           			{
      					set(status,"Online");
         				format(tempstring, sizeof(tempstring),  lang_texts[6][31] , GangMemberInfo[memberid][member_name],status,GetPlayerLevel(GangMemberInfo[memberid][member_playerid]));
     				}
     				else
     				{
      					set(status,"Offline");
      					format(tempstring, sizeof(tempstring),  lang_texts[6][32] , GangMemberInfo[memberid][member_name],status);
     				}
     				SendPlayerFormattedText(playerid, tempstring, 0,COLOUR_MISC);
    			}
   			}
   			return 1;
  		}

  		if(strcomp(cmd, "create", true) == 1)
  		{

      		if (PlayerGangid[playerid] != 0)
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
			
   			//new colourname[MAX_NAME]; // <------------ Old gang colors system
   			new gangcolour=255;
			/*
			 // <------------ Old gang colors system
   			set(colourname,strcharsplit(text, idx,strchar(" ")));
   			if(!strlen(colourname))
   			{
       			SendPlayerFormattedText(playerid,  lang_texts[6][35] , 0,COLOUR_RED);
                SendPlayerFormattedText(playerid,  lang_texts[6][36] , 0,COLOUR_RED);
    			return 1;
         	}

			
			
			
			
         	for (new colourid=0;colourid<COLOURS_SIZE;colourid++)
         	{
             	if (strcomp("Homeless",GangColours[colourid][colour_name],true) == 1)
             	{
              		gangcolour = GangColours[colourid][colour_code];
    			}
         	}
			
			*/
			
			
			gangcolour = GangColours[0][colour_code];
			
         	if (gangcolour == 255)
         	{
          		SendPlayerFormattedText(playerid,  lang_texts[6][37] , 0,COLOUR_RED);
                SendPlayerFormattedText(playerid,  lang_texts[6][38] , 0,COLOUR_RED);
    			return 1;
   			}
			
			
      		//set(gangname,text);
         	//strdel(gangname, 0, idx);
			set(gangname,strcharsplit(text, idx,strchar(" ")));
         	if (strlen(gangname) <3)
   			{
       			SendPlayerFormattedText(playerid,  lang_texts[6][39] , 0,COLOUR_RED);
    			return 1;
   			}
   			if (strlen(gangname) >40)
   			{
       			SendPlayerFormattedText(playerid,  lang_texts[6][40] , 0,COLOUR_RED);
    			return 1;
   			}
   			new tempname[MAX_STRING];
   			set(tempname,gangname);
   			if (!StringCharCheck(tempname))
   			{
    			SendPlayerFormattedText(playerid,  lang_texts[6][41] , 0,COLOUR_RED);
    			return 1;
   			}

			//printf("%s %d",gangname,gangcolour);
			
   			if (GangCreate(playerid,gangname,gangcolour) != 0)
   			{
    			oGivePlayerMoney(playerid,0-GANG_CREATE_COST,1);
    			SendPlayerFormattedText(playerid,  lang_texts[6][42] , 0,COLOUR_GREEN);
    			new logstring[256];
    			format(logstring, sizeof (logstring), "player: %d:  %s: created gang '%s' ",playerid,oGetPlayerName(playerid),gangname);
				SendPlayerFormattedText(playerid,  "Автоматически установлен стандартный цвет банды!" , 0,COLOUR_GREEN);
				SendPlayerFormattedText(playerid,  "Цвет изменится при покупке дома" , 0,COLOUR_GREEN);
       			WriteLog(logstring);
   			}
   			else
   			{
    			SendPlayerFormattedText(playerid,  lang_texts[6][43] , 0,COLOUR_RED);
   			}
			
			
  			return 1;
  		} // end create

  		if((strcomp(cmd, "accept", true) == 1) || (strcomp(cmd, "join", true) == 1))
  		{
      		if (PlayerGangid[playerid] != 0)
      		{
       			SendPlayerFormattedText(playerid,  lang_texts[6][44] , 0,COLOUR_RED);
				return 1;
      		}
      		if (GangInvite[playerid] == 0)
      		{
       			SendPlayerFormattedText(playerid,  lang_texts[6][45] , 0,COLOUR_RED);
    			return 1;
      		}
   			new gangid = GangInvite[playerid];

   			if (GangOnlineCount(gangid) >= MAX_GANG_SIZE)
   			{

    			SendPlayerFormattedText(playerid,  lang_texts[6][46] , 0,COLOUR_RED);
    			GangInvite[playerid] = 0;
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

  		if (PlayerGangid[playerid] == 0)
  		{
   			SendPlayerFormattedText(playerid,  lang_texts[6][50] , 0,COLOUR_RED);
   			return 1;
  		}
  		new gangid = PlayerGangid[playerid];
  		new leadermemberid = GangMembers[gangid][0];


  		if((strcomp(cmd, "quit", true) == 1) || (strcomp(cmd, "leave", true) == 1))
  		{
      		if (PlayerGangid[playerid] == 0)
      		{
       			SendPlayerFormattedText(playerid,  lang_texts[6][51] , 0,COLOUR_RED);
       			return 1;
      		}
			
			if (strcomp(GangMemberInfo[leadermemberid][member_name],oGetPlayerName(playerid),true) == 1)
      		{ // player is leader of this gang			
				ShowPlayerDialog(playerid,GGUI,0,"::: ВНИМАНИЕ :::",lang_texts[6][81],"YES","NO");
    			return 1;
			}
			
      		GangRemoveMember(gangid,oGetPlayerName(playerid),0);
      		return 1;
  		}

  		if(strcomp(cmd, "invite", true) == 1)
  		{
      		if (strcomp(GangMemberInfo[leadermemberid][member_name],oGetPlayerName(playerid),false) == 0)
      		{ // player is not leader of this gang
       			SendPlayerFormattedText(playerid,  lang_texts[6][52] , 0,COLOUR_RED);
    			return 1;
   		}

/* приглашение по имени
     		new inviteid = INVALID_PLAYER_ID;

      		new inviteplayername[MAX_NAME];
   			set(inviteplayername,text);
            strdel(inviteplayername, 0, idx);
            if (!strlen(inviteplayername))
            {
       			SendPlayerFormattedText(playerid,  lang_texts[6][53] , 0,COLOUR_RED);
                return 1;
         	}

            for (new i = 0;i<MAX_PLAYERS;i++)
            {
                if (IsPlayerRegistered(i))
                {
                    if (strcomp(oGetPlayerName(i),inviteplayername,true) == 1)
                    {
                     inviteid = i;
                     break;
                    }
                }
            }
*/
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
      		if (inviteid == INVALID_PLAYER_ID)
      		{
//       			SendPlayerFormattedText(playerid,  lang_texts[6][54] , 0,COLOUR_RED);
       			SendPlayerFormattedText(playerid,  "Применение: /gang invite <ID>" , 0,COLOUR_RED);

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

   			if (PlayerGangid[inviteid] != 0)
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
  		}

  		if(strcomp(cmd, "delete", true) == 1)
  		{
      		if (strcomp(GangMemberInfo[leadermemberid][member_name],oGetPlayerName(playerid),false) == 0)
      		{
       			SendPlayerFormattedText(playerid,  lang_texts[6][60] , 0,COLOUR_RED);
    			return 1;
   			}
								
   			new kickplayername[MAX_NAME];
   			set(kickplayername,text);
            strdel(kickplayername, 0, idx);
            if (!strlen(kickplayername))
            {
            	SendPlayerFormattedText(playerid,  lang_texts[6][61] , 0,COLOUR_RED);
    			return 1;
            }
			
//			if (strcomp(GangMemberInfo[leadermemberid][member_name],kickplayername,true) == 1)
//			{
//			GangRemove(gangid,1); // kickall
//			SendClientMessage(playerid,COLOUR_GANG,"Вы распустили свою банду");
//			return 1;
//			}
			
            if (GangRemoveMember(gangid,kickplayername,0))
            {
       			format(tempstring, sizeof(tempstring),  lang_texts[6][62] , kickplayername);
    			SendPlayerFormattedText(playerid, tempstring, 0,COLOUR_GREEN);
   			}
   			else
   			{
    			format(tempstring, sizeof(tempstring),  lang_texts[6][63] , kickplayername);
    			SendPlayerFormattedText(playerid, tempstring, 0,COLOUR_RED);
   			}
   			return 1;

  		}
/*
  		if((strcomp(cmd, "colour", true) == 1) || (strcomp(cmd, "color", true) == 1))
  		{
      		if (strcomp(GangMemberInfo[leadermemberid][member_name],oGetPlayerName(playerid),false) == 0)
      		{
       			SendPlayerFormattedText(playerid,  lang_texts[6][64] , 0,COLOUR_RED);
    			return 1;
   			}
    		if (oGetPlayerMoney(playerid) < GANG_COLOUR_COST)
      		{
       			SendPlayerFormattedText(playerid,  lang_texts[6][65] , GANG_COLOUR_COST,COLOUR_RED);
    			return 1;
   			}
   			new colourname[MAX_NAME];
   			new gangcolour;
   			set(colourname,strcharsplit(text, idx,strchar(" ")));
   			if(!strlen(colourname))
   			{
       			SendPlayerFormattedText(playerid,  lang_texts[6][66] , 0,COLOUR_RED);
   				return 1;
         	}

        	for (new colourid=0;colourid<COLOURS_SIZE;colourid++)
         	{
            	if (strcomp(colourname,GangColours[colourid][colour_name],true) == 1)
             	{
              		gangcolour = GangColours[colourid][colour_code];
    			}
         	}
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
		*/
	} // end gang
 	return 0;
}

public PlayerGangColour(playerid)
{
 new gangid = PlayerGangid[playerid];
 new newcolour = COLOUR_PLAYER;
 if (gangid != 0)
 {
     if (Gangs[gangid][gang_colour] != 0)
     {
         newcolour = Gangs[gangid][gang_colour];
  }
 }
 return newcolour;
}

public GangJoinMember(gangid,playerid)
{
 if (gangid == 0)
 {
        WriteLog("script_warning: invalid gang id.");
  return 0;

 }
 if (PlayerGangid[playerid] != 0)
    {
     WriteLog("script_warning: player already in a gang!");
  return 0;
    }

 if (GangOnlineCount(gangid) >= MAX_GANG_SIZE)
 {
  WriteLog("script_warning: Gang is already full.");
  return 0;
 }

 for (new gangmember = 0;gangmember<MAX_GANG_SIZE;gangmember++)
 { // foreach member of the gang
  new memberid = GangMembers[gangid][gangmember]; // get memberid
  if (strlen(GangMemberInfo[memberid][member_name]) == 0) // if member slot free
  {
   set(GangMemberInfo[memberid][member_name],oGetPlayerName(playerid));
      GangMemberInfo[memberid][member_playerid] = playerid;
      GangMemberInfo[memberid][member_online] = 1;
      PlayerGangid[playerid] = gangid;
      set(PlayerGangName[playerid],Gangs[gangid][gang_name]);
      GangMemberLogin(gangid,playerid);
	  SetPlayerColour(playerid,Gangs[gangid][gang_colour]);
      return 1;
  }
 }
 return 0;
}

public GangRemoveMember(gangid,kickplayername[],par )
{
new playerid = INVALID_PLAYER_ID;

 for (new gangmember = 0;gangmember<MAX_GANG_SIZE;gangmember++)
 { // foreach member of the gang

  new memberid = GangMembers[gangid][gangmember]; // get memberid
  if (strcomp(GangMemberInfo[memberid][member_name],kickplayername,true) == 1)
  {
   playerid = GangMemberInfo[memberid][member_playerid];
      GangMemberInfo[memberid][member_online] = 0;
      GangMemberInfo[memberid][member_playerid] = INVALID_PLAYER_ID;
	  
   set(GangMemberInfo[memberid][member_name],nullstr);
   //format(GangMemberInfo[memberid][member_name],1,"%s",nullstr);

   format(tempstring, sizeof(tempstring),  lang_texts[6][70] , kickplayername);
   SendGangMessage(gangid,tempstring,COLOUR_GANG);

            new logstring[256];
   format(logstring, sizeof (logstring), "%s has been removed from gang '%s'", kickplayername,Gangs[gangid][gang_name]);
      WriteLog(logstring);

   if (playerid != INVALID_PLAYER_ID)
   {
    format(tempstring, sizeof(tempstring),  lang_texts[6][71] , Gangs[gangid][gang_name]);
    SendClientMessage(playerid,COLOUR_GANG,tempstring);
    PlayerGangid[playerid] = 0;
    set(PlayerGangName[playerid],nullstr);
	SetPlayerColour(playerid,COLOUR_PLAYER);
   }
   
	if(par == 0)
	{
	GangSave(gangid);
    if (GangOnlineCount(gangid) == 0)
    {
          GangUnload(gangid);
	}}
			
   return 1;
  }
 }
 return 0;
}

public GangRemove(gangid,par) // if par == 0, delete ALL members, if par == 1, delete without leader
{
if(par < 0 || par > 1) {return 0;}

if(!par)
{
new str[128];
format(str,sizeof(str),"SERVER: Банда '%s' удалена!",Gangs[gangid][gang_name]);
SendClientMessageToAll(Gangs[gangid][gang_colour],str);
}

for (new gangmember = par;gangmember<MAX_GANG_SIZE;gangmember++)
{
new memberid = GangMembers[gangid][gangmember];
GangRemoveMember(gangid,GangMemberInfo[memberid][member_name],1);
}

if (GangOnlineCount(gangid) == 0)
{ GangUnload(gangid); } else {GangSave(gangid);}

return 1;
}


public GangCreate(leaderid,gangname[],gangcolour)
{
 if (!IsPlayerRegistered(leaderid)) return 0;

 new tempname[MAX_STRING];
 set(tempname,gangname);
 if (!StringCharCheck(tempname))
  {
  SendPlayerFormattedText(leaderid,  lang_texts[6][72] , 0,COLOUR_RED);
  return 0;
 }
 
 if(tempname[0] == 32) // (' ')
 {
 SendPlayerFormattedText(leaderid,  "Первый символ в имени не должен быть пробелом!" , 0,COLOUR_RED);
 return 0;
 }

 // udb
 //new udbfilename[MAX_NAME];
 //set(udbfilename,gangname);
 //strcat(udbfilename,".Gang",sizeof(udbfilename));

 // dini
 if(DBTYPE == 0)
 {
 new dinifilename[MAX_STRING];
 format(dinifilename,sizeof(dinifilename),"%sGTO.Gang.%s.txt",GangDB,gangname);

 if (dini_Exists(dinifilename))
 {
 SendClientMessage(leaderid,COLOUR_RED,  lang_texts[6][73] );
 return 0;
 }
 }
 if(DBTYPE == 1)
 {
 new DBResult:gangreg;
 new query[MAX_STRING];
 format(query,sizeof(query),"SELECT * FROM gangs WHERE name = '%s' LIMIT 1",gangname);
 gangreg = xdb_query(ReunionDB,query);
 if(db_num_rows(gangreg))
 {
 SendClientMessage(leaderid,COLOUR_RED,  lang_texts[6][73] );		
 return 0;
 }
 }

 // Create the gang
 new gangid;
 for (new id=1;id<MAX_GANGS;id++)
 {
     if(!Gangs[id][gang_active])
     {
      gangid = id;
      Gangs[id][gang_active] = true; // find first free gang slot and andd our gang
      break;
  }
 }
 
 if(DBTYPE == 1) {
 GangSQLID[gangid] = GetFreeSQLID("gangs");
 new query[MAX_STRING];
 format(query, sizeof(query), "INSERT INTO gangs ( id, name) VALUES ( %d, '%s')",GangSQLID[gangid],gangname);
 xdb_query(ReunionDB,query);
 }

//printf("fcolor %d",gangcolour);

 set(Gangs[gangid][gang_name],gangname);
 Gangs[gangid][gang_colour] = gangcolour;
 Gangs[gangid][gang_kills] = 0;
 Gangs[gangid][gang_score] = 0;

//printf("gcolor %d",Gangs[gangid][gang_colour]);
 
 for (new gangmember = 0;gangmember<MAX_GANG_SIZE;gangmember++)
 { // foreach member

  GangMembers[gangid][gangmember] = GetFreeMemberID();
  new memberid = GangMembers[gangid][gangmember];
  if (memberid == 0)
  {
   WriteLog("script error: free gang member id not found.");
   return 0;
  }

  GangMemberInfo[memberid][member_active] = 1;
  GangMemberInfo[memberid][member_online] = 0;
  GangMemberInfo[memberid][member_playerid] = INVALID_PLAYER_ID;
 }

 new memberid = GangMembers[gangid][0];
 set(GangMemberInfo[memberid][member_name],oGetPlayerName(leaderid));
 GangMemberInfo[memberid][member_playerid] = leaderid;
 GangMemberInfo[memberid][member_online] = 1;
 set(PlayerGangName[leaderid],gangname);
 PlayerGangid[leaderid] = gangid;
 
 SetPlayerColour(leaderid,Gangs[gangid][gang_colour]);
 
 //print("Color set");

 GangSave(gangid);

 return gangid;
}

public GangCleanup(gangid)
{
 if (!Gangs[gangid][gang_active]) return;

 for (new gangmember = 0;gangmember<MAX_GANG_SIZE;gangmember++)
 { // foreach member of the gang

  new memberid = GangMembers[gangid][gangmember]; // get memberid
  if (GangMemberInfo[memberid][member_online])
  {
      if (GangMemberInfo[memberid][member_playerid] == INVALID_PLAYER_ID) return;
      if (!IsPlayerRegistered(GangMemberInfo[memberid][member_playerid]))
   {
    GangMemberLogout(GangMemberInfo[memberid][member_playerid],gangid);
    GangMemberInfo[memberid][member_online] = 0;
   }
  }
 }

 if (GangOnlineCount(gangid) == 0)
    {
        GangUnload(gangid);
 }
}

public GangSaveAll()
{
 for (new i = 1;i<MAX_GANGS;i++)
 {
  if (Gangs[i][gang_active])
  {
      GangSave(i);
      GangCleanup(i);
  }
 }
}

public CheckGangs()
{ new tmp[128];
for (new i = 1;i<MAX_GANGS;i++)
{ if (Gangs[i][gang_active]) {
if(Gangs[i][gang_savetimer] < GANG_SAVE_DELAY) {Gangs[i][gang_savetimer]++;}
else { Gangs[i][gang_savetimer] = 0; GangSave(i); GangCleanup(i); 
format(tmp,sizeof(tmp),"GANG AUTOSAVE | gsqlid=%d | gname='%s'",GangSQLID[i],Gangs[i][gang_name]);
WriteSQLLog(tmp);
}}} return 1; }

public GangMemberLogout(playerid,gangid)
{
 GangInvite[playerid] = 0;
 if (gangid == 0)
 {
  return;
 }
 for (new gangmember = 0;gangmember<MAX_GANG_SIZE;gangmember++)
 { // foreach member of the gang
  new memberid = GangMembers[gangid][gangmember]; // get memberid
  if (GangMemberInfo[memberid][member_playerid] == playerid)
  {
   GangMemberInfo[memberid][member_online] = 0;
   GangMemberInfo[memberid][member_playerid] = INVALID_PLAYER_ID;
   break;
  }
 }
    if (GangOnlineCount(gangid) == 0)
    {
        GangUnload(gangid);
 }
 else
 {
  format(tempstring, sizeof(tempstring),  lang_texts[6][74] , oGetPlayerName(playerid));
  SendGangMessage(gangid,tempstring,COLOUR_GANG);
 }
}

public GangSave(gangid)
{
 if (gangid == 0) return 0;
 if (!Gangs[gangid][gang_active]) return 0;
 if (!strlen(Gangs[gangid][gang_name])) return 0;
 //gang_save_db_dini(gangid);
 gang_save_db_sql(gangid);
 return 1;
}

gang_save_db_sql(gangid)
{
if(GangSQLID[gangid] == 0) {return;}
new lquery[MAX_STRING];
format(lquery,sizeof(lquery),"UPDATE gangs SET name='%s', color='%d', kills=%d, score=%d WHERE id=%d",Gangs[gangid][gang_name],Gangs[gangid][gang_colour],Gangs[gangid][gang_kills],Gangs[gangid][gang_score], GangSQLID[gangid]);
xdb_query(ReunionDB,lquery);
set(lquery,nullstr);
for (new gm = 0;gm<MAX_GANG_SIZE;gm++)
{
if(strlen(lquery) < 1) { format(lquery,sizeof(lquery),"UPDATE gangs SET"); }
format(lquery,sizeof(lquery),"%s mem%d='%s'",lquery,gm,GangMemberInfo[ GangMembers[gangid][gm] ][member_name]);
if(strlen(lquery) >= MAX_STRING-50)
{
format(lquery,sizeof(lquery),"%s WHERE id=%d",lquery,GangSQLID[gangid]);
xdb_query(ReunionDB,lquery);
format(lquery,sizeof(lquery),nullstr);
} else if (gm < MAX_GANG_SIZE-1 ) strcat(lquery, ",", sizeof(lquery));
}
if(strlen(lquery))
{
format(lquery,sizeof(lquery),"%s WHERE id=%d",lquery,GangSQLID[gangid]);
xdb_query(ReunionDB,lquery);
}
}


stock gang_save_db_dini(gangid)
{
 new gangname[MAX_STRING];
 set(gangname,Gangs[gangid][gang_name]);
 new dinifilename[MAX_STRING];
  format(dinifilename,sizeof(dinifilename),"%sGTO.Gang.%s.txt",GangDB,gangname);
 if (!dini_Exists(dinifilename))
 {
  //dini_Create(dinifilename);
  if (strlen(gangname) > 1) {dini_Create(dinifilename);}
 }

 new temp[MAX_STRING];

 dini_Set(dinifilename,"Name",gangname);

 dini_IntSet(dinifilename,"Colour",Gangs[gangid][gang_colour]);
 //Note//
 //<dini_IntSet> used for write colour info because function <valstr>
 //crashed server if colour = 0x8EBC8EFF and many others colours
 //Do not uncomment lines if your scripting level is too low!
 //valstr(temp,Gangs[gangid][gang_colour]);
 //dini_Set(dinifilename,"Colour",temp);

 valstr(temp,Gangs[gangid][gang_kills]);
 dini_Set(dinifilename,"Kills",temp);

 valstr(temp,Gangs[gangid][gang_score]);
 dini_Set(dinifilename,"Score",temp);

 for (new gangmember = 0;gangmember<MAX_GANG_SIZE;gangmember++)
 { // foreach member of the gang
     
     new memberid = GangMembers[gangid][gangmember];
	 new dinistring[MAX_STRING];
     format(dinistring,sizeof(dinistring),"Member%d",gangmember);
	// if (strcomp(GangMemberInfo[memberid][member_name],nullstr,false) == 0) //Если имя НЕ равно Ньльстроке
	// {	 
	 dini_Set(dinifilename,dinistring,GangMemberInfo[memberid][member_name]);
	 //}
  
 }
}

// public GangUnload(gangid)
// {
 // GangSave(gangid);
 // for (new gangmember = 0;gangmember<MAX_GANG_SIZE;gangmember++)
 // { // foreach member
  // new memberid = GangMembers[gangid][gangmember];
  // GangMemberInfo[memberid][member_active] = 0;
  // GangMemberInfo[memberid][member_online] = 0;
  // GangMemberInfo[memberid][member_playerid] = INVALID_PLAYER_ID;
 // }
 // Gangs[gangid][gang_active] = 0;

// }

public GangUnload(gangid)
{
GangSave(gangid);
//new dinifilename[MAX_STRING];
//format(dinifilename,sizeof(dinifilename),"%sGTO.Gang.%s.txt",GangDB,Gangs[gangid][gang_name]);
//if (IsGangFileEmpty(dinifilename))
if (IsGangLineEmpty(GangSQLID[gangid]))
	{ //No members in gang. remove file.
	//if (dini_Exists(dinifilename))
		//{
		//dini_Remove(dinifilename);
		//new logstring[MAX_STRING];
		//format(logstring,MAX_STRING,"gang %s (%d) removed (no members in file)",Gangs[gangid][gang_name],gangid);
		//WriteLog(logstring);
		//}
	if (DBTYPE == 1)
		{
		new query[128];
		format(query,sizeof(query),"DELETE FROM gangs WHERE id=%d",GangSQLID[gangid]);
		xdb_query(ReunionDB,query);
		format(query,sizeof(query),"gang %s (%d) removed (no members in file)",Gangs[gangid][gang_name],gangid);
		WriteLog(query);
		}
	
	new hid = -1;
	hid = GetGangHouseID(Gangs[gangid][gang_name]);
	if(hid > -1)
	{HouseMakeOwnerless(hid);} //банда удаляется и если владела домом, то дом становится ничейным
	}

 for (new gangmember = 0;gangmember<MAX_GANG_SIZE;gangmember++)
 { // foreach member
  new memberid = GangMembers[gangid][gangmember];
  set(GangMemberInfo[memberid][member_name],nullstr);
  //format(GangMemberInfo[memberid][member_name],1,"%s",nullstr);
  GangMemberInfo[memberid][member_active] = 0;
  GangMemberInfo[memberid][member_online] = 0;
  GangMemberInfo[memberid][member_playerid] = INVALID_PLAYER_ID;
  GangMembers[gangid][gangmember] = 0;
 }
 Gangs[gangid][gang_active] = 0;
 set(Gangs[gangid][gang_name],nullstr);
 set(Gangs[gangid][gang_colour],nullstr);
 Gangs[gangid][gang_kills] = 0;
 Gangs[gangid][gang_score] = 0;
 Gangs[gangid][gang_savetimer] = 0;
 GangSQLID[gangid] = 0;

}

public GangKill(gangid,killerid,victimid,reason)
{
 if (victimid != INVALID_PLAYER_ID)
 {
     Gangs[gangid][gang_kills]++;
 }
 if (PlayerGangid[killerid] == PlayerGangid[victimid])
    { // killed a gang member
  format(tempstring, sizeof(tempstring),  lang_texts[6][76] , oGetPlayerName(killerid));
  SendGangMessage(PlayerGangid[killerid],tempstring,COLOUR_GANG);
     return 1;
    }
    return 0;
}



public GangMemberLogin(playerid,gangid)
{
 if (PlayerGangid[playerid] != 0)
 {
  PlayerGangid[playerid] = 0;
 }
 if (gangid == 0)
 {
  return 0;
 }
 for (new gangmember = 0;gangmember<MAX_GANG_SIZE;gangmember++)
 { // foreach member of the gang
  new memberid = GangMembers[gangid][gangmember]; // get memberid

  if (strcomp(GangMemberInfo[memberid][member_name],oGetPlayerName(playerid),false) == 1)
  {
   format(tempstring, sizeof(tempstring),  lang_texts[6][77] , oGetPlayerName(playerid));
   SendGangMessage(gangid,tempstring,COLOUR_GANG);
   GangMemberInfo[memberid][member_online] = 1;
   GangMemberInfo[memberid][member_playerid] = playerid;
   PlayerGangid[playerid] = gangid;
   
   
   set(PlayerGangName[playerid],Gangs[gangid][gang_name]);

      format(tempstring, sizeof(tempstring),  lang_texts[6][78] ,Gangs[gangid][gang_name],GangOnlineCount(gangid)-1);
   SendPlayerFormattedText(playerid, tempstring, 0,COLOUR_GANG);
   GangInvite[playerid] = 0;
   SetPlayerColour(playerid,Gangs[gangid][gang_colour]);
   return 1;
  }
 }
 return 0;
}


public SendGangMessage(gangid,message[MAX_STRING],colour)
{
 for (new gangmember = 0;gangmember<MAX_GANG_SIZE;gangmember++)
 { // foreach member of the gang
  new memberid = GangMembers[gangid][gangmember]; // get memberid
  if(GangMemberInfo[memberid][member_online]) SendPlayerFormattedText(GangMemberInfo[memberid][member_playerid], message, 0,colour);
 }
}

public GangOnlineCount(gangid)
{
 new memberscount;
 for (new gangmember = 0;gangmember<MAX_GANG_SIZE;gangmember++)
 { // foreach member of the gang
  new memberid = GangMembers[gangid][gangmember]; // get memberid
  if (GangMemberInfo[memberid][member_online]) memberscount++;
 }
    return memberscount;
}

public GangGiveXP(gangid,xpamount,giverid)
{
 Gangs[gangid][gang_score] = Gangs[gangid][gang_score] + xpamount;
 new giveamount;
 giveamount = xpamount / GangOnlineCount(gangid);

 for (new gangmember = 0;gangmember<MAX_GANG_SIZE;gangmember++)
 { // foreach member of the gang
  new memberid = GangMembers[gangid][gangmember]; // get memberid
  if((GangMemberInfo[memberid][member_online] == 1) && (giverid != GangMemberInfo[memberid][member_playerid]))
  {
   GivePlayerXP(GangMemberInfo[memberid][member_playerid],giveamount,0);
   if (giveamount >= 300)
   {
   new string[MAX_STRING];
   format(string, sizeof(string),  lang_texts[6][79] ,giveamount,oGetPlayerName(giverid));
   SendPlayerFormattedText(GangMemberInfo[memberid][member_playerid], string, 0,COLOUR_XP_GOOD);
   }
  }
 }
}


public SetGangColour(gangid,colour)
{
 Gangs[gangid][gang_colour] = colour;
 for (new gangmember = 0;gangmember<MAX_GANG_SIZE;gangmember++)
 { // foreach member of the gang
  new memberid = GangMembers[gangid][gangmember]; // get memberid
  if(GangMemberInfo[memberid][member_online] == 1)
  {
   new playerid = GangMemberInfo[memberid][member_playerid];
   SetPlayerColour(playerid,colour);
  }
 }
}


stock IsGangFileEmpty(filename[])
{
if (!dini_Exists(filename)) return true;
new dinistring[MAX_STRING];
 for (new gangmember = 0;gangmember<MAX_GANG_SIZE;gangmember++)
 {
  format(dinistring,MAX_STRING,"Member%d" ,gangmember);
  if(strlen(dini_Get(filename,dinistring)) > 0) return false;
 }
return true;
}

stock IsGangLineEmpty(gangsqlid)
{
new query[128];
new DBResult:RES;
format(query,sizeof(query),"SELECT * FROM gangs WHERE id=%d LIMIT 1",gangsqlid);
RES = xdb_query(ReunionDB,query);
if(!db_num_rows(RES))
{
return true;
}
new var[32];
for (new i = 0;i<MAX_GANG_SIZE;i++)
{
db_get_field(RES, 5+i, var, sizeof(var));
if(strlen(var) > 0) {return false;}
}
return true;
}

