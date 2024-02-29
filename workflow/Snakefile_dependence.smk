rule remove_foreignfund:
    input:
        pub_data = PUB_DATA
    output:
        pub_noint_fund = PUB_NOINT_FUND_FILE
    shell:
        """
        papermill scripts/remove_foreignfund.ipynb \
            scripts/outputs/remove_foreignfund.ipynb \
            -p pubs_path {input.pub_data} \
            -p pub_filter_path {output.pub_noint_fund}
        """
        
rule cal_cntry_author_full:
    input:
        pub_data = PUB_DATA
    output:
        cntry_author_full = CNTRY_AUTHOR_FULL
    shell:
        """
        papermill scripts/cntry_author_full.ipynb \
            scripts/outputs/cntry_author_full.ipynb \
            -p pubs_path {input.pub_data} \
            -p cntry_author_full_path {output.cntry_author_full}
        """


rule plot_pub_reduction_global:
    input:
        cntry_author_full = CNTRY_AUTHOR_FULL,
        pub_noint_fund = PUB_NOINT_FUND_FILE,
        cntry_region = CNTRY_REGION_DATA,
        world_shp = WORLD_SHP_PATH
    output:
        reduction_plot = PUB_REDUCTION_GLOBAL_PLOT
    shell:
        """
        papermill scripts/cal_plot_pubreduction.ipynb \
            scripts/outputs/cal_plot_pubreduction.ipynb \
            -p cntry_full_path {input.cntry_author_full} \
            -p cntry_filter_path {input.pub_noint_fund} \
            -p geopath {input.world_shp} \
            -p region_path {input.cntry_region} \
            -p plot_path {output.reduction_plot}
        """

rule plot_pub_change_global:
    input:
        cntry_author_full = CNTRY_AUTHOR_FULL,
        pub_noint_fund = PUB_NOINT_FUND_FILE,
        cntry_region = CNTRY_REGION_DATA,
        world_shp = WORLD_SHP_PATH
    output:
        change_plot = PUB_CHANGE_GLOBAL_PLOT
    shell:
        """
        papermill scripts/cal_plot_profilechange_global.ipynb \
            scripts/outputs/cal_plot_profilechange_global.ipynb \
            -p cntry_full_path {input.cntry_author_full} \
            -p cntry_filter_path {input.pub_noint_fund} \
            -p geopath {input.world_shp} \
            -p region_path {input.cntry_region} \
            -p plot_path {output.change_plot}
        """

rule remove_exclusive_foreignfund:
    input:
        pub_data = PUB_DATA
    output:
        pub_noint_fund = PUB_NO_EXCLUSIVE_INT_FUND_FILE
    shell:
        """
        papermill scripts/remove_exclusive_foreignfund.ipynb \
            scripts/outputs/remove_exclusive_foreignfund.ipynb \
            -p pubs_path {input.pub_data} \
            -p pub_filter_path {output.pub_noint_fund}
        """
        
rule plot_pub_reduction_no_exclusive_global:
    input:
        cntry_author_full = CNTRY_AUTHOR_FULL,
        pub_noint_fund = PUB_NO_EXCLUSIVE_INT_FUND_FILE,
        cntry_region = CNTRY_REGION_DATA,
        world_shp = WORLD_SHP_PATH
    output:
        reduction_plot = PUB_REDUCTION_NO_EXCLUSIVE_FOREIGN_GLOBAL_PLOT
    shell:
        """
        papermill scripts/cal_plot_pubreduction.ipynb \
            scripts/outputs/cal_plot_pubreduction.ipynb \
            -p cntry_full_path {input.cntry_author_full} \
            -p cntry_filter_path {input.pub_noint_fund} \
            -p geopath {input.world_shp} \
            -p region_path {input.cntry_region} \
            -p plot_path {output.reduction_plot}
        """
        
rule plot_pub_change_no_exclusive_global:
    input:
        cntry_author_full = CNTRY_AUTHOR_FULL,
        pub_noint_fund = PUB_NO_EXCLUSIVE_INT_FUND_FILE,
        cntry_region = CNTRY_REGION_DATA,
        world_shp = WORLD_SHP_PATH
    output:
        change_plot = PUB_CHANGE_NO_EXCLUSIVE_GLOBAL_PLOT
    shell:
        """
        papermill scripts/cal_plot_profilechange_global.ipynb \
            scripts/outputs/cal_plot_profilechange_global.ipynb \
            -p cntry_full_path {input.cntry_author_full} \
            -p cntry_filter_path {input.pub_noint_fund} \
            -p geopath {input.world_shp} \
            -p region_path {input.cntry_region} \
            -p plot_path {output.change_plot}
        """
        
rule prepare_regression:
    input:
        pubs_path = PUB_DATA
    output:
        reg_table_path = REGRESSION_TABLE
    shell:
        """
        papermill scripts/prepare_reg_table.ipynb \
            scripts/outputs/prepare_reg_table.ipynb \
            -p pubs_path {input.pubs_path} \
            -p reg_table_path {output.reg_table_path}
        """
        
rule run_regression:
    input: 
        REGRESSION_TABLE
    output: 
        REGRESSION_RESULT
    shell:
        "Rscript scripts/run_regression.r {input} {output}"