Class FX_BugBaitHitFX extends Emitter
	transient;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         UseRandomSubdivision=True
         Acceleration=(X=3.000000,Z=15.000000)
         ColorMultiplierRange=(X=(Min=0.400000,Max=0.600000),Y=(Min=0.300000,Max=0.400000),Z=(Min=0.300000,Max=0.400000))
         FadeOutStartTime=1.000000
         FadeInEndTime=0.015000
         MaxParticles=16
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Max=25.000000)
         SpinsPerSecondRange=(X=(Max=0.015000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=50.000000,Max=80.000000))
         InitialParticlesPerSecond=100.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'Effects_Tex.BulletHits.dirtclouddark'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         LifetimeRange=(Min=2.000000,Max=3.000000)
         StartVelocityRange=(X=(Min=-8.000000,Max=8.000000),Y=(Min=-8.000000,Max=8.000000),Z=(Min=-8.000000,Max=8.000000))
     End Object
     Emitters(0)=SpriteEmitter'ApocMutators.FX_BugBaitHitFX.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         UseRevolution=True
         UseRevolutionScale=True
         UniformSize=True
         AutomaticInitialSpawning=False
         FadeOutStartTime=0.600000
         FadeInEndTime=0.250000
         MaxParticles=8
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Max=60.000000)
         RevolutionCenterOffsetRange=(X=(Min=-50.000000,Max=50.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=-50.000000,Max=50.000000))
         RevolutionsPerSecondRange=(X=(Min=-0.200000,Max=0.200000),Y=(Min=-0.200000,Max=0.200000),Z=(Min=-0.200000,Max=0.200000))
         RevolutionScale(0)=(RelativeTime=0.250000,RelativeRevolution=(X=-1.000000,Y=-1.000000,Z=1.000000))
         RevolutionScale(1)=(RelativeTime=0.500000,RelativeRevolution=(X=1.000000,Y=1.000000,Z=-1.000000))
         RevolutionScale(2)=(RelativeTime=0.750000,RelativeRevolution=(X=-1.000000,Y=1.000000,Z=-1.000000))
         RevolutionScale(3)=(RelativeTime=1.000000,RelativeRevolution=(X=-1.000000,Y=1.000000,Z=-1.000000))
         StartSizeRange=(X=(Min=2.000000,Max=4.000000))
         InitialParticlesPerSecond=8.000000
         Texture=Texture'Effects_Tex.BulletHits.glowfinal'
         LifetimeRange=(Min=2.000000,Max=3.000000)
         StartVelocityRange=(X=(Min=-64.000000,Max=64.000000),Y=(Min=-64.000000,Max=64.000000),Z=(Min=-64.000000,Max=64.000000))
     End Object
     Emitters(1)=SpriteEmitter'ApocMutators.FX_BugBaitHitFX.SpriteEmitter1'

     AutoDestroy=True
     bNoDelete=False
     LifeSpan=4.000000
}
