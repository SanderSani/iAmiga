//
//  Settings.m
//  iUAE
//
//  Created by Emufr3ak on 08.03.15.
//
//  iUAE is free software: you may copy, redistribute
//  and/or modify it under the terms of the GNU General Public License as
//  published by the Free Software Foundation, either version 2 of the
//  License, or (at your option) any later version.
//
//  This file is distributed in the hope that it will be useful, but
//  WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
//  General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

#import "uae.h"
#import "sysconfig.h"
#import "sysdeps.h"
#import "options.h"
#import "SDL.h"
#import "UIKitDisplayView.h"
#import "savestate.h"
#import "JoypadKey.h"

#import "Settings.h"

static NSString *const kAppSettingsInitializedKey = @"appvariableinitialized";
static NSString *const kInitializeKey = @"_initialize";
static NSString *const kConfigurationNameKey = @"configurationname";
static NSString *const kConfigurationsKey = @"configurations";
static NSString *const kAutoloadConfigKey = @"autoloadconfig";
static NSString *const kInsertedFloppiesKey = @"insertedfloppies";

static NSString *const kNtscKey = @"_ntsc";
static NSString *const kStretchScreenKey = @"_stretchscreen";
static NSString *const kShowStatusKey = @"_showstatus";
static NSString *const kShowStatusBarKey = @"_showstatusbar";
static NSString *const kSelectedEffectIndexKey = @"_selectedeffectindex";
static NSString *const kJoypadStyleKey = @"_joypadstyle";
static NSString *const kJoypadLeftOrRightKey = @"_joypadleftorright";
static NSString *const kJoypadShowButtonTouchKey = @"_joypadshowbuttontouch";

static NSString *const kJoypadButtonkey = @"_BTN_";

static NSString *const kDf1EnabledKey = @"df1Enabled";
static NSString *const kDf2EnabledKey = @"df2Enabled";
static NSString *const kDf3EnabledKey = @"df3Enabled";

extern int mainMenu_showStatus;
extern int mainMenu_ntsc;
extern int mainMenu_stretchscreen;
extern int joystickselected;

static NSString *configurationname;

@implementation Settings {
    NSUserDefaults *defaults;
}

- (id)init {
    if (self = [super init]) {
        defaults = [[NSUserDefaults standardUserDefaults] retain];
    }
    return self;
}

- (BOOL)initializeSettings {
    BOOL isFirstInitialization = [self initializeCommonSettings];
    [self initializespecificsettings];
    return isFirstInitialization;
}

- (BOOL)initializeCommonSettings {
    
    configurationname = [[defaults stringForKey:kConfigurationNameKey] retain];
    
    BOOL isFirstInitialization = ![defaults boolForKey:kAppSettingsInitializedKey];
    
    if(isFirstInitialization)
    {
        [defaults setBool:TRUE forKey:kAppSettingsInitializedKey];
        self.autoloadConfig = FALSE;
        self.driveState = [DriveState getAllEnabled];
        [defaults setObject:@"General" forKey:kConfigurationNameKey];
    }
    return isFirstInitialization;
}

- (void)setFloppyConfigurations:(NSArray *)adfPaths {
    for (NSString *adfPath : adfPaths)
    {
        [self setFloppyConfiguration:adfPath];
    }
}

- (void)setFloppyConfiguration:(NSString *)adfPath {
    NSString *settingstring = [NSString stringWithFormat:@"cnf%@", [adfPath lastPathComponent]];
    if ([defaults stringForKey:settingstring])
    {
        [configurationname release];
        configurationname = [[defaults stringForKey:settingstring] retain];
        [defaults setObject:configurationname forKey:kConfigurationNameKey];
    }
}

#define BTN_A 0
#define BTN_B 1
#define BTN_X 2
#define BTN_Y 3
#define BTN_L1 5
#define BTN_L2 7
#define BTN_R1 4
#define BTN_R2 6
#define BTN_UP 9
#define BTN_DOWN 10
#define BTN_LEFT 11
#define BTN_RIGHT 12

