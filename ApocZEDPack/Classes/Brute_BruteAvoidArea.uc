class Brute_BruteAvoidArea extends AvoidMarker;

var KFMonster KFMonst; // Should be the same as base and owner

state BigMeanAndScary
{
	Begin:
		StartleBots();
		Sleep(1.0);
		GoTo('Begin');
}

function InitFor(KFMonster V)
{
	if (V != None)
	{
		KFMonst = V;
		SetCollisionSize(KFMonst.CollisionRadius * 3, KFMonst.CollisionHeight + CollisionHeight);
		SetBase(KFMonst);
		GoToState('BigMeanAndScary');
	}
}

function Touch( actor Other )
{
	if ( (Pawn(Other) != None) && RelevantTo(Pawn(Other)) )
		KFMonsterController(Pawn(Other).Controller).AvoidThisMonster(KFMonst);
}

function bool RelevantTo(Pawn P)
{
	return ( KFMonst != none && VSizeSquared(KFMonst.Velocity) >= 75 && Super.RelevantTo(P)
			&& KFMonst.Velocity dot (P.Location - KFMonst.Location) > 0  );
}

function StartleBots()
{
	local KFMonster P;

	if (KFMonst != None)
		ForEach CollidingActors(class'KFMonster', P, CollisionRadius)
		if (RelevantTo(P))
			KFMonsterController(P.Controller).AvoidThisMonster(KFMonst);
}

DefaultProperties
{
	TeamNum=255
	bStatic=false
	bBlockZeroExtentTraces=false
	bBlockNonZeroExtentTraces=false
	bBlockHitPointTraces=false
	CollisionRadius=1000.000
	RemoteRole=ROLE_None
}
