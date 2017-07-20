//
//  UIAlertController+MRAlerts.h
//  MapRemark
//
//  Created by SamXu on 18/7/17.
//  Copyright © 2017 AnXu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (MRAlerts)

//default alert controller with just title and an "OK" button
+ (instancetype)defaultAlertWithTitle: (NSString *)title message:(NSString *)message;

@end
