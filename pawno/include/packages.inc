forward PackInit();
forward PackLog(string[]);
//forward PlayerGetPack(playerid);
//forward GetPlayerPackSignal(playerid, signal, packid);
forward xGetPlayerPackSignal(playerid, dist, packid);
forward UpdatePackSignal();
//forward OnOffPackUpdate();
forward CheckPack();
forward Pack_OnAccLogin(playerid);
forward PackHelp(playerid);
forward PackInfo(playerid);
forward PackBench();

#define PACKINGAME 32 // 30 and 2 for training
#define PACKCOORD 322 // 320 and 2 for training
#define MAX_PACK_TYPES 6
#define PACKMODEL 1276
#define MAX_PACK_LIFE 20 // milliseconds = MAX_PACK_LIFE*PACK_UPD_TIME
#define MINPACKTOVIP 50

//#define CmdTimerComandZ 19 // на всякие таймеры с отсчетом 1 минута (16 бензоколонок, +2 4me, +1 (19) раз в 10 минут сохранять дальнобоев))
//new CmdTimerComand[CmdTimerComandZ]; // всякие разные таймеры на 1 минуту

new PackNow[PACKINGAME]; // ids pickapov
new PackCond[PACKINGAME]; //0 - hide; 1 - show
new PackType[PACKINGAME];
new PackLife[PACKINGAME];
new PackNowCoords[PACKINGAME]; // ids koordinat(0-319)
new Text3D:Pack3DT[PACKINGAME]; // 3d text

new PlayerSignalLevel[MAX_PLAYERS];
new PlayerPackType[MAX_PLAYERS];

#define PTD_MAX 5
//#define SIG_UPD_TIME 1000
#define PACK_UPD_TIME 1000

#define SIG_RAD 8.0

new SignalRadius[PTD_MAX] = {45,35,25,15,5};

new PackEnable = 1; //switch

/*
new Float:PTextX = 625.00;
new Float:PTextY = 2.00;

new Float:PTextL = 13.00;
new Float:PTextS = 3.00;

new Float:PTextH = 5.00;
*/
/*
new Float:PTextX = 637.00;
new Float:PTextY = 22.00;

new Float:PTextL = 13.00;
new Float:PTextS = -3.00;

new Float:PTextH = -5.00;
*/

new Text:PTextD[PTD_MAX];
new Text:PTextF[PTD_MAX];
new Text:PTextC[MAX_PACK_TYPES];

enum pack_info {
pack_text[24],
pack_xp,
pack_money,
pack_color,
pack_icon_text[10]
}

new PackTypes[MAX_PACK_TYPES][pack_info] = {
{"RED pack",600,10000,0xff4c4cff,"RP~n~0"},
{"ORANGE pack",400,8000,0xffbc3bff,"OP~n~1"},
{"YELLOW pack",250,6000,0xfffa6eff,"YP~n~2"},
{"GREEN pack",150,4500,0x4dff3aff,"GP~n~3"},
{"BLUE pack",100,3000,0x58e2ffff,"BP~n~4"},
{"TRAINING pack",0,0,0xFFFFFFff,"TP~n~5"}
};

