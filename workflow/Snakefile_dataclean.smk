rule clean_compile_data:
    input:
        raw_pub = RAW_PUB,
        raw_author = RAW_AUTHOR,
        raw_funder = RAW_FUNDER,
        cntry_convert = CNTRY_CONVERT_DATA,
    output:
        pub_data = PUB_DATA
    shell:
        """
        papermill scripts/compile_data.ipynb \
            scripts/outputs/compile_data.ipynb \
            -p pub_path {input.raw_pub} \
            -p pub_author_path {input.raw_author} \
            -p pub_fund_path {input.raw_funder} \
            -p cntry_path {input.cntry_convert} \
            -p clean_pub_path {output.pub_data}
        """
        