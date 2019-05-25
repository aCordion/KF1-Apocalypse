class Weapon_DualDeagleFire extends DualDeagleFire;

var float PenDmgReduction; //penetration damage reduction. 1.0 - no reduction, 25% reduction
var byte  MaxPenetrations; //how many enemies can penetrate a single bullet
var bool  bCheck4Ach;

// Remove left gun's aiming bug  (c) PooSH
// Thanks to n87, Benjamin
function DoFireEffect()
{
	super(KFFire).DoFireEffect();
}

function DoTrace(Vector Start, Rotator Dir)
{
	super(KFFire).DoTrace(Start, Dir);
}

defaultproperties
{
	 PenDmgReduction=0.650000
	 MaxPenetrations=4
	 bCheck4Ach=True
	 DamageType=Class'ApocMutators.Weapon_DamTypeDualDeagle'
}
