//
//  CrashTesterCommands.m
//  Example-Apps-Mac
//
//  Created by Karl Stenerud on 9/28/13.
//  Copyright (c) 2013 Karl Stenerud. All rights reserved.
//

#import "CrashTesterCommands.h"
#import "Configuration.h"

#import <SentryCrash/SentryCrash.h>
#import <SentryCrash/SentryCrashReportFilterSets.h>
#import <SentryCrash/SentryCrashReportFilter.h>
#import <SentryCrash/SentryCrashReportFilterAppleFmt.h>
#import <SentryCrash/SentryCrashReportFilterBasic.h>
#import <SentryCrash/SentryCrashReportFilterGZip.h>
#import <SentryCrash/SentryCrashReportFilterJSON.h>
#import <SentryCrash/SentryCrashReportSinkConsole.h>
#import <SentryCrash/SentryCrashReportSinkEMail.h>
#import <SentryCrash/SentryCrashReportSinkQuincyHockey.h>
#import <SentryCrash/SentryCrashReportSinkStandard.h>
#import <SentryCrash/SentryCrashReportSinkVictory.h>

@implementation CrashTesterCommands

+ (NSString*) reportCountString
{
    int reportCount = (int)[[SentryCrash sharedInstance] reportCount];
    if(reportCount == 1)
    {
        return @"1 Report";
    }
    else
    {
        return [NSString stringWithFormat:@"%d Reports", reportCount];
    }
}

