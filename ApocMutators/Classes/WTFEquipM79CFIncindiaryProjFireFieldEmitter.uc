class WTFEquipM79CFIncindiaryProjFireFieldEmitter extends WTFEquipFTFuelFlame;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter10
         UseColorScale=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         UseRandomSubdivision=True
         //Acceleration=(Z=100.000000)
         Acceleration=(Z=0.000000) //kyan
         ColorScale(1)=(RelativeTime=0.300000,color=(B=255,G=255,R=255))
         ColorScale(2)=(RelativeTime=0.750000,color=(B=96,G=160,R=255))
         ColorScale(3)=(RelativeTime=1.000000)
         ColorMultiplierRange=(Z=(Min=0.670000,Max=2.000000))
         //MaxParticles=300
         MaxParticles=100 //kyan
         StartLocationRange=(X=(Min=-200.000000,Max=200.000000),Y=(Min=-200.000000,Max=200.000000))
         SpinsPerSecondRange=(X=(Max=0.070000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=0.250000)
         //StartSizeRange=(X=(Min=56.000000,Max=45.000000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
         StartSizeRange=(X=(Min=30.000000,Max=25.000000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000)) //kyan
         ScaleSizeByVelocityMultiplier=(X=0.000000,Y=0.000000,Z=0.000000)
         ScaleSizeByVelocityMax=0.000000
         texture=texture'KillingFloorTextures.LondonCommon.fire3'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         SecondsBeforeInactive=15.000000
         LifetimeRange=(Min=0.750000,Max=1.500000)
         StartVelocityRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=5.000000,Max=15.000000))
     End Object
     Emitters(0)=SpriteEmitter'ApocMutators.WTFEquipM79CFIncindiaryProjFireFieldEmitter.SpriteEmitter10'

     LightBrightness=300.000000
     LightRadius=14.000000
     LifeSpan=10.000000
     SoundRadius=750.000000
}
