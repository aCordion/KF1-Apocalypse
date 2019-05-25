class WTFEquipFireAxeFireB extends AxeFireB;

simulated function Timer()
{
	local Actor HitActor;
	local vector StartTrace, EndTrace, HitLocation, HitNormal;
	local rotator PointRot;
	local int MyDamage;
	local KFPlayerReplicationInfo KFPRI;

	if (!KFWeapon(Weapon).bNoHit)
	{
		hitDamageClass=Class'KFMod.DamTypeAxe'; // set back to default in case it was changed by a firebug doing a death from above attack :P
		MyDamage = MeleeDamage;
		StartTrace = Instigator.Location + Instigator.EyePosition();

		if (Instigator.Controller != None && PlayerController(Instigator.Controller) == None && Instigator.Controller.Enemy != None)
		{
			PointRot = rotator(Instigator.Controller.Enemy.Location-StartTrace); // Give aimbot for bots.
		}
		else
		{
			PointRot = Instigator.GetViewRotation();
		}

		EndTrace = StartTrace + vector(PointRot) * weaponRange;
		HitActor = Instigator.Trace(HitLocation, HitNormal, EndTrace, StartTrace, true);

		if (HitActor != None)
		{
			ImpactShakeView();

			if (HitActor.IsA('ExtendedZCollision') && HitActor.Base != none &&
				HitActor.Base.IsA('KFMonster'))
			{
				HitActor = HitActor.Base;
			}

			if ((HitActor.IsA('KFMonster') || HitActor.IsA('KFHumanPawn')) && KFMeleeGun(Weapon).BloodyMaterial != none)
			{
				Weapon.Skins[KFMeleeGun(Weapon).BloodSkinSwitchArray] = KFMeleeGun(Weapon).BloodyMaterial;
				Weapon.texture = Weapon.default.Texture;
			}

			if ((KFMonster(HitActor) != none))
			{
				KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);

				 //special fx; happens on clients and listen server host
				if (Level.NetMode != NM_DedicatedServer)
				{
					if (Instigator.Velocity.Z < 0)
					{
						if (KFPRI != none)
						{
							if (KFPRI.ClientVeteranSkill == Class'SRVetFirebug')
								Weapon.PlayOwnedSound(Sound'KF_EnemiesFinalSnd.Husk.Husk_FireImpact', SLOT_Interact, 2.0, , 500.0, , false);
							else if (KFPRI.ClientVeteranSkill == Class'SRVetBerserker')
								Spawn(Class'WTFEquipChainsawBloodExplosion', Instigator, , HitLocation, rotator(HitLocation - StartTrace));
						}
					}
				}

				 //only server deals the damage
				if (Level.NetMode == NM_Client)
				{
					Return;
				}

				if (HitActor.IsA('Pawn') && !HitActor.IsA('Vehicle')
				 && (Normal(HitActor.Location-Instigator.Location) dot vector(HitActor.Rotation)) < 0)
				{
					MyDamage *= 2; // Backstab > :P
				}

				if (Instigator.Velocity.Z < 0)
				{
					if (KFPRI != None)
					{
						if (KFPRI.ClientVeteranSkill == Class'SRVetBerserker')
							MyDamage *= 1.15; // bonus damage for falling strike
						else if (KFPRI.ClientVeteranSkill == Class'SRVetFirebug')
							HitActor.TakeDamage(MyDamage * 0.5, Instigator, HitLocation, vector(PointRot), Class'KFMod.DamTypeBurned');
					}
				}

				HitActor.TakeDamage(MyDamage, Instigator, HitLocation, vector(PointRot), hitDamageClass);

				if (MeleeHitSounds.Length > 0)
				{
					Weapon.PlaySound(MeleeHitSounds[Rand(MeleeHitSounds.length)], SLOT_None, MeleeHitVolume, , , , false);
				}

				if (VSize(Instigator.Velocity) > 300 && KFMonster(HitActor).Mass <= Instigator.Mass)
				{
					KFMonster(HitActor).FlipOver();
				}

			}
			else
			{
				HitActor.TakeDamage(MyDamage, Instigator, HitLocation, vector(PointRot), hitDamageClass) ;
				Spawn(HitEffectClass, , , HitLocation, rotator(HitLocation - StartTrace));
				 //if (KFWeaponAttachment(Weapon.ThirdPersonActor) != None)
				//  KFWeaponAttachment(Weapon.ThirdPersonActor).UpdateHit(HitActor, HitLocation, HitNormal);

			   // Weapon.IncrementFlashCount(ThisModeNum);
			}
		}
	}
}

defaultproperties
{
}
