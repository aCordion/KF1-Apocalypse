Class SlotMachine_ZedDeathCard extends SlotMachine_SlotCard;

static function float ExecuteCard(Pawn Target)
{
    local SlotMachine_Reaper R;
    local KFMonster M;
    local Controller C;

    R = Class'SlotMachine_InstaDeathCard'.Static.SummonReaper(Target);
    if (R == None)
        return 0.f; // FAIL!

    for (C=Target.Level.ControllerList; C != None; C=C.nextController)
    {
        M = KFMonster(C.Pawn);
        if (M != None && M.Health > 0 && VSize(M.Location-Target.Location) < 4000)
            R.AddVictim(M);
    }

    Target.PlaySound(Sound'RevebBell', SLOT_None, 2, , 1000.f);
    PlayerController(Target.Controller).ReceiveLocalizedMessage(Class'SlotMachine_ZedDeathMessage');
    return 10.f;
}

defaultproperties
{
     Desireability=0.100000
     CardMaterial=Texture'KillingFloor2HUD.Achievements.Achievement_57'
}
