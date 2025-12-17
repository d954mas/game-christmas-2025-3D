---@meta

---@class FirebaseInitializeOptions
---@field api_key string|nil
---@field app_id string|nil
---@field database_url string|nil
---@field messaging_sender_id string|nil
---@field project_id string|nil
---@field storage_bucket string|nil

---@class FirebaseMessage
---@field token number|nil for MSG_INSTALLATION_AUTH_TOKEN
---@field id number|nil for MSG_INSTALLATION_ID
---@field error string|nil error text for MSG_ERROR

---@alias FirebaseCallback fun(self:any, message_id:number, message:FirebaseMessage)

---@class FirebaseSdk
firebase = {}

---@param options FirebaseInitializeOptions|nil optional init params overriding google-services config
function firebase.initialize(options) end

---Request the Firebase Installation auth token.
function firebase.get_installation_auth_token() end

---@param callback FirebaseCallback|nil callback receiving firebase events, nil removes callback
function firebase.set_callback(callback) end

---Request the Firebase Installation id.
function firebase.get_installation_id() end

---@type number
firebase.MSG_ERROR = 0

---@type number
firebase.MSG_INITIALIZED = 1

---@type number
firebase.MSG_INSTALLATION_AUTH_TOKEN = 2

---@type number
firebase.MSG_INSTALLATION_ID = 3

---@class FirebaseAnalyticsMessage
---@field error string|nil error text for MSG_ERROR
---@field instance_id string|nil instance id for MSG_INSTANCE_ID

---@alias FirebaseAnalyticsCallback fun(self:any, message_id:number, message:FirebaseAnalyticsMessage)

---@class FirebaseAnalyticsSdk
firebase.analytics = {}

---Initialize Firebase Analytics.
function firebase.analytics.initialize() end

---@param callback FirebaseAnalyticsCallback|nil callback receiving analytics events, nil removes callback
function firebase.analytics.set_callback(callback) end

---Log an event without parameters.
---@param name string
function firebase.analytics.log(name) end

---Log an event with one string parameter.
---@param name string
---@param parameter_name string
---@param parameter_value string
function firebase.analytics.log_string(name, parameter_name, parameter_value) end

---Log an event with one integer parameter.
---@param name string
---@param parameter_name string
---@param parameter_value number
function firebase.analytics.log_int(name, parameter_name, parameter_value) end

---Log an event with one float parameter.
---@param name string
---@param parameter_name string
---@param parameter_value number
function firebase.analytics.log_number(name, parameter_name, parameter_value) end

---Log an event with table parameters.
---@param name string
---@param parameters_table table<string, any>
function firebase.analytics.log_table(name, parameters_table) end

---Sets default event parameters.
---@param default_params table<string, any>
function firebase.analytics.set_default_event_params(default_params) end

---Sets the user ID property.
---@param user_id string
function firebase.analytics.set_user_id(user_id) end

---Set a user property to the given value.
---@param name string
---@param property string
function firebase.analytics.set_user_property(name, property) end

---Clears all analytics data for this app and resets the app instance id.
function firebase.analytics.reset() end

---Get the analytics instance id. Result delivered via callback with MSG_INSTANCE_ID.
function firebase.analytics.get_id() end

---Sets whether analytics collection is enabled for this app on this device.
---@param enabled boolean
function firebase.analytics.set_enabled(enabled) end

---@type number
firebase.analytics.MSG_ERROR = 0

---@type number
firebase.analytics.MSG_INSTANCE_ID = 1

