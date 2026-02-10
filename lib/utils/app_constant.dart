class AppConstant {
  AppConstant._();

  /// Minimum app version required. Users below this version must update before using the app.
  /// Update this when you release a new version (e.g. '1.0.1').
  /// Also add "[Minimum supported app version: X.Y.Z]" to your Play Store app description
  /// (full description or "What's New") so old installs get the minimum version from the store.
  static const String minAppVersion = '9.9.9';

  static const String s3BaseUrl =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com';

  // Google Maps API Key for Geocoding and Places Autocomplete
  static const String googleMapsApiKey =
      'AIzaSyBLAoT6aFAsHaFWBIvK3hha1BDbMzPFOb0';

  // Google Cloud Translation API Key
  static const String googleTranslateApiKey =
      'AIzaSyBcUk-nCY7Je-CFF2uiBJNNlBsE9cE7-JY';

  static const String exitAppImage = 'assets/images/exit-app-image.svg';
  static const String logoutImage = 'assets/images/logout-image.svg';

  static const String noDataFoundImage = 'assets/images/NoResult.png';
  static const String deleteImage = 'assets/images/delete_task.svg';
  static const String closeIcon = 'assets/icons/close-icon.svg';
  static const String pickImageIcon = 'assets/icons/pick-image-icon.svg';

  static const String inProgressIcon = 'assets/icons/Inprogress.svg';
  static const String pendingIcon = 'assets/icons/pending.svg';
  static const String editIcon = 'assets/icons/edit-icon.svg';
  static const String deleteIcon = 'assets/icons/delete.svg';
  static const String callIcon = 'assets/icons/call_icon.svg';
  static const String chatIcon = 'assets/icons/chat_icon_new.svg';

  static const String galleryIcon = 'assets/icons/gallery-icon.svg';
  static const String cameraIcon = 'assets/icons/camera-icon.svg';
  static const String checkIcon = 'assets/icons/check-icon.svg';
  static const String searchIcon = 'assets/icons/search-icon.svg';
  static const String fileIcon = 'assets/icons/file_icon.svg';

  // Dashboard Assets
  static const String guruHoroscope = 'assets/app/guru_horoscope-4a9362.png';
  static const String gemstoneCard = 'assets/app/gemstone_card.png';
  static const String quoteBackground = 'assets/app/quote_background.png';
  static const String quoteOfTheDay =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/AstroBharatAI+User+App/App/quote_of_the_day.png';

  // Onboarding Screen Backgrounds
  static const String onboardingScreen1Bgimg =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/AstroBharatAI+User+App/Onboarding+Screens/onboarding_screen1_bgimg.png';
  static const String onboardingScreen2Bgimg =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/AstroBharatAI+User+App/Onboarding+Screens/onboarding_screen2_bgimg.png';
  static const String onboardingScreen3Bgimg =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/AstroBharatAI+User+App/Onboarding+Screens/onboarding_screen3_bgimg.png';

  // Match Making JSON Files
  static const String matchMakingKundliJson =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/AstroBharatAI+User+App/Json/match_making_kundli.json';
  static const String matchMakingAnimationJson =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/AstroBharatAI+User+App/Json/match_making_animation.json';

  // Kundli Images
  static const String kundliBoy =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/AstroBharatAI+User+App/App/kundliBoy.png';
  static const String kundliGirl =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/AstroBharatAI+User+App/App/kundliGirl.png';

  // Book Images
  static const String book =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/AstroBharatAI+User+App/App/book.png';
  static const String bookBackground =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/AstroBharatAI+User+App/App/book_background.png';

  // Vastu Compass Images
  static const String needle =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/AstroBharatAI+User+App/App/needle.png';
  static const String outerFrame =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/AstroBharatAI+User+App/App/outer_frame.png';
  static const String star =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/AstroBharatAI+User+App/App/star.png';
  static const String zoneRing =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/AstroBharatAI+User+App/App/zone_ring.png';
  static const String directionRing =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/AstroBharatAI+User+App/App/direction_ring.png';

  // Face Reading Images
  static const String faceReadingEx =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/AstroBharatAI+User+App/Face+Reading/face_reading_ex.png';
  static const String faceReadingEx2 =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/AstroBharatAI+User+App/Face+Reading/face_reading_ex_2.png';
  static const String faceReadingEx3 =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/AstroBharatAI+User+App/Face+Reading/face_reading_ex_3.png';
  static const String faceReadingHub =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/AstroBharatAI+User+App/App/FaceReadingHub.png';

  // Palm Reading Images
  static const String palmreadingscreen =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/AstroBharatAI+User+App/App/palmreadingscreen.png';
  static const String palmscan =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/AstroBharatAI+User+App/App/palmscan.png';

  // Free Service Image
  static const String freeservice =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/AstroBharatAI+User+App/App/freeservice.png';

  // Audio Files
  static const String aartiMp3 =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/AstroBharatAI+User+App/Audio/aarti.mp3';
  static const String shankhMp3 =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/AstroBharatAI+User+App/Audio/shankh.mp3';

  static const String templeImage = 'assets/app/temple_image.png';
  static const String templeMahakaleshwar =
      'assets/app/temple_mahakaleshwar.png';
  static const String videoThumbnail = 'assets/app/astrology.svg';
  static const String horoscopeGuru = 'assets/app/guru.png';
  static const String divineShop = 'assets/app/pill_digital_mart.png';
  static const String ePooja = 'assets/app/e_pooja.png';
  static const String aiAstrologer =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/Astro+Service/AIAstrologer.svg';
  static const String education = 'assets/app/pill_digital_education.png';
  static const String poojaAnuj = 'assets/app/pooja_anuj.png';
  static const String poojaAbhishek = 'assets/app/pooja_abhishek.png';
  static const String chantingMala = 'assets/app/chanting_mala.png';
  static const String rudraksha = 'assets/app/rudraksha.png';
  static const String gemstone = 'assets/app/gemstone.png';
  static const String ePoojaRemedy = 'assets/app/e_pooja_remedy.png';
  static const String videoJupiter = 'assets/app/video_jupiter.png';
  static const String blogVedic = 'assets/app/blog_vedic.png';
  static const String blogKundli = 'assets/app/blog_kundli.png';
  static const String astrologerAnuj = 'assets/app/astrologer_anuj-6c8367.png';
  static const String astrologerShashi = 'assets/app/astrologer_shashi.png';
  static const String astrologerPrakhar = 'assets/app/astrologer_prakhar.png';
  static const String astrologerRitik = 'assets/app/astrologer_ritik.png';
  static const String aiGuruVedic = 'assets/app/ai_guru_vedic.png';
  static const String aiTarot = 'assets/app/ai_tarot.png';
  static const String aiNumerology = 'assets/app/ai_numerology.png';
  static const String aiPalm = 'assets/app/ai_palm.png';

  ///
  static const String logo = '$s3BaseUrl/homepageVideos/favicon.ico';
  static const String logoText =
      '$s3BaseUrl/homepageVideos/Frame+1321314931.svg';

  /// astrology tool icons
  static const String astrologyToolTarotReading =
      'assets/images/tarot reading final.png';
  static const String astrologyToolWritingAstrology =
      'assets/images/Writing Astrology.png';
  static const String astrologyToolPrashnKundli =
      'assets/images/prashna final.png';
  static const String astrologyToolFaceReading =
      'assets/images/face reading final.png';
  static const String astrologyToolPalmReading =
      'assets/images/pal reading final.png';
  static const String astrologyToolVastuReading =
      'assets/images/vastu final.png';
  static const String astrologyToolRamalShastra =
      'assets/app/RAMAL SHASTRA.png';

  // ecommerce images
  static const String shopMainBanner =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/AstroBharatAI+User+App/Images/shop_main_banner.png';

  // astrology report images
  static const String astrologyReportBrihatKudli =
      'assets/app/brihat_kundli.png';
  static const String astrologyReportHoroscope2026 =
      'assets/app/horoscope_2026_report.png';
  static const String astrologyYearBookReport =
      'assets/app/year_book_report.png';
  static const String astrologyYearBookReportShani =
      'assets/app/year_book_shani_report.png';
  static const String astrologyRajYogaReport = 'assets/app/raj_yoga_report.png';

  // Service Icons (from Figma)
  static const String service2025 = 'assets/app/service_2025.svg';
  static const String serviceGenerateKundali =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/Astro+Service/3D+Logos/Kundali+3d.png';
  static const String serviceFaceReading =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/Astro+Service/FaceReading.svg';
  static const String servicePalmReading =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/Astro+Service/PalmReading.svg';
  static const String serviceConsult = 'assets/app/service_consult.svg';
  static const String servicePanchang =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/Astro+Service/3D+Logos/panchang+n.png';
  static const String serviceMatchMaking =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/Astro+Service/3D+Logos/kundali+matchinh.png';
  static const String serviceNumerology =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/Astro+Service/3D+Logos/Neumorology+n.png';
  static const String serviceTarot =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/Astro+Service/TarrotCard.svg';
  static const String serviceRasiChart =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/Astro+Service/RasiChart.svg';

  // Common
  static const String fullChakra = 'assets/app/fullchakra.svg';

  // Dashboard card images
  static const String cardConsultation =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/AstroBharatAI+User+App/App/ganeshji_u.png';
  static const String cardPalm = 'assets/app/palmReadingCard.png';
  static const String cardKundli =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/Astro+Service/3D+Logos/Kundali+3d.png';

  static const String tarot = 'assets/app/tarot.svg';

  static const String horoscope =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/Astro+Service/3D+Logos/Horoscope+3d.png';
  static const String vastu =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/Astro+Service/Vastu.png';
  static const String writingAstrology =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/Astro+Service/Writing.svg';
  static const String ramalShastra = 'assets/app/ramalShastra.png';
  static const String carrotAstrology =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/Astro+Service/carrotAstrology.png';

  // 3D Logos for Kundli/Horoscope
  static const String varshpal3d =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/Astro+Service/3D+Logos/Varshpal.png';
  static const String shodashVarga3d =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/Astro+Service/3D+Logos/ShodashVarga.png';
  static const String yog3d =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/Astro+Service/3D+Logos/Yog3d.png';

  // Panchang Icons
  static const String panchangBackButton = 'assets/icons/close-icon.svg';
  static const String sunriseIcon = 'assets/app/sunrise_icon.svg';
  static const String sunsetIcon = 'assets/app/sunset_icon.svg';
  static const String moonriseIcon = 'assets/app/moonrise_icon.svg';
  static const String moonsetIcon = 'assets/app/moonset_icon.svg';
  static const String solarNoonIcon = 'assets/app/solar_noon_icon.svg';
  static const String moonPhaseIcon = 'assets/app/moon_phase_icon.svg';
  static const String dailyPanchangIcon = 'assets/app/daily_panchang_icon.svg';
  static const String monthlyCalendarIcon =
      'assets/app/monthly_calendar_icon.svg';
  static const String hinduCalendarIcon = 'assets/app/hindu_calendar_icon.svg';
  static const String yearlyVratIcon = 'assets/app/yearly_vrat_icon.svg';
  static const String festivalIcon = 'assets/app/festival_icon.svg';
  static const String horaIcon = 'assets/app/hora_icon.svg';
  static const String chogadiaIcon = 'assets/app/chogadia_icon.svg';
  static const String doGhatiIcon = 'assets/app/do_ghati_icon.svg';
  static const String rahuKaalIcon = 'assets/app/rahu_kaal_icon.svg';
  static const String otherCalendarsIcon = 'assets/app/other_calender_icon.svg';
  static const String panchakIcon = 'assets/app/panchak_icon.svg';
  static const String bhadraIcon = 'assets/app/bhadra_icon.svg';
  static const String muhuratIcon = 'assets/app/muhurat_icon.svg';
  static const String lagnaTableIcon = 'assets/app/lagna_table_icon.svg';

  static const String securePaymentOptionIcon =
      'assets/icons/secure_payment_option.png';
  static const String trustedIcon = 'assets/icons/trusted_icon.png';
  static const String verifiedAstrologersIcon =
      'assets/icons/verified_astrologer_icon.png';

  // astro remedy images

  // shop banner images
  static const String shopBanner1 =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/AstroBharatAI+User+App/Images/BANNER+1.png';
  static const String shopBanner2 =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/AstroBharatAI+User+App/Images/BANNER+2.png';
  static const String shopBanner3 =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/AstroBharatAI+User+App/Images/BANNER+3.png';
  static const String shopBanner4 =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/AstroBharatAI+User+App/Images/BANNER+4.png';
  static const String shopBanner5 =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/AstroBharatAI+User+App/Images/BANNER+5.png';

  // cunsultation category icons

  static const String consultationCategoryHoroScopes =
      'assets/icons/horoscope_category.png';
  static const String consultationCategoryKundli =
      'assets/icons/kudli_category.png';
  static const String consultationCategoryCompatibility =
      'assets/icons/compatibility_category.png';
  static const String consultationCategoryNumerology =
      'assets/icons/numerology_category.png';
  static const String consultationCategoryTarot =
      'assets/icons/tarot_reading_category.png';
  static const String consultationCategoryRemedies =
      'assets/icons/ramedies_category.png';

  static const String prashnaKundali = 'assets/app/prashnakundali.svg';

  static const String lifePredictions =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/Astro+Service/3D+Logos/Life+prediction+n.png';

  static const String dosh =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/Astro+Service/3D+Logos/dosh+n.png';

  static const String dasha =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/Astro+Service/3D+Logos/dasha+n.png';

  static const String kPAstrology =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/Astro+Service/3D+Logos/KP+ASTROLOGY.png';
  static const String kpN =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/Astro+Service/3D+Logos/kp+n.png';

  static const String lalKitab =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/Astro+Service/3D+Logos/lal+kitab+n.png';

  static const String gemstone2 = 'assets/app/gemstone2.png';
  static const String pendent = 'assets/app/pendent.png';
  static const String pendent2 = 'assets/app/pendent2.png';

  static const String astroBharatLogo = 'assets/app/AstrobharatAi .svg';

  // Zodiac Sign Images
  static const String zodiacAries =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/Zodiac+Signs/Aries.png';
  static const String zodiacTaurus =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/Zodiac+Signs/Taurus.png';
  static const String zodiacGemini =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/Zodiac+Signs/Gemini.png';
  static const String zodiacCancer =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/Zodiac+Signs/Cancer.png';
  static const String zodiacLeo =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/Zodiac+Signs/Leo.png';
  static const String zodiacVirgo =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/Zodiac+Signs/Virgo.png';
  static const String zodiacLibra =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/Zodiac+Signs/Libra.png';
  static const String zodiacScorpio =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/Zodiac+Signs/Scorpio.png';
  static const String zodiacSagittarius =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/Zodiac+Signs/Saggitarius.png';
  static const String zodiacCapricorn =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/Zodiac+Signs/Capricorn.png';
  static const String zodiacAquarius =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/Zodiac+Signs/Aquarius.png';
  static const String zodiacPisces =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/Zodiac+Signs/Pisces.png';

  // E-Mandir Images
  static const String eMandirGanesha = 'assets/images/ganesha.png';
  static const String eMandirLiveDarshan = 'assets/images/live_darshan.png';
  static const String eMandirAartiIcon = 'assets/images/aarti_icon.png';
  static const String eMandirThaliIcon =
      'https://astrobharatai.s3.ap-south-1.amazonaws.com/AstroBharatAI+User+App/Sri+Mandir/Agarbatti+thali.svg';
  static const String eMandirPlayIcon = 'assets/images/play_icon.png';
  static const String eMandirEPuja = 'assets/images/e_puja.png';
  static const String eMandirLibraryAarti = 'assets/images/liberary_arti.png';
  static const String eMandirPlusIcon = 'assets/images/plus_icon.png';
  static const String eMandirGodIcon = 'assets/images/god_icon.png';
  static const String eMandirLadduIcon = 'assets/images/laddu_icon.png';
  static const String eMandirListenNowIcon =
      'assets/images/listen_now_icon.png';
  static const String eMandirGoldenTemple = 'assets/images/golder temple.png';
  static const String eMandirMeenakshiTemple =
      'assets/images/meenakshi temple.png';
  static const String eMandirTirupatiBalaji =
      'assets/images/tirupatiBalaji.jpg';
  static const String eMandirOmmIcon = 'assets/images/omm_icon.png';
  static const String eMandirRemMandir = 'assets/images/rem_mandir.png';
  static const String eMandirLightImage = 'assets/images/light_image.png';
  static const String eMandirChakraLeft = 'assets/images/chakraleft.png';
  static const String eMandirPassbookOom = 'assets/images/passbook_oom.png';
  static const String eMandirChakra = 'assets/images/chakra.png';
  static const String eMandirLockChakra = 'assets/images/lock_chakra.png';
  static const String eMandirSankhIcon = 'assets/images/sankh_icon.png';
  static const String eMandirFlower1 = 'assets/images/flower1.png';
  static const String eMandirFlower2 = 'assets/images/flower2.png';
  static const String eMandirFlower3 = 'assets/images/flower3.png';
  static const String eMandirFlower = 'assets/images/flower.png';
  static const String eMandirShriGanesh = 'assets/images/shri_ganesh.png';
  static const String eMandirButton1 = 'assets/images/Button (1).png';
  static const String eMandirButton2 = 'assets/images/Button (2).png';
  static const String eMandirButton3 = 'assets/images/Button (3).png';
  static const String eMandirButton4 = 'assets/images/Button (4).png';

  /// Digital Education images
  /// digital education Spiritual Pillars images

  static const String dESpriritualPillarsLalKitab =
      '$s3BaseUrl/Digital+Learning/laalKitab.jpeg';

  static const String dESpriritualPillarsVedicAstrology =
      '$s3BaseUrl/Digital+Learning/VedicAstrology.png';

  static const String dESpriritualPillarsKPAstrology =
      '$s3BaseUrl/Digital+Learning/KPastrology.png';

  static const String dESpriritualPillarsGemstoneScience =
      '$s3BaseUrl/Digital+Learning/gemstoneScience.png';

  static const String dESpriritualPillarsNumerology =
      '$s3BaseUrl/Digital+Learning/numerology.png';

  static const String dESpriritualPillarsVaastuShastra =
      '$s3BaseUrl/Digital+Learning/VaastuShastra.png';

  static const String dESpriritualPillarsFaceReading =
      '$s3BaseUrl/Digital+Learning/faceReading.png';

  static const String dESpriritualPillarsReikiHealing =
      '$s3BaseUrl/Digital+Learning/ReikiHealing.png';

  static const String dESpriritualPillarsTarotReading =
      '$s3BaseUrl/Digital+Learning/TarotReading.png';

  static const String dESpriritualPillarsNakshatra =
      '$s3BaseUrl/Digital+Learning/nakshtra.png';

  static const String dESpriritualPillarsRudrakshScience =
      '$s3BaseUrl/Digital+Learning/RudrakshScience.png';

  static const String dESpriritualPillarsPalmistry =
      '$s3BaseUrl/Digital+Learning/palmistry.png';

  /// digital education  banners
  static const String dEBanner1 =
      '$s3BaseUrl/Digital+Learning/DigitalBannerVideo.mp4';
  static const String dEBanner2 =
      '$s3BaseUrl/Digital+Learning/LiveClasses+Banner.png';
  static const String dEBanner3 =
      '$s3BaseUrl/Digital+Learning/DigitalLearningBanner.png';

  /// digital education key course module images
  static const String dEKeyCourseModule1 =
      '$s3BaseUrl/Digital+Learning/EnergyConnection.png';
  static const String dEKeyCourseModule2 =
      '$s3BaseUrl/Digital+Learning/RealVsFake.png';
  static const String dEKeyCourseModule3 =
      '$s3BaseUrl/Digital+Learning/kpusingpalmand+face.png';
  static const String dEKeyCourseModule4 =
      '$s3BaseUrl/Digital+Learning/ethics.png';

  /// digital education Specialized Mastery Bundles
  static const String dESpecializedMasteryBundles1 =
      '$s3BaseUrl/Digital+Learning/astrologyMasterBundle.png';
  static const String dESpecializedMasteryBundles2 =
      '$s3BaseUrl/Digital+Learning/energyandhealing.png';
  static const String dESpecializedMasteryBundles3 =
      '$s3BaseUrl/Digital+Learning/personality.png';

  static const String dESpecializedMasteryBundles4 =
      '$s3BaseUrl/Digital+Learning/GrandMasterImage.png';
  static const String consultation =
      '$s3BaseUrl/Astro+Service/3D+Logos/consultation+3d.png';

  ///
}

class InstagramConstant {
  static const String instagramAccessToken = '';
  static const String instagramProfileUrl =
      'https://www.instagram.com/astrobharatai';
}
