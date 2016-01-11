//
//  AddCompanyViewController.m
//  Nav Controller Re-Done
//
//  Created by Robert Baghai on 1/8/16.
//  Copyright © 2016 Robert Baghai. All rights reserved.
//

#import "AddCompanyViewController.h"
#import "DataAccessObject.h"
#import "Company.h"

@interface AddCompanyViewController ()

@property (weak, nonatomic) IBOutlet UITextField *companyNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *companyStockCodeTextField;
@property (weak, nonatomic) IBOutlet UIImageView *theImage;
@property (nonatomic, strong) UIImage *pickedImage;

@end

@implementation AddCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Set up ImagePicker/Delegate
- (IBAction)selectLogoButton:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.theImage.image = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Submit New Company
- (IBAction)submitButton:(id)sender {
    Company *company = [[Company alloc] init];
    company.companyName = self.companyNameTextField.text;
    company.companyLogo =  self.theImage.image;
    company.stockCode = self.companyStockCodeTextField.text;
    company.companyProducts = [[NSMutableArray alloc] init];
    [self.array addObject:company];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
