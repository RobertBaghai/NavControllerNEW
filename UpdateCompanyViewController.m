//
//  UpdateCompanyViewController.m
//  Nav Controller Re-Done
//
//  Created by Robert Baghai on 1/10/16.
//  Copyright © 2016 Robert Baghai. All rights reserved.
//

#import "UpdateCompanyViewController.h"
#import "Company.h"

@interface UpdateCompanyViewController ()

@property (weak, nonatomic) IBOutlet UITextField *updatedCompanyNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *updatedCompanyStockCodeTextField;
@property (nonatomic, strong) Company *company;

@end

@implementation UpdateCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setValuesForSubViews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Give Subviews Data
- (void)setValuesForSubViews {
    self.company = [self.array objectAtIndex:self.indexPath.row];
    self.updatedCompanyNameTextField.text = self.company.companyName;
    self.updatedCompanyStockCodeTextField.text = self.company.stockCode;
    self.imageToBeEdited.image = self.company.companyLogo;
}

- (IBAction)submitUpdatedCompanyButton:(id)sender {
    self.company.companyName = self.updatedCompanyNameTextField.text;
    self.company.stockCode = self.updatedCompanyStockCodeTextField.text;
    self.company.companyLogo = self.imageToBeEdited.image;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)selectNewCompanyLogoButton:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary*)info {
    self.imageToBeEdited.image = info[UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
