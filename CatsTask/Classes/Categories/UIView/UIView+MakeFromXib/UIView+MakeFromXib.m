//
//  UIView+MakeFromXib.m
//
//  Created by Mark on 31.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "UIView+MakeFromXib.h"

@implementation UIView (MakeFromXib)

+ (instancetype)makeFromXibWithFileOwner:(id)owner
{
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:owner options:nil];
    return [nibs firstObject];
}

+ (instancetype)makeFromXib
{
    return [self makeFromXibWithFileOwner:nil];
}

@end
