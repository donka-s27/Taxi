//
//  Constant.h
//  LinkRider
//
//  Created by hieu nguyen on 7/15/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#ifndef LinkRider_Constant_h
#define LinkRider_Constant_h

#define IS_DEMO                         NO


#define SHOW_TRANSACTION_HISTORY_KEY    @"SHOW_TRANSACTION_HISTORY_KEY"


#define RECEIVE_ORDER_REQUEST_KEY       @"receiveOrderRequestByPushNotifications"
#define START_TRIP_KEY                  @"startTripByPushNotifications"
#define END_TRIP_KEY                    @"endTripByPushNotifications"
#define DRIVER_CONFIRM_KEY              @"driverConfirmByPishNotifications"
#define CANCEL_TRIP_KEY                 @"cancelTripByPishNotifications"
#define WILL_ENTER_FORCE_GROUND         @"appWillEnterForceGround"

#define DRIVER_RECEIVE_REQUEST_KEY      @"driverReceiveRequestByPushNotifications"
#define DRIVER_CANCEL_TRIP_KEY          @"driverCancelTripByPushNotifications"
#define DRIVER_CANCEL_REQUEST_KEY       @"driverCancelRequestByPushNotifications"
#define PASSENGER_CANCEL_REQUEST        @"cancelRequest"
#define DRIVER_REGISTER_APPROVE         @"driverApproved"
#define PUSH_KEY_PROMOTION              @"promotion"


#define LANGUAGE_KEY                    @"LANGUAGEKEY"
#define IS_LOGGED_IN_KEY                @"IS_LOGGED_IN_KEY"
#define USER_KEY                        @"GUSER_KEY"
#define CURRENT_TRIP_KEY                @"CURRENT_TRIP_KEY"

#define CURRENT_TRIP_ID_KEY             @"currentTripId"
#define DRIVER_CURRENT_TRIP_ID_KEY      @"driverCurrentTripId"


//#define DEFAULT_LAT                     @"-37.8108311"
//#define DEFAULT_LONG                    @"144.9678817"

#define STEP_TITLE_FONT                 [UIFont fontWithName:@"Raleway-Medium" size:22]

#define TRIP_STATUS_APPROACHING     @"1"
#define TRIP_STATUS_IN_PROGRESS     @"2"
#define TRIP_STATUS_PENDING_PAYMENT @"3"
#define TRIP_STATUS_FINISH          @"4"


#define CANCELLATION_ORDER_FEE      @"1"
#define EXCHANGE_POINT              @"2"
#define REDEEM_POINT                @"3"
#define TRANSFER_POINT              @"4"
#define TRIP_PAYMENT                @"5"
#define PASSENGER_SHARE_BONUS       @"6"
#define DRIVER_SHARE_BONUS          @"7"
#endif
