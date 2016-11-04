//
//  ModelManager.h
//  LinkRider
//
//  Created by hieu nguyen on 7/3/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
@interface ModelManager : NSObject
+(void)getUserProfileWithAccessToken:(NSString *)accessToken
                         WithSuccess:(void (^)(User *))success
                             failure:(void (^)(NSString *))failure;
+(void)registerAsDriver:(User *)user
           documentPath:(UIImage *)document
            withSuccess:(void(^)(NSDictionary *))success
                failure:(void (^) (NSString *))failure;

+(void)loginWithUser:(User *)user andToken:(NSString *)token
              Status:(BOOL)isEnable
         withSuccess:(void (^)(NSString *))success
             failure:(void (^)(NSString *))failure;

+(void)getUserProfileWithSuccess:(void (^)(void))success
                         failure:(void(^)(NSString *))failure;

+(void)sendRequestWithSuccess:(void(^)(NSDictionary *))success
                    andFailure:(void (^)(NSString *))failure;

+(void)showTripDetailWithTripId:(NSString *)tripId
                    withSuccess:(void(^)(Trips *))success
                     andFailure:(void (^)(NSString *))failure;
    
+(void)logoutWithSuccess:(void(^)(void ))success
               andFailure:(void (^)(NSString *))failure;

+(void)showMyTripsWithSuccess:(void(^)(NSMutableArray *))success
                    andFailure:(void (^)(NSString *))failure;
+(void)showMyTripsWithPage:(int)page
                   Success:(void(^)(NSMutableArray *))success
                andFailure:(void (^)(NSString *))failure;
+(void)showMyRequestWithSuccess:(void(^)(NSMutableArray *))success
                      andFailure:(void (^)(NSString *))failure;
+(void)cancelRequest:(Trips *)trip
         withSuccess:(void(^)(void))success
          andFailure:(void (^)(NSString *))failure;

+(void)setDriverOnline:(BOOL)isOnline
           withSuccess:(void(^)(void))success
            andFailure:(void (^)(NSString *))failure;

+(void)updateProfileWithUser:(User *)user
                 withSuccess:(void (^)(NSString *))success
                     failure:(void (^)(NSString *))failure;

+(void)updateProfileWithDriver:(User *)user
                   andDocument:(UIImage *)document
                   withSuccess:(void (^)(NSDictionary *))success
                       failure:(void (^)(NSString *))failure;

+(void)cancelTrip:(Trips *)trip
      withSuccess:(void(^)(void))success
       andFailure:(void (^)(NSString *))failure;

+(void)pointExchangewithAmount:(NSString *)amount
                 transactionId:(NSString *)tran
              andPaymentMethod:(NSString *)method
                   withSuccess:(void(^)(void))success
                    andFailure:(void (^)(NSString *))failure;
+(void)pointRedeemwithAmount:(NSString *)amount
                 withSuccess:(void(^)(void))success
                  andFailure:(void (^)(NSString *))failure;

+(void)searchUserWithEmail:(NSString *)email
               withSuccess:(void(^)(User *))success
                andFailure:(void (^)(NSString *))failure;

+(void)transferWithAmount:(NSString *)amount
                    email:(NSString *)receiverEmail
                  andNote:(NSString *)note
              withSuccess:(void(^)(void))success
               andFailure:(void (^)(NSString *))failure;

+(void)transactionHistorywithPage:(int)page
                          Success:(void(^)(NSMutableArray *))success
                       andFailure:(void (^)(NSString *))failure;

+(void)rateDriverWithRate:(float)rate
                  Success:(void(^)(void ))success
               andFailure:(void (^)(NSString *))failure;


+(void)tripPaymentWithSuccess:(void(^)(void ))success
                   andFailure:(void (^)(NSString *))failure;

+(void)ratePassengerWithRate:(float)rate
                     Success:(void(^)(void ))success
                  andFailure:(void (^)(NSString *))failure;

+(void)shareWithType:(NSString *)social
         WithSuccess:(void(^)(void ))success
          andFailure:(void (^)(NSString *))failure;

+(void)updateCoordinatewithLat:(float)lat andLong:(float)lon
                   withSuccess:(void (^)(void))success
                       failure:(void (^)(NSString *))failure;

+(void)updateDistancewithSuccess:(void (^)(float))success
                         failure:(void (^)(NSString *))failure;

+(void)driverConfirmWithTriId:(NSString *)tripId
                  withSuccess:(void (^)(void))success
                      failure:(void (^)(NSString *))failure;

+(void)driverStartTripWithTriId:(NSString *)tripId
                    withSuccess:(void (^)(void))success
                        failure:(void (^)(NSString *))failure;

+(void)driverEndTripWithTriId:(NSString *)tripId
                  andDistance:(NSString *)distance
                  withSuccess:(void (^)(void))success
                      failure:(void (^)(NSString *))failure;
+(void)generalSettingWithSuccess:(void(^)(NSDictionary *))success
                      andFailure:(void (^)(NSString *))failure;

+(void)getNumberOfCarsWithLatitude:(float)latitude
                         Longitude:(float)longitude
                       withSuccess:(void (^)(int))success
                           failure:(void (^)(NSString *))failure;

+ (void)getListStateWithSuccess:(void (^)(NSArray *arrResult))returnSuccess failure:(void (^)(NSString *err))returnFail;

@end
