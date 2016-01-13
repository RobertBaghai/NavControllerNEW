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
@property (weak, nonatomic) IBOutlet UIImageView *updateCompanyLogo;

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
    self.company = [self.updatedCompanyArray objectAtIndex:self.indexPath.row];
    self.updatedCompanyNameTextField.text = self.company.companyName;
    self.updatedCompanyStockCodeTextField.text = self.company.stockCode;
    self.updateCompanyLogo.image = [UIImage imageNamed:@"newNeutron.jpg"];
}

- (IBAction)submitUpdatedCompanyButton:(id)sender {
    self.company.companyName = self.updatedCompanyNameTextField.text;
    self.company.stockCode = self.updatedCompanyStockCodeTextField.text;
    self.company.companyLogo = @"newNeutron.jpg";
    [self.navigationController popViewControllerAnimated:YES];
}

@end