new PackAllCoordsStatus[PACKCOORD]; //0 - free, 1 - not free
// список координат где могут появлятся пикапы
new Float:PackAllCoords[PACKCOORD][CoordInfo] = {
{1415.1731,-806.5101,85.0408},
{1118.3169,-736.9434,100.1204},
{1104.1550,-817.9091,86.9453},
{977.5168,-769.7613,112.2026},
{1000.3095,-691.6593,121.3108},
{960.4400,-715.7138,122.2109},
{918.2813,-896.2104,45.7656},
{857.4197,-974.1622,35.5723},
{566.3318,-1098.7473,69.9513},
{567.0979,-1080.1754,72.9095},
{416.6098,-1227.2563,51.5078},
{401.6454,-1269.1322,46.9464},
{453.3344,-1281.6471,15.3463},
{169.6071,-1751.9823,5.2969},
{165.9258,-1753.9268,5.2969},
{200.0812,-1755.3966,4.3047},
{245.5795,-1873.0719,5.8867},
{154.4934,-1959.0679,3.7734},
{398.9263,-1839.5061,7.8359},
{444.8802,-1796.6162,9.0288},
{450.6554,-1818.6539,5.5469},
{674.6290,-1866.9944,5.4609},
{933.4367,-1819.6532,13.3210},
{1015.1085,-2086.3550,13.2281},
{1484.2312,-2260.1350,-2.8203},
{1649.8032,-2286.4221,-1.2098},
{1500.6146,-2284.4204,13.5537},
{1744.2811,-2241.4980,0.7813},
{1737.1602,-2081.5154,13.5469},
{1912.5092,-2003.8018,13.5469},
{1873.8245,-1955.7251,20.0703},
{1865.3163,-1966.9249,17.2587},
{2099.4597,-1980.9880,13.5469},
{2232.8618,-2283.1775,14.3751},
{2199.5525,-1970.3990,13.7841},
{2371.7483,-2135.0432,27.1750},
{2537.4749,-1988.7966,13.5469},
{2463.5706,-1956.1368,16.7995},
{2444.9585,-1952.1750,18.5500},
{2469.3809,-1960.7782,21.6944},
{2515.1450,-1966.4452,21.8167},
{2526.9507,-1705.6692,13.3879},
{1544.3529,-1631.9088,13.3828},
{1480.2827,-1769.7717,18.7958},
{1426.9103,-1453.0276,20.4246},
{1256.5510,-1439.2025,18.8331},
{1292.0057,-1438.8307,20.4783},
{1322.2969,-1424.7725,20.6780},
{1260.2583,-1424.6029,20.6642},
{1068.2500,-1495.6090,22.7578},
{1081.7810,-1355.7521,13.5418},
{1185.2874,-1160.5961,31.8125},
{1086.1941,-1268.4155,21.5469},
{914.2181,-1235.2767,17.2109},
{695.9002,-1206.4401,16.1234},
{698.6578,-1200.9480,15.2114},
{585.0529,-1542.4884,15.3822},
{473.2033,-1614.0669,24.8281},
{301.2228,-1606.9177,33.0734},
{386.0779,-1548.6986,30.6947},
{122.5483,-1506.6426,12.4259},
{-1966.8588,-983.6406,32.2266},
{-1937.4523,-982.8398,32.2266},
{-1943.0669,-1085.4150,30.7779},
{-2097.3752,-912.1835,32.1642},
{-2529.3982,-702.8594,139.3203},
{-2529.5950,-710.8627,139.3203},
{-2482.0422,-285.8586,40.5469},
{-2452.8423,-163.0121,35.3426},
{-2454.2866,-99.7558,29.1875},
{-2458.9604,-37.8122,31.6484},
{-2534.9724,-38.4593,25.6172},
{-2555.0977,-35.2057,12.6719},
{-2554.6606,26.6798,12.6021},
{-2737.6482,-18.9237,4.3986},
{-2751.6316,-58.3448,7.1875},
{-2706.4028,376.3843,4.9685},
{-2563.7947,326.7642,10.5625},
{-2482.0049,396.2013,27.7772},
{-2569.6990,444.0786,14.6094},
{-2925.4883,420.4059,4.9141},
{-2707.9033,588.9255,14.4531},
{-2592.7986,660.8199,14.4531},
{-2575.1350,653.7704,14.4531},
{-2460.1438,775.3455,35.1719},
{-2066.6030,703.2689,65.7008},
{-2105.2793,650.1674,52.3704},
{-1809.1030,562.1320,35.1641},
{-1924.0405,708.2194,47.9662},
{-1972.0513,708.2577,47.9662},
{-1957.4230,651.0477,47.7031},
{-1946.3933,667.1200,47.7031},
{-1961.8232,660.9777,47.7031},
{-1977.5232,645.1345,46.5625},
{-1926.3126,658.5806,46.5625},
{-1738.9473,526.5418,28.5939},
{-1773.5959,882.6921,25.0859},
{-1731.4290,882.7942,25.0859},
{-1752.9626,885.3676,295.8750},
{-1754.6152,884.6735,295.8750},
{-1754.7266,806.3146,42.8990},
{-1755.0642,772.3945,43.1876},
{-1746.0962,784.5506,35.5230},
{-1947.3240,996.5911,35.1756},
{-2051.0022,1138.1200,45.4453},
{-2092.6941,1044.4008,66.3858},
{-1369.3982,439.8672,7.1875},
{-1466.5581,398.9006,7.1875},
{-1385.2754,372.6891,7.1875},
{-1566.7134,315.3936,7.1875},
{-1724.7271,225.5889,1.9609},
{-1734.3506,185.8727,3.5547},
{-1685.6863,51.1506,1.4898},
{-1717.0038,14.7755,3.6063},
{-1511.8315,114.9883,17.3281},
{-1692.3550,-35.2006,3.5547},
{-1823.5326,-150.8817,9.3984},
{-1889.1250,-203.3958,14.5837},
{-1968.9659,111.1401,27.6875},
{-1969.0897,152.5365,27.6875},
{-1796.3516,376.0894,0.5994},
{-1698.4757,419.2918,12.4375},
{-1709.8755,403.5129,7.4190},
{-1390.8191,661.1123,34.5781},
{-1460.6395,1018.9660,1.7891},
{-1568.5710,1267.6563,1.4531},
{-1495.4233,1285.9215,7.1751},
{-1510.5726,1372.6509,3.2576},
{-1498.7653,1379.2518,3.1790},
{-1685.0889,1371.8600,9.7971},
{-1686.5223,1378.8271,14.7814},
{-1681.6874,1389.9917,21.0078},
{-1704.9565,1361.5414,17.2500},
{-2137.0769,1229.4589,33.9347},
{-2175.5369,1215.4055,37.3780},
{-2307.8245,999.4840,61.0735},
{-2315.0107,1067.6500,65.5859},
{-2578.1169,1186.1803,43.2893},
{-2619.1987,1230.9993,50.5467},
{-2547.4875,1227.1277,37.4219},
{-2698.6262,1375.7255,7.0968},
{-2651.3691,1373.2279,12.2562},
{-2660.0500,1371.9380,27.1563},
{-2660.1807,1402.2584,36.9277},
{-2660.4697,1446.8540,41.8359},
{-2659.5732,1529.5941,54.9045},
{-2666.4233,1492.2695,7.5635},
{-2655.8547,1594.6584,64.4354},
{-2815.3196,1030.3933,42.7589},
{-2819.7346,1118.1560,28.6252},
{-2819.4167,1134.3921,26.0889},
{-2819.1648,1146.4943,20.3258},
{-2816.9680,1145.1492,20.3400},
{-2817.7544,1145.2191,20.3649},
{-2807.6384,1163.1044,20.3125},
{-2807.6868,1161.6180,20.3125},
{-2808.3684,1162.8032,20.3125},
{-2800.0500,1185.6085,23.0501},
{-2791.9753,1200.1106,22.9798},
{-2797.8928,1216.4340,22.9876},
{-2906.435791,1240.775512,5.034915},
{-2722.130615,1246.208007,11.765625},
{-2408.229248,1235.495239,31.495100},
{-2513.727050,1199.106689,43.140625},
{-2483.125244,1210.432495,38.789062},
{-2326.910644,1224.167846,33.428344},
{-2117.448974,1210.279663,48.004001},
{-2094.832519,1434.963623,7.101562},
{-2105.383789,1200.578125,49.530101},
{-2124.782470,1104.008178,79.539047},
{-1894.257202,1395.964599,1.382823},
{-1790.975952,1544.446044,7.187500},
{-1666.317871,1404.032348,7.179687},
{-1660.229248,1433.389770,7.173841},
{-1621.997558,1399.692993,7.875486},
{-1564.162841,1327.245605,2.888503},
{-1508.265869,1295.762451,1.397048},
{-1612.960205,1260.670410,7.046875},
{-1658.888305,1207.348022,7.250000},
{-1664.969726,1227.659057,21.156250},
{-1516.944213,1117.960205,7.184553},
{-1664.371948,1072.349243,7.921875},
{-1587.823364,783.227600,6.616401},
{-1572.798583,658.077209,7.187500},
{-1617.337036,685.853881,7.187500},
{-1639.711547,650.301269,-5.242187},
{-1701.046142,688.577331,24.890625},
{-1629.509765,594.542358,32.089878},
{-1658.692016,596.632690,30.861368},
{-1979.888549,434.577545,25.929239},
{-1926.358520,457.328674,35.171875},
{-1934.057495,496.284210,35.765625},
{-2017.678588,333.075500,35.171875},
{-1843.599243,-10.305613,15.117187},
{-1881.921997,-169.587081,11.951729},
{-1916.343383,-219.263519,23.091373},
{-1996.263549,-326.811096,25.717599},
{-1941.157592,-792.988281,32.226562},
{-1967.861083,-923.990600,32.226562},
{-2097.163574,-966.462280,32.171875},
{-2659.407958,229.910446,4.335937},
{-2695.076904,229.066452,4.335937},
{-2644.452636,205.660140,4.331754},
{-2662.957275,189.043365,4.517284},
{-2616.982421,177.156784,7.195312},
{-2649.134765,128.323364,4.335937},
{-2540.708496,220.825942,11.093750},
{-2547.447021,200.330825,13.039062},
{-2476.040039,175.262680,16.818025},
{-2494.058837,293.647918,35.150424},
{-2525.314941,342.155700,36.320312},
{-2515.521728,300.720031,28.976562},
{-2364.242187,83.419448,35.312500},
{-2360.860839,-116.901016,35.320312},
{-2323.600830,-158.190460,35.554687},
{-2433.892089,-290.535980,40.756484},
{-2398.269042,-248.408111,39.935279},
{-2378.734863,-268.844665,44.015289},
{-2303.838867,-236.199493,42.652282},
{-2053.466064,-406.857177,38.734375},
{-2025.296264,-482.406402,38.734375},
{2646.398437,-2051.145996,13.619244},
{2662.565429,-2018.171142,13.555171},
{2801.403076,-1941.369384,17.320312},
{2787.022216,-1970.493041,17.320312},
{2939.721435,-2053.315185,3.548043},
{2872.941894,-2124.855468,4.451539},
{2765.479248,-2244.353759,3.420493},
{2218.641845,-2033.724487,17.271224},
{2162.639404,-1987.346801,14.025465},
{2091.706054,-2041.395385,16.075946},
{2073.669677,-2089.203857,16.075946},
{2012.764038,-2067.666259,17.357158},
{1928.833129,-1903.651611,15.031354},
{1909.597290,-1777.741210,13.382812},
{1846.925903,-1591.328613,23.890625},
{1740.831420,-1609.374145,20.216850},
{1576.982543,-1470.935180,14.236015},
{1620.210571,-1556.878051,13.578125},
{1711.849853,-1570.214965,13.953125},
{1638.907348,-1676.273071,19.117187},
{1645.141235,-1692.492919,15.609375},
{1641.908935,-1706.433349,21.687500},
{1660.912353,-1689.921508,22.075969},
{1700.958984,-1683.320556,20.203464},
{1662.968383,-1748.786376,14.148437},
{1546.756835,-1748.062377,14.046875},
{1549.281982,-1692.318725,13.921438},
{1541.639038,-1616.895751,13.382812},
{1580.788452,-1634.133911,13.562067},
{1538.839233,-1641.189941,5.890625},
{1338.720214,-1776.063354,13.539685},
{1249.114013,-1696.295166,13.546875},
{1217.434570,-1693.109497,19.734375},
{1277.594482,-1663.633911,19.734375},
{1203.287231,-1624.149169,13.762530},
{1191.729370,-1689.131713,13.156250},
{1165.100219,-1659.171630,22.234375},
{1072.825195,-1666.419799,19.546875},
{1120.381469,-1668.297241,19.546875},
{1106.667236,-1618.561401,13.912013},
{994.575439,-1520.836547,13.550727},
{949.086242,-1466.354980,17.148437},
{769.031372,-1487.361206,13.546875},
{730.229431,-1483.068603,1.968750},
{725.673645,-1451.027099,17.695312},
{662.432067,-1487.290161,14.851562},
{582.584777,-1489.463012,15.357023},
{615.790832,-1604.349365,16.300785},
{555.686584,-1604.708984,16.223375},
{473.053283,-1513.619262,20.502750},
{474.648559,-1484.691528,20.036544},
{418.784179,-1505.862060,31.291532},
{327.672088,-1495.471191,24.921875},
{300.659301,-1565.001708,30.235851},
{342.576049,-1330.654052,17.958049},
{287.401397,-1428.116699,13.982728},
{477.853332,-1747.970214,9.376688},
{540.372863,-1760.953491,14.326881},
{530.510559,-1812.548828,9.289062},
{432.149841,-1746.524658,9.368689},
{1029.578491,-1014.785156,35.740158},
{1027.385009,-1027.825439,38.294353},
{1101.940551,-972.235290,42.765625},
{1107.948974,-994.353637,42.765625},
{1151.493896,-999.496093,36.787693},
{1195.203613,-1010.929504,32.552505},
{1233.979614,-1010.427062,36.328262},
{1234.634155,-1059.499389,30.465768},
{1192.933471,-1086.828369,29.278654},
{1130.551025,-1086.025512,25.833623},
{1114.420776,-1104.972534,25.975145},
{1095.985229,-1054.189208,30.848478},
{994.788269,-1096.715332,24.830953},
{879.132507,-1056.844848,25.033948},
{807.959716,-1082.680419,24.289501},
{811.389221,-1098.340332,25.906250},
{810.957519,-1108.466064,25.784429},
{850.817260,-1128.697021,23.869514},
{851.203918,-1158.859130,26.306468},
{816.673767,-1215.105346,16.976562},
{840.460144,-1267.818725,14.153750},
{809.078918,-1308.072021,18.766004},
{726.135498,-1279.062622,13.648437},
{713.792419,-1269.493286,25.225044},
{730.351318,-1276.104492,26.659233},
{732.161682,-1277.793945,17.648437},
{724.070373,-1297.429321,17.648437},
{649.703674,-1308.305664,13.562715},
{528.242675,-1370.990722,16.114913},
{514.388549,-1329.522094,17.242187},
{488.043182,-1329.443481,15.449593},
{480.737762,-1334.768676,15.445725},
{314.553192,-1334.276367,14.463189},
{1054.711547,-658.377990,120.110549},
{1020.090881,-672.208496,121.165924},
{956.942382,-705.878295,125.700233},
{786.915710,-770.878906,73.560661},
{793.939636,-757.750488,80.990318},
{815.204650,-762.824584,76.531364},

{2084.338378,1285.406372,10.820312}, // training 2 PACKCOORD-2
{2473.928222,-1682.872436,13.424806} // training 1 PACKCOORD-1
};

