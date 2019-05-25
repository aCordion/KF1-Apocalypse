Class SlotMachine_HeadSizeCard extends SlotMachine_SlotCard;

static function float ExecuteCard(Pawn Target)
{
    local int Res;

    if (Target.HeadScale < 1)
        Res = 0;
    else if (Target.HeadScale > 1)
        Res = 1;
    else Res = Rand(2);

    if (Res == 0)
        Target.SetHeadScale(2);
    else Target.SetHeadScale(0.5);
    PlayerController(Target.Controller).ReceiveLocalizedMessage(Class'SlotMachine_HeadMessage', Res);
    return 0;
}

defaultproperties
{
     CardMaterial=Texture'KillingFloorHUD.Achievements.Achievement_39'
}
