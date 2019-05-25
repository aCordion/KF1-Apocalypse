Class RPGFire extends HL2WeaponFire;

var bool bTrackingProj;
var float FireAnimEnd;

function Projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local Projectile p;

    p = Super.SpawnProjectile(Start,Dir);
	if( p!=None )
	{
		HL_RPG(Weapon).bTrackingProjectile = true;
		if( RPGProjectile(p)!=None )
		{
			RPGProjectile(p).TrackingTarget = HL_RPG(Weapon).TargetDot;
			RPGProjectile(p).MyWeapon = HL_RPG(Weapon);
		}
	}
    return p;
}
simulated function ModeTick( float dt )
{
	if( bTrackingProj && FireAnimEnd<Level.TimeSeconds )
	{
		// Don't allow firemode end before rocket has been destroyed.
		if( HL_RPG(Weapon).bTrackingProjectile )
			NextFireTime = Level.TimeSeconds+1.f;
		else
		{
			bTrackingProj = false;

			// Now auto-reload if possible.
			if( Weapon.AmmoAmount(0)>0 )
			{
				if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != none && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != none )
					dt = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.Static.GetReloadSpeedModifier(KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo), KFWeapon(Weapon));
				else dt = 1.0;

				if( Weapon.Role == ROLE_Authority )
				{
					Instigator.SetAnimAction(KFWeapon(Weapon).WeaponReloadAnim);
					KFWeapon(Weapon).AddReloadedAmmo();
				}
				if( Instigator.IsLocallyControlled() && Instigator.IsFirstPerson() )
					Weapon.PlayAnim(KFWeapon(Weapon).ReloadAnim, KFWeapon(Weapon).ReloadAnimRate*dt, 0.1);

				NextFireTime = Level.TimeSeconds+(KFWeapon(Weapon).Default.ReloadRate / dt);
			}
			else NextFireTime = Level.TimeSeconds;
		}
	}
}

simulated function PlayFiring()
{
	Super.PlayFiring();
	bTrackingProj = true;
	FireAnimEnd = Level.TimeSeconds+FireRate;
	NextFireTime = FireAnimEnd+1.f;
}
function ServerPlayFiring()
{
	Super.ServerPlayFiring();
	bTrackingProj = true;
	FireAnimEnd = Level.TimeSeconds+FireRate;
	NextFireTime = FireAnimEnd+1.f;
}
function Timer();

defaultproperties
{
     ProjSpawnOffset=(X=5.000000,Y=6.000000,Z=-4.000000)
     StereoFireSound=Sound'HL2WeaponsS.RPG.rocketfire1'
     RandFireAnims(0)="Fire"
     bUseTraceFire=False
     bWaitForRelease=True
     TransientSoundVolume=1.500000
     FireSound=Sound'HL2WeaponsS.RPG.rocketfire1M'
     NoAmmoSound=None
     FireRate=1.200000
     AmmoClass=Class'ApocMutators.HL_RPGAmmo'
     ShakeRotMag=(X=3.000000,Y=4.000000,Z=2.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeOffsetMag=(X=3.000000,Y=3.000000,Z=3.000000)
     ProjectileClass=Class'ApocMutators.RPGProjectile'
     aimerror=12.000000
}
