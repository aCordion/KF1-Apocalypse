// Written by Marco
class Sentry_UA571HSentry extends SVehicle// Gay hack, but has to be done.
    Placeable
    Config(ApocMutators)
    CacheExempt;

#exec obj load file="SentryTechTex1.utx"
#exec obj load file="SentryTechAnim1.ukx"
#exec obj load file="SentryTechStatics.usx"
#exec obj load file="SentryTechSounds.uax"
#exec obj load file="KF_LAWSnd.uax"

var transient Sentry_UA571HSentryMuzzleFlash Flashes[4];
var transient byte BarrelNumber, FXBarrelNumber;
var transient float NextVoiceTimer;
var() name BarrelBones[4];

var KRigidBodyState UpdatingPosition;
var byte AnimRepNum, IdleRotPos, OldAnimRep;
var(Sounds) sound AlarmNoiseSnd, DiedSnd, LockedOnSnd;
var(Sounds) sound Voices[8];
var vector AttackTargetPos;
var rotator CurrentRot, RotSpeed;
var float NextKPackSt, NextFlipCheckTime;
var config int HitDamage, SentryHealth;
var() Class<DamageType> HitDgeType;
var() float FireRateTime;
var vector LaserOffset;
var KFNewTracer mTracer[4];
var transient Font HUDFontz[2];
var Pawn OwnerPawn;
var Sentry_UA571HSentryWeapon WeaponOwner;
var int EffectiveRange;
var vector RepHitPos[2]; // Fires dual shots so rep 2 at once.

// Bitmasks
var bool bNeedsKUpdate, bIsCurrentlyFlipped;
var() bool bNoAutoDestruct, bEvilTurret, bHasGodMode;

replication
{
    // Variables the server should send to the client.
    reliable if (Role == ROLE_Authority)
        UpdatingPosition, AnimRepNum, RepHitPos, SentryHealth;
    reliable if (Role == ROLE_Authority && AnimRepNum == 2)
        AttackTargetPos;
}

