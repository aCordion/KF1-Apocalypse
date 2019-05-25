Class SlotMachine_CashShareCard extends SlotMachine_SlotCard;

static function float ExecuteCard(Pawn Target)
{
    local int Amount, PLCount, PerPlayerCash;
    local Controller C;

    for (C=Target.Level.ControllerList; C != None; C=C.nextController)
        if (C.bIsPlayer && C.Pawn != Target && C.Pawn != None && C.Pawn.Health > 0 && PlayerController(C) != None)
            ++PLCount;

    if (PLCount > 0)
    {
        PerPlayerCash = int(Target.Controller.PlayerReplicationInfo.Score / (PLCount + 1));
        if (PerPlayerCash > 0)
        {
            for (C=Target.Level.ControllerList; C != None; C=C.nextController)
                if (C.bIsPlayer && C.Pawn != Target && C.Pawn != None && C.Pawn.Health > 0 && PlayerController(C) != None)
                {
                    C.PlayerReplicationInfo.Score += PerPlayerCash;
                    Amount += PerPlayerCash;
                    C.Pawn.PlaySound(Class'CashPickup'.Default.PickupSound, SLOT_None, 2);
                    PlayerController(C).ReceiveLocalizedMessage(Class'SlotMachine_CashDonateMessage', Amount, Target.Controller.PlayerReplicationInfo);
                }
        }
        Target.PlaySound(Class'CashPickup'.Default.PickupSound, SLOT_None, 2);
        Amount = Min(Target.Controller.PlayerReplicationInfo.Score, Amount);
    }
    Target.Controller.PlayerReplicationInfo.Score -= Amount;
    PlayerController(Target.Controller).ReceiveLocalizedMessage(Class'SlotMachine_CashShareMessage', Amount);
    return 0;
}

defaultproperties
{
     Desireability=0.800000
     CardMaterial=Texture'KillingFloorHUD.HUD.Hud_Pound_Symbol'
}
