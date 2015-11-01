//
//  AMActivityIndicatorView.m
//  CatsTask
//
//  Created by Eugenity on 31.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "AMActivityIndicatorView.h"

@interface AMActivityIndicatorView ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation AMActivityIndicatorView

#pragma mark - Actions

- (void)showActivityIndicatorAddedToView:(UIView *)view
{
    self.frame = view.frame;
    [view addSubview:self];
    [self.activityIndicator startAnimating];
}

- (void)hideActivityIndicator
{
    [self removeFromSuperview];
    [self.activityIndicator stopAnimating];
}

@end
