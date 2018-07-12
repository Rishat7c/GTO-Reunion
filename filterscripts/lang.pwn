#include <a_samp>
#include <core>
#include <float>
#include "utils\dini"
#include "utils\dutils"

forward lang_read(filename[]);

new lang_db[MAX_STRING] = "GTO/Languages/";
new lang[4] = "ru";
new lang_texts[21][100][MAX_STRING];

public lang_read(filename[]) {

	new File:fohnd, tmpres[MAX_STRING], tmp1[MAX_STRING], tmp2[MAX_STRING], i;

	fohnd=fopen(filename,io_read);

	if (!fohnd) return;

	while (fread(fohnd,tmpres,sizeof(tmpres))) {

		if (strlen(tmpres) == 0) return;

		if (strfind(tmpres, "//",true) != -1) continue;

		if (strfind(tmpres, ":", true) != -1)
		{

			strmid(tmp1, tmpres, 0, strfind(tmpres, ":", true));

			strmid(tmp2, tmpres, strfind(tmpres, ":", true)+1, (strlen(tmpres)-strlen(tmp1)));

			lang_texts[i][strval(tmp1)] = tmp2;

		}
		//		else continue; // tmp2 = tmpres;

		else if (strfind(tmpres, ":", true) == -1) i++;

	}

	fclose(fohnd);
}

public OnPlayerCommandText(playerid, cmdtext[])
{
new tmp[256];
new cmd[256];
new idx;
cmd = strtok(cmdtext, idx);

 
if(strcmp(cmdtext, "/lang_read", true) == 0) {
new lang_file[50];
format(lang_file,sizeof(lang_file),"%sGTOReunion_%s.lang",lang_db,lang);
lang_read(lang_file);
return 1;
}

if(strcmp(cmd, "/lang_get", true) == 0) {

tmp = strtok(cmdtext, idx);
if(!strlen(tmp)) {
SendClientMessage(playerid,0xFF0000AA,"err1");
return 1;
}
new x1 = strval(tmp);

tmp = strtok(cmdtext, idx);
if(!strlen(tmp)) {
SendClientMessage(playerid,0xFF0000AA,"err2");
return 1;
}
new x2 = strval(tmp);

format(tmp,sizeof(tmp),">> %s",lang_texts[x1][x2]);

SendClientMessage(playerid,0xFF0000FF,tmp);
return 1;
}


return 0;
}

