//SQLite GTO database engine

#if defined _database_sql_included
  #endinput
#endif

#define _database_sql_included
#pragma library database_sql

forward DBResult:xdb_query(DB:db,query[]);
forward DatabaseConnect();
forward CreateTableForPlayers();
forward CreateTableForCars();
forward CreateTableForGangs();
forward CreateTableForHouses();
forward CreateGraph();
forward UpdatePlayerVarInt(playerid, fieldname[], integer);
forward SendClientQuery(playerid,query[]);
forward PlayerSQLID2ID(sqlid);

/*
#define db_id		0	//acc on reg
#define db_name		1	//pls var
#define db_ip		2	//acc on login
#define db_pass		3	//acc var
#define db_email	4	//acc var
#define db_cdate	5	//acc on reg
#define db_llogin	6	//acc on login
#define db_gang		7
#define db_lvl		8
#define db_xp		9
#define db_money	10
#define db_bmoney	11
#define db_deaths	12
#define db_kills	13
#define	db_jailed	14
#define db_muted 	15
#define db_x		16
#define db_y		17
#define db_z		18
#define db_stat		19
#define db_weap		20
#define db_skill	21
#define db_skin		22
#define db_vip		23
#define db_car		24
#define db_packages	25
#define db_rxp		26
#define db_train1	27 // Обучение Дальнобоя
#define db_train2	28 // Обучение Гонки
#define db_train3	29 // Обучение Дм
#define db_train4	30 // Теор часть
*/

public DBResult:xdb_query(DB:db,query[])
{
//QCounter++;
//new incount = QCounter;
//new sttime = GetTickCount();

if(DBLOG){WriteSQLLog(query);}
if(DBCONSOLELOG){print(query);}
//new DBResult:QRES = db_query(db,query);

//printf("Result of query [ %d ][ time %d ms ][ %s ]", incount, GetTickCount() - sttime, query);

//return QRES;
return DBResult:db_query(db,query);
}

new STOP_IF_EMPTY = 0;

public DatabaseConnect() // must be run on gamemode run
{
	if(fexist(DBNAME))
	{
		ReunionDB = db_open(DBNAME);
	}
	else
	{
		ReunionDB = db_open(DBNAME);
		CreateTableForPlayers();
		CreateTableForCars();
		CreateTableForGangs();
	}
//CreateGraph();
//CreateTableForPlayers();
//CreateTableForCars();
//CreateTableForGangs();
//GameModeExit();

new DBResult:tryconnect_p;
new DBResult:tryconnect_c;
new DBResult:tryconnect_g;

new var_p = 0;
new var_c = 0;
new var_g = 0;

//--------------------------------------------------------------------------
WriteSQLLog("- - - - - - - - - - ");
WriteSQLLog("DB try to Connect...");
tryconnect_p = xdb_query(ReunionDB,"SELECT id FROM players");
tryconnect_c = xdb_query(ReunionDB,"SELECT id FROM cars");
tryconnect_g = xdb_query(ReunionDB,"SELECT id FROM gangs");

var_p = db_num_rows(tryconnect_p);
var_c = db_num_rows(tryconnect_c);
var_g = db_num_rows(tryconnect_g);

if(!var_p)
{
print("\n----------------------[SQLite]-----------------------\n");
print("[SQLite] Connection failure or empty table players... ");
print("\n-----------------------------------------------------\n");
WriteSQLLog("DB Connection FAILURE [p]");
CreateTableForPlayers();
if(STOP_IF_EMPTY){GameModeExit(); return 0;}
}
if(!var_c)
{
print("\n----------------------[SQLite]-----------------------\n");
print("[SQLite] Connection failure or empty table cars... ");
print("\n-----------------------------------------------------\n");
WriteSQLLog("DB Connection FAILURE [c]");
CreateTableForCars();
if(STOP_IF_EMPTY){GameModeExit(); return 0;}
}
if(!var_g)
{
print("\n----------------------[SQLite]-----------------------\n");
print("[SQLite] Connection failure or empty table gangs... ");
print("\n-----------------------------------------------------\n");
WriteSQLLog("DB Connection FAILURE [g]");
CreateTableForGangs();
if(STOP_IF_EMPTY){GameModeExit(); return 0;}
}

print("\n----------------------[SQLite]-----------------------\n");
printf("[SQLite] Connect to players success... %d accounts registered", var_p );
printf("[SQLite] Connect to cars success...... %d cars registered", var_c );
printf("[SQLite] Connect to gangs success..... %d gangs registered", var_g );
print("\n-----------------------------------------------------\n");
WriteSQLLog("DB Connection SUCCESS");

return 1;
}
/*
if(!strlen(var_h))
{
print("\n----------------------[SQLite]-----------------------\n");
print("[SQLite] Problem with houses table...");
print("\n-----------------------------------------------------\n");
WriteSQLLog("DB Connection FAILURE [h]");
GameModeExit();
return 0;
}
else
{
tryconnect_h = xdb_query(ReunionDB,"SELECT id FROM houses");
	if(db_num_rows( tryconnect_h ) < MAX_HOUSES)
	{
	print("[SQLite] Table houses do not match the declared size in run time memory!");
	GameModeExit();
	}
}
*/

