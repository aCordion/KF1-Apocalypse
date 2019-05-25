Class Doom3KF_Doom3Controller extends KFMonsterController;

var transient float ValidKillTime, TeleportingTime;
var vector TeleDest;
var bool bInitKill, bCanTele;
var byte NoneSightCount;
var Actor RandStakeMoveGoal;

function BeginPlay()
{
	TeleportingTime = Level.TimeSeconds+FRand()*10.f+30.f;
	Super.BeginPlay();
}

// Get rid of this Zed if he's stuck somewhere and noone has seen him
function bool CanKillMeYet()
{
	local Controller C;

	if (!bInitKill)
	{
		bInitKill = true;
		ValidKillTime = Level.TimeSeconds+60.f;
		TeleportingTime = Level.TimeSeconds+FRand()*10.f;
		return false;
	}
	else if (ValidKillTime>Level.TimeSeconds)
		return false;

	for (C=Level.ControllerList; C != None; C=C.nextController)
	{
		if (C.bIsPlayer && C.PlayerReplicationInfo != None && C.Pawn != None && C.Pawn.Health>0 && C.LineOfSightTo(Pawn))
		{
			if (NoneSightCount >= 5)
			{
				KFM.OriginalGroundSpeed = KFM.Default.GroundSpeed;
				KFM.GroundSpeed = KFM.Default.GroundSpeed;
			}
			NoneSightCount = 0;
			return false;
		}
	}
	if (NoneSightCount >= 5) // Walk faster to find players.
	{
		KFM.OriginalGroundSpeed = FMax(KFM.GroundSpeed, 300.f);
		KFM.GroundSpeed = KFM.OriginalGroundSpeed;
	}
	return (++NoneSightCount>45);
}

function bool FireWeaponAt(Actor A) // Don't fire until finished turning toward enemy.
{
	local int YawDif;

	if (A == None)
		A = Enemy;
	if ((A == None) || (Focus != A))
		return false;
	YawDif = (Pawn.Rotation.Yaw-rotator(A.Location-Pawn.Location).Yaw) & 65535;
	if (YawDif>4000 && YawDif<61536)
		return false;
	Target = A;
	Monster(Pawn).RangedAttack(Target);
	return false;
}

