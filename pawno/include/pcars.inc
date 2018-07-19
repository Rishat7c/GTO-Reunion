#if defined _pcars_included
#endinput
#endif
#define _pcars_included
#pragma library pcars

#include <a_samp>

#define CARMOD_MAX 14
#define MyCARRespTime 300

#define NEON_COLORS 6

forward LoadPlayerCarDB(playerid);
forward SavePlayerCar(playerid);
forward SavePlayerCarDB(playerid);
forward ChangePlayerCarColor(playerid,color1,color2);
forward LoadPlayerCar(playerid);
forward RespawnPlayerCar(playerid);
forward UnloadPlayerCar(playerid);
forward SetPlayerCarName(playerid,name[]);
forward CarsCommandHandler(playerid,text[]);
forward PlayerCarCheckSpawn(vehicleid);
forward playercar_OnPlayerConnect(playerid);
forward NeonOn(playerid,type,manual,Float:offx,Float:offy,Float:offz);
forward RegisterPCar(playerid);
//forward PlayerCarCheckStream(vehicleid,forplayerid);

enum p_CarInfo { sqlid, pcarname[32], model, c1, c2, pjob, vid, Float:CX, Float:CY, Float:CZ, Float:CA, locked, neon, neont}
new PlCar[MAX_PLAYERS][p_CarInfo];
new PlCarT[MAX_PLAYERS][CARMOD_MAX];
new Text3D:Cars3DT[MAX_PLAYERS];
new NeonObjects[NEON_COLORS] = {18647,18648,18649,18650,18651,18652};

enum model_neon_inf {
model, Float:offsetx, Float:offsety, Float:offsetz }

new NeonAllowedMdels[][model_neon_inf] = {
{V_BFINJECT,	0.0,	0.35,	-0.4},
{V_JESTER,		0.0,	0.1,	-0.5},
{V_URANUS,		0.0,	0.1,	-0.44},
{V_TURISMO,		0.0,	-0.15,	-0.56},
{V_SULTAN,		0.0,	0.0,	-0.53},
{V_INFERNUS,	0.0,	0.1,	-0.65},
{V_BULLET,		0.0,	0.0,	-0.45},
{V_ELEGY,		0.0,	0.1,	-0.53},
{V_SLAMVAN,		0.0,	0.0,	-0.61},
{V_HUNTLEY,		0.0,	0.0,	-0.53},
{V_ALPHA,		0.0,	0.0,	-0.615},
{V_BANSHEE,		0.0,	0.0,	-0.5},
{V_FLASH,		0.0,	0.1,	-0.46},
{V_RDTRAIN,		0.0,	-1.8,	-1.62},
{V_SUPERGT,		0.0,	-0.1,	-0.56}
};

IsValidColor(color)
{
if(color < 0) {return 0;}
if(color > 255) {return 0;}
return 1;
}

/*
forward SQLCARSTimer();
new NXX = -1;
public SQLCARSTimer()
{
if(NXX == -1) {return 0;}
if(NXX > 200){return 0;}
NXX++;
PlCar[90][sqlid] = 0;
Player[90][Car] = 0;
set(PlCar[90][pcarname],"Test Car Name");
PlCar[90][vid] = random(900);
PlCar[90][model] = GetVehicleModel(PlCar[90][vid]);
PlCar[90][c1] = 1;
PlCar[90][c2] = 1;
PlCar[90][pjob] = 0;
GetVehiclePos(PlCar[90][vid], PlCar[90][CX], PlCar[90][CY], PlCar[90][CZ]);
GetVehicleZAngle(PlCar[90][vid], PlCar[90][CA]);
for(new i=0;i<CARMOD_MAX;i++)
{
PlCarT[90][i] = random(9999);
}
SavePlayerCarDB(90);
printf("Save RUN %d",PlCar[90][sqlid]);
return 1;
}
*/
/*
new BadCarList[] = {
448, 461, 462, 463, 468, 521, 522, 523, 581, 586, 481, 509, 510, // moto and bycycles
430, 446, 452, 453, 454, 472, 473, 484, 493, 595, // boats
417, 425, 447, 465, 469, 487, 488, 497, 501, 548, 563, // heli
406, 444, 556, 557, 573, // monster truck
460, 464, 476, 511, 512, 513, 519, 520, 539, 553, 577, 592, 593, // planes
471, // quad
432, // tank
}; // old list before use MakeBadlist
*/

new BadCarList[] = {
//403,
406,407,408,414,416,417,423,427,428,430,431,433,435,437,441,443,444,446,448,449,450, // rhino 432, appach 425, vorobei 447
452,453,454,455,456,457,460,464,465,469,472,473,484,485,486,487,488,490,493,497,498,499,501,511, // rustler 476
512,513,//514,515,
519,524,525,528,530,531,532,537,538,539,544,548,552,553,556,557,563,564,569,570, // hydra 520
572,573,574,577,578,582,583,584,588,590,591,592,593,594,595,596,597,598,599,601,606,607,608,609,610,
611
}; // 101 vehicles OMG o_O

GetCarNeonID(modelid)
{
if(modelid == -1) {return -1;}
for(new i=0;i<sizeof(NeonAllowedMdels);i++)
{if(modelid == NeonAllowedMdels[i][model]) {return i;}}
return -1;
}

IsCarAllowedForSave(playerid,modelid)
{
if(modelid == -1) {return 0;}
if(IsPlayerAdmin(playerid)) {return 1;}
for(new i=0;i<sizeof(BadCarList);i++)
{
if(modelid == BadCarList[i]) {return 0;}}
return 1;
}

