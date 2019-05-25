class L96AWPLLI extends KFWeapon;

#exec OBJ LOAD FILE="L96AWPLLI_A.ukx"

var() 		name 			ReloadShortAnim;
var() 		float 			ReloadShortRate;
var color ChargeColor;
var float Range;
var float LastRangingTime;
var() Material ZoomMat;
var() Sound ZoomSound;
var bool bArrowRemoved;
var()		int			lenseMaterialID;
var()		float		scopePortalFOVHigh;
var()		float		scopePortalFOV;
var()       vector      XoffsetScoped;
var()       vector      XoffsetHighDetail;
var()		int			scopePitch;
var()		int			scopeYaw;
var()		int			scopePitchHigh;
var()		int			scopeYawHigh;
var   ScriptedTexture   ScopeScriptedTexture;
var	  Shader		    ScopeScriptedShader;
var   Material          ScriptedTextureFallback;
var     Combiner            ScriptedScopeCombiner;
var     Combiner            ScriptedScopeStatic;
var     texture             TexturedScopeTexture;
var	    bool				bInitializedScope;
var()           class<Emitter>  ShellEjectNewClass;
var()           Emitter         ShellEjectNewEmitter;
var()           name            ShellEjectNewBoneName;


function float GetAIRating()
{
	local Bot B;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return AIRating;

	return AIRating;
}

function byte BestMode()
{
	return 0;
}
exec function pfov(int thisFOV)
{
	if( !class'ROEngine.ROLevelInfo'.static.RODebugMode() )
		return;

	scopePortalFOV = thisFOV;
}

exec function pPitch(int num)
{
	if( !class'ROEngine.ROLevelInfo'.static.RODebugMode() )
		return;

	scopePitch = num;
	scopePitchHigh = num;
}

exec function pYaw(int num)
{
	if( !class'ROEngine.ROLevelInfo'.static.RODebugMode() )
		return;

	scopeYaw = num;
	scopeYawHigh = num;
}

simulated exec function TexSize(int i, int j)
{
	if( !class'ROEngine.ROLevelInfo'.static.RODebugMode() )
		return;

	ScopeScriptedTexture.SetSize(i, j);
}

