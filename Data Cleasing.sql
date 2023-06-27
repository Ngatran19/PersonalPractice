--Cleaning Data in SQL Queries

select * 
from [data cleaning].dbo.Sheet1

-- Standardize Date Format
update dbo.Sheet1
set SaleDate = convert (date,SaleDate)

alter table dbo.Sheet1
Add  SaleDateConvert date

update dbo.Sheet1
set SaleDateConvert = convert (date,SaleDate)

select SaleDateConvert
from dbo.Sheet1

-- Populate Property Address data

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from [data cleaning].dbo.Sheet1 a
join [data cleaning].dbo.Sheet1 b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null
order by a.ParcelID

update a
set a.PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from [data cleaning].dbo.Sheet1 a
join [data cleaning].dbo.Sheet1 b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null


-- Breaking out Address into Individual Columns (Address, City, State)
select SUBSTRING(c.PropertyAddress,1, CHARINDEX(',',c.PropertyAddress) -1),
SUBSTRING(c.PropertyAddress,CHARINDEX(',',c.PropertyAddress) +1, LEN(c.PropertyAddress))
from [data cleaning].dbo.Sheet1 c

alter table  [data cleaning].dbo.Sheet1
add PropertySplitAddress nvarchar(255),
    PropertySplitCity nvarchar(255)

Update  [data cleaning].dbo.Sheet1
set PropertySplitAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress) -1),
Update  [data cleaning].dbo.Sheet1
set PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))

select 
PARSENAME(replace(OwnerAddress,',','.'),3),
PARSENAME(replace(OwnerAddress,',','.'),2),
PARSENAME(replace(OwnerAddress,',','.'),1)
from [data cleaning].dbo.Sheet1

alter table  [data cleaning].dbo.Sheet1
add OwnerSplitAddress nvarchar(255),
    OwnerSplitCity nvarchar(255),
	OwnerSplitState nvarchar(255)

Update  [data cleaning].dbo.Sheet1
set OwnerSplitAddress = PARSENAME(replace(OwnerAddress,',','.'),3)
Update  [data cleaning].dbo.Sheet1
set OwnerSplitCity = PARSENAME(replace(OwnerAddress,',','.'),2)
Update  [data cleaning].dbo.Sheet1
set OwnerSplitState = PARSENAME(replace(OwnerAddress,',','.'),1)

-- Change Y and N to Yes and No in "Sold as Vacant" field

select SoldAsVacant, COUNT(*)
from  [data cleaning].dbo.Sheet1
group by SoldAsVacant
order by COUNT(*)


select SoldAsVacant, 
case when SoldAsVacant = 'N' then 'No'
     when SoldAsVacant = 'Y' then 'Yes'
	 else SoldAsVacant
	 end
from [data cleaning].dbo.Sheet1

update [data cleaning].dbo.Sheet1
set SoldAsVacant = case when SoldAsVacant = 'N' then 'No'
     when SoldAsVacant = 'Y' then 'Yes'
	 else SoldAsVacant
	 end
from [data cleaning].dbo.Sheet1

-- Remove Duplicates
select [UniqueID ], COUNT (*)
from [data cleaning].dbo.Sheet1
group by [UniqueID ]
having COUNT (*)>1

with dupi as (
select PropertyAddress,ParcelID,SaleDate,SalePrice,LegalReference,
ROW_NUMBER() OVER(PARTITION BY  PropertyAddress,
								ParcelID,
								SaleDate,
								SalePrice,
								LegalReference
								ORDER BY ParcelID) dup
from [data cleaning].dbo.Sheet1)
select dup
from dupi
where dup > 1
  





-- Delete Unused Columns

