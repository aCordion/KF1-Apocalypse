class MolotovFire extends M79Fire;

#exec OBJ LOAD FILE=KF_AxeSnd.uax

defaultproperties
{
     StereoFireSound=Sound'KF_AxeSnd.AxeFireBase.Axe_Fire1'
     FireSound=Sound'KF_AxeSnd.AxeFireBase.Axe_Fire1'
     NoAmmoSound=Sound'KF_AxeSnd.AxeFireBase.Axe_Fire1'
     FireRate=1.000000
     AmmoClass=class'MolotovAmmo'
     ProjectileClass=class'MolotovProj'
}
