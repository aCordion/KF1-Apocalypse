/*
Title:           AdminPlus_v3 Mutator for Killing Floor
Creator:         Rythmix@Gmail.com - 11/08/2004
				 ported to Killing Floor by    RED-FROG  Red_Frog@web.de   May 30th, 2009
WebSite:         http://rythmix.zclans.com
				 http://www.levels4you.com
Add'l Content:   Based off of the AdminCheats and AdminUtils
				 mutators by mkhaos7 and James M. Poore Jr.
Features:  		 TempAdmin, ChangeName, CustomLoaded1,2,3, Godon/off,
				 GiveItem, PlayerSize, HeadSize, SetGrav, PrivMessage,
				 Reset Score, Change Score, Ghost/Fly/Spider/Walk, Summon,
				 Advanced Summon, Loaded, DNO, SloMo, Teleport
				 Cause Event
				-----------------------------------------------------------
				 Partial Name Recognition, 'ALL' Names Recognition
				 Applicable functions Work with Spectators, SuperAdmin
*/
class AdminPlus extends Admin;

var localized string MSG_LoadedOn;
var localized string MSG_GodOn;
var localized string MSG_GodOff;
var localized string MSG_Ghost;
var localized string MSG_Fly;
var localized string MSG_ChangeScore;
var localized string MSG_Spider;
var localized string MSG_Walk;
var localized string MSG_InvisOn;
var localized string MSG_InvisOff;
var localized string MSG_TempAdmin;
var localized string MSG_TempAdminOff;
var localized string MSG_ChangeName;
var localized string MSG_ChangeSize;
var localized string MSG_GiveItem;
var localized string MSG_Adrenaline;
var localized string MSG_Help1;
var localized string MSG_Help2;
var localized string MSG_Help3;
var localized string MSG_Help4;
var localized string MSG_Help5;
var localized string MSG_Help6;
var localized string MSG_Help7;
var localized string MSG_Help8;
var localized string MSG_Help9;
var localized string MSG_Help10;
var localized string MSG_Help11;
var localized string MSG_Help12;
var localized string MSG_Help13;
var localized string MSG_Help14;
var localized string MSG_Help15;
var localized string MSG_Help16;
var localized string MSG_Help17;
var localized string MSG_Help18;
var localized string MSG_Help19;
var localized string MSG_Help20;
var localized string MSG_Help21;
var localized string MSG_Help22;
var localized string MSG_Help23;
var localized string MSG_Help24;
var localized string MSG_Help25;
var localized string MSG_Help26;
var localized string MSG_Help27;
var localized string MSG_Help28;
var localized string MSG_Help29;
var localized string MSG_Help30;
var localized string MSG_Help31;
var localized string MSG_Help32;
var localized string MSG_Help33;
var localized string MSG_Help34;
var localized string MSG_Help35;
var localized string MSG_ReSpawned;
var localized string MSG_CantRespawn;
var xEmitter LeftTrail, RightTrail, HeadTrail;
//var CrateActor Effect;
var int NumDoubles;
//var Bot Doubles[4];

//========================================================================================
// Really Crappy version of the admin.uc file to allow temp admins on single admin systems
//========================================================================================
function DoLogin( string Username, string Password )
{
	if (Level.Game.AccessControl.AdminLogin(Outer, Username, Password))
	{
		bAdmin = true;
		Level.Game.AccessControl.AdminEntered(Outer, "");
	}

	if ( outer.playerreplicationinfo.badmin == true && !Level.Game.AccessControl.AdminLogin(Outer, Username, Password))
	{
		Level.Game.AccessControl.AdminLogout(Outer);
		Level.Game.AccessControl.AdminLogin(outer, "ut2004", Level.Game.AccessControl.Users.Get(0).Password);
		Level.Game.AccessControl.AdminEntered(outer, "");
		bAdmin = true;
	 }

}

function DoLogout()
{
	if (Level.Game.AccessControl.AdminLogout(Outer))
	{
		bAdmin = false;
		Level.Game.AccessControl.AdminExited(Outer);
	}
}

//=======================================================
//finds the mutator of a given class starting from the given Mutator
//original text from admincheats
function Mutator findMut(Mutator M, class MC){
   if (M.Class ==  MC)
	  return M;
   else if (M != None)
			  return findMut(M.NextMutator,MC);
		else
			return None;
}

//Gives back the Pawn associated with a player name
function Pawn findPlayerByName(string PName){
	local Controller C;
	local int namematch;

	for( C = Level.ControllerList; C != None; C = C.nextController ) {
		if( C.IsA('PlayerController') || C.IsA('xBot')) {
			If (Len(C.PlayerReplicationInfo.PlayerName) >= 3 && Len(PName) < 3) {
				Log("Must be longer than 3 characters");
			} else {
				namematch = InStr( Caps(C.PlayerReplicationInfo.PlayerName), Caps(PName));
				if (namematch >=0) {
					return C.Pawn;
				}
			}
		}
	}
	return none;
}

//Verify that the target of our functions exists
//If no target is specified, apply the function to ourselves
//original text from admincheats
function Pawn verifyTarget(string target) {
	local Pawn p;

	if (target == "")
	   return Pawn;
	else
	   p = findPlayerByName(target);
	   if (p == None)
		  ClientMessage(target $" is not currently in the game." );
	   return p;
}

//Verify that the target of our functions exists
//If no target is specified, apply the function to ourselves
//original text from admincheats
function Controller verifyCont(string target) {
	local Controller C;
	local int namematch;

	if (target == ""){
	   return c;
	}else{
		for( C = Level.ControllerList; C != None; C = C.nextController ) {
			if( C.IsA('PlayerController') || C.IsA('xBot')) {
				namematch = InStr( Caps(C.PlayerReplicationInfo.PlayerName), Caps(target));
				if (namematch < 0) {
					ClientMessage(target $" is not currently in the game." );
					return C;
				}
			}
		}
	}
}

//================================================
//Make Target a Temp Admin
exec function TempAdmin(string target){
	local Mutator myMut;
	local Controller C;
	local int namematch;
	local Pawn p;

	myMut = findMut(Level.Game.BaseMutator, class'AdminPlusMut');

	if (myMut != none) {
		if (AdminPlusMut(myMut).TempAdminEnabled()) {

			if (target == "all") {
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController') || C.IsA('xBot')) {
						if (C.playerreplicationinfo.bAdmin != TRUE){
							PlayerController(C).ClientMessage(MSG_TempAdmin);
							C.playerreplicationinfo.bAdmin = true;
							if (pawn != none){
								C.Pawn.PlayTeleportEffect(true, true);
							}
						}
					}
				}
				return;
			} else if (target == ""){
				P = verifyTarget(target);
				P.ClientMessage(MSG_TempAdmin);
				P.PlayTeleportEffect(true, true);
				p.playerreplicationinfo.bAdmin = true;
				return;
			} else {

				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController') || C.IsA('xBot')) {
						namematch = InStr( Caps(C.PlayerReplicationInfo.PlayerName), Caps(target));
						if (namematch >=0) {
							PlayerController(C).ClientMessage(MSG_TempAdmin);
							C.playerreplicationinfo.bAdmin = true;
							if (pawn != none){
								C.Pawn.PlayTeleportEffect(true, true);
							}
						}
					}
				}
				return;
			}
		}
	}
}

//================================================
//Remove Target Temp Admin abilities
exec function TempAdminOff(string target){
	local Mutator myMut;
	local Controller C;
	local string A;
	local int i;
	local int namematch;
	local int adminmatch;
	local Pawn p;

	myMut = findMut(Level.Game.BaseMutator, class'AdminPlusMut');
	if (myMut != none) {
		if (AdminPlusMut(myMut).TempAdminEnabled()) {

			if (target == "all") {
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController') || C.IsA('xBot')) {
						for (i = 0; i < class'AdminPlusMut'.default.SuperAdmin.Length; i++) {
							A = (class'AdminPlusMut'.default.SuperAdmin[i]);
							adminmatch = InStr( Caps(A), Caps(C.PlayerReplicationInfo.PlayerName));
							if (adminmatch >=0) {
								ClientMessage("~AdminPlus: Trying to Disable a SuperAdmin is not allowed");
							} else {
								PlayerController(C).ClientMessage(MSG_TempAdminOff);
								C.playerreplicationinfo.bAdmin = false;
								if (pawn != none){
								C.Pawn.PlayTeleportEffect(true, true);
								}
							}
						}
					}
				}
				return;
			} else if (target == ""){
				P = verifyTarget(target);
				P.ClientMessage("Use AdminLogout to exit Admin mode");
				//P.playerreplicationinfo.bAdmin = false;
				return;
			} else {
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController') || C.IsA('xBot')) {
						namematch = InStr( Caps(C.PlayerReplicationInfo.PlayerName), Caps(target));
						if (namematch >=0) {
							for (i = 0; i < class'AdminPlusMut'.default.SuperAdmin.Length; i++) {
								A = (class'AdminPlusMut'.default.SuperAdmin[i]);
								adminmatch = InStr( Caps(A), Caps(C.PlayerReplicationInfo.PlayerName));
								if (adminmatch >=0) {
									ClientMessage("~AdminPlus: Trying to Disable a SuperAdmin is not allowed!");
									//return;
								}
							}
							PlayerController(C).ClientMessage(MSG_TempAdminOff);
							C.playerreplicationinfo.bAdmin = false;
							if (pawn != none){
								C.Pawn.PlayTeleportEffect(true, true);
							}
						}
					}
				}
			}
	}
	}
}

