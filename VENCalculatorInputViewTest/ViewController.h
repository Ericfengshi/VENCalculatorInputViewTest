//
//  ViewController.h
//  VENCalculatorInputViewTest
//
//  Created by fengs on 15-1-15.
//  Copyright (c) 2015年 fengs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VENCalculatorInputTextField.h"

@interface ViewController : UIViewController<UITextFieldDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,retain) VENCalculatorInputTextField *venTextField;
@property (nonatomic,retain) UIView *shadowView;
@end
