//=============================================================================
// ApocMutatorLoader Source
//=============================================================================
// Made By [APOC]|[TeaM]
// 2019/04/29
//=============================================================================
// Title:
// 	뮤테이터 로더
//
// Description:
// 	ApocMutators.ini 에 기입된 뮤테이터 목록을 로드한다.
//
// Changelogs:
//
//=============================================================================

class ApocMutatorLoader extends Mutator
	config (ApocMutators);

var() config array<string> Mutator;
var() config bool bDebug;
var bool bInitialized;

function PreBeginPlay()
{
	local int i;

	Super.PreBeginPlay();

	if (bInitialized)
		return;
    bInitialized = True;

	for( i=0; i < Mutator.Length; i++ )
	{
		if ((Mutator[i] == "") || (Mutator[i] == "ApocMutators.ApocMutatorLoader"))
		{
			continue;
		}
		else
		{
			Level.Game.AddMutator(Mutator[i],true);
			if (bDebug)
			{
				Log("> [apoc]"@Class.Outer.Name@": Mutator loaded ["$Mutator[i]$"]");
			}
		}
	}
    return;
}

defaultproperties
{
	bDebug=True
}
