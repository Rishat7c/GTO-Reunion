#if defined _train_included
#endinput
#endif

#define _train_included
#pragma library train

#define chek_1 1
#define chek_2 2
#define chek_3 3
#define chek_4 4
#define chek_5 5
#define chek_6 6
#define chek_7 7
#define chek_8 8
new chekstat[MAX_PLAYERS];
new Actor1[MAX_PLAYERS];
new Actor2[MAX_PLAYERS];
new Actor3[MAX_PLAYERS];
new statdm[MAX_PLAYERS];
new PlayerText3D:actortext1;
new PlayerText3D:actortext2;
new PlayerText3D:actortext3;

forward train_OnPlayerDisconnect(playerid);
public train_OnPlayerDisconnect(playerid)
{
	if(Player[playerid][train1] == 1)
	{
		Player[playerid][train1] = 0;
		DestroyVehicle(TrainingVehicle[playerid][train_indus1]);
		TrainingVehicle[playerid][train_indus1] = INVALID_VEHICLE_ID;
		DestroyVehicle(TrainingVehicle[playerid][train_indus2]);
		TrainingVehicle[playerid][train_indus2] = INVALID_VEHICLE_ID;
		DestroyVehicle(TrainingVehicle[playerid][train_indus3]);
		TrainingVehicle[playerid][train_indus3] = INVALID_VEHICLE_ID;
		DestroyVehicle(TrainingVehicle[playerid][train_indus4]);
		TrainingVehicle[playerid][train_indus4] = INVALID_VEHICLE_ID;
        ResetQuest(playerid);
	} else if(Player[playerid][train2] == 1)
	{
	    Player[playerid][train2] = 0;
	    
		DestroyVehicle(TrainingVehicle[playerid][train_race]);
		TrainingVehicle[playerid][train_race] = INVALID_VEHICLE_ID;
		
		oDisablePlayerRaceCheckpoint(playerid);
		chekstat[playerid] = 0;
		ResetQuest(playerid);
	} else if(Player[playerid][train3] == 1)
	{
	    Player[playerid][train3] = 0;
 		DestroyActor(Actor1[playerid]);
 		DestroyActor(Actor2[playerid]);
 		DestroyActor(Actor3[playerid]);
   		RemovePlayerMapIcon(playerid,91);
   		RemovePlayerMapIcon(playerid,92);
   		RemovePlayerMapIcon(playerid,93);
     	DeletePlayer3DTextLabel(playerid, actortext1);
     	DeletePlayer3DTextLabel(playerid, actortext2);
     	DeletePlayer3DTextLabel(playerid, actortext3);
      	statdm[playerid]=0;
      	ResetQuest(playerid);
	}
}

forward train_OnPlayerSpawn(playerid);
public train_OnPlayerSpawn(playerid)
{
	if(Player[playerid][train1] + Player[playerid][train2] + Player[playerid][train3] + Player[playerid][train4] < 6)
	{
	    // Установка виртуального мира 500 + ID игрока (Планируемый лимит на слоты MAX = 100)
	    oSetPlayerVirtualWorld(playerid,500+playerid); // Виртуальный мир
	    //
	    new list[MAX_STRING]; format(list, 32, "Статус\tНаименование\tОпыт\n");
		if(Player[playerid][train4] != 2)
		{
			format(list,sizeof(list),"%s\n {808080}[НЕ ВЫПОЛНЕНО]\tТеоретический материал\t+250 XP\n",list);
		}
		else
		{
			format(list,sizeof(list),"%s\n {008000}[ВЫПОЛНЕНО]\tТеоретический материал\t{00BFFF}+250 XP\n",list);
		}
		if(Player[playerid][train2] != 2)
		{
			format(list,sizeof(list),"%s\n {808080}[НЕ ВЫПОЛНЕНО]\tОбучение Гонщика\t+850 XP\n",list);
		}
		else
		{
			format(list,sizeof(list),"%s\n {008000}[ВЫПОЛНЕНО]\tОбучение Гонщика\t{00BFFF}+850 XP\n",list);
		}
		if(Player[playerid][train3] != 2)
		{
			format(list,sizeof(list),"%s\n {808080}[НЕ ВЫПОЛНЕНО]\tОбучение ДМ режима\t+850 XP\n",list);
		}
		else
		{
			format(list,sizeof(list),"%s\n {008000}[ВЫПОЛНЕНО]\tОбучение ДМ режима\t{00BFFF}+850 XP\n",list);
		}
		if(Player[playerid][train1] != 2)
		{
			format(list,sizeof(list),"%s\n {808080}[НЕ ВЫПОЛНЕНО]\tОбучение Дальнобойщика\t+850 XP\n",list);
		}
		else
		{
			format(list,sizeof(list),"%s\n {008000}[ВЫПОЛНЕНО]\tОбучение Дальнобойщика\t{00BFFF}+850 XP\n",list);
		}
		ShowPlayerDialog(playerid, TGUI, DIALOG_STYLE_TABLIST_HEADERS, "Обучение", list, "ОК", "");
	}
	return 1;
}

