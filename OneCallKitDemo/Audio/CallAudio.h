//
//  CallAudio.h
//  OneCallKitDemo
//
//  Created by wintel on 16/8/23.
//  Copyright © 2016年 wintel. All rights reserved.
//
//  使用麦克风,并播放实时的音频

#import "AudioController.h"

@interface CallAudio : AudioController
+ (instancetype)sharedCallAudio;
- (void)configureAudioSession;
- (void)startAudio;
- (void)stopAudio;

@end
