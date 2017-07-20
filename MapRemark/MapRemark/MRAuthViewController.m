//
//  ViewController.m
//  MapRemark
//
//  Created by SamXu on 17/7/17.
//  Copyright © 2017 AnXu. All rights reserved.
//

#import "MRAuthViewController.h"
#import "UIAlertController+MRAlerts.h"
#import "NSString+MRStringValidation.h"
#import "Constants.h"

@import FirebaseAuth;

@interface MRAuthViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation MRAuthViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //prefill emial and password
    //TODO: storing password is not secure
    NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:MRUserEmail];
    self.emailTextField.text = email;
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:MRUserPassword];
    self.passwordTextField.text = password;
}

#pragma mark- IBActions
- (IBAction)loginButtonClicked:(UIButton *)sender {
    if ([self validateTextFields]) {
        [self toggleViewsForProgress:YES];
        [[FIRAuth auth] signInWithEmail:self.emailTextField.text password:self.passwordTextField.text completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
            [self userLogedIn:user error:error];
        }];
    }
}

#pragma mark- Text Field Delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark- Private methods

//presen alert for error, otherwise navigate to the mapview
- (void)userLogedIn:(FIRUser *)user error: (NSError *)error {
    NSString *title = @"Welcome";
    NSString *message = user.displayName ?: user.email;
    
    [self toggleViewsForProgress:NO];
    
    if (error) {
        title = @"Error occurred";
        message = error.localizedDescription;
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:self.emailTextField.text forKey:MRUserEmail];
        //TODO: store user passwor is not secure, should store user token instead
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

//validate the text field before send it to the server
- (BOOL)validateTextFields {
    
    //email needs to be valid
    if (![self.emailTextField.text isValidEmail]) {
        UIAlertController *alertController = [UIAlertController defaultAlertWithTitle:nil message:@"Please, enter a valid email"];
        [self presentViewController:alertController animated:YES completion:^{
            [self.emailTextField becomeFirstResponder];
        }];
        return NO;
    }

    
    if (self.passwordTextField.text.length == 0) {
        UIAlertController *alertController = [UIAlertController defaultAlertWithTitle:nil message:@"Please fill in password"];
        [self presentViewController:alertController animated:YES completion:^{}];
        return NO;
    } else {
        return YES;
    }
}

//when login in progress disable all UIs
- (void)toggleViewsForProgress:(BOOL)inProgress {
    
    if (inProgress) {
        [self.emailTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];
    }
    
    self.signUpButton.enabled = !inProgress;
    self.loginButton.enabled = !inProgress;
}


- (void)navigateToMapViewController {
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MRMapViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
