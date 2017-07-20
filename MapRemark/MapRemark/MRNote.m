//
//  MRNote.m
//  MapRemark
//
//  Created by SamXu on 19/7/17.
//  Copyright © 2017 AnXu. All rights reserved.
//

#import "MRNote.h"

@implementation MRNote

- (NSDictionary *_Nonnull)dictionaryRepresentation {
    
    return @{@"userID" : self.userid,
             @"author" : self.displayName,
             @"body" : self.body,
             @"lat" : @(self.latitude),
             @"long" : @(self.longitude),
             @"time" : @(self.timeStamp.timeIntervalSinceReferenceDate),
             @"privacy" : @(self.pricacy)
             };
}

@end
