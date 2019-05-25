Class Doom3KF_D3Karma extends Object
	Config(ApocMonsters)
	PerObjectConfig;

var config bool bRagdolls;
var bool bHasInit, bRagdoll;

static final function InitConfig()
{
	local Doom3KF_D3Karma D;

	Default.bHasInit = true;
	D = New(None, "Doom3Karma") Class'Doom3KF_D3Karma';
	Default.bRagdoll = D.bRagdolls;
	D.SaveConfig();
}
static final function bool UseRagdoll()
{
	if (!Default.bHasInit)
		InitConfig();
	return Default.bRagdoll;
}

defaultproperties
{
}
