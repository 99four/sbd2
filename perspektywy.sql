--zad 1
CREATE OR REPLACE VIEW ASYSTENCI (ID, NAZWISKO, PLACA, STAŻ_PRACY) AS
SELECT id_prac, nazwisko, placa_pod + nvl(placa_dod, 0),
'lat: '|| EXTRACT(year FROM (SYSDATE - ZATRUDNIONY) YEAR TO MONTH) 
|| ' miesięcy: ' ||
EXTRACT(MONTH FROM (SYSDATE - ZATRUDNIONY) YEAR TO MONTH)
FROM pracownicy
WHERE ETAT='ASYSTENT';

--zad 2
create or replace view place (id_zesp, srednia, minimum, maximum, fundusz, l_pensji, l_dodatkow)
	as select p.id_zesp, 
avg(p.placa_pod + nvl(p.placa_dod, 0)), 
min(p.placa_pod + nvl(p.placa_dod, 0)), 
max(p.placa_pod + nvl(p.placa_dod, 0)),
sum(p.placa_pod + nvl(p.placa_dod, 0)),
count(p.placa_pod),
count(p.placa_dod)
from pracownicy p 
join zespoly z
on p.id_zesp = z.id_zesp 
group by p.id_zesp order by p.id_zesp;

--zad 3
select w.nazwisko, w.placa_pod 
from place p join pracownicy w on p.id_zesp = w.id_zesp 
where w.placa_pod + nvl(w.placa_dod, 0) < p.srednia 
order by w.nazwisko;

--zad 4
create or replace view place_minimalne as
select id_prac, nazwisko, etat, placa_pod 
from pracownicy where placa_pod < 700
with check OPTION constraint za_wysoka_placa;

--zad 5
update place_minimalne set placa_pod = 800 where nazwisko = 'HAPKE';
--output: update place_minimalne set placa_pod = 800 where nazwisko = 'HAPKE'
--BŁĄD w linii 1: 
--ORA-01402: naruszenie klauzuli WHERE dla perspektywy z WITH CHECK OPTION 

--zad 6
create or replace view prac_szef as
select id_prac, id_szefa, nazwisko as pracownik, etat,
(select nazwisko from pracownicy where id_prac = p.id_szefa)
as szef
from pracownicy p;

--zad 7
create or replace view zarobki as
select id_prac, nazwisko, etat, placa_pod
from pracownicy p
where
(select placa_pod from pracownicy where id_prac = p.id_szefa)
>
p.placa_pod
with check option constraint too_high_salary;

--zad 8
select column_name, updatable, insertable, deletable
from USER_UPDATABLE_COLUMNS
where table_name = 'PRAC_SZEF';

--zad 9
SELECT ROWNUM, T.rnum, T.nazwisko, T.etat, T.pensja
FROM (
SELECT ROWNUM AS rnum,
nazwisko, etat, placa_pod AS pensja
FROM pracownicy ORDER BY pensja DESC ) T
WHERE ROWNUM < 4;

--zad 10
SELECT Z.rnm as ranking, Z.nazwisko, Z.placa_pod, Z.etat FROM (
	SELECT ROWNUM as rnm, T.rnum, T.nazwisko, T.etat, T.placa_pod
	FROM (
		SELECT ROWNUM AS rnum,
		nazwisko, etat, placa_pod
		FROM pracownicy ORDER BY placa_pod DESC 
	) T
	WHERE ROWNUM <= 10
	ORDER BY T.placa_pod ASC
) Z 
WHERE ROWNUM <= 5
ORDER BY Z.placa_pod DESC;

