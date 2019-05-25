Class SlotMachine_HeartBreakCard extends SlotMachine_SlotCard;

static function float ExecuteCard(Pawn Target)
{
    Target.Health = Max(Target.Health / 2, 1);
    PlayerController(Target.Controller).ReceiveLocalizedMessage(Class'SlotMachine_HeartBMessage');
    return 0;
}

defaultproperties
{
     CardMaterial=Texture'KillingFloorHUD.Achievements.Achievement_40'
}
