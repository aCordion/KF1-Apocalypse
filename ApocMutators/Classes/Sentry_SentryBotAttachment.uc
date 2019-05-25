class Sentry_SentryBotAttachment extends PipeBombAttachment;

#exec obj load file="SentryTechTex1.utx"
#exec obj load file="SentryTechAnim1.ukx"


simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    TweenAnim('Folded', 0.01f);
}

defaultproperties
{
     Mesh=SkeletalMesh'SentryTechAnim1.Weapon_DoomSentry'
}
