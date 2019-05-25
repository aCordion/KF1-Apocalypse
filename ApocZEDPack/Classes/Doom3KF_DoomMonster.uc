// Original for UT2004 by INI, edit for KF by Marco.
class Doom3KF_DoomMonster extends KFMonster
    Config(ApocMonsters);

#exec obj load file="2009DoomMonstersSounds.uax"
#exec obj load file="2009DoomMonstersTex.utx"
#exec obj load file="2009DoomMonstersAnims.ukx"
#exec obj load file="2009DoomMonstersSM.usx"

var Doom3KF_Archvile ArchvileMaster;
var Doom3KF_TriggerSpawnDemon SpawnFactory;

var(Anims) name DeathAnims[4], SightAnim;
var(Anims) array<name> HitAnimsX;
var(Anims) float MinHitAnimDelay;
var(Sounds) Sound MissSound[4], CollapseSound[2], MeleeAttackSounds[4], SightSound, DeResSound;
var(Sounds) array<Sound> RunStepSounds;
var(Burn) Material InvisMat, BurningMaterial;
var(Burn) class<Doom3KF_DoomBurnTex> BurnClass;
var(Burn) class<MaterialSequence> FadeClass;
var(Burn) class<Doom3KF_DoomDeResDustSmall> BurnDust;
var() float MeleeKnockBack, FootstepSndRadius;
var() class<Projectile> RangedProjectile;
var() class<Doom3KF_DemonSpawnBase> DoomTeleportFXClass;
var() byte BurnedTextureNum[2];

var(Anims) bool HasHitAnims;
var() bool bHasFireWeakness, BigMonster;
var bool Collapsing, bWasBossPat;
var bool Burning;
var bool bHasRoamed;
var bool bIsBossSpawn;

var byte RagdollStateNum;
var Doom3KF_DoomDeResDustSmall Sparks;
var Mesh SecondMesh;
var int AimError;
var float BurnAnimTime;
var int BurnSpeed;
var Doom3KF_DoomBurnTex BurnFX;
var MaterialSequence FadeFX;
var Material FadingBurnMaterial;
var transient float nextHitAnimTime, nextChallengeVoice;

simulated function PostNetBeginPlay()
{
    Super.PostNetBeginPlay();
    HealthMax = Max(HealthMax, Health); // Fix for commando healthbar with bosses.
}

simulated function RemoveFlamingEffects()
{
    local int i;

    if (Level.NetMode == NM_DedicatedServer)
        return;

    for (i = 0; i < Attached.length; i++)
    {
        if (xEmitter(Attached[i]) != none)
        {
            xEmitter(Attached[i]).mRegen = false;
            Attached[i].LifeSpan = 2;
        }
        else if (Emitter(Attached[i]) != None && !Attached[i].IsA('DismembermentJet') && !Attached[i].IsA('Doom3KF_DoomEmitter'))
        {
            Emitter(Attached[i]).Kill();
            Attached[i].LifeSpan = 2;
        }
    }
}

event bool EncroachingOn(actor Other)
{
    if (bIsBossSpawn && Pawn(Other) != None)
        return false;
    return Super.EncroachingOn(Other);
}

function PlayChallengeSound()
{
    if (nextChallengeVoice<Level.TimeSeconds)
    {
        PlaySound(ChallengeSound[Rand(4)], SLOT_Talk);
        nextChallengeVoice = Level.TimeSeconds+4.f+FRand()*6.f;
    }
}

function NotifyTeleport()
{
    if (HasAnim('Teleport'))
    {
        PrepareStillAttack(None);
        SetAnimAction('Teleport');
    }
}

simulated function PostNetReceive();

simulated function PostBeginPlay()
{
    bHasRoamed = (FRand()<0.75);
    Super.PostBeginPlay();
}

final function bool IsInMeleeRange(Actor A, optional float ExtendedRange)
{
    local vector D;

    if (A.IsA('KFDoorMover'))
        return true;
    D = A.Location-Location;
    if (Abs(D.Z)>(CollisionHeight+A.CollisionHeight+MeleeRange))
        return false;
    D.Z = 0;
    return (VSize(D)<(CollisionRadius+A.CollisionRadius+(MeleeRange+ExtendedRange)));
}
function bool MeleeDamageTarget(int hitdamage, vector pushdir)
{
    local Actor A;

    if (Level.NetMode==NM_Client || Controller==None || Controller.Target==None)
        Return False;
    A = Controller.Target;
    if (IsInMeleeRange(A, 0.5f))
    {
        A.TakeDamage(hitdamage, self, Normal(Location-A.Location)*A.CollisionRadius+A.Location, pushdir, CurrentDamType);
        Return True;
    }
    return false;
}