- (void)initializespecificsettings {
    if(![self boolForKey:kInitializeKey])
    {
        self.ntsc = mainMenu_ntsc;
        self.stretchScreen = mainMenu_stretchscreen;
        self.showStatus = mainMenu_showStatus;
        self.showStatusBar = YES;
        self.selectedEffectIndex = 0;
        self.joypadstyle = @"FourButton";
        self.joypadleftorright = @"Right";
        self.joypadshowbuttontouch = true;
        
        [self setKeyconfiguration:@"Joypad" Button:BTN_A];
        [self setKeyconfiguration:@"Joypad" Button:BTN_B];
        [self setKeyconfiguration:@"Joypad" Button:BTN_X];
        [self setKeyconfiguration:@"Joypad" Button:BTN_Y];
        [self setKeyconfiguration:@"Joypad" Button:BTN_L1];
        [self setKeyconfiguration:@"Joypad" Button:BTN_L2];
        [self setKeyconfiguration:@"Joypad" Button:BTN_R1];
        [self setKeyconfiguration:@"Joypad" Button:BTN_R2];
        [self setKeyconfiguration:@"Joypad" Button:BTN_UP];
        [self setKeyconfiguration:@"Joypad" Button:BTN_DOWN];
        [self setKeyconfiguration:@"Joypad" Button:BTN_LEFT];
        [self setKeyconfiguration:@"Joypad" Button:BTN_RIGHT];
        
        [self setKeyconfigurationname:@"Joypad" Button:BTN_A];
        [self setKeyconfigurationname:@"Joypad" Button:BTN_B];
        [self setKeyconfigurationname:@"Joypad" Button:BTN_X];
        [self setKeyconfigurationname:@"Joypad" Button:BTN_Y];
        [self setKeyconfigurationname:@"Joypad" Button:BTN_L1];
        [self setKeyconfigurationname:@"Joypad" Button:BTN_L2];
        [self setKeyconfigurationname:@"Joypad" Button:BTN_R1];
        [self setKeyconfigurationname:@"Joypad" Button:BTN_R2];
        [self setKeyconfigurationname:@"Joypad" Button:BTN_UP];
        [self setKeyconfigurationname:@"Joypad" Button:BTN_DOWN];
        [self setKeyconfigurationname:@"Joypad" Button:BTN_LEFT];
        [self setKeyconfigurationname:@"Joypad" Button:BTN_RIGHT];
        
        [self setBool:TRUE forKey:kInitializeKey];
    }
    else
    {
        mainMenu_ntsc = self.ntsc;
        mainMenu_stretchscreen = self.stretchScreen;
        mainMenu_showStatus = self.showStatus;
    }
}

- (BOOL)autoloadConfig {
    return [self boolForKey:kAutoloadConfigKey];
}

- (void)setAutoloadConfig:(BOOL)autoloadConfig {
    [self setBool:autoloadConfig forKey:kAutoloadConfigKey];
}

- (NSArray *)insertedFloppies {
    return [self arrayForKey:kInsertedFloppiesKey];
}

- (void)setInsertedFloppies:(NSArray *)insertedFloppies {
    [self setObject:insertedFloppies forKey:kInsertedFloppiesKey];
}

- (BOOL)ntsc {
    return [self boolForKey:kNtscKey];
}

- (void)setNtsc:(BOOL)ntsc {
    [self setBool:ntsc forKey:kNtscKey];
}

- (BOOL)stretchScreen {
    return [self boolForKey:kStretchScreenKey];
}

- (void)setStretchScreen:(BOOL)stretchScreen {
    [self setBool:stretchScreen forKey:kStretchScreenKey];
}

- (BOOL)showStatus {
    return [self boolForKey:kShowStatusKey];
}

- (void)setShowStatus:(BOOL)showStatus {
    [self setBool:showStatus forKey:kShowStatusKey];
}

- (NSString *)joypadstyle {
    return [self stringForKey:kJoypadStyleKey];
}

- (void)setJoypadstyle:(NSString *)joypadstyle {
    [self setObject:joypadstyle forKey:kJoypadStyleKey];
}

- (NSString *)joypadleftorright {
    return [self stringForKey:kJoypadLeftOrRightKey];
}

- (void)setJoypadleftorright:(NSString *)joypadleftorright {
    [self setObject:joypadleftorright forKey:kJoypadLeftOrRightKey];
}

- (BOOL)joypadshowbuttontouch {
    return [self boolForKey:kJoypadShowButtonTouchKey];
}

-(void)setJoypadshowbuttontouch:(BOOL)joypadshowbuttontouch {
    [self setBool:joypadshowbuttontouch forKey:kJoypadShowButtonTouchKey];
}

