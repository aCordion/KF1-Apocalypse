class AFKMut extends Mutator
    config(ApocMutators);

var() config float AFKTimer;
var() config string KickMessage, KickMessagePlayer;
var() config string SpectatorMessage, SpectatorMessagePlayer;
var() config bool bDebug, EnableKick;

struct pRecord
{
    var PlayerController PC;
    var rotator Rotation;
    var float Time;
    var bool bIsSpectator;
    var bool bOutOfLives;
    var int PlayerHealth;
};

var array<pRecord> Players;
var config array<string> AllowAFK;

function PostBeginPlay()
{
    SetTimer(2.0, true);
    SaveConfig();
}

function bool UpdatePlayer(PlayerController PC)
{
    local int i;
    local bool bSurvivor, bKickIdler;

    for (i = 0; i < Players.Length; i++)
    {
        if (Players[i].PC == PC)
        {
            bSurvivor = true;

            if (Players[i].bIsSpectator != PC.PlayerReplicationInfo.bIsSpectator
                || Players[i].bOutOfLives != PC.PlayerReplicationInfo.bOutOfLives
                || Players[i].PlayerHealth>0 != KFPlayerReplicationInfo(PC.PlayerReplicationInfo).PlayerHealth>0)
            {
                Players[i].Rotation = PC.Rotation;
                Players[i].bIsSpectator = PC.PlayerReplicationInfo.bIsSpectator;
                Players[i].bOutOfLives = PC.PlayerReplicationInfo.bOutOfLives;
                Players[i].PlayerHealth = KFPlayerReplicationInfo(PC.PlayerReplicationInfo).PlayerHealth;
            }
            else if (Players[i].Rotation != PC.Rotation)
            {
                Players[i].Rotation = PC.Rotation;
                Players[i].Time = Level.TimeSeconds;
                bKickIdler = false;
            }

            if ((Players[i].Time + AFKTimer) < Level.TimeSeconds)
                bKickIdler = true;
        }
    }

    if (!bSurvivor)
    {
        Players.Insert(0, 1);
        Players[0].PC = PC;
        Players[0].Rotation = PC.Rotation;
        Players[0].Time = Level.TimeSeconds;
        Players[i].bIsSpectator = PC.PlayerReplicationInfo.bIsSpectator;
        Players[i].bOutOfLives = PC.PlayerReplicationInfo.bOutOfLives;
        Players[i].PlayerHealth = KFPlayerReplicationInfo(PC.PlayerReplicationInfo).PlayerHealth;
        bKickIdler = false;
    }

    return bKickIdler;
}

function RemovePlayer(PlayerController PC)
{
    local int i;

    for (i = 0; i < Players.Length; i++)
    {
        if (Players[i].PC == PC)
        {
            Players.Remove(i, 1);
            i--;
        }
    }
}

function bool IsAllowAFK(string PlayerName)
{
    local int i;

    for (i = 0; i < AllowAFK.Length; i++)
        if (Caps(PlayerName) == AllowAFK[i])
            return true;

    return false;
}

function Timer()
{
    local PlayerController PC;

    foreach DynamicActors(class'PlayerController', PC)
    {
        if (PC.PlayerReplicationInfo==none)
            continue;

        if (IsAllowAFK(PC.PlayerReplicationInfo.PlayerName))
            continue;

        if (Caps(PC.PlayerReplicationInfo.PlayerName)=="WEBADMIN")
            continue;

        if (Caps(PC.PlayerReplicationInfo.PlayerName)=="CHATTERSPECTATOR")
            continue;

        if ((Level.Game.AccessControl!=none) && Level.Game.AccessControl.IsAdmin(PC))
            continue;

        if (PC.PlayerReplicationInfo.bIsSpectator)
            continue;

        if (UpdatePlayer(PC))
        {
            RemovePlayer(PC);

            if (PC != none)
            {
                if (EnableKick)
                    KickPlayer(PC, KickMessagePlayer);
                else
                    BecomeSpectator(PC, SpectatorMessagePlayer);
            }
        }
    }

    CleanupPlayer();
}

function CleanupPlayer()
{
    local int i;

    for (i=0; i<Players.Length; i++)
    {
        if (Players[i].PC==none || (Level.Game.AccessControl!=none && Level.Game.AccessControl.IsAdmin(Players[i].PC)))
        {
            Players.Remove(i, 1);
            i--;
        }
    }
}

function KickPlayer(PlayerController C, string message)
{
    local string PlayerName;

    if (C != None
        && Level.Game.AccessControl != none
        && !Level.Game.AccessControl.IsAdmin(C)
        && NetConnection(C.Player) != None)
    {
        if (C.PlayerReplicationInfo != None)
            PlayerName = C.PlayerReplicationInfo.PlayerName;

        C.ClientNetworkMessage("AC_Kicked", message);

        if (C.Pawn != none && Vehicle(C.Pawn) == none)
            C.Pawn.Destroy();

        if (C != None)
            C.Destroy();

        if (PlayerName != "")
            Level.Game.Broadcast(Self, Repl(KickMessage, "%player%", PlayerName));
    }
}

function BecomeSpectator(PlayerController C, string message)
{
    local string PlayerName;

    if (Role < ROLE_Authority)
        return;

    if ( !Level.Game.BecomeSpectator(C) )
        return;

    if ( C.Pawn != None )
        C.Pawn.Died(C, class'DamageType', C.Pawn.Location);

    if ( C.PlayerReplicationInfo != None )
        PlayerName = C.PlayerReplicationInfo.PlayerName;

    C.PlayerReplicationInfo.Score = 0;
    C.PlayerReplicationInfo.Deaths = 0;
    C.PlayerReplicationInfo.GoalsScored = 0;
    C.PlayerReplicationInfo.Kills = 0;
    C.ServerSpectate();

    if (PlayerName != "")
        Level.Game.Broadcast(Self, Repl(SpectatorMessage, "%player%", PlayerName));

    C.ClientBecameSpectator();
}

defaultproperties
{
    GroupName="KF-AFKMut"
    FriendlyName="AFK Mutator"
    Description="Away From Keyboard."

    AFKTimer=1200
    EnableKick=False // kick or spectator
    KickMessage="%player% was kicked by AntiAFK."
    KickMessagePlayer="You was kicked by AntiAFK."
    SpectatorMessage="%player% was spectator by AntiAFK."
    SpectatorMessagePlayer="You was spectator by AntiAFK."
    AllowAFK[0]="Admin1"
    AllowAFK[1]="Admin2"
}