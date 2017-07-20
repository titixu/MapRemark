//
//  MRNoteAnnotation.h
//  MapRemark
//
//  Created by SamXu on 19/7/17.
//  Copyright © 2017 AnXu. All rights reserved.
//

#import <MapKit/MapKit.h>

@class MRNote;
@class FIRDataSnapshot;

NS_ASSUME_NONNULL_BEGIN

@interface MRNoteAnnotation : MKPointAnnotation

@property (nonatomic, strong) MRNote * note;

//init and set up with a note instance
+(instancetype )noteAnnotationWithNote:(MRNote *)note;

@end

NS_ASSUME_NONNULL_END
