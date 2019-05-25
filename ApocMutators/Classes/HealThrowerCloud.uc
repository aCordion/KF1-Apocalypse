class HealThrowerCloud extends Nade;

var Emitter PuffCloud;

var()   int     HealBoostAmount;// How much we heal a player by default with the medic nade
var     int     TotalHeals;     // The total number of times this nade has healed (or hurt enemies)
var()   int     MaxHeals;       // The total number of times this nade will heal (or hurt enemies) until its done healing
var     float   NextHealTime;   // The next time that this nade will heal friendlies or hurt enemies
var()   float   HealInterval;   // How often to do healing
var()   sound   ExplosionSound; // The sound of the rocket exploding
var localized   string  SuccessfulHealMessage;
var 	int		MaxNumberOfPlayers;
var     bool    bNeedToPlayEffects; // Whether or not effects have been played yet

replication
{
    reliable if (Role==ROLE_Authority)
        bNeedToPlayEffects;
}

simulated function PostBeginPlay()
{
	SetTimer(0.2, true);

	Velocity = Speed * Vector(Rotation);

	if ( Level.NetMode != NM_DedicatedServer )
	{
		if ( !PhysicsVolume.bWaterVolume )
		{
			PuffCloud = Spawn(Class'HealThrowerCloudEmitter',self);
		}
	}
}

simulated function PostNetReceive()
{
    super.PostNetReceive();
    if( !bHasExploded && bNeedToPlayEffects )
    {
        bNeedToPlayEffects = false;
        Explode(Location, vect(0,0,1));
    }
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
	if ( Other == none )
		return;

	if (!Other.IsA('PhysicsVolume') && !Other.IsA('Projectile')
           && !Other.IsA('ROBulletWhipAttachment')  )
    {
        if ( KFPawn(Other) != none && KFPawn(Other).BurnDown > 1 )
            KFPawn(Other).BurnDown /= 2;
		HealOrHurt(Damage,DamageRadius, MyDamageType, MomentumTransfer, HitLocation);
	}

	Explode(Location, vect(0,0,1));
}

function Timer()
{
	Destroy();
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	SetPhysics(PHYS_None);
	Spawn(Class'HealThrowerCloudImpact',,, HitLocation, rotator(HitNormal));
	if ( PuffCloud != none )
	{
		PuffCloud.Kill();
	}

	AmbientSound=none;
	Destroy();
}

simulated function Destroyed()
{ //Emptied to keep recursive Destroy-Explode-Destroy loops
}

