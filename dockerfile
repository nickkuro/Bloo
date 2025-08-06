# Use official Python 3.11 image
FROM python:3.11-slim

# Set environment variables
ENV POETRY_VERSION=1.8.2 \
    POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_CREATE=false

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    gcc \
    libpq-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | python3.11 -

# Add Poetry to PATH
ENV PATH="/root/.local/bin:$PATH"

# Set working directory
WORKDIR /app

# Copy project files
COPY pyproject.toml poetry.lock* ./
COPY bloo ./bloo
COPY tables.sql ./
COPY start.sh ./

# Copy config file placeholder (replace at runtime)
COPY config.json ./

# Install dependencies
RUN poetry install --no-root

# Make start script executable
RUN chmod +x start.sh

# Set the default command
CMD ["./start.sh"]
