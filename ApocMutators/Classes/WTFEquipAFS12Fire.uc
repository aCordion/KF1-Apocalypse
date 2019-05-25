class WTFEquipAFS12Fire extends AA12Fire;

//from kfshotgunfire
function DoFireEffect()
{
	local Vector StartProj, StartTrace, X, Y, Z;
	local Rotator R, Aim;
	local Vector HitLocation, HitNormal;
	local Actor Other;
	local int p;
	local int SpawnCount;
	local float theta;
	local KFPlayerReplicationInfo KFPRI;

	Instigator.MakeNoise(1.0);
	Weapon.GetViewAxes(X, Y, Z);

	StartTrace = Instigator.Location + Instigator.EyePosition(); // + X * Instigator.CollisionRadius;
	StartProj = StartTrace + X * ProjSpawnOffset.X;
	if (!Weapon.WeaponCentered() && !KFWeap.bAimingRifle)
		StartProj = StartProj + Weapon.Hand * Y * ProjSpawnOffset.Y + Z * ProjSpawnOffset.Z;

	// check if projectile would spawn through a wall and adjust start location accordingly
	Other = Weapon.Trace(HitLocation, HitNormal, StartProj, StartTrace, false);

// Collision attachment debugging
 /*   if (Other.IsA('ROCollisionAttachment'))
	{
		log(self $ "'s trace hit " $ Other.Base $ " Collision attachment");
	}*/

	if (Other != None)
	{
		StartProj = HitLocation;
	}

	Aim = AdjustAim(StartProj, AimError);

	ProjectileClass=default.ProjectileClass;
	ProjPerFire=default.ProjPerFire;
	KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
	if (KFPRI != none)
	{
		if (KFPRI.ClientVeteranSkill == Class'SRVetDemolitions')
		{
			ProjPerFire=1;
			ProjectileClass=Class'ApocMutators.WTFEquipAFS12ExplosiveRound';
			if (KFWeap.bAimingRifle)
			{
				Spread *= 0.35; // bigger bonus for aiming
			}
			else
			{
				Spread *= 0.6;
			}
		}
	}

	SpawnCount = Max(1, ProjPerFire * int(Load));

	switch(SpreadStyle)
	{
	case SS_Random:
		X = Vector(Aim);
		for (p = 0; p < SpawnCount; p++)
		{
			R.Yaw = Spread  * (FRand()-0.5);
			R.Pitch = Spread  * (FRand()-0.5);
			R.Roll = Spread  * (FRand()-0.5);
			SpawnProjectile(StartProj, Rotator(X >> R));
		}
		break;
	case SS_Line:
		for (p = 0; p < SpawnCount; p++)
		{
			theta = Spread * PI / 32768 * (p - float(SpawnCount-1) / 2.0);
			X.X = Cos(theta);
			X.Y = Sin(theta);
			X.Z = 0.0;
			SpawnProjectile(StartProj, Rotator(X >> Aim));
		}
		break;
	default:
		SpawnProjectile(StartProj, Aim);
	}

	if (Instigator != none && Instigator.Physics != PHYS_Falling)
		Instigator.AddVelocity(KickMomentum >> Instigator.GetViewRotation());
}

defaultproperties
{
	ProjectileClass=Class'ApocMutators.WTFEquipAFS12ForceBullet'
	AmmoClass=Class'ApocMutators.WTFEquipAFS12Ammo'
}