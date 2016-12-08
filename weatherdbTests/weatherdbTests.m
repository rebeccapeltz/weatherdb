//
//  weatherdbTests.m
//  weatherdbTests
//
//  Created by Rebecca Peltz on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "weatherdbTests.h"
#import "ptObservationFetcher.h"
#import "ptStationFetcher.h"



@implementation weatherdbTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    //STFail(@"Unit tests are not implemented yet in weatherdbTests");
    STAssertTrue(0==0,@"0 is not equal to 0");
    
}
-(void)testStationFetcher{
    
    NSError *error = nil;
    ptStationFetcher *fetcher = [[[ptStationFetcher alloc]init]autorelease];
    NSString *latStr = @"47.8";
    NSString *lonStr = @"-122.4";
    [fetcher loadXmlDataFromWeatherUnderground:&error forLatitude:latStr forLongitude:lonStr ];
    STAssertNil(error,@"fetcher has non nil error");
    STAssertNotNil([fetcher xmlData],@"fetcher returned no data");
    NSString *dataStr = [NSString stringWithUTF8String:[[fetcher xmlData] bytes]];
    STAssertNotNil(dataStr,@"data is nil");
}
-(void) testParseStationData{
    NSString *xmlStr = @"<location> \
    <icao>KBFI</icao>\
    </location>";
    
    STAssertTrue([xmlStr length] > 0,@"length not > 0");
    NSData *data = [xmlStr dataUsingEncoding: NSUTF8StringEncoding];
    STAssertNotNil(data,@"data is nil");
    ptStationFetcher *fetcher = [[[ptStationFetcher alloc]init] autorelease];
    [fetcher parseWUStations:data];
    NSArray *outputArray = [fetcher outputArray];
    STAssertNotNil(outputArray,@"output array is empty");
    
}
-(void)testLoadXMLData{
    NSError *error = nil;
     ptObservationFetcher *fetcher = [[[ptObservationFetcher alloc]init] autorelease];
    [fetcher loadXmlDataFromWeatherUnderground:&error];
    NSData *data = nil;
    data = [fetcher xmlData];
    STAssertNotNil(data,@"fetcher returned no data");
}
-(void)testLoadXMLDataWithStationId{
    NSError *error = nil;
    ptObservationFetcher *fetcher = [[[ptObservationFetcher alloc]init]autorelease];
    [fetcher loadXmlDataFromWeatherUnderground:&error forSearchString:@"KBFI"];
    NSData *data = nil;
    data = [fetcher xmlData];
    STAssertNotNil(data,@"fetcher with ID returned no data");
}
-(void) testFetchStationIdArray{
    ptStationFetcher *fetcher = [[[ptStationFetcher alloc]init]autorelease];
    NSString *latStr = @"47.8";
    NSString *lonStr = @"-122.4";
    [fetcher fetchStationIdArray:latStr forLongitude:lonStr];
    STAssertNotNil([fetcher outputArray],@"array of ids is empty");
}

-(void)testFetchObservationDictionary{
    ptObservationFetcher *fetcher = [[[ptObservationFetcher alloc]init] autorelease];
    NSDictionary *dictionary = nil;
    [fetcher fetchObservationDataDictionary];
    dictionary = [fetcher outputDictionary];
    STAssertNotNil(dictionary,@"observation data dictionary is nil");
}
-(void)testShortXMLParser{
    NSString *xmlStr = @"<current_observation> \
    <temp_f>41</temp_f>\
    <pressure_mb>994</pressure_mb> \
    </current_observation>";
    
    STAssertTrue([xmlStr length] > 0,@"length not > 0");
    NSData *data = [xmlStr dataUsingEncoding: NSUTF8StringEncoding];
    STAssertNotNil(data,@"data is nil");
    ptObservationFetcher *fetcher = [[[ptObservationFetcher alloc]init] autorelease];
    [fetcher parseWUObservations:data];
    NSDictionary *outputDictionary = [fetcher outputDictionary];
    STAssertTrue([outputDictionary count] >0 ,@"dictionary has no entries");
    //int num = [[outputDictionary objectForKey:@"temp_f"] intValue];
    STAssertTrue([[outputDictionary objectForKey:@"temp_f"] intValue] == 41,@"incorrect temp value");
    STAssertTrue([[outputDictionary objectForKey:@"pressure_mb"] intValue] == 994,@"incorrect pressure value");
      // NSString *str = [outputDictionary objectForKey:@"temp_f"];
    //STAssertTrue([str isEqualToString: @"41"],@"incorrect value");
    //ptWundergroundObservation *obs =[observations objectAtIndex:0];
    //STAssertNotNil([obs temperature],@"Temp is not null");
}

