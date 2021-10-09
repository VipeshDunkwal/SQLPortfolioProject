--cleaning Data in SQL queries

Select*
FROM PortfolioProject.dbo.[NashvilleHousing]


--------------------------------------------------------------------------------------------------------------


-- standardize Date format
Select SaleDateConverted,Convert(date,SaleDate)
FROM PortfolioProject.dbo.[NashvilleHousing]

--Update NashvilleHousing
--SET SaleDate= Convert(date,SaleDate)

ALTER Table PortfolioProject.dbo.[NashvilleHousing]
ADD saleDateConverted Date;

Update PortfolioProject.dbo.[NashvilleHousing]
SET SaleDateConverted= Convert(date,SaleDate)



-------------------------------------------------------------------------------------------------------------------



--Populated the Property Address data
Select *
FROM PortfolioProject.dbo.[NashvilleHousing]
--Where PropertyAddress is NULL
order by ParcelID

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,isNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject.dbo.[NashvilleHousing] a                --Just JOINIG the Two Table
Join PortfolioProject.dbo.[NashvilleHousing] b
     on a.ParcelID=b.ParcelID
	 ANd a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is NULL            --Checking for Null Property address


Update a
SET PropertyAddress = isNULL(a.PropertyAddress,b.PropertyAddress)                --Populating the Null PropertyAdress
FROM PortfolioProject.dbo.[NashvilleHousing] a
Join PortfolioProject.dbo.[NashvilleHousing] b
     on a.ParcelID=b.ParcelID
	 ANd a.[UniqueID ]<>b.[UniqueID ]
where PropertyAddress is NULL



----------------------------------------------------------------------------------------------------------------



--Breaking Out address into Individual Columns(address,city,state)



Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing

   --using substring,character index

SELECT
substring(PropertyAddress,1,Charindex(',',PropertyAddress)-1) as address
,substring(PropertyAddress,Charindex(',',PropertyAddress)+1,Len(PropertyAddress)) as address
From PortfolioProject.dbo.NashvilleHousing

   --creting new column 
ALTER Table PortfolioProject.dbo.[NashvilleHousing]
ADD PropertysplitAddress NVARCHAR(255);

Update PortfolioProject.dbo.[NashvilleHousing]
SET PropertysplitAddress= substring(PropertyAddress,1,Charindex(',',PropertyAddress)-1)

ALTER Table PortfolioProject.dbo.[NashvilleHousing]
ADD PropertysplitCity NVARCHAR(255);

Update PortfolioProject.dbo.[NashvilleHousing]
SET PropertysplitCity= substring(PropertyAddress,Charindex(',',PropertyAddress)+1,Len(PropertyAddress))

SELECT*
From PortfolioProject.dbo.NashvilleHousing


   --simple way of doing it for owner Address

SELECT owneraddress
From PortfolioProject.dbo.NashvilleHousing

select
PARSENAME(Replace(owneraddress,',','.'),3),
PARSENAME(Replace(owneraddress,',','.'),2)
,PARSENAME(Replace(owneraddress,',','.'),1)
From PortfolioProject.dbo.NashvilleHousing


ALTER Table PortfolioProject.dbo.[NashvilleHousing]
ADD ownersplitAddress NVARCHAR(255);

Update PortfolioProject.dbo.[NashvilleHousing]
SET ownersplitAddress= PARSENAME(Replace(owneraddress,',','.'),3)

ALTER Table PortfolioProject.dbo.[NashvilleHousing]
ADD ownersplitCity NVARCHAR(255);

Update PortfolioProject.dbo.[NashvilleHousing]
SET ownersplitCity= PARSENAME(Replace(owneraddress,',','.'),2)

ALTER Table PortfolioProject.dbo.[NashvilleHousing]
ADD ownersplitstate NVARCHAR(255);         

Update PortfolioProject.dbo.[NashvilleHousing]
SET ownersplitstate= PARSENAME(Replace(owneraddress,',','.'),1)

SELECT*
From PortfolioProject.dbo.NashvilleHousing




---------------------------------------------------------------------------------------------------------------------



---Change Y and N to Yes and No in'sold as vacant' column


SELECT Distinct(SoldAsVacant), count(soldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2


Select SoldAsVacant
,Case When SoldAsVacant='Y' Then 'Yes'
      When SoldAsVacant='N' Then 'NO'
	  ELSE SoldAsVacant
	  END

From PortfolioProject.dbo.NashvilleHousing

Update PortfolioProject.dbo.NashvilleHousing 
SET SoldAsVacant = Case When SoldAsVacant='Y' Then 'Yes'
      When SoldAsVacant='N' Then 'NO'
	  ELSE SoldAsVacant
	  END



-----------------------------------------------------------------------------------------------------------------

-- REMOVE Duplicates
   --using CTE(common Table expression)

With RomNumCTE AS (
Select*,
      Row_NUMBER() OVER (
	  PARTITION BY ParcelID,
	               PropertyAddress,
				   SalePrice,
				   SaleDate,
				   LegalReference
				   ORDER BY
				     UniqueID
					  ) row_num

  
From PortfolioProject.dbo.NashvilleHousing
)
Delete
From RomNumCTE
where Row_num>1







-----------------------------------------------------------------------------------------------------------------

--Delete Unused columns

select*
From  PortfolioProject.dbo.NashvilleHousing

ALTER TABLE  PortfolioProject.dbo.NashvilleHousing
DROP COLUMN Owneraddress,Taxdistrict,Propertyaddress


ALTER TABLE  PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate







