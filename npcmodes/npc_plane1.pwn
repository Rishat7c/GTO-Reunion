
#include <a_npc>

#define NUM_PLAYBACK_FILES 3
new gPlaybackFileCycle=0;

//------------------------------------------

main(){}

//------------------------------------------

NextPlayback()
{
	// Reset the cycle count if we reach the max
	if(gPlaybackFileCycle==NUM_PLAYBACK_FILES) gPlaybackFileCycle = 0;

	if(gPlaybackFileCycle==0)
	{
	    StartRecordingPlayback(PLAYER_RECORDING_TYPE_DRIVER,"npc_plane1");
	}
	else if(gPlaybackFileCycle==1)
	{
		StartRecordingPlayback(PLAYER_RECORDING_TYPE_DRIVER,"npc_plane2");
	}
	else if(gPlaybackFileCycle==2)
	{
 		StartRecordingPlayback(PLAYER_RECORDING_TYPE_DRIVER,"npc_plane3");
	}

	gPlaybackFileCycle++;
}
	

//------------------------------------------

public OnRecordingPlaybackEnd()
{
    NextPlayback();
}

//------------------------------------------

public OnNPCEnterVehicle(vehicleid, seatid)
{
    NextPlayback();
}

//------------------------------------------

public OnNPCExitVehicle()
{
    StopRecordingPlayback();
    gPlaybackFileCycle = 0;
}

//------------------------------------------
