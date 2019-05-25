Class SlotMachine_ArmorCard extends SlotMachine_SlotCard;

static function float ExecuteCard(Pawn Target)
{
    Target.PlaySound(Class'Vest'.Default.PickupSound, SLOT_None, 2);
    Target.AddShieldStrength(100);
    PlayerController(Target.Controller).ReceiveLocalizedMessage(Class'SlotMachine_ArmorMessage');
    return 0;
}

defaultproperties
{
     CardMaterial=Texture'KillingFloorHUD.Achievements.Achievement_7'
}
