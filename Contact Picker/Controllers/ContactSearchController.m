//
//  ContactSearchController.m
//  Contact Picker
//
//  Created by CPU12202 on 3/19/20.
//  Copyright © 2020 Long Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ContactSearchController.h"
#import "ContactSearchResultController.h"

@interface ContactSearchController ()

@property ContactSearchResultController *result;

@end

@implementation ContactSearchController

- (instancetype)init
{
    return [self initWithSearchResultsController:nil];
}

- (instancetype)initWithSearchResultsController:(UIViewController <UISearchResultsUpdating> * _Nullable)controller
{
    self = [super initWithSearchResultsController:controller];
    if (self)
    {
        self.obscuresBackgroundDuringPresentation = NO;
        self.searchResultsUpdater = controller;
        self.searchBar.placeholder = @"Search Contacts";
    }
    return self;
}

@end
