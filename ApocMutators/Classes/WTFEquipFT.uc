class WTFEquipFT extends FlameThrower;

//override parent here, because parent bails if FireMode != 1; aka firemode(0)
simulated function bool StartFire(int Mode)
{
    if (!super(KFWeapon).StartFire(Mode)) // returns false when mag is empty
    {
        return false;
    }
    
    if (AmmoAmount(0) <= 0)
    {
        return false;
    }

    AnimStopLooping();

    if (!FireMode[Mode].IsInState('FireLoop') && (AmmoAmount(0) > 0))
    {
        FireMode[Mode].StartFiring();
        return true;
    }
    else
    {
        return false;
    }

    return true;
}

defaultproperties
{
     Weight=8.000000
     FireModeClass(0)=Class'ApocMutators.WTFEquipFTFire'
     FireModeClass(1)=Class'ApocMutators.WTFEquipFTFireSpray'
     AmmoClass(0)=Class'ApocMutators.WTFEquipFTAmmo'
     Description="A deadly weapon"
     PickupClass=Class'ApocMutators.WTFEquipFTPickup'
     ItemName="Flamethrower II"
}
