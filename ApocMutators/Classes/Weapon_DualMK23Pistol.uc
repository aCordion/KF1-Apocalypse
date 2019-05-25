class Weapon_DualMK23Pistol extends DualMK23Pistol;

var transient int NumKillsWithoutReloading;

function bool HandlePickupQuery( pickup Item )
{
    if ( Item.InventoryType==Class'KFMod.MK23Pistol' )
    {
        if( LastHasGunMsgTime < Level.TimeSeconds && PlayerController(Instigator.Controller) != none )
        {
            LastHasGunMsgTime = Level.TimeSeconds + 0.5;
            PlayerController(Instigator.Controller).ReceiveLocalizedMessage(Class'KFMainMessages', 1);
        }

        return True;
    }

    return Super.HandlePickupQuery(Item);
}

function DropFrom(vector StartLocation)
{
    local int m;
    local KFWeaponPickup Pickup;
    local int AmmoThrown, OtherAmmo;
    local KFWeapon SinglePistol;

    if( !bCanThrow )
        return;

    AmmoThrown = AmmoAmount(0);
    ClientWeaponThrown();

    for (m = 0; m < NUM_FIRE_MODES; m++)
    {
        if (FireMode[m].bIsFiring)
            StopFire(m);
    }

    if ( Instigator != None )
        DetachFromPawn(Instigator);

    if( Instigator.Health > 0 )
    {
        OtherAmmo = AmmoThrown / 2;
        AmmoThrown -= OtherAmmo;
        SinglePistol = Spawn(Class'KFMod.MK23Pistol');
        SinglePistol.SellValue = SellValue / 2;
        SinglePistol.GiveTo(Instigator);
        SinglePistol.Ammo[0].AmmoAmount = OtherAmmo;
        SinglePistol.MagAmmoRemaining = MagAmmoRemaining / 2;
        MagAmmoRemaining = Max(MagAmmoRemaining-SinglePistol.MagAmmoRemaining,0);
    }

    Pickup = Spawn(class'KFMod.MK23Pickup',,, StartLocation);

    if ( Pickup != None )
    {
        Pickup.InitDroppedPickupFor(self);
        Pickup.Velocity = Velocity;
        //fixing dropping exploit
        Pickup.SellValue = SellValue / 2;
        Pickup.Cost = Pickup.SellValue / 0.75;
        Pickup.AmmoAmount[0] = AmmoThrown;
        Pickup.MagAmmoRemaining = MagAmmoRemaining;
        if (Instigator.Health > 0)
            Pickup.bThrown = true;
        //Log("--- Pickup "$String(Pickup)$" spawned with Cost = "$Pickup.Cost);
    }

    Destroyed();
    Destroy();
}

simulated function bool PutDown()
{
    if ( Instigator.PendingWeapon.class == class'KFMod.MK23Pistol' )
    {
        bIsReloading = false;
    }

    return super.PutDown();
}

simulated function ActuallyFinishReloading()
{
    NumKillsWithoutReloading = 0;

    super.ActuallyFinishReloading();
}

defaultproperties
{
     FireModeClass(0)=Class'ApocMutators.Weapon_DualMK23Fire'
     DemoReplacement=class'KFMod.MK23Pistol'
     PickupClass=Class'ApocMutators.Weapon_DualMK23Pickup'
     ItemName="Dual MK23"
}
