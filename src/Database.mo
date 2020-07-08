import Types "Types";

import Result "mo:base/Result";
import Buf "mo:base/Buf";

import TrieMap "mo:base/TrieMap";
import RBTree "mo:base/RBTree";

module {

  public type Res<R> = Result.Result<R, Types.Err>;

  public class Database<Id, CRU>(
    idCreate : Types.Id.Create<Id, CRU>,
    idEqual : Types.Id.Equal<Id>,
    idKind : Types.Id.Kind<Id>)
  {

    // to do -- two possible representations, depending on the identifier kind:
    var entries : TrieMap.TrieMap<Id, CRU> = switch idKind {
      case (#hash(h)) {
             TrieMap.TrieMap<Id, CRU>(idEqual, h)
           };
      case (#order(_)) {
             assert false; loop { }
           };
    };

    var lastCreated : ?Id = null;

    var logBuf : Types.LogBuf<Id, CRU> = Buf.Buf(0);

    public func create(cru:CRU) : Id {
      let x : Id = idCreate(cru, lastCreated);
      lastCreated := ?x;
      entries.put(x, cru);
      logBuf.add(#create(x, cru));
      x
    };

    public func read(id:Id) : Res<CRU> {
      switch (entries.get(id)) {
        case null {
          logBuf.add(#read(id, #err(#invalidId)));
          #err(#invalidId)
        };
        case (?cru) {
          let r : Types.Res<CRU> = #ok(cru);
          logBuf.add(#read(id, r));
          #ok(cru)
        };
      }
    };

    public func update(id:Id, cru:CRU) : Res<()> {
      switch (entries.replace(id, cru)) {
        case null {
          logBuf.add(#update(id, cru, ?#invalidId));
          #err(#invalidId)
        };
        case (?_) {
          logBuf.add(#update(id, cru, null));
          #ok(())
        };
      }
    };

    public func delete(id:Id) : Res<()> {
      switch (entries.remove(id)) {
        case null { #err(#invalidId) };
        case (?_) { #ok(()) };
      }
    };

    public func drainLog() : Types.LogBuf<Id, CRU> {
      let l = logBuf.clone();
      logBuf.clear();
      l
    }

  };

}
