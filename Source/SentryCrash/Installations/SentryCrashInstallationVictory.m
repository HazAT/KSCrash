//
//  SentryCrashInstallationVictory.m
//
//  Created by Kelp on 2013-03-13.
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


#import "SentryCrashInstallationVictory.h"
#import "SentryCrashInstallation+Private.h"
#import "SentryCrashReportFilterBasic.h"
#import "SentryCrashReportSinkVictory.h"


@implementation SentryCrashInstallationVictory

@synthesize url = _url;
@synthesize userName = _userName;
@synthesize userEmail = _userEmail;

+ (instancetype) sharedInstance
{
    static SentryCrashInstallationVictory *sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[SentryCrashInstallationVictory alloc] init];
    });
    return sharedInstance;
}

- (id) init
{
    return [super initWithRequiredProperties:[NSArray arrayWithObjects: @"url", nil]];
}

- (id<SentryCrashReportFilter>) sink
{
    SentryCrashReportSinkVictory* sink = [SentryCrashReportSinkVictory sinkWithURL:self.url userName:self.userName userEmail:self.userEmail];
    return [SentryCrashReportFilterPipeline filterWithFilters:[sink defaultCrashReportFilterSet], nil];
}

@end
