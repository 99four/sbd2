-- zad 1
CREATE OR REPLACE PROCEDURE
  PODWYZKA(
    p_id_zesp IN NUMBER,
    p_procent_podwyzki IN NUMBER DEFAULT 15
  ) IS
BEGIN
  FOR cur_rec IN
    (SELECT ID_PRAC, NAZWISKO, PLACA_POD FROM PRACOWNICY WHERE ID_ZESP = p_id_zesp)
  LOOP
    update pracownicy set placa_pod = placa_pod + (p_procent_podwyzki / 100) * placa_pod where ID_PRAC = cur_rec.id_prac;
  END LOOP;
END PODWYZKA;
/

-- zad 2
CREATE OR REPLACE PROCEDURE
  PODWYZKA(
    p_id_zesp IN NUMBER,
    p_procent_podwyzki IN NUMBER DEFAULT 15
  ) AS p_count NUMBER;
BEGIN
  SELECT COUNT(*) into p_count FROM PRACOWNICY WHERE ID_ZESP = p_id_zesp;
  if p_count = 0 then
    RAISE_APPLICATION_ERROR(-20010, 'Brak zespolu o podanym numerze!');
  ELSE
    FOR cur_rec IN
      (SELECT ID_PRAC, NAZWISKO, PLACA_POD FROM PRACOWNICY WHERE ID_ZESP = p_id_zesp)
    LOOP
      update pracownicy set placa_pod = placa_pod + (p_procent_podwyzki / 100) * placa_pod where ID_PRAC = cur_rec.id_prac;
    END LOOP;
  END IF;
END PODWYZKA;
/

-- zad 3
CREATE OR REPLACE PROCEDURE LICZBA_PRACOWNIKOW (
    P_TEAM_NAME IN ZESPOLY.NAZWA%TYPE,
    P_WORKERS_COUNTER OUT NUMBER
) IS
CURSOR C_PRACOWNICY IS
SELECT * FROM PRACOWNICY P INNER JOIN ZESPOLY Z ON P.ID_ZESP = Z.ID_ZESP
WHERE Z.NAZWA = P_TEAM_NAME;
V_HAS_ROWS BOOLEAN := FALSE;
BEGIN
    P_WORKERS_COUNTER := 0;
    FOR PRACOWNIK IN C_PRACOWNICY
    LOOP
        V_HAS_ROWS := TRUE;
        P_WORKERS_COUNTER := P_WORKERS_COUNTER  + 1;
    END LOOP;

    IF V_HAS_ROWS = FALSE THEN
        RAISE NO_DATA_FOUND;
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('Nie znaleziono pracownikow dla danej nazwy zespolu: ' || P_TEAM_NAME);
END;

--zad 4
CREATE OR REPLACE PROCEDURE NOWY_PRACOWNIK (
    P_NAZWISKO IN PRACOWNICY.NAZWISKO%TYPE,
    P_NAZWA_ZESP IN ZESPOLY.NAZWA%TYPE,
    P_NAZWISKO_SZEFA IN PRACOWNICY.NAZWISKO%TYPE,
    P_PLACA_POD IN PRACOWNICY.PLACA_POD%TYPE,
    P_ZATRUDNIONY IN PRACOWNICY.ZATRUDNIONY%TYPE DEFAULT SYSDATE,
    P_ETAT IN PRACOWNICY.ETAT%TYPE DEFAULT 'STAZYSTA'
) IS
TEAM_NOT_FOUND EXCEPTION;
WORKER_NOT_FOUND EXCEPTION;
V_ID_ZESP ZESPOLY.ID_ZESP%TYPE;
V_ID_SZEFA PRACOWNICY.ID_PRAC%TYPE;
V_ID_PRAC PRACOWNICY.ID_PRAC%TYPE;
V_COUNT NUMBER;
BEGIN 
    SELECT COUNT(*) INTO V_COUNT
    FROM ZESPOLY
    WHERE NAZWA=P_NAZWA_ZESP;

    IF V_COUNT = 0 THEN
        RAISE TEAM_NOT_FOUND;
    END IF;

    SELECT COUNT(*) INTO V_COUNT
    FROM PRACOWNICY
    WHERE NAZWISKO = P_NAZWISKO_SZEFA;

    IF V_COUNT = 0 THEN
        RAISE WORKER_NOT_FOUND;
    END IF;

    SELECT ID_ZESP INTO V_ID_ZESP
    FROM ZESPOLY
    WHERE NAZWA=P_NAZWA_ZESP;

    SELECT ID_PRAC INTO V_ID_SZEFA
    FROM PRACOWNICY
    WHERE NAZWISKO = P_NAZWISKO_SZEFA;

    SELECT MAX(ID_PRAC) + 1 INTO V_ID_PRAC
    FROM PRACOWNICY;

    INSERT INTO PRACOWNICY (ID_PRAC, NAZWISKO, ETAT, ID_SZEFA, ZATRUDNIONY, PLACA_POD, ID_ZESP)
    VALUES (V_ID_PRAC, P_NAZWISKO, P_ETAT, V_ID_SZEFA, P_ZATRUDNIONY, P_PLACA_POD, V_ID_ZESP);

    EXCEPTION
    WHEN TEAM_NOT_FOUND THEN
        dbms_output.put_line('Nie znaleziono zespolu');
    WHEN WORKER_NOT_FOUND THEN
        dbms_output.put_line('Nie znaleziono szefa');
END;

-- zad 5
create or replace function placa_netto (
    brutto in number,
    podatek in number default 20
) return number is
begin
    return (100 * brutto) / (100 + podatek);
end;

-- zad 6
create or replace function silnia (
    n in number
) return number is
v_factorial number := 1;
begin 
    if n = 0 then
        return 1;
    end if;

    for i in 1..n
    loop
        v_factorial := v_factorial * i;
    end loop; 

    return v_factorial;
end;


-- zad 7
create or replace function silnia (
    n in number
) return number is
v_factorial number := 1;
begin 
    if n = 0 then
        return 1;
    end if;

    return n * silnia(n-1);
end;


-- zad 8
create or replace function staz (
    p_hired in date
) return number is
begin
    return floor(months_between(sysdate, p_hired) /12);
end;

