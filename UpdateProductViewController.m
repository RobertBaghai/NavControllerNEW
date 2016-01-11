//
//  UpdateProductViewController.m
//  Nav Controller Re-Done
//
//  Created by Robert Baghai on 1/10/16.
//  Copyright © 2016 Robert Baghai. All rights reserved.
//

#import "UpdateProductViewController.h"
#import "Product.h"

@interface UpdateProductViewController ()

@property (weak, nonatomic) IBOutlet UITextField *updatedProductNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *updatedProductUrlTextField;
@property (nonatomic, strong) Product *product;

@end

@implementation UpdateProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setValuesForSubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - Give Subviews Data
- (void)setValuesForSubViews {
    self.product = [self.array objectAtIndex:self.indexPath.row];
    self.updatedProductNameTextField.text = self.product.productName;
    self.updatedProductUrlTextField.text = self.product.productUrl;
    self.imageToBeEdited.image = self.product.productLogo;
}

- (IBAction)submitUpdatedProductButton:(id)sender {
    self.product.productName = self.updatedProductNameTextField.text;
    self.product.productUrl = self.updatedProductUrlTextField.text;
    self.product.productLogo = self.imageToBeEdited.image;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)selectNewProductLogoButton:(id)sender {
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
