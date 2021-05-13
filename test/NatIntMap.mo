import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";

import Db "../src/Database";
import Types "../src/Types";

actor {

  // A database of integers, each identified by a natural number.
  var db = Db.Database<Nat, Int>(
    // to do (base) -- Nat.incOpton ?
    func (_, last) {
      switch last { case null 0; case (?x) x + 1 };
    },
    Nat.equal,
    #hash(Hash.hash),
  );

  public type LogOps = Types.LogOps<Nat, Int>;

  public func test() : async LogOps {
    // todo -- add assertions below
    let x = db.create(3);
    let y = db.create(-3);
    Debug.print ("created " # (debug_show (x, y)));
    let rx = db.read(x);
    let ry = db.read(y);
    Debug.print ("read-1" # (debug_show (rx, ry)));
    let ux = db.update(x, 6);
    let uy = db.update(y, -6);
    Debug.print ("updated " # (debug_show (ux, uy)));
    let r2x = db.read(x);
    let r2y = db.read(y);
    Debug.print ("read-2 " # (debug_show (r2x, r2y)));
    let dx = db.delete(x);
    let dy = db.delete(y);
    Debug.print ("delete " # (debug_show (dx, dy)));
    let r3x = db.read(x);
    let r3y = db.read(y);
    Debug.print ("read-3 " # (debug_show (r3x, r3y)));
    Debug.print "test success.";
    db.drainLog().toArray()
  };

  public func selfTest() : () {
     // to do
     Debug.print "success" 
  };

}
