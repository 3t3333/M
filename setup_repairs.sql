-- Tic Time of Pasadena - Repair Requests Schema
-- Run this in the Supabase SQL Editor

-- 1. Create the repairs table
CREATE TABLE IF NOT EXISTS repairs (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  customer_name TEXT NOT NULL,
  customer_email TEXT NOT NULL,
  customer_phone TEXT,
  watch_brand TEXT NOT NULL,
  watch_model TEXT,
  service_type TEXT NOT NULL,
  issue_description TEXT NOT NULL,
  image_url TEXT,
  status TEXT DEFAULT 'pending', -- pending, in-progress, completed, cancelled
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Enable Row Level Security
ALTER TABLE repairs ENABLE ROW LEVEL SECURITY;

-- 3. Create Policies for 'repairs' table
-- Anyone can submit a repair request
DROP POLICY IF EXISTS "Public can insert repairs" ON repairs;
CREATE POLICY "Public can insert repairs" 
ON repairs FOR INSERT 
WITH CHECK (true);

-- Only authenticated admins can view and manage repairs
DROP POLICY IF EXISTS "Admins can manage repairs" ON repairs;
CREATE POLICY "Admins can manage repairs" 
ON repairs FOR ALL 
TO authenticated 
USING (true) 
WITH CHECK (true);

-- 4. Storage Setup for Repair Images
-- IMPORTANT: You must create a bucket named 'repair_images' in the Supabase Dashboard
-- and set it to 'Public' for the best experience.

-- Allow anyone to upload images to the repair_images bucket
DROP POLICY IF EXISTS "Public can upload repair images" ON storage.objects;
CREATE POLICY "Public can upload repair images" 
ON storage.objects FOR INSERT 
TO anon, authenticated
WITH CHECK ( bucket_id = 'repair_images' );

-- Allow anyone to view images in the repair_images bucket
DROP POLICY IF EXISTS "Public can view repair images" ON storage.objects;
CREATE POLICY "Public can view repair images" 
ON storage.objects FOR SELECT 
TO anon, authenticated
USING ( bucket_id = 'repair_images' );

-- Allow admins to manage (delete) repair images
DROP POLICY IF EXISTS "Admins can delete repair images" ON storage.objects;
CREATE POLICY "Admins can delete repair images" 
ON storage.objects FOR DELETE 
TO authenticated 
USING ( bucket_id = 'repair_images' );
