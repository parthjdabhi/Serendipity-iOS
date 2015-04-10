//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#import <FacebookSDK/FacebookSDK.h>
#import <SwipeView/SwipeView.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Meteor/METCoreDataDDPClient.h>
#import <JSQMessagesViewController/JSQMessagesViewController.h>
#import <BugfenderSDK/BugfenderSDK.h>
#import "R.h"

@interface METDDPClient (Private)

@property (nonatomic, copy) METAccount *account;

- (void)loginWithMethodName:(NSString *)methodName parameters:(NSArray *)parameters completionHandler:(METLogInCompletionHandler)completionHandler;

@end

@interface JSQMessagesViewController (Private)

- (void)jsq_configureMessagesViewController;
- (void)jsq_registerForNotifications:(BOOL)registerForNotifications;
+ (UINib *)nib;

@end

@interface METDDPClient (Extension)

- (BOOL)hasAccount;

@end

@interface RACSignal (SwiftCompileFix)

- (RACSignal *)And;
- (RACSignal *)Or;
- (RACSignal *)Not;

+ (RACSignal *)Return:(id)object;

@end

@interface NSLogger : NSObject

- (void)logWithFilename:(NSString *)filename
             lineNumber:(int)lineNumber
           functionName:(NSString *)functionName
                 domain:(NSString *)domain
                  level:(int)level
                message:(NSString *)message;

@end

@interface Bugfender (Swift)

+ (void)logWithFilename:(NSString *)filename
             lineNumber:(int)lineNumber
           functionName:(NSString *)functionName
                    tag:(NSString *)tag
                  level:(BFLogLevel)level
                message:(NSString *)message;

@end