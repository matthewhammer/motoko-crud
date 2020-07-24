import Result "mo:base/Result";
import Buffer "mo:base/Buffer";
import Hash "mo:base/Hash";
import Order "mo:base/Order";

/*
 ## Type arguments used in this file:

 - Type Id for identifiers chosen by the service, issued by Create.

 - Type CRU for Create, Read and Update data in/out of the service.

 */

module {

/*
   ## Identifers

   We assume that the library client chooses an identifier
type and basic operations over it.  (The base library gives these definitions for simple choices like Nat, Int and Text).
*/
  public module Id {

    /// given CRU and optional "last created id", create next id
    public type Create<Id, CRU> = (CRU, ?Id) -> Id;

    public type Equal<Id> = (Id, Id) -> Bool;

    public type Kind<Id> = {
      #hash: (Id -> Hash.Hash);
      #order: ((Id, Id) -> Order.Order);
    };
  };

  public type Req<Id, CRU> = {
    #create: CRU;
    #read: Id;
    #update: CRU;
    #delete: Id;
  };

  public type Resp<CRU> = {
    #create;
    #read: CRU;
    #update;
    #delete;
  };

  public type Err = {
    #invalidId;
    #permissionDenied
  };

  public type Res<X> = Result.Result<X, Err>;

  public type LogOp<Id, CRU> = {
    #create: (Id, CRU);
    #read: (Id, Res<CRU>);
    #update: (Id, CRU, ?Err);
    #delete: (Id, ?Err);
  };

  public type LogOps<Id, CRU> = [LogOp<Id, CRU>];

  public type LogBuffer<Id, CRU> = Buffer.Buffer<LogOp<Id, CRU>>;

}
