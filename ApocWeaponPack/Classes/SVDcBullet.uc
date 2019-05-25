class SVDcBullet extends ShotgunBullet;

simulated function PostBeginPlay()
{
	Super(Projectile).PostBeginPlay();

	Velocity = Speed * Vector(Rotation); // starts off slower so combo can be done closer

    SetTimer(0.4, false);

    /*if ( Level.NetMode != NM_DedicatedServer )
    {
        if ( !PhysicsVolume.bWaterVolume )
        {

            Trail = Spawn(class'KFTracer',self);
            Trail.Lifespan = Lifespan;
        }
    }*/
}

defaultproperties
{
     HeadShotDamageMult=8.000000
     ImpactEffect=Class'ROEffects.ROBulletHitEffect'
     Speed=14000.000000
     MaxSpeed=14000.000000
     bSwitchToZeroCollision=True
     Damage=250.000000 //120.000000 //kyan
     DamageRadius=0.000000
     MomentumTransfer=50000.000000
     MyDamageType=Class'DamTypeSVDc'
     ExplosionDecal=Class'KFMod.ShotgunDecal'
     DrawType=DT_StaticMesh
     CullDistance=3000.000000
     LifeSpan=3.000000
     Style=STY_Alpha
}
