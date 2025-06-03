import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

serve(async (req) => {
  try {
    const { phone } = await req.json()
    
    // Create Supabase client
    const supabaseAdmin = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    // First find the user in public.users
    const { data: userData, error: userError } = await supabaseAdmin
      .from('users')
      .select('id')
      .eq('phone', phone)
      .single()

    if (userError && userError.code !== 'PGRST116') {
      throw userError
    }

    if (userData) {
      // Delete from public.users first
      await supabaseAdmin
        .from('users')
        .delete()
        .eq('id', userData.id)
    }

    // Find user in auth.users by email
    const { data: authData, error: authError } = await supabaseAdmin
      .auth.admin.listUsers()

    if (authError) {
      throw authError
    }

    const authUser = authData.users.find(
      u => u.email === `${phone}@temp.gadgetzone.ir`
    )

    if (authUser) {
      // Delete from auth.users
      await supabaseAdmin.auth.admin.deleteUser(authUser.id)
    }

    return new Response(
      JSON.stringify({ success: true }),
      { headers: { 'Content-Type': 'application/json' } }
    )

  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 400, headers: { 'Content-Type': 'application/json' } }
    )
  }
}) 