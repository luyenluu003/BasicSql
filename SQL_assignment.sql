/* I. CREATE TABLES */

-- faculty (Khoa trong trường)
create table faculty (
	id decimal primary key,
	name nvarchar(30) not null
);

-- subject (Môn học)
create table subject(
	id decimal primary key,
	name nvarchar(100) not null,
	lesson_quantity decimal(2,0) not null -- tổng số tiết học
);

-- student (Sinh viên)
create table student (
	id decimal primary key,
	name nvarchar(30) not null,
	gender nvarchar(10) not null, -- giới tính
	birthday date not null,
	hometown nvarchar(100) not null, -- quê quán
	scholarship decimal, -- học bổng
	faculty_id decimal not null constraint faculty_id references faculty(id) -- mã khoa
);

-- exam management (Bảng điểm)
create table exam_management(
	id decimal primary key,
	student_id decimal not null constraint student_id references student(id),
	subject_id decimal not null constraint subject_id references subject(id),
	number_of_exam_taking decimal not null, -- số lần thi (thi trên 1 lần được gọi là thi lại) 
	mark decimal(4,2) not null -- điểm
);



/*================================================*/

/* II. INSERT SAMPLE DATA */

-- subject
insert into subject (id, name, lesson_quantity) values (1, N'Cơ sở dữ liệu', 45);
insert into subject values (2, N'Trí tuệ nhân tạo', 45);
insert into subject values (3, N'Truyền tin', 45);
insert into subject values (4, N'Đồ họa', 60);
insert into subject values (5, N'Văn phạm', 45);


-- faculty
insert into faculty values (1, N'Anh - Văn');
insert into faculty values (2, N'Tin học');
insert into faculty values (3, N'Triết học');
insert into faculty values (4, N'Vật lý');


-- student
insert into student values (1, N'Nguyễn Thị Hải', N'Nữ', '1990/02/23', N'Hà Nội', 130000, 2);
insert into student values (2, N'Trần Văn Chính', N'Nam', '1992/12/24', N'Bình Định', 150000, 4);
insert into student values (3, N'Lê Thu Yến', N'Nữ', '1990/02/21',  N'TP HCM', 150000, 2);
insert into student values (4, N'Lê Hải Yến', N'Nữ', '1990/02/21',  N'TP HCM', 170000, 2);
insert into student values (5, N'Trần Anh Tuấn', N'Nam', '1990/12/20',  N'Hà Nội', 180000, 1);
insert into student values (6, N'Trần Thanh Mai', N'Nữ', '1991/08/12',  N'Hải Phòng', null, 3);
insert into student values (7, N'Trần Thị Thu Thủy', N'Nữ', '1991/01/02', N'Hải Phòng', 10000, 1);



-- exam_management
insert into exam_management values (1, 1, 1, 1, 3);
insert into exam_management values (2, 1, 2, 2, 6);
insert into exam_management values (3, 1, 3, 1, 5);
insert into exam_management values (4, 2, 1, 1, 4.5);
insert into exam_management values (5, 2, 3, 1, 10);
insert into exam_management values (6, 2, 5, 1, 9);
insert into exam_management values (7, 3, 1, 2, 5);
insert into exam_management values (8, 3, 3, 1, 2.5);
insert into exam_management values (9, 4, 5, 2, 10);
insert into exam_management values (10, 5, 1, 1, 7);
insert into exam_management values (11, 5, 3, 1, 2.5);
insert into exam_management values (12, 6, 2, 1, 6);
insert into exam_management values (13, 6, 4, 1, 10);
insert into exam_management values (14, 6, 5, 2, 7);
insert into exam_management values (15, 6, 1, 2, 7);
insert into exam_management values (16, 5, 2, 1, 2);



/*================================================*/

/* III. QUERY */


 /********* A. BASIC QUERY *********/

-- 1. Liệt kê danh sách sinh viên sắp xếp theo thứ tự:
--      a. id tăng dần ASC tăng DESC giảm
		select *
		from student
		order by id ASC
--      b. giới tính
		select *
		from student
		order by gender 
--      c. ngày sinh TĂNG DẦN và học bổng GIẢM DẦN
		select *
		from student 
		order by birthday ASC , scholarship DESC

-- 2. Môn học có tên bắt đầu bằng chữ 'T'
		select *
		from subject
		where name LIKE 'T%'

-- 3. Sinh viên có chữ cái cuối cùng trong tên là 'i'
		select *
		from student
		where name LIKE '%i'
-- 4. Những khoa có ký tự thứ hai của tên khoa có chứa chữ 'n'
		select *
		from faculty
		where name LIKE '_n%'
-- 5. Sinh viên trong tên có từ 'Thị'
		select *
		from student
		where name like N'%Thị%'
-- 6. Sinh viên có ký tự đầu tiên của tên nằm trong khoảng từ 'a' đến 'm', sắp xếp theo họ tên sinh viên
		select *
		from student 
		where name like '[a-m]%'
		order by name


-- 7. Sinh viên có học bổng lớn hơn 100000, sắp xếp theo mã khoa giảm dần
		select *
		from student
		where scholarship > 100000
		order by faculty_id DESC
