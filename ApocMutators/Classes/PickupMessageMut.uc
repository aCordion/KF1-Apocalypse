class PickupMessageMut extends Mutator
	Config(ApocMutators);

var() globalconfig string StringReplace;// sorry but i don't find any replace like print_r('the nex word %s to translate',somevar)

function PreBeginPlay()
{
	Level.Game.AddGameModifier(Spawn(class'PickupMessageRules'));
}

static function FillPlayInfo(PlayInfo PlayInfo)
{
	Super.FillPlayInfo(PlayInfo);

	PlayInfo.AddSetting(default.GameGroup, "StringReplace", "Weapon Pickup text", 0, 0, "Text",   "100:200");
}

static event string GetDescriptionText(string PropName)
{
	switch(PropName)
	{
		case "StringReplace":return "A String to replace in every weapon pickup, see the description for further details.";

	}

	return Super.GetDescriptionText(PropName);
}

defaultproperties
{
	StringReplace="%KFARGPlayerName% pick %KFARGWeapon% up"
	GroupName="KFARGBuchonOPQ"
	FriendlyName="KFARGBuchonOPQ Weapon pickup message!"
	Description="KFARGBuchonOPQ by NANOMO | Params: %KFARGPlayerName% Player name | %KFARGWeapon% Weapon name | Example: I pickedup a %KFARGWeapon% weapon, will produce -> I pickedup a Bullpup weapon | visit http://www.killingfloorarg.com or write us to kf-argentina @ hotmail.com!! Fix by King Sumo"
	bAlwaysRelevant=True
	RemoteRole=ROLE_SimulatedProxy
}
