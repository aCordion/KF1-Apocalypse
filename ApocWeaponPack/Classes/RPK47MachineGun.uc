class RPK47MachineGun extends KFWeapon
    config(user);

#exec OBJ LOAD FILE=RPK47_A.ukx

// Use alt fire to switch fire modes
simulated function AltFire(float F)
{
    if(ReadyToFire(0))
    {
        DoToggle();
    }
}

// Toggle semi/auto fire
simulated function DoToggle ()
{
    local PlayerController Player;

    Player = Level.GetLocalPlayerController();
    if ( Player!=None )
    {
        //PlayOwnedSound(sound'Inf_Weapons_Foley.stg44_firemodeswitch01',SLOT_None,2.0,,,,false);
        FireMode[0].bWaitForRelease = !FireMode[0].bWaitForRelease;
        if ( FireMode[0].bWaitForRelease )
            Player.ReceiveLocalizedMessage(class'KFmod.BullpupSwitchMessage',0);
        else Player.ReceiveLocalizedMessage(class'KFmod.BullpupSwitchMessage',1);
    }
    Super.DoToggle();

    ServerChangeFireMode(FireMode[0].bWaitForRelease);
}

// Set the new fire mode on the server
function ServerChangeFireMode(bool bNewWaitForRelease)
{
    FireMode[0].bWaitForRelease = bNewWaitForRelease;
}

function bool RecommendRangedAttack()
{
    return true;
}

//TODO: LONG ranged?
function bool RecommendLongRangedAttack()
{
    return true;
}

function float SuggestAttackStyle()
{
    return -1.0;
}

exec function SwitchModes()
{
    DoToggle();
}

function float GetAIRating()
{
    local Bot B;

    B = Bot(Instigator.Controller);
    if ( (B == None) || (B.Enemy == None) )
        return AIRating;

    return AIRating;
}

function byte BestMode()
{
    return 0;
}

simulated function SetZoomBlendColor(Canvas c)
{
    local Byte    val;
    local Color   clr;
    local Color   fog;

    clr.R = 255;
    clr.G = 255;
    clr.B = 255;
    clr.A = 255;

    if( Instigator.Region.Zone.bDistanceFog )
    {
        fog = Instigator.Region.Zone.DistanceFogColor;
        val = 0;
        val = Max( val, fog.R);
        val = Max( val, fog.G);
        val = Max( val, fog.B);
        if( val > 128 )
        {
            val -= 128;
            clr.R -= val;
            clr.G -= val;
            clr.B -= val;
        }
    }
    c.DrawColor = clr;
}

defaultproperties
{
     MagCapacity=30
     ReloadRate=3.000000
     ReloadAnim="Reload"
     ReloadAnimRate=1.00000
     WeaponReloadAnim="Reload_AK47"
     Weight=7.000000
     bHasAimingMode=True
     IdleAimAnim="Iron_Idle"
     StandardDisplayFOV=65.000000
     bModeZeroCanDryFire=True
     TraderInfoTexture=Texture'RPK47_A.RPK47_T.RPK47_trader'
     SleeveNum=1
     bIsTier2Weapon=True
     Mesh=SkeletalMesh'RPK47_A.RPK47_mesh'
     Skins(0)=Texture'RPK47_A.RPK47_T.RPK_0'
     Skins(1)=Texture'KF_Weapons3_Trip_T.hands.Priest_Hands_1st_P'
     Skins(2)=Texture'RPK47_A.RPK47_T.RPK_1'
     Skins(3)=Texture'RPK47_A.RPK47_T.RPK_2'
     Skins(4)=Texture'RPK47_A.RPK47_T.RPK_3'
     Skins(5)=Texture'RPK47_A.RPK47_T.RPK_4'
     Skins(6)=Texture'RPK47_A.RPK47_T.RPK_5'
     Skins(7)=Texture'RPK47_A.RPK47_T.RPK_6'
     Skins(8)=Texture'RPK47_A.RPK47_T.RPK_7'
     Skins(9)=Shader'KF_Weapons2_Trip_T.Special.Aimpoint_sight_shdr'
     SelectSound=Sound'RPK47_A.RPK47_select'
     HudImage=Texture'RPK47_A.RPK47_T.RPK47_Unselected'
     SelectedHudImage=Texture'RPK47_A.RPK47_T.RPK47_selected'
     PlayerIronSightFOV=65.000000
     ZoomedDisplayFOV=32.000000
     FireModeClass(0)=Class'RPK47Fire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.550000
     CurrentRating=0.550000
     bShowChargingBar=True
     Description="RPG-7 (Ручной Пулемет Калашникова) под 7,62-мм промежуточный патрон образца 1943 г., создан как оружие поддержки стрелкового взвода на основе автомата АКМ. На вооружение Советской Армии RPG-7 был принят в 1961 г., заменив ручной пулемет Дегтярева РПД, созданный в конце 40-х годов."
     EffectOffset=(X=100.000000,Y=25.000000,Z=-10.000000)
     DisplayFOV=65.000000
     Priority=125
     CustomCrosshair=11
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross5"
     InventoryGroup=3
     GroupOffset=7
     PickupClass=Class'RPK47Pickup'
     PlayerViewOffset=(X=8.000000,Y=8.000000,Z=-3.000000)
     BobDamping=4.000000
     AttachmentClass=Class'RPK47Attachment'
     IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
     ItemName="RPG-7"
     TransientSoundVolume=1.250000
}