// While enemy is not in reach but still in sight.
function bool ShouldTryRanged(Actor A)
{
    return false;
}

function bool ShouldChargeAtPlayer()
{
    return true;
}

final function PrepareStillAttack(Actor A)
{
    if (A != None)
        Controller.Target = A;
    bShotAnim = true;
    Controller.bPreparingMove = true;
    Acceleration = vect(0, 0, 0);
}
final function PrepareMovingAttack(Actor A, float MoveSpeed)
{
    Controller.Target = A;
    DesiredSpeed = Abs(MoveSpeed); // Slow down...
    Acceleration = Normal(A.Location-Location)*GroundSpeed;
    if (MoveSpeed<0)
    {
        Controller.MoveTarget = None;
        Acceleration = -Acceleration;
    }
    else Controller.MoveTarget = A;
    bShotAnim = true;
}
simulated final function name GetCurrentAnim()
{
    local name Anim;
    local float frame, rate;

    GetAnimParams(0, Anim, frame, rate);
    return Anim;
}
simulated function AnimEnd(int Channel)
{
    AnimAction = '';
    if (bShotAnim && Channel==ExpectingChannel)
    {
        bShotAnim = false;
        if (Controller != None)
            Controller.bPreparingMove = false;
        if (DesiredSpeed>0)
            DesiredSpeed = MaxDesiredSpeed; // Reset movement speed.
    }
    if (!bPhysicsAnimUpdate && Channel==0)
        bPhysicsAnimUpdate = Default.bPhysicsAnimUpdate;
    Super(xPawn).AnimEnd(Channel);
}

simulated function RemoveEffects();

simulated function Tick(float DeltaTime)
{
    if (bResetAnimAct && ResetAnimActTime<Level.TimeSeconds)
    {
        AnimAction = '';
        bResetAnimAct = False;
    }

    if (Level.NetMode != NM_DedicatedServer)
    {
        TickFX(DeltaTime);

        if (bBurnified && !bBurnApplied)
        {
            if (!bGibbed)
                StartBurnFX();
        }
        else if (!bBurnified && bBurnApplied)
        {
            StopBurnFX();
        }
        if (bAshen && Level.NetMode == NM_Client && !class'GameInfo'.static.UseLowGore())
        {
            ZombieCrispUp();
            bAshen = False;
        }
    }
    if (BileCount > 0 && NextBileTime<level.TimeSeconds)
    {
        --BileCount;
        NextBileTime+=BileFrequency;
        TakeBileDamage();
    }
}
function bool FlipOver()
{
    return false;
}
simulated function FreeFXObjects()
{
    if (FadeFX != None)
    {
        Level.ObjectPool.FreeObject(FadeFX);
        FadeFX = None;
    }
    if (BurnFX != None)
    {
        BurnFX.AlphaRef = 0;
        Level.ObjectPool.FreeObject(BurnFX);
        BurnFX = None;
    }
}

function MeleeAttack()
{
    if (Controller != None && Controller.Target != None)
    {
        if (MeleeDamageTarget(MeleeDamage, (MeleeKnockBack * Normal(Controller.Target.Location - Location))))
            PlaySound(MeleeAttackSounds[Rand(ArrayCount(MeleeAttackSounds))], SLOT_Interact);
        else PlaySound(MissSound[Rand(ArrayCount(MissSound))], SLOT_Interact);
    }
}

function PlayMoverHitSound()
{
    PlaySound(HitSound[0], SLOT_Interact);
}

function bool SameSpeciesAs(Pawn P)
{
    return (Doom3KF_DoomMonster(P) != None);
}

simulated function PlayDirectionalDeath(Vector HitLoc)
{
    if (Level.NetMode==NM_DedicatedServer)
    {
        SetCollision(false, false, false);
        return;
    }
    InitFX();
    SetCollision(false, false, false);
    PlayDeathAnim();
}
simulated final function InitFX()
{
    BurnFX = Doom3KF_DoomBurnTex(Level.ObjectPool.AllocateObject(BurnClass));
    FadeFX = MaterialSequence(Level.ObjectPool.AllocateObject(FadeClass));
    if (FadeFX != None && BurnFX != None)
    {
        FadeFX.SequenceItems[0].Material = BurningMaterial;
        SetOverlayMaterial(None, 0.0f, true);
        Projectors.Remove(0, Projectors.Length);
        bAcceptsProjectors = false;
        if (PlayerShadow != None)
            PlayerShadow.bShadowActive = false;
        RemoveFlamingEffects();
    }
}
simulated function PlayDeathAnim()
{
    PlayAnim(DeathAnims[Rand(4)], BurnAnimTime, 0.1);
}

