Class SlotMachine_SlotRules extends GameRules;

var SlotMachineMut Mut;

function ScoreKill(Controller Killer, Controller Killed)
{
    if (PlayerController(Killer) != None && Killer.Pawn != None && Monster(Killed.Pawn) != None)
        Mut.AwardKill(PlayerController(Killer), Monster(Killed.Pawn));
    Super.ScoreKill(Killer, Killed);
}

defaultproperties
{
}
