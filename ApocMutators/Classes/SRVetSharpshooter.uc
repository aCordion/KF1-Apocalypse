class SRVetSharpshooter extends SRVeterancyTypes
    abstract;

static function int GetPerkProgressInt( ClientPerkRepLink StatOther, out int FinalInt, byte CurLevel, byte ReqNum )
{
    FinalInt = GetPerkXP( CurLevel, 1 );
    return Min( StatOther.RHeadshotKillsStat, FinalInt );
}

static function bool IsPerkDamType( class<DamageType> DmgType )
{
    return(DmgType == class'DamTypeCrossbow'
        || DmgType == class'DamTypeCrossbowHeadShot'
        || DmgType == class'DamTypeDeagle'
        || DmgType == class'DamTypeDual44Magnum'
        || DmgType == class'DamTypeDualDeagle'
        || DmgType == class'DamTypeDualies'
        || DmgType == class'DamTypeDualMK23Pistol'
        || DmgType == class'DamTypeM14EBR'
        || DmgType == class'DamTypeMagnum44Pistol'
        || DmgType == class'DamTypeM99HeadShot'
        || DmgType == class'DamTypeM99SniperRifle'
        || DmgType == class'DamTypeMK23Pistol'
        || DmgType == class'DamTypeSPSniper'
        || DmgType == class'DamTypeWinchester'
        /////////////////////////////////////////////
        || DmgType == class'Weapon_DamTypeM14EBR'
        || DmgType == class'Weapon_DamTypeM99SniperRifle'
        || DmgType == class'Weapon_DamTypeM99HeadShot'
        /////////////////////////////////////////////
        || DmgType == class'DamTypeL96AWPLLI'
        || DmgType == class'DamTypeL96AWPLLIm'
        || DmgType == class'DamTypeVSSDT'
        );
}

static function bool IsPerkExtraAmmo( Class<Ammunition> AmmoType )
{
    return(AmmoType == class'CrossbowAmmo'
        || AmmoType == class'DeagleAmmo'
        || AmmoType == class'DualiesAmmo'
        || AmmoType == class'M14EBRAmmo'
        || AmmoType == class'Magnum44Ammo'
        || AmmoType == class'MK23Ammo'
        || AmmoType == class'SingleAmmo'
        || AmmoType == class'SPSniperAmmo'
        || AmmoType == class'WinchesterAmmo'
        /////////////////////////////////////////////
        || AmmoType == class'Weapon_M99Ammo'
        /////////////////////////////////////////////
        || AmmoType == class'L96AWPLLIAmmo'
        || AmmoType == class'VSSDTAmmo'
        );
}

static function bool IsPerkWeapon( KFWeapon Other )
{
    return(None != Crossbow(Other)
        || None != Deagle(Other)
        || None != Dual44Magnum(Other)
        || None != DualDeagle(Other)
        || None != Dualies(Other)
        || None != DualMK23Pistol(Other)
        || None != M14EBRBattleRifle(Other)
        || None != Magnum44Pistol(Other)
        || None != MK23Pistol(Other)
        || None != Single(Other)
        || None != SPSniperRifle(Other)
        || None != Winchester(Other)
        /////////////////////////////////////////////
        || None != Weapon_M14EBRBattleRifle(Other)
        /////////////////////////////////////////////
        || none != L96AWPLLI(Other)
        || None != VSSDT(Other)
        );
}

static function bool IsPerkSalesPickup( class<Pickup> Item )
{
    return(Item == class'CrossbowPickup'
        || Item == class'DeaglePickup'
        || Item == class'Magnum44Pickup'
        || Item == class'Dual44MagnumPickup'
        || Item == class'DualDeaglePickup'
        || Item == class'DualMK23Pickup'
        || Item == class'GoldenDeaglePickup'
        || Item == class'GoldenDualDeaglePickup'
        || Item == class'M14EBRPickup'
        || Item == class'M99Pickup'
        || Item == class'MK23Pickup'
        || Item == class'SPSniperPickup'
        /////////////////////////////////////////////
        || Item == class'Weapon_M14EBRPickup'
        || Item == class'Weapon_M99Pickup'
        );
}

////////////////////////////////////////////////////////////////////////////////
// 퍼크 특수 능력
////////////////////////////////////////////////////////////////////////////////

static function bool CanBeGrabbed( KFPlayerReplicationInfo KFPRI, KFMonster Other )
{
    return !Other.IsA('ZombieClot');
}

static function float GetHeadShotDamMulti( KFPlayerReplicationInfo KFPRI, KFPawn P, class<DamageType> DmgType )
{
    local float ret;

    if ( IsPerkDamType(DmgType) )
        ret = GetScale( KFPRI, 60, 250, 5 ); // 60~250%
    else ret = 1.0; // Fix for oversight in Balance Round 6(which is the reason for the Round 6 second attempt patch)

    // headshot damage: 50~150%
    //return ret  * (1.0 + FMin(1.5, 0.05 * KFPRI.ClientVeteranSkillLevel));
    return ret * 2.5;
}