final function SetOwningPlayer(Pawn Other, Sentry_UA571HSentryWeapon Wep)
{
    OwnerPawn = Other;
    PlayerReplicationInfo = Other.PlayerReplicationInfo;
    WeaponOwner = Wep;
    bScriptPostRender = true;
}
simulated function PostRender2D(Canvas C, float ScreenLocX, float ScreenLocY)
{
    local string S;
    local float XL, YL;
    local vector D;

    if (Health <= 0 || PlayerReplicationInfo == None)
        return; // Dead or unknown owner.
    D = C.Viewport.Actor.CalcViewLocation-Location;
    if ((vector(C.Viewport.Actor.CalcViewRotation) Dot D) > 0)
        return; // Behind the camera
    XL = VSizeSquared(D);
    if (XL > 1200 * 1200 || !FastTrace(C.Viewport.Actor.CalcViewLocation, Location))
        return; // Beyond 1200 distance or not in line of sight.

    if (C.Viewport.Actor.PlayerReplicationInfo == PlayerReplicationInfo)
        C.SetDrawColor(255, 100, 100, 255);
    else C.SetDrawColor(200, 0, 0, 255);

    // Load up fonts if not yet loaded.
    if (Default.HUDFontz[0] == None)
    {
        Default.HUDFontz[0] = Font(DynamicLoadObject("ROFonts_Rus.ROArial7", Class'Font'));
        if (Default.HUDFontz[0] == None)
            Default.HUDFontz[0] = Font'Engine.DefaultFont';
        Default.HUDFontz[1] = Font(DynamicLoadObject("ROFonts_Rus.ROBtsrmVr12", Class'Font'));
        if (Default.HUDFontz[1] == None)
            Default.HUDFontz[1] = Font'Engine.DefaultFont';
    }
    if (C.ClipY < 1024)
        C.Font = Default.HUDFontz[0];
    else C.Font = Default.HUDFontz[1];

    C.Style = ERenderStyle.STY_Alpha;
    S = "[ UA-571H Sentry ]";
    C.TextSize(S, XL, YL);
    C.SetPos(ScreenLocX-XL * 0.5, ScreenLocY-YL * 3.25f);
    C.DrawTextClipped(S, false);
    S = "Owner: " @ PlayerReplicationInfo.PlayerName;
    C.TextSize(S, XL, YL);
    C.SetPos(ScreenLocX-XL * 0.5, ScreenLocY-YL * 2.f);
    C.DrawTextClipped(S, false);
    S = "Health: " @ Max(1, float(Health) / float(SentryHealth) * 100.f)
        @ "% (" @ Health @ "/" @ SentryHealth @ ")";
    C.TextSize(S, XL, YL);
    C.SetPos(ScreenLocX-XL * 0.5, ScreenLocY-YL * 0.75f);
    C.DrawTextClipped(S, false);
    /*kyan: todo
    S = "Kills: " @ xPlayerReplicationInfo(PlayerReplicationInfo).flakcount;
    C.TextSize(S, XL, YL);
    C.SetPos(ScreenLocX - XL * 0.5, ScreenLocY + YL * 0.5f);
    C.DrawTextClipped(S, False);*/
}
event bool EncroachingOn(actor Other)
{
    if (Other.bWorldGeometry || Other.bBlocksTeleport)
        return true;
    if (Pawn(Other) != None)
        return true;
    return false;
}
function UsedBy(Pawn user);
function bool TryToDrive(Pawn P)
{
    Return False;
}
simulated function PostNetReceive()
{
    bScriptPostRender = (PlayerReplicationInfo != None);
    if (OldAnimRep != AnimRepNum)
    {
        OldAnimRep = AnimRepNum;
        Switch(AnimRepNum)
        {
            Case 0:
                PlayUnDeploy();
                Break;
            Case 1:
                PlayDeploy();
                Break;
            Case 2:
                PlayFiringTurret();
                Break;
            Case 3:
                PlayIdleTurret();
                Break;
            Default:
                PlayTurretDied();
                Break;
        }
    }
    if (Physics == PHYS_Karma /*&& UpdatingPosition.Position != vect(0, 0, 0)*/)
    {
        if (!KIsAwake())
            KWake();
        bNeedsKUpdate = True;
    }
    if (RepHitPos[0] != vect(0, 0, 0))
    {
        ClientTraceHit(RepHitPos[0]);
        RepHitPos[0] = vect(0, 0, 0);
    }
    if (RepHitPos[1] != vect(0, 0, 0))
    {
        ClientTraceHit(RepHitPos[1]);
        RepHitPos[1] = vect(0, 0, 0);
    }
}
simulated final function ClientTraceHit(vector Spot)
{
    local vector Start, HL, HN, Dir;
    local Actor A;

    Start = Location + (vect(0, 0, 0.9) * CollisionHeight >> Rotation);
    Dir = Normal(Spot-Start);
    A = Trace(HL, HN, Spot + Dir * 30.f, Spot-Dir * 20.f, true);
    if (A == None)
        HL = Spot;
    ProcessHitFXs(A, HL, HN);
}
final function PackState()
{
    KGetRigidBodyState(UpdatingPosition);
}
simulated event bool KUpdateState(out KRigidBodyState newState)
{
    if (!bNeedsKUpdate)
        Return False;
    newState = UpdatingPosition;
    bNeedsKUpdate = False;
    Return True;
}
simulated final function rotator GetActualDirection()
{
    local vector X, Y, Z;

    GetAxes(CurrentRot, X, Y, Z);
    X = X >> Rotation;
    Y = Y >> Rotation;
    Z = Z >> Rotation;
    return OrthoRotation(X, Y, Z);
}
simulated final function int FixedTurn(int current, int desired, int deltaRate)
{
    current = current & 65535;

    if (deltaRate == 0)
        return current;
    desired = desired & 65535;
    if (current == desired)
        return current;
    if (current > desired)
    {
        if (current - desired < 32768)
            current -= Min((current - desired), deltaRate);
        else
            current += Min((desired + 65536 - current), deltaRate);
    }
    else if (desired - current < 32768)
        current += Min((desired - current), deltaRate);
    else current -= Min((current + 65536 - desired), deltaRate);
    return(current & 65535);
}
simulated function Tick(float Delta)
{
    local rotator OlR, DesR;
    local bool bFlip;

    if (Level.NetMode != NM_Client && Physics == PHYS_Karma)
    {
        if (Level.NetMode != NM_StandAlone && NextKPackSt < Level.TimeSeconds)
        {
            NextKPackSt = Level.TimeSeconds + 1.f / NetUpdateFrequency;
            PackState();
        }
        if (KParams != None && KParams.bContactingLevel && NextFlipCheckTime < Level.TimeSeconds)
        {
            NextFlipCheckTime = Level.TimeSeconds + 0.6;
            bFlip = IsFlipped();
            if (bFlip != bIsCurrentlyFlipped)
            {
                if (bFlip)
                bIsCurrentlyFlipped = bFlip;
                Sentry_UA571HSentryAI(Controller).NotifyGotFlipped(bFlip);
            }
        }
    }
// if (Level.NetMode == NM_DedicatedServer || ((Level.TimeSeconds-LastRenderTime) > 2 && (LaserFX == None || (Level.TimeSeconds-LaserFX.LastRenderTime) > 2)))
//     return;
    OlR = CurrentRot;
    if (AnimRepNum == 2)
    {
        DesR = Normalize(rotator((AttackTargetPos-Location) << Rotation));
        CurrentRot.Yaw = FixedTurn(CurrentRot.Yaw, Clamp(DesR.Yaw, -9000, 9000), RotationRate.Yaw * Delta);
        CurrentRot.Pitch = FixedTurn(CurrentRot.Pitch, Clamp(DesR.Pitch, -7000, 7000), RotationRate.Pitch * Delta);
        RotSpeed = rot(0, 0, 0);
    }
    else if (AnimRepNum == 3)
    {
        if (IdleRotPos == 0)
        {
            if (CurrentRot.Yaw < 4000 && CurrentRot.Pitch > -5000)
            {
                RotSpeed.Yaw += 6000 * Delta;
                RotSpeed.Pitch-=6000 * Delta;
            }
            else IdleRotPos = 1;
        }
        else if (IdleRotPos == 1)
        {
            if (CurrentRot.Pitch < 5000)
                RotSpeed.Pitch += 6000 * Delta;
            else IdleRotPos = 2;
        }
        else if (IdleRotPos == 2)
        {
            if (CurrentRot.Yaw > -4000 && CurrentRot.Pitch > -5000)
            {
                RotSpeed.Yaw-=6000 * Delta;
                RotSpeed.Pitch-=6000 * Delta;
            }
            else IdleRotPos = 3;
        }
        else
        {
            if (CurrentRot.Pitch < 5000)
                RotSpeed.Pitch += 6000 * Delta;
            else IdleRotPos = 0;
        }
        CurrentRot.Yaw += Delta * RotSpeed.Yaw;
        CurrentRot.Pitch += Delta * RotSpeed.Pitch;
        if (CurrentRot.Yaw > 4000)
        {
            RotSpeed.Yaw = 0;
            CurrentRot.Yaw = 4000;
        }
        else if (CurrentRot.Yaw < -4000)
        {
            RotSpeed.Yaw = 0;
            CurrentRot.Yaw = -4000;
        }
        if (CurrentRot.Pitch > 5000)
        {
            RotSpeed.Pitch = 0;
            CurrentRot.Pitch = 5000;
        }
        else if (CurrentRot.Pitch < -5000)
        {
            RotSpeed.Pitch = 0;
            CurrentRot.Pitch = -5000;
        }
    }
    if (OlR != CurrentRot)
    {
        DesR.Yaw = 0;
        DesR.Roll = 0;
        DesR.Pitch = -CurrentRot.Yaw;
        SetBoneRotation('Aim_LR', DesR);
        DesR.Roll = CurrentRot.Pitch;
        DesR.Pitch = 0;
        SetBoneRotation('Aim_UD', DesR);
    }
}
function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, Class<DamageType> damageType, optional int HitIndex)
{
    if (Level.NetMode == NM_Client)
        Return;

    if (damageType == class'DamTypeWelder')
    {
        Health += Damage / 10;
        if (Health > default.SentryHealth)
            Health = default.SentryHealth;
        return;
    }

    if (KFPawn(instigatedBy)  != None)
        return;
    if (!KIsAwake())
        KWake();
    if (VSize(hitlocation-Location) < 10)
        hitlocation.Z += 10;
    if (damageType == HitDgeType && !bIsCurrentlyFlipped)
        if ((damageType != None && damageType.Default.bBulletHit) || !bEvilTurret)
            momentum *= 0.07f; // Reduce momentum for bullet hits.

    if (Physics == PHYS_Karma)
        KAddImpulse(momentum, hitlocation);

    if (bHasGodMode || bIsCurrentlyFlipped || damageType == HitDgeType)
        return;
    Health-=Damage;
    if (Health <= 0)
    {
        bIsCurrentlyFlipped = true;
        Sentry_UA571HSentryAI(Controller).NotifyGotFlipped(true);
    }
}
simulated function PlayDeploy()
{
    AnimRepNum = 1;
    if (Level.NetMode == NM_DedicatedServer)
        Return;
    PlayAnim('Deploy', 0.5, 0.1);
    Skins[0] = Default.Skins[0];
    SetTimer(0, false);
}
simulated function PlayUnDeploy()
{
    AnimRepNum = 0;
    if (Level.NetMode == NM_DedicatedServer)
        Return;

    PlayAnim('Retract', 0.5, 0.1);
    Skins[0] = Default.Skins[0];
    SetTimer(0, false);
}
simulated function PlayTurretDied()
{
    AnimRepNum = 4;
    if (Level.NetMode == NM_DedicatedServer)
        Return;
    PlayAnim('Retract', 0.5, 0.1);
    PlaySound(DiedSnd, SLOT_Pain, 2.f, , 400.f);
    Skins[0] = Texture'SentryTechTex1.Weapon_USCMSentry.USCMSentry_D';
    SetTimer(0, false);
}
simulated function PlayFiringTurret()
{
    AnimRepNum = 2;
    if (Level.NetMode == NM_DedicatedServer)
        Return;
    LoopAnim('Fire', 1.5, 0.f);
    PlaySound(LockedOnSnd, SLOT_Misc, 2.f, , 400.f);
    SetTimer(FireRateTime, true);
    Timer();
}
simulated function PlayIdleTurret()
{
    AnimRepNum = 3;
    if (Level.NetMode == NM_DedicatedServer)
        Return;
    LoopAnim('IdleAlert', 0.8f);
    Skins[0] = Default.Skins[0];
    SetTimer(0, false);
}

