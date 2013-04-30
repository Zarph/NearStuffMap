//
//  RMFacebookSDK.h
//  MasterShareSDK
//
//  Created by Ramiro Guerrero & Marco Graciano on 29/04/13.
//    Copyright (c) 2013 Weston McBride
//
//    Permission is hereby granted, free of charge, to any
//    person obtaining a copy of this software and associated
//    documentation files (the "Software"), to deal in the
//    Software without restriction, including without limitation
//    the rights to use, copy, modify, merge, publish,
//    distribute, sublicense, and/or sell copies of the
//    Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice
//    shall be included in all copies or substantial portions of
//    the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY
//    KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
//    WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
//    PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
//    OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
//    OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
//    OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
//    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@protocol FacebookDelegate <NSObject>

-(void)loadNearbyFacebookPlacesWithData:(NSDictionary *)data;

@end

@interface RMFacebookSDK : AFHTTPClient {
    NSString *accessToken;
}


+ (RMFacebookSDK *)sharedClient;

-(void)getPublicPageWithQuery:(NSString *)query WithParams:(NSDictionary *)params AndWithDelegate:(NSObject <FacebookDelegate> *)delegate;
-(void)getPublicPlaceWithQuery:(NSString *)query WithParams:(NSDictionary *)params AndWithDelegate:(NSObject <FacebookDelegate> *)delegate;
-(void)getPublicPlaceWithQuery:(NSString *)query WithLatitude:(NSString *)latitude WithLongitude:(NSString *)longitude WithParams:(NSDictionary *)params AndWithDelegate:(NSObject <FacebookDelegate> *)delegate;
-(void)getPublicPostsWithQuery:(NSString *)query WithParams:(NSDictionary *)params AndWithDelegate:(NSObject <FacebookDelegate> *)delegate;
-(void)getPublicGroupsWithQuery:(NSString *)query WithParams:(NSDictionary *)params AndWithDelegate:(NSObject <FacebookDelegate> *)delegate;

@end