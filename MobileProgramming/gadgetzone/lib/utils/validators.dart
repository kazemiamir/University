class Validators {
  static String? required(String? value) {
    if (value?.isEmpty ?? true) {
      return 'این فیلد الزامی است';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value?.isEmpty ?? true) {
      return 'لطفا شماره موبایل خود را وارد کنید';
    }
    if (!value!.startsWith('09')) {
      return 'شماره موبایل باید با ۰۹ شروع شود';
    }
    if (value.length != 11) {
      return 'شماره موبایل باید ۱۱ رقم باشد';
    }
    return null;
  }

  static String? username(String? value) {
    if (value?.isEmpty ?? true) {
      return 'لطفا نام کاربری خود را وارد کنید';
    }
    if (value!.length < 3) {
      return 'نام کاربری باید حداقل ۳ کاراکتر باشد';
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return 'نام کاربری فقط می‌تواند شامل حروف انگلیسی، اعداد و _ باشد';
    }
    return null;
  }

  static String? password(String? value) {
    if (value?.isEmpty ?? true) {
      return 'لطفا رمز عبور خود را وارد کنید';
    }
    if (value!.length < 8) {
      return 'رمز عبور باید حداقل ۸ کاراکتر باشد';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'رمز عبور باید شامل حداقل یک حرف بزرگ باشد';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'رمز عبور باید شامل حداقل یک حرف کوچک باشد';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'رمز عبور باید شامل حداقل یک عدد باشد';
    }
    return null;
  }
} 