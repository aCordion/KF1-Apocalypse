// subclassing ROBallisticProjectile so we can do the ambient volume scaling
class M202A1Proj extends LAWProj;

#exec OBJ LOAD FILE=M202_SM.usx

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


//	PlaySound(ExplosionSound,,2.0);
        PlaySound(sound'KF_GrenadeSnd.FlameNade_Explode',,100.5*TransientSoundVolume);
	if ( EffectIsRelevant(Location,false) )
	{
		Spawn(Class'KFIncendiaryExplosion',,,HitLocation + HitNormal*20,rotator(HitNormal));
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
     ArmDistSquared=50000.000000
     MyDamageType=Class'DamTypeLAWFlame'
     Damage=120.0 //120.000000 //kyan
     DamageRadius=700.000000
     LightHue=25
     LightSaturation=100
     LightBrightness=450.000000
     LightRadius=20.000000
     StaticMeshRef="M202_SM.IncRocket"
}