//Slap that guys bothering you and do 1 point of damage from him
exec function Slap(string target){
	local Mutator myMut;
	local Pawn p;
	local Controller C;
	//local int i;
	local int namematch;
	local int iSlapDmg;
	//local int iMom;

	myMut = findMut(Level.Game.BaseMutator, class'AdminPlusMut');
	if(myMut != none) {
		if (AdminPlusMut(myMut).SlapEnabled()) {
			iSlapDmg = (class'AdminPlusMut'.default.iSlapDamage);
			//iMom = (class'AdminPlusMut'.default.iMomentum);
			if (target == "all") {
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController') || C.IsA('xBot')) {
						C.Pawn.ClientMessage("You've been Pimp slapped");
						ServerSay(Pawn.PlayerReplicationInfo.PlayerName$ " PimpSlaps " $ C.PlayerReplicationInfo.PlayerName $ " like a bitch!");
						//Slap... but don't kill
						if (C.Pawn.Health > 1){
							C.Pawn.TakeDamage(iSlapDmg,Pawn,Vect(100000,100000,100000),Vect(100000,100000,100000),class'DamageType');
							C.Pawn.PlayTeleportEffect(true, true);
						}
					}
				}
				return;
			} else if (target == ""){
				P = verifyTarget(target);
				P.ClientMessage("You've been Pimp slapped!");
				ServerSay(Pawn.PlayerReplicationInfo.PlayerName$ " PimpSlaps Himself like a bitch!");
				//Slap... but don't kill
				if (P.Health > 1){
					P.TakeDamage(iSlapDmg,Pawn,Vect(100000,100000,100000),Vect(100000,100000,100000),class'DamageType');
					P.PlayTeleportEffect(true, true);
				}
				return;
			} else {
				P = verifyTarget(target);
				if (P == none){
					return;
				}
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController') || C.IsA('xBot')) {
						namematch = InStr( Caps(C.PlayerReplicationInfo.PlayerName), Caps(target));
						if (namematch >=0) {
							C.Pawn.ClientMessage("You've been Pimp slapped!");
							ServerSay(Pawn.PlayerReplicationInfo.PlayerName$ " PimpSlaps " $ C.Pawn.PlayerReplicationInfo.PlayerName $ " like a bitch!");
							//Slap... but don't kill
							if (C.Pawn.Health > 1){
								C.Pawn.TakeDamage(iSlapDmg,Pawn,Vect(100000,100000,100000),Vect(100000,100000,100000),class'DamageType');
								C.Pawn.PlayTeleportEffect(true, true);
							}
						}
					}
				}
			}
		}
	}
}

//================================================
//Change Player's Name
exec function ChangeName(string target, string NewName){
	local Mutator myMut;
	local Controller C;
	local int namematch;

	myMut = findMut(Level.Game.BaseMutator, class'AdminPlusMut');
	if (myMut != none) {
		if (AdminPlusMut(myMut).ChangeNameEnabled()) {
			if (NewName != ""){
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController') || C.IsA('xBot')) {
						namematch = InStr( Caps(C.PlayerReplicationInfo.PlayerName), Caps(target));
						if (namematch >=0) {
							PlayerController(C).ClientMessage(MSG_ChangeName);
							C.playerreplicationinfo.PlayerName = NewName;
						}
					}
				}
			} else {
				ClientMessage("You must enter a new name for the player");
			}
		}
	}
}
//Change Player's Name
//================================================
function ReSpawnRoutine(PlayerController C)
{
	if (C.PlayerReplicationInfo != None && !C.PlayerReplicationInfo.bOnlySpectator && C.PlayerReplicationInfo.bOutOfLives)
	{
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
		Invasion(Level.Game).bWaveInProgress = true;
		Level.Game.Enable('Timer');
		C.ClientMessage(MSG_ReSpawned);
	}
}
//================================================
exec function ReSpawn(string target)
{
	local Mutator myMut;
	local Controller C;
	local int namematch;

	log("ReSpawn"@target);

	myMut = findMut(Level.Game.BaseMutator, class'AdminPlusMut');
	if (myMut != none)
	{
		if (Invasion(Level.Game).bWaveInProgress==false) // Запретить респавн между волнами
		{
			target = PlayerReplicationInfo.PlayerName;
			for( C = Level.ControllerList; C != None; C = C.nextController ) {
				namematch = InStr( Caps(C.PlayerReplicationInfo.PlayerName), Caps(target));
				if (namematch >=0)
				{
					PlayerController(C).ClientMessage(MSG_CantRespawn);
					return;
				}
			}
		}
		for( C = Level.ControllerList; C != None; C = C.nextController )
		{
			if( C.IsA('PlayerController') || C.IsA('xBot') )
			{
				if (Target=="all")
				{
					ReSpawnRoutine(PlayerController(C));
				}
				else
				{
					namematch = InStr( Caps(C.PlayerReplicationInfo.PlayerName), Caps(target));
					if (namematch >=0)
						ReSpawnRoutine(PlayerController(C));
				}
					/*
					if( PlayerController(C)!=None && (C.Pawn==None || C.Pawn.Health<=0) && !C.PlayerReplicationInfo.bOnlySpectator )
					{
						C.GotoState('PlayerWaiting');
						C.PlayerReplicationInfo.bOutOfLives = false;
						C.PlayerReplicationInfo.NumLives = 0;
						C.ServerReStartPlayer();
						PlayerController(C).ClientSetViewTarget(C.Pawn);
						PlayerController(C).SetViewTarget(C.Pawn);
					}
					*/
				/*

					if ( !C.PlayerReplicationInfo.bOnlySpectator )
					{
						log("PlayerNotOnlySpectator");
						PlayerController(C).ClientMessage(MSG_ReSpawned);
						C.PlayerReplicationInfo.Score = Max(KFGameType(Level.Game).MinRespawnCash,int(C.PlayerReplicationInfo.Score));

						if( PlayerController(C) != none )
						{
							log("PlayerController!=none");
							PlayerController(C).GotoState('PlayerWaiting');
							PlayerController(C).SetViewTarget(C);
							PlayerController(C).ClientSetBehindView(false);
							PlayerController(C).bBehindView = False;
							PlayerController(C).ClientSetViewTarget(C.Pawn);
						}
						log("ServerRestartPlayer");
						C.ServerReStartPlayer();
					}
					//C.playerreplicationinfo.PlayerName = NewName;
					*/
			}
		}
	}
}
//================================================
//Send a Private Message to a player
exec function PrivMessage(string target, string APMessage){
	local Mutator myMut;
	local Controller C;
	local int namematch;
	local int v;

	myMut = findMut(Level.Game.BaseMutator, class'AdminPlusMut');
	if (myMut != none) {
		if (AdminPlusMut(myMut).PrivMessageEnabled()) {
			v = 0;
			for( C = Level.ControllerList; C != None; C = C.nextController ) {
				if( C.IsA('PlayerController') || C.IsA('xBot')) {
					namematch = InStr( Caps(C.PlayerReplicationInfo.PlayerName), Caps(target));
						if (namematch >=0) {
						v = v++;
						PlayerController(C).ClientMessage("Private Message from Admin: "$APMessage);
					}
				}
			}
			if (v == 0){
					ClientMessage(target$" is not in the game");
			}
		}
	}
}

exec function PM (string target, String PMMessage){
	PrivMessage(target, PMMessage);
}
exec function GI (string item, String ItemName){
	GiveItem(item, ItemName);
}
exec function CN (string target, String NewName){
	ChangeName(target, NewName);
}
exec function SG ( float gr){
	SetGravity(gr);
}
exec function CL1 ( string target ){
	CustomLoaded1(target);
}
exec function CL2 ( string target ){
	CustomLoaded2(target);
}
exec function CL3 ( string target ){
	CustomLoaded3(target);
}

//================================================
//Change Player's Head Size
exec function HeadSize(string target,float newHeadSize){
	local Mutator myMut;
	local Controller C;
	local int namematch;
	local Pawn p;

	myMut = findMut(Level.Game.BaseMutator, class'AdminPlusMut');
	if (myMut != none) {
		if (AdminPlusMut(myMut).ChangeSizeEnabled()){

			if (target == "all") {
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController') || C.IsA('xBot')) {
						if(pawn != none){
							C.Pawn.ClientMessage(MSG_ChangeSize);
							C.Pawn.headscale = newHeadSize;
							C.Pawn.PlayTeleportEffect(true, true);
						}
					}
				}
				return;
			} else if (target == ""){
				P = verifyTarget(target);
				P.ClientMessage(MSG_ChangeSize);
				P.PlayTeleportEffect(true, true);
				P.headscale = newHeadSize;
				return;
			} else {
				P = verifyTarget(target);
				if (P == none){
					return;
				}
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController') || C.IsA('xBot')) {
						namematch = InStr( Caps(C.PlayerReplicationInfo.PlayerName), Caps(target));
						if (namematch >=0) {
							if(pawn != none){
								C.Pawn.ClientMessage(MSG_ChangeSize);
								C.Pawn.headscale = newHeadSize;
								C.Pawn.PlayTeleportEffect(true, true);
							}
						}
					}
				}
			}
		}
	}
}



