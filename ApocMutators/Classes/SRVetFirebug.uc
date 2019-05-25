class SRVetFirebug extends SRVeterancyTypes
    abstract;

static function int GetPerkProgressInt( ClientPerkRepLink StatOther, out int FinalInt, byte CurLevel, byte ReqNum )
{
    FinalInt = GetPerkXP( CurLevel, 4000 );

    return Min( StatOther.RFlameThrowerDamageStat, FinalInt );
}

static function bool IsPerkDamType( class<DamageType> DmgType )
{
    return(None != class<DamTypeBurned>(DmgType)
        || None != class<DamTypeFlamethrower>(DmgType)
        || None != class<DamTypeFlareProjectileImpact>(DmgType)
        || None != class<DamTypeHuskGunProjectileImpact>(DmgType)
        /////////////////////////////////////////////
        || None != class<DamTypeUMP45>(DmgType)
        );
}

static function bool IsPerkExtraAmmo( Class<Ammunition> AmmoType )
{
    return(AmmoType == class'FlameAmmo'
        || AmmoType == class'FlareRevolverAmmo'
        || AmmoType == class'GoldenFlameAmmo'
        || AmmoType == class'HuskGunAmmo'
        || AmmoType == class'MAC10Ammo'
        || AmmoType == class'TrenchgunAmmo'
        /////////////////////////////////////////////
        || AmmoType == class'UMP45Ammo'
    );
}

static function bool IsPerkWeapon( KFWeapon Other )
{
    return(None != DualFlareRevolver(Other)
        || None != Flamethrower(Other)
        || None != FlareRevolver(Other)
        || None != GoldenFlamethrower(Other)
        || None != HuskGun(Other)
        || None != MAC10MP(Other)
        || None != Trenchgun(Other)
        /////////////////////////////////////////////
        || none != UMP45SubmachineGun(Other)
        );
}

static function bool IsPerkSalesPickup( class<Pickup> Item )
{
    return(Item == class'DualFlareRevolverPickup'
        || Item == class'FlameThrowerPickup'
        || Item == class'FlareRevolverPickup'
        || Item == class'GoldenFTPickup'
        || Item == class'HuskGunPickup'
        || Item == class'MAC10Pickup'
        || Item == class'TrenchgunPickup'
        );
}

////////////////////////////////////////////////////////////////////////////////
// 퍼크 특수 능력
////////////////////////////////////////////////////////////////////////////////

static function bool CanBeGrabbed( KFPlayerReplicationInfo KFPRI, KFMonster Other )
{
    return !Other.IsA('ZombieClot');
}

// Change effective range on FlameThrower
static function int ExtraRange( KFPlayerReplicationInfo KFPRI )
{
    return 4; // 200% Longer Range
    //return 2; // 100% Longer Range
}

static function class<Grenade> GetNadeType( KFPlayerReplicationInfo KFPRI )
{
    if ( KFPRI.ClientVeteranSkillLevel >= 3 )
        return class'FlameNade'; // Grenade detonations cause enemies to catch fire
    return super.GetNadeType(KFPRI);
}

////////////////////////////////////////////////////////////////////////////////
// 퍼크 기본 능력
////////////////////////////////////////////////////////////////////////////////

static function int AddDamage( KFPlayerReplicationInfo KFPRI, KFMonster Injured, KFPawn DamageTaker, int InDamage, class<DamageType> DmgType )
{
    if ( IsPerkDamType(DmgType) )
        return float( InDamage ) * GetScale( KFPRI, 60, 250, 5 ); // 60~350%
    return InDamage;
}

static function float AddExtraAmmoFor( KFPlayerReplicationInfo KFPRI, Class<Ammunition> AmmoType )
{
    if ( IsPerkExtraAmmo(AmmoType) )
        return 5.0; // 400%
    return 1.0;
}

