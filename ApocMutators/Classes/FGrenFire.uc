Class FGrenFire extends HL2WeaponFire;

var() vector ThrowVelocity;

function ModeDoFire()
{
	Super.ModeDoFire();
	if( Level.NetMode!=NM_Client )
		SetTimer(0.44,false);
}
function Timer()
{
	if( Weapon.ammoAmount(0) <= 0 && Instigator != none && Instigator.Controller != none )
		Weapon.LifeSpan = 0.01; // Kill the weapon next tick.
}
function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local Projectile p;

    p = Super.SpawnProjectile(Start,Dir);
	if( p!=None )
	{
		Start = ThrowVelocity;
		Start.Z = 0;
		p.Velocity = (Start >> Dir)+vect(0,0,1)*ThrowVelocity.Z;
	}
    return p;
}

defaultproperties
{
     ThrowVelocity=(X=800.000000,Z=200.000000)
     ProjSpawnOffset=(X=5.000000,Y=6.000000,Z=8.000000)
     RandFireAnims(0)="Throw"
     bUsesAmmoMag=False
     bUseTraceFire=False
     bWaitForRelease=True
     FireSound=Sound'HL2WeaponsS.Grenade.Throw'
     NoAmmoSound=None
     FireRate=1.770000
     AmmoClass=Class'ApocMutators.HL_GrenadeAmmo'
     ProjectileClass=Class'ApocMutators.FGrenade'
     aimerror=0.000000
}
