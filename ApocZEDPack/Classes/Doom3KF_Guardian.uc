class Doom3KF_Guardian extends Doom3KF_DoomMonster;

var(Sounds) Sound GroundSlamSound;
var() class<DamageType> ShockWaveDamageType;
var transient float NextGroundPound, NextChargeTime;
var Emitter Flames[5];
var() int ShockDamage;
var() float ShockRadius;
var() byte MaxSeekers;
var() float SeekerRegenTime;
var byte ChargeCounter, SeekersCount;

var bool bChargingNow, bRegenSeekers, bClientSpawningSeekers;

replication
{
    reliable if (bNetDirty && Role == ROLE_Authority)
        bChargingNow, bRegenSeekers;
}

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();

    if (Level.NetMode != NM_DedicatedServer)
    {
        Flames[0] = Spawn(class'Doom3KF_GuardianHandFlame');
        AttachToBone(Flames[0], 'GFlameRHand');
        Flames[1] = Spawn(class'Doom3KF_GuardianHandFlame');
        AttachToBone(Flames[1], 'GFlameLHand');
        Flames[2] = Spawn(class'Doom3KF_GuardianBackFlame');
        AttachToBone(Flames[2], 'GFlameBack');
        Flames[3] = Spawn(class'Doom3KF_GuardianTailFlame');
        AttachToBone(Flames[3], 'tail_12');
    }
    bHasRoamed = false;
}

function bool NeedNewSeekers()
{
    return (MaxSeekers>0 && SeekersCount==0);
}
function BeginRegen()
{
    bRegenSeekers = true;
    Acceleration = vect(0, 0, 0);
    Controller.Focus = None;
    Controller.FocalPoint = vector(Rotation)*50000.f+Location;
    if (Level.NetMode != NM_DedicatedServer)
        PostNetReceive();
}
function SpawnSeekers()
{
    local byte i;
    local Doom3KF_Seeker S;
    local vector P;

    P = GetBoneCoords('GFlameBack').Origin;

    for (i=0; i<MaxSeekers; i++)
    {
        S = Spawn(Class'Doom3KF_Seeker', , , P+VRand()*20.f);
        if (S==None)
            continue;
        S.Mother = Self;
        SeekersCount++;
    }
}
function EndRegen()
{
    bRegenSeekers = false;
    if (Level.NetMode != NM_DedicatedServer)
        PostNetReceive();
}
event EncroachedBy(actor Other)
{
    if (Doom3KF_Seeker(Other)==None)
        Super.EncroachedBy(Other);
}

function RangedAttack(Actor A)
{
    if (bShotAnim)
        return;
    if (!bHasRoamed)
        RoamAtPlayer();
    else if (IsInMeleeRange(A))
    {
        if (FRand()<0.33)
        {
            PrepareStillAttack(A);
            SetAnimAction('Attack3');
        }
        else
        {
            PrepareMovingAttack(A, 1);
            if (FRand()<0.5)
                SetAnimAction('WalkAttack1');
            else SetAnimAction('WalkAttack2');
        }
    }
    else if (NextGroundPound<Level.TimeSeconds)
    {
        NextGroundPound = Level.TimeSeconds+4+FRand()*10.f;
        if (FRand()<0.3)
            return;
        PrepareStillAttack(A);
        if (FRand()<0.33)
            SetAnimAction('Attack1');
        else if (FRand()<0.33)
            SetAnimAction('Attack2');
        else SetAnimAction('RangedAttack');
    }
    else if (NextChargeTime<Level.TimeSeconds && Controller != None && Controller.ActorReachable(A))
    {
        NextChargeTime = Level.TimeSeconds+4+FRand()*10.f;
        if (FRand()<0.5)
            return;
        RoamAtPlayer();
        GoToState('Charging');
    }
}

simulated function PostNetReceive()
{
    if (bChargingNow)
        MovementAnims[0] = 'Run';
    else MovementAnims[0] = Default.MovementAnims[0];
    if (bClientSpawningSeekers != bRegenSeekers)
    {
        bClientSpawningSeekers = bRegenSeekers;
        if (bRegenSeekers)
        {
            Flames[4] = Spawn(class'Doom3KF_GuardianBackSteam');
            AttachToBone(Flames[4], 'GFlameBack');
        }
        else if (Flames[4] != None)
            Flames[4].Kill();
    }
}

