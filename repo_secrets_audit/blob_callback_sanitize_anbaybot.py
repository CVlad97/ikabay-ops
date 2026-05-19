import re

# git-filter-repo blob callback body (expects `blob` in scope).
# Purpose: purge historical strings that secret scanners often flag:
# - hardcoded long token-like literals (e.g. Solana mint addresses used in early test commits)
# - Authorization: Bearer ... examples in docs
# - accidental env values in .env/.env.example history

try:
    s = blob.data.decode("utf-8")
except Exception:
    return

orig = s

# Replace specific long literals that were previously hardcoded in test-mode routes.
s = s.replace("So11111111111111111111111111111111111111112", "TOKEN_IN_PLACEHOLDER")
s = s.replace("EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v", "TOKEN_OUT_PLACEHOLDER")

# Normalize curl auth examples (avoid suggesting real tokens).
s = re.sub(r"Authorization:\s*Bearer\s+[^\s\"']+", "Authorization: Bearer <CRON_TOKEN>", s)
s = re.sub(r"Authorization:\s*Bearer\s+[^\s`]+", "Authorization: Bearer <CRON_TOKEN>", s)

# Ensure common env vars are placeholders (covers history too).
s = re.sub(r'(?m)^(MEXC_API_KEY=)\"?.*\"?$', r'\\1\"\"', s)
s = re.sub(r'(?m)^(MEXC_API_SECRET=)\"?.*\"?$', r'\\1\"\"', s)
s = re.sub(r'(?m)^(HELIUS_API_KEY=)\"?.*\"?$', r'\\1\"\"', s)
s = re.sub(r'(?m)^(HELIUS_WEBHOOK_SECRET=)\"?.*\"?$', r'\\1\"\"', s)
s = re.sub(r'(?m)^(COINGECKO_API_KEY=)\"?.*\"?$', r'\\1\"\"', s)

if s != orig:
    blob.data = s.encode("utf-8")
