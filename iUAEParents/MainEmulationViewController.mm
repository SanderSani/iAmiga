//
//  DOTCEmulationViewController.m
//  iAmiga
//
//  Created by Stuart Carnie on 7/11/11.
//  Copyright 2011 Manomio LLC. All rights reserved.
//

#import "MainEmulationViewController.h"
#import "VirtualKeyboard.h"
#import "IOSKeyboard.h"
#import "uae.h"

@interface MainEmulationViewController()

//- (void)startIntroSequence;

@end

@implementation MainEmulationViewController
@synthesize joyControllerMain;


UIButton *btnSettings;
IOSKeyboard *ioskeyboard;

extern void uae_reset();

- (IBAction)restart:(id)sender {
        uae_reset();
}

-(void) settings {
    SettingsController *viewController = [[SettingsController alloc] initWithNibName:@"SettingsController" bundle:nil];
    viewController.view.frame = CGRectMake(0, 0, self.screenHeight, self.screenWidth);
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *fn = [NSString stringWithFormat:@"setVersion('%@');", self.bundleVersion];
    NSString *result = [webView stringByEvaluatingJavaScriptFromString:fn];
}

- (CGFloat) screenHeight {
    CGRect screenRect = CGRectZero;
    screenRect = [[UIScreen mainScreen] bounds];
    return screenRect.size.height;
}

- (CGFloat) screenWidth {
    CGRect screenRect = CGRectZero;
    screenRect = [[UIScreen mainScreen] bounds];
    return screenRect.size.width;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    // virtual keyboard
    
	/*vKeyboard = [[VirtualKeyboard alloc] initWithFrame:CGRectMake(0, 568, 1024, 200)];
    vKeyboard.autoresizingMask = UIViewAutoresizingNone;
    vKeyboard.backgroundColor = [UIColor redColor];
	vKeyboard.hidden = YES;*/
    [self.view setMultipleTouchEnabled:TRUE];
}

- (void)initializeFullScreenPanel:(int)barwidth barheight:(int)barheight iconwidth:(int)iconwidth iconheight:(int)iconheight  {
    
    int xpos = [self XposFloatPanel:barwidth];
    
    fullscreenPanel = [[FloatPanel alloc] initWithFrame:CGRectMake(xpos,20,barwidth,barheight)];
    UIButton *btnExitFS = [[[UIButton alloc] initWithFrame:CGRectMake(0,0,iconwidth,iconheight)] autorelease];
    btnExitFS.center=CGPointMake(63, 18);
    [btnExitFS setImage:[UIImage imageNamed:@"exitfull~ipad.png"] forState:UIControlStateNormal];
    [btnExitFS addTarget:self action:@selector(toggleScreenSize) forControlEvents:UIControlEventTouchUpInside];
    [fullscreenPanel.contentView addSubview:btnExitFS];
    
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:16];
    
    btnSettings = [[[UIButton alloc] initWithFrame:CGRectMake(0,0,iconwidth,iconheight)] autorelease];
    [btnSettings setImage:[UIImage imageNamed:@"options.png"] forState:UIControlStateNormal];
    [btnSettings addTarget:self action:@selector(toggleControls:) forControlEvents:UIControlEventTouchUpInside];
    [items addObject:btnSettings];
    
    btnKeyboard = [[[UIButton alloc] initWithFrame:CGRectMake(0,0,iconwidth,iconheight)] autorelease];
    [btnKeyboard setImage:[UIImage imageNamed:@"modekeyoff.png"] forState:UIControlStateNormal];
    [btnKeyboard setImage:[UIImage imageNamed:@"modekeyon.png"] forState:UIControlStateSelected];
    [btnKeyboard addTarget:self action:@selector(toggleControls:) forControlEvents:UIControlEventTouchUpInside];
    [items addObject:btnKeyboard];
    
    btnJoypad = [[[UIButton alloc] initWithFrame:CGRectMake(0,0,iconwidth,iconheight)] autorelease];
    [btnJoypad setImage:[UIImage imageNamed:@"modejoy.png"] forState:UIControlStateNormal];
    [btnJoypad setImage:[UIImage imageNamed:@"modejoypressed.png"] forState:UIControlStateSelected];
    [btnJoypad addTarget:self action:@selector(toggleControls:) forControlEvents:UIControlEventTouchUpInside];
    [items addObject:btnJoypad];
    
    [fullscreenPanel setItems:items];
    
    [self.view addSubview:fullscreenPanel];
    [fullscreenPanel showContent];
}

-(void)initializeJoypad:(InputControllerView *)joyController {
    joyControllerMain = joyController;
    self.joyControllerMain.hidden = TRUE;
    joyactive = FALSE;
}

- (CGFloat) XposFloatPanel:(int)barwidth {
    CGRect screenRect = CGRectZero;
    screenRect = [[UIScreen mainScreen] bounds];
    //CGFloat screenHeight = screenRect.size.height;
    
    CGFloat result = (self.screenHeight / 2) - (barwidth/2);
    
    return result;
}

- (IBAction)toggleControls:(id)sender {
    
    bool keyboardactiveonstart = keyboardactive;
    
    UIButton *button = (UIButton *) sender;
    
    keyboardactive = (button == btnKeyboard) ? !keyboardactive : FALSE;
    joyactive = (button == btnJoypad) ? !joyactive : FALSE;
    
    btnKeyboard.selected = (button == btnKeyboard) ? !btnKeyboard.selected : FALSE;
    btnJoypad.selected = (button == btnJoypad) ? !btnJoypad.selected : FALSE;
    
    joyControllerMain.hidden = !joyactive;
    mouseHandlermain.hidden = joyactive;
    
    if (keyboardactive != keyboardactiveonstart) { [ioskeyboard toggleKeyboard]; }
        
    if (button == btnSettings) { [self settings]; }
    
}

- (void) initializeKeyboard:(UITextField *)p_dummy_textfield dummytextf:p_dummy_textfield_f {
    
    keyboardactive = FALSE;
    
    ioskeyboard = [[IOSKeyboard alloc] initWithDummyFields:p_dummy_textfield fieldf:p_dummy_textfield_f];
    
    [[NSNotificationCenter defaultCenter]   addObserver:self
                                               selector:@selector(keyboardDidHide:)
                                                   name:UIKeyboardDidHideNotification
                                                 object:nil];
}

@end
