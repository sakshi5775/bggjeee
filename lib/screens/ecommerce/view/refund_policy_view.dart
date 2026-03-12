import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';

class RefundPolicyView extends StatelessWidget {
  const RefundPolicyView({super.key});

  static const Color _maroon = Color(0xFF68171E);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        endDrawer: const CommonEndDrawer(),
        body: SafeArea(
          child: Column(
            children: [
              const CommonHeader(title: 'Refund Policy'),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _mainTitle('NATIONAL POLICIES'),
                      _sectionTitle(
                          'Refund, Cancellation & Satisfaction Guarantee Policy'),
                      _body('AstrobharatAI.com\nLast Updated: January 2026'),
                      _body(
                        'At AstrobharatAI, your trust matters deeply to us. '
                        'We understand that astrology is personal, and choosing a digital platform requires confidence. '
                        'That is why we are committed to clear pricing, honest communication, and fair solutions whenever something does not meet your expectations.\n\n'
                        'This policy explains how refunds, cancellations, and support work—in simple, transparent language, with your comfort in mind.\n\n'
                        'This Policy applies to all purchases made on www.astrobharatai.com and the AstrobharatAI mobile applications.',
                      ),
                      _divider(),
                      _sectionTitle(
                          '1. Our Satisfaction Guarantee – Try With Confidence'),
                      _body(
                        'We believe astrology should support and empower, never create regret.\n\n'
                        'If you are a first-time subscriber and feel that AstrobharatAI is not right for you, we offer a 48-hour satisfaction guarantee from the time of purchase.\n\n'
                        '• No complicated process\n'
                        '• No uncomfortable questions\n'
                        '• Just reach out to us within 48 hours\n\n'
                        'This guarantee exists so you can explore AstrobharatAI with peace of mind and confidence.',
                      ),
                      _divider(),
                      _sectionTitle('2. Subscription Plans'),
                      _body(
                          '(AI Astrology, Premium Features, Learning Access)'),
                      _subTitle('2.1 Free Trial (If Available)'),
                      _body(
                        '• You may cancel anytime during the free trial period.\n'
                        '• If you cancel before the trial ends, you will not be charged.',
                      ),
                      _subTitle('2.2 Paid Subscription – Easy Cancellation'),
                      _body(
                        '• You can cancel your subscription anytime from your account dashboard.\n'
                        '• Cancellation stops future billing immediately.\n'
                        '• You will continue to enjoy your subscription benefits until the end of your current billing cycle.\n\n'
                        'No hidden steps. No penalties.',
                      ),
                      _subTitle('2.3 Subscription Refunds – Fair & Transparent'),
                      _body(
                        'We handle subscription refunds as follows:\n\n'
                        '✔ Within 48 hours of your first-ever subscription purchase\n'
                        '→ You are eligible for a full refund, provided the service has not been heavily used.\n\n'
                        '✔ After 48 hours or after significant usage\n'
                        '→ Refunds may not apply, but your subscription will remain active until it naturally expires.\n\n'
                        'What do we mean by "significant usage"?\n'
                        'This may include:\n'
                        '• Generating multiple AI reports\n'
                        '• Accessing extensive personalized or premium content\n'
                        '• Using expert consultations\n\n'
                        'These limits help us stay fair to all users while keeping our guarantee meaningful.',
                      ),
                      _divider(),
                      _sectionTitle('3. Digital Astrology Services & Reports'),
                      _body(
                        'This includes:\n'
                        '• AI-generated astrology reports\n'
                        '• Personalized predictions\n'
                        '• Horoscope, numerology, and palmistry readings\n'
                        '• Astrology consultations (chat, audio, or video)\n\n'
                        '3.1 How Refunds Work\n'
                        'Because these services are created specifically for you, refunds are generally not available once the service has been delivered or accessed.\n\n'
                        '3.2 We Will Always Help If Something Goes Wrong\n'
                        'If you experience any of the following, please contact us—we are here to support you:\n'
                        '• The service was not delivered\n'
                        '• The content was incomplete or not accessible\n'
                        '• A system or payment error occurred\n\n'
                        'Please reach out within 24 hours of delivery, and we will fix the issue, re-deliver the service, or issue a refund when appropriate.',
                      ),
                      _divider(),
                      _sectionTitle('4. E-Mart Purchases'),
                      _subTitle('4.1 Physical Products'),
                      _body(
                        '(Books, Pooja Items, Accessories)\n\n'
                        'We want you to receive what you ordered, in good condition.\n\n'
                        'You are eligible for a refund or replacement if:\n'
                        '• The item arrived damaged or defective\n'
                        '• The wrong item was delivered\n'
                        '• You report the issue within 48 hours of delivery\n\n'
                        'For faster resolution, we may request a photo or short video.\n\n'
                        'When Refunds May Not Apply\n'
                        'Refunds or replacements may not be possible if:\n'
                        '• Damage occurred due to misuse\n'
                        '• Original packaging is missing\n'
                        '• The product was customized, energized, or ritual-specific (unless damaged on delivery)',
                      ),
                      _subTitle('4.2 Digital Products'),
                      _body(
                        '(E-Books, Courses, Downloads)\n\n'
                        '• Digital products are non-refundable once accessed or downloaded.\n'
                        '• If you face a technical issue, please contact us—we will assist promptly.',
                      ),
                      _divider(),
                      _sectionTitle('5. E-Pooja & Ritual Services'),
                      _body(
                        '• You may cancel an E-Pooja booking up to 24 hours before the scheduled time.\n'
                        '• Eligible cancellations may receive a full refund or rescheduling.\n'
                        '• Once a ritual has been completed, refunds are not applicable, as the service has already been performed.',
                      ),
                      _divider(),
                      _sectionTitle('6. Refund Processing – What to Expect'),
                      _body(
                        '• Approved refunds are processed within 5–7 business days.\n'
                        '• Refunds are issued to the original payment method.\n'
                        '• Bank processing times may vary, but we will keep you informed if delays occur.',
                      ),
                      _divider(),
                      _sectionTitle('7. We\'re Here to Help'),
                      _body(
                        'If you ever need support, refunds, or clarification, please reach out.\n'
                        'We believe in human conversations, not automated rejections.\n\n'
                        '📧 support@astrobharatai.com\n'
                        '📱 In-App Support / WhatsApp\n'
                        '🕘 Support Hours: 9:00 AM – 9:00 PM IST\n\n'
                        'To help us assist you faster, please share:\n'
                        '• Order ID\n'
                        '• Registered email or mobile number\n'
                        '• A brief description of the issue',
                      ),
                      _divider(),
                      _sectionTitle('8. Fair Use – Protecting Everyone'),
                      _body(
                        'We trust our users, and we expect the same in return.\n\n'
                        'In rare cases, refunds may be declined if there is:\n'
                        '• Repeated misuse of refund requests\n'
                        '• Fraudulent or suspicious activity\n'
                        '• Violation of platform terms\n\n'
                        'This helps us protect genuine users while keeping our policies fair and sustainable.',
                      ),
                      _divider(),
                      _sectionTitle('9. Policy Updates'),
                      _body(
                        'As AstrobharatAI grows, we may update this policy to serve you better.\n'
                        'Any changes will be clearly published on our website and app and will apply going forward.',
                      ),
                      _divider(),
                      _sectionTitle('🌟 AstrobharatAI Trust Promise'),
                      _body(
                        '✔ 48-Hour Satisfaction Guarantee for First-Time Subscribers\n'
                        '✔ Simple & Transparent Refund Policy\n'
                        '✔ Secure Payments & Trusted Services\n'
                        '✔ Real Human Support When You Need It\n\n'
                        'Your trust is more important than any transaction.',
                      ),
                      const SizedBox(height: 28),
                      _sectionTitle(
                          'Terms & Conditions – Refund & Cancellation Clause Alignment'),
                      _body('Payments, Refunds & Cancellations'),
                      _body(
                        'All payments made on AstrobharatAI.com and its mobile applications are subject to the Refund, Cancellation & Satisfaction Guarantee Policy published on the platform, which forms an integral part of these Terms & Conditions.\n\n'
                        'By completing a purchase, the user expressly acknowledges and agrees that:\n\n'
                        '1. Subscription Services\n'
                        '• Subscription fees are billed in advance for the selected billing cycle.\n'
                        '• Users may cancel subscriptions at any time to avoid future charges.\n'
                        '• A one-time, first-time subscriber satisfaction guarantee allows eligible users to request a full refund within 48 hours of purchase, subject to fair-use limitations.\n\n'
                        '2. Personalized Digital Services\n'
                        '• Astrology reports, AI-generated insights, consultations, and other personalized services are customized based on user-provided information.\n'
                        '• Once such services are delivered or accessed, they are non-refundable, except in cases of non-delivery, technical failure, or verified platform error.\n\n'
                        '3. E-Mart Purchases\n'
                        '• Physical product refunds or replacements are permitted only for damaged, defective, or incorrectly delivered items, reported within the specified timeframe.\n'
                        '• Digital products are non-refundable once accessed or downloaded.\n\n'
                        '4. E-Pooja & Ritual Services\n'
                        '• Ritual services may be canceled up to 24 hours before the scheduled time.\n'
                        '• No refunds are applicable once a ritual has been performed.\n\n'
                        '5. Fair-Use Enforcement\n'
                        '• Astrobharat AI reserves the right to refuse refunds in cases of abuse, excessive refund requests, fraud, or violation of these Terms.\n\n'
                        'The company\'s determination regarding refund eligibility shall be final and binding, subject to applicable consumer protection laws.',
                      ),
                      const SizedBox(height: 24),
                      _sectionTitle(
                          'Refund & Cancellation – Frequently Asked Questions (FAQs)'),
                      _body(
                          'This FAQ is published as a standalone Help / Support page.\n'),
                      _faqItem(
                        '1. Can I cancel my subscription anytime?',
                        'Yes. You may cancel your subscription at any time from your account dashboard. Your access will remain active until the end of the current billing cycle, and no future charges will apply.',
                      ),
                      _faqItem(
                        '2. Do you offer refunds on subscriptions?',
                        'Yes. If you are a first-time subscriber, you are eligible for a 100% refund within 48 hours of purchase, provided there has not been excessive usage of premium features.',
                      ),
                      _faqItem(
                        '3. What is considered "excessive usage"?',
                        'Excessive usage includes multiple AI report generations, personalized content access, or consultations within a short period. This safeguard ensures fairness for all users.',
                      ),
                      _faqItem(
                        '4. Are astrology reports refundable?',
                        'Astrology reports and personalized digital services are generally non-refundable once delivered, as they are created specifically for you. However, we will gladly assist if there is a technical issue or delivery failure.',
                      ),
                      _faqItem(
                        '5. What if I didn\'t receive my report or service?',
                        'If a service is not delivered or is technically inaccessible, please contact us within 24 hours, and we will resolve the issue promptly or issue a refund if applicable.',
                      ),
                      _faqItem(
                        '6. What is the refund policy for E-Mart products?',
                        '• Physical products: Refund or replacement for damaged, defective, or incorrect items reported within 48 hours of delivery.\n• Digital products: Non-refundable once downloaded or accessed.',
                      ),
                      _faqItem(
                        '7. Can I cancel an E-Pooja booking?',
                        'Yes. You may cancel an E-Pooja booking up to 24 hours before the scheduled time for a full refund or rescheduling. Once the pooja has been performed, refunds are not applicable.',
                      ),
                      _faqItem(
                        '8. How long does a refund take?',
                        'Approved refunds are processed within 5–7 business days and credited to the original payment method.',
                      ),
                      _faqItem(
                        '9. How do I request a refund?',
                        'Simply contact us via:\n• Email: support@astrobharatai.com\n• In-App Help or WhatsApp Support\nPlease share your order ID and registered contact details for faster resolution.',
                      ),
                      _sectionTitle('Premium Trust Positioning'),
                      _body(
                        '◆ AstrobharatAI Trust Guarantee\n'
                        '◆ 48-Hour Satisfaction Promise\n'
                        '◆ Transparent Refunds\n'
                        '◆ Secure Payments',
                      ),
                      const SizedBox(height: 28),
                      _mainTitle('INTERNATIONAL POLICIES'),
                      _sectionTitle('International Refund Policy'),
                      _body(
                          'For Our Global AstrobharatAI Community\nIssued: Jan 2026\n\n'),
                      _body(
                        'AstrobharatAI welcomes users from around the world, and we are committed to treating every customer—no matter where they are—with fairness, clarity, and respect.\n'
                        'If you ever feel something didn\'t work as expected, we\'re here to help.',
                      ),
                      _divider(),
                      _sectionTitle('Our Global Promise'),
                      _body(
                        'Wherever you are located, our goal is simple: to make your experience with AstrobharatAI comfortable, transparent, and worry-free.\n\n'
                        'We follow the same core refund principles for international users as we do for domestic users, with a few location-specific considerations explained below.',
                      ),
                      _sectionTitle('1. Subscriptions – International Users'),
                      _body(
                        '• If you are a first-time subscriber, you are eligible for our 48-hour satisfaction guarantee, worldwide.\n'
                        '• If AstrobharatAI isn\'t right for you, simply contact us within 48 hours of purchase, and we\'ll review your request with care.\n'
                        '• There is no complicated process—just reach out to our support team.\n\n'
                        'Once approved, your refund will be issued to your original payment method.\n\n'
                        'We understand trying a new platform takes trust. This guarantee exists to make that first step easy.',
                      ),
                      _sectionTitle('2. Currency & Payment Transparency'),
                      _body(
                        '• Refunds are processed in the same currency used for the original purchase.\n'
                        '• Depending on your country or bank, currency conversion or processing fees may apply. These are set by payment providers, not AstrobharatAI—but we will always be transparent about what to expect.\n'
                        '• Any applicable taxes (VAT, GST, or sales tax) are refunded wherever regulations allow.\n\n'
                        'If you have questions about your refund amount, our support team is happy to explain.',
                      ),
                      _sectionTitle('3. Digital & Personalized Services'),
                      _body(
                        'Astrology services are often personal and customized, which means:\n\n'
                        '• Personalized reports, AI insights, and consultations are non-refundable once delivered, as they are created specifically for you.\n\n'
                        'That said, we will always help if:\n'
                        '• Your service was not delivered\n'
                        '• You faced a technical or access issue\n'
                        '• A payment was charged incorrectly\n\n'
                        'Please contact us within 24 hours, and we will resolve the issue or issue a refund where appropriate.',
                      ),
                      _sectionTitle('4. E-Mart Orders (International Shipping)'),
                      _body(
                        'For physical products shipped internationally:\n\n'
                        '• If your item arrives damaged, defective, or incorrect, please let us know within 48 hours of delivery.\n'
                        '• Share a photo or short video, and we will work with you to arrange a replacement or refund, depending on what is fastest and most practical.\n\n'
                        'Please note:\n'
                        '• International shipping fees, customs duties, or import taxes are usually non-refundable, as they are charged by external authorities.\n'
                        '• We will always guide you clearly if this applies to your order.',
                      ),
                      _sectionTitle('5. App Store & Third-Party Purchases'),
                      _body(
                        'If you made a purchase through:\n'
                        '• Apple App Store\n'
                        '• Google Play Store\n'
                        '• Another third-party platform\n\n'
                        'Refunds are processed according to that platform\'s policies.\n\n'
                        'However, you are not on your own—our team will assist you with guidance and documentation wherever possible.',
                      ),
                      _sectionTitle('6. Local Consumer Rights'),
                      _body(
                        '• This policy is designed to work globally.\n'
                        '• If local consumer protection laws in your country provide additional rights, those rights will always be respected.\n\n'
                        'Our intent is never to restrict fair consumer protections, but to support them.',
                      ),
                      _sectionTitle('7. We\'re Here for You'),
                      _body(
                        'If you need help or have questions—before or after a purchase—please reach out.\n\n'
                        '📧 support@astrobharatai.com\n'
                        '🕘 Support Hours: 9:00 AM – 9:00 PM IST\n'
                        '(We respond with care, even across time zones.)',
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mainTitle(String text) {
    final style = TextStyle(
      fontFamily: 'Poppins',
      fontSize: 18,
      fontWeight: FontWeight.w800,
      color: _maroon,
      letterSpacing: 0.5,
    );
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Text(text, style: style),
    );
  }

  Widget _sectionTitle(String text) {
    final style = TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: _maroon,
      height: 1.3,
    );
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(text, style: style),
    );
  }

  Widget _subTitle(String text) {
    final style = TextStyle(
      fontFamily: 'Poppins',
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: _maroon.withValues(alpha: 0.9),
    );
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Text(text, style: style),
    );
  }

  Widget _body(String text) {
    final style = TextStyle(
      fontFamily: 'Poppins',
      fontSize: 13,
      color: AppColors.textPrimary,
      height: 1.5,
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: style),
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Divider(
        color: _maroon.withValues(alpha: 0.25),
        thickness: 1,
      ),
    );
  }

  Widget _faqItem(String q, String a) {
    final questionStyle = TextStyle(
      fontFamily: 'Poppins',
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: _maroon,
    );
    final answerStyle = TextStyle(
      fontFamily: 'Poppins',
      fontSize: 12,
      color: AppColors.textPrimary,
      height: 1.45,
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(q, style: questionStyle),
          const SizedBox(height: 4),
          Text(a, style: answerStyle),
        ],
      ),
    );
  }
}
