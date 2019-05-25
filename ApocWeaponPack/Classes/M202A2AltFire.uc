class M202A2AltFire extends M202A2Fire;

var() float BurstRate; //Time between shots (should be smaller than FireRate).
var bool bBursting;

event ModeDoFire()
{
/*	if(bBursting && KFWeapon(Weapon).MagAmmoRemaining > 0)
		KFWeapon(Weapon).MagAmmoRemaining--;*/

	//If not already firing, start a burst.
	if(!bBursting && AllowFire())
	{
		bBursting = true;
		SetTimer(BurstRate, true);
	}
	if(KFWeapon(Weapon).MagAmmoRemaining < 1)
	{
		SetTimer(0, false);
		KFWeapon(Weapon).MagAmmoRemaining = 0;
		bBursting = false;
		return;
	}
	//if (!AllowFire())
	//return;
	Super.ModeDoFire();
}

simulated function Timer()
{
	if(bBursting)
		ModeDoFire();
	else SetTimer(0,false);
}


defaultproperties
{
     FireAnimIron="Fire_Hard"
     FireAnimSimple="IronFire_Hard"
     BurstRate=0.2
}
