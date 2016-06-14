//
//  DataAccessObject.m
//  Nav Controller Re-Done
//
//  Created by Robert Baghai on 1/8/16.
//  Copyright © 2016 Robert Baghai. All rights reserved.
//

#import "DataAccessObject.h"
#import "CoreCompany.h"
#import "CoreProduct.h"
#import <CoreData/CoreData.h>
#import "Company.h"
#import "Product.h"

@interface DataAccessObject()

@property (nonatomic, strong) NSString                     *fileStorePath;
@property (nonatomic, strong) NSManagedObjectModel         *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSFetchRequest               *fetchRequest;
@property (nonatomic, strong) NSPredicate                  *predicate;
@property (nonatomic, strong) NSMutableArray               *fetchResultsArray;

@end


@implementation DataAccessObject

#pragma mark - Shared Instance Method
+ (instancetype)sharedInstance {
    static dispatch_once_t cp_singleton_once_token;
    static DataAccessObject *sharedInstance;
    dispatch_once(&cp_singleton_once_token, ^{
        sharedInstance             = [[self alloc] init];
        sharedInstance.companyList = [[NSMutableArray alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Create Path
- (NSString *) archiveStoreFilePath {
    NSArray  *documentDirectory     = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectoryPath = documentDirectory[0];
    self.fileStorePath              = [documentDirectoryPath stringByAppendingPathComponent:@"CompanyList.data"];

    return self.fileStorePath;
}

#pragma mark - Set up ManagedObjectContext
- (void) initModelContext {
    self.managedObjectModel         = [NSManagedObjectModel mergedModelFromBundles:nil];
    self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    NSURL *storeUrl                 = [NSURL fileURLWithPath:[self archiveStoreFilePath]];
    NSString *path = [self archiveStoreFilePath];
    NSLog(@"Store Path -- %@",path);
    NSError *error = nil;
    if(![self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]){
        [NSException raise:@"Open failed" format:@"Reason: %@", [error localizedDescription]];
    }
    self.managedObjectContext         = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
}

- (void)readFromCoreDataIfExistsElseCreateFileAndRead {
    [self initModelContext];
    self.fetchRequest                        = [[NSFetchRequest alloc] init];
    self.predicate                           = [NSPredicate predicateWithFormat:@"companyName MATCHES '.*'"];
    self.fetchRequest.predicate              = self.predicate;
    NSSortDescriptor *sortCompanyByPosition  = [[NSSortDescriptor alloc] initWithKey:@"companyPosition" ascending:YES];
    self.fetchRequest.sortDescriptors        = [NSArray arrayWithObject: sortCompanyByPosition];
    NSEntityDescription *entity              = [[self.managedObjectModel entitiesByName]objectForKey:@"Company"];
    self.fetchRequest.entity                 = entity;
    
    NSError *error = nil;
    NSArray *fetch = [self.managedObjectContext executeFetchRequest:self.fetchRequest error:&error];
    self.fetchResultsArray = [[NSMutableArray alloc] initWithArray:fetch];
    
    /*
        *Checks to see if data is saved in core data
        *If there is no data saved then load hard coded values into core data
        *Else just read what is saved in core data
     */
    
    if ( self.fetchResultsArray.count == 0 ) {
        [self loadHardCodedValuesIntoManagedContext];
        int i = 0;
        NSNumber *position;
        for (Company *company in self.companyList) {
            position = [NSNumber numberWithInt:i];
            company.companyPosition = position;
            [self createManagedObjectsUsingCompany:company];
            i++;
        }
        [self saveContext];
        NSArray *fetch = [self.managedObjectContext executeFetchRequest:self.fetchRequest error:&error];
        self.fetchResultsArray = [[NSMutableArray alloc]initWithArray:fetch];
    } else {
        for (CoreCompany *managedCompany in self.fetchResultsArray) {
            Company *company        = [[Company alloc] init];
            company.companyName     = managedCompany.companyName;
            company.companyLogo     = managedCompany.companyLogo;
            company.stockCode       = managedCompany.companyStockCode;
            company.companyPosition = managedCompany.companyPosition;
            company.companyProducts = [[NSMutableArray alloc] init];
            
            NSSortDescriptor *sortByProdPosition = [[NSSortDescriptor alloc] initWithKey:@"productPosition" ascending:YES];
            NSArray *products                = [managedCompany.products sortedArrayUsingDescriptors:@[sortByProdPosition]];
            for(CoreProduct *managedProduct in products) {
                Product *product        = [[Product alloc] init];
                product.productName     = managedProduct.productName;
                product.productLogo     = managedProduct.productLogo;
                product.productUrl      = managedProduct.productUrl;
                product.productPosition = managedProduct.productPosition;
                [company.companyProducts addObject:product];
            }
            [self.companyList addObject:company];
        }
        NSArray *fetch = [self.managedObjectContext executeFetchRequest:self.fetchRequest error:&error];
        self.fetchResultsArray = [[NSMutableArray alloc]initWithArray:fetch];
    }
}

#pragma mark - Add Using Core Data
- (void)addCompanyToContext: (Company*)company withNewPosition:(NSNumber*)position {
    CoreCompany *addCompany     = (CoreCompany*)[NSEntityDescription insertNewObjectForEntityForName:@"Company" inManagedObjectContext:self.managedObjectContext];
    addCompany.companyName      = company.companyName;
    addCompany.companyLogo      = company.companyLogo;
    addCompany.companyStockCode = company.stockCode;
    addCompany.companyPosition  = position;
    [self saveContext];
}

- (void)addProductToContext: (Product*)product withNewPosition:(NSNumber*)position toCompanyIndex:(long)index {
    CoreProduct *addProduct = (CoreProduct*)[NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:self.managedObjectContext];
    addProduct.productName     = product.productName;
    addProduct.productLogo     = product.productLogo;
    addProduct.productUrl      = product.productUrl;
    addProduct.productPosition = position;
    
    CoreCompany *coreCompany = (CoreCompany*)[self.fetchResultsArray objectAtIndex:index];
    [coreCompany addProductsObject:addProduct];
    
    [self saveContext];
}

#pragma mark - Delete Using Core Data
- (void)deleteCompanyfromContext:(long)index {
    CoreCompany *deleteCompany = (CoreCompany*)[self.fetchResultsArray objectAtIndex:index];
    [self.managedObjectContext deleteObject:deleteCompany];
    [self.fetchResultsArray removeObject:deleteCompany];
    
    NSError *error = nil;
    if (![deleteCompany.managedObjectContext save:&error]) {
        NSLog(@"Error -- %@, %@",error.localizedDescription, error.userInfo);
    }
    [self saveContext];
}

- (void)deleteProductFromContext:(long)index fromCompanyIndex:(long)companyIndex {
    CoreCompany *deleteFromCompany = (CoreCompany*)[self.fetchResultsArray objectAtIndex:companyIndex];
    CoreProduct *deleteProduct     = (CoreProduct*)[[deleteFromCompany.products allObjects]objectAtIndex:index];
    [self.managedObjectContext deleteObject:deleteProduct];
    [deleteFromCompany removeProductsObject:deleteProduct];
    [self.fetchResultsArray removeObject:deleteProduct];
    [self saveContext];
}

#pragma mark - Update Using Core Data
-(void)updateCompany:(Company*)company atIndex:(long)index {
    CoreCompany *updateCompany = (CoreCompany *)[self.fetchResultsArray objectAtIndex:index];
    updateCompany.companyName = company.companyName;
    updateCompany.companyLogo = company.companyLogo;
    updateCompany.companyStockCode = company.stockCode;
    updateCompany.companyPosition = company.companyPosition;
    [self saveContext];
}


-(void)updateProduct:(Product*) product atIndex:(long)index forCompanyIndex:(long)companyIndex {
    CoreCompany *company          = [self.fetchResultsArray objectAtIndex:companyIndex];
    CoreProduct *updateProduct    = (CoreProduct*)[[company.products allObjects]objectAtIndex:index];
    updateProduct.productName     = product.productName;
    updateProduct.productUrl      = product.productUrl;
    updateProduct.productLogo     = product.productLogo;
    updateProduct.productPosition = product.productPosition;
    [self saveContext];
}

#pragma mark - Move Using Core Data
-(void)moveCompany:(Company*)company fromIndex:(long)index toIndex:(long)newIndex {
    CoreCompany *moveCompany = [self.fetchResultsArray objectAtIndex:index];
    moveCompany.companyPosition = @(newIndex);
    [self.fetchResultsArray exchangeObjectAtIndex:index withObjectAtIndex:newIndex];
    [self saveContext];
}

-(void)moveProductfromIndex:(long)index toIndex:(long)newIndex forCompanyIndex:(long)companyIndex {
    CoreCompany *company          = [self.fetchResultsArray objectAtIndex:companyIndex];
    CoreProduct *updateProduct    = (CoreProduct*)[[company.products allObjects]objectAtIndex:index];
    updateProduct.productPosition = @(newIndex);
    [self saveContext];
}

#pragma mark - Helper Methods
-(void)createManagedObjectsUsingCompany:(Company *)company {
    CoreCompany *managedCompany = (CoreCompany*)[NSEntityDescription insertNewObjectForEntityForName:@"Company"
                                                                              inManagedObjectContext:self.managedObjectContext];
    managedCompany.companyName      = company.companyName;
    managedCompany.companyLogo      = company.companyLogo;
    managedCompany.companyStockCode = company.stockCode;
    managedCompany.companyPosition  = company.companyPosition;
    
    for (Product *product in company.companyProducts) {
         CoreProduct *managedProduct  = (CoreProduct*) [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:self.managedObjectContext];
        managedProduct.productName     = product.productName;
        managedProduct.productLogo     = product.productLogo;
        managedProduct.productUrl      = product.productUrl;
        managedProduct.productPosition = product.productPosition;
        [managedCompany addProductsObject:managedProduct];
    }

}

#pragma mark - Save ManagedObjectContext
- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
    NSLog(@"Data Saved");
}


#pragma mark - Hard Coded Values
- (void) loadHardCodedValuesIntoManagedContext {
    Company *apple          = [[Company alloc] init];
    apple.companyName       = @"Apple Mobile Devices";
    apple.companyLogo       = @"apple.jpg";
    apple.stockCode         = @"AAPL";
    apple.companyPosition   = @0;
    Product *iPad           = [[Product alloc] init];
    iPad.productName        = @"iPad";
    iPad.productLogo        = @"ipad.jpg";
    iPad.productUrl         = @"https://www.apple.com/ipad/";
    iPad.productPosition    = @0;
    Product *iPod           = [[Product alloc] init];
    iPod.productName        = @"iPod Touch";
    iPod.productLogo        = @"ipod.jpg";
    iPod.productUrl         = @"https://www.apple.com/ipod-touch/";
    iPod.productPosition    = @1;
    Product *iPhone         = [[Product alloc] init];
    iPhone.productName      = @"iPhone";
    iPhone.productLogo      = @"iphone.jpg";
    iPhone.productUrl       = @"https://www.apple.com/iphone/";
    iPhone.productPosition  = @2;
    apple.companyProducts   = [[NSMutableArray alloc] initWithObjects:iPad, iPod, iPhone, nil];
    
    Company *samsung        = [[Company alloc] init];
    samsung.companyName     = @"Samsung Mobile Devices";
    samsung.companyLogo     = @"samsung.jpg";
    samsung.stockCode       = @"SSUN.DE";
    samsung.companyPosition   = @1;
    Product *galaxy         = [[Product alloc] init];
    galaxy.productName      = @"Galaxy S5";
    galaxy.productLogo      = @"s5.jpg";
    galaxy.productUrl       = @"http://www.samsung.com/global/microsite/galaxys5/features.html";
    galaxy.productPosition  = @0;
    Product *note           = [[Product alloc] init];
    note.productName        = @"Galaxy Note";
    note.productLogo        = @"note.jpg";
    note.productUrl         = @"https://www.samsung.com/us/mobile/galaxy-note/";
    note.productPosition    = @1;
    Product *tab            = [[Product alloc] init];
    tab.productName         = @"Galaxy Tab";
    tab.productLogo         = @"tablet.jpg";
    tab.productUrl          = @"https://www.samsung.com/us/explore/tab-s2-features-and-specs/?cid=ppc-";
    tab.productPosition     = @2;
    samsung.companyProducts = [[NSMutableArray alloc] initWithObjects:galaxy, note, tab, nil];
    
    Company *htc            = [[Company alloc] init];
    htc.companyName         = @"HTC Mobile Devices";
    htc.companyLogo         = @"htc.png";
    htc.stockCode           = @"GOOG";
    htc.companyPosition     = @2;
    Product *htcOne         = [[Product alloc] init];
    htcOne.productName      = @"HTC One M9";
    htcOne.productLogo      = @"htcone.jpg";
    htcOne.productUrl       = @"https://www.htc.com/us/smartphones/htc-one-m9/";
    htcOne.productPosition  = @0;
    Product *nexus          = [[Product alloc] init];
    nexus.productName       = @"Google Nexus";
    nexus.productLogo       = @"nexus.jpg";
    nexus.productUrl        = @"https://store.google.com/product/nexus_6p?utm_source=en-ha-na-sem&utm_medium=text&utm_content=skws&utm_campaign=nexus6p&gclid=CjwKEAjws7OwBRCn2Ome5tPP8gESJAAfopWsF1f3gGR_3ME1Ixcmv8sq_vO9pzHjJwS6Sf_ztXnn_hoCiRDw_wcB";
    nexus.productPosition   = @1;
    Product *camera         = [[Product alloc] init];
    camera.productName      = @"RE Camera";
    camera.productLogo      = @"camera.jpg";
    camera.productUrl       = @"https://www.htc.com/us/re/re-camera/";
    camera.productPosition  = @2;
    htc.companyProducts     = [[NSMutableArray alloc] initWithObjects: htcOne, nexus, camera, nil];
    
    self.companyList        = [NSMutableArray arrayWithArray:@[apple, samsung, htc]];
}

@end
