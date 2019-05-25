class SlotMachine_GodModeClient extends Emitter;

#exec AUDIO IMPORT file="Assets\SlotMachine\siroof.wav" NAME="IronShieldOff" GROUP="FX"
#exec AUDIO IMPORT file="Assets\SlotMachine\siroon.wav" NAME="IronShieldOn" GROUP="FX"

var Pawn PawnOwner;
var PlayerController PlayerOwner;
var bool bWornOff;

replication
{
    // Variables the server should send to the client.
    reliable if (Role == ROLE_Authority)
        bWornOff, PawnOwner;
}

function BeginPlay()
{
    PawnOwner = Pawn(Owner);
    PlayerOwner = PlayerController(PawnOwner.Controller);
    PlayerOwner.bGodMode = true;
    SetTimer(Class'SlotMachine_GodModeCard'.Default.GodModeTime, false);
}
function Timer()
{
    SetTimer(0.f, false);
    bWornOff = true;
    LifeSpan = 0.6f;
    Disable('Tick');
    if (Level.NetMode != NM_DedicatedServer)
        PostNetReceive();
}
function Tick(float Delta)
{
    if (PawnOwner == None || PawnOwner.Health <= 0)
        Timer();
}
function Destroyed()
{
    if (PlayerOwner != None)
        PlayerOwner.bGodMode = false;
}

simulated function PostNetBeginPlay()
{
    if (bWornOff)
        return;
    PlaySound(Sound'IronShieldOn');
    if (PawnOwner != None)
        SetOwner(PawnOwner);
}
simulated function PostNetReceive()
{
    if (bWornOff)
    {
        PlaySound(Sound'IronShieldOff');
        Kill();
    }
    if (Owner != PawnOwner)
        SetOwner(PawnOwner);
}

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         FadeOut=True
         FadeIn=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         Acceleration=(Z=60.000000)
         ColorMultiplierRange=(X=(Min=0.700000),Y=(Min=0.000000,Max=0.100000),Z=(Min=0.700000,Max=0.900000))
         FadeOutStartTime=0.150000
         FadeInEndTime=0.100000
         StartLocationRange=(X=(Min=-22.000000,Max=22.000000),Y=(Min=-22.000000,Max=22.000000),Z=(Min=-44.000000,Max=44.000000))
         SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=5.000000)
         StartSizeRange=(X=(Min=4.000000,Max=7.000000))
         Texture=Texture'Effects_Tex.explosions.fire_quad'
         LifetimeRange=(Min=0.400000,Max=0.600000)
     End Object
     Emitters(0)=SpriteEmitter'ApocMutators.SlotMachine_GodModeClient.SpriteEmitter0'

     bNoDelete=False
     Physics=PHYS_Trailer
     RemoteRole=ROLE_SimulatedProxy
     TransientSoundVolume=2.000000
     TransientSoundRadius=800.000000
     bNetNotify=True
}
