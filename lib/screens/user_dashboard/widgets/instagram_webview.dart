import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InstagramWebView extends StatefulWidget {
  final String url;
  const InstagramWebView({super.key, required this.url});

  @override
  State<InstagramWebView> createState() => _InstagramWebViewState();
}

class _InstagramWebViewState extends State<InstagramWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            // Ignore ERR_UNKNOWN_URL_SCHEME as it's expected for deep links
            if (!error.description.contains('ERR_UNKNOWN_URL_SCHEME')) {
              debugPrint('Instagram WebView Error: ${error.description}');
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            // Handle external URLs (like instagram://, intent://, etc.)
            final uri = Uri.parse(request.url);
            if (uri.scheme != 'http' && uri.scheme != 'https') {
              // Try to launch the external URL
              _launchExternalUrl(request.url);
              return NavigationDecision.prevent;
            }
            // Allow normal http/https navigation
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  Future<void> _launchExternalUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Could not launch external URL: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(
          controller: _controller,
          gestureRecognizers: {
            Factory<VerticalDragGestureRecognizer>(
              () => VerticalDragGestureRecognizer(),
            ),
            Factory<HorizontalDragGestureRecognizer>(
              () => HorizontalDragGestureRecognizer(),
            ),
            Factory<TapGestureRecognizer>(() => TapGestureRecognizer()),
            Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()),
            Factory<LongPressGestureRecognizer>(
              () => LongPressGestureRecognizer(),
            ),
          },
        ),
        if (_isLoading)
          Center(child: CircularProgressIndicator(color: '#820B17'.toColor())),
      ],
    );
  }
}
