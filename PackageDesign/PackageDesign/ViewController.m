//
//  ViewController.m
//  PackageDesign
//
//  Created by lijie on 2021/11/4.
//

#import "ViewController.h"

@interface ViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *boxLengthTextField;
@property (weak, nonatomic) IBOutlet UITextField *boxWidthTextField;
@property (weak, nonatomic) IBOutlet UITextField *boxHeightTextField;

@property (weak, nonatomic) IBOutlet UITextField *objectLengthTextField;
@property (weak, nonatomic) IBOutlet UITextField *objectWidthTextField;
@property (weak, nonatomic) IBOutlet UITextField *objectHeightTextField;


@property (weak, nonatomic) IBOutlet UISwitch *onlyRightSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *canLengthSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *canWidthSwitch;


@property (weak, nonatomic) IBOutlet UITextView *resultTextView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initData];
}

-(void)initData{
    NSNumber* onlyRight = [[NSUserDefaults standardUserDefaults]objectForKey:@"onlyRight"];
    NSNumber* canLength = [[NSUserDefaults standardUserDefaults]objectForKey:@"canLength"];
    NSNumber* canWidth = [[NSUserDefaults standardUserDefaults]objectForKey:@"canWidth"];
    
    if (!onlyRight) {
        onlyRight = @(NO);
    }
    if (!canLength) {
        canLength = @(NO);
    }
    if (!canWidth) {
        canWidth = @(NO);
    }
    [self.onlyRightSwitch setOn:onlyRight.boolValue];
    [self.canLengthSwitch setOn:canLength.boolValue];
    [self.canWidthSwitch setOn:canWidth.boolValue];
    
    for (NSInteger i = 1; i<=6; i++) {
        NSString* text = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%ldText", i]];
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
        self.boxHeightTextField.text.length == 0 ||
        
        self.objectLengthTextField.text.length == 0 ||
        self.objectWidthTextField.text.length == 0 ||
        self.objectHeightTextField.text.length == 0
        ) {
        return;
    }
    
    NSInteger needDecimal = 1;
    if ([self.boxLengthTextField.text containsString:@"."] ||
        [self.boxWidthTextField.text containsString:@"."] ||
        [self.boxHeightTextField.text containsString:@"."] ||
        
        [self.objectLengthTextField.text containsString:@"."] ||
        [self.objectWidthTextField.text containsString:@"."] ||
        [self.objectHeightTextField.text containsString:@"."]
        ) {
        needDecimal = 10;
    }
    
    NSInteger boxLength = self.boxLengthTextField.text.floatValue*needDecimal;
    NSInteger boxWidth = self.boxWidthTextField.text.floatValue*needDecimal;
    NSInteger boxHeight = self.boxHeightTextField.text.floatValue*needDecimal;
    
    NSInteger objectLength = self.objectLengthTextField.text.floatValue*needDecimal;
    NSInteger objectWidth = self.objectWidthTextField.text.floatValue*needDecimal;
    NSInteger objectHeight = self.objectHeightTextField.text.floatValue*needDecimal;
    
    NSInteger boxVolume = boxLength*boxWidth*boxHeight;
    NSInteger objectVolume = objectLength*objectWidth*objectHeight;
    
    HYPutType putType = HYPutType_Normal;
    NSInteger maxCount = 0;
    NSInteger maxLengthCount = 0;
    NSInteger maxWidthCount = 0;
    NSInteger maxHeightCount = 0;
    
    //???????????????
    maxLengthCount = boxLength/objectLength;
    maxWidthCount = boxWidth/objectWidth;
    maxHeightCount = boxHeight/objectHeight;
    maxCount = maxLengthCount*maxWidthCount*maxHeightCount;
    
    
    if (!self.onlyRightSwitch.on) {
        NSInteger maxLengthCount2 = boxLength/objectWidth;
        NSInteger maxWidthCount2 = boxWidth/objectLength;
        NSInteger maxHeightCount2 = boxHeight/objectHeight;//????????????
        NSInteger maxCount2 = maxLengthCount2*maxWidthCount2*maxHeightCount2;
        if (maxCount2 > maxCount) {
            putType = HYPutType_NormalAngle90;
            maxCount = maxCount2;
            maxLengthCount = maxLengthCount2;
            maxWidthCount = maxWidthCount2;
            maxHeightCount = maxHeightCount2;
        }
    }

    
    #pragma mark - ================ ?????????????????? ==================
    if (self.canLengthSwitch.on && !self.onlyRightSwitch.on) {
        //????????????????????????
        NSInteger maxLengthCount2 = boxLength/objectLength;//????????????
        NSInteger maxWidthCount2 = boxWidth/objectHeight;
        NSInteger maxHeightCount2 = boxHeight/objectWidth;
        NSInteger maxCount2 = maxLengthCount2*maxWidthCount2*maxHeightCount2;
        if (maxCount2 > maxCount) {
            putType = HYPutType_BottomLength;
            maxCount = maxCount2;
            maxLengthCount = maxLengthCount2;
            maxWidthCount = maxWidthCount2;
            maxHeightCount = maxHeightCount2;
        }
        
        {//????????????????????????
            NSInteger maxLengthCount2 = boxLength/objectHeight;
            NSInteger maxWidthCount2 = boxWidth/objectLength;
            NSInteger maxHeightCount2 = boxHeight/objectWidth;
            NSInteger maxCount2 = maxLengthCount2*maxWidthCount2*maxHeightCount2;
            if (maxCount2 > maxCount) {
                putType = HYPutType_BottomLengthAngle90;
                maxCount = maxCount2;
                maxLengthCount = maxLengthCount2;
                maxWidthCount = maxWidthCount2;
                maxHeightCount = maxHeightCount2;
            }
        }
    }
    
    if (self.canWidthSwitch.on && !self.onlyRightSwitch.on) {
        //????????????????????????
        NSInteger maxLengthCount2 = boxLength/objectHeight;
        NSInteger maxWidthCount2 = boxWidth/objectWidth;//????????????
        NSInteger maxHeightCount2 = boxHeight/objectLength;
        NSInteger maxCount2 = maxLengthCount2*maxWidthCount2*maxHeightCount2;
        if (maxCount2 > maxCount) {
            putType = HYPutType_BottomWidth;
            maxCount = maxCount2;
            maxLengthCount = maxLengthCount2;
            maxWidthCount = maxWidthCount2;
            maxHeightCount = maxHeightCount2;
        }
        
        {//????????????????????????
            NSInteger maxLengthCount2 = boxLength/objectWidth;
            NSInteger maxWidthCount2 = boxWidth/objectHeight;
            NSInteger maxHeightCount2 = boxHeight/objectLength;
            NSInteger maxCount2 = maxLengthCount2*maxWidthCount2*maxHeightCount2;
            if (maxCount2 > maxCount) {
                putType = HYPutType_BottomWidthAngle90;
                maxCount = maxCount2;
                maxLengthCount = maxLengthCount2;
                maxWidthCount = maxWidthCount2;
                maxHeightCount = maxHeightCount2;
            }
        }
    }
    
    NSString* putTypeString = @"";
    switch (putType) {
        case HYPutType_Normal:{
            putTypeString = @"?????????????????????????????????????????????";
            break;
        }
        case HYPutType_NormalAngle90: {
            putTypeString = @"??????????????????90????????????????????????????????????";
            NSInteger tempValue = objectLength;
            objectLength = objectWidth;
            objectWidth = tempValue;
            break;
        }
        case HYPutType_BottomLength: {
            putTypeString = @"?????????????????????????????????????????????";
            NSInteger tempValue = objectWidth;
            objectWidth = objectHeight;
            objectHeight = tempValue;
            break;
        }
        case HYPutType_BottomLengthAngle90: {
            putTypeString = @"?????????????????????????????????????????????";
            NSInteger tempValue = objectLength;
            objectLength = objectHeight;
            objectHeight = objectWidth;
            objectWidth = tempValue;
            break;
        }
        case HYPutType_BottomWidth: {
            putTypeString = @"?????????????????????????????????????????????";
            NSInteger tempValue = objectLength;
            objectLength = objectHeight;
            objectHeight = tempValue;
            break;
        }
        case HYPutType_BottomWidthAngle90: {
            putTypeString = @"?????????????????????????????????????????????";
            NSInteger tempValue = objectLength;
            objectLength = objectWidth;
            objectWidth = objectHeight;
            objectHeight = tempValue;
            break;
        }
        case HYPutType_AllType: {
            putTypeString = @"????????????";
            break;
        }
    }
//    putTypeString = [NSString stringWithFormat:@"????????????????????????:\n%@\n\n??????????????????%ld???\n??????????????????%ld???\n??????????????????%ld???\n??????????????????????%ld???\n\n\n", putTypeString, maxLengthCount, maxWidthCount, maxHeightCount, maxCount];
    
    if (needDecimal == 1) {
        putTypeString = [NSString stringWithFormat:@"????????????????????????:\n%@\n\n??????????????????%ld???\t %ld * %ld = %ld\n??????????????????%ld???\t %ld * %ld = %ld\n??????????????????%ld???\t %ld * %ld = %ld\n??????????????????????%ld???\n\n\n",
                         putTypeString,
                         maxLengthCount,maxLengthCount,objectLength,    maxLengthCount*objectLength,
                         maxWidthCount,maxWidthCount,objectWidth,       maxWidthCount*objectWidth,
                         maxHeightCount,maxHeightCount,objectHeight,    maxHeightCount*objectHeight,
                         maxCount];
    }else{
        putTypeString = [NSString stringWithFormat:@"????????????????????????:\n%@\n\n??????????????????%ld???\t %ld * %.1f = %.1f\n??????????????????%ld???\t %ld * %.1f = %.1f\n??????????????????%ld???\t %ld * %.1f = %.1f\n??????????????????????%ld???\n\n\n",
                         putTypeString,
                         maxLengthCount,maxLengthCount,objectLength*1.0/needDecimal,    maxLengthCount*objectLength*1.0/needDecimal,
                         maxWidthCount,maxWidthCount,objectWidth*1.0/needDecimal,       maxWidthCount*objectWidth*1.0/needDecimal,
                         maxHeightCount,maxHeightCount,objectHeight*1.0/needDecimal,    maxHeightCount*objectHeight*1.0/needDecimal,
                         maxCount];
    }
    
    NSInteger needDecimalVolume = pow(needDecimal, 3);
    
    
    NSString* infoString = @"";
    if (needDecimal == 1) {
        infoString = [NSString stringWithFormat:@"????????????: %ld\n????????????: %ld\n??????????????????????????????: %ld\n\n", boxVolume, objectVolume, boxVolume/objectVolume];
    }else{
        infoString = [NSString stringWithFormat:@"????????????: %.3f\n????????????: %.3f\n??????????????????????????????: %ld???\n\n", boxVolume*1.0/(needDecimalVolume), objectVolume*1.0/(needDecimalVolume), boxVolume/objectVolume];
    }
    
    
    NSString* remainString = @"";
    if (needDecimal == 1) {
        remainString = [NSString stringWithFormat:@"??????????????????%ld\n??????????????????%ld\n??????????????????%ld\n?????????????????????%ld\n\n",
                        boxLength-objectLength*maxLengthCount,
                        boxWidth-objectWidth*maxWidthCount,
                        boxHeight-objectHeight*maxHeightCount,
                        boxVolume-(objectVolume*maxCount)];
    }else{
        remainString = [NSString stringWithFormat:@"??????????????????%.1f\n??????????????????%.1f\n??????????????????%.1f\n?????????????????????%.3f\n\n",
                        (boxLength-objectLength*maxLengthCount)*1.0/needDecimal,
                        (boxWidth-objectWidth*maxWidthCount)*1.0/needDecimal,
                        (boxHeight-objectHeight*maxHeightCount)*1.0/needDecimal,
                        (boxVolume-(objectVolume*maxCount))*1.0/(needDecimalVolume)];
    }
    
    
    
    
    self.resultTextView.text = [NSString stringWithFormat:@"%@%@%@", infoString, putTypeString, remainString];
    
}



- (IBAction)onlyRightClick:(UISwitch *)sender {
    if (sender.on) {
        self.canWidthSwitch.enabled = NO;
        self.canLengthSwitch.enabled = NO;
    }else{
        self.canWidthSwitch.enabled = YES;
        self.canLengthSwitch.enabled = YES;
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:@(sender.isOn) forKey:@"onlyRight"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self calculateResult];
}

- (IBAction)canLengthClick:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults]setObject:@(sender.isOn) forKey:@"canLength"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self calculateResult];
}


- (IBAction)canWidthClick:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults]setObject:@(sender.isOn) forKey:@"canWidth"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self calculateResult];
}

#pragma mark - ================ Delegate ==================
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField.text containsString:@"."]) {
        textField.text = [NSString stringWithFormat:@"%.1f", textField.text.floatValue];
    }else{
        textField.text = [NSString stringWithFormat:@"%ld", textField.text.integerValue];
    }
    [[NSUserDefaults standardUserDefaults]setObject:textField.text forKey:[NSString stringWithFormat:@"%ldText", textField.tag]];
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
