//
// Created:     06.09.06
// Aurthor:     Iain Gilbert
// ReCreate: 	Artem Firstov (Konsul)
// ReCreate:	Gaysin Rishat
//
// Update 21.11.16
// Добавил выдачу ХР всем членам банды онлайн
// Снятия со счета банды -25.000 за содержание зоны
// Обнуление зоны если на счете не достаточно средств
//
// Update 24.11.16
// Изменение пооцедуры поиска gangid
//
// Update 17.06.17
// Изменена выдача ХР игрокам
//

#if defined _payday_included
  #endinput
#endif

#define _payday_included
#pragma library payday
#include "base"
#include "player"
#include "zones"
#include "gang10"

forward PayDay();

#define PayDayDelay 59999 // Delay between pays
new admpayday,rpayday;

static BasePay = 500; // Base amount player recieves each pay (pay = PocketMoney + (PocketMoney * level ))
static PayCutoff = 1000000; // amount of money player can horde before they stop getting payed (they can still get money by killing)
static BasePayXP = 50;

new XPZone = 0;
//new MoneyZone = 2000;

// timer needs to run this.
// gives players money.
// PayDay - раз в час, причем ХП тоже дается. Рассчитать верное кол-во и процент...
public PayDay()
{
new hour,minute,second;
gettime(hour,minute,second);
if (minute>0) {rpayday=0;}
if ( ((minute==0) && (rpayday==0)) || (admpayday>0) )
{
	if (admpayday==0) {rpayday++;}
	new BasePayM,BasePayX,string[MAX_STRING];
	admpayday=0;
	PayDayZoneID();
	for (new id = 0; id < MAX_PLAYERS; id++)
	{
		 if (IsPlayerConnected(id))
		 {
			BasePayM=0;
			if (GetPlayerTotalMoney(id) < PayCutoff)	//MONEY
			{
			BasePayM=BasePay+(BasePay*Player[id][Level]);
			oGivePlayerMoney(id, BasePayM, 0);
			}

			BasePayX=0;
			if (GetPlayerXP(id) < MAX_LVLXP)		//XP
			{
			BasePayX=BasePayXP+(BasePayXP*Player[id][Level]); //200+(200*0) 200+(200*20)
			GivePlayerXP(id, BasePayX ,0);
			CheckPlayerLevel(id);
			}

			format(string, sizeof(string), lang_texts[2][12], BasePayM, BasePayX );
			SendClientMessage(id, COLOUR_MONEY_GOOD, string);
			format(string, sizeof(string), lang_texts[2][13], BasePayM, BasePayX );
			GameTextForPlayer(id, string ,999, 5);
			PlayerPlaySound(id, 1190, 0.0, 0.0, 0.0);
			PlayerPlaySound(id, 1101, 0.0, 0.0, 0.0);
			
			// Зарплата для Владельцов зон
            
            new CountZone[MAX_GANGS]; // На это число будем умножать ХР и Деньги
			for(new i=0;i<MAX_GANG_ZONE;i++)
			{
				new gangid = -1;
				gangid = GetGangIDFromSQLID( ZoneInfo[i][Zones_GangSQLID] ); // Владелец
				if (ZoneInfo[i][Zones_GangSQLID] != -1)
				{
					if(gangid != -1)
					{
						CountZone[gangid]++;
					}
				}
			}
			
			new LvlZone = GetPlayerScore(id);
			if(LvlZone < 10) XPZone = 350;
			else if(LvlZone > 9 && LvlZone < 15) XPZone = 600;
			else if(LvlZone > 14 && LvlZone < 20) XPZone = 1000;
			else if(LvlZone > 19 && LvlZone < 30) XPZone = 2500;
			else if(LvlZone > 29 && LvlZone < 40) XPZone = 4000;
			
			DataXP[id] = XPZone * CountZone[PlayerGangID[id]];
			//printf("ID: %d, DataXP[%d]: %d, CountZone: %d", id, id, DataXP[id], CountZone[PlayerGangID[id]]);
			//DataMoney[id] = MoneyZone * CountZone[PlayerGangID[id]];
			
			/*printf("MoneyZone = %d", MoneyZone);
			printf("XPZone = %d", XPZone);
			printf("CountZone = %d", CountZone);
			printf("DataMoney[%d] = %d",id,DataMoney[id]);
            printf("DataXP[%d] = %d",id,DataXP[id]);*/
			
			if (PlayerGangID[id] != -1)
			{
			    if(CountZone[PlayerGangID[id]] >= 1)
				{
			    	GivePlayerXP(id, DataXP[id], 0);
					format(string, sizeof(string), lang_texts[2][14],  DataXP[id] );
					SendClientMessage(id, COLOUR_MONEY_GOOD, string);
				}
			}
 			/*if(Gangs[gangid][gang_bank] > DataMoney[gangid])
  			{
				if ( GangMembers[gangid][0][member_sqlid] == PlayerSQLID[id] )
				{
					format(string, sizeof(string), lang_texts[23][6],  DataMoney[gangid]);
					SendClientMessage(id, COLOUR_MONEY_GOOD, string);
				}
				Gangs[gangid][gang_bank] = Gangs[gangid][gang_bank] - DataMoney[gangid];
			}
			else
			{
			if ( GangMembers[gangid][0][member_sqlid] == PlayerSQLID[id] )
			{
  				SendPlayerFormattedText(id,  lang_texts[23][5] , 0,COLOUR_RED);
			}
				new zoneid = 0;
				zoneid = GetGangZoneID( ZoneInfo[i][Zones_GangSQLID] );
				if(zoneid > 0) {ZoneMakeOwnerless(zoneid,1); UpdateColor(zoneid);} // Банда и если владела зоной, то зона становится ничейной
			}*/
            
			/*new gangid = -1;
			gangid = GetGangIDFromSQLID( ZoneInfo[zoneid][Zones_GangSQLID] ); // Владелец
			
			if (PlayerGangID[id] == gangid)
			//if (ZoneInfo[i][Zones_GangSQLID] == PlayerGangSQLID[id])
			{
			    GivePlayerXP(id, XPZone, 0);
				format(string, sizeof(string), lang_texts[2][14],  XPZone );
				SendClientMessage(id, COLOUR_MONEY_GOOD, string);
			}
 			if(Gangs[gangid][gang_bank] > MoneyZone)
  			{
				if ( GangMembers[gangid][0][member_sqlid] == PlayerSQLID[id] )
				{
					format(string, sizeof(string), lang_texts[23][6],  MoneyZone);
					SendClientMessage(id, COLOUR_MONEY_GOOD, string);
				}
				Gangs[gangid][gang_bank] = Gangs[gangid][gang_bank] - MoneyZone;
			}
			else
			{
			if ( GangMembers[gangid][0][member_sqlid] == PlayerSQLID[id] )
			{
  				SendPlayerFormattedText(id,  lang_texts[23][5] , 0,COLOUR_RED);
			}
				new zoneid = 0;
				zoneid = GetGangZoneID( ZoneInfo[i][Zones_GangSQLID] );
				if(zoneid > 0) {ZoneMakeOwnerless(zoneid,1); UpdateColor(zoneid);} // Банда и если владела зоной, то зона становится ничейной
			}*/
		}
	}
}
}

PaydayLoadConfig()
{
	if (ForceOverwrite) return;
	if (!dini_Exists(ConfigDB)) return;
	new temp[MAX_STRING];
	set(temp,dini_Get(ConfigDB,"Payday_Base"));
	if (strlen(temp) > 0) BasePay = strval(temp);
	set(temp,nullstr);
	set(temp,dini_Get(ConfigDB,"Payday_Cutoff"));
	if (strlen(temp) > 0) PayCutoff = strval(temp);

	return;
}

PaydaySaveConfig()
{
	if (!dini_Exists(ConfigDB)) return;
	new temp[MAX_STRING];
	valstr(temp,BasePay);
	dini_Set(ConfigDB,"Payday_Base",temp);
	valstr(temp,PayCutoff);
	dini_Set(ConfigDB,"Payday_Cutoff",temp);
	return;
}
