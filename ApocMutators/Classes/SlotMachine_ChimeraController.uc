Class SlotMachine_ChimeraController extends KFMonsterController;

var vector EnemyPosition;
var Pawn RoamedEnemy;
var transient float NextRoamTime, DisappearTimer;
var bool bCheckEnemyPosition;

// Never automatically kill the chimera!
function bool CanKillMeYet()
{
	return false;
}

function BeginPlay()
{
	DisappearTimer = Level.TimeSeconds + 80.f + FRand() * 60.f;
	Super.BeginPlay();
}
final function bool ShouldRoam()
{
	if (NextRoamTime > Level.TimeSeconds || FRand() < 0.5f)
		return false;
	NextRoamTime = Level.TimeSeconds + 5 + 10.f * FRand();
	return true;
}
function bool FindNewEnemy()
{
	// This Chimera does not actively hunt.
	return false;
}

function FightEnemy(bool bCanCharge)
{
	if (KFM.bShotAnim)
	{
		GoToState('WaitForAnim');
		Return;
	}
	if (Enemy == none || Enemy.Health <= 0 || !EnemyVisible())
	{
		Enemy = None;
		WhatToDoNext(33);
		return;
	}

	// see enemy - decide whether to charge it or strafe around / stand and fire
	bCheckEnemyPosition = true;
	EnemyPosition = Enemy.Location;
	Target = Enemy;
	GoalString = "Charge";
	DoCharge();
}
function DoCharge()
{
	if (RoamedEnemy != Enemy)
	{
		RoamedEnemy = Enemy;
		if (ShouldRoam())
		{
			GoToState('RoamTarget');
			return;
		}
	}
	Super.DoCharge();
}

function bool FindRoamDest()
{
	GoToState('ZombieRestFormation'); // Force put to rest formation instead of wandering around map.
	return true;
}

function SetPeripheralVision();

state ZombieRoam
{
	function EnemyChanged(bool bNewEnemyVisible)
	{
		bEnemyAcquired = false;
		SetEnemyInfo(bNewEnemyVisible);
		GoToState('RoamTarget');
	}
}
state ZombieRestFormation
{
	function Timer()
	{
		local Controller C;

		SetTimer(0.6 + FRand() * 0.4f, true);
		for (C=Level.ControllerList; C != None; C=C.nextController)
			if (!C.bIsPlayer && C.Pawn != None && C.Pawn.Health > 0 && VSizeSquared(C.Pawn.Location-Pawn.Location) < 390000.f
			 && FastTrace(C.Pawn.Location, Pawn.Location))
				SeePlayer(C.Pawn);
	}
	function EnemyChanged(bool bNewEnemyVisible)
	{
		bEnemyAcquired = false;
		SetEnemyInfo(bNewEnemyVisible);
		GoToState('RoamTarget');
	}

Begin:
	if (DisappearTimer < Level.TimeSeconds)
	{
		Pawn.Died(None, Class'SlotMachine_DamTypeShutDown', Pawn.Location);
		Stop;
	}
	WaitForLanding();
	while(bCheckEnemyPosition)
	{
		if (PointReachable(EnemyPosition))
		{
			MoveTo(EnemyPosition, , true);
			bCheckEnemyPosition = false;
		}
		else
		{
			MoveTarget = FindPathTo(EnemyPosition);
			if (MoveTarget != None)
				MoveToward(MoveTarget, , , false, true);
			else bCheckEnemyPosition = false;
		}
	}
Camping:
	Pawn.Acceleration = vect(0, 0, 0);
	Focus = None;
	FocalPoint = KFM.Location + VRand() * 80000.f;
	FinishRotation();
	Sleep(2 + FRand() * 2.f);
Moving:
	PickDestination();
WaitForAnim:
	while(KFM.bShotAnim)
		Sleep(0.15);
	MoveTo(Destination, , true);
	WhatToDoNext(8);
	Goto('Begin');
}

State RoamTarget
{
Ignores StrafeFromDamage, EnemyNotVisible, Timer, SeePlayer, HearNoise, DamageAttitudeTo;

Begin:
	RoamedEnemy = Enemy;
	SlotMachine_UChimera(Pawn).HandleSighted();
	Focus = Enemy;
	FinishRotation();
	SlotMachine_UChimera(Pawn).PlayRoamAnim();
	while(KFM.bShotAnim)
		Sleep(0.1f);
	FightEnemy(true);
}

defaultproperties
{
	 PathFindState=2
}
