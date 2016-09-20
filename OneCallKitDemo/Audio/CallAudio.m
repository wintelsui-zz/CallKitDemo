//
//  CallAudio.m
//  OneCallKitDemo
//
//  Created by wintel on 16/8/23.
//  Copyright © 2016年 wintel. All rights reserved.
//

#import "CallAudio.h"

static CallAudio *_audio = nil;

@implementation CallAudio
{
    AudioController *audioController;
}

+ (instancetype)sharedCallAudio{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _audio = [[CallAudio alloc] init];
    });
    return _audio;
}

- (void)configureAudioSession{
    NSLog(@"Configuring audio session");
    if (audioController == nil) {
        audioController = [[AudioController alloc] init];
    }
}

- (void)startAudio{
    NSLog(@"Starting audio");
    
    if ([audioController startIOUnit] == kAudioServicesNoError) {
        [audioController setMuteAudio:NO];
    } else {
        // handle error
    }
}

- (void)stopAudio{
    NSLog(@"Stopping audio");
    
    if ([audioController stopIOUnit] == kAudioServicesNoError) {
        // handle error
    }
}

@end
