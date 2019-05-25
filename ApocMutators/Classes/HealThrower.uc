class HealThrower extends KFWeapon;
//class HealThrower extends MP7MMedicGun; //Makes the medic syringe number appear next to ammo? Gives medic mag bonus offline

#exec OBJ LOAD FILE=HealThrower_R.ukx

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
	if(!FireMode[0].IsInState('FireLoop'))
	{
	  	Super.AnimEnd(channel);
	}
}

simulated function WeaponTick(float dt)
{
  Super.WeaponTick(dt);
}

function bool RecommendRangedAttack()
{
	return true;
}

function float SuggestAttackStyle()
{
	return -1.0;
}

function bool RecommendLongRangedAttack()
{
	return true;
}


defaultproperties
{
	Skins(0)=Combiner'HealThrower_R.HealThrower_cmb'
	SkinRefs(0)="HealThrower_R.HealThrower_cmb"
	SleeveNum=1
	Skins(2)=Texture'HealThrower_R.Blank'
	SkinRefs(2)="HealThrower_R.Blank"
    WeaponReloadAnim=Reload_Flamethrower
    MagCapacity=100
    ReloadRate=4.14
    ReloadAnim="Reload"
    ReloadAnimRate=1.0
    Weight=7
    bModeZeroCanDryFire=True
    FireModeClass(0)=Class'HealThrowerBlast'
    FireModeClass(1)=Class'KFMod.NoFire'
    PutDownAnim="PutDown"
    SelectSound=none
    Description="Why didn't we think of this earlier? Seriously! I'm sick of dying from Sirens because you fools think a stunned Scrake is a more dangerous target!|-Lt. Masterson"
    Priority=145
    InventoryGroup=3
    GroupOffset=8
    PickupClass=Class'HealThrowerPickup'
    BobDamping=6
    AttachmentClass=Class'HealThrowerAttachment'
    IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
    ItemName="Heal Thrower"
	Mesh=SkeletalMesh'HealThrower_R.HealThrower_1st'
    MeshRef="HealThrower_R.HealThrower_1st"
    DrawScale=0.900000
    TransientSoundVolume=1.250000
    AmbientGlow=0
    PutDownTime = 1.0
    PutDownAnimRate=1.0
    QuickPutDownTime=0.5
    PlayerViewOffset=(X=5,Y=7,Z=-8)
    EffectOffset=(X=100,Y=25,Z=-10)
    bSteadyAim = true
    AIRating=0.7
    CurrentRating=0.7
    MinimumFireRange = 300
    ZoomTime=0.25
    FastZoomOutTime=0.2
    ZoomInRotation=(Pitch=-1000,Yaw=0,Roll=1500)
    bHasAimingMode=true
    IdleAimAnim=Idle
    DisplayFOV=70
    StandardDisplayFOV=70.0
    PlayerIronSightFOV=75
    ZoomedDisplayFOV=70

	HudImage=Texture'HealThrower_R.HealThrower_HUD_UnSelected'
	HudImageRef="HealThrower_R.HealThrower_HUD_UnSelected"
	SelectedHudImage=Texture'HealThrower_R.HealThrower_HUD_Selected'
	SelectedHudImageRef="HealThrower_R.HealThrower_HUD_Selected"
	TraderInfoTexture=texture'HealThrower_R.HealThrower_HUD_Trader'

	bIsTier2Weapon=true
}
