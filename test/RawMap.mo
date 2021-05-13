/* Raw Map

 Each keys and value is an array of bytes.

 Demonstrates a minimal Map service via the Motoko CRUD package.

*/

import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Nat32 "mo:base/Nat32";
import Order "mo:base/Order";

import Database "../src/Database";

actor {
  public type Key = [Nat8];
  public type Val = [Nat8];

  var nextKey : ?[Nat8] = null;

  func keyEqual(x : Key, y : Key) : Bool {
    switch (keyCompare(x, y)) {
    case (#equal) true;
    case _ false;
    }
  };

  // to do -- add a generic version to base package
  func keyCompare(x : Key, y : Key) : Order.Order {
    switch (Nat.compare(x.size(), y.size())) {
      case (#less) #less;
      case (#greater) #greater;
      case (#equal) {
        for (i in x.keys()) {
          if (x[i] < y[i]) return #less
          else if (x[i] > y[i]) return #greater
          else { }
        };
        return #equal
      };
    }
  };

  func keyHash(x : Key) : Nat32 {
    let blowupAndBitshiftLeft : (Nat8, Nat32) -> Nat32 = func (x, y) {
      Nat32.bitshiftLeft(Nat32.fromNat(Nat8.toNat(x)), y)
    };
    // to do -- use all bits in the final hash, not just the first ones
    blowupAndBitshiftLeft(x[0], 24) +
    blowupAndBitshiftLeft(x[0], 16) +
    blowupAndBitshiftLeft(x[0], 8) +
    blowupAndBitshiftLeft(x[0], 0)
  };

  var db = Database.Database<Key, Val>(
    func (_, _) : Key { 
      switch nextKey { 
        case null { assert false; loop { } };
        case (?x) x 
      }},
    keyEqual,
    #hash(keyHash),
  );

  public func put(k:Key, v:Val) : async () {
    // to do -- for now, we communicate the key via mutation (ugly).
    nextKey := ?k;
    let _ = db.create(v);
  };

  public func get(k:Key) : async ?Val {
    switch (db.read(k)) {
      case (#ok(v)) ?v;
      case (#err(_)) null;
    }
  };

  public func selfTest() : () {
     // to do
     Debug.print "success" 
  };

}
