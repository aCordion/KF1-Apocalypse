Class CrossbowProjectile extends HL2Projectile;

var array<Pawn> PendingVictims;
var vector PendingHitSpot;

function PostBeginPlay()
{
	Velocity = vector(Rotation)*Speed;
}
simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	if( Other!=Instigator && KFPawn(Other)==None && ROBulletWhipAttachment(Other)==None )
	{
		if( ExtendedZCollision(Other)!=None )
			Other = Other.Owner;
		if ( Level.NetMode!=NM_Client && (Instigator==None || Instigator.Controller==None) )
			Other.SetDelayedDamageInstigatorController(InstigatorController);
		Other.TakeDamage(Damage,Instigator,HitLocation,MomentumTransfer*Normal(Velocity),MyDamageType);
		
		if( Vehicle(Other)!=None )
			Explode(HitLocation,Normal(-Velocity));
		else if( Pawn(Other)!=None )
		{
			if( Level.NetMode!=NM_DedicatedServer )
			{
				PlaySound(Sound'Bolt_HitBody');
				PendingVictims[PendingVictims.Length] = Pawn(Other);
				PendingHitSpot = HitLocation;
				SetTimer(0.1,false);
			}
			Damage = Damage>>1; // Half the damage for next hit.
			if( Damage<100 )
				Destroy();
		}
	}
}
simulated function Explode(vector HitLocation, vector HitNormal)
{
	if( Level.NetMode!=NM_DedicatedServer )
	{
		Spawn(Class'ROBulletHitEffect',,,HitLocation,Rotator(-HitNormal));
		PlaySound(ImpactSound);
	}
	if( Physics==PHYS_Projectile && Abs(HitNormal Dot Normal(Velocity))<0.4f ) // Can bounce off the wall once.
	{
		bOrientToVelocity = (Level.NetMode!=NM_DedicatedServer);
		Damage -= (Damage>>2); // Reduce by a quarter of damage.
		Velocity = MirrorVectorByNormal(Velocity,HitNormal);
		SetPhysics(PHYS_Falling);
		return;
	}
	if( Level.NetMode==NM_DedicatedServer )
	{
		Destroy();
		return;
	}
	bOrientToVelocity = false;
	LifeSpan = 4.f;
	RemoteRole = ROLE_None;
	SetPhysics(PHYS_None);
	SetCollision(false);
	Skins.Length = 1;
	Skins[0] = Texture'v_rebar';
}
simulated function Timer()
{
	local int i;
	local vector X,HL,HN;
	
	// Attempt to pin body onto wall
	X = vector(Rotation);
	for( i=0; i<PendingVictims.Length; ++i )
	{
		if( PendingVictims[i]!=None && PendingVictims[i].Health<=0 && PendingVictims[i].Physics==PHYS_KarmaRagdoll )
		{
			if( Trace(HL,HN,Location+X*1000.f,Location-X*10.f,False)!=None )
				Spawn(Class'BodyAttacher',PendingVictims[i],,PendingHitSpot).AttachEndPoint = HL-HN*4;
		}
	}
	PendingVictims.Length = 0;
}

defaultproperties
{
     Speed=5000.000000
     MaxSpeed=5000.000000
     Damage=500.000000
     MomentumTransfer=25000.000000
     MyDamageType=Class'ApocMutators.DamTypeCrossbow'
     ImpactSound=Sound'HL2WeaponsS.Crossbow.Hit1'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'HL2WeaponsA.Projectile.Crossbow_Bolt'
     DrawScale=1.300000
     TransientSoundVolume=1.500000
     TransientSoundRadius=350.000000
     bBounce=True
}
