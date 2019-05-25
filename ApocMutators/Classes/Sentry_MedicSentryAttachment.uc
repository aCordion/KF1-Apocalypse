//================================================================================ 
// Sentry_MedicSentryAttachment.
//================================================================================ 

class Sentry_MedicSentryAttachment extends PipeBombAttachment;


#exec obj load file="SentryTechTex1.utx"
#exec obj load file="SentryTechAnim1.ukx"


simulated function PostBeginPlay()
{
  Super.PostBeginPlay();
  TweenAnim('Folded', 0.01);
}

defaultproperties
{
     Mesh=SkeletalMesh'SentryTechAnim1.Weapon_DoomSentry'
     Skins(2)=Texture'SentryTechTex1.Weapon_MedicSentryBot.MedicSentryBot_Skin2'
}
