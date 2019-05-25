class WTFEquipM79CFFire extends M79Fire;

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
	local KFPlayerReplicationInfo KFPRI;

	KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
	if (KFPRI != none)
	{
		if (KFPRI.ClientVeteranSkill == Class'SRVetFirebug')
			ProjectileClass=Class'ApocMutators.WTFEquipM79CFIncindiaryProj';
		else if (KFPRI.ClientVeteranSkill == Class'SRVetDemolitions')
			ProjectileClass=Class'ApocMutators.WTFEquipM79CFClusterBombProjectile';
		else
			ProjectileClass=default.ProjectileClass;
	}
	else
		ProjectileClass=default.ProjectileClass;

	return Super.SpawnProjectile(Start, Dir);
}

defaultproperties
{
	AmmoClass=Class'ApocMutators.WTFEquipM79CFAmmo'
	FireRate=3.333//0.23
}