forward StartTrain1(playerid);
public StartTrain1(playerid)
{
if(Player[playerid][train1] != 2)
{
	// Диалог информации о миссии
	new str[1024];
	format(str,sizeof(str),"{ffffff}Привет, друг. Перед тобой находится грузовик, сядь в него и прицепи прицеп.\
	\nПосле встанешь на красный круг (чекпоинт) и свяжешься с диспетчером командой {CD853F}'/trade'\
	\n{ffffff}В меню необходимо будет выбрать подходящий товар под Ваш прицеп.\
	\nПомни, время ограничено");
	ShowPlayerDialog(playerid,TGUI+1,0,"::: Los Santos Logistics :::",str,"Приступить","");
	// ТП На место доставки груза
	SetPlayerPosEx(playerid,2237.9006,-2236.5847,13.5547);
	SetPlayerInterior(playerid,0);
	Player[playerid][train1] = 1;
	ResetQuest(playerid);
	oSetPlayerVirtualWorld(playerid,500+playerid); // Виртуальный мир
} else {
	new string[MAX_STRING];
	format(string,sizeof(string),"[Обучение] Вы уже выполнили обучение Дальнобойщика");
	SendClientMessage(playerid, COLOUR_RED, string);
 	train_OnPlayerSpawn(playerid);
}
return 1;
}

forward StartTrain2(playerid);
public StartTrain2(playerid)
{
if(Player[playerid][train2] != 2)
{
    //printf("Сработал StartTrain2");
    oSetPlayerVirtualWorld(playerid,500+playerid); // Виртуальный мир
   	new str[1024];
	format(str,sizeof(str),"Привет, друг. Хочу познакомить тебя с эвентом гонки. Это обучаю курс, поэтому соперников у тебя не будет.\
	\nСтарт происходит после того, как о начале гонки объявят в общем чате. В заданное место необходимо будет приехать с машиной\
	\nОбрати внимание, что у каждой гонки есть минимальный уровень для участия. Чем Выше уровень гонки, тем больше сумеешь заработать опыта\
	\nТеперь садись в тачку и следуй по указанным чекпоинтам.");
	ShowPlayerDialog(playerid,TGUI+2,0,"::: Race: Training Track [id -1] :::",str,"Приступить","Назад");
	SetPlayerPosEx(playerid,-2869.0012,-896.5919,8.9544);
	SetPlayerInterior(playerid,0);
	TrainingVehicle[playerid][train_race] = CreateVehicle(415,-2872.5903,-917.4955,9.4844,169.9281,-1,-1,Truck_Resp); // cheetah
	SetVehicleVirtualWorld ( TrainingVehicle[playerid][train_race], 500+playerid );
	PutPlayerInVehicle(playerid, TrainingVehicle[playerid][train_race], 0);
	PlayerQuest[playerid] = 500+playerid; // Для выхода с эвента ResetQuest(playerid);
	Player[playerid][train2] = 1;
	//printf("PlayerQuest = %d", 500+playerid);
	
	chekstat[playerid] = chek_1;
	oSetPlayerRaceCheckpoint(playerid,0,-2883.2229,-966.3828,9.4922,-2917.7002,-1208.1135,9.1478,8);
} else {
	new string[MAX_STRING];
	format(string,sizeof(string),"[Обучение] Вы уже выполнили обучение Гонщика");
	SendClientMessage(playerid, COLOUR_RED, string);
	train_OnPlayerSpawn(playerid);
}
return 1;
}

