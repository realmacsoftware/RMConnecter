//
//	RMiTunesConnecterAppDelegate.h
//	Connecter
//
//	Created by Nik Fletcher on 31/01/2014.
//
//	Copyright (c) 2014 Nik Fletcher, Realmac Software
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//	SOFTWARE.
//

static NSString * const _RMConnecterLastPackageLocationDefaultsKey = @"lastPackageLocation";

#import "RMConnecterWindowController.h"

@interface RMConnecterWindowController () <NSTextFieldDelegate>

@property (strong, nonatomic) NSOperationQueue *operationQueue;

@end

@implementation RMConnecterWindowController

static NSString *_RMConnecterTransporterPath(void)
{
	static NSString * const _RMConnecterApplicationLoaderName = @"Application Loader";
	
	NSString *applicationLoaderPath = [[NSWorkspace sharedWorkspace] fullPathForApplication:_RMConnecterApplicationLoaderName];
	if (applicationLoaderPath == nil) {
		return nil;
	}
	
	return [applicationLoaderPath stringByAppendingPathComponent:@"Contents/MacOS/itms/bin/iTMSTransporter"];
}

+ (void)load
{
	@autoreleasepool {
		NSDictionary *registrationDefaults = @{_RMConnecterLastPackageLocationDefaultsKey : @"~/Desktop"};
		[[NSUserDefaults standardUserDefaults] registerDefaults:registrationDefaults];
	}
}

- (id)init
{
	return [self initWithWindowNibName:@"RMConnecterWindow" owner:self];
}

