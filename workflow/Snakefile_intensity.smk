rule plot_fund_intensity:
    input:
        pub_data = PUB_DATA,
        cntry_region = CNTRY_REGION_DATA,
        world_shp = WORLD_SHP_PATH
    output:
        overall_plot = FUNDING_INTENSITY_OVERALL_PLOT,
        portfolio_plot = FUNDING_PORTFOLIO_PLOT,
        funding_portfolio_outlier = FUNDING_PORTFOLIO_OUTLIER,
        self_plot = FUNDING_INTENSITY_SELF_PLOT
    shell:
        """
        papermill scripts/plot_fundintensity.ipynb \
            scripts/outputs/plot_fundintensity.ipynb \
            -p pubs_path {input.pub_data} \
            -p region_path {input.cntry_region} \
            -p world_geo_path {input.world_shp} \
            -p funding_intensity_overall_path {output.overall_plot} \
            -p funding_portfolio_path {output.portfolio_plot} \
            -p funding_portfolio_outlier {output.funding_portfolio_outlier}\
            -p funding_intensity_self_path {output.self_plot}
        """
        