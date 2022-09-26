/* Cleaning data in SQl queries*/

select*
from `datacleaning`.`nashville housing data for data cleaning`;

-- Standardized sale date
SELECT SaleDate
FROM `datacleaning`.`nashville housing data for data cleaning`;
-- populate property address

select PropertyAddress
    FROM datacleaning.`nashville housing data for data cleaning` 
    where PropertyAddress is null;
    
select a1.ParcelID,a1.PropertyAddress,a2.ParcelID,a2.PropertyAddress,
    case when a1.PropertyAddress is null then a2.PropertyAddress else a1.PropertyAddress end
    FROM datacleaning.`nashville housing data for data cleaning` as a1
left  join
   datacleaning.`nashville housing data for data cleaning` as a2
   on a1.ParcelID=a2.ParcelID
   and a1.UniqueID<>a2.UniqueID
   where a1.PropertyAddress is null;
   
   select a1.ParcelID,a1.PropertyAddress,a2.ParcelID,coalesce(a1.PropertyAddress,a2.PropertyAddress)
FROM datacleaning.`nashville housing data for data cleaning` as a1
  join
   datacleaning.`nashville housing data for data cleaning` as a2
   on a1.ParcelID=a2.ParcelID
   and a1.UniqueID<>a2.UniqueID
   where a1.PropertyAddress is null;
   -- updating the property address
  update  datacleaning.`nashville housing data for data cleaning` as a1  
 join    datacleaning.`nashville housing data for data cleaning` as a2  
 on a1.ParcelID=a2.ParcelID    and a1.UniqueID<>a2.UniqueID    
 set     a1.PropertyAddress = coalesce(a1.PropertyAddress,a2.PropertyAddress)  
 where a1.PropertyAddress is null;
 
 -- Breaking out address into individual columns(address,city,state)
 
 SELECT PropertyAddress
 FROM datacleaning.`nashville housing data for data cleaning`;
 -- where PropertyAddress in null
 -- order by ParcelID
 SELECT substring(PropertyAddress,1,locate(',',PropertyAddress)-1) as Address,
substring(PropertyAddress,locate(',',PropertyAddress)+1,length(PropertyAddress)) as Address
 FROM datacleaning.`nashville housing data for data cleaning`;
 
 ALTER TABLE `datacleaning`.`nashville housing data for data cleaning`
 add PropertysplitAddress varchar(255);
 
 UPDATE `datacleaning`.`nashville housing data for data cleaning`
 SET PropertysplitAddress=substring(PropertyAddress,1,locate(',',PropertyAddress)-1);
 
 Alter TABLE `datacleaning`.`nashville housing data for data cleaning`
 ADD Propertysplitcity varchar(255);
 
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
CASE WHEN SoldAsVacant ='Y' THEN 'Yes' 
WHEN SoldAsVacant='N' THEN 'NO'
ELSE SoldAsVacant 
END
FROM `datacleaning`.`nashville housing data for data cleaning`;

UPDATE  `datacleaning`.`nashville housing data for data cleaning`
SET SoldAsVacant=CASE WHEN SoldAsVacant ='Y' THEN 'Yes' 
WHEN SoldAsVacant='N' THEN 'NO'
ELSE SoldAsVacant 
END;

-- remove duplicates
SELECT *,
ROW_NUMBER() OVER(PARTITION BY ParcelID,PropertyAddress,SalePrice,SaleDate,LegalReference ORDER BY UniqueID) as row_num
FROM `datacleaning`.`nashville housing data for data cleaning`;

WITH Rownumb AS (SELECT *,
ROW_NUMBER() OVER(
PARTITION BY ParcelID,PropertyAddress,SalePrice,SaleDate,LegalReference ORDER BY UniqueID) as row_num
FROM `datacleaning`.`nashville housing data for data cleaning`)
 DELETE 
 FROM Rownumb 
 PARTITION (UniqueID, ParcelID, LandUse, PropertyAddress, SaleDate, SalePrice, LegalReference, SoldAsVacant, OwnerName, OwnerAddress, Acreage, TaxDistrict, LandValue, BuildingValue, TotalValue, YearBuilt, Bedrooms, FullBath, HalfBath, PropertysplitAddress, Propertysplitcity, OwnersplitAddress, OwnersplitCity, OwnersplitState)
 WHERE row_num >1;
 
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












