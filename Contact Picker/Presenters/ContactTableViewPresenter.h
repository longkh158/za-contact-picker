//
//  ContactTableViewPresenter.h
//  Contact Picker
//
//  Created by CPU12202 on 3/17/20.
//  Copyright © 2020 Long Kim. All rights reserved.
//

#ifndef ContactTableViewPresenter_h
#define ContactTableViewPresenter_h

#import "ContactTableViewPresenterProtocol.h"

@interface ContactTableViewPresenter : NSObject

@property (readonly) id <ContactTableViewPresenterProtocol> delegate;

- (void)attachView:(id <ContactTableViewPresenterProtocol>)view;
- (void)getAllContacts;

@end

#endif /* ContactTableViewPresenter_h */
