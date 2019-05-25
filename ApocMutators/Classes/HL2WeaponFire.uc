Class HL2WeaponFire extends WeaponFire
	abstract;

var(TraceFire) class<DamageType> DamageType;
var(TraceFire) int DamageMin, DamageMax;
var(TraceFire) float TraceRange;
var(TraceFire) float Momentum,DamageKnockForce;

var(ProjectileFire) int ProjPerFire;
var(ProjectileFire) Vector ProjSpawnOffset;

var() float PreFireTimeSec,PostFireTimeSec;
var() sound StereoFireSound,PreFireStereoSound,PreFireSound;
var() array<name> RandFireAnims;
var() name FlashEmitterBone;
var() byte NumPenetrates;
var transient float LastClickTime;
var() bool bUsesAmmoMag,bCanPenetrate,bUseTraceFire,bCanInteruptReload,bAutoReloadAfterFire,bCanHitTeamMates;
var bool bNeedsPostReload;

simulated function InitEffects()
{
    // don't even spawn on server
    if ( (Level.NetMode == NM_DedicatedServer) || (AIController(Instigator.Controller) != None) )
		return;
    if ( (FlashEmitterClass != None) && ((FlashEmitter == None) || FlashEmitter.bDeleteMe) )
    {
        FlashEmitter = Weapon.Spawn(FlashEmitterClass);
		Weapon.AttachToBone(FlashEmitter, FlashEmitterBone);
    }
}
simulated function DrawMuzzleFlash(Canvas Canvas);

simulated function SetTimer( float NewTimerRate, bool bLoop )
{
	if( TimerInterval!=0 ) // Must do this due to Epic's programming error when you call SetTimer during Timer event.
	{
		bTimerLoop = (NewTimerRate>0);
		TimerInterval = NewTimerRate;
	}
	else
	{
		bTimerLoop = bLoop;
		TimerInterval = NewTimerRate;
		NextTimerPop = Level.TimeSeconds + TimerInterval;
	}
}

final function float GetFireSpeed()
{
	if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != none && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != none )
		return KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.Static.GetFireSpeedMod(KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo), Weapon);
	return 1;
}
simulated function ModeDoFire()
{
	local float Rec,Rate;

	if (!AllowFire())
		return;

	Spread = Default.Spread;

	Rec = GetFireSpeed();
	FireAnimRate = Default.FireAnimRate*Rec;
	PreFireAnimRate = Default.PreFireAnimRate*Rec;

	if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != none && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != none )
		Spread *= KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.Static.ModifyRecoilSpread(KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo), self, Rec);

	if (MaxHoldTime > 0.0)
		HoldTime = FMin(HoldTime, MaxHoldTime);
		
	bNeedsPostReload = (bAutoReloadAfterFire && Weapon.AmmoAmount(0)>1 && KFWeapon(Weapon).MagAmmoRemaining<=1);

	// server
	if (Weapon.Role == ROLE_Authority)
	{
		Weapon.ConsumeAmmo(ThisModeNum, AmmoPerFire);
		if( PreFireTimeSec==0.f )
			DoFireEffect();
		HoldTime = 0;	// if bot decides to stop firing, HoldTime must be reset first
		if ( (Instigator == None) || (Instigator.Controller == None) )
			return;

		if ( AIController(Instigator.Controller) != None )
			AIController(Instigator.Controller).WeaponFireAgain(BotRefireRate, true);

		Instigator.DeactivateSpawnProtection();
	}

	// client
	if (Instigator.IsLocallyControlled())
	{
		if( PreFireTimeSec==0 )
		{
			ShakeView();
			PlayFiring();
			FlashMuzzleFlash();
			StartMuzzleSmoke();
		}
		else PlayPreFire();
	}
	else // server
	{
		if( PreFireTimeSec==0 )
			ServerPlayFiring();
		else ServerPlayPreFire();
	}
	
	if( bNeedsPostReload )
	{
		if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo)!=none && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill!=none )
			Rate = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.Static.GetReloadSpeedModifier(KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo),KFWeapon(Weapon));
		else Rate = 1.f;
		Rate = KFWeapon(Weapon).Default.ReloadRate / Rate;
		SetTimer(FireRate/Rec,false);
	}

	// set the next firing time. must be careful here so client and server do not get out of sync
	if (bFireOnRelease)
	{
		if (bIsFiring)
			NextFireTime += MaxHoldTime + FireRate/Rec + Rate;
		else NextFireTime = Level.TimeSeconds + FireRate/Rec + Rate;
	}
	else
	{
		NextFireTime += (FireRate/Rec+Rate);
		NextFireTime = FMax(NextFireTime, Level.TimeSeconds);
	}

	if( PreFireTimeSec>0 )
		SetTimer(PreFireTimeSec/Rec,false);
	else if( !bUseTraceFire )
		Weapon.IncrementFlashCount(ThisModeNum);
	if( PostFireTimeSec>0 )
		SetTimer(PostFireTimeSec/Rec,false);

	Load = AmmoPerFire;
	HoldTime = 0;

	if (Instigator.PendingWeapon != Weapon && Instigator.PendingWeapon != None)
	{
		bIsFiring = false;
		Weapon.PutDown();
	}
}
simulated function Timer()
{
	local float Rate;

	if( bNeedsPostReload )
	{
		if( Weapon.Role == ROLE_Authority )
		{
			Instigator.SetAnimAction(KFWeapon(Weapon).WeaponReloadAnim);
			KFWeapon(Weapon).AddReloadedAmmo();
		}
		if( Instigator.IsLocallyControlled() && Instigator.IsFirstPerson() )
		{
			if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != none && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != none )
				Rate = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.Static.GetReloadSpeedModifier(KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo), KFWeapon(Weapon));
			else Rate = 1.0;
			Weapon.PlayAnim(KFWeapon(Weapon).ReloadAnim, KFWeapon(Weapon).ReloadAnimRate*Rate, 0.1);
		}
		return;
	}
	if( Weapon.Role == ROLE_Authority )
		DoFireEffect();

	if (Instigator.IsLocallyControlled())
	{
		ShakeView();
		PlayFiring();
		FlashMuzzleFlash();
		StartMuzzleSmoke();
	}
	else ServerPlayFiring();
	
	if( !bUseTraceFire )
		Weapon.IncrementFlashCount(ThisModeNum);
}

