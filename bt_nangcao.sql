CREATE DATABASE session05_nangcao_qlsv;
USE session05_nangcao_qlsv;

CREATE TABLE Subjects(
	subject_id int(4) primary key auto_increment,
    subject_name varchar(50)
);
CREATE TABLE Classes(
	class_id int(4) primary key auto_increment,
    class_name varchar(50)
);
CREATE TABLE Students(
	student_id int(4) primary key auto_increment,
    student_name varchar(50),
    age int(4),
    emil varchar(100)
);
CREATE TABLE ClassStudent(
	student_id int(4),
    foreign key(student_id) references Students(student_id),
    class_id int(4),
    foreign key(class_id) references Classes(class_id),
    primary key(student_id,class_id)
);
CREATE TABLE Marks(
	student_id int(4),
    foreign key(student_id) references Students(student_id),
    subject_id int(4),
	foreign key(subject_id) references Subjects(subject_id),
    marks int(4)
);
INSERT INTO subjects (subject_name) VALUES 
	('SQL'),
    ('JAVA'),
    ('C'),
    ('Visual Basic');
    
INSERT INTO students (student_name,age,emil) VALUES 
	('Nguyen Quang An',18,'an@yahoo.com'),
    ('Nguyen Cong Vinh',20,'vinh@gmail.com'),
    ('Nguyen Van Quyen',19,'quyen'),
    ('Pham Thanh Binh',25,'binh@com'),
    ('Phan Van Tai Em',30,'taiem@sport.com');

INSERT INTO classes (class_name) VALUES 
    ('C0706L'),
    ('C0708G');
    
INSERT INTO classStudent (student_id,class_id) VALUES 
    (1,1),
    (2,1),
    (3,2),
    (4,2),
    (5,2);

INSERT INTO marks (student_id,subject_id,marks) VALUES 
    (1,1,8),
    (1,2,4),
    (1,1,9),
    (3,1,7),
    (4,1,3),
    (5,2,5),
    (3,3,8),
    (5,3,1),
    (4,2,3);
    
-- Hien thi danh sach tat ca cac hoc vien
select * from students;

-- Hien thi danh sach tat ca cac mon hoc
select * from subjects;

-- Tinh diem trung binh cua tat ca hoc vien
select s.student_id,s.student_name,avg(m.marks) as avg_mark 
from students s
join marks m on m.student_id=s.student_id
group by s.student_id,s.student_name;

-- Hien thi mon hoc nao co hoc sinh thi duoc diem cao nhat
select m.subject_id,s.subject_name,m.marks
from marks m
join subjects s on m.subject_id=s.subject_id
group by m.subject_id,s.subject_name,m.marks
having m.marks >= all(select marks from marks);

-- Danh so thu tu cua diem theo chieu giam
select m.subject_id,s.subject_name,st.student_name,m.marks from marks m
join subjects s on s.subject_id=m.subject_id
join students st on st.student_id=m.student_id
group by m.subject_id,s.subject_name,st.student_name,m.marks
order by marks desc;

-- Thay doi kieu du lieu cua cot SubjectName trong bang Subjects thanh nvarchar(max)
	ALTER TABLE Subjects 
    modify COLUMN subject_name varchar(16382);
    
-- Cap nhat them dong chu « Day la mon hoc « vao truoc cac ban ghi tren cot SubjectName trong bang Subjects
	select subject_id,concat('Đây là môn học ',subject_name) as subject_name from subjects;
    
-- Viet Check Constraint de kiem tra do tuoi nhap vao trong bang Student yeu cau Age >15 va Age < 50
	alter table students
	add constraint check (age > 15 and age < 50);
    
-- Loai bo tat ca quan he giua cac bang
	ALTER TABLE classstudent 
    DROP FOREIGN KEY classstudent_ibfk_1,
    DROP FOREIGN KEY classstudent_ibfk_2;
	ALTER TABLE marks 
    DROP FOREIGN KEY marks_ibfk_1,
    DROP FOREIGN KEY marks_ibfk_2;
    
-- Xoa hoc vien co StudentID la 1
	delete from students where student_id=1;
    
-- Trong bang Student them mot column Status co kieu du lieu la Bit va co gia tri Default la 1
	alter table students
    add column status bit default(1);
    
-- Cap nhap gia tri Status trong bang Student thanh 0
	update students set status = 0;