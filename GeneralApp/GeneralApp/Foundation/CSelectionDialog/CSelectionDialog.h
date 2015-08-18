#import <UIKit/UIKit.h>

@class CSelectionDialog;
@protocol CSelectionDialogDelegate <NSObject>

@required

- (void)selectionDialogCallback:(CSelectionDialog *)view;

@end

@interface CSelectionDialog : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, retain) NSArray *dataList;   // Item is NSString
@property (nonatomic, strong) NSArray *indexArray;
@property (nonatomic, assign) BOOL multiple;       // Default is NO
@property (nonatomic, assign) id<CSelectionDialogDelegate> delegate;

- (void)showInView:(UIView *)view;

@end
