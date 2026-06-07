create database nashville_housing;
use nashville_housing;

select * from nashville_housing_data;


-- Data cleaning steps

-- standardize date format
-- populate property address data
-- breaking out address into individuals columns(address, city, state) 
-- change Y and N to Yes and No in SoldAsVacant case statment
-- remove duplicate 
-- remove unusead columns


-- standardize date format in MYSQL
-- NOTE in SQL solution for this problem is using (convert) function

select * from nashville_housing_data;

select saledate from nashville_housing_data;

update nashville_housing_data
set saledate = str_to_date(saledate, '%M %e, %Y');




-- populate property address data

select * from nashville_housing_data
where PropertyAddress is null
and ParcelID is null;

-- the goal is to join PropertyAddress with null values to ParcelID. as result PropertyAddress wont have null values.

select n1.ParcelID, n1.PropertyAddress, n2.ParcelID, n2.PropertyAddress,
coalesce(n1.PropertyAddress, n2.PropertyAddress) as new_proper_add
from nashville_housing_data n1
join nashville_housing_data n2 on n1.ParcelID = n2.ParcelID
where n1.UniqueID <> n2.UniqueID
and n1.PropertyAddress is null
and n1.ParcelID is not null;


update nashville_housing_data n1
join nashville_housing_data n2 on n1.ParcelID = n2.ParcelID
set n1.PropertyAddress = coalesce(n1.PropertyAddress, n2.PropertyAddress)
where n1.UniqueID <> n2.UniqueID
and n1.PropertyAddress is null
and n1.ParcelID is not null;


-- breaking out address into individuals columns(address, city, state) in two ways in MYSQL
-- NOTE in SQL solution for this problem is using
-- substring(PropertyAddress, 1, charindex(',' , PropertyAddress)-1)
-- (-1) MEANS one behind the (,) and (+1) MEANS one forward to the (,)
-- second way and the easiest way is to use substringindex in mysql and parsename(replace)  in SQL

select * from nashville_housing_data;

select substring(PropertyAddress, 1, locate(',' , PropertyAddress)-1) as Address, 
substring(PropertyAddress, locate(',' , PropertyAddress)+1, length(PropertyAddress)) as City
from nashville_housing_data;


alter table nashville_housing_data
add column Address text;


alter table nashville_housing_data
add column City text;


update nashville_housing_data
set Address = substring(PropertyAddress, 1, locate(',' , PropertyAddress)-1) ; 


update nashville_housing_data
set City = substring(PropertyAddress, locate(',' , PropertyAddress)+1, length(PropertyAddress)) ;



SELECT  SUBSTRING_INDEX(OwnerAddress, ',', +1) as OWAddress, 
substring_index(substring_index(OwnerAddress,',' , 2), ',', -1) as OWCity,
SUBSTRING_INDEX(OwnerAddress, ',', -1) as OWState,OwnerAddress 
FROM nashville_housing_data;


alter table nashville_housing_data
add column OWAddress text;


alter table nashville_housing_data
add column OWCity text;


alter table nashville_housing_data
add column OWState text;



update nashville_housing_data 
set  OWAddress = substring_index(owneraddress, ',', +1);


update nashville_housing_data 
set  OWCity = substring_index(substring_index(owneraddress, ',', 2), ',', -1);



update nashville_housing_data 
set  OWState = substring_index(owneraddress, ',', -1);



-- change Y and N to Yes and No in SoldAsVacant 



select distinct SoldAsVacant, count(SoldAsVacant) from nashville_housing_data
group by SoldAsVacant
order by 2;


select SoldAsVacant,
case
when SoldAsVacant = 'N' then 'No'
when SoldAsVacant = 'Y' then 'Yes'
else SoldAsVacant
end
from nashville_housing_data;



update nashville_housing_data
set SoldAsVacant = case
when SoldAsVacant = 'N' then 'No'
when SoldAsVacant = 'Y' then 'Yes'
else SoldAsVacant
end;



-- remove duplicate 


with remove_duplicate as

(select * , row_number()over(partition by ParcelID, PropertyAddress, SaleDate,
SalePrice, LegalReference order by UniqueID) as row_num from nashville_housing_data
)
select * from remove_duplicate
where row_num > 1;


with remove_duplicate as

(select * , row_number()over(partition by ParcelID, PropertyAddress, SaleDate,
SalePrice, LegalReference order by UniqueID) as row_num from nashville_housing_data
)
delete from remove_duplicate
where row_num > 1;


-- remove unusead columns

select * from nashville_housing_data;

-- remove unusead columns in sql

-- alter table nashville_housing_data
-- drop column PropertyAddress, OwnerAddress, TaxDistrict;

-- remove unusead columns in MYsql

   alter table nashville_housing_data
   drop column  PropertyAddress, 
   drop column  OwnerAddress,
   drop column  TaxDistrict;