//public OnOffPackUpdate() {if(!PUPDS) {PUPDS = 1;} else {PUPDS = 0;} return PUPDS;}

public PackBench()
{
new Float:time = 30000.000;
new sttime = GetTickCount();
new Float:y = 0.000;
for(new i=0;i<1000000;i++)
{
UpdatePackSignal();
y++;
if(GetTickCount() - sttime > time) {break;}
}
new Float:mark = y/time;
printf("count=%f, time=%f, mark=%f, tick=%d",y,time,mark,GetTickCount());
return 1;
}

public PackInfo(playerid)
{
new string[128];
for(new p=0;p<PACKINGAME;p++)
{
format(string,sizeof(string),"%s%d-%c | ",string,p,PackTypes[ PackType[p] ][pack_text][0]);
if(strlen(string) > 110) {SendClientMessage(playerid,COLOUR_WHITE,string); set(string,nullstr);}
}
SendClientMessage(playerid,COLOUR_WHITE,string);
return 1;
}

public PackHelp(playerid)
{
SendClientMessage(playerid,COLOUR_WHITE,"Информация о статуэтках (расширенная версия):");
new string[MAX_STRING];
format(string,sizeof(string),"Размер вознаграждения зависит от типа найденной статуэтки и уровня игрока. Всего в игре %d типов статуэток:",MAX_PACK_TYPES);
SendClientMessage(playerid,COLOUR_WHITE,string);

new lvl = GetPlayerLevel(playerid);
lvl++;

for(new i=0;i<MAX_PACK_TYPES;i++)
{
if(i == (MAX_PACK_TYPES-1))
{
format(string,sizeof(string),"За %s (тип %d) вы ничего не получите - это обучающая статуэтка.",PackTypes[i][pack_text],i);
}
else
{
format(string,sizeof(string),"За %s (тип %d) вы получите %d XP и %d $",PackTypes[i][pack_text],i,lvl*PackTypes[i][pack_xp],PackTypes[i][pack_money]);
}
SendClientMessage(playerid,PackTypes[i][pack_color],string);
}
SendClientMessage(playerid,COLOUR_WHITE,"Не трудно заметить, что каждый тип имеет свой цвет.");

SendClientMessage(playerid,COLOUR_WHITE,"В вержнем правом углу имеется индикатор антенны.");
SendClientMessage(playerid,COLOUR_WHITE,"Если вы поймаете сигнал статуэтки, то рядом с полосками будет отображаться информация о ней:");
SendClientMessage(playerid,COLOUR_WHITE,"Две буквы сверху это сокращенное название, например 'RP' означает 'RED pack'");
SendClientMessage(playerid,COLOUR_WHITE,"Цифра внизу - это тип статуэтки, цвет букв совпадает с цветом типа.");
return 1;
}