public CreateTableForPlayers() // do not use in account system!
{
xdb_query(ReunionDB,"CREATE TABLE players (id int, name varchar, ip varchar, pass varchar, email varchar, cdate varchar, llogin varchar, gang int, lvl int, xp bigint, money bigint, bmoney bigint, deaths int, kills int, jailed int, muted bigint, x varchar, y varchar, z varchar, stat int, weap varchar, skill varchar, skin int, vip int, car int, packages int, rxp int, train1 int, train2 int, train3 int, train4 int, attachments varchar, eventban int, typespawn int)"); //10
return 1;
}

public CreateTableForCars() // do not use in account system!
{
xdb_query(ReunionDB,"CREATE TABLE cars (id int, name varchar, model int, col1 int, col2 int, pjob int, x varchar, y varchar, z varchar, a varchar, t0 int, t1 int, t2 int, t3 int, t4 int, t5 int, t6 int, t7 int, t8 int, t9 int, t10 int, t11 int, t12 int, t13 int)");
return 1;
}

/*
public CreateTableForHouses() // do not use in account system!
{
xdb_query(ReunionDB,"CREATE TABLE houses (id int, name varchar, cost bigint, gang varchar, gsqlid int, upkeep bigint, upkeepl bigint, buyout bigint, color varchar)");
// create static data lines:
new query[256];
for (new id=0;id<MAX_HOUSES;id++)
{
format(query, sizeof(query), "INSERT INTO houses ( id, name, cost, gang, gsqlid, upkeep, upkeepl, buyout, color ) VALUES ( %d, '%s', %d,'%s', %d, %d, %d, %d, '%d')", Houses[id][Houses_SQLID], Houses[id][Houses_Name], Houses[id][Houses_Cost], Houses[id][Houses_Gang], Houses[id][Houses_GangSQLID], Houses[id][Houses_UpKeep], Houses[id][Houses_UpKeepLeft], Houses[id][Houses_Buyout], COLOUR_PLAYER );
xdb_query(ReunionDB,query);
set(query,nullstr);
}
return 1;
}
*/

public CreateTableForGangs() // do not use in account system!
{
new query[600];
format(query,sizeof(query),"CREATE TABLE gangs (id int, name varchar, color varchar, kills bigint, score bigint, bank bigint, m0 int, m1 int, m2 int, m3 int, m4 int, m5 int, m6 int, m7 int, m8 int, m9 int, m10 int, m11 int, m12 int, m13 int, m14 int, m15 int, m16 int, m17 int, m18 int, m19 int, m20 int, m21 int, m22 int, m23 int, m24 int, m25 int, m26 int, m27 int, m28 int, m29 int, level bigint, xp bigint, tag varchar, zam int)");
xdb_query(ReunionDB,query); //10
return 1;
}

