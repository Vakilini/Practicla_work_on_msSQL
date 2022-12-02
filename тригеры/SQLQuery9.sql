/*ЗАДАНИЕ 1*/
CREATE TRIGGER UPDATE_ORDER
ON [ORDER]
AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON;
	PRINT 'ЗАПИСЬ ДОБАВЛЕНА!'
END
GO
/*Проверка тригера*/
INSERT INTO [ORDER]
(IdCust)
VALUES
(3)
GO
/*Дроп тригера*/
DROP TRIGGER UPDATE_ORDER
GO
/*ЗАДАНИЕ 2*/
CREATE TRIGGER ROLLBACK_ORDER
ON OrdItem
AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON;
	IF (SELECT Qty FROM inserted) < 1
		BEGIN
			ROLLBACK TRAN
			PRINT 'ВЫ НЕ МОЖЕТЕ СОЗДАТЬ ЗАКАЗ С КОЛИЧЕСТВОМ МЕНЬШЕ 1!'
		END
RETURN
END
GO
/*Проверка тригера*/
INSERT INTO [ORDER]
(IdCust)
VALUES
(0)
GO
/*ЗАДАНИЕ 3*/
CREATE TRIGGER Qty_UPDATE
ON OrdItem
AFTER INSERT
AS
DECLARE @X INT, @Y INT
BEGIN
	SET NOCOUNT ON;
	IF NOT EXISTS(SELECT * FROM inserted
	WHERE inserted.Qty <= ALL
		(SELECT Product.InStock FROM Product
		WHERE inserted.IdProd=Product.IdProd))
BEGIN
ROLLBACK TRAN
PRINT 'НЕ ДОПУСТИМОЕ КОЛ-ВО ТОВАРА'
END
SELECT @Y=inserted.idProd, @X=inserted.Qty
FROM inserted
UPDATE Product
SET Product.InStock=Product.InStock-@X
WHERE Product.IdProd=@Y
END
GO

INSERT INTO [ORDER]
(IdCust)
VALUES
(5000)
GO

CREATE TRIGGER trig3
ON Shipmen
after insert
AS
update Product
set InStock = InStock + s.Qty 
from Shipmen s join
inserted i
 on s.IdProd = i.IdProd
 go

 insert into Shipmen
 ([Description], Qty)
 values
 ('конфета',30)
 go
/*ЗАДАНИЕ 4*/
create table History
(
	Id INT IDENTITY PRIMARY KEY,
	idProduct INT NOT NULL,
	Operation NVARCHAR(200) NOT NULL,
	CreateAt DATETIME NOT NULL DEFAULT GETDATE()
);
go

create trigger Product_INSERT
ON Product
AFTER INSERT
AS
INSERT INTO History (idProduct, Operation)
SELECT IdProd, 'Добавлен товар' + [Description]
FROM INSERTED
go

insert into Product
([Description],InStock)
values
('конфета', 200)
go

create trigger Product_DELITE
on product
after DELETE
AS
Insert into history (idProduct, Operation)
select IdProd, 'Товар удалён' + [Description]
from inserted
go

create trigger Product_UPDATE
on product
after UPDATE
AS
Insert into history (idProduct, Operation)
select IdProd, 'Товар обнавлён' + [Description]
from inserted
go

/*ЗАДАНИЕ 5*/

create trigger products_delete
on Product
instead of delete
as
update Product
set IsDeleted = 1
Where IdProd = (select IdProd From deleted)

delete from Product
Where [Description]='iPhone X'

select * from Product
go

create trigger Customer_delete
on Customer
instead of delete
as
update Customer
set IsDeleted = 1
Where IdCust = (select IdCust From deleted)
go