-(void)testObervationParser{
    NSString *xmlStr = @"<current_observation> \
    <credit>Weather Underground NOAA Weather Station</credit> \
    <credit_URL>http://wunderground.com/</credit_URL>\
    <image> \
    <url>http://icons-ak.wxug.com/graphics/wu2/logo_130x80.png</url> \
    <title>Weather Underground</title> \
    <link>http://wunderground.com/</link> \
    </image> \
    <display_location> \
    <full>Seattle, WA</full>\
    <city>Seattle</city>\
    <state>WA</state>\
    <state_name>Washington</state_name>\
    <country>US</country>\
    <country_iso3166>US</country_iso3166>\
    <zip>98115</zip>\
    <latitude>47.68511963</latitude>\
    <longitude>-122.29238892</longitude>\
    <elevation>110.00000000 ft</elevation>\
    </display_location>\
    <observation_location>\
    <full>Seattle Boeing, Washington</full>\
    <city>Seattle Boeing</city>\
    <state>Washington</state>\
    <country>US</country>\
    <country_iso3166>US</country_iso3166>\
    <latitude>47.52999878</latitude>\
    <longitude>-122.30000305</longitude>\
    <elevation>16 ft</elevation>\
    </observation_location>\
    <station_id>KBFI</station_id>\
    <observation_time>Last Updated on March 12, 6:53 PM PDT</observation_time>\
    <observation_time_rfc822>Tue, 13 Mar 2012 01:53:00 GMT</observation_time_rfc822>\
    <observation_epoch>1331603580</observation_epoch>\
    <local_time>March 12, 7:41 PM PDT</local_time>\
    <local_time_rfc822>Tue, 13 Mar 2012 02:41:05 GMT</local_time_rfc822>\
    <local_epoch>1331606465</local_epoch>\
    <weather>light rain mist</weather>\
    <temperature_string>41 F (5 C)</temperature_string>\
    <temp_f>41</temp_f>\
    <temp_c>5</temp_c>\
    <relative_humidity>89%</relative_humidity>\
    <wind_string>From the South at 8 MPH </wind_string>\
    <wind_dir>South</wind_dir>\
    <wind_degrees>170</wind_degrees>\
    <wind_mph>8</wind_mph>\
    <wind_gust_mph></wind_gust_mph>\
    <pressure_string>29.37 in (994 mb)</pressure_string> \
    <pressure_mb>994</pressure_mb> \
    <pressure_in>29.37</pressure_in> \
    <dewpoint_string>38 F (3 C)</dewpoint_string>\
    <dewpoint_f>38</dewpoint_f> \
    <dewpoint_c>3</dewpoint_c>\
    <heat_index_string>NA</heat_index_string>\
    <heat_index_f>NA</heat_index_f>\
    <heat_index_c>NA</heat_index_c>\
    <windchill_string>36 F (2 C)</windchill_string>\
    <windchill_f>36</windchill_f>\
    <windchill_c>2</windchill_c>\
    <visibility_mi>6.0</visibility_mi>\
    <visibility_km>9.7</visibility_km>\
    </current_observation>";
   
    
    NSData *data = [xmlStr dataUsingEncoding: NSUTF8StringEncoding];
    ptObservationFetcher *fetcher = [[[ptObservationFetcher alloc]init] autorelease];
    [fetcher parseWUObservations:data];
    NSDictionary *outputDictionary = [fetcher outputDictionary];
    STAssertTrue([outputDictionary count] >0 ,@"dictionary has no entries");
    //int num = [[outputDictionary objectForKey:@"temp_f"] intValue];
    STAssertTrue([[outputDictionary objectForKey:@"temp_f"] intValue] == 41,@"incorrect temp value");
    STAssertTrue([[outputDictionary objectForKey:@"pressure_mb"] intValue] == 994,@"incorrect pressure value");
    STAssertTrue([[outputDictionary objectForKey:@"wind_mph"] intValue] == 8,@"incorrect wind value");
    
    
     STAssertTrue([[outputDictionary objectForKey:@"latitude"] doubleValue] == 47.52999878,@"incorrect latitude value");
     STAssertTrue([[outputDictionary objectForKey:@"longitude"] doubleValue] == -122.30000305,@"incorrect longitude value");
    
    //NSDate *testDate = [NSDate dateWithTimeIntervalSince1970:1331603580];
    
    
    STAssertTrue([[outputDictionary objectForKey:@"observation_epoch"] intValue] == 1331603580,@"incorrect epoch value");
    
    STAssertTrue([[outputDictionary objectForKey:@"station_id"] isEqualToString:@"KBFI"],@"incorrect station id value");
     STAssertTrue([[outputDictionary objectForKey:@"full"] isEqualToString:@"Seattle Boeing, Washington"],@"incorrect station name");
    

}

@end
