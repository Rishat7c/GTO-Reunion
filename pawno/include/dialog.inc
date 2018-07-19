// GUI Engine

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
if( dialogid == S_GUI_01 ) { TogglePlayerControllable(playerid, 1); return 1; }
if( dialogid == S_GUI_02 ) { return 1; }
//B_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
//--------------------[ GGUI ]--------------------------------------- >
if(dialogid == GGUI) // Gang -> if leader leave gang
 {
	if(response)
	{
	new gangid = PlayerGangID[playerid];
	if(gangid == -1) {return 1;}
	GangRemoveMember(gangid,PlayerSQLID[playerid],0);
	if (Gangs[gangid][gang_active])
			{
			if(!GangCleanup(gangid))
			{GangSave(gangid);}
			}
	}
	else { TogglePlayerControllable(playerid, 1); }
	return 1;
 }
//--------------------[ GGUI end ]----------------------------------- <

if(dialogid == CGUI+1) // в правилах коротко
 {
	if(response)
	{
	DialogPlayerHelp(playerid, 1);
	}
	else { TogglePlayerControllable(playerid, 1); }
	return 1;
 }

if(dialogid == CGUI+2) // правила лист 1
 {
	if(response)
	{
	DialogPlayerHelp(playerid, 2);
	}
	else { TogglePlayerControllable(playerid, 1); }
	return 1;

 }

if(dialogid == CGUI+3) // в правилах лист 2
 {
	if(response)
	{
	DialogPlayerHelp(playerid, 3);
	}
	else { DialogPlayerHelp(playerid, 1); }
	return 1;
 }

if(dialogid == CGUI+4) // о гто
 {
	if(response)
	{
	DialogPlayerHelp(playerid, 1);
	
	if(Player[playerid][train1] + Player[playerid][train2] + Player[playerid][train3] + Player[playerid][train4] < 6)
	{
	if(Player[playerid][train4] != 2)
	{
		Player[playerid][train4]=2;
		GivePlayerXP(playerid, 250, 1);
		OnPlayerSpawn(playerid);
		oSetPlayerVirtualWorld(playerid,0); // Виртуальный мир
	}
	} else {
		Player[playerid][train4]=2;
	}
	
	}
	else
	{
		TogglePlayerControllable(playerid, 1);
		
		if(Player[playerid][train1] + Player[playerid][train2] + Player[playerid][train3] + Player[playerid][train4] < 6)
		{
		if(Player[playerid][train4] != 2)
		{
			Player[playerid][train4]=2;
			GivePlayerXP(playerid, 250, 1);
			OnPlayerSpawn(playerid);
			oSetPlayerVirtualWorld(playerid,0); // Виртуальный мир
		}
		} else {
			Player[playerid][train4]=2;
		}
	
	}
	return 1;
 }

if(dialogid == CGUI+6) // Tun Shop`s
 {
	if(response)
	{
	//buy
		if (GetPlayerVehicleID(playerid) == TunCar[0])
		{	
			PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);  
			oGivePlayerMoney(playerid,-5000,0);
			IsCarTun[0] = 2;
//			Businesses[27][Business_Vault]=Businesses[27][Business_Vault]+5000; //первый магаз
			SendClientMessage(playerid, COLOUR_GREEN, "Счастливого пути!");
			return 1;
		} else if (GetPlayerVehicleID(playerid) == TunCar[1])
		{	
			PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);  
			oGivePlayerMoney(playerid,-3000,0);
			IsCarTun[1] = 2;
//			Businesses[27][Business_Vault]=Businesses[27][Business_Vault]+3000; //первый магаз
			SendClientMessage(playerid, COLOUR_GREEN, "Счастливого пути!");
			return 1;
		} else if (GetPlayerVehicleID(playerid) == TunCar[2])
		{	
			PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);  
			oGivePlayerMoney(playerid,-1000,0);
			IsCarTun[2] = 2;
//			Businesses[27][Business_Vault]=Businesses[27][Business_Vault]+1000; //первый магаз
			SendClientMessage(playerid, COLOUR_GREEN, "Счастливого пути!");
			return 1;
		} else if (GetPlayerVehicleID(playerid) == TunCar[3])
		{	
			PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);  
			oGivePlayerMoney(playerid,-1000,0);
			IsCarTun[3] = 2;
//			Businesses[27][Business_Vault]=Businesses[27][Business_Vault]+1000; //первый магаз
			SendClientMessage(playerid, COLOUR_GREEN, "Счастливого пути!");
			return 1;
		} else if (GetPlayerVehicleID(playerid) == TunCar[4])
		{	
			PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);  
			oGivePlayerMoney(playerid,-1000,0);
			IsCarTun[4] = 2;
			SendClientMessage(playerid, COLOUR_GREEN, "Счастливого пути!");
			return 1;
		} else if (GetPlayerVehicleID(playerid) == TunCar[5])
		{	
			PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);  
			oGivePlayerMoney(playerid,-1000,0);
			IsCarTun[5] = 2;
//			Businesses[27][Business_Vault]=Businesses[27][Business_Vault]+1000; //первый магаз
			SendClientMessage(playerid, COLOUR_GREEN, "Счастливого пути!");
			return 1;
		} else if (GetPlayerVehicleID(playerid) == TunCar[6])
		{	
			PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);  
			oGivePlayerMoney(playerid,-1500,0);
			IsCarTun[6] = 2;
//			Businesses[27][Business_Vault]=Businesses[27][Business_Vault]+1500; //первый магаз
			SendClientMessage(playerid, COLOUR_GREEN, "Счастливого пути!");
			return 1;
		} else if (GetPlayerVehicleID(playerid) == TunCar[7])
		{	
			PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);  
			oGivePlayerMoney(playerid,-1000,0);
			IsCarTun[7] = 2;
//			Businesses[27][Business_Vault]=Businesses[27][Business_Vault]+1000; //первый магаз
			SendClientMessage(playerid, COLOUR_GREEN, "Счастливого пути!");
			return 1;
		} else if (GetPlayerVehicleID(playerid) == TunCar[8])
		{	
			PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);  
			oGivePlayerMoney(playerid,-1000,0);
			IsCarTun[8] = 2;
//			Businesses[27][Business_Vault]=Businesses[27][Business_Vault]+1000; //первый магаз
			SendClientMessage(playerid, COLOUR_GREEN, "Счастливого пути!");
			return 1;
		} else if (GetPlayerVehicleID(playerid) == TunCar[9])
		{	
			PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);  
			oGivePlayerMoney(playerid,-1500,0);
			IsCarTun[9] = 2;
//			Businesses[26][Business_Vault]=Businesses[26][Business_Vault]+1500; //второй магаз
			SendClientMessage(playerid, COLOUR_GREEN, "Счастливого пути!");
			return 1;
		} else if (GetPlayerVehicleID(playerid) == TunCar[10])
		{	
			PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);  
			oGivePlayerMoney(playerid,-5000,0);
			IsCarTun[10] = 2;
//			Businesses[26][Business_Vault]=Businesses[26][Business_Vault]+5000; //второй магаз
			SendClientMessage(playerid, COLOUR_GREEN, "Счастливого пути!");
			return 1;
		} else if (GetPlayerVehicleID(playerid) == TunCar[11])
		{	
			PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);  
			oGivePlayerMoney(playerid,-1000,0);
			IsCarTun[11] = 2;
//			Businesses[26][Business_Vault]=Businesses[26][Business_Vault]+1000; //второй магаз
			SendClientMessage(playerid, COLOUR_GREEN, "Счастливого пути!");
			return 1;
		} else if (GetPlayerVehicleID(playerid) == TunCar[12])
		{	
			PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);  
			oGivePlayerMoney(playerid,-5000,0);
			IsCarTun[12] = 2;
//			Businesses[26][Business_Vault]=Businesses[26][Business_Vault]+5000; //второй магаз
			SendClientMessage(playerid, COLOUR_GREEN, "Счастливого пути!");
			return 1;
		} else if (GetPlayerVehicleID(playerid) == TunCar[13])
		{	
			PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);  
			oGivePlayerMoney(playerid,-3000,0);
			IsCarTun[13] = 2;
//			Businesses[26][Business_Vault]=Businesses[26][Business_Vault]+3000; //второй магаз
			SendClientMessage(playerid, COLOUR_GREEN, "Счастливого пути!");
			return 1;
		} else if (GetPlayerVehicleID(playerid) == TunCar[14])
		{	
			PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);  
			oGivePlayerMoney(playerid,-1000,0);
			IsCarTun[14] = 2;
//			Businesses[26][Business_Vault]=Businesses[26][Business_Vault]+1000; //второй магаз
			SendClientMessage(playerid, COLOUR_GREEN, "Счастливого пути!");
			return 1;
		} else if (GetPlayerVehicleID(playerid) == TunCar[15])
		{	
			PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);  
			oGivePlayerMoney(playerid,-1000,0);
			IsCarTun[15] = 2;
//			Businesses[26][Business_Vault]=Businesses[26][Business_Vault]+1000; //второй магаз
			SendClientMessage(playerid, COLOUR_GREEN, "Счастливого пути!");
			return 1;
		} else // 16
		{	
			PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);  
			oGivePlayerMoney(playerid,-10000,0);
			IsCarTun[16] = 2;
//			Businesses[26][Business_Vault]=Businesses[26][Business_Vault]+10000; //второй магаз
			SendClientMessage(playerid, COLOUR_GREEN, "Счастливого пути!");
			return 1;
		}
	}
	else {
	//cancel
	TogglePlayerControllable(playerid, 1);
	RemovePlayerFromVehicle(playerid);
	return 1;
	}
 }

