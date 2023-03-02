#ARG IMAGE=containers.intersystems.com/intersystems/irishealth-community:2022.1.0.209.0
ARG IMAGE=intersystems/irishealth-community:2022.1.2.574.0
FROM $IMAGE

USER root

RUN apt-get update && apt-get install -y

# コンテナ内のワークディレクトリを /opt/try　に設定（後でここにデータベースを作成予定）
WORKDIR /opt/try
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/try

USER ${ISC_PACKAGE_MGRUSER}
COPY iris.script .
COPY Setup.cls .
COPY requirements.txt .
COPY nmain509.txt .
COPY Flask Flask
COPY src src
COPY entrypoint.sh .
COPY data/StructureDefinition-string.json ${ISC_PACKAGE_INSTALLDIR}/dev/fhir/fhir-metadata/packages/hl7.fhir.r4.core

# run iris and initial 
RUN iris start IRIS \
    && iris session IRIS < iris.script \
    && iris stop IRIS quietly

ENV PYTHON_PATH=/usr/irissys/bin/irispython
ENV PIP_PATH=/usr/irissys/bin/irispip
ENV IRISUSERNAME "SuperUser"
ENV IRISPASSWORD "SYS"
ENV IRISNAMESPACE="R4FHIRNAMESPACE"

RUN ${PYTHON_PATH} -m pip install -r requirements.txt
#RUN pip install --no-cache-dir -r requirements.txt

ENTRYPOINT [ "/tini", "--", "/opt/try/entrypoint.sh" ]