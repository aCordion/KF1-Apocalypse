class Sentry_SentryTurretMessage extends LocalMessage;

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
     Message(0)="Can't deploy Sentry Turret here"
     Message(1)="Sentry Turret deployed"
     Message(2)="Sentry Turret destroyed"
     bIsUnique=True
     bFadeMessage=True
     Lifetime=4
     DrawColor=(B=170,G=170,R=170)
     StackMode=SM_Down
     PosY=0.800000
}
