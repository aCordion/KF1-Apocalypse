// Written by .:..: (2009)
// Base class of all server veterancy types
class SRVeterancyTypes extends KFVeterancyTypes
    abstract;

var() localized string CustomLevelInfo;
var() localized array<string> SRLevelEffects; // Added in ver 5.00, dynamic array for level effects.
var() byte NumRequirements;
var() localized string DisableTag,DisableDescription; // Can be set as a reason to hide inventory from specific players.

var array< class<KFWeapon> > PerkWeapons;
var array< class<KFWeapon> > PerkOffWeapons;

// Can be used to add in custom stats.
static function AddCustomStats( ClientPerkRepLink Other );

////////////////////////////////////////////////////////////////////////////////
// 퍼크 공통 능력
////////////////////////////////////////////////////////////////////////////////

static function int AddCarryMaxWeight( KFPlayerReplicationInfo KFPRI )
{
    return 14;
    return 9 + Int(FMin(5.0, 0.05 * float(KFPRI.ClientVeteranSkillLevel)));
}

static function float GetAmmoCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item)
{
    return 0.75; // 75%
}

static function float GetMovementSpeedModifier( KFPlayerReplicationInfo KFPRI, KFGameReplicationInfo KFGRI )
{
    if ( KFPRI.ClientVeteranSkillLevel >= 100 ) return 1.40; // 40%

    return 1.20; // 20%
}

static function int ReduceDamage( KFPlayerReplicationInfo KFPRI, KFPawn Injured, Pawn Instigator, int InDamage, class<DamageType> DmgType )
{
    return float( InDamage ) * 0.90; // 10%
}

////////////////////////////////////////////////////////////////////////////////

static function float GetScale(KFPlayerReplicationInfo KFPRI, float min, float max, float step)
{
    local float ret;

    min = min * 0.01;
    max = max * 0.01 - min;
    min = min + 1.0;
    step = step * 0.01;

    ret = min + FMin( max, step * float(KFPRI.ClientVeteranSkillLevel) );

    if (ret < 1.0) ret = 1.0;

    return ret;
}
// Return the level of perk that is available, 0 = perk is n/a.
static function byte PerkIsAvailable( ClientPerkRepLink StatOther )
{
    local byte i;

    // Check which level it fits in to.
    for( i=0; i<StatOther.MaximumLevel; i++ )
    {
        if( !LevelIsFinished(StatOther,i) )
            return Clamp(i,StatOther.MinimumLevel,StatOther.MaximumLevel);
    }
    return StatOther.MaximumLevel;
}

//kyan: add
static function int GetPerkXP(byte CurLevel, int InValue)
{
    //return InValue + int(float(CurLevel * CurLevel * CurLevel * InValue) * 0.5f);
    return InValue + int(float(CurLevel * CurLevel * InValue));
}

// Return the number of different requirements this level has.
static function byte GetRequirementCount( ClientPerkRepLink StatOther, byte CurLevel )
{
    if( CurLevel==StatOther.MaximumLevel )
        return 0;
    return default.NumRequirements;
}

// Return 0-1 % of how much of the progress is done to gain this perk (for menu GUI).
static function float GetTotalProgress( ClientPerkRepLink StatOther, byte CurLevel )
{
    local byte i,rc,Minimum;
    local int R,V,NegReq;
    local float RV;

    if( CurLevel==StatOther.MaximumLevel )
        return 1.f;
    if( StatOther.bMinimalRequirements )
    {
        Minimum = 0;
        CurLevel = Max(CurLevel-StatOther.MinimumLevel,0);
    }
    else Minimum = StatOther.MinimumLevel;

    rc = GetRequirementCount(StatOther,CurLevel);
    for( i=0; i<rc; i++ )
    {
        V = GetPerkProgressInt(StatOther,R,CurLevel,i);
        R*=StatOther.RequirementScaling;
        if( CurLevel>Minimum )
        {
            GetPerkProgressInt(StatOther,NegReq,(CurLevel-1),i);
            NegReq*=StatOther.RequirementScaling;
            R-=NegReq;
            V-=NegReq;
        }
        if( R<=0 ) // Avoid division by zero error.
            RV+=1.f;
        else RV+=FClamp(float(V)/(float(R)),0.f,1.f);
    }
    return RV/float(rc);
}

