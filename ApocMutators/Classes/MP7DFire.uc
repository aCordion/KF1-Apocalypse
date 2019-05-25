class MP7DFire extends KFFire;

var 	sound   				FireEndSound;
var 	sound   				FireEndStereoSound;
var 	float   				AmbientFireSoundRadius;
var		sound					AmbientFireSound;
var		byte					AmbientFireVolume;

function StartFiring()
{
   GotoState('FireLoop');
}

function PlayAmbientSound(Sound aSound)
{
	local WeaponAttachment WA;

	WA = WeaponAttachment(Weapon.ThirdPersonActor);

    if ( Weapon == none || (WA == none))
        return;

	if(aSound == None)
	{
		WA.SoundVolume = WA.default.SoundVolume;
		WA.SoundRadius = WA.default.SoundRadius;
	}
	else
	{
		WA.SoundVolume = AmbientFireVolume;
		WA.SoundRadius = AmbientFireSoundRadius;
	}

    WA.AmbientSound = aSound;
}

event ModeDoFire()
{
	if( AllowFire() && IsInState('FireLoop'))
	{
	    Super.ModeDoFire();
	}
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

          	if( Rand( 2 ) == 1 )
             	NewRecoilRotation.Yaw *= -1;

    	    NewRecoilRotation.Pitch += (Instigator.HealthMax / Instigator.Health * 5);
    	    NewRecoilRotation.Yaw += (Instigator.HealthMax / Instigator.Health * 5);
    	    NewRecoilRotation *= Rec;

 		    KFPC.SetRecoil(NewRecoilRotation,RecoilRate / (default.FireRate/FireRate));
    	}
 	}
}

state FireLoop
{
    function BeginState()
    {
		NextFireTime = Level.TimeSeconds - 0.1; //fire now!

        if( KFWeap.bAimingRifle )
		{
            Weapon.LoopAnim(FireLoopAimedAnim, FireLoopAnimRate, TweenTime);
		}
		else
		{
            Weapon.LoopAnim(FireLoopAnim, FireLoopAnimRate, TweenTime);
		}

		PlayAmbientSound(AmbientFireSound);
    }

    function PlayFiring() {}
	function ServerPlayFiring() {}

    function EndState()
    {
        Weapon.AnimStopLooping();
        PlayAmbientSound(none);
    	if( Weapon.Instigator != none && Weapon.Instigator.IsLocallyControlled() &&
    	   Weapon.Instigator.IsFirstPerson() && StereoFireSound != none )
    	{
            Weapon.PlayOwnedSound(FireEndStereoSound,SLOT_None,AmbientFireVolume/127,,AmbientFireSoundRadius,,false);
        }
        else
        {
            Weapon.PlayOwnedSound(FireEndSound,SLOT_None,AmbientFireVolume/127,,AmbientFireSoundRadius);
        }
        Weapon.StopFire(ThisModeNum);
    }

    function StopFiring()
    {
        GotoState('');
    }

    function ModeTick(float dt)
    {
	    Super.ModeTick(dt);

		if ( !bIsFiring ||  !AllowFire()  )  // stopped firing, magazine empty
        {
			GotoState('');
			return;
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

    if( bWaitForRelease )
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

defaultproperties
{
     FireEndSound=SoundGroup'KF_MP7Snd.MP7_tail'
     FireEndStereoSound=SoundGroup'KF_MP7Snd.MP7_tailST'
     AmbientFireSoundRadius=500.000000
     AmbientFireSound=SoundGroup'KF_MP7Snd.MP7_FireLoop'
     AmbientFireVolume=255
     FireAimedAnim="Fire_Iron"
     FireEndAimedAnim="Fire_Iron_End"
     FireLoopAimedAnim="Fire_Iron_Loop"
     RecoilRate=0.060000
     maxVerticalRecoilAngle=125
     maxHorizontalRecoilAngle=100
     ShellEjectClass=Class'ROEffects.KFShellEjectMP'
     ShellEjectBoneName="Shell_eject_right"
     DamageType=Class'ApocMutators.Weapon_DamTypeMP7D'
     DamageMin=90
     DamageMax=100
     Momentum=5500.000000
     bPawnRapidFireAnim=True
     TransientSoundVolume=1.800000
     FireLoopAnim="Fire_Loop"
     FireEndAnim="Fire_End"
     TweenTime=0.025000
     NoAmmoSound=Sound'KF_MP7Snd.MP7_DryFire'
     FireForce="AssaultRifleFire"
     FireRate=0.063000
     AmmoClass=Class'ApocMutators.MP7DAmmo'
     AmmoPerFire=2
     ShakeRotMag=(X=25.000000,Y=25.000000,Z=125.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeRotTime=3.000000
     ShakeOffsetMag=(X=4.000000,Y=2.500000,Z=5.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.250000
     BotRefireRate=0.100000
     FlashEmitterClass=Class'ROEffects.MuzzleFlash1stMP'
     aimerror=30.000000
     Spread=0.012000
     SpreadStyle=SS_Random
}
