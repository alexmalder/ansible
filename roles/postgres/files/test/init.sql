DROP TABLE IF EXISTS students CASCADE;
DROP TABLE IF EXISTS courses CASCADE;
DROP TABLE IF EXISTS courses_students CASCADE;
DROP TABLE IF EXISTS polls CASCADE;
DROP TABLE IF EXISTS instances CASCADE;
DROP TABLE IF EXISTS questions CASCADE;
DROP TABLE IF EXISTS answers CASCADE;

CREATE TABLE IF NOT EXISTS students (
  id SERIAL PRIMARY KEY,
  name VARCHAR(128) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS courses (
  id SERIAL PRIMARY KEY,
  name VARCHAR(128) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS courses_students (
  course_id INTEGER REFERENCES courses(id),
  student_id INTEGER REFERENCES students(id),
  PRIMARY KEY(course_id, student_id)
);

CREATE TABLE IF NOT EXISTS polls (
  id SERIAL PRIMARY KEY,
  course_id INTEGER REFERENCES courses(id)
);

CREATE TABLE IF NOT EXISTS instances (
  id SERIAL PRIMARY KEY,
  poll_id INTEGER REFERENCES polls(id)
);

CREATE TABLE IF NOT EXISTS questions (
  id SERIAL PRIMARY KEY,
  title VARCHAR(128) NOT NULL,
  has_answer_text BOOLEAN NOT NULL DEFAULT TRUE,
  poll_id INTEGER NOT NULL REFERENCES polls(id)
);

CREATE TABLE IF NOT EXISTS answers (
  title VARCHAR(128) NOT NULL,
  choise INTEGER NOT NULL,
  student_id INTEGER REFERENCES students(id),
  instance_id INTEGER REFERENCES instances(id),
  question_id INTEGER REFERENCES questions(id),
  PRIMARY KEY (student_id, instance_id, question_id)
);

INSERT INTO students(name) VALUES ('dmitry'), ('sergey'), ('alex');
INSERT INTO courses(name) VALUES ('devops'), ('cv'), ('nlp');
INSERT INTO courses_students (student_id,course_id) VALUES (1,1), (1,2), (2,2), (2,3), (3,1);

-- Create or replace o_students_with_courses type
DO $$
  BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'o_students_with_courses') THEN
      CREATE TYPE o_students_with_courses AS
      (
        id INTEGER,
        name VARCHAR(128),
        cnames text[]
      );
  END IF;
END$$;

-- Create or replace o_courses type
DO $$
  BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'o_courses') THEN
      CREATE TYPE o_courses AS
      (
        id INTEGER,
        name VARCHAR(128)
      );
  END IF;
END$$;

-- function select_courses_lf (limit, offset)
CREATE OR REPLACE FUNCTION select_courses_lf(INTEGER, INTEGER)
RETURNS o_courses[] LANGUAGE plpgsql AS $$
DECLARE
inputLimit ALIAS FOR $1;
inputOffset ALIAS FOR $2;
outCourses o_courses[];
BEGIN
  select into outCourses courses.* from courses limit inputLimit offset inputOffset;
  --select * from courses into outCourses;
  RETURN outCourses;
END;
$$;

-- function insert_course (name)
CREATE OR REPLACE FUNCTION insert_course(text)
RETURNS INTEGER LANGUAGE plpgsql AS $$
DECLARE
inputName ALIAS FOR $1;
outID INTEGER;
BEGIN
  insert into courses (id, name) values (default, inputName) returning * into outID;
  RETURN outID;
END;
$$;

-- function update_course (id, name)
CREATE OR REPLACE FUNCTION update_course(INTEGER, text)
RETURNS INTEGER LANGUAGE plpgsql AS $$
DECLARE
inputID ALIAS FOR $1;
inputName ALIAS FOR $2;
outID INTEGER;
BEGIN
  update courses set name = inputName where id = inputID returning * into outID;
  RETURN outID;
END;
$$;

-- function delete_course (id)
CREATE OR REPLACE FUNCTION delete_course(INTEGER)
RETURNS INTEGER LANGUAGE plpgsql AS $$
DECLARE
inputID ALIAS FOR $1;
outID INTEGER;
BEGIN
  delete from courses where id = inputID returning * into outID;
  RETURN outID;
END;
$$;

-- function get_student_with_courses_lf (limit, offset, like_course)
CREATE OR REPLACE FUNCTION get_student_with_courses_lf(INTEGER, INTEGER, text)
RETURNS o_students_with_courses[] LANGUAGE plpgsql AS $$
DECLARE
vLimit ALIAS FOR $1;
vOffset ALIAS for $2;
likeCourse ALIAS for $3;
outStudentsWithCourses o_students_with_courses[];
BEGIN
  select into outStudentsWithCourses students.*,
  --json_agg(json_build_object('id', courses.id, 'name', courses.name)) AS courses
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

--select get_student_with_courses_lf(128, 0, 'cv');
