# Minimal custom image for Zyte Scrapy Cloud
# Ref: Custom Images contract docs
FROM python:3.11-slim

# Prevents Python from writing .pyc files and enables unbuffered logs
ENV PYTHONDONTWRITEBYTECODE=1         PYTHONUNBUFFERED=1

# Install system deps (build tools + libxml for bs4 lxml if needed later)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Create app directory
WORKDIR /app

# Copy requirement files first (better layer caching)
COPY requirements.txt /app/requirements.txt

# Install python deps
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r /app/requirements.txt

# Copy the rest of the project
COPY . /app

# Default command is defined in scrapinghub.yml "commands.start"
# but we set a safe fallback:
CMD ["python", "zytepitchbook.py"]
