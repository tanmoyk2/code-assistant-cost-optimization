#!/bin/bash -e
echo "STARTUP-SCRIPT: START"
sudo -u jupyter gsutil cp gs://qwiklabs-gcp-04-f7259b2b6bd5-bucket/code_assistant_cost_optimization.ipynb /home/jupyter/
sudo -u jupyter gsutil -m cp -r gs://qwiklabs-gcp-04-f7259b2b6bd5-bucket/code_assistant /home/jupyter/
sudo -u jupyter gsutil -m cp -r gs://qwiklabs-gcp-04-f7259b2b6bd5-bucket/assets /home/jupyter/
echo "STARTUP-SCRIPT: END"