function PlayDirectionalHit(Vector HitLoc)
{
    if (HasHitAnims && !bShotAnim && nextHitAnimTime<Level.TimeSeconds && HitAnimsX.Length>0)
    {
        nextHitAnimTime = Level.TimeSeconds+MinHitAnimDelay+FRand()*MinHitAnimDelay;
        PrepareStillAttack(None);
        SetAnimAction(HitAnimsX[Rand(HitAnimsX.Length)]);
    }
}

function Sound GetSound(xPawnSoundGroup.ESoundType soundType)
{
    return None;
}

function PlayTakeHit(vector HitLocation, int Damage, class<DamageType> DamageType)
{
    if (Damage > 35 && BigMonster)
        Super.PlayTakeHit(HitLocation, Damage, DamageType);
    else if (Damage > 20)
        Super.PlayTakeHit(HitLocation, Damage, DamageType);
}

simulated function RunStep()
{
    if (RunStepSounds.Length==0)
        PlaySound(Footstep[Rand(ArrayCount(Footstep))], SLOT_Interact, 1, , FootstepSndRadius);
    else PlaySound(RunStepSounds[Rand(RunStepSounds.Length)], SLOT_Interact, 1, , FootstepSndRadius);
}

function AddVelocity(vector NewVelocity)
{
    if ((Velocity.Z > 350) && (NewVelocity.Z > 1000))
        NewVelocity.Z *= 0.5;
    Velocity += NewVelocity;
}

simulated function SpawnSparksFX()
{
    if (Level.NetMode != NM_DedicatedServer)
        Sparks = Spawn(BurnDust, Self);
}

simulated function Destroyed()
{
    if (SpawnFactory != None)
    {
        SpawnFactory.NotifyMobDied();
        SpawnFactory = None;
    }
    if (Sparks != None)
        Sparks.KillFX();

    FreeFXObjects();
    RemoveEffects();
    Super.Destroyed();
}

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
    local Controller C;

    if (SpawnFactory != None)
    {
        SpawnFactory.NotifyMobDied();
        SpawnFactory = None;
    }
    if (bWasBossPat)
    {
        KFGameType(Level.Game).DoBossDeath();
        for (C=Level.ControllerList; C != None; C=C.NextController)
        {
            if (PlayerController(C) != None)
            {
                PlayerController(C).SetViewTarget(Self);
                PlayerController(C).ClientSetViewTarget(Self);
                PlayerController(C).bBehindView = true;
                PlayerController(C).ClientSetBehindView(True);
            }
        }
    }
    Super.Died(Killer, damageType, HitLocation);
}

simulated function Collapse()
{
    Collapsing = true;
    PlaySound(CollapseSound[Rand(2)], SLOT_Interact);
}

simulated function PlayCollapseSound()
{
    PlaySound(CollapseSound[Rand(2)], SLOT_Talk);
}

