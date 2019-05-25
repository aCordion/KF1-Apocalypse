class AutoRespawnMut extends Mutator
	config(ApocMutators);

struct PlayerSpawnInfo
{
	var string				Hash;
	var KFPlayerController	PC;
	var float				DeadTime;
	var float				RespawnTimeoutMsgTime;	
	var float				RespawnMsgDelay;
	var bool				bCanRemove;
	var int					nViewRestore;
};

struct PlayerInfo
{
	var vector Location;
	var rotator Rotation;
	var int HP;
	var Controller C;
};

var() globalconfig localized string WaitToRespawnMsg,RespawnTresholdMsg,BroadcastPlayerRespawnedMsg,DisabledWaveMsg;
var array<PlayerSpawnInfo> PlayerDB;
var() globalconfig int RespawnTimeout;
var() globalconfig array<int> DisabledWaves;
var() globalconfig float RespawnLiveToDeathTreshold;
var float bLiveToDeathTresholdMsgNext, bDisabledWaveMsgNext;
var float timerPrecision;
var int nViewRestoreTryes;

function PostBeginPlay()
{
	SetTimer(timerPrecision, true);
	SaveConfig();
}

function bool bAlreadyWaitRespawn(KFPlayerController PC)
{
	local int i;
	
	if (PC==none)
	{		
		return false;
	}
	for (i = 0; i < PlayerDB.Length; i++)
	{
		if (PlayerDB[i].Hash==PC.GetPlayerIDHash())
			return true;
	}
	return false;
}

function RestoreView(PlayerController C)
{
	if( C.Pawn!=None )
	{
		C.SetViewTarget(C.Pawn);
		C.ClientSetViewTarget(C.Pawn);
	}
	else
	{
		C.SetViewTarget(C);
		C.ClientSetViewTarget(C);
	}
	C.bBehindView = False;
	C.ClientSetBehindView(False);
	return;
}

function PlayerInfo FindBestPlayer(PlayerController PC)
{
	local Controller C;
	local KFPlayerReplicationInfo KFPRI;
	local PlayerInfo BestPlayer;

	for( C = Level.ControllerList; C != None; C = C.nextController )
	{
		if ( !C.IsA('KFPlayerController') && !C.IsA('KFInvBots') ) 
			continue; 
		if (C.Pawn==none) continue;
			KFPRI=KFPlayerReplicationInfo(C.PlayerReplicationInfo);
		if (KFPRI==none) 
			continue;
		if (PC==C) 
			continue;
		
		if( C.Pawn.Health+C.Pawn.ShieldStrength > BestPlayer.HP )
		{
			BestPlayer.Location	= C.Pawn.GetTargetLocation();
			BestPlayer.Rotation	= C.Pawn.GetViewRotation();
			BestPlayer.HP		= C.Pawn.Health+C.Pawn.ShieldStrength;
			BestPlayer.C		= C;
		}
	}
	return BestPlayer;
}

