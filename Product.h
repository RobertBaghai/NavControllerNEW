//
//  Product.h
//  Nav Controller Re-Done
//
//  Created by Robert Baghai on 1/8/16.
//  Copyright © 2016 Robert Baghai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Product : NSObject

@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) UIImage *productLogo;
@property (nonatomic, strong) NSString *productUrl;

@end
