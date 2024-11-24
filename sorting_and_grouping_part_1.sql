-- 1

/*
Для каждого города выведите число покупателей из соответствующей таблицы, сгруппированных по возрастным категориям и отсортированных по убыванию количества покупателей в каждой категории.
Примечание: под возрастной категорией подразумевается возраст человека в полных годах (например, 21, 35, 65 и т.д.). 
Можете дополнительно написать запрос именно для “категорий”: от 0 до 20 (категория young), от 21 до 49 (категория adult), от 50 и выше (категория old)
*/


SELECT 
	city,
	CASE 
		when age::integer between 0 and 20 then 'young'
		when age::integer between 21 and 49 then 'adult'
		when age::integer >= 50 then 'old'
	END as age_cat
	,
	COUNT(id) as cnt
FROM users
GROUP BY city, age_cat
ORDER BY cnt desc;

-- 2

/*
Рассчитайте среднюю цену категорий товаров в таблице products, в названиях товаров которых присутствуют слова «hair» или «home». 
Среднюю цену округлите до двух знаков после запятой. Столбец с полученным значением назовите avg_price.

Поля в результирующей таблице: avg_price, category.
*/

SELECT
	category,
  TRUNC(AVG(CAST(price as DOUBLE PRECISION))::DECIMAL, 2) as avg_price
FROM products
WHERE name ilike '%hair%' or name ilike '%home%'
GROUP BY category;