function FireAShot(vector TPos, optional vector TPosB)
{
    local vector Start, HL, HN, X, Dir;
    local Actor HitA, Res;
    local byte i;

    AttackTargetPos = TPos;
    Start = Location + (vect(0, 0, 0.9) * CollisionHeight >> Rotation);

    // Knock slightly back
    Dir = Normal(TPos-Start);
    if (bIsCurrentlyFlipped && Physics == PHYS_Karma)
    {
        if (!KIsAwake())
            KWake();
        KAddImpulse(-Dir * 1, Start);
    }

    for (i=0; i < 2; ++i)
    {
        if (i == 1 && TPosB != vect(0, 0, 0))
            Dir = Normal(TPosB-Start);
        X = Normal(Dir + VRand() * 0.03);
        if (!KIsAwake())
            KWake();
        TPos = Start + X * 10000;

        foreach TraceActors(Class'Actor', Res, HL, HN, Start + X * EffectiveRange, Start)
        {
            if (Res != Self && (Res == Level || Res.bBlockActors || Res.bProjTarget || Res.bWorldGeometry) && (KFPawn(Res) == None || bEvilTurret)
               && KFBulletWhipAttachment(Res) == None)
            {
                HitA = Res;
                break;
            }
        }
        if (HitA == None)
            HL = TPos;

        if (Level.NetMode != NM_DedicatedServer)
            ProcessHitFXs(HitA, HL, HN);

        if (Level.NetMode != NM_StandAlone)
        {
            if (VSizeSquared(RepHitPos[i]-HL) < 5.f)
                RepHitPos[i] += VRand() * 1.25f;
            else RepHitPos[i] = HL;
        }
        if (HitA != None)
        {
            if (OwnerPawn != None)
            {
                // Give kill credit to owner but tell AI it was I who inflicted it.
                HitA.TakeDamage(HitDamage, OwnerPawn, HL, 10000 * X, HitDgeType);
                if (Pawn(HitA) != None && Pawn(HitA).Controller != None)
                    Pawn(HitA).Controller.damageAttitudeTo(Self, HitDamage);
            }
            else
            {
                Controller.bIsPlayer = False;
                HitA.TakeDamage(HitDamage, Self, HL, 10000 * X, HitDgeType);
                Controller.bIsPlayer = True;
            }
        }
    }
}
simulated function Timer()
{
    // Make noise
    //PlaySound(Sound'USCMSentryGunFire', SLOT_Pain, 2.f, , 800.f);
    PlaySound(Sound'USCMSentryGunFire', SLOT_Pain, 0.7f, , 800.f);

    // Muzzle flash
    if ((Level.TimeSeconds-LastRenderTime) < 4)
    {
        if (Flashes[FXBarrelNumber] == None)
        {
            Flashes[FXBarrelNumber] = Spawn(Class'Sentry_UA571HSentryMuzzleFlash');
            AttachToBone(Flashes[FXBarrelNumber], BarrelBones[FXBarrelNumber]);
            Flashes[FXBarrelNumber + 1] = Spawn(Class'Sentry_UA571HSentryMuzzleFlash');
            AttachToBone(Flashes[FXBarrelNumber + 1], BarrelBones[FXBarrelNumber + 1]);
        }
        else
        {
            Flashes[FXBarrelNumber].FireFX();
            Flashes[FXBarrelNumber + 1].FireFX();
        }
    }
    FXBarrelNumber += 2;
    if (FXBarrelNumber >= ArrayCount(BarrelBones))
        FXBarrelNumber = 0;
}
simulated final function ProcessHitFXs(Actor HitA, vector HitPos, vector HitNor)
{
    local float hitDist;
    local vector SpawnDir, SpawnVel, SpawnLoc;

    // Hit impact FX
    if (HitA != None && (Pawn(HitA) == None || Vehicle(HitA) != None) && ExtendedZCollision(HitA) == None)
        Spawn(class'ROBulletHitEffect', , , HitPos, Rotator(-HitNor));

    // Add tracert.
    if (mTracer[BarrelNumber] == None)
        mTracer[BarrelNumber] = Spawn(Class'KFNewTracer');
    if (mTracer[BarrelNumber] != None)
    {
        SpawnLoc = GetBoneCoords(BarrelBones[BarrelNumber]).Origin;
        mTracer[BarrelNumber].SetLocation(SpawnLoc);

        hitDist = VSize(HitPos - SpawnLoc) - 50.f;

        SpawnDir = Normal(HitPos - SpawnLoc);

        if (hitDist > 100.f)
        {
            SpawnVel = SpawnDir * 7500.f;
            mTracer[BarrelNumber].Emitters[0].StartVelocityRange.X.Min = SpawnVel.X;
            mTracer[BarrelNumber].Emitters[0].StartVelocityRange.X.Max = SpawnVel.X;
            mTracer[BarrelNumber].Emitters[0].StartVelocityRange.Y.Min = SpawnVel.Y;
            mTracer[BarrelNumber].Emitters[0].StartVelocityRange.Y.Max = SpawnVel.Y;
            mTracer[BarrelNumber].Emitters[0].StartVelocityRange.Z.Min = SpawnVel.Z;
            mTracer[BarrelNumber].Emitters[0].StartVelocityRange.Z.Max = SpawnVel.Z;

            mTracer[BarrelNumber].Emitters[0].LifetimeRange.Min = hitDist / 7500.f;
            mTracer[BarrelNumber].Emitters[0].LifetimeRange.Max = mTracer[BarrelNumber].Emitters[0].LifetimeRange.Min;

            mTracer[BarrelNumber].SpawnParticle(1);
        }
    }

    // Next barrel.
    if (++BarrelNumber == ArrayCount(BarrelBones))
        BarrelNumber = 0;
}
simulated function Destroyed()
{
    local byte i;

    for (i=0; i < 4; ++i)
    {
        if (mTracer[i] != None)
            mTracer[i].Destroy();
        if (Flashes[i] != None)
            Flashes[i].Destroy();
    }
    if (Controller != None)
        Controller.Destroy();
    if (Driver != None)
        Driver.Destroy();
    Super.Destroyed();
}
event PostBeginPlay()
{
    Super.PostBeginPlay();
    if ((ControllerClass != None) && (Controller == None))
        Controller = spawn(ControllerClass);
    if (Controller != None)
        Controller.Possess(self);
}
simulated function bool IsFlipped()
{
    local vector worldUp, gravUp;

    gravUp = -Normal(PhysicsVolume.Gravity);
    if (gravUp == vect(0, 0, 0))
        gravUp.Z = -1;
    worldUp = vect(0, 0, 1) >> Rotation;
    if (worldUp Dot gravUp < 0.75f)
        return true;

    return false;
}
function bool SameSpeciesAs(Pawn P)
{
    if (KFPawn(P) != None)
        return !bEvilTurret;
    Return(Monster(P) == None);
}
simulated function PostNetBeginPlay()
{
    RepHitPos[0] = vect(0, 0, 0);
    RepHitPos[1] = vect(0, 0, 0);
    bNetNotify = True;
    PostNetReceive();
}
function Died(Controller Killer, Class<DamageType> damageType, vector HitLocation)
{
    if (bDeleteMe || Level.bLevelChange || Level.Game == None)
        return; // already destroyed, or level is being cleaned up

    if (WeaponOwner != None)
    {
        if (OwnerPawn != None && PlayerController(OwnerPawn.Controller) != None)
            PlayerController(OwnerPawn.Controller).ReceiveLocalizedMessage(Class'Sentry_UA571HSentryMessageTurret', 2);
        WeaponOwner.CurrentSentry = None;
        WeaponOwner.Destroy();
        WeaponOwner = None;
    }
    if (Controller != None)
    {
        Controller.bIsPlayer = False;
        Level.Game.Killed(Killer, Controller, self, damageType);
        Controller.Destroy();
    }

    TriggerEvent(Event, self, None);

    // remove powerup effects, etc.
    RemovePowerups();
    Spawn(Class'PanzerfaustHitConcrete_simple');
    PlaySound(Sound'Rocket_Explode', SLOT_Pain, 2.5f, , 800.f);

    Destroy();
}
simulated function int GetTeamNum()
{
    Return 250;
}
simulated event SetInitialState()
{
    Super(Actor).SetInitialState();
}
simulated event DrivingStatusChanged();
event TakeWaterDamage(float DeltaTime);
simulated function PreBeginPlay()
{
    if (KarmaParamsRBFull(KParams) != None)
        KarmaParamsRBFull(KParams).bHighDetailOnly = False; // Hack to fix some issues.
    if (Level.NetMode != NM_DedicatedServer)
    {
        TweenAnim('Idle', 0.001f);
    }
    Health = SentryHealth;
    HealthMax = SentryHealth;
    Super.PreBeginPlay();
}

