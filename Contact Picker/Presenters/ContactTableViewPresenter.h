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
#import "ContactService.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContactTableViewPresenter : NSObject

@property (readonly, nonatomic, weak) id <ContactTableViewPresenterProtocol> delegate;

- (instancetype)init;
- (void)attachView:(id <ContactTableViewPresenterProtocol>)view;
- (void)getAllContacts;
- (void)fetchImageForContactWithIdentifier:(NSString *)identifier
                                  callback:(void (^)(NSData * _Nullable imageData, NSError * _Nullable error))error;
- (void)filteredContactsByText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END

#endif /* ContactTableViewPresenter_h */
