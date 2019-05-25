class WTFEquipFTSprayProj extends WTFEquipFTProj;

/*
While each Proj doesn't do that much damage itself, they all set the DoT a hit
ZED takes to a relatively high amount; This is done because a LOT of these are being shot
when using the FT's secondary fire, so each one only does a little damage.
*/

simulated function ProcessTouch(Actor Other, vector HitLocation)
{
     //flows over, though, past intervening zeds
    if (Other != Instigator && !Other.IsA('PhysicsVolume') && (Other.IsA('Pawn') || Other.IsA('ExtendedZCollision')))
    {
        if (Role == ROLE_Authority)
        {
            if (Other.IsA('KFMonster'))
                KFMonster(Other).LastBurnDamage=14; // base damage of one primary fire projectile
                
            HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);
        }
    }
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
    if (Role == ROLE_Authority)
    {
        HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);
    }

    if (KFHumanPawn(Instigator) != none)
    {
        if (EffectIsRelevant(Location, false))
        {
            Spawn(Class'ApocMutators.WTFEquipFTFuelFlame', self, , Location);
        }
    }

    Destroy();
}

//running every .2 seconds(5 times per second)
simulated function Timer();

simulated singular function HitWall(vector HitNormal, actor Wall)
{
    Explode(Location, Location);
}

simulated function Landed(vector HitNormal)
{
    Explode(Location, Location);
}

defaultproperties
{
     Damage=4.000000
     DamageRadius=50.000000
     LifeSpan=0.250000
}
