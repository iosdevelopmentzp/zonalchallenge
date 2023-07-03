//
//  ZNLSWAPIClient.h
//  StarWarsAPIViewer
//
//  Created by Scott Runciman on 20/07/2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZNLSWAPIClient : NSObject

/// Creates an instance of `ZNLSWAPIClient` which can be used to perform API requests against the SWAPI
/// @param baseURL The host URL for the API, which will be used for all requests initiated from this instance
/// @param session The `NSURLSession` on which all requests which be performed
-(instancetype)initWithBaseURL:(NSURL *)baseURL usingSession: (NSURLSession *)session;

/// Requests data from the SWAPI. Important to note is that no validation of data, or the response from the API is performed here. It is the responsibility of the caller to validate the data is appropriate
/// @param endpoint The endpoint to contact. This will be appended, using usual URL formatting rules, to the `baseURL` provided in `initWithBaseURL:usingSession:`
/// @param completion Will be called when the network requests completes
-(void)beginRequestForEndpoint:(NSString *)endpoint completion:(void (^_Nullable)( NSData * _Nullable  data,  NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
