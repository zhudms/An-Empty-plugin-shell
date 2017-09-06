/********* cameraWithClip.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>

#import "FileHelper.h"


@interface cameraWithClip : CDVPlugin {
    // Member variables go here.
}

- (void)takePic:(CDVInvokedUrlCommand*)command;
- (void)prepare;
@end

@implementation cameraWithClip

UIWindow *window;
NSString* callbackId;

NSString *picName;
FileHelper *helper;
NSString *picPath;

- (void)takePic:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* echo = [command.arguments objectAtIndex:0];
    
    if (echo != nil && [echo length] > 0) {
        callbackId=command.callbackId;
        [self prepare];
        // pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
    } else {
        // pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        // [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
    
    
}

-(void)prepare{
    window = [UIApplication sharedApplication].delegate.window;
    picName=[NSString stringWithFormat:@"%@%@",[FileHelper getCurrentTimeString],IDFileName];
    picPath=[helper getFilePath:picName withParentType:PATH_ID clearParent:true];
    
}

@end
