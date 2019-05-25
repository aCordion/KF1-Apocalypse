class Doom3KF_Revenant extends Doom3KF_DoomMonster;

var Material WeaponFlashLight[3];
var transient float NextMissileTime;
var(Anims) name RangedAnims[3];
var byte MultiFiresLeft;

function RangedAttack(Actor A)
{
	if (bShotAnim)
		return;
	if (!bHasRoamed)
	{
		if (FRand()<0.5)
			SightAnim = 'Sight2';
		RoamAtPlayer();
	}
	else if (IsInMeleeRange(A))
	{
		PrepareStillAttack(A);
		SetAnimAction(MeleeAnims[Rand(3)]);
	}
	else if (NextMissileTime<Level.TimeSeconds)
	{
		if (MultiFiresLeft==0)
			MultiFiresLeft = 1+Rand(3);
		else if (--MultiFiresLeft==0)
			NextMissileTime = Level.TimeSeconds+2.5f+FRand()*2.f;
		PrepareStillAttack(A);
		SetAnimAction(RangedAnims[Rand(3)]);
	}
}

// While enemy is not in reach but still in sight.
function bool ShouldTryRanged(Actor A)
{
	return (NextMissileTime<Level.TimeSeconds && FRand()<0.4f);
}

simulated function Collapse()
{
	if (!bGibbed)
	{
		LinkMesh(SecondMesh, false);
		bWaitForAnim = false;
		PlayAnim('Collapse', , 0.1);
		LifeSpan = 3.f;
	}
}

simulated function FireProjectile()
{
	FireRightProjectile();
	FireLeftProjectile();
}

simulated function FireRightProjectile()
{
	if (Level.NetMode != NM_Client && Controller != None)
		FireProj(GetBoneCoords('r_gun').Origin);
	PlaySound(FireSound, SLOT_Interact);
}

function FireLeftProjectile()
{
	if (Level.NetMode != NM_Client && Controller != None)
		FireProj(GetBoneCoords('l_gun').Origin);
	PlaySound(FireSound, SLOT_Misc);
}

simulated function RocketFlashOnL()
{
	if (Level.NetMode != NM_DedicatedServer)
	{
		Spawn(class'Doom3KF_RevenantSmokePuffs', self, , GetBoneCoords('LMissileBone').Origin);
		Skins[3] = WeaponFlashLight[0];
		Skins[4] = WeaponFlashLight[2];
		Skins[5] = WeaponFlashLight[1];
	}
}

simulated function RocketFlashOnR()
{
	if (Level.NetMode != NM_DedicatedServer)
	{
		Spawn(class'Doom3KF_RevenantSmokePuffs', self, , GetBoneCoords('RMissileBone').Origin);
		Skins[6] = WeaponFlashLight[0];
		Skins[7] = WeaponFlashLight[2];
		Skins[8] = WeaponFlashLight[1];
	}
}

simulated function RocketFlashOffL()
{
	if (Level.NetMode != NM_DedicatedServer)
	{
		Skins[3] = InvisMat;
		Skins[4] = InvisMat;
		Skins[5] = InvisMat;
	}
}

simulated function RocketFlashOffR()
{
	if (Level.NetMode != NM_DedicatedServer)
	{
		Skins[6] = InvisMat;
		Skins[7] = InvisMat;
		Skins[8] = InvisMat;
	}
}

simulated function RocketFlashOffBoth()
{
	RocketFlashOffL();
	RocketFlashOffR();
}

simulated function RocketFlashOnBoth()
{
	RocketFlashOnL();
	RocketFlashOnR();
}

function SetOverlayMaterial(Material mat, float time, bool bOverride)
{
}

simulated function FadeSkins()
{
	Skins[1] = FadeFX;
	Skins[3] = InvisMat;
	Skins[4] = InvisMat;
	Skins[5] = InvisMat;
	Skins[6] = InvisMat;
	Skins[7] = InvisMat;
	Skins[8] = InvisMat;
	MakeBurnAway();
}

simulated function BurnAway()
{
	Skins[0] = InvisMat;
	Skins[1] = BurnFX;
	Skins[2] = InvisMat;
	Burning = true;
	PlaySound(DeResSound, SLOT_Misc, 2, , 600.f);
}

