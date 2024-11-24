--- 1
/*
Назовем “успешными” (’rich’) селлерами тех:
кто продает более одной категории товаров
и чья суммарная выручка превышает 50 000
Остальные селлеры (продают более одной категории, но чья суммарная выручка менее 50 000) будут обозначаться как ‘poor’. Выведите для каждого продавца количество категорий, средний рейтинг его категорий, суммарную выручку, а также метку ‘poor’ или ‘rich’.
Назовите поля: seller_id, total_categ, avg_rating, total_revenue, seller_type.Выведите ответ по возрастанию id селлера.
Примечание: Категория “Bedding” не должна учитываться в расчетах.
*/

SELECT 
    seller_id,
    COUNT(DISTINCT category) AS total_categ, 
    AVG(rating) AS avg_rating, 
    SUM(revenue) AS total_revenue,
    CASE
        WHEN COUNT(DISTINCT category) > 1 AND SUM(revenue) > 50000 THEN 'rich'
        ELSE 'poor'
    END AS seller_type
FROM sellers
WHERE category != 'Bedding'
GROUP BY seller_id
ORDER BY seller_id;


--- 2
/*
Для каждого из неуспешных продавцов (из предыдущего задания) посчитайте, сколько полных месяцев прошло с даты регистрации продавца.
Отсчитывайте от того времени, когда вы выполняете задание. Считайте, что в месяце 30 дней. Например, для 61 дня полных месяцев будет 2.
Также выведите разницу между максимальным и минимальным сроком доставки среди неуспешных продавцов. Это число должно быть одинаковым для всех неуспешных продавцов.
Назовите поля: seller_id, month_from_registration ,max_delivery_difference.Выведите ответ по возрастанию id селлера.
Примечание: Категория “Bedding” по-прежнему не должна учитываться в расчетах.
*/

WITH seller_types AS (
    SELECT 
        seller_id,
        CASE
            WHEN COUNT(DISTINCT category) > 1 AND SUM(revenue) > 50000 THEN 'rich'
            ELSE 'poor'
        END AS seller_type
    FROM sellers
    WHERE category != 'Bedding'
    GROUP BY seller_id
)
SELECT 
    seller_id,
    DATE_PART('year', AGE(TO_DATE(date, 'DD/MM/YYYY'), TO_DATE(date_reg, 'DD/MM/YYYY'))) * 12 +
    DATE_PART('month', AGE(TO_DATE(date, 'DD/MM/YYYY'), TO_DATE(date_reg, 'DD/MM/YYYY'))) AS month_from_registration,
    MAX(delivery_days) - MIN(delivery_days) AS max_delivery_difference
FROM sellers
WHERE category != 'Bedding'
  AND seller_id IN (
      SELECT seller_id
      FROM seller_types
      WHERE seller_type = 'poor'
  )
GROUP BY seller_id
ORDER BY seller_id;


--- 3
/*
Отберите продавцов, зарегистрированных в 2022 году и продающих ровно 2 категории товаров с суммарной выручкой, превышающей 75 000.
Выведите seller_id данных продавцов, а также столбец category_pair с наименованиями категорий, которые продают данные селлеры.
Например, если селлер продает товары категорий “Game”, “Fitness”, то для него необходимо вывести пару категорий category_pair с разделителем “-” в алфавитном порядке (т.е. “Game - Fitness”).
Поля в результирующей таблице: seller_id, category_pair
*/



WITH sellers_2022 AS (
    SELECT 
        seller_id, 
        STRING_AGG(DISTINCT category, ' - ' ORDER BY category) AS category_pair,
        SUM(revenue) AS total_revenue
    FROM sellers
    WHERE EXTRACT(YEAR FROM TO_DATE(date_reg, 'DD/MM/YYYY')) = 2022
    GROUP BY seller_id
)
SELECT seller_id, category_pair
FROM sellers_2022
WHERE array_length(string_to_array(category_pair, ' - '), 1) = 2 AND total_revenue > 75000
ORDER BY seller_id;
