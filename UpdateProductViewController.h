//
//  UpdateProductViewController.h
//  Nav Controller Re-Done
//
//  Created by Robert Baghai on 1/10/16.
//  Copyright © 2016 Robert Baghai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateProductViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) NSMutableArray *array; 
@property (weak, nonatomic) IBOutlet UIImageView *imageToBeEdited;

@end
