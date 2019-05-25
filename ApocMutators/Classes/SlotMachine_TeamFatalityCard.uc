Class SlotMachine_TeamFatalityCard extends SlotMachine_SlotCard;

#exec AUDIO IMPORT file="Assets\SlotMachine\lightn5a.wav" NAME="LightningStrike" GROUP="FX"

static function float ExecuteCard(Pawn Target)
{
    local Controller C;

    for (C=Target.Level.ControllerList; C != None; C=C.nextController)
        if (C.bIsPlayer && C.Pawn != None && C.Pawn.Health > 0 && PlayerController(C) != None)
        {
            C.Pawn.Health = 1;
            if (xPawn(C.Pawn) != None)
            {
                xPawn(C.Pawn).ShieldStrength = 0;
                xPawn(C.Pawn).SmallShieldStrength = 0;
            }
            C.Pawn.TakeDamage(0, None, vect(0, 0, 0), vect(0, 0, 0), Class'DamageType'); // Make player do near death scream.
            C.Pawn.PlaySound(Sound'LightningStrike', SLOT_None, 2);
            PlayerController(C).ReceiveLocalizedMessage(Class'SlotMachine_TeamFatalityMessage', , Target.Controller.PlayerReplicationInfo);
        }
    return 0;
}

defaultproperties
{
     Desireability=0.050000
     CardMaterial=Texture'KillingFloorHUD.Achievements.Achievement_36'
}
