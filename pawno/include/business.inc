//
// Created:     27.11.06
// Aurthor:     Peter Steenbergen
// ReCreate: Artem Firstov (Konsul)

#if defined _business_included
#endinput
#endif
/*
#define _business_included
#pragma library business
#include "base"
#include "utils\gtoutils"
#include "utils\dutils"
#include "utils\gtodudb"
#include "utils\dini"
#include "account"
#include "player"
#include "world"*/

forward BusinessInit();
forward IsPlayerAtBusiness(playerid);
forward OnPlayerEnterBusinessCheckpoint(playerid);
forward GetBusinessID(playerid);
forward IsPlayerHasBusiness(playersqlid);
forward SetNewOwnerNameToAllPlayerBus(playersqlid,newnick[]);
forward TurnAround();
forward BusinessCommandHandler(playerid,text[]);

//forward BisMenuInit();
forward FBisInfo(playerid);
forward FBisBuy(playerid);
forward FBisSell(playerid);
forward FBisCollect(playerid);
forward FBisBises(playerid);
forward FBisMyBises(playerid);

forward DialogPlayerBisiness(playerid);
forward BusinessesMakeOwnerless(id,save);

#define MAX_BUSINESBUYSELL 999999999
#define MAX_BUSINESSES 30

#define TurnAroundDelay 600000 // Delay between businesses turnaround

new TurnsInHour = 3600000/TurnAroundDelay;
new ValueMultipleMax = 120;
new ValueMultiple = 10;


enum BusinessInfo {
	Business_DBID,
	Business_Name[MAX_STRING],  // business name
	Business_Cost,              // cost
	Business_Value,             // value
	Business_Level,             // minumum level
	Business_Owner[MAX_NAME],   // owner
	Business_OwnerSQLID,
	Business_Buyout,            // Buyout price
	Business_Vault              // Vault
}

new Businesses[MAX_BUSINESSES][BusinessInfo] = {
	//NAME,COST,VALUE,LEVEL,OWNER,BUYOUT
	{1,"Gof Club",550000,800,5,"<Unknown>",0,0,0},
	{2,"Botique",350000,800,5,"<Unknown>",0,0,0},
	{3,"Shithole Bar",250000,1300,8,"<Unknown>",0,0,0},
	{4,"Tattoo Parlor",400000,600,3,"<Unknown>",0,0,0},
	{5,"Binco Clothing",150000,800,5,"<Unknown>",0,0,0},
	
	{6,"Train Hard Clothing",150000,800,5,"<Unknown>",0,0,0},
	{7,"Urban Clothing",150000,800,5,"<Unknown>",0,0,0},
	{8,"Victim Clothing",150000,800,5,"<Unknown>",0,0,0},
	{9,"Zip Clothing",150000,800,5,"<Unknown>",0,0,0},
	{10,"DidierSachs Clothing",200000,950,7,"<Unknown>",0,0,0},
	
	{11,"Gym",200000,1000,7,"<Unknown>",0,0,0},
	{12,"Zero RC",100000,900,3,"<Unknown>",0,0,0},
	{13,"Zombotech",350000,1600,12,"<Unknown>",0,0,0},
	{14,"Verdant Meadows Air Strip",200000,1200,7,"<Unknown>",0,0,0},
	{15,"Blueberry Liquor Store",150000,850,5,"<Unknown>",0,0,0},
	
	{16,"Club-Disco",500000,1600,10,"<Unknown>",0,0,0},
	{17,"Lil Probe-Inn",470000,1100,6,"<Unknown>",0,0,0},
	{18,"Sex Shop",400000,950,7,"<Unknown>",0,0,0},
	{19,"Strip Club",600000,1400,10,"<Unknown>",0,0,0},
	{20,"The Big Spread Ranch",480000,1450,9,"<Unknown>",0,0,0},
	
	{21,"Jizzys",580000,1675,13,"<Unknown>",0,0,0},
	{22,"The Sherman Dam",580000,1800,16,"<Unknown>",0,0,0},
	{23,"Cobra Marital Arts",150000,800,5,"<Unknown>",0,0,0},
	{24,"City Planning Department",350000,1600,12,"<Unknown>",0,0,0},
	{25,"Inside Track",200000,1200,7,"<Unknown>",0,0,0},
	
	{26,"Coutt and Schutz Auto",250000,1250,8,"<Unknown>",0,0,0},
	{27,"Ottos Auto",250000,1250,8,"<Unknown>",0,0,0},
	{28,"Wang Cars",250000,1250,22,"<Unknown>",0,0,0},
	{29,"Caligulas",3750000,19900,30,"<Unknown>",0,0,0},
	{30,"Four Dragons",2050000,16000,28,"<Unknown>",0,0,0}
};

