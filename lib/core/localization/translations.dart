import 'package:astrobharataiuser/core/enums/app_language.dart';
import 'package:astrobharataiuser/core/localization/language_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Translation helper class for static strings
/// For dynamic content from APIs, handle translations at API level
class Translations {
  // Common
  static String get appName => _getTranslation('AstroBharatAI', 'एस्ट्रोभारतAI');

  // Auth
  static String get login => _getTranslation('Login', 'लॉगिन');
  static String get signUp => _getTranslation('Sign Up', 'साइन अप');
  static String get logout => _getTranslation('Logout', 'लॉगआउट');
  static String get email => _getTranslation('Email', 'ईमेल');
  static String get password => _getTranslation('Password', 'पासवर्ड');
  static String get phone => _getTranslation('Phone', 'फोन');
  static String get username => _getTranslation('Username', 'उपयोगकर्ता नाम');
  static String get confirmPassword =>
      _getTranslation('Confirm Password', 'पासवर्ड की पुष्टि करें');
  static String get enterOtp => _getTranslation('Enter OTP', 'OTP दर्ज करें');
  static String get resendOtp =>
      _getTranslation('Resend OTP', 'OTP पुनः भेजें');
  static String get verify => _getTranslation('Verify', 'सत्यापित करें');
  static String get dontHaveAccount =>
      _getTranslation("Don't have an account?", 'खाता नहीं है?');
  static String get alreadyHaveAccount =>
      _getTranslation('Already have an account?', 'पहले से खाता है?');
  static String get verifyYourIdentity =>
      _getTranslation('Verify Your Identity', 'अपनी पहचान सत्यापित करें');
  static String get enterOtpMessage => _getTranslation(
    'Please enter the 4-digit code sent to your number.',
    'कृपया अपने नंबर पर भेजे गए 4-अंकीय कोड दर्ज करें।',
  );
  static String get resendOtpIn =>
      _getTranslation('Resend OTP in', 'OTP पुनः भेजें');
  static String get verifying =>
      _getTranslation('Verifying...', 'सत्यापित हो रहा है...');
  static String get verifyProceed =>
      _getTranslation('Verify & Proceed', 'सत्यापित करें और आगे बढ़ें');
  static String get changePhoneNumber => _getTranslation(
    'I would like to change phone number',
    'मैं फोन नंबर बदलना चाहूंगा',
  );
  static String get createAccount =>
      _getTranslation('Create Account', 'खाता बनाएं');
  static String get joinUsStarted =>
      _getTranslation('Join us to get started', 'शुरू करने के लिए हमसे जुड़ें');
  static String get selectUserType =>
      _getTranslation('Select User Type', 'उपयोगकर्ता प्रकार चुनें');
  static String get creatingAccount =>
      _getTranslation('Creating Account...', 'खाता बनाया जा रहा है...');
  static String get signIn => _getTranslation('Sign In', 'साइन इन करें');
  static String get phoneNumberOrEmail =>
      _getTranslation('Phone Number or Email', 'फोन नंबर या ईमेल');
  static String get enterPhoneOrEmail => _getTranslation(
    'Enter your phone number or email',
    'अपना फोन नंबर या ईमेल दर्ज करें',
  );
  static String get enterPassword =>
      _getTranslation('Enter your password', 'अपना पासवर्ड दर्ज करें');
  static String get forgotPassword =>
      _getTranslation('Forgot Password?', 'पासवर्ड भूल गए?');
  static String get signInContinue =>
      _getTranslation('Sign in to continue', 'जारी रखने के लिए साइन इन करें');

  // User Types
  static String get user => _getTranslation('User', 'उपयोगकर्ता');

  // Dashboard
  static String get dashboard => _getTranslation('Dashboard', 'डैशबोर्ड');
  static String get userDashboard =>
      _getTranslation('User Dashboard', 'उपयोगकर्ता डैशबोर्ड');
  static String get welcome => _getTranslation('Welcome', 'स्वागत है');
  static String get quickActions =>
      _getTranslation('Quick Actions', 'त्वरित कार्य');
  static String get recentActivity =>
      _getTranslation('Recent Activity', 'हाल की गतिविधि');

