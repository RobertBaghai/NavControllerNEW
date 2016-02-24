//
//  DataAccessObject.h
//  Nav Controller Re-Done
//
//  Created by Robert Baghai on 1/8/16.
//  Copyright © 2016 Robert Baghai. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Company;
@class Product;

@interface DataAccessObject : NSObject

@property (nonatomic, strong) NSMutableArray *companyList;

#pragma mark - Shared Instance Method
+ (instancetype)sharedInstance;

#pragma mark - Get Data using SQL
- (void) createEditableCopyOfDatabaseIfNeeded;

#pragma mark - Delete using SQL
- (void) deleteCompanyWithQuery     : (Company*)company;
- (void) deleteProductWithQuery     : (Product*)product;

#pragma mark - Add using SQL
- (void) addCompanyWithQuery        : (Company*)company;
- (void) addProductWithQuery        : (Product*)product forCompanyId:(Company*)company;

#pragma mark - Update using SQL
- (void) updateCompanyDataWithQuery : (Company*)company;
- (void) updateProductDataWithQuery : (Product*)product;

#pragma mark - Move using SQL
- (void) moveCompanyWithQuery       : (Company*)company;
- (void) moveProductWithQuery       : (Product*)product usingArray: (NSMutableArray*)companyProducts;

@end
