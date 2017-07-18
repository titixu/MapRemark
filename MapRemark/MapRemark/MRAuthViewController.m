//
//  ViewController.m
//  MapRemark
//
//  Created by SamXu on 17/7/17.
//  Copyright © 2017 AnXu. All rights reserved.
//

#import "MRAuthViewController.h"
#import "UIAlertController+MRAlerts.h"
#import "Constants.h"

@import FirebaseAuth;

@interface MRAuthViewController () <UITextFieldDelegate>

@property (nonatomic, assign) FIRAuthStateDidChangeListenerHandle authStateDidChangeHandler;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;

@end

@implementation MRAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:MRUserEmail];
    self.emailTextField.text = email;
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:MRUserPassword];
    self.passwordTextField.text = password;
}

- (IBAction)signUpButtonClicked:(UIButton *)sender {

    if ([self validateTextFields]) {
        
        [self toggleViewsForProgress:YES];
        
        [[FIRAuth auth] createUserWithEmail:self.emailTextField.text password:self.passwordTextField.text completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
            if (self.userNameTextField.text.length) {
                FIRUserProfileChangeRequest *changeRequest = [[FIRAuth auth].currentUser profileChangeRequest];
                changeRequest.displayName = self.userNameTextField.text;
                [changeRequest commitChangesWithCompletion:^(NSError * _Nullable error) {
                    if (error) {
                        NSLog(@"change display name error %@", error);
                    }
                    [self userLogedIn:[FIRAuth auth].currentUser error:error];
                }];
            } else {
                [self userLogedIn:user error:error];
            }
        }];
    }
}

- (IBAction)loginButtonClicked:(UIButton *)sender {
    if ([self validateTextFields]) {
        [self toggleViewsForProgress:YES];
        [[FIRAuth auth] signInWithEmail:self.emailTextField.text password:self.passwordTextField.text completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
            [self userLogedIn:user error:error];
        }];
    }
}

- (void)userLogedIn:(FIRUser *)user error: (NSError *)error {
    NSString *title = @"Welcome";
    NSString *message = user.displayName ?: user.email;
    
    [self toggleViewsForProgress:NO];
    
    if (error) {
        title = @"Error occurred";
        message = error.localizedDescription;
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:self.emailTextField.text forKey:MRUserEmail];
        [[NSUserDefaults standardUserDefaults] setObject:self.passwordTextField.text forKey:MRUserPassword];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    UIAlertController *alertController = [UIAlertController defaultAlertWithTitle:title message:message];
    [self presentViewController:alertController animated:YES completion:^{
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self navigateToMapViewController];
            });
        }
    }];
    

}

- (BOOL)validateTextFields {
    if (self.emailTextField.text.length == 0 || self.passwordTextField.text.length == 0) {
        UIAlertController *alertController = [UIAlertController defaultAlertWithTitle:@"Missing email or password" message:@"Please fill in both email and password"];
        [self presentViewController:alertController animated:YES completion:^{}];
        return NO;
    } else {
        return YES;
    }
}

- (void)toggleViewsForProgress:(BOOL)inProgress {
    
    if (inProgress) {
        [self.emailTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];
    }
    
    self.emailTextField.enabled = !inProgress;
    self.passwordTextField.enabled = !inProgress;
    self.signUpButton.enabled = !inProgress;
    self.loginButton.enabled = !inProgress;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.emailTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else if (textField == self.passwordTextField) {
        [self signUpButtonClicked:nil];
    }
    return YES;
}

- (void)navigateToMapViewController {
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MRMapViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