  // Blogs
  static String get blogs => _getTranslation('Blogs', 'ब्लॉग');
  static String get myBlogs => _getTranslation('Blogs', 'ब्लॉग');
  static String get createBlog => _getTranslation('Create Blog', 'ब्लॉग बनाएं');
  static String get editBlog =>
      _getTranslation('Edit Blog', 'ब्लॉग संपादित करें');
  static String get blogTitle => _getTranslation('Blog Title', 'ब्लॉग शीर्षक');
  static String get blogContent =>
      _getTranslation('Blog Content', 'ब्लॉग सामग्री');
  static String get categories => _getTranslation('Categories', 'श्रेणियां');
  static String get tags => _getTranslation('Tags', 'टैग');
  static String get status => _getTranslation('Status', 'स्थिति');
  static String get publish => _getTranslation('Publish', 'प्रकाशित करें');
  static String get draft => _getTranslation('Draft', 'ड्राफ्ट');
  static String get active => _getTranslation('Active', 'सक्रिय');
  static String get search => _getTranslation('Search', 'खोजें');
  static String get delete => _getTranslation('Delete', 'हटाएं');
  static String get edit => _getTranslation('Edit', 'संपादित करें');
  static String get comments => _getTranslation('Comments', 'टिप्पणियां');
  static String get addComment =>
      _getTranslation('Add Comment', 'टिप्पणी जोड़ें');
  static String get noComments =>
      _getTranslation('No comments yet', 'अभी तक कोई टिप्पणी नहीं');
  static String get writeComment =>
      _getTranslation('Write a comment...', 'टिप्पणी लिखें...');

  // Profile
  static String get profile => _getTranslation('Profile', 'प्रोफ़ाइल');
  static String get schedule => _getTranslation('Schedule', 'अनुसूची');
  static String get settings => _getTranslation('Settings', 'सेटिंग्स');
  static String get language => _getTranslation('Language', 'भाषा');
  static String get changeLanguage =>
      _getTranslation('Change Language', 'भाषा बदलें');
  static String get selectLanguage =>
      _getTranslation('Select Language', 'भाषा चुनें');

  // Common Actions
  static String get save => _getTranslation('Save', 'सहेजें');
  static String get cancel => _getTranslation('Cancel', 'रद्द करें');
  static String get submit => _getTranslation('Submit', 'जमा करें');
  static String get refresh => _getTranslation('Refresh', 'ताज़ा करें');
  static String get loading => _getTranslation('Loading', 'लोड हो रहा है');
  static String get noDataFound =>
      _getTranslation('No data found', 'कोई डेटा नहीं मिला');
  static String get comingSoon =>
      _getTranslation('Coming Soon', 'जल्द ही आ रहा है');
  static String get thisFeatureAvailableSoon => _getTranslation(
    'This feature will be available soon!',
    'यह सुविधा जल्द ही उपलब्ध होगी!',
  );

  // Horoscope, Shop, Chat (User Dashboard)
  static String get horoscope => _getTranslation('Horoscope', 'राशिफल');
  static String get shop => _getTranslation('Shop', 'दुकान');
  static String get chat => _getTranslation('Chat', 'चैट');
  static String get home => _getTranslation('Home', 'होम');


