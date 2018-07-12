#include <a_samp>
#include <mSelection>

new planelist = mS_INVALID_LISTID;
new skinlist = mS_INVALID_LISTID;
public OnFilterScriptInit()
{
	planelist = LoadModelSelectionMenu("planes.txt");
	skinlist = LoadModelSelectionMenu("skins.txt");
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if(strcmp(cmdtext, "/plane", true) == 0)
	{
	    ShowModelSelectionMenu(playerid, planelist, "->Planes<-");
	    return 1;
	}
	if(strcmp(cmdtext, "/changeskin", true) == 0)
	{
	    ShowModelSelectionMenu(playerid, skinlist, "Select Skin");
	    return 1;
	}
	return 0;
}

public OnPlayerModelSelection(playerid, response, listid, modelid)
{
	if(listid == planelist)
	{
	    if(response)
	    {
		    SendClientMessage(playerid, 0xFF0000FF, "Plane Spawned");
	    	new Float:pos[3]; GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	    	CreateVehicle(modelid, pos[0] + 2.5, pos[1], pos[2] + 2.5, 0.0, random(128), random(128), -1);
	    }
	    else SendClientMessage(playerid, 0xFF0000FF, "Canceled plane selection");
    	return 1;
	}
	if(listid == skinlist)
	{
	    if(response)
	    {
		    SendClientMessage(playerid, 0xFF0000FF, "Skin Changed");
	    	SetPlayerSkin(playerid, modelid);
	    }
	    else SendClientMessage(playerid, 0xFF0000FF, "Canceled skin selection");
    	return 1;
	}
	return 1;
}
