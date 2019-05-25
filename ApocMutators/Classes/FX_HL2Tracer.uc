class FX_HL2Tracer extends KFNewTracer;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseDirectionAs=PTDU_Right
         RespawnDeadParticles=False
         UseAbsoluteTimeForSizeScale=True
         UseRegularSizeScale=False
         ScaleSizeXByVelocity=True
         AutomaticInitialSpawning=False
         ExtentMultiplier=(X=0.200000)
         ColorMultiplierRange=(Y=(Min=0.800000,Max=0.800000),Z=(Min=0.500000,Max=0.500000))
         MaxParticles=100
         StartSizeRange=(X=(Min=10.000000,Max=10.000000),Y=(Min=0.700000,Max=0.850000))
         ScaleSizeByVelocityMultiplier=(X=0.001000)
         DrawStyle=PTDS_Brighten
         Texture=Texture'HL2WeaponsA.fx.tracer_middle'
         LifetimeRange=(Min=0.100000,Max=0.100000)
         StartVelocityRange=(X=(Min=10000.000000,Max=10000.000000))
     End Object
     Emitters(0)=SpriteEmitter'ApocMutators.FX_HL2Tracer.SpriteEmitter0'

}
