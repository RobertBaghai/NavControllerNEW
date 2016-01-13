//
//  AddCompanyViewController.m
//  Nav Controller Re-Done
//
//  Created by Robert Baghai on 1/8/16.
//  Copyright © 2016 Robert Baghai. All rights reserved.
//

#import "AddCompanyViewController.h"
#import "Company.h"

@interface AddCompanyViewController ()

@property (weak, nonatomic) IBOutlet UITextField *companyNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *companyStockCodeTextField;
@property (weak, nonatomic) IBOutlet UIImageView *addedCompanyLogo;

@end

@implementation AddCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.addedCompanyLogo.image = [UIImage imageNamed:@"neutron.jpg"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Submit New Company
- (IBAction)submitButton:(id)sender {
    Company *company = [[Company alloc] init];
    company.companyName = self.companyNameTextField.text;
    company.companyLogo =  @"neutron.jpg";
    company.stockCode = self.companyStockCodeTextField.text;
    company.companyProducts = [[NSMutableArray alloc] init];
    [self.addedCompanyArray addObject:company];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
