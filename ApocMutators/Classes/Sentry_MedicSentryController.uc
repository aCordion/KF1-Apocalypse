//================================================================================
// Sentry_MedicSentryController.
//================================================================================
class Sentry_MedicSentryController extends AIController;

var Sentry_MedicSentry Sentry_MedicSentry;
var bool bLostContactToPL;
var float MaxDistanceToOwnerSquared;

function Restart()
{
	Enemy = none;
	Sentry_MedicSentry = Sentry_MedicSentry(Pawn);
	GotoState('WakeUp');
}

function SeeMonster(Pawn Seen)
{
	ChangeEnemy(Seen);
}

function HearNoise(float Loudness, Actor NoiseMaker)
{
	if ((NoiseMaker != None) && (NoiseMaker.Instigator != None) && FastTrace(NoiseMaker.Location, Pawn.Location))
		ChangeEnemy(NoiseMaker.Instigator);
}

function SeePlayer(Pawn Seen)
{
	ChangeEnemy(Seen);
}

function damageAttitudeTo(Pawn Other, float Damage)
{
	ChangeEnemy(Other);
}

function bool MustReturnToOwner()
{
	if (Sentry_MedicSentry == none || Sentry_MedicSentry.OwnerPawn == none)
		return false; // no owner to return to

	return !LineOfSightTo(Sentry_MedicSentry.OwnerPawn)
	|| VSizeSquared(Sentry_MedicSentry.Location - Sentry_MedicSentry.OwnerPawn.Location) >= MaxDistanceToOwnerSquared;
}

function ChangeEnemy(Pawn Other)
{
	if (KFPlayerReplicationInfo(Other.PlayerReplicationInfo) == none)
		return;

	if (Other == None)
		return;

	/*kyan: removed
	if ((Other.Health >= KFPlayerReplicationInfo(Other.PlayerReplicationInfo).default.PlayerHealth)
	|| (Other.Controller == None)
	|| (Other == Enemy))
	{
		return
	}*/

	//kyan: modified
	if ((Other.Health >= Other.HealthMax)
	|| (Other.Controller == None)
	|| (Other == Enemy))
	{
		return;
	}

	if ((Sentry_MedicSentry.OwnerPawn == None) && (KFPawn(Other) != None))
	{
		Sentry_MedicSentry.SetOwningPlayer(Other, None);
		return;
	}

	if (KFHumanPawn(Other) == None)
		return;

	/*kyan: removed
	if ((Enemy != None) && (Enemy.Health >= KFPlayerReplicationInfo(Enemy.PlayerReplicationInfo).default.PlayerHealth))
		Enemy = None;*/

	//kyan: modified
	if ((Enemy != None) && (Enemy.Health >= Enemy.HealthMax))
		Enemy = None;

	if ((Enemy != None)
	  && (LineOfSightTo(Enemy)
	  && !LineOfSightTo(Other)
	|| (VSizeSquared(Other.Location - Pawn.Location) > VSizeSquared(Enemy.Location - Pawn.Location))))
	{
		return;
	}

	Enemy = Other;
	EnemyChanged();
}

function EnemyChanged();

final function GoNextOrders()
{
	bIsPlayer = True;

	if ((Sentry_MedicSentry.OwnerPawn == None) || (Sentry_MedicSentry.OwnerPawn.Health <= 0))
	{
		Sentry_MedicSentry.OwnerPawn = None;
		Sentry_MedicSentry.PlayerReplicationInfo = None;
	}

	/*kyan: removed
	if ((Enemy != None)
	  && (Enemy.Health <= KFPlayerReplicationInfo(Enemy.PlayerReplicationInfo).default.PlayerHealth)
	  && !MustReturnToOwner())
	{
		GotoState('FightEnemy', 'Begin');
		return;
	}
	else
	{
		Enemy = None;
	}*/

	//kyan: modified
	if ((Enemy != None) && (Enemy.Health <= Enemy.HealthMax) && !MustReturnToOwner())
	{
		GotoState('FightEnemy', 'Begin');
		return;
	}
	else
	{
		Enemy = None;
	}

	GotoState('FollowOwner', 'Begin');
}

function PawnDied(Pawn P)
{
	if (Pawn == P)
		Destroy();
}

state WakeUp
{
	Ignores SeePlayer, HearNoise, SeeMonster;

Begin:
	Sentry_MedicSentry.SetAnimationNum(1);
	WaitForLanding();
	Sentry_MedicSentry.SetAnimationNum(0);
	Sleep(1.0);
	GoNextOrders();
}

