//
//  ContactSearchController.h
//  Contact Picker
//
//  Created by CPU12202 on 3/19/20.
//  Copyright © 2020 Long Kim. All rights reserved.
//

#ifndef ContactSearchController_h
#define ContactSearchController_h

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContactSearchController : UISearchController

- (instancetype)init;
- (instancetype)initWithSearchResultsController:(UIViewController * _Nullable)controller;

@end

NS_ASSUME_NONNULL_END

#endif /* ContactSearchController_h */