-(void)setKeyconfiguration:(NSString *)configuredkey Button:(int)button {
    [self setObject:configuredkey forKey:[NSString stringWithFormat:@"_BTN_%d", button]];
}

-(void)setKeyconfigurationname:(NSString *)configuredkey Button:(int)button {
    [self setObject:configuredkey forKey:[NSString stringWithFormat:@"_BTNN_%d", button]];
}

- (BOOL)showStatusBar {
    return [self boolForKey:kShowStatusBarKey];
}

- (void)setShowStatusBar:(BOOL)showStatusBar {
    [self setBool:showStatusBar forKey:kShowStatusBarKey];
}

- (NSUInteger)selectedEffectIndex {
    return [self integerForKey:kSelectedEffectIndexKey];
}

- (void)setSelectedEffectIndex:(NSUInteger)selectedEffectIndex {
    return [self setInteger:selectedEffectIndex forKey:kSelectedEffectIndexKey];
}

- (NSString *)configurationName {
    return [self stringForKey:kConfigurationNameKey];
}

- (void)setConfigurationName:(NSString *)configurationName {
    [self setObject:configurationName forKey:kConfigurationNameKey];
}

- (NSArray *)configurations {
    return [self arrayForKey:kConfigurationsKey];
}

- (void)setConfigurations:(NSArray *)configurations {
    [self setObject:configurations forKey:kConfigurationsKey];
}

- (DriveState *)driveState {
    DriveState *driveState = [[[DriveState alloc] init] autorelease];
    driveState.df1Enabled = [self boolForKey:kDf1EnabledKey];
    driveState.df2Enabled = [self boolForKey:kDf2EnabledKey];
    driveState.df3Enabled = [self boolForKey:kDf3EnabledKey];
    return driveState;
}

- (void)setDriveState:(DriveState *)driveState {
    [self setBool:driveState.df1Enabled forKey:kDf1EnabledKey];
    [self setBool:driveState.df2Enabled forKey:kDf2EnabledKey];
    [self setBool:driveState.df3Enabled forKey:kDf3EnabledKey];
}

- (void)setBool:(BOOL)value forKey:(NSString *)settingitemname {
    [defaults setBool:value forKey:[self getInternalSettingKey:settingitemname]];
}

- (void)setObject:(id)value forKey:(NSString *)settingitemname {
    [defaults setObject:value forKey:[self getInternalSettingKey:settingitemname]];
}

- (bool)boolForKey:(NSString *)settingitemname {
    return [defaults boolForKey:[self getInternalSettingKey:settingitemname]];
}
         
- (NSString *)stringForKey:(NSString *)settingitemname {
    return [defaults stringForKey:[self getInternalSettingKey:settingitemname]];
}

- (void)setInteger:(NSInteger)value forKey:(NSString *)settingitemname {
    [defaults setInteger:value forKey:[self getInternalSettingKey:settingitemname]];
}

- (NSInteger)integerForKey:(NSString *)settingitemname {
    return [defaults integerForKey:[self getInternalSettingKey:settingitemname]];
}

- (NSArray *)arrayForKey:(NSString *)settingitemname {
    return [defaults arrayForKey:[self getInternalSettingKey:settingitemname]];
}

- (void)removeObjectForKey:(NSString *) settingitemname {
    [defaults removeObjectForKey:[self getInternalSettingKey:settingitemname]];
}

- (NSString *)getInternalSettingKey:(NSString *)name {
    // if name starts with '_', the setting is stored in its own configuration
    return [name hasPrefix:@"_"] ? [NSString stringWithFormat:@"%@%@", configurationname, name] : name;
}

- (NSString *)configForDisk:(NSString *)diskName {
    NSString *settingstring = [NSString stringWithFormat:@"cnf%@", diskName];
    return [defaults stringForKey:settingstring];
}

- (void)setConfig:(NSString *)configName forDisk:(NSString *)diskName {
    
    NSString *configstring = [NSString stringWithFormat:@"cnf%@", diskName];
    
    if([configName isEqual:@"None"])
    {
        if([self configForDisk:diskName])
        {
            [defaults setObject:nil forKey:configstring];
        }
    }
    else
    {
        [defaults setObject:configName forKey:configstring];
    }
}

- (void)dealloc {
    [defaults release];
    defaults = nil;
    [super dealloc];
}
         
@end