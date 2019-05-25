class ApocWeapRenameMut extends Mutator;

simulated function PostBeginPlay()
{
    TranslateDLC();
    TranslateWTF();
    TranlsateRUS();
    //TranlsateCustom();
}

simulated function TranslateDLC()
{
    class'KFMod.Crossbuzzsaw'.default.ItemName = "[DLC] Buzzsaw Bow";
    class'KFMod.CrossbuzzsawPickup'.default.ItemName = "[DLC] Buzzsaw Bow";
    class'KFMod.CrossbuzzsawPickup'.default.ItemShortName = "[DLC] Buzzsaw Bow";
    class'KFMod.CrossbuzzsawPickup'.default.PickupMessage = "[DLC] Buzzsaw Bow";

    class'KFMod.FlareRevolver'.default.ItemName = "[DLC] Flare Revolver";
    class'KFMod.FlareRevolverPickup'.default.ItemName = "[DLC] Flare Revolver";
    class'KFMod.FlareRevolverPickup'.default.ItemShortName = "[DLC] Flare Revolver";
    class'KFMod.FlareRevolverPickup'.default.PickupMessage = "[DLC] Flare Revolver";

    class'KFMod.DualFlareRevolver'.default.ItemName = "[DLC] Dual Flare Revolvers";
    class'KFMod.DualFlareRevolverPickup'.default.ItemName = "[DLC] Dual Flare Revolvers";
    class'KFMod.DualFlareRevolverPickup'.default.ItemShortName = "[DLC] Dual Flare Revolvers";
    class'KFMod.DualFlareRevolverPickup'.default.PickupMessage = "[DLC] Dual Flare Revolvers";

    class'KFMod.Scythe'.default.ItemName = "[DLC] Scythe";
    class'KFMod.ScythePickup'.default.ItemName = "[DLC] Scythe";
    class'KFMod.ScythePickup'.default.ItemShortName = "[DLC] Scythe";
    class'KFMod.ScythePickup'.default.PickupMessage = "[DLC] Scythe";

    class'KFMod.ThompsonSMG'.default.ItemName = "[DLC] Tommy Gun";
    class'KFMod.ThompsonPickup'.default.ItemName = "[DLC] Tommy Gun";
    class'KFMod.ThompsonPickup'.default.ItemShortName = "[DLC] Tommy Gun";
    class'KFMod.ThompsonPickup'.default.PickupMessage = "[DLC] Tommy Gun";

    class'KFMod.GoldenAK47AssaultRifle'.default.ItemName = "[DLC] Golden AK47";
    class'KFMod.GoldenAK47pickup'.default.ItemName = "[DLC] Golden AK47";
    class'KFMod.GoldenAK47pickup'.default.ItemShortName = "[DLC] Golden AK47";
    class'KFMod.GoldenAK47pickup'.default.PickupMessage = "[DLC] Golden AK47";

    class'KFMod.GoldenBenelliShotgun'.default.ItemName = "[DLC] Golden Combat Shotgun";
    class'KFMod.GoldenBenelliPickup'.default.ItemName = "[DLC] Golden Combat Shotgun";
    class'KFMod.GoldenBenelliPickup'.default.ItemShortName = "[DLC] Golden Combat Shotgun";
    class'KFMod.GoldenBenelliPickup'.default.PickupMessage = "[DLC] Golden Combat Shotgun";

    class'KFMod.GoldenKatana'.default.ItemName = "[DLC] Golden Katana";
    class'KFMod.GoldenKatanaPickup'.default.ItemName = "[DLC] Golden Katana";
    class'KFMod.GoldenKatanaPickup'.default.ItemShortName = "[DLC] Golden Katana";
    class'KFMod.GoldenKatanaPickup'.default.PickupMessage = "[DLC] Golden Katana";

    class'KFMod.GoldenM79GrenadeLauncher'.default.ItemName = "[DLC] Golden M79 Grenade Launcher";
    class'KFMod.GoldenM79Pickup'.default.ItemName = "[DLC] Golden M79 Grenade Launcher";
    class'KFMod.GoldenM79Pickup'.default.ItemShortName = "[DLC] Golden M79 Grenade Launcher";
    class'KFMod.GoldenM79Pickup'.default.PickupMessage = "[DLC] Golden M79 Grenade Launcher";

    class'KFMod.ZEDGun'.default.ItemName = "[ACH] Zed Eradication Device";
    class'KFMod.ZEDGunPickup'.default.ItemName = "[ACH] Zed Eradication Device";
    class'KFMod.ZEDGunPickup'.default.ItemShortName = "[ACH] Zed Eradication Device";
    class'KFMod.ZEDGunPickup'.default.PickupMessage = "[ACH] Zed Eradication Device";

    class'KFMod.DwarfAxe'.default.ItemName = "[ACH] Dwarfs!? Axe";
    class'KFMod.DwarfAxePickup'.default.ItemName = "[ACH] Dwarfs!? Axe";
    class'KFMod.DwarfAxePickup'.default.ItemShortName = "[ACH] Dwarfs!? Axe";
    class'KFMod.DwarfAxePickup'.default.PickupMessage = "[ACH] Dwarfs!? Axe";

    class'KFMod.SPAutoShotgun'.default.ItemName = "[DLC] Multichamber ZED Thrower";
    class'KFMod.SPShotgunPickup'.default.ItemName = "[DLC] Multichamber ZED Thrower";
    class'KFMod.SPShotgunPickup'.default.ItemShortName = "[DLC] Multichamber ZED Thrower";
    class'KFMod.SPShotgunPickup'.default.PickupMessage = "[DLC] Multichamber ZED Thrower";

    class'KFMod.SPGrenadeLauncher'.default.ItemName = "[DLC] The Orca Bomb Propeller";
    class'KFMod.SPGrenadePickup'.default.ItemName = "[DLC] The Orca Bomb Propeller";
    class'KFMod.SPGrenadePickup'.default.ItemShortName = "[DLC] The Orca Bomb Propeller";
    class'KFMod.SPGrenadePickup'.default.PickupMessage = "[DLC] The Orca Bomb Propeller";

    class'KFMod.SPSniperRifle'.default.ItemName = "[DLC] Single Piston Longmusket";
    class'KFMod.SPSniperPickup'.default.ItemName = "[DLC] Single Piston Longmusket";
    class'KFMod.SPSniperPickup'.default.ItemShortName = "[DLC] Single Piston Longmusket";
    class'KFMod.SPSniperPickup'.default.PickupMessage = "[DLC] Single Piston Longmusket";

    class'KFMod.SPThompsonSMG'.default.ItemName = "[DLC] Dr. T's Lead Delivery System";
    class'KFMod.SPThompsonPickup'.default.ItemName = "[DLC] Dr. T's Lead Delivery System";
    class'KFMod.SPThompsonPickup'.default.ItemShortName = "[DLC] Dr. T's Lead Delivery System";
    class'KFMod.SPThompsonPickup'.default.PickupMessage = "[DLC] Dr. T's Lead Delivery System";

    class'KFMod.ThompsonDrumSMG'.default.ItemName = "[DLC] Rising Storm Tommy Gun";
    class'KFMod.ThompsonDrumPickup'.default.ItemName = "[DLC] Rising Storm Tommy Gun";
    class'KFMod.ThompsonDrumPickup'.default.ItemShortName = "[DLC] Rising Storm Tommy Gun";
    class'KFMod.ThompsonDrumPickup'.default.PickupMessage = "[DLC] Rising Storm Tommy Gun";

    class'KFMod.GoldenAA12AutoShotgun'.default.ItemName = "[DLC] Golden AA12 Shotgun";
    class'KFMod.GoldenAA12Pickup'.default.ItemName = "[DLC] Golden AA12 Shotgun";
    class'KFMod.GoldenAA12Pickup'.default.ItemShortName = "[DLC] Golden AA12 Shotgun";
    class'KFMod.GoldenAA12Pickup'.default.PickupMessage = "[DLC] Golden AA12 Shotgun";

    class'KFMod.GoldenChainsaw'.default.ItemName = "[DLC] Golden Chainsaw";
    class'KFMod.GoldenChainsawPickup'.default.ItemName = "[DLC] Golden Chainsaw";
    class'KFMod.GoldenChainsawPickup'.default.ItemShortName = "[DLC] Golden Chainsaw";
    class'KFMod.GoldenChainsawPickup'.default.PickupMessage = "[DLC] Golden Chainsaw";

    class'KFMod.GoldenDeagle'.default.ItemName = "[DLC] Golden Handcannon";
    class'KFMod.GoldenDeaglePickup'.default.ItemName = "[DLC] Golden Handcannon";
    class'KFMod.GoldenDeaglePickup'.default.ItemShortName = "[DLC] Golden Handcannon";
    class'KFMod.GoldenDeaglePickup'.default.PickupMessage = "[DLC] Golden Handcannon";

    class'KFMod.GoldenDualDeagle'.default.ItemName = "[DLC] Dual Golden Handcannons";
    class'KFMod.GoldenDualDeaglePickup'.default.ItemName = "[DLC] Dual Golden Handcannons";
    class'KFMod.GoldenDualDeaglePickup'.default.ItemShortName = "[DLC] Dual Golden Handcannons";
    class'KFMod.GoldenDualDeaglePickup'.default.PickupMessage = "[DLC] Dual Golden Handcannons";

    class'KFMod.GoldenFlamethrower'.default.ItemName = "[DLC] Golden Flamethrower";
    class'KFMod.GoldenFTPickup'.default.ItemName = "[DLC] Golden Flamethrower";
    class'KFMod.GoldenFTPickup'.default.ItemShortName = "[DLC] Golden Flamethrower";
    class'KFMod.GoldenFTPickup'.default.PickupMessage = "[DLC] Golden Flamethrower";

    class'KFMod.ZEDMKIIWeapon'.default.ItemName = "[DLC] Zed Eradication Device MKII";
    class'KFMod.ZEDMKIIPickup'.default.ItemName = "[DLC] Zed Eradication Device MKII";
    class'KFMod.ZEDMKIIPickup'.default.ItemShortName = "[DLC] Zed Eradication Device MKII";
    class'KFMod.ZEDMKIIPickup'.default.PickupMessage = "[DLC] Zed Eradication Device MKII";

    class'KFMod.BlowerThrower'.default.ItemName = "[DLC] Blower Thrower Bile Launcher";
    class'KFMod.BlowerThrowerPickup'.default.ItemName = "[DLC] Blower Thrower Bile Launcher";
    class'KFMod.BlowerThrowerPickup'.default.ItemShortName = "[DLC] Blower Thrower Bile Launcher";
    class'KFMod.BlowerThrowerPickup'.default.PickupMessage = "[DLC] Blower Thrower Bile Launcher";

    class'KFMod.SeekerSixRocketLauncher'.default.ItemName = "[DLC] SeekerSix Rocket Launcher";
    class'KFMod.SeekerSixPickup'.default.ItemName = "[DLC] SeekerSix Rocket Launcher";
    class'KFMod.SeekerSixPickup'.default.ItemShortName = "[DLC] SeekerSix Rocket Launcher";
    class'KFMod.SeekerSixPickup'.default.PickupMessage = "[DLC] SeekerSix Rocket Launcher";

    class'KFMod.SealSquealHarpoonBomber'.default.ItemName = "[DLC] SealSqueal Harpoon Bomber";
    class'KFMod.SealSquealPickup'.default.ItemName = "[DLC] SealSqueal Harpoon Bomber";
    class'KFMod.SealSquealPickup'.default.ItemShortName = "[DLC] SealSqueal Harpoon Bomber";
    class'KFMod.SealSquealPickup'.default.PickupMessage = "[DLC] SealSqueal Harpoon Bomber";

    class'KFMod.CamoM32GrenadeLauncher'.default.ItemName = "[DLC] Camo M32 Grenade Launcher";
    class'KFMod.CamoM32Pickup'.default.ItemName = "[DLC] Camo M32 Grenade Launcher";
    class'KFMod.CamoM32Pickup'.default.ItemShortName = "[DLC] Camo M32 Grenade Launcher";
    class'KFMod.CamoM32Pickup'.default.PickupMessage = "[DLC] Camo M32 Grenade Launcher";

    class'KFMod.CamoShotgun'.default.ItemName = "[DLC] Camo Shotgun";
    class'KFMod.CamoShotgunPickup'.default.ItemName = "[DLC] Camo Shotgun";
    class'KFMod.CamoShotgunPickup'.default.ItemShortName = "[DLC] Camo Shotgun";
    class'KFMod.CamoShotgunPickup'.default.PickupMessage = "[DLC] Camo Shotgun";

    class'KFMod.CamoMP5MMedicGun'.default.ItemName = "[DLC] Camo MP5M Medic Gun";
    class'KFMod.CamoMP5MPickup'.default.ItemName = "[DLC] Camo MP5M Medic Gun";
    class'KFMod.CamoMP5MPickup'.default.ItemShortName = "[DLC] Camo MP5M Medic Gun";
    class'KFMod.CamoMP5MPickup'.default.PickupMessage = "[DLC] Camo MP5M Medic Gun";

    class'KFMod.CamoM4AssaultRifle'.default.ItemName = "[DLC] Camo M4";
    class'KFMod.CamoM4Pickup'.default.ItemName = "[DLC] Camo M4";
    class'KFMod.CamoM4Pickup'.default.ItemShortName = "[DLC] Camo M4";
    class'KFMod.CamoM4Pickup'.default.PickupMessage = "[DLC] Camo M4";
}