// ------------------------ Usable Utilites --------------------------
/*
enum parking_info {
places,
Float:width,
Float:dir,
Float:center,
Float:first,
Float:height
}

new Parking[2][parking_info] = {
{27,3.5743,270.000,2302.7361,1405.0840,10.823},
{27,3.5743,90.000,2332.4849,1405.0840,10.823}
};

TestParking()
{
new Float:X, Float:Y, Float:Z, Float:A;
for(new i = 0;i<50;i++)
{
if(i < Parking[0][places])
{ X = Parking[0][center]; Y = Parking[0][first] + Parking[0][width]*i; Z = Parking[0][height]; A = Parking[0][dir];}
else if(i < Parking[0][places]+Parking[1][places])
{ X = Parking[1][center]; Y = Parking[1][first] + Parking[1][width]*(i-Parking[0][places]); Z = Parking[1][height]; A = Parking[1][dir];}
CreateVehicle(V_TURISMO,X,Y,Z,A,-1,-1,-1);
}
}
*/
/*
new startmodel = 400;
new endmodel = 611;
new counterx = 400;
new currentid = -1;
new Float:aax, Float:aay, Float:aaz;

MakeBadList(playerid)
{
new temp[128];
if(aax == 0) {GetPlayerPos(playerid,aax,aay,aaz); aax = aax + 15.000;}
if(currentid != -1) {DestroyVehicle(currentid);}
if(counterx >= startmodel && counterx <= endmodel)
{
currentid = CreateVehicle(counterx,aax,aay,aaz,0.000,-1,-1,-1);
format(temp,sizeof(temp),"Эта машина?\nМодель: %s",GetVehicleName(counterx));
ShowPlayerDialog(playerid,70,1,"???",temp,"Плохая!","Хорошая!");
return 1;
}
SendClientMessage(playerid,COLOUR_GREEN, "Окончено!");
return 1;
}
*/
// ------------------------ Player Cars --------------------------

SetDefaultPlayerCarName(playerid)
{
new tmp[128];
format(tmp,sizeof(tmp),"%s-s car",oGetPlayerName(playerid));
set(PlCar[playerid][pcarname],tmp);
return 1;
}

public LoadPlayerCarDB(playerid)
{

new DBResult:CRES;
new query[128];

format(query,sizeof(query),"SELECT * FROM cars WHERE id = %d LIMIT 1",PlCar[playerid][sqlid]);
CRES = xdb_query(ReunionDB,query);
if (!db_num_rows(CRES))
{
SendClientMessage(playerid,COLOUR_GREEN, "Ошибка! Машина с таким ид не найдена в базе данных!");
return 0;
}
new var[32];
db_get_field(CRES, 1, var, sizeof(var)); set(PlCar[playerid][pcarname],var); set(var,nullstr);
db_get_field(CRES, 2, var, sizeof(var)); PlCar[playerid][model] = strval(var); set(var,nullstr);
db_get_field(CRES, 3, var, sizeof(var)); PlCar[playerid][c1] = strval(var); set(var,nullstr);
db_get_field(CRES, 4, var, sizeof(var)); PlCar[playerid][c2] = strval(var); set(var,nullstr);
db_get_field(CRES, 5, var, sizeof(var)); PlCar[playerid][pjob] = strval(var); set(var,nullstr);

db_get_field(CRES, 6, var, sizeof(var)); PlCar[playerid][CX] = floatstr(var); set(var,nullstr);
db_get_field(CRES, 7, var, sizeof(var)); PlCar[playerid][CY] = floatstr(var); set(var,nullstr);
db_get_field(CRES, 8, var, sizeof(var)); PlCar[playerid][CZ] = floatstr(var); set(var,nullstr);
db_get_field(CRES, 9, var, sizeof(var)); PlCar[playerid][CA] = floatstr(var); set(var,nullstr);

for(new i=0;i<CARMOD_MAX;i++)
{ db_get_field(CRES, i+10, var, sizeof(var)); PlCarT[playerid][i] = strval(var); }

return 1;
}

// --------------------------------------------------------------

