//
// Created:     05.09.06
// Aurthor:    Iain Gilbert
//



/*

Pawn general reference:

-----------

#define
#else
#elseif
#emit
#endif
#endinput
#endscript
#error
#le
#if
#include
#line
#pragma
#section
#tryinclude
#undef

-----------

enum
forward
native
new
operator
public
static
stock

-----------

break
case
continue
default
do
else
exit
for
goto
if
return
sleep
state
switch
while

-----------

define
sizeof
state
tagof

-----------

Escape sequences:

'na' 		Audible alarm (beep)
'nb' 		Backspace
'ne' 		Escape
'nf' 		Formfeed
'nn' 		Newline
'nr' 		Carriage Return
'nt' 		Horizontal tab
'nv' 		Vertical tab
'nn' 		n the escape character
'n'' 		' single quote
'n"' 		" double quote
'n% 		% percent sign
'nddd;' 	character code with decimal code \ddd"
'nxhhh;' 	character code with hexadecimal code \hhh"

----------


i () function call left-to-right
[] array index (cell)
{} array index (character)
! logical not right-to-left
~ one's complement
- two's complement (unary minus)
++ increment
-- decrement
: tag override
char convert number of packed characters to cells
defined symbol denition status
sizeof symbol size in \elements"
state automaton/state condition
tagof unique number for the tag
* multiplication left-to-right
/ division
% modulus

+ addition left-to-right
- subtraction
>> arithmetic shift right left-to-right
>>> logical shift right
<< shift left
& bitwise and left-to-right
^ bitwise exclusive or left-to-right
| bitwise or left-to-right
< smaller than left-to-right
<= smaller than or equal to
> greater than
>= greater than or equal to
== equality left-to-right
!= inequality
&& logical and left-to-right
|| logical or left-to-right
? : conditional right-to-left
= assignment right-to-left
*= /= %= += -= >>= >>>= <<= &= ^= |=
, comma left-to-right

*/


#if defined _gtoutils_included
  #endinput
#endif

#define _gtoutils_included
#pragma library gtoutils
#include "base"

forward SendPlayerScrollingText(playerid,text[]);
forward TextScroller();
forward strcharsplit(string[], &index,seperator);
forward strchar(string[2]);
//forward charstr(character);
forward CharReplace(findchar,newchar,string[MAX_STRING]);
forward Vary(source,varyamount);
forward strcomp(str1[],str2[],bool:ignorecase);
forward NameCharCheck(string[MAX_STRING]);
forward PlayerNameCharCheck(str[MAX_PLAYER_NAME]);
forward StringCharCheck(string[MAX_STRING]);
forward XStringCharCheck(string[]);
forward SendPlayerFormattedText(playerid, const str[], define, colour);
forward SendAllFormattedText(const str[], define);
forward SendClientMessageToRegistered(colour, message[]);
forward ConvertSeconds(time);
forward encryptbykey(string[],key[MAX_STRING]);
forward PlayerCount();
forward GetPointDistanceToPointEx(Float:x,Float:y,Float:z,Float:x2,Float:y2,Float:z2);

EncodeName(nickname[])
{
	new tmp[MAX_STRING];
	set(tmp,nickname);
	new newchar = strchar("_");

	for (new i=0;i<MAX_STRING;i++)
	{
		if (tmp[i]==0) break; // null
	    if (((tmp[i]>=strchar("a")) && (tmp[i]<=strchar("z"))) || ((tmp[i]>=strchar("A")) && (tmp[i]<=strchar("Z"))) || ((tmp[i]>=strchar("0")) && (tmp[i]<=strchar("9"))))
	    {
			continue;
	    }
	    else
	    {
	        if (tmp[i] == strchar(".")) continue; // temp fix until new db handler is finished
	        tmp[i] = newchar;
		}
	}
	tmp=CharReplace(DBSeperator,newchar,tmp);
	tmp=CharReplace(strchar(" "),newchar,tmp);
	tmp=CharReplace(strchar("\n"),newchar,tmp);
	return tmp;
}


ovalstr(value)
{
	new temp[MAX_STRING];
	valstr(temp,value); // level
	return temp;
}

PlayerPlaySoundOnPlayer(playerid,soundid)
{
	new Float:playerx,Float:playery,Float:playerz;
	GetPlayerPos(playerid,playerx,playery,playerz);
	PlayerPlaySound(playerid,soundid,playerx,playery,playerz);
}
/*
GetPosInDescendingStrStack(str[],value)
{
	for (new i=0;i<strlen(str);i++)
	{
		if (value > str[i]) return i;
	}
	return strlen(str);
}
*/
Float:GetPlayerX(playerid)
{
	new Float:playerx,Float:playery,Float:playerz;
	GetPlayerPos(playerid,playerx,playery,playerz);
	return playerx;
}

