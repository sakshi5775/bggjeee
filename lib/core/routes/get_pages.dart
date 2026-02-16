import 'package:astrobharataiuser/binding/auth_binding/login_binding.dart';
import 'package:astrobharataiuser/binding/auth_binding/otp_binding.dart';
import 'package:astrobharataiuser/binding/auth_binding/signup_binding.dart';
import 'package:astrobharataiuser/binding/blog_binding/all_blogs_binding.dart';
import 'package:astrobharataiuser/binding/chat_binding/chat_binding.dart';
import 'package:astrobharataiuser/binding/courses_binding/courses_binding.dart';
import 'package:astrobharataiuser/binding/courses_binding/live_webinars_binding.dart'; // Added
import 'package:astrobharataiuser/binding/courses_binding/my_learning_binding.dart';
import 'package:astrobharataiuser/binding/dashboard_binding/user_main_binding.dart';
// E-Mandir bindings removed - files don't exist
import 'package:astrobharataiuser/binding/waiting_screen_binding/waiting_screen_binding.dart';
import 'package:astrobharataiuser/binding/onboarding_binding/onboarding_binding.dart';
import 'package:astrobharataiuser/binding/ai_chat_binding/ai_chat_binding.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
// import 'package:astrobharataiuser/screens/navtara/view/navtara_dashboard_view.dart';
import 'package:astrobharataiuser/screens/astrologer_registration/binding/astrologer_registration_binding.dart';
import 'package:astrobharataiuser/screens/astrologer_registration/view/astrologer_registration_intro_view.dart';
import 'package:astrobharataiuser/screens/astrologer_registration/view/astrologer_registration_form_view.dart';
import 'package:astrobharataiuser/screens/astrologer_registration/view/astrologer_registration_otp_view.dart';
import 'package:astrobharataiuser/screens/login/login/view/user_privacy_policy_view.dart';
import 'package:astrobharataiuser/screens/login/forgot_password/view/forgot_password_view.dart';
import 'package:astrobharataiuser/screens/login/forgot_password/view/forgot_password_otp_view.dart';
import 'package:astrobharataiuser/screens/login/forgot_password/view/reset_password_view.dart';
import 'package:astrobharataiuser/screens/login/forgot_password/binding/forgot_password_binding.dart';

import 'package:astrobharataiuser/screens/ecommerce/remedies/view/remedies_view.dart';
import 'package:astrobharataiuser/screens/ecommerce/remedies/bindings/remedies_binding.dart';
import 'package:astrobharataiuser/screens/ecommerce/remedies/remedy_category_listing/view/remedy_category_listing_view.dart';
import 'package:astrobharataiuser/screens/ecommerce/remedies/remedy_category_listing/bindings/remedy_category_listing_binding.dart';
import 'package:astrobharataiuser/screens/ai_chat/views/ai_chat_view.dart';
import 'package:astrobharataiuser/screens/blogs/view/all_blogs_view.dart';
import 'package:astrobharataiuser/screens/blogs/view/blog_comments_view.dart';
import 'package:astrobharataiuser/screens/blogs/view/blog_detail_view.dart';
import 'package:astrobharataiuser/screens/chat/views/chat_view.dart';
import 'package:astrobharataiuser/screens/ai_chat/views/persona_detail_view.dart';
import 'package:astrobharataiuser/data_model/persona_model.dart';
import 'package:astrobharataiuser/screens/ai_chat/voice_call/views/persona_voice_call_view.dart';
import 'package:astrobharataiuser/screens/ai_chat/voice_call/views/persona_voice_history_view.dart';
import 'package:astrobharataiuser/screens/e_mandir/bhakti_chakra/view/bhakti_chakra_view.dart';
import 'package:astrobharataiuser/binding/e_mandir_binding/bhakti_chakra_binding.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_library/view/devotional_library_view.dart';
import 'package:astrobharataiuser/binding/e_mandir_binding/devotional_library_binding.dart';
import 'package:astrobharataiuser/screens/e_mandir/e_mandir_home/view/namaste_home_view.dart';
import 'package:astrobharataiuser/binding/e_mandir_binding/namaste_home_binding.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_player/view/devotional_player_view.dart';
import 'package:astrobharataiuser/binding/e_mandir_binding/devotional_player_binding.dart';
import 'package:astrobharataiuser/screens/e_mandir/lyrics/view/lyrics_view.dart';
import 'package:astrobharataiuser/binding/e_mandir_binding/lyrics_binding.dart';
import 'package:astrobharataiuser/screens/e_mandir/meaning/view/meaning_view.dart';
import 'package:astrobharataiuser/binding/e_mandir_binding/meaning_binding.dart';
import 'package:astrobharataiuser/screens/e_mandir/passbook/view/passbook_view.dart';
import 'package:astrobharataiuser/binding/e_mandir_binding/passbook_binding.dart';
import 'package:astrobharataiuser/screens/e_mandir/punya_mudra/view/punya_mudra_view.dart';
import 'package:astrobharataiuser/binding/e_mandir_binding/punya_mudra_binding.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/view/virtual_darshan_view.dart';
import 'package:astrobharataiuser/binding/e_mandir_binding/virtual_darshan_binding.dart';
import 'package:astrobharataiuser/screens/login/login/view/login_view.dart';
import 'package:astrobharataiuser/screens/match_making/match_making/view/match_making_form_view.dart';
import 'package:astrobharataiuser/screens/match_making/match_making/view/match_making_full_kundli_view.dart';
import 'package:astrobharataiuser/screens/match_making/match_making/view/match_making_gif_view.dart';
import 'package:astrobharataiuser/screens/match_making/match_making/view/match_making_result_view.dart';
import 'package:astrobharataiuser/screens/prashna_kundali/binding/prashna_kundali_binding.dart';
import 'package:astrobharataiuser/screens/prashna_kundali/view/prashna_kundali_history_view.dart';
import 'package:astrobharataiuser/screens/prashna_kundali/view/prashna_kundali_results_view.dart';
import 'package:astrobharataiuser/screens/prashna_kundali/view/prashna_kundali_view.dart';
import 'package:astrobharataiuser/screens/ramal_shastra/binding/ramal_shastra_binding.dart';
import 'package:astrobharataiuser/screens/ramal_shastra/view/ramal_shastra_view.dart';
import 'package:astrobharataiuser/screens/ramal_shastra/view/ramal_shastra_question_view.dart';
import 'package:astrobharataiuser/screens/ramal_shastra/view/ramal_shastra_method_view.dart';
import 'package:astrobharataiuser/screens/ramal_shastra/view/ramal_shastra_casting_dice_view.dart';
import 'package:astrobharataiuser/screens/ramal_shastra/view/ramal_shastra_casting_cards_view.dart';
import 'package:astrobharataiuser/screens/ramal_shastra/view/ramal_shastra_casting_dots_view.dart';
import 'package:astrobharataiuser/screens/ramal_shastra/view/ramal_shastra_confirmation_view.dart';
import 'package:astrobharataiuser/screens/ramal_shastra/view/ramal_shastra_results_view.dart';
import 'package:astrobharataiuser/screens/ramal_shastra/view/ramal_shastra_history_view.dart';
import 'package:astrobharataiuser/screens/ramal_shastra/view/ramal_shastra_stats_view.dart';
import 'package:astrobharataiuser/screens/ramal_shastra/view/ramal_shastra_detail_view.dart';
import 'package:astrobharataiuser/screens/waiting_screen/waiting_screen/view/waiting_screen_view.dart';
import 'package:astrobharataiuser/screens/onboarding/view/onboarding_view.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart'
    show AutoTranslateText;
