class Weapon_Dual44MagnumFire extends Dual44MagnumFire;

var float PenDmgReduction; //penetration damage reduction. 1.0 - no reduction, 25% reduction
var byte  MaxPenetrations; //how many enemies can penetrate a single bullet

function DoTrace(Vector Start, Rotator Dir)
{
	super(KFFire).DoTrace(Start, Dir);
}

simulated function float GetSpread()
{
	local float AccuracyMod;

	AccuracyMod = 1.0;

	// Spread bonus while using laser sights
	if ( Weapon_Dual44MagnumLaser(Weapon) != none && Weapon_Dual44MagnumLaser(Weapon).bLaserActive)
		AccuracyMod = 0.5;

	return AccuracyMod * super.GetSpread();
}

// Remove left gun's aiming bug  (c) PooSH
// Thanks to n87, Benjamin
function DoFireEffect()
{
	super(KFFire).DoFireEffect();
}

defaultproperties
{
	 PenDmgReduction=0.500000
	 MaxPenetrations=4
	 DamageType=Class'ApocMutators.Weapon_DamTypeDual44Magnum'
	 DamageMax=90
	 AmmoClass=Class'ApocMutators.Weapon_Dual44MagnumAmmo'
}