  // Common Dashboard Strings
  static String get totalConsultations =>
      _getTranslation('Total Consultations', 'कुल परामर्श');
  static String get pending => _getTranslation('Pending', 'लंबित');
  static String get rating => _getTranslation('Rating', 'रेटिंग');
  static String get earnings => _getTranslation('Earnings', 'आय');
  static String get totalUsers =>
      _getTranslation('Total Users', 'कुल उपयोगकर्ता');
  static String get consultations =>
      _getTranslation('Consultations', 'परामर्श');
  static String get revenue => _getTranslation('Revenue', 'राजस्व');
  static String get liveChat => _getTranslation('Live Chat', 'लाइव चैट');
  static String get startConsultation =>
      _getTranslation('Start Consultation', 'परामर्श शुरू करें');
  static String get videoCall => _getTranslation('Video Call', 'वीडियो कॉल');
  static String get videoConsultation =>
      _getTranslation('Video Consultation', 'वीडियो परामर्श');
  static String get manageAppointments =>
      _getTranslation('Manage Appointments', 'नियुक्तियां प्रबंधित करें');
  static String get manageArticles =>
      _getTranslation('Manage Articles', 'लेख प्रबंधित करें');
  static String get recentConsultations =>
      _getTranslation('Recent Consultations', 'हाल के परामर्श');
  static String get clientName => _getTranslation('Client', 'ग्राहक');
  static String get type => _getTranslation('Type', 'प्रकार');
  static String get time => _getTranslation('Time', 'समय');
  static String get completed => _getTranslation('Completed', 'पूर्ण');
  static String get viewEdit =>
      _getTranslation('View & Edit', 'देखें और संपादित करें');
  static String get readComment =>
      _getTranslation('Read & Comment', 'पढ़ें और टिप्पणी करें');
  static String get dailyReading =>
      _getTranslation('Daily Reading', 'दैनिक पढ़ना');
  static String get pastReadings =>
      _getTranslation('Past Readings', 'पिछली पढ़ाई');
  static String get manageUsers =>
      _getTranslation('Manage Users', 'उपयोगकर्ता प्रबंधित करें');
  static String get viewEditUsers =>
      _getTranslation('View & Edit Users', 'उपयोगकर्ता देखें और संपादित करें');
  static String get analytics => _getTranslation('Analytics', 'विश्लेषण');
  static String get viewReports =>
      _getTranslation('View Reports', 'रिपोर्ट देखें');
  static String get appConfiguration =>
      _getTranslation('App Configuration', 'ऐप कॉन्फ़िगरेशन');
  static String get newUserRegistered =>
      _getTranslation('New User Registered', 'नया उपयोगकर्ता पंजीकृत');
  static String get consultationCompleted =>
      _getTranslation('Consultation Completed', 'परामर्श पूर्ण');
  static String get chatConsultation =>
      _getTranslation('Chat Consultation', 'चैट परामर्श');
  static String get hoursAgo => _getTranslation('hours ago', 'घंटे पहले');
  static String get hourAgo => _getTranslation('hour ago', 'घंटा पहले');
  static String get joinedThePlatform =>
      _getTranslation('joined the platform', 'प्लेटफॉर्म से जुड़ा');
  static String get history => _getTranslation('History', 'इतिहास');
  static String get accountCreated =>
      _getTranslation('Account Created', 'खाता बनाया गया');
  static String get welcomeToAstrologyApp => _getTranslation(
    'Welcome to Astrology App',
    'ज्योतिष ऐप में आपका स्वागत है',
  );
  static String get justNow => _getTranslation('Just now', 'अभी');
  static String get dailyHoroscope =>
      _getTranslation('Daily Horoscope', 'दैनिक राशिफल');
  static String get checkDailyReading =>
      _getTranslation('Check your daily reading', 'अपनी दैनिक पढ़ाई देखें');
  static String get deleteBlog => _getTranslation('Delete Blog', 'ब्लॉग हटाएं');
  static String get areYouSureDelete => _getTranslation(
    'Are you sure you want to delete',
    'क्या आप वाकई हटाना चाहते हैं',
  );
  static String get thisActionCannotUndone => _getTranslation(
    'This action cannot be undone',
    'इस क्रिया को पूर्ववत नहीं किया जा सकता',
  );
  static String get all => _getTranslation('All', 'सभी');
  static String get drafts => _getTranslation('Drafts', 'ड्राफ्ट');
  static String get underReview =>
      _getTranslation('Under Review', 'समीक्षा के अधीन');
  static String get published => _getTranslation('Published', 'प्रकाशित');
  static String get untitled => _getTranslation('Untitled', 'बिना शीर्षक');
  static String get noExcerptAvailable =>
      _getTranslation('No excerpt available', 'कोई उद्धरण उपलब्ध नहीं');
  static String get daysAgo => _getTranslation('days ago', 'दिन पहले');
  static String get minutesAgo => _getTranslation('minutes ago', 'मिनट पहले');
  static String get unknown => _getTranslation('Unknown', 'अज्ञात');
  static String get searchArticlesByTitle => _getTranslation(
    'Search articles by title or keyword',
    'शीर्षक या कीवर्ड से लेख खोजें',
  );
  static String get readingTime =>
      _getTranslation('Reading Time', 'पढ़ने का समय');
  static String get views => _getTranslation('Views', 'दृश्य');
  static String get by => _getTranslation('By', 'द्वारा');
  static String get on => _getTranslation('On', 'पर');
  static String get share => _getTranslation('Share', 'साझा करें');
  static String get allComments =>
      _getTranslation('All Comments', 'सभी टिप्पणियां');
  static String get noCommentsFound =>
      _getTranslation('No comments found', 'कोई टिप्पणी नहीं मिली');
  static String get postComment =>
      _getTranslation('Post Comment', 'टिप्पणी पोस्ट करें');
  static String get like => _getTranslation('Like', 'पसंद');
  static String get liked => _getTranslation('Liked', 'पसंद किया गया');
  static String get reply => _getTranslation('Reply', 'जवाब दें');
  static String get enterYourComment =>
      _getTranslation('Enter your comment', 'अपनी टिप्पणी दर्ज करें');
  static String get selectCategories =>
      _getTranslation('Select Categories', 'श्रेणियां चुनें');
  static String get selectTags => _getTranslation('Select Tags', 'टैग चुनें');
  static String get selected => _getTranslation('Selected', 'चयनित');
  static String get noCategoriesFound =>
      _getTranslation('No categories found', 'कोई श्रेणी नहीं मिली');
  static String get noTagsFound =>
      _getTranslation('No tags found', 'कोई टैग नहीं मिला');
  static String get addCategory =>
      _getTranslation('Add Category', 'श्रेणी जोड़ें');
  static String get addTag => _getTranslation('Add Tag', 'टैग जोड़ें');
  static String get keywords => _getTranslation('Keywords', 'कीवर्ड');
  static String get enterKeywords => _getTranslation(
    'Enter keywords separated by commas',
    'कॉमा से अलग कीवर्ड दर्ज करें',
  );
  static String get featuredImage =>
      _getTranslation('Featured Image', 'फीचर्ड इमेज');
  static String get selectImage => _getTranslation('Select Image', 'छवि चुनें');
  static String get changeImage => _getTranslation('Change Image', 'छवि बदलें');
  static String get excerpt => _getTranslation('Excerpt', 'उद्धरण');
  static String get enterExcerpt =>
      _getTranslation('Enter a brief excerpt', 'एक संक्षिप्त उद्धरण दर्ज करें');
  static String get metaTitle => _getTranslation('Meta Title', 'मेटा शीर्षक');
  static String get metaDescription =>
      _getTranslation('Meta Description', 'मेटा विवरण');
  static String get publishDate =>
      _getTranslation('Publish Date', 'प्रकाशन तिथि');
  static String get selectPublishDate =>
      _getTranslation('Select Publish Date', 'प्रकाशन तिथि चुनें');
  static String get information => _getTranslation('Information', 'जानकारी');
  // static String get comments => _getTranslation('Comments', 'टिप्पणियां');

