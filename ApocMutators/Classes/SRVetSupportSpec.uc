class SRVetSupportSpec extends SRVeterancyTypes
    abstract;

static function int GetPerkProgressInt( ClientPerkRepLink StatOther, out int FinalInt, byte CurLevel, byte ReqNum )
{
    FinalInt = GetPerkXP( CurLevel, 5000 );
    return Min( StatOther.RShotgunDamageStat, FinalInt );
}

static function bool IsPerkDamType( class<DamageType> DmgType )
{
    return(DmgType == class'DamTypeAA12Shotgun'
        || DmgType == class'DamTypeBenelli'
        || DmgType == class'DamTypeDBShotgun'
        || DmgType == class'DamTypeFrag'
        || DmgType == class'DamTypeKSGShotgun'
        || DmgType == class'DamTypeNailgun'
        || DmgType == class'DamTypeShotgun'
        || DmgType == class'DamTypeSPShotgun'
        /////////////////////////////////////////////
        || DmgType == class'DamTypeRem870EC'
        );
}

static function bool IsPerkExtraAmmo( Class<Ammunition> AmmoType )
{
    return(AmmoType == class'AA12Ammo'
        || AmmoType == class'BenelliAmmo'
        || AmmoType == class'CamoShotgunAmmo'
        || AmmoType == class'DBShotgunAmmo'
        || AmmoType == class'GoldenAA12Ammo'
        || AmmoType == class'GoldenBenelliAmmo'
        || AmmoType == class'KSGAmmo'
        || AmmoType == class'NailGunAmmo'
        || AmmoType == class'NeonKSGAmmo'
        || AmmoType == class'ShotgunAmmo'
        || AmmoType == class'SPShotgunAmmo'
        /////////////////////////////////////////////
        || AmmoType == class'Rem870ECAmmo'
        || AmmoType == class'WTFEquipBoomStickAmmo'
        );
}

static function bool IsPerkWeapon( KFWeapon Other )
{
    return(None != AA12AutoShotgun(Other)
        || None != BenelliShotgun(Other)
        || None != Boomstick(Other)
        || None != CamoShotgun(Other)
        || None != GoldenAA12AutoShotgun(Other)
        || None != GoldenBenelliShotgun(Other)
        || None != KSGShotgun(Other)
        || None != NailGun(Other)
        || None != NeonKSGShotgun(Other)
        || None != Shotgun(Other)
        || None != SPAutoShotgun(Other)
        /////////////////////////////////////////////
        || none != Rem870EC(Other)
        || none != WTFEquipBoomStick(Other)
        );
}

static function bool IsPerkSalesPickup( class<Pickup> Item )
{
    return(Item == class'AA12Pickup'
        || Item == class'BenelliPickup'
        || Item == class'BoomstickPickup'
        || Item == class'CamoShotgunPickup'
        || Item == class'GoldenAA12Pickup'
        || Item == class'GoldenBenelliPickup'
        || Item == class'KSGPickup'
        || Item == class'NailGunPickup'
        || Item == class'NeonKSGPickup'
        || Item == class'ShotgunPickup'
        || Item == class'SPShotgunPickup'
        );
}

////////////////////////////////////////////////////////////////////////////////
// 퍼크 특수 능력
////////////////////////////////////////////////////////////////////////////////

static function bool CanBeGrabbed( KFPlayerReplicationInfo KFPRI, KFMonster Other )
{
    return !Other.IsA('ZombieClot');
}

// Reduce Penetration damage with Shotgun slower
static function float GetShotgunPenetrationDamageMulti( KFPlayerReplicationInfo KFPRI, float DefaultPenDamageReduction )
{
    local float PenDamageInverse;
    PenDamageInverse = 1.0 - FMax( 0, DefaultPenDamageReduction );
    //return DefaultPenDamageReduction + ((PenDamageInverse / 254.5555) * float(KFPRI.ClientVeteranSkillLevel));
    return DefaultPenDamageReduction + ( PenDamageInverse * 0.9 ); // 90%
}