//================================================
//Change Player's Size
exec function PlayerSize(string target,float newPlayerSize){
	local Mutator myMut;
	local Controller C;
	local int namematch;
	local Pawn p;
	local float oldsize;

	myMut = findMut(Level.Game.BaseMutator, class'AdminPlusMut');
	if (myMut != none) {
		if (AdminPlusMut(myMut).ChangeSizeEnabled()){

			oldsize = C.Pawn.DrawScale;
			if (newPlayerSize == 0 || newPlayerSize > 5){
				ClientMessage("PlayerSize Cannot be 0 or greater than 5, causes game to crash");
				return;
			}

			if (target == "all") {
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController') || C.IsA('xBot')) {
						if ((newPlayerSize < oldsize) || (oldsize == 0)){
							C.Pawn.SetDrawScale((P.DrawScale * 0) + 1);
						}
						if (pawn != none){
							C.Pawn.SetDrawScale(C.Pawn.DrawScale * newPlayerSize);
							C.Pawn.SetCollisionSize(C.Pawn.CollisionRadius * newPlayerSize, C.Pawn.CollisionHeight * newPlayerSize);
							C.Pawn.BaseEyeHeight *= newPlayerSize;
							C.Pawn.EyeHeight     *= newPlayerSize;
							C.Pawn.PlayTeleportEffect(true, true);
							//C.Pawn.bCanCrouch = False;
							//C.Pawn.CrouchHeight  *= newPlayerSize;
							//C.Pawn.CrouchRadius  *= newPlayerSize;
						}
					}
				}
				return;
			} else if (target == ""){
				P = verifyTarget(target);
				P.ClientMessage(MSG_ChangeSize);
				if ((newPlayerSize < oldsize) || (oldsize == 0)){
						P.SetDrawScale((P.DrawScale * 0) + 1);
				}
				P.SetDrawScale(P.DrawScale * newPlayerSize);
				P.SetCollisionSize(P.CollisionRadius * newPlayerSize, P.CollisionHeight * newPlayerSize);
				P.BaseEyeHeight *= newPlayerSize;
				P.EyeHeight     *= newPlayerSize;
				//P.bCanCrouch = False;
				P.PlayTeleportEffect(true, true);
				//	P.CrouchHeight  *= newPlayerSize;
				//	P.CrouchRadius  *= newPlayerSize;
				return;
			} else {
				P = verifyTarget(target);
				if (P == none){
					return;
				}
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController') || C.IsA('xBot')) {
						namematch = InStr( Caps(C.PlayerReplicationInfo.PlayerName), Caps(target));
						if (namematch >=0) {
							C.Pawn.ClientMessage(MSG_ChangeSize);
							if ((newPlayerSize < oldsize) || (oldsize == 0)){
								C.Pawn.SetDrawScale((P.DrawScale * 0) + 1);
							}
							if (pawn != none){
								C.Pawn.SetDrawScale(C.Pawn.DrawScale * newPlayerSize);
								C.Pawn.SetCollisionSize(C.Pawn.CollisionRadius * newPlayerSize, C.Pawn.CollisionHeight * newPlayerSize);
								C.Pawn.BaseEyeHeight *= newPlayerSize;
								C.Pawn.EyeHeight     *= newPlayerSize;
							//	C.Pawn.bCanCrouch = False;
								C.Pawn.PlayTeleportEffect(true, true);
							//	C.Pawn.CrouchHeight  *= newPlayerSize;
							//	C.Pawn.CrouchRadius  *= newPlayerSize;
							}
						}
					}
				}
			}
		}
	}
}


//================================================
//Put Target In God Mode
exec function GodOn(string target){
	local Mutator myMut;
	local Controller C;
	local int namematch;

	myMut = findMut(Level.Game.BaseMutator, class'AdminPlusMut');
	if (myMut != none) {
		if (AdminPlusMut(myMut).GodEnabled()){

			if (target == "all") {
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController') || C.IsA('xBot')) {
						C.bGodMode = true;
						PlayerController(C).ClientMessage(MSG_GodOn);
						C.Pawn.PlayTeleportEffect(true, true);
					}
				}
				ServerSay("Everyone is in God mode");
				return;
			} else if (target == ""){
				target = PlayerReplicationInfo.PlayerName;
				log(target);
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					namematch = InStr( Caps(C.PlayerReplicationInfo.PlayerName), Caps(target));
					if (namematch >=0) {
						C.bGodMode = true;
						PlayerController(C).ClientMessage(MSG_GodOn);
						C.Pawn.PlayTeleportEffect(true, true);
						return;
					}
				}
				ServerSay(target$ " is in God mode");
				return;
			} else {
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController') || C.IsA('xBot')) {
						namematch = InStr( Caps(C.PlayerReplicationInfo.PlayerName), Caps(target));
						if (namematch >=0) {
							C.bGodMode = true;
							PlayerController(C).ClientMessage(MSG_GodOn);
							C.Pawn.PlayTeleportEffect(true, true);
							ServerSay(C.PlayerReplicationInfo.PlayerName$ " is in God mode");
						}
					}
				}
			}
		}
	}
}

//Take Target Out Of God Mode
exec function GodOff(string target){
	local Mutator myMut;
	local Controller C;
	local int namematch;

	myMut = findMut(Level.Game.BaseMutator, class'AdminPlusMut');
	if (myMut != none) {
		if (AdminPlusMut(myMut).GodEnabled()){

			if (target == "all") {
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController') || C.IsA('xBot')) {
						C.bGodMode = false;
						PlayerController(C).ClientMessage(MSG_GodOff);
						C.Pawn.PlayTeleportEffect(true, true);
					}
				}
				ServerSay("All Players are out of God Mode");
				return;
			} else if (target == ""){
				target = PlayerReplicationInfo.PlayerName;
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					namematch = InStr( Caps(C.PlayerReplicationInfo.PlayerName), Caps(target));
					if (namematch >=0) {
						C.bGodMode = false;
						PlayerController(C).ClientMessage(MSG_GodOff);
						C.Pawn.PlayTeleportEffect(true, true);
					}
				}
				ServerSay(target$ " is out of God mode");
				return;
			} else {
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController') || C.IsA('xBot')) {
						namematch = InStr( Caps(C.PlayerReplicationInfo.PlayerName), Caps(target));
						if (namematch >=0) {
							if ( C.bGodMode == false){
								return;
							}
							C.bGodMode = false;
							PlayerController(C).ClientMessage(MSG_GodOff);
							ServerSay(C.PlayerReplicationInfo.PlayerName$ " is out of God Mode");
							C.Pawn.PlayTeleportEffect(true, true);
						}
					}
				}
			}
		}
	}
}


//================================================
//Change a Player's Score
exec function ChangeScore(string target, float newScoreValue){
	local Mutator myMut;
	local Controller C;
	local int namematch;

	myMut = findMut(Level.Game.BaseMutator, class'AdminPlusMut');
	if (myMut != none) {
		if (AdminPlusMut(myMut).ChangeScoreEnabled()){
			if (newScoreValue < 0){
				ClientMessage("You must enter a New Positive Score");
				return;
			}
			if (target == "all") {
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController') || C.IsA('xBot')) {
						C.PlayerReplicationInfo.Score = newScoreValue;
						PlayerController(C).ClientMessage(MSG_ChangeScore);
					}
				}
				ServerSay("All Scores have been set to "$newScoreValue);
				return;
			} else if (target == ""){
				target = PlayerReplicationInfo.PlayerName;
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					namematch = InStr( Caps(C.PlayerReplicationInfo.PlayerName), Caps(target));
					if (namematch >=0) {
						C.PlayerReplicationInfo.Score = newScoreValue;
						PlayerController(C).ClientMessage(MSG_ChangeScore);
						ServerSay(target$ "'s Score has been set to "$newScoreValue);
					}
				}
				return;
			} else {
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController') || C.IsA('xBot')) {
						namematch = InStr( Caps(C.PlayerReplicationInfo.PlayerName), Caps(target));
						if (namematch >=0) {
							C.PlayerReplicationInfo.Score = newScoreValue;
							PlayerController(C).ClientMessage(MSG_ChangeScore);
							ServerSay(C.PlayerReplicationInfo.PlayerName$ "'s Score has been set to "$newScoreValue);
						}
					}
				}
			}
		}
	}
}

exec function ResetScore (string target){
	ChangeScore(target, 0.0);
}

//=================================================
exec function SloMo( float T ){
	local Mutator myMut;

	myMut = findMut(Level.Game.BaseMutator, class'AdminPlusMut');
	if(myMut != none) {
		if (AdminPlusMut(myMut).SloMoEnabled()){
			ServerSay("Game Speed has been set to "$T);
			ClientMessage("Use 'Slomo 1' to return to normal");
			Level.Game.SetGameSpeed(T);

		}
	}
}

//=================================================
exec function SetGravity( float F ){
	local Mutator myMut;

	myMut = findMut(Level.Game.BaseMutator, class'AdminPlusMut');
	if(myMut != none) {
		if (AdminPlusMut(myMut).SetGravityEnabled()) {
			ServerSay("Gravity has been set to "$F);
			ClientMessage("Use 'SetGrav -950' to return to normal");
			PhysicsVolume.Gravity.Z = F;
		}
	}
}

//================================================
//Make Target Invisible
exec function InvisOn(string target, optional float invamount){
	local Mutator myMut;
	local Controller C;
	local int namematch;
	local Pawn p;

	myMut = findMut(Level.Game.BaseMutator, class'AdminPlusMut');
	if(myMut != none) {
		if (AdminPlusMut(myMut).InvisEnabled()) {

			if (target == "all") {
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController') || C.IsA('xBot')) {
						C.Pawn.bHidden = true;
						C.Pawn.Visibility = invamount;
						C.Pawn.ClientMessage(MSG_InvisOn);
					}
				}
				return;
			} else if (target == ""){
				P = verifyTarget(target);
				P.bHidden = true;
				P.Visibility = invamount;
				P.ClientMessage(MSG_InvisOn);
				return;
			} else {
				P = verifyTarget(target);
				if (P == none){
					return;
				}
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController') || C.IsA('xBot')) {
						namematch = InStr( Caps(C.PlayerReplicationInfo.PlayerName), Caps(target));
						if (namematch >=0) {
							C.Pawn.bHidden = true;
							C.Pawn.Visibility = invamount;
							C.Pawn.ClientMessage(MSG_InvisOn);
						}
					}
				}
			}
		}
	}
}

