//
//  ptStationFetcher.m
//  weatherdb
//
//  Created by Becky on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ptStationFetcher.h"

@implementation ptStationFetcher

@synthesize outputArray;
@synthesize xmlData;
@synthesize currentArray;
@synthesize currentString;





-(void) fetchStationIdArray: (NSString *) lat forLongitude: (NSString *) lon{
    NSError *error = nil;
    [self loadXmlDataFromWeatherUnderground:&error forLatitude:lat forLongitude:lon];
    [self parseWUStations:[self xmlData]];
    
}

-(BOOL) loadXmlDataFromWeatherUnderground: (NSError **)outError forLatitude: (NSString *) lat forLongitude: (NSString *) lon{
    BOOL success = false;
     NSString *urlString = [NSString stringWithFormat:@"http://api.wunderground.com/auto/wui/geo/GeoLookupXML/index.xml?query=%@,%@",lat,lon];
    NSLog(@"url with search: %@",urlString);
    NSURL *xmlURL = [NSURL URLWithString:(urlString)];
    
   
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

#pragma mark -
#pragma mark XML Parser Method
-(void) parseWUStations:(NSData *)theData{
    BOOL success;
    NSXMLParser *parser;
    parser = [[NSXMLParser alloc] initWithData:theData];
    [parser setDelegate:self];
    success = [parser parse];
    if (!success){
        outputArray = nil;
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
    if([elementName isEqual:@"location"]){
        currentArray = [[[NSMutableArray alloc]init] autorelease];
    } 
    
}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if ([elementName isEqual:@"icao"]){
     
        NSLog(@"did end station id in currentArray: %@",[currentArray lastObject]);
         [currentArray addObject:[currentString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];  
        
    } else if ([elementName isEqual:@"location"]){
        outputArray = [[currentArray copy]autorelease];
    
    } else if (currentArray && currentString){
        NSString *trimmed;
        
        trimmed = [currentString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSLog(@"elementName: %@  trimmed: %@",elementName,trimmed);
        
       
    }
    currentString = nil;
}
-(void)parser: (NSXMLParser *)parser foundCharacters:(NSString *)string{
    if (!currentString){
        currentString = [[[NSMutableString alloc]init] autorelease];
    }
    [currentString appendString:string];
    NSLog(@"current string: %@",currentString);
}

@end
