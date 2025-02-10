create database hackathon;
use hackathon;

create table tbl_students(
	student_id int auto_increment primary key,
    student_name varchar(100) not null,
    phone varchar(20) not null unique,
    email varchar(100) not null unique,
    address varchar(255)
);

create table tbl_teachers(
	teacher_id int auto_increment primary key,
    teacher_name varchar(100) not null,
    specialization varchar(100),
    phone varchar(20) not null unique,
    email varchar(100) not null unique
);

create table tbl_courses(
	course_id int auto_increment primary key,
    course_name varchar(100) not null,
    teacher_id int,
    start_date date,
    end_date date,
    tuition_fee decimal(10,2),
    foreign key(teacher_id) references tbl_teachers(teacher_id) 
);

create table tbl_enrollments(
	enrollment_id int auto_increment primary key,
    student_id int,
    course_id int,
    enrollment_date date,
    status enum('Active', 'Completed', 'Cancelled'),
    foreign key(student_id) references tbl_students(student_id),
    foreign key(course_id) references tbl_courses(course_id)
);

create table tbl_schedules(
	schedule_id int auto_increment primary key,
    course_id int,
    teacher_id int,
    class_date datetime,
    room varchar(50),
    foreign key(course_id) references tbl_courses(course_id),
    foreign key(teacher_id) references tbl_teachers(teacher_id)
);

-- câu 2
alter table tbl_enrollments add column discount decimal(10,2);
alter table tbl_students modify column phone varchar(15);
alter table tbl_courses drop tuition_fee;

-- câu 3
insert into tbl_students(student_name, phone, email, address)
values
("Nguyen Van A", "0123458749", "nva@gmail.com", "Ha Noi"),
("Nguyen Van B", "0123458849", "nvb@gmail.com", "Sai Gon"),
("Nguyen Van C", "0123458949", "nvc@gmail.com", "Da Nang"),
("Nguyen Van D", "0123458149", "nvd@gmail.com", "Hue"),
("Nguyen Van E", "0123458249", "nve@gmail.com", "Ninh Binh");

insert into tbl_teachers(teacher_name, specialization, phone ,email)
values
("Nguyen Van F", "Mon Hoa", "0223458249", "nvf@gmail.com"),
("Nguyen Van G", "Mon Toan", "0323458249", "nvg@gmail.com"),
("Nguyen Van H", "Mon Ly", "0423458249", "nvh@gmail.com"),
("Nguyen Van I", "Mon Anh", "0523458249", "nvi@gmail.com"),
("Nguyen Van K", "Mon Van", "0623458249", "nvk@gmail.com");

insert into tbl_courses(course_name, teacher_id, start_date, end_date )
values
("Mon Hoa", 1, "1999-02-11", "2030-02-11"),
("Mon Toan", 2, "1999-02-11", "2030-02-11"),
("Mon Ly", 3, "1999-02-11", "2030-02-11"),
("Mon Anh", 4, "1999-02-11", "2030-02-11"),
("Mon Van", 5, "1999-02-11", "2030-02-11");

insert into tbl_enrollments(student_id, course_id, enrollment_date, status)
values
(1, 1, "2025-02-11", "Active"),
(1, 2, "2025-02-11", "Completed"),
(2, 3, "2025-02-11", "Active"),
(3, 4, "2025-02-11", "Active"),
(4, 5, "2025-02-11", "Cancelled");

insert into tbl_schedules(course_id, teacher_id, class_date, room)
values 
(1,1,"2025-02-11 00:00:00", "401"),
(2,2,"2025-02-11 00:00:00", "402"),
(3,3,"2025-02-11 00:00:00", "403"),
(4,4,"2025-02-11 00:00:00", "404"),
(5,5,"2025-02-11 00:00:00", "405");

-- câu 4:
-- câu 4a:
select 
	tbl_courses.course_id,
	tbl_courses.course_name,
    tbl_teachers.teacher_name,
    tbl_courses.start_date,
    tbl_courses.end_date 
from tbl_courses
join tbl_teachers on tbl_teachers.teacher_id = tbl_courses.teacher_id;

-- câu 4b:
select 
	tbl_students.student_name
from tbl_students
join tbl_enrollments on tbl_enrollments.student_id = tbl_students.student_id 
group by tbl_students.student_name;

-- câu 5a:
select 
	tbl_teachers.teacher_name,
	count(course_id) as total
from tbl_teachers
join tbl_courses on tbl_teachers.teacher_id = tbl_courses.teacher_id
group by tbl_teachers.teacher_name;

-- câu 5b:
select 
	tbl_courses.course_name,
    count(tbl_students.student_id) as total_student
from tbl_enrollments
join tbl_students on tbl_enrollments.student_id = tbl_students.student_id 
join tbl_courses on tbl_courses.course_id = tbl_enrollments.course_id
group by tbl_courses.course_name;

-- câu 6a:
select 
	tbl_students.student_name,
    count(tbl_enrollments.enrollment_id) as total_courses
from tbl_students
left join tbl_enrollments on tbl_enrollments.student_id = tbl_students.student_id 
group by tbl_students.student_name;

-- câu 6b:
select 
	tbl_students.student_name,
    count(tbl_enrollments.enrollment_id) as total_courses
from tbl_students
left join tbl_enrollments on tbl_enrollments.student_id = tbl_students.student_id 
group by tbl_students.student_name
having total_courses >= 2;

-- câu 7:
select
	tbl_courses.course_name,
    count(tbl_enrollments.student_id) as total_student
from tbl_enrollments
join tbl_students on tbl_students.student_id = tbl_enrollments.student_id 
join tbl_courses on tbl_courses.course_id = tbl_enrollments.course_id 
group by tbl_courses.course_name
order by total_student desc
limit 5;

-- câu 8:
alter table tbl_courses add column tuition_fee decimal(10,2);
select 
	tbl_students.student_name,
    sum(tuition_fee) as sum_fee
from tbl_enrollments
join tbl_courses on tbl_enrollments.course_id  = tbl_courses.course_id 
join tbl_students on tbl_students.student_id = tbl_enrollments.student_id
group by tbl_students.student_name;
-- câu 9a:
select 
	tbl_students.student_name,
    count(tbl_enrollments.student_id) as total_course
from tbl_students
join tbl_enrollments on tbl_enrollments.student_id = tbl_students.student_id 
group by tbl_students.student_name
having count(tbl_enrollments.student_id) = (select max(total_course) from tbl_enrollments);

-- câu 9b:
select 
	tbl_courses.course_name 
from tbl_enrollments
join tbl_students on tbl_enrollments.student_id = tbl_students.student_id 
join tbl_courses on tbl_courses.course_id  = tbl_enrollments.course_id  
group by tbl_courses.course_name
having count(tbl_enrollments.student_id) = (select student_id from tbl_enrollments where student_id is null)