simulated function bool ShouldDrawPortal()
{
	if( bAimingRifle )
		return true;
	else
		return false;
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	KFScopeDetail = class'KFWeapon'.default.KFScopeDetail;

	UpdateScopeMode();
}
simulated function UpdateScopeMode()
{
	if (Level.NetMode != NM_DedicatedServer && Instigator != none && Instigator.IsLocallyControlled() &&
		Instigator.IsHumanControlled() )
	{
		if( KFScopeDetail == KF_ModelScope )
		{
			scopePortalFOV = default.scopePortalFOV;
			ZoomedDisplayFOV = default.ZoomedDisplayFOV;
			//bPlayerFOVZooms = false;
			if (bUsingSights)
			{
				PlayerViewOffset = XoffsetScoped;
			}

			if( ScopeScriptedTexture == none )
			{
				ScopeScriptedTexture = ScriptedTexture(Level.ObjectPool.AllocateObject(class'ScriptedTexture'));
			}

			ScopeScriptedTexture.FallBackMaterial = ScriptedTextureFallback;
			ScopeScriptedTexture.SetSize(512,512);
			ScopeScriptedTexture.Client = Self;

			if( ScriptedScopeCombiner == none )
			{
				ScriptedScopeCombiner = Combiner(Level.ObjectPool.AllocateObject(class'Combiner'));
				ScriptedScopeCombiner.Material1 = Texture'L96AWPLLI_A.L96AWPLLI_T.L96AWPLLI_scope';
				ScriptedScopeCombiner.FallbackMaterial = Shader'ScopeShaders.Zoomblur.LensShader';
				ScriptedScopeCombiner.CombineOperation = CO_Multiply;
				ScriptedScopeCombiner.AlphaOperation = AO_Use_Mask;
				ScriptedScopeCombiner.Material2 = ScopeScriptedTexture;
			}

			if( ScriptedScopeStatic == none )
			{
				// Construct the Combiner
				ScriptedScopeStatic = Combiner(Level.ObjectPool.AllocateObject(class'Combiner'));
	            ScriptedScopeStatic.Material1 = Texture'L96AWPLLI_A.L96AWPLLI_T.L96AWPLLI_scope_dot';
	            ScriptedScopeStatic.FallbackMaterial = Shader'ScopeShaders.Zoomblur.LensShader';
	            ScriptedScopeStatic.CombineOperation = CO_Add;
	            ScriptedScopeStatic.AlphaOperation = AO_Use_Mask;
	            ScriptedScopeStatic.Material2 = ScriptedScopeCombiner;
	        }

			
			if( ScopeScriptedShader == none )
			{
				ScopeScriptedShader = Shader(Level.ObjectPool.AllocateObject(class'Shader'));
				ScopeScriptedShader.Diffuse = ScriptedScopeCombiner;
				ScopeScriptedShader.SelfIllumination = ScriptedScopeStatic;
				ScopeScriptedShader.FallbackMaterial = Shader'ScopeShaders.Zoomblur.LensShader';
			}

			bInitializedScope = true;
		}
		else if( KFScopeDetail == KF_ModelScopeHigh )
		{
			scopePortalFOV = scopePortalFOVHigh;
			ZoomedDisplayFOV = default.ZoomedDisplayFOVHigh;
			if (bUsingSights)
			{
				PlayerViewOffset = XoffsetHighDetail;
			}

			if( ScopeScriptedTexture == none )
			{
				ScopeScriptedTexture = ScriptedTexture(Level.ObjectPool.AllocateObject(class'ScriptedTexture'));
			}
			ScopeScriptedTexture.FallBackMaterial = ScriptedTextureFallback;
			ScopeScriptedTexture.SetSize(1024,1024);
			ScopeScriptedTexture.Client = Self;

			if( ScriptedScopeCombiner == none )
			{
				ScriptedScopeCombiner = Combiner(Level.ObjectPool.AllocateObject(class'Combiner'));
				ScriptedScopeCombiner.Material1 = Texture'L96AWPLLI_A.L96AWPLLI_T.L96AWPLLI_scope';
				ScriptedScopeCombiner.FallbackMaterial = Shader'ScopeShaders.Zoomblur.LensShader';
				ScriptedScopeCombiner.CombineOperation = CO_Multiply;
				ScriptedScopeCombiner.AlphaOperation = AO_Use_Mask;
				ScriptedScopeCombiner.Material2 = ScopeScriptedTexture;
			}

			if( ScriptedScopeStatic == none )
			{
				// Construct the Combiner
				ScriptedScopeStatic = Combiner(Level.ObjectPool.AllocateObject(class'Combiner'));
	            ScriptedScopeStatic.Material1 = Texture'L96AWPLLI_A.L96AWPLLI_T.L96AWPLLI_scope_dot';
	            ScriptedScopeStatic.FallbackMaterial = Shader'ScopeShaders.Zoomblur.LensShader';
	            ScriptedScopeStatic.CombineOperation = CO_Add;
	            ScriptedScopeStatic.AlphaOperation = AO_Use_Mask;
	            ScriptedScopeStatic.Material2 = ScriptedScopeCombiner;
	        }

						
			if( ScopeScriptedShader == none )
			{
				ScopeScriptedShader = Shader(Level.ObjectPool.AllocateObject(class'Shader'));
				ScopeScriptedShader.Diffuse = ScriptedScopeCombiner;
				ScopeScriptedShader.SelfIllumination = ScriptedScopeStatic;
				ScopeScriptedShader.FallbackMaterial = Shader'ScopeShaders.Zoomblur.LensShader';
			}

			bInitializedScope = true;
		}
		else if (KFScopeDetail == KF_TextureScope)
		{
			ZoomedDisplayFOV = default.ZoomedDisplayFOV;
			PlayerViewOffset.X = default.PlayerViewOffset.X;

			bInitializedScope = true;
		}
	}
}

