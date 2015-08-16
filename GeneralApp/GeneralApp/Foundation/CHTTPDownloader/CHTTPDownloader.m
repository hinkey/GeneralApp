#import "CHTTPDownloader.h"
#import "COperationCache.h"
#import "NSString+UAExtension.h"
#import "Constants.h"

@interface CHTTPDownloader () <CHTTPRequestDelegate>
{
    __weak id _delegate;
    NSString *_urlOfFile;
    long long _lengthOfTempFile;
}

@end

@implementation CHTTPDownloader

+ (CHTTPDownloader *)create
{
    return [[CHTTPDownloader alloc]init];
}

- (id)init
{
    self = [super init];
    if (self) {
        // Caches directory
        [self createCachesDirectory];
    }
    
    return self;
}

- (void)dealloc
{
    NSLog(@"CHTTPDownloader dealloc");
}

#pragma mark - Methods

+ (NSString *)downloadImage:(NSString *)url callback:(CHTTPCallback)callback
{
    return [[self create]download:url type:CHTTPTypeImage recevied:NULL callback:callback];
}

+ (NSString *)downloadImage:(NSString *)url recevied:(CHTTPReceivedDataCallback)recevied callback:(CHTTPCallback)callback
{
    return [[self create]download:url type:CHTTPTypeImage recevied:recevied callback:callback];
}

+ (NSString *)download:(NSString *)url callback:(CHTTPCallback)callback
{
    return [[self create]download:url recevied:NULL callback:callback];
}

+ (NSString *)download:(NSString *)url recevied:(CHTTPReceivedDataCallback)recevied callback:(CHTTPCallback)callback
{
    return [[self create]download:url recevied:recevied callback:callback];
}

- (NSString *)downloadImage:(NSString *)url delegate:(id)delegate tag:(int)tag
{
    return [self download:url delegate:delegate type:CHTTPTypeImage tag:tag];
}

- (NSString *)download:(NSString *)url delegate:(id)delegate tag:(int)tag
{
    return [self download:url delegate:delegate type:CHTTPTypeDownload tag:tag];
}

- (void)cancelDownload:(int)tag
{
    NSArray *operations = [COperationCache operationWith:CHTTPTypeDownload];
    for (CHTTPOperation *operation in operations) {
        if (operation.delegate == self && operation.tag == tag) {
            [operation cancel];
        }
    }
}

- (NSString *)download:(NSString *)url delegate:(id)delegate type:(CHTTPType)type tag:(int)tag
{
    _urlOfFile = url;
    
    if ([self checkLocalFile:[self localPathOfFile]]) {
        return [self localPathOfFile];
    } else {
        _lengthOfTempFile = 0;
        BOOL temp = [self checkLocalFile:[self localPathOfTempFile]];
        if (temp) {
            _lengthOfTempFile = [self sizeOfLocalFile:[self localPathOfTempFile]];
        }
        
        // Download the file
        _delegate = delegate;
        
        // Add to operation queue
        NSMutableURLRequest *mrequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
        NSString* rangeHeader = [NSString stringWithFormat:@"bytes=%@-", [NSNumber numberWithLongLong:_lengthOfTempFile]];
        [mrequest setValue:rangeHeader forHTTPHeaderField:@"Range"];
        
        CHTTPOperation *operation = [[CHTTPOperation alloc]initWithRequest:mrequest delegate:self tag:tag];
        operation.type = type;
        [operation setTimeout:30];
        [operation setRetryTimes:0];
        [operation setRetryTimeInterval:0];
        
        // Cache
        [COperationCache addOperation:operation];
    }
    
    return nil;
}

- (NSString *)download:(NSString *)url recevied:(CHTTPReceivedDataCallback)recevied callback:(CHTTPCallback)callback
{
    return [self download:url type:CHTTPTypeDownload recevied:recevied callback:callback];
}

