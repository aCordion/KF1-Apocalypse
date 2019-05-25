//=============================================================================
// SeekerSixRocketProjectile
//=============================================================================
// Rocket projectile class for the SeekerSix mini rocket launcher
//=============================================================================
// Killing Floor Source
// Copyright (C) 2013 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================
class Weapon_SeekerSixRocketProjectile extends SeekerSixRocketProjectile;

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local Controller C;
	local PlayerController  LocalPlayer;

	bHasExploded = True;

	// Don't explode if this is a dud
	if( bDud )
	{
		Velocity = vect(0,0,0);
		LifeSpan=1.0;
		SetPhysics(PHYS_Falling);
	}

	PlaySound(ExplosionSound,,2.0);
	if ( EffectIsRelevant(Location,false) )
	{
		//Spawn(class'KFMod.SeekerSixExplosionEmitter',,,HitLocation + HitNormal*20,rotator(HitNormal));
		Spawn(ExplosionDecal,self,,HitLocation, rotator(-HitNormal));
	}

	BlowUp(HitLocation);
	Destroy();

	// Shake nearby players screens
	LocalPlayer = Level.GetLocalPlayerController();
	if ( (LocalPlayer != None) && (VSize(Location - LocalPlayer.ViewTarget.Location) < DamageRadius) )
		LocalPlayer.ShakeView(RotMag, RotRate, RotTime, OffsetMag, OffsetRate, OffsetTime);

	for ( C=Level.ControllerList; C!=None; C=C.NextController )
		if ( (PlayerController(C) != None) && (C != LocalPlayer)
			&& (VSize(Location - PlayerController(C).ViewTarget.Location) < DamageRadius) )
			C.ShakeView(RotMag, RotRate, RotTime, OffsetMag, OffsetRate, OffsetTime);
}

defaultproperties
{
}
