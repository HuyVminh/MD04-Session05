create database session05_bt_lab4;
use session05_bt_lab4;

create table customer(
	cID int primary key auto_increment,
    cName varchar(255),
    cAge int
);
create table orders(
	oID int primary key auto_increment,
    cID int,
    foreign key(cID) references customer(cID),
    oDate date,
    oTotalPrice float
);
create table products(
	pID int primary key auto_increment,
    pName varchar(255),
    pPrice float
);
create table order_detail(
	oID int,
    foreign key(oID) references orders(oID),
    pID int,
    foreign key(pID) references products(pID),
    odQty int
);
insert into customer(cName,cAge) values
	('Minh Quan',10),
    ('Ngoc Oanh',20),
    ('Hong Ha',50);
    
insert into orders(cID,oDate,oTotalPrice) values
	(1,'2006-3-21',null),
    (2,'2006-3-23',null),
    (1,'2006-3-16',null);
    
insert into products(pName,pPrice) values
	('May giat',3),
    ('Tu lanh',5),
    ('Dieu hoa',7),
    ('Quat',1),
    ('Bep dien',2);
    
insert into order_detail(oID,pID,odQty) values
	(1,1,3),
    (1,3,7),
    (1,4,2),
    (2,1,1),
    (3,1,8),
    (2,5,4),
    (2,3,3);
    
select * from orders;

-- Hiển thị tên và giá của các sản phẩm có giá cao nhất
select pID,pName,pPrice from products
where pPrice >= all (select pPrice from products);

-- Hiển thị danh sách các khách hàng đã mua hàng, và danh sách sản phẩm được mua bởi các khách đó
select o.oID,c.cName,p.pName from customer c
join orders o on o.cID=c.cID
join order_detail od on od.oID=o.oID
join products p on p.pID=od.pID
group by o.oID,c.cName,p.pName;

-- Hiển thị tên những khách hàng không mua bất kỳ một sản phẩm nào
select c.cID,c.cName from customer c
where not exists (select * from orders o where o.cID=c.cID);

-- Hiển thị chi tiết của từng hóa đơn
select o.oID,o.oDate,od.odQty,p.pName,p.pPrice from orders o
join order_detail od on od.oID=o.oID
join products p on p.pID=od.pID;

-- Hiển thị mã hóa đơn, ngày bán và giá tiền của từng hóa đơn (giá một hóa đơn được tính bằng tổng giá bán của từng loại mặt hàng xuất hiện trong hóa đơn. 
-- Giá bán của từng loại được tính = odQTY*pPrice) 
select o.oID,o.oDate,SUM(od.odQty*p.pPrice) as total from orders o
join order_detail od on od.oID=o.oID
join products p on p.pID=od.pID
group by o.oID,o.oDate;