SELECT *
FROM menu;

CREATE TABLE menu (
    restaurant_id INT NOT NULL,
    item_name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    description TEXT,
    PRIMARY KEY (restaurant_id, item_name),
    FOREIGN KEY (restaurant_id) REFERENCES restaurant(id)
);

INSERT INTO menu (restaurant_id, item_name, price, description)
VALUES
(1, 'Veggie Pizza', 9.99, 'A delicious pizza with fresh vegetables.'),
(2, 'Salmon Sushi', 11.50, 'Freshly made salmon sushi.'),
(3, 'BBQ Burger', 8.99, 'Juicy beef patty with BBQ sauce.');

UPDATE 
    menu 
SET
    price = 10.99
WHERE 
    1 = 1
    AND restaurant_id = 1 
    AND item_name = 'Veggie Pizza';

DELETE FROM menu
WHERE 
    restaurant_id = 3 
    AND item_name = 'BBQ Burger';


-- Semua menu serta restoran yang memiliki harga lebih dari 9.00, diurutkan dari harga tertinggi ke terendah
SELECT
    menu.item_name AS menu_name,
    restaurant.name AS restaurant_name,
    menu.price
FROM menu
JOIN restaurant ON menu.restaurant_id = restaurant.id
WHERE menu.price > 9.00
ORDER BY menu.price DESC;