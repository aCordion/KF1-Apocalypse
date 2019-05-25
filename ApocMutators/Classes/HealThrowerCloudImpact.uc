class HealThrowerCloudImpact extends Emitter;

var bool bFlashed;

simulated function PostBeginPlay()
{
	Super.Postbeginplay();
	NadeLight();
}

simulated function NadeLight()
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
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        BlendBetweenSubdivisions=True
        ColorScale(0)=(Color=(G=255,R=128,A=255))
        ColorScale(1)=(RelativeTime=1,Color=(B=61,G=105,R=61,A=255))
        FadeOutFactor=(W=0,X=0,Y=0,Z=0)
        FadeOutStartTime=1
        Name="SpriteEmitter0"
        SpinsPerSecondRange=(Y=(Min=0.050000,Max=0.100000),Z=(Min=0.050000,Max=0.100000))
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000),Y=(Max=1),Z=(Max=1))
        SizeScale(0)=(RelativeSize=1)
        SizeScale(1)=(RelativeTime=1,RelativeSize=0.2)
        StartSizeRange=(X=(Min=50,Max=50),Y=(Min=50,Max=50),Z=(Min=50,Max=50))
        InitialParticlesPerSecond=6
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'kf_fx_trip_t.Misc.smoke_animated'
        TextureUSubdivisions=8
        TextureVSubdivisions=8
        LifetimeRange=(Min=1,Max=1)
        StartVelocityRange=(X=(Min=-750,Max=750),Y=(Min=-750,Max=750))
        VelocityLossRange=(X=(Min=10,Max=10),Y=(Min=10,Max=10),Z=(Min=10,Max=10))
    End Object
    Emitters(0)=SpriteEmitter'HealThrowerCloudImpact.SpriteEmitter0'

	LifeSpan=1
    RemoteRole=ROLE_SimulatedProxy
    bNotOnDedServer=False
    bNoDelete=False
    AutoDestroy=True
}
