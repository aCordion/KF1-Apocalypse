Class FX_IRifleProjTrail extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         FadeOut=True
         FadeIn=True
         SpinParticles=True
         UniformSize=True
         FadeOutStartTime=0.100000
         FadeInEndTime=0.100000
         CoordinateSystem=PTCS_Relative
         MaxParticles=4
         SpinsPerSecondRange=(X=(Max=2.000000))
         StartSpinRange=(X=(Max=1.000000))
         StartSizeRange=(X=(Min=14.000000,Max=16.000000))
         Texture=Texture'HL2WeaponsA.fx.ar2_altfire1b'
         LifetimeRange=(Min=0.200000,Max=0.200000)
     End Object
     Emitters(0)=SpriteEmitter'ApocMutators.FX_IRifleProjTrail.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseCollision=True
         FadeOut=True
         FadeIn=True
         SpinParticles=True
         UniformSize=True
         UseRandomSubdivision=True
         AddVelocityFromOwner=True
         ExtentMultiplier=(X=0.000000,Y=0.000000,Z=0.000000)
         DampingFactorRange=(X=(Min=0.500000,Max=0.500000),Y=(Min=0.500000,Max=0.500000),Z=(Min=0.500000,Max=0.500000))
         FadeOutStartTime=0.250000
         FadeInEndTime=0.100000
         SpinsPerSecondRange=(X=(Max=0.500000))
         StartSpinRange=(X=(Max=1.000000))
         StartSizeRange=(X=(Min=4.000000,Max=6.000000))
         Texture=Texture'HL2WeaponsA.fx.combinemuzzle1'
         TextureUSubdivisions=1
         TextureVSubdivisions=2
         LifetimeRange=(Min=0.700000,Max=1.000000)
         StartVelocityRange=(X=(Min=-64.000000,Max=64.000000),Y=(Min=-64.000000,Max=64.000000),Z=(Min=-64.000000,Max=64.000000))
         VelocityLossRange=(X=(Min=2.000000,Max=2.000000),Y=(Min=2.000000,Max=2.000000),Z=(Min=2.000000,Max=2.000000))
     End Object
     Emitters(1)=SpriteEmitter'ApocMutators.FX_IRifleProjTrail.SpriteEmitter1'

     Begin Object Class=TrailEmitter Name=TrailEmitter0
         TrailShadeType=PTTST_RandomStatic
         TrailLocation=PTTL_FollowEmitter
         MaxPointsPerTrail=35
         DistanceThreshold=20.000000
         FadeOut=True
         FadeIn=True
         ColorMultiplierRange=(Z=(Min=0.600000,Max=0.700000))
         FadeOutStartTime=0.250000
         FadeInEndTime=0.200000
         MaxParticles=7
         StartSizeRange=(X=(Min=7.000000,Max=9.000000))
         Texture=Texture'HL2WeaponsA.fx.lgtning'
         LifetimeRange=(Min=0.400000,Max=0.400000)
     End Object
     Emitters(2)=TrailEmitter'ApocMutators.FX_IRifleProjTrail.TrailEmitter0'

     bNoDelete=False
     Physics=PHYS_Trailer
}
