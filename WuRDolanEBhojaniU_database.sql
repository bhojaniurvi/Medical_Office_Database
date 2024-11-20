DROP DATABASE IF EXISTS doc_office;
CREATE DATABASE doc_office;
USE doc_office;

CREATE TABLE department (
  dept_id INT PRIMARY KEY,
  dept_name VARCHAR(64) NOT NULL
);

CREATE TABLE physician (
  physician_id INT AUTO_INCREMENT PRIMARY KEY,
  physician_name VARCHAR(64) NOT NULL,
  physician_type INT NOT NULL,

  CONSTRAINT fk_phys_typ FOREIGN KEY (physician_type) REFERENCES department (dept_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE insurance (
  insurance_id INT AUTO_INCREMENT PRIMARY KEY,
  company_name VARCHAR(64) NOT NULL,
  type VARCHAR(64) NOT NULL
);  

CREATE TABLE patient (
  patient_id INT AUTO_INCREMENT PRIMARY KEY,
  ssn CHAR(9) NOT NULL,
  patient_name VARCHAR(64) NOT NULL,
  address VARCHAR(64) NOT NULL,
  phone CHAR(10) NOT NULL,
  insurance_id INT DEFAULT NULL,
  
  CONSTRAINT uk_pat_ssn UNIQUE (ssn),
  CONSTRAINT fk_patient_in FOREIGN KEY (insurance_id) REFERENCES insurance (insurance_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE room (
  room_num INT PRIMARY KEY,
  floor_num INT NOT NULL
);

CREATE TABLE appointment (
  apt_id INT AUTO_INCREMENT PRIMARY KEY,
  patient INT NOT NULL,
  physician INT NOT NULL,
  room INT NOT NULL,
  date DATETIME NOT NULL,
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,
  description VARCHAR(300),
   
  CONSTRAINT uk_appointment_unique_combination UNIQUE (room, date, start_time, end_time),
  CONSTRAINT fk_apt_pcp FOREIGN KEY (physician) REFERENCES physician (physician_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_apt_pat FOREIGN KEY (patient) REFERENCES patient (patient_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_apt_room FOREIGN KEY (room) REFERENCES room (room_num) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE medication (
  med_id INT AUTO_INCREMENT PRIMARY KEY,
  med_name VARCHAR(64) NOT NULL,
  med_desc VARCHAR(200) NOT NULL
);

CREATE TABLE prescription (
  presc_id INT AUTO_INCREMENT PRIMARY KEY,
  pat INT NOT NULL,
  phys INT NOT NULL,
  med INT NOT NULL,
  
  CONSTRAINT fk_diag_pat FOREIGN KEY (pat) REFERENCES patient (patient_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_diag_phys FOREIGN KEY (phys) REFERENCES physician (physician_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_med_pat FOREIGN KEY (med) REFERENCES medication (med_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE equipment (
  equip_id INT AUTO_INCREMENT PRIMARY KEY,
  equip_name VARCHAR(64) NOT NULL,
  equip_desc VARCHAR(200) NOT NULL
);

CREATE TABLE appoint_equipment (
  apt INT NOT NULL,
  equipment INT NOT NULL,
  
  CONSTRAINT fk_apteqip_apt FOREIGN KEY (apt) REFERENCES appointment (apt_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_apteqip_equip FOREIGN KEY (equipment) REFERENCES equipment (equip_id) ON DELETE RESTRICT ON UPDATE RESTRICT
);

CREATE TABLE billing (
  apt INT NOT NULL UNIQUE,
  amount FLOAT NOT NULL,
  paid_status BIT(1),
  
  CONSTRAINT fk_bill_apt FOREIGN KEY (apt) REFERENCES appointment (apt_id) ON DELETE RESTRICT ON UPDATE RESTRICT
  );
  
INSERT INTO department VALUES
(111, 'Pediatrics'),
(222, 'Cardiology'),
(333, 'General'),
(444, 'Oncology'),
(555, 'Surgery'),
(666, 'Dermatology'),
(777, 'Neurology');

INSERT INTO physician VALUES
(1, 'Meredith Grey, MD', 111),
(2, 'Derek Shepard, MD', 222),
(3, 'Izzie Stevens, MD', 333),
(4, 'Alex Karev, MD', 444),
(5, 'Jackson Avery, MD', 555),
(6, 'Derek Eruiv, MD', 111);

INSERT INTO insurance VALUES
(1111, 'Blue Cross Blue Shield', 'PPO'),
(1222, 'Blue Cross Blue Shield', 'HMO'),
(2222, 'Aetna', 'PPO'),
(2333, 'Aetna', 'HMO'),
(3333, 'United Healthcare', 'PPO'),
(3444, 'United Healthcare', 'HMO');

INSERT INTO patient VALUES
(1234, '999999999', 'Elizabeth Smith', '9 Strawberry Lane Katy TX 83267', '1111111111', 1111),
(3456, '777777777', 'Thomas Adams', '7 Longsford Circle Burlington VT 28473', '3333333333', 2333),
(4567, '666666666', 'Abigail Lincoln', '10 Sterling Drive Fayetteville NC 38296', '4444444444', 3333),
(3345, '222222222', 'Derek Perez', '3368 Metro Drive Boston MA 02115', '5555555555', 2333),
(2323, '111111111', 'Biseh Dimitri', '1937 Big Circle Drive Nashville TN', '9999999999', 3444),
(2345, '888888888', 'Benjamin Washington', '6 Hickery Street Seattle WA 57933', '2222222222', 2222),
(2224, '877777777', 'John Franklin', '3 Raindrop Street Cheeseville WI 02948', '1222222222', 3333);

INSERT INTO room VALUES
(101, 1),
(102, 1),
(103, 1),
(104, 1),
(105, 1),
(201, 2),
(202, 2),
(203, 2),
(204, 2),
(205, 2),
(301, 3),
(302, 3),
(303, 3),
(304, 3),
(305, 3);

INSERT INTO appointment VALUES
(001, 1234, 1, 101, '2023-06-21', '12:00', '12:30', 'taking an x ray and getting injections'),
(002, 3456, 2, 102, '2023-06-21', '13:00', '14:30', 'annual checkup'),
(003, 4567, 3, 103, '2023-06-21', '12:00', '12:30', 'needed new prescriptions'),
(004, 2345, 4, 104, '2023-06-21', '13:00', '13:30', 'cancer diagnosis'),
(005, 2224, 5, 105, '2023-06-21', '13:00', '13:30', 'small skin removal');

INSERT INTO medication VALUES
(1, 'penicillin', 'antibiotic'),
(2, 'hydroxyzine', 'antihistamine'),
(3, 'fexofenadine HCL', 'antihistamine'),
(4, 'propranolol', 'beta blocker'),
(5, 'ibuprofen', 'painkiller');

INSERT INTO prescription VALUES
(001, 1234, 1, 3),
(002, 2224, 3, 1),
(003, 2345, 2, 1),
(004, 4567, 2, 2);

INSERT INTO equipment VALUES
(1, 'x-ray machine', 'to take x-ray images'),
(2, 'MRI machine', 'for MRI imaging'),
(3, 'EKG machine', 'to take EKGs'),
(4, 'Sterilizer', 'to sterilize equipment'),
(5, 'Heart monitor', 'track patient heartbeat'),
(6, 'Syringe', 'administer injection'),
(7, 'Surgical equipment', 'to perform surgical operations');

INSERT INTO appoint_equipment VALUES
(001, 1),
(001, 6),
(002, 5),
(005, 4),
(005, 7),
(005, 5);

INSERT INTO billing VALUES
(001, 200, 0),
(003, 100, 1),
(005, 200, 1);

DELIMITER //
CREATE PROCEDURE createPhysician(IN pname VARCHAR(64), IN pdept INT)
BEGIN
  DECLARE ptypeid INT;
  SELECT dept_id INTO ptypeid FROM department WHERE dept_id = pdept;

  INSERT INTO physician (physician_name, physician_type)
  VALUES (pname, ptypeid);  
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE removePhysician(IN phys_id INT)
BEGIN
  IF EXISTS (SELECT 1 FROM physician WHERE physician_id = phys_id) THEN
    DELETE FROM physician WHERE physician_id = phys_id;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Physician does not exist';
  END IF;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE readPhysician()
BEGIN
	SELECT * FROM physician;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE createInsuranceType(IN companyName VARCHAR(64), IN insuranceType VARCHAR(64))
BEGIN
  IF EXISTS (SELECT 1 FROM insurance WHERE company_name = companyName AND type = insuranceType) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insurance type already exists.';
  ELSE
    INSERT INTO insurance (company_name, type)
    VALUES (companyName, insuranceType);
  END IF;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE readInsurance()
BEGIN
	SELECT * FROM insurance;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE createPatient(IN patientSSN CHAR(9), IN patientName VARCHAR(64), IN patientAddress VARCHAR(64), IN patientPhone CHAR(10), IN patientInsuranceId INT)
BEGIN
  DECLARE insuranceExists INT;

  IF patientInsuranceId IS NOT NULL THEN
    SELECT COUNT(*) INTO insuranceExists
    FROM insurance
    WHERE insurance_id = patientInsuranceId;

    IF insuranceExists = 0 THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid insurance id.';
    END IF;
  END IF;

  INSERT INTO patient (ssn, patient_name, address, phone, insurance_id)
  VALUES (patientSSN, patientName, patientAddress, patientPhone, patientInsuranceId);
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE removePatient(IN patientId INT)
BEGIN
  DECLARE patientCount INT;

  SELECT COUNT(*) INTO patientCount
  FROM patient
  WHERE patient_id = patientId;

  IF patientCount = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid patient id';
  ELSE
    DELETE FROM patient
    WHERE patient_id = patientId;
  END IF;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE readPatient()
BEGIN
	SELECT * FROM patient;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE updatePatient(
  IN p_patient_id INT,
  IN p_ssn CHAR(9),
  IN p_patient_name VARCHAR(64),
  IN p_address VARCHAR(64),
  IN p_phone CHAR(10),
  IN p_insurance_id INT
)
BEGIN
  DECLARE patient_exists INT;
  DECLARE overlapping_count INT;
  SELECT COUNT(*) INTO patient_exists
  FROM patient
  WHERE patient_id = p_patient_id;

  IF patient_exists =  0 THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Patient does not exist';
    ELSE
      UPDATE patient
      SET patient_id = p_patient_id,
          ssn = p_ssn,
          patient_name = p_patient_name,
          address = p_address,
          phone = p_phone,
          insurance_id = p_insurance_id
      WHERE patient_id = p_patient_id;
    END IF;
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE addEquipment (IN p_equip_name VARCHAR(64), IN p_equip_desc VARCHAR(200)
)
BEGIN
  DECLARE equip_count INT;
  SELECT COUNT(*) INTO equip_count
  FROM equipment
  WHERE equip_name = p_equip_name;

  IF equip_count > 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Equipment already present.';
  ELSE
    INSERT INTO equipment (equip_name, equip_desc)
    VALUES (p_equip_name, p_equip_desc);
  END IF;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE removeEquipment (IN p_equip_id INT
)
BEGIN
  DECLARE equip_count INT;
  SELECT COUNT(*) INTO equip_count
  FROM equipment
  WHERE equip_id = p_equip_id;

  IF equip_count = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Equipment does not exist.';
  ELSE
    DELETE FROM equipment
    WHERE equip_id = p_equip_id;
  END IF;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE readEquipment()
BEGIN
	SELECT * FROM equipment;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE createMedication (IN p_med_name VARCHAR(64), IN p_med_desc VARCHAR(200)
)
BEGIN
  DECLARE med_count INT;
  SELECT COUNT(*) INTO med_count
  FROM medication
  WHERE med_name = p_med_name;

  IF med_count > 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Medication already present.';
  ELSE
    INSERT INTO medication (med_name, med_desc)
    VALUES (p_med_name, p_med_desc);
  END IF;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE readMedication()
BEGIN
	SELECT * FROM medication;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE createPrescription (
  IN p_patient_id INT,
  IN p_physician_id INT,
  IN p_med_id INT
)
BEGIN
  DECLARE patient_count INT;
  DECLARE physician_count INT;
  DECLARE medication_count INT;

  SELECT COUNT(*) INTO patient_count
  FROM patient
  WHERE patient_id = p_patient_id;

  SELECT COUNT(*) INTO physician_count
  FROM physician
  WHERE physician_id = p_physician_id;

  SELECT COUNT(*) INTO medication_count
  FROM medication
  WHERE med_id = p_med_id;

  IF patient_count = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Invalid patient.';
  ELSEIF physician_count = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Invalid physician.';
  ELSEIF medication_count = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Invalid medication.';
  ELSE
    INSERT INTO prescription (pat, phys, med)
    VALUES (p_patient_id, p_physician_id, p_med_id);
  END IF;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE updatePrescription(
  IN p_presc_id INT,
  IN p_pat INT,
  IN p_phys INT,
  IN p_med INT
)
BEGIN
  DECLARE presc_exists INT;
  DECLARE pat_exists INT;
  DECLARE phys_exists INT;
  DECLARE med_exists INT;
  
  SELECT COUNT(*) INTO presc_exists
  FROM prescription
  WHERE presc_id = p_presc_id;
  
  IF presc_exists > 0 THEN
    SELECT COUNT(*) INTO pat_exists
    FROM patient
    WHERE patient_id = p_pat;
  
    SELECT COUNT(*) INTO phys_exists
    FROM physician
    WHERE physician_id = p_phys;
  
    SELECT COUNT(*) INTO med_exists
    FROM medication
    WHERE med_id = p_med;
  
    IF pat_exists > 0 AND phys_exists > 0 AND med_exists > 0 THEN
      UPDATE prescription
      SET pat = p_pat,
          phys = p_phys,
          med = p_med
      WHERE presc_id = p_presc_id;
    ELSE
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Patient, Physician, or Medication does not exist.';
    END IF;
  ELSE
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Prescription does not exist.';
  END IF;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE readPrescription()
BEGIN
	SELECT * FROM prescription;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE createAppointment (
  IN p_patient_id INT,
  IN p_physician_id INT,
  IN p_room INT,
  IN p_date DATE,
  IN p_start_time TIME,
  IN p_end_time TIME,
  IN p_description VARCHAR(300)
)
BEGIN
  DECLARE patient_count INT;
  DECLARE physician_count INT;
  DECLARE overlapping_count INT;

  SELECT COUNT(*) INTO patient_count
  FROM patient
  WHERE patient_id = p_patient_id;

  SELECT COUNT(*) INTO physician_count
  FROM physician
  WHERE physician_id = p_physician_id;

  IF patient_count = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Patient does not exist.';
  ELSEIF physician_count = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Physician does not exist.';
  ELSE
    SELECT COUNT(*) INTO overlapping_count
    FROM appointment
    WHERE room = p_room
      AND date = p_date
      AND ((start_time >= p_start_time AND start_time < p_end_time)
           OR (end_time > p_start_time AND end_time <= p_end_time)
           OR (start_time <= p_start_time AND end_time >= p_end_time));

    IF overlapping_count > 0 THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Room already booked at this time.';
    ELSE
      INSERT INTO appointment (patient, physician, room, date, start_time, end_time, description)
      VALUES (p_patient_id, p_physician_id, p_room, p_date, p_start_time, p_end_time, p_description);
    END IF;
  END IF;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE cancelAppointment(p_apt_id INT)
BEGIN
  DECLARE apt_exists INT;
  
  SELECT COUNT(*) INTO apt_exists
  FROM appointment
  WHERE apt_id = p_apt_id;

  IF apt_exists > 0 THEN
    DELETE FROM appointment
    WHERE apt_id = p_apt_id;    
  ELSE
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Appointment doesnt exist.';
  END IF;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE updateAppointment(
  IN p_apt_id INT,
  IN p_room INT,
  IN p_appt_date DATE,
  IN p_start_time TIME,
  IN p_end_time TIME
)
BEGIN
  DECLARE apt_exists INT;
  DECLARE overlapping_count INT;
  SELECT COUNT(*) INTO apt_exists
  FROM appointment
  WHERE apt_id = p_apt_id;

  IF apt_exists > 0 THEN
    SELECT COUNT(*) INTO overlapping_count
    FROM appointment
    WHERE room = p_room
      AND DATE(date) = p_appt_date
      AND ((start_time >= p_start_time AND start_time < p_end_time)
           OR (end_time > p_start_time AND end_time <= p_end_time)
           OR (start_time <= p_start_time AND end_time >= p_end_time))
      AND apt_id <> p_apt_id;
    
    IF overlapping_count > 0 THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Appointment is overlapping with another.';
    ELSE
      UPDATE appointment
      SET date = p_appt_date,
          start_time = p_start_time,
          end_time = p_end_time,
          room = p_room
      WHERE apt_id = p_apt_id;
    END IF;
  ELSE
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Appointment does not exist.';
  END IF;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE readAppointment()
BEGIN
	SELECT * FROM appointment;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE readDepartment()
BEGIN
	SELECT * FROM department;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE createBilling(
  IN p_apt INT,
  IN p_amount FLOAT,
  IN p_paid_status BIT(1)
)
BEGIN
  DECLARE apt_exists INT;
  
  SELECT COUNT(*) INTO apt_exists
  FROM appointment
  WHERE apt_id = p_apt;
  
  IF apt_exists > 0 THEN
    INSERT INTO billing (apt, amount, paid_status)
    VALUES (p_apt, p_amount, p_paid_status);
  ELSE
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Appointment does not exist.';
  END IF;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS updateBilling;
DELIMITER //
CREATE PROCEDURE updateBilling(
  IN p_apt INT,
  IN p_paid_status BIT(1)
)
BEGIN
  UPDATE billing
  SET paid_status = p_paid_status
  WHERE apt = p_apt;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE readBilling()
BEGIN
	SELECT * FROM billing;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE addAppointmentEquipment(
  IN p_apt INT,
  IN p_equipment INT
)
BEGIN
  IF EXISTS (
    SELECT 1
    FROM appoint_equipment
    WHERE apt = p_apt AND equipment = p_equipment
  ) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Appointment has this equipment already.';
  ELSE
    INSERT INTO appoint_equipment (apt, equipment)
    VALUES (p_apt, p_equipment);
  END IF;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE removeAppointmentEquipment(
  IN p_apt INT,
  IN p_equipment INT
)
BEGIN
  IF EXISTS (
    SELECT 1 FROM appoint_equipment
    WHERE apt = p_apt AND equipment = p_equipment
  ) THEN
    DELETE FROM appoint_equipment
    WHERE apt = p_apt AND equipment = p_equipment;
  ELSE
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Appointment does not have this equipment.';
  END IF;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE fetchPhysician(IN p_phys INT)
BEGIN
	SELECT * FROM equipment WHERE p_phys = physician_id;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE fetchPatient(IN p_pat INT)
BEGIN
	SELECT * FROM patient WHERE p_pat = patient_id;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE fetchMedication(IN p_med INT)
BEGIN
	SELECT * FROM medication WHERE p_med = med_id;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE fetchAppointment(IN p_apt INT)
BEGIN
	SELECT * FROM appointment WHERE p_apt = apt_id;
END//
DELIMITER ;
