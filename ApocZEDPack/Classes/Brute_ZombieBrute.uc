class Brute_ZombieBrute extends Brute_ZombieBruteBase
	Config(ApocZEDPack);

struct SZEDInfo {
	var config int ForcedMinPlayers;
	var config int Health;
    var config int HeadHealth;
    var config float PlayerCountHealthScale;
    var config float PlayerNumHeadHealthScale;
};
var config SZEDInfo ZEDInfo;

simulated function PostBeginPlay()
{
    if (ZEDInfo.Health>0 && Health!=ZEDInfo.Health)
    {
        Health = ZEDInfo.Health;
        HealthMax = ZEDInfo.Health;
    }

    if (ZEDInfo.HeadHealth>0 && HeadHealth!=ZEDInfo.HeadHealth)
        HeadHealth = ZEDInfo.HeadHealth;

    if (ZEDInfo.PlayerCountHealthScale>0 && PlayerCountHealthScale!=ZEDInfo.PlayerCountHealthScale)
        PlayerCountHealthScale = ZEDInfo.PlayerCountHealthScale;

    if (ZEDInfo.PlayerNumHeadHealthScale>0 && PlayerNumHeadHealthScale!=ZEDInfo.PlayerNumHeadHealthScale)
        PlayerNumHeadHealthScale = ZEDInfo.PlayerNumHeadHealthScale;
		
	Super.PostBeginPlay();
}

function float NumPlayersHealthModifer()
{
    if (ZEDInfo.ForcedMinPlayers>0)
        return 1.0 + (ZEDInfo.ForcedMinPlayers - 1) * PlayerCountHealthScale;
    return Super.NumPlayersHealthModifer();
}

function float NumPlayersHeadHealthModifer()
{
    if (ZEDInfo.ForcedMinPlayers>0)
        return 1.0 + (ZEDInfo.ForcedMinPlayers - 1) * PlayerNumHeadHealthScale;
    return Super.NumPlayersHeadHealthModifer();
}

simulated function PostNetBeginPlay()
{
	super.PostNetBeginPlay();
	EnableChannelNotify(1,1);
	EnableChannelNotify(2,1);
	AnimBlendParams(1, 1.0, 0.0,, SpineBone1);
}

function ServerRaiseBlock()
{
	bServerBlock = true;
	SetAnimAction('BlockLoop');
}

function ServerLowerBlock()
{
	local name Sequence;
	local float Frame, Rate;

	bServerBlock = false;
	GetAnimParams(1, Sequence, Frame, Rate);
	if (Sequence == 'BlockLoop')
		AnimStopLooping(1);
}

simulated function PostNetReceive()
{
	local name Sequence;
	local float Frame, Rate;

	if(bClientCharge != bChargingPlayer)
	{
		bClientCharge = bChargingPlayer;
		if (bChargingPlayer)
		{
			MovementAnims[0] = ChargingAnim;
			MeleeAnims[0] = 'BruteRageAttack';
			MeleeAnims[1] = 'BruteRageAttack';
			MeleeAnims[2] = 'BruteRageAttack';
		}
		else
		{
			MovementAnims[0] = default.MovementAnims[0];
			MeleeAnims[0] = default.MeleeAnims[0];
			MeleeAnims[1] = default.MeleeAnims[1];
			MeleeAnims[2] = default.MeleeAnims[2];
		}
	}

	if (bClientBlock != bServerBlock)
	{
		bClientBlock = bServerBlock;
		if (bClientBlock)
			SetAnimAction('BlockLoop');
		else
		{
			GetAnimParams(1, Sequence, Frame, Rate);
			if (Sequence == 'BlockLoop')
				AnimStopLooping(1);
		}
	}
}

simulated function Tick(float DeltaTime)
{
    super.Tick(DeltaTime);

	if (Role == ROLE_Authority)
	{
		// Lock to target when attacking (except on beginner!)
		if (bShotAnim && Level.Game.GameDifficulty >= 2.0)
			if (LookTarget != none)
				Acceleration = AccelRate * Normal(LookTarget.Location - Location);

		// Block according to rules
		if (Role == ROLE_Authority && !bServerBlock && !bShotAnim)
			if (Controller != none && Controller.Target != none)
				ServerRaiseBlock();
	}
}

