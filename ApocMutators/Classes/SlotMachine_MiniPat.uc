Class SlotMachine_MiniPat extends ZEDS_ZombieBoss;

function Died(Controller Killer, Class<DamageType> damageType, vector HitLocation)
{
    super(ZombieBossBase).Died(Killer, damageType, HitLocation);
}
function bool MakeGrandEntry()
{
    return false;
}

defaultproperties
{
     ScoringValue=350
     Health=3000
     MenuName="Patriarch Jr."
}