public CreateGraph() // do not use in account system!
{
new File:GraphFile;
new DBResult:getmax, DBResult:getcdata;
new var[24], query[128], day[32], month[32], lday[32], lmonth[32];
new maxid, count;
getmax = xdb_query(ReunionDB,"SELECT max(id) FROM players");
db_get_field(getmax, 0 , var, sizeof(var));
if(!strlen(var))
{
WriteSQLLog("Failure!!! Can't get data!");
return 1;
}
maxid = strval(var);

if (fexist("GTO/graph.txt"))
		{
	        GraphFile = fopen("GTO/graph.txt", io_append);
		}
		else
		{
	        GraphFile = fopen("GTO/graph.txt", io_write);
		}

for(new i=1;i<maxid+1;i++)
{
new idx = 0;
format(query,sizeof(query),"SELECT * FROM players WHERE id = %d LIMIT 1",i);
getcdata = xdb_query(ReunionDB,query);
if(!db_num_rows(getcdata)){continue;}

db_get_field(getcdata, 5, var, sizeof(var)); // cdate

set(day,strcharsplit(var, idx,strchar(" ")));
set(month,strcharsplit(var, idx,strchar(" ")));

if(strcomp(day,lday,true)==0 || strcomp(month,lmonth,true)==0)
{
format(query,sizeof(query),"%s %s	%d",lday,lmonth,count);
count = 0;

fwrite_utf8(GraphFile, query);
fwrite_utf8(GraphFile, "\r\n");
}

count++;
set(lday,day);
set(lmonth,month);
}
fclose(GraphFile);
return 1;
}

GetFreeSQLID(tablename[])
{
new DBResult:checkempty;
new DBResult:getfree;
new var[24];
new freeid;
new query[128], tmp[128];

format(query,sizeof(query),"SELECT id FROM %s",tablename);
checkempty = xdb_query(ReunionDB,query);
if(!db_num_rows(checkempty))
{freeid = 1;} else {

format(query,sizeof(query),"SELECT max(id) FROM %s",tablename);
getfree = xdb_query(ReunionDB,query);
db_get_field(getfree, 0 , var, sizeof(var));
if(!strlen(var))
{
format(tmp,sizeof(tmp),"Connection failure or empty table [%s]... ",tablename);
WriteSQLLog(tmp);

return 1;
}
freeid = strval(var) + 1;
}
return freeid;
}

player_save_db_sql(playerid)
{
if(PlayerSQLID[playerid] == 0) {return;}

new squery[512];

new tempx[16];
new tempy[16];
new tempz[16];
new Float:playerx, Float:playery, Float:playerz;
GetPlayerPos(playerid,playerx,playery,playerz);
if (playerz > 900)
{
playerx=0;
playery=0;
playerz=0;
}
format(tempx,sizeof(tempx),"%f",playerx);
format(tempy,sizeof(tempy),"%f",playery);
format(tempz,sizeof(tempz),"%f",playerz);

if(Player[playerid][Deaths] > 9999) {Player[playerid][Deaths] = 9999;}
if(Player[playerid][Kills] > 9999) {Player[playerid][Kills] = 9999;}
if(Player[playerid][Packages] > 9999) {Player[playerid][Packages] = 9999;}

format(squery,sizeof(squery), "UPDATE players SET gang=%d, lvl=%d, xp=%d, money=%d, bmoney=%d, deaths=%d, kills=%d, jailed=%d, muted=%d WHERE id=%d", PlayerGangSQLID[playerid], Player[playerid][Level], Player[playerid][XP], Player[playerid][Money], Player[playerid][Bank], Player[playerid][Deaths],Player[playerid][Kills], Player[playerid][Jailed],Player[playerid][Muted],PlayerSQLID[playerid]);
xdb_query(ReunionDB,squery);

format(squery,sizeof(squery), "UPDATE players SET x='%s', y='%s', z='%s', stat=%d, vip=%d, car=%d, packages=%d WHERE id=%d",tempx,tempy,tempz, Player[playerid][Status], Player[playerid][Vip], Player[playerid][Car], Player[playerid][Packages], PlayerSQLID[playerid]);
xdb_query(ReunionDB,squery);

format(squery,sizeof(squery), "UPDATE players SET weap='%s', skill='%s', skin=%d, rxp=%d, train1=%d, train2=%d, train3=%d, train4=%d WHERE id=%d",CreateWeaponDBString(playerid), CreateWeaponSkillDBString(playerid),Player[playerid][SkinModel],Player[playerid][RXP],Player[playerid][train1],Player[playerid][train2],Player[playerid][train3],Player[playerid][train4],PlayerSQLID[playerid]);
xdb_query(ReunionDB,squery);

SaveAttachmentsObjects(playerid);
SaveEventBan(playerid);
SaveTypeSpawn(playerid);

return;
}

player_create_db_sql(playerid)
{
player_save_db_sql(playerid);
}

