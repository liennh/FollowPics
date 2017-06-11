//
//  AlertViewBlock.m
//  Hulo
//
//  Created by Ngo Hoang Lien on 5/25/15.
//  Copyright (c) 2015 Hulo. All rights reserved.
//

typedef enum {

    Confirm_Yes_No,
    Confirm_Yes_No_Not_Exit,
    Only_OK
} AlertStyle;

#import "AlertViewBlock.h"

@interface  AlertViewBlock()
@property (nonatomic, strong) AlertBlock confirmBlock;
@property (nonatomic, strong) VoidBlock okBlock;
@property (nonatomic, assign) AlertStyle style;

@end

@implementation AlertViewBlock
@synthesize confirmBlock;
@synthesize okBlock;

+ (void)showConfirmRetryMessage:(NSString *)message withTitle:(NSString *)title withBlock:(AlertBlock)aBlock {

    AlertViewBlock *alertBlock = [[AlertViewBlock alloc] init];
    [alertBlock showConfirmRetryMessage: message withTitle: title withBlock: aBlock];
}

+ (void)showConfirmGoMessage:(NSString *)message withBlock:(AlertBlock)aBlock  {

    AlertViewBlock *alertBlock = [[AlertViewBlock alloc] init];
    [alertBlock showConfirmGoMessage: message withBlock: aBlock];
}

+ (void)showConfirmGoMessage:(NSString *)message labelClose:(NSString*) labelClose labelGo:(NSString*) labelGo withBlock:(AlertBlock)aBlock {
    AlertViewBlock *alertBlock = [[AlertViewBlock alloc] init];
    [alertBlock showConfirmGoMessage: message labelClose:labelClose labelGo:labelGo withBlock: aBlock];
}

+ (void) showConfirmWithTitle:(NSString *)title  message:(NSString *)msg strLeftButton:(NSString *)leftButton
               srtRightButton:(NSString *)rightButton withBlock:(AlertBlock)aBlock {
    AlertViewBlock *alertBlock = [[AlertViewBlock alloc] init];
    [alertBlock  showConfirmWithTitle:title message: msg strLeftButton: leftButton srtRightButton:rightButton withBlock:aBlock];
}

- (void) showConfirmWithTitle:(NSString *)title  message:(NSString *)msg strLeftButton:(NSString *)leftButton
                   srtRightButton:(NSString *)rightButton withBlock:(AlertBlock)aBlock {
    self.confirmBlock = aBlock;
    self.style = Confirm_Yes_No_Not_Exit;
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: title message: msg delegate: self cancelButtonTitle: leftButton otherButtonTitles: rightButton, nil];
    [alert show];
    [alert release];

}

- (void)showConfirmRetryMessage:(NSString *)message withTitle:(NSString *)title withBlock:(AlertBlock)aBlock {

    self.confirmBlock = aBlock;
    self.style = Confirm_Yes_No;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: title message: message delegate: self cancelButtonTitle: NSLocalizedString(@"Cancel", nil) otherButtonTitles: NSLocalizedString(@"Retry", nil), nil];
    [alert show];
    [alert release];
}

- (void)showConfirmGoMessage:(NSString *)message withBlock:(AlertBlock)aBlock {

    self.confirmBlock = aBlock;
    self.style = Confirm_Yes_No;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"" message: message delegate: self cancelButtonTitle: NSLocalizedString(@"Buy", nil) otherButtonTitles: NSLocalizedString(@"Restore", nil), nil];
    [alert show];
    [alert release];
}

- (void)showConfirmGoMessage:(NSString *)message labelClose:(NSString*) labelClose labelGo:(NSString*) labelGo withBlock:(AlertBlock)aBlock {
    self.confirmBlock = aBlock;
    self.style = Confirm_Yes_No;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"" message: message delegate: self cancelButtonTitle: NSLocalizedString(labelClose, nil) otherButtonTitles: NSLocalizedString(labelGo, nil), nil];
    [alert show];
    [alert release];
}

+ (void)showOkMessage:(NSString *)message withBlock:(VoidBlock)aBlock {
    AlertViewBlock *alertBlock = [[AlertViewBlock alloc] init];
    [alertBlock showOkMessage: message withBlock: aBlock];
}

+ (void)showOkMessage:(NSString *)message withTitle:(NSString *)title withBlock:(VoidBlock)aBlock {
    
    AlertViewBlock *alertBlock = [[AlertViewBlock alloc] init];
    [alertBlock showOkMessage: message withTitle: title withBlock: aBlock];
}

- (void)showOkMessage:(NSString *)message withTitle:(NSString *)title withBlock:(VoidBlock)aBlock {
    
    self.okBlock = aBlock;
    self.style = Only_OK;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: title message: message delegate: self cancelButtonTitle: NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
    [alert show];
    [alert release];
}

- (void)showOkMessage:(NSString *)message withBlock:(VoidBlock)aBlock {

    self.okBlock = aBlock;
    self.style = Only_OK;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"" message: message delegate: self cancelButtonTitle: NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
    [alert show];
    [alert release];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    switch (self.style) {
        case Confirm_Yes_No: {
            if(buttonIndex == 0) {
                //OK
                if (self.confirmBlock) {
                    self.confirmBlock(NO);
                }
                
            } else {
                if (self.confirmBlock) {
                    self.confirmBlock(YES);
                }

            }

            break;
        }

        case Confirm_Yes_No_Not_Exit: {
            if(buttonIndex == 0) {
                //OK
                if (self.confirmBlock) {
                    self.confirmBlock(NO);
                }
            } else {
                if (self.confirmBlock) {
                    self.confirmBlock(YES);
                }

            }

            break;
        }


        case Only_OK: {
            if (self.okBlock) {
                self.okBlock();
            }
            break;
        }
    }//end switch

    [self release];
}

- (void)dealloc {
    self.confirmBlock = nil;
    self.okBlock = nil;
    [super dealloc];
}

@end
