## schema

- discipline
  - id
  - title
  - description

- course
  - id
  - title
  - position
  - discipline_id

- poll
  - id
  - course_id
  - title

- poll_instance
  - id
  - poll_id
  - group_id
  - expiration_time

- question
  - id
  - title
  - poll_id
  - type: enum[value|choise]

- choice
  - id
  - title
  - question_id

- answer_text
  - id
  - title
  - account_id
  - poll_instance_id
  - question_id

- answer_choise
  - id
  - title
  - account_id
  - poll_instance_id
  - question_id
