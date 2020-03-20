//
//  Contact_PickerTests.m
//  Contact PickerTests
//
//  Created by CPU12202 on 3/17/20.
//  Copyright © 2020 Long Kim. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ContactDataAdapter.h"

@interface Contact_PickerTests : XCTestCase

@end

@implementation Contact_PickerTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testDataAdapterFetchPerformance
{
    [self measureBlock:^
    {
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^
        {
            dispatch_apply(1000, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(size_t idx)
            {
                [[ContactDataAdapter sharedInstance] fetchContactsWithKeys:nil
                                                                usingQueue:nil
                                                                  callback:^(NSDictionary<NSString *,NSArray *> * _Nullable data, NSError * _Nullable err)
                {
                    static dispatch_once_t onceToken;
                    dispatch_once(&onceToken, ^{
                        NSLog(@"%@", data);
                    });
                }];
            });
        });
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    }];
}

@end
	
