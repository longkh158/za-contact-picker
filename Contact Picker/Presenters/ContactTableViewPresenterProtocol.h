//
//  ContactTableViewPresenterProtocol.h
//  Contact Picker
//
//  Created by CPU12202 on 3/17/20.
//  Copyright © 2020 Long Kim. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ContactTableViewPresenterProtocol <NSObject>

- (void)didFetchData:(id _Nullable)data withError:(NSError *_Nullable)error;

@optional
- (void)didFetchEmpty;
- (void)willFetchData;
- (void)didFetchImage:(NSData *)imageData forCellVM:(id)vm;

@end

NS_ASSUME_NONNULL_END