// Change the cost of particular items
static function float GetCostScaling( KFPlayerReplicationInfo KFPRI, class<Pickup> Item )
{
    if ( IsPerkSalesPickup(Item) )
        return 0.5; // 50%
    return 1.0; // 0%
}

static function class<DamageType> GetMAC10DamageType( KFPlayerReplicationInfo KFPRI )
{
    return class'DamTypeMAC10MPInc';
}

static function float GetMagCapacityMod( KFPlayerReplicationInfo KFPRI, KFWeapon Other )
{
    if ( IsPerkWeapon(Other) )
        return GetScale( KFPRI, 100, 250, 5 ); // 100~250%
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
    return Recoil;
}

static function int ReduceDamage( KFPlayerReplicationInfo KFPRI, KFPawn Injured, Pawn Instigator, int InDamage, class<DamageType> DmgType )
{
    if ( IsPerkReduceDamage(DmgType) )
        return 0.0; // 100%
    if ( IsPerkReduceHalfDamage(DmgType) )
        return float( InDamage ) * 0.5; // 50%
    return float( InDamage ) * ( 2.0 - GetScale( KFPRI, 10, 35, 5 ) ); // 10~35%
}

////////////////////////////////////////////////////////////////////////////////

// Give Extra Items as default
static function AddDefaultInventory( KFPlayerReplicationInfo KFPRI, Pawn P )
{
    P.ShieldStrength = 100;
    P.HealthMax = 100 + KFPRI.ClientVeteranSkillLevel;
    KFHumanPawn(P).CreateInventoryVeterancy("ApocMutators.WTFEquipFlaregun", 0);
    KFHumanPawn(P).CreateInventoryVeterancy("ApocMutators.WTFEquipGlowstick", 0);
    KFHumanPawn(P).CreateInventoryVeterancy("KFMod.FlameThrower", GetCostScaling(KFPRI, class'FlamethrowerPickup'));
    KFHumanPawn(P).CreateInventoryVeterancy("KFMod.MAC10MP", GetCostScaling(KFPRI, class'MAC10Pickup'));
    //KFHumanPawn(P).CreateInventoryVeterancy("ApocMutators.WTFEquipM79CF", GetCostScaling(KFPRI, class'WTFEquipM79CFPickup'));
}

static function string GetCustomLevelInfo( byte Level )
{
    local string S;

    S = Default.CustomLevelInfo;
    //ReplaceText(S, "%s", GetPercentStr(0.1 + 0.00236220472440944881889763779528 * float(Level))); // damage: 10~70%
    ReplaceText(S, "%s", GetPercentStr(0.6 + FMin(2.9, 0.05 * float(Level)))); // damage: 60~350%
    ReplaceText(S, "%m", GetPercentStr(0.1 + FMin(0.9, 0.05 * float(Level)))); // reload speed: 10~100%
    ReplaceText(S, "%s", GetPercentStr(2.0)); // extra ammo: 200%
    //ReplaceText(S, "%s", GetPercentStr(1.5 + FMin(0.5, 0.05 * float(Level)))); // extra ammo: 150~200%
    //ReplaceText(S, "%f", GetPercentStr(0.1 + 0.00354330708661417322834645669291 * float(Level))); // reduce damage: 10~100%
    //ReplaceText(S, "%d", GetPercentStr(0.1 + FMin(0.6, 0.05 * float(Level)))); // discount: 10~70%
    ReplaceText(S, "%d", GetPercentStr(0.5)); // discount: 50%
    return S;
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    CustomLevelInfo=" * %s extra flame weapon damage| * %m faster Flamethrower reload| * %s more flame weapon ammo| * 100% resistance to fire| * 100% extra Flamethrower range| * Grenades set enemies on fire| * %d discount on flame weapons| * Spawn with a Flamethrower and Body Armor| * Can't be grabbed by Clots"
    PerkIndex=5
    OnHUDIcon=Texture'KyanHUD.Perks.Perk_Firebug'
    VeterancyName="Firebug"
    Requirements(0)="Deal %x damage with the Flamethrower"
}