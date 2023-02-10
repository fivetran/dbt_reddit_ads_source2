{% macro get_ad_report_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "account_id", "datatype": dbt_utils.type_string()},
    {"name": "ad_id", "datatype": dbt_utils.type_string()},
    {"name": "app_install_metrics_add_payment_info", "datatype": dbt_utils.type_int()},
    {"name": "app_install_metrics_add_to_cart", "datatype": dbt_utils.type_int()},
    {"name": "app_install_metrics_app_launch", "datatype": dbt_utils.type_int()},
    {"name": "app_install_metrics_completed_tutorial", "datatype": dbt_utils.type_int()},
    {"name": "app_install_metrics_install", "datatype": dbt_utils.type_int()},
    {"name": "app_install_metrics_level_achieved", "datatype": dbt_utils.type_int()},
    {"name": "app_install_metrics_purchase", "datatype": dbt_utils.type_int()},
    {"name": "app_install_metrics_search", "datatype": dbt_utils.type_int()},
    {"name": "app_install_metrics_sign_up", "datatype": dbt_utils.type_int()},
    {"name": "app_install_metrics_spend", "datatype": dbt_utils.type_int()},
    {"name": "app_install_metrics_spend_credits", "datatype": dbt_utils.type_int()},
    {"name": "app_install_metrics_view_content", "datatype": dbt_utils.type_int()},
    {"name": "clicks", "datatype": dbt_utils.type_int()},
    {"name": "comment_downvotes", "datatype": dbt_utils.type_int()},
    {"name": "comment_upvotes", "datatype": dbt_utils.type_int()},
    {"name": "comments_page_views", "datatype": dbt_utils.type_int()},
    {"name": "conversion_roas", "datatype": dbt_utils.type_float()},
    {"name": "cpc", "datatype": dbt_utils.type_float()},
    {"name": "ctr", "datatype": dbt_utils.type_float()},
    {"name": "date", "datatype": "date"},
    {"name": "ecpm", "datatype": dbt_utils.type_float()},
    {"name": "gallery_item_caption", "datatype": dbt_utils.type_string()},
    {"name": "gallery_item_id", "datatype": dbt_utils.type_string()},
    {"name": "impressions", "datatype": dbt_utils.type_int()},
    {"name": "legacy_click_conversions_attribution_window_day", "datatype": dbt_utils.type_int()},
    {"name": "legacy_click_conversions_attribution_window_month", "datatype": dbt_utils.type_int()},
    {"name": "legacy_click_conversions_attribution_window_week", "datatype": dbt_utils.type_int()},
    {"name": "legacy_view_conversions_attribution_window_day", "datatype": dbt_utils.type_int()},
    {"name": "legacy_view_conversions_attribution_window_month", "datatype": dbt_utils.type_int()},
    {"name": "legacy_view_conversions_attribution_window_week", "datatype": dbt_utils.type_int()},
    {"name": "priority", "datatype": dbt_utils.type_string()},
    {"name": "region", "datatype": dbt_utils.type_string()},
    {"name": "spend", "datatype": dbt_utils.type_int()},
    {"name": "video_fully_viewable_impressions", "datatype": dbt_utils.type_int()},
    {"name": "video_plays_expanded", "datatype": dbt_utils.type_int()},
    {"name": "video_plays_with_sound", "datatype": dbt_utils.type_int()},
    {"name": "video_started", "datatype": dbt_utils.type_int()},
    {"name": "video_viewable_impressions", "datatype": dbt_utils.type_int()},
    {"name": "video_watched_100_percent", "datatype": dbt_utils.type_int()},
    {"name": "video_watched_10_seconds", "datatype": dbt_utils.type_int()},
    {"name": "video_watched_25_percent", "datatype": dbt_utils.type_int()},
    {"name": "video_watched_3_seconds", "datatype": dbt_utils.type_int()},
    {"name": "video_watched_50_percent", "datatype": dbt_utils.type_int()},
    {"name": "video_watched_5_seconds", "datatype": dbt_utils.type_int()},
    {"name": "video_watched_75_percent", "datatype": dbt_utils.type_int()},
    {"name": "video_watched_95_percent", "datatype": dbt_utils.type_int()},
    {"name": "viewable_impressions", "datatype": dbt_utils.type_int()},
    {"name": "viewer_comments", "datatype": dbt_utils.type_int()}
] %}

{{ return(columns) }}

{% endmacro %}