import 'package:flutter/material.dart';
import 'package:astrobharataiuser/screens/courses/views/courses_view.dart';
import 'package:astrobharataiuser/screens/courses/views/course_detail_view.dart';
import 'package:astrobharataiuser/screens/courses/views/course_player_view.dart';
import 'package:astrobharataiuser/screens/courses/views/content_player_view.dart';
import 'package:astrobharataiuser/screens/courses/views/live_webinars_view.dart';
import 'package:astrobharataiuser/screens/courses/views/live_webinar_session_view.dart';
import 'package:astrobharataiuser/screens/courses/views/my_learning_view.dart';

import 'package:astrobharataiuser/screens/otp/view/otp_view.dart';
import 'package:astrobharataiuser/screens/sign_up/view/signup_view.dart';
import 'package:astrobharataiuser/screens/user_dashboard/view/user_main_view.dart';
import 'package:astrobharataiuser/screens/user_dashboard/view/consultation_history_view.dart';
import 'package:astrobharataiuser/screens/user_dashboard/view/all_reports_view.dart';
import 'package:astrobharataiuser/screens/user_dashboard/view/all_videos_view.dart';
import 'package:astrobharataiuser/binding/dashboard_binding/all_videos_binding.dart';
import 'package:astrobharataiuser/screens/user_dashboard/widgets/ComingSoonPage.dart';
import 'package:astrobharataiuser/screens/user_dashboard/view/report_pdf_view.dart';