function bool FindFreshBody()
{
	return false; // Never feed on player corpses.
}
function DoTacticalMove()
{
	if (Enemy != None && LineOfSightTo(Enemy) && Doom3KF_DoomMonster(Pawn).ShouldTryRanged(Enemy))
		GoToState('ZombieHunt', 'DoRangeNow');
	else GotoState('TacticalMove');
}
function rotator AdjustAim(FireProperties FiredAmmunition, vector projStart, int aimerror)
{
	local rotator FireRotation, TargetLook;
	local float FireDist, TargetDist, ProjSpeed;
	local actor HitActor;
	local vector FireSpot, FireDir, TargetVel, HitLocation, HitNormal;
	local int realYaw;
	local bool bDefendMelee, bClean, bLeadTargetNow;

	if (Doom3KF_DoomMonster(Pawn).RangedProjectile != None)
		projspeed = Doom3KF_DoomMonster(Pawn).RangedProjectile.Default.Speed;
	else projspeed = 2000.f;

	// make sure bot has a valid target
	if (Target == None)
	{
		Target = Enemy;
		if (Target == None)
			return Rotation;
	}
	FireSpot = Target.Location;
	TargetDist = VSize(Target.Location - Pawn.Location);

	// perfect aim at stationary objects
	if (Pawn(Target) == None)
	{
		if (!FiredAmmunition.bTossed)
			return rotator(Target.Location - projstart);
		else
		{
			FireDir = AdjustToss(projspeed, ProjStart, Target.Location, true);
			SetRotation(Rotator(FireDir));
			return Rotation;
		}
	}

	bLeadTargetNow = FiredAmmunition.bLeadTarget && bLeadTarget;
	bDefendMelee = ((Target == Enemy) && DefendMelee(TargetDist));
	aimerror = AdjustAimError(aimerror, TargetDist, bDefendMelee, FiredAmmunition.bInstantHit, bLeadTargetNow);

	// lead target with non instant hit projectiles
	if (bLeadTargetNow)
	{
		TargetVel = Target.Velocity;
		// hack guess at projecting falling velocity of target
		if (Target.Physics == PHYS_Falling)
		{
			if (Target.PhysicsVolume.Gravity.Z <= Target.PhysicsVolume.Default.Gravity.Z)
				TargetVel.Z = FMin(TargetVel.Z + FMax(-400, Target.PhysicsVolume.Gravity.Z * FMin(1, TargetDist/projSpeed)), 0);
			else
				TargetVel.Z = FMin(0, TargetVel.Z);
		}
		// more or less lead target (with some random variation)
		FireSpot += FMin(1, 0.7 + 0.6 * FRand()) * TargetVel * TargetDist/projSpeed;
		FireSpot.Z = FMin(Target.Location.Z, FireSpot.Z);

		if ((Target.Physics != PHYS_Falling) && (FRand() < 0.55) && (VSize(FireSpot - ProjStart) > 1000))
		{
			// don't always lead far away targets, especially if they are moving sideways with respect to the bot
			TargetLook = Target.Rotation;
			if (Target.Physics == PHYS_Walking)
				TargetLook.Pitch = 0;
			bClean = (((Vector(TargetLook) Dot Normal(Target.Velocity)) >= 0.71) && FastTrace(FireSpot, ProjStart));
		}
		else // make sure that bot isn't leading into a wall
			bClean = FastTrace(FireSpot, ProjStart);
		if (!bClean)
		{
			// reduce amount of leading
			if (FRand() < 0.3)
				FireSpot = Target.Location;
			else
				FireSpot = 0.5 * (FireSpot + Target.Location);
		}
	}

	bClean = false; //so will fail first check unless shooting at feet
	if (FiredAmmunition.bTrySplash && (Pawn(Target) != None) && ((Skill >= 4) || bDefendMelee)
		&& (((Target.Physics == PHYS_Falling) && (Pawn.Location.Z + 80 >= Target.Location.Z))
			|| ((Pawn.Location.Z + 19 >= Target.Location.Z) && (bDefendMelee || (skill > 6.5 * FRand() - 0.5)))))
	{
	 	HitActor = Trace(HitLocation, HitNormal, FireSpot - vect(0, 0, 1) * (Target.CollisionHeight + 6), FireSpot, false);
 		bClean = (HitActor == None);
		if (!bClean)
		{
			FireSpot = HitLocation + vect(0, 0, 3);
			bClean = FastTrace(FireSpot, ProjStart);
		}
		else
			bClean = ((Target.Physics == PHYS_Falling) && FastTrace(FireSpot, ProjStart));
	}

	if (!bClean)
	{
		//try middle
		FireSpot.Z = Target.Location.Z;
 		bClean = FastTrace(FireSpot, ProjStart);
	}
	if (FiredAmmunition.bTossed && !bClean && bEnemyInfoValid)
	{
		FireSpot = LastSeenPos;
	 	HitActor = Trace(HitLocation, HitNormal, FireSpot, ProjStart, false);
		if (HitActor != None)
		{
			bCanFire = false;
			FireSpot += 2 * Target.CollisionHeight * HitNormal;
		}
		bClean = true;
	}

	if (!bClean)
	{
		// try head
 		FireSpot.Z = Target.Location.Z + 0.9 * Target.CollisionHeight;
 		bClean = FastTrace(FireSpot, ProjStart);
	}
	if (!bClean && (Target == Enemy) && bEnemyInfoValid)
	{
		FireSpot = LastSeenPos;
		if (Pawn.Location.Z >= LastSeenPos.Z)
			FireSpot.Z -= 0.4 * Enemy.CollisionHeight;
	 	HitActor = Trace(HitLocation, HitNormal, FireSpot, ProjStart, false);
		if (HitActor != None)
		{
			FireSpot = LastSeenPos + 2 * Enemy.CollisionHeight * HitNormal;
			if (Monster(Pawn).SplashDamage() && (Skill >= 4))
			{
			 	HitActor = Trace(HitLocation, HitNormal, FireSpot, ProjStart, false);
				if (HitActor != None)
					FireSpot += 2 * Enemy.CollisionHeight * HitNormal;
			}
			bCanFire = false;
		}
	}

	// adjust for toss distance
	if (FiredAmmunition.bTossed)
		FireDir = AdjustToss(projspeed, ProjStart, FireSpot, true);
	else
		FireDir = FireSpot - ProjStart;

	FireRotation = Rotator(FireDir);
	realYaw = FireRotation.Yaw;
	InstantWarnTarget(Target, FiredAmmunition, vector(FireRotation));

	FireRotation.Yaw = SetFireYaw(FireRotation.Yaw + aimerror);
	FireDir = vector(FireRotation);
	// avoid shooting into wall
	FireDist = FMin(VSize(FireSpot-ProjStart), 400);
	FireSpot = ProjStart + FireDist * FireDir;
	HitActor = Trace(HitLocation, HitNormal, FireSpot, ProjStart, false);
	if (HitActor != None)
	{
		if (HitNormal.Z < 0.7)
		{
			FireRotation.Yaw = SetFireYaw(realYaw - aimerror);
			FireDir = vector(FireRotation);
			FireSpot = ProjStart + FireDist * FireDir;
			HitActor = Trace(HitLocation, HitNormal, FireSpot, ProjStart, false);
		}
		if (HitActor != None)
		{
			FireSpot += HitNormal * 2 * Target.CollisionHeight;
			if (Skill >= 4)
			{
				HitActor = Trace(HitLocation, HitNormal, FireSpot, ProjStart, false);
				if (HitActor != None)
					FireSpot += Target.CollisionHeight * HitNormal;
			}
			FireDir = Normal(FireSpot - ProjStart);
			FireRotation = rotator(FireDir);
		}
	}

	SetRotation(FireRotation);
	return FireRotation;
}

