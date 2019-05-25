Class FGrenAltFire extends FGrenFire;

function ModeDoFire()
{
	Super(HL2WeaponFire).ModeDoFire();
	if( Level.NetMode!=NM_Client )
		SetTimer(0.53,false);
}

defaultproperties
{
     ThrowVelocity=(X=300.000000,Z=0.000000)
     ProjSpawnOffset=(Z=-8.000000)
     RandFireAnims(0)="Roll"
}
