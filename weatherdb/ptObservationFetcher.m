//
//  ptObservationFetcher.m
//  weatherdb
//
//  Created by Becky on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ptObservationFetcher.h"



@implementation ptObservationFetcher

@synthesize currentFields;
@synthesize currentString;
@synthesize outputDictionary;
@synthesize xmlData;

-(id) init{
    self = [super init];
    if (self){
        
        //dateFormatter = [[NSDateFormatter alloc]init];
        //[dateFormatter setDateFormat:(@"")];
        
    }
    return self;
}
-(void)dealloc
{
    [super dealloc];
    
}

#pragma mark -
#pragma mark Web service call Method

-(void) fetchObservationDataDictionaryForStationId:(NSString *)stationId{
    NSError *error = nil;
    [self loadXmlDataFromWeatherUnderground:&error forSearchString:stationId];
    [self parseWUObservations:[self xmlData]];
}

-(void) fetchObservationDataDictionary{
    NSError *error = nil;  
    [self loadXmlDataFromWeatherUnderground:&error];
    //eat the error
    [self parseWUObservations:[self xmlData]];
}
-(BOOL) loadXmlDataFromWeatherUnderground:(NSError **)outError forSearchString:(NSString *)searchString{
    BOOL success = false;
    NSString *urlString = [NSString stringWithFormat:@"http://api.wunderground.com/auto/wui/geo/WXCurrentObXML/index.xml?query=%@",searchString];
    NSLog(@"url with search: %@",urlString);
    NSURL *xmlURL = [NSURL URLWithString:(urlString)];
    //NSURL *xmlURL = [NSURL URLWithString:(@"http://api.wunderground.com/auto/wui/geo/WXCurrentObXML/index.xml?query=KBFI")];
    NSURLRequest *req = [NSURLRequest requestWithURL:xmlURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    NSURLResponse *resp = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:req                                         returningResponse:(&resp) error:outError];
    if (!data){
        [self setXmlData:nil];
    } else{
        [self setXmlData:data];
        NSLog(@"Received %ld bytes.",[data length]);
        success = true;
    }
    return success;
}

-(BOOL) loadXmlDataFromWeatherUnderground:(NSError **)outError{
    BOOL success = false;
    NSURL *xmlURL = [NSURL URLWithString:(@"http://api.wunderground.com/auto/wui/geo/WXCurrentObXML/index.xml?query=KBFI")];
    NSURLRequest *req = [NSURLRequest requestWithURL:xmlURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    NSURLResponse *resp = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:req                                         returningResponse:(&resp) error:outError];
    if (!data){
        [self setXmlData:nil];
    } else{
        [self setXmlData:data];
         NSLog(@"Received %ld bytes.",[data length]);
        success = true;
    }
    return success;
}
/*
+(NSData *) callWeatherUndergroundWS:(NSError **)outError{
    NSURL *xmlURL = [NSURL URLWithString:(@"http://api.wunderground.com/auto/wui/geo/WXCurrentObXML/index.xml?query=KBFI")];
    NSURLRequest *req = [NSURLRequest requestWithURL:xmlURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    NSURLResponse *resp = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:req                                         returningResponse:(&resp) error:outError];
    if (!data)
        return nil;
    NSLog(@"Received %ld bytes.",[data length]);
    return data;
}
*/
#pragma mark -
#pragma mark XML Parser Method
-(void) parseWUObservations:(NSData *)theData{
    BOOL success;
    
    //[observations removeAllObjects];
    
    NSXMLParser *parser;
    parser = [[NSXMLParser alloc] initWithData:theData];
    [parser setDelegate:self];
    success = [parser parse];
    if (!success){
        outputDictionary = nil;
    }
    parser = nil;
    
}



#pragma mark -
#pragma mark NSXMLParserDelegate Methods
-(void)parser:(NSXMLParser *)parser 
didStartElement:(NSString *)elementName 
 namespaceURI:(NSString *)namespaceURI 
qualifiedName:(NSString *)qName 
   attributes:(NSDictionary *)attributeDict
{
    NSLog(@"didStart: %@",elementName);
    if([elementName isEqual:@"current_observation"]){
        currentFields = [[[NSMutableDictionary alloc]init] autorelease];
    } 
    
}



-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if ([elementName isEqual:@"current_observation"]){
        
        outputDictionary = [[currentFields copy] autorelease];
        currentFields = nil;
        
        
    } else if (currentFields && currentString){
        NSString *trimmed;
        
        trimmed = [currentString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        // NSLog(@"elementName: %@  trimmed: %@",elementName,trimmed);
        
        if ( [elementName isEqual:@"pressure_mb"] 
            || [elementName isEqual:@"wind_mph"]
            || [elementName isEqual:@"latitude"] 
            || [elementName isEqual:@"longitude"] 
            || [elementName isEqual:@"observation_epoch"] 
            || [elementName isEqual:@"temp_f"] 
            || [elementName isEqual:@"station_id"] 
            || [elementName isEqual:@"full"]){
            //NSNumber *tempNum = [NSNumber numberWithDouble:[trimmed doubleValue]];
            [currentFields setObject:trimmed forKey:elementName];       
        } 
    }
    currentString = nil;
}

-(void)parser: (NSXMLParser *)parser foundCharacters:(NSString *)string{
    if (!currentString){
        currentString = [[[NSMutableString alloc]init] autorelease];
    }
    [currentString appendString:string];
}
@end
