Class SlotMachine_UChimera extends KFMonster;

#exec obj load file="UChimera_rc.ukx"

var byte SightFXCounter;
var SlotMachine_UseTriggerCatcher UseCatcher;
var bool bMessageDeath;

replication
{
    // Variables the server should send to the client.
    reliable if (Role == ROLE_Authority)
        SightFXCounter;
}

simulated function PostBeginPlay()
{
    if (ROLE == ROLE_Authority && UseCatcher == None)
    {
            UseCatcher = Spawn(class'SlotMachine_UseTriggerCatcher', self, , Location + (vect(-50, 0, 0) >> Rotation));
            UseCatcher.SetBase(self);
    }
    if (Level.NetMode != NM_DedicatedServer)
        Spawn(Class'SlotMachine_ChimeraDieFX');
    Super.PostBeginPlay();
}
simulated function Destroyed()
{
    if (UseCatcher != None)
        UseCatcher.Destroy();
    Super.Destroyed();
}
simulated function Tick(float DeltaTime)
{
    if (bResetAnimAct && ResetAnimActTime < Level.TimeSeconds)
    {
        AnimAction = '';
        bResetAnimAct = False;
    }
}
function bool FlipOver()
{
    return false;
}
function PlayTakeHit(vector HitLocation, int Damage, Class<DamageType> DamageType);
function DoDamageFX(Name boneName, int Damage, Class<DamageType> DamageType, Rotator r);
function ProcessHitFX();

State ZombieDying
{
ignores TakeDamage;

    simulated function Timer()
    {
        Destroy();
    }
    simulated function BeginState()
    {
        LifeSpan = 0.25f;
        SetPhysics(PHYS_None);
        if (Controller != None)
        {
            if (Controller.bIsPlayer)
                Controller.PawnDied(Self);
            else Controller.Destroy();
        }
     }
}

function DoorAttack(Actor A)
{
    if (!bShotAnim && A != None)
    {
        bShotAnim = true;
        SetAnimAction('Bite');
        GotoState('DoorBashing');
    }
}
function RangedAttack(Actor A)
{
    if (!bShotAnim && CanAttack(A))
    {
        bShotAnim = true;
        SetAnimAction('Bite');
        Controller.bPreparingMove = true;
        Acceleration = vect(0, 0, 0);
    }
}
final function bool BiteHits(Actor Other)
{
    local vector V;

    V = vector(Rotation) * 90.f + Location-Other.Location;
    if (Abs(V.Z) > (60.f + Other.CollisionHeight))
        return false;
    V.Z = 0;
    return(VSize(V) < (100.f + Other.CollisionRadius) && FastTrace(Other.Location, Location));
}
function BiteTarget()
{
    local Controller C, NC;

    if (KFDoorMover(Controller.Target) != None)
        Controller.Target.TakeDamage(MeleeDamage, Self, Location, vect(0, 0, 0), CurrentDamType);
    for (C=Level.ControllerList; C != None; C=NC)
    {
        NC = C.nextController;
        if (C.Pawn != None && SlotMachine_UChimera(C.Pawn) == None && C.Pawn.Health > 0 && BiteHits(C.Pawn))
        {
            C.Pawn.AddVelocity(Normal(C.Pawn.Location-Location) * 2000.f);
            C.Pawn.TakeDamage(MeleeDamage, Self, Location, Normal(C.Pawn.Location-Location) * 400000.f, CurrentDamType);
        }
    }
}

simulated event SetAnimAction(name NewAction)
{
    if (NewAction == '')
        Return;

    ExpectingChannel = DoAnimAction(NewAction);

    if (AnimNeedsWait(NewAction))
    {
        bWaitForAnim = true;
        bPhysicsAnimUpdate = false;
    }
    if (Level.NetMode != NM_Client)
    {
        AnimAction = NewAction;
        bResetAnimAct = True;
        ResetAnimActTime = Level.TimeSeconds + 0.3;
    }
}
function ZombieMoan();

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, Class<DamageType> damageType, optional int HitIndex)
{
    // Ultimate chimera is indestructable!
    if (Damage > 0 && Controller != None)
        Controller.DamageAttitudeTo(instigatedBy, Damage);
}
function bool IsHeadShot(vector loc, vector ray, float AdditionalScale)
{
    return false;
}
function Died(Controller Killer, Class<DamageType> damageType, vector HitLocation)
{
    if (MyExtCollision != None)
        MyExtCollision.Destroy();
    if (UseCatcher != None)
        UseCatcher.Destroy();
    if (bMessageDeath && Killer != None && Killer != Controller && Killer.PlayerReplicationInfo != None)
        BroadcastLocalizedMessage(Class'SlotMachine_ChimeraSummonMessage', 2, Killer.PlayerReplicationInfo);
    Super.Died(Killer, damageType, HitLocation);
}

simulated function PlayDyingAnimation(Class<DamageType> DamageType, vector HitLoc)
{
    if (Level.NetMode != NM_DedicatedServer)
        Spawn(Class'SlotMachine_ChimeraDieFX');
    BaseEyeHeight = Default.BaseEyeHeight;
    SetTwistLook(0, 0);
    SetInvisibility(0.0);
    StopAnimating(true);
    SetPhysics(PHYS_None);
}

