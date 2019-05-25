class WTFEquipWelda extends Welder
    dependson(KFVoicePack);

#exec obj load file=WTFTex.utx
#exec obj load file=KF_Weapons_Trip_T.utx

simulated function Tick(float dt)
{
    if (FireMode[0].bIsFiring)
        FireModeArray = 0;
    else if (FireMode[1].bIsFiring)
        FireModeArray = 1;
        
    if (WTFEquipWeldaFire(FireMode[FireModeArray]).LHitActor == none)
    {
        WTFEquipWeldaFire(FireMode[FireModeArray]).LastHitActor = none;
        Super.Tick(dt);
    }
    else if (WTFEquipWeldaFire(FireMode[FireModeArray]).LHitActor.IsA('KFDoorMover'))
    {
        WTFEquipWeldaFire(FireMode[FireModeArray]).LastHitActor = KFDoorMover(WTFEquipWeldaFire(FireMode[FireModeArray]).LHitActor);
        Super.Tick(dt);    
    }
    else if (AmmoAmount(0) < FireMode[0].AmmoClass.Default.MaxAmmo)
    {
        AmmoRegenCount += (dT * AmmoRegenRate);
        ConsumeAmmo(0, -1 * (int(AmmoRegenCount)));
        AmmoRegenCount -= int(AmmoRegenCount);
    }
    
    Super(KFMeleeGun).Tick(dt);
}

defaultproperties
{
     FireModeClass(0)=Class'ApocMutators.WTFEquipWeldaFire'
     FireModeClass(1)=Class'ApocMutators.WTFEquipWeldaFireB'
     AmmoClass(0)=Class'ApocMutators.WTFEquipWeldaAmmo'
     Description="A deadly weapon"
     PickupClass=Class'ApocMutators.WTFEquipWeldaPickup'
     AttachmentClass=Class'ApocMutators.WTFEquipWeldaAttachment'
     ItemName="Legend of Welda"
     Skins(0)=Texture'WTFTex.Welda.Welda'
}