// Return true if this level is earned.
static function bool LevelIsFinished( ClientPerkRepLink StatOther, byte CurLevel )
{
    local byte i,rc;
    local int R,V;

    if( CurLevel==StatOther.MaximumLevel )
        return false;
    if( StatOther.bMinimalRequirements )
        CurLevel = Max(CurLevel-StatOther.MinimumLevel,0);
    rc = GetRequirementCount(StatOther,CurLevel);
    for( i=0; i<rc; i++ )
    {
        V = GetPerkProgressInt(StatOther,R,CurLevel,i);
        R*=StatOther.RequirementScaling;
        if( R>V )
            return false;
    }
    return true;
}

// Return 0-1 % of how much of the progress is done to gain this individual task (for menu GUI).
static function float GetPerkProgress( ClientPerkRepLink StatOther, byte CurLevel, byte ReqNum, out int Numerator, out int Denominator )
{
    local byte Minimum;
    local int Reduced,Cur,Fin;

    if( CurLevel==StatOther.MaximumLevel )
    {
        Denominator = 1;
        Numerator = 1;
        return 1.f;
    }
    if( StatOther.bMinimalRequirements )
    {
        Minimum = 0;
        CurLevel = Max(CurLevel-StatOther.MinimumLevel,0);
    }
    else Minimum = StatOther.MinimumLevel;
    Numerator = GetPerkProgressInt(StatOther,Denominator,CurLevel,ReqNum);
    Denominator*=StatOther.RequirementScaling;
    if( CurLevel>Minimum )
    {
        GetPerkProgressInt(StatOther,Reduced,CurLevel-1,ReqNum);
        Reduced*=StatOther.RequirementScaling;
        Cur = Max(Numerator-Reduced,0);
        Fin = Max(Denominator-Reduced,0);
    }
    else
    {
        Cur = Numerator;
        Fin = Denominator;
    }
    if( Fin<=0 ) // Avoid division by zero.
        return 1.f;
    return FMin(float(Cur)/float(Fin),1.f);
}

// Return int progress for this perk level up.
static function int GetPerkProgressInt( ClientPerkRepLink StatOther, out int FinalInt, byte CurLevel, byte ReqNum )
{
    FinalInt = 1;
    return 1;
}
static final function int GetDoubleScaling( byte CurLevel, int InValue )
{
    CurLevel-=6;
    return CurLevel*CurLevel*InValue;
}

// Get display info text for menu GUI
static function string GetVetInfoText( byte Level, byte Type, optional byte RequirementNum )
{
    switch( Type )
    {
    case 0:
        return Default.LevelNames[Min(Level,ArrayCount(Default.LevelNames))]; // This was left in the void of unused...
    case 1:
        return GetCustomLevelInfo(Level);
    case 2:
        return Default.Requirements[RequirementNum];
    default:
        return Default.VeterancyName;
    }
}

static function string GetCustomLevelInfo( byte Level )
{
    return Default.CustomLevelInfo;
}
static final function string GetPercentStr( float InValue )
{
    return int(InValue*100.f)$"%";
}

// This function is called for every weapon with and every perk every time trader menu is shown.
// If returned false on any perk, weapon is hidden from the buyable list.
static function bool AllowWeaponInTrader( class<KFWeaponPickup> Pickup, KFPlayerReplicationInfo KFPRI, byte Level )
{
    return true;
}

//kyan: add
static function int Adjust(float Color, float Factor)
{
    local float Gamma, IntensityMax;
    local int Result;

    Gamma = 0.80f;
    IntensityMax = 255.f;

    if (Color == 0.f)
        Result = 0; // Don't want 0^x = 1 for x < > 0
    else
        Result = Round(IntensityMax  * (Color * Factor)^Gamma);

    return Result;
}

