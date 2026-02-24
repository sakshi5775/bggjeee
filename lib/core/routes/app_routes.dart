class AppRoutes {
  static const String root = '/root';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String otp = '/otp';
  static const String forgotPassword = '/forgot-password';
  static const String forgotPasswordOtp = '/forgot-password-otp';
  static const String resetPassword = '/reset-password';

  // Dashboard Routes
  static const String userDashboard = '/user-dashboard';
  static const String astrologyServices = '/astrology-services';
  static const String allAstrologers = '/all-astrologers';
  static const String astrologerDetail = '/astrologer-detail';
  static const String liveAstrologers = '/live-astrologers';
  static const String booking = '/booking';
  static const String chat = '/chat';
  static const String astrologerChat = '/astrologer-chat';
  static const String astrologerChatHistory = '/astrologer-chat-history';
  static const String consultationHistory = '/consultation-history';
  static const String allReports = '/all-reports';
  static const String allVideos = '/all-videos';
  static const String astrologerVoiceCall = '/astrologer-voice-call';
  static const String astrologerVideoCall = '/astrologer-video-call';
  static const String aichat = '/ai-chat';

  // Blog Routes

  static const String blogDetail = '/blog-detail';
  static const String createBlog = '/create-blog';
  static const String editBlog = '/edit-blog';
  static const String blogComments = '/blog-comments';

  static const String allBlogs = '/all-blogs';

  // E-commerce Routes
  static const String ecommerceHome = '/ecommerce-home';
  static const String productList = '/product-list';
  static const String productDetail = '/product-detail';
  static const String cart = '/cart';
  static const String savedItems = '/saved-items';
  static const String wishlist = '/wishlist';
  static const String profile = '/profile';
  static const String orders = '/orders';
  static const String orderDetail = '/orders/detail';
  static const String search = '/search';
  static const String payments = '/payments';
  static const String paymentDetail = '/payments/detail';
  static const String addresses = '/addresses';
  static const String coupons = '/coupons';
  static const String followingAstrologers = '/following-astrologers';
  static const String remedies = '/remedies';
  static const String remedyCategoryListing = '/remedy-category-listing';

  // Support Tickets Routes
  static const String supportTickets = '/support-tickets';
  static const String createSupportTicket = '/create-support-ticket';
  static const String supportTicketDetail = '/support-ticket-detail';

  // Courses Routes
  static const String courses = '/courses';
  static const String courseDetail = '/course-detail';
  static const String coursePlayer = '/course-player';
  static const String contentPlayer = '/content-player';
  static const String liveWebinars = '/live-webinars';
  static const String liveWebinarSession = '/live-webinar-session';
  static const String myLearning = '/my-learning';
  static const String spiritualPillarCourses = '/spiritual-pillar-courses';

  // Chat Routes
  static const String personaChat = '/persona-chat';
  static const String personaDetail = '/persona-detail';
  static const String personaVoiceCall = '/persona-voice-call';
  static const String personaVoiceHistory = '/persona-voice-history';

  // Wallet Routes
  static const String wallet = '/wallet';

  // Horoscope Routes
  static const String horoscope = '/horoscope';
  static const String horoscopeForm = '/horoscope-form';
  static const String horoscopeSignSelection = '/horoscope-sign-selection';
  static const String horoscopeMain = '/horoscope-main';

  // Palm Reading Routes
  static const String palmReading = '/palm-reading';
  static const String palmReadingHistory = '/palm-reading-history';
  static const String palmReadingForm = '/palm-reading-form';
  static const String palmReadingTime = '/palm-reading-time';
  static const String palmReadingHandGender = '/palm-reading-hand-gender';
  static const String palmReadingUpload = '/palm-reading-upload';
  static const String palmReadingCamera = '/palm-reading-camera';
  static const String palmReadingScanning = '/palm-reading-scanning';
  static const String palmReadingResults = '/palm-reading-results';
  static const String palmReadingDetail = '/palm-reading-detail';
  static const String palmReadingAnalysis = '/palm-reading-analysis';

  // Face Reading Routes
  static const String faceReading = '/face-reading';
  static const String faceReadingUpload = '/face-reading-upload';
  static const String faceReadingScanning = '/face-reading-scanning';
  static const String faceReadingResults = '/face-reading-results';
  static const String faceReadingCategoryDetail =
      '/face-reading-category-detail';
  static const String faceReadingFeatureDetail = '/face-reading-feature-detail';
  static const String faceReadingHistory = '/face-reading-history';

  // Handwriting Astrology Routes
  static const String handwritingAstrology = '/handwriting-astrology';
  static const String handwritingAstrologyUpload =
      '/handwriting-astrology-upload';
  static const String handwritingAstrologyResults =
      '/handwriting-astrology-results';
  static const String handwritingAstrologyHistory =
      '/handwriting-astrology-history';

  // Tarot Card Reading Routes
  static const String tarotReading = '/tarot-reading';

  // Carrot Astrology Routes
  static const String carrotAstrology = '/carrot-astrology';
  static const String carrotAstrologyForm = '/carrot-astrology-form';
  static const String carrotAstrologySignSelection =
      '/carrot-astrology-sign-selection';
  static const String carrotAstrologyResults = '/carrot-astrology-results';
  static const String carrotAstrologyHistory = '/carrot-astrology-history';

  // Vastu Reading Routes
  static const String vastuReading = '/vastu-reading';
  static const String vastuDashboard = '/vastu-dashboard';
  static const String homeVastuList = '/home-vastu-list';
  static const String homeVastuCompass = '/home-vastu-compass';
  static const String officeVastuList = '/office-vastu-list';
  static const String officeVastuCompass = '/office-vastu-compass';
  static const String vastuDosh = '/vastu-dosh';
  static const String vastuShastra = '/vastu-shastra';
  static const String vastuTips = '/vastu-tips';
  static const String arVastu = '/ar-vastu';
  static const String arOnboarding = '/ar-onboarding';
  static const String vastuCorrection = '/vastu-correction';
  static const String expertMode = '/expert-mode';

  // Live Stream Reports Routes
  static const String streamReports = '/stream-reports';

  // Panchang Routes
  static const String panchang = '/panchang';
  static const String dailyPanchang = '/daily-panchang';
  static const String monthlyCalendar = '/monthly-calendar';
  static const String festivalDetail = '/festival-detail';
  static const String hinduCalendar = '/hindu-calendar';
  static const String festivalFiltered = '/festival-filtered';
  static const String yearlyVrat = '/yearly-vrat';
  static const String festivalYearly = '/festival-yearly';
  static const String hora = '/hora';
  static const String chogadia = '/chogadia';
  static const String rahukaal = '/rahukaal';
  static const String bhadra = '/bhadra';
  static const String muhurat = '/muhurat';
  static const String otherCalendars = '/other-calendars';
  static const String jainCalendar = '/jain-calendar';
  static const String hinduCalendarMonthlyPanchang =
      '/hindu-calendar-monthly-panchang';
  static const String moonCalendar = '/moon-calendar';

  // Kundli Routes
  static const String kundliForm = '/kundli-form';
  static const String kundliResult = '/kundli-result';
  static const String shodashvarga = '/shodashvarga';
  static const String dasha = '/dasha';
  static const String yog = '/yog';
  static const String dosh = '/dosh';
  static const String sadeSati = '/sade-sati';
  static const String gemstonesReport = '/gemstones-report';
  static const String transitToday = '/transit-today';
  static const String kpSystem = '/kp-system';
  static const String lalKitab = '/lal-kitab';
  static const String varshphal = '/varshphal';
  static const String predictions = '/predictions';
  static const String planets = '/planets';
  static const String birthDetails = '/birth-details';
  static const String comingSoon = '/coming-soon';

  // Numerology Routes
  static const String numerology = '/numerology';
  static const String numerologyForm = '/numerology-form';
  static const String numerologyFeatures = '/numerology-features';
  static const String numerologyResult = '/numerology-result';
  static const String numerologyReports = '/numerology-reports';
  static const String numerologyKeyPoints = '/numerology-key-points';
  static const String loshuGridForm = '/loshu-grid-form';
  static const String loshuGridResult = '/loshu-grid-result';

  // Match Making Routes
  static const String matchMakingGif = '/match-making-gif';
  static const String matchMakingForm = '/match-making-form';
  static const String matchMakingResult = '/match-making-result';
  static const String matchMakingFullKundli = '/match-making-full-kundli';

  // AI Guider Route
  static const String aiGuider = '/ai-guider';

  // Prashna Kundali Routes
  static const String prashnaKundali = '/prashna-kundali';
  static const String prashnaKundaliHistory = '/prashna-kundali-history';
  static const String prashnaKundaliResults = '/prashna-kundali-results';

  // Ramal Shastra Routes
  static const String ramalShastra = '/ramal-shastra';
  static const String ramalShastraIntro = '/ramal-shastra-intro';
  static const String ramalShastraQuestion = '/ramal-shastra-question';
  static const String ramalShastraMethod = '/ramal-shastra-method';
  static const String ramalShastraCastingDice = '/ramal-shastra-casting-dice';
  static const String ramalShastraCastingCards = '/ramal-shastra-casting-cards';
  static const String ramalShastraCastingDots = '/ramal-shastra-casting-dots';
  static const String ramalShastraConfirmation = '/ramal-shastra-confirmation';
  static const String ramalShastraLoading = '/ramal-shastra-loading';
  static const String ramalShastraResults = '/ramal-shastra-results';
  static const String ramalShastraHistory = '/ramal-shastra-history';
  static const String ramalShastraStats = '/ramal-shastra-stats';
  static const String ramalShastraDetail = '/ramal-shastra-detail';

  // E-Mandir Routes
  static const String namasteHome = '/e-mandir-home';
  static const String punyaMudra = '/punya-mudra';
  static const String virtualDarshan = '/virtual-darshan';
  static const String devotionalLibrary = '/devotional-library';
  static const String devotionalPlayer = '/devotional-player';
  static const String lyrics = '/lyrics';
  static const String meaning = '/meaning';
  static const String bhaktiChakra = '/bhakti-chakra';
  static const String passbook = '/passbook';
  static const String bookPuja = '/book-puja';
  static const String pujaDetail = '/puja-detail';
  static const String addressSelection = '/address-selection';
  static const String addressForm = '/address-form';
  static const String pujaBookingForm = '/puja-booking-form';
  static const String myBookings = '/my-bookings';
  static const String myBookingDetail = '/my-booking-detail';

  // E-Mandir Festival Routes
  static const String eMandirFestivalDetail = '/e-mandir-festival-detail';
  static const String allFestivals = '/all-festivals';
  static const String aboutUs = '/about-us';

  // Astrologer Registration Routes
  static const String astrologerRegistrationIntro =
      '/astrologer-registration-intro';
  static const String astrologerRegistrationForm =
      '/astrologer-registration-form';
  static const String astrologerRegistrationOtp =
      '/astrologer-registration-otp';
  static const String userPrivacyPolicy = '/user-privacy-policy';
  static const String reportPdfView = '/report-pdf-view';
  static const String navtaraDashboard = '/navtara-dashboard';
  static const String kundliReportHistory = '/kundli-report-history';
}
