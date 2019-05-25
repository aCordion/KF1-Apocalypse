Class Doom3KF_GuardianAI extends Doom3KF_Doom3Controller;

function FightEnemy(bool bCanCharge)
{
	if (Doom3KF_Guardian(Pawn).NeedNewSeekers())
		GoToState('RegenSeekers', 'Begin');
	else Super.FightEnemy(bCanCharge);
}

State RegenSeekers
{
Ignores DamageAttitudeTo, SeePlayer, HearNoise, SetEnemy, EnemyNotVisible;

	function EndState()
	{
		if (Pawn != None && Pawn.Health>0)
			Doom3KF_Guardian(Pawn).EndRegen();
	}
Begin:
	MoveTo(Pawn.Location+VRand()*300.f);
	Doom3KF_Guardian(Pawn).BeginRegen();
	Sleep(Doom3KF_Guardian(Pawn).SeekerRegenTime);
	Doom3KF_Guardian(Pawn).SpawnSeekers();
	Sleep(2.f);
	WhatToDoNext(25);
}

defaultproperties
{
}
