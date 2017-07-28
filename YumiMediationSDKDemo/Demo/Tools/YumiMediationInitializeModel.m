//
//  YumiMediationInitializeModel.m
//  YumiMediationDebugCenter-iOS
//
//  Created by ShunZhi Tang on 2017/7/27.
//
//

#import "YumiMediationInitializeModel.h"

@implementation YumiMediationInitializeModel

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)coder {

    [coder encodeObject:self.yumiID forKey:@"yumiID"];
    [coder encodeObject:self.channelID forKey:@"channelID"];
    [coder encodeObject:self.versionID forKey:@"versionID"];
}

- (instancetype)initWithCoder:(NSCoder *)decoder {

    if (self = [super init]) {
        self.yumiID = [decoder decodeObjectForKey:@"yumiID"];
        self.channelID = [decoder decodeObjectForKey:@"channelID"];
        self.versionID = [decoder decodeObjectForKey:@"versionID"];
    }

    return self;
}

@end