simulated event RenderTexture(ScriptedTexture Tex)
{
	local rotator RollMod;

	RollMod = Instigator.GetViewRotation();

	if(Owner != none && Instigator != none && Tex != none && Tex.Client != none)
		Tex.DrawPortal(0,0,Tex.USize,Tex.VSize,Owner,(Instigator.Location + Instigator.EyePosition()), RollMod,  scopePortalFOV );
}

simulated function SetZoomBlendColor(Canvas c)
{
	local Byte    val;
	local Color   clr;
	local Color   fog;

	clr.R = 255;
	clr.G = 255;
	clr.B = 255;
	clr.A = 255;

	if( Instigator.Region.Zone.bDistanceFog )
	{
		fog = Instigator.Region.Zone.DistanceFogColor;
		val = 0;
		val = Max( val, fog.R);
		val = Max( val, fog.G);
		val = Max( val, fog.B);
		if( val > 128 )
		{
			val -= 128;
			clr.R -= val;
			clr.G -= val;
			clr.B -= val;
		}
	}
	c.DrawColor = clr;
}

simulated function ZoomIn(bool bAnimateTransition)
{
	super(BaseKFWeapon).ZoomIn(bAnimateTransition);

	bAimingRifle = True;

	if( KFHumanPawn(Instigator)!=None )
		KFHumanPawn(Instigator).SetAiming(True);

	if( Level.NetMode != NM_DedicatedServer && KFPlayerController(Instigator.Controller) != none )
	{
		if( AimInSound != none )
		{
			PlayOwnedSound(AimInSound, SLOT_Interact,,,,, false);
		}
	}
}

simulated function ZoomOut(bool bAnimateTransition)
{
	super.ZoomOut(bAnimateTransition);

	bAimingRifle = False;

	if( KFHumanPawn(Instigator)!=None )
		KFHumanPawn(Instigator).SetAiming(False);

	if( Level.NetMode != NM_DedicatedServer && KFPlayerController(Instigator.Controller) != none )
	{
		if( AimOutSound != none )
		{
			PlayOwnedSound(AimOutSound, SLOT_Interact,,,,, false);
		}
		KFPlayerController(Instigator.Controller).TransitionFOV(KFPlayerController(Instigator.Controller).DefaultFOV,0.0);
	}
}

simulated function WeaponTick(float dt)
{
	super.WeaponTick(dt);

	if( bAimingRifle && ForceZoomOutTime > 0 && Level.TimeSeconds - ForceZoomOutTime > 0 )
	{
		ForceZoomOutTime = 0;

		ZoomOut(false);

		if( Role < ROLE_Authority)
			ServerZoomOut(false);
	}
}

simulated event OnZoomInFinished()
{
	local name anim;
	local float frame, rate;

	GetAnimParams(0, anim, frame, rate);

	if (ClientState == WS_ReadyToFire)
	{
		if (anim == IdleAnim)
		{
		PlayIdle();
		}
	}

	if( Level.NetMode != NM_DedicatedServer && KFPlayerController(Instigator.Controller) != none &&
		KFScopeDetail == KF_TextureScope )
	{
		KFPlayerController(Instigator.Controller).TransitionFOV(PlayerIronSightFOV,0.0);
	}
}

simulated function bool CanZoomNow()
{
	Return (!FireMode[0].bIsFiring && Instigator!=None && Instigator.Physics!=PHYS_Falling);
}

