const SUPABASE_URL = "https://bhyuxhruukfeoutrbkav.supabase.co";
const SUPABASE_KEY = "sb_publishable_PnGz-pwdzeglp0M7T5OjCg_KEyUnteW"; // Anon key

// Export for use in other scripts
if (typeof window !== 'undefined') {
    window.SUPABASE_CONFIG = {
        url: SUPABASE_URL,
        key: SUPABASE_KEY
    };
}
