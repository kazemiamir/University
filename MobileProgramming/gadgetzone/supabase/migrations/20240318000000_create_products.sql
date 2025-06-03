-- Create products table
CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    original_price DECIMAL(10,2),
    image_url TEXT NOT NULL,
    category VARCHAR(100) NOT NULL,
    is_featured BOOLEAN DEFAULT false,
    specifications JSONB NOT NULL DEFAULT '{}',
    stock_quantity INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Sample products with valid image URLs
INSERT INTO products (name, description, price, original_price, image_url, category, is_featured, specifications, stock_quantity) VALUES
('شیائومی Redmi Note 12 Pro', 'میان‌رده قدرتمند با دوربین 108 مگاپیکسلی', 12900000, 13900000, 'https://raw.githubusercontent.com/gadgetzone/product-images/main/phones/redmi-note-12-pro.jpg', 'موبایل', true, 
    '{"RAM": "8GB", "رنگ": "آبی", "باتری": "5000mAh", "حافظه": "128GB", "دوربین": "108MP", "پردازنده": "Dimensity 1080"}', 40),
('آیفون 14 Pro Max', 'پرچمدار اپل با دوربین 48 مگاپیکسلی', 89900000, 92000000, 'https://raw.githubusercontent.com/gadgetzone/product-images/main/phones/iphone-14-pro-max.jpg', 'موبایل', true,
    '{"RAM": "6GB", "رنگ": "مشکی", "باتری": "4323mAh", "حافظه": "256GB", "دوربین": "48MP", "پردازنده": "A16 Bionic"}', 15),
('گوشی سامسونگ Galaxy S23 Ultra', 'پرچمدار سامسونگ با قلم S Pen', 79900000, 82000000, 'https://raw.githubusercontent.com/gadgetzone/product-images/main/phones/s23-ultra.jpg', 'موبایل', true,
    '{"RAM": "12GB", "رنگ": "سبز", "باتری": "5000mAh", "حافظه": "256GB", "دوربین": "200MP", "پردازنده": "Snapdragon 8 Gen 2"}', 25);

-- Create function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger for updated_at
CREATE TRIGGER update_products_updated_at
    BEFORE UPDATE ON products
    FOR EACH ROW
    EXECUTE PROCEDURE update_updated_at_column(); 