simulated function StartDeRes()
{
    if (Level.NetMode == NM_DedicatedServer)
        return;
    AmbientSound = None;
    bDeRes = true;
}
function Projectile FireProj(vector Position)
{
    if (!SavedFireProperties.bInitialized)
    {
        SavedFireProperties.AmmoClass = Class'SkaarjAmmo';
        SavedFireProperties.ProjectileClass = RangedProjectile;
        SavedFireProperties.WarnTargetPct = 0.5f;
        SavedFireProperties.MaxRange = RangedProjectile.Default.Speed*RangedProjectile.Default.LifeSpan;
        SavedFireProperties.bTossed = (RangedProjectile.Default.Physics==PHYS_Falling);
        SavedFireProperties.bTrySplash = (RangedProjectile.Default.DamageRadius>20.f);
        SavedFireProperties.bLeadTarget = true;
        SavedFireProperties.bInstantHit = false;
        SavedFireProperties.bInitialized = true;
    }
    return Spawn(RangedProjectile, , , Position, Controller.AdjustAim(SavedFireProperties, Position, 500.f));
}
function DoorAttack(Actor A)
{
    RangedAttack(A);
}
simulated function PlayDyingAnimation(class<DamageType> DamageType, vector HitLoc)
{
    local vector shotDir, hitLocRel, deathAngVel, shotStrength;
    local float maxDim;
    local KarmaParamsSkel skelParams;
    local bool PlayersRagdoll;
    local PlayerController pc;

    if (MyExtCollision != None)
        MyExtCollision.Destroy();
    if (ArchvileMaster != None)
    {
        ArchvileMaster.MonsterCounter--;
        ArchvileMaster = None;
    }

    RemoveEffects();
    if (Level.NetMode != NM_DedicatedServer && Class'Doom3KF_D3Karma'.Static.UseRagdoll() && Len(RagdollOverride)>0)
    {
        // Is this the local player's ragdoll?
        if (OldController != None)
            pc = PlayerController(OldController);
        if (pc != None && pc.ViewTarget == self)
            PlayersRagdoll = true;

        // In low physics detail, if we were not just controlling this pawn,
        // and it has not been rendered in 3 seconds, just destroy it.

        if (Level.NetMode == NM_ListenServer)
        {
            // For a listen server, use LastSeenOrRelevantTime instead of render time so
            // monsters don't disappear for other players that the host can't see - Ramm
            if (Level.PhysicsDetailLevel != PDL_High && !PlayersRagdoll && ((Level.TimeSeconds-LastSeenOrRelevantTime)>3 || bGibbed))
            {
                Destroy();
                return;
            }
        }
        else if (Level.PhysicsDetailLevel != PDL_High && !PlayersRagdoll && ((Level.TimeSeconds-LastRenderTime)>3 || bGibbed))
        {
            Destroy();
            return;
        }

        KMakeRagdollAvailable();
        if (KIsRagdollAvailable())
        {
            skelParams = KarmaParamsSkel(KParams);
            skelParams.KSkeleton = RagdollOverride;

            // Stop animation playing.
            StopAnimating(true);

            // StopAnimating() resets the neck bone rotation, we have to set it again
            // if the zed was decapitated the cute way
            if (class'GameInfo'.static.UseLowGore() && NeckRot != rot(0, 0, 0))
                SetBoneRotation('neck', NeckRot);

            if (DamageType != none)
            {
                if (DamageType.default.bLeaveBodyEffect)
                    TearOffMomentum = vect(0, 0, 0);

                if (DamageType.default.bKUseOwnDeathVel)
                {
                    RagDeathVel = DamageType.default.KDeathVel;
                    RagDeathUpKick = DamageType.default.KDeathUpKick;
                    RagShootStrength = DamageType.default.KDamageImpulse;
                }
            }

            // Set the dude moving in direction he was shot in general
            shotDir = Normal(GetTearOffMomemtum());
            shotStrength = RagDeathVel * shotDir;

            // Calculate angular velocity to impart, based on shot location.
            hitLocRel = TakeHitLocation - Location;

            if (DamageType.default.bLocationalHit)
            {
                hitLocRel.X *= RagSpinScale;
                hitLocRel.Y *= RagSpinScale;

                if (Abs(hitLocRel.X)  > RagMaxSpinAmount)
                {
                    if (hitLocRel.X < 0)
                    {
                        hitLocRel.X = FMax((hitLocRel.X * RagSpinScale), (RagMaxSpinAmount * -1));
                    }
                    else
                    {
                        hitLocRel.X = FMin((hitLocRel.X * RagSpinScale), RagMaxSpinAmount);
                    }
                }

                if (Abs(hitLocRel.Y)  > RagMaxSpinAmount)
                {
                    if (hitLocRel.Y < 0)
                    {
                        hitLocRel.Y = FMax((hitLocRel.Y * RagSpinScale), (RagMaxSpinAmount * -1));
                    }
                    else
                    {
                        hitLocRel.Y = FMin((hitLocRel.Y * RagSpinScale), RagMaxSpinAmount);
                    }
                }

            }
            else
            {
                // We scale the hit location out sideways a bit, to get more spin around Z.
                hitLocRel.X *= RagSpinScale;
                hitLocRel.Y *= RagSpinScale;
            }

            // If the tear off momentum was very small for some reason, make up some angular velocity for the pawn
            if (VSize(GetTearOffMomemtum()) < 0.01)
            {
                //Log("TearOffMomentum magnitude of Zero");
                deathAngVel = VRand() * 18000.0;
            }
            else
            {
                deathAngVel = RagInvInertia * (hitLocRel cross shotStrength);
            }

            // Set initial angular and linear velocity for ragdoll.
            // Scale horizontal velocity for characters - they run really fast!
            if (DamageType.Default.bRubbery)
                skelParams.KStartLinVel = vect(0, 0, 0);
            if (Damagetype.default.bKUseTearOffMomentum)
                skelParams.KStartLinVel = GetTearOffMomemtum() + Velocity;
            else
            {
                skelParams.KStartLinVel.X = 0.6 * Velocity.X;
                skelParams.KStartLinVel.Y = 0.6 * Velocity.Y;
                skelParams.KStartLinVel.Z = 1.0 * Velocity.Z;
                skelParams.KStartLinVel += shotStrength;
            }
            // If not moving downwards - give extra upward kick
            if (!DamageType.default.bLeaveBodyEffect && !DamageType.Default.bRubbery && (Velocity.Z > -10))
                skelParams.KStartLinVel.Z += RagDeathUpKick;

            if (DamageType.Default.bRubbery)
            {
                Velocity = vect(0, 0, 0);
                skelParams.KStartAngVel = vect(0, 0, 0);
            }
            else
            {
                skelParams.KStartAngVel = deathAngVel;

                // Set up deferred shot-bone impulse
                maxDim = Max(CollisionRadius, CollisionHeight);

                skelParams.KShotStart = TakeHitLocation - (1 * shotDir);
                skelParams.KShotEnd = TakeHitLocation + (2*maxDim*shotDir);
                skelParams.KShotStrength = RagShootStrength;
            }

            //log("RagDeathVel = "$RagDeathVel$" KShotStrength = "$skelParams.KShotStrength$" RagDeathUpKick = "$RagDeathUpKick);

            // If this damage type causes convulsions, turn them on here.
            if (DamageType != none && DamageType.default.bCauseConvulsions)
            {
                RagConvulseMaterial=DamageType.default.DamageOverlayMaterial;
                skelParams.bKDoConvulsions = true;
            }

            // Turn on Karma collision for ragdoll.
            KSetBlockKarma(true);

            // Set physics mode to ragdoll.
            // This doesn't actaully start it straight away, it's deferred to the first tick.
            SetPhysics(PHYS_KarmaRagdoll);

            // If viewing this ragdoll, set the flag to indicate that it is 'important'
            if (PlayersRagdoll)
                skelParams.bKImportantRagdoll = true;

            skelParams.bRubbery = DamageType.Default.bRubbery;
            bRubbery = DamageType.Default.bRubbery;
            skelParams.KActorGravScale = RagGravScale;
            return;
        }
    }

    // non-ragdoll death fallback
    Velocity += GetTearOffMomemtum();
    BaseEyeHeight = Default.BaseEyeHeight;
    SetTwistLook(0, 0);
    SetInvisibility(0.0);
    PlayDirectionalDeath(HitLoc);
    SetPhysics(PHYS_Falling);
}
function RoamAtPlayer()
{
    bHasRoamed = true;
    PlaySound(SightSound, SLOT_Talk, 2);
    if (SightAnim != '')
    {
        Controller.bPreparingMove = true;
        SetAnimAction(SightAnim);
        Acceleration = vect(0, 0, 0);
        bShotAnim = true;
    }
}
function RemoveHead();

