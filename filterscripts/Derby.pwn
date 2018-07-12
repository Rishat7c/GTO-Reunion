/*
MTA Derby
*/
#include <a_samp>

#define ForEach(%0) for(new %0 = 0; %0 != GetServerVarAsInt("maxplayers"); %0++) if(IsPlayerConnected(%0) && !IsPlayerNPC(%0))

new DB_VehicleID = 415;

#define DB_DIALOG 1111

#define MAX_DERBY_SPAWN 2
new Float:DB_Spawns[MAX_DERBY_SPAWN][][] =
{
	{
		{2580.9543,-2922.2375,1003.8871},{2580.9353,-3040.3372,1003.8871},{2620.9497,-2980.4980,1003.8871},
		{2662.5625,-2922.4089,1003.8871},{2682.1228,-2959.8835,1003.8871},{2663.1399,-2999.8201,1003.8871},
		{2581.3845,-2962.0913,1003.8871},{2606.0146,-2995.0747,1003.8871},{2601.6973,-2941.1292,1003.8871},
		{2581.7783,-2959.8501,1003.8871}
	},
	{
		{3811.2156,-2453.5735,1002.5284},{3828.2717,-2437.7588,1002.5284},{3797.6394,-2471.6860,1002.5284},
		{3778.0747,-2452.8750,1002.5284},{3848.7319,-2453.9375,1002.5284},{3828.6216,-2453.9402,1015.5284},
		{3797.5637,-2453.8789,1015.5284},{3855.7751,-2472.6580,1015.5284},{3770.3140,-2436.6235,1015.5284},
		{3811.2190,-2436.3999,1015.5284}
	}
};

forward DB_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);


new DBP_Stats[MAX_PLAYERS];
new DBP_Vehicle[MAX_PLAYERS];

forward DBP_Spawn(playerid);
forward DBP_Exit(playerid);

forward LoadCreateObject();
forward SetPlayerPosEx(playerid, Float:x, Float:y, Float:z, Float:ang, int, vw);

//DB - Derby. DBP - Derby Player
//==============================================================================
public OnGameModeInit()
{
	SetTimer("ServerTimer", 1000, 1);
	LoadCreateObject();
	return 1;
}

public OnPlayerConnect(playerid)
{
	DBP_Exit(playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	DBP_Exit(playerid);
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if(!strcmp(cmdtext, "/derby", true))
	{
        if(DBP_Stats[playerid] >= 0) return ShowPlayerDialog(playerid, DB_DIALOG+1, DIALOG_STYLE_MSGBOX, "Derby", "Leave Derby area?", "Ok", "No");
	    new string[128];
	    for(new i; i < MAX_DERBY_SPAWN; i++)
	    {
	        format(string,sizeof(string),"%sDerby zone {FFCB77}¹%d{FFFFFF}.\n",string,i);
		}
		ShowPlayerDialog(playerid, DB_DIALOG, DIALOG_STYLE_LIST, "Derby - Zone:", string, "Ok", "Exit");
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	DBP_Exit(playerid);
    return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    DB_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DB_DIALOG:
		{
			if(!response) return 1;
			if(DBP_Stats[playerid] >= 0)
			{
				ShowPlayerDialog(playerid, 15157, DIALOG_STYLE_MSGBOX, "Derby", "You are already in Derby", " ", "");
				return 1;
			}
			DBP_Stats[playerid] = listitem;
	 		new RandomDerby = random(sizeof(DB_Spawns));
			SetPlayerPosEx(playerid, DB_Spawns[DBP_Stats[playerid]][RandomDerby][0], DB_Spawns[DBP_Stats[playerid]][RandomDerby][1], DB_Spawns[DBP_Stats[playerid]][RandomDerby][2]+2, random(360), 0, 1);
            DBP_Vehicle[playerid] = CreateVehicle(DB_VehicleID,DB_Spawns[DBP_Stats[playerid]][RandomDerby][0], DB_Spawns[DBP_Stats[playerid]][RandomDerby][1], DB_Spawns[DBP_Stats[playerid]][RandomDerby][2]+2,0,random(126), random(126),50000);
		}
		case DB_DIALOG+1:
		{
			if(!response) return 1;
			DBP_Exit(playerid);
		}
	}
	return 1;
}

forward ServerTimer();
public ServerTimer()
{
	ForEach(playerid)
	{
		if(DBP_Stats[playerid] >= 0)
		{
		    new Float: pPos[4];
		    new Float:vehhp;
		    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		    {
				GetVehiclePos(GetPlayerVehicleID(playerid),pPos[0],pPos[1],pPos[2]);
			    GetVehicleHealth(GetPlayerVehicleID(playerid), vehhp);
			}
			if(pPos[2] <= 990 || GetPlayerState(playerid) != PLAYER_STATE_DRIVER || vehhp < 250.0)
			{
				DBP_Spawn(playerid);
			}
		}
	}
	return 1;
}

public DB_OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(((newkeys & KEY_SUBMISSION) && !(oldkeys & KEY_SUBMISSION)) || ((newkeys & 1024) && !(oldkeys & 1024)) )
	{
        if(DBP_Stats[playerid] == -1) return 1;
        ShowPlayerDialog(playerid, DB_DIALOG+1, DIALOG_STYLE_MSGBOX, "Derby", "Leave Derby area??", "Ok", "No");
	}
	return 1;
}

