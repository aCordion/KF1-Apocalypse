class MolotovProj extends ApocWeaponPack.MolotovClusterBombProjectile;

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local PlayerController  LocalPlayer;

	bHasExploded = True;
	BlowUp(HitLocation);

	// Incendiary Effects..
	PlaySound(sound'KFWeaponSound.bullethitglass2',,100.5*TransientSoundVolume);

	Spawn(ProjectileClass,Instigator, '', HitLocation + HitNormal*20, Rotation);

	if ( EffectIsRelevant(Location,false) )
	{
		Spawn(class'KFMod.FlameImpact',self,,HitLocation + HitNormal*20,rotator(HitNormal));
		Spawn(Class'KFIncendiaryExplosion',,, HitLocation, rotator(vect(0,0,1)));
		Spawn(ExplosionDecal,self,,HitLocation, rotator(-HitNormal));
	}

	// Shake nearby players screens
	LocalPlayer = Level.GetLocalPlayerController();
	if ( (LocalPlayer != None) && (VSize(Location - LocalPlayer.ViewTarget.Location) < (DamageRadius * 1.5)) )
		LocalPlayer.ShakeView(RotMag, RotRate, RotTime, OffsetMag, OffsetRate, OffsetTime);
	Destroy();
}

defaultproperties
{
     ProjectileClass=class'MolotovIncindiaryProjFireField'
     Damage=125.000000
     DamageRadius=200.000000
     ExplosionDecal=Class'KFMod.FlameThrowerBurnMark'
     StaticMesh=StaticMesh'Molotov_A.Molotov_grenade'
}
