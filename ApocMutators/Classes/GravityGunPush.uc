Class GravityGunPush extends GravityGunGrab;

simulated function PostNetBeginPlay()
{
	local float Dist,BDist;
	local Projectile P;

	DesiredPos = Location;
	if( Level.NetMode!=NM_Client )
		return;

	if( GrabProj==None && GrabProjClass==None )
		return;

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
		if( GrabProj==None )
			return;
		if( VSize(GrabProj.Location-Location)>50.f )
			GrabProj.SetLocation(Location);
	}
	LaunchProjectile(LaunchVelocity);
}

simulated function Tick( float Delta );

defaultproperties
{
     bNetTemporary=True
     LifeSpan=0.400000
}