state ZombieHunt
{
	function BeginState();
	function EndState();

	function PickDestination()
	{
		local vector nextSpot, ViewSpot, Dir;
		local float posZ;
		local bool bCanSeeLastSeen;

		if (FindFreshBody())
			Return;
		if ((Enemy != None) && !KFM.bCannibal && (Enemy.Health <= 0))
		{
			Enemy = None;
			WhatToDoNext(23);
			return;
		}
		if (PathFindState==0)
		{
			InitialPathGoal = FindRandomDest();
			PathFindState = 1;
		}
		if (PathFindState==1)
		{
			if (InitialPathGoal==None)
				PathFindState = 2;
			else if (ActorReachable(InitialPathGoal))
			{
				MoveTarget = InitialPathGoal;
				PathFindState = 2;
				Return;
			}
			else if (FindBestPathToward(InitialPathGoal, true, true))
				Return;
			else PathFindState = 2;
		}

		if (Pawn.JumpZ > 0)
			Pawn.bCanJump = true;

		if (KFM.Intelligence==BRAINS_Retarded && FRand()<0.25)
		{
			Destination = Pawn.Location+VRand()*200;
			Return;
		}
		if (ActorReachable(Enemy))
		{
			LastSeenTime = Level.TimeSeconds;
			Destination = Enemy.Location;
			if (KFM.Intelligence==BRAINS_Retarded && FRand()<0.5)
			{
				Destination+=VRand()*50;
				Return;
			}
			MoveTarget = None;
			return;
		}

		if (LineOfSightTo(Enemy) && Doom3KF_DoomMonster(Pawn).ShouldTryRanged(Enemy))
		{
			LastSeenTime = Level.TimeSeconds;
			GoToState(, 'DoRangeNow');
			return;
		}

		ViewSpot = Pawn.Location + Pawn.BaseEyeHeight * vect(0, 0, 1);
		bCanSeeLastSeen = bEnemyInfoValid && FastTrace(LastSeenPos, ViewSpot);

		if (FindBestPathToward(Enemy, true, true))
		{
			LastSeenTime = Level.TimeSeconds;
			return;
		}

		if (bSoaking && (Physics != PHYS_Falling))
			SoakStop("COULDN'T FIND PATH TO ENEMY "$Enemy);

		MoveTarget = None;
		if (!bEnemyInfoValid)
		{
			Enemy = None;
			GotoState('StakeOut');
			return;
		}

		Destination = LastSeeingPos;
		bEnemyInfoValid = false;
		if (FastTrace(Enemy.Location, ViewSpot) && VSize(Pawn.Location - Destination) > Pawn.CollisionRadius)
            {
			SeePlayer(Enemy);
			return;
            }

		posZ = LastSeenPos.Z + Pawn.CollisionHeight - Enemy.CollisionHeight;
		nextSpot = LastSeenPos - Normal(Enemy.Velocity) * Pawn.CollisionRadius;
		nextSpot.Z = posZ;
		if (FastTrace(nextSpot, ViewSpot))
			Destination = nextSpot;
		else if (bCanSeeLastSeen)
		{
			Dir = Pawn.Location - LastSeenPos;
			Dir.Z = 0;
			if (VSize(Dir) < Pawn.CollisionRadius)
			{
				Destination = Pawn.Location+VRand()*500;
				return;
			}
			Destination = LastSeenPos;
		}
		else
		{
			Destination = LastSeenPos;
			if (!FastTrace(LastSeenPos, ViewSpot))
			{
				// check if could adjust and see it
				if (PickWallAdjust(Normal(LastSeenPos - ViewSpot)) || FindViewSpot())
				{
					if (Pawn.Physics == PHYS_Falling)
						SetFall();
					else GotoState(, 'AdjustFromWall');
				}
				else
				{
					Destination = Pawn.Location+VRand()*500;
					return;
				}
			}
		}
	}

DoRangeNow:
	Focus = Enemy;
	Pawn.Acceleration = vect(0, 0, 0);
	FinishRotation();
	KFM.RangedAttack(Enemy);
	while(KFM.bShotAnim)
		Sleep(0.2f);
	PickDestination();
	WhatToDoNext(22);
	Stop;
}
state TacticalMove
{
	function BeginState()
	{
		bForcedDirection = false;
		MinHitWall += 0.15;
		Pawn.bAvoidLedges = true;
		Pawn.bStopAtLedges = true;
		Pawn.bCanJump = false;
		bAdjustFromWalls = false;
	}
TacticalTick:
	Sleep(0.02);
Begin:
	if (Pawn.Physics == PHYS_Falling)
	{
		Focus = Enemy;
		Destination = Enemy.Location;
		WaitForLanding();
	}
	PickDestination();

DoMove:
	if (!Pawn.bCanStrafe)
	{
		if (!KFM.bShotAnim && Enemy != None && Doom3KF_DoomMonster(Pawn).ShouldTryRanged(Enemy) && LineOfSightTo(Enemy))
		{
			LastSeenTime = Level.TimeSeconds;
			Pawn.Acceleration = vect(0, 0, 0);
			Focus = Enemy;
			FinishRotation();
			KFM.RangedAttack(Enemy);
		}
		StopFiring();
WaitForAnim:
		while(KFM.bShotAnim)
			Sleep(0.25);
		MoveTo(Destination);
	}
	else
	{
DoStrafeMove:
		MoveTo(Destination, Enemy);
	}
	if (bForcedDirection && (Level.TimeSeconds - StartTacticalTime < 0.2))
	{
		if (Skill > 2 + 3 * FRand())
		{
			bMustCharge = true;
			WhatToDoNext(51);
		}
		GoalString = "RangedAttack from failed tactical";
		DoRangedAttackOn(Enemy);
	}
	if ((Enemy == None) || EnemyVisible() || !FastTrace(Enemy.Location, LastSeeingPos) || Monster(Pawn).PreferMelee() || !Pawn.bCanStrafe)
		Goto('FinishedStrafe');
	//CheckIfShouldCrouch(LastSeeingPos, Enemy.Location, 0.5);

RecoverEnemy:
	GoalString = "Recover Enemy";
	HidingSpot = Pawn.Location;
	StopFiring();
	Sleep(0.1 + 0.2 * FRand());
	Destination = LastSeeingPos + 4 * Pawn.CollisionRadius * Normal(LastSeeingPos - Pawn.Location);
	MoveTo(Destination, Enemy);

	if (FireWeaponAt(Enemy))
	{
		Pawn.Acceleration = vect(0, 0, 0);
		if (Monster(Pawn).SplashDamage())
		{
			StopFiring();
			Sleep(0.05);
		}
		else
			Sleep(0.1 + 0.3 * FRand() + 0.06 * (7 - FMin(7, Skill)));
		if (FRand() > 0.5)
		{
			Enable('EnemyNotVisible');
			Destination = HidingSpot + 4 * Pawn.CollisionRadius * Normal(HidingSpot - Pawn.Location);
			Goto('DoMove');
		}
	}
FinishedStrafe:
	WhatToDoNext(21);
	if (bSoaking)
		SoakStop("STUCK IN TACTICAL MOVE!");
}

