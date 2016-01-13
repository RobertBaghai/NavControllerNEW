//
//  Product.m
//  Nav Controller Re-Done
//
//  Created by Robert Baghai on 1/8/16.
//  Copyright © 2016 Robert Baghai. All rights reserved.
//

#import "Product.h"

@implementation Product
#pragma mark Encode With Key
-(void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.productName forKey:@"productName"];
    [aCoder encodeObject:self.productLogo forKey:@"productLogo"];
    [aCoder encodeObject:self.productUrl forKey:@"productUrl"];
}

#pragma mark Decode With Key
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if( self ){
        self.productName = [aDecoder decodeObjectForKey:@"productName"];
        self.productLogo = [aDecoder decodeObjectForKey:@"productLogo"];
        self.productUrl = [aDecoder decodeObjectForKey:@"productUrl"];
    }
    return self;
}



@end