public DBP_Spawn(playerid)
{
    if(DBP_Stats[playerid] == -1) return 1;
	new RandomDerby = random(10);

    SetPlayerPosEx(playerid, DB_Spawns[DBP_Stats[playerid]][RandomDerby][0], DB_Spawns[DBP_Stats[playerid]][RandomDerby][1], DB_Spawns[DBP_Stats[playerid]][RandomDerby][2]+2, random(360), 0, 1);

	DestroyVehicle(DBP_Vehicle[playerid]);
   	DBP_Vehicle[playerid] = CreateVehicle(DB_VehicleID,DB_Spawns[DBP_Stats[playerid]][RandomDerby][0], DB_Spawns[DBP_Stats[playerid]][RandomDerby][1], DB_Spawns[DBP_Stats[playerid]][RandomDerby][2]+2,0,random(126), random(126),50000);

	ResetPlayerWeapons(playerid);
	SetVehicleVirtualWorld(DBP_Vehicle[playerid],GetPlayerVirtualWorld(playerid));
	LinkVehicleToInterior(DBP_Vehicle[playerid],GetPlayerInterior(playerid));
	PutPlayerInVehicle(playerid, DBP_Vehicle[playerid], 0);
	return 1;
}

public DBP_Exit(playerid)
{
	if(DBP_Stats[playerid] == -1) return 1;
	DestroyVehicle(DBP_Vehicle[playerid]);
	DBP_Stats[playerid] = -1;
	SpawnPlayer(playerid);
	return 1;
}

public SetPlayerPosEx(playerid, Float:x, Float:y, Float:z, Float:ang, int, vw)
{
	SetPlayerPos(playerid, x, y, z);
	SetPlayerFacingAngle(playerid, ang);
	SetPlayerInterior(playerid, int);
	SetPlayerVirtualWorld(playerid, vw);
    SetCameraBehindPlayer(playerid);
	return 1;
}

