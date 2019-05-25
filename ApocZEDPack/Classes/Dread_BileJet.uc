//-----------------------------------------------------------
//
//-----------------------------------------------------------
class Dread_BileJet extends Actor;

var() rotator BileRotation;

function PostBeginPlay()
{
	settimer(0.1, false);
}

simulated function timer()
{
	local vector X,Y,Z;
	local int i;
	local rotator R;

	GetAxes(Rotation,X,Y,Z);

    // Randomly chuch out vomit globs
    for (i = 0; i < 1; i++)
    {
        R.Yaw = BileRotation.Yaw * FRand();
        R.Pitch = BileRotation.Pitch;
        R.Roll = BileRotation.Roll;
        Spawn(Class'Dread_LAWProj',,,Location,Rotator(X >> R));
    }

}

defaultproperties
{
     BileRotation=(Pitch=500,Yaw=10000)
     bHidden=True
     LifeSpan=2.500000
}
