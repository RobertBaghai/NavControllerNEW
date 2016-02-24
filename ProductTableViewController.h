//
//  ProductTableViewController.h
//  Nav Controller Re-Done
//
//  Created by Robert Baghai on 1/8/16.
//  Copyright © 2016 Robert Baghai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Company.h"

@interface ProductTableViewController : UITableViewController 

@property (nonatomic, strong) NSMutableArray *companyProducts;
@property (nonatomic, strong) Company *company;

@end
