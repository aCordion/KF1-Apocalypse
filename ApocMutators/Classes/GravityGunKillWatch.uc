Class GravityGunKillWatch extends Projectile
	transient;

var Pawn SpecimenTarget;

final function AttachTo( Pawn Other )
{
	SpecimenTarget = Other;
	SetLocation(Other.Location+Other.Velocity*0.2f);
	SetCollisionSize(Other.CollisionRadius,Other.CollisionHeight);
}
function Tick( float Delta )
{
	if( SpecimenTarget==None || SpecimenTarget.Health<=0 )
	{
		Destroy();
		return;
	}
	if( SpecimenTarget.Physics!=PHYS_Falling )
	{
		SpecimenTarget.TakeDamage(400,instigator,SpecimenTarget.Location,vect(0,0,0),Class'DamTypeBGravGunKill');
		Destroy();
		return;
	}
	Velocity = SpecimenTarget.Velocity;
	Move(SpecimenTarget.Location+SpecimenTarget.Velocity*Delta-Location);
}
function Touch( Actor Other )
{
	local int Dam;

	if( SpecimenTarget==None || SpecimenTarget.Health<=0 )
		return;
	if( ExtendedZCollision(Other)!=None )
		Other = Other.Owner;
	if( Monster(Other)!=None && Other!=SpecimenTarget && Pawn(Other).Health>0 )
	{
		Dam = SpecimenTarget.Health<<2; // Take a his health X 4
		if( Pawn(Other).Health>Dam )
		{
			Other.TakeDamage(Dam,instigator,SpecimenTarget.Location,SpecimenTarget.Velocity*SpecimenTarget.Mass,Class'DamTypeBGravGunKill');
			Dam = Dam<<1; // Make sure the thrown specimen dies now.
		}
		else
		{
			Dam = Pawn(Other).Health;
			Other.TakeDamage(99999,instigator,SpecimenTarget.Location,SpecimenTarget.Velocity*SpecimenTarget.Mass,Class'DamTypeBGravGunKill');
		}
		SpecimenTarget.TakeDamage((Dam>>2),instigator,SpecimenTarget.Location,vect(0,0,0),Class'DamTypeBGravGunKill');
	}
}
function HitWall(vector HitNormal, actor Wall)
{
	SpecimenTarget.TakeDamage(400,instigator,SpecimenTarget.Location,vect(0,0,0),Class'DamTypeBGravGunKill');
	Destroy();
}

defaultproperties
{
     bHidden=True
     RemoteRole=ROLE_None
     LifeSpan=8.000000
}
