class M202BackBurnBackProj extends ShotgunBullet;

var PanzerfaustTrail SmokeTrail;
var		bool		bInfinitePenetration,bInfiniteRebound;
var		int			Penetrations,Rebounds,MaxRebounds,MinRebounds;
var		float		ReboundDamageReduction,ReboundSpeedReduction,RandReboundChance,RandReboundRate;
var		float		DampenFactor,DampenFactorParallel;
var			Float				BackSpeedCoef;

simulated function PostBeginPlay()
{
	local rotator SmokeRotation;
	//Super.PostBeginPlay();

	Penetrations = MaxPenetrations;
	Rebounds = MinRebounds + int(FRand() * (MaxRebounds - MinRebounds));


	Velocity = Speed * Vector(Rotation); // starts off slower so combo can be done closer

    SetTimer(0.2, false);

    if ( Level.NetMode != NM_DedicatedServer )
    {
        if ( !PhysicsVolume.bWaterVolume )
        {

//        SmokeTrail = Spawn(class'PanzerfaustTrail',self);
	SmokeTrail = Spawn(class'M202PanzerfaustTrail_BackBurnTrail',self);
//	SmokeTrail = Spawn(class'TestFlare_green',self);
        SmokeTrail.SetBase(self);
        SmokeRotation.Pitch = 32768;
        SmokeTrail.SetRelativeRotation(SmokeRotation);
        }
    }

//	Super.PostBeginPlay();

}

function Tick( float DT )
{
	/*local Vector NewVelocity;
	local float Z_Size;*/

	Speed=Speed*BackSpeedCoef;
	/*if (Speed<default.Speed)
	{
		Z_Size=VSize(Velocity);
		NewVelocity = Normal(Normal(Velocity) + RotateDir*RotateCoef);
		Velocity = NewVelocity*Z_Size;
	}*/
    if( Speed < (default.Speed * 0.04) )
    {
        Destroy();
    }
}

simulated function Destroyed()
{
	if ( SmokeTrail != None )
	{
		SmokeTrail.HandleOwnerDestroyed();
	}

/*	if( !bHasExploded && !bHidden && !bDud )
		Explode(Location,vect(0,0,1));
	if( bHidden && !bDisintegrated )
        Disintegrate(Location,vect(0,0,1));*/

    Super.Destroyed();
}


simulated function ProcessTouch (Actor Other, vector HitLocation)
{
    local vector X;
	local Vector TempHitLocation, HitNormal;
	local array<int>	HitPoints;
    local KFPawn HitPawn;

//	if ( !Other.bBlockHitPointTraces  )
	if ( Other == none || Other == Instigator || Other.Base == Instigator || !Other.bBlockHitPointTraces  )
		return;

    X = Vector(Rotation);

 	if( ROBulletWhipAttachment(Other) != none )
	{
        if(!Other.Base.bDeleteMe)
        {
	        Other = Instigator.HitPointTrace(TempHitLocation, HitNormal, HitLocation + (200 * X), HitPoints, HitLocation,, 1);

			if( Other == none || HitPoints.Length == 0 )
				return;

			HitPawn = KFPawn(Other);

            if (Role == ROLE_Authority)
            {
    	    	if ( HitPawn != none )
    	    	{
     				// Hit detection debugging
    				/*log("Bullet hit "$HitPawn.PlayerReplicationInfo.PlayerName);
    				HitPawn.HitStart = HitLocation;
    				HitPawn.HitEnd = HitLocation + (65535 * X);*/

                    if( !HitPawn.bDeleteMe )
                    	HitPawn.ProcessLocationalDamage(Damage, Instigator, TempHitLocation, MomentumTransfer * Normal(Velocity), MyDamageType,HitPoints);


                    // Hit detection debugging
    				//if( Level.NetMode == NM_Standalone)
    				//	HitPawn.DrawBoneLocation();
    	    	}
    		}
		}
	}
    else
    {
        if (Pawn(Other) != none && Pawn(Other).IsHeadShot(HitLocation, X, 1.0))
        {
            Pawn(Other).TakeDamage(Damage * (0.25 + 1.75 * LifeSpan/default.LifeSpan) * HeadShotDamageMult * 0.6, Instigator, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType);
        }
        else
        {
            Other.TakeDamage(Damage * (0.25 + 1.75 * LifeSpan/default.LifeSpan) * 0.6, Instigator, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType);
        }
    }

	if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != none && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != none )
	{
   		PenDamageReduction = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.static.GetShotgunPenetrationDamageMulti(KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo),default.PenDamageReduction);
	}
	else
	{
   		PenDamageReduction = default.PenDamageReduction;
   	}

   	Damage *= PenDamageReduction; // Keep going, but lose effectiveness each time.

	Penetrations--;

    // if we've struck through more than the max number of foes, destroy.
    if ( Penetrations < 0 && !bInfinitePenetration )
    {
        Destroy();
    }

    speed = VSize(Velocity);

    if( Speed < (default.Speed * 0.05) )
    {
        Destroy();
    }
}

simulated singular function HitWall(vector HitNormal, actor Wall)
{
	local Vector VNorm;

    if ( Role == ROLE_Authority )
	{
		if ( !Wall.bStatic && !Wall.bWorldGeometry )
		{
			if ( Instigator == None || Instigator.Controller == None )
				Wall.SetDelayedDamageInstigatorController( InstigatorController );
			Wall.TakeDamage( Damage, instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);
			if (DamageRadius > 0 && Vehicle(Wall) != None && Vehicle(Wall).Health > 0)
				Vehicle(Wall).DriverRadiusDamage(Damage, DamageRadius, InstigatorController, MyDamageType, MomentumTransfer, Location);
			HurtWall = Wall;
		}
		MakeNoise(1.0);
	}

	Rebounds--;

	if ( Rebounds < 0 && !bInfiniteRebound )
	{
		Explode(Location + ExploWallOut * HitNormal, HitNormal);

		if (Trail != None)
		{
			Trail.mRegen=False;
			Trail.SetPhysics(PHYS_None);
		}

		Destroy();
	}
	else
	{
		VNorm = (Velocity dot HitNormal) * HitNormal;
		Velocity = -VNorm * DampenFactor + (Velocity - VNorm) * DampenFactorParallel;
		if ( RandReboundChance > FRand() )
		{
			Velocity = VSize(Velocity) * ( normal(Velocity) + VRand() * RandReboundRate );
		}
		Damage *= ReboundDamageReduction;
		Velocity *= ReboundSpeedReduction;
		Speed = VSize(Velocity);
	}

	if (ImpactEffect != None && (Level.NetMode != NM_DedicatedServer))
	{
			Spawn(ImpactEffect,,, Location, rotator(-HitNormal));
	}

	HurtWall = None;
}

defaultproperties
{
     BackSpeedCoef=0.950000
     MaxRebounds=2
     MinRebounds=1
     ReboundDamageReduction=0.900000
     ReboundSpeedReduction=1.300000
     RandReboundChance=0.790000
     RandReboundRate=0.150000
     DampenFactor=0.050000
     DampenFactorParallel=0.030000
     LifeSpan=0.900000
     DamageAtten=1.000000
     HeadShotDamageMult=1.000000
     ImpactEffect=Class'KFMod.AxeHitEffect'
     Speed=1000.000000
     ExplosionDecal=Class'ROEffects.RocketMarkDirt'
     MyDamageType=Class'DamTypeBackBurn'
     bHidden=False
     DrawType=DT_None
}