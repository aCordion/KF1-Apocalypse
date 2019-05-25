Class FX_FGrenTrail extends XEmitter;

simulated final function Kill()
{
	mRegen = false;
	LifeSpan = 1.5f;
}

defaultproperties
{
     mParticleType=PT_Stream
     mStartParticles=0
     mMaxParticles=100
     mLifeRange(0)=1.500000
     mLifeRange(1)=1.500000
     mRegenRange(0)=20.000000
     mRegenRange(1)=20.000000
     mSpawnVecB=(X=4.000000,Z=0.000000)
     mSpeedRange(0)=0.000000
     mSpeedRange(1)=0.000000
     mSizeRange(0)=5.000000
     mSizeRange(1)=5.000000
     mGrowthRate=3.000000
     mColorRange(0)=(B=50,G=50)
     mColorRange(1)=(B=50,G=50)
     Physics=PHYS_Trailer
     RelativeLocation=(Z=4.000000)
     Skins(0)=Texture'HL2WeaponsA.fx.TransTrailT'
     Style=STY_Additive
     bHardAttach=True
}
