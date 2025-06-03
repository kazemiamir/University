-- Enable RLS on public.users if not already enabled
CREATE POLICY "Enable read access for authenticated users"
ON public.users
FOR SELECT
TO authenticated
USING (true);

CREATE POLICY "Enable insert access for authenticated users"
ON public.users
FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = id);

CREATE POLICY "Enable update for users based on id"
ON public.users
FOR UPDATE
TO authenticated
USING (auth.uid() = id)
WITH CHECK (auth.uid() = id);

-- Allow public read access to specific fields
CREATE POLICY "Allow public read access to non-sensitive data"
ON public.users
FOR SELECT
TO anon
USING (true);

-- Add debug logging
DO $$
BEGIN
    RAISE NOTICE 'Created public access policies for users table';
END $$; 