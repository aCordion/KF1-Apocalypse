class Weapon_LaserDot extends LaserDot;

#exec OBJ LOAD FILE=ScrnTex.utx

var byte LaserColor;
var byte CurrentLaserColor;


simulated function SetLaserColor(byte NewLaserColor)
{
    LaserColor = NewLaserColor;
    CurrentLaserColor = NewLaserColor;

    switch (NewLaserColor) {
    case class'ApocMutators.Weapon_M14EBRBattleRifle'.default.LASER_Red:
        ProjTexture=Texture'ScrnTex.Laser.Laser_Dot_Red';
        break;
    case class'ApocMutators.Weapon_M14EBRBattleRifle'.default.LASER_Green:
        ProjTexture=Texture'ScrnTex.Laser.Laser_Dot_Green';
        break;
    case class'ApocMutators.Weapon_M14EBRBattleRifle'.default.LASER_Blue:
        ProjTexture=Texture'ScrnTex.Laser.Laser_Dot_Blue';
        break;
    case class'ApocMutators.Weapon_M14EBRBattleRifle'.default.LASER_Orange:
        ProjTexture=Texture'ScrnTex.Laser.Laser_Dot_Orange';
        break;
    }
}

// both ToggleDot() and SetValid() are deprecated. Use SetLaserColor() instead
simulated function ToggleDot()
{
     if( ProjTexture== default.ProjTexture )
     {
        ProjTexture = texture'ScrnTex.Laser.Laser_Dot_Green';
     }
     else
     {
        ProjTexture = texture'ScrnTex.Laser.Laser_Dot_Red';
     }
}
simulated function SetValid(bool bNewValid)
{

    if (bNewValid)
        SetLaserColor(class'ApocMutators.Weapon_M14EBRBattleRifle'.default.LASER_Green);
    else
        SetLaserColor(class'ApocMutators.Weapon_M14EBRBattleRifle'.default.LASER_Red);
}

defaultproperties
{
     ProjTexture=Texture'ScrnTex.Laser.Laser_Dot_Blue'
}