simulated function TranslateWTF()
{
    class'ApocMutators.WTFEquipFlaregun'.default.ItemName = "[WTF] Flaregun";
    class'ApocMutators.WTFEquipFlaregunPickup'.default.ItemName = "[WTF] Flaregun";
    class'ApocMutators.WTFEquipFlaregunPickup'.default.ItemShortName = "[WTF] Flaregun";
    class'ApocMutators.WTFEquipFlaregunPickup'.default.PickupMessage = "[WTF] Flaregun";

    class'ApocMutators.WTFEquipGlowstick'.default.ItemName = "[WTF] Glowstick";
    class'ApocMutators.WTFEquipGlowstickPickup'.default.ItemName = "[WTF] Glowstick";
    class'ApocMutators.WTFEquipGlowstickPickup'.default.ItemShortName = "[WTF] Glowstick";
    class'ApocMutators.WTFEquipGlowstickPickup'.default.PickupMessage = "[WTF] Glowstick";

    class'ApocMutators.WTFEquipWelda'.default.ItemName = "[WTF] Legend of Welda";
    class'ApocMutators.WTFEquipWeldaPickup'.default.ItemName = "[WTF] Legend of Welda";
    class'ApocMutators.WTFEquipWeldaPickup'.default.ItemShortName = "[WTF] Legend of Welda";
    class'ApocMutators.WTFEquipWeldaPickup'.default.PickupMessage = "[WTF] Legend of Welda";

    class'ApocMutators.WTFEquipChainsaw'.default.ItemName = "[WTF] Chainsaw";
    class'ApocMutators.WTFEquipChainsawPickup'.default.ItemName = "[WTF] Chainsaw";
    class'ApocMutators.WTFEquipChainsawPickup'.default.ItemShortName = "[WTF] Chainsaw";
    class'ApocMutators.WTFEquipChainsawPickup'.default.PickupMessage = "[WTF] Chainsaw";

    class'ApocMutators.WTFEquipFireAxe'.default.ItemName = "[WTF] FIRE Axe";
    class'ApocMutators.WTFEquipFireAxePickup'.default.ItemName = "[WTF] FIRE Axe";
    class'ApocMutators.WTFEquipFireAxePickup'.default.ItemShortName = "[WTF] FIRE Axe";
    class'ApocMutators.WTFEquipFireAxePickup'.default.PickupMessage = "[WTF] FIRE Axe";

    class'ApocMutators.WTFEquipKatana'.default.ItemName = "[WTF] Katana";
    class'ApocMutators.WTFEquipKatanaPickup'.default.ItemName = "[WTF] Katana";
    class'ApocMutators.WTFEquipKatanaPickup'.default.ItemShortName = "[WTF] Katana";
    class'ApocMutators.WTFEquipKatanaPickup'.default.PickupMessage = "[WTF] Katana";

    class'ApocMutators.WTFEquipLethalInjection'.default.ItemName = "[WTF] Lethal Injection";
    class'ApocMutators.WTFEquipLethalInjectionPickup'.default.ItemName = "[WTF] Lethal Injection";
    class'ApocMutators.WTFEquipLethalInjectionPickup'.default.ItemShortName = "[WTF] Lethal Injection";
    class'ApocMutators.WTFEquipLethalInjectionPickup'.default.PickupMessage = "[WTF] Lethal Injection";

    class'ApocMutators.WTFEquipMP7M2a'.default.ItemName = "[WTF] MP7M2 Medic Gun";
    class'ApocMutators.WTFEquipMP7M2Pickup'.default.ItemName = "[WTF] MP7M2 Medic Gun";
    class'ApocMutators.WTFEquipMP7M2Pickup'.default.ItemShortName = "[WTF] MP7M2 Medic Gun";
    class'ApocMutators.WTFEquipMP7M2Pickup'.default.PickupMessage = "[WTF] MP7M2 Medic Gun";

    class'ApocMutators.WTFEquipAK48S'.default.ItemName = "[WTF] AK48S";
    class'ApocMutators.WTFEquipAK48SPickup'.default.ItemName = "[WTF] AK48S";
    class'ApocMutators.WTFEquipAK48SPickup'.default.ItemShortName = "[WTF] AK48S";
    class'ApocMutators.WTFEquipAK48SPickup'.default.PickupMessage = "[WTF] AK48S";

    class'ApocMutators.WTFEquipBulldog'.default.ItemName = "[WTF] Bulldog";
    class'ApocMutators.WTFEquipBulldogPickup'.default.ItemName = "[WTF] Bulldog";
    class'ApocMutators.WTFEquipBulldogPickup'.default.ItemShortName = "[WTF] Bulldog";
    class'ApocMutators.WTFEquipBulldogPickup'.default.PickupMessage = "[WTF] Bulldog";

    class'ApocMutators.WTFEquipSCAR19a'.default.ItemName = "[WTF] SCAR19";
    class'ApocMutators.WTFEquipSCAR19Pickup'.default.ItemName = "[WTF] SCAR19";
    class'ApocMutators.WTFEquipSCAR19Pickup'.default.ItemShortName = "[WTF] SCAR19";
    class'ApocMutators.WTFEquipSCAR19Pickup'.default.PickupMessage = "[WTF] SCAR19";

    class'ApocMutators.WTFEquipCrossbow'.default.ItemName = "[WTF] Xbow";
    class'ApocMutators.WTFEquipCrossbowPickup'.default.ItemName = "[WTF] Xbow";
    class'ApocMutators.WTFEquipCrossbowPickup'.default.ItemShortName = "[WTF] Xbow";
    class'ApocMutators.WTFEquipCrossbowPickup'.default.PickupMessage = "[WTF] Xbow";

    class'ApocMutators.WTFEquipMachineDualies'.default.ItemName = "[WTF] 2x Machine Pistols";
    class'ApocMutators.WTFEquipMachineDualiesPickup'.default.ItemName = "[WTF] 2x Machine Pistols";
    class'ApocMutators.WTFEquipMachineDualiesPickup'.default.ItemShortName = "[WTF] 2x Machine Pistols";
    class'ApocMutators.WTFEquipMachineDualiesPickup'.default.PickupMessage = "[WTF] 2x Machine Pistols";

    class'ApocMutators.WTFEquipMachinePistol'.default.ItemName = "[WTF] Machine Pistol";
    class'ApocMutators.WTFEquipMachinePistolPickup'.default.ItemName = "[WTF] Machine Pistol";
    class'ApocMutators.WTFEquipMachinePistolPickup'.default.ItemShortName = "[WTF] Machine Pistol";
    class'ApocMutators.WTFEquipMachinePistolPickup'.default.PickupMessage = "[WTF] Machine Pistol";

    class'ApocMutators.WTFEquipAFS12a'.default.ItemName = "[WTF] AFS12";
    class'ApocMutators.WTFEquipAFS12Pickup'.default.ItemName = "[WTF] AFS12";
    class'ApocMutators.WTFEquipAFS12Pickup'.default.ItemShortName = "[WTF] AFS12";
    class'ApocMutators.WTFEquipAFS12Pickup'.default.PickupMessage = "[WTF] AFS12";

    class'ApocMutators.WTFEquipBoomStick'.default.ItemName = "[WTF] BOOMSTICK";
    class'ApocMutators.WTFEquipBoomStickPickup'.default.ItemName = "[WTF] BOOMSTICK";
    class'ApocMutators.WTFEquipBoomStickPickup'.default.ItemShortName = "[WTF] BOOMSTICK";
    class'ApocMutators.WTFEquipBoomStickPickup'.default.PickupMessage = "[WTF] BOOMSTICK";

    class'ApocMutators.WTFEquipSawedOffShotgun'.default.ItemName = "[WTF] Sawed-Off Shotgun";
    class'ApocMutators.WTFEquipSawedOffShotgunPickup'.default.ItemName = "[WTF] Sawed-Off Shotgun";
    class'ApocMutators.WTFEquipSawedOffShotgunPickup'.default.ItemShortName = "[WTF] Sawed-Off Shotgun";
    class'ApocMutators.WTFEquipSawedOffShotgunPickup'.default.PickupMessage = "[WTF] Sawed-Off Shotgun";

    class'ApocMutators.WTFEquipShotgun'.default.ItemName = "[WTF] Shotgun";
    class'ApocMutators.WTFEquipShotgunPickup'.default.ItemName = "[WTF] Shotgun";
    class'ApocMutators.WTFEquipShotgunPickup'.default.ItemShortName = "[WTF] Shotgun";
    class'ApocMutators.WTFEquipShotgunPickup'.default.PickupMessage = "[WTF] Shotgun";

    class'ApocMutators.WTFEquipUM32a'.default.ItemName = "[WTF] UM32";
    class'ApocMutators.WTFEquipUM32Pickup'.default.ItemName = "[WTF] UM32";
    class'ApocMutators.WTFEquipUM32Pickup'.default.ItemShortName = "[WTF] UM32";
    class'ApocMutators.WTFEquipUM32Pickup'.default.PickupMessage = "[WTF] UM32";

    class'ApocMutators.WTFEquipFT'.default.ItemName = "[WTF] Flamethrower II";
    class'ApocMutators.WTFEquipFTPickup'.default.ItemName = "[WTF] Flamethrower II";
    class'ApocMutators.WTFEquipFTPickup'.default.ItemShortName = "[WTF] Flamethrower II";
    class'ApocMutators.WTFEquipFTPickup'.default.PickupMessage = "[WTF] Flamethrower II";

    class'ApocMutators.WTFEquipBanHammer'.default.ItemName = "[WTF] Ban Hammer";
    class'ApocMutators.WTFEquipBanHammerPickup'.default.ItemName = "[WTF] Ban Hammer";
    class'ApocMutators.WTFEquipBanHammerPickup'.default.ItemShortName = "[WTF] Ban Hammer";
    class'ApocMutators.WTFEquipBanHammerPickup'.default.PickupMessage = "[WTF] Ban Hammer";

    class'ApocMutators.WTFEquipM79CF'.default.ItemName = "[WTF] M79CF";
    class'ApocMutators.WTFEquipM79CFPickup'.default.ItemName = "[WTF] M79CF";
    class'ApocMutators.WTFEquipM79CFPickup'.default.ItemShortName = "[WTF] M79CF";
    class'ApocMutators.WTFEquipM79CFPickup'.default.PickupMessage = "[WTF] M79CF";

    class'ApocMutators.WTFEquipPipeBomb'.default.ItemName = "[WTF] Pipe Bomb";
    class'ApocMutators.WTFEquipPipeBombPickup'.default.ItemName = "[WTF] Pipe Bomb";
    class'ApocMutators.WTFEquipPipeBombPickup'.default.ItemShortName = "[WTF] Pipe Bomb";
    class'ApocMutators.WTFEquipPipeBombPickup'.default.PickupMessage = "[WTF] Pipe Bomb";

    class'ApocMutators.WTFEquipRocketLauncher'.default.ItemName = "[WTF] Rocket Launcher";
    class'ApocMutators.WTFEquipRocketLauncherPickup'.default.ItemName = "[WTF] Rocket Launcher";
    class'ApocMutators.WTFEquipRocketLauncherPickup'.default.ItemShortName = "[WTF] Rocket Launcher";
    class'ApocMutators.WTFEquipRocketLauncherPickup'.default.PickupMessage = "[WTF] Rocket Launcher";

    class'ApocMutators.WTFEquipSelfDestruct'.default.ItemName = "[WTF] Self Destruct";
    class'ApocMutators.WTFEquipSelfDestructPickup'.default.ItemName = "[WTF] Self Destruct";
    class'ApocMutators.WTFEquipSelfDestructPickup'.default.ItemShortName = "[WTF] Self Destruct";
    class'ApocMutators.WTFEquipSelfDestructPickup'.default.PickupMessage = "[WTF] Self Destruct";
}

