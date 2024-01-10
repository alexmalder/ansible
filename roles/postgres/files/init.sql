CREATE TABLE students (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL UNIQUE
);


CREATE TABLE courses (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE courses_students(
  course_id INTEGER REFERENCES students(id),
  student_id INTEGER REFERENCES courses(id),
  CONSTRAINT courses_students_pk PRIMARY KEY(course_id,student_id)
);

INSERT INTO students(name) VALUES ('dmitry'), ('sergey'), ('alex');
INSERT INTO courses(name) VALUES ('devops'), ('cv'), ('nlp');
INSERT INTO courses_students (student_id,course_id) VALUES (1,1), (1,2), (2,2), (2,3), (3,1);

create or replace VIEW v_courses_students AS
SELECT students.*, 
--json_agg(json_build_object('id', courses.id, 'name', courses.name)) AS courses
ARRAY_AGG (courses.name) as cnames
FROM courses
LEFT OUTER JOIN courses_students
ON courses.id = courses_students.course_id
LEFT OUTER JOIN students
ON courses_students.student_id = students.id
GROUP BY students.id;

select id, name, cnames 
from v_courses_students 
where cnames in ('devops');


SELECT students.*, 
--json_agg(json_build_object('id', courses.id, 'name', courses.name)) AS courses
ARRAY_AGG (courses.name) as courses
FROM courses
LEFT OUTER JOIN courses_students
ON courses.id = courses_students.course_id
LEFT OUTER JOIN students
ON courses_students.student_id = students.id
GROUP BY students.id;
