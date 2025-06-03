-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Drop existing table if it exists
DROP TABLE IF EXISTS products;

-- Create products table
CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    original_price DECIMAL(10, 2),
    image_url TEXT NOT NULL,
    category VARCHAR(100) NOT NULL,
    is_featured BOOLEAN DEFAULT false,
    specifications JSONB DEFAULT '{}'::jsonb,
    stock_quantity INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create function to automatically update updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger for automatically updating updated_at
DROP TRIGGER IF EXISTS update_products_updated_at ON products;
CREATE TRIGGER update_products_updated_at
    BEFORE UPDATE ON products
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Grant permissions
ALTER TABLE products ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Enable read access for all users" ON products FOR SELECT USING (true);
CREATE POLICY "Enable insert access for authenticated users" ON products FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable update access for authenticated users" ON products FOR UPDATE USING (true);
CREATE POLICY "Enable delete access for authenticated users" ON products FOR DELETE USING (true);

-- Insert test data
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
); 