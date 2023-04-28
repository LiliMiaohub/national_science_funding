rule cal_fund_frac:
    input:
        pub_data = PUB_DATA,
    output:
        cntry_fund_frac = CNTRY_FUND_FRAC
    shell:
        """
        papermill scripts/cntry_fund_frac.ipynb \
            scripts/outputs/cntry_fund_frac.ipynb \
            -p pubs_path {input.pub_data} \
            -p cntry_fund_frac_path {output.cntry_fund_frac}
        """

rule plot_global_funding:
    input:
        pub_data = PUB_DATA
    output:
        global_fund = GLOBAL_FUND_PLOT
    shell:
        """
        papermill scripts/plot_globalfund_fig1.ipynb \
            scripts/outputs/plot_globalfund_fig1.ipynb\
            -p pubs_path {input.pub_data} \
            -p global_funding_path {output.global_fund}
        """

rule plot_global_patron:
    input:
        cntry_fund_frac = CNTRY_FUND_FRAC,
        pub_data = PUB_DATA,
        cntry_flag = CNTRY_FLAG_DATA,
        cntry_region = CNTRY_REGION_DATA
    output:
        cntry_fund_frac_plot = CNTRY_FUND_FRAC_PLOT
    shell:
        """
        papermill scripts/plot_global_patron.ipynb \
            scripts/outputs/plot_global_patron.ipynb \
            -p cntry_fund_path {input.cntry_fund_frac} \
            -p pubs_path {input.pub_data} \
            -p flag_path {input.cntry_flag} \
            -p region_path {input.cntry_region} \
            -p cntry_funding_path {output.cntry_fund_frac_plot}
        """
     
        