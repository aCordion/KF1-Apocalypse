Class SlotMachine_CashJackpotCard extends SlotMachine_SlotCard;

static function float ExecuteCard(Pawn Target)
{
    local int Amount;

    Target.PlaySound(Class'CashPickup'.Default.PickupSound, SLOT_None, 2);
    Amount = 2000 + Rand(21) * 100;
    Target.Controller.PlayerReplicationInfo.Score += Amount;
    PlayerController(Target.Controller).ReceiveLocalizedMessage(Class'SlotMachine_CashMessage', Amount);
    return 0;
}

defaultproperties
{
     Desireability=0.080000
     CardMaterial=Texture'KillingFloorHUD.Achievements.Achievement_17'
}
