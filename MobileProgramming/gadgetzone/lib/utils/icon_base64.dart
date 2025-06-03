import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class IconBase64 {
  static const String base64Icon = '''
iVBORw0KGgoAAAANSUhEUgAABAAAAAQACAIAAADwf7zCAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH4QgR
DjcqPCuqugAAAAd0RVh0QXV0aG9yAKmuzEgAAAAMdEVYdERlc2NyaXB0aW9uABMJISMAAAAKdEVYdENvcHlyaWdo
dACsD8w6AAAAB3RJTUUH4QgRDjc0PrEQugAAAQZJREFUeJztwTEBAAAAwqD1T20ND6AAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
''';

  static Future<void> createAppIcon() async {
    try {
      // تبدیل Base64 به بایت‌ها
      final bytes = base64Decode(base64Icon);
      
      // ایجاد پوشه assets/images اگر وجود نداشت
      final directory = Directory('assets/images');
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }

      // ذخیره فایل‌ها
      await File('assets/images/app_icon.png').writeAsBytes(bytes);
      await File('assets/images/app_icon_foreground.png').writeAsBytes(bytes);

      print('✅ آیکون‌ها با موفقیت ساخته شدند');
    } catch (e) {
      print('❌ خطا در ساخت آیکون‌ها: $e');
    }
  }
} 