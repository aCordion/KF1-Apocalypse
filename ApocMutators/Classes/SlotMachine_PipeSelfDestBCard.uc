Class SlotMachine_PipeSelfDestBCard extends SlotMachine_SlotCard;

static function float ExecuteCard(Pawn Target)
{
    local PipeBombProjectile P;

    foreach Target.DynamicActors(Class'PipeBombProjectile', P)
        if (!P.bEnemyDetected)
        {
            P.bEnemyDetected = true;
            P.SetTimer(0.15, True);
        }
    Target.BroadcastLocalizedMessage(Class'SlotMachine_PipeSelfDestBMessage', , Target.PlayerReplicationInfo);
    return 0;
}

defaultproperties
{
     Desireability=0.070000
     CardMaterial=Texture'KillingFloorHUD.Achievements.Achievement_23'
}