function TakeDamage(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    if (bRegenSeekers)
        Super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitIndex);
}

state Charging
{
    function RangedAttack(Actor A)
    {
        if (bShotAnim)
            return;
        if (IsInMeleeRange(A))
        {
            PrepareMovingAttack(A, 2.5);
            if (FRand()<0.5)
                SetAnimAction('RunHeadbutt');
            else SetAnimAction('RunHeadbutt2');
        }
    }
    function BeginState()
    {
        ChargeCounter = Rand(7);
        MaxDesiredSpeed = 2.5f;
        bChargingNow = true;
        if (Level.NetMode != NM_DedicatedServer)
            PostNetReceive();
    }
    function EndState()
    {
        NextChargeTime = Level.TimeSeconds+5+FRand()*6.f;
        MaxDesiredSpeed = 1.f;
        bChargingNow = False;
        if (Level.NetMode != NM_DedicatedServer)
            PostNetReceive();
    }
    function BeginRegen()
    {
        GoToState('');
        Global.BeginRegen();
    }
Begin:
    while(Controller != None && Controller.Target != None && ++ChargeCounter<15)
    {
        Sleep(0.5);
        MaxDesiredSpeed = 2.5f;
    }
    GoToState('');
}

simulated function BothWaves()
{
    LeftWave();
    RightWave();
}

simulated function LeftWave()
{
    if (Level.NetMode != NM_DedicatedServer)
        Spawn(class'Doom3KF_GuardianShockWave', , , GetBoneCoords('GFlameLhand').Origin);
}

simulated function RightWave()
{
    if (Level.NetMode != NM_DedicatedServer)
        Spawn(class'Doom3KF_GuardianShockWave', , , GetBoneCoords('GFlameRhand').Origin);
}

simulated final function MakeGroundPound(vector Point)
{
    local Actor P;
    local vector dir;
    local float damageScale, dist, Shake;
    local PlayerController PC;

    PlaySound(GroundSlamSound, SLOT_Misc, 2, , 1000.f);

    if (Level.NetMode != NM_Client)
    {
        foreach VisibleCollidingActors(class'Actor', P, ShockRadius, Point)
        {
            if (P != Self && !P.bStatic && P.Physics==PHYS_Walking)
            {
                dir = P.Location-Point;
                dist = FMax(1, VSize(dir));
                dir = dir/dist;
                damageScale = 1 - FMax(0, (dist - P.CollisionRadius)/ShockRadius);
                P.TakeDamage(damageScale * ShockDamage, self, P.Location - 0.5 * (P.CollisionHeight+P.CollisionRadius) * dir, (damageScale * 90000.f * dir), ShockWaveDamageType);
            }
        }
    }
    PC = Level.GetLocalPlayerController();
    if (PC != None && VSize(PC.CalcViewLocation-Point)<ShockRadius)
    {
        Shake = RandRange(2000, 3000);
        PC.ShakeView(vect(0.0, 0.02, 0.0)*Shake, vect(0, 1000, 0), 0.003*Shake, vect(0.02, 0.02, 0.02)*Shake, vect(1000, 1000, 1000), 0.003*Shake);
    }
}
simulated function RightShock()
{
    MakeGroundPound(GetBoneCoords('GFlameRhand').Origin);
}
simulated function LeftShock()
{
    MakeGroundPound(GetBoneCoords('GFlameLhand').Origin);
}

