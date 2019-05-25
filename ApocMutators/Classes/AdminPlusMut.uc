/*
Title:           AdminPlus_v3 Mutator for Killing Floor
Creator:         Rythmix@Gmail.com - 11/08/2004
				 ported to Killing Floor by    RED-FROG  Red_Frog@web.de   May 30th, 2009
WebSite:         http://rythmix.zclans.com
				 http://www.levels4you.com
Add'l Content:   Based off of the AdminCheats and AdminUtils
				 mutators by mkhaos7 and James M. Poore Jr.
Features:  		 TempAdmin, ChangeName, CustomLoaded1,2,3, Godon/off,
				 GiveItem, PlayerSize, HeadSize, SetGrav, PrivMessage,
				 Reset Score, Change Score, Ghost/Fly/Spider/Walk, Summon,
				 Advanced Summon, Loaded, DNO, SloMo, Teleport
				 Cause Event
				-----------------------------------------------------------
				 Partial Name Recognition, 'ALL' Names Recognition
				 Applicable functions Work with Spectators, SuperAdmin
*/
class AdminPlusMut extends Mutator
	Config(ApocMutators);

var config array<string> WeaponBase1;
var config array<string> WeaponBase2;
var config array<string> WeaponBase3;
var config array<string> SuperAdmin;
var config int iSlapDamage;
//var config int iMomentum;

var config bool bAllowSummon, bAllowSlap, bAllowCombos, bAllowChangeScore, bAllowSetGravity, bAllowPrivMessage, bAllowChangeSize, bAllowGiveItem, bAllowLoaded, bAllowGod, bAllowGhost, bAllowCustomLoaded, bAllowFly, bAllowInvis, bAllowFatality, bAllowTempAdmin, bAllowCauseEvent, bAllowDNO, bAllowSpider, bAllowSloMo, bAllowChangeName, bAllowAdvancedSummon, bAllowTeleport;
var localized string SummonDisplayText, SlapDisplayText, SlapDescText, CombosDisplayText, CombosDescText, PrivMessageDescText, PrivMessageDisplayText, ChangeScoreDescText, ChangeScoreDisplayText, SetGravityDisplayText, SetGravityDescText, ChangeSizeDisplayText, ChangeSizeDescText, GiveItemDisplayText, GiveItemDescText, LoadedDisplayText, CustomLoadedDisplayText, GodDisplayText, GhostDisplayText, SummonDescText, LoadedDescText, GodDescText, GhostDescText, FlyDisplayText, FlyDescText, InvisDisplayText, InvisDescText, FatalityDisplayText, FatalityDescText, ChangeNameDisplayText, ChangeNameDescText, TempAdminDisplayText, TempAdminDescText, TempAdminOffDisplayText, TempAdminOffDescText, CauseEventDisplayText, CauseEventDescText, DNODisplayText, DNODescText, SpiderDisplayText, SpiderDescText, SloMoDisplayText, SloMoDescText, AdvancedSummonDisplayText, CustomLoadedDescText, AdvancedSummonDescText, TeleportDisplayText, TeleportDescText;

