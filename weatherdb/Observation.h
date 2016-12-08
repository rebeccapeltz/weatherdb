//
//  Observation.h
//  weatherdb
//
//  Created by Rebecca Peltz on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class Station;

@interface Observation : NSManagedObject

@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSNumber * temperature;
@property (nonatomic, retain) NSNumber * windspeed;
@property (nonatomic, retain) NSNumber * barometer;
@property (nonatomic, retain) Station *station;
+ (Observation *)observationFromWeatherUnderground:(NSManagedObjectContext *)moc;
+ (Observation *)observationFromWeatherUnderground:(NSManagedObjectContext *)moc forStationId:(NSString *)searchString;

@end

