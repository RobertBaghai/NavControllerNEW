//
//  DataAccessObject.m
//  Nav Controller Re-Done
//
//  Created by Robert Baghai on 1/8/16.
//  Copyright © 2016 Robert Baghai. All rights reserved.
//

#import "DataAccessObject.h"
#import <UIKit/UIKit.h>
#import "Company.h"
#import "Product.h"
#import <sqlite3.h>

@interface DataAccessObject()

@property (nonatomic)         sqlite3  *companyListDataBase;
@property (nonatomic, strong) NSString *databasePath;

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

#pragma mark - Get data using SQL
- (void) createEditableCopyOfDatabaseIfNeeded {
    NSString *databaseName            = @"NavControllerDataBase.db";
    NSArray  *path                    = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath  = path[0];
    self.databasePath                 = [documentsDirectoryPath stringByAppendingPathComponent:databaseName];
    NSLog(@"DB Path %@", self.databasePath);
    [self checkIfFileExistsAtPath];
    
    sqlite3_stmt *company_statement;
    sqlite3_stmt *product_statement;
    const char   *dbPath = [self.databasePath UTF8String];
    
    if (sqlite3_open(dbPath, &_companyListDataBase) == SQLITE_OK) {
        NSLog(@"Database opened");
        NSString *selectCompanies = @"SELECT * FROM Company ORDER BY c_position";
        const char *query_companies = [selectCompanies UTF8String];
        if (sqlite3_prepare(self.companyListDataBase, query_companies, -1, &company_statement, NULL) == SQLITE_OK) {
            while ( sqlite3_step(company_statement) == SQLITE_ROW ) {
                NSString *company_id         = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(company_statement, 0)];
                NSString *company_name       = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(company_statement, 1)];
                NSString *company_logo       = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(company_statement, 2)];
                NSString *company_stock_code = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(company_statement, 3)];
                Company  *company            = [[Company alloc]  init];
                company.companyId            = company_id;
                company.companyName          = company_name;
                company.companyLogo          = company_logo;
                company.stockCode            = company_stock_code;
                company.companyProducts      = [[NSMutableArray alloc] init];
                
                NSString *selectProducts = [NSString stringWithFormat:@"SELECT * FROM Product WHERE company_id = %d ORDER BY p_position",[company_id intValue]];
                const char *query_products = [selectProducts UTF8String];
                if (sqlite3_prepare(self.companyListDataBase, query_products, -1, &product_statement, NULL) == SQLITE_OK) {
                    while ( sqlite3_step(product_statement) == SQLITE_ROW ) {
                        NSString *product_id   = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(product_statement, 0)];
                        NSString *product_name = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(product_statement, 1)];
                        NSString *product_logo = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(product_statement, 2)];
                        NSString *product_url  = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(product_statement, 3)];
                        Product  *product      = [[Product alloc]  init];
                        product.productId      = product_id;
                        product.productName    = product_name;
                        product.productLogo    = product_logo;
                        product.productUrl     = product_url;
                        [company.companyProducts addObject:product];
                    }
                }
                [self.companyList addObject:company];
            }
        }
        // Release the compiled statements from memory.
        sqlite3_finalize(company_statement);
        sqlite3_finalize(product_statement);
    }
    sqlite3_close(self.companyListDataBase);
}

#pragma mark - Check for Database
- (void) checkIfFileExistsAtPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:self.databasePath]) {
        NSString *appDatabaseBundlePath = [[NSBundle mainBundle] pathForResource:@"NavControllerDataBase" ofType:@"db"];
        NSError *error = nil;
        [[NSFileManager defaultManager] copyItemAtPath:appDatabaseBundlePath toPath:self.databasePath error:&error];
        if ( error ) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops!" message:[NSString stringWithFormat:@"%@",error.userInfo] preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *alert = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
                //Just Dismiss Alert
            }];
            [alertController addAction:alert];
        }
    }
}

#pragma mark - Delete using SQL
- (void) deleteCompanyWithQuery: (Company*)company {
    char *error;
    char *errorTwo;
    NSString *deleteCompanyQuery          = [NSString stringWithFormat:@"DELETE FROM Company WHERE c_name IS '%@'", company.companyName];
    NSString *deleteProdFromDeleteCompany = [NSString stringWithFormat:@"DELETE FROM Product WHERE company_id IS '%d'",[company.companyId intValue]];
    
    if (sqlite3_exec(self.companyListDataBase, [deleteCompanyQuery UTF8String], NULL, NULL, &error) == SQLITE_OK) {
        NSLog(@"Company '%@' has been deleted.",company.companyName);
    }
    if (sqlite3_exec(self.companyListDataBase, [deleteProdFromDeleteCompany UTF8String], NULL, NULL, &errorTwo) == SQLITE_OK) {
        NSLog(@"Products for company '%@' have been deleted.",company.companyName);
    }
    sqlite3_close(self.companyListDataBase);
}

- (void) deleteProductWithQuery:(Product*)product {
    NSString *deleteProductQuery   = [NSString stringWithFormat:@"DELETE FROM Product WHERE p_name IS '%@'",product.productName];
    char *error;
    if (sqlite3_exec(self.companyListDataBase, [deleteProductQuery UTF8String], NULL, NULL, &error) == SQLITE_OK) {
        NSLog(@"Product '%@' has been deleted.",product.productName);
    }
    sqlite3_close(self.companyListDataBase);
}