static function FillPlayInfo(PlayInfo PlayInfo)
{
	Super.FillPlayInfo(PlayInfo);

	PlayInfo.AddSetting(default.RulesGroup, "bAllowSummon", default.SummonDisplayText, 0, 1, "Check");
	PlayInfo.AddSetting(default.RulesGroup, "bAllowLoaded", default.LoadedDisplayText, 0, 1, "Check");
	PlayInfo.AddSetting(default.RulesGroup, "bAllowCustomLoaded", default.CustomLoadedDisplayText, 0, 1, "Check");
	PlayInfo.AddSetting(default.RulesGroup, "bAllowGiveItem", default.GiveItemDisplayText, 0, 1, "Check");
	PlayInfo.AddSetting(default.RulesGroup, "bAllowChangeScore", default.ChangeScoreDisplayText, 0, 1, "Check");
	PlayInfo.AddSetting(default.RulesGroup, "bAllowGod", default.GodDisplayText, 0, 1, "Check");
	PlayInfo.AddSetting(default.RulesGroup, "bAllowGhost", default.GhostDisplayText, 0, 1, "Check");
	PlayInfo.AddSetting(default.RulesGroup, "bAllowFly", default.FlyDisplayText, 0, 1, "Check");
	PlayInfo.AddSetting(default.RulesGroup, "bAllowInvis", default.InvisDisplayText, 0, 1, "Check");
	PlayInfo.AddSetting(default.RulesGroup, "bAllowFatality", default.FatalityDisplayText, 0, 1, "Check");
	PlayInfo.AddSetting(default.RulesGroup, "bAllowTempAdmin", default.TempAdminDisplayText, 0, 1, "Check");
	PlayInfo.AddSetting(default.RulesGroup, "bAllowChangeName", default.ChangeNameDisplayText, 0, 1, "Check");
	PlayInfo.AddSetting(default.RulesGroup, "bAllowChangeSize", default.ChangeSizeDisplayText, 0, 1, "Check");
	PlayInfo.AddSetting(default.RulesGroup, "bAllowCauseEvent", default.CauseEventDisplayText, 0, 1, "Check");
	PlayInfo.AddSetting(default.RulesGroup, "bAllowDNO", default.DNODisplayText, 0, 1, "Check");
	PlayInfo.AddSetting(default.RulesGroup, "bAllowSpider", default.SpiderDisplayText, 0, 1, "Check");
	PlayInfo.AddSetting(default.RulesGroup, "bAllowSloMo", default.SloMoDisplayText, 0, 1, "Check");
	PlayInfo.AddSetting(default.RulesGroup, "bAllowSetGravity", default.SetGravityDisplayText, 0, 1, "Check");
	PlayInfo.AddSetting(default.RulesGroup, "bAllowAdvancedSummon", default.AdvancedSummonDisplayText, 0, 1, "Check");
	PlayInfo.AddSetting(default.RulesGroup, "bAllowTeleport", default.TeleportDisplayText, 0, 1, "Check");
	PlayInfo.AddSetting(default.RulesGroup, "bAllowPrivMessage", default.PrivMessageDisplayText, 0, 1, "Check");
	PlayInfo.AddSetting(default.RulesGroup, "bAllowCombos", default.CombosDisplayText, 0, 1, "Check");
	PlayInfo.AddSetting(default.RulesGroup, "bAllowSlap", default.SlapDisplayText, 0, 1, "Check");
}

static event string GetDescriptionText(string PropName)
{
	switch (PropName)
	{
		case "bAllowSummon":	return default.SummonDescText;
		case "bAllowLoaded":	return default.LoadedDescText;
		case "bAllowCustomLoaded":	return default.CustomLoadedDescText;
		case "bAllowGiveItem":	return default.GiveItemDescText;
		case "bAllowChangeScore":	return default.ChangeScoreDescText;
		case "bAllowGod":	return default.GodDescText;
		case "bAllowGhost":	return default.GhostDescText;
		case "bAllowFly":	return default.FlyDescText;
		case "bAllowSpider":	return default.SpiderDescText;
		case "bAllowInvis":	return default.InvisDescText;
		case "bAllowFatality":	return default.FatalityDescText;
		case "bAllowTempAdmin":	return default.TempAdminDescText;
		case "bAllowChangeName":	return default.ChangeNameDescText;
		case "bAllowChangeSize":	return default.ChangeSizeDescText;
		case "bAllowCauseEvent":	return default.CauseEventDescText;
		case "bAllowDNO":	return default.DNODescText;
		case "bAllowSpider":	return default.SpiderDescText;
		case "bAllowSloMo":	return default.SloMoDescText;
		case "bAllowSetGravity":	return default.SetGravityDescText;
		case "bAllowAdvancedSummon":	return default.AdvancedSummonDescText;
		case "bAllowTeleport":	return default.TeleportDescText;
		case "bAllowPrivMessage":	return default.PrivMessageDescText;
		case "bAllowCombos":	return default.CombosDescText;
		case "bAllowSlap":	return default.SlapDescText;
	}

	return Super.GetDescriptionText(PropName);
}

event PreBeginPlay(){
	Super.PreBeginPlay();

  Level.Game.AccessControl.AdminClass = class'AdminPlus';
	Level.Game.bAllowMPGameSpeed = true;
}

function bool SummonEnabled(){
  return bAllowSummon;
}

function bool LoadedEnabled(){
  return bAllowLoaded;
}

function bool CustomLoadedEnabled(){
  return bAllowCustomLoaded;
}

function bool GiveItemEnabled(){
  return bAllowGiveItem;
}

function bool ChangeScoreEnabled(){
  return bAllowChangeScore;
}

function bool GhostEnabled(){
  return bAllowGhost;
}

function bool GodEnabled(){
  return bAllowGod;
}

function bool FlyEnabled(){
  return bAllowFly;
}

function bool InvisEnabled(){
  return bAllowInvis;
}

function bool FatalityEnabled(){
  return bAllowFatality;
}

function bool TempAdminEnabled(){
  return bAllowTempAdmin;
}

function bool ChangeNameEnabled(){
  return bAllowChangeName;
}

function bool ChangeSizeEnabled(){
  return bAllowChangeSize;
}

function bool CauseEventEnabled(){
  return bAllowCauseEvent;
}

