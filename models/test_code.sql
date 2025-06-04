Role: {{ target.role }}
Schema: {{ target.schema }}

    {% set role = 'targetrole' %}
    {% set my_cool_string = 'wow! cool!' %}


{% set sql %}
  grant usage on schema {{ schema }} to role {{ role }};
  grant select on all tables in schema {{ schema }} to role {{ role }};
  grant select on all views in schema {{ schema }} to role {{ role }};
{% endset %}

{{ log('Granting select on all tables and views in schema ' ~ target.schema ~ ' to role ' ~ role, info=True) }}

{{sql}}



{% set arg1 = 'teste1' %}
{% set arg2 = 'teste2' %}

{{ log("Running some_macro: " ~ arg1 ~ ", " ~ arg2) }}
