class SRVetBerserker extends SRVeterancyTypes
    abstract;

static function int GetPerkProgressInt( ClientPerkRepLink StatOther, out int FinalInt, byte CurLevel, byte ReqNum )
{
    FinalInt = GetPerkXP( CurLevel, 5000 );
    return Min( StatOther.RMeleeDamageStat, finalInt );
}

static function bool IsPerkDamType( class<DamageType> DmgType )
{
    return((class<KFWeaponDamageType>(DmgType) != None
        && class<KFWeaponDamageType>(DmgType).default.bIsMeleeDamage)
        || DmgType == class'DamTypeCrossbuzzsawHeadShot'
        );
}

static function bool IsPerkSalesPickup( class<Pickup> Item )
{
    return(Item == class'AxePickup'
        || Item == class'ChainsawPickup'
        || Item == class'ClaymoreSwordPickup'
        || Item == class'CrossbuzzsawPickup'
        || Item == class'DwarfAxePickup'
        || Item == class'GoldenChainsawPickup'
        || Item == class'GoldenKatanaPickup'
        || Item == class'KatanaPickup'
        || Item == class'MachetePickup'
        || Item == class'ScythePickup'

        );
}

////////////////////////////////////////////////////////////////////////////////
// 퍼크 특수 능력
////////////////////////////////////////////////////////////////////////////////

static function bool CanMeleeStun()
{
    return true;
}

static function bool CanBeGrabbed( KFPlayerReplicationInfo KFPRI, KFMonster Other )
{
    return !Other.IsA('ZombieClot');
}

static function int ZedTimeExtensions( KFPlayerReplicationInfo KFPRI )
{
    return 4;
}

////////////////////////////////////////////////////////////////////////////////
// 퍼크 기본 능력
////////////////////////////////////////////////////////////////////////////////

static function int AddDamage( KFPlayerReplicationInfo KFPRI, KFMonster Injured, KFPawn DamageTaker, int InDamage, class<DamageType> DmgType )
{
    if( IsPerkDamType(DmgType) )
        return float( InDamage ) * GetScale( KFPRI, 60, 300, 5 ); // 60~300%
    return InDamage;
}

static function float AddExtraAmmoFor( KFPlayerReplicationInfo KFPRI, class<Ammunition> AmmoType )
{
    if ( AmmoType == class'CrossbuzzsawAmmo' )
        return 5.0; // 400%
    return 1.0;
}

static function float GetCostScaling( KFPlayerReplicationInfo KFPRI, class<Pickup> Item )
{
    if ( IsPerkSalesPickup(Item) )
        return 0.5;
    return 1.0;
}

static function float GetFireSpeedMod( KFPlayerReplicationInfo KFPRI, Weapon Other )
{
    if ( None != KFMeleeGun( KFWeapon(Other) ) )
        return GetScale( KFPRI, 60, 150, 5 ); // 60~150%
    else if ( None != Crossbuzzsaw(Other) )
        return GetScale( KFPRI, 10, 100, 5 ); // 10~100%
    return 1.0;
}

static function float GetMagCapacityMod( KFPlayerReplicationInfo KFPRI, KFWeapon Other )
{
    return 1.0;
}

static function float GetMeleeMovementSpeedModifier( KFPlayerReplicationInfo KFPRI )
{
    if ( KFPRI.ClientVeteranSkillLevel >= 100 )
        return GetScale( KFPRI, 10, 50, 5 ) - 1.0; // 10~50%
    return GetScale( KFPRI, 10, 30, 5 ) - 1.0; // 10~30%
}

static function float GetMovementSpeedModifier( KFPlayerReplicationInfo KFPRI, KFGameReplicationInfo KFGRI )
{
    return 1.0;
}

static function int ReduceDamage( KFPlayerReplicationInfo KFPRI, KFPawn Injured, Pawn Instigator, int InDamage, class<DamageType> DmgType )
{
    if ( IsPerkReduceDamage(DmgType) )
        return 0.0; // 100%
    if ( IsPerkReduceHalfDamage(DmgType) )
        return float( InDamage ) * 0.5; // 50%
    return float( InDamage ) * ( 2.0 - GetScale( KFPRI, 10, 40, 5 ) ); // 10~40%
}

////////////////////////////////////////////////////////////////////////////////

// Give Extra Items as default
static function AddDefaultInventory( KFPlayerReplicationInfo KFPRI, Pawn P )
{
    P.ShieldStrength = 100;
    P.HealthMax = 100 + KFPRI.ClientVeteranSkillLevel;
    KFHumanPawn(P).CreateInventoryVeterancy("ApocMutators.WTFEquipFlaregun", 0);
    KFHumanPawn(P).CreateInventoryVeterancy("ApocMutators.WTFEquipGlowstick", 0);
    KFHumanPawn(P).CreateInventoryVeterancy("KFMod.Axe", GetCostScaling(KFPRI, class'AxePickup'));
    KFHumanPawn(P).CreateInventoryVeterancy("KFMod.Katana", GetCostScaling(KFPRI, class'KatanaPickup'));
}

static function string GetCustomLevelInfo( byte Level )
{
    local string S;

    S = Default.CustomLevelInfo;
    //ReplaceText(S, "%r", GetPercentStr(0.1 + 0.00236220472440944881889763779528 * float(Level))); // damage: 10~70%
    ReplaceText(S, "%r", GetPercentStr(0.6 + FMin(1.9, 0.05 * float(Level)))); // damage: 60~250%
    ReplaceText(S, "%s", GetPercentStr(0.6 + FMin(0.9, 0.05 * float(Level)))); // fire speed: 60~150%
    if (Level<100)
        ReplaceText(S, "%m", GetPercentStr(0.1 + FMin(0.2, 0.05 * float(Level)))); // melee movement: 10~30%
    else ReplaceText(S, "%m", GetPercentStr(0.1 + FMin(0.35, 0.05 * float(Level)))); // melee movement: 10~45%
    ReplaceText(S, "%l", GetPercentStr(0.4)); // reduce damage: 40%
    //ReplaceText(S, "%d", GetPercentStr(0.1 + FMin(0.6, 0.05 * float(Level)))); // discount: 10~70%
    ReplaceText(S, "%d", GetPercentStr(0.5)); // discount: 50%
    return S;
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    CustomLevelInfo=" * %r extra melee damage| * %s faster melee attacks| * %m faster melee movement| * %l less damage from Bloat Bile| * %l resistance to all damage| * %d discount on Katana / Chainsaw / Sword| * Spawn with a Chainsaw and Body Armor| * Can't be grabbed by Clots| * Up to 4 Zed-Time Extensions"
    PerkIndex=4
    OnHUDIcon=texture'KyanHUD.Perks.Perk_Berserker'
    VeterancyName="Berserker"
    Requirements(0)="Deal %x damage with melee weapons"
}