simulated function TranlsateRUS()
{
    class'ApocWeaponPack.AK47SHAssaultRifle'.default.ItemName = "[APOC] Kalashnikov AKS74";
    class'ApocWeaponPack.AK47SHPickup'.default.ItemName = "[APOC] Kalashnikov AKS74";
    class'ApocWeaponPack.AK47SHPickup'.default.ItemShortName = "[APOC] Kalashnikov AKS74";
    class'ApocWeaponPack.AK47SHPickup'.default.PickupMessage = "You got a [APOC] Kalashnikov AKS74.";

    class'ApocWeaponPack.AK74uAssaultRifle'.default.ItemName = "[APOC] Kalashnikov AK74u";
    class'ApocWeaponPack.AK74uPickup'.default.ItemName = "[APOC] Kalashnikov AK74u";
    class'ApocWeaponPack.AK74uPickup'.default.ItemShortName = "[APOC] Kalashnikov AK74u";
    class'ApocWeaponPack.AK74uPickup'.default.PickupMessage = "You got a [APOC] Kalashnikov AK74u.";

    class'ApocWeaponPack.AKC74AssaultRifle'.default.ItemName = "[APOC] AKC-74 AssaultRifle";
    class'ApocWeaponPack.AKC74Pickup'.default.ItemName = "[APOC] Kalashnikov AKC-74 AssaultRifle";
    class'ApocWeaponPack.AKC74Pickup'.default.ItemShortName = "[APOC] AKC-74 AssaultRifle";
    class'ApocWeaponPack.AKC74Pickup'.default.PickupMessage = "You got a [APOC] AKC-74 AssaultRifle.";

    class'ApocWeaponPack.AUG_A1AR'.default.ItemName = "[APOC] AUG A1AR";
    class'ApocWeaponPack.AUG_A1ARPickup'.default.ItemName = "[APOC] AUG A1AR";
    class'ApocWeaponPack.AUG_A1ARPickup'.default.ItemShortName = "[APOC] AUG A1AR";
    class'ApocWeaponPack.AUG_A1ARPickup'.default.PickupMessage = "You got a [APOC] AUG A1AR.";

    class'ApocWeaponPack.B94'.default.ItemName = "[APOC] B94";
    class'ApocWeaponPack.B94Pickup'.default.ItemName = "[APOC] B94";
    class'ApocWeaponPack.B94Pickup'.default.ItemShortName = "[APOC] B94";
    class'ApocWeaponPack.B94Pickup'.default.PickupMessage = "You got a [APOC] B94.";

    class'ApocWeaponPack.G2ContenderDT'.default.ItemName = "[APOC] G2ContenderDT";
    class'ApocWeaponPack.G2ContenderDTPickup'.default.ItemName = "[APOC] G2ContenderDT";
    class'ApocWeaponPack.G2ContenderDTPickup'.default.ItemShortName = "[APOC] G2ContenderDT";
    class'ApocWeaponPack.G2ContenderDTPickup'.default.PickupMessage = "You got a [APOC] G2ContenderDT.";

    class'ApocWeaponPack.HK417'.default.ItemName = "[APOC] HK417";
    class'ApocWeaponPack.HK417Pickup'.default.ItemName = "[APOC] HK417";
    class'ApocWeaponPack.HK417Pickup'.default.ItemShortName = "[APOC] HK417";
    class'ApocWeaponPack.HK417Pickup'.default.PickupMessage = "You got a [APOC] HK417.";

    class'ApocWeaponPack.M202A1'.default.ItemName = "[APOC] M202A1";
    class'ApocWeaponPack.M202A1Pickup'.default.ItemName = "[APOC] M202A1";
    class'ApocWeaponPack.M202A1Pickup'.default.ItemShortName = "[APOC] M202A1";
    class'ApocWeaponPack.M202A1Pickup'.default.PickupMessage = "You got a [APOC] M202A1.";

    class'ApocWeaponPack.M202A2'.default.ItemName = "[APOC] M202A2";
    class'ApocWeaponPack.M202A2Pickup'.default.ItemName = "[APOC] M202A2";
    class'ApocWeaponPack.M202A2Pickup'.default.ItemShortName = "[APOC] M202A2";
    class'ApocWeaponPack.M202A2Pickup'.default.PickupMessage = "You got a [APOC] M202A2.";

    class'ApocWeaponPack.M249'.default.ItemName = "[APOC] M249 SAW";
    class'ApocWeaponPack.M249Pickup'.default.ItemName = "[APOC] M249 SAW";
    class'ApocWeaponPack.M249Pickup'.default.ItemShortName = "[APOC] M249 SAW";
    class'ApocWeaponPack.M249Pickup'.default.PickupMessage = "You got a [APOC] M249 SAW.";

    class'ApocWeaponPack.M76LLIBattleRifle'.default.ItemName = "[APOC] M76 BattleRifle";
    class'ApocWeaponPack.M76LLIPickup'.default.ItemName = "[APOC] M76 BattleRifle";
    class'ApocWeaponPack.M76LLIPickup'.default.ItemShortName = "[APOC] M76 BattleRifle";
    class'ApocWeaponPack.M76LLIPickup'.default.PickupMessage = "You got a [APOC] M76 BattleRifle.";

    class'ApocWeaponPack.P90DT'.default.ItemName = "[APOC] P90";
    class'ApocWeaponPack.P90DTPickup'.default.ItemName = "[APOC] P90";
    class'ApocWeaponPack.P90DTPickup'.default.ItemShortName = "[APOC] P90";
    class'ApocWeaponPack.P90DTPickup'.default.PickupMessage = "You got a [APOC] P90.";

    class'ApocWeaponPack.PKM'.default.ItemName = "[APOC] PKM SAW";
    class'ApocWeaponPack.PKMPickup'.default.ItemName = "[APOC] PKM SAW";
    class'ApocWeaponPack.PKMPickup'.default.ItemShortName = "[APOC] PKM SAW";
    class'ApocWeaponPack.PKMPickup'.default.PickupMessage = "You got a [APOC] PKM SAW.";

    class'ApocWeaponPack.PP19AssaultRifle'.default.ItemName = "[APOC] PP-19 Bizon";
    class'ApocWeaponPack.PP19Pickup'.default.ItemName = "[APOC] PP-19 Bizon";
    class'ApocWeaponPack.PP19Pickup'.default.ItemShortName = "[APOC] PP-19";
    class'ApocWeaponPack.PP19Pickup'.default.PickupMessage = "You got a [APOC] PP-19 Bizon.";

    class'ApocWeaponPack.Protecta'.default.ItemName = "[APOC] Protecta";
    class'ApocWeaponPack.ProtectaPickup'.default.ItemName = "[APOC] Protecta";
    class'ApocWeaponPack.ProtectaPickup'.default.ItemShortName = "[APOC] Protecta";
    class'ApocWeaponPack.ProtectaPickup'.default.PickupMessage = "You got a [APOC] Protecta.";

    class'ApocWeaponPack.Rem870EC'.default.ItemName = "[APOC] Rem870EC";
    class'ApocWeaponPack.Rem870ECPickup'.default.ItemName = "[APOC] Rem870EC";
    class'ApocWeaponPack.Rem870ECPickup'.default.ItemShortName = "[APOC] Rem870EC";
    class'ApocWeaponPack.Rem870ECPickup'.default.PickupMessage = "You got a [APOC] Rem870EC.";

    class'ApocWeaponPack.RPK47MachineGun'.default.ItemName = "[APOC] RPK-47 MachineGun";
    class'ApocWeaponPack.RPK47Pickup'.default.ItemName = "[APOC] RPK-47 MachineGun";
    class'ApocWeaponPack.RPK47Pickup'.default.ItemShortName = "[APOC] RPK-47 MachineGun";
    class'ApocWeaponPack.RPK47Pickup'.default.PickupMessage = "You got a [APOC] RPK-47 MachineGun.";

    class'ApocWeaponPack.SA80LSW'.default.ItemName = "[APOC] SA80 LSW";
    class'ApocWeaponPack.SA80LSWPickup'.default.ItemName = "[APOC] SA80 LSW";
    class'ApocWeaponPack.SA80LSWPickup'.default.ItemShortName = "[APOC] SA80 LSW";
    class'ApocWeaponPack.SA80LSWPickup'.default.PickupMessage = "You got a [APOC] SA80 LSW.";

    class'ApocWeaponPack.Saiga12c'.default.ItemName = "[APOC] Saiga-12 Shotgun";
    class'ApocWeaponPack.Saiga12cPickup'.default.ItemName = "[APOC] Saiga-12 Shotgun";
    class'ApocWeaponPack.Saiga12cPickup'.default.ItemShortName = "[APOC] Saiga-12 Shotgun";
    class'ApocWeaponPack.Saiga12cPickup'.default.PickupMessage = "You got a [APOC] Saiga-12 Shotgun.";

    class'ApocWeaponPack.SVDc'.default.ItemName = "[APOC] SVD Dragunov";
    class'ApocWeaponPack.SVDcPickup'.default.ItemName = "[APOC] SVD Dragunov";
    class'ApocWeaponPack.SVDcPickup'.default.ItemShortName = "[APOC] SVD Dragunov";
    class'ApocWeaponPack.SVDcPickup'.default.PickupMessage = "You got a [APOC] SVD Dragunov.";

    class'ApocWeaponPack.ThompsonSubmachineGun'.default.ItemName = "[APOC] Thompson M1A1";
    class'ApocWeaponPack.ThompsonPickup'.default.ItemName = "[APOC] Thompson M1A1";
    class'ApocWeaponPack.ThompsonPickup'.default.ItemShortName = "[APOC] Thompson M1A1";
    class'ApocWeaponPack.ThompsonPickup'.default.PickupMessage = "You got a [APOC] Thompson M1A1.";

    class'ApocWeaponPack.ThompsonV2SubmachineGun'.default.ItemName = "[APOC] Thompson M1928";
    class'ApocWeaponPack.ThompsonV2Pickup'.default.ItemName = "[APOC] Thompson M1928";
    class'ApocWeaponPack.ThompsonV2Pickup'.default.ItemShortName = "[APOC] Thompson M1928";
    class'ApocWeaponPack.ThompsonV2Pickup'.default.PickupMessage = "You got a [APOC] Thompson M1928.";

    class'ApocWeaponPack.UMP45SubmachineGun'.default.ItemName = "[APOC] HK UMP-45";
    class'ApocWeaponPack.UMP45Pickup'.default.ItemName = "[APOC] HK UMP-45";
    class'ApocWeaponPack.UMP45Pickup'.default.ItemShortName = "[APOC] HK UMP-45";
    class'ApocWeaponPack.UMP45Pickup'.default.PickupMessage = "You got a [APOC] HK UMP-45.";

    class'ApocWeaponPack.VALDTAssaultRifle'.default.ItemName = "[APOC] AS Val 'Shaft'";
    class'ApocWeaponPack.VALDTPickup'.default.ItemName = "[APOC] AS Val 'Shaft'";
    class'ApocWeaponPack.VALDTPickup'.default.ItemShortName = "[APOC] AS Val 'Shaft'";
    class'ApocWeaponPack.VALDTPickup'.default.PickupMessage = "You got a [APOC] AS Val 'Shaft'.";

    class'ApocWeaponPack.VSSDT'.default.ItemName = "[APOC] VSS Vintorez";
    class'ApocWeaponPack.VSSDTPickup'.default.ItemName = "[APOC] VSS Vintorez";
    class'ApocWeaponPack.VSSDTPickup'.default.ItemShortName = "[APOC] VSS Vintorez";
    class'ApocWeaponPack.VSSDTPickup'.default.PickupMessage = "You got a [APOC] VSS Vintorez.";

    class'ApocWeaponPack.ATMineExplosive'.default.ItemName = "[APOC] ATMine Explosive";
    class'ApocWeaponPack.ATMinePickup'.default.ItemName = "[APOC] ATMine Explosive";
    class'ApocWeaponPack.ATMinePickup'.default.ItemShortName = "[APOC] ATMine Explosive";
    class'ApocWeaponPack.ATMinePickup'.default.PickupMessage = "You got a [APOC] ATMine Explosive.";

    class'ApocWeaponPack.HopMineLchr'.default.ItemName = "[APOC] HopMine Launcher";
    class'ApocWeaponPack.HopMineLPickup'.default.ItemName = "[APOC] HopMine Launcher";
    class'ApocWeaponPack.HopMineLPickup'.default.ItemShortName = "[APOC] HopMine Launcher";
    class'ApocWeaponPack.HopMineLPickup'.default.PickupMessage = "You got a [APOC] HopMine Launcher.";

    class'ApocWeaponPack.Molotov'.default.ItemName = "[APOC] Molotov Cocktail";
    class'ApocWeaponPack.MolotovPickup'.default.ItemName = "[APOC] Molotov Cocktail";
    class'ApocWeaponPack.MolotovPickup'.default.ItemShortName = "[APOC] Molotov Cocktail";
    class'ApocWeaponPack.MolotovPickup'.default.PickupMessage = "You got a [APOC] Molotov Cocktail.";

    class'ApocWeaponPack.RPG'.default.ItemName = "[APOC] RPG-7";
    class'ApocWeaponPack.RPGPickup'.default.ItemName = "[APOC] RPG-7";
    class'ApocWeaponPack.RPGPickup'.default.ItemShortName = "[APOC] RPG-7";
    class'ApocWeaponPack.RPGPickup'.default.PickupMessage = "You got a [APOC] RPG-7.";
}