defaultproperties
{
     WeaponFlashLight(0)=Shader'2009DoomMonstersTex.Sentry.LowerWeaponFlash'
     WeaponFlashLight(1)=Shader'2009DoomMonstersTex.Revenant.NewRevenantFlash'
     WeaponFlashLight(2)=Shader'2009DoomMonstersTex.Revenant.WeaponFlash3'
     RangedAnims(0)="RangedAttackBoth"
     RangedAnims(1)="RangedAttackLeft"
     RangedAnims(2)="RangedAttackRight"
     DeathAnims(0)="DeathF"
     DeathAnims(1)="DeathB"
     DeathAnims(2)="DeathF"
     DeathAnims(3)="DeathB"
     SightAnim="Sight"
     HitAnimsX(0)="PainL"
     HitAnimsX(1)="PainL2"
     HitAnimsX(2)="PainR"
     HitAnimsX(3)="PainR2"
     MissSound(0)=Sound'2009DoomMonstersSounds.Revenant.Revenant_melee5'
     MissSound(1)=Sound'2009DoomMonstersSounds.Revenant.Revenant_melee5'
     MissSound(2)=Sound'2009DoomMonstersSounds.Revenant.Revenant_melee5'
     MissSound(3)=Sound'2009DoomMonstersSounds.Revenant.Revenant_melee5'
     MeleeAttackSounds(0)=Sound'2009DoomMonstersSounds.Revenant.Revenant_chatter_combat2'
     MeleeAttackSounds(1)=Sound'2009DoomMonstersSounds.Revenant.Revenant_chatter_combat3'
     MeleeAttackSounds(2)=Sound'2009DoomMonstersSounds.Revenant.Revenant_chatter_combat2'
     MeleeAttackSounds(3)=Sound'2009DoomMonstersSounds.Revenant.Revenant_chatter4'
     SightSound=Sound'2009DoomMonstersSounds.Revenant.Revenant_sight1_1'
     DeResSound=Sound'2009DoomMonstersSounds.Revenant.Revenant_burn'
     BurningMaterial=Shader'2009DoomMonstersTex.Revenant.RevenantShader'
     BurnClass=Class'Doom3KF_RevenantBurnTex'
     FadeClass=Class'Doom3KF_RevenantMaterialSequence'
     RangedProjectile=Class'Doom3KF_RevenantProjectile'
     BurnedTextureNum(0)=1
     HasHitAnims=True
     BigMonster=True
     SecondMesh=SkeletalMesh'2009DoomMonstersAnims.RevenantCollapse'
     aimerror=600
     BurnAnimTime=0.250000
     MeleeAnims(0)="Attack1"
     MeleeAnims(1)="Attack2"
     MeleeAnims(2)="Attack3"
     MeleeDamage=24
     FootStep(0)=Sound'2009DoomMonstersSounds.Revenant.Revenant_step1'
     FootStep(1)=Sound'2009DoomMonstersSounds.Revenant.Revenant_step4'
     DodgeSkillAdjust=1.000000
     HitSound(0)=Sound'2009DoomMonstersSounds.Revenant.Revenant_pain1_alt1'
     HitSound(1)=Sound'2009DoomMonstersSounds.Revenant.Revenant_pain3_alt1'
     HitSound(2)=Sound'2009DoomMonstersSounds.Revenant.Revenant_pain1_alt1'
     HitSound(3)=Sound'2009DoomMonstersSounds.Revenant.Revenant_pain3_alt1'
     DeathSound(0)=Sound'2009DoomMonstersSounds.Revenant.Revenant_die2_alt1'
     DeathSound(1)=Sound'2009DoomMonstersSounds.Revenant.Revenant_die2_alt1'
     DeathSound(2)=Sound'2009DoomMonstersSounds.Revenant.Revenant_die2_alt1'
     DeathSound(3)=Sound'2009DoomMonstersSounds.Revenant.Revenant_die2_alt1'
     ChallengeSound(0)=Sound'2009DoomMonstersSounds.Revenant.Revenant_sight1_2_alt1'
     ChallengeSound(1)=Sound'2009DoomMonstersSounds.Revenant.Revenant_sight2_1_alt1'
     ChallengeSound(2)=Sound'2009DoomMonstersSounds.Revenant.revenant_1'
     ChallengeSound(3)=Sound'2009DoomMonstersSounds.Revenant.revenant_2'
     FireSound=Sound'2009DoomMonstersSounds.Revenant.revenant_rocket_fire'
     ScoringValue=130
     WallDodgeAnims(0)="DodgeL2"
     WallDodgeAnims(1)="DodgeR2"
     WallDodgeAnims(2)="DodgeL2"
     WallDodgeAnims(3)="DodgeR2"
     IdleHeavyAnim="Idle"
     IdleRifleAnim="Idle"
     FireHeavyRapidAnim="Walk"
     FireHeavyBurstAnim="Walk"
     FireRifleRapidAnim="Walk"
     FireRifleBurstAnim="Walk"
     RagdollOverride="D3Revenant"
     bCanJump=False
     GroundSpeed=100.000000
     HealthMax=900.000000
     Health=900
     HeadRadius=13.000000
     MenuName="Revenant"
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
     DodgeAnims(0)="DodgeL2"
     DodgeAnims(1)="DodgeR2"
     DodgeAnims(2)="DodgeL2"
     DodgeAnims(3)="DodgeR2"
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
     Mesh=SkeletalMesh'2009DoomMonstersAnims.RevenantMesh'
     DrawScale=1.200000
     Skins(0)=Shader'2009DoomMonstersTex.Revenant.RevenantShader'
     Skins(1)=Combiner'2009DoomMonstersTex.Revenant.JRevenantSkin'
     Skins(2)=Shader'2009DoomMonstersTex.Revenant.RevenantEyesShader'
     Skins(3)=Texture'2009DoomMonstersTex.Revenant.InvisMat'
     Skins(4)=Texture'2009DoomMonstersTex.Revenant.InvisMat'
     Skins(5)=Texture'2009DoomMonstersTex.Revenant.InvisMat'
     Skins(6)=Texture'2009DoomMonstersTex.Revenant.InvisMat'
     Skins(7)=Texture'2009DoomMonstersTex.Revenant.InvisMat'
     Skins(8)=Texture'2009DoomMonstersTex.Revenant.InvisMat'
     CollisionRadius=20.000000
     CollisionHeight=50.000000
}
