class PP19Bullet extends ShotgunBullet;

#exec OBJ LOAD FILE="PP19_Snd.uax"

var() array<Sound> ExplodeSounds;

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();

    Velocity = Speed * Vector(Rotation); // starts off slower so combo can be done closer

    SetTimer(0.4, false);

/*    if ( Level.NetMode != NM_DedicatedServer )
    {
        if ( !PhysicsVolume.bWaterVolume )
        {

            Trail = Spawn(class'KFTracer',self);
            Trail.Lifespan = Lifespan;
        }
    }*/
}

simulated function Explode(vector HitLocation,vector HitNormal)
{
    if ( Role == ROLE_Authority )
    {
        HurtRadius(Damage*0.75, DamageRadius, MyDamageType, 0.0, HitLocation );
        HurtRadius(Damage*0.25, DamageRadius*2.0, MyDamageType, MomentumTransfer, HitLocation );

        //does full damage within DamageRadius (dealt in two chunks), but less damage to things outside of DamageRadius but within
        //DamageRadius*2.0
    }

    //why would it matter if instigator exists or not for spawning an fx???
    //if ( KFHumanPawn(Instigator) != none )
    //{

        PlaySound(ExplodeSounds[rand(ExplodeSounds.length)],,1.0);

        if ( EffectIsRelevant(Location,false) )
        {
            Spawn(class'PP19BulletEmitter',self,,Location);
        }

    //}

    Destroy();
}

/* kyan: remove
simulated function ProcessTouch (Actor Other, vector HitLocation)
{
    if ( Other != Instigator && !Other.IsA('PhysicsVolume') && (Other.IsA('Pawn') || Other.IsA('ExtendedZCollision')) )
    {
        Other.Velocity.X = self.Velocity.X * 0.5;
        Other.Velocity.Y = Self.Velocity.Y * 0.5;
        Other.Velocity.Z = self.Velocity.Z * 0.5;
        Other.Acceleration = vect(0,0,0); //0,0,0

        Explode(Other.Location,Other.Location);
    }
}
*/

//kyan: add
/*
simulated function ProcessTouch(Actor Other, vector HitLocation)
{
    if (Other == None)
        return;

    if (KFMonster(Other) == None)
        return;

    if (Other.Physics == PHYS_Walking)
        Other.SetPhysics(PHYS_Falling);

    Other.Velocity.X = Self.Velocity.X * 0.05;
    Other.Velocity.Y = Self.Velocity.Y * 0.05;
    Other.Velocity.Z = Self.Velocity.Z * 0.05;

    Other.Acceleration = vect(0, 0, 0); // 0, 0, 0

    Super.ProcessTouch(Other, HitLocation);
}
*/

defaultproperties
{
    Speed=9000.000000
    MaxSpeed=9000.000000
    ExplodeSounds(0)=Sound'PP19_Snd.PP19_explode'
    ExplodeSounds(1)=Sound'PP19_Snd.PP19_explode'
    ExplodeSounds(2)=Sound'PP19_Snd.PP19_explode'
    Damage=40.000000
    DamageRadius=1.000000 //10.000000 kyan
    MomentumTransfer=30000.000000
    MyDamageType=Class'DamTypePP19'
}
