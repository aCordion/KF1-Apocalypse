// FreezeRules controls Zed freezing on server side.
// FreezeReplicationInfo is used to replciate freezing effects to clients.

class FreezeRules extends GameRules;

var FreezeReplicationInfo FreezeRI;
var float FreezeTreshold; // % of HealthMax to be done to fully freeze zed
var float FrozenDamageResistance; // frozen zed gets less damage
var float FrozenDamageMult;       // but it is possible to break the ice and instant kill zed
var float FrozenDamageMultHS;     // damage that can do headshots does more damage to ice
var float FrozenDamageMultSG;     // shotgun-specific damage mult

var class<Emitter> ShatteredIce;

var bool bDosh;

struct SFrozen {
    var KFMonster M;
    var bool bFrozen;
    var float CurrentFreeze;
    var float FreezeTreshold; // when CurrentFreeze reaches this value, zed becomes completely frozen
    // FoT: Freeze over Time
    var float FoT;
    var float FoT_Remaining;
    var float WarmTime; // time after which zed should get warmed up

    var int Damage; // damage done during freeze
    var vector FocalPoint;
};
var transient array<SFrozen> Frozen;


final static function FreezeRules FindOrSpawnMe(GameInfo Game)
{
    local GameRules GR;
    local FreezeRules FR;

    FR = FreezeRules(Game.GameRulesModifiers);
    if ( FR == none ) {

        for ( GR = Game.GameRulesModifiers; GR != none && FR == none; GR = GR.NextGameRules )
            FR = FreezeRules(Game.GameRulesModifiers);

        // Freeze rules not found. Spawn it now
        if ( FR == none ) {
            FR = Game.Spawn(Class'FreezeRules', Game);
            if( Game.GameRulesModifiers==None )
                Game.GameRulesModifiers = FR;
            else
                Game.GameRulesModifiers.AddGameRules(FR);
        }
    }

    return FR;
}


function PostBeginPlay()
{
    FreezeRI = spawn(class'FreezeReplicationInfo', self);
}

function AddGameRules(GameRules GR)
{
    if ( GR.class != self.class ) //prevent adding same rules more than once
        Super.AddGameRules(GR);
}

function int NetDamage( int OriginalDamage, int Damage, pawn injured, pawn instigatedBy,
	vector HitLocation, out vector Momentum, class<DamageType> DamageType )
{
    local class<KFWeaponDamageType> KFDamType;
    local class<FreezerBaseDamType> FreezeDT;
    local KFMonster ZedVictim;
    local int idx;

    KFDamType = class<KFWeaponDamageType>(damageType);
    ZedVictim = KFMonster(injured);

    if ( KFDamType != none && ZedVictim != none && ZedVictim.Controller != none  && ZedVictim.Health > 0 )
    {
        FreezeDT = class<FreezerBaseDamType>(damageType);
        if ( FreezeDT != none ) {
            if ( ZedVictim.bBurnified ) {
                ZedVictim.BurnDown /= 2;
                if ( ZedVictim.BurnDown == 0 ) {
                    ZedVictim.bBurnified = false;
                    ZedVictim.Timer(); // stop burning behavior
                }
            }

            if ( !ZedVictim.bBurnified ) {
                idx = FrozenIndex(ZedVictim, true);
                Frozen[idx].CurrentFreeze += Damage * FreezeDT.default.FreezeRatio;
                if ( Frozen[idx].bFrozen ) {
                    Frozen[idx].WarmTime = fmax(Frozen[idx].WarmTime, Level.TimeSeconds + 0.5);
                    // allow shattering for ice darts
                    if ( FreezeDT.default.bCheckForHeadShots ) {
                        Damage *= FrozenDamageResistance * FreezeDT.default.HeadShotDamageMult;
                        Frozen[idx].Damage += Damage * FrozenDamageMultHS;
                        if ( ZedVictim.Health <= Damage + Frozen[idx].Damage ) {
                            Damage += Frozen[idx].Damage;
                            ShatterZed(ZedVictim, instigatedBy.Controller, DamageType);
                        }
                    }
                }
                else {
                    // Freeze over Time
                    if ( FreezeDT.default.FoT_Duration > 0 && (Frozen[idx].FoT_Remaining < 0.5
                            || Frozen[idx].FoT < Damage * FreezeDT.default.FoT_Ratio) )
                    {
                        Frozen[idx].FoT = Damage * FreezeDT.default.FoT_Ratio;
                        Frozen[idx].FoT_Remaining = FreezeDT.default.FoT_Duration;
                    }
                    if ( Frozen[idx].CurrentFreeze >= Frozen[idx].FreezeTreshold ) {
                        // enough damage to freeze zed
                        FreezeZed(ZedVictim, idx);
                        Frozen[idx].bFrozen = true;
                        Frozen[idx].WarmTime = fmax(Frozen[idx].WarmTime, Level.TimeSeconds + 2.0);
                    }
                    else
                        Frozen[idx].WarmTime = fmax(Frozen[idx].WarmTime, Level.TimeSeconds + 1.0);
                }
            }
            //debug
            // Level.GetLocalPlayerController().ClientMessage(Frozen[idx].CurrentFreeze $" / "$ Frozen[idx].FreezeTreshold);
        }
        else {
            idx = FrozenIndex(ZedVictim, false);
            if ( idx != -1 ) {
                if ( KFDamType.default.bDealBurningDamage ) {
                    // fire instantly unfreezes zed
                    if ( Frozen[idx].bFrozen )
                        UnfreezeZed(ZedVictim, idx);
                    Frozen.remove(idx, 1);
                }
                else if ( Frozen[idx].bFrozen ) {
                    if ( KFDamType.default.bCheckForHeadShots && class<DamTypeCrossbuzzsaw>(KFDamType) == none ) {
                        Damage *= KFDamType.default.HeadShotDamageMult;
                        if ( KFDamType.default.bIsPowerWeapon || KFDamType.default.bIsMeleeDamage )
                            Frozen[idx].Damage += Damage * FrozenDamageMultSG;
                        else
                            Frozen[idx].Damage += Damage * FrozenDamageMultHS;
                    }
                    else
                        Frozen[idx].Damage += Damage * FrozenDamageMult;
                    Damage *= FrozenDamageResistance;

                    if ( ZedVictim.Health <= Damage + Frozen[idx].Damage ) {
                        Damage += Frozen[idx].Damage;
                        ShatterZed(ZedVictim, instigatedBy.Controller, DamageType);
                    }
                }
            }
        }
    }

    if ( NextGameRules != None )
        return NextGameRules.NetDamage( OriginalDamage,Damage,injured,instigatedBy,HitLocation,Momentum,DamageType);

    return Damage;
}

