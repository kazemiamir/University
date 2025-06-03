-- بررسی و به‌روزرسانی دسترسی‌ها
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