//================================================
//Make Target Able To Be Seen (Undo Invisibility)
exec function InvisOff(string target){
	local Mutator myMut;
	local Controller C;
	local int namematch;
	local Pawn p;

	myMut = findMut(Level.Game.BaseMutator, class'AdminPlusMut');
	if(myMut != none) {
		if (AdminPlusMut(myMut).InvisEnabled()) {

			if (target == "all") {
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController') || C.IsA('xBot')) {
						C.Pawn.bHidden = false;
						C.Pawn.Visibility = C.Pawn.default.visibility;
						C.Pawn.ClientMessage(MSG_InvisOff);
					}
				}
				return;
			} else if (target == ""){
				P = verifyTarget(target);
				P.bHidden = false;
				P.Visibility = P.default.visibility;
				P.ClientMessage(MSG_InvisOff);
				return;
			} else {
				P = verifyTarget(target);
				if (P == none){
					return;
				}
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController') || C.IsA('xBot')) {
						namematch = InStr( Caps(C.PlayerReplicationInfo.PlayerName), Caps(target));
						if (namematch >=0) {
							C.Pawn.bHidden = false;
							C.Pawn.Visibility = C.Pawn.default.visibility;
							C.Pawn.ClientMessage(MSG_InvisOff);
						}
					}
				}
			}
		}
	}
}

//================================================
//Put Target In Ghost Mode
exec function Ghost(string target){
	local Mutator myMut;
	local Controller C;
	local int namematch;
	local Pawn p;

	myMut = findMut(Level.Game.BaseMutator, class'AdminPlusMut');
	if(myMut != none){
		if (AdminPlusMut(myMut).GhostEnabled()){

			if (target == "all"){
				for( C = Level.ControllerList; C != None; C = C.nextController ){
					if( C.IsA('PlayerController')) {
						C.Pawn.bAmbientCreature=true;
						C.Pawn.UnderWaterTime = -1.0;
						C.Pawn.SetCollision(false, false, false);
						C.Pawn.bCollideWorld = false;
						C.Pawn.controller.GotoState('PlayerFlying');
						C.Pawn.ClientMessage(MSG_Ghost);
						C.Pawn.PlayTeleportEffect(true, true);
						ClientMessage("Use 'Admin Walk' to return players to normal");
					}
				}
				return;
			} else if (target == ""){
				P = verifyTarget(target);
				P.bAmbientCreature=true;
				P.UnderWaterTime = -1.0;
				P.SetCollision(false, false, false);
				P.bCollideWorld = false;
				P.controller.GotoState('PlayerFlying');
				P.ClientMessage(MSG_Ghost);
				P.PlayTeleportEffect(true, true);
				ClientMessage("Use 'Admin Walk' to return players to normal");
				return;
			} else {
				P = verifyTarget(target);
				if (P == none){
					return;
				}
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController') || C.IsA('xBot')) {
						namematch = InStr( Caps(C.PlayerReplicationInfo.PlayerName), Caps(target));
						if (namematch >=0){
							C.Pawn.bAmbientCreature=true;
							C.Pawn.UnderWaterTime = -1.0;
							C.Pawn.SetCollision(false, false, false);
							C.Pawn.bCollideWorld = false;
							C.Pawn.controller.GotoState('PlayerFlying');
							C.Pawn.ClientMessage(MSG_Ghost);
							C.Pawn.PlayTeleportEffect(true, true);
							ClientMessage("Use 'Admin Walk' to return players to normal");
						}
					}
				}
			}
		}
	}
}


//================================================
//Put Target In Fly Mode
exec function Fly(string target){
	local Mutator myMut;
	local Controller C;
	local int namematch;
	local Pawn p;

	myMut = findMut(Level.Game.BaseMutator, class'AdminPlusMut');
	if(myMut != none) {
		if (AdminPlusMut(myMut).FlyEnabled()) {

			if (target == "all") {
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController')) {
						C.Pawn.bAmbientCreature=false;
						C.Pawn.UnderWaterTime = C.Pawn.Default.UnderWaterTime;
						C.Pawn.SetCollision(true, true , true);
						C.Pawn.bCollideWorld = true;
						C.Pawn.controller.GotoState('PlayerFlying');
						C.Pawn.ClientMessage(MSG_Fly);
						C.Pawn.PlayTeleportEffect(true, true);
						ClientMessage("Use 'Admin Walk' to return players to normal");
					}
				}
				return;
			} else if (target == ""){
				P = verifyTarget(target);
				P.bAmbientCreature=false;
				P.UnderWaterTime = P.Default.UnderWaterTime;
				P.SetCollision(true, true , true);
				P.bCollideWorld = true;
				P.controller.GotoState('PlayerFlying');
				P.ClientMessage(MSG_Fly);
				P.PlayTeleportEffect(true, true);
				ClientMessage("Use 'Admin Walk' to return players to normal");
				return;
			} else {
				P = verifyTarget(target);
				if (P == none){
					return;
				}
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController')) {
						namematch = InStr( Caps(C.PlayerReplicationInfo.PlayerName), Caps(target));
						if (namematch >=0) {
							C.Pawn.bAmbientCreature=false;
							C.Pawn.UnderWaterTime = C.Pawn.Default.UnderWaterTime;
							C.Pawn.SetCollision(true, true , true);
							C.Pawn.bCollideWorld = true;
							C.Pawn.controller.GotoState('PlayerFlying');
							C.Pawn.ClientMessage(MSG_Fly);
							C.Pawn.PlayTeleportEffect(true, true);
							ClientMessage("Use 'Admin Walk' to return players to normal");
						}
					}
				}
			}
		}
	}
}

//================================================
//Put Target In Spider Mode
exec function Spider(string target){
	local Mutator myMut;
	local Controller C;
	local int namematch;
	local Pawn p;

	myMut = findMut(Level.Game.BaseMutator, class'AdminPlusMut');
	if(myMut != none) {
		if (AdminPlusMut(myMut).SpiderEnabled()) {

			if (target == "all") {
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if ( C.IsA('PlayerController')) {
						C.Pawn.bAmbientCreature=false;
						C.Pawn.UnderWaterTime = C.Pawn.Default.UnderWaterTime;
						C.Pawn.SetCollision(true, true , true);
						C.Pawn.bCollideWorld = true;
						C.Pawn.JumpZ = 0.0;
						xPawn(C.Pawn).bflaming = true;
						C.Pawn.controller.GotoState('PlayerSpidering');
						C.Pawn.ClientMessage(MSG_Spider);
						C.Pawn.PlayTeleportEffect(true, true);
						ClientMessage("Use 'Admin Walk' to return players to normal");
					}
				}
				return;
			} else if (target == ""){
				P = verifyTarget(target);
				P.bAmbientCreature=false;
				P.UnderWaterTime = P.Default.UnderWaterTime;
				P.SetCollision(true, true , true);
				P.bCollideWorld = true;
				P.bCanJump = False;
				P.controller.GotoState('PlayerSpidering');
				P.ClientMessage(MSG_Spider);
				P.PlayTeleportEffect(true, true);
				ClientMessage("Use 'Admin Walk' to return players to normal");
				return;
			} else {
				P = verifyTarget(target);
				if (P == none){
					return;
				}
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController')) {
						namematch = InStr( Caps(C.PlayerReplicationInfo.PlayerName), Caps(target));
						if (namematch >=0) {
							C.Pawn.bAmbientCreature=false;
							C.Pawn.UnderWaterTime = C.Pawn.Default.UnderWaterTime;
							C.Pawn.SetCollision(true, true , true);
							C.Pawn.bCollideWorld = true;
							C.Pawn.bCanJump = False;
							C.Pawn.controller.GotoState('PlayerSpidering');
							C.Pawn.ClientMessage(MSG_Spider);
							C.Pawn.PlayTeleportEffect(true, true);
							ClientMessage("Use 'Admin Walk' to return players to normal");
						}
					}
				}
			}
		}
	}
}
//================================================
//Put Target In Walk Mode
exec function Walk(string target){
	local Mutator myMut;
	local Controller C;
	local int namematch;
	local Pawn p;

	myMut = findMut(Level.Game.BaseMutator, class'AdminPlusMut');
	if(myMut != none) {

		if (target == "all") {
			for( C = Level.ControllerList; C != None; C = C.nextController ) {
				if( C.IsA('PlayerController')) {
					C.Pawn.bAmbientCreature=false;
					C.Pawn.UnderWaterTime = C.Pawn.Default.UnderWaterTime;
					C.Pawn.SetCollision(true, true , true);
					C.Pawn.SetPhysics(PHYS_Walking);
					C.Pawn.bCollideWorld = true;
					C.Pawn.bCanJump = true;
					C.Pawn.controller.GotoState('PlayerWalking');
					C.Pawn.ClientMessage(MSG_Walk);
				}
			}
			return;
		} else if (target == ""){
			P = verifyTarget(target);
			P.bAmbientCreature=false;
			P.UnderWaterTime = P.Default.UnderWaterTime;
			P.SetCollision(true, true , true);
			P.SetPhysics(PHYS_Walking);
			P.bCollideWorld = true;
			P.bCanJump = true;
			P.controller.GotoState('PlayerWalking');
			P.ClientMessage(MSG_Walk);
			return;
		} else {
			P = verifyTarget(target);
			if (P == none){
					return;
				}
			for( C = Level.ControllerList; C != None; C = C.nextController ) {
				if( C.IsA('PlayerController')) {
					namematch = InStr( Caps(C.PlayerReplicationInfo.PlayerName), Caps(target));
					if (namematch >=0) {
						C.Pawn.bAmbientCreature=false;
						C.Pawn.UnderWaterTime = C.Pawn.Default.UnderWaterTime;
						C.Pawn.SetCollision(true, true , true);
						C.Pawn.SetPhysics(PHYS_Walking);
						C.Pawn.bCollideWorld = true;
						C.Pawn.bCanJump = true;
						C.Pawn.controller.GotoState('PlayerWalking');
						C.Pawn.ClientMessage(MSG_Walk);
					}
				}
			}
		}
	}
}
//================================================
exec function Summon( string ClassName )
{
	local class<actor> NewClass;
	local vector SpawnLoc;
	local Mutator myMut;

	myMut = findMut(Level.Game.BaseMutator, class'AdminPlusMut');
	if(myMut != none) {
		if (AdminPlusMut(myMut).SummonEnabled()) {
			NewClass = class<actor>( DynamicLoadObject( ClassName, class'Class' ) );
			if( NewClass!=None )
			{
				if ( Pawn != None )
					SpawnLoc = Pawn.Location;
				else
					SpawnLoc = Location;
				Spawn( NewClass,,,SpawnLoc + 72 * Vector(Rotation) + vect(0,0,1) * 15 );
			}
		}
	}
}

