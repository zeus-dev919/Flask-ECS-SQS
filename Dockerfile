FROM python:3.7-alpine

WORKDIR /flask_app
COPY requirements.txt requirements.txt
ADD flask_app /flask_app

RUN pip install -r requirements.txt

ENV FLASK_APP __init__.py

EXPOSE 5008

CMD flask run --host=0.0.0.0 --port=5008