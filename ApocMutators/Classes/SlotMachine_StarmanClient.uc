class SlotMachine_StarmanClient extends Emitter;

#exec AUDIO IMPORT file="Assets\SlotMachine\PowerUp.WAV" NAME="StarOn" GROUP="FX"
#exec AUDIO IMPORT file="Assets\SlotMachine\PowerDown.WAV" NAME="StarOff" GROUP="FX"
#exec AUDIO IMPORT file="Assets\SlotMachine\starman.wav" NAME="StarLoop" GROUP="FX"

var Pawn PawnOwner;
var PlayerController PlayerOwner;
var transient float NextDmgTime;
var bool bWornOff, bHasInit;

replication
{
	// Variables the server should send to the client.
	reliable if (Role == ROLE_Authority)
		bWornOff, PawnOwner;
}

function BeginPlay()
{
	PlaySound(Sound'StarOn');
	PawnOwner = Pawn(Owner);
	PawnOwner.Health = 500;
	//PawnOwner.Health = PawnOwner.HealthMax;
	PlayerOwner = PlayerController(PawnOwner.Controller);
	PlayerOwner.bGodMode = true;
	SetTimer(0.8, false);
}
function Timer()
{
	if (!bHasInit)
	{
		bHasInit = true;
		AmbientSound = Sound'StarLoop';
		SetTimer(Class'SlotMachine_StarmanCard'.Default.StarmanTime, false);
		return;
	}
	Disable('Tick');
	SetTimer(0.f, false);
	bWornOff = true;
	LifeSpan = 0.6f;
	if (Level.NetMode != NM_DedicatedServer)
		PostNetReceive();
}
function Tick(float Delta)
{
	local Monster M;

	if (PawnOwner == None || PawnOwner.Health <= 0)
		Timer();
	else if (NextDmgTime < Level.TimeSeconds)
	{
		NextDmgTime = Level.TimeSeconds + 0.1f;
		foreach VisibleCollidingActors(Class'Monster', M, 600, PawnOwner.Location)
			if (IsTouching(M))
				M.TakeDamage(150, PawnOwner, PawnOwner.Location, vect(0, 0, 0), Class'DamageType');
	}
}
final function bool IsTouching(Actor A)
{
	local vector V;

	V = PawnOwner.Location-A.Location;
	if (Abs(V.Z) > (PawnOwner.CollisionHeight + A.CollisionHeight + 50.f))
		return false;
	V.Z = 0;
	return(VSize(V) < (PawnOwner.CollisionRadius + A.CollisionRadius + 50.f));
}
function Destroyed()
{
	if (PlayerOwner != None)
		PlayerOwner.bGodMode = false;
	if (PawnOwner != None && PawnOwner.Health > 0)
		PawnOwner.Health = 100;
}

simulated function PostNetBeginPlay()
{
	if (bWornOff)
		return;
	if (PawnOwner != None)
		SetOwner(PawnOwner);
}
simulated function PostNetReceive()
{
	if (bWornOff)
	{
		PlaySound(Sound'StarOff');
		Kill();
		AmbientSound = None;
	}
	if (PawnOwner != Owner)
		SetOwner(PawnOwner);
}

defaultproperties
{
	 Begin Object Class=SpriteEmitter Name=SpriteEmitter0
		 FadeOut=True
		 FadeIn=True
		 SpinParticles=True
		 UniformSize=True
		 AddVelocityFromOwner=True
		 Acceleration=(Z=5.000000)
		 ColorMultiplierRange=(X=(Min=0.300000),Y=(Min=0.300000),Z=(Min=0.300000))
		 FadeOutStartTime=0.400000
		 FadeInEndTime=0.100000
		 StartLocationRange=(X=(Min=-26.000000,Max=26.000000),Y=(Min=-26.000000,Max=26.000000),Z=(Min=-44.000000,Max=44.000000))
		 SpinsPerSecondRange=(X=(Max=0.300000))
		 StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
		 StartSizeRange=(X=(Min=7.000000,Max=7.000000))
		 Texture=Texture'KFX.MetalHitKF2'
		 LifetimeRange=(Min=0.500000,Max=0.700000)
		 StartVelocityRange=(Z=(Min=25.000000,Max=25.000000))
		 VelocityLossRange=(X=(Min=3.000000,Max=3.000000),Y=(Min=3.000000,Max=3.000000))
	 End Object
	 Emitters(0)=SpriteEmitter'ApocMutators.SlotMachine_StarmanClient.SpriteEmitter0'

	 Begin Object Class=SpriteEmitter Name=SpriteEmitter1
		 UseColorScale=True
		 FadeOut=True
		 FadeIn=True
		 UseSizeScale=True
		 UseRegularSizeScale=False
		 UniformSize=True
		 UseRandomSubdivision=True
		 ColorScale(0)=(RelativeTime=0.500000)
		 ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255))
		 ColorMultiplierRange=(X=(Min=0.700000),Y=(Min=0.700000),Z=(Min=0.700000))
		 Opacity=0.700000
		 FadeOutStartTime=0.100000
		 FadeInEndTime=0.100000
		 StartLocationRange=(X=(Min=-22.000000,Max=22.000000),Y=(Min=-22.000000,Max=22.000000),Z=(Min=-44.000000,Max=44.000000))
		 SizeScale(0)=(RelativeTime=1.000000,RelativeSize=4.000000)
		 StartSizeRange=(X=(Min=4.000000,Max=7.000000))
		 Texture=Texture'Effects_Tex.BulletHits.waterring_2frame'
		 TextureUSubdivisions=2
		 TextureVSubdivisions=1
		 SubdivisionStart=1
		 SubdivisionEnd=1
		 LifetimeRange=(Min=0.400000,Max=0.500000)
	 End Object
	 Emitters(1)=SpriteEmitter'ApocMutators.SlotMachine_StarmanClient.SpriteEmitter1'

	 LightType=LT_Flicker
	 LightHue=127
	 LightSaturation=191
	 LightBrightness=255.000000
	 LightRadius=8.000000
	 bNoDelete=False
	 bDynamicLight=True
	 Physics=PHYS_Trailer
	 RemoteRole=ROLE_SimulatedProxy
	 bFullVolume=True
	 SoundVolume=255
	 SoundRadius=200.000000
	 TransientSoundVolume=2.000000
	 TransientSoundRadius=800.000000
	 bNetNotify=True
}
