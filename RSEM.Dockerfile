FROM continuumio/miniconda3:latest

RUN conda install -y bioconda::rsem