new BusinessCP[MAX_BUSINESSES][CoordInfo] = {
	{1459.633178,2773.585205,10.820312},
 {418.5547,-80.1667,1001.8047},
	{501.4927,-75.4323,998.7578},
	{-203.4864,-41.2045,1002.2734},
	{207.5640,-97.8188,1005.2578},
	{210.1111,-129.1273,1003.5152},
	{203.8557,-40.4717,1001.8047},
	{210.3724,-8.1825,1005.2109},
	{161.1875,-79.9915,1001.8047},
	{204.2810,-157.2614,1000.5234},
	{773.6138,-72.1616,1000.6484},
	{-2231.2478,131.9623,1035.4141},
	{-1951.5938,704.3567,46.5625},
	{418.1210,2536.8762,10.0000},
	{252.4851,-57.3515,1.5703},
	{500.7049,-13.3777,1000.6797},
	{-225.7790,1403.9459,27.7734},
	{-103.5525,-22.4661,1000.7188},
	{1212.3918,-10.9459,1000.9219},
	{1208.5027,-32.6044,1000.9531},
	{-2650.0667,1409.2106,906.2734},
	{-955.5327,1948.5414,9.0000},
	{768.2014,-36.9461,1000.6865},
	{357.0584,173.5787,1008.3820},
	{823.1819,3.2361,1004.1797},
	{2131.6455,-1148.2836,24.3898},
	{-1657.8334,1207.3041,7.2500},
	{-1957.5327,300.2131,35.4688},
	{2235.5408,1679.0402,1008.3594},
	{1993.9758,1017.8945,994.8906}
};

/*
new Menu:BisMenu;

public BisMenuInit()     //Create by FP
{
//	new rst[256]="edited...";

	BisMenu = CreateMenu("Business", 1, 30.0, 150.0, 100.0, 140.0);
//	SetMenuColumnHeader(BisMenu, 0, "");
		AddMenuItem(BisMenu, 0, "~<~ Exit");
		AddMenuItem(BisMenu, 0, "Information");
		AddMenuItem(BisMenu, 0, "Buy");
		AddMenuItem(BisMenu, 0, "Sell");
//		AddMenuItem(BisMenu, 0, "Set Sell Cost");
		AddMenuItem(BisMenu, 0, "Collect");
		AddMenuItem(BisMenu, 0, "My Busin-s");
		AddMenuItem(BisMenu, 0, "All Busin-s");


return 1;
}
*/


new BusinessDB[MAX_STRING] = "GTO/Business/";

/*BusinessLoadAll()
{
for (new i=0;i<MAX_BUSINESSES;i++)
{
new businessdbname[MAX_STRING];
format(businessdbname,sizeof(businessdbname),"%sGTO.Business.%d.rdb",BusinessDB,Businesses[i][Business_DBID]);
if (!dini_Exists(businessdbname)) {BusinessSave(i); continue;}
set(Businesses[i][Business_Name],dini_Get(businessdbname,"Name"));
Businesses[i][Business_Cost] = dini_Int(businessdbname,"Cost");
Businesses[i][Business_Value] = dini_Int(businessdbname,"Value");
Businesses[i][Business_Level] = dini_Int(businessdbname,"Level");
set(Businesses[i][Business_Owner],dini_Get(businessdbname,"Owner"));
Businesses[i][Business_OwnerSQLID] = dini_Int(businessdbname,"OwnerSQLID");
Businesses[i][Business_Buyout] = dini_Int(businessdbname,"Buyout");
Businesses[i][Business_Vault] = dini_Int(businessdbname,"Vault");
}
return;
}
*/
BusinessSave(i)
{
new businessdbname[MAX_STRING];
format(businessdbname,sizeof(businessdbname),"%sGTO.Business.%d.rdb",BusinessDB,Businesses[i][Business_DBID]);
if (!dini_Exists(businessdbname)) {dini_Create(businessdbname);}
dini_Set(businessdbname,"Name",Businesses[i][Business_Name]);
dini_IntSet(businessdbname,"Cost",Businesses[i][Business_Cost]);
dini_IntSet(businessdbname,"Value",Businesses[i][Business_Value]);
dini_IntSet(businessdbname,"Level",Businesses[i][Business_Level]);
dini_Set(businessdbname,"Owner",Businesses[i][Business_Owner]);
dini_IntSet(businessdbname,"OwnerSQLID",Businesses[i][Business_OwnerSQLID]);
dini_IntSet(businessdbname,"Buyout",Businesses[i][Business_Buyout]);
dini_IntSet(businessdbname,"Vault",Businesses[i][Business_Vault]);
return;
}

