{%- macro get_deploy_stage_sql(relation) -%}
    {{- log('Applying DEPLOY STAGE to: ' ~ relation) -}}
    {{- adapter.dispatch('get_deploy_stage_sql', 'dbt')(relation) -}}
{%- endmacro -%}


{%- macro default__get_deploy_stage_sql(relation) -%}

    -- get the standard intermediate name
    {% set intermediate_relation = make_intermediate_relation(relation) %}

    {{ get_rename_sql(intermediate_relation, relation.identifier) }}

{%- endmacro -%}
