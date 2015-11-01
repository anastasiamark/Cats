//
//  AMNetworkManager.h
//  CatsTask
//
//  Created by Mark on 29.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Completion)(id deserealizedJson, NSError *error);

@interface AMNetworkManager : NSObject

+ (instancetype)sharedManager;

- (void)downloadCatImageWithCompletion:(Completion)completion;

- (void)uploadCatImageURL:(NSString *)catURLString
           withCompletion:(Completion)completion;

@end