/*
BusinessSaveAll(param = -1)
{
	new temp[MAX_STRING];
	if (dini_Exists(ConfigDB))
	{
		dini_Set(ConfigDB,"Business_DB",BusinessDB);
	}
	
	new st, end;
	
	if(param == -1)
	{
	st = param + 1;
	end = MAX_BUSINESSES;
	}
	
	if(param > -1 && param < MAX_BUSINESSES)
	{
	st = param;
	end = param + 1;
	}
	
	
	for (new i = st;i<end;i++)
	{
		new businessdbname[MAX_STRING];
		format(businessdbname,sizeof(businessdbname),"%sGTO.Business.%s.txt",BusinessDB,Businesses[i][Business_Name]);
		if (!dini_Exists(businessdbname)) dini_Create(businessdbname);
		dini_Set(businessdbname,"Name",Businesses[i][Business_Name]);
		valstr(temp,Businesses[i][Business_Cost]);
		dini_Set(businessdbname,"Cost",temp);
		set(temp,nullstr);
		valstr(temp,Businesses[i][Business_Value]);
		dini_Set(businessdbname,"Value",temp);
		set(temp,nullstr);
		valstr(temp,Businesses[i][Business_Level]);
		dini_Set(businessdbname,"Level",temp);
		set(temp,nullstr);
		dini_Set(businessdbname,"Owner",Businesses[i][Business_Owner]);
		valstr(temp,Businesses[i][Business_Buyout]);
		dini_Set(businessdbname,"Buyout",temp);
		set(temp,nullstr);
		valstr(temp,Businesses[i][Business_Vault]);
		dini_Set(businessdbname,"Vault",temp);
		set(temp,nullstr);
		
		//printf("Сохранил биз %d",i);
	}
	return;

}
*/

public SetNewOwnerNameToAllPlayerBus(playersqlid,newnick[]) // OK
{
	for (new id=0;id<MAX_BUSINESSES;id++)
	{
		if (Businesses[id][Business_OwnerSQLID] == playersqlid)
		{
			set(Businesses[id][Business_Owner],newnick);
			BusinessSave(id);
		}
	}
return 1;
}

public BusinessInit() // OK
{
	for (new id=0;id<MAX_BUSINESSES;id++)
	{
		AddActiveCheckpoint(BusinessCP[id][Coord_X],BusinessCP[id][Coord_Y],BusinessCP[id][Coord_Z],20,8);
		AddStaticPickup(1274,49,BusinessCP[id][Coord_X],BusinessCP[id][Coord_Y],BusinessCP[id][Coord_Z]);	//синий домик
	}
	WriteLog("Business checkpoints initialised");
}

public IsPlayerAtBusiness(playerid) // OK
{
	for (new id=0;id<MAX_BUSINESSES;id++)
	{
		if (oIsPlayerInCheckpoint(playerid,BusinessCP[id][Coord_X],BusinessCP[id][Coord_Y],BusinessCP[id][Coord_Z],8))
		{
			return 1;
		}
	}
	return 0;
}

public OnPlayerEnterBusinessCheckpoint(playerid) // OK
{
	//if (playerid == INVALIDX_PLAYER_ID) return;
	//if (playerid == INVALID_PLAYER_ID) return;
	//if (!IsPlayerConnected(playerid)) return;
	if (!IsPlayerAtBusiness(playerid)) return;

	for (new id=0;id<MAX_BUSINESSES;id++)
	{
		if (oIsPlayerInCheckpoint(playerid,BusinessCP[id][Coord_X],BusinessCP[id][Coord_Y],BusinessCP[id][Coord_Z],8))
		{
			new temp[MAX_STRING];
			format(temp,sizeof(temp), lang_texts[3][1] ,Businesses[id][Business_Name]);
			SendPlayerFormattedText(playerid, temp, 0,COLOUR_GREEN);
		}
	}
}

