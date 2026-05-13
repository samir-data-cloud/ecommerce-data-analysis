-- ============================================================
-- E-Commerce Olist — SQL Analytics
-- Author: Bouziane Samir — Data Analyst & BI Developer
-- Source: ecommerce_cleaned.csv → import in SQLite / DuckDB
-- ============================================================

-- 1. KPIs globaux
SELECT
    COUNT(DISTINCT order_id)                          AS total_orders,
    ROUND(SUM(price), 2)                              AS total_revenue,
    ROUND(AVG(price), 2)                              AS avg_basket,
    ROUND(AVG(review_score), 2)                       AS avg_score,
    ROUND(100.0 * SUM(CASE WHEN is_late = 'True' THEN 1 ELSE 0 END)
          / COUNT(*), 1)                              AS late_rate_pct
FROM ecommerce_cleaned
WHERE order_status = 'delivered';

-- 2. CA mensuel (tendance)
SELECT
    month,
    ROUND(SUM(price), 0)              AS monthly_revenue,
    COUNT(DISTINCT order_id)          AS orders_count,
    ROUND(AVG(price), 2)              AS avg_basket
FROM ecommerce_cleaned
WHERE order_status = 'delivered'
GROUP BY month
ORDER BY month;

-- 3. Top 10 catégories par CA
SELECT
    product_category_name,
    COUNT(DISTINCT order_id)          AS orders,
    ROUND(SUM(price), 0)              AS revenue,
    ROUND(AVG(review_score), 2)       AS avg_score,
    ROUND(100.0 * SUM(CASE WHEN is_late = 'True' THEN 1 ELSE 0 END)
          / COUNT(*), 1)              AS late_pct
FROM ecommerce_cleaned
WHERE order_status = 'delivered'
GROUP BY product_category_name
ORDER BY revenue DESC
LIMIT 10;

-- 4. Performance par état (livraisons)
SELECT
    customer_state,
    COUNT(DISTINCT order_id)                           AS orders,
    ROUND(AVG(delivery_time), 1)                       AS avg_delivery_days,
    ROUND(100.0 * SUM(CASE WHEN is_late = 'True' THEN 1 ELSE 0 END)
          / COUNT(*), 1)                               AS late_pct,
    ROUND(AVG(review_score), 2)                        AS avg_score
FROM ecommerce_cleaned
WHERE order_status = 'delivered'
GROUP BY customer_state
ORDER BY late_pct DESC;

-- 5. Distribution scores d'avis
SELECT
    review_score,
    COUNT(*)                          AS count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct
FROM ecommerce_cleaned
WHERE order_status = 'delivered'
GROUP BY review_score
ORDER BY review_score;

-- 6. Modes de paiement
SELECT
    payment_type,
    COUNT(*)                          AS transactions,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct,
    ROUND(AVG(payment_value), 2)      AS avg_value,
    ROUND(AVG(payment_installments), 1) AS avg_installments
FROM ecommerce_cleaned
WHERE order_status = 'delivered'
GROUP BY payment_type
ORDER BY transactions DESC;

-- 7. Impact retards sur satisfaction (window function)
SELECT
    is_late,
    COUNT(*)                          AS orders,
    ROUND(AVG(review_score), 2)       AS avg_score,
    ROUND(AVG(delivery_time), 1)      AS avg_days,
    RANK() OVER (ORDER BY AVG(review_score) DESC) AS score_rank
FROM ecommerce_cleaned
WHERE order_status = 'delivered'
GROUP BY is_late;

-- 8. Vendeurs top performance (RANK par CA)
SELECT
    seller_id,
    COUNT(DISTINCT order_id)          AS orders,
    ROUND(SUM(price), 0)              AS revenue,
    ROUND(AVG(review_score), 2)       AS avg_score,
    RANK() OVER (ORDER BY SUM(price) DESC) AS revenue_rank
FROM ecommerce_cleaned
WHERE order_status = 'delivered'
GROUP BY seller_id
ORDER BY revenue DESC
LIMIT 15;

-- 9. Corrélation délai livraison / satisfaction
SELECT
    CASE
        WHEN delivery_time <= 7  THEN 'Express (< 7j)'
        WHEN delivery_time <= 14 THEN 'Standard (7-14j)'
        WHEN delivery_time <= 30 THEN 'Long (14-30j)'
        ELSE 'Très long (> 30j)'
    END AS delivery_band,
    COUNT(*)                          AS orders,
    ROUND(AVG(review_score), 2)       AS avg_score,
    ROUND(AVG(price), 2)              AS avg_basket
FROM ecommerce_cleaned
WHERE order_status = 'delivered' AND delivery_time >= 0
GROUP BY delivery_band
ORDER BY AVG(delivery_time);

-- 10. Analyse panier : frais de port vs prix produit
SELECT
    CASE
        WHEN price < 50   THEN '< R$50'
        WHEN price < 150  THEN 'R$50-150'
        WHEN price < 500  THEN 'R$150-500'
        ELSE '> R$500'
    END AS price_band,
    COUNT(*)                          AS orders,
    ROUND(AVG(price), 2)              AS avg_price,
    ROUND(AVG(freight_value), 2)      AS avg_freight,
    ROUND(100.0 * AVG(freight_value)
          / (AVG(price) + AVG(freight_value)), 1) AS freight_share_pct
FROM ecommerce_cleaned
WHERE order_status = 'delivered'
GROUP BY price_band
ORDER BY AVG(price);