simulated function RangedShock()
{
    FireProjectiles();
    LeftShock();
    RightShock();
    PlaySound(FireSound, SLOT_Talk, 1.5, , 700);
}
final function FireProjectiles()
{
    local Coords BoneLocation;
    local Rotator Rot;

    if (Level.NetMode != NM_Client)
    {
        BoneLocation = GetBoneCoords('GFlameLhand');
        Rot.Yaw = 0;
        Spawn(RangedProjectile, , , BoneLocation.Origin, Rotation + Rot);
        Rot.Yaw = 32768;
        Spawn(RangedProjectile, , , BoneLocation.Origin, Rotation + Rot);
        Rot.Yaw = -16834;
        Spawn(RangedProjectile, , , BoneLocation.Origin, Rotation + Rot);
        BoneLocation = GetBoneCoords('GFlameRhand');
        Rot.Yaw = 0;
        Spawn(RangedProjectile, , , BoneLocation.Origin, Rotation + Rot);
        Rot.Yaw = 32768;
        Spawn(RangedProjectile, , , BoneLocation.Origin, Rotation + Rot);
        Rot.Yaw = 16834;
        Spawn(RangedProjectile, , , BoneLocation.Origin, Rotation + Rot);
    }
}

simulated function RemoveEffects()
{
    local byte i;

    for (i=0; i<ArrayCount(Flames); i++)
    {
        if (Flames[i] != None)
            Flames[i].Kill();
    }
}

simulated function FadeSkins()
{
    Skins[0] = FadeFX;
    Skins[1] = FadeFX;
    Skins[2] = InvisMat;
    MakeBurnAway();
}

simulated function BurnAway()
{
    Skins[0] = BurnFX;
    Skins[1] = BurnFX;
    Burning = true;
}

