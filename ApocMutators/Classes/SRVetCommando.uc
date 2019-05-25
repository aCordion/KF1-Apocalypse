class SRVetCommando extends SRVeterancyTypes
    abstract;

static function int GetPerkProgressInt( ClientPerkRepLink StatOther, out int FinalInt, byte CurLevel, byte ReqNum )
{
    FinalInt = GetPerkXP( CurLevel, 5000 );
    return Min( StatOther.RBullpupDamageStat, finalInt );
}

static function bool IsPerkDamType( class<DamageType> DmgType )
{
    return(DmgType == class'DamTypeAK47AssaultRifle'
        || DmgType == class'DamTypeBullpup'
        || DmgType == class'DamTypeFNFALAssaultRifle'
        || DmgType == class'DamTypeM4AssaultRifle'
        || DmgType == class'DamTypeMKb42AssaultRifle'
        || DmgType == class'DamTypeSCARMK17AssaultRifle'
        || DmgType == class'DamTypeSPThompson'
        || DmgType == class'DamTypeThompson'
        || DmgType == class'DamTypeThompsonDrum'
        /////////////////////////////////////////////
        || DmgType == class'DamTypeAK47SH'
        || DmgType == class'DamTypeAK74u'
        || DmgType == class'DamTypeAKC74'
        || DmgType == class'DamTypeAUG_A1AR'
        || DmgType == class'DamTypeM249'
        || DmgType == class'DamTypeP90DT'
        || DmgType == class'DamTypePKM'
        || DmgType == class'DamTypeRPK47'
        || DmgType == class'DamTypeSA80LSW'
        || DmgType == class'DamTypeThompsonV2'
        || DmgType == class'DamTypeVALDT'
        /////////////////////////////////////////////
        || DmgType == class'DamTypePG'
        );
}

static function bool IsPerkExtraAmmo( Class<Ammunition> AmmoType )
{
    return(AmmoType == class'AK47Ammo'
        || AmmoType == class'BullpupAmmo'
        || AmmoType == class'CamoM4Ammo'
        || AmmoType == class'FNFALAmmo'
        || AmmoType == class'GoldenAK47Ammo'
        || AmmoType == class'M4Ammo'
        || AmmoType == class'MKb42Ammo'
        || AmmoType == class'NeonAK47Ammo'
        || AmmoType == class'NeonSCARMK17Ammo'
        || AmmoType == class'SCARMK17Ammo'
        || AmmoType == class'SPThompsonAmmo'
        || AmmoType == class'ThompsonAmmo'
        || AmmoType == class'ThompsonDrumAmmo'
        /////////////////////////////////////////////
        || AmmoType == class'AK47SHAmmo'
        || AmmoType == class'AK74uAmmo'
        || AmmoType == class'AKC74Ammo'
        || AmmoType == class'AUG_A1ARAmmo'
        || AmmoType == class'M249Ammo'
        || AmmoType == class'P90DTAmmo'
        || AmmoType == class'PKMAmmo'
        || AmmoType == class'RPK47Ammo'
        || AmmoType == class'SA80LSWAmmo'
        || AmmoType == class'ThompsonV2Ammo'
        || AmmoType == class'VALDTAmmo'
        /////////////////////////////////////////////
        || AmmoType == class'PatGunAmmo'
        );
}

static function bool IsPerkWeapon( KFWeapon Other )
{
    return(None != AK47AssaultRifle(Other)
        || None != Bullpup(Other)
        || None != CamoM4AssaultRifle(Other)
        || None != FNFAL_ACOG_AssaultRifle(Other)
        || None != GoldenAK47AssaultRifle(Other)
        || None != M4AssaultRifle(Other)
        || None != MKb42AssaultRifle(Other)
        || None != NeonAK47AssaultRifle(Other)
        || None != NeonSCARMK17AssaultRifle(Other)
        || None != ThompsonSMG(Other)
        || None != ThompsonDrumSMG(Other)
        || none != SCARMK17AssaultRifle(Other)
        || None != SPThompsonSMG(Other)
        /////////////////////////////////////////////
        || None != AK47SHAssaultRifle(Other)
        || None != AK74uAssaultRifle(Other)
        || None != AKC74AssaultRifle(Other)
        || None != AUG_A1AR(Other)
        || None != M249(Other)
        || None != P90DT(Other)
        || none != PKM(Other)
        || none != RPK47MachineGun(Other)
        || None != ThompsonSubmachineGun(Other)
        || None != ThompsonV2SubmachineGun(Other)
        || none != VALDTAssaultRifle(Other)
        /////////////////////////////////////////////
        || none != PatGun(Other)
        );
}

static function bool IsPerkSalesPickup( class<Pickup> Item )
{
    return(Item == class'AK47Pickup'
        || Item == class'BullpupPickup'
        || Item == class'CamoM4Pickup'
        || Item == class'FNFAL_ACOG_Pickup'
        || Item == class'GoldenAK47Pickup'
        || Item == class'M4Pickup'
        || Item == class'MKb42Pickup'
        || Item == class'NeonAK47Pickup'
        || Item == class'NeonSCARMK17Pickup'
        || Item == class'SCARMK17Pickup'
        || Item == class'SPThompsonPickup'
        || Item == class'ThompsonPickup'
        || Item == class'ThompsonDrumPickup'
        );
}

////////////////////////////////////////////////////////////////////////////////
// 퍼크 특수 능력
////////////////////////////////////////////////////////////////////////////////

