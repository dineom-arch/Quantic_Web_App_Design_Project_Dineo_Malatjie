FROM python:3.11-slim
WORKDIR /app
COPY . /app
RUN pip install --no-cache-dir -r "04 Backend Code/backend/requirements.txt"
ENV FLASK_ENV=production
ENV FLASK_APP=run.py
EXPOSE 5000
CMD ["python", "04 Backend Code/backend/run.py"]
