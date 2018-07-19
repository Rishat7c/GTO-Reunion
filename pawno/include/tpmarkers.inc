forward OnPlayerEnterTPCheckpoint(playerid);
forward OnPlayerReadyToEnterTPCP(playerid);
forward IsPlayerAtTPC(playerid);
forward TPCInit();

#define TPMARKERS 12

new banner[27];

new Float:TPMarkersLoc[TPMARKERS][CoordInfo] = {
{2678.500,-1690.500,9.400}, //to st"8"
{-1407.000,-266.000,1040.000}, //to Idelwood

{-2125.3015,-444.1190,35.5344}, //на стадион гор2
{-1365.1656,931.7251,1036.1515}, //со стадиона в гор2

{1099.1719,1608.6260,12.5469}, //на стадион гор3
{-1436.0983,-635.4744,1049.6434}, //со стодиона в гор3

{1166.3785,1351.0072,10.9219}, //на стадион гор3 мото
{-1350.4274,1654.3477,1052.3638}, //с мотошколы

{-2071.6663,-502.5453,35.2303}, //на стадион гор2 колцо
{-1411.8481,893.3829,1041.1873}, //со страдиона

{2122.6118,1480.0587,10.8203}, //в бистро святого Марка
{-794.9582,489.5273,1376.1953} //из бистро в мир 0

};

/* мир
2122.6118,1480.0587,10.8203 вход в ресторан (из инт0)
2123.3008,1471.2034,10.8203 выход из ресторана (в инт0)

интерьер (bistro yard)
-794.7271,493.7477,1376.1953 куда поподаю войды с рест (инт1)
-794.9582,489.5273,1376.1953 дверь */

new Float:TPMarkersDest[TPMARKERS][CoordInfoEx] = {
{-1403.0000,-247.000,1043.000,7}, //st "8"
{2701.000,-1676.000,9.370,0}, //idelwood

{-1503.5779,960.8135,1036.9014,15}, //круглый с дм гор2
{-2120.6787,-409.7801,35.5313,0}, //возле стадиона гор 2

{-1293.6913,-707.1928,1056.1337,4}, //стадион внедорож гор3
{1077.3629,1608.5353,12.5469,0}, //возле стадиона гор3

{-1488.3859,1650.9994,1052.3690,14}, //стадион моторазвлекухи гор3
{1151.4023,1372.8003,10.6719,0}, //возле стадиона гор3 мото

{-1389.2142,905.6647,1041.1392,15}, //круглый гор2 круг
{-2020.5066,-502.5297,35.2303,0},

{-794.7271,493.7477,1376.1953,1}, //bistro SantMark
{2123.3008,1471.2034,10.8203,0} //kuda tp iz bistro

};

new TPMarkersVehTransfer[TPMARKERS] = {1,1, 1,1, 1,1, 1,1, 1,1, 0,0};

public TPCInit()
{
	for (new id=0;id<TPMARKERS;id++)
	{
		AddActiveCheckpoint(TPMarkersLoc[id][Coord_X],TPMarkersLoc[id][Coord_Y],TPMarkersLoc[id][Coord_Z],200,8);
		//AddStaticPickup(1273,49,HousesCP[id][Coord_X],HousesCP[id][Coord_Y],HousesCP[id][Coord_Z]);	//зеленый домик
		//CreateStreamMapIcon(31, HousesCP[id][Coord_X], HousesCP[id][Coord_Y], HousesCP[id][Coord_Z]);
	}
	WriteLog("TP checkpoints and icones initialised");
}

public IsPlayerAtTPC(playerid)
{
	for (new id=0;id<TPMARKERS;id++)
	{
		if (oIsPlayerInCheckpoint(playerid,TPMarkersLoc[id][Coord_X],TPMarkersLoc[id][Coord_Y],TPMarkersLoc[id][Coord_Z],8))
		{
			return 1;
		}
	}
	return 0;
}