public GetBusinessID(playerid)
{
	new lookupid=-1;
	for (new id=0;id<MAX_BUSINESSES;id++)
	{
		if (oIsPlayerInCheckpoint(playerid,BusinessCP[id][Coord_X],BusinessCP[id][Coord_Y],BusinessCP[id][Coord_Z],8))
		{
			lookupid = id;
		}
	}
	return lookupid;
}

public IsPlayerHasBusiness(playersqlid)
{
new bova = 0;
if (playersqlid < 1) return bova;
for (new id=0;id<MAX_BUSINESSES;id++)
	{
		if (Businesses[id][Business_OwnerSQLID] == playersqlid)
		{
		bova = 1;
		break;
		}

	}
	return bova;
}


public TurnAround()
{
	//new temp[MAX_STRING];
	new vaultamount;
	new vaultmax;
	new vaultadd;
	for (new id=0;id<MAX_BUSINESSES;id++)
	{
		if(Businesses[id][Business_OwnerSQLID] > 0)
		{
			vaultmax = Businesses[id][Business_Value] * ValueMultipleMax;
			vaultadd = Businesses[id][Business_Value] * ValueMultiple;
			vaultamount = Businesses[id][Business_Vault] + vaultadd;
			if(vaultamount < vaultmax)
			{
				Businesses[id][Business_Vault] = vaultamount;
				BusinessSave(id);
			}
		}
	}
}

