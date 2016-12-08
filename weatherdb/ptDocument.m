//
//  ptDocument.m
//  weatherdb
//
//  Created by Rebecca Peltz on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ptDocument.h"
#import "Station.h"
#import "Observation.h"
#import "ptStationFetcher.h"
#import "CoreLocation/CoreLocation.h"

@implementation ptDocument
@synthesize clLocationManager;

- (id)init
{
    self = [super init];
    if (self) {
        self.clLocationManager = [[[CLLocationManager alloc]init]autorelease];
        self.clLocationManager.purpose = @"automatically find weather stations nearby";
        [self.clLocationManager startUpdatingLocation];
        CLLocationCoordinate2D defaultLocation;
        if(!self.clLocationManager.location){
            defaultLocation.latitude = 47.8;
            defaultLocation.longitude = -122.4;
        } else{
            defaultLocation = [self clLocationManager].location.coordinate;
        }
        double lat = defaultLocation.latitude;
        double lon = defaultLocation.longitude;
        
        NSString *latStr = [NSString stringWithFormat:@"%f",lat]; //@"47.8";
        NSString *lonStr =  [NSString stringWithFormat:@"%f",lon];//@"-122.4";
        
        
        ptStationFetcher *fetcher = [[[ptStationFetcher alloc]init]autorelease];
        
        // NSString *latStr = @"47.8";
        // NSString *lonStr = @"-122.4";
        //use latitude and longitude to get an array of nearby station ids
        //from wunderground
        [fetcher fetchStationIdArray:latStr forLongitude:lonStr];
        NSArray *stationIdArray = [fetcher outputArray];
        NSLog(@"Array of station Id nearby: %@",stationIdArray);
        
        for(NSString *stationId in stationIdArray){
            [Observation observationFromWeatherUnderground:[self managedObjectContext] forStationId:stationId];                   
        }

        
    }
    return self;
}
//- (IBAction)stationACSelect:(id)sender{
//    NSLog(@"something with stationAC: %a",@"test" );
//}
-(void) addRandomObservationToStation:(Station *) station{
    Observation *observation = [NSEntityDescription 
                                insertNewObjectForEntityForName :@"Observation" 
                                inManagedObjectContext: self.managedObjectContext];
    observation.temperature = [NSNumber numberWithInt:(rand()%100)];
    observation.barometer = [NSNumber numberWithFloat:((rand()%100) * 0.1) ];
    observation.windspeed = [NSNumber numberWithInt:(rand()%100)];
    observation.station = station;
}

