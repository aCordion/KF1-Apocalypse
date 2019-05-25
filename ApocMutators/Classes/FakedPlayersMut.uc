//-----------------------------------------------------------
//
//-----------------------------------------------------------
class FakedPlayersMut extends Mutator
    Config(ApocMutators);

var config int ForcedMinPlayers;

var localized string GUIDisplayText;
var localized string GUIDescText;

function PostBeginPlay()
{
	SetTimer(1.0,True);
}

function Timer()
{
    If (KFGameType(Level.Game).NumPlayers < ForcedMinPlayers)
    {
        KFGameType(Level.Game).NumPlayers = ForcedMinPlayers;
        Log("> [apoc]"@Class.Outer.Name@": ForcedMinPlayers ["$KFGameType(Level.Game).NumPlayers$"]");
    }
}

static function string GetDisplayText(string PropName) {
  switch (PropName) {
	case "ForcedMinPlayers":  return default.GUIDisplayText;
  }
  return "Null";
}

static event string GetDescriptionText(string PropName) {
  switch (PropName) {
	case "ForcedMinPlayers":  return default.GUIDescText;
  }
  return Super.GetDescriptionText(PropName);
}

static function FillPlayInfo(PlayInfo PlayInfo) {
  Super.FillPlayInfo(PlayInfo);

  PlayInfo.AddSetting(default.GameGroup, "ForcedMinPlayers", GetDisplayText("ForcedMinPlayers"), 0, 2, "Text", "6;1:99", "", False, False);
}

defaultproperties
{
	 ForcedMinPlayers=6
	 GUIDisplayText="Forced Minimum Players"
	 GUIDescText="Forced Minimum Players"
	 GroupName="KF-Custom"
	 FriendlyName="Faked Players"
	 Description="Simulate extras players to get a bit harder game."
}
