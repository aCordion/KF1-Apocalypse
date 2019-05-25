Class SlotMachine_DrunkClient extends Info;

var float RotDelta[2], RotMultiDir[2], RotUpdateTimer[2];
var bool bUpdateView;

function PostBeginPlay()
{
    SetTimer(Class'SlotMachine_DrunkCard'.Default.DrunkenTime, false);
}
function Timer()
{
    Destroy();
}

simulated function PostNetBeginPlay()
{
    bUpdateView = (Level.NetMode == NM_Client || Level.GetLocalPlayerController() == Owner);
}
simulated function Tick(float Delta)
{
    if (Level.NetMode != NM_Client && (Instigator == None || Instigator.Health <= 0))
        Destroy();
    else if (bUpdateView)
        UpdateDrunkView(Level.GetLocalPlayerController(), Delta);
}
simulated final function UpdateDrunkView(PlayerController PC, float Delta)
{
    local byte i;
    local rotator R;

    for (i=0; i < 2; ++i)
    {
        if (RotUpdateTimer[i] < Level.TimeSeconds)
        {
            RotUpdateTimer[i] = Level.TimeSeconds + FRand() * 0.5f;
            if (FRand() < 0.5)
                RotMultiDir[i] = -1;
            else RotMultiDir[i] = 1;
        }
        RotDelta[i] = FClamp(RotDelta[i] + (RotMultiDir[i] * Delta * 3000.f), -4000.f, 4000.f);
    }
    R = PC.Rotation;
    R.Yaw += RotDelta[0] * Delta;
    R.Pitch += RotDelta[1] * Delta;
    PC.SetRotation(R);
}

defaultproperties
{
     bOnlyRelevantToOwner=True
     RemoteRole=ROLE_SimulatedProxy
}
