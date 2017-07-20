//
//  MRNote.h
//  MapRemark
//
//  Created by SamXu on 19/7/17.
//  Copyright © 2017 AnXu. All rights reserved.
//

#import <Foundation/Foundation.h>

//DB mapping object

typedef NS_ENUM(NSUInteger, MRNotesPrivacy) {
    MRNotesPrivacyPublic = 0,
    MRNotesPrivacyPrivate = 1
};

@interface MRNote : NSObject

@property (nonatomic, strong) NSString * _Nonnull uid;
@property (nonatomic, strong) NSString * _Nonnull userid;
@property (nonatomic, strong) NSString * _Nonnull displayName;
@property (nonatomic, strong) NSString * _Nonnull body;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, strong) NSDate * _Nonnull timeStamp;
@property (nonatomic, assign) MRNotesPrivacy pricacy;

//get dictionary representation for send it to the server
- (NSDictionary *_Nonnull)dictionaryRepresentation;


@end
