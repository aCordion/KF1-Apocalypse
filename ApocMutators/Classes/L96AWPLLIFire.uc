class L96AWPLLIFire extends KFFire;

function DoTrace(Vector Start, Rotator Dir)
{
	local Vector X,Y,Z, End, HitLocation, HitNormal, ArcEnd;
	local Actor Other;
	local byte HitCount,HCounter;
	local float HitDamage;
	local array<int>	HitPoints;
	local KFPawn HitPawn;
	local array<Actor>	IgnoreActors;
	local Actor DamageActor;
	local int i;

	MaxRange();

	Weapon.GetViewAxes(X, Y, Z);
	if ( Weapon.WeaponCentered() )
	{
		ArcEnd = (Instigator.Location + Weapon.EffectOffset.X * X + 1.5 * Weapon.EffectOffset.Z * Z);
	}
	else
	{
		ArcEnd = (Instigator.Location + Instigator.CalcDrawOffset(Weapon) + Weapon.EffectOffset.X * X +
		Weapon.Hand * Weapon.EffectOffset.Y * Y + Weapon.EffectOffset.Z * Z);
	}

	X = Vector(Dir);
	End = Start + TraceRange * X;
	HitDamage = DamageMax;
	While( (HitCount++)<4 )
	{
		DamageActor = none;

		Other = Instigator.HitPointTrace(HitLocation, HitNormal, End, HitPoints, Start,, 1);
		if( Other==None )
		{
			Break;
		}
		else if( Other==Instigator || Other.Base == Instigator )
		{
			IgnoreActors[IgnoreActors.Length] = Other;
			Other.SetCollision(false);
			Start = HitLocation;
			Continue;
		}

		if( ExtendedZCollision(Other)!=None && Other.Owner!=None )
		{
			IgnoreActors[IgnoreActors.Length] = Other;
			IgnoreActors[IgnoreActors.Length] = Other.Owner;
			Other.SetCollision(false);
			Other.Owner.SetCollision(false);
			DamageActor = Pawn(Other.Owner);
		}

		if ( !Other.bWorldGeometry && Other!=Level )
		{
			HitPawn = KFPawn(Other);

			if ( HitPawn != none )
			{
				// Hit detection debugging
				/*log("PreLaunchTrace hit "$HitPawn.PlayerReplicationInfo.PlayerName);
				HitPawn.HitStart = Start;
				HitPawn.HitEnd = End;*/
				if(!HitPawn.bDeleteMe)
					HitPawn.ProcessLocationalDamage(int(HitDamage), Instigator, HitLocation, Momentum*X,DamageType,HitPoints);

				// Hit detection debugging
				/*if( Level.NetMode == NM_Standalone)
					HitPawn.DrawBoneLocation();*/

				IgnoreActors[IgnoreActors.Length] = Other;
				IgnoreActors[IgnoreActors.Length] = HitPawn.AuxCollisionCylinder;
				Other.SetCollision(false);
				HitPawn.AuxCollisionCylinder.SetCollision(false);
				DamageActor = Other;
			}
			else
			{
				if( KFMonster(Other)!=None )
				{
					IgnoreActors[IgnoreActors.Length] = Other;
					Other.SetCollision(false);
					DamageActor = Other;
				}
				else if( DamageActor == none )
				{
					DamageActor = Other;
				}
				Other.TakeDamage(int(HitDamage), Instigator, HitLocation, Momentum*X, DamageType);
			}
			if( (HCounter++)>=4 || Pawn(DamageActor)==None )
			{
				Break;
			}
			HitDamage*=0.7;
			Start = HitLocation;
		}
		else if ( HitScanBlockingVolume(Other)==None )
		{
			if( KFWeaponAttachment(Weapon.ThirdPersonActor)!=None )
			KFWeaponAttachment(Weapon.ThirdPersonActor).UpdateHit(Other,HitLocation,HitNormal);
			Break;
		}
	}

	// Turn the collision back on for any actors we turned it off
	if ( IgnoreActors.Length > 0 )
	{
		for (i=0; i<IgnoreActors.Length; i++)
		{
			if(IgnoreActors[i]!=None) //Flame
				IgnoreActors[i].SetCollision(true);
		}
	}
}

function FlashMuzzleFlash()
{
    super(InstantFire).FlashMuzzleFlash();
}
defaultproperties
{
	FireAimedAnim="Fire_Iron"
	RecoilRate=0.200000
	maxVerticalRecoilAngle=800
	maxHorizontalRecoilAngle=250
	ShellEjectClass=Class'ApocMutators.KFShellEjectL96AWPLLI'
	ShellEjectBoneName="Ejector_LLIePLLIeHb"
	StereoFireSound=Sound'L96AWPLLI_A.L96AWPLLI_Snd.L96AWPLLI_shot'
	DamageType=Class'ApocMutators.DamTypeL96AWPLLI'
	DamageMax=700
	Momentum=20000.000000
	bPawnRapidFireAnim=True
	bWaitForRelease=True
	TransientSoundVolume=3.800000
	FireLoopAnim="Fire"
	TweenTime=0.025000
	FireSound=Sound'L96AWPLLI_A.L96AWPLLI_Snd.L96AWPLLI_shot'
	NoAmmoSound=Sound'L96AWPLLI_A.L96AWPLLI_Snd.L96AWPLLI_empty'
	FireForce="AssaultRifleFire"
	FireRate=1.400000
	AmmoClass=Class'ApocMutators.L96AWPLLIAmmo'
	AmmoPerFire=1
	ShakeRotMag=(X=100.000000,Y=100.000000,Z=500.000000)
	ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
	ShakeRotTime=2.000000
	ShakeOffsetMag=(X=20.000000,Y=3.000000,Z=6.000000)
	ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
	ShakeOffsetTime=2.000000
	BotRefireRate=0.650000
	FlashEmitterClass=Class'ROEffects.MuzzleFlash1stKar'
	aimerror=0.000000
	Spread=0.007000
	SpreadStyle=SS_Random
}
