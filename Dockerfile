FROM python:3.9.5-slim-buster

ARG ZSCALER_CERT

RUN if [ -n "${ZSCALER_CERT}" ]; then \
      mkdir -p /usr/local/share/ca-certificates; \
      echo "${ZSCALER_CERT}" > /usr/local/share/ca-certificates/zscaler.crt; \
      update-ca-certificates --fresh; \
    fi

RUN mkdir -p /root/.config/pip/

COPY ./*.py /app/
COPY ./names.json /app/
COPY ./Procfile /app/
COPY ./requirements.txt /app/
COPY ./pip.conf /root/.config/pip/

WORKDIR /app

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8080

CMD ["gunicorn", "-b", "0.0.0.0:8000", "app:app"]
