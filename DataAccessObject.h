//
//  DataAccessObject.h
//  Nav Controller Re-Done
//
//  Created by Robert Baghai on 1/8/16.
//  Copyright © 2016 Robert Baghai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataAccessObject : NSObject

@property (nonatomic, strong) NSMutableArray *companyList;
@property (nonatomic, strong) NSMutableArray *stockPrices;

#pragma mark - Shared Instance Method
+ (instancetype)sharedInstance;

#pragma mark - Hard Coded Values
- (void)getCompaniesAndProducts;

#pragma mark - Update Stocks
- (void) updateStockPrices;

@end
