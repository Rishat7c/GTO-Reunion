//Business components management module
//Created by MadCat
//Idea from PEN1

#include "vehicles"
#include "b_global"

forward Business_OnGameModeInit();
//forward MakeItems();

#define COMPONENT_COST 100

//new TimerMakeItems;

#define ONE_SA_DAY 1440000

public Business_OnGameModeInit(){
//	TimerMakeItems = SetTimer("MakeItems",ONE_SA_DAY,1);
	return 0;
}

/*public MakeItems()
{
	new temp[MAX_STRING];
	for (new i=0;i<MAX_ARMDEALERS;i++)
	{
		if(Armdealers[i][Components] > 0)
		{
			if (Armdealers[i][WeaponSell] == WEAPON_PACK){
				Armdealers[i][ItemsInStock] = Armdealers[i][ItemsInStock]+floatround((Armdealers[i][Components]*COMPONENT_COST)/PACK_COST);
				Armdealers[i][Components]=0;
				new dinifilename[MAX_STRING];
				format(dinifilename,sizeof(dinifilename),"%s%s.txt",ArmsDealerBusinessDB,Armdealers[i][Name]);
				if (dini_Exists(dinifilename)){
					valstr(temp,Armdealers[i][ItemsInStock]);
					dini_Set(dinifilename,"ItemsInStock",temp);
					set(temp,nullstr);
					valstr(temp,Armdealers[i][Components]);
					dini_Set(dinifilename,"Components",temp);
					set(temp,nullstr);
				}

			} else {
				Armdealers[i][ItemsInStock] = Armdealers[i][ItemsInStock]+floatround((Armdealers[i][Components]*COMPONENT_COST)/GetWeaponCost(Armdealers[i][WeaponSell]));
				Armdealers[i][Components]=0;
				new dinifilename[MAX_STRING];
				format(dinifilename,sizeof(dinifilename),"%s%s.txt",ArmsDealerBusinessDB,Armdealers[i][Name]);
				if (dini_Exists(dinifilename)){
					valstr(temp,Armdealers[i][ItemsInStock]);
					dini_Set(dinifilename,"ItemsInStock",temp);
					set(temp,nullstr);
					valstr(temp,Armdealers[i][Components]);
					dini_Set(dinifilename,"Components",temp);
					set(temp,nullstr);
				}
			}
		}
	}
}*/

/*BusLoadVehicles()
{
	new timestr[328];
	for (new i=0;i<sizeof(VehicleBussSpawns);i++)
	{
    if (VehicleBussSpawns[i][vspawn_model] != 0)
    {
        new vehicleid = CreateVehicle(VehicleBussSpawns[i][vspawn_model],VehicleBussSpawns[i][vspawn_x],VehicleBussSpawns[i][vspawn_y],VehicleBussSpawns[i][vspawn_z],VehicleBussSpawns[i][vspawn_heading],VehicleBussSpawns[i][vspawn_colour1],VehicleBussSpawns[i][vspawn_colour2],never);
		for (new ix=0;ix<MAX_PLAYERS;ix++)
   	 	{
        format(timestr,sizeof(timestr),"Компоненты: %d/%d",PlayerHaul[GetPlayerVehicleID(ix)][Load],PlayerHaul[GetPlayerVehicleID(ix)][Capacity]);
        }
        new Text3D: textid = Create3DTextLabel( timestr, 0xFF0000AA, 7.77, 7.77, 7.77, 100.0, 0, 1 );
        
        Attach3DTextLabelToVehicle(textid, vehicleid, 0.0, 0.0, 2.0 );

    }
	}
}*/