public Pack_OnAccLogin(playerid)
{
if(!PackEnable) {return 0;}
PlayerSignalLevel[playerid] = 0;
PlayerPackType[playerid] = -1;

for(new i=0;i<PTD_MAX;i++)
{ TextDrawShowForPlayer(playerid, PTextF[i]);

//printf("Show F%d",i);
}

return 1;
}

public xGetPlayerPackSignal(playerid, dist, packid)
{

if(packid == -1)
	{
	if(PlayerPackType[playerid] != -1)
		{
		TextDrawHideForPlayer(playerid, PTextC[ PlayerPackType[playerid] ]);
		//printf("Hide C%d",PlayerPackType[playerid]);
		PlayerPackType[playerid] = -1;
		}

		if(PlayerSignalLevel[playerid] != 0)
			{
			for(new i=0;i<PlayerSignalLevel[playerid];i++)
				{
				TextDrawHideForPlayer(playerid, PTextD[i]);
				TextDrawShowForPlayer(playerid, PTextF[i]);
				//printf("Show F%d | Hide D%d",i,i);
				}
			PlayerSignalLevel[playerid] = 0;
			}
			//printf("Pack %d | Type %d | Sign %d | Dist %d | Zone %d",packid,-1,0,dist,-1);

	}
	else
	{
	new type = PackType[packid];

	if(PlayerPackType[playerid] != type)
		{
		if(PlayerPackType[playerid] != -1)
			{
			TextDrawHideForPlayer(playerid, PTextC[ PlayerPackType[playerid] ]);
			//printf("Hide C%d",PlayerPackType[playerid]);
			}
		PlayerPackType[playerid] = type;
		TextDrawShowForPlayer(playerid, PTextC[type]);
		//printf("Show C%d",type);
		}
	
	//new zone = -1;
	new signal = 0;
	new levels = 0;

	for(new i=0;i<PTD_MAX;i++)
		{		
		if(dist <= SignalRadius[i])
			{
			//zone = i;
			signal = i+1;
			levels = PlayerSignalLevel[playerid] - signal;		
			if(signal > PlayerSignalLevel[playerid])
				{
				TextDrawHideForPlayer(playerid, PTextF[i]);
				TextDrawShowForPlayer(playerid, PTextD[i]);
				//printf("Show D%d | Hide F%d",i,i);
				}	
			}
		else if(levels > 0)
			{
			if(signal < PlayerSignalLevel[playerid])
				{
				levels--;
				TextDrawHideForPlayer(playerid, PTextD[i]);
				TextDrawShowForPlayer(playerid, PTextF[i]);
				//printf("Show F%d | Hide D%d",i,i);
				}
			}
		}
	PlayerSignalLevel[playerid] = signal;
	
	//printf("Pack %d | Type %d | Sign %d | Dist %d | Zone %d",packid,type,PlayerSignalLevel[playerid],dist,zone);
	
	if(PlayerSignalLevel[playerid] == PTD_MAX && PackCond[packid] == 0)
		{
		new str3d[64];
		PackCond[packid] = 1;
		new coo = PackNowCoords[packid];
		PackNow[packid] = CreatePickup(PACKMODEL,2,PackAllCoords[coo][Coord_X],PackAllCoords[coo][Coord_Y],PackAllCoords[coo][Coord_Z]);
		PackLife[packid] = 0;
		SendClientMessage(playerid, PackTypes[type][pack_color], "Пакет обнаружен");

		format(str3d,sizeof(str3d),"%s",PackTypes[type][pack_text]);
		Pack3DT[packid] = Create3DTextLabel(str3d, PackTypes[type][pack_color], PackAllCoords[coo][Coord_X],PackAllCoords[coo][Coord_Y],PackAllCoords[coo][Coord_Z]+1,15.000,0,0);
		//SetPlayerCameraLookAt(playerid, PackAllCoords[coo][Coord_X], PackAllCoords[coo][Coord_Y], PackAllCoords[coo][Coord_Z]);
		}
	}
return 1;
}
/*
public GetPlayerPackSignal(playerid, signal, packid)
{

if(!PackEnable) {return 0;}

for(new i=0;i<PTD_MAX;i++)
{
if(i+1 <= signal) {
TextDrawHideForPlayer(playerid, PTextF[PTD_MAX-(i+1)]);
TextDrawShowForPlayer(playerid, PTextD[PTD_MAX-(i+1)]);
continue;}
TextDrawHideForPlayer(playerid, PTextD[PTD_MAX-(i+1)]);
TextDrawShowForPlayer(playerid, PTextF[PTD_MAX-(i+1)]);
}

new str3d[64];

if(packid != -1 && signal > 0)
{
	for(new i=0;i<PTD_MAX;i++)
	{
	if(i == PackType[packid]) {TextDrawShowForPlayer(playerid, PTextC[i]); continue;}
	TextDrawHideForPlayer(playerid, PTextC[i]);
	}
}
else
{
TextDrawHideForPlayer(playerid, PTextC[0]); TextDrawHideForPlayer(playerid, PTextC[1]);
TextDrawHideForPlayer(playerid, PTextC[2]); TextDrawHideForPlayer(playerid, PTextC[3]);
TextDrawHideForPlayer(playerid, PTextC[4]);
}

if(signal == PTD_MAX && packid != -1)
{
if(PackCond[packid] == 0)
{
PackCond[packid] = 1;
new coo = PackNowCoords[packid];
new type = PackType[packid];
PackNow[packid] = CreatePickup(PACKMODEL,2,PackAllCoords[coo][Coord_X],PackAllCoords[coo][Coord_Y],PackAllCoords[coo][Coord_Z]);
PackLife[packid] = 0;
SendClientMessage(playerid, 0xFFFFFFAA, "Пакет обнаружен!!!");

format(str3d,sizeof(str3d),"%s",PackTypes[type][pack_text]);
Pack3DT[packid] = Create3DTextLabel(str3d, PackTypes[type][pack_color], PackAllCoords[coo][Coord_X],PackAllCoords[coo][Coord_Y],PackAllCoords[coo][Coord_Z]+1,15.000,0,0);
}}
//printf("%d <<<",GetTickCount());
return 1;
}
*/

