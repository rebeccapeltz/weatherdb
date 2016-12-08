//
//  Station.h
//  weatherdb
//
//  Created by Rebecca Peltz on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Observation;

@interface Station : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSSet *observation;
@end

@interface Station (CoreDataGeneratedAccessors)

- (void)addObservationObject:(Observation *)value;
- (void)removeObservationObject:(Observation *)value;
- (void)addObservation:(NSSet *)values;
- (void)removeObservation:(NSSet *)values;

-(void)createFakeObservations;

@end