- (NSString *)download:(NSString *)url type:(CHTTPType)type recevied:(CHTTPReceivedDataCallback)recevied callback:(CHTTPCallback)callback
{
    _urlOfFile = url;
    
    if ([self checkLocalFile:[self localPathOfFile]]) {
        return [self localPathOfFile];
    } else {
        _lengthOfTempFile = 0;
        BOOL temp = [self checkLocalFile:[self localPathOfTempFile]];
        if (temp) {
            _lengthOfTempFile = [self sizeOfLocalFile:[self localPathOfTempFile]];
        }
        
        // Add to operation queue
        NSMutableURLRequest *mrequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
        NSString* rangeHeader = [NSString stringWithFormat:@"bytes=%@-", [NSNumber numberWithLongLong:_lengthOfTempFile]];
        [mrequest setValue:rangeHeader forHTTPHeaderField:@"Range"];
        
        CHTTPOperation *operation = [[CHTTPOperation alloc]initWithRequest:mrequest
                                                                  response:^(CHTTPStatus *status)
                                     {
                                         if (status.code != CHTTPCodePartialContent) {
                                             // No Resume
                                             [self removeTempFile];
                                         }
                                     } recevied:^(id data, long long rl, long long el) {
                                         if (recevied) {
                                             recevied(data, rl + _lengthOfTempFile, el + _lengthOfTempFile);
                                         }
                                         
                                         // Saved to local file
                                         [self writeToFileWith:data path:[self localPathOfTempFile]];
                                     } callback:^(CHTTPStatus *status, id data) {
                                         NSString *tpath = [self localPathOfTempFile];
                                         NSString *path = [self localPathOfFile];
                                         
                                         // Rename
                                         [self renameFile:path old:tpath];
                                         
                                         if (callback) {
                                             callback(status, data);
                                         }
                                     }];
        [operation setType:type];
        [operation setTimeout:30];
        [operation setRetryTimes:0];
        [operation setRetryTimeInterval:0];
        [COperationCache addOperation:operation];
    }
    return nil;
}

// Cancel the operation with tag
+ (void)cancelDownloadWith:(NSString *)url
{
    if (!url || url.length == 0) {
        return;
    }
    
    NSArray *operations = [COperationCache operationWith:CHTTPTypeDownload];
    for (CHTTPOperation *operation in operations) {
        if ([operation.request.URL.absoluteString isEqualToString:url]) {
            [operation cancel];
        }
    }
}

+ (void)cancelAllDownloads
{
    NSArray *operations = [COperationCache operationWith:CHTTPTypeDownload];
    for (CHTTPOperation *operation in operations) {
        [operation cancel];
    }
}

- (BOOL)createCachesDirectory
{
    NSString *path = [self directoryPath];
    NSFileManager *fm = [NSFileManager defaultManager];
    return [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
}

- (BOOL)checkLocalFile:(NSString *)path
{
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

- (NSString *)directoryPath
{
    return cacheDirectoryPath();
}

- (NSString *)localPathOfFile
{
    NSString *name = [_urlOfFile MD5String];
    name = [name stringByAppendingString:@".cache"];
    
    NSString *path = [self directoryPath];
    path = [path stringByAppendingPathComponent:name];
    
    return path;
}

- (NSString *)localPathOfTempFile
{
    NSString *name = [_urlOfFile MD5String];
    name = [name stringByAppendingString:@".$cache$"];
    
    NSString *path = [self directoryPath];
    path = [path stringByAppendingPathComponent:name];
    
    return path;
}

- (void)removeFile
{
    remove([[self localPathOfFile] UTF8String]);
}

- (void)removeTempFile
{
    remove([[self localPathOfTempFile] UTF8String]);
}

- (void)writeToFileWith:(NSData *)data path:(NSString *)path
{
    // Write to file
    FILE *file = fopen([path UTF8String], "ab+");
    if(file != NULL) {
        fseek(file, 0, SEEK_END);
        fwrite((const void*)[data bytes], [data length], 1, file);
    }
    fclose(file);
    file = NULL;
}

- (void)renameFile:(NSString *)newname old:(NSString *)oldname
{
    rename([oldname UTF8String], [newname UTF8String]);
}

- (long long)sizeOfLocalFile:(NSString *)path
{
    long long size = 0;
    FILE* file = fopen([path UTF8String], "r");
    if(file != NULL) {
        fseek(file, 0, SEEK_END);
        size = ftell(file);
    }
    fclose(file);
    file = NULL;
    
    return size;
}

#pragma mark - CHTTPRequestDelegate

- (void)requestDidReceviedResponseCallback:(CHTTPStatus *)status
{
    if (status.code != CHTTPCodePartialContent) {
        // No Resume
        [self removeTempFile];
    }
}

- (void)requestDidReceviedDataCallback:(int)tag data:(id)data receivedLength:(long long)rlength expectedLength:(long long)elength
{
    if (_delegate && [_delegate respondsToSelector:@selector(downloaderDidReceivedData:data:receivedLength:expectedLength:)]) {
        [_delegate downloaderDidReceivedData:tag data:data receivedLength:rlength + _lengthOfTempFile expectedLength:elength + _lengthOfTempFile];
    }
    
    // Saved to local file
    [self writeToFileWith:data path:[self localPathOfTempFile]];
}

- (void)requestFinishedCallback:(int)tag status:(CHTTPStatus *)status data:(id)data
{
    // Rename
    NSString *tpath = [self localPathOfTempFile];
    NSString *path = [self localPathOfFile];
    
    // Rename
    [self renameFile:path old:tpath];
    
    if (_delegate && [_delegate respondsToSelector:@selector(downloaderDidFinished:status:data:)]) {
        [_delegate downloaderDidFinished:tag status:status data:data];
    }
}

@end