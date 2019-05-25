Class SlotMachine_AmmoCard extends SlotMachine_SlotCard;

static function float ExecuteCard(Pawn Target)
{
    local Inventory I;

    Target.PlaySound(Class'KFAmmoPickup'.Default.PickupSound, SLOT_None, 2);
    for (I=Target.Inventory; I != None; I=I.Inventory)
        if (Weapon(I) != None)
            Weapon(I).MaxOutAmmo();
    PlayerController(Target.Controller).ReceiveLocalizedMessage(Class'SlotMachine_AmmoMessage');
    return 0;
}

defaultproperties
{
     CardMaterial=Texture'KillingFloorHUD.HUD.Hud_Bullets'
}
