-- پاک کردن داده‌های قبلی
TRUNCATE TABLE products;

-- درج داده‌های جدید
INSERT INTO products (name, description, price, original_price, image_url, category, is_featured, specifications, stock_quantity) VALUES
(
    'گوشی سامسونگ Galaxy S21',
    'گوشی هوشمند پرچمدار سامسونگ با دوربین حرفه‌ای',
    899.99,
    999.99,
    'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=500&h=500&fit=crop',
    'موبایل',
    true,
    '{"رنگ": "مشکی", "حافظه": "128GB", "RAM": "8GB", "صفحه نمایش": "6.2 اینچ"}'::jsonb,
    50
),
(
    'لپ‌تاپ MacBook Pro',
    'لپ‌تاپ قدرتمند اپل با پردازنده M1',
    1299.99,
    1499.99,
    'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=500&h=500&fit=crop',
    'لپ‌تاپ',
    true,
    '{"رنگ": "نقره‌ای", "حافظه": "512GB", "RAM": "16GB", "صفحه نمایش": "13 اینچ"}'::jsonb,
    30
),
(
    'ایرپاد پرو',
    'هدفون بی‌سیم اپل با حذف نویز فعال',
    249.99,
    299.99,
    'https://images.unsplash.com/photo-1588423771073-b8997d76108b?w=500&h=500&fit=crop',
    'لوازم جانبی',
    true,
    '{"رنگ": "سفید", "باتری": "تا 4.5 ساعت", "حذف نویز": "فعال"}'::jsonb,
    100
),
(
    'ساعت هوشمند Apple Watch Series 7',
    'ساعت هوشمند اپل با صفحه نمایش بزرگتر',
    399.99,
    449.99,
    'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?w=500&h=500&fit=crop',
    'ساعت هوشمند',
    true,
    '{"رنگ": "مشکی", "اندازه": "45mm", "GPS": "دارد", "ضد آب": "تا 50 متر"}'::jsonb,
    40
),
(
    'تبلت iPad Air',
    'تبلت اپل با چیپ M1',
    599.99,
    699.99,
    'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=500&h=500&fit=crop',
    'تبلت',
    false,
    '{"رنگ": "خاکستری", "حافظه": "256GB", "صفحه نمایش": "10.9 اینچ"}'::jsonb,
    25
); 