class EndPoints {
  /// auth
  static const String login = 'auth/login';
  static const String register = 'auth/register';
  static const String refreshToken = 'auth/refresh';
  static const String logout = 'auth/logout';
  static const String logoutAll = 'auth/logout-all';
  static const String sendOtp = 'auth/send-otp';
  static const String verifyOtp = 'auth/verify-otp';
  static const String resendOtp = 'auth/resend-otp';
  static const String checkExists = 'auth/check-exists';
  //static const String profile = 'auth/profile';

  /// blogs
  static const String blogs = 'blogs/api/blogs';
  static const String categories = 'blogs/api/categories';
  static const String tags = 'blogs/api/tags';
  static String blogReactions(String blogId) =>
      'blogs/api/blogs/$blogId/my-reactions';
  static String blogComments(String blogId) =>
      'blogs/api/comments/blog/$blogId';
  static const String popularTags = 'blogs/api/tags/popular';
  static String tagBySlug(String slug) => 'blogs/api/tags/$slug';

  /// pujas
  static const String pujas = 'sri-mandir/api/pujas';
  static String pujaById(String pujaId) => 'sri-mandir/api/pujas/$pujaId';

  /// puja addresses
  static const String pujaAddresses = 'sri-mandir/api/addresses';
  static String pujaAddressById(String addressId) =>
      'sri-mandir/api/addresses/$addressId';
  static String pujaAddressSetDefault(String addressId) =>
      'sri-mandir/api/addresses/$addressId/default';

  /// puja bookings
  static const String pujaBookings = 'sri-mandir/api/bookings';
  static String myBookings(int page, int limit) =>
      'sri-mandir/api/bookings/my-bookings?page=$page&limit=$limit';
  static String bookingDetail(String bookingId) =>
      'sri-mandir/api/bookings/$bookingId';

  /// puja payments
  static const String pujaPaymentInitiate = 'sri-mandir/api/payments/initiate';
  static const String pujaPaymentVerify = 'sri-mandir/api/payments/verify';

  /// god categories
  static const String godCategories = 'sri-mandir/api/god-categories';

  /// puja item categories
  static const String pujaItemCategories =
      'sri-mandir/api/puja-item-categories';
  static String pujaItemCategoryById(String categoryId) =>
      'sri-mandir/api/puja-item-categories/$categoryId';

  /// ecommerce
  // Category endpoints
  static const String ecommerceCategories = 'ecommerce/api/categories';
  static const String ecommerceCategoriesTree = 'ecommerce/api/categories/tree';
  static String ecommerceCategoryById(String id) =>
      'ecommerce/api/categories/$id';
  static String ecommerceCategoryBySlug(String slug) =>
      'ecommerce/api/categories/slug/$slug';
  static String ecommerceCategoryProducts(String categoryId) =>
      'ecommerce/api/categories/$categoryId/products';
  static String ecommerceProductsByCategorySlug(String slug) =>
      'ecommerce/api/products/category/$slug';

  // Product endpoints
  static const String ecommerceProducts = 'ecommerce/api/products';
  static const String ecommerceProductsFeatured =
      'ecommerce/api/products/featured';
  static const String ecommerceProductsTopSelling =
      'ecommerce/api/products/top-selling';
  static String ecommerceProductById(String id) => 'ecommerce/api/products/$id';
  static String ecommerceProductBySlug(String slug) =>
      'ecommerce/api/products/slug/$slug';
  static String ecommerceProductVariants(String productId) =>
      'ecommerce/api/products/$productId/variants';
  static String ecommerceProductRelated(String productId) =>
      'ecommerce/api/products/$productId/related';
  static String ecommerceProductReviews(String productId) =>
      'ecommerce/api/products/$productId/reviews';

  // Cart endpoints
  static const String ecommerceCart = 'ecommerce/api/cart';
  static const String ecommerceCartItems = 'ecommerce/api/cart/items';
  static String ecommerceCartItem(String itemId) =>
      'ecommerce/api/cart/items/$itemId';
  static String ecommerceSavedItemMoveToCart(String savedItemId) =>
      'ecommerce/api/cart/saved-items/$savedItemId/move-to-cart';
  static const String ecommerceCartMerge = 'ecommerce/api/cart/merge';
  static const String ecommerceCartCoupon = 'ecommerce/api/cart/coupon';
  static String ecommerceCartItemSaveForLater(String itemId) =>
      'ecommerce/api/cart/items/$itemId/save-for-later';

