//=============================================================================
// Shotgun Bullet
//=============================================================================
class ShotgunBulletDK extends ShotgunBullet;

var		bool		bInfinitePenetration,bInfiniteRebound;
var		int			Penetrations,Rebounds,MaxRebounds,MinRebounds;
var		float		ReboundDamageReduction,ReboundSpeedReduction,RandReboundChance,RandReboundRate;
var		float		DampenFactor,DampenFactorParallel;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	Penetrations = MaxPenetrations;
	Rebounds = MinRebounds + int(FRand() * (MaxRebounds - MinRebounds));
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
    local vector X;
	local Vector TempHitLocation, HitNormal;
	local array<int>	HitPoints;
    local KFPawn HitPawn;

	if ( !Other.bBlockHitPointTraces  )
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
	bInfinitePenetration = false
	MaxRebounds = 1
	MinRebounds = 1
	HeadShotDamageMult = 0.5
    LifeSpan = 0.7
	ReboundDamageReduction = 0.40
	ReboundSpeedReduction = 2.30
	RandReboundChance = 0.79
	RandReboundRate = 0.15
	DampenFactor=0.05
    DampenFactorParallel=0.03
}
