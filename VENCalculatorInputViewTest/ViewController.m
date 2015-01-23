//
//  ViewController.m
//  VENCalculatorInputViewTest
//
//  Created by fengs on 15-1-15.
//  Copyright (c) 2015年 fengs. All rights reserved.
//

#import "ViewController.h"
//#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize venTextField,shadowView;

- (void)dealloc {
    [venTextField release];
    [shadowView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setVenTextField:nil];
    [self setShadowView:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"VENCalculator Test";
    
    venTextField = [[[VENCalculatorInputTextField alloc] initWithFrame:CGRectMake(60, 36, 200, 36)] autorelease];
    venTextField.borderStyle = UITextBorderStyleRoundedRect;
    venTextField.delegate = self;
    [self.view addSubview:venTextField];
        
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark - UIGestureRecognizerDelegate

-(void)tapTouches:(UITapGestureRecognizer*)recognizer
{
    [venTextField resignFirstResponder];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    return YES;
}

#pragma mark -
#pragma mark -textFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [shadowView removeFromSuperview];
    [textField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
//    UIViewController *viewController = ((AppDelegate *)[UIApplication sharedApplication].delegate).nav.visibleViewController;
    shadowView = [[UIView alloc] initWithFrame:self.view.frame];
    UITapGestureRecognizer *tapTouches = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTouches:)];
    [shadowView addGestureRecognizer:tapTouches];
    tapTouches.delegate = self;
    tapTouches.cancelsTouchesInView = NO;
    [self.view addSubview:shadowView];
}


@end