#pragma mark - Add using SQL
- (void) addCompanyWithQuery: (Company*)company {
    int companyPosition = [self fetchMaxCompanyPosition];
    char *error;
    NSString *addQuery = [NSString stringWithFormat:@"INSERT INTO Company (c_name,c_logo,c_stockCode,c_position) VALUES ('%@','%@','%@','%d')",company.companyName, company.companyLogo, company.stockCode, companyPosition];
    if (sqlite3_exec(self.companyListDataBase, [addQuery UTF8String], NULL, NULL, &error) == SQLITE_OK) {
        NSLog(@"Company '%@' has been added.",company.companyName);
    }
    sqlite3_close(self.companyListDataBase);
}

- (void) addProductWithQuery:(Product*)product forCompanyId:(Company*)company {
    int productPosition = [self fetchMaxProductPosition];
    char *error;
    NSString *addQuery = [NSString stringWithFormat:@"INSERT INTO Product (p_name, p_logo, p_url, company_id, p_position) VALUES ('%@','%@','%@','%d','%d')", product.productName, product.productLogo, product.productUrl, [company.companyId intValue], productPosition];
    if (sqlite3_exec(self.companyListDataBase, [addQuery UTF8String], NULL, NULL, &error) == SQLITE_OK) {
        NSLog(@"Product '%@' has been added.",product.productName);
    }
    sqlite3_close(self.companyListDataBase);
}

#pragma mark - Update using SQL
- (void) updateCompanyDataWithQuery:(Company*)company {
    char *error;
    NSString *editQuery = [NSString stringWithFormat:@"UPDATE Company SET c_name = '%@', c_logo = '%@', c_stockCode = '%@' WHERE id = '%d'", company.companyName, company.companyLogo, company.stockCode, [company.companyId intValue]];
    if (sqlite3_exec(self.companyListDataBase, [editQuery UTF8String], NULL, NULL, &error) == SQLITE_OK) {
        NSLog(@"Company '%@' has been updated.",company.companyName);
    }
    sqlite3_close(self.companyListDataBase);
}

- (void) updateProductDataWithQuery:(Product*)product {
    char *error;
    NSString *editQuery = [NSString stringWithFormat:@"UPDATE Product SET p_name = '%@', p_logo = '%@', p_url = '%@' WHERE id = '%d'",product.productName, product.productLogo, product.productUrl, [product.productId intValue]];
    if (sqlite3_exec(self.companyListDataBase, [editQuery UTF8String], NULL, NULL, &error) == SQLITE_OK) {
        NSLog(@"Product '%@' has been updated.",product.productName);
    }
    sqlite3_close(self.companyListDataBase);
}

#pragma mark - Move using SQL
- (void) moveCompanyWithQuery: (Company*)company {
    char *error;
    for (int i = 0 ; i < self.companyList.count; i++) {
        company = [self.companyList objectAtIndex:i];
        NSString *moveQuery = [NSString stringWithFormat:@"UPDATE Company SET c_position = '%d' WHERE id = '%d'",i + 1, [company.companyId intValue]];
        if (sqlite3_exec(self.companyListDataBase, [moveQuery UTF8String], NULL, NULL, &error) == SQLITE_OK) {
            NSLog(@"Company '%@' move to index %d.",company.companyName, i);
        }
    }
    sqlite3_close(self.companyListDataBase);
}

- (void) moveProductWithQuery: (Product*)product usingArray: (NSMutableArray*)companyProducts {
    char *error;
    for (int i = 0; i < companyProducts.count; i++) {
        product = [companyProducts objectAtIndex:i];
        NSString *moveQuery = [NSString stringWithFormat:@"UPDATE Product SET p_position = '%d' WHERE id = '%d'", i + 1, [product.productId intValue]];
        if (sqlite3_exec(self.companyListDataBase, [moveQuery UTF8String], NULL, NULL, &error) == SQLITE_OK) {
            NSLog(@"Product '%@' move to index %d.", product.productName, i);
        }
    }
    sqlite3_close(self.companyListDataBase);
}

#pragma mark - Find Max Positon Using SQL
- (int) fetchMaxCompanyPosition {
    NSString *maxPositionString = nil;
    int newMaxPosition          = 0;
    sqlite3_stmt *statement;
    NSString *query = [NSString stringWithFormat:@"SELECT MAX(c_position) FROM Company"];
    if (sqlite3_prepare(self.companyListDataBase, [query UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        while (sqlite3_step( statement ) == SQLITE_ROW) {
            const unsigned char *currentMaxPosition = sqlite3_column_text(statement, 0);
            NSLog(@"Company max position %s",currentMaxPosition);
            if ( currentMaxPosition == NULL ) {
                newMaxPosition = 1;
            } else {
                maxPositionString =  [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                newMaxPosition    = [maxPositionString intValue]+1;
            }
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(self.companyListDataBase);
    return newMaxPosition;
}

- (int) fetchMaxProductPosition {
    NSString *maxPositionString = nil;
    int newMaxPosition          = 0;
    sqlite3_stmt *statement;
    NSString *query = [NSString stringWithFormat:@"SELECT MAX(p_position) FROM Product"];
    if (sqlite3_prepare(self.companyListDataBase, [query UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        while (sqlite3_step( statement ) == SQLITE_ROW) {
            const unsigned char *currentMaxPosition = sqlite3_column_text(statement, 0);
            NSLog(@"Product max position = %s",currentMaxPosition);
            if ( currentMaxPosition == NULL ) {
                newMaxPosition    = 1;
            } else {
                maxPositionString = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                newMaxPosition    = [maxPositionString intValue] + 1;
            }
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(self.companyListDataBase);
    return newMaxPosition;
}


@end
