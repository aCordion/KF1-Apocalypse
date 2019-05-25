Class HL2WeaponAttachment extends KFWeaponAttachment
	Abstract;

var() class<Actor> WallHitEffect;

static function PreloadAssets(optional KFWeaponAttachment Spawned);
static function bool UnloadAssets();

function UpdateHit(Actor HitActor, vector HitLocation, vector HitNormal)
{
	if( VSizeSquared(mHitLocation-HitLocation)<1.f )
		mHitLocation+=VRand();
	else mHitLocation = HitLocation;
	if( Level.NetMode!=NM_DedicatedServer )
		DrawTraceHit(GetTracerStart(),HitLocation,HitNormal,HitActor);
	NetUpdateTime = Level.TimeSeconds - 1;
}
simulated function DoFlashEmitter()
{
    if (mMuzFlash3rd == None)
    {
        mMuzFlash3rd = Spawn(mMuzFlashClass);
        AttachToBone(mMuzFlash3rd, 'Muz');
    }
    if(mMuzFlash3rd != None)
        mMuzFlash3rd.SpawnParticle(1);
}

simulated function PostNetReceive()
{
	if( Instigator!=LastInstig )
	{
		LastInstig = Instigator;
		if( KFPawn(Instigator)!=None )
			KFPawn(Instigator).SetWeaponAttachment(self);
	}
	if( mHitLocation!=vect(0,0,0) )
	{
		if( Instigator!=None )
			ClientCheckTrace();
		mHitLocation = vect(0,0,0);
	}
}
simulated function PostNetBeginPlay()
{
	Super(BaseKFWeaponAttachment).PostNetBeginPlay();

	LastInstig = Instigator;
	mHitLocation = vect(0,0,0);
	bNetNotify = True;
}

simulated final function ClientCheckTrace()
{
	local vector Start,X,HL,HN;
	local Actor A;

	Start = GetTracerStart();
	X = Normal(mHitLocation-Start);
	A = Instigator.Trace(HL,HN,mHitLocation+X*25,mHitLocation-X*10,true);
	if( A!=None )
		mHitLocation = HL;

	if( ExtendedZCollision(A)!=None )
		A = A.Owner;
	DrawTraceHit(Start,mHitLocation,HN,A);

	if( A!=None ) // Do client side damage to allow dismemeber the bodies.
		A.TakeDamage(25, Instigator, mHitLocation, 2000.f*X,Class'DamageType');
}
simulated function DrawTraceHit( vector Start, vector HL, vector HN, Actor Other )
{
	if( Other!=None && WallHitEffect!=None && (Pawn(Other)==None || Vehicle(Other)!=None) )
		Spawn(WallHitEffect,,,HL,Rotator(-HN));

	SpawnTracer();
	WeaponLight();
	KFPawn(Instigator).StartFiringX(false,false);
	CheckForSplash();
	DoFlashEmitter();
}

simulated event ThirdPersonEffects()
{
	local PlayerController PC;

	if ( (Level.NetMode == NM_DedicatedServer) || (Instigator == None) )
		return;

  	if ( FlashCount>0 )
	{
		if( KFPawn(Instigator)!=None )
			KFPawn(Instigator).StartFiringX((FiringMode!=0),bRapidFire);

		if( bDoFiringEffects )
		{
    		PC = Level.GetLocalPlayerController();

    		if ( (Level.TimeSeconds - LastRenderTime > 0.2) && (Instigator.Controller != PC) )
    			return;

    		WeaponLight();
    		DoFlashEmitter();
		}
	}
	else
	{
		GotoState('');
		if( KFPawn(Instigator)!=None )
			KFPawn(Instigator).StopFiring();
	}
}

defaultproperties
{
     WallHitEffect=Class'ROEffects.ROBulletHitEffect'
     mTracerClass=Class'ApocMutators.FX_HL2Tracer'
     SplashEffect=Class'ROEffects.BulletSplashEmitter'
     DrawScale=1.300000
}