-- 8. Sinh viên có học bổng từ 150000 trở lên và sinh ở Hà Nội
		select *
		from student
		where scholarship > 150000 and hometown =N'Hà Nội'
-- 9. Những sinh viên có ngày sinh từ ngày 01/01/1991 đến ngày 05/06/1992
		select *
		from student
		where birthday between '1991/01/01' and '1992/06/05'

-- 10. Những sinh viên có học bổng từ 80000 đến 150000
		select *
		from student
		where scholarship between 80000 and 150000

-- 11. Những môn học có số tiết lớn hơn 30 và nhỏ hơn 45
		select *
		from subject
		where lesson_quantity between 30 and 45

/********* B. CALCULATION QUERY *********/

-- 1. Cho biết thông tin về mức học bổng của các sinh viên, gồm: Mã sinh viên, Giới tính, Mã 
		-- khoa, Mức học bổng. Trong đó, mức học bổng sẽ hiển thị là “Học bổng cao” nếu giá trị 
		-- của học bổng lớn hơn 500,000 và ngược lại hiển thị là “Mức trung bình”.
		select id,gender,faculty_id,scholarship,IIF(scholarship > 500000, N'Học bổng cao', N'Mức trung bình') AS scholarship_level
		from student
		
		
-- 2. Tính tổng số sinh viên của toàn trường
	select count(*) as tongSinhVien
	from student

-- 3. Tính tổng số sinh viên nam và tổng số sinh viên nữ.
	select  count(*) AS tongSVnam,(select count(*) from student where gender = N'Nữ') AS tongSVnu
    from student
	where gender = 'Nam'
	
-- 4. Tính tổng số sinh viên từng khoa
	select faculty.name,count(*) as tongSVkhoa
	from faculty,student
	where faculty.id = student.faculty_id
	group by faculty.name


-- 5. Tính tổng số sinh viên của từng môn học
	select subject.name ,count(*) as tongSV
	from subject,student,exam_management
	where subject.id = exam_management.subject_id and student.id= exam_management.student_id
	group by subject.name

-- 6. Tính số lượng môn học mà sinh viên đã học
	select student.name, count(*) as tongSoLuongMonHoc
	from subject,student,exam_management
	where subject.id = exam_management.subject_id and student.id= exam_management.student_id
	group by student.name
-- 7. Tổng số học bổng của mỗi khoa	
	select faculty.name ,count(*) tongSoLuongHocBong
	from faculty, student
	where faculty.id = student.faculty_id and student.scholarship>0
	group by faculty.name

-- 8. Cho biết học bổng cao nhất của mỗi khoa
	select faculty.name , max(student.scholarship)
	from faculty,student
	where faculty.id = student.faculty_id
	group by faculty.name

-- 9. Cho biết tổng số sinh viên nam và tổng số sinh viên nữ của mỗi khoa
	select faculty.name as khoa,
			count ( case when student.gender ='Nam' Then 1 end ) as tongSVNAM,
			count ( case when student.gender =N'Nữ' Then 1 end ) as tongSVNU
	from faculty,student
	where faculty.id = student.faculty_id
	group by faculty.name

-- 10. Cho biết số lượng sinh viên theo từng độ tuổi

	select count(*) as soLuongSV ,(Year(GETDATE())-YEAR(birthday)) AS tuoi
	from student
	group by (Year(GETDATE())-YEAR(birthday))
	order by tuoi
	
	
-- 11. Cho biết những nơi nào có ít nhất 2 sinh viên đang theo học tại trường
	select hometown as diaDiem ,count(*) as soluong
	from student
	group by hometown
	having  count(*)>=2

-- 12. Cho biết những sinh viên thi lại ít nhất 2 lần
	select student.name , count( exam_management.number_of_exam_taking) as SoLanThiLaiTren2Lan
	from student ,exam_management
	where student.id = exam_management.student_id and exam_management.number_of_exam_taking>1
	group by student.id,student.name
	having count(exam_management.number_of_exam_taking)>1

-- 13. Cho biết những sinh viên nam có điểm trung bình lần 1 trên 7.0 
	select student.name, student.gender,AVG(exam_management.mark) as diemTB
	from exam_management,student
	where student.id = exam_management.student_id and student.gender='Nam' and exam_management.number_of_exam_taking=1
	group by student.id,student.name,student.gender
	having  AVG(exam_management.mark)>7

-- 14. Cho biết danh sách các sinh viên rớt ít nhất 2 môn ở lần thi 1 (rớt môn là điểm thi của môn không quá 4 điểm)
	select student.name , count(*) as soMonRot
	from exam_management,student
	where student.id = exam_management.student_id  and exam_management.number_of_exam_taking=1 and exam_management.mark<=4
	GROUP BY student.id, student.name
	HAVING COUNT(*) >= 2;

-- 15. Cho biết danh sách những khoa có nhiều hơn 2 sinh viên nam
	select faculty.name as tenKhoa , count(student.gender) as soLuongSVnam
	from student,faculty
	where student.faculty_id= faculty.id  and student.gender='Nam'
	group by faculty.name, student.gender
	having  COUNT(student.gender)>2