Float:GetPlayerY(playerid)
{
	new Float:playerx,Float:playery,Float:playerz;
	GetPlayerPos(playerid,playerx,playery,playerz);
	return playery;
}

Float:GetPlayerZ(playerid)
{
	new Float:playerx,Float:playery,Float:playerz;
	GetPlayerPos(playerid,playerx,playery,playerz);
	return playerz;
}

FormatPosition(position)
{
	new string[MAX_STRING];
	if (position == 1)
	{
	    format(string, sizeof(string), "%dst!",position);
	}
	else if (position == 2)
	{
		format(string, sizeof(string), "%dnd!",position);
	}
	else if (position == 3)
	{
		format(string, sizeof(string), "%drd!",position);
	}
	else
	{
		format(string, sizeof(string), "%dth",position);
	}
	return string;
}


#define TEXT_SCROLL_SPEED 1000
#define TEXT_SCROLL_SIZE 1023
new ScrollingText[MAX_PLAYERS][TEXT_SCROLL_SIZE]; // hmmmmm
public SendPlayerScrollingText(playerid,text[])
{
	for (new i = 0;i<strlen(text);i++)
	{
	    if (text[i] == 0) break;
	    if (text[i] == strchar("\n")) text[i] = strchar("_");
	}

	if (strlen(text) > 150) //  not allowed
	{
		SendClientMessage(playerid, COLOUR_MISC, text);
  		return;
	}
	new wbreak;
	while ((strlen(ScrollingText[playerid]) > (TEXT_SCROLL_SIZE  - strlen(text))) && (wbreak < 5))
	{
		ScrollText(playerid);
		wbreak++;
	}
	if (wbreak >=5)
	{
		strdel(ScrollingText[playerid], 0, strlen(ScrollingText[playerid])-1);
	}
	strins(ScrollingText[playerid],text,strlen(ScrollingText[playerid]),TEXT_SCROLL_SIZE-1);
	strins(ScrollingText[playerid],"\n",strlen(ScrollingText[playerid]),TEXT_SCROLL_SIZE-1);
}

ScrollText(id)
{
	if (IsPlayerConnected(id))
	{
	    if (strlen(ScrollingText[id]) == 0) return;
		new string[MAX_STRING];
	    new idx;
	    set(string,strcharsplit(ScrollingText[id],idx,strchar("\n")));
	    if (strlen(string) < 1) return;
	    new colour;
	    if ((string[0] == strchar("~")) && (string[2] == strchar("~")))
	    {
	        if (string[1] == strchar("r")) colour = COLOUR_RED;
	        else if (string[1] == strchar("g")) colour = COLOUR_GREEN;
            else if (string[1] == strchar("b")) colour = COLOUR_BLUE;
            else if (string[1] == strchar("y")) colour = COLOUR_YELLOW;
            strdel(string, 0, 3);
        }
        if (colour != 0)
        {
        	SendClientMessage(id, colour, string);
        }
        else
        {
	       	SendClientMessage(id, COLOUR_MISC, string);
	  	}
		strdel(ScrollingText[id], 0, idx);
			
	}
	else
	{
		strdel(ScrollingText[id], 0, strlen(ScrollingText[id])-1);
	}
	return;
}

public TextScroller()
{
	for (new id = 0;id<MAX_PLAYERS;id++)
	{
		if (IsPlayerConnected(id))
		{
		    ScrollText(id);
		}
	}
}

/*
strstrsplit(const string[],index,seperator[20])
{
	new result[MAX_STRING];
	for (new i=index;i<strlen(string);i++)
	{
		if (string[i] == 0) break;
		if (string[i] == seperator[0])
		{
		    new isseperator;
		    for (new i2=1;i<strlen(seperator);i++)
		    {
				if (string[i+i2] != seperator[i2]) break;
				
				if (i == strlen(seperator) - 1)
				{
				    isseperator = 1;
				}
		    }
		    
		    if (isseperator)
		    {
		    	for (new i2=0;i<strlen(seperator);i++)
		    	{
		    		result[i-index] = string[i];
		}
		else
		{
		    continue;
		}
		
		
	}
	return result;
}
*/
strcharsplit(string[], &index,seperator)
{
	new result[MAX_STRING];
	new idxpos = index;
	for (new i=index;i<strlen(string);i++)
	{
	    index++;
		if (string[i] == seperator) break;
		if (string[i] == 0) break;
		result[i-idxpos] = string[i];
		
	}
	return result;
}

