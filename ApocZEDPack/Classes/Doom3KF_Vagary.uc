class Doom3KF_Vagary extends Doom3KF_DoomMonster;

var Emitter Jet, HandTrail;
var transient float NextRangedTime;
var(Sounds) Sound PreFireSound;

function RangedAttack(Actor A)
{
    if (bShotAnim)
        return;

    if (!bHasRoamed)
        RoamAtPlayer();
    else if (IsInMeleeRange(A))
    {
        PrepareStillAttack(A);
        SetAnimAction('Melee1');
    }
    else if (NextRangedTime<Level.TimeSeconds)
    {
        PrepareStillAttack(A);
        if (FRand()<0.5f)
            SetAnimAction('RangedAttack2');
        else SetAnimAction('RangedAttack1');
        if (Health>1000)
            NextRangedTime = Level.TimeSeconds+2.f+FRand()*3.f;
        else NextRangedTime = Level.TimeSeconds+0.5f+FRand()*2.f;
        PlaySound(PreFireSound, SLOT_Misc, 2, , 500.f);
        SpawnProject(A);
    }
}
function bool ShouldTryRanged(Actor A)
{
    return (NextRangedTime<Level.TimeSeconds && FRand()<0.8f);
}

final function SpawnProject(Actor A)
{
    local vector NDir, Point, HL, HN;
    local byte i;

    NDir = Location-A.Location;
    NDir.Z = 0;
    NDir = A.Location+Normal(NDir)*400.f;
    while(++i<20)
    {
        Point = NDir;
        Point.X+=(500.f*FRand()-250.f);
        Point.Y+=(500.f*FRand()-250.f);
        if (Trace(HL, HN, Point-vect(0, 0, 600.f), Point, false)==None)
            continue;
        Point = HL+HN*4.f;
        if (FastTrace(A.Location, Point+vect(0, 0, 100)))
            break;
    }
    Spawn(RangedProjectile, , , Point, rotator(A.Location-Point));
}
simulated function FireProjectile()
{
    if (HandTrail != None)
        HandTrail.Kill();
}
simulated function FireLProjectile()
{
    if (HandTrail != None)
        HandTrail.Kill();
}
simulated function int DoAnimAction(name AnimName)
{
    if (Level.NetMode != NM_DedicatedServer)
    {
        if (AnimName=='RangedAttack2')
        {
            HandTrail = Spawn(Class'Doom3KF_VagaryHandTrail');
            AttachToBone(HandTrail, 'Lmid1');
        }
        else if (AnimName=='RangedAttack1')
        {
            HandTrail = Spawn(Class'Doom3KF_VagaryHandTrail');
            AttachToBone(HandTrail, 'Rmid1');
        }
    }
    PlayAnim(AnimName, , 0.1);
    return 0;
}
simulated function LeakSpawn()
{
    if (Level.NetMode != NM_DedicatedServer && Jet==None)
    {
        Jet = Spawn(class'ROBloodSpurt', self);
        AttachToBone(Jet, 'Belly');
    }
}

simulated function RemoveEffects()
{
    if (Jet != None)
    {
        Jet.Kill();
        Jet.LifeSpan = 1.f;
    }
    if (HandTrail != None)
        HandTrail.Kill();
}

simulated function FadeSkins()
{
    Skins[0] = FadeFX;
    Skins[1] = InvisMat;
    MakeBurnAway();
}

simulated function BurnAway()
{
    Skins[0] = BurnFX;
    Skins[2] = BurnFX;
    Burning = true;
}

