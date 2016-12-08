//
//  Observation.m
//  weatherdb
//
//  Created by Rebecca Peltz on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Observation.h"
#import "ptObservationFetcher.h"
#import "Station.h"


@implementation Observation

@dynamic time;
@dynamic temperature;
@dynamic windspeed;
@dynamic barometer;
@dynamic station;



- (void)awakeFromInsert
{
    [super awakeFromInsert];
    self.time = [NSDate dateWithTimeIntervalSinceNow:-1 * rand()%7200];
    self.temperature = [NSNumber numberWithDouble:(10. + rand()%200)*0.1];
    self.barometer = [NSNumber numberWithDouble:(990 + (rand()%200)*0.1)];
    self.windspeed = [NSNumber numberWithDouble:(rand()%200*0.1)];
}

+ (Observation *) observationFromWeatherUnderground:(NSManagedObjectContext *)moc forStationId:(NSString *)searchString{
    ptObservationFetcher *fetcher = [[[ptObservationFetcher alloc]init] autorelease];
    NSDictionary *outputDictionary = nil;
    // [fetcher fetchObservationDataDictionary];
    [fetcher fetchObservationDataDictionaryForStationId:searchString];
    outputDictionary = [fetcher outputDictionary];
    //observation info
    NSNumber *temp = [NSNumber numberWithInt:[[outputDictionary objectForKey:@"temp_f"] intValue]];
    NSNumber *pressure = [NSNumber numberWithInt:[[outputDictionary objectForKey:@"pressure_mb"] intValue]];
    NSNumber *wind = [NSNumber numberWithInt:[[outputDictionary objectForKey:@"wind_mph"] intValue]];
    NSDate *timestamp = [NSDate dateWithTimeIntervalSince1970:[[outputDictionary objectForKey:@"observation_epoch"] intValue]];
    NSLog(@"observation info: %@, %@, %@, %@",temp,pressure,wind,timestamp);
    //station info
    NSString *code = [outputDictionary objectForKey:@"station_id"] ;
    NSString *name = [outputDictionary objectForKey:@"full"];
    NSNumber *latitude = [NSNumber numberWithDouble:[[outputDictionary objectForKey:@"latitude"] doubleValue]];
    NSNumber *longitude = [NSNumber numberWithDouble:[[outputDictionary objectForKey:@"longitude"] doubleValue]];
    NSLog(@"station info: %@, %@, %@, %@",code,name, latitude,longitude);
    
    
    Observation *newObs = 
    [NSEntityDescription insertNewObjectForEntityForName:@"Observation"
                                  inManagedObjectContext:moc];
    [newObs setTemperature:temp];
    [newObs setBarometer:pressure];
    [newObs setWindspeed:wind];
    [newObs setTime:timestamp];
    
    //check to see if the station exists in the mock
    Station *theStation;
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Station" inManagedObjectContext:moc];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDescription];
    
    //NSString *searchForCode = @"KBFI";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(code LIKE[c] %@)", searchString];
    [request setPredicate:predicate];
    NSError *error = nil;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    if ([array count] == 0){
        NSLog(@"Station does NOT exist so create it");
        theStation =  [NSEntityDescription insertNewObjectForEntityForName:@"Station"
                                                    inManagedObjectContext:moc];
        
        
    }else {
        NSLog(@"Station does exist");
        theStation = [array lastObject]; //it's unique
    }
    [theStation setCode:code];
    [theStation setName:name];
    [theStation setLatitude:latitude];
    [theStation setLongitude:longitude];
    [newObs setStation:theStation];
    return newObs;
    
}

+ (Observation *)observationFromWeatherUnderground:
(NSManagedObjectContext *)moc{
    
    ptObservationFetcher *fetcher = [[[ptObservationFetcher alloc]init] autorelease];
    NSDictionary *outputDictionary = nil;
    [fetcher fetchObservationDataDictionary];
    outputDictionary = [fetcher outputDictionary];
    //observation info
    NSNumber *temp = [NSNumber numberWithInt:[[outputDictionary objectForKey:@"temp_f"] intValue]];
    NSNumber *pressure = [NSNumber numberWithInt:[[outputDictionary objectForKey:@"pressure_mb"] intValue]];
    NSNumber *wind = [NSNumber numberWithInt:[[outputDictionary objectForKey:@"wind_mph"] intValue]];
    NSDate *timestamp = [NSDate dateWithTimeIntervalSince1970:[[outputDictionary objectForKey:@"observation_epoch"] intValue]];
    NSLog(@"observation info: %@, %@, %@, %@",temp,pressure,wind,timestamp);
    //station info
    NSString *code = [outputDictionary objectForKey:@"station_id"] ;
    NSString *name = [outputDictionary objectForKey:@"full"];
    NSNumber *latitude = [NSNumber numberWithDouble:[[outputDictionary objectForKey:@"latitude"] doubleValue]];
    NSNumber *longitude = [NSNumber numberWithDouble:[[outputDictionary objectForKey:@"longitude"] doubleValue]];
    NSLog(@"station info: %@, %@, %@, %@",code,name, latitude,longitude);
    
    
    Observation *newObs = 
    [NSEntityDescription insertNewObjectForEntityForName:@"Observation"
                                  inManagedObjectContext:moc];
    [newObs setTemperature:temp];
    [newObs setBarometer:pressure];
    [newObs setWindspeed:wind];
    [newObs setTime:timestamp];
    
    //check to see if the station exists in the mock
    Station *theStation;
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Station" inManagedObjectContext:moc];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDescription];
    
    NSString *searchForCode = @"KBFI";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(code LIKE[c] %@)", searchForCode];
    [request setPredicate:predicate];
    NSError *error = nil;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    if ([array count] == 0){
        NSLog(@"Station does NOT exist so create it");
        theStation =  [NSEntityDescription insertNewObjectForEntityForName:@"Station"
                                                    inManagedObjectContext:moc];
        
        
    }else {
        NSLog(@"Station does exist");
        theStation = [array lastObject]; //it's unique
    }
    [theStation setCode:code];
    [theStation setName:name];
    [theStation setLatitude:latitude];
    [theStation setLongitude:longitude];
    [newObs setStation:theStation];
    return newObs;
}


@end
