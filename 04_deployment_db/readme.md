# Healthcare Data Analyst Project — MySQL Database (Docker)

**healthcare-data-analyst-project**.

## 📦 Stack

- **Image**: `mysql:8.0`
- **Container name**: `healthcare-mysql`
- **Host port**: `3308` (mapped to container port `3306`)
- **Database**: `healthcare_data_analyst`
- **User**: `healthcare_admin`
- **Persistent volume**: `healthcare_mysql_data`

> ℹ️ Port `3308` is used instead of the default `3306` because another MySQL container (`mysql_db`) is already using port `3307` on this machine.

## 📄 docker-compose.yml

```yaml
services:
  mysql:
    image: mysql:8.0
    container_name: healthcare-mysql
    environment:
      MYSQL_ROOT_PASSWORD: RootPassFort123!
      MYSQL_DATABASE: healthcare_data_analyst
      MYSQL_USER: healthcare_admin
      MYSQL_PASSWORD: VotreMotDePasseFort123!
    ports:
      - "3308:3306"
    volumes:
      - healthcare_mysql_data:/var/lib/mysql

volumes:
  healthcare_mysql_data:
```

⚠️ **Security note**: Replace the example passwords with strong, unique values before using this in any real environment. Do not commit real credentials to Git — use a `.env` file instead (see [Using a `.env` file](#-using-a-env-file-recommended) below).

## 🚀 Getting Started

### 1. Start the container

```bash
docker compose up -d
```

### 2. Check that it's running

```bash
docker ps
```

You should see `healthcare-mysql` with status `Up` and port `0.0.0.0:3308->3306/tcp`.

### 3. View logs

```bash
docker compose logs -f mysql
```

### 4. Connect to the database (from the host)

```bash
mysql -h 127.0.0.1 -P 3308 -u healthcare_admin -p healthcare_data_analyst
```

### 5. Connect via the container directly

```bash
docker exec -it healthcare-mysql mysql -u healthcare_admin -p healthcare_data_analyst
```

### 6. Stop the container

```bash
docker compose down
```

### 7. Stop and remove the data volume (⚠️ deletes all data)

```bash
docker compose down -v
```

### 8. Restart the container

```bash
docker compose restart
```

## 🔌 Connection String (for Python / SQLAlchemy)

```
mysql+pymysql://healthcare_admin:VotreMotDePasseFort123!@localhost:3308/healthcare_data_analyst
```

## 🔐 Using a `.env` file (recommended)

Create a `.env` file next to `docker-compose.yml`:

```env
MYSQL_ROOT_PASSWORD=RootPassFort123!
MYSQL_DATABASE=healthcare_data_analyst
MYSQL_USER=healthcare_admin
MYSQL_PASSWORD=VotreMotDePasseFort123!
```

Then reference the variables in `docker-compose.yml`:

```yaml
services:
  mysql:
    image: mysql:8.0
    container_name: healthcare-mysql
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
    ports:
      - "3308:3306"
    volumes:
      - healthcare_mysql_data:/var/lib/mysql

volumes:
  healthcare_mysql_data:
```

Add `.env` to your `.gitignore` so credentials are never committed.

## 🛠 Useful Troubleshooting Commands

| Command | Purpose |
|---|---|
| `docker ps -a` | List all containers, including stopped ones |
| `docker rm healthcare-mysql` | Remove the container (must be stopped first) |
| `docker volume ls` | List all Docker volumes |
| `docker volume rm healthcare_mysql_data` | Remove the persistent data volume |
| `docker exec -it healthcare-mysql bash` | Open a shell inside the container |
| `docker compose config` | Validate and print the resolved compose file |