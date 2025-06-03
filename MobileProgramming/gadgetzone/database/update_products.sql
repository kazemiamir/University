-- Update existing products
UPDATE products 
SET 
    category = 'نمایشگر',
    is_featured = true,
    specifications = '{"نوع پنل": "AMOLED", "اندازه": "6 اینچ", "رزولوشن": "2400x1080"}'::jsonb
WHERE name LIKE '%AMOLED%';

UPDATE products 
SET 
    category = 'لپ‌تاپ',
    is_featured = true,
    specifications = '{"پردازنده": "Core i7", "رم": "16GB", "حافظه": "512GB SSD"}'::jsonb
WHERE name LIKE '%S21%';

-- Insert new products
INSERT INTO products (name, description, price, original_price, image_url, category, is_featured, specifications, stock_quantity) VALUES
(
    'هدفون سونی WH-1000XM4',
    'هدفون بی‌سیم با کیفیت صدای فوق‌العاده و حذف نویز پیشرفته',
    299.99,
    349.99,
    'https://images.unsplash.com/photo-1618366712010-f4ae9c647dcb?w=500&h=500&fit=crop',
    'لوازم جانبی',
    true,
    '{"رنگ": "مشکی", "باتری": "تا 30 ساعت", "حذف نویز": "فعال", "بلوتوث": "5.0"}'::jsonb,
    45
),
(
    'ساعت هوشمند Galaxy Watch 5',
    'ساعت هوشمند سامسونگ با قابلیت‌های سلامتی پیشرفته',
    279.99,
    329.99,
    'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?w=500&h=500&fit=crop',
    'ساعت هوشمند',
    true,
    '{"رنگ": "نقره‌ای", "اندازه": "44mm", "ضد آب": "5ATM", "GPS": "دارد"}'::jsonb,
    35
),
(
    'تبلت Galaxy Tab S8',
    'تبلت اندرویدی قدرتمند سامسونگ با قلم S Pen',
    649.99,
    699.99,
    'https://images.unsplash.com/photo-1587033411391-5d9e51cce126?w=500&h=500&fit=crop',
    'تبلت',
    true,
    '{"رنگ": "مشکی", "حافظه": "256GB", "رم": "8GB", "صفحه نمایش": "11 اینچ"}'::jsonb,
    20
); 