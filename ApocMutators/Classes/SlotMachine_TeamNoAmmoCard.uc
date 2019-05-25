Class SlotMachine_TeamNoAmmoCard extends SlotMachine_SlotCard;

#exec Texture Import File=Assets\SlotMachine\NoAmmo.pcx Name=I_NoAmmo Mips=Off MASKED=1

static function float ExecuteCard(Pawn Target)
{
    local Controller C;
    local Inventory I;

    for (C=Target.Level.ControllerList; C != None; C=C.nextController)
        if (C.bIsPlayer && C.Pawn != None && C.Pawn.Health > 0 && PlayerController(C) != None)
        {
            for (I=C.Pawn.Inventory; I != None; I=I.Inventory)
                if (Weapon(I) != None)
                {
                    Weapon(I).ConsumeAmmo(0, 999, true);
                    Weapon(I).ConsumeAmmo(1, 999, true);
                    if (KFWeapon(I) != None)
                        KFWeapon(I).MagAmmoRemaining = 0;
                }
            C.Pawn.PlaySound(Class'KFAmmoPickup'.Default.PickupSound, SLOT_None, 2);
            PlayerController(C).ReceiveLocalizedMessage(Class'SlotMachine_NoAmmoMessage', , Target.Controller.PlayerReplicationInfo);
        }
    return 0;
}

defaultproperties
{
     Desireability=0.060000
     CardMaterial=Texture'ApocMutators.I_NoAmmo'
}
