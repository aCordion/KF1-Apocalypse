class DamagePopupMut extends Mutator
	config(ApocMutator);

var() globalconfig Byte CfgRed,CfgGreen,CfgBlue,CfgAlpha;

var localized string GUIDisplayText[4];
var localized string GUIDescText[4];

function PostBeginPlay()
{
	local GameRules G;
	local DamagePopupGameRules DG;

	Super.PostBeginPlay();
	G = spawn(class'DamagePopupGameRules');
	DG = DamagePopupGameRules(G);
	DG.MutatorOwner = self;
	if ( Level.Game.GameRulesModifiers == None )
		Level.Game.GameRulesModifiers = G;
	else
		Level.Game.GameRulesModifiers.AddGameRules(G);
	//Destroy();
}

static function string GetDisplayText(string PropName) {
  switch (PropName) {
    case "CfgRed":  	return default.GUIDisplayText[0];
	case "CfgGreen":  	return default.GUIDisplayText[1];
	case "CfgBlue":  	return default.GUIDisplayText[2];
	case "CfgAlpha":  	return default.GUIDisplayText[3];
  }
  return "Null";
}

static event string GetDescriptionText(string PropName) {
  switch (PropName) {
    case "CfgRed":  	return default.GUIDescText[0];
	case "CfgGreen":  	return default.GUIDescText[1];
	case "CfgBlue":  	return default.GUIDescText[2];
	case "CfgAlpha":  	return default.GUIDescText[3];
  }
  return Super.GetDescriptionText(PropName);
}

static function FillPlayInfo(PlayInfo PlayInfo) {
  Super.FillPlayInfo(PlayInfo);

  PlayInfo.AddSetting(default.GameGroup, "CfgRed", GetDisplayText("CfgRed"), 0, 2, "Text", "255;0:255", "", False, False);
  PlayInfo.AddSetting(default.GameGroup, "CfgGreen", GetDisplayText("CfgGreen"), 0, 2, "Text", "128;0:255", "", False, False);
  PlayInfo.AddSetting(default.GameGroup, "CfgBlue", GetDisplayText("CfgBlue"), 0, 2, "Text", "0;0:255", "", False, False);
  PlayInfo.AddSetting(default.GameGroup, "CfgAlpha", GetDisplayText("CfgAlpha"), 0, 2, "Text", "255;0:255", "", False, False);
}

defaultproperties
{
     CfgRed=255
     CfgGreen=128
     CfgAlpha=255
     GUIDisplayText(0)="Red"
     GUIDisplayText(1)="Green"
     GUIDisplayText(2)="Blue"
     GUIDisplayText(3)="Alpha"
     GUIDescText(0)="Red"
     GUIDescText(1)="Green"
     GUIDescText(2)="Blue"
     GUIDescText(3)="Alpha"
     bAddToServerPackages=True
     GroupName="KF-DamagePopup"
     FriendlyName="Damage Popup KF"
     Description="Make Damage values Popup."
     bAlwaysRelevant=True
     RemoteRole=ROLE_SimulatedProxy
}
