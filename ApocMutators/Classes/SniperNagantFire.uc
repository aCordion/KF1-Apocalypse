class SniperNagantFire extends MosinNagantFire;

function float GetFireSpeed()
{
	if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != none && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != none )
	{
		return KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.Static.GetFireSpeedMod(KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo), Weapon);
	}

	return 1;
}

function PlayFiring()
{
	local float Rec;
	local float Rec2;
    local float RandPitch;
	
	Rec = GetFireSpeed();
	if (Rec>1 || Rec<1){Rec2 = Rec*1.15;}
	else{Rec2 = Rec;}
	FireRate = default.FireRate/Rec2;
	FireAnimRate = default.FireAnimRate*Rec2;
	Rec = 1;
	Rec2 = 0;


	if ( Weapon.Mesh != None )
	{
		if ( FireCount > 0 )
		{
			if( KFWeap.bAimingRifle )
			{
    				Weapon.PlayAnim(FireAimedAnim, FireAnimRate, TweenTime);
			}
			else
			{
    				Weapon.PlayAnim(FireAnim, FireAnimRate, TweenTime);
			}
		}
		else
		{
            if( KFWeap.bAimingRifle )
			{
                    Weapon.PlayAnim(FireAimedAnim, FireAnimRate, TweenTime);
			}
			else
			{
                Weapon.PlayAnim(FireAnim, FireAnimRate, TweenTime);
			}
		}
	}


	if( Weapon.Instigator != none && Weapon.Instigator.IsLocallyControlled() &&
	   Weapon.Instigator.IsFirstPerson() && StereoFireSound != none )
	{
        if( bRandomPitchFireSound )
        {
            RandPitch = FRand() * RandomPitchAdjustAmt;

            if( FRand() < 0.5 )
            {
                RandPitch *= -1.0;
            }
        }

        Weapon.PlayOwnedSound(StereoFireSound,SLOT_Interact,TransientSoundVolume * 0.85,,TransientSoundRadius,(1.0 + RandPitch),false);
    }
    else
    {
        if( bRandomPitchFireSound )
        {
            RandPitch = FRand() * RandomPitchAdjustAmt;

            if( FRand() < 0.5 )
            {
                RandPitch *= -1.0;
            }
        }

        Weapon.PlayOwnedSound(FireSound,SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,(1.0 + RandPitch),false);
    }
    ClientPlayForceFeedback(FireForce);  // jdf

    FireCount++;
}

defaultproperties
{
     FireAimedAnim="Fire_Iron"
	 FireAnim="Fire"
	 FireRate=1.633333
     AmmoClass=Class'SniperNagantAmmo'
}
