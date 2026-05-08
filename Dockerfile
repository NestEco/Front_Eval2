#FROM → Define la imagen base (ej: Alpine, Ubuntu,Node).
#WORKDIR → Establece la carpeta donde trabajará el contenedor.
#COPY / ADD → Copia archivos locales al contenedor.
#RUN → Instala dependencias o ejecuta scripts.
#ENV → Crea variables de entorno.
#EXPOSE → Documenta puertos usados por el contenedor.
#CMD y ENTRYPOINT → Indican cómo se ejecutará la aplicación.

#Parte 1: Construir
FROM python:3.11-slim AS builder

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

#Parte 2: Producir
FROM python:3.11-slim AS production

WORKDIR /app

RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser

COPY --from=builder /install /usr/local

COPY --chown=appuser:appgroup . .

USER appuser

EXPOSE 5000

CMD ["python", "app.py"]