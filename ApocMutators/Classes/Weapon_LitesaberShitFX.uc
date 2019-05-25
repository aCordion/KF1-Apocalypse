//=============================================================================
// ROBulletHitRockEffect
//=============================================================================
// Hit effect emitter for bullets hitting rock
//=============================================================================
// Red Orchestra Source
// Copyright (C) 2005 John Ramm-Jaeger" Gibson
//=============================================================================

class Weapon_LitesaberShitFX extends emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseCollision=True
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         DampRotation=True
         UseSizeScale=True
         UniformSize=True
         AutomaticInitialSpawning=False
         Acceleration=(Z=-400.000000)
         ExtentMultiplier=(X=0.150000,Y=0.150000,Z=0.150000)
         DampingFactorRange=(X=(Min=0.300000,Max=0.300000),Y=(Min=0.300000,Max=0.300000),Z=(Min=0.300000,Max=0.300000))
         ColorScale(1)=(RelativeTime=0.100000,Color=(B=251,G=240,R=241,A=255))
         ColorScale(2)=(RelativeTime=0.750000,Color=(B=182,G=206,R=239,A=255))
         ColorScale(3)=(RelativeTime=1.000000)
         MaxParticles=5
         UseRotationFrom=PTRS_Actor
         SpinsPerSecondRange=(X=(Max=2.000000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         RotationDampingFactorRange=(X=(Min=0.200000,Max=0.200000),Y=(Min=0.200000,Max=0.200000),Z=(Min=0.200000,Max=0.200000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=0.600000)
         StartSizeRange=(X=(Min=6.000000,Max=25.000000),Y=(Min=50.000000,Max=50.000000),Z=(Min=50.000000,Max=50.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'daforce.hardspot'
         TextureUSubdivisions=1
         TextureVSubdivisions=1
         LifetimeRange=(Min=3.000000,Max=5.000000)
         StartVelocityRange=(X=(Min=100.000000,Max=200.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=50.000000,Max=150.000000))
         VelocityLossRange=(X=(Min=0.800000,Max=0.800000),Y=(Min=0.800000,Max=0.800000),Z=(Min=0.800000,Max=0.800000))
     End Object
     Emitters(0)=SpriteEmitter'ApocMutators.Weapon_LitesaberShitFX.SpriteEmitter0'

     AutoDestroy=True
     bNoDelete=False
}
