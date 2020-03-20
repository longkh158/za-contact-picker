//
//  ContactTableViewController.h
//  Contact Picker
//
//  Created by CPU12202 on 3/17/20.
//  Copyright © 2020 Long Kim. All rights reserved.
//

#ifndef ContactTableViewController_h
#define ContactTableViewController_h

#import <UIKit/UIKit.h>
#import "ContactTableViewPresenterProtocol.h"

@interface ContactTableViewController : UITableViewController <ContactTableViewPresenterProtocol>

- (void)getContacts;

@end

#endif /* ContactTableViewController_h */