  // Addresses
  static const String ecommerceAddresses = 'ecommerce/api/addresses';
  static const String ecommerceAddressesDefault =
      'ecommerce/api/addresses/default';
  static String ecommerceAddressById(String id) =>
      'ecommerce/api/addresses/$id';
  static String ecommerceAddressSetDefault(String id) =>
      'ecommerce/api/addresses/$id/set-default';

  // Orders & Payments
  static const String ecommerceOrders = 'ecommerce/api/orders';
  static const String ecommercePaymentsInitiate =
      'ecommerce/api/payments/initiate';
  static const String ecommercePaymentsVerify = 'ecommerce/api/payments/verify';
  static String ecommerceOrderById(String id) => 'ecommerce/api/orders/$id';
  static String ecommerceOrderByOrderId(String orderId) =>
      'ecommerce/api/orders/order-id/$orderId';
  static String ecommerceOrderHistory(String orderId) =>
      'ecommerce/api/orders/$orderId/history';
  static String ecommerceOrderTrack(String orderId) =>
      'ecommerce/api/orders/$orderId/track';
  static String ecommerceOrderCancel(String orderId) =>
      'ecommerce/api/orders/$orderId/cancel';
  static const String ecommercePayments = 'ecommerce/api/payments';
  static String ecommercePaymentById(String id) => 'ecommerce/api/payments/$id';

  // User Profile (current user - uses Bearer token; no userId in path)
  static const String userProfileCurrent = 'users/api/users/profile';
  static String getUserProfile(String userId) =>
      'users/api/users/profile/$userId';
  static String updateUserProfile(String userId) =>
      'users/api/users/profile/$userId';
  static String updateBirthChart(String userId) =>
      'users/api/users/birth-chart/$userId';

  // Support Tickets
  static const String supportTickets = 'auth/support/tickets';
  static String supportTicketById(String ticketId) =>
      'auth/support/tickets/$ticketId';
  static String supportTicketReply(String ticketId) =>
      'auth/support/tickets/$ticketId/reply';

  // Recommendations
  static const String ecommerceRecommendations =
      'ecommerce/api/recommendations';
  static const String ecommerceRecommendationsPersonalized =
      'ecommerce/api/recommendations/personalized';
  static const String ecommerceRecommendationsRecentlyViewed =
      'ecommerce/api/recommendations/recently-viewed';
  static String ecommerceRecommendationsFrequentlyBought(String productId) =>
      'ecommerce/api/recommendations/frequently-bought-together/$productId';

  // Wishlist
  static const String ecommerceWishlist = 'ecommerce/api/wishlist';
  static const String ecommerceWishlistItems = 'ecommerce/api/wishlist/items';
  static String ecommerceWishlistItem(String productId) =>
      'ecommerce/api/wishlist/items/$productId';
  static String ecommerceWishlistItemMoveToCart(String productId) =>
      'ecommerce/api/wishlist/items/$productId/move-to-cart';

  // Coupons
  static const String ecommerceCouponsAvailable =
      'ecommerce/api/coupons/available';
  static const String ecommerceCouponValidate =
      'ecommerce/api/coupons/validate';
  static String ecommerceCouponByCode(String code) =>
      'ecommerce/api/coupons/code/$code';

  // Search
  static const String ecommerceSearch = 'ecommerce/api/search';
  static const String ecommerceSearchSuggestions =
      'ecommerce/api/search/suggestions';
  static const String ecommerceSearchPopular = 'ecommerce/api/search/popular';

  /// AI Chat Personas
  static const String personaAi = 'astrologers/api/astrologers/persona-ai';
  static const String personaAiCategories =
      'astrologers/api/astrologers/persona-ai/categories';
  static const String personaAiMyPersonas =
      'astrologers/api/astrologers/persona-ai/my-personas';
  static String personaAiById(String id) =>
      'astrologers/api/astrologers/persona-ai/$id';

