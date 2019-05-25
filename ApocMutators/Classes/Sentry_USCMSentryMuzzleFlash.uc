class Sentry_USCMSentryMuzzleFlash extends Emitter
    Transient;

    #exec obj load file="SentryTechTex1.utx"
#exec obj load file="SentryTechAnim1.ukx"
#exec obj load file="SentryTechStatics.usx"
#exec obj load file="SentryTechSounds.uax"



simulated function BeginPlay()
{
    SetTimer(0.06, false);
}
simulated final function FireFX()
{
    local byte i;

    for (i=0; i < Emitters.Length; ++i)
        Emitters[i].Reset();
    LightType = LT_Strobe;
    SetTimer(0.06, false);
}
simulated function Timer()
{
    LightType = LT_None;
}

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseDirectionAs=PTDU_Normal
         ProjectionNormal=(X=1.000000,Z=0.000000)
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         CoordinateSystem=PTCS_Relative
         MaxParticles=2
         SpinsPerSecondRange=(X=(Max=1.000000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeTime=0.500000,RelativeSize=3.000000)
         SizeScale(1)=(RelativeTime=1.000000)
         StartSizeRange=(X=(Min=4.000000,Max=6.000000))
         InitialParticlesPerSecond=50.000000
         Texture=Texture'SentryTechTex1.Weapon_PortalTurret.combinemuzzle1'
         LifetimeRange=(Min=0.080000,Max=0.090000)
     End Object
     Emitters(0)=SpriteEmitter'ApocMutators.Sentry_USCMSentryMuzzleFlash.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UniformSize=True
         AutomaticInitialSpawning=False
         FadeOutStartTime=0.025000
         CoordinateSystem=PTCS_Relative
         MaxParticles=2
         StartLocationRange=(X=(Min=4.000000,Max=6.000000))
         SpinsPerSecondRange=(X=(Max=1.000000))
         StartSpinRange=(X=(Max=1.000000))
         StartSizeRange=(X=(Min=5.000000,Max=8.000000))
         InitialParticlesPerSecond=35.000000
         Texture=Texture'SentryTechTex1.Weapon_PortalTurret.combinemuzzle2'
         LifetimeRange=(Min=0.060000,Max=0.040000)
     End Object
     Emitters(1)=SpriteEmitter'ApocMutators.Sentry_USCMSentryMuzzleFlash.SpriteEmitter1'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         FadeOut=True
         RespawnDeadParticles=False
         UniformSize=True
         AutomaticInitialSpawning=False
         FadeOutStartTime=0.030000
         CoordinateSystem=PTCS_Relative
         MaxParticles=2
         StartLocationRange=(X=(Min=8.000000,Max=14.000000))
         StartSizeRange=(X=(Min=4.000000,Max=6.000000))
         InitialParticlesPerSecond=45.000000
         Texture=Texture'SentryTechTex1.Weapon_PortalTurret.combinemuzzle1'
         LifetimeRange=(Min=0.040000,Max=0.060000)
     End Object
     Emitters(2)=SpriteEmitter'ApocMutators.Sentry_USCMSentryMuzzleFlash.SpriteEmitter2'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter3
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UniformSize=True
         AutomaticInitialSpawning=False
         FadeOutStartTime=0.030000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         StartLocationRange=(X=(Min=14.000000,Max=17.000000))
         SpinsPerSecondRange=(X=(Max=1.000000))
         StartSpinRange=(X=(Max=1.000000))
         StartSizeRange=(X=(Min=3.000000,Max=5.000000))
         InitialParticlesPerSecond=25.000000
         Texture=Texture'SentryTechTex1.Weapon_PortalTurret.combinemuzzle2'
         LifetimeRange=(Min=0.060000,Max=0.090000)
         StartVelocityRange=(X=(Min=150.000000,Max=200.000000))
     End Object
     Emitters(3)=SpriteEmitter'ApocMutators.Sentry_USCMSentryMuzzleFlash.SpriteEmitter3'

     LightType=LT_Strobe
     LightHue=42
     LightSaturation=191
     LightBrightness=80.000000
     LightRadius=3.000000
     bNoDelete=False
     bDynamicLight=True
     RelativeRotation=(Pitch=16384)
}
