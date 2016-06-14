//
//  AddProductsViewController.h
//  Nav Controller Re-Done
//
//  Created by Robert Baghai on 1/8/16.
//  Copyright © 2016 Robert Baghai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Company.h"

@interface AddProductsViewController : UIViewController 

@property (nonatomic, weak)   NSMutableArray *addedProductArray;
@property (nonatomic, strong) Company        *company;
@property (nonatomic, strong) NSIndexPath    *companyIndex;

@end
