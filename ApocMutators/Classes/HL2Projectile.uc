Class HL2Projectile extends Projectile
	Abstract;

simulated final function PlayStereoSound( vector Pos, Sound Snd, float Volume, float Radius, float Pitch )
{
	local PlayerController PC;
	local float Dist;

	if( Level.NetMode==NM_DedicatedServer )
		return;
	PC = Level.GetLocalPlayerController();
	if( PC!=None )
	{
		Dist = VSizeSquared(PC.CalcViewLocation-Pos);
		Radius = Square(Radius);
		if( Dist<Radius )
		{
			if( !FastTrace(PC.CalcViewLocation,Pos) )
				Volume*=0.4;
			PlaySound(Snd,SLOT_None,(1.f-(Dist/Radius))*Volume,,800000.f,Pitch,false);
		}
	}
}

simulated function HurtRadius( float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation )
{
	local Actor Victims;
	local float damageScale, dist;
	local vector dir;
	local int NumKilled;
	local KFMonster KFMonsterVictim;
	local KFPawn KFP;

	if ( bHurtEntry )
		return;

	bHurtEntry = true;

	foreach CollidingActors (class 'Actor', Victims, DamageRadius, HitLocation)
	{
		// don't let blast damage affect fluid - VisibleCollisingActors doesn't really work for them - jag
		if( (Victims != self) && (Hurtwall != Victims) && (Victims.Role == ROLE_Authority) && !Victims.IsA('FluidSurfaceInfo')
		 && ExtendedZCollision(Victims)==None )
		{
			if( (Instigator==None || Instigator.Health<=0) && KFPawn(Victims)!=None )
				Continue;
			dir = Victims.Location - HitLocation;
			dist = FMax(1,VSize(dir));
			dir = dir/dist;
			damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius);

			if ( Instigator == None || Instigator.Controller == None )
				Victims.SetDelayedDamageInstigatorController( InstigatorController );

			if( Pawn(Victims)!=None )
			{
                KFP = KFPawn(Victims);
				KFMonsterVictim = KFMonster(Victims);
				
				if( KFMonsterVictim!=None && KFMonsterVictim.Health <= 0 )
                    KFMonsterVictim = None;
                if( KFMonsterVictim!=None )
                    damageScale *= KFMonsterVictim.GetExposureTo(Location + 5 * -Normal(PhysicsVolume.Gravity));
                else if( KFP!=None )
				    damageScale *= (KFP.GetExposureTo(Location + 5 * -Normal(PhysicsVolume.Gravity))*0.25);

				if ( damageScale <= 0)
					continue;
			}
			else KFMonsterVictim = None;

			Victims.TakeDamage(damageScale * DamageAmount,Instigator,Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius)
			 * dir,(damageScale * Momentum * dir),DamageType);

			if( Role==ROLE_Authority && KFMonsterVictim!=none && KFMonsterVictim.Health<=0 )
                NumKilled++;

			if (Vehicle(Victims) != None && Vehicle(Victims).Health > 0)
				Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, InstigatorController, DamageType, Momentum, HitLocation);
        }
	}

	if( Role == ROLE_Authority )
	{
		if ( NumKilled >= 4 )
			KFGameType(Level.Game).DramaticEvent(0.05);
		else if ( NumKilled >= 2 )
			KFGameType(Level.Game).DramaticEvent(0.03);
	}
	bHurtEntry = false;
}

defaultproperties
{
     bBlockHitPointTraces=False
}
