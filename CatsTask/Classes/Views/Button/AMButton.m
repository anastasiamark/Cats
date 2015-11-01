//
//  AMButton.m
//  CatsTask
//
//  Created by Eugenity on 30.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "AMButton.h"

@implementation AMButton

#pragma mark - Lifecycle

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.layer.cornerRadius = 5.f;
}

@end
