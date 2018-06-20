//
//  SentryCrashInstallationEmail.m
//
//  Created by Karl Stenerud on 2013-03-02.
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


#import "SentryCrashInstallationEmail.h"
#import "SentryCrashInstallation+Private.h"
#import "SentryCrashReportSinkEMail.h"
#import "SentryCrashReportFilterAlert.h"


@interface SentryCrashInstallationEmail ()

@property(nonatomic,readwrite,retain) NSDictionary* defaultFilenameFormats;

@end


@implementation SentryCrashInstallationEmail

@synthesize recipients = _recipients;
@synthesize subject = _subject;
@synthesize message = _message;
@synthesize filenameFmt = _filenameFmt;
@synthesize reportStyle = _reportStyle;
@synthesize defaultFilenameFormats = _defaultFilenameFormats;

+ (instancetype) sharedInstance
{
    static SentryCrashInstallationEmail *sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[SentryCrashInstallationEmail alloc] init];
    });
    return sharedInstance;
}

- (id) init
{
    if((self = [super initWithRequiredProperties:[NSArray arrayWithObjects:
                                                  @"recipients",
                                                  @"subject",
                                                  @"filenameFmt",
                                                  nil]]))
    {
        NSString* bundleName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
        self.subject = [NSString stringWithFormat:@"Crash Report (%@)", bundleName];
        self.defaultFilenameFormats = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [NSString stringWithFormat:@"crash-report-%@-%%d.txt.gz", bundleName],
                                       [NSNumber numberWithInt:SentryCrashEmailReportStyleApple],
                                       [NSString stringWithFormat:@"crash-report-%@-%%d.json.gz", bundleName],
                                       [NSNumber numberWithInt:SentryCrashEmailReportStyleJSON],
                                       nil];
        [self setReportStyle:SentryCrashEmailReportStyleJSON useDefaultFilenameFormat:YES];
    }
    return self;
}

- (void) setReportStyle:(SentryCrashEmailReportStyle)reportStyle
useDefaultFilenameFormat:(BOOL) useDefaultFilenameFormat
{
    self.reportStyle = reportStyle;

    if(useDefaultFilenameFormat)
    {
        self.filenameFmt = [self.defaultFilenameFormats objectForKey:[NSNumber numberWithInt:reportStyle]];
    }
}

- (id<SentryCrashReportFilter>) sink
{
    SentryCrashReportSinkEMail* sink = [SentryCrashReportSinkEMail sinkWithRecipients:self.recipients
                                                                      subject:self.subject
                                                                      message:self.message
                                                                  filenameFmt:self.filenameFmt];

    switch(self.reportStyle)
    {
        case SentryCrashEmailReportStyleApple:
            return [sink defaultCrashReportFilterSetAppleFmt];
        case SentryCrashEmailReportStyleJSON:
            return [sink defaultCrashReportFilterSet];
    }
}

@end
