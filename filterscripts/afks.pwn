// This is a comment
// uncomment the line below if you want to write a filterscript
#define COLOR_WHITE -1

#include <a_samp>

new plafk[MAX_PLAYERS];

public OnFilterScriptInit()
{
	SetTimer("AFKSystem", 1000, 1);
	return 1;
}

public OnPlayerUpdate(playerid)
{
    if(!IsPlayerNPC(playerid) && plafk[playerid] > -2)
    {
    	if(plafk[playerid] > 5)
   		{
           		new string[128];
            	format(string,sizeof(string),"Время вашего АФК: %s",ConvertSeconds(plafk[playerid]));
           		SendClientMessage(playerid, -1, string);
            	SetPlayerChatBubble(playerid, "АФК: завершено", COLOR_WHITE, 10.0, 1);
   		}

		plafk[playerid] = 0;
	}
    return 1;
}

forward AFKSystem();

public AFKSystem()
{
    for(new playerid;playerid < MAX_PLAYERS;playerid++)
    {
        if(IsPlayerConnected(playerid) && !IsPlayerNPC(playerid))
        {
        
            printf("plafk = %d", plafk[playerid]);
        
            if(plafk[playerid] == 0) plafk[playerid] -= 1;
            else if(plafk[playerid] == -1)
            {
                plafk[playerid] = 1;
                new string[128];
                format(string, sizeof(string), "АФК: %s", ConvertSeconds(plafk[playerid]));
                SetPlayerChatBubble(playerid, string, COLOR_WHITE, 10.0, 70000000);
            }
            else if(plafk[playerid] > 0)
            {
                new string[255];
                plafk[playerid] += 1;
                format(string, sizeof(string), "АФК: %s", ConvertSeconds(plafk[playerid]));
                SetPlayerChatBubble(playerid, string, COLOR_WHITE, 10.0, 70000000);
                
/*                if(plafk[playerid] >= 30)
				{
					Kick(playerid);
				}*/
            }
        }
    }
}


public OnPlayerDeath(playerid, killerid, reason)
{
    plafk[playerid] = -2;
    return 1;
}


main() {}


public OnPlayerConnect(playerid)
{
    plafk[playerid] = -2;
	return 1;
}

public OnPlayerSpawn(playerid)
{
    plafk[playerid] = 0;
	return 1;
}

stock ConvertSeconds(time)
{
    new string[128];
    if(time < 60) format(string, sizeof(string), "%d секунд", time);
    else if(time == 60) string = "1 минуту";
    else if(time > 60 && time < 3600)
    {
        new Float: minutes;
        new seconds;
        minutes = time / 60;
        seconds = time % 60;
        format(string, sizeof(string), "%.0f минут и %d секунд", minutes, seconds);
    }
    else if(time == 3600) string = "1 час";
    else if(time > 3600)
    {
        new Float: hours;
        new minutes_int;
        new Float: minutes;
        new seconds;
        hours = time / 3600;
        minutes_int = time % 3600;
        minutes = minutes_int / 60;
        seconds = minutes_int % 60;
        format(string, sizeof(string), "%.0f:%.0f:%d", hours, minutes, seconds);
    }
    return string;
}