public SavePlayerCar(playerid)
{
if(!Player[playerid][Vip]) {
SendClientMessage(playerid,COLOUR_GREEN, "Нет прав на выполнение!");
return 0;}
if(!IsPlayerInAnyVehicle(playerid)) {
SendClientMessage(playerid,COLOUR_GREEN, "Вы должны быть в машине!");
return 0;}
if(GetPlayerVehicleSeat(playerid) != 0) {
SendClientMessage(playerid,COLOUR_GREEN, "Вы должны быть водителем!");
return 0;}

new vehid, nowmod, oldmod;
vehid = GetPlayerVehicleID(playerid);

GetVehiclePos(vehid, PlCar[playerid][CX], PlCar[playerid][CY], PlCar[playerid][CZ]);
PlCar[playerid][CZ] = PlCar[playerid][CZ] + 0.15;
GetVehicleZAngle(vehid, PlCar[playerid][CA]);

if (PlCar[playerid][CZ] > 800)
{
SendClientMessage(playerid,COLOUR_GREEN, "Ваша машина слишком высоко, или находится в интерьере!");
return 0;}

nowmod = GetVehicleModel(vehid);

if(!IsCarAllowedForSave(playerid,nowmod))
{SendClientMessage(playerid,COLOUR_GREEN, "Вы не можете сохранить машину данного типа!"); return 0;}

if(nowmod == 432 || nowmod == 425 || nowmod == 447 || nowmod == 476 || nowmod == 520)
{
	if(Player[playerid][Vip] < 2)
	{
		SendClientMessage(playerid,COLOUR_GREEN, "Сохранение военного транспорта доступна на 2-ом уровне VIP'a!");
		return 1;
	}
}

oldmod = PlCar[playerid][model];
PlCar[playerid][model] = nowmod;
for(new i = 0;i<CARMOD_MAX;i++) { PlCarT[playerid][i] = GetVehicleComponentInSlot(vehid,i); }

if(vehid == PlCar[playerid][vid])
{

if(PlCar[playerid][neon] != -1)
{
DestroyObject(PlCar[playerid][neon]);
}

DestroyVehicle(PlCar[playerid][vid]);
PlCar[playerid][vid] = CreateVehicle(PlCar[playerid][model],PlCar[playerid][CX],PlCar[playerid][CY],PlCar[playerid][CZ],PlCar[playerid][CA],PlCar[playerid][c1],PlCar[playerid][c2],MyCARRespTime);
for(new i=0;i<CARMOD_MAX;i++)
{
if(PlCarT[playerid][i] > 0) { AddVehicleComponent(PlCar[playerid][vid], PlCarT[playerid][i]); }
}
ChangeVehiclePaintjob(PlCar[playerid][vid], PlCar[playerid][pjob]);
oPutPlayerInVehicle(playerid,PlCar[playerid][vid],0);
Attach3DTextLabelToVehicle(Cars3DT[playerid], PlCar[playerid][vid], 0.000, 0.000, 1.000);

if(PlCar[playerid][neon] != -1)
{
new allow = GetCarNeonID( PlCar[playerid][model] );
	if(allow != -1)
	{
		PlCar[playerid][neon] = CreateObject(NeonObjects[ PlCar[playerid][neont] ],0.00,0.00,10.000,0.00,0.00,0.00);
		//AttachObjectToVehicle(PlCar[playerid][neon], PlCar[playerid][vid], 0.00, 0.00, -0.50, 0.00, 0.00, 0.00);
		AttachObjectToVehicle(PlCar[playerid][neon], PlCar[playerid][vid], NeonAllowedMdels[allow][offsetx], NeonAllowedMdels[allow][offsety], NeonAllowedMdels[allow][offsetz], 0.00, 0.00, 0.00);
	}
}

}
else if(vehid != PlCar[playerid][vid])
{
for(new i=0;i<MAX_PLAYERS;i++)
{
if(PlCar[i][vid] == -1) {continue;}
if(PlCar[i][vid] == vehid && i != playerid) {SendClientMessage(playerid,COLOUR_GREEN, "Это не ваша машина!"); return 0;}
}
new xpar = 0;
new msg[256];
if(PlCar[playerid][vid] != -1)
{
xpar = 1;

if(PlCar[playerid][neon] != -1)
{
DestroyObject(PlCar[playerid][neon]);
PlCar[playerid][neon] = -1;
}

DestroyVehicle(PlCar[playerid][vid]);
format(msg,sizeof(msg),"Ваша старая машина (%s | id %d) была удалена!",GetVehicleName(oldmod),PlCar[playerid][vid]);
SendClientMessage(playerid,COLOUR_GREEN,msg);
PlCar[playerid][c1] = 1;
PlCar[playerid][c2] = 1;
PlCar[playerid][pjob] = 0;
PlCar[playerid][vid] = -1;
SendClientMessage(playerid,COLOUR_GREEN, "Параметры цвета и граффити для вашей новой машины были изменены на стандартные!");
}
if(PlCar[playerid][vid] == -1)
{
SetVehicleToRespawn(vehid);
PlCar[playerid][vid] = CreateVehicle(PlCar[playerid][model],PlCar[playerid][CX],PlCar[playerid][CY],PlCar[playerid][CZ],PlCar[playerid][CA],PlCar[playerid][c1],PlCar[playerid][c2],MyCARRespTime);
for(new i=0;i<CARMOD_MAX;i++)
{
if(PlCarT[playerid][i] > 0) { AddVehicleComponent(PlCar[playerid][vid], PlCarT[playerid][i]); }
}
oPutPlayerInVehicle(playerid,PlCar[playerid][vid],0);
if(!xpar)
{
if(Player[playerid][Car])
{
SendClientMessage(playerid,COLOUR_GREEN,"Параметры вашей старой машины были заменены на новые в базе данных сервера!");
}
SetDefaultPlayerCarName(playerid);
Cars3DT[playerid] = Create3DTextLabel(PlCar[playerid][pcarname], 0xFFFFFFFF, 0.000, 0.000, 10000.000, 50.000, 0, 0);
}
Attach3DTextLabelToVehicle(Cars3DT[playerid], PlCar[playerid][vid], 0.000, 0.000, 1.000);
Speed_UpdateVehName(PlCar[playerid][vid], PlCar[playerid][pcarname]);
}
}

SavePlayerCarDB(playerid);

new msg[128];
format(msg,sizeof(msg),"Машина сохранена | model %s (%d) | id %d",GetVehicleName(PlCar[playerid][model]),PlCar[playerid][model],PlCar[playerid][vid]);
SendClientMessage(playerid,COLOUR_GREEN, msg);
return 1;
}

// --------------------------------------------------------------

