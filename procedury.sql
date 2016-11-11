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