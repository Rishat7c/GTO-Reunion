#include "b_management"

forward Business_OnPlayerCommandText(playerid,text[]);

public Business_OnPlayerCommandText(playerid,text[])
{
	new cmd[20];
	new idx;

	if (IsPlayerInAnyDM(playerid)) return 0; //Deathmatch near business. Don't do this
	
	set(cmd,strcharsplit(text, idx,strchar(" ")));
	if (strlen(cmd) == 0) return 0;

    if(strcomp(cmd, "/bmenu", true) == 1)
	{
		if (IsPlayerAtArmDealer(playerid)){
			DialogPlayerWBussines(playerid);
		} else {
			SendPlayerFormattedText(playerid,lang_texts[22][8],0,COLOUR_RED);
		}
		return 1;
	}

    if(strcomp(cmd, "/bbuy", true) == 1)
	{
		if (IsPlayerAtArmDealer(playerid)){
			BuyArmDealer(playerid);
		} else {
			SendPlayerFormattedText(playerid,lang_texts[22][8],0,COLOUR_RED);
		}
		return 1;
	}
	
 	if(strcomp(cmd, "/bcollect", true) == 1)
	{
		if (IsPlayerAtArmDealer(playerid)){
			CollectArmDealer(playerid);
		} else {
			SendPlayerFormattedText(playerid,lang_texts[22][8],0,COLOUR_RED);
		}
	}
	
	if(strcomp(cmd, "/bsell", true) == 1)
	{
		if (IsPlayerAtArmDealer(playerid)){
			SellArmDealer(playerid);
		} else {
			SendPlayerFormattedText(playerid,lang_texts[22][8],0,COLOUR_RED);
		}
		return 1;
	}
	
	if(strcomp(cmd, "/buy", true) == 1)
	{
		if (IsPlayerAtArmDealer(playerid)){
			BuyWeaponFromDealer(playerid);
		} else {
  			 SendPlayerFormattedText(playerid,lang_texts[22][8],0,COLOUR_RED);
		}
		return 1;
	}
	
	if(strcomp(cmd, "/blist", true) == 1)
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
		return 1;
	}

	return 0;
}

