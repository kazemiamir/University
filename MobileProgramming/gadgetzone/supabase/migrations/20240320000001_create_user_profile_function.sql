-- Drop function if exists
DROP FUNCTION IF EXISTS create_user_profile;

-- Create the function
CREATE OR REPLACE FUNCTION create_user_profile(
  user_id UUID,
  user_name TEXT,
  user_phone TEXT,
  user_email TEXT,
  user_username TEXT
) RETURNS void AS $$
BEGIN
  INSERT INTO users (
    id,
    name,
    phone,
    email,
    username,
    created_at
  ) VALUES (
    user_id,
    user_name,
    user_phone,
    user_email,
    user_username,
    NOW()
  );
END;
$$ LANGUAGE plpgsql;

-- Grant execute permission to both authenticated and anonymous users
GRANT EXECUTE ON FUNCTION create_user_profile(UUID, TEXT, TEXT, TEXT, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION create_user_profile(UUID, TEXT, TEXT, TEXT, TEXT) TO anon; 