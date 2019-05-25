class WTFEquipUM32AltFire extends M32Fire;

//only for demos
event ModeDoFire()
{
	local KFPlayerReplicationInfo KFPRI;

	KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
	if (KFPRI != none && KFPRI.ClientVeteranSkill == Class'SRVetDemolitions')
		Super.ModeDoFire();
}

defaultproperties
{
	 ProjectileClass=Class'ApocMutators.WTFEquipUM32ProximityMine'
}