  // Blog Creation/Edit Translations
  static String get basicInformation =>
      _getTranslation('Basic Information', 'मूल जानकारी');
  static String get media => _getTranslation('Media', 'मीडिया');
  static String get publishing => _getTranslation('Publishing', 'प्रकाशन');
  static String get seoSettings =>
      _getTranslation('SEO Settings', 'SEO सेटिंग्स');
  static String get categoriesAndTags =>
      _getTranslation('Categories & Tags', 'श्रेणियां और टैग');
  static String get saving =>
      _getTranslation('Saving...', 'सहेजा जा रहा है...');
  static String get updateBlog =>
      _getTranslation('Update Blog', 'ब्लॉग अपडेट करें');
  static String get noCategoriesSelected =>
      _getTranslation('No categories selected', 'कोई श्रेणी चयनित नहीं');
  static String get noTagsSelected =>
      _getTranslation('No tags selected', 'कोई टैग चयनित नहीं');
  static String get done => _getTranslation('Done', 'पूर्ण');
  static String get noKeywordsAdded => _getTranslation(
    'No keywords added yet',
    'अभी तक कोई कीवर्ड नहीं जोड़ा गया',
  );
  static String get noImageSelected =>
      _getTranslation('No image selected', 'कोई छवि चयनित नहीं');
  static String get tapToSelectImage =>
      _getTranslation('Tap to select an image', 'छवि चुनने के लिए टैप करें');
  static String get authorType => _getTranslation('Author Type', 'लेखक प्रकार');
  static String get reviewed => _getTranslation('Reviewed', 'समीक्षित');
  static String get titleRequired => _getTranslation('Title *', 'शीर्षक *');
  static String get enterBlogTitle =>
      _getTranslation('Enter blog title', 'ब्लॉग शीर्षक दर्ज करें');
  static String get excerptRequired => _getTranslation('Excerpt *', 'उद्धरण *');
  static String get enterBriefDescription => _getTranslation(
    'Enter a brief description',
    'एक संक्षिप्त विवरण दर्ज करें',
  );
  static String get contentRequired =>
      _getTranslation('Content *', 'सामग्री *');
  static String get writeBlogContent => _getTranslation(
    'Write your blog content here...',
    'अपनी ब्लॉग सामग्री यहां लिखें...',
  );
  static String get seoTitleHint => _getTranslation(
    'SEO title for search engines',
    'सर्च इंजन के लिए SEO शीर्षक',
  );
  static String get seoDescriptionHint => _getTranslation(
    'SEO description for search engines',
    'सर्च इंजन के लिए SEO विवरण',
  );
  static String get enterKeywordAndPress => _getTranslation(
    'Enter keyword and press +',
    'कीवर्ड दर्ज करें और + दबाएं',
  );

