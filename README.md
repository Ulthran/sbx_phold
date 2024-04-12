This is a template to use to extend the [Sunbeam pipeline](https://github.com/sunbeam-labs/sunbeam). There are three major parts to a Sunbeam extension: 

 - `sbx_phold_env.yml` specifies the extension's dependencies
 - `config.yml` contains configuration options that can be specified by the user when running an extension
 - `sbx_phold.rules` contains the rules (logic/commands run) of the extension
 
## Creating an extension

Any dependencies (available through conda) required for an extension should be listed in the `sbx_[your_extension_name]_env.yml` file. An example of how to format this is shown in the `sbx_phold_env.yml` file. These dependencies are automatically handled and installed by Snakemake through conda (see below for how to make sure your rule finds this env file), so the user doesn't have to worry about installing dependencies themselves. You can also specify specific software versions like so:

    dependencies:
      - python=3.7
      - megahit<2

Rarely, you may want to specify different environments for different rules within your extension, in the event that different rules have different (potentially conflicting) requirements.

The `config.yml` contains parameters that the user might need to modify when running an extension. For example, if your downstream analysis is run differently depending on whether reads are paired- or single-end, it would probably be wise to include a `paired_end` parameter. Default values should be specified for each terminal key. As of Sunbeam v3.0, as long as the parameter config file is named `config.yml`, configuration options for installed extensions are automatically included in new config files generated by `sunbeam init` and `sunbeam config update`.

Finally, `sbx_phold.rules` contains the actual logic for the extension, including required input and output files. A detailed discussion of Snakemake rule creation is beyond the scope of this tutorial, but definitely check out [the Snakemake tutorial](http://snakemake.readthedocs.io/en/stable/tutorial/basics.html) and any of the [extensions by sunbeam-labs](https://github.com/sunbeam-labs) for inspiration.

For each rule that needs dependencies from your environment file, make sure to let snakemake know in the rule like this:

    example_rule:
        ...
        conda:
            "sbx_phold_env.yml"
        ...

The dependency .yml file can be named whatever you want, as long as you refer to it by the correct filename in whatever rule needs those dependencies. The path to the dependency .yml file is relative to the .rules file (which in most cases is in the same directory).

## Additional extension components

### .github/

This directory contains CI workflows for GitHub to run automatically on PRs, including tests and linting. If the linter raises errors, you can fix them by running `snakefmt` on any snakemake files and `black` on any python files. The release workflow will build and push a docker image for each environment in the extension.

### .tests/

This directory contains tests, broken down into types such as end-to-end (e2e) and unit, as well as data for running these tests.

### scripts/

This directory contains scripts that can be run by rules. Use this for any rules that need to run python, R, etc code.

### envs/*.Dockerfile

The Dockerfiles provided with conda env specifications allow for containerized runs of sunbeam (meaning they use docker containers to run each rule rather than conda envs).

(You can delete everything above this line)
-----------------------------------------------------------------

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

    sunbeam run --profile /path/to/project/ example_rule

### Options for config.yml

  - example_rule_options: Example rule options description
    
## Installing an extension (legacy instructions for sunbeam <3.0)

Installing an extension is as simple as cloning (or moving) your extension directory into the sunbeam/extensions/ folder, installing requirements through Conda, and adding the new options to your existing configuration file: 

    git clone https://github.com/sunbeam-labs/sbx_phold/ sunbeam/extensions/sbx_phold
    cat sunbeam/extensions/sbx_phold/config.yml >> sunbeam_config.yml

## Issues with pipeline

Please post any issues with this extension [here](https://github.com/sunbeam-labs/sbx_phold/issues).
