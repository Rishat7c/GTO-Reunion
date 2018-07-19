#if defined _clothes_included
  #endinput
#endif
#define _clothes_included
#pragma library clothes

#define CLCount 3

new EnterToClothes[CLCount][CoordInfo] = {
	{2244.6694,-1664.3196,15.4766}, // LS
	{2090.5325,2224.4365,11.0234}, // LV
	{-1694.2429,950.9510,24.8906} // SF
};

new ChangeClothes[CLCount][CoordInfo] = {
	{215.0163,-100.1271,1005.2578}, // LS
	{214.3250,-130.0623,1003.5078}, // LV
	{208.6242,-35.7182,1001.9297} // SF
};

new ExitToCity[CLCount][CoordInfo] = {
	{207.6119,-110.4472,1005.1328}, // LS
	{206.8617,-139.3431,1003.5078}, // LV
	{203.8159,-50.0513,1001.8047} // SF
};

new clothesid[CLCount];
new Text3D:clothesidtext[CLCount];

forward OnClothesInit();
public OnClothesInit()
{
	for (new clid=0;clid<CLCount;clid++)
	{
	    new temp[MAX_STRING];
	    clothesid[clid] = CreatePickup(1275,1,EnterToClothes[clid][Coord_X],EnterToClothes[clid][Coord_Y],EnterToClothes[clid][Coord_Z],0);
   		format(temp,sizeof(temp), "Магазин одежды\nДля вызова меню нажми 'Num 4'");
		clothesidtext[clid]=Create3DTextLabel(temp,COLOUR_WHITE,ChangeClothes[clid][Coord_X],ChangeClothes[clid][Coord_Y],ChangeClothes[clid][Coord_Z],40.0,0,1);
	    clothesid[clid] = CreatePickup(1275,1,ChangeClothes[clid][Coord_X],ChangeClothes[clid][Coord_Y],ChangeClothes[clid][Coord_Z],0);
		format(temp,sizeof(temp), "Магазин одежды\nДля входа в магазин нажми 'Num 4'");
		clothesidtext[clid]=Create3DTextLabel(temp,COLOUR_WHITE,EnterToClothes[clid][Coord_X],EnterToClothes[clid][Coord_Y],EnterToClothes[clid][Coord_Z],40.0,0,1);
  		clothesid[clid] = CreatePickup(1275,1,ExitToCity[clid][Coord_X],ExitToCity[clid][Coord_Y],ExitToCity[clid][Coord_Z],0);
   		format(temp,sizeof(temp), "Магазин одежды\nДля выхода из магазина нажми 'Num 4'");
		clothesidtext[clid]=Create3DTextLabel(temp,COLOUR_WHITE,ExitToCity[clid][Coord_X],ExitToCity[clid][Coord_Y],ExitToCity[clid][Coord_Z],40.0,0,1);
		clothesid[clid]=CreateStreamMapIcon(45, EnterToClothes[clid][Coord_X], EnterToClothes[clid][Coord_Y], EnterToClothes[clid][Coord_Z]);
	}
}

forward IsPlayerAtClothes(playerid);
public IsPlayerAtClothes(playerid)
{
	for (new id=0;id<CLCount;id++)
	{
		if (IsPlayerInRangeOfPoint(playerid,1.0,EnterToClothes[id][Coord_X],EnterToClothes[id][Coord_Y],EnterToClothes[id][Coord_Z]))
		{
			return 1;
		}
	}
	return 0;
}

forward GetClothesID(playerid);
public GetClothesID(playerid)
{
	new lookupid=-1;
	for (new id=0;id<CLCount;id++)
	{
		if (IsPlayerInRangeOfPoint(playerid,1.0,EnterToClothes[id][Coord_X],EnterToClothes[id][Coord_Y],EnterToClothes[id][Coord_Z])) lookupid = id;
	}
	return lookupid;
}

forward IsPlayerAtChangeClothes(playerid);
public IsPlayerAtChangeClothes(playerid)
{
	for (new id=0;id<CLCount;id++)
	{
		if (IsPlayerInRangeOfPoint(playerid,1.0,ChangeClothes[id][Coord_X],ChangeClothes[id][Coord_Y],ChangeClothes[id][Coord_Z]))
		{
			return 1;
		}
	}
	return 0;
}

forward IsPlayerAtExitClothes(playerid);
public IsPlayerAtExitClothes(playerid)
{
	for (new id=0;id<CLCount;id++)
	{
		if (IsPlayerInRangeOfPoint(playerid,1.0,ExitToCity[id][Coord_X],ExitToCity[id][Coord_Y],ExitToCity[id][Coord_Z]))
		{
			return 1;
		}
	}
	return 0;
}

forward GetExitClothesID(playerid);
public GetExitClothesID(playerid)
{
	new lookupid=-1;
	for (new id=0;id<CLCount;id++)
	{
		if (IsPlayerInRangeOfPoint(playerid,1.0,ExitToCity[id][Coord_X],ExitToCity[id][Coord_Y],ExitToCity[id][Coord_Z])) lookupid = id;
	}
	return lookupid;
}