public strchar(string[2])
{
	return string[0];
}

stock charstr(character)
{
	new string[2];
	string[0] = character;
	return string;
}

CharReplace(findchar,newchar,string[MAX_STRING])
{
	for (new i = 0;i<MAX_STRING;i++)
	{
		if (string[i] == findchar)
		{
		    if (string[i] == 0) break;
		    string[i] = newchar;
		}
	}
	return string;
}

public Vary(source,varyamount)
{
	new rnd = random((varyamount*2)+1) - varyamount;
	source = source + rnd;
	return source;
}

// strcmp() returns are fucked, this is an override to fix returns
// will return 1/true if strings are equal
public strcomp(str1[],str2[],bool:ignorecase)
{
	if ((!strlen(str1)) && (!strlen(str2))) return 1;
	if (!strlen(str1)) return 0;
	if (!strlen(str2)) return 0;
	if (strcmp(str1,str2,ignorecase) == 0)
	{
	    return 1;
	}
	return 0;
}

public NameCharCheck(string[MAX_STRING])
{
	for (new i=0;i<MAX_STRING;i++)
	{
	    if (string[i]==0) return 1; // null
		if (string[i] < 32) return 0;
		if (string[i] > 125) return 0;
	}

	return 1;
}

public PlayerNameCharCheck(str[MAX_PLAYER_NAME])
{
	for (new i=0;i<MAX_PLAYER_NAME;i++)
	{
		if (str[i]==0) return 1; // null
		if (str[i] < 48) return 0;
		if (str[i] > 57 && str[i] < 65) return 0;
		if (str[i] == 92 || str[i] == 94 || str[i] == 96) return 0;
		if (str[i] > 122) return 0;
	}
	return 1;
}

stock StrFind(str[],origin[])
{
if(!strlen(str) && !strlen(origin)) {return 1;}
if(!strlen(origin)) {return 0;}
if(strlen(str) < strlen(origin)) {return 0;}
new step;
new count;
step = strlen(str) - strlen(origin) +1;
for(new i=0; i<step; i++)
{
for(new j=0;j<strlen(origin);j++)
{
if(str[j+i] == origin[j]) {count ++;}
}
if(count == strlen(origin)) {return 1;}
count = 0;
}
return 0;
}

stock CheckHEX(hexstr[])
{
new len = strlen(hexstr);
if(!len){return 0;}
if(len > 8){return 0;}
for(new i=0;i<len;i++)
{
if(hexstr[i] < 48 || hexstr[i] > 70){return 0;}
if(hexstr[i] > 57 && hexstr[i] < 65){return 0;}
}
return 1;
}

public StringCharCheck(string[MAX_STRING])
{
	for (new i=0;i<MAX_STRING;i++)
	{
	    if (string[i]==0) return 1; // null
		if ((string[i]<48) && (string[i]!=32)) return 0;
		if (string[i]>57 && string[i]<65) return 0;
		if (string[i]>90 && string[i]<97) return 0;
		if (string[i]>122) return 0;
	}
	return 1;
}

public XStringCharCheck(string[])
{
	new size = strlen(string) + 1;
	for (new i=0;i<size;i++)
	{
	    if (string[i]==0) return 1; // null
		if (string[i]<48 && string[i]!=32 && string[i]!=45) return 0;
		if (string[i]>58 && string[i]<65) return 0;
		if (string[i]>90 && string[i]<97) return 0;
		if (string[i]>122) return 0;
	}
	return 1;
}

public SendPlayerFormattedText(playerid, const str[], define, colour)
{
	new tmpbuf[256];
	format(tmpbuf, sizeof(tmpbuf), str, define);
	SendClientMessage(playerid, colour, tmpbuf);
}

public SendAllFormattedText(const str[], define)
{
	new tmpbuf[256];
	format(tmpbuf, sizeof(tmpbuf), str, define);
	SendClientMessageToAll(COLOUR_MISC, tmpbuf);
}

public SendClientMessageToRegistered(colour, message[])
{
	for (new playerid=0;playerid<MAX_PLAYERS;playerid++)
	{
	    if (IsPlayerConnected(playerid))
	    {
	        if (IsPlayerRegistered(playerid))
	        {
	        	SendClientMessage(playerid, colour, message);
			}
		}
	}
}

stock minrand(min, max)                  //функция для рандом
{ 
   return random(max - min) + min; 
}

