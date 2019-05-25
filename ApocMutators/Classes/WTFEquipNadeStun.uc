class WTFEquipNadeStun extends Nade;

simulated function Explode(vector HitLocation, vector HitNormal)
{
    Local Actor A;
    Local KFMonster K;
    local WTFEquipNadeStunProj p;
    
    if (bHasExploded)
        return;
        
    bHasExploded=True;

    if (ROLE == ROLE_Authority)
    {
        foreach CollidingActors(class 'Actor', A, DamageRadius, HitLocation)
        {
            if (KFMonster(A) != None && ExtendedZCollision(A) == none)
            {
                K = KFMonster(A);
                p = Instigator.Spawn(Class'ApocMutators.WTFEquipNadeStunProj', instigator, , Location, K.Rotation);
                p.Stick(K, K.Location);
            }
        }
    }
        
  // PlaySound(sound'PatchSounds.StunNadeBoomSound', , 100.5 * TransientSoundVolume);
    PlaySound(ExplodeSounds[rand(ExplodeSounds.length)], , 100.5 * TransientSoundVolume);
    if (EffectIsRelevant(Location, false))
    {
        Spawn(Class'ApocMutators.WTFEquipNadeExplosionEmitter', , , HitLocation + HitNormal * 20, rotator(HitNormal));
        Spawn(Class'ApocMutators.WTFEquipNadeStunFlash', , , HitLocation + HitNormal * 20, rotator(HitNormal));
    }

    BlowUp(HitLocation);
    Destroy();
}

defaultproperties
{
}
