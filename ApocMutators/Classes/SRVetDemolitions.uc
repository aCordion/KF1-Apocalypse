class SRVetDemolitions extends SRVeterancyTypes
    abstract;

static function int GetPerkProgressInt( ClientPerkRepLink StatOther, out int FinalInt, byte CurLevel, byte ReqNum )
{
    FinalInt = GetPerkXP( CurLevel, 5000 );
    return Min( StatOther.RExplosivesDamageStat, finalInt );
}

static function bool IsPerkDamType( class<DamageType> DmgType )
{
    return(None != class<DamTypeFrag>(DmgType)
        || none != class<DamTypeM203Grenade>(DmgType)
        || none != class<DamTypeM32Grenade>(DmgType)
        || none != class<DamTypeM4203AssaultRifle>(DmgType)
        || None != class<DamTypeM79Grenade>(DmgType)
        || none != class<DamTypePipeBomb>(DmgType)
        || None != class<DamTypeRocketImpact>(DmgType)
        || None != class<DamTypeSealSquealExplosion>(DmgType)
        || None != class<DamTypeSeekerSixRocket>(DmgType)
        || None != class<DamTypeSPGrenade>(DmgType)
        /////////////////////////////////////////////
        || none != class<DamTypePP19>(DmgType)
        || none != class<WTFEquipDamTypeBanHammer>(DmgType)
        /////////////////////////////////////////////
        || none != class<DamTypeATMine>(DmgType)
        || none != class<DamTypeHopMine>(DmgType)
        || none != class<DamTypeRPG>(DmgType)
        );
}

static function bool IsPerkExtraAmmo( Class<Ammunition> AmmoType )
{
    return(AmmoType == class'CamoM32Ammo'
        || AmmoType == class'FragAmmo'
        || AmmoType == class'GoldenM79Ammo'
        || AmmoType == class'LAWAmmo'
        || AmmoType == class'M203Ammo'
        || AmmoType == class'M32Ammo'
        || AmmoType == class'M4203Ammo'
        || AmmoType == class'M79Ammo'
        || AmmoType == class'PipeBombAmmo'
        || AmmoType == class'SealSquealAmmo'
        || AmmoType == class'SeekerSixAmmo'
        || AmmoType == class'SPGrenadeAmmo'
        /////////////////////////////////////////////
        || AmmoType == class'PP19Ammo'
        /////////////////////////////////////////////
        || AmmoType == class'ATMineAmmo'
        || AmmoType == class'HL_RPGAmmo'
        || AmmoType == class'HopMineAmmo'
        );
}

static function bool IsPerkSalesPickup( class<Pickup> Item )
{
    return(Item == class'CamoM32Pickup'
        || Item == class'GoldenM79Pickup'
        || Item == class'LawPickup'
        || Item == class'M32Pickup'
        || Item == class'M4203Pickup'
        || Item == class'M79Pickup'
        || Item == class'PipeBombPickup'
        || Item == class'SealSquealPickup'
        || Item == class'SeekerSixPickup'
        || Item == class'SPGrenadePickup'
        /////////////////////////////////////////////
        || Item == class'Weapon_CamoM32Pickup'
        || Item == class'Weapon_GoldenM79Pickup'
        || Item == class'Weapon_LawPickup'
        || Item == class'Weapon_M32Pickup'
        || Item == class'Weapon_M4203Pickup'
        || Item == class'Weapon_M79Pickup'
        || Item == class'Weapon_PipeBombPickup'
        || Item == class'Weapon_SealSquealPickup'
        || Item == class'Weapon_SeekerSixPickup'
        || Item == class'Weapon_SPGrenadePickup'
        );
}

////////////////////////////////////////////////////////////////////////////////
// 퍼크 특수 능력
////////////////////////////////////////////////////////////////////////////////

static function bool CanBeGrabbed( KFPlayerReplicationInfo KFPRI, KFMonster Other )
{
    return !Other.IsA('ZombieClot');
}

static function int AddDamage( KFPlayerReplicationInfo KFPRI, KFMonster Injured, KFPawn DamageTaker, int InDamage, class<DamageType> DmgType )
{
    if ( IsPerkDamType(DmgType) )
        return float( InDamage ) * GetScale( KFPRI, 60, 250, 5 ); // 60~250%
    return InDamage;
}

static function float AddExtraAmmoFor( KFPlayerReplicationInfo KFPRI, Class<Ammunition> AmmoType )
{
    if ( IsPerkExtraAmmo(AmmoType) )
        return 5.0; // 400%
    return 1.0;
}

static function float GetCostScaling( KFPlayerReplicationInfo KFPRI, class<Pickup> Item )
{
    if ( IsPerkSalesPickup(Item) )
        return 0.5; // 50%
    return 1.0; // 100%
}

static function float GetFireSpeedMod( KFPlayerReplicationInfo KFPRI, Weapon Other )
{
    if(None != WTFEquipBanHammer(Other)
    || none != Weapon_M4203AssaultRifle(Other)
    || none != Weapon_M79GrenadeLauncher(Other)
    || None != Weapon_GoldenM79GrenadeLauncher(Other)
    || none != Weapon_SPGrenadeLauncher(Other)
    || none != Weapon_SealSquealHarpoonBomber(Other)
    || none != Weapon_SeekerSixRocketLauncher(Other)
    /////////////////////////////////////////////
    || none != PP19AssaultRifle(Other)
    || none != HL_RPG(Other)
    )
    {
        return GetScale( KFPRI, 10, 100, 5 ); // 10~100%
    }

    return 1.0; // 0%
}

