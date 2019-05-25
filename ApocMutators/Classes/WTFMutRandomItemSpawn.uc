class WTFMutRandomItemSpawn extends KFRandomItemSpawn;

var() Class<Pickup> CommonItems[6];
var() Class<Pickup> RareItems[9];
var() Class<Pickup> RarestItems[9];

simulated function PostBeginPlay()
{
    local int i;

    if (Level.NetMode != NM_Client)
    {
        SetRandPowerUp();
    }
    
    if (Level.NetMode != NM_DedicatedServer)
    {
        for (i=0; i < ArrayCount(CommonItems); i++)
            CommonItems[i].static.StaticPrecache(Level);
            
        for (i=0; i < ArrayCount(RareItems); i++)
            RareItems[i].static.StaticPrecache(Level);
            
        for (i=0; i < ArrayCount(RarestItems); i++)
            RarestItems[i].static.StaticPrecache(Level);
    }

    if (KFGameType(Level.Game) != none)
    {
        KFGameType(Level.Game).WeaponPickups[KFGameType(Level.Game).WeaponPickups.Length] = self;
        DisableMe();
    }

    SetLocation(Location - vect(0, 0, 1)); // adjust because reduced drawscale
}

function SetRandPowerUp()
{
    local float r;
    local int RarestItemsLastIndex, RareItemsLastIndex, CommonItemsLastIndex;
    
    RarestItemsLastIndex = ArrayCount(RarestItems) - 1;
    RareItemsLastIndex = ArrayCount(RareItems) - 1;
    CommonItemsLastIndex = ArrayCount(CommonItems) - 1;
    
    r = FRand();
    
    if (r < 0.05)
        PowerUp = RarestItems[rand(RarestItemsLastIndex)]; // rarest items 5% of the time
    else if (r < 0.2)
        PowerUp = RareItems[rand(RareItemsLastIndex)]; // rare items 20% of the time
    else
        PowerUp = CommonItems[rand(CommonItemsLastIndex)]; // rest of the time common items
    
}

function int GetWeightedRandClass();

function TurnOn()
{
    SetRandPowerUp();
    
    if (myPickup != none)
        myPickup.Destroy();

    SpawnPickup();
    SetTimer(InitialWaitTime + InitialWaitTime * FRand(), false);
}

defaultproperties
{
     CommonItems(0)=Class'ApocMutators.WTFEquipShotgunPickup'
     CommonItems(1)=Class'ApocMutators.WTFEquipMachineDualiesPickup'
     CommonItems(2)=Class'KFMod.WinchesterPickup'
     CommonItems(3)=Class'ApocMutators.WTFEquipBulldogPickup'
     CommonItems(4)=Class'KFMod.MachetePickup'
     CommonItems(5)=Class'ApocMutators.WTFEquipFlaregunPickup'
     RareItems(0)=Class'ApocMutators.WTFEquipBoomStickPickup'
     RareItems(1)=Class'KFMod.DeaglePickup'
     RareItems(2)=Class'ApocMutators.WTFEquipCrossbowPickup'
     RareItems(3)=Class'ApocMutators.WTFEquipAK48SPickup'
     RareItems(4)=Class'ApocMutators.WTFEquipFireAxePickup'
     RareItems(5)=Class'ApocMutators.WTFEquipFTPickup'
     RareItems(6)=Class'ApocMutators.WTFEquipM79CFPickup'
     RareItems(7)=Class'ApocMutators.WTFEquipMP7M2Pickup'
     RareItems(8)=Class'ApocMutators.WTFEquipLethalInjectionPickup'
     RarestItems(0)=Class'ApocMutators.WTFEquipRocketLauncherPickup'
     RarestItems(1)=Class'ApocMutators.WTFEquipAFS12Pickup'
     RarestItems(2)=Class'KFMod.M14EBRPickup'
     RarestItems(3)=Class'ApocMutators.WTFEquipSCAR19Pickup'
     RarestItems(4)=Class'ApocMutators.WTFEquipChainsawPickup'
     RarestItems(5)=Class'ApocMutators.WTFEquipKatanaPickup'
     RarestItems(6)=Class'KFMod.PipeBombPickup'
     RarestItems(7)=Class'ApocMutators.WTFEquipUM32Pickup'
     RarestItems(8)=Class'ApocMutators.WTFEquipSelfDestructPickup'
}
