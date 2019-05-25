class WTFEquipNadeStunProj extends WTFEquipLethalInjectionProj;

function Timer()
{
    if (StuckTo != None)
    {
        if (StuckTo.Health <= 0)
            Destroy();
            
        if (ROLE == ROLE_Authority)
        {
             //StuckTo.TakeDamage(Damage, Instigator, StuckTo.Location, MomentumTransfer * Normal(Velocity), MyDamageType);
            StuckTo.bStunned=(LifeSpan >= 3.0);
                
            /*
            Only slow them down if they are faster than our penalty.
            This is so we don't accidentally speed them back up if they are under
            a worse penalty than ours- such as the one Stun Grenades apply.
            */
            if (StuckTo.OriginalGroundSpeed > SlowedGroundSpeed)
                StuckTo.OriginalGroundSpeed=SlowedGroundSpeed;
        
            if (LifeSpan <= 1.0)
                StuckTo.OriginalGroundSpeed=DefaultGroundSpeed;
        }
    }
}

defaultproperties
{
     ReduceSpeedTo=0.300000
     bSlowPoison=True
     Damage=0.000000
     LifeSpan=5.000000
}