//================================================
exec function AdvancedSummon( string ClassName, string target)
{
	local class<actor> NewClass;
	local vector SpawnLoc;
	local Mutator myMut;
	local Pawn p;

		 p = verifyTarget(target);
		 if (p == None){
			ClientMessage(target $" is not on the game.");
			return;

	}
	myMut = findMut(Level.Game.BaseMutator, class'AdminPlusMut');
	if(myMut != none) {
		if (AdminPlusMut(myMut).AdvancedSummonEnabled()) {
			log( "Fabricate " $ ClassName );
			NewClass = class<actor>( DynamicLoadObject( ClassName, class'Class' ) );
			if( NewClass!=None )
			{
				if ( P != None )
					SpawnLoc = P.Location;
				else
					SpawnLoc = Location;
				Spawn( NewClass,,,SpawnLoc + 72 * Vector(Rotation) + vect(0,0,1) * 15 );
			}
		}
	}
}

//================================================
exec function Teleport(){
	local Mutator myMut;
	local actor HitActor;
	local vector HitNormal, HitLocation;

	myMut = findMut(Level.Game.BaseMutator, class'AdminPlusMut');
	if(myMut != none) {
		if (AdminPlusMut(myMut).TeleportEnabled()) {
			HitActor = Trace(HitLocation, HitNormal, ViewTarget.Location + 10000 * vector(Rotation),ViewTarget.Location, true);
			if ( HitActor == None ){
				HitLocation = ViewTarget.Location + 10000 * vector(Rotation);
			} else {
				HitLocation = HitLocation + ViewTarget.CollisionRadius * HitNormal;
			}
			ViewTarget.SetLocation(HitLocation);
			ViewTarget.PlayTeleportEffect(false,true);
		}
	}
}

//================================================

exec function GiveItem(string ItemName, string target){
	local Inventory Inv;
	local Mutator myMut;
	local Controller C;
	local int namematch;
	local Pawn p;
	local string ItemOnly;
	local int PeriodLoc;
	//local Weapon myWeapon;

	myMut = findMut(Level.Game.BaseMutator, class'AdminPlusMut');
	if(myMut != none) {
		if (AdminPlusMut(myMut).GiveItemEnabled()) {
			PeriodLoc = Instr(ItemName, ".");
			ItemOnly = Right(ItemName, PeriodLoc);
			if (target == "all") {
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController')){
						if (ItemName == "adrenaline"){
							C.Pawn.controller.adrenaline = 100;
							C.Pawn.ClientMessage("You Have been given Full Adrenaline!");
						} else {
							C.Pawn.GiveWeapon(ItemName);
							C.Pawn.PlayTeleportEffect(true, true);
							C.Pawn.ClientMessage("You Have been given the gift of: "$ItemOnly);
							AllAmmo(C.Pawn);
							For ( Inv=C.Pawn.Inventory; Inv!=None; Inv=Inv.Inventory ) {
								if ( Weapon(Inv) != None ) {
									Weapon(Inv).Loaded();
								}
							}
						}
					}
				}
				return;
			} else if (target == ""){
				P = verifyTarget(target);
				if (ItemName == "adrenaline"){
					P.controller.adrenaline = 100;
					P.ClientMessage("You Have been given Full Adrenaline!");
				} else {
					P.GiveWeapon(ItemName);
					P.PlayTeleportEffect(true, true);
					P.ClientMessage("You Have been given the gift of: "$ItemOnly);
					AllAmmo(P);
					For ( Inv=P.Inventory; Inv!=None; Inv=Inv.Inventory ) {
						if ( Weapon(Inv) != None ) {
							Weapon(Inv).Loaded();
						}
					}
				}
				return;
			} else {
				P = verifyTarget(target);
				if (P == none){
					return;
				}
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController') || C.IsA('xBot')) {
						namematch = InStr( Caps(C.PlayerReplicationInfo.PlayerName), Caps(target));
						if (namematch >=0) {
							if (ItemName == "adrenaline"){
								C.Pawn.controller.adrenaline = 100;
								C.Pawn.ClientMessage("You Have been given Full Adrenaline!");
							} else {
								C.Pawn.GiveWeapon(ItemName);
								C.Pawn.PlayTeleportEffect(true, true);
								C.Pawn.ClientMessage("You Have been given the gift of: "$ItemOnly);
								AllAmmo(C.Pawn);
								For ( Inv=C.Pawn.Inventory; Inv!=None; Inv=Inv.Inventory ) {
									if ( Weapon(Inv) != None ) {
										Weapon(Inv).Loaded();
									}
								}
							}
						}
					}
				}
			}
		}
	}
}
//=============================================
exec function Loaded(string target){
	local Inventory Inv;
	local Mutator myMut;
	local Controller C;
	local int namematch;
	local Pawn P;

	myMut = findMut(Level.Game.BaseMutator, class'AdminPlusMut');
	if(myMut != none) {
		if (AdminPlusMut(myMut).LoadedEnabled()) {

			if (target == "all") {
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController')){
						AllWeapons(C.Pawn);
						AllAmmo(C.Pawn);
						C.Pawn.ClientMessage ("You have been given All Default Weapons!");
						C.Pawn.PlayTeleportEffect(true, true);
						For ( Inv=C.Pawn.Inventory; Inv!=None; Inv=Inv.Inventory ) {
							if ( Weapon(Inv) != None ) {
								Weapon(Inv).Loaded();
							}
						}
					}
				}
				ServerSay("Everyone has been Loaded!");
				return;
			} else if (target == ""){
				P = verifyTarget(target);
				AllWeapons(P);
				AllAmmo(P);
				P.ClientMessage ("You have been given All Default Weapons!");
				P.PlayTeleportEffect(true, true);
				ServerSay(target$ " has been Loaded!");
				For ( Inv=P.Inventory; Inv!=None; Inv=Inv.Inventory ) {
					if ( Weapon(Inv) != None ) {
						Weapon(Inv).Loaded();
					}
				}
				return;
			} else {
				P = verifyTarget(target);
				if (P == none){
					return;
				}
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController') || C.IsA('xBot')) {
						namematch = InStr( Caps(C.PlayerReplicationInfo.PlayerName), Caps(target));
						if (namematch >= 0) {
							AllWeapons(C.Pawn);
							AllAmmo(C.Pawn);
							C.Pawn.ClientMessage ("You have been given All Default Weapons!");
							C.Pawn.PlayTeleportEffect(true, true);
							For ( Inv=C.Pawn.Inventory; Inv!=None; Inv=Inv.Inventory ) {
								if ( Weapon(Inv) != None ) {
									Weapon(Inv).Loaded();
								}
							}
						}
					}
				}
				ServerSay(C.PlayerReplicationInfo.PlayerName$ " has been Loaded!");
				return;
			}
		}
	}
}
//=============================================
exec function CustomLoaded1(string target){
	local Inventory Inv;
	local Mutator myMut;
	local int i;
	local string M;
	local Controller C;
	local int namematch;
	local Pawn P;

	myMut = findMut(Level.Game.BaseMutator, class'AdminPlusMut');
	if(myMut != none) {
		if (AdminPlusMut(myMut).CustomLoadedEnabled()) {

			if (target == "all") {
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController')) {
						for (i = 0; i < class'AdminPlusMut'.default.WeaponBase1.Length; i++) {
							M = (class'AdminPlusMut'.default.WeaponBase1[i]);
							C.Pawn.Giveweapon(M);
						}
						AllAmmo(C.Pawn);
						C.Pawn.ClientMessage ("You have been given Custom Weapons Pack 1!");
						C.Pawn.PlayTeleportEffect(true, true);
						For ( Inv=C.Pawn.Inventory; Inv!=None; Inv=Inv.Inventory ){
							if ( Weapon(Inv) != None ){
								Weapon(Inv).Loaded();
							}
						}
					}
				}
				return;
			} else if (target == ""){
				P = verifyTarget(target);
				if (P == none){
					return;
				}
				for (i = 0; i < class'AdminPlusMut'.default.WeaponBase1.Length; i++) {
					M = (class'AdminPlusMut'.default.WeaponBase1[i]);
					p.Giveweapon(M);
				}
				AllAmmo(p);
				P.ClientMessage ("You have been given Custom Weapons Pack 1!");
				P.PlayTeleportEffect(true, true);
				For ( Inv=P.Inventory; Inv!=None; Inv=Inv.Inventory ){
					if ( Weapon(Inv) != None ){
						Weapon(Inv).Loaded();
					}
				}
				return;
			} else {
				P = verifyTarget(target);
				if (P == none){
					return;
				}
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController') || C.IsA('xBot')) {
						namematch = InStr( Caps(C.PlayerReplicationInfo.PlayerName), Caps(target));
						if (namematch >=0) {
							for (i = 0; i < class'AdminPlusMut'.default.WeaponBase1.Length; i++) {
								M = (class'AdminPlusMut'.default.WeaponBase1[i]);
								C.Pawn.Giveweapon(M);
							}
							AllAmmo(C.Pawn);
							C.Pawn.ClientMessage ("You have been given Custom Weapons Pack 1!");
							C.Pawn.PlayTeleportEffect(true, true);
							For ( Inv=C.Pawn.Inventory; Inv!=None; Inv=Inv.Inventory ){
								if ( Weapon(Inv) != None ){
									Weapon(Inv).Loaded();
								}
							}
						}
					}
				}
			}
		}
	}
}
//=============================================
exec function CustomLoaded2(string target){
	local Inventory Inv;
	local Mutator myMut;
	local int i;
	local string M;
	local Controller C;
	local int namematch;
	local Pawn P;

	myMut = findMut(Level.Game.BaseMutator, class'AdminPlusMut');
	if(myMut != none) {
		if (AdminPlusMut(myMut).CustomLoadedEnabled()) {

			if (target == "all") {
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController')) {
						for (i = 0; i < class'AdminPlusMut'.default.WeaponBase2.Length; i++) {
							M = (class'AdminPlusMut'.default.WeaponBase2[i]);
							C.Pawn.Giveweapon(M);
						}
						AllAmmo(C.Pawn);
						C.Pawn.ClientMessage ("You have been given Custom Weapons Pack 2!");
						C.Pawn.PlayTeleportEffect(true, true);
						For ( Inv=C.Pawn.Inventory; Inv!=None; Inv=Inv.Inventory ){
							if ( Weapon(Inv) != None ){
								Weapon(Inv).Loaded();
							}
						}
					}
				}
				return;
			} else if (target == ""){
				P = verifyTarget(target);
				if (P == none){
					return;
				}
				for (i = 0; i < class'AdminPlusMut'.default.WeaponBase2.Length; i++) {
					M = (class'AdminPlusMut'.default.WeaponBase2[i]);
					p.Giveweapon(M);
				}
				AllAmmo(P);
				P.ClientMessage ("You have been given Custom Weapons Pack 2!");
				P.PlayTeleportEffect(true, true);
				For ( Inv=P.Inventory; Inv!=None; Inv=Inv.Inventory ){
					if ( Weapon(Inv) != None ){
						Weapon(Inv).Loaded();
					}
				}
				return;
			} else {
				P = verifyTarget(target);
				if (P == none){
					return;
				}
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController') || C.IsA('xBot')) {
						namematch = InStr( Caps(C.PlayerReplicationInfo.PlayerName), Caps(target));
						if (namematch >=0) {
							for (i = 0; i < class'AdminPlusMut'.default.WeaponBase2.Length; i++) {
								M = (class'AdminPlusMut'.default.WeaponBase2[i]);
								C.Pawn.Giveweapon(M);
							}
							AllAmmo(C.Pawn);
							C.Pawn.ClientMessage ("You have been given Custom Weapons Pack 2!");
							C.Pawn.PlayTeleportEffect(true, true);
							For ( Inv=C.Pawn.Inventory; Inv!=None; Inv=Inv.Inventory ){
								if ( Weapon(Inv) != None ){
									Weapon(Inv).Loaded();
								}
							}
						}
					}
				}
			}
		}
	}
}
//=============================================
exec function CustomLoaded3(string target){
	local Inventory Inv;
	local Mutator myMut;
	local int i;
	local string M;
	local Controller C;
	local int namematch;
	local Pawn P;

	myMut = findMut(Level.Game.BaseMutator, class'AdminPlusMut');
	if(myMut != none) {
		if (AdminPlusMut(myMut).CustomLoadedEnabled()) {

			if (target == "all") {
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController')) {
						for (i = 0; i < class'AdminPlusMut'.default.WeaponBase3.Length; i++) {
							M = (class'AdminPlusMut'.default.WeaponBase3[i]);
							C.Pawn.Giveweapon(M);
						}
						AllAmmo(C.Pawn);
						C.Pawn.ClientMessage ("You have been given Custom Weapons Pack 3!");
						C.Pawn.PlayTeleportEffect(true, true);
						For ( Inv=C.Pawn.Inventory; Inv!=None; Inv=Inv.Inventory ){
							if ( Weapon(Inv) != None ){
								Weapon(Inv).Loaded();
							}
						}
					}
				}
				return;
			} else if (target == ""){
				P = verifyTarget(target);
				if (P == none){
					return;
				}
				for (i = 0; i < class'AdminPlusMut'.default.WeaponBase3.Length; i++) {
					M = (class'AdminPlusMut'.default.WeaponBase3[i]);
					p.Giveweapon(M);
				}
				AllAmmo(P);
				P.ClientMessage ("You have been given Custom Weapons Pack 3!");
				P.PlayTeleportEffect(true, true);
				For ( Inv=P.Inventory; Inv!=None; Inv=Inv.Inventory ){
					if ( Weapon(Inv) != None ){
						Weapon(Inv).Loaded();
					}
				}
				return;
			} else {
				P = verifyTarget(target);
				if (P == none){
					return;
				}
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController') || C.IsA('xBot')) {
						namematch = InStr( Caps(C.PlayerReplicationInfo.PlayerName), Caps(target));
						if (namematch >=0) {
							for (i = 0; i < class'AdminPlusMut'.default.WeaponBase3.Length; i++) {
								M = (class'AdminPlusMut'.default.WeaponBase3[i]);
								C.Pawn.Giveweapon(M);
							}
							AllAmmo(C.Pawn);
							C.Pawn.ClientMessage ("You have been given Custom Weapons Pack 3!");
							C.Pawn.PlayTeleportEffect(true, true);
							For ( Inv=C.Pawn.Inventory; Inv!=None; Inv=Inv.Inventory ){
								if ( Weapon(Inv) != None ){
									Weapon(Inv).Loaded();
								}
							}
						}
					}
				}
			}
		}
	}
}