public OnPlayerEnterTPCheckpoint(playerid)
{
	//if (playerid == INVALID_PLAYER_ID) return;
	//if (playerid == INVALIDX_PLAYER_ID) return;
	//if (!IsPlayerConnected(playerid)) return;
	if (!IsPlayerAtTPC(playerid)) return;
	
	SendPlayerFormattedText(playerid,  lang_texts[9][42]  , 0,COLOUR_GREEN);
	

	/* 
	for (new id=0;id<TPMARKERS;id++)
	{
		if (oIsPlayerInCheckpoint(playerid,TPMarkersLoc[id][Coord_X],TPMarkersLoc[id][Coord_Y],TPMarkersLoc[id][Coord_Z],8))
		{
			SetPlayerInterior(playerid,TPMarkersDest[id][Coord_I]);
			
			if( IsPlayerInAnyVehicle(playerid) )
			{
				new VehicleID;
				VehicleID = GetPlayerVehicleID(playerid);
				LinkVehicleToInterior(VehicleID,TPMarkersDest[id][Coord_I]);
				SetVehiclePosEx(VehicleID, TPMarkersDest[id][Coord_X], TPMarkersDest[id][Coord_Y], TPMarkersDest[id][Coord_Z] );
				}
				else
				{
				SetPlayerPosEx(playerid, TPMarkersDest[id][Coord_X], TPMarkersDest[id][Coord_Y], TPMarkersDest[id][Coord_Z]);
				}
			
			//new zone[MAX_NAME];
			//zone = GetXYZZoneName(TPMarkersDest[id][Coord_X], TPMarkersDest[id][Coord_Y], TPMarkersDest[id][Coord_Z])
			
			new temp[MAX_STRING];
			format(temp,sizeof(temp), lang_texts[9][41] ,GetXYZZoneName(TPMarkersDest[id][Coord_X], TPMarkersDest[id][Coord_Y], TPMarkersDest[id][Coord_Z]));
			SendPlayerFormattedText(playerid, temp, 0,COLOUR_GREEN);
		}
	} 
	*/

	
}

public OnPlayerReadyToEnterTPCP(playerid)
{
	if (playerid == INVALID_PLAYER_ID) return;
	if (playerid == INVALIDX_PLAYER_ID) return;
	if (!IsPlayerConnected(playerid)) return;
	new telego = -1;	
	for (new id=0;id<TPMARKERS;id++)
	{
		if (oIsPlayerInCheckpoint(playerid,TPMarkersLoc[id][Coord_X],TPMarkersLoc[id][Coord_Y],TPMarkersLoc[id][Coord_Z],8))
		{
			telego = id;
		}
	}

	SetPlayerInterior(playerid,TPMarkersDest[telego][Coord_I]);
	if(IsPlayerInAnyVehicle(playerid) && TPMarkersVehTransfer[telego] == 1)
	{
		new VehicleID;
		VehicleID = GetPlayerVehicleID(playerid);
		LinkVehicleToInterior(VehicleID,TPMarkersDest[telego][Coord_I]);
		SetVehiclePosEx(VehicleID, TPMarkersDest[telego][Coord_X], TPMarkersDest[telego][Coord_Y], TPMarkersDest[telego][Coord_Z]);
		// есть ли пассажиры в тачке тогда им тоже интерьер
		for (new i = 0; i < MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i))
			{
				if(IsPlayerInVehicle(i,GetPlayerVehicleID(playerid)) && GetPlayerVehicleSeat(i) != 0)
				{
					SetPlayerInterior(i, TPMarkersDest[telego][Coord_I]);
				}
			}
		}
	} else
	{
		SetPlayerPosEx(playerid, TPMarkersDest[telego][Coord_X], TPMarkersDest[telego][Coord_Y], TPMarkersDest[telego][Coord_Z]);
	}		
	new temp[MAX_STRING];
	format(temp,sizeof(temp), lang_texts[9][41] ,GetXYZZoneName(TPMarkersDest[telego][Coord_X], TPMarkersDest[telego][Coord_Y], TPMarkersDest[telego][Coord_Z]));
	SendPlayerFormattedText(playerid, temp, 0,COLOUR_GREEN);
}

