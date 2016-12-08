//
//  Station.m
//  weatherdb
//
//  Created by Rebecca Peltz on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Station.h"
#import "Observation.h"

static NSUInteger stationCount = 0;

@implementation Station

@dynamic name;
@dynamic code;
@dynamic latitude;
@dynamic longitude;
@dynamic observation;

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    self.code = [NSString stringWithFormat:@"KABC%02d",++stationCount];//@"Station KABCxx";
    self.name = [NSString stringWithFormat:@"Station KABC%02d",stationCount];//@"KABCxx";
    self.latitude = [NSNumber numberWithDouble:47.5 +  (rand()%100)*.01];
    self.longitude = [NSNumber numberWithDouble:-122.5+(rand()%100) *.01];
}
-(void)createFakeObservations
{
    for (int i=0;i<10;i++){
        Observation *newObservation = [NSEntityDescription insertNewObjectForEntityForName:@"Observation"  inManagedObjectContext:self.managedObjectContext];
        newObservation.station = self;
    }
}

@end