function bool SetBossLaught()
{
    local Controller C;

    if (!bBoss)
        return false;
    GoToState('');
    RoamAtPlayer();
    for (C=Level.ControllerList; C != None; C=C.NextController)
    {
        if (PlayerController(C) != None)
        {
            PlayerController(C).SetViewTarget(Self);
            PlayerController(C).ClientSetViewTarget(Self);
            PlayerController(C).ClientSetBehindView(True);
        }
    }
    Return True;
}
function bool MakeGrandEntry()
{
    Health+=(FMax(0.f, Level.Game.NumPlayers-1)*Class'Doom3KFMut'.Default.BossPerPlayerHP*float(Default.Health));
    RoamAtPlayer();
    bWasBossPat = true;
    return True;
}

simulated final function MakeBurnAway()
{
    if (Level.NetMode==NM_DedicatedServer)
        return;
    Enable('Tick');
    if (FadeFX != None)
        FadeFX.Reset();
}
simulated function BurnAway();
simulated function FadeSkins();

simulated event SetAnimAction(name NewAction)
{
    if (NewAction=='')
        Return;
    ExpectingChannel = DoAnimAction(NewAction);

    if (AnimNeedsWait(NewAction))
    {
        bPhysicsAnimUpdate = false; // Prevent movement animations to mess up me.
        bWaitForAnim = true;
    }
    else bWaitForAnim = false;

    if (Level.NetMode != NM_Client)
    {
        AnimAction = NewAction;
        bResetAnimAct = True;
        ResetAnimActTime = Level.TimeSeconds+0.3;
    }
}
simulated function int DoAnimAction(name AnimName)
{
    PlayAnim(AnimName, , 0.1);
    return 0;
}
function ZombieMoan();

