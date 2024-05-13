<img src="https://github.com/sunbeam-labs/sunbeam/blob/stable/docs/images/sunbeam_logo.gif" width=120, height=120 align="left" />

# sbx_phold

<!-- Badges start -->
[![Tests](https://github.com/sunbeam-labs/sbx_phold/actions/workflows/tests.yml/badge.svg)](https://github.com/sunbeam-labs/sbx_phold/actions/workflows/tests.yml)
[![DockerHub](https://img.shields.io/docker/pulls/sunbeamlabs/sbx_phold)](https://hub.docker.com/repository/docker/sunbeamlabs/sbx_phold/)
<!-- Badges end -->

## Introduction

sbx_phold is a [sunbeam](https://github.com/sunbeam-labs/sunbeam) extension for .... This pipeline uses ....

## Installation

Extension install is as simple as passing the extension's URL on GitHub to `sunbeam extend`:

    sunbeam extend https://github.com/sunbeam-labs/sbx_phold

Any user-modifiable parameters specified in `config.yml` are automatically added on `sunbeam init`. If you're installing an extension in a project where you already have a config file, run the following to add the options for your newly added extension to your config (the `-i` flag means in-place config file modification; remove the `-i` flag to see the new config in stdout):

    sunbeam config update -i /path/to/project/sunbeam_config.yml

Installation instructions for older versions of Sunbeam are included at the end of this README.

## Running

To run an extension, simply run Sunbeam as usual with your extension's target rule specified:

    sunbeam run --profile /path/to/project/ all_phold

### Options for config.yml

  - phold_db: Path to phold db
    
## Installing an extension (legacy instructions for sunbeam <3.0)

Installing an extension is as simple as cloning (or moving) your extension directory into the sunbeam/extensions/ folder, installing requirements through Conda, and adding the new options to your existing configuration file: 

    git clone https://github.com/sunbeam-labs/sbx_phold/ sunbeam/extensions/sbx_phold
    cat sunbeam/extensions/sbx_phold/config.yml >> sunbeam_config.yml

## Issues with pipeline

Please post any issues with this extension [here](https://github.com/sunbeam-labs/sbx_phold/issues).
