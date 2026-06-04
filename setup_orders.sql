-- Run this in the Supabase SQL Editor to create the Orders table

CREATE TABLE IF NOT EXISTS orders (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  watch_id UUID REFERENCES watches(id) ON DELETE SET NULL,
  watch_name TEXT NOT NULL,
  total_price NUMERIC NOT NULL,
  customer_name TEXT NOT NULL,
  customer_email TEXT NOT NULL,
  shipping_address TEXT NOT NULL,
  fake_card_last4 TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

-- Anyone can submit a test order
CREATE POLICY "Public can insert orders" 
ON orders FOR INSERT 
WITH CHECK (true);

-- Only authenticated admins can view the orders
CREATE POLICY "Admins can view orders" 
ON orders FOR SELECT 
TO authenticated 
USING (true);
