Class SlotMachine_PipeSelfDestCard extends SlotMachine_SlotCard;

static function float ExecuteCard(Pawn Target)
{
    local PipeBombProjectile P;

    foreach Target.DynamicActors(Class'PipeBombProjectile', P)
        if (P.Instigator == Target && !P.bEnemyDetected)
        {
            P.bEnemyDetected = true;
            P.SetTimer(0.15, True);
        }
    PlayerController(Target.Controller).ReceiveLocalizedMessage(Class'SlotMachine_PipeSelfDestMessage');
    return 0;
}

defaultproperties
{
     Desireability=0.350000
     CardMaterial=Texture'KillingFloor2HUD.HUD.Hud_Pipebomb'
}