// --------------------------------------------------------------------------------------------

if(dialogid == CGUI+5) // Дальнобойщики диалог HELP
 {
	if(response)
	{
	TradePlayerHelp(playerid);
	}
	else { TogglePlayerControllable(playerid, 1); }
	return 1;

 }
 
 if(dialogid == CGUI+9) // Дальнобойщики пуcтой инфо-диалог
 {
	if(response){TogglePlayerControllable(playerid, 1);}
	else{
	TradePlayerHelp(playerid);}
 
 return 1;
 }
 
 if(dialogid == CGUI+7) // Дальнобойщики диалог Выбор миссии
 {
	if(response)
	{
	PlayerGetTradeMission(playerid,listitem);
	}
	else { TradePlayerHelp(playerid); }
	return 1;

 }
 
 if(dialogid == CGUI+8) // Дальнобойщики диалог Половина цены
 {
	if(response)
	{
	HalfPriceTrade(playerid);
	}
	else { TogglePlayerControllable(playerid, 1); }
	return 1;

 }
 
 if(dialogid == CGUI+10) // Дальнобойщики первый лист правил
 {
	if(response)
	{
	TogglePlayerControllable(playerid, 1);
	}
	else { TradePlayerHelp2(playerid); }
	return 1;
 }

 if(dialogid == CGUI+11) // Дальнобойщики - игрок сел в машину
 {
	if(response)
	{
	PlayerJoinTradeMission( playerid ); // да, принять участие
	}
	else { RemovePlayerFromVehicle(playerid); } // нее, ну нахрен
	return 1;
 }

//---------------- house menu
if(dialogid == HGUI+1)
{
	if(response)
	{
		if(listitem == 0) {FHouseInfo(playerid);DialogPlayerHouse(playerid);}
		if(listitem == 1) {FHouseBuy(playerid);DialogPlayerHouse(playerid);}
		if(listitem == 2) {FHouseSell(playerid);DialogPlayerHouse(playerid);}
		if(listitem == 3) 
		{
			new id=GetHouseID(playerid);
			new s[MAX_STRING];
			format(s,sizeof(s), "Задолженность за содержание дома составляет\n\t--- %d $ ---\n[ Прекращение обслуживания через %d часов ]\nСколько вы хотите внести?",Houses[id][Houses_UpKeepLeft],GetKeepTime(id));
			ShowPlayerDialog(playerid, HGUI+2, DIALOG_STYLE_INPUT, "Внос денег", s, "Внести", "Назад");
		}
		if(listitem == 4) {FHouseHouses(playerid);DialogPlayerHouse(playerid);}
		if(listitem == 5) {FHouseEnter(playerid);TogglePlayerControllable(playerid,1);}
	}
	else { TogglePlayerControllable(playerid, 1); }
	return 1;
}

if(dialogid == HGUI+2)
 {
	if(response)
	{
		FHouseKeep(playerid, strval(inputtext));
		DialogPlayerHouse(playerid);
	}
	else
	{
		DialogPlayerHouse(playerid);
	}
	return 1;
 }

//----------------- анд бизнесы
/*if(dialogid == HGUI+3)
{
	if(response)
	{
		if(listitem == 0) {FBisInfo(playerid);}
		if(listitem == 1) {FBisBuy(playerid);}
		if(listitem == 2) {FBisSell(playerid);}
		if(listitem == 3) {FBisCollect(playerid);}
		if(listitem == 4) {FBisMyBises(playerid);}
		if(listitem == 5) {FBisBises(playerid);}
		TogglePlayerControllable(playerid, 1);
	}
	else { TogglePlayerControllable(playerid, 1); }
	return 1;
}*/
if(dialogid == 430)
{
       if(response)
       {
         TogglePlayerControllable(playerid, 1);
		 ShowPlayerDialog(playerid,436,DIALOG_STYLE_LIST,"Меню управления бизнеса","Купить товар\nКупить бизнес\nЗабрать прибыль\nПоказать статистику бизнеса\nПродать бизнес\nКОНФИГУРАЦИЯ ОРУЖИЙ","Выбрать","Отмена");
     }
     else { TogglePlayerControllable(playerid, 1); }
	 return 1;
}
/*if(dialogid == 638)
{
       if(response)
       {
         //TogglePlayerControllable(playerid, 1);
		 
     }
     else { ShowPlayerDialog(playerid,436,DIALOG_STYLE_LIST,"Меню управления бизнеса","Купить товар\nКупить бизнес\nЗабрать прибыль\nПоказать список ваших бизнесов\nПродать бизнес","Выбрать","Отмена"); }
	 return 1;
}*/
if(dialogid==436)
{
if(!response)return 1;
    if(response)
	{
		switch(listitem)
		{
		    case 0:
			{
    if (IsPlayerAtArmDealer(playerid)){
		BuyWeaponFromDealer(playerid);
	} else {
		SendPlayerFormattedText(playerid,lang_texts[22][8],0,COLOUR_RED);
	}
			}
			case 1:
			{
    if (IsPlayerAtArmDealer(playerid)){
		BuyArmDealer(playerid);
	} else {
		SendPlayerFormattedText(playerid,lang_texts[22][8],0,COLOUR_RED);
	}
	DialogPlayerWBussines(playerid);
            }
	        case 2:
			{
    if (IsPlayerAtArmDealer(playerid)){
		CollectArmDealer(playerid);
	} else {
		SendPlayerFormattedText(playerid,lang_texts[22][8],0,COLOUR_RED);
	}
	DialogPlayerWBussines(playerid);
			}
			case 3:
			{
	new temp[MAX_STRING];
	new count = 0;
	for (new id=0;id<MAX_ARMDEALERS;id++)
	{
		if(strcomp(Armdealers[id][Owner], oGetPlayerName(playerid), true) == 1)
		{
			count++;
			format(temp,sizeof(temp),lang_texts[22][9],Armdealers[id][Name],Armdealers[id][MoneyNow]);
			SendPlayerScrollingText(playerid,temp);
			set(temp,nullstr);
		}
	}
	if(count < 1)
	{
		SendPlayerFormattedText(playerid,lang_texts[22][10],0,COLOUR_RED);
	}
	DialogPlayerWBussines(playerid);
			}
//			case 4:
//			{
//				//	ShowTruckLoad(playerid);
//			}
			case 4:
			{
			if (IsPlayerAtArmDealer(playerid)){
				SellArmDealer(playerid);
			} else {
				SendPlayerFormattedText(playerid,lang_texts[22][8],0,COLOUR_RED);
			}
			DialogPlayerWBussines(playerid);
			}
			case 5:
			{
			DialogPlayerAmmo(playerid);
			}
}
}
return 1;
}
//----------------- end house

if(dialogid == GUIZERO)
{
TogglePlayerControllable(playerid, 1);
return 1;
}

if(dialogid == BGUI)
{
new s[64];
PlayerBankSelect[playerid] = 0;

	if(response)
	{
		if(listitem == 0)
		{
		format(s,sizeof(s),":: ВАШ СЧЕТ < %s $ >::" , AddPricePoint( Player[playerid][Bank] ));
		PlayerBankSelect[playerid] = 1;
		}
		if(listitem == 1)
		{
			if(PlayerGangID[playerid] == -1)
			{
			SendClientMessage(playerid, COLOUR_RED, "Вы не состоите в банде!");
			DialogPlayerBank(playerid);
			PlayerBankSelect[playerid] = 0;
			}
			else
			{
			format(s,sizeof(s),":: СЧЕТ БАНДЫ < %s $ > ::" , AddPricePoint( Gangs[ PlayerGangID[playerid] ][gang_bank] ));
			PlayerBankSelect[playerid] = 2;
			}
		}
		ShowPlayerDialog(playerid,BGUI+1,DIALOG_STYLE_LIST,s,"Пополнить счет\nСнять деньги со счета","ОК","НАЗАД");
	}
	else
	{
	TogglePlayerControllable(playerid, 1);
	}
	return 1;
}
 
if(dialogid == BGUI+1)
{
	if(PlayerBankSelect[playerid] == 0) {TogglePlayerControllable(playerid,1); return 1;}

	if(response)
	{
		if(PlayerBankSelect[playerid] == 1)
		{
			if(listitem == 0)
			{
			ShowPlayerDialog(playerid,BGUI+2,DIALOG_STYLE_INPUT,":: ПОПОЛНЕНИЕ ЛИЧНОГО СЧЕТА ::","Пополнить на:","ОК","НАЗАД");
			return 1;
			}
			if(listitem == 1)
			{
			ShowPlayerDialog(playerid,BGUI+3,DIALOG_STYLE_INPUT,":: СНЯТЬ С ЛИЧНОГО СЧЕТА ::","Снять:","ОК","НАЗАД");
			return 1;
			}
		}
		else if(PlayerBankSelect[playerid] == 2)
		{
			if(listitem == 0)
			{
			ShowPlayerDialog(playerid,BGUI+2,DIALOG_STYLE_INPUT,":: ПОПОЛНЕНИЕ СЧЕТА БАНДЫ ::","Пополнить на:","ОК","НАЗАД");
			return 1;
			}
			if(listitem == 1)
			{
			ShowPlayerDialog(playerid,BGUI+3,DIALOG_STYLE_INPUT,":: СНЯТЬ СО СЧЕТА БАНДЫ ::","Снять:","ОК","НАЗАД");
			return 1;
			}
		}
	}
	else
	{
	DialogPlayerBank(playerid);
	}
return 1;
}

