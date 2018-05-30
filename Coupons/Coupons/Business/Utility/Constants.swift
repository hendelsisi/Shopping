
//  Constants.swift
//  Arabian Center
//
//  Created by hend elsisi on 3/22/18.
//  Copyright © 2018 hend elsisi. All rights reserved.
//

import Foundation

enum AlertType {
    case SHARE_ALERT,
    CART_ALERT,
    NETWORK_ALERT,
    LOGIN_ALERT,
    HINT_ALERT
}

struct Constants {
    // AppURl
    static let EmailRegExp = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
  
    //User Defalts
    static let IMAGES_COUNT = "imageCount"
    static let VIDEOS_COUNT = "VideosCount"
    
    struct StoryBoardSegue {
        static let showImagesViewController = "showImagesViewController"
        static let imagesViewContainer = "imagesViewContainer"
    }
    struct CollectionViewCell {
         static let brandCell = "BrandCell"
    }
    
    struct TableViewCell {
        static let offerCell = "OfferCell"
        static let walletCell = "WalletCell"
    }
    
    struct CoreData {
        static let modelName = "Converted"
         static let offerEntityName = "Offer"
        static let walletEntityName = "MyWallet"
        static let sortCoupTableKey = "coup_id"
         static let sortWalletTableKey = "facebook_post"
    }
    
    
    struct NSNotification {
        static let iapHelperProductPurchasedNotification = "iapHelperProductPurchasedNotification"
        static let iapHelperTransactionFailNotification = "iapHelperTransactionFailNotification"
    }
    
    struct UserDefaults {
        static let registeredKey = "registered"
       
    }
    
    
    
    struct IAP {
        static let productId = ""
    }
}
//#define Constants_h
//let IS_IPAD = UI_USER_INTERFACE_IDIOM() == .pad
//let IS_IPHONE = UI_USER_INTERFACE_IDIOM() == .phone
//let IS_RETINA = UIScreen.main.scale >= 2.0
//let SCREEN_WIDTH = UIScreen.main.bounds.size.width
//let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
//let SCREEN_MAX_LENGTH = max(SCREEN_WIDTH, SCREEN_HEIGHT)
//let SCREEN_MIN_LENGTH = min(SCREEN_WIDTH, SCREEN_HEIGHT)
//let IS_ZOOMED = IS_IPHONE && SCREEN_MAX_LENGTH == 736.0
//let IS_IPHONE_4_OR_LESS = IS_IPHONE && SCREEN_MAX_LENGTH < 568.0
//let IS_IPHONE_5 = IS_IPHONE && SCREEN_MAX_LENGTH == 568.0
//let IS_IPHONE_6 = IS_IPHONE && SCREEN_MAX_LENGTH == 667.0
//let IS_IPHONE_6P = IS_IPHONE && SCREEN_MAX_LENGTH == 736.0
//let IS_IPHONE_X = IS_IPHONE && SCREEN_MAX_LENGTH == 812.0
//let IS_IPHONE_6_OR_HIGHER = IS_IPHONE && SCREEN_MAX_LENGTH >= 667.0
////#define FACEBOOK_PERMISSIONS [@"public_profile",@"email",@"user_friends"]
//let FACEBOOK_URL = "https://itunes.apple.com/app/id284882215"
//let ALERT_SECOND_OPTION = "Cancel"
//let VALUE_PARAMETER_REQUEST = "id,name,email"
//let KEY_PARAMETER_REQUEST = "fields"
//let GRAPH_PATH = "me"
//let USER_EMAIL_KEY = "email"
//let CELL_IDENTIFIER = "giftcell"
//let TITLE_CELL_IDENTIFIER = "title"
//let MENU_CELL_IDENTIFIER = "tuple"
//let BRAND_CELL_IDENTIFIER = "myCell"
//let COUPON_CELL_IDENTIFIER = "SimpleTableItem"
//let FIRST_COUP_IDIMG = "aCoupons_screen_H&M"
//let SECOND_COUP_IDIMG = "bCoup_screen_bodyShop"
//let THIRD_COUP_IDIMG = "cCoup_screen_costa"
//let FOURTH_COUP_IDIMG = "dCoup_screen_kfc"
//let NOTIFICATION_CENTER_BACK_HOME = "return"
//let CART_SEGUE_IDENTIFIER = "myCart"
//let CLAIM_SEGUE_IDENTIFIER = "Claim"
//let LOGIN_SEGUE_IDENTIFIER = "LOGIN"
//let VIEW_COUPON = "viewGift"
//let FIRST_COUPON_DESCRIPTION = "50% off at H&M,or online via promo code FRINDS (03/31)"
//let SECOND_COUPON_DESCRIPTION = "$5 off $25 at The Body Shop or online via promo code SDOSAVE525 (03/31)"
//let THIRD_COUPON_DESCRIPTION = "50% off a single item at A.C. Moore (03/31)"
//let FOURTH_COUPON_DESCRIPTION = "Second lunch free today at KFC (03/31)"
//let COUPONS_ENTITY_NAME = "CouponsEntity"
//let DATA_BASE_MODEL_NAME = "CouponsModel"
//let USER_DEFAULTS_LONG_KEY = "long"
//let USER_DEFAULTS_LATIT_KEY = "latit"
//let CART_ENTITY_NAME = "CartEntity"
//let COULUM_KEY_SORT = "coup_id"
//let NOTIFICATION_CONDITION = "updateNotification"
//let CART_ICON_NAME = "icon-gift-card"
//let NOTIFICATION_ID = "MyCoupons"
//let MY_GIFTS_STORYBOARD_ID = "MyGiftsViewController"
//let LEFT_MENU_STORYBOARD_ID = "LeftMenuTable"
//let PAGER_CONTENT_STORYBOARD_ID = "PageContentViewController"
//let PAGER_CONTROLLER_STORYBOARD_ID = "PageViewController"
//let HINT_STORYBOARD_ID = "PopUp"
//let BOX_STORYBOARD_ID = "GetGifts"
//let NAVIGATION_STORYBOARD_ID = "newNavigation"
//let MENU_CONTROLLER_STORYBOARD_ID = "LeftController"
//let COUPON_STORYBOARD_ID = "ViewScreen"
//let MY_CART_SEGUE_IDENTIFIER = "myCartScreen"
//let STORYBOARD_NAME = "Main"
//let ROOT_SEGUE_IDENTIFIER = "GoDirect"
//let USER_DEFAULTS_BADGE_KEY = "coup_badge"
//let USER_DEFAULTS_REG_KEY = "RegisteredUser"
//let USER_DEFAULTS_EMAIL_KEY = "userEmail"
//let USER_DEFAULTS_VISITOR_KEY = "TutorialSeen"
//let USER_DEFAULTS_POP_UP_KEY = "showPopup"
//let USER_DEFAULTS_WIN_KEY = "showGifts"
//let NOTIFICATION_TIME_INTERVAL = 30
//let TOTAL_STORES_NUMBER = 20
//let EMAIL_REG_EXP = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
//let SPLASH_IMAGE = "Grid-img"
//let CHECKED_BRAND_IMG = "checked_cell_icon"
//let DESELECT_BRAND_IMG = "deselect_cell_icon"