account_save_db_sql(playerid)
{
if(PlayerSQLID[playerid] == 0) {return;}
new query[255];

new name[MAX_PLAYER_NAME];
GetPlayerName(playerid, name, sizeof(name));
UnsetTag(name);

format(query, sizeof(query), "UPDATE players SET name='%s', ip='%s', email='%s', cdate='%s', llogin='%s' WHERE id=%d", name,PlayerIP[playerid],PlayerEmail[playerid],PlayerCreationDate[playerid],PlayerLastLogin[playerid],PlayerSQLID[playerid]);

xdb_query(ReunionDB,query);
return;
}

account_login_db_sql(playerid,password[])
{
printf("pass = %s | playerid = %d", password, playerid ); // мдешим пароль
new DBResult:RES;
new query[128];
new querytext[256];
new pl_name[MAX_PLAYER_NAME];
GetPlayerName(playerid, pl_name, sizeof(pl_name));

format(query,sizeof(query),
    "SELECT id, pass, email, cdate FROM players WHERE name = '%s' LIMIT 1", pl_name );
RES = xdb_query(ReunionDB,query);

if(!db_num_rows(RES)) // Если не нашли, то ищем без тега
{
    db_free_result(RES);
    UnsetTag(pl_name);
    format(query,sizeof(query),
        "SELECT id, pass, email, cdate FROM players WHERE name = '%s' LIMIT 1", pl_name );
    RES = xdb_query(ReunionDB,query);

    if(!db_num_rows(RES))
    {
        SendClientMessage(playerid,COLOUR_RED,  lang_texts[1][3] );
        return 0;
    } else {
    	SendClientMessage(playerid,COLOUR_RED, "Кажется вы используете никнейм с [тегом], согласно нашим правилам такие никнеймы недопустимы.");
		format(querytext, sizeof(querytext), "При следующем входе, исправьте имя в клиенте на %s", pl_name);
		SendClientMessage(playerid,COLOUR_RED, querytext);
    }
}
new var[32];
db_get_field(RES, 1, var, sizeof(var));

new dbpassword[32];
set(dbpassword,var);

set(password,encryptbykey(password,ENCRYPTION_KEY_SQL));

if (!equal(password, dbpassword,false))
{
new logstring[256];
format(logstring, sizeof (logstring), "player_login: failed: incorrect password ID:%d NAME:%s P:%s",playerid,oGetPlayerName(playerid),password);
WriteLog(logstring);
			
SendClientMessage(playerid,COLOUR_RED,  lang_texts[1][6] );
SendClientMessage(playerid,COLOUR_RED,  lang_texts[1][7] );
KickPlayer(playerid,"Неверный Пароль"); // kick them
return false;
}
db_get_field(RES, 0, var, sizeof(var));
PlayerSQLID[playerid] = strval(var);

db_get_field(RES, 2, var, sizeof(var));
set(PlayerEmail[playerid],var);

db_get_field(RES, 3, var, sizeof(var));
set(PlayerCreationDate[playerid],var);

set(PlayerLastLogin[playerid],oNow());
set(PlayerPassword[playerid],password);

GetPlayerIp(playerid, var,sizeof(var));
set(PlayerIP[playerid],var);

PlayerRegistered[playerid] = 1;
return true;
}

