-- Argumentos
-- pos_last_transaction_date DATE, pix_last_transaction_date DATE,
-- acquiring_membership_payment_date DATE, days_until_inactive INT64
{%- macro installed_and_active(
    pos_last_transaction_date,
    pix_last_transaction_date,
    acquiring_membership_payment_date,
    days_until_inactive
) -%}

    case
        when
            date_diff(
                current_date(),
                greatest(
                    coalesce(pos_last_transaction_date, date('1900-01-01')),
                    coalesce(pix_last_transaction_date, date('1900-01-01')),
                    coalesce(acquiring_membership_payment_date, date('1900-01-01'))
                ),
                day
            )
            < days_until_inactive
        then true
        else false
    end

{%- endmacro -%}