import 'package:astrobharataiuser/screens/astrology_services/view/astrology_services_view.dart';
import 'package:astrobharataiuser/screens/astrology_services/view/all_astrologers_view.dart';
import 'package:astrobharataiuser/screens/astrology_services/view/astrologer_detail_view.dart';
import 'package:astrobharataiuser/screens/astrology_services/view/following_astrologers_view.dart';
import 'package:astrobharataiuser/screens/live_astrologers/view/live_astrologers_view.dart';
import 'package:astrobharataiuser/screens/astrology_services/view/booking_view.dart';
import 'package:astrobharataiuser/screens/astrology_services/views/astrologer_chat_view.dart';
import 'package:astrobharataiuser/screens/astrology_services/views/astrologer_chat_history_view.dart';
import 'package:astrobharataiuser/screens/astrology_services/view/astrologer_voice_call_view.dart';
import 'package:astrobharataiuser/screens/astrology_services/view/astrologer_video_call_view.dart';
import 'package:astrobharataiuser/screens/ecommerce/view/ecommerce_home_view.dart';
import 'package:astrobharataiuser/screens/ecommerce/view/product_list_view.dart';
import 'package:astrobharataiuser/screens/ecommerce/view/product_detail_view.dart';
import 'package:astrobharataiuser/screens/ecommerce/binding/product_list_binding.dart';
import 'package:astrobharataiuser/screens/ecommerce/binding/product_detail_binding.dart';
import 'package:astrobharataiuser/screens/ecommerce/view/search_view.dart';
import 'package:astrobharataiuser/screens/ecommerce/binding/search_binding.dart';
import 'package:astrobharataiuser/screens/ecommerce/view/cart_view.dart';
import 'package:astrobharataiuser/screens/ecommerce/view/saved_items_view.dart';
import 'package:astrobharataiuser/screens/ecommerce/view/wishlist_view.dart';
import 'package:astrobharataiuser/screens/ecommerce/view/profile_view.dart';
import 'package:astrobharataiuser/screens/ecommerce/view/orders_view.dart';
import 'package:astrobharataiuser/screens/ecommerce/view/order_detail_view.dart';
import 'package:astrobharataiuser/screens/ecommerce/view/addresses_view.dart';
import 'package:astrobharataiuser/screens/ecommerce/view/coupons_view.dart';
import 'package:astrobharataiuser/screens/ecommerce/view/payments_view.dart';
import 'package:astrobharataiuser/screens/ecommerce/view/payment_detail_view.dart';
import 'package:astrobharataiuser/binding/ecommerce_binding/ecommerce_binding.dart';
import 'package:astrobharataiuser/screens/ecommerce/binding/cart_binding.dart';
import 'package:astrobharataiuser/screens/ecommerce/binding/wishlist_binding.dart';
import 'package:astrobharataiuser/screens/ecommerce/binding/profile_binding.dart';
import 'package:astrobharataiuser/screens/ecommerce/binding/orders_binding.dart';
import 'package:astrobharataiuser/screens/ecommerce/binding/order_detail_binding.dart';
import 'package:astrobharataiuser/screens/ecommerce/binding/address_binding.dart';
import 'package:astrobharataiuser/screens/ecommerce/binding/coupons_binding.dart';
import 'package:astrobharataiuser/screens/ecommerce/binding/payments_binding.dart';
import 'package:astrobharataiuser/screens/ecommerce/binding/payment_detail_binding.dart';
import 'package:astrobharataiuser/screens/support/view/support_tickets_list_view.dart';
import 'package:astrobharataiuser/screens/support/view/create_support_ticket_view.dart';
import 'package:astrobharataiuser/screens/support/view/support_ticket_detail_view.dart';
import 'package:astrobharataiuser/screens/support/binding/support_ticket_binding.dart';
import 'package:astrobharataiuser/screens/wallet/view/wallet_view.dart';
import 'package:astrobharataiuser/binding/navtara_binding/navtara_binding.dart';
import 'package:astrobharataiuser/screens/navtara/view/navtara_view.dart';
import 'package:astrobharataiuser/screens/horoscope/view/horoscope_form_view.dart';
import 'package:astrobharataiuser/screens/horoscope/view/horoscope_sign_selection_view.dart';
import 'package:astrobharataiuser/screens/horoscope/view/horoscope_main_view.dart';
import 'package:astrobharataiuser/binding/horoscope_binding/horoscope_form_binding.dart';
import 'package:astrobharataiuser/screens/panchang/view/panchang_view.dart';
import 'package:astrobharataiuser/screens/panchang/view/daily_panchang_view.dart';
import 'package:astrobharataiuser/screens/panchang/view/monthly_calendar_view.dart';
import 'package:astrobharataiuser/screens/panchang/view/festival_detail_view.dart';
import 'package:astrobharataiuser/screens/panchang/view/hindu_calendar_view.dart';
import 'package:astrobharataiuser/screens/panchang/view/festival_filtered_view.dart';
import 'package:astrobharataiuser/screens/panchang/view/yearly_vrat_view.dart';
import 'package:astrobharataiuser/screens/panchang/view/festival_yearly_view.dart';
import 'package:astrobharataiuser/screens/panchang/view/hora_view.dart';
import 'package:astrobharataiuser/screens/panchang/view/chogadia_view.dart';
import 'package:astrobharataiuser/screens/panchang/view/rahukaal_view.dart';
import 'package:astrobharataiuser/screens/panchang/view/bhadra_view.dart';
import 'package:astrobharataiuser/screens/panchang/view/muhurat_view.dart';
import 'package:astrobharataiuser/screens/panchang/view/other_calendars_view.dart';
import 'package:astrobharataiuser/screens/panchang/view/jain_calendar_view.dart';
import 'package:astrobharataiuser/screens/panchang/view/hindu_calendar_monthly_panchang_view.dart';
import 'package:astrobharataiuser/screens/panchang/view/moon_calendar_view.dart';
import 'package:astrobharataiuser/screens/kundli/view/kundli_form_view.dart';
import 'package:astrobharataiuser/screens/kundli/view/kundli_result_view.dart';
import 'package:astrobharataiuser/screens/kundli/view/shodashvarga_view.dart';
import 'package:astrobharataiuser/screens/kundli/view/dasha_view.dart';
import 'package:astrobharataiuser/screens/kundli/view/yog_view.dart';
import 'package:astrobharataiuser/screens/kundli/view/dosh_view.dart';
import 'package:astrobharataiuser/screens/kundli/view/sade_sati_view.dart';
import 'package:astrobharataiuser/screens/kundli/view/gemstones_report_view.dart';
import 'package:astrobharataiuser/screens/kundli/view/transit_today_view.dart';
import 'package:astrobharataiuser/screens/kundli/view/kp_system_view.dart';
import 'package:astrobharataiuser/screens/kundli/view/lal_kitab_view.dart';
import 'package:astrobharataiuser/screens/kundli/view/varshphal_view.dart';
import 'package:astrobharataiuser/screens/kundli/view/predictions_view.dart';
import 'package:astrobharataiuser/screens/kundli/view/planets_view.dart';
import 'package:astrobharataiuser/binding/kundli_binding/kundli_form_binding.dart';
import 'package:astrobharataiuser/binding/kundli_binding/kundli_result_binding.dart';
import 'package:astrobharataiuser/binding/kundli_binding/shodashvarga_binding.dart';
import 'package:astrobharataiuser/binding/kundli_binding/dasha_binding.dart';
import 'package:astrobharataiuser/binding/kundli_binding/yog_binding.dart';
import 'package:astrobharataiuser/binding/kundli_binding/dosh_binding.dart';
import 'package:astrobharataiuser/binding/kundli_binding/sade_sati_binding.dart';
import 'package:astrobharataiuser/binding/kundli_binding/gemstones_report_binding.dart';
import 'package:astrobharataiuser/binding/kundli_binding/transit_today_binding.dart';
import 'package:astrobharataiuser/binding/kundli_binding/kp_system_binding.dart';
import 'package:astrobharataiuser/binding/kundli_binding/lal_kitab_binding.dart';
import 'package:astrobharataiuser/binding/kundli_binding/varshphal_binding.dart';
import 'package:astrobharataiuser/binding/kundli_binding/predictions_binding.dart';
import 'package:astrobharataiuser/binding/kundli_binding/planets_binding.dart';
import 'package:astrobharataiuser/binding/panchang_binding/panchang_binding.dart';
import 'package:astrobharataiuser/binding/panchang_binding/daily_panchang_binding.dart';
import 'package:astrobharataiuser/binding/panchang_binding/monthly_calendar_binding.dart';
import 'package:astrobharataiuser/binding/panchang_binding/festival_detail_binding.dart';
import 'package:astrobharataiuser/binding/panchang_binding/hindu_calendar_binding.dart';
import 'package:astrobharataiuser/binding/panchang_binding/festival_filtered_binding.dart';
import 'package:astrobharataiuser/binding/panchang_binding/yearly_vrat_binding.dart';
import 'package:astrobharataiuser/binding/panchang_binding/festival_yearly_binding.dart';
import 'package:astrobharataiuser/binding/panchang_binding/hora_binding.dart';
import 'package:astrobharataiuser/binding/panchang_binding/chogadia_binding.dart';
import 'package:astrobharataiuser/binding/panchang_binding/rahukaal_binding.dart';
import 'package:astrobharataiuser/binding/panchang_binding/bhadra_binding.dart';
import 'package:astrobharataiuser/binding/panchang_binding/muhurat_binding.dart';
import 'package:astrobharataiuser/binding/panchang_binding/other_calendars_binding.dart';
import 'package:astrobharataiuser/binding/panchang_binding/jain_calendar_binding.dart';
import 'package:astrobharataiuser/binding/panchang_binding/hindu_calendar_monthly_panchang_binding.dart';
import 'package:astrobharataiuser/binding/panchang_binding/moon_calendar_binding.dart';
import 'package:astrobharataiuser/binding/e_mandir_binding/e_mandir_festival_detail_binding.dart';
import 'package:astrobharataiuser/binding/e_mandir_binding/all_festival_binding.dart';
import 'package:astrobharataiuser/screens/e_mandir/festivals/festival_details/view/e_mandir_festival_detail_view.dart';
import 'package:astrobharataiuser/screens/e_mandir/festivals/all_festival/view/all_festival_view.dart';
import 'package:astrobharataiuser/screens/numerology/view/numerology_view.dart';
import 'package:astrobharataiuser/screens/numerology/view/numerology_form_view.dart';
import 'package:astrobharataiuser/screens/numerology/view/numerology_features_view.dart';

