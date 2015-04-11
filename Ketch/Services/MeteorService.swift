//
//  MeteorService.swift
//  Ketch
//
//  Created by Tony Xiao on 4/10/15.
//  Copyright (c) 2015 Ketch. All rights reserved.
//

import Foundation
import ReactiveCocoa
import SugarRecord
import Meteor

class MeteorService : NSObject {
    private let meteor: METCoreDataDDPClient
    let subscriptions: (
        metadata: METSubscription,
        currentUser: METSubscription,
        candidates: METSubscription,
        connections: METSubscription,
        messages: METSubscription
    )
    let collections: (
        metadata: METCollection,
        users: METCollection,
        candidates: METCollection,
        connections: METCollection,
        messages: METCollection
    )
    let meta: Metadata
    
    // Proxied accessors
    var connectionStatus: METDDPConnectionStatus { return meteor.connectionStatus }
    var connected: Bool { return meteor.connected }
    var loggingIn: Bool { return meteor.loggingIn }
    var mainContext : NSManagedObjectContext { return meteor.mainQueueManagedObjectContext }
    var account: METAccount? { return meteor.account }
    var userID : String? { return meteor.userID }
    weak var delegate: METDDPClientDelegate? {
        get { return meteor.delegate }
        set { meteor.delegate = newValue }
    }
    
    init(serverURL: NSURL) {
        meteor = METCoreDataDDPClient(serverURL: serverURL, account: nil)
        subscriptions = (
            meteor.addSubscriptionWithName("metadata"),
            meteor.addSubscriptionWithName("currentUser"),
            meteor.addSubscriptionWithName("candidates"),
            meteor.addSubscriptionWithName("connections"),
            meteor.addSubscriptionWithName("messages")
        )
        collections = (
            meteor.database.collectionWithName("metadata"),
            meteor.database.collectionWithName("users"),
            meteor.database.collectionWithName("candidates"),
            meteor.database.collectionWithName("connections"),
            meteor.database.collectionWithName("messages")
        )
        meta = Metadata(collection: collections.metadata)
        
        meteor.account = METAccount.defaultAccount()
        meteor.connect()
        
        SugarRecord.addStack(MeteorCDStack(meteor: meteor))
        
        super.init()
    }
    
    func loginWithFacebook(#accessToken: String, expiresAt: NSDate) -> RACSignal {
        return meteor.loginWithFacebook(accessToken, expiresAt: expiresAt)
    }
    
    func addPushToken(#appID: String, apsEnv: String, pushToken: NSData) -> RACSignal {
        return meteor.call("user/addPushToken", [appID, apsEnv, pushToken.hexString()])
    }
    
    func submitChoices(#yes: Candidate, no: Candidate, maybe: Candidate) -> RACSignal {
        return meteor.call("candidate/submitChoices", [[
            "yes": yes.documentID!,
            "no": no.documentID!,
            "maybe": maybe.documentID!
        ]]) {
            [yes, no, maybe].map { $0.delete() }
            return nil
        }
    }
    
    func markAsRead(connection: Connection) -> RACSignal {
        return meteor.call("connection/markAsRead", [connection.documentID!]) {
            connection.hasUnreadMessage = false
            connection.save()
            return nil
        }
    }
    
    func sendMessage(connection: Connection, text: String) -> RACSignal {
        return meteor.call("connection/sendMessage", [connection.documentID!, text]) {
            let message = Message.create() as Message
            message.connection = connection
            message.sender = User.currentUser()
            message.text = text
            message.save()
            return nil
        }
    }
    
    func reportUser(user: User, reason: String) -> RACSignal {
        return meteor.call("user/report", [user.documentID!, reason])
    }
    
    func deleteAccount() -> RACSignal {
        return meteor.call("user/delete")
    }
    
    func logout() -> RACSignal {
        return meteor.logout()
    }
}
