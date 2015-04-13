//
//  APIData.h
//  Assessment4
//
//  Created by Sherrie Jones. on 4/12/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIData : NSObject

@property NSManagedObjectContext *moc;

- (instancetype)initWithObjectContext:(NSManagedObjectContext *)context;
- (NSArray *)getDogArrayFromAPIData;

@end
