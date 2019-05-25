class SRVetFieldMedic extends SRVeterancyTypes
    abstract;

static function int GetPerkProgressInt( ClientPerkRepLink StatOther, out int FinalInt, byte CurLevel, byte ReqNum )
{
    FinalInt = GetPerkXP( CurLevel, 30 );
    return Min( StatOther.RDamageHealedStat, FinalInt );
}

static function bool IsPerkDamType( class<DamageType> DmgType )
{
    return(DmgType == class'DamTypeBlowerThrower'
        || DmgType == class'DamTypeKrissM'
        || DmgType == class'DamTypeM7A3M'
        || DmgType == class'DamTypeMP5M'
        || DmgType == class'DamTypeMP7M'
        /////////////////////////////////////////////
        || DmgType == class'DamTypeMedicNade'
        || DmgType == class'DamTypePPSH'
        );
}

static function bool IsPerkExtraAmmo( Class<Ammunition> AmmoType )
{
    return(AmmoType == class'BlowerThrowerAmmo'
        || AmmoType == class'CamoMP5MAmmo'
        || AmmoType == class'KrissMAmmo'
        || AmmoType == class'M7A3MAmmo'
        || AmmoType == class'MP5MAmmo'
        || AmmoType == class'MP7MAmmo'
        || AmmoType == class'NeonKrissMAmmo'
        /////////////////////////////////////////////
        || AmmoType == class'HealThrowerAmmo'
        || AmmoType == class'PPSHAmmo'
        );
}

static function bool IsPerkWeapon( KFWeapon Other )
{
    return(none != BlowerThrower(Other)
        || none != CamoMP5MMedicGun(Other)
        || None != KrissMMedicGun(Other)
        || None != MP5MMedicGun(Other)
        || None != MP7MMedicGun(Other)
        || None != M7A3MMedicGun(Other)
        || None != NeonKrissMMedicGun(Other)
        /////////////////////////////////////////////
        || none != HealThrower(Other)
        || none != PPSH41x(Other)
        );
}

static function bool IsPerkSalesPickup( class<Pickup> Item )
{
    return(Item == class'BlowerThrowerPickup'
        || Item == class'CamoMP5MPickup'
        || Item == class'KrissMPickup'
        || Item == class'M7A3MPickup'
        || Item == class'MP5MPickup'
        || Item == class'MP7MPickup'
        || Item == class'NeonKrissMPickup'
        || Item == class'Vest'
        /////////////////////////////////////////////
        || Item == class'Sentry_MedicSentry'
        );
}

////////////////////////////////////////////////////////////////////////////////
// 퍼크 특수 능력
////////////////////////////////////////////////////////////////////////////////

static function bool CanBeGrabbed( KFPlayerReplicationInfo KFPRI, KFMonster Other )
{
    return !Other.IsA('ZombieClot');
}

static function class<Grenade> GetNadeType( KFPlayerReplicationInfo KFPRI )
{
    return class'MedicNade'; // Grenade detonations heal nearby teammates, and cause enemies to be poisoned
}

static function float GetSyringeChargeRate( KFPlayerReplicationInfo KFPRI )
{
    return GetScale( KFPRI, 150, 300, 5 ); // 150~300%
}

static function float GetHealPotency( KFPlayerReplicationInfo KFPRI )
{
    return GetScale( KFPRI, 10, 300, 5 ); // 10~300%
}

// Reduce damage when wearing Armor
static function float GetBodyArmorDamageModifier( KFPlayerReplicationInfo KFPRI )
{
    return 2.0 - GetScale( KFPRI, 10, 75, 5 ); // 10~75%
}

////////////////////////////////////////////////////////////////////////////////
// 퍼크 기본 능력
////////////////////////////////////////////////////////////////////////////////

static function int AddDamage( KFPlayerReplicationInfo KFPRI, KFMonster Injured, KFPawn DamageTaker, int InDamage, Class<DamageType> DmgType )
{
    if ( IsPerkDamType(DmgType) )
        return float( InDamage ) * GetScale( KFPRI, 60, 250, 5 ); // 60~250%
    return InDamage;
}

static function float AddExtraAmmofor( KFPlayerReplicationInfo KFPRI, Class<Ammunition> AmmoType )
{
    if ( IsPerkExtraAmmo(AmmoType) )
        return 5.0; // 400%
    else if ( AmmoType == class'FragAmmo' )
        return GetScale( KFPRI, 10, 60, 5 ); // 10~60%
    return 1.0;
}

// Change the cost of particular items
static function float GetCostScaling( KFPlayerReplicationInfo KFPRI, class<Pickup> Item )
{
    if ( IsPerkSalesPickup(Item) )
        return 0.3; // 70%
    return 1.0;
}

static function float GetFireSpeedMod( KFPlayerReplicationInfo KFPRI, Weapon Other )
{
    if ( None != WTFEquipLethalInjection(Other) )
        return GetScale( KFPRI, 60, 150, 5 ); // 60~150%
    return 1.0;
}