import 'package:astrobharataiuser/screens/numerology/view/numerology_result_view.dart';
import 'package:astrobharataiuser/screens/numerology/view/numerology_reports_view.dart';
import 'package:astrobharataiuser/screens/numerology/view/loshu_grid_form_view.dart';
import 'package:astrobharataiuser/screens/numerology/view/loshu_grid_result_view.dart';
import 'package:astrobharataiuser/binding/numerology_binding/numerology_binding.dart';
import 'package:astrobharataiuser/binding/numerology_binding/numerology_form_binding.dart';

import 'package:astrobharataiuser/binding/numerology_binding/numerology_reports_binding.dart';
import 'package:astrobharataiuser/binding/numerology_binding/loshu_grid_form_binding.dart';
import 'package:astrobharataiuser/binding/numerology_binding/loshu_grid_result_binding.dart';
import 'package:astrobharataiuser/screens/palm_reading/view/palm_reading_view.dart';
import 'package:astrobharataiuser/screens/palm_reading/view/palm_reading_history_view.dart';
import 'package:astrobharataiuser/screens/palm_reading/view/palm_reading_form_view.dart';
import 'package:astrobharataiuser/screens/palm_reading/view/palm_reading_time_view.dart';
import 'package:astrobharataiuser/screens/palm_reading/view/palm_reading_hand_gender_view.dart';
import 'package:astrobharataiuser/screens/palm_reading/view/palm_reading_upload_view.dart';
import 'package:astrobharataiuser/screens/palm_reading/view/palm_reading_camera_view.dart';
import 'package:astrobharataiuser/screens/palm_reading/view/palm_reading_scanning_view.dart';
import 'package:astrobharataiuser/screens/palm_reading/view/palm_reading_results_view.dart';
import 'package:astrobharataiuser/screens/palm_reading/view/palm_reading_detail_view.dart';
import 'package:astrobharataiuser/screens/palm_reading/view/palm_reading_analysis_view.dart';
import 'package:astrobharataiuser/binding/palm_reading_binding/palm_reading_binding.dart';
import 'package:astrobharataiuser/binding/palm_reading_binding/palm_reading_history_binding.dart';
import 'package:astrobharataiuser/screens/face_reading/view/face_reading_view.dart';
import 'package:astrobharataiuser/screens/face_reading/view/face_reading_upload_view.dart';
import 'package:astrobharataiuser/screens/face_reading/view/face_reading_scanning_view.dart';
import 'package:astrobharataiuser/screens/face_reading/view/face_reading_results_view.dart';
import 'package:astrobharataiuser/screens/face_reading/view/face_reading_category_detail_view.dart';
import 'package:astrobharataiuser/screens/face_reading/view/face_reading_feature_detail_view.dart';
import 'package:astrobharataiuser/screens/face_reading/view/face_reading_history_view.dart';
import 'package:astrobharataiuser/screens/vastu/view/vastu_reading_view.dart';
import 'package:astrobharataiuser/screens/vastu/view/vastu_dashboard_view.dart';
import 'package:astrobharataiuser/screens/vastu/view/home_vastu/home_vastu_list_view.dart';
import 'package:astrobharataiuser/screens/vastu/view/home_vastu/home_vastu_compass_view.dart';
import 'package:astrobharataiuser/screens/vastu/view/office_vastu/office_vastu_list_view.dart';
import 'package:astrobharataiuser/screens/vastu/view/office_vastu/office_vastu_compass_view.dart';
import 'package:astrobharataiuser/screens/vastu/view/vastu_dosh_view.dart';
import 'package:astrobharataiuser/screens/vastu/view/vastu_shastra_view.dart';
import 'package:astrobharataiuser/screens/vastu/view/vastu_tips_view.dart';
import 'package:astrobharataiuser/screens/vastu/view/ar_vastu/ar_vastu_screen.dart';
import 'package:astrobharataiuser/screens/vastu/view/ar_vastu/ar_onboarding_screen.dart';
import 'package:astrobharataiuser/screens/vastu/view/vastu_correction_view.dart';
import 'package:astrobharataiuser/screens/handwriting_astrology/view/handwriting_astrology_view.dart';
import 'package:astrobharataiuser/screens/handwriting_astrology/view/handwriting_astrology_upload_view.dart';
import 'package:astrobharataiuser/screens/handwriting_astrology/view/handwriting_astrology_results_view.dart';
import 'package:astrobharataiuser/screens/handwriting_astrology/view/handwriting_astrology_history_view.dart';
import 'package:astrobharataiuser/binding/handwriting_astrology_binding/handwriting_astrology_binding.dart';
import 'package:astrobharataiuser/screens/tarot_reading/view/tarot_reading_view.dart';
import 'package:astrobharataiuser/screens/tarot_reading/binding/tarot_binding.dart';
import 'package:astrobharataiuser/screens/carrot_astrology/view/carrot_astrology_view.dart';
import 'package:astrobharataiuser/screens/carrot_astrology/view/carrot_astrology_form_view.dart';
import 'package:astrobharataiuser/screens/carrot_astrology/view/carrot_astrology_results_view.dart';
import 'package:astrobharataiuser/screens/carrot_astrology/view/carrot_astrology_history_view.dart';
import 'package:astrobharataiuser/screens/live_stream/widgets/stream_reports_view.dart';

import 'package:astrobharataiuser/binding/match_making_binding/match_making_form_binding.dart';
import 'package:astrobharataiuser/screens/ai_guider/view/ai_guider_view.dart';
import 'package:astrobharataiuser/binding/ai_guider_binding/ai_guider_binding.dart';
import 'package:get/get.dart';

import '../../binding/e_mandir_binding/book_pooja_binding.dart';
import '../../binding/e_mandir_binding/pooja_details_binding.dart';
import '../../binding/e_mandir_binding/address_selection_binding.dart';
import '../../binding/e_mandir_binding/address_form_binding.dart';
import '../../binding/e_mandir_binding/puja_booking_form_binding.dart';
import '../../binding/e_mandir_binding/my_bookings_binding.dart';
import '../../binding/e_mandir_binding/my_booking_detail_binding.dart';
import '../../screens/e_mandir/book_puja/view/book_puja_view.dart';
import '../../screens/e_mandir/puja_detail/view/puja_detail_view.dart';
import '../../screens/e_mandir/address_selection/view/address_selection_view.dart';
import '../../screens/e_mandir/address_form/view/address_form_view.dart';
import '../../screens/e_mandir/puja_booking_form/view/puja_booking_form_view.dart';
import '../../screens/e_mandir/my_bookings/view/my_bookings_view.dart';
import '../../screens/e_mandir/my_bookings/view/my_booking_detail_view.dart';

