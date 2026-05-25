# Swiggy vs Zomato — Restaurant & Platform Analytics

## Objective

This project analyzes 2,500+ restaurants across 10 Indian cities to compare
Swiggy and Zomato on ratings, pricing, delivery speed, revenue, and platform
dominance using SQL.

## Tech Stack

- PostgreSQL 18.4
- SQL (Joins, Window Functions, Aggregations, CASE WHEN)
- Python with pandas and sqlalchemy for data loading
- VS Code with SQLTools extension

## Schema Design

The data is split into two normalized tables. The `restaurants` table holds
restaurant info including location, cuisine type, and pricing. The
`platform_metrics` table stores all Swiggy vs Zomato comparisons per
restaurant — ratings, delivery time, revenue, and profit estimates.

## Key Findings

### Platform Ratings

Zomato has a slightly higher average rating than Swiggy (4.01 vs 3.99) across
all 2,500 restaurants. Zomato performs better in most cities, winning in
Bangalore (218 vs 194 restaurants), Mumbai (234 vs 210), and Chennai
(104 vs 93). Delhi is the one major market where Swiggy leads, with 202 wins
compared to Zomato's 176.

### Delivery Performance

Delivery times are nearly identical across both platforms for all restaurant
types. Casual Dining is the fastest category at around 38.7 minutes, while
Cloud Kitchens are the slowest at around 40.5 minutes — which is surprising
given they are delivery-only operations.

### Pricing

The cheapest cuisine combination is Desserts with Vietnamese food, averaging
just Rs. 155 per person. Delivery fees are the same on both platforms across
all 10 cities. Kolkata has the lowest delivery fee at Rs. 55.33 while Pune
charges the most at Rs. 60.60.

### Revenue and Profit

Mumbai generates the highest combined monthly revenue at Rs. 12.28 crore,
followed by Bangalore at Rs. 11.11 crore. Korean cuisine leads all categories
in total profit at Rs. 2.01 crore, with Biryani close behind at the same
figure driven by high order volumes.

### Price vs Satisfaction

Mid-range restaurants have the highest average rating at 4.02, while luxury
restaurants actually rate the lowest at 3.97. Higher price does not guarantee
higher customer satisfaction.

### Discount Impact

Restaurants offering medium discounts (25-50%) have the highest Swiggy rating
at 4.54, compared to 3.91 for low-discount restaurants. This suggests discounts
positively influence both order volume and customer perception.

## Project Structure

swiggy-zomato-analysis/
├── data/
│ └── swiggy_vs_zomato_3000.csv
├── load_data.ipynb
├── queries.sql
└── README.md
