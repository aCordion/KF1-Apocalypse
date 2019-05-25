//=============================================================================
// Modified MP7 MedicGun Inventory class
//=============================================================================
class PPSH41x extends KFWeapon;

#exec OBJ LOAD FILE=KFPPSh.utx
#exec OBJ LOAD FILE=PPSH.ukx

var ()      float       AmmoRegenRate;  // How quickly the healing charge regenerates
var ()      int         HealBoostAmount;// How much we heal a player by default with the heal dart
Const MaxAmmoCount=500;                 // Maximum healing charge count
var         float       RegenTimer;     // Tracks regeneration
var         int         HealAmmoCharge; // Current healing charger
var localized   string  SuccessfulHealMessage;

replication
{
    // Things the server should send to the client.
    reliable if( Role==ROLE_Authority )
        HealAmmoCharge;

 	reliable if( Role == ROLE_Authority )
		ClientSuccessfulHeal;
}

// The server lets the client know they successfully healed someone
simulated function ClientSuccessfulHeal(String HealedName)
{
    if( PlayerController(Instigator.Controller) != none )
    {
        PlayerController(Instigator.controller).ClientMessage(SuccessfulHealMessage@HealedName, 'CriticalEvent');
    }
}

// Return a float value representing the current healing charge amount
simulated function float ChargeBar()
{
	return FClamp(float(HealAmmoCharge)/float(MaxAmmoCount),0,1);
}

simulated function MaxOutAmmo()
{
	if ( bNoAmmoInstances )
	{
		if ( AmmoClass[0] != None )
			AmmoCharge[0] = MaxAmmo(0);
		return;
	}
	if ( Ammo[0] != None )
		Ammo[0].AmmoAmount = Ammo[0].MaxAmmo;

	HealAmmoCharge = MaxAmmoCount;
}

simulated function SuperMaxOutAmmo()
{
   HealAmmoCharge = 999;

	if ( bNoAmmoInstances )
	{
		if ( AmmoClass[0] != None )
			AmmoCharge[0] = 999;
		return;
	}
	if ( Ammo[0] != None )
		Ammo[0].AmmoAmount = 999;
}

simulated function int MaxAmmo(int mode)
{
    if( Mode == 1 )
    {
	   return MaxAmmoCount;
	}
	else
	{
	   return super.MaxAmmo(mode);
	}
}

simulated function FillToInitialAmmo()
{
	if ( bNoAmmoInstances )
	{
		if ( AmmoClass[0] != None )
			AmmoCharge[0] = Max(AmmoCharge[0], AmmoClass[0].Default.InitialAmount);
        HealAmmoCharge = MaxAmmoCount;
		return;
	}

	if ( Ammo[0] != None )
        Ammo[0].AmmoAmount = Ammo[0].AmmoAmount;

    HealAmmoCharge = MaxAmmoCount;
}

simulated function int AmmoAmount(int mode)
{
    if( Mode == 1 )
    {
	   return HealAmmoCharge;
	}
	else
	{
	   return super.AmmoAmount(mode);
	}
}

simulated function bool AmmoMaxed(int mode)
{
    if( Mode == 1 )
    {
	   return HealAmmoCharge>=MaxAmmoCount;
	}
	else
	{
	   return super.AmmoMaxed(mode);
	}
}

simulated function float AmmoStatus(optional int Mode) // returns float value for ammo amount
{
    if( Mode == 1 )
    {
	   return float(HealAmmoCharge)/float(MaxAmmoCount);
	}
	else
	{
	   return super.AmmoStatus(Mode);
	}
}

simulated function bool ConsumeAmmo(int Mode, float load, optional bool bAmountNeededIsMax)
{
    if( Mode == 1 )
    {
        if( Load>HealAmmoCharge )
        {
            return false;
        }

    	HealAmmoCharge-=Load;
    	Return True;
	}
	else
	{
	   return super.ConsumeAmmo(Mode, load, bAmountNeededIsMax);
	}
}

function bool AddAmmo(int AmmoToAdd, int Mode)
{
    if( Mode == 1 )
    {
    	if( HealAmmoCharge<MaxAmmoCount )
    	{
    		HealAmmoCharge+=AmmoToAdd;
    		if( HealAmmoCharge>MaxAmmoCount )
    		{
    			HealAmmoCharge = MaxAmmoCount;
    		}
    	}
        return true;
    }
    else
    {
        return super.AddAmmo(AmmoToAdd,Mode);
    }
}

simulated function bool HasAmmo()
{
    if( HealAmmoCharge > 0 )
    {
        return true;
    }

	if ( bNoAmmoInstances )
	{
    	return ( (AmmoClass[0] != none && FireMode[0] != none && AmmoCharge[0] >= FireMode[0].AmmoPerFire) );
	}
    return (Ammo[0] != none && FireMode[0] != none && Ammo[0].AmmoAmount >= FireMode[0].AmmoPerFire);
}

simulated function CheckOutOfAmmo()
{
    return;
}

simulated function Tick(float dt)
{
	if ( Level.NetMode!=NM_Client && HealAmmoCharge<MaxAmmoCount && RegenTimer<Level.TimeSeconds )
	{
		RegenTimer = Level.TimeSeconds + AmmoRegenRate;

		if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != none && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != none )
		{
			HealAmmoCharge += 10 * KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.Static.GetSyringeChargeRate(KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo));
		}
		else
		{
			HealAmmoCharge += 10;
		}

		if ( HealAmmoCharge > MaxAmmoCount )
		{
			HealAmmoCharge = MaxAmmoCount;
		}
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
     AmmoRegenRate=0.300000
     HealBoostAmount=20
     HealAmmoCharge=500
     SuccessfulHealMessage="You healed "
     MagCapacity=71
     ReloadRate=3.100000
     ReloadAnim="Reload"
     ReloadAnimRate=0.800000
     WeaponReloadAnim="Reload"
     Weight=3.000000
     bHasAimingMode=True
     IdleAimAnim="Idle_Iron"
     StandardDisplayFOV=55.000000
     bModeZeroCanDryFire=True
     SleeveNum=2
     PlayerIronSightFOV=65.000000
     ZoomedDisplayFOV=45.000000
     FireModeClass(0)=Class'ApocMutators.PPSHFire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     SelectSound=Sound'KF_MP7Snd.MP7_Select'
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.550000
     CurrentRating=0.550000
     bShowChargingBar=True
     Description="An advanced prototype submachine gun. Modified to fire healing darts."
     EffectOffset=(X=100.000000,Y=25.000000,Z=-10.000000)
     DisplayFOV=55.000000
     Priority=10
     InventoryGroup=4
     GroupOffset=8
     PickupClass=Class'ApocMutators.PPSHPickup'
     PlayerViewOffset=(X=18.000000,Y=22.000000,Z=-20.000000)
     BobDamping=6.000000
     AttachmentClass=Class'ApocMutators.PPSHAttachment'
     IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
     ItemName="PPSh-41"
     Mesh=SkeletalMesh'PPSH.PPSh_John'
     Skins(0)=Texture'KFPPSH.Rifle.PPSH'
     TransientSoundVolume=1.250000
}
