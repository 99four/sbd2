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

