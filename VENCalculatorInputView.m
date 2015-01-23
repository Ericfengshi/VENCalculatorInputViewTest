#import "VENCalculatorInputView.h"

@implementation VENCalculatorInputView

- (id)initWithDelegate:(id)delegate {
    self = [[[NSBundle mainBundle] loadNibNamed:@"VENCalculatorInputView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.delegate = delegate;
        // Set customizable properties
        [self setNumberButtonBackgroundColor:[UIColor colorWithWhite:0.98828 alpha:1]];
        [self setNumberButtonBorderColor:[UIColor colorWithRed:193/255.0f green:195/255.0f blue:199/255.0f alpha:1]];
//        [self setOperationButtonBackgroundColor:[UIColor colorWithRed:193/255.0f green:196/255.0f blue:200/255.0f alpha:1]];
        [self setOperationButtonBackgroundColor:[UIColor orangeColor]];
        [self setOperationButtonBorderColor:[UIColor colorWithRed:172/255.0f green:174/255.0f blue:177/255.0f alpha:1]];
        [self setButtonHighlightedColor:[UIColor grayColor]];
        [self setButtonTitleColor:[UIColor darkTextColor]];
        
        [self setButtonFrame];
        [self setUnderLine];

        // Set default properties
        for (UIButton *numberButton in self.numberButtonCollection) {
            [self setupButton:numberButton];
        }
        for (UIButton *operationButton in self.operationButtonCollection) {
            [self setupButton:operationButton];
        }
    }
    return self;
}

- (void)setupButton:(UIButton *)button {
    button.layer.borderWidth = 0.25f;
}

- (IBAction)userDidTapBackspace:(UIButton *)sender {
    [[UIDevice currentDevice] playInputClick];
    if ([self.delegate respondsToSelector:@selector(calculatorInputViewDidTapBackspace:)]) {
        [self.delegate calculatorInputViewDidTapBackspace:self];
    }
}

- (IBAction)userDidTapKey:(UIButton *)sender {
    [[UIDevice currentDevice] playInputClick];
    if ([self.delegate respondsToSelector:@selector(calculatorInputView:didTapKey:)]) {
        [self.delegate calculatorInputView:self didTapKey:sender.titleLabel.text];
    }
}

#pragma mark - UIInputViewAudioFeedback

- (BOOL)enableInputClicksWhenVisible {
    return YES;
}

#pragma mark - Helpers

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();

    [color set];
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


#pragma mark - Properties

- (void)setButtonTitleColor:(UIColor *)buttonTitleColor {
    _buttonTitleColor = buttonTitleColor;
    for (UIButton *numberButton in self.numberButtonCollection) {
        [numberButton setTitleColor:buttonTitleColor forState:UIControlStateNormal];
    }
    for (UIButton *operationButton in self.operationButtonCollection) {
        [operationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (void)setButtonTitleFont:(UIFont *)buttonTitleFont {
    _buttonTitleFont = buttonTitleFont;
    for (UIButton *numberButton in self.numberButtonCollection) {
        numberButton.titleLabel.font = buttonTitleFont;
    }
    for (UIButton *operationButton in self.operationButtonCollection) {
        operationButton.titleLabel.font = buttonTitleFont;
    }
}

- (void)setButtonHighlightedColor:(UIColor *)buttonHighlightedColor {
    _buttonHighlightedColor = buttonHighlightedColor;
    for (UIButton *numberButton in self.numberButtonCollection) {
        [numberButton setBackgroundImage:[self imageWithColor:buttonHighlightedColor size:CGSizeMake(50, 50)]
                                forState:UIControlStateHighlighted];
    }
    for (UIButton *operationButton in self.operationButtonCollection) {
        [operationButton setBackgroundImage:[self imageWithColor:buttonHighlightedColor size:CGSizeMake(50, 50)]
                                   forState:UIControlStateHighlighted];
    }
}

- (void)setNumberButtonBackgroundColor:(UIColor *)numberButtonBackgroundColor {
    _numberButtonBackgroundColor = numberButtonBackgroundColor;
    for (UIButton *numberButton in self.numberButtonCollection) {
        numberButton.backgroundColor = numberButtonBackgroundColor;
    }
}

- (void)setNumberButtonBorderColor:(UIColor *)numberButtonBorderColor {
    _numberButtonBorderColor = numberButtonBorderColor;
    for (UIButton *numberButton in self.numberButtonCollection) {
        numberButton.layer.borderColor = numberButtonBorderColor.CGColor;
    }
}

- (void)setOperationButtonBackgroundColor:(UIColor *)operationButtonBackgroundColor {
    _operationButtonBackgroundColor = operationButtonBackgroundColor;
    for (UIButton *operationButton in self.operationButtonCollection) {
        operationButton.backgroundColor = operationButtonBackgroundColor;
    }
}

- (void)setOperationButtonBorderColor:(UIColor *)operationButtonBorderColor {
    _operationButtonBorderColor = operationButtonBorderColor;
    for (UIButton *operationButton in self.operationButtonCollection) {
        operationButton.layer.borderColor = operationButtonBorderColor.CGColor;
    }
}

// reset frame
-(void)setButtonFrame{
    
    CGFloat viewHeight = 216;
    CGFloat viewWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat defaultHeight = viewHeight/4;
    CGFloat leftWidth = defaultHeight;
    CGFloat defaultWidth = (viewWidth-leftWidth)/3;
    for (UIButton *numberButton in self.numberButtonCollection) {
        if ([numberButton.titleLabel.text isEqualToString:@"1"]) {
            [numberButton setFrame:CGRectMake(leftWidth, 0, defaultWidth, defaultHeight)];
        }else if ([numberButton.titleLabel.text isEqualToString:@"2"]) {
            [numberButton setFrame:CGRectMake(leftWidth+defaultWidth, 0, defaultWidth, defaultHeight)];
        }else if ([numberButton.titleLabel.text isEqualToString:@"3"]) {
            [numberButton setFrame:CGRectMake(leftWidth+defaultWidth*2, 0, defaultWidth, defaultHeight)];
        }else if ([numberButton.titleLabel.text isEqualToString:@"4"]) {
            [numberButton setFrame:CGRectMake(leftWidth, defaultHeight, defaultWidth, defaultHeight)];
        }else if ([numberButton.titleLabel.text isEqualToString:@"5"]) {
            [numberButton setFrame:CGRectMake(leftWidth+defaultWidth, defaultHeight, defaultWidth, defaultHeight)];
        }else if ([numberButton.titleLabel.text isEqualToString:@"6"]) {
            [numberButton setFrame:CGRectMake(leftWidth+defaultWidth*2, defaultHeight, defaultWidth, defaultHeight)];
        }else if ([numberButton.titleLabel.text isEqualToString:@"7"]) {
            [numberButton setFrame:CGRectMake(leftWidth, defaultHeight*2, defaultWidth, defaultHeight)];
        }else if ([numberButton.titleLabel.text isEqualToString:@"8"]) {
            [numberButton setFrame:CGRectMake(leftWidth+defaultWidth, defaultHeight*2, defaultWidth, defaultHeight)];
        }else if ([numberButton.titleLabel.text isEqualToString:@"9"]) {
            [numberButton setFrame:CGRectMake(leftWidth+defaultWidth*2, defaultHeight*2, defaultWidth, defaultHeight)];
        }else if ([numberButton.titleLabel.text isEqualToString:@"0"]) {
            [numberButton setFrame:CGRectMake(leftWidth+defaultWidth, defaultHeight*3, defaultWidth, defaultHeight)];
        }

    }
    for (UIButton *operationButton in self.operationButtonCollection) {
        if ([operationButton.titleLabel.text isEqualToString:@"÷"]) {
            [operationButton setFrame:CGRectMake(0, 0, leftWidth, defaultHeight)];
        }else if ([operationButton.titleLabel.text isEqualToString:@"×"]) {
            [operationButton setFrame:CGRectMake(0, defaultHeight, leftWidth, defaultHeight)];
        }else if ([operationButton.titleLabel.text isEqualToString:@"—"]) {
            [operationButton setFrame:CGRectMake(0, defaultHeight*2, leftWidth, defaultHeight)];
        }else if ([operationButton.titleLabel.text isEqualToString:@"+"]) {
            [operationButton setFrame:CGRectMake(0, defaultHeight*3, leftWidth, defaultHeight)];
        }else if ([operationButton.titleLabel.text isEqualToString:@"."]) {
            [operationButton setFrame:CGRectMake(leftWidth, defaultHeight*3, defaultWidth, defaultHeight)];
        }else{// if ([operationButton.titleLabel.text) {
            [operationButton setFrame:CGRectMake(leftWidth+defaultWidth*2, defaultHeight*3, defaultWidth, defaultHeight)];
        }
    }
}

// add under/vertical line for UIControl
-(void)setUnderLine{
    CGFloat viewHeight = 216;
    CGFloat viewWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat defaultHeight = viewHeight/4;
    CGFloat leftWidth = defaultHeight;
    CGFloat defaultWidth = (viewWidth-leftWidth)/3;
    
    [self addSubview:[self drawImageView:CGRectMake(leftWidth-1, 0, 1, viewHeight)]];
    [self addSubview:[self drawImageView:CGRectMake(leftWidth+defaultWidth-1, 0, 0.1, viewHeight)]];
    [self addSubview:[self drawImageView:CGRectMake(leftWidth+defaultWidth*2-1, 0, 0.1, viewHeight)]];
    
    [self addSubview:[self drawImageView:CGRectMake(0, defaultHeight-1, viewWidth, 1)]];
    [self addSubview:[self drawImageView:CGRectMake(0, defaultHeight*2-1, viewWidth, 1)]];
    [self addSubview:[self drawImageView:CGRectMake(0, defaultHeight*3-1, viewWidth, 1)]];
}

-(UIImageView*)drawImageView:(CGRect)frame{
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:frame];
    imgView.backgroundColor = [UIColor lightGrayColor];
    return imgView;
}

@end
