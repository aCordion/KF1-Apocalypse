Class FX_IRifleHitFX extends Emitter
	transient;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseDirectionAs=PTDU_Normal
         ProjectionNormal=(X=1.000000,Z=0.000000)
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         UseRandomSubdivision=True
         FadeOutStartTime=0.100000
         FadeInEndTime=0.050000
         CoordinateSystem=PTCS_Relative
         MaxParticles=2
         SpinsPerSecondRange=(X=(Max=1.000000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=3.000000)
         StartSizeRange=(X=(Min=6.000000,Max=10.000000))
         InitialParticlesPerSecond=50.000000
         Texture=Texture'HL2WeaponsA.fx.combinemuzzle1'
         TextureUSubdivisions=1
         TextureVSubdivisions=2
         LifetimeRange=(Min=0.180000,Max=0.200000)
     End Object
     Emitters(0)=SpriteEmitter'ApocMutators.FX_IRifleHitFX.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         FadeOut=True
         RespawnDeadParticles=False
         UniformSize=True
         AutomaticInitialSpawning=False
         UseRandomSubdivision=True
         CoordinateSystem=PTCS_Relative
         MaxParticles=6
         StartLocationRange=(Y=(Min=-8.000000,Max=8.000000),Z=(Min=-8.000000,Max=8.000000))
         StartSizeRange=(X=(Min=2.000000,Max=4.000000))
         InitialParticlesPerSecond=100.000000
         Texture=Texture'HL2WeaponsA.fx.combinemuzzle1'
         TextureUSubdivisions=1
         TextureVSubdivisions=2
         LifetimeRange=(Min=0.170000,Max=0.200000)
         StartVelocityRange=(X=(Min=100.000000,Max=200.000000),Y=(Min=-90.000000,Max=90.000000),Z=(Min=-90.000000,Max=90.000000))
     End Object
     Emitters(1)=SpriteEmitter'ApocMutators.FX_IRifleHitFX.SpriteEmitter1'

     AutoDestroy=True
     bNoDelete=False
     LifeSpan=0.400000
}
