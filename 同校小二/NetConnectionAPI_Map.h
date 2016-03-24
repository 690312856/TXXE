//
//  NetConnectionAPI_Map.h
//  TXXE
//
//  Created by River on 15/6/7.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#ifndef TXXE_NetConnectionAPI_Map_h
#define TXXE_NetConnectionAPI_Map_h

typedef NS_ENUM(NSInteger, API_InterfaceType){

    API_good_JsonDetail                                 ,
    API_home_Data                                       ,
    API_good_list                                       ,
    API_category_list                                   ,
    API_good_JsonDetaill                                ,
    API_user_login                                      ,
    API_school_list                                     ,
    API_favorite_add                                    ,
    API_favorite_remove                                 ,
    API_phone_captcha                                   ,
    API_user_register                                   ,
    API_good_service_create                             ,
    API_user_center_data                                ,
    API_user_verify                                     ,
    API_Profile_update                                  ,
    API_good_my_goods                                   ,
    API_ask_list                                        ,
    API_system_message                                  ,
    API_comment_message                                 ,
    API_goods_addReview                                 ,
    API_good_change_sale_status                         ,
    API_user_my_favorites                               ,
    API_ask_my_ask                                      ,
    API_get_myscore                                     ,
    API_ask_create                                      ,
    API_ask_change_bought_status                        ,
    API_good_update                                     ,
    API_ask_JsonDetail                                  ,
    API_ask_update                                      ,
    API_good_delete_create                              ,
    API_ask_delete_create                               ,
    API_systemMessage_hadRead                           ,
    API_good_report                                     ,
    API_report_reason                                   ,
    API_ask_report                                      ,
    API_function_list                                   ,
    API_commentMessage_hadRead                          ,
    API_asks_addReview                                  ,
    API_Weixin_login                                    ,
    API_lostPassword                                    ,
    API_passwordReset                                   ,
    API_about_us                                        ,
    API_score_rule                                      ,
    API_feed_back                                       ,
    API_check_message                                   ,
};
#endif
