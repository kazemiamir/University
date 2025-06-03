-- Disable email confirmation requirement
ALTER TABLE auth.users
ALTER COLUMN email_confirmed_at 
SET DEFAULT NOW();

-- Update existing users to have confirmed emails
UPDATE auth.users
SET email_confirmed_at = NOW()
WHERE email_confirmed_at IS NULL;

-- Add some debug logging
DO $$
BEGIN
    RAISE NOTICE 'Disabled email confirmation requirement';
    RAISE NOTICE 'Updated existing users to have confirmed emails';
END $$; 