static function bool CanBeGrabbed( KFPlayerReplicationInfo KFPRI, KFMonster Other )
{
    return !Other.IsA('ZombieClot');
}

// Display enemy health bars
static function SpecialHUDInfo( KFPlayerReplicationInfo KFPRI, Canvas C )
{
    local KFMonster KFEnemy;
    local HUDKillingFloor HKF;
    local float MaxDistanceSquared;

    if ( KFPRI.ClientVeteranSkillLevel > 0 )
    {
        HKF = HUDKillingFloor(C.ViewPort.Actor.myHUD);
        if ( HKF == None || Pawn(C.ViewPort.Actor.ViewTarget)==None || Pawn(C.ViewPort.Actor.ViewTarget).Health<=0 )
            return;

        switch ( KFPRI.ClientVeteranSkillLevel )
        {
            case 1:  MaxDistanceSquared = 25600; break; // 20% (160 units)
            case 2:  MaxDistanceSquared = 102400; break; // 40% (320 units)
            case 3:  MaxDistanceSquared = 230400; break; // 60% (480 units)
            case 4:  MaxDistanceSquared = 409600; break; // 80% (640 units)
            default: MaxDistanceSquared = 640000; break; // 100% (800 units)
        }

        foreach C.ViewPort.Actor.DynamicActors(class'KFMonster',KFEnemy)
        {
            if ( KFEnemy.Health > 0 && (!KFEnemy.Cloaked() || KFEnemy.bZapped || KFEnemy.bSpotted) && VSizeSquared(KFEnemy.Location - C.ViewPort.Actor.Pawn.Location) < MaxDistanceSquared )
                HKF.DrawHealthBar(C, KFEnemy, KFEnemy.Health, KFEnemy.HealthMax , 50.0);
        }
    }
}

static function bool ShowStalkers( KFPlayerReplicationInfo KFPRI )
{
    return true;
}

static function float GetStalkerViewDistanceMulti( KFPlayerReplicationInfo KFPRI )
{
    return FMax(0.1, (0.004 * float(KFPRI.ClientVeteranSkillLevel)));
}

// Set number times Zed Time can be extended
static function int ZedTimeExtensions( KFPlayerReplicationInfo KFPRI )
{
    return 4;
}

////////////////////////////////////////////////////////////////////////////////
// 퍼크 기본 능력
////////////////////////////////////////////////////////////////////////////////

static function int AddDamage( KFPlayerReplicationInfo KFPRI, KFMonster Injured, KFPawn DamageTaker, int InDamage, class<DamageType> DmgType )
{
    if ( IsPerkDamType(DmgType) )
        return float( InDamage ) * GetScale( KFPRI, 60, 400, 5 ); // 60~400%
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
        return 0.5;
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
    return Recoil;
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

// Give Extra Items as default
static function AddDefaultInventory( KFPlayerReplicationInfo KFPRI, Pawn P )
{
    P.ShieldStrength = 100;
    P.HealthMax = 100 + KFPRI.ClientVeteranSkillLevel;
    KFHumanPawn(P).CreateInventoryVeterancy("ApocMutators.WTFEquipFlaregun", 0);
    KFHumanPawn(P).CreateInventoryVeterancy("ApocMutators.WTFEquipGlowstick", 0);
    KFHumanPawn(P).CreateInventoryVeterancy("KFMod.Bullpup", GetCostScaling(KFPRI, class'BullpupPickup'));
    KFHumanPawn(P).CreateInventoryVeterancy("KFMod.AK47AssaultRifle", GetCostScaling(KFPRI, class'AK47Pickup'));
}

static function string GetCustomLevelInfo( byte Level )
{
    local string S;

    S = Default.CustomLevelInfo;
    //ReplaceText(S, "%a", GetPercentStr(0.1 + 0.00236220472440944881889763779528 * float(Level))); // damage: 10~70%
    ReplaceText(S, "%a", GetPercentStr(0.6 + FMin(3.4, 0.05 * float(Level)))); // damage: 60~400%
    ReplaceText(S, "%c", GetPercentStr(2.5)); // extra ammo: 250%
    //ReplaceText(S, "%c", GetPercentStr(1.5 + FMin(0.5, 0.05 * float(Level)))); // extra ammo: 150~200%
    ReplaceText(S, "%s", GetPercentStr(0.1 + FMin(0.9, 0.05 * float(Level)))); // reload speed: 10~100%
    //ReplaceText(S, "%d", GetPercentStr(0.1 + FMin(0.6, 0.05 * float(Level)))); // discount: 10~70%
    ReplaceText(S, "%d", GetPercentStr(0.5)); // discount: 50%
    ReplaceText(S, "%z", string(4));
    return S;
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    CustomLevelInfo=" * %a more damage with Assault / Battle Rifles| * 100% less recoil with Assault / Battle Rifles| * %c larger Assault / Battle Rifles clip| * %s faster reload with all weapons| * %d discount on Assault / Battle Rifles| * Spawn with an AK47| * Can see cloaked Stalkers from 16m| * Can see enemy health from 16m| * Can't be grabbed by Clots| * Up to %z Zed-Time Extensions"
    PerkIndex=3
    OnHUDIcon=Texture'KyanHUD.Perks.Perk_Commando'
    VeterancyName="Commando"
    Requirements(0)="Deal %x damage with Assault / Battle Rifles"
}