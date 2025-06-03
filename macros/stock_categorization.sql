-- Argumentos
-- status STRING, installed_and_active BOOL, serviceprovider_name STRING, last_status
-- STRING, mo_type STRING, id_providertype INT64
-- Tipo de retorno STRING

{%- macro stock_categorization(
    status,
    installed_and_active,
    serviceprovider_name,
    last_status,
    mo_type,
    id_providertype
) -%}

    case
        when status = 'EM PRODUÇÃO' and installed_and_active = true
        then 'instalado_ativo'
        when
            status = 'EM PRODUÇÃO'
            and (installed_and_active is null or installed_and_active = false)
        then 'instalado_inativo'
        when
            status in (
                'VENDIDO',
                'PERDA ATIVA',
                'PERDIDO CLIENTE',
                'ROUBADO',
                'IRREPARÁVEL',
                'DESTRUÍDO',
                'PERDIDO PAGO',
                'PERDIDO OPERAÇÃO',
                'ROUBADO PAGO',
                'OBSOLETO',
                'INATIVO',
                'SHOW ROOM',
                'POS DEV',
                'IRREPARAVEL',
                'ROUBADO_PAGO',
                'DESTRUIDO',
                'PERDA ATIVA - CLIENTE',
                'CANCELADO',
                'PROVISIONADO'
            )
        then 'baixado'
        when
            serviceprovider_name in (
                'TECNO',
                'REDEPAY',
                'GDC',
                'GLOBAL AUTOMACAO ',
                'GLOBAL AUTOMACAO',
                'TEFWAY',
                'RS SOLUTION',
                'TESTE',
                'VENDA DE MAQUINA',
                'OPERADOR LOGISTICO TESTE'
            )
        then 'divergencia'
        when status = 'GOOD' and id_providertype = 7
        then 'good_disponivel_cd'
        when
            (
                (status = 'PRÉ-RECEBIDO' and last_status = 'TRANSP_CD')
                or (status = 'TRANSP_CD' and last_status = 'RESERVA OM')
            )
            and mo_type in ('GOOD')
        then 'good_movimentacao_cd'
        when status = 'RESERVA_OS' and id_providertype = 7
        then 'good_transferencia'
        when
            (
                (status = 'PRÉ-RECEBIDO' and last_status = 'TRANSP_BASE')
                or (
                    status = 'RESERVA OM'
                    and last_status in ('GOOD')
                    or (status = 'TRANSP_BASE' and last_status = 'RESERVA OM')
                )
            )
            and mo_type in ('GOOD')
        then 'good_avanco'
        when status in ('GOOD', 'BKP_TEC', 'RESERVA_OS') and id_providertype != 7
        then 'good_disponivel_ponta'
        when
            (status in ('RETIRADO', 'BAD') and id_providertype != 7)
            or (
                status = 'RESERVA OM'
                and last_status not in ('GOOD', 'LAB_EXT')
                and id_providertype != 7
            )
        then 'triagem_ponta'
        when
            (
                status in ('PRÉ-RECEBIDO', 'TRANSP_BASE')
                and mo_type in ('RETIRADO', 'BAD')
                and id_providertype != 7
            )
        then 'triagem_movimentacao_ponta'
        when status = 'TRDO_GOOD' and id_providertype != 7
        then 'triagem_sem_insumo_ponta'
        when status = 'TRDO_GOOD' and id_providertype = 7
        then 'triagem_sem_insumo_cd'
        when status = 'TRANSP_CD' and mo_type in ('RETIRADO', 'BAD')
        then 'triagem_transp_CD'
        when
            (
                status in ('EM TRIAGEM', 'EM TRIAGEM CQ', 'RETIRADO', 'PRÉ-BAD')
                and id_providertype = 7
            )
        then 'triagem_disponivel_cd'
        when
            status = 'PRÉ-RECEBIDO'
            and mo_type in ('RETIRADO', 'BAD')
            and id_providertype = 7
        then 'triagem_recebimento_cd'
        when status = 'REV_LAB_EXT'
        then 'triagem_transp_lab'
        when
            (status = 'BAD' and id_providertype = 7)
            or (status = 'RESERVA OM' and last_status = 'BAD' and id_providertype = 7)
        then 'lab_bad_cd'
        when status in ('TRANSP_LAB')
        then 'lab_transp_lab'
        when
            status in ('LAB_EXT') or (status = 'RESERVA OM' and last_status = 'LAB_EXT')
        then 'lab_laboratorio'
        when status in ('LAB_GOOD')
        then 'lab_good'
        else 'divergencia'
    end

{% endmacro %}