+ (void) showAlertWithTitle:(NSString*) title
                    message:(NSString*) fmt, ...
{
    va_list args;
    va_start(args, fmt);
    NSString* message = [[NSString alloc] initWithFormat:fmt arguments:args];
    va_end(args);

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
    [[[UIAlertView alloc] initWithTitle:title
                                message:message
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
#else
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"OK"];
    [alert setMessageText:title];
    [alert setInformativeText:message];
    [alert setAlertStyle:NSInformationalAlertStyle];
    [alert runModal];
#endif
}


+ (void) sendReportsWithMessage:(NSString*)message
                           sink:(id<SentryCrashReportFilter>)sink
{
    [self sendReportsWithMessage:message sink:sink completion:nil];
}

+ (void) sendReportsWithMessage:(NSString*)message
                           sink:(id<SentryCrashReportFilter>)sink
                     completion:(SentryCrashReportFilterCompletion)completion
{
    NSLog(@"%@", message);
    SentryCrash* crashReporter = [SentryCrash sharedInstance];
    crashReporter.sink = sink;
    [crashReporter sendAllReportsWithCompletion:completion];
}

+ (void) printStandard
{
    [self sendReportsWithMessage:@"Printing standard reports..."
                            sink:[SentryCrashReportFilterPipeline filterWithFilters:
                                  [SentryCrashReportFilterJSONEncode filterWithOptions:KSJSONEncodeOptionSorted | KSJSONEncodeOptionPretty],
                                  [SentryCrashReportFilterDataToString filter],
                                  [SentryCrashReportSinkConsole filter],
                                  nil]];
}

+ (void) printUnsymbolicated
{
    [self sendReportsWithMessage:@"Printing unsymbolicated apple reports..."
                            sink:[SentryCrashReportFilterPipeline filterWithFilters:
                                  [SentryCrashReportFilterAppleFmt filterWithReportStyle:KSAppleReportStyleUnsymbolicated],
                                  [SentryCrashReportSinkConsole filter],
                                  nil]];
}

+ (void) printPartiallySymbolicated
{
    [self sendReportsWithMessage:@"Printing partially symbolicated apple reports..."
                            sink:[SentryCrashReportFilterPipeline filterWithFilters:
                                  [SentryCrashReportFilterAppleFmt filterWithReportStyle:KSAppleReportStylePartiallySymbolicated],
                                  [SentryCrashReportSinkConsole filter],
                                  nil]];
}

+ (void) printSymbolicated
{
    [self sendReportsWithMessage:@"Printing symbolicated apple reports..."
                            sink:[SentryCrashReportFilterPipeline filterWithFilters:
                                  [SentryCrashReportFilterAppleFmt filterWithReportStyle:KSAppleReportStyleSymbolicated],
                                  [SentryCrashReportSinkConsole filter],
                                  nil]];
}

+ (void) printSideBySide
{
    [self sendReportsWithMessage:@"Apple Style (Side-By-Side)"
                            sink:[SentryCrashReportFilterPipeline filterWithFilters:
                                  [SentryCrashReportFilterAppleFmt filterWithReportStyle:KSAppleReportStyleSymbolicatedSideBySide],
                                  [SentryCrashReportSinkConsole filter],
                                  nil]];
}

+ (void) printSideBySideWithUserAndSystemData
{
    [self sendReportsWithMessage:@"Printing side-by-side symbolicated apple reports with system and user data..."
                            sink:[SentryCrashReportFilterPipeline filterWithFilters:
                                  [SentryCrashFilterSets appleFmtWithUserAndSystemData:KSAppleReportStyleSymbolicatedSideBySide
                                                                        compressed:NO],
                                  [SentryCrashReportSinkConsole filter],
                                  nil]];
}

+ (void) mailStandard
{
    [self sendReportsWithMessage:@"Mailing standard reports..."
                            sink:[[SentryCrashReportSinkEMail sinkWithRecipients:nil
                                                                    subject:@"Crash Reports"
                                                                    message:nil
                                                                filenameFmt:@"StandardReport-%d.json.gz"] defaultCrashReportFilterSet]];
}

+ (void) mailUnsymbolicated
{
    [self sendReportsWithMessage:@"Mailing unsymbolicated apple reports..."
                            sink:[SentryCrashReportFilterPipeline filterWithFilters:
                                  [SentryCrashReportFilterAppleFmt filterWithReportStyle:KSAppleReportStyleUnsymbolicated],
                                  [SentryCrashReportFilterStringToData filter],
                                  [SentryCrashReportFilterGZipCompress filterWithCompressionLevel:-1],
                                  [SentryCrashReportSinkEMail sinkWithRecipients:nil
                                                                     subject:@"Crash Reports"
                                                                     message:nil
                                                                 filenameFmt:@"AppleUnsymbolicatedReport-%d.txt.gz"],
                                  nil]];
}

+ (void) mailPartiallySymbolicated
{
    [self sendReportsWithMessage:@"Mailing partially symbolicated apple reports..."
                            sink:[SentryCrashReportFilterPipeline filterWithFilters:
                                  [SentryCrashReportFilterAppleFmt filterWithReportStyle:KSAppleReportStylePartiallySymbolicated],
                                  [SentryCrashReportFilterStringToData filter],
                                  [SentryCrashReportFilterGZipCompress filterWithCompressionLevel:-1],
                                  [SentryCrashReportSinkEMail sinkWithRecipients:nil
                                                                     subject:@"Crash Reports"
                                                                     message:nil
                                                                 filenameFmt:@"ApplePartialSymbolicatedReport-%d.txt.gz"],
                                  nil]];
}

+ (void) mailSymbolicated
{
    [self sendReportsWithMessage:@"Mailing symbolicated apple reports..."
                            sink:[SentryCrashReportFilterPipeline filterWithFilters:
                                  [SentryCrashReportFilterAppleFmt filterWithReportStyle:KSAppleReportStyleSymbolicated],
                                  [SentryCrashReportFilterStringToData filter],
                                  [SentryCrashReportFilterGZipCompress filterWithCompressionLevel:-1],
                                  [SentryCrashReportSinkEMail sinkWithRecipients:nil
                                                                     subject:@"Crash Reports"
                                                                     message:nil
                                                                 filenameFmt:@"AppleSymbolicatedReport-%d.txt.gz"],
                                  nil]];
}

+ (void) mailSideBySide
{
    [self sendReportsWithMessage:@"Mailing side-by-side symbolicated apple reports..."
                            sink:[SentryCrashReportFilterPipeline filterWithFilters:
                                  [SentryCrashReportFilterAppleFmt filterWithReportStyle:KSAppleReportStyleSymbolicatedSideBySide],
                                  [SentryCrashReportFilterStringToData filter],
                                  [SentryCrashReportFilterGZipCompress filterWithCompressionLevel:-1],
                                  [SentryCrashReportSinkEMail sinkWithRecipients:nil
                                                                     subject:@"Crash Reports"
                                                                     message:nil
                                                                 filenameFmt:@"AppleSideBySideReport-%d.txt.gz"],
                                  nil]];
}

+ (void) mailSideBySideWithUserAndSystemData
{
    [self sendReportsWithMessage:@"Mailing side-by-side symbolicated apple reports with system and user data..."
                            sink:[SentryCrashReportFilterPipeline filterWithFilters:
                                  [SentryCrashFilterSets appleFmtWithUserAndSystemData:KSAppleReportStyleSymbolicatedSideBySide
                                                                        compressed:YES],
                                  [SentryCrashReportSinkEMail sinkWithRecipients:nil
                                                                     subject:@"Crash Reports"
                                                                     message:nil
                                                                 filenameFmt:@"AppleSystemUserReport-%d.txt.gz"],
                                  nil]];
}

+ (void) sendToKSWithCompletion:(SentryCrashReportFilterCompletion)completion
{
    [self sendReportsWithMessage:@"Sending reports to KS..."
                           sink:[[SentryCrashReportSinkStandard sinkWithURL:kReportURL] defaultCrashReportFilterSet]
                      completion:completion];
}

+ (void) sendToQuincyWithCompletion:(SentryCrashReportFilterCompletion)completion
{
    [self sendReportsWithMessage:@"Sending reports to Quincy..."
                            sink:[[SentryCrashReportSinkQuincy sinkWithURL:kQuincyReportURL
                                                             userIDKey:nil
                                                           userNameKey:nil
                                                       contactEmailKey:nil
                                                  crashDescriptionKeys:nil] defaultCrashReportFilterSet]
                      completion:completion];
}

+ (void) sendToHockeyWithCompletion:(SentryCrashReportFilterCompletion)completion
{
    [self sendReportsWithMessage:@"Sending reports to Hockey..."
                            sink:[[SentryCrashReportSinkHockey sinkWithAppIdentifier:kHockeyAppID
                                                                       userIDKey:nil
                                                                     userNameKey:nil
                                                                 contactEmailKey:nil
                                                            crashDescriptionKeys:nil] defaultCrashReportFilterSet]
                      completion:completion];
}

+ (void) sendToVictoryWithUserName:(NSString*)userName
                        completion:(SentryCrashReportFilterCompletion)completion
{
    [self sendReportsWithMessage:@"Sending reports to Victory..."
                            sink:[[SentryCrashReportSinkVictory sinkWithURL:kVictoryURL
                                                               userName:userName
                                                              userEmail:nil] defaultCrashReportFilterSet]
                      completion:completion];
}

@end