simulated function bool AllowFire()
{
	if( KFWeapon(Weapon).bIsReloading && (!bCanInteruptReload || KFWeapon(Weapon).MagAmmoRemaining<2) )
		return false;

	if( KFPawn(Instigator)!=None && (KFPawn(Instigator).SecondaryItem!=none || KFPawn(Instigator).bThrowingNade) )
		return false;

	if( bUsesAmmoMag && KFWeapon(Weapon).MagAmmoRemaining<1 )
	{
    	if( Level.TimeSeconds - LastClickTime>FireRate )
    		LastClickTime = Level.TimeSeconds;

		if( AIController(Instigator.Controller)!=None )
			KFWeapon(Weapon).ReloadMeNow();
		return false;
	}
	return Super.AllowFire();
}
simulated function PlayFiring()
{
	Weapon.PlayAnim(RandFireAnims[Rand(RandFireAnims.Length)], FireAnimRate, TweenTime);

	if( StereoFireSound!=none && Weapon.Instigator!=None && Weapon.Instigator.IsLocallyControlled()
		 && Weapon.Instigator.IsFirstPerson() )
		Weapon.PlaySound(StereoFireSound,SLOT_Interact,TransientSoundVolume * 0.85,,TransientSoundRadius,,false);
	else Weapon.PlaySound(FireSound,SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,,false);

	FireCount++;
}

simulated function PlayPreFire()
{
	if( PreFireAnim!='' )
		Weapon.PlayAnim(PreFireAnim, PreFireAnimRate, TweenTime);

	if( PreFireStereoSound!=none && Weapon.Instigator!=None && Weapon.Instigator.IsLocallyControlled()
		 && Weapon.Instigator.IsFirstPerson() )
		Weapon.PlaySound(PreFireStereoSound,SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,,false);
	else Weapon.PlaySound(PreFireSound,SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,,false);
}
function ServerPlayPreFire()
{
	Weapon.PlayOwnedSound(PreFireSound,SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,,false);
}

function float MaxRange()
{
	if( Instigator.Region.Zone.bDistanceFog )
		return FClamp(Instigator.Region.Zone.DistanceFogEnd, 6000, TraceRange);
	return TraceRange;
}

