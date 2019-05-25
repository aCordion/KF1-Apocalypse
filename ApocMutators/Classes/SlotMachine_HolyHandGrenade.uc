class SlotMachine_HolyHandGrenade extends KFWeapon;

var Pawn TempPawn;

simulated function AnimEnd(int channel)
{
    local name anim;
    local float frame, rate;

    GetAnimParams(0, anim, frame, rate);
    if (Anim != 'Toss')
        Super.AnimEnd(channel);
}

final function SwitchNextWeapon()
{
    TempPawn = Pawn(Owner);
    TempPawn.DeleteInventory(Self);
}

simulated function float RateSelf()
{
    if (Instigator != None && Instigator.Weapon == Self)
        return -1;
    return Super.RateSelf();
}

State KillSelf
{
Ignores Timer, AnimEnd;

Begin:
    Sleep(0.8f);
    SwitchNextWeapon();
    Sleep(0.1f);
    TempPawn.Controller.ClientSwitchToBestWeapon();
    Destroy();
}

defaultproperties
{
     HudImage=TexScaler'ApocMutators.IconScalar'
     SelectedHudImage=TexScaler'ApocMutators.IconScalar'
     Weight=0.000000
     bKFNeverThrow=True
     FireModeClass(0)=Class'ApocMutators.SlotMachine_HHGFire'
     FireModeClass(1)=Class'KFMod.NoFire'
     RestAnim="Idle"
     AimAnim="Idle"
     RunAnim="Idle"
     PutDownAnim="Deselect"
     AIRating=80.000000
     CurrentRating=80.000000
     bCanThrow=False
     Priority=80
     SmallViewOffset=(Y=-18.000000,Z=-18.000000)
     PlayerViewOffset=(Y=-18.000000,Z=-18.000000)
     AttachmentClass=Class'ApocMutators.SlotMachine_HHFragAttachment'
     ItemName="Holy Hand Grenade"
     Mesh=SkeletalMesh'ApocMutators.HHGrenadeMesh'
     Skins(0)=Texture'ApocMutators.Grenade'
     Skins(1)=Combiner'KF_Weapons_Trip_T.hands.hands_1stP_military_cmb'
     TransientSoundVolume=1.000000
     TransientSoundRadius=700.000000
}
