//
//  GCHelper.h
//  HowManyC
//
//  Created by Max on 06/07/15.
//  Copyright (c) 2015 Max. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface GCHelper : NSObject {
    BOOL gameCenterAvailable;
    BOOL userAuthenticated;
}

@property (assign, readonly) BOOL gameCenterAvailable;
@property UIViewController *controller;
@property NSString *localPlayerId;
@property NSInteger localPlayerRank;

+ (GCHelper *)sharedInstance;
- (void)authenticateLocalUser;
- (void)reportScore:(NSInteger)scoreValue;
- (void) getLeaderboardWithCompletionHandler:(void(^)(NSArray* scores))handler;
@end
