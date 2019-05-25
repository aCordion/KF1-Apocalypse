class L96AWPLLIFireB extends KFMeleeFire;

var() int MeleeDamageNew;
var float WideDamageMinHitAngleNew;
var float LastClickTime;

//Скопировано из KFMeleeFire, в конце переменная ChopSlowRate заменена на 0.2
simulated event ModeDoFire()
{
	local float Rec;

	if (!AllowFire())
		return;

	Rec = GetFireSpeed();
	SetTimer(DamagedelayMin/Rec, False);
	FireRate = default.FireRate/Rec;
	FireAnimRate = default.FireAnimRate*Rec;
	ReloadAnimRate = default.ReloadAnimRate*Rec;

	if (MaxHoldTime > 0.0)
		HoldTime = FMin(HoldTime, MaxHoldTime);

	// server
	if (Weapon.Role == ROLE_Authority)
	{
		Weapon.ConsumeAmmo(ThisModeNum, Load);
		DoFireEffect();

		HoldTime = 0;   // if bot decides to stop firing, HoldTime must be reset first
		if ( (Instigator == None) || (Instigator.Controller == None) )
			return;

		if ( AIController(Instigator.Controller) != None )
			AIController(Instigator.Controller).WeaponFireAgain(BotRefireRate, true);

		Instigator.DeactivateSpawnProtection();
	}

	// client
	if (Instigator.IsLocallyControlled())
	{
		ShakeView();
		PlayFiring();
		FlashMuzzleFlash();
		StartMuzzleSmoke();
		ClientPlayForceFeedback(FireForce);
	}
	else // server
		ServerPlayFiring();

	Weapon.IncrementFlashCount(ThisModeNum);

	// set the next firing time. must be careful here so client and server do not get out of sync
	if (bFireOnRelease)
	{
		if (bIsFiring)
			NextFireTime += MaxHoldTime + FireRate;
		else
			NextFireTime = Level.TimeSeconds + FireRate;
	}
	else
	{
		NextFireTime += FireRate;
		NextFireTime = FMax(NextFireTime, Level.TimeSeconds);
	}

	Load = AmmoPerFire;
	HoldTime = 0;

	if (Instigator.PendingWeapon != Weapon && Instigator.PendingWeapon != None)
	{
		bIsFiring = false;
		Weapon.PutDown();
	}

	if( Weapon.Owner != none && Weapon.Owner.Physics != PHYS_Falling )
	{
		Weapon.Owner.Velocity.x *= 0.2;
		Weapon.Owner.Velocity.y *= 0.2;
	}
}

simulated function Timer()
{
	local Actor HitActor;
	local vector StartTrace, EndTrace, HitLocation, HitNormal;
	local rotator PointRot;
	local int MyDamage;
	local bool bBackStabbed;
	local Pawn Victims;
	local vector dir, lookdir;
	local float DiffAngle, VictimDist;

	MyDamage = MeleeDamageNew;
	if( !KFWeapon(Weapon).bNoHit )
	{
		MyDamage = MeleeDamageNew;
		StartTrace = Instigator.Location + Instigator.EyePosition();

		if( Instigator.Controller!=None && PlayerController(Instigator.Controller)==None && Instigator.Controller.Enemy!=None )
		{
			PointRot = rotator(Instigator.Controller.Enemy.Location-StartTrace);
		}
		else
		{
			PointRot = Instigator.GetViewRotation();
		}

		EndTrace = StartTrace + vector(PointRot)*weaponRange;
		HitActor = Instigator.Trace( HitLocation, HitNormal, EndTrace, StartTrace, true);

		//Instigator.ClearStayingDebugLines();
		//Instigator.DrawStayingDebugLine( StartTrace, EndTrace,0, 255, 0);

		if (HitActor!=None)
		{
			ImpactShakeView();

			if( HitActor.IsA('ExtendedZCollision') && HitActor.Base != none &&
				HitActor.Base.IsA('KFMonster') )
			{
				HitActor = HitActor.Base;
			}

/* 			if ( (HitActor.IsA('KFMonster') || HitActor.IsA('KFHumanPawn')) && KFWeapon(Weapon).BloodyMaterial!=none )
			{
				Weapon.Skins[KFWeapon(Weapon).BloodSkinSwitchArray] = KFWeapon(Weapon).BloodyMaterial;
				Weapon.texture = Weapon.default.Texture;
			} */

			if( Level.NetMode==NM_Client )
			{
				return;
			}

			if( HitActor.IsA('Pawn') && !HitActor.IsA('Vehicle')
			&& (Normal(HitActor.Location-Instigator.Location) dot vector(HitActor.Rotation))>0 ) // Fixed in Balance Round 2
			{
				bBackStabbed = true;

				MyDamage*=2;
			}

			if( (KFMonster(HitActor)!=none) )
			{

				KFMonster(HitActor).bBackstabbed = bBackStabbed;

				HitActor.TakeDamage(MyDamage, Instigator, HitLocation, vector(PointRot), hitDamageClass) ;

				if(MeleeHitSounds.Length > 0)
				{
					Weapon.PlaySound(MeleeHitSounds[Rand(MeleeHitSounds.length)],SLOT_None,MeleeHitVolume,,,,false);
				}

				if(VSize(Instigator.Velocity) > 300 && KFMonster(HitActor).Mass <= Instigator.Mass)
				{
					KFMonster(HitActor).FlipOver();
				}

			}
			else
			{
				HitActor.TakeDamage(MyDamage, Instigator, HitLocation, vector(PointRot), hitDamageClass) ;
				Spawn(HitEffectClass,,, HitLocation, rotator(HitLocation - StartTrace));
			}
			Spawn(class'L96AWPLLIPush',,, HitLocation, PointRot);//Flame
		}

		if( WideDamageMinHitAngleNew > 0 )
		{
			foreach Weapon.VisibleCollidingActors( class 'Pawn', Victims, (weaponRange * 2), StartTrace ) //, RadiusHitLocation
			{
				if( (HitActor != none && Victims == HitActor) || Victims.Health <= 0 )
				{
					continue;
				}

				if( Victims != Instigator )
				{
					VictimDist = VSizeSquared(Instigator.Location - Victims.Location);

					if( VictimDist > (((weaponRange * 1.1) * (weaponRange * 1.1)) + (Victims.CollisionRadius * Victims.CollisionRadius)) )
					{
						continue;
					}

					lookdir = Normal(Vector(Instigator.GetViewRotation()));
					dir = Normal(Victims.Location - Instigator.Location);

					DiffAngle = lookdir dot dir;

					if( DiffAngle > WideDamageMinHitAngleNew )
					{
						Victims.TakeDamage(MyDamage*DiffAngle, Instigator, (Victims.Location + Victims.CollisionHeight * vect(0,0,0.7)), vector(PointRot), hitDamageClass) ;

						if(MeleeHitSounds.Length > 0)
						{
							Victims.PlaySound(MeleeHitSounds[Rand(MeleeHitSounds.length)],SLOT_None,MeleeHitVolume,,,,false);
						}
					}
				}
			}
		}
	}
}

