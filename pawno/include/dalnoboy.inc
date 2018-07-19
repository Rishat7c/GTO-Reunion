forward OnPlayerEnterTDLCheckpoint(playerid);
forward IsPlayerAtTDLC(playerid); // игрок в "покупка нефти"
forward IsPlayerAtTDLD(playerid); // продажа керосина
forward IsPlayerAtTDLP(playerid); // переработка
forward IsPlayerAtTDLE(playerid); // бензоколонка
forward DalnLog(string[]);
forward DalnZSaves(savepoint);

forward TDLCInit(); //инициализация чекпоинтов

forward DialogPlayerDLB(playerid); // диалог покупки нефти
forward DialogPlayerDLS(playerid); // диалог продажи керосина
forward DialogPlayerDLP(playerid); // диалог переработки
forward DialogPlayerDLE(playerid); // диалог бензина

/* переместил в commandhandler.inc
// покупаем ТУТ
new Float:TDLMarkersLoc[DALNSZMARKERS][CoordInfoEx] = { // Coord_I - цена
{271.9484,1417.1746,10.4533,700} //завод в третьем
};

// перерабатываем тут
new Float:TDLMarkersProces[TDLMARKERS][CoordInfoEx] = { // коорд и = цена приемки оил, кена керосина кена оил +600
{2486.0518,-2083.7764,13.5469,1200}, //завод в первом (не перерабатывает в керосин)
{-1035.2433,-626.3660,32.0078,950}, //завод во втором
{2707.8103,2646.9172,10.8203,900} //завод в третьем KACC
};

// продаем тут
new Float:TDLMarkersDest[TDLMARKERS][CoordInfoEx] = { // цена покупки бензина 1500, продажи по формуле
	{369.3520,2602.1160,16.4918,1400}, //заброшенный аэро
	{-1567.6123,-656.9137,14.1484,1300}, //аэропорт во втором
	{2491.6790,-2652.4880,13.6722,1600} //порт в первом
};

//бензоколонки
new Float:TDMarkersPetrol[DALNAZSMARKERS][CoordInfo] = {
	{2109.2126,917.5845,10.8203},
	{2640.1831,1103.9224,10.8203},
	{611.8934,1694.7921,6.7193},
	{-1327.5398,2682.9771,49.7896},
	{-2413.7427,975.9317,45.0031},
	{-1672.3597,414.2950,6.8866},
	{-2244.1365,-2560.6294,31.6276},
	{-1603.0166,-2709.3589,48.2419},
	{1939.3275,-1767.6813,13.2787},
	{-94.7651,-1174.8079,1.9979},
	{1381.6699,462.6467,19.8540},
	{657.8167,-559.6507,16.0630},
	{-1478.2916,1862.8318,32.3617},
	{2147.3054,2744.9377,10.5263},
	{2204.9602,2480.3494,10.5278},
	{1590.9493,2202.2637,10.5247}
};
*/
public TDLCInit()
{
	for (new id=0;id<DALNSZMARKERS;id++) // продажные маркеры (один)
	{
		AddActiveCheckpoint(TDLMarkersLoc[id][Coord_X],TDLMarkersLoc[id][Coord_Y],TDLMarkersLoc[id][Coord_Z],200,8);
	}
	for (new id=0;id<TDLMARKERS;id++) // перерабатывающие
	{
		AddActiveCheckpoint(TDLMarkersProces[id][Coord_X],TDLMarkersProces[id][Coord_Y],TDLMarkersProces[id][Coord_Z],200,8);
		new filestring[256];
		new filedatstring[256];
		new DalnFilePath[MAX_STRING] = "GTO/Dalnoboy/";
		format(filestring,sizeof(filestring),"%szavod.txt",DalnFilePath);
		new tempi[128];
		valstr(tempi,id);

		format(filedatstring,sizeof(filedatstring),"zavod%s",tempi);
		if (dini_Exists(filestring))
		{
		new temp[MAX_STRING];
		set(temp,dini_Get(filestring,filedatstring));
		IsLoadZavod[id] = strval(temp);
		}
	}
	for (new id=0;id<TDLMARKERS;id++) // потребляющие керосин
	{
		AddActiveCheckpoint(TDLMarkersDest[id][Coord_X],TDLMarkersDest[id][Coord_Y],TDLMarkersDest[id][Coord_Z],200,8);
	}
	for (new id=0;id<DALNAZSMARKERS;id++) // бензоколонки
	{
		new filestring[256];
		new DalnFilePath[MAX_STRING] = "GTO/Dalnoboy/";
		new tempi[128];
		valstr(tempi,id);
		format(filestring,sizeof(filestring),"%sazs%s.txt",DalnFilePath,tempi);
		if (dini_Exists(filestring))
		{
		new temp[MAX_STRING];
		set(temp,dini_Get(filestring,"load"));
		CmdTimerComand[id+2] = strval(temp);
		}
	}
	WriteLog("TM checkpoints initialised");
}

