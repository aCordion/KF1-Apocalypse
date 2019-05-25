class HealThrowerBlast extends KFShotgunFire ;

var int MaxLoad;

var 	sound   				FireEndSound;
var 	float   				AmbientFireSoundRadius;
var		sound					AmbientFireSound;
var		byte					AmbientFireVolume;

var		string			FireEndSoundRef;
var		string			AmbientFireSoundRef;

static function PreloadAssets(LevelInfo LevelInfo, optional KFShotgunFire Spawned)
{
	super.PreloadAssets(LevelInfo, Spawned);

	if ( default.FireEndSoundRef != "" )
	{
		default.FireEndSound = sound(DynamicLoadObject(default.FireEndSoundRef, class'sound', true));
	}

	if ( default.AmbientFireSoundRef != "" )
	{
		default.AmbientFireSound = sound(DynamicLoadObject(default.AmbientFireSoundRef, class'sound', true));
	}

	if ( HealThrowerBlast(Spawned) != none )
	{
		HealThrowerBlast(Spawned).FireEndSound = default.FireEndSound;
		HealThrowerBlast(Spawned).AmbientFireSound = default.AmbientFireSound;
	}
}

static function bool UnloadAssets()
{
	super.UnloadAssets();

	default.FireEndSound = none;
	default.AmbientFireSound = none;

	return true;
}

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

simulated function bool AllowFire()
{
	if(KFWeapon(Weapon).bIsReloading)
		return false;
	if(KFWeapon(Weapon).MagAmmoRemaining < 1)
	{
		if(Level.TimeSeconds - LastClickTime > FireRate)
		{
			Weapon.PlayOwnedSound(NoAmmoSound, SLOT_Interact, TransientSoundVolume,,,, false);
			LastClickTime = Level.TimeSeconds;
			if(Weapon.HasAnim(EmptyAnim))
				weapon.PlayAnim(EmptyAnim, EmptyAnimRate, 0.0);
		}
		return false;
	}
	LastClickTime = Level.TimeSeconds;
	//return Super.AllowFire();
	return (Weapon.AmmoAmount(ThisModeNum) >= AmmoPerFire);
}

state FireLoop
{
    function BeginState()
    {
		NextFireTime = Level.TimeSeconds - 0.1; //fire now!

        Weapon.LoopAnim(FireLoopAnim, FireLoopAnimRate, TweenTime);

		PlayAmbientSound(AmbientFireSound);
    }

    function PlayFiring() {}
	function ServerPlayFiring() {}

    function EndState()
    {
        Weapon.AnimStopLooping();
        PlayAmbientSound(none);
        Weapon.PlayOwnedSound(FireEndSound,SLOT_None,AmbientFireVolume/127,,AmbientFireSoundRadius);
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

function DoFireEffect()
{
    local Vector StartProj, StartTrace, X,Y,Z;
    local Rotator Aim;
    local Vector HitLocation, HitNormal,FireLocation;
    local Actor Other;
    local int p, SpawnCount;
    local HealThrowerCloud FiredRockets[4];

    if ( (SpreadStyle == SS_Line) || (Load < 2) )
    {
		Super(KFShotgunFire).DoFireEffect();
        return;
    }

    Instigator.MakeNoise(1.0);
    Weapon.GetViewAxes(X,Y,Z);

    StartTrace = Instigator.Location + Instigator.EyePosition();
    StartProj = StartTrace + X*ProjSpawnOffset.X + Z*ProjSpawnOffset.Z;
    if ( !Weapon.WeaponCentered() )
        StartProj = StartProj + Weapon.Hand * Y*ProjSpawnOffset.Y;

    Other = Weapon.Trace(HitLocation, HitNormal, StartProj, StartTrace, false);
    if (Other != None)
    {
        StartProj = HitLocation;
    }

    Aim = AdjustAim(StartProj, AimError);

	SpawnCount = Max(1, int(Load));

	for ( p=0; p<SpawnCount; p++ )
	{
		Firelocation = StartProj - 2*((Sin(p*2*PI/MaxLoad)*8 - 7)*Y - (Cos(p*2*PI/MaxLoad)*8 - 7)*Z) - X * 8 * FRand();
		FiredRockets[p] = HealThrowerCloud(SpawnProjectile(FireLocation, Aim));
	}
}

function float MaxRange()
{
    return 1500;
}

defaultproperties
{
     KickMomentum=(X=0,Z=0)
     ProjPerFire=1
     bAttachSmokeEmitter=True
     TransientSoundVolume=1
     TransientSoundRadius=500
	 FireAimedAnim=Fire_Iron
	 FireForce="AssaultRifleFire"
     FireSound=none
     FireSoundRef="none"
     FireRate=0.07
     AmmoClass=Class'HealThrowerAmmo'
	 ProjectileClass=Class'HealThrowerCloud'
     BotRefireRate=0.070000
     aimerror=0
     Spread=0
     FlashEmitterClass=Class'KFMod.KFFlameMuzzFlash'
     SpreadStyle=SS_Random
     ShakeOffsetMag=(X=0,Y=0,Z=0)
     ShakeRotMag=(X=0,Y=0,Z=0)
     ShakeRotRate=(X=0,Y=0,Z=0)
     ShakeOffsetRate=(X=0,Y=0,Z=0)
     ProjSpawnOffset=(X=65,Y=10,Z=-15)
     MaxLoad=3
     EffectiveRange=1500
     bSplashDamage=true
     bRecommendSplashDamage=true
     maxVerticalRecoilAngle=300
     maxHorizontalRecoilAngle=150
     bWaitForRelease=false
     FireEndSound=Sound'KF_FlamethrowerSnd.FT_Fire1Shot'
     FireEndSoundRef="KF_FlamethrowerSnd.FT_Fire1Shot"
     NoAmmoSound=Sound'KF_FlamethrowerSnd.FT_DryFire'
     NoAmmoSoundRef="KF_FlamethrowerSnd.FT_DryFire"
     AmbientFireSoundRadius=500
     AmbientFireSound=Sound'KF_FlamethrowerSnd.FireLoop'
     AmbientFireSoundRef="KF_FlamethrowerSnd.FireLoop"
     AmbientFireVolume=255
     FireLoopAnim=Fire
     FireEndAnim=Idle
     FireAnim=
     //FireAnim=''
     bRandomPitchFireSound=false
}