function bool DNOEnabled(){
  return bAllowDNO;
}

function bool SpiderEnabled(){
  return bAllowSpider;
}

function bool SloMoEnabled(){
  return bAllowSloMo;
}

function bool CombosEnabled(){
  return bAllowCombos;
}

function bool SlapEnabled(){
  return bAllowSlap;
}

function bool SetGravityEnabled(){
  return bAllowSetGravity;
}

function bool AdvancedSummonEnabled(){
  return bAllowAdvancedSummon;
}

function bool TeleportEnabled(){
  return bAllowTeleport;
}

function bool PrivMessageEnabled(){
  return bAllowPrivMessage;
}

defaultproperties
{
	 iSlapDamage=1
	 bAllowSummon=True
	 bAllowSlap=True
	 bAllowCombos=True
	 bAllowChangeScore=True
	 bAllowSetGravity=True
	 bAllowPrivMessage=True
	 bAllowChangeSize=True
	 bAllowGiveItem=True
	 bAllowLoaded=True
	 bAllowGod=True
	 bAllowGhost=True
	 bAllowCustomLoaded=True
	 bAllowFly=True
	 bAllowInvis=True
	 bAllowFatality=True
	 bAllowTempAdmin=True
	 bAllowCauseEvent=True
	 bAllowDNO=True
	 bAllowSpider=True
	 bAllowSloMo=True
	 bAllowChangeName=True
	 bAllowAdvancedSummon=True
	 bAllowTeleport=True
	 SummonDisplayText="Summon"
	 SlapDisplayText="Slap"
	 SlapDescText="Allows Admins to slap players, a little warning for misbehavior"
	 CombosDisplayText="Instant Combos"
	 CombosDescText="Allows admins to initiate Combos to players"
	 PrivMessageDescText="Allows Admins to send private messages to separate players"
	 PrivMessageDisplayText="Private Messages"
	 ChangeScoreDescText="Allows you to reset any players score by name"
	 ChangeScoreDisplayText="Reset Score"
	 SetGravityDisplayText="Change Gravity (default = -950)"
	 SetGravityDescText="Allows you to modify the Level Gravity. (default = -950)"
	 ChangeSizeDisplayText="Head size Change"
	 ChangeSizeDescText="Change Player's head size to larger or smaller"
	 GiveItemDisplayText="GiveItem"
	 GiveItemDescText="Gives Targeted Players the Item declared."
	 LoadedDisplayText="Loaded"
	 CustomLoadedDisplayText="CustomLoaded"
	 GodDisplayText="God Mode"
	 GhostDisplayText="Ghost"
	 SummonDescText="Summon actors inside the level."
	 LoadedDescText="Gives Targeted Players All Weapons and Ammo."
	 GodDescText="Makes You Invunerable."
	 GhostDescText="Let's you go into Ghost Mode."
	 FlyDisplayText="Fly"
	 FlyDescText="Let's you go into Fly Mode."
	 InvisDisplayText="Invisiblity"
	 InvisDescText="Let's you become Invisible."
	 FatalityDisplayText="Fatality!"
	 FatalityDescText="An Instant Death to Anyone Foolish Enough to Anger the Gods."
	 ChangeNameDisplayText="Change Players names"
	 ChangeNameDescText="Change vulgar Player's names to something more appropriate"
	 TempAdminDisplayText="Temporary Admin."
	 TempAdminDescText="Allow Players to Become Temporary Admins.  Be Careful!  These People Will Have Full Admin Access!  Only Works On Single Admin Systems."
	 TempAdminOffDisplayText="Disable Temporary Admin."
	 TempAdminOffDescText="Remove Players Temporary Admin Status."
	 CauseEventDisplayText="Cause Event"
	 CauseEventDescText="Triggers an In-Game Event Handy For Debugging."
	 DNODisplayText="Disable Next Objective"
	 DNODescText="Allows You To Disable The Next Objective In Assault Games."
	 SpiderDisplayText="Spider"
	 SpiderDescText="Let's you go into Spider Mode and cling to surfaces."
	 SloMoDisplayText="SloMo"
	 SloMoDescText="Allows you to modify the game speed."
	 AdvancedSummonDisplayText="Advanced Summon"
	 CustomLoadedDescText="Gives Targeted Players All Custom Weapons from INI files."
	 AdvancedSummonDescText="Allows you to summon things to another location. (Another Player's Location)"
	 TeleportDisplayText="Teleport"
	 TeleportDescText="Teleports you to the surface (wall) your crosshair is pointing to"
	 GroupName="KF-AdminPlus_v3"
	 FriendlyName="AdminPlus_v3"
	 Description="Allows Admin commands to work in Online Games"
}
