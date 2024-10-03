@Autor
Laura Figueredo 202114933
@Asignatura 
Bases de Datos II
@Ingeniero
Mauro Pita
# Explicación de la consulta SQL
La consulta está diseñada para obtener una lista de todas las posibles **combinaciones de trabajos y departamentos** que no están asignadas a ningún empleado actual ni a ningún registro histórico de empleo. 
A continuación se explica el propósito de cada parte del código y por qué `WHERE e.job_id IS NULL AND jh.job_id IS NULL` es una parte importante en esta consulta.

## Desglose de la consulta:

```sql
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
```

### 1. SELECT
- `j.job_title`: El título del trabajo.
- `d.department_name`: El nombre del departamento.
- `d.department_id`: El identificador del departamento.

### 2. FROM
- `hr.jobs j`: Se selecciona la tabla de trabajos (`jobs`), alias `j`.
- `CROSS JOIN hr.departments d`: 
  - Se hace un `CROSS JOIN` entre `jobs` y `departments`. Esto genera una combinación cartesiana, es decir, cada trabajo se combina con cada departamento, resultando en todas las posibles combinaciones de trabajos y departamentos.

### 3. LEFT JOIN (primero)
- `LEFT JOIN hr.employees e ON e.job_id = j.job_id AND e.department_id = d.department_id`:
  - Se realiza un `LEFT JOIN` con la tabla `employees` (empleados) para ver si **algún empleado actual** ocupa el trabajo (`job_id`) en ese departamento (`department_id`).
  - El `LEFT JOIN` asegura que siempre se devuelvan todas las filas de la combinación de `jobs` y `departments`, pero con posibles valores `NULL` en los campos de la tabla `employees` si no existe tal relación.

### 4. LEFT JOIN (segundo)
- `LEFT JOIN hr.job_history jh ON jh.job_id = j.job_id AND jh.department_id = d.department_id`:
  - Este es otro `LEFT JOIN`, pero con la tabla `job_history`, que registra los empleos anteriores. El objetivo es ver si **algún empleado pasado** alguna vez tuvo ese trabajo en ese departamento.
  - Este `LEFT JOIN` también garantiza que siempre se muestren todas las combinaciones de `jobs` y `departments`, incluso si no hay registros en `job_history`.

### 5. WHERE
- `e.job_id IS NULL AND jh.job_id IS NULL`: 
  - Esta condición es clave porque el propósito de la consulta es encontrar combinaciones de trabajos y departamentos que **nunca han sido ocupadas por empleados actuales ni históricos**.
  - `e.job_id IS NULL` asegura que no haya un empleado actual en ese trabajo y departamento.
  - `jh.job_id IS NULL` asegura que ningún empleado en el pasado haya ocupado ese trabajo en ese departamento.
  - Por lo tanto, si ambas condiciones se cumplen (es decir, si no hay empleado actual ni histórico), la combinación de trabajo y departamento se incluirá en los resultados.

### 6. ORDER BY
- Ordena los resultados por el título del trabajo y luego por el nombre del departamento en orden ascendente.

## Ejemplo:

Si se tiene:
- 2 trabajos: `Manager` y `Developer`.
- 2 departamentos: `HR` y `IT`.

Y se hace un `CROSS JOIN`, se obtendria estas combinaciones:
1. Manager - HR
2. Manager - IT
3. Developer - HR
4. Developer - IT

Luego, los `LEFT JOIN` revisarán si alguno de esos trabajos está ocupado por empleados actuales o históricos en ese departamento. Si un empleado actual trabaja como "Manager" en "HR", esa combinación (Manager - HR) **no será incluida en los resultados** porque el `WHERE` no lo permitirá (su `e.job_id` no será `NULL`). Lo mismo aplica si el trabajo aparece en el historial de un empleado.

## Punto clave, (analogía con el **complemento** del conjunto que continen los trabajos asignados a cierto departamento )

El `WHERE e.job_id IS NULL AND jh.job_id IS NULL` es necesario para filtrar solo las combinaciones de trabajo y departamento que **nunca han sido ocupadas** por un empleado actual ni en el pasado.
