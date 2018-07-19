forward tuning_OnPlayerStateChange(playerid, newstate, oldstate);

public tuning_OnPlayerStateChange(playerid, newstate, oldstate)
{

	if(newstate == PLAYER_STATE_DRIVER)
	{ //если игрок стал водителем
	new string[MAX_STRING];
//	SetVehicleNumberPlate(GetPlayerVehicleID(playerid), oGetPlayerName(playerid));

		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 520 && GetPlayerLevel(playerid) < MinHydraLevel && !IsPlayerAdmin(playerid))
		{
		format(string,sizeof(string),lang_texts[9][40],GetVehicleName(GetVehicleModel(GetPlayerVehicleID(playerid))),MinHydraLevel);
		SendClientMessage(playerid, COLOUR_GREEN, string);
		return RemovePlayerFromVehicle(playerid);
		}

		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 425 && GetPlayerLevel(playerid) < MinHunterLevel && !IsPlayerAdmin(playerid))
		{
		format(string,sizeof(string),lang_texts[9][40],GetVehicleName(GetVehicleModel(GetPlayerVehicleID(playerid))),MinHunterLevel);
		SendClientMessage(playerid, COLOUR_GREEN, string);
		return RemovePlayerFromVehicle(playerid);
		}

		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 432 && GetPlayerLevel(playerid) < MinRhinoLevel && !IsPlayerAdmin(playerid))
		{
		format(string,sizeof(string),lang_texts[9][40],GetVehicleName(GetVehicleModel(GetPlayerVehicleID(playerid))),MinRhinoLevel);
		SendClientMessage(playerid, COLOUR_GREEN, string);
		return RemovePlayerFromVehicle(playerid);
		}

    if (GetPlayerVehicleID(playerid) == TunCar[0])
    {
        if(IsCarTun[0] == 0) //hotring
	{	
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1010); // Nitro
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1079);//koleso
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1087);//gidr
        IsCarTun[0] = 1;
        }
        if(IsCarTun[0] == 1)
	{
	DialogPlayerTun(playerid, 5000);
	}
    }
    else if(GetPlayerVehicleID(playerid) == TunCar[1]) //Sandking
    {
    	if(IsCarTun[1] == 0)
	{	
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1010); // Nitro
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1080);//koleso
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1087);//gidr
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1018);//trubi Exhaust
        IsCarTun[1] = 1;
        }
        if(IsCarTun[1] == 1)
	{
	DialogPlayerTun(playerid, 3000);
	}
    }
    else if(GetPlayerVehicleID(playerid) == TunCar[2]) //Elegy
    {
        if(IsCarTun[2] == 0)
	{	
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1010); // Nitro
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1079);//koleso
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1086);//sterio
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1087);//gidr
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1171);//bamper
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1149);//bamper
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1146);//spoiler
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1035);//roof
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1040);//ubka
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1036);//ubka
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1034);//trubi
        ChangeVehiclePaintjob(GetPlayerVehicleID(playerid), 1);
        IsCarTun[2] = 1;
        }
        if(IsCarTun[2] == 1)
	{
	DialogPlayerTun(playerid, 1000);
	}
    }
    else if(GetPlayerVehicleID(playerid) == TunCar[3]) //Sultan
    {
        if(IsCarTun[3] == 0)
	{	
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1010); // Nitro
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1080);//koleso
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1086);//sterio
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1087);//gidr
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1169);//bamper
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1141);//bamper
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1138);//spoiler
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1032);//roof
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1026);//ubka
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1027);//ubka
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1028);//trubi
        ChangeVehiclePaintjob(GetPlayerVehicleID(playerid), 1);
        IsCarTun[3] = 1;
        }
        if(IsCarTun[3] == 1)
	{
	DialogPlayerTun(playerid, 1000);
	}
     }
    else if(GetPlayerVehicleID(playerid) == TunCar[4]) //Uranus
    {
        if(IsCarTun[4] == 0)
	{	
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1010); // Nitro
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1081);//koleso
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1086);//sterio
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1087);//gidr
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1166);//bamper front alien
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1168);//bamper rear alien
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1164);//spoiler alien
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1088);//roof alien
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1090);//ubka Right Alien
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1094);//ubka Left Alien
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1092);//trubi Exhaust
        ChangeVehiclePaintjob(GetPlayerVehicleID(playerid), 0);
        IsCarTun[4] = 1;
        }
        if(IsCarTun[4] == 1)
	{
	DialogPlayerTun(playerid, 1000);
	}
     }
         else if(GetPlayerVehicleID(playerid) == TunCar[5]) //Jester
    {
        if(IsCarTun[5] == 0)
	{	
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1010); // Nitro
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1081);//koleso
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1086);//sterio
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1087);//gidr
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1160);//bamper front alien
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1159);//bamper rear alien
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1162);//spoiler alien
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1067);//roof alien
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1069);//ubka Right Alien
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1071);//ubka Left Alien
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1065);//trubi Exhaust
        ChangeVehiclePaintjob(GetPlayerVehicleID(playerid), 0);
        IsCarTun[5] = 1;
        }
        if(IsCarTun[5] == 1)
	{
	DialogPlayerTun(playerid, 1000);
	}
     }
         else if(GetPlayerVehicleID(playerid) == TunCar[6]) //Mesa
    {
        if(IsCarTun[6] == 0)
	{	
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1010); // Nitro
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1074);//koleso
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1086);//sterio
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1087);//gidr
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1013);//противотуманки круглые
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1019);//trubi Exhaust
        IsCarTun[6] = 1;
        }
        if(IsCarTun[6] == 1)
	{
	DialogPlayerTun(playerid, 1500);
	}
	}
         else if(GetPlayerVehicleID(playerid) == TunCar[7]) //Elegy
    {
        if(IsCarTun[7] == 0)
	{	
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1010); // Nitro
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1080);//koleso
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1086);//sterio
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1087);//gidr
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1172);//bamper front X-Flow
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1148);//bamper rear X-Flow
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1146);//spoiler X-Flow
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1035);//roof X-Flow
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1041);//ubka Right X-Flow
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1039);//ubka Left X-Flow
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1037);//trubi Exhaust X-Flow
        ChangeVehiclePaintjob(GetPlayerVehicleID(playerid), 1);
        IsCarTun[7] = 1;
        }
        if(IsCarTun[7] == 1)
	{
	DialogPlayerTun(playerid, 1000);
	}
     }
         else if(GetPlayerVehicleID(playerid) == TunCar[8]) //Infernus
    {
        if(IsCarTun[8] == 0)
	{	
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1010); // Nitro
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1074);//koleso
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1086);//sterio
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1087);//gidr
        IsCarTun[8] = 1;
        }
        if(IsCarTun[8] == 1)
	{
	DialogPlayerTun(playerid, 1000);
	}
     }
         else if(GetPlayerVehicleID(playerid) == TunCar[9]) //Mesa
    {
        if(IsCarTun[9] == 0)
	{	
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1010); // Nitro
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1074);//koleso
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1086);//sterio
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1087);//gidr
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1013);//противотуманки круглые
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1019);//trubi Exhaust
        IsCarTun[9] = 1;
        }
        if(IsCarTun[9] == 1)
	{
	DialogPlayerTun(playerid, 1500);
	}
     } 
         else if(GetPlayerVehicleID(playerid) == TunCar[10]) //Sandking
    {
        if(IsCarTun[10] == 0)
	{	
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1010); // Nitro
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1080);//koleso
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1087);//gidr
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1018);//trubi Exhaust
        IsCarTun[10] = 1;
        }
        if(IsCarTun[10] == 1)
	{
	DialogPlayerTun(playerid, 5000);
	}
     }
         else if(GetPlayerVehicleID(playerid) == TunCar[11]) //Sultan
    {
        if(IsCarTun[11] == 0)
	{	
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1010); // Nitro
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1081);//koleso
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1086);//sterio
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1087);//gidr
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1170);//bamper
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1140);//bamper
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1139);//spoiler
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1033);//roof
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1026);//ubka
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1027);//ubka
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1029);//trubi
        ChangeVehiclePaintjob(GetPlayerVehicleID(playerid), 1);
        IsCarTun[11] = 1;
        }
        if(IsCarTun[11] == 1)
	{
	DialogPlayerTun(playerid, 1000);
	}
     }
         else if(GetPlayerVehicleID(playerid) == TunCar[12]) //BF
    {
        if(IsCarTun[12] == 0)
	{	
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1010); // Nitro
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1098);//koleso
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1087);//gidr
        IsCarTun[12] = 1;
        }
        if(IsCarTun[12] == 1)
	{
	DialogPlayerTun(playerid, 5000);
	}
     }
         else if(GetPlayerVehicleID(playerid) == TunCar[13]) //Uranus
    {
        if(IsCarTun[13] == 0)
	{	
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1010); // Nitro
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1082);//koleso
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1086);//sterio
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1087);//gidr
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1165);//bamper front x
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1167);//bamper rear x
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1163);//spoiler x
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1091);//roof x
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1093);//ubka Right x
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1095);//ubka Left Alien
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1089);//trubi Exhaust
        ChangeVehiclePaintjob(GetPlayerVehicleID(playerid), 1);
        IsCarTun[13] = 1;
        }
        if(IsCarTun[13] == 1)
	{
	DialogPlayerTun(playerid, 1000);
	}
     }
         else if(GetPlayerVehicleID(playerid) == TunCar[14]) //Elegy
    {
        if(IsCarTun[14] == 0)
	{	
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1010); // Nitro
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1079);//koleso
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1086);//sterio
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1087);//gidr
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1172);//bamper front x
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1148);//bamper rear x
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1146);//spoiler x
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1035);//roof x
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1041);//ubka Right x
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1039);//ubka Left x
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1037);//trubi Exhaust x
        ChangeVehiclePaintjob(GetPlayerVehicleID(playerid), 1);
        IsCarTun[14] = 1;
        }
        if(IsCarTun[14] == 1)
	{
	DialogPlayerTun(playerid, 1000);
	}
     }
         else if(GetPlayerVehicleID(playerid) == TunCar[15]) //Jester
    {
        if(IsCarTun[15] == 0)
	{	
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1010); // Nitro
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1098);//koleso
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1086);//sterio
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1087);//gidr
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1173);//bamper front x
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1161);//bamper rear x
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1158);//spoiler x
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1068);//roof x
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1070);//ubka Right x
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1072);//ubka Left x
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1066);//trubi Exhaust x
        ChangeVehiclePaintjob(GetPlayerVehicleID(playerid), 2);
        IsCarTun[15] = 1;
        }
        if(IsCarTun[15] == 1)
	{
	DialogPlayerTun(playerid, 1000);
	}
     }
         else if(GetPlayerVehicleID(playerid) == TunCar[16]) //Hotring
    {
        if(IsCarTun[16] == 0)
	{	
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1010); // Nitro
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1079);//koleso
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1087);//gidr
        IsCarTun[16] = 1;
        }
        if(IsCarTun[16] == 1)
	{
	DialogPlayerTun(playerid, 10000);
	}
     }
	} // конец - если игрок стал водителем


return 1;
}