forward Banner_ModeInit();
public Banner_ModeInit()
{
	banner[1] = CreateObject(4238, 2480.34, -1648.97, 20.59,   3.14, 0.00, 50.82); // баннеры
	banner[2] = CreateObject(4238, 2409.88, -1556.51, 41.77,   0.00, 0.00, 10.54);
	banner[3] = CreateObject(4238, 2289.94, -1553.82, 35.61,   0.00, 0.00, 30.04);
	banner[4] = CreateObject(4238, 1963.91, -1522.29, 24.74,   0.00, 0.00, 120.46);
	banner[5] = CreateObject(4238, 1887.38, -1549.65, 30.30,   0.00, 0.00, 152.76);
	banner[6] = CreateObject(4238, 1907.60, -1354.17, 25.71,   0.00, 0.00, 30.00);
	banner[7] = CreateObject(4238, 1751.68, -1483.69, 30.13,   0.00, 0.00, 70.00);
	banner[8] = CreateObject(4731, 1748.71, -1420.65, 41.38,   0.00, 0.00, 0.10);
	banner[9] = CreateObject(4238, 1353.76, -1713.58, 25.90,   0.00, 0.00, 120.00);
	banner[10] = CreateObject(4238, 1565.38, -1722.42, 31.11,   0.00, 0.00, 35.00);
	banner[11] = CreateObject(4238, 952.41, -1293.61, 25.40,   0.00, 0.00, -58.50);
	banner[12] = CreateObject(4238, 356.44, -1718.44, 27.11,   0.00, 0.00, -59.82);
	banner[13] = CreateObject(4238, 2069.28, 1503.00, 18.41,   0.00, 0.00, 30.28);
	banner[14] = CreateObject(4238, 2068.94, 1504.07, 18.41,   0.00, 0.00, 210.28);
	banner[15] = CreateObject(4238, 2046.38, 1484.41, 18.41,   0.00, 0.00, 210.28);
	banner[16] = CreateObject(4238, 2046.28, 1483.37, 18.41,   0.00, 0.00, 30.28);
	banner[17] = CreateObject(4238, 2046.02, 1302.34, 18.41,   0.00, 0.00, 30.28);
	banner[18] = CreateObject(4238, 2045.97, 1303.34, 18.41,   0.00, 0.00, 210.28);
	banner[19] = CreateObject(4238, 2068.60, 1341.92, 18.41,   0.00, 0.00, 30.28);
	banner[20] = CreateObject(4238, 2068.55, 1342.86, 18.41,   0.00, 0.00, 210.28);
	banner[21] = CreateObject(4238, 2046.53, 869.20, 14.46,   0.00, 0.00, 210.28);
	banner[22] = CreateObject(4238, 2046.40, 868.44, 14.46,   0.00, 0.00, 30.28);
	banner[23] = CreateObject(8332, 1787.74, 1077.03, 25.98,   0.00, 0.00, 0.24);
	banner[24] = CreateObject(7909, 1785.60, 1978.89, 25.27,   0.00, 0.00, 1.00);
	banner[25] = CreateObject(8310, 1775.72, 887.57, 29.78,   0.00, 0.00, -108.00); // напоминание о том что тут ДВЕ текстуры
	banner[26] = CreateObject(8293, 1624.80, 818.92, 27.42,   0.00, 0.00, 108.80); // напоминание о том что тут ДВЕ текстуры
	//end statik massiv
	SetObjectMaterialText(banner[1], "Добро пожаловать на сервер \n проекта GTO Reunion.\n наш сайт:\n {000000}www.{FF8000}vk.com{000000}/gto_reunion", 0, OBJECT_MATERIAL_SIZE_512x256,"Arial", 42, 0, 0xFFFF8000, 0xFFFFFFFF, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(banner[2], "GTO Reunion", 0, OBJECT_MATERIAL_SIZE_512x256,"Arial", 64, 0, 0xFFFF8000, 0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(banner[3], "www.{FF8000}vk.com{000000}/gto_reunion", 0, OBJECT_MATERIAL_SIZE_512x256,"Arial", 60, 0, 0xFF000000, 0xFFFFFFFF, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(banner[4], "Добро пожаловать на сервер \n проекта GTO Reunion.\n наш сайт:\n {000000}www.{FF8000}vk.com{000000}/gto_reunion", 0, OBJECT_MATERIAL_SIZE_512x256,"Arial", 42, 0, 0xFFFF8000, 0xFFFFFFFF, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(banner[5], "Коротко правила:\n   {FF8000}Не читерим.(Не юзаем баги.)\n   Не ругаемся.(Матом тем более.)\n   Не флудим и не рекламируем.\n   Не мешаем играть другим игрокам. ", 0, OBJECT_MATERIAL_SIZE_512x256,"Arial", 32, 0, 0xFFFF0000, 0xFFFFFFFF, OBJECT_MATERIAL_TEXT_ALIGN_LEFT);
	SetObjectMaterialText(banner[6], "Как играть? \n НАБЕРИ \n {008000}/inoob", 0, OBJECT_MATERIAL_SIZE_512x256,"Arial", 72, 0, 0xFFFF8000, 0xFFFFFFFF, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(banner[7], "Добро пожаловать на сервер \n проекта GTO Reunion.\n наш сайт:\n {000000}www.{FF8000}vk.com{000000}/gto_reunion", 0, OBJECT_MATERIAL_SIZE_512x256,"Arial", 42, 0, 0xFFFF8000, 0xFFFFFFFF, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(banner[8], "GTO Reunion", 0, OBJECT_MATERIAL_SIZE_512x256,"Arial", 64, 0, 0xFFFF8000, 0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(banner[9], "www.{FF8000}vk.com{000000}/gto_reunion", 0, OBJECT_MATERIAL_SIZE_512x256,"Arial", 60, 0, 0xFF000000, 0xFFFFFFFF, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(banner[10], "Добро пожаловать на сервер \n проекта GTO Reunion.\n наш сайт:\n {000000}www.{FF8000}vk.com{000000}/gto_reunion", 0, OBJECT_MATERIAL_SIZE_512x256,"Arial", 42, 0, 0xFFFF8000, 0xFFFFFFFF, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(banner[11], "Коротко правила:\n   {FF8000}Не читерим.(Не юзаем баги.)\n   Не ругаемся.(Матом тем более.)\n   Не флудим и не рекламируем.\n   Не мешаем играть другим игрокам.", 0, OBJECT_MATERIAL_SIZE_512x256,"Arial", 32, 0, 0xFFFF0000, 0xFFFFFFFF, OBJECT_MATERIAL_TEXT_ALIGN_LEFT);
	SetObjectMaterialText(banner[12], "Как играть? \n НАБЕРИ \n {008000}/inoob", 0, OBJECT_MATERIAL_SIZE_512x256,"Arial", 72, 0, 0xFFFF8000, 0xFFFFFFFF, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(banner[13], "РЕКЛАМА\n {008000}место сдается", 0, OBJECT_MATERIAL_SIZE_512x256,"Arial", 34, 0, 0xFFFFFFFF, 0xFF000088, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(banner[14], "РЕКЛАМА\n {008000}место сдается", 0, OBJECT_MATERIAL_SIZE_512x256,"Arial", 40, 0, 0xFFFF0000, 0xFFFF9900, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(banner[15], "GTO Reunion", 0, OBJECT_MATERIAL_SIZE_512x256,"Arial", 64, 0, 0xFFFF8000, 0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(banner[16], "РЕКЛАМА\n {008000} место сдается", 0, OBJECT_MATERIAL_SIZE_512x256,"Arial", 72, 0, 0xFFFF8000, 0xFFFFFFFF, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(banner[17], "www.{FF8000}vk.com{000000}/gto_reunion", 0, OBJECT_MATERIAL_SIZE_512x256,"Arial", 60, 0, 0xFF000000, 0xFFFFFFFF, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(banner[18], "GTO Reunion", 0, OBJECT_MATERIAL_SIZE_512x256,"Arial", 64, 0, 0xFFFF8000, 0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(banner[19], "РЕКЛАМА\n {008000}место сдается", 0, OBJECT_MATERIAL_SIZE_512x256,"Arial", 32, 0, 0xFFFF8000, 0xFFFFFFFF, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(banner[20], "РЕКЛАМА\n {008000}место сдается", 0, OBJECT_MATERIAL_SIZE_512x256,"Arial", 32, 0, 0xFFFF8000, 0xFFFFFFFF, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	//SetObjectMaterialText(banner[19], "Зарегистрируйтесь на нашем форме\n для общения и поддержки.\n www.gto-reunion.com", 0, OBJECT_MATERIAL_SIZE_512x256,"Arial", 34, 0, 0xFFFF8000, 0xFFFFFFFF, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	//SetObjectMaterialText(banner[20], "РЕКЛАМА\n {008000} место сдается", 0, OBJECT_MATERIAL_SIZE_512x256,"Arial", 72, 0, 0xFFFF8000, 0xFFFFFFFF, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(banner[21], "Правила вы можете узнать\n при помощи команды {008000}/rules{FF8000}\n или на нашем сайте\n www.vk.com/gto_reunion", 0, OBJECT_MATERIAL_SIZE_512x256,"Arial", 40, 0, 0xFFFF8000, 0xFFFFFFFF, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(banner[22], "GTO Reunion", 0, OBJECT_MATERIAL_SIZE_512x256,"Arial", 64, 0, 0xFFFF8000, 0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(banner[23], "Как играть? \n НАБЕРИ \n {008000}/inoob", 0, OBJECT_MATERIAL_SIZE_512x256,"Arial", 72, 0, 0xFFFF8000, 0xFFFFFFFF, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(banner[24], "www.{FF8000}vk.com{000000}/gto_reunion", 0, OBJECT_MATERIAL_SIZE_512x256,"Arial", 60, 0, 0xFF000000, 0xFFFFFFFF, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(banner[25], "GTO Reunion", 2, OBJECT_MATERIAL_SIZE_512x256,"Arial", 64, 0, 0xFFFF8000, 0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(banner[25], "www.{FF8000}vk.com{000000}/gto_reunion", 3, OBJECT_MATERIAL_SIZE_512x256,"Arial", 60, 0, 0xFF000000, 0xFFFFFFFF, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(banner[26], "РЕКЛАМА\n {008000}место сдается", 0, OBJECT_MATERIAL_SIZE_512x256,"Arial", 72, 0, 0xFFFF8000, 0xFFFFFFFF, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(banner[26], "РЕКЛАМА\n {008000}место сдается", 1, OBJECT_MATERIAL_SIZE_512x256,"Arial", 72, 0, 0xFFFF8000, 0xFFFFFFFF, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	return 1;
}
