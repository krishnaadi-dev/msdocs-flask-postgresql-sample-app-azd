-- A1
CREATE DATABASE restaurant_reviews;

SELECT current_database();

SELECT datname
FROM pg_database;

-- A2
CREATE TABLE restaurant (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    street_address VARCHAR(50),
    description TEXT
);

CREATE TABLE review (
    id INT PRIMARY KEY,
    restaurant_id INT NOT NULL,
    user_name VARCHAR(50) NOT NULL,
    rating INT NOT NULL,
    review_text TEXT,
    review_date DATE,

    CONSTRAINT fk_restaurant
        FOREIGN KEY (restaurant_id)
        REFERENCES restaurant(id)
        ON DELETE CASCADE
);

-- B1
INSERT INTO restaurant VALUES (1, 'Jaya Fried Chicken', 'Jl. Raya Pemogan, No. 32','Menjual Fried Chicken, Burger, dan French Fries');
INSERT INTO restaurant VALUES (2, 'Sushi Tei', 'Jl. Sunset Road, No. 88','Menjual berbagai macam sushi dan sashimi');
INSERT INTO restaurant VALUES (3, 'Batagor & Siomay Kang Alfi', 'Jl. Teuku Umar, No. 45','Menjual Batagor dan Siomay ala Bandung');

SELECT * FROM restaurant;

-- B2
INSERT INTO review VALUES (1, 1, 'Made', 5, 'Makanan enak dan pelayanan baik!', '2023-10-01');
INSERT INTO review VALUES (2, 2, 'Bobi', 4, 'Sushi sangat lezat!', '2023-10-02');
INSERT INTO review VALUES (3, 3, 'Charlie', 5, 'Batagor dan Siomay sangat lezat!', '2023-10-03');
INSERT INTO review VALUES (4, 3, 'David', 4, 'Enak tapi harganya sedikit mahal.', '2023-10-04');
INSERT INTO review VALUES (5, 2, 'Alfi', 2, 'Kok ikannya mentah sih?', '2023-10-02');

SELECT * FROM review;

-- C1.1
INSERT INTO restaurant VALUES (4, 'Bubur Kacang Ijo & Ketan', 'Jl. Gunung Asri, No. 12','Menjual bubur kacang ijo dan bubur ketan hitam');

SELECT * FROM restaurant;

-- C1.2
INSERT INTO review VALUES (6, 4, 'Komang', 3, 'Bubur kacang ijo terlalu manis', '2023-10-05');

SELECT * FROM review;

-- C2.1
SELECT *
FROM review
WHERE restaurant_id = 2;

-- C2.2
SELECT *
FROM review
WHERE rating >= 4;

-- C2.3
SELECT 
    restaurant.name AS restaurant_name, 
    review.user_name AS reviewer_name,
    review.rating AS reviewer_rating,
    review.review_text AS restaurant_review,
    review.review_date
FROM restaurant
LEFT JOIN review ON restaurant.id = review.restaurant_id
ORDER BY review.review_date ASC;

-- C3.1
UPDATE restaurant
SET description = 'Menjual berbagai macam sushi, sashimi, dan ramen'
WHERE id = 2;

SELECT * FROM restaurant;

-- C3.2
UPDATE review
SET rating = 1
WHERE id = 5;

SELECT * FROM review;

-- C4.1
DELETE FROM review
WHERE id = 5;

SELECT * FROM review;

-- C4.2
DELETE FROM restaurant
WHERE id = 3;

SELECT * FROM restaurant;

SELECT * FROM review;

-- D1
SELECT
    restaurant.name AS restaurant_name,
    AVG(review.rating) AS average_rating
FROM restaurant
LEFT JOIN review
    ON restaurant.id = review.restaurant_id
GROUP BY restaurant.name
ORDER BY average_rating DESC
LIMIT 1;

-- D2
SELECT
    restaurant.id AS restaurant_id,
    restaurant.name AS restaurant_name,
    COUNT(review.id) AS review_count
FROM restaurant
LEFT JOIN review 
    ON restaurant.id = review.restaurant_id
GROUP BY restaurant.id, restaurant.name
ORDER BY restaurant.id ASC;

INSERT INTO review VALUES (7, 1, 'Alfi', 3, 'Burgernya biasa aja', '2023-10-07');
INSERT INTO review VALUES (8, 2, 'Doni', 5, 'Sushinya enak', '2023-10-08');
INSERT INTO review VALUES (9, 4, 'Eka', 4, 'Bubur kacang ijo enak dan murah', '2023-10-09');

SELECT * FROM review;

-- D3
SELECT
    restaurant.name AS restaurant_name,
    review.user_name AS reviewer_name,
    review.rating AS reviewer_rating,
    review.review_text AS restaurant_review,
    review.review_date AS latest_review_date
FROM restaurant
JOIN review ON restaurant.id = review.restaurant_id
WHERE review.review_date = (
    SELECT MAX(review_date)
    FROM review
    WHERE restaurant_id = restaurant.id)
ORDER BY latest_review_date DESC;

-- E1
CREATE TABLE menu (
    restaurant_id INT NOT NULL,
    item_name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    description TEXT,
    PRIMARY KEY (restaurant_id, item_name),
    FOREIGN KEY (restaurant_id) REFERENCES restaurant(id)
);

INSERT INTO menu VALUES (1, 'Fried Chicken', 15000.00, 'Ayam goreng renyah dengan saus spesial');
INSERT INTO menu VALUES (1, 'Cheeseburger', 20000.00, 'Burger dengan keju dan sayuran');
INSERT INTO menu VALUES (1, 'French Fries', 10000.00, 'Kentang goreng renyah');
INSERT INTO menu VALUES (2, 'Sushi Combo', 50000.00, 'Berbagai macam sushi dan sashimi');
INSERT INTO menu VALUES (2, 'Sashimi Platter', 40000.00, 'Berbagai macam sashimi segar');
INSERT INTO menu VALUES (2, 'Ramen', 35000.00, 'Berbagai macam ramen lezat');
INSERT INTO menu VALUES (4, 'Bubur Kacang Ijo', 10000.00, 'Bubur kacang ijo lezat');
INSERT INTO menu VALUES (4, 'Bubur Ketan Hitam', 9000.00, 'Bubur ketan hitam lezat');
INSERT INTO menu VALUES (4, 'Bubur Kacang Ijo Komplit', 12000.00, 'Bubur kacang ijo + ketan hitam lezat');

SELECT * FROM menu;

SELECT * FROM review;

SELECT * FROM restaurant;

-- E2
WITH avg_rating AS (
    SELECT 
        restaurant_id,
        AVG(rating) AS average_rating
    FROM review
    GROUP BY restaurant_id
)
SELECT
    restaurant.name AS restaurant_name,
    menu.item_name AS menu_item,
    avg_rating.average_rating
FROM restaurant
JOIN menu ON restaurant.id = menu.restaurant_id
LEFT JOIN avg_rating ON restaurant.id = avg_rating.restaurant_id
ORDER BY avg_rating.average_rating DESC;

