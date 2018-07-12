#include <a_samp>
#include <mSelection>

#define CUSTOM_TRAILER_MENU 1

public OnPlayerCommandText(playerid, cmdtext[])
{
	if(strcmp(cmdtext, "/selectVehicleTrailer", true) == 0)
	{
	    new cars[15];
	    cars[0] = 435;
	    cars[1] = 450;
	    cars[2] = 569;
	    cars[3] = 570;
	    cars[4] = 584;
	    cars[5] = 590;
	    cars[6] = 591;
	    cars[7] = 606;
	    cars[8] = 607;
	    cars[9] = 608;
	    cars[10] = 610;
	    cars[11] = 611;
	    ShowModelSelectionMenuEx(playerid, cars, 12, "Select trailer", CUSTOM_TRAILER_MENU, 16.0, 0.0, -55.0);
	    return 1;
	}
	return 0;
}

public OnPlayerModelSelectionEx(playerid, response, extraid, modelid)
{
	if(extraid == CUSTOM_TRAILER_MENU)
	{
	    if(response)
	    {
		    SendClientMessage(playerid, 0xFF0000FF, "Trailer Spawned");
	    	new Float:pos[3]; GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	    	CreateVehicle(modelid, pos[0] + 2.5, pos[1], pos[2] + 2.5, 0.0, random(128), random(128), -1);
		}
	    else SendClientMessage(playerid, 0xFF0000FF, "Canceled trailer selection");
	}
	return 1;
}
