//
//  MRSignUpViewController.m
//  MapRemark
//
//  Created by SamXu on 20/7/17.
//  Copyright © 2017 AnXu. All rights reserved.
//

#import "MRSignUpViewController.h"
#import "NSString+MRStringValidation.h"
#import "UIAlertController+MRAlerts.h"

#import <FirebaseAuth/FirebaseAuth.h>
#import "Constants.h"

@interface MRSignUpViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

@end

@implementation MRSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}



#pragma mark- IBAction

- (IBAction)cancelButtonClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)signMeUpButtonClicked:(UIButton *)sender {
    //validate all the text field before sign up
    if ([self validateTextField]) {
        //sign up with user email and password
        [[FIRAuth auth] createUserWithEmail:self.emailTextField.text password:self.passwordTextField.text completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
            if (error) {
                UIAlertController *alertController = [UIAlertController defaultAlertWithTitle:nil message:error.localizedDescription];
                [self presentViewController:alertController animated:YES completion:^{}];
            } else {
                //if success store the email and password in userdefault
                //TODO: store user passwor is not secure, should store user token instead
                [[NSUserDefaults standardUserDefaults] setObject:self.emailTextField.text forKey:MRUserEmail];
                [[NSUserDefaults standardUserDefaults] setObject:self.passwordTextField.text forKey:MRUserPassword];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:MRNewUserSignedUp];
                [[NSUserDefaults standardUserDefaults] synchronize];
                //dismiss self after all done
                
                //also update the display name
                FIRUserProfileChangeRequest *changeRequest = [[FIRAuth auth].currentUser profileChangeRequest];
                changeRequest.displayName = self.userNameTextField.text;
                [changeRequest commitChangesWithCompletion:^(NSError * _Nullable error) {}];
                [self dismissViewControllerAnimated:YES completion:^{}];
            }
        }];
    }
}

#pragma mark- Text Field Delegate
//default way to dismiss the keyboard for all text fields
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma mark- Private 
- (BOOL)validateTextField {
    //user name should not be empty
    if (!self.userNameTextField.text.length) {
        UIAlertController *alertController = [UIAlertController defaultAlertWithTitle:nil message:@"Please, fill in your name"];
        [self presentViewController:alertController animated:YES completion:^{
            [self.userNameTextField becomeFirstResponder];
        }];
        return NO;
    }
    
    //email needs to be valid
    if (![self.emailTextField.text isValidEmail]) {
        UIAlertController *alertController = [UIAlertController defaultAlertWithTitle:nil message:@"Please, enter a valid email"];
        [self presentViewController:alertController animated:YES completion:^{
            [self.emailTextField becomeFirstResponder];
        }];
        return NO;
    }
    
    //password should match
    if ([self.passwordTextField.text isEqualToString:@""] ||
        [self.confirmPasswordTextField.text isEqualToString:@""] ||
        ![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
        UIAlertController *alertController = [UIAlertController defaultAlertWithTitle:nil message:@"Password does not match"];
        [self presentViewController:alertController animated:YES completion:^{
            [self.passwordTextField becomeFirstResponder];
        }];
        return NO;
    }
    
    return YES;
}
@end
