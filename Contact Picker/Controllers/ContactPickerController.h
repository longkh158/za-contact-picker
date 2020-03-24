//
//  ContactPickerController.h
//  Contact Picker
//
//  Created by CPU12202 on 3/23/20.
//  Copyright © 2020 Long Kim. All rights reserved.
//

#ifndef ContactPickerController_h
#define ContactPickerController_h

#import <UIKit/UIKit.h>

@interface ContactPickerController : UICollectionViewController

@property ViewController *parent;

- (void)attachViewModel:(NSMutableArray *)vm;
- (void)refreshUI;

@end

#endif /* ContactPickerController_h */
