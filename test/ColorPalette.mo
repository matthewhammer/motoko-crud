/*
 Attempts to address this question:
 https://forum.dfinity.org/t/crud-sample-question/1022
*/
import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";

import Buffer "mo:base/Buffer";

import Db "../src/Database";
import Types "../src/Types";

actor {

  type Color = {#red; #green; #gold}; // to do -- expand with more

  type Palette = Buffer.Buffer<Color>; // to do -- what order? duplicates?

  // A database of palettes, each identified by a natural number.
  flexible var db = Db.Database<Nat, Palette>(
    func (_, last) {
      switch last { case null 0; case (?x) x + 1 };
    },
    Nat.equal,
    #hash(Hash.hash),
  );

  // to do -- stable representation (e.g., use tries of lists, etc.)

  /// add given color to an existing palette
  public func addColor(palette : Nat, color : Color) : async ?() {
    let result = db.read(palette);
    switch result {
      case (#ok(palette)) { palette.add(color); ?() };
      case (#err(_)) null;
    }
  };

  /// add given color to an existing palette
  public func addColors(palette : Nat, colors : [Color]) : async ?() {
    let result = db.read(palette);
    switch result {
      case (#ok(palette)) {
             for (color in colors.vals()) {
               palette.add(color)
             }; ?() };
      case (#err(_)) null;
    }
  };

  /// get a color from an existing palette (based on its position)
  public func getColor(palette : Nat, color : Nat) : async ?Color {
    let result = db.read(palette);
    switch result {
      case (#ok(palette)) ?palette.get(color);
      case (#err(_)) null;
    }
  };

  /// get all colors from an existing palette
  public func getColors(palette : Nat) : async ?[Color] {
    let result = db.read(palette);
    switch result {
      case (#ok(palette)) ?palette.toArray();
      case (#err(_)) null;
    }
  };

  public func selfTest() : () {
     // to do
     Debug.print "success"
  };
}
