-- Temporarily disable RLS
ALTER TABLE users DISABLE ROW LEVEL SECURITY;

-- Drop existing policies
DROP POLICY IF EXISTS "Enable insert for unauthenticated users" ON users;
DROP POLICY IF EXISTS "Enable insert for authenticated users" ON users;
DROP POLICY IF EXISTS "Users can view own data" ON users;
DROP POLICY IF EXISTS "Users can update own data" ON users;

-- Re-enable RLS
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Create a single insert policy that allows both authenticated and anonymous users
CREATE POLICY "Allow user registration"
    ON users FOR INSERT
    WITH CHECK (
        -- Allow authenticated users to insert their own data
        (auth.role() = 'authenticated' AND auth.uid() = id)
        OR
        -- Allow anonymous users to insert during registration
        (auth.role() = 'anon')
    );

-- Policy for viewing own data
CREATE POLICY "Allow users to view own data"
    ON users FOR SELECT
    USING (auth.uid() = id OR auth.role() = 'anon');

-- Policy for updating own data
CREATE POLICY "Allow users to update own data"
    ON users FOR UPDATE
    USING (auth.uid() = id)
    WITH CHECK (auth.uid() = id);

-- Grant necessary permissions
GRANT ALL ON users TO authenticated;
GRANT INSERT, SELECT ON users TO anon;

-- Add some debug logging
DO $$
BEGIN
    RAISE NOTICE 'Updated RLS policies for users table';
    RAISE NOTICE 'Granted permissions to authenticated and anonymous users';
END $$; 