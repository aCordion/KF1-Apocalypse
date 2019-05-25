class MutantZombieFleshpound extends ZEDS_ZombieFleshpound
    Config(ApocZEDPack);

struct SZEDInfo {
	var config int ForcedMinPlayers;
	var config int Health;
    var config int HeadHealth;
    var config float PlayerCountHealthScale;
    var config float PlayerNumHeadHealthScale;
};
var config SZEDInfo ZEDInfo;

simulated function PostBeginPlay()
{
    if (ZEDInfo.Health>0 && Health!=ZEDInfo.Health)
    {
        Health = ZEDInfo.Health;
        HealthMax = ZEDInfo.Health;
    }

    if (ZEDInfo.HeadHealth>0 && HeadHealth!=ZEDInfo.HeadHealth)
        HeadHealth = ZEDInfo.HeadHealth;

    if (ZEDInfo.PlayerCountHealthScale>0 && PlayerCountHealthScale!=ZEDInfo.PlayerCountHealthScale)
        PlayerCountHealthScale = ZEDInfo.PlayerCountHealthScale;

    if (ZEDInfo.PlayerNumHeadHealthScale>0 && PlayerNumHeadHealthScale!=ZEDInfo.PlayerNumHeadHealthScale)
        PlayerNumHeadHealthScale = ZEDInfo.PlayerNumHeadHealthScale;
		
	Super.PostBeginPlay();
}

function float NumPlayersHealthModifer()
{
    if (ZEDInfo.ForcedMinPlayers>0)
        return 1.0 + (ZEDInfo.ForcedMinPlayers - 1) * PlayerCountHealthScale;
    return Super.NumPlayersHealthModifer();
}

function float NumPlayersHeadHealthModifer()
{
    if (ZEDInfo.ForcedMinPlayers>0)
        return 1.0 + (ZEDInfo.ForcedMinPlayers - 1) * PlayerNumHeadHealthScale;
    return Super.NumPlayersHeadHealthModifer();
}

simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();

    SetBoneScale(2, 1.75, 'rarm');
    SetBoneScale(3, 1.75, 'larm');
}

defaultproperties
{
    mesh=SkeletalMesh'KF_Freaks_Trip.FleshPound_Freak'
    Skins(0)=Combiner'KF_Specimens_Trip_T.fleshpound_cmb'
    Skins(1)=Shader'KFCharacters.FPAmberBloomShader'
    HitSound(0)=Sound'KF_EnemiesFinalSnd.FP_Pain'
    AmbientSound=Sound'KF_BaseFleshpound.FP_IdleLoop'
    ChallengeSound(0)=Sound'KF_EnemiesFinalSnd.FP_Challenge'
    ChallengeSound(1)=Sound'KF_EnemiesFinalSnd.FP_Challenge'
    ChallengeSound(2)=Sound'KF_EnemiesFinalSnd.FP_Challenge'
    ChallengeSound(3)=Sound'KF_EnemiesFinalSnd.FP_Challenge'
    MoanVoice=Sound'KF_EnemiesFinalSnd.FP_Talk'
    DeathSound(0)=Sound'KF_EnemiesFinalSnd.FP_Death'
    JumpSound=Sound'KF_EnemiesFinalSnd.FP_Jump'
    MeleeAttackHitSound=sound'KF_EnemiesFinalSnd.FP_HitPlayer'

    EventClasses(0)="MutantZombieFleshpound";
    EventClasses(1)="MutantZombieFleshpound";
    EventClasses(2)="MutantZombieFleshpound";
    EventClasses(3)="MutantZombieFleshpound";
}
