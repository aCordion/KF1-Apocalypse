//=============================================================================
// M79MedicGun Source
//=============================================================================
// Made By [C|AK]|[TeaM]
// 03/02/2013
//=============================================================================
class Weapon_M79MedicGrenadeLauncher extends M79GrenadeLauncher;

defaultproperties
{
     InventoryGroup=4
     FireModeClass(0)=Class'ApocMutators.Weapon_M79MedicFire'
     Description="An advanced semi automatic medic grenade launcher. Launches Heals grenades."
     PickupClass=Class'ApocMutators.Weapon_M79MedicPickup'
     AttachmentClass=Class'ApocMutators.Weapon_M79MedicAttachment'
     ItemName="M79 Medic Grenade Launcher"
}
