class DamagePopup extends xEmitter;

// Special
// 0: No special effect
// 1: Falling effect
// 2: Popup effect


var int Damage;
var color FontColor;
var ScriptedTexture STexture;
var TexRotator TexRot;

var Material	StextureFallBack;
var Font DrawFont;
var bool bInit;

replication
{
	reliable if(Role==ROLE_Authority )
         FontColor,Damage,ShowDamage;
}

static function ShowDamage(actor dest, vector ShowLocation, int sDamage, optional int Special, optional color pColor)
{
	local DamagePopup p;
	//if (sDamage < 0) return;
	//if(dest==none) return;

	ShowLocation.X = ShowLocation.X + 30*FRand() - 30*FRand();
	ShowLocation.Y = ShowLocation.Y + 30*FRand() - 30*FRand();
	ShowLocation.Z = ShowLocation.Z + 30 + 30*Frand() - 30*FRand();

	p = dest.spawn(class'DamagePopup',,,ShowLocation,rot(16384,0,0));

	p.Damage=sDamage;
 	p.FontColor=pColor;

	Special = 2;
	switch (2) {
	case 0:
		break;
	case 1:
		p.SetPhysics(PHYS_Falling);
		break;
	case 2:
		p.Velocity.z = -dest.PhysicsVolume.Gravity.z*0.05;
		p.SetPhysics(PHYS_Falling);
		break;
	}
}


event Destroyed()
{
	if(stexture!=none)
	{
		stexture.Client=none;
		Level.ObjectPool.FreeObject(STexture);
	}
	if(TexRot!=none)
	{
		Level.ObjectPool.FreeObject(TexRot);
	}
	super.Destroyed();
}

simulated event Tick(float dt)
{
	//local HUDKillingFloor HUDKF;
	//HUDKF = HUDKillingFloor(xInterface.Hudbase);

	super.tick(dt);
	if(Damage!=9998 && !bInit)
	{
	STexture = ScriptedTexture(Level.ObjectPool.AllocateObject(class'ScriptedTexture'));
	TexRot = TexRotator(Level.ObjectPool.AllocateObject(class'TexRotator'));
	STexture.SetSize(128,128);
	stexture.FallBackMaterial = stextureFallBack;
	stexture.Client = Self;

	TexRot.Material=stexture;
	TexRot.Rotation.Yaw=8191;
	TexRot.UOffset=64;
	TexRot.VOffset=64;
	DrawFont = Font(DynamicLoadObject("ROFontsTwo.ROArial24DS", class'Font'));
	//	DrawFont = Font(DynamicLoadObject("Engine.DefaultFont", class'Font'));
	//  DrawFont = Font(DynamicLoadObject("UT2003Fonts.FontEurostile14", class'Font'));
	//DrawFont = class'Engine'.GetConsoleFont(Engine.Canvas);
	texture=TexRot;
	Skins[0]=TexRot;
	setRotation(rot(16384,0,0));
	mStartParticles=1;

 		bInit=true;
	}

}
simulated event RenderTexture(ScriptedTexture Tex)
{
    local int SizeX,  SizeY;
    local string text;
    local color BackColor;
	//local HUDKillingFloor HUDKF;

	BackColor.R=0;
    BackColor.G=0;
    BackColor.B=0;
    BackColor.A=0;

	text=string(damage);
	//	log("Damage=" $ damage);

	Tex.TextSize(text, DrawFont, SizeX, SizeY);
	Tex.DrawTile(0, 0, Tex.USize, Tex.VSize, 0, 0, Tex.USize, Tex.VSize, STextureFallback, BackColor);
	Tex.DrawText((Tex.USize - SizeX) * 0.5, 32, text, DrawFont, FontColor);
}

defaultproperties
{
     Damage=9998
     FontColor=(G=128,R=255,A=255)
     DrawFont=Font'ROFontsTwo.ROArial24DS'
     mStartParticles=0
     mMaxParticles=1
     mSpeedRange(0)=300.000000
     mSpeedRange(1)=300.000000
     mMassRange(0)=2.000000
     mMassRange(1)=2.000000
     mAirResistance=1.000000
     mSizeRange(0)=50.000000
     mSizeRange(1)=50.000000
     mAttenuate=False
     DrawType=DT_Sprite
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=2.000000
     Rotation=(Pitch=16383)
     Texture=None
     Skins(0)=None
     Style=STY_Alpha
}
