//
//  ModelManager.m
//  LinkRider
//
//  Created by hieu nguyen on 7/3/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import "ModelManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFURLSessionManager.h"
#import "Driver.h"
#import "DriverCar.h"
#import "StateObj.h"

@implementation ModelManager


+(void)sendData:(NSDictionary *)data
           path:(NSString *)path
    WithSuccess:(void (^)(NSDictionary *))success
        failure:(void (^)(NSString *))failure
{
    
    
    if (![Util isConnectNetwork]) {
        failure(@"No network found");
    }
    else{
        
        NSString*urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,path];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setTimeoutInterval:20];
        [manager POST:urlStr parameters:data success:^(AFHTTPRequestOperation *operation, id responseObject) {
            success(responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure([Util localized:@"msg_technical_error"]);
        }];
    }
}
+(void)registerAsDriver:(User *)user documentPath:(UIImage *)document withSuccess:(void(^)(NSDictionary *))success failure:(void (^) (NSString *))failure{
    
    NSString* token = [Util objectForKey:@"Token"];
    
    NSDictionary *dic = @{@"email":[Validator getSafeString:user.email],@"gcm_id":[Validator getSafeString:token],@"ime":[Validator getSafeString:token],@"type":@"2",@"lat":user.lattitude,@"long":user.logitude,@"gender":[Validator getSafeString:user.gender],@"name":[Validator getSafeString:user.name],@"image":[Validator getSafeString:user.thumb],@"dob":[Validator getSafeString:user.date_of_birth],@"carPlate":[Validator getSafeString:user.car.carPlate],@"brand":[Validator getSafeString:user.car.brand],@"model":[Validator getSafeString:user.car.model],@"year":[Validator getSafeString:user.manufacture_year],@"status":[Validator getSafeString:user.car_status],@"account":[Validator getSafeString:user.cart_value],@"token":[Validator getSafeString:gUser.token]};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:[NSString stringWithFormat:@"%@driverRegister",BASE_URL] parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData *main_car = UIImageJPEGRepresentation(user.main_car_image,0.5);
        [formData appendPartWithFileData:main_car name:@"image" fileName:[NSString stringWithFormat:@"image%@.jpg",user.client_id] mimeType:@"image/jpeg"];
        
        if (user.sub_car) {
            NSData *sub_car = UIImageJPEGRepresentation(user.sub_car_image,0.5);
            [formData appendPartWithFileData:sub_car name:@"image2" fileName:[NSString stringWithFormat:@"image2%@.jpg",user.client_id] mimeType:@"image/jpeg"];
            
        }
        
        NSData *document_car = UIImageJPEGRepresentation(document,0.5);
        [formData appendPartWithFileData:document_car name:@"document" fileName:[NSString stringWithFormat:@"document%@.jpg",user.client_id] mimeType:@"image/jpeg"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSString *status = [dic objectForKey:@"status"];
        if ([status.lowercaseString isEqualToString:@"success"]) {
            success(responseObject);
        }
        else{
            failure([dic objectForKey:@"message"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure([Util localized:@"msg_technical_error"]);
    }];
    
    
}
+(void)loginWithUser:(User *)user andToken:(NSString *)token Status:(BOOL)isEnable withSuccess:(void (^)(NSString *))success failure:(void (^)(NSString *))failure
{
    
    if (![Util isConnectNetwork]) {
        failure(nil);
        failure(nil);
    }
    if (user.lattitude.length==0) {
        user.lattitude = @"0";
        user.logitude = @"0";
    }
    if (token.length==0) {
        token = [Util objectForKey:@"Token"];
    }
    
    NSDictionary *di = @{@"email":[Validator getSafeString:user.email],
                         @"gcm_id":[Validator getSafeString:token],
                         @"ime":[Validator getSafeString:token],
                         @"type":@"2",
                         @"lat":user.lattitude,
                         @"long":user.logitude,
                         @"gender":[Validator getSafeString:user.gender],
                         @"name":[Validator getSafeString:user.name],
                         @"image":[Validator getSafeString:user.thumb]};

    if (user.date_of_birth.length>0) {
        di = @{@"email":[Validator getSafeString:user.email],
               @"gcm_id":[Validator getSafeString:token],
               @"ime":[Validator getSafeString:token],
               @"type":@"2",
               @"lat":user.lattitude,
               @"long":user.logitude,
               @"gender":[Validator getSafeString:user.gender],
               @"name":[Validator getSafeString:user.name],
               @"image":[Validator getSafeString:user.thumb],
               @"dob":[Validator getSafeString:user.date_of_birth]};
    }
    [self sendData:di path:API_LOGIN WithSuccess:^(NSDictionary *dic) {
        NSString *status =[dic objectForKey:@"status"];
        if ([status.lowercaseString isEqualToString:@"success"]) {
            gUser = [[User alloc]init];
            NSDictionary *dict = [dic objectForKey:@"data"];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                gUser = [[User alloc]init];
                gUser = user;
                gUser.client_id = [dict objectForKey:@"user_id"];
                gUser.point = [dict objectForKey:@"points"];
                gUser.token = [dict objectForKey:@"token"];
                gUser.is_driver = [dict objectForKey:@"isDriver"];
                gUser.driver = [[Driver alloc]init];
                gUser.driver.isActive = [Validator getSafeString:dict[@"driverActive"]];
                [Util saveUser:gUser];
                success([[dic objectForKey:@"data"] valueForKey:@"token"]);
            }
            else{
                failure([dic objectForKey:@"message"]);
            }
        }
        else{
            failure([dic objectForKey:@"message"]);
        }
    } failure:^(NSString *err) {
        failure(err);
    }];
    
}

+(void)getUserProfileWithAccessToken:(NSString *)accessToken
                         WithSuccess:(void (^)(User *))success
                             failure:(void (^)(NSString *))failure{
    NSString*urlStr = [NSString stringWithFormat:@"https://www.googleapis.com/oauth2/v1/userinfo?access_token=%@",accessToken];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSString *content = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if (!jsonDic) {
        
        if(failure)
            failure(nil);
    } else {
        User *u = [[User alloc]init];
        u.client_id = [Validator getSafeString:jsonDic[@"id"]];
        u.login_type = @"google";
        u.name = [Validator getSafeString:jsonDic[@"name"]];
        u.email = [Validator getSafeString:jsonDic[@"email"]];
        u.thumb = [Validator getSafeString:jsonDic[@"picture"]];
        u.gender = [Validator getSafeString:jsonDic[@"gender"]];
        
        [self getUserEmailWithAccessToken:accessToken WithSuccess:^(User *user) {
            u.email = user.email;
            
            success(u);
        } failure:^(NSString *err) {
            success(u);
        }];
    }
}

+(void)getUserEmailWithAccessToken:(NSString *)accessToken
                       WithSuccess:(void (^)(User *))success
                           failure:(void (^)(NSString *))failure{
    NSString*urlStr = [NSString stringWithFormat:@"https://www.googleapis.com/oauth2/v1/tokeninfo?access_token=%@",accessToken];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSString *content = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if (!jsonDic) {
        
        if(failure)
            failure(nil);
    } else {
        User *u = [[User alloc]init];
        u.email = [Validator getSafeString:jsonDic[@"email"]];
        
        success(u);
    }
    
}


+(User *)parseUserFromdic:(NSDictionary *)dic{
    User *u = [[User alloc]init];
    u.name = [Validator getSafeString:dic[@"fullName"]];
    u.email = [Validator getSafeString:dic[@"email"]];
    u.thumb = [Validator getSafeString:dic[@"image"]];
    u.gender = [Validator getSafeString:dic[@"gender"]];
    u.phone = [Validator getSafeString:dic[@"phone"]];
    u.passenger_rating_count = [Validator getSafeString:dic[@"rate"]];
    return u;
}
+(void)searchLocationWithKey:(NSString *)key withSuccess:(void (^)(NSMutableArray *))success failure:(void (^)(NSString *))failure
{
    
    if (![Util isConnectNetwork]) {
        failure(nil);
    }
    
    NSDictionary *dic = @{@"address":key,@"key":GOOGLE_API_KEY};
    NSString*urlStr = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(nil);
    }];
    
}
+(void)updateCoordinatewithLat:(float)lat andLong:(float)lon withSuccess:(void (^)(void))success failure:(void (^)(NSString *))failure
{
    
    if (![Util isConnectNetwork]) {
        failure(nil);
    }
    
    NSDictionary *dic = @{@"token":gUser.token,@"lat":[NSString stringWithFormat:@"%f",lat],@"long":[NSString stringWithFormat:@"%f",lon]};
//    NSDictionary *dic = @{@"token":gUser.token,@"lat":DEFAULT_LAT,@"long":DEFAULT_LONG};
    [self sendData:dic path:@"updateCoordinate" WithSuccess:^(NSDictionary *dict) {
        success();
    } failure:^(NSString *err) {
        failure(err);
    }];
    
}
+(void)updateDistancewithSuccess:(void (^)(float))success failure:(void (^)(NSString *))failure
{
    
    if (![Util isConnectNetwork]) {
        failure(nil);
    }
    
    NSDictionary *dic = @{@"token":gUser.token,@"tripId":gTrip.tripId};
    [self sendData:dic path:@"showDistance" WithSuccess:^(NSDictionary *dict) {
        success([Validator getSafeFloat:dict[@"data"]]);
    } failure:^(NSString *err) {
        failure(err);
    }];
    
}
+(void)getNumberOfCarsWithLatitude:(float)latitude Longitude:(float)longitude withSuccess:(void (^)(int))success failure:(void (^)(NSString *))failure
{
    
    if (![Util isConnectNetwork]) {
        failure(nil);
    }
    
    NSDictionary *dic = @{@"startLat":[NSString stringWithFormat:@"%f",latitude],@"startLong":[NSString stringWithFormat:@"%f",longitude]};
//    NSDictionary *dic = @{@"startLat":DEFAULT_LAT,@"startLong":DEFAULT_LONG};

    [self sendData:dic path:@"searchDriver" WithSuccess:^(NSDictionary *dict) {
        int numberOfCar =[dict[@"data"] intValue];
        success(numberOfCar);
    } failure:^(NSString *err) {
        failure(err);
    }];
    
}
+(void)driverConfirmWithTriId:(NSString *)tripId withSuccess:(void (^)(void))success failure:(void (^)(NSString *))failure
{
    
    if (![Util isConnectNetwork]) {
        failure(nil);
    }
    
    NSDictionary *dic = @{@"token":gUser.token,@"requestId":tripId};
    [self sendData:dic path:@"driverConfirm" WithSuccess:^(NSDictionary *dict) {
        success();
    } failure:^(NSString *err) {
        failure(err);
    }];
    
}
+(void)driverStartTripWithTriId:(NSString *)tripId withSuccess:(void (^)(void))success failure:(void (^)(NSString *))failure
{
    
    if (![Util isConnectNetwork]) {
        failure(nil);
    }
    
    NSDictionary *dic = @{@"token":gUser.token,@"tripId":tripId};
    [self sendData:dic path:@"startTrip" WithSuccess:^(NSDictionary *dict) {
        success();
    } failure:^(NSString *err) {
        failure(err);
    }];
    
}

