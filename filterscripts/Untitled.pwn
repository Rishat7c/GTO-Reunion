//|_____���������: Makc_Astapov ���������� ��� Millenium Role Play____|
#include <a_samp>
#define RADIO 888
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys == 262144) { ShowPlayerDialog(playerid,RADIO,DIALOG_STYLE_LIST, "�������������","[1] Radio ������-FM\n[2] Radio Record\n[3] Radio Europa-Plus\n��������� �����","��������","������");}
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == RADIO && response)
	switch (listitem) {
	case 0: PlayAudioStreamForPlayer(playerid,"http://www.zaycev.fm:9001/rnb/ZaycevFM(128)");
	case 1: PlayAudioStreamForPlayer(playerid,"http://air.radiorecord.ru:805/rr_320");
	case 2: PlayAudioStreamForPlayer(playerid,"http://radio.kazantip-fm.ru:8000/mp396");
	case 3: StopAudioStreamForPlayer(playerid);}
	return 1;
}
