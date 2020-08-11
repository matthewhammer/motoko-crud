// see https://forum.dfinity.org/t/crud-with-uuid-generation-need-some-direction/1033
module {
  public type Id = Nat;
  public type Name = Text;

  public type NamedEntity = {
    name : Name; // the name need not be unique
    entity : Entity; // (arbitrarily complex entity data)
  };

  /// distinguish different types of entities
  public type Entity = {
    #rarity : Rarity;
    #monster : Monster;
  };

  /// Entity type: Rarities
  public type Rarity = {
    kind : RarityKind;
    quantity : Nat; // units?
  };

  /// distinguish different types of rarities
  public type RarityKind = {
    #gold;
    #silver;
    #unobtanium;
  };

  /// Entity type: Monsters
  public type Monster = {
    kind : MonsterKind;
    data : MonsterData;
  };

  /// data common to all monsters
  public type MonsterData = {
    health : Nat;
    // to do -- data common to all monsters
  };

  /// distinguish different kinds of monsters
  public type MonsterKind = {
    #goblin;
    #dragon: DragonColor;
  };

  /// distinguish different kinds of dragons
  public type DragonColor = {
    #green;
    #gold;
    #red;
  };
}