simulated function TranlsateRUS_REMOVED()
{
    /*
    class'ApocWeaponPack.Fomka'.default.ItemName = "[APOC] Fomka";
    class'ApocWeaponPack.FomkaPickup'.default.ItemName = "[APOC] Fomka";
    class'ApocWeaponPack.FomkaPickup'.default.ItemShortName = "[APOC] Fomka";
    class'ApocWeaponPack.FomkaPickup'.default.PickupMessage = "You got a [APOC] Fomka.";
    */
}

simulated function TranlsateCustom()
{
    /*
    ///////////////////////////////////////////////////////////////////////////
    class'ApocWeaponPack.AluminumBat'.default.ItemName = "[APOC] Aluminum Bat";
    class'ApocWeaponPack.AluminumBatPickup'.default.ItemName = "[APOC] Aluminum Bat";
    class'ApocWeaponPack.AluminumBatPickup'.default.ItemShortName = "[APOC] Aluminum Bat";
    class'ApocWeaponPack.AluminumBatPickup'.default.PickupMessage = "You got a [APOC] Aluminum Bat.";

    class'ApocWeaponPack.BastardSword'.default.ItemName = "[APOC] Bastard Sword";
    class'ApocWeaponPack.BastardPickup'.default.ItemName = "[APOC] Bastard Sword";
    class'ApocWeaponPack.BastardPickup'.default.ItemShortName = "[APOC] Bastard Sword";
    class'ApocWeaponPack.BastardPickup'.default.PickupMessage = "You got a [APOC] Bastard Sword.";

    class'ApocWeaponPack.BusterSwordd'.default.ItemName = "[APOC] Buster Sword";
    class'ApocWeaponPack.BusterSworddPickup'.default.ItemName = "[APOC] Buster Sword";
    class'ApocWeaponPack.BusterSworddPickup'.default.ItemShortName = "[APOC] Buster Sword";
    class'ApocWeaponPack.BusterSworddPickup'.default.PickupMessage = "You got a [APOC] Buster Sword.";

    class'ApocWeaponPack.Chainsword'.default.ItemName = "[APOC] Chainsword";
    class'ApocWeaponPack.ChainswordPickup'.default.ItemName = "[APOC] Chainsword";
    class'ApocWeaponPack.ChainswordPickup'.default.ItemShortName = "[APOC] Chainsword";
    class'ApocWeaponPack.ChainswordPickup'.default.PickupMessage = "You got a [APOC] Chainsword";

    class'ApocWeaponPack.Crystal'.default.ItemName = "[APOC] Crystal Sword";
    class'ApocWeaponPack.CrystalPickup'.default.ItemName = "[APOC] Crystal Sword";
    class'ApocWeaponPack.CrystalPickup'.default.ItemShortName = "[APOC] Crystal Sword";
    class'ApocWeaponPack.CrystalPickup'.default.PickupMessage = "You got a [APOC] Crystal Sword.";

    class'ApocWeaponPack.Fleshpounders'.default.ItemName = "[APOC] Fleshpounders";
    class'ApocWeaponPack.FleshpoundersPickup'.default.ItemName = "[APOC] Fleshpounders";
    class'ApocWeaponPack.FleshpoundersPickup'.default.ItemShortName = "[APOC] Fleshpounders";
    class'ApocWeaponPack.FleshpoundersPickup'.default.PickupMessage = "You got a [APOC] Fleshpounders.";

    class'ApocWeaponPack.FlyingV'.default.ItemName = "[APOC] FlyingV";
    class'ApocWeaponPack.FlyingVPickup'.default.ItemName = "[APOC] FlyingV";
    class'ApocWeaponPack.FlyingVPickup'.default.ItemShortName = "[APOC] FlyingV";
    class'ApocWeaponPack.FlyingVPickup'.default.PickupMessage = "You got a [APOC] FlyingV.";

    class'ApocWeaponPack.Gensho'.default.ItemName = "[APOC] Gensho Sword";
    class'ApocWeaponPack.GenshoPickup'.default.ItemName = "[APOC] Gensho Sword";
    class'ApocWeaponPack.GenshoPickup'.default.ItemShortName = "[APOC] Gensho Sword";
    class'ApocWeaponPack.GenshoPickup'.default.PickupMessage = "You got a [APOC] Gensho Sword.";

    class'ApocWeaponPack.Godai'.default.ItemName = "[APOC] Godai";
    class'ApocWeaponPack.GodaiPickup'.default.ItemName = "[APOC] Godai";
    class'ApocWeaponPack.GodaiPickup'.default.ItemShortName = "[APOC] Godai";
    class'ApocWeaponPack.GodaiPickup'.default.PickupMessage = "You got a [APOC] Godai.";

    class'ApocWeaponPack.HOR'.default.ItemName = "[APOC] Hammer of Retribution";
    class'ApocWeaponPack.HORPickup'.default.ItemName = "[APOC] Hammer of Retribution";
    class'ApocWeaponPack.HORPickup'.default.ItemShortName = "[APOC] Hammer of Retribution";
    class'ApocWeaponPack.HORPickup'.default.PickupMessage = "You got a [APOC] Hammer of Retribution.";

    class'ApocWeaponPack.Machete'.default.ItemName = "[APOC] Machete";
    class'ApocWeaponPack.MachetePickup'.default.ItemName = "[APOC] Machete";
    class'ApocWeaponPack.MachetePickup'.default.ItemShortName = "[APOC] Machete";
    class'ApocWeaponPack.MachetePickup'.default.PickupMessage = "You got a [APOC] Machete.";

    class'ApocWeaponPack.MackDaddy'.default.ItemName = "[APOC] MackDaddy";
    class'ApocWeaponPack.MackDaddyPickup'.default.ItemName = "[APOC] MackDaddy";
    class'ApocWeaponPack.MackDaddyPickup'.default.ItemShortName = "[APOC] MackDaddy";
    class'ApocWeaponPack.MackDaddyPickup'.default.PickupMessage = "You got a [APOC] MackDaddy.";

    class'ApocWeaponPack.NewMachete'.default.ItemName = "[APOC] New-Machete";
    class'ApocWeaponPack.NewMachetePickup'.default.ItemName = "[APOC] New-Machete";
    class'ApocWeaponPack.NewMachetePickup'.default.ItemShortName = "[APOC] New-Machete";
    class'ApocWeaponPack.NewMachetePickup'.default.PickupMessage = "You got a [APOC] New-Machete.";

    class'ApocWeaponPack.NWAR'.default.ItemName = "[APOC] Nordic War Axe";
    class'ApocWeaponPack.NWARPickup'.default.ItemName = "[APOC] Nordic War Axe";
    class'ApocWeaponPack.NWARPickup'.default.ItemShortName = "[APOC] Nordic War Axe";
    class'ApocWeaponPack.NWARPickup'.default.PickupMessage = "You got a [APOC] Nordic War Axe.";

    class'ApocWeaponPack.OmniBlade'.default.ItemName = "[APOC] Omni Blade";
    class'ApocWeaponPack.OmniBladePickup'.default.ItemName = "[APOC] Omni Blade";
    class'ApocWeaponPack.OmniBladePickup'.default.ItemShortName = "[APOC] Omni Blade";
    class'ApocWeaponPack.OmniBladePickup'.default.PickupMessage = "You got a [APOC] Omni Blade.";

    class'ApocWeaponPack.Razor'.default.ItemName = "[APOC] Razor Sword";
    class'ApocWeaponPack.RazorPickup'.default.ItemName = "[APOC] Razor Sword";
    class'ApocWeaponPack.RazorPickup'.default.ItemShortName = "[APOC] Razor Sword";
    class'ApocWeaponPack.RazorPickup'.default.PickupMessage = "You got a [APOC] Razor Sword.";

    class'ApocWeaponPack.Yoshimitsu'.default.ItemName = "[APOC] Yoshimitsu";
    class'ApocWeaponPack.YoshimitsuPickup'.default.ItemName = "[APOC] Yoshimitsu";
    class'ApocWeaponPack.YoshimitsuPickup'.default.ItemShortName = "[APOC] Yoshimitsu";
    class'ApocWeaponPack.YoshimitsuPickup'.default.PickupMessage = "You got a [APOC] Yoshimitsu.";

    class'ApocWeaponPack.Zabuzas'.default.ItemName = "[APOC] Zabuzas Sword";
    class'ApocWeaponPack.ZabuzasPickup'.default.ItemName = "[APOC] Zabuzas Sword";
    class'ApocWeaponPack.ZabuzasPickup'.default.ItemShortName = "[APOC] Zabuzas Sword";
    class'ApocWeaponPack.ZabuzasPickup'.default.PickupMessage = "You got a [APOC] Zabuzas Sword.";

    ///////////////////////////////////////////////////////////////////////////
    class'ApocWeaponPack.AAR525AssaultRifle'.default.ItemName = "[APOC] AAR525 AssaultRifle";
    class'ApocWeaponPack.AAR525Pickup'.default.ItemName = "[APOC] AAR525 AssaultRifle";
    class'ApocWeaponPack.AAR525Pickup'.default.ItemShortName = "[APOC] AAR525 AssaultRifle";
    class'ApocWeaponPack.AAR525Pickup'.default.PickupMessage = "You got a [APOC] AAR525 AssaultRifle.";

    class'ApocWeaponPack.AAR525S'.default.ItemName = "[APOC] AAR525S";
    class'ApocWeaponPack.AAR525SPickup'.default.ItemName = "[APOC] AAR525S";
    class'ApocWeaponPack.AAR525SPickup'.default.ItemShortName = "[APOC] AAR525S";
    class'ApocWeaponPack.AAR525SPickup'.default.PickupMessage = "You got a [APOC] AAR525S.";

    class'ApocWeaponPack.AEK971AssaultRifle'.default.ItemName = "[APOC] AEK-971 AssaultRifle";
    class'ApocWeaponPack.AEK971Pickup'.default.ItemName = "[APOC] AEK-971 AssaultRifle";
    class'ApocWeaponPack.AEK971Pickup'.default.ItemShortName = "[APOC] AEK-971 AssaultRifle";
    class'ApocWeaponPack.AEK971Pickup'.default.PickupMessage = "You got a [APOC] AEK-971 AssaultRifle.";

    class'ApocWeaponPack.AK47LLIAssaultRifle'.default.ItemName = "[APOC] AK-47 AssaultRifle";
    class'ApocWeaponPack.AK47LLIPickup'.default.ItemName = "[APOC] AK-47 AssaultRifle";
    class'ApocWeaponPack.AK47LLIPickup'.default.ItemShortName = "[APOC] AK-47 AssaultRifle";
    class'ApocWeaponPack.AK47LLIPickup'.default.PickupMessage = "You got a [APOC] AK-47 AssaultRifle.";

    class'ApocWeaponPack.Ak47_CoDBO'.default.ItemName = "[APOC] AK-47 (CoD-BO)";
    class'ApocWeaponPack.Ak47_CoDBOPickup'.default.ItemName = "[APOC] AK-47 (CoD-BO)";
    class'ApocWeaponPack.Ak47_CoDBOPickup'.default.ItemShortName = "[APOC] AK-47 (CoD-BO)";
    class'ApocWeaponPack.Ak47_CoDBOPickup'.default.PickupMessage = "You got a [APOC] AK-47 (CoD-BO).";

    class'ApocWeaponPack.AK47_RD_HMAssaultRifle'.default.ItemName = "[APOC] AK-47 (RDHM)";
    class'ApocWeaponPack.AK47_RD_HMPickup'.default.ItemName = "[APOC] AK-47 (RDHM)";
    class'ApocWeaponPack.AK47_RD_HMPickup'.default.ItemShortName = "[APOC] AK-47 (RDHM)";
    class'ApocWeaponPack.AK47_RD_HMPickup'.default.PickupMessage = "You got a [APOC] AK-47 (RDHM).";

    class'ApocWeaponPack.AKS74ULLIAssaultRifle'.default.ItemName = "[APOC] AKS-74 AssaultRifle.";
    class'ApocWeaponPack.AKS74ULLIPickup'.default.ItemName = "[APOC] AKS-74 AssaultRifle";
    class'ApocWeaponPack.AKS74ULLIPickup'.default.ItemShortName = "[APOC] AKS-74 AssaultRifle";
    class'ApocWeaponPack.AKS74ULLIPickup'.default.PickupMessage = "You got a [APOC] AKS-74 AssaultRifle.";

    class'ApocWeaponPack.F2000'.default.ItemName = "[APOC] F2000wep AssaultRifle";
    class'ApocWeaponPack.F2000Pickup'.default.ItemName = "[APOC] F2000wep AssaultRifle";
    class'ApocWeaponPack.F2000Pickup'.default.ItemShortName = "[APOC] F2000wep AssaultRifle";
    class'ApocWeaponPack.F2000Pickup'.default.PickupMessage = "You got a [APOC] F2000wep AssaultRifle.";

    class'ApocWeaponPack.FMX_SCARLAssaultRifle'.default.ItemName = "[APOC] FMX SCAR-L AssaultRifle";
    class'ApocWeaponPack.FMX_SCARLPickup'.default.ItemName = "[APOC] FMX SCAR-L AssaultRifle";
    class'ApocWeaponPack.FMX_SCARLPickup'.default.ItemShortName = "[APOC] FMX SCAR-L AssaultRifle";
    class'ApocWeaponPack.FMX_SCARLPickup'.default.PickupMessage = "You got a [APOC] FMX SCAR-L AssaultRifle.";

    class'ApocWeaponPack.G36CAssaultRifle'.default.ItemName = "[APOC] G36C AssaultRifle";
    class'ApocWeaponPack.G36CPickup'.default.ItemName = "[APOC] G36C AssaultRifle";
    class'ApocWeaponPack.G36CPickup'.default.ItemShortName = "[APOC] G36C AssaultRifle";
    class'ApocWeaponPack.G36CPickup'.default.PickupMessage = "You got a [APOC] G36C AssaultRifle.";

    class'ApocWeaponPack.G36_STALKER'.default.ItemName = "[APOC] G36 STALKER";
    class'ApocWeaponPack.G36_STALKERPickup'.default.ItemName = "[APOC] G36 STALKER";
    class'ApocWeaponPack.G36_STALKERPickup'.default.ItemShortName = "[APOC] G36 STALKER";
    class'ApocWeaponPack.G36_STALKERPickup'.default.PickupMessage = "You got a [APOC] G36 STALKER.";

    class'ApocWeaponPack.GPMG'.default.ItemName = "[APOC] GPMG";
    class'ApocWeaponPack.GPMGPickup'.default.ItemName = "[APOC] GPMG";
    class'ApocWeaponPack.GPMGPickup'.default.ItemShortName = "[APOC] GPMG";
    class'ApocWeaponPack.GPMGPickup'.default.PickupMessage = "You got a [APOC] GPMG.";

    class'ApocWeaponPack.HomeMadeppshAssaultRifle'.default.ItemName = "[APOC] HomeMadeppsh AssaultRifle";
    class'ApocWeaponPack.HomeMadeppshPickup'.default.ItemName = "[APOC] HomeMadeppsh AssaultRifle";
    class'ApocWeaponPack.HomeMadeppshPickup'.default.ItemShortName = "[APOC] HomeMadeppsh AssaultRifle";
    class'ApocWeaponPack.HomeMadeppshPickup'.default.PickupMessage = "You got a [APOC] HomeMadeppsh AssaultRifle.";

    class'ApocWeaponPack.IAFARAssaultRifle'.default.ItemName = "[APOC] IAFAR AssaultRifle";
    class'ApocWeaponPack.IAFARPickup'.default.ItemName = "[APOC] IAFAR AssaultRifle";
    class'ApocWeaponPack.IAFARPickup'.default.ItemShortName = "[APOC] IAFAR AssaultRifle";
    class'ApocWeaponPack.IAFARPickup'.default.PickupMessage = "You got a [APOC] IAFAR AssaultRifle.";

    class'ApocWeaponPack.M4A1_COD'.default.ItemName = "[APOC] M4A1 (CoD)";
    class'ApocWeaponPack.M4A1_CODPickup'.default.ItemName = "[APOC] M4A1 (CoD)";
    class'ApocWeaponPack.M4A1_CODPickup'.default.ItemShortName = "[APOC] M4A1 (CoD)";
    class'ApocWeaponPack.M4A1_CODPickup'.default.PickupMessage = "You got a [APOC] M4A1 (CoD).";

    class'ApocWeaponPack.PDW'.default.ItemName = "[APOC] KAC PDW";
    class'ApocWeaponPack.PDWPickup'.default.ItemName = "[APOC] KAC PDW";
    class'ApocWeaponPack.PDWPickup'.default.ItemShortName = "[APOC] KAC PDW";
    class'ApocWeaponPack.PDWPickup'.default.PickupMessage = "You got a [APOC] KAC PDW.";

    class'ApocWeaponPack.SG552_Tactic'.default.ItemName = "[APOC] SG552 Tactics";
    class'ApocWeaponPack.SG552_TacticPickup'.default.ItemName = "[APOC] SG552 Tactics";
    class'ApocWeaponPack.SG552_TacticPickup'.default.ItemShortName = "[APOC] SG552 Tactics";
    class'ApocWeaponPack.SG552_TacticPickup'.default.PickupMessage = "You got a [APOC] SG552 Tactics.";

    class'ApocWeaponPack.Slayer_AUG'.default.ItemName = "[APOC] Slayer AUG";
    class'ApocWeaponPack.Slayer_AUGPickup'.default.ItemName = "[APOC] Slayer AUG";
    class'ApocWeaponPack.Slayer_AUGPickup'.default.ItemShortName = "[APOC] Slayer AUG";
    class'ApocWeaponPack.Slayer_AUGPickup'.default.PickupMessage = "You got a [APOC] Slayer AUG.";

    class'ApocWeaponPack.TactThom'.default.ItemName = "[APOC] Tactics Thompson";
    class'ApocWeaponPack.TactThomPickup'.default.ItemName = "[APOC] Tactics Thompson";
    class'ApocWeaponPack.TactThomPickup'.default.ItemShortName = "[APOC] Tactics Thompson";
    class'ApocWeaponPack.TactThomPickup'.default.PickupMessage = "You got a [APOC] Tactics Thompson.";

    class'ApocWeaponPack.Type19'.default.ItemName = "[APOC] Type-19";
    class'ApocWeaponPack.Type19Pickup'.default.ItemName = "[APOC] Type-19";
    class'ApocWeaponPack.Type19Pickup'.default.ItemShortName = "[APOC] Type-19";
    class'ApocWeaponPack.Type19Pickup'.default.PickupMessage = "You got a [APOC] Type-19.";

    class'ApocWeaponPack.XM8'.default.ItemName = "[APOC] XM8 Rifle";
    class'ApocWeaponPack.XM8Pickup'.default.ItemName = "[APOC] XM8 Rifle";
    class'ApocWeaponPack.XM8Pickup'.default.ItemShortName = "[APOC] XM8 Rifle";
    class'ApocWeaponPack.XM8Pickup'.default.PickupMessage = "You got a [APOC] XM8 Rifle.";

    ///////////////////////////////////////////////////////////////////////////

    class'ApocWeaponPack.M320GrenadeLauncher'.default.ItemName = "[APOC] M320 GrenadeLauncher";
    class'ApocWeaponPack.M320Pickup'.default.ItemName = "[APOC] M320 GrenadeLauncher";
    class'ApocWeaponPack.M320Pickup'.default.ItemShortName = "[APOC] M320 GrenadeLauncher";
    class'ApocWeaponPack.M320Pickup'.default.PickupMessage = "You got a [APOC] M320 GrenadeLauncher.";

    ///////////////////////////////////////////////////////////////////////////
    class'ApocWeaponPack.Graza'.default.ItemName = "[APOC] Graza";
    class'ApocWeaponPack.GrazaPickup'.default.ItemName = "[APOC] Graza";
    class'ApocWeaponPack.GrazaPickup'.default.ItemShortName = "[APOC] Graza";
    class'ApocWeaponPack.GrazaPickup'.default.PickupMessage = "You got a [APOC] Graza.";

    class'ApocWeaponPack.MP5A4_EoTech'.default.ItemName = "[APOC] MP5A4 EoTech";
    class'ApocWeaponPack.MP5A4_EoTechPickup'.default.ItemName = "[APOC] MP5A4 EoTech";
    class'ApocWeaponPack.MP5A4_EoTechPickup'.default.ItemShortName = "[APOC] MP5A4 EoTech";
    class'ApocWeaponPack.MP5A4_EoTechPickup'.default.PickupMessage = "You got a [APOC] MP5A4 EoTech.";

    class'ApocWeaponPack.MP5A4_MedGun'.default.ItemName = "[APOC] MP5A4 MedGun";
    class'ApocWeaponPack.MP5A4_MedGunPickup'.default.ItemName = "[APOC] MP5A4 MedGun";
    class'ApocWeaponPack.MP5A4_MedGunPickup'.default.ItemShortName = "[APOC] MP5A4 MedGun";
    class'ApocWeaponPack.MP5A4_MedGunPickup'.default.PickupMessage = "You got a [APOC] MP5A4 MedGun.";

    class'ApocWeaponPack.MP5SD'.default.ItemName = "[APOC] MP5SD";
    class'ApocWeaponPack.MP5SDPickup'.default.ItemName = "[APOC] MP5SD";
    class'ApocWeaponPack.MP5SDPickup'.default.ItemShortName = "[APOC] MP5SD";
    class'ApocWeaponPack.MP5SDPickup'.default.PickupMessage = "You got a [APOC] MP5SD.";

    class'ApocWeaponPack.MP7Dual'.default.ItemName = "[APOC] MP7Dual";
    class'ApocWeaponPack.MP7DPickup'.default.ItemName = "[APOC] MP7Dual";
    class'ApocWeaponPack.MP7DPickup'.default.ItemShortName = "[APOC] MP7Dual";
    class'ApocWeaponPack.MP7DPickup'.default.PickupMessage = "You got a [APOC] MP7Dual.";

    class'ApocWeaponPack.PPSH41x'.default.ItemName = "[APOC] PPSH41x";
    class'ApocWeaponPack.PPSHPickup'.default.ItemName = "[APOC] PPSH41x";
    class'ApocWeaponPack.PPSHPickup'.default.ItemShortName = "[APOC] PPSH41x";
    class'ApocWeaponPack.PPSHPickup'.default.PickupMessage = "You got a [APOC] PPSH41x.";

    class'ApocWeaponPack.WMediShot'.default.ItemName = "[APOC] WMediShot";
    class'ApocWeaponPack.WMediShotPickup'.default.ItemName = "[APOC] WMediShot";
    class'ApocWeaponPack.WMediShotPickup'.default.ItemShortName = "[APOC] WMediShot";
    class'ApocWeaponPack.WMediShotPickup'.default.PickupMessage = "You got a [APOC] WMediShot.";

    ///////////////////////////////////////////////////////////////////////////
    class'ApocWeaponPack.FireBombExplosive'.default.ItemName = "[APOC] FireBomb Explosive";
    class'ApocWeaponPack.FireBombPickup'.default.ItemName = "[APOC] FireBomb Explosive";
    class'ApocWeaponPack.FireBombPickup'.default.ItemShortName = "[APOC] FireBomb Explosive";
    class'ApocWeaponPack.FireBombPickup'.default.PickupMessage = "You got a [APOC] FireBomb Explosive.";

    class'ApocWeaponPack.FlameBoomStick'.default.ItemName = "[APOC] FlameBoomStick";
    class'ApocWeaponPack.FlameBoomStickPickup'.default.ItemName = "[APOC] FlameBoomStick";
    class'ApocWeaponPack.FlameBoomStickPickup'.default.ItemShortName = "[APOC] FlameBoomStick";
    class'ApocWeaponPack.FlameBoomStickPickup'.default.PickupMessage = "You got a [APOC] FlameBoomStick.";

    class'ApocWeaponPack.FlameBullpup'.default.ItemName = "[APOC] FlameBullpup";
    class'ApocWeaponPack.FlameBullpupPickup'.default.ItemName = "[APOC] FlameBullpup";
    class'ApocWeaponPack.FlameBullpupPickup'.default.ItemShortName = "[APOC] FlameBullpup";
    class'ApocWeaponPack.FlameBullpupPickup'.default.PickupMessage = "You got a [APOC] FlameBullpup.";

    class'ApocWeaponPack.FlameCrossbow'.default.ItemName = "[APOC] FlameCrossbow";
    class'ApocWeaponPack.FlameCrossbowPickup'.default.ItemName = "[APOC] FlameCrossbow";
    class'ApocWeaponPack.FlameCrossbowPickup'.default.ItemShortName = "[APOC] FlameCrossbow";
    class'ApocWeaponPack.FlameCrossbowPickup'.default.PickupMessage = "You got a [APOC] FlameCrossbow.";

    class'ApocWeaponPack.FlameDeagle'.default.ItemName = "[APOC] FlameDeagle";
    class'ApocWeaponPack.FlameDeaglePickup'.default.ItemName = "[APOC] FlameDeagle";
    class'ApocWeaponPack.FlameDeaglePickup'.default.ItemShortName = "[APOC] FlameDeagle";
    class'ApocWeaponPack.FlameDeaglePickup'.default.PickupMessage = "You got a [APOC] FlameDeagle.";

    class'ApocWeaponPack.FlameDualDeagle'.default.ItemName = "[APOC] FlameDualDeagle";
    class'ApocWeaponPack.FlameDualDeaglePickup'.default.ItemName = "[APOC] FlameDualDeagle";
    class'ApocWeaponPack.FlameDualDeaglePickup'.default.ItemShortName = "[APOC] FlameDualDeagle";
    class'ApocWeaponPack.FlameDualDeaglePickup'.default.PickupMessage = "You got a [APOC] FlameDualDeagle.";

    class'ApocWeaponPack.FlameDualies'.default.ItemName = "[APOC] FlameDualies";
    class'ApocWeaponPack.FlameDualiesPickup'.default.ItemName = "[APOC] FlameDualies";
    class'ApocWeaponPack.FlameDualiesPickup'.default.ItemShortName = "[APOC] FlameDualies";
    class'ApocWeaponPack.FlameDualiesPickup'.default.PickupMessage = "You got a [APOC] FlameDualies.";

    class'ApocWeaponPack.FlameLAW'.default.ItemName = "[APOC] FlameLAW";
    class'ApocWeaponPack.FlameLAWPickup'.default.ItemName = "[APOC] FlameLAW";
    class'ApocWeaponPack.FlameLAWPickup'.default.ItemShortName = "[APOC] FlameLAW";
    class'ApocWeaponPack.FlameLAWPickup'.default.PickupMessage = "You got a [APOC] FlameLAW.";

    class'ApocWeaponPack.FlameShotgun'.default.ItemName = "[APOC] FlameShotgun";
    class'ApocWeaponPack.FlameShotgunPickup'.default.ItemName = "[APOC] FlameShotgun";
    class'ApocWeaponPack.FlameShotgunPickup'.default.ItemShortName = "[APOC] FlameShotgun";
    class'ApocWeaponPack.FlameShotgunPickup'.default.PickupMessage = "You got a [APOC] FlameShotgun.";

    class'ApocWeaponPack.FlameSingle'.default.ItemName = "[APOC] FlameSingle";
    class'ApocWeaponPack.FlameSinglePickup'.default.ItemName = "[APOC] FlameSingle";
    class'ApocWeaponPack.FlameSinglePickup'.default.ItemShortName = "[APOC] FlameSingle";
    class'ApocWeaponPack.FlameSinglePickup'.default.PickupMessage = "You got a [APOC] FlameSingle.";

    class'ApocWeaponPack.FlameWinchester'.default.ItemName = "[APOC] FlameWinchester";
    class'ApocWeaponPack.FlameWinchesterPickup'.default.ItemName = "[APOC] FlameWinchester";
    class'ApocWeaponPack.FlameWinchesterPickup'.default.ItemShortName = "[APOC] FlameWinchester";
    class'ApocWeaponPack.FlameWinchesterPickup'.default.PickupMessage = "You got a [APOC] FlameWinchester.";

    class'ApocWeaponPack.KRISSSV'.default.ItemName = "[APOC] KRISSSV";
    class'ApocWeaponPack.KRISSSVPickup'.default.ItemName = "[APOC] KRISSSV";
    class'ApocWeaponPack.KRISSSVPickup'.default.ItemShortName = "[APOC] KRISSSV";
    class'ApocWeaponPack.KRISSSVPickup'.default.PickupMessage = "You got a [APOC] KRISSSV.";

    class'ApocWeaponPack.M4RIS'.default.ItemName = "[APOC] M4RIS";
    class'ApocWeaponPack.M4RISPickup'.default.ItemName = "[APOC] M4RIS";
    class'ApocWeaponPack.M4RISPickup'.default.ItemShortName = "[APOC] M4RIS";
    class'ApocWeaponPack.M4RISPickup'.default.PickupMessage = "You got a [APOC] M4RIS.";

    class'ApocWeaponPack.Mk11SR'.default.ItemName = "[APOC] SR-25";
    class'ApocWeaponPack.Mk11SRPickup'.default.ItemName = "[APOC] SR-25";
    class'ApocWeaponPack.Mk11SRPickup'.default.ItemShortName = "[APOC] SR-25";
    class'ApocWeaponPack.Mk11SRPickup'.default.PickupMessage = "You got a [APOC] SR-25.";

    class'ApocWeaponPack.ThompsonIncSMG'.default.ItemName = "[APOC] ThompsonIncSMG";
    class'ApocWeaponPack.ThompsonIncPickup'.default.ItemName = "[APOC] ThompsonIncSMG";
    class'ApocWeaponPack.ThompsonIncPickup'.default.ItemShortName = "[APOC] ThompsonIncSMG";
    class'ApocWeaponPack.ThompsonIncPickup'.default.PickupMessage = "You got a [APOC] ThompsonIncSMG.";

    class'ApocWeaponPack.UMP45LLI'.default.ItemName = "[APOC] HK UMP-45";
    class'ApocWeaponPack.UMP45LLIPickup'.default.ItemName = "[APOC] HK UMP-45";
    class'ApocWeaponPack.UMP45LLIPickup'.default.ItemShortName = "[APOC] UMP-45";
    class'ApocWeaponPack.UMP45LLIPickup'.default.PickupMessage = "You got a [APOC] HK UMP-45.";

    class'ApocWeaponPack.Winchester'.default.ItemName = "[APOC] Winchester";
    class'ApocWeaponPack.WinchesterPickup'.default.ItemName = "[APOC] Winchester";
    class'ApocWeaponPack.WinchesterPickup'.default.ItemShortName = "[APOC] Winchester";
    class'ApocWeaponPack.WinchesterPickup'.default.PickupMessage = "You got a [APOC] Winchester.";

    ///////////////////////////////////////////////////////////////////////////

    class'ApocWeaponPack.AS50SniperRifle'.default.ItemName = "[APOC] AS50 Sniper Rifle";
    class'ApocWeaponPack.AS50Pickup'.default.ItemName = "[APOC] AS50 Sniper Rifle";
    class'ApocWeaponPack.AS50Pickup'.default.ItemShortName = "[APOC] AS50 Sniper Rifle";
    class'ApocWeaponPack.AS50Pickup'.default.PickupMessage = "You got a [APOC] AS50 Sniper Rifle.";

    class'ApocWeaponPack.AutoSv4'.default.ItemName = "[APOC] AutoSv4";
    class'ApocWeaponPack.AutoSv4Pickup'.default.ItemName = "[APOC] AutoSv4";
    class'ApocWeaponPack.AutoSv4Pickup'.default.ItemShortName = "[APOC] AutoSv4";
    class'ApocWeaponPack.AutoSv4Pickup'.default.PickupMessage = "You got a [APOC] AutoSv4.";

    class'ApocWeaponPack.Barret_M98_Bravo'.default.ItemName = "[APOC] Barret M98 Bravo";
    class'ApocWeaponPack.Barret_M98_BravoPickup'.default.ItemName = "[APOC] Barret M98 Bravo";
    class'ApocWeaponPack.Barret_M98_BravoPickup'.default.ItemShortName = "[APOC] Barret M98 Bravo";
    class'ApocWeaponPack.Barret_M98_BravoPickup'.default.PickupMessage = "You got a [APOC] Barret M98 Bravo.";

    class'ApocWeaponPack.Barret_M98_Bravo_camo'.default.ItemName = "[APOC] Barret M98 Bravo camo";
    class'ApocWeaponPack.Barret_M98_BravoPickup_camo'.default.ItemName = "[APOC] Barret M98 Bravo camo";
    class'ApocWeaponPack.Barret_M98_BravoPickup_camo'.default.ItemShortName = "[APOC] Barret M98 Bravo camo";
    class'ApocWeaponPack.Barret_M98_BravoPickup_camo'.default.PickupMessage = "You got a [APOC] Barret M98 Bravo camo.";

    class'ApocWeaponPack.GaussRifle'.default.ItemName = "[APOC] Gauss Rifle";
    class'ApocWeaponPack.GaussRiflePickup'.default.ItemName = "[APOC] Gauss Rifle";
    class'ApocWeaponPack.GaussRiflePickup'.default.ItemShortName = "[APOC] Gauss Rifle";
    class'ApocWeaponPack.GaussRiflePickup'.default.PickupMessage = "You got a [APOC] Gauss Rifle.";

    class'ApocWeaponPack.Hunting_Rifle'.default.ItemName = "[APOC] Hunting Rifle";
    class'ApocWeaponPack.Hunting_RiflePickup'.default.ItemName = "[APOC] Hunting Rifle";
    class'ApocWeaponPack.Hunting_RiflePickup'.default.ItemShortName = "[APOC] Hunting Rifle";
    class'ApocWeaponPack.Hunting_RiflePickup'.default.PickupMessage = "You got a [APOC] Hunting Rifle.";

    class'ApocWeaponPack.L96AWPLLI'.default.ItemName = "[APOC] L96AWP";
    class'ApocWeaponPack.L96AWPLLIPickup'.default.ItemName = "[APOC] L96AWP";
    class'ApocWeaponPack.L96AWPLLIPickup'.default.ItemShortName = "[APOC] L96AWP";
    class'ApocWeaponPack.L96AWPLLIPickup'.default.PickupMessage = "You got a [APOC] L96AWP.";

    class'ApocWeaponPack.m21_Cod'.default.ItemName = "[APOC] M21 Cod";
    class'ApocWeaponPack.m21_CodPickup'.default.ItemName = "[APOC] M21 Cod";
    class'ApocWeaponPack.m21_CodPickup'.default.ItemShortName = "[APOC] M21 Cod";
    class'ApocWeaponPack.m21_CodPickup'.default.PickupMessage = "You got a [APOC] M21 Cod.";

    class'ApocWeaponPack.M82A1LLI'.default.ItemName = "[APOC] M82A1";
    class'ApocWeaponPack.M82A1LLIPickup'.default.ItemName = "[APOC] M82A1";
    class'ApocWeaponPack.M82A1LLIPickup'.default.ItemShortName = "[APOC] M82A1";
    class'ApocWeaponPack.M82A1LLIPickup'.default.PickupMessage = "You got a [APOC] M82A1.";

    class'ApocWeaponPack.MosinNagant'.default.ItemName = "[APOC] MosinNagant";
    class'ApocWeaponPack.MosinNagantPickup'.default.ItemName = "[APOC] MosinNagant";
    class'ApocWeaponPack.MosinNagantPickup'.default.ItemShortName = "[APOC] MosinNagant";
    class'ApocWeaponPack.MosinNagantPickup'.default.PickupMessage = "You got a [APOC] MosinNagant.";

    class'ApocWeaponPack.SV98SniperRifle'.default.ItemName = "[APOC] SV98 SniperRifle";
    class'ApocWeaponPack.SV98Pickup'.default.ItemName = "[APOC] SV98 SniperRifle";
    class'ApocWeaponPack.SV98Pickup'.default.ItemShortName = "[APOC] SV98 SniperRifle";
    class'ApocWeaponPack.SV98Pickup'.default.PickupMessage = "You got a [APOC] SV98 SniperRifle.";

    class'ApocWeaponPack.SVDLLI'.default.ItemName = "[APOC] SVD Dragunov";
    class'ApocWeaponPack.SVDLLIPickup'.default.ItemName = "[APOC] SVD Dragunov";
    class'ApocWeaponPack.SVDLLIPickup'.default.ItemShortName = "[APOC] SVD Dragunov";
    class'ApocWeaponPack.SVDLLIPickup'.default.PickupMessage = "You got a [APOC] SVD Dragunov.";

    class'ApocWeaponPack.V94LLI'.default.ItemName = "[APOC] V94";
    class'ApocWeaponPack.V94LLIPickup'.default.ItemName = "[APOC] V94";
    class'ApocWeaponPack.V94LLIPickup'.default.ItemShortName = "[APOC] V94";
    class'ApocWeaponPack.V94LLIPickup'.default.PickupMessage = "You got a [APOC] V94.";

    ///////////////////////////////////////////////////////////////////////////
    class'ApocWeaponPack.BSshort'.default.ItemName = "[APOC] BSshort";
    class'ApocWeaponPack.BSshortPickup'.default.ItemName = "[APOC] BSshort";
    class'ApocWeaponPack.BSshortPickup'.default.ItemShortName = "[APOC] BSshort";
    class'ApocWeaponPack.BSshortPickup'.default.PickupMessage = "You got a [APOC] BSshort.";

    class'ApocWeaponPack.D3Shotgun'.default.ItemName = "[APOC] UAC Shotgun";
    class'ApocWeaponPack.D3ShotgunPickup'.default.ItemName = "[APOC] UAC Shotgun";
    class'ApocWeaponPack.D3ShotgunPickup'.default.ItemShortName = "[APOC] UAC Shotgun";
    class'ApocWeaponPack.D3ShotgunPickup'.default.PickupMessage = "You got a [APOC] UAC Shotgun.";

    class'ApocWeaponPack.LilithKiss'.default.ItemName = "[APOC] Lilith's Kisses";
    class'ApocWeaponPack.LilithKissPickup'.default.ItemName = "[APOC] Lilith's Kisses";
    class'ApocWeaponPack.LilithKissPickup'.default.ItemShortName = "[APOC] Lilith's Kisses";
    class'ApocWeaponPack.LilithKissPickup'.default.PickupMessage = "You got a [APOC] Lilith's Kisses.";

    class'ApocWeaponPack.Q3Shotgun'.default.ItemName = "[APOC] Arena Shotgun";
    class'ApocWeaponPack.Q3ShotgunPickup'.default.ItemName = "[APOC] Arena Shotgun";
    class'ApocWeaponPack.Q3ShotgunPickup'.default.ItemShortName = "[APOC] Arena Shotgun";
    class'ApocWeaponPack.Q3ShotgunPickup'.default.PickupMessage = "You got a [APOC] Arena Shotgun.";

    class'ApocWeaponPack.USAS12_V3'.default.ItemName = "[APOC] USAS12 V3";
    class'ApocWeaponPack.USAS12_V3Pickup'.default.ItemName = "[APOC] USAS12 V3";
    class'ApocWeaponPack.USAS12_V3Pickup'.default.ItemShortName = "[APOC] USAS12 V3";
    class'ApocWeaponPack.USAS12_V3Pickup'.default.PickupMessage = "You got a [APOC] USAS12 V3.";

    class'ApocWeaponPack.W1300_Compact_Edition'.default.ItemName = "[APOC] W1300 Compact Edition";
    class'ApocWeaponPack.W1300_Compact_EditionPickup'.default.ItemName = "[APOC] W1300 Compact Edition";
    class'ApocWeaponPack.W1300_Compact_EditionPickup'.default.ItemShortName = "[APOC] W1300 Compact Edition";
    class'ApocWeaponPack.W1300_Compact_EditionPickup'.default.PickupMessage = "You got a [APOC] W1300 Compact Edition.";

    class'ApocWeaponPack.WeldShot'.default.ItemName = "[APOC] WeldShot";
    class'ApocWeaponPack.WeldShotPickup'.default.ItemName = "[APOC] WeldShot";
    class'ApocWeaponPack.WeldShotPickup'.default.ItemShortName = "[APOC] WeldShot";
    class'ApocWeaponPack.WeldShotPickup'.default.PickupMessage = "You got a [APOC] WeldShot.";
    */
}

defaultproperties
{
    Role=ROLE_Authority
    bAlwaysRelevant=true
    RemoteRole=ROLE_SimulatedProxy
    bAddToServerPackages=True
}
