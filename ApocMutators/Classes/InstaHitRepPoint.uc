Class InstaHitRepPoint extends Info
	transient;

var HL2WeaponAttachment Attachment;

replication
{
	reliable if( Role==ROLE_Authority )
		Attachment;
}

simulated function PostNetBeginPlay()
{
	if( Attachment!=None && Attachment.Instigator!=None )
	{
		Attachment.mHitLocation = Location;
		Attachment.ClientCheckTrace();
		Attachment.mHitLocation = vect(0,0,0);
	}
}

defaultproperties
{
     DrawType=DT_None
     bHidden=False
     bNetTemporary=True
     NetUpdateFrequency=50.000000
     LifeSpan=0.500000
}
