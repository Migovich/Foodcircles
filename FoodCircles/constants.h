#define BASE_URL @"http://joinfoodcircles.org/"

#define USER_COUNT_URL (BASE_URL @"/api/general/users")
#define SIGN_UP_URL (BASE_URL @"/api/sessions/sign_up")
#define SIGN_IN_URL (BASE_URL @"/api/sessions/sign_in")
#define UPDATE_URL (BASE_URL @"/api/sessions/update")
#define VENUES_URL (BASE_URL @"/api/venues/%f/%f")
#define CHARITIES_URL (BASE_URL @"/api/charities")
#define TIMELINE_URL (BASE_URL @"/api/timeline")
#define PAYMENT_URL (BASE_URL @"/api/payments")

//Short URL's
#define PAYMENT_URL_SHORT @"/api/payments"
#define NEWS_URL @"api/news"
#define LOGOUT_URL @"/users/sign_out"
#define DELETE_VOUCHER_URL @"/payment/used"

#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#define kTesterClientId @"AZ-lJhCFTTflkzUugWkJ2i_Q7iSpADJgPtHVAlwGj_nzOSu-Xfzo0yKnI1DW"
#define kClientId @"ATtEOxB-eX60pOi_fHSv3K2PvAX8LRme-eyngA9l6LRSTIr9SeJHtmpaJL4M"
