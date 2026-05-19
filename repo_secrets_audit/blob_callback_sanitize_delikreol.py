import re

# This callback is executed by git-filter-repo with `blob` in scope.
# Goal: purge historical secrets (Supabase anon keys / JWT-like strings, Stripe keys)
# while keeping documentation usable via safe placeholders.
#
# We intentionally do NOT rely on `metadata` (not available in all builds/configs).
# Instead we only rewrite blobs that look like UTF-8 text, and skip binaries.

try:
    s = blob.data.decode("utf-8")
except Exception:
    return

orig = s

# Normalize common env lines.
s = re.sub(r"(?m)^(VITE_SUPABASE_ANON_KEY=).+$", r"\1SUPABASE_ANON_KEY_REPLACE_ME", s)
s = re.sub(r"(?m)^(WHATSAPP_VERIFY_TOKEN=).+$", r"\1CHANGE_ME", s)

# Remove Stripe keys anywhere (code blocks or prose).
s = re.sub(r"pk_(?:test|live)_[^\s\"'`\\]{4,}", "STRIPE_PUBLISHABLE_KEY_REPLACE_ME", s)
s = re.sub(r"sk_(?:test|live)_[^\s\"'`\\]{4,}", "STRIPE_SECRET_KEY_REPLACE_ME", s)

# Remove JWT-ish tokens (Supabase anon keys often look like JWTs).
s = re.sub(r"eyJ[^\s]{20,}", "SUPABASE_ANON_KEY_REPLACE_ME", s)

# Avoid docs triggering gitleaks by mentioning full prefixes.
s = s.replace("pk_test_", "pk_")
s = s.replace("pk_live_", "pk_")
s = s.replace("sk_test_", "sk_")
s = s.replace("sk_live_", "sk_")

if s != orig:
    blob.data = s.encode("utf-8")
