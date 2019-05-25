class M202A1AltFire extends M202A1Fire;

event ModeDoFire()
{
	local float Rec;
	
	if (!AllowFire())
		return;
	
	Spread = Default.Spread;
	
	Rec = GetFireSpeed();
	FireRate = default.FireRate/Rec;
	FireAnimRate = default.FireAnimRate*Rec;
	if(KFWeapon(Weapon).bAimingRifle)
	{		
		FireAnim = FireAnimIron;
	}
	else
	{
		FireAnim = FireAnimSimple;
	}

	Rec = 1;
	
	if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != none && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != none )
	{
		Spread *= KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.Static.ModifyRecoilSpread(KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo), self, Rec);
	}
	
	if( !bFiringDoesntAffectMovement )
	{
		if (FireRate > 0.25)
		{
			Instigator.Velocity.x *= 0.1;
			Instigator.Velocity.y *= 0.1;
		}
		else
		{
			Instigator.Velocity.x *= 0.5;
			Instigator.Velocity.y *= 0.5;
		}
	}
	if (!AllowFire())
	return;
	
	if (MaxHoldTime > 0.0)
	HoldTime = FMin(HoldTime, MaxHoldTime);
	
	// server
	if (Level.NetMode != NM_Client)
	{
	Load = KFWeapon(Weapon).MagAmmoRemaining;
	log("Load: "$Load);
	log("ThisModeNum: "$ThisModeNum);
	AmmoPerFire = Load;
	Weapon.ConsumeAmmo(ThisModeNum, Load);
	DoFireEffectN(Load);
		HoldTime = 0;	// if bot decides to stop firing, HoldTime must be reset first
	if ( (Instigator == None) || (Instigator.Controller == None) )
			return;
	
	if ( AIController(Instigator.Controller) != None )
	    AIController(Instigator.Controller).WeaponFireAgain(BotRefireRate, true);
	
	Instigator.DeactivateSpawnProtection();
	}
	
	// client
	if (Instigator.IsLocallyControlled())
	{
		// Need to consume ammo client side to make sure the right anims play
	        if( Weapon.Role < ROLE_Authority )
			{
		        //Weapon.ConsumeAmmo(ThisModeNum, Load);
	        }
	ShakeView();
	PlayFiring();
	FlashMuzzleFlash();
	StartMuzzleSmoke();
	}
	else // server
	{
	ServerPlayFiring();
	}
	
	Weapon.IncrementFlashCount(ThisModeNum);
	
	// set the next firing time. must be careful here so client and server do not get out of sync
	if (bFireOnRelease)
	{
	if (bIsFiring)
	    NextFireTime += MaxHoldTime + FireRate;
	else
	    NextFireTime = Level.TimeSeconds + FireRate;
	}
	else
	{
	NextFireTime += FireRate;
	NextFireTime = FMax(NextFireTime, Level.TimeSeconds);
	}
	
	//Load = AmmoPerFire;
	HoldTime = 0;
	
	if (Instigator.PendingWeapon != Weapon && Instigator.PendingWeapon != None)
	{
	bIsFiring = false;
	Weapon.PutDown();
	}
	// client
	if (Instigator.IsLocallyControlled())
	{
	HandleRecoil(Rec);
	}
}

function DoFireEffectN(int nomer)
{	
	local Vector offsetsXYZ;
	offsetsXYZ.X = 0.0;
	offsetsXYZ.Y = 0.0;
	offsetsXYZ.Z = 0.0;
	if(nomer>=4)
	{
		offsetsXYZ.Y = -3.12;
		offsetsXYZ.z =  3.12;
		DoFireEffectWithOffsets(offsetsXYZ);
	}
	if(nomer>=3)
	{
		offsetsXYZ.Y =  3.12;
		offsetsXYZ.z =  3.12;	
		DoFireEffectWithOffsets(offsetsXYZ);
	}
	if(nomer>=2)
	{
		offsetsXYZ.Y = -3.12;
		offsetsXYZ.z = -3.12;
		DoFireEffectWithOffsets(offsetsXYZ);
	}
	if(nomer>=1)
	{
		offsetsXYZ.Y =  3.12;
		offsetsXYZ.z = -3.12;
		DoFireEffectWithOffsets(offsetsXYZ);
	}	
}


defaultproperties
{
     FireAnimIron="Fire_Hard"
     FireAnimSimple="IronFire_Hard"
}
