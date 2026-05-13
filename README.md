# E-Commerce Olist — Analyse de données

**Auteur :** Bouziane Samir — Data Analyst & BI Developer  
**Stack :** Python · Pandas · SQL · Chart.js  
**Dataset :** Olist Brazilian E-Commerce — 117 329 commandes · 73 catégories · 26 états

---

## Problématique

> Une plateforme e-commerce brésilienne livre **63.5% de ses commandes en retard**.  
> Quel est l'impact sur la satisfaction client ? Quels leviers actionner pour augmenter le CA ?

---

## Résultats clés

| Insight | Constat | Recommandation |
|---------|---------|----------------|
| **Black Friday** | +52% de CA en Nov-2017 (R$1.04M) | Anticiper les stocks 6 semaines avant |
| **Retards logistiques** | 97.9% de retards en Acre (AC) | Partenaire logistique dédié nord-Brésil |
| **Impact satisfaction** | Score 4.22/5 Express vs 3.42/5 longs délais | SLA livraison 7 jours max |
| **Frais de port** | 16.6% du panier total, 35% pour petits paniers | Seuil livraison gratuite : R$100 |
| **Paiement** | 73.7% carte de crédit | Programme cashback / fidélité |

**Impact estimé :** réduire les retards de 63% → 30% = **R$800K–1.5M de CA supplémentaire/an**

---

## Structure du projet

```
ecommerce-data-analysis/
├── data/
│   └── cleaned/
│       └── ecommerce_cleaned.csv     ← dataset Olist nettoyé (117 329 lignes)
├── notebooks/
│   ├── 01_data_cleaning.py           ← audit qualité + nettoyage + features
│   └── 02_eda_insights.py            ← 6 insights business avec impact chiffré
├── sql/
│   └── ecommerce_analysis.sql        ← 10 requêtes analytiques (window functions)
├── dashboard/
│   └── dashboard.html                ← dashboard interactif Chart.js
└── README.md
```

---

## Étapes du projet

### 1. Data Cleaning (`01_data_cleaning.py`)
- Audit qualité : valeurs manquantes, types, doublons
- Filtre sur commandes livrées uniquement
- Normalisation texte (catégories, états)
- Features : `price_band`, `delivery_band`, `revenue_total`

### 2. EDA & Insights (`02_eda_insights.py`)
- 6 insights business avec recommandations chiffrées
- Résumé exécutif avec impact financier estimé

### 3. SQL (`ecommerce_analysis.sql`)
- 10 requêtes analytiques
- Window functions : `RANK() OVER`, `SUM() OVER`
- Analyse : KPIs globaux, revenus mensuels, top catégories, livraisons, satisfaction, paiements

### 4. Dashboard (`dashboard.html`)
- 4 KPI cards avec badges d'alerte
- 6 graphiques interactifs : revenus, paiements, catégories, retards, scores, délais
- 6 insight cards avec recommandations business
- Ouverture directe dans le navigateur, aucune dépendance

---

## Lancer le projet

```bash
# 1. Nettoyage
cd notebooks && python3 01_data_cleaning.py

# 2. EDA
python3 02_eda_insights.py

# 3. SQL → importer ecommerce_cleaned.csv dans DB Browser for SQLite
# puis exécuter sql/ecommerce_analysis.sql

# 4. Dashboard → ouvrir dans le navigateur
open dashboard/dashboard.html
```

---

## Contact

**Bouziane Samir** — Data Analyst & BI Developer  
[LinkedIn](https://linkedin.com/in/samir-bouziane-117172409) · [GitHub](https://github.com/samir-data-cloud) · m.salahbouziane@gmail.com