static function float GetMagCapacityMod( KFPlayerReplicationInfo KFPRI, KFWeapon Other )
{
    if ( IsPerkWeapon(Other) )
        return GetScale( KFPRI, 10, 200, 5 ); // 10~200%
    return 1.0;
}

static function float GetMovementSpeedModifier( KFPlayerReplicationInfo KFPRI, KFGameReplicationInfo KFGRI )
{
    if ( KFPRI.ClientVeteranSkillLevel >= 100 )
        return GetScale( KFPRI, 20, 65, 5 ); // 20~55%
    return GetScale( KFPRI, 20, 50, 5 ); // 20~35%
}

static function float GetReloadSpeedModifier( KFPlayerReplicationInfo KFPRI, KFWeapon Other )
{
    if ( IsPerkWeapon(Other) )
        return GetScale( KFPRI, 10, 100, 5 ); // 10~100%
    return 1.0;
}

static function int ReduceDamage( KFPlayerReplicationInfo KFPRI, KFPawn Injured, Pawn Instigator, int InDamage, class<DamageType> DmgType )
{
    if ( IsPerkReduceDamage(DmgType) )
        return 0.0; // 100%
    if ( IsPerkReduceHalfDamage(DmgType) )
        return float( InDamage ) * 0.5; // 50%

    if (DmgType == class'DamTypeVomit')
        return float( InDamage ) * ( 2.0 - GetScale( KFPRI, 10, 75, 5 ) ); // 10~75%
    return InDamage * 0.90; // 10%
}

////////////////////////////////////////////////////////////////////////////////

// Give Extra Items as Default
static function AddDefaultInventory( KFPlayerReplicationInfo KFPRI, Pawn P )
{
    P.ShieldStrength = 100;
    P.HealthMax = 100 + KFPRI.ClientVeteranSkillLevel;
    KFHumanPawn(P).CreateInventoryVeterancy("ApocMutators.WTFEquipFlaregun", 0);
    KFHumanPawn(P).CreateInventoryVeterancy("ApocMutators.WTFEquipGlowstick", 0);
    KFHumanPawn(P).CreateInventoryVeterancy("KFMod.MP7MMedicGun", GetCostScaling(KFPRI, class'MP7MPickup'));
    KFHumanPawn(P).CreateInventoryVeterancy("KFMod.MP5MMedicGun", GetCostScaling(KFPRI, class'MP5MPickup'));
}

static function string GetCustomLevelInfo( byte Level )
{
    local string S;

    S = default.CustomLevelInfo;
    ReplaceText(S, "%s", GetPercentStr(1.0 + FMin(2.0, 0.05 * float(Level)))); // recharge: 100~300%
    ReplaceText(S, "%i", GetPercentStr(0.1 + FMin(2.9, 0.05 * float(Level)))); // heal: 10~300%
    ReplaceText(S, "%d", GetPercentStr(0.6 + FMin(1.9, 0.05 * float(Level)))); // damage: 60~250%
    ReplaceText(S, "%b", GetPercentStr(0.1 + FMin(0.8, 0.05 * float(Level)))); // reduce damage: 10~90%
    if (Level<100)
        ReplaceText(S, "%r", GetPercentStr(0.1 + FMin(0.4, 0.05 * float(Level)))); // movement speed: 10~50%
    else
        ReplaceText(S, "%r", GetPercentStr(0.1 + FMin(0.55, 0.05 * float(Level)))); // movement speed: 10~65%
    ReplaceText(S, "%g", GetPercentStr(0.1 + FMin(0.9, 0.05 * float(Level)))); // mag cap: 10~100%
    ReplaceText(S, "%a", GetPercentStr(0.1 + FMin(0.8, 0.05 * float(Level)))); // body armor: 10~90%
    ReplaceText(S, "%d", GetPercentStr(0.1 + FMin(0.8, 0.05 * float(Level)))); // body discount: 10~90%
    //ReplaceText(S, "%m", GetPercentStr(0.1 + FMin(0.6, 0.05 * float(Level)))); // discount: 10~70%
    ReplaceText(S, "%m", GetPercentStr(0.7)); // discount: 80%
    return S;
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    CustomLevelInfo=" * %s faster Syringe recharge| * %i more potent medical injections| * %b less damage from Bloat Bile| * %d more damage with MedicGun| * %r faster movement speed| * %g larger MP7M Medic Gun clip| * %a better Body Armor| * %d discount on Body Armor| * %m discount on MP7M Medic Guns| * Spawn with Body Armor and Medic Gun| * Can't be grabbed by Clots"
    PerkIndex=0
    OnHUDIcon=Texture'KyanHUD.Perks.Perk_Medic'
    VeterancyName="Field Medic"
    Requirements(0)="Heal %x HP on your teammates"
}