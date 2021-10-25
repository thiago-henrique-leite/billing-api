# Billing API

Requisitos:

- Docker

### Iniciando a Aplicação

- Para criar a aplicação, precisaremos do rails, portanto usaremos a imagem abaixo para obtermos um container rails:

- Espaço utilizado: 1.09GB

```bash
docker pull jacksonpires/ubuntu-rails-ssh 

docker run -d -P -v $(pwd):/project --name container-rails jacksonpires/ubuntu-rails-ssh

docker port container-rails 

$ 22/tcp -> 0.0.0.0:49154
$ 22/tcp -> :::49154
$ 3000/tcp -> 0.0.0.0:49153
$ 3000/tcp -> :::49153

ssh app@localhost -p 49154

- senha: app

rvm upgrade 2.4.1p111 2.7.1

rvm default 2.7.1

ruby -v
$ ruby 2.7.1p83

gem install rails:6.1.4.1
```

### Criando o projeto

```bash
rails new billing-api --api --database=postgresql --skip-webpack-install

cd billing-api/
```

##### Crie os modelos necessários

```bash
rails g model Institution name:string cnpj:string kind:string enabled:boolean

rails g model Student name:string cpf:string birthday:date gender:string phone:string payment_method:string postal_code:string state:string city:string address:string neighborhood:string address_number:string enabled:boolean

rails g model Enrollment institution:references student:references enrollment_semester:string course_name:string amount_bills:integer due_day:integer full_value:decimal discount_percentage:decimal enabled:boolean

rails g model Bill enrollment:references status:string due_date:date full_amount:decimal bill_type:string
```

##### Preparando ambiente Docker da aplicação

```bash
touch Dockerfile
touch docker-compose.yml
```

##### Adicionar ao Dockerfile

```Dockerfile
FROM ruby:2.7.1

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN mkdir /billing-api
WORKDIR /billing-api

COPY Gemfile /billing-api/Gemfile
COPY Gemfile.lock /billing-api/Gemfile.lock

RUN bundle install
RUN bundle update --bundler

COPY . /billing-api

CMD ["rails", "server", "-b", "0.0.0.0"]
```

##### Adicionar ao docker-compose.yml

- Não esqueça de trocar seu nome de usuário e senha.

```yml
version: "3.9"

services:
  db:
    image: postgres
    container_name: postgres-container
    environment:
      POSTGRES_DB: "billing-api-db"
      POSTGRES_USER: "<USUARIO>"
      POSTGRES_PASSWORD: "<SENHA_POSTGRES>"
    ports:
      - "5432:5432"
    volumes:
      - "./data/postgres:/var/lib/postgresql/data" 
    networks:
      - compose-network
      
  pgadmin:
    image: dpage/pgadmin4
    container_name: "pgadmin-container"
    environment:
      PGADMIN_DEFAULT_EMAIL: "<EMAIL>"
      PGADMIN_DEFAULT_PASSWORD: "<SENHA_PGADMIN>"
    ports:
      - "15432:80"
    depends_on:
      - db
    networks:
      - compose-network

  rails:
    build: .
    container_name: "rails-container"
    command: bundle exec rails s -p 3000 -b '0.0.0.0'
    volumes:
      - .:/billing-api
    ports:
      - "3000:3000"
    depends_on:
      - db
    networks:
      - compose-network

networks: 
  compose-network:
    driver: bridge
```

##### Verifique se os Containers estão funcionando adequadamente

```bash
docker-compose up
```

##### Configurando a conexão com o banco de dados:

- Substitua no arquivo config/database.yml o campo `default`:

```bash
  default: &default
  host: db
  adapter: postgresql
  encoding: unicode
  username: <USUARIO>
  password: "<SENHA>"
  # For details on connection pooling, see Rails configuration guide
  # https://guides.rubyonrails.org/configuring.html#database-pooling
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
```

### Criando o banco de dados:

##### Com os containers rodando, abra um novo terminal e rode o seguinte comando:

```bash
docker exec -it rails-container bash
```

##### Agora você estará no bash da sua aplicação Rails, execute os comandos abaixo:

```bash
rails db:create
rails db:migrate
```