if(dialogid == BGUI+2)
{
	if(response)
	{
		if(strval(inputtext) > 0)
		{
			if(PlayerBankSelect[playerid] == 1)
			{
			PlayerAddMoneyToBank(playerid,strval(inputtext));
			TogglePlayerControllable(playerid, 1);
			return 1;
			}
			if(PlayerBankSelect[playerid] == 2)
			{
			PlayerAddMoneyToGangBank(playerid,strval(inputtext));
			TogglePlayerControllable(playerid, 1);
			return 1;
			}
			TogglePlayerControllable(playerid, 1);
		}
		else
		{
		SendClientMessage(playerid, 0xFFFFFFFF, "[BANK] Введите положительное число!");
		DialogPlayerBank(playerid);
		}
	}
	else
	{
	DialogPlayerBank(playerid);
	return 1;
	}
}

if(dialogid == BGUI+3)
{
	if(response)
	{
		if(strval(inputtext) > 0)
		{
			if(PlayerBankSelect[playerid] == 1)
			{
			PlayerGetMoneyFromBank(playerid,strval(inputtext));
			TogglePlayerControllable(playerid, 1);
			return 1;
			}
			if(PlayerBankSelect[playerid] == 2)
			{
			PlayerGetMoneyFromGangBank(playerid,strval(inputtext));
			TogglePlayerControllable(playerid, 1);
			return 1;
			}
		}
		else
		{
		SendClientMessage(playerid, 0xFFFFFFFF, "[BANK] Введите положительное число!");
		DialogPlayerBank(playerid);
		}
	}
	else
	{
	DialogPlayerBank(playerid);
	return 1;
	}
}

if(dialogid == AGUI+3)
 {
	if(!response)
	{
	SendClientMessage(playerid, 0xFFFFFFFF, "You kicked from this server");
	Kick(playerid);
	return 1;
	}
	DialogPlayerToRegister(playerid);
	return 1;
}

if(dialogid == AGUI)
{
if(response == 0)
{
SendClientMessage(playerid, 0xFFFFFFFF, "You kicked from this server");
Kick(playerid);
return 1;
}
if (response == 1)
{
if(!strlen(inputtext))
{
SendClientMessage(playerid, COLOUR_MISC,  lang_texts[1][4] );
DialogPlayerToRegister(playerid);
return 1;
}
if(strlen(inputtext) <= 3)
{
SendClientMessage(playerid, COLOUR_MISC,  lang_texts[1][55] );
DialogPlayerToRegister(playerid);
return 1;
}
if(strlen(inputtext) >= 16)
{
SendClientMessage(playerid, COLOUR_MISC,  lang_texts[1][56] );
DialogPlayerToRegister(playerid);
return 1;
}
if(!PassCharCheck(inputtext))
{
SendClientMessage(playerid, COLOUR_MISC, " Недопустимые символы в пароле, используйте a-z, A-Z, 0-9" );
DialogPlayerToRegister(playerid);
return 1;
}
set(PlayerPasswordT[playerid],nullstr);
set(PlayerPasswordT[playerid],inputtext);
DialogPlayerToTuring(playerid);
return 1;
}
}

if(dialogid == AGUI + 1)
{
if(response == 0)
{
SendClientMessage(playerid, 0xFFFFFFFF, "You kicked from this server");
Kick(playerid);
return 1;
}
if (response == 1)
{
if(!strlen(inputtext))
{
SendClientMessage(playerid, COLOUR_MISC,  lang_texts[1][13] );
DialogPlayerToLogin(playerid);
return 1;
}
new pass[32];
set(pass,inputtext);
AccountLogin(playerid,pass);
return 1;
}
}

if(dialogid == AGUI + 2)
{
if(response == 0)
{
DialogPlayerToRegister(playerid);
return 1;
}
if (response == 1)
{
if(!strlen(inputtext))
{
SendClientMessage(playerid, COLOUR_MISC,lang_texts[1][39] );
DialogPlayerToTuring(playerid);
return 1;
}
//set(PlayerInputCode[playerid],inputtext);
PlayerInputCode[playerid] = strval(inputtext);
AccountRegister(playerid);
//new regcom[MAX_STRING];
//format(regcom,sizeof(regcom),"/register %s %s",PlayerPasswordT[playerid],PlayerInputCode[playerid]);
//OnPlayerCommandText(playerid,regcom);
return 1;
}
}

if(dialogid == WGUI+1)
{
if(response)
{
if(listitem == 0) {ShowPlayerDialog(playerid, WGUI+13, DIALOG_STYLE_MSGBOX, ":: Ваше оружие ::", GetGUIPlayerWeaponsStr(playerid), "OK", "Назад");}
if(listitem == 1) {ShowPlayerDialog(playerid, WGUI+14, DIALOG_STYLE_MSGBOX, ":: Ваши навыки :::",GetGUIPlayerSkillStr(playerid), "OK", "Назад");}
if(listitem == 2) {ShowPlayerDialog(playerid, WGUI+15, DIALOG_STYLE_MSGBOX, ":: Оружие & Навыки ::",WeaponSkillCondGUIStrting, "ОК", "Назад");}
if(listitem == 3) {GetGUIPlayerWeapons(playerid);}
}
else { TogglePlayerControllable(playerid, 1); }
return 1;
}

if(dialogid == WGUI+2)
{
if(response)
{
new guis[512];
if(listitem == 0) // Холодное
{
format(guis,sizeof(guis),"%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s",WSTR(1),WSTR(2),WSTR(3),WSTR(4),WSTR(5),WSTR(6),WSTR(7),WSTR(8),WSTR(9));
ShowPlayerDialog(playerid, WGUI+3, DIALOG_STYLE_LIST, ":: Выберете оружие ::", guis, "Выбор", "Назад");
}
if(listitem == 1) // Пистолеты
{
format(guis,sizeof(guis),"%s\n%s\n%s",WSTR(22),WSTR(23),WSTR(24));
ShowPlayerDialog(playerid, WGUI+4, DIALOG_STYLE_LIST, ":: Выберете оружие ::", guis, "Выбор", "Назад");
}
if(listitem == 2) // Автоматы
{
format(guis,sizeof(guis),"%s\n%s\n%s",WSTR(28),WSTR(29),WSTR(32));
ShowPlayerDialog(playerid, WGUI+5, DIALOG_STYLE_LIST, ":: Выберете оружие ::", guis, "Выбор", "Назад");
}
if(listitem == 3) // Винтовки
{
format(guis,sizeof(guis),"%s\n%s",WSTR(33),WSTR(34));
ShowPlayerDialog(playerid, WGUI+6, DIALOG_STYLE_LIST, ":: Выберете оружие ::", guis, "Выбор", "Назад");
}
if(listitem == 4) // Штурмовое
{
format(guis,sizeof(guis),"%s\n%s",WSTR(30),WSTR(31));
ShowPlayerDialog(playerid, WGUI+7, DIALOG_STYLE_LIST, ":: Выберете оружие ::", guis, "Выбор", "Назад");
}
if(listitem == 5) // Shotguns
{
format(guis,sizeof(guis),"%s\n%s\n%s",WSTR(25),WSTR(26),WSTR(27));
ShowPlayerDialog(playerid, WGUI+8, DIALOG_STYLE_LIST, ":: Выберете оружие ::", guis, "Выбор", "Назад");
}
if(listitem == 6) // Heavy Weaponry
{
format(guis,sizeof(guis),"%s\n%s\n%s",WSTR(35),WSTR(37),WSTR(38));
ShowPlayerDialog(playerid, WGUI+9, DIALOG_STYLE_LIST, ":: Выберете оружие ::", guis, "Выбор", "Назад");
}
if(listitem == 7) // Thrown
{
format(guis,sizeof(guis),"%s\n%s\n%s\n%s",WSTR(16),WSTR(17),WSTR(18),WSTR(39));
ShowPlayerDialog(playerid, WGUI+10, DIALOG_STYLE_LIST, ":: Выберете оружие ::", guis, "Выбор", "Назад");
}
if(listitem == 8) // Misc
{
format(guis,sizeof(guis),"%s\n%s\n%s\n%s\n%s",WSTR(14),WSTR(15),WSTR(41),WSTR(42),WSTR(46));
ShowPlayerDialog(playerid, WGUI+11, DIALOG_STYLE_LIST, ":: Выберете оружие ::", guis, "Выбор", "Назад");
}
} else {DialogPlayerAmmo(playerid);}
return 1;
}

if(dialogid == WGUI+3) {
if(response) {
if(listitem == 0) { BuyWeapon(playerid,1,1);}
if(listitem == 1) { BuyWeapon(playerid,2,1);}
if(listitem == 2) { BuyWeapon(playerid,3,1);}
if(listitem == 3) { BuyWeapon(playerid,4,1);}
if(listitem == 4) { BuyWeapon(playerid,5,1);}
if(listitem == 5) { BuyWeapon(playerid,6,1);}
if(listitem == 6) { BuyWeapon(playerid,7,1);}
if(listitem == 7) { BuyWeapon(playerid,8,1);}
if(listitem == 8) { BuyWeapon(playerid,9,1);}
TogglePlayerControllable(playerid, 1); }
else { ShowPlayerDialog(playerid, WGUI+2, DIALOG_STYLE_LIST, ":: Выберете ТИП ::", wtypes, "Выбор", "Назад"); }
return 1; }

