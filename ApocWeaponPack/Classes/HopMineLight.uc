Class HopMineLight extends Effects
	transient;

var byte ModeIndex;
var() Material Dots[3];
var Sound MineActiveSound,MineDeactivateSound;

simulated final function SetMode( bool bA, bool bB )
{
	local byte i;

	if( bB )
		i = 2;
	else if( bA )
		i = 1;
	else i = 0;

	if( i==ModeIndex )
		return;
	Texture = Dots[i];
	ModeIndex = i;
	if( ModeIndex==0 )
	{
		PlaySound(MineDeactivateSound);
		AmbientSound = None;
	}
	else AmbientSound = MineActiveSound;
}

defaultproperties
{
     Dots(0)=FinalBlend'HopMine_rc.fx.FBBlueDot'
     Dots(1)=FinalBlend'HopMine_rc.fx.FBGreenDot'
     Dots(2)=FinalBlend'HopMine_rc.fx.FBRedDot'
     Texture=FinalBlend'HopMine_rc.fx.FBBlueDot'
     DrawScale=0.035000
     bFullVolume=True
     bHardAttach=True
     SoundVolume=255
     SoundRadius=200.000000
     TransientSoundVolume=2.000000
	 TransientSoundRadius=350.000000
	 MineActiveSound=Sound'combine_mine_active_loop1';
	 MineDeactivateSound=Sound'combine_mine_deactivate1'
}
