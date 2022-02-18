INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUES
('society_orpailleur', 'Orpailleur', 1);

INSERT INTO `addon_inventory` (`name`, `label`, `shared`) VALUES
('society_orpailleur', 'Orpailleur', 1);

INSERT INTO `jobs` (`name`, `label`) VALUES
('orpailleurs', 'Orpailleur');

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('orpailleurs', 0, 'worker', 'Recrue', 600, '', ''),
('orpailleurs', 1, 'worker2', 'Employé', 1000, '', ''),
('orpailleurs', 2, 'manager', 'Manager', 1350, '', ''),
('orpailleurs', 3, 'co-pdg', 'Adjoint', 1900, '', ''),
('orpailleurs', 4, 'boss', 'Directeur', 3000, '', '');


INSERT INTO `items` (name, label, `weight`) VALUES
('pepites', 'Pepites Or', 50),
('powder', 'Poudre Or', 50),
('lingot', 'Lingot Or', 50)
;