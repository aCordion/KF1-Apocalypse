Class SlotMachine_GrenadeCard extends SlotMachine_SlotCard;

static function float ExecuteCard(Pawn Target)
{
    local Inventory I;
    local Class<KFVeterancyTypes> V;
    local byte c;

    if (KFPlayerReplicationInfo(Target.PlayerReplicationInfo) != none)
        V = KFPlayerReplicationInfo(Target.PlayerReplicationInfo).ClientVeteranSkill;
    if (V == None)
        V = Class'KFVeterancyTypes';

    for (I=Target.Inventory; I != None; I=I.Inventory)
        if (Frag(I) != None)
        {
            c = 0;
            while(++c < 10 && Frag(I).ConsumeAmmo(0, 1))
            {
                Frag(I).ServerThrow();
                Target.Spawn(V.Static.GetNadeType(KFPlayerReplicationInfo(Target.PlayerReplicationInfo)), , , Target.Location + VRand() * 20.f, RotRand(true));
            }
        }
    PlayerController(Target.Controller).ReceiveLocalizedMessage(Class'SlotMachine_GrenadeMessage');
    return 0;
}

defaultproperties
{
     CardMaterial=Texture'KillingFloorHUD.HUD.Hud_Grenade'
}