  // Persona Reviews
  static String personaAiReviews(String personaId) =>
      'astrologers/api/astrologers/persona-ai/$personaId/reviews';
  static String personaAiMyReview(String personaId) =>
      'astrologers/api/astrologers/persona-ai/$personaId/reviews/my-review';
  static String personaAiReviewById(String personaId, String reviewId) =>
      'astrologers/api/astrologers/persona-ai/$personaId/reviews/$reviewId';
  static String personaAiReviewHelpful(String personaId, String reviewId) =>
      'astrologers/api/astrologers/persona-ai/$personaId/reviews/$reviewId/helpful';
  static String personaAiReviewReport(String personaId, String reviewId) =>
      'astrologers/api/astrologers/persona-ai/$personaId/reviews/$reviewId/report';

  // Persona Follow/Unfollow
  static String personaAiFollow(String personaId) =>
      'astrologers/api/astrologers/persona-ai/$personaId/follow';
  static String personaAiUnfollow(String personaId) =>
      'astrologers/api/astrologers/persona-ai/$personaId/unfollow';

  /// Persona AI Voice Call (User)
  static String voiceInitiate(String personaId) =>
      'users/api/users/voice/$personaId/initiate';
  static const String voiceHistory = 'users/api/users/voice/history';
  static const String voiceStats = 'users/api/users/voice/stats';
  static String voiceCallById(String callId) => 'users/api/users/voice/$callId';
  static String voiceUpload(String callId) =>
      'users/api/users/voice/$callId/upload';
  static String voiceProcess(String callId) =>
      'users/api/users/voice/$callId/process';
  static String voiceCancel(String callId) =>
      'users/api/users/voice/$callId/cancel';
  static String voiceDelete(String callId) => 'users/api/users/voice/$callId';

  /// Learning Portal Courses
  static const String courses = 'learning-portal/api/learning-portal/courses';
  static String courseById(String id) =>
      'learning-portal/api/learning-portal/courses/$id';
  static String courseLectures(String courseId) =>
      'learning-portal/api/learning-portal/courses/$courseId/lectures';
  static String lectureById(String id) =>
      'learning-portal/api/learning-portal/lectures/$id';
  static String lectureContent(String lectureId) =>
      'learning-portal/api/learning-portal/lectures/$lectureId/content';
  static String contentById(String id) =>
      'learning-portal/api/learning-portal/content/$id';

  /// Learning Portal Webinars
  static const String liveWebinars =
      'learning-portal/api/learning-portal/webinars/live';
  static const String upcomingWebinars =
      'learning-portal/api/learning-portal/webinars/upcoming';
  static const String webinarHistory =
      'learning-portal/api/learning-portal/webinars/history';

  static String webinarById(String id) =>
      'learning-portal/api/learning-portal/webinars/$id';
  static String joinWebinar(String id) =>
      'learning-portal/api/learning-portal/webinars/$id/join';
  static String leaveWebinar(String id) =>
      'learning-portal/api/learning-portal/webinars/$id/leave';

  /// Learning Portal Orders
  static const String ordersInitiate =
      'learning-portal/api/learning-portal/orders/initiate';
  static const String ordersList = 'learning-portal/api/learning-portal/orders';
  static String orderById(String orderId) =>
      'learning-portal/api/learning-portal/orders/$orderId';
  static String orderInvoice(String orderId) =>
      'learning-portal/api/learning-portal/orders/$orderId/invoice';

  /// Learning Portal Payments
  // Note: Website uses 'learning-portal/payments/process' but app base URL includes '/api/'
  // So we use 'learning-portal/payments/process' to match website format
  static const String paymentsProcess =
      'learning-portal/api/learning-portal/payments/process';
  static const String paymentsVerify =
      'learning-portal/api/learning-portal/payments/verify';

  /// Learning Portal Enrollments
  static const String enrollments =
      'learning-portal/api/learning-portal/enrollments';
  static String enrollmentCheck(String courseId) =>
      'learning-portal/api/learning-portal/enrollments/check/$courseId';
  static String enrollmentById(String enrollmentId) =>
      'learning-portal/api/learning-portal/enrollments/$enrollmentId';

  /// Learning Portal Progress
  static const String progressOverview =
      'learning-portal/api/learning-portal/progress/overview';
  static String progressCourse(String courseId) =>
      'learning-portal/api/learning-portal/progress/course/$courseId';
  static const String progressLecture =
      'learning-portal/api/learning-portal/progress/lecture';
  static const String progressContent =
      'learning-portal/api/learning-portal/progress/content';

