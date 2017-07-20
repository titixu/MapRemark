//
//  MRDBInteractor.m
//  MapRemark
//
//  Created by SamXu on 19/7/17.
//  Copyright © 2017 AnXu. All rights reserved.
//

#import "MRDBInteractor.h"
#import "MRNote.h"
#import "MRNoteFactory.h"

@import CoreLocation;
@import Firebase;
@import FirebaseAuth;

@interface MRDBInteractor ()

@property (strong, nonatomic) FIRDatabaseReference *DBRef;

@end

@implementation MRDBInteractor

- (FIRDatabaseReference *)DBRef {
    if (!_DBRef) {
        _DBRef = [[FIRDatabase database] reference];
    }
    return _DBRef;
}

- (void)postNote:(MRNote *)note {
    NSDictionary *post = note.dictionaryRepresentation;
    NSDictionary *childUpdates = @{[@"/notes/" stringByAppendingString:note.uid] : post};
    [self.DBRef updateChildValues:childUpdates];

}

-(void)fetchAllNotesHandler:(void(^)(FIRDataSnapshot *snapshot))handler {
    
    [[self.DBRef child:@"notes"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        handler(snapshot);
    }];
}

- (void)removeNote:(MRNote *)note completionBlock:(void (^)(NSError *error))completionBlock {
    
    [[[self.DBRef child:@"notes"] child:note.uid] removeValueWithCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
            completionBlock(error);
    }];
}

- (void)removeNote:(MRNote *)note {
    [[[self.DBRef child:@"notes"] child:note.uid] removeValue];
}

@end