if(dialogid == WGUI+4) {
if(response) {
if(listitem == 0) { bGUIWeaponID[playerid] = 22; }
if(listitem == 1) { bGUIWeaponID[playerid] = 23; }
if(listitem == 2) { bGUIWeaponID[playerid] = 24; }
ShowPlayerDialog(playerid, WGUI+12, DIALOG_STYLE_INPUT, "  ", "Патроны", "Купить", "Назад"); }
else { ShowPlayerDialog(playerid, WGUI+2, DIALOG_STYLE_LIST, ":: Выберете ТИП ::", wtypes, "Выбор", "Назад"); }
return 1; }

if(dialogid == WGUI+5) {
if(response) {
if(listitem == 0) { bGUIWeaponID[playerid] = 28;}
if(listitem == 1) { bGUIWeaponID[playerid] = 29;}
if(listitem == 2) { bGUIWeaponID[playerid] = 32;}
ShowPlayerDialog(playerid, WGUI+12, DIALOG_STYLE_INPUT, "  ", "Патроны", "Купить", "Назад"); }
else { ShowPlayerDialog(playerid, WGUI+2, DIALOG_STYLE_LIST, ":: Выберете ТИП ::", wtypes, "Выбор", "Назад"); }
return 1; }

if(dialogid == WGUI+6) {
if(response) {
if(listitem == 0) { bGUIWeaponID[playerid] = 33;}
if(listitem == 1) { bGUIWeaponID[playerid] = 34;}
ShowPlayerDialog(playerid, WGUI+12, DIALOG_STYLE_INPUT, "  ", "Патроны", "Купить", "Назад"); }
else { ShowPlayerDialog(playerid, WGUI+2, DIALOG_STYLE_LIST, ":: Выберете ТИП ::", wtypes, "Выбор", "Назад"); }
return 1; }

if(dialogid == WGUI+7) {
if(response) {
if(listitem == 0) { bGUIWeaponID[playerid] = 30;}
if(listitem == 1) { bGUIWeaponID[playerid] = 31;}
ShowPlayerDialog(playerid, WGUI+12, DIALOG_STYLE_INPUT, "  ", "Патроны", "Купить", "Назад"); }
else { ShowPlayerDialog(playerid, WGUI+2, DIALOG_STYLE_LIST, ":: Выберете ТИП ::", wtypes, "Выбор", "Назад"); }
return 1; }

if(dialogid == WGUI+8) {
if(response) {
if(listitem == 0) { bGUIWeaponID[playerid] = 25;}
if(listitem == 1) { bGUIWeaponID[playerid] = 26;}
if(listitem == 2) { bGUIWeaponID[playerid] = 27;}
ShowPlayerDialog(playerid, WGUI+12, DIALOG_STYLE_INPUT, "  ", "Патроны", "Купить", "Назад"); }
else { ShowPlayerDialog(playerid, WGUI+2, DIALOG_STYLE_LIST, ":: Выберете ТИП ::", wtypes, "Выбор", "Назад"); }
return 1; }

if(dialogid == WGUI+9) {
if(response) {
if(listitem == 0) { bGUIWeaponID[playerid] = 35;}
if(listitem == 1) { bGUIWeaponID[playerid] = 37;}
if(listitem == 2) { bGUIWeaponID[playerid] = 38;}
ShowPlayerDialog(playerid, WGUI+12, DIALOG_STYLE_INPUT, "  ", "Патроны", "Купить", "Назад"); }
else { ShowPlayerDialog(playerid, WGUI+2, DIALOG_STYLE_LIST, ":: Выберете ТИП ::", wtypes, "Выбор", "Назад"); }
return 1; }

if(dialogid == WGUI+10) {
if(response) {
if(listitem == 0) { bGUIWeaponID[playerid] = 16;}
if(listitem == 1) { bGUIWeaponID[playerid] = 17;}
if(listitem == 2) { bGUIWeaponID[playerid] = 18;}
if(listitem == 3) { bGUIWeaponID[playerid] = 39;}
ShowPlayerDialog(playerid, WGUI+12, DIALOG_STYLE_INPUT, "  ", "Патроны", "Купить", "Назад"); }
else { ShowPlayerDialog(playerid, WGUI+2, DIALOG_STYLE_LIST, ":: Выберете ТИП ::", wtypes, "Выбор", "Назад"); }
return 1; }

if(dialogid == WGUI+11) {
if(response) {
if(listitem == 0) { BuyWeapon(playerid,14,1); TogglePlayerControllable(playerid, 1);}
if(listitem == 1) { BuyWeapon(playerid,15,1); TogglePlayerControllable(playerid, 1);}
if(listitem == 2) { bGUIWeaponID[playerid] = 41; ShowPlayerDialog(playerid, WGUI+12, DIALOG_STYLE_INPUT, "  ", "Патроны", "Купить", "Назад"); }
if(listitem == 3) { bGUIWeaponID[playerid] = 42; ShowPlayerDialog(playerid, WGUI+12, DIALOG_STYLE_INPUT, "  ", "Патроны", "Купить", "Назад"); }
if(listitem == 4) { BuyWeapon(playerid,46,1); TogglePlayerControllable(playerid, 0);} }
else { ShowPlayerDialog(playerid, WGUI+2, DIALOG_STYLE_LIST, ":: Выберете ТИП ::", wtypes, "Выбор", "Назад"); }
return 1; }

if(dialogid == WGUI+12)
{
if(response) { BuyWeapon(playerid, bGUIWeaponID[playerid], strval(inputtext) ); TogglePlayerControllable(playerid, 1); } else {
ShowPlayerDialog(playerid, WGUI+2, DIALOG_STYLE_LIST, ":: Выберете ТИП ::", wtypes, "Выбор", "Назад"); }
return 1;
}

if(dialogid == WGUI+16)
{
new id=GetPlayerArmDealerID(playerid);
if(response) { BuyWeapon(playerid, Armdealers[id][WeaponSell], strval(inputtext) ); } else {
DialogPlayerWBussines(playerid); }
return 1;
}

if(dialogid == WGUI+26)
{
if(response) {DialogPlayerWBussines(playerid);}
return 1;
}

