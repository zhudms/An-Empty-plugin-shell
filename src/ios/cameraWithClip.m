/********* cameraWithClip.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>

#import "FileHelper.h"

#import "PureCamera.h"
#import "TOCropViewController.h"
#import "ImageHelper.h"


@interface cameraWithClip : CDVPlugin<cameraCancelDelegate> {
    // Member variables go here.
}


@property (nonatomic, strong) PureCamera *cameraVC;
@property (nonatomic, strong)  UIImageView *imgeView;

- (void)takePic:(CDVInvokedUrlCommand*)command;
- (void)prepare;

@end

@implementation cameraWithClip

UIWindow *window;
NSString* callbackId;

NSString *picName;
FileHelper *helper;
NSString *picPath;
@synthesize cameraVC;


int cameraType=0；//拍照：1； 在图库中选图：2
int maxNumb=0;//取值范围>=1 需要选取几张照片，当cameraType==1（拍照模式时），此参数无效
int needCut=0;//不需裁剪：1；需要裁剪：2

- (void)takePic:(CDVInvokedUrlCommand*)command
{
    
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
    
    [self getPremission];
    //    [self showTakePicView];
}




-(void)showTakePicView{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        cameraVC = [[PureCamera alloc] init];
        cameraVC.cancelDelegate=self;
        
        __weak typeof(self) myself = self;
        cameraVC.fininshcapture = ^(UIImage *ss) {
            if (ss) {
                NSLog(@"照片存在");
                //                myself.Kimageview.image = ss;
                ImageHelper *imageHelper=[[ImageHelper alloc]init];
                if(imageHelper){
                    ss=[imageHelper fixOrientation:ss];
                    
                }
                
                FileHelper *helper=[[FileHelper alloc  ]init];
                if (helper) {
                    NSString *path= [helper savePic:ss withName:picName ByType:PATH_ID ifClear:true];
                    if (path) {
                        [self sendPicResult:CDVCommandStatus_OK withMessage:path];
                    }
                    
                }
                
            }else{
                [self sendPicResult:CDVCommandStatus_ERROR withMessage:@"获取照片失败"];
            }
        };
        //        [self sendPicResult:<#(CDVCommandStatus)#> withMessage:<#(NSString *)#>];
        
        
        
        //        [myself presentViewController:homec
        //                             animated:NO
        //                           completion:^{
        //                           }];
    } else {
        NSLog(@"相机调用失败");
        [self sendPicResult:CDVCommandStatus_ERROR withMessage:@"相机调用失败"];
    }
    
    //    self.cameraViewvController = [[CameraViewController alloc] init];
    //    self.cameraViewvController.delegate = self;
    //    self.cameraViewvController.cancelDelegate=self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.cameraVC];
    [navigationController setNavigationBarHidden:YES];
    [window.rootViewController presentViewController:navigationController animated:YES completion:nil];
}

//检查相机权限
-(Boolean)getPremission{
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        NSString *errorStr = @"应用获取相机权限失败,请在设置中启用";
        NSLog(@"%@",errorStr);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"应用获取相机权限失败,请在设置中启用" preferredStyle: UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //点击确认后需要做的事
            [self sendPicResult:CDVCommandStatus_ERROR withMessage:@"应用获取相机权限失败,请在设置中启用"];
        }]];
        [self.viewController presentViewController:alert animated:YES completion:nil];
        
    }else{
        [self showTakePicView];
    }
    
    
}

-(void)pureCameraCancel{
    NSLog(@"camera is canceled");
    
}

//返回结果
-(void)sendPicResult:(CDVCommandStatus)status withMessage:(NSString*) result {
    
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:status messageAsString:result];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
    
}


@end