public BusinessCommandHandler(playerid,text[]) // process player commands
{
	if (!IsPlayerConnected(playerid)) return 0;

	new cmd[20];
	new idx;

	set(cmd,strcharsplit(text, idx,strchar(" ")));
	if (strlen(cmd) == 0) return 0;

	if (!strcmp("/bmenu", cmd, true, 5))
	{
		if (!IsPlayerAtBusiness(playerid))
		{
			SendPlayerFormattedText(playerid,  lang_texts[3][2]  , 0,COLOUR_RED);
			return 1;
		}
		else
		{
		TogglePlayerControllable(playerid, 0);
		DialogPlayerBisiness(playerid);
 	   	//if(IsValidMenu(BisMenu)) ShowMenuForPlayer(BisMenu, playerid);
		return 1;
		}
	}

	//-- businessinfo --
	if((strcomp(cmd, "/businessinfo", true) == 1) || (strcomp(cmd, "/binfo", true) == 1))
	{
		if (!IsPlayerAtBusiness(playerid))
		{
			SendPlayerFormattedText(playerid,  lang_texts[3][2]  , 0,COLOUR_RED);
			return 1;
		}
		else
		{
		FBisInfo(playerid);
		}
	return 1;
	}
	//---------------------

	//-- buybusiness --
	if((strcomp(cmd, "/businessbuy", true) == 1) || (strcomp(cmd, "/bbuy", true) == 1))
	{
		if (!IsPlayerAtBusiness(playerid))
		{
			SendPlayerFormattedText(playerid,  lang_texts[3][19]  , 0,COLOUR_RED);
			return 1;
		}
		else
		{
		FBisBuy(playerid);
		}
	return 1;
	}
	//---------------------

	//-- sellbusiness --
	if((strcomp(cmd, "/businesssell", true) == 1) || (strcomp(cmd, "/bsell", true) == 1))
	{
		if (!IsPlayerAtBusiness(playerid))
		{
			SendPlayerFormattedText(playerid,  lang_texts[3][28]  , 0,COLOUR_RED);
			return 1;
		}
		else
		{
		FBisSell(playerid);
		}
	return 1;
	}
	//--------------------
/*
	//-- set buyout --
	if(strcomp(cmd, "/setbbuyout", true) == 1)
	{
		new buyoutamount;
		buyoutamount = strval(strcharsplit(text, idx,strchar(" ")));

		if ((buyoutamount < -99999999) || (buyoutamount == 0) || (buyoutamount > 99999999) || (buyoutamount > Player[playerid][Money]))
		{
			SendPlayerFormattedText(playerid, lang_texts[3][37] , 0,COLOUR_RED);
			return 1;
		}

		if (!IsPlayerAtBusiness(playerid))
		{
			SendPlayerFormattedText(playerid,  lang_texts[3][38]  , 0,COLOUR_RED);
			return 1;
		} else {
			new id=GetBusinessID(playerid);
			new temp[MAX_STRING];
			if (id > -1)
			{
				if (IsPlayerRegistered(playerid))
				{
					if(strcomp(Businesses[id][Business_Owner], oGetPlayerName(playerid), true) == 0)
					{
						SendPlayerFormattedText(playerid,  lang_texts[3][39] , 0,COLOUR_RED);
					} else {
						new newbuyout;
						newbuyout = Businesses[id][Business_Buyout] + buyoutamount;
						if(newbuyout < 0 || newbuyout > MAX_BUSINESBUYSELL)
						{
							SendPlayerFormattedText(playerid, lang_texts[3][40] , 0,COLOUR_RED);
							return 1;
						}
						oGivePlayerMoney(playerid,0-buyoutamount,1);
						Businesses[id][Business_Buyout] = newbuyout;
						new dinifilename[MAX_STRING];
						//format(dinifilename,sizeof(dinifilename),"%sGTO.Business.%s.txt",BusinessDB,Businesses[id][Business_Name]);
						if (dini_Exists(dinifilename))
						{
							valstr(temp,Businesses[id][Business_Buyout]);
							dini_Set(dinifilename,"Buyout",temp);
							set(temp,nullstr);
						}
						if(buyoutamount > 0)
						{
 						format(temp,sizeof(temp), lang_texts[3][41] ,Businesses[id][Business_Buyout]);
							SendPlayerFormattedText(playerid, temp, 0,COLOUR_GREEN);
							set(temp,nullstr);
							new logstring[256];
							format(logstring, sizeof (logstring), "player: %d:  %s: increased the buy out of '%s' (business) to $%d",playerid,oGetPlayerName(playerid),Businesses[id][Business_Name],Businesses[id][Business_Buyout]);
							WriteLog(logstring);
						} else {
							format(temp,sizeof(temp), lang_texts[3][42] ,Businesses[id][Business_Buyout]);
							SendPlayerFormattedText(playerid, temp, 0,COLOUR_GREEN);
							set(temp,nullstr);
							new logstring[256];
							format(logstring, sizeof (logstring), "player: %d:  %s: decreased the buy out of '%s' (business) to $%d",playerid,oGetPlayerName(playerid),Businesses[id][Business_Name],Businesses[id][Business_Buyout]);
							WriteLog(logstring);
						}
					}
				} else {
					SendPlayerFormattedText(playerid,  lang_texts[3][43] , 0,COLOUR_RED);
					SendPlayerFormattedText(playerid,  lang_texts[3][44] , 0,COLOUR_RED);
				}
			} else {
				SendPlayerFormattedText(playerid,  lang_texts[3][45] , 0,COLOUR_RED);
			}
		}
		return 1;
	}
	//----------------------
*/
	//-- collect vault --
	if(strcomp(cmd, "/collect", true) == 1)
	{
		if (!IsPlayerAtBusiness(playerid))
		{
			SendPlayerFormattedText(playerid,  lang_texts[3][46]  , 0,COLOUR_RED);
			return 1;
		}
		else
		{
		FBisCollect(playerid);
		}
	return 1;
	}
	//---------------------

	//-- businesses list --
	if(strcomp(cmd, "/businesses", true) == 1)
	{
	FBisBises(playerid);
	return 1;
	}


	//-------------------------

	//--  my businesses list --
	if(strcomp(cmd, "/mybusinesses", true) == 1)
	{
	FBisMyBises(playerid);
	return 1;
	}


	//-------------------------
	return 0;
}


//----------------RECOMPILED BUSINESSES----------------------------------------

