class VALDTAssaultRifle extends KFWeapon
    config(user);

#exec OBJ LOAD FILE=VALDT_v2_A.ukx

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
     ReloadRate=2.500000
     ReloadAnim="Reload"
     ReloadAnimRate=1.12000
     WeaponReloadAnim="Reload_AK47"
     SelectAnimRate=1.363600
     Weight=5.000000
     bHasAimingMode=True
     IdleAimAnim="Iron_Idle"
     StandardDisplayFOV=65.000000
     bModeZeroCanDryFire=True
     TraderInfoTexture=Texture'VALDT_v2_A.VALDT_Trader'
     SleeveNum=3
     bIsTier2Weapon=True
     Mesh=SkeletalMesh'VALDT_v2_A.ValDTmesh'
     Skins(0)=Texture'VALDT_v2_A.wpn_vss'
     Skins(1)=Texture'VALDT_v2_A.newvss'
     Skins(2)=Texture'VALDT_v2_A.wpn_bullet1_545'
     Skins(3)=Texture'KF_Weapons2_Trip_T.hands.BritishPara_Hands_1st_P'
     SelectSound=Sound'KF_PumpSGSnd.SG_Select'
     HudImage=Texture'VALDT_v2_A.VALDT_Unselected'
     SelectedHudImage=Texture'VALDT_v2_A.VALDT_selected'
     PlayerIronSightFOV=65.000000
     ZoomedDisplayFOV=32.000000
     FireModeClass(0)=Class'VALDTFire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.550000
     CurrentRating=0.550000
     bShowChargingBar=True
     Description="АС «Вал» (Автомат Специальный, Индекс ГРАУ — 6П30) — бесшумный автомат, разработанный в климовском ЦНИИточмаш конструкторами П. Сердюковым и В. Красниковым во второй половине 1980-х годов вместе с бесшумной снайперской винтовкой ВСС и состоящий на вооружении подразделений специального назначения России."
     EffectOffset=(X=100.000000,Y=25.000000,Z=-10.000000)
     DisplayFOV=65.000000
     Priority=135
     CustomCrosshair=11
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross5"
     InventoryGroup=3
     GroupOffset=7
     PickupClass=Class'VALDTPickup'
     PlayerViewOffset=(X=10.000000,Y=10.000000,Z=-5.000000)
     BobDamping=5.000000
     AttachmentClass=Class'VALDTAttachment'
     IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
     ItemName="АС «Вал»"
     TransientSoundVolume=1.250000
}
