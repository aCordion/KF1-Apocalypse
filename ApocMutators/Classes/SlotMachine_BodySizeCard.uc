Class SlotMachine_BodySizeCard extends SlotMachine_SlotCard;

static function float ExecuteCard(Pawn Target)
{
    local int Res;

    Target.SetHeadScale(0.5);
    PlayerController(Target.Controller).ReceiveLocalizedMessage(Class'SlotMachine_HeadMessage', Res);
    return 0;
}

defaultproperties
{
     CardMaterial=Texture'KillingFloor2HUD.Achievements.Achievement_137'
}