function int FrozenIndex(KFMonster M, bool bCreate)
{
    local int i;

    for ( i=0; i < Frozen.length; ++i )
        if ( Frozen[i].M == M )
            return i;

    if ( bCreate ) {
        Frozen.insert(i, 1);
        Frozen[i].M = M;
        Frozen[i].FreezeTreshold = M.HealthMax * FreezeTreshold;
        Frozen[i].WarmTime = Level.TimeSeconds + 2.0;
        return i;
    }

    return -1;
}



function Tick(float DeltaTime)
{
    local int i;
    local bool bRemove;
    local byte FrozenCount;

    while ( i < Frozen.length ) {
        bRemove = Frozen[i].M == none || Frozen[i].M.Health <= 0;

        if ( !bRemove ) {
            if ( Frozen[i].FoT_Remaining > 0 ) {
                Frozen[i].CurrentFreeze += Frozen[i].FoT * DeltaTime;
                Frozen[i].FoT_Remaining -= DeltaTime;
                Frozen[i].WarmTime = fmax(Frozen[i].WarmTime, Level.TimeSeconds + 1.0);
                if ( !Frozen[i].bFrozen && Frozen[i].CurrentFreeze >= Frozen[i].FreezeTreshold ) {
                    FreezeZed(Frozen[i].M, i);
                    Frozen[i].bFrozen = true;
                }
            }
            else {
                if ( Frozen[i].CurrentFreeze > 0 && Level.TimeSeconds >= Frozen[i].WarmTime ) {
                    Frozen[i].CurrentFreeze -= fmax(Frozen[i].CurrentFreeze * 0.2, 20.0) * DeltaTime;
                    if ( Frozen[i].bFrozen && Frozen[i].CurrentFreeze < Frozen[i].FreezeTreshold ) {
                        UnfreezeZed(Frozen[i].M, i);
                        Frozen[i].bFrozen = false;
                        Frozen[i].Damage = 0;
                        Frozen[i].CurrentFreeze *= 0.80;
                    }
                    if ( Frozen[i].CurrentFreeze <= 0 )
                        bRemove = true;
                }
            }

            if ( Frozen[i].bFrozen ) {
                FrozenCount++;
                if ( Frozen[i].M.IsAnimating(0) || Frozen[i].M.IsAnimating(1) )
                    FreezeZed(Frozen[i].M, i);
                else if ( Frozen[i].M.Controller != none ) {
                    // prevent rotating
                    Frozen[i].M.Controller.FocalPoint = Frozen[i].FocalPoint;
                    Frozen[i].M.Controller.Enemy = none;
                    Frozen[i].M.Controller.Focus = none;
                }
            }
        }

        if ( bRemove )
            Frozen.Remove(i, 1);
        else
            i++;
    }
    if ( FrozenCount != FreezeRI.FrozenCount ) {
        FreezeRI.FrozenCount = FrozenCount;
        FreezeRI.NetUpdateTime = Level.TimeSeconds - 1;
    }
}