function AllAmmo(Pawn P){
	local Inventory Inv;
	for( Inv=P.Inventory; Inv!=None; Inv=Inv.Inventory )
		if ( Weapon(Inv)!=None )
			Weapon(Inv).SuperMaxOutAmmo();

	P.Controller.AwardAdrenaline( 999 );
}

function AllWeapons(pawn P)
{
	if ((P == None) || (Vehicle(P) != None) )
		return;

	P.GiveWeapon("KFMod.Axe");
	P.GiveWeapon("KFMod.Bullpup");
	P.GiveWeapon("KFMod.Chainsaw");
	P.GiveWeapon("KFMod.Crossbow");
	P.GiveWeapon("KFMod.Deagle");
	P.GiveWeapon("KFMod.Single");
	P.GiveWeapon("KFMod.Shotgun");
	P.GiveWeapon("KFMod.Flamethrower");
	P.GiveWeapon("KFMod.Nade");
	P.GiveWeapon("KFMod.Machete");
	P.GiveWeapon("KFMod.Syringe");
	P.GiveWeapon("KFMod.Welder");
	P.GiveWeapon("KFMod.Winchester");
	P.GiveWeapon("KFMod.LAW");
	P.GiveWeapon("KFMod.Knife");
}

//=========================================================================
exec function CauseEvent( name EventName ){
	local Mutator myMut;

	myMut = findMut(Level.Game.BaseMutator, class'AdminPlusMut');
	if(myMut != none) {
		if (AdminPlusMut(myMut).CauseEventEnabled()) {
			TriggerEvent( EventName, Pawn, Pawn);
		}
	}
}

//=========================================================================
exec function DNO(){
	local Mutator myMut;

	myMut = findMut(Level.Game.BaseMutator, class'AdminPlusMut');
	if(myMut != none) {
		if (AdminPlusMut(myMut).DNOEnabled()) {
			Level.Game.DisableNextObjective();
		}
	}
}

function help_list(Controller C)
{
	PlayerController(C).ClientMessage(MSG_Help1);
	PlayerController(C).ClientMessage(MSG_Help2);
	PlayerController(C).ClientMessage(MSG_Help3);
	PlayerController(C).ClientMessage(MSG_Help4);
	PlayerController(C).ClientMessage(MSG_Help5);
	PlayerController(C).ClientMessage(MSG_Help6);
	PlayerController(C).ClientMessage(MSG_Help7);
	PlayerController(C).ClientMessage(MSG_Help8);
	PlayerController(C).ClientMessage(MSG_Help9);
	PlayerController(C).ClientMessage(MSG_Help10);
	PlayerController(C).ClientMessage(MSG_Help11);
	PlayerController(C).ClientMessage(MSG_Help12);
	PlayerController(C).ClientMessage(MSG_Help13);
	PlayerController(C).ClientMessage(MSG_Help14);
	PlayerController(C).ClientMessage(MSG_Help15);
	PlayerController(C).ClientMessage(MSG_Help16);
	PlayerController(C).ClientMessage(MSG_Help17);
	PlayerController(C).ClientMessage(MSG_Help18);
	PlayerController(C).ClientMessage(MSG_Help19);
	PlayerController(C).ClientMessage(MSG_Help20);
	PlayerController(C).ClientMessage(MSG_Help21);
	PlayerController(C).ClientMessage(MSG_Help22);
	PlayerController(C).ClientMessage(MSG_Help23);
	PlayerController(C).ClientMessage(MSG_Help24);
	PlayerController(C).ClientMessage(MSG_Help25);
	PlayerController(C).ClientMessage(MSG_Help26);
	PlayerController(C).ClientMessage(MSG_Help27);
	PlayerController(C).ClientMessage(MSG_Help28);
	PlayerController(C).ClientMessage(MSG_Help29);
	PlayerController(C).ClientMessage(MSG_Help30);
	PlayerController(C).ClientMessage(MSG_Help31);
	PlayerController(C).ClientMessage(MSG_Help32);
	PlayerController(C).ClientMessage(MSG_Help33);
	PlayerController(C).ClientMessage(MSG_Help34);
	PlayerController(C).ClientMessage(MSG_Help35);
}
//=========================================================================
exec function Help(string target){
	local Mutator myMut;
	local Controller C;
	local int namematch;

	myMut = findMut(Level.Game.BaseMutator, class'AdminPlusMut');
	if (myMut != none) {

		if (target == ""){
			target = PlayerReplicationInfo.PlayerName;
			for( C = Level.ControllerList; C != None; C = C.nextController ) {
				namematch = InStr( Caps(C.PlayerReplicationInfo.PlayerName), Caps(target));
				if (namematch >=0) {
					help_list(C);
					return;
				}
			}
		} else {
			for( C = Level.ControllerList; C != None; C = C.nextController ) {
				if( C.IsA('PlayerController') || C.IsA('xBot')) {
					namematch = InStr( Caps(C.PlayerReplicationInfo.PlayerName), Caps(target));
					if (namematch >=0) {
						help_list(C);
					}
				}
			}
		}
	}
}
//====================
//====================
//==Disabled at work==
//====================
//====================