public FBisInfo(playerid) {
	new id=GetBusinessID(playerid);
	new mhead[64];
	new temp[512];
			
	if (id == -1) {
	ShowPlayerDialog(playerid,S_GUI_01,0,":: Ой-ой-ой оО ::",lang_texts[3][18],"OК","Выход");
	return 1;}
	
	format(mhead,sizeof(mhead),":: %s ::",Businesses[id][Business_Name]);
	format(temp,sizeof(temp),"%sТип:\n\tБизнес [id %d]\n\n",temp,id);
	
	new price;
	price = Businesses[id][Business_Cost] + Businesses[id][Business_Buyout];
	
	if(Businesses[id][Business_OwnerSQLID] > 0)
	{
		if(Businesses[id][Business_OwnerSQLID] == PlayerSQLID[playerid])
		{
			//SendPlayerFormattedText(playerid,  lang_texts[3][8] , 0,COLOUR_GREEN);
			format(temp,sizeof(temp),"%sВладелец:\n\tВы (%s)\n\n",temp,Businesses[id][Business_Owner]);
			
			price = (price * 75) / 100;

			if (Businesses[id][Business_Vault] > 0)
			{
				format(temp,sizeof(temp), "%sДоступная прибыль:\n\t%d $\n\n" ,temp,Businesses[id][Business_Vault]);
				//SendPlayerFormattedText(playerid, temp, 0,COLOUR_GREEN);
				//set(temp,nullstr);
				//SendPlayerFormattedText(playerid,  lang_texts[3][10] , 0,COLOUR_GREEN);
			}
	
			format(temp,sizeof(temp), "%sСтоимость продажи:\n\t%d $" ,temp,price);
			//SendPlayerFormattedText(playerid, temp, 0,COLOUR_GREEN);
			//set(temp,nullstr);
			//SendPlayerFormattedText(playerid,  lang_texts[3][12] , 0,COLOUR_GREEN);
			
		} else
		{
			format(temp,sizeof(temp),"%sВладелец:\n\t%s\n\nСтоимость:\n\t%d $\n\nМинимальный уровень:\n\t%d\n\nПрибыль:\n\t%d $ в час",temp,Businesses[id][Business_Owner],price,Businesses[id][Business_Level],Businesses[id][Business_Value]*TurnsInHour);
			
		
			//format(temp,sizeof(temp), lang_texts[3][4] ,Businesses[id][Business_Owner]);
			//SendPlayerFormattedText(playerid, temp, 0,COLOUR_GREEN);
			//set(temp,nullstr);
			//format(temp,sizeof(temp), lang_texts[3][5] ,price);
			//SendPlayerFormattedText(playerid, temp, 0,COLOUR_GREEN);
			//set(temp,nullstr);
			//format(temp,sizeof(temp), lang_texts[3][6] ,Businesses[id][Business_Level]);
			//SendPlayerFormattedText(playerid, temp, 0,COLOUR_GREEN);
			//set(temp,nullstr);
			//format(temp,sizeof(temp), lang_texts[3][7] ,Businesses[id][Business_Value]);
			//SendPlayerFormattedText(playerid, temp, 0,COLOUR_GREEN);
			//set(temp,nullstr);

		}

	} else
	{
		format(temp,sizeof(temp),"%sВладелец:\n\tНикому не принадлежит\n\nСтоимость:\n\t%d $\n\nМинимальный уровень:\n\t%d\n\nПрибыль:\n\t%d $ в час",temp,price,Businesses[id][Business_Level],Businesses[id][Business_Value]*TurnsInHour);
		//SendPlayerFormattedText(playerid,  lang_texts[3][13] , 0,COLOUR_GREEN);
		//format(temp,sizeof(temp), lang_texts[3][14] ,Businesses[id][Business_Cost]);
		//SendPlayerFormattedText(playerid, temp, 0,COLOUR_GREEN);
		//set(temp,nullstr);
		//format(temp,sizeof(temp), lang_texts[3][15] ,Businesses[id][Business_Level]);
		//SendPlayerFormattedText(playerid, temp, 0,COLOUR_GREEN);
		//set(temp,nullstr);
		//format(temp,sizeof(temp), lang_texts[3][16] ,Businesses[id][Business_Value]);
		//SendPlayerFormattedText(playerid, temp, 0,COLOUR_GREEN);
		//set(temp,nullstr);
		//SendPlayerFormattedText(playerid,  lang_texts[3][17] , 0,COLOUR_GREEN);
	}
	ShowPlayerDialog(playerid,S_GUI_01,0,mhead,temp,"OК","Выход");
return 1;
}

