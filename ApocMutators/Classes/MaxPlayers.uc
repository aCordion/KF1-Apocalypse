class MaxPlayers extends Info
    Config(ApocMutators);

var config int ForcedMaxPlayers;

function Tick(float Delta)
{
    //Log("Forcing server max players from" @ Level.Game.MaxPlayers @ "to" @ ForcedMaxPlayers, class.Outer.Name);
    Level.Game.MaxPlayers = ForcedMaxPlayers;
    Level.Game.Default.MaxPlayers = ForcedMaxPlayers;
    Destroy();
}

defaultproperties
{
     ForcedMaxPlayers=16
}
