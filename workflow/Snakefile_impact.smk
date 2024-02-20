rule remove_foreignfund_top20:
    input:
        pub_data = PUB_DATA,
        cntry_fund_frac = CNTRY_FUND_FRAC
    output:
        pub_noforeign = PUB_NOFOREIGN_TOP20
    shell:
        """
        papermill scripts/build_profile_without_top20.ipynb \
            scripts/outputs/build_profile_without_top20.ipynb \
            -p pubs_path {input.pub_data} \
            -p cntry_fund_frac_path {input.cntry_fund_frac} \
            -p profile_path {output.pub_noforeign}
        """
        
rule plot_pubred_top:
    input:
        cntry_author_full = CNTRY_AUTHOR_FULL,
        pub_noforeign_top = PUB_NOFOREIGN_TOP20,
        cntry_flag = CNTRY_FLAG_DATA
    output:
        plot = PUB_REDUCTION_TOP_PLOT
    shell:
        """
        papermill scripts/plot_pubred_top20.ipynb \
            scripts/outputs/plot_pubred_top20.ipynb \
            -p cntry_full_path {input.cntry_author_full} \
            -p cntry_filter_path {input.pub_noforeign_top} \
            -p flag_path {input.cntry_flag} \
            -p plot_path {output.plot} 
        """ 
        
rule plot_profilechange_top:
    input:
        cntry_author_full = CNTRY_AUTHOR_FULL,
        pub_noforeign_top = PUB_NOFOREIGN_TOP20,
        cntry_flag = CNTRY_FLAG_DATA
    output:
        plot = PROFILECHANGE_TOP_PLOT
    shell:
        """
        papermill scripts/plot_profilechange_top20.ipynb \
            scripts/outputs/plot_profilechange_top20.ipynb \
            -p cntry_full_path {input.cntry_author_full} \
            -p cntry_filter_path {input.pub_noforeign_top} \
            -p flag_path {input.cntry_flag} \
            -p plot_path {output.plot} 
        """  
        
rule remove_exclusive_foreignfund_top20:
    input:
        pub_data = PUB_DATA,
        cntry_fund_frac = CNTRY_FUND_FRAC
    output:
        pub_noforeign = PUB_NOFOREIGN_EXCLUSIVE_TOP20
    shell:
        """
        papermill scripts/build_profile_without_exclusive_top20.ipynb \
            scripts/outputs/build_profile_without_exclusive_top20.ipynb \
            -p pubs_path {input.pub_data} \
            -p cntry_fund_frac_path {input.cntry_fund_frac} \
            -p profile_path {output.pub_noforeign}
        """
        
rule plot_pubred_exclusive_funded_by_top:
    input:
        cntry_author_full = CNTRY_AUTHOR_FULL,
        pub_noforeign_top = PUB_NOFOREIGN_EXCLUSIVE_TOP20,
        cntry_flag = CNTRY_FLAG_DATA
    output:
        plot = PUB_REDUCTION_EXCLUSIVE_TOP_PLOT
    shell:
        """
        papermill scripts/plot_pubred_top20.ipynb \
            scripts/outputs/plot_pubred_top20.ipynb \
            -p cntry_full_path {input.cntry_author_full} \
            -p cntry_filter_path {input.pub_noforeign_top} \
            -p flag_path {input.cntry_flag} \
            -p plot_path {output.plot} 
        """ 
 
rule plot_profilechange_exclusive_funded_by_top:
    input:
        cntry_author_full = CNTRY_AUTHOR_FULL,
        pub_noforeign_top = PUB_NOFOREIGN_EXCLUSIVE_TOP20,
        cntry_flag = CNTRY_FLAG_DATA
    output:
        plot = PROFILECHANGE_EXCLUSIVE_TOP_PLOT
    shell:
        """
        papermill scripts/plot_profilechange_top20.ipynb \
            scripts/outputs/plot_profilechange_top20.ipynb \
            -p cntry_full_path {input.cntry_author_full} \
            -p cntry_filter_path {input.pub_noforeign_top} \
            -p flag_path {input.cntry_flag} \
            -p plot_path {output.plot} 
        """  

#rule plot_influentialarea_top:
#    input:
#        cntry_author_full = CNTRY_AUTHOR_FULL,
#        pub_noforeign_top = PUB_NOFOREIGN_TOP20,
#        world_geo = WORLD_SHP_PATH
#    output:
#        plot_path = INFLUENCIAL_AREA_PLOT
#    shell:
#        """
#        papermill scripts/plot_influential_area_top20.ipynb \
#            scripts/outputs/plot_influential_area_top20.ipynb \
#            -p cntry_full_path {input.cntry_author_full} \
#            -p cntry_filter_path {input.pub_noforeign_top} \
#            -p geo_path {input.world_geo} \
#            -p plot_path {output.plot_path} \
#            -p cntry {wildcards.cntry}
#        """   

rule plot_influentialarea_top:
    input:
        CNTRY_AUTHOR_FULL,
        PUB_NOFOREIGN_TOP20,
        WORLD_SHP_PATH
    output:
        INFLUENCIAL_AREA_PLOT
    shell:
        'python scripts/plot_influential_area_top20.py {input} "{output[0]}"'

rule cal_funding_unit_flow:
    input:
        pub_data = PUB_DATA
    output:
        flow_data = FUNDING_UNIT_FLOW
    shell:
        """
        papermill scripts/fundunit_flow.ipynb \
            scripts/outputs/fundunit_flow.ipynb \
            -p pubs_path {input.pub_data} \
            -p flow_result {output.flow_data} 

        """    

rule cal_noforeign_funding_all2all:
    input:
        pub_data = PUB_DATA,
        cntry_author_full = CNTRY_AUTHOR_FULL
    output:
        all2all_res = PUB_NOFOREIGN_ALL2ALL
    shell:
        """
        papermill scripts/build_profile_without_allcountries.ipynb \
            scripts/outputs/build_profile_without_allcountries.ipynb \
            -p pubs_path {input.pub_data} \
            -p cntry_full_path {input.cntry_author_full} \
            -p profile_path {output.all2all_res} 

        """    
rule extract_backbone_all2all:
    input:
        all2all_data = PUB_NOFOREIGN_ALL2ALL,
        cntry_region = CNTRY_REGION_DATA,
        cntry_fund_frac = CNTRY_FUND_FRAC,
    output:
        backbone_net = ALL2ALL_BACKBONE_ALPHA
    shell:
        """
        papermill scripts/extract_backbone.ipynb \
            scripts/outputs/extract_backbone.ipynb \
            -p all2all_path {input.all2all_data} \
            -p cntry_region_path {input.cntry_region} \
            -p fund_frac_path {input.cntry_fund_frac} \
            -p backbone_net_path {output.backbone_net}
        """  
        
rule plot_backbone_all2all:
    input:
        graph_file = ALL2ALL_BACKBONE_GRAPH
    output:
        plot = BACKBONE_PLOT
    shell:
        """
        papermill scripts/draw_network_all.ipynb \
            scripts/outputs/draw_network_all.ipynb \
            -p path {input.graph_file} \
            -p plot_path {output.plot} 
        """        

rule plot_backbone_individual_cntry:
    input:
        ALL2ALL_BACKBONE_GRAPH
    output: 
        BACKBONE_INDIVIDUAL_CNTRY_PLOT
    shell:
        'python scripts/draw_network_individual_cntry.py {input} "{output[0]}"'
