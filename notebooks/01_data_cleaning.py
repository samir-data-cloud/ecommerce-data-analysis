"""
E-Commerce Data Cleaning & Quality Audit
Dataset: Olist Brazilian E-Commerce — 117 329 orders
Author: Bouziane Samir — Data Analyst & BI Developer
"""

import pandas as pd
import numpy as np

# ── Load ──────────────────────────────────────────────────────────────────────
df = pd.read_csv("../data/cleaned/ecommerce_cleaned.csv", low_memory=False)
print(f"Shape brut : {df.shape}")

# ── Quality audit ─────────────────────────────────────────────────────────────
print("\n=== AUDIT QUALITÉ ===")
null_pct = (df.isnull().sum() / len(df) * 100).sort_values(ascending=False)
print(null_pct[null_pct > 0].to_string())

print(f"\nDoublons order_id : {df.duplicated('order_id').sum()}")
print(f"Statuts commande  : {df['order_status'].value_counts().to_dict()}")
print(f"Types paiement    : {df['payment_type'].value_counts().to_dict()}")

# ── Cleaning ──────────────────────────────────────────────────────────────────
# Drop cancelled orders for revenue analysis
df_clean = df[df["order_status"] == "delivered"].copy()

# Normalize text columns
df_clean["product_category_name"] = (
    df_clean["product_category_name"]
    .str.strip()
    .str.lower()
    .str.replace("_", " ")
    .str.title()
)
df_clean["customer_state"] = df_clean["customer_state"].str.upper().str.strip()

# Fill missing review scores with median
median_score = df_clean["review_score"].median()
df_clean["review_score"] = df_clean["review_score"].fillna(median_score)

# Fix negative delivery times
df_clean = df_clean[df_clean["delivery_time"] >= 0]

# ── Feature engineering ───────────────────────────────────────────────────────
df_clean["revenue_total"] = df_clean["price"] + df_clean["freight_value"]
df_clean["price_band"] = pd.cut(
    df_clean["price"],
    bins=[0, 50, 150, 500, 10000],
    labels=["< R$50", "R$50-150", "R$150-500", "> R$500"],
)
df_clean["delivery_band"] = pd.cut(
    df_clean["delivery_time"],
    bins=[0, 7, 14, 30, 200],
    labels=["Express (< 7j)", "Standard (7-14j)", "Long (14-30j)", "Très long (> 30j)"],
)
df_clean["is_late"] = df_clean["is_late"].astype(bool)

# ── Summary ───────────────────────────────────────────────────────────────────
print("\n=== RÉSUMÉ APRÈS NETTOYAGE ===")
print(f"Commandes livrées  : {len(df_clean):,}")
print(f"CA total           : R${df_clean['price'].sum():,.0f}")
print(f"Score moyen        : {df_clean['review_score'].mean():.2f}/5")
print(f"Taux retard livr.  : {df_clean['is_late'].mean()*100:.1f}%")
print(f"Catégories         : {df_clean['product_category_name'].nunique()}")
print(f"États clients      : {df_clean['customer_state'].nunique()}")

df_clean.to_csv("../data/cleaned/ecommerce_analysis_ready.csv", index=False)
print("\n✓ Fichier exporté : data/cleaned/ecommerce_analysis_ready.csv")
