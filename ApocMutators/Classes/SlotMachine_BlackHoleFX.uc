class SlotMachine_BlackHoleFX extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter3
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         ZTest=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         FadeOutStartTime=0.100000
         FadeInEndTime=0.100000
         CoordinateSystem=PTCS_Relative
         MaxParticles=15
         SpinsPerSecondRange=(X=(Max=0.100000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=15.000000)
         StartSizeRange=(X=(Min=20.000000,Max=40.000000))
         InitialParticlesPerSecond=25.000000
         Texture=Texture'KFX.MetalHitKF2'
         LifetimeRange=(Min=0.400000,Max=0.600000)
         InitialDelayRange=(Min=17.000000,Max=17.000000)
     End Object
     Emitters(0)=SpriteEmitter'ApocMutators.SlotMachine_BlackHoleFX.SpriteEmitter3'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         ZTest=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorMultiplierRange=(X=(Min=0.000000,Max=0.100000),Y=(Min=0.000000,Max=0.100000),Z=(Min=0.000000,Max=0.100000))
         FadeOutStartTime=15.000000
         FadeInEndTime=0.600000
         CoordinateSystem=PTCS_Relative
         SpinsPerSecondRange=(X=(Max=0.100000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeTime=0.050000,RelativeSize=0.140000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=0.100000)
         StartSizeRange=(X=(Min=900.000000,Max=1000.000000))
         InitialParticlesPerSecond=50.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'KFX.MetalHitKF'
         LifetimeRange=(Min=17.000000,Max=18.000000)
     End Object
     Emitters(1)=SpriteEmitter'ApocMutators.SlotMachine_BlackHoleFX.SpriteEmitter1'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         UseDirectionAs=PTDU_Up
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         UniformSize=True
         ScaleSizeYByVelocity=True
         AutomaticInitialSpawning=False
         ColorMultiplierRange=(Z=(Min=0.200000))
         FadeOutStartTime=0.100000
         FadeInEndTime=0.100000
         CoordinateSystem=PTCS_Relative
         MaxParticles=40
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=700.000000,Max=900.000000)
         StartSizeRange=(X=(Min=6.000000,Max=20.000000))
         ScaleSizeByVelocityMultiplier=(Y=0.002500)
         InitialParticlesPerSecond=3.000000
         Texture=Texture'KFX.KFSparkHead'
         LifetimeRange=(Min=0.200000,Max=0.250000)
         InitialDelayRange=(Min=1.250000,Max=1.000000)
         StartVelocityRadialRange=(Min=-2000.000000,Max=-3000.000000)
         GetVelocityDirectionFrom=PTVD_AddRadial
     End Object
     Emitters(2)=SpriteEmitter'ApocMutators.SlotMachine_BlackHoleFX.SpriteEmitter2'

     AutoDestroy=True
     bNoDelete=False
     Physics=PHYS_Trailer
     LifeSpan=21.000000
}
