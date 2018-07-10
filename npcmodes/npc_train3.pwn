
#include <a_npc>

#define NUM_PLAYBACK_FILES 7
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
	    StartRecordingPlayback(PLAYER_RECORDING_TYPE_DRIVER,"npc_train6");
	}
	else if(gPlaybackFileCycle==1)
	{
		StartRecordingPlayback(PLAYER_RECORDING_TYPE_DRIVER,"npc_train7");
	}
	else if(gPlaybackFileCycle==2)
	{
	    StartRecordingPlayback(PLAYER_RECORDING_TYPE_DRIVER,"npc_train1");
	}
	else if(gPlaybackFileCycle==3)
	{
	    StartRecordingPlayback(PLAYER_RECORDING_TYPE_DRIVER,"npc_train2");
	}
	else if(gPlaybackFileCycle==4)
	{
	    StartRecordingPlayback(PLAYER_RECORDING_TYPE_DRIVER,"npc_train3");
	}
	else if(gPlaybackFileCycle==5)
	{
	    StartRecordingPlayback(PLAYER_RECORDING_TYPE_DRIVER,"npc_train4");
	}
	else if(gPlaybackFileCycle==6)
	{
	    StartRecordingPlayback(PLAYER_RECORDING_TYPE_DRIVER,"npc_train5");
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