+(void)driverEndTripWithTriId:(NSString *)tripId andDistance:(NSString *)distance withSuccess:(void (^)(void))success failure:(void (^)(NSString *))failure
{
    
    if (![Util isConnectNetwork]) {
        failure(nil);
    }

    NSDictionary *dic = @{@"token":gUser.token,@"tripId":tripId,@"distance":distance};
    [self sendData:dic path:@"endTrip" WithSuccess:^(NSDictionary *dict) {
        success();
    } failure:^(NSString *err) {
        failure(err);
    }];
    
}
+(void)getUserProfileWithSuccess:(void (^)(void))success failure:(void(^)(NSString *))failure{
    if (![Util isConnectNetwork]) {
        failure(nil);
        failure(nil);
    }
    NSString *type = @"0";
    if (gUser.driver_id.length>0) {
        type = @"1";
    }
    NSDictionary *dic = @{@"token":gUser.token,@"driver":type};
    [self sendData:dic path:SHOW_USER_INFO WithSuccess:^(NSDictionary *dic) {
        
        if ([[dic objectForKey:@"status"] isEqualToString:@"SUCCESS"]) {
            NSDictionary *user = [dic objectForKey:@"data"];
            gUser.point = [Validator getSafeString:user[@"balance"]];
            gUser.descriptions = [Validator getSafeString:user[@"description"]];
            gUser.address = [Validator getSafeString:user[@"address"]];
            gUser.passenger_rating = [Validator getSafeString:user[@"passengerRate"]];
            gUser.passenger_rating_count = [Validator getSafeString:user[@"passengerRateCount"]];
            gUser.email = [Validator getSafeString:user[@"email"]];
            gUser.name = [Validator getSafeString:user[@"fullName"]];
            gUser.gender = [Validator getSafeString:user[@"gender"]];
            gUser.driver_id = [Validator getSafeString:user[@"id"]];
            gUser.phone = [Validator getSafeString:user[@"phone"]];
            gUser.thumb = [Validator getSafeString:user[@"image"]];
            gUser.is_online = [Validator getSafeString:user[@"isOnline"]];
            gUser.state = [Validator getSafeString:user[@"stateName"]];
            gUser.stateId = [Validator getSafeString:user[@"stateId"]];
            gUser.cityId = [Validator getSafeString:user[@"cityId"]];
            gUser.city = [Validator getSafeString:user[@"cityName"]];
            
            NSDictionary *car = [user objectForKey:@"car"];
            if ([car isKindOfClass:[NSDictionary class]]) {
                gUser.car = [[DriverCar alloc]init];
                gUser.car.brand = [Validator getSafeString:car[@"brand"]];
                gUser.car.carPlate = [Validator getSafeString:car[@"carPlate"]];
                gUser.car.dateCreated = [Validator getSafeString:car[@"dateCreated"]];
                gUser.car.document = [Validator getSafeString:car[@"document"]];
                gUser.car.car_id = [Validator getSafeString:car[@"car_id"]];
                gUser.car.image1 = [Validator getSafeString:[[car objectForKey:@"images"] valueForKey:@"image1"]];
                gUser.car.image2 = [Validator getSafeString:[[car objectForKey:@"images"] valueForKey:@"image2"]];
                gUser.car.model = [Validator getSafeString:car[@"model"]];
                gUser.car.year = [Validator getSafeString:car[@"year"]];
                gUser.car.status = [Validator getSafeString:car[@"status"]];
            }
            
            
            
            NSDictionary *driver = [user objectForKey:@"driver"];
            if ([driver isKindOfClass:[NSDictionary class]]) {
                gUser.driver = [[Driver alloc]init];
                gUser.driver.bankAccount = [Validator getSafeString:driver[@"bankAccount"]];
                gUser.driver.document = [Validator getSafeString:driver[@"document"]];
                gUser.driver.driverRate = [Validator getSafeString:driver[@"driverRate"]];
                gUser.driver.driverRateCount = [Validator getSafeString:driver[@"driverRateCount"]];
                gUser.driver.isActive = [Validator getSafeString:driver[@"isActive"]];
                gUser.driver.isOnline = [Validator getSafeString:driver[@"isOnline"]];
                gUser.is_online = [Validator getSafeString:driver[@"isOnline"]];
                gUser.driver.status = [Validator getSafeString:driver[@"status"]];
                gUser.driver.update_pending = [Validator getSafeString:driver[@"updatePending"]];
                gUser.is_driver = @"1";
                
            }
            
            [Util saveUser:gUser];
            success();
        }
        else{
            failure([dic objectForKey:@"message"]);
        }
    } failure:^(NSString *err) {
        failure(err);
    }];
    
}
+(void)sendRequestWithSuccess:(void(^)(NSDictionary *))success andFailure:(void (^)(NSString *))failure{
    NSString *startLat = [NSString stringWithFormat:@"%f",gTrip.startLocation.placemark.coordinate.latitude];
    NSString *startLong = [NSString stringWithFormat:@"%f",gTrip.startLocation.placemark.coordinate.longitude];
    
    NSString *endLat = [NSString stringWithFormat:@"%f",gTrip.endLocation.placemark.coordinate.latitude];
    NSString *endLong = [NSString stringWithFormat:@"%f",gTrip.endLocation.placemark.coordinate.longitude];
    
    NSDictionary *dic = @{@"link":gTrip.link,@"startLat":startLat,@"startLong":startLong,@"startLocation":gTrip.startLocation.name,@"endLat":endLat,@"endLong":endLong,@"endLocation":gTrip.endLocation.name,@"token":gUser.token};
    [self sendData:dic path:CREATE_REQUEST WithSuccess:^(NSDictionary *dict) {
        success(dict);
    } failure:^(NSString *err) {
        failure(err);
    }];
}
+(void)logoutWithSuccess:(void(^)(void ))success andFailure:(void (^)(NSString *))failure{
    
    NSDictionary *dic = @{@"token":gUser.token};
    [self sendData:dic path:@"logout" WithSuccess:^(NSDictionary *dict) {
        success();
    } failure:^(NSString *err) {
        failure(err);
    }];
}