public SavePlayerCarDB(playerid)
{
new query[MAX_STRING];
new p = playerid;

PlCar[p][sqlid] = Player[p][Car];
if(!PlCar[p][sqlid])
{
PlCar[p][sqlid] = GetFreeSQLID("cars");
Player[p][Car] = PlCar[p][sqlid];
format(query, sizeof(query), "INSERT INTO cars ( id ) VALUES ( %d )", PlCar[p][sqlid]);
xdb_query(ReunionDB,query);
}

new tempx[16];
new tempy[16];
new tempz[16];
new tempa[16];

if (PlCar[p][CZ] > 800)
{
PlCar[p][CX] = 0.000;
PlCar[p][CY] = 0.000;
PlCar[p][CZ] = 0.000;
PlCar[p][CA] = 0.000;
}

format(tempx,sizeof(tempx),"%.3f",PlCar[p][CX]);
format(tempy,sizeof(tempy),"%.3f",PlCar[p][CY]);
format(tempz,sizeof(tempz),"%.3f",PlCar[p][CZ]);
format(tempa,sizeof(tempa),"%.3f",PlCar[p][CA]);

if(!strlen(PlCar[p][pcarname])) {SetDefaultPlayerCarName(p);}

format(query,sizeof(query), "UPDATE cars SET name='%s', model=%d, col1=%d, col2=%d, pjob=%d, x='%s', y='%s', z='%s', a='%s' WHERE id=%d",PlCar[p][pcarname],PlCar[p][model],PlCar[p][c1],PlCar[p][c2],PlCar[p][pjob],tempx,tempy,tempz,tempa,PlCar[p][sqlid]);
xdb_query(ReunionDB,query); // 1 part pishem v bazu
format(query,sizeof(query), "UPDATE cars SET t0=%d, t1=%d, t2=%d, t3=%d, t4=%d, t5=%d, t6=%d, t7=%d, t8=%d, t9=%d, t10=%d, t11=%d, t12=%d, t13=%d WHERE id=%d",PlCarT[p][0],PlCarT[p][1],PlCarT[p][2],PlCarT[p][3],PlCarT[p][4],PlCarT[p][5],PlCarT[p][6],PlCarT[p][7],PlCarT[p][8],PlCarT[p][9],PlCarT[p][10],PlCarT[p][11],PlCarT[p][12],PlCarT[p][13],PlCar[p][sqlid]);
xdb_query(ReunionDB,query); // 2 part pishem v bazu

return 1;
}

// --------------------------------------------------------------

public NeonOn(playerid,type,manual,Float:offx,Float:offy,Float:offz)
{
if(!Player[playerid][Vip]) {
SendClientMessage(playerid,COLOUR_GREEN, "Нет прав на выполнение!");
return 0;} // net prav
if(PlCar[playerid][sqlid] == 0) {
SendClientMessage(playerid,COLOUR_GREEN, "У вас нет машины!");
return 0;} // net u vas mashini
if(PlCar[playerid][vid] == -1) {
SendClientMessage(playerid,COLOUR_GREEN, "Ваша машина еще не загружена, введите '/mycar load'!");
return 0;}
if(type < 0 || type >= NEON_COLORS) {
SendClientMessage(playerid,COLOUR_GREEN, "Неверный цвет неона, используйте 0 - 5");
return 0;}

new allow = -1;

if(manual == 0) //NOT admins mod
{
allow = GetCarNeonID(PlCar[playerid][model]);
if(allow == -1) {
SendClientMessage(playerid,COLOUR_GREEN, "Неон для этой модели недоступен (или временно недоступен)");
return 0;}
offx = NeonAllowedMdels[allow][offsetx];
offy = NeonAllowedMdels[allow][offsety];
offz = NeonAllowedMdels[allow][offsetz];
}

if(PlCar[playerid][neon] != -1){DestroyObject(PlCar[playerid][neon]); PlCar[playerid][neon] = -1;}
PlCar[playerid][neont] = type;
PlCar[playerid][neon] = CreateObject(NeonObjects[type],0.00,0.00,10.000,0.00,0.00,0.00);
AttachObjectToVehicle(PlCar[playerid][neon], PlCar[playerid][vid], offx, offy, offz, 0.00, 0.00, 0.00);
return 1;
}
// --------------------------------------------------------------

public SetPlayerCarName(playerid,name[])
{
if(!Player[playerid][Vip]) {
SendClientMessage(playerid,COLOUR_GREEN, "Нет прав на выполнение!");
return 0;} // net prav
if(PlCar[playerid][sqlid] == 0) {
SendClientMessage(playerid,COLOUR_GREEN, "У вас нет машины!");
return 0;} // net u vas mashini
set(PlCar[playerid][pcarname],name);

//Update3DTextLabelText(Cars3DT[playerid], 0xFFFFFFFF, PlCar[playerid][pcarname]); // bugged =(

Delete3DTextLabel(Cars3DT[playerid]);
Cars3DT[playerid] = Create3DTextLabel( PlCar[playerid][pcarname], 0xFFFFFFFF, 0.000, 0.000, 10000.000, 50.000, 0, 0);
Attach3DTextLabelToVehicle(Cars3DT[playerid], PlCar[playerid][vid], 0.000, 0.000, 1.000);

Speed_UpdateVehName(PlCar[playerid][vid], name);

SendClientMessage(playerid,COLOUR_GREEN, "Имя изменено!");
return 1;
}

