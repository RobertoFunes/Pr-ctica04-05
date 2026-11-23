-- Reemplaza o amplía este script con las tablas que necesites exportar para regenerar el grupo de RelaX desde la base.

SELECT 'group: uif_proyecto';
SELECT '';
SELECT 'desglose_norm = {';
SELECT '  id_reporte:number, renglon:number, descripcion:string, monto:number';
SELECT '  ' || id_reporte || ', ' || renglon || ', ''' || descripcion || ''', ' || monto
FROM desglose_norm;
SELECT '}';