state FightEnemy
{
	function EnemyChanged()
	{
		Sentry_MedicSentry.Speech(2);

		if (Sentry_MedicSentry.RepAnimationAction != 0)
			Sentry_MedicSentry.SetAnimationNum(0);

		GotoState(, 'Begin');
	}

	function BeginState()
	{
		Sentry_MedicSentry.Speech(2);
	}

	function EndState()
	{
		if (Sentry_MedicSentry.RepAnimationAction != 0)
			Sentry_MedicSentry.SetAnimationNum(0);

		Sentry_MedicSentry.Speech(3);
	}

Begin:
	/*kyan: removed
	if ((Enemy == None)
	|| (Enemy.Health >= KFPlayerReplicationInfo(Enemy.PlayerReplicationInfo).default.PlayerHealth))
	{
BadEnemy:
		Enemy = None;
		GoNextOrders();
	}*/

	//kyan: modified
	if ((Enemy == None) || (Enemy.Health >= Enemy.HealthMax))
	{
BadEnemy:
		Enemy = None;
		GoNextOrders();
	}

	if (LineOfSightTo(Enemy) && !MustReturnToOwner())
		goto('ShootEnemy');

	MoveTarget = FindPathToward(Enemy);

	if ((MoveTarget == None) || MustReturnToOwner())
		goto('BadEnemy');

	MoveToward(MoveTarget);
	goto('Begin');

ShootEnemy:
	if (MustReturnToOwner())
	{
		MoveTarget = FindPathToward(Sentry_MedicSentry.OwnerPawn);

		if (MoveTarget == None)
			goto('BadEnemy');

		MoveToward(MoveTarget);
		goto('Begin');
	}

	Focus = Enemy;
	Pawn.Acceleration = vect(0.00, 0.00, 0.00);
	FinishRotation();
	Sentry_MedicSentry.SetAnimationNum(2);

	/*kyan: removed
	While((Enemy != None)
		&& (Enemy.Health < KFPlayerReplicationInfo(Enemy.PlayerReplicationInfo).default.PlayerHealth)
		&& LineOfSightTo(Enemy)
		&& !MustReturnToOwner())
	{
		Pawn.Acceleration = vect(0.00, 0.00, 0.00);

		if (Enemy.Controller != None)
		{
			Enemy.Health += Sentry_MedicSentry.HitDamage;

			if (Enemy.Health > KFPlayerReplicationInfo(Enemy.PlayerReplicationInfo).default.PlayerHealth)
				Enemy.Health = KFPlayerReplicationInfo(Enemy.PlayerReplicationInfo).default.PlayerHealth;

			if (Sentry_MedicSentry.OwnerPawn != None)
				KFSteamStatsAndAchievements(KFPlayerReplicationInfo(Sentry_MedicSentry.OwnerPawn.PlayerReplicationInfo).SteamStatsAndAchievements)
					.AddDamageHealed(Sentry_MedicSentry.HitDamage);
		}

		Sleep(0.34999999);
	}*/

	//kyan: modifed
	if (KFPlayerReplicationInfo(Sentry_MedicSentry.OwnerPawn.PlayerReplicationInfo).ClientVeteranSkill == Class'SRVetFieldMedic')
	{
		While((Enemy != none)
			&& (Enemy.Health < Enemy.HealthMax)
			&& LineOfSightTo(Enemy)
			&& !MustReturnToOwner())
		{
			Pawn.Acceleration = vect(0.00, 0.00, 0.00);

			if (Enemy.Controller != None)
			{
				Enemy.Health += Sentry_MedicSentry.HitDamage;

				if (Enemy.Health > Enemy.HealthMax)
					Enemy.Health = Enemy.HealthMax;

				/*
				if (Sentry_MedicSentry.OwnerPawn != None && Sentry_MedicSentry.OwnerPawn != KFHumanPawn(Enemy))
					KFSteamStatsAndAchievements(KFPlayerReplicationInfo(Sentry_MedicSentry.OwnerPawn.PlayerReplicationInfo).SteamStatsAndAchievements)
						.AddDamageHealed(Sentry_MedicSentry.HitDamage);
				*/
			}

			Sleep(0.34999999);
		}
	}

	Sentry_MedicSentry.SetAnimationNum(0);
	Sleep(0.44999999);
	goto('Begin');
}

state FollowOwner
{
	function bool NotifyBump(Actor Other)
	{
		if (KFPawn(Other) != None)
		{
			Destination = (Normal(Pawn.Location - Other.Location) + VRand() * 0.34999999)  * (Other.CollisionRadius + 30.0 + FRand() * 50.0) + Pawn.Location;
			GotoState(, 'StepAside');
		}

		return False;
	}

	final function CheckShopTeleport()
	{
		local ShopVolume S;

		foreach Pawn.TouchingActors(Class'ShopVolume', S)
		{
			if (!S.bCurrentlyOpen && (S.TelList.Length > 0))
				S.TelList[Rand(S.TelList.Length)].Accept(Pawn, S);

			return;
		}
	}

Begin:
	CheckShopTeleport();
	Disable('NotifyBump');

	if (!MustReturnToOwner())
	{
		if (bLostContactToPL)
		{
			Sentry_MedicSentry.Speech(6);
			bLostContactToPL = False;
		}

Idle:
		Enable('NotifyBump');
		Focus = None;
		FocalPoint = VRand() * 20000.0 + Pawn.Location;
		FocalPoint.Z = Pawn.Location.Z;
		Pawn.Acceleration = vect(0.00, 0.00, 0.00);
		Sleep(0.41 + FRand());
	}
	else
	{
		if (actorReachable(Sentry_MedicSentry.OwnerPawn))
		{
			Enable('NotifyBump');
			MoveTo(Sentry_MedicSentry.OwnerPawn.Location + VRand()  * (Sentry_MedicSentry.OwnerPawn.CollisionRadius + 80.0));
		}
		else
		{
			if (!bLostContactToPL)
			{
				Sentry_MedicSentry.Speech(7);
				bLostContactToPL = True;
			}

			MoveTarget = FindPathToward(Sentry_MedicSentry.OwnerPawn);

			if (MoveTarget != None)
			{
				MoveToward(MoveTarget);
			}
			else
			{
				Sentry_MedicSentry.Speech(1);
				goto('Idle');
			}
		}
	}

	GoNextOrders();

StepAside:
	MoveTo(Destination);
	GoNextOrders();
}

defaultproperties
{
	MaxDistanceToOwnerSquared=62500.000000
	bHunting=True
}
