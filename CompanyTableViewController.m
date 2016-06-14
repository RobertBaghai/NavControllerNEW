//
//  CompanyTableViewController.m
//  Nav Controller Re-Done
//
//  Created by Robert Baghai on 1/8/16.
//  Copyright © 2016 Robert Baghai. All rights reserved.
//

#import "CompanyTableViewController.h"
#import "ProductTableViewController.h"
#import "DataAccessObject.h"
#import "Company.h"
#import "AddCompanyViewController.h"
#import "UpdateCompanyViewController.h"

@interface CompanyTableViewController ()

@property (nonatomic, strong) DataAccessObject *dao;
@property (nonatomic, strong) Company          *company;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSIndexPath      *indexPath;

@end

@implementation CompanyTableViewController
@dynamic refreshControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Mobile Devices";
    [self createRightBarButtonItems];
    self.dao = [DataAccessObject sharedInstance];
    [self.dao readFromCoreDataIfExistsElseCreateFileAndRead];
    [self addRefeshControlForTableView];
    [self addLongPressToTableView];
    self.tableView.backgroundColor = [UIColor grayColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadStockPrices];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Create Navigation Items
- (void)createRightBarButtonItems {
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain
                                                                 target:self action:@selector(add:)];
    NSArray *arrayOfButtons = [NSArray arrayWithObjects:addButton,self.editButtonItem, nil];
    self.navigationItem.rightBarButtonItems = arrayOfButtons;
}

- (void)add:(id)sender {
    [self performSegueWithIdentifier:@"addCompanies" sender:nil];
}

#pragma mark - Add Scroll To Refresh
- (void)addRefeshControlForTableView {
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector( refreshTable ) forControlEvents:UIControlEventValueChanged];
}

- (void)refreshTable {
    [self.refreshControl endRefreshing];
    [self loadStockPrices];
}

#pragma mark Set up NSURLSession
- (void) loadStockPrices {
    NSURLSession   *session = [NSURLSession sharedSession];
    NSMutableArray *array   = [[NSMutableArray alloc] init];
    for (Company *comp in self.dao.companyList) {
        [array addObject:comp.stockCode];
    }
    
    NSString *stringUrl = [NSString stringWithFormat:@"http://finance.yahoo.com/d/quotes.csv?s=%@&f=a",[array componentsJoinedByString:@"+"]];
    [[session dataTaskWithURL:[NSURL URLWithString:stringUrl]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                if ( error ) {
                    NSLog(@"Error --- %@",error.localizedDescription);
                } else {
                    NSString *stockString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                    NSUInteger index = 0;
                    
                    for (NSString *stockPrice in [stockString componentsSeparatedByString:@"\n"]) {
                        if (index == self.dao.companyList.count) break;
                        [[self.dao.companyList objectAtIndex:index]setStockPrice:stockPrice];
                        index++;
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                }
            }]resume];
}

#pragma mark - Create Long Press Gesture
- (void)addLongPressToTableView {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(addCompanyLongPressAction:)];
    longPress.minimumPressDuration = 1.0;
    longPress.cancelsTouchesInView = YES;
    [self.tableView addGestureRecognizer:longPress];
}

- (IBAction)addCompanyLongPressAction:(UILongPressGestureRecognizer *)sender {
    if ( sender.state == UIGestureRecognizerStateRecognized ) {
        CGPoint touchPoint = [sender locationInView:self.view];
        self.indexPath = [self.tableView indexPathForRowAtPoint:touchPoint];
        NSLog(@"Cell Index = %ld",(long)self.indexPath.row);
        [self performSegueWithIdentifier:@"updateCompany" sender:self.dao.companyList];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dao.companyList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    Company *company               = [self.dao.companyList objectAtIndex:indexPath.row];
    cell.textLabel.text            = company.companyName;
    cell.textLabel.textColor       = [UIColor blueColor];
    cell.imageView.image           = [UIImage imageNamed:company.companyLogo];
    
    NSString *stockPrice = nil;
    if (company.stockPrice == nil)
        stockPrice = @"No Stock Info Available";
    else
        stockPrice = [@"Current Stock Price: " stringByAppendingString:company.stockPrice];
    
    cell.detailTextLabel.text      = stockPrice;
    cell.detailTextLabel.textColor = [UIColor redColor];
    
    return cell;
}

#pragma mark - Table view Delegates
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ( editingStyle == UITableViewCellEditingStyleDelete ) {
        [self.dao deleteCompanyfromContext:indexPath.row];
        [self.dao.companyList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    Company *company = [self.dao.companyList objectAtIndex: fromIndexPath.row];
    [self.dao.companyList removeObjectAtIndex: fromIndexPath.row];
    [self.dao.companyList insertObject:company atIndex: toIndexPath.row];
    [self.dao moveCompany:company fromIndex:fromIndexPath.row toIndex:toIndexPath.row];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.company = [self.dao.companyList objectAtIndex:indexPath.row];
    NSLog(@"Company name = %@ , company position = %@", self.company.companyName, self.company.companyPosition);
    [self performSegueWithIdentifier:@"showProducts" sender:self.company];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ( [segue.identifier isEqualToString:@"showProducts"] ) {
        ProductTableViewController *productTableView = (ProductTableViewController*)segue.destinationViewController;
        productTableView.company                     = sender;
        productTableView.companyProducts             = self.company.companyProducts;
        productTableView.title                       = self.company.companyName;
        productTableView.companyIndex                = [self.tableView indexPathForSelectedRow];
        
    } else if ( [segue.identifier isEqualToString:@"updateCompany"] ) {
        UpdateCompanyViewController *updateCompany = (UpdateCompanyViewController*)segue.destinationViewController;
        updateCompany.updatedCompanyArray          = sender;
        updateCompany.indexPath = self.indexPath;
    }
}

@end
