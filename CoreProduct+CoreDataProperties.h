//
//  CoreProduct+CoreDataProperties.h
//  Nav Controller Re-Done
//
//  Created by Robert Baghai on 2/24/16.
//  Copyright © 2016 Robert Baghai. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CoreProduct.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoreProduct (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString    *productName;
@property (nullable, nonatomic, retain) NSString    *productLogo;
@property (nullable, nonatomic, retain) NSString    *productUrl;
@property (nullable, nonatomic, retain) NSNumber    *productPosition;
@property (nullable, nonatomic, retain) CoreCompany *company;

@end

NS_ASSUME_NONNULL_END
