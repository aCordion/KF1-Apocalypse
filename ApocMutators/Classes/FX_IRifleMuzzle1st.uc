Class FX_IRifleMuzzle1st extends Emitter
	transient;

simulated function Trigger( Actor Other, Pawn EventInstigator )
{
	SpawnParticle(1);
}

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         UseRandomSubdivision=True
         FadeOutStartTime=0.020000
         FadeInEndTime=0.020000
         CoordinateSystem=PTCS_Relative
         MaxParticles=4
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=0.600000)
         StartSizeRange=(X=(Min=14.000000,Max=17.000000))
         Texture=Texture'HL2WeaponsA.fx.combinemuzzle1'
         TextureUSubdivisions=1
         TextureVSubdivisions=2
         LifetimeRange=(Min=0.100000,Max=0.120000)
         StartVelocityRange=(X=(Min=60.000000,Max=70.000000))
     End Object
     Emitters(0)=SpriteEmitter'ApocMutators.FX_IRifleMuzzle1st.SpriteEmitter1'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         UseRandomSubdivision=True
         FadeOutStartTime=0.050000
         FadeInEndTime=0.020000
         CoordinateSystem=PTCS_Relative
         MaxParticles=4
         StartLocationRange=(X=(Min=4.000000,Max=5.000000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=0.600000)
         StartSizeRange=(X=(Min=10.000000,Max=13.000000))
         Texture=Texture'HL2WeaponsA.fx.combinemuzzle1'
         TextureUSubdivisions=1
         TextureVSubdivisions=2
         LifetimeRange=(Min=0.100000,Max=0.120000)
         StartVelocityRange=(X=(Min=50.000000,Max=60.000000))
     End Object
     Emitters(1)=SpriteEmitter'ApocMutators.FX_IRifleMuzzle1st.SpriteEmitter2'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter3
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         UseRandomSubdivision=True
         FadeOutStartTime=0.050000
         FadeInEndTime=0.040000
         CoordinateSystem=PTCS_Relative
         MaxParticles=4
         StartLocationRange=(X=(Min=5.000000,Max=7.000000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=0.700000)
         StartSizeRange=(X=(Min=6.000000,Max=8.000000))
         Texture=Texture'HL2WeaponsA.fx.combinemuzzle1'
         TextureUSubdivisions=1
         TextureVSubdivisions=2
         LifetimeRange=(Min=0.140000,Max=0.140000)
         StartVelocityRange=(X=(Min=60.000000,Max=70.000000))
     End Object
     Emitters(2)=SpriteEmitter'ApocMutators.FX_IRifleMuzzle1st.SpriteEmitter3'

     bNoDelete=False
     RelativeLocation=(Z=28.000000)
     RelativeRotation=(Pitch=16384)
}