forward StartTrain3(playerid);
public StartTrain3(playerid)
{
if(Player[playerid][train3] != 2)
{
    //printf("Сработал StartTrain3");
    oSetPlayerVirtualWorld(playerid,500+playerid); // Виртуальный мир
   	new str[1024];
	format(str,sizeof(str),"Привет, друг. Хочу познакомить тебя с эвентом ДМ. Это обучаю курс, поэтому в качестве соперников у тебя будут боты.\
	\nОбъявление старта ДМ-режима происходит аналогично режиму гонок. После обучающего режима вместо ботов будут реальные игроки\
	\nОбрати внимание, что у каждого ДМ есть минимальный уровень для участия. ДМ подразделяются на командные и единоличные\
	\nЗадача: Уничтожить всех ботов в деревушке [npcid 3]");
	ShowPlayerDialog(playerid,TGUI+3,0,"::: Deathmatch: Training Area [id -1] :::",str,"Приступить","Закрыть");
	SetPlayerPosEx(playerid,-333.2594,2221.3345,42.4884);
	SetPlayerInterior(playerid,0);
	Actor1[playerid] = CreateActor(285,-379.4301,2206.2708,42.2359,284.4829); // SWAT
	SetActorInvulnerable(Actor1[playerid], 0);
	SetActorHealth(Actor1[playerid],100);
	SetActorVirtualWorld(Actor1[playerid], 500+playerid);
	ApplyActorAnimation(Actor1[playerid], "COLT45", "colt45_fire_2hands", 4.1, 0, 0, 0, 0, 0); // Анимация оплаты
	Actor2[playerid] = CreateActor(287,-421.5788,2239.4734,42.4297,273.5396); // Army
	SetActorInvulnerable(Actor2[playerid], 0);
	SetActorHealth(Actor2[playerid],100);
	SetActorVirtualWorld(Actor2[playerid], 500+playerid);
	ApplyActorAnimation(Actor2[playerid], "SHOTGUN", "shotgun_fire", 4.1, 0, 0, 0, 0, 0); // Анимация оплаты
	Actor3[playerid] = CreateActor(121,-379.4373,2263.3198,42.4844,182.9854); // Killer
	SetActorInvulnerable(Actor3[playerid], 0);
	SetActorHealth(Actor3[playerid],100);
	SetActorVirtualWorld(Actor3[playerid], 500+playerid);
	ApplyActorAnimation(Actor3[playerid], "UZI", "UZI_fire", 4.1, 0, 0, 0, 0, 0); // Анимация оплаты
	statdm[playerid] = 0;
	Player[playerid][train3] = 1;
	PlayerQuest[playerid] = 500+playerid; // Для выхода с эвента ResetQuest(playerid);
	
	SetPlayerMapIcon(playerid, 91, -379.4301,2206.2708,42.2359, 58, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 92, -421.5788,2239.4734,42.4297, 60, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, 93, -379.4373,2263.3198,42.4844, 62, 0, MAPICON_LOCAL);
	
	oGivePlayerWeapon(playerid,31,400);
	oGivePlayerWeapon(playerid,29,300);
	
	new temp[MAX_STRING];
 	new name[MAX_STRING];
    GetPlayerName(playerid, name, sizeof(name));
	format(temp,sizeof(temp), "Сегодня ты умрешь, %s\nЧертов ублюдок!", name);
	
	actortext1=CreatePlayer3DTextLabel(playerid,temp,COLOUR_WHITE,-379.4301,2206.2708,42.2359+1,40.0);
	actortext2=CreatePlayer3DTextLabel(playerid,"Я возвышусь — ты падешь!",COLOUR_BLUE,-421.5788,2239.4734,42.4297+1,40.0);
	actortext3=CreatePlayer3DTextLabel(playerid,"Выстрельнешь, и за тобой сразу выедут\nКомнатный снайпер",COLOUR_RED,-379.4373,2263.3198,42.4844+1,40.0);
} else {
	new string[MAX_STRING];
	format(string,sizeof(string),"[Обучение] Вы уже выполнили обучение ДМ режима");
	SendClientMessage(playerid, COLOUR_RED, string);
	train_OnPlayerSpawn(playerid);
}
return 1;
}

forward StartTrain4(playerid);
public StartTrain4(playerid)
{
if(Player[playerid][train4] != 2)
{
 	DialogPlayerHelp(playerid, 3);
 	Player[playerid][train4] = 1;
} else {
	new string[MAX_STRING];
	format(string,sizeof(string),"[Обучение] Вы уже выполнили обучение Теоретическую часть");
	SendClientMessage(playerid, COLOUR_RED, string);
 	train_OnPlayerSpawn(playerid);
}
return 1;
}

