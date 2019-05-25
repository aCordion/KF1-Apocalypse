class Doom3KF_SentryGunAttachment extends PipeBombAttachment;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	TweenAnim('Folded', 0.01f);
}

defaultproperties
{
     Mesh=SkeletalMesh'2009DoomMonstersAnims.SentryMesh'
}
