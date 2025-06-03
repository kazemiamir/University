import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final Color? color;

  const AppLogo({
    super.key,
    this.size = 100,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).primaryColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: (color ?? Theme.of(context).primaryColor).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // گرد کردن گوشه‌های لوگو
          ClipRRect(
            borderRadius: BorderRadius.circular(size / 2),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    (color ?? Theme.of(context).primaryColor).withOpacity(0.8),
                    color ?? Theme.of(context).primaryColor,
                  ],
                ),
              ),
            ),
          ),
          // آیکون گجت در وسط
          Icon(
            Icons.devices,
            size: size * 0.5,
            color: Colors.white,
          ),
          // نوشته GZ در پایین آیکون
          Positioned(
            bottom: size * 0.2,
            child: const Text(
              'GZ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 