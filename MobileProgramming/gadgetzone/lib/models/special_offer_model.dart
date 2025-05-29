class SpecialOffer {
  final String id;
  final String name;
  final String imageUrl;
  final double originalPrice;
  final double discountedPrice;
  final int discountPercentage;
  final String? description;
  final DateTime endTime;

  SpecialOffer({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.originalPrice,
    required this.discountedPrice,
    required this.discountPercentage,
    this.description,
    required this.endTime,
  });
}

// لیست نمونه از پیشنهادات ویژه
final List<SpecialOffer> dummySpecialOffers = [
  SpecialOffer(
    id: '1',
    name: 'ایرپاد پرو',
    imageUrl: 'assets/images/airpods.png',
    originalPrice: 249.99,
    discountedPrice: 199.99,
    discountPercentage: 20,
    description: 'نسل دوم با نویز کنسلینگ',
    endTime: DateTime.now().add(const Duration(days: 2)),
  ),
  SpecialOffer(
    id: '2',
    name: 'گلکسی واچ 6',
    imageUrl: 'assets/images/galaxy_watch.png',
    originalPrice: 399.99,
    discountedPrice: 299.99,
    discountPercentage: 25,
    description: 'پایش سلامت پیشرفته',
    endTime: DateTime.now().add(const Duration(days: 3)),
  ),
  SpecialOffer(
    id: '3',
    name: 'شیائومی ردمی بادز 4',
    imageUrl: 'assets/images/redmi_buds.png',
    originalPrice: 79.99,
    discountedPrice: 49.99,
    discountPercentage: 37,
    description: 'کیفیت صدای فوق‌العاده',
    endTime: DateTime.now().add(const Duration(days: 1)),
  ),
]; 