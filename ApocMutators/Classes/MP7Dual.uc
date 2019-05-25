class MP7Dual extends KFWeapon;

#exec OBJ LOAD FILE=DualMP7Tex.utx
#exec OBJ LOAD FILE=Dualmp7static.usx
#exec OBJ LOAD FILE=DualMP7.ukx

var name altTPAnim;
var Actor altThirdPersonActor;
var name altWeaponAttach;

/**
 * Handles all the functionality for zooming in including
 * setting the parameters for the weapon, pawn, and playercontroller
 *
 * @param bAnimateTransition whether or not to animate this zoom transition
 */
simulated function ZoomIn(bool bAnimateTransition)
{
    super.ZoomIn(bAnimateTransition);

    if( bAnimateTransition )
    {
        if( bZoomOutInterrupted )
        {
            PlayAnim('GOTO_Iron',1.0,0.1);
        }
        else
        {
            PlayAnim('GOTO_Iron',1.0,0.1);
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
        TweenAnim('GOTO_Hip',ZoomTime);
    }
}

function AttachToPawn(Pawn P)
{
	local name BoneName;

	Super.AttachToPawn(P);

	if(altThirdPersonActor == None)
	{
		altThirdPersonActor = Spawn(AttachmentClass,Owner);
		InventoryAttachment(altThirdPersonActor).InitFor(self);
	}
	else altThirdPersonActor.NetUpdateTime = Level.TimeSeconds - 1;
	BoneName = P.GetOffhandBoneFor(self);
	if(BoneName == '')
	{
		altThirdPersonActor.SetLocation(P.Location);
		altThirdPersonActor.SetBase(P);
	}
	else P.AttachToBone(altThirdPersonActor,BoneName);

	if(altThirdPersonActor != None)
		DualDeagleAttachment(altThirdPersonActor).bIsOffHand = true;
	if(altThirdPersonActor != None && ThirdPersonActor != None)
	{
		MP7DAttachment(altThirdPersonActor).brother = MP7DAttachment(ThirdPersonActor);
		MP7DAttachment(ThirdPersonActor).brother = MP7DAttachment(altThirdPersonActor);
		altThirdPersonActor.LinkMesh(MP7DAttachment(ThirdPersonActor).BrotherMesh);
	}
}

simulated function bool StartFire(int Mode)
{
	if( Mode == 1 )
		return super.StartFire(Mode);

	if( !super.StartFire(Mode) )  // returns false when mag is empty
	   return false;

	if( AmmoAmount(0) <= 0 )
	{
    	return false;
    }

	AnimStopLooping();

	if( !FireMode[Mode].IsInState('FireLoop') && (AmmoAmount(0) > 0) )
	{
		FireMode[Mode].StartFiring();
		return true;
	}
	else
	{
		return false;
	}

	return true;
}

simulated function AnimEnd(int channel)
{
    local name anim;
    local float frame, rate;

	if(!FireMode[0].IsInState('FireLoop'))
	{
        GetAnimParams(0, anim, frame, rate);

        if (ClientState == WS_ReadyToFire)
        {
             if ((FireMode[0] == None || !FireMode[0].bIsFiring) && (FireMode[1] == None || !FireMode[1].bIsFiring))
            {
                PlayIdle();
            }
        }
	}
}

simulated function bool CanZoomNow()
{
	Return (!FireMode[0].bIsFiring && Instigator!=None && Instigator.Physics!=PHYS_Falling);
}

defaultproperties
{
     MagCapacity=80
     ReloadRate=2.600000
     ReloadAnim="Reload"
     ReloadAnimRate=1.000000
     FlashBoneName="Tip_Right"
     WeaponReloadAnim="Reload"
     HudImage=Texture'DualMP7Tex.Mp7_unselected'
     SelectedHudImage=Texture'DualMP7Tex.Mp7_selected'
     Weight=4.000000
     bHasAimingMode=True
     IdleAimAnim="Idle_Iron"
     StandardDisplayFOV=70.000000
     bModeZeroCanDryFire=True
     TraderInfoTexture=Texture'DualMP7Tex.MP7_trader'
     PlayerIronSightFOV=65.000000
     ZoomedDisplayFOV=65.000000
     FireModeClass(0)=Class'ApocMutators.MP7DFire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     SelectSound=Sound'KF_MP7Snd.MP7_Select'
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.550000
     CurrentRating=0.550000
     bShowChargingBar=True
     Description="An advanced prototype submachine gun. Modified to fire healing darts."
     EffectOffset=(X=120.000000,Z=-10.000000)
     DisplayFOV=55.000000
     Priority=10
     InventoryGroup=4
     GroupOffset=8
     PickupClass=Class'ApocMutators.MP7DPickup'
     PlayerViewOffset=(X=-12.000000,Z=-8.000000)
     BobDamping=6.000000
     AttachmentClass=Class'ApocMutators.MP7DAttachment'
     IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
     ItemName="Dual MP7s"
     Mesh=SkeletalMesh'Dualmp7.DualMp71_John'
     Skins(0)=Combiner'KF_Weapons2_Trip_T.Special.MP_7_cmb'
     TransientSoundVolume=1.250000
}