defaultproperties
{
     GroundSlamSound=Sound'2009DoomMonstersSounds.Guardian.Guardian_rocksmash'
     ShockWaveDamageType=Class'Doom3KF_DamTypeGuardianShockWave'
     ShockDamage=40
     ShockRadius=1000.000000
     MaxSeekers=5
     SeekerRegenTime=6.000000
     DeathAnims(0)="Death"
     DeathAnims(1)="Death"
     DeathAnims(2)="Death"
     DeathAnims(3)="Death"
     SightAnim="Sight"
     HitAnimsX(0)="Pain"
     HitAnimsX(1)="Pain"
     HitAnimsX(2)="Pain"
     HitAnimsX(3)="Pain"
     MinHitAnimDelay=3.000000
     MeleeAttackSounds(0)=Sound'2009DoomMonstersSounds.Guardian.Guardian_chatter1'
     MeleeAttackSounds(1)=Sound'2009DoomMonstersSounds.Guardian.Guardian_chatter3'
     MeleeAttackSounds(2)=Sound'2009DoomMonstersSounds.Guardian.Guardian_chatter1'
     MeleeAttackSounds(3)=Sound'2009DoomMonstersSounds.Guardian.Guardian_chatter3'
     SightSound=Sound'2009DoomMonstersSounds.Guardian.guardian_sight'
     RangedProjectile=Class'Doom3KF_GuardianProjectile'
     DoomTeleportFXClass=Class'Doom3KF_BossDemonSpawn'
     BurnedTextureNum(0)=1
     HasHitAnims=True
     BigMonster=True
     aimerror=100
     BurnAnimTime=1.200000
     MeleeAnims(0)="Attack1"
     MeleeAnims(1)="Attack2"
     MeleeAnims(2)="Attack3"
     MeleeDamage=40
     bUseExtendedCollision=True
     ColOffset=(X=32.000000,Z=92.000000)
     ColRadius=120.000000
     ColHeight=100.000000
     FootStep(0)=Sound'2009DoomMonstersSounds.Guardian.Guardian_step4'
     FootStep(1)=Sound'2009DoomMonstersSounds.Guardian.Guardian_step4'
     bBoss=True
     HitSound(0)=Sound'2009DoomMonstersSounds.Guardian.Guardian_pain1'
     HitSound(1)=Sound'2009DoomMonstersSounds.Guardian.Guardian_pain2'
     HitSound(2)=Sound'2009DoomMonstersSounds.Guardian.Guardian_pain3'
     HitSound(3)=Sound'2009DoomMonstersSounds.Guardian.Guardian_pain1'
     DeathSound(0)=Sound'2009DoomMonstersSounds.Guardian.guardian_death'
     DeathSound(1)=Sound'2009DoomMonstersSounds.Guardian.guardian_death'
     DeathSound(2)=Sound'2009DoomMonstersSounds.Guardian.guardian_death'
     DeathSound(3)=Sound'2009DoomMonstersSounds.Guardian.guardian_death'
     ChallengeSound(0)=Sound'2009DoomMonstersSounds.Guardian.Guardian_chatter_combat2'
     ChallengeSound(1)=Sound'2009DoomMonstersSounds.Guardian.Guardian_sight1_1'
     ChallengeSound(2)=Sound'2009DoomMonstersSounds.Guardian.Guardian_sight2_1'
     ChallengeSound(3)=Sound'2009DoomMonstersSounds.Guardian.Guardian_sight1_1'
     FireSound=Sound'2009DoomMonstersSounds.Guardian.guardian_fire_flare_up'
     ScoringValue=300
     WallDodgeAnims(0)="Walk"
     WallDodgeAnims(1)="Walk"
     WallDodgeAnims(2)="Walk"
     WallDodgeAnims(3)="Walk"
     IdleHeavyAnim="Idle2"
     IdleRifleAnim="Idle"
     FireHeavyRapidAnim="Walk"
     FireHeavyBurstAnim="Walk"
     FireRifleRapidAnim="Walk"
     FireRifleBurstAnim="Walk"
     bCanJump=False
     MeleeRange=250.000000
     GroundSpeed=200.000000
     HealthMax=7500.000000
     Health=7500
    PlayerCountHealthScale=1.5//0.25
    PlayerNumHeadHealthScale=0.4//0.30 // Was 0.35 in Balance Round 1
     HeadRadius=25.000000
     MenuName="Guardian"
     ControllerClass=Class'Doom3KF_GuardianAI'
     MovementAnims(0)="Walk"
     MovementAnims(1)="Walk"
     MovementAnims(2)="Walk"
     MovementAnims(3)="Walk"
     TurnLeftAnim="Walk"
     TurnRightAnim="Walk"
     SwimAnims(0)="Walk"
     SwimAnims(1)="Walk"
     SwimAnims(2)="Walk"
     SwimAnims(3)="Walk"
     CrouchAnims(0)="Walk"
     CrouchAnims(1)="Walk"
     CrouchAnims(2)="Walk"
     CrouchAnims(3)="Walk"
     WalkAnims(0)="Walk"
     WalkAnims(1)="Walk"
     WalkAnims(2)="Walk"
     WalkAnims(3)="Walk"
     AirAnims(0)="Walk"
     AirAnims(1)="Walk"
     AirAnims(2)="Walk"
     AirAnims(3)="Walk"
     TakeoffAnims(0)="Walk"
     TakeoffAnims(1)="Walk"
     TakeoffAnims(2)="Walk"
     TakeoffAnims(3)="Walk"
     LandAnims(0)="Walk"
     LandAnims(1)="Walk"
     LandAnims(2)="Walk"
     LandAnims(3)="Walk"
     DoubleJumpAnims(0)="Walk"
     DoubleJumpAnims(1)="Walk"
     DoubleJumpAnims(2)="Walk"
     DoubleJumpAnims(3)="Walk"
     DodgeAnims(0)="Walk"
     DodgeAnims(1)="Walk"
     DodgeAnims(2)="Walk"
     DodgeAnims(3)="Walk"
     AirStillAnim="Walk"
     TakeoffStillAnim="Walk"
     CrouchTurnRightAnim="Walk"
     CrouchTurnLeftAnim="Walk"
     IdleCrouchAnim="Idle"
     IdleSwimAnim="Idle2"
     IdleWeaponAnim="Idle"
     IdleRestAnim="Idle2"
     IdleChatAnim="Idle"
     Mesh=SkeletalMesh'2009DoomMonstersAnims.GuardianMesh'
     Skins(0)=Texture'2009DoomMonstersTex.Guardian.GuardianTongue'
     Skins(1)=Texture'2009DoomMonstersTex.Guardian.GuardianSkin'
     Skins(2)=Shader'2009DoomMonstersTex.Guardian.GuardianShader'
     CollisionRadius=70.000000
     CollisionHeight=100.000000
     Mass=10000.000000
}
