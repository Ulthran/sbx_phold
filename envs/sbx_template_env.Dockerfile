FROM condaforge/mambaforge:latest

# Setup
WORKDIR /home/sbx_phold_env

COPY envs/sbx_phold_env.yml ./

# Install environment
RUN conda env create --file sbx_phold_env.yml --name sbx_phold

ENV PATH="/opt/conda/envs/sbx_phold/bin/:${PATH}"

# "Activate" the environment
SHELL ["conda", "run", "-n", "sbx_phold", "/bin/bash", "-c"]

# Run
CMD "bash"