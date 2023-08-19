{%- macro get_drop_sql(relation) -%}
    {{- log('Applying DROP to: ' ~ relation) -}}
    {{- adapter.dispatch('get_drop_sql', 'dbt')(relation) -}}
{%- endmacro -%}


{%- macro default__get_drop_sql(relation) -%}

    {%- if relation.is_view -%}
        {{ drop_view(relation) }}

    {%- elif relation.is_table -%}
        {{ drop_table(relation) }}

    {%- elif relation.is_materialized_view -%}
        {{ drop_materialized_view(relation) }}

    {%- else -%}
        {{- exceptions.raise_compiler_error("`get_drop_sql` has not been implemented for: " ~ relation.type ) -}}

    {%- endif -%}

{%- endmacro -%}


{% macro drop_relation(relation) -%}
    {{ return(adapter.dispatch('drop_relation', 'dbt')(relation)) }}
{% endmacro %}

{% macro default__drop_relation(relation) -%}
    {% call statement('drop_relation', auto_begin=False) -%}
        {%- if relation.is_table -%}
            {{- drop_table(relation) -}}
        {%- elif relation.is_view -%}
            {{- drop_view(relation) -}}
        {%- elif relation.is_materialized_view -%}
            {{- drop_materialized_view(relation) -}}
        {%- else -%}
            drop {{ relation.type }} if exists {{ relation }} cascade
        {%- endif -%}
    {%- endcall %}
{% endmacro %}
