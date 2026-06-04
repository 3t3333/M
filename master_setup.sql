-- TIC TIME OF PASADENA - MASTER DATABASE SETUP
-- Run this entire file in your Supabase SQL Editor

-- --------------------------------------------------------
-- 1. CREATE TABLES
-- --------------------------------------------------------

-- Watches Table
CREATE TABLE IF NOT EXISTS watches (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  price NUMERIC NOT NULL,
  shipping_price NUMERIC DEFAULT 0,
  image_url TEXT,
  square_link TEXT,
  is_visible BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Orders Table (For the simulator)
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

-- Repairs Table (For the booking form)
CREATE TABLE IF NOT EXISTS repairs (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  customer_name TEXT NOT NULL,
  customer_email TEXT NOT NULL,
  customer_phone TEXT,
  watch_brand TEXT NOT NULL,
  watch_model TEXT,
  service_type TEXT NOT NULL,
  issue_description TEXT,
  image_url TEXT,
  status TEXT DEFAULT 'pending',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- --------------------------------------------------------
-- 2. ENABLE ROW LEVEL SECURITY (RLS)
-- --------------------------------------------------------
ALTER TABLE watches ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE repairs ENABLE ROW LEVEL SECURITY;

-- --------------------------------------------------------
-- 3. PUBLIC PERMISSIONS (What customers can do)
-- --------------------------------------------------------

-- Anyone can view visible watches
DROP POLICY IF EXISTS "Public view watches" ON watches;
CREATE POLICY "Public view watches" ON watches FOR SELECT USING (is_visible = true);

-- Anyone can submit a test order
DROP POLICY IF EXISTS "Public insert orders" ON orders;
CREATE POLICY "Public insert orders" ON orders FOR INSERT WITH CHECK (true);

-- Anyone can submit a repair request
DROP POLICY IF EXISTS "Public insert repairs" ON repairs;
CREATE POLICY "Public insert repairs" ON repairs FOR INSERT WITH CHECK (true);

-- --------------------------------------------------------
-- 4. ADMIN PERMISSIONS (What you can do when logged in)
-- --------------------------------------------------------

-- Admins can do anything to watches
DROP POLICY IF EXISTS "Admin manage watches" ON watches;
CREATE POLICY "Admin manage watches" ON watches FOR ALL TO authenticated USING (true);

-- Admins can view orders
DROP POLICY IF EXISTS "Admin view orders" ON orders;
CREATE POLICY "Admin view orders" ON orders FOR SELECT TO authenticated USING (true);

-- Admins can manage repairs
DROP POLICY IF EXISTS "Admin manage repairs" ON repairs;
CREATE POLICY "Admin manage repairs" ON repairs FOR ALL TO authenticated USING (true);

-- --------------------------------------------------------
-- 5. STORAGE BUCKET POLICIES (Assuming bucket is public)
-- --------------------------------------------------------
-- NOTE: You must manually create the 'watch_images' and 'repair_images' buckets in the Storage UI first.

DROP POLICY IF EXISTS "Public Access" ON storage.objects;
CREATE POLICY "Public Access" ON storage.objects FOR SELECT USING (true);

DROP POLICY IF EXISTS "Admin Upload" ON storage.objects;
CREATE POLICY "Admin Upload" ON storage.objects FOR INSERT TO authenticated WITH CHECK (true);

DROP POLICY IF EXISTS "Admin Update" ON storage.objects;
CREATE POLICY "Admin Update" ON storage.objects FOR UPDATE TO authenticated USING (true);

DROP POLICY IF EXISTS "Admin Delete" ON storage.objects;
CREATE POLICY "Admin Delete" ON storage.objects FOR DELETE TO authenticated USING (true);