  /// Chat APIs
  static String chatSendMessage(String personaId) =>
      'users/api/users/chat/$personaId';
  static String chatGetConversation(String personaId, String conversationId) =>
      'users/api/users/chat/$personaId?conversationId=$conversationId';
  static String chatDeleteConversation(
    String personaId,
    String conversationId,
  ) => 'users/api/users/chat/$personaId/$conversationId';

  /// Astrologers Public API
  static const String astrologersPublic = 'astrologers/api/astrologers/public';

  /// Wallet APIs
  static const String walletRechargeInitiate =
      'users/api/users/wallet/recharge/initiate';
  static const String walletRechargeVerify =
      'users/api/users/wallet/recharge/verify';
  static const String walletRechargeHistory =
      'users/api/users/wallet/recharge/history';
  static String walletRechargeById(String rechargeId) =>
      'users/api/users/wallet/recharge/$rechargeId';
  static String walletRechargeCancel(String rechargeId) =>
      'users/api/users/wallet/recharge/$rechargeId/cancel';
  static String walletBalance(String userId) =>
      'users/api/users/wallet/$userId/balance';

  /// Call APIs
  static const String callInitiate = 'calls/initiate';
  static const String callHistory = 'calls/history';
  static String callEnd(String callId) => 'calls/$callId/end';

  /// Live Streams APIs
  static const String liveStreams = 'calls/api/streams/live';
  static String joinStream(String streamId) =>
      'calls/api/streams/$streamId/join';
  static const String upcomingStreams = 'calls/api/streams/upcoming';
  static String astrologerSchedule(String astrologerId) =>
      'calls/api/streams/astrologer/$astrologerId/schedule';
  static String streamRsvp(String streamId) =>
      'calls/api/streams/$streamId/rsvp';
  static String streamRsvpCount(String streamId) =>
      'calls/api/streams/$streamId/rsvp/count';
  static const String userRsvps = 'calls/api/streams/user/rsvps';
  static const String giftsCatalog = 'calls/api/streams/gifts/catalog';
  static String streamReport(String streamId) =>
      'calls/api/streams/$streamId/report';
  static const String streamReportsMyReports =
      'calls/api/streams/reports/my-reports';

  /// Panchang Routes
  static const String panchang = 'panchang/panchang';
  static const String monthlyCalendar = 'panchang/monthly-calender';
  static const String horaMuhurta = 'panchang/hora-muhurta';
  static const String choghadiyaMuhurta = 'panchang/choghadiya-muhurta';
  static const String sunrise = 'panchang/sunrise';
  static const String sunset = 'panchang/sunset';
  static const String moonrise = 'panchang/moonrise';
  static const String moonset = 'panchang/moonset';
  static const String jainNavkarshi = 'panchang/jain-navkarshi';
  static const String jainKalyanak = 'panchang/jain-kalyanak';

  /// Numerology Routes
  static const String loshuGrid = 'numerology/loshu-grid';
  static const String planeDetails = 'numerology/plane-details';
  static const String numberAnalysis = 'numerology/number-analysis';
  static const String missingNumbers = 'numerology/missing-numbers';
  static const String availableNumbers = 'numerology/available-numbers';
  static const String mobileAnalysis = 'numerology/mobile-analysis';
  static const String numerologySuggestion = 'numerology/numerology-suggestion';
  static const String nameAnalysis = 'numerology/name-analysis';
  static const String vehicleAnalysis = 'numerology/vehicle-analysis';
  static const String luckyThings = 'numerology/lucky-things';
  static const String personalYear = 'numerology/personal-year';
  static const String karmicNumber = 'numerology/karmic-number';
  static const String masterNumbers = 'numerology/master-numbers';
  static const String numerologyReports = 'numerology/reports';
  static String numerologyReportById(String reportId) =>
      'numerology/reports/$reportId';

  /// Astrologer Reviews
  static String astrologerReviews(String astrologerId) =>
      'astrologers/api/astrologers/$astrologerId/reviews';
  static String astrologerReviewById(String astrologerId, String reviewId) =>
      'astrologers/api/astrologers/$astrologerId/reviews/$reviewId';
  static String astrologerReviewHelpful(String astrologerId, String reviewId) =>
      'astrologers/api/astrologers/$astrologerId/reviews/$reviewId/helpful';
  static String astrologerReviewReport(String astrologerId, String reviewId) =>
      'astrologers/api/astrologers/$astrologerId/reviews/$reviewId/report';

