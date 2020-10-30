/*1. Найдите номер модели, скорость и размер жесткого диска для всех ПК стоимостью менее 500 дол. Вывести: model, speed и hd*/
SELECT model,
	speed,
	hd
FROM PC
WHERE price < 500;

/*2. Найдите производителей принтеров. Вывести: maker*/
SELECT DISTINCT maker
FROM Product
WHERE type = 'Printer';

/*3. Найдите номер модели, объем памяти и размеры экранов ПК-блокнотов, цена которых превышает 1000 дол.*/
SELECT model,
	ram,
	screen
FROM Laptop
WHERE price > 1000;

/*4. Найдите все записи таблицы Printer для цветных принтеров.*/
SELECT *
FROM Printer
WHERE color = 'y';

/*5. Найдите номер модели, скорость и размер жесткого диска ПК, имеющих 12x или 24x CD и цену менее 600 дол.*/
SELECT model,
	speed,
	hd
FROM PC
WHERE (
		cd = '12x'
		OR cd = '24x'
		)
	AND price < 600;

/*6. Для каждого производителя, выпускающего ПК-блокноты c объёмом жесткого диска не менее 10 Гбайт, найти скорости таких ПК-блокнотов. Вывод: производитель, скорость.*/
SELECT DISTINCT Product.maker,
	Laptop.speed
FROM Product
JOIN Laptop ON Product.model = Laptop.model
WHERE Laptop.hd >= 10;

/*7.Найдите номера моделей и цены всех имеющихся в продаже продуктов (любого типа) производителя B (латинская буква).*/
SELECT Product.model,
	price
FROM PC
JOIN Product ON PC.model = Product.model
WHERE Product.maker = 'B'

UNION

SELECT Product.model,
	price
FROM Laptop
JOIN Product ON Laptop.model = Product.model
WHERE Product.maker = 'B'

UNION

SELECT Product.model,
	price
FROM Printer
JOIN Product ON Printer.model = Product.model
WHERE Product.maker = 'B';

/*8. Найдите производителя, выпускающего ПК, но не ПК-блокноты.*/
SELECT maker
FROM Product
WHERE type = 'PC'

EXCEPT

SELECT maker
FROM Product
WHERE type = 'Laptop';

/*9. Найдите производителей ПК с процессором не менее 450 Мгц. Вывести: Maker*/
SELECT DISTINCT Product.maker
FROM Product
JOIN PC ON Product.model = PC.model
WHERE PC.speed >= 450;

/*10. Найдите модели принтеров, имеющих самую высокую цену. Вывести: model, price*/
SELECT model,
	price
FROM Printer
WHERE price = (
		SELECT MAX(price)
		FROM Printer
		);

/*11. Найдите среднюю скорость ПК.*/
SELECT AVG(speed)
FROM PC;

/*12. Найдите среднюю скорость ПК-блокнотов, цена которых превышает 1000 дол.*/
SELECT AVG(speed)
FROM Laptop
WHERE price > 1000;

/*13. Найдите среднюю скорость ПК, выпущенных производителем A.*/
SELECT AVG(PC.speed)
FROM Product
JOIN PC ON Product.model = PC.model
WHERE maker = 'A';

/*14. Найдите класс, имя и страну для кораблей из таблицы Ships, имеющих не менее 10 орудий.*/
SELECT Ships.class,
	Ships.name,
	Classes.country
FROM Ships
JOIN Classes ON Ships.class = Classes.class
WHERE Classes.numGuns > = 10;

/*15. Найдите размеры жестких дисков, совпадающих у двух и более PC. Вывести: HD*/
SELECT hd
FROM PC
GROUP BY hd
HAVING count(hd) >= 2;

/*16. Найдите пары моделей PC, имеющих одинаковые скорость и RAM.
В результате каждая пара указывается только один раз, т.е. (i,j), но не (j,i), Порядок вывода: модель с большим номером, модель с меньшим номером, скорость и RAM.*/
SELECT DISTINCT R.model,
	L.model,
	R.speed,
	R.ram
FROM PC R
JOIN PC L ON L.speed = R.speed
	AND L.ram = R.ram
	AND L.model < P.model;

/*17. Найдите модели ПК-блокнотов, скорость которых меньше скорости каждого из ПК.
Вывести: type, model, speed*/
SELECT DISTINCT Product.type,
	Laptop.model,
	Laptop.speed
FROM Laptop,
	Product
WHERE Laptop.speed < ALL (
		SELECT speed
		FROM PC
		)
	AND Product.type = 'Laptop';

/*18. Найдите производителей самых дешевых цветных принтеров. Вывести: maker, price*/
SELECT DISTINCT Product.maker,
	Printer.price
FROM Printer
JOIN Product ON Printer.model = Product.model
WHERE Printer.price = (
		SELECT MIN(price)
		FROM Printer
		WHERE Printer.color = 'y'
		)
	AND Printer.color = 'y';

/*19.  Для каждого производителя, имеющего модели в таблице Laptop, найдите средний размер экрана выпускаемых им ПК-блокнотов.
Вывести: maker, средний размер экрана.*/
SELECT Product.maker,
	AVG(Laptop.screen)
FROM Product
JOIN Laptop ON Product.model = Laptop.model
GROUP BY Product.maker;

/*20. Найдите производителей, выпускающих по меньшей мере три различных модели ПК. Вывести: Maker, число моделей ПК.*/
SELECT maker,
	COUNT(model)
FROM Product
WHERE Product.type = 'PC'
GROUP BY maker
HAVING COUNT(model) >= 3;