public FBisBuy(playerid) {
	new id=GetBusinessID(playerid);
	new temp[MAX_STRING];
	
	if (id == -1) {
	SendPlayerFormattedText(playerid,  lang_texts[3][27] , 0,COLOUR_RED);
	return 1;}
	
	if (!IsPlayerRegistered(playerid)) {
	SendPlayerFormattedText(playerid,  lang_texts[3][26] , 0,COLOUR_RED);
	return 1;}
	
	if (Player[playerid][Level] < Businesses[id][Business_Level]) {
	format(temp,sizeof(temp), lang_texts[3][25] ,Businesses[id][Business_Level]);
	SendPlayerFormattedText(playerid, temp, 0,COLOUR_RED); set(temp,nullstr);
	return 1;}
	
	new price;
	price = Businesses[id][Business_Cost] + Businesses[id][Business_Buyout];
	
	if(Player[playerid][Money] < price) {
	SendPlayerFormattedText(playerid,  lang_texts[3][24] , 0,COLOUR_RED);
	return 1;}

	if(Businesses[id][Business_OwnerSQLID] == PlayerSQLID[playerid])
	{
		SendPlayerFormattedText(playerid,  lang_texts[3][20] , 0,COLOUR_RED);
	} else {
				new owner=-1;
				
				for (new ownerid = 0; ownerid < MAX_PLAYERS; ownerid++)
				{
					if (!IsPlayerConnected(ownerid)){continue;}	
					if(Businesses[id][Business_OwnerSQLID] == PlayerSQLID[ownerid])
						{owner=ownerid;}		
				}
				
				oGivePlayerMoney(playerid,0-price,1);
				
				if (owner > -1)
				{
					format(temp,sizeof(temp), lang_texts[3][21] ,Businesses[id][Business_Name],oGetPlayerName(playerid));
					SendPlayerFormattedText(owner, temp, 0,COLOUR_RED); set(temp,nullstr);
					oGivePlayerMoney(owner,0+price+Businesses[id][Business_Vault],1);
				} else
				{
					new tempmoney;			
					new DBResult:res;
					new query[128];
					format(query,sizeof(query),"SELECT bank FROM players WHERE id = %d LIMIT 1",Businesses[id][Business_OwnerSQLID]);
					res = db_query(ReunionDB,query);
									
					if(db_num_rows(res))
					{
						new mvar[32];
						db_get_field(res, 0, mvar, sizeof(mvar));
						tempmoney = strval(mvar) + price + Businesses[id][Business_Vault];
						
						if(tempmoney > MAX_BANK) {tempmoney = MAX_BANK;}
														
						format(query, sizeof(query), "UPDATE players SET bank=%d WHERE id=%d", tempmoney, Businesses[id][Business_OwnerSQLID]);
						db_query(ReunionDB,query);
					}			
					set(temp,nullstr);																
				}
				
				Businesses[id][Business_OwnerSQLID] = PlayerSQLID[playerid];
				Businesses[id][Business_Vault] = 0;
				set(Businesses[id][Business_Owner],oGetPlayerName(playerid));
				Businesses[id][Business_Buyout] = 0;
				BusinessSave(id);
										
				format(temp,sizeof(temp), lang_texts[3][22] ,Businesses[id][Business_Name]);
				SendPlayerFormattedText(playerid, temp, 0,COLOUR_GREEN); set(temp,nullstr);

				new logstring[256];
				format(logstring, sizeof (logstring), "player: %d:  %s: bought the '%s' (business)",playerid,oGetPlayerName(playerid),Businesses[id][Business_Name]);
				WriteLog(logstring);

				if (Businesses[id][Business_Vault] > 0)
				{
					format(temp,sizeof(temp), lang_texts[3][23] ,Businesses[id][Business_Vault]);
					SendPlayerFormattedText(playerid, temp, 0,COLOUR_GREEN); set(temp,nullstr);
				}
		}

return 1;
}


public FBisSell(playerid) {
	new id=GetBusinessID(playerid);
	new temp[MAX_STRING];

	if (id == -1) {
	SendPlayerFormattedText(playerid,  lang_texts[3][36] , 0,COLOUR_RED);
	return 1;}
	
	if (!IsPlayerRegistered(playerid)) {
	SendPlayerFormattedText(playerid,  lang_texts[3][34] , 0,COLOUR_RED);
	SendPlayerFormattedText(playerid,  lang_texts[3][35] , 0,COLOUR_RED);
	return 1;}
	
	new price;
	price = Businesses[id][Business_Cost] + Businesses[id][Business_Buyout];
	
	if(Businesses[id][Business_OwnerSQLID] != PlayerSQLID[playerid])
	{
		SendPlayerFormattedText(playerid,  lang_texts[3][29] , 0,COLOUR_RED);
		
		if(Businesses[id][Business_OwnerSQLID] == 0 && Player[playerid][Level] >= Businesses[id][Business_Level])
		{
			SendPlayerFormattedText(playerid,  lang_texts[3][57] , price, COLOUR_GREEN);
		}
		
		return 1;
	}
			
	price = (price * 85) / 100;
	price += Businesses[id][Business_Vault];
	oGivePlayerMoney(playerid,0+price,1);
	BusinessesMakeOwnerless(id,1);

	format(temp,sizeof(temp), lang_texts[3][30] ,Businesses[id][Business_Name]);
	SendPlayerFormattedText(playerid, temp, 0,COLOUR_GREEN); set(temp,nullstr);
	//SendPlayerFormattedText(playerid,  lang_texts[3][31] , 0,COLOUR_GREEN);
	if (Businesses[id][Business_Vault] > 0)
	{
		format(temp,sizeof(temp), lang_texts[3][32] ,Businesses[id][Business_Vault]);
		SendPlayerFormattedText(playerid, temp, 0,COLOUR_RED); set(temp,nullstr);
		SendPlayerFormattedText(playerid,  lang_texts[3][33] , 0,COLOUR_RED);
	}
	
	new logstring[256];
	format(logstring, sizeof (logstring), "player: %d:  %s: sold the '%s' (business)",playerid,oGetPlayerName(playerid),Businesses[id][Business_Name]);
	WriteLog(logstring);

return 1;
}



