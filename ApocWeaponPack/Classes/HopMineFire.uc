class HopMineFire extends M79Fire;

function Projectile SpawnProjectile(Vector Start, Rotator Dir)
{
	local HopMineProj P;
	
	P = HopMineProj(Super.SpawnProjectile(Start,Dir));
	if( P!=None && !P.bNeedsDetonate )
		HopMineLchr(Weapon).AddMine(P);
	return P;
}

defaultproperties
{
     AmmoClass=class'HopMineAmmo'
     ProjectileClass=class'HopMineProj'
}
