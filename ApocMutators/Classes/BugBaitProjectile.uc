Class BugBaitProjectile extends HL2Projectile;

simulated function PostBeginPlay()
{
	Velocity = vector(Rotation)*Speed;
	SetRotation(RotRand(true));
}

simulated function Landed( vector HN )
{
	HitWall(HN,Base);
}
simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	if ( Other!=Instigator && ExtendedZCollision(Other)==None && ROBulletWhipAttachment(Other)==None )
		HitWall(HitLocation,Other);
}
simulated function HitWall(vector HitNormal, actor Wall)
{
	if( Level.NetMode!=NM_DedicatedServer )
	{
		PlaySound(ImpactSound,SLOT_Pain);
		Spawn(Class'FX_BugBaitHitFX');
	}
	if( Level.NetMode!=NM_Client )
	{
		if( Pawn(Wall)!=None && Pawn(Wall).Health>0 )
			Class'ZEDAttractInv'.Static.SetTargeting(Level,Location,true,Pawn(Wall));
		else Class'ZEDAttractInv'.Static.SetTargeting(Level,Location,true,,Location);
	}
	Destroy();
}

defaultproperties
{
     Speed=800.000000
     MaxSpeed=1200.000000
     DamageRadius=1500.000000
     ImpactSound=SoundGroup'HL2WeaponsS.BugBait.BugBait_Impact'
     Physics=PHYS_Falling
     LifeSpan=10.000000
     Mesh=SkeletalMesh'HL2WeaponsA.HL_BugBait3rd'
     DrawScale=1.300000
     AmbientGlow=25
     bUnlit=False
     TransientSoundVolume=1.500000
     TransientSoundRadius=400.000000
}