GetRndPackCoords(coords)
{
new rnd;
for(new i=0;i<10;i++)
{rnd = random(PACKCOORD - 2); if(PackAllCoordsStatus[rnd] == 0 && rnd != coords) {PackAllCoordsStatus[rnd] = 1; break;}}
return rnd;
}

new pickuphelp3;
new pickuphelpa1;
new pickuphelpa2;
//new pickuphelpb[16];
//----------------------------------------------
//new UFOP1;
//new UFOP2;
//new VREPAIR;
//------------------------------------------------

public OnPlayerPickUpPickup(playerid, pickupid) {
Ba_OnPlayerPickUpPickup(playerid, pickupid);
/*
	for (new t=0; t < 16; t++)
	{
		if (pickupid == pickuphelpb[t])
		{
			new str[MAX_STRING];
			format(str,sizeof(str),"Здесь вы можете заправить машину АЗОТОМ командой '/nitro'\nИли продать сюда бензин (если вы его приобрели - разргузка по команде '/unload')");
			new sd[MAX_STRING];
			format(sd,sizeof(sd),":: АЗС %d :: %d ед бензина ::", t+1, CmdTimerComand[t+2]);
			ShowPlayerDialog(playerid,7,0,sd,str,"OK","Cancel");
			PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
		return 1;
		}
	}
	*/

/*	if(pickupid == UFOP2 || pickupid == UFOP1)
	{
	player_Spawn(playerid);
	SendClientMessage(playerid,COLOUR_WHITE, "Старайтесь, больше не попадать в лапы пришельцев =)");
	}*/
	
	if (pickupid == pickuphelp3) {
		DialogPlayerHelp(playerid, 3);
		PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
	} else if (pickupid == pickuphelpa1 || pickupid == pickuphelpa2) {
		new str[MAX_STRING];
		format(str,sizeof(str),"Здесь вы можете взять в аренду, заранее тюнингованные машины.");
		ShowPlayerDialog(playerid,7,0,"::: Help :::",str,"OK","Cancel");
		PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
	}
	
	//if(pickupid == VREPAIR)
	//{
	//RepairVehicle(GetPlayerVehicleID(playerid));
	//}
	
	
for(new i=0;i<PACKINGAME;i++)
{
if(PackCond[i] == 0) {continue;}
if(pickupid == PackNow[i])
{
new packid = i;
new type = PackType[packid];

PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);

if(type == 5)
{
SendClientMessage(playerid,COLOUR_WHITE, "Это пример статуэтки которую ты можешь найти");
SendClientMessage(playerid,COLOUR_WHITE, "Чтобы обнаружить статуэтку, следи за уровнем сигнала в правом верхнем углу экрана");
SendClientMessage(playerid,COLOUR_WHITE, "Чем выше уровень сигнала, тем ближе статуэтка. Когда сигнал будет максимальный статуэтка появится");
SendClientMessage(playerid,COLOUR_WHITE, "Ищи источники сигнала в LS и SF.");
SendClientMessage(playerid,COLOUR_WHITE, "Хотите знать больше? - введите '/pack-help'.");
break;
}
	
PackCond[packid] = 0;
DestroyPickup(PackNow[packid]);
Delete3DTextLabel(Pack3DT[packid]);
PackLife[packid] = 0;
PackNow[packid] = -1;
	
new string[MAX_STRING];
new year, month,day;
getdate(year, month, day);
new hour,minute,second;
gettime(hour,minute,second);

format(string, sizeof(string), "nick: %s | PackNowCoords: %d | packid: %d | type: %d | time:(%d.%d.%d %d:%d:%d)", oGetPlayerName(playerid), PackNowCoords[packid], packid, PackType[packid], day,month,year,hour,minute,second);
PackLog(string);

format(string,sizeof(string), "Отлично! Вы нашли %s [type %d] - держите награду!",PackTypes[type][pack_text],type);
SendClientMessage(playerid, PackTypes[type][pack_color] , string);
format(string,sizeof(string), "Игрок %s(id%d) нашел бонус! Молодец!",oGetPlayerName(playerid), playerid);
SendClientMessageToAll(COLOUR_WHITE, string);

oGivePlayerMoney(playerid,PackTypes[type][pack_money],1);
new xpamount;
xpamount = PackTypes[type][pack_xp];
new xpamountkeep;
xpamountkeep = xpamount*(GetPlayerLevel(playerid)+1);
GivePlayerXP(playerid,xpamountkeep,1);
Player[playerid][Packages] += 1;

if(Player[playerid][Vip] == 0){
if(Player[playerid][Packages] >= MINPACKTOVIP) {
SendClientMessage(playerid, 0xFFFFFFAA, "Поздравляем! Теперь вы имеете статус VIP!");
format(string,sizeof(string), "Игрок %s(id%d) нашел %d пакетов и получил VIP статус!",oGetPlayerName(playerid), playerid,MINPACKTOVIP);
SendClientMessageToAll(COLOUR_WHITE, string);
Player[playerid][Vip] = 1;
} else {
format(string,sizeof(string), "Продолжайте в том же духе! Найдите еще %d пакетов и получите VIP статус!",MINPACKTOVIP - Player[playerid][Packages]);
SendClientMessage(playerid, 0xFFFFFFAA, string);
}}

new rand = GetRndPackCoords( PackNowCoords[packid] );
PackAllCoordsStatus[ PackNowCoords[packid] ] = 0;
PackNowCoords[packid] = rand;
type = GetRndPackType();
PackType[packid] = type;

break;
}
	
}
	
