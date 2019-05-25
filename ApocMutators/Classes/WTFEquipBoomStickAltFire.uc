class WTFEquipBoomStickAltFire extends BoomStickAltFire;

var int ShellType;

//from kfshotgunfire
function DoFireEffect()
{
    local Vector StartProj, StartTrace, X, Y, Z;
    local Rotator R, Aim;
    local Vector HitLocation, HitNormal;
    local Actor Other;
    local int p;
    local int SpawnCount;
    local float theta;

    Instigator.MakeNoise(1.0);
    Weapon.GetViewAxes(X, Y, Z);

    StartTrace = Instigator.Location + Instigator.EyePosition(); // + X * Instigator.CollisionRadius;
    StartProj = StartTrace + X * ProjSpawnOffset.X;
    if (!Weapon.WeaponCentered() && !KFWeap.bAimingRifle)
        StartProj = StartProj + Weapon.Hand * Y * ProjSpawnOffset.Y + Z * ProjSpawnOffset.Z;

    // check if projectile would spawn through a wall and adjust start location accordingly
    Other = Weapon.Trace(HitLocation, HitNormal, StartProj, StartTrace, false);

// Collision attachment debugging
 /*   if (Other.IsA('ROCollisionAttachment'))
    {
        log(self $ "'s trace hit " $ Other.Base $ " Collision attachment");
    }*/

    if (Other != None)
    {
        StartProj = HitLocation;
    }

    Aim = AdjustAim(StartProj, AimError);

    SpawnCount = Max(1, ProjPerFire * int(Load));

    if (ShellType == 0) // slugs
    {
        if (KFWeap.bAimingRifle)
        {
            Spread *= 0.38; // bigger bonus for aiming
        }
        else
        {
            Spread *= 0.7;
        }
    }

    switch(SpreadStyle)
    {
    case SS_Random:
        X = Vector(Aim);
        for (p = 0; p < SpawnCount; p++)
        {
            R.Yaw = Spread  * (FRand()-0.5);
            R.Pitch = Spread  * (FRand()-0.5);
            R.Roll = Spread  * (FRand()-0.5);
            SpawnProjectile(StartProj, Rotator(X >> R));
        }
        break;
    case SS_Line:
        for (p = 0; p < SpawnCount; p++)
        {
            theta = Spread * PI / 32768 * (p - float(SpawnCount-1) / 2.0);
            X.X = Cos(theta);
            X.Y = Sin(theta);
            X.Z = 0.0;
            SpawnProjectile(StartProj, Rotator(X >> Aim));
        }
        break;
    default:
        SpawnProjectile(StartProj, Aim);
    }

    if (Instigator != none && Instigator.Physics != PHYS_Falling)
        Instigator.AddVelocity(KickMomentum >> Instigator.GetViewRotation());
}

function SetShellType(int type)
{
    ShellType = type;
    if (ShellType == 0) // slugs
    {
        ProjPerFire=1;
        ProjectileClass=Class'ApocMutators.WTFEquipBoomStickSlug';
        Weapon.ItemName=Weapon.default.ItemName  $  "(Slugs)";
    }
    else
    {
        ProjPerFire=12;
        ProjectileClass=Class'ApocMutators.WTFEquipBoomStickPellet';
        Weapon.ItemName=Weapon.default.ItemName  $  "(Shot)";
    }
}

function int GetShellType()
{
    return ShellType;
}

defaultproperties
{
     ShellType=1
     KickMomentum=(X=-150.000000,Z=66.000000)
     maxVerticalRecoilAngle=6400
     maxHorizontalRecoilAngle=1800
     ProjPerFire=12
     TransientSoundVolume=3.800000
     TransientSoundRadius=1000.000000
     ShakeRotMag=(X=100.000000,Y=100.000000,Z=800.000000)
     ShakeOffsetMag=(X=12.000000,Y=4.000000,Z=20.000000)
     ProjectileClass=Class'ApocMutators.WTFEquipBoomStickPellet'
}
