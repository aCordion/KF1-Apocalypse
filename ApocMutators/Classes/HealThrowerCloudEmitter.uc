class HealThrowerCloudEmitter extends Emitter;

simulated function PostBeginPlay()
{
	Super.Postbeginplay();
	LightEffect();
}

simulated function LightEffect()
{
	if ( !Level.bDropDetail && (Instigator != None)
		&& ((Level.TimeSeconds - LastRenderTime < 0.2) || (PlayerController(Instigator.Controller) != None)) )
	{
		bDynamicLight = true;
		SetTimer(0.25, false);
	}
	else Timer();
}

simulated function Timer()
{
	bDynamicLight = false;
}

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseColorScale=True
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UniformSize=True
         ColorScale(0)=(Color=(G=255,R=128,A=255))
         ColorScale(1)=(RelativeTime=1,Color=(B=61,G=105,R=61,A=255))
         FadeOutStartTime=0.378000
         FadeInEndTime=0.014000
         MaxParticles=20
         SpinsPerSecondRange=(X=(Max=0.025000))
         StartSpinRange=(X=(Min=-0.200000,Max=0.200000))
		 SizeScale(0)=(RelativeSize=10)
         SizeScale(1)=(RelativeTime=0.5,RelativeSize=2)
		 SizeScale(2)=(RelativeTime=1,RelativeSize=1)
         //StartSizeRange=(X=(Min=3,Max=32),Y=(Min=3,Max=32),Z=(Min=3,Max=32))
		 StartSizeRange=(X=(Min=40,Max=40),Y=(Min=40,Max=40),Z=(Min=40,Max=40))
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'kf_fx_trip_t.Misc.smoke_animated'
         TextureUSubdivisions=8
         TextureVSubdivisions=8
         LifetimeRange=(Min=1,Max=1)
     End Object
     Emitters(0)=SpriteEmitter'HealThrowerCloudEmitter.SpriteEmitter0'

     Physics=PHYS_Trailer
     LifeSpan=1

	RemoteRole=ROLE_SimulatedProxy
    bNotOnDedServer=False
    bNoDelete=False
    AutoDestroy=True
}
