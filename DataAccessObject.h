//
//  DataAccessObject.h
//  Nav Controller Re-Done
//
//  Created by Robert Baghai on 1/8/16.
//  Copyright © 2016 Robert Baghai. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;
@class  Company;
@class  Product;

@interface DataAccessObject : NSObject

@property (nonatomic, strong) NSMutableArray               *companyList;
@property (nonatomic, strong) NSManagedObjectContext       *managedObjectContext;

#pragma mark - Shared Instance Method
+ (instancetype)sharedInstance;

#pragma mark - Read/Write To Core Data
- (void)readFromCoreDataIfExistsElseCreateFileAndRead;

#pragma mark - Add Using Core Data
- (void)addCompanyToContext: (Company*)company withNewPosition:(NSNumber*)position;
- (void)addProductToContext: (Product*)product withNewPosition:(NSNumber*)position toCompanyIndex:(long)index;

#pragma mark - Delete Using Core Data
- (void)deleteCompanyfromContext:(long)index;
- (void)deleteProductFromContext:(long)index fromCompanyIndex:(long)companyIndex;

#pragma mark - Update Using Core Data
-(void)updateCompany:(Company*)company atIndex:(long)index;
-(void)updateProduct:(Product*) product atIndex:(long)index forCompanyIndex:(long)companyIndex;

#pragma mark - Move Using Core Data
-(void)moveCompany:(Company*)company fromIndex:(long)index toIndex:(long)newIndex;
-(void)moveProductfromIndex:(long)index toIndex:(long)newIndex forCompanyIndex:(long)companyIndex;

@end
