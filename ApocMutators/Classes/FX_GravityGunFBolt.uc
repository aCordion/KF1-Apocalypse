Class FX_GravityGunFBolt extends Emitter
	transient;

simulated final function SetColor( color C )
{
	Emitters[0].ColorMultiplierRange.X.Min = (C.R/500.f);
	Emitters[0].ColorMultiplierRange.X.Max = Emitters[0].ColorMultiplierRange.X.Min;
	Emitters[0].ColorMultiplierRange.Y.Min = (C.G/500.f);
	Emitters[0].ColorMultiplierRange.Y.Max = Emitters[0].ColorMultiplierRange.Y.Min;
	Emitters[0].ColorMultiplierRange.Z.Min = (C.B/500.f);
	Emitters[0].ColorMultiplierRange.Z.Max = Emitters[0].ColorMultiplierRange.Z.Min;
	Emitters[1].ColorMultiplierRange.X.Min = (C.R/255.f);
	Emitters[1].ColorMultiplierRange.X.Max = Emitters[0].ColorMultiplierRange.X.Min;
	Emitters[1].ColorMultiplierRange.Y.Min = (C.G/255.f);
	Emitters[1].ColorMultiplierRange.Y.Max = Emitters[0].ColorMultiplierRange.Y.Min;
	Emitters[1].ColorMultiplierRange.Z.Min = (C.B/255.f);
	Emitters[1].ColorMultiplierRange.Z.Max = Emitters[0].ColorMultiplierRange.Z.Min;
}
simulated final function DrawBeam( vector Start, vector End )
{
	SetLocation(Start);
	BeamEmitter(Emitters[0]).BeamEndPoints[0].Offset.X.Min = End.X;
	BeamEmitter(Emitters[0]).BeamEndPoints[0].Offset.X.Max = End.X;
	BeamEmitter(Emitters[0]).BeamEndPoints[0].Offset.Y.Min = End.Y;
	BeamEmitter(Emitters[0]).BeamEndPoints[0].Offset.Y.Max = End.Y;
	BeamEmitter(Emitters[0]).BeamEndPoints[0].Offset.Z.Min = End.Z;
	BeamEmitter(Emitters[0]).BeamEndPoints[0].Offset.Z.Max = End.Z;
	BeamEmitter(Emitters[1]).BeamEndPoints[0].Offset = BeamEmitter(Emitters[0]).BeamEndPoints[0].Offset;
	Emitters[0].SpawnParticle(2);
	Emitters[1].SpawnParticle(1);
}

defaultproperties
{
     Begin Object Class=BeamEmitter Name=BeamEmitter0
         BeamEndPoints(0)=(offset=(X=(Min=1.000000,Max=1.000000)))
         DetermineEndPointBy=PTEP_OffsetAsAbsolute
         BeamTextureUScale=0.500000
         LowFrequencyNoiseRange=(X=(Min=-5.000000,Max=5.000000),Y=(Min=-5.000000,Max=5.000000),Z=(Min=-5.000000,Max=5.000000))
         HighFrequencyNoiseRange=(X=(Min=-5.000000,Max=5.000000),Y=(Min=-5.000000,Max=5.000000),Z=(Min=-5.000000,Max=5.000000))
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         AutomaticInitialSpawning=False
         ColorMultiplierRange=(Y=(Min=0.500000,Max=0.600000),Z=(Min=0.000000,Max=0.000000))
         Opacity=0.500000
         FadeOutStartTime=0.050000
         FadeInEndTime=0.025000
         MaxParticles=2
         StartSizeRange=(X=(Min=1.000000,Max=1.500000))
         Texture=Texture'Effects_Tex.Weapons.trailblur'
         LifetimeRange=(Min=0.100000,Max=0.100000)
     End Object
     Emitters(0)=BeamEmitter'ApocMutators.FX_GravityGunFBolt.BeamEmitter0'

     Begin Object Class=BeamEmitter Name=BeamEmitter1
         BeamEndPoints(0)=(offset=(X=(Min=1.000000,Max=1.000000)))
         DetermineEndPointBy=PTEP_OffsetAsAbsolute
         BeamTextureUScale=0.800000
         LowFrequencyNoiseRange=(X=(Min=-3.000000,Max=3.000000),Y=(Min=-3.000000,Max=3.000000),Z=(Min=-3.000000,Max=3.000000))
         HighFrequencyNoiseRange=(X=(Min=-3.000000,Max=3.000000),Y=(Min=-3.000000,Max=3.000000),Z=(Min=-3.000000,Max=3.000000))
         RespawnDeadParticles=False
         AutomaticInitialSpawning=False
         ColorMultiplierRange=(Y=(Min=0.600000,Max=0.600000),Z=(Min=0.000000,Max=0.000000))
         MaxParticles=1
         StartSizeRange=(X=(Min=2.000000,Max=4.000000))
         Texture=Texture'Effects_Tex.Weapons.trailblur'
         LifetimeRange=(Min=0.120000,Max=0.120000)
     End Object
     Emitters(1)=BeamEmitter'ApocMutators.FX_GravityGunFBolt.BeamEmitter1'

     bNoDelete=False
}
