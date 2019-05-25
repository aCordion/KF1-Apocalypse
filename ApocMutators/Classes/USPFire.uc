Class USPFire extends HL2WeaponFire;

var bool bCanFireNext,bWasZeroClip;

function StopFiring()
{
	bCanFireNext = True;
	SetTimer(0,false);
}
function ModeDoFire()
{
	if( Instigator==None || PlayerController(Instigator.Controller)==None || bCanFireNext )
	{
		if( Instigator!=None && Instigator.IsLocallyControlled() )
		{
			if( KFWeapon(Weapon).MagAmmoRemaining<=1 )
			{
				bWasZeroClip = true;
				RandFireAnims.Length = 1;
				RandFireAnims[0] = 'FireEmpty';
			}
			else if( bWasZeroClip )
			{
				bWasZeroClip = false;
				RandFireAnims = Default.RandFireAnims;
			}
		}
		Super.ModeDoFire();
		bCanFireNext = False;
		SetTimer(1,false);
	}
}
function Timer()
{
	bCanFireNext = True;
	if( bIsFiring )
		ModeDoFire();
}

defaultproperties
{
     bCanFireNext=True
     DamageType=Class'ApocMutators.DamTypeUSP'
     DamageMin=40
     DamageMax=45
     StereoFireSound=Sound'HL2WeaponsS.pistol.pistol_fire2'
     RandFireAnims(0)="Fire"
     RandFireAnims(1)="Fire1"
     RandFireAnims(2)="Fire2"
     RandFireAnims(3)="fire3"
     FlashEmitterBone="Muzzle"
     bPawnRapidFireAnim=True
     TransientSoundVolume=1.000000
     FireAnimRate=1.400000
     FireSound=Sound'HL2WeaponsS.pistol.pistol_fire2M'
     NoAmmoSound=Sound'HL2WeaponsS.pistol.pistol_empty'
     FireRate=0.100000
     AmmoClass=Class'ApocMutators.HL_USPAmmo'
     ShakeRotMag=(X=3.000000,Y=4.000000,Z=2.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeOffsetMag=(X=3.000000,Y=3.000000,Z=3.000000)
     FlashEmitterClass=Class'ApocMutators.FX_SMGMuzzle1st'
     aimerror=32.000000
     Spread=0.010000
}
