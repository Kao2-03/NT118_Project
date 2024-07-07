import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

Future<String> createPaypalUrl({
  required String clientId,
  required String secretKey,
  required String currencyCode,
  required String intent,
  required double amount,
  required String returnUrl,
  required String cancelUrl,
  required String baseUrl,
}) async {
  // Tạo Access Token từ PayPal
  final authHeader = base64Encode(utf8.encode('$clientId:$secretKey'));
  final tokenResponse = await http.post(
    Uri.parse('https://api.sandbox.paypal.com/v1/oauth2/token'),
    headers: {
      'Authorization': 'Basic $authHeader',
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: 'grant_type=client_credentials',
  );

  if (tokenResponse.statusCode != 200) {
    throw Exception('Lỗi khi lấy access token: ${tokenResponse.body}');
  }

  final tokenData = jsonDecode(tokenResponse.body);
  final accessToken = tokenData['access_token'];

  // Tạo yêu cầu thanh toán
  final paymentResponse = await http.post(
    Uri.parse('https://api.sandbox.paypal.com/v1/payments/payment'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
    body: jsonEncode({
      'intent': intent,
      'redirect_urls': {
        'return_url': returnUrl,
        'cancel_url': cancelUrl,
      },
      'payer': {
        'payment_method': 'paypal',
      },
      'transactions': [
        {
          'amount': {
            'total': amount.toStringAsFixed(2),
            'currency': currencyCode,
          },
          'description': 'Mô tả giao dịch ở đây',
        },
      ],
    }),
  );

  if (paymentResponse.statusCode != 201) {
    throw Exception('Lỗi khi tạo yêu cầu thanh toán: ${paymentResponse.body}');
  }

  final paymentData = jsonDecode(paymentResponse.body);
  final approvalUrl = paymentData['links'].firstWhere((link) => link['rel'] == 'approval_url')['href'];

  return approvalUrl;
}
