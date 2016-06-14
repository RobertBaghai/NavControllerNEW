//
//  CoreCompany+CoreDataProperties.h
//  Nav Controller Re-Done
//
//  Created by Robert Baghai on 2/24/16.
//  Copyright © 2016 Robert Baghai. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CoreCompany.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoreCompany (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *companyName;
@property (nullable, nonatomic, retain) NSString *companyLogo;
@property (nullable, nonatomic, retain) NSString *companyStockCode;
@property (nullable, nonatomic, retain) NSNumber *companyPosition;
@property (nullable, nonatomic, retain) NSSet<CoreProduct *> *products;

@end

@interface CoreCompany (CoreDataGeneratedAccessors)

- (void)addProductsObject      :(CoreProduct *)value;
- (void)removeProductsObject   :(CoreProduct *)value;
- (void)addProducts   :(NSSet<CoreProduct *> *)values;
- (void)removeProducts:(NSSet<CoreProduct *> *)values;

@end

NS_ASSUME_NONNULL_END
