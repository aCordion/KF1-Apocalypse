//=============================================================================
// Doom3KF_SentryGun Pickup.
//=============================================================================
class Doom3KF_SentryGunPickup extends KFWeaponPickup;

#exec obj load file="2009DoomMonstersAnims.ukx"

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	TweenAnim('Folded', 0.01f);
}

defaultproperties
{
	 Weight=1.000000
	 cost=5000
	 AmmoCost=0
	 BuyClipSize=1
	 PowerValue=100
	 SpeedValue=20
	 RangeValue=50
	 Description="A heavy armed machine gun sentry bot you can purchase to aid you in the combat."
	 ItemName="Doom Sentry bot"
	 ItemShortName="Doom Sentry bot"
	 AmmoItemName="Doom Sentry bot"
	 CorrespondingPerkIndex=3
	 EquipmentCategoryID=3
	 InventoryType=Class'Doom3KF_SentryGun'
	 PickupMessage="You got a Doom3KF_Sentry bot."
	 PickupSound=Sound'KF_AA12Snd.AA12_Pickup'
	 PickupForce="AssaultRiflePickup"
	 DrawType=DT_Mesh
	 Mesh=SkeletalMesh'2009DoomMonstersAnims.SentryMesh'
	 CollisionRadius=22.000000
	 CollisionHeight=23.000000
}
