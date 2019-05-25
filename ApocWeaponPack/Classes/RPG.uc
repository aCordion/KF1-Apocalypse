class RPG extends KFWeaponShotgun;

#exec OBJ LOAD FILE=RPG7DT_A.ukx

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
     MagCapacity=1
     ReloadRate=0.010000
     ReloadAnim="Reload"
     ReloadAnimRate=1.150000
     bDoSingleReload=True
     NumLoadedThisReload=1
     WeaponReloadAnim="Reload_Crossbow"
     MinimumFireRange=200
     HudImage=Texture'RPG7DT_A.WeaponSelect.rpg_unselected'
     SelectedHudImage=Texture'RPG7DT_A.WeaponSelect.RPG'
     bReloadEffectDone=False
     bAimingRifle=True
     bHasAimingMode=True
     IdleAimAnim="Idle"
     StandardDisplayFOV=75.000000
     bModeZeroCanDryFire=True
     SleeveNum=0
     TraderInfoTexture=Texture'RPG7DT_A.RPG.BigIcon_RPG'
     PlayerIronSightFOV=90.000000
     ZoomTime=0.260000
     ZoomedDisplayFOV=65.000000
     FireModeClass(0)=Class'RPGFire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="putaway"
     SelectSound=Sound'KF_LAWSnd.LAW_Select'
     SelectForce="SwitchToRocketLauncher"
     AIRating=0.750000
     CurrentRating=0.750000
     bSniping=False
     Description="RPG-7 Launcher||Manufacturer: Classic Weapons Industries|Primary: Powerful Rocket Fire|Secondary: Iron Sights||Ah, the RPG-7. The arch enemy of armored columns ever since its pre-war inception. The RPG-7 is a portable, shoulder mounted, anti-tank rocket propelled grenade launcher with a rugged, reliable design and a high powered warhead. While its simple HE warhead may not be as accurate as the guidable G5's or as powerful as the SM-AT/AA's, it can still devastate infantry and disable lightly armored vehicles."
     EffectOffset=(X=0.100000,Y=-10.000000,Z=0.100000)
     DisplayFOV=75.000000
     Priority=199
     HudColor=(G=0)
     InventoryGroup=4
     GroupOffset=4
     PickupClass=Class'RPGPickup'
     PlayerViewOffset=(X=16.000000,Y=20.000000,Z=-18.000000)
     BobDamping=1.800000
     AttachmentClass=Class'RPGAttachment'
     IconCoords=(X1=429,Y1=212,X2=508,Y2=251)
     ItemName="RPG-7"
     Mesh=SkeletalMesh'RPG7DT_A.RPG7'
     Skins(1)=Texture'RPG7DT_A.RPG.RPG_Main'
     AmbientGlow=2
}
