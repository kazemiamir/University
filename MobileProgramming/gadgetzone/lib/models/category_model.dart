import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final IconData icon;
  final Color? color;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    this.color,
  });
}

// لیست نمونه از دسته‌بندی‌ها
final List<Category> dummyCategories = [
  Category(
    id: 'phones',
    name: 'موبایل',
    icon: Icons.phone_android,
    color: Colors.blue,
  ),
  Category(
    id: 'laptops',
    name: 'لپ‌تاپ',
    icon: Icons.laptop,
    color: Colors.green,
  ),
  Category(
    id: 'tablets',
    name: 'تبلت',
    icon: Icons.tablet_mac,
    color: Colors.orange,
  ),
  Category(
    id: 'watches',
    name: 'ساعت هوشمند',
    icon: Icons.watch,
    color: Colors.purple,
  ),
  Category(
    id: 'accessories',
    name: 'لوازم جانبی',
    icon: Icons.headphones,
    color: Colors.red,
  ),
  Category(
    id: 'gaming',
    name: 'گیمینگ',
    icon: Icons.sports_esports,
    color: Colors.indigo,
  ),
  Category(
    id: 'cameras',
    name: 'دوربین',
    icon: Icons.camera_alt,
    color: Colors.teal,
  ),
  Category(
    id: 'audio',
    name: 'صوتی',
    icon: Icons.speaker,
    color: Colors.brown,
  ),
]; 