public IsPlayerAtTDLC(playerid) // покупка нефти
{
	for (new id=0;id<DALNSZMARKERS;id++)
	{
		if (oIsPlayerInCheckpoint(playerid,TDLMarkersLoc[id][Coord_X],TDLMarkersLoc[id][Coord_Y],TDLMarkersLoc[id][Coord_Z],8))
		{
			return 1;
		}
	}
	return 0;
}

public IsPlayerAtTDLP(playerid) // пеработка
{
	for (new id=0;id<TDLMARKERS;id++)
	{
		if (oIsPlayerInCheckpoint(playerid,TDLMarkersProces[id][Coord_X],TDLMarkersProces[id][Coord_Y],TDLMarkersProces[id][Coord_Z],8))
		{
			return 1;
		}
	}
	return 0;
}

public IsPlayerAtTDLD(playerid) // продажа керосина
{
	for (new id=0;id<TDLMARKERS;id++)
	{
		if (oIsPlayerInCheckpoint(playerid,TDLMarkersDest[id][Coord_X],TDLMarkersDest[id][Coord_Y],TDLMarkersDest[id][Coord_Z],8))
		{
			return 1;
		}
	}
	return 0;
}

public IsPlayerAtTDLE(playerid) // бензоколонки
{
	for (new id=0;id<DALNAZSMARKERS;id++)
	{
/*		if (oIsPlayerInCheckpoint(playerid,TDMarkersPetrol[id][Coord_X],TDMarkersPetrol[id][Coord_Y],TDMarkersPetrol[id][Coord_Z],8))
		{
			return 1;
		}*/
		if (IsPlayerInSphere(playerid,TDMarkersPetrol[id][Coord_X],TDMarkersPetrol[id][Coord_Y],TDMarkersPetrol[id][Coord_Z],30))
		{
			return 1;
		}

	}
	return 0;
}


