//-----------------------------------------------------------
//
//-----------------------------------------------------------
class Weapon_LitesaberFire extends KFMeleeFire;

var() array<name> FireAnims;

simulated event ModeDoFire()
{
    local int AnimToPlay;

    if(FireAnims.length > 0)
    {
        AnimToPlay = rand(FireAnims.length);
        FireAnim = FireAnims[AnimToPlay];
    }

    Super.ModeDoFire();
}

defaultproperties
{
     FireAnims(0)="Fire"
     FireAnims(1)="Fire2"
     FireAnims(2)="fire3"
     FireAnims(3)="Fire4"
     FireAnims(4)="Fire5"
     FireAnims(5)="Fire6"
     MeleeDamage=400
     ProxySize=0.150000
     weaponRange=110.000000
     DamagedelayMin=0.320000
     DamagedelayMax=0.320000
     HitDamageClass=Class'ApocMutators.Weapon_DamTypeLitesaber'
     MeleeHitSounds(0)=Sound'daforce.LSwall011'
     MeleeHitSounds(1)=Sound'daforce.LSwall021'
     MeleeHitVolume=2.000000
     HitEffectClass=Class'ApocMutators.Weapon_LitesaberHitEffect'
     FireSoundRef="'"
     MeleeHitSoundRefs(0)="'"
     FireSound=SoundGroup'daforce.LSswing'
     FireRate=0.67
     BotRefireRate=0.850000
}
