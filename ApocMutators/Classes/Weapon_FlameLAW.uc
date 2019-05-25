class Weapon_FlameLAW extends KFWeaponShotgun;

// Killing Floor's Light Anti Tank Weapon.
// This is probably about as badass as things get....

simulated event WeaponTick(float dt)
{
	if(AmmoAmount(0) == 0)
		MagAmmoRemaining = 0;
	super.Weapontick(dt);
}

/**
 * Handles all the functionality for zooming in including
 * setting the parameters for the weapon, pawn, and playercontroller
 *
 * @param bAnimateTransition whether or not to animate this zoom transition
 */
simulated function ZoomIn(bool bAnimateTransition)
{
    if( Level.TimeSeconds < FireMode[0].NextFireTime )
    {
        return;
    }

    super.ZoomIn(bAnimateTransition);

    if( bAnimateTransition )
    {
        if( bZoomOutInterrupted )
        {
            PlayAnim('Raise',1.0,0.1);
        }
        else
        {
            PlayAnim('Raise',1.0,0.1);
        }
    }
}


/**
 * Handles all the functionality for zooming out including
 * setting the parameters for the weapon, pawn, and playercontroller
 *
 * @param bAnimateTransition whether or not to animate this zoom transition
 */
simulated function ZoomOut(bool bAnimateTransition)
{
    super.ZoomOut(false);

    if( bAnimateTransition )
    {
        TweenAnim(IdleAnim,FastZoomOutTime);
    }
}

defaultproperties
{
    Skins(0)=Combiner'KF_Weapons_Trip_T.Supers.law_cmb'
    Skins(1)=Shader'KF_Weapons_Trip_T.Supers.law_reddot_shdr'
    Skins(2)=Combiner'KF_Weapons_Trip_T.Supers.rocket_cmb'

    WeaponReloadAnim=Reload_LAW

    MagCapacity=1
    ReloadRate=3.000000
    Weight=14.000000
    FireModeClass(0)=Class'ApocMutators.Weapon_FlameLAWFire'
    FireModeClass(1)=Class'KFMod.NoFire'
    PutDownAnim="PutDown"
    //PutDownTime=1.000000
    //  BringUpTime=1.000000
    SelectSound=Sound'KF_LAWSnd.LAW_Select'
    SelectForce="SwitchToRocketLauncher"
    Description="The Light Anti Personnel Weapon is a military grade heavy weapons platform designed to cook noobs."
    EffectOffset=(X=50.000000,Y=1.000000,Z=10.000000)
    Priority=50
    HudColor=(G=0)
    InventoryGroup=4
    GroupOffset=4
    PickupClass=Class'ApocMutators.Weapon_FlameLAWPickup'
    PlayerViewOffset=(X=30.0,Y=30.0,Z=0.000000)
    BobDamping=7.000000
    AttachmentClass=Class'KFMod.LAWAttachment'
    IconCoords=(X1=429,Y1=212,X2=508,Y2=251)
    ItemName="Incendiary L.A.W"
    Mesh=SkeletalMesh'KF_Weapons_Trip.LAW_Trip'
    DrawScale=1.000000
    AmbientGlow=2

    AIRating=1.5
    CurrentRating=1.5

    MinimumFireRange = 300
    bSniping=False

    ZoomTime=0.26//1.0
    FastZoomOutTime=0.2
    ZoomInRotation=(Pitch=-910,Yaw=0,Roll=2910)
    bHasAimingMode=true
    IdleAimAnim=AimIdle

    DisplayFOV=75.000000
    StandardDisplayFOV=75.0
    PlayerIronSightFOV=90
    ZoomedDisplayFOV=65

	HudImage=texture'KillingFloorHUD.WeaponSelect.LAW_unselected'
	SelectedHudImage=texture'KillingFloorHUD.WeaponSelect.LAW'
    SleeveNum=3
	TraderInfoTexture=texture'KillingFloorHUD.Trader_Weapon_Images.Trader_LAW'
}
