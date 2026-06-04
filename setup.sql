-- Tic Time of Pasadena - Database Schema (Re-runnable version)
-- Run this in the Supabase SQL Editor

-- 1. Create the watches table (if it doesn't exist)
CREATE TABLE IF NOT EXISTS watches (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  price NUMERIC NOT NULL,
  image_url TEXT,
  square_link TEXT,
  is_visible BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Enable Row Level Security
ALTER TABLE watches ENABLE ROW LEVEL SECURITY;

-- 3. Reset and Create Policies for 'watches' table
DROP POLICY IF EXISTS "Public can view visible watches" ON watches;
CREATE POLICY "Public can view visible watches" 
ON watches FOR SELECT 
USING (is_visible = true);

DROP POLICY IF EXISTS "Admins can manage watches" ON watches;
CREATE POLICY "Admins can manage watches" 
ON watches FOR ALL 
TO authenticated 
USING (true) 
WITH CHECK (true);

-- 4. Reset and Create Storage Policies for 'storage.objects'
-- Note: These apply to the storage.objects table which handles all buckets
DROP POLICY IF EXISTS "Public Access" ON storage.objects;
CREATE POLICY "Public Access" 
ON storage.objects FOR SELECT 
USING ( bucket_id = 'watch_images' );

DROP POLICY IF EXISTS "Admin Upload" ON storage.objects;
CREATE POLICY "Admin Upload" 
ON storage.objects FOR INSERT 
TO authenticated 
WITH CHECK ( bucket_id = 'watch_images' );

DROP POLICY IF EXISTS "Admin Update" ON storage.objects;
CREATE POLICY "Admin Update" 
ON storage.objects FOR UPDATE 
TO authenticated 
USING ( bucket_id = 'watch_images' );

DROP POLICY IF EXISTS "Admin Delete" ON storage.objects;
CREATE POLICY "Admin Delete" 
ON storage.objects FOR DELETE 
TO authenticated 
USING ( bucket_id = 'watch_images' );
