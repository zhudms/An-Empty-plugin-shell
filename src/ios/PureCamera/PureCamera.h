/*!
 @abstract

 */
#import <UIKit/UIKit.h>
#import "cameraCancelDelegate.h"

typedef void (^fininshcapture)(UIImage *image);
@interface PureCamera : UIViewController
@property (nonatomic,copy) fininshcapture fininshcapture;
@property (nonatomic, weak)id<cameraCancelDelegate> cancelDelegate;


@end