/// Мусор автовызываемых пабликов
forward Train2_OnPlayerEnterRaceCP(playerid);
public Train2_OnPlayerEnterRaceCP(playerid)
{
	switch(chekstat[playerid])
	{
		case chek_1:
		{
			oSetPlayerRaceCheckpoint(playerid,0,-2917.7002,-1208.1135,9.1478,-2935.0635,-1522.7023,10.7798,8);
			chekstat[playerid] = chek_2;
			if(Player[playerid][train2] == 1)
			{
			ShowPlayerDialog(playerid, S_GUI_02, 0,"Подсказка","Следуй по красным чекпоинтам на карте \nПостарайся не повредить автомобиль \nУдачного пути, друг мой!","ОК","");
			}
		}
		case chek_2:
		{
			oSetPlayerRaceCheckpoint(playerid,0,-2935.0635,-1522.7023,10.7798,-2865.7554,-1823.5706,37.6858,8);
			chekstat[playerid] = chek_3;//
		}
		case chek_3:
		{
			oSetPlayerRaceCheckpoint(playerid,0,-2865.7554,-1823.5706,37.6858,-2694.8379,-2019.2948,43.8409,8);
			chekstat[playerid] = chek_4;//
		}
		case chek_4:
		{
			oSetPlayerRaceCheckpoint(playerid,0,-2694.8379,-2019.2948,43.8409,-2503.7356,-2195.5847,28.8877,8);
			chekstat[playerid] = chek_5;//
		}
		case chek_5:
		{
			oSetPlayerRaceCheckpoint(playerid,0,-2503.7356,-2195.5847,28.8877,-2408.2029,-2281.3904,14.6292,8);
			chekstat[playerid] = chek_6;//
		}
		case chek_6:
		{
			oSetPlayerRaceCheckpoint(playerid,0,-2408.2029,-2281.3904,14.6292,-2344.5518,-2239.8413,18.4922,8);
			chekstat[playerid] = chek_7;//
		}
		case chek_7:
		{
			oSetPlayerRaceCheckpoint(playerid,1,-2344.5518,-2239.8413,18.4922,-2344.5518,-2239.8413,18.4922,8);
			chekstat[playerid] = chek_8;//
		}
		case chek_8:
		{
			oDisablePlayerRaceCheckpoint(playerid);
			chekstat[playerid] = 0;
			
   			Player[playerid][train2] = 2;
   			GivePlayerXP(playerid, 850, 1);
   			DestroyVehicle(TrainingVehicle[playerid][train_race]);
   			TrainingVehicle[playerid][train_race] = INVALID_VEHICLE_ID;
   			OnPlayerSpawn(playerid);
   			ResetQuest(playerid);
   			oSetPlayerVirtualWorld(playerid,0); // Виртуальный мир
		}
	}
	return 1;
}

public OnPlayerGiveDamageActor(playerid, damaged_actorid, Float: amount, weaponid, bodypart)
{
    new Float:actorHealth;
    
	if(Actor1[playerid] || Actor2[playerid] || Actor3[playerid])
	{
	    //printf("Сработал If где стоят ||. Урон = %.0f, Здоровья = %.2f",amount,GetActorHealth(damaged_actorid, actorHealth));
	    if(GetActorHealth(damaged_actorid, actorHealth) < 10)
	    {
	        DestroyActor(damaged_actorid);
	        //RemovePlayerMapIcon(playerid, damaged_actorid+91);
	        //DeletePlayer3DTextLabel(playerid, damaged_actorid);
	        statdm[playerid]++;
	        if(statdm[playerid]==1)
	        {
	            ShowPlayerDialog(playerid, S_GUI_02, 0,"Подсказка","Молодец, уничтожь ещё двух ботов!","ОК","");
	        }
	        if(statdm[playerid]>=3)
	        {
      			Player[playerid][train3]=2;
   				GivePlayerXP(playerid, 850, 1);
             	OnPlayerSpawn(playerid);
     			oGivePlayerWeapon(playerid,31,-400);
				oGivePlayerWeapon(playerid,29,-300);
				ResetQuest(playerid);
				oSetPlayerVirtualWorld(playerid,0); // Виртуальный мир
	        }
	        if(damaged_actorid == Actor1[playerid])
	        {
       			RemovePlayerMapIcon(playerid,91);
     			DeletePlayer3DTextLabel(playerid, actortext1);
	        }
        	if(damaged_actorid == Actor2[playerid])
	        {
       			RemovePlayerMapIcon(playerid,92);
     			DeletePlayer3DTextLabel(playerid, actortext2);
	        }
        	if(damaged_actorid == Actor3[playerid])
	        {
       			RemovePlayerMapIcon(playerid,93);
     			DeletePlayer3DTextLabel(playerid, actortext3);
	        }
	    }
	}
    return 1;
}

forward train1_OnPlayerEnterVehicle(playerid, vehicleid, ispassenger);
public train1_OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	if(Player[playerid][train1] == 1)
	{
        if(vehicleid == TrainingVehicle[playerid][train_indus2])
        {
            ShowPlayerDialog(playerid, S_GUI_02, 0,"Подсказка","Прицепи нужный прицеп \nДля отцепления нажми кнопку '2' иди '+' \nПосле того как возьмешь прицеп встань на маркер и введи '/trade'","ОК","");
        }
	}
    return 1;
}