simulated function ZombieCrispUp()
{
    local byte i;

    bAshen = true;
    bCrispified = true;

    SetBurningBehavior();

    if (Level.NetMode == NM_DedicatedServer || class'GameInfo'.static.UseLowGore())
        Return;

    for (i=0; i<ArrayCount(BurnedTextureNum); ++i)
        if (BurnedTextureNum[i]<255)
            Skins[BurnedTextureNum[i]] = Texture'PatchTex.Common.ZedBurnSkin';
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType, optional int HitIndex)
{
    local bool bIsHeadshot;
    local KFPlayerReplicationInfo KFPRI;
    local float HeadShotCheckScale;

    LastDamagedBy = instigatedBy;
    LastDamagedByType = damageType;
    HitMomentum = VSize(momentum);
    LastHitLocation = hitlocation;
    LastMomentum = momentum;

    // Zeds and fire dont mix.
    if (bHasFireWeakness && (class<DamTypeBurned>(damageType) != none || class<DamTypeFlamethrower>(damageType) != none))
    {
        LastBurnDamage = Damage;
        Damage *= 1.5;
        if (BurnDown<=0)
        {
            if (HeatAmount>4 || Damage >= 15)
            {
                bBurnified = true;
                BurnDown = 10;
                GroundSpeed *= 0.80;
                BurnInstigator = instigatedBy;
                SetTimer(1.0, true);
            }
            else HeatAmount++;
        }
    }

    if (class<KFWeaponDamageType>(damageType) != none && class<KFWeaponDamageType>(damageType).default.bCheckForHeadShots)
    {
        HeadShotCheckScale = 1.0;

        // Do larger headshot checks if it is a melee attach
        if (class<DamTypeMelee>(damageType) != none)
            HeadShotCheckScale *= 1.25;
        bIsHeadShot = IsHeadShot(hitlocation, normal(momentum), HeadShotCheckScale);
    }

    if (KFPawn(instigatedBy) != none && instigatedBy.PlayerReplicationInfo != none)
        KFPRI = KFPlayerReplicationInfo(instigatedBy.PlayerReplicationInfo);

    if (KFPRI != none)
    {
        if (KFPRI.ClientVeteranSkill != none)
            Damage = KFPRI.ClientVeteranSkill.Static.AddDamage(KFPRI, self, KFPawn(instigatedBy), Damage, DamageType);
    }

    if (bIsHeadShot && class<DamTypeBurned>(DamageType) == none && class<DamTypeFlamethrower>(DamageType) == none)
    {
        if (class<KFWeaponDamageType>(damageType) != none)
            Damage = Damage * class<KFWeaponDamageType>(damageType).default.HeadShotDamageMult;

        if (class<DamTypeMelee>(damageType) == none && KFPRI != none && KFPRI.ClientVeteranSkill != none)
            Damage = float(Damage) * KFPRI.ClientVeteranSkill.Static.GetHeadShotDamMulti(KFPRI, KFPawn(instigatedBy), damageType);

        LastDamageAmount = Damage;

        PlaySound(sound'KF_EnemyGlobalSndTwo.Impact_Skull', SLOT_None, 2.0, true, 500);
    }

    if ((Health-Damage)>0 && DamageType != class'DamTypeFrag' && DamageType != class'DamTypePipeBomb'
         && DamageType != class'DamTypeM79Grenade' && DamageType != class'DamTypeM32Grenade')
        Momentum = vect(0, 0, 0);

    if (class<DamTypeVomit>(DamageType) != none) // Same rules apply to zombies as players.
    {
        BileCount=7;
        BileInstigator = instigatedBy;
        if (NextBileTime< Level.TimeSeconds)
            NextBileTime = Level.TimeSeconds+BileFrequency;
    }

    Super(Monster).TakeDamage(Damage, instigatedBy, hitLocation, momentum, damageType, HitIndex);

    if (bIsHeadShot && Health<=0)
    {
        KFGameType(Level.Game).DramaticEvent(0.03);

        // Award headshot here.
        if (Class<KFWeaponDamageType>(damageType) != None && instigatedBy != None && KFPlayerController(instigatedBy.Controller) != None)
        {
            bLaserSightedEBRM14Headshotted = M14EBRBattleRifle(instigatedBy.Weapon) != none && M14EBRBattleRifle(instigatedBy.Weapon).bLaserActive;
          //Class<KFWeaponDamageType>(damageType).Static.ScoredHeadshot(KFSteamStatsAndAchievements(PlayerController(instigatedBy.Controller).SteamStatsAndAchievements), bLaserSightedEBRM14Headshotted);
            Class<KFWeaponDamageType>(damageType).Static.ScoredHeadshot(KFSteamStatsAndAchievements(PlayerController(instigatedBy.Controller).SteamStatsAndAchievements), self.Class, bLaserSightedEBRM14Headshotted);
        }
    }
}

