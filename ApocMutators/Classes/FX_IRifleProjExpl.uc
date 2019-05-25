Class FX_IRifleProjExpl extends Emitter
	transient;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         FadeOutStartTime=0.100000
         FadeInEndTime=0.050000
         MaxParticles=5
         SpinsPerSecondRange=(X=(Max=1.000000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=4.000000)
         StartSizeRange=(X=(Min=50.000000,Max=65.000000))
         InitialParticlesPerSecond=15.000000
         Texture=Texture'HL2WeaponsA.fx.ar2_altfire1b'
         LifetimeRange=(Min=0.300000,Max=0.350000)
     End Object
     Emitters(0)=SpriteEmitter'ApocMutators.FX_IRifleProjExpl.SpriteEmitter2'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter3
         UseCollision=True
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UniformSize=True
         AutomaticInitialSpawning=False
         UseRandomSubdivision=True
         Acceleration=(Z=-800.000000)
         ExtentMultiplier=(X=0.000000,Y=0.000000,Z=0.000000)
         DampingFactorRange=(X=(Min=0.400000,Max=0.400000),Y=(Min=0.400000,Max=0.400000),Z=(Min=0.400000,Max=0.400000))
         FadeOutStartTime=0.300000
         FadeInEndTime=0.100000
         MaxParticles=20
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Max=50.000000)
         SpinsPerSecondRange=(X=(Max=0.500000))
         StartSpinRange=(X=(Max=1.000000))
         StartSizeRange=(X=(Min=6.000000,Max=8.000000))
         InitialParticlesPerSecond=45.000000
         Texture=Texture'HL2WeaponsA.fx.combinemuzzle1'
         TextureUSubdivisions=1
         TextureVSubdivisions=2
         LifetimeRange=(Min=0.600000,Max=0.900000)
         StartVelocityRange=(X=(Min=-640.000000,Max=640.000000),Y=(Min=-640.000000,Max=640.000000),Z=(Min=-200.000000,Max=800.000000))
     End Object
     Emitters(1)=SpriteEmitter'ApocMutators.FX_IRifleProjExpl.SpriteEmitter3'

     AutoDestroy=True
     bNoDelete=False
     LifeSpan=1.500000
}
