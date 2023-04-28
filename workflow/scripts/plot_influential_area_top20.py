import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import os
import funding.core
import sys
import geopandas as gp

def read_group(path,groupby,reset_col):
    df=pd.read_csv(path)
    df=df.rename(columns={'author_distinct':'cntry'})
    df=df.groupby(groupby)['count'].sum().reset_index(name=reset_col)
    return df

if __name__ == "__main__":
    
    cntry_full_path = sys.argv[1]
    cntry_filter_path = sys.argv[2]
    geo_path = sys.argv[3]
    plot_path = sys.argv[4]
    
    raw_df=pd.read_csv(cntry_full_path)
    raw_df=raw_df.rename(columns={'aucntry':'cntry'})
    raw_df=read_group(cntry_full_path,['cntry'],'raw')
    
    filter_df=pd.read_csv(cntry_filter_path)
    filter_df=read_group(cntry_filter_path,['cntry','srce_cntry'],'filter')
    
    meta=raw_df.merge(filter_df,on='cntry')
    meta['p']=(meta['raw']-meta['filter'])/meta['raw']
    meta['p']=meta['p'].apply(lambda x:np.around(x,2))
    
    world_geo=funding.core.read_geofile(geo_path)

    fig, ax = plt.subplots(figsize=(8,6))
    dirname, filename = os.path.split(plot_path)
    cntry = filename.split('.')[0]
    df=meta[meta.srce_cntry==cntry]
    
    plot_data=world_geo.merge(df,left_on='WoS',right_on='cntry')
    plot_data=gp.GeoDataFrame(plot_data)
    fig,ax=funding.core.plot_worldmap(ax, fig, world_geo, plot_data, 'p','viridis_r',0.0,0.2)
    ax.margins(0)
    plt.savefig(plot_path,bbox_inches='tight')