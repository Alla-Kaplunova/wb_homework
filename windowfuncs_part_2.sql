--- 1

SELECT 
    s.SHOPNUMBER,
    sh.CITY,
    sh.ADDRESS,
    SUM(s.QTY) AS SUM_QTY,
    SUM(s.QTY * g.PRICE) AS SUM_QTY_PRICE
FROM 
    sales s
JOIN 
    shops sh ON s.SHOPNUMBER = sh.SHOPNUMBER
JOIN 
    goods g ON s.ID_GOOD = g.ID_GOOD
WHERE 
    s.DATE = '2016-01-02'
GROUP BY 
    s.SHOPNUMBER, sh.CITY, sh.ADDRESS;

--- 2

SELECT 
    s.DATE,
    sh.CITY,
    SUM(s.QTY * g.PRICE) / SUM(SUM(s.QTY * g.PRICE)) OVER (PARTITION BY s.DATE) AS SUM_SALES_REL
FROM 
    sales s
JOIN 
    shops sh ON s.SHOPNUMBER = sh.SHOPNUMBER
JOIN 
    goods g ON s.ID_GOOD = g.ID_GOOD
WHERE 
    g.CATEGORY = 'ЧИСТОТА'
GROUP BY 
    s.DATE, sh.CITY;


--- 3

WITH RankedSales AS (
    SELECT 
        s.DATE,
        s.SHOPNUMBER,
        s.ID_GOOD,
        RANK() OVER (PARTITION BY s.DATE, s.SHOPNUMBER ORDER BY SUM(s.QTY) DESC) AS rank
    FROM 
        sales s
    GROUP BY 
        s.DATE, s.SHOPNUMBER, s.ID_GOOD
)
SELECT 
    DATE,
    SHOPNUMBER,
    ID_GOOD
FROM 
    RankedSales
WHERE 
    rank <= 3;

--- 4

WITH PreviousSales AS (
    SELECT 
        s.DATE,
        s.SHOPNUMBER,
        g.CATEGORY,
        SUM(s.QTY * g.PRICE) AS PREV_SALES,
        LAG(SUM(s.QTY * g.PRICE)) OVER (PARTITION BY s.SHOPNUMBER, g.CATEGORY ORDER BY s.DATE) AS PREV_SALES_LAG
    FROM 
        sales s
    JOIN 
        shops sh ON s.SHOPNUMBER = sh.SHOPNUMBER
    JOIN 
        goods g ON s.ID_GOOD = g.ID_GOOD
    WHERE 
        sh.CITY = 'СПб'
    GROUP BY 
        s.DATE, s.SHOPNUMBER, g.CATEGORY
)
SELECT 
    DATE,
    SHOPNUMBER,
    CATEGORY,
    PREV_SALES_LAG AS PREV_SALES
FROM 
    PreviousSales
WHERE 
    PREV_SALES_LAG IS NOT NULL;