function ReSpawnRoutine(PlayerController C)
{
	local PlayerInfo BestPlayer;
	local vector	SpawnLocation;
	local rotator	SpawnRotation;
	if (C==none) return; if (C.Pawn!=none) return;
	if (KFPlayerReplicationInfo(C.PlayerReplicationInfo)==none) return;
	if (C.PlayerReplicationInfo == None 
	|| C.PlayerReplicationInfo.bOnlySpectator
	|| !C.PlayerReplicationInfo.bOutOfLives
	|| KFPlayerReplicationInfo(C.PlayerReplicationInfo).PlayerHealth>0)
		return;
	Level.Game.Disable('Timer');
	C.PlayerReplicationInfo.bOutOfLives = false;
	C.PlayerReplicationInfo.NumLives = 0;
	C.PlayerReplicationInfo.Score = Max(KFGameType(Level.Game).MinRespawnCash, int(C.PlayerReplicationInfo.Score));
	C.GotoState('PlayerWaiting');
	
	C.SetViewTarget(C);
	C.ClientSetBehindView(false);
	C.bBehindView = False;
	C.ClientSetViewTarget(C.Pawn);
	
	Invasion(Level.Game).bWaveInProgress = false;
	C.ServerReStartPlayer();
	C.bGodMode = true;
	Invasion(Level.Game).bWaveInProgress = true;
	
	BestPlayer = FindBestPlayer(C);
	if( BestPlayer.Location.x		!= 0
		|| BestPlayer.Location.y	!= 0
		|| BestPlayer.Location.z	!= 0 )
	{
		SpawnLocation = BestPlayer.Location;
		SpawnRotation = BestPlayer.Rotation; 
		SpawnRotation.Pitch+=32768;
		C.Pawn.bBlockActors = false;
		C.Pawn.SetRotation(SpawnRotation);
		C.Pawn.ClientSetRotation(SpawnRotation);
		C.Pawn.SetLocation(SpawnLocation); 
		C.Pawn.ClientSetLocation(SpawnLocation,SpawnRotation);
		C.Pawn.SetPhysics(PHYS_Falling);
		C.Pawn.Velocity.X += 15;
		C.Pawn.Velocity.Y += 15;
		C.Pawn.Velocity.Z += 30;
		C.Pawn.Acceleration = vect(15,15,30);
		C.Pawn.bBlockActors = true;
	}
	
	RestoreViews();
	
	Level.Game.Enable('Timer');
	
	if (BestPlayer.C!=none)
	{		
		Level.Game.Broadcast(Self,Repl(BroadcastPlayerRespawnedMsg,"%player%",C.PlayerReplicationInfo.PlayerName)@BestPlayer.C.PlayerReplicationInfo.PlayerName);
	}
	else
	{
		Level.Game.Broadcast(Self,Repl(BroadcastPlayerRespawnedMsg,"%player%",C.PlayerReplicationInfo.PlayerName));
	}
}

function AddToWaitRespawn(KFPlayerController PC)
{
	if (PC==none)
		return;
	
	PlayerDB.Insert(0,1);
	PlayerDB[0].Hash = PC.GetPlayerIDHash();
	PlayerDB[0].PC = PC;
	PlayerDB[0].DeadTime = Level.TimeSeconds;
	PlayerDB[0].bCanRemove = false;
	PlayerDB[0].nViewRestore = 0;	
}

function int RoundMy(int input, int div)
{
	local int t;
	t=input/div;
	return t * div;
}

function int RoundMy2(float input, float div)
{
	return int(Round(input/div) * div);
}

function bool ShowMsg(KFPlayerController PC, string Msg, int i)
{
	//PC.ClientMessage(Msg);
	PC.ReceiveLocalizedMessage(Class'AutoRespawnMessage',i,,,);
	return true;
}

function bool Between(float a, float b, float c)
{
	return (a>=b && a<c);
}

function ShowWaitToRespawnMsg(int i)
{
	local float rDelay;
	local bool bMsgShowed;
	local int t;
	if (PlayerDB[i].RespawnTimeoutMsgTime < Level.TimeSeconds)
	{
		
		rDelay = (PlayerDB[i].DeadTime + RespawnTimeout) - Level.TimeSeconds;
		
		if (PlayerDB[i].RespawnMsgDelay==0.0f)
		{
			t = RoundMy2(rDelay,1);
			bMsgShowed=ShowMsg( PlayerDB[i].PC, Repl(WaitToRespawnMsg,"%time%",RoundMy2(rDelay,1)),t );
			PlayerDB[i].RespawnMsgDelay=1;
		}
		if( rDelay > 60.0f
			&& rDelay - float(RoundMy(rDelay,30)) < timerPrecision
			&& PlayerDB[i].RespawnMsgDelay < Level.TimeSeconds )
		{
			if (!bMsgShowed)
				t = RoundMy2(rDelay,1);
				bMsgShowed=ShowMsg( PlayerDB[i].PC, Repl(WaitToRespawnMsg,"%time%",RoundMy2(rDelay,30)),t );
			PlayerDB[i].RespawnMsgDelay = Level.TimeSeconds + timerPrecision;
		}
		else if( Between(rDelay, 30.0f, 60.0f)
			&& rDelay - float(RoundMy(rDelay,10)) < timerPrecision
			&& PlayerDB[i].RespawnMsgDelay < Level.TimeSeconds )
		{
			if (!bMsgShowed)
				t = RoundMy2(rDelay,1);
				bMsgShowed=ShowMsg( PlayerDB[i].PC, Repl(WaitToRespawnMsg,"%time%",RoundMy2(rDelay,10)),t );
			PlayerDB[i].RespawnMsgDelay = Level.TimeSeconds + timerPrecision;
		}
		else if( Between(rDelay, 10.0f, 30.0f)
			&& rDelay - float(RoundMy(rDelay,5)) < timerPrecision
			&& PlayerDB[i].RespawnMsgDelay < Level.TimeSeconds )
		{
			if (!bMsgShowed)
				t = RoundMy2(rDelay,1);
				bMsgShowed=ShowMsg( PlayerDB[i].PC, Repl(WaitToRespawnMsg,"%time%",RoundMy2(rDelay,5)),t);
			PlayerDB[i].RespawnMsgDelay = Level.TimeSeconds + timerPrecision;
		}
		else if( rDelay < 10.0f
				 && rDelay - float(RoundMy(rDelay,1)) < timerPrecision
				 && PlayerDB[i].RespawnMsgDelay < Level.TimeSeconds )
		{
			if (!bMsgShowed && RoundMy2(rDelay,1) != 0)
				t = RoundMy2(rDelay,1);
				bMsgShowed=ShowMsg( PlayerDB[i].PC, Repl(WaitToRespawnMsg,"%time%",RoundMy2(rDelay,1)),t );
			PlayerDB[i].RespawnMsgDelay = Level.TimeSeconds + timerPrecision;
		}
	}
}