simulated event RenderOverlays(Canvas Canvas)
{
	local int m;
	local PlayerController PC;

	if (Instigator == None)
		return;

	PC = PlayerController(Instigator.Controller);

	if(PC == None)
		return;

	if(!bInitializedScope && PC != none )
	{
		UpdateScopeMode();
	}

	Canvas.DrawActor(None, false, true);

	for (m = 0; m < NUM_FIRE_MODES; m++)
	{
		if (FireMode[m] != None)
		{
			FireMode[m].DrawMuzzleFlash(Canvas);
		}
	}


	SetLocation( Instigator.Location + Instigator.CalcDrawOffset(self) );
	SetRotation( Instigator.GetViewRotation() + ZoomRotInterp);

	PreDrawFPWeapon();

	if(bAimingRifle && PC != none && (KFScopeDetail == KF_ModelScope || KFScopeDetail == KF_ModelScopeHigh))
	{
		if (ShouldDrawPortal())
		{
			if ( ScopeScriptedTexture != none )
			{
				Skins[LenseMaterialID] = ScopeScriptedShader;
				ScopeScriptedTexture.Client = Self;
				ScopeScriptedTexture.Revision = (ScopeScriptedTexture.Revision +1);
			}
		}

		bDrawingFirstPerson = true;
		Canvas.DrawBoundActor(self, false, false,DisplayFOV,PC.Rotation,rot(0,0,0),Instigator.CalcZoomedDrawOffset(self));
		bDrawingFirstPerson = false;
	}
	else if( KFScopeDetail == KF_TextureScope && PC.DesiredFOV == PlayerIronSightFOV && bAimingRifle)
	{
		Skins[LenseMaterialID] = ScriptedTextureFallback;

		SetZoomBlendColor(Canvas);

		Canvas.Style = ERenderStyle.STY_Normal;
		Canvas.SetPos(0, 0);
		Canvas.DrawTile(ZoomMat, (Canvas.SizeX - Canvas.SizeY) / 2, Canvas.SizeY, 0.0, 0.0, 8, 8);
		Canvas.SetPos(Canvas.SizeX, 0);
		Canvas.DrawTile(ZoomMat, -(Canvas.SizeX - Canvas.SizeY) / 2, Canvas.SizeY, 0.0, 0.0, 8, 8);

		Canvas.Style = 255;
		Canvas.SetPos((Canvas.SizeX - Canvas.SizeY) / 2,0);
		Canvas.DrawTile(ZoomMat, Canvas.SizeY, Canvas.SizeY, 0.0, 0.0, 1024, 1024);

		Canvas.Font = Canvas.MedFont;
		Canvas.SetDrawColor(200,150,0);

		Canvas.SetPos(Canvas.SizeX * 0.16, Canvas.SizeY * 0.43);
		Canvas.DrawText(" ");

		Canvas.SetPos(Canvas.SizeX * 0.16, Canvas.SizeY * 0.47);
	}
	else
	{
		Skins[LenseMaterialID] = ScriptedTextureFallback;
		bDrawingFirstPerson = true;
		Canvas.DrawActor(self, false, false, DisplayFOV);
		bDrawingFirstPerson = false;
	}
}

simulated function AdjustIngameScope()
{
	local PlayerController PC;

	PC = PlayerController(Instigator.Controller);

	if( !bHasScope )
		return;

	switch (KFScopeDetail)
	{
		case KF_ModelScope:
			if( bAimingRifle )
				DisplayFOV = default.ZoomedDisplayFOV;
			if ( PC.DesiredFOV == PlayerIronSightFOV && bAimingRifle )
			{
				if( Level.NetMode != NM_DedicatedServer && KFPlayerController(Instigator.Controller) != none )
				{
					KFPlayerController(Instigator.Controller).TransitionFOV(KFPlayerController(Instigator.Controller).DefaultFOV,0.0);
}
			}
			break;

		case KF_TextureScope:
			if( bAimingRifle )
				DisplayFOV = default.ZoomedDisplayFOV;
			if ( bAimingRifle && PC.DesiredFOV != PlayerIronSightFOV )
			{
				if( Level.NetMode != NM_DedicatedServer && KFPlayerController(Instigator.Controller) != none )
				{
					KFPlayerController(Instigator.Controller).TransitionFOV(PlayerIronSightFOV,0.0);
				}
			}
			break;

		case KF_ModelScopeHigh:
			if( bAimingRifle )
			{
				if( ZoomedDisplayFOVHigh > 0 )
					DisplayFOV = default.ZoomedDisplayFOVHigh;
				else
					DisplayFOV = default.ZoomedDisplayFOV;
			}
			if ( bAimingRifle && PC.DesiredFOV == PlayerIronSightFOV )
			{
				if( Level.NetMode != NM_DedicatedServer && KFPlayerController(Instigator.Controller) != none )
				{
					KFPlayerController(Instigator.Controller).TransitionFOV(KFPlayerController(Instigator.Controller).DefaultFOV,0.0);
				}
			}
			break;
	}

	UpdateScopeMode();
}

