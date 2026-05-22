# DELIKREOL .mq Cutover Runbook (low cost / semi-autonome)

Date: 2026-05-22

## Objectif

Passer de `https://cvlad97.github.io/DELIKREOL/` vers `https://delikreol.mq` avec:

- email pro `contact@delikreol.mq` redirigé vers `vladimir.claveau@gmail.com`
- tunnel commande prioritaire (client-first)
- automatisation minimale mais réelle (sans API non officielle)

## Hypothèses

- Le domaine `.mq` doit être acheté (pas de gratuit réaliste).
- Le DNS sera géré par Cloudflare (plan gratuit).
- Le front reste hébergé via GitHub Pages.

## Étape 1 — Domaine + DNS (J0)

1. Acheter `delikreol.mq` chez un registrar qui gère `.mq`.
2. Mettre les nameservers Cloudflare.
3. Ajouter DNS:
   - `A @ -> 185.199.108.153`
   - `A @ -> 185.199.109.153`
   - `A @ -> 185.199.110.153`
   - `A @ -> 185.199.111.153`
   - `CNAME www -> cvlad97.github.io`
4. Dans GitHub repo `CVlad97/DELIKREOL`:
   - Settings > Pages > Custom domain = `delikreol.mq`
   - Activer HTTPS

## Étape 2 — Email pro (J0/J1)

1. Cloudflare > Email Routing (gratuit) > activer.
2. Créer l’alias:
   - `contact@delikreol.mq` -> `vladimir.claveau@gmail.com`
3. Ajouter SPF / DKIM / DMARC recommandés.

## Étape 3 — WhatsApp Business officiel (J1)

Niveau App (gratuit):

- Message accueil / absence
- Réponses rapides
- Étiquettes pipeline commande
- Catalogue services

Niveau API (si volume):

- WhatsApp Cloud API (Meta officiel)
- n8n webhook pour:
  - réception lead
  - qualification
  - création ligne de suivi
  - alerte opérateur

## Étape 4 — Tracking/KPI (J1/J2)

1. Activer Cloudflare Web Analytics (gratuit) sur `delikreol.mq`.
2. Suivre au minimum:
   - visites
   - clic CTA commande
   - ajout panier
   - commande confirmée
3. Export quotidien dans Google Sheet (n8n ou Apps Script).

## Étape 5 — Pilotage financier prudent (J2+)

Règle proposée:

- 70% revenus -> opérations/charges
- 20% -> réserve
- 10% -> tests croissance

Crypto:

- non prioritaire
- jamais sans validation humaine explicite
- journal de risque obligatoire

## Étape 6 — Cadence d’exécution auto

Commande locale:

```bash
/root/vladclaw/ikabay-ops/scripts/run-global-checks.sh
```

Sortie:

- rapport dans `ikabay-ops/reports/`
- PASS/FAIL global

## Statut actuel

- Home DELIKREOL recentrée commande: OK
- Consentement géolocalisation + carte + validation: OK
- Tests techniques/e2e: OK
- Script global multi-repos: OK

## Décisions humaines encore nécessaires

1. Registrar final pour `delikreol.mq`
2. Compte Cloudflare cible
3. Identité Meta Business pour API WhatsApp
4. Budget ads hebdomadaire
