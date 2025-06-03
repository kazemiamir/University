-- 1. ایجاد تابع به‌روزرسانی خودکار updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 2. تنظیم دسترسی‌ها
ALTER TABLE products ENABLE ROW LEVEL SECURITY;

-- حذف سیاست‌های قبلی
DROP POLICY IF EXISTS "Enable read access for all users" ON products;
DROP POLICY IF EXISTS "Enable insert access for authenticated users" ON products;
DROP POLICY IF EXISTS "Enable update access for authenticated users" ON products;
DROP POLICY IF EXISTS "Enable delete access for authenticated users" ON products;

-- ایجاد سیاست‌های جدید
CREATE POLICY "Enable read access for all users" ON products FOR SELECT USING (true);
CREATE POLICY "Enable insert access for authenticated users" ON products FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable update access for authenticated users" ON products FOR UPDATE USING (true);
CREATE POLICY "Enable delete access for authenticated users" ON products FOR DELETE USING (true);

-- اطمینان از وجود تریگر به‌روزرسانی
DROP TRIGGER IF EXISTS update_products_updated_at ON products;
CREATE TRIGGER update_products_updated_at
    BEFORE UPDATE ON products
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- 3. درج داده‌های نمونه
TRUNCATE TABLE products;

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