  /// Astrologer Follow/Unfollow
  static String astrologerFollow(String astrologerId) =>
      'astrologers/api/astrologers/$astrologerId/follow';
  static String astrologerUnfollow(String astrologerId) =>
      'astrologers/api/astrologers/$astrologerId/follow';
  static String astrologerFollowStatus(String astrologerId) =>
      'astrologers/api/astrologers/$astrologerId/follow/status';
  static String astrologerFollowNotifications(String astrologerId) =>
      'astrologers/api/astrologers/$astrologerId/follow/notifications';
  static String astrologerFollowersCount(String astrologerId) =>
      'astrologers/api/astrologers/$astrologerId/followers/count';
  static const String astrologerFollowing =
      'astrologers/api/astrologers/users/me/following';

  /// Palmistry APIs
  static const String palmistryAnalyze = 'users/api/users/palmistry/analyze';
  static const String palmistryHistory = 'users/api/users/palmistry/history';
  static const String palmistryStats = 'users/api/users/palmistry/stats';
  static String palmistryGetById(String readingId) =>
      'users/api/users/palmistry/$readingId';
  static String palmistryDeleteById(String readingId) =>
      'users/api/users/palmistry/$readingId';

  /// Face Reading APIs
  static const String faceReadingAnalyze = 'api/users/face-reading/analyze';
  static const String faceReadingHistory =
      'users/api/users/face-reading/history';
  static const String faceReadingStats = 'users/api/users/face-reading/stats';
  static String faceReadingGetById(String readingId) =>
      'users/api/users/face-reading/$readingId';
  static String faceReadingDeleteById(String readingId) =>
      'users/api/users/face-reading/$readingId';

  /// Handwriting Astrology APIs
  static const String handwritingAnalyze =
      'users/api/users/handwriting/analyze';
  static const String handwritingHistory =
      'users/api/users/handwriting/history';
  static String handwritingGetById(String readingId) =>
      'users/api/users/handwriting/$readingId';
  static String handwritingDeleteById(String readingId) =>
      'users/api/users/handwriting/$readingId';

  /// Ramal Shastra APIs
  static const String ramalAnalyze = 'api/users/ramal/analyze';
  static const String ramalHistory = 'api/users/ramal/history';
  static const String ramalStats = 'api/users/ramal/stats';
  static String ramalGetById(String readingId) => 'api/users/ramal/$readingId';
  static String ramalDeleteById(String readingId) =>
      'api/users/ramal/$readingId';

  /// Carrot Astrology APIs
  static const String carrotAstrologyAnalyze =
      'users/api/users/carrot-astrology/analyze';
  static const String carrotAstrologyHistory =
      'users/api/users/carrot-astrology/history';
  static const String carrotAstrologyStats =
      'users/api/users/carrot-astrology/stats';
  static String carrotAstrologyGetById(String readingId) =>
      'users/api/users/carrot-astrology/$readingId';

  /// Astrologer Chat APIs (User)
  // static const String chatSessionPurchase = 'chat/session/purchase'; // REMOVED
  static String chatSessionGet(String chatId) => 'chat/session/$chatId';
  static String chatSessionStart(String chatId) => 'chat/session/$chatId/start';
  static String chatSessionEnd(String chatId) => 'chat/session/$chatId/end';
  static const String chatSessionsActive = 'chat/sessions/active';
  static const String chatSessionsHistory = 'chat/sessions/history';
  static String chatSessionMessages(String chatId) =>
      'chat/session/$chatId/messages';
  static String chatSessionMessagesRead(String chatId) =>
      'chat/session/$chatId/messages/read';
  static String chatSessionUploadImage(String chatId) =>
      'chat/session/$chatId/upload-image';
  static String chatSessionRating(String chatId) =>
      'chat/session/$chatId/rating';
  static String chatSessionDownload(String chatId) =>
      'chat/session/$chatId/download';

