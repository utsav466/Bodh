import 'package:bodh_flutter/core/api/api_endpoints.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EsewaWebViewScreen extends StatefulWidget {
  final String paymentUrl;
  final Map<String, dynamic> payload;
  final String orderId;

  const EsewaWebViewScreen({
    super.key,
    required this.paymentUrl,
    required this.payload,
    required this.orderId,
  });

  @override
  State<EsewaWebViewScreen> createState() => _EsewaWebViewScreenState();
}

class _EsewaWebViewScreenState extends State<EsewaWebViewScreen> {
  late final WebViewController _controller;

  bool _loading = true;
  bool _callbackDetected = false;
  bool _resultSent = false;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            debugPrint("WEBVIEW START URL: $url");

            if (mounted) {
              setState(() => _loading = true);
            }

            final uri = Uri.tryParse(url);
            final path = uri?.path ?? "";

            if (path == ApiEndpoints.esewaSuccessPath ||
                path == ApiEndpoints.esewaFailurePath) {
              _callbackDetected = true;
            }
          },
          onPageFinished: (url) async {
            debugPrint("WEBVIEW FINISH URL: $url");

            if (mounted) {
              setState(() => _loading = false);
            }

            if (_callbackDetected && !_resultSent) {
              final uri = Uri.tryParse(url);
              final path = uri?.path ?? "";

              if (path == ApiEndpoints.esewaSuccessPath) {
                _resultSent = true;
                await Future.delayed(const Duration(milliseconds: 1000));
                if (!mounted) return;
                Navigator.pop(context, {
                  "success": true,
                  "orderId": widget.orderId,
                });
              }

              if (path == ApiEndpoints.esewaFailurePath) {
                _resultSent = true;
                await Future.delayed(const Duration(milliseconds: 1000));
                if (!mounted) return;
                Navigator.pop(context, {
                  "success": false,
                  "orderId": widget.orderId,
                });
              }
            }
          },
          onNavigationRequest: (request) {
            debugPrint("WEBVIEW NAV URL: ${request.url}");
            return NavigationDecision.navigate;
          },
          onWebResourceError: (error) {
            debugPrint(
              "WEBVIEW ERROR: ${error.errorCode} ${error.description}",
            );
          },
        ),
      )
      ..loadHtmlString(
        _buildAutoSubmitHtml(
          actionUrl: widget.paymentUrl,
          payload: widget.payload,
        ),
      );
  }

  String _buildAutoSubmitHtml({
    required String actionUrl,
    required Map<String, dynamic> payload,
  }) {
    final inputFields = payload.entries.map((entry) {
      final key = entry.key;
      final value = entry.value.toString().replaceAll('"', '&quot;');
      return '<input type="hidden" name="$key" value="$value" />';
    }).join('\n');

    return '''
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>eSewa Payment</title>
</head>
<body onload="document.forms[0].submit();">
<form method="POST" action="$actionUrl">
$inputFields
</form>
<div style="font-family: Arial; text-align: center; margin-top: 40px;">
Redirecting to eSewa...
</div>
</body>
</html>
''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pay with eSewa"),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_loading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}