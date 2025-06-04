import 'package:flutter/material.dart';
import '../models/category_model.dart';

final List<Category> dummyCategories = [
  Category(
    id: 'c1',
    name: 'گوشی موبایل',
    icon: Icons.phone_android,
    color: Colors.blue,
    description: 'انواع گوشی‌های هوشمند',
  ),
  Category(
    id: 'c2',
    name: 'لپ تاپ',
    icon: Icons.laptop,
    color: Colors.purple,
    description: 'لپ‌تاپ‌های حرفه‌ای و گیمینگ',
  ),
  Category(
    id: 'c3',
    name: 'تبلت',
    icon: Icons.tablet_android,
    color: Colors.orange,
    description: 'تبلت‌های اندروید و آیپد',
  ),
  Category(
    id: 'c4',
    name: 'ساعت هوشمند',
    icon: Icons.watch,
    color: Colors.green,
    description: 'ساعت‌های هوشمند و مچ‌بندهای سلامتی',
  ),
  Category(
    id: 'c5',
    name: 'هدفون و هندزفری',
    icon: Icons.headphones,
    color: Colors.red,
    description: 'هدفون، هندزفری و لوازم جانبی صوتی',
  ),
]; 