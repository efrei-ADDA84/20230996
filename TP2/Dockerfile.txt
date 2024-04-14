FROM python:3.8
WORKDIR /app
COPY . /app
RUN pip install -r requirements.txt
EXPOSE 8081
CMD ["python", "TP2.py"]
