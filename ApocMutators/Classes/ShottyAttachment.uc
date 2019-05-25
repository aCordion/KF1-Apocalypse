Class ShottyAttachment extends HL2WeaponAttachment;

var array<Emitter> mTracers;
var transient float LastTracerTimer;
var transient byte TracerOffset;

function UpdateHit(Actor HitActor, vector HitLocation, vector HitNormal)
{
	local InstaHitRepPoint R;

	if( Level.NetMode!=NM_DedicatedServer )
	{
		mHitLocation = HitLocation;
		DrawTraceHit(GetTracerStart(),HitLocation,HitNormal,HitActor);
		mHitLocation = vect(0,0,0);
	}
	if( Level.NetMode!=NM_StandAlone )
	{
		R = Spawn(Class'InstaHitRepPoint',,,HitLocation+HitNormal);
		R.Attachment = Self;
	}
}

// Multiple tracers in same tick needs an own actor.
simulated function SpawnTracer()
{
	if( LastTracerTimer!=Level.TimeSeconds )
	{
		LastTracerTimer = Level.TimeSeconds;
		TracerOffset = 0;
	}
	if( mTracers.Length==TracerOffset )
		mTracers.Length = TracerOffset+1;
	if( mTracers[TracerOffset]==None )
		mTracers[TracerOffset] = Spawn(mTracerClass);
	mTracer = mTracers[TracerOffset++];
	Super.SpawnTracer();
}
simulated function Destroyed()
{
	for( TracerOffset=0; TracerOffset<mTracers.Length; ++TracerOffset )
		if( mTracers[TracerOffset]!=None )
			mTracers[TracerOffset].Destroy();
	Super.Destroyed();
}

defaultproperties
{
     mMuzFlashClass=Class'ApocMutators.FX_SMGMuzzle'
     MovementAnims(0)="JogF_Shotgun"
     MovementAnims(1)="JogB_Shotgun"
     MovementAnims(2)="JogL_Shotgun"
     MovementAnims(3)="JogR_Shotgun"
     TurnLeftAnim="TurnL_Shotgun"
     TurnRightAnim="TurnR_Shotgun"
     CrouchAnims(0)="CHwalkF_Shotgun"
     CrouchAnims(1)="CHwalkB_Shotgun"
     CrouchAnims(2)="CHwalkL_Shotgun"
     CrouchAnims(3)="CHwalkR_Shotgun"
     WalkAnims(0)="WalkF_Shotgun"
     WalkAnims(1)="WalkB_Shotgun"
     WalkAnims(2)="WalkL_Shotgun"
     WalkAnims(3)="WalkR_Shotgun"
     CrouchTurnRightAnim="CH_TurnR_Shotgun"
     CrouchTurnLeftAnim="CH_TurnL_Shotgun"
     IdleCrouchAnim="CHIdle_Shotgun"
     IdleWeaponAnim="Idle_Shotgun"
     IdleRestAnim="Idle_Shotgun"
     IdleChatAnim="Idle_Shotgun"
     IdleHeavyAnim="Idle_Shotgun"
     IdleRifleAnim="Idle_Shotgun"
     FireAnims(0)="Fire_Shotgun"
     FireAnims(1)="Fire_Shotgun"
     FireAnims(2)="Fire_Shotgun"
     FireAnims(3)="Fire_Shotgun"
     FireAltAnims(0)="Fire_Shotgun"
     FireAltAnims(1)="Fire_Shotgun"
     FireAltAnims(2)="Fire_Shotgun"
     FireAltAnims(3)="Fire_Shotgun"
     FireCrouchAnims(0)="CHFire_Shotgun"
     FireCrouchAnims(1)="CHFire_Shotgun"
     FireCrouchAnims(2)="CHFire_Shotgun"
     FireCrouchAnims(3)="CHFire_Shotgun"
     FireCrouchAltAnims(0)="CHFire_Shotgun"
     FireCrouchAltAnims(1)="CHFire_Shotgun"
     FireCrouchAltAnims(2)="CHFire_Shotgun"
     FireCrouchAltAnims(3)="CHFire_Shotgun"
     HitAnims(0)="HitF_Shotgun"
     HitAnims(1)="HitB_Shotgun"
     HitAnims(2)="HitL_Shotgun"
     HitAnims(3)="HitR_Shotgun"
     PostFireBlendStandAnim="Blend_Shotgun"
     PostFireBlendCrouchAnim="CHBlend_Shotgun"
     Mesh=SkeletalMesh'HL2WeaponsA.HL_Shotgun3rd'
     RelativeLocation=(X=14.000000)
     RelativeRotation=(Yaw=-16384)
}
