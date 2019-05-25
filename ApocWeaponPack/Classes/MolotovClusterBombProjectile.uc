class MolotovClusterBombProjectile extends M79GrenadeProjectile;

var() class<Projectile> ProjectileClass;
var() int NumProjectiles;

simulated function Explode(vector HitLocation, vector HitNormal)
{
    local Controller C;
    local PlayerController  LocalPlayer;

	local vector start;
    local rotator rot;
    local int i;
    local Projectile NewChunk;
	
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
		Spawn(class'ROEffects.ROSmokeRing',self,,HitLocation + HitNormal*20,rotator(HitNormal));
    }

    BlowUp(HitLocation);
	
    start = Location + 10 * HitNormal;
    if ( Role == ROLE_Authority && !bDud)
    {   
        for (i=0; i< NumProjectiles; i++)
        {
            rot = Rotation;
            rot.yaw += FRand()*32000-16000;
            rot.pitch += FRand()*32000-16000;
            rot.roll += FRand()*32000-16000;
            NewChunk = Spawn(ProjectileClass,Instigator, '', Start, rot);
        }
    }
	
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
     ProjectileClass=class'MolotovClusterBomblet'
     NumProjectiles=3
     Speed=1250.000000
     MaxSpeed=1250.000000
}
