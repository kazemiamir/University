class Banner {
  final String imageUrl;
  final String title;
  final String? description;
  final String? link;

  Banner({
    required this.imageUrl,
    required this.title,
    this.description,
    this.link,
  });
}

// لیست نمونه از بنرها
final List<Banner> dummyBanners = [
  Banner(
    imageUrl: 'assets/images/banner1.jpg',
    title: 'آیفون ۱۵ پرو',
    description: 'جدیدترین گوشی اپل با تخفیف ویژه',
  ),
  Banner(
    imageUrl: 'assets/images/banner2.jpg',
    title: 'ساعت‌های هوشمند سامسونگ',
    description: 'تا ۳۰٪ تخفیف برای خرید نقدی',
  ),
  Banner(
    imageUrl: 'assets/images/banner3.jpg',
    title: 'لوازم جانبی گیمینگ',
    description: 'هدست، کیبورد و ماوس حرفه‌ای',
  ),
]; 