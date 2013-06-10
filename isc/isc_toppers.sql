begin;

create temporary table s (
       subject	       text,
       mean	       float,
       sd	       float,
       primary key (subject)
);

insert into s
(subject,mean,sd)
(select
subject,
avg(score::float) as mean,
stddev_pop(score::float) as sd
from isc.scores
where score not in ('XXX','PCA  *','PCNA *','ABS  *','SPCA *','SPCNA*','A','B','C','D','X')
group by subject
having count(*)>=1000
);

select
st.student_name as name,
st.result_id,
--st.school_name as school,
--sc.result_id,
avg((sc.score::float-s.mean)/s.sd)::numeric(4,2) as n_mean
from isc.scores sc
join s on (s.subject)=(sc.subject)
join isc.students st on (st.result_id)=(sc.result_id)
where sc.subject not in ('Result','SUPW')
and sc.score not in ('X','XXX')
group by name,st.result_id
having count(*)>=5
order by n_mean desc
limit 10;

commit;