defaultproperties
{
     BarrelBones(0)="tip"
     BarrelBones(1)="tip"
     BarrelBones(2)="tip"
     BarrelBones(3)="tip"
     HitDamage=37
     SentryHealth=1200
     HitDgeType=Class'ApocMutators.Sentry_DamTypeUA571HSentry'
     FireRateTime=0.070000
     LaserOffset=(X=12.000000,Z=11.800000)
     EffectiveRange=4000
     Team=250
     VehicleNameString="Turret"
     bCanBeBaseForPawns=False
     PeripheralVision=0.700000
     MenuName="UA-571H Turret"
     ControllerClass=Class'ApocMutators.Sentry_UA571HSentryAI'
     bStasis=False
     Mesh=SkeletalMesh'SentryTechAnim1.Weapon_USCMSentryGun'
     Skins(0)=Texture'SentryTechTex1.Weapon_USCMSentry.USCMSentry_D'
     SoundRadius=140.000000
     CollisionRadius=14.000000
     CollisionHeight=10.000000
     RotationRate=(Pitch=32000,Yaw=32000)
     Begin Object Class=KarmaParamsRBFull Name=KarmaParamsRBFull0
         KInertiaTensor(0)=500.100006
         KInertiaTensor(3)=500.100006
         KInertiaTensor(5)=500.100006
         KCOMOffset=(Y=-0.020000)
         KAngularDamping=0.010000
         KBuoyancy=1.100000
         KStartEnabled=True
         KActorGravScale=2.000000
         KMaxSpeed=10.000000
         KMaxAngularSpeed=30.000000
         bHighDetailOnly=False
         bClientOnly=False
         bKStayUpright=True
         bDestroyOnWorldPenetrate=True
         bDoSafetime=True
         KFriction=0.850000
         KImpactThreshold=5000000.000000
     End Object
     KParams=KarmaParamsRBFull'ApocMutators.Sentry_UA571HSentry.KarmaParamsRBFull0'
     bBlockActors=False
}
