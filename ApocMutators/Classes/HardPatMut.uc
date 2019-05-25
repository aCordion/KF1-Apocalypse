class HardPatMut extends Mutator;


function PreBeginPlay()
{
	KFGameType(Level.Game).EndGameBossClass = string(Class'HardPat');
}

function Timer()
{
	//kyan: add
	ReplaceClassicBoss();

	Destroy();
}

//kyan: add
function ReplaceClassicBoss()
{
	class'KFChar.ZombieBoss_STANDARD'.default.EventClasses[0]="HardPat";
	class'KFChar.ZombieBoss_STANDARD'.default.EventClasses[1]="HardPat";
	class'KFChar.ZombieBoss_STANDARD'.default.EventClasses[2]="HardPat";
	class'KFChar.ZombieBoss_STANDARD'.default.EventClasses[3]="HardPat";
	class'KFMonstersCollection'.default.EndGameBossClass="HardPat";
	class'KFMonstersXmas'.default.EndGameBossClass="HardPat";
}

defaultproperties
{
	 bAddToServerPackages=True
	 GroupName="KF-HardPatMut"
	 FriendlyName="Hard Patriarch mode"
	 Description="Make the Patriarch boss harder than ever."
}
