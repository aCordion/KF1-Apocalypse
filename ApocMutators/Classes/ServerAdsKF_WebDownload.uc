///////////////////////////////////////////////////////////////////////////////
// filename:    ServerAdsKF_WebDownload.uc
// version:     101
// author:      DeeZNutZ <deeznutz@san.rr.com>
// perpose:     downloading ServerAds lines from a webserver
///////////////////////////////////////////////////////////////////////////////

class ServerAdsKF_WebDownload extends TCPLink;

const DEBUG     = false;

// public
var string      sHostname;
var int         iPort;
var string      sRequest;
var ServerAdsKF sase;

// private
var private string buffer;

// main function
function GetLines ()
{
  // resolve Hostname + connect
  Resolve(sHostname);
}

event Opened()
{
  if (DEBUG) log("[D] ServerAdsKF connection to "$sHostname$":"$iPort$" established");
  buffer = "";
  SendText("GET "$sRequest$" HTTP/1.0");
  SendText("Host: "$sHostname);
  SendText("Connection: close");
  SendText("User-agent: ServerAdsKF ("$sase.VERSION$"; KillingFloor; "$Level.EngineVersion$"; www.BadStreak.com)");
  SendText("");
}

event Closed()
{
  local int i;
  local string header;
  local array< string > lines;
  if (DEBUG) log("[D] ServerAdsKF connection to "$sHostname$":"$iPort$" closed");

  // devide headers and data
  if (Divide(buffer, Chr(13) $ Chr(10) $ Chr(13) $ Chr(10), header, buffer) == false) {
    if (DEBUG) log("[D] ServerAdsKF no valid data received");
    return;
  };
  // split lines of data
  if (Split(buffer, Chr(10), lines) == 0) {
    if (DEBUG) log("[D] ServerAdsKF no valid data received");
    return;
  };

  // check for correct download
  if (InStr(Caps(header), "200 OK") == -1)
  {
    log("[E] ServerAdsKF: webserver didn't return a code 200");
    return;
  }
  // check for correct content type
  if (InStr(Caps(header), "CONTENT-TYPE: TEXT/PLAIN") == -1)
  {
    log("[E] ServerAdsKF: webserver didn't return a plain text file");
    return;
  }

  log("[~] ServerAdsKF updating lines from web");
  for (i = 0; i < lines.length; i++ )
  {   
    // cut off CR
    if (InStr(lines[i], Chr(13)) > -1)
    {
      lines[i] = Left(lines[i], InStr(lines[i], Chr(13)));
    }
    if (lines[i] != "")
    {
      if (DEBUG) log("[D] ServerAdsKF line["$i$"]: "$lines[i]);
      sase.sLines[i] = lines[i];
      sase.nLines = i+1;
    }
    if (i > sase.MAXLINES) {
      if (DEBUG) log("[D] ServerAdsKF received more the max lines");
      break;
    }
  }

  // clear other lines
  for (i = sase.nLines; i < sase.MAXLINES; i++)
  {
    sase.sLines[i] = "";
  }
  log("[~] There are now "$sase.nLines$" lines in the list");
  if (sase.iCurPos >= sase.nLines) sase.iCurPos = 0;

  sase.StaticSaveConfig();
  sase.SaveConfig();
}

event ReceivedLine( string Line )
{
  if (DEBUG) log("[D] ServerAdsKF read: "$Line);
  buffer = buffer$Line;
}

event Resolved( IpAddr Addr )
{
  Addr.Port = iPort;
  if (DEBUG) log("[D] ServerAdsKF connecting to: "$sHostname$" ("$IpAddrToString(Addr)$")");
  BindPort();
  LinkMode = MODE_Line;
  ReceiveMode = RMODE_Event;
  Open(Addr);  
}

event ResolveFailed()
{
  log("[E] ServerAdsKF resolve failed, cannot update ServerAdsKF lines");
}

defaultproperties
{
}
