//
//  SentryCrashInstallationQuincyHockey.m
//
//  Created by Karl Stenerud on 2013-02-10.
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


#import "SentryCrashInstallationQuincyHockey.h"

#import "SentryCrashInstallation+Private.h"
#import "SentryCrashReportFields.h"
#import "SentryCrashReportSinkQuincyHockey.h"
#import "NSError+SimpleConstructor.h"


#define kQuincyDefaultKeyUserID @"user_id"
#define kQuincyDefaultKeyUserName @"user_name"
#define kQuincyDefaultKeyContactEmail @"contact_email"
#define kQuincyDefaultKeyDescription @"crash_description"
#define kQuincyDefaultKeysExtraDescription [NSArray arrayWithObjects:@"/" @SentryCrashField_System, @"/" @SentryCrashField_User, nil]


@implementation SentryCrashInstallationBaseQuincyHockey

IMPLEMENT_REPORT_PROPERTY(userID, UserID, NSString*);
IMPLEMENT_REPORT_PROPERTY(userName, UserName, NSString*);
IMPLEMENT_REPORT_PROPERTY(contactEmail, ContactEmail, NSString*);
IMPLEMENT_REPORT_PROPERTY(crashDescription, CrashDescription, NSString*);

@synthesize extraDescriptionKeys = _extraDescriptionKeys;
@synthesize waitUntilReachable = _waitUntilReachable;

- (id) initWithRequiredProperties:(NSArray*) requiredProperties
{
    if((self = [super initWithRequiredProperties:requiredProperties]))
    {
        self.userIDKey = kQuincyDefaultKeyUserID;
        self.userNameKey = kQuincyDefaultKeyUserName;
        self.contactEmailKey = kQuincyDefaultKeyContactEmail;
        self.crashDescriptionKey = kQuincyDefaultKeyDescription;
        self.extraDescriptionKeys = kQuincyDefaultKeysExtraDescription;
        self.waitUntilReachable = YES;
    }
    return self;
}

- (NSArray*) allCrashDescriptionKeys
{
    NSMutableArray* keys = [NSMutableArray array];
    if(self.crashDescriptionKey != nil)
    {
        [keys addObject:self.crashDescriptionKey];
    }
    if([self.extraDescriptionKeys count] > 0)
    {
        [keys addObjectsFromArray:self.extraDescriptionKeys];
    }
    return keys;
}

@end


@implementation SentryCrashInstallationQuincy

@synthesize url = _url;

+ (instancetype) sharedInstance
{
    static SentryCrashInstallationQuincy *sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[SentryCrashInstallationQuincy alloc] init];
    });
    return sharedInstance;
}

- (id) init
{
    return [super initWithRequiredProperties:[NSArray arrayWithObjects: @"url", nil]];
}

- (id<SentryCrashReportFilter>) sink
{
    SentryCrashReportSinkQuincy* sink = [SentryCrashReportSinkQuincy sinkWithURL:self.url
                                                               userIDKey:[self makeKeyPath:self.userIDKey]
                                                             userNameKey:[self makeKeyPath:self.userNameKey]
                                                         contactEmailKey:[self makeKeyPath:self.contactEmailKey]
                                                    crashDescriptionKeys:[self makeKeyPaths:[self allCrashDescriptionKeys]]];
    sink.waitUntilReachable = self.waitUntilReachable;
    return [sink defaultCrashReportFilterSet];
}

@end


@implementation SentryCrashInstallationHockey

@synthesize appIdentifier = _appIdentifier;

+ (instancetype) sharedInstance
{
    static SentryCrashInstallationHockey *sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[SentryCrashInstallationHockey alloc] init];
    });
    return sharedInstance;
}

- (id) init
{
    if((self = [super initWithRequiredProperties:[NSArray arrayWithObjects:
                                                  @"appIdentifier",
                                                  nil]]))
    {
    }
    return self;
}

- (id<SentryCrashReportFilter>) sink
{
    SentryCrashReportSinkHockey* sink = [SentryCrashReportSinkHockey sinkWithAppIdentifier:self.appIdentifier
                                                                         userIDKey:[self makeKeyPath:self.userIDKey]
                                                                       userNameKey:[self makeKeyPath:self.userNameKey]
                                                                   contactEmailKey:[self makeKeyPath:self.contactEmailKey]
                                                              crashDescriptionKeys:[self makeKeyPaths:[self allCrashDescriptionKeys]]];
    sink.waitUntilReachable = self.waitUntilReachable;
    return [sink defaultCrashReportFilterSet];
}

@end
