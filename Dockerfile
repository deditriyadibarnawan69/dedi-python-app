# Gunakan image base Python yang kecil
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Salin file requirements.txt dan install dependensi
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Salin semua file dari direktori lokal ke dalam container
COPY . .

# Expose port yang akan digunakan
EXPOSE 5000

# Jalankan aplikasi
CMD ["python", "app.py"]
