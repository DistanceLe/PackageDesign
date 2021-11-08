//
//  PEBagViewController.m
//  PackageDesign
//
//  Created by lijie on 2021/11/5.
//

#import "PEBagViewController.h"

@interface PEBagViewController ()

@property (weak, nonatomic) IBOutlet UITextField *boxLengthTextField;
@property (weak, nonatomic) IBOutlet UITextField *boxWidthTextField;
@property (weak, nonatomic) IBOutlet UITextField *boxHeightTextField;

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;


@end

@implementation PEBagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self initData];
}

-(void)initData{
    
    
    for (NSInteger i = 1; i<=6; i++) {
        NSString* text = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%ldTextPE", i]];
        if (text) {
            UITextField* textField = [self.view viewWithTag:i];
            textField.text = text;
        }
    }
    [self calculateResult];
}
-(void)calculateResult{
    if (self.boxLengthTextField.text.length == 0 ||
        self.boxWidthTextField.text.length == 0 ||
        self.boxHeightTextField.text.length == 0
        ) {
        return;
    }
    
    NSInteger needDecimal = 1;
    if ([self.boxLengthTextField.text containsString:@"."] ||
        [self.boxWidthTextField.text containsString:@"."] ||
        [self.boxHeightTextField.text containsString:@"."]
        ) {
        needDecimal = 10;
    }
    
    NSInteger boxLength = self.boxLengthTextField.text.floatValue*needDecimal;
    NSInteger boxWidth = self.boxWidthTextField.text.floatValue*needDecimal;
    NSInteger boxHeight = self.boxHeightTextField.text.floatValue*needDecimal;
    
    NSInteger peWidth = boxWidth+boxLength;
    
    NSInteger maxBoxEdge = boxWidth>boxLength?boxWidth:boxLength;
    NSInteger triangleTwoHeight = peWidth-maxBoxEdge;
    NSInteger peLength = triangleTwoHeight + boxHeight;
    
    if (needDecimal == 1) {
        self.resultLabel.text = [NSString stringWithFormat:@"PE袋子 最小尺寸(长*宽): %ld * %ld", peLength, peWidth];
    }else{
        self.resultLabel.text = [NSString stringWithFormat:@"PE袋子 最小尺寸(长*宽): %.2f * %.2f", peLength*1.0/needDecimal, peWidth*1.0/needDecimal];
    }
    
}

#pragma mark - ================ Delegate ==================
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField.text containsString:@"."]) {
        textField.text = [NSString stringWithFormat:@"%.1f", textField.text.floatValue];
    }else{
        textField.text = [NSString stringWithFormat:@"%ld", textField.text.integerValue];
    }
    [[NSUserDefaults standardUserDefaults]setObject:textField.text forKey:[NSString stringWithFormat:@"%ldTextPE", textField.tag]];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self calculateResult];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag != 6) {
        UITextField* nextTextField = [self.view viewWithTag:textField.tag+1];
        if (nextTextField) {
            [nextTextField becomeFirstResponder];
        }
    }else{
        [self calculateResult];
        [self.view endEditing:YES];
    }
    return YES;
}






@end
