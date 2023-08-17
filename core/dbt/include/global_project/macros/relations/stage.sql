{%- macro get_stage_sql(relation, sql) -%}
    {{- log('Applying STAGE to: ' ~ relation) -}}
    {{- adapter.dispatch('get_stage_sql', 'dbt')(relation, sql) -}}
{%- endmacro -%}


{%- macro default__get_stage_sql(relation, sql) -%}

    -- get the standard intermediate name
    {% set intermediate_relation = make_intermediate_relation(relation) %}

    -- drop any pre-existing intermediate
    {{ get_drop_sql(intermediate_relation) }};

    {{ get_create_sql(intermediate_relation, sql) }}

{%- endmacro -%}