// --------------------------------------------------------------
public ChangePlayerCarColor(playerid,color1,color2)
{
PlCar[playerid][sqlid] = Player[playerid][Car];
if(!Player[playerid][Vip]) {
SendClientMessage(playerid,COLOUR_GREEN, "Нет прав на выполнение!");
return 0;}
if(PlCar[playerid][sqlid] == 0) {
SendClientMessage(playerid,COLOUR_GREEN, "У вас нет машины!");
return 0;}
if(PlCar[playerid][vid] == -1) {
SendClientMessage(playerid,COLOUR_GREEN, "Ваша машина еще не загружена, введите '/mycar load'!");
return 0;}
if(GetPlayerMoney(playerid) < 5000) {
SendClientMessage(playerid, COLOUR_CRIMSON, "Для использования команды Вам нужно 5000 $");
return 0;}

if(IsValidColor(color1) == 1 && IsValidColor(color2) == 1)
{
ChangeVehicleColor(PlCar[playerid][vid], color1, color2);
PlCar[playerid][c1] = color1;
PlCar[playerid][c2] = color2;
oGivePlayerMoney(playerid,-5000,0);
new tmp[128];
format(tmp,sizeof(tmp),"Цвет машины установлен: ( %d | %d )",color1,color2);
SendClientMessage(playerid,COLOUR_GREEN, tmp);
}
else
{
SendClientMessage(playerid,COLOUR_CRIMSON, "Неверный ИД цвета, используйте 0-255");
}
return 1;
}

// --------------------------------------------------------------
public RegisterPCar(playerid)
{
PlCar[playerid][sqlid] = Player[playerid][Car];
}
// --------------------------------------------------------------
public LoadPlayerCar(playerid)
{
PlCar[playerid][sqlid] = Player[playerid][Car];
if(!Player[playerid][Vip]) {
SendClientMessage(playerid,COLOUR_GREEN, "Нет прав на выполнение!");
return 0;}
if(PlCar[playerid][sqlid] == 0) {
SendClientMessage(playerid,COLOUR_GREEN, "У вас нет машины!");
return 0;}
if(PlCar[playerid][vid] != -1) {
SendClientMessage(playerid,COLOUR_GREEN, "Ваша машина уже доставлена!");
return 0;}

LoadPlayerCarDB(playerid);

if(PlCar[playerid][CX] == 0 && PlCar[playerid][CY] == 0 && PlCar[playerid][CZ] == 0) {
GetPlayerPos( playerid, PlCar[playerid][CX], PlCar[playerid][CY], PlCar[playerid][CZ]);
PlCar[playerid][CY] += 10.000;
}

PlCar[playerid][vid] = CreateVehicle(PlCar[playerid][model],PlCar[playerid][CX],PlCar[playerid][CY],PlCar[playerid][CZ],PlCar[playerid][CA],PlCar[playerid][c1],PlCar[playerid][c2],MyCARRespTime);

Cars3DT[playerid] = Create3DTextLabel(PlCar[playerid][pcarname], 0xFFFFFFFF, 0.000, 0.000, 10000.000, 50.000, 0, 0);
Attach3DTextLabelToVehicle(Cars3DT[playerid], PlCar[playerid][vid], 0.000, 0.000, 1.000);

for(new i=0;i<CARMOD_MAX;i++)
{
if(PlCarT[playerid][i] > 0) AddVehicleComponent(PlCar[playerid][vid], PlCarT[playerid][i]);
}

ChangeVehiclePaintjob(PlCar[playerid][vid], PlCar[playerid][pjob]);

new msg[256];
format(msg,256,"Машина доставлена | model %s | id %d",GetVehicleName(PlCar[playerid][model]),PlCar[playerid][vid]);
SendClientMessage(playerid,COLOUR_GREEN, msg);

return 1;
}

// --------------------------------------------------------------
RespawnPlayerCar(playerid)
{
PlCar[playerid][sqlid] = Player[playerid][Car];
if(!Player[playerid][Vip]) {
SendClientMessage(playerid,COLOUR_GREEN, "Нет прав на выполнение!");
return 0;}
if(PlCar[playerid][sqlid] == 0) {
SendClientMessage(playerid,COLOUR_GREEN, "У вас нет машины!");
return 0;}
if(PlCar[playerid][vid] == -1) {
SendClientMessage(playerid,COLOUR_GREEN, "Ваша машина еще не загружена, введите '/mycar load'!");
return 0;}
SetVehicleToRespawn(PlCar[playerid][vid]);
return 1;
}

stock DoorsPlayerCar(playerid,doorslocked)
{
PlCar[playerid][sqlid] = Player[playerid][Car];
if(!Player[playerid][Vip]) {
SendClientMessage(playerid,COLOUR_GREEN, "Нет прав на выполнение!");
return 0;}
if(PlCar[playerid][sqlid] == 0) {
SendClientMessage(playerid,COLOUR_GREEN, "У вас нет машины!");
return 0;}
if(PlCar[playerid][vid] == -1) {
SendClientMessage(playerid,COLOUR_GREEN, "Ваша машина еще не загружена, введите '/mycar load'!");
return 0;}

PlCar[playerid][locked] = doorslocked;

for(new i=0;i<MAX_PLAYERS;i++)
{
if(i == playerid) { continue; }
SetVehicleParamsForPlayer(PlCar[playerid][vid],i,0,doorslocked);
}
return 1;
}

