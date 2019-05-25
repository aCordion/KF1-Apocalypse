Class FX_GravityGunBolts extends Emitter
	transient;

simulated final function SetColor( color C )
{
	Emitters[0].ColorMultiplierRange.X.Min = (C.R/255.f);
	Emitters[0].ColorMultiplierRange.X.Max = Emitters[0].ColorMultiplierRange.X.Min;
	Emitters[0].ColorMultiplierRange.Y.Min = (C.G/255.f);
	Emitters[0].ColorMultiplierRange.Y.Max = Emitters[0].ColorMultiplierRange.Y.Min;
	Emitters[0].ColorMultiplierRange.Z.Min = (C.B/255.f);
	Emitters[0].ColorMultiplierRange.Z.Max = Emitters[0].ColorMultiplierRange.Z.Min;
}

defaultproperties
{
     Begin Object Class=BeamEmitter Name=BeamEmitter0
         BeamEndPoints(0)=(offset=(X=(Min=16.000000,Max=16.000000)))
         DetermineEndPointBy=PTEP_Offset
         LowFrequencyNoiseRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000))
         HighFrequencyNoiseRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         HighFrequencyPoints=5
         DynamicHFNoiseRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         DynamicHFNoisePointsRange=(Min=2.000000,Max=3.000000)
         DynamicTimeBetweenNoiseRange=(Min=0.020000,Max=0.040000)
         FadeOut=True
         FadeIn=True
         FadeOutStartTime=0.050000
         FadeInEndTime=0.010000
         CoordinateSystem=PTCS_Relative
         MaxParticles=3
         StartSizeRange=(X=(Min=0.500000,Max=1.000000))
         Texture=Texture'Effects_Tex.Weapons.trailblur'
         LifetimeRange=(Min=0.100000,Max=0.100000)
     End Object
     Emitters(0)=BeamEmitter'ApocMutators.FX_GravityGunBolts.BeamEmitter0'

     bNoDelete=False
}
