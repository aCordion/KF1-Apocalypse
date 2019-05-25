//=============================================================================
// M32MedicGun Source 
//=============================================================================
// Made By [C|AK]|[TeaM]
// 03/02/2013
//=============================================================================
class Weapon_M32MedicGrenadeLauncher extends M32GrenadeLauncher;

defaultproperties
{
     FireModeClass(0)=Class'ApocMutators.Weapon_M32MedicFire'
     Description="An advanced semi automatic medic grenade launcher. Launches Heals grenades."
     PickupClass=Class'ApocMutators.Weapon_M32MedicPickup'
     AttachmentClass=Class'ApocMutators.Weapon_M32MedicAttachment'
     ItemName="M32 Medic Grenade Launcher"
}
