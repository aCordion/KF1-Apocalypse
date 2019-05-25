class WTFEquipAFS12ForceBullet extends ShotgunBullet;

simulated function ProcessTouch(Actor Other, vector HitLocation)
{
    if (Other == None)
        return;

    if (KFMonster(Other) == None)
        return;

    if (Other.Physics == PHYS_Walking)
        Other.SetPhysics(PHYS_Falling);

    Other.Velocity.X = Self.Velocity.X * 0.075;
    Other.Velocity.Y = Self.Velocity.Y * 0.075;
    Other.Velocity.Z = Self.Velocity.Z * 0.075;

    Other.Acceleration = vect(0, 0, 0); // 0, 0, 0

    Super.ProcessTouch(Other, HitLocation);
}

defaultproperties
{
     Damage=60.000000
     DamageRadius=1.000000
     LifeSpan=5.000000
     DrawScale=5.000000
}
