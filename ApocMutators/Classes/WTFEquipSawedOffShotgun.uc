class WTFEquipSawedOffShotgun extends WTFEquipBoomStick;

#exec obj load file=WTFTex2.utx

// can't use slugs with this weapon
function bool AllowReload()
{
    if (super(KFWeapon).AllowReload())
    {
        SetPendingReload();
        return true;
    }
    return false;
}

defaultproperties
{
     Weight=5.000000
     FireModeClass(0)=Class'ApocMutators.WTFEquipSawedOffShotgunAltFire'
     FireModeClass(1)=Class'ApocMutators.WTFEquipSawedOffShotgunFire'
     AmmoClass(0)=Class'ApocMutators.WTFEquipSawedOffShotgunAmmo'
     PickupClass=Class'ApocMutators.WTFEquipSawedOffShotgunPickup'
     ItemName="Sawed-Off Shotgun"
     Skins(0)=Texture'WTFTex2.SawedOffShotgun.SawedOffShotgun'
}
