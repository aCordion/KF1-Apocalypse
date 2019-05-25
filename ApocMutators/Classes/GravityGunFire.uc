Class GravityGunFire extends HL2WeaponFire;

var() bool bOrganicMode;

function DoTrace(Vector Start, Rotator Dir)
{
	local Vector X;
	local Actor Other;
	local HL_GravityGun G;
	local GravityGunPush P;
	local GravityGunKillWatch K;

	X = vector(Dir);
	G = HL_GravityGun(Weapon);
	if( G.bHasAttached )
	{
		if( G.GrabbedActor!=None )
			KFWeaponAttachment(Weapon.ThirdPersonActor).UpdateHit(G.GrabbedActor,G.GrabbedActor.Location,X);
		G.LaunchCarry(X);
		return;
	}
	Other = HL_GravityGun(Weapon).FindGrabActor(Start,Dir,bOrganicMode);

	if( Other!=None )
	{
		KFWeaponAttachment(Weapon.ThirdPersonActor).UpdateHit(Other,Other.Location,X);
		
		if( Pawn(Other)!=None )
		{
			if( Pawn(Other).Default.Health<500 || G.bIsOrganic )
			{
				if( KFMonster(Other)!=None )
					KFMonster(Other).FlipOver();
				if( X.Z<0.5 )
				{
					X.Z = 0.5;
					X = Normal(X);
				}
				if( G.bIsOrganic )
					X*=1.6f;
				Pawn(Other).AddVelocity(Momentum*X);
				if( G.bIsOrganic )
				{
					K = Weapon.Spawn(Class'GravityGunKillWatch',,,Other.Location);
					K.AttachTo(Pawn(Other));
				}
				else Other.TakeDamage(25,Instigator,Other.Location,vect(0,0,0),Class'DamTypeGravGunKill');
			}
		}
		else
		{
			Other.Velocity = X*FMax(VSize(Other.Velocity),800.f);
			if( Other.Physics!=PHYS_Falling && Other.Physics!=PHYS_Projectile )
			{
				Other.bBounce = true;
				Other.SetPhysics(PHYS_Falling);
			}
			if( Level.NetMode!=NM_StandAlone && Other.RemoteRole==ROLE_SimulatedProxy && !Other.bUpdateSimulatedPosition )
			{
				P = Spawn(Class'GravityGunPush',,,Other.Location);
				P.GrabProj = Projectile(Other);
				if( Other.bNetTemporary )
				{
					P.GrabProjClass = Class<Projectile>(Other.Class);
					P.GrabProjInst = Other.Instigator;
				}
				P.LaunchVelocity = Other.Velocity;
			}
		}
	}
}

defaultproperties
{
     bOrganicMode=True
     Momentum=1000.000000
     RandFireAnims(0)="Fire"
     bUsesAmmoMag=False
     TransientSoundVolume=1.500000
     FireSound=Sound'HL2WeaponsS.PhysCannon.physcannon_dryfire'
     FireRate=0.600000
     AmmoPerFire=0
     ShakeRotMag=(X=3.000000,Y=4.000000,Z=2.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeOffsetMag=(X=3.000000,Y=3.000000,Z=3.000000)
     aimerror=0.000000
}
