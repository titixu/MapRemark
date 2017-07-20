//
//  NSString+MRStringValidation.m
//  MapRemark
//
//  Created by SamXu on 20/7/17.
//  Copyright © 2017 AnXu. All rights reserved.
//

#import "NSString+MRStringValidation.h"

@implementation NSString (MRStringValidation)

- (BOOL)isValidEmail {
    NSString *regex = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

@end