simulated event Destroyed()
{
	if (ScopeScriptedTexture != None)
	{
		ScopeScriptedTexture.Client = None;
		Level.ObjectPool.FreeObject(ScopeScriptedTexture);
		ScopeScriptedTexture=None;
	}

	if (ScriptedScopeCombiner != None)
	{
		ScriptedScopeCombiner.Material2 = none;
		Level.ObjectPool.FreeObject(ScriptedScopeCombiner);
		ScriptedScopeCombiner = none;
	}

	if (ScopeScriptedShader != None)
	{
		ScopeScriptedShader.Diffuse = none;
		ScopeScriptedShader.SelfIllumination = none;
		Level.ObjectPool.FreeObject(ScopeScriptedShader);
		ScopeScriptedShader = none;
	}

	Super.Destroyed();
}

simulated function PreTravelCleanUp()
{
	if (ScopeScriptedTexture != None)
	{
		ScopeScriptedTexture.Client = None;
		Level.ObjectPool.FreeObject(ScopeScriptedTexture);
		ScopeScriptedTexture=None;
	}

	if (ScriptedScopeCombiner != None)
	{
		ScriptedScopeCombiner.Material2 = none;
		Level.ObjectPool.FreeObject(ScriptedScopeCombiner);
		ScriptedScopeCombiner = none;
	}

	if (ScopeScriptedShader != None)
	{
		ScopeScriptedShader.Diffuse = none;
		ScopeScriptedShader.SelfIllumination = none;
		Level.ObjectPool.FreeObject(ScopeScriptedShader);
		ScopeScriptedShader = none;
	}
}

simulated function Notify_ShowBullets()
{
	local int AvailableAmmo;
	
	AvailableAmmo = AmmoAmount(0);

	if (AvailableAmmo == 0)
	{
		SetBoneScale (0, 0.0, 'Bullet_LLIePLLIeHb');
	}
	else
	{
		SetBoneScale (0, 1.0, 'Bullet_LLIePLLIeHb');
	}
}

simulated function Notify_HideBullets()
{
	if (MagAmmoRemaining <= 0)
	{
		SetBoneScale (0, 0.0, 'Bullet_LLIePLLIeHb');
	}
}

exec function ReloadMeNow()
{
	local float ReloadMulti;

	if(!AllowReload())
		return;

	if ( bHasAimingMode && bAimingRifle )
	{
		FireMode[1].bIsFiring = False;

		ZoomOut(false);
		if( Role < ROLE_Authority)
			ServerZoomOut(false);
	}

	if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != none && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != none )
	{
		ReloadMulti = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.Static.GetReloadSpeedModifier(KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo), self);
	}
	else
	{
		ReloadMulti = 1.0;
	}

	bIsReloading = true;
	ReloadTimer = Level.TimeSeconds;
	if (MagAmmoRemaining <= 0)
	{
		ReloadRate = Default.ReloadRate / ReloadMulti;
	}
	else if (MagAmmoRemaining >= 1)
	{
		ReloadRate = Default.ReloadShortRate / ReloadMulti;
	}

	if( bHoldToReload )
	{
		NumLoadedThisReload = 0;
	}

	ClientReload();
	Instigator.SetAnimAction(WeaponReloadAnim);

	if ( Level.Game.NumPlayers > 1 && KFGameType(Level.Game).bWaveInProgress && KFPlayerController(Instigator.Controller) != none &&
		Level.TimeSeconds - KFPlayerController(Instigator.Controller).LastReloadMessageTime > KFPlayerController(Instigator.Controller).ReloadMessageDelay )
	{
		KFPlayerController(Instigator.Controller).Speech('AUTO', 2, "");
		KFPlayerController(Instigator.Controller).LastReloadMessageTime = Level.TimeSeconds;
	}
}

