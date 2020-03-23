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

NS_ASSUME_NONNULL_BEGIN

@interface ContactTableViewController : UITableViewController <UISearchResultsUpdating, UISearchControllerDelegate, ContactTableViewPresenterProtocol>

- (void)getContacts;
- (void)attachSearchController:(UISearchController *)controller;

@end

NS_ASSUME_NONNULL_END

#endif /* ContactTableViewController_h */
