import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";

import Buffer "mo:base/Buffer";

import Db "../src/Database";
import Types "../src/Types";

actor {

  type Color = {#red; #green; #gold} // to do -- expand with more

  type Palette = Buffer.Buffer<Color>; // to do -- what order? duplicates?

  // A database of integers, each identified by a natural number.
  flexible var db = Db.Database<Nat, Palette>(
    func (_, last) {
      switch last { case null 0; case (?x) x + 1 };
    },
    Nat.equal,
    #hash(Hash.hash),
  );

  // to do -- stable representation (e.g., use tries of lists, etc.)

  public func getColor(palette : Nat, color : Nat) : async Color {
    db.read(palette).get(color)
  };

}
