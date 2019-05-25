class WTFEquipMachinePistol extends Single;

function bool HandlePickupQuery(pickup Item)
{
    if (Item.InventoryType == Class)
    {
        if (KFHumanPawn(Owner) != none && !KFHumanPawn(Owner).CanCarry(Class'WTFEquipMachineDualies'.Default.Weight))
        {
            PlayerController(Instigator.Controller).ReceiveLocalizedMessage(Class'KFMainMessages', 2);
            return true;
        }

        return false; // Allow to "pickup" so this weapon can be replaced with dualies.
    }
    Return Super(KFWeapon).HandlePickupQuery(Item);
}

simulated function bool PutDown()
{
    if (Instigator.PendingWeapon != none && Instigator.PendingWeapon.class == class'WTFEquipMachineDualies')
    {
        bIsReloading = false;
    }

    return super(KFWeapon).PutDown();
}
    

defaultproperties
{
     MagCapacity=16
     FireModeClass(0)=Class'ApocMutators.WTFEquipMachinePistolFire'
     bCanThrow=False
     Description="A deadly weapon"
     PickupClass=Class'ApocMutators.WTFEquipMachinePistolPickup'
     ItemName="Machine Pistol"
}
