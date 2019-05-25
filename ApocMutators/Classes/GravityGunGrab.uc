Class GravityGunGrab extends Info
	Transient;

var Projectile GrabProj;
var class<Projectile> GrabProjClass;
var Pawn GrabProjInst,Attachment;
var vector DesiredPos,ProjStartPosition,LaunchVelocity;
var HL_GravityGun WeaponOwner;

var float ReelingInTime;
var bool bReelInProjectile,bWaitingProjectile,bDropped,bChangeInstigator;

replication
{
	reliable if( Role==ROLE_Authority )
		GrabProj,GrabProjClass,GrabProjInst,Attachment,LaunchVelocity,bDropped;
}

simulated function CheckProjType()
{
	bChangeInstigator = (PipeBombProjectile(GrabProj)==None);
}
simulated function PostNetBeginPlay()
{
	local float Dist,BDist;
	local Projectile P;

	DesiredPos = Location;
	if( Level.NetMode!=NM_Client )
		return;

	bNetNotify = true;
	if( GrabProj==None && GrabProjClass==None )
	{
		bWaitingProjectile = true; // GrabProj might not have been replicated yet.
		return;
	}
	if( GrabProj==None )
	{
		foreach CollidingActors(class'Projectile',P,500.f)
		{
			if( !ClassIsChildOf(P.Class,GrabProjClass) )
				continue;

			Dist = VSizeSquared(P.Location-Location);
			if( GrabProjInst!=None && P.Instigator!=GrabProjInst )
				Dist+=250000.f; // 500^2 - Disfavor if projectile doesn't have required instigator.
			if( GrabProj==None || BDist>Dist )
			{
				GrabProj = P;
				BDist = Dist;
			}
		}
		if( GrabProj==None ) // If none else was found, simply spawn one then.
		{
			GrabProj = Spawn(GrabProjClass,,,Location);
			if( GrabProj==None )
				return;
		}
	}
	ProjStartPosition = GrabProj.Location;
	bReelInProjectile = true;
	CheckProjType();
}
simulated function PostNetReceive()
{
	if( bWaitingProjectile && GrabProj!=None )
	{
		bWaitingProjectile = false;
		PostNetBeginPlay();
	}
	if( LaunchVelocity!=vect(0,0,0) )
		LaunchProjectile(LaunchVelocity);
	else if( bDropped )
		LaunchProjectile(vect(0,0,0));
}

simulated function LaunchProjectile( vector Vel )
{
	if( GrabProj!=None )
	{
		if( bChangeInstigator && Attachment!=None )
			GrabProj.Instigator = Attachment;
		if( Vel!=vect(0,0,0) )
			GrabProj.SetRotation(rotator(Vel));
		if( GrabProj.Physics!=PHYS_Projectile && GrabProj.Physics!=PHYS_Falling )
		{
			GrabProj.SetPhysics(PHYS_Falling);
			GrabProj.bBounce = true;
		}
		else if( GrabProj.Physics==PHYS_Projectile && Vel==vect(0,0,0) )
			Vel = vector(GrabProj.Rotation)*GrabProj.Speed;
		GrabProj.Velocity = Vel;
		if( GrabProj.RemoteRole==ROLE_SimulatedProxy && !GrabProj.bNetTemporary && GrabProj.Physics==PHYS_Falling )
			GrabProj.bUpdateSimulatedPosition = true;
		GrabProj = None;
	}
	LaunchVelocity = Vel;
	bDropped = (Vel==vect(0,0,0));

	bNetNotify = false;
	Disable('Tick');
	LifeSpan = 0.5f;
}

simulated function Tick( float Delta )
{
	if( GrabProj==None )
	{
		Destroy();
		return;
	}

	if( Attachment!=None )
		DesiredPos = Attachment.Location+Attachment.EyePosition()+vector(Attachment.Rotation)*(Attachment.CollisionRadius+20.f);

	GrabProj.Velocity = vect(0,0,0);
	if( bChangeInstigator && Attachment!=None )
		GrabProj.Instigator = Attachment;

	if( bReelInProjectile )
	{
		if( !FastTrace(DesiredPos,ProjStartPosition) )
		{
			bReelInProjectile = false;
			GrabProj.SetLocation(DesiredPos);
		}
		else
		{
			ReelingInTime+=Delta*3.f;
			if( ReelingInTime>=1.f )
				bReelInProjectile = false;
			else GrabProj.Move(ProjStartPosition+(DesiredPos-ProjStartPosition)*ReelingInTime-GrabProj.Location);
		}
	}
	else
	{
		if( Attachment!=None )
			GrabProj.SetRotation(Attachment.GetViewRotation());
		GrabProj.Move(DesiredPos-GrabProj.Location);
		
		if( WeaponOwner!=None && VSizeSquared(DesiredPos-GrabProj.Location)>10000.f )
			WeaponOwner.DropCarry();
	}
}

function Destroyed()
{
	if( WeaponOwner!=None && WeaponOwner.ProjGrabInfo==Self )
		WeaponOwner.LostCarry();
}

defaultproperties
{
     DrawType=DT_None
     bHidden=False
}