// Wander around more, if fail for long enough, teleport.
state StakeOut
{
	final function bool FindTeleportDest()
	{
		local NavigationPoint N;
		local array<NavigationPoint> Candinates;
		local int i, j;
		local vector OldSpot;

		for (N=Level.NavigationPointList; N != None; N=N.NextNavigationPoint)
		{
			if (FRand()<0.5)
				Candinates[Candinates.Length] = N;
		}
		if (Candinates.Length==0)
			return false;
		OldSpot = Pawn.Location;
		for (i=0; i<20; i++) // Give it 20 tries
		{
			j = Rand(Candinates.Length);
			N = Candinates[j];

			// Try twice..
			if (Pawn.SetLocation(N.Location) || Pawn.SetLocation(N.Location+vect(0, 0, 1)*(Pawn.CollisionHeight-N.CollisionHeight)))
			{
				TeleDest = Pawn.Location;
				Pawn.SetLocation(OldSpot);
				return true;
			}

			// Remove candinate entry, and try random next...
			Candinates.Remove(j, 1);
			if (Candinates.Length==0)
				break;
		}
		return false;
	}
	final function float GetSleepTime()
	{
		local class<Doom3KF_DemonSpawnBase> D;

		D = Doom3KF_DoomMonster(Pawn).DoomTeleportFXClass;
		if (D==None)
			return 1.f;
		Spawn(Class'Doom3KF_DemonSpawnB', , , Pawn.Location, rot(0, 0, 0));
		Spawn(D, , , TeleDest, rot(0, 0, 0));
		return D.Default.TeleportInTime;
	}
	final function bool PickRandDest()
	{
		if (RandStakeMoveGoal==None)
		{
			RandStakeMoveGoal = FindRandomDest();
			if (RandStakeMoveGoal==None)
				return false;
		}
		if (ActorReachable(RandStakeMoveGoal))
		{
			MoveTarget = RandStakeMoveGoal;
			RandStakeMoveGoal = None;
		}
		else if (!FindBestPathToward(RandStakeMoveGoal, true, true))
		{
			RandStakeMoveGoal = None;
			return false;
		}
		return true;
	}

Begin:
	Pawn.Acceleration = vect(0, 0, 0);
	Focus = None;
	FinishRotation();
	if (Enemy != None && KFM.HasRangedAttack() && (FRand() < 0.5) && (VSize(Enemy.Location - FocalPoint) < 150)
		 && (Level.TimeSeconds - LastSeenTime < 4) && ClearShot(FocalPoint, true))
		FireWeaponAt(Enemy);
	else StopFiring();
	Sleep(0.4 + FRand()*0.4);
	if (bCanTele && (bInitKill || (Level.TimeSeconds-LastSeenTime)>30.f) && Level.TimeSeconds>TeleportingTime && FindTeleportDest())
	{
		TeleportingTime = Level.TimeSeconds+FRand()*10.f+5.f;
		Sleep(GetSleepTime());
		Pawn.SetLocation(TeleDest);
		Doom3KF_DoomMonster(Pawn).NotifyTeleport();
		while(KFM.bShotAnim)
			Sleep(0.25f);
	}
	else if (FRand()<0.5f && PickRandDest())
		MoveToward(MoveTarget);
	else MoveTo(Pawn.Location+VRand()*(Pawn.CollisionRadius+300.f));
	WhatToDoNext(31);
	if (bSoaking)
		SoakStop("STUCK IN STAKEOUT!");
}

