## WordPress Quick Setup Script

📂 Este repositório contém dois scripts bash:

- **wp-nginx.sh**: Automatiza a instalação e configuração do WordPress com **Nginx**, **PHP**, **MariaDB** e **WordPress**.


- **remove_all.sh**: Remove completamente o Nginx, PHP, MariaDB e WordPress, limpando dependências e arquivos de configuração.

#
 
⚠️ Estes scripts são destinados apenas para **instâncias EC2** com **Ubuntu** ou **Debian** para fins de teste. 
- Não execute em ambientes de produção ou máquinas locais (exceto em ambientes isolados, como containers ou VMs).

#

### Como usar 🛠️

#### 1. Clone o repositório:
   ```bash
   git clone https://github.com/nolascojoao/wordpress-nginx-ubuntu.git
   cd wordpress-nginx-ubuntu
   ```
#### 2. Execute o script `wp-nginx.sh`:
  ```bash
    chmod +x wp-nginx.sh
    ./wp-nginx.sh
  ```
    
#### 3. Conclua a configuração do wordpress acessando o IP público da sua instância no navegador.


<div align="center">
  <img src="https://github.com/user-attachments/assets/0969fdc0-8d4f-4dc6-bfa3-de6513be11ee"/>
</div>

#

### Alterar a senha de root do MariaDB (Opcional) 🔑

Caso queira alterar a senha de root do MariaDB após a instalação:

#### 1. Acesse o MariaDB como root:
   ```bash
   sudo mysql -u root
   ```

#### 2. Substitua `nova_senha` pela senha desejada:
```bash
ALTER USER 'root'@'localhost' IDENTIFIED BY 'nova_senha';
```

#### 3. Execute o comando FLUSH PRIVILEGES para aplicar as mudanças:
```bash
FLUSH PRIVILEGES;
```

#### 4. Saia do MariaDB:
```
EXIT;
```

#### A senha de root foi alterada. Para se autenticar novamente, use o comando:
```bash
sudo mysql -u root -p
```
O sistema solicitará a nova senha para concluir a autenticação.

#
   
### Para remover o WordPress e limpar o sistema 🧹

1. Execute o script `remove_all.sh`:
```bash
chmod +x remove_all.sh
./remove_all.sh
```
