//
//  ptObservationFetcher.h
//  weatherdb
//
//  Created by Becky on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ptObservationFetcher : NSObject<NSXMLParserDelegate>{
   
   // NSMutableString *currentString;
   // NSMutableDictionary *currentFields;
   // NSDateFormatter *dateFormatter;
    NSDictionary *outputDictionary;
    NSData *xmlData;
}
//Returns an array of observations if successful
//Returns nil on failure
@property (nonatomic, retain) NSData *xmlData;

@property (nonatomic, retain) NSMutableString *currentString;
@property (nonatomic,retain) NSMutableDictionary *currentFields;
@property (nonatomic, retain) NSDictionary *outputDictionary;

-(void) parseWUObservations:(NSData *)theData  ;
-(void) fetchObservationDataDictionary;
-(BOOL) loadXmlDataFromWeatherUnderground:(NSError **)outError;
-(BOOL) loadXmlDataFromWeatherUnderground: (NSError **)outError forSearchString:(NSString *)searchString;
-(void) fetchObservationDataDictionaryForStationId :(NSString*) stationId;
@end
