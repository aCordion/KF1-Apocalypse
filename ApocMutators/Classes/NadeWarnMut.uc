//=============================================================================
// Nade Warn by Phada | 5 April 2011 | http://phada.2ya.com / kf.xhtml
// Network replication code by Marco
//=============================================================================
class NadeWarnMut extends Mutator
	Config(ApocMutators);

var config bool bOwnNadeOnly, bShowDanger;
var config byte NadeAlpha;
var config float WarnDelay;
var localized string sOption[4], sToolTip[4];

replication {
	reliable if (Role == ROLE_Authority)
		bOwnNadeOnly, bShowDanger, NadeAlpha, WarnDelay;
}

simulated function BeginPlay() {
	if(Level.NetMode == NM_Client) { // Reset client values to zero before receiving server values.
		bOwnNadeOnly = false;
		bShowDanger = false;
		WarnDelay = 0;
	}
}

function PostBeginPlay() { // fixing some options values
	NadeAlpha = Clamp(NadeAlpha, 10, 100);
	default.NadeAlpha = NadeAlpha;
	NadeAlpha *= 2.55; // scaled now to real value 25~255
	WarnDelay = fClamp(WarnDelay, 0, 1.5);
	default.WarnDelay = WarnDelay;
}

simulated function Tick(float DeltaTime) { // running client-side only, gives hud overlay to non-spectator player
	local PlayerController PC;
	local NadeWarnHUDO NewOverlay;
	PC = Level.GetLocalPlayerController();
	if (PC != None && PC.PlayerReplicationInfo != None) {
		if (PC.PlayerReplicationInfo.bOnlySpectator)
			Disable('Tick');
		else if (PC.myHUD != None) {
			NewOverlay = Spawn(class'NadeWarnHUDO');
			if (NewOverlay != None) {
				NewOverlay.Mut = self;
				PC.myHUD.AddHUDOverlay(NewOverlay);
				Disable('Tick');
			}
		}
	}
}

// config stuff from here
static event string GetDescriptionText(string PropName) {
	switch(PropName) {
	case "bOwnNadeOnly": return default.sToolTip[0];
	case "WarnDelay": return default.sToolTip[1];
	case "NadeAlpha": return default.sToolTip[2];
	case "bShowDanger": return default.sToolTip[3];
	}
	return Super.GetDescriptionText(PropName);
}

static function FillPlayInfo(PlayInfo PlayInfo) {
	Super.FillPlayInfo(PlayInfo);
	PlayInfo.AddSetting(default.GameGroup, "bOwnNadeOnly", default.sOption[0], 0, 0, "Check");
	PlayInfo.AddSetting(default.GameGroup, "WarnDelay", default.sOption[1], 0, 1, "Text", "0.60;0.00:1.50");
	PlayInfo.AddSetting(default.GameGroup, "NadeAlpha", default.sOption[2], 0, 2, "Text", "60;10:100");
	PlayInfo.AddSetting(default.GameGroup, "bShowDanger", default.sOption[3], 0, 3, "Check");
}

defaultproperties
{
	 bShowDanger=True
	 NadeAlpha=60
	 WarnDelay=0.600000
	 sOption(0)="Only Warns Your Own Grenades"
	 sOption(1)="Warn Delay For Own Grenades"
	 sOption(2)="Grenade Icon Transparency %"
	 sOption(3)="Shows DANGER Word"
	 sToolTip(0)="Not recommended with friendly fire on."
	 sToolTip(1)="Delay in seconds: 0=always visible, 0.6=recommended, 1.5=max, 2=explosion."
	 sToolTip(2)="Icon alpha in percentage."
	 sToolTip(3)="In complementary to the icon."
	 bAddToServerPackages=True
	 GroupName="KFNadeWarn"
	 FriendlyName="Nade Warn"
	 Description="Shows an icon to easily see the grenades position at close range.||[Configurable]"
	 bAlwaysRelevant=True
	 RemoteRole=ROLE_SimulatedProxy
}
