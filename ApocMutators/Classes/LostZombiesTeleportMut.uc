class LostZombiesTeleportMut extends Mutator
	config(ApocMutators);

var config int secondsToWait;
var int lastMonsterKilledTime;
var int monsterCount;

function MatchStarting()
{
	SetTimer(5, true);
}

function Timer()
{
	local KFMonster KFM;
	local vector newSpawnLoc;
	local int teleportCounter;
	local bool teleported;

	if(KFGameType(Level.Game).bWaveBossInProgress)
		return;

	if(!KFGameType(Level.Game).bWaveInProgress)
	{
		monsterCount=0;
		lastMonsterKilledTime=Level.TimeSeconds;
		return;
	}

	if(monsterCount!=KFGameReplicationInfo(Level.Game.GameReplicationInfo).MaxMonsters)
	{
		monsterCount=KFGameReplicationInfo(Level.Game.GameReplicationInfo).MaxMonsters;
		lastMonsterKilledTime=Level.TimeSeconds;
	}

	if (Level.TimeSeconds-lastMonsterKilledTime>secondsToWait)
	{
		foreach AllActors(Class'KFMonster', KFM)
		{
			for(teleportCounter=0;teleportCounter<20;teleportCounter++)
			{
				newSpawnLoc=GetSpawnLocation();
				teleported=Teleport(KFM,newSpawnLoc);
				if(teleported) break;
			}
			if(!teleported)
			{
				KFM.TakeDamage(1000000,KFM,KFM.Location,vect(0,0,0),Class'DamTypeBleedOut');
			}

			lastMonsterKilledTime=Level.TimeSeconds;
		}
	}
}

function vector RandomizeLocation(vector location)
{
	local vector newLoc;
	local int randInt;
	randInt=Rand(4);
	if (randInt==0)
		newLoc=location+vect(-1,0,0) * 400;
	else if(randInt==1)
		newLoc=location+vect(1,0,0) * 400;
	else if(randInt==2)
		newLoc=location+vect(0,-1,0) * 400;
	else
		newLoc=location+vect(0,1,0) * 400;
	return newLoc;
}

function vector GetSpawnLocation()
{
	local ZombieVolume zv;
	local int volumeListLength;
	local int randVolume;
	volumeListLength=KFGameType(Level.Game).ZedSpawnList.Length;
	randVolume=Rand(volumeListLength);
	zv=KFGameType(Level.Game).ZedSpawnList[randVolume];
	return RandomizeLocation(zv.Location);
}

function bool Teleport(KFMonster KFM, vector newSpawnLoc)
{
	if (KFM.SetLocation(newSpawnLoc))
	{
		KFM.SetPhysics(PHYS_Walking);
		if (KFM.Controller.PointReachable(newSpawnLoc))
		{
			KFM.Velocity = vect(0, 0, 0);
			KFM.Acceleration = vect(0, 0, 0);
			KFM.SetRotation(rotator(newSpawnLoc - KFM.Location));
			KFM.Controller.GotoState('');
			MonsterController(KFM.Controller).WhatToDoNext(0);
		}
	}

	if(VSizeSq(KFM.Location-newSpawnLoc)<100)
	{
		return true;
	}
	return false;
}

static final function float VSizeSq(vector A)
{
	return Sqrt( Square(A.X) + Square(A.Y) + Square(A.Z) );
}

defaultproperties
{
	 secondsToWait=60
	 bAddToServerPackages=True
	 GroupName="LostZombiesTeleportMut"
	 FriendlyName="LostZombiesTeleportMut"
	 Description="Teleports lost zombies to zombie volumes"
}
