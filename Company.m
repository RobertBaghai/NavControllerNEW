//
//  Company.m
//  Nav Controller Re-Done
//
//  Created by Robert Baghai on 1/8/16.
//  Copyright © 2016 Robert Baghai. All rights reserved.
//

#import "Company.h"

@implementation Company

#pragma mark Encode With Key
-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.companyName forKey:@"companyName"];
    [aCoder encodeObject:self.companyLogo forKey:@"companyLogo"];
    [aCoder encodeObject:self.companyProducts forKey:@"companyProducts"];
    [aCoder encodeObject:self.stockCode forKey:@"stockCode"];
}

#pragma mark Decode With Key
-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if( self ){
        self.companyName = [aDecoder decodeObjectForKey:@"companyName"];
        self.companyLogo = [aDecoder decodeObjectForKey:@"companyLogo"];
        self.companyProducts = [aDecoder decodeObjectForKey:@"companyProducts"];
        self.stockCode = [aDecoder decodeObjectForKey:@"stockCode"];
    }
    return self;
}

@end
