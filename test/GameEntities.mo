/*
 Attempts to address this question:
 https://forum.dfinity.org/t/crud-with-uuid-generation-need-some-direction/1033
*/
import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";

import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";

import Db "../src/Database";

import Types "../examples/game/Types";

actor {

  public type Id = Types.Id; // Nat for now (not Text, as in the forum question)
  public type DbRow = Types.NamedEntity;
  public type Entity = Types.Entity;

  // A database of named entities, each (uniquely) identified by a number
  flexible var db = Db.Database<Id, DbRow>(
    func (_, last) {
      switch last { case null 0; case (?x) x + 1 };
    },
    Nat.equal,
    #hash(Hash.hash),
  );

  /// create an entity, assigning a unique ID
  public func createEntity(n : Text, e : Entity) : async Id {
    db.create({name=n; entity=e})
  };

  /// get all of the entries in the database thus far
  public func readAll() : async [(Id, DbRow)] {
    Iter.toArray(db.entries())
  };

  public func selfTest() : () {
     // to do
     Debug.print "success"
  };
}
