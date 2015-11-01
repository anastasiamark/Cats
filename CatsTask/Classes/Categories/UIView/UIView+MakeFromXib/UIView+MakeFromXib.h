//
//  UIView+MakeFromXib.h
//
//  Created by Mark on 31.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MakeFromXib)

+ (instancetype)makeFromXibWithFileOwner:(id)owner;
+ (instancetype)makeFromXib;

@end
