//
//  CountdownTimer.m
//  testoc
//
//  Created by wu, hao on 2019/10/28.
//  Copyright © 2019 wuhao. All rights reserved.
//

#import "CountdownTimer.h"
#import <pthread/pthread.h>

@interface CountdownTimer()
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, dispatch_source_t> *timers;
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, CountdownCallback> *callBacks;
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, NSDate *> *endDates;
@end

@implementation CountdownTimer {
    pthread_mutex_t _lock;
}

typedef enum : NSUInteger {
    timer,
    callBacks,
    endDates,
} CountdownStorageType;

static id _instance;
+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        pthread_mutex_init(&_lock, NULL);
        _timers = [NSMutableDictionary dictionary];
        _callBacks = [NSMutableDictionary dictionary];
        _endDates = [NSMutableDictionary dictionary];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

+ (void)startTimerWithKey:(CountdownKey)key
                  count:(NSInteger)count
                 callBack:(CountdownCallback)callback {
    NSTimeInterval endTimeInterval = [[NSDate date] timeIntervalSince1970] + count;
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endTimeInterval];
    [[CountdownTimer shared] startTimerWithKey:key endDate:endDate callBack:callback];
}

+ (void)stopTimerWithKey:(CountdownKey)key {
    [[CountdownTimer shared] handleCallbackWithKey:key count:0 isFinished:YES];
}

+ (void)continueTimerWithKey:(CountdownKey)key
                     callBack:(CountdownCallback)callback {
    [[CountdownTimer shared] continueTimerWithKey:key callBack:callback];
}

+ (BOOL)isFinishedTimerWithKey:(CountdownKey)key {
    return [[CountdownTimer shared] isFinishedTimerWithKey:key];
}

- (void)startTimerWithKey:(CountdownKey)key
                    endDate:(NSDate *)endDate
                 callBack:(CountdownCallback)callback {
    pthread_mutex_lock(&_lock);
    _endDates[@(key)] = endDate;
    _callBacks[@(key)] = callback;
    pthread_mutex_unlock(&_lock);
    [self launchTimerWithKey:key];
}

- (void)continueTimerWithKey:(CountdownKey)key
                     callBack:(CountdownCallback)callback {
    pthread_mutex_lock(&_lock);
    NSDate *endTime = _endDates[@(key)];
    pthread_mutex_unlock(&_lock);
    if (!endTime || [self isExpiredWithEndTime:[endTime timeIntervalSince1970]]) {
        [self handleCallbackWithKey:key count:0 isFinished:YES];
        return;
    }
    [self removeCountDownWithKey:key];
    [self startTimerWithKey:key endDate:endTime callBack:callback];
}

- (BOOL)isFinishedTimerWithKey:(CountdownKey)key {
    pthread_mutex_lock(&_lock);
    BOOL isFhinished = _timers[@(key)] == nil;
    pthread_mutex_unlock(&_lock);
    return isFhinished;
}

- (void)launchTimerWithKey:(CountdownKey)key {
    dispatch_source_t timer = [self createCountDownTimerWithKey:key];
    pthread_mutex_lock(&_lock);
    _timers[@(key)] = timer;
    pthread_mutex_unlock(&_lock);
    dispatch_resume(timer);
}

- (void)removeCountDownWithKey:(CountdownKey)key {
    pthread_mutex_lock(&_lock);
    dispatch_source_t timer = _timers[@(key)];
    dispatch_source_cancel(timer);
    [_timers removeObjectForKey:@(key)];
    [_callBacks removeObjectForKey:@(key)];
    [_endDates removeObjectForKey:@(key)];
    pthread_mutex_unlock(&_lock);
}

- (void)willEnterForegroundNotification {
    NSDictionary *tempDict = [NSDictionary dictionaryWithDictionary:_callBacks];
    for (NSNumber *key in tempDict) {
        CountdownCallback callBack = _callBacks[key];
        if (!callBack) {
            continue;
        }
        [self continueTimerWithKey:key.integerValue callBack:callBack];
    }
}

- (dispatch_source_t) createCountDownTimerWithKey:(CountdownKey)key {
    pthread_mutex_lock(&_lock);
    NSDate *endTime = _endDates[@(key)];
    pthread_mutex_unlock(&_lock);
    NSTimeInterval endTimeInterval = [endTime timeIntervalSince1970];
    if ([self isExpiredWithEndTime:endTimeInterval]) {
        [self handleCallbackWithKey:key count:0 isFinished:true];
        return nil;
    }
    dispatch_source_t timer;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    __block NSInteger countDown = endTimeInterval - [[NSDate date] timeIntervalSince1970] + 1;
    typeof(self) __weak weakself = self;
    dispatch_source_set_event_handler(timer, ^{
        countDown--;
        BOOL isFinished = countDown <= 0;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself handleCallbackWithKey:key count:countDown isFinished:isFinished];
        });
    });
    return timer;
}

- (void)handleCallbackWithKey:(CountdownKey)key count:(NSInteger)count isFinished:(BOOL)isFinished {
    CountdownCallback callback = _callBacks[@(key)];
    if (!callback) {
        return;
    }
    callback(count, isFinished);
    if (isFinished) {
        [self removeCountDownWithKey:key];
    }
}

- (BOOL)isExpiredWithEndTime:(NSTimeInterval)endTime {
    return [NSDate date].timeIntervalSince1970 >= endTime;
}

@end
