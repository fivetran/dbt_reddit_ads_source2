<p align="center">
    <a alt="License"
        href="https://github.com/fivetran/dbt_reddit_ads_source/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
    <a alt="dbt-core">
        <img src="https://img.shields.io/badge/dbt_Core™_version->=1.3.0_,<2.0.0-orange.svg" /></a>
    <a alt="Maintained?">
        <img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg" /></a>
    <a alt="PRs">
        <img src="https://img.shields.io/badge/Contributions-welcome-blueviolet" /></a>
</p>

# Reddit Ads Source dbt Package ([Docs](https://fivetran.github.io/dbt_reddit_ads_source/))
## What does this dbt package do?
- Materializes [Reddit Ads staging tables](https://fivetran.github.io/dbt_reddit_ads_source/#!/overview/reddit_ads_source/models/?g_v=1&g_e=seeds) which leverage data in the format described by [this ERD](https://fivetran.com/docs/applications/reddit-ads#schemainformation). These staging tables clean, test, and prepare your reddit_ads data from [Fivetran's connector](https://fivetran.com/docs/applications/reddit-ads) for analysis by doing the following:
  - Naming the columns for consistency across all packages and for easier analysis
  - Adding freshness tests to source data
  - Adding column-level testing where applicable. For example, all primary keys are tested for uniqueness and non-null values.
- Generates a comprehensive data dictionary of your Reddit Ads data through the [dbt docs site](https://fivetran.github.io/dbt_reddit_ads_source/).
- These tables are designed to work simultaneously with our [Reddit Ads transformation package](https://github.com/fivetran/dbt_reddit_ads).

## How do I use the dbt package?
### Step 1: Prerequisites
To use this dbt package, you must have the following:
- At least one Fivetran Reddit Ads connection syncing data into your destination
- A **BigQuery**, **Snowflake**, **Redshift**, **PostgreSQL**, or **Databricks** destination

#### Databricks Dispatch Configuration
If you are using a Databricks destination with this package, you will need to add the below (or a variation of the below) dispatch configuration within your `dbt_project.yml`. This is required in order for the package to accurately search for macros within the `dbt-labs/spark_utils`, then the `dbt-labs/dbt_utils` packages, respectively.
```yml
dispatch:
  - macro_namespace: dbt_utils
    search_order: ['spark_utils', 'dbt_utils']
```

### Step 2: Install the package (skip if also using the `reddit_ads` transformation or `ad_reporting` combo package)
If you are _not_ using the [Reddit Ads](https://github.com/fivetran/dbt_reddit_ads) transformation package or the [Ad Reporting](https://github.com/fivetran/dbt_ad_reporting) combination package, include the following reddit_ads_source package version in your `packages.yml` file.
> TIP: Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.
```yaml
packages:
  - package: fivetran/reddit_ads_source
    version: [">=0.3.0", "<0.4.0"]
```
### Step 3: Define database and schema variables
By default, this package runs using your destination and the `reddit_ads` schema. If this is not where your Reddit Ads data is (for example, if your `reddit_ads` schema is named `reddit_ads_fivetran`), add the following configuration to your root `dbt_project.yml` file:

```yml
vars:
    reddit_ads_database: your_destination_name
    reddit_ads_schema: your_schema_name 
```

### (Optional) Step 4: Additional configurations
<details open><summary>Expand/Collapse details</summary>

#### Union multiple connections
If you have multiple reddit_ads connections in Fivetran and would like to use this package on all of them simultaneously, we have provided functionality to do so. The package will union all of the data together and pass the unioned table into the transformations. You will be able to see which source it came from in the `source_relation` column of each model. To use this functionality, you will need to set either the `reddit_ads_union_schemas` OR `reddit_ads_union_databases` variables (cannot do both) in your root `dbt_project.yml` file:

```yml
vars:
    reddit_ads_union_schemas: ['reddit_ads_usa','reddit_ads_canada'] # use this if the data is in different schemas/datasets of the same database/project
    reddit_ads_union_databases: ['reddit_ads_usa','reddit_ads_canada'] # use this if the data is in different databases/projects but uses the same schema name
```
> NOTE: The native `source.yml` connection set up in the package will not function when the union schema/database feature is utilized. Although the data will be correctly combined, you will not observe the sources linked to the package models in the Directed Acyclic Graph (DAG). This happens because the package includes only one defined `source.yml`.

To connect your multiple schema/database sources to the package models, follow the steps outlined in the [Union Data Defined Sources Configuration](https://github.com/fivetran/dbt_fivetran_utils/tree/releases/v0.4.latest#union_data-source) section of the Fivetran Utils documentation for the union_data macro. This will ensure a proper configuration and correct visualization of connections in the DAG.

#### Passing Through Additional Metrics
By default, this package will select `clicks`, `impressions`, `spend`, `conversions` (aliased from `click_through_conversion_attribution_window_month` source field), `view_through_conversions` (aliased from `view_through_conversion_attribution_window_month` source field), `total_items`, and `total_value` from the source reporting tables to store into the staging models. Note that we choose the maximum attribution window for counting conversions. 

If you would like to pass through additional metrics to the staging models, for example, different attribution windows for conversions such as `view_through_conversion_attribution_window_week`, add the following configurations to your `dbt_project.yml` file. These variables allow the pass-through fields to be aliased (`alias`) if desired, but not required. Use the following format for declaring the respective pass-through variables:

> **NOTE** Make sure to exercise due diligence when adding metrics to these models. The metrics added by default (clicks, impressions, cost, conversions, view-through conversions, total items, and total value) have been vetted by the Fivetran team maintaining this package for accuracy. There are metrics included within the source reports, for example, metric averages, which may be inaccurately represented at the grain for reports created in this package. You want to ensure whichever metrics you pass through are indeed appropriate to aggregate at the respective reporting levels provided in this package.

```yml
vars:
    reddit_ads__account_passthrough_metrics: 
      - name: "custom_field_1"
        alias: "custom_field"
    reddit_ads__campaign_passthrough_metrics:
      - name: "this_field"
    reddit_ads__ad_group_passthrough_metrics:
      - name: "unique_string_field"
    reddit_ads__ad_passthrough_metrics: 
      - name: "new_custom_field"
        alias: "custom_field"
      - name: "a_second_field"
    reddit_ads__account_conversions_passthrough_metrics:
      - name: "view_through_conversion_attribution_window_week"
    reddit_ads__ad_group_conversions_passthrough_metrics:
      - name: "view_through_conversion_attribution_window_week"
    reddit_ads__ad_conversions_passthrough_metrics:
      - name: "view_through_conversion_attribution_window_week"
    reddit_ads__campaign_conversions_passthrough_metrics:
      - name: "view_through_conversion_attribution_window_week"
```

#### Change the build schema
By default, this package builds the Reddit Ads staging models (12 views, 12 tables) within a schema titled (`<target_schema>` + `_reddit_ads_source`) in your destination. If this is not where you would like your Reddit Ads staging data to be written to, add the following configuration to your root `dbt_project.yml` file:

```yml
models:
    reddit_ads_source:
      +schema: my_new_schema_name # leave blank for just the target_schema
```
    
#### Change the source table references
If an individual source table has a different name than the package expects, add the table name as it appears in your destination to the respective variable. This is not available when running the package on multiple unioned connections.
> IMPORTANT: See this project's [`dbt_project.yml`](https://github.com/fivetran/dbt_reddit_ads_source/blob/main/dbt_project.yml) variable declarations to see the expected names.
    
```yml
vars:
    reddit_ads_<default_source_table_name>_identifier: your_table_name 
```

</details>

### (Optional) Step 5: Orchestrate your models with Fivetran Transformations for dbt Core™
<details><summary>Expand for more details</summary>

Fivetran offers the ability for you to orchestrate your dbt project through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt). Learn how to set up your project for orchestration through Fivetran in our [Transformations for dbt Core™ setup guides](https://fivetran.com/docs/transformations/dbt#setupguide).
    
</details>

## Does this package have dependencies?
This dbt package is dependent on the following dbt packages. These dependencies are installed by default within this package. For more information on the following packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
> IMPORTANT: If you have any of these dependent packages in your own `packages.yml` file, we highly recommend that you remove them from your root `packages.yml` to avoid package version conflicts.
```yml
packages:
    - package: fivetran/fivetran_utils
      version: [">=0.4.0", "<0.5.0"]

    - package: dbt-labs/dbt_utils
      version: [">=1.0.0", "<2.0.0"]

    - package: dbt-labs/spark_utils
      version: [">=0.3.0", "<0.4.0"]
```
          
## How is this package maintained and can I contribute?
### Package Maintenance
The Fivetran team maintaining this package _only_ maintains the latest version of the package. We highly recommend that you stay consistent with the [latest version](https://hub.getdbt.com/fivetran/reddit_ads_source/latest/) of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_reddit_ads_source/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

### Contributions
A small team of analytics engineers at Fivetran develops these dbt packages. However, the packages are made better by community contributions.

We highly encourage and welcome contributions to this package. Check out [this dbt Discourse article](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) on the best workflow for contributing to a package.

#### Contributors
We thank [everyone](https://github.com/fivetran/dbt_reddit_ads_source/graphs/contributors) who has taken the time to contribute. Each PR, bug report, and feature request has made this package better and is truly appreciated.

A special thank you to [Seer Interactive](https://www.seerinteractive.com/?utm_campaign=Fivetran%20%7C%20Models&utm_source=Fivetran&utm_medium=Fivetran%20Documentation), who we closely collaborated with to introduce native conversion support to our Ad packages.

## Are there any resources available?
- If you have questions or want to reach out for help, see the [GitHub Issue](https://github.com/fivetran/dbt_reddit_ads_source/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran or would like to request a new dbt package, fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).