// Override to always move when attacking
function RangedAttack(Actor A)
{
	if (bShotAnim || Physics == PHYS_Swimming)
		return;
	else if (CanAttack(A))
	{
		if (bChargingPlayer)
			SetAnimAction('AoeClaw');
		else
		{
			if (Rand(BlockHitsLanded) < 1)
				SetAnimAction('BlockClaw');
			else
				SetAnimAction('Claw');
		}

		bShotAnim = true;
		return;
	}
}

function bool IsHeadShot(vector Loc, vector Ray, float AdditionalScale)
{
	local float D;
	local float AddScale;
	local bool bIsBlocking;

	bBlockedHS = false;

	if (bServerBlock && !IsTweening(1))
	{
		bIsBlocking = true;
		AddScale = AdditionalScale + BlockAddScale;
	}
	else
		AddScale = AdditionalScale + 1.0;

	if (Super.IsHeadShot(Loc, Ray, AddScale))
	{
		if (bIsBlocking)
		{
			D = vector(Rotation) dot Ray;
			if (-D > 0.20) {
				bBlockedHS = true;
				return false;
			}
			else
				return true;
		}
		else
			return true;
	}
	else
		return false;
}

function TakeDamage(int Damage, Pawn InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamType, optional int HitIndex)
{
	local bool bIsHeadShot;

	bIsHeadShot = IsHeadShot(HitLocation, normal(Momentum), 1.0);

	if (!bIsHeadShot && bBlockedHS)
	{
		if (class<KFProjectileWeaponDamageType>(DamType) != none)
			PlaySound(class'MetalHitEmitter'.default.ImpactSounds[rand(3)],, 128);
		else if (class<DamTypeChainsaw>(DamType) != none)
			PlaySound(Sound'KF_ChainsawSnd.Chainsaw_Impact_Metal',, 128);
		else if (class<DamTypeMelee>(DamType) != none)
			PlaySound(Sound'KF_KnifeSnd.Knife_HitMetal',, 128);

		if (class<DamTypeBurned>(DamType) == none && class<DamTypeFlameThrower>(DamType) == none)
			Damage *= BlockDmgMul; // Greatly reduce damage as we only hit the metal plating
		else
			Damage *= BlockFireDmgMul; // Fire damage isn't reduced as much
	}

	// Alter damage based on type
	if (class<DamTypeMelee>(DamType) != none)
		Damage *= 0.75;
	//else if (class<DamTypeBurned>(DamType) != none || class<DamTypeFlameThrower>(DamType) != none)
		//Damage *= 0.75;

	// Record damage over 2-second frames
	if (LastDamagedTime < Level.TimeSeconds)
	{
		TwoSecondDamageTotal = 0;
		LastDamagedTime = Level.TimeSeconds + 2;
	}
	TwoSecondDamageTotal += Damage;

	// If criteria is met make him rage
	if (!bDecapitated && !bChargingPlayer && TwoSecondDamageTotal > RageDamageThreshold)
	{
		StartCharging();
		if (InstigatedBy != None)
			if (Controller.Target != InstigatedBy)
				MonsterController(Controller).ChangeEnemy(InstigatedBy, Controller.CanSee(InstigatedBy));
	}

	Super.TakeDamage(Damage, instigatedBy, hitLocation, momentum, DamType,HitIndex);

	if (bDecapitated)
		Died(InstigatedBy.Controller, DamType, HitLocation);
}

function TakeFireDamage(int Damage, Pawn Instigator)
{
	Super.TakeFireDamage(Damage, Instigator);

	// Adjust movement speed if not charging
	if (!bChargingPlayer)
	{
		if (bBurnified)
			GroundSpeed = GetOriginalGroundSpeed() * BurnGroundSpeedMul;
		else
			GroundSpeed = GetOriginalGroundSpeed();
	}
}