//================================================
//Instantly do 10,000 points of damage to a given player.
/*exec function fatality(string target){
	local Mutator myMut;
	local Controller C;
	local int namematch;
	local Pawn p;

	myMut = findMut(Level.Game.BaseMutator, class'AdminPlusMut');
	if(myMut != none) {
		if (AdminPlusMut(myMut).fatalityEnabled()) {

			if (target == "all") {
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController') || C.IsA('xBot')) {
						C.Pawn.Controller.bGodMode = false;
						Spawn( class<actor>( DynamicLoadObject( "xeffects.redeemerexplosion", class'Class' ) ),,,C.Pawn.location + 72 * Vector(Rotation) + vect(0,0,1) * 15 );
						C.Pawn.controller.PlaySound(sound'WeaponSounds.redeemer_explosionsound',,255);
						C.Pawn.TakeDamage(1000,Instigator,Vect(0,0,0),Vect(0,0,0),class'DamTypeIonBlast');
					}
				}
				ServerSay("An Admin turned everyone into ashes!");
				return;
			} else if (target == ""){
				P = verifyTarget(target);
				if (P == none){
					return;
				}
				P.Controller.bGodMode = false;
				Spawn( class<actor>( DynamicLoadObject( "xeffects.redeemerexplosion", class'Class' ) ),,,P.location + 72 * Vector(Rotation) + vect(0,0,1) * 15 );
				P.controller.PlaySound(sound'WeaponSounds.redeemer_explosionsound',,255);
				ServerSay(P.PlayerReplicationInfo.PlayerName $" turned himself into ashes!");
				P.TakeDamage(1000,Instigator,Vect(0,0,0),Vect(0,0,0),class'DamTypeIonBlast');
				return;
			} else {
				P = verifyTarget(target);
				if (P == none){
					return;
				}
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController') || C.IsA('xBot')) {
						namematch = InStr( Caps(C.PlayerReplicationInfo.PlayerName), Caps(target));
						if (namematch >=0) {
							C.Pawn.Controller.bGodMode = false;
							Spawn( class<actor>( DynamicLoadObject( "xeffects.redeemerexplosion", class'Class' ) ),,,C.Pawn.location + 72 * Vector(Rotation) + vect(0,0,1) * 15 );
							C.Pawn.controller.PlaySound(sound'WeaponSounds.redeemer_explosionsound',,255);
							ServerSay("An Admin turned " $ C.PlayerReplicationInfo.PlayerName $ " into ashes!");
							C.Pawn.TakeDamage(1000,Instigator,Vect(0,0,0),Vect(0,0,0),class'DamTypeIonBlast');
						}
					}
				}
			}
		}
	}
}*/

//================================================
//xPawn Commands for combos, invisibility, more
/*exec function CrateComboOn(string target){

	local Mutator myMut;
	local Pawn P;
	local Controller C;
	local int namematch;

	myMut = findMut(Level.Game.BaseMutator, class'AdminPlusMut');
	if (myMut != none) {
		if (AdminPlusMut(myMut).CombosEnabled()){

			if (target == "all") {
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController') || C.IsA('xBot')) {
						if (C.Pawn.Role == ROLE_Authority){
							Effect = Spawn(class'CrateActor', C.Pawn,, C.Pawn.Location + C.Pawn.CollisionHeight * vect(0,0,0.55), C.Pawn.Rotation);
							C.Pawn.ClientMessage("Camouflage");
						}
					}
				}
				return;
			} else if (target == ""){
				P = verifyTarget(target);
				if (P.Role == ROLE_Authority){
					Effect = Spawn(class'CrateActor', C.Pawn,, C.Pawn.Location + C.Pawn.CollisionHeight * vect(0,0,0.55), C.Pawn.Rotation);
					P.ClientMessage("Camouflage");
				}
				return;
			} else {
				P = verifyTarget(target);
				if (P == none){
					return;
				}
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController') || C.IsA('xBot')) {
						namematch = InStr( Caps(C.PlayerReplicationInfo.PlayerName), Caps(target));
						if (namematch >=0) {
							if (C.Pawn.Role == ROLE_Authority){
								Effect = Spawn(class'CrateActor', C.Pawn,, C.Pawn.Location + C.Pawn.CollisionHeight * vect(0,0,0.55), C.Pawn.Rotation);
								C.Pawn.ClientMessage("Camouflage");
							}
						}
					}
				}
			}
		}
	}
}

exec function CrateComboOff(string target){

	local Mutator myMut;
	local Pawn P;
	local Controller C;
	local int namematch;

	myMut = findMut(Level.Game.BaseMutator, class'AdminPlusMut');
	if (myMut != none) {
		if (AdminPlusMut(myMut).CombosEnabled()){

			if (target == "all") {
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController') || C.IsA('xBot')) {
						if (C.Pawn.Role == ROLE_Authority){
							if (Effect != None){
								Effect.Destroy();
							}
							C.Pawn.ClientMessage("Camouflage Removed");
						}
					}
				}
				ClientMessage("use 'Admin KillAll Crateactor' to get rid of all crates (its bugged)");
				return;
			} else if (target == ""){
				P = verifyTarget(target);
				P.ClientMessage(MSG_ChangeSize);
				if (P.Role == ROLE_Authority){
					if (Effect != None)
						Effect.Destroy();
					P.ClientMessage("Camouflage Removed");
				}
				ClientMessage("use 'Admin KillAll Crateactor' to get rid of all crates (its bugged)");
				return;
			} else {
				P = verifyTarget(target);
				if (P == none){
					return;
				}
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController') || C.IsA('xBot')) {
						namematch = InStr( Caps(C.PlayerReplicationInfo.PlayerName), Caps(target));
						if (namematch >=0) {
							if (C.Pawn.Role == ROLE_Authority){
								if (Effect != None)
									Effect.Destroy();
								C.Pawn.ClientMessage("Camouflage Removed");
								ClientMessage("use 'Admin KillAll Crateactor' to get rid of all crates (its bugged)");
							}
						}
					}
				}
			}
		}
	}
}

exec function SpeedComboOn(string target){

	local Mutator myMut;
	local Pawn P;
	local Controller C;
	local int namematch;

	myMut = findMut(Level.Game.BaseMutator, class'AdminPlusMut');
	if (myMut != none) {
		if (AdminPlusMut(myMut).CombosEnabled()){

			if (target == "all") {
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController') || C.IsA('xBot')) {
						if (C.Pawn.GroundSpeed > 500){
								return;
						}
						LeftTrail = Spawn(class'SpeedTrail', C.Pawn,, C.Pawn.Location, C.Pawn.Rotation);
						C.Pawn.controller.PlaySound(sound'GameSounds.Combo.ComboActivated',,255);
						C.Pawn.AttachToBone(LeftTrail, 'lfoot');
						RightTrail = Spawn(class'SpeedTrail', C.Pawn,, C.Pawn.Location, C.Pawn.Rotation);
						C.Pawn.controller.PlaySound(sound'GameSounds.Combo.ComboActivated',,255);
						C.Pawn.AttachToBone(RightTrail, 'rfoot');
						C.Pawn.AirControl *= 1.4;
						C.Pawn.GroundSpeed *= 1.4;
						C.Pawn.WaterSpeed *= 1.4;
						C.Pawn.AirSpeed *= 1.4;
						C.Pawn.JumpZ *= 1.5;
						C.Pawn.ClientMessage("Speed Boost Combo");
					}
				}
				return;
			} else if (target == ""){
				P = verifyTarget(target);
				if (P.GroundSpeed > 500){
					return;
				}
				LeftTrail = Spawn(class'SpeedTrail', P,, P.Location, P.Rotation);
				P.controller.PlaySound(sound'GameSounds.Combo.ComboActivated',,255);
				P.AttachToBone(LeftTrail, 'lfoot');
				RightTrail = Spawn(class'IonCore', P,, P.Location, P.Rotation);
				P.controller.PlaySound(sound'GameSounds.Combo.ComboActivated',,255);
				P.AttachToBone(RightTrail, 'rfoot');
				P.AirControl *= 1.4;
				P.GroundSpeed *= 1.4;
				P.WaterSpeed *= 1.4;
				P.AirSpeed *= 1.4;
				P.JumpZ *= 1.5;
				P.ClientMessage("Speed Boost Combo");
				return;
			} else {
				P = verifyTarget(target);
				if (P == none){
					return;
				}
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController') || C.IsA('xBot')) {
						namematch = InStr( Caps(C.PlayerReplicationInfo.PlayerName), Caps(target));
						if (namematch >=0) {
							if (C.Pawn.GroundSpeed > 500){
								return;
							}
							LeftTrail = Spawn(class'SpeedTrail', C.Pawn,, C.Pawn.Location, C.Pawn.Rotation);
							C.Pawn.controller.PlaySound(sound'GameSounds.Combo.ComboActivated',,255);
							C.Pawn.AttachToBone(LeftTrail, 'lfoot');
							RightTrail = Spawn(class'SpeedTrail', C.Pawn,, C.Pawn.Location, C.Pawn.Rotation);
							C.Pawn.controller.PlaySound(sound'GameSounds.Combo.ComboActivated',,255);
							C.Pawn.AttachToBone(RightTrail, 'rfoot');
							C.Pawn.AirControl *= 1.4;
							C.Pawn.GroundSpeed *= 1.4;
							C.Pawn.WaterSpeed *= 1.4;
							C.Pawn.AirSpeed *= 1.4;
							C.Pawn.JumpZ *= 1.5;
							C.Pawn.ClientMessage("Speed Boost Combo");
						}
					}
				}
			}
		}
	}
}

exec function SpeedComboOff(string target){

	local Mutator myMut;
	local Pawn P;
	local Controller C;
	local int namematch;

	myMut = findMut(Level.Game.BaseMutator, class'AdminPlusMut');
	if (myMut != none) {
		if (AdminPlusMut(myMut).CombosEnabled()){

			if (target == "all") {
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController') || C.IsA('xBot')) {
						//Level.Game.SetPlayerDefaults(C.Pawn);
						If (C.Pawn.GroundSpeed > 500) {
							C.Pawn.AirControl /= 1.4;
							C.Pawn.GroundSpeed /= 1.4;
							C.Pawn.WaterSpeed /= 1.4;
							C.Pawn.AirSpeed /= 1.4;
							C.Pawn.JumpZ /= 1.5;
							C.Pawn.ClientMessage("Bye Bye Speedy");
						}
					}
				}
				return;
			} else if (target == ""){
				P = verifyTarget(target);
				If (P.GroundSpeed > 500) {
					P.AirControl /= 1.4;
					P.GroundSpeed /= 1.4;
					P.WaterSpeed /= 1.4;
					P.AirSpeed /= 1.4;
					P.JumpZ /= 1.5;
					P.ClientMessage("Bye Bye Speedy");
				}
				return;
			} else {
				P = verifyTarget(target);
				if (P == none){
					return;
				}
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController') || C.IsA('xBot')) {
						namematch = InStr( Caps(C.PlayerReplicationInfo.PlayerName), Caps(target));
						if (namematch >=0) {
							//Level.Game.SetPlayerDefaults(C.Pawn);
							If (C.Pawn.GroundSpeed > 500) {
								C.Pawn.AirControl /= 1.4;
								C.Pawn.GroundSpeed /= 1.4;
								C.Pawn.WaterSpeed /= 1.4;
								C.Pawn.AirSpeed /= 1.4;
								C.Pawn.JumpZ /= 1.5;
								C.Pawn.ClientMessage("Bye Bye Speedy");
							}
						}
					}
				}
			}
			//if (LeftTrail != None){
				log("lefttraildestroy");
				LeftTrail.Destroy();
			//}
			//if (RightTrail != None){
				RightTrail.Destroy();
			//}
		}
	}
}

exec function InvisComboOn(string target){

	local Mutator myMut;
	local Pawn P;
	local Controller C;
	local int namematch;
	//local xPawn XP;

	myMut = findMut(Level.Game.BaseMutator, class'AdminPlusMut');
	if (myMut != none) {
		if (AdminPlusMut(myMut).CombosEnabled()){

			if (target == "all") {
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController') || C.IsA('xBot')) {
						C.Pawn.ClientMessage("Invisibility Combo");
						xPawn(C.Pawn).SetInvisibility(80.0);
					}
				}
				return;
			} else if (target == ""){
				P = verifyTarget(target);
				xPawn(P).SetInvisibility(80.0);
				P.ClientMessage("Invisibility Combo");
				return;
			} else {
				P = verifyTarget(target);
				if (P == none){
					return;
				}
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController') || C.IsA('xBot')) {
						namematch = InStr( Caps(C.PlayerReplicationInfo.PlayerName), Caps(target));
						if (namematch >=0) {
							C.Pawn.ClientMessage("Invisibility Combo");
							xPawn(C.Pawn).SetInvisibility(80.0);
						}
					}
				}
			}
		}
	}
}

exec function InvisComboOff(string target){

	local Mutator myMut;
	local Pawn P;
	local Controller C;
	local int namematch;
	//local xPawn XP;

	myMut = findMut(Level.Game.BaseMutator, class'AdminPlusMut');
	if (myMut != none) {
		if (AdminPlusMut(myMut).CombosEnabled()){

			if (target == "all") {
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController') || C.IsA('xBot')) {
						C.Pawn.ClientMessage("Visible");
						xPawn(C.Pawn).SetInvisibility (0.0);
					}
				}
				return;
			} else if (target == ""){
				P = verifyTarget(target);
				xPawn(P).SetInvisibility(0.0);
				P.ClientMessage("Visible");
				return;
			} else {
				P = verifyTarget(target);
				if (P == none){
					return;
				}
				for( C = Level.ControllerList; C != None; C = C.nextController ) {
					if( C.IsA('PlayerController') || C.IsA('xBot')) {
						namematch = InStr( Caps(C.PlayerReplicationInfo.PlayerName), Caps(target));
						if (namematch >=0) {
							C.Pawn.ClientMessage("Invisible");
							xPawn(C.Pawn).SetInvisibility (0.0);
						}
					}
				}
			}
		}
	}
}*/


