-- Drop existing policies if any
DROP POLICY IF EXISTS "Users can view their own data" ON public.users;
DROP POLICY IF EXISTS "Users can insert their own data" ON public.users;
DROP POLICY IF EXISTS "Users can update their own data" ON public.users;

-- Enable RLS
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Users can view their own data"
ON public.users
FOR SELECT
USING (
    auth.uid() = id
    OR
    auth.role() = 'service_role'
);

CREATE POLICY "Users can insert their own data"
ON public.users
FOR INSERT
WITH CHECK (
    auth.uid() = id
    OR
    auth.role() = 'service_role'
);

CREATE POLICY "Users can update their own data"
ON public.users
FOR UPDATE
USING (
    auth.uid() = id
    OR
    auth.role() = 'service_role'
)
WITH CHECK (
    auth.uid() = id
    OR
    auth.role() = 'service_role'
);

-- Add debug logging
DO $$
BEGIN
    RAISE NOTICE 'Updated RLS policies for users table';
END $$; 