+(void)rateDriverWithRate:(float)rate Success:(void(^)(void ))success andFailure:(void (^)(NSString *))failure{
    
    NSDictionary *dic = @{@"token":gUser.token,@"tripId":gTrip.tripId,@"rate":[NSString stringWithFormat:@"%.0f",rate]};
    [self sendData:dic path:@"rateDriver" WithSuccess:^(NSDictionary *dict) {
        NSString *status = [dict objectForKey:@"status"];
        if ([status.lowercaseString isEqualToString:@"success"]) {
            success();
        }
        else{
            failure([dict objectForKey:@"message"]);
        }
    } failure:^(NSString *err) {
        failure(err);
    }];
}
+(void)shareWithType:(NSString *)social WithSuccess:(void(^)(void ))success andFailure:(void (^)(NSString *))failure{
    
    NSString *type = @"passenger";
    if ([[Validator getSafeString:gUser.is_driver] isEqualToString:@"1"]) {
        type = @"driver";
    }
    NSDictionary *dic = @{@"token":gUser.token,@"type":type,@"social":social};
    [self sendData:dic path:@"shareApp" WithSuccess:^(NSDictionary *dict) {
        NSString *status = [dict objectForKey:@"status"];
        if ([status.lowercaseString isEqualToString:@"success"]) {
            success();
        }
        else{
            failure([dict objectForKey:@"message"]);
        }
    } failure:^(NSString *err) {
        failure(err);
    }];
}
+(void)tripPaymentWithSuccess:(void(^)(void ))success andFailure:(void (^)(NSString *))failure{
    
    NSDictionary *dic = @{@"token":gUser.token,@"tripId":gTrip.tripId};
    [self sendData:dic path:@"tripPayment" WithSuccess:^(NSDictionary *dict) {
        NSString *status = [dict objectForKey:@"status"];
        if ([status.lowercaseString isEqualToString:@"success"]) {
            success();
        }
        else{
            failure([dict objectForKey:@"message"]);
        }
    } failure:^(NSString *err) {
        failure(err);
    }];
}
+(void)ratePassengerWithRate:(float)rate Success:(void(^)(void ))success andFailure:(void (^)(NSString *))failure{
    
    NSDictionary *dic = @{@"token":gUser.token,@"tripId":gTrip.tripId,@"rate":[NSString stringWithFormat:@"%.0f",rate]};
    [self sendData:dic path:@"ratePassenger" WithSuccess:^(NSDictionary *dict) {
        NSString *status = [dict objectForKey:@"status"];
        if ([status.lowercaseString isEqualToString:@"success"]) {
            success();
        }
        else{
            failure([dict objectForKey:@"message"]);
        }
    } failure:^(NSString *err) {
        failure(err);
    }];
}
+(void)showMyTripsWithSuccess:(void(^)(NSMutableArray *))success andFailure:(void (^)(NSString *))failure{
    
    NSDictionary *dic = @{@"token":gUser.token};
    [self sendData:dic path:@"showMyTrip" WithSuccess:^(NSDictionary *dict) {
        success([self parseTripFromDicArr:dict]);
    } failure:^(NSString *err) {
        failure(err);
    }];
}
+(void)showMyTripsWithPage:(int)page Success:(void(^)(NSMutableArray *))success andFailure:(void (^)(NSString *))failure{
    
    NSDictionary *dic = @{@"token":gUser.token,@"page":[NSString stringWithFormat:@"%d",page]};
    [self sendData:dic path:@"showMyTrip" WithSuccess:^(NSDictionary *dict) {
        success([self parseTripFromDicArr:dict]);
    } failure:^(NSString *err) {
        failure(err);
    }];
}
+(void)showTripDetailWithTripId:(NSString *)tripId withSuccess:(void(^)(Trips *))success andFailure:(void (^)(NSString *))failure{
    
    NSDictionary *dic = @{@"token":gUser.token,@"tripId":tripId};
    [self sendData:dic path:@"showTripDetail" WithSuccess:^(NSDictionary *dict) {
        success([self parseTripFromDic:dict]);
        
    } failure:^(NSString *err) {
        failure(err);
    }];
}

