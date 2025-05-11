FROM python:3.9-slim

WORKDIR /app

RUN apt-get update && apt-get install postgress-client

COPY elt_script.py .

CMD ["python", "elt_script.py"]