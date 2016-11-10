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

-- zad 2
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

-- zad 3
declare
  p_id_prac number;
  p_id_zesp number;
  p_nazwisko varchar(100);
  p_placa_pod number;
  PRIMARY_KEY_DUPLICATE exception;
  pragma exception_init(PRIMARY_KEY_DUPLICATE, -1);
  WORKER_ID_DOESNT_EXIST exception;
  pragma exception_init(WORKER_ID_DOESNT_EXIST, -1400);
  TOO_LOW_SALARY exception;
  pragma exception_init(TOO_LOW_SALARY, -2290);
  TEAM_DOESNT_EXIST exception;
  pragma exception_init(TEAM_DOESNT_EXIST, -2291);
begin
  p_id_prac := '&id_prac';
  p_id_zesp := &id_zesp;
  p_nazwisko := '&nazwisko';
  p_placa_pod := &placa_pod;
  insert into pracownicy (id_prac, id_zesp, nazwisko, placa_pod)
    values (p_id_prac, p_id_zesp, p_nazwisko, p_placa_pod);
exception
  when PRIMARY_KEY_DUPLICATE then  
    dbms_output.put_line('id pracownika nie jest unikalne!');
  when TOO_LOW_SALARY then
    dbms_output.put_line('płaca podstawowa musi być większa niż 101!');
  when WORKER_ID_DOESNT_EXIST then
    dbms_output.put_line('nie podano id pracownika, które jest wymagane!');
  when TEAM_DOESNT_EXIST then
    dbms_output.put_line('podany zespół nie istnieje!');
end;
/

-- zad 4
declare
  p_nazwisko varchar(100);
  p_count number;
  SUPERIOR exception;
  pragma exception_init(SUPERIOR, -2292);
begin
  p_nazwisko := '&nazwisko';
  select count(*) into p_count from pracownicy where nazwisko = p_nazwisko;
  if p_count = 0 then
    raise_application_error(-20020, 'Nie istnieje taki pracownik');
  elsif p_count > 1 then
    raise_application_error(-20030, 'Niejednoznaczne wskazanie pracownika');
  else
  	delete from pracownicy where nazwisko = p_nazwisko;
  end if;
exception
  when SUPERIOR then
    raise_application_error(-20040, 'Nie możesz usunąć przełożonego');
end;
/
