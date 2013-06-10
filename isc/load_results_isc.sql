begin;

create schema isc;

drop table if exists isc.students;

create table isc.students (
	result_id	      text,
	student_name	      text,
	school_name	      text,
	primary key (result_id)
);

drop table if exists isc.scores;

create table isc.scores (
	result_id	      text references isc.students(result_id),
	subject		      text,
	score		      text,
	primary key (result_id,subject)
);

copy isc.students from '/tmp/isc_students.csv' with delimiter as ',' csv quote as '"';

copy isc.scores from '/tmp/isc_scores.csv' with delimiter as ',' csv quote as '"';

commit;
