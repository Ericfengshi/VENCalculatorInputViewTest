#import "VENCalculatorInputTextField.h"

@implementation VENCalculatorInputTextField
@synthesize isFirstTouch;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        isFirstTouch = YES;
        [self setUpInit];
    }
    return self;
}

- (void)awakeFromNib {
    [self setUpInit];
}

- (void)setUpInit {
    self.inputView = [[VENCalculatorInputView alloc] initWithDelegate:self];
    [self addTarget:self action:@selector(venCalculatorTextFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [self addTarget:self action:@selector(venCalculatorTextFieldDidEndEditing) forControlEvents:UIControlEventEditingDidEnd];
}

#pragma mark - UITextField

- (void)venCalculatorTextFieldDidChange {

    if (![self.text length]) {
        return;
    }
    
    if (!isFirstTouch) {
        return;
    }
    isFirstTouch = NO;
    NSString *lastCharacterString = [self.text substringFromIndex:[self.text length] - 1];
    NSString *subString = [self.text substringToIndex:self.text.length - 1];
    if ([lastCharacterString isEqualToString:@"+"] ||
        [lastCharacterString isEqualToString:@"—"] ||
        [lastCharacterString isEqualToString:@"×"] ||
        [lastCharacterString isEqualToString:@"÷"]) {
        NSString *evaluatedString = [self evaluateExpression:subString];
        if (evaluatedString) {
            self.text = [NSString stringWithFormat:@"%@%@", evaluatedString, lastCharacterString];
        } else {
            if (subString.length>0) {
                // operation replace
                NSString *secondToLastCharacterString= [subString substringFromIndex:[subString length] - 1];
                if ([secondToLastCharacterString isEqualToString:@"+"] ||
                    [secondToLastCharacterString isEqualToString:@"—"] ||
                    [secondToLastCharacterString isEqualToString:@"×"] ||
                    [secondToLastCharacterString isEqualToString:@"÷"]) {
                    self.text = [NSString stringWithFormat:@"%@%@", [subString substringToIndex:subString.length -1 ], lastCharacterString];
                }
            }else{
                self.text = subString;
            }
            
        }
    } else if ([lastCharacterString isEqualToString:@"."]) {
        
        NSString *secondToLastCharacterString = [self.text substringWithRange:NSMakeRange([self.text length] - 2, 1)];
        if ([secondToLastCharacterString isEqualToString:@"."]) {
            self.text = subString;
        }else{
            // filter decimals error use 
            NSString *validRegEx = @"^(\\d*\\.?\\d*[+|—|×|÷]?)?\\d*\\.\\d*.$";
            NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
            BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:self.text];
            if (myStringMatchesRegEx) {
                self.text = subString;
            }
        }
    }
}

- (void)venCalculatorTextFieldDidEndEditing {
    NSString *textToEvaluate = [self trimExpressionString:self.text];
    NSString *evaluatedString = [self evaluateExpression:textToEvaluate];
    if (evaluatedString) {
        self.text = evaluatedString;
    }
}

#pragma mark - VENCalculatorInputViewDelegate

- (void)calculatorInputView:(VENCalculatorInputView *)inputView didTapKey:(NSString *)key {
    self.isFirstTouch = YES;
    [self insertText:key];
}

- (void)calculatorInputViewDidTapBackspace:(VENCalculatorInputView *)calculatorInputView {
    self.isFirstTouch = YES;
    [self deleteBackward];
}

#pragma mark - Helpers

/**
 Removes any trailing operations and decimals.
 @param expressionString The expression string to trim
 @return The trimmed expression string
 */
- (NSString *)trimExpressionString:(NSString *)expressionString {
    if ([self.text length] > 0) {
        NSString *lastCharacterString = [self.text substringFromIndex:[self.text length] - 1];
        if ([lastCharacterString isEqualToString:@"+"] ||
            [lastCharacterString isEqualToString:@"—"] ||
            [lastCharacterString isEqualToString:@"×"] ||
            [lastCharacterString isEqualToString:@"÷"] ||
            [lastCharacterString isEqualToString:@"."]) {
            return [self.text substringToIndex:self.text.length - 1];
        }
    }
    return expressionString;
}

- (NSString *)evaluateExpression:(NSString *)expressionString {
    if (!expressionString) {
        return nil;
    }
    
    NSRange range = [expressionString rangeOfString:@"." options:NSBackwardsSearch];
    if (range.location != NSNotFound && range.location == expressionString.length-1) {
        expressionString = [NSString stringWithFormat:@"%@0",expressionString];
    }
    
    NSString *floatString = [NSString stringWithFormat:@"1.0*%@", expressionString];
    NSString *sanitizedString = [self replaceOperandsInString:floatString];
    
    NSExpression *expression;
    id result;
    @try {
        expression = [NSExpression expressionWithFormat:sanitizedString];
        result = [expression expressionValueWithObject:nil context:nil];
    }
    @catch (NSException *exception) {
        if ([[exception name] isEqualToString:NSInvalidArgumentException]) {
            return nil;
        } else {
            [exception raise];
        }
    }
    if ([result isKindOfClass:[NSNumber class]]) {
        NSInteger integerExpression = [(NSNumber *)result integerValue];
        CGFloat floatExpression = [(NSNumber *)result floatValue];
        if (integerExpression == floatExpression) {
            return [(NSNumber *)result stringValue];
        } else if (floatExpression >= CGFLOAT_MAX || isnan(floatExpression)) {
            return @"0";
        }else {
            return [NSString stringWithFormat:@"%.2f", floatExpression];
        }
    } else {
        return nil;
    }
}

- (NSString *)replaceOperandsInString:(NSString *)string {
    NSString *subtractReplaced = [string stringByReplacingOccurrencesOfString:@"—" withString:@"-"];
    NSString *divideReplaced = [subtractReplaced stringByReplacingOccurrencesOfString:@"÷" withString:@"/"];
    return [divideReplaced stringByReplacingOccurrencesOfString:@"×" withString:@"*"];
}
@end
