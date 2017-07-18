//
//  UIAlertController+MRAlerts.m
//  MapRemark
//
//  Created by SamXu on 18/7/17.
//  Copyright © 2017 AnXu. All rights reserved.
//

#import "UIAlertController+MRAlerts.h"

@implementation UIAlertController (MRAlerts)

+ (instancetype)defaultAlertWithTitle: (NSString *)title message:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    [alertController addAction:defaultAction];
    return alertController;
}

@end
