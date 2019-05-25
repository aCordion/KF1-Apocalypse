class WTFEquipNadeFlame extends Nade;

#exec obj load file=KF_GrenadeSnd.uax

simulated function Explode(vector HitLocation, vector HitNormal)
{
    local PlayerController  LocalPlayer;

    bHasExploded = True;
    BlowUp(HitLocation);

    // Incendiary Effects..
    PlaySound(sound'KF_GrenadeSnd.FlameNade_Explode', , 100.5 * TransientSoundVolume);

    if (EffectIsRelevant(Location, false))
    {
        Spawn(Class'KFIncendiaryExplosion', , , HitLocation, rotator(vect(0, 0, 1)));
        Spawn(ExplosionDecal, self, , HitLocation, rotator(-HitNormal));
    }

    // Shake nearby players screens
    LocalPlayer = Level.GetLocalPlayerController();
    if ((LocalPlayer != None) && (VSize(Location - LocalPlayer.ViewTarget.Location) < (DamageRadius * 1.5)))
        LocalPlayer.ShakeView(RotMag, RotRate, RotTime, OffsetMag, OffsetRate, OffsetTime);
    Destroy();
}

defaultproperties
{
     Damage=125.000000
     MyDamageType=Class'KFMod.DamTypeBurned'
     ExplosionDecal=Class'KFMod.FlameThrowerBurnMark'
}
