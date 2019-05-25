Class CrowbarFire extends HL2WeaponFire;

var() array<name> FireHitAnims;

simulated function ModeDoFire()
{
	if( Instigator.IsLocallyControlled() )
		RandFireAnims[0] = GetFireAnim();
	Super.ModeDoFire();
}
simulated final function name GetFireAnim()
{
	local Vector Start,X,HitLocation,HitNormal;
	local Actor Other;

	Start = Instigator.Location + Instigator.EyePosition();
	X = Vector(Instigator.GetViewRotation());

	foreach Instigator.TraceActors(Class'Actor',Other,HitLocation,HitNormal,Start+TraceRange*X,Start)
	{
		if( Other!=Instigator && (Other==Level || Other.bBlockActors || Other.bProjTarget || Other.bWorldGeometry)
			&& KFBulletWhipAttachment(Other)==None )
		{
			if( ExtendedZCollision(Other)!=None )
				Other = Other.Owner;
				
			if( Pawn(Other)!=None && Pawn(Other).Health<=DamageMin )
				return 'HitKill';

			return FireHitAnims[Rand(FireHitAnims.Length)];
		}
	}
	if( FRand()<0.5 )
		return 'Miss1';
	return 'Miss2';
}

defaultproperties
{
     FireHitAnims(0)="Hit1"
     FireHitAnims(1)="Hit2"
     FireHitAnims(2)="Hit3"
     DamageType=Class'ApocMutators.DamTypeCrowbar'
     DamageMin=60
     DamageMax=65
     TraceRange=120.000000
     RandFireAnims(0)="Hit1"
     bUsesAmmoMag=False
     bCanHitTeamMates=True
     TransientSoundVolume=1.000000
     FireSound=Sound'HL2WeaponsS.Grenade.Throw'
     AmmoPerFire=0
     ShakeRotMag=(X=3.000000,Y=4.000000,Z=2.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeOffsetMag=(X=3.000000,Y=3.000000,Z=3.000000)
     aimerror=0.000000
}