  // Profile Translations
  static String get about => _getTranslation('About', 'के बारे में');
  static String get fullName => _getTranslation('Full Name', 'पूरा नाम');
  static String get dateOfBirth =>
      _getTranslation('Date of Birth', 'जन्म तिथि');
  static String get gender => _getTranslation('Gender', 'लिंग');
  static String get experience => _getTranslation('Experience', 'अनुभव');
  static String get qualifications =>
      _getTranslation('Qualifications', 'योग्यता');
  static String get year => _getTranslation('Year', 'वर्ष');
  static String get contactInformation =>
      _getTranslation('Contact Information', 'संपर्क जानकारी');
  static String get yearsOfExperience =>
      _getTranslation('Years of Experience', 'वर्षों का अनुभव');
  static String get reviews => _getTranslation('Reviews', 'समीक्षाएं');
  static String get thisMonth => _getTranslation('This Month', 'इस महीने');
  static String get services => _getTranslation('Services', 'सेवाएं');
  static String get liveStreaming =>
      _getTranslation('Live Streaming', 'लाइव स्ट्रीमिंग');
  static String get availability => _getTranslation('Availability', 'उपलब्धता');
  static String get notAvailable =>
      _getTranslation('Not Available', 'उपलब्ध नहीं');
  static String get financial => _getTranslation('Financial', 'वित्तीय');
  static String get totalEarnings =>
      _getTranslation('Total Earnings', 'कुल आय');
  static String get bankDetails =>
      _getTranslation('Bank Details', 'बैंक विवरण');
  static String get accountHolder =>
      _getTranslation('Account Holder', 'खाताधारक');
  static String get accountNumber =>
      _getTranslation('Account Number', 'खाता संख्या');
  static String get ifscCode => _getTranslation('IFSC Code', 'IFSC कोड');
  static String get bankName => _getTranslation('Bank Name', 'बैंक का नाम');
  static String get recentWithdrawals =>
      _getTranslation('Recent Withdrawals', 'हाल की निकासी');
  static String get noReviewsYet =>
      _getTranslation('No reviews yet', 'अभी तक कोई समीक्षा नहीं');
  static String get retry => _getTranslation('Retry', 'पुनः प्रयास करें');
  static String get profileNotFound =>
      _getTranslation('Profile not found', 'प्रोफ़ाइल नहीं मिली');
  static String get addressLabel => _getTranslation('Address', 'पता');
  static String get phoneCall => _getTranslation('Phone Call', 'फोन कॉल');