  /// Kundli/Chart APIs
  static const String generateKundli = 'chart/d1';
  static const String generateNavamsha = 'chart/d9';
  static const String generateMoon = 'chart/moon';
  static const String generateSun = 'chart/sun';
  static const String generateChalit = 'chart/bhav-chalit';
  static const String generateTransit = 'chart/transit-chart';

  // Shodashvarga Chart APIs (D2 removed)
  static const String chartD3 = 'chart/d3';
  static const String chartD4 = 'chart/d4';
  static const String chartD6 = 'chart/d6';
  static const String chartD7 = 'chart/d7';
  static const String chartD8 = 'chart/d8';
  static const String chartD10 = 'chart/d10';
  static const String chartD12 = 'chart/d12';
  static const String chartD16 = 'chart/d16';
  static const String chartD20 = 'chart/d20';
  static const String chartD24 = 'chart/d24';
  static const String chartD27 = 'chart/d27';
  static const String chartD30 = 'chart/d30';
  static const String chartD40 = 'chart/d40';
  static const String chartD45 = 'chart/d45';
  static const String chartD60 = 'chart/d60';

  // Dasha APIs
  static const String currentMahadashaFull = 'dasha/current-mahadasha-full';
  static const String currentMahadasha = 'dasha/current-mahadasha';
  static const String mahadasha = 'dasha/mahadasha';
  static const String yoginiDashaMain = 'dasha/yogini-dasha-main';
  static const String yoginiDashaSub = 'dasha/yogini-dasha-sub';

  // Dosh APIs
  static const String mangalDosh = 'dosh/mangal-dosh';
  static const String manglikDosh = 'dosh/manglik-dosh';
  static const String kaalsarpDosh = 'dosh/kaalsarp-dosh';
  static const String pitraDosh = 'dosh/pitra-dosh';

  // KP Astrology APIs
  static const String kpChart = 'kp-astrology/chart';
  static const String kpRasiChart = 'kp-astrology/rasi-chart';
  static const String kpPlanetDetails = 'kp-astrology/planet-details';
  static const String kpPlanetSignifications =
      'kp-astrology/planet-significations';
  static const String kpHouseSignificators = 'kp-astrology/house-significators';
  static const String kpPlanetSignificatorsLevelWise =
      'kp-astrology/planet-significators-level-wise';
  static const String kpCuspsDetails = 'kp-astrology/cusps-details';

  // Lal Kitab APIs
  static const String lalKitabHoroscope = 'lal-kitab/horoscope';
  static const String lalKitabDebts = 'lal-kitab/debts';
  static const String lalKitabRemedies = 'lal-kitab/remedies';
  static const String lalKitabHouses = 'lal-kitab/houses';
  static const String lalKitabPlanets = 'lal-kitab/planets';
  static const String lalKitabChart = 'lal-kitab/chart';
  static const String lalKitabVarshphalChart = 'lal-kitab/varshphal-chart';

  // Prediction APIs
  static const String predictionNumerology = 'prediction/numerology';
  static const String predictionDaily = 'prediction/daily';
  static const String predictionWeekly = 'prediction/weekly';
  static const String predictionMonthly = 'prediction/monthly';
  static const String predictionYearly = 'prediction/yearly';
  static const String predictionAscendant = 'prediction/ascendant';
  static const String predictionMoon = 'prediction/moon';
  static const String predictionNakshatra = 'prediction/nakshatra';
  static const String predictionPanchang = 'prediction/panchang';

  // Prokerala Horoscope APIs
  static const String prokeralaDaily = 'prokerala/horoscope/daily';
  static const String prokeralaDailyAdvanced =
      'prokerala/horoscope/daily/advanced';
  static const String prokeralaLoveCompatibility =
      'prokerala/horoscope/daily/love-compatibility';

  // Planet Details API
  static const String planetDetails = 'horoscope/planet-details';
  static const String planetTransitDates = 'vedic/western/planet-transit-dates';
  static const String westernTransitChart = 'vedic/western/transit-chart';
  static const String dailyTransits = 'vedic/western/daily-transits';
  static const String dailyTransitPrediction =
      'vedic/western/daily-transit-prediction';
  static const String detailedPlanetReport =
      'vedic/western/detailed-planet-report';
  static const String westernPlanetDetails = 'vedic/western/planet-details';
  static const String aspects = 'vedic/western/aspects';

  // Ashtakvarga API
  static const String ashtakvarga = 'horoscope/ashtakvarga';

