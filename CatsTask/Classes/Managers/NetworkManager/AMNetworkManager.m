//
//  AMNetworkManager.m
//  CatsTask
//
//  Created by Mark on 29.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "AMNetworkManager.h"

static NSString *const kRandomCatURLString = @"http://random.cat/meow";

static NSString *const kParseURLString = @"https://api.parse.com/1/classes/Logs";

@interface AMNetworkManager ()

@end

@implementation AMNetworkManager

dispatch_queue_t serialization_queue()
{
    static dispatch_queue_t serialization_queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serialization_queue = dispatch_queue_create("serialization_queue", DISPATCH_QUEUE_CONCURRENT);
    });
    return serialization_queue;
}

#pragma mark - Singleton Methods

+ (instancetype)sharedManager
{
    static AMNetworkManager *sharedManager = nil;
    static dispatch_once_t oneceToken;
    dispatch_once(&oneceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

#pragma mark - Requests

- (void)downloadCatImageWithCompletion:(Completion)completion
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDataTask *downloadTask = [session dataTaskWithURL:[NSURL URLWithString:kRandomCatURLString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(serialization_queue(), ^{
            NSError *serializationError;
            id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&serializationError];
            NSLog(@"json : %@", json);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(json, error ? error : serializationError);
                }
            });
        });
        
    }];
    
    [downloadTask resume];
}

- (void)uploadCatImageURL:(NSString *)catURLString withCompletion:(Completion)completion
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.HTTPAdditionalHeaders = @{@"X-Parse-Application-Id" : @"wGuKBRFghDRy3K2JuL9IkCwBssmQ2K0qR2noI5Qx",
                                            @"X-Parse-REST-API-Key" : @"qlAavQKuwnUeCl2L1FcCPUfMMkHJPL75cJjDLsQb",
                                            @"Content-type" : @"JSON"
                                            };
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kParseURLString]];
    
    request.HTTPMethod = @"POST";
    
    NSDictionary *body = @{@"userID": @"Anastasia Markovskaya",
                           @"catURL": catURLString};
    
    dispatch_async(serialization_queue(), ^{
        
        NSError *serializationError;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:NSJSONWritingPrettyPrinted error:&serializationError];
        
        request.HTTPBody = jsonData;
        
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            dispatch_async(serialization_queue(), ^{
                NSError *serializationError;
                id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&serializationError];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(json, error ? error : serializationError);
                    }
                });
            });
        }];
        [dataTask resume];
    });
}

@end
