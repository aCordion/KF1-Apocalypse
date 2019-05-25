Class ApocZedDreadMut extends Mutator;

function PreBeginPlay()
{
	if( KFGameType(Level.Game)==None )
		Error("This mutator is only for KFGameType!");
	else
	{
		Spawn(Class'ApocZedDreadManager');
		AddToPackageMap();
	}
}

defaultproperties
{
     GroupName="KF-ApocZedDreadMut"
     FriendlyName="[APOC] ZED Dread"
     Description="Add armed and infected soldiers to the game."
     LifeSpan=0.100000
}
