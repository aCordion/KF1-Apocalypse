Class SlotMachine_NoDoshCard extends SlotMachine_SlotCard;

#exec Texture Import File=Assets\SlotMachine\NoDosh.pcx Name=I_NoDosh Mips=Off

var config float CashRemainScale;

static function float ExecuteCard(Pawn Target)
{
    local Controller C;

    for (C=Target.Level.ControllerList; C != None; C=C.nextController)
        if (C.bIsPlayer && PlayerController(C) != None && C.PlayerReplicationInfo != None && !C.PlayerReplicationInfo.bOnlySpectator)
        {
            C.PlayerReplicationInfo.Score = int(C.PlayerReplicationInfo.Score * Default.CashRemainScale);
            PlayerController(C).ReceiveLocalizedMessage(Class'SlotMachine_NoDoshMessage');
        }
    return 0;
}

defaultproperties
{
     CashRemainScale=0.100000
     Desireability=0.050000
     CardMaterial=Texture'ApocMutators.I_NoDosh'
}