simulated function bool AllowFire()
{
	if(KFWeapon(Weapon).bIsReloading)
		return false;
	if(KFPawn(Instigator).SecondaryItem!=none)
		return false;
	if(KFPawn(Instigator).bThrowingNade)
		return false;
	if ( KFWeapon(Weapon).bAimingRifle )
		return false;
	/*if(KFWeapon(Weapon).MagAmmoRemaining < 1)
	{
		if( Level.TimeSeconds - LastClickTime>FireRate )
		{
			LastClickTime = Level.TimeSeconds;
		}

		if( AIController(Instigator.Controller)!=None )
			KFWeapon(Weapon).ReloadMeNow();
		return false;
	}*/

	return Super.AllowFire();
}

simulated function DestroyEffects()
{
	/*super.DestroyEffects();

	if (ShellEjectEmitter != None)
		ShellEjectEmitter.Destroy();*/
}

simulated function InitEffects()
{
	/*super.InitEffects();

	// don't even spawn on server
	if ( (Level.NetMode == NM_DedicatedServer) || (AIController(Instigator.Controller) != None) )
		return;
	if ( (ShellEjectClass != None) && ((ShellEjectEmitter == None) || ShellEjectEmitter.bDeleteMe) )
	{
		ShellEjectEmitter = Weapon.Spawn(ShellEjectClass);
		Weapon.AttachToBone(ShellEjectEmitter, ShellEjectBoneName);
	}

	if ( FlashEmitter != None )
		Weapon.AttachToBone(FlashEmitter, KFWeapon(Weapon).FlashBoneName);*/
}

function DrawMuzzleFlash(Canvas Canvas)
{
	/*super.DrawMuzzleFlash(Canvas);
	// Draw smoke first
	if (ShellEjectEmitter != None )
	{
		Canvas.DrawActor( ShellEjectEmitter, false, false, Weapon.DisplayFOV );
	}*/
}

function FlashMuzzleFlash()
{
	/*super.FlashMuzzleFlash();

	if (ShellEjectEmitter != None)
	{
		//ShellEjectEmitter.SpawnParticle(1);//Trigger(Weapon, Instigator);
		ShellEjectEmitter.Trigger(Weapon, Instigator);
	}*/
}

defaultproperties
{
	MeleeDamageNew=140
	WideDamageMinHitAngleNew=0.700000
	ProxySize=0.150000
	weaponRange=65.000000
	DamagedelayMin=0.330000
	DamagedelayMax=0.330000
	hitDamageClass=Class'ApocMutators.DamTypeL96AWPLLIm'
	MeleeHitSounds(0)=Sound'KF_AxeSnd.AxeImpactBase.Axe_HitFlesh4'
	HitEffectClass=Class'ApocMutators.L96AWPLLIHitEffect'
	bWaitForRelease=True
	FireAnim="MeleeAttack"
	FireRate=1.100000
	BotRefireRate=1.100000
}