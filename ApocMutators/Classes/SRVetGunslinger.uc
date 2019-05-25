/**
 * Perk designed for using pistols
 */
class SRVetGunslinger extends SRVeterancyTypes
    abstract;

#exec TEXTURE IMPORT FILE="Assets\ServerPerks\Perk_Gunslinger.dds" name=Perk_Gunslinger GROUP=KyanHUD Alpha=True

static function int GetPerkProgressInt( ClientPerkRepLink StatOther, out int FinalInt, byte CurLevel, byte ReqNum )
{
    FinalInt = GetPerkXP( CurLevel, 5000 );

    return Min( StatOther.GetCustomValueInt(class'ApocMutators.Weapon_PistolDamageProgress'), FinalInt );
}

static function bool IsPerkDamType( class<DamageType> DmgType )
{
    return (DmgType == class'Weapon_DamTypeDualies'
        //|| DmgType == class'Weapon_DamTypeDeagle'
        || DmgType == class'Weapon_DamTypeDual44Magnum'
        || DmgType == class'Weapon_DamTypeDualDeagle'
        || DmgType == class'Weapon_DamTypeDualMK23Pistol'
        //|| DmgType == class'Weapon_DamTypeMagnum44Pistol'
        //|| DmgType == class'Weapon_DamTypeMK23Pistol'
        //|| DmgType == class'Weapon_DamTypeSingle'
        /////////////////////////////////////////////
        || DmgType == class'Weapon_DamTypeMP7D'
        );
}

static function bool IsPerkExtraAmmo( Class<Ammunition> AmmoType )
{
    return(AmmoType == class'DualiesAmmo'
        || AmmoType == class'DeagleAmmo'
        || AmmoType == class'Weapon_Dual44MagnumAmmo'
        || AmmoType == class'Magnum44Ammo'
        || AmmoType == class'MK23Ammo'
        /////////////////////////////////////////////
        || AmmoType == class'MP7DAmmo'
        );
}

static function bool IsPerkWeapon( KFWeapon Other )
{
    return(None != Weapon_Dualies(Other)
        //|| None != eapon_Deagle(Other)
        || None != Weapon_Dual44Magnum(Other)
        || None != Weapon_DualDeagle(Other)
        || None != Weapon_DualMK23Pistol(Other)
        //|| None != Weapon_Magnum44Pistol(Other)
        //|| None != Weapon_MK23Pistol(Other)
        //|| None != Weapon_Single(Other)
        /////////////////////////////////////////////
        || none != MP7Dual(Other)
        );
}

////////////////////////////////////////////////////////////////////////////////
// 퍼크 특수 능력
////////////////////////////////////////////////////////////////////////////////

static function bool CanBeGrabbed( KFPlayerReplicationInfo KFPRI, KFMonster Other )
{
    return !Other.IsA('ZombieClot');
}

static function AddCustomStats( ClientPerkRepLink Other )
{
    super.AddCustomStats(Other); //init achievements
    Other.AddCustomValue(class'ApocMutators.Weapon_PistolDamageProgress');
}

static function float AddExtraAmmoFor( KFPlayerReplicationInfo KFPRI, Class<Ammunition> AmmoType )
{
    if ( IsPerkExtraAmmo(AmmoType) )
        return 8.0; // 700%
    return 1.0;
}

static function int AddDamage( KFPlayerReplicationInfo KFPRI, KFMonster Injured, KFPawn DamageTaker, int InDamage, class<DamageType> DmgType )
{
    if ( IsPerkDamType(DmgType) )
        return float( InDamage ) * GetScale( KFPRI, 60, 400, 5 ); // 60~400%
    return InDamage;
}

static function float GetCostScaling( KFPlayerReplicationInfo KFPRI, class<Pickup> Item )
{
    return 1.0;
}

static function float GetMagCapacityMod( KFPlayerReplicationInfo KFPRI, KFWeapon Other )
{
    if ( IsPerkWeapon(Other) )
        return GetScale( KFPRI, 20, 150, 5 ); // 20~150%
    return 1.0;
}

static function float GetMovementSpeedModifier( KFPlayerReplicationInfo KFPRI, KFGameReplicationInfo KFGRI )
{
    if ( KFPRI.ClientVeteranSkillLevel >= 100 )
        return GetScale( KFPRI, 10, 50, 5 ); // 10~50%
    return GetScale( KFPRI, 10, 30, 5 ); // 10~30%
}

static function float GetReloadSpeedModifier( KFPlayerReplicationInfo KFPRI, KFWeapon Other )
{
    if ( IsPerkWeapon(Other) )
        return GetScale( KFPRI, 10, 100, 5 ); // 10~100%
    return 1.0;
}

static function float ModifyRecoilSpread( KFPlayerReplicationInfo KFPRI, WeaponFire Other, out float Recoil )
{
    if ( IsPerkWeapon( KFWeapon(Other.Weapon)) )
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
    super.AddDefaultInventory(KFPRI, P);

    P.ShieldStrength = 100;
    P.HealthMax = 100 + KFPRI.ClientVeteranSkillLevel;
    KFHumanPawn(P).CreateInventoryVeterancy("ApocMutators.WTFEquipFlaregun", 0);
    KFHumanPawn(P).CreateInventoryVeterancy("ApocMutators.WTFEquipGlowstick", 0);
    KFHumanPawn(P).CreateInventoryVeterancy("ApocMutators.Weapon_Dualies", GetCostScaling(KFPRI, class'ApocMutators.Weapon_DualiesPickup'));
    KFHumanPawn(P).CreateInventoryVeterancy("ApocMutators.Weapon_Dual44Magnum", GetCostScaling(KFPRI, class'ApocMutators.Weapon_Dual44MagnumPickup'));
}

static function string GetCustomLevelInfo( byte Level )
{
    local string S;

    S = Default.CustomLevelInfo;
    ReplaceText(S, "%s", GetPercentStr(0.6 + FMin(3.4, 0.05 * float(Level)))); // damage: 60~400%
    ReplaceText(S, "%r", GetPercentStr(0.1 + FMin(0.9, 0.05 * float(Level)))); // reload speed: 10~100%
    if (Level<100)
        ReplaceText(S, "%m", GetPercentStr(0.1 + FMin(0.2, 0.05 * float(Level)))); // movement speed: 10~30%
    else
        ReplaceText(S, "%m", GetPercentStr(0.1 + FMin(0.4, 0.05 * float(Level)))); // movement speed: 10~50%
    ReplaceText(S, "%d", GetPercentStr(0.0)); // discount: 50%
    return S;
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    CustomLevelInfo=" * %s more damage with HC/44/MK23|%r faster reload with Pistols|%d discount on HC/44/MK23|Spawn with Dual 44 Magnums|%m movement speed bonus| * Can't be grabbed by Clots"
    PerkIndex=8
    OnHUDIcon=texture'KyanHUD.Perks.Perk_Gunslinger'
    VeterancyName="Gunslinger"
    Requirements(0)="Deal %x damage with Pistols"
}