return 1;
}


public CheckPack()
{
for(new y=2;y<PACKINGAME;y++)
{
if(PackCond[y] == 0) {continue;}
PackLife[y]++;
if(PackNow[y] != -1 && PackLife[y] >= MAX_PACK_LIFE) {
DestroyPickup(PackNow[y]);
PackCond[y] = 0;
PackLife[y] = 0;
Delete3DTextLabel(Pack3DT[y]);
}
}
return 1;
}

public UpdatePackSignal()
{
//new sttime = GetTickCount();
new dist, temp, packid;

for(new i=0;i<MAX_PLAYERS;i++)
{
if(!IsPlayerConnected(i)) {continue;}
if(IsPlayerNPC(i)) {continue;}

if( !ShowTDS[i][1] ){continue;}
//printf("id %d >>> %d",i,GetTickCount());
//new signal = 0;

dist = SignalRadius[0];
temp = 0;
packid = -1;

for(new y=0;y<PACKINGAME;y++)
{

//temp = GetPlayerDistanceToPointEx(i,PackAllCoords[PackNowCoords[y]][Coord_X],PackAllCoords[PackNowCoords[y]][Coord_Y],PackAllCoords[PackNowCoords[y]][Coord_Z]);
temp =	floatround(
		GetPlayerDistanceFromPoint(
		i,
		PackAllCoords[PackNowCoords[y]][Coord_X],
		PackAllCoords[PackNowCoords[y]][Coord_Y],
		PackAllCoords[PackNowCoords[y]][Coord_Z]
		)
		);

if(temp > dist) {continue;}
dist = temp;

packid = y;

//for(new u=0;u<PTD_MAX;u++){if(dist <= SignalRadius[u]) {if(u+1 > signal) { signal = u+1; }}}

}

//printf("signal = %d",signal);
xGetPlayerPackSignal(i, dist, packid);
//GetPlayerPackSignal(i, signal, packid);
}
//printf("Update time %d ms",GetTickCount()-sttime);
return 1;
}

