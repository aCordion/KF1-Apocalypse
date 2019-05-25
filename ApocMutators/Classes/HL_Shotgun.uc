Class HL_Shotgun extends HL2Weapon;

var() float PreReloadTime,PostReloadTime,PumpTime;
var byte ReloadStage;
var transient float InterruptTimer;

replication
{
	reliable if(Role == ROLE_Authority)
		ClientPump,ClientEndReload;
}

simulated function bool StartFire(int Mode)
{
	if( bIsReloading && MagAmmoRemaining>0 && InterruptTimer<Level.TimeSeconds )
	{
		InterruptTimer = Level.TimeSeconds+0.5f;
		InterruptReload();
	}
	return Super(Weapon).StartFire(Mode);
}

simulated function PumpShotgun()
{
	local float Div;

	if( Instigator!=None && Instigator.IsLocallyControlled() && Instigator.IsFirstPerson() )
	{
		if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != none && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != none )
			Div = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.Static.GetFireSpeedMod(KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo), Self);
		else Div = 1.f;
		PlayAnim('Pump',Div);
	}
	if( Role == ROLE_Authority )
		Instigator.SetAnimAction('Weapon_Switch');
}
simulated function ClientPump()
{
	if( Role < ROLE_Authority )
		PumpShotgun();
}
simulated function ClientReloadEffects()
{
	if( Instigator==None || !Instigator.IsLocallyControlled() || !Instigator.IsFirstPerson() )
		return;

	bIsReloading = true;
	PlayAnim('Reload2', ReloadAnimRate*GetReloadRate());
}
simulated function ClientEndReload()
{
	if( Instigator==None || !Instigator.IsLocallyControlled() || !Instigator.IsFirstPerson() )
		return;

	bIsReloading = true;
	PlayAnim('Reload3', ReloadAnimRate*GetReloadRate());
}
simulated function ClientInterruptReload();

function ServerInterruptReload()
{
	bReloadEffectDone = false;
}

exec function ReloadMeNow()
{
	local float ReloadMulti;

	if(!AllowReload())
		return;

	bReloadEffectDone = true;
	ReloadMulti = GetReloadRate();
	bIsReloading = true;
	ReloadTimer = Level.TimeSeconds+(PreReloadTime/ReloadMulti);
	ReloadStage = 0;
	NumLoadedThisReload = 0;

	ClientReload();
	Instigator.SetAnimAction(WeaponReloadAnim);

	// Reload message commented out for now - Ramm
	if ( Level.Game.NumPlayers > 1 && KFGameType(Level.Game).bWaveInProgress && KFPlayerController(Instigator.Controller) != none &&
		 Level.TimeSeconds - KFPlayerController(Instigator.Controller).LastReloadMessageTime > KFPlayerController(Instigator.Controller).ReloadMessageDelay )
	{
		KFPlayerController(Instigator.Controller).Speech('AUTO', 2, "");
		KFPlayerController(Instigator.Controller).LastReloadMessageTime = Level.TimeSeconds;
	}
}

simulated function WeaponTick(float dt)
{
	if( bIsPendingPutDown && !bIsReloading && FireMode[0].NextFireTime<Level.TimeSeconds
		&& FireMode[1].NextFireTime<Level.TimeSeconds )
	{
		bIsPendingPutDown = false;
		PutDown();
		return;
	}

	if ( (Level.NetMode == NM_Client) || Instigator == None )
		return;

	UpdateMagCapacity(Instigator.PlayerReplicationInfo);

	if(!bIsReloading)
	{
		if(!Instigator.IsHumanControlled())
		{
			dt = Level.TimeSeconds - Instigator.Controller.LastSeenTime;
			if(MagAmmoRemaining == 0 || ((dt >= 5 || dt > MagAmmoRemaining) && MagAmmoRemaining < MagCapacity))
				ReloadMeNow();
		}
	}
	else if( Level.TimeSeconds>ReloadTimer )
	{
		dt = GetReloadRate();
		
		if( ReloadStage==3 ) // End of reloading
			ActuallyFinishReloading();
		else if( ReloadStage==1 || ReloadStage==2 ) // Play put down and pump.
		{
			if( ReloadStage==1 )
			{
				ReloadTimer = Level.TimeSeconds+(PostReloadTime/dt);
				ClientEndReload();
			}
			else if( ReloadStage==2 )
			{
				ReloadTimer = Level.TimeSeconds+(PumpTime/dt);
				PumpShotgun();
				ClientPump();
			}
			++ReloadStage;
			if( NumLoadedThisReload==0 )
				++ReloadStage; // Skip pumping.
		}
		else
		{
			if( !bReloadEffectDone || MagAmmoRemaining>=Min(MagCapacity,AmmoAmount(0)) )
			{
				++ReloadStage;
				return;
			}
			AddReloadedAmmo();
			++NumLoadedThisReload;
			
			ClientReloadEffects();
			Instigator.SetAnimAction(WeaponReloadAnim);
			
			ReloadTimer = Level.TimeSeconds+(ReloadRate/dt);
		}
	}
}
// Add the ammo for this reload
function AddReloadedAmmo()
{
	UpdateMagCapacity(Instigator.PlayerReplicationInfo);
	MagAmmoRemaining = Min(MagAmmoRemaining+1,Min(MagCapacity,AmmoAmount(0)));
}

simulated function AnimEnd(int channel)
{
    local name anim;
    local float frame, rate;

    GetAnimParams(0, anim, frame, rate);
	
	if( anim!='Reload1' && anim!='reload2' )
		Super.AnimEnd(channel);
}

defaultproperties
{
     PreReloadTime=0.560000
     PostReloadTime=0.500000
     PumpTime=0.600000
     MagCapacity=6
     ReloadRate=0.460000
     ReloadAnim="Reload1"
     bHoldToReload=True
     FlashBoneName="Gun"
     WeaponReloadAnim="Reload_MP5"
     HudImage=Texture'HL2WeaponsA.Icons.I_Shotgun'
     SelectedHudImage=Texture'HL2WeaponsA.Icons.I_Shotgun'
     Weight=4.000000
     TraderInfoTexture=Texture'HL2WeaponsA.Icons.I_Shotgun'
     FireModeClass(0)=Class'ApocMutators.ShottyFire'
     FireModeClass(1)=Class'ApocMutators.ShottyAltFire'
     BringUpTime=0.800000
     Description="A shotgun."
     Priority=130
     InventoryGroup=3
     GroupOffset=5
     PickupClass=Class'ApocMutators.HL_ShotgunPickup'
     PlayerViewOffset=(X=-20.000000)
     PlayerViewPivot=(Yaw=-16384)
     AttachmentClass=Class'ApocMutators.ShottyAttachment'
     ItemName="Shotgun"
     Mesh=SkeletalMesh'HL2WeaponsA.HL_Shotgun'
}
