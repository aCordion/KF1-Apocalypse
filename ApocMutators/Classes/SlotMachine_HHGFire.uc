//=============================================================================
// SlotMachine_HHGFire
//=============================================================================
class SlotMachine_HHGFire extends BaseProjectileFire;

function DoFireEffect()
{
    SetTimer(0.3, false);
}
function Timer()
{
    local Vector StartProj, StartTrace, X, Y, Z;
    local Rotator Aim;
    local Vector HitLocation, HitNormal;
    local Actor Other;

    Instigator.MakeNoise(1.0);
    Weapon.GetViewAxes(X, Y, Z);

    StartTrace = Instigator.Location + Instigator.EyePosition(); // + X * Instigator.CollisionRadius;
    StartProj = StartTrace + X * ProjSpawnOffset.X;
    if (!Weapon.WeaponCentered())
        StartProj = StartProj + Weapon.Hand * Y * ProjSpawnOffset.Y + Z * ProjSpawnOffset.Z;

    // check if projectile would spawn through a wall and adjust start location accordingly
    Other = Weapon.Trace(HitLocation, HitNormal, StartProj, StartTrace, false);

    if (Other != None)
        StartProj = HitLocation;

    Aim = AdjustAim(StartProj, AimError);
    SpawnProjectile(StartProj, Aim);
    Weapon.GoToState('KillSelf');
}

defaultproperties
{
     FireAnim="Toss"
     FireRate=5.000000
     ProjectileClass=Class'ApocMutators.SlotMachine_HGrenade'
}
