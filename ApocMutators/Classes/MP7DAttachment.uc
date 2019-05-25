class MP7DAttachment extends DualiesAttachment;

simulated function UpdateTacBeam( float Dist );
simulated function TacBeamGone();

defaultproperties
{
     BrotherMesh=SkeletalMesh'Dualmp7.mp7_3rd'
     bRapidFire=True
     bAltRapidFire=True
     SplashEffect=Class'ROEffects.BulletSplashEmitter'
     CullDistance=5000.000000
     Mesh=SkeletalMesh'Dualmp7.mp7_3rd'
}