//kyan: WaveLength[700~380]
static function WavelengthToRGB(int Wavelength, out byte R, out byte G, out byte B)
{
    local float Red, Green, Blue, Factor;

    if (380 <= Wavelength && Wavelength <= 439)
    {
        Red = -float(Wavelength - 440) / float(440 - 380);
        Green = 0.0f;
        Blue = 1.0f;
    }
    else if (440 <= Wavelength && Wavelength <= 489)
    {
        Red = 0.0f;
        Green = float(Wavelength - 440) / float(490 - 440);
        Blue = 1.0f;
    }
    else if (490 <= Wavelength && Wavelength <= 509)
    {
        Red = 0.0f;
        Green = 1.0f;
        Blue = -float(Wavelength - 510) / float(510 - 490);
    }
    else if (510 <= Wavelength && Wavelength <= 579)
    {
        Red = float(Wavelength - 510) / float(580 - 510);
        Green = 1.0;
        Blue = 0.0;
    }
    else if (580 <= Wavelength && Wavelength <= 644)
    {
        Red = 1.0f;
        Green = -float(Wavelength - 645) / float(645 - 580);
        Blue = 0.0f;
    }
    else if (645 <= Wavelength && Wavelength <= 780)
    {
        Red = 1.0f;
        Green = 0.0f;
        Blue = 0.0f;
    }
    else
    {
        Red = 0.0;
        Green = 0.0;
        Blue = 0.0;
    }

    // Let the intensity fall off near the vision limits
    if (380 <= Wavelength && Wavelength <= 419)
    {
        Factor = 0.3f + 0.7f * float(Wavelength - 380) / float(420 - 380);
    }
    else if (420 <= Wavelength && Wavelength <= 700)
    {
        Factor = 1.0f;
    }
    else if (701 <= Wavelength && Wavelength <= 780)
    {
        Factor = 0.3f + 0.7f * float(780 - Wavelength) / float(780 - 700);
    }
    else
    {
        Factor = 0.0f;
    }

    R = Adjust(Red, Factor);
    G = Adjust(Green, Factor);
    B = Adjust(Blue, Factor);
}


static function byte PreDrawPerk( Canvas C, byte Level, out Material PerkIcon, out Material StarIcon )
{

    //kyan: modified
    local byte R, G, B;
    local float Wavelength;
    Wavelength = 650 - float(Level) * 1.000f;
    WavelengthToRGB(Wavelength, R, G, B);
    PerkIcon = default.OnHUDIcon;
    C.SetDrawColor(R, G, B, C.DrawColor.A);

    return Level;
}

static final function AddPerkedWeapon( class<KFWeapon> W, KFPlayerReplicationInfo KFPRI, Pawn P )
{
    local float C;
    local class<KFWeaponPickup> WC;

    WC = class<KFWeaponPickup>(W.Default.PickupClass);
    if( WC==None )
        KFHumanPawn(P).CreateInventory(string(W));
    else
    {
        C = float(WC.Default.cost) * GetCostScaling(KFPRI,WC);
        KFHumanPawn(P).CreateInventoryVeterancy(string(W),C);
    }
}

static function bool IsPerkReduceDamage( class<DamageType> DmgType )
{
    if(none != class< DamTypeFlameNade >(DmgType)
    || none != class< DamTypeFlamethrower >(DmgType)
    || none != class< DamTypeFrag >(DmgType)
    || none != class< DamTypeHuskGun >(DmgType)
    || none != class< DamTypeHuskGunProjectileImpact >(DmgType)
    || none != class< DamTypeBlowerThrower >(DmgType)
    || none != class< WTFEquipDamTypeBanHammer >(DmgType)
    )
    {
        return true;
    }
    return false;
}

static function bool IsPerkReduceHalfDamage( class<DamageType> DmgType )
{
    if(none != class< DamTypeFrag >(DmgType)
    || none != class< DamTypePipeBomb >(DmgType)
    || none != class< DamTypeM79Grenade >(DmgType)
    || none != class< DamTypeM32Grenade >(DmgType)
    || none != class< DamTypeM203Grenade >(DmgType)
    || none != class< DamTypeRocketImpact >(DmgType)
    || none != class< DamTypeSPGrenade >(DmgType)
    || none != class< DamTypeSealSquealExplosion >(DmgType)
    || none != class< DamTypeSeekerSixRocket >(DmgType)
    || none != class< DamTypeRPG >(DmgType)
    )
    {
        return true;
    }
    return false;
}

defaultproperties
{
    NumRequirements=1
    DisableTag="LOCKED"
    DisableDescription="Can't buy this weapon because the perk says no."
}