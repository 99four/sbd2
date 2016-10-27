--zad 1
declare
  cursor c_asystenci is
    select nazwisko, zatrudniony
    from pracownicy
    where etat = 'ASYSTENT';
  v_nazwisko pracownicy.nazwisko%type;
  v_zatrudniony pracownicy.zatrudniony%type;
begin
  open c_asystenci;
  loop
    fetch c_asystenci into v_nazwisko, v_zatrudniony;
    exit when c_asystenci%notfound;
    sys.dbms_output.put_line(v_nazwisko || ' pracuje od ' || to_char(v_zatrudniony, 'DD-MM-YYYY'));
  end loop;
  close c_asystenci;
end;

--zad 2
declare
  cursor c_pracownicy is
    select nazwisko
    from pracownicy
    order by (placa_pod + nvl(placa_dod, 0)) desc;
  v_nazwisko pracownicy.nazwisko%type;
begin
  open c_pracownicy;
  loop
    fetch c_pracownicy into v_nazwisko;
    sys.dbms_output.put_line(c_pracownicy%rowcount || ' : ' || v_nazwisko);
    exit when c_pracownicy%rowcount = 3;
  end loop;
  close c_pracownicy;
end;

-- zad 3
-- przed podwyżką
select nazwisko, placa_pod from pracownicy where to_char(zatrudniony, 'D') = '1';
-- przykładowe wyjście: 
-- WEGLARZ  2491,2 (zatrudniony w poniedziałek)
-- BLAZEWICZ  1350 (zatrudniony we wtorek)
declare
  cursor c_milionerzy is
    select placa_pod
    from pracownicy
    where to_char(zatrudniony, 'D') = '1'
    for update of placa_pod;
begin
  for bogacz in c_milionerzy loop
    update pracownicy
    set placa_pod = placa_pod * 1.2
    where current of c_milionerzy;
  end loop;
end;
-- po podwyzce
select nazwisko, placa_pod from pracownicy where to_char(zatrudniony, 'D') = '1';
-- przykładowe wyjście: 
-- WEGLARZ 2989,44 (zatrudniony w poniedziałek)
-- BLAZEWICZ  1350 (zatrudniony we wtorek)

--zad 4
declare
  cursor c_pracownicy is
    select
    p.id_prac,
    p.nazwisko,
    p.etat,
    p.id_szefa,
    p.zatrudniony,
    p.placa_pod,
    p.placa_dod,    
    p.id_zesp,
    z.nazwa
    from pracownicy p
    join zespoly z on p.id_zesp = z.id_zesp
    for update;
begin
  for prac in c_pracownicy loop
    if prac.nazwa = 'ALGORYTMY'
    then
      update pracownicy
      set placa_dod = nvl(placa_dod, 0) + 100
      where current of c_pracownicy;
    elsif prac.nazwa = 'ADMINISTRACJA'
    then
      update pracownicy
      set placa_dod = nvl(placa_dod, 0) + 150
      where current of c_pracownicy;
    elsif prac.etat = 'STAZYSTA'
    then
      delete from pracownicy
      where current of c_pracownicy;
    end if;
  end loop;
end;

--zad 5
declare
  cursor c_pracownicy(time_job pracownicy.etat%type) is
    select nazwisko
    from pracownicy
    where etat = time_job
    order by nazwisko;
  v_etat pracownicy.etat%type;
begin
  v_etat := '&etat';
  for pracownik in c_pracownicy(v_etat) loop
    sys.dbms_output.put_line(pracownik.nazwisko);
  end loop;
end;

--zad 6
declare
  cursor c_etaty is
    select
      e.nazwa,
      avg(p.placa_pod + nvl(p.placa_dod, 0)) as sredniaplaca,
      sum(case when nazwisko is not null then 1 else 0 end) as liczbaprac
      from etaty e 
      left join pracownicy p
      on p.etat = e.nazwa
      group by e.nazwa;
  cursor c_pracownicy(time_job pracownicy.etat%type) is
    select nazwisko, placa_pod + nvl(placa_dod, 0) pensja
      from pracownicy
      where etat = time_job;
begin
  for v_etat in c_etaty loop
    sys.dbms_output.put_line('etat: ' || v_etat.nazwa);
    for v_prac in c_pracownicy(v_etat.nazwa) loop
      sys.dbms_output.put_line(c_pracownicy%rowcount || ' ' || v_prac.nazwisko || ', pensja: ' || v_prac.pensja);
    end loop;
    sys.dbms_output.put_line('liczba pracowników: ' || v_etat.liczbaprac);
    if v_etat.liczbaprac = 0 then
      sys.dbms_output.put_line('średnia płaca na etacie: brak');
    else
      sys.dbms_output.put_line('średnia płaca na etacie: ' || v_etat.sredniaplaca);
    end if;
  end loop;
end;