+(void)showMyRequestWithSuccess:(void(^)(NSMutableArray *))success andFailure:(void (^)(NSString *))failure{
    NSString *isDriver = gUser.is_driver;
    if ([gUser.is_driver isEqualToString:@"1"]) {
        if(![gUser.driver.isOnline isEqualToString:@"1"]){
            isDriver = @"0";
        }
    }
    NSDictionary *dic = @{@"token":gUser.token,@"driver":isDriver};
    [self sendData:dic path:@"showMyRequest" WithSuccess:^(NSDictionary *dict) {
        success([self parseTripFromDicArr:dict]);
    } failure:^(NSString *err) {
        failure(err);
    }];
}


+(void)cancelRequest:(Trips *)trip withSuccess:(void(^)(void))success andFailure:(void (^)(NSString *))failure{
    
    NSString *isDriver = gUser.is_driver;
    if ([gUser.is_driver isEqualToString:@"1"]) {
        if(![gUser.driver.isOnline isEqualToString:@"1"]){
            isDriver = @"0";
        }
    }
    NSDictionary *dic = @{@"token":gUser.token,@"driver":isDriver};
    if ([isDriver isEqualToString:@"1"]) {
        
        dic = @{@"token":gUser.token,@"driver":isDriver,@"requestId":trip.tripId};
    }
    
    
    [self sendData:dic path:@"cancelRequest" WithSuccess:^(NSDictionary *dict) {
        NSString *status = [Validator getSafeString:dict[@"status"]];
        if ([status.lowercaseString isEqualToString:@"success"]) {
            success();
        }
        else{
            failure([Validator getSafeString:dict[@"message"]]);
        }
        
    } failure:^(NSString *err) {
        failure(err);
    }];
}
+(void)cancelTrip:(Trips *)trip withSuccess:(void(^)(void))success andFailure:(void (^)(NSString *))failure{
    NSDictionary *dic = @{@"token":gUser.token,@"driverId":trip.driverId,@"tripId":trip.tripId};
    
    
    [self sendData:dic path:@"cancelTrip" WithSuccess:^(NSDictionary *dict) {
        NSString *status = [Validator getSafeString:dict[@"status"]];
        if ([status.lowercaseString isEqualToString:@"success"]) {
            success();
        }
        else{
            failure([Validator getSafeString:dict[@"message"]]);
        }
        
    } failure:^(NSString *err) {
        failure(nil);
    }];
}
+(void)setDriverOnline:(BOOL)isOnline withSuccess:(void(^)(void))success andFailure:(void (^)(NSString *))failure{
    NSString *status = @"0";
    if (isOnline) {
        status = @"1";
    }
    NSDictionary *dic = @{@"token":gUser.token,@"status":status};
    [self sendData:dic path:@"online" WithSuccess:^(NSDictionary *dict) {
        NSString *status = [Validator getSafeString:dict[@"status"]];
        if ([status.lowercaseString isEqualToString:@"success"]) {
            success();
        }
        else{
            failure([Validator getSafeString:dict[@"message"]]);
        }
        
    } failure:^(NSString *err) {
        failure(err);
    }];
}
+(void)updateProfileWithUser:(User *)user withSuccess:(void (^)(NSString *))success failure:(void (^)(NSString *))failure
{
    
    if (![Util isConnectNetwork]) {
        failure(nil);
        failure(nil);
    }
    if (user.lattitude.length==0) {
        user.lattitude = @"0";
        user.logitude = @"0";
    }
    NSString *token = gUser.token;
    
    NSDictionary *di = @{@"description":user.descriptions,@"address":user.address,@"cityId":user.city,@"cityName": user.city, @"stateId":user.stateId, @"stateName":user.state, @"phone":user.phone,@"token":token};
    
    [self sendData:di path:@"updateProfile" WithSuccess:^(NSDictionary *dic) {
        NSString *status =[dic objectForKey:@"status"];
        if ([status.lowercaseString isEqualToString:@"success"]) {
            gUser = [[User alloc]init];
            NSDictionary *dict = [dic objectForKey:@"data"];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                gUser = [[User alloc]init];
                gUser = user;
                [Util saveUser:gUser];
                success([[dic objectForKey:@"data"] valueForKey:@"token"]);
            }
            else{
                failure([dic objectForKey:@"message"]);
            }
            
        }
        else{
            failure([dic objectForKey:@"message"]);
        }
    } failure:^(NSString *err) {
        failure(err);
    }];
    
}