public LoadCreateObject()
{
	//Derby 1:------------------------------------------------------------------
	CreateObject(8558,2583.55273438,-2921.90820312,1001.35871506,0.00000000,0.00000000,0.00000000); // 1)
	CreateObject(8558,2623.75903320,-2921.92407227,1001.35871506,0.00000000,0.00000000,0.00000000); // 2)
	CreateObject(8558,2663.91845703,-2921.92724609,1001.35871506,0.00000000,0.00000000,0.00000000); // 3)
	CreateObject(8558,2681.58496094,-2943.59521484,1001.35871506,0.00000000,0.00000000,90.00000000); // 4)
	CreateObject(8558,2681.58984375,-2983.88793945,1001.35871506,0.00000000,0.00000000,90.00000000); // 5)
	CreateObject(8558,2681.56201172,-3024.05273438,1001.35871506,0.00000000,0.00000000,90.00000000); // 6)
	CreateObject(8558,2658.91650391,-3041.70947266,1001.35871506,0.00000000,0.00000000,180.00000000); // 7)
	CreateObject(8558,2618.93896484,-3041.70922852,1001.35871506,0.00000000,0.00000000,179.99450684); // 8)
	CreateObject(8558,2579.22973633,-3041.67895508,1001.35871506,0.00000000,0.00000000,179.99450684); // 9)
	CreateObject(8558,2561.60351562,-3019.28930664,1001.35871506,0.00000000,0.00000000,90.00000000); // 10)
	CreateObject(8558,2561.60791016,-2979.25610352,1001.35871506,0.00000000,0.00000000,90.00000000); // 11)
	CreateObject(8558,2561.60058594,-2939.54589844,1001.35871506,0.00000000,0.00000000,90.00000000); // 12)
	CreateObject(8558,2561.60351562,-3019.28906250,1001.35871506,0.00000000,0.00000000,90.00000000); // 13)
	CreateObject(8558,2583.98046875,-2978.90551758,1001.35871506,0.00000000,0.00000000,0.00000000); // 1)
	CreateObject(8558,2658.91259766,-2978.71704102,1001.35871506,0.00000000,0.00000000,0.00000000); // 1)
	CreateObject(8558,2622.16528320,-3019.43432617,1001.35871506,0.00000000,0.00000000,90.00000000); // 13)
	CreateObject(8558,2622.04321289,-2941.63378906,1001.35871506,0.00000000,0.00000000,90.00000000); // 13)
	CreateObject(1634,2621.95776367,-2959.33129883,1003.68449116,0.00000000,0.00000000,180.00000000); // 1)
	CreateObject(1634,2600.51269531,-2978.81298828,1003.68449116,0.00000000,0.00000000,270.00000000); // 2)
	CreateObject(1634,2622.16284180,-3003.88330078,1003.68449116,0.00000000,0.00000000,0.00000000); // 3)
	CreateObject(1634,2643.73681641,-2978.61230469,1003.68449116,0.00000000,0.00000000,90.00000000); // 4)
	CreateObject(8558,2581.15527344,-2958.77563477,1001.35871506,0.00000000,0.00000000,90.00000000); // 12)
	CreateObject(8558,2581.12744141,-2942.96484375,1001.35871506,0.00000000,0.00000000,90.00000000); // 12)
	CreateObject(8558,2583.78588867,-2960.45166016,1001.35871506,0.00000000,0.00000000,0.00000000); // 1)
	CreateObject(8558,2582.97290039,-2940.23608398,1001.35871506,0.00000000,0.00000000,0.00000000); // 1)
	CreateObject(8558,2601.40527344,-2942.78515625,1001.35871506,0.00000000,0.00000000,90.00000000); // 12)
	CreateObject(8558,2613.96875000,-2972.66796875,1001.35871506,0.00000000,0.00000000,136.00000000); // 12)
	CreateObject(8558,2627.50952148,-2985.75268555,1001.35871506,0.00000000,0.00000000,136.00003052); // 12)
	CreateObject(8558,2662.98852539,-2997.44946289,1001.35871506,0.00000000,0.00000000,90.00000000); // 12)
	CreateObject(8558,2662.98754883,-3020.35913086,1001.35871506,0.00000000,0.00000000,90.00000000); // 12)
	CreateObject(8558,2660.61303711,-3000.07495117,1001.35871506,0.00000000,0.00000000,0.00000000); // 1)
	CreateObject(8558,2660.71166992,-3021.18383789,1001.35871506,0.00000000,0.00000000,0.00000000); // 1)
	CreateObject(8558,2642.74194336,-3020.76025391,1001.35871506,0.00000000,0.00000000,90.00000000); // 12)
	CreateObject(8558,2617.92700195,-2982.91992188,1001.35871506,0.00000000,0.00000000,226.25000000); // 12)
	CreateObject(8558,2581.16992188,-2996.62011719,1001.35871506,0.00000000,0.00000000,90.00000000); // 12)
	CreateObject(8558,2581.16650391,-3020.93725586,1001.35871506,0.00000000,0.00000000,90.00000000); // 12)
	CreateObject(8558,2583.53076172,-2997.95751953,1001.35871506,0.00000000,0.00000000,0.00000000); // 1)
	CreateObject(8558,2583.85302734,-3021.10888672,1001.35871506,0.00000000,0.00000000,0.00000000); // 1)
	CreateObject(8558,2603.62939453,-3017.48510742,1001.35871506,0.00000000,0.00000000,90.00000000); // 12)
	CreateObject(8558,2603.62231445,-3021.84985352,1001.35871506,0.00000000,0.00000000,90.00000000); // 12)
	CreateObject(8558,2662.96679688,-2963.67480469,1001.35871506,0.00000000,0.00000000,90.00000000); // 12)
	CreateObject(8558,2662.94287109,-2939.53588867,1001.35871506,0.00000000,0.00000000,90.00000000); // 12)
	CreateObject(8558,2660.06127930,-2960.21826172,1001.35871506,0.00000000,0.00000000,0.00000000); // 1)
	CreateObject(8558,2659.75219727,-2940.42773438,1001.35871506,0.00000000,0.00000000,0.00000000); // 1)
	CreateObject(8558,2625.03808594,-2975.54052734,1001.35871506,0.00000000,0.00000000,226.24694824); // 12)
	CreateObject(8558,2639.40380859,-2941.73388672,1001.35871506,0.00000000,0.00000000,90.00000000); // 12)
	CreateObject(8558,2621.37939453,-2940.33618164,1001.35871506,0.00000000,0.00000000,0.00000000); // 1)
	CreateObject(8558,2621.35986328,-3021.18725586,1001.35871506,0.00000000,0.00000000,0.00000000); // 1)

	//Derby 2:------------------------------------------------------------------
	CreateObject(8558,3795.19995117,-2472.10009766,48.00000000+952,0.00000000,0.00000000,0.00000000); // 1)
	CreateObject(8558,3830.60009766,-2472.10009766,48.00000000+952,0.00000000,0.00000000,0.00000000); // 2)
	CreateObject(8558,3828.19995117,-2454.30004883,48.00000000+952,0.00000000,0.00000000,90.00000000); // 3)
	CreateObject(8558,3797.60009766,-2454.30004883,48.00000000+952,0.00000000,0.00000000,90.00000000); // 4)
	CreateObject(8558,3795.19995117,-2436.80004883,48.00000000+952,0.00000000,0.00000000,0.00000000); // 5)
	CreateObject(8558,3830.60009766,-2436.80004883,48.00000000+952,0.00000000,0.00000000,0.00000000); // 6)
	CreateObject(8558,3849.30004883,-2454.30004883,48.00000000+952,0.00000000,0.00000000,90.00000000); // 7)
	CreateObject(8558,3777.69995117,-2454.30004883,48.00000000+952,0.00000000,0.00000000,90.00000000); // 8)
	CreateObject(8558,3770.00000000,-2454.30004883,61.00000000+952,0.00000000,0.00000000,90.00000000); // 9)
	CreateObject(8558,3789.30004883,-2453.50000000,51.09999847+952,0.00000000,30.00000000,0.00000000); // 10)
	CreateObject(8558,3810.50000000,-2453.50000000,48.00000000+952,0.00000000,0.00000000,0.00000000); // 11)
	CreateObject(8558,3836.50000000,-2453.50000000,51.09999847+952,0.00000000,30.00000000,180.00000000); // 12)
	CreateObject(8558,3855.30004883,-2454.30004883,61.00000000+952,0.00000000,0.00000000,90.00000000); // 14)
	CreateObject(8558,3832.55004883,-2472.00000000,61.00000000+952,0.00000000,0.00000000,0.00000000); // 15)
	CreateObject(8558,3792.30004883,-2472.00000000,61.00000000+952,0.00000000,0.00000000,0.00000000); // 16)
	CreateObject(8558,3832.55004883,-2436.66992188,61.00000000+952,0.00000000,0.00000000,0.00000000); // 17)
	CreateObject(8558,3792.30004883,-2436.66992188,61.00000000+952,0.00000000,0.00000000,0.00000000); // 18)
	CreateObject(8558,3797.60009766,-2454.30004883,61.00000000+952,0.00000000,0.00000000,90.00000000); // 19)
	CreateObject(8558,3828.19995117,-2454.30004883,61.00000000+952,0.00000000,0.00000000,90.00000000); //20)
	return 1;
}
