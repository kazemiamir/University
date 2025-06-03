import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:xml/xml.dart' as xml;

class SMSService {
  // اطلاعات کاربری پنل ملی پیامک
  static const String _username = '09396876476';
  static const String _password = 'e5783450-bd1c-4714-af95-de1beeb3a51e';
  static const String _sender = '50002710076476';
  static const String _baseUrl = 'https://rest.payamak-panel.com/api/SendSMS';

  static String _parseXmlResponse(String xmlStr) {
    try {
      if (xmlStr.contains('"RetStatus":1')) {
        return "1";
      }
      return "0";
    } catch (e) {
      print('Error parsing response: $e');
      return "0";
    }
  }

  static Future<bool> checkAPIStatus() async {
    try {
      print('\n=== Checking API Status ===');
      
      final response = await http.post(
        Uri.parse('$_baseUrl/GetCredit'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          'Accept': 'text/xml',
        },
        encoding: Encoding.getByName('utf-8'),
        body: {
          'username': _username,
          'password': _password,
        },
      );

      print('Status Check Response: ${response.body}');
      
      if (response.statusCode == 200) {
        final credit = _parseXmlResponse(response.body);
        print('Credit Value: $credit');
        final creditValue = double.tryParse(credit);
        if (creditValue != null) {
          print('اعتبار باقیمانده: $creditValue ریال');
          return true;
        }
      }
      
      return false;
    } catch (e) {
      print('Error checking API status: $e');
      return false;
    }
  }

  static String generateOTP() {
    final random = Random();
    String otp = '';
    for (int i = 0; i < 6; i++) {
      otp += random.nextInt(10).toString();
    }
    print('Generated OTP: $otp');
    return otp;
  }

  static Future<bool> sendOTP(String phone, String otp) async {
    try {
      print('\n=== شروع فرآیند ارسال پیامک ===');
      print('شماره موبایل اصلی: $phone');
      
      String formattedPhone = phone;
      if (formattedPhone.startsWith('0')) {
        formattedPhone = formattedPhone.substring(1);
      }
      formattedPhone = '98$formattedPhone';
      
      print('شماره موبایل فرمت شده: $formattedPhone');
      print('کد تایید: $otp');

      final Map<String, String> requestData = {
        'username': _username,
        'password': _password,
        'to': formattedPhone,
        'from': _sender,
        'text': 'کد:$otp',
        'isflash': 'false',
      };

      final uri = Uri.parse('$_baseUrl/SendSMS');
      print('آدرس درخواست: ${uri.toString()}');
      print('داده‌های درخواست: $requestData');

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        },
        encoding: Encoding.getByName('utf-8'),
        body: requestData,
      );
      
      print('کد وضعیت: ${response.statusCode}');
      print('پاسخ: ${response.body}');

      if (response.statusCode == 200) {
        final result = _parseXmlResponse(response.body);
        print('نتیجه: $result');
        final status = int.tryParse(result);
        return status == 1;
      }
      
      return false;
    } catch (e) {
      print('❌ خطا در ارسال پیامک');
      print('جزئیات خطا: $e');
      return false;
    }
  }

  static Future<bool> testAPICredentials() async {
    try {
      print('\n=== تست اعتبارسنجی API ===');
      
      final uri = Uri.parse('$_baseUrl/GetCredit');
      final data = {
        'username': _username,
        'password': _password,
      };
      
      print('در حال تست اعتبارسنجی...');
      
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          'Accept': 'text/xml',
        },
        encoding: Encoding.getByName('utf-8'),
        body: data,
      );
      
      print('کد وضعیت: ${response.statusCode}');
      print('پاسخ: ${response.body}');
      
      if (response.statusCode == 200) {
        final credit = _parseXmlResponse(response.body);
        print('اعتبار: $credit');
        
        final creditValue = double.tryParse(credit);
        return creditValue != null && creditValue > 0;
      }
      
      return false;
    } catch (e) {
      print('خطا در تست اعتبارسنجی: $e');
      return false;
    }
  }

  // Test function to verify SMS service
  static Future<void> testSMSService() async {
    print('\n=== Testing SMS Service ===');
    final testPhone = '09396876476';
    final otp = generateOTP();
    
    print('Sending test SMS...');
    final result = await sendOTP(testPhone, otp);
    
    if (result) {
      print('✅ Test SMS sent successfully');
    } else {
      print('❌ Test SMS failed');
    }
    print('========================\n');
  }
}