Class SlotMachine_PawnHatModel extends Actor;

var Pawn PawnOwner;
var byte ModelIndex;
var StaticMesh Models[5];
var vector RelativePos[5];
var rotator RelativeRot[5];
var float Scaling[5];

replication
{
    // Variables the server should send to the client.
    reliable if (Role == ROLE_Authority)
        PawnOwner, ModelIndex;
}

simulated function PostNetBeginPlay()
{
    if (Level.NetMode == NM_Client)
    {
        if (PawnOwner != None)
            SetModel(ModelIndex);
        else
        {
            Disable('Tick');
            bNetNotify = true;
        }
    }
}
simulated function PostNetReceive()
{
    if (PawnOwner != None)
    {
        SetModel(ModelIndex);
        bNetNotify = false;
        Enable('Tick');
    }
}

simulated final function SetModel(byte Num)
{
    ModelIndex = Num;
    if (Level.NetMode != NM_DedicatedServer)
    {
        SetStaticMesh(Models[Num]);
        SetDrawScale(Scaling[Num]);
        PawnOwner.AttachToBone(Self, PawnOwner.HeadBone);
        SetRelativeLocation(RelativePos[Num]);
        SetRelativeRotation(RelativeRot[Num]);
    }
    else SetBase(PawnOwner);
}
simulated function Tick(float Delta)
{
    if (PawnOwner == None)
        Destroy();
    else if (Level.NetMode != NM_Client && PawnOwner.Health <= 0)
    {
        bTearOff = true;
        LifeSpan = 1.f;
        Disable('Tick');
    }
}
simulated function TornOff()
{
    if (bNetNotify)
        Destroy();
}

final function bool HatMatches(Pawn Target, byte Index)
{
    return(Target == PawnOwner && (Index == ModelIndex || (Index > 0 && ModelIndex > 0)));
}

defaultproperties
{
     Models(0)=StaticMesh'ApocMutators.SantaHatMesh'
     Models(1)=StaticMesh'ApocMutators.FrankBunnyMask'
     Models(2)=StaticMesh'ApocMutators.PumpkinHead'
     Models(3)=StaticMesh'ApocMutators.SkullMask'
     Models(4)=StaticMesh'ApocMutators.HockeyMask'
     RelativePos(0)=(X=6.000000)
     RelativePos(2)=(X=2.000000)
     RelativeRot(0)=(Yaw=-16384,Roll=16384)
     RelativeRot(1)=(Pitch=-16384)
     RelativeRot(2)=(Yaw=-16384,Roll=16384)
     RelativeRot(3)=(Pitch=-16384)
     RelativeRot(4)=(Pitch=-16384)
     Scaling(0)=0.600000
     Scaling(1)=0.650000
     Scaling(2)=0.250000
     Scaling(3)=0.650000
     Scaling(4)=0.650000
     DrawType=DT_StaticMesh
     bDramaticLighting=True
     bSkipActorPropertyReplication=True
     RemoteRole=ROLE_SimulatedProxy
     bHardAttach=True
     bNoRepMesh=True
}
