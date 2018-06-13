//
//  PADemoUtils.m
//  PlayableAds_Example
//
//  Created by lgd on 2018/4/18.
//  Copyright © 2018年 on99. All rights reserved.
//

#import "PADemoUtils.h"

@interface PADemoUtils ()
@property (nonatomic) NSFileManager *fm;
@end

@implementation PADemoUtils

+ (instancetype)shared {
    static PADemoUtils *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)init {
    if (self = [super init]) {
        self.fm = [NSFileManager defaultManager];
    }
    return self;
}

- (NSURL *)baseDirectoryURL {
    NSURL *cacheDirectoryURL =
        [self.fm URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    return [cacheDirectoryURL URLByAppendingPathComponent:@"PlayableAdsCache" isDirectory:YES];
}

- (BOOL)createTagFile {
    NSURL *baseDir = [self baseDirectoryURL];
    BOOL dirExist = [self.fm fileExistsAtPath:[baseDir absoluteString]];
    if (!dirExist) {
        NSError *error;
        BOOL successful =
            [self.fm createDirectoryAtURL:baseDir withIntermediateDirectories:YES attributes:nil error:&error];
        if (successful) {
            return
                [self.fm createFileAtPath:[baseDir.path stringByAppendingString:@"/zpta"] contents:nil attributes:nil];
        }
    }
    return NO;
}

- (BOOL)removeTagFile {
    return [self.fm removeItemAtPath:[[[self baseDirectoryURL] path] stringByAppendingString:@"/zpta"] error:NULL];
}

- (BOOL)tagFileExsit {
    BOOL exist = [self.fm fileExistsAtPath:[[[self baseDirectoryURL] path] stringByAppendingString:@"/zpta"]];
    return exist;
}

- (void)dealloc {
}

@end