  // Binnashtakvarga API
  static const String binnashtakvarga = 'horoscope/binnashtakvarga';

  // Ashtakvarga Chart API
  static const String ashtakvargaChart = 'horoscope/ashtakvarga-chart';

  // Divisional Chart API
  static const String divisionalChart = 'horoscope/divisional-chart';

  // Ascendant Report API
  static const String ascendantReport = 'horoscope/ascendant-report';

  // Varshphal APIs
  static const String varshaphalDetails =
      'extended-horoscope/varshaphal-details';
  static const String varshaphalYearlyChart =
      'extended-horoscope/varshaphal-yearly-chart';

  // Shad Bala API
  static const String shadBalaVedic = 'extended-horoscope/shad-bala-vedic';

  // Extended Horoscope APIs
  static const String extendedKundali = 'extended-horoscope/extended-kundali';
  static const String moonSign = 'extended-horoscope/moon-sign';
  static const String sunSign = 'extended-horoscope/sun-sign';
  static const String ascendantSign = 'extended-horoscope/ascendant-sign';
  static const String currentSadeSati = 'extended-horoscope/current-sade-sati';
  static const String sadeSatiTableVedic =
      'extended-horoscope/sade-sati-table-vedic';
  static const String gemSuggestion = 'extended-horoscope/gem-suggestion';
  static const String gemDetails = 'vedic/utilities/gem-details';
  static const String rudrakshSuggestion =
      'extended-horoscope/rudraksh-suggestion';
  static const String friendshipTable = 'extended-horoscope/friendship-table';
  static const String planetKp = 'extended-horoscope/planet-kp';

  /// Match Making API
  static const String matchMakingAshtakoot =
      'vedic/matching/ashtakoot-with-astro-details';

  /// Banners APIs
  static const String bannersCategories = 'users/api/users/banners/categories';
  static const String bannersAll = 'users/api/users/banners/all';
  static String bannersByCategory(String category) =>
      'users/api/users/banners/category/$category';

  /// Daily Quote APIs
  static const String dailyQuote = 'users/api/users/daily-quote';
  static const String dailyQuoteLanguages =
      'users/api/users/daily-quote/languages';
  static String dailyQuoteHistory({int? offset}) {
    final query = offset != null ? '?offset=$offset' : '';
    return 'users/api/users/daily-quote/history$query';
  }

  /// Tarot Reading APIs
  static const String tarotShuffle = 'vedic/tarot/shuffle';
  static const String tarotYesNo = 'vedic/tarot/yes-no';
  static const String tarotCareer = 'vedic/tarot/career-select';
  static const String tarotLoveTriangle = 'vedic/tarot/love-triangle';
  static const String tarotInDepthLove = 'vedic/tarot/in-depth-love';
  static const String tarotEroticLove = 'vedic/tarot/erotic-love';
  static const String tarotMadeForEachOther = 'vedic/tarot/made-for-each-other';
  static const String tarotFlirtReading = 'vedic/tarot/flirt-reading';
  static const String tarotDaily = 'vedic/tarot/daily';
  static const String tarotRomanticBreakup = 'vedic/tarot/romantic-breakup';
  static const String tarotBusinessBreakup = 'vedic/tarot/business-breakup';
  static const String tarotFortuneCookie = 'vedic/tarot/fortune-cookie';

  /// AI Guider APIs
  static const String aiQuery = 'ai/query';

  static const String freeServicesStatus =
      'users/api/users/free-services/status';

  /// Prashna Kundali APIs
  static const String prashnaKundaliQuestions =
      'users/api/users/prashna-kundali/questions';
  static const String prashnaKundaliAnalyze =
      'users/api/users/prashna-kundali/analyze';
  static const String prashnaKundaliHistory =
      'users/api/users/prashna-kundali/history';
  static String prashnaKundaliGetById(String id) =>
      'users/api/users/prashna-kundali/$id';

  /// Astrologer Registration
  static const String astrologerRegistration =
      'astrologers/api/astrologers/registration-request';
  static const String astrologerRegistrationVerifyOtp =
      'astrologers/api/astrologers/registration-request/verify-otp';
  static const String astrologerRegistrationResendOtp =
      'astrologers/api/astrologers/registration-request/resend-otp';
}
