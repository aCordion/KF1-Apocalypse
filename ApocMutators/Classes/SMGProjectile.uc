Class SMGProjectile extends HL2Projectile;

var FX_SMGProjTrail MyTrail;
var() Sound UWSound;

simulated function PostBeginPlay()
{
	if( Level.NetMode!=NM_DedicatedServer )
	{
		if( MyTrail==None )
			MyTrail = Spawn(Class'FX_SMGProjTrail',Self);
		RotationRate = RotRand(True);
	}
		
	if( Level.NetMode!=NM_Client )
		Velocity = vector(Rotation)*Speed;
}
simulated function Landed( vector HN )
{
	Explode(Location,HN);
}
simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	if ( Other!=Instigator && KFPawn(Other)==None && ROBulletWhipAttachment(Other)==None )
		Explode(HitLocation,Normal(HitLocation-Other.Location));
}
simulated function Explode(vector HitLocation, vector HitNormal)
{
	HurtRadius(Damage,DamageRadius,MyDamageType,MomentumTransfer,HitLocation);
	if ( Role == ROLE_Authority )
		MakeNoise(2.0);
	if( Level.NetMode!=NM_DedicatedServer )
	{
		Spawn(Class'GrenadeExplosion',,,HitLocation).RemoteRole = ROLE_None;
		if( PhysicsVolume!=None && PhysicsVolume.bWaterVolume )
			PlaySound(UWSound);
		else PlaySound(ImpactSound);
	}
	Destroy();
}
simulated function Destroyed()
{
	if( MyTrail!=None )
	{
		MyTrail.LifeSpan = 0.5;
		MyTrail.Kill();
	}
}

defaultproperties
{
     UWSound=SoundGroup'HL2WeaponsS.Generic.UWExplosion_G'
     Speed=1600.000000
     Damage=500.000000
     DamageRadius=500.000000
     MomentumTransfer=15000.000000
     MyDamageType=Class'ApocMutators.DamTypeSMGGrenade'
     ImpactSound=SoundGroup'HL2WeaponsS.Generic.Explosion_G'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'HL2WeaponsA.Projectile.SMGGrenade'
     Physics=PHYS_Falling
     DrawScale=1.400000
     TransientSoundVolume=1.500000
     TransientSoundRadius=400.000000
}