public FBisCollect(playerid) {
	new id=GetBusinessID(playerid);
	//new temp[MAX_STRING];
	
	if (id == -1) {
	SendPlayerFormattedText(playerid,  lang_texts[3][52] , 0,COLOUR_RED);
	return 1;}
	
	if (!IsPlayerRegistered(playerid)) {
	SendPlayerFormattedText(playerid,  lang_texts[3][50] , 0,COLOUR_RED);
	SendPlayerFormattedText(playerid,  lang_texts[3][51] , 0,COLOUR_RED);
	return 1;}
	
	if(Businesses[id][Business_OwnerSQLID] != PlayerSQLID[playerid])
	{ SendPlayerFormattedText(playerid,  lang_texts[3][47] , 0,COLOUR_RED);
	} else
	{
		if(Businesses[id][Business_Vault] > 0)
		{
			oGivePlayerMoney(playerid,0+Businesses[id][Business_Vault],1);
			SendPlayerFormattedText(playerid,  lang_texts[3][48] , 0,COLOUR_GREEN);
			Businesses[id][Business_Vault] = 0;
			BusinessSave(id);
		} else
		{
			SendPlayerFormattedText(playerid,  lang_texts[3][49] , 0,COLOUR_RED);
		}
	}
return 1;
}




public FBisBises(playerid) {
		new temp[MAX_STRING];
		for (new id=0;id<MAX_BUSINESSES;id++)
		{
			if(Businesses[id][Business_OwnerSQLID] > 0)
			{
				format(temp,sizeof(temp), lang_texts[3][53] ,Businesses[id][Business_Name],Businesses[id][Business_Owner]);
				SendPlayerScrollingText(playerid,temp);
				set(temp,nullstr);
			} else {
				format(temp,sizeof(temp), lang_texts[3][54] ,Businesses[id][Business_Name]);
				SendPlayerScrollingText(playerid,temp);
				set(temp,nullstr);
			}
		}
		return 1;
	}


public FBisMyBises(playerid) {
		new temp[MAX_STRING];
		new count = 0;
		for (new id=0;id<MAX_BUSINESSES;id++)
		{
			if(Businesses[id][Business_OwnerSQLID] == PlayerSQLID[playerid])
			{
				count++;
				format(temp,sizeof(temp), lang_texts[3][55] ,Businesses[id][Business_Name],Businesses[id][Business_Vault]);
				SendPlayerScrollingText(playerid,temp);
				set(temp,nullstr);
			}
		}
		if(count < 1)
		{
			SendPlayerFormattedText(playerid,  lang_texts[3][56] , 0,COLOUR_RED);
		}
		return 1;
	}


public BusinessesMakeOwnerless(id,save)
{
	Businesses[id][Business_OwnerSQLID] = 0;
	set(Businesses[id][Business_Owner],"<Unknown>");
	Businesses[id][Business_Vault] = 0;
	Businesses[id][Business_Buyout] = 0;
	if(save){BusinessSave(id);}
	return 1;
}
	
public DialogPlayerBisiness(playerid)
{
if (!IsPlayerConnected(playerid)) return 0;
new s[MAX_STRING];
format(s,sizeof(s), "Информация\nПриобрести\nПродать\nСнять деньги\nМои бизнесы\nВсе бизнесы", oGetPlayerName(playerid));
ShowPlayerDialog(playerid,HGUI+3,2,":: Бизнесы ::",s,"ОК ","НАЗАД");
return 1;
}