function bool DoJump(bool bUpdating)
{
    if (!bIsCrouched && !bWantsToCrouch && ((Physics == PHYS_Walking) || (Physics == PHYS_Ladder) || (Physics == PHYS_Spider)))
    {
        PlayOwnedSound(JumpSound, SLOT_Pain, GruntVolume, , 80);

        if (Role == ROLE_Authority)
        {
            if ((Level.Game != None) && (Level.Game.GameDifficulty > 2))
                MakeNoise(0.1 * Level.Game.GameDifficulty);
            if (bCountJumps && (Inventory != None))
                Inventory.OwnerEvent('Jumped');
        }
        if (Physics == PHYS_Spider)
            Velocity = JumpZ * Floor;
        else if (Physics == PHYS_Ladder)
            Velocity.Z = 0;
        else Velocity.Z = JumpZ;

        if ((Base != None) && !Base.bWorldGeometry)
            Velocity.Z += Base.Velocity.Z;
        SetPhysics(PHYS_Falling);
        return true;
    }
    return false;
}

simulated function HandleSighted()
{
    if (Level.NetMode != NM_DedicatedServer)
        Spawn(Class'SlotMachine_ChimeraNotice', Self);
    if (Level.NetMode != NM_Client)
    {
        Acceleration = vect(0, 0, 0);
        if (++SightFXCounter == 250)
            SightFXCounter = 1;
    }
}
function PlayRoamAnim()
{
    if (FRand() < 0.5)
        SetAnimAction('Idle2');
    else SetAnimAction('Idle3');
    bShotAnim = true;
    Acceleration = vect(0, 0, 0);
}
simulated function PostNetBeginPlay()
{
    SightFXCounter = 0;
    Super.PostNetBeginPlay();
    bNetNotify = true;
}
simulated function PostNetReceive()
{
    if (SightFXCounter != 0)
    {
        SightFXCounter = 0;
        HandleSighted();
    }
}

simulated function RunStepNoise()
{
    PlaySound(SoundGroup'UC_FootStep', SLOT_None, 1.5f, , 700.f);
}
simulated function WalkStepNoise()
{
    PlaySound(SoundGroup'UC_FootStep', SLOT_None, 0.6f, , 350.f);
}
simulated function BiteNoise()
{
    PlaySound(Sound'ucbite', SLOT_Talk, 1.6f, , 900.f);
}
simulated function GrowlNoise()
{
    PlaySound(Sound'ucgrowl', SLOT_Talk, 1.4f, , 1000.f);
}
simulated function RoamNoise()
{
    PlaySound(Sound'ucroar', SLOT_Talk, 1.4f, , 1000.f);
}

defaultproperties
{
     MeleeDamage=9999
     CurrentDamType=Class'ApocMutators.SlotMachine_DamTypeChimeraBit'
     bUseExtendedCollision=True
     ColOffset=(X=50.000000,Z=20.000000)
     ColRadius=32.000000
     ColHeight=36.000000
     bBoss=True
     ScoringValue=2000
     IdleHeavyAnim="Idle"
     IdleRifleAnim="Idle"
     FireHeavyRapidAnim="Idle"
     FireHeavyBurstAnim="Idle"
     FireRifleRapidAnim="Idle"
     FireRifleBurstAnim="Idle"
     SightRadius=600.000000
     PeripheralVision=-2.000000
     MeleeRange=90.000000
     GroundSpeed=380.000000
     WalkingPct=0.300000
     MenuName="Ultimate Chimera"
     ControllerClass=Class'ApocMutators.SlotMachine_ChimeraController'
     bDoTorsoTwist=False
     MovementAnims(0)="Run"
     MovementAnims(1)="Run"
     MovementAnims(2)="Run"
     MovementAnims(3)="Run"
     TurnLeftAnim="Land"
     TurnRightAnim="Land"
     SwimAnims(0)="Run"
     SwimAnims(1)="Run"
     SwimAnims(2)="Run"
     SwimAnims(3)="Run"
     CrouchAnims(0)="Walk"
     CrouchAnims(1)="Walk"
     CrouchAnims(2)="Walk"
     CrouchAnims(3)="Walk"
     WalkAnims(0)="Walk"
     WalkAnims(1)="Walk"
     WalkAnims(2)="Walk"
     WalkAnims(3)="Walk"
     AirAnims(0)="Jump"
     AirAnims(1)="Jump"
     AirAnims(2)="Jump"
     AirAnims(3)="Jump"
     LandAnims(0)="Land"
     LandAnims(1)="Land"
     LandAnims(2)="Land"
     LandAnims(3)="Land"
     DodgeAnims(0)="Jump"
     DodgeAnims(1)="Jump"
     DodgeAnims(2)="Jump"
     DodgeAnims(3)="Jump"
     AirStillAnim="Jump"
     TakeoffStillAnim="Jump"
     CrouchTurnRightAnim="Land"
     CrouchTurnLeftAnim="Land"
     IdleCrouchAnim="Idle"
     IdleSwimAnim="Idle"
     IdleWeaponAnim="Idle"
     IdleRestAnim="Idle"
     IdleChatAnim="Idle"
     bActorShadows=False
     bAlwaysRelevant=True
     Mesh=SkeletalMesh'UChimera_rc.UChimMesh'
     PrePivot=(Z=-9.000000)
     Skins(0)=Shader'UChimera_rc.Skins.UCEyeShader'
     bNetNotify=False
     RotationRate=(Yaw=140000)
}
