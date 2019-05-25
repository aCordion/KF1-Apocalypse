class Doom3KF_HellKnight extends Doom3KF_DoomMonster;

var Doom3KF_HellKnightHandEffect HandFX;
var transient float NextRangedTime;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	if (FRand()<0.5f)
		Skins[0] = Combiner'JHellKnightSkinB';
}

function RangedAttack(Actor A)
{
	local byte i;

	if (bShotAnim)
		return;

	if (!bHasRoamed)
	{
		RoamAtPlayer();
		PrepareMovingAttack(A, 0.6f);
	}
	else if (IsInMeleeRange(A))
	{
		i = Rand(3);
		if (i==1)
			PrepareMovingAttack(A, 0.45);
		else PrepareStillAttack(A);
		SetAnimAction(MeleeAnims[i]);
	}
	else if (NextRangedTime<Level.TimeSeconds)
	{
		if (FRand()<0.25f)
		{
			NextRangedTime = Level.TimeSeconds+1.f+FRand()*2.f;
			return;
		}
		if (FRand()<0.5)
			SetAnimAction('HighAttack');
		else SetAnimAction('RangedAttack');
		PrepareStillAttack(A);
		NextRangedTime = Level.TimeSeconds+4.f+FRand()*3.f;
	}
}

// While enemy is not in reach but still in sight.
function bool ShouldTryRanged(Actor A)
{
	return (NextRangedTime<Level.TimeSeconds && FRand()<0.5f && VSizeSquared(A.Location-Location)<2250000.f);
}

simulated function FireProjectile()
{
	if (Level.NetMode != NM_Client)
		FireProj(GetBoneCoords('RHandBone').Origin);
	if (Level.NetMode != NM_DedicatedServer)
	{
		PlaySound(FireSound, SLOT_Interact);
		if (HandFX != None)
			HandFX.Destroy();
	}
}

simulated function RangedEffect()
{
	if (Level.NetMode != NM_DedicatedServer)
	{
		HandFX = Spawn(class'Doom3KF_HellKnightHandEffect', Self);
		AttachToBone(HandFX, 'RHandBone');
	}
}

function SetOverlayMaterial(Material mat, float time, bool bOverride)
{
}

simulated function RemoveEffects()
{
	if (HandFX != None)
		HandFX.Kill();
}

simulated function FadeSkins()
{
	Skins[0] = FadeFX;
	Skins[1] = InvisMat;
	Skins[2] = InvisMat;
	Skins[3] = InvisMat;
	MakeBurnAway();
}

simulated function BurnAway()
{
	Skins[0] = BurnFX;
	Burning = true;
	PlaySound(DeResSound, SLOT_Misc, 2, , 650.f);
}

defaultproperties
{
     DeathAnims(0)="DeathF"
     DeathAnims(1)="DeathB"
     DeathAnims(2)="DeathF"
     DeathAnims(3)="DeathB"
     SightAnim="Roar"
     HitAnimsX(0)="PainLeft"
     HitAnimsX(1)="PainHead"
     HitAnimsX(2)="PainRight"
     HitAnimsX(3)="PainChest"
     MinHitAnimDelay=4.000000
     MeleeAttackSounds(0)=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_chomp1'
     MeleeAttackSounds(1)=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_chomp2'
     MeleeAttackSounds(2)=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_chomp3'
     MeleeAttackSounds(3)=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_chomp2'
     SightSound=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_sight1_1'
     DeResSound=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_hk_burn'
     BurningMaterial=Texture'2009DoomMonstersTex.HellKnight.HellKnightSkin'
     BurnClass=Class'Doom3KF_HellknightBurnTex'
     FadeClass=Class'Doom3KF_HellknightMaterialSequence'
     RangedProjectile=Class'Doom3KF_HellKnightProjectile'
     BurnedTextureNum(1)=3
     HasHitAnims=True
     BigMonster=True
     aimerror=200
     BurnAnimTime=0.500000
     MeleeAnims(0)="Attack1"
     MeleeAnims(1)="Attack3"
     MeleeAnims(2)="Attack4"
     MeleeDamage=35
     bUseExtendedCollision=True
     ColOffset=(Z=49.000000)
     ColRadius=40.000000
     ColHeight=40.000000
     FootStep(0)=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_step1'
     FootStep(1)=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_step1'
     DodgeSkillAdjust=0.100000
     HitSound(0)=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_hk_pain_01'
     HitSound(1)=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_hk_pain_02'
     HitSound(2)=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_hk_pain_03'
     HitSound(3)=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_hk_pain_03'
     DeathSound(0)=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_die1'
     DeathSound(1)=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_die2'
     DeathSound(2)=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_die3'
     DeathSound(3)=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_die2'
     ChallengeSound(0)=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_sight1_2'
     ChallengeSound(1)=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_sight2_1'
     ChallengeSound(2)=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_sight3_1'
     ChallengeSound(3)=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_hk_chatter_03'
     FireSound=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_fb_create_02'
     ScoringValue=120
     WallDodgeAnims(0)="Walk"
     WallDodgeAnims(1)="Walk"
     WallDodgeAnims(2)="Walk"
     WallDodgeAnims(3)="Walk"
     IdleHeavyAnim="Idle"
     IdleRifleAnim="Idle"
     FireHeavyRapidAnim="Walk"
     FireHeavyBurstAnim="Walk"
     FireRifleRapidAnim="Walk"
     FireRifleBurstAnim="Walk"
     RagdollOverride="D3HellKnight"
     bCanJump=False
     GroundSpeed=120.000000
     HealthMax=2500.000000
     Health=2500
     HeadRadius=17.000000
     MenuName="Hell Knight"
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
     IdleSwimAnim="Idle"
     IdleWeaponAnim="Idle"
     IdleRestAnim="Idle"
     IdleChatAnim="Idle"
     HeadBone="Jaw"
     Mesh=SkeletalMesh'2009DoomMonstersAnims.HellKnightMesh'
     DrawScale=1.200000
     Skins(0)=Combiner'2009DoomMonstersTex.HellKnight.JHellKnightSkin'
     Skins(1)=FinalBlend'2009DoomMonstersTex.HellKnight.GobFinal'
     Skins(2)=Shader'2009DoomMonstersTex.HellKnight.DroolShader'
     Skins(3)=Texture'2009DoomMonstersTex.HellKnight.HellKnightTongue'
     CollisionRadius=23.000000
     CollisionHeight=50.000000
     Mass=2000.000000
}
