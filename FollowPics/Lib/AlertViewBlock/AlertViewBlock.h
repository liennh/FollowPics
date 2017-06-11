//
//  AlertViewBlock.h
//  Hulo
//
//  Created by Ngo Hoang Lien on 5/25/15.
//  Copyright (c) 2015 Hulo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"

typedef void (^VoidBlock)(void);
typedef void (^AlertBlock)(BOOL status);

@interface AlertViewBlock : NSObject <UIAlertViewDelegate>

+ (void)showConfirmRetryMessage:(NSString *)message withTitle:(NSString *)title withBlock:(AlertBlock)aBlock;
+ (void)showConfirmGoMessage:(NSString *)message withBlock:(AlertBlock)aBlock;
+ (void)showConfirmGoMessage:(NSString *)message labelClose:(NSString*) labelClose labelGo:(NSString*) labelGo withBlock:(AlertBlock)aBlock;
+ (void)showOkMessage:(NSString *)message withBlock:(VoidBlock)aBlock;
+ (void)showOkMessage:(NSString *)message withTitle:(NSString *)title withBlock:(VoidBlock)aBlock;
+ (void) showConfirmWithTitle:(NSString *)title  message:(NSString *)msg strLeftButton:(NSString *)leftButton
               srtRightButton:(NSString *)rightButton withBlock:(AlertBlock)aBlock;



@end
