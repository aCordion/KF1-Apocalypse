class WTFEquipBanHammer extends Axe;

#exec obj load file=WTFTex2.utx

var bool bIsBlown;

replication
{
    reliable if (Role == ROLE_Authority)
        bIsBlown;
        
    reliable if (Role < ROLE_Authority)
        ResetBlown;
}

function ResetBlown()
{
    bIsBlown=false;
}

simulated function BringUp(optional Weapon PrevWeapon)
{
    if (ROLE == ROLE_AUTHORITY)
        bIsBlown=False;
    super.BringUp(PrevWeapon);
}

simulated function AltFire(float F)
{
    if (bIsBlown)
    {
        ResetBlown();
        PlayAnim(SelectAnim, SelectAnimRate, 0.0);
        Skins[BloodSkinSwitchArray] = default.Skins[BloodSkinSwitchArray];
        Texture = default.Texture;
    }
}

defaultproperties
{
     BloodyMaterial=Texture'WTFTex2.BanHammer.Banhammer_bloody'
     Weight=2.000000
     FireModeClass(0)=Class'ApocMutators.WTFEquipBanHammerFire'
     FireModeClass(1)=Class'KFMod.NoFire'
     Description="A deadly weapon"
     PickupClass=Class'ApocMutators.WTFEquipBanHammerPickup'
     AttachmentClass=Class'ApocMutators.WTFEquipBanHammerAttachment'
     ItemName="Ban Hammer"
     Skins(0)=Texture'WTFTex2.BanHammer.BanHammer'
}