TPPlayerCar(playerid)
{
PlCar[playerid][sqlid] = Player[playerid][Car];
if(!Player[playerid][Vip]) {
SendClientMessage(playerid,COLOUR_GREEN, "Нет прав на выполнение!");
return 0;}
if(PlCar[playerid][sqlid] == 0) {
SendClientMessage(playerid,COLOUR_GREEN, "У вас нет машины!");
return 0;}
if(PlCar[playerid][vid] == -1) {
SendClientMessage(playerid,COLOUR_GREEN, "Ваша машина еще не загружена, введите '/mycar load'!");
return 0;}
if(IsPlayerInAnyVehicle(playerid)) {
SendClientMessage(playerid,COLOUR_GREEN, "Выйдите из машины!");
return 0;}
if(GetPlayerVehicleID(playerid) == PlCar[playerid][vid]) {
SendClientMessage(playerid,COLOUR_GREEN, "Вы итак уже сидите в своей машине!!!");
return 0;}

new Float:pX, Float:pY, Float:pZ, Float:pA;
GetPlayerPos(playerid,pX,pY,pZ);
GetPlayerFacingAngle(playerid,pA);
SetVehicleToRespawn(PlCar[playerid][vid]);
SetVehiclePosEx(PlCar[playerid][vid], pX+Get_dx(pA, 10.00), pY+Get_dy(pA, 10.00), pZ+1);
SetVehicleZAngle(PlCar[playerid][vid], pA-90);
SetVehicleVirtualWorld(PlCar[playerid][vid], GetPlayerVirtualWorld(playerid));
return 1;
}

// --------------------------------------------------------------
public UnloadPlayerCar(playerid)
{
PlCar[playerid][sqlid] = 0;
PlCar[playerid][model] = -1;
PlCar[playerid][c1] = 1;
PlCar[playerid][c2] = 1;
if(PlCar[playerid][vid] != -1)
{
DestroyVehicle(PlCar[playerid][vid]);
Delete3DTextLabel(Cars3DT[playerid]);
}
set(PlCar[playerid][pcarname],nullstr);
PlCar[playerid][vid] = -1;
PlCar[playerid][pjob] = 0;

PlCar[playerid][CX] = 0.000;
PlCar[playerid][CY] = 0.000;
PlCar[playerid][CZ] = 0.000;
PlCar[playerid][CA] = 0.000;
PlCar[playerid][locked] = 0;

if(PlCar[playerid][neon] != -1)
{
DestroyObject(PlCar[playerid][neon]);
PlCar[playerid][neon] = -1;
}

PlCar[playerid][neont] = 5; // white neon

for(new i=0;i<CARMOD_MAX;i++)
{
PlCarT[playerid][i] = 0;
}
return 1;
}

public playercar_OnPlayerConnect(playerid)
{
PlCar[playerid][vid] = -1;
PlCar[playerid][neon] = -1;
return 1;
}

public PlayerCarCheckSpawn(vehicleid)
{
if(vehicleid == -1) {return 0;}
for(new i=0;i<MAX_PLAYERS;i++)
{
if(!IsPlayerConnected(i)) {continue;}
if(PlCar[i][vid] == -1) {continue;}
if(PlCar[i][vid] == vehicleid)
{
for(new y=0;y<CARMOD_MAX;y++)
{
if(PlCarT[i][y] > 0) AddVehicleComponent(PlCar[i][vid], PlCarT[i][y]);
}
ChangeVehiclePaintjob(PlCar[i][vid], PlCar[i][pjob]);
ChangeVehicleColor(PlCar[i][vid], PlCar[i][c1], PlCar[i][c2]);

if(PlCar[i][locked] == 1) { DoorsPlayerCar(i,1); }
return SendClientMessage(i, COLOUR_GREEN, "Ваша машина возвращена на сохраненную точку");
}
}
return 1;
}

/*
public PlayerCarCheckStream(vehicleid,forplayerid)
{
if(vehicleid == -1) {return 0;}
for(new i=0;i<MAX_PLAYERS;i++)
{
if(PlCar[i][vid] == -1) {continue;}
if(PlCar[i][vid] == vehicleid && i != forplayerid)
{ SetVehicleParamsForPlayer(vehicleid,forplayerid,0,PlCar[i][locked]); break;}
}
return 1;
}
*/

// --------------------------------------------------------------

