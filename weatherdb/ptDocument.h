//
//  ptDocument.h
//  weatherdb
//
//  Created by Rebecca Peltz on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Station.h"
#import "Observation.h"
#import "CoreLocation/CoreLocation.h"

@interface ptDocument : NSPersistentDocument
- (IBAction)populate:(id)sender;
- (IBAction)refreshStationsBtn:(id)sender;
- (IBAction)dataFromWunderground: (id)sender;
//- (IBAction)stationACSelect:(id)sender;
- (void) addAnObservationToStation:(Station *) station;
- (void) addRandomObservationToStation:(Station *) station;
@property (nonatomic,retain) CLLocationManager *clLocationManager;
@end
