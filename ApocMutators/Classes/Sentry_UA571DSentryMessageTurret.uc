class Sentry_UA571DSentryMessageTurret extends LocalMessage;

#exec obj load file="SentryTechTex1.utx"
#exec obj load file="SentryTechAnim1.ukx"
#exec obj load file="SentryTechStatics.usx"
#exec obj load file="SentryTechSounds.uax"



var localized string Message[3];

static function string GetString(
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject)
{

    return Default.Message[Switch];
}

defaultproperties
{
     Message(0)="Can't deploy UA-571D Sentry here"
     Message(1)="UA-571D Sentry deployed"
     Message(2)="UA-571D Sentry destroyed"
     bIsUnique=True
     bFadeMessage=True
     Lifetime=8
     DrawColor=(B=0,G=170,R=0)
     StackMode=SM_Down
     PosY=0.800000
}
