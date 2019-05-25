class WTFEquipAFS12a extends AA12AutoShotgun;

defaultproperties
{
     FireModeClass(0)=Class'ApocMutators.WTFEquipAFS12Fire'
     Description="A deadly weapon"
     PickupClass=class'ApocMutators.WTFEquipAFS12Pickup'
     AttachmentClass=class'ApocMutators.WTFEquipAFS12Attachment'
     ItemName="AFS12"
     Skins(0)=Texture'WTFTex.AFS12.AFS12'
     AmbientGlow=25

     //kyan: add
     MagCapacity=30
     mesh=SkeletalMesh'KF_Weapons2_Trip.AA12_Trip'
}
