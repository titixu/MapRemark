//
//  MRDBInteractor.h
//  MapRemark
//
//  Created by SamXu on 19/7/17.
//  Copyright © 2017 AnXu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRNote.h"

#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@class CLLocation;
@class FIRDataSnapshot;

@interface MRDBInteractor : NSObject

//insert or update an note instance into the DB
-(void)postNote:(MRNote *)note;

//fetch all notes instances from the DB
//TODO: denormalization the databsae in Firebase so we don't have to fetch all the data for every sreach
//It is one of the biggest issue with Firebase
-(void)fetchAllNotesHandler:(void(^)(FIRDataSnapshot *snapshot))handler;

//remove the note from the server
-(void)removeNote:(MRNote *)note completionBlock:(void (^)(NSError * _Nullable error))completionBlock;
-(void)removeNote:(MRNote *)note;

@end

NS_ASSUME_NONNULL_END
