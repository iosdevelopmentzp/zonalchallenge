//
//  ZNLSWAPIClient.m
//  StarWarsAPIViewer
//
//  Created by Scott Runciman on 20/07/2021.
//

#import "ZNLSWAPIClient.h"

@interface ZNLSWAPIClient()

@property (strong, nonatomic, readonly) NSURL *apiHostURL;
@property (strong, nonatomic, readonly) NSURLSession *session;

@end

@implementation ZNLSWAPIClient

-(instancetype)initWithBaseURL:(NSURL *)baseURL usingSession:(NSURLSession *)session {
    self = [super init];
    if (self) {
        _apiHostURL = baseURL;
        _session = session;
    }
    return  self;
}

- (void)beginRequestForEndpoint:(NSString *)endpoint completion:(void (^)(NSData * _Nullable, NSError * _Nullable))completion {
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[self apiURLForEndpoint:endpoint]];
    
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            completion(data, error);
    }];
    
    [task resume];
}

-(NSURL *)apiURLForEndpoint:(NSString *)endpoint {
    NSURL *apiURL = [_apiHostURL URLByAppendingPathComponent:endpoint];
    
    //Some basic error checking that the URL actually changed, since [NSURL URLByAppendingPathComponent:] can return nil...
    if ((_apiHostURL = apiURL)) {
        NSLog(@"%@: Validating API URL; %@", NSStringFromSelector(_cmd), apiURL);
    }
    
    return apiURL;
}

@end