+(void)updateProfileWithDriver:(User *)user andDocument:(UIImage *)document withSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure
{
    
    if (![Util isConnectNetwork]) {
        failure(nil);
        failure(nil);
    }
    if (user.lattitude.length==0) {
        user.lattitude = @"0";
        user.logitude = @"0";
    }
    NSString *token = gUser.token;
    
    NSDictionary *dic = @{@"carPlate":user.car.carPlate,@"brand":user.car.brand,@"model":user.car.model,@"year":user.manufacture_year,@"status":user.car.status,@"phone":user.phone,@"token":token};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:[NSString stringWithFormat:@"%@updateDriverData",BASE_URL] parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        if (user.main_car_image) {
            NSData *main_car = UIImageJPEGRepresentation(user.main_car_image,0.5);
            [formData appendPartWithFileData:main_car name:@"image" fileName:[NSString stringWithFormat:@"image%@.jpg",user.client_id] mimeType:@"image/jpeg"];
        }
        
        
        if (user.sub_car_image) {
            NSData *sub_car = UIImageJPEGRepresentation(user.sub_car_image,0.5);
            [formData appendPartWithFileData:sub_car name:@"image2" fileName:[NSString stringWithFormat:@"image2%@.jpg",user.client_id] mimeType:@"image/jpeg"];
            
        }
        if (document) {
            NSData *document_car = UIImageJPEGRepresentation(document,0.5);
            [formData appendPartWithFileData:document_car name:@"document" fileName:[NSString stringWithFormat:@"document%@.jpg",user.client_id] mimeType:@"image/jpeg"];
        }
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSString *status = [dic objectForKey:@"status"];
        if ([status.lowercaseString isEqualToString:@"success"]) {
            success(dic);
        }
        else{
            failure([dic objectForKey:@"message"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure([Util localized:@"msg_technical_error"]);
    }];
    
}
+(void)pointExchangewithAmount:(NSString *)amount
                 transactionId:(NSString *)tran
              andPaymentMethod:(NSString *)method
                   withSuccess:(void(^)(void))success
                    andFailure:(void (^)(NSString *))failure{
    
    NSDictionary *dic = @{@"token":gUser.token,@"transactionId":tran,@"amount":amount,@"paymentMethod":method};
    [self sendData:dic path:@"pointExchange" WithSuccess:^(NSDictionary *dict) {
        NSString *status = [Validator getSafeString:dict[@"status"]];
        if ([status.lowercaseString isEqualToString:@"success"]) {
            success();
        }
        else{
            failure([Validator getSafeString:dict[@"message"]]);
        }
        
    } failure:^(NSString *err) {
        failure([Util localized:@"msg_technical_error"]);
    }];
}

+(void)pointRedeemwithAmount:(NSString *)amount
                 withSuccess:(void(^)(void))success
                  andFailure:(void (^)(NSString *))failure{
    
    NSDictionary *dic = @{@"token":gUser.token,@"amount":amount};
    [self sendData:dic path:@"pointRedeem" WithSuccess:^(NSDictionary *dict) {
        NSString *status = [Validator getSafeString:dict[@"status"]];
        if ([status.lowercaseString isEqualToString:@"success"]) {
            success();
        }
        else{
            failure([Validator getSafeString:dict[@"message"]]);
        }
        
    } failure:^(NSString *err) {
        failure(err);
    }];
}

+(void)searchUserWithEmail:(NSString *)email
               withSuccess:(void(^)(User *))success
                andFailure:(void (^)(NSString *))failure{
    
    NSDictionary *dic = @{@"token":gUser.token,@"email":email};
    [self sendData:dic path:@"searchUser" WithSuccess:^(NSDictionary *dict) {
        NSString *status = [Validator getSafeString:dict[@"status"]];
        if ([status.lowercaseString isEqualToString:@"success"]) {
            NSDictionary *user = [dict objectForKey:@"data"];
            if ([user isKindOfClass:[NSDictionary class]]) {
                success([self parseUserFromdic:user]);
            }
            else{
                failure([Validator getSafeString:dict[@"message"]]);
            }
        }
        else{
            failure([Validator getSafeString:dict[@"message"]]);
        }
        
    } failure:^(NSString *err) {
        failure(err);
    }];
}

+(void)transferWithAmount:(NSString *)amount
                    email:(NSString *)receiverEmail
                  andNote:(NSString *)note
              withSuccess:(void(^)(void))success
               andFailure:(void (^)(NSString *))failure{
    
    NSDictionary *dic = @{@"token":gUser.token,@"amount":amount,@"receiverEmail":receiverEmail,@"note":note};
    [self sendData:dic path:@"pointTransfer" WithSuccess:^(NSDictionary *dict) {
        NSString *status = [Validator getSafeString:dict[@"status"]];
        if ([status.lowercaseString isEqualToString:@"success"]) {
            success();
        }
        else{
            failure([Validator getSafeString:dict[@"message"]]);
        }
        
    } failure:^(NSString *err) {
        failure(err);
    }];
}

+(void)transactionHistorywithPage:(int)page Success:(void(^)(NSMutableArray *))success
                       andFailure:(void (^)(NSString *))failure{
    
    NSDictionary *dic = @{@"token":gUser.token,@"page":[NSString stringWithFormat:@"%d",page]};
    [self sendData:dic path:@"transactionHistory" WithSuccess:^(NSDictionary *dict) {
        NSString *status = [Validator getSafeString:dict[@"status"]];
        if ([status.lowercaseString isEqualToString:@"success"]) {
            NSArray *arr = [dict objectForKey:@"data"];
            success([self parseHistoryFromDic:arr]);
        }
        else{
            failure([Validator getSafeString:dict[@"message"]]);
        }
        
    } failure:^(NSString *err) {
        failure(err);
    }];
}

+(void)generalSettingWithSuccess:(void(^)(NSDictionary *))success
                      andFailure:(void (^)(NSString *))failure{
    
    NSDictionary *dic = @{@"token":gUser.token};
    [self sendData:dic path:@"generalSettings" WithSuccess:^(NSDictionary *dict) {
        NSString *status = [Validator getSafeString:dict[@"status"]];
        if ([status.lowercaseString isEqualToString:@"success"]) {
            success([dict objectForKey:@"data"]);
        }
        else{
            failure([Validator getSafeString:dict[@"message"]]);
        }
        
    } failure:^(NSString *err) {
        failure(err);
    }];
}

+(NSMutableArray *)parseHistoryFromDic:(NSArray*)dicArr{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in dicArr) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            History *his  = [[History alloc]init];
            his.amount = [Validator getSafeString:dic[@"amount"]];
            his.dateCreated =  [Validator getSafeString:dic[@"dateCreated"]];
            his.destination =  [Validator getSafeString:dic[@"destination"]];
            his.transactionId =  [Validator getSafeString:dic[@"id"]];
            his.userId =  [Validator getSafeString:dic[@"userId"]];
            his.tripId = [Validator getSafeString:dic[@"tripId"]];
            NSString *action =  [Validator getSafeString:dic[@"action"]];
            if ([action isEqualToString:CANCELLATION_ORDER_FEE]) {
                his.action = [Util localized:@"CANCELLATION_ORDER_FEE"];
            }
            else if ([action isEqualToString:EXCHANGE_POINT]) {
                his.action = [Util localized:@"EXCHANGE_POINT"];
            }
            else if ([action isEqualToString:REDEEM_POINT]) {
                his.action = [Util localized:@"REDEEM_POINT"];
            }
            else if ([action isEqualToString:TRANSFER_POINT]) {
                his.action = [Util localized:@"TRANSFER_POINT"];
            }
            else if ([action isEqualToString:TRIP_PAYMENT]) {
                his.action = [Util localized:@"TRIP_PAYMENT"];
            }
            else if ([action isEqualToString:PASSENGER_SHARE_BONUS]) {
                his.action = [Util localized:@"PASSENGER_SHARE_BONUS"];
            }
            else{
                his.action = [Util localized:@"DRIVER_SHARE_BONUS"];
            }
            his.type =  [Validator getSafeString:dic[@"type"]];
            [arr addObject:his];
        }
    }
    return arr;
}

