//
//  AddProductsViewController.m
//  Nav Controller Re-Done
//
//  Created by Robert Baghai on 1/8/16.
//  Copyright © 2016 Robert Baghai. All rights reserved.
//

#import "AddProductsViewController.h"
#import "Product.h"

@interface AddProductsViewController ()

@property (weak, nonatomic) IBOutlet UITextField *productNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *productUrlTextField;
@property (weak, nonatomic) IBOutlet UIImageView *pickedImageDisplay;
@property (nonatomic, strong) UIImage *pickedImage;

@end

@implementation AddProductsViewController

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
- (IBAction)selectLogoButton:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.pickedImageDisplay.image = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Submit New Product
- (IBAction)submitProductButton:(id)sender {
    Product *product = [[Product alloc] init];
    product.productName = self.productNameTextField.text;
    product.productUrl = self.productUrlTextField.text;
    product.productLogo = self.pickedImageDisplay.image;
    [self.array addObject:product];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