---@type string
firebase.analytics.EVENT_ADIMPRESSION = "EVENT_ADIMPRESSION"
---@type string
firebase.analytics.EVENT_ADDPAYMENTINFO = "EVENT_ADDPAYMENTINFO"
---@type string
firebase.analytics.EVENT_ADDSHIPPINGINFO = "EVENT_ADDSHIPPINGINFO"
---@type string
firebase.analytics.EVENT_ADDTOCART = "EVENT_ADDTOCART"
---@type string
firebase.analytics.EVENT_ADDTOWISHLIST = "EVENT_ADDTOWISHLIST"
---@type string
firebase.analytics.EVENT_APPOPEN = "EVENT_APPOPEN"
---@type string
firebase.analytics.EVENT_BEGINCHECKOUT = "EVENT_BEGINCHECKOUT"
---@type string
firebase.analytics.EVENT_CAMPAIGNDETAILS = "EVENT_CAMPAIGNDETAILS"
---@type string
firebase.analytics.EVENT_EARNVIRTUALCURRENCY = "EVENT_EARNVIRTUALCURRENCY"
---@type string
firebase.analytics.EVENT_GENERATELEAD = "EVENT_GENERATELEAD"
---@type string
firebase.analytics.EVENT_JOINGROUP = "EVENT_JOINGROUP"
---@type string
firebase.analytics.EVENT_LEVELEND = "EVENT_LEVELEND"
---@type string
firebase.analytics.EVENT_LEVELSTART = "EVENT_LEVELSTART"
---@type string
firebase.analytics.EVENT_LEVELUP = "EVENT_LEVELUP"
---@type string
firebase.analytics.EVENT_LOGIN = "EVENT_LOGIN"
---@type string
firebase.analytics.EVENT_POSTSCORE = "EVENT_POSTSCORE"
---@type string
firebase.analytics.EVENT_PURCHASE = "EVENT_PURCHASE"
---@type string
firebase.analytics.EVENT_REFUND = "EVENT_REFUND"
---@type string
firebase.analytics.EVENT_REMOVEFROMCART = "EVENT_REMOVEFROMCART"
---@type string
firebase.analytics.EVENT_SCREENVIEW = "EVENT_SCREENVIEW"
---@type string
firebase.analytics.EVENT_SEARCH = "EVENT_SEARCH"
---@type string
firebase.analytics.EVENT_SELECTCONTENT = "EVENT_SELECTCONTENT"
---@type string
firebase.analytics.EVENT_SELECTITEM = "EVENT_SELECTITEM"
---@type string
firebase.analytics.EVENT_SELECTPROMOTION = "EVENT_SELECTPROMOTION"
---@type string
firebase.analytics.EVENT_SHARE = "EVENT_SHARE"
---@type string
firebase.analytics.EVENT_SIGNUP = "EVENT_SIGNUP"
---@type string
firebase.analytics.EVENT_SPENDVIRTUALCURRENCY = "EVENT_SPENDVIRTUALCURRENCY"
---@type string
firebase.analytics.EVENT_TUTORIALBEGIN = "EVENT_TUTORIALBEGIN"
---@type string
firebase.analytics.EVENT_TUTORIALCOMPLETE = "EVENT_TUTORIALCOMPLETE"
---@type string
firebase.analytics.EVENT_UNLOCKACHIEVEMENT = "EVENT_UNLOCKACHIEVEMENT"
---@type string
firebase.analytics.EVENT_VIEWCART = "EVENT_VIEWCART"
---@type string
firebase.analytics.EVENT_VIEWITEM = "EVENT_VIEWITEM"
---@type string
firebase.analytics.EVENT_VIEWITEMLIST = "EVENT_VIEWITEMLIST"
---@type string
firebase.analytics.EVENT_VIEWPROMOTION = "EVENT_VIEWPROMOTION"
---@type string
firebase.analytics.EVENT_VIEWSEARCHRESULTS = "EVENT_VIEWSEARCHRESULTS"

