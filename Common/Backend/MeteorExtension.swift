//
//  MeteorExtension.swift
//  Serendipity
//
//  Created by Tony Xiao on 2/7/15.
//  Copyright (c) 2015 Serendipity. All rights reserved.
//

import Meteor
import ReactiveCocoa

//extension
extension METSubscription {
    
    var signal : RACSignal {
        let subject = RACReplaySubject()
        whenDone { (err) -> Void in
            err != nil ? subject.sendError(err) : subject.sendCompleted()
        }
        return subject
    }
}

extension METDDPClient {
    var logDDPMessages : Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey("METShouldLogDDPMessages")
        }
        set(newValue) {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: "METShouldLogDDPMessages")
        }
    }
    
    func call(method: String, _ params: [AnyObject]? = nil, stub:(() -> AnyObject?)? = nil) -> RACSignal {
        if let stub = stub {
            return callMethod(method, params: params) { _ in
                return stub()
            }
        } else {
            return callMethod(method, params: params)
        }
    }
    
    func callMethod(method: String, params: [AnyObject]? = nil, stub:(([AnyObject]!) -> AnyObject!)? = nil) -> RACSignal {
        let subject = RACReplaySubject()
        callMethodWithName(method, parameters: params, completionHandler: { res, error in
            if error != nil {
                subject.sendError(error)
            } else {
                subject.sendNext(res)
                subject.sendCompleted()
            }
        }, methodStub: stub)
        return subject
    }
    
    func loginWithMethod(method: String, params: [AnyObject]?) -> RACSignal {
        let subject = RACReplaySubject()
        loginWithMethodName(method, parameters: params) { (err) -> Void in
            err != nil ? subject.sendError(err) : subject.sendCompleted()
        }
        return subject;
    }
    
    func logout() -> RACSignal {
        let subject = RACReplaySubject()
        logoutWithCompletionHandler { (error) -> Void in
            if error != nil {
                subject.sendError(error)
            } else {
                subject.sendCompleted()
            }
        }
        return subject
    }
}

// MARK: - Meteor CoreData

extension NSManagedObjectContext {
    var meteorStore : METIncrementalStore? {
        return persistentStoreCoordinator?.persistentStores.first as? METIncrementalStore
    }
    
    func objectIDWithCollection(collection: String, documentID: String) -> NSManagedObjectID? {
        return meteorStore?.objectIDForDocumentKey(METDocumentKey(collectionName: collection, documentID: documentID))
    }
    
    func objectInCollection(collection: String, documentID: String) -> NSManagedObject? {
        let objectID = objectIDWithCollection(collection, documentID: documentID)
        return objectID != nil ? objectWithID(objectID!) : nil
    }
    
    func existingObjectInCollection(collection: String, documentID: String, error: NSErrorPointer) -> NSManagedObject? {
        let objectID = objectIDWithCollection(collection, documentID: documentID)
        return objectID != nil ? existingObjectWithID(objectID!, error: error) : nil
    }
}

extension NSManagedObject {
    var meteorStore : METIncrementalStore? {
        return managedObjectContext?.meteorStore
    }
    
    var documentID : String? {
        return meteorStore?.documentKeyForObjectID(objectID)?.documentID as? String
    }
}
