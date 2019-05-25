Class SlotMachine_ToxicCard extends SlotMachine_SlotCard;

static function float ExecuteCard(Pawn Target)
{
    Target.TakeDamage(30, None, Target.Location, vect(0, 0, 0), Class'DamTypeVomit');
    PlayerController(Target.Controller).ReceiveLocalizedMessage(Class'SlotMachine_ToxicMessage');
    return 0;
}

defaultproperties
{
     CardMaterial=Texture'KillingFloorHUD.Achievements.Achievement_4'
}
