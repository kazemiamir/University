class PriceFormatter {
  static String format(num price) {
    // Convert to integer by rounding
    int intPrice = price.round();
    
    // Convert to string and split into groups of 3
    String priceStr = intPrice.toString();
    String result = '';
    
    for (int i = 0; i < priceStr.length; i++) {
      if (i > 0 && (priceStr.length - i) % 3 == 0) {
        result += ' ';
      }
      result += priceStr[i];
    }
    
    // Add currency with Unicode marks for proper text direction
    return '\u202d$result\u202c تومان';
  }
} 