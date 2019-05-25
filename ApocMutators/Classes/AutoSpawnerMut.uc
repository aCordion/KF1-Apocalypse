class AutoSpawnerMut extends Mutator;

struct PlayerSpawnInfo
{
    var string              Hash;
    var KFPlayerController  PC;
    var bool                bSpawnedThisWave;
};

var array<KFPlayerController> PCBuffer;
var array<PlayerSpawnInfo> PlayerDB;
var string VersionString;
var string DateString;
var int WaveCounter;

function PostBeginPlay()
{
    SetTimer(1, true);
}

function Mutate(string MutateString, PlayerController Sender)
{
    if (Caps(MutateString) == "VERSION")
        Sender.ClientMessage(FriendlyName@VersionString@"("$DateString$")");

    super.Mutate(MutateString, Sender);
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
    if (PlayerReplicationInfo(Other) != None)
        PCBuffer[PCBuffer.Length] = KFPlayerController(Other.Owner);

    return Super.CheckReplacement(Other, bSuperRelevant);
}

function NotifyLogout(Controller Exiting)
{
    local KFPlayerController PC;
    local int ID;

    PC = KFPlayerController(Exiting);

    if (PC != None)
    {
        for (ID = 0; ID < PlayerDB.Length; ID++)
        {
            if (PlayerDB[ID].PC == PC)
            {
                if (Invasion(Level.Game).bWaveInProgress)
                {
                    if (KFPlayerReplicationInfo(PC.PlayerReplicationInfo).PlayerHealth > 50)
                        PlayerDB.Remove(ID, 1);
                }
                else
                {
                    PlayerDB.Remove(ID, 1);
                }

                break;
            }
        }
    }

    Super.NotifyLogout(Exiting);
}

function Timer()
{
    local KFPlayerController PC;
    local string Hash;
    local int ID;

    if (Level.Game.GetStateName() != 'MatchInProgress')
        return;

    while (PCBuffer.Length > 0)
    {
        PC = PCBuffer[0];
        PCBuffer.Remove(0, 1);

        if (PC != None)
        {
            Hash = PC.GetPlayerIDHash();

            for (ID = 0; ID < PlayerDB.Length; ID++)
                if (PlayerDB[ID].Hash == Hash)
                    break;

            if (ID == PlayerDB.Length)
            {
                PlayerDB.Length = ID + 1;
                PlayerDB[ID].Hash = Hash;
                PlayerDB[ID].bSpawnedThisWave = false;
            }

            PlayerDB[ID].PC = PC;
        }
    }

    for (ID = 0; ID < PlayerDB.Length; ID++)
    {
        PC = PlayerDB[ID].PC;

        if (PC == None)
            continue;

        if (PC.Pawn != None || PC.bSpawnedThisWave || PlayerDB[ID].bSpawnedThisWave)
        {
            PlayerDB[ID].bSpawnedThisWave = true;
            continue;
        }

        //log("Autospawner, PlayerName:"@PC.PlayerReplicationInfo.PlayerName@"bIsSpec:"@PC.PlayerReplicationInfo.bIsSpectator@"OnlySpec:"@PC.PlayerReplicationInfo.bOnlySpectator@"Waiting:"@PC.PlayerReplicationInfo.bWaitingPlayer@"Ready:"@PC.PlayerReplicationInfo.bReadyToPlay@"OutOfLives:"@PC.PlayerReplicationInfo.bOutOfLives);

        if (Invasion(Level.Game).bWaveInProgress)
        {
            if (PC.PlayerReplicationInfo != None && !PC.PlayerReplicationInfo.bIsSpectator && !PC.PlayerReplicationInfo.bOnlySpectator && PC.PlayerReplicationInfo.bOutOfLives)
            {
                //log("Autospawner, Spawn PlayerName:"@PC.PlayerReplicationInfo.PlayerName@"!!!");

                Level.Game.Disable('Timer');

                PC.PlayerReplicationInfo.bOutOfLives = false;
                PC.PlayerReplicationInfo.NumLives = 0;
                PC.PlayerReplicationInfo.Score = Max(KFGameType(Level.Game).MinRespawnCash, int(PC.PlayerReplicationInfo.Score));
                PC.GotoState('PlayerWaiting');
                PC.SetViewTarget(PC);
                PC.ClientSetBehindView(false);
                PC.bBehindView = False;
                PC.ClientSetViewTarget(PC.Pawn);

                Invasion(Level.Game).bWaveInProgress = false;
                PC.ServerReStartPlayer();
                Invasion(Level.Game).bWaveInProgress = true;

                //kyan: add
                PC.Pawn.Spawn(Class'SlotMachine_GodModeClient', PC.Pawn);
                PlayerController(PC.Pawn.Controller).ReceiveLocalizedMessage(Class'SlotMachine_GodModeMessage');

                Level.Game.Enable('Timer');
            }
        }
    }

    if (Invasion(Level.Game).WaveNum != WaveCounter)
    {
        for (ID = PlayerDB.Length - 1; ID > -1; ID--)
            if (PlayerDB[ID].PC == None)
                PlayerDB.Remove(ID, 1);

        WaveCounter = Invasion(Level.Game).WaveNum;
    }
}

defaultproperties
{
     VersionString="0.0.8n"
     DateString="04/March/12"
     WaveCounter=-1
     GroupName="KF-AutoSpawner"
     FriendlyName="AutoSpawner"
     Description="Allows newly joined players to spawn during the existing wave."
}
