//-----------------------------------------------------------
//                 eXtended Ban Admin
//             XBanAdmin
//
//                           created: 16.01.2007
//                     last modified: 22.01.2007
//
//
//(C) 2006 by Radu "radix" Colceriu
//
// Description:
// Extends the admin class by adding the xkick, xsession
// and xkickban commands.
//-----------------------------------------------------------



class XBanAdmin extends Admin;


var array<string> strBanReason;
var array<string> strHelpLines;


exec function xKick(string Cmd, string Extra)
{
    local array<string> Params;
    local array<PlayerReplicationInfo> AllPRI;
    local Controller C, NextC;
    local int i;

    local string strCmd;
    local string strNoob;
    local string strReasonId;
    local string strReasonDescription;


    if (CanPerform("Kp") || CanPerform("Kb"))  // Kp = Kick, Kb = Kick / Ban
    {
        if (Cmd ~= "List")
        {
            // Get the list of players to kick by showing their PlayerID
            Level.Game.GameReplicationInfo.GetPRIArray(AllPRI);
            for (i = 0; i < AllPRI.Length; i++)
            {
                if (PlayerController(AllPRI[i].Owner) != none && AllPRI[i].PlayerName != "WebAdmin")
                    ClientMessage(Right("   " $ AllPRI[i].PlayerID, 3) $ ")" @ AllPRI[i].PlayerName @ " " $ PlayerController(AllPRI[i].Owner).GetPlayerIDHash());
                else
                    ClientMessage(Right("   " $ AllPRI[i].PlayerID, 3) $ ")" @ AllPRI[i].PlayerName);
            }
            return;
        }

         // trying to normalize the expression

            if (Cmd ~= "Ban" || Cmd ~= "Session")
            Params = TokenizeString(Cmd @ Extra);
          else
                Params = TokenizeString("kick" @ Cmd @ Extra);


         if (Cmd ~= "Ban" || Cmd ~= "Session")
         {
            if (Cmd ~= "Ban")
                strCmd = "ban ";
            else
                strCmd = "sess";

            if (Params.Length > 1)
                strNoob = Params[1];
            else
            {
                ClientMessage("XBanMutator: n00b expected. invalid command format");
                return;
            }
         }
         else
         {
            strCmd = "kick";
            strNoob = Params[1];
         }

         // building reasonid and reason description.
         // if id is missing  id = 0. if reason is missing : "no reason"
         if (Params.Length > 2)
         {
            if (IsNumeric(Params[2]))
            {
                strReasonId = Params[2];

                if (Params.Length > 3)
                {
                    strReasonDescription = buildString(Params, 3);
                }
                else
                {
                    strReasonDescription = strBanReason[int(strReasonId)];
                }
            }
            else
            {
                strReasonId = "5";
                strReasonDescription = buildString(Params, 2);
            }
         }
         else
         {
            strReasonId = "0";
            strReasonDescription = "no reason provided";
         }



        // go thru all Players
        for (C = Level.ControllerList; C != None; C = NextC)
        {
            NextC = C.NextController;

// debug
//         ClientMessage(" +++  debug : "  $  PlayerController(PlayerController(C).PlayerReplicationInfo.Owner).GetPlayerIDHash());
// end debug

            if (C != Owner && PlayerController(C) != None && C.PlayerReplicationInfo != None)
            {
                    if ((IsNumeric(strNoob) && C.PlayerReplicationInfo.PlayerID == int(strNoob))
                             || MaskedCompare(C.PlayerReplicationInfo.PlayerName, strNoob))
                    {
                        if (Cmd ~= "Ban")
                        {
                            ClientMessage(Repl(Msg_PlayerBanned, "%Player%", C.PlayerReplicationInfo.PlayerName));
                            Manager.BanPlayer(PlayerController(C));
                            addToLog("ban ", C, strReasonId, strReasonDescription);
                        }
                        else if (Cmd ~= "Session")
                        {
                            ClientMessage(Repl(Msg_SessionBanned, "%Player%", C.PlayerReplicationInfo.PlayerName));
                            Manager.BanPlayer(PlayerController(C), true);
                            addToLog("sess", C, strReasonId, strReasonDescription);
                        }
                        else
                        {
                            Manager.KickPlayer(PlayerController(C));
                            ClientMessage(Repl(Msg_PlayerKicked, "%Player%", C.PlayerReplicationInfo.PlayerName));
                            addToLog("kick", C, strReasonId, strReasonDescription);
                        }
                        break;
                    }
            }
        }
    }
}


exec function xKickBan(string s)
{
    xKick("ban", s);
}

exec function xSession(string s)
{
    xKick("Session", s);
}


exec function xList(string s)
{
    local int   i;
    local array<string> strarrTemp;

    for (i = 0; i < strBanReason.Length; i++)
        strarrTemp[i] = "  "  $  i  $  " - "  $   strBanReason[i];

    SendComplexMsg(strarrTemp , "default reason codes");

}


exec function xHelp(string s)
{
    local int   i;

    for (i = 0; i < strHelpLines.Length; i++)
        ClientMessage(strHelpLines[i]);

}


