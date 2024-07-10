# Use the official PostgreSQL image from Docker Hub
FROM postgres:latest

# Environment variables
ENV POSTGRES_DB=bookstore-db \
    POSTGRES_USER=your_user \
    POSTGRES_PASSWORD=your_password

# Expose the PostgreSQL port
EXPOSE 5432