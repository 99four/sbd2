--zad 1
DECLARE
  v_tekst VARCHAR(50) := 'Witaj, świecie!';
  v_liczba NUMBER(10,3) := 1000.456;
BEGIN
  dbms_output.put_line('Zmienna v_tekst: ' || v_tekst);
  dbms_output.put_line('Zmienna v_liczba: ' || v_liczba);
END;

--zad 2
DECLARE
  v_tekst VARCHAR(100) := 'Witaj, świecie! ';
  v_liczba NUMBER(20,3) := 1000.456;
BEGIN
  v_tekst := v_tekst || ' Witaj nowy dniu!';
  v_liczba := v_liczba + POWER(10, 15);

  dbms_output.put_line('Zmienna v_tekst: ' || v_tekst);
  dbms_output.put_line('Zmienna v_liczba: ' || v_liczba);
END;

--zad 3
DECLARE
  num1 NUMBER(20,9) := &num1input;
  num2 NUMBER(20,9) := &num2input;
BEGIN
  dbms_output.put_line('Wynik dodawania: ' || num1 || ' i ' || num2 || ': ' || (num1 + num2));
END;

--zad 4
DECLARE
  PI CONSTANT NUMBER(10, 2) := 3.14;
  radius NUMBER(10, 2) := &r;
BEGIN
  dbms_output.put_line('Obwód koła o promieniu równym: ' || radius || ': ' || (2 * PI * radius));
  dbms_output.put_line('Pole koła o promieniu równym: ' || radius || ': ' || (PI * POWER(radius, 2)));
END;

--zad 5
DECLARE
  v_nazwisko PRACOWNICY.NAZWISKO%TYPE;
  v_etat PRACOWNICY.ETAT%TYPE;
BEGIN
  SELECT nazwisko, etat INTO v_nazwisko, v_etat
  FROM PRACOWNICY
  WHERE PLACA_POD=(SELECT MAX(PLACA_POD) FROM PRACOWNICY);

  dbms_output.put_line('Najlepiej zarabia pracownik ' || v_nazwisko);
  dbms_output.put_line('Pracuje on jako: ' || v_etat);
END;

--zad 6
DECLARE
  v_pracownik PRACOWNICY%ROWTYPE;
BEGIN
  SELECT * INTO v_pracownik
  FROM PRACOWNICY
  WHERE PLACA_POD=(SELECT MAX(PLACA_POD) FROM PRACOWNICY);

  dbms_output.put_line('Najlepiej zarabia pracownik ' || v_pracownik.nazwisko);
  dbms_output.put_line('Pracuje on jako ' || v_pracownik.etat);
END;

--zad 7


--zad 8
DECLARE
  v_choice VARCHAR(4) := '&choice';
  v_time VARCHAR(10);
BEGIN
  IF (v_choice = 'TIME') THEN
    SELECT to_char(CURRENT_TIMESTAMP, 'HH24:MI:SS' ) INTO v_time FROM DUAL;
    dbms_output.put_line(v_time);
  ELSIF (v_choice = 'DATE') THEN
    dbms_output.put_line(SYSDATE());
  ELSE
    dbms_output.put_line('Nie rozpoznano wyboru!');
  END IF;
END;

--zad 9
DECLARE
  v_choice VARCHAR(4) := '&choice';
  v_time VARCHAR(10);
BEGIN
  CASE v_choice
    WHEN 'TIME' THEN
      SELECT to_char(CURRENT_TIMESTAMP, 'HH24:MI:SS' ) INTO v_time FROM DUAL;
      dbms_output.put_line(v_time);
    WHEN 'DATE' THEN
      dbms_output.put_line(SYSDATE());
    ELSE
      dbms_output.put_line('Nie rozpoznano wyboru!');
    END CASE;
END;

--zad 10
DECLARE
  v_second VARCHAR(2);
BEGIN
  LOOP
    SELECT to_char(CURRENT_TIMESTAMP, 'SS' ) INTO v_second FROM DUAL;
    IF v_second = '25' THEN
      dbms_output.put_line('Nadeszła 25 sekunda!');
      EXIT;
    END IF;
  END LOOP;
END;

--zad 11
DECLARE
  v_num NUMBER(32) := &input;
  v_silnia NUMBER(32) := 1;
BEGIN
  IF v_num = 0 OR v_num = 1 THEN
    dbms_output.put_line('Silnia dla n=' || v_num || ': '  || v_silnia);
  ELSE
    FOR i IN 1 .. v_num LOOP
      v_silnia := v_silnia * i;
    END LOOP;
  END IF;
  dbms_output.put_line('Silnia dla n=' || v_num || ': '  || v_silnia);
END;

--zad 12
DECLARE
  v_startDate DATE := '2000-01-01';
  v_endDate DATE := '2100-12-31';
  v_dayOfWeek NUMBER;
  v_dayOfMonth NUMBER;
BEGIN
  LOOP
    SELECT to_char (v_startDate, 'D') D INTO v_dayOfWeek FROM dual;
    IF v_dayOfWeek = 5 and (EXTRACT(DAY FROM v_startDate) = 13) THEN
      dbms_output.put_line('Piatek 13 to: ' || v_startDate);
    END IF;
    IF v_startDate = v_endDate THEN
      EXIT;
    END IF;
    
    v_startDate := v_startDate + 1;
  END LOOP;
END;
