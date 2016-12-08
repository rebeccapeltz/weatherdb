//
//  ptStationFetcher.h
//  weatherdb
//
//  Created by Becky on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ptStationFetcher : NSObject<NSXMLParserDelegate>{
    NSArray *outputArray;
    NSData *xmlData;
}
@property (nonatomic,retain) NSData *xmlData;
@property (nonatomic,retain) NSMutableArray *currentArray;
@property (nonatomic,retain) NSArray *outputArray;
@property (nonatomic, retain)NSMutableString *currentString;

-(void) parseWUStations:(NSData *)theData;

-(void) fetchStationIdArray: (NSString *) lat forLongitude: (NSString *) lon;

-(BOOL) loadXmlDataFromWeatherUnderground: (NSError **)outError forLatitude: (NSString *) lat forLongitude: (NSString *) lon;

@end