// Change the cost of particular items
static function float GetCostScaling( KFPlayerReplicationInfo KFPRI, class<Pickup> Item )
{
    if ( IsPerkSalesPickup(Item) )
        return 0.5; // 50%
    return 1.0;
}

static function float AddExtraAmmoFor( KFPlayerReplicationInfo KFPRI, Class<Ammunition> AmmoType )
{
    if ( IsPerkExtraAmmo(AmmoType) )
        return 5.0; // 400%
    return 1.0;
}

// Modify fire speed
static function float GetFireSpeedMod( KFPlayerReplicationInfo KFPRI, Weapon Other )
{
    if ( IsPerkWeapon( KFWeapon(Other) ) )
        return GetScale( KFPRI, 10, 100, 5 ); // 10~100%
    return 1.0;
}

static function float GetMagCapacityMod( KFPlayerReplicationInfo KFPRI, KFWeapon Other )
{
    if ( IsPerkWeapon(Other) )
        return GetScale( KFPRI, 20, 200, 5 ); // 20~200%
    return 1.0;
}

static function float GetReloadSpeedModifier( KFPlayerReplicationInfo KFPRI, KFWeapon Other )
{
    if ( IsPerkWeapon(Other) )
        return GetScale( KFPRI, 10, 100, 5 ); // 10~100%
    return 1.0;

}
static function float ModifyRecoilSpread( KFPlayerReplicationInfo KFPRI, WeaponFire Other, out float Recoil )
{
    if ( IsPerkWeapon( KFWeapon(Other.Weapon) ) )
        Recoil = 0.25;
    else Recoil = 1.0;
    Return Recoil;
}

static function int ReduceDamage( KFPlayerReplicationInfo KFPRI, KFPawn Injured, Pawn Instigator, int InDamage, class<DamageType> DmgType )
{
    if ( IsPerkReduceDamage(DmgType) )
        return 0.0; // 100%
    if ( IsPerkReduceHalfDamage(DmgType) )
        return float( InDamage ) * 0.5; // 50%
    return InDamage;
}

////////////////////////////////////////////////////////////////////////////////

// Give Extra Items as Default
static function AddDefaultInventory( KFPlayerReplicationInfo KFPRI, Pawn P )
{
    P.ShieldStrength = 100;
    P.HealthMax = 100 + KFPRI.ClientVeteranSkillLevel;
    KFHumanPawn(P).CreateInventoryVeterancy("ApocMutators.WTFEquipFlaregun", 0);
    KFHumanPawn(P).CreateInventoryVeterancy("ApocMutators.WTFEquipGlowstick", 0);
    KFHumanPawn(P).CreateInventoryVeterancy("KFMod.Deagle", GetCostScaling(KFPRI, class'DeaglePickup'));
    KFHumanPawn(P).CreateInventoryVeterancy("KFMod.Winchester", GetCostScaling(KFPRI, class'WinchesterPickup'));
}

static function string GetCustomLevelInfo( byte Level )
{
    local string S;

    S = Default.CustomLevelInfo;
    //ReplaceText(S, "%s", GetPercentStr(0.1 + 0.00236220472440944881889763779528 * float(Level))); // damage: 10~70%
    ReplaceText(S, "%s", GetPercentStr(0.6 + FMin(1.9, 0.05 * float(Level)))); // damage: 60~250%
    ReplaceText(S, "%p", GetPercentStr(0.1 + FMin(1.4, 0.05 * float(Level)))); // reload speed: 10~150%
    //ReplaceText(S, "%h", GetPercentStr(0.1 + FMin(2.44, 0.05 * float(Level)))); // headshot damage: 10~100%
    //ReplaceText(S, "%d", GetPercentStr(0.1 + FMin(0.6, 0.05 * float(Level)))); // discount: 10~70%
    ReplaceText(S, "%d", GetPercentStr(0.5)); // discount: 50%
    return S;
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    CustomLevelInfo=" * %s more damage with Pistols, Rifle, Crossbow, M14, and M99| * 100% less recoil with Pistols, Rifle, Crossbow, M14, and M99| * %p faster reload with Pistols, Rifle, Crossbow, M14, and M99| * 150% extra headshot damage| * %d discount on Handcannon / 44 Magnum / M14 / M99| * Spawn with a Crossbow| * Can't be grabbed by Clots"
    PerkIndex=2
    OnHUDIcon=Texture'KyanHUD.Perks.Perk_SharpShooter'
    VeterancyName="Sharpshooter"
    Requirements(0)="Get %x headshot kills with Pistols, Rifle, Crossbow, M14, or M99"
}
