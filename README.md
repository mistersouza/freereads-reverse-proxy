# NGINX Reverse Proxy with Docker & Render

This repository showcases the use of **NGINX as a reverse proxy** in a **Dockerized full-stack application**, deployed on **Render**. It includes best practices for **load balancing, SSL termination, caching, WebSockets support, security, and logging**.

## 🚀 Why This Matters

NGINX is widely used in production environments due to its **efficiency, scalability, and security**. This setup demonstrates real-world skills sought after by employers.

## 🛠️ Tech Stack
- **Backend:** Node.js + Express
- **Database:** MongoDB + Redis
- **Proxy:** NGINX
- **Containerization:** Docker + Docker Compose
- **Deployment:** Render

---

## 📌 Features Covered

✅ Reverse Proxy for Node.js Backend  
✅ Load Balancing for Scalability  
✅ SSL Termination with Let's Encrypt  
✅ Caching for Performance Optimization  
✅ Rate Limiting & Security Hardening  
✅ WebSockets Support for Notifications  
✅ Logging & Monitoring with NGINX Logs  
✅ Future Expansion: Integrating Prometheus + Grafana  

---

## 📂 Project Structure

```graphql
📁 project-root/
 ├── 📁 nginx/                   # NGINX configuration files
 │   ├── default.conf            # NGINX reverse proxy config
 │   ├── ssl/                    # SSL certificate storage (Let's Encrypt)
 ├── 📁 backend/                 # Node.js + Express API
 ├── 📁 docker/                  # Docker-related files
 ├── 📜 docker-compose.yml       # Multi-container setup
 ├── 📜 README.md                # You're here!
```

---

## 🚀 Setting Up the Project

### 1️⃣ **Clone the Repository**

```sh
git clone https://github.com/mistersouza/freereads-reverse-proxy.git
cd freereads-reverse-proxy
```

### 2️⃣ ***Set Up Environment Variables***

Create a .env file with the following:

```ini
NODE_ENV=production
MONGO_URI=mongodb://your-mongo-uri
REDIS_URL=redis://your-redis-uri
```

### 3️⃣ **Run with Docker Compose**

```sh
docker-compose up --build
```

This will start the NGINX reverse proxy and the Node.js backend in detached mode.

## 🌐 NGINX Configuration Breakdown

### 1️⃣ Reverse Proxy to Node.js Backend

NGINX routes traffic to the Express server:

```nginx
server {
    listen 80;
    server_name yourdomain.com;

    location / {
        proxy_pass http://backend:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

### 2️⃣ Load Balancing Across Multiple Containers

(Do you want to use Docker Compose scaling? YES/NO)
If YES, add this to docker-compose.yml:

```yaml
  backend:
    image: your-backend-image
    deploy:
      replicas: 3
      restart_policy:
        condition: on-failure
```

NGINX will distribute traffic evenly:

```nginx
upstream backend_servers {
    server backend1:3000;
    server backend2:3000;
    server backend3:3000;
}

server {
    location / {
        proxy_pass http://backend_servers;
    }
}
```

### 3️⃣ SSL Termination with Let's Encrypt

NGINX handles HTTPS:


```nginx
server {
    listen 443 ssl;
    ssl_certificate /etc/nginx/ssl/fullchain.pem;
    ssl_certificate_key /etc/nginx/ssl/privkey.pem;
    location / {
        proxy_pass http://backend:3000;
    }
}

```

Run Certbot for automatic SSL generation:


```sh
docker run --rm -v /etc/letsencrypt:/etc/letsencrypt certbot/certbot certonly --webroot -w /var/www/html -d yourdomain.com
```

### 4️⃣ Caching for Static Files

```nginx
location ~* \.(jpg|jpeg|png|gif|css|js|ico|woff|woff2|ttf|svg)$ {
    expires 6M;
    access_log off;
}
```

### 5️⃣ Rate Limiting & Security Enhancements

```nginx
limit_req_zone $binary_remote_addr zone=mylimit:10m rate=5r/s;
server {
    location /api/ {
        limit_req zone=mylimit burst=10;
    }
}
```

### 6️⃣ WebSockets Support for Notifications

```nginx
server {
    location /ws/ {
        proxy_pass http://backend:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "Upgrade";
    }
}
```

### 7️⃣ Logging & Future Monitoring Integration

(Do you want Prometheus/Grafana integration later? YES/NO)
For now, logs are stored in:

```nginx
access_log /var/log/nginx/access.log;
error_log /var/log/nginx/error.log;
```

To view logs:

```sh
docker logs nginx-container
```

## 🚀 Deployment on Render

1. Push to GitHub

```sh
git push origin main
```

2. Create a New Web Service on Render

3. Connect Repository & Set Environment Variables

4. Deploy & Monitor Logs

## 📌 Next Steps

- [ ] Automate SSL renewal
- [ ] Integrate Prometheus/Grafana for monitoring
- [ ] Enhance security with Fail2Ban
- [ ] Implement CI/CD pipeline


## 🎯 Conclusion

This setup demonstrates a professional full-stack deployment with NGINX, Docker, and Render, covering essential DevOps and backend engineering skills. Employers value this expertise for scaling production-ready applications.