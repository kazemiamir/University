import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('راهنما'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // راهنمای خرید
          _buildSection(
            title: 'راهنمای خرید',
            icon: Icons.shopping_cart,
            items: [
              _HelpItem(
                title: 'چگونه خرید کنم؟',
                content: '1. محصول مورد نظر خود را انتخاب کنید\n'
                    '2. روی دکمه "افزودن به سبد خرید" کلیک کنید\n'
                    '3. به صفحه سبد خرید بروید\n'
                    '4. اطلاعات ارسال را تکمیل کنید\n'
                    '5. پرداخت را انجام دهید',
              ),
              _HelpItem(
                title: 'روش‌های پرداخت',
                content: '• پرداخت آنلاین با درگاه بانکی\n'
                    '• پرداخت در محل (برای تهران)\n'
                    '• کارت به کارت',
              ),
              _HelpItem(
                title: 'هزینه ارسال',
                content: '• ارسال رایگان برای خریدهای بالای 500 هزار تومان\n'
                    '• تهران: 20 هزار تومان\n'
                    '• شهرستان‌ها: 35 هزار تومان',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // پیگیری سفارش
          _buildSection(
            title: 'پیگیری سفارش',
            icon: Icons.local_shipping,
            items: [
              _HelpItem(
                title: 'وضعیت سفارش',
                content: 'برای پیگیری سفارش خود می‌توانید:\n'
                    '1. به بخش "سفارش‌های من" در پروفایل مراجعه کنید\n'
                    '2. کد رهگیری پستی را در سایت پست پیگیری کنید\n'
                    '3. با پشتیبانی تماس بگیرید',
              ),
              _HelpItem(
                title: 'زمان تحویل',
                content: '• تهران: 1 تا 2 روز کاری\n'
                    '• شهرستان‌ها: 2 تا 4 روز کاری\n'
                    '• مناطق دورافتاده: 4 تا 7 روز کاری',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // گارانتی و مرجوعی
          _buildSection(
            title: 'گارانتی و مرجوعی',
            icon: Icons.security,
            items: [
              _HelpItem(
                title: 'شرایط مرجوعی',
                content: '• تا 7 روز فرصت مرجوعی دارید\n'
                    '• کالا باید در بسته‌بندی اصلی باشد\n'
                    '• لوازم جانبی کامل باشند\n'
                    '• کالا استفاده نشده باشد',
              ),
              _HelpItem(
                title: 'گارانتی محصولات',
                content: '• 18 ماه گارانتی شرکتی\n'
                    '• تعویض در 24 ساعت اول\n'
                    '• خدمات پس از فروش',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // تماس با ما
          _buildSection(
            title: 'تماس با ما',
            icon: Icons.contact_support,
            items: [
              _HelpItem(
                title: 'راه‌های ارتباطی',
                content: '• تلفن: 021-12345678\n'
                    '• ایمیل: support@gadgetzone.com\n'
                    '• آدرس: تهران، خیابان ولیعصر\n'
                    '• ساعات پاسخگویی: 9 صبح تا 9 شب',
              ),
              _HelpItem(
                title: 'شبکه‌های اجتماعی',
                content: '• اینستاگرام: @gadgetzone\n'
                    '• تلگرام: @gadgetzone_support\n'
                    '• واتساپ: 0912-3456789',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<_HelpItem> items,
  }) {
    return Card(
      child: ExpansionTile(
        leading: Icon(icon),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        children: items.map((item) => _buildHelpItem(item)).toList(),
      ),
    );
  }

  Widget _buildHelpItem(_HelpItem item) {
    return ExpansionTile(
      title: Text(item.title),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            item.content,
            style: const TextStyle(
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _HelpItem {
  final String title;
  final String content;

  _HelpItem({
    required this.title,
    required this.content,
  });
} 