+(Trips *)parseTripFromDic:(NSDictionary *)dic{
    Trips *trip = [[Trips alloc]init];
    NSDictionary *data = [dic objectForKey:@"data"];
    trip.tripId = [Validator getSafeString:data[@"id"]];
    trip.passengerId = [Validator getSafeString:data[@"passengerId"]];
    trip.startTime = [Validator getSafeString:data[@"startTime"]];
    trip.link = [Validator getSafeString:data[@"link"]];
    float startLat = [Validator getSafeFloat:data[@"startLat"]];
    float startLong = [Validator getSafeFloat:data[@"startLong"]];
    NSString *startLocation = [Validator getSafeString:data[@"startLocation"]];
    [trip setStartLocationWithLatitude:startLat longitude:startLong andTitle:startLocation];
    
    float endLat = [Validator getSafeFloat:data[@"endLat"]];
    float endLong = [Validator getSafeFloat:data[@"endLong"]];
    NSString *endLocation = [Validator getSafeString:data[@"endLocation"]];
    [trip setEndLocationWithLatitude:endLat longitude:endLong andTitle:endLocation];
    
    trip.driverId = [Validator getSafeString:data[@"driverId"]];
    trip.status = [Validator getSafeString:data[@"status"]];
    trip.distance = [Validator getSafeString:data[@"distance"]];
    trip.estimateFare = [Validator getSafeString:data[@"estimateFare"]];
    trip.actualFare = [Validator getSafeString:data[@"actualFare"]];
    trip.actualEarn = [Validator getSafeString:data[@"driver_earn"]];
    trip.driverRate = [Validator getSafeString:data[@"driverRate"]];
    trip.passengerRate = [Validator getSafeString:data[@"passengerRate"]];
    
    
    NSDictionary *driver = [data objectForKey:@"driver"];
    trip.driver = [[Driver alloc]init];
    trip.driver.driverName = [Validator getSafeString:driver[@"driverName"]];
    trip.driver.driverRateCount = [Validator getSafeString:driver[@"rate"]];
    trip.driver.imageDriver = [Validator getSafeString:driver[@"imageDriver"]];
    trip.driver.carImage = [Validator getSafeString:driver[@"carImage"]];
    trip.driver.carPlate = [Validator getSafeString:driver[@"carPlate"]];
    trip.driver.phone = [Validator getSafeString:driver[@"phone"]];
    
    NSDictionary *passenger = [data objectForKey:@"passenger"];
    trip.passenger = [[User alloc]init];
    trip.passenger.name = [Validator getSafeString:passenger[@"passengerName"]];
    trip.passenger.passenger_rating_count = [Validator getSafeString:passenger[@"rate"]];
    trip.passenger.thumb = [Validator getSafeString:passenger[@"imagePassenger"]];
    trip.passenger.phone = [Validator getSafeString:passenger[@"phone"]];
    return trip;
}
+(NSMutableArray *)parseTripFromDicArr:(NSDictionary *)dic{
    NSArray *arr = [dic objectForKey:@"data"];
    NSMutableArray *tripArr = [[NSMutableArray alloc]init];
    if ([arr isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dict in arr) {
            Trips *trip = [[Trips alloc]init];
            trip.tripId = [Validator getSafeString:dict[@"id"]];
            trip.passengerId = [Validator getSafeString:dict[@"passengerId"]];
            trip.link = [Validator getSafeString:dict[@"link"]];
            trip.startTime = [Validator getSafeString:dict[@"startTime"]];
            trip.endTime = [Validator getSafeString:dict[@"endTime"]];
            trip.distance = [Validator getSafeString:dict[@"distance"]];
            trip.status = [Validator getSafeString:dict[@"status"]];
            
            trip.estimateFare = [Validator getSafeString:dict[@"estimateFare"]];
            trip.actualFare = [Validator getSafeString:dict[@"actualFare"]];
            trip.actualEarn = [Validator getSafeString:dict[@"actualReceive"]];
            trip.driverRate = [Validator getSafeString:dict[@"driverRate"]];
            trip.passengerRate = [Validator getSafeString:dict[@"passengerRate"]];
            trip.dateCreated = [Validator getSafeString:dict[@"dateCreated"]];
            trip.totalTime = [Validator getSafeString:dict[@"totalTime"]];
            trip.driverId = [Validator getSafeString:dict[@"driverId"]];
            trip.passenger = [[User alloc]init];
            NSDictionary *passenger = dict[@"passenger"];
            if ([passenger isKindOfClass:[NSDictionary class]]){
                trip.passenger = [self parseUserFromdic:dict[@"passenger"]];
            }
            
            if ([trip.status isEqualToString:TRIP_STATUS_PENDING_PAYMENT]) {
                if ([trip.driverId isEqualToString:gUser.driver_id]) {
                    trip.status = TRIP_STATUS_FINISH;
                }
            }
            NSDictionary *driver = [dict objectForKey:@"driver"];
            if ([driver isKindOfClass:[NSDictionary class]]){
                trip.driver = [[Driver alloc]init];
                trip.driver.driverName = [Validator getSafeString:driver[@"driverName"]];
                trip.driver.driverRateCount = [Validator getSafeString:driver[@"rate"]];
                trip.driver.imageDriver = [Validator getSafeString:driver[@"imageDriver"]];
                if (trip.driver.imageDriver.length==0) {
                    trip.driver.imageDriver = [Validator getSafeString:driver[@"image"]];
                }
                NSDictionary *images = driver[@"carImage"];
                if ([images isKindOfClass:[NSDictionary class]]) {
                    trip.driver.carImage = [Validator getSafeString:driver[@"image1"]];
                }
                
                trip.driver.carPlate = [Validator getSafeString:driver[@"carPlate"]];
                trip.driver.phone = [Validator getSafeString:driver[@"phone"]];
            }
            
            
            NSString *startLat = [Validator getSafeString:dict[@"startLat"]];
            NSString *startLong = [Validator getSafeString:dict[@"startLong"]];
            NSString *endLat = [Validator getSafeString:dict[@"endLat"]];
            NSString *endLong = [Validator getSafeString:dict[@"endLong"]];
            NSString *startLocation = [Validator getSafeString:dict[@"startLocation"]];
            NSString *endLocation = [Validator getSafeString:dict[@"endLocation"]];
            
            MKPlacemark *placemarkFrom = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake([startLat floatValue], [startLong floatValue]) addressDictionary:nil] ;
            trip.startLocation = [[MKMapItem alloc] initWithPlacemark:placemarkFrom];
            [trip.startLocation setName:startLocation];
            
            MKPlacemark *placemarkTo = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake([endLat floatValue], [endLong floatValue]) addressDictionary:nil] ;
            trip.endLocation = [[MKMapItem alloc] initWithPlacemark:placemarkTo];
            [trip.endLocation setName:endLocation];
            
            [tripArr addObject:trip];
        }
    }
    
    
    return tripArr;
}

+ (void)getListStateWithSuccess:(void (^)(NSArray *))returnSuccess failure:(void (^)(NSString *))returnFail{
    NSDictionary *dic = @{};
    [self sendData:dic path:@"showStateCity" WithSuccess:^(NSDictionary *dict) {
        NSString *status = [Validator getSafeString:dict[@"status"]];
        if ([status.lowercaseString isEqualToString:@"success"]) {
            NSArray *arrDictState = [dict objectForKey:@"data"];
            NSMutableArray *arrStateReturn = [[NSMutableArray alloc] init];
            for (NSDictionary *dictState in arrDictState) {
                StateObj* stateObj = [[StateObj alloc] initWithDict:dictState];
                [arrStateReturn addObject:stateObj];
            }
            returnSuccess(arrStateReturn);
            gArrState = arrStateReturn.copy;
        }
        else{
            returnFail(dict[@"message"]);
        }
        
    } failure:^(NSString *err) {
        returnFail(err);
    }];


}

@end
