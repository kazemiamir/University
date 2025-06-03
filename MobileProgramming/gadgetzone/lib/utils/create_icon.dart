import 'package:flutter/material.dart';
import 'icon_base64.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await IconBase64.createAppIcon();
} 