function bool addToLog(string strCmd, Controller cN00b, string strReasonCode, string strReasonDecription)
{
    // FILE FORMAT
    // atetime; admin name; map name; nOOb name; nOObid; kick / kickban / session; reson code;reason description;

    local string strDate, strAdmin, strMap, strNoobName, strNoobId;
    local string strStringBuilder;
    local FileLog   fileLog;
    local string strLogFileName;


    strDate = GetDate();
    strAdmin = PlayerOwnerName;
    strMap = string(Level.Outer.name);
    strNoobName = cN00b.PlayerReplicationInfo.PlayerName;
    strNoobID = PlayerController(cN00b).GetPlayerIDHash();

    strStringBuilder = strDate                $  ";"  $ 
                    strAdmin             $  ";"  $ 
                    strMap           $  ";"  $ 
                    strNoobName          $  ";"  $ 
                    strNoobId            $  ";"  $ 
                    strCmd           $  ";"  $ 
                    strReasonCode        $  ";"  $ 
                    strReasonDecription  $  ";" ;


  // write to the file
    fileLog = spawn(class'FileLog');

    if (fileLog != None)
    {
        strLogFileName = "XBanMutator";

        fileLog.OpenLog(strLogFileName);
        fileLog.Logf(strStringBuilder);             // log to XBanMutator.log
        fileLog.CloseLog();
        log(" +++  XBanMutator: ##" @ strStringBuilder); // log to RedOrchestra.log
    }
    else
    {
        log(" ++++XBanMutator: XBanAdmin::addToLog(...) : Failed to create FileLog Object. Entry to write :"  $  strStringBuilder);
        ClientMessage("XBanMutator: could not write to the log. Entry written to RedOrchestra.log");
    }

    return true;
}


function string buildString(array<string> Params, optional int nStart)
{
    local int       i;
    local string strStringBuilder;

    strStringBuilder = "";

    // proofing params
    if (nStart < 1 || Params.Length < 1)
        return strStringBuilder;

    // building the string
    for (i = nStart; i < Params.Length ; i++)
        strStringBuilder = strStringBuilder @ Params[i];

    return strStringBuilder;
}


function array<string> TokenizeString(string Params) // space delimited
{
    local array<string> splitted;
    local int p, start, i;

    i = 0;

    while(Params != "")
    {
        p = 0;

        while(Mid(Params, p, 1) == " ") p++;
        if (Mid(Params, p) == "")
            break;

        start = p;

        while(Mid(Params, p, 1) != "" && Mid(Params, p, 1) != " ")
            p++;

        splitted[i++] = Mid(Params, start, p-start);

        Params = Mid(Params, p);
    }
    return splitted;
}


function string GetDate()
{
    // returns current date in the format : yyyy.mm.dd hh:mm   < - easy to sort date format :P
    local string str;

    str = string(Level.Year)  $  "." ;

    if (Level.Month < 10)
        str = str  $  "0";

    str = str  $  Level.Month  $  ".";

    if (Level.Day < 10)
        str = str  $  "0";

    str = str  $  Level.Day  $  " ";

    if (Level.Hour < 10)
        str = str  $  "0";

    str = str  $  Level.Hour  $  ":";

    if (Level.Minute < 10)
        str = str  $  "0";

    str = str  $  Level.Minute;

    return str;

}




/* EOF */

defaultproperties
{
     strBanReason(0)="no description"
     strBanReason(1)="TK"
     strBanReason(2)="offensive name"
     strBanReason(3)="exploiting"
     strBanReason(4)="spawn killing"
     strBanReason(5)="other"
     strHelpLines(0)="XBanMutator Help  v 0.2"
     strHelpLines(1)="======================================================== "
     strHelpLines(2)=" "
     strHelpLines(3)="usage:"
     strHelpLines(4)="      admin < command> < n00b> [reason_id] [reason_description]"
     strHelpLines(5)=" "
     strHelpLines(6)=" < command > ::="
     strHelpLines(7)="      xkick    - kick the n00b"
     strHelpLines(8)="      xsession  - kick / ban for the session"
     strHelpLines(9)="      xkickban - ban the n00b"
     strHelpLines(10)="      xhelp    - display this help oO"
     strHelpLines(11)="      xlist    - display the reason table"
     strHelpLines(12)=" "
     strHelpLines(13)=" < noob > ::="
     strHelpLines(14)="      - player name or player id"
     strHelpLines(15)=" "
     strHelpLines(16)="[reason_id]::="
     strHelpLines(17)="      the id identifying the reason why the n00b was kicked / banned."
     strHelpLines(18)="      see the reason table(xlist command). If it is not provided"
     strHelpLines(19)="       it will be filled with 5(other)."
     strHelpLines(20)=" "
     strHelpLines(21)="[reason_description]:="
     strHelpLines(22)="      a text describing the reason. if it is not provided the default"
     strHelpLines(23)="      text for the reason_id will be automatically assigned."
     strHelpLines(24)=" "
     strHelpLines(25)="======================================================== "
}
