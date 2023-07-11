SELECT EV.cod_student||EV.nota||EX.DATAEX||MAT.DENUMIRE Info
FROM elearn_app_admin.evaluare ev,
elearn_app_admin.examen ex, elearn_admin.materie mat
WHERE ev.cod_examen=ex.id
AND ex.cod_materie=mat.id;

exec elearn_app_admin.proc_cdinam('select nume from student');

exec elearn_app_admin.proc_cdinam('SELECT EV.cod_student|| EV.nota||EX.DATAEX||MAT.DENUMIRE Info FROM elearn_app_admin.evaluare ev, elearn_app_admin.examen ex,elearn_app_admin.materie mat WHERE ev.cod_examen=ex.id AND ex.cod_materie=mat.id');

exec elearn_app_admin.proc_cdinam('delete from evaluare');