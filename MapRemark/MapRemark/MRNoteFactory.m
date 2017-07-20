//
//  MRNoteFactory.m
//  MapRemark
//
//  Created by SamXu on 19/7/17.
//  Copyright © 2017 AnXu. All rights reserved.
//

#import "MRNoteFactory.h"
#import "MRNote.h"
#import <CoreLocation/CoreLocation.h>

@import Firebase;
@import FirebaseAuth;
@import CoreLocation;

@implementation MRNoteFactory

//create a default empty note for adding an new annotation by user
+ (MRNote *)noteForCurrentUserWithCoordinate:(CLLocationCoordinate2D)coordinate {
    FIRUser *user = [FIRAuth auth].currentUser;
    FIRDatabaseReference *DBRef = [[FIRDatabase database] reference];
    NSString *key = [[DBRef child:@"notes"] childByAutoId].key;
    MRNote *aNote = [MRNoteFactory noteWithUid:key user:user coordinate:coordinate privacy:MRNotesPrivacyPublic body:@"Note"];
    return aNote;
}

+ (MRNote *)noteWithUid: (NSString *) uid user:(FIRUser *)user coordinate:(CLLocationCoordinate2D)coordinate privacy:(MRNotesPrivacy)privacy  body:(NSString *) noteBody {
    
    MRNote *note = [[MRNote alloc] init];
    note.uid = uid;
    note.userid = user.uid;
    note.displayName = user.displayName ?: @"noname";
    note.latitude = coordinate.latitude;
    note.longitude = coordinate.longitude;
    note.pricacy = privacy;
    note.body = noteBody;
    note.timeStamp = [NSDate date];
    
    return note;
}

//convert the FIRDataSnapshot into an note instance
+ (MRNote * _Nullable)noteWithDataSnapshot:(FIRDataSnapshot *)child {
    
    NSDictionary *dict = child.value;
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    MRNote *note = [[MRNote alloc] init];
    note.uid = child.key;
    note.userid = dict[@"userID"];
    note.displayName = dict[@"author"];
    
    NSNumber *lat = dict[@"lat"];
    note.latitude = lat.doubleValue;
    
    NSNumber *longitude = dict[@"long"];
    note.longitude = longitude.doubleValue;
    
    NSNumber *pricacy = dict[@"privacy"];
    note.pricacy = pricacy.boolValue;
    
    note.body = dict[@"body"];
    
    NSNumber *time = dict[@"time"];
    note.timeStamp = [NSDate dateWithTimeIntervalSinceReferenceDate: time.doubleValue];
    
    return note;
}

@end
