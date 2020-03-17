//
//  ContactTableCellViewModel.h
//  Contact Picker
//
//  Created by CPU12202 on 3/17/20.
//  Copyright © 2020 Long Kim. All rights reserved.
//

#ifndef ContactTableCellViewModel_h
#define ContactTableCellViewModel_h

#import "ZAViewModel.h"

@interface ContactTableCellViewModel : NSObject <ZAViewModel>

@property (readonly) NSString *identifier;
@property (readonly) NSString *fullName;

@end

#endif /* ContactTableCellViewModel_h */
