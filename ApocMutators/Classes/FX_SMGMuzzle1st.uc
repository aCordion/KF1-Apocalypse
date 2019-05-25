Class FX_SMGMuzzle1st extends Emitter
	transient;

simulated function Trigger( Actor Other, Pawn EventInstigator )
{
	SpawnParticle(1);
}

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter7
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         UseRandomSubdivision=True
         FadeOutStartTime=0.040000
         FadeInEndTime=0.010000
         CoordinateSystem=PTCS_Relative
         MaxParticles=5
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=1.500000)
         StartSizeRange=(X=(Min=10.000000,Max=12.000000))
         Texture=Texture'HL2WeaponsA.fx.muzzleflash1'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         LifetimeRange=(Min=0.100000,Max=0.120000)
     End Object
     Emitters(0)=SpriteEmitter'ApocMutators.FX_SMGMuzzle1st.SpriteEmitter7'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter8
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         UseRandomSubdivision=True
         FadeOutStartTime=0.030000
         FadeInEndTime=0.020000
         CoordinateSystem=PTCS_Relative
         MaxParticles=5
         StartLocationRange=(X=(Min=6.000000,Max=8.000000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=0.600000)
         StartSizeRange=(X=(Min=7.000000,Max=8.000000))
         Texture=Texture'HL2WeaponsA.fx.muzzleflash1'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         LifetimeRange=(Min=0.120000,Max=0.120000)
         StartVelocityRange=(X=(Min=80.000000,Max=100.000000))
     End Object
     Emitters(1)=SpriteEmitter'ApocMutators.FX_SMGMuzzle1st.SpriteEmitter8'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter9
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         UseRandomSubdivision=True
         FadeOutStartTime=0.040000
         FadeInEndTime=0.030000
         CoordinateSystem=PTCS_Relative
         MaxParticles=5
         StartLocationRange=(X=(Min=10.000000,Max=12.000000))
         SpinsPerSecondRange=(X=(Max=0.500000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=0.600000)
         StartSizeRange=(X=(Min=5.000000,Max=6.000000))
         Texture=Texture'HL2WeaponsA.fx.muzzleflash1'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         LifetimeRange=(Min=0.130000,Max=0.130000)
         StartVelocityRange=(X=(Min=150.000000,Max=200.000000))
     End Object
     Emitters(2)=SpriteEmitter'ApocMutators.FX_SMGMuzzle1st.SpriteEmitter9'

     bNoDelete=False
}
