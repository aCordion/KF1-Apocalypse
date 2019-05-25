Class AutoRespawnMessage extends LocalMessage;


var localized float MessageShowTime;



static function string GetString(optional int Switch,optional PlayerReplicationInfo RelatedPRI_1,optional PlayerReplicationInfo RelatedPRI_2,optional Object OptionalObject)
{
	local string m;
	if( Switch == 0 )
	{
		m = "You had been respawned!!";
		return m;
	}
	else
	{
		m = "Wait " $ Switch $ " for respawn";
		return m;
	}
}


static function float GetLifeTime(int Switch)
{
	return default.MessageShowTime;
}

static function color GetColor( optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2 )
{
	local color C;

	C.A = 255;
	C.B = Clamp(150,0,255);
	C.G = Clamp(0+Switch*50,0,255);
	return C;
}

static function ClientReceive(PlayerController P, optional int Sw, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
	local HudBase H;
	H = HudBase(P.myHud);
	if ( H!=None )
		H.LocalizedMessage(Default.Class,Sw,RelatedPRI_1,,OptionalObject);
}

defaultproperties
{
     MessageShowTime=5.000000
     bFadeMessage=True
     DrawColor=(B=150,G=0,R=0)
     DrawPivot=DP_UpperLeft
     StackMode=SM_Down
     PosX=0.700000
     PosY=0.200000
     FontSize=2
}
