Class BugBaitAltFire extends HL2WeaponFire;

function Timer()
{
	Class'ZEDAttractInv'.Static.SetTargeting(Level,Instigator.Location,false,Instigator);
}
function DoFireEffect()
{
	Instigator.MakeNoise(1.0);
	SetTimer(0.25,false);
}

defaultproperties
{
     RandFireAnims(0)="Squeeze"
     bUsesAmmoMag=False
     bWaitForRelease=True
     TransientSoundVolume=1.000000
     FireSound=SoundGroup'HL2WeaponsS.BugBait.BugBait_Squeeze'
     NoAmmoSound=None
     FireRate=0.800000
     AmmoPerFire=0
}