---@type string
firebase.analytics.PARAM_ADFORMAT = "PARAM_ADFORMAT"
---@type string
firebase.analytics.PARAM_ADNETWORKCLICKID = "PARAM_ADNETWORKCLICKID"
---@type string
firebase.analytics.PARAM_ADPLATFORM = "PARAM_ADPLATFORM"
---@type string
firebase.analytics.PARAM_ADSOURCE = "PARAM_ADSOURCE"
---@type string
firebase.analytics.PARAM_ADUNITNAME = "PARAM_ADUNITNAME"
---@type string
firebase.analytics.PARAM_AFFILIATION = "PARAM_AFFILIATION"
---@type string
firebase.analytics.PARAM_CP1 = "PARAM_CP1"
---@type string
firebase.analytics.PARAM_CAMPAIGN = "PARAM_CAMPAIGN"
---@type string
firebase.analytics.PARAM_CAMPAIGNID = "PARAM_CAMPAIGNID"
---@type string
firebase.analytics.PARAM_CHARACTER = "PARAM_CHARACTER"
---@type string
firebase.analytics.PARAM_CONTENT = "PARAM_CONTENT"
---@type string
firebase.analytics.PARAM_CONTENTTYPE = "PARAM_CONTENTTYPE"
---@type string
firebase.analytics.PARAM_COUPON = "PARAM_COUPON"
---@type string
firebase.analytics.PARAM_CREATIVEFORMAT = "PARAM_CREATIVEFORMAT"
---@type string
firebase.analytics.PARAM_CREATIVENAME = "PARAM_CREATIVENAME"
---@type string
firebase.analytics.PARAM_CREATIVESLOT = "PARAM_CREATIVESLOT"
---@type string
firebase.analytics.PARAM_CURRENCY = "PARAM_CURRENCY"
---@type string
firebase.analytics.PARAM_DESTINATION = "PARAM_DESTINATION"
---@type string
firebase.analytics.PARAM_DISCOUNT = "PARAM_DISCOUNT"
---@type string
firebase.analytics.PARAM_ENDDATE = "PARAM_ENDDATE"
---@type string
firebase.analytics.PARAM_EXTENDSESSION = "PARAM_EXTENDSESSION"
---@type string
firebase.analytics.PARAM_FLIGHTNUMBER = "PARAM_FLIGHTNUMBER"
---@type string
firebase.analytics.PARAM_GROUPID = "PARAM_GROUPID"
---@type string
firebase.analytics.PARAM_INDEX = "PARAM_INDEX"
---@type string
firebase.analytics.PARAM_ITEMBRAND = "PARAM_ITEMBRAND"
---@type string
firebase.analytics.PARAM_ITEMCATEGORY = "PARAM_ITEMCATEGORY"
---@type string
firebase.analytics.PARAM_ITEMCATEGORY2 = "PARAM_ITEMCATEGORY2"
---@type string
firebase.analytics.PARAM_ITEMCATEGORY3 = "PARAM_ITEMCATEGORY3"
---@type string
firebase.analytics.PARAM_ITEMCATEGORY4 = "PARAM_ITEMCATEGORY4"
---@type string
firebase.analytics.PARAM_ITEMCATEGORY5 = "PARAM_ITEMCATEGORY5"
---@type string
firebase.analytics.PARAM_ITEMID = "PARAM_ITEMID"
---@type string
firebase.analytics.PARAM_ITEMLISTID = "PARAM_ITEMLISTID"
---@type string
firebase.analytics.PARAM_ITEMLISTNAME = "PARAM_ITEMLISTNAME"
---@type string
firebase.analytics.PARAM_ITEMNAME = "PARAM_ITEMNAME"
---@type string
firebase.analytics.PARAM_ITEMVARIANT = "PARAM_ITEMVARIANT"
---@type string
firebase.analytics.PARAM_ITEMS = "PARAM_ITEMS"
---@type string
firebase.analytics.PARAM_LEVEL = "PARAM_LEVEL"
---@type string
firebase.analytics.PARAM_LEVELNAME = "PARAM_LEVELNAME"
---@type string
firebase.analytics.PARAM_LOCATION = "PARAM_LOCATION"
---@type string
firebase.analytics.PARAM_LOCATIONID = "PARAM_LOCATIONID"
---@type string
firebase.analytics.PARAM_MARKETINGTACTIC = "PARAM_MARKETINGTACTIC"
---@type string
firebase.analytics.PARAM_MEDIUM = "PARAM_MEDIUM"
---@type string
firebase.analytics.PARAM_METHOD = "PARAM_METHOD"
---@type string
firebase.analytics.PARAM_NUMBEROFNIGHTS = "PARAM_NUMBEROFNIGHTS"
---@type string
firebase.analytics.PARAM_NUMBEROFPASSENGERS = "PARAM_NUMBEROFPASSENGERS"
---@type string
firebase.analytics.PARAM_NUMBEROFROOMS = "PARAM_NUMBEROFROOMS"
---@type string
firebase.analytics.PARAM_ORIGIN = "PARAM_ORIGIN"
---@type string
firebase.analytics.PARAM_PAYMENTTYPE = "PARAM_PAYMENTTYPE"
---@type string
firebase.analytics.PARAM_PRICE = "PARAM_PRICE"
---@type string
firebase.analytics.PARAM_PROMOTIONID = "PARAM_PROMOTIONID"
---@type string
firebase.analytics.PARAM_PROMOTIONNAME = "PARAM_PROMOTIONNAME"
---@type string
firebase.analytics.PARAM_QUANTITY = "PARAM_QUANTITY"
---@type string
firebase.analytics.PARAM_SCORE = "PARAM_SCORE"
---@type string
firebase.analytics.PARAM_SCREENCLASS = "PARAM_SCREENCLASS"
---@type string
firebase.analytics.PARAM_SCREENNAME = "PARAM_SCREENNAME"
---@type string
firebase.analytics.PARAM_SEARCHTERM = "PARAM_SEARCHTERM"
---@type string
firebase.analytics.PARAM_SHIPPING = "PARAM_SHIPPING"
---@type string
firebase.analytics.PARAM_SHIPPINGTIER = "PARAM_SHIPPINGTIER"
---@type string
firebase.analytics.PARAM_SOURCE = "PARAM_SOURCE"
---@type string
firebase.analytics.PARAM_SOURCEPLATFORM = "PARAM_SOURCEPLATFORM"
---@type string
firebase.analytics.PARAM_STARTDATE = "PARAM_STARTDATE"
---@type string
firebase.analytics.PARAM_SUCCESS = "PARAM_SUCCESS"
---@type string
firebase.analytics.PARAM_TAX = "PARAM_TAX"
---@type string
firebase.analytics.PARAM_TERM = "PARAM_TERM"
---@type string
firebase.analytics.PARAM_TRANSACTIONID = "PARAM_TRANSACTIONID"
---@type string
firebase.analytics.PARAM_TRAVELCLASS = "PARAM_TRAVELCLASS"
---@type string
firebase.analytics.PARAM_VALUE = "PARAM_VALUE"
---@type string
firebase.analytics.PARAM_VIRTUALCURRENCYNAME = "PARAM_VIRTUALCURRENCYNAME"

---@type string
firebase.analytics.PROP_ALLOWADPERSONALIZATIONSIGNALS = "PROP_ALLOWADPERSONALIZATIONSIGNALS"
---@type string
firebase.analytics.PROP_SIGNUPMETHOD = "PROP_SIGNUPMETHOD"