function ClawDamageTarget()
{
	local KFHumanPawn HumanTarget;
	local float UsedMeleeDamage;
	local Actor OldTarget;
	local name Sequence;
	local float Frame, Rate;
	local bool bHitSomeone;

	if (MeleeDamage > 1)
		UsedMeleeDamage = (MeleeDamage - (MeleeDamage * 0.05)) + (MeleeDamage * (FRand() * 0.1));
	else
		UsedMeleeDamage = MeleeDamage;

	GetAnimParams(1, Sequence, Frame, Rate);

	if (Controller != none && Controller.Target != none)
	{
		if (Sequence == 'BruteRageAttack')
		{
			OldTarget = Controller.Target;
			foreach VisibleCollidingActors(class'KFHumanPawn', HumanTarget, MeleeRange + class'KFHumanPawn'.default.CollisionRadius)
			{
				bHitSomeone = ClawDamageSingleTarget(UsedMeleeDamage, HumanTarget);
			}
			Controller.Target = OldTarget;
			if (bHitSomeone)
				BlockHitsLanded++;
		}
		else if (Sequence != 'BruteAttack1' && Sequence != 'BruteAttack2' && Sequence != 'DoorBash') // Block attack
		{
			bHitSomeone = ClawDamageSingleTarget(UsedMeleeDamage, Controller.Target);
			if (bHitSomeone)
				BlockHitsLanded++;
		}
		else
			bHitSomeone = ClawDamageSingleTarget(UsedMeleeDamage, Controller.Target);

		if (bHitSomeone)
			PlaySound(MeleeAttackHitSound, SLOT_Interact, 1.25);
	}
}

function bool ClawDamageSingleTarget(float UsedMeleeDamage, Actor ThisTarget)
{
	local Pawn HumanTarget;
	local KFPlayerController HumanTargetController;
	local bool bHitSomeone;
	local float EnemyAngle;
	local vector PushForceVar;

	EnemyAngle = Normal(ThisTarget.Location - Location) dot vector(Rotation);
	if (EnemyAngle > 0)
	{
		Controller.Target = ThisTarget;
		if (MeleeDamageTarget(UsedMeleeDamage, vect(0, 0, 0)))
		{
			HumanTarget = KFHumanPawn(ThisTarget);
			if (HumanTarget != None)
			{
				EnemyAngle = (EnemyAngle * 0.5) + 0.5; // Players at sides get knocked back half as much
				PushForceVar = (PushForce * Normal(HumanTarget.Location - Location) * EnemyAngle) + PushAdd;
				if (!bChargingPlayer)
					PushForceVar *= 0.85;

				// (!) I'm sure the VeterancyName string is localized but I'm not sure of another way compatible with ServerPerks
				if (KFPlayerReplicationInfo(HumanTarget.Controller.PlayerReplicationInfo).ClientVeteranSkill != none)
					if (KFPlayerReplicationInfo(HumanTarget.Controller.PlayerReplicationInfo).ClientVeteranSkill
						.default.VeterancyName == "Berserker")
							PushForceVar *= 0.75;

				if (!(HumanTarget.Physics == PHYS_WALKING || HumanTarget.Physics == PHYS_NONE))
					PushForceVar *= vect(1, 1, 0); // (!) Don't throw upwards if we are not on the ground - adjust for more flexibility

				HumanTarget.AddVelocity(PushForceVar);

				HumanTargetController = KFPlayerController(HumanTarget.Controller);
				if (HumanTargetController != None)
					HumanTargetController.ShakeView(ShakeViewRotMag, ShakeViewRotRate, ShakeViewRotTime,
						ShakeViewOffsetMag, ShakeViewOffsetRate, ShakeViewOffsetTime);

				bHitSomeone = true;
			}
		}
	}

	return bHitSomeone;
}

function StartCharging()
{
	// How many times should we hit before we cool down?
	if (Level.Game.NumPlayers <= 3)
		MaxRageCounter = 2;
	else
		MaxRageCounter = 3;

	RageCounter = MaxRageCounter;
	PlaySound(RageSound, SLOT_Talk, 255);
	GotoState('RageCharging');
}

