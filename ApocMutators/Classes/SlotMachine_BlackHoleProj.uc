class SlotMachine_BlackHoleProj extends Projectile;

var Emitter Trail;
var float DesiredFlyHeight;
var vector RepHolePosition;

var bool bSecondPhase;

replication
{
	// Variables the server should send to the client.
	reliable if (Role == ROLE_Authority)
		bSecondPhase, RepHolePosition;
}

function PostBeginPlay()
{
	local vector HL, HN;

	if (Trace(HL, HN, Location + vect(0, 0, 1000), Location, false) == None)
		DesiredFlyHeight = 500 + Location.Z;
	else DesiredFlyHeight = Abs(HL.Z-Location.Z) * 0.5f + Location.Z;
	Velocity = vect(0, 0, 200);
}
simulated function PostNetBeginPlay()
{
	if (Level.NetMode != NM_DedicatedServer)
		SetTrailFX();
	bNetNotify = !bSecondPhase;
}
simulated final function SetTrailFX()
{
	if (Trail != None)
		Trail.Kill();
	if (bSecondPhase)
		Spawn(Class'SlotMachine_BlackHoleFX', Self);
	else Trail = Spawn(Class'SlotMachine_SuperNovaFX', Self);
}
simulated function PostNetReceive()
{
	if (bSecondPhase)
	{
		Velocity = vect(0, 0, 0);
		SetTrailFX();
		bNetNotify = false;
		if (RepHolePosition != vect(0, 0, 0))
			SetLocation(RepHolePosition);
	}
}
simulated function Destroyed()
{
	if (Trail != None)
		Trail.Kill();
}

simulated final function bool IsHittingDeath(Actor A)
{
	local vector V;

	V = A.Location-Location;
	if (Abs(V.Z) > (A.CollisionHeight + 40))
		return false;
	V.Z = 0;
	return(VSize(V) < (A.CollisionRadius + 40));
}
simulated final function ProcessGravity(float Delta)
{
	local Actor A;
	local vector D;
	local float Dist, RealFF;
	local TeamGame T;

	T = TeamGame(Level.Game);
	if (T != None)
	{
		RealFF = T.FriendlyFireScale;
		T.FriendlyFireScale = 1;
	}
	foreach VisibleCollidingActors(class'Actor', A, 3500)
	{
		if (A.Class == Class || A.bStatic || !A.bMovable || (Pawn(A) == None && Projectile(A) == None && Gib(A) == None))
			continue;
		if (A.Physics == PHYS_Walking || A.Physics == PHYS_None)
			A.SetPhysics(PHYS_Falling);
		D = Location-A.Location;
		Dist = VSize(D);

		if (A.Physics == PHYS_Karma || A.Physics == PHYS_KarmaRagDoll)
			A.KAddImpulse((Normal(D) * ((3600-Dist) / 2.f) * Delta), vect(0, 0, 0));
		else if (Dist > 500)
			A.Velocity += (Normal(D) * (3600-Dist) * Delta);
		else A.Velocity = (Normal(D) * 1500.f);

		if (A.Role == ROLE_Authority && IsHittingDeath(A))
			A.TakeDamage(200, Instigator, A.Location + VRand() * 60.f, D, class'SlotMachine_DamTypeUHHGren');
	}
	if (T != None)
		T.FriendlyFireScale = RealFF;
}

simulated function Tick(float Delta)
{
	if (!bSecondPhase)
	{
		if (Location.Z >= DesiredFlyHeight)
		{
			LifeSpan = 10;
			Velocity = vect(0, 0, 0);
			bSecondPhase = true;
			RepHolePosition = Location;
			if (Level.NetMode != NM_DedicatedServer)
				SetTrailFX();
		}
	}
	else ProcessGravity(Delta);
}

defaultproperties
{
	 DrawType=DT_None
	 bNetTemporary=False
	 bAlwaysRelevant=True
	 LifeSpan=12.000000
	 bCollideActors=False
}