public CarsCommandHandler(playerid,text[])
{
if (!IsPlayerConnected(playerid)) return 0;
if (!IsPlayerRegistered(playerid)) return 0;

new cmd[20];
new idx;
	
set(cmd,strcharsplit(text, idx,strchar(" ")));
if (strlen(cmd) == 0) return 0;

if(strcomp(cmd, "/mycar", true) == 1)
{

if (!IsPlayerRegistered(playerid))
  		{
   			SendPlayerFormattedText(playerid,  lang_texts[1][58] , 0,COLOUR_RED);
   			return 1;
  		}

//if (!strcomp(oGetPlayerName(playerid), "OFFREAL", true)) {
//SendClientMessage(playerid, COLOUR_CRIMSON, "Извините, функция заблокирована до исправления неполадок!"); return 1;}
		
  		set(cmd,strcharsplit(text, idx,strchar(" ")));
  		if (strlen(cmd) == 0) return 0;

if(strcomp(cmd, "save", true) == 1)
{
	if(CmdTimer[playerid][Time_SCommand] <= 0)
	{
	if(SavePlayerCar(playerid) == 1) {CmdTimer[playerid][Time_SCommand] =  CMD_TIME*4;}
	}
	else
	{
	new string[MAX_STRING];
	format(string,sizeof(string), lang_texts[9][44],CmdTimer[playerid][Time_SCommand]);
	return SendClientMessage(playerid, COLOUR_CRIMSON, string);	
	}
	return 1;
	}
/*
if(strcomp(cmd, "testparking", true) == 1)
{
TestParking();
return 1;
}
*/
/*
if(strcomp(cmd, "badlist", true) == 1)
{
MakeBadList(playerid);
return 1;
}
*/
if(strcomp(cmd, "name", true) == 1)
{
new carname[128],mess[128];
set(carname,text);
strdel(carname, 0, idx);
if(!strlen(carname)) {SendClientMessage(playerid, COLOUR_CRIMSON, "Введенное имя слишком короткое!"); return 1;}
if(strlen(carname) > 24) {SendClientMessage(playerid, COLOUR_CRIMSON, "Введенное имя слишком длинное!"); return 1;}
if(!XStringCharCheck(carname))
{
SendClientMessage(playerid, COLOUR_CRIMSON, "Вы использовали запрещенные символы! Используйте только: A-Z,a-z,0-9,],[,_");
return 1;
}
format(mess,sizeof(mess),"Вы изменили имя машины на '%s'",carname);
SendClientMessage(playerid, COLOUR_GREEN, mess);
SetPlayerCarName(playerid,carname);
return 1;
}

/*
if(strcomp(cmd, "numplate", true) == 1)
{
new carname[128],mess[128];
set(carname,text);
strdel(carname, 0, idx);
if(!strlen(carname)) {SendClientMessage(playerid, COLOUR_CRIMSON, "Введенное имя слишком короткое!"); return 1;}
if(strlen(carname) > 24) {SendClientMessage(playerid, COLOUR_CRIMSON, "Введенное имя слишком длинное!"); return 1;}
if(!PCarsStringCharCheck(carname))
{
SendClientMessage(playerid, COLOUR_CRIMSON, "Вы использовали запрещенные символы! Используйте только: A-Z,a-z,0-9,],[,_");
return 1;
}
format(mess,sizeof(mess),"Вы изменили имя машины на '%s'",carname);
SendClientMessage(playerid, COLOUR_GREEN, mess);
SetPlayerCarName(playerid,carname);
return 1;
}
*/

if(strcomp(cmd, "load", true) == 1)
{
LoadPlayerCar(playerid);
return 1;
}

if(strcomp(cmd, "resp", true) == 1)
{
RespawnPlayerCar(playerid);
return 1;
}

if(strcomp(cmd, "neon", true) == 1)
{
//if(!IsPlayerAdmin(playerid)){return 0;}
new nt = strval(strcharsplit(text, idx,strchar(" ")));
//new Float:offx = floatstr(strcharsplit(text, idx,strchar(" ")));
//new Float:offy = floatstr(strcharsplit(text, idx,strchar(" ")));
//new Float:offz = floatstr(strcharsplit(text, idx,strchar(" ")));
NeonOn(playerid,nt,0,0.00,0.00,0.00);
return 1;
}

if(strcomp(cmd, "neonoff", true) == 1)
{
if(PlCar[playerid][neon] != -1)
{
DestroyObject(PlCar[playerid][neon]);
PlCar[playerid][neon] = -1;
SendClientMessage(playerid, COLOUR_GREEN, "Неон отключен");
}
return 1;
}

if(strcomp(cmd, "neon-manual", true) == 1)
{
if(!IsPlayerAdmin(playerid)){return 0;} // admins only
new nt = strval(strcharsplit(text, idx,strchar(" ")));
new Float:offx = floatstr(strcharsplit(text, idx,strchar(" ")));
new Float:offy = floatstr(strcharsplit(text, idx,strchar(" ")));
new Float:offz = floatstr(strcharsplit(text, idx,strchar(" ")));
NeonOn(playerid,nt,1,offx,offy,offz);
return 1;
}


/*
if(strcomp(cmd, "lock", true) == 1)
{
if(DoorsPlayerCar(playerid,1) == 1) { SendClientMessage(playerid, COLOUR_GREEN, "Вы заблокировали двери своей машины"); }
return 1;
}

if(strcomp(cmd, "open", true) == 1)
{
if(DoorsPlayerCar(playerid,0) == 1) { SendClientMessage(playerid, COLOUR_GREEN, "Вы разблокировали двери своей машины");}
return 1;
}
*/

if(strcomp(cmd, "tele", true) == 1)
{

	if(IsPlayerInAnyDM(playerid))
	{
	SendClientMessage(playerid, COLOUR_CRIMSON, lang_texts[9][36]);
	return 1;
    }

if(CmdTimer[playerid][Time_CarTP] <= 0)
	{
	if(TPPlayerCar(playerid) == 1) {SendClientMessage(playerid, COLOUR_GREEN, "Ваша машина перед вами!");
	CmdTimer[playerid][Time_CarTP] = (CMD_TIME/2);}
	}
	else
	{
	new string[MAX_STRING];
	format(string,sizeof(string),"Команда '/mycar tele' будет доступна через %d секунд" ,CmdTimer[playerid][Time_CarTP]);
	return SendClientMessage(playerid, COLOUR_CRIMSON, string);	
	}

return 1;
}

//if(strcomp(cmd, "nxx", true) == 1)
//{
//NXX = 0;
//return 1;
//}
if(strcomp(cmd, "color", true) == 1)
{
//new vehicleid = GetPlayerVehicleID(playerid);

new col1, col2;
new tmp[MAX_STRING];
tmp = strcharsplit(text, idx,strchar(" "));
if(!strlen(tmp)) {
SendClientMessage(playerid,COLOUR_CRIMSON,"Вы не ввели значение первого цвета! Применение: '/mycar color <color1> <color2>");
return 1;
}
col1 = strval(tmp);

tmp = strcharsplit(text, idx,strchar(" "));
if(!strlen(tmp)) {
SendClientMessage(playerid,COLOUR_CRIMSON,"Вы не ввели значение второго цвета! Применение: '/mycar color <color1> <color2>");
return 1;
}
col2 = strval(tmp);

ChangePlayerCarColor(playerid,col1,col2);

return 1;
}


if(strcomp(cmd, "help", true) == 1)
{
SendClientMessage(playerid, COLOUR_GREEN, "::: Команды для персональных машин :::");
SendClientMessage(playerid, COLOUR_GREEN, "'/mycar load' - загрузить сохраненную машину из базы данных.");
SendClientMessage(playerid, COLOUR_GREEN, "'/mycar name <name>' - установить имя машины.");
SendClientMessage(playerid, COLOUR_GREEN, "'/mycar save' - сохранить текущие параметры машины в базу данных.");
SendClientMessage(playerid, COLOUR_GREEN, "'/mycar resp' - вернуть мою машину на точку респавна.");
//SendClientMessage(playerid, COLOUR_GREEN, "'/mycar lock' - заблокировать двери своей машины.");
//SendClientMessage(playerid, COLOUR_GREEN, "'/mycar open' - разблокировать двери своей машины.");
SendClientMessage(playerid, COLOUR_GREEN, "'/mycar tele' - телепортировать ко мне мою машину.");
SendClientMessage(playerid, COLOUR_GREEN, "'/mycar color <color1> <color2>' - изменить цвет машины.");
SendClientMessage(playerid, COLOUR_GREEN, "'/mycar neon <id>' - неоновая подсветка. id: {FF0000}0 {0000FF}1 {00FF00}2 {FFEE00}3 {EE00FF}4 {FFFFFF}5");
SendClientMessage(playerid, COLOUR_GREEN, "'/mycar neonoff' - выключить неон.");
return 1;
}

}
return 0;
}
// ---------------------------------------------------------------
public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
//printf("PlCar[playerid][vid] = %d",PlCar[playerid][vid]);
if(vehicleid == PlCar[playerid][vid] || PlCar[playerid][vid] == -1)
{
PlCar[playerid][c1] = color1;
PlCar[playerid][c2] = color2;
//printf("carcolors respray - ( %d | %d )",color1,color2);
}
return 1;
}
// --------------------------------------------------------------
public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
if(vehicleid == PlCar[playerid][vid] || PlCar[playerid][vid] == -1)
{
PlCar[playerid][pjob] = paintjobid;
}
return 1;
}
// --------------------------------------------------------------
forward MyCar_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
public MyCar_OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys == 65536) //KEY_YES (Y)
	{
		if(Player[playerid][Vip] == 0)
		{
			return 1;
		}
		
	    if(!IsPlayerInAnyVehicle(playerid))
	    {
	        SetPlayerChatBubble(playerid, "Открыл меню управления транспортом", COLOR_BLUE, 20.0, 2000);
	    	new helpstr[2200];
   		 	new comstr[128];
   		 	if(PlCar[playerid][vid] == -1){
	        	format(comstr,sizeof(comstr), "Ваш транспорт: {FF0000}[НЕ ЗАГРУЖЕН]",PlCar[playerid][vid],GetVehicleName(PlCar[playerid][model]));
			} else {
			    format(comstr,sizeof(comstr), "Ваш транспорт [%d]: {008000}%s",PlCar[playerid][vid],GetVehicleName(PlCar[playerid][model]));
			}
     		strins(helpstr, "{FFFFFF}Загрузить транспорт\n", strlen(helpstr));
	        strins(helpstr, "{FFFFFF}Вызвать транспорт на респавн\n", strlen(helpstr));
	        strins(helpstr, "{008000}Телепортировать транспорт к себе\n", strlen(helpstr));
	        strins(helpstr, "{FFFFFF}Установка неоновой подсветки\n", strlen(helpstr));
	        strins(helpstr, "{FFFFFF}Удаление неоновой подсветки\n", strlen(helpstr));
	        strins(helpstr, "{FFFFFF}Установка цвета автомобиля\n", strlen(helpstr));
	        strins(helpstr, "{FFFFFF}Установка имени автомобиля\n", strlen(helpstr));
	        ShowPlayerDialog(playerid, MCGUI, DIALOG_STYLE_LIST, comstr, helpstr,"Выбрать", "Отмена");
	    } else {
	    	SetPlayerChatBubble(playerid, "Открыл меню управления транспортом", COLOR_BLUE, 20.0, 2000);
    		new helpstr[2200];
   		 	new comstr[128];
   		 	if(PlCar[playerid][vid] == -1){
	        	format(comstr,sizeof(comstr), "Ваш транспорт: {FF0000}[НЕ ЗАГРУЖЕН]",PlCar[playerid][vid],GetVehicleName(PlCar[playerid][model]));
			} else {
			    format(comstr,sizeof(comstr), "Ваш транспорт [%d]: {008000}%s",PlCar[playerid][vid],GetVehicleName(PlCar[playerid][model]));
			}
     		strins(helpstr, "{FFFFFF}Загрузить транспорт\n", strlen(helpstr));
	        strins(helpstr, "{FFFFFF}Вызвать транспорт на респавн\n", strlen(helpstr));
	        strins(helpstr, "{FFFFFF}Установка неоновой подсветки\n", strlen(helpstr));
	        strins(helpstr, "{FFFFFF}Удаление неоновой подсветки\n", strlen(helpstr));
	        strins(helpstr, "{FFFFFF}Установка цвета автомобиля\n", strlen(helpstr));
	        strins(helpstr, "{FFFFFF}Установка имени автомобиля\n", strlen(helpstr));
	        strins(helpstr, "{008000}Сохранение транспорта\n", strlen(helpstr));
	        ShowPlayerDialog(playerid, MCGUI+1, DIALOG_STYLE_LIST, comstr, helpstr,"Выбрать", "Отмена");
	    }
	}
	return 1;
}
