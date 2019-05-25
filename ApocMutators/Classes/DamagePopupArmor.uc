class DamagePopupArmor extends Armor
	abstract;

function armor PrioritizeArmor( int Damage, class<DamageType> DamageType, vector HitLocation )
{
  	log("awawawawawawa");

	return PrioritizeArmor( Damage, DamageType, HitLocation );
}
function int ArmorAbsorbDamage(int Damage, class<DamageType> DamageType, vector HitLocation)
{
	class'DamagePopup'.static.showdamage(self,HitLocation,Damage);
	log("awawawawawawa");
	return ArmorAbsorbDamage(Damage,DamageType,HitLocation);
}

defaultproperties
{
}
