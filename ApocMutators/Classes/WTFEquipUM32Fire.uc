class WTFEquipUM32Fire extends M32Fire;

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
	local KFPlayerReplicationInfo KFPRI;

	KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
	if (KFPRI != none)
	{
		if (KFPRI.ClientVeteranSkill == Class'SRVetDemolitions')
			ProjectileClass=Class'ApocMutators.WTFEquipUM32Proj';
	}
	else
		ProjectileClass=Class'KFMod.M32GrenadeProjectile';

	return Super.SpawnProjectile(Start, Dir);
}

defaultproperties
{
	 //FireRate=2.333
	 AmmoClass=Class'ApocMutators.WTFEquipUM32Ammo'
}
