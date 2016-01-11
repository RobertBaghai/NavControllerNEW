//
//  Company.h
//  Nav Controller Re-Done
//
//  Created by Robert Baghai on 1/8/16.
//  Copyright © 2016 Robert Baghai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Company : NSObject

@property (nonatomic, strong) NSString *companyName;
@property (nonatomic, strong) UIImage *companyLogo;
@property (nonatomic, strong) NSString *stockCode;
@property (nonatomic, strong) NSString *stockPrice;
@property (nonatomic, strong) NSMutableArray *companyProducts;

@end
