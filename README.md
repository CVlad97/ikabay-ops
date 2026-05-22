# ikabay-ops

Outils d'exploitation pour vérifier l'état réel des projets.

## Vérification globale (multi-repos)

Commande:

```bash
/root/vladclaw/ikabay-ops/scripts/run-global-checks.sh
```

Ce script exécute automatiquement:

- sync git local/remote (`main`)
- `typecheck`, `lint`, `build` (et `e2e` pour DELIKREOL)
- contrôle HTTP des URLs publiques

Les rapports sont générés dans:

`/root/vladclaw/ikabay-ops/reports/`