static function float GetMagCapacityMod( KFPlayerReplicationInfo KFPRI, KFWeapon Other )
{
    if(None != M4203AssaultRifle(Other)
    || none != Weapon_M4203AssaultRifle(Other)
    /////////////////////////////////////////////
    || none != Weapon_SealSquealHarpoonBomber(Other)
    || none != Weapon_SeekerSixRocketLauncher(Other)
    /////////////////////////////////////////////
    || none != PP19AssaultRifle(Other)
    )
    {
        return GetScale( KFPRI, 20, 200, 5 ); // 20~200%
    }

    return 1.0;
}

static function float GetReloadSpeedModifier( KFPlayerReplicationInfo KFPRI, KFWeapon Other )
{
    if(None != Frag(Other)
    || None != PipeBombExplosive(Other)
    || None != M79GrenadeLauncher(Other)
    || None != M32GrenadeLauncher(Other)
    || None != M4203AssaultRifle(Other)
    || none != LAW(Other)
    || None != CamoM32GrenadeLauncher(Other)
    || None != SPGrenadeLauncher(Other)
    || None != SealSquealHarpoonBomber(Other)
    || None != SeekerSixRocketLauncher(Other)
    /////////////////////////////////////////////
    || none != Weapon_PipeBombExplosive(Other)
    || None != Weapon_M79GrenadeLauncher(Other)
    || None != Weapon_M32GrenadeLauncher(Other)
    || None != Weapon_M4203AssaultRifle(Other)
    || none != Weapon_LAW(Other)
    || None != Weapon_CamoM32GrenadeLauncher(Other)
    || None != Weapon_SPGrenadeLauncher(Other)
    || None != Weapon_SealSquealHarpoonBomber(Other)
    || none != Weapon_SeekerSixRocketLauncher(Other)
    /////////////////////////////////////////////
    || none != PP19AssaultRifle(Other)
    || none != HL_RPG(Other)
    )
    {
        return GetScale( KFPRI, 10, 100, 5 ); // 10~100%
    }

    return 1.0;
}

static function float ModifyRecoilSpread( KFPlayerReplicationInfo KFPRI, WeaponFire Other, out float Recoil )
{
    if(None != M4203AssaultRifle(Other.Weapon)
    || none != Weapon_M4203AssaultRifle(Other.Weapon)
    /////////////////////////////////////////////
    || none != PP19AssaultRifle(Other.Weapon)
    )
    {
        Recoil = 0.25;
        return Recoil;
    }

    Recoil = 1.0;
    return Recoil;
}

static function int ReduceDamage( KFPlayerReplicationInfo KFPRI, KFPawn Injured, Pawn Instigator, int InDamage, class<DamageType> DmgType )
{
    if ( IsPerkReduceDamage(DmgType) )
        return 0.0; // 100%
    if ( IsPerkReduceHalfDamage(DmgType) )
        return float( InDamage ) * 0.1; // 90%
    return InDamage * 0.9; // 10%
}

////////////////////////////////////////////////////////////////////////////////

// Give Extra Items as default
static function AddDefaultInventory( KFPlayerReplicationInfo KFPRI, Pawn P )
{
    P.ShieldStrength = 100;
    P.HealthMax = 100 + KFPRI.ClientVeteranSkillLevel;
    KFHumanPawn(P).CreateInventoryVeterancy("ApocMutators.WTFEquipFlaregun", 0);
    KFHumanPawn(P).CreateInventoryVeterancy("ApocMutators.WTFEquipGlowstick", 0);
    KFHumanPawn(P).CreateInventoryVeterancy("ApocMutators.Weapon_M79GrenadeLauncher", GetCostScaling(KFPRI, class'M79Pickup'));
    KFHumanPawn(P).CreateInventoryVeterancy("ApocMutators.WTFEquipBanHammer", GetCostScaling(KFPRI, class'WTFEquipBanHammerPickup'));
    KFHumanPawn(P).CreateInventoryVeterancy("ApocMutators.Weapon_PipeBombExplosive", GetCostScaling(KFPRI, class'PipeBombPickup'));
}

static function string GetCustomLevelInfo( byte Level )
{
    local string S;

    S = default.CustomLevelInfo;
    //ReplaceText(S, "%s", GetPercentStr(0.1 + 0.00236220472440944881889763779528 * float(Level))); // damage: 10~70%
    ReplaceText(S, "%s", GetPercentStr(0.6 + FMin(1.9, 0.05 * float(Level)))); // damage: 60~250%
  // ReplaceText(S, "%r", GetPercentStr(0.1 + 0.00354330708661417322834645669291 * float(Level))); // reduce damage: 10~100%
    ReplaceText(S, "%g", GetPercentStr(0.1 + FMin(0.9, 0.05 * float(Level)))); // grenade cap: 10~100%
    ReplaceText(S, "%y", GetPercentStr(0.1 + FMin(2.9, 0.05 * float(Level)))); // pipe-boom cap: 10~300%
    ReplaceText(S, "%x", GetPercentStr(0.1 + FMin(0.8, 0.05 * float(Level)))); // pipe-boom discount: 10~90%
    //ReplaceText(S, "%d", GetPercentStr(0.1 + FMin(0.6, 0.05 * float(Level)))); // discount: 10~70%
    ReplaceText(S, "%d", GetPercentStr(0.5)); // discount: 50%
    return S;
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    CustomLevelInfo=" * %s extra Explosives damage| * 70% resistance to Explosives| * %g increase in grenade capacity| * Can carry %x Remote Explosives| * %y discount on Explosives| * %d off Remote Explosives| * Spawn with an M79 and Pipe Bomb| * Can't be grabbed by Clots"
    PerkIndex=6
    OnHUDIcon=Texture'KyanHUD.Perks.Perk_Demolition'
    VeterancyName="Demolitions"
    Requirements(0)="Deal %x damage with the Explosives"
}
