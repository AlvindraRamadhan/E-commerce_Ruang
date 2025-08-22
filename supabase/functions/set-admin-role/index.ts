// Lokasi: supabase/functions/set-admin-role/index.ts

import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { corsHeaders } from "../_shared/cors.ts";

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const { uid, role } = await req.json();
    if (!uid || !role) {
      throw new Error("UID and role are required.");
    }

    // PERBAIKAN: Mengambil nama secret yang benar
    const supabaseAdmin = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SERVICE_ROLE_KEY") ?? "" 

    const { error } = await supabaseAdmin
      .from("profiles")
      .update({ role: role })
      .eq("id", uid);

    if (error) {
      throw error;
    }

    return new Response(
      JSON.stringify({
        message: `User ${uid} has been updated to role ${role}`,
      }),
      {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 200,
      }
    );
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
      status: 400,
    });
  }
});