player_load_db_sql(playerid)
{
if(PlayerSQLID[playerid] == 0) {return;}
new DBResult:RES;
new query[128];
format(query,sizeof(query),"SELECT * FROM players WHERE id = %d LIMIT 1",PlayerSQLID[playerid]);
RES = xdb_query(ReunionDB,query);

if (!db_num_rows(RES))
{
return;
}
new llvar[255];
new lvar[64];
new var[24];

//---GANG------------------------
PlayerGangID[playerid] = -1;
PlayerGangSQLID[playerid] = 0;
set(PlayerGangName[playerid],nullstr);
set(PlayerGangTag[playerid],nullstr);

db_get_field(RES, 7, var, sizeof(var));
PlayerGangSQLID[playerid] = strval(var);

if(PlayerGangSQLID[playerid] > 0) {
PlayerGangID[playerid] = GangLoad(PlayerGangSQLID[playerid]);
GangMemberLogin(PlayerGangID[playerid], playerid);
}
//---END-GANG--------------------

db_get_field(RES, 8, var, sizeof(var));
Player[playerid][Level] = strval(var);

db_get_field(RES, 9, var, sizeof(var));
Player[playerid][XP] = strval(var);

db_get_field(RES, 10, var, sizeof(var));
oSetPlayerMoney(playerid,strval(var));

db_get_field(RES, 11, var, sizeof(var));
Player[playerid][Bank] = strval(var);
	
db_get_field(RES, 12, var, sizeof(var));
Player[playerid][Deaths] = strval(var);

db_get_field(RES, 13, var, sizeof(var));
Player[playerid][Kills] = strval(var);

db_get_field(RES, 14, var, sizeof(var));
Player[playerid][Jailed] = strval(var);

db_get_field(RES, 15, var, sizeof(var));
Player[playerid][Muted] = strval(var);

db_get_field(RES, 16, var, sizeof(var));
PlayerSpawn[playerid][Coord_X] = floatstr(var);

db_get_field(RES, 17, var, sizeof(var));
PlayerSpawn[playerid][Coord_Y] = floatstr(var);

db_get_field(RES, 18, var, sizeof(var));
PlayerSpawn[playerid][Coord_Z] = floatstr(var);
		
db_get_field(RES, 19, var, sizeof(var));
Player[playerid][Status] = strval(var);

new wepstr[MAX_STRING];
db_get_field(RES, 20, llvar, sizeof(llvar));
set(wepstr,llvar);
SetWeaponsFromDBString(playerid,wepstr);
		
new skillstr[MAX_STRING];
db_get_field(RES, 21, lvar, sizeof(lvar));
set(skillstr,lvar);
SetWeaponsSkillFromDBString(playerid,skillstr);

db_get_field(RES, 22, var, sizeof(var));
Player[playerid][SkinModel] = strval(var);

db_get_field(RES, 23, var, sizeof(var));
Player[playerid][Vip] = strval(var);

db_get_field(RES, 24, var, sizeof(var));
Player[playerid][Car] = strval(var);

db_get_field(RES, 25, var, sizeof(var));
Player[playerid][Packages] = strval(var);

db_get_field(RES, 26, var, sizeof(var));
Player[playerid][RXP] = strval(var);

db_get_field(RES, 27, var, sizeof(var));
Player[playerid][train1] = strval(var);

db_get_field(RES, 28, var, sizeof(var));
Player[playerid][train2] = strval(var);

db_get_field(RES, 29, var, sizeof(var));
Player[playerid][train3] = strval(var);

db_get_field(RES, 30, var, sizeof(var));
Player[playerid][train4] = strval(var);

//
new attachstr[1100];
db_get_field(RES, 31, attachstr, sizeof(attachstr));
LoadAttachmentsObjects(playerid,attachstr);
//

db_get_field(RES, 32, var, sizeof(var));
Player[playerid][EventBan] = strval(var);

db_get_field(RES, 33, var, sizeof(var));
Player[playerid][TypeSpawn] = strval(var);

UpdatePlayerScore(playerid);
}

public UpdatePlayerVarInt(playerid, fieldname[], integer)
{
if(playerid < 0 || playerid >= MAX_PLAYERS) {return 0;}
if(PlayerSQLID[playerid] == 0) {return 0;}
if(!IsPlayerRegistered(playerid)) {return 0;}

new query[64];
format(query,sizeof(query), "UPDATE players SET %s=%d WHERE id=%d", fieldname, integer, PlayerSQLID[playerid]);
xdb_query(ReunionDB,query);

return 1;
}

public SendClientQuery(playerid,query[])
{
new len = strlen(query);
if(!len || len < 10) {SendClientMessage(playerid, 0xFFFFFFAA, "Слишком короткий запрос!"); return 0;}
if(len > 255) {SendClientMessage(playerid, 0xFFFFFFAA, "Слишком длинный запрос!"); return 0;}
new x;
for(new i=0;i<len;i++)
{
if(query[i] == 39) {x++;}
}
if(x%2 != 0) {SendClientMessage(playerid, 0xFFFFFFAA, "Ошибка запроса!"); return 0;}
xdb_query(ReunionDB,query);
return 1;
}

public PlayerSQLID2ID(sqlid)
{
new playerid = -1;
for(new i=0;i<MAX_PLAYERS;i++)
{
if(!IsPlayerConnected(i)) {continue;}
if(PlayerSQLID[i] == sqlid) {playerid = i; break;}
}
return playerid;
}

