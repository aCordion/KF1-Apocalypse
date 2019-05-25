class Weapon_Dualies extends Dualies;

var transient int NumKillsWithoutReleasingTrigger;

function DropFrom(vector StartLocation)
{
    local int m;
    local Pickup Pickup;
    local Inventory I;
    local int AmmoThrown,OtherAmmo;

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

    if( Instigator.Health>0 )
    {
        OtherAmmo = AmmoThrown/2;
        AmmoThrown-=OtherAmmo;
        I = Spawn(class'KFMod.Single');
        I.GiveTo(Instigator);
        Weapon(I).Ammo[0].AmmoAmount = OtherAmmo;
        Single(I).MagAmmoRemaining = MagAmmoRemaining/2;
        MagAmmoRemaining = Max(MagAmmoRemaining-Single(I).MagAmmoRemaining,0);
    }
    Pickup = Spawn(PickupClass,,, StartLocation);
    if ( Pickup != None )
    {
        Pickup.InitDroppedPickupFor(self);
        Pickup.Velocity = Velocity;
        WeaponPickup(Pickup).AmmoAmount[0] = AmmoThrown;
        if( KFWeaponPickup(Pickup)!=None )
            KFWeaponPickup(Pickup).MagAmmoRemaining = MagAmmoRemaining;
        if (Instigator.Health > 0)
            WeaponPickup(Pickup).bThrown = true;
    }

    Destroyed();
    Destroy();
}

function ServerStopFire(byte Mode)
{
    super.ServerStopFire(Mode);
    NumKillsWithoutReleasingTrigger = 0;
}

defaultproperties
{
     Weight=2.000000
     FireModeClass(0)=Class'ApocMutators.Weapon_DualiesFire'
     DemoReplacement=Class'KFMod.Single'
     PickupClass=Class'ApocMutators.Weapon_DualiesPickup'
     ItemName="Dual 9mms"
}