function bool IsHeadShot(vector loc, vector ray, float AdditionalScale)
{
    local coords C;
    local vector HeadLoc, B, M, diff;
    local float t, DotMM, Distance;
    local int look;
    local bool bWasAnimating;

    if (HeadBone == '')
        return False;

    // If we are a dedicated server estimate what animation is most likely playing on the client
    if (Level.NetMode == NM_DedicatedServer && !bShotAnim)
    {
        if (Physics == PHYS_Falling)
            PlayAnim(AirAnims[0], 1.0, 0.0);
        else if (Physics == PHYS_Walking)
        {
            if (!IsAnimating(0) && !IsAnimating(1))
            {
                if (bIsCrouched)
                    PlayAnim(IdleCrouchAnim, 1.0, 0.0);
                else if (VSizeSquared(Acceleration)<150.f)
                    PlayAnim(IdleRestAnim, 1.0, 0.0);
                else PlayAnim(MovementAnims[0], 1.0, 0.0);
            }
            else bWasAnimating = true;

            if (bDoTorsoTwist)
            {
                SmoothViewYaw = Rotation.Yaw;
                SmoothViewPitch = ViewPitch;

                look = (256 * ViewPitch) & 65535;
                if (look > 32768)
                    look -= 65536;
                SetTwistLook(0, look);
            }
        }
        else if (Physics == PHYS_Swimming && !bShotAnim)
            PlayAnim(SwimAnims[0], 1.0, 0.0);
        if (!bWasAnimating)
            SetAnimFrame(0.5);
    }
    C = GetBoneCoords(HeadBone);
    HeadLoc = C.Origin + (HeadHeight * HeadScale * AdditionalScale * C.XAxis);

    // Express snipe trace line in terms of B + tM
    B = loc;
    M = ray * (2.0 * CollisionHeight + 2.0 * CollisionRadius);

    // Find Point-Line Squared Distance
    diff = HeadLoc - B;
    t = M Dot diff;
    if (t > 0)
    {
        DotMM = M dot M;
        if (t < DotMM)
        {
            t = t / DotMM;
            diff = diff - (t * M);
        }
        else
        {
            t = 1;
            diff -= M;
        }
    }
    else t = 0;

    Distance = Sqrt(diff Dot diff);
    return (Distance < (HeadRadius * HeadScale * AdditionalScale));
}