-- 16. Cho biết những khoa có 2 sinh viên đạt học bổng từ 200000 đến 300000
	select faculty.name as tenKhoa , count(student.id) as soLuongHocBuong 
	from student,faculty
	where student.faculty_id= faculty.id and  student.scholarship between '200000' and '300000' 
	group by faculty.name
	having count(student.id)>2
-- 17. Cho biết sinh viên nào có học bổng cao nhất
	select *
	from student
	where scholarship = (select max(scholarship) from student);


-------------------------------------------------------------------

/********* C. DATE/TIME QUERY *********/

-- 1. Sinh viên có nơi sinh ở Hà Nội và sinh vào tháng 02
	select *
	from student 
	where hometown=N'Hà Nội' and month(birthday)=2

-- 2. Sinh viên có tuổi lớn hơn 20

	select name , (Year(GETDATE())-YEAR(birthday)) as tuoi
	from student 
	where (Year(GETDATE())-YEAR(birthday)) > 20

-- 3. Sinh viên sinh vào mùa xuân năm 1990
	select name , birthday
	from student
	where year(birthday)=1990 and month(birthday) between 1 and 3


-------------------------------------------------------------------


/********* D. JOIN QUERY *********/

-- 1. Danh sách các sinh viên của khoa ANH VĂN và khoa VẬT LÝ
	select student.name , faculty.name as tenKhoa
	from student 
	join faculty on faculty.id = student.faculty_id
	where faculty.name=N'Anh - Văn' or faculty.name=N'Vật lý'
-- 2. Những sinh viên nam của khoa ANH VĂN và khoa TIN HỌC
	select student.name , faculty.name as tenKhoa
	from student 
	join faculty on faculty.id = student.faculty_id
	where (faculty.name=N'Anh - Văn' or faculty.name=N'Tin học') and gender='Nam'
-- 3. Cho biết sinh viên nào có điểm thi lần 1 môn cơ sở dữ liệu cao nhất
	select student.name , subject.name as tenMon , exam_management.mark as diem
	from student
	inner join exam_management on exam_management.student_id= student.id
	inner join subject on subject.id= exam_management.subject_id
	where  mark = (select max(mark) from exam_management join subject on subject.id= exam_management.subject_id 
					where  exam_management.number_of_exam_taking=1 and subject.name =N'Cơ sở dữ liệu')  
	and subject.name=N'Cơ sở dữ liệu'
	and exam_management.number_of_exam_taking=1
	
-- 4. Cho biết sinh viên khoa anh văn có tuổi lớn nhất.
	select student.name , (Year(GETDATE())-YEAR(birthday)) as tuoi
	from student 
	join faculty on student.faculty_id=faculty.id
	where faculty.name=N'Anh - Văn' and (Year(GETDATE())-YEAR(birthday)) = (select max(Year(GETDATE())-YEAR(birthday)) 
			from student join faculty on student.faculty_id = faculty.id 
			where faculty.name=N'Anh - Văn')
	
-- 5. Cho biết khoa nào có đông sinh viên nhất
	select faculty.name,count(student.id) as tongSVkhoa
	from faculty
	join student on faculty.id = student.faculty_id
	group by faculty.name
	having count(student.id)
		=(
			select max(tongSV) 
			from 
				(
					select count(student.id) as tongSV from faculty
					join student on faculty.id = student.faculty_id 
					group by faculty.id
				)  
				as maxTongSV
		);

-- 6. Cho biết khoa nào có đông nữ nhất
	select faculty.name,count(student.id) as tongSVkhoa
	from faculty
	join student on faculty.id = student.faculty_id
	where student.gender=N'Nữ'
	group by faculty.name

	having count(student.id)
		=(
			select max(tongSV) 
			from 
				(
					select count(student.id) as tongSV from faculty
					join student on faculty.id = student.faculty_id 
					where student.gender=N'Nữ'
					group by faculty.id
				)  
				as maxTongSV
		);
-- 7. Cho biết những sinh viên đạt điểm cao nhất trong từng môn
	select subject.name ,student.name , exam_management.mark AS diemcaonhat
	from (
		select subject_id, MAX(mark) as max_mark
		from exam_management
		group by subject_id
	) as max_marks
	join exam_management on exam_management.subject_id = max_marks.subject_id AND exam_management.mark = max_marks.max_mark
	join student on student.id = exam_management.student_id
	join subject on subject.id = exam_management.subject_id;


-- 8. Cho biết những khoa không có sinh viên học
	select faculty.name as khoaKhongCoSV
	from faculty
	join student on student.faculty_id= faculty.id
	where student.id is null

-- 9. Cho biết sinh viên chưa thi môn cơ sở dữ liệu
	select student.name as chuaThiCSDL
	from student
	join exam_management on exam_management.student_id = student.id
	join subject on subject.id = exam_management.subject_id and subject.name=N'Cơ sở dữ liệu'
	where exam_management.student_id is null 
-- 10. Cho biết sinh viên nào không thi lần 1 mà có dự thi lần 2
	