state ZombieCharge
{
	function HearNoise(float Loudness, Actor NoiseMaker)
	{
		if (KFM.Intelligence==BRAINS_Human && NoiseMaker != None && NoiseMaker.Instigator != None && FastTrace(NoiseMaker.Location, Pawn.Location))
			SetEnemy(NoiseMaker.Instigator);
	}
Begin:
	LastSeenTime = Level.TimeSeconds;
	if (Pawn.Physics == PHYS_Falling)
	{
		Focus = Enemy;
		Destination = Enemy.Location;
		WaitForLanding();
	}
	if (Enemy == None)
		WhatToDoNext(16);
WaitForAnim:
	While(KFM.bShotAnim)
		Sleep(0.35);
	if (!Doom3KF_DoomMonster(Pawn).ShouldChargeAtPlayer())
	{
		Focus = Enemy;
		Target = Enemy;
		Pawn.Acceleration = vect(0, 0, 0);
		Sleep(0.5f);
		WhatToDoNext(17);
	}
	if (!FindBestPathToward(Enemy, false, true))
		GotoState('TacticalMove');
Moving:
	if (KFM.Intelligence==BRAINS_Retarded)
	{
		if (FRand()<0.3)
			MoveTo(Pawn.Location+VRand()*200, None);
		else if (MoveTarget==Enemy && FRand()<0.5)
			MoveTo(MoveTarget.Location+VRand()*50, None);
		else MoveToward(MoveTarget, FaceActor(1), , ShouldStrafeTo(MoveTarget));
	}
	else MoveToward(MoveTarget, FaceActor(1), , ShouldStrafeTo(MoveTarget));
	WhatToDoNext(17);
	if (bSoaking)
		SoakStop("STUCK IN CHARGING!");
}

defaultproperties
{
}