- (void)windowDidLoad
{
	[super windowDidLoad];
	
	NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
	[self setOperationQueue:operationQueue];
	
	if (_RMConnecterTransporterPath() == nil) {
		[[self statusTextField] setStringValue:NSLocalizedString(@"Please install iTunes Transporter", @"Status Field Install Transporter String")];
		[self setCredentialEntryAvailability:NO];
		[self setTransporterInteractionAvailability:NO];
		
		NSAlert *alert = [[NSAlert alloc] init];
		[alert addButtonWithTitle:NSLocalizedString(@"OK", @"OK")];
		[alert addButtonWithTitle:NSLocalizedString(@"Get Xcode", "Transporter Missing Alert Get Xcode Button Label")];
		[alert setMessageText:NSLocalizedString(@"Unable to Locate iTMSTransporter", @"")];
		[alert setInformativeText:NSLocalizedString(@"Connecter requires the iTMSTransporter binary to be installed. Please install Xcode from the Mac App Store.", @"")];
		[alert beginSheetModalForWindow:[self window] completionHandler:^ (NSModalResponse returnCode) {
			if (returnCode == NSAlertSecondButtonReturn) {
				[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://itunes.apple.com/gb/app/xcode/id497799835?mt=12"]];
			}
		}];
	}
	else {
		[[self statusTextField] setStringValue:NSLocalizedString(@"Please enter your iTunes Connect credentials…", @"")];
		[self setTransporterInteractionAvailability:NO];
	};
}

#pragma mark - Actions

- (IBAction)chooseiTunesPackage:(id)sender
{
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	[openPanel setAllowsMultipleSelection:NO];
	[openPanel setCanChooseDirectories:NO];
	[openPanel setCanCreateDirectories:NO];
	[openPanel setCanChooseFiles:YES];
	[openPanel setAllowedFileTypes:@[@"itmsp"]];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString * filePath = [defaults stringForKey:_RMConnecterLastPackageLocationDefaultsKey];
	NSURL *fileURL = [NSURL fileURLWithPath:filePath];
	[openPanel setDirectoryURL:fileURL];
	
	[openPanel beginSheetModalForWindow:[self window]
					  completionHandler:^(NSInteger result) {
						  if (result == NSFileHandlingPanelCancelButton) {
							  return;
						  }
						  [[self logView] setString:@""];
						  NSURL *selectedPackageURL = [openPanel URL];
						  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
						  [defaults setObject:selectedPackageURL.path forKey:_RMConnecterLastPackageLocationDefaultsKey];
						  switch ([sender tag]) {
							  case 1:
								  [self verifyiTunesPackageAtURL:selectedPackageURL];
								  [[self statusTextField] setStringValue:[NSString stringWithFormat:NSLocalizedString(@"Verifying iTunes Package: %@", @"Verifying Package String"), selectedPackageURL.path]];
								  break;
							  case 2:
								  [self submitPackageAtURL:selectedPackageURL];
								  [[self statusTextField] setStringValue:[NSString stringWithFormat:NSLocalizedString(@"Submitting iTunes Package: %@", @"Submitting Package String"), selectedPackageURL.path]];
								  break;
							  default:
								  break;
						  }
					  }];
}

- (IBAction)selectLocationForDownloadedMetadata:(id)sender
{
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	[openPanel setAllowsMultipleSelection:NO];
	[openPanel setCanChooseDirectories:YES];
	[openPanel setCanCreateDirectories:YES];
	[openPanel setCanChooseFiles:NO];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString * filePath = [defaults stringForKey:_RMConnecterLastPackageLocationDefaultsKey];
	NSURL *fileURL = [NSURL fileURLWithPath:filePath];
	[openPanel setDirectoryURL:fileURL];
	
	[openPanel beginSheetModalForWindow:[self window]
					  completionHandler:^(NSInteger result) {
						  if (result == NSFileHandlingPanelCancelButton) {
							  return;
						  }
						  [[self logView] setString:@""];
						  NSURL *selectedPackageURL = [openPanel URL];
						  [[self statusTextField] setStringValue:[NSString stringWithFormat:NSLocalizedString(@"Retrieving package from iTunes Connect. Metadata will be downloaded to %@", "Downloaded Info String"), selectedPackageURL.path]];
						  [self lookupMetadataAndPlaceInPackageAtURL:selectedPackageURL];
					  }];
}

#pragma mark - iTunes Connect Interaction

- (void)lookupMetadataAndPlaceInPackageAtURL:(NSURL *)packageURL
{
	NSArray *arguments = @[
		@"-vendor_id", [[self iTunesConnectAppSKUField] stringValue],
		@"-destination", packageURL,
	];
	[self _enqueueiTunesConnectInteractionOperationForPackageAtURL:packageURL method:@"lookupMetadata" arguments:arguments openPackageUponTermination:YES];
}

- (void)verifyiTunesPackageAtURL:(NSURL *)packageURL
{
	NSArray *arguments = @[
		@"-f", packageURL,
	];
	[self _enqueueiTunesConnectInteractionOperationForPackageAtURL:packageURL method:@"verify" arguments:arguments openPackageUponTermination:NO];
}

- (void)submitPackageAtURL:(NSURL *)packageURL
{
	NSArray *arguments = @[
		@"-f", packageURL,
	];
	[self _enqueueiTunesConnectInteractionOperationForPackageAtURL:packageURL method:@"upload" arguments:arguments openPackageUponTermination:NO];
}

- (void)_enqueueiTunesConnectInteractionOperationForPackageAtURL:(NSURL *)packageURL method:(NSString *)method arguments:(NSArray *)arguments openPackageUponTermination:(BOOL)openPackageUponTermination
{
	NSParameterAssert(packageURL != nil);
	NSParameterAssert(method != nil);
	
	NSArray *taskArguments = @[
		@"-m", method,
		@"-u", [[self iTunesConnectUsernameField] stringValue],
		@"-p", [[self iTunesConnectPasswordField] stringValue],
	];
	taskArguments = [taskArguments arrayByAddingObjectsFromArray:arguments];
	
	[self shouldShowAndAnimateActivityIndicator:YES];
	[self setTransporterInteractionAvailability:NO];
	[self setCredentialEntryAvailability:NO];
	
	__block NSString *result = @"";
	
	NSOperation *taskOperation = [NSBlockOperation blockOperationWithBlock:^{
		NSTask *task = [[NSTask alloc] init];
		[task setLaunchPath:_RMConnecterTransporterPath()];
		[task setArguments:taskArguments];
		
		NSPipe *pipe = [NSPipe pipe];
		[task setStandardOutput:pipe];
		NSFileHandle *file = [pipe fileHandleForReading];
		
		[task launch];
		
		NSData *data = [file readDataToEndOfFile];
		result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	}];
	[[self operationQueue] addOperation:taskOperation];
	
	NSOperation *resultOperation = [NSBlockOperation blockOperationWithBlock:^{
		[self setCredentialEntryAvailability:YES];
		[self setTransporterInteractionAvailability:YES];
		[self shouldShowAndAnimateActivityIndicator:NO];
		
		[[self statusTextField] setStringValue:NSLocalizedString(@"Finished", "Finished Interacting with iTunes Connect Strings")];
		[[self logView] setString:result];
		
		if (openPackageUponTermination) {
			[[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:@[packageURL]];
		}
	}];
	[resultOperation addDependency:taskOperation];
	[[NSOperationQueue mainQueue] addOperation:resultOperation];
}

#pragma mark - Transporter Preflighting

- (void)setCredentialEntryAvailability:(BOOL)b {
	[[self iTunesConnectPasswordField] setEnabled:b];
	[[self iTunesConnectUsernameField] setEnabled:b];
}

- (void)setTransporterInteractionAvailability:(BOOL)b {
	[[self submitLocalPackageToiTunesConnectButton] setEnabled:b];
	[[self verifyLocalPackageButton] setEnabled:b];
	[[self iTunesConnectAppSKUField] setEnabled:b];
	if ([self.iTunesConnectAppSKUField.stringValue length] > 0) {
		[[self downloadPackageFromiTunesConnectButton] setEnabled:b];
	}
}

- (void)shouldShowAndAnimateActivityIndicator:(BOOL)b {
	switch (b) {
		case YES:
			[_activityQueueProgressIndicator setHidden:NO];
			[_activityQueueProgressIndicator startAnimation:self];
			break;
		default:
			[_activityQueueProgressIndicator setHidden:YES];
			
			[_activityQueueProgressIndicator stopAnimation:self];
			break;
	}
}

#pragma mark - NSTextFieldDelegate

- (void)controlTextDidChange:(NSNotification *)aNotification  {
	if (([self.iTunesConnectUsernameField.stringValue length] > 0) && ([self.iTunesConnectPasswordField.stringValue length] > 0)) {
		[self setTransporterInteractionAvailability:YES];
		[[self statusTextField] setStringValue:NSLocalizedString(@"Awaiting your command…", @"Awaiting your Command String")];
	}
	if ([self.iTunesConnectAppSKUField.stringValue length] > 0) {
		[[self downloadPackageFromiTunesConnectButton] setEnabled:YES];
	}
	
	if (([self.iTunesConnectUsernameField.stringValue length] == 0) && ([self.iTunesConnectPasswordField.stringValue length] == 0)) {
		[self setTransporterInteractionAvailability:NO];
		[[self statusTextField] setStringValue:NSLocalizedString(@"Please enter your iTunes Connect credentials…", @"Enter Credentials Prompt")];
	}
	if ([self.iTunesConnectAppSKUField.stringValue length]== 0) {
		[[self downloadPackageFromiTunesConnectButton] setEnabled:NO];
	}
}

@end
