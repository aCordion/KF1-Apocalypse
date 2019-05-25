//-----------------------------------------------------------
//
//-----------------------------------------------------------
class Weapon_LitesaberFireB extends KFMeleeFire;

defaultproperties
{
     MeleeDamage=500
     ProxySize=0.150000
     weaponRange=130.000000
     DamagedelayMin=0.650000
     DamagedelayMax=0.650000
     HitDamageClass=Class'ApocMutators.Weapon_DamTypeLitesaber'
     MeleeHitSounds(0)=Sound'daforce.LSwall011'
     MeleeHitSounds(1)=Sound'daforce.LSwall021'
     MeleeHitVolume=2.000000
     HitEffectClass=Class'ApocMutators.Weapon_LitesaberHitEffect'
     FireSoundRef="'"
     MeleeHitSoundRefs(0)="'"
     bWaitForRelease=True
     FireAnim="HardAttack"
     FireSound=Sound'daforce.SlowSabr01'
     FireRate=1.000000
     BotRefireRate=0.850000
}
