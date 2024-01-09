-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 30-Nov-2023 às 23:14
-- Versão do servidor: 10.4.24-MariaDB
-- versão do PHP: 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `atv`
--

-- --------------------------------------------------------

--
-- Estrutura da tabela `estudante`
--

CREATE TABLE `estudante` (
  `ra` int(11) NOT NULL,
  `email` varchar(30) DEFAULT NULL,
  `idPessoa` int(11) DEFAULT NULL,
  `idRep` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `estudante`
--

INSERT INTO `estudante` (`ra`, `email`, `idPessoa`, `idRep`) VALUES
(10, 'Fernanda@gmail.com', 1, NULL),
(11, 'ana@gmail.com', 2, 21),
(13, 'julia@gmail.com', 4, 21),
(14, 'miguel@gmail.com', 5, 22);

--
-- Acionadores `estudante`
--
DELIMITER $$
CREATE TRIGGER `before_insert_estudante` BEFORE INSERT ON `estudante` FOR EACH ROW BEGIN
    IF NEW.idPessoa IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Não é possível inserir um Estudante sem uma Pessoa correspondente.';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `fonepessoa`
--

CREATE TABLE `fonepessoa` (
  `idPessoa` int(11) DEFAULT NULL,
  `ddd` varchar(3) NOT NULL,
  `prefixo` char(4) NOT NULL,
  `nro` char(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `fonepessoa`
--

INSERT INTO `fonepessoa` (`idPessoa`, `ddd`, `prefixo`, `nro`) VALUES
(1, '11', '4002', '8922'),
(2, '11', '9876', '5432'),
(3, '21', '8765', '4321'),
(5, '41', '6543', '2109'),
(6, '51', '5432', '1098'),
(7, '55', '9876', '5432');

-- --------------------------------------------------------

--
-- Estrutura da tabela `pessoa`
--

CREATE TABLE `pessoa` (
  `idPessoa` int(11) NOT NULL,
  `nome` varchar(40) DEFAULT NULL,
  `endereco` varchar(40) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `pessoa`
--

INSERT INTO `pessoa` (`idPessoa`, `nome`, `endereco`) VALUES
(1, 'Fernanda', 'Rua Aeronautas, 14 - Casa 02'),
(2, 'Ana', 'Rua Flores, 22'),
(3, 'Carlos', 'Nova rua, 456'),
(4, 'Julia', 'Travessa das Árvores, 45'),
(5, 'Miguel', 'Alameda dos Lagos, 789'),
(6, 'Isabela', 'Rua das Pedras, 67'),
(7, 'Fernanda', 'Rua das Flores, 123');

--
-- Acionadores `pessoa`
--
DELIMITER $$
CREATE TRIGGER `after_delete_pessoa` AFTER DELETE ON `pessoa` FOR EACH ROW BEGIN
    DELETE FROM FonePessoa
    WHERE idPessoa = OLD.idPessoa;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_update_pessoa` AFTER UPDATE ON `pessoa` FOR EACH ROW BEGIN
    UPDATE Estudante
    SET email = CONCAT(NEW.nome, '@gmail.com')
    WHERE idPessoa = NEW.idPessoa;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_delete_pessoa` BEFORE DELETE ON `pessoa` FOR EACH ROW BEGIN
    DECLARE est_count INT;
    SELECT COUNT(*) INTO est_count
    FROM Estudante
    WHERE idPessoa = OLD.idPessoa;

    IF est_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Não é possível eliminar Pessoa com registos de Estudante associados';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_insert_pessoa` BEFORE INSERT ON `pessoa` FOR EACH ROW BEGIN
    IF LENGTH(NEW.nome) > 30 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'O comprimento do nome excede o limite de 30 caracteres';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `republica`
--

CREATE TABLE `republica` (
  `idRep` int(11) NOT NULL,
  `nome` varchar(30) DEFAULT NULL,
  `endereco` varchar(40) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `republica`
--

INSERT INTO `republica` (`idRep`, `nome`, `endereco`) VALUES
(20, 'Osasco', 'Rua dos Aeronautas, 1968'),
(21, 'São Paulo', 'Avenida das Palmeiras, 987'),
(22, 'Rio de Janeiro', 'Praça da Liberdade, 321'),
(23, 'Belo Horizonte', 'Alameda das Rosas, 654'),
(24, 'Curitiba', 'Rua dos Pinheiros, 789'),
(25, 'Porto Alegre', 'Avenida das Hortênsias, 987'),
(26, 'Campinas', 'Rua das Palmas, 987');

--
-- Acionadores `republica`
--
DELIMITER $$
CREATE TRIGGER `after_update_republica` AFTER UPDATE ON `republica` FOR EACH ROW BEGIN
    UPDATE Estudante
    SET endereco = NEW.endereco
    WHERE idRep = NEW.idRep;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_delete_republica` BEFORE DELETE ON `republica` FOR EACH ROW BEGIN
    DECLARE est_count INT;
    SELECT COUNT(*) INTO est_count
    FROM Estudante
    WHERE idRep = OLD.idRep;

    IF est_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Não é possível excluir Republica com registros de Estudante associados';
    END IF;
END
$$
DELIMITER ;

--
-- Índices para tabelas despejadas
--

--
-- Índices para tabela `estudante`
--
ALTER TABLE `estudante`
  ADD PRIMARY KEY (`ra`),
  ADD KEY `idRep` (`idRep`),
  ADD KEY `idPessoa` (`idPessoa`);

--
-- Índices para tabela `fonepessoa`
--
ALTER TABLE `fonepessoa`
  ADD PRIMARY KEY (`ddd`,`prefixo`,`nro`),
  ADD KEY `idPessoa` (`idPessoa`);

--
-- Índices para tabela `pessoa`
--
ALTER TABLE `pessoa`
  ADD PRIMARY KEY (`idPessoa`);

--
-- Índices para tabela `republica`
--
ALTER TABLE `republica`
  ADD PRIMARY KEY (`idRep`);

--
-- AUTO_INCREMENT de tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `pessoa`
--
ALTER TABLE `pessoa`
  MODIFY `idPessoa` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Restrições para despejos de tabelas
--

--
-- Limitadores para a tabela `estudante`
--
ALTER TABLE `estudante`
  ADD CONSTRAINT `estudante_ibfk_1` FOREIGN KEY (`idRep`) REFERENCES `republica` (`idRep`),
  ADD CONSTRAINT `estudante_ibfk_2` FOREIGN KEY (`idPessoa`) REFERENCES `pessoa` (`idPessoa`);

--
-- Limitadores para a tabela `fonepessoa`
--
ALTER TABLE `fonepessoa`
  ADD CONSTRAINT `fonepessoa_ibfk_1` FOREIGN KEY (`idPessoa`) REFERENCES `pessoa` (`idPessoa`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
