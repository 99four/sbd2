-- zad 1
declare
  cursor c_pracownicy(time_job pracownicy.etat%type) is
    select nazwisko
    from pracownicy
    where etat = time_job
    order by nazwisko;
  v_etat pracownicy.etat%type := '&etat';
begin
  SELECT NAZWA INTO v_etat FROM ETATY where NAZWA = v_etat;
  for pracownik in c_pracownicy(v_etat) loop
    sys.dbms_output.put_line(pracownik.nazwisko);
  end loop;
EXCEPTION
  WHEN no_data_found THEN
  dbms_output.put_line('Nie istnieje etat o nazwie ' || v_etat);
end;
/

--zad 2
declare
  cursor c_szefowie is 
	select s.id_prac, s.nazwisko as szef, s.placa_pod as placa_szefa,
	sum(p.placa_pod) as placa_podwladnych
	from pracownicy s join pracownicy p on s.id_prac = p.id_szefa 
	where s.etat = 'PROFESOR'
	group by s.id_prac, s.nazwisko, s.placa_pod;
begin
    for szef in c_szefowie
    loop
    	sys.dbms_output.put_line('szef to ' || szef.szef);
    	if ((szef.placa_szefa + 0.1 * szef.placa_podwladnych) > 2000)
    	then
    		RAISE_APPLICATION_ERROR(-20010, 'Pensja po podwyżce przekroczyłaby 2000!');
    	else
    		update pracownicy
    		set placa_pod = placa_pod + 0.1 * szef.placa_podwladnych
    		where ID_PRAC = szef.id_prac;
		end if;
    end loop;
end;
/