function RestoreViews()
{
	local int i;
	local KFPlayerReplicationInfo KFPRI;
	for (i = 0; i < PlayerDB.Length; i++)
	{		
		if (PlayerDB[i].PC==none)
		{
			PlayerDB[i].bCanRemove=true;
			continue;
		}
		KFPRI = KFPlayerReplicationInfo(PlayerDB[i].PC.PlayerReplicationInfo);
		if (KFPRI==none || PlayerDB[i].nViewRestore >= nViewRestoreTryes)
		{
			PlayerDB[i].bCanRemove=true;
			continue;
		}
		else if (!KFPRI.bOutOfLives && KFPRI.PlayerHealth>0
			&& PlayerDB[i].nViewRestore < nViewRestoreTryes
			&& !PlayerDB[i].bCanRemove)
		{
			RestoreView(PlayerDB[i].PC);
			PlayerDB[i].nViewRestore++;
			if (PlayerDB[i].nViewRestore>=8/timerPrecision)
			{
				PlayerDB[i].PC.bGodMode=false;
			}
		}
	}
}

function RespawnPlayers()
{
	local int i;
	for (i = 0; i < PlayerDB.Length; i++)
	{
		if (PlayerDB[i].PC==none)
		{
			PlayerDB.Remove(i, 1);
			i--;
		}
		else if (PlayerDB[i].nViewRestore == 0 && !PlayerDB[i].PC.PlayerReplicationInfo.bOutOfLives)
		{
			PlayerDB[i].PC.bGodMode=false;
			PlayerDB.Remove(i, 1);
			i--;			
		}
		else if( KFPlayerReplicationInfo(PlayerDB[i].PC.PlayerReplicationInfo)==none
				|| PlayerDB[i].bCanRemove )
		{
			PlayerDB[i].PC.bGodMode=false;
			PlayerDB.Remove(i, 1);
			i--;
		}
		else if (PlayerDB[i].DeadTime+RespawnTimeout < Level.TimeSeconds)
		{
			if (PlayerDB[i].PC!=none)
				ReSpawnRoutine(PlayerDB[i].PC);
			else	
				PlayerDB[i].bCanRemove=true;			
		}
		else if (PlayerDB[i].PC.PlayerReplicationInfo.bOutOfLives && !PlayerDB[i].bCanRemove)
		{
			ShowWaitToRespawnMsg(i);		
		}
	}
}

