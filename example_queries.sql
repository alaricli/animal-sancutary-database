-- Insert
insert into Habitats values ('Lion Pen', 5);

-- Delete
drop table Habitats;

-- Update
UPDATE Table SET name='" . $new_name . "' WHERE name='" . $old_name . "'

-- Select
SELECT 
from 
Animals 
where species = 'Lion'

-- Projection
Select productName, price 
from AnimalProduct 
WHERE price < 20 

-- Join
select AnimalProductProcured.visitorID, AnimalProduct.price 
FROM AnimalProductProcured 
INNER JOIN AnimalProduct 
ON AnimalProductProcured.animalName, AnimalProductProcured.animalSpecies, AnimalProductProcured.productName = AnimalProduct.animalName, AnimalProduct.animalSpecies, AnimalProduct.productName

-- Join
SELECT a.visitorID, p.price
FROM AnimalProductProcured a, AnimalProduct p
WHERE a.animalName = p.animalName and a.animalSpecies = p.animalSpecies and a.productName = p.productName;

-- Aggregation with Group By,
SELECT animalSpecies,  AVG(price)
FROM AnimalProduct
GROUP BY animalSpecies;

-- Aggregation with Group By and having
SELECT hname,  AVG(capacity)
FROM Habitats
GROUP BY hname
HAVING count (*) > 1;

-- Nested Aggregation with Group By and having
SELECT animalSpecies,  AVG(price)
FROM AnimalProduct
GROUP BY animalSpecies
HAVING SUM(price) > (SELECT MIN(amountSponsored) FROM Sponsor);


-- -- DIVISION primary carer who cares for all animals
SELECT p.pID
FROM   PrimaryCarers p
WHERE NOT EXISTS 
(SELECT  *
FROM  Animals
MINUS
SELECT  *
FROM  Animals a
WHERE a.primaryCarerID = p.pID);
