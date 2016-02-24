//
//  UpdateProductViewController.m
//  Nav Controller Re-Done
//
//  Created by Robert Baghai on 1/10/16.
//  Copyright © 2016 Robert Baghai. All rights reserved.
//

#import "UpdateProductViewController.h"
#import "Product.h"
#import "DataAccessObject.h"

@interface UpdateProductViewController ()

@property (weak, nonatomic) IBOutlet UITextField *updatedProductNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *updatedProductUrlTextField;
@property (weak, nonatomic) IBOutlet UIImageView *updateProductLogo;
@property (nonatomic, strong) Product            *product;
@property (nonatomic, strong) DataAccessObject   *dao;

@end

@implementation UpdateProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dao = [DataAccessObject sharedInstance];
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
    self.product                          = [self.updateProductArray objectAtIndex:self.indexPath.row];
    self.updatedProductNameTextField.text = self.product.productName;
    self.updatedProductUrlTextField.text  = self.product.productUrl;
    self.updateProductLogo.image          = [UIImage imageNamed:@"newBulb.jpg"];
}

- (IBAction)submitUpdatedProductButton:(id)sender {
    self.product.productName = self.updatedProductNameTextField.text;
    self.product.productUrl  = self.updatedProductUrlTextField.text;
    self.product.productLogo = @"newBulb.jpg";
    [self.dao updateProductDataWithQuery:self.product];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
