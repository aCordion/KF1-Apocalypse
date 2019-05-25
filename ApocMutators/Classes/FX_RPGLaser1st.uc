Class FX_RPGLaser1st extends Emitter
	transient;

defaultproperties
{
     Begin Object Class=BeamEmitter Name=BeamEmitter0
         BeamEndPoints(0)=(offset=(X=(Min=64.000000,Max=64.000000)))
         DetermineEndPointBy=PTEP_Offset
         FadeOut=True
         FadeIn=True
         ColorMultiplierRange=(Y=(Min=0.200000,Max=0.200000),Z=(Min=0.200000,Max=0.200000))
         FadeOutStartTime=0.100000
         FadeInEndTime=0.100000
         CoordinateSystem=PTCS_Relative
         MaxParticles=2
         StartSizeRange=(X=(Min=1.000000,Max=1.000000))
         Texture=Texture'Effects_Tex.Weapons.trailblur'
         LifetimeRange=(Min=0.150000,Max=0.150000)
     End Object
     Emitters(0)=BeamEmitter'ApocMutators.FX_RPGLaser1st.BeamEmitter0'

     bNoDelete=False
     RelativeLocation=(X=-10.000000,Y=6.000000)
}
