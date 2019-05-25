class L96AWPLLIPush extends Nade;

var() float     KnockbackSpeed;
var() float     ZForce;

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local Actor Victims;
	local KFMonster MonsterVictim;
	local vector pushVector;
	local rotator PointRot;	
	HitLocation.Z=Instigator.Location.Z;
	bHasExploded = True;
	BlowUp(HitLocation);

	PointRot = Instigator.GetViewRotation();
	foreach CollidingActors (class 'Actor', Victims, DamageRadius, HitLocation)
	{
		if	(KFMonster(Victims) != none)
		{
			MonsterVictim = KFMonster(Victims);
			if (MonsterVictim.Physics == PHYS_Walking)
				MonsterVictim.SetPhysics(PHYS_Falling);
		
			pushVector = vector(PointRot) * KnockbackSpeed;
			if (pushVector.Z < ZForce)
				pushVector.Z = ZForce;
			
			MonsterVictim.Velocity += pushVector;
			MonsterVictim.Acceleration = vect(0,0,0);
		}
	}
	Destroy();
}

defaultproperties
{
     KnockbackSpeed=130.000000
     DisintegrateSound=None
     ExplodeSounds(0)=None
     ExplodeSounds(1)=None
     ExplodeSounds(2)=None
     ExplodeTimer=0.100000
     Damage=0.000000
     DamageRadius=30.000000
     MomentumTransfer=30000.000000
     ExplosionDecal=None
     StaticMesh=None
	 ZForce=35
}