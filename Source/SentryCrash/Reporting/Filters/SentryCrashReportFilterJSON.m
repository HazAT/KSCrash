//
//  SentryCrashReportFilterJSON.m
//
//  Created by Karl Stenerud on 2012-05-09.
//
//  Copyright (c) 2012 Karl Stenerud. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall remain in place
// in this source code.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//


#import "SentryCrashReportFilterJSON.h"

//#define SentryCrashLogger_LocalLevel TRACE
#import "SentryCrashLogger.h"


@interface SentryCrashReportFilterJSONEncode ()

@property(nonatomic,readwrite,assign) SentryCrashJSONEncodeOption encodeOptions;

@end


@implementation SentryCrashReportFilterJSONEncode

@synthesize encodeOptions = _encodeOptions;

+ (SentryCrashReportFilterJSONEncode*) filterWithOptions:(SentryCrashJSONEncodeOption) options
{
    return [(SentryCrashReportFilterJSONEncode*)[self alloc] initWithOptions:options];
}

- (id) initWithOptions:(SentryCrashJSONEncodeOption) options
{
    if((self = [super init]))
    {
        self.encodeOptions = options;
    }
    return self;
}

- (void) filterReports:(NSArray*) reports
          onCompletion:(SentryCrashReportFilterCompletion) onCompletion
{
    NSMutableArray* filteredReports = [NSMutableArray arrayWithCapacity:[reports count]];
    for(NSDictionary* report in reports)
    {
        NSError* error = nil;
        NSData* jsonData = [SentryCrashJSONCodec encode:report
                                       options:self.encodeOptions
                                         error:&error];
        if(jsonData == nil)
        {
            sentrycrash_callCompletion(onCompletion, filteredReports, NO, error);
            return;
        }
        else
        {
            [filteredReports addObject:jsonData];
        }
    }

    sentrycrash_callCompletion(onCompletion, filteredReports, YES, nil);
}

@end


@interface SentryCrashReportFilterJSONDecode ()

@property(nonatomic,readwrite,assign) SentryCrashJSONDecodeOption decodeOptions;

@end


@implementation SentryCrashReportFilterJSONDecode

@synthesize decodeOptions = _encodeOptions;

+ (SentryCrashReportFilterJSONDecode*) filterWithOptions:(SentryCrashJSONDecodeOption) options
{
    return [(SentryCrashReportFilterJSONDecode*)[self alloc] initWithOptions:options];
}

- (id) initWithOptions:(SentryCrashJSONDecodeOption) options
{
    if((self = [super init]))
    {
        self.decodeOptions = options;
    }
    return self;
}

- (void) filterReports:(NSArray*) reports
          onCompletion:(SentryCrashReportFilterCompletion) onCompletion
{
    NSMutableArray* filteredReports = [NSMutableArray arrayWithCapacity:[reports count]];
    for(NSData* data in reports)
    {
        NSError* error = nil;
        NSDictionary* report = [SentryCrashJSONCodec decode:data
                                           options:self.decodeOptions
                                             error:&error];
        if(report == nil)
        {
            sentrycrash_callCompletion(onCompletion, filteredReports, NO, error);
            return;
        }
        else
        {
            [filteredReports addObject:report];
        }
    }

    sentrycrash_callCompletion(onCompletion, filteredReports, YES, nil);
}

@end