State ZombieDying
{
ignores PostNetReceive;

    simulated function BeginState()
    {
        if (bTearOff && ((Level.NetMode == NM_DedicatedServer) || class'GameInfo'.static.UseLowGore()))
            LifeSpan = 1.0;
        else SetTimer(2.0, false);

        if (Physics != PHYS_KarmaRagdoll)
            SetPhysics(PHYS_Falling);
        if (Controller != None)
            Controller.Destroy();
    }
    function Landed(vector HitNormal)
    {
        if (!IsAnimating(0))
            LandThump();
    }
    simulated function Timer()
    {
        if ((Level.TimeSeconds-LastRenderTime)>3.f)
            Destroy();
        else
        {
            SetTimer(1.0, false);
            if (Physics==PHYS_KarmaRagdoll)
            {
                if (RagdollStateNum==0)
                {
                    InitFX();
                    ++RagdollStateNum;
                    FadeSkins();
                }
                else if (RagdollStateNum==1)
                {
                    ++RagdollStateNum;
                    BurnAway();
                    bUnlit = true;
                    SpawnSparksFX();
                }
            }
        }
    }
    simulated function Tick(float deltatime)
    {
        if (Burning && BurnFX != None)
        {
            if (!bUnlit)
            {
                bUnlit = true;
                SpawnSparksFX();
            }
            if (BurnFX.AlphaRef<255)
                BurnFX.AlphaRef = Min(BurnFX.AlphaRef+BurnSpeed, 255);
            else
            {
                bHidden = true;
                Disable('Tick');
                LifeSpan = 0.1f;
            }
        }
    }
    simulated function TakeDamage(int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
    {
        local Vector HitNormal, shotDir;
        local Vector PushLinVel, PushAngVel;
        local Name HitBone;
        local float HitBoneDist;
        local vector HitRay;

        if (bFrozenBody || bRubbery || Physics != PHYS_KarmaRagdoll || Burning)
            return;

        // Throw the body if its a rocket explosion or shock combo
        if (damageType.Default.bThrowRagdoll)
        {
            shotDir = Normal(Momentum);
            PushLinVel = (RagDeathVel * shotDir) +  vect(0, 0, 250);
            PushAngVel = Normal(shotDir Cross vect(0, 0, 1)) * -18000;
            KSetSkelVel(PushLinVel, PushAngVel);
        }
        else if (damageType.Default.bRagdollBullet)
        {
            if (Momentum == vect(0, 0, 0))
                Momentum = HitLocation - InstigatedBy.Location;
            if (FRand() < 0.65)
            {
                if (Velocity.Z <= 0)
                    PushLinVel = vect(0, 0, 40);
                PushAngVel = Normal(Normal(Momentum) Cross vect(0, 0, 1)) * -8000 ;
                PushAngVel.X *= 0.5;
                PushAngVel.Y *= 0.5;
                PushAngVel.Z *= 4;
                KSetSkelVel(PushLinVel, PushAngVel);
            }
            PushLinVel = RagShootStrength*Normal(Momentum);
            KAddImpulse(PushLinVel, HitLocation);
            if ((LifeSpan > 0) && (LifeSpan < DeResTime + 2))
                LifeSpan += 0.2;
        }
        else
        {
            PushLinVel = RagShootStrength*Normal(Momentum);
            KAddImpulse(PushLinVel, HitLocation);
        }

            HitRay = vect(0, 0, 0);
            if (InstigatedBy != none)
                HitRay = Normal(HitLocation-(InstigatedBy.Location+(vect(0, 0, 1)*InstigatedBy.EyeHeight)));

        CalcHitLoc(HitLocation, HitRay, HitBone, HitBoneDist);

        if (InstigatedBy != None)
            HitNormal = Normal(Normal(InstigatedBy.Location-HitLocation) + VRand() * 0.2 + vect(0, 0, 2.8));
        else
            HitNormal = Normal(Vect(0, 0, 1) + VRand() * 0.2 + vect(0, 0, 2.8));

            // Actually do blood on a client
            PlayHit(Damage, InstigatedBy, hitLocation, damageType, Momentum);
        DoDamageFX(HitBone, Damage, DamageType, Rotator(HitNormal));
    }
}

defaultproperties
{
     MinHitAnimDelay=1.250000
     MissSound(0)=Sound'2009DoomMonstersSounds.Imp.imp_miss_01'
     MissSound(1)=Sound'2009DoomMonstersSounds.Imp.imp_miss_03'
     MissSound(2)=Sound'2009DoomMonstersSounds.Imp.imp_miss_01'
     MissSound(3)=Sound'2009DoomMonstersSounds.Imp.imp_miss_03'
     CollapseSound(0)=Sound'2009DoomMonstersSounds.Trite.Trite_deathsplat_01'
     CollapseSound(1)=Sound'2009DoomMonstersSounds.Trite.Trite_deathsplat_04'
     InvisMat=Texture'2009DoomMonstersTex.Revenant.InvisMat'
     BurningMaterial=Texture'2009DoomMonstersTex.FatZombie.FattySkin'
     BurnClass=Class'Doom3KF_DoomBurnTex'
     FadeClass=Class'Doom3KF_DoomMaterialSequence'
     BurnDust=Class'Doom3KF_DoomDeResDustMedium'
     MeleeKnockBack=5000.000000
     FootstepSndRadius=600.000000
     DoomTeleportFXClass=Class'Doom3KF_DemonSpawn'
     BurnedTextureNum(1)=255
     bHasFireWeakness=True
     BurnAnimTime=1.000000
     BurnSpeed=1
     FadingBurnMaterial=Texture'2009DoomMonstersTex.Symbols.DoomFire'
     CurrentDamType=Class'Doom3KF_DamTypeD3Melee'
     DeResTime=2.000000
     DeResGravScale=10.000000
     bCanWalkOffLedges=True
     HeadScale=1.000000
     ControllerClass=Class'Doom3KF_Doom3Controller'
     bDoTorsoTwist=False
     DrawScale=1.400000
     TransientSoundVolume=1.700000
}
