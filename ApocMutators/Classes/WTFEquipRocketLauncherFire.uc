class WTFEquipRocketLauncherFire extends LAWFire;

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local Projectile p;

    if (FRand() <= 0.006)
        p = Weapon.Spawn(Class'ApocMutators.WTFEquipRocketLauncherProjWTF', , , Start, Dir);
    else
        p = Weapon.Spawn(ProjectileClass, , , Start, Dir);

    if (p == None)
        return None;

    p.Damage *= DamageAtten;
    return p;
}

defaultproperties
{
     AmmoClass=Class'ApocMutators.WTFEquipRocketLauncherAmmo'
     ProjectileClass=Class'ApocMutators.WTFEquipRocketLauncherProj'
}
