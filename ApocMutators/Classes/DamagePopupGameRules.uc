class DamagePopupGameRules extends GameRules;

var Monster LastDamagePawn;
var int LastDamage;
var DamagePopupMut MutatorOwner;
var Color CfgColor;
var bool bColorSet;

function int NetDamage( int OriginalDamage, int Damage, pawn injured, pawn instigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType )
{
	if ( NextGameRules != None )
		damage= NextGameRules.NetDamage( OriginalDamage,Damage,injured,instigatedBy,HitLocation,Momentum,DamageType );

	if (injured!=none && LastDamagePawn!=none)
	{
		LastDamagePawn=Monster(injured);
		LastDamage+=Damage;
	 	SetTimer(0.01,false);
	}
	else
	{
		if(LastDamagePawn!=none) {
			if(!bColorSet)
			{
			CfgColor.R=MutatorOwner.CfgRed;
			CfgColor.G=MutatorOwner.CfgGreen;
			CfgColor.B=MutatorOwner.CfgBlue;
			CfgColor.A=MutatorOwner.CfgAlpha;
			bColorSet = True;
			}
			class'DamagePopup'.static.showdamage(LastDamagePawn,LastDamagePawn.Location ,LastDamage,,CfgColor);;
		}
		LastDamagePawn=Monster(injured);
		LastDamage=Damage;
	 	SetTimer(0.01,false);
	}
	return Damage;
}

event Timer()
{
	if(LastDamagePawn!=none) {
		if(!bColorSet)
		{
		CfgColor.R=MutatorOwner.CfgRed;
		CfgColor.G=MutatorOwner.CfgGreen;
		CfgColor.B=MutatorOwner.CfgBlue;
		CfgColor.A=MutatorOwner.CfgAlpha;
		bColorSet = True;
		}

		class'DamagePopup'.static.showdamage(LastDamagePawn,LastDamagePawn.Location,LastDamage,,CfgColor);
	}
	LastDamagePawn=none;
	LastDamage=0;
}


function GetServerDetails( out GameInfo.ServerResponseLine ServerState )
{
	// append the gamerules name- only used if mutator adds me and deletes itself.
	local int i;
	i = ServerState.ServerInfo.Length;
	ServerState.ServerInfo.Length = i+1;
	ServerState.ServerInfo[i].Key = "Mutator";
	ServerState.ServerInfo[i].Value = GetHumanReadableName();
}

defaultproperties
{
     CfgColor=(G=128,R=255,A=128)
}
