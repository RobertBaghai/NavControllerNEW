//
//  ProductTableViewController.m
//  Nav Controller Re-Done
//
//  Created by Robert Baghai on 1/8/16.
//  Copyright © 2016 Robert Baghai. All rights reserved.
//

#import "ProductTableViewController.h"
#import "Product.h"
#import "UrlViewController.h"
#import "AddProductsViewController.h"
#import "UpdateProductViewController.h"
#import "DataAccessObject.h"

@interface ProductTableViewController ()

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) DataAccessObject *dao;

@end

@implementation ProductTableViewController

@synthesize refreshControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createRightBarButtonItems];
    [self addRefeshControlForTableView];
    [self addLongPressToTableView];
    self.dao = [DataAccessObject sharedInstance];
    self.tableView.backgroundColor = [UIColor grayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    [self.dao archiveData];
}

#pragma mark - Create Navigation Items
- (void)createRightBarButtonItems {
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(add:)];
    NSArray *arrayOfButtons = [NSArray arrayWithObjects:addButton, self.editButtonItem, nil];
    self.navigationItem.rightBarButtonItems = arrayOfButtons;
}

- (void)add:(id)sender {
    [self performSegueWithIdentifier:@"addProducts" sender:self.companyProducts];
}

#pragma mark - Add Scroll To Refresh
- (void)addRefeshControlForTableView {
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
}

- (void)refreshTable {
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

#pragma mark - Create Long Press Gesture
- (void)addLongPressToTableView {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(addProductLongPressAction:)];
    longPress.minimumPressDuration = 1.0;
    longPress.cancelsTouchesInView = YES;
    [self.tableView addGestureRecognizer:longPress];
}

- (IBAction)addProductLongPressAction:(UILongPressGestureRecognizer *)sender {
    if ( sender.state == UIGestureRecognizerStateRecognized ){
        UITableView *tableView = (UITableView*)self.view;
        CGPoint touchPoint = [sender locationInView:self.view];
        self.indexPath = [tableView indexPathForRowAtPoint:touchPoint];
        NSLog(@"Cell Index = %ld",(long)self.indexPath.row);
        [self performSegueWithIdentifier:@"updateProduct" sender:self.companyProducts];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.companyProducts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    Product *product = [self.companyProducts objectAtIndex:indexPath.row];
    cell.textLabel.text = product.productName;
    cell.textLabel.textColor = [UIColor blueColor];
    cell.imageView.image = [UIImage imageNamed:product.productLogo];
    cell.detailTextLabel.text = product.productUrl;
    cell.detailTextLabel.textColor = [UIColor redColor];

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.companyProducts removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.dao archiveData];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    Product *product = [self.companyProducts objectAtIndex:fromIndexPath.row];
    [self.companyProducts removeObjectAtIndex:fromIndexPath.row];
    [self.companyProducts insertObject:product atIndex:toIndexPath.row];
    [self.dao archiveData];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Product *product = [self.companyProducts objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showProductUrl" sender: product.productUrl];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showProductUrl"]) {
        UrlViewController *urlView = (UrlViewController*)segue.destinationViewController;
        [urlView setURL:sender];
    } else if ([segue.identifier isEqualToString:@"addProducts"]){
        AddProductsViewController *addProduct = (AddProductsViewController*)segue.destinationViewController;
        addProduct.addedProductArray = sender;
    } else if ( [segue.identifier isEqualToString:@"updateProduct"] ) {
        UpdateProductViewController *updateProduct = (UpdateProductViewController*)segue.destinationViewController;
        updateProduct.updateProductArray = sender;
        if ( self.indexPath != nil ) {
            updateProduct.indexPath = self.indexPath;
        }
    }
}

@end
