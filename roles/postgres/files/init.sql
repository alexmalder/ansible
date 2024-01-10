CREATE TABLE students (
  id SERIAL PRIMARY KEY,
  name VARCHAR(128) NOT NULL UNIQUE
);

CREATE TABLE courses (
  id SERIAL PRIMARY KEY,
  name VARCHAR(128) NOT NULL UNIQUE
);

CREATE TABLE courses_students (
  course_id INTEGER REFERENCES students(id),
  student_id INTEGER REFERENCES courses(id),
  CONSTRAINT courses_students_pk PRIMARY KEY(course_id, student_id)
);

INSERT INTO students(name) VALUES ('dmitry'), ('sergey'), ('alex');
INSERT INTO courses(name) VALUES ('devops'), ('cv'), ('nlp');
INSERT INTO courses_students (student_id,course_id) VALUES (1,1), (1,2), (2,2), (2,3), (3,1);

--create or replace VIEW v_courses_students AS
SELECT students.*,
--json_agg(json_build_object('id', courses.id, 'name', courses.name)) AS courses
ARRAY_AGG (courses.name) as cnames
FROM courses
LEFT OUTER JOIN courses_students
ON courses.id = courses_students.course_id
LEFT OUTER JOIN students
ON courses_students.student_id = students.id
where courses.name like 'cv'
GROUP BY students.id;

-- Create students_with_courses type
CREATE TYPE students_with_courses AS
(
  id INTEGER,
  name VARCHAR(128),
  cnames text[]
);

-- create function with
create function get_student_with_courses_lf(INTEGER, INTEGER, text)
RETURNS students_with_courses LANGUAGE plpgsql AS $$
DECLARE
vLimit ALIAS FOR $1;
vOffset ALIAS for $2;
likeCourse ALIAS for $3;
outStudentsWithCourses students_with_courses;
BEGIN
  select into outStudentsWithCourses students.*,
  ARRAY_AGG (courses.name) as cnames
  FROM courses
  LEFT OUTER JOIN courses_students
  ON courses.id = courses_students.course_id
  LEFT OUTER JOIN students
  ON courses_students.student_id = students.id
  where courses.name like likeCourse
  GROUP BY students.id
  limit vLimit
  offset vOffset;
  RETURN outStudentsWithCourses;
END;
$$;

select get_student_with_courses_lf(128, 0, 'cv');