//=========================================================================

defaultproperties
{
	 MSG_LoadedOn="You Have Been Loaded with KF Weapons"
	 MSG_GodOn="You are in God mode."
	 MSG_GodOff="You are no longer in God Mode."
	 MSG_Ghost="You feel Ethereal"
	 MSG_Fly="You feel much lighter"
	 MSG_ChangeScore="AdminPlus(Private): The Admin has changed your score."
	 MSG_Spider="You are in Spider Mode, walk up the walls, but avoid jumping (buggy)."
	 MSG_Walk="You are in normal walking mode."
	 MSG_InvisOn="You are now Invisible."
	 MSG_InvisOff="You are no longer Invisible. We Can See You."
	 MSG_TempAdmin="You can now Log in as a Temporary Admin. Just type: adminlogin in the console."
	 MSG_TempAdminOff="You are no longer Logged In as an Admin."
	 MSG_ChangeName="Your Name has been changed."
	 MSG_ChangeSize="You are experiencing an extreme bodily change."
	 MSG_GiveItem="You have been given a gift from the Admin!"
	 MSG_Adrenaline="You Have been given Full Adrenaline!"
	 MSG_Help1="This is a complete list of commands. (Some may be disabled in the ini)"
	 MSG_Help2="Always put admin in front of the command you want. Ex: admin ghost"
	 MSG_Help3="Ghost/Walk/Spider/Fly are disabled for bots, it makes them act weird"
	 MSG_Help4="MOST COMMANDS CAN BE ISSUED TO OTHERS BY NAME, PARTIAL NAME, or 'ALL'"
	 MSG_Help5="Examples: Admin Loaded Brockster, Admin Ghost Broc, Admin Godon All"
	 MSG_Help6="--------------------------------------------------------------------------------"
	 MSG_Help7="GodOn / Godoff - Invulnerability | Ex: ' admin GodOn all '"
	 MSG_Help8="InvisOn / InvisOff - Invisibility | Ex: ' admin GodOff Brock '"
	 MSG_Help9="Loaded - To give all weapon | Ex: ' admin Loaded all '"
	 MSG_Help10="Help - To deduce the information | Ex: ' admin help '"
	 MSG_Help11="Ghost - the Mode of circulation through walls | Ex: ' admin ghost Jakob '"
	 MSG_Help12="Fly - a mode of flight | Ex: ' admin fly Jak '"
	 MSG_Help13="Spider - the Mode of a spider (circulation on walls) | Ex: ' admin spider Luna '"
	 MSG_Help14="Walk - To return to a mode of walking | Ex: ' admin walk all '"
	 MSG_Help15="Fatality - Take Revenge On a Player | CauseEvent - Trigger an In-Game Event"
	 MSG_Help16="InvisComboOn/InvisComboOff - Toggle Invisi Combo"
	 MSG_Help17="CrateComboOn/CrateComboOff - Toggle Crate Combo"
	 MSG_Help18="SpeedComboOn/SpeedComboOff - Toggle Speed Combo"
	 MSG_Help19="Slap <target_nick> - Шлепнуть the player"
	 MSG_Help20="CustomLoaded1,2,3 - Loads Custom Weapons that you set in the server ini file"
	 MSG_Help21="TempAdmin - Grants Temporary Admin Status (Only Works on Single Admin Systems"
	 MSG_Help22="TempAdminOff - Removes Temporary Admin Status (Only Works on Single Admin Systems"
	 MSG_Help23="ChangeName <old_name> <new_name> - To change a name of the player"
	 MSG_Help24="HeadSize <target_name> <size> - To change the size of a head of the player (1=по to default)"
	 MSG_Help25="PlayerSize <target_name> <size> - To change the size of the player (1=по to default)"
	 MSG_Help26="GiveItem [weaponclass] - To give the weapon or full adrenaline to the player"
	 MSG_Help27="Summon <class> - To cause the monster before itself"
	 MSG_Help28="AdvancedSummon <class> <target_name> - To cause the monster near to the player"
	 MSG_Help29="ChangeScore <target_nick> <new_score_value>"
	 MSG_Help30="ResetScore - To dump quantity of money at the player"
	 MSG_Help31="Respawn <target> - To restore the player or all"
	 MSG_Help32="SetGravity <gravity> - Variation of gravitation (-950=по to default)"
	 MSG_Help33="Teleport - a teleport on a surface at which look"
	 MSG_Help34="PrivMessage/PM - Allows to send the message to separate players"
	 MSG_Help35="DNO - To disconnect Next Objective In Assault Games"
	 MSG_ReSpawned="You're back in the game!"
	 MSG_CantRespawn="I can't респавнить players between waves"
}
