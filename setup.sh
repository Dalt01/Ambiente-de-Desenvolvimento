#!/bin/bash

# Função para verificar se o docker está instalado
check_docker() {
    if ! command -v docker &> /dev/null; then
        echo "Docker não está instalado. Instalando Docker..."
        install_docker
    else
        echo "Docker já está instalado."
    fi
}

# Função para instalar o docker
install_docker() {
    # Instala o Docker
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    # Adiciona o usuário ao grupo docker para executar comandos Docker sem sudo
    sudo usermod -aG docker $USER
    # Instala o Docker Compose
    sudo apt-get install -y docker-compose
}

# Verifiqua se o docker está instalado
check_docker

# Cria um dockerfile
cat <<EOF > Dockerfile
FROM node:latest
WORKDIR /app
COPY . .
RUN npm install express
CMD ["node", "index.js"]
EOF

# Cria um script Node.js para gerar o projeto Express
cat <<EOF > generate_express_project.js
const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.send('Hello World!');
});

app.listen(port, () => {
  console.log(\`Servidor Express iniciado em http://localhost:\${port}\`);
});
EOF

# Cria um script index.js para iniciar o servidor Express
cat <<EOF > index.js
const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.send('Hello World!');
});

app.listen(port, () => {
  console.log(\`Servidor Express iniciado em http://localhost:\${port}\`);
});
EOF

# Compila o projeto Express
docker build -t my-express-app .

# Inicia o contêiner Docker
docker run -p 3000:3000 my-express-app