simulated function ClientReload()
{
	local float ReloadMulti;

	if ( bHasAimingMode && bAimingRifle )
	{
		FireMode[1].bIsFiring = False;

		ZoomOut(false);
		if( Role < ROLE_Authority)
			ServerZoomOut(false);
	}

	if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != none && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != none )
	{
		ReloadMulti = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.Static.GetReloadSpeedModifier(KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo), self);
	}
	else
	{
		ReloadMulti = 1.0;
	}

	bIsReloading = true;
	if (MagAmmoRemaining <= 0)
	{
		PlayAnim(ReloadAnim, ReloadAnimRate*ReloadMulti, 0.1);
	}
	else if (MagAmmoRemaining >= 1)
	{
		PlayAnim(ReloadShortAnim, ReloadAnimRate*ReloadMulti, 0.1);
	}
}
simulated function Notify_Shell()
{
    if ( KFFire(FireMode[0]).ShellEjectEmitter != None )
    {
        KFFire(FireMode[0]).ShellEjectEmitter.Trigger(Self, Instigator);
    }
}

defaultproperties
{
	FlashBoneName="tip_LLIePLLIeHb"
	ReloadShortAnim="Reload_LLI"
	ReloadShortRate=3.500000
	ZoomMat=FinalBlend'L96AWPLLI_A.L96AWPLLI_T.L96AWPLLI_scope_FB'
	lenseMaterialID=3
	scopePortalFOVHigh=12.000000
	scopePortalFOV=12.000000
	ScriptedTextureFallback=Texture'L96AWPLLI_A.L96AWPLLI_T.AlphaLens'
	bHasScope=True
	ZoomedDisplayFOVHigh=32.000000
	MagCapacity=10
	ReloadRate=4.200000
	ReloadAnim="Reload"
	ReloadAnimRate=1.000000
	WeaponReloadAnim="Reload_M14"
	HudImage=Texture'L96AWPLLI_A.L96AWPLLI_T.L96AWPLLI_Unselected'
	SelectedHudImage=Texture'L96AWPLLI_A.L96AWPLLI_T.L96AWPLLI_selected'
	Weight=7.000000
	bHasAimingMode=True
	IdleAimAnim="Idle_Iron"
	StandardDisplayFOV=65.000000
	bModeZeroCanDryFire=True
	TraderInfoTexture=Texture'L96AWPLLI_A.L96AWPLLI_T.L96AWPLLI_Trader'
	PlayerIronSightFOV=22.000000
	ZoomedDisplayFOV=32.000000
	FireModeClass(0)=Class'ApocMutators.L96AWPLLIFire'
	FireModeClass(1)=Class'ApocMutators.L96AWPLLIFireB'
	PutDownAnim="PutDown"
	BringUpTime=0.930000
	SelectSound=Sound'L96AWPLLI_A.L96AWPLLI_Snd.L96AWPLLI_select'
	SelectForce="SwitchToAssaultRifle"
	AIRating=0.650000
	CurrentRating=0.650000
	Description="The Accuracy International Arctic Warfare rifle is a family of bolt-action sniper rifles designed and manufactured by the British company Accuracy International."
	DisplayFOV=65.000000
	Priority=140
	CustomCrosshair=11
	CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross5"
	InventoryGroup=4
	GroupOffset=3
	PickupClass=Class'ApocMutators.L96AWPLLIPickup'
	PlayerViewOffset=(X=10.000000,Y=22.000000,Z=-10.000000)
	BobDamping=6.000000
	AttachmentClass=Class'ApocMutators.L96AWPLLIAttachment'
	IconCoords=(X1=253,Y1=146,X2=333,Y2=181)
	ItemName="L96 AWP"
	Mesh=SkeletalMesh'L96AWPLLI_A.L96AWPLLI_mesh'
	Skins(0)=Combiner'L96AWPLLI_A.L96AWPLLI_T.L96AWPLLI_tex_1_cmb'
	Skins(1)=Texture'KF_Weapons3_Trip_T.hands.Priest_Hands_1st_P'
	Skins(2)=Combiner'L96AWPLLI_A.L96AWPLLI_T.L96AWPLLI_tex_2_cmb'
	Skins(3)=Texture'L96AWPLLI_A.L96AWPLLI_T.AlphaLens'
}