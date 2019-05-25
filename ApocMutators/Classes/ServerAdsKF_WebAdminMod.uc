///////////////////////////////////////////////////////////////////////////////
// filename:    ServerAdsKF_WebAdminMod.uc
// version:     101
// author:      DeeZNutZ <deeznutz@san.rr.com>
// perpose:     Web Administration area for ServerAdsKF
///////////////////////////////////////////////////////////////////////////////

class ServerAdsKF_WebAdminMod extends xWebQueryHandler;

const DEBUG     = false;

var ServerAdsKF sase;
var string AboutPage;
var string SettingsPage;

var string RootPath;
var string FileIndex;
var string FileAbout;
var string FileFrame;
var string FileStyleSheet;

function bool Init()
{
  GetServerAdsKF();
    Super.Init();
  log("[~] ServerAdsKF ServerAdsKF_WebAdmin loaded");
  return true;
}

function GetServerAdsKF()
{
    local ServerAdsKF A;
    foreach Level.AllActors( class'ServerAdsKF', A )
  {
    if (String(A.class) == "ApocMutators.ServerAdsKF")
    {
      if (DEBUG) log("[D] ServerAdsKF actor found");
      sase = A;
    }
    }
  if (sase == none)
  {
    Log("[E] ServerAdsKF actor NOT found !");
  }
}

function bool Query(WebRequest Request, WebResponse Response)
{
  switch (Mid(Request.URI, 1))
    {
    case DefaultPage:       RequestFrame(Request, Response); return true;
      case SettingsPage:          RequestIndex(Request, Response); return true;
    case AboutPage:         RequestAbout(Request, Response); return true;
      case FileStyleSheet:    Response.SendCachedFile(RootPath$"/"$FileStyleSheet, "text/css"); return true;
    }
  return false;
}

function defaultSubsts (WebResponse Response)
{
  Response.Subst("urlhome", SettingsPage);
  Response.Subst("urlabout", AboutPage);
  Response.Subst("VERSION", sase.VERSION);
  Response.Subst("Title", Title);
}