function HealOrHurt(float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation)
{
	local actor Victims;
	local float damageScale;
	local vector dir;
	local int NumKilled;
	local KFMonster KFMonsterVictim;
	local Pawn P;
	local KFPawn KFP;
	local array<Pawn> CheckedPawns;
	local int i;
	local bool bAlreadyChecked;
	local KFPlayerReplicationInfo PRI;
	local int MedicReward;
	local float HealSum; // for modifying based on perks
	local int PlayersHealed;

	if ( bHurtEntry )
		return;

    NextHealTime = Level.TimeSeconds + HealInterval;

	bHurtEntry = true;

	foreach CollidingActors (class 'Actor', Victims, DamageRadius, HitLocation)
	{
		if( (Victims != self) && (Hurtwall != Victims) && (Victims.Role == ROLE_Authority) && !Victims.IsA('FluidSurfaceInfo')
		 && ExtendedZCollision(Victims)==None )
		{
			if( (Instigator==None || Instigator.Health<=0) && KFPawn(Victims)!=None )
				Continue;

			damageScale = 1.0;

			if ( Instigator == None || Instigator.Controller == None )
			{
				Victims.SetDelayedDamageInstigatorController( InstigatorController );
			}

			P = Pawn(Victims);

			if( P != none )
			{
		        for (i = 0; i < CheckedPawns.Length; i++)
				{
		        	if (CheckedPawns[i] == P)
					{
						bAlreadyChecked = true;
						break;
					}
				}

				if( bAlreadyChecked )
				{
					bAlreadyChecked = false;
					P = none;
					continue;
				}

                KFMonsterVictim = KFMonster(Victims);

    			if( KFMonsterVictim != none && KFMonsterVictim.Health <= 0 )
    			{
                    KFMonsterVictim = none;
    			}

                KFP = KFPawn(Victims);

                if( KFMonsterVictim != none )
                {
                    damageScale *= KFMonsterVictim.GetExposureTo(Location + 15 * -Normal(PhysicsVolume.Gravity));
                }
                else if( KFP != none )
                {
				    damageScale *= KFP.GetExposureTo(Location + 15 * -Normal(PhysicsVolume.Gravity));
                }

				CheckedPawns[CheckedPawns.Length] = P;

				if ( damageScale <= 0)
				{
					P = none;
					continue;
				}
				else
				{
					P = none;
				}
			}
			else
			{
                continue;
			}

            if( KFP == none )
            {

    			if( Pawn(Victims) != none && Pawn(Victims).Health > 0 )
    			{
                    Victims.TakeDamage(damageScale * DamageAmount,Instigator,Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius)
        			 * dir,(damageScale * Momentum * dir),DamageType);

        			if( Role == ROLE_Authority && KFMonsterVictim != none && KFMonsterVictim.Health <= 0 )
                    {
                        NumKilled++;
                    }
                }
			}
			else
			{
                if( Instigator != none && KFP.Health > 0 && KFP.Health < KFP.HealthMax )
                {
	                if ( KFP.bCanBeHealed )
					{
						PlayersHealed += 1;
	            		MedicReward = HealBoostAmount;

	            		PRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);

	            		if ( PRI != none && PRI.ClientVeteranSkill != none )
	            		{
	            			MedicReward *= PRI.ClientVeteranSkill.Static.GetHealPotency(PRI);
	            		}

	                    HealSum = MedicReward;

	            		if ( (KFP.Health + KFP.healthToGive + MedicReward) > KFP.HealthMax )
	            		{
	                        MedicReward = KFP.HealthMax - (KFP.Health + KFP.healthToGive);
	            			if ( MedicReward < 0 )
	            			{
	            				MedicReward = 0;
	            			}
	            		}

	                    KFP.GiveHealth(HealSum, KFP.HealthMax);

	             		if ( PRI != None )
	            		{
	            			if ( MedicReward > 0 && KFSteamStatsAndAchievements(PRI.SteamStatsAndAchievements) != none )
	            			{
	            				KFSteamStatsAndAchievements(PRI.SteamStatsAndAchievements).AddDamageHealed(MedicReward, false, true);
	            			}

	            			MedicReward = int((FMin(float(MedicReward),KFP.HealthMax)/KFP.HealthMax) * 60);

	            			PRI.ReceiveRewardForHealing( MedicReward, KFP );

	            			if ( KFHumanPawn(Instigator) != none )
	            			{
	            				KFHumanPawn(Instigator).AlphaAmount = 255;
	            			}

	                        if( PlayerController(Instigator.Controller) != none )
	                        {
	                            PlayerController(Instigator.Controller).ClientMessage(SuccessfulHealMessage$KFP.GetPlayerName(), 'CriticalEvent');
	                        }
	            		}
            		}
                }
			}

			KFP = none;
        }
	}

	bHurtEntry = false;
}

function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
{ //LOL nope
}

simulated singular function HitWall(vector HitNormal, actor Wall)
{
	Explode(Location + ExploWallOut * HitNormal, HitNormal);
}

function Tick( float DeltaTime )
{
    if( Role < ROLE_Authority )
    {
        return;
    }

    if( TotalHeals < MaxHeals && NextHealTime > 0 &&  NextHealTime < Level.TimeSeconds )
    {
        TotalHeals += 1;

        HealOrHurt(Damage,DamageRadius, MyDamageType, MomentumTransfer, Location);

        if( TotalHeals >= MaxHeals )
        {
            AmbientSound=none;
        }
    }
}

defaultproperties
{
    Speed=2200 //1600
    MaxSpeed=2500 //1800
	Physics=PHYS_Falling

	HealBoostAmount=3
	DamageRadius=175 //Radius of the heal effect- keep it small
    Damage=5
	MyDamageType=Class'DamTypeMedicNade'
	HealInterval=1
	MaxHeals=1
	DrawScale=2 //1.0 //Maybe make this larger so the invisible mesh hits better? Try in WiPv4
	ImpactSound=none
	ExplosionDecal=none
	StaticMesh=none
    ExplosionSound=none
	AmbientSound=Sound'Inf_WeaponsTwo.smoke_loop'
	SoundVolume=150
	SoundRadius=100
	TransientSoundVolume=2.0
	TransientSoundRadius=200
	bFullVolume=false
    DisintegrateSound=none
    SuccessfulHealMessage="You healed "
	MaxNumberOfPlayers=1
}
