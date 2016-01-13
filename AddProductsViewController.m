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
@property (weak, nonatomic) IBOutlet UIImageView *addedProductLogo;

@end

@implementation AddProductsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.addedProductLogo.image = [UIImage imageNamed:@"lightBulb.png"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Submit New Product
- (IBAction)submitProductButton:(id)sender {
    Product *product = [[Product alloc] init];
    product.productName = self.productNameTextField.text;
    product.productUrl = self.productUrlTextField.text;
    product.productLogo = @"lightBulb.png";
    [self.addedProductArray addObject:product];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
