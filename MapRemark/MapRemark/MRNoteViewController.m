//
//  MRNoteViewController.m
//  MapRemark
//
//  Created by SamXu on 20/7/17.
//  Copyright © 2017 AnXu. All rights reserved.
//

#import "MRNoteViewController.h"
#import "MRNote.h"
#import "MRDBInteractor.h"
#import "UIAlertController+MRAlerts.h"

@import FirebaseAuth;
@import Firebase;

@interface MRNoteViewController ()

@property (weak, nonatomic) IBOutlet UITextView *noteTextView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *privacyControl;

@property (nonatomic, strong) MRDBInteractor *interactor;

@end

@implementation MRNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.note.displayName;
    self.noteTextView.text = self.note.body;
    self.privacyControl.selectedSegmentIndex = self.note.pricacy;
    
    //UI bugs, somehow, it ignores the IB config, and it is set to not editable
    self.noteTextView.editable = YES;
    
    if(![self isNoteBelongToUser]) {
        [self disableUI];
    }
}

#pragma mark- IBActions

- (IBAction)deleteButtonClicked:(UIButton *)sender {
    [self disableUI];
    [self.interactor removeNote:self.note completionBlock:^(NSError * _Nullable error) {
        if (error) {
            UIAlertController *alert = [UIAlertController defaultAlertWithTitle:error.localizedDescription message:error.localizedFailureReason];
            [self presentViewController:alert animated:YES completion:^{
                [self enableUI];
            }];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (IBAction)saveButtonClicked:(UIButton *)sender {
    self.note.body = self.noteTextView.text;
    self.note.pricacy = self.privacyControl.selectedSegmentIndex;
    [self disableUI];
    [self.interactor postNote:self.note];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- Getters
-(MRDBInteractor *)interactor {
    if (!_interactor) {
        _interactor = [[MRDBInteractor alloc] init];
    }
    return _interactor;
}


#pragma mark- Private methods
- (BOOL)isNoteBelongToUser {
    FIRUser *user = [FIRAuth auth].currentUser;
    return ([user.uid isEqualToString:self.note.userid]);
}

//disable for interacting with DB
-(void)disableUI {
    [self.noteTextView resignFirstResponder];
    self.noteTextView.editable = NO;
    self.deleteButton.enabled = NO;
    self.saveButton.enabled = NO;
    self.privacyControl.enabled = NO;
}

//enable all UI for editing, but only for owner's notes
- (void)enableUI {
    BOOL enable = [self isNoteBelongToUser];
    self.noteTextView.editable = enable;
    self.deleteButton.enabled = enable;
    self.saveButton.enabled = enable;
    self.privacyControl.enabled = enable;
}

@end