////////////////////////////////////////////////////////////////////////////////
// 퍼크 기본 능력
////////////////////////////////////////////////////////////////////////////////

static function int AddDamage( KFPlayerReplicationInfo KFPRI, KFMonster Injured, KFPawn DamageTaker, int InDamage, class<DamageType> DmgType )
{
    if ( IsPerkDamType(DmgType) )
        return float( InDamage ) * GetScale( KFPRI, 60, 350, 5 ); // 60~350%
    return InDamage;
}

static function int AddCarryMaxWeight( KFPlayerReplicationInfo KFPRI )
{
    //return 14 + Int( FMin(5.0, 0.05 * float(KFPRI.ClientVeteranSkillLevel)) );
    return 20;
}

static function float GetCostScaling( KFPlayerReplicationInfo KFPRI, class<Pickup> Item )
{
    if ( IsPerkSalesPickup(Item) )
        return 0.5; // 50%
    return 1.0;
}

static function float AddExtraAmmoFor( KFPlayerReplicationInfo KFPRI, Class<Ammunition> AmmoType )
{
    if ( IsPerkExtraAmmo(AmmoType) )
        return 7.0; // 600%
    if ( AmmoType == class'FragAmmo' )
        return GetScale( KFPRI, 50, 100, 5 ); // 50~100%
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

static function float GetWeldSpeedModifier( KFPlayerReplicationInfo KFPRI )
{
    return GetScale( KFPRI, 10, 100, 5 ) - 1.0; // 10~100%
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
    KFHumanPawn(P).CreateInventoryVeterancy("KFMod.Shotgun", GetCostScaling(KFPRI, class'ShotgunPickup'));
    KFHumanPawn(P).CreateInventoryVeterancy("KFMod.Boomstick", GetCostScaling(KFPRI, class'BoomstickPickup'));
}

static function string GetCustomLevelInfo( byte Level )
{
    local string S;

    S = default.CustomLevelInfo;
    //ReplaceText(S, "%s", GetPercentStr(0.1 + 0.00236220472440944881889763779528 * float(Level))); // damage: 10~70%
    ReplaceText(S, "%s", GetPercentStr(0.6 + FMin(2.9, 0.05 * float(Level)))); // damage: 60~350%
    ReplaceText(S, "%a", GetPercentStr(1.5)); // extra cap: 150%
    //ReplaceText(S, "%a", GetPercentStr(0.5 + FMin(0.5, 0.05 * float(Level)))); // extra cap: 50~100%
    ReplaceText(S, "%g", GetPercentStr(0.1 + FMin(1.4, 0.05 * float(Level)))); // grenade damage: 10~150%
    ReplaceText(S, "%n", GetPercentStr(0.1 + FMin(1.4, 0.05 * float(Level)))); // grenade cap: 10~150%
    //ReplaceText(S, "%c", String(9 + FMin(5.0, 0.05 * float(Level)))); // carry
    ReplaceText(S, "%c", String(39)); // carry
    ReplaceText(S, "%w", GetPercentStr(0.1 + FMin(0.8, 0.05 * float(Level)))); // weld speed: 10~90%
    //ReplaceText(S, "%d", GetPercentStr(0.1 + FMin(0.6, 0.05 * float(Level)))); // discount: 10-70%
    ReplaceText(S, "%d", GetPercentStr(0.5)); // discount: 50%
    return S;
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    CustomLevelInfo=" * %s more damage with Shotguns| * 90% better Shotgun penetration| * %a extra shotgun ammo| * %g more damage with Grenades| * %n increase in grenade capacity| * %c increased carry weight| * %w faster welding / unwelding| * %d discount on Shotguns| * Spawn with a Hunting Shotgun| * Can't be grabbed by Clots"
    PerkIndex=1
    OnHUDIcon=Texture'KyanHUD.Perks.Perk_Support'
    VeterancyName="Support Specialist"
    Requirements(0)="Deal %x damage with shotguns"
}
