-- Criação das tabelas para o E-commerce

-- Tabela de Usuários
CREATE TABLE Usuarios (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    cpf VARCHAR(11) UNIQUE NOT NULL,
    telefone VARCHAR(15),
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('ativo', 'inativo') DEFAULT 'ativo'
);

-- Tabela de Endereços
CREATE TABLE Enderecos (
    id_endereco INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT,
    cep VARCHAR(8) NOT NULL,
    logradouro VARCHAR(100) NOT NULL,
    numero VARCHAR(10),
    complemento VARCHAR(50),
    bairro VARCHAR(50) NOT NULL,
    cidade VARCHAR(50) NOT NULL,
    estado CHAR(2) NOT NULL,
    tipo_endereco ENUM('entrega', 'cobranca', 'ambos') NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario)
);

-- Tabela de Categorias de Produtos
CREATE TABLE Categorias (
    id_categoria INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    descricao TEXT,
    categoria_pai_id INT,
    status ENUM('ativo', 'inativo') DEFAULT 'ativo',
    FOREIGN KEY (categoria_pai_id) REFERENCES Categorias(id_categoria)
);

-- Tabela de Produtos
CREATE TABLE Produtos (
    id_produto INT PRIMARY KEY AUTO_INCREMENT,
    id_categoria INT,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco_custo DECIMAL(10,2) NOT NULL,
    preco_venda DECIMAL(10,2) NOT NULL,
    quantidade_estoque INT NOT NULL,
    peso DECIMAL(5,2),
    dimensoes VARCHAR(50),
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('ativo', 'inativo') DEFAULT 'ativo',
    FOREIGN KEY (id_categoria) REFERENCES Categorias(id_categoria)
);

-- Tabela de Imagens de Produtos
CREATE TABLE Imagens_Produto (
    id_imagem INT PRIMARY KEY AUTO_INCREMENT,
    id_produto INT,
    url_imagem VARCHAR(255) NOT NULL,
    ordem INT DEFAULT 0,
    FOREIGN KEY (id_produto) REFERENCES Produtos(id_produto)
);

-- Tabela de Pedidos
CREATE TABLE Pedidos (
    id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT,
    id_endereco_entrega INT,
    data_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    status_pedido ENUM('aguardando_pagamento', 'pago', 'em_separacao', 'enviado', 'entregue', 'cancelado'),
    valor_total DECIMAL(10,2) NOT NULL,
    valor_frete DECIMAL(10,2) NOT NULL,
    codigo_rastreio VARCHAR(50),
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
    FOREIGN KEY (id_endereco_entrega) REFERENCES Enderecos(id_endereco)
);

-- Tabela de Itens do Pedido
CREATE TABLE Itens_Pedido (
    id_item_pedido INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido INT,
    id_produto INT,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES Pedidos(id_pedido),
    FOREIGN KEY (id_produto) REFERENCES Produtos(id_produto)
);

-- Tabela de Pagamentos
CREATE TABLE Pagamentos (
    id_pagamento INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido INT,
    forma_pagamento ENUM('cartao_credito', 'boleto', 'pix') NOT NULL,
    status_pagamento ENUM('pendente', 'aprovado', 'recusado', 'estornado') NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    data_pagamento DATETIME,
    codigo_transacao VARCHAR(100),
    FOREIGN KEY (id_pedido) REFERENCES Pedidos(id_pedido)
);

-- Tabela de Avaliações de Produtos
CREATE TABLE Avaliacoes (
    id_avaliacao INT PRIMARY KEY AUTO_INCREMENT,
    id_produto INT,
    id_usuario INT,
    nota INT NOT NULL CHECK (nota >= 1 AND nota <= 5),
    comentario TEXT,
    data_avaliacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pendente', 'aprovada', 'reprovada') DEFAULT 'pendente',
    FOREIGN KEY (id_produto) REFERENCES Produtos(id_produto),
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario)
);

-- Tabela de Cupons de Desconto
CREATE TABLE Cupons (
    id_cupom INT PRIMARY KEY AUTO_INCREMENT,
    codigo VARCHAR(50) UNIQUE NOT NULL,
    tipo ENUM('percentual', 'valor_fixo') NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL,
    quantidade_maxima INT,
    quantidade_utilizada INT DEFAULT 0,
    status ENUM('ativo', 'inativo') DEFAULT 'ativo'
);
