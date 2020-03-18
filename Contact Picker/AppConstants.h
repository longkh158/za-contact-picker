//
//  AppConstants.h
//  Contact Picker
//
//  Created by CPU12202 on 3/17/20.
//  Copyright © 2020 Long Kim. All rights reserved.
//

#ifndef AppConstants_h
#define AppConstants_h

#include <Foundation/Foundation.h>
#include <CoreGraphics/CoreGraphics.h>

/// Default height of table cell in an \c UITableView.
static const CGFloat TABLE_CELL_HEIGHT = 64.0;

static NSString * const TABLE_CELL_REUSE_ID = @"contact_picker_table_cell";

static const NSUInteger CONTACTS_SELECTION_LIMIT = 5;

static const long MAXIMUM_CALLBACKS_ALLOWED = 10;

static NSUInteger CACHE_LIMIT = 10;

#endif /* AppConstants_h */