LoadAttachmentsObjects(playerid,dbstring[])
{
	new idx=0;
	for (new i=0;i<MAX_PLAYER_ATTACHED_OBJECTS;i++)
	{
		PlayerAttachmentsObj[playerid][i][amodelid]=strval(strcharsplit(dbstring,idx,strchar("|")));
		PlayerAttachmentsObj[playerid][i][aboneid]=strval(strcharsplit(dbstring,idx,strchar("|")));
		PlayerAttachmentsObj[playerid][i][aOffsetX]=floatstr(strcharsplit(dbstring,idx,strchar("|")));
		PlayerAttachmentsObj[playerid][i][aOffsetY]=floatstr(strcharsplit(dbstring,idx,strchar("|")));
		PlayerAttachmentsObj[playerid][i][aOffsetZ]=floatstr(strcharsplit(dbstring,idx,strchar("|")));
		PlayerAttachmentsObj[playerid][i][aRotX]=floatstr(strcharsplit(dbstring,idx,strchar("|")));
		PlayerAttachmentsObj[playerid][i][aRotY]=floatstr(strcharsplit(dbstring,idx,strchar("|")));
		PlayerAttachmentsObj[playerid][i][aRotZ]=floatstr(strcharsplit(dbstring,idx,strchar("|")));
		PlayerAttachmentsObj[playerid][i][aScaleX]=floatstr(strcharsplit(dbstring,idx,strchar("|")));
		PlayerAttachmentsObj[playerid][i][aScaleY]=floatstr(strcharsplit(dbstring,idx,strchar("|")));
		PlayerAttachmentsObj[playerid][i][aScaleZ]=floatstr(strcharsplit(dbstring,idx,strchar("/")));
	}
}

SaveAttachmentsObjects(playerid)
{
	new attachstr[1100];
	for(new i=0;i<MAX_PLAYER_ATTACHED_OBJECTS;i++)
	{
		format(attachstr,sizeof(attachstr),"%d|%d|%.3f|%.3f|%.3f|%.3f|%.3f|%.3f|%.3f|%.3f|%.3f/%s",
		PlayerAttachmentsObj[playerid][i][amodelid],PlayerAttachmentsObj[playerid][i][aboneid],PlayerAttachmentsObj[playerid][i][aOffsetX],PlayerAttachmentsObj[playerid][i][aOffsetY],PlayerAttachmentsObj[playerid][i][aOffsetZ],PlayerAttachmentsObj[playerid][i][aRotX],PlayerAttachmentsObj[playerid][i][aRotY],PlayerAttachmentsObj[playerid][i][aRotZ],PlayerAttachmentsObj[playerid][i][aScaleX],PlayerAttachmentsObj[playerid][i][aScaleY],PlayerAttachmentsObj[playerid][i][aScaleZ],attachstr);
	}
	format(attachstr, sizeof(attachstr), "UPDATE players SET attachments='%s' WHERE id=%d", attachstr, PlayerSQLID[playerid]);
	xdb_query(ReunionDB,attachstr);
}

SaveEventBan(playerid)
{
	new attachstr[1100];
	format(attachstr, sizeof(attachstr), "UPDATE players SET eventban=%d WHERE id=%d", Player[playerid][EventBan], PlayerSQLID[playerid]);
	xdb_query(ReunionDB,attachstr);
}

SaveTypeSpawn(playerid)
{
	new attachstr[1100];
	format(attachstr, sizeof(attachstr), "UPDATE players SET typespawn=%d WHERE id=%d", Player[playerid][TypeSpawn], PlayerSQLID[playerid]);
	xdb_query(ReunionDB,attachstr);
}

SetAttachmentsObjectsForPlayer(playerid)
{
	for (new i=0;i<MAX_PLAYER_ATTACHED_OBJECTS;i++)
	{
		if(PlayerAttachmentsObj[playerid][i][amodelid] > 0)
			SetPlayerAttachedObject(playerid,i,
			PlayerAttachmentsObj[playerid][i][amodelid],PlayerAttachmentsObj[playerid][i][aboneid],PlayerAttachmentsObj[playerid][i][aOffsetX],PlayerAttachmentsObj[playerid][i][aOffsetY],PlayerAttachmentsObj[playerid][i][aOffsetZ],PlayerAttachmentsObj[playerid][i][aRotX],PlayerAttachmentsObj[playerid][i][aRotY],PlayerAttachmentsObj[playerid][i][aRotZ],PlayerAttachmentsObj[playerid][i][aScaleX],PlayerAttachmentsObj[playerid][i][aScaleY],PlayerAttachmentsObj[playerid][i][aScaleZ]);
	}
}

