---7. Mostrar los trabajos que se puede ofrecer en un departamento. 
---Ordenar la lista de forma ascendente.
SELECT 
    j.job_title, 
    d.department_name, 
    d.department_id
FROM 
    hr.jobs j 
CROSS JOIN 
    hr.departments d
LEFT JOIN 
    hr.employees e ON e.job_id = j.job_id AND e.department_id = d.department_id
LEFT JOIN 
    hr.job_history jh ON jh.job_id = j.job_id AND jh.department_id = d.department_id
WHERE 
    e.job_id IS NULL 
    AND jh.job_id IS NULL
ORDER BY 
    j.job_title, d.department_name ASC;
