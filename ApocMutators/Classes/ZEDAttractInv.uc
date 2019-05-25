Class ZEDAttractInv extends Inventory;

var float ReRouteTime;
var Pawn AttackTarget;
var bool bDesireTarget;

static final function SetTargeting( LevelInfo Map, vector Start, bool bForce, optional Pawn AttackTarget, optional vector MoveDest )
{
	local Controller C;
	local ZEDAttractInv Z;
	local Inventory I;
	
	if( AttackTarget!=None )
		MoveDest = AttackTarget.Location;
	for( C=Map.ControllerList; C!=None; C=C.nextController )
	{
		if( Monster(C.Pawn)!=None && VSizeSquared(C.Pawn.Location-Start)<2250000.f
		 && Map.FastTrace(C.Pawn.Location,Start) && MonsterController(C)!=None )
		{
			if( Monster(C.Pawn).bBoss && (AttackTarget==None || AttackTarget==C.Pawn) )
				continue;
			for( I=C.Pawn.Inventory; I!=None; I=I.Inventory )
				if( I.Class==Class'ZEDAttractInv' )
					break;
			if( I!=None && bForce )
			{
				I.Destroy();
				I = None;
			}
			if( I==None ) // Don't allow order ZED around all the time...
			{
				Z = Map.Spawn(Class'ZEDAttractInv',,,MoveDest);
				if( AttackTarget!=C.Pawn )
				{
					Z.AttackTarget = AttackTarget;
					Z.bDesireTarget = (AttackTarget!=None);
					C.MoveTarget = AttackTarget;
					C.Focus = AttackTarget;
				}
				Z.GiveTo(C.Pawn);
			}
		}
	}
}

function GiveTo( pawn Other, optional Pickup Pickup )
{
	Instigator = Other;
	LifeSpan = 5.f+FRand()*5.f;
	if ( Other.AddInventory( Self ) )
		GotoState('BossZed');
	else
		Destroy();
}

state BossZed
{
Begin:
	ReRouteTime = 0.2+FRand()*0.25;
	while( Instigator.Controller!=None )
	{
		if( bDesireTarget )
		{
			if( AttackTarget==None || AttackTarget.Health<=0 )
				Destroy();
			Instigator.Controller.Enemy = AttackTarget;
			Instigator.Controller.Target = AttackTarget;
		}
		else
		{
			Instigator.Controller.MoveTarget = Self;
			Instigator.Controller.Focus = Self;
			Instigator.Controller.FocalPoint = Location;
			Instigator.Controller.Destination = Location;
		}
		Sleep(ReRouteTime);
	}
}

defaultproperties
{
     RemoteRole=ROLE_None
     LifeSpan=4.000000
}
