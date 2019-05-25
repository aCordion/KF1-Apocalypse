class Weapon_DualMK23Fire extends DualMK23Fire;

var float PenDmgReduction; //penetration damage reduction. 1.0 - no reduction, 0 - no penetration, 0.75 - 25% reduction
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
	if ( Weapon_DualMK23Laser(Weapon) != none && Weapon_DualMK23Laser(Weapon).bLaserActive)
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
	 DamageType=Class'ApocMutators.Weapon_DamTypeDualMK23Pistol'
}
