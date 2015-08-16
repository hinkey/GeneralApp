#import <Foundation/Foundation.h>
#import "CHTTPOperation.h"

@protocol CHTTPDownloaderDelegate <NSObject>

@required
- (void)downloaderDidFinished:(int)tag status:(CHTTPStatus *)status data:(NSData *)data;

@optional
- (void)downloaderDidReceivedData:(int)tag data:(NSData *)data receivedLength:(long long)length expectedLength:(long long)length;

@end

@interface CHTTPDownloader : NSObject

// Create instance
+ (CHTTPDownloader *)create;

/*
 * For block mode
 */

// Return local path of file if the file exsits, block style.
+ (NSString *)downloadImage:(NSString *)url callback:(CHTTPCallback)callback;

// Return local path of file if the file exsits, block style with recevied data.
+ (NSString *)downloadImage:(NSString *)url recevied:(CHTTPReceivedDataCallback)recevied callback:(CHTTPCallback)callback;

// Return local path of file if the file exsits, block style.
+ (NSString *)download:(NSString *)url callback:(CHTTPCallback)callback;

// Return local path of file if the file exsits, block style with recevied data.
+ (NSString *)download:(NSString *)url recevied:(CHTTPReceivedDataCallback)recevied callback:(CHTTPCallback)callback;

/*
 * For delegate mode
 */

// For UIImageView+UAExtention
- (NSString *)downloadImage:(NSString *)url delegate:(id)delegate tag:(int)tag;

// Return local path of file if the file exsits, delegate style.
- (NSString *)download:(NSString *)url delegate:(id)delegate tag:(int)tag;

// Cancel the operation with url
- (void)cancelDownload:(int)tag;

/*
 * For all
 */

// Cancel the operation with url
+ (void)cancelDownloadWith:(NSString *)url;

// Cancel the operation with url
+ (void)cancelAllDownloads;


@end