// call it only if zed isn't frozen yet
function FreezeZed(KFMonster M, int FrozenIndex)
{
    M.SetOverlayMaterial(FreezeRI.FrozenMaterial, 999, true);
    Frozen[FrozenIndex].FocalPoint = M.Location + 512*vector(M.Rotation);
    M.Velocity = M.PhysicsVolume.Gravity;
    M.AnimAction = '';
    M.bShotAnim = true;
    M.bWaitForAnim = true;
    M.Disable('AnimEnd');
    class'FreezeReplicationInfo'.static.RemoveAnimations(M);
    M.Acceleration = vect(0, 0, 0);
    M.SetTimer(0, false);
    M.StopAnimating();

    if ( M.HeadRadius > 0 )
        M.HeadRadius = -M.HeadRadius; // disable headshots

    if ( M.Controller != none ) {
        M.Controller.FocalPoint = Frozen[FrozenIndex].FocalPoint;
        M.Controller.Enemy = none;
        M.Controller.Focus = none;
        if ( !M.Controller.IsInState('WaitForAnim') )
            M.Controller.GoToState('WaitForAnim');
        KFMonsterController(M.Controller).bUseFreezeHack = True;
    }
}

function UnfreezeZed(KFMonster M, int FrozenIndex)
{
    if ( M == none || M.Controller == none || M.Health <= 0 )
        return;

    M.SetOverlayMaterial(none, 0.1, true);

    if ( M.HeadRadius < 0 )
        M.HeadRadius = -M.HeadRadius; //enable headshots
    M.bShotAnim = false;
    M.bWaitForAnim = false;
    M.Enable('AnimEnd');
    class'FreezeReplicationInfo'.static.RestoreAnimations(M);
    M.AnimEnd(1);
    M.AnimEnd(0);
    //KFMonsterController(M.Controller).WhatToDoNext(99);
    M.Controller.GotoState('ZombieHunt');
    M.GroundSpeed = M.GetOriginalGroundSpeed();
    // this should "wake up" raged scrakes
    M.TakeDamage(1, M, M.Location, vect(0,0,0), class'FreezerBaseDamType');
}

function ShatterZed(KFMonster ZedVictim, Controller Killer, class<DamageType> DamageType)
{
    local vector loc;
    local rotator r;
    local CashPickup Dosh;
    local int i;
    local int MaxDosh;

    loc = ZedVictim.Location;
    if ( bDosh && !ZedVictim.bDecapitated )
        MaxDosh = ZedVictim.ScoringValue / 5;


    Spawn(ShatteredIce,,,loc);
    ZedVictim.bHidden = true;
    ZedVictim.Died(Killer, DamageType, loc );

    // DO$H DO$H DO$H DO$H DO$H
    if ( MaxDosh > 0 ) {
        r = ZedVictim.GetViewRotation();
        for ( i=0; i<5; ++i ) {
            Dosh = Spawn(class'FreezeFrozenDosh',,, loc);
            if ( Dosh != none ) {
                Dosh.CashAmount = 1 + rand(MaxDosh);
                Dosh.RespawnTime = 0;
                Dosh.bDroppedCash = True;
                Dosh.Velocity = Vector(r) * 100;
                Dosh.Velocity.Z += 500;
                Dosh.InitDroppedPickupFor(None);
            }
            r.Yaw += 13107;
        }
    }
}

defaultproperties
{
     FreezeTreshold=0.333333
     FrozenDamageResistance=0.500000
     FrozenDamageMult=1.500000
     FrozenDamageMultHS=4.500000
     FrozenDamageMultSG=2.500000
     ShatteredIce=Class'FreezerIceChunkEmitter'
     bDosh=True
}
