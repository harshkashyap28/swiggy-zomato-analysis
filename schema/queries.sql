-- Swiggy vs Zomato Restaurant Analytics
-- Which platform has better avg rating overall?
SELECT ROUND(AVG(swiggy_rating)::numeric, 2) AS avg_swiggy_rating,
    ROUND(AVG(zomato_rating)::numeric, 2) AS avg_zomato_rating
FROM platform_metrics;
-- Which cuisine is cheapest on average?
SELECT cuisines,
    ROUND(AVG(avg_cost_per_person_inr)::numeric, 2) AS avg_cost
FROM restaurants
GROUP BY cuisines
ORDER BY avg_cost ASC
LIMIT 10;
-- Swiggy vs Zomato delivery fee by city
SELECT r.city,
    ROUND(AVG(p.swiggy_delivery_fee_inr)::numeric, 2) AS avg_swiggy_fee,
    ROUND(AVG(p.zomato_delivery_fee_inr)::numeric, 2) AS avg_zomato_fee
FROM restaurants r
    JOIN platform_metrics p ON r.restaurant_id = p.restaurant_id
GROUP BY r.city
ORDER BY r.city;
-- Which platform delivers faster by city?
SELECT r.city,
    ROUND(
        AVG(p.swiggy_avg_delivery_time_minutes)::numeric,
        2
    ) AS swiggy_time,
    ROUND(
        AVG(p.zomato_avg_delivery_time_minutes)::numeric,
        2
    ) AS zomato_time,
    CASE
        WHEN AVG(p.swiggy_avg_delivery_time_minutes) < AVG(p.zomato_avg_delivery_time_minutes) THEN 'Swiggy Faster'
        ELSE 'Zomato Faster'
    END AS faster_platform
FROM restaurants r
    JOIN platform_metrics p ON r.restaurant_id = p.restaurant_id
GROUP BY r.city;
-- Top 5 cities by total monthly revenue
SELECT r.city,
    ROUND(
        SUM(
            p.swiggy_estimated_monthly_revenue_inr + p.zomato_estimated_monthly_revenue_inr
        )::numeric,
        2
    ) AS total_revenue
FROM restaurants r
    JOIN platform_metrics p ON r.restaurant_id = p.restaurant_id
GROUP BY r.city
ORDER BY total_revenue DESC
LIMIT 5;
-- Which cuisine generates most profit?
SELECT r.cuisines,
    ROUND(
        SUM(
            p.swiggy_estimated_net_profit_inr + p.zomato_estimated_net_profit_inr
        )::numeric,
        2
    ) AS total_profit
FROM restaurants r
    JOIN platform_metrics p ON r.restaurant_id = p.restaurant_id
GROUP BY r.cuisines
ORDER BY total_profit DESC
LIMIT 10;
-- Platform dominance by city
SELECT r.city,
    COUNT(
        CASE
            WHEN p.platform_performance_better = 'Swiggy Better' THEN 1
        END
    ) AS swiggy_wins,
    COUNT(
        CASE
            WHEN p.platform_performance_better = 'Zomato Better' THEN 1
        END
    ) AS zomato_wins
FROM restaurants r
    JOIN platform_metrics p ON r.restaurant_id = p.restaurant_id
GROUP BY r.city
ORDER BY r.city;
-- Which price category gets best ratings?
SELECT r.price_category,
    ROUND(AVG(p.average_rating_both_platforms)::numeric, 2) AS avg_rating
FROM restaurants r
    JOIN platform_metrics p ON r.restaurant_id = p.restaurant_id
GROUP BY r.price_category
ORDER BY avg_rating DESC;
-- Discount frequency vs rating
SELECT CASE
        WHEN p.swiggy_discount_frequency_pct > 50 THEN 'High Discount'
        WHEN p.swiggy_discount_frequency_pct BETWEEN 25 AND 50 THEN 'Medium Discount'
        ELSE 'Low Discount'
    END AS discount_bucket,
    ROUND(AVG(p.swiggy_rating)::numeric, 2) AS avg_swiggy_rating
FROM platform_metrics p
GROUP BY discount_bucket
ORDER BY avg_swiggy_rating DESC;
-- Top 10 most reviewed restaurants
SELECT r.restaurant_name,
    r.city,
    (p.swiggy_total_reviews + p.zomato_total_reviews) AS total_reviews
FROM restaurants r
    JOIN platform_metrics p ON r.restaurant_id = p.restaurant_id
ORDER BY total_reviews DESC
LIMIT 10;
-- Restaurant type vs avg delivery time
SELECT r.restaurant_type,
    ROUND(
        AVG(p.swiggy_avg_delivery_time_minutes)::numeric,
        2
    ) AS swiggy_time,
    ROUND(
        AVG(p.zomato_avg_delivery_time_minutes)::numeric,
        2
    ) AS zomato_time
FROM restaurants r
    JOIN platform_metrics p ON r.restaurant_id = p.restaurant_id
GROUP BY r.restaurant_type
ORDER BY swiggy_time;
-- Revenue rank per city
SELECT r.restaurant_name,
    r.city,
    ROUND(
        (
            p.swiggy_estimated_monthly_revenue_inr + p.zomato_estimated_monthly_revenue_inr
        )::numeric,
        2
    ) AS total_revenue,
    RANK() OVER (
        PARTITION BY r.city
        ORDER BY (
                p.swiggy_estimated_monthly_revenue_inr + p.zomato_estimated_monthly_revenue_inr
            ) DESC
    ) AS revenue_rank
FROM restaurants r
    JOIN platform_metrics p ON r.restaurant_id = p.restaurant_id;
-- Running total of orders by city
SELECT r.city,
    r.restaurant_name,
    p.swiggy_estimated_monthly_orders + p.zomato_estimated_monthly_orders AS total_orders,
    SUM(
        p.swiggy_estimated_monthly_orders + p.zomato_estimated_monthly_orders
    ) OVER (
        PARTITION BY r.city
        ORDER BY r.restaurant_name
    ) AS running_total
FROM restaurants r
    JOIN platform_metrics p ON r.restaurant_id = p.restaurant_id;
-- Restaurants where Zomato beats Swiggy on both rating and delivery time
SELECT r.restaurant_name,
    r.city,
    p.swiggy_rating,
    p.zomato_rating,
    p.swiggy_avg_delivery_time_minutes,
    p.zomato_avg_delivery_time_minutes
FROM restaurants r
    JOIN platform_metrics p ON r.restaurant_id = p.restaurant_id
WHERE p.zomato_rating > p.swiggy_rating
    AND p.zomato_avg_delivery_time_minutes < p.swiggy_avg_delivery_time_minutes;
-- Best value restaurants (low cost + high rating)
SELECT r.restaurant_name,
    r.city,
    r.cuisines,
    r.avg_cost_per_person_inr,
    p.average_rating_both_platforms,
    CASE
        WHEN r.avg_cost_per_person_inr < 500
        AND p.average_rating_both_platforms >= 4.0 THEN 'Best Value'
        WHEN r.avg_cost_per_person_inr < 1000
        AND p.average_rating_both_platforms >= 3.5 THEN 'Good Value'
        ELSE 'Premium'
    END AS value_category
FROM restaurants r
    JOIN platform_metrics p ON r.restaurant_id = p.restaurant_id
ORDER BY p.average_rating_both_platforms DESC
LIMIT 20;