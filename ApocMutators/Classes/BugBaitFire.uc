Class BugBaitFire extends HL2WeaponFire;

function ModeDoFire()
{
	Super.ModeDoFire();
	if( Level.NetMode!=NM_Client )
		SetTimer(0.5,false);
}
function Timer()
{
	if( Weapon.ammoAmount(0) <= 0 && Instigator != none && Instigator.Controller != none )
		Weapon.LifeSpan = 0.01; // Kill the weapon next tick.
}

defaultproperties
{
     ProjSpawnOffset=(X=5.000000,Y=6.000000,Z=8.000000)
     RandFireAnims(0)="Throw"
     bUsesAmmoMag=False
     bUseTraceFire=False
     bWaitForRelease=True
     NoAmmoSound=None
     FireRate=1.200000
     AmmoClass=Class'ApocMutators.HL_BugBaitAmmo'
     ProjectileClass=Class'ApocMutators.BugBaitProjectile'
     aimerror=0.000000
}
