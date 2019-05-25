Class FX_LaserDot extends Emitter;

var rotator AimingTarget;
var RPGAttachment EffectOwner;

var transient vector Dir,HL,HN,Start,LaserTargetPosition;
var transient Actor HitActor;

replication
{
    reliable if( Role==ROLE_Authority )
        EffectOwner;
	reliable if( Role==ROLE_Authority && !bNetOwner )
        AimingTarget;
}

simulated final function bool TraceForHit()
{
	foreach TraceActors(Class'Actor',HitActor,HL,HN,Dir,Start)
	{
		if( HitActor!=EffectOwner.Instigator && (HitActor==Level || HitActor.bBlockActors || HitActor.bProjTarget
			|| HitActor.bWorldGeometry) && KFPawn(HitActor)==None && KFBulletWhipAttachment(HitActor)==None )
			return true;
	}
	return false;
}
simulated function Tick( float Delta )
{
	if( EffectOwner==None || EffectOwner.Instigator==None )
	{
		if( Level.NetMode==NM_Client )
			bHidden = true;
		else Destroy();
		return;
	}
	bHidden = false;

	if( Level.NetMode==NM_Client && !EffectOwner.Instigator.IsLocallyControlled() )
	{
		if( (Level.TimeSeconds-EffectOwner.LastRenderTime)<1.f )
			Start = EffectOwner.Location;
		else Start = EffectOwner.Instigator.Location+EffectOwner.Instigator.EyePosition();
	}
	else
	{
		AimingTarget = EffectOwner.Instigator.GetViewRotation();
		Start = EffectOwner.Instigator.Location+EffectOwner.Instigator.EyePosition();

		if( Level.NetMode==NM_DedicatedServer )
		{
			Dir = Start+vector(AimingTarget)*8000.f;
			
			if( TraceForHit() )
				LaserTargetPosition = HL;
			else LaserTargetPosition = Dir;

			SetLocation(EffectOwner.Instigator.Location);
			return;
		}
	}
	Dir = Start+vector(AimingTarget)*8000.f;

	if( TraceForHit() )
		SetLocation(HL+HN*3);
	else SetLocation(Dir);
	LaserTargetPosition = Location;
}

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         FadeOut=True
         FadeIn=True
         UniformSize=True
         ColorMultiplierRange=(Y=(Min=0.100000,Max=0.100000),Z=(Min=0.200000,Max=0.200000))
         FadeOutStartTime=0.070000
         FadeInEndTime=0.030000
         CoordinateSystem=PTCS_Relative
         MaxParticles=2
         StartSizeRange=(X=(Min=5.000000,Max=6.000000))
         Texture=Texture'Effects_Tex.BulletHits.glowfinal'
         LifetimeRange=(Min=0.100000,Max=0.100000)
     End Object
     Emitters(0)=SpriteEmitter'ApocMutators.FX_LaserDot.SpriteEmitter0'

     bNoDelete=False
     bSkipActorPropertyReplication=True
     bBlockHitPointTraces=False
}