defaultproperties
{
     PreFireSound=Sound'2009DoomMonstersSounds.Vagary.Vagary_Pickup'
     DeathAnims(0)="DeathF"
     DeathAnims(1)="DeathB"
     DeathAnims(2)="DeathCurl"
     DeathAnims(3)="DeathB"
     SightAnim="Sight"
     HitAnimsX(0)="Pain_L"
     HitAnimsX(1)="Pain_R"
     HitAnimsX(2)="Pain_Head"
     HitAnimsX(3)="Pain_Chest"
     MeleeAttackSounds(0)=Sound'2009DoomMonstersSounds.Vagary.Vagary_Attack1'
     MeleeAttackSounds(1)=Sound'2009DoomMonstersSounds.Vagary.Vagary_Attack2'
     MeleeAttackSounds(2)=Sound'2009DoomMonstersSounds.Vagary.Vagary_Attack3'
     MeleeAttackSounds(3)=Sound'2009DoomMonstersSounds.Vagary.Vagary_Attack2'
     SightSound=Sound'2009DoomMonstersSounds.Vagary.Vagary_Stand'
     BurnClass=Class'Doom3KF_VagaryBurnTex'
     FadeClass=Class'Doom3KF_VagaryMaterialSequence'
     MeleeKnockBack=25000.000000
     RangedProjectile=Class'Doom3KF_VagaryClassicProj'
     DoomTeleportFXClass=Class'Doom3KF_BossDemonSpawn'
     HasHitAnims=True
     BigMonster=True
     aimerror=10
     BurnAnimTime=0.500000
     MeleeDamage=40
     bUseExtendedCollision=True
     ColOffset=(X=13.000000,Z=41.000000)
     ColRadius=45.000000
     ColHeight=30.000000
     FootStep(0)=Sound'2009DoomMonstersSounds.Vagary.Vagary_footstep1'
     FootStep(1)=Sound'2009DoomMonstersSounds.Vagary.Vagary_footstep2'
     DodgeSkillAdjust=1.000000
     HitSound(0)=Sound'2009DoomMonstersSounds.Vagary.Vagary_pain_right_arm'
     HitSound(1)=Sound'2009DoomMonstersSounds.Vagary.Vagary_pain_left_arm'
     HitSound(2)=Sound'2009DoomMonstersSounds.Vagary.Vagary_Pain_Head'
     HitSound(3)=Sound'2009DoomMonstersSounds.Vagary.Vagary_Pain'
     DeathSound(0)=Sound'2009DoomMonstersSounds.Vagary.Vagary_Death'
     DeathSound(1)=Sound'2009DoomMonstersSounds.Vagary.Vagary_Death'
     DeathSound(2)=Sound'2009DoomMonstersSounds.Vagary.Vagary_Death'
     DeathSound(3)=Sound'2009DoomMonstersSounds.Vagary.Vagary_Death'
     ChallengeSound(0)=Sound'2009DoomMonstersSounds.Vagary.Vagary_caverns_scream'
     ChallengeSound(1)=Sound'2009DoomMonstersSounds.Vagary.Vagary_chatter_combat2'
     ChallengeSound(2)=Sound'2009DoomMonstersSounds.Vagary.Vagary_chatter_combat3'
     ChallengeSound(3)=Sound'2009DoomMonstersSounds.Vagary.Vagary_wake_solo'
     FireSound=Sound'2009DoomMonstersSounds.Vagary.Vagary_range_attack'
     ScoringValue=350
     WallDodgeAnims(0)="DodgeL"
     WallDodgeAnims(1)="DodgeR"
     WallDodgeAnims(2)="DodgeL"
     WallDodgeAnims(3)="DodgeR"
     IdleHeavyAnim="Idle"
     IdleRifleAnim="Idle"
     FireHeavyRapidAnim="Walk"
     FireHeavyBurstAnim="Walk"
     FireRifleRapidAnim="Walk"
     FireRifleBurstAnim="Walk"
     RagdollOverride="D3Vagary"
     bCanJump=False
     MeleeRange=60.000000
     GroundSpeed=250.000000
     HealthMax=7500.00000 //5500.000000 kyan
     Health=7500 //5500 kyan
     PlayerCountHealthScale=1.5//0.25
     PlayerNumHeadHealthScale=0.4//0.30 // Was 0.35 in Balance Round 1
     HeadRadius=18.000000
     MenuName="Vagary"
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
     DodgeAnims(0)="DodgeL"
     DodgeAnims(1)="DodgeR"
     AirStillAnim="Walk"
     TakeoffStillAnim="Walk"
     CrouchTurnRightAnim="Walk"
     CrouchTurnLeftAnim="Walk"
     IdleCrouchAnim="Idle"
     IdleSwimAnim="Idle"
     IdleWeaponAnim="Idle"
     IdleRestAnim="Idle"
     IdleChatAnim="Idle"
     Mesh=SkeletalMesh'2009DoomMonstersAnims.VagaryMesh'
     DrawScale=1.500000
     Skins(0)=Combiner'2009DoomMonstersTex.Vagary.JVagarySkin'
     Skins(1)=Shader'2009DoomMonstersTex.Vagary.TeethShader'
     Skins(2)=Shader'2009DoomMonstersTex.Vagary.VagarySacShader'
     CollisionRadius=30.000000
     CollisionHeight=50.000000
     Mass=1000.000000
}