function DoFireEffect()
{
	Instigator.MakeNoise(1.0);

	// the to-hit trace always starts right in front of the eye
	if( bUseTraceFire )
		FireTrace();
	else FireProjectile();
}
function FireTrace()
{
	local Vector StartTrace;
	local Rotator R, Aim;
	local byte i;

	// the to-hit trace always starts right in front of the eye
	StartTrace = Instigator.Location + Instigator.EyePosition();
	Aim = AdjustAim(StartTrace, AimError);
	
	for( i=0; i<ProjPerFire; ++i )
	{
		R = rotator(vector(Aim) + VRand()*FRand()*Spread);
		DoTrace(StartTrace, R);
	}
}
function FireProjectile()
{
	local Vector StartProj, StartTrace, X,Y,Z;
	local Rotator R, Aim;
	local Vector HitLocation, HitNormal;
	local Actor Other;
	local int p;
	local float theta;

	Weapon.GetViewAxes(X,Y,Z);

	StartTrace = Instigator.Location + Instigator.EyePosition();// + X*Instigator.CollisionRadius;
	StartProj = StartTrace + X*ProjSpawnOffset.X;
	if ( !Weapon.WeaponCentered() )
		StartProj = StartProj + Weapon.Hand * Y*ProjSpawnOffset.Y + Z*ProjSpawnOffset.Z;

	// check if projectile would spawn through a wall and adjust start location accordingly
	Other = Weapon.Trace(HitLocation, HitNormal, StartProj, StartTrace, false);

	if (Other != None)
		StartProj = HitLocation;

	Aim = AdjustAim(StartProj, AimError);

	switch (SpreadStyle)
	{
	case SS_Random:
		X = Vector(Aim);
		for (p = 0; p < ProjPerFire; p++)
		{
			R.Yaw = Spread * (FRand()-0.5);
			R.Pitch = Spread * (FRand()-0.5);
			R.Roll = Spread * (FRand()-0.5);
			SpawnProjectile(StartProj, Rotator(X >> R));
		}
		break;
	case SS_Line:
		for (p = 0; p < ProjPerFire; p++)
		{
			theta = Spread*PI/32768*(p - float(ProjPerFire-1)/2.0);
			X.X = Cos(theta);
			X.Y = Sin(theta);
			X.Z = 0.0;
			SpawnProjectile(StartProj, Rotator(X >> Aim));
		}
		break;
	default:
		SpawnProjectile(StartProj, Aim);
	}
}
function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local Projectile p;

    if( ProjectileClass != None )
        p = Weapon.Spawn(ProjectileClass,,, Start, Dir);

    if( p == None )
        return None;

    p.Damage *= DamageAtten;
    return p;
}
simulated function vector GetFireStart(vector X, vector Y, vector Z)
{
    return Instigator.Location + Instigator.EyePosition() + X*ProjSpawnOffset.X + Y*ProjSpawnOffset.Y + Z*ProjSpawnOffset.Z;
}

function DoTrace(Vector Start, Rotator Dir)
{
	local Vector X,HitLocation,HitNormal,LastHL,LastHN;
	local Actor Other,LastHit;
	local int HitDamage;
	local byte HitCount;
	local float KnockBackForce;

	X = Vector(Dir);
	HitDamage = DamageMin+Rand(DamageMax-DamageMin);
	KnockBackForce = DamageKnockForce;
	
	foreach Instigator.TraceActors(Class'Actor',Other,HitLocation,HitNormal,Start+TraceRange*X,Start)
	{
		if( Other!=Instigator && (Other==Level || Other.bBlockActors || Other.bProjTarget || Other.bWorldGeometry)
			&& (KFPawn(Other)==None || bCanHitTeamMates) && KFBulletWhipAttachment(Other)==None )
		{
			if( ExtendedZCollision(Other)!=None )
				Other = Other.Owner;

			if( bCanPenetrate )
			{
				if( LastHit==Other ) // Don't let penetration double hit same enemy.
					continue;
				LastHit = Other;
				LastHL = HitLocation;
				LastHN = HitNormal;
			}
			else // Update hit effect
				KFWeaponAttachment(Weapon.ThirdPersonActor).UpdateHit(Other, HitLocation, HitNormal);

			if( KnockBackForce>0 && KFMonster(Other)!=None )
			{
				KFMonster(Other).AddVelocity(KnockBackForce*X/Other.Mass);
				KnockBackForce*=0.7f;
			}
			Other.TakeDamage(HitDamage, Instigator, HitLocation, Momentum*X,DamageType);

			if( bCanPenetrate )
			{
				if( ++HitCount>NumPenetrates || Pawn(Other)==None || Vehicle(Other)!=None )
					break;
				HitDamage = HitDamage>>1; // Cut damage in half for next hit.
			}
			else return;
		}
	}
	
	if( bCanPenetrate && LastHit!=None ) // Let the tracert penetrate through all hits.
		KFWeaponAttachment(Weapon.ThirdPersonActor).UpdateHit(LastHit, LastHL, LastHN);
	else KFWeaponAttachment(Weapon.ThirdPersonActor).UpdateHit(None, Start+TraceRange*X, X);
}

defaultproperties
{
     DamageType=Class'Engine.DamageType'
     TraceRange=15000.000000
     ProjPerFire=1
     FlashEmitterBone="Muz"
     bUsesAmmoMag=True
     bUseTraceFire=True
     TweenTime=0.000000
     NoAmmoSound=Sound'HL2WeaponsS.SMG.smg_empty'
     AmmoPerFire=1
}
