/* Cleaning data in SQl queries*/

SELECT*
FROM  `datacleaning`.`nashville housing data for data cleaning`;

-- Standardized sale date
SELECT SaleDate
FROM `datacleaning`.`nashville housing data for data cleaning`;
-- populate property address

select PropertyAddress
    FROM datacleaning.`nashville housing data for data cleaning` 
   WHERE PropertyAddress IS NULL;
    -- USING the case statement
SELECT a1.ParcelID,
a1.PropertyAddress,
a2.ParcelID,
a2.PropertyAddress,
    CASE 
    WHEN a1.PropertyAddress IS NULL THEN a2.PropertyAddress ELSE a1.PropertyAddress END
    FROM datacleaning.`nashville housing data for data cleaning` AS a1
LEFT JOIN
   datacleaning.`nashville housing data for data cleaning` AS a2
   ON a1.ParcelID=a2.ParcelID
 AND a1.UniqueID<>a2.UniqueID
 WHERE a1.PropertyAddress IS NULL ;
   -- USING coalesce
   SELECT a1.ParcelID,
   a1.PropertyAddress,
   a2.ParcelID,
   coalesce(a1.PropertyAddress,a2.PropertyAddress)
FROM datacleaning.`nashville housing data for data cleaning` AS a1
  JOIN
   datacleaning.`nashville housing data for data cleaning` AS a2
 ON a1.ParcelID=a2.ParcelID
  AND a1.UniqueID<>a2.UniqueID
WHERE a1.PropertyAddress IS NULL;
   -- updating the property address
UPDATE  datacleaning.`nashville housing data for data cleaning` AS a1  
JOIN   datacleaning.`nashville housing data for data cleaning` AS a2  
ON a1.ParcelID=a2.ParcelID  AND a1.UniqueID<>a2.UniqueID    
SET    a1.PropertyAddress =coalesce(a1.PropertyAddress,a2.PropertyAddress)  
 WHERE a1.PropertyAddress IS NULL;
 
 -- Breaking out address into individual columns(address,city,state)
 
 SELECT PropertyAddress
 FROM datacleaning.`nashville housing data for data cleaning`;
-- WHERE PROPERTY ADDRESS IS NULL
 -- order by ParcelID
 SELECT substring(PropertyAddress,1,locate(',',PropertyAddress)-1) AS Address,
substring(PropertyAddress,locate(',',PropertyAddress)+1,length(PropertyAddress)) AS Address
 FROM datacleaning.`nashville housing data for data cleaning`;
 
 ALTER TABLE `datacleaning`.`nashville housing data for data cleaning`
ADD PropertysplitAddress VARCHAR(255);
 
 UPDATE `datacleaning`.`nashville housing data for data cleaning`
 SET PropertysplitAddress=substring(PropertyAddress,1,locate(',',PropertyAddress)-1);
 
 Alter TABLE `datacleaning`.`nashville housing data for data cleaning`
 ADD Propertysplitcity VARCHAR(255);
 
 UPDATE datacleaning.`nashville housing data for data cleaning`
 SET Propertysplitcity =substring(PropertyAddress,locate(',',PropertyAddress)+1,length(PropertyAddress));

SELECT *
FROM `datacleaning`.`nashville housing data for data cleaning`;
-- breaking out owner address into  (address,city and state)

SELECT OwnerAddress
FROM `datacleaning`.`nashville housing data for data cleaning`;

SELECT 
substring_index(OwnerAddress,',',1),
substring_index(substring_index(OwnerAddress,',',2),',','-1'),
substring_index(OwnerAddress,',',-1)
FROM `datacleaning`.`nashville housing data for data cleaning`;

ALTER TABLE `datacleaning`.`nashville housing data for data cleaning`
ADD OwnersplitAddress VARCHAR(255);

UPDATE `datacleaning`.`nashville housing data for data cleaning`
SET OwnersplitAddress=substring_index(OwnerAddress,',',1);

ALTER TABLE `datacleaning`.`nashville housing data for data cleaning`
ADD OwnersplitCity VARCHAR(255);

UPDATE `datacleaning`.`nashville housing data for data cleaning`
SET OwnersplitCity=substring_index(substring_index(OwnerAddress,',',2),',','-1');

Alter TABLE `datacleaning`.`nashville housing data for data cleaning`
ADD OwnersplitState VARCHAR(255);

UPDATE `datacleaning`.`nashville housing data for data cleaning`
SET OwnersplitState=substring_index(OwnerAddress,',',-1);

SELECT *
FROM `datacleaning`.`nashville housing data for data cleaning`;

-- change Y and N to Yes and No in the SoldAsVacant field


SELECT SoldAsVacant,
CASE 
WHEN SoldAsVacant ='Y' THEN 'Yes' 
WHEN SoldAsVacant='N' THEN 'NO'
ELSE SoldAsVacant 
END
FROM `datacleaning`.`nashville housing data for data cleaning`;

UPDATE  `datacleaning`.`nashville housing data for data cleaning`
SET SoldAsVacant=CASE WHEN SoldAsVacant ='Y' THEN 'Yes' 
WHEN SoldAsVacant='N' THEN 'NO'
ELSE SoldAsVacant 
END;

-- identifying duplicates
SELECT *,
ROW_NUMBER() OVER(PARTITION BY ParcelID,PropertyAddress,SalePrice,SaleDate,LegalReference ORDER BY UniqueID) AS row_num
FROM `datacleaning`.`nashville housing data for data cleaning`;


 -- delete unused columns
 
 SELECT *
 FROM `datacleaning`.`nashville housing data for data cleaning`;
 
 ALTER TABLE `datacleaning`.`nashville housing data for data cleaning`
 DROP COLUMN OwnerAddress;
 ALTER TABLE `datacleaning`.`nashville housing data for data cleaning`
 DROP COLUMN PropertyAddress;
  ALTER TABLE `datacleaning`.`nashville housing data for data cleaning`
 DROP COLUMN TaxDistrict;
ALTER TABLE `datacleaning`.`nashville housing data for data cleaning`
 DROP COLUMN SaleDate ;
 
 -- final table
 SELECT *
 FROM `datacleaning`.`nashville housing data for data cleaning`












