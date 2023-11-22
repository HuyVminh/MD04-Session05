create database bt_student_test;
use bt_student_test;

create table test(
	test_id int auto_increment primary key,
    name varchar(255)
);
create table student(
	rn int auto_increment primary key,
    name varchar(255),
    age tinyint,
    status bit default(1)
);
create table student_test(
	rn int,
    foreign key (rn) references student(rn),
    test_id int,
    foreign key (test_id) references test(test_id),
    dates date,
    mark int
);

insert into student(name,age) values
	('Nguyen Hong Ha',20),
    ('Truong Ngoc Anh',30),
    ('Tuan Minh',25),
    ('Dan Truong',22);
insert into test(name) values
	('EPC'),
    ('DWMX'),
    ('SQL1'),
    ('SQL2');
insert into student_test(rn,test_id,dates,mark) values
	(1,1,'2006-7-17',8),
    (1,2,'2006-7-18',5),
    (1,3,'2006-7-19',7),
    (2,1,'2006-7-17',7),
    (2,2,'2006-7-18',4),
    (2,3,'2006-7-19',2),
    (3,1,'2006-7-17',10),
    (3,3,'2006-7-18',1);
    
-- Sử dụng alter để sửa đổi
-- a. Thêm ràng buộc dữ liệu cho cột age với giá trị thuộc khoảng: 15-55

alter table student
add constraint age check (age>=15 and age<=55);

-- b. Thêm giá trị mặc định cho cột mark trong bảng StudentTest là 0

alter table student_test
modify column mark int default(0);

-- c. Thêm khóa chính cho bảng studenttest là (RN,TestID)

alter table student_test
add primary key (rn,test_id);

-- d. Thêm ràng buộc duy nhất (unique) cho cột name trên bảng Test

alter table test
modify column name varchar(255) unique;

-- e. Xóa ràng buộc duy nhất (unique) trên bảng Test

alter table test
modify column name varchar(255);

-- Hiển thị danh sách các học viên đã tham gia thi, các môn thi được thi bởi các học viên đó, điểm thi và ngày thi

select s.name, t.name, st.mark,st.dates 
from student_test st
join student s on s.rn=st.rn
join test t on t.test_id=st.test_id
group by s.name, t.name, st.mark,st.dates;

-- Hiển thị danh sách các bạn học viên chưa thi môn nào

select s.rn,s.name,s.age from student s
where s.rn not in(select rn from student_test);

-- Hiển thị danh sách học viên phải thi lại, tên môn học phải thi lại và điểm thi(điểm phải thi lại là điểm nhỏ hơn 5)

select st.rn,s.name,t.name,st.mark 
from student_test st
join student s on s.rn=st.rn
join test t on t.test_id=st.test_id
group by st.rn,s.name,t.name,st.mark 
having st.mark < 5;

-- Hiển thị danh sách học viên và điểm trung bình(Average) của các môn đã thi. 
-- Danh sách phải sắp xếp theo thứ tự điểm trung bình giảm dần(nếu không sắp xếp thì chỉ được ½ số điểm)

select s.rn,s.name,s.age,avg(st.mark) as average
from student s
join student_test st on st.rn=s.rn
group by s.rn,s.name,s.age
order by avg(st.mark) desc;

-- Hiển thị tên và điểm trung bình của học viên có điểm trung bình lớn nhất

select s.rn,s.name,s.age,avg(st.mark) as average
from student s
join student_test st on st.rn=s.rn
group by s.rn,s.name,s.age
having avg(st.mark) > all (select avg(st.mark) as average from student s join student_test st on st.rn=s.rn);

-- Hiển thị điểm thi cao nhất của từng môn học. Danh sách phải được sắp xếp theo tên môn học

select st.test_id,t.name, max(st.mark) from student_test st
join test t on t.test_id=st.test_id
group by st.test_id;

-- Hiển thị danh sách tất cả các học viên và môn học mà các học viên đó đã thi nếu học viên chưa thi môn nào thì phần tên môn học để Null

SELECT s.rn, s.name, IFNULL(t.name, 'Null') AS test_name
FROM student s
LEFT JOIN student_test st ON s.rn = st.rn
LEFT JOIN test t ON t.test_id = st.test_id;

-- Sửa (Update) tuổi của tất cả các học viên mỗi người lên một tuổi.

update student set age = age + 1;

-- Thêm trường tên là Status có kiểu Varchar(10) vào bảng Student.
alter table student
modify column status varchar(10);

-- Cập nhật(Update) trường Status sao cho những học viên nhỏ hơn 30 tuổi sẽ nhận giá trị ‘Young’, 
-- trường hợp còn lại nhận giá trị ‘Old’ sau đó hiển thị toàn bộ nội dung bảng Student lên

UPDATE student SET status = IF(age < 30, 'Young', 'Old');

-- Hiển thị danh sách học viên và điểm thi, dánh sách phải sắp xếp tăng dần theo ngày thi

select st.rn,s.name,st.mark,st.dates from student_test st
join student s on s.rn=st.rn
group by st.rn,s.name,st.mark,st.dates
order by st.dates desc;

-- Hiển thị các thông tin sinh viên có tên bắt đầu bằng ký tự ‘T’ và điểm thi trung bình >4.5. Thông tin bao gồm Tên sinh viên, tuổi, điểm trung bình

select s.rn,s.name,s.age,avg(st.mark) as avg
from student s
join student_test st on s.rn=st.rn
group by s.rn,s.name,s.age
having avg(st.mark) > 4.5 and s.name like 'T%';

-- Hiển thị các thông tin sinh viên (Mã, tên, tuổi, điểm trung bình, xếp hạng). 
-- Trong đó, xếp hạng dựa vào điểm trung bình của học viên, điểm trung bình cao nhất thì xếp hạng 1

select s.rn,s.name,s.age,avg(st.mark) as avg,rank() over (order by avg(st.mark) desc) as xep_hang
from student s
join student_test st on s.rn=st.rn
group by s.rn,s.name,s.age;

-- Sủa đổi kiểu dữ liệu cột name trong bảng student thành nvarchar(max)

alter table student
modify column name nvarchar(11111);

-- Cập nhật (sử dụng phương thức write) cột name trong bảng student với yêu cầu sau:
-- a. Nếu tuổi >20 -> thêm ‘Old’ vào trước tên (cột name)
-- b. Nếu tuổi <=20 thì thêm ‘Young’ vào trước tên (cột name)

UPDATE student SET name = CONCAT( CASE WHEN age > 20 THEN 'Old ' ELSE 'Young ' END, name);

-- Xóa tất cả các môn học chưa có bất kỳ sinh viên nào thi

DELETE FROM test t
WHERE NOT EXISTS ( SELECT st.test_id FROM student_test st WHERE st.test_id = t.test_id);

-- Xóa thông tin điểm thi của sinh viên có điểm <5

delete from student_test
where mark < 5;