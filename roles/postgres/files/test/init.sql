-- удаляем таблицы, чтобы далее создать их с нуля
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
  polls_id INTEGER REFERENCES pollss(id),
  question_id INTEGER REFERENCES questions(id),
  PRIMARY KEY (student_id, polls_id, question_id)
);

-- 1. Создать студента
-- 2. Создать курсы
-- 3. Привязать курсы к студенту
-- 4. Создать новый опрос
-- 5. Привязать к опросу вопросы и ответы
-- 6. Пройти свой же опрос для теста

INSERT INTO students(name) VALUES ('dmitry'), ('sergey'), ('alex');
INSERT INTO courses(name) VALUES ('devops'), ('cv'), ('nlp');
INSERT INTO courses_students (student_id,course_id) VALUES (1,1), (1,2), (2,2), (2,3), (3,1);

-- function get_student_with_courses_lf (limit, offset, like_course)
-- CREATE OR REPLACE FUNCTION get_student_with_courses_lf(INTEGER, INTEGER, text)
-- RETURNS o_students_with_courses[] LANGUAGE plpgsql AS $$
-- DECLARE
-- vLimit ALIAS FOR $1;
-- vOffset ALIAS for $2;
-- likeCourse ALIAS for $3;
-- outStudentsWithCourses o_students_with_courses[];
-- BEGIN
--   select into outStudentsWithCourses students.*,
--   --json_agg(json_build_object('id', courses.id, 'name', courses.name)) AS courses
--   ARRAY_AGG (courses.name) as cnames
--   FROM courses
--   LEFT OUTER JOIN courses_students
--   ON courses.id = courses_students.course_id
--   LEFT OUTER JOIN students
--   ON courses_students.student_id = students.id
--   where courses.name like likeCourse
--   GROUP BY students.id
--   limit vLimit
--   offset vOffset;
--   RETURN outStudentsWithCourses;
-- END;
-- $$;
--select get_student_with_courses_lf(128, 0, 'cv');
