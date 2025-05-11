-- Create sample tables
CREATE TABLE IF NOT EXISTS customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    signup_date DATE NOT NULL DEFAULT CURRENT_DATE,
    customer_tier VARCHAR(20) CHECK (customer_tier IN ('basic', 'premium', 'vip'))
);

CREATE TABLE IF NOT EXISTS products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    in_stock BOOLEAN DEFAULT true
);

CREATE TABLE IF NOT EXISTS orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id),
    order_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(12,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'pending'
);

-- Insert sample data
INSERT INTO customers (first_name, last_name, email, customer_tier) VALUES
('John', 'Doe', 'john.doe@example.com', 'premium'),
('Jane', 'Smith', 'jane.smith@example.com', 'basic'),
('Michael', 'Johnson', 'michael.j@example.com', 'vip'),
('Emily', 'Williams', 'emily.w@example.com', 'basic'),
('David', 'Brown', 'david.b@example.com', 'premium');

INSERT INTO products (product_name, category, price) VALUES
('Laptop', 'Electronics', 999.99),
('Smartphone', 'Electronics', 699.99),
('Desk Chair', 'Furniture', 199.50),
('Coffee Maker', 'Appliances', 89.99),
('Notebook', 'Stationery', 4.99);

INSERT INTO orders (customer_id, total_amount, status) VALUES
(1, 999.99, 'completed'),
(1, 199.50, 'completed'),
(2, 699.99, 'shipped'),
(3, 89.99, 'pending'),
(4, 4.99, 'completed'),
(5, 1099.98, 'processing');

-- Create some indexes
CREATE INDEX idx_customers_email ON customers(email);
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_products_category ON products(category);

-- Create a view for customer orders
CREATE VIEW customer_order_summary AS
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.email,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_spent
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, customer_name, c.email;