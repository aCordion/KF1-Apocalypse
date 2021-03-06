class PP19Fire extends KFShotgunFire;

var float LastFireTime;

var()           class<Emitter>  ShellEjectClass;
var()           Emitter         ShellEjectEmitter;
var()           name            ShellEjectBoneName;

var()           float           MaxSpread;
var             int             NumShotsInBurst;
var()           bool            bAccuracyBonusForSemiAuto;

var(Recoil)     float           RecoilVelocityScale;
var(Recoil)     bool            bRecoilRightOnly;

simulated function bool AllowFire()
{
	if(KFWeapon(Weapon).bIsReloading)
		return false;
	if(KFPawn(Instigator).SecondaryItem!=none)
		return false;
	if(KFPawn(Instigator).bThrowingNade)
		return false;

	if(KFWeapon(Weapon).MagAmmoRemaining < 1)
	{
    	if( Level.TimeSeconds - LastClickTime>FireRate )
    	{
    		LastClickTime = Level.TimeSeconds;
    	}

		if( AIController(Instigator.Controller)!=None )
			KFWeapon(Weapon).ReloadMeNow();
		return false;
	}

	return super(WeaponFire).AllowFire();
}

simulated function HandleRecoil(float Rec)
{
	local rotator NewRecoilRotation;
	local KFPlayerController KFPC;
	local KFPawn KFPwn;

    if( Instigator != none )
    {
		KFPC = KFPlayerController(Instigator.Controller);
		KFPwn = KFPawn(Instigator);
	}

    if( KFPC == none || KFPwn == none )
    	return;

	if( !KFPC.bFreeCamera )
	{
    	if( Weapon.GetFireMode(0).bIsFiring || (DeagleAltFire(Weapon.GetFireMode(1))!=none
    	 && DeagleAltFire(Weapon.GetFireMode(1)).bIsFiring) )
    	{
          	NewRecoilRotation.Pitch = RandRange( maxVerticalRecoilAngle * 0.5, maxVerticalRecoilAngle );
         	NewRecoilRotation.Yaw = RandRange( maxHorizontalRecoilAngle * 0.5, maxHorizontalRecoilAngle );

          	if( !bRecoilRightOnly )
          	{
                if( Rand( 2 ) == 1 )
                 	NewRecoilRotation.Yaw *= -1;
            }

    	    if( RecoilVelocityScale > 0 )
    	    {
                NewRecoilRotation.Pitch += (VSize(Weapon.Owner.Velocity)* RecoilVelocityScale);
        	    NewRecoilRotation.Yaw += (VSize(Weapon.Owner.Velocity)* RecoilVelocityScale);
    	    }
    	    NewRecoilRotation.Pitch += (Instigator.HealthMax / Instigator.Health * 5);
    	    NewRecoilRotation.Yaw += (Instigator.HealthMax / Instigator.Health * 5);
    	    NewRecoilRotation *= Rec;

 		    KFPC.SetRecoil(NewRecoilRotation,RecoilRate / (default.FireRate/FireRate));
    	}
 	}
}

simulated function float GetSpread()
{
    local float NewSpread;
    local float AccuracyMod;

    AccuracyMod = 1.0;

    if( KFWeap.bAimingRifle )
    {
        AccuracyMod *= 0.5;
    }

    if( Instigator != none && Instigator.bIsCrouched )
    {
        AccuracyMod *= 0.85;
    }

    if( bAccuracyBonusForSemiAuto && bWaitForRelease )
    {
        AccuracyMod *= 0.85;
    }

    NumShotsInBurst += 1;

	if ( Level.TimeSeconds - LastFireTime > 0.5 )
	{
		NewSpread = Default.Spread;
		NumShotsInBurst=0;
	}
	else
    {
        NewSpread = FMin(Default.Spread + (NumShotsInBurst * (MaxSpread/6.0)),MaxSpread);
    }

    NewSpread *= AccuracyMod;

    return NewSpread;
}

simulated function InitEffects()
{
    super.InitEffects();

    if ( (Level.NetMode == NM_DedicatedServer) || (AIController(Instigator.Controller) != None) )
		return;
    if ( (ShellEjectClass != None) && ((ShellEjectEmitter == None) || ShellEjectEmitter.bDeleteMe) )
    {
        ShellEjectEmitter = Weapon.Spawn(ShellEjectClass);
        Weapon.AttachToBone(ShellEjectEmitter, ShellEjectBoneName);
    }
}

function DrawMuzzleFlash(Canvas Canvas)
{
    super.DrawMuzzleFlash(Canvas);
    if (ShellEjectEmitter != None )
    {
        Canvas.DrawActor( ShellEjectEmitter, false, false, Weapon.DisplayFOV );
    }
}

function FlashMuzzleFlash()
{
    super.FlashMuzzleFlash();

    if (ShellEjectEmitter != None)
    {
        ShellEjectEmitter.Trigger(Weapon, Instigator);
    }
}

simulated function DestroyEffects()
{
    super.DestroyEffects();

    if (ShellEjectEmitter != None)
        ShellEjectEmitter.Destroy();
}

function DoFireEffect()
{
   Super(KFShotgunFire).DoFireEffect();
}

/*simulated function bool AllowFire()
{
	return (!KFWeapon(Weapon).bIsReloading && Weapon.AmmoAmount(ThisModeNum) >= AmmoPerFire);
}*/

defaultproperties
{
     FireAimedAnim="Fire"
     RecoilRate=0.045000
     maxVerticalRecoilAngle=500
     maxHorizontalRecoilAngle=250
     bRecoilRightOnly=True
     ShellEjectClass=Class'ROEffects.KFShellEjectMac'
     ShellEjectBoneName="Shell_eject"
     bAccuracyBonusForSemiAuto=True
     bRandomPitchFireSound=False
     bWaitForRelease=false
     FireSound=Sound'PP19_Snd.PP19_shoot_mono'
     StereoFireSound=Sound'PP19_Snd.PP19_shoot_stereo'
     NoAmmoSound=Sound'PP19_Snd.PP19_empty'
//     DamageType=Class'DamTypePP19'
//     DamageMin=45
//     DamageMax=50
//     Momentum=9500.000000
     bPawnRapidFireAnim=True
     TransientSoundVolume=1.800000
     FireLoopAnim="Fire"
     TweenTime=0.025000
     FireForce="AssaultRifleFire"
     FireRate=0.114000
     AmmoClass=Class'PP19Ammo'
     ProjectileClass=Class'PP19Bullet'
     AmmoPerFire=1
     ShakeRotMag=(X=50.000000,Y=50.000000,Z=350.000000)
     ShakeRotRate=(X=5000.000000,Y=5000.000000,Z=5000.000000)
     ShakeRotTime=0.750000
     ShakeOffsetMag=(X=6.000000,Y=3.000000,Z=7.500000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.250000
     BotRefireRate=0.990000
     FlashEmitterClass=Class'ROEffects.MuzzleFlash1stSTG'
     aimerror=42.000000
     Spread=0.005000
     SpreadStyle=SS_Random
}
