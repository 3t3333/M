-- 1. Update watches table with stock/inventory
ALTER TABLE watches 
ADD COLUMN IF NOT EXISTS stock_quantity INTEGER DEFAULT 1;

-- 2. Update orders table with more details and status
ALTER TABLE orders 
ADD COLUMN IF NOT EXISTS quantity INTEGER DEFAULT 1,
ADD COLUMN IF NOT EXISTS comments TEXT,
ADD COLUMN IF NOT EXISTS status TEXT DEFAULT 'Pending';
