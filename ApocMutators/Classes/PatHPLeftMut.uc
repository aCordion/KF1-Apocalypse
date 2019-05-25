//=============================================================================
// Patriarch HP Left by Phada | 7 Sep. 2010 | http://phada.2ya.com/kf.xhtml
//=============================================================================
class PatHPLeftMut extends Mutator;

function PostBeginPlay()
{
	SetTimer(1.0, True);
}

function Timer()
{
	if (Level.Game.IsInState('MatchOver'))
	{
		ShowHP();
	}
}

function ShowHP()
{
	local ZombieBossBase Boss;
	local string Msg;
	local string Name;
	local int Health;
	local int HealthMax;
	local float Percentage;

	foreach DynamicActors(class'ZombieBossBase', Boss)
		break;

	if (Boss != None)
	{
		Name = GetNameOf(Boss);
		Health = Boss.Health;
		HealthMax = int(Boss.HealthMax);
		Percentage = (Boss.Health / Boss.HealthMax * 100);
		//Msg = Name $ " HP = " $ Health $ "/" $ HealthMax $ " (" $ Percentage $ "%)";
		Msg = name $ " HP = " $ Percentage $ "% (" $ Health $ "/" $ HealthMax $ ")";

		Level.Game.Broadcast(None, Msg);

		SetTimer(0.0, false);
	}
}

static final function string GetNameOf(ZombieBossBase Boss)
{
	if (Len(Boss.Default.MenuName) == 0)
		return string(Boss.Name);

	return Boss.Default.MenuName;
}

defaultproperties
{
	 bAddToServerPackages=True

	 GroupName="KF-PatHPLeftMut"
	 FriendlyName="Patriarch HP Left"
	 Description="Shows the remaining health of patriarch when the squad wipe."
}
