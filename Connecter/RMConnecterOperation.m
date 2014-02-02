//
//  RMConnecterOperation.m
//  Connecter
//
//  Created by Damien DeVille on 2/2/14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import "RMConnecterOperation.h"

@interface RMConnecterOperation (/* Parameters */)

@property (copy, nonatomic) NSString *launchPath;
@property (strong, nonatomic) NSArray *arguments;

@end

@interface RMConnecterOperation (/* Operation */)

@property (assign, atomic) BOOL isExecuting, isFinished;

@property (readwrite, copy, atomic) NSString * (^completionProvider)(NSError **errorRef);

@end

@interface RMConnecterOperation (/* Private */)

@property (strong, nonatomic) NSOperationQueue *controlQueue;
@property (strong, nonatomic) dispatch_queue_t workQueue;

@property (strong, nonatomic) NSTask *task;
@property (strong, nonatomic) dispatch_io_t taskConnection;

@property (strong, nonatomic) NSMutableData *response;

@end

@implementation RMConnecterOperation

- (id)initWithToolLaunchPath:(NSString *)launchPath arguments:(NSArray *)arguments
{
	self = [self init];
	if (self == nil) {
		return nil;
	}
	
	NSParameterAssert(launchPath != nil);
	_launchPath = [launchPath copy];
	
	NSParameterAssert(arguments != nil);
	_arguments = arguments;
	
	return self;
}

#pragma mark - NSOperation

- (BOOL)isConcurrent
{
	return YES;
}

static NSString * const _RMConnecterOperationIsExecutingKey = @"isExecuting";
static NSString * const _RMConnecterOperationIsFinishedKey = @"isFinished";

- (void)start
{
	[[self controlQueue] addOperationWithBlock:^ {
		if ([self isCancelled]) {
			[self _finish];
			return;
		}
		
		[self willChangeValueForKey:_RMConnecterOperationIsExecutingKey];
		[self setIsExecuting:YES];
		[self didChangeValueForKey:_RMConnecterOperationIsExecutingKey];
		
		[self _startTask];
	}];
}

- (void)cancel
{
	[[self controlQueue] addOperationWithBlock:^ {
		[[self task] terminate];
		
		[super cancel];
	}];
	
	[super cancel];
}

- (void)_finish
{
	[self willChangeValueForKey:_RMConnecterOperationIsExecutingKey];
	[self setIsExecuting:NO];
	[self didChangeValueForKey:_RMConnecterOperationIsExecutingKey];
	
	[self willChangeValueForKey:_RMConnecterOperationIsFinishedKey];
	[self setIsFinished:YES];
	[self didChangeValueForKey:_RMConnecterOperationIsFinishedKey];
}

#pragma mark - Task

- (void)_startTask
{
	[self __setupTask];
	[self __setupConnection];
	
	[self __startTask];
}

- (void)__setupTask
{
	NSTask *task = [[NSTask alloc] init];
	[task setLaunchPath:[self launchPath]];
	[task setArguments:[self arguments]];
	
	[task setStandardOutput:[NSPipe pipe]];
	[task setStandardError:[NSFileHandle fileHandleWithNullDevice]];
	
	[self setTask:task];
}

- (void)__setupConnection
{
	dispatch_io_t connection = dispatch_io_create(DISPATCH_IO_STREAM, [[[[self task] standardOutput] fileHandleForReading] fileDescriptor], [self workQueue], ^ (int error) {
		if (error != 0) {
			[self _didReceiveTaskError:[NSError errorWithDomain:NSPOSIXErrorDomain code:error userInfo:nil]];
			return;
		}
	});
	[self setTaskConnection:connection];
	
	dispatch_io_read(connection, 0, SIZE_MAX, [self workQueue], ^ (bool done, dispatch_data_t receivedData, int error) {
		if (receivedData != nil && dispatch_data_get_size(receivedData) != 0) {
			if ([self response] == nil) {
				[self setResponse:[NSMutableData data]];
			}
			
			void const *bytes = NULL; size_t bytesLength = 0;
			dispatch_data_t contiguousData __attribute__((unused, objc_precise_lifetime)) = dispatch_data_create_map(receivedData, &bytes, &bytesLength);
			
			[[self response] appendBytes:bytes length:bytesLength];
		}
		
		if (error != 0) {
			dispatch_io_close(connection, DISPATCH_IO_STOP);
			
			[self _didReceiveTaskError:[NSError errorWithDomain:NSPOSIXErrorDomain code:error userInfo:nil]];
			return;
		}
		
		if (done) {
			dispatch_io_close(connection, DISPATCH_IO_STOP);
			
			[self _didReceiveTaskResponse:[self response]];
		}
	});
}

- (void)__startTask
{
	[[self task] launch];
}

#pragma mark - Completion

- (void)_didReceiveTaskError:(NSError *)error
{
	[self setCompletionProvider:^ NSString * (NSError **errorRef) {
		if (errorRef != NULL) {
			*errorRef = error;
		}
		return nil;
	}];
	
	[self _finish];
}

- (void)_didReceiveTaskResponse:(NSData *)response
{
	NSString *responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
	
	[self setCompletionProvider:^ NSString * (NSError **errorRef) {
		return responseString;
	}];
	
	[self _finish];
}

@end