GetRndPackType()
{
new rnd = -1;
rnd = random(31);
if(!rnd) {return 0;}
if(rnd < 3) {return 1;}
if(rnd < 7) {return 2;}
if(rnd < 15) {return 3;}
if(rnd >= 15) {return 4;}
return 4;
}

public PackInit() // инициализация (растановка)
{

if (!dini_Exists("GTO/PackConfig.cfg"))
{
dini_Create("GTO/PackConfig.cfg");
dini_Set("GTO/PackConfig.cfg","PackEnable","1");
PackEnable = 1;
}
else
{
PackEnable = strval(dini_Get("GTO/PackConfig.cfg","PackEnable"));
}

if(!PackEnable) {return 0;}

//SetTimer("UpdatePackSignal",SIG_UPD_TIME,1);
SetTimer("CheckPack",PACK_UPD_TIME,1);

new type, rand;

//-----------------signal--------------------------
/*
for(new i=0;i<MAX_PACK_TYPES;i++)
{
PTextC[i] = TextDrawCreate( 610.00, 4.00, PackTypes[i][pack_icon_text]);
TextDrawColor(PTextC[i], PackTypes[i][pack_color] );
TextDrawFont(PTextC[i], 2);
TextDrawAlignment(PTextC[i], 2);
TextDrawLetterSize(PTextC[i], 0.4 ,1.0);
TextDrawSetShadow(PTextC[i],0);
TextDrawHideForAll(PTextC[i]);
}

for(new i=0;i<PTD_MAX;i++)
{
PTextD[i] = TextDrawCreate( (PTextX+(i*PTextS)), PTextY + i*PTextH, " ");
PTextF[i] = TextDrawCreate( (PTextX+(i*PTextS)), PTextY + i*PTextH, " ");

TextDrawUseBox(PTextD[i], 1);
TextDrawUseBox(PTextF[i], 1);

TextDrawBoxColor(PTextD[i], 0xFFFFFF70 );
TextDrawBoxColor(PTextF[i], 0x00000070 );

TextDrawSetShadow(PTextD[i],0);
TextDrawSetShadow(PTextF[i],0);

TextDrawTextSize(PTextD[i], PTextX + PTextL, 0);
TextDrawTextSize(PTextF[i], PTextX + PTextL, 0);

TextDrawHideForAll(PTextD[i]);
TextDrawHideForAll(PTextF[i]);
}
*/

for(new i=0;i<MAX_PACK_TYPES;i++)
{
	PTextC[i] = TextDrawCreate(ITDX + 86.0, ITDY + 4.7, "O");
	TextDrawColor(PTextC[i], PackTypes[i][pack_color] );
	TextDrawFont(PTextC[i], 1);
	TextDrawLetterSize(PTextC[i], 0.455 ,1.56);
	TextDrawSetShadow(PTextC[i],0);
	TextDrawSetOutline(PTextC[i],0);
	TextDrawHideForAll(PTextC[i]);
}

for(new i=0;i<PTD_MAX;i++)
{
	PTextD[i] = TextDrawCreate(ITDX + 90.0 + SIG_RAD * floatsin( i*45 ,degrees), ITDY + -4.0 + SIG_RAD * floatcos( i*45 ,degrees), ".");
	PTextF[i] = TextDrawCreate(ITDX + 90.0 + SIG_RAD * floatsin( i*45 ,degrees), ITDY + -4.0 + SIG_RAD * floatcos( i*45 ,degrees), ".");

	TextDrawFont(PTextD[i],1);
	TextDrawFont(PTextF[i],1);

	TextDrawColor(PTextD[i],0xFFFFFFFF);
	TextDrawColor(PTextF[i],0xFFFFFF44);

	TextDrawLetterSize(PTextD[i],0.7, 2.4 );
	TextDrawLetterSize(PTextF[i],0.7, 2.4 );
		
	TextDrawSetShadow(PTextD[i],0);
	TextDrawSetShadow(PTextF[i],0);

	TextDrawSetOutline(PTextD[i],0);
	TextDrawSetOutline(PTextF[i],0);

	TextDrawHideForAll(PTextD[i]);
	TextDrawHideForAll(PTextF[i]);
}
//------------------------------------------------


for(new p=2;p<PACKINGAME;p++) // 2 training pickups
{
rand = GetRndPackCoords(-1);
type = GetRndPackType();
PackType[p] = type;
PackCond[p] = 0;
PackLife[p] = 0;

PackNowCoords[p] = rand;
}

type = 5;
new str3d[64];

PackNowCoords[0] = PACKCOORD-1;
rand = PackNowCoords[0];
PackAllCoordsStatus[rand] = 1;
PackCond[0] = 1;
PackNow[0] = CreatePickup(PACKMODEL,2,PackAllCoords[rand][Coord_X],PackAllCoords[rand][Coord_Y],PackAllCoords[rand][Coord_Z]);
PackType[0] = type;
PackLife[0] = 0;
format(str3d,sizeof(str3d),"%s",PackTypes[type][pack_text]);
Pack3DT[0] = Create3DTextLabel(str3d, PackTypes[type][pack_color],PackAllCoords[rand][Coord_X],PackAllCoords[rand][Coord_Y],PackAllCoords[rand][Coord_Z]+1.000,30.000,0,0);

PackNowCoords[1] = PACKCOORD-2;
rand = PackNowCoords[1];
PackAllCoordsStatus[rand] = 1;
PackCond[1] = 1;
PackNow[1] = CreatePickup(PACKMODEL,2,PackAllCoords[rand][Coord_X],PackAllCoords[rand][Coord_Y],PackAllCoords[rand][Coord_Z]);
PackType[1] = type;
PackLife[0] = 0;
format(str3d,sizeof(str3d),"%s",PackTypes[type][pack_text]);
Pack3DT[1] = Create3DTextLabel(str3d, PackTypes[type][pack_color],PackAllCoords[rand][Coord_X],PackAllCoords[rand][Coord_Y],PackAllCoords[rand][Coord_Z]+1.000,30.000,0,0);

return 1;
}

public PackLog(string[])
{
	new File:hFile;
	if (!fexist("GTO/gto_pack.log"))
{
	hFile=fopen("GTO/gto_pack.log",io_write);
	fclose(hFile);
}
	new entry[MAX_STRING];
	format(entry, sizeof(entry), "%s\n",string);

	hFile = fopen("GTO/gto_pack.log", io_append);
	fwrite(hFile, entry);
	fclose(hFile);
}
