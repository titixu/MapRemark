//
//  MRNoteAnnotation.m
//  MapRemark
//
//  Created by SamXu on 19/7/17.
//  Copyright © 2017 AnXu. All rights reserved.
//

#import "MRNoteAnnotation.h"
#import "MRNoteFactory.h"
#import "MRNote.h"

#import <CoreLocation/CoreLocation.h>

@implementation MRNoteAnnotation

+(instancetype )noteAnnotationWithNote:(MRNote *)note {
    MRNoteAnnotation *annotation = [[MRNoteAnnotation alloc] init];
    annotation.note = note;
    annotation.coordinate = CLLocationCoordinate2DMake(note.latitude, note.longitude);
    annotation.title = note.displayName;
    annotation.subtitle = note.body;
    return annotation;
}

@end