state RageCharging
{
Ignores StartCharging;

    function PlayDirectionalHit(Vector HitLoc)
    {
        if (!bShotAnim)
            super.PlayDirectionalHit(HitLoc);
    }

    function bool CanGetOutOfWay()
    {
        return false;
    }

    function bool CanSpeedAdjust()
    {
        return false;
    }

	function BeginState()
	{
		bFrustrated = false;
        bChargingPlayer = true;
		RageSpeedTween = 0.0;
		if (Level.NetMode != NM_DedicatedServer)
			ClientChargingAnims();

		NetUpdateTime = Level.TimeSeconds - 1;
	}

	function EndState()
	{
        bChargingPlayer = false;

        Brute_BruteZombieController(Controller).RageFrustrationTimer = 0;

		if (Health > 0)
		{
			GroundSpeed = GetOriginalGroundSpeed();
			if (bBurnified)
				GroundSpeed *= BurnGroundSpeedMul;
		}

		if( Level.NetMode!=NM_DedicatedServer )
			ClientChargingAnims();

		NetUpdateTime = Level.TimeSeconds - 1;
	}

	function Tick(float Delta)
	{
		if (!bShotAnim)
		{
			RageSpeedTween = FClamp(RageSpeedTween + (Delta * 0.75), 0, 1.0);
			GroundSpeed = OriginalGroundSpeed + ((OriginalGroundSpeed * 0.75 / MaxRageCounter * (RageCounter + 1) * RageSpeedTween));
			if (bBurnified)
				GroundSpeed *= BurnGroundSpeedMul;
		}

        Global.Tick(Delta);
	}

	function Bump(Actor Other)
	{
        local KFMonster KFM;

        KFM = KFMonster(Other);

        // Hurt enemies that we run into while raging
        if (!bShotAnim && KFM != None && Brute_ZombieBrute(Other) == None && Pawn(Other).Health > 0)
			Other.TakeDamage(RageBumpDamage, self, Other.Location, Velocity * Other.Mass, class'DamTypePoundCrushed');
		else Global.Bump(Other);
	}

	function bool MeleeDamageTarget(int HitDamage, vector PushDir)
	{
		local bool DamDone, bWasEnemy;

		bWasEnemy = (Controller.Target == Controller.Enemy);

		DamDone = Super.MeleeDamageTarget(HitDamage * RageDamageMul, vect(0, 0, 0));

		if (bWasEnemy && DamDone)
		{
			ChangeTarget();
			CalmDown();
		}

		return DamDone;
	}

	function CalmDown()
	{
		RageCounter = FClamp(RageCounter - 1, 0, MaxRageCounter);
		if (RageCounter == 0)
			GotoState('');
	}

	function ChangeTarget()
	{
		local Controller C;
		local Pawn BestPawn;
		local float Dist, BestDist;

		for (C = Level.ControllerList; C != none; C = C.NextController)
			if (C.Pawn != none && KFHumanPawn(C.Pawn) != none)
			{
				Dist = VSize(C.Pawn.Location - Location);
				if (C.Pawn == Controller.Target)
					Dist += GroundSpeed * 4;

				if (BestPawn == none)
				{
					BestPawn = C.Pawn;
					BestDist = Dist;
				}
				else if (Dist < BestDist)
				{
					BestPawn = C.Pawn;
					BestDist = Dist;
				}
			}

		if (BestPawn != none && BestPawn != Controller.Enemy)
			MonsterController(Controller).ChangeEnemy(BestPawn, Controller.CanSee(BestPawn));
	}
}

// Override to prevent stunning
function bool FlipOver()
{
	return false;
}

// Shouldn't fight with our own
function bool SameSpeciesAs(Pawn P)
{
	return (Brute_ZombieBrute(P) != none);
}

// ------------------------------------------------------
// Animation --------------------------------------------
// ------------------------------------------------------

function PlayTakeHit(vector HitLocation, int Damage, class<DamageType> DamageType)
{
	if (Level.TimeSeconds - LastPainAnim < MinTimeBetweenPainAnims)
		return;

    // Uncomment this if we want some damage to make him drop his block
    /*if( !Controller.IsInState('WaitForAnim') && Damage >= 10 )
        PlayDirectionalHit(HitLocation);*/

	LastPainAnim = Level.TimeSeconds;

	if (Level.TimeSeconds - LastPainSound < MinTimeBetweenPainSounds)
		return;

	LastPainSound = Level.TimeSeconds;
	PlaySound(HitSound[0], SLOT_Pain,1.25,,400);
}