//ConvertSeconds by El Presy
//Converts an ammount of seconds into hours/minutes/seconds
ConvertSeconds(time)
{
new string[40];
//Less than 1 minute
if(time < 60)
format(string, sizeof(string), "%d секунд", time);
//1 minute
else if(time == 60)
string = "1 minute";
//From 1 minute to 59 minutes
else if(time > 60 && time < 3600){
new Float: minutes;
new seconds;
minutes = time / 60;
seconds = time % 60;
format(string, sizeof(string), "%.0f минут и %d секунд", minutes, seconds);
//1 hour
}else if(time == 3600)
string = "1 час";
//More than 1 hour
else if(time > 3600){
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

// encrypt(string[]) by Alex "Y_Less" Cole, Based on code by Jeremy Cole
//
// slightly modified by Iain for use with GTO - 03.11.06
stock encryptbykey(string[],key[MAX_STRING])
{
	new size = strlen(key);
	//static size = sizeof(key) - 1;
	// Theres a slight bug, you don't want to count the end \0

	new retval[64];
	// Passwords limited to 48 chars (64 - 16 for rounding)

	new j, k, sum, tmp[] = {0, 0};
	// Initialise the variables

	j = strlen(string);
	sum = j;
	// Get the length of the source string

	k = ((j >> 4) + 1) << 4; // << >> это побитовый сдвиг влево и вправо
	// Round up to the nearest 16 (trust me, it does)

	for (new i = 0; i < k; i++)
	{
		if (i < j)
		{
			tmp[0] = string[i];
			// Get the next character
		}
		else
		{
			tmp[0] = ' ';
			// Add the padding
		}

		sum = ((sum + strfind(key, tmp) + 1) % size);
		// Add the new position to the running total and limit
		// it to the size of the array (thus carrying character
		// data over to the next)

		retval[i] = key[sum];
		// Add the new character to the running array.
	}
	return retval;
}


stock togglePlayerMapIconVisibility(playerid,bool:visible){
    SetPlayerColor(playerid, (GetPlayerColor(playerid) | 0xFF) - (visible ? 0x00 : 0xFF));
}


public PlayerCount()
{
	new count = 0;

	for (new playerid=0; playerid<MAX_PLAYERS;playerid++)
	{
        if (IsPlayerConnected(playerid)) count++;
	}
	return count;
}

stock GetHoursFromDate()
{
	new yearn, monthn,dayn;
	getdate(yearn, monthn, dayn);
	new hourn,minuten,secondn;
	gettime(hourn,minuten,secondn);
	if(monthn > 1)
	{
		dayn=dayn+31;
	}
	if(monthn > 2)
	{
		dayn=dayn+27;
	}
	if(monthn > 3)
	{
		dayn=dayn+31;
	}
	if(monthn > 4)
	{
		dayn=dayn+30;
	}
	if(monthn > 5)
	{
		dayn=dayn+31;
	}
	if(monthn > 6)
	{
		dayn=dayn+30;
	}
	if(monthn > 7)
	{
		dayn=dayn+31;
	}
	if(monthn > 8)
	{
		dayn=dayn+31;
	}
	if(monthn > 9)
	{
		dayn=dayn+30;
	}
	if(monthn > 10)
	{
		dayn=dayn+31;
	}
	if(monthn > 11)
	{
		dayn=dayn+30;
	}
	hourn=hourn+(dayn*24);
	return hourn;
}

stock Compass(playerid)
{
new Float:step = 22.5;
new str[16];
new Float:angle;
new point = 0;
GetPlayerFacingAngle(playerid,angle);

if(angle < step || angle > 360-step) {point = 0; 		set(str,"N"); }
else if(angle > step && angle < 45+step ) {point = 1; 		set(str,"NW"); }
else if(angle > 90-step && angle < 90+step ) {point = 2; 	set(str,"W"); }
else if(angle > 135-step && angle < 135+step ) {point = 3; 	set(str,"SW"); }
else if(angle > 180-step && angle < 180+step ) {point = 4; 	set(str,"S"); }
else if(angle > 225-step && angle < 225+step ) {point = 5; 	set(str,"SE"); }
else if(angle > 270-step && angle < 270+step ) {point = 6; 	set(str,"E"); }
else if(angle > 315-step && angle < 315+step ) {point = 7; 	set(str,"NE"); }

if(point == -1) { set(str,"X"); return str;}

return str;
}

stock ACompass(Float:angle)
{
new Float:step = 22.5;
new str[16];
new point = 0;
if(angle < step || angle > 360-step) {point = 0; 		set(str,"N"); }
else if(angle > step && angle < 45+step ) {point = 1; 		set(str,"NW"); }
else if(angle > 90-step && angle < 90+step ) {point = 2; 	set(str,"W"); }
else if(angle > 135-step && angle < 135+step ) {point = 3; 	set(str,"SW"); }
else if(angle > 180-step && angle < 180+step ) {point = 4; 	set(str,"S"); }
else if(angle > 225-step && angle < 225+step ) {point = 5; 	set(str,"SE"); }
else if(angle > 270-step && angle < 270+step ) {point = 6; 	set(str,"E"); }
else if(angle > 315-step && angle < 315+step ) {point = 7; 	set(str,"NE"); }

if(point == -1) { set(str,"X"); return str;}

format(str,sizeof(str),"%s[%0.f]",str,angle);

return str;
}

stock setcolora(color,a) { return color & 0xffffff00 | a; }

//-----------------------------
stock CheckVisibility()
{
new prange = 50.000;
new Float:pX, Float:pY, Float:pZ;
for(new i=0;i<MAX_PLAYERS;i++)
{
if(!IsPlayerConnected(i)) {continue;}
GetPlayerPos(i,pX,pY,pZ);
for(new y=0;y<MAX_PLAYERS;y++)
{
if(!IsPlayerConnected(y)) {continue;}
if(i == y){continue;}
if(IsPlayerInRangeOfPoint(y, prange,pX, pY,pZ)) {SetPlayerMarkerForPlayer(i,y,GetPlayerColor(i) | 0xFF) - (true ? 0x00 : 0xFF));}
else {SetPlayerMarkerForPlayer(i,y,GetPlayerColor(i) | 0xFF) - (false ? 0x00 : 0xFF));}
}}}
//----------------------------------