if(dialogid == WGUI+13 || dialogid == WGUI+14 || dialogid == WGUI+15)
{
if(response) {TogglePlayerControllable(playerid, 1);}
else {

if(IsPlayerAtAmmunation(playerid))
{
DialogPlayerAmmo(playerid);
}
else
{
TogglePlayerControllable(playerid, 1);
}

}
return 1;
}
//------------------------------------
if(dialogid == CGUI)
{
if(response) {
if(listitem == 0) {CommandHandler(playerid,"/repair");}
if(listitem == 1) {CommandHandler(playerid,"/heal");}
if(listitem == 2) {CommandHandler(playerid,"/level");}
if(listitem == 3) {CommandHandler(playerid,"/stat");}
if(listitem == 4) {CommandHandler(playerid,"/myskills");}
if(listitem == 5) {AccountCommandHandler(playerid,"/mysqlid");}
if(listitem == 6) {CommandHandler(playerid,"/skydive");}
if(listitem == 7) {DMCommandHandler(playerid,"/dms");}
if(listitem == 8) {RaceCommandHandler(playerid,"/races");}
if(listitem == 9) {ShowPlayerDialog(playerid, CGUI+14, DIALOG_STYLE_LIST, ":: PM control ::", PmCMDlist, "OK", "Cancel");}
}
return 1;
}
//-----------------------------------
if(dialogid == CGUI+13)
{
if(response) {
if(listitem == 0) {pm_addto_blacklist(playerid,SelectedID[playerid]);}
if(listitem == 1) {ShowPlayerDialog(playerid, CGUI+15, DIALOG_STYLE_INPUT, ":: Введите сумму ::", " ", "OK", "Cancel");}
if(listitem == 2) {
	new lstr[1024],scolor[8],stat[32];
	new nameX[MAX_STRING];
	if(IsPlayerAdmin(SelectedID[playerid]))
	{
		format(stat,sizeof(stat),lang_texts[15][97],Player[SelectedID[playerid]][Status]);
	}
	else if(Player[SelectedID[playerid]][Status] >= 1 && Player[SelectedID[playerid]][Status]<=10)
	{
		format(stat,sizeof(stat),lang_texts[12][87],Player[SelectedID[playerid]][Status]);
	}
	else if(Player[SelectedID[playerid]][Status]>10)
	{
		format(stat,sizeof(stat),lang_texts[12][86],Player[SelectedID[playerid]][Status]);
	}
	else
	{
		format(stat,sizeof(stat),lang_texts[12][88]);
	}

	OKS_HEX2STR_M(GetPlayerColor(SelectedID[playerid]), scolor, sizeof(scolor));

	format(lstr,sizeof(lstr),
	"{FFFFFF}ИГРОК:\t\t{%s}%s{FFFFFF}   id %d\nСТАТ.:\t\t%s\nSQLID:\t\t%d\n",
	scolor,oGetPlayerName(SelectedID[playerid]),SelectedID[playerid],stat,PlayerSQLID[SelectedID[playerid]]);

	if(PlayerGangID[SelectedID[playerid]] != -1)
	{
		format(lstr,sizeof(lstr),
		"%sБАНДА:\t{%s}%s{FFFFFF}   id %d\n",
		lstr,scolor,PlayerGangName[SelectedID[playerid]],PlayerGangID[SelectedID[playerid]]);
	}

	if(Player[SelectedID[playerid]][Level] == MAX_LEVEL)
	{
		format(lstr,sizeof(lstr),
		"%sУРОВЕНЬ:\t{23FF70}%d{FFFFFF}\n",
		lstr,Player[SelectedID[playerid]][Level]);
	}
	else
	{
		format(lstr,sizeof(lstr),
		"%sУРОВЕНЬ:   {23FF70}%d{FFFFFF}\n",
		lstr,Player[SelectedID[playerid]][Level]);
	}

	format(lstr,sizeof(lstr),
	"%sУБИЙСТВ:   {FF4238}%d{FFFFFF}   |   СМЕРТЕЙ:   {FF4238}%d{FFFFFF}\n\
	RACEXP:\t{2370FF}%d{FFFFFF}\nPACK:\t\t{2370FF}%d{FFFFFF}\nVIP:\t\t%d\nРЕГИСТРАЦИЯ:\t%s",
	lstr,
	Player[SelectedID[playerid]][Kills],Player[SelectedID[playerid]][Deaths],Player[SelectedID[playerid]][RXP],
	Player[SelectedID[playerid]][Packages],Player[SelectedID[playerid]][Vip],PlayerCreationDate[SelectedID[playerid]]);

	format(nameX,sizeof(nameX),"Общая статистика %s [id: %d]",oGetPlayerName(SelectedID[playerid]), SelectedID[playerid]);

	ShowPlayerDialog(playerid,S_GUI_02,0,nameX,lstr,"OК","");
}
}
return 1;
}
//-----------------------------------
if(dialogid == CGUI+14)
{
if(response) {
if(listitem == 0) {pm_show_blacklist(playerid);}
if(listitem == 1) {pm_clear_blacklist(playerid);}
} else {ShowPlayerDialog(playerid, CGUI, DIALOG_STYLE_LIST, ":: Список команд ::", MyCMDlist, "OK", "Cancel");}
return 1;
}
//-----------------------------------
if(dialogid == CGUI+15)
{
if(response) {
if(!strlen(inputtext)) {ShowPlayerDialog(playerid, CGUI+15, DIALOG_STYLE_INPUT, ":: Введите сумму ::", " ", "OK", "Cancel");}
else {
new mvalue = strval(inputtext);
new tmp[128];
format(tmp,sizeof(tmp),"/sm %d %d",SelectedID[playerid],mvalue);
CommandHandler(playerid,tmp);
}
} else {ShowPlayerDialog(playerid, CGUI+13, DIALOG_STYLE_LIST, ":: Игрок %s id:%d ::", PlCMDlist, "OK", "Cancel");}
return 1;
}
/*
if(dialogid == 70)
{
if(!response) { counterx++; MakeBadList(playerid);}
if(response) { printf("%d [comment: %s]",counterx, inputtext); counterx++; MakeBadList(playerid);}
}
*/
if(dialogid == QGUI)
{
if(response)
{
TogglePlayerControllable(playerid, 1);
return 1;
}
if(!response)
{
if(SendClientQuery(playerid,inputtext))
{
SendClientMessage(playerid, COLOUR_MISC,"Запрос отправлен!");
return 1;
}
else
{
ShowPlayerDialog(playerid,QGUI,1,"::: SQL control :::","- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\nWrite query","Cancel","Send");
return 1;
}
}
}
//new string2[MAX_STRING];
//new string[MAX_STRING];
		if(dialogid == DIALOG_ATTACH_INDEX_SELECTION)
        //case DIALOG_ATTACH_INDEX_SELECTION:
        {
            if(response)
            {
            	if(IsPlayerAttachedObjectSlotUsed(playerid, listitem))
            	{
                	ShowPlayerDialog(playerid, DIALOG_ATTACH_EDITREPLACE, DIALOG_STYLE_MSGBOX, "{FF0000}Добавление объекта", "Изменить или удалить выбранный объект?", "Изменить", "Удалить");
            	}
            	else
            	{
                	new string2[2990];
                	for(new x;x<sizeof(AttachmentObjects);x++)
                	{
                    	format(string2, sizeof(string2), "%s%s\n", string2, AttachmentObjects[x][attachname]);
                	}
                	ShowPlayerDialog(playerid, DIALOG_ATTACH_MODEL_SELECTION, DIALOG_STYLE_LIST, "{FF0000}Добавление объекта - Выбор объекта", string2, "Выбрать", "Отмена");
            	}
            	SetPVarInt(playerid, "AttachmentIndexSel", listitem);
            }
            return 1;
        }
        if(dialogid == DIALOG_ATTACH_EDITREPLACE)
        //case DIALOG_ATTACH_EDITREPLACE:
        {
        	if(response) EditAttachedObject(playerid, GetPVarInt(playerid, "AttachmentIndexSel"));
        	else
			{
			    new string[MAX_STRING];
				PlayerAttachmentsObj[playerid][GetPVarInt(playerid, "AttachmentIndexSel")][amodelid]=0;
				RemovePlayerAttachedObject(playerid, GetPVarInt(playerid, "AttachmentIndexSel"));
				for(new x;x<MAX_PLAYER_ATTACHED_OBJECTS;x++)
				{
			    	if(IsPlayerAttachedObjectSlotUsed(playerid, x)) format(string, sizeof(string), "%s%d (занято)\n", string, x);
			    	else format(string, sizeof(string), "%s%d\n", string, x);
				}
				ShowPlayerDialog(playerid, DIALOG_ATTACH_INDEX_SELECTION, DIALOG_STYLE_LIST, "{FF0000}Добавление объекта - Выбор слота", string, "Выбрать", "Выход");
			}
        	DeletePVar(playerid, "AttachmentIndexSel");
            return 1;
        }
        if(dialogid == DIALOG_ATTACH_MODEL_SELECTION)
        //case DIALOG_ATTACH_MODEL_SELECTION:
        {
            if(response)
            {
                if(GetPVarInt(playerid, "AttachmentUsed") == 1) EditAttachedObject(playerid, listitem);
                else
                {
                    SetPVarInt(playerid, "AttachmentModelSel", AttachmentObjects[listitem][attachmodel]);
                    new string[256+1];
                    for(new x;x<sizeof(AttachmentBones);x++)
                    {
                        format(string, sizeof(string), "%s%s\n", string, AttachmentBones[x]);
                    }
                    ShowPlayerDialog(playerid, DIALOG_ATTACH_BONE_SELECTION, DIALOG_STYLE_LIST, "{FF0000}Добавление объекта - Выбор части тела", string, "Выбрать", "Отмена");
            	}
            }
            else DeletePVar(playerid, "AttachmentIndexSel");
            return 1;
        }
        if(dialogid == DIALOG_ATTACH_BONE_SELECTION)
        //case DIALOG_ATTACH_BONE_SELECTION:
        {
            if(response)
            {
                SetPlayerAttachedObject(playerid, GetPVarInt(playerid, "AttachmentIndexSel"), GetPVarInt(playerid, "AttachmentModelSel"), listitem+1);
                EditAttachedObject(playerid, GetPVarInt(playerid, "AttachmentIndexSel"));
                SendClientMessage(playerid, 0xFFFFFFFF, "Подсказка: Используйте {FFFF00}~k~~PED_SPRINT~{FFFFFF} для поворота камеры.");
            }
            DeletePVar(playerid, "AttachmentIndexSel");
            DeletePVar(playerid, "AttachmentModelSel");
            return 1;
        }