-(void) addAnObservationToStation:(Station *) station{
    Observation *observation = [NSEntityDescription 
                                 insertNewObjectForEntityForName :@"Observation" 
                                 inManagedObjectContext: self.managedObjectContext];
    observation.temperature = [NSNumber numberWithInt:32];
    observation.barometer = [NSNumber numberWithInt:1000];
    observation.windspeed = [NSNumber numberWithInt:10];
    observation.station = station;
}
- (IBAction)dataFromWunderground:(id)sender{
   // [Observation observationFromWeatherUnderground:[self managedObjectContext]];
    //[Observation observationFromWeatherUnderground:[self managedObjectContext] forStationId:@"KBFI"];
//    
    self.clLocationManager = [[[CLLocationManager alloc]init]autorelease];
    self.clLocationManager.purpose = @"automatically find weather stations nearby";
    [self.clLocationManager startUpdatingLocation];
    CLLocationCoordinate2D defaultLocation;
    if(!self.clLocationManager.location){
        defaultLocation.latitude = 47.8;
       defaultLocation.longitude = -122.4;
    } else{
       defaultLocation = [self clLocationManager].location.coordinate;
  }
    double lat = defaultLocation.latitude;
    double lon = defaultLocation.longitude;
    
    NSString *latStr = [NSString stringWithFormat:@"%f",lat]; //@"47.8";
    NSString *lonStr =  [NSString stringWithFormat:@"%f",lon];//@"-122.4";
    
    
    ptStationFetcher *fetcher = [[[ptStationFetcher alloc]init]autorelease];
   
   // NSString *latStr = @"47.8";
   // NSString *lonStr = @"-122.4";
    //use latitude and longitude to get an array of nearby station ids
    //from wunderground
    [fetcher fetchStationIdArray:latStr forLongitude:lonStr];
    NSArray *stationIdArray = [fetcher outputArray];
    NSLog(@"Array of station Id nearby: %@",stationIdArray);
    
    for(NSString *stationId in stationIdArray){
        [Observation observationFromWeatherUnderground:[self managedObjectContext] forStationId:stationId];                   
    }
}
-(IBAction)refreshStationsBtn:(id)sender{
    
    NSLog(@"refresh button pressed");
    //unable to set up link between station controller and code
 /*   
    NSArray * selectedObjects = [[ [self stationAC] arrangedObjects] objectsAtIndexes:[[self stationAC] selectedIndexes]];
    for (Station *station in selectedObjects){
        NSLog(@"station code: %@",station.code);
    }
    if (!selectedObjects)
        return;
  */      
    
    
}
- (IBAction)populate:(id)sender {
    for (int i=1;i<4;i++){
        Station *station = [NSEntityDescription 
                              insertNewObjectForEntityForName :@"Station" 
                              inManagedObjectContext: self.managedObjectContext];
        [station createFakeObservations];
        
    }
    /*
    Station *station01 = [NSEntityDescription 
                             insertNewObjectForEntityForName :@"Station" 
                             inManagedObjectContext: self.managedObjectContext];
    station01.name = @"Station KABC01";
    station01.code = @"KABC01";
    station01.latitude = [NSNumber numberWithFloat:47.57];
    station01.longitude = [NSNumber numberWithFloat:-122.01];
    for(int i=0;i<10;i++){
       [self addRandomObservationToStation: station01];
    }
    [self addAnObservationToStation: station01];
    
//    Observation *observation1 = [NSEntityDescription 
//                                 insertNewObjectForEntityForName :@"Observation" 
//                                 inManagedObjectContext: self.managedObjectContext];
//    observation1.temperature = [NSNumber numberWithInt:32];
//    observation1.barometer = [NSNumber numberWithInt:1000];
//    observation1.windspeed = [NSNumber numberWithInt:10];
//    observation1.station = station01;
    
    Station *station02 = [NSEntityDescription 
                          insertNewObjectForEntityForName :@"Station" 
                          inManagedObjectContext: self.managedObjectContext];
    station02.name = @"Station KABC02";
    station02.code = @"KABC02";
    station02.latitude = [NSNumber numberWithFloat:48.57];
    station02.longitude = [NSNumber numberWithFloat:-123.01];
    for(int i=0;i<10;i++){
        [self addRandomObservationToStation: station02];
    }
    Station *station03 = [NSEntityDescription 
                          insertNewObjectForEntityForName :@"Station" 
                          inManagedObjectContext: self.managedObjectContext];
    station03.name = @"Station KABC03";
    station03.code = @"KABC03";
    station03.latitude = [NSNumber numberWithFloat:49.57];
    station03.longitude = [NSNumber numberWithFloat:-124.01];
    for(int i=0;i<10;i++){
        [self addRandomObservationToStation: station03];
    }
    Station *station04 = [NSEntityDescription 
                          insertNewObjectForEntityForName :@"Station" 
                          inManagedObjectContext: self.managedObjectContext];
    station04.name = @"Station KABC04";
    station04.code = @"KABC04";
    station04.latitude = [NSNumber numberWithFloat:40.57];
    station04.longitude = [NSNumber numberWithFloat:-120.01];
    for(int i=0;i<10;i++){
        [self addRandomObservationToStation: station04];
    }
    Station *station05 = [NSEntityDescription 
                          insertNewObjectForEntityForName :@"Station" 
                          inManagedObjectContext: self.managedObjectContext];
    station05.name = @"Station KABC05";
    station05.code = @"KABC05";
    station05.latitude = [NSNumber numberWithFloat:41.57];
    station05.longitude = [NSNumber numberWithFloat:-121.01];
    for(int i=0;i<10;i++){
        [self addRandomObservationToStation: station05];
    }
    Station *station06 = [NSEntityDescription 
                          insertNewObjectForEntityForName :@"Station" 
                          inManagedObjectContext: self.managedObjectContext];
    station06.name = @"Station KABC06";
    station06.code = @"KABC06";
    station06.latitude = [NSNumber numberWithFloat:42.57];
    station06.longitude = [NSNumber numberWithFloat:-122.03];
    for(int i=0;i<10;i++){
        [self addRandomObservationToStation: station06];
    }
    Station *station07 = [NSEntityDescription 
                          insertNewObjectForEntityForName :@"Station" 
                          inManagedObjectContext: self.managedObjectContext];
    station07.name = @"Station KABC07";
    station07.code = @"KABC07";
    station07.latitude = [NSNumber numberWithFloat:43.57];
    station07.longitude = [NSNumber numberWithFloat:-125.01];
    for(int i=0;i<10;i++){
        [self addRandomObservationToStation: station07];
    }
    Station *station08 = [NSEntityDescription 
                          insertNewObjectForEntityForName :@"Station" 
                          inManagedObjectContext: self.managedObjectContext];
    station08.name = @"Station KABC08";
    station08.code = @"KABC08";
    station08.latitude = [NSNumber numberWithFloat:44.57];
    station08.longitude = [NSNumber numberWithFloat:-124.01];
    for(int i=0;i<10;i++){
        [self addRandomObservationToStation: station08];
    }
    Station *station09 = [NSEntityDescription 
                          insertNewObjectForEntityForName :@"Station" 
                          inManagedObjectContext: self.managedObjectContext];
    station09.name = @"Station KABC09";
    station09.code = @"KABC09";
    station09.latitude = [NSNumber numberWithFloat:45.57];
    station09.longitude = [NSNumber numberWithFloat:-125.01];
    for(int i=0;i<10;i++){
        [self addRandomObservationToStation: station09];
    }
    Station *station10 = [NSEntityDescription 
                          insertNewObjectForEntityForName :@"Station" 
                          inManagedObjectContext: self.managedObjectContext];
    station10.name = @"Station KABC10";
    station10.code = @"KABC10";
    station10.latitude = [NSNumber numberWithFloat:46.57];
    station10.longitude = [NSNumber numberWithFloat:-126.01];
    for(int i=0;i<10;i++){
        [self addRandomObservationToStation: station10];
    }
     */
 
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"ptDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

@end