stock AddToNow(sec) {

if(sec > 31536000) {sec = 31536000;}
new year, month,day;
getdate(year, month, day);
new hour,minute,second;
gettime(hour,minute,second);

new timego;

timego = second + (minute * 60) + (hour * 3600);
new days_of_month[12] = {31, 0 ,31,30,31,30,31,31,30,31,30,31};

if ( ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0) ) {
days_of_month[1] = 29;
} else {
days_of_month[1] = 28;
}

new days_this_year = 0;
days_this_year = day;
if(month > 1) {
for(new i=0; i<month-1;i++) {
days_this_year += days_of_month[i];
}}

timego += days_this_year * 86400;
timego += sec;

for(new j=2000;j<year;j++) {
		timego += 31536000;
		if ( ((j % 4 == 0) && (j % 100 != 0)) || (j % 400 == 0) )  timego += 86400;
	}

return timego;
}

//----------------------------------------------
new l_arab[13] = {1, 4, 5, 9, 10, 40, 50, 90, 100, 400, 500, 900, 1000};
new l_roman[13][3] = {"I","IV","V","IX","X","XL","L","XC","C","CD","D","CM","M"};
 
stock ArabToRoman(number)
{
new ret[128];
if(!number) return ret;

	new i = strlen(l_arab) - 1;
	while(number > 0)
	{
		if(number >= l_arab[i])
		{
			ret += l_roman[i];
			number -= l_arab[i];
		}
		else
		{
			i--;
		}
 
	}
	return ret;
}

stock tabul(stlen,stline)
{
new tabstr[64];
if(stlen<1 || stlen<1 || stline < stlen){set(tabstr,"|"); return tabstr;}
new tablen = 6;
new tabs = 0;
tabs = stline/tablen;
tabs += 1;
tabs -= stlen/tablen;
while(tabs>0)
{
format(tabstr,sizeof(tabstr),"%s\t",tabstr);
tabs--;
}
return tabstr;
}

public GetPointDistanceToPointEx(Float:x,Float:y,Float:z,Float:x2,Float:y2,Float:z2) //By Sacky
{
new Float:tmpdis;
tmpdis = floatsqroot(floatpower(floatabs(floatsub(x,x2)),2)+floatpower(floatabs(floatsub(y,y2)),2)+floatpower(floatabs(floatsub(z,z2)),2));
return floatround(tmpdis);
}

//Function from Make It Comfortable
stock strcut(string[],substring[]){
new fn = strfind(string,substring);
new ln = strlen(substring);
strdel(string,fn,fn+ln);
}

stock AddPricePoint(price)
{
new str[16];
new l, c;
if(price < 0 || price > 200000000) {set(str,"<!>"); return str;}
format(str,sizeof(str),"%d",price);

l = strlen(str);

while(l > 0)
{
if(c == 3){strins(str, ".", l); c=0;}
c++;
l--;
}

return str;
}

stock OKS_HEX2STR(color) { // by OKStyle
new str[8];
format(str,8,"%06x",color >>> 8);
return str; }

stock OKS_HEX2STR_M(color, str[], size = 8) { // by OKStyle
format(str,size,"%06x",color >>> 8); }