//
if(dialogid == COMMANDS_INFO_DIALOG)
{
    if(response)
    {
	    new helpstr[1800];
	    new comstr[128];
	    if(listitem == 0)
	    {
	    	format(comstr,sizeof(comstr), "Команды Аккаунта:");
		    strins(helpstr, "{596C56}'/rules'{ffffff}				- правила поведения на серверу (ОБЯЗАТЕЛЬНЫ К ПРОЧТЕНИЮ).\n", strlen(helpstr));
		    strins(helpstr, "{596C56}'/quit'('/q'){ffffff}			- выход с сервера.\n", strlen(helpstr));
		    strins(helpstr, "{596C56}'/heal'{ffffff}			    - покупка бронежилета.\n", strlen(helpstr));
		    strins(helpstr, "{596C56}'/commands'{ffffff}			- список доступных команд сервера.\n", strlen(helpstr));
		    strins(helpstr, "{596C56}'/inoob'{ffffff}			    - помощь для новичков. Здесь вы можете найти описание основных принципов режима GTO.\n", strlen(helpstr));
		    strins(helpstr, "{596C56}'/stats'{ffffff}				- полная статистика о вашем персонаже (уровень, банда, количество убийств и тп.).\n", strlen(helpstr));
		    strins(helpstr, "{596C56}'/level'{ffffff}				- информация о вашем уровне (сколько XP  у вас есть, сколько XP необходимо для достижения следующего уровня и тп.).\n", strlen(helpstr));
		    strins(helpstr, "{596C56}'/muted'{ffffff}				- информация о наказании.\n", strlen(helpstr));
		    strins(helpstr, "{596C56}'/myskills'{ffffff}			- навыки персонажа.\n", strlen(helpstr));
		    strins(helpstr, "{596C56}'/fight <ИД 0 - 5>'{ffffff}	- смена стиля боя.\n", strlen(helpstr));
		    strins(helpstr, "{596C56}'/kill'{ffffff}				- убить себя.\n", strlen(helpstr));
            strins(helpstr, "{596C56}'/attachments'{ffffff}			- управление объектами на персонаже.\n", strlen(helpstr));
	    }
	    if(listitem == 1)
	    {
	    	format(comstr,sizeof(comstr), "Команды Финансов:");
		    strins(helpstr, "{DBED15}'/givecash <ИД> <сумма>' ('/sm <ИД> <сумма>'){ffffff}	- передать деньги другому игроку.\n", strlen(helpstr));
		    strins(helpstr, "{DBED15}'/bank <сумма>'{ffffff} 					- положить деньги на банковский счёт (только в банке).\n", strlen(helpstr));
		    strins(helpstr, "{DBED15}'/withdraw <сумма>'{ffffff} 				- снять деньги с банковского счёта (только в банке).\n", strlen(helpstr));
	    }
	    if(listitem == 2)
	    {
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
	    }
		if(listitem == 3)
	    {
	    	format(comstr,sizeof(comstr), "Команды Оружия:");
		    strins(helpstr, "{BABABA}'/weapons{ffffff}			- список вашего оружия, купленного в магазине.\n", strlen(helpstr));
		    strins(helpstr, "{BABABA}'/wl' ('/weaponlist'){ffffff}		- список доступного, для покупки, оружия.\n", strlen(helpstr));
		    strins(helpstr, "{BABABA}'/dropammo'{ffffff}			- удаление всего вашего оружия.\n", strlen(helpstr));
	    }
	    if(listitem == 4)
	    {
	    	format(comstr,sizeof(comstr), "Команды Домов:");
		    strins(helpstr, "{8CED15}'/houses'{ffffff}			- список всех домов на сервере.\n", strlen(helpstr));
		    strins(helpstr, "{8CED15}'/myhouses'{ffffff}			- список ваших домов или домов принадлежащей вашей банде.\n", strlen(helpstr));
		    strins(helpstr, "{8CED15}'/hinfo'{ffffff}				- информация о доме (только в ЧП дома).\n", strlen(helpstr));
		    strins(helpstr, "{8CED15}'/hbuy'{ffffff}				- покупка дома (только в ЧП дома).\n", strlen(helpstr));
		    strins(helpstr, "{8CED15}'/hsell'{ffffff}				- продажа дома (только в ЧП дома).\n", strlen(helpstr));
		    strins(helpstr, "{8CED15}'/hmenu'{ffffff}			- меню дома, в нём вы можете найти все эти команды (только в ЧП дома).\n", strlen(helpstr));
	    }
	    if(listitem == 5)
	    {
	    	format(comstr,sizeof(comstr), "Команды Гонок:");
		    strins(helpstr, "{37DB45}'/races'{ffffff}		- список активных гонок.\n", strlen(helpstr));
		    strins(helpstr, "{37DB45}'/race join <ИД>'{ffffff}	- присоединиться к гонке с определённым ИД.\n", strlen(helpstr));
		    strins(helpstr, "{37DB45}'/race quit'{ffffff}		- покинуть гонку.\n", strlen(helpstr));
		    strins(helpstr, "{37DB45}'/race 4me'{ffffff}		- покупка события (ПЛАТНАЯ).\n", strlen(helpstr));
            strins(helpstr, "{37DB45}'/events'{ffffff}		- список активных событий.\n", strlen(helpstr));
	    }
	    if(listitem == 6)
	    {
	    	format(comstr,sizeof(comstr), "Команды Дестматчей:");
		    strins(helpstr, "{FF0000}'/dms'{ffffff}			- список активных десматчей.\n", strlen(helpstr));
		    strins(helpstr, "{FF0000}'/dm join <ИД>'{ffffff}	- присоединиться к десматчу с определённым ИД.\n", strlen(helpstr));
		    strins(helpstr, "{FF0000}'/dm quit'{ffffff}		- покинуть десматч.\n", strlen(helpstr));
		    strins(helpstr, "{FF0000}'/dm 4me'{ffffff}		- покупка события (ПЛАТНАЯ).\n", strlen(helpstr));
		    strins(helpstr, "{FF0000}'/events'{ffffff}		- список активных событий.\n", strlen(helpstr));
	    }
	    if(listitem == 7)
	    {
	    	format(comstr,sizeof(comstr), "Команды Бизнесов:");
		    strins(helpstr, "{37DB45}'/bmenu'{ffffff}	- меню бизнеса, там содержится управление этим бизнесом (только в ЧП бизнеса).\n", strlen(helpstr));
	    }
	    if(listitem == 8)
	    {
	    	format(comstr,sizeof(comstr), "Команды Машин:");
		    strins(helpstr, "{1B1BE0}'/repair'{ffffff}			- отремонтировать машину, в которой вы находитесь (доступна раз в 30 сек.). Цена: $1.500.\n", strlen(helpstr));
		    strins(helpstr, "{1B1BE0}'/carkill'{ffffff}			- взорвать машину, в которой вы сидите (доступна только водителю).\n", strlen(helpstr));
		    strins(helpstr, "{1B1BE0}'/mycar help'{ffffff}		- информация о личным автомобиле (доступно для VIP).\n", strlen(helpstr));
		    strins(helpstr, "{1B1BE0}'/plight'{ffffff}			- установка компонента (доступно для VIP).\n", strlen(helpstr));
		    strins(helpstr, "{1B1BE0}'/llight'{ffffff}			- установка компонента (доступна для VIP).\n", strlen(helpstr));
		    strins(helpstr, "{1B1BE0}'/dellight'{ffffff}		- удаление изменении на автомобиле (доступна для VIP).\n", strlen(helpstr));
		    strins(helpstr, "{1B1BE0}'/hydraulic'{ffffff}		- установка гидравлики.\n", strlen(helpstr));
		    strins(helpstr, "{1B1BE0}'Y'{ffffff}				- вызов меню автомобиля.\n", strlen(helpstr));
	    }
	    if(listitem == 9)
	    {
	    	format(comstr,sizeof(comstr), "Команды Vote System:");
		    strins(helpstr, "{DBED15}'/votekick <ИД> <причина>'{ffffff}	- запустить голосование, для кика с сервера нарушителя правил (доступна с 5 уровня).\n", strlen(helpstr));
		    strins(helpstr, "{DBED15}'/votestop <причина>'{ffffff}	- остановить голосование (только для создателя голосования).\n", strlen(helpstr));
		    strins(helpstr, "{DBED15}'/avote'{ffffff}				- проголосовать.\n", strlen(helpstr));
	    }
	    if(listitem == 10)
	    {
	    	format(comstr,sizeof(comstr), "Команды Захвата территории:");
		    strins(helpstr, "{15D4ED}'/attack <ИД>'{ffffff}		- атаковать зону. ИД  - номер территории.\n", strlen(helpstr));
		    strins(helpstr, "{15D4ED}'/zone all'{ffffff}				- список всех территории.\n", strlen(helpstr));
		    strins(helpstr, "{15D4ED}'/zone info'{ffffff}			    - информация о территории по позиции игрока.\n", strlen(helpstr));
		    strins(helpstr, "{15D4ED}'/zone join <ИД>'{ffffff}			- присоединиться к захвату территории.\n", strlen(helpstr));
		    strins(helpstr, "{15D4ED}'/zone quit'{ffffff}				- покинуть захват территории.\n", strlen(helpstr));
		    strins(helpstr, "{15D4ED}'/zone keep <ИД> <СУММА>'{ffffff}	- оплата за содержание территории.\n", strlen(helpstr));
	    }
	    if(listitem == 11)
	    {
	    	format(comstr,sizeof(comstr), "Команды V.I.P:");
		    strins(helpstr, "{DBED15}'/vip'{ffffff}				- информация о системе V.I.P.\n", strlen(helpstr));
		    strins(helpstr, "{DBED15}'/donat'{ffffff}			- информация о приобретении V.I.P.\n", strlen(helpstr));
		    strins(helpstr, "{DBED15}'/attachments'{ffffff}		- информация о объектах персонажа.\n", strlen(helpstr));
	    }
	    if(listitem == 12)
	    {
	    	format(comstr,sizeof(comstr), "Команды Дальнобойщика:");
		    strins(helpstr, "{DBED15}'/trade'{ffffff}				- вызов терминала на точке доставки/загрузки\n", strlen(helpstr));
	    }
	    if(listitem == 13)
	    {
	    	format(comstr,sizeof(comstr), "Остальные команды:");
		    strins(helpstr, "{7340DB}'/admins'{ffffff}			- список администрации, находящейся в данный момент на сервере.\n", strlen(helpstr));
		    strins(helpstr, "{7340DB}'/skydive'{ffffff}			- прыгнуть с парашутом. Цена: $20.000.\n", strlen(helpstr));
		    strins(helpstr, "{7340DB}'/heal'{ffffff}				- приобрести броню. Цена: $2.500.\n", strlen(helpstr));
		    strins(helpstr, "{7340DB}'/pt'{ffffff}				- поприветствовать всех игроков.\n", strlen(helpstr));
		    strins(helpstr, "{7340DB}'/bb'{ffffff}				- попрощаться со всеми игроками.\n", strlen(helpstr));
		    strins(helpstr, "{7340DB}'* <текст>'{ffffff}			- сказать шёпотом (вас будут слышать только те игроки, которые находятся недалеко от вас).\n", strlen(helpstr));
		    strins(helpstr, "{7340DB}'/bug <текст>'{ffffff}		- сообщение администрации о найденных багах.\n", strlen(helpstr));
		    strins(helpstr, "{7340DB}'/PM <ИД> <сообщение>'{ffffff}	- написать личное сообщение другому игроку.\n", strlen(helpstr));
	    }
		ShowPlayerDialog(playerid, COMMANDS_INFO_DIALOG+1, DIALOG_STYLE_MSGBOX, comstr, helpstr,"Назад", "Выход");
	}
	return 1;
}