// Overridden to handle playing upper body only attacks when moving
simulated event SetAnimAction(name NewAction)
{
	if (NewAction=='')
		return;

	if (NewAction == 'Claw')
	{
		NewAction = MeleeAnims[rand(2)];
		CurrentDamType = ZombieDamType[0];
	}
	else if (NewAction == 'BlockClaw')
	{
		NewAction = 'BruteBlockSlam';
		CurrentDamType = ZombieDamType[0];
	}
	else if (NewAction == 'AoeClaw')
	{
		NewAction = 'BruteRageAttack';
		CurrentDamType = ZombieDamType[0];
	}
	else if (NewAction == 'DoorBash')
		CurrentDamType = ZombieDamType[Rand(3)];

	ExpectingChannel = DoAnimAction(NewAction);

	if (AnimNeedsWait(NewAction))
		bWaitForAnim = true;
	else
		bWaitForAnim = false;

	if (Level.NetMode != NM_Client)
	{
		AnimAction = NewAction;
		bResetAnimAct = True;
		ResetAnimActTime = Level.TimeSeconds+0.3;
	}
}

simulated function int DoAnimAction( name AnimName )
{
	if (AnimName=='BruteAttack1' || AnimName=='BruteAttack2' || AnimName=='ZombieFireGun' || AnimName == 'DoorBash')
	{
		if (Role == ROLE_Authority)
			ServerLowerBlock();
		AnimBlendParams(1, 1.0, 0.0,, FireRootBone);
		PlayAnim(AnimName,, 0.1, 1);
		return 1;
	}
	else if (AnimName == 'BruteRageAttack')
	{
		if (Role == ROLE_Authority)
			ServerLowerBlock();
		AnimBlendParams(1, 1.0, 0.0,, FireRootBone);
		PlayAnim(AnimName,, 0.1, 1);
		return 1;
	}
	else if (AnimName == 'BlockLoop')
	{
		AnimBlendParams(1, 1.0, 0.0,, FireRootBone);
		LoopAnim(AnimName,, 0.25, 1);
		return 1;
	}
	else if (AnimName == 'BruteBlockSlam')
	{
		AnimBlendParams(2, 1.0, 0.0,, FireRootBone);
		PlayAnim(AnimName,, 0.1, 2);
		return 2;
	}
	return Super.DoAnimAction(AnimName);
}

// The animation is full body and should set the bWaitForAnim flag
simulated function bool AnimNeedsWait(name TestAnim)
{
    if (TestAnim == 'DoorBash')
        return true;

    return false;
}

simulated function AnimEnd(int Channel)
{
	local name Sequence;
	local float Frame, Rate;

	GetAnimParams(Channel, Sequence, Frame, Rate);

	// Don't allow notification for a looping animation
	if (Sequence == 'BlockLoop')
		return;

	// Disable channel 2 when we're done with it
	if (Channel == 2 && Sequence == 'BruteBlockSlam')
	{
		AnimBlendParams(2, 0);
		bShotAnim = false;
		return;
	}

	Super.AnimEnd(Channel);
}

simulated function ClientChargingAnims()
{
	PostNetReceive();
}

function PlayHit(float Damage, Pawn InstigatedBy, vector HitLocation, class<DamageType> damageType, vector Momentum, optional int HitIdx)
{
	local Actor A;
	if (bBlockedHS)
		A = Spawn(class'Brute_BlockHitEmitter', InstigatedBy,, HitLocation, rotator(Normal(HitLocation - Location)));
	else
		Super.PlayHit(Damage, InstigatedBy, HitLocation, damageType, Momentum, HitIdx);
}

defaultproperties
{
	DetachedArmClass=Class'Brute_SeveredArmBrute'
	DetachedLegClass=Class'Brute_SeveredLegBrute'
	DetachedHeadClass=Class'Brute_SeveredHeadBrute'
	ControllerClass=Class'Brute_BruteZombieController'
}