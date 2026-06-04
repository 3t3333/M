-- RUN THIS IN SUPABASE SQL EDITOR TO UPGRADE THE DATABASE

-- 1. Add Stock management to watches
ALTER TABLE watches ADD COLUMN IF NOT EXISTS stock_quantity INTEGER DEFAULT 1;

-- 2. Add Quantity, Comments, and Status tracking to orders
ALTER TABLE orders ADD COLUMN IF NOT EXISTS quantity INTEGER DEFAULT 1;
ALTER TABLE orders ADD COLUMN IF NOT EXISTS comments TEXT;
ALTER TABLE orders ADD COLUMN IF NOT EXISTS status TEXT DEFAULT 'Pending';