class PageRoutes {
  static const INITIAL = AppRoutes.root;
  static const leftToRight = Transition.leftToRight;
  static final routes = [
    GetPage(
      name: AppRoutes.root,
      page: () => const WaitingScreenView(),
      transition: leftToRight,
      binding: WaitingScreenBinding(),
    ),
    GetPage(
      name: AppRoutes.astrologerRegistrationIntro,
      page: () => const AstrologerRegistrationIntroView(),
      transition: Transition.rightToLeft,
      binding: AstrologerRegistrationBinding(),
    ),
    GetPage(
      name: AppRoutes.astrologerRegistrationForm,
      page: () => const AstrologerRegistrationFormView(),
      transition: Transition.rightToLeft,
      binding: AstrologerRegistrationBinding(),
    ),
    GetPage(
      name: AppRoutes.astrologerRegistrationOtp,
      page: () => const AstrologerRegistrationOtpView(),
      transition: Transition.rightToLeft,
      binding: AstrologerRegistrationBinding(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingView(),
      transition: Transition.fadeIn,
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: AppRoutes.search,
      page: () => const EcommerceSearchView(),
      transition: Transition.native,
      transitionDuration: Duration(milliseconds: 250),
      binding: SearchBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      transition: Transition.upToDown,
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordView(),
      transition: Transition.rightToLeft,
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: AppRoutes.forgotPasswordOtp,
      page: () => const ForgotPasswordOtpView(),
      transition: Transition.rightToLeft,
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: AppRoutes.resetPassword,
      page: () => const ResetPasswordView(),
      transition: Transition.rightToLeft,
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: AppRoutes.otp,
      page: () => const OTPView(),
      transition: Transition.rightToLeft,
      binding: OTPBinding(),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignUpView(),
      transition: Transition.rightToLeft,
      binding: SignUpBinding(),
    ),
    GetPage(
      name: AppRoutes.userDashboard,
      page: () => const UserMainView(),
      transition: Transition.fadeIn,
      binding: UserMainBinding(),
    ),
    GetPage(
      name: AppRoutes.astrologyServices,
      page: () => const AstrologyServicesView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.liveAstrologers,
      page: () => const LiveAstrologersView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.allAstrologers,
      page: () {
        final args = Get.arguments;
        final initialFilter = args is String
            ? args
            : args is Map<String, dynamic>
            ? args['filter'] as String?
            : null;
        return AllAstrologersView(initialFilter: initialFilter);
      },
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.astrologerDetail,
      page: () => const AstrologerDetailView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.booking,
      page: () => const BookingView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.chat,
      page: () => const AstrologerChatView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.astrologerChat,
      page: () => const AstrologerChatView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.astrologerChatHistory,
      page: () => const AstrologerChatHistoryView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.consultationHistory,
      page: () => const ConsultationHistoryView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.reportPdfView,
      page: () => const ReportPdfView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.navtaraDashboard,
      page: () => const NavtaraView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: NavtaraBinding(),
    ),
    GetPage(
      name: AppRoutes.allReports,
      page: () => const AllReportsView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.allVideos,
      page: () => const AllVideosView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: AllVideosBinding(),
    ),
    GetPage(
      name: AppRoutes.astrologerVoiceCall,
      page: () => const AstrologerVoiceCallView(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.astrologerVideoCall,
      page: () => const AstrologerVideoCallView(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.aichat,
      page: () {
        final args = Get.arguments;
        final showBackButton = args is Map<String, dynamic>
            ? args['showBackButton'] as bool? ?? true
            : true;
        return AiChatView(showBackButton: showBackButton);
      },
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
      binding: AiChatBinding(),
    ),
    GetPage(
      name: AppRoutes.allBlogs,
      page: () => const AllBlogsView(),
      transition: Transition.rightToLeft,
      binding: AllBlogsBinding(),
    ),
    GetPage(
      name: AppRoutes.blogDetail,
      page: () => BlogDetailView(blog: Get.arguments),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.blogComments,
      page: () => BlogCommentsView(blogId: Get.arguments),
      transition: Transition.rightToLeft,
    ),
    // E-commerce Routes
    GetPage(
      name: AppRoutes.ecommerceHome,
      page: () {
        final args = Get.arguments;
        final showBackButton = args is Map<String, dynamic>
            ? args['showBackButton'] as bool? ?? false
            : false;
        return EcommerceHomeView(showBackButton: showBackButton);
      },
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: EcommerceBinding(),
    ),
    GetPage(
      name: AppRoutes.remedies,
      page: () => const RemediesView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: RemediesBinding(),
    ),
    GetPage(
      name: AppRoutes.remedyCategoryListing,
      page: () => const RemedyCategoryListingView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: RemedyCategoryListingBinding(),
    ),
    GetPage(
      name: AppRoutes.productList,
      page: () => const ProductListView(),
      transition: Transition.native,
      transitionDuration: Duration(milliseconds: 300),
      binding: ProductListBinding(),
    ),
    GetPage(
      name: AppRoutes.productDetail,
      page: () => const ProductDetailView(),
      transition: Transition.native,
      transitionDuration: Duration(milliseconds: 300),
      binding: ProductDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.cart,
      page: () => const CartView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: CartBinding(),
    ),
    GetPage(
      name: AppRoutes.savedItems,
      page: () => const SavedItemsView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: CartBinding(),
    ),
    GetPage(
      name: AppRoutes.wishlist,
      page: () => const WishlistView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: WishlistBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () {
        final args = Get.arguments;
        final showBackButton = args is Map<String, dynamic>
            ? args['showBackButton'] as bool? ?? true
            : true;
        return ProfileView(showBackButton: showBackButton);
      },
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.followingAstrologers,
      page: () => const FollowingAstrologersView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.orders,
      page: () => const OrdersView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: OrdersBinding(),
    ),
    GetPage(
      name: AppRoutes.orderDetail,
      page: () => const OrderDetailView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: OrderDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.payments,
      page: () => const PaymentsView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: PaymentsBinding(),
    ),
    GetPage(
      name: AppRoutes.paymentDetail,
      page: () => const PaymentDetailView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: PaymentDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.addresses,
      page: () => const AddressesView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: AddressBinding(),
    ),
    GetPage(
      name: AppRoutes.coupons,
      page: () => const CouponsView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: CouponsBinding(),
    ),
    // Support Tickets Routes
    GetPage(
      name: AppRoutes.supportTickets,
      page: () => const SupportTicketsListView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: SupportTicketBinding(),
    ),
    GetPage(
      name: AppRoutes.createSupportTicket,
      page: () => const CreateSupportTicketView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.supportTicketDetail,
      page: () => SupportTicketDetailView(ticketId: Get.arguments),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    // Courses Routes
    GetPage(
      name: AppRoutes.courses,
      page: () {
        final args = Get.arguments;
        final showBackButton = args is Map<String, dynamic>
            ? args['showBackButton'] as bool? ?? true
            : true;
        return CoursesView(showBackButton: showBackButton);
      },
      transition: Transition.noTransition,
      transitionDuration: Duration.zero,
      binding: CoursesBinding(),
    ),
    GetPage(
      name: AppRoutes.courseDetail,
      page: () {
        final args = Get.arguments;
        final courseId = args is String
            ? args
            : args is Map<String, dynamic>
            ? args['courseId'] as String? ?? ''
            : '';
        return CourseDetailView(courseId: courseId);
      },
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: CoursesBinding(),
    ),
    GetPage(
      name: AppRoutes.coursePlayer,
      page: () {
        final args = Get.arguments;
        final courseId = args is String
            ? args
            : args is Map<String, dynamic>
            ? args['courseId'] as String? ?? ''
            : '';
        return CoursePlayerView(courseId: courseId);
      },
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: CoursesBinding(),
    ),
    GetPage(
      name: AppRoutes.contentPlayer,
      page: () {
        final args = Get.arguments as Map<String, dynamic>? ?? {};
        return ContentPlayerView(arguments: args);
      },
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.liveWebinars,
      page: () => const LiveWebinarsView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: LiveWebinarsBinding(), // Changed from CoursesBinding
    ),
    GetPage(
      name: AppRoutes.liveWebinarSession,
      page: () {
        final args = Get.arguments as Map<String, dynamic>? ?? {};
        return LiveWebinarSessionView(
          webinarId: args['webinarId'] as String? ?? '',
          courseId: args['courseId'] as String? ?? '',
        );
      },
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: LiveWebinarsBinding(),
    ),
    GetPage(
      name: AppRoutes.myLearning,
      page: () => const MyLearningView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: MyLearningBinding(),
    ),
    // Chat Routes
    GetPage(
      name: AppRoutes.personaChat,
      page: () {
        final args = Get.arguments;
        PersonaModel persona;
        if (args is Map<String, dynamic>) {
          persona = args['persona'] as PersonaModel;
        } else {
          persona = args as PersonaModel;
        }
        return ChatView(persona: persona);
      },
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: ChatBinding(),
    ),
    // Voice Call Route
    GetPage(
      name: AppRoutes.personaVoiceCall,
      page: () {
        final args = Get.arguments;
        if (args is PersonaModel) {
          return VoiceCallView(persona: args);
        } else if (args is Map<String, dynamic>) {
          final persona = args['persona'] as PersonaModel?;
          final platform = args['platform']?.toString() ?? 'android';
          if (persona != null) {
            return VoiceCallView(persona: persona, platform: platform);
          }
        }
        return const Scaffold(
          body: Center(child: AutoTranslateText('Invalid arguments')),
        );
      },
      transition: Transition.downToUp,
      transitionDuration: Duration(milliseconds: 250),
    ),
    // Voice Call History
    GetPage(
      name: AppRoutes.personaVoiceHistory,
      page: () {
        final args = Get.arguments;
        if (args is Map<String, dynamic>) {
          return PersonaVoiceHistoryView(
            personaId: args['personaId']?.toString(),
            persona: args['persona'] as PersonaModel?,
          );
        }
        return const Scaffold(
          body: Center(child: AutoTranslateText('Invalid arguments')),
        );
      },
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 250),
    ),
    // Persona Detail Route
    GetPage(
      name: AppRoutes.personaDetail,
      page: () {
        final args = Get.arguments;
        if (args is Map<String, dynamic>) {
          final personaId = args['personaId'] as String?;
          final persona = args['persona'] as PersonaModel?;
          if (personaId != null) {
            return PersonaDetailView(personaId: personaId, persona: persona);
          }
        } else if (args is String) {
          return PersonaDetailView(personaId: args);
        } else if (args is PersonaModel) {
          return PersonaDetailView(personaId: args.id, persona: args);
        }
        return const Scaffold(
          body: Center(child: AutoTranslateText('Invalid arguments')),
        );
      },
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    // Wallet Route
    GetPage(
      name: AppRoutes.wallet,
      page: () => const WalletView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    // Horoscope Routes
    GetPage(
      name: AppRoutes.horoscope,
      page: () => const HoroscopeSignSelectionView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.horoscopeForm,
      page: () => const HoroscopeFormView(),
      binding: HoroscopeFormBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.horoscopeSignSelection,
      page: () => const HoroscopeSignSelectionView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.horoscopeMain,
      page: () => const HoroscopeMainView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    // Panchang Route
    GetPage(
      name: AppRoutes.panchang,
      page: () => const PanchangView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: PanchangBinding(),
    ),
    // Daily Panchang Route
    GetPage(
      name: AppRoutes.dailyPanchang,
      page: () => const DailyPanchangView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: DailyPanchangBinding(),
    ),
    GetPage(
      name: AppRoutes.monthlyCalendar,
      page: () => const MonthlyCalendarView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: MonthlyCalendarBinding(),
    ),
    GetPage(
      name: AppRoutes.festivalDetail,
      page: () => const FestivalDetailView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: FestivalDetailBinding(),
    ),
    // Hindu Calendar Route
    GetPage(
      name: AppRoutes.hinduCalendar,
      page: () => const HinduCalendarView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: HinduCalendarBinding(),
    ),
    // Festival Filtered Route
    GetPage(
      name: AppRoutes.festivalFiltered,
      page: () => const FestivalFilteredView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: FestivalFilteredBinding(),
    ),
    // Yearly Vrat Route
    GetPage(
      name: AppRoutes.yearlyVrat,
      page: () => const YearlyVratView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: YearlyVratBinding(),
    ),
    // Festival Yearly Route
    GetPage(
      name: AppRoutes.festivalYearly,
      page: () => const FestivalYearlyView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: FestivalYearlyBinding(),
    ),
    // Hora Route
    GetPage(
      name: AppRoutes.hora,
      page: () => const HoraView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: HoraBinding(),
    ),
    // Chogadia Route
    GetPage(
      name: AppRoutes.chogadia,
      page: () => const ChogadiaView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: ChogadiaBinding(),
    ),
    // Rahukaal Route
    GetPage(
      name: AppRoutes.rahukaal,
      page: () => const RahukaalView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: RahukaalBinding(),
    ),
    // Bhadra Route
    GetPage(
      name: AppRoutes.bhadra,
      page: () => const BhadraView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: BhadraBinding(),
    ),
    // Muhurat Route
    GetPage(
      name: AppRoutes.muhurat,
      page: () => const MuhuratView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: MuhuratBinding(),
    ),
    // Other Calendars Route
    GetPage(
      name: AppRoutes.otherCalendars,
      page: () => const OtherCalendarsView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: OtherCalendarsBinding(),
    ),
    // Jain Calendar Route
    GetPage(
      name: AppRoutes.jainCalendar,
      page: () => const JainCalendarView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: JainCalendarBinding(),
    ),
    // Hindu Calendar Monthly Panchang Route
    GetPage(
      name: AppRoutes.hinduCalendarMonthlyPanchang,
      page: () => const HinduCalendarMonthlyPanchangView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: HinduCalendarMonthlyPanchangBinding(),
    ),
    // Moon Calendar Route
    GetPage(
      name: AppRoutes.moonCalendar,
      page: () => const MoonCalendarView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: MoonCalendarBinding(),
    ),
    // Numerology Routes
    GetPage(
      name: AppRoutes.numerology,
      page: () => const NumerologyView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: NumerologyBinding(),
    ),
    GetPage(
      name: AppRoutes.numerologyForm,
      page: () => const NumerologyFormView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: NumerologyFormBinding(),
    ),
    GetPage(
      name: AppRoutes.numerologyFeatures,
      page: () => const NumerologyFeaturesView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: NumerologyFormBinding(),
    ),

    GetPage(
      name: AppRoutes.numerologyResult,
      page: () => const NumerologyResultView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.numerologyReports,
      page: () => const NumerologyReportsView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: NumerologyReportsBinding(),
    ),
    GetPage(
      name: AppRoutes.loshuGridForm,
      page: () => const LoShuGridFormView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: LoShuGridFormBinding(),
    ),
    GetPage(
      name: AppRoutes.loshuGridResult,
      page: () => const LoShuGridResultView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: LoShuGridResultBinding(),
    ),
    // Palm Reading Routes
    GetPage(
      name: AppRoutes.palmReading,
      page: () => const PalmReadingView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: PalmReadingBinding(),
    ),
    GetPage(
      name: AppRoutes.palmReadingHistory,
      page: () => const PalmReadingHistoryView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: PalmReadingHistoryBinding(),
    ),
    GetPage(
      name: AppRoutes.palmReadingForm,
      page: () => const PalmReadingFormView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: PalmReadingBinding(),
    ),
    GetPage(
      name: AppRoutes.palmReadingTime,
      page: () => const PalmReadingTimeView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: PalmReadingBinding(),
    ),
    GetPage(
      name: AppRoutes.palmReadingHandGender,
      page: () => const PalmReadingHandGenderView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: PalmReadingBinding(),
    ),
    GetPage(
      name: AppRoutes.palmReadingUpload,
      page: () => const PalmReadingUploadView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: PalmReadingBinding(),
    ),
    GetPage(
      name: AppRoutes.palmReadingCamera,
      page: () => const PalmReadingCameraView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: PalmReadingBinding(),
    ),
    GetPage(
      name: AppRoutes.palmReadingScanning,
      page: () => const PalmReadingScanningView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: PalmReadingBinding(),
    ),
    GetPage(
      name: AppRoutes.palmReadingResults,
      page: () => const PalmReadingResultsView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: PalmReadingBinding(),
    ),
    GetPage(
      name: AppRoutes.palmReadingDetail,
      page: () => const PalmReadingDetailView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: PalmReadingBinding(),
    ),
    GetPage(
      name: AppRoutes.palmReadingAnalysis,
      page: () => const PalmReadingAnalysisView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: PalmReadingBinding(),
    ),
    // Face Reading Route
    GetPage(
      name: AppRoutes.faceReading,
      page: () => const FaceReadingView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.faceReadingUpload,
      page: () => const FaceReadingUploadView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.faceReadingScanning,
      page: () => const FaceReadingScanningView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.faceReadingResults,
      page: () => const FaceReadingResultsView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.faceReadingCategoryDetail,
      page: () => const FaceReadingCategoryDetailView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.faceReadingFeatureDetail,
      page: () => const FaceReadingFeatureDetailView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.faceReadingHistory,
      page: () => const FaceReadingHistoryView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    // Handwriting Astrology Routes
    GetPage(
      name: AppRoutes.handwritingAstrology,
      page: () => const HandwritingAstrologyView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: HandwritingAstrologyBinding(),
    ),
    GetPage(
      name: AppRoutes.handwritingAstrologyUpload,
      page: () => const HandwritingAstrologyUploadView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: HandwritingAstrologyBinding(),
    ),
    GetPage(
      name: AppRoutes.handwritingAstrologyResults,
      page: () => const HandwritingAstrologyResultsView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.handwritingAstrologyHistory,
      page: () => const HandwritingAstrologyHistoryView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    // Vastu Reading Routes
    GetPage(
      name: AppRoutes.vastuDashboard,
      page: () => const VastuDashboardView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.vastuReading,
      page: () => const VastuReadingView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.homeVastuList,
      page: () => const HomeVastuListView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.homeVastuCompass,
      page: () => const HomeVastuCompassView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.officeVastuList,
      page: () => const OfficeVastuListView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.officeVastuCompass,
      page: () => const OfficeVastuCompassView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.vastuDosh,
      page: () => const VastuDoshView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.vastuShastra,
      page: () => const VastuShastraView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.vastuTips,
      page: () => const VastuTipsView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.arVastu,
      page: () => const ARVastuScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.arOnboarding,
      page: () => const AROnboardingScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.vastuCorrection,
      page: () => const VastuCorrectionView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),

    // Tarot Card Reading Route
    GetPage(
      name: AppRoutes.tarotReading,
      page: () => const TarotReadingView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: TarotBinding(),
    ),
    // Carrot Astrology Routes
    GetPage(
      name: AppRoutes.carrotAstrology,
      page: () => const CarrotAstrologyView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.carrotAstrologyForm,
      page: () => const CarrotAstrologyFormView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.carrotAstrologyResults,
      page: () => const CarrotAstrologyResultsView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.carrotAstrologyHistory,
      page: () => const CarrotAstrologyHistoryView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.streamReports,
      page: () => const StreamReportsView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    // Kundli Routes
    GetPage(
      name: AppRoutes.kundliForm,
      page: () => const KundliFormView(),
      binding: KundliFormBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.kundliResult,
      page: () => const KundliResultView(),
      binding: KundliResultBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.shodashvarga,
      page: () => const ShodashvargaView(),
      binding: ShodashvargaBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.dasha,
      page: () => const DashaView(),
      binding: DashaBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.yog,
      page: () => const YogView(),
      binding: YogBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.dosh,
      page: () => const DoshView(),
      binding: DoshBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.sadeSati,
      page: () => const SadeSatiView(),
      binding: SadeSatiBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.gemstonesReport,
      page: () => const GemstonesReportView(),
      binding: GemstonesReportBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.transitToday,
      page: () => const TransitTodayView(),
      binding: TransitTodayBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.kpSystem,
      page: () => const KpSystemView(),
      binding: KpSystemBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.lalKitab,
      page: () => const LalKitabView(),
      binding: LalKitabBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.varshphal,
      page: () => const VarshphalView(),
      binding: VarshphalBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.predictions,
      page: () => const PredictionsView(),
      binding: PredictionsBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.planets,
      page: () => const PlanetsView(),
      binding: PlanetsBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.comingSoon,
      page: () => const ComingSoonPage(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    // Match Making Routes
    GetPage(
      name: AppRoutes.matchMakingGif,
      page: () => const MatchMakingGifView(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.matchMakingForm,
      page: () => const MatchMakingFormView(),
      binding: MatchMakingFormBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.matchMakingResult,
      page: () => const MatchMakingResultView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.matchMakingFullKundli,
      page: () => const MatchMakingFullKundliView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.aiGuider,
      page: () => const AiGuiderView(),
      transition: Transition.downToUp,
      transitionDuration: Duration(milliseconds: 300),
      binding: AiGuiderBinding(),
    ),
    GetPage(
      name: AppRoutes.prashnaKundali,
      page: () => const PrashnaKundaliView(),
      binding: PrashnaKundaliBinding(),
    ),
    GetPage(
      name: AppRoutes.prashnaKundaliHistory,
      page: () => const PrashnaKundaliHistoryView(),
      binding: PrashnaKundaliBinding(),
    ),
    GetPage(
      name: AppRoutes.prashnaKundaliResults,
      page: () => const PrashnaKundaliResultsView(),
      binding: PrashnaKundaliBinding(),
    ),
    // Ramal Shastra Routes
    GetPage(
      name: AppRoutes.ramalShastra,
      page: () => const RamalShastraView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: RamalShastraBinding(),
    ),
    GetPage(
      name: AppRoutes.ramalShastraQuestion,
      page: () => const RamalShastraQuestionView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: RamalShastraBinding(),
    ),
    GetPage(
      name: AppRoutes.ramalShastraMethod,
      page: () => const RamalShastraMethodView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: RamalShastraBinding(),
    ),
    GetPage(
      name: AppRoutes.ramalShastraCastingDice,
      page: () => const RamalShastraCastingDiceView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: RamalShastraBinding(),
    ),
    GetPage(
      name: AppRoutes.ramalShastraCastingCards,
      page: () => const RamalShastraCastingCardsView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: RamalShastraBinding(),
    ),
    GetPage(
      name: AppRoutes.ramalShastraCastingDots,
      page: () => const RamalShastraCastingDotsView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: RamalShastraBinding(),
    ),
    GetPage(
      name: AppRoutes.ramalShastraConfirmation,
      page: () => const RamalShastraConfirmationView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: RamalShastraBinding(),
    ),
    GetPage(
      name: AppRoutes.ramalShastraResults,
      page: () => const RamalShastraResultsView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: RamalShastraBinding(),
    ),
    GetPage(
      name: AppRoutes.ramalShastraHistory,
      page: () => const RamalShastraHistoryView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: RamalShastraBinding(),
    ),
    GetPage(
      name: AppRoutes.ramalShastraStats,
      page: () => const RamalShastraStatsView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: RamalShastraBinding(),
    ),
    GetPage(
      name: AppRoutes.ramalShastraDetail,
      page: () => const RamalShastraDetailView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: RamalShastraBinding(),
    ),
    // E-Mandir Routes
    GetPage(
      name: AppRoutes.namasteHome,
      page: () => const NamasteHomeView(),
      binding: NamasteHomeBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.punyaMudra,
      page: () => const PunyaMudraView(),
      binding: PunyaMudraBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.virtualDarshan,
      page: () => const VirtualDarshanView(),
      binding: VirtualDarshanBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.devotionalLibrary,
      page: () => const DevotionalLibraryView(),
      binding: DevotionalLibraryBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.devotionalPlayer,
      page: () => const DevotionalPlayerView(),
      binding: DevotionalPlayerBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.lyrics,
      page: () => const LyricsView(),
      binding: LyricsBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.meaning,
      page: () => const MeaningView(),
      binding: MeaningBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.bhaktiChakra,
      page: () => const BhaktiChakraView(),
      binding: BhaktiChakraBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.passbook,
      page: () => const PassbookView(),
      binding: PassbookBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.bookPuja,
      page: () => const BookPujaView(),
      binding: BookPoojaBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.pujaDetail,
      page: () => PujaDetailView(),
      binding: PoojaDetailsBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.addressSelection,
      page: () => const AddressSelectionView(),
      binding: AddressSelectionBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.addressForm,
      page: () => const AddressFormView(),
      binding: AddressFormBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.pujaBookingForm,
      page: () => const PujaBookingFormView(),
      binding: PujaBookingFormBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.myBookings,
      page: () => const MyBookingsView(),
      binding: MyBookingsBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.myBookingDetail,
      page: () => const MyBookingDetailView(),
      binding: MyBookingDetailBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.userPrivacyPolicy,
      page: () => const UserPrivacyPolicyView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.reportPdfView,
      page: () => const ReportPdfView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.eMandirFestivalDetail,
      page: () => const EMandirFestivalDetailView(),
      binding: EMandirFestivalDetailBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.allFestivals,
      page: () => const AllFestivalView(),
      binding: AllFestivalBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
  ];
}
