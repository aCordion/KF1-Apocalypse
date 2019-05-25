Class SlotMachine_ChimeraNotice extends Emitter
    Transient;

simulated function PostBeginPlay()
{
    PlaySound(Sound'KFWeaponSound.bullethitflesh2', SLOT_Misc, 2.f, , 900.f);
}

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         UniformSize=True
         AutomaticInitialSpawning=False
         FadeOutStartTime=0.900000
         FadeInEndTime=0.050000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         StartLocationRange=(X=(Min=46.000000,Max=46.000000),Z=(Min=120.000000,Max=120.000000))
         StartSizeRange=(X=(Min=-20.000000,Max=-22.000000))
         InitialParticlesPerSecond=100.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'UChimera_rc.Skins.JExclamation'
         LifetimeRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(0)=SpriteEmitter'ApocMutators.SlotMachine_ChimeraNotice.SpriteEmitter0'

     AutoDestroy=True
     bNoDelete=False
     bTrailerSameRotation=True
     Physics=PHYS_Trailer
     LifeSpan=1.250000
}
