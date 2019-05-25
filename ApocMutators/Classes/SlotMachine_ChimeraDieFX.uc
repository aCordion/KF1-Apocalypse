class SlotMachine_ChimeraDieFX extends Emitter
    Transient;

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
         UseVelocityScale=True
         ColorMultiplierRange=(Y=(Min=0.400000,Max=0.250000))
         FadeOutStartTime=0.150000
         FadeInEndTime=0.050000
         CoordinateSystem=PTCS_Relative
         MaxParticles=80
         StartLocationRange=(X=(Min=-15.000000,Max=90.000000),Y=(Min=-39.000000,Max=39.000000),Z=(Min=-25.000000,Max=50.000000))
         SpinsPerSecondRange=(X=(Max=0.500000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=3.000000)
         StartSizeRange=(X=(Min=25.000000,Max=35.000000))
         Texture=Texture'Effects_Tex.explosions.fire_quad'
         LifetimeRange=(Min=0.300000,Max=0.500000)
         StartVelocityRadialRange=(Min=60.000000,Max=100.000000)
         GetVelocityDirectionFrom=PTVD_AddRadial
         VelocityScale(0)=(RelativeVelocity=(X=0.100000,Y=0.100000,Z=0.100000))
         VelocityScale(1)=(RelativeTime=1.000000,RelativeVelocity=(X=2.000000,Y=2.000000,Z=2.000000))
     End Object
     Emitters(0)=SpriteEmitter'ApocMutators.SlotMachine_ChimeraDieFX.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         Acceleration=(Z=25.000000)
         Opacity=0.500000
         FadeOutStartTime=1.000000
         FadeInEndTime=1.000000
         CoordinateSystem=PTCS_Relative
         MaxParticles=3
         StartLocationRange=(X=(Max=80.000000))
         SpinsPerSecondRange=(X=(Max=0.050000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=80.000000))
         InitialParticlesPerSecond=80.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'Effects_Tex.Smoke.grenadesmoke'
         LifetimeRange=(Min=2.000000,Max=3.000000)
     End Object
     Emitters(1)=SpriteEmitter'ApocMutators.SlotMachine_ChimeraDieFX.SpriteEmitter1'

     AutoDestroy=True
     bNoDelete=False
     LifeSpan=4.000000
}