if(dialogid == COMMANDS_INFO_DIALOG+1)
{
    if(response)
    ShowPlayerDialog(playerid, COMMANDS_INFO_DIALOG, DIALOG_STYLE_LIST, " Пользовательские команды для:", "{596C56}Аккаунта\n{DBED15}Финансов\n{DB881A}Банд\n{BABABA}Оружия\n{8CED15}Домов\n{37DB45}Гонок\n{FF0000}Дестматчей\n{37DB45}Бизнесов\n{1B1BE0}Машин\n{DBED15}Vote System\n{15D4ED}Территории\n{DBED15}V.I.P\n{CCEEFF}Дальнобойщика\n{7340DB}Остального","Выбрать", "Выход");
    return 1;
}
//
//---------------- train menu
if(dialogid == TGUI)
{
	if(response)
	{
		if(listitem == 0) {StartTrain4(playerid);}
		if(listitem == 1) {StartTrain2(playerid);}
		if(listitem == 2) {StartTrain3(playerid);}
		if(listitem == 3) {StartTrain1(playerid);}
	}
	else { train_OnPlayerSpawn(playerid); }
	return 1;
}
//
//---------------- train1 menu
if(dialogid == TGUI+1)
{
	if(response)
	{
		if(Player[playerid][train1] == 1){
		// Создание && Загрузки Грузовика для игрока в его виртуальный мир
		TrainingVehicle[playerid][train_indus1] = CreateVehicle(Truck_B,2207.700,-2243.700,13.700,315.000,-1,-1,Truck_Resp);
		TrainingVehicle[playerid][train_indus2] = CreateVehicle(Truck_L3,2248.105224,-2233.470458,13.680203,45.000,-1,-1,never);
		TrainingVehicle[playerid][train_indus3] = CreateVehicle(Truck_A,2203.700,-2240.700,13.700,315.000,-1,-1,Truck_Resp);
		TrainingVehicle[playerid][train_indus4] = CreateVehicle(Truck_C,2200.700,-2237.700,13.700,315.000,-1,-1,Truck_Resp);
    	SetVehicleVirtualWorld ( TrainingVehicle[playerid][train_indus1], 500+playerid );
    	SetVehicleVirtualWorld ( TrainingVehicle[playerid][train_indus2], 500+playerid );
    	SetVehicleVirtualWorld ( TrainingVehicle[playerid][train_indus3], 500+playerid );
    	SetVehicleVirtualWorld ( TrainingVehicle[playerid][train_indus4], 500+playerid );
    	TradePlayerHelp(playerid);
    	PutPlayerInVehicle(playerid, TrainingVehicle[playerid][train_indus2], 0);
    	}
	}
	return 1;
}
//
//---------------- events menu
 if(dialogid == EGUI) // Дальнобойщики диалог Выбор миссии
 {
	if(response)
	{
		PlayerGetEvents(playerid,listitem);
	}
	return 1;
 }
 //
if(dialogid == A_GUI)
{
    if(response)
    {
	    new helpstr[2200];
	    new comstr[128];
	    if(listitem == 0)
	    {
	        format(comstr,sizeof(comstr), "Команды Модератора:");
	        strins(helpstr, "{1B1BE0}'/plist <ИД>'{ffffff}			- список наказанных игроков.\n", strlen(helpstr));
	        strins(helpstr, "{1B1BE0}'/supermute <ИД> <время>'{ffffff}	- дать игроку супермуту.\n", strlen(helpstr));
	        strins(helpstr, "{1B1BE0}'/mute <ИД> <время>'{ffffff}		- заткнуть игрока.\n", strlen(helpstr));
	        strins(helpstr, "{1B1BE0}'/unmute <ИД>'{ffffff}		- снять с игрока муту.\n", strlen(helpstr));
	        strins(helpstr, "{1B1BE0}'/jail <ИД> <время>'{ffffff}		- посадить игрока в тюрьму.\n", strlen(helpstr));
	        strins(helpstr, "{1B1BE0}'/unjail <ИД>'{ffffff}	 		- выпустить игрока из тюрьмы.\n", strlen(helpstr));
	        strins(helpstr, "{1B1BE0}'/tele-to <ИД>'{ffffff}			- телепортироваться к игроку.\n", strlen(helpstr));
	        strins(helpstr, "{1B1BE0}'/specplayer <ИД>'{ffffff}			- наблюдать за игроком.\n", strlen(helpstr));
	        strins(helpstr, "{1B1BE0}'/specvehicle' <ИД>{ffffff}			- наблюдать за транспортом.\n", strlen(helpstr));
	        strins(helpstr, "{1B1BE0}'/specoff'{ffffff}	- 			- прекратить из слежку.\n", strlen(helpstr));
	        strins(helpstr, "{1B1BE0}'/scan <ИД>'{ffffff} 			- проверить оружие игрока.\n", strlen(helpstr));
	        strins(helpstr, "{1B1BE0}'/scanall'{ffffff} 			- проверить оружие всех игроков.\n", strlen(helpstr));
	        strins(helpstr, "{1B1BE0}'/scanhelp'{ffffff}			- помощь по командам сканирования оружия.\n", strlen(helpstr));
	        strins(helpstr, "{1B1BE0}'/msay <сообщение>'{ffffff}		- написать сообщение от имени модератора.\n", strlen(helpstr));
	        strins(helpstr, "{1B1BE0}'/mkick <ИД>'{ffffff}		- ответить игроку на его сообщение в /report.\n", strlen(helpstr));
	        strins(helpstr, "{1B1BE0}'/gohome' и '/gowork'{ffffff}	- админский дом.\n", strlen(helpstr));
	    }
	    if(listitem == 1)
	    {
	        format(comstr,sizeof(comstr), "Команды Администратора:");
	        strins(helpstr, "{37DB45}'/kick <ИД>'{ffffff}					- кикнуть игрока.\n", strlen(helpstr));
	        strins(helpstr, "{37DB45}'/akill <ИД>'{ffffff}					- убить игрока.\n", strlen(helpstr));
	        strins(helpstr, "{37DB45}'/remcar <ИД>'{ffffff}					- выкинуть игрока из машины.\n", strlen(helpstr));
	        strins(helpstr, "{37DB45}'/paralyze <ИД>'{ffffff}				- парализовать игрока.\n", strlen(helpstr));
	        strins(helpstr, "{37DB45}'/deparalyze <ИД>'{ffffff}				- распарализовать игрока.\n", strlen(helpstr));
	        strins(helpstr, "{37DB45}'/pinfo <ИД>'{ffffff}					- информация об игроке.\n", strlen(helpstr));
	        strins(helpstr, "{37DB45}'/tele-set'{ffffff}					- установить точку телепорта.\n", strlen(helpstr));
	        strins(helpstr, "{37DB45}'/tele-loc'{ffffff}					- телепортироваться в установленную точку.\n", strlen(helpstr));
	        strins(helpstr, "{37DB45}'/tele-to <ИД>'{ffffff}					- переместиться к игроку.\n", strlen(helpstr));
	        strins(helpstr, "{37DB45}'/tele-here <ИД>'{ffffff}				- переместить игрока к себе.\n", strlen(helpstr));
	        strins(helpstr, "{37DB45}'/tele-hereall'{ffffff}					- переместить всех к себе.\n", strlen(helpstr));
	        strins(helpstr, "{37DB45}'/givegun <ИД> <ИД оружия> <патроны>'{ffffff}	- дать игроку оружие и патроны.\n", strlen(helpstr));
	        strins(helpstr, "{37DB45}'/setarm <ИД> <броня>'{ffffff}			- дать игроку броню.\n", strlen(helpstr));
	        strins(helpstr, "{37DB45}'/sethealth <ИД> <HP>'{ffffff}			- дать игроку HP.\n", strlen(helpstr));
	        strins(helpstr, "{37DB45}'/clearchat'{ffffff}					- очистить чат.\n", strlen(helpstr));
	        strins(helpstr, "{37DB45}'/say <текст>'{ffffff}					- написать сообщение в чат от имени супермодератора.\n", strlen(helpstr));
	        strins(helpstr, "{37DB45}'/cnn <текст>'{ffffff}					- написать текст посередине экрана, большими буквами.\n", strlen(helpstr));
	    }
	    if(listitem == 2)
	    {
	        format(comstr,sizeof(comstr), "Команды RCON Администратора:");
	        strins(helpstr, "{37DB45}'/carinfo <ИД>'{ffffff}					- информация о авто.\n", strlen(helpstr));
	        strins(helpstr, "{37DB45}'/add_veh <ИД>'{ffffff}					- добавить транспорт.\n", strlen(helpstr));
	        strins(helpstr, "{37DB45}'/add_train <ИД>'{ffffff}					- добавить груз.\n", strlen(helpstr));
	        strins(helpstr, "{37DB45}'/del_veh <ИД>'{ffffff}				- удаление транспорта.\n", strlen(helpstr));
	        strins(helpstr, "{37DB45}'/action <ИД>'{ffffff}				- действие.\n", strlen(helpstr));
	        strins(helpstr, "{37DB45}'/carrep'{ffffff}					- ремонт.\n", strlen(helpstr));
	        strins(helpstr, "{37DB45}'/carresp'{ffffff}					- респавн транспорта.\n", strlen(helpstr));
	        strins(helpstr, "{37DB45}'/setskill <ID> <IDw> <skill>'{ffffff} - установить скилл игроку.\n", strlen(helpstr));
	        strins(helpstr, "{37DB45}'/go <ИД>'{ffffff}					- переместиться к точке.\n", strlen(helpstr));
	        strins(helpstr, "{37DB45}'/go2pack <ИД>'{ffffff}				- переместить к скрытому пакету.\n", strlen(helpstr));
	        strins(helpstr, "{37DB45}'/payday'{ffffff}					- выдать всем ЗП.\n", strlen(helpstr));
	        strins(helpstr, "{37DB45}'/poslog'{ffffff}					- incomning.\n", strlen(helpstr));
	        strins(helpstr, "{37DB45}'/boom'{ffffff}			- рандомный взрыв.\n", strlen(helpstr));
	        strins(helpstr, "{37DB45}'/boomex'{ffffff}			- рандомный взрыв.\n", strlen(helpstr));
	        strins(helpstr, "{37DB45}'/setskin'{ffffff}					- установка скина.\n", strlen(helpstr));
	        strins(helpstr, "{37DB45}'/kickall'{ffffff}					- кикнуть всех игроков.\n", strlen(helpstr));
	        strins(helpstr, "{37DB45}'/ssay <текст>'{ffffff}			- написать текст от SERVER'a.\n", strlen(helpstr));
	        strins(helpstr, "{ffffff}Остальный команды доступны только разработчикам проекта.\n", strlen(helpstr));
	    }
	    ShowPlayerDialog(playerid, A_GUI+1, DIALOG_STYLE_MSGBOX, comstr, helpstr,"Назад", "Выход");
	}
	return 1;
}
//
if(dialogid == A_GUI+1)
{
    if(response)
	{
		new ahelpstr[380];
		if (IsPlayerMod(playerid) || IsPlayerAdm(playerid) || IsPlayerAdmin(playerid))strins(ahelpstr,"{1B1BE0}Команды Модератора\n", strlen(ahelpstr));
		if (IsPlayerAdm(playerid) || IsPlayerAdmin(playerid))strins(ahelpstr,"{37DB45}Команды Администратора\n", strlen(ahelpstr));
		if (IsPlayerAdmin(playerid))strins(ahelpstr,"{15D4ED}Команды RCON Администратора\n", strlen(ahelpstr));
		ShowPlayerDialog(playerid, A_GUI, DIALOG_STYLE_LIST, " Команды администратора:", ahelpstr,"Ок", "Закрыть");
	}
    return 1;
}
//
if(dialogid == RADIO)
 	{
	if(response)
	{
		if(listitem == 0) {PlayAudioStreamForPlayer(playerid,"http://www.zaycev.fm:9001/rnb/ZaycevFM(128)");}
		if(listitem == 1) {PlayAudioStreamForPlayer(playerid,"http://air.radiorecord.ru:805/rr_320");}
		if(listitem == 2) {PlayAudioStreamForPlayer(playerid,"http://ep128.streamr.ru");}
		if(listitem == 3) {PlayAudioStreamForPlayer(playerid,"http://ic2.101.ru:8000/v1_1");}
		if(listitem == 4) {StopAudioStreamForPlayer(playerid);}
	}
	return 1;
}
//
//--------------------[ RACE ]--------------------------------------- >
if(dialogid == R_GUI) // Gang -> if leader leave gang
 {
	if(response)
	{
	}
	else { OnPlayerCommandText(playerid,"/events"); }
	return 1;
 }
 //--------------------[ QUIT EVENT - ZOMBIE ]--------------------------------------- >
