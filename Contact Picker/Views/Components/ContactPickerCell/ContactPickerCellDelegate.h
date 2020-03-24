//
//  ContactPickerCellDelegate.h
//  Contact Picker
//
//  Created by CPU12202 on 3/24/20.
//  Copyright © 2020 Long Kim. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ContactPickerCellDelegate <NSObject>

- (void)handleRemoveSelectedContactWithIdentifier:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
