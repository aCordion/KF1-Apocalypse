//=============================================================================
// L85 Fire
//=============================================================================
class WTFEquipSA80Fire extends KFFire;

var float ClickTime;
var vector  KickMomentum;
var bool bZoomed;

#exec obj load file=WTFSounds.uax

//code from deagle
//adds limited shot penetration
function DoTrace(Vector Start, Rotator Dir)
{
    local Vector X, Y, Z, End, HitLocation, HitNormal, ArcEnd;
    local Actor Other;
    local byte HitCount, HCounter;
    local float HitDamage;
    local array<int> HitPoints;
    local KFPawn HitPawn;
    local array<Actor> IgnoreActors;
    local Actor DamageActor;
    local int i;

    MaxRange();

    Weapon.GetViewAxes(X, Y, Z);
    if (Weapon.WeaponCentered())
    {
        ArcEnd = (Instigator.Location + Weapon.EffectOffset.X * X + 1.5 * Weapon.EffectOffset.Z * Z);
    }
    else
    {
        ArcEnd = (Instigator.Location + Instigator.CalcDrawOffset(Weapon) + Weapon.EffectOffset.X * X +
         Weapon.Hand * Weapon.EffectOffset.Y * Y + Weapon.EffectOffset.Z * Z);
    }

    X = Vector(Dir);
    End = Start + TraceRange * X;
    HitDamage = DamageMax;
    While((HitCount++) < 10)
    {
        DamageActor = none;

        Other = Instigator.HitPointTrace(HitLocation, HitNormal, End, HitPoints, Start, , 1);
        if (Other == None)
        {
            Break;
        }
        else if (Other == Instigator || Other.Base == Instigator)
        {
            IgnoreActors[IgnoreActors.Length] = Other;
            Other.SetCollision(false);
            Start = HitLocation;
            Continue;
        }

        if (ExtendedZCollision(Other) != None && Other.Owner != None)
        {
            IgnoreActors[IgnoreActors.Length] = Other;
            IgnoreActors[IgnoreActors.Length] = Other.Owner;
            Other.SetCollision(false);
            Other.Owner.SetCollision(false);
            DamageActor = Pawn(Other.Owner);
        }

        if (!Other.bWorldGeometry && Other != Level)
        {
            HitPawn = KFPawn(Other);

            if (HitPawn != none)
            {
                 // Hit detection debugging
                 /*log("PreLaunchTrace hit " $ HitPawn.PlayerReplicationInfo.PlayerName);
                 HitPawn.HitStart = Start;
                 HitPawn.HitEnd = End;*/
                 if (!HitPawn.bDeleteMe)
                     HitPawn.ProcessLocationalDamage(int(HitDamage), Instigator, HitLocation, Momentum * X, DamageType, HitPoints);

                 // Hit detection debugging
                 /*if (Level.NetMode == NM_Standalone)
                       HitPawn.DrawBoneLocation();*/

                IgnoreActors[IgnoreActors.Length] = Other;
                IgnoreActors[IgnoreActors.Length] = HitPawn.AuxCollisionCylinder;
                Other.SetCollision(false);
                HitPawn.AuxCollisionCylinder.SetCollision(false);
                DamageActor = Other;
            }
            else
            {
                if (KFMonster(Other) != None)
                {
                    IgnoreActors[IgnoreActors.Length] = Other;
                    Other.SetCollision(false);
                    DamageActor = Other;
                }
                else if (DamageActor == none)
                {
                    DamageActor = Other;
                }
                Other.TakeDamage(int(HitDamage), Instigator, HitLocation, Momentum * X, DamageType);
            }
            if ((HCounter++) >= 4 || Pawn(DamageActor) == None)
            {
                Break;
            }
            HitDamage /= 2;
            Start = HitLocation;
        }
        else if (HitScanBlockingVolume(Other) == None)
        {
            if (KFWeaponAttachment(Weapon.ThirdPersonActor) != None)
              KFWeaponAttachment(Weapon.ThirdPersonActor).UpdateHit(Other, HitLocation, HitNormal);
            Break;
        }
    }

    // Turn the collision back on for any actors we turned it off
    if (IgnoreActors.Length > 0)
    {
        for (i=0; i < IgnoreActors.Length; i++)
        {
            IgnoreActors[i].SetCollision(true);
        }
    }
}

// Calculate modifications to spread
simulated function float GetSpread()
{
    local float NewSpread;
    local float AccuracyMod;

    AccuracyMod = 1.0;

    // Spread bonus for firing aiming
    if (KFWeap.bAimingRifle)
    {
        AccuracyMod *= 0;
    }

    // Small spread bonus for firing crouched
    if (Instigator != none && Instigator.bIsCrouched)
    {
        AccuracyMod *= 0.85;
    }

    NumShotsInBurst += 1;

    if (Level.TimeSeconds - LastFireTime > 0.5)
    {
        NewSpread = Default.Spread;
        NumShotsInBurst=0;
    }
    else
    {
        // Decrease accuracy up to MaxSpread by the number of recent shots up to a max of six
        NewSpread = FMin(Default.Spread + (NumShotsInBurst  * (MaxSpread / 6.0)), MaxSpread);
    }

    NewSpread *= AccuracyMod;

    return NewSpread;
}

defaultproperties
{
     RecoilRate=0.070000
     maxVerticalRecoilAngle=200
     maxHorizontalRecoilAngle=75
     DamageType=Class'ApocMutators.WTFEquipDamTypeSA80a'
     DamageMin=400
     DamageMax=500
     Momentum=8500.000000
     bPawnRapidFireAnim=True
     bWaitForRelease=True
     bModeExclusive=False
     TransientSoundVolume=180.000000
     FireLoopAnim="Fire"
     FireEndAnim="Idle"
     FireSound=Sound'WTFSounds.SA80Fire'
     FireForce="AssaultRifleFire"
     FireRate=1.000000
     AmmoClass=Class'ApocMutators.WTFEquipSA80Ammo'
     AmmoPerFire=1
     ShakeRotMag=(X=250.000000,Y=500.000000,Z=250.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=4.000000,Y=4.000000,Z=4.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=2.000000
     BotRefireRate=1.000000
     FlashEmitterClass=Class'ROEffects.MuzzleFlash1stSTG'
     aimerror=0.100000
     Spread=0.005000
     SpreadStyle=SS_Random
}
