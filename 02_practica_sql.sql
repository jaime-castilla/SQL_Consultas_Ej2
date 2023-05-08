--distinct

--Se quiere saber a qué paises se les vende usar la tabla de clientes
select distinct country from public.customers
--Se quiere saber a qué ciudades se les vende usar la tabla de clientes
select distinct city from public.customers
--Se quiere saber a qué ciudades se les ha enviado una orden
select distinct ship_city from public.orders
--Se quiere saber a qué ciudades se les vende en el pais USA usar la tabla de clientes
select distinct city from public.customers where country = 'USA'

--Agrupacion

--Se quiere saber a qué paises se les vende usar la tabla de clientes nota hacerla usando group by
select country from public.customers group by country
--Cuantos clientes hay por pais
select count(customer_id), country from public.customers group by country
--Cuantos clientes hay por ciudad en el pais USA
select count(customer_id), city from public.customers 
where country = 'USA' group by city 
--Cuantos productos hay por proveedor de la categoria 1
select count(product_id), supplier_id from public.products 
where category_id = 1 group by supplier_id

--Filtro con having

--Cuales son los proveedores que nos surten más de 1 producto, mostrar el proveedor mostrar la cantidad de productos
select supplier_id, count(supplier_id) from public.products 
group by supplier_id 
having count(supplier_id) > 1
--Cuales son los proveedores que nos surten más de 1 producto, mostrar el proveedor mostrar la cantidad de productos, pero únicamente de la categoria 1
select supplier_id, count(supplier_id) from public.products 
where category_id = 1
group by supplier_id 
having count(supplier_id) > 1
--CONTAR LAS ORDENES POR EMPLEADO DE LOS PAISES USA, CANADA, SPAIN (ShipCountry) MOSTRAR UNICAMENTE LOS EMPLEADOS CUYO CONTADOR DE ORDENES SEA MAYOR A 20
select employee_id, count(*) from public.orders 
where ship_country in ('USA', 'Canada', 'Spain')
group by employee_id 
having count(*) > 20 
--OBTENER EL PRECIO PROMEDIO DE LOS PRODUCTOS POR PROVEEDOR UNICAMENTE DE AQUELLOS CUYO PROMEDIO SEA MAYOR A 20
select supplier_id, avg(unit_price) from public.products 
group by supplier_id, unit_price 
having avg(unit_price) > 20
--OBTENER LA SUMA DE LAS UNIDADES EN EXISTENCIA (UnitsInStock) POR CATEGORIA, Y TOMANDO EN CUENTA UNICAMENTE LOS PRODUCTOS CUYO PROVEEDOR (SupplierID) SEA IGUAL A 17, 19, 16 DICIONALMENTE CUYA SUMA POR CATEGORIA SEA MAYOR A 300--
select category_id, sum(units_in_stock) from public.products
where supplier_id in (16, 17, 19)
group by category_id
having sum(units_in_stock) > 300
--CONTAR LAS ORDENES POR EMPLEADO DE LOS PAISES (ShipCountry) SA, CANADA, SPAIN cuYO CONTADOR SEA MAYOR A 25
select employee_id, count(order_id) from public.orders
where ship_country in ('USA', 'Canada', 'Spain')
group by employee_id
having count(order_id) > 25
----OBTENER LAS VENTAS (Quantity * UnitPrice) AGRUPADAS POR PRODUCTO (Orders details) Y CUYA SUMA DE VENTAS SEA MAYOR A 50.000
select product_id, sum(quantity * unit_price) as ventas from public.order_details
group by product_id
having sum(quantity * unit_price) > 50000


--Mas de una tabla 

--OBTENER EL NUMERO DE ORDEN, EL ID EMPLEADO, NOMBRE Y APELLIDO DE LAS TABLAS DE ORDENES Y EMPLEADOS
select O.order_id, E.employee_id, E.first_name, E.last_name 
from employees as E
inner join orders as O
on E.employee_id = O.employee_id
--OBTENER EL PRODUCTID, PRODUCTNAME, SUPPLIERID, COMPANYNAME DE LAS TABLAS DE PRODUCTOS Y PROVEEDORES (SUPPLIERS)
select p.product_id, p.product_name, s.supplier_id, s.company_name
from products as p
inner join suppliers as s
on p.supplier_id = s.supplier_id
--OBTENER LOS DATOS DEL DETALLE DE ORDENES CON EL NOMBRE DEL PRODUCTO DE LAS TABLAS DE DETALLE DE ORDENES Y DE PRODUCTOS
select p.product_name, d.order_id, d.product_id, d.unit_price, d.quantity, d.discount
from products as p
inner join order_details as d
on p.product_id = d.product_id
--OBTENER DE LAS ORDENES EL ID, SHIPPERID, NOMBRE DE LA COMPAÑÍA DE ENVIO (SHIPPERS)
select o.order_id, s.shipper_id, s.company_name
from orders as o
inner join shippers as s
on o.order_id = s.shipper_id
--Obtener el número de orden, país de envío (shipCountry) y el nombre del empleado de la tabla ordenes y empleados. Queremos que salga el Nombre y Apellido del Empleado en una sola columna.
select o.order_id, o.ship_country, concat(e.first_name , e.last_name)as nombre_completo
from orders as o
inner join employees as e
on o.employee_id = e.employee_id


--Combinando la mayoría de conceptos

--CONTAR EL NUMERO DE ORDENES POR EMPLEADO OBTENIENDO EL ID EMPLEADO Y EL NOMBRE COMPLETO DE LAS TABLAS DE ORDENES Y DE EMPLEADOS join y group by / columna calculada
select e.employee_id, e.first_name, e.last_name, count(order_id)
from employees as e
inner join orders as o
on e.employee_id = o.employee_id
group by e.employee_id
--OBTENER LA SUMA DE LA CANTIDAD VENDIDA Y EL PRECIO PROMEDIO POR NOMBRE DE PRODUCTO DE LA TABLA DE ORDERS DETAILS Y PRODUCTS
select sum(o.quantity + avg(o.unit_price))
from order_details as o
inner join products as p
on o.product_id = p.product_id
--OBTENER LAS VENTAS (UNITPRICE * QUANTITY) POR CLIENTE DE LAS TABLAS ORDER DETAILS, ORDERS
select (d.unit_price * d.quantity)as ventas, o.customer_id
from order_details as d
inner join orders as o
on d.order_id = o.order_id
--OBTENER LAS VENTAS (UNITPRICE * QUANTITY) POR EMPLEADO MOSTRANDO EL APELLIDO (LASTNAME)DE LAS TABLAS EMPLEADOS, ORDENES, DETALLE DE ORDENES
select (d.unit_price * d.quantity)as ventas, e.last_name
from order_details as d
inner join employees as e
on 

