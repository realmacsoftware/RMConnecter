//
//  RMAddLocaleWindowController.m
//  Connecter
//
//  Created by Markus on 26.02.14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import "RMAppVersion.h"
#import "RMAppLocale.h"

#import "RMAddLocaleWindowController.h"

NSString *const RMAddLocaleSelectionVersionKeyPath = @"versionsController.selectedObjects";

@interface RMAddLocaleWindowController ()
@property (nonatomic, strong) IBOutlet NSArrayController *versionsController;
@property (nonatomic, strong) IBOutlet NSArrayController *filterLocalesController;
@property (nonatomic, strong) NSArray *filteredLocales;
@property (nonatomic, readonly) NSArray *allLocales;
@end

@implementation RMAddLocaleWindowController

@synthesize allLocales = _allLocales;

- (id)init
{
    return [super initWithWindowNibName:NSStringFromClass([self class]) owner:self];
}

- (id)initWithMetaData:(RMAppMetaData *)metaData;
{
    self = [self init];
    if (self) {
        _metaData = metaData;
    }
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:RMAddLocaleSelectionVersionKeyPath];
}

- (void)windowDidLoad;
{
    [super windowDidLoad];
    [self addObserver:self forKeyPath:RMAddLocaleSelectionVersionKeyPath
              options:NSKeyValueObservingOptionInitial context:nil];
}

#pragma mark actions

- (IBAction)cancel:(id)sender;
{
    [self.window.sheetParent endSheet:self.window
                           returnCode:NSModalResponseCancel];
}

- (IBAction)addLocale:(id)sender;
{
    RMAppVersion *selectedVersion = [[self.versionsController selectedObjects] firstObject];
    RMAppLocale *selectedLocale = [[self.filterLocalesController selectedObjects] firstObject];
    if ([selectedLocale isKindOfClass:[RMAppLocale class]]) {
        [selectedVersion addLocale:selectedLocale];
    }
    
    [self.window.sheetParent endSheet:self.window
                           returnCode:NSModalResponseOK];
}

#pragma mark locales logic

- (NSArray *)allLocales;
{
    if (!_allLocales) {
        // based on App Metadata Specification 5.1 Revision 1
        NSArray *allLocales = @[@"cmn-Hans",@"cmn-Hant",@"da",@"nl",@"en-AU",
                                @"en-CA",@"en-GB",@"en-US",@"fi",@"fr-CA",
                                @"fr-FR",@"de-DE",@"el",@"id",@"it",@"ja",@"ko",
                                @"ms",@"no",@"pt-BR",@"pt-PT",@"ru",@"es-MX",
                                @"es-ES",@"sv",@"th",@"tr",@"vi"];
        _allLocales = [allLocales sortedArrayUsingSelector:@selector(compare:)];
    }
    return _allLocales;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
{
    if (object != self || ![keyPath isEqualToString:RMAddLocaleSelectionVersionKeyPath]) return;
    
    NSMutableArray *locales = [[self allLocales] mutableCopy];
    if ([self.versionsController.selectedObjects count] > 0) {
        RMAppVersion *version = [[self.versionsController selectedObjects] firstObject];
        for (RMAppLocale *locale in version.activeLocales) {
            [locales removeObject:locale.localeName];
            [locales removeObject:[locale.localeName substringToIndex:2]];
        }
    }
    
    NSMutableArray *localeObjects = [NSMutableArray array];
    [locales enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        RMAppLocale *locale = [[RMAppLocale alloc] init];
        locale.localeName = obj;
        [localeObjects addObject:locale];
    }];
    
    self.filteredLocales = [localeObjects copy];
}

@end
