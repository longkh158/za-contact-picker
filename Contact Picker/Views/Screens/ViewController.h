//
//  ViewController.h
//  Contact Picker
//
//  Created by CPU12202 on 3/17/20.
//  Copyright © 2020 Long Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactTableCellViewModel.h"

@interface ViewController : UIViewController

@property (readonly) NSMutableArray<ContactTableCellViewModel *> *selectedContacts;

- (void)addContactViewModel:(ContactTableCellViewModel *)vm;
- (void)removeContactViewModel:(ContactTableCellViewModel *)vm;
- (void)removeAllContacts;

@end