  // Verification Translations
  static String get verification => _getTranslation('Verification', 'सत्यापन');
  static String get verified => _getTranslation('Verified', 'सत्यापित');
  static String get notVerified => _getTranslation('Not Verified', 'असत्यापित');

  // Profile Edit Translations
  static String get editProfile =>
      _getTranslation('Edit Profile', 'प्रोफ़ाइल संपादित करें');
  static String get updateProfile =>
      _getTranslation('Update Profile', 'प्रोफ़ाइल अपडेट करें');
  static String get displayName =>
      _getTranslation('Display Name', 'प्रदर्शन नाम');
  static String get enterFullName =>
      _getTranslation('Enter full name', 'पूरा नाम दर्ज करें');
  static String get enterDisplayName =>
      _getTranslation('Enter display name', 'प्रदर्शन नाम दर्ज करें');
  static String get enterEmail =>
      _getTranslation('Enter email', 'ईमेल दर्ज करें');
  static String get enterPhone =>
      _getTranslation('Enter phone number', 'फोन नंबर दर्ज करें');
  static String get alternatePhone =>
      _getTranslation('Alternate Phone', 'वैकल्पिक फोन');
  static String get enterAlternatePhone =>
      _getTranslation('Enter alternate phone', 'वैकल्पिक फोन दर्ज करें');
  static String get enterBio =>
      _getTranslation('Enter bio', 'जीवनी दर्ज करें');
  static String get profilePicture =>
      _getTranslation('Profile Picture', 'प्रोफ़ाइल चित्र');
  static String get voice => _getTranslation('Voice', 'आवाज');
  static String get video => _getTranslation('Video', 'वीडियो');
  static String get languages =>
      _getTranslation('Languages', 'भाषाएं');
  static String get specializations =>
      _getTranslation('Specializations', 'विशेषज्ञताएं');
  static String get bio => _getTranslation('Bio', 'जीवनी');

  // Helper method to get translation based on current language
  static String _getTranslation(String english, String hindi) {
    try {
      if (Get.isRegistered<LanguageController>()) {
        final controller = Get.find<LanguageController>();
        return controller.currentLanguage.value == AppLanguage.hindi
            ? hindi
            : english;
      }
      // Fallback: Check locale from GetX
      final locale = Get.locale ?? const Locale('en', 'US');
      return locale.languageCode == 'hi' ? hindi : english;
    } catch (e) {
      // If controller not found, default to English
      return english;
    }
  }

  /// Get translation for dynamic content
  /// Use this when you have content from API that might need translation
  /// If API returns translated content, use the content directly
  /// If API doesn't support translation, use this with English fallback
  static String translate(String english, {String? hindi}) {
    final currentLanguage =
        Get.find<LanguageController>().currentLanguage.value;
    if (currentLanguage == AppLanguage.hindi && hindi != null) {
      return hindi;
    }
    return english;
  }
}
