//
//  AMCatController.m
//  CatsTask
//
//  Created by Mark on 29.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "AMCatController.h"

#import "AMNetworkManager.h"

#import "UIView+MakeFromXib.h"

#import "AMActivityIndicatorView.h"

@interface AMCatController ()

@property (weak, nonatomic) IBOutlet UIImageView *catImageView;

@property (weak, nonatomic) IBOutlet UILabel *catLinkLabel;

@property (nonatomic) AMNetworkManager *networkManager;

@property (strong, nonatomic) NSString *savedCatURLString;

@property (strong, nonatomic) AMActivityIndicatorView *activityIndicatorView;

@end

@implementation AMCatController

#pragma mark - Accessors

- (AMNetworkManager *)networkManager
{
    if (!_networkManager) {
        _networkManager = [AMNetworkManager sharedManager];
    }
    return _networkManager;
}

#pragma mark - Lifecycle

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _activityIndicatorView = [AMActivityIndicatorView makeFromXib];
    }
    return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Actions

- (IBAction)downloadCatAction:(id)sender
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.activityIndicatorView showActivityIndicatorAddedToView:self.view];
    
    __weak typeof(self)weakSelf = self;
    [self.networkManager downloadCatImageWithCompletion:^(id deserealizedJson, NSError *error) {
        if (error) {
            [weakSelf showAlertControllerWithTitle:@"Error" andMessage:@"There was a loading data error"];
            return;
        }
        if ([deserealizedJson isKindOfClass:[NSDictionary class]]) {
            
            NSString *catURLString = deserealizedJson[@"file"];
            weakSelf.savedCatURLString = catURLString;
            NSURL *catURL = [NSURL URLWithString:catURLString];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSData *imageData = [[NSData alloc] initWithContentsOfURL:catURL];
                UIImage *catImage = [UIImage imageWithData:imageData];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.catImageView.image = catImage;
                    weakSelf.catLinkLabel.text = weakSelf.savedCatURLString;
                    [weakSelf.activityIndicatorView hideActivityIndicator];
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                });
            });
        }
    }];
}

- (IBAction)uploadCatURLClick:(id)sender
{
    if (!self.savedCatURLString.length) {
        return;
    }
    
    __weak typeof(self)weakSelf = self;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.activityIndicatorView showActivityIndicatorAddedToView:self.view];
    
    [self.networkManager uploadCatImageURL:self.savedCatURLString withCompletion:^(id deserealizedJson, NSError *error) {
        if (error) {
            [weakSelf showAlertControllerWithTitle:@"Error" andMessage:@"There was a loading data error"];
            return;
        }
        [weakSelf.activityIndicatorView hideActivityIndicator];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        NSLog(@"json : %@", deserealizedJson);
        [weakSelf showAlertControllerWithTitle:deserealizedJson[@"objectId"] andMessage:deserealizedJson[@"createdAt"]];
    }];
}

- (void)showAlertControllerWithTitle:(NSString *)title andMessage:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
