import Types "Types";

import Result "mo:base/Result";
import Buffer "mo:base/Buffer";

import TrieMap "mo:base/TrieMap";
import RBTree "mo:base/RBTree";
import Iter "mo:base/Iter";

module {

  public type Res<R> = Result.Result<R, Types.Err>;

  public class Database<Id, CRU>(
    idCreate : Types.Id.Create<Id, CRU>,
    idEqual : Types.Id.Equal<Id>,
    idKind : Types.Id.Kind<Id>)
  {

    // to do -- two possible representations, depending on the identifier kind:
    var _entries : TrieMap.TrieMap<Id, CRU> = switch idKind {
      case (#hash(h)) {
             TrieMap.TrieMap<Id, CRU>(idEqual, h)
           };
      case (#order(_)) {
             assert false; loop { }
           };
    };

    var lastCreated : ?Id = null;

    var logBuffer : Types.LogBuffer<Id, CRU> = Buffer.Buffer(0);

    public func create(cru:CRU) : Id {
      let x : Id = idCreate(cru, lastCreated);
      lastCreated := ?x;
      _entries.put(x, cru);
      logBuffer.add(#create(x, cru));
      x
    };

    public func read(id:Id) : Res<CRU> {
      switch (_entries.get(id)) {
        case null {
          logBuffer.add(#read(id, #err(#invalidId)));
          #err(#invalidId)
        };
        case (?cru) {
          let r : Types.Res<CRU> = #ok(cru);
          logBuffer.add(#read(id, r));
          #ok(cru)
        };
      }
    };

    public func update(id:Id, cru:CRU) : Res<()> {
      switch (_entries.replace(id, cru)) {
        case null {
          logBuffer.add(#update(id, cru, ?#invalidId));
          #err(#invalidId)
        };
        case (?_) {
          logBuffer.add(#update(id, cru, null));
          #ok(())
        };
      }
    };

    public func delete(id:Id) : Res<()> {
      switch (_entries.remove(id)) {
        case null { #err(#invalidId) };
        case (?_) { #ok(()) };
      }
    };

    public func drainLog() : Types.LogBuffer<Id, CRU> {
      let l = logBuffer.clone();
      logBuffer.clear();
      l
    };

    public func entries() : Iter.Iter<(Id, CRU)> {
      _entries.entries()
    };
  };

}