/*21. Найдите максимальную цену ПК, выпускаемых каждым производителем, у которого есть модели в таблице PC.*/
SELECT Product.maker,
	MAX(PC.price)
FROM Product
JOIN PC ON Product.model = PC.model
GROUP BY maker;

/*22. Для каждого значения скорости ПК, превышающего 600 МГц, определите среднюю цену ПК с такой же скоростью. Вывести: speed, средняя цена.*/
SELECT speed,
	AVG(price)
FROM PC
WHERE speed > 600
GROUP BY speed;

/*23. Найдите производителей, которые производили бы как ПК со скоростью не менее 750 МГц, так и ПК-блокноты со скоростью не менее 750 МГц.
Вывести: Maker*/
SELECT Product.maker
FROM Product
JOIN PC ON PC.model = Product.model
WHERE PC.speed > = 750

INTERSECT

SELECT Product.maker
FROM Product
JOIN Laptop ON Laptop.model = Product.model
WHERE Laptop.speed > = 750;

/*24. Перечислите номера моделей любых типов, имеющих самую высокую цену по всей имеющейся в базе данных продукции.*/
WITH models
AS (
	SELECT model,
		price
	FROM PC

	UNION

	SELECT model,
		price
	FROM Laptop

	UNION

	SELECT model,
		price
	FROM Printer
	)
SELECT model
FROM models
WHERE price = (
		SELECT MAX(Price)
		FROM models
		);

/*25. Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM и с самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM. Вывести: Maker*/
SELECT DISTINCT maker
FROM Product
WHERE type = 'printer'
	AND maker IN (
		SELECT maker
		FROM Product
		WHERE model IN (
				SELECT model
				FROM PC
				WHERE speed = (
						SELECT MAX(speed)
						FROM (
							SELECT speed
							FROM PC
							WHERE ram = (
									SELECT MIN(ram)
									FROM PC
									)
							) AS z4
						)
					AND ram = (
						SELECT MIN(ram)
						FROM PC
						)
				)
		);

/*26. Найдите среднюю цену ПК и ПК-блокнотов, выпущенных производителем A (латинская буква). Вывести: одна общая средняя цена.*/
WITH PRICES
AS (
	SELECT PC.price price
	FROM PC
	JOIN Product ON Product.model = PC.model
	WHERE Product.maker = 'A'

	UNION ALL

	SELECT Laptop.price price
	FROM Laptop
	JOIN Product ON Product.model = Laptop.model
	WHERE Product.maker = 'A'
	)
SELECT AVG(PRICES.price)
FROM PRICES;

/*27. Найдите средний размер диска ПК каждого из тех производителей, которые выпускают и принтеры. Вывести: maker, средний размер HD.*/
SELECT Product.maker,
	AVG(PC.hd)
FROM Product
JOIN PC ON Product.model = PC.model
WHERE Product.maker IN (
		SELECT Product.maker
		FROM Product
		WHERE Product.type = 'PC'

		INTERSECT

		SELECT Product.maker
		FROM Product
		WHERE Product.type = 'Printer'
		)
GROUP BY Product.maker;

/*28. Используя таблицу Product, определить количество производителей, выпускающих по одной модели.*/
WITH quantity AS (
		SELECT COUNT(maker) AS q
		FROM Product
		GROUP BY maker
		HAVING COUNT(maker) = 1
		)

SELECT COUNT(q)
FROM quantity;

	/*29. В предположении, что приход и расход денег на каждом пункте приема фиксируется не чаще одного раза в день [т.е. первичный ключ (пункт, дата)], написать запрос с выходными данными (пункт, дата, приход, расход).
Использовать таблицы Income_o и Outcome_o.*/
	WITH k AS (
		SELECT Income_o.point,
			Income_o.DATE
		FROM Income_o

		UNION

		SELECT Outcome_o.point,
			Outcome_o.DATE
		FROM Outcome_o
		)

SELECT k.point,
	k.DATE,
	inc,
	OUT
FROM k
FULL JOIN Income_o ON k.point = Income_o.point
	AND k.DATE = Income_o.DATE
FULL JOIN Outcome_o ON k.point = Outcome_o.point
	AND k.DATE = Outcome_o.DATE;

/*30. В предположении, что приход и расход денег на каждом пункте приема фиксируется произвольное число раз (первичным ключом в таблицах является столбец code), требуется получить таблицу, в которой каждому пункту за каждую дату выполнения операций будет соответствовать одна строка.
Вывод: point, date, суммарный расход пункта за день (out), суммарный приход пункта за день (inc). Отсутствующие значения считать неопределенными (NULL).*/
WITH i AS (
		SELECT point,
			date,
			NULL AS out,
			SUM(inc) AS inc
		FROM Income
		GROUP BY point, date
		),
	o AS (
		SELECT point,
			date,
			SUM(out) AS out,
			NULL AS inc
		FROM Outcome
		GROUP BY point,
			date
		),
	adds_p_and_d AS (
		SELECT point, date
		FROM i

		EXCEPT

		SELECT point, date
		FROM o
		)

SELECT i.point,
	i.DATE,
	i.OUT,
	i.inc
FROM adds_p_and_d
JOIN i ON adds_p_and_d.point = i.point
	AND adds_p_and_d.DATE = i.DATE

UNION

SELECT o.point,
	o.DATE,
	o.OUT,
	i.inc
FROM o
JOIN i ON o.point = i.point
	AND o.DATE = i.DATE

UNION

SELECT o.point,
	o.DATE,
	o.OUT,
	i.inc
FROM o
LEFT JOIN i ON o.point = i.point
	AND o.DATE = i.DATE;