if(dialogid == EV_GUI) //
 {
	if(response)
	{
 		new dmid = GetPlayerDM(playerid);
 		if (dmid == INVALID_DM_ID) return 1;
	    PlayerLeaveDM(playerid,dmid);
	}
	return 1;
 }
//
//--------------------[ Player Car ]--------------------------------------- >
if(dialogid == MCGUI) // Первое меню вне машины
 {
	if(response)
	{
		if(listitem == 0) { LoadPlayerCar(playerid); }
		if(listitem == 1) { RespawnPlayerCar(playerid); }
		if(listitem == 2) { OnPlayerCommandText(playerid,"/mycar tele"); }
		if(listitem == 3) { ShowPlayerDialog(playerid, MCGUI+2, DIALOG_STYLE_INPUT, " ", ":: Введите цвет неона ::\n\n\
		id: {FF0000}0 {0000FF}1 {00FF00}2 {FFEE00}3 {EE00FF}4 {FFFFFF}5", "Установить", "Выход"); } // Установка неона
		if(listitem == 4) {
		if(PlCar[playerid][neon] != -1)
		{
			DestroyObject(PlCar[playerid][neon]);
			PlCar[playerid][neon] = -1;
			SendClientMessage(playerid, COLOUR_GREEN, "Неон отключен");
		}
	 	}
	 	if(listitem == 5) {
	 	ShowPlayerDialog(playerid, MCGUI+3, DIALOG_STYLE_INPUT, " ", ":: Введите цвет автомобиля ::\n\n\
		<color1> <color2>", "Установить", "Выход");
	 	} // Установка цвета авто 1 и 2 цвет
	 	if(listitem == 6) {
	 	ShowPlayerDialog(playerid, MCGUI+4, DIALOG_STYLE_INPUT, " ", ":: Введите имя автомобиля ::", "Установить", "Выход");
	 	} // Установка имени автомобиля
	 	if(listitem == 7) { OnPlayerCommandText(playerid,"/mycar save"); }
	}
	return 1;
}
if(dialogid == MCGUI+1) // Второе меню в машине
 {
	if(response)
	{
		if(listitem == 0) { LoadPlayerCar(playerid); }
		if(listitem == 1) { RespawnPlayerCar(playerid); }
		if(listitem == 2) { ShowPlayerDialog(playerid, MCGUI+2, DIALOG_STYLE_INPUT, " ", ":: Введите цвет неона ::\n\n\
		id: {FF0000}0 {0000FF}1 {00FF00}2 {FFEE00}3 {EE00FF}4 {FFFFFF}5", "Установить", "Выход"); } // Установка неона
		if(listitem == 3) {
		if(PlCar[playerid][neon] != -1)
		{
			DestroyObject(PlCar[playerid][neon]);
			PlCar[playerid][neon] = -1;
			SendClientMessage(playerid, COLOUR_GREEN, "Неон отключен");
		}
	 	}
	 	if(listitem == 4) {
	 	ShowPlayerDialog(playerid, MCGUI+3, DIALOG_STYLE_INPUT, " ", ":: Введите цвет автомобиля ::\n\n\
		<color1> <color2>", "Установить", "Выход");
	 	} // Установка цвета авто 1 и 2 цвет
	 	if(listitem == 5) {
	 	ShowPlayerDialog(playerid, MCGUI+4, DIALOG_STYLE_INPUT, " ", ":: Введите имя автомобиля ::", "Установить", "Выход");
	 	} // Установка имени автомобиля
	 	if(listitem == 6) { OnPlayerCommandText(playerid,"/mycar save"); }
	}
	return 1;
}
if(dialogid == MCGUI+2) // неон в машине
 {
	if(response)
	{
	    if(!strlen(inputtext)) { return 1; }
		//new nt = strval(inputtext);
		new idx;
		new nt = strval(strcharsplit(inputtext, idx,strchar(" ")));
		NeonOn(playerid,nt,0,0.00,0.00,0.00);
	}
	return 1;
}
if(dialogid == MCGUI+3) // цвет машины
 {
	if(response)
	{
	    if(!strlen(inputtext)) { return 1; }
        new idx;
		new col1, col2;
		new tmp[MAX_STRING];
		tmp = strcharsplit(inputtext, idx,strchar(" "));
		if(!strlen(tmp)) {
			SendClientMessage(playerid,COLOUR_CRIMSON,"Вы не ввели значение первого цвета! Применение: '/mycar color <color1> <color2>");
			return 1;
		}
		col1 = strval(tmp);

		tmp = strcharsplit(inputtext, idx,strchar(" "));
		if(!strlen(tmp)) {
			SendClientMessage(playerid,COLOUR_CRIMSON,"Вы не ввели значение второго цвета! Применение: '/mycar color <color1> <color2>");
			return 1;
		}
		col2 = strval(tmp);

		ChangePlayerCarColor(playerid,col1,col2);
	}
	return 1;
}
if(dialogid == MCGUI+4) // имя машины
 {
	if(response)
	{
	    if(!strlen(inputtext)) { return 1; }
		
  		new idx;
        
		new carname[128],mess[128];
		set(carname,inputtext);
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

	}
	return 1;
}
//
if(dialogid == HOTEL_MENU_DIALOG)
{
	if(response)
	{
		if(listitem == 0)
		{
			FHotelHotels(playerid);
			ShowPlayerDialog(playerid, HOTEL_MENU_DIALOG, DIALOG_STYLE_LIST, " Система управления отелями:", "Информация о всех отелях\nАрендовать отель\nВыписаться из отеля", "Выбрать", "Выход");
		}
		if(listitem == 1)
		{
			FHotelBuy(playerid);
			TogglePlayerControllable(playerid, 1);
		}
		if(listitem == 2)
		{
			FHotelSell(playerid);
			TogglePlayerControllable(playerid, 1);
		}
	}
	else
	{
	    TogglePlayerControllable(playerid, 1);
	}
	return 1;
}
//
return 0;
}
