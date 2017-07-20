//
//  MRNoteFactory.h
//  MapRemark
//
//  Created by SamXu on 19/7/17.
//  Copyright © 2017 AnXu. All rights reserved.
//

//Factory class that respons for genreating Note instance

#import <Foundation/Foundation.h>
#import "MRNote.h"
#import <CoreLocation/CoreLocation.h>

@class FIRUser;
@class MRNote;
@class CLLocation;
@class FIRDataSnapshot;

NS_ASSUME_NONNULL_BEGIN

@interface MRNoteFactory : NSObject

//User long press and try to add an annotation to the map, create a default note for it
+ (MRNote *)noteForCurrentUserWithCoordinate:(CLLocationCoordinate2D)coordinate;

+ (MRNote *)noteWithUid: (NSString *) uid user:(FIRUser *)user coordinate:(CLLocationCoordinate2D)coordinate privacy:(MRNotesPrivacy)privacy body:(NSString *) noteBody;

//convert the FIRDataSnapshot into an note instance
+ (MRNote * _Nullable)noteWithDataSnapshot:(FIRDataSnapshot *)child;

@end

NS_ASSUME_NONNULL_END
