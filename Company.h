//
//  Company.h
//  Nav Controller Re-Done
//
//  Created by Robert Baghai on 1/8/16.
//  Copyright © 2016 Robert Baghai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Company : NSObject

@property (nonatomic, strong) NSString       *companyName;
@property (nonatomic, strong) NSString       *companyLogo;
@property (nonatomic, strong) NSString       *stockCode;
@property (nonatomic, strong) NSString       *stockPrice;
@property (nonatomic, strong) NSString       *companyId;
@property (nonatomic, strong) NSMutableArray *companyProducts;
@property (nonatomic, assign) NSUInteger      companyPosition;

@end