function Timer()
{
	local Controller C;
	local KFPlayerController PC;
	local KFPlayerReplicationInfo KFPRI;
	local bool bLiveToDeathTreshold, bDisabledWave;
	local int i;

	if (Level.Game.bGameEnded)
		return;
	
	RestoreViews();
	
	if (GetNPlayersLive()/GetNPlayersAll() < RespawnLiveToDeathTreshold)
		bLiveToDeathTreshold=true;
	else
		bLiveToDeathTreshold=false;
	
	for(i=0;i<DisabledWaves.Length;i++)
	{
		if (DisabledWaves[i]==(InvasionGameReplicationInfo(Level.Game.GameReplicationInfo).WaveNumber + 1))
		{
			bDisabledWave=true;
			break;
		}
		else
			bDisabledWave=false;
	}
	
	if(!bLiveToDeathTreshold && !bDisabledWave)
	{
		for( C = Level.ControllerList; C != None; C = C.nextController )
		{
			PC = KFPlayerController(C);
			if (PC==none)
				continue;

			KFPRI = KFPlayerReplicationInfo(PC.PlayerReplicationInfo);

			if( KFPRI==none
				|| !KFPRI.bOutOfLives
				|| KFPRI.PlayerHealth > 0
				|| KFPRI.bOnlySpectator )
				continue;

			if (bAlreadyWaitRespawn(PC))
				continue;
		
			AddToWaitRespawn(PC);
		}
	}	
		
	if(bDisabledWave)
	{
		if ( bDisabledWaveMsgNext < Level.TimeSeconds && Invasion(Level.Game).bWaveInProgress )
		{
			bDisabledWaveMsgNext=Level.TimeSeconds+20;
			Level.Game.Broadcast(Self,DisabledWaveMsg);
		}
	}
		
	if (bLiveToDeathTreshold)
	{
		if ( bLiveToDeathTresholdMsgNext < Level.TimeSeconds && Invasion(Level.Game).bWaveInProgress )
		{
			bLiveToDeathTresholdMsgNext=Level.TimeSeconds+20;
			Level.Game.Broadcast(Self,RespawnTresholdMsg);
		}
	}
	else
		bLiveToDeathTresholdMsgNext=0;
		
		if( !bLiveToDeathTreshold && !bDisabledWave
		&& Invasion(Level.Game).bWaveInProgress==true )
	{
		RespawnPlayers();
	}
}

function float GetNPlayersLive()
{
	local int NumPlayers;
	local Controller C;
	local KFPlayerReplicationInfo KFPRI;
	local KFPlayerController KFPC;
	For( C=Level.ControllerList; C!=None; C=C.NextController )
	{
		KFPC=KFPlayerController(C);
		if (KFPC==none)
			continue;
		KFPRI=KFPlayerReplicationInfo(KFPC.PlayerReplicationInfo);
		if (KFPRI==none)
			continue;
			
		if( C.bIsPlayer && KFPRI.PlayerHealth>0 && !KFPRI.bOutOfLives )
		{
			NumPlayers++;
		}
	}
	return NumPlayers;
}

function float GetNPlayersAll()
{
	local int NumPlayers;
	local Controller C;
	For( C=Level.ControllerList; C!=None; C=C.NextController )
	{
		if( C.bIsPlayer )
		{
			NumPlayers++;
		}
	}
	return NumPlayers;
}

static function FillPlayInfo(PlayInfo PlayInfo)
{
	Super.FillPlayInfo(PlayInfo);
	PlayInfo.AddSetting(default.RulesGroup, "RespawnTimeout", "Time for respawn", 0, 1, "Text", "8;0:50000");
}

static event string GetDescriptionText(string PropName)
{
	switch(PropName)
	{
		case "RespawnTimeout":
			return "Time players have to wait for respawn.";
	}
}

defaultproperties
{
     WaitToRespawnMsg="%time% seconds to respawn"
     RespawnTresholdMsg="Auto respawn was turned off because of too litle alive players"
     BroadcastPlayerRespawnedMsg="%player% spawns near"
     DisabledWaveMsg="Auto respawn was turned off on this wave by server administrator"
     RespawnTimeout=60
     DisabledWaves(0)=11
     RespawnLiveToDeathTreshold=-1.000000
     timerPrecision=0.500000
     nViewRestoreTryes=10
     GroupName="KF-AutoRespawnv2"
     FriendlyName="AutoRespawnV2"
     Description="Auto Respawn mutator v2 edited by jaarKIRA"
}
