class WTFEquipNadePlain extends Nade;

simulated function Explode(vector HitLocation, vector HitNormal)
{
    local PlayerController  LocalPlayer;

    bHasExploded = True;
    BlowUp(HitLocation);

    PlaySound(ExplodeSounds[rand(ExplodeSounds.length)], , 2.0);

    if (EffectIsRelevant(Location, false))
    {
        Spawn(Class'ApocMutators.WTFEquipNadeExplosionEmitter', , , HitLocation, rotator(vect(0, 0, 1)));
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
     Damage=350.000000
}
