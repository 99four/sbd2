--zad 1
CREATE VIEW ASYSTENCI (ID, NAZWISKO, PLACA, STAŻ_PRACY) AS
SELECT id_prac, nazwisko, placa_pod + nvl(placa_dod, 0),
'lat: '|| EXTRACT(year FROM (SYSDATE - ZATRUDNIONY) YEAR TO MONTH) 
|| ' miesięcy: ' ||
EXTRACT(MONTH FROM (SYSDATE - ZATRUDNIONY) YEAR TO MONTH)
FROM pracownicy
WHERE ETAT='ASYSTENT';

--zad 2
create view place (id_zesp, srednia, minimum, maximum, fundusz, l_pensji, l_dodatkow)
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