function bool RequestIndex(WebRequest Request, WebResponse Response)
{
  local string ssLines, line;
  local int i;
  defaultSubsts(Response);
  if (Request.GetVariable("update") == "settings")
  {
    if (Request.GetVariable("submit") == "save")
    {
      if (DEBUG) log("[D] Updating settings from ServerAdsKF_WebAdmin");
      sase.bEnabled = (Request.GetVariable("bEnabled") == "true");
      sase.fDelay = float(Request.GetVariable("fDelay", "300"));
      sase.iAdType = int(Request.GetVariable("iAdType", "0"));
      sase.iGroupSize = int(Request.GetVariable("iGroupSize", "0"));
      sase.bWrapAround = (Request.GetVariable("bWrapAround") == "true");
      sase.iAdminMsgDuration = int(Request.GetVariable("iAdminMsgDuration", "5"));
      sase.cAdminMsgColor.R = int(Request.GetVariable("cAdminMsgColorR", "255"));
      sase.cAdminMsgColor.G = int(Request.GetVariable("cAdminMsgColorG", "255"));
      sase.cAdminMsgColor.B = int(Request.GetVariable("cAdminMsgColorB", "255"));
      sase.bUseURL = (Request.GetVariable("bUseURL") == "true");
      sase.sURLHost = Request.GetVariable("sURLHost");
      sase.iURLPort = int(Request.GetVariable("iURLPort", "80"));
      sase.sURLRequest = Request.GetVariable("sURLRequest");
      sase.StaticSaveConfig();
      sase.SaveConfig();
    }
    else if (Request.GetVariable("submit") == "update lines")
    {
      if (DEBUG) log("[D] Updating lines via web");
      sase.getLinesFromWeb();
    }
  }
  if (Request.GetVariable("update") == "lines")
  {
    if (DEBUG) log("[D] Updating lines from ServerAdsKF_WebAdmin");
    ssLines = Request.GetVariable("sLines");
    line = Left(ssLines, InStr(ssLines, Chr(10)));
    i = 0;
    while (((Len(ssLines) > 0) || (line != "")) && (i < sase.MAXLINES))
    {
      if (InStr(line, Chr(13)) > -1)
      {
        line = Left(line, InStr(line, Chr(13)));
      }
      if (line != "")
      {
        if (DEBUG) log("[D] ServerAdsKF line["$i$"]: "$line);
        sase.sLines[i] = line;
        sase.nLines = i+1;
        i++;
      }

      ssLines = Mid(ssLines, InStr(ssLines, Chr(10)) + 1);
      if (InStr(ssLines, Chr(10)) > -1)
      {
        line = Left(ssLines, InStr(ssLines, Chr(10)));
      }
      else {
        line = ssLines;
        ssLines = "";
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

  if (sase.bEnabled) Response.Subst("bEnabled", "CHECKED");
    else Response.Subst("bEnabled", "");
  Response.Subst("fDelay", string(sase.fDelay));
  switch (sase.iAdType)
  {
    case 0: Response.Subst("iAdType0", "SELECTED");
            Response.Subst("iAdType1", "");
            Response.Subst("iAdType2", "");
            break;
    case 1: Response.Subst("iAdType0", "");
            Response.Subst("iAdType1", "SELECTED");
            Response.Subst("iAdType2", "");
            break;
    case 2: Response.Subst("iAdType0", "");
            Response.Subst("iAdType1", "");
            Response.Subst("iAdType2", "SELECTED");
            break;
  }
  Response.Subst("iGroupSize",  string(sase.iGroupSize));
  if (sase.bWrapAround) Response.Subst("bWrapAround", "CHECKED");
    else Response.Subst("bWrapAround", "");
  Response.Subst("iAdminMsgDuration",  string(sase.iAdminMsgDuration));
  Response.Subst("cAdminMsgColorR",  string(sase.cAdminMsgColor.R));
  Response.Subst("cAdminMsgColorG",  string(sase.cAdminMsgColor.G));
  Response.Subst("cAdminMsgColorB",  string(sase.cAdminMsgColor.B));
  if (sase.bUseURL) Response.Subst("bUseURL", "CHECKED");
    else Response.Subst("bUseURL", "");
  Response.Subst("sURLHost", sase.sURLHost);
  Response.Subst("iURLPort",  string(sase.iURLPort));
  Response.Subst("sURLRequest", sase.sURLRequest);
  ssLines = "";
  for (i = 0; i < sase.nLines; i++)
  {
    ssLines = ssLines$sase.sLines[i]$Chr(10);
  }
  Response.Subst("sLines", ssLines);
  Response.Subst("nLines",  string(sase.nLines));

  Response.IncludeUHTM(RootPath$"/"$FileIndex);
    Response.ClearSubst();
  return true;
}

function bool RequestAbout(WebRequest Request, WebResponse Response)
{
  defaultSubsts(Response);
  Response.IncludeUHTM(RootPath$"/"$FileAbout);
    Response.ClearSubst();
  return true;
}

function bool RequestFrame(WebRequest Request, WebResponse Response)
{
  if (sase == none)
  {
    Response.SendText("<html><body><pre>Could not find a ServerAdsKF instance, please check your server's configuration if it contains the following lines:");
    Response.SendText("[Engine.GameEngine]");
    Response.SendText("ServerActors=ApocMutators.ServerAdsKF</pre></body></html>");
    return true;
  }
  defaultSubsts(Response);
  Response.IncludeUHTM(RootPath$"/"$FileFrame);
    Response.ClearSubst();
  return true;
}

defaultproperties
{
     AboutPage="ServerAdsKFAbout"
     SettingsPage="ServerAdsKFSettings"
     RootPath="ServerAdsKF"
     FileIndex="index.html"
     FileAbout="about.html"
     FileFrame="frame.html"
     FileStyleSheet="ServerAdsKF.css"
     DefaultPage="ServerAdsKF"
     Title="ServerAdsKF"
}
