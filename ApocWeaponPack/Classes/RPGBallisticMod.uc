//=============================================================================
// RPGBallisticMod.
//
// FIXME.
//
// by Nolan "Dark Carnivour" Richert.
// Copyright(c) 2006 RuneStorm. All Rights Reserved.
//=============================================================================
class RPGBallisticMod extends Info
	exportstructs
	config(BallisticV21);

enum ELLHDetailMode
{
	DM_SuperLow,
	DM_Low,
	DM_High
};

var() globalconfig ELLHDetailMode	EffectsDetailMode;
var() globalconfig bool				bEjectBrass;
var() globalconfig bool				bMuzzleSmoke;
var() globalconfig bool				bBulletFlybys;
var() globalconfig bool				bUseMotionBlur;

var   RPGBallisticMod					RPGBallisticMod;

static function InitializeMod()
{
	log("Ballistic Core: Initialized Mod: FIXME");
}

static function RPGBallisticMod Get(actor a)
{
	local RPGBallisticMod BM;

	if (default.RPGBallisticMod != None)
		return default.RPGBallisticMod;
	foreach A.AllActors(class'RPGBallisticMod', BM)
		if (BM != None)
		{
			default.RPGBallisticMod = BM;
			return default.RPGBallisticMod;
		}
	return None;
}

defaultproperties
{
     EffectsDetailMode=DM_High
     bEjectBrass=True
     bMuzzleSmoke=True
     bBulletFlybys=True
     bAlwaysRelevant=True
     RemoteRole=ROLE_SimulatedProxy
}