public OnPlayerEnterTDLCheckpoint(playerid) // проверка не въехал ли игрок в один из четырех типов ЧП	
{
	if (playerid == INVALID_PLAYER_ID) return;
	if (!IsPlayerConnected(playerid)) return;
	if (!IsPlayerAtTDLC(playerid) && !IsPlayerAtTDLD(playerid) && !IsPlayerAtTDLP(playerid)) return; // бензин  && !IsPlayerAtTDLE(playerid)
/*
	if (IsPlayerAtTDLE(playerid))
		{
		SendPlayerFormattedText(playerid, " Нажмите KEY_ANALOG_LEFT <NUM4> для отображения дополнительной информации.", 0,COLOUR_GREEN);
		return;
		}
*/
	if (!IsPlayerInAnyVehicle(playerid)) // плаер пехом
	{
/*		if (IsPlayerAtTDLE(playerid))
		{
		SendPlayerFormattedText(playerid, " Нажмите KEY_ANALOG_LEFT <NUM4> для отображения дополнительной информации.", 0,COLOUR_GREEN);
		return;
		}*/
	SendPlayerFormattedText(playerid, " Это грузовой портал. Приезжайте на грузовике с прицепом.", 0,COLOUR_GREEN);
	} else if (GetVehicleModel(GetPlayerVehicleID(playerid)) != 403 && GetVehicleModel(GetPlayerVehicleID(playerid)) != 514 && GetVehicleModel(GetPlayerVehicleID(playerid)) != 515)
	{ // не на грузовике (если модель машины на которой приехал игрок НЕ 403 и НЕ 514 и НЕ 515)
	SendPlayerFormattedText(playerid, " Это грузовой портал. Приезжайте на грузовике с прицепом.", 0,COLOUR_GREEN);
	} else if (!IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
	{ // без прицепа
	SendPlayerFormattedText(playerid, " Это грузовой портал. Приезжайте на грузовике с прицепом 'цистерна'.", 0,COLOUR_GREEN);
	} else if (GetVehicleModel(GetVehicleTrailer(GetPlayerVehicleID(playerid))) != 584)
	{ // не с цистерной
	SendPlayerFormattedText(playerid, " Вам надо приехать с цистерной!", 0,COLOUR_GREEN);
	} else // иначе все ок
	{	
	SendPlayerFormattedText(playerid, " Нажмите KEY_ANALOG_LEFT <NUM4> для отображения дополнительной информации.", 0,COLOUR_GREEN);
	}
}

public DialogPlayerDLB(playerid) // покупка оил
{
if (!IsPlayerConnected(playerid)) return 0;
	new s[MAX_STRING];
	if (!IsPlayerInAnyVehicle(playerid)) // плаер пехом
	{
	format(s,sizeof(s), "Это грузовой портал. Приезжайте на грузовике с прицепом.");
	ShowPlayerDialog(playerid,CGUI+5,0,"::: Oil Help :::",s,"Ok","Cancel");
	} else if (GetVehicleModel(GetPlayerVehicleID(playerid)) != 403 && GetVehicleModel(GetPlayerVehicleID(playerid)) != 514 && GetVehicleModel(GetPlayerVehicleID(playerid)) != 515)
	{ // игрок НЕ на грузовике
	format(s,sizeof(s), "Это грузовой портал. Приезжайте на грузовике с прицепом.");
	ShowPlayerDialog(playerid,CGUI+5,0,"::: Oil Help :::",s,"Ok","Cancel");
	} else if (!IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
	{ //игрок на грузовике без прицепа
	format(s,sizeof(s), "Это грузовой портал. Приезжайте на грузовике с прицепом 'цистерна'.");
	ShowPlayerDialog(playerid,CGUI+5,0,"::: Oil Help :::",s,"Ok","Cancel");
	} else if (GetVehicleModel(GetVehicleTrailer(GetPlayerVehicleID(playerid))) != 584)
	{ // игрок на грузовике, с прицепом, но не цистерна
	format(s,sizeof(s), "Вам надо приехать c цистерной!", 0,COLOUR_GREEN);
	ShowPlayerDialog(playerid,CGUI+5,0,"::: Oil Help :::",s,"Ok","Cancel");
	} else //игрок на грузовике, с прицепом цистерна (потом какнить проверим водила ли он)
	{	
				if (oIsPlayerInCheckpoint(playerid,TDLMarkersLoc[0][Coord_X],TDLMarkersLoc[0][Coord_Y],TDLMarkersLoc[0][Coord_Z],8))
				{
					new tempz1;
					for(new f=0; f < sizeof(LoadTrailer);f++)
					{
		    				if(GetVehicleTrailer(GetPlayerVehicleID(playerid)) == LoadTrailer[f])
					        	{
		       					tempz1 = f;
		        				}
					}
					if (IsLoadTrailerTip[tempz1] == 0 || IsLoadTrailerTip[tempz1] == 1)
					{
						format(s,sizeof(s), "Сколько вы хотите преобрести нефти\nпо цене %d$ за еденицу.",TDLMarkersLoc[0][Coord_I]);
						ShowPlayerDialog(playerid,CGUI+7,1,":: Buy OIL ::",s,"ОК ","Cancel");
					} else if (IsLoadTrailerTip[tempz1] == 2) {
						format(s,sizeof(s), "В вашем прицепе уже есть %d едениц керасина.\nСмешивать жидкости нельзя!", IsLoadTrailer[tempz1]);
						ShowPlayerDialog(playerid,CGUI+5,0,"::: Oil Help :::",s,"Ok","Cancel");
					} else {
						format(s,sizeof(s), "В вашем прицепе уже есть %d едениц бензина.\nСмешивать жидкости нельзя!", IsLoadTrailer[tempz1]);
						ShowPlayerDialog(playerid,CGUI+5,0,"::: Oil Help :::",s,"Ok","Cancel");
					}
				}
	}
TogglePlayerControllable(playerid, 1);
return 1;
}

public DialogPlayerDLS(playerid) // продажа керосина
{
if (!IsPlayerConnected(playerid)) return 0;
	new s[MAX_STRING];
	if (!IsPlayerInAnyVehicle(playerid)) // плаер пехом
	{
	format(s,sizeof(s), "Это грузовой портал. Приезжайте на грузовике с прицепом.");
	ShowPlayerDialog(playerid,CGUI+5,0,"::: Oil Help :::",s,"Ok","Cancel");
	} else if (GetVehicleModel(GetPlayerVehicleID(playerid)) != 403 && GetVehicleModel(GetPlayerVehicleID(playerid)) != 514 && GetVehicleModel(GetPlayerVehicleID(playerid)) != 515)
	{ // не грузовик
	format(s,sizeof(s), "Это грузовой портал. Приезжайте на грузовике с прицепом.");
	ShowPlayerDialog(playerid,CGUI+5,0,"::: Oil Help :::",s,"Ok","Cancel");
	} else if (!IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
	{ // без прицепа
	format(s,sizeof(s), "Это грузовой портал. Приезжайте на грузовике с прицепом 'цистерна'.");
	ShowPlayerDialog(playerid,CGUI+5,0,"::: Oil Help :::",s,"Ok","Cancel");
	} else if (GetVehicleModel(GetVehicleTrailer(GetPlayerVehicleID(playerid))) != 584)
	{ // не с цистерной
	format(s,sizeof(s), "Вам надо приехать c цистерной!", 0,COLOUR_GREEN);
	ShowPlayerDialog(playerid,CGUI+5,0,"::: Oil Help :::",s,"Ok","Cancel");
	} else 
	{
		new tempz1;
		for(new f=0; f < sizeof(LoadTrailer);f++)
		{
		    	if(GetVehicleTrailer(GetPlayerVehicleID(playerid)) == LoadTrailer[f])
	        	{
		       		tempz1 = f;
		        }
		}
		if (IsLoadTrailerTip[tempz1] != 2)
		{ // с пустой цистерной
			format(s,sizeof(s), "В вашем прицепе нет керасина!\n Приобретите керосин на ближайшем заводе.");
			ShowPlayerDialog(playerid,CGUI+5,0,"::: Oil Help :::",s,"Ok","Cancel");
		} else
		{	
			for (new i=0; i<TDLMARKERS; i++)
			{
				if (oIsPlayerInCheckpoint(playerid,TDLMarkersDest[i][Coord_X],TDLMarkersDest[i][Coord_Y],TDLMarkersDest[i][Coord_Z],8))
				{
					format(s,sizeof(s), "Продать все по цене %d$ за еденицу?\n У вас %d едениц керосина.",TDLMarkersDest[i][Coord_I]+600,IsLoadTrailer[tempz1]);
					ShowPlayerDialog(playerid,CGUI+8,0,":: Sell OIL ::",s,"Уes ","Cancel");
				}
			}
		}
	}
TogglePlayerControllable(playerid, 1);
return 1;
}

public DialogPlayerDLP(playerid) // переработка
{
if (!IsPlayerConnected(playerid)) return 0;
	new sd[MAX_STRING];
	if (oIsPlayerInCheckpoint(playerid,TDLMarkersProces[0][Coord_X],TDLMarkersProces[0][Coord_Y],TDLMarkersProces[0][Coord_Z],8))
	{
		format(sd,sizeof(sd), ":: Завод \'Willow field\' :: %d ед ::", IsLoadZavod[0]);
	} else if (oIsPlayerInCheckpoint(playerid,TDLMarkersProces[1][Coord_X],TDLMarkersProces[1][Coord_Y],TDLMarkersProces[1][Coord_Z],8))
	{
		format(sd,sizeof(sd), ":: Завод \'Easter bay chemicals\' :: %d ед ::", IsLoadZavod[1]);
	} else if (oIsPlayerInCheckpoint(playerid,TDLMarkersProces[2][Coord_X],TDLMarkersProces[2][Coord_Y],TDLMarkersProces[2][Coord_Z],8))
	{
		format(sd,sizeof(sd), ":: Завод \'K.A.C.C. military fuels\' :: %d ед ::", IsLoadZavod[2]);
	} else
	{
		SendPlayerFormattedText(playerid, "!!! ERROR d003 сообщите плиз админу!", 0,COLOUR_RED);
		TogglePlayerControllable(playerid, 1);
		return 1;
	}
	new s[MAX_STRING];
	format(s,sizeof(s), "Это грузовой портал. Приезжайте на грузовике с прицепом 'цистерна'.");
	if (!IsPlayerInAnyVehicle(playerid)) // плаер пехом
	{
	ShowPlayerDialog(playerid,CGUI+5,0,sd,s,"Ok","Cancel");
	} else if (GetVehicleModel(GetPlayerVehicleID(playerid)) != 403 && GetVehicleModel(GetPlayerVehicleID(playerid)) != 514 && GetVehicleModel(GetPlayerVehicleID(playerid)) != 515)
	{ // не грузовик
	ShowPlayerDialog(playerid,CGUI+5,0,sd,s,"Ok","Cancel");
	} else if (!IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
	{ // без прицепа
	ShowPlayerDialog(playerid,CGUI+5,0,sd,s,"Ok","Cancel");
	} else if (GetVehicleModel(GetVehicleTrailer(GetPlayerVehicleID(playerid))) != 584)
	{ // не с цистерной
	format(s,sizeof(s), "Вам надо приехать c цистерной!", 0,COLOUR_GREEN);
	ShowPlayerDialog(playerid,CGUI+5,0,sd,s,"Ok","Cancel");
	} else 
	{
		format(s,sizeof(s), "Вы хотите продать нефть?\nВы хотите купить керосин?\nВы хотите купить бензин?");
		ShowPlayerDialog(playerid,CGUI+9,2,sd,s,"Уes ","Cancel");
	}
TogglePlayerControllable(playerid, 1);
return 1;
}

public DialogPlayerDLE(playerid) // продажа бензина
{
if (!IsPlayerConnected(playerid)) return 0;
	new tempz2;
	new sd[MAX_STRING];
	// на какой азс игрок?
		for (new i=0; i<DALNAZSMARKERS; i++)
		{
			if (IsPlayerInSphere(playerid,TDMarkersPetrol[i][Coord_X],TDMarkersPetrol[i][Coord_Y],TDMarkersPetrol[i][Coord_Z],30))
			{
			tempz2 = i;
			format(sd,sizeof(sd), ":: АЗС %d ::", i+1);
			}
		}
	new s[MAX_STRING];
	if (!IsPlayerInAnyVehicle(playerid)) // плаер пехом
	{
	format(s,sizeof(s), "Это бензоколонка!\nВы можете тут запрпавися нитро,\nили доставить сюда бензин на продажу.");
	ShowPlayerDialog(playerid,CGUI+5,0,sd,s,"Ok","Cancel");
	} else if (GetVehicleModel(GetPlayerVehicleID(playerid)) != 403 && GetVehicleModel(GetPlayerVehicleID(playerid)) != 514 && GetVehicleModel(GetPlayerVehicleID(playerid)) != 515)
	{ // не грузовик
	format(s,sizeof(s), "Это бензоколонка!\nВы можете тут запрпавися нитро.\nДля этого наберите команду '/nitro'");
	ShowPlayerDialog(playerid,CGUI+5,0,sd,s,"Ok","Cancel");
	} else if (!IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
	{ // без прицепа
	format(s,sizeof(s), "Это бензоколонка!\nВы можете тут запрпавися нитро.\nДля этого наберите команду '/nitro'");
	ShowPlayerDialog(playerid,CGUI+5,0,sd,s,"Ok","Cancel");
	} else if (GetVehicleModel(GetVehicleTrailer(GetPlayerVehicleID(playerid))) != 584)
	{ // не с цистерной
	format(s,sizeof(s), "Это бензоколонка!\nВы можете тут запрпавися нитро.\nДля этого наберите команду '/nitro'", 0,COLOUR_GREEN);
	ShowPlayerDialog(playerid,CGUI+5,0,sd,s,"Ok","Cancel");
	} else 
	{
		new tempz1;
		for(new f=0; f < sizeof(LoadTrailer);f++)
		{
		    	if(GetVehicleTrailer(GetPlayerVehicleID(playerid)) == LoadTrailer[f])
	        	{
		       		tempz1 = f;
		        }
		}
		if (IsLoadTrailerTip[tempz1] != 3)
		{ // с пустой цистерной
			format(s,sizeof(s), "В вашем прицепе нет бензина!\n Приобретите бензин на ближайшем заводе.");
			ShowPlayerDialog(playerid,CGUI+5,0,sd,s,"Ok","Cancel");
		} else
		{	
			new benzocena=2000-CmdTimerComand[tempz2+2]; //CmdTimer - взял готовый чтоб не плодить - лень! ))) 2000 максимальная цена, когда колонка пустая 1 литр выветривается за 1 минуту
			format(s,sizeof(s), "АЗС %d \n Продать бензин по цене %d$ за еденицу?\n У вас %d едениц бензина.", tempz2+1, benzocena, IsLoadTrailer[tempz1]);
			ShowPlayerDialog(playerid,CGUI+12,0,sd,s,"Уes ","Cancel");
		}
	}
TogglePlayerControllable(playerid, 1);
return 1;
}


public DalnLog(string[])
{
	new File:hFile;
	if (!fexist("GTO/gto_daln.log"))
	{
		hFile=fopen("GTO/gto_daln.log",io_write);
		fclose(hFile);
	}
	new entry[MAX_STRING];
	format(entry, sizeof(entry), "%s\n",string);

	hFile = fopen("GTO/gto_daln.log", io_append);
	fwrite_utf8(hFile, entry);
	fclose(hFile);
	return;
}

public DalnZSaves(savepoint)
{
//	SendClientMessageToAll(COLOUR_LIGHTBLUE, "тик сохранения Завода");
	new filestring[256];
	new filedatstring[256];
	new DalnFilePath[MAX_STRING] = "GTO/Dalnoboy/";
	new entry;
	new temp[128];
		format(filestring,sizeof(filestring),"%szavod.txt",DalnFilePath);
		valstr(temp,savepoint);
		format(filedatstring,sizeof(filedatstring),"zavod%s",temp);
		entry = IsLoadZavod[savepoint];
	if (!dini_Exists(filestring)) return;
	valstr(temp,entry);
	dini_Set(filestring,filedatstring,temp);
	return;
}

/*
public DalnPSaves(savepoint)
{
	SendClientMessageToAll(COLOUR_LIGHTBLUE, "тик сохранения АЗС!");
	new filestring[256];
	new DalnFilePath[MAX_STRING] = "GTO/Dalnoboy/";
	new entry;
	new temp[128];
		valstr(temp,savepoint);
		format(filestring,sizeof(filestring),"%sazs%s.txt",DalnFilePath, temp);
		entry = CmdTimerComand[savepoint+2];
	if (!dini_Exists(filestring)) return;
	valstr(temp,entry);
	dini_Set(filestring,"load",temp);
	return;
}*/