FROM python:3.10-slim

ARG version="21.1.3"

RUN python -m pip install --upgrade pip && \
    pip install ansible-base && \
    ansible-galaxy collection install vmware.alb:${version} && \
    pip install -r ~/.ansible/collections/ansible_collections/vmware/alb/requirements.txt && \
    pip cache purge

